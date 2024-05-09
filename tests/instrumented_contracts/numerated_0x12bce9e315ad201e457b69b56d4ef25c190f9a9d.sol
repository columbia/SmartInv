1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
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
304 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
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
537 // File: @openzeppelin/contracts/utils/Address.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @dev Collection of functions related to the address type
546  */
547 library Address {
548     /**
549      * @dev Returns true if `account` is a contract.
550      *
551      * [IMPORTANT]
552      * ====
553      * It is unsafe to assume that an address for which this function returns
554      * false is an externally-owned account (EOA) and not a contract.
555      *
556      * Among others, `isContract` will return false for the following
557      * types of addresses:
558      *
559      *  - an externally-owned account
560      *  - a contract in construction
561      *  - an address where a contract will be created
562      *  - an address where a contract lived, but was destroyed
563      * ====
564      */
565     function isContract(address account) internal view returns (bool) {
566         // This method relies on extcodesize, which returns 0 for contracts in
567         // construction, since the code is only stored at the end of the
568         // constructor execution.
569 
570         uint256 size;
571         assembly {
572             size := extcodesize(account)
573         }
574         return size > 0;
575     }
576 
577     /**
578      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
579      * `recipient`, forwarding all available gas and reverting on errors.
580      *
581      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
582      * of certain opcodes, possibly making contracts go over the 2300 gas limit
583      * imposed by `transfer`, making them unable to receive funds via
584      * `transfer`. {sendValue} removes this limitation.
585      *
586      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
587      *
588      * IMPORTANT: because control is transferred to `recipient`, care must be
589      * taken to not create reentrancy vulnerabilities. Consider using
590      * {ReentrancyGuard} or the
591      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
592      */
593     function sendValue(address payable recipient, uint256 amount) internal {
594         require(address(this).balance >= amount, "Address: insufficient balance");
595 
596         (bool success, ) = recipient.call{value: amount}("");
597         require(success, "Address: unable to send value, recipient may have reverted");
598     }
599 
600     /**
601      * @dev Performs a Solidity function call using a low level `call`. A
602      * plain `call` is an unsafe replacement for a function call: use this
603      * function instead.
604      *
605      * If `target` reverts with a revert reason, it is bubbled up by this
606      * function (like regular Solidity function calls).
607      *
608      * Returns the raw returned data. To convert to the expected return value,
609      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
610      *
611      * Requirements:
612      *
613      * - `target` must be a contract.
614      * - calling `target` with `data` must not revert.
615      *
616      * _Available since v3.1._
617      */
618     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
619         return functionCall(target, data, "Address: low-level call failed");
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
624      * `errorMessage` as a fallback revert reason when `target` reverts.
625      *
626      * _Available since v3.1._
627      */
628     function functionCall(
629         address target,
630         bytes memory data,
631         string memory errorMessage
632     ) internal returns (bytes memory) {
633         return functionCallWithValue(target, data, 0, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but also transferring `value` wei to `target`.
639      *
640      * Requirements:
641      *
642      * - the calling contract must have an ETH balance of at least `value`.
643      * - the called Solidity function must be `payable`.
644      *
645      * _Available since v3.1._
646      */
647     function functionCallWithValue(
648         address target,
649         bytes memory data,
650         uint256 value
651     ) internal returns (bytes memory) {
652         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
657      * with `errorMessage` as a fallback revert reason when `target` reverts.
658      *
659      * _Available since v3.1._
660      */
661     function functionCallWithValue(
662         address target,
663         bytes memory data,
664         uint256 value,
665         string memory errorMessage
666     ) internal returns (bytes memory) {
667         require(address(this).balance >= value, "Address: insufficient balance for call");
668         require(isContract(target), "Address: call to non-contract");
669 
670         (bool success, bytes memory returndata) = target.call{value: value}(data);
671         return verifyCallResult(success, returndata, errorMessage);
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
676      * but performing a static call.
677      *
678      * _Available since v3.3._
679      */
680     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
681         return functionStaticCall(target, data, "Address: low-level static call failed");
682     }
683 
684     /**
685      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
686      * but performing a static call.
687      *
688      * _Available since v3.3._
689      */
690     function functionStaticCall(
691         address target,
692         bytes memory data,
693         string memory errorMessage
694     ) internal view returns (bytes memory) {
695         require(isContract(target), "Address: static call to non-contract");
696 
697         (bool success, bytes memory returndata) = target.staticcall(data);
698         return verifyCallResult(success, returndata, errorMessage);
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
703      * but performing a delegate call.
704      *
705      * _Available since v3.4._
706      */
707     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
708         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
713      * but performing a delegate call.
714      *
715      * _Available since v3.4._
716      */
717     function functionDelegateCall(
718         address target,
719         bytes memory data,
720         string memory errorMessage
721     ) internal returns (bytes memory) {
722         require(isContract(target), "Address: delegate call to non-contract");
723 
724         (bool success, bytes memory returndata) = target.delegatecall(data);
725         return verifyCallResult(success, returndata, errorMessage);
726     }
727 
728     /**
729      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
730      * revert reason using the provided one.
731      *
732      * _Available since v4.3._
733      */
734     function verifyCallResult(
735         bool success,
736         bytes memory returndata,
737         string memory errorMessage
738     ) internal pure returns (bytes memory) {
739         if (success) {
740             return returndata;
741         } else {
742             // Look for revert reason and bubble it up if present
743             if (returndata.length > 0) {
744                 // The easiest way to bubble the revert reason is using memory via assembly
745 
746                 assembly {
747                     let returndata_size := mload(returndata)
748                     revert(add(32, returndata), returndata_size)
749                 }
750             } else {
751                 revert(errorMessage);
752             }
753         }
754     }
755 }
756 
757 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
758 
759 
760 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 /**
765  * @dev Interface of the ERC165 standard, as defined in the
766  * https://eips.ethereum.org/EIPS/eip-165[EIP].
767  *
768  * Implementers can declare support of contract interfaces, which can then be
769  * queried by others ({ERC165Checker}).
770  *
771  * For an implementation, see {ERC165}.
772  */
773 interface IERC165 {
774     /**
775      * @dev Returns true if this contract implements the interface defined by
776      * `interfaceId`. See the corresponding
777      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
778      * to learn more about how these ids are created.
779      *
780      * This function call must use less than 30 000 gas.
781      */
782     function supportsInterface(bytes4 interfaceId) external view returns (bool);
783 }
784 
785 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
786 
787 
788 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 /**
794  * @dev Implementation of the {IERC165} interface.
795  *
796  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
797  * for the additional interface id that will be supported. For example:
798  *
799  * ```solidity
800  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
801  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
802  * }
803  * ```
804  *
805  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
806  */
807 abstract contract ERC165 is IERC165 {
808     /**
809      * @dev See {IERC165-supportsInterface}.
810      */
811     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
812         return interfaceId == type(IERC165).interfaceId;
813     }
814 }
815 
816 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
817 
818 
819 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
820 
821 pragma solidity ^0.8.0;
822 
823 
824 /**
825  * @dev _Available since v3.1._
826  */
827 interface IERC1155Receiver is IERC165 {
828     /**
829         @dev Handles the receipt of a single ERC1155 token type. This function is
830         called at the end of a `safeTransferFrom` after the balance has been updated.
831         To accept the transfer, this must return
832         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
833         (i.e. 0xf23a6e61, or its own function selector).
834         @param operator The address which initiated the transfer (i.e. msg.sender)
835         @param from The address which previously owned the token
836         @param id The ID of the token being transferred
837         @param value The amount of tokens being transferred
838         @param data Additional data with no specified format
839         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
840     */
841     function onERC1155Received(
842         address operator,
843         address from,
844         uint256 id,
845         uint256 value,
846         bytes calldata data
847     ) external returns (bytes4);
848 
849     /**
850         @dev Handles the receipt of a multiple ERC1155 token types. This function
851         is called at the end of a `safeBatchTransferFrom` after the balances have
852         been updated. To accept the transfer(s), this must return
853         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
854         (i.e. 0xbc197c81, or its own function selector).
855         @param operator The address which initiated the batch transfer (i.e. msg.sender)
856         @param from The address which previously owned the token
857         @param ids An array containing ids of each token being transferred (order and length must match values array)
858         @param values An array containing amounts of each token being transferred (order and length must match ids array)
859         @param data Additional data with no specified format
860         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
861     */
862     function onERC1155BatchReceived(
863         address operator,
864         address from,
865         uint256[] calldata ids,
866         uint256[] calldata values,
867         bytes calldata data
868     ) external returns (bytes4);
869 }
870 
871 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
872 
873 
874 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
875 
876 pragma solidity ^0.8.0;
877 
878 
879 /**
880  * @dev Required interface of an ERC1155 compliant contract, as defined in the
881  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
882  *
883  * _Available since v3.1._
884  */
885 interface IERC1155 is IERC165 {
886     /**
887      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
888      */
889     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
890 
891     /**
892      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
893      * transfers.
894      */
895     event TransferBatch(
896         address indexed operator,
897         address indexed from,
898         address indexed to,
899         uint256[] ids,
900         uint256[] values
901     );
902 
903     /**
904      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
905      * `approved`.
906      */
907     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
908 
909     /**
910      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
911      *
912      * If an {URI} event was emitted for `id`, the standard
913      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
914      * returned by {IERC1155MetadataURI-uri}.
915      */
916     event URI(string value, uint256 indexed id);
917 
918     /**
919      * @dev Returns the amount of tokens of token type `id` owned by `account`.
920      *
921      * Requirements:
922      *
923      * - `account` cannot be the zero address.
924      */
925     function balanceOf(address account, uint256 id) external view returns (uint256);
926 
927     /**
928      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
929      *
930      * Requirements:
931      *
932      * - `accounts` and `ids` must have the same length.
933      */
934     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
935         external
936         view
937         returns (uint256[] memory);
938 
939     /**
940      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
941      *
942      * Emits an {ApprovalForAll} event.
943      *
944      * Requirements:
945      *
946      * - `operator` cannot be the caller.
947      */
948     function setApprovalForAll(address operator, bool approved) external;
949 
950     /**
951      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
952      *
953      * See {setApprovalForAll}.
954      */
955     function isApprovedForAll(address account, address operator) external view returns (bool);
956 
957     /**
958      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
959      *
960      * Emits a {TransferSingle} event.
961      *
962      * Requirements:
963      *
964      * - `to` cannot be the zero address.
965      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
966      * - `from` must have a balance of tokens of type `id` of at least `amount`.
967      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
968      * acceptance magic value.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 id,
974         uint256 amount,
975         bytes calldata data
976     ) external;
977 
978     /**
979      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
980      *
981      * Emits a {TransferBatch} event.
982      *
983      * Requirements:
984      *
985      * - `ids` and `amounts` must have the same length.
986      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
987      * acceptance magic value.
988      */
989     function safeBatchTransferFrom(
990         address from,
991         address to,
992         uint256[] calldata ids,
993         uint256[] calldata amounts,
994         bytes calldata data
995     ) external;
996 }
997 
998 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
999 
1000 
1001 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1002 
1003 pragma solidity ^0.8.0;
1004 
1005 
1006 /**
1007  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1008  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1009  *
1010  * _Available since v3.1._
1011  */
1012 interface IERC1155MetadataURI is IERC1155 {
1013     /**
1014      * @dev Returns the URI for token type `id`.
1015      *
1016      * If the `\{id\}` substring is present in the URI, it must be replaced by
1017      * clients with the actual token type ID.
1018      */
1019     function uri(uint256 id) external view returns (string memory);
1020 }
1021 
1022 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1023 
1024 
1025 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1026 
1027 pragma solidity ^0.8.0;
1028 
1029 /**
1030  * @dev Contract module that helps prevent reentrant calls to a function.
1031  *
1032  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1033  * available, which can be applied to functions to make sure there are no nested
1034  * (reentrant) calls to them.
1035  *
1036  * Note that because there is a single `nonReentrant` guard, functions marked as
1037  * `nonReentrant` may not call one another. This can be worked around by making
1038  * those functions `private`, and then adding `external` `nonReentrant` entry
1039  * points to them.
1040  *
1041  * TIP: If you would like to learn more about reentrancy and alternative ways
1042  * to protect against it, check out our blog post
1043  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1044  */
1045 abstract contract ReentrancyGuard {
1046     // Booleans are more expensive than uint256 or any type that takes up a full
1047     // word because each write operation emits an extra SLOAD to first read the
1048     // slot's contents, replace the bits taken up by the boolean, and then write
1049     // back. This is the compiler's defense against contract upgrades and
1050     // pointer aliasing, and it cannot be disabled.
1051 
1052     // The values being non-zero value makes deployment a bit more expensive,
1053     // but in exchange the refund on every call to nonReentrant will be lower in
1054     // amount. Since refunds are capped to a percentage of the total
1055     // transaction's gas, it is best to keep them low in cases like this one, to
1056     // increase the likelihood of the full refund coming into effect.
1057     uint256 private constant _NOT_ENTERED = 1;
1058     uint256 private constant _ENTERED = 2;
1059 
1060     uint256 private _status;
1061 
1062     constructor() {
1063         _status = _NOT_ENTERED;
1064     }
1065 
1066     /**
1067      * @dev Prevents a contract from calling itself, directly or indirectly.
1068      * Calling a `nonReentrant` function from another `nonReentrant`
1069      * function is not supported. It is possible to prevent this from happening
1070      * by making the `nonReentrant` function external, and making it call a
1071      * `private` function that does the actual work.
1072      */
1073     modifier nonReentrant() {
1074         // On the first call to nonReentrant, _notEntered will be true
1075         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1076 
1077         // Any calls to nonReentrant after this point will fail
1078         _status = _ENTERED;
1079 
1080         _;
1081 
1082         // By storing the original value once again, a refund is triggered (see
1083         // https://eips.ethereum.org/EIPS/eip-2200)
1084         _status = _NOT_ENTERED;
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
1115 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1116 
1117 
1118 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 
1123 
1124 
1125 
1126 
1127 
1128 /**
1129  * @dev Implementation of the basic standard multi-token.
1130  * See https://eips.ethereum.org/EIPS/eip-1155
1131  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1132  *
1133  * _Available since v3.1._
1134  */
1135 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1136     using Address for address;
1137 
1138     // Mapping from token ID to account balances
1139     mapping(uint256 => mapping(address => uint256)) private _balances;
1140 
1141     // Mapping from account to operator approvals
1142     mapping(address => mapping(address => bool)) private _operatorApprovals;
1143 
1144     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1145     string private _uri;
1146 
1147     /**
1148      * @dev See {_setURI}.
1149      */
1150     constructor(string memory uri_) {
1151         _setURI(uri_);
1152     }
1153 
1154     /**
1155      * @dev See {IERC165-supportsInterface}.
1156      */
1157     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1158         return
1159             interfaceId == type(IERC1155).interfaceId ||
1160             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1161             super.supportsInterface(interfaceId);
1162     }
1163 
1164     /**
1165      * @dev See {IERC1155MetadataURI-uri}.
1166      *
1167      * This implementation returns the same URI for *all* token types. It relies
1168      * on the token type ID substitution mechanism
1169      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1170      *
1171      * Clients calling this function must replace the `\{id\}` substring with the
1172      * actual token type ID.
1173      */
1174     function uri(uint256) public view virtual override returns (string memory) {
1175         return _uri;
1176     }
1177 
1178     /**
1179      * @dev See {IERC1155-balanceOf}.
1180      *
1181      * Requirements:
1182      *
1183      * - `account` cannot be the zero address.
1184      */
1185     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1186         require(account != address(0), "ERC1155: balance query for the zero address");
1187         return _balances[id][account];
1188     }
1189 
1190     /**
1191      * @dev See {IERC1155-balanceOfBatch}.
1192      *
1193      * Requirements:
1194      *
1195      * - `accounts` and `ids` must have the same length.
1196      */
1197     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1198         public
1199         view
1200         virtual
1201         override
1202         returns (uint256[] memory)
1203     {
1204         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1205 
1206         uint256[] memory batchBalances = new uint256[](accounts.length);
1207 
1208         for (uint256 i = 0; i < accounts.length; ++i) {
1209             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1210         }
1211 
1212         return batchBalances;
1213     }
1214 
1215     /**
1216      * @dev See {IERC1155-setApprovalForAll}.
1217      */
1218     function setApprovalForAll(address operator, bool approved) public virtual override {
1219         _setApprovalForAll(_msgSender(), operator, approved);
1220     }
1221 
1222     /**
1223      * @dev See {IERC1155-isApprovedForAll}.
1224      */
1225     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1226         return _operatorApprovals[account][operator];
1227     }
1228 
1229     /**
1230      * @dev See {IERC1155-safeTransferFrom}.
1231      */
1232     function safeTransferFrom(
1233         address from,
1234         address to,
1235         uint256 id,
1236         uint256 amount,
1237         bytes memory data
1238     ) public virtual override {
1239         require(
1240             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1241             "ERC1155: caller is not owner nor approved"
1242         );
1243         _safeTransferFrom(from, to, id, amount, data);
1244     }
1245 
1246     /**
1247      * @dev See {IERC1155-safeBatchTransferFrom}.
1248      */
1249     function safeBatchTransferFrom(
1250         address from,
1251         address to,
1252         uint256[] memory ids,
1253         uint256[] memory amounts,
1254         bytes memory data
1255     ) public virtual override {
1256         require(
1257             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1258             "ERC1155: transfer caller is not owner nor approved"
1259         );
1260         _safeBatchTransferFrom(from, to, ids, amounts, data);
1261     }
1262 
1263     /**
1264      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1265      *
1266      * Emits a {TransferSingle} event.
1267      *
1268      * Requirements:
1269      *
1270      * - `to` cannot be the zero address.
1271      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1272      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1273      * acceptance magic value.
1274      */
1275     function _safeTransferFrom(
1276         address from,
1277         address to,
1278         uint256 id,
1279         uint256 amount,
1280         bytes memory data
1281     ) internal virtual {
1282         require(to != address(0), "ERC1155: transfer to the zero address");
1283 
1284         address operator = _msgSender();
1285 
1286         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1287 
1288         uint256 fromBalance = _balances[id][from];
1289         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1290         unchecked {
1291             _balances[id][from] = fromBalance - amount;
1292         }
1293         _balances[id][to] += amount;
1294 
1295         emit TransferSingle(operator, from, to, id, amount);
1296 
1297         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1298     }
1299 
1300     /**
1301      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1302      *
1303      * Emits a {TransferBatch} event.
1304      *
1305      * Requirements:
1306      *
1307      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1308      * acceptance magic value.
1309      */
1310     function _safeBatchTransferFrom(
1311         address from,
1312         address to,
1313         uint256[] memory ids,
1314         uint256[] memory amounts,
1315         bytes memory data
1316     ) internal virtual {
1317         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1318         require(to != address(0), "ERC1155: transfer to the zero address");
1319 
1320         address operator = _msgSender();
1321 
1322         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1323 
1324         for (uint256 i = 0; i < ids.length; ++i) {
1325             uint256 id = ids[i];
1326             uint256 amount = amounts[i];
1327 
1328             uint256 fromBalance = _balances[id][from];
1329             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1330             unchecked {
1331                 _balances[id][from] = fromBalance - amount;
1332             }
1333             _balances[id][to] += amount;
1334         }
1335 
1336         emit TransferBatch(operator, from, to, ids, amounts);
1337 
1338         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1339     }
1340 
1341     /**
1342      * @dev Sets a new URI for all token types, by relying on the token type ID
1343      * substitution mechanism
1344      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1345      *
1346      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1347      * URI or any of the amounts in the JSON file at said URI will be replaced by
1348      * clients with the token type ID.
1349      *
1350      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1351      * interpreted by clients as
1352      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1353      * for token type ID 0x4cce0.
1354      *
1355      * See {uri}.
1356      *
1357      * Because these URIs cannot be meaningfully represented by the {URI} event,
1358      * this function emits no events.
1359      */
1360     function _setURI(string memory newuri) internal virtual {
1361         _uri = newuri;
1362     }
1363 
1364     /**
1365      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1366      *
1367      * Emits a {TransferSingle} event.
1368      *
1369      * Requirements:
1370      *
1371      * - `to` cannot be the zero address.
1372      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1373      * acceptance magic value.
1374      */
1375     function _mint(
1376         address to,
1377         uint256 id,
1378         uint256 amount,
1379         bytes memory data
1380     ) internal virtual {
1381         require(to != address(0), "ERC1155: mint to the zero address");
1382 
1383         address operator = _msgSender();
1384 
1385         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1386 
1387         _balances[id][to] += amount;
1388         emit TransferSingle(operator, address(0), to, id, amount);
1389 
1390         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1391     }
1392 
1393     /**
1394      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1395      *
1396      * Requirements:
1397      *
1398      * - `ids` and `amounts` must have the same length.
1399      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1400      * acceptance magic value.
1401      */
1402     function _mintBatch(
1403         address to,
1404         uint256[] memory ids,
1405         uint256[] memory amounts,
1406         bytes memory data
1407     ) internal virtual {
1408         require(to != address(0), "ERC1155: mint to the zero address");
1409         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1410 
1411         address operator = _msgSender();
1412 
1413         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1414 
1415         for (uint256 i = 0; i < ids.length; i++) {
1416             _balances[ids[i]][to] += amounts[i];
1417         }
1418 
1419         emit TransferBatch(operator, address(0), to, ids, amounts);
1420 
1421         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1422     }
1423 
1424     /**
1425      * @dev Destroys `amount` tokens of token type `id` from `from`
1426      *
1427      * Requirements:
1428      *
1429      * - `from` cannot be the zero address.
1430      * - `from` must have at least `amount` tokens of token type `id`.
1431      */
1432     function _burn(
1433         address from,
1434         uint256 id,
1435         uint256 amount
1436     ) internal virtual {
1437         require(from != address(0), "ERC1155: burn from the zero address");
1438 
1439         address operator = _msgSender();
1440 
1441         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1442 
1443         uint256 fromBalance = _balances[id][from];
1444         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1445         unchecked {
1446             _balances[id][from] = fromBalance - amount;
1447         }
1448 
1449         emit TransferSingle(operator, from, address(0), id, amount);
1450     }
1451 
1452     /**
1453      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1454      *
1455      * Requirements:
1456      *
1457      * - `ids` and `amounts` must have the same length.
1458      */
1459     function _burnBatch(
1460         address from,
1461         uint256[] memory ids,
1462         uint256[] memory amounts
1463     ) internal virtual {
1464         require(from != address(0), "ERC1155: burn from the zero address");
1465         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1466 
1467         address operator = _msgSender();
1468 
1469         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1470 
1471         for (uint256 i = 0; i < ids.length; i++) {
1472             uint256 id = ids[i];
1473             uint256 amount = amounts[i];
1474 
1475             uint256 fromBalance = _balances[id][from];
1476             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1477             unchecked {
1478                 _balances[id][from] = fromBalance - amount;
1479             }
1480         }
1481 
1482         emit TransferBatch(operator, from, address(0), ids, amounts);
1483     }
1484 
1485     /**
1486      * @dev Approve `operator` to operate on all of `owner` tokens
1487      *
1488      * Emits a {ApprovalForAll} event.
1489      */
1490     function _setApprovalForAll(
1491         address owner,
1492         address operator,
1493         bool approved
1494     ) internal virtual {
1495         require(owner != operator, "ERC1155: setting approval status for self");
1496         _operatorApprovals[owner][operator] = approved;
1497         emit ApprovalForAll(owner, operator, approved);
1498     }
1499 
1500     /**
1501      * @dev Hook that is called before any token transfer. This includes minting
1502      * and burning, as well as batched variants.
1503      *
1504      * The same hook is called on both single and batched variants. For single
1505      * transfers, the length of the `id` and `amount` arrays will be 1.
1506      *
1507      * Calling conditions (for each `id` and `amount` pair):
1508      *
1509      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1510      * of token type `id` will be  transferred to `to`.
1511      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1512      * for `to`.
1513      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1514      * will be burned.
1515      * - `from` and `to` are never both zero.
1516      * - `ids` and `amounts` have the same, non-zero length.
1517      *
1518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1519      */
1520     function _beforeTokenTransfer(
1521         address operator,
1522         address from,
1523         address to,
1524         uint256[] memory ids,
1525         uint256[] memory amounts,
1526         bytes memory data
1527     ) internal virtual {}
1528 
1529     function _doSafeTransferAcceptanceCheck(
1530         address operator,
1531         address from,
1532         address to,
1533         uint256 id,
1534         uint256 amount,
1535         bytes memory data
1536     ) private {
1537         if (to.isContract()) {
1538             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1539                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1540                     revert("ERC1155: ERC1155Receiver rejected tokens");
1541                 }
1542             } catch Error(string memory reason) {
1543                 revert(reason);
1544             } catch {
1545                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1546             }
1547         }
1548     }
1549 
1550     function _doSafeBatchTransferAcceptanceCheck(
1551         address operator,
1552         address from,
1553         address to,
1554         uint256[] memory ids,
1555         uint256[] memory amounts,
1556         bytes memory data
1557     ) private {
1558         if (to.isContract()) {
1559             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1560                 bytes4 response
1561             ) {
1562                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1563                     revert("ERC1155: ERC1155Receiver rejected tokens");
1564                 }
1565             } catch Error(string memory reason) {
1566                 revert(reason);
1567             } catch {
1568                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1569             }
1570         }
1571     }
1572 
1573     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1574         uint256[] memory array = new uint256[](1);
1575         array[0] = element;
1576 
1577         return array;
1578     }
1579 }
1580 
1581 // File: @openzeppelin/contracts/access/Ownable.sol
1582 
1583 
1584 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 
1589 /**
1590  * @dev Contract module which provides a basic access control mechanism, where
1591  * there is an account (an owner) that can be granted exclusive access to
1592  * specific functions.
1593  *
1594  * By default, the owner account will be the one that deploys the contract. This
1595  * can later be changed with {transferOwnership}.
1596  *
1597  * This module is used through inheritance. It will make available the modifier
1598  * `onlyOwner`, which can be applied to your functions to restrict their use to
1599  * the owner.
1600  */
1601 abstract contract Ownable is Context {
1602     address private _owner;
1603 
1604     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1605 
1606     /**
1607      * @dev Initializes the contract setting the deployer as the initial owner.
1608      */
1609     constructor() {
1610         _transferOwnership(_msgSender());
1611     }
1612 
1613     /**
1614      * @dev Returns the address of the current owner.
1615      */
1616     function owner() public view virtual returns (address) {
1617         return _owner;
1618     }
1619 
1620     /**
1621      * @dev Throws if called by any account other than the owner.
1622      */
1623     modifier onlyOwner() {
1624         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1625         _;
1626     }
1627 
1628     /**
1629      * @dev Leaves the contract without owner. It will not be possible to call
1630      * `onlyOwner` functions anymore. Can only be called by the current owner.
1631      *
1632      * NOTE: Renouncing ownership will leave the contract without an owner,
1633      * thereby removing any functionality that is only available to the owner.
1634      */
1635     function renounceOwnership() public virtual onlyOwner {
1636         _transferOwnership(address(0));
1637     }
1638 
1639     /**
1640      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1641      * Can only be called by the current owner.
1642      */
1643     function transferOwnership(address newOwner) public virtual onlyOwner {
1644         require(newOwner != address(0), "Ownable: new owner is the zero address");
1645         _transferOwnership(newOwner);
1646     }
1647 
1648     /**
1649      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1650      * Internal function without access restriction.
1651      */
1652     function _transferOwnership(address newOwner) internal virtual {
1653         address oldOwner = _owner;
1654         _owner = newOwner;
1655         emit OwnershipTransferred(oldOwner, newOwner);
1656     }
1657 }
1658 
1659 // File: contracts/4_AlphaPass.sol
1660 
1661 //SPDX-License-Identifier: Unlicense
1662 
1663 pragma solidity ^0.8.0;
1664 
1665 
1666 
1667 
1668 
1669 
1670 contract SyndicatePosters is ERC1155, Ownable, ReentrancyGuard {
1671   using Address for address;
1672   using SafeMath for uint256;
1673   using ECDSA for bytes32;
1674 
1675   uint256 public constant MAX_SUPPLY = 100;
1676   uint256 public constant RESERVED = 10;
1677   uint256 public constant TOKEN_ID = 0;
1678 
1679   mapping(bytes => bool) public signatureUsed;
1680   uint256 public totalSupply;
1681   bool public saleActive;
1682   address public signer = 0xb6e1c43C748DF0F8F983bF9da9FffFd66018750F; 
1683 
1684   constructor(string memory _uri) ERC1155(_uri) {
1685     _mint(msg.sender, TOKEN_ID, RESERVED, "");
1686     totalSupply = totalSupply.add(RESERVED);
1687   }
1688 
1689   function setSigner(address _signer) public onlyOwner {
1690     signer = _signer;
1691   }
1692 
1693   function flipSaleActive() public onlyOwner {
1694     saleActive = !saleActive;
1695   }
1696 
1697   function setMetadata(string memory _uri) public onlyOwner {
1698     _setURI(_uri);
1699   }
1700 
1701   function mint(bytes memory signature) public nonReentrant validMinter(signature) {
1702     require(saleActive, "Sale is not active");
1703     require(totalSupply.add(1) <= MAX_SUPPLY, "Exceeds maximum number of tokens");
1704 
1705     signatureUsed[signature] = true;
1706     _mint(_msgSender(), TOKEN_ID, 1, "");
1707     totalSupply = totalSupply.add(1);
1708   }
1709 
1710   modifier validMinter(bytes memory signature) {
1711     require(!signatureUsed[signature], "Signature already used");
1712     address _signer = ECDSA.recover(
1713       ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_msgSender()))),
1714       signature
1715     );
1716     require(signer == _signer, "Invalid signature");
1717     _;
1718   }
1719 }