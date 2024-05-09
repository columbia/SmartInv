1 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
9  *
10  * These functions can be used to verify that a message was signed by the holder
11  * of the private keys of a given address.
12  */
13 library ECDSA {
14     enum RecoverError {
15         NoError,
16         InvalidSignature,
17         InvalidSignatureLength,
18         InvalidSignatureS,
19         InvalidSignatureV
20     }
21 
22     function _throwError(RecoverError error) private pure {
23         if (error == RecoverError.NoError) {
24             return; // no error: do nothing
25         } else if (error == RecoverError.InvalidSignature) {
26             revert("ECDSA: invalid signature");
27         } else if (error == RecoverError.InvalidSignatureLength) {
28             revert("ECDSA: invalid signature length");
29         } else if (error == RecoverError.InvalidSignatureS) {
30             revert("ECDSA: invalid signature 's' value");
31         } else if (error == RecoverError.InvalidSignatureV) {
32             revert("ECDSA: invalid signature 'v' value");
33         }
34     }
35 
36     /**
37      * @dev Returns the address that signed a hashed message (`hash`) with
38      * `signature` or error string. This address can then be used for verification purposes.
39      *
40      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
41      * this function rejects them by requiring the `s` value to be in the lower
42      * half order, and the `v` value to be either 27 or 28.
43      *
44      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
45      * verification to be secure: it is possible to craft signatures that
46      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
47      * this is by receiving a hash of the original message (which may otherwise
48      * be too long), and then calling {toEthSignedMessageHash} on it.
49      *
50      * Documentation for signature generation:
51      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
52      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
53      *
54      * _Available since v4.3._
55      */
56     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
57         // Check the signature length
58         // - case 65: r,s,v signature (standard)
59         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
60         if (signature.length == 65) {
61             bytes32 r;
62             bytes32 s;
63             uint8 v;
64             // ecrecover takes the signature parameters, and the only way to get them
65             // currently is to use assembly.
66             assembly {
67                 r := mload(add(signature, 0x20))
68                 s := mload(add(signature, 0x40))
69                 v := byte(0, mload(add(signature, 0x60)))
70             }
71             return tryRecover(hash, v, r, s);
72         } else if (signature.length == 64) {
73             bytes32 r;
74             bytes32 vs;
75             // ecrecover takes the signature parameters, and the only way to get them
76             // currently is to use assembly.
77             assembly {
78                 r := mload(add(signature, 0x20))
79                 vs := mload(add(signature, 0x40))
80             }
81             return tryRecover(hash, r, vs);
82         } else {
83             return (address(0), RecoverError.InvalidSignatureLength);
84         }
85     }
86 
87     /**
88      * @dev Returns the address that signed a hashed message (`hash`) with
89      * `signature`. This address can then be used for verification purposes.
90      *
91      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
92      * this function rejects them by requiring the `s` value to be in the lower
93      * half order, and the `v` value to be either 27 or 28.
94      *
95      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
96      * verification to be secure: it is possible to craft signatures that
97      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
98      * this is by receiving a hash of the original message (which may otherwise
99      * be too long), and then calling {toEthSignedMessageHash} on it.
100      */
101     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
102         (address recovered, RecoverError error) = tryRecover(hash, signature);
103         _throwError(error);
104         return recovered;
105     }
106 
107     /**
108      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
109      *
110      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
111      *
112      * _Available since v4.3._
113      */
114     function tryRecover(
115         bytes32 hash,
116         bytes32 r,
117         bytes32 vs
118     ) internal pure returns (address, RecoverError) {
119         bytes32 s;
120         uint8 v;
121         assembly {
122             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
123             v := add(shr(255, vs), 27)
124         }
125         return tryRecover(hash, v, r, s);
126     }
127 
128     /**
129      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
130      *
131      * _Available since v4.2._
132      */
133     function recover(
134         bytes32 hash,
135         bytes32 r,
136         bytes32 vs
137     ) internal pure returns (address) {
138         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
139         _throwError(error);
140         return recovered;
141     }
142 
143     /**
144      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
145      * `r` and `s` signature fields separately.
146      *
147      * _Available since v4.3._
148      */
149     function tryRecover(
150         bytes32 hash,
151         uint8 v,
152         bytes32 r,
153         bytes32 s
154     ) internal pure returns (address, RecoverError) {
155         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
156         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
157         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
158         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
159         //
160         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
161         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
162         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
163         // these malleable signatures as well.
164         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
165             return (address(0), RecoverError.InvalidSignatureS);
166         }
167         if (v != 27 && v != 28) {
168             return (address(0), RecoverError.InvalidSignatureV);
169         }
170 
171         // If the signature is valid (and not malleable), return the signer address
172         address signer = ecrecover(hash, v, r, s);
173         if (signer == address(0)) {
174             return (address(0), RecoverError.InvalidSignature);
175         }
176 
177         return (signer, RecoverError.NoError);
178     }
179 
180     /**
181      * @dev Overload of {ECDSA-recover} that receives the `v`,
182      * `r` and `s` signature fields separately.
183      */
184     function recover(
185         bytes32 hash,
186         uint8 v,
187         bytes32 r,
188         bytes32 s
189     ) internal pure returns (address) {
190         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
191         _throwError(error);
192         return recovered;
193     }
194 
195     /**
196      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
197      * produces hash corresponding to the one signed with the
198      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
199      * JSON-RPC method as part of EIP-191.
200      *
201      * See {recover}.
202      */
203     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
204         // 32 is the length in bytes of hash,
205         // enforced by the type signature above
206         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
207     }
208 
209     /**
210      * @dev Returns an Ethereum Signed Typed Data, created from a
211      * `domainSeparator` and a `structHash`. This produces hash corresponding
212      * to the one signed with the
213      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
214      * JSON-RPC method as part of EIP-712.
215      *
216      * See {recover}.
217      */
218     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
219         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
220     }
221 }
222 
223 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
224 
225 
226 
227 pragma solidity ^0.8.0;
228 
229 // CAUTION
230 // This version of SafeMath should only be used with Solidity 0.8 or later,
231 // because it relies on the compiler's built in overflow checks.
232 
233 /**
234  * @dev Wrappers over Solidity's arithmetic operations.
235  *
236  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
237  * now has built in overflow checking.
238  */
239 library SafeMath {
240     /**
241      * @dev Returns the addition of two unsigned integers, with an overflow flag.
242      *
243      * _Available since v3.4._
244      */
245     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
246         unchecked {
247             uint256 c = a + b;
248             if (c < a) return (false, 0);
249             return (true, c);
250         }
251     }
252 
253     /**
254      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
255      *
256      * _Available since v3.4._
257      */
258     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
259         unchecked {
260             if (b > a) return (false, 0);
261             return (true, a - b);
262         }
263     }
264 
265     /**
266      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
267      *
268      * _Available since v3.4._
269      */
270     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         unchecked {
272             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
273             // benefit is lost if 'b' is also tested.
274             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
275             if (a == 0) return (true, 0);
276             uint256 c = a * b;
277             if (c / a != b) return (false, 0);
278             return (true, c);
279         }
280     }
281 
282     /**
283      * @dev Returns the division of two unsigned integers, with a division by zero flag.
284      *
285      * _Available since v3.4._
286      */
287     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
288         unchecked {
289             if (b == 0) return (false, 0);
290             return (true, a / b);
291         }
292     }
293 
294     /**
295      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
296      *
297      * _Available since v3.4._
298      */
299     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
300         unchecked {
301             if (b == 0) return (false, 0);
302             return (true, a % b);
303         }
304     }
305 
306     /**
307      * @dev Returns the addition of two unsigned integers, reverting on
308      * overflow.
309      *
310      * Counterpart to Solidity's `+` operator.
311      *
312      * Requirements:
313      *
314      * - Addition cannot overflow.
315      */
316     function add(uint256 a, uint256 b) internal pure returns (uint256) {
317         return a + b;
318     }
319 
320     /**
321      * @dev Returns the subtraction of two unsigned integers, reverting on
322      * overflow (when the result is negative).
323      *
324      * Counterpart to Solidity's `-` operator.
325      *
326      * Requirements:
327      *
328      * - Subtraction cannot overflow.
329      */
330     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
331         return a - b;
332     }
333 
334     /**
335      * @dev Returns the multiplication of two unsigned integers, reverting on
336      * overflow.
337      *
338      * Counterpart to Solidity's `*` operator.
339      *
340      * Requirements:
341      *
342      * - Multiplication cannot overflow.
343      */
344     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
345         return a * b;
346     }
347 
348     /**
349      * @dev Returns the integer division of two unsigned integers, reverting on
350      * division by zero. The result is rounded towards zero.
351      *
352      * Counterpart to Solidity's `/` operator.
353      *
354      * Requirements:
355      *
356      * - The divisor cannot be zero.
357      */
358     function div(uint256 a, uint256 b) internal pure returns (uint256) {
359         return a / b;
360     }
361 
362     /**
363      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
364      * reverting when dividing by zero.
365      *
366      * Counterpart to Solidity's `%` operator. This function uses a `revert`
367      * opcode (which leaves remaining gas untouched) while Solidity uses an
368      * invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      *
372      * - The divisor cannot be zero.
373      */
374     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
375         return a % b;
376     }
377 
378     /**
379      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
380      * overflow (when the result is negative).
381      *
382      * CAUTION: This function is deprecated because it requires allocating memory for the error
383      * message unnecessarily. For custom revert reasons use {trySub}.
384      *
385      * Counterpart to Solidity's `-` operator.
386      *
387      * Requirements:
388      *
389      * - Subtraction cannot overflow.
390      */
391     function sub(
392         uint256 a,
393         uint256 b,
394         string memory errorMessage
395     ) internal pure returns (uint256) {
396         unchecked {
397             require(b <= a, errorMessage);
398             return a - b;
399         }
400     }
401 
402     /**
403      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
404      * division by zero. The result is rounded towards zero.
405      *
406      * Counterpart to Solidity's `/` operator. Note: this function uses a
407      * `revert` opcode (which leaves remaining gas untouched) while Solidity
408      * uses an invalid opcode to revert (consuming all remaining gas).
409      *
410      * Requirements:
411      *
412      * - The divisor cannot be zero.
413      */
414     function div(
415         uint256 a,
416         uint256 b,
417         string memory errorMessage
418     ) internal pure returns (uint256) {
419         unchecked {
420             require(b > 0, errorMessage);
421             return a / b;
422         }
423     }
424 
425     /**
426      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
427      * reverting with custom message when dividing by zero.
428      *
429      * CAUTION: This function is deprecated because it requires allocating memory for the error
430      * message unnecessarily. For custom revert reasons use {tryMod}.
431      *
432      * Counterpart to Solidity's `%` operator. This function uses a `revert`
433      * opcode (which leaves remaining gas untouched) while Solidity uses an
434      * invalid opcode to revert (consuming all remaining gas).
435      *
436      * Requirements:
437      *
438      * - The divisor cannot be zero.
439      */
440     function mod(
441         uint256 a,
442         uint256 b,
443         string memory errorMessage
444     ) internal pure returns (uint256) {
445         unchecked {
446             require(b > 0, errorMessage);
447             return a % b;
448         }
449     }
450 }
451 
452 // File: @openzeppelin/contracts/utils/Strings.sol
453 
454 
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev String operations.
460  */
461 library Strings {
462     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
463 
464     /**
465      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
466      */
467     function toString(uint256 value) internal pure returns (string memory) {
468         // Inspired by OraclizeAPI's implementation - MIT licence
469         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
470 
471         if (value == 0) {
472             return "0";
473         }
474         uint256 temp = value;
475         uint256 digits;
476         while (temp != 0) {
477             digits++;
478             temp /= 10;
479         }
480         bytes memory buffer = new bytes(digits);
481         while (value != 0) {
482             digits -= 1;
483             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
484             value /= 10;
485         }
486         return string(buffer);
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
491      */
492     function toHexString(uint256 value) internal pure returns (string memory) {
493         if (value == 0) {
494             return "0x00";
495         }
496         uint256 temp = value;
497         uint256 length = 0;
498         while (temp != 0) {
499             length++;
500             temp >>= 8;
501         }
502         return toHexString(value, length);
503     }
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
507      */
508     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
509         bytes memory buffer = new bytes(2 * length + 2);
510         buffer[0] = "0";
511         buffer[1] = "x";
512         for (uint256 i = 2 * length + 1; i > 1; --i) {
513             buffer[i] = _HEX_SYMBOLS[value & 0xf];
514             value >>= 4;
515         }
516         require(value == 0, "Strings: hex length insufficient");
517         return string(buffer);
518     }
519 }
520 
521 // File: @openzeppelin/contracts/utils/Context.sol
522 
523 
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Provides information about the current execution context, including the
529  * sender of the transaction and its data. While these are generally available
530  * via msg.sender and msg.data, they should not be accessed in such a direct
531  * manner, since when dealing with meta-transactions the account sending and
532  * paying for execution may not be the actual sender (as far as an application
533  * is concerned).
534  *
535  * This contract is only required for intermediate, library-like contracts.
536  */
537 abstract contract Context {
538     function _msgSender() internal view virtual returns (address) {
539         return msg.sender;
540     }
541 
542     function _msgData() internal view virtual returns (bytes calldata) {
543         return msg.data;
544     }
545 }
546 
547 // File: @openzeppelin/contracts/access/Ownable.sol
548 
549 
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev Contract module which provides a basic access control mechanism, where
556  * there is an account (an owner) that can be granted exclusive access to
557  * specific functions.
558  *
559  * By default, the owner account will be the one that deploys the contract. This
560  * can later be changed with {transferOwnership}.
561  *
562  * This module is used through inheritance. It will make available the modifier
563  * `onlyOwner`, which can be applied to your functions to restrict their use to
564  * the owner.
565  */
566 abstract contract Ownable is Context {
567     address private _owner;
568 
569     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
570 
571     /**
572      * @dev Initializes the contract setting the deployer as the initial owner.
573      */
574     constructor() {
575         _setOwner(_msgSender());
576     }
577 
578     /**
579      * @dev Returns the address of the current owner.
580      */
581     function owner() public view virtual returns (address) {
582         return _owner;
583     }
584 
585     /**
586      * @dev Throws if called by any account other than the owner.
587      */
588     modifier onlyOwner() {
589         require(owner() == _msgSender(), "Ownable: caller is not the owner");
590         _;
591     }
592 
593     /**
594      * @dev Leaves the contract without owner. It will not be possible to call
595      * `onlyOwner` functions anymore. Can only be called by the current owner.
596      *
597      * NOTE: Renouncing ownership will leave the contract without an owner,
598      * thereby removing any functionality that is only available to the owner.
599      */
600     function renounceOwnership() public virtual onlyOwner {
601         _setOwner(address(0));
602     }
603 
604     /**
605      * @dev Transfers ownership of the contract to a new account (`newOwner`).
606      * Can only be called by the current owner.
607      */
608     function transferOwnership(address newOwner) public virtual onlyOwner {
609         require(newOwner != address(0), "Ownable: new owner is the zero address");
610         _setOwner(newOwner);
611     }
612 
613     function _setOwner(address newOwner) private {
614         address oldOwner = _owner;
615         _owner = newOwner;
616         emit OwnershipTransferred(oldOwner, newOwner);
617     }
618 }
619 
620 // File: @openzeppelin/contracts/security/Pausable.sol
621 
622 
623 
624 pragma solidity ^0.8.0;
625 
626 
627 /**
628  * @dev Contract module which allows children to implement an emergency stop
629  * mechanism that can be triggered by an authorized account.
630  *
631  * This module is used through inheritance. It will make available the
632  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
633  * the functions of your contract. Note that they will not be pausable by
634  * simply including this module, only once the modifiers are put in place.
635  */
636 abstract contract Pausable is Context {
637     /**
638      * @dev Emitted when the pause is triggered by `account`.
639      */
640     event Paused(address account);
641 
642     /**
643      * @dev Emitted when the pause is lifted by `account`.
644      */
645     event Unpaused(address account);
646 
647     bool private _paused;
648 
649     /**
650      * @dev Initializes the contract in unpaused state.
651      */
652     constructor() {
653         _paused = false;
654     }
655 
656     /**
657      * @dev Returns true if the contract is paused, and false otherwise.
658      */
659     function paused() public view virtual returns (bool) {
660         return _paused;
661     }
662 
663     /**
664      * @dev Modifier to make a function callable only when the contract is not paused.
665      *
666      * Requirements:
667      *
668      * - The contract must not be paused.
669      */
670     modifier whenNotPaused() {
671         require(!paused(), "Pausable: paused");
672         _;
673     }
674 
675     /**
676      * @dev Modifier to make a function callable only when the contract is paused.
677      *
678      * Requirements:
679      *
680      * - The contract must be paused.
681      */
682     modifier whenPaused() {
683         require(paused(), "Pausable: not paused");
684         _;
685     }
686 
687     /**
688      * @dev Triggers stopped state.
689      *
690      * Requirements:
691      *
692      * - The contract must not be paused.
693      */
694     function _pause() internal virtual whenNotPaused {
695         _paused = true;
696         emit Paused(_msgSender());
697     }
698 
699     /**
700      * @dev Returns to normal state.
701      *
702      * Requirements:
703      *
704      * - The contract must be paused.
705      */
706     function _unpause() internal virtual whenPaused {
707         _paused = false;
708         emit Unpaused(_msgSender());
709     }
710 }
711 
712 // File: @openzeppelin/contracts/utils/Address.sol
713 
714 
715 
716 pragma solidity ^0.8.0;
717 
718 /**
719  * @dev Collection of functions related to the address type
720  */
721 library Address {
722     /**
723      * @dev Returns true if `account` is a contract.
724      *
725      * [IMPORTANT]
726      * ====
727      * It is unsafe to assume that an address for which this function returns
728      * false is an externally-owned account (EOA) and not a contract.
729      *
730      * Among others, `isContract` will return false for the following
731      * types of addresses:
732      *
733      *  - an externally-owned account
734      *  - a contract in construction
735      *  - an address where a contract will be created
736      *  - an address where a contract lived, but was destroyed
737      * ====
738      */
739     function isContract(address account) internal view returns (bool) {
740         // This method relies on extcodesize, which returns 0 for contracts in
741         // construction, since the code is only stored at the end of the
742         // constructor execution.
743 
744         uint256 size;
745         assembly {
746             size := extcodesize(account)
747         }
748         return size > 0;
749     }
750 
751     /**
752      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
753      * `recipient`, forwarding all available gas and reverting on errors.
754      *
755      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
756      * of certain opcodes, possibly making contracts go over the 2300 gas limit
757      * imposed by `transfer`, making them unable to receive funds via
758      * `transfer`. {sendValue} removes this limitation.
759      *
760      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
761      *
762      * IMPORTANT: because control is transferred to `recipient`, care must be
763      * taken to not create reentrancy vulnerabilities. Consider using
764      * {ReentrancyGuard} or the
765      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
766      */
767     function sendValue(address payable recipient, uint256 amount) internal {
768         require(address(this).balance >= amount, "Address: insufficient balance");
769 
770         (bool success, ) = recipient.call{value: amount}("");
771         require(success, "Address: unable to send value, recipient may have reverted");
772     }
773 
774     /**
775      * @dev Performs a Solidity function call using a low level `call`. A
776      * plain `call` is an unsafe replacement for a function call: use this
777      * function instead.
778      *
779      * If `target` reverts with a revert reason, it is bubbled up by this
780      * function (like regular Solidity function calls).
781      *
782      * Returns the raw returned data. To convert to the expected return value,
783      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
784      *
785      * Requirements:
786      *
787      * - `target` must be a contract.
788      * - calling `target` with `data` must not revert.
789      *
790      * _Available since v3.1._
791      */
792     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
793         return functionCall(target, data, "Address: low-level call failed");
794     }
795 
796     /**
797      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
798      * `errorMessage` as a fallback revert reason when `target` reverts.
799      *
800      * _Available since v3.1._
801      */
802     function functionCall(
803         address target,
804         bytes memory data,
805         string memory errorMessage
806     ) internal returns (bytes memory) {
807         return functionCallWithValue(target, data, 0, errorMessage);
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
812      * but also transferring `value` wei to `target`.
813      *
814      * Requirements:
815      *
816      * - the calling contract must have an ETH balance of at least `value`.
817      * - the called Solidity function must be `payable`.
818      *
819      * _Available since v3.1._
820      */
821     function functionCallWithValue(
822         address target,
823         bytes memory data,
824         uint256 value
825     ) internal returns (bytes memory) {
826         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
827     }
828 
829     /**
830      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
831      * with `errorMessage` as a fallback revert reason when `target` reverts.
832      *
833      * _Available since v3.1._
834      */
835     function functionCallWithValue(
836         address target,
837         bytes memory data,
838         uint256 value,
839         string memory errorMessage
840     ) internal returns (bytes memory) {
841         require(address(this).balance >= value, "Address: insufficient balance for call");
842         require(isContract(target), "Address: call to non-contract");
843 
844         (bool success, bytes memory returndata) = target.call{value: value}(data);
845         return verifyCallResult(success, returndata, errorMessage);
846     }
847 
848     /**
849      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
850      * but performing a static call.
851      *
852      * _Available since v3.3._
853      */
854     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
855         return functionStaticCall(target, data, "Address: low-level static call failed");
856     }
857 
858     /**
859      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
860      * but performing a static call.
861      *
862      * _Available since v3.3._
863      */
864     function functionStaticCall(
865         address target,
866         bytes memory data,
867         string memory errorMessage
868     ) internal view returns (bytes memory) {
869         require(isContract(target), "Address: static call to non-contract");
870 
871         (bool success, bytes memory returndata) = target.staticcall(data);
872         return verifyCallResult(success, returndata, errorMessage);
873     }
874 
875     /**
876      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
877      * but performing a delegate call.
878      *
879      * _Available since v3.4._
880      */
881     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
882         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
883     }
884 
885     /**
886      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
887      * but performing a delegate call.
888      *
889      * _Available since v3.4._
890      */
891     function functionDelegateCall(
892         address target,
893         bytes memory data,
894         string memory errorMessage
895     ) internal returns (bytes memory) {
896         require(isContract(target), "Address: delegate call to non-contract");
897 
898         (bool success, bytes memory returndata) = target.delegatecall(data);
899         return verifyCallResult(success, returndata, errorMessage);
900     }
901 
902     /**
903      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
904      * revert reason using the provided one.
905      *
906      * _Available since v4.3._
907      */
908     function verifyCallResult(
909         bool success,
910         bytes memory returndata,
911         string memory errorMessage
912     ) internal pure returns (bytes memory) {
913         if (success) {
914             return returndata;
915         } else {
916             // Look for revert reason and bubble it up if present
917             if (returndata.length > 0) {
918                 // The easiest way to bubble the revert reason is using memory via assembly
919 
920                 assembly {
921                     let returndata_size := mload(returndata)
922                     revert(add(32, returndata), returndata_size)
923                 }
924             } else {
925                 revert(errorMessage);
926             }
927         }
928     }
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
932 
933 
934 
935 pragma solidity ^0.8.0;
936 
937 /**
938  * @title ERC721 token receiver interface
939  * @dev Interface for any contract that wants to support safeTransfers
940  * from ERC721 asset contracts.
941  */
942 interface IERC721Receiver {
943     /**
944      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
945      * by `operator` from `from`, this function is called.
946      *
947      * It must return its Solidity selector to confirm the token transfer.
948      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
949      *
950      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
951      */
952     function onERC721Received(
953         address operator,
954         address from,
955         uint256 tokenId,
956         bytes calldata data
957     ) external returns (bytes4);
958 }
959 
960 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
961 
962 
963 
964 pragma solidity ^0.8.0;
965 
966 /**
967  * @dev Interface of the ERC165 standard, as defined in the
968  * https://eips.ethereum.org/EIPS/eip-165[EIP].
969  *
970  * Implementers can declare support of contract interfaces, which can then be
971  * queried by others ({ERC165Checker}).
972  *
973  * For an implementation, see {ERC165}.
974  */
975 interface IERC165 {
976     /**
977      * @dev Returns true if this contract implements the interface defined by
978      * `interfaceId`. See the corresponding
979      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
980      * to learn more about how these ids are created.
981      *
982      * This function call must use less than 30 000 gas.
983      */
984     function supportsInterface(bytes4 interfaceId) external view returns (bool);
985 }
986 
987 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
988 
989 
990 
991 pragma solidity ^0.8.0;
992 
993 
994 /**
995  * @dev Implementation of the {IERC165} interface.
996  *
997  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
998  * for the additional interface id that will be supported. For example:
999  *
1000  * ```solidity
1001  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1002  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1003  * }
1004  * ```
1005  *
1006  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1007  */
1008 abstract contract ERC165 is IERC165 {
1009     /**
1010      * @dev See {IERC165-supportsInterface}.
1011      */
1012     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1013         return interfaceId == type(IERC165).interfaceId;
1014     }
1015 }
1016 
1017 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1018 
1019 
1020 
1021 pragma solidity ^0.8.0;
1022 
1023 
1024 /**
1025  * @dev Required interface of an ERC721 compliant contract.
1026  */
1027 interface IERC721 is IERC165 {
1028     /**
1029      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1030      */
1031     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1032 
1033     /**
1034      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1035      */
1036     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1037 
1038     /**
1039      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1040      */
1041     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1042 
1043     /**
1044      * @dev Returns the number of tokens in ``owner``'s account.
1045      */
1046     function balanceOf(address owner) external view returns (uint256 balance);
1047 
1048     /**
1049      * @dev Returns the owner of the `tokenId` token.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      */
1055     function ownerOf(uint256 tokenId) external view returns (address owner);
1056 
1057     /**
1058      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1059      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1060      *
1061      * Requirements:
1062      *
1063      * - `from` cannot be the zero address.
1064      * - `to` cannot be the zero address.
1065      * - `tokenId` token must exist and be owned by `from`.
1066      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1067      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function safeTransferFrom(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) external;
1076 
1077     /**
1078      * @dev Transfers `tokenId` token from `from` to `to`.
1079      *
1080      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1081      *
1082      * Requirements:
1083      *
1084      * - `from` cannot be the zero address.
1085      * - `to` cannot be the zero address.
1086      * - `tokenId` token must be owned by `from`.
1087      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function transferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) external;
1096 
1097     /**
1098      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1099      * The approval is cleared when the token is transferred.
1100      *
1101      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1102      *
1103      * Requirements:
1104      *
1105      * - The caller must own the token or be an approved operator.
1106      * - `tokenId` must exist.
1107      *
1108      * Emits an {Approval} event.
1109      */
1110     function approve(address to, uint256 tokenId) external;
1111 
1112     /**
1113      * @dev Returns the account approved for `tokenId` token.
1114      *
1115      * Requirements:
1116      *
1117      * - `tokenId` must exist.
1118      */
1119     function getApproved(uint256 tokenId) external view returns (address operator);
1120 
1121     /**
1122      * @dev Approve or remove `operator` as an operator for the caller.
1123      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1124      *
1125      * Requirements:
1126      *
1127      * - The `operator` cannot be the caller.
1128      *
1129      * Emits an {ApprovalForAll} event.
1130      */
1131     function setApprovalForAll(address operator, bool _approved) external;
1132 
1133     /**
1134      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1135      *
1136      * See {setApprovalForAll}
1137      */
1138     function isApprovedForAll(address owner, address operator) external view returns (bool);
1139 
1140     /**
1141      * @dev Safely transfers `tokenId` token from `from` to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - `from` cannot be the zero address.
1146      * - `to` cannot be the zero address.
1147      * - `tokenId` token must exist and be owned by `from`.
1148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function safeTransferFrom(
1154         address from,
1155         address to,
1156         uint256 tokenId,
1157         bytes calldata data
1158     ) external;
1159 }
1160 
1161 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1162 
1163 
1164 
1165 pragma solidity ^0.8.0;
1166 
1167 
1168 /**
1169  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1170  * @dev See https://eips.ethereum.org/EIPS/eip-721
1171  */
1172 interface IERC721Enumerable is IERC721 {
1173     /**
1174      * @dev Returns the total amount of tokens stored by the contract.
1175      */
1176     function totalSupply() external view returns (uint256);
1177 
1178     /**
1179      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1180      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1181      */
1182     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1183 
1184     /**
1185      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1186      * Use along with {totalSupply} to enumerate all tokens.
1187      */
1188     function tokenByIndex(uint256 index) external view returns (uint256);
1189 }
1190 
1191 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1192 
1193 
1194 
1195 pragma solidity ^0.8.0;
1196 
1197 
1198 /**
1199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1200  * @dev See https://eips.ethereum.org/EIPS/eip-721
1201  */
1202 interface IERC721Metadata is IERC721 {
1203     /**
1204      * @dev Returns the token collection name.
1205      */
1206     function name() external view returns (string memory);
1207 
1208     /**
1209      * @dev Returns the token collection symbol.
1210      */
1211     function symbol() external view returns (string memory);
1212 
1213     /**
1214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1215      */
1216     function tokenURI(uint256 tokenId) external view returns (string memory);
1217 }
1218 
1219 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1220 
1221 
1222 
1223 pragma solidity ^0.8.0;
1224 
1225 
1226 
1227 
1228 
1229 
1230 
1231 
1232 /**
1233  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1234  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1235  * {ERC721Enumerable}.
1236  */
1237 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1238     using Address for address;
1239     using Strings for uint256;
1240 
1241     // Token name
1242     string private _name;
1243 
1244     // Token symbol
1245     string private _symbol;
1246 
1247     // Mapping from token ID to owner address
1248     mapping(uint256 => address) private _owners;
1249 
1250     // Mapping owner address to token count
1251     mapping(address => uint256) private _balances;
1252 
1253     // Mapping from token ID to approved address
1254     mapping(uint256 => address) private _tokenApprovals;
1255 
1256     // Mapping from owner to operator approvals
1257     mapping(address => mapping(address => bool)) private _operatorApprovals;
1258 
1259     /**
1260      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1261      */
1262     constructor(string memory name_, string memory symbol_) {
1263         _name = name_;
1264         _symbol = symbol_;
1265     }
1266 
1267     /**
1268      * @dev See {IERC165-supportsInterface}.
1269      */
1270     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1271         return
1272             interfaceId == type(IERC721).interfaceId ||
1273             interfaceId == type(IERC721Metadata).interfaceId ||
1274             super.supportsInterface(interfaceId);
1275     }
1276 
1277     /**
1278      * @dev See {IERC721-balanceOf}.
1279      */
1280     function balanceOf(address owner) public view virtual override returns (uint256) {
1281         require(owner != address(0), "ERC721: balance query for the zero address");
1282         return _balances[owner];
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-ownerOf}.
1287      */
1288     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1289         address owner = _owners[tokenId];
1290         require(owner != address(0), "ERC721: owner query for nonexistent token");
1291         return owner;
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Metadata-name}.
1296      */
1297     function name() public view virtual override returns (string memory) {
1298         return _name;
1299     }
1300 
1301     /**
1302      * @dev See {IERC721Metadata-symbol}.
1303      */
1304     function symbol() public view virtual override returns (string memory) {
1305         return _symbol;
1306     }
1307 
1308     /**
1309      * @dev See {IERC721Metadata-tokenURI}.
1310      */
1311     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1312         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1313 
1314         string memory baseURI = _baseURI();
1315         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1316     }
1317 
1318     /**
1319      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1320      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1321      * by default, can be overriden in child contracts.
1322      */
1323     function _baseURI() internal view virtual returns (string memory) {
1324         return "";
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-approve}.
1329      */
1330     function approve(address to, uint256 tokenId) public virtual override {
1331         address owner = ERC721.ownerOf(tokenId);
1332         require(to != owner, "ERC721: approval to current owner");
1333 
1334         require(
1335             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1336             "ERC721: approve caller is not owner nor approved for all"
1337         );
1338 
1339         _approve(to, tokenId);
1340     }
1341 
1342     /**
1343      * @dev See {IERC721-getApproved}.
1344      */
1345     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1346         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1347 
1348         return _tokenApprovals[tokenId];
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-setApprovalForAll}.
1353      */
1354     function setApprovalForAll(address operator, bool approved) public virtual override {
1355         require(operator != _msgSender(), "ERC721: approve to caller");
1356 
1357         _operatorApprovals[_msgSender()][operator] = approved;
1358         emit ApprovalForAll(_msgSender(), operator, approved);
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-isApprovedForAll}.
1363      */
1364     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1365         return _operatorApprovals[owner][operator];
1366     }
1367 
1368     /**
1369      * @dev See {IERC721-transferFrom}.
1370      */
1371     function transferFrom(
1372         address from,
1373         address to,
1374         uint256 tokenId
1375     ) public virtual override {
1376         //solhint-disable-next-line max-line-length
1377         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1378 
1379         _transfer(from, to, tokenId);
1380     }
1381 
1382     /**
1383      * @dev See {IERC721-safeTransferFrom}.
1384      */
1385     function safeTransferFrom(
1386         address from,
1387         address to,
1388         uint256 tokenId
1389     ) public virtual override {
1390         safeTransferFrom(from, to, tokenId, "");
1391     }
1392 
1393     /**
1394      * @dev See {IERC721-safeTransferFrom}.
1395      */
1396     function safeTransferFrom(
1397         address from,
1398         address to,
1399         uint256 tokenId,
1400         bytes memory _data
1401     ) public virtual override {
1402         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1403         _safeTransfer(from, to, tokenId, _data);
1404     }
1405 
1406     /**
1407      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1408      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1409      *
1410      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1411      *
1412      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1413      * implement alternative mechanisms to perform token transfer, such as signature-based.
1414      *
1415      * Requirements:
1416      *
1417      * - `from` cannot be the zero address.
1418      * - `to` cannot be the zero address.
1419      * - `tokenId` token must exist and be owned by `from`.
1420      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1421      *
1422      * Emits a {Transfer} event.
1423      */
1424     function _safeTransfer(
1425         address from,
1426         address to,
1427         uint256 tokenId,
1428         bytes memory _data
1429     ) internal virtual {
1430         _transfer(from, to, tokenId);
1431         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1432     }
1433 
1434     /**
1435      * @dev Returns whether `tokenId` exists.
1436      *
1437      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1438      *
1439      * Tokens start existing when they are minted (`_mint`),
1440      * and stop existing when they are burned (`_burn`).
1441      */
1442     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1443         return _owners[tokenId] != address(0);
1444     }
1445 
1446     /**
1447      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1448      *
1449      * Requirements:
1450      *
1451      * - `tokenId` must exist.
1452      */
1453     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1454         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1455         address owner = ERC721.ownerOf(tokenId);
1456         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1457     }
1458 
1459     /**
1460      * @dev Safely mints `tokenId` and transfers it to `to`.
1461      *
1462      * Requirements:
1463      *
1464      * - `tokenId` must not exist.
1465      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1466      *
1467      * Emits a {Transfer} event.
1468      */
1469     function _safeMint(address to, uint256 tokenId) internal virtual {
1470         _safeMint(to, tokenId, "");
1471     }
1472 
1473     /**
1474      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1475      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1476      */
1477     function _safeMint(
1478         address to,
1479         uint256 tokenId,
1480         bytes memory _data
1481     ) internal virtual {
1482         _mint(to, tokenId);
1483         require(
1484             _checkOnERC721Received(address(0), to, tokenId, _data),
1485             "ERC721: transfer to non ERC721Receiver implementer"
1486         );
1487     }
1488 
1489     /**
1490      * @dev Mints `tokenId` and transfers it to `to`.
1491      *
1492      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1493      *
1494      * Requirements:
1495      *
1496      * - `tokenId` must not exist.
1497      * - `to` cannot be the zero address.
1498      *
1499      * Emits a {Transfer} event.
1500      */
1501     function _mint(address to, uint256 tokenId) internal virtual {
1502         require(to != address(0), "ERC721: mint to the zero address");
1503         require(!_exists(tokenId), "ERC721: token already minted");
1504 
1505         _beforeTokenTransfer(address(0), to, tokenId);
1506 
1507         _balances[to] += 1;
1508         _owners[tokenId] = to;
1509 
1510         emit Transfer(address(0), to, tokenId);
1511     }
1512 
1513     /**
1514      * @dev Destroys `tokenId`.
1515      * The approval is cleared when the token is burned.
1516      *
1517      * Requirements:
1518      *
1519      * - `tokenId` must exist.
1520      *
1521      * Emits a {Transfer} event.
1522      */
1523     function _burn(uint256 tokenId) internal virtual {
1524         address owner = ERC721.ownerOf(tokenId);
1525 
1526         _beforeTokenTransfer(owner, address(0), tokenId);
1527 
1528         // Clear approvals
1529         _approve(address(0), tokenId);
1530 
1531         _balances[owner] -= 1;
1532         delete _owners[tokenId];
1533 
1534         emit Transfer(owner, address(0), tokenId);
1535     }
1536 
1537     /**
1538      * @dev Transfers `tokenId` from `from` to `to`.
1539      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1540      *
1541      * Requirements:
1542      *
1543      * - `to` cannot be the zero address.
1544      * - `tokenId` token must be owned by `from`.
1545      *
1546      * Emits a {Transfer} event.
1547      */
1548     function _transfer(
1549         address from,
1550         address to,
1551         uint256 tokenId
1552     ) internal virtual {
1553         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1554         require(to != address(0), "ERC721: transfer to the zero address");
1555 
1556         _beforeTokenTransfer(from, to, tokenId);
1557 
1558         // Clear approvals from the previous owner
1559         _approve(address(0), tokenId);
1560 
1561         _balances[from] -= 1;
1562         _balances[to] += 1;
1563         _owners[tokenId] = to;
1564 
1565         emit Transfer(from, to, tokenId);
1566     }
1567 
1568     /**
1569      * @dev Approve `to` to operate on `tokenId`
1570      *
1571      * Emits a {Approval} event.
1572      */
1573     function _approve(address to, uint256 tokenId) internal virtual {
1574         _tokenApprovals[tokenId] = to;
1575         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1576     }
1577 
1578     /**
1579      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1580      * The call is not executed if the target address is not a contract.
1581      *
1582      * @param from address representing the previous owner of the given token ID
1583      * @param to target address that will receive the tokens
1584      * @param tokenId uint256 ID of the token to be transferred
1585      * @param _data bytes optional data to send along with the call
1586      * @return bool whether the call correctly returned the expected magic value
1587      */
1588     function _checkOnERC721Received(
1589         address from,
1590         address to,
1591         uint256 tokenId,
1592         bytes memory _data
1593     ) private returns (bool) {
1594         if (to.isContract()) {
1595             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1596                 return retval == IERC721Receiver.onERC721Received.selector;
1597             } catch (bytes memory reason) {
1598                 if (reason.length == 0) {
1599                     revert("ERC721: transfer to non ERC721Receiver implementer");
1600                 } else {
1601                     assembly {
1602                         revert(add(32, reason), mload(reason))
1603                     }
1604                 }
1605             }
1606         } else {
1607             return true;
1608         }
1609     }
1610 
1611     /**
1612      * @dev Hook that is called before any token transfer. This includes minting
1613      * and burning.
1614      *
1615      * Calling conditions:
1616      *
1617      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1618      * transferred to `to`.
1619      * - When `from` is zero, `tokenId` will be minted for `to`.
1620      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1621      * - `from` and `to` are never both zero.
1622      *
1623      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1624      */
1625     function _beforeTokenTransfer(
1626         address from,
1627         address to,
1628         uint256 tokenId
1629     ) internal virtual {}
1630 }
1631 
1632 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1633 
1634 
1635 
1636 pragma solidity ^0.8.0;
1637 
1638 
1639 
1640 /**
1641  * @dev ERC721 token with pausable token transfers, minting and burning.
1642  *
1643  * Useful for scenarios such as preventing trades until the end of an evaluation
1644  * period, or having an emergency switch for freezing all token transfers in the
1645  * event of a large bug.
1646  */
1647 abstract contract ERC721Pausable is ERC721, Pausable {
1648     /**
1649      * @dev See {ERC721-_beforeTokenTransfer}.
1650      *
1651      * Requirements:
1652      *
1653      * - the contract must not be paused.
1654      */
1655     function _beforeTokenTransfer(
1656         address from,
1657         address to,
1658         uint256 tokenId
1659     ) internal virtual override {
1660         super._beforeTokenTransfer(from, to, tokenId);
1661 
1662         require(!paused(), "ERC721Pausable: token transfer while paused");
1663     }
1664 }
1665 
1666 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1667 
1668 
1669 
1670 pragma solidity ^0.8.0;
1671 
1672 
1673 
1674 /**
1675  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1676  * enumerability of all the token ids in the contract as well as all token ids owned by each
1677  * account.
1678  */
1679 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1680     // Mapping from owner to list of owned token IDs
1681     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1682 
1683     // Mapping from token ID to index of the owner tokens list
1684     mapping(uint256 => uint256) private _ownedTokensIndex;
1685 
1686     // Array with all token ids, used for enumeration
1687     uint256[] private _allTokens;
1688 
1689     // Mapping from token id to position in the allTokens array
1690     mapping(uint256 => uint256) private _allTokensIndex;
1691 
1692     /**
1693      * @dev See {IERC165-supportsInterface}.
1694      */
1695     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1696         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1697     }
1698 
1699     /**
1700      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1701      */
1702     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1703         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1704         return _ownedTokens[owner][index];
1705     }
1706 
1707     /**
1708      * @dev See {IERC721Enumerable-totalSupply}.
1709      */
1710     function totalSupply() public view virtual override returns (uint256) {
1711         return _allTokens.length;
1712     }
1713 
1714     /**
1715      * @dev See {IERC721Enumerable-tokenByIndex}.
1716      */
1717     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1718         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1719         return _allTokens[index];
1720     }
1721 
1722     /**
1723      * @dev Hook that is called before any token transfer. This includes minting
1724      * and burning.
1725      *
1726      * Calling conditions:
1727      *
1728      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1729      * transferred to `to`.
1730      * - When `from` is zero, `tokenId` will be minted for `to`.
1731      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1732      * - `from` cannot be the zero address.
1733      * - `to` cannot be the zero address.
1734      *
1735      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1736      */
1737     function _beforeTokenTransfer(
1738         address from,
1739         address to,
1740         uint256 tokenId
1741     ) internal virtual override {
1742         super._beforeTokenTransfer(from, to, tokenId);
1743 
1744         if (from == address(0)) {
1745             _addTokenToAllTokensEnumeration(tokenId);
1746         } else if (from != to) {
1747             _removeTokenFromOwnerEnumeration(from, tokenId);
1748         }
1749         if (to == address(0)) {
1750             _removeTokenFromAllTokensEnumeration(tokenId);
1751         } else if (to != from) {
1752             _addTokenToOwnerEnumeration(to, tokenId);
1753         }
1754     }
1755 
1756     /**
1757      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1758      * @param to address representing the new owner of the given token ID
1759      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1760      */
1761     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1762         uint256 length = ERC721.balanceOf(to);
1763         _ownedTokens[to][length] = tokenId;
1764         _ownedTokensIndex[tokenId] = length;
1765     }
1766 
1767     /**
1768      * @dev Private function to add a token to this extension's token tracking data structures.
1769      * @param tokenId uint256 ID of the token to be added to the tokens list
1770      */
1771     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1772         _allTokensIndex[tokenId] = _allTokens.length;
1773         _allTokens.push(tokenId);
1774     }
1775 
1776     /**
1777      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1778      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1779      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1780      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1781      * @param from address representing the previous owner of the given token ID
1782      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1783      */
1784     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1785         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1786         // then delete the last slot (swap and pop).
1787 
1788         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1789         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1790 
1791         // When the token to delete is the last token, the swap operation is unnecessary
1792         if (tokenIndex != lastTokenIndex) {
1793             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1794 
1795             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1796             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1797         }
1798 
1799         // This also deletes the contents at the last position of the array
1800         delete _ownedTokensIndex[tokenId];
1801         delete _ownedTokens[from][lastTokenIndex];
1802     }
1803 
1804     /**
1805      * @dev Private function to remove a token from this extension's token tracking data structures.
1806      * This has O(1) time complexity, but alters the order of the _allTokens array.
1807      * @param tokenId uint256 ID of the token to be removed from the tokens list
1808      */
1809     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1810         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1811         // then delete the last slot (swap and pop).
1812 
1813         uint256 lastTokenIndex = _allTokens.length - 1;
1814         uint256 tokenIndex = _allTokensIndex[tokenId];
1815 
1816         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1817         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1818         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1819         uint256 lastTokenId = _allTokens[lastTokenIndex];
1820 
1821         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1822         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1823 
1824         // This also deletes the contents at the last position of the array
1825         delete _allTokensIndex[tokenId];
1826         _allTokens.pop();
1827     }
1828 }
1829 
1830 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1831 
1832 
1833 
1834 pragma solidity ^0.8.0;
1835 
1836 
1837 
1838 /**
1839  * @title ERC721 Burnable Token
1840  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1841  */
1842 abstract contract ERC721Burnable is Context, ERC721 {
1843     /**
1844      * @dev Burns `tokenId`. See {ERC721-_burn}.
1845      *
1846      * Requirements:
1847      *
1848      * - The caller must own `tokenId` or be an approved operator.
1849      */
1850     function burn(uint256 tokenId) public virtual {
1851         //solhint-disable-next-line max-line-length
1852         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1853         _burn(tokenId);
1854     }
1855 }
1856 
1857 // File: ImpactTheoryFoundersKey.sol
1858 
1859 
1860 pragma solidity ^0.8.0;
1861 
1862 
1863 
1864 
1865 
1866 
1867 
1868 
1869 /**
1870  *
1871  * Impact Theory Founders Key
1872  *
1873  */
1874 contract ImpactTheoryFoundersKey is
1875     Ownable,
1876     ERC721Burnable,
1877     ERC721Enumerable,
1878     ERC721Pausable
1879 {
1880     using SafeMath for uint256;
1881     using Strings for uint256;
1882     using ECDSA for bytes32;
1883 
1884     // Public tier info
1885     struct Tier {
1886         uint256 id;
1887         string name;
1888     }
1889 
1890     // Private tier info
1891     struct TierInfo {
1892         Tier tier;
1893         uint256 startingOffset;
1894         uint256 totalSupply;
1895         uint256 startingPrice;
1896         uint256 endingPrice;
1897         uint256 maxPerClosedPresale;
1898         uint256 maxTotalMint;
1899         bool saleEnded;
1900     }
1901 
1902     // Base token uri
1903     string private baseTokenURI; // baseTokenURI can point to IPFS folder like https://ipfs.io/ipfs/{cid}/ while
1904     string private baseTokenURIForMetadata; // baseTokenURIForMetadata should point to the raw IPFS endpoint because it will not use IPFS folders. For example: https://ipfs.io/ipfs/
1905 
1906     // For uint to bytes32 conversion
1907     bytes16 private constant HEX_ALPHABET = "0123456789abcdef";
1908     string private constant IPFS_PREFIX = "f01551220"; // IPFS byte (f) + CID v1 (0x01) + raw codec (0x55) + SHA256 (0x12) + 256 bits long (0x20)
1909 
1910     // Payment address
1911     address private paymentAddress = 0x681EA99a65E6f392f0F5276Af396AE8CaD140E6D;
1912 
1913     // Royalties address
1914     address private royaltyAddress = 0x681EA99a65E6f392f0F5276Af396AE8CaD140E6D;
1915 
1916     // Signer address
1917     address private signerAddress = 0x4A2034e724034F31b46117d918E789c42EBE0CF2;
1918 
1919     // Royalties basis points (percentage using 2 decimals - 10000 = 100, 0 = 0)
1920     uint256 private royaltyBasisPoints = 1000; // 10%
1921 
1922     // Token info
1923     string public constant TOKEN_NAME = "Impact Theory Founder's Key";
1924     string public constant TOKEN_SYMBOL = "ITFK";
1925 
1926     // Sale durations
1927     uint256 public constant CLOSED_PRESALE_DURATION = 1 days;
1928     uint256 public constant PRESALE_DURATION = 1 days;
1929     uint256 public constant AUCTION_DURATION = 1 days;
1930     uint256 public constant AUCTION_PRICE_CHANGE = 1 hours;
1931     uint256 public constant DURATION_BETWEEN_TIERS = 1 days;
1932 
1933     // Public sale params
1934     uint256 public publicSaleStartTime;
1935     bool public publicSaleActive;
1936 
1937     //-- Tiers --//
1938     // Tier 1 - public info
1939     Tier public tier1 = Tier({id: 1, name: "Legendary"});
1940 
1941     // Tier 1 - private info
1942     TierInfo private tier1Info =
1943         TierInfo({
1944             tier: tier1,
1945             startingOffset: 1,
1946             totalSupply: 2700,
1947             startingPrice: 3 ether,
1948             endingPrice: 1.5 ether,
1949             maxPerClosedPresale: 1,
1950             maxTotalMint: 4,
1951             saleEnded: false
1952         });
1953 
1954     // Tier 2 - public info
1955     Tier public tier2 = Tier({id: 2, name: "Heroic"});
1956 
1957     // Tier 2 - private info
1958     TierInfo private tier2Info =
1959         TierInfo({
1960             tier: tier2,
1961             startingOffset: 2701,
1962             totalSupply: 7300,
1963             startingPrice: 1.5 ether,
1964             endingPrice: .75 ether,
1965             maxPerClosedPresale: 2,
1966             maxTotalMint: 5,
1967             saleEnded: false
1968         });
1969 
1970     // Tier 3 - public info
1971     Tier public tier3 = Tier({id: 3, name: "Relentless"});
1972 
1973     // Tier 3 - private info
1974     TierInfo private tier3Info =
1975         TierInfo({
1976             tier: tier3,
1977             startingOffset: 10001,
1978             totalSupply: 10000,
1979             startingPrice: .1 ether,
1980             endingPrice: .05 ether,
1981             maxPerClosedPresale: 1,
1982             maxTotalMint: 5,
1983             saleEnded: false
1984         });
1985 
1986     Tier[] public allTiersArray;
1987     TierInfo[] private allTiersInfoArray;
1988 
1989     uint256[] public allTierIds;
1990 
1991     mapping(uint256 => Tier) public allTiers;
1992     mapping(uint256 => TierInfo) private allTiersInfo;
1993 
1994     mapping(uint256 => Tier) public tokenTier;
1995 
1996     mapping(uint256 => uint256) public tokenMintedAt;
1997     mapping(uint256 => uint256) public tokenLastTransferredAt;
1998 
1999     mapping(uint256 => uint256) public tierCounts;
2000 
2001     mapping(uint256 => bytes32[]) public tokenMetadata;
2002 
2003     // Presale whitelist per tier
2004     mapping(address => uint256[]) private presaleWhitelist;
2005 
2006     // Used nonces for mint signatures
2007     mapping(string => bool) private usedNonces;
2008 
2009     //-- Events --//
2010 
2011     event PublicSaleStart(uint256 indexed _saleStartTime);
2012     event PublicSalePaused(uint256 indexed _timeElapsed);
2013     event PublicSaleActive(bool indexed _publicSaleActive);
2014     event RoyaltyBasisPoints(uint256 indexed _royaltyBasisPoints);
2015 
2016     //-- Modifiers --//
2017 
2018     // Public sale active modifier
2019     modifier whenPublicSaleActive() {
2020         require(publicSaleActive, "Public sale is not active");
2021         _;
2022     }
2023 
2024     // Public sale not active modifier
2025     modifier whenPublicSaleNotActive() {
2026         require(
2027             !publicSaleActive && publicSaleStartTime == 0,
2028             "Public sale is already active"
2029         );
2030         _;
2031     }
2032 
2033     // Owner or public sale active modifier
2034     modifier whenOwnerOrPublicSaleActive() {
2035         require(
2036             owner() == _msgSender() || publicSaleActive,
2037             "Public sale is not active"
2038         );
2039         _;
2040     }
2041 
2042     // -- Constructor --//
2043     constructor(string memory _baseTokenURI) ERC721(TOKEN_NAME, TOKEN_SYMBOL) {
2044         baseTokenURI = _baseTokenURI;
2045 
2046         // Setup intial tiers and tiers info
2047         Tier[3] memory allTiersArrayMem = [tier1, tier2, tier3];
2048         TierInfo[3] memory allTiersInfoArrayMem = [
2049             tier1Info,
2050             tier2Info,
2051             tier3Info
2052         ];
2053 
2054         for (uint256 i = 0; i < allTiersArrayMem.length; i++) {
2055             uint256 tierId = allTiersArrayMem[i].id;
2056 
2057             // Tier arrays
2058             allTiersArray.push(allTiersArrayMem[i]);
2059             allTiersInfoArray.push(allTiersInfoArrayMem[i]);
2060 
2061             allTierIds.push(tierId);
2062 
2063             // Tier mappings
2064             allTiers[tierId] = allTiersArray[i];
2065             allTiersInfo[tierId] = allTiersInfoArray[i];
2066         }
2067     }
2068 
2069     // -- External Functions -- //
2070 
2071     // Start public sale
2072     function startPublicSale() external onlyOwner whenPublicSaleNotActive {
2073         publicSaleStartTime = block.timestamp;
2074         publicSaleActive = true;
2075         emit PublicSaleStart(publicSaleStartTime);
2076     }
2077 
2078     // Set this value to the block.timestamp you'd like to reset to
2079     // Created as a way to fast foward in time for tier timing unit tests
2080     // Can also be used if needing to pause and restart public sale from original start time (returned in startPublicSale() above)
2081     function setPublicSaleStartTime(uint256 _publicSaleStartTime)
2082         external
2083         onlyOwner
2084     {
2085         publicSaleStartTime = _publicSaleStartTime;
2086         emit PublicSaleStart(publicSaleStartTime);
2087     }
2088 
2089     // Toggle public sale
2090     function togglePublicSaleActive() external onlyOwner {
2091         publicSaleActive = !publicSaleActive;
2092         emit PublicSaleActive(publicSaleActive);
2093     }
2094 
2095     // Pause public sale
2096     function pausePublicSale() external onlyOwner whenPublicSaleActive {
2097         publicSaleActive = false;
2098         emit PublicSalePaused(getElapsedSaleTime());
2099     }
2100 
2101     // End tier sale
2102     function setTierSaleEnded(uint256 _tierId, bool _saleEnded)
2103         external
2104         onlyOwner
2105         whenPublicSaleActive
2106     {
2107         allTiersInfo[_tierId].saleEnded = _saleEnded;
2108     }
2109 
2110     // Get all tiers
2111     function getAllTiers() external view returns (Tier[] memory) {
2112         return allTiersArray;
2113     }
2114 
2115     // Get all tiers info
2116     function getAllTiersInfo()
2117         external
2118         view
2119         onlyOwner
2120         returns (TierInfo[] memory)
2121     {
2122         return allTiersInfoArray;
2123     }
2124 
2125     // Support royalty info - See {EIP-2981}: https://eips.ethereum.org/EIPS/eip-2981
2126     function royaltyInfo(uint256, uint256 _salePrice)
2127         external
2128         view
2129         returns (address receiver, uint256 royaltyAmount)
2130     {
2131         return (
2132             royaltyAddress,
2133             (_salePrice.mul(royaltyBasisPoints)).div(10000)
2134         );
2135     }
2136 
2137     // Adds multiple address to presale whitelist for specific tier
2138     function addToPresaleWhitelist(uint256 _tierId, address[] memory _addresses)
2139         external
2140         onlyOwner
2141     {
2142         Tier memory tier = allTiers[_tierId];
2143 
2144         require(tier.id == _tierId, "Invalid tier");
2145 
2146         for (uint256 i = 0; i < _addresses.length; i++) {
2147             address _address = _addresses[i];
2148 
2149             uint256[] storage tierIds = presaleWhitelist[_address];
2150 
2151             bool exists = false;
2152             for (uint256 j = 0; j < tierIds.length; j++) {
2153                 if (tierIds[j] == tier.id) {
2154                     exists = true;
2155                 }
2156             }
2157 
2158             if (!exists) {
2159                 tierIds.push(tier.id);
2160             }
2161 
2162             presaleWhitelist[_address] = tierIds;
2163         }
2164     }
2165 
2166     // Removes single address from whitelist for specific tier
2167     function removeFromPresaleWhitelist(uint256 _tierId, address _address)
2168         external
2169         onlyOwner
2170     {
2171         Tier memory tier = allTiers[_tierId];
2172 
2173         require(tier.id == _tierId, "Invalid tier");
2174 
2175         uint256[] storage tierIds = presaleWhitelist[_address];
2176 
2177         // Loop over each tier id
2178         for (uint256 i = 0; i < tierIds.length; i++) {
2179             if (tierIds[i] == tier.id) {
2180                 // If tier id is found, replace with last tier id
2181                 tierIds[i] = tierIds[tierIds.length - 1];
2182             }
2183         }
2184 
2185         // Remove last tier id, since it replaced the matched tier id
2186         tierIds.pop();
2187 
2188         presaleWhitelist[_address] = tierIds;
2189     }
2190 
2191     // Get all tiers address is whitelisted for
2192     function getPresaleWhitelist(address _address)
2193         external
2194         view
2195         onlyOwner
2196         returns (uint256[] memory)
2197     {
2198         return presaleWhitelist[_address];
2199     }
2200 
2201     //-- Public Functions --//
2202 
2203     // Get elapsed sale time
2204     function getElapsedSaleTime() public view returns (uint256) {
2205         return
2206             publicSaleStartTime > 0
2207                 ? block.timestamp.sub(publicSaleStartTime)
2208                 : 0;
2209     }
2210 
2211     // Get remaining closed presale time
2212     function getRemainingClosedPresaleTime(uint256 _tierId)
2213         public
2214         view
2215         whenPublicSaleActive
2216         returns (uint256)
2217     {
2218         Tier memory tier = allTiers[_tierId];
2219 
2220         require(tier.id == _tierId, "Invalid tier");
2221 
2222         // Get elapsed sale time
2223         uint256 elapsed = getElapsedSaleTime();
2224 
2225         // Time logic based on tier and constants
2226         uint256 closedPresaleStart = (tier.id - 1).mul(DURATION_BETWEEN_TIERS);
2227         uint256 closedPresaleEnd = closedPresaleStart.add(
2228             CLOSED_PRESALE_DURATION
2229         );
2230 
2231         // Tier not active
2232         require(elapsed >= closedPresaleStart, "Tier not active");
2233 
2234         // Tier finished presale
2235         if (elapsed >= closedPresaleEnd) {
2236             return 0;
2237         }
2238 
2239         // Elasped time since presale start
2240         uint256 elapsedSinceStart = elapsed.sub(closedPresaleStart);
2241 
2242         // Total duration minus elapsed time since presale start
2243         return CLOSED_PRESALE_DURATION.sub(elapsedSinceStart);
2244     }
2245 
2246     // Get remaining presale time
2247     function getRemainingPresaleTime(uint256 _tierId)
2248         public
2249         view
2250         whenPublicSaleActive
2251         returns (uint256)
2252     {
2253         Tier memory tier = allTiers[_tierId];
2254 
2255         require(tier.id == _tierId, "Invalid tier");
2256 
2257         // Get elapsed sale time
2258         uint256 elapsed = getElapsedSaleTime();
2259 
2260         // Time logic based on tier and constants
2261         uint256 closedPresaleStart = (tier.id - 1).mul(DURATION_BETWEEN_TIERS);
2262         uint256 closedPresaleEnd = closedPresaleStart.add(
2263             CLOSED_PRESALE_DURATION
2264         );
2265         uint256 presaleStart = closedPresaleEnd;
2266         uint256 presaleEnd = presaleStart.add(PRESALE_DURATION);
2267 
2268         // Tier not active
2269         require(elapsed >= presaleStart, "Tier not active");
2270 
2271         // Tier finished presale
2272         if (elapsed >= presaleEnd) {
2273             return 0;
2274         }
2275 
2276         // Elasped time since presale start
2277         uint256 elapsedSinceStart = elapsed.sub(presaleStart);
2278 
2279         // Total duration minus elapsed time since presale start
2280         return PRESALE_DURATION.sub(elapsedSinceStart);
2281     }
2282 
2283     // Get remaining auction time
2284     function getRemainingAuctionTime(uint256 _tierId)
2285         public
2286         view
2287         whenPublicSaleActive
2288         returns (uint256)
2289     {
2290         Tier memory tier = allTiers[_tierId];
2291 
2292         require(tier.id == _tierId, "Invalid tier");
2293 
2294         uint256 elapsed = getElapsedSaleTime();
2295 
2296         // Time logic based on tier and constants
2297         uint256 closedPresaleStart = (tier.id - 1).mul(DURATION_BETWEEN_TIERS);
2298         uint256 closedPresaleEnd = closedPresaleStart.add(
2299             CLOSED_PRESALE_DURATION
2300         );
2301         uint256 presaleStart = closedPresaleEnd;
2302         uint256 presaleEnd = presaleStart.add(PRESALE_DURATION);
2303         uint256 auctionStart = presaleEnd;
2304         uint256 auctionEnd = auctionStart.add(AUCTION_DURATION);
2305 
2306         // Tier not active
2307         require(elapsed >= auctionStart, "Tier not active");
2308 
2309         // Tier finished auction
2310         if (elapsed >= auctionEnd) {
2311             return 0;
2312         }
2313 
2314         // Elasped time since auction start
2315         uint256 elapsedSinceStart = elapsed.sub(auctionStart);
2316 
2317         // Total duration minus elapsed time since auction start
2318         return AUCTION_DURATION.sub(elapsedSinceStart);
2319     }
2320 
2321     // Mint token - requires tier and amount
2322     function mint(
2323         uint256 _tierId,
2324         uint256 _amount,
2325         bytes32 _hash,
2326         bytes memory _signature,
2327         string memory _nonce
2328     ) public payable whenOwnerOrPublicSaleActive {
2329         require(
2330             matchAddressSigner(_hash, _signature),
2331             "Direct mint disallowed"
2332         );
2333         require(!usedNonces[_nonce], "Hash already used");
2334         require(
2335             hashTransaction(_msgSender(), _amount, _nonce) == _hash,
2336             "Hash failed"
2337         );
2338 
2339         Tier memory tier = allTiers[_tierId];
2340         TierInfo memory tierInfo = allTiersInfo[_tierId];
2341 
2342         require(tier.id == _tierId, "Invalid tier");
2343 
2344         // Must mint at least one
2345         require(_amount > 0, "Must mint at least one");
2346 
2347         // Check there enough mints left for tier
2348         require(
2349             getMintsLeft(tier.id).sub(_amount) >= 0,
2350             "Minting would exceed max supply"
2351         );
2352 
2353         // Get current address total balance
2354         uint256 currentTotalAmount = super.balanceOf(_msgSender());
2355 
2356         // Loop over all tokens for address and get current tier count
2357         uint256 currentTierAmount = 0;
2358         for (uint256 i = 0; i < currentTotalAmount; i++) {
2359             uint256 tokenId = super.tokenOfOwnerByIndex(_msgSender(), i);
2360             Tier memory _tokenTier = tokenTier[tokenId];
2361             if (_tokenTier.id == tier.id) {
2362                 currentTierAmount++;
2363             }
2364         }
2365 
2366         uint256 costToMint = 0;
2367         uint256 amount = _amount;
2368 
2369         // Is owner
2370         bool isOwner = owner() == _msgSender();
2371 
2372         // If not owner, check amounts are not more than max amounts
2373         if (!isOwner) {
2374             // Get elapsed sale time
2375             uint256 elapsed = getElapsedSaleTime();
2376 
2377             // Time logic based on tier and constants
2378             uint256 closedPresaleStart = (tier.id - 1).mul(
2379                 DURATION_BETWEEN_TIERS
2380             );
2381             uint256 closedPresaleEnd = closedPresaleStart.add(
2382                 CLOSED_PRESALE_DURATION
2383             );
2384 
2385             // If still in the closed whitelist, do not allow more than max per closed presale
2386             if (elapsed <= closedPresaleEnd) {
2387                 require(
2388                     currentTierAmount.add(amount) <= tierInfo.maxPerClosedPresale,
2389                     "Requested amount exceeds maximum whitelist mint amount"
2390                 );
2391             }
2392 
2393             // Do not allow more than max total mint
2394             require(
2395                 currentTierAmount.add(amount) <= tierInfo.maxTotalMint,
2396                 "Requested amount exceeds maximum total mint amount"
2397             );
2398         }
2399 
2400         // Get cost to mint
2401         costToMint = getMintPrice(tier.id).mul(amount);
2402 
2403         // Check cost to mint for tier, and if enough ETH is passed to mint
2404         require(costToMint <= msg.value, "ETH amount sent is not correct");
2405 
2406         for (uint256 i = 0; i < amount; i++) {
2407             // Token id is tier starting offset plus count of already minted
2408             uint256 tokenId = tierInfo.startingOffset.add(tierCounts[tier.id]);
2409 
2410             // Safe mint
2411             _safeMint(_msgSender(), tokenId);
2412 
2413             // Attribute token id with tier
2414             tokenTier[tokenId] = tier;
2415 
2416             // Store minted at timestamp by token id
2417             tokenMintedAt[tokenId] = block.timestamp;
2418 
2419             // Increment tier counter
2420             tierCounts[tier.id] = tierCounts[tier.id].add(1);
2421         }
2422 
2423         usedNonces[_nonce] = true;
2424 
2425         // Send mint cost to payment address
2426         Address.sendValue(payable(paymentAddress), costToMint);
2427 
2428         // Return unused value
2429         if (msg.value > costToMint) {
2430             Address.sendValue(payable(_msgSender()), msg.value.sub(costToMint));
2431         }
2432     }
2433 
2434     // Burn multiple
2435     function burnMultiple(uint256[] memory _tokenIds) public onlyOwner {
2436         for (uint256 i = 0; i < _tokenIds.length; i++) {
2437             // Token id
2438             uint256 tokenId = _tokenIds[i];
2439 
2440             _burn(tokenId);
2441         }
2442     }
2443 
2444     // Get mint price
2445     function getMintPrice(uint256 _tierId)
2446         public
2447         view
2448         whenOwnerOrPublicSaleActive
2449         returns (uint256)
2450     {
2451         Tier memory tier = allTiers[_tierId];
2452         TierInfo memory tierInfo = allTiersInfo[_tierId];
2453 
2454         require(tier.id == _tierId, "Invalid tier");
2455 
2456         // Is owner
2457         bool isOwner = owner() == _msgSender();
2458 
2459         // If owner, cost is 0
2460         if (isOwner) {
2461             return 0;
2462         }
2463 
2464         uint256 elapsed = getElapsedSaleTime();
2465         uint256 currentPrice = 0;
2466 
2467         // Setup starting and ending prices
2468         uint256 startingPrice = tierInfo.startingPrice;
2469         uint256 endingPrice = tierInfo.endingPrice;
2470 
2471         // Time logic based on tier and constants
2472 
2473         uint256 closedPresaleStart = (tier.id - 1).mul(DURATION_BETWEEN_TIERS);
2474         uint256 closedPresaleEnd = closedPresaleStart.add(
2475             CLOSED_PRESALE_DURATION
2476         );
2477         uint256 presaleStart = closedPresaleEnd;
2478         uint256 presaleEnd = presaleStart.add(PRESALE_DURATION);
2479         uint256 auctionStart = presaleEnd;
2480         uint256 auctionEnd = auctionStart.add(AUCTION_DURATION);
2481 
2482         // Tier not active
2483         require(elapsed >= closedPresaleStart, "Tier not active");
2484 
2485         // Closed presale - starting price
2486         if ((elapsed >= closedPresaleStart) && (elapsed < presaleStart)) {
2487             // Must be in presale whitelist to get price and mint
2488             uint256[] memory whitelistedTiers = presaleWhitelist[_msgSender()];
2489             bool isWhitelisted = false;
2490             for (uint256 i = 0; i < whitelistedTiers.length; i++) {
2491                 if (whitelistedTiers[i] == tier.id) {
2492                     isWhitelisted = true;
2493                 }
2494             }
2495 
2496             require(isWhitelisted, "Tier not active, not whitelisted");
2497             currentPrice = startingPrice;
2498 
2499             // Presale - starting price
2500         } else if ((elapsed >= presaleStart) && (elapsed < presaleEnd)) {
2501             currentPrice = startingPrice;
2502 
2503             // Dutch Auction - price descreses dynamically for duration
2504         } else if ((elapsed >= auctionStart) && (elapsed < auctionEnd)) {
2505             uint256 elapsedSinceAuctionStart = elapsed.sub(auctionStart); // Elapsed time since auction start
2506             uint256 totalPriceDiff = startingPrice.sub(endingPrice); // Total price diff between starting and ending price
2507             uint256 numPriceChanges = AUCTION_DURATION.div(
2508                 AUCTION_PRICE_CHANGE
2509             ).sub(1); // Amount of price changes in the auction
2510             uint256 priceChangeAmount = totalPriceDiff.div(numPriceChanges); // Amount of price change per instance of price change
2511             uint256 elapsedRounded = elapsedSinceAuctionStart.div(
2512                 AUCTION_PRICE_CHANGE
2513             ); // Elapsed time since auction start rounded to auction price change variable
2514             uint256 totalPriceChangeAmount = priceChangeAmount.mul(
2515                 elapsedRounded
2516             ); // Total amount of price change based on time
2517 
2518             currentPrice = startingPrice.sub(totalPriceChangeAmount); // Starting price minus total price change
2519 
2520             // Post auction - ending price
2521         } else if (elapsed >= auctionEnd) {
2522             // Check if tier ended
2523             require(!tierInfo.saleEnded, "Tier not active");
2524 
2525             currentPrice = endingPrice;
2526         }
2527 
2528         // Double check current price is not lower than ending price
2529         return currentPrice < endingPrice ? endingPrice : currentPrice;
2530     }
2531 
2532     // Get mints left for tier
2533     function getMintsLeft(uint256 _tierId)
2534         public
2535         view
2536         whenOwnerOrPublicSaleActive
2537         returns (uint256)
2538     {
2539         Tier memory tier = allTiers[_tierId];
2540         TierInfo memory tierInfo = allTiersInfo[_tierId];
2541 
2542         require(tier.id == _tierId, "Invalid tier");
2543 
2544         // Get tier total supplys and counts
2545         uint256 tierSupply = tierInfo.totalSupply;
2546         uint256 tierCount = tierCounts[tier.id];
2547 
2548         return tierSupply.sub(tierCount);
2549     }
2550 
2551     function setPaymentAddress(address _address) public onlyOwner {
2552         paymentAddress = _address;
2553     }
2554 
2555     function setSignerAddress(address _address) public onlyOwner {
2556         signerAddress = _address;
2557     }
2558 
2559     // Set royalty wallet address
2560     function setRoyaltyAddress(address _address) public onlyOwner {
2561         royaltyAddress = _address;
2562     }
2563 
2564     // Set royalty basis points
2565     function setRoyaltyBasisPoints(uint256 _basisPoints) public onlyOwner {
2566         royaltyBasisPoints = _basisPoints;
2567         emit RoyaltyBasisPoints(_basisPoints);
2568     }
2569 
2570     // Set base URI
2571     function setBaseURI(string memory _uri) public onlyOwner {
2572         baseTokenURI = _uri;
2573     }
2574 
2575     function setBaseURIForMetadata(string memory _uri) public onlyOwner {
2576         baseTokenURIForMetadata = _uri;
2577     }
2578 
2579     // Append token metadata
2580     function appendTokenMetadata(uint256 _tokenId, bytes32 _metadataHash)
2581         public
2582         onlyOwner
2583     {
2584         require(_exists(_tokenId), "Nonexistent token");
2585 
2586         tokenMetadata[_tokenId].push(_metadataHash);
2587     }
2588 
2589     // Get all token metadata changes
2590     function getTokenMetadata(uint256 _tokenId)
2591         public
2592         view
2593         returns (bytes32[] memory)
2594     {
2595         require(_exists(_tokenId), "Nonexistent token");
2596 
2597         return tokenMetadata[_tokenId];
2598     }
2599 
2600     // Token URI (baseTokenURI + tokenId)
2601     function tokenURI(uint256 _tokenId)
2602         public
2603         view
2604         virtual
2605         override
2606         returns (string memory)
2607     {
2608         require(_exists(_tokenId), "Nonexistent token");
2609 
2610         uint256 tokenMetadataLength = tokenMetadata[_tokenId].length;
2611 
2612         if (tokenMetadataLength > 0) {
2613             uint256 _lastMetadataHash = uint256(
2614                 tokenMetadata[_tokenId][tokenMetadataLength - 1]
2615             );
2616 
2617             // IPFS CID V1 is too long for Solidity byte32 but it contains the same prefix "f01551220" if it was added to IPFS with the same codec and hash function.
2618             // IPFS CID V1 Multihash example: bafkreif7gr5yvy5p65nbozy7o3f7m2tt2jkyhp5fgpd4cg5ljl4e7ohxxq
2619             // Explorer: https://cid.ipfs.io/#bafkreif7gr5yvy5p65nbozy7o3f7m2tt2jkyhp5fgpd4cg5ljl4e7ohxxq
2620             // It's prefix (f01551220) + SHA256 hash (BF347B8AE3AFF75A17671F76CBF66A73D25583BFA533C7C11BAB4AF84FB8F7BC)
2621             // List of codes: https://github.com/multiformats/multicodec/blob/master/table.csv
2622             // Prefix format: IPFS specific byte (f) + CID V1 (01) + multicodec code (0x55 for raw) + hash function code (0x12 for SHA256) + length (0x20 for 256-bits)
2623             // Final: f017012200C39FEAEE65382EFEDE80ED763CC922B280AE2A2A403C24FEE73B36D8A6AC7F7
2624             // Addressable as usual: http://ipfs.io/ipfs/f015512200874F3B3FEE8BFE197A86AB9F676F6246248B8FFE1F81111D1C44B11D41173CD
2625             // That way we can strip meaningless for blockchain "f01701220" and save huge amount of gas by storing it efficiently in byte32.
2626             // IMPORTANT: JSON files up to 256KB always have 0x55 (raw) codec.
2627 
2628             return
2629                 string(
2630                     abi.encodePacked(
2631                         abi.encodePacked(baseTokenURIForMetadata, IPFS_PREFIX),
2632                         uintToHexString(_lastMetadataHash, 32)
2633                     )
2634                 );
2635         }
2636         return
2637             string(abi.encodePacked(_baseURI(), "token/", _tokenId.toString()));
2638     }
2639 
2640     // Contract metadata URI - Support for OpenSea: https://docs.opensea.io/docs/contract-level-metadata
2641     function contractURI() public view returns (string memory) {
2642         return string(abi.encodePacked(_baseURI(), "contract"));
2643     }
2644 
2645     // Override supportsInterface - See {IERC165-supportsInterface}
2646     function supportsInterface(bytes4 _interfaceId)
2647         public
2648         view
2649         virtual
2650         override(ERC721, ERC721Enumerable)
2651         returns (bool)
2652     {
2653         return super.supportsInterface(_interfaceId);
2654     }
2655 
2656     // Pauses all token transfers - See {ERC721Pausable}
2657     function pause() public virtual onlyOwner {
2658         _pause();
2659     }
2660 
2661     // Unpauses all token transfers - See {ERC721Pausable}
2662     function unpause() public virtual onlyOwner {
2663         _unpause();
2664     }
2665 
2666     //-- Private Functions --/
2667 
2668     // Hash transaction
2669     function hashTransaction(
2670         address _sender,
2671         uint256 _amount,
2672         string memory _nonce
2673     ) private pure returns (bytes32) {
2674         bytes32 hash = keccak256(
2675             abi.encodePacked(
2676                 "\x19Ethereum Signed Message:\n32",
2677                 keccak256(abi.encodePacked(_sender, _amount, _nonce))
2678             )
2679         );
2680 
2681         return hash;
2682     }
2683 
2684     // Match address signer
2685     function matchAddressSigner(bytes32 _hash, bytes memory _signature)
2686         private
2687         view
2688         returns (bool)
2689     {
2690         return signerAddress == _hash.recover(_signature);
2691     }
2692 
2693     //-- Internal Functions --//
2694 
2695     // Get base URI
2696     function _baseURI() internal view override returns (string memory) {
2697         return baseTokenURI;
2698     }
2699 
2700     // Before all token transfer
2701     function _beforeTokenTransfer(
2702         address _from,
2703         address _to,
2704         uint256 _tokenId
2705     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
2706         // Store token last transfer timestamp by id
2707         tokenLastTransferredAt[_tokenId] = block.timestamp;
2708 
2709         super._beforeTokenTransfer(_from, _to, _tokenId);
2710     }
2711 
2712     // Uint to hex string
2713     function uintToHexString(uint256 value, uint256 length)
2714         internal
2715         pure
2716         returns (string memory)
2717     {
2718         bytes memory buffer = new bytes(2 * length);
2719 
2720         for (uint256 i = 2 * length; i > 0; --i) {
2721             buffer[i - 1] = HEX_ALPHABET[value & 0xf];
2722             value >>= 4;
2723         }
2724         require(value == 0, "Strings: hex length insufficient");
2725         return string(buffer);
2726     }
2727 }