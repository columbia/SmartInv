1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Strings.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev String operations.
240  */
241 library Strings {
242     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
243 
244     /**
245      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
246      */
247     function toString(uint256 value) internal pure returns (string memory) {
248         // Inspired by OraclizeAPI's implementation - MIT licence
249         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
250 
251         if (value == 0) {
252             return "0";
253         }
254         uint256 temp = value;
255         uint256 digits;
256         while (temp != 0) {
257             digits++;
258             temp /= 10;
259         }
260         bytes memory buffer = new bytes(digits);
261         while (value != 0) {
262             digits -= 1;
263             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
264             value /= 10;
265         }
266         return string(buffer);
267     }
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
271      */
272     function toHexString(uint256 value) internal pure returns (string memory) {
273         if (value == 0) {
274             return "0x00";
275         }
276         uint256 temp = value;
277         uint256 length = 0;
278         while (temp != 0) {
279             length++;
280             temp >>= 8;
281         }
282         return toHexString(value, length);
283     }
284 
285     /**
286      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
287      */
288     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
289         bytes memory buffer = new bytes(2 * length + 2);
290         buffer[0] = "0";
291         buffer[1] = "x";
292         for (uint256 i = 2 * length + 1; i > 1; --i) {
293             buffer[i] = _HEX_SYMBOLS[value & 0xf];
294             value >>= 4;
295         }
296         require(value == 0, "Strings: hex length insufficient");
297         return string(buffer);
298     }
299 }
300 
301 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
302 
303 
304 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 
309 /**
310  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
311  *
312  * These functions can be used to verify that a message was signed by the holder
313  * of the private keys of a given address.
314  */
315 library ECDSA {
316     enum RecoverError {
317         NoError,
318         InvalidSignature,
319         InvalidSignatureLength,
320         InvalidSignatureS,
321         InvalidSignatureV
322     }
323 
324     function _throwError(RecoverError error) private pure {
325         if (error == RecoverError.NoError) {
326             return; // no error: do nothing
327         } else if (error == RecoverError.InvalidSignature) {
328             revert("ECDSA: invalid signature");
329         } else if (error == RecoverError.InvalidSignatureLength) {
330             revert("ECDSA: invalid signature length");
331         } else if (error == RecoverError.InvalidSignatureS) {
332             revert("ECDSA: invalid signature 's' value");
333         } else if (error == RecoverError.InvalidSignatureV) {
334             revert("ECDSA: invalid signature 'v' value");
335         }
336     }
337 
338     /**
339      * @dev Returns the address that signed a hashed message (`hash`) with
340      * `signature` or error string. This address can then be used for verification purposes.
341      *
342      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
343      * this function rejects them by requiring the `s` value to be in the lower
344      * half order, and the `v` value to be either 27 or 28.
345      *
346      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
347      * verification to be secure: it is possible to craft signatures that
348      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
349      * this is by receiving a hash of the original message (which may otherwise
350      * be too long), and then calling {toEthSignedMessageHash} on it.
351      *
352      * Documentation for signature generation:
353      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
354      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
355      *
356      * _Available since v4.3._
357      */
358     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
359         // Check the signature length
360         // - case 65: r,s,v signature (standard)
361         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
362         if (signature.length == 65) {
363             bytes32 r;
364             bytes32 s;
365             uint8 v;
366             // ecrecover takes the signature parameters, and the only way to get them
367             // currently is to use assembly.
368             assembly {
369                 r := mload(add(signature, 0x20))
370                 s := mload(add(signature, 0x40))
371                 v := byte(0, mload(add(signature, 0x60)))
372             }
373             return tryRecover(hash, v, r, s);
374         } else if (signature.length == 64) {
375             bytes32 r;
376             bytes32 vs;
377             // ecrecover takes the signature parameters, and the only way to get them
378             // currently is to use assembly.
379             assembly {
380                 r := mload(add(signature, 0x20))
381                 vs := mload(add(signature, 0x40))
382             }
383             return tryRecover(hash, r, vs);
384         } else {
385             return (address(0), RecoverError.InvalidSignatureLength);
386         }
387     }
388 
389     /**
390      * @dev Returns the address that signed a hashed message (`hash`) with
391      * `signature`. This address can then be used for verification purposes.
392      *
393      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
394      * this function rejects them by requiring the `s` value to be in the lower
395      * half order, and the `v` value to be either 27 or 28.
396      *
397      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
398      * verification to be secure: it is possible to craft signatures that
399      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
400      * this is by receiving a hash of the original message (which may otherwise
401      * be too long), and then calling {toEthSignedMessageHash} on it.
402      */
403     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
404         (address recovered, RecoverError error) = tryRecover(hash, signature);
405         _throwError(error);
406         return recovered;
407     }
408 
409     /**
410      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
411      *
412      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
413      *
414      * _Available since v4.3._
415      */
416     function tryRecover(
417         bytes32 hash,
418         bytes32 r,
419         bytes32 vs
420     ) internal pure returns (address, RecoverError) {
421         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
422         uint8 v = uint8((uint256(vs) >> 255) + 27);
423         return tryRecover(hash, v, r, s);
424     }
425 
426     /**
427      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
428      *
429      * _Available since v4.2._
430      */
431     function recover(
432         bytes32 hash,
433         bytes32 r,
434         bytes32 vs
435     ) internal pure returns (address) {
436         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
437         _throwError(error);
438         return recovered;
439     }
440 
441     /**
442      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
443      * `r` and `s` signature fields separately.
444      *
445      * _Available since v4.3._
446      */
447     function tryRecover(
448         bytes32 hash,
449         uint8 v,
450         bytes32 r,
451         bytes32 s
452     ) internal pure returns (address, RecoverError) {
453         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
454         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
455         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
456         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
457         //
458         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
459         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
460         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
461         // these malleable signatures as well.
462         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
463             return (address(0), RecoverError.InvalidSignatureS);
464         }
465         if (v != 27 && v != 28) {
466             return (address(0), RecoverError.InvalidSignatureV);
467         }
468 
469         // If the signature is valid (and not malleable), return the signer address
470         address signer = ecrecover(hash, v, r, s);
471         if (signer == address(0)) {
472             return (address(0), RecoverError.InvalidSignature);
473         }
474 
475         return (signer, RecoverError.NoError);
476     }
477 
478     /**
479      * @dev Overload of {ECDSA-recover} that receives the `v`,
480      * `r` and `s` signature fields separately.
481      */
482     function recover(
483         bytes32 hash,
484         uint8 v,
485         bytes32 r,
486         bytes32 s
487     ) internal pure returns (address) {
488         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
489         _throwError(error);
490         return recovered;
491     }
492 
493     /**
494      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
495      * produces hash corresponding to the one signed with the
496      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
497      * JSON-RPC method as part of EIP-191.
498      *
499      * See {recover}.
500      */
501     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
502         // 32 is the length in bytes of hash,
503         // enforced by the type signature above
504         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
505     }
506 
507     /**
508      * @dev Returns an Ethereum Signed Message, created from `s`. This
509      * produces hash corresponding to the one signed with the
510      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
511      * JSON-RPC method as part of EIP-191.
512      *
513      * See {recover}.
514      */
515     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
516         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
517     }
518 
519     /**
520      * @dev Returns an Ethereum Signed Typed Data, created from a
521      * `domainSeparator` and a `structHash`. This produces hash corresponding
522      * to the one signed with the
523      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
524      * JSON-RPC method as part of EIP-712.
525      *
526      * See {recover}.
527      */
528     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
529         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
530     }
531 }
532 
533 // File: @openzeppelin/contracts/utils/Context.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev Provides information about the current execution context, including the
542  * sender of the transaction and its data. While these are generally available
543  * via msg.sender and msg.data, they should not be accessed in such a direct
544  * manner, since when dealing with meta-transactions the account sending and
545  * paying for execution may not be the actual sender (as far as an application
546  * is concerned).
547  *
548  * This contract is only required for intermediate, library-like contracts.
549  */
550 abstract contract Context {
551     function _msgSender() internal view virtual returns (address) {
552         return msg.sender;
553     }
554 
555     function _msgData() internal view virtual returns (bytes calldata) {
556         return msg.data;
557     }
558 }
559 
560 // File: @openzeppelin/contracts/access/Ownable.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @dev Contract module which provides a basic access control mechanism, where
570  * there is an account (an owner) that can be granted exclusive access to
571  * specific functions.
572  *
573  * By default, the owner account will be the one that deploys the contract. This
574  * can later be changed with {transferOwnership}.
575  *
576  * This module is used through inheritance. It will make available the modifier
577  * `onlyOwner`, which can be applied to your functions to restrict their use to
578  * the owner.
579  */
580 abstract contract Ownable is Context {
581     address private _owner;
582 
583     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
584 
585     /**
586      * @dev Initializes the contract setting the deployer as the initial owner.
587      */
588     constructor() {
589         _transferOwnership(_msgSender());
590     }
591 
592     /**
593      * @dev Returns the address of the current owner.
594      */
595     function owner() public view virtual returns (address) {
596         return _owner;
597     }
598 
599     /**
600      * @dev Throws if called by any account other than the owner.
601      */
602     modifier onlyOwner() {
603         require(owner() == _msgSender(), "Ownable: caller is not the owner");
604         _;
605     }
606 
607     /**
608      * @dev Leaves the contract without owner. It will not be possible to call
609      * `onlyOwner` functions anymore. Can only be called by the current owner.
610      *
611      * NOTE: Renouncing ownership will leave the contract without an owner,
612      * thereby removing any functionality that is only available to the owner.
613      */
614     function renounceOwnership() public virtual onlyOwner {
615         _transferOwnership(address(0));
616     }
617 
618     /**
619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
620      * Can only be called by the current owner.
621      */
622     function transferOwnership(address newOwner) public virtual onlyOwner {
623         require(newOwner != address(0), "Ownable: new owner is the zero address");
624         _transferOwnership(newOwner);
625     }
626 
627     /**
628      * @dev Transfers ownership of the contract to a new account (`newOwner`).
629      * Internal function without access restriction.
630      */
631     function _transferOwnership(address newOwner) internal virtual {
632         address oldOwner = _owner;
633         _owner = newOwner;
634         emit OwnershipTransferred(oldOwner, newOwner);
635     }
636 }
637 
638 // File: @openzeppelin/contracts/utils/Address.sol
639 
640 
641 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
642 
643 pragma solidity ^0.8.1;
644 
645 /**
646  * @dev Collection of functions related to the address type
647  */
648 library Address {
649     /**
650      * @dev Returns true if `account` is a contract.
651      *
652      * [IMPORTANT]
653      * ====
654      * It is unsafe to assume that an address for which this function returns
655      * false is an externally-owned account (EOA) and not a contract.
656      *
657      * Among others, `isContract` will return false for the following
658      * types of addresses:
659      *
660      *  - an externally-owned account
661      *  - a contract in construction
662      *  - an address where a contract will be created
663      *  - an address where a contract lived, but was destroyed
664      * ====
665      *
666      * [IMPORTANT]
667      * ====
668      * You shouldn't rely on `isContract` to protect against flash loan attacks!
669      *
670      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
671      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
672      * constructor.
673      * ====
674      */
675     function isContract(address account) internal view returns (bool) {
676         // This method relies on extcodesize/address.code.length, which returns 0
677         // for contracts in construction, since the code is only stored at the end
678         // of the constructor execution.
679 
680         return account.code.length > 0;
681     }
682 
683     /**
684      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
685      * `recipient`, forwarding all available gas and reverting on errors.
686      *
687      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
688      * of certain opcodes, possibly making contracts go over the 2300 gas limit
689      * imposed by `transfer`, making them unable to receive funds via
690      * `transfer`. {sendValue} removes this limitation.
691      *
692      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
693      *
694      * IMPORTANT: because control is transferred to `recipient`, care must be
695      * taken to not create reentrancy vulnerabilities. Consider using
696      * {ReentrancyGuard} or the
697      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
698      */
699     function sendValue(address payable recipient, uint256 amount) internal {
700         require(address(this).balance >= amount, "Address: insufficient balance");
701 
702         (bool success, ) = recipient.call{value: amount}("");
703         require(success, "Address: unable to send value, recipient may have reverted");
704     }
705 
706     /**
707      * @dev Performs a Solidity function call using a low level `call`. A
708      * plain `call` is an unsafe replacement for a function call: use this
709      * function instead.
710      *
711      * If `target` reverts with a revert reason, it is bubbled up by this
712      * function (like regular Solidity function calls).
713      *
714      * Returns the raw returned data. To convert to the expected return value,
715      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
716      *
717      * Requirements:
718      *
719      * - `target` must be a contract.
720      * - calling `target` with `data` must not revert.
721      *
722      * _Available since v3.1._
723      */
724     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
725         return functionCall(target, data, "Address: low-level call failed");
726     }
727 
728     /**
729      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
730      * `errorMessage` as a fallback revert reason when `target` reverts.
731      *
732      * _Available since v3.1._
733      */
734     function functionCall(
735         address target,
736         bytes memory data,
737         string memory errorMessage
738     ) internal returns (bytes memory) {
739         return functionCallWithValue(target, data, 0, errorMessage);
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
744      * but also transferring `value` wei to `target`.
745      *
746      * Requirements:
747      *
748      * - the calling contract must have an ETH balance of at least `value`.
749      * - the called Solidity function must be `payable`.
750      *
751      * _Available since v3.1._
752      */
753     function functionCallWithValue(
754         address target,
755         bytes memory data,
756         uint256 value
757     ) internal returns (bytes memory) {
758         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
759     }
760 
761     /**
762      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
763      * with `errorMessage` as a fallback revert reason when `target` reverts.
764      *
765      * _Available since v3.1._
766      */
767     function functionCallWithValue(
768         address target,
769         bytes memory data,
770         uint256 value,
771         string memory errorMessage
772     ) internal returns (bytes memory) {
773         require(address(this).balance >= value, "Address: insufficient balance for call");
774         require(isContract(target), "Address: call to non-contract");
775 
776         (bool success, bytes memory returndata) = target.call{value: value}(data);
777         return verifyCallResult(success, returndata, errorMessage);
778     }
779 
780     /**
781      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
782      * but performing a static call.
783      *
784      * _Available since v3.3._
785      */
786     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
787         return functionStaticCall(target, data, "Address: low-level static call failed");
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
792      * but performing a static call.
793      *
794      * _Available since v3.3._
795      */
796     function functionStaticCall(
797         address target,
798         bytes memory data,
799         string memory errorMessage
800     ) internal view returns (bytes memory) {
801         require(isContract(target), "Address: static call to non-contract");
802 
803         (bool success, bytes memory returndata) = target.staticcall(data);
804         return verifyCallResult(success, returndata, errorMessage);
805     }
806 
807     /**
808      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
809      * but performing a delegate call.
810      *
811      * _Available since v3.4._
812      */
813     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
814         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
815     }
816 
817     /**
818      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
819      * but performing a delegate call.
820      *
821      * _Available since v3.4._
822      */
823     function functionDelegateCall(
824         address target,
825         bytes memory data,
826         string memory errorMessage
827     ) internal returns (bytes memory) {
828         require(isContract(target), "Address: delegate call to non-contract");
829 
830         (bool success, bytes memory returndata) = target.delegatecall(data);
831         return verifyCallResult(success, returndata, errorMessage);
832     }
833 
834     /**
835      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
836      * revert reason using the provided one.
837      *
838      * _Available since v4.3._
839      */
840     function verifyCallResult(
841         bool success,
842         bytes memory returndata,
843         string memory errorMessage
844     ) internal pure returns (bytes memory) {
845         if (success) {
846             return returndata;
847         } else {
848             // Look for revert reason and bubble it up if present
849             if (returndata.length > 0) {
850                 // The easiest way to bubble the revert reason is using memory via assembly
851 
852                 assembly {
853                     let returndata_size := mload(returndata)
854                     revert(add(32, returndata), returndata_size)
855                 }
856             } else {
857                 revert(errorMessage);
858             }
859         }
860     }
861 }
862 
863 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
864 
865 
866 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
867 
868 pragma solidity ^0.8.0;
869 
870 /**
871  * @title ERC721 token receiver interface
872  * @dev Interface for any contract that wants to support safeTransfers
873  * from ERC721 asset contracts.
874  */
875 interface IERC721Receiver {
876     /**
877      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
878      * by `operator` from `from`, this function is called.
879      *
880      * It must return its Solidity selector to confirm the token transfer.
881      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
882      *
883      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
884      */
885     function onERC721Received(
886         address operator,
887         address from,
888         uint256 tokenId,
889         bytes calldata data
890     ) external returns (bytes4);
891 }
892 
893 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
894 
895 
896 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
897 
898 pragma solidity ^0.8.0;
899 
900 /**
901  * @dev Interface of the ERC165 standard, as defined in the
902  * https://eips.ethereum.org/EIPS/eip-165[EIP].
903  *
904  * Implementers can declare support of contract interfaces, which can then be
905  * queried by others ({ERC165Checker}).
906  *
907  * For an implementation, see {ERC165}.
908  */
909 interface IERC165 {
910     /**
911      * @dev Returns true if this contract implements the interface defined by
912      * `interfaceId`. See the corresponding
913      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
914      * to learn more about how these ids are created.
915      *
916      * This function call must use less than 30 000 gas.
917      */
918     function supportsInterface(bytes4 interfaceId) external view returns (bool);
919 }
920 
921 // File: @openzeppelin/contracts/interfaces/IERC165.sol
922 
923 
924 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
925 
926 pragma solidity ^0.8.0;
927 
928 
929 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
930 
931 
932 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 
937 /**
938  * @dev Interface for the NFT Royalty Standard.
939  *
940  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
941  * support for royalty payments across all NFT marketplaces and ecosystem participants.
942  *
943  * _Available since v4.5._
944  */
945 interface IERC2981 is IERC165 {
946     /**
947      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
948      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
949      */
950     function royaltyInfo(uint256 tokenId, uint256 salePrice)
951         external
952         view
953         returns (address receiver, uint256 royaltyAmount);
954 }
955 
956 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
957 
958 
959 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
960 
961 pragma solidity ^0.8.0;
962 
963 
964 /**
965  * @dev Implementation of the {IERC165} interface.
966  *
967  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
968  * for the additional interface id that will be supported. For example:
969  *
970  * ```solidity
971  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
972  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
973  * }
974  * ```
975  *
976  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
977  */
978 abstract contract ERC165 is IERC165 {
979     /**
980      * @dev See {IERC165-supportsInterface}.
981      */
982     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
983         return interfaceId == type(IERC165).interfaceId;
984     }
985 }
986 
987 // File: @openzeppelin/contracts/token/common/ERC2981.sol
988 
989 
990 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
991 
992 pragma solidity ^0.8.0;
993 
994 
995 
996 /**
997  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
998  *
999  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1000  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1001  *
1002  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1003  * fee is specified in basis points by default.
1004  *
1005  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1006  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1007  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1008  *
1009  * _Available since v4.5._
1010  */
1011 abstract contract ERC2981 is IERC2981, ERC165 {
1012     struct RoyaltyInfo {
1013         address receiver;
1014         uint96 royaltyFraction;
1015     }
1016 
1017     RoyaltyInfo private _defaultRoyaltyInfo;
1018     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1019 
1020     /**
1021      * @dev See {IERC165-supportsInterface}.
1022      */
1023     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1024         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1025     }
1026 
1027     /**
1028      * @inheritdoc IERC2981
1029      */
1030     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1031         external
1032         view
1033         virtual
1034         override
1035         returns (address, uint256)
1036     {
1037         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1038 
1039         if (royalty.receiver == address(0)) {
1040             royalty = _defaultRoyaltyInfo;
1041         }
1042 
1043         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1044 
1045         return (royalty.receiver, royaltyAmount);
1046     }
1047 
1048     /**
1049      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1050      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1051      * override.
1052      */
1053     function _feeDenominator() internal pure virtual returns (uint96) {
1054         return 10000;
1055     }
1056 
1057     /**
1058      * @dev Sets the royalty information that all ids in this contract will default to.
1059      *
1060      * Requirements:
1061      *
1062      * - `receiver` cannot be the zero address.
1063      * - `feeNumerator` cannot be greater than the fee denominator.
1064      */
1065     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1066         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1067         require(receiver != address(0), "ERC2981: invalid receiver");
1068 
1069         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1070     }
1071 
1072     /**
1073      * @dev Removes default royalty information.
1074      */
1075     function _deleteDefaultRoyalty() internal virtual {
1076         delete _defaultRoyaltyInfo;
1077     }
1078 
1079     /**
1080      * @dev Sets the royalty information for a specific token id, overriding the global default.
1081      *
1082      * Requirements:
1083      *
1084      * - `tokenId` must be already minted.
1085      * - `receiver` cannot be the zero address.
1086      * - `feeNumerator` cannot be greater than the fee denominator.
1087      */
1088     function _setTokenRoyalty(
1089         uint256 tokenId,
1090         address receiver,
1091         uint96 feeNumerator
1092     ) internal virtual {
1093         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1094         require(receiver != address(0), "ERC2981: Invalid parameters");
1095 
1096         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1097     }
1098 
1099     /**
1100      * @dev Resets royalty information for the token id back to the global default.
1101      */
1102     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1103         delete _tokenRoyaltyInfo[tokenId];
1104     }
1105 }
1106 
1107 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1108 
1109 
1110 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1111 
1112 pragma solidity ^0.8.0;
1113 
1114 
1115 /**
1116  * @dev Required interface of an ERC721 compliant contract.
1117  */
1118 interface IERC721 is IERC165 {
1119     /**
1120      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1121      */
1122     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1123 
1124     /**
1125      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1126      */
1127     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1128 
1129     /**
1130      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1131      */
1132     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1133 
1134     /**
1135      * @dev Returns the number of tokens in ``owner``'s account.
1136      */
1137     function balanceOf(address owner) external view returns (uint256 balance);
1138 
1139     /**
1140      * @dev Returns the owner of the `tokenId` token.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must exist.
1145      */
1146     function ownerOf(uint256 tokenId) external view returns (address owner);
1147 
1148     /**
1149      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1150      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1151      *
1152      * Requirements:
1153      *
1154      * - `from` cannot be the zero address.
1155      * - `to` cannot be the zero address.
1156      * - `tokenId` token must exist and be owned by `from`.
1157      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function safeTransferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) external;
1167 
1168     /**
1169      * @dev Transfers `tokenId` token from `from` to `to`.
1170      *
1171      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1172      *
1173      * Requirements:
1174      *
1175      * - `from` cannot be the zero address.
1176      * - `to` cannot be the zero address.
1177      * - `tokenId` token must be owned by `from`.
1178      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function transferFrom(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) external;
1187 
1188     /**
1189      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1190      * The approval is cleared when the token is transferred.
1191      *
1192      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1193      *
1194      * Requirements:
1195      *
1196      * - The caller must own the token or be an approved operator.
1197      * - `tokenId` must exist.
1198      *
1199      * Emits an {Approval} event.
1200      */
1201     function approve(address to, uint256 tokenId) external;
1202 
1203     /**
1204      * @dev Returns the account approved for `tokenId` token.
1205      *
1206      * Requirements:
1207      *
1208      * - `tokenId` must exist.
1209      */
1210     function getApproved(uint256 tokenId) external view returns (address operator);
1211 
1212     /**
1213      * @dev Approve or remove `operator` as an operator for the caller.
1214      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1215      *
1216      * Requirements:
1217      *
1218      * - The `operator` cannot be the caller.
1219      *
1220      * Emits an {ApprovalForAll} event.
1221      */
1222     function setApprovalForAll(address operator, bool _approved) external;
1223 
1224     /**
1225      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1226      *
1227      * See {setApprovalForAll}
1228      */
1229     function isApprovedForAll(address owner, address operator) external view returns (bool);
1230 
1231     /**
1232      * @dev Safely transfers `tokenId` token from `from` to `to`.
1233      *
1234      * Requirements:
1235      *
1236      * - `from` cannot be the zero address.
1237      * - `to` cannot be the zero address.
1238      * - `tokenId` token must exist and be owned by `from`.
1239      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function safeTransferFrom(
1245         address from,
1246         address to,
1247         uint256 tokenId,
1248         bytes calldata data
1249     ) external;
1250 }
1251 
1252 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1253 
1254 
1255 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 
1260 /**
1261  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1262  * @dev See https://eips.ethereum.org/EIPS/eip-721
1263  */
1264 interface IERC721Enumerable is IERC721 {
1265     /**
1266      * @dev Returns the total amount of tokens stored by the contract.
1267      */
1268     function totalSupply() external view returns (uint256);
1269 
1270     /**
1271      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1272      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1273      */
1274     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1275 
1276     /**
1277      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1278      * Use along with {totalSupply} to enumerate all tokens.
1279      */
1280     function tokenByIndex(uint256 index) external view returns (uint256);
1281 }
1282 
1283 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1284 
1285 
1286 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 
1291 /**
1292  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1293  * @dev See https://eips.ethereum.org/EIPS/eip-721
1294  */
1295 interface IERC721Metadata is IERC721 {
1296     /**
1297      * @dev Returns the token collection name.
1298      */
1299     function name() external view returns (string memory);
1300 
1301     /**
1302      * @dev Returns the token collection symbol.
1303      */
1304     function symbol() external view returns (string memory);
1305 
1306     /**
1307      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1308      */
1309     function tokenURI(uint256 tokenId) external view returns (string memory);
1310 }
1311 
1312 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1313 
1314 
1315 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1316 
1317 pragma solidity ^0.8.0;
1318 
1319 
1320 
1321 
1322 
1323 
1324 
1325 
1326 /**
1327  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1328  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1329  * {ERC721Enumerable}.
1330  */
1331 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1332     using Address for address;
1333     using Strings for uint256;
1334 
1335     // Token name
1336     string private _name;
1337 
1338     // Token symbol
1339     string private _symbol;
1340 
1341     // Mapping from token ID to owner address
1342     mapping(uint256 => address) private _owners;
1343 
1344     // Mapping owner address to token count
1345     mapping(address => uint256) private _balances;
1346 
1347     // Mapping from token ID to approved address
1348     mapping(uint256 => address) private _tokenApprovals;
1349 
1350     // Mapping from owner to operator approvals
1351     mapping(address => mapping(address => bool)) private _operatorApprovals;
1352 
1353     /**
1354      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1355      */
1356     constructor(string memory name_, string memory symbol_) {
1357         _name = name_;
1358         _symbol = symbol_;
1359     }
1360 
1361     /**
1362      * @dev See {IERC165-supportsInterface}.
1363      */
1364     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1365         return
1366             interfaceId == type(IERC721).interfaceId ||
1367             interfaceId == type(IERC721Metadata).interfaceId ||
1368             super.supportsInterface(interfaceId);
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-balanceOf}.
1373      */
1374     function balanceOf(address owner) public view virtual override returns (uint256) {
1375         require(owner != address(0), "ERC721: balance query for the zero address");
1376         return _balances[owner];
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-ownerOf}.
1381      */
1382     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1383         address owner = _owners[tokenId];
1384         require(owner != address(0), "ERC721: owner query for nonexistent token");
1385         return owner;
1386     }
1387 
1388     /**
1389      * @dev See {IERC721Metadata-name}.
1390      */
1391     function name() public view virtual override returns (string memory) {
1392         return _name;
1393     }
1394 
1395     /**
1396      * @dev See {IERC721Metadata-symbol}.
1397      */
1398     function symbol() public view virtual override returns (string memory) {
1399         return _symbol;
1400     }
1401 
1402     /**
1403      * @dev See {IERC721Metadata-tokenURI}.
1404      */
1405     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1406         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1407 
1408         string memory baseURI = _baseURI();
1409         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1410     }
1411 
1412     /**
1413      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1414      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1415      * by default, can be overriden in child contracts.
1416      */
1417     function _baseURI() internal view virtual returns (string memory) {
1418         return "";
1419     }
1420 
1421     /**
1422      * @dev See {IERC721-approve}.
1423      */
1424     function approve(address to, uint256 tokenId) public virtual override {
1425         address owner = ERC721.ownerOf(tokenId);
1426         require(to != owner, "ERC721: approval to current owner");
1427 
1428         require(
1429             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1430             "ERC721: approve caller is not owner nor approved for all"
1431         );
1432 
1433         _approve(to, tokenId);
1434     }
1435 
1436     /**
1437      * @dev See {IERC721-getApproved}.
1438      */
1439     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1440         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1441 
1442         return _tokenApprovals[tokenId];
1443     }
1444 
1445     /**
1446      * @dev See {IERC721-setApprovalForAll}.
1447      */
1448     function setApprovalForAll(address operator, bool approved) public virtual override {
1449         _setApprovalForAll(_msgSender(), operator, approved);
1450     }
1451 
1452     /**
1453      * @dev See {IERC721-isApprovedForAll}.
1454      */
1455     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1456         return _operatorApprovals[owner][operator];
1457     }
1458 
1459     /**
1460      * @dev See {IERC721-transferFrom}.
1461      */
1462     function transferFrom(
1463         address from,
1464         address to,
1465         uint256 tokenId
1466     ) public virtual override {
1467         //solhint-disable-next-line max-line-length
1468         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1469 
1470         _transfer(from, to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev See {IERC721-safeTransferFrom}.
1475      */
1476     function safeTransferFrom(
1477         address from,
1478         address to,
1479         uint256 tokenId
1480     ) public virtual override {
1481         safeTransferFrom(from, to, tokenId, "");
1482     }
1483 
1484     /**
1485      * @dev See {IERC721-safeTransferFrom}.
1486      */
1487     function safeTransferFrom(
1488         address from,
1489         address to,
1490         uint256 tokenId,
1491         bytes memory _data
1492     ) public virtual override {
1493         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1494         _safeTransfer(from, to, tokenId, _data);
1495     }
1496 
1497     /**
1498      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1499      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1500      *
1501      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1502      *
1503      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1504      * implement alternative mechanisms to perform token transfer, such as signature-based.
1505      *
1506      * Requirements:
1507      *
1508      * - `from` cannot be the zero address.
1509      * - `to` cannot be the zero address.
1510      * - `tokenId` token must exist and be owned by `from`.
1511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1512      *
1513      * Emits a {Transfer} event.
1514      */
1515     function _safeTransfer(
1516         address from,
1517         address to,
1518         uint256 tokenId,
1519         bytes memory _data
1520     ) internal virtual {
1521         _transfer(from, to, tokenId);
1522         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1523     }
1524 
1525     /**
1526      * @dev Returns whether `tokenId` exists.
1527      *
1528      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1529      *
1530      * Tokens start existing when they are minted (`_mint`),
1531      * and stop existing when they are burned (`_burn`).
1532      */
1533     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1534         return _owners[tokenId] != address(0);
1535     }
1536 
1537     /**
1538      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1539      *
1540      * Requirements:
1541      *
1542      * - `tokenId` must exist.
1543      */
1544     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1545         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1546         address owner = ERC721.ownerOf(tokenId);
1547         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1548     }
1549 
1550     /**
1551      * @dev Safely mints `tokenId` and transfers it to `to`.
1552      *
1553      * Requirements:
1554      *
1555      * - `tokenId` must not exist.
1556      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1557      *
1558      * Emits a {Transfer} event.
1559      */
1560     function _safeMint(address to, uint256 tokenId) internal virtual {
1561         _safeMint(to, tokenId, "");
1562     }
1563 
1564     /**
1565      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1566      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1567      */
1568     function _safeMint(
1569         address to,
1570         uint256 tokenId,
1571         bytes memory _data
1572     ) internal virtual {
1573         _mint(to, tokenId);
1574         require(
1575             _checkOnERC721Received(address(0), to, tokenId, _data),
1576             "ERC721: transfer to non ERC721Receiver implementer"
1577         );
1578     }
1579 
1580     /**
1581      * @dev Mints `tokenId` and transfers it to `to`.
1582      *
1583      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1584      *
1585      * Requirements:
1586      *
1587      * - `tokenId` must not exist.
1588      * - `to` cannot be the zero address.
1589      *
1590      * Emits a {Transfer} event.
1591      */
1592     function _mint(address to, uint256 tokenId) internal virtual {
1593         require(to != address(0), "ERC721: mint to the zero address");
1594         require(!_exists(tokenId), "ERC721: token already minted");
1595 
1596         _beforeTokenTransfer(address(0), to, tokenId);
1597 
1598         _balances[to] += 1;
1599         _owners[tokenId] = to;
1600 
1601         emit Transfer(address(0), to, tokenId);
1602 
1603         _afterTokenTransfer(address(0), to, tokenId);
1604     }
1605 
1606     /**
1607      * @dev Destroys `tokenId`.
1608      * The approval is cleared when the token is burned.
1609      *
1610      * Requirements:
1611      *
1612      * - `tokenId` must exist.
1613      *
1614      * Emits a {Transfer} event.
1615      */
1616     function _burn(uint256 tokenId) internal virtual {
1617         address owner = ERC721.ownerOf(tokenId);
1618 
1619         _beforeTokenTransfer(owner, address(0), tokenId);
1620 
1621         // Clear approvals
1622         _approve(address(0), tokenId);
1623 
1624         _balances[owner] -= 1;
1625         delete _owners[tokenId];
1626 
1627         emit Transfer(owner, address(0), tokenId);
1628 
1629         _afterTokenTransfer(owner, address(0), tokenId);
1630     }
1631 
1632     /**
1633      * @dev Transfers `tokenId` from `from` to `to`.
1634      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1635      *
1636      * Requirements:
1637      *
1638      * - `to` cannot be the zero address.
1639      * - `tokenId` token must be owned by `from`.
1640      *
1641      * Emits a {Transfer} event.
1642      */
1643     function _transfer(
1644         address from,
1645         address to,
1646         uint256 tokenId
1647     ) internal virtual {
1648         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1649         require(to != address(0), "ERC721: transfer to the zero address");
1650 
1651         _beforeTokenTransfer(from, to, tokenId);
1652 
1653         // Clear approvals from the previous owner
1654         _approve(address(0), tokenId);
1655 
1656         _balances[from] -= 1;
1657         _balances[to] += 1;
1658         _owners[tokenId] = to;
1659 
1660         emit Transfer(from, to, tokenId);
1661 
1662         _afterTokenTransfer(from, to, tokenId);
1663     }
1664 
1665     /**
1666      * @dev Approve `to` to operate on `tokenId`
1667      *
1668      * Emits a {Approval} event.
1669      */
1670     function _approve(address to, uint256 tokenId) internal virtual {
1671         _tokenApprovals[tokenId] = to;
1672         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1673     }
1674 
1675     /**
1676      * @dev Approve `operator` to operate on all of `owner` tokens
1677      *
1678      * Emits a {ApprovalForAll} event.
1679      */
1680     function _setApprovalForAll(
1681         address owner,
1682         address operator,
1683         bool approved
1684     ) internal virtual {
1685         require(owner != operator, "ERC721: approve to caller");
1686         _operatorApprovals[owner][operator] = approved;
1687         emit ApprovalForAll(owner, operator, approved);
1688     }
1689 
1690     /**
1691      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1692      * The call is not executed if the target address is not a contract.
1693      *
1694      * @param from address representing the previous owner of the given token ID
1695      * @param to target address that will receive the tokens
1696      * @param tokenId uint256 ID of the token to be transferred
1697      * @param _data bytes optional data to send along with the call
1698      * @return bool whether the call correctly returned the expected magic value
1699      */
1700     function _checkOnERC721Received(
1701         address from,
1702         address to,
1703         uint256 tokenId,
1704         bytes memory _data
1705     ) private returns (bool) {
1706         if (to.isContract()) {
1707             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1708                 return retval == IERC721Receiver.onERC721Received.selector;
1709             } catch (bytes memory reason) {
1710                 if (reason.length == 0) {
1711                     revert("ERC721: transfer to non ERC721Receiver implementer");
1712                 } else {
1713                     assembly {
1714                         revert(add(32, reason), mload(reason))
1715                     }
1716                 }
1717             }
1718         } else {
1719             return true;
1720         }
1721     }
1722 
1723     /**
1724      * @dev Hook that is called before any token transfer. This includes minting
1725      * and burning.
1726      *
1727      * Calling conditions:
1728      *
1729      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1730      * transferred to `to`.
1731      * - When `from` is zero, `tokenId` will be minted for `to`.
1732      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1733      * - `from` and `to` are never both zero.
1734      *
1735      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1736      */
1737     function _beforeTokenTransfer(
1738         address from,
1739         address to,
1740         uint256 tokenId
1741     ) internal virtual {}
1742 
1743     /**
1744      * @dev Hook that is called after any transfer of tokens. This includes
1745      * minting and burning.
1746      *
1747      * Calling conditions:
1748      *
1749      * - when `from` and `to` are both non-zero.
1750      * - `from` and `to` are never both zero.
1751      *
1752      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1753      */
1754     function _afterTokenTransfer(
1755         address from,
1756         address to,
1757         uint256 tokenId
1758     ) internal virtual {}
1759 }
1760 
1761 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol
1762 
1763 
1764 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/ERC721Royalty.sol)
1765 
1766 pragma solidity ^0.8.0;
1767 
1768 
1769 
1770 
1771 /**
1772  * @dev Extension of ERC721 with the ERC2981 NFT Royalty Standard, a standardized way to retrieve royalty payment
1773  * information.
1774  *
1775  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1776  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1777  *
1778  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1779  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1780  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1781  *
1782  * _Available since v4.5._
1783  */
1784 abstract contract ERC721Royalty is ERC2981, ERC721 {
1785     /**
1786      * @dev See {IERC165-supportsInterface}.
1787      */
1788     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
1789         return super.supportsInterface(interfaceId);
1790     }
1791 
1792     /**
1793      * @dev See {ERC721-_burn}. This override additionally clears the royalty information for the token.
1794      */
1795     function _burn(uint256 tokenId) internal virtual override {
1796         super._burn(tokenId);
1797         _resetTokenRoyalty(tokenId);
1798     }
1799 }
1800 
1801 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1802 
1803 
1804 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1805 
1806 pragma solidity ^0.8.0;
1807 
1808 
1809 
1810 /**
1811  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1812  * enumerability of all the token ids in the contract as well as all token ids owned by each
1813  * account.
1814  */
1815 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1816     // Mapping from owner to list of owned token IDs
1817     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1818 
1819     // Mapping from token ID to index of the owner tokens list
1820     mapping(uint256 => uint256) private _ownedTokensIndex;
1821 
1822     // Array with all token ids, used for enumeration
1823     uint256[] private _allTokens;
1824 
1825     // Mapping from token id to position in the allTokens array
1826     mapping(uint256 => uint256) private _allTokensIndex;
1827 
1828     /**
1829      * @dev See {IERC165-supportsInterface}.
1830      */
1831     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1832         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1833     }
1834 
1835     /**
1836      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1837      */
1838     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1839         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1840         return _ownedTokens[owner][index];
1841     }
1842 
1843     /**
1844      * @dev See {IERC721Enumerable-totalSupply}.
1845      */
1846     function totalSupply() public view virtual override returns (uint256) {
1847         return _allTokens.length;
1848     }
1849 
1850     /**
1851      * @dev See {IERC721Enumerable-tokenByIndex}.
1852      */
1853     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1854         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1855         return _allTokens[index];
1856     }
1857 
1858     /**
1859      * @dev Hook that is called before any token transfer. This includes minting
1860      * and burning.
1861      *
1862      * Calling conditions:
1863      *
1864      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1865      * transferred to `to`.
1866      * - When `from` is zero, `tokenId` will be minted for `to`.
1867      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1868      * - `from` cannot be the zero address.
1869      * - `to` cannot be the zero address.
1870      *
1871      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1872      */
1873     function _beforeTokenTransfer(
1874         address from,
1875         address to,
1876         uint256 tokenId
1877     ) internal virtual override {
1878         super._beforeTokenTransfer(from, to, tokenId);
1879 
1880         if (from == address(0)) {
1881             _addTokenToAllTokensEnumeration(tokenId);
1882         } else if (from != to) {
1883             _removeTokenFromOwnerEnumeration(from, tokenId);
1884         }
1885         if (to == address(0)) {
1886             _removeTokenFromAllTokensEnumeration(tokenId);
1887         } else if (to != from) {
1888             _addTokenToOwnerEnumeration(to, tokenId);
1889         }
1890     }
1891 
1892     /**
1893      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1894      * @param to address representing the new owner of the given token ID
1895      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1896      */
1897     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1898         uint256 length = ERC721.balanceOf(to);
1899         _ownedTokens[to][length] = tokenId;
1900         _ownedTokensIndex[tokenId] = length;
1901     }
1902 
1903     /**
1904      * @dev Private function to add a token to this extension's token tracking data structures.
1905      * @param tokenId uint256 ID of the token to be added to the tokens list
1906      */
1907     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1908         _allTokensIndex[tokenId] = _allTokens.length;
1909         _allTokens.push(tokenId);
1910     }
1911 
1912     /**
1913      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1914      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1915      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1916      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1917      * @param from address representing the previous owner of the given token ID
1918      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1919      */
1920     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1921         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1922         // then delete the last slot (swap and pop).
1923 
1924         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1925         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1926 
1927         // When the token to delete is the last token, the swap operation is unnecessary
1928         if (tokenIndex != lastTokenIndex) {
1929             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1930 
1931             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1932             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1933         }
1934 
1935         // This also deletes the contents at the last position of the array
1936         delete _ownedTokensIndex[tokenId];
1937         delete _ownedTokens[from][lastTokenIndex];
1938     }
1939 
1940     /**
1941      * @dev Private function to remove a token from this extension's token tracking data structures.
1942      * This has O(1) time complexity, but alters the order of the _allTokens array.
1943      * @param tokenId uint256 ID of the token to be removed from the tokens list
1944      */
1945     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1946         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1947         // then delete the last slot (swap and pop).
1948 
1949         uint256 lastTokenIndex = _allTokens.length - 1;
1950         uint256 tokenIndex = _allTokensIndex[tokenId];
1951 
1952         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1953         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1954         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1955         uint256 lastTokenId = _allTokens[lastTokenIndex];
1956 
1957         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1958         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1959 
1960         // This also deletes the contents at the last position of the array
1961         delete _allTokensIndex[tokenId];
1962         _allTokens.pop();
1963     }
1964 }
1965 
1966 // File: contracts/JunityOfficial.sol
1967 
1968 
1969 pragma solidity >=0.7.0 <0.9.0;
1970 
1971 
1972 
1973 
1974 
1975 
1976 contract JunityOfficial is ERC721Enumerable, Ownable, ERC721Royalty {
1977     using Strings for uint256;
1978     using SafeMath for uint256;
1979     using ECDSA for bytes32;
1980 
1981     string public baseURI;
1982     string private _baseExtension = ".json";
1983     string private _notRevealedUri;
1984     string private _contractURI;
1985     uint256 public cost = 0.01 ether; //price for 1 nft
1986     uint256 public maxSupply = 1100; // number of nft in the collection
1987     uint256 public maxMintAmount = 1;
1988     uint256 public nftPerAddressLimit = 1;
1989     bool public paused = false;
1990     bool public revealed = false;
1991     bool public onlyWhitelisted = true;
1992     mapping(address => uint256) public addressMintedBalance;
1993     uint8 private _og = 2;
1994     uint8 private _wl = 1;
1995 
1996     constructor() ERC721("Junity official", "JU") {
1997         setBaseURI("ipfs://QmNPiK9X3kupHbe9RiRfRqCHA6QN5MkDAGGUfUyKaHenet/");
1998         setNotRevealedURI("ipfs://Qmc5NBfSM63P5LdgPnN5SdE6LUdtWNeVJcYP7v87yiUCTf");
1999         _setDefaultRoyalty(owner(), 1000);
2000         setContractURI("ipfs://QmenpZbR26vhcLm9SsWYuMCjAf7NUaUcWYFaWRryNUooVJ");
2001     }
2002 
2003     function contractURI() public view returns (string memory) {
2004         return _contractURI;
2005     }
2006 
2007     function setContractURI(string memory _URI) public onlyOwner {
2008         _contractURI = _URI;
2009     }
2010 
2011     // internal
2012     function _baseURI() internal view virtual override returns (string memory) {
2013         return baseURI;
2014     }
2015 
2016     function supportsInterface(bytes4 interfaceId)
2017         public
2018         view
2019         virtual
2020         override(ERC721Enumerable, ERC721Royalty)
2021         returns (bool)
2022     {
2023         return super.supportsInterface(interfaceId);
2024     }
2025 
2026     function _beforeTokenTransfer(
2027         address from,
2028         address to,
2029         uint256 tokenId
2030     ) internal override(ERC721, ERC721Enumerable) {
2031         super._beforeTokenTransfer(from, to, tokenId);
2032     }
2033 
2034     function _burn(uint256 tokenId)
2035         internal
2036         virtual
2037         override(ERC721, ERC721Royalty)
2038     {
2039         super._burn(tokenId);
2040         _resetTokenRoyalty(tokenId);
2041     }
2042 
2043     function setMaxSupply(uint256 _amount) public onlyOwner {
2044         maxSupply = _amount;
2045     }
2046 
2047     function mint(uint256 _mintAmount, bytes memory _signature) public payable {
2048         require(!paused, "the contract is paused");
2049         uint256 supply = totalSupply();
2050         require(_mintAmount > 0, "need to mint at least 1 NFT");
2051         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
2052         uint256 maxMint = maxMintAmount;
2053         uint256 nftPerAdress = nftPerAddressLimit;
2054 
2055         if (msg.sender != owner()) {
2056             if (onlyWhitelisted == true) {
2057                 if (!isOGListed(_signature)) {
2058                     require(
2059                         isWhitelisted(_signature),
2060                         "user is not whitelisted"
2061                     );
2062                 } else {
2063                     maxMint = 2;
2064                     nftPerAdress = 2;
2065                 }
2066 
2067                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
2068                 require(
2069                     ownerMintedCount + _mintAmount <= nftPerAdress,
2070                     "max NFT per address exceeded"
2071                 );
2072             }
2073 
2074             require(
2075                 _mintAmount <= maxMint,
2076                 "max mint amount per session exceeded"
2077             );
2078             require(msg.value >= cost * _mintAmount, "insufficient funds!");
2079         }
2080 
2081         for (uint256 i = 1; i <= _mintAmount; i++) {
2082             addressMintedBalance[msg.sender]++;
2083             _safeMint(msg.sender, supply + i);
2084         }
2085     }
2086 
2087     function isMessageValid(bytes memory _signature, uint8 _nonce)
2088         public
2089         view
2090         returns (address, bool)
2091     {
2092         bytes32 messagehash = keccak256(
2093             abi.encodePacked(address(this), msg.sender, _nonce)
2094         );
2095         address signer = messagehash.toEthSignedMessageHash().recover(
2096             _signature
2097         );
2098 
2099         if (msg.sender == signer) {
2100             return (signer, true);
2101         } else {
2102             return (signer, false);
2103         }
2104     }
2105 
2106     function replenishBalance() external payable onlyOwner {}
2107 
2108     function interestPayments(uint256 _wei) public onlyOwner {
2109         for (uint256 i = 1; i < maxSupply; i++) {
2110             if (_exists(i)) {
2111                 address _adr = ownerOf(i);
2112                 (bool success, ) = payable(_adr).call{value: _wei}("");
2113                 require(success, "insufficient funds!");
2114             } else break;
2115         }
2116     }
2117 
2118     function isWhitelisted(bytes memory _signature) public view returns (bool) {
2119         (, bool success) = isMessageValid(_signature, _wl);
2120         return success;
2121     }
2122 
2123     function isOGListed(bytes memory _signature) private view returns (bool) {
2124         (, bool success) = isMessageValid(_signature, _og);
2125         return success;
2126     }
2127 
2128     function walletOfOwner(address _owner)
2129         public
2130         view
2131         returns (uint256[] memory)
2132     {
2133         uint256 ownerTokenCount = balanceOf(_owner);
2134         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2135         for (uint256 i; i < ownerTokenCount; i++) {
2136             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
2137         }
2138         return tokenIds;
2139     }
2140 
2141     function tokenURI(uint256 tokenId)
2142         public
2143         view
2144         virtual
2145         override
2146         returns (string memory)
2147     {
2148         require(
2149             _exists(tokenId),
2150             "ERC721Metadata: URI query for nonexistent token"
2151         );
2152 
2153         if (revealed == false) {
2154             return _notRevealedUri;
2155         }
2156 
2157         string memory currentBaseURI = _baseURI();
2158         return
2159             bytes(currentBaseURI).length > 0
2160                 ? string(
2161                     abi.encodePacked(
2162                         currentBaseURI,
2163                         tokenId.toString(),
2164                         _baseExtension
2165                     )
2166                 )
2167                 : "";
2168     }
2169 
2170     //only owner
2171     function reveal() public onlyOwner {
2172         revealed = true;
2173     }
2174 
2175     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
2176         nftPerAddressLimit = _limit;
2177     }
2178 
2179     function setCost(uint256 _newCost) public onlyOwner {
2180         cost = _newCost;
2181     }
2182 
2183     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
2184         maxMintAmount = _newmaxMintAmount;
2185     }
2186 
2187     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2188         baseURI = _newBaseURI;
2189     }
2190 
2191     function setBaseExtension(string memory _newBaseExtension)
2192         public
2193         onlyOwner
2194     {
2195         _baseExtension = _newBaseExtension;
2196     }
2197 
2198     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2199         _notRevealedUri = _notRevealedURI;
2200     }
2201 
2202     function pause(bool _state) public onlyOwner {
2203         paused = _state;
2204     }
2205 
2206     function setOnlyWhitelisted(bool _state) public onlyOwner {
2207         onlyWhitelisted = _state;
2208         if (onlyWhitelisted) maxMintAmount = 1;
2209         else maxMintAmount = 10;
2210     }
2211 
2212     function withdraw() external onlyOwner {
2213         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2214         require(os);
2215     }
2216 
2217     function getBalance() public view onlyOwner returns (uint256) {
2218         return address(this).balance;
2219     }
2220 }