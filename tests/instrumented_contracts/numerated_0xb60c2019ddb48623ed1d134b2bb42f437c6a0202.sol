1 // File: contracts/Initializable.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 contract Initializable {
8     bool inited = false;
9 
10     modifier initializer() {
11         require(!inited, "already inited");
12         _;
13         inited = true;
14     }
15 }
16 // File: contracts/EIP712Base.sol
17 
18 
19 
20 pragma solidity ^0.8.0;
21 
22 
23 contract EIP712Base is Initializable {
24     struct EIP712Domain {
25         string name;
26         string version;
27         address verifyingContract;
28         bytes32 salt;
29     }
30 
31     string constant public ERC712_VERSION = "1";
32 
33     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
34         bytes(
35             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
36         )
37     );
38     bytes32 internal domainSeperator;
39 
40     // supposed to be called once while initializing.
41     // one of the contracts that inherits this contract follows proxy pattern
42     // so it is not possible to do this in a constructor
43     function _initializeEIP712(
44         string memory name
45     )
46         internal
47         initializer
48     {
49         _setDomainSeperator(name);
50     }
51 
52     function _setDomainSeperator(string memory name) internal {
53         domainSeperator = keccak256(
54             abi.encode(
55                 EIP712_DOMAIN_TYPEHASH,
56                 keccak256(bytes(name)),
57                 keccak256(bytes(ERC712_VERSION)),
58                 address(this),
59                 bytes32(getChainId())
60             )
61         );
62     }
63 
64     function getDomainSeperator() public view returns (bytes32) {
65         return domainSeperator;
66     }
67 
68     function getChainId() public view returns (uint256) {
69         uint256 id;
70         assembly {
71             id := chainid()
72         }
73         return id;
74     }
75 
76     /**
77      * Accept message hash and returns hash message in EIP712 compatible form
78      * So that it can be used to recover signer from signature signed using EIP712 formatted data
79      * https://eips.ethereum.org/EIPS/eip-712
80      * "\\x19" makes the encoding deterministic
81      * "\\x01" is the version byte to make it compatible to EIP-191
82      */
83     function toTypedMessageHash(bytes32 messageHash)
84         internal
85         view
86         returns (bytes32)
87     {
88         return
89             keccak256(
90                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
91             );
92     }
93 }
94 // File: contracts/ContentMixin.sol
95 
96 
97 
98 pragma solidity ^0.8.0;
99 
100 abstract contract ContextMixin {
101     function msgSender()
102         internal
103         view
104         returns (address payable sender)
105     {
106         if (msg.sender == address(this)) {
107             bytes memory array = msg.data;
108             uint256 index = msg.data.length;
109             assembly {
110                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
111                 sender := and(
112                     mload(add(array, index)),
113                     0xffffffffffffffffffffffffffffffffffffffff
114                 )
115             }
116         } else {
117             sender = payable(msg.sender);
118         }
119         return sender;
120     }
121 }
122 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
123 
124 
125 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 // CAUTION
130 // This version of SafeMath should only be used with Solidity 0.8 or later,
131 // because it relies on the compiler's built in overflow checks.
132 
133 /**
134  * @dev Wrappers over Solidity's arithmetic operations.
135  *
136  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
137  * now has built in overflow checking.
138  */
139 library SafeMath {
140     /**
141      * @dev Returns the addition of two unsigned integers, with an overflow flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             uint256 c = a + b;
148             if (c < a) return (false, 0);
149             return (true, c);
150         }
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
155      *
156      * _Available since v3.4._
157      */
158     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         unchecked {
160             if (b > a) return (false, 0);
161             return (true, a - b);
162         }
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
167      *
168      * _Available since v3.4._
169      */
170     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
171         unchecked {
172             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173             // benefit is lost if 'b' is also tested.
174             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175             if (a == 0) return (true, 0);
176             uint256 c = a * b;
177             if (c / a != b) return (false, 0);
178             return (true, c);
179         }
180     }
181 
182     /**
183      * @dev Returns the division of two unsigned integers, with a division by zero flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
188         unchecked {
189             if (b == 0) return (false, 0);
190             return (true, a / b);
191         }
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
196      *
197      * _Available since v3.4._
198      */
199     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
200         unchecked {
201             if (b == 0) return (false, 0);
202             return (true, a % b);
203         }
204     }
205 
206     /**
207      * @dev Returns the addition of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `+` operator.
211      *
212      * Requirements:
213      *
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         return a + b;
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting on
222      * overflow (when the result is negative).
223      *
224      * Counterpart to Solidity's `-` operator.
225      *
226      * Requirements:
227      *
228      * - Subtraction cannot overflow.
229      */
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         return a - b;
232     }
233 
234     /**
235      * @dev Returns the multiplication of two unsigned integers, reverting on
236      * overflow.
237      *
238      * Counterpart to Solidity's `*` operator.
239      *
240      * Requirements:
241      *
242      * - Multiplication cannot overflow.
243      */
244     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245         return a * b;
246     }
247 
248     /**
249      * @dev Returns the integer division of two unsigned integers, reverting on
250      * division by zero. The result is rounded towards zero.
251      *
252      * Counterpart to Solidity's `/` operator.
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function div(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a / b;
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * reverting when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a % b;
276     }
277 
278     /**
279      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
280      * overflow (when the result is negative).
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {trySub}.
284      *
285      * Counterpart to Solidity's `-` operator.
286      *
287      * Requirements:
288      *
289      * - Subtraction cannot overflow.
290      */
291     function sub(
292         uint256 a,
293         uint256 b,
294         string memory errorMessage
295     ) internal pure returns (uint256) {
296         unchecked {
297             require(b <= a, errorMessage);
298             return a - b;
299         }
300     }
301 
302     /**
303      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
304      * division by zero. The result is rounded towards zero.
305      *
306      * Counterpart to Solidity's `/` operator. Note: this function uses a
307      * `revert` opcode (which leaves remaining gas untouched) while Solidity
308      * uses an invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function div(
315         uint256 a,
316         uint256 b,
317         string memory errorMessage
318     ) internal pure returns (uint256) {
319         unchecked {
320             require(b > 0, errorMessage);
321             return a / b;
322         }
323     }
324 
325     /**
326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
327      * reverting with custom message when dividing by zero.
328      *
329      * CAUTION: This function is deprecated because it requires allocating memory for the error
330      * message unnecessarily. For custom revert reasons use {tryMod}.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      *
338      * - The divisor cannot be zero.
339      */
340     function mod(
341         uint256 a,
342         uint256 b,
343         string memory errorMessage
344     ) internal pure returns (uint256) {
345         unchecked {
346             require(b > 0, errorMessage);
347             return a % b;
348         }
349     }
350 }
351 
352 // File: contracts/NativeMetaTransaction.sol
353 
354 
355 
356 pragma solidity ^0.8.0;
357 
358 
359 
360 contract NativeMetaTransaction is EIP712Base {
361     using SafeMath for uint256;
362     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
363         bytes(
364             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
365         )
366     );
367     event MetaTransactionExecuted(
368         address userAddress,
369         address payable relayerAddress,
370         bytes functionSignature
371     );
372     mapping(address => uint256) nonces;
373 
374     /*
375      * Meta transaction structure.
376      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
377      * He should call the desired function directly in that case.
378      */
379     struct MetaTransaction {
380         uint256 nonce;
381         address from;
382         bytes functionSignature;
383     }
384 
385     function executeMetaTransaction(
386         address userAddress,
387         bytes memory functionSignature,
388         bytes32 sigR,
389         bytes32 sigS,
390         uint8 sigV
391     ) public payable returns (bytes memory) {
392         MetaTransaction memory metaTx = MetaTransaction({
393             nonce: nonces[userAddress],
394             from: userAddress,
395             functionSignature: functionSignature
396         });
397 
398         require(
399             verify(userAddress, metaTx, sigR, sigS, sigV),
400             "Signer and signature do not match"
401         );
402 
403         // increase nonce for user (to avoid re-use)
404         nonces[userAddress] = nonces[userAddress].add(1);
405 
406         emit MetaTransactionExecuted(
407             userAddress,
408             payable(msg.sender),
409             functionSignature
410         );
411 
412         // Append userAddress and relayer address at the end to extract it from calling context
413         (bool success, bytes memory returnData) = address(this).call(
414             abi.encodePacked(functionSignature, userAddress)
415         );
416         require(success, "Function call not successful");
417 
418         return returnData;
419     }
420 
421     function hashMetaTransaction(MetaTransaction memory metaTx)
422         internal
423         pure
424         returns (bytes32)
425     {
426         return
427             keccak256(
428                 abi.encode(
429                     META_TRANSACTION_TYPEHASH,
430                     metaTx.nonce,
431                     metaTx.from,
432                     keccak256(metaTx.functionSignature)
433                 )
434             );
435     }
436 
437     function getNonce(address user) public view returns (uint256 nonce) {
438         nonce = nonces[user];
439     }
440 
441     function verify(
442         address signer,
443         MetaTransaction memory metaTx,
444         bytes32 sigR,
445         bytes32 sigS,
446         uint8 sigV
447     ) internal view returns (bool) {
448         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
449         return
450             signer ==
451             ecrecover(
452                 toTypedMessageHash(hashMetaTransaction(metaTx)),
453                 sigV,
454                 sigR,
455                 sigS
456             );
457     }
458 }
459 // File: @openzeppelin/contracts/utils/Counters.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @title Counters
468  * @author Matt Condon (@shrugs)
469  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
470  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
471  *
472  * Include with `using Counters for Counters.Counter;`
473  */
474 library Counters {
475     struct Counter {
476         // This variable should never be directly accessed by users of the library: interactions must be restricted to
477         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
478         // this feature: see https://github.com/ethereum/solidity/issues/4637
479         uint256 _value; // default: 0
480     }
481 
482     function current(Counter storage counter) internal view returns (uint256) {
483         return counter._value;
484     }
485 
486     function increment(Counter storage counter) internal {
487         unchecked {
488             counter._value += 1;
489         }
490     }
491 
492     function decrement(Counter storage counter) internal {
493         uint256 value = counter._value;
494         require(value > 0, "Counter: decrement overflow");
495         unchecked {
496             counter._value = value - 1;
497         }
498     }
499 
500     function reset(Counter storage counter) internal {
501         counter._value = 0;
502     }
503 }
504 
505 // File: @openzeppelin/contracts/utils/Strings.sol
506 
507 
508 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev String operations.
514  */
515 library Strings {
516     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
517     uint8 private constant _ADDRESS_LENGTH = 20;
518 
519     /**
520      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
521      */
522     function toString(uint256 value) internal pure returns (string memory) {
523         // Inspired by OraclizeAPI's implementation - MIT licence
524         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
525 
526         if (value == 0) {
527             return "0";
528         }
529         uint256 temp = value;
530         uint256 digits;
531         while (temp != 0) {
532             digits++;
533             temp /= 10;
534         }
535         bytes memory buffer = new bytes(digits);
536         while (value != 0) {
537             digits -= 1;
538             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
539             value /= 10;
540         }
541         return string(buffer);
542     }
543 
544     /**
545      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
546      */
547     function toHexString(uint256 value) internal pure returns (string memory) {
548         if (value == 0) {
549             return "0x00";
550         }
551         uint256 temp = value;
552         uint256 length = 0;
553         while (temp != 0) {
554             length++;
555             temp >>= 8;
556         }
557         return toHexString(value, length);
558     }
559 
560     /**
561      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
562      */
563     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
564         bytes memory buffer = new bytes(2 * length + 2);
565         buffer[0] = "0";
566         buffer[1] = "x";
567         for (uint256 i = 2 * length + 1; i > 1; --i) {
568             buffer[i] = _HEX_SYMBOLS[value & 0xf];
569             value >>= 4;
570         }
571         require(value == 0, "Strings: hex length insufficient");
572         return string(buffer);
573     }
574 
575     /**
576      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
577      */
578     function toHexString(address addr) internal pure returns (string memory) {
579         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
580     }
581 }
582 
583 // File: @openzeppelin/contracts/utils/Context.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Provides information about the current execution context, including the
592  * sender of the transaction and its data. While these are generally available
593  * via msg.sender and msg.data, they should not be accessed in such a direct
594  * manner, since when dealing with meta-transactions the account sending and
595  * paying for execution may not be the actual sender (as far as an application
596  * is concerned).
597  *
598  * This contract is only required for intermediate, library-like contracts.
599  */
600 abstract contract Context {
601     function _msgSender() internal view virtual returns (address) {
602         return msg.sender;
603     }
604 
605     function _msgData() internal view virtual returns (bytes calldata) {
606         return msg.data;
607     }
608 }
609 
610 // File: @openzeppelin/contracts/access/Ownable.sol
611 
612 
613 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 
618 /**
619  * @dev Contract module which provides a basic access control mechanism, where
620  * there is an account (an owner) that can be granted exclusive access to
621  * specific functions.
622  *
623  * By default, the owner account will be the one that deploys the contract. This
624  * can later be changed with {transferOwnership}.
625  *
626  * This module is used through inheritance. It will make available the modifier
627  * `onlyOwner`, which can be applied to your functions to restrict their use to
628  * the owner.
629  */
630 abstract contract Ownable is Context {
631     address private _owner;
632 
633     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
634 
635     /**
636      * @dev Initializes the contract setting the deployer as the initial owner.
637      */
638     constructor() {
639         _transferOwnership(_msgSender());
640     }
641 
642     /**
643      * @dev Throws if called by any account other than the owner.
644      */
645     modifier onlyOwner() {
646         _checkOwner();
647         _;
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
658      * @dev Throws if the sender is not the owner.
659      */
660     function _checkOwner() internal view virtual {
661         require(owner() == _msgSender(), "Ownable: caller is not the owner");
662     }
663 
664     /**
665      * @dev Leaves the contract without owner. It will not be possible to call
666      * `onlyOwner` functions anymore. Can only be called by the current owner.
667      *
668      * NOTE: Renouncing ownership will leave the contract without an owner,
669      * thereby removing any functionality that is only available to the owner.
670      */
671     function renounceOwnership() public virtual onlyOwner {
672         _transferOwnership(address(0));
673     }
674 
675     /**
676      * @dev Transfers ownership of the contract to a new account (`newOwner`).
677      * Can only be called by the current owner.
678      */
679     function transferOwnership(address newOwner) public virtual onlyOwner {
680         require(newOwner != address(0), "Ownable: new owner is the zero address");
681         _transferOwnership(newOwner);
682     }
683 
684     /**
685      * @dev Transfers ownership of the contract to a new account (`newOwner`).
686      * Internal function without access restriction.
687      */
688     function _transferOwnership(address newOwner) internal virtual {
689         address oldOwner = _owner;
690         _owner = newOwner;
691         emit OwnershipTransferred(oldOwner, newOwner);
692     }
693 }
694 
695 // File: @openzeppelin/contracts/utils/Address.sol
696 
697 
698 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
699 
700 pragma solidity ^0.8.1;
701 
702 /**
703  * @dev Collection of functions related to the address type
704  */
705 library Address {
706     /**
707      * @dev Returns true if `account` is a contract.
708      *
709      * [IMPORTANT]
710      * ====
711      * It is unsafe to assume that an address for which this function returns
712      * false is an externally-owned account (EOA) and not a contract.
713      *
714      * Among others, `isContract` will return false for the following
715      * types of addresses:
716      *
717      *  - an externally-owned account
718      *  - a contract in construction
719      *  - an address where a contract will be created
720      *  - an address where a contract lived, but was destroyed
721      * ====
722      *
723      * [IMPORTANT]
724      * ====
725      * You shouldn't rely on `isContract` to protect against flash loan attacks!
726      *
727      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
728      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
729      * constructor.
730      * ====
731      */
732     function isContract(address account) internal view returns (bool) {
733         // This method relies on extcodesize/address.code.length, which returns 0
734         // for contracts in construction, since the code is only stored at the end
735         // of the constructor execution.
736 
737         return account.code.length > 0;
738     }
739 
740     /**
741      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
742      * `recipient`, forwarding all available gas and reverting on errors.
743      *
744      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
745      * of certain opcodes, possibly making contracts go over the 2300 gas limit
746      * imposed by `transfer`, making them unable to receive funds via
747      * `transfer`. {sendValue} removes this limitation.
748      *
749      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
750      *
751      * IMPORTANT: because control is transferred to `recipient`, care must be
752      * taken to not create reentrancy vulnerabilities. Consider using
753      * {ReentrancyGuard} or the
754      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
755      */
756     function sendValue(address payable recipient, uint256 amount) internal {
757         require(address(this).balance >= amount, "Address: insufficient balance");
758 
759         (bool success, ) = recipient.call{value: amount}("");
760         require(success, "Address: unable to send value, recipient may have reverted");
761     }
762 
763     /**
764      * @dev Performs a Solidity function call using a low level `call`. A
765      * plain `call` is an unsafe replacement for a function call: use this
766      * function instead.
767      *
768      * If `target` reverts with a revert reason, it is bubbled up by this
769      * function (like regular Solidity function calls).
770      *
771      * Returns the raw returned data. To convert to the expected return value,
772      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
773      *
774      * Requirements:
775      *
776      * - `target` must be a contract.
777      * - calling `target` with `data` must not revert.
778      *
779      * _Available since v3.1._
780      */
781     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
782         return functionCall(target, data, "Address: low-level call failed");
783     }
784 
785     /**
786      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
787      * `errorMessage` as a fallback revert reason when `target` reverts.
788      *
789      * _Available since v3.1._
790      */
791     function functionCall(
792         address target,
793         bytes memory data,
794         string memory errorMessage
795     ) internal returns (bytes memory) {
796         return functionCallWithValue(target, data, 0, errorMessage);
797     }
798 
799     /**
800      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
801      * but also transferring `value` wei to `target`.
802      *
803      * Requirements:
804      *
805      * - the calling contract must have an ETH balance of at least `value`.
806      * - the called Solidity function must be `payable`.
807      *
808      * _Available since v3.1._
809      */
810     function functionCallWithValue(
811         address target,
812         bytes memory data,
813         uint256 value
814     ) internal returns (bytes memory) {
815         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
816     }
817 
818     /**
819      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
820      * with `errorMessage` as a fallback revert reason when `target` reverts.
821      *
822      * _Available since v3.1._
823      */
824     function functionCallWithValue(
825         address target,
826         bytes memory data,
827         uint256 value,
828         string memory errorMessage
829     ) internal returns (bytes memory) {
830         require(address(this).balance >= value, "Address: insufficient balance for call");
831         require(isContract(target), "Address: call to non-contract");
832 
833         (bool success, bytes memory returndata) = target.call{value: value}(data);
834         return verifyCallResult(success, returndata, errorMessage);
835     }
836 
837     /**
838      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
839      * but performing a static call.
840      *
841      * _Available since v3.3._
842      */
843     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
844         return functionStaticCall(target, data, "Address: low-level static call failed");
845     }
846 
847     /**
848      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
849      * but performing a static call.
850      *
851      * _Available since v3.3._
852      */
853     function functionStaticCall(
854         address target,
855         bytes memory data,
856         string memory errorMessage
857     ) internal view returns (bytes memory) {
858         require(isContract(target), "Address: static call to non-contract");
859 
860         (bool success, bytes memory returndata) = target.staticcall(data);
861         return verifyCallResult(success, returndata, errorMessage);
862     }
863 
864     /**
865      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
866      * but performing a delegate call.
867      *
868      * _Available since v3.4._
869      */
870     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
871         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
872     }
873 
874     /**
875      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
876      * but performing a delegate call.
877      *
878      * _Available since v3.4._
879      */
880     function functionDelegateCall(
881         address target,
882         bytes memory data,
883         string memory errorMessage
884     ) internal returns (bytes memory) {
885         require(isContract(target), "Address: delegate call to non-contract");
886 
887         (bool success, bytes memory returndata) = target.delegatecall(data);
888         return verifyCallResult(success, returndata, errorMessage);
889     }
890 
891     /**
892      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
893      * revert reason using the provided one.
894      *
895      * _Available since v4.3._
896      */
897     function verifyCallResult(
898         bool success,
899         bytes memory returndata,
900         string memory errorMessage
901     ) internal pure returns (bytes memory) {
902         if (success) {
903             return returndata;
904         } else {
905             // Look for revert reason and bubble it up if present
906             if (returndata.length > 0) {
907                 // The easiest way to bubble the revert reason is using memory via assembly
908                 /// @solidity memory-safe-assembly
909                 assembly {
910                     let returndata_size := mload(returndata)
911                     revert(add(32, returndata), returndata_size)
912                 }
913             } else {
914                 revert(errorMessage);
915             }
916         }
917     }
918 }
919 
920 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
921 
922 
923 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 /**
928  * @title ERC721 token receiver interface
929  * @dev Interface for any contract that wants to support safeTransfers
930  * from ERC721 asset contracts.
931  */
932 interface IERC721Receiver {
933     /**
934      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
935      * by `operator` from `from`, this function is called.
936      *
937      * It must return its Solidity selector to confirm the token transfer.
938      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
939      *
940      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
941      */
942     function onERC721Received(
943         address operator,
944         address from,
945         uint256 tokenId,
946         bytes calldata data
947     ) external returns (bytes4);
948 }
949 
950 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
951 
952 
953 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
954 
955 pragma solidity ^0.8.0;
956 
957 /**
958  * @dev Interface of the ERC165 standard, as defined in the
959  * https://eips.ethereum.org/EIPS/eip-165[EIP].
960  *
961  * Implementers can declare support of contract interfaces, which can then be
962  * queried by others ({ERC165Checker}).
963  *
964  * For an implementation, see {ERC165}.
965  */
966 interface IERC165 {
967     /**
968      * @dev Returns true if this contract implements the interface defined by
969      * `interfaceId`. See the corresponding
970      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
971      * to learn more about how these ids are created.
972      *
973      * This function call must use less than 30 000 gas.
974      */
975     function supportsInterface(bytes4 interfaceId) external view returns (bool);
976 }
977 
978 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
979 
980 
981 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
982 
983 pragma solidity ^0.8.0;
984 
985 
986 /**
987  * @dev Implementation of the {IERC165} interface.
988  *
989  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
990  * for the additional interface id that will be supported. For example:
991  *
992  * ```solidity
993  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
994  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
995  * }
996  * ```
997  *
998  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
999  */
1000 abstract contract ERC165 is IERC165 {
1001     /**
1002      * @dev See {IERC165-supportsInterface}.
1003      */
1004     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1005         return interfaceId == type(IERC165).interfaceId;
1006     }
1007 }
1008 
1009 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1010 
1011 
1012 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 
1017 /**
1018  * @dev Required interface of an ERC721 compliant contract.
1019  */
1020 interface IERC721 is IERC165 {
1021     /**
1022      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1023      */
1024     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1025 
1026     /**
1027      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1028      */
1029     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1030 
1031     /**
1032      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1033      */
1034     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1035 
1036     /**
1037      * @dev Returns the number of tokens in ``owner``'s account.
1038      */
1039     function balanceOf(address owner) external view returns (uint256 balance);
1040 
1041     /**
1042      * @dev Returns the owner of the `tokenId` token.
1043      *
1044      * Requirements:
1045      *
1046      * - `tokenId` must exist.
1047      */
1048     function ownerOf(uint256 tokenId) external view returns (address owner);
1049 
1050     /**
1051      * @dev Safely transfers `tokenId` token from `from` to `to`.
1052      *
1053      * Requirements:
1054      *
1055      * - `from` cannot be the zero address.
1056      * - `to` cannot be the zero address.
1057      * - `tokenId` token must exist and be owned by `from`.
1058      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1059      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function safeTransferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes calldata data
1068     ) external;
1069 
1070     /**
1071      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1072      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1073      *
1074      * Requirements:
1075      *
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must exist and be owned by `from`.
1079      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1080      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function safeTransferFrom(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) external;
1089 
1090     /**
1091      * @dev Transfers `tokenId` token from `from` to `to`.
1092      *
1093      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1094      *
1095      * Requirements:
1096      *
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must be owned by `from`.
1100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function transferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) external;
1109 
1110     /**
1111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1112      * The approval is cleared when the token is transferred.
1113      *
1114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1115      *
1116      * Requirements:
1117      *
1118      * - The caller must own the token or be an approved operator.
1119      * - `tokenId` must exist.
1120      *
1121      * Emits an {Approval} event.
1122      */
1123     function approve(address to, uint256 tokenId) external;
1124 
1125     /**
1126      * @dev Approve or remove `operator` as an operator for the caller.
1127      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1128      *
1129      * Requirements:
1130      *
1131      * - The `operator` cannot be the caller.
1132      *
1133      * Emits an {ApprovalForAll} event.
1134      */
1135     function setApprovalForAll(address operator, bool _approved) external;
1136 
1137     /**
1138      * @dev Returns the account approved for `tokenId` token.
1139      *
1140      * Requirements:
1141      *
1142      * - `tokenId` must exist.
1143      */
1144     function getApproved(uint256 tokenId) external view returns (address operator);
1145 
1146     /**
1147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1148      *
1149      * See {setApprovalForAll}
1150      */
1151     function isApprovedForAll(address owner, address operator) external view returns (bool);
1152 }
1153 
1154 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1155 
1156 
1157 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1158 
1159 pragma solidity ^0.8.0;
1160 
1161 
1162 /**
1163  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1164  * @dev See https://eips.ethereum.org/EIPS/eip-721
1165  */
1166 interface IERC721Metadata is IERC721 {
1167     /**
1168      * @dev Returns the token collection name.
1169      */
1170     function name() external view returns (string memory);
1171 
1172     /**
1173      * @dev Returns the token collection symbol.
1174      */
1175     function symbol() external view returns (string memory);
1176 
1177     /**
1178      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1179      */
1180     function tokenURI(uint256 tokenId) external view returns (string memory);
1181 }
1182 
1183 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1184 
1185 
1186 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 
1191 
1192 
1193 
1194 
1195 
1196 
1197 /**
1198  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1199  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1200  * {ERC721Enumerable}.
1201  */
1202 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1203     using Address for address;
1204     using Strings for uint256;
1205 
1206     // Token name
1207     string private _name;
1208 
1209     // Token symbol
1210     string private _symbol;
1211 
1212     // Mapping from token ID to owner address
1213     mapping(uint256 => address) private _owners;
1214 
1215     // Mapping owner address to token count
1216     mapping(address => uint256) private _balances;
1217 
1218     // Mapping from token ID to approved address
1219     mapping(uint256 => address) private _tokenApprovals;
1220 
1221     // Mapping from owner to operator approvals
1222     mapping(address => mapping(address => bool)) private _operatorApprovals;
1223 
1224     /**
1225      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1226      */
1227     constructor(string memory name_, string memory symbol_) {
1228         _name = name_;
1229         _symbol = symbol_;
1230     }
1231 
1232     /**
1233      * @dev See {IERC165-supportsInterface}.
1234      */
1235     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1236         return
1237             interfaceId == type(IERC721).interfaceId ||
1238             interfaceId == type(IERC721Metadata).interfaceId ||
1239             super.supportsInterface(interfaceId);
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-balanceOf}.
1244      */
1245     function balanceOf(address owner) public view virtual override returns (uint256) {
1246         require(owner != address(0), "ERC721: address zero is not a valid owner");
1247         return _balances[owner];
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-ownerOf}.
1252      */
1253     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1254         address owner = _owners[tokenId];
1255         require(owner != address(0), "ERC721: invalid token ID");
1256         return owner;
1257     }
1258 
1259     /**
1260      * @dev See {IERC721Metadata-name}.
1261      */
1262     function name() public view virtual override returns (string memory) {
1263         return _name;
1264     }
1265 
1266     /**
1267      * @dev See {IERC721Metadata-symbol}.
1268      */
1269     function symbol() public view virtual override returns (string memory) {
1270         return _symbol;
1271     }
1272 
1273     /**
1274      * @dev See {IERC721Metadata-tokenURI}.
1275      */
1276     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1277         _requireMinted(tokenId);
1278 
1279         string memory baseURI = _baseURI();
1280         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1281     }
1282 
1283     /**
1284      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1285      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1286      * by default, can be overridden in child contracts.
1287      */
1288     function _baseURI() internal view virtual returns (string memory) {
1289         return "";
1290     }
1291 
1292     /**
1293      * @dev See {IERC721-approve}.
1294      */
1295     function approve(address to, uint256 tokenId) public virtual override {
1296         address owner = ERC721.ownerOf(tokenId);
1297         require(to != owner, "ERC721: approval to current owner");
1298 
1299         require(
1300             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1301             "ERC721: approve caller is not token owner nor approved for all"
1302         );
1303 
1304         _approve(to, tokenId);
1305     }
1306 
1307     /**
1308      * @dev See {IERC721-getApproved}.
1309      */
1310     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1311         _requireMinted(tokenId);
1312 
1313         return _tokenApprovals[tokenId];
1314     }
1315 
1316     /**
1317      * @dev See {IERC721-setApprovalForAll}.
1318      */
1319     function setApprovalForAll(address operator, bool approved) public virtual override {
1320         _setApprovalForAll(_msgSender(), operator, approved);
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-isApprovedForAll}.
1325      */
1326     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1327         return _operatorApprovals[owner][operator];
1328     }
1329 
1330     /**
1331      * @dev See {IERC721-transferFrom}.
1332      */
1333     function transferFrom(
1334         address from,
1335         address to,
1336         uint256 tokenId
1337     ) public virtual override {
1338         //solhint-disable-next-line max-line-length
1339         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1340 
1341         _transfer(from, to, tokenId);
1342     }
1343 
1344     /**
1345      * @dev See {IERC721-safeTransferFrom}.
1346      */
1347     function safeTransferFrom(
1348         address from,
1349         address to,
1350         uint256 tokenId
1351     ) public virtual override {
1352         safeTransferFrom(from, to, tokenId, "");
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-safeTransferFrom}.
1357      */
1358     function safeTransferFrom(
1359         address from,
1360         address to,
1361         uint256 tokenId,
1362         bytes memory data
1363     ) public virtual override {
1364         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1365         _safeTransfer(from, to, tokenId, data);
1366     }
1367 
1368     /**
1369      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1370      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1371      *
1372      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1373      *
1374      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1375      * implement alternative mechanisms to perform token transfer, such as signature-based.
1376      *
1377      * Requirements:
1378      *
1379      * - `from` cannot be the zero address.
1380      * - `to` cannot be the zero address.
1381      * - `tokenId` token must exist and be owned by `from`.
1382      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1383      *
1384      * Emits a {Transfer} event.
1385      */
1386     function _safeTransfer(
1387         address from,
1388         address to,
1389         uint256 tokenId,
1390         bytes memory data
1391     ) internal virtual {
1392         _transfer(from, to, tokenId);
1393         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1394     }
1395 
1396     /**
1397      * @dev Returns whether `tokenId` exists.
1398      *
1399      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1400      *
1401      * Tokens start existing when they are minted (`_mint`),
1402      * and stop existing when they are burned (`_burn`).
1403      */
1404     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1405         return _owners[tokenId] != address(0);
1406     }
1407 
1408     /**
1409      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1410      *
1411      * Requirements:
1412      *
1413      * - `tokenId` must exist.
1414      */
1415     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1416         address owner = ERC721.ownerOf(tokenId);
1417         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1418     }
1419 
1420     /**
1421      * @dev Safely mints `tokenId` and transfers it to `to`.
1422      *
1423      * Requirements:
1424      *
1425      * - `tokenId` must not exist.
1426      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1427      *
1428      * Emits a {Transfer} event.
1429      */
1430     function _safeMint(address to, uint256 tokenId) internal virtual {
1431         _safeMint(to, tokenId, "");
1432     }
1433 
1434     /**
1435      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1436      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1437      */
1438     function _safeMint(
1439         address to,
1440         uint256 tokenId,
1441         bytes memory data
1442     ) internal virtual {
1443         _mint(to, tokenId);
1444         require(
1445             _checkOnERC721Received(address(0), to, tokenId, data),
1446             "ERC721: transfer to non ERC721Receiver implementer"
1447         );
1448     }
1449 
1450     /**
1451      * @dev Mints `tokenId` and transfers it to `to`.
1452      *
1453      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1454      *
1455      * Requirements:
1456      *
1457      * - `tokenId` must not exist.
1458      * - `to` cannot be the zero address.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function _mint(address to, uint256 tokenId) internal virtual {
1463         require(to != address(0), "ERC721: mint to the zero address");
1464         require(!_exists(tokenId), "ERC721: token already minted");
1465 
1466         _beforeTokenTransfer(address(0), to, tokenId);
1467 
1468         _balances[to] += 1;
1469         _owners[tokenId] = to;
1470 
1471         emit Transfer(address(0), to, tokenId);
1472 
1473         _afterTokenTransfer(address(0), to, tokenId);
1474     }
1475 
1476     /**
1477      * @dev Destroys `tokenId`.
1478      * The approval is cleared when the token is burned.
1479      *
1480      * Requirements:
1481      *
1482      * - `tokenId` must exist.
1483      *
1484      * Emits a {Transfer} event.
1485      */
1486     function _burn(uint256 tokenId) internal virtual {
1487         address owner = ERC721.ownerOf(tokenId);
1488 
1489         _beforeTokenTransfer(owner, address(0), tokenId);
1490 
1491         // Clear approvals
1492         _approve(address(0), tokenId);
1493 
1494         _balances[owner] -= 1;
1495         delete _owners[tokenId];
1496 
1497         emit Transfer(owner, address(0), tokenId);
1498 
1499         _afterTokenTransfer(owner, address(0), tokenId);
1500     }
1501 
1502     /**
1503      * @dev Transfers `tokenId` from `from` to `to`.
1504      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1505      *
1506      * Requirements:
1507      *
1508      * - `to` cannot be the zero address.
1509      * - `tokenId` token must be owned by `from`.
1510      *
1511      * Emits a {Transfer} event.
1512      */
1513     function _transfer(
1514         address from,
1515         address to,
1516         uint256 tokenId
1517     ) internal virtual {
1518         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1519         require(to != address(0), "ERC721: transfer to the zero address");
1520 
1521         _beforeTokenTransfer(from, to, tokenId);
1522 
1523         // Clear approvals from the previous owner
1524         _approve(address(0), tokenId);
1525 
1526         _balances[from] -= 1;
1527         _balances[to] += 1;
1528         _owners[tokenId] = to;
1529 
1530         emit Transfer(from, to, tokenId);
1531 
1532         _afterTokenTransfer(from, to, tokenId);
1533     }
1534 
1535     /**
1536      * @dev Approve `to` to operate on `tokenId`
1537      *
1538      * Emits an {Approval} event.
1539      */
1540     function _approve(address to, uint256 tokenId) internal virtual {
1541         _tokenApprovals[tokenId] = to;
1542         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1543     }
1544 
1545     /**
1546      * @dev Approve `operator` to operate on all of `owner` tokens
1547      *
1548      * Emits an {ApprovalForAll} event.
1549      */
1550     function _setApprovalForAll(
1551         address owner,
1552         address operator,
1553         bool approved
1554     ) internal virtual {
1555         require(owner != operator, "ERC721: approve to caller");
1556         _operatorApprovals[owner][operator] = approved;
1557         emit ApprovalForAll(owner, operator, approved);
1558     }
1559 
1560     /**
1561      * @dev Reverts if the `tokenId` has not been minted yet.
1562      */
1563     function _requireMinted(uint256 tokenId) internal view virtual {
1564         require(_exists(tokenId), "ERC721: invalid token ID");
1565     }
1566 
1567     /**
1568      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1569      * The call is not executed if the target address is not a contract.
1570      *
1571      * @param from address representing the previous owner of the given token ID
1572      * @param to target address that will receive the tokens
1573      * @param tokenId uint256 ID of the token to be transferred
1574      * @param data bytes optional data to send along with the call
1575      * @return bool whether the call correctly returned the expected magic value
1576      */
1577     function _checkOnERC721Received(
1578         address from,
1579         address to,
1580         uint256 tokenId,
1581         bytes memory data
1582     ) private returns (bool) {
1583         if (to.isContract()) {
1584             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1585                 return retval == IERC721Receiver.onERC721Received.selector;
1586             } catch (bytes memory reason) {
1587                 if (reason.length == 0) {
1588                     revert("ERC721: transfer to non ERC721Receiver implementer");
1589                 } else {
1590                     /// @solidity memory-safe-assembly
1591                     assembly {
1592                         revert(add(32, reason), mload(reason))
1593                     }
1594                 }
1595             }
1596         } else {
1597             return true;
1598         }
1599     }
1600 
1601     /**
1602      * @dev Hook that is called before any token transfer. This includes minting
1603      * and burning.
1604      *
1605      * Calling conditions:
1606      *
1607      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1608      * transferred to `to`.
1609      * - When `from` is zero, `tokenId` will be minted for `to`.
1610      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1611      * - `from` and `to` are never both zero.
1612      *
1613      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1614      */
1615     function _beforeTokenTransfer(
1616         address from,
1617         address to,
1618         uint256 tokenId
1619     ) internal virtual {}
1620 
1621     /**
1622      * @dev Hook that is called after any transfer of tokens. This includes
1623      * minting and burning.
1624      *
1625      * Calling conditions:
1626      *
1627      * - when `from` and `to` are both non-zero.
1628      * - `from` and `to` are never both zero.
1629      *
1630      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1631      */
1632     function _afterTokenTransfer(
1633         address from,
1634         address to,
1635         uint256 tokenId
1636     ) internal virtual {}
1637 }
1638 
1639 // File: contracts/ERC721Tradable.sol
1640 
1641 
1642 
1643 pragma solidity ^0.8.0;
1644 
1645 
1646 
1647 
1648 
1649 
1650 
1651 
1652 contract OwnableDelegateProxy {}
1653 
1654 /**
1655  * Used to delegate ownership of a contract to another address, to save on unneeded transactions to approve contract use for users
1656  */
1657 contract ProxyRegistry {
1658     mapping(address => OwnableDelegateProxy) public proxies;
1659 }
1660 
1661 /**
1662  * @title ERC721Tradable
1663  * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
1664  */
1665 abstract contract ERC721Tradable is ERC721, ContextMixin, NativeMetaTransaction, Ownable {
1666     using SafeMath for uint256;
1667     using Counters for Counters.Counter;
1668 
1669     /**
1670      * We rely on the OZ Counter util to keep track of the next available ID.
1671      * We track the nextTokenId instead of the currentTokenId to save users on gas costs. 
1672      * Read more about it here: https://shiny.mirror.xyz/OUampBbIz9ebEicfGnQf5At_ReMHlZy0tB4glb9xQ0E
1673      */ 
1674     Counters.Counter private _nextTokenId;
1675     address proxyRegistryAddress;
1676 
1677     constructor(
1678         string memory _name,
1679         string memory _symbol,
1680         address _proxyRegistryAddress
1681     ) ERC721(_name, _symbol) {
1682         proxyRegistryAddress = _proxyRegistryAddress;
1683         // nextTokenId is initialized to 1, since starting at 0 leads to higher gas cost for the first minter
1684         _nextTokenId.increment();
1685         _initializeEIP712(_name);
1686     }
1687 
1688     /**
1689      * @dev Mints a token to an address with a tokenURI.
1690      * @param _to address of the future owner of the token
1691      */
1692     /*function mintTo(address _to) public override  {
1693         uint256 currentTokenId = _nextTokenId.current();
1694         _nextTokenId.increment();
1695         _safeMint(_to, currentTokenId);
1696     }*/
1697 
1698     /**
1699         @dev Returns the total tokens minted so far.
1700         1 is always subtracted from the Counter since it tracks the next available tokenId.
1701      */
1702 
1703     function baseTokenURI() virtual public pure returns (string memory);
1704 
1705     /*function tokenURI(uint256 _tokenId) override public pure returns (string memory) {
1706         return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId)));
1707     }*/
1708 
1709     /**
1710      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1711      */
1712     function isApprovedForAll(address owner, address operator)
1713         override
1714         public
1715         view
1716         returns (bool)
1717     {
1718         // Whitelist OpenSea proxy contract for easy trading.
1719         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1720         if (address(proxyRegistry.proxies(owner)) == operator) {
1721             return true;
1722         }
1723 
1724         return super.isApprovedForAll(owner, operator);
1725     }
1726 
1727     /**
1728      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1729      */
1730     function _msgSender()
1731         internal
1732         override
1733         view
1734         returns (address sender)
1735     {
1736         return ContextMixin.msgSender();
1737     }
1738 }
1739 // File: contracts/0xthulu_2.sol
1740 
1741 
1742 
1743 pragma solidity ^0.8.0;
1744 
1745 
1746 /**
1747  * @title Creature
1748  * Creature - a contract for my non-fungible creatures.
1749  */
1750 contract Oxthulu is ERC721Tradable {
1751     using SafeMath for uint256;
1752     using Counters for Counters.Counter;
1753     Counters.Counter private _nextTokenId;
1754     uint public Pricestatus;
1755     uint256 public Priceval;
1756     uint public mintLimit;
1757     
1758     bool public contractstatus;
1759     mapping(address => uint256) public mintaddresscount;
1760     mapping(uint256 => string) private _tokenURIs;
1761     mapping(address => bool) public whitelistedAddresses;
1762 //    mapping(address => bool) presaleAddresses;
1763     uint public currentmintLimit;
1764     uint public paidmintLimit;
1765     address public Oxthulu_ETH_HOLDER;
1766     bool public pauseState;
1767     using SafeMath for uint256;
1768     address private Owner;
1769     uint Oxthulu_Total_Mint;        
1770     constructor(address _proxyRegistryAddress)
1771         ERC721Tradable("0xTHULU Relic of Membership", "0xRoM", _proxyRegistryAddress)
1772     {
1773         Pricestatus=0;
1774 		Priceval=(2/100)* 10**18;
1775         mintLimit=10;
1776         currentmintLimit=10;        
1777         paidmintLimit=10;
1778         contractstatus=false;        
1779         pauseState = false;
1780         Owner = msg.sender;
1781         Oxthulu_Total_Mint=11138;
1782         _nextTokenId.increment();
1783     }
1784 
1785     function baseTokenURI() override public pure returns (string memory) {
1786         return "https://ipfs.perma.store/content/"; //Live
1787         //return "http://lktest.funblockchain.com/contentv2/";
1788     }
1789 
1790     function contractURI() public pure returns (string memory) {
1791         return "https://ipfs.perma.store/content/"; //Live
1792         //return "http://lktest.funblockchain.com/contentv2/";
1793     }
1794 
1795     /*function mintTo(string memory uri) public  {
1796         uint256 currentTokenId = _nextTokenId.current();        
1797         _safeMint(msg.sender, currentTokenId);
1798         _setTokenURI(currentTokenId,uri);
1799         _nextTokenId.increment();
1800     }*/
1801 
1802     function tokenMint(string memory uri) private {
1803         uint256 currentcount = mintaddresscount[msg.sender];
1804         require(currentcount < mintLimit,"Total mint limit has reached.");
1805           	   
1806 	    uint256 tokenId = _nextTokenId.current();
1807         _nextTokenId.increment();
1808         _safeMint(msg.sender, tokenId);
1809         _setTokenURI(tokenId, uri);
1810           
1811         if(currentcount>=1){ currentcount++; }else{ currentcount=1;}
1812         mintaddresscount[msg.sender]=currentcount;
1813     }
1814 
1815      function tokenMint_pay(string memory uri) private {
1816 
1817         require(Pricestatus == 1, "Pricing is not enabled yet.");
1818         //require( this.balanceOf(msg.sender) < mintLimit,"Total: mint limit has reached.");                  
1819         /*if(Pricestatus!=0){
1820             uint256 Total_tobe_paid = calculate_transaction_pay(Priceval);
1821             require(msg.value == Total_tobe_paid, "Insufficient balance. Please transfer appropriate ETH."); 
1822            // transfer(Royalty_wallet, 0.002);
1823         }*/       
1824 	   
1825 	    uint256 tokenId = _nextTokenId.current();
1826         _nextTokenId.increment();
1827         _safeMint(msg.sender, tokenId);
1828         _setTokenURI(tokenId, uri);
1829                   
1830     }
1831 
1832     function tokenMintmultiple(string[] memory uris) external  payable whenNotPaused {
1833         require(totalSupply() < Oxthulu_Total_Mint, "Total Mint has been reached.");
1834         if(Pricestatus == 1){
1835             if(contractstatus == true || verifyUser(msg.sender) == true){
1836             require(contractstatus == true,"Contract is disabled. Please comeback later.");
1837             require(uris.length <= paidmintLimit,"Current mint limit exceeded.");
1838 
1839             if(Pricestatus!=0){
1840                 uint256 Total_tobe_paid = calculate_transaction_pay(uris);
1841                 require(msg.value == Total_tobe_paid, "Insufficient balance. Please transfer appropriate ETH."); 
1842                 require(Oxthulu_ETH_HOLDER != address(0), "ETH Holder account should not be empty.");
1843                 {(bool sent, bytes memory data) = Oxthulu_ETH_HOLDER.call{value: msg.value}("");}
1844            // transfer(Royalty_wallet, 0.002);
1845             }        
1846 	   
1847             for(uint i=0;i<uris.length;i++){
1848                 tokenMint_pay(uris[i]);
1849             }            
1850             }
1851            else{
1852             require(contractstatus == false,"Contract is in paused state.");
1853             require(verifyUser(msg.sender), "User is not whitelisted");
1854         }
1855             /*if(Pricestatus !=0 )
1856             {(bool sent, bytes memory data) = LK_ETH_HOLDER.call{value: msg.value}("");}*/
1857         }
1858         else{require(Pricestatus == 1, "Pricing is not enabled yet.");}
1859      }
1860 
1861      function tokenMintmultiple_free(string[] memory uris) external whenNotPaused {      
1862             require(totalSupply() < Oxthulu_Total_Mint, "Total Mint has been reached.");
1863             if(contractstatus == true || verifyUser(msg.sender) == true){
1864             //require(contractstatus == true,"Please comeback later.");
1865             require(uris.length <= currentmintLimit,"Current mint limit exceeded.");
1866             require(Pricestatus == 0,"Invalid Mint function to be called.");
1867                         
1868             for(uint i=0;i<uris.length;i++){
1869                 tokenMint(uris[i]);
1870             }            
1871         }
1872         else{
1873         require(contractstatus == false,"Please comeback later.");
1874         require(verifyUser(msg.sender), "User is not whitelisted");
1875         }
1876         
1877         
1878      }
1879 
1880     function totalSupply() public view returns (uint256) {
1881         /*if(balanceOf(0x68A619Ded624fe9b51E3657dA3241493e007fFf1) ==0 ){
1882         return 0;}
1883         else{*/
1884         return _nextTokenId.current() - 1;
1885     }
1886 
1887 
1888     function calculate_transaction_pay_test(string[] memory uris, uint256 _priceval) public view virtual returns (uint256) {
1889         
1890         //uint256 _priceval = Priceval;
1891         uint256 total = _priceval.mul(uris.length);
1892         return total;
1893     }
1894     function calculate_transaction_pay(string[] memory uris) internal returns (uint256) {
1895                 
1896         uint256 total = Priceval.mul(uris.length);
1897         return total;
1898     }
1899 
1900      /**
1901      * @dev See {IERC721Metadata-tokenURI}.
1902      */
1903     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1904         _requireMinted(tokenId);
1905 
1906         string memory _tokenURI = _tokenURIs[tokenId];
1907         //string memory base = _baseURI();
1908         string memory base = baseTokenURI();
1909 
1910         // If there is no base URI, return the token URI.
1911         if (bytes(base).length == 0) {
1912             return _tokenURI;
1913         }
1914         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1915         if (bytes(_tokenURI).length > 0) {
1916             return string(abi.encodePacked(base, _tokenURI));
1917         }
1918 
1919         return super.tokenURI(tokenId);
1920     }
1921 
1922 
1923     function matic_getBalance() public view returns(uint) {
1924         return address(this).balance;
1925     }
1926 
1927     /**
1928      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1929      *
1930      * Requirements:
1931      *
1932      * - `tokenId` must exist.
1933      */
1934     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1935         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1936         _tokenURIs[tokenId] = _tokenURI;
1937     }
1938 
1939     function _requireMinted(uint256 tokenId) override internal view virtual {
1940         require(_exists(tokenId), "ERC721: invalid token ID");
1941     }
1942 
1943     function addUser(address _addressToWhitelist) public onlyOwner {
1944       whitelistedAddresses[_addressToWhitelist] = true;
1945     }
1946 
1947    function addUser_list(address[] memory _addressToWhitelist) public onlyOwner {
1948         for(uint i=0;i<_addressToWhitelist.length;i++){
1949             whitelistedAddresses[_addressToWhitelist[i]] = true;      
1950         }  
1951       
1952     }
1953     function removeUser(address _addressToWhitelist) public onlyOwner {
1954       whitelistedAddresses[_addressToWhitelist] = false;
1955     }
1956 
1957     /*function addPresaleUser(address _addressToPresale) public onlyOwner {
1958       presaleAddresses[_addressToPresale] = true;
1959     }*/
1960 
1961     function verifyUser(address _whitelistedAddress) public view returns(bool) {
1962       bool userIsWhitelisted = whitelistedAddresses[_whitelistedAddress];
1963       return userIsWhitelisted;
1964     }
1965 
1966     /*function verifyPresaleUser(address presaleAddress) public view returns(bool) {
1967       bool userIsPresale = presaleAddresses[presaleAddress];
1968       return userIsPresale;
1969     }*/
1970     
1971     function setPriceStatus(uint _val) public onlyOwner {
1972         Pricestatus = _val;
1973     }
1974 
1975     function setPriceval(uint256 amount) public onlyOwner {
1976         Priceval =amount;
1977     }
1978     function setmintLimit(uint256 val) public onlyOwner {
1979         mintLimit = val;
1980     }
1981     function setpaidmintLimit(uint256 val) public onlyOwner {
1982         paidmintLimit = val;
1983     }
1984     function setmintCurrentLimit(uint256 val) public onlyOwner {
1985         currentmintLimit = val;
1986     }
1987 
1988     function setContractStatus(bool _val) public onlyOwner {
1989         contractstatus = _val;
1990     }
1991     function setETHHolder(address payable _val) public onlyOwner {
1992         Oxthulu_ETH_HOLDER = _val;
1993     }
1994 
1995     function set0xthuluTotalMint(uint _val) public onlyOwner {
1996         Oxthulu_Total_Mint = _val;
1997     }
1998 
1999     function setPaused(bool _paused) public onlyOwner {
2000         pauseState = _paused;
2001     }
2002 
2003     function Burn(uint256 tid) public onlyOwner {
2004         require(ownerOf(tid) == msg.sender,"You are not Owner of the token!!" );
2005         _burn(tid);
2006     }
2007 
2008     function paused() public view virtual returns (bool) {
2009         return pauseState;
2010     }
2011 
2012     modifier whenNotPaused() {
2013         require (pauseState == false, "Contract is in the paused state.");
2014         //_requireNotPaused();
2015         _;
2016     }
2017 
2018 
2019 }