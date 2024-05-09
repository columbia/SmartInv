1 // File: https://github.com/ProjectOpenSea/opensea-creatures/blob/f7257a043e82fae8251eec2bdde37a44fee474c4/contracts/common/meta-transactions/Initializable.sol
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
16 
17 // File: https://github.com/ProjectOpenSea/opensea-creatures/blob/f7257a043e82fae8251eec2bdde37a44fee474c4/contracts/common/meta-transactions/EIP712Base.sol
18 
19 
20 
21 pragma solidity ^0.8.0;
22 
23 
24 contract EIP712Base is Initializable {
25     struct EIP712Domain {
26         string name;
27         string version;
28         address verifyingContract;
29         bytes32 salt;
30     }
31 
32     string constant public ERC712_VERSION = "1";
33 
34     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
35         bytes(
36             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
37         )
38     );
39     bytes32 internal domainSeperator;
40 
41     // supposed to be called once while initializing.
42     // one of the contracts that inherits this contract follows proxy pattern
43     // so it is not possible to do this in a constructor
44     function _initializeEIP712(
45         string memory name
46     )
47         internal
48         initializer
49     {
50         _setDomainSeperator(name);
51     }
52 
53     function _setDomainSeperator(string memory name) internal {
54         domainSeperator = keccak256(
55             abi.encode(
56                 EIP712_DOMAIN_TYPEHASH,
57                 keccak256(bytes(name)),
58                 keccak256(bytes(ERC712_VERSION)),
59                 address(this),
60                 bytes32(getChainId())
61             )
62         );
63     }
64 
65     function getDomainSeperator() public view returns (bytes32) {
66         return domainSeperator;
67     }
68 
69     function getChainId() public view returns (uint256) {
70         uint256 id;
71         assembly {
72             id := chainid()
73         }
74         return id;
75     }
76 
77     /**
78      * Accept message hash and returns hash message in EIP712 compatible form
79      * So that it can be used to recover signer from signature signed using EIP712 formatted data
80      * https://eips.ethereum.org/EIPS/eip-712
81      * "\\x19" makes the encoding deterministic
82      * "\\x01" is the version byte to make it compatible to EIP-191
83      */
84     function toTypedMessageHash(bytes32 messageHash)
85         internal
86         view
87         returns (bytes32)
88     {
89         return
90             keccak256(
91                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
92             );
93     }
94 }
95 // File: https://github.com/ProjectOpenSea/opensea-creatures/blob/f7257a043e82fae8251eec2bdde37a44fee474c4/contracts/common/meta-transactions/ContentMixin.sol
96 
97 
98 
99 pragma solidity ^0.8.0;
100 
101 abstract contract ContextMixin {
102     function msgSender()
103         internal
104         view
105         returns (address payable sender)
106     {
107         if (msg.sender == address(this)) {
108             bytes memory array = msg.data;
109             uint256 index = msg.data.length;
110             assembly {
111                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
112                 sender := and(
113                     mload(add(array, index)),
114                     0xffffffffffffffffffffffffffffffffffffffff
115                 )
116             }
117         } else {
118             sender = payable(msg.sender);
119         }
120         return sender;
121     }
122 }
123 
124 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
125 
126 
127 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 // CAUTION
132 // This version of SafeMath should only be used with Solidity 0.8 or later,
133 // because it relies on the compiler's built in overflow checks.
134 
135 /**
136  * @dev Wrappers over Solidity's arithmetic operations.
137  *
138  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
139  * now has built in overflow checking.
140  */
141 library SafeMath {
142     /**
143      * @dev Returns the addition of two unsigned integers, with an overflow flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         unchecked {
149             uint256 c = a + b;
150             if (c < a) return (false, 0);
151             return (true, c);
152         }
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
157      *
158      * _Available since v3.4._
159      */
160     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         unchecked {
162             if (b > a) return (false, 0);
163             return (true, a - b);
164         }
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         unchecked {
174             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175             // benefit is lost if 'b' is also tested.
176             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
177             if (a == 0) return (true, 0);
178             uint256 c = a * b;
179             if (c / a != b) return (false, 0);
180             return (true, c);
181         }
182     }
183 
184     /**
185      * @dev Returns the division of two unsigned integers, with a division by zero flag.
186      *
187      * _Available since v3.4._
188      */
189     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
190         unchecked {
191             if (b == 0) return (false, 0);
192             return (true, a / b);
193         }
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
198      *
199      * _Available since v3.4._
200      */
201     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
202         unchecked {
203             if (b == 0) return (false, 0);
204             return (true, a % b);
205         }
206     }
207 
208     /**
209      * @dev Returns the addition of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `+` operator.
213      *
214      * Requirements:
215      *
216      * - Addition cannot overflow.
217      */
218     function add(uint256 a, uint256 b) internal pure returns (uint256) {
219         return a + b;
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      *
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return a - b;
234     }
235 
236     /**
237      * @dev Returns the multiplication of two unsigned integers, reverting on
238      * overflow.
239      *
240      * Counterpart to Solidity's `*` operator.
241      *
242      * Requirements:
243      *
244      * - Multiplication cannot overflow.
245      */
246     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247         return a * b;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers, reverting on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator.
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function div(uint256 a, uint256 b) internal pure returns (uint256) {
261         return a / b;
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * reverting when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a % b;
278     }
279 
280     /**
281      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
282      * overflow (when the result is negative).
283      *
284      * CAUTION: This function is deprecated because it requires allocating memory for the error
285      * message unnecessarily. For custom revert reasons use {trySub}.
286      *
287      * Counterpart to Solidity's `-` operator.
288      *
289      * Requirements:
290      *
291      * - Subtraction cannot overflow.
292      */
293     function sub(
294         uint256 a,
295         uint256 b,
296         string memory errorMessage
297     ) internal pure returns (uint256) {
298         unchecked {
299             require(b <= a, errorMessage);
300             return a - b;
301         }
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
306      * division by zero. The result is rounded towards zero.
307      *
308      * Counterpart to Solidity's `/` operator. Note: this function uses a
309      * `revert` opcode (which leaves remaining gas untouched) while Solidity
310      * uses an invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function div(
317         uint256 a,
318         uint256 b,
319         string memory errorMessage
320     ) internal pure returns (uint256) {
321         unchecked {
322             require(b > 0, errorMessage);
323             return a / b;
324         }
325     }
326 
327     /**
328      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
329      * reverting with custom message when dividing by zero.
330      *
331      * CAUTION: This function is deprecated because it requires allocating memory for the error
332      * message unnecessarily. For custom revert reasons use {tryMod}.
333      *
334      * Counterpart to Solidity's `%` operator. This function uses a `revert`
335      * opcode (which leaves remaining gas untouched) while Solidity uses an
336      * invalid opcode to revert (consuming all remaining gas).
337      *
338      * Requirements:
339      *
340      * - The divisor cannot be zero.
341      */
342     function mod(
343         uint256 a,
344         uint256 b,
345         string memory errorMessage
346     ) internal pure returns (uint256) {
347         unchecked {
348             require(b > 0, errorMessage);
349             return a % b;
350         }
351     }
352 }
353 
354 // File: https://github.com/ProjectOpenSea/opensea-creatures/blob/f7257a043e82fae8251eec2bdde37a44fee474c4/contracts/common/meta-transactions/NativeMetaTransaction.sol
355 
356 
357 
358 pragma solidity ^0.8.0;
359 
360 
361 
362 contract NativeMetaTransaction is EIP712Base {
363     using SafeMath for uint256;
364     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
365         bytes(
366             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
367         )
368     );
369     event MetaTransactionExecuted(
370         address userAddress,
371         address payable relayerAddress,
372         bytes functionSignature
373     );
374     mapping(address => uint256) nonces;
375 
376     /*
377      * Meta transaction structure.
378      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
379      * He should call the desired function directly in that case.
380      */
381     struct MetaTransaction {
382         uint256 nonce;
383         address from;
384         bytes functionSignature;
385     }
386 
387     function executeMetaTransaction(
388         address userAddress,
389         bytes memory functionSignature,
390         bytes32 sigR,
391         bytes32 sigS,
392         uint8 sigV
393     ) public payable returns (bytes memory) {
394         MetaTransaction memory metaTx = MetaTransaction({
395             nonce: nonces[userAddress],
396             from: userAddress,
397             functionSignature: functionSignature
398         });
399 
400         require(
401             verify(userAddress, metaTx, sigR, sigS, sigV),
402             "Signer and signature do not match"
403         );
404 
405         // increase nonce for user (to avoid re-use)
406         nonces[userAddress] = nonces[userAddress].add(1);
407 
408         emit MetaTransactionExecuted(
409             userAddress,
410             payable(msg.sender),
411             functionSignature
412         );
413 
414         // Append userAddress and relayer address at the end to extract it from calling context
415         (bool success, bytes memory returnData) = address(this).call(
416             abi.encodePacked(functionSignature, userAddress)
417         );
418         require(success, "Function call not successful");
419 
420         return returnData;
421     }
422 
423     function hashMetaTransaction(MetaTransaction memory metaTx)
424         internal
425         pure
426         returns (bytes32)
427     {
428         return
429             keccak256(
430                 abi.encode(
431                     META_TRANSACTION_TYPEHASH,
432                     metaTx.nonce,
433                     metaTx.from,
434                     keccak256(metaTx.functionSignature)
435                 )
436             );
437     }
438 
439     function getNonce(address user) public view returns (uint256 nonce) {
440         nonce = nonces[user];
441     }
442 
443     function verify(
444         address signer,
445         MetaTransaction memory metaTx,
446         bytes32 sigR,
447         bytes32 sigS,
448         uint8 sigV
449     ) internal view returns (bool) {
450         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
451         return
452             signer ==
453             ecrecover(
454                 toTypedMessageHash(hashMetaTransaction(metaTx)),
455                 sigV,
456                 sigR,
457                 sigS
458             );
459     }
460 }
461 
462 // File: openzeppelin-solidity/contracts/utils/Strings.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev String operations.
471  */
472 library Strings {
473     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
474 
475     /**
476      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
477      */
478     function toString(uint256 value) internal pure returns (string memory) {
479         // Inspired by OraclizeAPI's implementation - MIT licence
480         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
481 
482         if (value == 0) {
483             return "0";
484         }
485         uint256 temp = value;
486         uint256 digits;
487         while (temp != 0) {
488             digits++;
489             temp /= 10;
490         }
491         bytes memory buffer = new bytes(digits);
492         while (value != 0) {
493             digits -= 1;
494             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
495             value /= 10;
496         }
497         return string(buffer);
498     }
499 
500     /**
501      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
502      */
503     function toHexString(uint256 value) internal pure returns (string memory) {
504         if (value == 0) {
505             return "0x00";
506         }
507         uint256 temp = value;
508         uint256 length = 0;
509         while (temp != 0) {
510             length++;
511             temp >>= 8;
512         }
513         return toHexString(value, length);
514     }
515 
516     /**
517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
518      */
519     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
520         bytes memory buffer = new bytes(2 * length + 2);
521         buffer[0] = "0";
522         buffer[1] = "x";
523         for (uint256 i = 2 * length + 1; i > 1; --i) {
524             buffer[i] = _HEX_SYMBOLS[value & 0xf];
525             value >>= 4;
526         }
527         require(value == 0, "Strings: hex length insufficient");
528         return string(buffer);
529     }
530 }
531 
532 // File: openzeppelin-solidity/contracts/utils/Context.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @dev Provides information about the current execution context, including the
541  * sender of the transaction and its data. While these are generally available
542  * via msg.sender and msg.data, they should not be accessed in such a direct
543  * manner, since when dealing with meta-transactions the account sending and
544  * paying for execution may not be the actual sender (as far as an application
545  * is concerned).
546  *
547  * This contract is only required for intermediate, library-like contracts.
548  */
549 abstract contract Context {
550     function _msgSender() internal view virtual returns (address) {
551         return msg.sender;
552     }
553 
554     function _msgData() internal view virtual returns (bytes calldata) {
555         return msg.data;
556     }
557 }
558 
559 // File: openzeppelin-solidity/contracts/access/Ownable.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @dev Contract module which provides a basic access control mechanism, where
569  * there is an account (an owner) that can be granted exclusive access to
570  * specific functions.
571  *
572  * By default, the owner account will be the one that deploys the contract. This
573  * can later be changed with {transferOwnership}.
574  *
575  * This module is used through inheritance. It will make available the modifier
576  * `onlyOwner`, which can be applied to your functions to restrict their use to
577  * the owner.
578  */
579 abstract contract Ownable is Context {
580     address private _owner;
581 
582     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
583 
584     /**
585      * @dev Initializes the contract setting the deployer as the initial owner.
586      */
587     constructor() {
588         _transferOwnership(_msgSender());
589     }
590 
591     /**
592      * @dev Returns the address of the current owner.
593      */
594     function owner() public view virtual returns (address) {
595         return _owner;
596     }
597 
598     /**
599      * @dev Throws if called by any account other than the owner.
600      */
601     modifier onlyOwner() {
602         require(owner() == _msgSender(), "Ownable: caller is not the owner");
603         _;
604     }
605 
606     /**
607      * @dev Leaves the contract without owner. It will not be possible to call
608      * `onlyOwner` functions anymore. Can only be called by the current owner.
609      *
610      * NOTE: Renouncing ownership will leave the contract without an owner,
611      * thereby removing any functionality that is only available to the owner.
612      */
613     function renounceOwnership() public virtual onlyOwner {
614         _transferOwnership(address(0));
615     }
616 
617     /**
618      * @dev Transfers ownership of the contract to a new account (`newOwner`).
619      * Can only be called by the current owner.
620      */
621     function transferOwnership(address newOwner) public virtual onlyOwner {
622         require(newOwner != address(0), "Ownable: new owner is the zero address");
623         _transferOwnership(newOwner);
624     }
625 
626     /**
627      * @dev Transfers ownership of the contract to a new account (`newOwner`).
628      * Internal function without access restriction.
629      */
630     function _transferOwnership(address newOwner) internal virtual {
631         address oldOwner = _owner;
632         _owner = newOwner;
633         emit OwnershipTransferred(oldOwner, newOwner);
634     }
635 }
636 
637 // File: openzeppelin-solidity/contracts/utils/Address.sol
638 
639 
640 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
641 
642 pragma solidity ^0.8.1;
643 
644 /**
645  * @dev Collection of functions related to the address type
646  */
647 library Address {
648     /**
649      * @dev Returns true if `account` is a contract.
650      *
651      * [IMPORTANT]
652      * ====
653      * It is unsafe to assume that an address for which this function returns
654      * false is an externally-owned account (EOA) and not a contract.
655      *
656      * Among others, `isContract` will return false for the following
657      * types of addresses:
658      *
659      *  - an externally-owned account
660      *  - a contract in construction
661      *  - an address where a contract will be created
662      *  - an address where a contract lived, but was destroyed
663      * ====
664      *
665      * [IMPORTANT]
666      * ====
667      * You shouldn't rely on `isContract` to protect against flash loan attacks!
668      *
669      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
670      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
671      * constructor.
672      * ====
673      */
674     function isContract(address account) internal view returns (bool) {
675         // This method relies on extcodesize/address.code.length, which returns 0
676         // for contracts in construction, since the code is only stored at the end
677         // of the constructor execution.
678 
679         return account.code.length > 0;
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
862 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
863 
864 
865 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
882      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
883      */
884     function onERC721Received(
885         address operator,
886         address from,
887         uint256 tokenId,
888         bytes calldata data
889     ) external returns (bytes4);
890 }
891 
892 // File: openzeppelin-solidity/contracts/utils/introspection/IERC165.sol
893 
894 
895 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
920 // File: openzeppelin-solidity/contracts/utils/introspection/ERC165.sol
921 
922 
923 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
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
951 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
952 
953 
954 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
993      * @dev Safely transfers `tokenId` token from `from` to `to`.
994      *
995      * Requirements:
996      *
997      * - `from` cannot be the zero address.
998      * - `to` cannot be the zero address.
999      * - `tokenId` token must exist and be owned by `from`.
1000      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes calldata data
1010     ) external;
1011 
1012     /**
1013      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1014      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1015      *
1016      * Requirements:
1017      *
1018      * - `from` cannot be the zero address.
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must exist and be owned by `from`.
1021      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1022      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) external;
1031 
1032     /**
1033      * @dev Transfers `tokenId` token from `from` to `to`.
1034      *
1035      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1036      *
1037      * Requirements:
1038      *
1039      * - `from` cannot be the zero address.
1040      * - `to` cannot be the zero address.
1041      * - `tokenId` token must be owned by `from`.
1042      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function transferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) external;
1051 
1052     /**
1053      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1054      * The approval is cleared when the token is transferred.
1055      *
1056      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1057      *
1058      * Requirements:
1059      *
1060      * - The caller must own the token or be an approved operator.
1061      * - `tokenId` must exist.
1062      *
1063      * Emits an {Approval} event.
1064      */
1065     function approve(address to, uint256 tokenId) external;
1066 
1067     /**
1068      * @dev Approve or remove `operator` as an operator for the caller.
1069      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1070      *
1071      * Requirements:
1072      *
1073      * - The `operator` cannot be the caller.
1074      *
1075      * Emits an {ApprovalForAll} event.
1076      */
1077     function setApprovalForAll(address operator, bool _approved) external;
1078 
1079     /**
1080      * @dev Returns the account approved for `tokenId` token.
1081      *
1082      * Requirements:
1083      *
1084      * - `tokenId` must exist.
1085      */
1086     function getApproved(uint256 tokenId) external view returns (address operator);
1087 
1088     /**
1089      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1090      *
1091      * See {setApprovalForAll}
1092      */
1093     function isApprovedForAll(address owner, address operator) external view returns (bool);
1094 }
1095 
1096 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1097 
1098 
1099 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
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
1118     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1119 
1120     /**
1121      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1122      * Use along with {totalSupply} to enumerate all tokens.
1123      */
1124     function tokenByIndex(uint256 index) external view returns (uint256);
1125 }
1126 
1127 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Metadata.sol
1128 
1129 
1130 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
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
1156 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
1157 
1158 
1159 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
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
1259      * by default, can be overridden in child contracts.
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
1391         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
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
1446 
1447         _afterTokenTransfer(address(0), to, tokenId);
1448     }
1449 
1450     /**
1451      * @dev Destroys `tokenId`.
1452      * The approval is cleared when the token is burned.
1453      *
1454      * Requirements:
1455      *
1456      * - `tokenId` must exist.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _burn(uint256 tokenId) internal virtual {
1461         address owner = ERC721.ownerOf(tokenId);
1462 
1463         _beforeTokenTransfer(owner, address(0), tokenId);
1464 
1465         // Clear approvals
1466         _approve(address(0), tokenId);
1467 
1468         _balances[owner] -= 1;
1469         delete _owners[tokenId];
1470 
1471         emit Transfer(owner, address(0), tokenId);
1472 
1473         _afterTokenTransfer(owner, address(0), tokenId);
1474     }
1475 
1476     /**
1477      * @dev Transfers `tokenId` from `from` to `to`.
1478      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1479      *
1480      * Requirements:
1481      *
1482      * - `to` cannot be the zero address.
1483      * - `tokenId` token must be owned by `from`.
1484      *
1485      * Emits a {Transfer} event.
1486      */
1487     function _transfer(
1488         address from,
1489         address to,
1490         uint256 tokenId
1491     ) internal virtual {
1492         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1493         require(to != address(0), "ERC721: transfer to the zero address");
1494 
1495         _beforeTokenTransfer(from, to, tokenId);
1496 
1497         // Clear approvals from the previous owner
1498         _approve(address(0), tokenId);
1499 
1500         _balances[from] -= 1;
1501         _balances[to] += 1;
1502         _owners[tokenId] = to;
1503 
1504         emit Transfer(from, to, tokenId);
1505 
1506         _afterTokenTransfer(from, to, tokenId);
1507     }
1508 
1509     /**
1510      * @dev Approve `to` to operate on `tokenId`
1511      *
1512      * Emits a {Approval} event.
1513      */
1514     function _approve(address to, uint256 tokenId) internal virtual {
1515         _tokenApprovals[tokenId] = to;
1516         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1517     }
1518 
1519     /**
1520      * @dev Approve `operator` to operate on all of `owner` tokens
1521      *
1522      * Emits a {ApprovalForAll} event.
1523      */
1524     function _setApprovalForAll(
1525         address owner,
1526         address operator,
1527         bool approved
1528     ) internal virtual {
1529         require(owner != operator, "ERC721: approve to caller");
1530         _operatorApprovals[owner][operator] = approved;
1531         emit ApprovalForAll(owner, operator, approved);
1532     }
1533 
1534     /**
1535      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1536      * The call is not executed if the target address is not a contract.
1537      *
1538      * @param from address representing the previous owner of the given token ID
1539      * @param to target address that will receive the tokens
1540      * @param tokenId uint256 ID of the token to be transferred
1541      * @param _data bytes optional data to send along with the call
1542      * @return bool whether the call correctly returned the expected magic value
1543      */
1544     function _checkOnERC721Received(
1545         address from,
1546         address to,
1547         uint256 tokenId,
1548         bytes memory _data
1549     ) private returns (bool) {
1550         if (to.isContract()) {
1551             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1552                 return retval == IERC721Receiver.onERC721Received.selector;
1553             } catch (bytes memory reason) {
1554                 if (reason.length == 0) {
1555                     revert("ERC721: transfer to non ERC721Receiver implementer");
1556                 } else {
1557                     assembly {
1558                         revert(add(32, reason), mload(reason))
1559                     }
1560                 }
1561             }
1562         } else {
1563             return true;
1564         }
1565     }
1566 
1567     /**
1568      * @dev Hook that is called before any token transfer. This includes minting
1569      * and burning.
1570      *
1571      * Calling conditions:
1572      *
1573      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1574      * transferred to `to`.
1575      * - When `from` is zero, `tokenId` will be minted for `to`.
1576      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1577      * - `from` and `to` are never both zero.
1578      *
1579      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1580      */
1581     function _beforeTokenTransfer(
1582         address from,
1583         address to,
1584         uint256 tokenId
1585     ) internal virtual {}
1586 
1587     /**
1588      * @dev Hook that is called after any transfer of tokens. This includes
1589      * minting and burning.
1590      *
1591      * Calling conditions:
1592      *
1593      * - when `from` and `to` are both non-zero.
1594      * - `from` and `to` are never both zero.
1595      *
1596      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1597      */
1598     function _afterTokenTransfer(
1599         address from,
1600         address to,
1601         uint256 tokenId
1602     ) internal virtual {}
1603 }
1604 
1605 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1606 
1607 
1608 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1609 
1610 pragma solidity ^0.8.0;
1611 
1612 
1613 
1614 /**
1615  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1616  * enumerability of all the token ids in the contract as well as all token ids owned by each
1617  * account.
1618  */
1619 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1620     // Mapping from owner to list of owned token IDs
1621     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1622 
1623     // Mapping from token ID to index of the owner tokens list
1624     mapping(uint256 => uint256) private _ownedTokensIndex;
1625 
1626     // Array with all token ids, used for enumeration
1627     uint256[] private _allTokens;
1628 
1629     // Mapping from token id to position in the allTokens array
1630     mapping(uint256 => uint256) private _allTokensIndex;
1631 
1632     /**
1633      * @dev See {IERC165-supportsInterface}.
1634      */
1635     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1636         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1637     }
1638 
1639     /**
1640      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1641      */
1642     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1643         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1644         return _ownedTokens[owner][index];
1645     }
1646 
1647     /**
1648      * @dev See {IERC721Enumerable-totalSupply}.
1649      */
1650     function totalSupply() public view virtual override returns (uint256) {
1651         return _allTokens.length;
1652     }
1653 
1654     /**
1655      * @dev See {IERC721Enumerable-tokenByIndex}.
1656      */
1657     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1658         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1659         return _allTokens[index];
1660     }
1661 
1662     /**
1663      * @dev Hook that is called before any token transfer. This includes minting
1664      * and burning.
1665      *
1666      * Calling conditions:
1667      *
1668      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1669      * transferred to `to`.
1670      * - When `from` is zero, `tokenId` will be minted for `to`.
1671      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1672      * - `from` cannot be the zero address.
1673      * - `to` cannot be the zero address.
1674      *
1675      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1676      */
1677     function _beforeTokenTransfer(
1678         address from,
1679         address to,
1680         uint256 tokenId
1681     ) internal virtual override {
1682         super._beforeTokenTransfer(from, to, tokenId);
1683 
1684         if (from == address(0)) {
1685             _addTokenToAllTokensEnumeration(tokenId);
1686         } else if (from != to) {
1687             _removeTokenFromOwnerEnumeration(from, tokenId);
1688         }
1689         if (to == address(0)) {
1690             _removeTokenFromAllTokensEnumeration(tokenId);
1691         } else if (to != from) {
1692             _addTokenToOwnerEnumeration(to, tokenId);
1693         }
1694     }
1695 
1696     /**
1697      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1698      * @param to address representing the new owner of the given token ID
1699      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1700      */
1701     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1702         uint256 length = ERC721.balanceOf(to);
1703         _ownedTokens[to][length] = tokenId;
1704         _ownedTokensIndex[tokenId] = length;
1705     }
1706 
1707     /**
1708      * @dev Private function to add a token to this extension's token tracking data structures.
1709      * @param tokenId uint256 ID of the token to be added to the tokens list
1710      */
1711     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1712         _allTokensIndex[tokenId] = _allTokens.length;
1713         _allTokens.push(tokenId);
1714     }
1715 
1716     /**
1717      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1718      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1719      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1720      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1721      * @param from address representing the previous owner of the given token ID
1722      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1723      */
1724     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1725         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1726         // then delete the last slot (swap and pop).
1727 
1728         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1729         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1730 
1731         // When the token to delete is the last token, the swap operation is unnecessary
1732         if (tokenIndex != lastTokenIndex) {
1733             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1734 
1735             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1736             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1737         }
1738 
1739         // This also deletes the contents at the last position of the array
1740         delete _ownedTokensIndex[tokenId];
1741         delete _ownedTokens[from][lastTokenIndex];
1742     }
1743 
1744     /**
1745      * @dev Private function to remove a token from this extension's token tracking data structures.
1746      * This has O(1) time complexity, but alters the order of the _allTokens array.
1747      * @param tokenId uint256 ID of the token to be removed from the tokens list
1748      */
1749     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1750         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1751         // then delete the last slot (swap and pop).
1752 
1753         uint256 lastTokenIndex = _allTokens.length - 1;
1754         uint256 tokenIndex = _allTokensIndex[tokenId];
1755 
1756         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1757         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1758         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1759         uint256 lastTokenId = _allTokens[lastTokenIndex];
1760 
1761         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1762         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1763 
1764         // This also deletes the contents at the last position of the array
1765         delete _allTokensIndex[tokenId];
1766         _allTokens.pop();
1767     }
1768 }
1769 
1770 // File: contracts/McLarenNFT.sol
1771 
1772 
1773 
1774 pragma solidity ^0.8.1;
1775 
1776 
1777 
1778 
1779 
1780 
1781 
1782 
1783 contract OwnableDelegateProxy {}
1784 
1785 contract ProxyRegistry {
1786     mapping(address => OwnableDelegateProxy) public proxies;
1787 }
1788 
1789 /**
1790  * @title McLarenMSOLABGenesis
1791  * McLarenMSOLABGenesis - NFT contract for https://nft.mclaren.com/
1792  * ERC721 contract that whitelists a trading address, and has minting functionality.
1793  * ProxyAddress depends on the network you're deploying to. 
1794  * It's 0xf57b2c51ded3a29e6891aba85459d600256cf317 on Rinkeby and 0xa5409ec958c83c3f309868babaca7c86dcb077c1 on mainnet. 
1795  * See https://github.com/ProjectOpenSea/opensea-creatures/blob/master/migrations/2_deploy_contracts.js#L7-L12 for an example of conditionally setting the proxy registry address.
1796  */
1797 contract McLarenMSOLABGenesis is ContextMixin, ERC721Enumerable, NativeMetaTransaction, Ownable {
1798     using SafeMath for uint256;
1799 
1800     address proxyRegistryAddress;
1801     uint256 private _currentTokenId = 0;
1802     
1803     /**
1804      * @dev Mapping from NFT ID to metadata uri.
1805      */
1806     mapping (uint256 => string) internal idToUri;
1807 
1808     constructor(
1809         string memory _name,
1810         string memory _symbol,
1811         address _proxyRegistryAddress
1812     ) ERC721(_name, _symbol) {
1813         proxyRegistryAddress = _proxyRegistryAddress;
1814         _initializeEIP712(_name);
1815     }
1816 
1817     /**
1818      * @dev Returns contract-level metadata
1819      * based on https://docs.opensea.io/docs/contract-level-metadata
1820      */
1821     function contractURI() public pure returns (string memory) {
1822       return "https://mclaren-assets.s3.amazonaws.com/contract-assets/mclaren-contract-metadata.json";
1823     }
1824 
1825     /**
1826      * @dev Mints a token to an address with a tokenURI.
1827      * @param _to address of the future owner of the token
1828      * @param _tokenId tokenId of the token
1829      */
1830     function mintTo(address _to, uint256 _tokenId, string memory _uri) public onlyOwner {
1831         _mint(_to, _tokenId);
1832         _setTokenUri(_tokenId, _uri);
1833     }
1834 
1835     /**
1836      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1837      */
1838     function isApprovedForAll(address owner, address operator)
1839         override
1840         public
1841         view
1842         returns (bool)
1843     {
1844         // Whitelist OpenSea proxy contract for easy trading.
1845         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1846         if (address(proxyRegistry.proxies(owner)) == operator) {
1847             return true;
1848         }
1849 
1850         return super.isApprovedForAll(owner, operator);
1851     }
1852 
1853     /**
1854      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1855      */
1856     function _msgSender()
1857         internal
1858         override
1859         view
1860         returns (address sender)
1861     {
1862         return ContextMixin.msgSender();
1863     }
1864     
1865       /**
1866    * @dev A distinct URI (RFC 3986) for a given NFT.
1867    * @param _tokenId Id for which we want uri.
1868    * @return URI of _tokenId.
1869    */
1870 
1871   function tokenURI(
1872     uint256 _tokenId
1873   )
1874     public
1875     override
1876     view
1877     returns (string memory)
1878   {
1879     return _tokenURI(_tokenId);
1880   }
1881 
1882   /**
1883    * @notice This is an internal function that can be overriden if you want to implement a different
1884    * way to generate token URI.
1885    * @param _tokenId Id for which we want uri.
1886    * @return URI of _tokenId.
1887    */
1888   function _tokenURI(
1889     uint256 _tokenId
1890   )
1891     internal
1892     virtual
1893     view
1894     returns (string memory)
1895   {
1896     return idToUri[_tokenId];
1897   }
1898     
1899       /**
1900    * @notice This is an internal function which should be called from user-implemented external
1901    * function. Its purpose is to show and properly initialize data structures when using this
1902    * implementation.
1903    * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
1904    * @param _tokenId Id for which we want URI.
1905    * @param _uri String representing RFC 3986 URI.
1906    */
1907       function _setTokenUri(
1908         uint256 _tokenId,
1909         string memory _uri
1910       )
1911         internal
1912       {
1913         idToUri[_tokenId] = _uri;
1914       }
1915   
1916 }