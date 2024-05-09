1 // File: contracts/IAwooClaiming.sol
2 
3 
4 
5 pragma solidity 0.8.12;
6 
7 interface IAwooClaiming{
8     function overrideTokenAccrualBaseRate(address contractAddress, uint32 tokenId, uint256 newBaseRate) external;
9 }
10 // File: contracts/AwooModels.sol
11 
12 
13 
14 pragma solidity 0.8.12;
15 
16 struct AccrualDetails{
17     address ContractAddress;
18     uint256[] TokenIds;
19     uint256[] Accruals;
20     uint256 TotalAccrued;
21 }
22 
23 struct ClaimDetails{
24     address ContractAddress;
25     uint32[] TokenIds;
26 }
27 
28 struct SupportedContractDetails{
29     address ContractAddress;
30     uint256 BaseRate;
31     bool Active;
32 }
33 // File: contracts/IAwooClaimingV2.sol
34 
35 
36 
37 pragma solidity 0.8.12;
38 
39 
40 interface IAwooClaimingV2{
41     function overrideTokenAccrualBaseRate(address contractAddress, uint32 tokenId, uint256 newBaseRate) external;
42     function claim(address holder, ClaimDetails[] calldata requestedClaims) external;
43 }
44 // File: contracts/AddressChecksumStringUtil.sol
45 
46 
47 pragma solidity ^0.8.0;
48 
49 // Derived from https://ethereum.stackexchange.com/a/63953, no license specified
50 // Modified to remove unnecessary functionality and prepend the checksummed string address with "0x"
51 
52 /**
53  * @dev This contract provides a set of pure functions for computing the EIP-55
54  * checksum of an account in formats friendly to both off-chain and on-chain
55  * callers, as well as for checking if a given string hex representation of an
56  * address has a valid checksum. These helper functions could also be repurposed
57  * as a library that extends the `address` type.
58  */
59 contract AddressChecksumStringUtil {
60 
61     function toChecksumString(address account) internal pure returns (string memory asciiString) {
62         // convert the account argument from address to bytes.
63         bytes20 data = bytes20(account);
64 
65         // create an in-memory fixed-size bytes array.
66         bytes memory asciiBytes = new bytes(40);
67 
68         // declare variable types.
69         uint8 b;
70         uint8 leftNibble;
71         uint8 rightNibble;
72         bool leftCaps;
73         bool rightCaps;
74         uint8 asciiOffset;
75 
76         // get the capitalized characters in the actual checksum.
77         bool[40] memory caps = _toChecksumCapsFlags(account);
78 
79         // iterate over bytes, processing left and right nibble in each iteration.
80         for (uint256 i = 0; i < data.length; i++) {
81             // locate the byte and extract each nibble.
82             b = uint8(uint160(data) / (2**(8*(19 - i))));
83             leftNibble = b / 16;
84             rightNibble = b - 16 * leftNibble;
85 
86             // locate and extract each capitalization status.
87             leftCaps = caps[2*i];
88             rightCaps = caps[2*i + 1];
89 
90             // get the offset from nibble value to ascii character for left nibble.
91             asciiOffset = _getAsciiOffset(leftNibble, leftCaps);
92 
93             // add the converted character to the byte array.
94             asciiBytes[2 * i] = bytes1(leftNibble + asciiOffset);
95 
96             // get the offset from nibble value to ascii character for right nibble.
97             asciiOffset = _getAsciiOffset(rightNibble, rightCaps);
98 
99             // add the converted character to the byte array.
100             asciiBytes[2 * i + 1] = bytes1(rightNibble + asciiOffset);
101         }
102 
103         return string(abi.encodePacked("0x", string(asciiBytes)));
104     }
105 
106     function _getAsciiOffset(uint8 nibble, bool caps) internal pure returns (uint8 offset) {
107         // to convert to ascii characters, add 48 to 0-9, 55 to A-F, & 87 to a-f.
108         if (nibble < 10) {
109             offset = 48;
110         } else if (caps) {
111             offset = 55;
112         } else {
113             offset = 87;
114         }
115     }
116 
117     function _toChecksumCapsFlags(address account) internal pure returns (bool[40] memory characterCapitalized) {
118         // convert the address to bytes.
119         bytes20 a = bytes20(account);
120 
121         // hash the address (used to calculate checksum).
122         bytes32 b = keccak256(abi.encodePacked(_toAsciiString(a)));
123 
124         // declare variable types.
125         uint8 leftNibbleAddress;
126         uint8 rightNibbleAddress;
127         uint8 leftNibbleHash;
128         uint8 rightNibbleHash;
129 
130         // iterate over bytes, processing left and right nibble in each iteration.
131         for (uint256 i; i < a.length; i++) {
132             // locate the byte and extract each nibble for the address and the hash.
133             rightNibbleAddress = uint8(a[i]) % 16;
134             leftNibbleAddress = (uint8(a[i]) - rightNibbleAddress) / 16;
135             rightNibbleHash = uint8(b[i]) % 16;
136             leftNibbleHash = (uint8(b[i]) - rightNibbleHash) / 16;
137 
138             characterCapitalized[2 * i] = (leftNibbleAddress > 9 && leftNibbleHash > 7);
139             characterCapitalized[2 * i + 1] = (rightNibbleAddress > 9 && rightNibbleHash > 7);
140         }
141     }
142 
143     // based on https://ethereum.stackexchange.com/a/56499/48410
144     function _toAsciiString(bytes20 data) internal pure returns (string memory asciiString) {
145         // create an in-memory fixed-size bytes array.
146         bytes memory asciiBytes = new bytes(40);
147 
148         // declare variable types.
149         uint8 b;
150         uint8 leftNibble;
151         uint8 rightNibble;
152 
153         // iterate over bytes, processing left and right nibble in each iteration.
154         for (uint256 i = 0; i < data.length; i++) {
155             // locate the byte and extract each nibble.
156             b = uint8(uint160(data) / (2 ** (8 * (19 - i))));
157             leftNibble = b / 16;
158             rightNibble = b - 16 * leftNibble;
159 
160             // to convert to ascii characters, add 48 to 0-9 and 87 to a-f.
161             asciiBytes[2 * i] = bytes1(leftNibble + (leftNibble < 10 ? 48 : 87));
162             asciiBytes[2 * i + 1] = bytes1(rightNibble + (rightNibble < 10 ? 48 : 87));
163         }
164 
165         return string(asciiBytes);
166     }
167 }
168 // File: @openzeppelin/contracts@4.4.1/utils/Strings.sol
169 
170 
171 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev String operations.
177  */
178 library Strings {
179     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
180 
181     /**
182      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
183      */
184     function toString(uint256 value) internal pure returns (string memory) {
185         // Inspired by OraclizeAPI's implementation - MIT licence
186         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
187 
188         if (value == 0) {
189             return "0";
190         }
191         uint256 temp = value;
192         uint256 digits;
193         while (temp != 0) {
194             digits++;
195             temp /= 10;
196         }
197         bytes memory buffer = new bytes(digits);
198         while (value != 0) {
199             digits -= 1;
200             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
201             value /= 10;
202         }
203         return string(buffer);
204     }
205 
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
208      */
209     function toHexString(uint256 value) internal pure returns (string memory) {
210         if (value == 0) {
211             return "0x00";
212         }
213         uint256 temp = value;
214         uint256 length = 0;
215         while (temp != 0) {
216             length++;
217             temp >>= 8;
218         }
219         return toHexString(value, length);
220     }
221 
222     /**
223      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
224      */
225     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
226         bytes memory buffer = new bytes(2 * length + 2);
227         buffer[0] = "0";
228         buffer[1] = "x";
229         for (uint256 i = 2 * length + 1; i > 1; --i) {
230             buffer[i] = _HEX_SYMBOLS[value & 0xf];
231             value >>= 4;
232         }
233         require(value == 0, "Strings: hex length insufficient");
234         return string(buffer);
235     }
236 }
237 
238 // File: @openzeppelin/contracts@4.4.1/utils/cryptography/ECDSA.sol
239 
240 
241 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 
246 /**
247  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
248  *
249  * These functions can be used to verify that a message was signed by the holder
250  * of the private keys of a given address.
251  */
252 library ECDSA {
253     enum RecoverError {
254         NoError,
255         InvalidSignature,
256         InvalidSignatureLength,
257         InvalidSignatureS,
258         InvalidSignatureV
259     }
260 
261     function _throwError(RecoverError error) private pure {
262         if (error == RecoverError.NoError) {
263             return; // no error: do nothing
264         } else if (error == RecoverError.InvalidSignature) {
265             revert("ECDSA: invalid signature");
266         } else if (error == RecoverError.InvalidSignatureLength) {
267             revert("ECDSA: invalid signature length");
268         } else if (error == RecoverError.InvalidSignatureS) {
269             revert("ECDSA: invalid signature 's' value");
270         } else if (error == RecoverError.InvalidSignatureV) {
271             revert("ECDSA: invalid signature 'v' value");
272         }
273     }
274 
275     /**
276      * @dev Returns the address that signed a hashed message (`hash`) with
277      * `signature` or error string. This address can then be used for verification purposes.
278      *
279      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
280      * this function rejects them by requiring the `s` value to be in the lower
281      * half order, and the `v` value to be either 27 or 28.
282      *
283      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
284      * verification to be secure: it is possible to craft signatures that
285      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
286      * this is by receiving a hash of the original message (which may otherwise
287      * be too long), and then calling {toEthSignedMessageHash} on it.
288      *
289      * Documentation for signature generation:
290      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
291      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
292      *
293      * _Available since v4.3._
294      */
295     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
296         // Check the signature length
297         // - case 65: r,s,v signature (standard)
298         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
299         if (signature.length == 65) {
300             bytes32 r;
301             bytes32 s;
302             uint8 v;
303             // ecrecover takes the signature parameters, and the only way to get them
304             // currently is to use assembly.
305             assembly {
306                 r := mload(add(signature, 0x20))
307                 s := mload(add(signature, 0x40))
308                 v := byte(0, mload(add(signature, 0x60)))
309             }
310             return tryRecover(hash, v, r, s);
311         } else if (signature.length == 64) {
312             bytes32 r;
313             bytes32 vs;
314             // ecrecover takes the signature parameters, and the only way to get them
315             // currently is to use assembly.
316             assembly {
317                 r := mload(add(signature, 0x20))
318                 vs := mload(add(signature, 0x40))
319             }
320             return tryRecover(hash, r, vs);
321         } else {
322             return (address(0), RecoverError.InvalidSignatureLength);
323         }
324     }
325 
326     /**
327      * @dev Returns the address that signed a hashed message (`hash`) with
328      * `signature`. This address can then be used for verification purposes.
329      *
330      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
331      * this function rejects them by requiring the `s` value to be in the lower
332      * half order, and the `v` value to be either 27 or 28.
333      *
334      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
335      * verification to be secure: it is possible to craft signatures that
336      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
337      * this is by receiving a hash of the original message (which may otherwise
338      * be too long), and then calling {toEthSignedMessageHash} on it.
339      */
340     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
341         (address recovered, RecoverError error) = tryRecover(hash, signature);
342         _throwError(error);
343         return recovered;
344     }
345 
346     /**
347      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
348      *
349      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
350      *
351      * _Available since v4.3._
352      */
353     function tryRecover(
354         bytes32 hash,
355         bytes32 r,
356         bytes32 vs
357     ) internal pure returns (address, RecoverError) {
358         bytes32 s;
359         uint8 v;
360         assembly {
361             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
362             v := add(shr(255, vs), 27)
363         }
364         return tryRecover(hash, v, r, s);
365     }
366 
367     /**
368      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
369      *
370      * _Available since v4.2._
371      */
372     function recover(
373         bytes32 hash,
374         bytes32 r,
375         bytes32 vs
376     ) internal pure returns (address) {
377         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
378         _throwError(error);
379         return recovered;
380     }
381 
382     /**
383      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
384      * `r` and `s` signature fields separately.
385      *
386      * _Available since v4.3._
387      */
388     function tryRecover(
389         bytes32 hash,
390         uint8 v,
391         bytes32 r,
392         bytes32 s
393     ) internal pure returns (address, RecoverError) {
394         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
395         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
396         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
397         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
398         //
399         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
400         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
401         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
402         // these malleable signatures as well.
403         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
404             return (address(0), RecoverError.InvalidSignatureS);
405         }
406         if (v != 27 && v != 28) {
407             return (address(0), RecoverError.InvalidSignatureV);
408         }
409 
410         // If the signature is valid (and not malleable), return the signer address
411         address signer = ecrecover(hash, v, r, s);
412         if (signer == address(0)) {
413             return (address(0), RecoverError.InvalidSignature);
414         }
415 
416         return (signer, RecoverError.NoError);
417     }
418 
419     /**
420      * @dev Overload of {ECDSA-recover} that receives the `v`,
421      * `r` and `s` signature fields separately.
422      */
423     function recover(
424         bytes32 hash,
425         uint8 v,
426         bytes32 r,
427         bytes32 s
428     ) internal pure returns (address) {
429         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
430         _throwError(error);
431         return recovered;
432     }
433 
434     /**
435      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
436      * produces hash corresponding to the one signed with the
437      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
438      * JSON-RPC method as part of EIP-191.
439      *
440      * See {recover}.
441      */
442     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
443         // 32 is the length in bytes of hash,
444         // enforced by the type signature above
445         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
446     }
447 
448     /**
449      * @dev Returns an Ethereum Signed Message, created from `s`. This
450      * produces hash corresponding to the one signed with the
451      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
452      * JSON-RPC method as part of EIP-191.
453      *
454      * See {recover}.
455      */
456     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
457         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
458     }
459 
460     /**
461      * @dev Returns an Ethereum Signed Typed Data, created from a
462      * `domainSeparator` and a `structHash`. This produces hash corresponding
463      * to the one signed with the
464      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
465      * JSON-RPC method as part of EIP-712.
466      *
467      * See {recover}.
468      */
469     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
470         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
471     }
472 }
473 
474 // File: @openzeppelin/contracts@4.4.1/token/ERC20/IERC20.sol
475 
476 
477 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @dev Interface of the ERC20 standard as defined in the EIP.
483  */
484 interface IERC20 {
485     /**
486      * @dev Returns the amount of tokens in existence.
487      */
488     function totalSupply() external view returns (uint256);
489 
490     /**
491      * @dev Returns the amount of tokens owned by `account`.
492      */
493     function balanceOf(address account) external view returns (uint256);
494 
495     /**
496      * @dev Moves `amount` tokens from the caller's account to `recipient`.
497      *
498      * Returns a boolean value indicating whether the operation succeeded.
499      *
500      * Emits a {Transfer} event.
501      */
502     function transfer(address recipient, uint256 amount) external returns (bool);
503 
504     /**
505      * @dev Returns the remaining number of tokens that `spender` will be
506      * allowed to spend on behalf of `owner` through {transferFrom}. This is
507      * zero by default.
508      *
509      * This value changes when {approve} or {transferFrom} are called.
510      */
511     function allowance(address owner, address spender) external view returns (uint256);
512 
513     /**
514      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
515      *
516      * Returns a boolean value indicating whether the operation succeeded.
517      *
518      * IMPORTANT: Beware that changing an allowance with this method brings the risk
519      * that someone may use both the old and the new allowance by unfortunate
520      * transaction ordering. One possible solution to mitigate this race
521      * condition is to first reduce the spender's allowance to 0 and set the
522      * desired value afterwards:
523      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
524      *
525      * Emits an {Approval} event.
526      */
527     function approve(address spender, uint256 amount) external returns (bool);
528 
529     /**
530      * @dev Moves `amount` tokens from `sender` to `recipient` using the
531      * allowance mechanism. `amount` is then deducted from the caller's
532      * allowance.
533      *
534      * Returns a boolean value indicating whether the operation succeeded.
535      *
536      * Emits a {Transfer} event.
537      */
538     function transferFrom(
539         address sender,
540         address recipient,
541         uint256 amount
542     ) external returns (bool);
543 
544     /**
545      * @dev Emitted when `value` tokens are moved from one account (`from`) to
546      * another (`to`).
547      *
548      * Note that `value` may be zero.
549      */
550     event Transfer(address indexed from, address indexed to, uint256 value);
551 
552     /**
553      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
554      * a call to {approve}. `value` is the new allowance.
555      */
556     event Approval(address indexed owner, address indexed spender, uint256 value);
557 }
558 
559 // File: contracts/IAwooToken.sol
560 
561 
562 
563 pragma solidity 0.8.12;
564 
565 
566 interface IAwooToken is IERC20 {
567     function increaseVirtualBalance(address account, uint256 amount) external;
568     function mint(address account, uint256 amount) external;
569     function balanceOfVirtual(address account) external view returns(uint256);
570     function spendVirtualAwoo(bytes32 hash, bytes memory sig, string calldata nonce, address account, uint256 amount) external;
571 }
572 // File: @openzeppelin/contracts@4.4.1/token/ERC20/extensions/IERC20Metadata.sol
573 
574 
575 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  * @dev Interface for the optional metadata functions from the ERC20 standard.
582  *
583  * _Available since v4.1._
584  */
585 interface IERC20Metadata is IERC20 {
586     /**
587      * @dev Returns the name of the token.
588      */
589     function name() external view returns (string memory);
590 
591     /**
592      * @dev Returns the symbol of the token.
593      */
594     function symbol() external view returns (string memory);
595 
596     /**
597      * @dev Returns the decimals places of the token.
598      */
599     function decimals() external view returns (uint8);
600 }
601 
602 // File: @openzeppelin/contracts@4.4.1/security/ReentrancyGuard.sol
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev Contract module that helps prevent reentrant calls to a function.
611  *
612  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
613  * available, which can be applied to functions to make sure there are no nested
614  * (reentrant) calls to them.
615  *
616  * Note that because there is a single `nonReentrant` guard, functions marked as
617  * `nonReentrant` may not call one another. This can be worked around by making
618  * those functions `private`, and then adding `external` `nonReentrant` entry
619  * points to them.
620  *
621  * TIP: If you would like to learn more about reentrancy and alternative ways
622  * to protect against it, check out our blog post
623  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
624  */
625 abstract contract ReentrancyGuard {
626     // Booleans are more expensive than uint256 or any type that takes up a full
627     // word because each write operation emits an extra SLOAD to first read the
628     // slot's contents, replace the bits taken up by the boolean, and then write
629     // back. This is the compiler's defense against contract upgrades and
630     // pointer aliasing, and it cannot be disabled.
631 
632     // The values being non-zero value makes deployment a bit more expensive,
633     // but in exchange the refund on every call to nonReentrant will be lower in
634     // amount. Since refunds are capped to a percentage of the total
635     // transaction's gas, it is best to keep them low in cases like this one, to
636     // increase the likelihood of the full refund coming into effect.
637     uint256 private constant _NOT_ENTERED = 1;
638     uint256 private constant _ENTERED = 2;
639 
640     uint256 private _status;
641 
642     constructor() {
643         _status = _NOT_ENTERED;
644     }
645 
646     /**
647      * @dev Prevents a contract from calling itself, directly or indirectly.
648      * Calling a `nonReentrant` function from another `nonReentrant`
649      * function is not supported. It is possible to prevent this from happening
650      * by making the `nonReentrant` function external, and making it call a
651      * `private` function that does the actual work.
652      */
653     modifier nonReentrant() {
654         // On the first call to nonReentrant, _notEntered will be true
655         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
656 
657         // Any calls to nonReentrant after this point will fail
658         _status = _ENTERED;
659 
660         _;
661 
662         // By storing the original value once again, a refund is triggered (see
663         // https://eips.ethereum.org/EIPS/eip-2200)
664         _status = _NOT_ENTERED;
665     }
666 }
667 
668 // File: @openzeppelin/contracts@4.4.1/utils/Context.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @dev Provides information about the current execution context, including the
677  * sender of the transaction and its data. While these are generally available
678  * via msg.sender and msg.data, they should not be accessed in such a direct
679  * manner, since when dealing with meta-transactions the account sending and
680  * paying for execution may not be the actual sender (as far as an application
681  * is concerned).
682  *
683  * This contract is only required for intermediate, library-like contracts.
684  */
685 abstract contract Context {
686     function _msgSender() internal view virtual returns (address) {
687         return msg.sender;
688     }
689 
690     function _msgData() internal view virtual returns (bytes calldata) {
691         return msg.data;
692     }
693 }
694 
695 // File: @openzeppelin/contracts@4.4.1/access/Ownable.sol
696 
697 
698 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 /**
704  * @dev Contract module which provides a basic access control mechanism, where
705  * there is an account (an owner) that can be granted exclusive access to
706  * specific functions.
707  *
708  * By default, the owner account will be the one that deploys the contract. This
709  * can later be changed with {transferOwnership}.
710  *
711  * This module is used through inheritance. It will make available the modifier
712  * `onlyOwner`, which can be applied to your functions to restrict their use to
713  * the owner.
714  */
715 abstract contract Ownable is Context {
716     address private _owner;
717 
718     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
719 
720     /**
721      * @dev Initializes the contract setting the deployer as the initial owner.
722      */
723     constructor() {
724         _transferOwnership(_msgSender());
725     }
726 
727     /**
728      * @dev Returns the address of the current owner.
729      */
730     function owner() public view virtual returns (address) {
731         return _owner;
732     }
733 
734     /**
735      * @dev Throws if called by any account other than the owner.
736      */
737     modifier onlyOwner() {
738         require(owner() == _msgSender(), "Ownable: caller is not the owner");
739         _;
740     }
741 
742     /**
743      * @dev Leaves the contract without owner. It will not be possible to call
744      * `onlyOwner` functions anymore. Can only be called by the current owner.
745      *
746      * NOTE: Renouncing ownership will leave the contract without an owner,
747      * thereby removing any functionality that is only available to the owner.
748      */
749     function renounceOwnership() public virtual onlyOwner {
750         _transferOwnership(address(0));
751     }
752 
753     /**
754      * @dev Transfers ownership of the contract to a new account (`newOwner`).
755      * Can only be called by the current owner.
756      */
757     function transferOwnership(address newOwner) public virtual onlyOwner {
758         require(newOwner != address(0), "Ownable: new owner is the zero address");
759         _transferOwnership(newOwner);
760     }
761 
762     /**
763      * @dev Transfers ownership of the contract to a new account (`newOwner`).
764      * Internal function without access restriction.
765      */
766     function _transferOwnership(address newOwner) internal virtual {
767         address oldOwner = _owner;
768         _owner = newOwner;
769         emit OwnershipTransferred(oldOwner, newOwner);
770     }
771 }
772 
773 // File: contracts/OwnerAdminGuard.sol
774 
775 
776 
777 pragma solidity 0.8.12;
778 
779 
780 contract OwnerAdminGuard is Ownable {
781     address[2] private _admins;
782     bool private _adminsSet;
783 
784     /// @notice Allows the owner to specify two addresses allowed to administer this contract
785     /// @param admins A 2 item array of addresses
786     function setAdmins(address[2] calldata admins) public {
787         require(admins[0] != address(0) && admins[1] != address(0), "Invalid admin address");
788         _admins = admins;
789         _adminsSet = true;
790     }
791 
792     function _isOwnerOrAdmin(address addr) internal virtual view returns(bool){
793         return addr == owner() || (
794             _adminsSet && (
795                 addr == _admins[0] || addr == _admins[1]
796             )
797         );
798     }
799 
800     modifier onlyOwnerOrAdmin() {
801         require(_isOwnerOrAdmin(msg.sender), "Not an owner or admin");
802         _;
803     }
804 }
805 // File: contracts/AuthorizedCallerGuard.sol
806 
807 
808 
809 pragma solidity 0.8.12;
810 
811 
812 contract AuthorizedCallerGuard is OwnerAdminGuard {
813 
814     /// @dev Keeps track of which contracts are explicitly allowed to interact with certain super contract functionality
815     mapping(address => bool) public authorizedContracts;
816 
817     event AuthorizedContractAdded(address contractAddress, address addedBy);
818     event AuthorizedContractRemoved(address contractAddress, address removedBy);
819 
820     /// @notice Allows the owner or an admin to authorize another contract to override token accruals on an individual token level
821     /// @param contractAddress The authorized contract address
822     function addAuthorizedContract(address contractAddress) public onlyOwnerOrAdmin {
823         require(_isContract(contractAddress), "Invalid contractAddress");
824         authorizedContracts[contractAddress] = true;
825         emit AuthorizedContractAdded(contractAddress, _msgSender());
826     }
827 
828     /// @notice Allows the owner or an admin to remove an authorized contract
829     /// @param contractAddress The contract address which should have its authorization revoked
830     function removeAuthorizedContract(address contractAddress) public onlyOwnerOrAdmin {
831         authorizedContracts[contractAddress] = false;
832         emit AuthorizedContractRemoved(contractAddress, _msgSender());
833     }
834 
835     /// @dev Derived from @openzeppelin/contracts/utils/Address.sol
836     function _isContract(address account) internal virtual view returns (bool) {
837         if(account == address(0)) return false;
838         // This method relies on extcodesize, which returns 0 for contracts in
839         // construction, since the code is only stored at the end of the
840         // constructor execution.
841         uint256 size;
842         assembly {
843             size := extcodesize(account)
844         }
845         return size > 0;
846     }
847 
848     function _isAuthorizedContract(address addr) internal virtual view returns(bool){
849         return authorizedContracts[addr];
850     }
851 
852     modifier onlyAuthorizedCaller() {
853         require(_isOwnerOrAdmin(_msgSender()) || _isAuthorizedContract(_msgSender()), "Sender is not authorized");
854         _;
855     }
856 
857     modifier onlyAuthorizedContract() {
858         require(_isAuthorizedContract(_msgSender()), "Sender is not authorized");
859         _;
860     }
861 
862 }
863 // File: contracts/AwooClaiming.sol
864 
865 
866 
867 pragma solidity 0.8.12;
868 pragma experimental ABIEncoderV2;
869 
870 
871 
872 
873 
874 
875 
876 
877 interface ISupportedContract {
878     function tokensOfOwner(address owner) external view returns (uint256[] memory);
879     function balanceOf(address owner) external view returns (uint256);
880     function ownerOf(uint256 tokenId) external view returns (address);
881     function exists(uint256 tokenId) external view returns (bool);
882 }
883 
884 contract AwooClaiming is IAwooClaiming, Ownable, ReentrancyGuard {
885     uint256 public accrualStart = 1646006400; //2022-02-28 00:00 UTC
886 	uint256 public accrualEnd;
887 	
888     bool public claimingActive;
889 
890     /// @dev A collection of supported contracts. These are typically ERC-721, with the addition of the tokensOfOwner function.
891     /// @dev These contracts can be deactivated but cannot be re-activated.  Reactivating can be done by adding the same
892     /// contract through addSupportedContract
893     SupportedContractDetails[] public supportedContracts;
894 
895     /// @dev Keeps track of the last time a claim was made for each tokenId within the supported contract collection
896     mapping(address => mapping(uint256 => uint256)) public lastClaims;
897     /// @dev Allows the base accrual rates to be overridden on a per-tokenId level to support things like upgrades
898     mapping(address => mapping(uint256 => uint256)) public baseRateTokenOverrides;
899 
900     address[2] private _admins;    
901     bool private _adminsSet;
902     
903     IAwooToken private _awooContract;    
904 
905     /// @dev Base accrual rates are set a per-day rate so we change them to per-minute to allow for more frequent claiming
906     uint64 private _baseRateDivisor = 1440;
907 
908     /// @dev Faciliates the maintence and functionality related to supportedContracts
909     uint8 private _activeSupportedContractCount;     
910     mapping(address => uint8) private _supportedContractIds;
911     
912     /// @dev Keeps track of which contracts are explicitly allowed to override the base accrual rates
913     mapping(address => bool) private _authorizedContracts;
914 
915     event TokensClaimed(address indexed claimedBy, uint256 qty);
916     event ClaimingStatusChanged(bool newStatus, address changedBy);
917     event AuthorizedContractAdded(address contractAddress, address addedBy);
918     event AuthorizedContractRemoved(address contractAddress, address removedBy);
919 
920     constructor(uint256 accrualStartTimestamp) {
921         require(accrualStartTimestamp > 0, "Invalid accrualStartTimestamp");
922         accrualStart = accrualStartTimestamp;
923     }
924 
925     /// @notice Determines the amount of accrued virtual AWOO for the specified address, based on the
926     /// base accural rates for each supported contract and how long has elapsed (in minutes) since the
927     /// last claim was made for a give supported contract tokenId
928     /// @param owner The address of the owner/holder of tokens for a supported contract
929     /// @return A collection of accrued virtual AWOO and the tokens it was accrued on for each supported contract, and the total AWOO accrued
930     function getTotalAccruals(address owner) public view returns (AccrualDetails[] memory, uint256) {
931         // Initialize the array length based on the number of _active_ supported contracts
932         AccrualDetails[] memory totalAccruals = new AccrualDetails[](_activeSupportedContractCount);
933 
934         uint256 totalAccrued;
935         uint8 contractCount; // Helps us keep track of the index to use when setting the values for totalAccruals
936         for(uint8 i = 0; i < supportedContracts.length; i++) {
937             SupportedContractDetails memory contractDetails = supportedContracts[i];
938 
939             if(contractDetails.Active){
940                 contractCount++;
941                 
942                 // Get an array of tokenIds held by the owner for the supported contract
943                 uint256[] memory tokenIds = ISupportedContract(contractDetails.ContractAddress).tokensOfOwner(owner);
944                 uint256[] memory accruals = new uint256[](tokenIds.length);
945                 
946                 uint256 totalAccruedByContract;
947 
948                 for (uint16 x = 0; x < tokenIds.length; x++) {
949                     uint32 tokenId = uint32(tokenIds[x]);
950                     uint256 accrued = getContractTokenAccruals(contractDetails.ContractAddress, contractDetails.BaseRate, tokenId);
951 
952                     totalAccruedByContract+=accrued;
953                     totalAccrued+=accrued;
954 
955                     tokenIds[x] = tokenId;
956                     accruals[x] = accrued;
957                 }
958 
959                 AccrualDetails memory accrual = AccrualDetails(contractDetails.ContractAddress, tokenIds, accruals, totalAccruedByContract);
960 
961                 totalAccruals[contractCount-1] = accrual;
962             }
963         }
964         return (totalAccruals, totalAccrued);
965     }
966 
967     /// @notice Claims all virtual AWOO accrued by the message sender, assuming the sender holds any supported contracts tokenIds
968     function claimAll() external nonReentrant {
969         require(claimingActive, "Claiming is inactive");
970         require(isValidHolder(), "No supported tokens held");
971 
972         (AccrualDetails[] memory accruals, uint256 totalAccrued) = getTotalAccruals(_msgSender());
973         require(totalAccrued > 0, "No tokens have been accrued");
974         
975         for(uint8 i = 0; i < accruals.length; i++){
976             AccrualDetails memory accrual = accruals[i];
977 
978             if(accrual.TotalAccrued > 0){
979                 for(uint16 x = 0; x < accrual.TokenIds.length;x++){
980                     // Update the time that this token was last claimed
981                     lastClaims[accrual.ContractAddress][accrual.TokenIds[x]] = block.timestamp;
982                 }
983             }
984         }
985     
986         // A holder's virtual AWOO balance is stored in the $AWOO ERC-20 contract
987         _awooContract.increaseVirtualBalance(_msgSender(), totalAccrued);
988         emit TokensClaimed(_msgSender(), totalAccrued);
989     }
990 
991     /// @notice Claims the accrued virtual AWOO from the specified supported contract tokenIds
992     /// @param requestedClaims A collection of supported contract addresses and the specific tokenIds to claim from
993     function claim(ClaimDetails[] calldata requestedClaims) external nonReentrant {
994         require(claimingActive, "Claiming is inactive");
995         require(isValidHolder(), "No supported tokens held");
996 
997         uint256 totalClaimed;
998 
999         for(uint8 i = 0; i < requestedClaims.length; i++){
1000             ClaimDetails calldata requestedClaim = requestedClaims[i];
1001 
1002             uint8 contractId = _supportedContractIds[requestedClaim.ContractAddress];
1003             if(contractId == 0) revert("Unsupported contract");
1004 
1005             SupportedContractDetails memory contractDetails = supportedContracts[contractId-1];
1006             if(!contractDetails.Active) revert("Inactive contract");
1007 
1008             for(uint16 x = 0; x < requestedClaim.TokenIds.length; x++){
1009                 uint32 tokenId = requestedClaim.TokenIds[x];
1010 
1011                 address tokenOwner = ISupportedContract(address(contractDetails.ContractAddress)).ownerOf(tokenId);
1012                 if(tokenOwner != _msgSender()) revert("Invalid owner claim attempt");
1013 
1014                 uint256 claimableAmount = getContractTokenAccruals(contractDetails.ContractAddress, contractDetails.BaseRate, tokenId);
1015 
1016                 if(claimableAmount > 0){
1017                     totalClaimed+=claimableAmount;
1018 
1019                     // Update the time that this token was last claimed
1020                     lastClaims[contractDetails.ContractAddress][tokenId] = block.timestamp;
1021                 }
1022             }
1023         }
1024 
1025         if(totalClaimed > 0){
1026             _awooContract.increaseVirtualBalance(_msgSender(), totalClaimed);
1027             emit TokensClaimed(_msgSender(), totalClaimed);
1028         }
1029     }
1030 
1031     /// @dev Calculates the accrued amount of virtual AWOO for the specified supported contract and tokenId
1032     function getContractTokenAccruals(address contractAddress, uint256 contractBaseRate, uint32 tokenId) private view returns(uint256){
1033         uint256 lastClaimTime = lastClaims[contractAddress][tokenId];
1034         uint256 accruedUntil = accrualEnd == 0 || block.timestamp < accrualEnd 
1035             ? block.timestamp 
1036             : accrualEnd;
1037         
1038         uint256 baseRate = baseRateTokenOverrides[contractAddress][tokenId] > 0 
1039             ? baseRateTokenOverrides[contractAddress][tokenId] 
1040             : contractBaseRate;
1041 
1042         if (lastClaimTime > 0){
1043             return (baseRate*(accruedUntil-lastClaimTime))/60;
1044         } else {
1045              return (baseRate*(accruedUntil-accrualStart))/60;
1046         }
1047     }
1048 
1049     /// @notice Allows an authorized contract to increase the base accrual rate for particular NFTs
1050     /// when, for example, upgrades for that NFT were purchased
1051     /// @param contractAddress The address of the supported contract
1052     /// @param tokenId The id of the token from the supported contract whose base accrual rate will be updated
1053     /// @param newBaseRate The new accrual base rate
1054     function overrideTokenAccrualBaseRate(address contractAddress, uint32 tokenId, uint256 newBaseRate)
1055         external onlyAuthorizedContract isValidBaseRate(newBaseRate) {
1056             require(tokenId > 0, "Invalid tokenId");
1057 
1058             uint8 contractId = _supportedContractIds[contractAddress];
1059             require(contractId > 0, "Unsupported contract");
1060             require(supportedContracts[contractId-1].Active, "Inactive contract");
1061 
1062             baseRateTokenOverrides[contractAddress][tokenId] = (newBaseRate/_baseRateDivisor);
1063     }
1064 
1065     /// @notice Allows the owner or an admin to set a reference to the $AWOO ERC-20 contract
1066     /// @param awooToken An instance of IAwooToken
1067     function setAwooTokenContract(IAwooToken awooToken) external onlyOwnerOrAdmin {
1068         _awooContract = awooToken;
1069     }
1070 
1071     /// @notice Allows the owner or an admin to set the date and time at which virtual AWOO accruing will stop
1072     /// @notice This will only be used if absolutely necessary and any AWOO that accrued before the end date will still be claimable
1073     /// @param timestamp The Epoch time at which accrual should end
1074     function setAccrualEndTimestamp(uint256 timestamp) external onlyOwnerOrAdmin {
1075         accrualEnd = timestamp;
1076     }
1077 
1078     /// @notice Allows the owner or an admin to add a contract whose tokens are eligible to accrue virtual AWOO
1079     /// @param contractAddress The contract address of the collection (typically ERC-721, with the addition of the tokensOfOwner function)
1080     /// @param baseRate The base accrual rate in wei units
1081     function addSupportedContract(address contractAddress, uint256 baseRate) external onlyOwnerOrAdmin isValidBaseRate(baseRate) {
1082         require(isContract(contractAddress), "Invalid contractAddress");
1083         require(_supportedContractIds[contractAddress] == 0, "Contract already supported");
1084 
1085         supportedContracts.push(SupportedContractDetails(contractAddress, baseRate/_baseRateDivisor, true));
1086         _supportedContractIds[contractAddress] = uint8(supportedContracts.length);
1087         _activeSupportedContractCount++;
1088     }
1089 
1090     /// @notice Allows the owner or an admin to deactivate a supported contract so it no longer accrues virtual AWOO
1091     /// @param contractAddress The contract address that should be deactivated
1092     function deactivateSupportedContract(address contractAddress) external onlyOwnerOrAdmin {
1093         require(_supportedContractIds[contractAddress] > 0, "Unsupported contract");
1094 
1095         supportedContracts[_supportedContractIds[contractAddress]-1].Active = false;
1096         supportedContracts[_supportedContractIds[contractAddress]-1].BaseRate = 0;
1097         _supportedContractIds[contractAddress] = 0;
1098         _activeSupportedContractCount--;
1099     }
1100 
1101     /// @notice Allows the owner or an admin to authorize another contract to override token accruals on an individual token level
1102     /// @param contractAddress The authorized contract address
1103     function addAuthorizedContract(address contractAddress) external onlyOwnerOrAdmin {
1104         require(isContract(contractAddress), "Invalid contractAddress");
1105         _authorizedContracts[contractAddress] = true;
1106         emit AuthorizedContractAdded(contractAddress, _msgSender());
1107     }
1108 
1109     /// @notice Allows the owner or an admin to remove an authorized contract
1110     /// @param contractAddress The contract address which should have its authorization revoked
1111     function removeAuthorizedContract(address contractAddress) external onlyOwnerOrAdmin {
1112         _authorizedContracts[contractAddress] = false;
1113         emit AuthorizedContractRemoved(contractAddress, _msgSender());
1114     }
1115 
1116     /// @notice Allows the owner or an admin to set the base accrual rate for a support contract
1117     /// @param contractAddress The address of the supported contract
1118     /// @param baseRate The new base accrual rate in wei units
1119     function setBaseRate(address contractAddress, uint256 baseRate) external onlyOwnerOrAdmin isValidBaseRate(baseRate) {
1120         require(_supportedContractIds[contractAddress] > 0, "Unsupported contract");
1121         supportedContracts[_supportedContractIds[contractAddress]-1].BaseRate = baseRate/_baseRateDivisor;
1122     }
1123 
1124     /// @notice Allows the owner to specify two addresses allowed to administer this contract
1125     /// @param adminAddresses A 2 item array of addresses
1126     function setAdmins(address[2] calldata adminAddresses) external onlyOwner {
1127         require(adminAddresses[0] != address(0) && adminAddresses[1] != address(0), "Invalid admin address");
1128 
1129         _admins = adminAddresses;
1130         _adminsSet = true;
1131     }
1132 
1133     /// @notice Allows the owner or an admin to activate/deactivate claiming ability
1134     /// @param active The value specifiying whether or not claiming should be allowed
1135     function setClaimingActive(bool active) external onlyOwnerOrAdmin {
1136         claimingActive = active;
1137         emit ClaimingStatusChanged(active, _msgSender());
1138     }
1139 
1140     /// @dev Derived from @openzeppelin/contracts/utils/Address.sol
1141     function isContract(address account) private view returns (bool) {
1142         if(account == address(0)) return false;
1143         // This method relies on extcodesize, which returns 0 for contracts in
1144         // construction, since the code is only stored at the end of the
1145         // constructor execution.
1146         uint256 size;
1147         assembly {
1148             size := extcodesize(account)
1149         }
1150         return size > 0;
1151     }
1152 
1153     /// @notice Determines whether or not the caller holds tokens for any of the supported contracts
1154     function isValidHolder() private view returns(bool) {
1155         for(uint8 i = 0; i < supportedContracts.length; i++){
1156             SupportedContractDetails memory contractDetails = supportedContracts[i];
1157             if(contractDetails.Active){
1158                 if(ISupportedContract(contractDetails.ContractAddress).balanceOf(_msgSender()) > 0) {
1159                     return true; // No need to continue checking other collections if the holder has any of the supported tokens
1160                 } 
1161             }
1162         }
1163         return false;
1164     }
1165 
1166     modifier onlyAuthorizedContract() {
1167         require(_authorizedContracts[_msgSender()], "Sender is not authorized");
1168         _;
1169     }
1170 
1171     modifier onlyOwnerOrAdmin() {
1172         require(
1173             _msgSender() == owner() || (
1174                 _adminsSet && (
1175                     _msgSender() == _admins[0] || _msgSender() == _admins[1]
1176                 )
1177             ), "Not an owner or admin");
1178         _;
1179     }
1180 
1181     /// @dev To minimize the amount of unit conversion we have to do for comparing $AWOO (ERC-20) to virtual AWOO, we store
1182     /// virtual AWOO with 18 implied decimal places, so this modifier prevents us from accidentally using the wrong unit
1183     /// for base rates.  For example, if holders of FangGang NFTs accrue at a rate of 1000 AWOO per fang, pre day, then
1184     /// the base rate should be 1000000000000000000000
1185     modifier isValidBaseRate(uint256 baseRate) {
1186         require(baseRate >= 1 ether, "Base rate must be in wei units");
1187         _;
1188     }
1189 }
1190 // File: @openzeppelin/contracts@4.4.1/token/ERC20/ERC20.sol
1191 
1192 
1193 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
1194 
1195 pragma solidity ^0.8.0;
1196 
1197 
1198 
1199 
1200 /**
1201  * @dev Implementation of the {IERC20} interface.
1202  *
1203  * This implementation is agnostic to the way tokens are created. This means
1204  * that a supply mechanism has to be added in a derived contract using {_mint}.
1205  * For a generic mechanism see {ERC20PresetMinterPauser}.
1206  *
1207  * TIP: For a detailed writeup see our guide
1208  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1209  * to implement supply mechanisms].
1210  *
1211  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1212  * instead returning `false` on failure. This behavior is nonetheless
1213  * conventional and does not conflict with the expectations of ERC20
1214  * applications.
1215  *
1216  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1217  * This allows applications to reconstruct the allowance for all accounts just
1218  * by listening to said events. Other implementations of the EIP may not emit
1219  * these events, as it isn't required by the specification.
1220  *
1221  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1222  * functions have been added to mitigate the well-known issues around setting
1223  * allowances. See {IERC20-approve}.
1224  */
1225 contract ERC20 is Context, IERC20, IERC20Metadata {
1226     mapping(address => uint256) private _balances;
1227 
1228     mapping(address => mapping(address => uint256)) private _allowances;
1229 
1230     uint256 private _totalSupply;
1231 
1232     string private _name;
1233     string private _symbol;
1234 
1235     /**
1236      * @dev Sets the values for {name} and {symbol}.
1237      *
1238      * The default value of {decimals} is 18. To select a different value for
1239      * {decimals} you should overload it.
1240      *
1241      * All two of these values are immutable: they can only be set once during
1242      * construction.
1243      */
1244     constructor(string memory name_, string memory symbol_) {
1245         _name = name_;
1246         _symbol = symbol_;
1247     }
1248 
1249     /**
1250      * @dev Returns the name of the token.
1251      */
1252     function name() public view virtual override returns (string memory) {
1253         return _name;
1254     }
1255 
1256     /**
1257      * @dev Returns the symbol of the token, usually a shorter version of the
1258      * name.
1259      */
1260     function symbol() public view virtual override returns (string memory) {
1261         return _symbol;
1262     }
1263 
1264     /**
1265      * @dev Returns the number of decimals used to get its user representation.
1266      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1267      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1268      *
1269      * Tokens usually opt for a value of 18, imitating the relationship between
1270      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1271      * overridden;
1272      *
1273      * NOTE: This information is only used for _display_ purposes: it in
1274      * no way affects any of the arithmetic of the contract, including
1275      * {IERC20-balanceOf} and {IERC20-transfer}.
1276      */
1277     function decimals() public view virtual override returns (uint8) {
1278         return 18;
1279     }
1280 
1281     /**
1282      * @dev See {IERC20-totalSupply}.
1283      */
1284     function totalSupply() public view virtual override returns (uint256) {
1285         return _totalSupply;
1286     }
1287 
1288     /**
1289      * @dev See {IERC20-balanceOf}.
1290      */
1291     function balanceOf(address account) public view virtual override returns (uint256) {
1292         return _balances[account];
1293     }
1294 
1295     /**
1296      * @dev See {IERC20-transfer}.
1297      *
1298      * Requirements:
1299      *
1300      * - `recipient` cannot be the zero address.
1301      * - the caller must have a balance of at least `amount`.
1302      */
1303     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1304         _transfer(_msgSender(), recipient, amount);
1305         return true;
1306     }
1307 
1308     /**
1309      * @dev See {IERC20-allowance}.
1310      */
1311     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1312         return _allowances[owner][spender];
1313     }
1314 
1315     /**
1316      * @dev See {IERC20-approve}.
1317      *
1318      * Requirements:
1319      *
1320      * - `spender` cannot be the zero address.
1321      */
1322     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1323         _approve(_msgSender(), spender, amount);
1324         return true;
1325     }
1326 
1327     /**
1328      * @dev See {IERC20-transferFrom}.
1329      *
1330      * Emits an {Approval} event indicating the updated allowance. This is not
1331      * required by the EIP. See the note at the beginning of {ERC20}.
1332      *
1333      * Requirements:
1334      *
1335      * - `sender` and `recipient` cannot be the zero address.
1336      * - `sender` must have a balance of at least `amount`.
1337      * - the caller must have allowance for ``sender``'s tokens of at least
1338      * `amount`.
1339      */
1340     function transferFrom(
1341         address sender,
1342         address recipient,
1343         uint256 amount
1344     ) public virtual override returns (bool) {
1345         _transfer(sender, recipient, amount);
1346 
1347         uint256 currentAllowance = _allowances[sender][_msgSender()];
1348         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1349         unchecked {
1350             _approve(sender, _msgSender(), currentAllowance - amount);
1351         }
1352 
1353         return true;
1354     }
1355 
1356     /**
1357      * @dev Atomically increases the allowance granted to `spender` by the caller.
1358      *
1359      * This is an alternative to {approve} that can be used as a mitigation for
1360      * problems described in {IERC20-approve}.
1361      *
1362      * Emits an {Approval} event indicating the updated allowance.
1363      *
1364      * Requirements:
1365      *
1366      * - `spender` cannot be the zero address.
1367      */
1368     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1369         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1370         return true;
1371     }
1372 
1373     /**
1374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1375      *
1376      * This is an alternative to {approve} that can be used as a mitigation for
1377      * problems described in {IERC20-approve}.
1378      *
1379      * Emits an {Approval} event indicating the updated allowance.
1380      *
1381      * Requirements:
1382      *
1383      * - `spender` cannot be the zero address.
1384      * - `spender` must have allowance for the caller of at least
1385      * `subtractedValue`.
1386      */
1387     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1388         uint256 currentAllowance = _allowances[_msgSender()][spender];
1389         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1390         unchecked {
1391             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1392         }
1393 
1394         return true;
1395     }
1396 
1397     /**
1398      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1399      *
1400      * This internal function is equivalent to {transfer}, and can be used to
1401      * e.g. implement automatic token fees, slashing mechanisms, etc.
1402      *
1403      * Emits a {Transfer} event.
1404      *
1405      * Requirements:
1406      *
1407      * - `sender` cannot be the zero address.
1408      * - `recipient` cannot be the zero address.
1409      * - `sender` must have a balance of at least `amount`.
1410      */
1411     function _transfer(
1412         address sender,
1413         address recipient,
1414         uint256 amount
1415     ) internal virtual {
1416         require(sender != address(0), "ERC20: transfer from the zero address");
1417         require(recipient != address(0), "ERC20: transfer to the zero address");
1418 
1419         _beforeTokenTransfer(sender, recipient, amount);
1420 
1421         uint256 senderBalance = _balances[sender];
1422         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1423         unchecked {
1424             _balances[sender] = senderBalance - amount;
1425         }
1426         _balances[recipient] += amount;
1427 
1428         emit Transfer(sender, recipient, amount);
1429 
1430         _afterTokenTransfer(sender, recipient, amount);
1431     }
1432 
1433     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1434      * the total supply.
1435      *
1436      * Emits a {Transfer} event with `from` set to the zero address.
1437      *
1438      * Requirements:
1439      *
1440      * - `account` cannot be the zero address.
1441      */
1442     function _mint(address account, uint256 amount) internal virtual {
1443         require(account != address(0), "ERC20: mint to the zero address");
1444 
1445         _beforeTokenTransfer(address(0), account, amount);
1446 
1447         _totalSupply += amount;
1448         _balances[account] += amount;
1449         emit Transfer(address(0), account, amount);
1450 
1451         _afterTokenTransfer(address(0), account, amount);
1452     }
1453 
1454     /**
1455      * @dev Destroys `amount` tokens from `account`, reducing the
1456      * total supply.
1457      *
1458      * Emits a {Transfer} event with `to` set to the zero address.
1459      *
1460      * Requirements:
1461      *
1462      * - `account` cannot be the zero address.
1463      * - `account` must have at least `amount` tokens.
1464      */
1465     function _burn(address account, uint256 amount) internal virtual {
1466         require(account != address(0), "ERC20: burn from the zero address");
1467 
1468         _beforeTokenTransfer(account, address(0), amount);
1469 
1470         uint256 accountBalance = _balances[account];
1471         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1472         unchecked {
1473             _balances[account] = accountBalance - amount;
1474         }
1475         _totalSupply -= amount;
1476 
1477         emit Transfer(account, address(0), amount);
1478 
1479         _afterTokenTransfer(account, address(0), amount);
1480     }
1481 
1482     /**
1483      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1484      *
1485      * This internal function is equivalent to `approve`, and can be used to
1486      * e.g. set automatic allowances for certain subsystems, etc.
1487      *
1488      * Emits an {Approval} event.
1489      *
1490      * Requirements:
1491      *
1492      * - `owner` cannot be the zero address.
1493      * - `spender` cannot be the zero address.
1494      */
1495     function _approve(
1496         address owner,
1497         address spender,
1498         uint256 amount
1499     ) internal virtual {
1500         require(owner != address(0), "ERC20: approve from the zero address");
1501         require(spender != address(0), "ERC20: approve to the zero address");
1502 
1503         _allowances[owner][spender] = amount;
1504         emit Approval(owner, spender, amount);
1505     }
1506 
1507     /**
1508      * @dev Hook that is called before any transfer of tokens. This includes
1509      * minting and burning.
1510      *
1511      * Calling conditions:
1512      *
1513      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1514      * will be transferred to `to`.
1515      * - when `from` is zero, `amount` tokens will be minted for `to`.
1516      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1517      * - `from` and `to` are never both zero.
1518      *
1519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1520      */
1521     function _beforeTokenTransfer(
1522         address from,
1523         address to,
1524         uint256 amount
1525     ) internal virtual {}
1526 
1527     /**
1528      * @dev Hook that is called after any transfer of tokens. This includes
1529      * minting and burning.
1530      *
1531      * Calling conditions:
1532      *
1533      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1534      * has been transferred to `to`.
1535      * - when `from` is zero, `amount` tokens have been minted for `to`.
1536      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1537      * - `from` and `to` are never both zero.
1538      *
1539      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1540      */
1541     function _afterTokenTransfer(
1542         address from,
1543         address to,
1544         uint256 amount
1545     ) internal virtual {}
1546 }
1547 
1548 // File: contracts/AwooToken.sol
1549 
1550 
1551 
1552 pragma solidity 0.8.12;
1553 
1554 
1555 
1556 
1557 
1558 
1559 
1560 
1561 
1562 contract AwooToken is IAwooToken, ERC20, ReentrancyGuard, Ownable, AddressChecksumStringUtil {
1563     using ECDSA for bytes32;
1564     using Strings for uint256;
1565 
1566     /// @dev Controls whether or not the deposit/withdraw functionality is enabled
1567     bool public isActive = true;
1568 
1569     /// @dev The percentage of spent virtual AWOO taken as a fee
1570     uint256 public awooFeePercentage = 10;
1571     /// @dev The Awoo Studios account where fees are sent
1572     address public awooStudiosAccount;
1573 
1574     address[2] private _admins;
1575     bool private _adminsSet;   
1576 
1577     /// @dev Keeps track of which contracts are explicitly allowed to add virtual AWOO to a holder's address, spend from it, or
1578     /// in the future, mint ERC-20 tokens
1579     mapping(address => bool) private _authorizedContracts;
1580     /// @dev Keeps track of each holders virtual AWOO balance
1581     mapping(address => uint256) private _virtualBalance;
1582     /// @dev Keeps track of nonces used for spending events to prevent double spends
1583     mapping(string => bool) private _usedNonces;
1584 
1585     event AuthorizedContractAdded(address contractAddress, address addedBy);
1586     event AuthorizedContractRemoved(address contractAddress, address removedBy);
1587     event VirtualAwooSpent(address spender, uint256 amount);
1588 
1589     constructor(address awooAccount) ERC20("Awoo Token", "AWOO") {
1590         require(awooAccount != address(0), "Invalid awooAccount");
1591         awooStudiosAccount = awooAccount;
1592     }
1593 
1594     /// @notice Allows an authorized contract to mint $AWOO
1595     /// @param account The account to receive the minted $AWOO tokens
1596     /// @param amount The amount of $AWOO to mint
1597     function mint(address account, uint256 amount) external nonReentrant onlyAuthorizedContract {
1598         require(account != address(0), "Cannot mint to the zero address");
1599         require(amount > 0, "Amount cannot be zero");
1600         _mint(account, amount);
1601     }
1602 
1603     /// @notice Allows the owner or an admin to add authorized contracts
1604     /// @param contractAddress The address of the contract to authorize
1605     function addAuthorizedContract(address contractAddress) external onlyOwnerOrAdmin {
1606         require(isContract(contractAddress), "Not a contract address");
1607         _authorizedContracts[contractAddress] = true;
1608         emit AuthorizedContractAdded(contractAddress, _msgSender());
1609     }
1610 
1611     /// @notice Allows the owner or an admin to remove authorized contracts
1612     /// @param contractAddress The address of the contract to revoke authorization for
1613     function removeAuthorizedContract(address contractAddress) external onlyOwnerOrAdmin {
1614         _authorizedContracts[contractAddress] = false;
1615         emit AuthorizedContractRemoved(contractAddress, _msgSender());
1616     }
1617 
1618     /// @notice Exchanges virtual AWOO for ERC-20 $AWOO
1619     /// @param amount The amount of virtual AWOO to withdraw
1620     function withdraw(uint256 amount) external whenActive hasBalance(amount, _virtualBalance[_msgSender()]) nonReentrant {
1621         _mint(_msgSender(), amount);
1622         _virtualBalance[_msgSender()] -= amount;
1623     }
1624 
1625     /// @notice Exchanges ERC-20 $AWOO for virtual AWOO to be used in the Awoo Studios ecosystem
1626     /// @param amount The amount of $AWOO to deposit
1627     function deposit(uint256 amount) external whenActive hasBalance(amount, balanceOf(_msgSender())) nonReentrant {
1628         _burn(_msgSender(), amount);
1629         _virtualBalance[_msgSender()] += amount;
1630     }
1631 
1632     /// @notice Returns the amount of virtual AWOO held by the specified address
1633     /// @param account The holder account to check
1634     function balanceOfVirtual(address account) external view returns(uint256) {
1635         return _virtualBalance[account];
1636     }
1637 
1638     /// @notice Returns the amount of ERC-20 $AWOO held by the specified address
1639     /// @param account The holder account to check
1640     function totalBalanceOf(address account) external view returns(uint256) {
1641         return _virtualBalance[account] + balanceOf(account);
1642     }
1643 
1644     /// @notice Allows authorized contracts to increase a holders virtual AWOO
1645     /// @param account The account to increase
1646     /// @param amount The amount of virtual AWOO to increase the account by
1647     function increaseVirtualBalance(address account, uint256 amount) external onlyAuthorizedContract {
1648         _virtualBalance[account] += amount;
1649     }
1650 
1651     /// @notice Allows authorized contracts to faciliate the spending of virtual AWOO, and fees to be paid to
1652     /// Awoo Studios.
1653     /// @notice Only amounts that have been signed and verified by the token holder can be spent
1654     /// @param hash The hash of the message displayed to and signed by the holder
1655     /// @param sig The signature of the messages that was signed by the holder
1656     /// @param nonce The unique code used to prevent double spends
1657     /// @param account The account of the holder to debit
1658     /// @param amount The amount of virtual AWOO to debit
1659     function spendVirtualAwoo(bytes32 hash, bytes memory sig, string calldata nonce, address account, uint256 amount)
1660         external onlyAuthorizedContract hasBalance(amount, _virtualBalance[account]) nonReentrant {
1661             require(_usedNonces[nonce] == false, "Duplicate nonce");
1662             require(matchAddresSigner(account, hash, sig), "Message signer mismatch"); // Make sure that the spend request was authorized (signed) by the holder
1663             require(hashTransaction(account, amount) == hash, "Hash check failed"); // Make sure that only the amount authorized by the holder can be spent
1664         
1665             // debit the holder's virtual AWOO account
1666             _virtualBalance[account]-=amount;
1667 
1668             // Mint the spending fee to the Awoo Studios account
1669             _mint(awooStudiosAccount, ((amount * awooFeePercentage)/100));
1670 
1671             _usedNonces[nonce] = true;
1672 
1673             emit VirtualAwooSpent(account, amount);
1674     }
1675 
1676     /// @notice Allows the owner to specify two addresses allowed to administer this contract
1677     /// @param adminAddresses A 2 item array of addresses
1678     function setAdmins(address[2] calldata adminAddresses) external onlyOwner {
1679         require(adminAddresses[0] != address(0) && adminAddresses[1] != address(0), "Invalid admin address");
1680         _admins = adminAddresses;
1681         _adminsSet = true;
1682     }
1683 
1684     /// @notice Allows the owner or an admin to activate/deactivate deposit and withdraw functionality
1685     /// @notice This will only be used to disable functionality as a worst case scenario
1686     /// @param active The value specifiying whether or not deposits/withdraws should be allowed
1687     function setActiveState(bool active) external onlyOwnerOrAdmin {
1688         isActive = active;
1689     }
1690 
1691     /// @notice Allows the owner to change the account used for collecting spending fees
1692     /// @param awooAccount The new account
1693     function setAwooStudiosAccount(address awooAccount) external onlyOwner {
1694         require(awooAccount != address(0), "Invalid awooAccount");
1695         awooStudiosAccount = awooAccount;
1696     }
1697 
1698     /// @notice Allows the owner to change the spending fee percentage
1699     /// @param feePercentage The new fee percentage
1700     function setFeePercentage(uint256 feePercentage) external onlyOwner {
1701         awooFeePercentage = feePercentage; // We're intentionally allowing the fee percentage to be set to 0%, incase no fees need to be collected
1702     }
1703 
1704     /// @notice Allows the owner to withdraw any Ethereum that was accidentally sent to this contract
1705     function rescueEth() external onlyOwner {
1706         payable(owner()).transfer(address(this).balance);
1707     }
1708 
1709     /// @dev Derived from @openzeppelin/contracts/utils/Address.sol
1710     function isContract(address account) private view returns (bool) {
1711         // This method relies on extcodesize, which returns 0 for contracts in
1712         // construction, since the code is only stored at the end of the
1713         // constructor execution.
1714         uint256 size;
1715         assembly {
1716             size := extcodesize(account)
1717         }
1718         return size > 0;
1719     }
1720 
1721     /// @dev Validates the specified account against the account that signed the message
1722     function matchAddresSigner(address account, bytes32 hash, bytes memory signature) private pure returns (bool) {
1723         return account == hash.recover(signature);
1724     }
1725 
1726     /// @dev Hashes the message we expected the spender to sign so we can compare the hashes to ensure that the owner
1727     /// of the specified address signed the same message
1728     /// @dev fractional ether unit amounts aren't supported
1729     function hashTransaction(address sender, uint256 amount) private pure returns (bytes32) {
1730         require(amount == ((amount/1e18)*1e18), "Invalid amount");
1731         // Virtual $AWOO, much like the ERC-20 $AWOO is stored with 18 implied decimal places.
1732         // For user-friendliness, when prompting the user to sign the message, the amount is
1733         // _displayed_ without the implied decimals, but it is charged with the implied decimals,
1734         // so when validating the hash, we have to use the same value we displayed to the user.
1735         // This only affects the display value, nothing else
1736         amount = amount/1e18;
1737         
1738         string memory message = string(abi.encodePacked(
1739             "As the owner of Ethereum address\r\n",
1740             toChecksumString(sender),
1741             "\r\nI authorize the spending of ",
1742             amount.toString()," virtual $AWOO"
1743         ));
1744         uint256 messageLength = bytes(message).length;
1745 
1746         bytes32 hash = keccak256(
1747             abi.encodePacked(
1748                 "\x19Ethereum Signed Message:\n",messageLength.toString(),
1749                 message
1750             )
1751         );
1752         return hash;
1753     }
1754     
1755     modifier onlyAuthorizedContract() {
1756         require(_authorizedContracts[_msgSender()], "Sender is not authorized");
1757         _;
1758     }
1759 
1760     modifier whenActive() {
1761         require(isActive, "Contract is not active");
1762         _;
1763     }
1764 
1765     modifier hasBalance(uint256 amount, uint256 balance) {
1766         require(amount > 0, "Amount cannot be zero");
1767         require(balance >= amount, "Insufficient Balance");
1768         _;
1769     }
1770 
1771     modifier onlyOwnerOrAdmin() {
1772         require(
1773             _msgSender() == owner() ||
1774                 (_adminsSet &&
1775                     (_msgSender() == _admins[0] || _msgSender() == _admins[1])),
1776             "Caller is not the owner or an admin"
1777         );
1778         _;
1779     }
1780 }
1781 // File: contracts/AwooClaimingV2.sol
1782 
1783 
1784 
1785 pragma solidity 0.8.12;
1786 
1787 
1788 
1789 
1790 
1791 
1792 
1793 contract AwooClaimingV2 is IAwooClaimingV2, AuthorizedCallerGuard, ReentrancyGuard {
1794     uint256 public accrualStart;
1795 	uint256 public accrualEnd;
1796 	
1797     bool public claimingActive;
1798 
1799     /// @dev A collection of supported contracts. These are typically ERC-721, with the addition of the tokensOfOwner function.
1800     /// @dev These contracts can be deactivated but cannot be re-activated.  Reactivating can be done by adding the same
1801     /// contract through addSupportedContract
1802     SupportedContractDetails[] public supportedContracts;
1803 
1804     /// @dev Keeps track of the last time a claim was made for each tokenId within the supported contract collection
1805     mapping(address => mapping(uint256 => uint256)) public lastClaims;
1806     /// @dev Allows the base accrual rates to be overridden on a per-tokenId level to support things like upgrades
1807     mapping(address => mapping(uint256 => uint256)) public baseRateTokenOverrides;
1808 
1809     AwooClaiming public v1ClaimingContract;
1810     AwooToken public awooContract;
1811 
1812     /// @dev Base accrual rates are set a per-day rate so we change them to per-minute to allow for more frequent claiming
1813     uint64 private _baseRateDivisor = 1440;
1814 
1815     /// @dev Faciliates the maintence and functionality related to supportedContracts
1816     uint8 private _activeSupportedContractCount;     
1817     mapping(address => uint8) private _supportedContractIds;
1818     
1819     event TokensClaimed(address indexed claimedBy, uint256 qty);
1820     event ClaimingStatusChanged(bool newStatus, address changedBy);
1821 
1822     constructor(AwooClaiming v1Contract) {
1823         v1ClaimingContract = v1Contract;
1824         accrualStart = v1ClaimingContract.accrualStart();
1825     }
1826 
1827     /// @notice Sets the first version of the claiming contract, which has been replaced with this one
1828     /// @param v1Contract A reference to the v1 claiming contract
1829     function setV1ClaimingContract(AwooClaiming v1Contract) external onlyOwnerOrAdmin {
1830         v1ClaimingContract = v1Contract;
1831         accrualStart = v1ClaimingContract.accrualStart();
1832     }
1833 
1834     /// @notice Determines the amount of accrued virtual AWOO for the specified address, based on the
1835     /// base accural rates for each supported contract and how long has elapsed (in minutes) since the
1836     /// last claim was made for a give supported contract tokenId
1837     /// @param owner The address of the owner/holder of tokens for a supported contract
1838     /// @return A collection of accrued virtual AWOO and the tokens it was accrued on for each supported contract, and the total AWOO accrued
1839     function getTotalAccruals(address owner) public view returns (AccrualDetails[] memory, uint256) {
1840         // Initialize the array length based on the number of _active_ supported contracts
1841         AccrualDetails[] memory totalAccruals = new AccrualDetails[](_activeSupportedContractCount);
1842 
1843         uint256 totalAccrued;
1844         uint8 contractCount; // Helps us keep track of the index to use when setting the values for totalAccruals
1845         for(uint8 i = 0; i < supportedContracts.length; i++) {
1846             SupportedContractDetails memory contractDetails = supportedContracts[i];
1847 
1848             if(contractDetails.Active){
1849                 contractCount++;
1850                 
1851                 // Get an array of tokenIds held by the owner for the supported contract
1852                 uint256[] memory tokenIds = ISupportedContract(contractDetails.ContractAddress).tokensOfOwner(owner);
1853                 uint256[] memory accruals = new uint256[](tokenIds.length);
1854                 
1855                 uint256 totalAccruedByContract;
1856 
1857                 for (uint16 x = 0; x < tokenIds.length; x++) {
1858                     uint32 tokenId = uint32(tokenIds[x]);
1859                     uint256 accrued = getContractTokenAccruals(contractDetails.ContractAddress, tokenId);
1860 
1861                     totalAccruedByContract+=accrued;
1862                     totalAccrued+=accrued;
1863 
1864                     tokenIds[x] = tokenId;
1865                     accruals[x] = accrued;
1866                 }
1867 
1868                 AccrualDetails memory accrual = AccrualDetails(contractDetails.ContractAddress, tokenIds, accruals, totalAccruedByContract);
1869 
1870                 totalAccruals[contractCount-1] = accrual;
1871             }
1872         }
1873         return (totalAccruals, totalAccrued);
1874     }
1875 
1876     /// @notice Claims all virtual AWOO accrued by the message sender, assuming the sender holds any supported contracts tokenIds
1877     function claimAll(address holder) external nonReentrant {
1878         require(claimingActive, "Claiming is inactive");
1879         require(_isAuthorizedContract(_msgSender()) || holder == _msgSender(), "Unauthorized claim attempt");
1880 
1881         (AccrualDetails[] memory accruals, uint256 totalAccrued) = getTotalAccruals(holder);
1882         require(totalAccrued > 0, "No tokens have been accrued");
1883         
1884         for(uint8 i = 0; i < accruals.length; i++){
1885             AccrualDetails memory accrual = accruals[i];
1886 
1887             if(accrual.TotalAccrued > 0){
1888                 for(uint16 x = 0; x < accrual.TokenIds.length;x++){
1889                     // Update the time that this token was last claimed
1890                     lastClaims[accrual.ContractAddress][accrual.TokenIds[x]] = block.timestamp;
1891                 }
1892             }
1893         }
1894     
1895         // A holder's virtual AWOO balance is stored in the $AWOO ERC-20 contract
1896         awooContract.increaseVirtualBalance(holder, totalAccrued);
1897         emit TokensClaimed(holder, totalAccrued);
1898     }
1899 
1900     /// @notice Claims the accrued virtual AWOO from the specified supported contract tokenIds
1901     /// @param requestedClaims A collection of supported contract addresses and the specific tokenIds to claim from
1902     function claim(address holder, ClaimDetails[] calldata requestedClaims) external nonReentrant {
1903         require(claimingActive, "Claiming is inactive");
1904         require(_isAuthorizedContract(_msgSender()) || holder == _msgSender(), "Unauthorized claim attempt");
1905 
1906         uint256 totalClaimed;
1907 
1908         for(uint8 i = 0; i < requestedClaims.length; i++){
1909             ClaimDetails calldata requestedClaim = requestedClaims[i];
1910 
1911             uint8 contractId = _supportedContractIds[requestedClaim.ContractAddress];
1912             if(contractId == 0) revert("Unsupported contract");
1913 
1914             SupportedContractDetails memory contractDetails = supportedContracts[contractId-1];
1915             if(!contractDetails.Active) revert("Inactive contract");
1916 
1917             for(uint16 x = 0; x < requestedClaim.TokenIds.length; x++){
1918                 uint32 tokenId = requestedClaim.TokenIds[x];
1919 
1920                 address tokenOwner = ISupportedContract(address(contractDetails.ContractAddress)).ownerOf(tokenId);
1921                 if(tokenOwner != holder) revert("Invalid owner claim attempt");
1922 
1923                 uint256 claimableAmount = getContractTokenAccruals(contractDetails.ContractAddress, tokenId);
1924 
1925                 if(claimableAmount > 0){
1926                     totalClaimed+=claimableAmount;
1927 
1928                     // Update the time that this token was last claimed
1929                     lastClaims[contractDetails.ContractAddress][tokenId] = block.timestamp;
1930                 }
1931             }
1932         }
1933 
1934         if(totalClaimed > 0){
1935             awooContract.increaseVirtualBalance(holder, totalClaimed);
1936             emit TokensClaimed(holder, totalClaimed);
1937         }
1938     }
1939 
1940     /// @notice Calculates the accrued amount of virtual AWOO for the specified supported contract and tokenId
1941     /// @dev To save gas, we don't validate the existence of the token within the specified collection as this is done
1942     /// within the claiming functions
1943     /// @dev The first time a claim is made in this contract, we use the v1 contract's last claim time so we don't
1944     /// accrue based on accruals that were claimed through the v1 contract
1945     /// @param contractAddress The contract address of the supported collection
1946     /// @param tokenId The id of the token/NFT
1947     /// @return The amount of virtual AWOO accrued for the specified token and collection
1948     function getContractTokenAccruals(address contractAddress, uint32 tokenId) public view returns(uint256){
1949         uint8 contractId = _supportedContractIds[contractAddress];
1950         if(contractId == 0) revert("Unsupported contract");
1951 
1952         SupportedContractDetails memory contractDetails = supportedContracts[contractId-1];
1953         if(!contractDetails.Active) revert("Inactive contract");
1954 
1955         uint256 lastClaimTime = lastClaims[contractAddress][tokenId] > 0
1956             ? lastClaims[contractAddress][tokenId]
1957             : v1ClaimingContract.lastClaims(contractAddress, tokenId);
1958 
1959         uint256 accruedUntil = accrualEnd == 0 || block.timestamp < accrualEnd 
1960             ? block.timestamp 
1961             : accrualEnd;
1962         
1963         uint256 baseRate = getContractTokenBaseAccrualRate(contractDetails, tokenId);
1964 
1965         if (lastClaimTime > 0){
1966             return (baseRate*(accruedUntil-lastClaimTime))/60;
1967         } else {
1968              return (baseRate*(accruedUntil-accrualStart))/60;
1969         }
1970     }
1971 
1972     /// @notice Returns the current base accrual rate for the specified token, taking overrides into account
1973     /// @dev This is mostly to support testing
1974     /// @param contractDetails The details of the supported contract
1975     /// @param tokenId The id of the token/NFT
1976     /// @return The base accrual rate
1977     function getContractTokenBaseAccrualRate(SupportedContractDetails memory contractDetails, uint32 tokenId
1978     ) public view returns(uint256){
1979         return baseRateTokenOverrides[contractDetails.ContractAddress][tokenId] > 0 
1980             ? baseRateTokenOverrides[contractDetails.ContractAddress][tokenId] 
1981             : contractDetails.BaseRate;
1982     }
1983 
1984     /// @notice Allows an authorized contract to increase the base accrual rate for particular NFTs
1985     /// when, for example, upgrades for that NFT were purchased
1986     /// @param contractAddress The address of the supported contract
1987     /// @param tokenId The id of the token from the supported contract whose base accrual rate will be updated
1988     /// @param newBaseRate The new accrual base rate
1989     function overrideTokenAccrualBaseRate(address contractAddress, uint32 tokenId, uint256 newBaseRate)
1990         external onlyAuthorizedContract isValidBaseRate(newBaseRate) {
1991             require(tokenId > 0, "Invalid tokenId");
1992 
1993             uint8 contractId = _supportedContractIds[contractAddress];
1994             require(contractId > 0, "Unsupported contract");
1995             require(supportedContracts[contractId-1].Active, "Inactive contract");
1996 
1997             baseRateTokenOverrides[contractAddress][tokenId] = (newBaseRate/_baseRateDivisor);
1998     }
1999 
2000     /// @notice Allows the owner or an admin to set a reference to the $AWOO ERC-20 contract
2001     /// @param awooToken An instance of IAwooToken
2002     function setAwooTokenContract(AwooToken awooToken) external onlyOwnerOrAdmin {
2003         awooContract = awooToken;
2004     }
2005 
2006     /// @notice Allows the owner or an admin to set the date and time at which virtual AWOO accruing will stop
2007     /// @notice This will only be used if absolutely necessary and any AWOO that accrued before the end date will still be claimable
2008     /// @param timestamp The Epoch time at which accrual should end
2009     function setAccrualEndTimestamp(uint256 timestamp) external onlyOwnerOrAdmin {
2010         accrualEnd = timestamp;
2011     }
2012 
2013     /// @notice Allows the owner or an admin to add a contract whose tokens are eligible to accrue virtual AWOO
2014     /// @param contractAddress The contract address of the collection (typically ERC-721, with the addition of the tokensOfOwner function)
2015     /// @param baseRate The base accrual rate in wei units
2016     function addSupportedContract(address contractAddress, uint256 baseRate) public onlyOwnerOrAdmin isValidBaseRate(baseRate) {
2017         require(_isContract(contractAddress), "Invalid contractAddress");
2018         require(_supportedContractIds[contractAddress] == 0, "Contract already supported");
2019 
2020         supportedContracts.push(SupportedContractDetails(contractAddress, baseRate/_baseRateDivisor, true));
2021         _supportedContractIds[contractAddress] = uint8(supportedContracts.length);
2022         _activeSupportedContractCount++;
2023     }
2024 
2025     /// @notice Allows the owner or an admin to deactivate a supported contract so it no longer accrues virtual AWOO
2026     /// @param contractAddress The contract address that should be deactivated
2027     function deactivateSupportedContract(address contractAddress) external onlyOwnerOrAdmin {
2028         require(_supportedContractIds[contractAddress] > 0, "Unsupported contract");
2029 
2030         supportedContracts[_supportedContractIds[contractAddress]-1].Active = false;
2031         supportedContracts[_supportedContractIds[contractAddress]-1].BaseRate = 0;
2032         _supportedContractIds[contractAddress] = 0;
2033         _activeSupportedContractCount--;
2034     }
2035 
2036     /// @notice Allows the owner or an admin to set the base accrual rate for a support contract
2037     /// @param contractAddress The address of the supported contract
2038     /// @param baseRate The new base accrual rate in wei units
2039     function setBaseRate(address contractAddress, uint256 baseRate) external onlyOwnerOrAdmin isValidBaseRate(baseRate) {
2040         require(_supportedContractIds[contractAddress] > 0, "Unsupported contract");
2041         supportedContracts[_supportedContractIds[contractAddress]-1].BaseRate = baseRate/_baseRateDivisor;
2042     }
2043 
2044     /// @notice Allows the owner or an admin to activate/deactivate claiming ability
2045     /// @param active The value specifiying whether or not claiming should be allowed
2046     function setClaimingActive(bool active) external onlyOwnerOrAdmin {
2047         claimingActive = active;
2048         emit ClaimingStatusChanged(active, _msgSender());
2049     }
2050 
2051     /// @dev To minimize the amount of unit conversion we have to do for comparing $AWOO (ERC-20) to virtual AWOO, we store
2052     /// virtual AWOO with 18 implied decimal places, so this modifier prevents us from accidentally using the wrong unit
2053     /// for base rates.  For example, if holders of FangGang NFTs accrue at a rate of 1000 AWOO per fang, pre day, then
2054     /// the base rate should be 1000000000000000000000
2055     modifier isValidBaseRate(uint256 baseRate) {
2056         require(baseRate >= 1 ether, "Base rate must be in wei units");
2057         _;
2058     }
2059 }
2060 // File: contracts/AwooClaimingV3.sol
2061 
2062 
2063 
2064 pragma solidity 0.8.12;
2065 
2066 
2067 
2068 
2069 
2070 
2071 
2072 contract AwooClaimingV3 is IAwooClaimingV2, AuthorizedCallerGuard, ReentrancyGuard {
2073     uint256 public accrualStart;
2074 	uint256 public accrualEnd;
2075 	
2076     bool public claimingActive = false;
2077 
2078     /// @dev A collection of supported contracts. These are typically ERC-721, with the addition of the tokensOfOwner function.
2079     /// @dev These contracts can be deactivated but cannot be re-activated.  Reactivating can be done by adding the same
2080     /// contract through addSupportedContract
2081     SupportedContractDetails[] public supportedContracts;
2082 
2083     /// @dev Keeps track of the last time a claim was made for each tokenId within the supported contract collection
2084     // contractAddress => (tokenId, lastClaimTimestamp)
2085     mapping(address => mapping(uint256 => uint48)) public lastClaims;
2086     /// @dev Allows the base accrual rates to be overridden on a per-tokenId level to support things like upgrades
2087     mapping(address => mapping(uint256 => uint256)) public baseRateTokenOverrides;
2088 
2089     // contractAddress => (tokenId, accruedAmount)
2090     mapping(address => mapping(uint256 => uint256)) public unclaimedSnapshot;
2091 
2092     AwooClaiming public v1ClaimingContract;
2093     AwooClaimingV2 public v2ClaimingContract;
2094     AwooToken public awooContract;
2095 
2096     /// @dev Base accrual rates are set a per-day rate so we change them to per-minute to allow for more frequent claiming
2097     uint64 private _baseRateDivisor = 1440;
2098 
2099     /// @dev Faciliates the maintence and functionality related to supportedContracts
2100     uint8 private _activeSupportedContractCount;     
2101     mapping(address => uint8) private _supportedContractIds;
2102     
2103     event TokensClaimed(address indexed claimedBy, uint256 qty);
2104     event ClaimingStatusChanged(bool newStatus, address changedBy);
2105 
2106     constructor(AwooToken awooTokenContract, AwooClaimingV2 v2Contract, AwooClaiming v1Contract) {
2107         awooContract = awooTokenContract;
2108         v2ClaimingContract = v2Contract;
2109         accrualStart = v2ClaimingContract.accrualStart();
2110         v1ClaimingContract = v1Contract;
2111     }
2112 
2113     /// @notice Sets the previous versions of the claiming contracts, which have been replaced with this one
2114     function setContracts(AwooClaimingV2 v2Contract, AwooClaiming v1Contract) external onlyOwnerOrAdmin {
2115         v2ClaimingContract = v2Contract;
2116         accrualStart = v2ClaimingContract.accrualStart();
2117         v1ClaimingContract = v1Contract;
2118     }
2119 
2120     /// @notice Determines the amount of accrued virtual AWOO for the specified address, based on the
2121     /// base accural rates for each supported contract and how long has elapsed (in minutes) since the
2122     /// last claim was made for a give supported contract tokenId
2123     /// @param owner The address of the owner/holder of tokens for a supported contract
2124     /// @return A collection of accrued virtual AWOO and the tokens it was accrued on for each supported contract, and the total AWOO accrued
2125     function getTotalAccruals(address owner) public view returns (AccrualDetails[] memory, uint256) {
2126         // Initialize the array length based on the number of _active_ supported contracts
2127         AccrualDetails[] memory totalAccruals = new AccrualDetails[](_activeSupportedContractCount);
2128 
2129         uint256 totalAccrued;
2130         uint8 contractCount; // Helps us keep track of the index to use when setting the values for totalAccruals
2131         for(uint8 i = 0; i < supportedContracts.length; i++) {
2132             SupportedContractDetails memory contractDetails = supportedContracts[i];
2133 
2134             if(contractDetails.Active){
2135                 contractCount++;
2136                 
2137                 // Get an array of tokenIds held by the owner for the supported contract
2138                 uint256[] memory tokenIds = ISupportedContract(contractDetails.ContractAddress).tokensOfOwner(owner);
2139                 uint256[] memory accruals = new uint256[](tokenIds.length);
2140                 
2141                 uint256 totalAccruedByContract;
2142 
2143                 for (uint16 x = 0; x < tokenIds.length; x++) {
2144                     uint256 tokenId = tokenIds[x];
2145                     uint256 accrued = getContractTokenAccruals(contractDetails.ContractAddress, tokenId);
2146 
2147                     totalAccruedByContract+=accrued;
2148                     totalAccrued+=accrued;
2149 
2150                     tokenIds[x] = tokenId;
2151                     accruals[x] = accrued;
2152                 }
2153 
2154                 AccrualDetails memory accrual = AccrualDetails(contractDetails.ContractAddress, tokenIds, accruals, totalAccruedByContract);
2155 
2156                 totalAccruals[contractCount-1] = accrual;
2157             }
2158         }
2159         return (totalAccruals, totalAccrued);
2160     }
2161 
2162     /// @notice Claims all virtual AWOO accrued by the message sender, assuming the sender holds any supported contracts tokenIds
2163     function claimAll(address holder) external nonReentrant {
2164         require(claimingActive, "Claiming is inactive");
2165         require(_isAuthorizedContract(_msgSender()) || holder == _msgSender(), "Unauthorized claim attempt");
2166 
2167         (AccrualDetails[] memory accruals, uint256 totalAccrued) = getTotalAccruals(holder);
2168         require(totalAccrued > 0, "No tokens have been accrued");
2169         
2170         for(uint8 i = 0; i < accruals.length; i++){
2171             AccrualDetails memory accrual = accruals[i];
2172 
2173             if(accrual.TotalAccrued > 0){
2174                 for(uint16 x = 0; x < accrual.TokenIds.length;x++){
2175                     // Update the time that this token was last claimed
2176                     lastClaims[accrual.ContractAddress][accrual.TokenIds[x]] = uint48(block.timestamp);
2177                     // Any amount from the unclaimed snapshot are now claimed because they were returned by getContractTokenAccruals
2178                     // so dump it
2179                     delete unclaimedSnapshot[accrual.ContractAddress][accrual.TokenIds[x]];
2180                 }
2181             }
2182         }
2183     
2184         // A holder's virtual AWOO balance is stored in the $AWOO ERC-20 contract
2185         awooContract.increaseVirtualBalance(holder, totalAccrued);
2186         emit TokensClaimed(holder, totalAccrued);
2187     }
2188 
2189     /// @notice Claims the accrued virtual AWOO from the specified supported contract tokenIds
2190     /// @param requestedClaims A collection of supported contract addresses and the specific tokenIds to claim from
2191     function claim(address holder, ClaimDetails[] calldata requestedClaims) external nonReentrant {
2192         require(claimingActive, "Claiming is inactive");
2193         require(_isAuthorizedContract(_msgSender()) || holder == _msgSender(), "Unauthorized claim attempt");
2194 
2195         uint256 totalClaimed;
2196 
2197         for(uint8 i = 0; i < requestedClaims.length; i++){
2198             ClaimDetails calldata requestedClaim = requestedClaims[i];
2199 
2200             uint8 contractId = _supportedContractIds[requestedClaim.ContractAddress];
2201             if(contractId == 0) revert("Unsupported contract");
2202 
2203             SupportedContractDetails memory contractDetails = supportedContracts[contractId-1];
2204             if(!contractDetails.Active) revert("Inactive contract");
2205 
2206             for(uint16 x = 0; x < requestedClaim.TokenIds.length; x++){
2207                 uint32 tokenId = requestedClaim.TokenIds[x];
2208 
2209                 address tokenOwner = ISupportedContract(address(contractDetails.ContractAddress)).ownerOf(tokenId);
2210                 if(tokenOwner != holder) revert("Invalid owner claim attempt");
2211 
2212                 uint256 claimableAmount = getContractTokenAccruals(contractDetails.ContractAddress, tokenId);
2213 
2214                 if(claimableAmount > 0){
2215                     totalClaimed+=claimableAmount;
2216 
2217                     // Update the time that this token was last claimed
2218                     lastClaims[contractDetails.ContractAddress][tokenId] = uint48(block.timestamp);
2219                     // Any amount from the unclaimed snapshot are now claimed because they were returned by getContractTokenAccruals
2220                     // so dump it
2221                     delete unclaimedSnapshot[contractDetails.ContractAddress][tokenId];
2222                 }
2223             }
2224         }
2225 
2226         if(totalClaimed > 0){
2227             awooContract.increaseVirtualBalance(holder, totalClaimed);
2228             emit TokensClaimed(holder, totalClaimed);
2229         }
2230     }
2231 
2232     /// @notice Calculates the accrued amount of virtual AWOO for the specified supported contract and tokenId
2233     /// @dev To save gas, we don't validate the existence of the token within the specified collection as this is done
2234     /// within the claiming functions
2235     /// @dev The first time a claim is made in this contract, we use the v1 contract's last claim time so we don't
2236     /// accrue based on accruals that were claimed through the v1 contract
2237     /// @param contractAddress The contract address of the supported collection
2238     /// @param tokenId The id of the token/NFT
2239     /// @return The amount of virtual AWOO accrued for the specified token and collection
2240     function getContractTokenAccruals(address contractAddress, uint256 tokenId) public view returns(uint256){
2241         uint8 contractId = _supportedContractIds[contractAddress];
2242         if(contractId == 0) revert("Unsupported contract");
2243 
2244         SupportedContractDetails memory contractDetails = supportedContracts[contractId-1];
2245         if(!contractDetails.Active) revert("Inactive contract");
2246 
2247         return getContractTokenAccruals(contractDetails, tokenId, uint48(block.timestamp));
2248     }
2249 
2250     /// @notice Calculates the accrued amount of virtual AWOO for the specified supported contract and tokenId, at the point in time specified
2251     /// @dev To save gas, we don't validate the existence of the token within the specified collection as this is done
2252     /// within the claiming functions
2253     /// @dev The first time a claim is made in this contract, we use the v1 contract's last claim time so we don't
2254     /// accrue based on accruals that were claimed through the v1 contract
2255     /// @param contractDetails The contract details of the supported collection
2256     /// @param tokenId The id of the token/NFT
2257     /// @param accruedUntilTimestamp The timestamp to calculate accruals from
2258     /// @return The amount of virtual AWOO accrued for the specified token and collection
2259     function getContractTokenAccruals(SupportedContractDetails memory contractDetails, 
2260         uint256 tokenId, uint48 accruedUntilTimestamp
2261     ) private view returns(uint256){
2262         uint48 lastClaimTime = getLastClaimTime(contractDetails.ContractAddress, tokenId);
2263 
2264         uint256 accruedUntil = accrualEnd == 0 || accruedUntilTimestamp < accrualEnd 
2265             ? accruedUntilTimestamp
2266             : accrualEnd;
2267         
2268         uint256 existingSnapshotAmount = unclaimedSnapshot[contractDetails.ContractAddress][tokenId];
2269         uint256 baseRate = getContractTokenBaseAccrualRate(contractDetails, tokenId);
2270 
2271         if (lastClaimTime > 0){
2272             return existingSnapshotAmount + ((baseRate*(accruedUntil-lastClaimTime))/60);
2273         } else {
2274             return existingSnapshotAmount + ((baseRate*(accruedUntil-accrualStart))/60);
2275         }
2276     }
2277 
2278     function getLastClaimTime(address contractAddress, uint256 tokenId) public view returns(uint48){
2279         uint48 lastClaim = lastClaims[contractAddress][tokenId];
2280         
2281         // If a claim has already been made through this contract, return the time of that claim
2282         if(lastClaim > 0) {
2283             return lastClaim;
2284         }
2285         
2286         // If not claims have been made through this contract, check V2
2287         lastClaim = uint48(v2ClaimingContract.lastClaims(contractAddress, tokenId));
2288         if(lastClaim > 0) {
2289             return lastClaim;
2290         }
2291 
2292         // If not claims have been made through the V2 contract, check the OG
2293         return uint48(v1ClaimingContract.lastClaims(contractAddress, tokenId));
2294     }
2295 
2296     /// @notice Returns the current base accrual rate for the specified token, taking overrides into account
2297     /// @dev This is mostly to support testing
2298     /// @param contractDetails The details of the supported contract
2299     /// @param tokenId The id of the token/NFT
2300     /// @return The base accrual rate
2301     function getContractTokenBaseAccrualRate(SupportedContractDetails memory contractDetails, uint256 tokenId
2302     ) public view returns(uint256){
2303         return baseRateTokenOverrides[contractDetails.ContractAddress][tokenId] > 0 
2304             ? baseRateTokenOverrides[contractDetails.ContractAddress][tokenId] 
2305             : contractDetails.BaseRate;
2306     }
2307 
2308     /// @notice Allows an authorized contract to increase the base accrual rate for particular NFTs
2309     /// when, for example, upgrades for that NFT were purchased
2310     /// @param contractAddress The address of the supported contract
2311     /// @param tokenId The id of the token from the supported contract whose base accrual rate will be updated
2312     /// @param newBaseRate The new accrual base rate
2313     function overrideTokenAccrualBaseRate(address contractAddress, uint32 tokenId, uint256 newBaseRate
2314     ) external onlyAuthorizedContract isValidBaseRate(newBaseRate) {
2315         require(tokenId > 0, "Invalid tokenId");
2316 
2317         uint8 contractId = _supportedContractIds[contractAddress];
2318         require(contractId > 0, "Unsupported contract");
2319         require(supportedContracts[contractId-1].Active, "Inactive contract");
2320 
2321         // Before overriding the accrual rate, take a snapshot of what the current unclaimed amount is
2322         // so that when `claim` or `claimAll` is called, the snapshot amount will be included so 
2323         // it doesn't get lost
2324         // @dev IMPORTANT: The snapshot must be taken _before_ baseRateTokenOverrides is set 
2325         unclaimedSnapshot[contractAddress][tokenId] = getContractTokenAccruals(contractAddress, tokenId);
2326         lastClaims[contractAddress][tokenId] = uint48(block.timestamp);
2327         baseRateTokenOverrides[contractAddress][tokenId] = (newBaseRate/_baseRateDivisor);
2328     }
2329 
2330     /// @notice Allows an authorized individual to manually create point-in-time snapshots of AWOO that
2331     /// was accrued up until a particular point in time.  This is only necessary to correct a bug in the
2332     /// V2 claiming contract that caused unclaimed AWOO to double when the base rates were overridden,
2333     /// rather than accruing with the new rate from that point in time
2334     function fixPreAccrualOverrideSnapshot(address contractAddress, uint256[] calldata tokenIds, 
2335         uint48[] calldata accruedUntilTimestamps
2336     ) external onlyOwnerOrAdmin {
2337         require(tokenIds.length == accruedUntilTimestamps.length, "Array length mismatch");
2338 
2339         uint8 contractId = _supportedContractIds[contractAddress];
2340         SupportedContractDetails memory contractDetails = supportedContracts[contractId-1];
2341 
2342         for(uint16 i; i < tokenIds.length; i++) {
2343             if(getLastClaimTime(contractAddress, tokenIds[i]) < accruedUntilTimestamps[i]) {
2344                 unclaimedSnapshot[contractAddress][tokenIds[i]] = getContractTokenAccruals(contractDetails, tokenIds[i], accruedUntilTimestamps[i]);
2345                 lastClaims[contractAddress][tokenIds[i]] = accruedUntilTimestamps[i];
2346             }
2347         }
2348     }
2349 
2350     /// @notice Allows the owner or an admin to set a reference to the $AWOO ERC-20 contract
2351     /// @param awooToken An instance of IAwooToken
2352     function setAwooTokenContract(AwooToken awooToken) external onlyOwnerOrAdmin {
2353         awooContract = awooToken;
2354     }
2355 
2356     /// @notice Allows the owner or an admin to set the date and time at which virtual AWOO accruing will stop
2357     /// @notice This will only be used if absolutely necessary and any AWOO that accrued before the end date will still be claimable
2358     /// @param timestamp The Epoch time at which accrual should end
2359     function setAccrualEndTimestamp(uint256 timestamp) external onlyOwnerOrAdmin {
2360         accrualEnd = timestamp;
2361     }
2362 
2363     /// @notice Allows the owner or an admin to add a contract whose tokens are eligible to accrue virtual AWOO
2364     /// @param contractAddress The contract address of the collection (typically ERC-721, with the addition of the tokensOfOwner function)
2365     /// @param baseRate The base accrual rate in wei units
2366     function addSupportedContract(address contractAddress, uint256 baseRate) public onlyOwnerOrAdmin isValidBaseRate(baseRate) {
2367         require(_isContract(contractAddress), "Invalid contractAddress");
2368         require(_supportedContractIds[contractAddress] == 0, "Contract already supported");
2369 
2370         supportedContracts.push(SupportedContractDetails(contractAddress, baseRate/_baseRateDivisor, true));
2371         _supportedContractIds[contractAddress] = uint8(supportedContracts.length);
2372         _activeSupportedContractCount++;
2373     }
2374 
2375     /// @notice Allows the owner or an admin to deactivate a supported contract so it no longer accrues virtual AWOO
2376     /// @param contractAddress The contract address that should be deactivated
2377     function deactivateSupportedContract(address contractAddress) external onlyOwnerOrAdmin {
2378         require(_supportedContractIds[contractAddress] > 0, "Unsupported contract");
2379 
2380         supportedContracts[_supportedContractIds[contractAddress]-1].Active = false;
2381         supportedContracts[_supportedContractIds[contractAddress]-1].BaseRate = 0;
2382         _supportedContractIds[contractAddress] = 0;
2383         _activeSupportedContractCount--;
2384     }
2385 
2386     /// @notice Allows the owner or an admin to set the base accrual rate for a support contract
2387     /// @param contractAddress The address of the supported contract
2388     /// @param baseRate The new base accrual rate in wei units
2389     function setBaseRate(address contractAddress, uint256 baseRate) external onlyOwnerOrAdmin isValidBaseRate(baseRate) {
2390         require(_supportedContractIds[contractAddress] > 0, "Unsupported contract");
2391         supportedContracts[_supportedContractIds[contractAddress]-1].BaseRate = baseRate/_baseRateDivisor;
2392     }
2393 
2394     /// @notice Allows the owner or an admin to activate/deactivate claiming ability
2395     /// @param active The value specifiying whether or not claiming should be allowed
2396     function setClaimingActive(bool active) external onlyOwnerOrAdmin {
2397         claimingActive = active;
2398         emit ClaimingStatusChanged(active, _msgSender());
2399     }
2400 
2401     /// @dev To minimize the amount of unit conversion we have to do for comparing $AWOO (ERC-20) to virtual AWOO, we store
2402     /// virtual AWOO with 18 implied decimal places, so this modifier prevents us from accidentally using the wrong unit
2403     /// for base rates.  For example, if holders of FangGang NFTs accrue at a rate of 1000 AWOO per fang, pre day, then
2404     /// the base rate should be 1000000000000000000000
2405     modifier isValidBaseRate(uint256 baseRate) {
2406         require(baseRate >= 1 ether, "Base rate must be in wei units");
2407         _;
2408     }
2409 }