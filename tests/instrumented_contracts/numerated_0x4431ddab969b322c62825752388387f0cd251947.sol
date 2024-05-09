1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 library ECDSA {
6     enum RecoverError {
7         NoError,
8         InvalidSignature,
9         InvalidSignatureLength,
10         InvalidSignatureS,
11         InvalidSignatureV
12     }
13 
14     function _throwError(RecoverError error) private pure {
15         if (error == RecoverError.NoError) {
16             return; // no error: do nothing
17         } else if (error == RecoverError.InvalidSignature) {
18             revert("ECDSA: invalid signature");
19         } else if (error == RecoverError.InvalidSignatureLength) {
20             revert("ECDSA: invalid signature length");
21         } else if (error == RecoverError.InvalidSignatureS) {
22             revert("ECDSA: invalid signature 's' value");
23         } else if (error == RecoverError.InvalidSignatureV) {
24             revert("ECDSA: invalid signature 'v' value");
25         }
26     }
27 
28     /**
29      * @dev Returns the address that signed a hashed message (`hash`) with
30      * `signature` or error string. This address can then be used for verification purposes.
31      *
32      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
33      * this function rejects them by requiring the `s` value to be in the lower
34      * half order, and the `v` value to be either 27 or 28.
35      *
36      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
37      * verification to be secure: it is possible to craft signatures that
38      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
39      * this is by receiving a hash of the original message (which may otherwise
40      * be too long), and then calling {toEthSignedMessageHash} on it.
41      *
42      * Documentation for signature generation:
43      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
44      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
45      *
46      * _Available since v4.3._
47      */
48     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
49         // Check the signature length
50         // - case 65: r,s,v signature (standard)
51         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
52         if (signature.length == 65) {
53             bytes32 r;
54             bytes32 s;
55             uint8 v;
56             // ecrecover takes the signature parameters, and the only way to get them
57             // currently is to use assembly.
58             assembly {
59                 r := mload(add(signature, 0x20))
60                 s := mload(add(signature, 0x40))
61                 v := byte(0, mload(add(signature, 0x60)))
62             }
63             return tryRecover(hash, v, r, s);
64         } else if (signature.length == 64) {
65             bytes32 r;
66             bytes32 vs;
67             // ecrecover takes the signature parameters, and the only way to get them
68             // currently is to use assembly.
69             assembly {
70                 r := mload(add(signature, 0x20))
71                 vs := mload(add(signature, 0x40))
72             }
73             return tryRecover(hash, r, vs);
74         } else {
75             return (address(0), RecoverError.InvalidSignatureLength);
76         }
77     }
78 
79     /**
80      * @dev Returns the address that signed a hashed message (`hash`) with
81      * `signature`. This address can then be used for verification purposes.
82      *
83      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
84      * this function rejects them by requiring the `s` value to be in the lower
85      * half order, and the `v` value to be either 27 or 28.
86      *
87      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
88      * verification to be secure: it is possible to craft signatures that
89      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
90      * this is by receiving a hash of the original message (which may otherwise
91      * be too long), and then calling {toEthSignedMessageHash} on it.
92      */
93     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
94         (address recovered, RecoverError error) = tryRecover(hash, signature);
95         _throwError(error);
96         return recovered;
97     }
98 
99     /**
100      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
101      *
102      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
103      *
104      * _Available since v4.3._
105      */
106     function tryRecover(
107         bytes32 hash,
108         bytes32 r,
109         bytes32 vs
110     ) internal pure returns (address, RecoverError) {
111         bytes32 s;
112         uint8 v;
113         assembly {
114             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
115             v := add(shr(255, vs), 27)
116         }
117         return tryRecover(hash, v, r, s);
118     }
119 
120     /**
121      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
122      *
123      * _Available since v4.2._
124      */
125     function recover(
126         bytes32 hash,
127         bytes32 r,
128         bytes32 vs
129     ) internal pure returns (address) {
130         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
131         _throwError(error);
132         return recovered;
133     }
134 
135     /**
136      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
137      * `r` and `s` signature fields separately.
138      *
139      * _Available since v4.3._
140      */
141     function tryRecover(
142         bytes32 hash,
143         uint8 v,
144         bytes32 r,
145         bytes32 s
146     ) internal pure returns (address, RecoverError) {
147         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
148         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
149         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
150         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
151         //
152         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
153         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
154         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
155         // these malleable signatures as well.
156         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
157             return (address(0), RecoverError.InvalidSignatureS);
158         }
159         if (v != 27 && v != 28) {
160             return (address(0), RecoverError.InvalidSignatureV);
161         }
162 
163         // If the signature is valid (and not malleable), return the signer address
164         address signer = ecrecover(hash, v, r, s);
165         if (signer == address(0)) {
166             return (address(0), RecoverError.InvalidSignature);
167         }
168 
169         return (signer, RecoverError.NoError);
170     }
171 
172     /**
173      * @dev Overload of {ECDSA-recover} that receives the `v`,
174      * `r` and `s` signature fields separately.
175      */
176     function recover(
177         bytes32 hash,
178         uint8 v,
179         bytes32 r,
180         bytes32 s
181     ) internal pure returns (address) {
182         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
183         _throwError(error);
184         return recovered;
185     }
186 
187     /**
188      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
189      * produces hash corresponding to the one signed with the
190      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
191      * JSON-RPC method as part of EIP-191.
192      *
193      * See {recover}.
194      */
195     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
196         // 32 is the length in bytes of hash,
197         // enforced by the type signature above
198         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
199     }
200 
201     /**
202      * @dev Returns an Ethereum Signed Typed Data, created from a
203      * `domainSeparator` and a `structHash`. This produces hash corresponding
204      * to the one signed with the
205      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
206      * JSON-RPC method as part of EIP-712.
207      *
208      * See {recover}.
209      */
210     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
211         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
212     }
213 }
214 
215 /**
216  * @dev String operations.
217  */
218 library Strings {
219     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
220 
221     /**
222      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
223      */
224     function toString(uint256 value) internal pure returns (string memory) {
225         // Inspired by OraclizeAPI's implementation - MIT licence
226         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
227 
228         if (value == 0) {
229             return "0";
230         }
231         uint256 temp = value;
232         uint256 digits;
233         while (temp != 0) {
234             digits++;
235             temp /= 10;
236         }
237         bytes memory buffer = new bytes(digits);
238         while (value != 0) {
239             digits -= 1;
240             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
241             value /= 10;
242         }
243         return string(buffer);
244     }
245 
246     /**
247      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
248      */
249     function toHexString(uint256 value) internal pure returns (string memory) {
250         if (value == 0) {
251             return "0x00";
252         }
253         uint256 temp = value;
254         uint256 length = 0;
255         while (temp != 0) {
256             length++;
257             temp >>= 8;
258         }
259         return toHexString(value, length);
260     }
261 
262     /**
263      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
264      */
265     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
266         bytes memory buffer = new bytes(2 * length + 2);
267         buffer[0] = "0";
268         buffer[1] = "x";
269         for (uint256 i = 2 * length + 1; i > 1; --i) {
270             buffer[i] = _HEX_SYMBOLS[value & 0xf];
271             value >>= 4;
272         }
273         require(value == 0, "Strings: hex length insufficient");
274         return string(buffer);
275     }
276 }
277 
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize, which returns 0 for contracts in
298         // construction, since the code is only stored at the end of the
299         // constructor execution.
300 
301         uint256 size;
302         assembly {
303             size := extcodesize(account)
304         }
305         return size > 0;
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         (bool success, ) = recipient.call{value: amount}("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain `call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value
382     ) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(
393         address target,
394         bytes memory data,
395         uint256 value,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(address(this).balance >= value, "Address: insufficient balance for call");
399         require(isContract(target), "Address: call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.call{value: value}(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a static call.
408      *
409      * _Available since v3.3._
410      */
411     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
412         return functionStaticCall(target, data, "Address: low-level static call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal view returns (bytes memory) {
426         require(isContract(target), "Address: static call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.staticcall(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a delegate call.
435      *
436      * _Available since v3.4._
437      */
438     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
439         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal returns (bytes memory) {
453         require(isContract(target), "Address: delegate call to non-contract");
454 
455         (bool success, bytes memory returndata) = target.delegatecall(data);
456         return verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
461      * revert reason using the provided one.
462      *
463      * _Available since v4.3._
464      */
465     function verifyCallResult(
466         bool success,
467         bytes memory returndata,
468         string memory errorMessage
469     ) internal pure returns (bytes memory) {
470         if (success) {
471             return returndata;
472         } else {
473             // Look for revert reason and bubble it up if present
474             if (returndata.length > 0) {
475                 // The easiest way to bubble the revert reason is using memory via assembly
476 
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 
489 /**
490  * @dev Wrappers over Solidity's arithmetic operations.
491  *
492  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
493  * now has built in overflow checking.
494  */
495 library SafeMath {
496     /**
497      * @dev Returns the addition of two unsigned integers, with an overflow flag.
498      *
499      * _Available since v3.4._
500      */
501     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
502         unchecked {
503             uint256 c = a + b;
504             if (c < a) return (false, 0);
505             return (true, c);
506         }
507     }
508 
509     /**
510      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
511      *
512      * _Available since v3.4._
513      */
514     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
515         unchecked {
516             if (b > a) return (false, 0);
517             return (true, a - b);
518         }
519     }
520 
521     /**
522      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
523      *
524      * _Available since v3.4._
525      */
526     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
527         unchecked {
528             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
529             // benefit is lost if 'b' is also tested.
530             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
531             if (a == 0) return (true, 0);
532             uint256 c = a * b;
533             if (c / a != b) return (false, 0);
534             return (true, c);
535         }
536     }
537 
538     /**
539      * @dev Returns the division of two unsigned integers, with a division by zero flag.
540      *
541      * _Available since v3.4._
542      */
543     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
544         unchecked {
545             if (b == 0) return (false, 0);
546             return (true, a / b);
547         }
548     }
549 
550     /**
551      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
552      *
553      * _Available since v3.4._
554      */
555     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
556         unchecked {
557             if (b == 0) return (false, 0);
558             return (true, a % b);
559         }
560     }
561 
562     /**
563      * @dev Returns the addition of two unsigned integers, reverting on
564      * overflow.
565      *
566      * Counterpart to Solidity's `+` operator.
567      *
568      * Requirements:
569      *
570      * - Addition cannot overflow.
571      */
572     function add(uint256 a, uint256 b) internal pure returns (uint256) {
573         return a + b;
574     }
575 
576     /**
577      * @dev Returns the subtraction of two unsigned integers, reverting on
578      * overflow (when the result is negative).
579      *
580      * Counterpart to Solidity's `-` operator.
581      *
582      * Requirements:
583      *
584      * - Subtraction cannot overflow.
585      */
586     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
587         return a - b;
588     }
589 
590     /**
591      * @dev Returns the multiplication of two unsigned integers, reverting on
592      * overflow.
593      *
594      * Counterpart to Solidity's `*` operator.
595      *
596      * Requirements:
597      *
598      * - Multiplication cannot overflow.
599      */
600     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
601         return a * b;
602     }
603 
604     /**
605      * @dev Returns the integer division of two unsigned integers, reverting on
606      * division by zero. The result is rounded towards zero.
607      *
608      * Counterpart to Solidity's `/` operator.
609      *
610      * Requirements:
611      *
612      * - The divisor cannot be zero.
613      */
614     function div(uint256 a, uint256 b) internal pure returns (uint256) {
615         return a / b;
616     }
617 
618     /**
619      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
620      * reverting when dividing by zero.
621      *
622      * Counterpart to Solidity's `%` operator. This function uses a `revert`
623      * opcode (which leaves remaining gas untouched) while Solidity uses an
624      * invalid opcode to revert (consuming all remaining gas).
625      *
626      * Requirements:
627      *
628      * - The divisor cannot be zero.
629      */
630     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
631         return a % b;
632     }
633 
634     /**
635      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
636      * overflow (when the result is negative).
637      *
638      * CAUTION: This function is deprecated because it requires allocating memory for the error
639      * message unnecessarily. For custom revert reasons use {trySub}.
640      *
641      * Counterpart to Solidity's `-` operator.
642      *
643      * Requirements:
644      *
645      * - Subtraction cannot overflow.
646      */
647     function sub(
648         uint256 a,
649         uint256 b,
650         string memory errorMessage
651     ) internal pure returns (uint256) {
652         unchecked {
653             require(b <= a, errorMessage);
654             return a - b;
655         }
656     }
657 
658     /**
659      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
660      * division by zero. The result is rounded towards zero.
661      *
662      * Counterpart to Solidity's `/` operator. Note: this function uses a
663      * `revert` opcode (which leaves remaining gas untouched) while Solidity
664      * uses an invalid opcode to revert (consuming all remaining gas).
665      *
666      * Requirements:
667      *
668      * - The divisor cannot be zero.
669      */
670     function div(
671         uint256 a,
672         uint256 b,
673         string memory errorMessage
674     ) internal pure returns (uint256) {
675         unchecked {
676             require(b > 0, errorMessage);
677             return a / b;
678         }
679     }
680 
681     /**
682      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
683      * reverting with custom message when dividing by zero.
684      *
685      * CAUTION: This function is deprecated because it requires allocating memory for the error
686      * message unnecessarily. For custom revert reasons use {tryMod}.
687      *
688      * Counterpart to Solidity's `%` operator. This function uses a `revert`
689      * opcode (which leaves remaining gas untouched) while Solidity uses an
690      * invalid opcode to revert (consuming all remaining gas).
691      *
692      * Requirements:
693      *
694      * - The divisor cannot be zero.
695      */
696     function mod(
697         uint256 a,
698         uint256 b,
699         string memory errorMessage
700     ) internal pure returns (uint256) {
701         unchecked {
702             require(b > 0, errorMessage);
703             return a % b;
704         }
705     }
706 }
707 
708 contract Initializable {
709     bool inited = false;
710 
711     modifier initializer() {
712         require(!inited, "already inited");
713         _;
714         inited = true;
715     }
716 }
717 
718 abstract contract Context {
719     function _msgSender() internal view virtual returns (address) {
720         return msg.sender;
721     }
722 
723     function _msgData() internal view virtual returns (bytes calldata) {
724         return msg.data;
725     }
726 }
727 
728 abstract contract ContextMixin {
729     function msgSender()
730         internal
731         view
732         returns (address payable sender)
733     {
734         if (msg.sender == address(this)) {
735             bytes memory array = msg.data;
736             uint256 index = msg.data.length;
737             assembly {
738                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
739                 sender := and(
740                     mload(add(array, index)),
741                     0xffffffffffffffffffffffffffffffffffffffff
742                 )
743             }
744         } else {
745             sender = payable(msg.sender);
746         }
747         return sender;
748     }
749 }
750 
751 interface IERC165 {
752     /**
753      * @dev Returns true if this contract implements the interface defined by
754      * `interfaceId`. See the corresponding
755      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
756      * to learn more about how these ids are created.
757      *
758      * This function call must use less than 30 000 gas.
759      */
760     function supportsInterface(bytes4 interfaceId) external view returns (bool);
761 }
762 
763 interface IERC721 is IERC165 {
764     /**
765      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
766      */
767     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
768 
769     /**
770      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
771      */
772     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
773 
774     /**
775      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
776      */
777     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
778 
779     /**
780      * @dev Returns the number of tokens in ``owner``'s account.
781      */
782     function balanceOf(address owner) external view returns (uint256 balance);
783 
784     /**
785      * @dev Returns the owner of the `tokenId` token.
786      *
787      * Requirements:
788      *
789      * - `tokenId` must exist.
790      */
791     function ownerOf(uint256 tokenId) external view returns (address owner);
792 
793     /**
794      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
795      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
796      *
797      * Requirements:
798      *
799      * - `from` cannot be the zero address.
800      * - `to` cannot be the zero address.
801      * - `tokenId` token must exist and be owned by `from`.
802      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
803      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
804      *
805      * Emits a {Transfer} event.
806      */
807     function safeTransferFrom(
808         address from,
809         address to,
810         uint256 tokenId
811     ) external;
812 
813     /**
814      * @dev Transfers `tokenId` token from `from` to `to`.
815      *
816      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
817      *
818      * Requirements:
819      *
820      * - `from` cannot be the zero address.
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must be owned by `from`.
823      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
824      *
825      * Emits a {Transfer} event.
826      */
827     function transferFrom(
828         address from,
829         address to,
830         uint256 tokenId
831     ) external;
832 
833     /**
834      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
835      * The approval is cleared when the token is transferred.
836      *
837      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
838      *
839      * Requirements:
840      *
841      * - The caller must own the token or be an approved operator.
842      * - `tokenId` must exist.
843      *
844      * Emits an {Approval} event.
845      */
846     function approve(address to, uint256 tokenId) external;
847 
848     /**
849      * @dev Returns the account approved for `tokenId` token.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      */
855     function getApproved(uint256 tokenId) external view returns (address operator);
856 
857     /**
858      * @dev Approve or remove `operator` as an operator for the caller.
859      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
860      *
861      * Requirements:
862      *
863      * - The `operator` cannot be the caller.
864      *
865      * Emits an {ApprovalForAll} event.
866      */
867     function setApprovalForAll(address operator, bool _approved) external;
868 
869     /**
870      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
871      *
872      * See {setApprovalForAll}
873      */
874     function isApprovedForAll(address owner, address operator) external view returns (bool);
875 
876     /**
877      * @dev Safely transfers `tokenId` token from `from` to `to`.
878      *
879      * Requirements:
880      *
881      * - `from` cannot be the zero address.
882      * - `to` cannot be the zero address.
883      * - `tokenId` token must exist and be owned by `from`.
884      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
885      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
886      *
887      * Emits a {Transfer} event.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes calldata data
894     ) external;
895 }
896 
897 interface IERC721Receiver {
898     /**
899      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
900      * by `operator` from `from`, this function is called.
901      *
902      * It must return its Solidity selector to confirm the token transfer.
903      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
904      *
905      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
906      */
907     function onERC721Received(
908         address operator,
909         address from,
910         uint256 tokenId,
911         bytes calldata data
912     ) external returns (bytes4);
913 }
914 
915 /**
916  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
917  * @dev See https://eips.ethereum.org/EIPS/eip-721
918  */
919 interface IERC721Enumerable is IERC721 {
920     /**
921      * @dev Returns the total amount of tokens stored by the contract.
922      */
923     function totalSupply() external view returns (uint256);
924 
925     /**
926      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
927      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
928      */
929     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
930 
931     /**
932      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
933      * Use along with {totalSupply} to enumerate all tokens.
934      */
935     function tokenByIndex(uint256 index) external view returns (uint256);
936 }
937 
938 /**
939  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
940  * @dev See https://eips.ethereum.org/EIPS/eip-721
941  */
942 interface IERC721Metadata is IERC721 {
943     /**
944      * @dev Returns the token collection name.
945      */
946     function name() external view returns (string memory);
947 
948     /**
949      * @dev Returns the token collection symbol.
950      */
951     function symbol() external view returns (string memory);
952 
953     /**
954      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
955      */
956     function tokenURI(uint256 tokenId) external view returns (string memory);
957 }
958 
959 abstract contract Ownable is Context {
960     address private _owner;
961 
962     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
963 
964     /**
965      * @dev Initializes the contract setting the deployer as the initial owner.
966      */
967     constructor() {
968         _setOwner(_msgSender());
969     }
970 
971     /**
972      * @dev Returns the address of the current owner.
973      */
974     function owner() public view virtual returns (address) {
975         return _owner;
976     }
977 
978     /**
979      * @dev Throws if called by any account other than the owner.
980      */
981     modifier onlyOwner() {
982         require(owner() == _msgSender(), "Ownable: caller is not the owner");
983         _;
984     }
985 
986     /**
987      * @dev Leaves the contract without owner. It will not be possible to call
988      * `onlyOwner` functions anymore. Can only be called by the current owner.
989      *
990      * NOTE: Renouncing ownership will leave the contract without an owner,
991      * thereby removing any functionality that is only available to the owner.
992      */
993     function renounceOwnership() public virtual onlyOwner {
994         _setOwner(address(0));
995     }
996 
997     /**
998      * @dev Transfers ownership of the contract to a new account (`newOwner`).
999      * Can only be called by the current owner.
1000      */
1001     function transferOwnership(address newOwner) public virtual onlyOwner {
1002         require(newOwner != address(0), "Ownable: new owner is the zero address");
1003         _setOwner(newOwner);
1004     }
1005 
1006     function _setOwner(address newOwner) private {
1007         address oldOwner = _owner;
1008         _owner = newOwner;
1009         emit OwnershipTransferred(oldOwner, newOwner);
1010     }
1011 }
1012 
1013 contract EIP712Base is Initializable {
1014     struct EIP712Domain {
1015         string name;
1016         string version;
1017         address verifyingContract;
1018         bytes32 salt;
1019     }
1020 
1021     string constant public ERC712_VERSION = "1";
1022 
1023     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
1024         bytes(
1025             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1026         )
1027     );
1028     bytes32 internal domainSeperator;
1029 
1030     // supposed to be called once while initializing.
1031     // one of the contracts that inherits this contract follows proxy pattern
1032     // so it is not possible to do this in a constructor
1033     function _initializeEIP712(
1034         string memory name
1035     )
1036         internal
1037         initializer
1038     {
1039         _setDomainSeperator(name);
1040     }
1041 
1042     function _setDomainSeperator(string memory name) internal {
1043         domainSeperator = keccak256(
1044             abi.encode(
1045                 EIP712_DOMAIN_TYPEHASH,
1046                 keccak256(bytes(name)),
1047                 keccak256(bytes(ERC712_VERSION)),
1048                 address(this),
1049                 bytes32(getChainId())
1050             )
1051         );
1052     }
1053 
1054     function getDomainSeperator() public view returns (bytes32) {
1055         return domainSeperator;
1056     }
1057 
1058     function getChainId() public view returns (uint256) {
1059         uint256 id;
1060         assembly {
1061             id := chainid()
1062         }
1063         return id;
1064     }
1065 
1066     /**
1067      * Accept message hash and returns hash message in EIP712 compatible form
1068      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1069      * https://eips.ethereum.org/EIPS/eip-712
1070      * "\\x19" makes the encoding deterministic
1071      * "\\x01" is the version byte to make it compatible to EIP-191
1072      */
1073     function toTypedMessageHash(bytes32 messageHash)
1074         internal
1075         view
1076         returns (bytes32)
1077     {
1078         return
1079             keccak256(
1080                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1081             );
1082     }
1083 }
1084 
1085 contract NativeMetaTransaction is EIP712Base {
1086     using SafeMath for uint256;
1087     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
1088         bytes(
1089             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1090         )
1091     );
1092     event MetaTransactionExecuted(
1093         address userAddress,
1094         address payable relayerAddress,
1095         bytes functionSignature
1096     );
1097     mapping(address => uint256) nonces;
1098 
1099     /*
1100      * Meta transaction structure.
1101      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1102      * He should call the desired function directly in that case.
1103      */
1104     struct MetaTransaction {
1105         uint256 nonce;
1106         address from;
1107         bytes functionSignature;
1108     }
1109 
1110     function executeMetaTransaction(
1111         address userAddress,
1112         bytes memory functionSignature,
1113         bytes32 sigR,
1114         bytes32 sigS,
1115         uint8 sigV
1116     ) public payable returns (bytes memory) {
1117         MetaTransaction memory metaTx = MetaTransaction({
1118             nonce: nonces[userAddress],
1119             from: userAddress,
1120             functionSignature: functionSignature
1121         });
1122 
1123         require(
1124             verify(userAddress, metaTx, sigR, sigS, sigV),
1125             "Signer and signature do not match"
1126         );
1127 
1128         // increase nonce for user (to avoid re-use)
1129         nonces[userAddress] = nonces[userAddress].add(1);
1130 
1131         emit MetaTransactionExecuted(
1132             userAddress,
1133             payable(msg.sender),
1134             functionSignature
1135         );
1136 
1137         // Append userAddress and relayer address at the end to extract it from calling context
1138         (bool success, bytes memory returnData) = address(this).call(
1139             abi.encodePacked(functionSignature, userAddress)
1140         );
1141         require(success, "Function call not successful");
1142 
1143         return returnData;
1144     }
1145 
1146     function hashMetaTransaction(MetaTransaction memory metaTx)
1147         internal
1148         pure
1149         returns (bytes32)
1150     {
1151         return
1152             keccak256(
1153                 abi.encode(
1154                     META_TRANSACTION_TYPEHASH,
1155                     metaTx.nonce,
1156                     metaTx.from,
1157                     keccak256(metaTx.functionSignature)
1158                 )
1159             );
1160     }
1161 
1162     function getNonce(address user) public view returns (uint256 nonce) {
1163         nonce = nonces[user];
1164     }
1165 
1166     function verify(
1167         address signer,
1168         MetaTransaction memory metaTx,
1169         bytes32 sigR,
1170         bytes32 sigS,
1171         uint8 sigV
1172     ) internal view returns (bool) {
1173         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1174         return
1175             signer ==
1176             ecrecover(
1177                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1178                 sigV,
1179                 sigR,
1180                 sigS
1181             );
1182     }
1183 }
1184 
1185 abstract contract ERC165 is IERC165 {
1186     /**
1187      * @dev See {IERC165-supportsInterface}.
1188      */
1189     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1190         return interfaceId == type(IERC165).interfaceId;
1191     }
1192 }
1193 
1194 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1195     using Address for address;
1196     using Strings for uint256;
1197 
1198     // Token name
1199     string private _name;
1200 
1201     // Token symbol
1202     string private _symbol;
1203 
1204     // Mapping from token ID to owner address
1205     mapping(uint256 => address) private _owners;
1206 
1207     // Mapping owner address to token count
1208     mapping(address => uint256) private _balances;
1209 
1210     // Mapping from token ID to approved address
1211     mapping(uint256 => address) private _tokenApprovals;
1212 
1213     // Mapping from owner to operator approvals
1214     mapping(address => mapping(address => bool)) private _operatorApprovals;
1215 
1216     /**
1217      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1218      */
1219     constructor(string memory name_, string memory symbol_) {
1220         _name = name_;
1221         _symbol = symbol_;
1222     }
1223 
1224     /**
1225      * @dev See {IERC165-supportsInterface}.
1226      */
1227     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1228         return
1229             interfaceId == type(IERC721).interfaceId ||
1230             interfaceId == type(IERC721Metadata).interfaceId ||
1231             super.supportsInterface(interfaceId);
1232     }
1233 
1234     /**
1235      * @dev See {IERC721-balanceOf}.
1236      */
1237     function balanceOf(address owner) public view virtual override returns (uint256) {
1238         require(owner != address(0), "ERC721: balance query for the zero address");
1239         return _balances[owner];
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-ownerOf}.
1244      */
1245     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1246         address owner = _owners[tokenId];
1247         require(owner != address(0), "ERC721: owner query for nonexistent token");
1248         return owner;
1249     }
1250 
1251     /**
1252      * @dev See {IERC721Metadata-name}.
1253      */
1254     function name() public view virtual override returns (string memory) {
1255         return _name;
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Metadata-symbol}.
1260      */
1261     function symbol() public view virtual override returns (string memory) {
1262         return _symbol;
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Metadata-tokenURI}.
1267      */
1268     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1269         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1270 
1271         string memory baseURI = _baseURI();
1272         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1273     }
1274 
1275     /**
1276      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1277      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1278      * by default, can be overriden in child contracts.
1279      */
1280     function _baseURI() internal view virtual returns (string memory) {
1281         return "";
1282     }
1283 
1284     /**
1285      * @dev See {IERC721-approve}.
1286      */
1287     function approve(address to, uint256 tokenId) public virtual override {
1288         address owner = ERC721.ownerOf(tokenId);
1289         require(to != owner, "ERC721: approval to current owner");
1290 
1291         require(
1292             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1293             "ERC721: approve caller is not owner nor approved for all"
1294         );
1295 
1296         _approve(to, tokenId);
1297     }
1298 
1299     /**
1300      * @dev See {IERC721-getApproved}.
1301      */
1302     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1303         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1304 
1305         return _tokenApprovals[tokenId];
1306     }
1307 
1308     /**
1309      * @dev See {IERC721-setApprovalForAll}.
1310      */
1311     function setApprovalForAll(address operator, bool approved) public virtual override {
1312         require(operator != _msgSender(), "ERC721: approve to caller");
1313 
1314         _operatorApprovals[_msgSender()][operator] = approved;
1315         emit ApprovalForAll(_msgSender(), operator, approved);
1316     }
1317 
1318     /**
1319      * @dev See {IERC721-isApprovedForAll}.
1320      */
1321     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1322         return _operatorApprovals[owner][operator];
1323     }
1324 
1325     /**
1326      * @dev See {IERC721-transferFrom}.
1327      */
1328     function transferFrom(
1329         address from,
1330         address to,
1331         uint256 tokenId
1332     ) public virtual override {
1333         //solhint-disable-next-line max-line-length
1334         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1335 
1336         _transfer(from, to, tokenId);
1337     }
1338 
1339     /**
1340      * @dev See {IERC721-safeTransferFrom}.
1341      */
1342     function safeTransferFrom(
1343         address from,
1344         address to,
1345         uint256 tokenId
1346     ) public virtual override {
1347         safeTransferFrom(from, to, tokenId, "");
1348     }
1349 
1350     /**
1351      * @dev See {IERC721-safeTransferFrom}.
1352      */
1353     function safeTransferFrom(
1354         address from,
1355         address to,
1356         uint256 tokenId,
1357         bytes memory _data
1358     ) public virtual override {
1359         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1360         _safeTransfer(from, to, tokenId, _data);
1361     }
1362 
1363     /**
1364      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1365      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1366      *
1367      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1368      *
1369      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1370      * implement alternative mechanisms to perform token transfer, such as signature-based.
1371      *
1372      * Requirements:
1373      *
1374      * - `from` cannot be the zero address.
1375      * - `to` cannot be the zero address.
1376      * - `tokenId` token must exist and be owned by `from`.
1377      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1378      *
1379      * Emits a {Transfer} event.
1380      */
1381     function _safeTransfer(
1382         address from,
1383         address to,
1384         uint256 tokenId,
1385         bytes memory _data
1386     ) internal virtual {
1387         _transfer(from, to, tokenId);
1388         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1389     }
1390 
1391     /**
1392      * @dev Returns whether `tokenId` exists.
1393      *
1394      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1395      *
1396      * Tokens start existing when they are minted (`_mint`),
1397      * and stop existing when they are burned (`_burn`).
1398      */
1399     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1400         return _owners[tokenId] != address(0);
1401     }
1402 
1403     /**
1404      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1405      *
1406      * Requirements:
1407      *
1408      * - `tokenId` must exist.
1409      */
1410     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1411         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1412         address owner = ERC721.ownerOf(tokenId);
1413         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1414     }
1415 
1416     /**
1417      * @dev Safely mints `tokenId` and transfers it to `to`.
1418      *
1419      * Requirements:
1420      *
1421      * - `tokenId` must not exist.
1422      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1423      *
1424      * Emits a {Transfer} event.
1425      */
1426     function _safeMint(address to, uint256 tokenId) internal virtual {
1427         _safeMint(to, tokenId, "");
1428     }
1429 
1430     /**
1431      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1432      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1433      */
1434     function _safeMint(
1435         address to,
1436         uint256 tokenId,
1437         bytes memory _data
1438     ) internal virtual {
1439         _mint(to, tokenId);
1440         require(
1441             _checkOnERC721Received(address(0), to, tokenId, _data),
1442             "ERC721: transfer to non ERC721Receiver implementer"
1443         );
1444     }
1445 
1446     /**
1447      * @dev Mints `tokenId` and transfers it to `to`.
1448      *
1449      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1450      *
1451      * Requirements:
1452      *
1453      * - `tokenId` must not exist.
1454      * - `to` cannot be the zero address.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function _mint(address to, uint256 tokenId) internal virtual {
1459         require(to != address(0), "ERC721: mint to the zero address");
1460         require(!_exists(tokenId), "ERC721: token already minted");
1461 
1462         _beforeTokenTransfer(address(0), to, tokenId);
1463 
1464         _balances[to] += 1;
1465         _owners[tokenId] = to;
1466 
1467         emit Transfer(address(0), to, tokenId);
1468     }
1469 
1470     /**
1471      * @dev Destroys `tokenId`.
1472      * The approval is cleared when the token is burned.
1473      *
1474      * Requirements:
1475      *
1476      * - `tokenId` must exist.
1477      *
1478      * Emits a {Transfer} event.
1479      */
1480     function _burn(uint256 tokenId) internal virtual {
1481         address owner = ERC721.ownerOf(tokenId);
1482 
1483         _beforeTokenTransfer(owner, address(0), tokenId);
1484 
1485         // Clear approvals
1486         _approve(address(0), tokenId);
1487 
1488         _balances[owner] -= 1;
1489         delete _owners[tokenId];
1490 
1491         emit Transfer(owner, address(0), tokenId);
1492     }
1493 
1494     /**
1495      * @dev Transfers `tokenId` from `from` to `to`.
1496      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1497      *
1498      * Requirements:
1499      *
1500      * - `to` cannot be the zero address.
1501      * - `tokenId` token must be owned by `from`.
1502      *
1503      * Emits a {Transfer} event.
1504      */
1505     function _transfer(
1506         address from,
1507         address to,
1508         uint256 tokenId
1509     ) internal virtual {
1510         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1511         require(to != address(0), "ERC721: transfer to the zero address");
1512 
1513         _beforeTokenTransfer(from, to, tokenId);
1514 
1515         // Clear approvals from the previous owner
1516         _approve(address(0), tokenId);
1517 
1518         _balances[from] -= 1;
1519         _balances[to] += 1;
1520         _owners[tokenId] = to;
1521 
1522         emit Transfer(from, to, tokenId);
1523     }
1524 
1525     /**
1526      * @dev Approve `to` to operate on `tokenId`
1527      *
1528      * Emits a {Approval} event.
1529      */
1530     function _approve(address to, uint256 tokenId) internal virtual {
1531         _tokenApprovals[tokenId] = to;
1532         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1533     }
1534 
1535     /**
1536      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1537      * The call is not executed if the target address is not a contract.
1538      *
1539      * @param from address representing the previous owner of the given token ID
1540      * @param to target address that will receive the tokens
1541      * @param tokenId uint256 ID of the token to be transferred
1542      * @param _data bytes optional data to send along with the call
1543      * @return bool whether the call correctly returned the expected magic value
1544      */
1545     function _checkOnERC721Received(
1546         address from,
1547         address to,
1548         uint256 tokenId,
1549         bytes memory _data
1550     ) private returns (bool) {
1551         if (to.isContract()) {
1552             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1553                 return retval == IERC721Receiver.onERC721Received.selector;
1554             } catch (bytes memory reason) {
1555                 if (reason.length == 0) {
1556                     revert("ERC721: transfer to non ERC721Receiver implementer");
1557                 } else {
1558                     assembly {
1559                         revert(add(32, reason), mload(reason))
1560                     }
1561                 }
1562             }
1563         } else {
1564             return true;
1565         }
1566     }
1567 
1568     /**
1569      * @dev Hook that is called before any token transfer. This includes minting
1570      * and burning.
1571      *
1572      * Calling conditions:
1573      *
1574      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1575      * transferred to `to`.
1576      * - When `from` is zero, `tokenId` will be minted for `to`.
1577      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1578      * - `from` and `to` are never both zero.
1579      *
1580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1581      */
1582     function _beforeTokenTransfer(
1583         address from,
1584         address to,
1585         uint256 tokenId
1586     ) internal virtual {}
1587 }
1588 
1589 
1590 contract OwnableDelegateProxy {}
1591 
1592 contract ProxyRegistry {
1593     mapping(address => OwnableDelegateProxy) public proxies;
1594 }
1595 
1596 /**
1597  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1598  * enumerability of all the token ids in the contract as well as all token ids owned by each
1599  * account.
1600  */
1601 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1602     // Mapping from owner to list of owned token IDs
1603     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1604 
1605     // Mapping from token ID to index of the owner tokens list
1606     mapping(uint256 => uint256) private _ownedTokensIndex;
1607 
1608     // Array with all token ids, used for enumeration
1609     uint256[] private _allTokens;
1610 
1611     // Mapping from token id to position in the allTokens array
1612     mapping(uint256 => uint256) private _allTokensIndex;
1613 
1614     /**
1615      * @dev See {IERC165-supportsInterface}.
1616      */
1617     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1618         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1619     }
1620 
1621     /**
1622      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1623      */
1624     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1625         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1626         return _ownedTokens[owner][index];
1627     }
1628 
1629     /**
1630      * @dev See {IERC721Enumerable-totalSupply}.
1631      */
1632     function totalSupply() public view virtual override returns (uint256) {
1633         return _allTokens.length;
1634     }
1635 
1636     /**
1637      * @dev See {IERC721Enumerable-tokenByIndex}.
1638      */
1639     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1640         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1641         return _allTokens[index];
1642     }
1643 
1644     /**
1645      * @dev Hook that is called before any token transfer. This includes minting
1646      * and burning.
1647      *
1648      * Calling conditions:
1649      *
1650      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1651      * transferred to `to`.
1652      * - When `from` is zero, `tokenId` will be minted for `to`.
1653      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1654      * - `from` cannot be the zero address.
1655      * - `to` cannot be the zero address.
1656      *
1657      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1658      */
1659     function _beforeTokenTransfer(
1660         address from,
1661         address to,
1662         uint256 tokenId
1663     ) internal virtual override {
1664         super._beforeTokenTransfer(from, to, tokenId);
1665 
1666         if (from == address(0)) {
1667             _addTokenToAllTokensEnumeration(tokenId);
1668         } else if (from != to) {
1669             _removeTokenFromOwnerEnumeration(from, tokenId);
1670         }
1671         if (to == address(0)) {
1672             _removeTokenFromAllTokensEnumeration(tokenId);
1673         } else if (to != from) {
1674             _addTokenToOwnerEnumeration(to, tokenId);
1675         }
1676     }
1677 
1678     /**
1679      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1680      * @param to address representing the new owner of the given token ID
1681      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1682      */
1683     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1684         uint256 length = ERC721.balanceOf(to);
1685         _ownedTokens[to][length] = tokenId;
1686         _ownedTokensIndex[tokenId] = length;
1687     }
1688 
1689     /**
1690      * @dev Private function to add a token to this extension's token tracking data structures.
1691      * @param tokenId uint256 ID of the token to be added to the tokens list
1692      */
1693     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1694         _allTokensIndex[tokenId] = _allTokens.length;
1695         _allTokens.push(tokenId);
1696     }
1697 
1698     /**
1699      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1700      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1701      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1702      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1703      * @param from address representing the previous owner of the given token ID
1704      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1705      */
1706     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1707         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1708         // then delete the last slot (swap and pop).
1709 
1710         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1711         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1712 
1713         // When the token to delete is the last token, the swap operation is unnecessary
1714         if (tokenIndex != lastTokenIndex) {
1715             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1716 
1717             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1718             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1719         }
1720 
1721         // This also deletes the contents at the last position of the array
1722         delete _ownedTokensIndex[tokenId];
1723         delete _ownedTokens[from][lastTokenIndex];
1724     }
1725 
1726     /**
1727      * @dev Private function to remove a token from this extension's token tracking data structures.
1728      * This has O(1) time complexity, but alters the order of the _allTokens array.
1729      * @param tokenId uint256 ID of the token to be removed from the tokens list
1730      */
1731     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1732         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1733         // then delete the last slot (swap and pop).
1734 
1735         uint256 lastTokenIndex = _allTokens.length - 1;
1736         uint256 tokenIndex = _allTokensIndex[tokenId];
1737 
1738         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1739         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1740         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1741         uint256 lastTokenId = _allTokens[lastTokenIndex];
1742 
1743         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1744         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1745 
1746         // This also deletes the contents at the last position of the array
1747         delete _allTokensIndex[tokenId];
1748         _allTokens.pop();
1749     }
1750 }
1751 
1752 /**
1753  * @title ERC721Tradable
1754  * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
1755  */
1756 abstract contract ERC721Tradable is ContextMixin, ERC721Enumerable, NativeMetaTransaction, Ownable {
1757     using SafeMath for uint256;
1758 
1759     address proxyRegistryAddress;
1760 
1761     constructor(
1762         string memory _name,
1763         string memory _symbol,
1764         address _proxyRegistryAddress
1765     ) ERC721(_name, _symbol) {
1766         proxyRegistryAddress = _proxyRegistryAddress;
1767         _initializeEIP712(_name);
1768     }
1769 
1770     function baseTokenURI() virtual public pure returns (string memory);
1771 
1772     function tokenURI(uint256 _tokenId) override public pure returns (string memory) {
1773         return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId)));
1774     }
1775 
1776     /**
1777      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1778      */
1779     function isApprovedForAll(address owner, address operator)
1780         override
1781         public
1782         view
1783         returns (bool)
1784     {
1785         // Whitelist OpenSea proxy contract for easy trading.
1786         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1787         if (address(proxyRegistry.proxies(owner)) == operator) {
1788             return true;
1789         }
1790 
1791         return super.isApprovedForAll(owner, operator);
1792     }
1793 
1794     /**
1795      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1796      */
1797     function _msgSender()
1798         internal
1799         override
1800         view
1801         returns (address sender)
1802     {
1803         return ContextMixin.msgSender();
1804     }
1805 }
1806 
1807 /**
1808  * @title FFPBurgers
1809  * FFPBurgers - a contract for non-fungible FFPBurgers.
1810  */
1811 contract FFPBurgers is ERC721Tradable {
1812 
1813     using ECDSA for bytes32;
1814     mapping(address => mapping(uint256 => bool)) private seenNonces;
1815     address private allowedSigner = 0x43dD43C9DC11EAD9dca441bCB86B26eA3Cd5A161;
1816 
1817     constructor(address _proxyRegistryAddress)
1818         ERC721Tradable("fast-food-punks-burgers", "FFPB", _proxyRegistryAddress)
1819     {}
1820 
1821     function baseTokenURI() override public pure returns (string memory) {
1822         return "ipfs://bafybeif4rhibtmdftmoyaydorwdhyovx332ubzugwzhnle76mq3gnh7xiu/";
1823     }
1824 
1825     function setAllowedSigner(address newSigner) public onlyOwner {
1826         allowedSigner = newSigner;
1827     }
1828 
1829     function submitMint(uint256 tokenId, address to, uint256 nonce, bytes memory signature) public {
1830         address signer = _getSigner(tokenId, to, nonce, signature);
1831         require(signer == allowedSigner);
1832         require(!seenNonces[signer][nonce]);
1833         seenNonces[signer][nonce] = true;
1834 
1835         _mint(to, tokenId);
1836     }
1837 
1838     function _getSigner(uint256 tokenId, address to, uint256 nonce, bytes memory signature) private pure returns (address) {
1839         bytes32 hash = keccak256(abi.encodePacked(tokenId, to, nonce));
1840         bytes32 messageHash = hash.toEthSignedMessageHash();
1841         address signer = messageHash.recover(signature);
1842         return signer;
1843     }
1844 }