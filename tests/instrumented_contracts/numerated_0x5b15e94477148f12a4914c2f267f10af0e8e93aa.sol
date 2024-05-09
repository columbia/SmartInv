1 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
2 // @@@@@@@@@@@@@@GB@@@@@@@@&@@@@@@@@@@@@@@@@&&#&@@@@@@@@@@&&##&&#BB&@@@@@@&&@@@@@@@##&&&&@@@@&7&@@@@@@@@@@@@@@@@@@@@&&###&##B#@@@@@@@@@&@@@@@@@
3 // @@@@@@@G@@@@@G.&@@@@#5YJJ&@@77?JJY5B@@@J^:.:..?@@@@@@@G^~!?..555B@@@@#7~:.Y@@@@@&J  ^P&@@B  &@@@@@@@@#~??JJ5P#@@@?^~7! !P55&@@@@#5YJJ&@@@@@@
4 // @@@@@@G^@@@@@?.@@@@^.&@@@@@& ^&####&@@@^B@@&P~ #@@@@@@@@@@@:Y@@@@@@@5.P?BB.^@@@@@@: B@@@@G .@@@@@@@@@Y P&####&@@@@@@@& @@@@@@@@~ #@@@@@@@@@@
5 // @@@@@P:!@@@@& ~@@@@~ !G@@@@&.^@@@@@@@@@^&@@@@5 &@@@@@@@@@@@ B@@@@@@5 Y!&@@& !@@@@& !@@@@@G ?@@@@@@@@@5 P@@@@@@@@@@@@@Y.@@@@@@@@! ~P@@@@@@@@@
6 // @@@@@Y.7@@@@~ Y@@@@@&5^.J@@@..?JP&@@@@@^&@@@@:!@@@@@@@@@@@# 5@@@@@@. ~Y@@@@^ @@@@G @@@@@@B B@@@@@@@@@P :JYG@@@@@@@@@@! @@@@@@@@@&5~.?@@@@@@@
7 // @@@@@# !@@&^. &@@@@@@@@&.!@@ .BB#@@@@@@:B@@#~J@@@@@@@@@@@@B Y@@@@@@? :J@@@B^.&@@@Y.@@@@@@B @@@@@@@@@@G ?BB&@@@@@@@@@@^ &@@@@@@@@@@@@:~@@@@@@
8 // @@@@@@7 &P..^G@@@@@@&&#Y.:@@ !@@@@@@@@@~.!:?&@@@@@@@@@@@@@# 5@@@@@@@P^.~7!JP!@@@@!^@@@@@@B G&######@@G #@@@@@@@@@@@@@! @@@@@@@@@&&#5..@@@@@@
9 // @@@@@@&.^^7P&@@@@@#5!~~!5@@@^7JJJY55G@@&GY&@@@@@@@@@@@@@@@@G@@@@@@@@@&??5GPY@@@BJ^!Y&@@@@J.!!77?JYP&@#:YJJY555&@@@@@@&G@@@@@@@#P!~~!5@@@@@@@
10 // @@@@@@@@@@@@@@@@@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&@@@@@@@@@@
11 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 
13 // File: @openzeppelin/contracts/utils/Context.sol
14 
15 // SPDX-License-Identifier: MIT
16 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 // File: @openzeppelin/contracts/access/Ownable.sol
41 
42 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         _checkOwner();
75         _;
76     }
77 
78     /**
79      * @dev Returns the address of the current owner.
80      */
81     function owner() public view virtual returns (address) {
82         return _owner;
83     }
84 
85     /**
86      * @dev Throws if the sender is not the owner.
87      */
88     function _checkOwner() internal view virtual {
89         require(owner() == _msgSender(), "Ownable: caller is not the owner");
90     }
91 
92     /**
93      * @dev Leaves the contract without owner. It will not be possible to call
94      * `onlyOwner` functions anymore. Can only be called by the current owner.
95      *
96      * NOTE: Renouncing ownership will leave the contract without an owner,
97      * thereby removing any functionality that is only available to the owner.
98      */
99     function renounceOwnership() public virtual onlyOwner {
100         _transferOwnership(address(0));
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Can only be called by the current owner.
106      */
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Internal function without access restriction.
115      */
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/Strings.sol
124 
125 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev String operations.
131  */
132 library Strings {
133     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
134     uint8 private constant _ADDRESS_LENGTH = 20;
135 
136     /**
137      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
138      */
139     function toString(uint256 value) internal pure returns (string memory) {
140         // Inspired by OraclizeAPI's implementation - MIT licence
141         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
142 
143         if (value == 0) {
144             return "0";
145         }
146         uint256 temp = value;
147         uint256 digits;
148         while (temp != 0) {
149             digits++;
150             temp /= 10;
151         }
152         bytes memory buffer = new bytes(digits);
153         while (value != 0) {
154             digits -= 1;
155             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
156             value /= 10;
157         }
158         return string(buffer);
159     }
160 
161     /**
162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
163      */
164     function toHexString(uint256 value) internal pure returns (string memory) {
165         if (value == 0) {
166             return "0x00";
167         }
168         uint256 temp = value;
169         uint256 length = 0;
170         while (temp != 0) {
171             length++;
172             temp >>= 8;
173         }
174         return toHexString(value, length);
175     }
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
179      */
180     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
181         bytes memory buffer = new bytes(2 * length + 2);
182         buffer[0] = "0";
183         buffer[1] = "x";
184         for (uint256 i = 2 * length + 1; i > 1; --i) {
185             buffer[i] = _HEX_SYMBOLS[value & 0xf];
186             value >>= 4;
187         }
188         require(value == 0, "Strings: hex length insufficient");
189         return string(buffer);
190     }
191 
192     /**
193      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
194      */
195     function toHexString(address addr) internal pure returns (string memory) {
196         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
201 
202 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 // CAUTION
207 // This version of SafeMath should only be used with Solidity 0.8 or later,
208 // because it relies on the compiler's built in overflow checks.
209 
210 /**
211  * @dev Wrappers over Solidity's arithmetic operations.
212  *
213  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
214  * now has built in overflow checking.
215  */
216 library SafeMath {
217     /**
218      * @dev Returns the addition of two unsigned integers, with an overflow flag.
219      *
220      * _Available since v3.4._
221      */
222     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
223         unchecked {
224             uint256 c = a + b;
225             if (c < a) return (false, 0);
226             return (true, c);
227         }
228     }
229 
230     /**
231      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
232      *
233      * _Available since v3.4._
234      */
235     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
236         unchecked {
237             if (b > a) return (false, 0);
238             return (true, a - b);
239         }
240     }
241 
242     /**
243      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
244      *
245      * _Available since v3.4._
246      */
247     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
248         unchecked {
249             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
250             // benefit is lost if 'b' is also tested.
251             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
252             if (a == 0) return (true, 0);
253             uint256 c = a * b;
254             if (c / a != b) return (false, 0);
255             return (true, c);
256         }
257     }
258 
259     /**
260      * @dev Returns the division of two unsigned integers, with a division by zero flag.
261      *
262      * _Available since v3.4._
263      */
264     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
265         unchecked {
266             if (b == 0) return (false, 0);
267             return (true, a / b);
268         }
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
273      *
274      * _Available since v3.4._
275      */
276     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             if (b == 0) return (false, 0);
279             return (true, a % b);
280         }
281     }
282 
283     /**
284      * @dev Returns the addition of two unsigned integers, reverting on
285      * overflow.
286      *
287      * Counterpart to Solidity's `+` operator.
288      *
289      * Requirements:
290      *
291      * - Addition cannot overflow.
292      */
293     function add(uint256 a, uint256 b) internal pure returns (uint256) {
294         return a + b;
295     }
296 
297     /**
298      * @dev Returns the subtraction of two unsigned integers, reverting on
299      * overflow (when the result is negative).
300      *
301      * Counterpart to Solidity's `-` operator.
302      *
303      * Requirements:
304      *
305      * - Subtraction cannot overflow.
306      */
307     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a - b;
309     }
310 
311     /**
312      * @dev Returns the multiplication of two unsigned integers, reverting on
313      * overflow.
314      *
315      * Counterpart to Solidity's `*` operator.
316      *
317      * Requirements:
318      *
319      * - Multiplication cannot overflow.
320      */
321     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a * b;
323     }
324 
325     /**
326      * @dev Returns the integer division of two unsigned integers, reverting on
327      * division by zero. The result is rounded towards zero.
328      *
329      * Counterpart to Solidity's `/` operator.
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function div(uint256 a, uint256 b) internal pure returns (uint256) {
336         return a / b;
337     }
338 
339     /**
340      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
341      * reverting when dividing by zero.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      *
349      * - The divisor cannot be zero.
350      */
351     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
352         return a % b;
353     }
354 
355     /**
356      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
357      * overflow (when the result is negative).
358      *
359      * CAUTION: This function is deprecated because it requires allocating memory for the error
360      * message unnecessarily. For custom revert reasons use {trySub}.
361      *
362      * Counterpart to Solidity's `-` operator.
363      *
364      * Requirements:
365      *
366      * - Subtraction cannot overflow.
367      */
368     function sub(
369         uint256 a,
370         uint256 b,
371         string memory errorMessage
372     ) internal pure returns (uint256) {
373         unchecked {
374             require(b <= a, errorMessage);
375             return a - b;
376         }
377     }
378 
379     /**
380      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
381      * division by zero. The result is rounded towards zero.
382      *
383      * Counterpart to Solidity's `/` operator. Note: this function uses a
384      * `revert` opcode (which leaves remaining gas untouched) while Solidity
385      * uses an invalid opcode to revert (consuming all remaining gas).
386      *
387      * Requirements:
388      *
389      * - The divisor cannot be zero.
390      */
391     function div(
392         uint256 a,
393         uint256 b,
394         string memory errorMessage
395     ) internal pure returns (uint256) {
396         unchecked {
397             require(b > 0, errorMessage);
398             return a / b;
399         }
400     }
401 
402     /**
403      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
404      * reverting with custom message when dividing by zero.
405      *
406      * CAUTION: This function is deprecated because it requires allocating memory for the error
407      * message unnecessarily. For custom revert reasons use {tryMod}.
408      *
409      * Counterpart to Solidity's `%` operator. This function uses a `revert`
410      * opcode (which leaves remaining gas untouched) while Solidity uses an
411      * invalid opcode to revert (consuming all remaining gas).
412      *
413      * Requirements:
414      *
415      * - The divisor cannot be zero.
416      */
417     function mod(
418         uint256 a,
419         uint256 b,
420         string memory errorMessage
421     ) internal pure returns (uint256) {
422         unchecked {
423             require(b > 0, errorMessage);
424             return a % b;
425         }
426     }
427 }
428 
429 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
430 
431 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
437  *
438  * These functions can be used to verify that a message was signed by the holder
439  * of the private keys of a given address.
440  */
441 library ECDSA {
442     enum RecoverError {
443         NoError,
444         InvalidSignature,
445         InvalidSignatureLength,
446         InvalidSignatureS,
447         InvalidSignatureV
448     }
449 
450     function _throwError(RecoverError error) private pure {
451         if (error == RecoverError.NoError) {
452             return; // no error: do nothing
453         } else if (error == RecoverError.InvalidSignature) {
454             revert("ECDSA: invalid signature");
455         } else if (error == RecoverError.InvalidSignatureLength) {
456             revert("ECDSA: invalid signature length");
457         } else if (error == RecoverError.InvalidSignatureS) {
458             revert("ECDSA: invalid signature 's' value");
459         } else if (error == RecoverError.InvalidSignatureV) {
460             revert("ECDSA: invalid signature 'v' value");
461         }
462     }
463 
464     /**
465      * @dev Returns the address that signed a hashed message (`hash`) with
466      * `signature` or error string. This address can then be used for verification purposes.
467      *
468      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
469      * this function rejects them by requiring the `s` value to be in the lower
470      * half order, and the `v` value to be either 27 or 28.
471      *
472      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
473      * verification to be secure: it is possible to craft signatures that
474      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
475      * this is by receiving a hash of the original message (which may otherwise
476      * be too long), and then calling {toEthSignedMessageHash} on it.
477      *
478      * Documentation for signature generation:
479      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
480      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
481      *
482      * _Available since v4.3._
483      */
484     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
485         if (signature.length == 65) {
486             bytes32 r;
487             bytes32 s;
488             uint8 v;
489             // ecrecover takes the signature parameters, and the only way to get them
490             // currently is to use assembly.
491             /// @solidity memory-safe-assembly
492             assembly {
493                 r := mload(add(signature, 0x20))
494                 s := mload(add(signature, 0x40))
495                 v := byte(0, mload(add(signature, 0x60)))
496             }
497             return tryRecover(hash, v, r, s);
498         } else {
499             return (address(0), RecoverError.InvalidSignatureLength);
500         }
501     }
502 
503     /**
504      * @dev Returns the address that signed a hashed message (`hash`) with
505      * `signature`. This address can then be used for verification purposes.
506      *
507      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
508      * this function rejects them by requiring the `s` value to be in the lower
509      * half order, and the `v` value to be either 27 or 28.
510      *
511      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
512      * verification to be secure: it is possible to craft signatures that
513      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
514      * this is by receiving a hash of the original message (which may otherwise
515      * be too long), and then calling {toEthSignedMessageHash} on it.
516      */
517     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
518         (address recovered, RecoverError error) = tryRecover(hash, signature);
519         _throwError(error);
520         return recovered;
521     }
522 
523     /**
524      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
525      *
526      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
527      *
528      * _Available since v4.3._
529      */
530     function tryRecover(
531         bytes32 hash,
532         bytes32 r,
533         bytes32 vs
534     ) internal pure returns (address, RecoverError) {
535         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
536         uint8 v = uint8((uint256(vs) >> 255) + 27);
537         return tryRecover(hash, v, r, s);
538     }
539 
540     /**
541      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
542      *
543      * _Available since v4.2._
544      */
545     function recover(
546         bytes32 hash,
547         bytes32 r,
548         bytes32 vs
549     ) internal pure returns (address) {
550         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
551         _throwError(error);
552         return recovered;
553     }
554 
555     /**
556      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
557      * `r` and `s` signature fields separately.
558      *
559      * _Available since v4.3._
560      */
561     function tryRecover(
562         bytes32 hash,
563         uint8 v,
564         bytes32 r,
565         bytes32 s
566     ) internal pure returns (address, RecoverError) {
567         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
568         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
569         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
570         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
571         //
572         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
573         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
574         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
575         // these malleable signatures as well.
576         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
577             return (address(0), RecoverError.InvalidSignatureS);
578         }
579         if (v != 27 && v != 28) {
580             return (address(0), RecoverError.InvalidSignatureV);
581         }
582 
583         // If the signature is valid (and not malleable), return the signer address
584         address signer = ecrecover(hash, v, r, s);
585         if (signer == address(0)) {
586             return (address(0), RecoverError.InvalidSignature);
587         }
588 
589         return (signer, RecoverError.NoError);
590     }
591 
592     /**
593      * @dev Overload of {ECDSA-recover} that receives the `v`,
594      * `r` and `s` signature fields separately.
595      */
596     function recover(
597         bytes32 hash,
598         uint8 v,
599         bytes32 r,
600         bytes32 s
601     ) internal pure returns (address) {
602         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
603         _throwError(error);
604         return recovered;
605     }
606 
607     /**
608      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
609      * produces hash corresponding to the one signed with the
610      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
611      * JSON-RPC method as part of EIP-191.
612      *
613      * See {recover}.
614      */
615     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
616         // 32 is the length in bytes of hash,
617         // enforced by the type signature above
618         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
619     }
620 
621     /**
622      * @dev Returns an Ethereum Signed Message, created from `s`. This
623      * produces hash corresponding to the one signed with the
624      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
625      * JSON-RPC method as part of EIP-191.
626      *
627      * See {recover}.
628      */
629     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
630         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
631     }
632 
633     /**
634      * @dev Returns an Ethereum Signed Typed Data, created from a
635      * `domainSeparator` and a `structHash`. This produces hash corresponding
636      * to the one signed with the
637      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
638      * JSON-RPC method as part of EIP-712.
639      *
640      * See {recover}.
641      */
642     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
643         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
644     }
645 }
646 
647 // File: erc721a/contracts/IERC721A.sol
648 
649 // ERC721A Contracts v4.2.2
650 // Creator: Chiru Labs
651 
652 pragma solidity ^0.8.4;
653 
654 /**
655  * @dev Interface of ERC721A.
656  */
657 interface IERC721A {
658     /**
659      * The caller must own the token or be an approved operator.
660      */
661     error ApprovalCallerNotOwnerNorApproved();
662 
663     /**
664      * The token does not exist.
665      */
666     error ApprovalQueryForNonexistentToken();
667 
668     /**
669      * The caller cannot approve to their own address.
670      */
671     error ApproveToCaller();
672 
673     /**
674      * Cannot query the balance for the zero address.
675      */
676     error BalanceQueryForZeroAddress();
677 
678     /**
679      * Cannot mint to the zero address.
680      */
681     error MintToZeroAddress();
682 
683     /**
684      * The quantity of tokens minted must be more than zero.
685      */
686     error MintZeroQuantity();
687 
688     /**
689      * The token does not exist.
690      */
691     error OwnerQueryForNonexistentToken();
692 
693     /**
694      * The caller must own the token or be an approved operator.
695      */
696     error TransferCallerNotOwnerNorApproved();
697 
698     /**
699      * The token must be owned by `from`.
700      */
701     error TransferFromIncorrectOwner();
702 
703     /**
704      * Cannot safely transfer to a contract that does not implement the
705      * ERC721Receiver interface.
706      */
707     error TransferToNonERC721ReceiverImplementer();
708 
709     /**
710      * Cannot transfer to the zero address.
711      */
712     error TransferToZeroAddress();
713 
714     /**
715      * The token does not exist.
716      */
717     error URIQueryForNonexistentToken();
718 
719     /**
720      * The `quantity` minted with ERC2309 exceeds the safety limit.
721      */
722     error MintERC2309QuantityExceedsLimit();
723 
724     /**
725      * The `extraData` cannot be set on an unintialized ownership slot.
726      */
727     error OwnershipNotInitializedForExtraData();
728 
729     // =============================================================
730     //                            STRUCTS
731     // =============================================================
732 
733     struct TokenOwnership {
734         // The address of the owner.
735         address addr;
736         // Stores the start time of ownership with minimal overhead for tokenomics.
737         uint64 startTimestamp;
738         // Whether the token has been burned.
739         bool burned;
740         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
741         uint24 extraData;
742     }
743 
744     // =============================================================
745     //                         TOKEN COUNTERS
746     // =============================================================
747 
748     /**
749      * @dev Returns the total number of tokens in existence.
750      * Burned tokens will reduce the count.
751      * To get the total number of tokens minted, please see {_totalMinted}.
752      */
753     function totalSupply() external view returns (uint256);
754 
755     // =============================================================
756     //                            IERC165
757     // =============================================================
758 
759     /**
760      * @dev Returns true if this contract implements the interface defined by
761      * `interfaceId`. See the corresponding
762      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
763      * to learn more about how these ids are created.
764      *
765      * This function call must use less than 30000 gas.
766      */
767     function supportsInterface(bytes4 interfaceId) external view returns (bool);
768 
769     // =============================================================
770     //                            IERC721
771     // =============================================================
772 
773     /**
774      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
775      */
776     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
777 
778     /**
779      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
780      */
781     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
782 
783     /**
784      * @dev Emitted when `owner` enables or disables
785      * (`approved`) `operator` to manage all of its assets.
786      */
787     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
788 
789     /**
790      * @dev Returns the number of tokens in `owner`'s account.
791      */
792     function balanceOf(address owner) external view returns (uint256 balance);
793 
794     /**
795      * @dev Returns the owner of the `tokenId` token.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must exist.
800      */
801     function ownerOf(uint256 tokenId) external view returns (address owner);
802 
803     /**
804      * @dev Safely transfers `tokenId` token from `from` to `to`,
805      * checking first that contract recipients are aware of the ERC721 protocol
806      * to prevent tokens from being forever locked.
807      *
808      * Requirements:
809      *
810      * - `from` cannot be the zero address.
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must exist and be owned by `from`.
813      * - If the caller is not `from`, it must be have been allowed to move
814      * this token by either {approve} or {setApprovalForAll}.
815      * - If `to` refers to a smart contract, it must implement
816      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817      *
818      * Emits a {Transfer} event.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId,
824         bytes calldata data
825     ) external;
826 
827     /**
828      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
829      */
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) external;
835 
836     /**
837      * @dev Transfers `tokenId` from `from` to `to`.
838      *
839      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
840      * whenever possible.
841      *
842      * Requirements:
843      *
844      * - `from` cannot be the zero address.
845      * - `to` cannot be the zero address.
846      * - `tokenId` token must be owned by `from`.
847      * - If the caller is not `from`, it must be approved to move this token
848      * by either {approve} or {setApprovalForAll}.
849      *
850      * Emits a {Transfer} event.
851      */
852     function transferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) external;
857 
858     /**
859      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
860      * The approval is cleared when the token is transferred.
861      *
862      * Only a single account can be approved at a time, so approving the
863      * zero address clears previous approvals.
864      *
865      * Requirements:
866      *
867      * - The caller must own the token or be an approved operator.
868      * - `tokenId` must exist.
869      *
870      * Emits an {Approval} event.
871      */
872     function approve(address to, uint256 tokenId) external;
873 
874     /**
875      * @dev Approve or remove `operator` as an operator for the caller.
876      * Operators can call {transferFrom} or {safeTransferFrom}
877      * for any token owned by the caller.
878      *
879      * Requirements:
880      *
881      * - The `operator` cannot be the caller.
882      *
883      * Emits an {ApprovalForAll} event.
884      */
885     function setApprovalForAll(address operator, bool _approved) external;
886 
887     /**
888      * @dev Returns the account approved for `tokenId` token.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      */
894     function getApproved(uint256 tokenId) external view returns (address operator);
895 
896     /**
897      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
898      *
899      * See {setApprovalForAll}.
900      */
901     function isApprovedForAll(address owner, address operator) external view returns (bool);
902 
903     // =============================================================
904     //                        IERC721Metadata
905     // =============================================================
906 
907     /**
908      * @dev Returns the token collection name.
909      */
910     function name() external view returns (string memory);
911 
912     /**
913      * @dev Returns the token collection symbol.
914      */
915     function symbol() external view returns (string memory);
916 
917     /**
918      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
919      */
920     function tokenURI(uint256 tokenId) external view returns (string memory);
921 
922     // =============================================================
923     //                           IERC2309
924     // =============================================================
925 
926     /**
927      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
928      * (inclusive) is transferred from `from` to `to`, as defined in the
929      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
930      *
931      * See {_mintERC2309} for more details.
932      */
933     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
934 }
935 
936 // File: erc721a/contracts/ERC721A.sol
937 
938 // ERC721A Contracts v4.2.2
939 // Creator: Chiru Labs
940 
941 pragma solidity ^0.8.4;
942 
943 /**
944  * @dev Interface of ERC721 token receiver.
945  */
946 interface ERC721A__IERC721Receiver {
947     function onERC721Received(
948         address operator,
949         address from,
950         uint256 tokenId,
951         bytes calldata data
952     ) external returns (bytes4);
953 }
954 
955 /**
956  * @title ERC721A
957  *
958  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
959  * Non-Fungible Token Standard, including the Metadata extension.
960  * Optimized for lower gas during batch mints.
961  *
962  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
963  * starting from `_startTokenId()`.
964  *
965  * Assumptions:
966  *
967  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
968  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
969  */
970 contract ERC721A is IERC721A {
971     // Reference type for token approval.
972     struct TokenApprovalRef {
973         address value;
974     }
975 
976     // =============================================================
977     //                           CONSTANTS
978     // =============================================================
979 
980     // Mask of an entry in packed address data.
981     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
982 
983     // The bit position of `numberMinted` in packed address data.
984     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
985 
986     // The bit position of `numberBurned` in packed address data.
987     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
988 
989     // The bit position of `aux` in packed address data.
990     uint256 private constant _BITPOS_AUX = 192;
991 
992     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
993     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
994 
995     // The bit position of `startTimestamp` in packed ownership.
996     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
997 
998     // The bit mask of the `burned` bit in packed ownership.
999     uint256 private constant _BITMASK_BURNED = 1 << 224;
1000 
1001     // The bit position of the `nextInitialized` bit in packed ownership.
1002     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1003 
1004     // The bit mask of the `nextInitialized` bit in packed ownership.
1005     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1006 
1007     // The bit position of `extraData` in packed ownership.
1008     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1009 
1010     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1011     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1012 
1013     // The mask of the lower 160 bits for addresses.
1014     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1015 
1016     // The maximum `quantity` that can be minted with {_mintERC2309}.
1017     // This limit is to prevent overflows on the address data entries.
1018     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1019     // is required to cause an overflow, which is unrealistic.
1020     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1021 
1022     // The `Transfer` event signature is given by:
1023     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1024     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1025         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1026 
1027     // =============================================================
1028     //                            STORAGE
1029     // =============================================================
1030 
1031     // The next token ID to be minted.
1032     uint256 private _currentIndex;
1033 
1034     // The number of tokens burned.
1035     uint256 private _burnCounter;
1036 
1037     // Token name
1038     string private _name;
1039 
1040     // Token symbol
1041     string private _symbol;
1042 
1043     // Mapping from token ID to ownership details
1044     // An empty struct value does not necessarily mean the token is unowned.
1045     // See {_packedOwnershipOf} implementation for details.
1046     //
1047     // Bits Layout:
1048     // - [0..159]   `addr`
1049     // - [160..223] `startTimestamp`
1050     // - [224]      `burned`
1051     // - [225]      `nextInitialized`
1052     // - [232..255] `extraData`
1053     mapping(uint256 => uint256) private _packedOwnerships;
1054 
1055     // Mapping owner address to address data.
1056     //
1057     // Bits Layout:
1058     // - [0..63]    `balance`
1059     // - [64..127]  `numberMinted`
1060     // - [128..191] `numberBurned`
1061     // - [192..255] `aux`
1062     mapping(address => uint256) private _packedAddressData;
1063 
1064     // Mapping from token ID to approved address.
1065     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1066 
1067     // Mapping from owner to operator approvals
1068     mapping(address => mapping(address => bool)) private _operatorApprovals;
1069 
1070     // =============================================================
1071     //                          CONSTRUCTOR
1072     // =============================================================
1073 
1074     constructor(string memory name_, string memory symbol_) {
1075         _name = name_;
1076         _symbol = symbol_;
1077         _currentIndex = _startTokenId();
1078     }
1079 
1080     // =============================================================
1081     //                   TOKEN COUNTING OPERATIONS
1082     // =============================================================
1083 
1084     /**
1085      * @dev Returns the starting token ID.
1086      * To change the starting token ID, please override this function.
1087      */
1088     function _startTokenId() internal view virtual returns (uint256) {
1089         return 0;
1090     }
1091 
1092     /**
1093      * @dev Returns the next token ID to be minted.
1094      */
1095     function _nextTokenId() internal view virtual returns (uint256) {
1096         return _currentIndex;
1097     }
1098 
1099     /**
1100      * @dev Returns the total number of tokens in existence.
1101      * Burned tokens will reduce the count.
1102      * To get the total number of tokens minted, please see {_totalMinted}.
1103      */
1104     function totalSupply() public view virtual override returns (uint256) {
1105         // Counter underflow is impossible as _burnCounter cannot be incremented
1106         // more than `_currentIndex - _startTokenId()` times.
1107         unchecked {
1108             return _currentIndex - _burnCounter - _startTokenId();
1109         }
1110     }
1111 
1112     /**
1113      * @dev Returns the total amount of tokens minted in the contract.
1114      */
1115     function _totalMinted() internal view virtual returns (uint256) {
1116         // Counter underflow is impossible as `_currentIndex` does not decrement,
1117         // and it is initialized to `_startTokenId()`.
1118         unchecked {
1119             return _currentIndex - _startTokenId();
1120         }
1121     }
1122 
1123     /**
1124      * @dev Returns the total number of tokens burned.
1125      */
1126     function _totalBurned() internal view virtual returns (uint256) {
1127         return _burnCounter;
1128     }
1129 
1130     // =============================================================
1131     //                    ADDRESS DATA OPERATIONS
1132     // =============================================================
1133 
1134     /**
1135      * @dev Returns the number of tokens in `owner`'s account.
1136      */
1137     function balanceOf(address owner) public view virtual override returns (uint256) {
1138         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1139         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1140     }
1141 
1142     /**
1143      * Returns the number of tokens minted by `owner`.
1144      */
1145     function _numberMinted(address owner) internal view returns (uint256) {
1146         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1147     }
1148 
1149     /**
1150      * Returns the number of tokens burned by or on behalf of `owner`.
1151      */
1152     function _numberBurned(address owner) internal view returns (uint256) {
1153         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1154     }
1155 
1156     /**
1157      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1158      */
1159     function _getAux(address owner) internal view returns (uint64) {
1160         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1161     }
1162 
1163     /**
1164      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1165      * If there are multiple variables, please pack them into a uint64.
1166      */
1167     function _setAux(address owner, uint64 aux) internal virtual {
1168         uint256 packed = _packedAddressData[owner];
1169         uint256 auxCasted;
1170         // Cast `aux` with assembly to avoid redundant masking.
1171         assembly {
1172             auxCasted := aux
1173         }
1174         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1175         _packedAddressData[owner] = packed;
1176     }
1177 
1178     // =============================================================
1179     //                            IERC165
1180     // =============================================================
1181 
1182     /**
1183      * @dev Returns true if this contract implements the interface defined by
1184      * `interfaceId`. See the corresponding
1185      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1186      * to learn more about how these ids are created.
1187      *
1188      * This function call must use less than 30000 gas.
1189      */
1190     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1191         // The interface IDs are constants representing the first 4 bytes
1192         // of the XOR of all function selectors in the interface.
1193         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1194         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1195         return
1196             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1197             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1198             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1199     }
1200 
1201     // =============================================================
1202     //                        IERC721Metadata
1203     // =============================================================
1204 
1205     /**
1206      * @dev Returns the token collection name.
1207      */
1208     function name() public view virtual override returns (string memory) {
1209         return _name;
1210     }
1211 
1212     /**
1213      * @dev Returns the token collection symbol.
1214      */
1215     function symbol() public view virtual override returns (string memory) {
1216         return _symbol;
1217     }
1218 
1219     /**
1220      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1221      */
1222     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1223         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1224 
1225         string memory baseURI = _baseURI();
1226         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1227     }
1228 
1229     /**
1230      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1231      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1232      * by default, it can be overridden in child contracts.
1233      */
1234     function _baseURI() internal view virtual returns (string memory) {
1235         return '';
1236     }
1237 
1238     // =============================================================
1239     //                     OWNERSHIPS OPERATIONS
1240     // =============================================================
1241 
1242     /**
1243      * @dev Returns the owner of the `tokenId` token.
1244      *
1245      * Requirements:
1246      *
1247      * - `tokenId` must exist.
1248      */
1249     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1250         return address(uint160(_packedOwnershipOf(tokenId)));
1251     }
1252 
1253     /**
1254      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1255      * It gradually moves to O(1) as tokens get transferred around over time.
1256      */
1257     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1258         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1259     }
1260 
1261     /**
1262      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1263      */
1264     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1265         return _unpackedOwnership(_packedOwnerships[index]);
1266     }
1267 
1268     /**
1269      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1270      */
1271     function _initializeOwnershipAt(uint256 index) internal virtual {
1272         if (_packedOwnerships[index] == 0) {
1273             _packedOwnerships[index] = _packedOwnershipOf(index);
1274         }
1275     }
1276 
1277     /**
1278      * Returns the packed ownership data of `tokenId`.
1279      */
1280     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1281         uint256 curr = tokenId;
1282 
1283         unchecked {
1284             if (_startTokenId() <= curr)
1285                 if (curr < _currentIndex) {
1286                     uint256 packed = _packedOwnerships[curr];
1287                     // If not burned.
1288                     if (packed & _BITMASK_BURNED == 0) {
1289                         // Invariant:
1290                         // There will always be an initialized ownership slot
1291                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1292                         // before an unintialized ownership slot
1293                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1294                         // Hence, `curr` will not underflow.
1295                         //
1296                         // We can directly compare the packed value.
1297                         // If the address is zero, packed will be zero.
1298                         while (packed == 0) {
1299                             packed = _packedOwnerships[--curr];
1300                         }
1301                         return packed;
1302                     }
1303                 }
1304         }
1305         revert OwnerQueryForNonexistentToken();
1306     }
1307 
1308     /**
1309      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1310      */
1311     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1312         ownership.addr = address(uint160(packed));
1313         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1314         ownership.burned = packed & _BITMASK_BURNED != 0;
1315         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1316     }
1317 
1318     /**
1319      * @dev Packs ownership data into a single uint256.
1320      */
1321     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1322         assembly {
1323             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1324             owner := and(owner, _BITMASK_ADDRESS)
1325             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1326             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1327         }
1328     }
1329 
1330     /**
1331      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1332      */
1333     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1334         // For branchless setting of the `nextInitialized` flag.
1335         assembly {
1336             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1337             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1338         }
1339     }
1340 
1341     // =============================================================
1342     //                      APPROVAL OPERATIONS
1343     // =============================================================
1344 
1345     /**
1346      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1347      * The approval is cleared when the token is transferred.
1348      *
1349      * Only a single account can be approved at a time, so approving the
1350      * zero address clears previous approvals.
1351      *
1352      * Requirements:
1353      *
1354      * - The caller must own the token or be an approved operator.
1355      * - `tokenId` must exist.
1356      *
1357      * Emits an {Approval} event.
1358      */
1359     function approve(address to, uint256 tokenId) public virtual override {
1360         address owner = ownerOf(tokenId);
1361 
1362         if (_msgSenderERC721A() != owner)
1363             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1364                 revert ApprovalCallerNotOwnerNorApproved();
1365             }
1366 
1367         _tokenApprovals[tokenId].value = to;
1368         emit Approval(owner, to, tokenId);
1369     }
1370 
1371     /**
1372      * @dev Returns the account approved for `tokenId` token.
1373      *
1374      * Requirements:
1375      *
1376      * - `tokenId` must exist.
1377      */
1378     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1379         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1380 
1381         return _tokenApprovals[tokenId].value;
1382     }
1383 
1384     /**
1385      * @dev Approve or remove `operator` as an operator for the caller.
1386      * Operators can call {transferFrom} or {safeTransferFrom}
1387      * for any token owned by the caller.
1388      *
1389      * Requirements:
1390      *
1391      * - The `operator` cannot be the caller.
1392      *
1393      * Emits an {ApprovalForAll} event.
1394      */
1395     function setApprovalForAll(address operator, bool approved) public virtual override {
1396         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1397 
1398         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1399         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1400     }
1401 
1402     /**
1403      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1404      *
1405      * See {setApprovalForAll}.
1406      */
1407     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1408         return _operatorApprovals[owner][operator];
1409     }
1410 
1411     /**
1412      * @dev Returns whether `tokenId` exists.
1413      *
1414      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1415      *
1416      * Tokens start existing when they are minted. See {_mint}.
1417      */
1418     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1419         return
1420             _startTokenId() <= tokenId &&
1421             tokenId < _currentIndex && // If within bounds,
1422             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1423     }
1424 
1425     /**
1426      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1427      */
1428     function _isSenderApprovedOrOwner(
1429         address approvedAddress,
1430         address owner,
1431         address msgSender
1432     ) private pure returns (bool result) {
1433         assembly {
1434             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1435             owner := and(owner, _BITMASK_ADDRESS)
1436             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1437             msgSender := and(msgSender, _BITMASK_ADDRESS)
1438             // `msgSender == owner || msgSender == approvedAddress`.
1439             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1440         }
1441     }
1442 
1443     /**
1444      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1445      */
1446     function _getApprovedSlotAndAddress(uint256 tokenId)
1447         private
1448         view
1449         returns (uint256 approvedAddressSlot, address approvedAddress)
1450     {
1451         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1452         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1453         assembly {
1454             approvedAddressSlot := tokenApproval.slot
1455             approvedAddress := sload(approvedAddressSlot)
1456         }
1457     }
1458 
1459     // =============================================================
1460     //                      TRANSFER OPERATIONS
1461     // =============================================================
1462 
1463     /**
1464      * @dev Transfers `tokenId` from `from` to `to`.
1465      *
1466      * Requirements:
1467      *
1468      * - `from` cannot be the zero address.
1469      * - `to` cannot be the zero address.
1470      * - `tokenId` token must be owned by `from`.
1471      * - If the caller is not `from`, it must be approved to move this token
1472      * by either {approve} or {setApprovalForAll}.
1473      *
1474      * Emits a {Transfer} event.
1475      */
1476     function transferFrom(
1477         address from,
1478         address to,
1479         uint256 tokenId
1480     ) public virtual override {
1481         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1482 
1483         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1484 
1485         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1486 
1487         // The nested ifs save around 20+ gas over a compound boolean condition.
1488         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1489             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1490 
1491         if (to == address(0)) revert TransferToZeroAddress();
1492 
1493         _beforeTokenTransfers(from, to, tokenId, 1);
1494 
1495         // Clear approvals from the previous owner.
1496         assembly {
1497             if approvedAddress {
1498                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1499                 sstore(approvedAddressSlot, 0)
1500             }
1501         }
1502 
1503         // Underflow of the sender's balance is impossible because we check for
1504         // ownership above and the recipient's balance can't realistically overflow.
1505         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1506         unchecked {
1507             // We can directly increment and decrement the balances.
1508             --_packedAddressData[from]; // Updates: `balance -= 1`.
1509             ++_packedAddressData[to]; // Updates: `balance += 1`.
1510 
1511             // Updates:
1512             // - `address` to the next owner.
1513             // - `startTimestamp` to the timestamp of transfering.
1514             // - `burned` to `false`.
1515             // - `nextInitialized` to `true`.
1516             _packedOwnerships[tokenId] = _packOwnershipData(
1517                 to,
1518                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1519             );
1520 
1521             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1522             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1523                 uint256 nextTokenId = tokenId + 1;
1524                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1525                 if (_packedOwnerships[nextTokenId] == 0) {
1526                     // If the next slot is within bounds.
1527                     if (nextTokenId != _currentIndex) {
1528                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1529                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1530                     }
1531                 }
1532             }
1533         }
1534 
1535         emit Transfer(from, to, tokenId);
1536         _afterTokenTransfers(from, to, tokenId, 1);
1537     }
1538 
1539     /**
1540      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1541      */
1542     function safeTransferFrom(
1543         address from,
1544         address to,
1545         uint256 tokenId
1546     ) public virtual override {
1547         safeTransferFrom(from, to, tokenId, '');
1548     }
1549 
1550     /**
1551      * @dev Safely transfers `tokenId` token from `from` to `to`.
1552      *
1553      * Requirements:
1554      *
1555      * - `from` cannot be the zero address.
1556      * - `to` cannot be the zero address.
1557      * - `tokenId` token must exist and be owned by `from`.
1558      * - If the caller is not `from`, it must be approved to move this token
1559      * by either {approve} or {setApprovalForAll}.
1560      * - If `to` refers to a smart contract, it must implement
1561      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1562      *
1563      * Emits a {Transfer} event.
1564      */
1565     function safeTransferFrom(
1566         address from,
1567         address to,
1568         uint256 tokenId,
1569         bytes memory _data
1570     ) public virtual override {
1571         transferFrom(from, to, tokenId);
1572         if (to.code.length != 0)
1573             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1574                 revert TransferToNonERC721ReceiverImplementer();
1575             }
1576     }
1577 
1578     /**
1579      * @dev Hook that is called before a set of serially-ordered token IDs
1580      * are about to be transferred. This includes minting.
1581      * And also called before burning one token.
1582      *
1583      * `startTokenId` - the first token ID to be transferred.
1584      * `quantity` - the amount to be transferred.
1585      *
1586      * Calling conditions:
1587      *
1588      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1589      * transferred to `to`.
1590      * - When `from` is zero, `tokenId` will be minted for `to`.
1591      * - When `to` is zero, `tokenId` will be burned by `from`.
1592      * - `from` and `to` are never both zero.
1593      */
1594     function _beforeTokenTransfers(
1595         address from,
1596         address to,
1597         uint256 startTokenId,
1598         uint256 quantity
1599     ) internal virtual {}
1600 
1601     /**
1602      * @dev Hook that is called after a set of serially-ordered token IDs
1603      * have been transferred. This includes minting.
1604      * And also called after one token has been burned.
1605      *
1606      * `startTokenId` - the first token ID to be transferred.
1607      * `quantity` - the amount to be transferred.
1608      *
1609      * Calling conditions:
1610      *
1611      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1612      * transferred to `to`.
1613      * - When `from` is zero, `tokenId` has been minted for `to`.
1614      * - When `to` is zero, `tokenId` has been burned by `from`.
1615      * - `from` and `to` are never both zero.
1616      */
1617     function _afterTokenTransfers(
1618         address from,
1619         address to,
1620         uint256 startTokenId,
1621         uint256 quantity
1622     ) internal virtual {}
1623 
1624     /**
1625      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1626      *
1627      * `from` - Previous owner of the given token ID.
1628      * `to` - Target address that will receive the token.
1629      * `tokenId` - Token ID to be transferred.
1630      * `_data` - Optional data to send along with the call.
1631      *
1632      * Returns whether the call correctly returned the expected magic value.
1633      */
1634     function _checkContractOnERC721Received(
1635         address from,
1636         address to,
1637         uint256 tokenId,
1638         bytes memory _data
1639     ) private returns (bool) {
1640         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1641             bytes4 retval
1642         ) {
1643             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1644         } catch (bytes memory reason) {
1645             if (reason.length == 0) {
1646                 revert TransferToNonERC721ReceiverImplementer();
1647             } else {
1648                 assembly {
1649                     revert(add(32, reason), mload(reason))
1650                 }
1651             }
1652         }
1653     }
1654 
1655     // =============================================================
1656     //                        MINT OPERATIONS
1657     // =============================================================
1658 
1659     /**
1660      * @dev Mints `quantity` tokens and transfers them to `to`.
1661      *
1662      * Requirements:
1663      *
1664      * - `to` cannot be the zero address.
1665      * - `quantity` must be greater than 0.
1666      *
1667      * Emits a {Transfer} event for each mint.
1668      */
1669     function _mint(address to, uint256 quantity) internal virtual {
1670         uint256 startTokenId = _currentIndex;
1671         if (quantity == 0) revert MintZeroQuantity();
1672 
1673         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1674 
1675         // Overflows are incredibly unrealistic.
1676         // `balance` and `numberMinted` have a maximum limit of 2**64.
1677         // `tokenId` has a maximum limit of 2**256.
1678         unchecked {
1679             // Updates:
1680             // - `balance += quantity`.
1681             // - `numberMinted += quantity`.
1682             //
1683             // We can directly add to the `balance` and `numberMinted`.
1684             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1685 
1686             // Updates:
1687             // - `address` to the owner.
1688             // - `startTimestamp` to the timestamp of minting.
1689             // - `burned` to `false`.
1690             // - `nextInitialized` to `quantity == 1`.
1691             _packedOwnerships[startTokenId] = _packOwnershipData(
1692                 to,
1693                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1694             );
1695 
1696             uint256 toMasked;
1697             uint256 end = startTokenId + quantity;
1698 
1699             // Use assembly to loop and emit the `Transfer` event for gas savings.
1700             assembly {
1701                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1702                 toMasked := and(to, _BITMASK_ADDRESS)
1703                 // Emit the `Transfer` event.
1704                 log4(
1705                     0, // Start of data (0, since no data).
1706                     0, // End of data (0, since no data).
1707                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1708                     0, // `address(0)`.
1709                     toMasked, // `to`.
1710                     startTokenId // `tokenId`.
1711                 )
1712 
1713                 for {
1714                     let tokenId := add(startTokenId, 1)
1715                 } iszero(eq(tokenId, end)) {
1716                     tokenId := add(tokenId, 1)
1717                 } {
1718                     // Emit the `Transfer` event. Similar to above.
1719                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1720                 }
1721             }
1722             if (toMasked == 0) revert MintToZeroAddress();
1723 
1724             _currentIndex = end;
1725         }
1726         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1727     }
1728 
1729     /**
1730      * @dev Mints `quantity` tokens and transfers them to `to`.
1731      *
1732      * This function is intended for efficient minting only during contract creation.
1733      *
1734      * It emits only one {ConsecutiveTransfer} as defined in
1735      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1736      * instead of a sequence of {Transfer} event(s).
1737      *
1738      * Calling this function outside of contract creation WILL make your contract
1739      * non-compliant with the ERC721 standard.
1740      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1741      * {ConsecutiveTransfer} event is only permissible during contract creation.
1742      *
1743      * Requirements:
1744      *
1745      * - `to` cannot be the zero address.
1746      * - `quantity` must be greater than 0.
1747      *
1748      * Emits a {ConsecutiveTransfer} event.
1749      */
1750     function _mintERC2309(address to, uint256 quantity) internal virtual {
1751         uint256 startTokenId = _currentIndex;
1752         if (to == address(0)) revert MintToZeroAddress();
1753         if (quantity == 0) revert MintZeroQuantity();
1754         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1755 
1756         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1757 
1758         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1759         unchecked {
1760             // Updates:
1761             // - `balance += quantity`.
1762             // - `numberMinted += quantity`.
1763             //
1764             // We can directly add to the `balance` and `numberMinted`.
1765             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1766 
1767             // Updates:
1768             // - `address` to the owner.
1769             // - `startTimestamp` to the timestamp of minting.
1770             // - `burned` to `false`.
1771             // - `nextInitialized` to `quantity == 1`.
1772             _packedOwnerships[startTokenId] = _packOwnershipData(
1773                 to,
1774                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1775             );
1776 
1777             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1778 
1779             _currentIndex = startTokenId + quantity;
1780         }
1781         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1782     }
1783 
1784     /**
1785      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1786      *
1787      * Requirements:
1788      *
1789      * - If `to` refers to a smart contract, it must implement
1790      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1791      * - `quantity` must be greater than 0.
1792      *
1793      * See {_mint}.
1794      *
1795      * Emits a {Transfer} event for each mint.
1796      */
1797     function _safeMint(
1798         address to,
1799         uint256 quantity,
1800         bytes memory _data
1801     ) internal virtual {
1802         _mint(to, quantity);
1803 
1804         unchecked {
1805             if (to.code.length != 0) {
1806                 uint256 end = _currentIndex;
1807                 uint256 index = end - quantity;
1808                 do {
1809                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1810                         revert TransferToNonERC721ReceiverImplementer();
1811                     }
1812                 } while (index < end);
1813                 // Reentrancy protection.
1814                 if (_currentIndex != end) revert();
1815             }
1816         }
1817     }
1818 
1819     /**
1820      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1821      */
1822     function _safeMint(address to, uint256 quantity) internal virtual {
1823         _safeMint(to, quantity, '');
1824     }
1825 
1826     // =============================================================
1827     //                        BURN OPERATIONS
1828     // =============================================================
1829 
1830     /**
1831      * @dev Equivalent to `_burn(tokenId, false)`.
1832      */
1833     function _burn(uint256 tokenId) internal virtual {
1834         _burn(tokenId, false);
1835     }
1836 
1837     /**
1838      * @dev Destroys `tokenId`.
1839      * The approval is cleared when the token is burned.
1840      *
1841      * Requirements:
1842      *
1843      * - `tokenId` must exist.
1844      *
1845      * Emits a {Transfer} event.
1846      */
1847     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1848         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1849 
1850         address from = address(uint160(prevOwnershipPacked));
1851 
1852         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1853 
1854         if (approvalCheck) {
1855             // The nested ifs save around 20+ gas over a compound boolean condition.
1856             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1857                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1858         }
1859 
1860         _beforeTokenTransfers(from, address(0), tokenId, 1);
1861 
1862         // Clear approvals from the previous owner.
1863         assembly {
1864             if approvedAddress {
1865                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1866                 sstore(approvedAddressSlot, 0)
1867             }
1868         }
1869 
1870         // Underflow of the sender's balance is impossible because we check for
1871         // ownership above and the recipient's balance can't realistically overflow.
1872         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1873         unchecked {
1874             // Updates:
1875             // - `balance -= 1`.
1876             // - `numberBurned += 1`.
1877             //
1878             // We can directly decrement the balance, and increment the number burned.
1879             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1880             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1881 
1882             // Updates:
1883             // - `address` to the last owner.
1884             // - `startTimestamp` to the timestamp of burning.
1885             // - `burned` to `true`.
1886             // - `nextInitialized` to `true`.
1887             _packedOwnerships[tokenId] = _packOwnershipData(
1888                 from,
1889                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1890             );
1891 
1892             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1893             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1894                 uint256 nextTokenId = tokenId + 1;
1895                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1896                 if (_packedOwnerships[nextTokenId] == 0) {
1897                     // If the next slot is within bounds.
1898                     if (nextTokenId != _currentIndex) {
1899                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1900                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1901                     }
1902                 }
1903             }
1904         }
1905 
1906         emit Transfer(from, address(0), tokenId);
1907         _afterTokenTransfers(from, address(0), tokenId, 1);
1908 
1909         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1910         unchecked {
1911             _burnCounter++;
1912         }
1913     }
1914 
1915     // =============================================================
1916     //                     EXTRA DATA OPERATIONS
1917     // =============================================================
1918 
1919     /**
1920      * @dev Directly sets the extra data for the ownership data `index`.
1921      */
1922     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1923         uint256 packed = _packedOwnerships[index];
1924         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1925         uint256 extraDataCasted;
1926         // Cast `extraData` with assembly to avoid redundant masking.
1927         assembly {
1928             extraDataCasted := extraData
1929         }
1930         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1931         _packedOwnerships[index] = packed;
1932     }
1933 
1934     /**
1935      * @dev Called during each token transfer to set the 24bit `extraData` field.
1936      * Intended to be overridden by the cosumer contract.
1937      *
1938      * `previousExtraData` - the value of `extraData` before transfer.
1939      *
1940      * Calling conditions:
1941      *
1942      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1943      * transferred to `to`.
1944      * - When `from` is zero, `tokenId` will be minted for `to`.
1945      * - When `to` is zero, `tokenId` will be burned by `from`.
1946      * - `from` and `to` are never both zero.
1947      */
1948     function _extraData(
1949         address from,
1950         address to,
1951         uint24 previousExtraData
1952     ) internal view virtual returns (uint24) {}
1953 
1954     /**
1955      * @dev Returns the next extra data for the packed ownership data.
1956      * The returned result is shifted into position.
1957      */
1958     function _nextExtraData(
1959         address from,
1960         address to,
1961         uint256 prevOwnershipPacked
1962     ) private view returns (uint256) {
1963         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1964         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1965     }
1966 
1967     // =============================================================
1968     //                       OTHER OPERATIONS
1969     // =============================================================
1970 
1971     /**
1972      * @dev Returns the message sender (defaults to `msg.sender`).
1973      *
1974      * If you are writing GSN compatible contracts, you need to override this function.
1975      */
1976     function _msgSenderERC721A() internal view virtual returns (address) {
1977         return msg.sender;
1978     }
1979 
1980     /**
1981      * @dev Converts a uint256 to its ASCII string decimal representation.
1982      */
1983     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1984         assembly {
1985             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1986             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1987             // We will need 1 32-byte word to store the length,
1988             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1989             str := add(mload(0x40), 0x80)
1990             // Update the free memory pointer to allocate.
1991             mstore(0x40, str)
1992 
1993             // Cache the end of the memory to calculate the length later.
1994             let end := str
1995 
1996             // We write the string from rightmost digit to leftmost digit.
1997             // The following is essentially a do-while loop that also handles the zero case.
1998             // prettier-ignore
1999             for { let temp := value } 1 {} {
2000                 str := sub(str, 1)
2001                 // Write the character to the pointer.
2002                 // The ASCII index of the '0' character is 48.
2003                 mstore8(str, add(48, mod(temp, 10)))
2004                 // Keep dividing `temp` until zero.
2005                 temp := div(temp, 10)
2006                 // prettier-ignore
2007                 if iszero(temp) { break }
2008             }
2009 
2010             let length := sub(end, str)
2011             // Move the pointer 32 bytes leftwards to make room for the length.
2012             str := sub(str, 0x20)
2013             // Store the length.
2014             mstore(str, length)
2015         }
2016     }
2017 }
2018 
2019 // File: contracts/UsedToilets.sol
2020 
2021 pragma solidity ^0.8.4;
2022 
2023 
2024 
2025 
2026 
2027 contract UsedToilets is ERC721A, Ownable {
2028     using Strings for uint256; 
2029     using SafeMath for uint256;
2030 
2031     enum State {
2032         CLOSED,
2033         PRESALE,
2034         PUBLIC
2035     }
2036 
2037     State public saleState = State.CLOSED;
2038     string public baseURI;
2039     uint256 public maxSupply = 5555;
2040     uint256 public maxMintAmount = 2;
2041     
2042     address private signer;
2043     address private partners;
2044     
2045     constructor (
2046         string memory _name,
2047         string memory _symbol,
2048         string memory _initBaseURI,
2049         address _signer,
2050         address _partners
2051     ) ERC721A (_name, _symbol) {  
2052         setBaseURI(_initBaseURI);
2053         signer = _signer;
2054         partners = _partners;
2055     }
2056 
2057 
2058     function _baseURI() internal view virtual override returns (string memory) {
2059         return baseURI;
2060     }
2061 
2062     function setBaseURI(string memory _newBaseURI) public onlyOwner() {
2063         baseURI = _newBaseURI;
2064     }
2065 
2066     function presaleMint(uint256 _mintAmount, bytes calldata _signature) external { 
2067         require(saleState == State.PRESALE, "Presale unavailable"); 
2068         require(_mintAmount > 0);
2069         require(ECDSA.recover(keccak256(abi.encodePacked(msg.sender)), _signature) == signer, "Signature Invalid");
2070         require(numberMinted(msg.sender) + _mintAmount <= maxMintAmount, "Exceeded mint amount");
2071         require((totalSupply() + _mintAmount) <= maxSupply, "Sold out"); 
2072         _safeMint(msg.sender, _mintAmount); 
2073     }
2074 
2075     function publicMint(uint256 _mintAmount) external { 
2076         require(saleState == State.PUBLIC, "Public sale unavailable"); 
2077         require(_mintAmount > 0);
2078         require(_mintAmount <= maxMintAmount, "Exceeded mint amount");
2079         require((totalSupply() + _mintAmount) <= maxSupply, "Sold out"); 
2080         _safeMint(msg.sender, _mintAmount); 
2081     }
2082 
2083     function numberMinted(address _owner) public view returns (uint256) {
2084         return _numberMinted(_owner);
2085     }
2086 
2087     function setPartners(address _newPartners) external onlyOwner() {
2088         partners = _newPartners;
2089     }
2090 
2091     function setSigner(address _newSigner) external onlyOwner() {
2092         signer = _newSigner;
2093     }
2094 
2095     function setMaxSupply(uint256 _newMaxSupply) external onlyOwner() {
2096         maxSupply = _newMaxSupply;
2097     }
2098 
2099     function setSaleState(uint256 _saleState) external onlyOwner() {
2100         saleState = State(_saleState);
2101     }
2102 
2103     function setMaxMintAmount(uint256 _newmaxMintAmount) external onlyOwner() {
2104         maxMintAmount = _newmaxMintAmount;
2105     }
2106 
2107     function airdropsBulk(address[] calldata _airdropWallets, uint256[] calldata _mintAmount) external onlyOwner() {
2108         require(_airdropWallets.length == _mintAmount.length);
2109         require((totalSupply() + _airdropWallets.length) <= maxSupply, "Cannot mint more");
2110         for (uint i =0; i < _airdropWallets.length; i++) {
2111             _safeMint(_airdropWallets[i], _mintAmount[i]);
2112         }
2113     }
2114 
2115     function airdrop(address _airdropWallet, uint256 quantity) external onlyOwner() {
2116         require((totalSupply() + quantity) <= maxSupply, "Cannot mint more");
2117         _safeMint(_airdropWallet, quantity);
2118     }
2119 
2120     function withdrawAll() external onlyOwner() {
2121         require(address(this).balance > 0, "No balance");
2122         uint256 contractBalance = address(this).balance;
2123 
2124         (bool w1,) = partners.call{value: contractBalance}(""); 
2125 
2126         require(w1, "Withdraw failed");
2127     }
2128 }