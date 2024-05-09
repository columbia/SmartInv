1 // File: contracts/IMonolocco.sol
2 
3 //SPDX-License-Identifier: UNLICENSED
4 pragma solidity ^0.8.11;
5 interface IMonolocco {
6      function mint(address to, uint256 amount) external;
7 }
8 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Contract module that helps prevent reentrant calls to a function.
17  *
18  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
19  * available, which can be applied to functions to make sure there are no nested
20  * (reentrant) calls to them.
21  *
22  * Note that because there is a single `nonReentrant` guard, functions marked as
23  * `nonReentrant` may not call one another. This can be worked around by making
24  * those functions `private`, and then adding `external` `nonReentrant` entry
25  * points to them.
26  *
27  * TIP: If you would like to learn more about reentrancy and alternative ways
28  * to protect against it, check out our blog post
29  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
30  */
31 abstract contract ReentrancyGuard {
32     // Booleans are more expensive than uint256 or any type that takes up a full
33     // word because each write operation emits an extra SLOAD to first read the
34     // slot's contents, replace the bits taken up by the boolean, and then write
35     // back. This is the compiler's defense against contract upgrades and
36     // pointer aliasing, and it cannot be disabled.
37 
38     // The values being non-zero value makes deployment a bit more expensive,
39     // but in exchange the refund on every call to nonReentrant will be lower in
40     // amount. Since refunds are capped to a percentage of the total
41     // transaction's gas, it is best to keep them low in cases like this one, to
42     // increase the likelihood of the full refund coming into effect.
43     uint256 private constant _NOT_ENTERED = 1;
44     uint256 private constant _ENTERED = 2;
45 
46     uint256 private _status;
47 
48     constructor() {
49         _status = _NOT_ENTERED;
50     }
51 
52     /**
53      * @dev Prevents a contract from calling itself, directly or indirectly.
54      * Calling a `nonReentrant` function from another `nonReentrant`
55      * function is not supported. It is possible to prevent this from happening
56      * by making the `nonReentrant` function external, and making it call a
57      * `private` function that does the actual work.
58      */
59     modifier nonReentrant() {
60         // On the first call to nonReentrant, _notEntered will be true
61         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
62 
63         // Any calls to nonReentrant after this point will fail
64         _status = _ENTERED;
65 
66         _;
67 
68         // By storing the original value once again, a refund is triggered (see
69         // https://eips.ethereum.org/EIPS/eip-2200)
70         _status = _NOT_ENTERED;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 // CAUTION
82 // This version of SafeMath should only be used with Solidity 0.8 or later,
83 // because it relies on the compiler's built in overflow checks.
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations.
87  *
88  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
89  * now has built in overflow checking.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, with an overflow flag.
94      *
95      * _Available since v3.4._
96      */
97     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
98         unchecked {
99             uint256 c = a + b;
100             if (c < a) return (false, 0);
101             return (true, c);
102         }
103     }
104 
105     /**
106      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
107      *
108      * _Available since v3.4._
109      */
110     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         unchecked {
112             if (b > a) return (false, 0);
113             return (true, a - b);
114         }
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125             // benefit is lost if 'b' is also tested.
126             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
127             if (a == 0) return (true, 0);
128             uint256 c = a * b;
129             if (c / a != b) return (false, 0);
130             return (true, c);
131         }
132     }
133 
134     /**
135      * @dev Returns the division of two unsigned integers, with a division by zero flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         unchecked {
141             if (b == 0) return (false, 0);
142             return (true, a / b);
143         }
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             if (b == 0) return (false, 0);
154             return (true, a % b);
155         }
156     }
157 
158     /**
159      * @dev Returns the addition of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `+` operator.
163      *
164      * Requirements:
165      *
166      * - Addition cannot overflow.
167      */
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         return a + b;
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting on
174      * overflow (when the result is negative).
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         return a - b;
184     }
185 
186     /**
187      * @dev Returns the multiplication of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `*` operator.
191      *
192      * Requirements:
193      *
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         return a * b;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers, reverting on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator.
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a / b;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * reverting when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a % b;
228     }
229 
230     /**
231      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
232      * overflow (when the result is negative).
233      *
234      * CAUTION: This function is deprecated because it requires allocating memory for the error
235      * message unnecessarily. For custom revert reasons use {trySub}.
236      *
237      * Counterpart to Solidity's `-` operator.
238      *
239      * Requirements:
240      *
241      * - Subtraction cannot overflow.
242      */
243     function sub(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         unchecked {
249             require(b <= a, errorMessage);
250             return a - b;
251         }
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function div(
267         uint256 a,
268         uint256 b,
269         string memory errorMessage
270     ) internal pure returns (uint256) {
271         unchecked {
272             require(b > 0, errorMessage);
273             return a / b;
274         }
275     }
276 
277     /**
278      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279      * reverting with custom message when dividing by zero.
280      *
281      * CAUTION: This function is deprecated because it requires allocating memory for the error
282      * message unnecessarily. For custom revert reasons use {tryMod}.
283      *
284      * Counterpart to Solidity's `%` operator. This function uses a `revert`
285      * opcode (which leaves remaining gas untouched) while Solidity uses an
286      * invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function mod(
293         uint256 a,
294         uint256 b,
295         string memory errorMessage
296     ) internal pure returns (uint256) {
297         unchecked {
298             require(b > 0, errorMessage);
299             return a % b;
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/interfaces/IERC1271.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC1271.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Interface of the ERC1271 standard signature validation method for
313  * contracts as defined in https://eips.ethereum.org/EIPS/eip-1271[ERC-1271].
314  *
315  * _Available since v4.1._
316  */
317 interface IERC1271 {
318     /**
319      * @dev Should return whether the signature provided is valid for the provided data
320      * @param hash      Hash of the data to be signed
321      * @param signature Signature byte array associated with _data
322      */
323     function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
324 }
325 
326 // File: @openzeppelin/contracts/utils/Address.sol
327 
328 
329 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
330 
331 pragma solidity ^0.8.1;
332 
333 /**
334  * @dev Collection of functions related to the address type
335  */
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      *
354      * [IMPORTANT]
355      * ====
356      * You shouldn't rely on `isContract` to protect against flash loan attacks!
357      *
358      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
359      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
360      * constructor.
361      * ====
362      */
363     function isContract(address account) internal view returns (bool) {
364         // This method relies on extcodesize/address.code.length, which returns 0
365         // for contracts in construction, since the code is only stored at the end
366         // of the constructor execution.
367 
368         return account.code.length > 0;
369     }
370 
371     /**
372      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
373      * `recipient`, forwarding all available gas and reverting on errors.
374      *
375      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
376      * of certain opcodes, possibly making contracts go over the 2300 gas limit
377      * imposed by `transfer`, making them unable to receive funds via
378      * `transfer`. {sendValue} removes this limitation.
379      *
380      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
381      *
382      * IMPORTANT: because control is transferred to `recipient`, care must be
383      * taken to not create reentrancy vulnerabilities. Consider using
384      * {ReentrancyGuard} or the
385      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
386      */
387     function sendValue(address payable recipient, uint256 amount) internal {
388         require(address(this).balance >= amount, "Address: insufficient balance");
389 
390         (bool success, ) = recipient.call{value: amount}("");
391         require(success, "Address: unable to send value, recipient may have reverted");
392     }
393 
394     /**
395      * @dev Performs a Solidity function call using a low level `call`. A
396      * plain `call` is an unsafe replacement for a function call: use this
397      * function instead.
398      *
399      * If `target` reverts with a revert reason, it is bubbled up by this
400      * function (like regular Solidity function calls).
401      *
402      * Returns the raw returned data. To convert to the expected return value,
403      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
404      *
405      * Requirements:
406      *
407      * - `target` must be a contract.
408      * - calling `target` with `data` must not revert.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionCall(target, data, "Address: low-level call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
418      * `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, 0, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but also transferring `value` wei to `target`.
433      *
434      * Requirements:
435      *
436      * - the calling contract must have an ETH balance of at least `value`.
437      * - the called Solidity function must be `payable`.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(
442         address target,
443         bytes memory data,
444         uint256 value
445     ) internal returns (bytes memory) {
446         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
451      * with `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(
456         address target,
457         bytes memory data,
458         uint256 value,
459         string memory errorMessage
460     ) internal returns (bytes memory) {
461         require(address(this).balance >= value, "Address: insufficient balance for call");
462         require(isContract(target), "Address: call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.call{value: value}(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a static call.
471      *
472      * _Available since v3.3._
473      */
474     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
475         return functionStaticCall(target, data, "Address: low-level static call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a static call.
481      *
482      * _Available since v3.3._
483      */
484     function functionStaticCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal view returns (bytes memory) {
489         require(isContract(target), "Address: static call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.staticcall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.4._
500      */
501     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
502         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
507      * but performing a delegate call.
508      *
509      * _Available since v3.4._
510      */
511     function functionDelegateCall(
512         address target,
513         bytes memory data,
514         string memory errorMessage
515     ) internal returns (bytes memory) {
516         require(isContract(target), "Address: delegate call to non-contract");
517 
518         (bool success, bytes memory returndata) = target.delegatecall(data);
519         return verifyCallResult(success, returndata, errorMessage);
520     }
521 
522     /**
523      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
524      * revert reason using the provided one.
525      *
526      * _Available since v4.3._
527      */
528     function verifyCallResult(
529         bool success,
530         bytes memory returndata,
531         string memory errorMessage
532     ) internal pure returns (bytes memory) {
533         if (success) {
534             return returndata;
535         } else {
536             // Look for revert reason and bubble it up if present
537             if (returndata.length > 0) {
538                 // The easiest way to bubble the revert reason is using memory via assembly
539 
540                 assembly {
541                     let returndata_size := mload(returndata)
542                     revert(add(32, returndata), returndata_size)
543                 }
544             } else {
545                 revert(errorMessage);
546             }
547         }
548     }
549 }
550 
551 // File: @openzeppelin/contracts/utils/Strings.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev String operations.
560  */
561 library Strings {
562     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
563 
564     /**
565      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
566      */
567     function toString(uint256 value) internal pure returns (string memory) {
568         // Inspired by OraclizeAPI's implementation - MIT licence
569         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
570 
571         if (value == 0) {
572             return "0";
573         }
574         uint256 temp = value;
575         uint256 digits;
576         while (temp != 0) {
577             digits++;
578             temp /= 10;
579         }
580         bytes memory buffer = new bytes(digits);
581         while (value != 0) {
582             digits -= 1;
583             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
584             value /= 10;
585         }
586         return string(buffer);
587     }
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
591      */
592     function toHexString(uint256 value) internal pure returns (string memory) {
593         if (value == 0) {
594             return "0x00";
595         }
596         uint256 temp = value;
597         uint256 length = 0;
598         while (temp != 0) {
599             length++;
600             temp >>= 8;
601         }
602         return toHexString(value, length);
603     }
604 
605     /**
606      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
607      */
608     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
609         bytes memory buffer = new bytes(2 * length + 2);
610         buffer[0] = "0";
611         buffer[1] = "x";
612         for (uint256 i = 2 * length + 1; i > 1; --i) {
613             buffer[i] = _HEX_SYMBOLS[value & 0xf];
614             value >>= 4;
615         }
616         require(value == 0, "Strings: hex length insufficient");
617         return string(buffer);
618     }
619 }
620 
621 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
622 
623 
624 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
631  *
632  * These functions can be used to verify that a message was signed by the holder
633  * of the private keys of a given address.
634  */
635 library ECDSA {
636     enum RecoverError {
637         NoError,
638         InvalidSignature,
639         InvalidSignatureLength,
640         InvalidSignatureS,
641         InvalidSignatureV
642     }
643 
644     function _throwError(RecoverError error) private pure {
645         if (error == RecoverError.NoError) {
646             return; // no error: do nothing
647         } else if (error == RecoverError.InvalidSignature) {
648             revert("ECDSA: invalid signature");
649         } else if (error == RecoverError.InvalidSignatureLength) {
650             revert("ECDSA: invalid signature length");
651         } else if (error == RecoverError.InvalidSignatureS) {
652             revert("ECDSA: invalid signature 's' value");
653         } else if (error == RecoverError.InvalidSignatureV) {
654             revert("ECDSA: invalid signature 'v' value");
655         }
656     }
657 
658     /**
659      * @dev Returns the address that signed a hashed message (`hash`) with
660      * `signature` or error string. This address can then be used for verification purposes.
661      *
662      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
663      * this function rejects them by requiring the `s` value to be in the lower
664      * half order, and the `v` value to be either 27 or 28.
665      *
666      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
667      * verification to be secure: it is possible to craft signatures that
668      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
669      * this is by receiving a hash of the original message (which may otherwise
670      * be too long), and then calling {toEthSignedMessageHash} on it.
671      *
672      * Documentation for signature generation:
673      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
674      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
675      *
676      * _Available since v4.3._
677      */
678     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
679         // Check the signature length
680         // - case 65: r,s,v signature (standard)
681         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
682         if (signature.length == 65) {
683             bytes32 r;
684             bytes32 s;
685             uint8 v;
686             // ecrecover takes the signature parameters, and the only way to get them
687             // currently is to use assembly.
688             assembly {
689                 r := mload(add(signature, 0x20))
690                 s := mload(add(signature, 0x40))
691                 v := byte(0, mload(add(signature, 0x60)))
692             }
693             return tryRecover(hash, v, r, s);
694         } else if (signature.length == 64) {
695             bytes32 r;
696             bytes32 vs;
697             // ecrecover takes the signature parameters, and the only way to get them
698             // currently is to use assembly.
699             assembly {
700                 r := mload(add(signature, 0x20))
701                 vs := mload(add(signature, 0x40))
702             }
703             return tryRecover(hash, r, vs);
704         } else {
705             return (address(0), RecoverError.InvalidSignatureLength);
706         }
707     }
708 
709     /**
710      * @dev Returns the address that signed a hashed message (`hash`) with
711      * `signature`. This address can then be used for verification purposes.
712      *
713      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
714      * this function rejects them by requiring the `s` value to be in the lower
715      * half order, and the `v` value to be either 27 or 28.
716      *
717      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
718      * verification to be secure: it is possible to craft signatures that
719      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
720      * this is by receiving a hash of the original message (which may otherwise
721      * be too long), and then calling {toEthSignedMessageHash} on it.
722      */
723     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
724         (address recovered, RecoverError error) = tryRecover(hash, signature);
725         _throwError(error);
726         return recovered;
727     }
728 
729     /**
730      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
731      *
732      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
733      *
734      * _Available since v4.3._
735      */
736     function tryRecover(
737         bytes32 hash,
738         bytes32 r,
739         bytes32 vs
740     ) internal pure returns (address, RecoverError) {
741         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
742         uint8 v = uint8((uint256(vs) >> 255) + 27);
743         return tryRecover(hash, v, r, s);
744     }
745 
746     /**
747      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
748      *
749      * _Available since v4.2._
750      */
751     function recover(
752         bytes32 hash,
753         bytes32 r,
754         bytes32 vs
755     ) internal pure returns (address) {
756         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
757         _throwError(error);
758         return recovered;
759     }
760 
761     /**
762      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
763      * `r` and `s` signature fields separately.
764      *
765      * _Available since v4.3._
766      */
767     function tryRecover(
768         bytes32 hash,
769         uint8 v,
770         bytes32 r,
771         bytes32 s
772     ) internal pure returns (address, RecoverError) {
773         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
774         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
775         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
776         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
777         //
778         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
779         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
780         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
781         // these malleable signatures as well.
782         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
783             return (address(0), RecoverError.InvalidSignatureS);
784         }
785         if (v != 27 && v != 28) {
786             return (address(0), RecoverError.InvalidSignatureV);
787         }
788 
789         // If the signature is valid (and not malleable), return the signer address
790         address signer = ecrecover(hash, v, r, s);
791         if (signer == address(0)) {
792             return (address(0), RecoverError.InvalidSignature);
793         }
794 
795         return (signer, RecoverError.NoError);
796     }
797 
798     /**
799      * @dev Overload of {ECDSA-recover} that receives the `v`,
800      * `r` and `s` signature fields separately.
801      */
802     function recover(
803         bytes32 hash,
804         uint8 v,
805         bytes32 r,
806         bytes32 s
807     ) internal pure returns (address) {
808         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
809         _throwError(error);
810         return recovered;
811     }
812 
813     /**
814      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
815      * produces hash corresponding to the one signed with the
816      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
817      * JSON-RPC method as part of EIP-191.
818      *
819      * See {recover}.
820      */
821     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
822         // 32 is the length in bytes of hash,
823         // enforced by the type signature above
824         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
825     }
826 
827     /**
828      * @dev Returns an Ethereum Signed Message, created from `s`. This
829      * produces hash corresponding to the one signed with the
830      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
831      * JSON-RPC method as part of EIP-191.
832      *
833      * See {recover}.
834      */
835     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
836         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
837     }
838 
839     /**
840      * @dev Returns an Ethereum Signed Typed Data, created from a
841      * `domainSeparator` and a `structHash`. This produces hash corresponding
842      * to the one signed with the
843      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
844      * JSON-RPC method as part of EIP-712.
845      *
846      * See {recover}.
847      */
848     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
849         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
850     }
851 }
852 
853 // File: @openzeppelin/contracts/utils/cryptography/SignatureChecker.sol
854 
855 
856 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/SignatureChecker.sol)
857 
858 pragma solidity ^0.8.0;
859 
860 
861 
862 
863 /**
864  * @dev Signature verification helper that can be used instead of `ECDSA.recover` to seamlessly support both ECDSA
865  * signatures from externally owned accounts (EOAs) as well as ERC1271 signatures from smart contract wallets like
866  * Argent and Gnosis Safe.
867  *
868  * _Available since v4.1._
869  */
870 library SignatureChecker {
871     /**
872      * @dev Checks if a signature is valid for a given signer and data hash. If the signer is a smart contract, the
873      * signature is validated against that smart contract using ERC1271, otherwise it's validated using `ECDSA.recover`.
874      *
875      * NOTE: Unlike ECDSA signatures, contract signatures are revocable, and the outcome of this function can thus
876      * change through time. It could return true at block N and false at block N+1 (or the opposite).
877      */
878     function isValidSignatureNow(
879         address signer,
880         bytes32 hash,
881         bytes memory signature
882     ) internal view returns (bool) {
883         (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
884         if (error == ECDSA.RecoverError.NoError && recovered == signer) {
885             return true;
886         }
887 
888         (bool success, bytes memory result) = signer.staticcall(
889             abi.encodeWithSelector(IERC1271.isValidSignature.selector, hash, signature)
890         );
891         return (success && result.length == 32 && abi.decode(result, (bytes4)) == IERC1271.isValidSignature.selector);
892     }
893 }
894 
895 // File: @openzeppelin/contracts/utils/Context.sol
896 
897 
898 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 /**
903  * @dev Provides information about the current execution context, including the
904  * sender of the transaction and its data. While these are generally available
905  * via msg.sender and msg.data, they should not be accessed in such a direct
906  * manner, since when dealing with meta-transactions the account sending and
907  * paying for execution may not be the actual sender (as far as an application
908  * is concerned).
909  *
910  * This contract is only required for intermediate, library-like contracts.
911  */
912 abstract contract Context {
913     function _msgSender() internal view virtual returns (address) {
914         return msg.sender;
915     }
916 
917     function _msgData() internal view virtual returns (bytes calldata) {
918         return msg.data;
919     }
920 }
921 
922 // File: @openzeppelin/contracts/access/Ownable.sol
923 
924 
925 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 /**
931  * @dev Contract module which provides a basic access control mechanism, where
932  * there is an account (an owner) that can be granted exclusive access to
933  * specific functions.
934  *
935  * By default, the owner account will be the one that deploys the contract. This
936  * can later be changed with {transferOwnership}.
937  *
938  * This module is used through inheritance. It will make available the modifier
939  * `onlyOwner`, which can be applied to your functions to restrict their use to
940  * the owner.
941  */
942 abstract contract Ownable is Context {
943     address private _owner;
944 
945     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
946 
947     /**
948      * @dev Initializes the contract setting the deployer as the initial owner.
949      */
950     constructor() {
951         _transferOwnership(_msgSender());
952     }
953 
954     /**
955      * @dev Returns the address of the current owner.
956      */
957     function owner() public view virtual returns (address) {
958         return _owner;
959     }
960 
961     /**
962      * @dev Throws if called by any account other than the owner.
963      */
964     modifier onlyOwner() {
965         require(owner() == _msgSender(), "Ownable: caller is not the owner");
966         _;
967     }
968 
969     /**
970      * @dev Leaves the contract without owner. It will not be possible to call
971      * `onlyOwner` functions anymore. Can only be called by the current owner.
972      *
973      * NOTE: Renouncing ownership will leave the contract without an owner,
974      * thereby removing any functionality that is only available to the owner.
975      */
976     function renounceOwnership() public virtual onlyOwner {
977         _transferOwnership(address(0));
978     }
979 
980     /**
981      * @dev Transfers ownership of the contract to a new account (`newOwner`).
982      * Can only be called by the current owner.
983      */
984     function transferOwnership(address newOwner) public virtual onlyOwner {
985         require(newOwner != address(0), "Ownable: new owner is the zero address");
986         _transferOwnership(newOwner);
987     }
988 
989     /**
990      * @dev Transfers ownership of the contract to a new account (`newOwner`).
991      * Internal function without access restriction.
992      */
993     function _transferOwnership(address newOwner) internal virtual {
994         address oldOwner = _owner;
995         _owner = newOwner;
996         emit OwnershipTransferred(oldOwner, newOwner);
997     }
998 }
999 
1000 // File: @openzeppelin/contracts/security/Pausable.sol
1001 
1002 
1003 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 
1008 /**
1009  * @dev Contract module which allows children to implement an emergency stop
1010  * mechanism that can be triggered by an authorized account.
1011  *
1012  * This module is used through inheritance. It will make available the
1013  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1014  * the functions of your contract. Note that they will not be pausable by
1015  * simply including this module, only once the modifiers are put in place.
1016  */
1017 abstract contract Pausable is Context {
1018     /**
1019      * @dev Emitted when the pause is triggered by `account`.
1020      */
1021     event Paused(address account);
1022 
1023     /**
1024      * @dev Emitted when the pause is lifted by `account`.
1025      */
1026     event Unpaused(address account);
1027 
1028     bool private _paused;
1029 
1030     /**
1031      * @dev Initializes the contract in unpaused state.
1032      */
1033     constructor() {
1034         _paused = false;
1035     }
1036 
1037     /**
1038      * @dev Returns true if the contract is paused, and false otherwise.
1039      */
1040     function paused() public view virtual returns (bool) {
1041         return _paused;
1042     }
1043 
1044     /**
1045      * @dev Modifier to make a function callable only when the contract is not paused.
1046      *
1047      * Requirements:
1048      *
1049      * - The contract must not be paused.
1050      */
1051     modifier whenNotPaused() {
1052         require(!paused(), "Pausable: paused");
1053         _;
1054     }
1055 
1056     /**
1057      * @dev Modifier to make a function callable only when the contract is paused.
1058      *
1059      * Requirements:
1060      *
1061      * - The contract must be paused.
1062      */
1063     modifier whenPaused() {
1064         require(paused(), "Pausable: not paused");
1065         _;
1066     }
1067 
1068     /**
1069      * @dev Triggers stopped state.
1070      *
1071      * Requirements:
1072      *
1073      * - The contract must not be paused.
1074      */
1075     function _pause() internal virtual whenNotPaused {
1076         _paused = true;
1077         emit Paused(_msgSender());
1078     }
1079 
1080     /**
1081      * @dev Returns to normal state.
1082      *
1083      * Requirements:
1084      *
1085      * - The contract must be paused.
1086      */
1087     function _unpause() internal virtual whenPaused {
1088         _paused = false;
1089         emit Unpaused(_msgSender());
1090     }
1091 }
1092 
1093 // File: @openzeppelin/contracts/utils/Counters.sol
1094 
1095 
1096 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1097 
1098 pragma solidity ^0.8.0;
1099 
1100 /**
1101  * @title Counters
1102  * @author Matt Condon (@shrugs)
1103  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1104  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1105  *
1106  * Include with `using Counters for Counters.Counter;`
1107  */
1108 library Counters {
1109     struct Counter {
1110         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1111         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1112         // this feature: see https://github.com/ethereum/solidity/issues/4637
1113         uint256 _value; // default: 0
1114     }
1115 
1116     function current(Counter storage counter) internal view returns (uint256) {
1117         return counter._value;
1118     }
1119 
1120     function increment(Counter storage counter) internal {
1121         unchecked {
1122             counter._value += 1;
1123         }
1124     }
1125 
1126     function decrement(Counter storage counter) internal {
1127         uint256 value = counter._value;
1128         require(value > 0, "Counter: decrement overflow");
1129         unchecked {
1130             counter._value = value - 1;
1131         }
1132     }
1133 
1134     function reset(Counter storage counter) internal {
1135         counter._value = 0;
1136     }
1137 }
1138 
1139 // File: contracts/Monostore.sol
1140 
1141 pragma solidity ^0.8.11;
1142 
1143 
1144 
1145 
1146 
1147 
1148 
1149 contract Monostore is Pausable, Ownable, ReentrancyGuard {
1150   using SafeMath for uint256;
1151   using SignatureChecker for address;
1152   address private signer;
1153   IMonolocco public _monoLocco;
1154   mapping (address => bool) public _minted;
1155   uint256 public _price = 0.25 ether;
1156   uint256 public constant LIST_IDENTIFIER = 2;
1157   uint256 public _startsAt = 1646049600; //2022-02-28T12:00:00.000Z
1158   uint256 public _endsAt = 1646071200; //2022-02-28T18:00:00.000Z
1159   address MHTT = 0x3eb7551EaC8ABaFc2f43b706dc2226aDE6E9051b;
1160   address PIG = 0xAF483e4d13100c7c6D0F7543a0E603Ac4eb32D5d;
1161   address LUCKY = 0x16256536e2B2fEe74d914169cB3612aC37f9Cc2A;
1162   constructor(
1163     address signer_,
1164     address monoLocco_
1165   ){
1166     signer = signer_;
1167     _monoLocco = IMonolocco(monoLocco_);
1168   }
1169 
1170   function mint(bytes memory signature)
1171     external
1172     payable
1173     whenNotPaused 
1174     nonReentrant
1175   {
1176     require(block.timestamp >= _startsAt && block.timestamp <= _endsAt, "MonoStore: Not active");
1177     require(signer.isValidSignatureNow(keccak256(abi.encodePacked(msg.sender, LIST_IDENTIFIER)), signature), "MonoStore: Invalid signature");
1178     require(!_minted[msg.sender], "MonoStore: User already minted");
1179     require(msg.value >= _price, "MonoStore: msg.value is less than total price");
1180     _minted[msg.sender] = true;
1181     _monoLocco.mint(msg.sender, 1);
1182   }
1183 
1184   function splitWithdraw() external onlyOwner {
1185     payable(MHTT).transfer(address(this).balance / 3);
1186     payable(PIG).transfer(address(this).balance / 3);
1187     payable(LUCKY).transfer(address(this).balance / 3);
1188   }
1189 
1190   function withdraw() external onlyOwner {
1191     payable(owner()).transfer(address(this).balance);
1192   }
1193 
1194   function updateSigner(address _newSigner) external onlyOwner {
1195     signer = _newSigner;
1196   }
1197   function pause() external onlyOwner {
1198     _pause();
1199   }
1200 
1201   function unPause() external onlyOwner {
1202     _unpause();
1203   }
1204 
1205   function changeStartAt(uint256 newDate) external onlyOwner {
1206     _startsAt =  newDate;
1207   }
1208   function changeEndsAt(uint256 newDate) external onlyOwner {
1209     _endsAt =  newDate;
1210   }
1211   function changePrice(uint256 newPrice) external onlyOwner {
1212     _price = newPrice;
1213   }
1214 }