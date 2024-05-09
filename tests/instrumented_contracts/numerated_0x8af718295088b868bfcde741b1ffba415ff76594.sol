1 pragma solidity ^0.8.0;
2 // SPDX-License-Identifier: MIT
3 // CAUTION
4 // This version of SafeMath should only be used with Solidity 0.8 or later,
5 // because it relies on the compiler's built in overflow checks.
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations.
9  *
10  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
11  * now has built in overflow checking.
12  */
13 library SafeMath {
14     /**
15      * @dev Returns the addition of two unsigned integers, with an overflow flag.
16      *
17      * _Available since v3.4._
18      */
19     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {
21             uint256 c = a + b;
22             if (c < a) return (false, 0);
23             return (true, c);
24         }
25     }
26 
27     /**
28      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             if (b > a) return (false, 0);
35             return (true, a - b);
36         }
37     }
38 
39     /**
40      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {
46             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47             // benefit is lost if 'b' is also tested.
48             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49             if (a == 0) return (true, 0);
50             uint256 c = a * b;
51             if (c / a != b) return (false, 0);
52             return (true, c);
53         }
54     }
55 
56     /**
57      * @dev Returns the division of two unsigned integers, with a division by zero flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             if (b == 0) return (false, 0);
64             return (true, a / b);
65         }
66     }
67 
68     /**
69      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             if (b == 0) return (false, 0);
76             return (true, a % b);
77         }
78     }
79 
80     /**
81      * @dev Returns the addition of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      *
88      * - Addition cannot overflow.
89      */
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a + b;
92     }
93 
94     /**
95      * @dev Returns the subtraction of two unsigned integers, reverting on
96      * overflow (when the result is negative).
97      *
98      * Counterpart to Solidity's `-` operator.
99      *
100      * Requirements:
101      *
102      * - Subtraction cannot overflow.
103      */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a * b;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers, reverting on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator.
127      *
128      * Requirements:
129      *
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return a / b;
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * reverting when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         return a % b;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * CAUTION: This function is deprecated because it requires allocating memory for the error
157      * message unnecessarily. For custom revert reasons use {trySub}.
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(
166         uint256 a,
167         uint256 b,
168         string memory errorMessage
169     ) internal pure returns (uint256) {
170         unchecked {
171             require(b <= a, errorMessage);
172             return a - b;
173         }
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(
189         uint256 a,
190         uint256 b,
191         string memory errorMessage
192     ) internal pure returns (uint256) {
193         unchecked {
194             require(b > 0, errorMessage);
195             return a / b;
196         }
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         unchecked {
220             require(b > 0, errorMessage);
221             return a % b;
222         }
223     }
224 }
225 /**
226  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
227  *
228  * These functions can be used to verify that a message was signed by the holder
229  * of the private keys of a given address.
230  */
231 library ECDSA {
232     /**
233      * @dev Returns the address that signed a hashed message (`hash`) with
234      * `signature`. This address can then be used for verification purposes.
235      *
236      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
237      * this function rejects them by requiring the `s` value to be in the lower
238      * half order, and the `v` value to be either 27 or 28.
239      *
240      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
241      * verification to be secure: it is possible to craft signatures that
242      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
243      * this is by receiving a hash of the original message (which may otherwise
244      * be too long), and then calling {toEthSignedMessageHash} on it.
245      *
246      * Documentation for signature generation:
247      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
248      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
249      */
250     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
251         // Check the signature length
252         // - case 65: r,s,v signature (standard)
253         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
254         if (signature.length == 65) {
255             bytes32 r;
256             bytes32 s;
257             uint8 v;
258             // ecrecover takes the signature parameters, and the only way to get them
259             // currently is to use assembly.
260             assembly {
261                 r := mload(add(signature, 0x20))
262                 s := mload(add(signature, 0x40))
263                 v := byte(0, mload(add(signature, 0x60)))
264             }
265             return recover(hash, v, r, s);
266         } else if (signature.length == 64) {
267             bytes32 r;
268             bytes32 vs;
269             // ecrecover takes the signature parameters, and the only way to get them
270             // currently is to use assembly.
271             assembly {
272                 r := mload(add(signature, 0x20))
273                 vs := mload(add(signature, 0x40))
274             }
275             return recover(hash, r, vs);
276         } else {
277             revert("ECDSA: invalid signature length");
278         }
279     }
280 
281     /**
282      * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
283      *
284      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
285      *
286      * _Available since v4.2._
287      */
288     function recover(
289         bytes32 hash,
290         bytes32 r,
291         bytes32 vs
292     ) internal pure returns (address) {
293         bytes32 s;
294         uint8 v;
295         assembly {
296             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
297             v := add(shr(255, vs), 27)
298         }
299         return recover(hash, v, r, s);
300     }
301 
302     /**
303      * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
304      */
305     function recover(
306         bytes32 hash,
307         uint8 v,
308         bytes32 r,
309         bytes32 s
310     ) internal pure returns (address) {
311         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
312         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
313         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
314         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
315         //
316         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
317         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
318         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
319         // these malleable signatures as well.
320         require(
321             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
322             "ECDSA: invalid signature 's' value"
323         );
324         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
325 
326         // If the signature is valid (and not malleable), return the signer address
327         address signer = ecrecover(hash, v, r, s);
328         require(signer != address(0), "ECDSA: invalid signature");
329 
330         return signer;
331     }
332 
333     /**
334      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
335      * produces hash corresponding to the one signed with the
336      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
337      * JSON-RPC method as part of EIP-191.
338      *
339      * See {recover}.
340      */
341     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
342         // 32 is the length in bytes of hash,
343         // enforced by the type signature above
344         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
345     }
346 
347     /**
348      * @dev Returns an Ethereum Signed Typed Data, created from a
349      * `domainSeparator` and a `structHash`. This produces hash corresponding
350      * to the one signed with the
351      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
352      * JSON-RPC method as part of EIP-712.
353      *
354      * See {recover}.
355      */
356     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
357         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
358     }
359 }
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev String operations.
364  */
365 library Strings {
366     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
367 
368     /**
369      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
370      */
371     function toString(uint256 value) internal pure returns (string memory) {
372         // Inspired by OraclizeAPI's implementation - MIT licence
373         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
374 
375         if (value == 0) {
376             return "0";
377         }
378         uint256 temp = value;
379         uint256 digits;
380         while (temp != 0) {
381             digits++;
382             temp /= 10;
383         }
384         bytes memory buffer = new bytes(digits);
385         while (value != 0) {
386             digits -= 1;
387             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
388             value /= 10;
389         }
390         return string(buffer);
391     }
392 
393     /**
394      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
395      */
396     function toHexString(uint256 value) internal pure returns (string memory) {
397         if (value == 0) {
398             return "0x00";
399         }
400         uint256 temp = value;
401         uint256 length = 0;
402         while (temp != 0) {
403             length++;
404             temp >>= 8;
405         }
406         return toHexString(value, length);
407     }
408 
409     /**
410      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
411      */
412     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
413         bytes memory buffer = new bytes(2 * length + 2);
414         buffer[0] = "0";
415         buffer[1] = "x";
416         for (uint256 i = 2 * length + 1; i > 1; --i) {
417             buffer[i] = _HEX_SYMBOLS[value & 0xf];
418             value >>= 4;
419         }
420         require(value == 0, "Strings: hex length insufficient");
421         return string(buffer);
422     }
423 }
424 
425 /**
426  * @dev Collection of functions related to the address type
427  */
428 library Address {
429     /**
430      * @dev Returns true if `account` is a contract.
431      *
432      * [IMPORTANT]
433      * ====
434      * It is unsafe to assume that an address for which this function returns
435      * false is an externally-owned account (EOA) and not a contract.
436      *
437      * Among others, `isContract` will return false for the following
438      * types of addresses:
439      *
440      *  - an externally-owned account
441      *  - a contract in construction
442      *  - an address where a contract will be created
443      *  - an address where a contract lived, but was destroyed
444      * ====
445      */
446     function isContract(address account) internal view returns (bool) {
447         // This method relies on extcodesize, which returns 0 for contracts in
448         // construction, since the code is only stored at the end of the
449         // constructor execution.
450 
451         uint256 size;
452         assembly {
453             size := extcodesize(account)
454         }
455         return size > 0;
456     }
457 
458     /**
459      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
460      * `recipient`, forwarding all available gas and reverting on errors.
461      *
462      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
463      * of certain opcodes, possibly making contracts go over the 2300 gas limit
464      * imposed by `transfer`, making them unable to receive funds via
465      * `transfer`. {sendValue} removes this limitation.
466      *
467      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
468      *
469      * IMPORTANT: because control is transferred to `recipient`, care must be
470      * taken to not create reentrancy vulnerabilities. Consider using
471      * {ReentrancyGuard} or the
472      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
473      */
474     function sendValue(address payable recipient, uint256 amount) internal {
475         require(address(this).balance >= amount, "Address: insufficient balance");
476 
477         (bool success, ) = recipient.call{value: amount}("");
478         require(success, "Address: unable to send value, recipient may have reverted");
479     }
480 
481     /**
482      * @dev Performs a Solidity function call using a low level `call`. A
483      * plain `call` is an unsafe replacement for a function call: use this
484      * function instead.
485      *
486      * If `target` reverts with a revert reason, it is bubbled up by this
487      * function (like regular Solidity function calls).
488      *
489      * Returns the raw returned data. To convert to the expected return value,
490      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
491      *
492      * Requirements:
493      *
494      * - `target` must be a contract.
495      * - calling `target` with `data` must not revert.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
500         return functionCall(target, data, "Address: low-level call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
505      * `errorMessage` as a fallback revert reason when `target` reverts.
506      *
507      * _Available since v3.1._
508      */
509     function functionCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         return functionCallWithValue(target, data, 0, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but also transferring `value` wei to `target`.
520      *
521      * Requirements:
522      *
523      * - the calling contract must have an ETH balance of at least `value`.
524      * - the called Solidity function must be `payable`.
525      *
526      * _Available since v3.1._
527      */
528     function functionCallWithValue(
529         address target,
530         bytes memory data,
531         uint256 value
532     ) internal returns (bytes memory) {
533         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
538      * with `errorMessage` as a fallback revert reason when `target` reverts.
539      *
540      * _Available since v3.1._
541      */
542     function functionCallWithValue(
543         address target,
544         bytes memory data,
545         uint256 value,
546         string memory errorMessage
547     ) internal returns (bytes memory) {
548         require(address(this).balance >= value, "Address: insufficient balance for call");
549         require(isContract(target), "Address: call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.call{value: value}(data);
552         return _verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but performing a static call.
558      *
559      * _Available since v3.3._
560      */
561     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
562         return functionStaticCall(target, data, "Address: low-level static call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
567      * but performing a static call.
568      *
569      * _Available since v3.3._
570      */
571     function functionStaticCall(
572         address target,
573         bytes memory data,
574         string memory errorMessage
575     ) internal view returns (bytes memory) {
576         require(isContract(target), "Address: static call to non-contract");
577 
578         (bool success, bytes memory returndata) = target.staticcall(data);
579         return _verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
584      * but performing a delegate call.
585      *
586      * _Available since v3.4._
587      */
588     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
589         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
594      * but performing a delegate call.
595      *
596      * _Available since v3.4._
597      */
598     function functionDelegateCall(
599         address target,
600         bytes memory data,
601         string memory errorMessage
602     ) internal returns (bytes memory) {
603         require(isContract(target), "Address: delegate call to non-contract");
604 
605         (bool success, bytes memory returndata) = target.delegatecall(data);
606         return _verifyCallResult(success, returndata, errorMessage);
607     }
608 
609     function _verifyCallResult(
610         bool success,
611         bytes memory returndata,
612         string memory errorMessage
613     ) private pure returns (bytes memory) {
614         if (success) {
615             return returndata;
616         } else {
617             // Look for revert reason and bubble it up if present
618             if (returndata.length > 0) {
619                 // The easiest way to bubble the revert reason is using memory via assembly
620 
621                 assembly {
622                     let returndata_size := mload(returndata)
623                     revert(add(32, returndata), returndata_size)
624                 }
625             } else {
626                 revert(errorMessage);
627             }
628         }
629     }
630 }
631 
632 /*
633  * @dev Provides information about the current execution context, including the
634  * sender of the transaction and its data. While these are generally available
635  * via msg.sender and msg.data, they should not be accessed in such a direct
636  * manner, since when dealing with meta-transactions the account sending and
637  * paying for execution may not be the actual sender (as far as an application
638  * is concerned).
639  *
640  * This contract is only required for intermediate, library-like contracts.
641  */
642 abstract contract Context {
643     function _msgSender() internal view virtual returns (address) {
644         return msg.sender;
645     }
646 
647     function _msgData() internal view virtual returns (bytes calldata) {
648         return msg.data;
649     }
650 }
651 /**
652  * @dev Contract module which provides a basic access control mechanism, where
653  * there is an account (an owner) that can be granted exclusive access to
654  * specific functions.
655  *
656  * By default, the owner account will be the one that deploys the contract. This
657  * can later be changed with {transferOwnership}.
658  *
659  * This module is used through inheritance. It will make available the modifier
660  * `onlyOwner`, which can be applied to your functions to restrict their use to
661  * the owner.
662  */
663 abstract contract Ownable is Context {
664     address private _owner;
665 
666     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
667 
668     /**
669      * @dev Initializes the contract setting the deployer as the initial owner.
670      */
671     constructor() {
672         _setOwner(_msgSender());
673     }
674 
675     /**
676      * @dev Returns the address of the current owner.
677      */
678     function owner() public view virtual returns (address) {
679         return _owner;
680     }
681 
682     /**
683      * @dev Throws if called by any account other than the owner.
684      */
685     modifier onlyOwner() {
686         require(owner() == _msgSender(), "Ownable: caller is not the owner");
687         _;
688     }
689 
690     /**
691      * @dev Leaves the contract without owner. It will not be possible to call
692      * `onlyOwner` functions anymore. Can only be called by the current owner.
693      *
694      * NOTE: Renouncing ownership will leave the contract without an owner,
695      * thereby removing any functionality that is only available to the owner.
696      */
697     function renounceOwnership() public virtual onlyOwner {
698         _setOwner(address(0));
699     }
700 
701     /**
702      * @dev Transfers ownership of the contract to a new account (`newOwner`).
703      * Can only be called by the current owner.
704      */
705     function transferOwnership(address newOwner) public virtual onlyOwner {
706         require(newOwner != address(0), "Ownable: new owner is the zero address");
707         _setOwner(newOwner);
708     }
709 
710     function _setOwner(address newOwner) private {
711         address oldOwner = _owner;
712         _owner = newOwner;
713         emit OwnershipTransferred(oldOwner, newOwner);
714     }
715 }
716 
717 
718 // ERC721A Contracts v4.2.3
719 // Creator: Chiru Labs
720 /**
721  * @dev Interface of ERC721A.
722  */
723 interface IERC721A {
724     /**
725      * The caller must own the token or be an approved operator.
726      */
727     error ApprovalCallerNotOwnerNorApproved();
728 
729     /**
730      * The token does not exist.
731      */
732     error ApprovalQueryForNonexistentToken();
733 
734     /**
735      * Cannot query the balance for the zero address.
736      */
737     error BalanceQueryForZeroAddress();
738 
739     /**
740      * Cannot mint to the zero address.
741      */
742     error MintToZeroAddress();
743 
744     /**
745      * The quantity of tokens minted must be more than zero.
746      */
747     error MintZeroQuantity();
748 
749     /**
750      * The token does not exist.
751      */
752     error OwnerQueryForNonexistentToken();
753 
754     /**
755      * The caller must own the token or be an approved operator.
756      */
757     error TransferCallerNotOwnerNorApproved();
758 
759     /**
760      * The token must be owned by `from`.
761      */
762     error TransferFromIncorrectOwner();
763 
764     /**
765      * Cannot safely transfer to a contract that does not implement the
766      * ERC721Receiver interface.
767      */
768     error TransferToNonERC721ReceiverImplementer();
769 
770     /**
771      * Cannot transfer to the zero address.
772      */
773     error TransferToZeroAddress();
774 
775     /**
776      * The token does not exist.
777      */
778     error URIQueryForNonexistentToken();
779 
780     /**
781      * The `quantity` minted with ERC2309 exceeds the safety limit.
782      */
783     error MintERC2309QuantityExceedsLimit();
784 
785     /**
786      * The `extraData` cannot be set on an unintialized ownership slot.
787      */
788     error OwnershipNotInitializedForExtraData();
789 
790     // =============================================================
791     //                            STRUCTS
792     // =============================================================
793 
794     struct TokenOwnership {
795         // The address of the owner.
796         address addr;
797         // Stores the start time of ownership with minimal overhead for tokenomics.
798         uint64 startTimestamp;
799         // Whether the token has been burned.
800         bool burned;
801         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
802         uint24 extraData;
803     }
804 
805     // =============================================================
806     //                         TOKEN COUNTERS
807     // =============================================================
808 
809     /**
810      * @dev Returns the total number of tokens in existence.
811      * Burned tokens will reduce the count.
812      * To get the total number of tokens minted, please see {_totalMinted}.
813      */
814     function totalSupply() external view returns (uint256);
815 
816     // =============================================================
817     //                            IERC165
818     // =============================================================
819 
820     /**
821      * @dev Returns true if this contract implements the interface defined by
822      * `interfaceId`. See the corresponding
823      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
824      * to learn more about how these ids are created.
825      *
826      * This function call must use less than 30000 gas.
827      */
828     function supportsInterface(bytes4 interfaceId) external view returns (bool);
829 
830     // =============================================================
831     //                            IERC721
832     // =============================================================
833 
834     /**
835      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
836      */
837     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
838 
839     /**
840      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
841      */
842     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
843 
844     /**
845      * @dev Emitted when `owner` enables or disables
846      * (`approved`) `operator` to manage all of its assets.
847      */
848     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
849 
850     /**
851      * @dev Returns the number of tokens in `owner`'s account.
852      */
853     function balanceOf(address owner) external view returns (uint256 balance);
854 
855     /**
856      * @dev Returns the owner of the `tokenId` token.
857      *
858      * Requirements:
859      *
860      * - `tokenId` must exist.
861      */
862     function ownerOf(uint256 tokenId) external view returns (address owner);
863 
864     /**
865      * @dev Safely transfers `tokenId` token from `from` to `to`,
866      * checking first that contract recipients are aware of the ERC721 protocol
867      * to prevent tokens from being forever locked.
868      *
869      * Requirements:
870      *
871      * - `from` cannot be the zero address.
872      * - `to` cannot be the zero address.
873      * - `tokenId` token must exist and be owned by `from`.
874      * - If the caller is not `from`, it must be have been allowed to move
875      * this token by either {approve} or {setApprovalForAll}.
876      * - If `to` refers to a smart contract, it must implement
877      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
878      *
879      * Emits a {Transfer} event.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes calldata data
886     ) external payable;
887 
888     /**
889      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) external payable;
896 
897     /**
898      * @dev Transfers `tokenId` from `from` to `to`.
899      *
900      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
901      * whenever possible.
902      *
903      * Requirements:
904      *
905      * - `from` cannot be the zero address.
906      * - `to` cannot be the zero address.
907      * - `tokenId` token must be owned by `from`.
908      * - If the caller is not `from`, it must be approved to move this token
909      * by either {approve} or {setApprovalForAll}.
910      *
911      * Emits a {Transfer} event.
912      */
913     function transferFrom(
914         address from,
915         address to,
916         uint256 tokenId
917     ) external payable;
918 
919     /**
920      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
921      * The approval is cleared when the token is transferred.
922      *
923      * Only a single account can be approved at a time, so approving the
924      * zero address clears previous approvals.
925      *
926      * Requirements:
927      *
928      * - The caller must own the token or be an approved operator.
929      * - `tokenId` must exist.
930      *
931      * Emits an {Approval} event.
932      */
933     function approve(address to, uint256 tokenId) external payable;
934 
935     /**
936      * @dev Approve or remove `operator` as an operator for the caller.
937      * Operators can call {transferFrom} or {safeTransferFrom}
938      * for any token owned by the caller.
939      *
940      * Requirements:
941      *
942      * - The `operator` cannot be the caller.
943      *
944      * Emits an {ApprovalForAll} event.
945      */
946     function setApprovalForAll(address operator, bool _approved) external;
947 
948     /**
949      * @dev Returns the account approved for `tokenId` token.
950      *
951      * Requirements:
952      *
953      * - `tokenId` must exist.
954      */
955     function getApproved(uint256 tokenId) external view returns (address operator);
956 
957     /**
958      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
959      *
960      * See {setApprovalForAll}.
961      */
962     function isApprovedForAll(address owner, address operator) external view returns (bool);
963 
964     // =============================================================
965     //                        IERC721Metadata
966     // =============================================================
967 
968     /**
969      * @dev Returns the token collection name.
970      */
971     function name() external view returns (string memory);
972 
973     /**
974      * @dev Returns the token collection symbol.
975      */
976     function symbol() external view returns (string memory);
977 
978     /**
979      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
980      */
981     function tokenURI(uint256 tokenId) external view returns (string memory);
982 
983     // =============================================================
984     //                           IERC2309
985     // =============================================================
986 
987     /**
988      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
989      * (inclusive) is transferred from `from` to `to`, as defined in the
990      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
991      *
992      * See {_mintERC2309} for more details.
993      */
994     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
995 }
996 
997 // ERC721A Contracts v4.2.3
998 // Creator: Chiru Labs
999 /**
1000  * @dev Interface of ERC721 token receiver.
1001  */
1002 interface ERC721A__IERC721Receiver {
1003     function onERC721Received(
1004         address operator,
1005         address from,
1006         uint256 tokenId,
1007         bytes calldata data
1008     ) external returns (bytes4);
1009 }
1010 
1011 /**
1012  * @title ERC721A
1013  *
1014  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1015  * Non-Fungible Token Standard, including the Metadata extension.
1016  * Optimized for lower gas during batch mints.
1017  *
1018  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1019  * starting from `_startTokenId()`.
1020  *
1021  * Assumptions:
1022  *
1023  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1024  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1025  */
1026 contract ERC721A is IERC721A {
1027     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1028     struct TokenApprovalRef {
1029         address value;
1030     }
1031 
1032     // =============================================================
1033     //                           CONSTANTS
1034     // =============================================================
1035 
1036     // Mask of an entry in packed address data.
1037     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1038 
1039     // The bit position of `numberMinted` in packed address data.
1040     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1041 
1042     // The bit position of `numberBurned` in packed address data.
1043     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1044 
1045     // The bit position of `aux` in packed address data.
1046     uint256 private constant _BITPOS_AUX = 192;
1047 
1048     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1049     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1050 
1051     // The bit position of `startTimestamp` in packed ownership.
1052     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1053 
1054     // The bit mask of the `burned` bit in packed ownership.
1055     uint256 private constant _BITMASK_BURNED = 1 << 224;
1056 
1057     // The bit position of the `nextInitialized` bit in packed ownership.
1058     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1059 
1060     // The bit mask of the `nextInitialized` bit in packed ownership.
1061     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1062 
1063     // The bit position of `extraData` in packed ownership.
1064     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1065 
1066     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1067     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1068 
1069     // The mask of the lower 160 bits for addresses.
1070     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1071 
1072     // The maximum `quantity` that can be minted with {_mintERC2309}.
1073     // This limit is to prevent overflows on the address data entries.
1074     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1075     // is required to cause an overflow, which is unrealistic.
1076     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1077 
1078     // The `Transfer` event signature is given by:
1079     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1080     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1081         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1082 
1083     // =============================================================
1084     //                            STORAGE
1085     // =============================================================
1086 
1087     // The next token ID to be minted.
1088     uint256 private _currentIndex;
1089 
1090     // The number of tokens burned.
1091     uint256 private _burnCounter;
1092 
1093     // Token name
1094     string private _name;
1095 
1096     // Token symbol
1097     string private _symbol;
1098 
1099     // Mapping from token ID to ownership details
1100     // An empty struct value does not necessarily mean the token is unowned.
1101     // See {_packedOwnershipOf} implementation for details.
1102     //
1103     // Bits Layout:
1104     // - [0..159]   `addr`
1105     // - [160..223] `startTimestamp`
1106     // - [224]      `burned`
1107     // - [225]      `nextInitialized`
1108     // - [232..255] `extraData`
1109     mapping(uint256 => uint256) private _packedOwnerships;
1110 
1111     // Mapping owner address to address data.
1112     //
1113     // Bits Layout:
1114     // - [0..63]    `balance`
1115     // - [64..127]  `numberMinted`
1116     // - [128..191] `numberBurned`
1117     // - [192..255] `aux`
1118     mapping(address => uint256) private _packedAddressData;
1119 
1120     // Mapping from token ID to approved address.
1121     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1122 
1123     // Mapping from owner to operator approvals
1124     mapping(address => mapping(address => bool)) private _operatorApprovals;
1125 
1126     // =============================================================
1127     //                          CONSTRUCTOR
1128     // =============================================================
1129 
1130     constructor(string memory name_, string memory symbol_) {
1131         _name = name_;
1132         _symbol = symbol_;
1133         _currentIndex = _startTokenId();
1134     }
1135 
1136     // =============================================================
1137     //                   TOKEN COUNTING OPERATIONS
1138     // =============================================================
1139 
1140     /**
1141      * @dev Returns the starting token ID.
1142      * To change the starting token ID, please override this function.
1143      */
1144     function _startTokenId() internal view virtual returns (uint256) {
1145         return 0;
1146     }
1147 
1148     /**
1149      * @dev Returns the next token ID to be minted.
1150      */
1151     function _nextTokenId() internal view virtual returns (uint256) {
1152         return _currentIndex;
1153     }
1154 
1155     /**
1156      * @dev Returns the total number of tokens in existence.
1157      * Burned tokens will reduce the count.
1158      * To get the total number of tokens minted, please see {_totalMinted}.
1159      */
1160     function totalSupply() public view virtual override returns (uint256) {
1161         // Counter underflow is impossible as _burnCounter cannot be incremented
1162         // more than `_currentIndex - _startTokenId()` times.
1163         unchecked {
1164             return _currentIndex - _burnCounter - _startTokenId();
1165         }
1166     }
1167 
1168     /**
1169      * @dev Returns the total amount of tokens minted in the contract.
1170      */
1171     function _totalMinted() internal view virtual returns (uint256) {
1172         // Counter underflow is impossible as `_currentIndex` does not decrement,
1173         // and it is initialized to `_startTokenId()`.
1174         unchecked {
1175             return _currentIndex - _startTokenId();
1176         }
1177     }
1178 
1179     /**
1180      * @dev Returns the total number of tokens burned.
1181      */
1182     function _totalBurned() internal view virtual returns (uint256) {
1183         return _burnCounter;
1184     }
1185 
1186     // =============================================================
1187     //                    ADDRESS DATA OPERATIONS
1188     // =============================================================
1189 
1190     /**
1191      * @dev Returns the number of tokens in `owner`'s account.
1192      */
1193     function balanceOf(address owner) public view virtual override returns (uint256) {
1194         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1195         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1196     }
1197 
1198     /**
1199      * Returns the number of tokens minted by `owner`.
1200      */
1201     function _numberMinted(address owner) internal view returns (uint256) {
1202         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1203     }
1204 
1205     /**
1206      * Returns the number of tokens burned by or on behalf of `owner`.
1207      */
1208     function _numberBurned(address owner) internal view returns (uint256) {
1209         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1210     }
1211 
1212     /**
1213      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1214      */
1215     function _getAux(address owner) internal view returns (uint64) {
1216         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1217     }
1218 
1219     /**
1220      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1221      * If there are multiple variables, please pack them into a uint64.
1222      */
1223     function _setAux(address owner, uint64 aux) internal virtual {
1224         uint256 packed = _packedAddressData[owner];
1225         uint256 auxCasted;
1226         // Cast `aux` with assembly to avoid redundant masking.
1227         assembly {
1228             auxCasted := aux
1229         }
1230         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1231         _packedAddressData[owner] = packed;
1232     }
1233 
1234     // =============================================================
1235     //                            IERC165
1236     // =============================================================
1237 
1238     /**
1239      * @dev Returns true if this contract implements the interface defined by
1240      * `interfaceId`. See the corresponding
1241      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1242      * to learn more about how these ids are created.
1243      *
1244      * This function call must use less than 30000 gas.
1245      */
1246     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1247         // The interface IDs are constants representing the first 4 bytes
1248         // of the XOR of all function selectors in the interface.
1249         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1250         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1251         return
1252             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1253             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1254             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1255     }
1256 
1257     // =============================================================
1258     //                        IERC721Metadata
1259     // =============================================================
1260 
1261     /**
1262      * @dev Returns the token collection name.
1263      */
1264     function name() public view virtual override returns (string memory) {
1265         return _name;
1266     }
1267 
1268     /**
1269      * @dev Returns the token collection symbol.
1270      */
1271     function symbol() public view virtual override returns (string memory) {
1272         return _symbol;
1273     }
1274 
1275     /**
1276      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1277      */
1278     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1279         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1280 
1281         string memory baseURI = _baseURI();
1282         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1283     }
1284 
1285     /**
1286      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1287      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1288      * by default, it can be overridden in child contracts.
1289      */
1290     function _baseURI() internal view virtual returns (string memory) {
1291         return '';
1292     }
1293 
1294     // =============================================================
1295     //                     OWNERSHIPS OPERATIONS
1296     // =============================================================
1297 
1298     /**
1299      * @dev Returns the owner of the `tokenId` token.
1300      *
1301      * Requirements:
1302      *
1303      * - `tokenId` must exist.
1304      */
1305     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1306         return address(uint160(_packedOwnershipOf(tokenId)));
1307     }
1308 
1309     /**
1310      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1311      * It gradually moves to O(1) as tokens get transferred around over time.
1312      */
1313     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1314         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1315     }
1316 
1317     /**
1318      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1319      */
1320     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1321         return _unpackedOwnership(_packedOwnerships[index]);
1322     }
1323 
1324     /**
1325      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1326      */
1327     function _initializeOwnershipAt(uint256 index) internal virtual {
1328         if (_packedOwnerships[index] == 0) {
1329             _packedOwnerships[index] = _packedOwnershipOf(index);
1330         }
1331     }
1332 
1333     /**
1334      * Returns the packed ownership data of `tokenId`.
1335      */
1336     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1337         uint256 curr = tokenId;
1338 
1339         unchecked {
1340             if (_startTokenId() <= curr)
1341                 if (curr < _currentIndex) {
1342                     uint256 packed = _packedOwnerships[curr];
1343                     // If not burned.
1344                     if (packed & _BITMASK_BURNED == 0) {
1345                         // Invariant:
1346                         // There will always be an initialized ownership slot
1347                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1348                         // before an unintialized ownership slot
1349                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1350                         // Hence, `curr` will not underflow.
1351                         //
1352                         // We can directly compare the packed value.
1353                         // If the address is zero, packed will be zero.
1354                         while (packed == 0) {
1355                             packed = _packedOwnerships[--curr];
1356                         }
1357                         return packed;
1358                     }
1359                 }
1360         }
1361         revert OwnerQueryForNonexistentToken();
1362     }
1363 
1364     /**
1365      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1366      */
1367     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1368         ownership.addr = address(uint160(packed));
1369         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1370         ownership.burned = packed & _BITMASK_BURNED != 0;
1371         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1372     }
1373 
1374     /**
1375      * @dev Packs ownership data into a single uint256.
1376      */
1377     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1378         assembly {
1379             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1380             owner := and(owner, _BITMASK_ADDRESS)
1381             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1382             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1383         }
1384     }
1385 
1386     /**
1387      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1388      */
1389     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1390         // For branchless setting of the `nextInitialized` flag.
1391         assembly {
1392             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1393             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1394         }
1395     }
1396 
1397     // =============================================================
1398     //                      APPROVAL OPERATIONS
1399     // =============================================================
1400 
1401     /**
1402      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1403      * The approval is cleared when the token is transferred.
1404      *
1405      * Only a single account can be approved at a time, so approving the
1406      * zero address clears previous approvals.
1407      *
1408      * Requirements:
1409      *
1410      * - The caller must own the token or be an approved operator.
1411      * - `tokenId` must exist.
1412      *
1413      * Emits an {Approval} event.
1414      */
1415     function approve(address to, uint256 tokenId) public payable virtual override {
1416         address owner = ownerOf(tokenId);
1417 
1418         if (_msgSenderERC721A() != owner)
1419             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1420                 revert ApprovalCallerNotOwnerNorApproved();
1421             }
1422 
1423         _tokenApprovals[tokenId].value = to;
1424         emit Approval(owner, to, tokenId);
1425     }
1426 
1427     /**
1428      * @dev Returns the account approved for `tokenId` token.
1429      *
1430      * Requirements:
1431      *
1432      * - `tokenId` must exist.
1433      */
1434     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1435         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1436 
1437         return _tokenApprovals[tokenId].value;
1438     }
1439 
1440     /**
1441      * @dev Approve or remove `operator` as an operator for the caller.
1442      * Operators can call {transferFrom} or {safeTransferFrom}
1443      * for any token owned by the caller.
1444      *
1445      * Requirements:
1446      *
1447      * - The `operator` cannot be the caller.
1448      *
1449      * Emits an {ApprovalForAll} event.
1450      */
1451     function setApprovalForAll(address operator, bool approved) public virtual override {
1452         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1453         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1454     }
1455 
1456     /**
1457      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1458      *
1459      * See {setApprovalForAll}.
1460      */
1461     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1462         return _operatorApprovals[owner][operator];
1463     }
1464 
1465     /**
1466      * @dev Returns whether `tokenId` exists.
1467      *
1468      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1469      *
1470      * Tokens start existing when they are minted. See {_mint}.
1471      */
1472     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1473         return
1474             _startTokenId() <= tokenId &&
1475             tokenId < _currentIndex && // If within bounds,
1476             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1477     }
1478 
1479     /**
1480      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1481      */
1482     function _isSenderApprovedOrOwner(
1483         address approvedAddress,
1484         address owner,
1485         address msgSender
1486     ) private pure returns (bool result) {
1487         assembly {
1488             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1489             owner := and(owner, _BITMASK_ADDRESS)
1490             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1491             msgSender := and(msgSender, _BITMASK_ADDRESS)
1492             // `msgSender == owner || msgSender == approvedAddress`.
1493             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1494         }
1495     }
1496 
1497     /**
1498      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1499      */
1500     function _getApprovedSlotAndAddress(uint256 tokenId)
1501         private
1502         view
1503         returns (uint256 approvedAddressSlot, address approvedAddress)
1504     {
1505         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1506         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1507         assembly {
1508             approvedAddressSlot := tokenApproval.slot
1509             approvedAddress := sload(approvedAddressSlot)
1510         }
1511     }
1512 
1513     // =============================================================
1514     //                      TRANSFER OPERATIONS
1515     // =============================================================
1516 
1517     /**
1518      * @dev Transfers `tokenId` from `from` to `to`.
1519      *
1520      * Requirements:
1521      *
1522      * - `from` cannot be the zero address.
1523      * - `to` cannot be the zero address.
1524      * - `tokenId` token must be owned by `from`.
1525      * - If the caller is not `from`, it must be approved to move this token
1526      * by either {approve} or {setApprovalForAll}.
1527      *
1528      * Emits a {Transfer} event.
1529      */
1530     function transferFrom(
1531         address from,
1532         address to,
1533         uint256 tokenId
1534     ) public payable virtual override {
1535         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1536 
1537         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1538 
1539         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1540 
1541         // The nested ifs save around 20+ gas over a compound boolean condition.
1542         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1543             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1544 
1545         if (to == address(0)) revert TransferToZeroAddress();
1546 
1547         _beforeTokenTransfers(from, to, tokenId, 1);
1548 
1549         // Clear approvals from the previous owner.
1550         assembly {
1551             if approvedAddress {
1552                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1553                 sstore(approvedAddressSlot, 0)
1554             }
1555         }
1556 
1557         // Underflow of the sender's balance is impossible because we check for
1558         // ownership above and the recipient's balance can't realistically overflow.
1559         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1560         unchecked {
1561             // We can directly increment and decrement the balances.
1562             --_packedAddressData[from]; // Updates: `balance -= 1`.
1563             ++_packedAddressData[to]; // Updates: `balance += 1`.
1564 
1565             // Updates:
1566             // - `address` to the next owner.
1567             // - `startTimestamp` to the timestamp of transfering.
1568             // - `burned` to `false`.
1569             // - `nextInitialized` to `true`.
1570             _packedOwnerships[tokenId] = _packOwnershipData(
1571                 to,
1572                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1573             );
1574 
1575             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1576             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1577                 uint256 nextTokenId = tokenId + 1;
1578                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1579                 if (_packedOwnerships[nextTokenId] == 0) {
1580                     // If the next slot is within bounds.
1581                     if (nextTokenId != _currentIndex) {
1582                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1583                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1584                     }
1585                 }
1586             }
1587         }
1588 
1589         emit Transfer(from, to, tokenId);
1590         _afterTokenTransfers(from, to, tokenId, 1);
1591     }
1592 
1593     /**
1594      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1595      */
1596     function safeTransferFrom(
1597         address from,
1598         address to,
1599         uint256 tokenId
1600     ) public payable virtual override {
1601         safeTransferFrom(from, to, tokenId, '');
1602     }
1603 
1604     /**
1605      * @dev Safely transfers `tokenId` token from `from` to `to`.
1606      *
1607      * Requirements:
1608      *
1609      * - `from` cannot be the zero address.
1610      * - `to` cannot be the zero address.
1611      * - `tokenId` token must exist and be owned by `from`.
1612      * - If the caller is not `from`, it must be approved to move this token
1613      * by either {approve} or {setApprovalForAll}.
1614      * - If `to` refers to a smart contract, it must implement
1615      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1616      *
1617      * Emits a {Transfer} event.
1618      */
1619     function safeTransferFrom(
1620         address from,
1621         address to,
1622         uint256 tokenId,
1623         bytes memory _data
1624     ) public payable virtual override {
1625         transferFrom(from, to, tokenId);
1626         if (to.code.length != 0)
1627             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1628                 revert TransferToNonERC721ReceiverImplementer();
1629             }
1630     }
1631 
1632     /**
1633      * @dev Hook that is called before a set of serially-ordered token IDs
1634      * are about to be transferred. This includes minting.
1635      * And also called before burning one token.
1636      *
1637      * `startTokenId` - the first token ID to be transferred.
1638      * `quantity` - the amount to be transferred.
1639      *
1640      * Calling conditions:
1641      *
1642      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1643      * transferred to `to`.
1644      * - When `from` is zero, `tokenId` will be minted for `to`.
1645      * - When `to` is zero, `tokenId` will be burned by `from`.
1646      * - `from` and `to` are never both zero.
1647      */
1648     function _beforeTokenTransfers(
1649         address from,
1650         address to,
1651         uint256 startTokenId,
1652         uint256 quantity
1653     ) internal virtual {}
1654 
1655     /**
1656      * @dev Hook that is called after a set of serially-ordered token IDs
1657      * have been transferred. This includes minting.
1658      * And also called after one token has been burned.
1659      *
1660      * `startTokenId` - the first token ID to be transferred.
1661      * `quantity` - the amount to be transferred.
1662      *
1663      * Calling conditions:
1664      *
1665      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1666      * transferred to `to`.
1667      * - When `from` is zero, `tokenId` has been minted for `to`.
1668      * - When `to` is zero, `tokenId` has been burned by `from`.
1669      * - `from` and `to` are never both zero.
1670      */
1671     function _afterTokenTransfers(
1672         address from,
1673         address to,
1674         uint256 startTokenId,
1675         uint256 quantity
1676     ) internal virtual {}
1677 
1678     /**
1679      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1680      *
1681      * `from` - Previous owner of the given token ID.
1682      * `to` - Target address that will receive the token.
1683      * `tokenId` - Token ID to be transferred.
1684      * `_data` - Optional data to send along with the call.
1685      *
1686      * Returns whether the call correctly returned the expected magic value.
1687      */
1688     function _checkContractOnERC721Received(
1689         address from,
1690         address to,
1691         uint256 tokenId,
1692         bytes memory _data
1693     ) private returns (bool) {
1694         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1695             bytes4 retval
1696         ) {
1697             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1698         } catch (bytes memory reason) {
1699             if (reason.length == 0) {
1700                 revert TransferToNonERC721ReceiverImplementer();
1701             } else {
1702                 assembly {
1703                     revert(add(32, reason), mload(reason))
1704                 }
1705             }
1706         }
1707     }
1708 
1709     // =============================================================
1710     //                        MINT OPERATIONS
1711     // =============================================================
1712 
1713     /**
1714      * @dev Mints `quantity` tokens and transfers them to `to`.
1715      *
1716      * Requirements:
1717      *
1718      * - `to` cannot be the zero address.
1719      * - `quantity` must be greater than 0.
1720      *
1721      * Emits a {Transfer} event for each mint.
1722      */
1723     function _mint(address to, uint256 quantity) internal virtual {
1724         uint256 startTokenId = _currentIndex;
1725         if (quantity == 0) revert MintZeroQuantity();
1726 
1727         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1728 
1729         // Overflows are incredibly unrealistic.
1730         // `balance` and `numberMinted` have a maximum limit of 2**64.
1731         // `tokenId` has a maximum limit of 2**256.
1732         unchecked {
1733             // Updates:
1734             // - `balance += quantity`.
1735             // - `numberMinted += quantity`.
1736             //
1737             // We can directly add to the `balance` and `numberMinted`.
1738             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1739 
1740             // Updates:
1741             // - `address` to the owner.
1742             // - `startTimestamp` to the timestamp of minting.
1743             // - `burned` to `false`.
1744             // - `nextInitialized` to `quantity == 1`.
1745             _packedOwnerships[startTokenId] = _packOwnershipData(
1746                 to,
1747                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1748             );
1749 
1750             uint256 toMasked;
1751             uint256 end = startTokenId + quantity;
1752 
1753             // Use assembly to loop and emit the `Transfer` event for gas savings.
1754             // The duplicated `log4` removes an extra check and reduces stack juggling.
1755             // The assembly, together with the surrounding Solidity code, have been
1756             // delicately arranged to nudge the compiler into producing optimized opcodes.
1757             assembly {
1758                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1759                 toMasked := and(to, _BITMASK_ADDRESS)
1760                 // Emit the `Transfer` event.
1761                 log4(
1762                     0, // Start of data (0, since no data).
1763                     0, // End of data (0, since no data).
1764                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1765                     0, // `address(0)`.
1766                     toMasked, // `to`.
1767                     startTokenId // `tokenId`.
1768                 )
1769 
1770                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1771                 // that overflows uint256 will make the loop run out of gas.
1772                 // The compiler will optimize the `iszero` away for performance.
1773                 for {
1774                     let tokenId := add(startTokenId, 1)
1775                 } iszero(eq(tokenId, end)) {
1776                     tokenId := add(tokenId, 1)
1777                 } {
1778                     // Emit the `Transfer` event. Similar to above.
1779                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1780                 }
1781             }
1782             if (toMasked == 0) revert MintToZeroAddress();
1783 
1784             _currentIndex = end;
1785         }
1786         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1787     }
1788 
1789     /**
1790      * @dev Mints `quantity` tokens and transfers them to `to`.
1791      *
1792      * This function is intended for efficient minting only during contract creation.
1793      *
1794      * It emits only one {ConsecutiveTransfer} as defined in
1795      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1796      * instead of a sequence of {Transfer} event(s).
1797      *
1798      * Calling this function outside of contract creation WILL make your contract
1799      * non-compliant with the ERC721 standard.
1800      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1801      * {ConsecutiveTransfer} event is only permissible during contract creation.
1802      *
1803      * Requirements:
1804      *
1805      * - `to` cannot be the zero address.
1806      * - `quantity` must be greater than 0.
1807      *
1808      * Emits a {ConsecutiveTransfer} event.
1809      */
1810     function _mintERC2309(address to, uint256 quantity) internal virtual {
1811         uint256 startTokenId = _currentIndex;
1812         if (to == address(0)) revert MintToZeroAddress();
1813         if (quantity == 0) revert MintZeroQuantity();
1814         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1815 
1816         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1817 
1818         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1819         unchecked {
1820             // Updates:
1821             // - `balance += quantity`.
1822             // - `numberMinted += quantity`.
1823             //
1824             // We can directly add to the `balance` and `numberMinted`.
1825             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1826 
1827             // Updates:
1828             // - `address` to the owner.
1829             // - `startTimestamp` to the timestamp of minting.
1830             // - `burned` to `false`.
1831             // - `nextInitialized` to `quantity == 1`.
1832             _packedOwnerships[startTokenId] = _packOwnershipData(
1833                 to,
1834                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1835             );
1836 
1837             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1838 
1839             _currentIndex = startTokenId + quantity;
1840         }
1841         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1842     }
1843 
1844     /**
1845      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1846      *
1847      * Requirements:
1848      *
1849      * - If `to` refers to a smart contract, it must implement
1850      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1851      * - `quantity` must be greater than 0.
1852      *
1853      * See {_mint}.
1854      *
1855      * Emits a {Transfer} event for each mint.
1856      */
1857     function _safeMint(
1858         address to,
1859         uint256 quantity,
1860         bytes memory _data
1861     ) internal virtual {
1862         _mint(to, quantity);
1863 
1864         unchecked {
1865             if (to.code.length != 0) {
1866                 uint256 end = _currentIndex;
1867                 uint256 index = end - quantity;
1868                 do {
1869                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1870                         revert TransferToNonERC721ReceiverImplementer();
1871                     }
1872                 } while (index < end);
1873                 // Reentrancy protection.
1874                 if (_currentIndex != end) revert();
1875             }
1876         }
1877     }
1878 
1879     /**
1880      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1881      */
1882     function _safeMint(address to, uint256 quantity) internal virtual {
1883         _safeMint(to, quantity, '');
1884     }
1885 
1886     // =============================================================
1887     //                        BURN OPERATIONS
1888     // =============================================================
1889 
1890     /**
1891      * @dev Equivalent to `_burn(tokenId, false)`.
1892      */
1893     function _burn(uint256 tokenId) internal virtual {
1894         _burn(tokenId, false);
1895     }
1896 
1897     /**
1898      * @dev Destroys `tokenId`.
1899      * The approval is cleared when the token is burned.
1900      *
1901      * Requirements:
1902      *
1903      * - `tokenId` must exist.
1904      *
1905      * Emits a {Transfer} event.
1906      */
1907     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1908         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1909 
1910         address from = address(uint160(prevOwnershipPacked));
1911 
1912         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1913 
1914         if (approvalCheck) {
1915             // The nested ifs save around 20+ gas over a compound boolean condition.
1916             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1917                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1918         }
1919 
1920         _beforeTokenTransfers(from, address(0), tokenId, 1);
1921 
1922         // Clear approvals from the previous owner.
1923         assembly {
1924             if approvedAddress {
1925                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1926                 sstore(approvedAddressSlot, 0)
1927             }
1928         }
1929 
1930         // Underflow of the sender's balance is impossible because we check for
1931         // ownership above and the recipient's balance can't realistically overflow.
1932         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1933         unchecked {
1934             // Updates:
1935             // - `balance -= 1`.
1936             // - `numberBurned += 1`.
1937             //
1938             // We can directly decrement the balance, and increment the number burned.
1939             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1940             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1941 
1942             // Updates:
1943             // - `address` to the last owner.
1944             // - `startTimestamp` to the timestamp of burning.
1945             // - `burned` to `true`.
1946             // - `nextInitialized` to `true`.
1947             _packedOwnerships[tokenId] = _packOwnershipData(
1948                 from,
1949                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1950             );
1951 
1952             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1953             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1954                 uint256 nextTokenId = tokenId + 1;
1955                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1956                 if (_packedOwnerships[nextTokenId] == 0) {
1957                     // If the next slot is within bounds.
1958                     if (nextTokenId != _currentIndex) {
1959                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1960                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1961                     }
1962                 }
1963             }
1964         }
1965 
1966         emit Transfer(from, address(0), tokenId);
1967         _afterTokenTransfers(from, address(0), tokenId, 1);
1968 
1969         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1970         unchecked {
1971             _burnCounter++;
1972         }
1973     }
1974 
1975     // =============================================================
1976     //                     EXTRA DATA OPERATIONS
1977     // =============================================================
1978 
1979     /**
1980      * @dev Directly sets the extra data for the ownership data `index`.
1981      */
1982     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1983         uint256 packed = _packedOwnerships[index];
1984         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1985         uint256 extraDataCasted;
1986         // Cast `extraData` with assembly to avoid redundant masking.
1987         assembly {
1988             extraDataCasted := extraData
1989         }
1990         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1991         _packedOwnerships[index] = packed;
1992     }
1993 
1994     /**
1995      * @dev Called during each token transfer to set the 24bit `extraData` field.
1996      * Intended to be overridden by the cosumer contract.
1997      *
1998      * `previousExtraData` - the value of `extraData` before transfer.
1999      *
2000      * Calling conditions:
2001      *
2002      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2003      * transferred to `to`.
2004      * - When `from` is zero, `tokenId` will be minted for `to`.
2005      * - When `to` is zero, `tokenId` will be burned by `from`.
2006      * - `from` and `to` are never both zero.
2007      */
2008     function _extraData(
2009         address from,
2010         address to,
2011         uint24 previousExtraData
2012     ) internal view virtual returns (uint24) {}
2013 
2014     /**
2015      * @dev Returns the next extra data for the packed ownership data.
2016      * The returned result is shifted into position.
2017      */
2018     function _nextExtraData(
2019         address from,
2020         address to,
2021         uint256 prevOwnershipPacked
2022     ) private view returns (uint256) {
2023         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2024         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2025     }
2026 
2027     // =============================================================
2028     //                       OTHER OPERATIONS
2029     // =============================================================
2030 
2031     /**
2032      * @dev Returns the message sender (defaults to `msg.sender`).
2033      *
2034      * If you are writing GSN compatible contracts, you need to override this function.
2035      */
2036     function _msgSenderERC721A() internal view virtual returns (address) {
2037         return msg.sender;
2038     }
2039 
2040     /**
2041      * @dev Converts a uint256 to its ASCII string decimal representation.
2042      */
2043     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2044         assembly {
2045             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2046             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2047             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2048             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2049             let m := add(mload(0x40), 0xa0)
2050             // Update the free memory pointer to allocate.
2051             mstore(0x40, m)
2052             // Assign the `str` to the end.
2053             str := sub(m, 0x20)
2054             // Zeroize the slot after the string.
2055             mstore(str, 0)
2056 
2057             // Cache the end of the memory to calculate the length later.
2058             let end := str
2059 
2060             // We write the string from rightmost digit to leftmost digit.
2061             // The following is essentially a do-while loop that also handles the zero case.
2062             // prettier-ignore
2063             for { let temp := value } 1 {} {
2064                 str := sub(str, 1)
2065                 // Write the character to the pointer.
2066                 // The ASCII index of the '0' character is 48.
2067                 mstore8(str, add(48, mod(temp, 10)))
2068                 // Keep dividing `temp` until zero.
2069                 temp := div(temp, 10)
2070                 // prettier-ignore
2071                 if iszero(temp) { break }
2072             }
2073 
2074             let length := sub(end, str)
2075             // Move the pointer 32 bytes leftwards to make room for the length.
2076             str := sub(str, 0x20)
2077             // Store the length.
2078             mstore(str, length)
2079         }
2080     }
2081 }
2082 
2083 /**
2084  * @title SafeERC20
2085  * @dev Wrappers around ERC20 operations that throw on failure (when the tBscen
2086  * contract returns false). TBscens that return no value (and instead revert or
2087  * throw on failure) are also supported, non-reverting calls are assumed to be
2088  * successful.
2089  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2090  * which allows you to call the safe operations as `tBscen.safeTransfer(...)`, etc.
2091  */
2092 library SafeERC20 {
2093     using SafeMath for uint256;
2094     using Address for address;
2095 
2096     function safeTransfer(IERC20 tBscen, address to, uint256 value) internal {
2097         _callOptionalReturn(tBscen, abi.encodeWithSelector(tBscen.transfer.selector, to, value));
2098     }
2099 
2100     function safeTransferFrom(IERC20 tBscen, address from, address to, uint256 value) internal {
2101         _callOptionalReturn(tBscen, abi.encodeWithSelector(tBscen.transferFrom.selector, from, to, value));
2102     }
2103 
2104     /**
2105      * @dev Deprecated. This function has issues similar to the ones found in
2106      * {IERC20-approve}, and its usage is discouraged.
2107      *
2108      * Whenever possible, use {safeIncreaseAllowance} and
2109      * {safeDecreaseAllowance} instead.
2110      */
2111     function safeApprove(IERC20 tBscen, address spender, uint256 value) internal {
2112         // safeApprove should only be called when setting an initial allowance,
2113         // or when resetting it to zero. To increase and decrease it, use
2114         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2115         // solhint-disable-next-line max-line-length
2116         require((value == 0) || (tBscen.allowance(address(this), spender) == 0),
2117             "SafeERC20: approve from non-zero to non-zero allowance"
2118         );
2119         _callOptionalReturn(tBscen, abi.encodeWithSelector(tBscen.approve.selector, spender, value));
2120     }
2121 
2122     function safeIncreaseAllowance(IERC20 tBscen, address spender, uint256 value) internal {
2123         uint256 newAllowance = tBscen.allowance(address(this), spender).add(value);
2124         _callOptionalReturn(tBscen, abi.encodeWithSelector(tBscen.approve.selector, spender, newAllowance));
2125     }
2126 
2127     function safeDecreaseAllowance(IERC20 tBscen, address spender, uint256 value) internal {
2128         uint256 newAllowance = tBscen.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
2129         _callOptionalReturn(tBscen, abi.encodeWithSelector(tBscen.approve.selector, spender, newAllowance));
2130     }
2131 
2132     /**
2133      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2134      * on the return value: the return value is optional (but if data is returned, it must not be false).
2135      * @param tBscen The tBscen targeted by the call.
2136      * @param data The call data (encoded using abi.encode or one of its variants).
2137      */
2138     function _callOptionalReturn(IERC20 tBscen, bytes memory data) private {
2139         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2140         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2141         // the target address contains contract code and also asserts for success in the low-level call.
2142 
2143         bytes memory returndata = address(tBscen).functionCall(data, "SafeERC20: low-level call failed");
2144         if (returndata.length > 0) { // Return data is optional
2145             // solhint-disable-next-line max-line-length
2146             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2147         }
2148     }
2149 }
2150 
2151 /**
2152  * @dev Interface of the ERC20 standard as defined in the EIP.
2153  */
2154 interface IERC20 {
2155     /**
2156      * @dev Returns the amount of tBscens in existence.
2157      */
2158     function totalSupply() external view returns (uint256);
2159 
2160     /**
2161      * @dev Returns the amount of tBscens owned by `account`.
2162      */
2163     function balanceOf(address account) external view returns (uint256);
2164 
2165     /**
2166      * @dev Moves `amount` tBscens from the caller's account to `recipient`.
2167      *
2168      * Returns a boolean value indicating whether the operation succeeded.
2169      *
2170      * Emits a {Transfer} event.
2171      */
2172     function transfer(address recipient, uint256 amount) external returns (bool);
2173 
2174     /**
2175      * @dev Returns the remaining number of tBscens that `spender` will be
2176      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2177      * zero by default.
2178      *
2179      * This value changes when {approve} or {transferFrom} are called.
2180      */
2181     function allowance(address owner, address spender) external view returns (uint256);
2182 
2183     /**
2184      * @dev Sets `amount` as the allowance of `spender` over the caller's tBscens.
2185      *
2186      * Returns a boolean value indicating whether the operation succeeded.
2187      *
2188      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2189      * that someone may use both the old and the new allowance by unfortunate
2190      * transaction ordering. One possible solution to mitigate this race
2191      * condition is to first reduce the spender's allowance to 0 and set the
2192      * desired value afterwards:
2193      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2194      *
2195      * Emits an {Approval} event.
2196      */
2197     function approve(address spender, uint256 amount) external returns (bool);
2198 
2199     /**
2200      * @dev Moves `amount` tBscens from `sender` to `recipient` using the
2201      * allowance mechanism. `amount` is then deducted from the caller's
2202      * allowance.
2203      *
2204      * Returns a boolean value indicating whether the operation succeeded.
2205      *
2206      * Emits a {Transfer} event.
2207      */
2208     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
2209 
2210     /**
2211      * @dev Emitted when `value` tBscens are moved from one account (`from`) to
2212      * another (`to`).
2213      *
2214      * Note that `value` may be zero.
2215      */
2216     event Transfer(address indexed from, address indexed to, uint256 value);
2217 
2218     /**
2219      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2220      * a call to {approve}. `value` is the new allowance.
2221      */
2222     event Approval(address indexed owner, address indexed spender, uint256 value);
2223 }
2224 
2225 interface IOperatorFilterRegistry {
2226     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2227     function register(address registrant) external;
2228     function registerAndSubscribe(address registrant, address subscription) external;
2229     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2230     function unregister(address addr) external;
2231     function updateOperator(address registrant, address operator, bool filtered) external;
2232     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2233     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2234     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2235     function subscribe(address registrant, address registrantToSubscribe) external;
2236     function unsubscribe(address registrant, bool copyExistingEntries) external;
2237     function subscriptionOf(address addr) external returns (address registrant);
2238     function subscribers(address registrant) external returns (address[] memory);
2239     function subscriberAt(address registrant, uint256 index) external returns (address);
2240     function copyEntriesOf(address registrant, address registrantToCopy) external;
2241     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2242     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2243     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2244     function filteredOperators(address addr) external returns (address[] memory);
2245     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2246     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2247     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2248     function isRegistered(address addr) external returns (bool);
2249     function codeHashOf(address addr) external returns (bytes32);
2250 }
2251 
2252 abstract contract OperatorFilterer {
2253     error OperatorNotAllowed(address operator);
2254 
2255     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2256         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
2257 
2258     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2259         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2260         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2261         // order for the modifier to filter addresses.
2262         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2263             if (subscribe) {
2264                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2265             } else {
2266                 if (subscriptionOrRegistrantToCopy != address(0)) {
2267                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2268                 } else {
2269                     OPERATOR_FILTER_REGISTRY.register(address(this));
2270                 }
2271             }
2272         }
2273     }
2274 
2275     modifier onlyAllowedOperator(address from) virtual {
2276         // Allow spending tokens from addresses with balance
2277         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2278         // from an EOA.
2279         if (from != msg.sender) {
2280             _checkFilterOperator(msg.sender);
2281         }
2282         _;
2283     }
2284 
2285     modifier onlyAllowedOperatorApproval(address operator) virtual {
2286         _checkFilterOperator(operator);
2287         _;
2288     }
2289 
2290     function _checkFilterOperator(address operator) internal view virtual {
2291         // Check registry code length to facilitate testing in environments without a deployed registry.
2292         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2293             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2294                 revert OperatorNotAllowed(operator);
2295             }
2296         }
2297     }
2298 }
2299 
2300 
2301 /**
2302  * @title  DefaultOperatorFilterer
2303  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2304  */
2305 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2306     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2307 
2308     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
2309 }
2310 
2311 
2312 
2313 interface ISatoSpecial {
2314     function mintSpecialNft(address to) external;
2315 }
2316 
2317 contract SATOsProof is ERC721A, Ownable, DefaultOperatorFilterer {
2318     using SafeMath for uint256;
2319     using Address for address;
2320     mapping(address => uint256) public _mintMap;
2321     mapping(address => uint256) public _mintWhitelistMap;
2322     mapping(address => uint256) public _mintP1Map;
2323     mapping(bytes32 => bool) public _msgHashMap;
2324 
2325 
2326     uint256 public _nftFreeRemaining;
2327     uint256 public _nftWhitelistRemaining;
2328     uint256 public _nftPayRemaining;
2329     uint256 public _nftPrice;
2330     uint256 public _nftWhitelistStartTime;
2331     uint256 public _nftP1StartTime;
2332     uint256 public _nftP2StartTime;
2333     uint256 public _nftEndTime;
2334     address public _validator;
2335     address public _specialNftAddress;
2336     bool private PAUSE = false;
2337     string public baseTokenURI;
2338 
2339     event ValidatorChangeEvent(address oldAddress, address newAddress);
2340     event SpecialNftAddressChangeEvent(address oldAddress, address newAddress);
2341     event PauseEvent(bool pause);
2342     event CreateNft(address indexed owner, uint256 startNum, uint256 endNum);
2343     event SetSalesEvent(uint256[] value, uint256 price, uint256 whitelistStartTime, uint256 p1StartTime, uint256 p2StartTime);
2344     event StakeNftEvent(address indexed staker, uint256[] tokenIDList, uint256 changeTime);
2345     constructor() ERC721A("SATOs Proof", "SATOs Proof"){
2346 
2347     }
2348 
2349     modifier nftIsOpen {
2350         require(!PAUSE, "Sales not open");
2351         _;
2352     }
2353 
2354     function _baseURI() internal view virtual override returns (string memory) {
2355         return baseTokenURI;
2356     }
2357 
2358     function setValidator(address validator) public onlyOwner {
2359         require(_validator != validator, "Validator is same");
2360         emit ValidatorChangeEvent(_validator, validator);
2361         _validator = validator;
2362     }
2363 
2364     function setSpecialNftAddress(address specialNftAddress) public onlyOwner {
2365         require(_specialNftAddress != specialNftAddress, "address is same");
2366         emit SpecialNftAddressChangeEvent(_specialNftAddress, specialNftAddress);
2367         _specialNftAddress = specialNftAddress;
2368     }
2369 
2370     function setSales(uint256[] memory remaining, uint256 price, uint256 whitelistStartTime, uint256 p1StartTime, uint256 p2StartTime, uint256 nftEndTime) public onlyOwner {
2371         require(remaining.length == 3, "Invalid remaining length");
2372         require(_nftWhitelistStartTime == 0, "Sales already started");
2373         _nftFreeRemaining = remaining[0];
2374         _nftWhitelistRemaining = remaining[1];
2375         _nftPayRemaining = remaining[2];
2376         _nftPrice = price;
2377         _nftWhitelistStartTime = whitelistStartTime;
2378         _nftP1StartTime = p1StartTime;
2379         _nftP2StartTime = p2StartTime;
2380         _nftEndTime = nftEndTime;
2381         emit SetSalesEvent(remaining, price, whitelistStartTime, p1StartTime, p2StartTime);
2382     }
2383 
2384     function setBaseURI(string memory baseURI) public onlyOwner {
2385         baseTokenURI = baseURI;
2386     }
2387     function mintByOwner(address _to, uint256 _value) public nftIsOpen onlyOwner{
2388         require(_nftFreeRemaining >= _value, "Not enough NFT");
2389         _nftFreeRemaining = _nftFreeRemaining.sub(_value);
2390         uint256 _startNum = _totalMinted();
2391         _mint(_to, _value);
2392         emit CreateNft(_to, _startNum, _startNum.add(_value));
2393     }
2394     function mintByWhitelist(address _to, uint256 _timestamp,uint256 amount,bytes memory _signature) public payable nftIsOpen{
2395         require(msg.sender == tx.origin, "only origin");
2396         require(_to == msg.sender, "Mint to must be msg.sender");
2397         require(_mintWhitelistMap[_to] + amount <= 2, "Mint to address has minted");
2398         require(block.timestamp >= _nftWhitelistStartTime && block.timestamp < _nftP1StartTime, "NFT Whitelist not start or pass time");
2399         bytes32 msgHash = keccak256(abi.encode(_to, amount, _timestamp));
2400         require(!_msgHashMap[msgHash], "Already used");
2401         _msgHashMap[msgHash] = true;
2402         address signerOwner = signatureWallet(_to, amount, _timestamp,_signature);
2403         require(_nftWhitelistRemaining >= amount, "NFT Whitelist sold out");
2404         require(signerOwner == _validator, "Not authorized to mint");
2405         _nftWhitelistRemaining = _nftWhitelistRemaining.sub(amount);
2406         _nftFreeRemaining = _nftFreeRemaining.sub(amount);
2407         _mintWhitelistMap[_to] += amount;
2408         uint256 _startNum = _totalMinted();
2409         _mint(_to, amount);
2410         emit CreateNft(_to, _startNum, _startNum.add(amount));
2411     }
2412 
2413     function mintByP1(address _to, uint256 amount) public payable nftIsOpen{
2414         require(msg.sender == tx.origin, "only origin");
2415         require(block.timestamp >= _nftP1StartTime && block.timestamp < _nftP2StartTime, "NFT P1 not start");
2416         require(_nftFreeRemaining >= amount, "NFT free sold out");
2417         _nftFreeRemaining = _nftFreeRemaining.sub(amount);
2418         require(_to == msg.sender, "Mint to must be msg.sender");
2419         require(_mintP1Map[_to] + amount <= 2, "Mint to address has minted");
2420         _mintP1Map[_to] += amount;
2421         uint256 _startNum = _totalMinted();
2422         _mint(_to, amount);
2423         emit CreateNft(_to, _startNum, _startNum.add(amount));
2424     }
2425 
2426     function mint(address _to, uint256 amount) public payable nftIsOpen{
2427         require(msg.sender == tx.origin, "only origin");
2428         require(_to == msg.sender, "Mint to must be msg.sender");
2429         require(block.timestamp >= _nftP2StartTime && block.timestamp < _nftEndTime, "NFT P2 not start or pass time");
2430         require(msg.value == _nftPrice * amount, "value error");
2431         require(_nftPayRemaining >= amount, "NFT sold out");
2432         uint256 _userAlreadyMinted = _mintMap[_to] + _mintP1Map[_to] + _mintWhitelistMap[_to];
2433         require(_userAlreadyMinted + amount <= 4, "Mint to address has minted");
2434         _nftPayRemaining = _nftPayRemaining.sub(amount);
2435         _mintMap[_to]+= amount;
2436         uint256 _startNum = _totalMinted();
2437         _mint(_to, amount);
2438         emit CreateNft(_to, _startNum, _startNum.add(amount));
2439     }
2440 
2441     function signatureWallet(address to, uint256 amount,uint256 _timestamp,bytes memory _signature) public pure returns (address){
2442         return ECDSA.recover(keccak256(abi.encode(to, amount, _timestamp)), _signature);
2443     }
2444     
2445     function mintSpecialNft(uint256[] memory tokenIDList) public{
2446         require(_specialNftAddress != address(0), "specialNftAddress is zero");
2447         require(tokenIDList.length == 4, "tokenIDList length must 4");
2448         for (uint256 i = 0; i < tokenIDList.length; i++) {
2449             uint256 _tokensId = tokenIDList[i];
2450             require(ownerOf(_tokensId) == msg.sender, "not owner");
2451             _burn(_tokensId);
2452         }
2453         ISatoSpecial(_specialNftAddress).mintSpecialNft(msg.sender);
2454         emit StakeNftEvent(_msgSender(), tokenIDList, block.timestamp);
2455     }
2456 
2457 
2458     function setPause(bool _pause) public onlyOwner{
2459         PAUSE = _pause;
2460         emit PauseEvent(PAUSE);
2461     }
2462     
2463     function withDrawAll(address payable to) public onlyOwner{
2464         (bool success, ) = to.call{value: address(this).balance}("");
2465         require(success, "Transfer failed.");
2466     }
2467 
2468     /**
2469      * @dev See {IERC721-safeTransferFrom}.
2470      */
2471     function safeTransferFrom(
2472         address from,
2473         address to,
2474         uint256 tokenId,
2475         bytes memory _data
2476     ) public virtual override payable onlyAllowedOperator(from){
2477         super.safeTransferFrom(from, to, tokenId, _data);
2478     }
2479 
2480     /**
2481      * @dev See {IERC721-safeTransferFrom}.
2482      */
2483     function safeTransferFrom(
2484         address from,
2485         address to,
2486         uint256 tokenId
2487     ) public virtual override payable onlyAllowedOperator(from){
2488         super.safeTransferFrom(from, to, tokenId, "");
2489     }
2490 
2491    /**
2492      * @dev See {IERC721-transferFrom}.
2493      */
2494     function transferFrom(
2495         address from,
2496         address to,
2497         uint256 tokenId
2498     ) public virtual override payable onlyAllowedOperator(from){
2499         super.transferFrom(from, to, tokenId);
2500     }
2501     /**
2502      * @dev See {IERC721-approve}.
2503      */
2504     function approve(address to, uint256 tokenId) public virtual override payable onlyAllowedOperatorApproval(to){
2505         super.approve(to, tokenId);
2506     }
2507     /**
2508      * @dev See {IERC721-setApprovalForAll}.
2509      */
2510     function setApprovalForAll(address operator, bool approved) public virtual override onlyAllowedOperatorApproval(operator){
2511         super.setApprovalForAll(operator, approved);
2512     }
2513 }