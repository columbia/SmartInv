1 pragma solidity ^0.8.4;
2 
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
20     unchecked {
21         uint256 c = a + b;
22         if (c < a) return (false, 0);
23         return (true, c);
24     }
25     }
26 
27     /**
28      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33     unchecked {
34         if (b > a) return (false, 0);
35         return (true, a - b);
36     }
37     }
38 
39     /**
40      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45     unchecked {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49         if (a == 0) return (true, 0);
50         uint256 c = a * b;
51         if (c / a != b) return (false, 0);
52         return (true, c);
53     }
54     }
55 
56     /**
57      * @dev Returns the division of two unsigned integers, with a division by zero flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62     unchecked {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66     }
67 
68     /**
69      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74     unchecked {
75         if (b == 0) return (false, 0);
76         return (true, a % b);
77     }
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
170     unchecked {
171         require(b <= a, errorMessage);
172         return a - b;
173     }
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
193     unchecked {
194         require(b > 0, errorMessage);
195         return a / b;
196     }
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
219     unchecked {
220         require(b > 0, errorMessage);
221         return a % b;
222     }
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
477         (bool success,) = recipient.call{value : amount}("");
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
551         (bool success, bytes memory returndata) = target.call{value : value}(data);
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
1081     0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
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
1163     unchecked {
1164         return _currentIndex - _burnCounter - _startTokenId();
1165     }
1166     }
1167 
1168     /**
1169      * @dev Returns the total amount of tokens minted in the contract.
1170      */
1171     function _totalMinted() internal view virtual returns (uint256) {
1172         // Counter underflow is impossible as `_currentIndex` does not decrement,
1173         // and it is initialized to `_startTokenId()`.
1174     unchecked {
1175         return _currentIndex - _startTokenId();
1176     }
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
1252         interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1253         interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1254         interfaceId == 0x5b5e139f;
1255         // ERC165 interface ID for ERC721Metadata.
1256     }
1257 
1258     // =============================================================
1259     //                        IERC721Metadata
1260     // =============================================================
1261 
1262     /**
1263      * @dev Returns the token collection name.
1264      */
1265     function name() public view virtual override returns (string memory) {
1266         return _name;
1267     }
1268 
1269     /**
1270      * @dev Returns the token collection symbol.
1271      */
1272     function symbol() public view virtual override returns (string memory) {
1273         return _symbol;
1274     }
1275 
1276     /**
1277      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1278      */
1279     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1280         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1281 
1282         string memory baseURI = _baseURI();
1283         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1284     }
1285 
1286     /**
1287      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1288      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1289      * by default, it can be overridden in child contracts.
1290      */
1291     function _baseURI() internal view virtual returns (string memory) {
1292         return '';
1293     }
1294 
1295     // =============================================================
1296     //                     OWNERSHIPS OPERATIONS
1297     // =============================================================
1298 
1299     /**
1300      * @dev Returns the owner of the `tokenId` token.
1301      *
1302      * Requirements:
1303      *
1304      * - `tokenId` must exist.
1305      */
1306     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1307         return address(uint160(_packedOwnershipOf(tokenId)));
1308     }
1309 
1310     /**
1311      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1312      * It gradually moves to O(1) as tokens get transferred around over time.
1313      */
1314     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1315         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1316     }
1317 
1318     /**
1319      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1320      */
1321     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1322         return _unpackedOwnership(_packedOwnerships[index]);
1323     }
1324 
1325     /**
1326      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1327      */
1328     function _initializeOwnershipAt(uint256 index) internal virtual {
1329         if (_packedOwnerships[index] == 0) {
1330             _packedOwnerships[index] = _packedOwnershipOf(index);
1331         }
1332     }
1333 
1334     /**
1335      * Returns the packed ownership data of `tokenId`.
1336      */
1337     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1338         uint256 curr = tokenId;
1339 
1340     unchecked {
1341         if (_startTokenId() <= curr)
1342             if (curr < _currentIndex) {
1343                 uint256 packed = _packedOwnerships[curr];
1344                 // If not burned.
1345                 if (packed & _BITMASK_BURNED == 0) {
1346                     // Invariant:
1347                     // There will always be an initialized ownership slot
1348                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1349                     // before an unintialized ownership slot
1350                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1351                     // Hence, `curr` will not underflow.
1352                     //
1353                     // We can directly compare the packed value.
1354                     // If the address is zero, packed will be zero.
1355                     while (packed == 0) {
1356                         packed = _packedOwnerships[--curr];
1357                     }
1358                     return packed;
1359                 }
1360             }
1361     }
1362         revert OwnerQueryForNonexistentToken();
1363     }
1364 
1365     /**
1366      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1367      */
1368     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1369         ownership.addr = address(uint160(packed));
1370         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1371         ownership.burned = packed & _BITMASK_BURNED != 0;
1372         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1373     }
1374 
1375     /**
1376      * @dev Packs ownership data into a single uint256.
1377      */
1378     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1379         assembly {
1380         // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1381             owner := and(owner, _BITMASK_ADDRESS)
1382         // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1383             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1384         }
1385     }
1386 
1387     /**
1388      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1389      */
1390     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1391         // For branchless setting of the `nextInitialized` flag.
1392         assembly {
1393         // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1394             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1395         }
1396     }
1397 
1398     // =============================================================
1399     //                      APPROVAL OPERATIONS
1400     // =============================================================
1401 
1402     /**
1403      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1404      * The approval is cleared when the token is transferred.
1405      *
1406      * Only a single account can be approved at a time, so approving the
1407      * zero address clears previous approvals.
1408      *
1409      * Requirements:
1410      *
1411      * - The caller must own the token or be an approved operator.
1412      * - `tokenId` must exist.
1413      *
1414      * Emits an {Approval} event.
1415      */
1416     function approve(address to, uint256 tokenId) public payable virtual override {
1417         address owner = ownerOf(tokenId);
1418 
1419         if (_msgSenderERC721A() != owner)
1420             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1421                 revert ApprovalCallerNotOwnerNorApproved();
1422             }
1423 
1424         _tokenApprovals[tokenId].value = to;
1425         emit Approval(owner, to, tokenId);
1426     }
1427 
1428     /**
1429      * @dev Returns the account approved for `tokenId` token.
1430      *
1431      * Requirements:
1432      *
1433      * - `tokenId` must exist.
1434      */
1435     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1436         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1437 
1438         return _tokenApprovals[tokenId].value;
1439     }
1440 
1441     /**
1442      * @dev Approve or remove `operator` as an operator for the caller.
1443      * Operators can call {transferFrom} or {safeTransferFrom}
1444      * for any token owned by the caller.
1445      *
1446      * Requirements:
1447      *
1448      * - The `operator` cannot be the caller.
1449      *
1450      * Emits an {ApprovalForAll} event.
1451      */
1452     function setApprovalForAll(address operator, bool approved) public virtual override {
1453         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1454         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1455     }
1456 
1457     /**
1458      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1459      *
1460      * See {setApprovalForAll}.
1461      */
1462     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1463         return _operatorApprovals[owner][operator];
1464     }
1465 
1466     /**
1467      * @dev Returns whether `tokenId` exists.
1468      *
1469      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1470      *
1471      * Tokens start existing when they are minted. See {_mint}.
1472      */
1473     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1474         return
1475         _startTokenId() <= tokenId &&
1476         tokenId < _currentIndex && // If within bounds,
1477         _packedOwnerships[tokenId] & _BITMASK_BURNED == 0;
1478         // and not burned.
1479     }
1480 
1481     /**
1482      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1483      */
1484     function _isSenderApprovedOrOwner(
1485         address approvedAddress,
1486         address owner,
1487         address msgSender
1488     ) private pure returns (bool result) {
1489         assembly {
1490         // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1491             owner := and(owner, _BITMASK_ADDRESS)
1492         // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1493             msgSender := and(msgSender, _BITMASK_ADDRESS)
1494         // `msgSender == owner || msgSender == approvedAddress`.
1495             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1496         }
1497     }
1498 
1499     /**
1500      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1501      */
1502     function _getApprovedSlotAndAddress(uint256 tokenId)
1503     private
1504     view
1505     returns (uint256 approvedAddressSlot, address approvedAddress)
1506     {
1507         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1508         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1509         assembly {
1510             approvedAddressSlot := tokenApproval.slot
1511             approvedAddress := sload(approvedAddressSlot)
1512         }
1513     }
1514 
1515     // =============================================================
1516     //                      TRANSFER OPERATIONS
1517     // =============================================================
1518 
1519     /**
1520      * @dev Transfers `tokenId` from `from` to `to`.
1521      *
1522      * Requirements:
1523      *
1524      * - `from` cannot be the zero address.
1525      * - `to` cannot be the zero address.
1526      * - `tokenId` token must be owned by `from`.
1527      * - If the caller is not `from`, it must be approved to move this token
1528      * by either {approve} or {setApprovalForAll}.
1529      *
1530      * Emits a {Transfer} event.
1531      */
1532     function transferFrom(
1533         address from,
1534         address to,
1535         uint256 tokenId
1536     ) public payable virtual override {
1537         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1538 
1539         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1540 
1541         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1542 
1543         // The nested ifs save around 20+ gas over a compound boolean condition.
1544         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1545             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1546 
1547         if (to == address(0)) revert TransferToZeroAddress();
1548 
1549         _beforeTokenTransfers(from, to, tokenId, 1);
1550 
1551         // Clear approvals from the previous owner.
1552         assembly {
1553             if approvedAddress {
1554             // This is equivalent to `delete _tokenApprovals[tokenId]`.
1555                 sstore(approvedAddressSlot, 0)
1556             }
1557         }
1558 
1559         // Underflow of the sender's balance is impossible because we check for
1560         // ownership above and the recipient's balance can't realistically overflow.
1561         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1562     unchecked {
1563         // We can directly increment and decrement the balances.
1564         --_packedAddressData[from];
1565         // Updates: `balance -= 1`.
1566         ++_packedAddressData[to];
1567         // Updates: `balance += 1`.
1568 
1569         // Updates:
1570         // - `address` to the next owner.
1571         // - `startTimestamp` to the timestamp of transfering.
1572         // - `burned` to `false`.
1573         // - `nextInitialized` to `true`.
1574         _packedOwnerships[tokenId] = _packOwnershipData(
1575             to,
1576             _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1577         );
1578 
1579         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1580         if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1581             uint256 nextTokenId = tokenId + 1;
1582             // If the next slot's address is zero and not burned (i.e. packed value is zero).
1583             if (_packedOwnerships[nextTokenId] == 0) {
1584                 // If the next slot is within bounds.
1585                 if (nextTokenId != _currentIndex) {
1586                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1587                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1588                 }
1589             }
1590         }
1591     }
1592 
1593         emit Transfer(from, to, tokenId);
1594         _afterTokenTransfers(from, to, tokenId, 1);
1595     }
1596 
1597     /**
1598      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1599      */
1600     function safeTransferFrom(
1601         address from,
1602         address to,
1603         uint256 tokenId
1604     ) public payable virtual override {
1605         safeTransferFrom(from, to, tokenId, '');
1606     }
1607 
1608     /**
1609      * @dev Safely transfers `tokenId` token from `from` to `to`.
1610      *
1611      * Requirements:
1612      *
1613      * - `from` cannot be the zero address.
1614      * - `to` cannot be the zero address.
1615      * - `tokenId` token must exist and be owned by `from`.
1616      * - If the caller is not `from`, it must be approved to move this token
1617      * by either {approve} or {setApprovalForAll}.
1618      * - If `to` refers to a smart contract, it must implement
1619      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function safeTransferFrom(
1624         address from,
1625         address to,
1626         uint256 tokenId,
1627         bytes memory _data
1628     ) public payable virtual override {
1629         transferFrom(from, to, tokenId);
1630         if (to.code.length != 0)
1631             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1632                 revert TransferToNonERC721ReceiverImplementer();
1633             }
1634     }
1635 
1636     /**
1637      * @dev Hook that is called before a set of serially-ordered token IDs
1638      * are about to be transferred. This includes minting.
1639      * And also called before burning one token.
1640      *
1641      * `startTokenId` - the first token ID to be transferred.
1642      * `quantity` - the amount to be transferred.
1643      *
1644      * Calling conditions:
1645      *
1646      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1647      * transferred to `to`.
1648      * - When `from` is zero, `tokenId` will be minted for `to`.
1649      * - When `to` is zero, `tokenId` will be burned by `from`.
1650      * - `from` and `to` are never both zero.
1651      */
1652     function _beforeTokenTransfers(
1653         address from,
1654         address to,
1655         uint256 startTokenId,
1656         uint256 quantity
1657     ) internal virtual {}
1658 
1659     /**
1660      * @dev Hook that is called after a set of serially-ordered token IDs
1661      * have been transferred. This includes minting.
1662      * And also called after one token has been burned.
1663      *
1664      * `startTokenId` - the first token ID to be transferred.
1665      * `quantity` - the amount to be transferred.
1666      *
1667      * Calling conditions:
1668      *
1669      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1670      * transferred to `to`.
1671      * - When `from` is zero, `tokenId` has been minted for `to`.
1672      * - When `to` is zero, `tokenId` has been burned by `from`.
1673      * - `from` and `to` are never both zero.
1674      */
1675     function _afterTokenTransfers(
1676         address from,
1677         address to,
1678         uint256 startTokenId,
1679         uint256 quantity
1680     ) internal virtual {}
1681 
1682     /**
1683      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1684      *
1685      * `from` - Previous owner of the given token ID.
1686      * `to` - Target address that will receive the token.
1687      * `tokenId` - Token ID to be transferred.
1688      * `_data` - Optional data to send along with the call.
1689      *
1690      * Returns whether the call correctly returned the expected magic value.
1691      */
1692     function _checkContractOnERC721Received(
1693         address from,
1694         address to,
1695         uint256 tokenId,
1696         bytes memory _data
1697     ) private returns (bool) {
1698         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1699             bytes4 retval
1700         ) {
1701             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1702         } catch (bytes memory reason) {
1703             if (reason.length == 0) {
1704                 revert TransferToNonERC721ReceiverImplementer();
1705             } else {
1706                 assembly {
1707                     revert(add(32, reason), mload(reason))
1708                 }
1709             }
1710         }
1711     }
1712 
1713     // =============================================================
1714     //                        MINT OPERATIONS
1715     // =============================================================
1716 
1717     /**
1718      * @dev Mints `quantity` tokens and transfers them to `to`.
1719      *
1720      * Requirements:
1721      *
1722      * - `to` cannot be the zero address.
1723      * - `quantity` must be greater than 0.
1724      *
1725      * Emits a {Transfer} event for each mint.
1726      */
1727     function _mint(address to, uint256 quantity) internal virtual {
1728         uint256 startTokenId = _currentIndex;
1729         if (quantity == 0) revert MintZeroQuantity();
1730 
1731         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1732 
1733         // Overflows are incredibly unrealistic.
1734         // `balance` and `numberMinted` have a maximum limit of 2**64.
1735         // `tokenId` has a maximum limit of 2**256.
1736     unchecked {
1737         // Updates:
1738         // - `balance += quantity`.
1739         // - `numberMinted += quantity`.
1740         //
1741         // We can directly add to the `balance` and `numberMinted`.
1742         _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1743 
1744         // Updates:
1745         // - `address` to the owner.
1746         // - `startTimestamp` to the timestamp of minting.
1747         // - `burned` to `false`.
1748         // - `nextInitialized` to `quantity == 1`.
1749         _packedOwnerships[startTokenId] = _packOwnershipData(
1750             to,
1751             _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1752         );
1753 
1754         uint256 toMasked;
1755         uint256 end = startTokenId + quantity;
1756 
1757         // Use assembly to loop and emit the `Transfer` event for gas savings.
1758         // The duplicated `log4` removes an extra check and reduces stack juggling.
1759         // The assembly, together with the surrounding Solidity code, have been
1760         // delicately arranged to nudge the compiler into producing optimized opcodes.
1761         assembly {
1762         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1763             toMasked := and(to, _BITMASK_ADDRESS)
1764         // Emit the `Transfer` event.
1765             log4(
1766             0, // Start of data (0, since no data).
1767             0, // End of data (0, since no data).
1768             _TRANSFER_EVENT_SIGNATURE, // Signature.
1769             0, // `address(0)`.
1770             toMasked, // `to`.
1771             startTokenId // `tokenId`.
1772             )
1773 
1774         // The `iszero(eq(,))` check ensures that large values of `quantity`
1775         // that overflows uint256 will make the loop run out of gas.
1776         // The compiler will optimize the `iszero` away for performance.
1777             for {
1778                 let tokenId := add(startTokenId, 1)
1779             } iszero(eq(tokenId, end)) {
1780                 tokenId := add(tokenId, 1)
1781             } {
1782             // Emit the `Transfer` event. Similar to above.
1783                 log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1784             }
1785         }
1786         if (toMasked == 0) revert MintToZeroAddress();
1787 
1788         _currentIndex = end;
1789     }
1790         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1791     }
1792 
1793     /**
1794      * @dev Mints `quantity` tokens and transfers them to `to`.
1795      *
1796      * This function is intended for efficient minting only during contract creation.
1797      *
1798      * It emits only one {ConsecutiveTransfer} as defined in
1799      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1800      * instead of a sequence of {Transfer} event(s).
1801      *
1802      * Calling this function outside of contract creation WILL make your contract
1803      * non-compliant with the ERC721 standard.
1804      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1805      * {ConsecutiveTransfer} event is only permissible during contract creation.
1806      *
1807      * Requirements:
1808      *
1809      * - `to` cannot be the zero address.
1810      * - `quantity` must be greater than 0.
1811      *
1812      * Emits a {ConsecutiveTransfer} event.
1813      */
1814     function _mintERC2309(address to, uint256 quantity) internal virtual {
1815         uint256 startTokenId = _currentIndex;
1816         if (to == address(0)) revert MintToZeroAddress();
1817         if (quantity == 0) revert MintZeroQuantity();
1818         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1819 
1820         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1821 
1822         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1823     unchecked {
1824         // Updates:
1825         // - `balance += quantity`.
1826         // - `numberMinted += quantity`.
1827         //
1828         // We can directly add to the `balance` and `numberMinted`.
1829         _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1830 
1831         // Updates:
1832         // - `address` to the owner.
1833         // - `startTimestamp` to the timestamp of minting.
1834         // - `burned` to `false`.
1835         // - `nextInitialized` to `quantity == 1`.
1836         _packedOwnerships[startTokenId] = _packOwnershipData(
1837             to,
1838             _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1839         );
1840 
1841         emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1842 
1843         _currentIndex = startTokenId + quantity;
1844     }
1845         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1846     }
1847 
1848     /**
1849      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1850      *
1851      * Requirements:
1852      *
1853      * - If `to` refers to a smart contract, it must implement
1854      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1855      * - `quantity` must be greater than 0.
1856      *
1857      * See {_mint}.
1858      *
1859      * Emits a {Transfer} event for each mint.
1860      */
1861     function _safeMint(
1862         address to,
1863         uint256 quantity,
1864         bytes memory _data
1865     ) internal virtual {
1866         _mint(to, quantity);
1867 
1868     unchecked {
1869         if (to.code.length != 0) {
1870             uint256 end = _currentIndex;
1871             uint256 index = end - quantity;
1872             do {
1873                 if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1874                     revert TransferToNonERC721ReceiverImplementer();
1875                 }
1876             }
1877             while (index < end);
1878             // Reentrancy protection.
1879             if (_currentIndex != end) revert();
1880         }
1881     }
1882     }
1883 
1884     /**
1885      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1886      */
1887     function _safeMint(address to, uint256 quantity) internal virtual {
1888         _safeMint(to, quantity, '');
1889     }
1890 
1891     // =============================================================
1892     //                        BURN OPERATIONS
1893     // =============================================================
1894 
1895     /**
1896      * @dev Equivalent to `_burn(tokenId, false)`.
1897      */
1898     function _burn(uint256 tokenId) internal virtual {
1899         _burn(tokenId, false);
1900     }
1901 
1902     /**
1903      * @dev Destroys `tokenId`.
1904      * The approval is cleared when the token is burned.
1905      *
1906      * Requirements:
1907      *
1908      * - `tokenId` must exist.
1909      *
1910      * Emits a {Transfer} event.
1911      */
1912     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1913         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1914 
1915         address from = address(uint160(prevOwnershipPacked));
1916 
1917         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1918 
1919         if (approvalCheck) {
1920             // The nested ifs save around 20+ gas over a compound boolean condition.
1921             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1922                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1923         }
1924 
1925         _beforeTokenTransfers(from, address(0), tokenId, 1);
1926 
1927         // Clear approvals from the previous owner.
1928         assembly {
1929             if approvedAddress {
1930             // This is equivalent to `delete _tokenApprovals[tokenId]`.
1931                 sstore(approvedAddressSlot, 0)
1932             }
1933         }
1934 
1935         // Underflow of the sender's balance is impossible because we check for
1936         // ownership above and the recipient's balance can't realistically overflow.
1937         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1938     unchecked {
1939         // Updates:
1940         // - `balance -= 1`.
1941         // - `numberBurned += 1`.
1942         //
1943         // We can directly decrement the balance, and increment the number burned.
1944         // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1945         _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1946 
1947         // Updates:
1948         // - `address` to the last owner.
1949         // - `startTimestamp` to the timestamp of burning.
1950         // - `burned` to `true`.
1951         // - `nextInitialized` to `true`.
1952         _packedOwnerships[tokenId] = _packOwnershipData(
1953             from,
1954             (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1955         );
1956 
1957         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1958         if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1959             uint256 nextTokenId = tokenId + 1;
1960             // If the next slot's address is zero and not burned (i.e. packed value is zero).
1961             if (_packedOwnerships[nextTokenId] == 0) {
1962                 // If the next slot is within bounds.
1963                 if (nextTokenId != _currentIndex) {
1964                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1965                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1966                 }
1967             }
1968         }
1969     }
1970 
1971         emit Transfer(from, address(0), tokenId);
1972         _afterTokenTransfers(from, address(0), tokenId, 1);
1973 
1974         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1975     unchecked {
1976         _burnCounter++;
1977     }
1978     }
1979 
1980     // =============================================================
1981     //                     EXTRA DATA OPERATIONS
1982     // =============================================================
1983 
1984     /**
1985      * @dev Directly sets the extra data for the ownership data `index`.
1986      */
1987     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1988         uint256 packed = _packedOwnerships[index];
1989         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1990         uint256 extraDataCasted;
1991         // Cast `extraData` with assembly to avoid redundant masking.
1992         assembly {
1993             extraDataCasted := extraData
1994         }
1995         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1996         _packedOwnerships[index] = packed;
1997     }
1998 
1999     /**
2000      * @dev Called during each token transfer to set the 24bit `extraData` field.
2001      * Intended to be overridden by the cosumer contract.
2002      *
2003      * `previousExtraData` - the value of `extraData` before transfer.
2004      *
2005      * Calling conditions:
2006      *
2007      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2008      * transferred to `to`.
2009      * - When `from` is zero, `tokenId` will be minted for `to`.
2010      * - When `to` is zero, `tokenId` will be burned by `from`.
2011      * - `from` and `to` are never both zero.
2012      */
2013     function _extraData(
2014         address from,
2015         address to,
2016         uint24 previousExtraData
2017     ) internal view virtual returns (uint24) {}
2018 
2019     /**
2020      * @dev Returns the next extra data for the packed ownership data.
2021      * The returned result is shifted into position.
2022      */
2023     function _nextExtraData(
2024         address from,
2025         address to,
2026         uint256 prevOwnershipPacked
2027     ) private view returns (uint256) {
2028         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2029         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2030     }
2031 
2032     // =============================================================
2033     //                       OTHER OPERATIONS
2034     // =============================================================
2035 
2036     /**
2037      * @dev Returns the message sender (defaults to `msg.sender`).
2038      *
2039      * If you are writing GSN compatible contracts, you need to override this function.
2040      */
2041     function _msgSenderERC721A() internal view virtual returns (address) {
2042         return msg.sender;
2043     }
2044 
2045     /**
2046      * @dev Converts a uint256 to its ASCII string decimal representation.
2047      */
2048     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2049         assembly {
2050         // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2051         // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2052         // We will need 1 word for the trailing zeros padding, 1 word for the length,
2053         // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2054             let m := add(mload(0x40), 0xa0)
2055         // Update the free memory pointer to allocate.
2056             mstore(0x40, m)
2057         // Assign the `str` to the end.
2058             str := sub(m, 0x20)
2059         // Zeroize the slot after the string.
2060             mstore(str, 0)
2061 
2062         // Cache the end of the memory to calculate the length later.
2063             let end := str
2064 
2065         // We write the string from rightmost digit to leftmost digit.
2066         // The following is essentially a do-while loop that also handles the zero case.
2067         // prettier-ignore
2068             for {let temp := value} 1 {} {
2069                 str := sub(str, 1)
2070             // Write the character to the pointer.
2071             // The ASCII index of the '0' character is 48.
2072                 mstore8(str, add(48, mod(temp, 10)))
2073             // Keep dividing `temp` until zero.
2074                 temp := div(temp, 10)
2075             // prettier-ignore
2076                 if iszero(temp) {break}
2077             }
2078 
2079             let length := sub(end, str)
2080         // Move the pointer 32 bytes leftwards to make room for the length.
2081             str := sub(str, 0x20)
2082         // Store the length.
2083             mstore(str, length)
2084         }
2085     }
2086 }
2087 
2088 /**
2089  * @title SafeERC20
2090  * @dev Wrappers around ERC20 operations that throw on failure (when the tBscen
2091  * contract returns false). TBscens that return no value (and instead revert or
2092  * throw on failure) are also supported, non-reverting calls are assumed to be
2093  * successful.
2094  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2095  * which allows you to call the safe operations as `tBscen.safeTransfer(...)`, etc.
2096  */
2097 library SafeERC20 {
2098     using SafeMath for uint256;
2099     using Address for address;
2100 
2101     function safeTransfer(IERC20 tBscen, address to, uint256 value) internal {
2102         _callOptionalReturn(tBscen, abi.encodeWithSelector(tBscen.transfer.selector, to, value));
2103     }
2104 
2105     function safeTransferFrom(IERC20 tBscen, address from, address to, uint256 value) internal {
2106         _callOptionalReturn(tBscen, abi.encodeWithSelector(tBscen.transferFrom.selector, from, to, value));
2107     }
2108 
2109     /**
2110      * @dev Deprecated. This function has issues similar to the ones found in
2111      * {IERC20-approve}, and its usage is discouraged.
2112      *
2113      * Whenever possible, use {safeIncreaseAllowance} and
2114      * {safeDecreaseAllowance} instead.
2115      */
2116     function safeApprove(IERC20 tBscen, address spender, uint256 value) internal {
2117         // safeApprove should only be called when setting an initial allowance,
2118         // or when resetting it to zero. To increase and decrease it, use
2119         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2120         // solhint-disable-next-line max-line-length
2121         require((value == 0) || (tBscen.allowance(address(this), spender) == 0),
2122             "SafeERC20: approve from non-zero to non-zero allowance"
2123         );
2124         _callOptionalReturn(tBscen, abi.encodeWithSelector(tBscen.approve.selector, spender, value));
2125     }
2126 
2127     function safeIncreaseAllowance(IERC20 tBscen, address spender, uint256 value) internal {
2128         uint256 newAllowance = tBscen.allowance(address(this), spender).add(value);
2129         _callOptionalReturn(tBscen, abi.encodeWithSelector(tBscen.approve.selector, spender, newAllowance));
2130     }
2131 
2132     function safeDecreaseAllowance(IERC20 tBscen, address spender, uint256 value) internal {
2133         uint256 newAllowance = tBscen.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
2134         _callOptionalReturn(tBscen, abi.encodeWithSelector(tBscen.approve.selector, spender, newAllowance));
2135     }
2136 
2137     /**
2138      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2139      * on the return value: the return value is optional (but if data is returned, it must not be false).
2140      * @param tBscen The tBscen targeted by the call.
2141      * @param data The call data (encoded using abi.encode or one of its variants).
2142      */
2143     function _callOptionalReturn(IERC20 tBscen, bytes memory data) private {
2144         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2145         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2146         // the target address contains contract code and also asserts for success in the low-level call.
2147 
2148         bytes memory returndata = address(tBscen).functionCall(data, "SafeERC20: low-level call failed");
2149         if (returndata.length > 0) {// Return data is optional
2150             // solhint-disable-next-line max-line-length
2151             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2152         }
2153     }
2154 }
2155 
2156 /**
2157  * @dev Interface of the ERC20 standard as defined in the EIP.
2158  */
2159 interface IERC20 {
2160     /**
2161      * @dev Returns the amount of tBscens in existence.
2162      */
2163     function totalSupply() external view returns (uint256);
2164 
2165     /**
2166      * @dev Returns the amount of tBscens owned by `account`.
2167      */
2168     function balanceOf(address account) external view returns (uint256);
2169 
2170     /**
2171      * @dev Moves `amount` tBscens from the caller's account to `recipient`.
2172      *
2173      * Returns a boolean value indicating whether the operation succeeded.
2174      *
2175      * Emits a {Transfer} event.
2176      */
2177     function transfer(address recipient, uint256 amount) external returns (bool);
2178 
2179     /**
2180      * @dev Returns the remaining number of tBscens that `spender` will be
2181      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2182      * zero by default.
2183      *
2184      * This value changes when {approve} or {transferFrom} are called.
2185      */
2186     function allowance(address owner, address spender) external view returns (uint256);
2187 
2188     /**
2189      * @dev Sets `amount` as the allowance of `spender` over the caller's tBscens.
2190      *
2191      * Returns a boolean value indicating whether the operation succeeded.
2192      *
2193      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2194      * that someone may use both the old and the new allowance by unfortunate
2195      * transaction ordering. One possible solution to mitigate this race
2196      * condition is to first reduce the spender's allowance to 0 and set the
2197      * desired value afterwards:
2198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2199      *
2200      * Emits an {Approval} event.
2201      */
2202     function approve(address spender, uint256 amount) external returns (bool);
2203 
2204     /**
2205      * @dev Moves `amount` tBscens from `sender` to `recipient` using the
2206      * allowance mechanism. `amount` is then deducted from the caller's
2207      * allowance.
2208      *
2209      * Returns a boolean value indicating whether the operation succeeded.
2210      *
2211      * Emits a {Transfer} event.
2212      */
2213     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
2214 
2215     /**
2216      * @dev Emitted when `value` tBscens are moved from one account (`from`) to
2217      * another (`to`).
2218      *
2219      * Note that `value` may be zero.
2220      */
2221     event Transfer(address indexed from, address indexed to, uint256 value);
2222 
2223     /**
2224      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2225      * a call to {approve}. `value` is the new allowance.
2226      */
2227     event Approval(address indexed owner, address indexed spender, uint256 value);
2228 }
2229 
2230 
2231 contract WhikoNFT_ERC721A is ERC721A, Ownable {
2232     using SafeMath for uint256;
2233     using Address for address;
2234     address private executorAddress;
2235     address private whitelistAddress;
2236     bool private PAUSE = false;
2237     string public baseTokenURI;
2238     mapping(uint256 => string) private _tokenURI;
2239     mapping(uint => mapping(address => bool)) public mintedNum;
2240     mapping(address => bool) private _blackMarketplaces;
2241     Stage[] private stageList;
2242     /* max mint nft quantity */
2243     uint256 public maxQuantity = 1;
2244 
2245     /* all mint total quantity */
2246     uint256 public maxTotalSupply = 0;
2247 
2248     /* open box time */
2249     uint256 public openBoxTime;
2250     string public openBoxBeforeTokenURI;
2251 
2252     struct Stage {
2253         /* The Stage start time */
2254         uint256 startTime;
2255         /* The Stage end time */
2256         uint256 endTime;
2257         /* The Stage max mint nft quantity */
2258         uint maxQuantity;
2259         /* The Stage remain mint nft quantity */
2260         uint mintedNum;
2261         /* The Stage nft sale price */
2262         uint256 price;
2263     }
2264 
2265     event PauseEvent(bool pause);
2266     /**
2267      * typ mint type 0 whitelist 1 normal
2268      * to to address
2269      * quantity current mint quantity
2270      * price purchase price
2271      */
2272     event NFTMintEvent(uint typ, uint256 token, address to, uint256 quantity, uint256 price);
2273 
2274     event StageEvent(uint typ, uint256 startTime, uint256 endTime, uint _maxQuantity, uint mintedNum, uint256 price);
2275 
2276     event UpdateStageEvent(uint typ, address to, uint mintedNum);
2277 
2278     event TokenURIEvent(uint256 token, string tokenURI);
2279 
2280     event ExecutorAddressEvent(address executorAddress);
2281 
2282     event WhitelistAddressEvent(address _whitelistAddress);
2283 
2284     event OpenBoxTimeEvent(uint256 openBoxTime);
2285 
2286     event WhiteListEvent(uint stage, address whiteListAddress, uint256 quantity);
2287     event WhiteListBatchEvent(uint stage, address[] whiteListAddress);
2288     event RemoveWhiteListEvent(uint stage, address whiteListAddress);
2289 
2290     event MaxQuantityEvent(uint256 _maxQuantity);
2291 
2292     event MaxTotalSupplyEvent(uint256 _maxTotalSupply);
2293 
2294     constructor(
2295         address _executorAddress,
2296         address _whitelistAddress,
2297         string memory _baseTokenURI,
2298         string memory _openBoxBeforeTokenURI,
2299         uint256 _maxTotalSupply,
2300         uint256 _openBoxTime
2301     ) ERC721A("Whiko NFT", "Whiko"){
2302         executorAddress = _executorAddress;
2303         whitelistAddress = _whitelistAddress;
2304         baseTokenURI = _baseTokenURI;
2305         openBoxBeforeTokenURI = _openBoxBeforeTokenURI;
2306         maxTotalSupply = _maxTotalSupply;
2307         openBoxTime = _openBoxTime;
2308     }
2309 
2310     modifier nftIsOpen {
2311         require(!PAUSE, "Sales has not open");
2312         _;
2313     }
2314 
2315     modifier stageOpen {
2316         require(stageList.length > 0, "Not stage set");
2317         _;
2318     }
2319 
2320     modifier onlyExecutor {
2321         require(executorAddress == _msgSender(), "caller is not the executor or ower");
2322         _;
2323     }
2324 
2325     function _baseURI() internal view virtual override returns (string memory) {
2326         return baseTokenURI;
2327     }
2328 
2329     /**
2330      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2331      */
2332     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2333         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2334         string memory baseURI = _baseURI();
2335         if (bytes(baseURI).length == 0) {
2336             return '';
2337         }
2338 
2339         if (openBoxTime == 0 || openBoxTime > block.timestamp) {
2340             if (bytes(openBoxBeforeTokenURI).length == 0) {
2341                 return '';
2342             }
2343             return string(abi.encodePacked(baseURI, openBoxBeforeTokenURI));
2344         } else {
2345             string memory token_uri = _tokenURI[tokenId];
2346             return string(abi.encodePacked(baseURI, token_uri));
2347         }
2348     }
2349 
2350     function setStage(uint stageType, uint256 startTime, uint256 endTime, uint _maxQuantity, uint256 price) public onlyExecutor {
2351         require(stageType > 0 && stageType < 5, "invalid type");
2352         require(startTime < endTime, "The Stage Start Time And Sale Time Must Be Less End Time");
2353         require(endTime > block.timestamp, "The Stage End Time Must Be More Current Time");
2354         require(_maxQuantity != 0, "The Stage quantity has not zero");
2355         uint stageNum = stageList.length;
2356         if (stageType >= stageNum) {
2357             for (uint i; i < stageType.sub(stageNum); i++) {
2358                 stageList.push(Stage(0, 0, 0, 0, 0));
2359             }
2360         }
2361         uint index = stageType.sub(1);
2362         Stage storage stage = stageList[index];
2363         stage.startTime = startTime;
2364         stage.endTime = endTime;
2365         stage.maxQuantity = _maxQuantity;
2366         stage.price = price;
2367         stageList[index] = stage;
2368         emit StageEvent(stageType, startTime, endTime, _maxQuantity, stage.mintedNum, price);
2369     }
2370 
2371     function getStage(uint stageType) public view onlyExecutor returns (uint _stageType, uint256 startTime, uint256 endTime, uint _maxQuantity, uint mintNum, uint256 price){
2372         require(stageType > 0, "invalid type");
2373         uint stageNum = stageList.length;
2374         if (stageType > stageNum) {
2375             return (0, 0, 0, 0, 0, 0);
2376         }
2377         Stage memory stage = stageList[stageType.sub(1)];
2378         return (stageType, stage.startTime, stage.endTime, stage.maxQuantity, stage.mintedNum, stage.price);
2379     }
2380 
2381     function getTokenURI(uint256 tokenId) public view onlyExecutor returns (string memory){
2382         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2383         return _tokenURI[tokenId];
2384     }
2385 
2386     function getExecutorAddress() public view returns (address _executorAddress){
2387         if (owner() != _msgSender()) {
2388             return address(0);
2389         }
2390         return executorAddress;
2391     }
2392 
2393     function getWhitelistAddress() public view returns (address _whitelistAddress){
2394         if (owner() != _msgSender()) {
2395             return address(0);
2396         }
2397         return whitelistAddress;
2398     }
2399 
2400     function setTokenURI(uint256 tokenId, string memory uri) public onlyExecutor {
2401         _tokenURI[tokenId] = uri;
2402         emit TokenURIEvent(tokenId, uri);
2403     }
2404 
2405     function setTokenURIBatch(uint256[] memory tokenIdList, string[] memory uriList) public onlyExecutor {
2406         require(tokenIdList.length != 0, "must not equal zero");
2407         require(tokenIdList.length == uriList.length, "invalid data length");
2408         require(tokenIdList.length <= 15, "data to large");
2409         for (uint i; i < tokenIdList.length; i++) {
2410             uint256 tokenId = tokenIdList[i];
2411             string memory uri = uriList[i];
2412             _tokenURI[tokenId] = uri;
2413         }
2414     }
2415 
2416     function setOpenBoxTime(uint256 _openBoxTime) public onlyExecutor {
2417         require(_openBoxTime > block.timestamp, "Open Box Time Must Be More Current Time");
2418         openBoxTime = _openBoxTime;
2419         emit OpenBoxTimeEvent(_openBoxTime);
2420     }
2421 
2422     function setMaxQuantity(uint256 _maxQuantity) public onlyExecutor {
2423         maxQuantity = _maxQuantity;
2424         emit MaxQuantityEvent(_maxQuantity);
2425     }
2426 
2427     function setExecutorAddress(address _executorAddress) public onlyOwner {
2428         executorAddress = _executorAddress;
2429         emit ExecutorAddressEvent(_executorAddress);
2430     }
2431 
2432     function setWhitelistAddress(address _whitelistAddress) public onlyOwner {
2433         whitelistAddress = _whitelistAddress;
2434         emit WhitelistAddressEvent(_whitelistAddress);
2435     }
2436 
2437     function executorMint(address to, uint256 quantity) public onlyExecutor nftIsOpen {
2438         require(msg.sender == tx.origin, "only origin");
2439         require(to == msg.sender, "The address of to cannot be the address of the caller");
2440         require(executorAddress == msg.sender, "The address of to cannot be the address of the executor");
2441 
2442         require(maxTotalSupply == 0 || totalSupply().add(quantity) < maxTotalSupply, "The total supply more than max");
2443 
2444         _mint(to, quantity);
2445         emit NFTMintEvent(0, _nextTokenId() - 1, to, quantity, 0);
2446     }
2447 
2448     function currentStage(address to) public view returns (uint _stage, bool _mint, uint256 _price){
2449         uint stageNum = stageList.length;
2450         uint256 currentTime = block.timestamp;
2451         for (uint i; i < stageNum; i++) {
2452             Stage memory stage = stageList[i];
2453             uint stageType = i.add(1);
2454             uint256 price = stage.price;
2455             // in stage range time
2456             if (currentTime >= stage.startTime && currentTime <= stage.endTime) {
2457                 if (to == address(0)) {
2458                     // has not login
2459                     return (stageType, false, price);
2460                 }
2461                 uint256 stageMintedNum = stage.mintedNum;
2462                 uint256 stageMaxQuantity = stage.maxQuantity;
2463                 if (stageMintedNum >= stageMaxQuantity) {
2464                     return (stageType, false, price);
2465                 }
2466                 return (stageType, !mintedNum[stageType][to], price);
2467             }
2468         }
2469         // The Stage has not exist
2470         return (0, false, 0);
2471     }
2472 
2473     function updateStage(uint stageType, address to, uint256 quantity, uint256 price) internal {
2474         require(stageType > 0 && stageType <= stageList.length, "The stage has not open");
2475         uint index = stageType.sub(1);
2476         Stage memory stage = stageList[index];
2477 
2478         uint256 startTime = stage.startTime;
2479         uint256 endTime = stage.endTime;
2480 
2481         require(startTime < block.timestamp && block.timestamp < endTime, "Don't this stage");
2482 
2483         uint256 stagePrice = stage.price;
2484         require(price != 0 && price >= stagePrice, "The price error");
2485 
2486         uint256 stageMintedNum = stage.mintedNum;
2487         uint256 stageMaxQuantity = stage.maxQuantity;
2488         require(stageMintedNum.add(quantity) <= stageMaxQuantity, "Minted more than max quantity in stage");
2489 
2490         require(quantity.mul(price) <= msg.value, "value error");
2491 
2492         Stage storage _stage = stageList[index];
2493         _stage.mintedNum = stageMintedNum.add(quantity);
2494         stageList[index] = _stage;
2495         emit UpdateStageEvent(stageType, to, _stage.mintedNum);
2496     }
2497 
2498     function mint(uint stageType, address to, uint256 quantity, uint256 price, uint256 _timestamp, bytes memory _signature) public payable nftIsOpen stageOpen {
2499         require(msg.sender == tx.origin, "only origin");
2500         require(to == msg.sender, "The address of to cannot be the address of the caller");
2501 
2502         address signerOwner = signatureMint(stageType, to, quantity, price, _timestamp, _signature);
2503         require(signerOwner == whitelistAddress, "signer is not the executor");
2504 
2505         require(_timestamp > block.timestamp, "The sign be overdue");
2506 
2507         require(maxQuantity == 0 || maxQuantity >= quantity, "This max quantity less current request quantity");
2508         require(maxTotalSupply == 0 || totalSupply().add(quantity) < maxTotalSupply, "The total supply more than max");
2509         require(!mintedNum[stageType][to], "The address has minted in stage");
2510         updateStage(stageType, to, quantity, price);
2511         mintedNum[stageType][to] = true;
2512         _mint(to, quantity);
2513         emit NFTMintEvent(stageType, _nextTokenId() - 1, to, quantity, price);
2514     }
2515 
2516     function signatureMint(uint stageType, address to, uint256 quantity, uint256 price, uint256 _timestamp, bytes memory _signature) public pure returns (address){
2517         return ECDSA.recover(keccak256(abi.encode(stageType, to, quantity, price, _timestamp)), _signature);
2518     }
2519 
2520     /**
2521      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2522      * The approval is cleared when the token is transferred.
2523      *
2524      * Only a single account can be approved at a time, so approving the
2525      * zero address clears previous approvals.
2526      *
2527      * Requirements:
2528      *
2529      * - The caller must own the token or be an approved operator.
2530      * - `tokenId` must exist.
2531      *
2532      * Emits an {Approval} event.
2533      */
2534     function approve(address to, uint256 tokenId) public payable virtual override {
2535         require(_blackMarketplaces[to] == false, "Invalid Marketplace");
2536         super.approve(to, tokenId);
2537     }
2538 
2539     /**
2540      * @dev Approve or remove `operator` as an operator for the caller.
2541      * Operators can call {transferFrom} or {safeTransferFrom}
2542      * for any token owned by the caller.
2543      *
2544      * Requirements:
2545      *
2546      * - The `operator` cannot be the caller.
2547      *
2548      * Emits an {ApprovalForAll} event.
2549      */
2550     function setApprovalForAll(address operator, bool approved) public virtual override {
2551         require(_blackMarketplaces[operator] == false, "Invalid Marketplace");
2552         super.setApprovalForAll(operator, approved);
2553     }
2554 
2555     function setBlackMarketplaces(address operator, bool approved) public onlyExecutor {
2556         _blackMarketplaces[operator] = approved;
2557     }
2558 
2559     function isBlackMarketplaces(address operator) public view onlyExecutor returns (bool){
2560         return _blackMarketplaces[operator];
2561     }
2562 
2563     function setPause(bool _pause) public onlyOwner {
2564         PAUSE = _pause;
2565         emit PauseEvent(PAUSE);
2566     }
2567 
2568     function withDrawAll(address payable to) public onlyOwner {
2569         (bool success,) = to.call{gas : 21000, value : address(this).balance}("");
2570         require(success, "Transfer failed.");
2571     }
2572 
2573 }