1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 // SPDX-License-Identifier: MIT
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     /**
34      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a + b;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a * b;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers, reverting on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator.
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         unchecked {
177             require(b <= a, errorMessage);
178             return a - b;
179         }
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b > 0, errorMessage);
201             return a / b;
202         }
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting with custom message when dividing by zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryMod}.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         unchecked {
226             require(b > 0, errorMessage);
227             return a % b;
228         }
229     }
230 }
231 
232 // File: @openzeppelin/contracts/utils/Strings.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev String operations.
241  */
242 library Strings {
243     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
244 
245     /**
246      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
247      */
248     function toString(uint256 value) internal pure returns (string memory) {
249         // Inspired by OraclizeAPI's implementation - MIT licence
250         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
251 
252         if (value == 0) {
253             return "0";
254         }
255         uint256 temp = value;
256         uint256 digits;
257         while (temp != 0) {
258             digits++;
259             temp /= 10;
260         }
261         bytes memory buffer = new bytes(digits);
262         while (value != 0) {
263             digits -= 1;
264             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
265             value /= 10;
266         }
267         return string(buffer);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
272      */
273     function toHexString(uint256 value) internal pure returns (string memory) {
274         if (value == 0) {
275             return "0x00";
276         }
277         uint256 temp = value;
278         uint256 length = 0;
279         while (temp != 0) {
280             length++;
281             temp >>= 8;
282         }
283         return toHexString(value, length);
284     }
285 
286     /**
287      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
288      */
289     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
290         bytes memory buffer = new bytes(2 * length + 2);
291         buffer[0] = "0";
292         buffer[1] = "x";
293         for (uint256 i = 2 * length + 1; i > 1; --i) {
294             buffer[i] = _HEX_SYMBOLS[value & 0xf];
295             value >>= 4;
296         }
297         require(value == 0, "Strings: hex length insufficient");
298         return string(buffer);
299     }
300 }
301 
302 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
303 
304 
305 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 
310 /**
311  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
312  *
313  * These functions can be used to verify that a message was signed by the holder
314  * of the private keys of a given address.
315  */
316 library ECDSA {
317     enum RecoverError {
318         NoError,
319         InvalidSignature,
320         InvalidSignatureLength,
321         InvalidSignatureS,
322         InvalidSignatureV
323     }
324 
325     function _throwError(RecoverError error) private pure {
326         if (error == RecoverError.NoError) {
327             return; // no error: do nothing
328         } else if (error == RecoverError.InvalidSignature) {
329             revert("ECDSA: invalid signature");
330         } else if (error == RecoverError.InvalidSignatureLength) {
331             revert("ECDSA: invalid signature length");
332         } else if (error == RecoverError.InvalidSignatureS) {
333             revert("ECDSA: invalid signature 's' value");
334         } else if (error == RecoverError.InvalidSignatureV) {
335             revert("ECDSA: invalid signature 'v' value");
336         }
337     }
338 
339     /**
340      * @dev Returns the address that signed a hashed message (`hash`) with
341      * `signature` or error string. This address can then be used for verification purposes.
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
352      *
353      * Documentation for signature generation:
354      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
355      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
356      *
357      * _Available since v4.3._
358      */
359     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
360         // Check the signature length
361         // - case 65: r,s,v signature (standard)
362         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
363         if (signature.length == 65) {
364             bytes32 r;
365             bytes32 s;
366             uint8 v;
367             // ecrecover takes the signature parameters, and the only way to get them
368             // currently is to use assembly.
369             assembly {
370                 r := mload(add(signature, 0x20))
371                 s := mload(add(signature, 0x40))
372                 v := byte(0, mload(add(signature, 0x60)))
373             }
374             return tryRecover(hash, v, r, s);
375         } else if (signature.length == 64) {
376             bytes32 r;
377             bytes32 vs;
378             // ecrecover takes the signature parameters, and the only way to get them
379             // currently is to use assembly.
380             assembly {
381                 r := mload(add(signature, 0x20))
382                 vs := mload(add(signature, 0x40))
383             }
384             return tryRecover(hash, r, vs);
385         } else {
386             return (address(0), RecoverError.InvalidSignatureLength);
387         }
388     }
389 
390     /**
391      * @dev Returns the address that signed a hashed message (`hash`) with
392      * `signature`. This address can then be used for verification purposes.
393      *
394      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
395      * this function rejects them by requiring the `s` value to be in the lower
396      * half order, and the `v` value to be either 27 or 28.
397      *
398      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
399      * verification to be secure: it is possible to craft signatures that
400      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
401      * this is by receiving a hash of the original message (which may otherwise
402      * be too long), and then calling {toEthSignedMessageHash} on it.
403      */
404     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
405         (address recovered, RecoverError error) = tryRecover(hash, signature);
406         _throwError(error);
407         return recovered;
408     }
409 
410     /**
411      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
412      *
413      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
414      *
415      * _Available since v4.3._
416      */
417     function tryRecover(
418         bytes32 hash,
419         bytes32 r,
420         bytes32 vs
421     ) internal pure returns (address, RecoverError) {
422         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
423         uint8 v = uint8((uint256(vs) >> 255) + 27);
424         return tryRecover(hash, v, r, s);
425     }
426 
427     /**
428      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
429      *
430      * _Available since v4.2._
431      */
432     function recover(
433         bytes32 hash,
434         bytes32 r,
435         bytes32 vs
436     ) internal pure returns (address) {
437         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
438         _throwError(error);
439         return recovered;
440     }
441 
442     /**
443      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
444      * `r` and `s` signature fields separately.
445      *
446      * _Available since v4.3._
447      */
448     function tryRecover(
449         bytes32 hash,
450         uint8 v,
451         bytes32 r,
452         bytes32 s
453     ) internal pure returns (address, RecoverError) {
454         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
455         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
456         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
457         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
458         //
459         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
460         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
461         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
462         // these malleable signatures as well.
463         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
464             return (address(0), RecoverError.InvalidSignatureS);
465         }
466         if (v != 27 && v != 28) {
467             return (address(0), RecoverError.InvalidSignatureV);
468         }
469 
470         // If the signature is valid (and not malleable), return the signer address
471         address signer = ecrecover(hash, v, r, s);
472         if (signer == address(0)) {
473             return (address(0), RecoverError.InvalidSignature);
474         }
475 
476         return (signer, RecoverError.NoError);
477     }
478 
479     /**
480      * @dev Overload of {ECDSA-recover} that receives the `v`,
481      * `r` and `s` signature fields separately.
482      */
483     function recover(
484         bytes32 hash,
485         uint8 v,
486         bytes32 r,
487         bytes32 s
488     ) internal pure returns (address) {
489         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
490         _throwError(error);
491         return recovered;
492     }
493 
494     /**
495      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
496      * produces hash corresponding to the one signed with the
497      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
498      * JSON-RPC method as part of EIP-191.
499      *
500      * See {recover}.
501      */
502     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
503         // 32 is the length in bytes of hash,
504         // enforced by the type signature above
505         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
506     }
507 
508     /**
509      * @dev Returns an Ethereum Signed Message, created from `s`. This
510      * produces hash corresponding to the one signed with the
511      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
512      * JSON-RPC method as part of EIP-191.
513      *
514      * See {recover}.
515      */
516     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
517         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
518     }
519 
520     /**
521      * @dev Returns an Ethereum Signed Typed Data, created from a
522      * `domainSeparator` and a `structHash`. This produces hash corresponding
523      * to the one signed with the
524      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
525      * JSON-RPC method as part of EIP-712.
526      *
527      * See {recover}.
528      */
529     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
530         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
531     }
532 }
533 
534 // File: @openzeppelin/contracts/utils/Context.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Provides information about the current execution context, including the
543  * sender of the transaction and its data. While these are generally available
544  * via msg.sender and msg.data, they should not be accessed in such a direct
545  * manner, since when dealing with meta-transactions the account sending and
546  * paying for execution may not be the actual sender (as far as an application
547  * is concerned).
548  *
549  * This contract is only required for intermediate, library-like contracts.
550  */
551 abstract contract Context {
552     function _msgSender() internal view virtual returns (address) {
553         return msg.sender;
554     }
555 
556     function _msgData() internal view virtual returns (bytes calldata) {
557         return msg.data;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/access/Ownable.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @dev Contract module which provides a basic access control mechanism, where
571  * there is an account (an owner) that can be granted exclusive access to
572  * specific functions.
573  *
574  * By default, the owner account will be the one that deploys the contract. This
575  * can later be changed with {transferOwnership}.
576  *
577  * This module is used through inheritance. It will make available the modifier
578  * `onlyOwner`, which can be applied to your functions to restrict their use to
579  * the owner.
580  */
581 abstract contract Ownable is Context {
582     address private _owner;
583 
584     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
585 
586     /**
587      * @dev Initializes the contract setting the deployer as the initial owner.
588      */
589     constructor() {
590         _transferOwnership(_msgSender());
591     }
592 
593     /**
594      * @dev Returns the address of the current owner.
595      */
596     function owner() public view virtual returns (address) {
597         return _owner;
598     }
599 
600     /**
601      * @dev Throws if called by any account other than the owner.
602      */
603     modifier onlyOwner() {
604         require(owner() == _msgSender(), "Ownable: caller is not the owner");
605         _;
606     }
607 
608     /**
609      * @dev Leaves the contract without owner. It will not be possible to call
610      * `onlyOwner` functions anymore. Can only be called by the current owner.
611      *
612      * NOTE: Renouncing ownership will leave the contract without an owner,
613      * thereby removing any functionality that is only available to the owner.
614      */
615     function renounceOwnership() public virtual onlyOwner {
616         _transferOwnership(address(0));
617     }
618 
619     /**
620      * @dev Transfers ownership of the contract to a new account (`newOwner`).
621      * Can only be called by the current owner.
622      */
623     function transferOwnership(address newOwner) public virtual onlyOwner {
624         require(newOwner != address(0), "Ownable: new owner is the zero address");
625         _transferOwnership(newOwner);
626     }
627 
628     /**
629      * @dev Transfers ownership of the contract to a new account (`newOwner`).
630      * Internal function without access restriction.
631      */
632     function _transferOwnership(address newOwner) internal virtual {
633         address oldOwner = _owner;
634         _owner = newOwner;
635         emit OwnershipTransferred(oldOwner, newOwner);
636     }
637 }
638 
639 // File: @openzeppelin/contracts/utils/Address.sol
640 
641 
642 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
643 
644 pragma solidity ^0.8.1;
645 
646 /**
647  * @dev Collection of functions related to the address type
648  */
649 library Address {
650     /**
651      * @dev Returns true if `account` is a contract.
652      *
653      * [IMPORTANT]
654      * ====
655      * It is unsafe to assume that an address for which this function returns
656      * false is an externally-owned account (EOA) and not a contract.
657      *
658      * Among others, `isContract` will return false for the following
659      * types of addresses:
660      *
661      *  - an externally-owned account
662      *  - a contract in construction
663      *  - an address where a contract will be created
664      *  - an address where a contract lived, but was destroyed
665      * ====
666      *
667      * [IMPORTANT]
668      * ====
669      * You shouldn't rely on `isContract` to protect against flash loan attacks!
670      *
671      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
672      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
673      * constructor.
674      * ====
675      */
676     function isContract(address account) internal view returns (bool) {
677         // This method relies on extcodesize/address.code.length, which returns 0
678         // for contracts in construction, since the code is only stored at the end
679         // of the constructor execution.
680 
681         return account.code.length > 0;
682     }
683 
684     /**
685      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
686      * `recipient`, forwarding all available gas and reverting on errors.
687      *
688      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
689      * of certain opcodes, possibly making contracts go over the 2300 gas limit
690      * imposed by `transfer`, making them unable to receive funds via
691      * `transfer`. {sendValue} removes this limitation.
692      *
693      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
694      *
695      * IMPORTANT: because control is transferred to `recipient`, care must be
696      * taken to not create reentrancy vulnerabilities. Consider using
697      * {ReentrancyGuard} or the
698      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
699      */
700     function sendValue(address payable recipient, uint256 amount) internal {
701         require(address(this).balance >= amount, "Address: insufficient balance");
702 
703         (bool success, ) = recipient.call{value: amount}("");
704         require(success, "Address: unable to send value, recipient may have reverted");
705     }
706 
707     /**
708      * @dev Performs a Solidity function call using a low level `call`. A
709      * plain `call` is an unsafe replacement for a function call: use this
710      * function instead.
711      *
712      * If `target` reverts with a revert reason, it is bubbled up by this
713      * function (like regular Solidity function calls).
714      *
715      * Returns the raw returned data. To convert to the expected return value,
716      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
717      *
718      * Requirements:
719      *
720      * - `target` must be a contract.
721      * - calling `target` with `data` must not revert.
722      *
723      * _Available since v3.1._
724      */
725     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
726         return functionCall(target, data, "Address: low-level call failed");
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
731      * `errorMessage` as a fallback revert reason when `target` reverts.
732      *
733      * _Available since v3.1._
734      */
735     function functionCall(
736         address target,
737         bytes memory data,
738         string memory errorMessage
739     ) internal returns (bytes memory) {
740         return functionCallWithValue(target, data, 0, errorMessage);
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
745      * but also transferring `value` wei to `target`.
746      *
747      * Requirements:
748      *
749      * - the calling contract must have an ETH balance of at least `value`.
750      * - the called Solidity function must be `payable`.
751      *
752      * _Available since v3.1._
753      */
754     function functionCallWithValue(
755         address target,
756         bytes memory data,
757         uint256 value
758     ) internal returns (bytes memory) {
759         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
764      * with `errorMessage` as a fallback revert reason when `target` reverts.
765      *
766      * _Available since v3.1._
767      */
768     function functionCallWithValue(
769         address target,
770         bytes memory data,
771         uint256 value,
772         string memory errorMessage
773     ) internal returns (bytes memory) {
774         require(address(this).balance >= value, "Address: insufficient balance for call");
775         require(isContract(target), "Address: call to non-contract");
776 
777         (bool success, bytes memory returndata) = target.call{value: value}(data);
778         return verifyCallResult(success, returndata, errorMessage);
779     }
780 
781     /**
782      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
783      * but performing a static call.
784      *
785      * _Available since v3.3._
786      */
787     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
788         return functionStaticCall(target, data, "Address: low-level static call failed");
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
793      * but performing a static call.
794      *
795      * _Available since v3.3._
796      */
797     function functionStaticCall(
798         address target,
799         bytes memory data,
800         string memory errorMessage
801     ) internal view returns (bytes memory) {
802         require(isContract(target), "Address: static call to non-contract");
803 
804         (bool success, bytes memory returndata) = target.staticcall(data);
805         return verifyCallResult(success, returndata, errorMessage);
806     }
807 
808     /**
809      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
810      * but performing a delegate call.
811      *
812      * _Available since v3.4._
813      */
814     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
815         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
816     }
817 
818     /**
819      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
820      * but performing a delegate call.
821      *
822      * _Available since v3.4._
823      */
824     function functionDelegateCall(
825         address target,
826         bytes memory data,
827         string memory errorMessage
828     ) internal returns (bytes memory) {
829         require(isContract(target), "Address: delegate call to non-contract");
830 
831         (bool success, bytes memory returndata) = target.delegatecall(data);
832         return verifyCallResult(success, returndata, errorMessage);
833     }
834 
835     /**
836      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
837      * revert reason using the provided one.
838      *
839      * _Available since v4.3._
840      */
841     function verifyCallResult(
842         bool success,
843         bytes memory returndata,
844         string memory errorMessage
845     ) internal pure returns (bytes memory) {
846         if (success) {
847             return returndata;
848         } else {
849             // Look for revert reason and bubble it up if present
850             if (returndata.length > 0) {
851                 // The easiest way to bubble the revert reason is using memory via assembly
852 
853                 assembly {
854                     let returndata_size := mload(returndata)
855                     revert(add(32, returndata), returndata_size)
856                 }
857             } else {
858                 revert(errorMessage);
859             }
860         }
861     }
862 }
863 
864 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
865 
866 
867 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
868 
869 pragma solidity ^0.8.0;
870 
871 /**
872  * @title ERC721 token receiver interface
873  * @dev Interface for any contract that wants to support safeTransfers
874  * from ERC721 asset contracts.
875  */
876 interface IERC721Receiver {
877     /**
878      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
879      * by `operator` from `from`, this function is called.
880      *
881      * It must return its Solidity selector to confirm the token transfer.
882      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
883      *
884      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
885      */
886     function onERC721Received(
887         address operator,
888         address from,
889         uint256 tokenId,
890         bytes calldata data
891     ) external returns (bytes4);
892 }
893 
894 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
895 
896 
897 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
898 
899 pragma solidity ^0.8.0;
900 
901 /**
902  * @dev Interface of the ERC165 standard, as defined in the
903  * https://eips.ethereum.org/EIPS/eip-165[EIP].
904  *
905  * Implementers can declare support of contract interfaces, which can then be
906  * queried by others ({ERC165Checker}).
907  *
908  * For an implementation, see {ERC165}.
909  */
910 interface IERC165 {
911     /**
912      * @dev Returns true if this contract implements the interface defined by
913      * `interfaceId`. See the corresponding
914      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
915      * to learn more about how these ids are created.
916      *
917      * This function call must use less than 30 000 gas.
918      */
919     function supportsInterface(bytes4 interfaceId) external view returns (bool);
920 }
921 
922 // File: @openzeppelin/contracts/interfaces/IERC165.sol
923 
924 
925 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
931 
932 
933 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
934 
935 pragma solidity ^0.8.0;
936 
937 
938 /**
939  * @dev Interface for the NFT Royalty Standard.
940  *
941  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
942  * support for royalty payments across all NFT marketplaces and ecosystem participants.
943  *
944  * _Available since v4.5._
945  */
946 interface IERC2981 is IERC165 {
947     /**
948      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
949      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
950      */
951     function royaltyInfo(uint256 tokenId, uint256 salePrice)
952         external
953         view
954         returns (address receiver, uint256 royaltyAmount);
955 }
956 
957 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
958 
959 
960 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 
965 /**
966  * @dev Implementation of the {IERC165} interface.
967  *
968  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
969  * for the additional interface id that will be supported. For example:
970  *
971  * ```solidity
972  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
973  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
974  * }
975  * ```
976  *
977  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
978  */
979 abstract contract ERC165 is IERC165 {
980     /**
981      * @dev See {IERC165-supportsInterface}.
982      */
983     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
984         return interfaceId == type(IERC165).interfaceId;
985     }
986 }
987 
988 // File: @openzeppelin/contracts/token/common/ERC2981.sol
989 
990 
991 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
992 
993 pragma solidity ^0.8.0;
994 
995 
996 
997 /**
998  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
999  *
1000  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1001  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1002  *
1003  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1004  * fee is specified in basis points by default.
1005  *
1006  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1007  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1008  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1009  *
1010  * _Available since v4.5._
1011  */
1012 abstract contract ERC2981 is IERC2981, ERC165 {
1013     struct RoyaltyInfo {
1014         address receiver;
1015         uint96 royaltyFraction;
1016     }
1017 
1018     RoyaltyInfo private _defaultRoyaltyInfo;
1019     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1020 
1021     /**
1022      * @dev See {IERC165-supportsInterface}.
1023      */
1024     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1025         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1026     }
1027 
1028     /**
1029      * @inheritdoc IERC2981
1030      */
1031     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1032         external
1033         view
1034         virtual
1035         override
1036         returns (address, uint256)
1037     {
1038         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1039 
1040         if (royalty.receiver == address(0)) {
1041             royalty = _defaultRoyaltyInfo;
1042         }
1043 
1044         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1045 
1046         return (royalty.receiver, royaltyAmount);
1047     }
1048 
1049     /**
1050      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1051      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1052      * override.
1053      */
1054     function _feeDenominator() internal pure virtual returns (uint96) {
1055         return 10000;
1056     }
1057 
1058     /**
1059      * @dev Sets the royalty information that all ids in this contract will default to.
1060      *
1061      * Requirements:
1062      *
1063      * - `receiver` cannot be the zero address.
1064      * - `feeNumerator` cannot be greater than the fee denominator.
1065      */
1066     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1067         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1068         require(receiver != address(0), "ERC2981: invalid receiver");
1069 
1070         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1071     }
1072 
1073     /**
1074      * @dev Removes default royalty information.
1075      */
1076     function _deleteDefaultRoyalty() internal virtual {
1077         delete _defaultRoyaltyInfo;
1078     }
1079 
1080     /**
1081      * @dev Sets the royalty information for a specific token id, overriding the global default.
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must be already minted.
1086      * - `receiver` cannot be the zero address.
1087      * - `feeNumerator` cannot be greater than the fee denominator.
1088      */
1089     function _setTokenRoyalty(
1090         uint256 tokenId,
1091         address receiver,
1092         uint96 feeNumerator
1093     ) internal virtual {
1094         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1095         require(receiver != address(0), "ERC2981: Invalid parameters");
1096 
1097         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1098     }
1099 
1100     /**
1101      * @dev Resets royalty information for the token id back to the global default.
1102      */
1103     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1104         delete _tokenRoyaltyInfo[tokenId];
1105     }
1106 }
1107 
1108 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1109 
1110 
1111 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 
1116 /**
1117  * @dev Required interface of an ERC721 compliant contract.
1118  */
1119 interface IERC721 is IERC165 {
1120     /**
1121      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1122      */
1123     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1124 
1125     /**
1126      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1127      */
1128     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1129 
1130     /**
1131      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1132      */
1133     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1134 
1135     /**
1136      * @dev Returns the number of tokens in ``owner``'s account.
1137      */
1138     function balanceOf(address owner) external view returns (uint256 balance);
1139 
1140     /**
1141      * @dev Returns the owner of the `tokenId` token.
1142      *
1143      * Requirements:
1144      *
1145      * - `tokenId` must exist.
1146      */
1147     function ownerOf(uint256 tokenId) external view returns (address owner);
1148 
1149     /**
1150      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1151      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1152      *
1153      * Requirements:
1154      *
1155      * - `from` cannot be the zero address.
1156      * - `to` cannot be the zero address.
1157      * - `tokenId` token must exist and be owned by `from`.
1158      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function safeTransferFrom(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) external;
1168 
1169     /**
1170      * @dev Transfers `tokenId` token from `from` to `to`.
1171      *
1172      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1173      *
1174      * Requirements:
1175      *
1176      * - `from` cannot be the zero address.
1177      * - `to` cannot be the zero address.
1178      * - `tokenId` token must be owned by `from`.
1179      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function transferFrom(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) external;
1188 
1189     /**
1190      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1191      * The approval is cleared when the token is transferred.
1192      *
1193      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1194      *
1195      * Requirements:
1196      *
1197      * - The caller must own the token or be an approved operator.
1198      * - `tokenId` must exist.
1199      *
1200      * Emits an {Approval} event.
1201      */
1202     function approve(address to, uint256 tokenId) external;
1203 
1204     /**
1205      * @dev Returns the account approved for `tokenId` token.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must exist.
1210      */
1211     function getApproved(uint256 tokenId) external view returns (address operator);
1212 
1213     /**
1214      * @dev Approve or remove `operator` as an operator for the caller.
1215      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1216      *
1217      * Requirements:
1218      *
1219      * - The `operator` cannot be the caller.
1220      *
1221      * Emits an {ApprovalForAll} event.
1222      */
1223     function setApprovalForAll(address operator, bool _approved) external;
1224 
1225     /**
1226      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1227      *
1228      * See {setApprovalForAll}
1229      */
1230     function isApprovedForAll(address owner, address operator) external view returns (bool);
1231 
1232     /**
1233      * @dev Safely transfers `tokenId` token from `from` to `to`.
1234      *
1235      * Requirements:
1236      *
1237      * - `from` cannot be the zero address.
1238      * - `to` cannot be the zero address.
1239      * - `tokenId` token must exist and be owned by `from`.
1240      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1241      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function safeTransferFrom(
1246         address from,
1247         address to,
1248         uint256 tokenId,
1249         bytes calldata data
1250     ) external;
1251 }
1252 
1253 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1254 
1255 
1256 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 
1261 /**
1262  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1263  * @dev See https://eips.ethereum.org/EIPS/eip-721
1264  */
1265 interface IERC721Enumerable is IERC721 {
1266     /**
1267      * @dev Returns the total amount of tokens stored by the contract.
1268      */
1269     function totalSupply() external view returns (uint256);
1270 
1271     /**
1272      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1273      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1274      */
1275     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1276 
1277     /**
1278      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1279      * Use along with {totalSupply} to enumerate all tokens.
1280      */
1281     function tokenByIndex(uint256 index) external view returns (uint256);
1282 }
1283 
1284 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1285 
1286 
1287 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1288 
1289 pragma solidity ^0.8.0;
1290 
1291 
1292 /**
1293  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1294  * @dev See https://eips.ethereum.org/EIPS/eip-721
1295  */
1296 interface IERC721Metadata is IERC721 {
1297     /**
1298      * @dev Returns the token collection name.
1299      */
1300     function name() external view returns (string memory);
1301 
1302     /**
1303      * @dev Returns the token collection symbol.
1304      */
1305     function symbol() external view returns (string memory);
1306 
1307     /**
1308      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1309      */
1310     function tokenURI(uint256 tokenId) external view returns (string memory);
1311 }
1312 
1313 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1314 
1315 
1316 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1317 
1318 pragma solidity ^0.8.0;
1319 
1320 
1321 
1322 
1323 
1324 
1325 
1326 
1327 /**
1328  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1329  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1330  * {ERC721Enumerable}.
1331  */
1332 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1333     using Address for address;
1334     using Strings for uint256;
1335 
1336     // Token name
1337     string private _name;
1338 
1339     // Token symbol
1340     string private _symbol;
1341 
1342     // Mapping from token ID to owner address
1343     mapping(uint256 => address) private _owners;
1344 
1345     // Mapping owner address to token count
1346     mapping(address => uint256) private _balances;
1347 
1348     // Mapping from token ID to approved address
1349     mapping(uint256 => address) private _tokenApprovals;
1350 
1351     // Mapping from owner to operator approvals
1352     mapping(address => mapping(address => bool)) private _operatorApprovals;
1353 
1354     /**
1355      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1356      */
1357     constructor(string memory name_, string memory symbol_) {
1358         _name = name_;
1359         _symbol = symbol_;
1360     }
1361 
1362     /**
1363      * @dev See {IERC165-supportsInterface}.
1364      */
1365     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1366         return
1367             interfaceId == type(IERC721).interfaceId ||
1368             interfaceId == type(IERC721Metadata).interfaceId ||
1369             super.supportsInterface(interfaceId);
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-balanceOf}.
1374      */
1375     function balanceOf(address owner) public view virtual override returns (uint256) {
1376         require(owner != address(0), "ERC721: balance query for the zero address");
1377         return _balances[owner];
1378     }
1379 
1380     /**
1381      * @dev See {IERC721-ownerOf}.
1382      */
1383     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1384         address owner = _owners[tokenId];
1385         require(owner != address(0), "ERC721: owner query for nonexistent token");
1386         return owner;
1387     }
1388 
1389     /**
1390      * @dev See {IERC721Metadata-name}.
1391      */
1392     function name() public view virtual override returns (string memory) {
1393         return _name;
1394     }
1395 
1396     /**
1397      * @dev See {IERC721Metadata-symbol}.
1398      */
1399     function symbol() public view virtual override returns (string memory) {
1400         return _symbol;
1401     }
1402 
1403     /**
1404      * @dev See {IERC721Metadata-tokenURI}.
1405      */
1406     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1407         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1408 
1409         string memory baseURI = _baseURI();
1410         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1411     }
1412 
1413     /**
1414      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1415      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1416      * by default, can be overriden in child contracts.
1417      */
1418     function _baseURI() internal view virtual returns (string memory) {
1419         return "";
1420     }
1421 
1422     /**
1423      * @dev See {IERC721-approve}.
1424      */
1425     function approve(address to, uint256 tokenId) public virtual override {
1426         address owner = ERC721.ownerOf(tokenId);
1427         require(to != owner, "ERC721: approval to current owner");
1428 
1429         require(
1430             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1431             "ERC721: approve caller is not owner nor approved for all"
1432         );
1433 
1434         _approve(to, tokenId);
1435     }
1436 
1437     /**
1438      * @dev See {IERC721-getApproved}.
1439      */
1440     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1441         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1442 
1443         return _tokenApprovals[tokenId];
1444     }
1445 
1446     /**
1447      * @dev See {IERC721-setApprovalForAll}.
1448      */
1449     function setApprovalForAll(address operator, bool approved) public virtual override {
1450         _setApprovalForAll(_msgSender(), operator, approved);
1451     }
1452 
1453     /**
1454      * @dev See {IERC721-isApprovedForAll}.
1455      */
1456     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1457         return _operatorApprovals[owner][operator];
1458     }
1459 
1460     /**
1461      * @dev See {IERC721-transferFrom}.
1462      */
1463     function transferFrom(
1464         address from,
1465         address to,
1466         uint256 tokenId
1467     ) public virtual override {
1468         //solhint-disable-next-line max-line-length
1469         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1470 
1471         _transfer(from, to, tokenId);
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-safeTransferFrom}.
1476      */
1477     function safeTransferFrom(
1478         address from,
1479         address to,
1480         uint256 tokenId
1481     ) public virtual override {
1482         safeTransferFrom(from, to, tokenId, "");
1483     }
1484 
1485     /**
1486      * @dev See {IERC721-safeTransferFrom}.
1487      */
1488     function safeTransferFrom(
1489         address from,
1490         address to,
1491         uint256 tokenId,
1492         bytes memory _data
1493     ) public virtual override {
1494         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1495         _safeTransfer(from, to, tokenId, _data);
1496     }
1497 
1498     /**
1499      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1500      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1501      *
1502      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1503      *
1504      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1505      * implement alternative mechanisms to perform token transfer, such as signature-based.
1506      *
1507      * Requirements:
1508      *
1509      * - `from` cannot be the zero address.
1510      * - `to` cannot be the zero address.
1511      * - `tokenId` token must exist and be owned by `from`.
1512      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1513      *
1514      * Emits a {Transfer} event.
1515      */
1516     function _safeTransfer(
1517         address from,
1518         address to,
1519         uint256 tokenId,
1520         bytes memory _data
1521     ) internal virtual {
1522         _transfer(from, to, tokenId);
1523         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1524     }
1525 
1526     /**
1527      * @dev Returns whether `tokenId` exists.
1528      *
1529      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1530      *
1531      * Tokens start existing when they are minted (`_mint`),
1532      * and stop existing when they are burned (`_burn`).
1533      */
1534     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1535         return _owners[tokenId] != address(0);
1536     }
1537 
1538     /**
1539      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1540      *
1541      * Requirements:
1542      *
1543      * - `tokenId` must exist.
1544      */
1545     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1546         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1547         address owner = ERC721.ownerOf(tokenId);
1548         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1549     }
1550 
1551     /**
1552      * @dev Safely mints `tokenId` and transfers it to `to`.
1553      *
1554      * Requirements:
1555      *
1556      * - `tokenId` must not exist.
1557      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1558      *
1559      * Emits a {Transfer} event.
1560      */
1561     function _safeMint(address to, uint256 tokenId) internal virtual {
1562         _safeMint(to, tokenId, "");
1563     }
1564 
1565     /**
1566      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1567      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1568      */
1569     function _safeMint(
1570         address to,
1571         uint256 tokenId,
1572         bytes memory _data
1573     ) internal virtual {
1574         _mint(to, tokenId);
1575         require(
1576             _checkOnERC721Received(address(0), to, tokenId, _data),
1577             "ERC721: transfer to non ERC721Receiver implementer"
1578         );
1579     }
1580 
1581     /**
1582      * @dev Mints `tokenId` and transfers it to `to`.
1583      *
1584      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1585      *
1586      * Requirements:
1587      *
1588      * - `tokenId` must not exist.
1589      * - `to` cannot be the zero address.
1590      *
1591      * Emits a {Transfer} event.
1592      */
1593     function _mint(address to, uint256 tokenId) internal virtual {
1594         require(to != address(0), "ERC721: mint to the zero address");
1595         require(!_exists(tokenId), "ERC721: token already minted");
1596 
1597         _beforeTokenTransfer(address(0), to, tokenId);
1598 
1599         _balances[to] += 1;
1600         _owners[tokenId] = to;
1601 
1602         emit Transfer(address(0), to, tokenId);
1603 
1604         _afterTokenTransfer(address(0), to, tokenId);
1605     }
1606 
1607     /**
1608      * @dev Destroys `tokenId`.
1609      * The approval is cleared when the token is burned.
1610      *
1611      * Requirements:
1612      *
1613      * - `tokenId` must exist.
1614      *
1615      * Emits a {Transfer} event.
1616      */
1617     function _burn(uint256 tokenId) internal virtual {
1618         address owner = ERC721.ownerOf(tokenId);
1619 
1620         _beforeTokenTransfer(owner, address(0), tokenId);
1621 
1622         // Clear approvals
1623         _approve(address(0), tokenId);
1624 
1625         _balances[owner] -= 1;
1626         delete _owners[tokenId];
1627 
1628         emit Transfer(owner, address(0), tokenId);
1629 
1630         _afterTokenTransfer(owner, address(0), tokenId);
1631     }
1632 
1633     /**
1634      * @dev Transfers `tokenId` from `from` to `to`.
1635      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1636      *
1637      * Requirements:
1638      *
1639      * - `to` cannot be the zero address.
1640      * - `tokenId` token must be owned by `from`.
1641      *
1642      * Emits a {Transfer} event.
1643      */
1644     function _transfer(
1645         address from,
1646         address to,
1647         uint256 tokenId
1648     ) internal virtual {
1649         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1650         require(to != address(0), "ERC721: transfer to the zero address");
1651 
1652         _beforeTokenTransfer(from, to, tokenId);
1653 
1654         // Clear approvals from the previous owner
1655         _approve(address(0), tokenId);
1656 
1657         _balances[from] -= 1;
1658         _balances[to] += 1;
1659         _owners[tokenId] = to;
1660 
1661         emit Transfer(from, to, tokenId);
1662 
1663         _afterTokenTransfer(from, to, tokenId);
1664     }
1665 
1666     /**
1667      * @dev Approve `to` to operate on `tokenId`
1668      *
1669      * Emits a {Approval} event.
1670      */
1671     function _approve(address to, uint256 tokenId) internal virtual {
1672         _tokenApprovals[tokenId] = to;
1673         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1674     }
1675 
1676     /**
1677      * @dev Approve `operator` to operate on all of `owner` tokens
1678      *
1679      * Emits a {ApprovalForAll} event.
1680      */
1681     function _setApprovalForAll(
1682         address owner,
1683         address operator,
1684         bool approved
1685     ) internal virtual {
1686         require(owner != operator, "ERC721: approve to caller");
1687         _operatorApprovals[owner][operator] = approved;
1688         emit ApprovalForAll(owner, operator, approved);
1689     }
1690 
1691     /**
1692      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1693      * The call is not executed if the target address is not a contract.
1694      *
1695      * @param from address representing the previous owner of the given token ID
1696      * @param to target address that will receive the tokens
1697      * @param tokenId uint256 ID of the token to be transferred
1698      * @param _data bytes optional data to send along with the call
1699      * @return bool whether the call correctly returned the expected magic value
1700      */
1701     function _checkOnERC721Received(
1702         address from,
1703         address to,
1704         uint256 tokenId,
1705         bytes memory _data
1706     ) private returns (bool) {
1707         if (to.isContract()) {
1708             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1709                 return retval == IERC721Receiver.onERC721Received.selector;
1710             } catch (bytes memory reason) {
1711                 if (reason.length == 0) {
1712                     revert("ERC721: transfer to non ERC721Receiver implementer");
1713                 } else {
1714                     assembly {
1715                         revert(add(32, reason), mload(reason))
1716                     }
1717                 }
1718             }
1719         } else {
1720             return true;
1721         }
1722     }
1723 
1724     /**
1725      * @dev Hook that is called before any token transfer. This includes minting
1726      * and burning.
1727      *
1728      * Calling conditions:
1729      *
1730      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1731      * transferred to `to`.
1732      * - When `from` is zero, `tokenId` will be minted for `to`.
1733      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1734      * - `from` and `to` are never both zero.
1735      *
1736      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1737      */
1738     function _beforeTokenTransfer(
1739         address from,
1740         address to,
1741         uint256 tokenId
1742     ) internal virtual {}
1743 
1744     /**
1745      * @dev Hook that is called after any transfer of tokens. This includes
1746      * minting and burning.
1747      *
1748      * Calling conditions:
1749      *
1750      * - when `from` and `to` are both non-zero.
1751      * - `from` and `to` are never both zero.
1752      *
1753      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1754      */
1755     function _afterTokenTransfer(
1756         address from,
1757         address to,
1758         uint256 tokenId
1759     ) internal virtual {}
1760 }
1761 
1762 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol
1763 
1764 
1765 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/ERC721Royalty.sol)
1766 
1767 pragma solidity ^0.8.0;
1768 
1769 
1770 
1771 
1772 /**
1773  * @dev Extension of ERC721 with the ERC2981 NFT Royalty Standard, a standardized way to retrieve royalty payment
1774  * information.
1775  *
1776  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1777  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1778  *
1779  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1780  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1781  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1782  *
1783  * _Available since v4.5._
1784  */
1785 abstract contract ERC721Royalty is ERC2981, ERC721 {
1786     /**
1787      * @dev See {IERC165-supportsInterface}.
1788      */
1789     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
1790         return super.supportsInterface(interfaceId);
1791     }
1792 
1793     /**
1794      * @dev See {ERC721-_burn}. This override additionally clears the royalty information for the token.
1795      */
1796     function _burn(uint256 tokenId) internal virtual override {
1797         super._burn(tokenId);
1798         _resetTokenRoyalty(tokenId);
1799     }
1800 }
1801 
1802 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1803 
1804 
1805 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1806 
1807 pragma solidity ^0.8.0;
1808 
1809 
1810 
1811 /**
1812  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1813  * enumerability of all the token ids in the contract as well as all token ids owned by each
1814  * account.
1815  */
1816 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1817     // Mapping from owner to list of owned token IDs
1818     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1819 
1820     // Mapping from token ID to index of the owner tokens list
1821     mapping(uint256 => uint256) private _ownedTokensIndex;
1822 
1823     // Array with all token ids, used for enumeration
1824     uint256[] private _allTokens;
1825 
1826     // Mapping from token id to position in the allTokens array
1827     mapping(uint256 => uint256) private _allTokensIndex;
1828 
1829     /**
1830      * @dev See {IERC165-supportsInterface}.
1831      */
1832     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1833         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1834     }
1835 
1836     /**
1837      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1838      */
1839     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1840         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1841         return _ownedTokens[owner][index];
1842     }
1843 
1844     /**
1845      * @dev See {IERC721Enumerable-totalSupply}.
1846      */
1847     function totalSupply() public view virtual override returns (uint256) {
1848         return _allTokens.length;
1849     }
1850 
1851     /**
1852      * @dev See {IERC721Enumerable-tokenByIndex}.
1853      */
1854     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1855         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1856         return _allTokens[index];
1857     }
1858 
1859     /**
1860      * @dev Hook that is called before any token transfer. This includes minting
1861      * and burning.
1862      *
1863      * Calling conditions:
1864      *
1865      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1866      * transferred to `to`.
1867      * - When `from` is zero, `tokenId` will be minted for `to`.
1868      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1869      * - `from` cannot be the zero address.
1870      * - `to` cannot be the zero address.
1871      *
1872      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1873      */
1874     function _beforeTokenTransfer(
1875         address from,
1876         address to,
1877         uint256 tokenId
1878     ) internal virtual override {
1879         super._beforeTokenTransfer(from, to, tokenId);
1880 
1881         if (from == address(0)) {
1882             _addTokenToAllTokensEnumeration(tokenId);
1883         } else if (from != to) {
1884             _removeTokenFromOwnerEnumeration(from, tokenId);
1885         }
1886         if (to == address(0)) {
1887             _removeTokenFromAllTokensEnumeration(tokenId);
1888         } else if (to != from) {
1889             _addTokenToOwnerEnumeration(to, tokenId);
1890         }
1891     }
1892 
1893     /**
1894      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1895      * @param to address representing the new owner of the given token ID
1896      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1897      */
1898     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1899         uint256 length = ERC721.balanceOf(to);
1900         _ownedTokens[to][length] = tokenId;
1901         _ownedTokensIndex[tokenId] = length;
1902     }
1903 
1904     /**
1905      * @dev Private function to add a token to this extension's token tracking data structures.
1906      * @param tokenId uint256 ID of the token to be added to the tokens list
1907      */
1908     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1909         _allTokensIndex[tokenId] = _allTokens.length;
1910         _allTokens.push(tokenId);
1911     }
1912 
1913     /**
1914      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1915      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1916      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1917      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1918      * @param from address representing the previous owner of the given token ID
1919      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1920      */
1921     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1922         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1923         // then delete the last slot (swap and pop).
1924 
1925         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1926         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1927 
1928         // When the token to delete is the last token, the swap operation is unnecessary
1929         if (tokenIndex != lastTokenIndex) {
1930             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1931 
1932             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1933             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1934         }
1935 
1936         // This also deletes the contents at the last position of the array
1937         delete _ownedTokensIndex[tokenId];
1938         delete _ownedTokens[from][lastTokenIndex];
1939     }
1940 
1941     /**
1942      * @dev Private function to remove a token from this extension's token tracking data structures.
1943      * This has O(1) time complexity, but alters the order of the _allTokens array.
1944      * @param tokenId uint256 ID of the token to be removed from the tokens list
1945      */
1946     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1947         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1948         // then delete the last slot (swap and pop).
1949 
1950         uint256 lastTokenIndex = _allTokens.length - 1;
1951         uint256 tokenIndex = _allTokensIndex[tokenId];
1952 
1953         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1954         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1955         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1956         uint256 lastTokenId = _allTokens[lastTokenIndex];
1957 
1958         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1959         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1960 
1961         // This also deletes the contents at the last position of the array
1962         delete _allTokensIndex[tokenId];
1963         _allTokens.pop();
1964     }
1965 }
1966 
1967 // File: contracts/SpermNFT.sol
1968 
1969 
1970 pragma solidity >=0.7.0 <0.9.0;
1971 
1972 
1973 
1974 
1975 
1976 
1977 contract SpermNFT is ERC721Enumerable, Ownable, ERC721Royalty {
1978     using Strings for uint256;
1979     using SafeMath for uint256;
1980     using ECDSA for bytes32;
1981 
1982     string public baseURI;
1983     string private _baseExtension = ".json";
1984     string private _notRevealedUri;
1985     string private _contractURI;
1986     uint256 public cost = 0 ether; //price for 1 nft
1987     uint256 public maxSupply = 1000; // number of nft in the collection
1988     uint256 public maxMintAmount = 1;
1989     uint256 public nftPerAddressLimit = 1;
1990     bool public paused = false;
1991     bool public revealed = false;
1992     bool public onlyWhitelisted = true;
1993     mapping(address => uint256) public addressMintedBalance;
1994     uint8 private _og = 2;
1995     uint8 private _wl = 1;
1996 
1997     constructor() ERC721("SpermNFT", "SPERM") {
1998         setBaseURI("ipfs://QmWagEWb2WA6HVuJrYgu64Jc5mFbWczvBiDRhuJE279Fkb/");
1999         setNotRevealedURI("ipfs://Qmcsk5Ex362ok7wpFxNgsdyWNZZN1fPiiohftDn9FchuUR");
2000         _setDefaultRoyalty(owner(), 1000);
2001         setContractURI("ipfs://QmNie8dNLnzGhC9K6aGWR3j5fnHLJGD4mT21BhwDx2vk4X");
2002     }
2003 
2004     function contractURI() public view returns (string memory) {
2005         return _contractURI;
2006     }
2007 
2008     function setContractURI(string memory _URI) public onlyOwner {
2009         _contractURI = _URI;
2010     }
2011 
2012     // internal
2013     function _baseURI() internal view virtual override returns (string memory) {
2014         return baseURI;
2015     }
2016 
2017     function supportsInterface(bytes4 interfaceId)
2018         public
2019         view
2020         virtual
2021         override(ERC721Enumerable, ERC721Royalty)
2022         returns (bool)
2023     {
2024         return super.supportsInterface(interfaceId);
2025     }
2026 
2027     function _beforeTokenTransfer(
2028         address from,
2029         address to,
2030         uint256 tokenId
2031     ) internal override(ERC721, ERC721Enumerable) {
2032         super._beforeTokenTransfer(from, to, tokenId);
2033     }
2034 
2035     function _burn(uint256 tokenId)
2036         internal
2037         virtual
2038         override(ERC721, ERC721Royalty)
2039     {
2040         super._burn(tokenId);
2041         _resetTokenRoyalty(tokenId);
2042     }
2043 
2044     function setMaxSupply(uint256 _amount) public onlyOwner {
2045         maxSupply = _amount;
2046     }
2047 
2048     function mint(uint256 _mintAmount, bytes memory _signature) public payable {
2049         require(!paused, "the contract is paused");
2050         uint256 supply = totalSupply();
2051         require(_mintAmount > 0, "need to mint at least 1 NFT");
2052         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
2053         uint256 maxMint = maxMintAmount;
2054         uint256 nftPerAdress = nftPerAddressLimit;
2055 
2056         if (msg.sender != owner()) {
2057             if (onlyWhitelisted == true) {
2058                 if (!isOGListed(_signature)) {
2059                     require(
2060                         isWhitelisted(_signature),
2061                         "user is not whitelisted"
2062                     );
2063                 } else {
2064                     maxMint = 2;
2065                     nftPerAdress = 2;
2066                 }
2067 
2068                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
2069                 require(
2070                     ownerMintedCount + _mintAmount <= nftPerAdress,
2071                     "max NFT per address exceeded"
2072                 );
2073             }
2074 
2075             require(
2076                 _mintAmount <= maxMint,
2077                 "max mint amount per session exceeded"
2078             );
2079             require(msg.value >= cost * _mintAmount, "insufficient funds!");
2080         }
2081 
2082         for (uint256 i = 1; i <= _mintAmount; i++) {
2083             addressMintedBalance[msg.sender]++;
2084             _safeMint(msg.sender, supply + i);
2085         }
2086     }
2087 
2088     function isMessageValid(bytes memory _signature, uint8 _nonce)
2089         public
2090         view
2091         returns (address, bool)
2092     {
2093         bytes32 messagehash = keccak256(
2094             abi.encodePacked(address(this), msg.sender, _nonce)
2095         );
2096         address signer = messagehash.toEthSignedMessageHash().recover(
2097             _signature
2098         );
2099 
2100         if (msg.sender == signer) {
2101             return (signer, true);
2102         } else {
2103             return (signer, false);
2104         }
2105     }
2106 
2107     function isWhitelisted(bytes memory _signature) public view returns (bool) {
2108         (, bool success) = isMessageValid(_signature, _wl);
2109         return success;
2110     }
2111 
2112     function isOGListed(bytes memory _signature) private view returns (bool) {
2113         (, bool success) = isMessageValid(_signature, _og);
2114         return success;
2115     }
2116 
2117     function walletOfOwner(address _owner)
2118         public
2119         view
2120         returns (uint256[] memory)
2121     {
2122         uint256 ownerTokenCount = balanceOf(_owner);
2123         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2124         for (uint256 i; i < ownerTokenCount; i++) {
2125             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
2126         }
2127         return tokenIds;
2128     }
2129 
2130     function tokenURI(uint256 tokenId)
2131         public
2132         view
2133         virtual
2134         override
2135         returns (string memory)
2136     {
2137         require(
2138             _exists(tokenId),
2139             "ERC721Metadata: URI query for nonexistent token"
2140         );
2141 
2142         if (revealed == false) {
2143             return _notRevealedUri;
2144         }
2145 
2146         string memory currentBaseURI = _baseURI();
2147         return
2148             bytes(currentBaseURI).length > 0
2149                 ? string(
2150                     abi.encodePacked(
2151                         currentBaseURI,
2152                         tokenId.toString(),
2153                         _baseExtension
2154                     )
2155                 )
2156                 : "";
2157     }
2158 
2159     //only owner
2160     function reveal() public onlyOwner {
2161         revealed = true;
2162     }
2163 
2164     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
2165         nftPerAddressLimit = _limit;
2166     }
2167 
2168     function setCost(uint256 _newCost) public onlyOwner {
2169         cost = _newCost;
2170     }
2171 
2172     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
2173         maxMintAmount = _newmaxMintAmount;
2174     }
2175 
2176     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2177         baseURI = _newBaseURI;
2178     }
2179 
2180     function setBaseExtension(string memory _newBaseExtension)
2181         public
2182         onlyOwner
2183     {
2184         _baseExtension = _newBaseExtension;
2185     }
2186 
2187     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2188         _notRevealedUri = _notRevealedURI;
2189     }
2190 
2191     function pause(bool _state) public onlyOwner {
2192         paused = _state;
2193     }
2194 
2195     function setOnlyWhitelisted(bool _state) public onlyOwner {
2196         onlyWhitelisted = _state;
2197         if (onlyWhitelisted) maxMintAmount = 1;
2198         else maxMintAmount = 10;
2199     }
2200 
2201     function withdraw() external onlyOwner {
2202         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2203         require(os);
2204     }
2205 
2206     function getBalance() public view onlyOwner returns (uint256) {
2207         return address(this).balance;
2208     }
2209 }