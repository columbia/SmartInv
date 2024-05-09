1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
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
234 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
304 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
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
421         bytes32 s;
422         uint8 v;
423         assembly {
424             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
425             v := add(shr(255, vs), 27)
426         }
427         return tryRecover(hash, v, r, s);
428     }
429 
430     /**
431      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
432      *
433      * _Available since v4.2._
434      */
435     function recover(
436         bytes32 hash,
437         bytes32 r,
438         bytes32 vs
439     ) internal pure returns (address) {
440         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
441         _throwError(error);
442         return recovered;
443     }
444 
445     /**
446      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
447      * `r` and `s` signature fields separately.
448      *
449      * _Available since v4.3._
450      */
451     function tryRecover(
452         bytes32 hash,
453         uint8 v,
454         bytes32 r,
455         bytes32 s
456     ) internal pure returns (address, RecoverError) {
457         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
458         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
459         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
460         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
461         //
462         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
463         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
464         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
465         // these malleable signatures as well.
466         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
467             return (address(0), RecoverError.InvalidSignatureS);
468         }
469         if (v != 27 && v != 28) {
470             return (address(0), RecoverError.InvalidSignatureV);
471         }
472 
473         // If the signature is valid (and not malleable), return the signer address
474         address signer = ecrecover(hash, v, r, s);
475         if (signer == address(0)) {
476             return (address(0), RecoverError.InvalidSignature);
477         }
478 
479         return (signer, RecoverError.NoError);
480     }
481 
482     /**
483      * @dev Overload of {ECDSA-recover} that receives the `v`,
484      * `r` and `s` signature fields separately.
485      */
486     function recover(
487         bytes32 hash,
488         uint8 v,
489         bytes32 r,
490         bytes32 s
491     ) internal pure returns (address) {
492         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
493         _throwError(error);
494         return recovered;
495     }
496 
497     /**
498      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
499      * produces hash corresponding to the one signed with the
500      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
501      * JSON-RPC method as part of EIP-191.
502      *
503      * See {recover}.
504      */
505     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
506         // 32 is the length in bytes of hash,
507         // enforced by the type signature above
508         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
509     }
510 
511     /**
512      * @dev Returns an Ethereum Signed Message, created from `s`. This
513      * produces hash corresponding to the one signed with the
514      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
515      * JSON-RPC method as part of EIP-191.
516      *
517      * See {recover}.
518      */
519     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
520         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
521     }
522 
523     /**
524      * @dev Returns an Ethereum Signed Typed Data, created from a
525      * `domainSeparator` and a `structHash`. This produces hash corresponding
526      * to the one signed with the
527      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
528      * JSON-RPC method as part of EIP-712.
529      *
530      * See {recover}.
531      */
532     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
533         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
534     }
535 }
536 
537 // File: @openzeppelin/contracts/utils/Context.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @dev Provides information about the current execution context, including the
546  * sender of the transaction and its data. While these are generally available
547  * via msg.sender and msg.data, they should not be accessed in such a direct
548  * manner, since when dealing with meta-transactions the account sending and
549  * paying for execution may not be the actual sender (as far as an application
550  * is concerned).
551  *
552  * This contract is only required for intermediate, library-like contracts.
553  */
554 abstract contract Context {
555     function _msgSender() internal view virtual returns (address) {
556         return msg.sender;
557     }
558 
559     function _msgData() internal view virtual returns (bytes calldata) {
560         return msg.data;
561     }
562 }
563 
564 // File: @openzeppelin/contracts/access/Ownable.sol
565 
566 
567 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @dev Contract module which provides a basic access control mechanism, where
574  * there is an account (an owner) that can be granted exclusive access to
575  * specific functions.
576  *
577  * By default, the owner account will be the one that deploys the contract. This
578  * can later be changed with {transferOwnership}.
579  *
580  * This module is used through inheritance. It will make available the modifier
581  * `onlyOwner`, which can be applied to your functions to restrict their use to
582  * the owner.
583  */
584 abstract contract Ownable is Context {
585     address private _owner;
586 
587     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
588 
589     /**
590      * @dev Initializes the contract setting the deployer as the initial owner.
591      */
592     constructor() {
593         _transferOwnership(_msgSender());
594     }
595 
596     /**
597      * @dev Returns the address of the current owner.
598      */
599     function owner() public view virtual returns (address) {
600         return _owner;
601     }
602 
603     /**
604      * @dev Throws if called by any account other than the owner.
605      */
606     modifier onlyOwner() {
607         require(owner() == _msgSender(), "Ownable: caller is not the owner");
608         _;
609     }
610 
611     /**
612      * @dev Leaves the contract without owner. It will not be possible to call
613      * `onlyOwner` functions anymore. Can only be called by the current owner.
614      *
615      * NOTE: Renouncing ownership will leave the contract without an owner,
616      * thereby removing any functionality that is only available to the owner.
617      */
618     function renounceOwnership() public virtual onlyOwner {
619         _transferOwnership(address(0));
620     }
621 
622     /**
623      * @dev Transfers ownership of the contract to a new account (`newOwner`).
624      * Can only be called by the current owner.
625      */
626     function transferOwnership(address newOwner) public virtual onlyOwner {
627         require(newOwner != address(0), "Ownable: new owner is the zero address");
628         _transferOwnership(newOwner);
629     }
630 
631     /**
632      * @dev Transfers ownership of the contract to a new account (`newOwner`).
633      * Internal function without access restriction.
634      */
635     function _transferOwnership(address newOwner) internal virtual {
636         address oldOwner = _owner;
637         _owner = newOwner;
638         emit OwnershipTransferred(oldOwner, newOwner);
639     }
640 }
641 
642 // File: @openzeppelin/contracts/utils/Address.sol
643 
644 
645 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 /**
650  * @dev Collection of functions related to the address type
651  */
652 library Address {
653     /**
654      * @dev Returns true if `account` is a contract.
655      *
656      * [IMPORTANT]
657      * ====
658      * It is unsafe to assume that an address for which this function returns
659      * false is an externally-owned account (EOA) and not a contract.
660      *
661      * Among others, `isContract` will return false for the following
662      * types of addresses:
663      *
664      *  - an externally-owned account
665      *  - a contract in construction
666      *  - an address where a contract will be created
667      *  - an address where a contract lived, but was destroyed
668      * ====
669      */
670     function isContract(address account) internal view returns (bool) {
671         // This method relies on extcodesize, which returns 0 for contracts in
672         // construction, since the code is only stored at the end of the
673         // constructor execution.
674 
675         uint256 size;
676         assembly {
677             size := extcodesize(account)
678         }
679         return size > 0;
680     }
681 
682     /**
683      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
684      * `recipient`, forwarding all available gas and reverting on errors.
685      *
686      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
687      * of certain opcodes, possibly making contracts go over the 2300 gas limit
688      * imposed by `transfer`, making them unable to receive funds via
689      * `transfer`. {sendValue} removes this limitation.
690      *
691      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
692      *
693      * IMPORTANT: because control is transferred to `recipient`, care must be
694      * taken to not create reentrancy vulnerabilities. Consider using
695      * {ReentrancyGuard} or the
696      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
697      */
698     function sendValue(address payable recipient, uint256 amount) internal {
699         require(address(this).balance >= amount, "Address: insufficient balance");
700 
701         (bool success, ) = recipient.call{value: amount}("");
702         require(success, "Address: unable to send value, recipient may have reverted");
703     }
704 
705     /**
706      * @dev Performs a Solidity function call using a low level `call`. A
707      * plain `call` is an unsafe replacement for a function call: use this
708      * function instead.
709      *
710      * If `target` reverts with a revert reason, it is bubbled up by this
711      * function (like regular Solidity function calls).
712      *
713      * Returns the raw returned data. To convert to the expected return value,
714      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
715      *
716      * Requirements:
717      *
718      * - `target` must be a contract.
719      * - calling `target` with `data` must not revert.
720      *
721      * _Available since v3.1._
722      */
723     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
724         return functionCall(target, data, "Address: low-level call failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
729      * `errorMessage` as a fallback revert reason when `target` reverts.
730      *
731      * _Available since v3.1._
732      */
733     function functionCall(
734         address target,
735         bytes memory data,
736         string memory errorMessage
737     ) internal returns (bytes memory) {
738         return functionCallWithValue(target, data, 0, errorMessage);
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
743      * but also transferring `value` wei to `target`.
744      *
745      * Requirements:
746      *
747      * - the calling contract must have an ETH balance of at least `value`.
748      * - the called Solidity function must be `payable`.
749      *
750      * _Available since v3.1._
751      */
752     function functionCallWithValue(
753         address target,
754         bytes memory data,
755         uint256 value
756     ) internal returns (bytes memory) {
757         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
762      * with `errorMessage` as a fallback revert reason when `target` reverts.
763      *
764      * _Available since v3.1._
765      */
766     function functionCallWithValue(
767         address target,
768         bytes memory data,
769         uint256 value,
770         string memory errorMessage
771     ) internal returns (bytes memory) {
772         require(address(this).balance >= value, "Address: insufficient balance for call");
773         require(isContract(target), "Address: call to non-contract");
774 
775         (bool success, bytes memory returndata) = target.call{value: value}(data);
776         return verifyCallResult(success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
781      * but performing a static call.
782      *
783      * _Available since v3.3._
784      */
785     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
786         return functionStaticCall(target, data, "Address: low-level static call failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
791      * but performing a static call.
792      *
793      * _Available since v3.3._
794      */
795     function functionStaticCall(
796         address target,
797         bytes memory data,
798         string memory errorMessage
799     ) internal view returns (bytes memory) {
800         require(isContract(target), "Address: static call to non-contract");
801 
802         (bool success, bytes memory returndata) = target.staticcall(data);
803         return verifyCallResult(success, returndata, errorMessage);
804     }
805 
806     /**
807      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
808      * but performing a delegate call.
809      *
810      * _Available since v3.4._
811      */
812     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
813         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
818      * but performing a delegate call.
819      *
820      * _Available since v3.4._
821      */
822     function functionDelegateCall(
823         address target,
824         bytes memory data,
825         string memory errorMessage
826     ) internal returns (bytes memory) {
827         require(isContract(target), "Address: delegate call to non-contract");
828 
829         (bool success, bytes memory returndata) = target.delegatecall(data);
830         return verifyCallResult(success, returndata, errorMessage);
831     }
832 
833     /**
834      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
835      * revert reason using the provided one.
836      *
837      * _Available since v4.3._
838      */
839     function verifyCallResult(
840         bool success,
841         bytes memory returndata,
842         string memory errorMessage
843     ) internal pure returns (bytes memory) {
844         if (success) {
845             return returndata;
846         } else {
847             // Look for revert reason and bubble it up if present
848             if (returndata.length > 0) {
849                 // The easiest way to bubble the revert reason is using memory via assembly
850 
851                 assembly {
852                     let returndata_size := mload(returndata)
853                     revert(add(32, returndata), returndata_size)
854                 }
855             } else {
856                 revert(errorMessage);
857             }
858         }
859     }
860 }
861 
862 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
863 
864 
865 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 /**
870  * @title ERC721 token receiver interface
871  * @dev Interface for any contract that wants to support safeTransfers
872  * from ERC721 asset contracts.
873  */
874 interface IERC721Receiver {
875     /**
876      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
877      * by `operator` from `from`, this function is called.
878      *
879      * It must return its Solidity selector to confirm the token transfer.
880      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
881      *
882      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
883      */
884     function onERC721Received(
885         address operator,
886         address from,
887         uint256 tokenId,
888         bytes calldata data
889     ) external returns (bytes4);
890 }
891 
892 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
893 
894 
895 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
896 
897 pragma solidity ^0.8.0;
898 
899 /**
900  * @dev Interface of the ERC165 standard, as defined in the
901  * https://eips.ethereum.org/EIPS/eip-165[EIP].
902  *
903  * Implementers can declare support of contract interfaces, which can then be
904  * queried by others ({ERC165Checker}).
905  *
906  * For an implementation, see {ERC165}.
907  */
908 interface IERC165 {
909     /**
910      * @dev Returns true if this contract implements the interface defined by
911      * `interfaceId`. See the corresponding
912      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
913      * to learn more about how these ids are created.
914      *
915      * This function call must use less than 30 000 gas.
916      */
917     function supportsInterface(bytes4 interfaceId) external view returns (bool);
918 }
919 
920 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
921 
922 
923 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 
928 /**
929  * @dev Implementation of the {IERC165} interface.
930  *
931  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
932  * for the additional interface id that will be supported. For example:
933  *
934  * ```solidity
935  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
936  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
937  * }
938  * ```
939  *
940  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
941  */
942 abstract contract ERC165 is IERC165 {
943     /**
944      * @dev See {IERC165-supportsInterface}.
945      */
946     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
947         return interfaceId == type(IERC165).interfaceId;
948     }
949 }
950 
951 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
952 
953 
954 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
955 
956 pragma solidity ^0.8.0;
957 
958 
959 /**
960  * @dev Required interface of an ERC721 compliant contract.
961  */
962 interface IERC721 is IERC165 {
963     /**
964      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
965      */
966     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
967 
968     /**
969      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
970      */
971     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
972 
973     /**
974      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
975      */
976     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
977 
978     /**
979      * @dev Returns the number of tokens in ``owner``'s account.
980      */
981     function balanceOf(address owner) external view returns (uint256 balance);
982 
983     /**
984      * @dev Returns the owner of the `tokenId` token.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function ownerOf(uint256 tokenId) external view returns (address owner);
991 
992     /**
993      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
994      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
995      *
996      * Requirements:
997      *
998      * - `from` cannot be the zero address.
999      * - `to` cannot be the zero address.
1000      * - `tokenId` token must exist and be owned by `from`.
1001      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function safeTransferFrom(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) external;
1011 
1012     /**
1013      * @dev Transfers `tokenId` token from `from` to `to`.
1014      *
1015      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1016      *
1017      * Requirements:
1018      *
1019      * - `from` cannot be the zero address.
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must be owned by `from`.
1022      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function transferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) external;
1031 
1032     /**
1033      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1034      * The approval is cleared when the token is transferred.
1035      *
1036      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1037      *
1038      * Requirements:
1039      *
1040      * - The caller must own the token or be an approved operator.
1041      * - `tokenId` must exist.
1042      *
1043      * Emits an {Approval} event.
1044      */
1045     function approve(address to, uint256 tokenId) external;
1046 
1047     /**
1048      * @dev Returns the account approved for `tokenId` token.
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must exist.
1053      */
1054     function getApproved(uint256 tokenId) external view returns (address operator);
1055 
1056     /**
1057      * @dev Approve or remove `operator` as an operator for the caller.
1058      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1059      *
1060      * Requirements:
1061      *
1062      * - The `operator` cannot be the caller.
1063      *
1064      * Emits an {ApprovalForAll} event.
1065      */
1066     function setApprovalForAll(address operator, bool _approved) external;
1067 
1068     /**
1069      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1070      *
1071      * See {setApprovalForAll}
1072      */
1073     function isApprovedForAll(address owner, address operator) external view returns (bool);
1074 
1075     /**
1076      * @dev Safely transfers `tokenId` token from `from` to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `from` cannot be the zero address.
1081      * - `to` cannot be the zero address.
1082      * - `tokenId` token must exist and be owned by `from`.
1083      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1084      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function safeTransferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes calldata data
1093     ) external;
1094 }
1095 
1096 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1097 
1098 
1099 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 
1104 /**
1105  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1106  * @dev See https://eips.ethereum.org/EIPS/eip-721
1107  */
1108 interface IERC721Enumerable is IERC721 {
1109     /**
1110      * @dev Returns the total amount of tokens stored by the contract.
1111      */
1112     function totalSupply() external view returns (uint256);
1113 
1114     /**
1115      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1116      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1117      */
1118     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1119 
1120     /**
1121      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1122      * Use along with {totalSupply} to enumerate all tokens.
1123      */
1124     function tokenByIndex(uint256 index) external view returns (uint256);
1125 }
1126 
1127 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1128 
1129 
1130 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 /**
1136  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1137  * @dev See https://eips.ethereum.org/EIPS/eip-721
1138  */
1139 interface IERC721Metadata is IERC721 {
1140     /**
1141      * @dev Returns the token collection name.
1142      */
1143     function name() external view returns (string memory);
1144 
1145     /**
1146      * @dev Returns the token collection symbol.
1147      */
1148     function symbol() external view returns (string memory);
1149 
1150     /**
1151      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1152      */
1153     function tokenURI(uint256 tokenId) external view returns (string memory);
1154 }
1155 
1156 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1157 
1158 
1159 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 
1164 
1165 
1166 
1167 
1168 
1169 
1170 /**
1171  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1172  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1173  * {ERC721Enumerable}.
1174  */
1175 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1176     using Address for address;
1177     using Strings for uint256;
1178 
1179     // Token name
1180     string private _name;
1181 
1182     // Token symbol
1183     string private _symbol;
1184 
1185     // Mapping from token ID to owner address
1186     mapping(uint256 => address) private _owners;
1187 
1188     // Mapping owner address to token count
1189     mapping(address => uint256) private _balances;
1190 
1191     // Mapping from token ID to approved address
1192     mapping(uint256 => address) private _tokenApprovals;
1193 
1194     // Mapping from owner to operator approvals
1195     mapping(address => mapping(address => bool)) private _operatorApprovals;
1196 
1197     /**
1198      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1199      */
1200     constructor(string memory name_, string memory symbol_) {
1201         _name = name_;
1202         _symbol = symbol_;
1203     }
1204 
1205     /**
1206      * @dev See {IERC165-supportsInterface}.
1207      */
1208     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1209         return
1210             interfaceId == type(IERC721).interfaceId ||
1211             interfaceId == type(IERC721Metadata).interfaceId ||
1212             super.supportsInterface(interfaceId);
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-balanceOf}.
1217      */
1218     function balanceOf(address owner) public view virtual override returns (uint256) {
1219         require(owner != address(0), "ERC721: balance query for the zero address");
1220         return _balances[owner];
1221     }
1222 
1223     /**
1224      * @dev See {IERC721-ownerOf}.
1225      */
1226     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1227         address owner = _owners[tokenId];
1228         require(owner != address(0), "ERC721: owner query for nonexistent token");
1229         return owner;
1230     }
1231 
1232     /**
1233      * @dev See {IERC721Metadata-name}.
1234      */
1235     function name() public view virtual override returns (string memory) {
1236         return _name;
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Metadata-symbol}.
1241      */
1242     function symbol() public view virtual override returns (string memory) {
1243         return _symbol;
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Metadata-tokenURI}.
1248      */
1249     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1250         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1251 
1252         string memory baseURI = _baseURI();
1253         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1254     }
1255 
1256     /**
1257      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1258      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1259      * by default, can be overriden in child contracts.
1260      */
1261     function _baseURI() internal view virtual returns (string memory) {
1262         return "";
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-approve}.
1267      */
1268     function approve(address to, uint256 tokenId) public virtual override {
1269         address owner = ERC721.ownerOf(tokenId);
1270         require(to != owner, "ERC721: approval to current owner");
1271 
1272         require(
1273             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1274             "ERC721: approve caller is not owner nor approved for all"
1275         );
1276 
1277         _approve(to, tokenId);
1278     }
1279 
1280     /**
1281      * @dev See {IERC721-getApproved}.
1282      */
1283     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1284         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1285 
1286         return _tokenApprovals[tokenId];
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-setApprovalForAll}.
1291      */
1292     function setApprovalForAll(address operator, bool approved) public virtual override {
1293         _setApprovalForAll(_msgSender(), operator, approved);
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-isApprovedForAll}.
1298      */
1299     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1300         return _operatorApprovals[owner][operator];
1301     }
1302 
1303     /**
1304      * @dev See {IERC721-transferFrom}.
1305      */
1306     function transferFrom(
1307         address from,
1308         address to,
1309         uint256 tokenId
1310     ) public virtual override {
1311         //solhint-disable-next-line max-line-length
1312         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1313 
1314         _transfer(from, to, tokenId);
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-safeTransferFrom}.
1319      */
1320     function safeTransferFrom(
1321         address from,
1322         address to,
1323         uint256 tokenId
1324     ) public virtual override {
1325         safeTransferFrom(from, to, tokenId, "");
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-safeTransferFrom}.
1330      */
1331     function safeTransferFrom(
1332         address from,
1333         address to,
1334         uint256 tokenId,
1335         bytes memory _data
1336     ) public virtual override {
1337         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1338         _safeTransfer(from, to, tokenId, _data);
1339     }
1340 
1341     /**
1342      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1343      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1344      *
1345      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1346      *
1347      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1348      * implement alternative mechanisms to perform token transfer, such as signature-based.
1349      *
1350      * Requirements:
1351      *
1352      * - `from` cannot be the zero address.
1353      * - `to` cannot be the zero address.
1354      * - `tokenId` token must exist and be owned by `from`.
1355      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1356      *
1357      * Emits a {Transfer} event.
1358      */
1359     function _safeTransfer(
1360         address from,
1361         address to,
1362         uint256 tokenId,
1363         bytes memory _data
1364     ) internal virtual {
1365         _transfer(from, to, tokenId);
1366         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1367     }
1368 
1369     /**
1370      * @dev Returns whether `tokenId` exists.
1371      *
1372      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1373      *
1374      * Tokens start existing when they are minted (`_mint`),
1375      * and stop existing when they are burned (`_burn`).
1376      */
1377     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1378         return _owners[tokenId] != address(0);
1379     }
1380 
1381     /**
1382      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1383      *
1384      * Requirements:
1385      *
1386      * - `tokenId` must exist.
1387      */
1388     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1389         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1390         address owner = ERC721.ownerOf(tokenId);
1391         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1392     }
1393 
1394     /**
1395      * @dev Safely mints `tokenId` and transfers it to `to`.
1396      *
1397      * Requirements:
1398      *
1399      * - `tokenId` must not exist.
1400      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1401      *
1402      * Emits a {Transfer} event.
1403      */
1404     function _safeMint(address to, uint256 tokenId) internal virtual {
1405         _safeMint(to, tokenId, "");
1406     }
1407 
1408     /**
1409      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1410      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1411      */
1412     function _safeMint(
1413         address to,
1414         uint256 tokenId,
1415         bytes memory _data
1416     ) internal virtual {
1417         _mint(to, tokenId);
1418         require(
1419             _checkOnERC721Received(address(0), to, tokenId, _data),
1420             "ERC721: transfer to non ERC721Receiver implementer"
1421         );
1422     }
1423 
1424     /**
1425      * @dev Mints `tokenId` and transfers it to `to`.
1426      *
1427      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1428      *
1429      * Requirements:
1430      *
1431      * - `tokenId` must not exist.
1432      * - `to` cannot be the zero address.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _mint(address to, uint256 tokenId) internal virtual {
1437         require(to != address(0), "ERC721: mint to the zero address");
1438         require(!_exists(tokenId), "ERC721: token already minted");
1439 
1440         _beforeTokenTransfer(address(0), to, tokenId);
1441 
1442         _balances[to] += 1;
1443         _owners[tokenId] = to;
1444 
1445         emit Transfer(address(0), to, tokenId);
1446     }
1447 
1448     /**
1449      * @dev Destroys `tokenId`.
1450      * The approval is cleared when the token is burned.
1451      *
1452      * Requirements:
1453      *
1454      * - `tokenId` must exist.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function _burn(uint256 tokenId) internal virtual {
1459         address owner = ERC721.ownerOf(tokenId);
1460 
1461         _beforeTokenTransfer(owner, address(0), tokenId);
1462 
1463         // Clear approvals
1464         _approve(address(0), tokenId);
1465 
1466         _balances[owner] -= 1;
1467         delete _owners[tokenId];
1468 
1469         emit Transfer(owner, address(0), tokenId);
1470     }
1471 
1472     /**
1473      * @dev Transfers `tokenId` from `from` to `to`.
1474      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1475      *
1476      * Requirements:
1477      *
1478      * - `to` cannot be the zero address.
1479      * - `tokenId` token must be owned by `from`.
1480      *
1481      * Emits a {Transfer} event.
1482      */
1483     function _transfer(
1484         address from,
1485         address to,
1486         uint256 tokenId
1487     ) internal virtual {
1488         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1489         require(to != address(0), "ERC721: transfer to the zero address");
1490 
1491         _beforeTokenTransfer(from, to, tokenId);
1492 
1493         // Clear approvals from the previous owner
1494         _approve(address(0), tokenId);
1495 
1496         _balances[from] -= 1;
1497         _balances[to] += 1;
1498         _owners[tokenId] = to;
1499 
1500         emit Transfer(from, to, tokenId);
1501     }
1502 
1503     /**
1504      * @dev Approve `to` to operate on `tokenId`
1505      *
1506      * Emits a {Approval} event.
1507      */
1508     function _approve(address to, uint256 tokenId) internal virtual {
1509         _tokenApprovals[tokenId] = to;
1510         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1511     }
1512 
1513     /**
1514      * @dev Approve `operator` to operate on all of `owner` tokens
1515      *
1516      * Emits a {ApprovalForAll} event.
1517      */
1518     function _setApprovalForAll(
1519         address owner,
1520         address operator,
1521         bool approved
1522     ) internal virtual {
1523         require(owner != operator, "ERC721: approve to caller");
1524         _operatorApprovals[owner][operator] = approved;
1525         emit ApprovalForAll(owner, operator, approved);
1526     }
1527 
1528     /**
1529      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1530      * The call is not executed if the target address is not a contract.
1531      *
1532      * @param from address representing the previous owner of the given token ID
1533      * @param to target address that will receive the tokens
1534      * @param tokenId uint256 ID of the token to be transferred
1535      * @param _data bytes optional data to send along with the call
1536      * @return bool whether the call correctly returned the expected magic value
1537      */
1538     function _checkOnERC721Received(
1539         address from,
1540         address to,
1541         uint256 tokenId,
1542         bytes memory _data
1543     ) private returns (bool) {
1544         if (to.isContract()) {
1545             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1546                 return retval == IERC721Receiver.onERC721Received.selector;
1547             } catch (bytes memory reason) {
1548                 if (reason.length == 0) {
1549                     revert("ERC721: transfer to non ERC721Receiver implementer");
1550                 } else {
1551                     assembly {
1552                         revert(add(32, reason), mload(reason))
1553                     }
1554                 }
1555             }
1556         } else {
1557             return true;
1558         }
1559     }
1560 
1561     /**
1562      * @dev Hook that is called before any token transfer. This includes minting
1563      * and burning.
1564      *
1565      * Calling conditions:
1566      *
1567      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1568      * transferred to `to`.
1569      * - When `from` is zero, `tokenId` will be minted for `to`.
1570      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1571      * - `from` and `to` are never both zero.
1572      *
1573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1574      */
1575     function _beforeTokenTransfer(
1576         address from,
1577         address to,
1578         uint256 tokenId
1579     ) internal virtual {}
1580 }
1581 
1582 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1583 
1584 
1585 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1586 
1587 pragma solidity ^0.8.0;
1588 
1589 
1590 
1591 /**
1592  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1593  * enumerability of all the token ids in the contract as well as all token ids owned by each
1594  * account.
1595  */
1596 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1597     // Mapping from owner to list of owned token IDs
1598     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1599 
1600     // Mapping from token ID to index of the owner tokens list
1601     mapping(uint256 => uint256) private _ownedTokensIndex;
1602 
1603     // Array with all token ids, used for enumeration
1604     uint256[] private _allTokens;
1605 
1606     // Mapping from token id to position in the allTokens array
1607     mapping(uint256 => uint256) private _allTokensIndex;
1608 
1609     /**
1610      * @dev See {IERC165-supportsInterface}.
1611      */
1612     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1613         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1614     }
1615 
1616     /**
1617      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1618      */
1619     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1620         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1621         return _ownedTokens[owner][index];
1622     }
1623 
1624     /**
1625      * @dev See {IERC721Enumerable-totalSupply}.
1626      */
1627     function totalSupply() public view virtual override returns (uint256) {
1628         return _allTokens.length;
1629     }
1630 
1631     /**
1632      * @dev See {IERC721Enumerable-tokenByIndex}.
1633      */
1634     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1635         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1636         return _allTokens[index];
1637     }
1638 
1639     /**
1640      * @dev Hook that is called before any token transfer. This includes minting
1641      * and burning.
1642      *
1643      * Calling conditions:
1644      *
1645      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1646      * transferred to `to`.
1647      * - When `from` is zero, `tokenId` will be minted for `to`.
1648      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1649      * - `from` cannot be the zero address.
1650      * - `to` cannot be the zero address.
1651      *
1652      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1653      */
1654     function _beforeTokenTransfer(
1655         address from,
1656         address to,
1657         uint256 tokenId
1658     ) internal virtual override {
1659         super._beforeTokenTransfer(from, to, tokenId);
1660 
1661         if (from == address(0)) {
1662             _addTokenToAllTokensEnumeration(tokenId);
1663         } else if (from != to) {
1664             _removeTokenFromOwnerEnumeration(from, tokenId);
1665         }
1666         if (to == address(0)) {
1667             _removeTokenFromAllTokensEnumeration(tokenId);
1668         } else if (to != from) {
1669             _addTokenToOwnerEnumeration(to, tokenId);
1670         }
1671     }
1672 
1673     /**
1674      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1675      * @param to address representing the new owner of the given token ID
1676      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1677      */
1678     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1679         uint256 length = ERC721.balanceOf(to);
1680         _ownedTokens[to][length] = tokenId;
1681         _ownedTokensIndex[tokenId] = length;
1682     }
1683 
1684     /**
1685      * @dev Private function to add a token to this extension's token tracking data structures.
1686      * @param tokenId uint256 ID of the token to be added to the tokens list
1687      */
1688     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1689         _allTokensIndex[tokenId] = _allTokens.length;
1690         _allTokens.push(tokenId);
1691     }
1692 
1693     /**
1694      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1695      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1696      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1697      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1698      * @param from address representing the previous owner of the given token ID
1699      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1700      */
1701     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1702         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1703         // then delete the last slot (swap and pop).
1704 
1705         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1706         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1707 
1708         // When the token to delete is the last token, the swap operation is unnecessary
1709         if (tokenIndex != lastTokenIndex) {
1710             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1711 
1712             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1713             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1714         }
1715 
1716         // This also deletes the contents at the last position of the array
1717         delete _ownedTokensIndex[tokenId];
1718         delete _ownedTokens[from][lastTokenIndex];
1719     }
1720 
1721     /**
1722      * @dev Private function to remove a token from this extension's token tracking data structures.
1723      * This has O(1) time complexity, but alters the order of the _allTokens array.
1724      * @param tokenId uint256 ID of the token to be removed from the tokens list
1725      */
1726     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1727         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1728         // then delete the last slot (swap and pop).
1729 
1730         uint256 lastTokenIndex = _allTokens.length - 1;
1731         uint256 tokenIndex = _allTokensIndex[tokenId];
1732 
1733         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1734         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1735         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1736         uint256 lastTokenId = _allTokens[lastTokenIndex];
1737 
1738         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1739         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1740 
1741         // This also deletes the contents at the last position of the array
1742         delete _allTokensIndex[tokenId];
1743         _allTokens.pop();
1744     }
1745 }
1746 
1747 // File: contracts/ninetales.sol
1748 
1749 
1750 
1751 pragma solidity ^0.8.4;
1752 
1753 
1754 
1755 
1756 
1757 
1758 contract NineTales is ERC721Enumerable, Ownable {
1759     using Strings for uint256;
1760     using SafeMath for uint256;
1761     using ECDSA for bytes32;
1762 
1763     uint256 public NTT_PER_USER = 10;
1764     uint256 public constant NTT_PRESALE = 999;
1765     uint256 public constant NTT_GIFT = 200;
1766     uint256 public constant NTT_PUBLIC = 8800;
1767     uint256 public constant NTT_MAX_SUPPLY = 9999;
1768     uint256 public constant NTT_PRESALE_PRICE = 0.049 ether;
1769     uint256 public NTT_PUBLIC_PRICE = 0.089 ether;
1770     
1771     mapping(address => uint256) public addressNumMinted;
1772     
1773     string private _tokenBaseURI;
1774     string private _finalProvenanceHash;
1775     address private _ownerAddress = 0xcd99C8B1723dA75d654F734499C64d8fe815F1aA;
1776     address private _consultant = 0x69B630b2Dc0eC30258494435Cc3d28C2167D5053;
1777     address private _signerAddress = 0xBa8128fF5f4220f6190A61234567F190942dBEf6;
1778 
1779     uint256 public giftedAmount;
1780     uint256 public publicAmountMinted;
1781     uint256 public presaleAmountMinted;
1782 
1783     bool public presaleOnly = true;
1784     bool public saleIsLive = true;
1785     bool public hashMintOnly = true;
1786     bool public provenanceLocked = false;
1787     
1788     
1789     constructor() ERC721("Nine Tales NFT Official", "NTT") { }
1790 
1791     modifier liveSale {
1792         require(saleIsLive, "SALE_CLOSED");
1793         _;
1794     }
1795 
1796     function hashTx(address sender) private pure returns(bytes32) {
1797         bytes32 hash = keccak256(abi.encodePacked(sender)).toEthSignedMessageHash();
1798         return hash;
1799     }
1800   
1801     function matchAddressSigner(bytes32 hash, bytes memory signature) private view returns(bool) {
1802         return _signerAddress == hash.toEthSignedMessageHash().recover(signature);
1803     }
1804 
1805     function presaleMint(uint256 tokenQuantity) private {
1806         require(presaleAmountMinted + tokenQuantity <= NTT_PRESALE, "EXCEEDS_PRESALE_MAX");
1807         require(addressNumMinted[msg.sender] + tokenQuantity <=  NTT_PER_USER, "EXCEEDS_TOKENS_PER_USER");
1808         require(NTT_PRESALE_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1809         
1810         addressNumMinted[msg.sender] += tokenQuantity;                                                            
1811 
1812         for(uint256 i = 0; i < tokenQuantity; i++) {
1813             presaleAmountMinted++;
1814             _safeMint(msg.sender, totalSupply() + 1);
1815         }
1816     }
1817 
1818     function publicMint(uint256 tokenQuantity) private {
1819         require(publicAmountMinted + tokenQuantity <= NTT_PUBLIC, "EXCEEDS_PUBLIC_MAX");
1820         require(balanceOf(msg.sender) + tokenQuantity <= NTT_PER_USER, "EXCEEDS_TOKENS_PER_USER");
1821         require(NTT_PUBLIC_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1822 
1823         for(uint256 i = 0; i < tokenQuantity; i++) {
1824             publicAmountMinted++;
1825             _safeMint(msg.sender, totalSupply() + 1);
1826         }
1827     }
1828 
1829     function mint(uint256 tokenQuantity) public payable liveSale {
1830         require(!hashMintOnly,"DIRECT_MINT_DISALLOWED");
1831         require(tokenQuantity > 0, "AMOUNT_ERROR");
1832         require(totalSupply() < NTT_MAX_SUPPLY, "OUT_OF_STOCK");
1833 
1834         if(presaleOnly) {
1835             presaleMint(tokenQuantity);            
1836         }
1837         else {
1838             publicMint(tokenQuantity);
1839         }
1840     }
1841 
1842     function hashMint(bytes memory signature, uint256 tokenQuantity) external payable liveSale  {
1843         require(hashMintOnly,"WRONG_FUNCTION");
1844         require(matchAddressSigner(hashTx(msg.sender), signature), "DIRECT_MINT_DISALLOWED");
1845         require(tokenQuantity > 0, "AMOUNT_ERROR");
1846         require(totalSupply() < NTT_MAX_SUPPLY, "OUT_OF_STOCK");
1847 
1848         if(presaleOnly) {                                                          
1849             presaleMint(tokenQuantity);                                                  
1850         }
1851         else {
1852             publicMint(tokenQuantity);
1853         }
1854     }
1855 
1856     function gift(address[] calldata winners) external onlyOwner {
1857         require(totalSupply() + winners.length <= NTT_MAX_SUPPLY, "EXCEEDS_MAX_SUPPLY");
1858         require(giftedAmount + winners.length <= NTT_GIFT, "EXCEEDS_GIFTS_MAX");
1859         
1860         for (uint256 i = 0; i < winners.length; i++) {
1861             giftedAmount++;
1862             _safeMint(winners[i], totalSupply() + 1);
1863         }
1864     }
1865 
1866     function withdrawAll() public onlyOwner {
1867         uint256 balance = address(this).balance;
1868         require(balance > 0,"NO_BALANCE");
1869         
1870         _withdraw(_consultant, balance.mul(5).div(100));
1871         _withdraw(_ownerAddress, address(this).balance);        
1872     }
1873 
1874     function _withdraw(address _address, uint256 _amount) private {
1875         (bool success, ) = _address.call{value: _amount}("");
1876         require(success, "TRANSFER_FAIL");
1877     }
1878 
1879     function setFinalProvenanceHash(string memory provenanceHash) external onlyOwner {
1880         require(!provenanceLocked, "PROVENANCE_LOCKED");
1881         _finalProvenanceHash = provenanceHash;
1882         provenanceLocked = true;
1883     }
1884 
1885     function getFinalProvenanceHash() external view returns(string memory){
1886         return _finalProvenanceHash;
1887     }
1888 
1889     function changePresaleStatus() external onlyOwner {
1890         presaleOnly = !presaleOnly;
1891     }
1892 
1893     function changeSaleStatus() external onlyOwner {
1894         saleIsLive = !saleIsLive;
1895     }
1896 
1897     function changeHashOnlyStatus() external onlyOwner {
1898         hashMintOnly = !hashMintOnly;
1899     }
1900 
1901     function getHashMintVariable() external view returns(bool) {
1902         return hashMintOnly;
1903     }
1904 
1905     function getAmountMinted() external view returns(uint256) {
1906         return addressNumMinted[msg.sender];
1907     }
1908 
1909     function setSignerAddress(address _addr) external onlyOwner {
1910         _signerAddress = _addr;
1911     }
1912 
1913     function setBaseURI(string calldata URI) external onlyOwner {
1914         _tokenBaseURI = URI;
1915     }
1916 
1917     function setNttPerUserLimit(uint256 _limit) public onlyOwner {
1918         NTT_PER_USER = _limit;
1919     }
1920 
1921     function setPublicPrice(uint256 _salePrice) public onlyOwner {
1922         NTT_PUBLIC_PRICE = _salePrice;
1923     }
1924 
1925     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1926         require(_exists(tokenId), "NONEXISTANT_TOKEN");
1927         
1928         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1929     }
1930 }