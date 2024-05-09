1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and make it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: contracts/common/Initializable.sol
68 
69 
70 
71 pragma solidity ^0.8.0;
72 
73 contract Initializable {
74     bool inited = false;
75 
76     modifier initializer() {
77         require(!inited, "already inited");
78         _;
79         inited = true;
80     }
81 }
82 // File: contracts/common/EIP712Base.sol
83 
84 
85 
86 pragma solidity ^0.8.0;
87 
88 
89 contract EIP712Base is Initializable {
90     struct EIP712Domain {
91         string name;
92         string version;
93         address verifyingContract;
94         bytes32 salt;
95     }
96 
97     string constant public ERC712_VERSION = "1";
98 
99     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
100         bytes(
101             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
102         )
103     );
104     bytes32 internal domainSeperator;
105 
106     // supposed to be called once while initializing.
107     // one of the contracts that inherits this contract follows proxy pattern
108     // so it is not possible to do this in a constructor
109     function _initializeEIP712(
110         string memory name
111     )
112         internal
113         initializer
114     {
115         _setDomainSeperator(name);
116     }
117 
118     function _setDomainSeperator(string memory name) internal {
119         domainSeperator = keccak256(
120             abi.encode(
121                 EIP712_DOMAIN_TYPEHASH,
122                 keccak256(bytes(name)),
123                 keccak256(bytes(ERC712_VERSION)),
124                 address(this),
125                 bytes32(getChainId())
126             )
127         );
128     }
129 
130     function getDomainSeperator() public view returns (bytes32) {
131         return domainSeperator;
132     }
133 
134     function getChainId() public view returns (uint256) {
135         uint256 id;
136         assembly {
137             id := chainid()
138         }
139         return id;
140     }
141 
142     /**
143      * Accept message hash and returns hash message in EIP712 compatible form
144      * So that it can be used to recover signer from signature signed using EIP712 formatted data
145      * https://eips.ethereum.org/EIPS/eip-712
146      * "\\x19" makes the encoding deterministic
147      * "\\x01" is the version byte to make it compatible to EIP-191
148      */
149     function toTypedMessageHash(bytes32 messageHash)
150         internal
151         view
152         returns (bytes32)
153     {
154         return
155             keccak256(
156                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
157             );
158     }
159 }
160 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
161 
162 
163 
164 pragma solidity ^0.8.0;
165 
166 // CAUTION
167 // This version of SafeMath should only be used with Solidity 0.8 or later,
168 // because it relies on the compiler's built in overflow checks.
169 
170 /**
171  * @dev Wrappers over Solidity's arithmetic operations.
172  *
173  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
174  * now has built in overflow checking.
175  */
176 library SafeMath {
177     /**
178      * @dev Returns the addition of two unsigned integers, with an overflow flag.
179      *
180      * _Available since v3.4._
181      */
182     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         unchecked {
184             uint256 c = a + b;
185             if (c < a) return (false, 0);
186             return (true, c);
187         }
188     }
189 
190     /**
191      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
192      *
193      * _Available since v3.4._
194      */
195     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
196         unchecked {
197             if (b > a) return (false, 0);
198             return (true, a - b);
199         }
200     }
201 
202     /**
203      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
204      *
205      * _Available since v3.4._
206      */
207     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
208         unchecked {
209             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
210             // benefit is lost if 'b' is also tested.
211             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
212             if (a == 0) return (true, 0);
213             uint256 c = a * b;
214             if (c / a != b) return (false, 0);
215             return (true, c);
216         }
217     }
218 
219     /**
220      * @dev Returns the division of two unsigned integers, with a division by zero flag.
221      *
222      * _Available since v3.4._
223      */
224     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         unchecked {
226             if (b == 0) return (false, 0);
227             return (true, a / b);
228         }
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             if (b == 0) return (false, 0);
239             return (true, a % b);
240         }
241     }
242 
243     /**
244      * @dev Returns the addition of two unsigned integers, reverting on
245      * overflow.
246      *
247      * Counterpart to Solidity's `+` operator.
248      *
249      * Requirements:
250      *
251      * - Addition cannot overflow.
252      */
253     function add(uint256 a, uint256 b) internal pure returns (uint256) {
254         return a + b;
255     }
256 
257     /**
258      * @dev Returns the subtraction of two unsigned integers, reverting on
259      * overflow (when the result is negative).
260      *
261      * Counterpart to Solidity's `-` operator.
262      *
263      * Requirements:
264      *
265      * - Subtraction cannot overflow.
266      */
267     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a - b;
269     }
270 
271     /**
272      * @dev Returns the multiplication of two unsigned integers, reverting on
273      * overflow.
274      *
275      * Counterpart to Solidity's `*` operator.
276      *
277      * Requirements:
278      *
279      * - Multiplication cannot overflow.
280      */
281     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a * b;
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers, reverting on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator.
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function div(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a / b;
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
301      * reverting when dividing by zero.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a % b;
313     }
314 
315     /**
316      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
317      * overflow (when the result is negative).
318      *
319      * CAUTION: This function is deprecated because it requires allocating memory for the error
320      * message unnecessarily. For custom revert reasons use {trySub}.
321      *
322      * Counterpart to Solidity's `-` operator.
323      *
324      * Requirements:
325      *
326      * - Subtraction cannot overflow.
327      */
328     function sub(
329         uint256 a,
330         uint256 b,
331         string memory errorMessage
332     ) internal pure returns (uint256) {
333         unchecked {
334             require(b <= a, errorMessage);
335             return a - b;
336         }
337     }
338 
339     /**
340      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
341      * division by zero. The result is rounded towards zero.
342      *
343      * Counterpart to Solidity's `/` operator. Note: this function uses a
344      * `revert` opcode (which leaves remaining gas untouched) while Solidity
345      * uses an invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      *
349      * - The divisor cannot be zero.
350      */
351     function div(
352         uint256 a,
353         uint256 b,
354         string memory errorMessage
355     ) internal pure returns (uint256) {
356         unchecked {
357             require(b > 0, errorMessage);
358             return a / b;
359         }
360     }
361 
362     /**
363      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
364      * reverting with custom message when dividing by zero.
365      *
366      * CAUTION: This function is deprecated because it requires allocating memory for the error
367      * message unnecessarily. For custom revert reasons use {tryMod}.
368      *
369      * Counterpart to Solidity's `%` operator. This function uses a `revert`
370      * opcode (which leaves remaining gas untouched) while Solidity uses an
371      * invalid opcode to revert (consuming all remaining gas).
372      *
373      * Requirements:
374      *
375      * - The divisor cannot be zero.
376      */
377     function mod(
378         uint256 a,
379         uint256 b,
380         string memory errorMessage
381     ) internal pure returns (uint256) {
382         unchecked {
383             require(b > 0, errorMessage);
384             return a % b;
385         }
386     }
387 }
388 
389 // File: contracts/common/NativeMetaTransaction.sol
390 
391 
392 
393 pragma solidity ^0.8.0;
394 
395 
396 
397 contract NativeMetaTransaction is EIP712Base {
398     using SafeMath for uint256;
399     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
400         bytes(
401             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
402         )
403     );
404     event MetaTransactionExecuted(
405         address userAddress,
406         address payable relayerAddress,
407         bytes functionSignature
408     );
409     mapping(address => uint256) nonces;
410 
411     /*
412      * Meta transaction structure.
413      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
414      * He should call the desired function directly in that case.
415      */
416     struct MetaTransaction {
417         uint256 nonce;
418         address from;
419         bytes functionSignature;
420     }
421 
422     function executeMetaTransaction(
423         address userAddress,
424         bytes memory functionSignature,
425         bytes32 sigR,
426         bytes32 sigS,
427         uint8 sigV
428     ) public payable returns (bytes memory) {
429         MetaTransaction memory metaTx = MetaTransaction({
430             nonce: nonces[userAddress],
431             from: userAddress,
432             functionSignature: functionSignature
433         });
434 
435         require(
436             verify(userAddress, metaTx, sigR, sigS, sigV),
437             "Signer and signature do not match"
438         );
439 
440         // increase nonce for user (to avoid re-use)
441         nonces[userAddress] = nonces[userAddress].add(1);
442 
443         emit MetaTransactionExecuted(
444             userAddress,
445             payable(msg.sender),
446             functionSignature
447         );
448 
449         // Append userAddress and relayer address at the end to extract it from calling context
450         (bool success, bytes memory returnData) = address(this).call(
451             abi.encodePacked(functionSignature, userAddress)
452         );
453         require(success, "Function call not successful");
454 
455         return returnData;
456     }
457 
458     function hashMetaTransaction(MetaTransaction memory metaTx)
459         internal
460         pure
461         returns (bytes32)
462     {
463         return
464             keccak256(
465                 abi.encode(
466                     META_TRANSACTION_TYPEHASH,
467                     metaTx.nonce,
468                     metaTx.from,
469                     keccak256(metaTx.functionSignature)
470                 )
471             );
472     }
473 
474     function getNonce(address user) public view returns (uint256 nonce) {
475         nonce = nonces[user];
476     }
477 
478     function verify(
479         address signer,
480         MetaTransaction memory metaTx,
481         bytes32 sigR,
482         bytes32 sigS,
483         uint8 sigV
484     ) internal view returns (bool) {
485         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
486         return
487             signer ==
488             ecrecover(
489                 toTypedMessageHash(hashMetaTransaction(metaTx)),
490                 sigV,
491                 sigR,
492                 sigS
493             );
494     }
495 }
496 // File: contracts/common/ContextMixin.sol
497 
498 
499 
500 pragma solidity ^0.8.0;
501 
502 abstract contract ContextMixin {
503     function msgSender()
504         internal
505         view
506         returns (address payable sender)
507     {
508         if (msg.sender == address(this)) {
509             bytes memory array = msg.data;
510             uint256 index = msg.data.length;
511             assembly {
512                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
513                 sender := and(
514                     mload(add(array, index)),
515                     0xffffffffffffffffffffffffffffffffffffffff
516                 )
517             }
518         } else {
519             sender = payable(msg.sender);
520         }
521         return sender;
522     }
523 }
524 // File: @openzeppelin/contracts/utils/Strings.sol
525 
526 
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev String operations.
532  */
533 library Strings {
534     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
535 
536     /**
537      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
538      */
539     function toString(uint256 value) internal pure returns (string memory) {
540         // Inspired by OraclizeAPI's implementation - MIT licence
541         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
542 
543         if (value == 0) {
544             return "0";
545         }
546         uint256 temp = value;
547         uint256 digits;
548         while (temp != 0) {
549             digits++;
550             temp /= 10;
551         }
552         bytes memory buffer = new bytes(digits);
553         while (value != 0) {
554             digits -= 1;
555             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
556             value /= 10;
557         }
558         return string(buffer);
559     }
560 
561     /**
562      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
563      */
564     function toHexString(uint256 value) internal pure returns (string memory) {
565         if (value == 0) {
566             return "0x00";
567         }
568         uint256 temp = value;
569         uint256 length = 0;
570         while (temp != 0) {
571             length++;
572             temp >>= 8;
573         }
574         return toHexString(value, length);
575     }
576 
577     /**
578      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
579      */
580     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
581         bytes memory buffer = new bytes(2 * length + 2);
582         buffer[0] = "0";
583         buffer[1] = "x";
584         for (uint256 i = 2 * length + 1; i > 1; --i) {
585             buffer[i] = _HEX_SYMBOLS[value & 0xf];
586             value >>= 4;
587         }
588         require(value == 0, "Strings: hex length insufficient");
589         return string(buffer);
590     }
591 }
592 
593 // File: @openzeppelin/contracts/utils/Context.sol
594 
595 
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @dev Provides information about the current execution context, including the
601  * sender of the transaction and its data. While these are generally available
602  * via msg.sender and msg.data, they should not be accessed in such a direct
603  * manner, since when dealing with meta-transactions the account sending and
604  * paying for execution may not be the actual sender (as far as an application
605  * is concerned).
606  *
607  * This contract is only required for intermediate, library-like contracts.
608  */
609 abstract contract Context {
610     function _msgSender() internal view virtual returns (address) {
611         return msg.sender;
612     }
613 
614     function _msgData() internal view virtual returns (bytes calldata) {
615         return msg.data;
616     }
617 }
618 
619 // File: @openzeppelin/contracts/access/Ownable.sol
620 
621 
622 
623 pragma solidity ^0.8.0;
624 
625 
626 /**
627  * @dev Contract module which provides a basic access control mechanism, where
628  * there is an account (an owner) that can be granted exclusive access to
629  * specific functions.
630  *
631  * By default, the owner account will be the one that deploys the contract. This
632  * can later be changed with {transferOwnership}.
633  *
634  * This module is used through inheritance. It will make available the modifier
635  * `onlyOwner`, which can be applied to your functions to restrict their use to
636  * the owner.
637  */
638 abstract contract Ownable is Context {
639     address private _owner;
640 
641     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
642 
643     /**
644      * @dev Initializes the contract setting the deployer as the initial owner.
645      */
646     constructor() {
647         _setOwner(_msgSender());
648     }
649 
650     /**
651      * @dev Returns the address of the current owner.
652      */
653     function owner() public view virtual returns (address) {
654         return _owner;
655     }
656 
657     /**
658      * @dev Throws if called by any account other than the owner.
659      */
660     modifier onlyOwner() {
661         require(owner() == _msgSender(), "Ownable: caller is not the owner");
662         _;
663     }
664 
665     /**
666      * @dev Leaves the contract without owner. It will not be possible to call
667      * `onlyOwner` functions anymore. Can only be called by the current owner.
668      *
669      * NOTE: Renouncing ownership will leave the contract without an owner,
670      * thereby removing any functionality that is only available to the owner.
671      */
672     function renounceOwnership() public virtual onlyOwner {
673         _setOwner(address(0));
674     }
675 
676     /**
677      * @dev Transfers ownership of the contract to a new account (`newOwner`).
678      * Can only be called by the current owner.
679      */
680     function transferOwnership(address newOwner) public virtual onlyOwner {
681         require(newOwner != address(0), "Ownable: new owner is the zero address");
682         _setOwner(newOwner);
683     }
684 
685     function _setOwner(address newOwner) private {
686         address oldOwner = _owner;
687         _owner = newOwner;
688         emit OwnershipTransferred(oldOwner, newOwner);
689     }
690 }
691 
692 // File: @openzeppelin/contracts/utils/Address.sol
693 
694 
695 
696 pragma solidity ^0.8.0;
697 
698 /**
699  * @dev Collection of functions related to the address type
700  */
701 library Address {
702     /**
703      * @dev Returns true if `account` is a contract.
704      *
705      * [IMPORTANT]
706      * ====
707      * It is unsafe to assume that an address for which this function returns
708      * false is an externally-owned account (EOA) and not a contract.
709      *
710      * Among others, `isContract` will return false for the following
711      * types of addresses:
712      *
713      *  - an externally-owned account
714      *  - a contract in construction
715      *  - an address where a contract will be created
716      *  - an address where a contract lived, but was destroyed
717      * ====
718      */
719     function isContract(address account) internal view returns (bool) {
720         // This method relies on extcodesize, which returns 0 for contracts in
721         // construction, since the code is only stored at the end of the
722         // constructor execution.
723 
724         uint256 size;
725         assembly {
726             size := extcodesize(account)
727         }
728         return size > 0;
729     }
730 
731     /**
732      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
733      * `recipient`, forwarding all available gas and reverting on errors.
734      *
735      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
736      * of certain opcodes, possibly making contracts go over the 2300 gas limit
737      * imposed by `transfer`, making them unable to receive funds via
738      * `transfer`. {sendValue} removes this limitation.
739      *
740      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
741      *
742      * IMPORTANT: because control is transferred to `recipient`, care must be
743      * taken to not create reentrancy vulnerabilities. Consider using
744      * {ReentrancyGuard} or the
745      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
746      */
747     function sendValue(address payable recipient, uint256 amount) internal {
748         require(address(this).balance >= amount, "Address: insufficient balance");
749 
750         (bool success, ) = recipient.call{value: amount}("");
751         require(success, "Address: unable to send value, recipient may have reverted");
752     }
753 
754     /**
755      * @dev Performs a Solidity function call using a low level `call`. A
756      * plain `call` is an unsafe replacement for a function call: use this
757      * function instead.
758      *
759      * If `target` reverts with a revert reason, it is bubbled up by this
760      * function (like regular Solidity function calls).
761      *
762      * Returns the raw returned data. To convert to the expected return value,
763      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
764      *
765      * Requirements:
766      *
767      * - `target` must be a contract.
768      * - calling `target` with `data` must not revert.
769      *
770      * _Available since v3.1._
771      */
772     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
773         return functionCall(target, data, "Address: low-level call failed");
774     }
775 
776     /**
777      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
778      * `errorMessage` as a fallback revert reason when `target` reverts.
779      *
780      * _Available since v3.1._
781      */
782     function functionCall(
783         address target,
784         bytes memory data,
785         string memory errorMessage
786     ) internal returns (bytes memory) {
787         return functionCallWithValue(target, data, 0, errorMessage);
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
792      * but also transferring `value` wei to `target`.
793      *
794      * Requirements:
795      *
796      * - the calling contract must have an ETH balance of at least `value`.
797      * - the called Solidity function must be `payable`.
798      *
799      * _Available since v3.1._
800      */
801     function functionCallWithValue(
802         address target,
803         bytes memory data,
804         uint256 value
805     ) internal returns (bytes memory) {
806         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
807     }
808 
809     /**
810      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
811      * with `errorMessage` as a fallback revert reason when `target` reverts.
812      *
813      * _Available since v3.1._
814      */
815     function functionCallWithValue(
816         address target,
817         bytes memory data,
818         uint256 value,
819         string memory errorMessage
820     ) internal returns (bytes memory) {
821         require(address(this).balance >= value, "Address: insufficient balance for call");
822         require(isContract(target), "Address: call to non-contract");
823 
824         (bool success, bytes memory returndata) = target.call{value: value}(data);
825         return verifyCallResult(success, returndata, errorMessage);
826     }
827 
828     /**
829      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
830      * but performing a static call.
831      *
832      * _Available since v3.3._
833      */
834     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
835         return functionStaticCall(target, data, "Address: low-level static call failed");
836     }
837 
838     /**
839      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
840      * but performing a static call.
841      *
842      * _Available since v3.3._
843      */
844     function functionStaticCall(
845         address target,
846         bytes memory data,
847         string memory errorMessage
848     ) internal view returns (bytes memory) {
849         require(isContract(target), "Address: static call to non-contract");
850 
851         (bool success, bytes memory returndata) = target.staticcall(data);
852         return verifyCallResult(success, returndata, errorMessage);
853     }
854 
855     /**
856      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
857      * but performing a delegate call.
858      *
859      * _Available since v3.4._
860      */
861     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
862         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
863     }
864 
865     /**
866      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
867      * but performing a delegate call.
868      *
869      * _Available since v3.4._
870      */
871     function functionDelegateCall(
872         address target,
873         bytes memory data,
874         string memory errorMessage
875     ) internal returns (bytes memory) {
876         require(isContract(target), "Address: delegate call to non-contract");
877 
878         (bool success, bytes memory returndata) = target.delegatecall(data);
879         return verifyCallResult(success, returndata, errorMessage);
880     }
881 
882     /**
883      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
884      * revert reason using the provided one.
885      *
886      * _Available since v4.3._
887      */
888     function verifyCallResult(
889         bool success,
890         bytes memory returndata,
891         string memory errorMessage
892     ) internal pure returns (bytes memory) {
893         if (success) {
894             return returndata;
895         } else {
896             // Look for revert reason and bubble it up if present
897             if (returndata.length > 0) {
898                 // The easiest way to bubble the revert reason is using memory via assembly
899 
900                 assembly {
901                     let returndata_size := mload(returndata)
902                     revert(add(32, returndata), returndata_size)
903                 }
904             } else {
905                 revert(errorMessage);
906             }
907         }
908     }
909 }
910 
911 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
912 
913 
914 
915 pragma solidity ^0.8.0;
916 
917 
918 
919 
920 /**
921  * @title PaymentSplitter
922  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
923  * that the Ether will be split in this way, since it is handled transparently by the contract.
924  *
925  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
926  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
927  * an amount proportional to the percentage of total shares they were assigned.
928  *
929  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
930  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
931  * function.
932  */
933 contract PaymentSplitter is Context {
934     event PayeeAdded(address account, uint256 shares);
935     event PaymentReleased(address to, uint256 amount);
936     event PaymentReceived(address from, uint256 amount);
937 
938     uint256 private _totalShares;
939     uint256 private _totalReleased;
940 
941     mapping(address => uint256) private _shares;
942     mapping(address => uint256) private _released;
943     address[] private _payees;
944 
945     /**
946      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
947      * the matching position in the `shares` array.
948      *
949      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
950      * duplicates in `payees`.
951      */
952     constructor(address[] memory payees, uint256[] memory shares_) payable {
953         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
954         require(payees.length > 0, "PaymentSplitter: no payees");
955 
956         for (uint256 i = 0; i < payees.length; i++) {
957             _addPayee(payees[i], shares_[i]);
958         }
959     }
960 
961     /**
962      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
963      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
964      * reliability of the events, and not the actual splitting of Ether.
965      *
966      * To learn more about this see the Solidity documentation for
967      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
968      * functions].
969      */
970     receive() external payable virtual {
971         emit PaymentReceived(_msgSender(), msg.value);
972     }
973 
974     /**
975      * @dev Getter for the total shares held by payees.
976      */
977     function totalShares() public view returns (uint256) {
978         return _totalShares;
979     }
980 
981     /**
982      * @dev Getter for the total amount of Ether already released.
983      */
984     function totalReleased() public view returns (uint256) {
985         return _totalReleased;
986     }
987 
988     /**
989      * @dev Getter for the amount of shares held by an account.
990      */
991     function shares(address account) public view returns (uint256) {
992         return _shares[account];
993     }
994 
995     /**
996      * @dev Getter for the amount of Ether already released to a payee.
997      */
998     function released(address account) public view returns (uint256) {
999         return _released[account];
1000     }
1001 
1002     /**
1003      * @dev Getter for the address of the payee number `index`.
1004      */
1005     function payee(uint256 index) public view returns (address) {
1006         return _payees[index];
1007     }
1008 
1009     /**
1010      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1011      * total shares and their previous withdrawals.
1012      */
1013     function release(address payable account) public virtual {
1014         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1015 
1016         uint256 totalReceived = address(this).balance + _totalReleased;
1017         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
1018 
1019         require(payment != 0, "PaymentSplitter: account is not due payment");
1020 
1021         _released[account] = _released[account] + payment;
1022         _totalReleased = _totalReleased + payment;
1023 
1024         Address.sendValue(account, payment);
1025         emit PaymentReleased(account, payment);
1026     }
1027 
1028     /**
1029      * @dev Add a new payee to the contract.
1030      * @param account The address of the payee to add.
1031      * @param shares_ The number of shares owned by the payee.
1032      */
1033     function _addPayee(address account, uint256 shares_) private {
1034         require(account != address(0), "PaymentSplitter: account is the zero address");
1035         require(shares_ > 0, "PaymentSplitter: shares are 0");
1036         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1037 
1038         _payees.push(account);
1039         _shares[account] = shares_;
1040         _totalShares = _totalShares + shares_;
1041         emit PayeeAdded(account, shares_);
1042     }
1043 }
1044 
1045 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1046 
1047 
1048 
1049 pragma solidity ^0.8.0;
1050 
1051 /**
1052  * @title ERC721 token receiver interface
1053  * @dev Interface for any contract that wants to support safeTransfers
1054  * from ERC721 asset contracts.
1055  */
1056 interface IERC721Receiver {
1057     /**
1058      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1059      * by `operator` from `from`, this function is called.
1060      *
1061      * It must return its Solidity selector to confirm the token transfer.
1062      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1063      *
1064      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1065      */
1066     function onERC721Received(
1067         address operator,
1068         address from,
1069         uint256 tokenId,
1070         bytes calldata data
1071     ) external returns (bytes4);
1072 }
1073 
1074 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1075 
1076 
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 /**
1081  * @dev Interface of the ERC165 standard, as defined in the
1082  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1083  *
1084  * Implementers can declare support of contract interfaces, which can then be
1085  * queried by others ({ERC165Checker}).
1086  *
1087  * For an implementation, see {ERC165}.
1088  */
1089 interface IERC165 {
1090     /**
1091      * @dev Returns true if this contract implements the interface defined by
1092      * `interfaceId`. See the corresponding
1093      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1094      * to learn more about how these ids are created.
1095      *
1096      * This function call must use less than 30 000 gas.
1097      */
1098     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1099 }
1100 
1101 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1102 
1103 
1104 
1105 pragma solidity ^0.8.0;
1106 
1107 
1108 /**
1109  * @dev Implementation of the {IERC165} interface.
1110  *
1111  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1112  * for the additional interface id that will be supported. For example:
1113  *
1114  * ```solidity
1115  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1116  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1117  * }
1118  * ```
1119  *
1120  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1121  */
1122 abstract contract ERC165 is IERC165 {
1123     /**
1124      * @dev See {IERC165-supportsInterface}.
1125      */
1126     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1127         return interfaceId == type(IERC165).interfaceId;
1128     }
1129 }
1130 
1131 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1132 
1133 
1134 
1135 pragma solidity ^0.8.0;
1136 
1137 
1138 /**
1139  * @dev Required interface of an ERC721 compliant contract.
1140  */
1141 interface IERC721 is IERC165 {
1142     /**
1143      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1144      */
1145     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1146 
1147     /**
1148      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1149      */
1150     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1151 
1152     /**
1153      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1154      */
1155     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1156 
1157     /**
1158      * @dev Returns the number of tokens in ``owner``'s account.
1159      */
1160     function balanceOf(address owner) external view returns (uint256 balance);
1161 
1162     /**
1163      * @dev Returns the owner of the `tokenId` token.
1164      *
1165      * Requirements:
1166      *
1167      * - `tokenId` must exist.
1168      */
1169     function ownerOf(uint256 tokenId) external view returns (address owner);
1170 
1171     /**
1172      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1173      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1174      *
1175      * Requirements:
1176      *
1177      * - `from` cannot be the zero address.
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must exist and be owned by `from`.
1180      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function safeTransferFrom(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) external;
1190 
1191     /**
1192      * @dev Transfers `tokenId` token from `from` to `to`.
1193      *
1194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1195      *
1196      * Requirements:
1197      *
1198      * - `from` cannot be the zero address.
1199      * - `to` cannot be the zero address.
1200      * - `tokenId` token must be owned by `from`.
1201      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function transferFrom(
1206         address from,
1207         address to,
1208         uint256 tokenId
1209     ) external;
1210 
1211     /**
1212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1213      * The approval is cleared when the token is transferred.
1214      *
1215      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1216      *
1217      * Requirements:
1218      *
1219      * - The caller must own the token or be an approved operator.
1220      * - `tokenId` must exist.
1221      *
1222      * Emits an {Approval} event.
1223      */
1224     function approve(address to, uint256 tokenId) external;
1225 
1226     /**
1227      * @dev Returns the account approved for `tokenId` token.
1228      *
1229      * Requirements:
1230      *
1231      * - `tokenId` must exist.
1232      */
1233     function getApproved(uint256 tokenId) external view returns (address operator);
1234 
1235     /**
1236      * @dev Approve or remove `operator` as an operator for the caller.
1237      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1238      *
1239      * Requirements:
1240      *
1241      * - The `operator` cannot be the caller.
1242      *
1243      * Emits an {ApprovalForAll} event.
1244      */
1245     function setApprovalForAll(address operator, bool _approved) external;
1246 
1247     /**
1248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1249      *
1250      * See {setApprovalForAll}
1251      */
1252     function isApprovedForAll(address owner, address operator) external view returns (bool);
1253 
1254     /**
1255      * @dev Safely transfers `tokenId` token from `from` to `to`.
1256      *
1257      * Requirements:
1258      *
1259      * - `from` cannot be the zero address.
1260      * - `to` cannot be the zero address.
1261      * - `tokenId` token must exist and be owned by `from`.
1262      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1263      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1264      *
1265      * Emits a {Transfer} event.
1266      */
1267     function safeTransferFrom(
1268         address from,
1269         address to,
1270         uint256 tokenId,
1271         bytes calldata data
1272     ) external;
1273 }
1274 
1275 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1276 
1277 
1278 
1279 pragma solidity ^0.8.0;
1280 
1281 
1282 /**
1283  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1284  * @dev See https://eips.ethereum.org/EIPS/eip-721
1285  */
1286 interface IERC721Enumerable is IERC721 {
1287     /**
1288      * @dev Returns the total amount of tokens stored by the contract.
1289      */
1290     function totalSupply() external view returns (uint256);
1291 
1292     /**
1293      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1294      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1295      */
1296     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1297 
1298     /**
1299      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1300      * Use along with {totalSupply} to enumerate all tokens.
1301      */
1302     function tokenByIndex(uint256 index) external view returns (uint256);
1303 }
1304 
1305 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1306 
1307 
1308 
1309 pragma solidity ^0.8.0;
1310 
1311 
1312 /**
1313  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1314  * @dev See https://eips.ethereum.org/EIPS/eip-721
1315  */
1316 interface IERC721Metadata is IERC721 {
1317     /**
1318      * @dev Returns the token collection name.
1319      */
1320     function name() external view returns (string memory);
1321 
1322     /**
1323      * @dev Returns the token collection symbol.
1324      */
1325     function symbol() external view returns (string memory);
1326 
1327     /**
1328      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1329      */
1330     function tokenURI(uint256 tokenId) external view returns (string memory);
1331 }
1332 
1333 // File: contracts/ERC721/ERC721S.sol
1334 
1335 
1336 // Forked from: Genetic Chain: ERC721Sequencial
1337 
1338 pragma solidity ^0.8.0;
1339 
1340 //------------------------------------------------------------------------------
1341 /*
1342 ░██████╗░██╗░░░██╗░█████╗░██╗░░░░░██╗███████╗██╗███████╗██████╗░  ██████╗░███████╗██╗░░░██╗░██████╗
1343 ██╔═══██╗██║░░░██║██╔══██╗██║░░░░░██║██╔════╝██║██╔════╝██╔══██╗  ██╔══██╗██╔════╝██║░░░██║██╔════╝
1344 ██║██╗██║██║░░░██║███████║██║░░░░░██║█████╗░░██║█████╗░░██║░░██║  ██║░░██║█████╗░░╚██╗░██╔╝╚█████╗░
1345 ╚██████╔╝██║░░░██║██╔══██║██║░░░░░██║██╔══╝░░██║██╔══╝░░██║░░██║  ██║░░██║██╔══╝░░░╚████╔╝░░╚═══██╗
1346 ░╚═██╔═╝░╚██████╔╝██║░░██║███████╗██║██║░░░░░██║███████╗██████╔╝  ██████╔╝███████╗░░╚██╔╝░░██████╔╝
1347 ░░░╚═╝░░░░╚═════╝░╚═╝░░╚═╝╚══════╝╚═╝╚═╝░░░░░╚═╝╚══════╝╚═════╝░  ╚═════╝░╚══════╝░░░╚═╝░░░╚═════╝░
1348 */
1349 //------------------------------------------------------------------------------
1350 // Author: orion (@OrionDevStar)
1351 //------------------------------------------------------------------------------
1352 
1353 //----------------------------------------------------------------------------
1354 // Openzeppelin contracts
1355 //----------------------------------------------------------------------------
1356 
1357 
1358 
1359 
1360 
1361 
1362 
1363 
1364 //----------------------------------------------------------------------------
1365 // OpenSea proxy
1366 //----------------------------------------------------------------------------
1367 
1368 
1369 
1370 
1371 
1372 //Used to delegate ownership of a contract to another address, to save on unneeded transactions to approve contract use for users
1373 contract OwnableDelegateProxy {}
1374 contract ProxyRegistry {
1375     mapping(address => OwnableDelegateProxy) public proxies;
1376 }
1377 
1378 /**
1379  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721
1380  *  [ERC721] Non-Fungible Token Standard
1381  *
1382  *  This implmentation of ERC721 assumes sequencial token creation to provide
1383  *  efficient minting.  Storage for balance are no longer required reducing
1384  *  gas significantly.  This comes at the price of calculating the balance by
1385  *  iterating through the entire array.  The balanceOf function should NOT
1386  *  be used inside a contract.  Gas usage will explode as the size of tokens
1387  *  increase.  A convineiance function is provided which returns the entire
1388  *  list of owners whose index maps tokenIds to thier owners.  Zero addresses
1389  *  indicate burned tokens.
1390  *
1391  */
1392 contract ERC721S is Context, ERC165, IERC721, IERC721Metadata, ContextMixin, NativeMetaTransaction {
1393     using Address for address;
1394     using Strings for uint256;
1395 
1396     // Token name
1397     string private _name;
1398 
1399     // Token symbol
1400     string private _symbol;
1401 
1402     //Opensea Proxy
1403     address private immutable _proxyRegistryAddress;
1404 
1405     // Mapping from token ID to owner address
1406     address[] _owners;
1407 
1408     // Mapping from token ID to approved address
1409     mapping(uint256 => address) private _tokenApprovals;
1410 
1411     // Mapping from owner to operator approvals
1412     mapping(address => mapping(address => bool)) private _operatorApprovals;
1413 
1414     /**
1415      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1416      */
1417     constructor(string memory name_, string memory symbol_,  address proxyRegistryAddress_) {
1418         _proxyRegistryAddress = proxyRegistryAddress_;
1419         _name = name_;
1420         _symbol = symbol_;
1421     }
1422 
1423     /**
1424      * @dev See {IERC165-supportsInterface}.
1425      */
1426     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1427         return
1428             interfaceId == type(IERC721).interfaceId ||
1429             interfaceId == type(IERC721Metadata).interfaceId ||
1430             super.supportsInterface(interfaceId);
1431     }
1432 
1433     /**
1434      * @dev See {IERC721-balanceOf}.
1435      */
1436     function balanceOf(address owner) public view virtual override returns (uint256 balance) {
1437         require(owner != address(0), "ERC721: balance query for the zero address");
1438 
1439         unchecked {
1440             uint256 length = _owners.length;
1441             for (uint256 i = 0; i < length; ++i) {
1442                 if (_owners[i] == owner) {
1443                     ++balance;
1444                 }
1445             }
1446         }
1447 
1448     }
1449 
1450     /**
1451      * @dev See {IERC721-ownerOf}.
1452      */
1453     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1454         require(_exists(tokenId), "ERC721: owner query for nonexistent token");
1455         address owner = _owners[tokenId];
1456         return owner;
1457     }
1458 
1459     /**
1460      * @dev Returns entire list of owner enumerated by thier tokenIds.  Burned tokens
1461      * will have a zero address.
1462      */
1463     function owners() public view returns (address[] memory) {
1464         address[] memory owners_ = _owners;
1465         return owners_;
1466     }
1467 
1468     /**
1469      * @dev Return largest tokenId minted.
1470      */
1471     function maxTokenId() public view returns (uint256) {
1472         return _owners.length > 0 ? _owners.length - 1 : 0;
1473     }
1474 
1475     /**
1476      * @dev See {IERC721Metadata-name}.
1477      */
1478     function name() public view virtual override returns (string memory) {
1479         return _name;
1480     }
1481 
1482     /**
1483      * @dev See {IERC721Metadata-symbol}.
1484      */
1485     function symbol() public view virtual override returns (string memory) {
1486         return _symbol;
1487     }
1488 
1489     /**
1490      * @dev See {IERC721Metadata-tokenURI}.
1491      */
1492     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1493         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1494 
1495         string memory baseURI = _baseURI();
1496         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1497     }
1498 
1499     /**
1500      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1501      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1502      * by default, can be overriden in child contracts.
1503      */
1504     function _baseURI() internal view virtual returns (string memory) {
1505         return "";
1506     }
1507 
1508     /**
1509      * @dev See {IERC721-approve}.
1510      */
1511     function approve(address to, uint256 tokenId) public virtual override {
1512         address owner = ERC721S.ownerOf(tokenId);
1513         require(to != owner, "ERC721: approval to current owner");
1514 
1515         require(
1516             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1517             "ERC721: approve caller is not owner nor approved for all"
1518         );
1519 
1520         _approve(to, tokenId);
1521     }
1522 
1523     /**
1524      * @dev See {IERC721-getApproved}.
1525      */
1526     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1527         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1528 
1529         return _tokenApprovals[tokenId];
1530     }
1531 
1532     /**
1533      * @dev See {IERC721-setApprovalForAll}.
1534      */
1535     function setApprovalForAll(address operator, bool approved) public virtual override {
1536         _setApprovalForAll(_msgSender(), operator, approved);
1537     }
1538 
1539     /**
1540      * @dev See {IERC721-isApprovedForAll}.
1541      */
1542     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1543         // Whitelist OpenSea proxy contract for easy trading.
1544         ProxyRegistry proxyRegistry = ProxyRegistry(_proxyRegistryAddress);
1545         if (address(proxyRegistry.proxies(owner)) == operator) {
1546             return true;
1547         }
1548 
1549         return _operatorApprovals[owner][operator];
1550     }
1551 
1552     /**
1553      * @dev See {IERC721-transferFrom}.
1554      */
1555     function transferFrom(
1556         address from,
1557         address to,
1558         uint256 tokenId
1559     ) public virtual override {
1560         //solhint-disable-next-line max-line-length
1561         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1562 
1563         _transfer(from, to, tokenId);
1564     }
1565 
1566     /**
1567      * @dev See {IERC721-safeTransferFrom}.
1568      */
1569     function safeTransferFrom(
1570         address from,
1571         address to,
1572         uint256 tokenId
1573     ) public virtual override {
1574         safeTransferFrom(from, to, tokenId, "");
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-safeTransferFrom}.
1579      */
1580     function safeTransferFrom(
1581         address from,
1582         address to,
1583         uint256 tokenId,
1584         bytes memory _data
1585     ) public virtual override {
1586         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1587         _safeTransfer(from, to, tokenId, _data);
1588     }
1589 
1590     /**
1591      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1592      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1593      *
1594      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1595      *
1596      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1597      * implement alternative mechanisms to perform token transfer, such as signature-based.
1598      *
1599      * Requirements:
1600      *
1601      * - `from` cannot be the zero address.
1602      * - `to` cannot be the zero address.
1603      * - `tokenId` token must exist and be owned by `from`.
1604      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function _safeTransfer(
1609         address from,
1610         address to,
1611         uint256 tokenId,
1612         bytes memory _data
1613     ) internal virtual {
1614         _transfer(from, to, tokenId);
1615         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1616     }
1617 
1618     /**
1619      * @dev Returns whether `tokenId` exists.
1620      *
1621      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1622      *
1623      * Tokens start existing when they are minted (`_mint`),
1624      * and stop existing when they are burned (`_burn`).
1625      */
1626     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1627         return tokenId < _owners.length && _owners[tokenId] != address(0);
1628     }
1629 
1630     /**
1631      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1632      *
1633      * Requirements:
1634      *
1635      * - `tokenId` must exist.
1636      */
1637     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1638         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1639         address owner = ERC721S.ownerOf(tokenId);
1640         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1641     }
1642 
1643     /**
1644      * @dev Safely mints `tokenId` and transfers it to `to`.
1645      *
1646      * Requirements:
1647      *
1648      * - `tokenId` must not exist.
1649      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1650      *
1651      * Emits a {Transfer} event.
1652      */
1653     function _safeMint(address to) internal virtual returns (uint256 tokenId) {
1654         tokenId = _safeMint(to, "");
1655     }
1656 
1657     /**
1658      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1659      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1660      */
1661     function _safeMint(
1662         address to,
1663         bytes memory _data
1664     ) internal virtual returns (uint256 tokenId) {
1665         tokenId = _mint(to);
1666         require(
1667             _checkOnERC721Received(address(0), to, tokenId, _data),
1668             "ERC721: transfer to non ERC721Receiver implementer"
1669         );
1670     }
1671 
1672     /**
1673      * @dev Mints `tokenId` and transfers it to `to`.
1674      *
1675      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1676      *
1677      * Requirements:
1678      *
1679      * - `tokenId` must not exist.
1680      * - `to` cannot be the zero address.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684     function _mint(address to) internal virtual returns (uint256 tokenId) {
1685         require(to != address(0), "ERC721: mint to the zero address");
1686         tokenId = _owners.length;
1687 
1688         _beforeTokenTransfer(address(0), to, tokenId);
1689 
1690         _owners.push(to);
1691 
1692         emit Transfer(address(0), to, tokenId);
1693     }
1694 
1695     /**
1696      * @dev Destroys `tokenId`.
1697      * The approval is cleared when the token is burned.
1698      *
1699      * Requirements:
1700      *
1701      * - `tokenId` must exist.
1702      *
1703      * Emits a {Transfer} event.
1704      */
1705     function _burn(uint256 tokenId) internal virtual {
1706         address owner = ERC721S.ownerOf(tokenId);
1707 
1708         _beforeTokenTransfer(owner, address(0), tokenId);
1709 
1710         // Clear approvals
1711         _approve(address(0), tokenId);
1712 
1713         delete _owners[tokenId];
1714 
1715         emit Transfer(owner, address(0), tokenId);
1716     }
1717 
1718     /**
1719      * @dev Transfers `tokenId` from `from` to `to`.
1720      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1721      *
1722      * Requirements:
1723      *
1724      * - `to` cannot be the zero address.
1725      * - `tokenId` token must be owned by `from`.
1726      *
1727      * Emits a {Transfer} event.
1728      */
1729     function _transfer(
1730         address from,
1731         address to,
1732         uint256 tokenId
1733     ) internal virtual {
1734         require(ERC721S.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1735         require(to != address(0), "ERC721: transfer to the zero address");
1736 
1737         _beforeTokenTransfer(from, to, tokenId);
1738 
1739         // Clear approvals from the previous owner
1740         _approve(address(0), tokenId);
1741 
1742         _owners[tokenId] = to;
1743 
1744         emit Transfer(from, to, tokenId);
1745     }
1746 
1747     /**
1748      * @dev Approve `to` to operate on `tokenId`
1749      *
1750      * Emits a {Approval} event.
1751      */
1752     function _approve(address to, uint256 tokenId) internal virtual {
1753         _tokenApprovals[tokenId] = to;
1754         emit Approval(ERC721S.ownerOf(tokenId), to, tokenId);
1755     }
1756 
1757     /**
1758      * @dev Approve `operator` to operate on all of `owner` tokens
1759      *
1760      * Emits a {ApprovalForAll} event.
1761      */
1762     function _setApprovalForAll(
1763         address owner,
1764         address operator,
1765         bool approved
1766     ) internal virtual {
1767         require(owner != operator, "ERC721: approve to caller");
1768         _operatorApprovals[owner][operator] = approved;
1769         emit ApprovalForAll(owner, operator, approved);
1770     }
1771 
1772     /**
1773      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1774      * The call is not executed if the target address is not a contract.
1775      *
1776      * @param from address representing the previous owner of the given token ID
1777      * @param to target address that will receive the tokens
1778      * @param tokenId uint256 ID of the token to be transferred
1779      * @param _data bytes optional data to send along with the call
1780      * @return bool whether the call correctly returned the expected magic value
1781      */
1782     function _checkOnERC721Received(
1783         address from,
1784         address to,
1785         uint256 tokenId,
1786         bytes memory _data
1787     ) private returns (bool) {
1788         if (to.isContract()) {
1789             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1790                 return retval == IERC721Receiver.onERC721Received.selector;
1791             } catch (bytes memory reason) {
1792                 if (reason.length == 0) {
1793                     revert("ERC721: transfer to non ERC721Receiver implementer");
1794                 } else {
1795                     assembly {
1796                         revert(add(32, reason), mload(reason))
1797                     }
1798                 }
1799             }
1800         } else {
1801             return true;
1802         }
1803     }
1804 
1805     /**
1806      * @dev Hook that is called before any token transfer. This includes minting
1807      * and burning.
1808      *
1809      * Calling conditions:
1810      *
1811      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1812      * transferred to `to`.
1813      * - When `from` is zero, `tokenId` will be minted for `to`.
1814      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1815      * - `from` and `to` are never both zero.
1816      *
1817      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1818      */
1819     function _beforeTokenTransfer(
1820         address from,
1821         address to,
1822         uint256 tokenId
1823     ) internal virtual {}
1824 }
1825 // File: contracts/ERC721/ERC721SE.sol
1826 
1827 
1828 // Forked from: Genetic Chain: ERC721SeqEnumerable
1829 
1830 pragma solidity ^0.8.0;
1831 
1832 //------------------------------------------------------------------------------
1833 /*
1834 
1835 ░██████╗░██╗░░░██╗░█████╗░██╗░░░░░██╗███████╗██╗███████╗██████╗░  ██████╗░███████╗██╗░░░██╗░██████╗
1836 ██╔═══██╗██║░░░██║██╔══██╗██║░░░░░██║██╔════╝██║██╔════╝██╔══██╗  ██╔══██╗██╔════╝██║░░░██║██╔════╝
1837 ██║██╗██║██║░░░██║███████║██║░░░░░██║█████╗░░██║█████╗░░██║░░██║  ██║░░██║█████╗░░╚██╗░██╔╝╚█████╗░
1838 ╚██████╔╝██║░░░██║██╔══██║██║░░░░░██║██╔══╝░░██║██╔══╝░░██║░░██║  ██║░░██║██╔══╝░░░╚████╔╝░░╚═══██╗
1839 ░╚═██╔═╝░╚██████╔╝██║░░██║███████╗██║██║░░░░░██║███████╗██████╔╝  ██████╔╝███████╗░░╚██╔╝░░██████╔╝
1840 ░░░╚═╝░░░░╚═════╝░╚═╝░░╚═╝╚══════╝╚═╝╚═╝░░░░░╚═╝╚══════╝╚═════╝░  ╚═════╝░╚══════╝░░░╚═╝░░░╚═════╝░
1841 */
1842 //------------------------------------------------------------------------------
1843 // Author: orion (@OrionDevStar)
1844 //------------------------------------------------------------------------------
1845 
1846 
1847 
1848 /**
1849  * @dev This is a no storage implemntation of the optional extension {ERC721}
1850  * defined in the EIP that adds enumerability of all the token ids in the
1851  * contract as well as all token ids owned by each account. These functions
1852  * are mainly for convienence and should NEVER be called from inside a
1853  * contract on the chain.
1854  */
1855 abstract contract ERC721SE is ERC721S, IERC721Enumerable {
1856     address constant zero = address(0);
1857 
1858     /**
1859      * @dev See {IERC165-supportsInterface}.
1860      */
1861     function supportsInterface(bytes4 interfaceId)
1862         public
1863         view
1864         virtual
1865         override(IERC165, ERC721S)
1866         returns (bool)
1867     {
1868         return
1869             interfaceId == type(IERC721Enumerable).interfaceId ||
1870             super.supportsInterface(interfaceId);
1871     }
1872 
1873     /**
1874      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1875      */
1876     function tokenOfOwnerByIndex(address owner, uint256 index)
1877         public
1878         view
1879         virtual
1880         override
1881         returns (uint256 tokenId)
1882     {
1883         uint256 length = _owners.length;
1884 
1885         unchecked {
1886             for (; tokenId < length; ++tokenId) {
1887                 if (_owners[tokenId] == owner) {
1888                     if (index-- == 0) {
1889                         break;
1890                     }
1891                 }
1892             }
1893         }
1894 
1895         require(
1896             tokenId < length,
1897             "ERC721Enumerable: owner index out of bounds"
1898         );
1899     }
1900 
1901     /**
1902      * @dev See {IERC721Enumerable-totalSupply}.
1903      */
1904     function totalSupply()
1905         public
1906         view
1907         virtual
1908         override
1909         returns (uint256 supply)
1910     {
1911         unchecked {
1912             uint256 length = _owners.length;
1913             for (uint256 tokenId = 0; tokenId < length; ++tokenId) {
1914                 if (_owners[tokenId] != zero) {
1915                     ++supply;
1916                 }
1917             }
1918         }
1919     }
1920 
1921     /**
1922      * @dev See {IERC721Enumerable-tokenByIndex}.
1923      */
1924     function tokenByIndex(uint256 index)
1925         public
1926         view
1927         virtual
1928         override
1929         returns (uint256 tokenId)
1930     {
1931         uint256 length = _owners.length;
1932 
1933         unchecked {
1934             for (; tokenId < length; ++tokenId) {
1935                 if (_owners[tokenId] != zero) {
1936                     if (index-- == 0) {
1937                         break;
1938                     }
1939                 }
1940             }
1941         }
1942 
1943         require(
1944             tokenId < length,
1945             "ERC721Enumerable: global index out of bounds"
1946         );
1947     }
1948 
1949     /**
1950      * @dev Get all tokens owned by owner.
1951      */
1952     function ownerTokens(address owner) public view returns (uint256[] memory) {
1953         uint256 tokenCount = ERC721S.balanceOf(owner);
1954         require(tokenCount != 0, "ERC721Enumerable: owner owns no tokens");
1955 
1956         uint256 length = _owners.length;
1957         uint256[] memory tokenIds = new uint256[](tokenCount);
1958         unchecked {
1959             uint256 i = 0;
1960             for (uint256 tokenId = 0; tokenId < length; ++tokenId) {
1961                 if (_owners[tokenId] == owner) {
1962                     tokenIds[i++] = tokenId;
1963                 }
1964             }
1965         }
1966 
1967         return tokenIds;
1968     }
1969 }
1970 // File: contracts/OddiesCOntract.sol
1971 
1972 
1973 
1974 pragma solidity ^0.8.9;
1975 
1976 /*
1977 ------------------------------------------------------------------------------
1978 
1979 ░█████╗░██████╗░██████╗░██╗███████╗░██████╗  ░█████╗░██╗░░░░░██╗░░░██╗██████╗░
1980 ██╔══██╗██╔══██╗██╔══██╗██║██╔════╝██╔════╝  ██╔══██╗██║░░░░░██║░░░██║██╔══██╗
1981 ██║░░██║██║░░██║██║░░██║██║█████╗░░╚█████╗░  ██║░░╚═╝██║░░░░░██║░░░██║██████╦╝
1982 ██║░░██║██║░░██║██║░░██║██║██╔══╝░░░╚═══██╗  ██║░░██╗██║░░░░░██║░░░██║██╔══██╗
1983 ╚█████╔╝██████╔╝██████╔╝██║███████╗██████╔╝  ╚█████╔╝███████╗╚██████╔╝██████╦╝
1984 ░╚════╝░╚═════╝░╚═════╝░╚═╝╚══════╝╚═════╝░  ░╚════╝░╚══════╝░╚═════╝░╚═════╝░
1985 ------------------------------------------------------------------------------
1986 Author: orion (@OrionDevStar)
1987 ------------------------------------------------------------------------------
1988 */
1989 
1990 
1991 
1992 
1993 
1994 
1995 contract Oddies is ERC721SE, Ownable, ReentrancyGuard, PaymentSplitter {
1996   using Strings for uint256;
1997   
1998   bool public isRevealed = false;
1999   uint8 public FORERUNNERS_MINT_AMOUNT = 5;
2000   uint8 public HUNTERS_MINT_AMOUNT = 3;
2001   uint8 public PUBLIC_MINT_AMOUNT_TRANSACTION = 5;  
2002   uint32 public FORERUNNERS_MINT_DATE = 1639623600;
2003   uint32 public HUNTERS_MINT_DATE = 1639821600;
2004   uint32 public PUBLIC_MINT_DATE = 1639882800;
2005   uint128 public PRESALE_COST = 0.035 ether;
2006   uint128 public PUBLIC_COST = 0.05 ether;
2007   uint256 public GENESIS_ODDIES_MAX_SUPPLY = 5005;  
2008   string  private baseURI;
2009   string  private notRevealedUri;
2010   address[] public team;
2011   mapping(address => uint256) public forerunnersMintedBalance;
2012   mapping(address => uint256) public huntersMintedBalance;
2013   
2014 
2015   constructor(
2016     string memory _name,
2017     string memory _symbol,
2018     string memory _initBaseURI,
2019     string memory _initNotRevealedUri,
2020     address proxyRegistryAddress,
2021     uint[] memory _teamShares,
2022     address[] memory _team,
2023     address[] memory _forerunners
2024    ) 
2025     ERC721S(_name, _symbol, proxyRegistryAddress)
2026     PaymentSplitter(_team, _teamShares)
2027    {
2028     setBaseURI(_initBaseURI);
2029     setNotRevealedURI(_initNotRevealedUri);
2030     team = _team;
2031     _initializeEIP712(_name);
2032     _owners.push();
2033 
2034     for (uint256 i = 0; i < _forerunners.length; i++) {
2035       forerunnersMintedBalance[_forerunners[i]] = FORERUNNERS_MINT_AMOUNT;
2036     }
2037   }
2038 
2039   // internal
2040   function _baseURI() internal view virtual override returns (string memory) {
2041     return baseURI;
2042   }
2043 
2044   function _mintNFT(uint256 _quantity, uint128 _price) internal {
2045       require(_quantity * _price <= msg.value, "Insufficient funds.");
2046       require(_quantity + _owners.length <= GENESIS_ODDIES_MAX_SUPPLY,"Purchase exceeds available supply.");
2047       for (uint256 i = 0; i < _quantity; i++) {
2048           _safeMint(msg.sender);
2049       }
2050   }  
2051 
2052   // public
2053   function mint(uint256 _quantity) public payable nonReentrant {
2054       require(block.timestamp >= PUBLIC_MINT_DATE, "Public mint not available.");
2055       require(_quantity <= PUBLIC_MINT_AMOUNT_TRANSACTION, "Quantity exceeds per-transaction limit");
2056       _mintNFT(_quantity, PUBLIC_COST);
2057   }   
2058 
2059   function forerunnersMint(uint256 _quantity) external payable nonReentrant {
2060     require(block.timestamp < PUBLIC_MINT_DATE && block.timestamp >= FORERUNNERS_MINT_DATE, "Forerunners presale mint not available.");
2061     require(forerunnersMintedBalance[msg.sender] - _quantity >= 0, "Quantity exceeds per-wallet limit");
2062     _mintNFT(_quantity,PRESALE_COST);
2063     forerunnersMintedBalance[msg.sender] -= _quantity;
2064   }   
2065 
2066   function huntersMint(uint256 _quantity) external payable nonReentrant {
2067     require(block.timestamp < PUBLIC_MINT_DATE && block.timestamp >= HUNTERS_MINT_DATE, "Hunters presale mint not available.");
2068     require(huntersMintedBalance[msg.sender] - _quantity >= 0, "Quantity exceeds per-wallet limit");
2069     _mintNFT(_quantity,PRESALE_COST);
2070     huntersMintedBalance[msg.sender] -= _quantity;
2071   }
2072 
2073   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2074     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
2075     return isRevealed 
2076             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
2077             : notRevealedUri;
2078   } 
2079 
2080   //only owner
2081   function mintReserveToAddress(uint256 _quantity, address _to) public onlyOwner {
2082     require(_quantity + _owners.length <= GENESIS_ODDIES_MAX_SUPPLY,"Purchase exceeds available supply.");
2083     for (uint256 i = 1; i <= _quantity; i++) {
2084       _safeMint(_to);
2085     }
2086   }
2087 
2088   // @dev mint a single token to each address passed in through calldata
2089   // @param _addresses Array of addresses to send a single token to
2090   function mintReserveToAddresses(address[] calldata _addresses) external  onlyOwner {
2091       uint256 _quantity = _addresses.length;
2092       require(_quantity + _owners.length <= GENESIS_ODDIES_MAX_SUPPLY,"Purchase exceeds available supply.");
2093       for (uint256 i = 0; i < _quantity; i++) {
2094           _safeMint(_addresses[i]);
2095       }
2096   }  
2097 
2098   function setBaseURI(string memory _newBaseURI) public onlyOwner {
2099     baseURI = _newBaseURI;
2100   }
2101   
2102   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2103     notRevealedUri = _notRevealedURI;
2104   }
2105 
2106   function setReveal() public  onlyOwner {
2107       isRevealed = !isRevealed;
2108   }
2109 
2110   function burnRemainingOddies() public onlyOwner {
2111     GENESIS_ODDIES_MAX_SUPPLY = _owners.length;
2112   }
2113 
2114   function addForerunnersList(address[] calldata _forerunners) external onlyOwner {
2115     for (uint256 i = 0; i < _forerunners.length; i++) {
2116         forerunnersMintedBalance[_forerunners[i]] = FORERUNNERS_MINT_AMOUNT;
2117     }
2118   }
2119 
2120   function addHuntersList(address[] calldata _forerunners) external onlyOwner {
2121     for (uint256 i = 0; i < _forerunners.length; i++) {
2122         huntersMintedBalance[_forerunners[i]] = HUNTERS_MINT_AMOUNT;
2123     }
2124   }  
2125     
2126   function releaseFunds() external onlyOwner {
2127     for (uint i = 0; i < team.length; i++) {
2128         release(payable(team[i]));
2129     }
2130   }
2131 }