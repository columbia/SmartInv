1 // File: IAllowsProxy.sol
2 
3 
4 pragma solidity >=0.8.4;
5 
6 interface IAllowsProxy {
7     function isProxyActive() external view returns (bool);
8 
9     function proxyAddress() external view returns (address);
10 
11     function isApprovedForProxy(address _owner, address _operator)
12         external
13         view
14         returns (bool);
15 }
16 
17 // File: IFactoryMintable.sol
18 
19 
20 pragma solidity >=0.8.4;
21 
22 interface IFactoryMintable {
23     function factoryMint(uint256 _optionId, address _to) external;
24 
25     function factoryCanMint(uint256 _optionId) external returns (bool);
26 }
27 
28 // File: INFT.sol
29 
30 
31 pragma solidity ^0.8.7;
32 
33 interface INFT{
34 
35     function mintTo(address recipient) external returns (uint256);
36 
37     function remaining() external view returns (uint256);
38 }
39 // File: Initializable.sol
40 
41 
42 pragma solidity ^0.8.7;
43 /**
44  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/Initializable.sol
45  */
46 contract Initializable {
47     bool inited = false;
48 
49     modifier initializer() {
50         require(!inited, "already inited");
51         _;
52         inited = true;
53     }
54 }
55 // File: EIP712Base.sol
56 
57 
58 pragma solidity ^0.8.7;
59 
60 
61 /**
62  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/EIP712Base.sol
63  */
64 contract EIP712Base is Initializable {
65     struct EIP712Domain {
66         string name;
67         string version;
68         address verifyingContract;
69         bytes32 salt;
70     }
71 
72     string public constant ERC712_VERSION = "1";
73 
74     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
75         keccak256(
76             bytes(
77                 "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
78             )
79         );
80     bytes32 internal domainSeperator;
81 
82     // supposed to be called once while initializing.
83     // one of the contractsa that inherits this contract follows proxy pattern
84     // so it is not possible to do this in a constructor
85     function _initializeEIP712(string memory name) internal initializer {
86         _setDomainSeperator(name);
87     }
88 
89     function _setDomainSeperator(string memory name) internal {
90         domainSeperator = keccak256(
91             abi.encode(
92                 EIP712_DOMAIN_TYPEHASH,
93                 keccak256(bytes(name)),
94                 keccak256(bytes(ERC712_VERSION)),
95                 address(this),
96                 bytes32(getChainId())
97             )
98         );
99     }
100 
101     function getDomainSeperator() public view returns (bytes32) {
102         return domainSeperator;
103     }
104 
105     function getChainId() public view returns (uint256) {
106         uint256 id;
107         assembly {
108             id := chainid()
109         }
110         return id;
111     }
112 
113     /**
114      * Accept message hash and returns hash message in EIP712 compatible form
115      * So that it can be used to recover signer from signature signed using EIP712 formatted data
116      * https://eips.ethereum.org/EIPS/eip-712
117      * "\\x19" makes the encoding deterministic
118      * "\\x01" is the version byte to make it compatible to EIP-191
119      */
120     function toTypedMessageHash(bytes32 messageHash)
121         internal
122         view
123         returns (bytes32)
124     {
125         return
126             keccak256(
127                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
128             );
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
133 
134 
135 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 // CAUTION
140 // This version of SafeMath should only be used with Solidity 0.8 or later,
141 // because it relies on the compiler's built in overflow checks.
142 
143 /**
144  * @dev Wrappers over Solidity's arithmetic operations.
145  *
146  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
147  * now has built in overflow checking.
148  */
149 library SafeMath {
150     /**
151      * @dev Returns the addition of two unsigned integers, with an overflow flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         unchecked {
157             uint256 c = a + b;
158             if (c < a) return (false, 0);
159             return (true, c);
160         }
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
165      *
166      * _Available since v3.4._
167      */
168     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
169         unchecked {
170             if (b > a) return (false, 0);
171             return (true, a - b);
172         }
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
177      *
178      * _Available since v3.4._
179      */
180     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
181         unchecked {
182             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183             // benefit is lost if 'b' is also tested.
184             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
185             if (a == 0) return (true, 0);
186             uint256 c = a * b;
187             if (c / a != b) return (false, 0);
188             return (true, c);
189         }
190     }
191 
192     /**
193      * @dev Returns the division of two unsigned integers, with a division by zero flag.
194      *
195      * _Available since v3.4._
196      */
197     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         unchecked {
199             if (b == 0) return (false, 0);
200             return (true, a / b);
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
206      *
207      * _Available since v3.4._
208      */
209     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         unchecked {
211             if (b == 0) return (false, 0);
212             return (true, a % b);
213         }
214     }
215 
216     /**
217      * @dev Returns the addition of two unsigned integers, reverting on
218      * overflow.
219      *
220      * Counterpart to Solidity's `+` operator.
221      *
222      * Requirements:
223      *
224      * - Addition cannot overflow.
225      */
226     function add(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a + b;
228     }
229 
230     /**
231      * @dev Returns the subtraction of two unsigned integers, reverting on
232      * overflow (when the result is negative).
233      *
234      * Counterpart to Solidity's `-` operator.
235      *
236      * Requirements:
237      *
238      * - Subtraction cannot overflow.
239      */
240     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a - b;
242     }
243 
244     /**
245      * @dev Returns the multiplication of two unsigned integers, reverting on
246      * overflow.
247      *
248      * Counterpart to Solidity's `*` operator.
249      *
250      * Requirements:
251      *
252      * - Multiplication cannot overflow.
253      */
254     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a * b;
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers, reverting on
260      * division by zero. The result is rounded towards zero.
261      *
262      * Counterpart to Solidity's `/` operator.
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function div(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a / b;
270     }
271 
272     /**
273      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
274      * reverting when dividing by zero.
275      *
276      * Counterpart to Solidity's `%` operator. This function uses a `revert`
277      * opcode (which leaves remaining gas untouched) while Solidity uses an
278      * invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      *
282      * - The divisor cannot be zero.
283      */
284     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
285         return a % b;
286     }
287 
288     /**
289      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
290      * overflow (when the result is negative).
291      *
292      * CAUTION: This function is deprecated because it requires allocating memory for the error
293      * message unnecessarily. For custom revert reasons use {trySub}.
294      *
295      * Counterpart to Solidity's `-` operator.
296      *
297      * Requirements:
298      *
299      * - Subtraction cannot overflow.
300      */
301     function sub(
302         uint256 a,
303         uint256 b,
304         string memory errorMessage
305     ) internal pure returns (uint256) {
306         unchecked {
307             require(b <= a, errorMessage);
308             return a - b;
309         }
310     }
311 
312     /**
313      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
314      * division by zero. The result is rounded towards zero.
315      *
316      * Counterpart to Solidity's `/` operator. Note: this function uses a
317      * `revert` opcode (which leaves remaining gas untouched) while Solidity
318      * uses an invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function div(
325         uint256 a,
326         uint256 b,
327         string memory errorMessage
328     ) internal pure returns (uint256) {
329         unchecked {
330             require(b > 0, errorMessage);
331             return a / b;
332         }
333     }
334 
335     /**
336      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
337      * reverting with custom message when dividing by zero.
338      *
339      * CAUTION: This function is deprecated because it requires allocating memory for the error
340      * message unnecessarily. For custom revert reasons use {tryMod}.
341      *
342      * Counterpart to Solidity's `%` operator. This function uses a `revert`
343      * opcode (which leaves remaining gas untouched) while Solidity uses an
344      * invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      *
348      * - The divisor cannot be zero.
349      */
350     function mod(
351         uint256 a,
352         uint256 b,
353         string memory errorMessage
354     ) internal pure returns (uint256) {
355         unchecked {
356             require(b > 0, errorMessage);
357             return a % b;
358         }
359     }
360 }
361 
362 // File: NativeMetaTransaction.sol
363 
364 
365 
366 pragma solidity ^0.8.0;
367 
368 
369 
370 contract NativeMetaTransaction is EIP712Base {
371     using SafeMath for uint256;
372     bytes32 private constant META_TRANSACTION_TYPEHASH =
373         keccak256(
374             bytes(
375                 "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
376             )
377         );
378     event MetaTransactionExecuted(
379         address userAddress,
380         address payable relayerAddress,
381         bytes functionSignature
382     );
383     mapping(address => uint256) nonces;
384 
385     /*
386      * Meta transaction structure.
387      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
388      * He should call the desired function directly in that case.
389      */
390     struct MetaTransaction {
391         uint256 nonce;
392         address from;
393         bytes functionSignature;
394     }
395 
396     function executeMetaTransactionWithExternalNonce(
397         address userAddress,
398         bytes memory functionSignature,
399         bytes32 sigR,
400         bytes32 sigS,
401         uint8 sigV,
402         uint256 userNonce
403     ) public payable returns (bytes memory) {
404         MetaTransaction memory metaTx = MetaTransaction({
405             nonce: userNonce,
406             from: userAddress,
407             functionSignature: functionSignature
408         });
409 
410         require(
411             verify(userAddress, metaTx, sigR, sigS, sigV),
412             "Signer and signature do not match"
413         );
414         require(userNonce == nonces[userAddress]);
415         // increase nonce for user (to avoid re-use)
416         nonces[userAddress] = userNonce.add(1);
417 
418         emit MetaTransactionExecuted(
419             userAddress,
420             payable(msg.sender),
421             functionSignature
422         );
423 
424         // Append userAddress and relayer address at the end to extract it from calling context
425         (bool success, bytes memory returnData) = address(this).call(
426             abi.encodePacked(functionSignature, userAddress)
427         );
428         require(success, "Function call not successful");
429 
430         return returnData;
431     }
432 
433     function hashMetaTransaction(MetaTransaction memory metaTx)
434         internal
435         pure
436         returns (bytes32)
437     {
438         return
439             keccak256(
440                 abi.encode(
441                     META_TRANSACTION_TYPEHASH,
442                     metaTx.nonce,
443                     metaTx.from,
444                     keccak256(metaTx.functionSignature)
445                 )
446             );
447     }
448 
449     function getNonce(address user) public view returns (uint256 nonce) {
450         nonce = nonces[user];
451     }
452 
453     function verify(
454         address signer,
455         MetaTransaction memory metaTx,
456         bytes32 sigR,
457         bytes32 sigS,
458         uint8 sigV
459     ) internal view returns (bool) {
460         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
461         return
462             signer ==
463             ecrecover(
464                 toTypedMessageHash(hashMetaTransaction(metaTx)),
465                 sigV,
466                 sigR,
467                 sigS
468             );
469     }
470 }
471 
472 // File: ContextMixin.sol
473 
474 
475 pragma solidity ^0.8.7;
476 /**
477  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/ContextMixin.sol
478  */
479 abstract contract ContextMixin {
480     function msgSender()
481         internal
482         view
483         returns (address payable sender)
484     {
485         if (msg.sender == address(this)) {
486             bytes memory array = msg.data;
487             uint256 index = msg.data.length;
488             assembly {
489                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
490                 sender := and(
491                     mload(add(array, index)),
492                     0xffffffffffffffffffffffffffffffffffffffff
493                 )
494             }
495         } else {
496             sender = payable(msg.sender);
497         }
498         return sender;
499     }
500 }
501 // File: @openzeppelin/contracts/access/IAccessControl.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev External interface of AccessControl declared to support ERC165 detection.
510  */
511 interface IAccessControl {
512     /**
513      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
514      *
515      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
516      * {RoleAdminChanged} not being emitted signaling this.
517      *
518      * _Available since v3.1._
519      */
520     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
521 
522     /**
523      * @dev Emitted when `account` is granted `role`.
524      *
525      * `sender` is the account that originated the contract call, an admin role
526      * bearer except when using {AccessControl-_setupRole}.
527      */
528     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
529 
530     /**
531      * @dev Emitted when `account` is revoked `role`.
532      *
533      * `sender` is the account that originated the contract call:
534      *   - if using `revokeRole`, it is the admin role bearer
535      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
536      */
537     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
538 
539     /**
540      * @dev Returns `true` if `account` has been granted `role`.
541      */
542     function hasRole(bytes32 role, address account) external view returns (bool);
543 
544     /**
545      * @dev Returns the admin role that controls `role`. See {grantRole} and
546      * {revokeRole}.
547      *
548      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
549      */
550     function getRoleAdmin(bytes32 role) external view returns (bytes32);
551 
552     /**
553      * @dev Grants `role` to `account`.
554      *
555      * If `account` had not been already granted `role`, emits a {RoleGranted}
556      * event.
557      *
558      * Requirements:
559      *
560      * - the caller must have ``role``'s admin role.
561      */
562     function grantRole(bytes32 role, address account) external;
563 
564     /**
565      * @dev Revokes `role` from `account`.
566      *
567      * If `account` had been granted `role`, emits a {RoleRevoked} event.
568      *
569      * Requirements:
570      *
571      * - the caller must have ``role``'s admin role.
572      */
573     function revokeRole(bytes32 role, address account) external;
574 
575     /**
576      * @dev Revokes `role` from the calling account.
577      *
578      * Roles are often managed via {grantRole} and {revokeRole}: this function's
579      * purpose is to provide a mechanism for accounts to lose their privileges
580      * if they are compromised (such as when a trusted device is misplaced).
581      *
582      * If the calling account had been granted `role`, emits a {RoleRevoked}
583      * event.
584      *
585      * Requirements:
586      *
587      * - the caller must be `account`.
588      */
589     function renounceRole(bytes32 role, address account) external;
590 }
591 
592 // File: @openzeppelin/contracts/utils/Counters.sol
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @title Counters
601  * @author Matt Condon (@shrugs)
602  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
603  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
604  *
605  * Include with `using Counters for Counters.Counter;`
606  */
607 library Counters {
608     struct Counter {
609         // This variable should never be directly accessed by users of the library: interactions must be restricted to
610         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
611         // this feature: see https://github.com/ethereum/solidity/issues/4637
612         uint256 _value; // default: 0
613     }
614 
615     function current(Counter storage counter) internal view returns (uint256) {
616         return counter._value;
617     }
618 
619     function increment(Counter storage counter) internal {
620         unchecked {
621             counter._value += 1;
622         }
623     }
624 
625     function decrement(Counter storage counter) internal {
626         uint256 value = counter._value;
627         require(value > 0, "Counter: decrement overflow");
628         unchecked {
629             counter._value = value - 1;
630         }
631     }
632 
633     function reset(Counter storage counter) internal {
634         counter._value = 0;
635     }
636 }
637 
638 // File: @openzeppelin/contracts/utils/Strings.sol
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev String operations.
647  */
648 library Strings {
649     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
650 
651     /**
652      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
653      */
654     function toString(uint256 value) internal pure returns (string memory) {
655         // Inspired by OraclizeAPI's implementation - MIT licence
656         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
657 
658         if (value == 0) {
659             return "0";
660         }
661         uint256 temp = value;
662         uint256 digits;
663         while (temp != 0) {
664             digits++;
665             temp /= 10;
666         }
667         bytes memory buffer = new bytes(digits);
668         while (value != 0) {
669             digits -= 1;
670             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
671             value /= 10;
672         }
673         return string(buffer);
674     }
675 
676     /**
677      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
678      */
679     function toHexString(uint256 value) internal pure returns (string memory) {
680         if (value == 0) {
681             return "0x00";
682         }
683         uint256 temp = value;
684         uint256 length = 0;
685         while (temp != 0) {
686             length++;
687             temp >>= 8;
688         }
689         return toHexString(value, length);
690     }
691 
692     /**
693      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
694      */
695     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
696         bytes memory buffer = new bytes(2 * length + 2);
697         buffer[0] = "0";
698         buffer[1] = "x";
699         for (uint256 i = 2 * length + 1; i > 1; --i) {
700             buffer[i] = _HEX_SYMBOLS[value & 0xf];
701             value >>= 4;
702         }
703         require(value == 0, "Strings: hex length insufficient");
704         return string(buffer);
705     }
706 }
707 
708 // File: @openzeppelin/contracts/utils/Context.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 /**
716  * @dev Provides information about the current execution context, including the
717  * sender of the transaction and its data. While these are generally available
718  * via msg.sender and msg.data, they should not be accessed in such a direct
719  * manner, since when dealing with meta-transactions the account sending and
720  * paying for execution may not be the actual sender (as far as an application
721  * is concerned).
722  *
723  * This contract is only required for intermediate, library-like contracts.
724  */
725 abstract contract Context {
726     function _msgSender() internal view virtual returns (address) {
727         return msg.sender;
728     }
729 
730     function _msgData() internal view virtual returns (bytes calldata) {
731         return msg.data;
732     }
733 }
734 
735 // File: FactoryMintable.sol
736 
737 
738 pragma solidity ^0.8.7;
739 
740 
741 
742 abstract contract FactoryMintable is IFactoryMintable, Context {
743     address public tokenFactory;
744 
745     error NotTokenFactory();
746     error FactoryCannotMint();
747 
748     modifier onlyFactory() {
749         if (_msgSender() != tokenFactory) {
750             revert NotTokenFactory();
751         }
752         _;
753     }
754 
755     modifier canMint(uint256 _optionId) {
756         if (!factoryCanMint(_optionId)) {
757             revert FactoryCannotMint();
758         }
759         _;
760     }
761 
762     function factoryMint(uint256 _optionId, address _to)
763         external
764         virtual
765         override;
766 
767     function factoryCanMint(uint256 _optionId)
768         public
769         view
770         virtual
771         override
772         returns (bool);
773 }
774 
775 // File: @openzeppelin/contracts/security/Pausable.sol
776 
777 
778 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 
783 /**
784  * @dev Contract module which allows children to implement an emergency stop
785  * mechanism that can be triggered by an authorized account.
786  *
787  * This module is used through inheritance. It will make available the
788  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
789  * the functions of your contract. Note that they will not be pausable by
790  * simply including this module, only once the modifiers are put in place.
791  */
792 abstract contract Pausable is Context {
793     /**
794      * @dev Emitted when the pause is triggered by `account`.
795      */
796     event Paused(address account);
797 
798     /**
799      * @dev Emitted when the pause is lifted by `account`.
800      */
801     event Unpaused(address account);
802 
803     bool private _paused;
804 
805     /**
806      * @dev Initializes the contract in unpaused state.
807      */
808     constructor() {
809         _paused = false;
810     }
811 
812     /**
813      * @dev Returns true if the contract is paused, and false otherwise.
814      */
815     function paused() public view virtual returns (bool) {
816         return _paused;
817     }
818 
819     /**
820      * @dev Modifier to make a function callable only when the contract is not paused.
821      *
822      * Requirements:
823      *
824      * - The contract must not be paused.
825      */
826     modifier whenNotPaused() {
827         require(!paused(), "Pausable: paused");
828         _;
829     }
830 
831     /**
832      * @dev Modifier to make a function callable only when the contract is paused.
833      *
834      * Requirements:
835      *
836      * - The contract must be paused.
837      */
838     modifier whenPaused() {
839         require(paused(), "Pausable: not paused");
840         _;
841     }
842 
843     /**
844      * @dev Triggers stopped state.
845      *
846      * Requirements:
847      *
848      * - The contract must not be paused.
849      */
850     function _pause() internal virtual whenNotPaused {
851         _paused = true;
852         emit Paused(_msgSender());
853     }
854 
855     /**
856      * @dev Returns to normal state.
857      *
858      * Requirements:
859      *
860      * - The contract must be paused.
861      */
862     function _unpause() internal virtual whenPaused {
863         _paused = false;
864         emit Unpaused(_msgSender());
865     }
866 }
867 
868 // File: @openzeppelin/contracts/access/Ownable.sol
869 
870 
871 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
872 
873 pragma solidity ^0.8.0;
874 
875 
876 /**
877  * @dev Contract module which provides a basic access control mechanism, where
878  * there is an account (an owner) that can be granted exclusive access to
879  * specific functions.
880  *
881  * By default, the owner account will be the one that deploys the contract. This
882  * can later be changed with {transferOwnership}.
883  *
884  * This module is used through inheritance. It will make available the modifier
885  * `onlyOwner`, which can be applied to your functions to restrict their use to
886  * the owner.
887  */
888 abstract contract Ownable is Context {
889     address private _owner;
890 
891     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
892 
893     /**
894      * @dev Initializes the contract setting the deployer as the initial owner.
895      */
896     constructor() {
897         _transferOwnership(_msgSender());
898     }
899 
900     /**
901      * @dev Returns the address of the current owner.
902      */
903     function owner() public view virtual returns (address) {
904         return _owner;
905     }
906 
907     /**
908      * @dev Throws if called by any account other than the owner.
909      */
910     modifier onlyOwner() {
911         require(owner() == _msgSender(), "Ownable: caller is not the owner");
912         _;
913     }
914 
915     /**
916      * @dev Leaves the contract without owner. It will not be possible to call
917      * `onlyOwner` functions anymore. Can only be called by the current owner.
918      *
919      * NOTE: Renouncing ownership will leave the contract without an owner,
920      * thereby removing any functionality that is only available to the owner.
921      */
922     function renounceOwnership() public virtual onlyOwner {
923         _transferOwnership(address(0));
924     }
925 
926     /**
927      * @dev Transfers ownership of the contract to a new account (`newOwner`).
928      * Can only be called by the current owner.
929      */
930     function transferOwnership(address newOwner) public virtual onlyOwner {
931         require(newOwner != address(0), "Ownable: new owner is the zero address");
932         _transferOwnership(newOwner);
933     }
934 
935     /**
936      * @dev Transfers ownership of the contract to a new account (`newOwner`).
937      * Internal function without access restriction.
938      */
939     function _transferOwnership(address newOwner) internal virtual {
940         address oldOwner = _owner;
941         _owner = newOwner;
942         emit OwnershipTransferred(oldOwner, newOwner);
943     }
944 }
945 
946 // File: AllowsConfigurableProxy.sol
947 
948 
949 pragma solidity >=0.8.4;
950 
951 
952 
953 contract OwnableDelegateProxy {}
954 
955 /**
956  * Used to delegate ownership of a contract to another address, to save on unneeded transactions to approve contract use for users
957  */
958 contract ProxyRegistry {
959     mapping(address => OwnableDelegateProxy) public proxies;
960 }
961 
962 contract AllowsConfigurableProxy is IAllowsProxy, Ownable {
963     bool internal isProxyActive_;
964     address internal proxyAddress_;
965 
966     constructor(address _proxyAddress, bool _isProxyActive) {
967         proxyAddress_ = _proxyAddress;
968         isProxyActive_ = _isProxyActive;
969     }
970 
971     function setIsProxyActive(bool _isProxyActive) external onlyOwner {
972         isProxyActive_ = _isProxyActive;
973     }
974 
975     function setProxyAddress(address _proxyAddress) public onlyOwner {
976         proxyAddress_ = _proxyAddress;
977     }
978 
979     function proxyAddress() public view override returns (address) {
980         return proxyAddress_;
981     }
982 
983     function isProxyActive() public view override returns (bool) {
984         return isProxyActive_;
985     }
986 
987     function isApprovedForProxy(address owner, address _operator)
988         public
989         view
990         override
991         returns (bool)
992     {
993         if (isProxyActive_ && proxyAddress_ == _operator) {
994             return true;
995         }
996         ProxyRegistry proxyRegistry = ProxyRegistry(proxyAddress_);
997         if (
998             isProxyActive_ && address(proxyRegistry.proxies(owner)) == _operator
999         ) {
1000             return true;
1001         }
1002         return false;
1003     }
1004 }
1005 
1006 // File: @openzeppelin/contracts/utils/Address.sol
1007 
1008 
1009 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1010 
1011 pragma solidity ^0.8.1;
1012 
1013 /**
1014  * @dev Collection of functions related to the address type
1015  */
1016 library Address {
1017     /**
1018      * @dev Returns true if `account` is a contract.
1019      *
1020      * [IMPORTANT]
1021      * ====
1022      * It is unsafe to assume that an address for which this function returns
1023      * false is an externally-owned account (EOA) and not a contract.
1024      *
1025      * Among others, `isContract` will return false for the following
1026      * types of addresses:
1027      *
1028      *  - an externally-owned account
1029      *  - a contract in construction
1030      *  - an address where a contract will be created
1031      *  - an address where a contract lived, but was destroyed
1032      * ====
1033      *
1034      * [IMPORTANT]
1035      * ====
1036      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1037      *
1038      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1039      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1040      * constructor.
1041      * ====
1042      */
1043     function isContract(address account) internal view returns (bool) {
1044         // This method relies on extcodesize/address.code.length, which returns 0
1045         // for contracts in construction, since the code is only stored at the end
1046         // of the constructor execution.
1047 
1048         return account.code.length > 0;
1049     }
1050 
1051     /**
1052      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1053      * `recipient`, forwarding all available gas and reverting on errors.
1054      *
1055      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1056      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1057      * imposed by `transfer`, making them unable to receive funds via
1058      * `transfer`. {sendValue} removes this limitation.
1059      *
1060      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1061      *
1062      * IMPORTANT: because control is transferred to `recipient`, care must be
1063      * taken to not create reentrancy vulnerabilities. Consider using
1064      * {ReentrancyGuard} or the
1065      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1066      */
1067     function sendValue(address payable recipient, uint256 amount) internal {
1068         require(address(this).balance >= amount, "Address: insufficient balance");
1069 
1070         (bool success, ) = recipient.call{value: amount}("");
1071         require(success, "Address: unable to send value, recipient may have reverted");
1072     }
1073 
1074     /**
1075      * @dev Performs a Solidity function call using a low level `call`. A
1076      * plain `call` is an unsafe replacement for a function call: use this
1077      * function instead.
1078      *
1079      * If `target` reverts with a revert reason, it is bubbled up by this
1080      * function (like regular Solidity function calls).
1081      *
1082      * Returns the raw returned data. To convert to the expected return value,
1083      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1084      *
1085      * Requirements:
1086      *
1087      * - `target` must be a contract.
1088      * - calling `target` with `data` must not revert.
1089      *
1090      * _Available since v3.1._
1091      */
1092     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1093         return functionCall(target, data, "Address: low-level call failed");
1094     }
1095 
1096     /**
1097      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1098      * `errorMessage` as a fallback revert reason when `target` reverts.
1099      *
1100      * _Available since v3.1._
1101      */
1102     function functionCall(
1103         address target,
1104         bytes memory data,
1105         string memory errorMessage
1106     ) internal returns (bytes memory) {
1107         return functionCallWithValue(target, data, 0, errorMessage);
1108     }
1109 
1110     /**
1111      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1112      * but also transferring `value` wei to `target`.
1113      *
1114      * Requirements:
1115      *
1116      * - the calling contract must have an ETH balance of at least `value`.
1117      * - the called Solidity function must be `payable`.
1118      *
1119      * _Available since v3.1._
1120      */
1121     function functionCallWithValue(
1122         address target,
1123         bytes memory data,
1124         uint256 value
1125     ) internal returns (bytes memory) {
1126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1127     }
1128 
1129     /**
1130      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1131      * with `errorMessage` as a fallback revert reason when `target` reverts.
1132      *
1133      * _Available since v3.1._
1134      */
1135     function functionCallWithValue(
1136         address target,
1137         bytes memory data,
1138         uint256 value,
1139         string memory errorMessage
1140     ) internal returns (bytes memory) {
1141         require(address(this).balance >= value, "Address: insufficient balance for call");
1142         require(isContract(target), "Address: call to non-contract");
1143 
1144         (bool success, bytes memory returndata) = target.call{value: value}(data);
1145         return verifyCallResult(success, returndata, errorMessage);
1146     }
1147 
1148     /**
1149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1150      * but performing a static call.
1151      *
1152      * _Available since v3.3._
1153      */
1154     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1155         return functionStaticCall(target, data, "Address: low-level static call failed");
1156     }
1157 
1158     /**
1159      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1160      * but performing a static call.
1161      *
1162      * _Available since v3.3._
1163      */
1164     function functionStaticCall(
1165         address target,
1166         bytes memory data,
1167         string memory errorMessage
1168     ) internal view returns (bytes memory) {
1169         require(isContract(target), "Address: static call to non-contract");
1170 
1171         (bool success, bytes memory returndata) = target.staticcall(data);
1172         return verifyCallResult(success, returndata, errorMessage);
1173     }
1174 
1175     /**
1176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1177      * but performing a delegate call.
1178      *
1179      * _Available since v3.4._
1180      */
1181     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1182         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1183     }
1184 
1185     /**
1186      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1187      * but performing a delegate call.
1188      *
1189      * _Available since v3.4._
1190      */
1191     function functionDelegateCall(
1192         address target,
1193         bytes memory data,
1194         string memory errorMessage
1195     ) internal returns (bytes memory) {
1196         require(isContract(target), "Address: delegate call to non-contract");
1197 
1198         (bool success, bytes memory returndata) = target.delegatecall(data);
1199         return verifyCallResult(success, returndata, errorMessage);
1200     }
1201 
1202     /**
1203      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1204      * revert reason using the provided one.
1205      *
1206      * _Available since v4.3._
1207      */
1208     function verifyCallResult(
1209         bool success,
1210         bytes memory returndata,
1211         string memory errorMessage
1212     ) internal pure returns (bytes memory) {
1213         if (success) {
1214             return returndata;
1215         } else {
1216             // Look for revert reason and bubble it up if present
1217             if (returndata.length > 0) {
1218                 // The easiest way to bubble the revert reason is using memory via assembly
1219 
1220                 assembly {
1221                     let returndata_size := mload(returndata)
1222                     revert(add(32, returndata), returndata_size)
1223                 }
1224             } else {
1225                 revert(errorMessage);
1226             }
1227         }
1228     }
1229 }
1230 
1231 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1232 
1233 
1234 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 /**
1239  * @title ERC721 token receiver interface
1240  * @dev Interface for any contract that wants to support safeTransfers
1241  * from ERC721 asset contracts.
1242  */
1243 interface IERC721Receiver {
1244     /**
1245      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1246      * by `operator` from `from`, this function is called.
1247      *
1248      * It must return its Solidity selector to confirm the token transfer.
1249      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1250      *
1251      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1252      */
1253     function onERC721Received(
1254         address operator,
1255         address from,
1256         uint256 tokenId,
1257         bytes calldata data
1258     ) external returns (bytes4);
1259 }
1260 
1261 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1262 
1263 
1264 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1265 
1266 pragma solidity ^0.8.0;
1267 
1268 /**
1269  * @dev Interface of the ERC165 standard, as defined in the
1270  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1271  *
1272  * Implementers can declare support of contract interfaces, which can then be
1273  * queried by others ({ERC165Checker}).
1274  *
1275  * For an implementation, see {ERC165}.
1276  */
1277 interface IERC165 {
1278     /**
1279      * @dev Returns true if this contract implements the interface defined by
1280      * `interfaceId`. See the corresponding
1281      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1282      * to learn more about how these ids are created.
1283      *
1284      * This function call must use less than 30 000 gas.
1285      */
1286     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1287 }
1288 
1289 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1290 
1291 
1292 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1293 
1294 pragma solidity ^0.8.0;
1295 
1296 
1297 /**
1298  * @dev Implementation of the {IERC165} interface.
1299  *
1300  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1301  * for the additional interface id that will be supported. For example:
1302  *
1303  * ```solidity
1304  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1305  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1306  * }
1307  * ```
1308  *
1309  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1310  */
1311 abstract contract ERC165 is IERC165 {
1312     /**
1313      * @dev See {IERC165-supportsInterface}.
1314      */
1315     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1316         return interfaceId == type(IERC165).interfaceId;
1317     }
1318 }
1319 
1320 // File: @openzeppelin/contracts/access/AccessControl.sol
1321 
1322 
1323 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
1324 
1325 pragma solidity ^0.8.0;
1326 
1327 
1328 
1329 
1330 
1331 /**
1332  * @dev Contract module that allows children to implement role-based access
1333  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1334  * members except through off-chain means by accessing the contract event logs. Some
1335  * applications may benefit from on-chain enumerability, for those cases see
1336  * {AccessControlEnumerable}.
1337  *
1338  * Roles are referred to by their `bytes32` identifier. These should be exposed
1339  * in the external API and be unique. The best way to achieve this is by
1340  * using `public constant` hash digests:
1341  *
1342  * ```
1343  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1344  * ```
1345  *
1346  * Roles can be used to represent a set of permissions. To restrict access to a
1347  * function call, use {hasRole}:
1348  *
1349  * ```
1350  * function foo() public {
1351  *     require(hasRole(MY_ROLE, msg.sender));
1352  *     ...
1353  * }
1354  * ```
1355  *
1356  * Roles can be granted and revoked dynamically via the {grantRole} and
1357  * {revokeRole} functions. Each role has an associated admin role, and only
1358  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1359  *
1360  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1361  * that only accounts with this role will be able to grant or revoke other
1362  * roles. More complex role relationships can be created by using
1363  * {_setRoleAdmin}.
1364  *
1365  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1366  * grant and revoke this role. Extra precautions should be taken to secure
1367  * accounts that have been granted it.
1368  */
1369 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1370     struct RoleData {
1371         mapping(address => bool) members;
1372         bytes32 adminRole;
1373     }
1374 
1375     mapping(bytes32 => RoleData) private _roles;
1376 
1377     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1378 
1379     /**
1380      * @dev Modifier that checks that an account has a specific role. Reverts
1381      * with a standardized message including the required role.
1382      *
1383      * The format of the revert reason is given by the following regular expression:
1384      *
1385      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1386      *
1387      * _Available since v4.1._
1388      */
1389     modifier onlyRole(bytes32 role) {
1390         _checkRole(role);
1391         _;
1392     }
1393 
1394     /**
1395      * @dev See {IERC165-supportsInterface}.
1396      */
1397     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1398         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1399     }
1400 
1401     /**
1402      * @dev Returns `true` if `account` has been granted `role`.
1403      */
1404     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1405         return _roles[role].members[account];
1406     }
1407 
1408     /**
1409      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1410      * Overriding this function changes the behavior of the {onlyRole} modifier.
1411      *
1412      * Format of the revert message is described in {_checkRole}.
1413      *
1414      * _Available since v4.6._
1415      */
1416     function _checkRole(bytes32 role) internal view virtual {
1417         _checkRole(role, _msgSender());
1418     }
1419 
1420     /**
1421      * @dev Revert with a standard message if `account` is missing `role`.
1422      *
1423      * The format of the revert reason is given by the following regular expression:
1424      *
1425      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1426      */
1427     function _checkRole(bytes32 role, address account) internal view virtual {
1428         if (!hasRole(role, account)) {
1429             revert(
1430                 string(
1431                     abi.encodePacked(
1432                         "AccessControl: account ",
1433                         Strings.toHexString(uint160(account), 20),
1434                         " is missing role ",
1435                         Strings.toHexString(uint256(role), 32)
1436                     )
1437                 )
1438             );
1439         }
1440     }
1441 
1442     /**
1443      * @dev Returns the admin role that controls `role`. See {grantRole} and
1444      * {revokeRole}.
1445      *
1446      * To change a role's admin, use {_setRoleAdmin}.
1447      */
1448     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1449         return _roles[role].adminRole;
1450     }
1451 
1452     /**
1453      * @dev Grants `role` to `account`.
1454      *
1455      * If `account` had not been already granted `role`, emits a {RoleGranted}
1456      * event.
1457      *
1458      * Requirements:
1459      *
1460      * - the caller must have ``role``'s admin role.
1461      */
1462     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1463         _grantRole(role, account);
1464     }
1465 
1466     /**
1467      * @dev Revokes `role` from `account`.
1468      *
1469      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1470      *
1471      * Requirements:
1472      *
1473      * - the caller must have ``role``'s admin role.
1474      */
1475     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1476         _revokeRole(role, account);
1477     }
1478 
1479     /**
1480      * @dev Revokes `role` from the calling account.
1481      *
1482      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1483      * purpose is to provide a mechanism for accounts to lose their privileges
1484      * if they are compromised (such as when a trusted device is misplaced).
1485      *
1486      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1487      * event.
1488      *
1489      * Requirements:
1490      *
1491      * - the caller must be `account`.
1492      */
1493     function renounceRole(bytes32 role, address account) public virtual override {
1494         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1495 
1496         _revokeRole(role, account);
1497     }
1498 
1499     /**
1500      * @dev Grants `role` to `account`.
1501      *
1502      * If `account` had not been already granted `role`, emits a {RoleGranted}
1503      * event. Note that unlike {grantRole}, this function doesn't perform any
1504      * checks on the calling account.
1505      *
1506      * [WARNING]
1507      * ====
1508      * This function should only be called from the constructor when setting
1509      * up the initial roles for the system.
1510      *
1511      * Using this function in any other way is effectively circumventing the admin
1512      * system imposed by {AccessControl}.
1513      * ====
1514      *
1515      * NOTE: This function is deprecated in favor of {_grantRole}.
1516      */
1517     function _setupRole(bytes32 role, address account) internal virtual {
1518         _grantRole(role, account);
1519     }
1520 
1521     /**
1522      * @dev Sets `adminRole` as ``role``'s admin role.
1523      *
1524      * Emits a {RoleAdminChanged} event.
1525      */
1526     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1527         bytes32 previousAdminRole = getRoleAdmin(role);
1528         _roles[role].adminRole = adminRole;
1529         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1530     }
1531 
1532     /**
1533      * @dev Grants `role` to `account`.
1534      *
1535      * Internal function without access restriction.
1536      */
1537     function _grantRole(bytes32 role, address account) internal virtual {
1538         if (!hasRole(role, account)) {
1539             _roles[role].members[account] = true;
1540             emit RoleGranted(role, account, _msgSender());
1541         }
1542     }
1543 
1544     /**
1545      * @dev Revokes `role` from `account`.
1546      *
1547      * Internal function without access restriction.
1548      */
1549     function _revokeRole(bytes32 role, address account) internal virtual {
1550         if (hasRole(role, account)) {
1551             _roles[role].members[account] = false;
1552             emit RoleRevoked(role, account, _msgSender());
1553         }
1554     }
1555 }
1556 
1557 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1558 
1559 
1560 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1561 
1562 pragma solidity ^0.8.0;
1563 
1564 
1565 /**
1566  * @dev Required interface of an ERC721 compliant contract.
1567  */
1568 interface IERC721 is IERC165 {
1569     /**
1570      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1571      */
1572     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1573 
1574     /**
1575      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1576      */
1577     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1578 
1579     /**
1580      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1581      */
1582     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1583 
1584     /**
1585      * @dev Returns the number of tokens in ``owner``'s account.
1586      */
1587     function balanceOf(address owner) external view returns (uint256 balance);
1588 
1589     /**
1590      * @dev Returns the owner of the `tokenId` token.
1591      *
1592      * Requirements:
1593      *
1594      * - `tokenId` must exist.
1595      */
1596     function ownerOf(uint256 tokenId) external view returns (address owner);
1597 
1598     /**
1599      * @dev Safely transfers `tokenId` token from `from` to `to`.
1600      *
1601      * Requirements:
1602      *
1603      * - `from` cannot be the zero address.
1604      * - `to` cannot be the zero address.
1605      * - `tokenId` token must exist and be owned by `from`.
1606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function safeTransferFrom(
1612         address from,
1613         address to,
1614         uint256 tokenId,
1615         bytes calldata data
1616     ) external;
1617 
1618     /**
1619      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1620      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1621      *
1622      * Requirements:
1623      *
1624      * - `from` cannot be the zero address.
1625      * - `to` cannot be the zero address.
1626      * - `tokenId` token must exist and be owned by `from`.
1627      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function safeTransferFrom(
1633         address from,
1634         address to,
1635         uint256 tokenId
1636     ) external;
1637 
1638     /**
1639      * @dev Transfers `tokenId` token from `from` to `to`.
1640      *
1641      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1642      *
1643      * Requirements:
1644      *
1645      * - `from` cannot be the zero address.
1646      * - `to` cannot be the zero address.
1647      * - `tokenId` token must be owned by `from`.
1648      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1649      *
1650      * Emits a {Transfer} event.
1651      */
1652     function transferFrom(
1653         address from,
1654         address to,
1655         uint256 tokenId
1656     ) external;
1657 
1658     /**
1659      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1660      * The approval is cleared when the token is transferred.
1661      *
1662      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1663      *
1664      * Requirements:
1665      *
1666      * - The caller must own the token or be an approved operator.
1667      * - `tokenId` must exist.
1668      *
1669      * Emits an {Approval} event.
1670      */
1671     function approve(address to, uint256 tokenId) external;
1672 
1673     /**
1674      * @dev Approve or remove `operator` as an operator for the caller.
1675      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1676      *
1677      * Requirements:
1678      *
1679      * - The `operator` cannot be the caller.
1680      *
1681      * Emits an {ApprovalForAll} event.
1682      */
1683     function setApprovalForAll(address operator, bool _approved) external;
1684 
1685     /**
1686      * @dev Returns the account approved for `tokenId` token.
1687      *
1688      * Requirements:
1689      *
1690      * - `tokenId` must exist.
1691      */
1692     function getApproved(uint256 tokenId) external view returns (address operator);
1693 
1694     /**
1695      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1696      *
1697      * See {setApprovalForAll}
1698      */
1699     function isApprovedForAll(address owner, address operator) external view returns (bool);
1700 }
1701 
1702 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1703 
1704 
1705 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1706 
1707 pragma solidity ^0.8.0;
1708 
1709 
1710 /**
1711  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1712  * @dev See https://eips.ethereum.org/EIPS/eip-721
1713  */
1714 interface IERC721Enumerable is IERC721 {
1715     /**
1716      * @dev Returns the total amount of tokens stored by the contract.
1717      */
1718     function totalSupply() external view returns (uint256);
1719 
1720     /**
1721      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1722      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1723      */
1724     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1725 
1726     /**
1727      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1728      * Use along with {totalSupply} to enumerate all tokens.
1729      */
1730     function tokenByIndex(uint256 index) external view returns (uint256);
1731 }
1732 
1733 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1734 
1735 
1736 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1737 
1738 pragma solidity ^0.8.0;
1739 
1740 
1741 /**
1742  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1743  * @dev See https://eips.ethereum.org/EIPS/eip-721
1744  */
1745 interface IERC721Metadata is IERC721 {
1746     /**
1747      * @dev Returns the token collection name.
1748      */
1749     function name() external view returns (string memory);
1750 
1751     /**
1752      * @dev Returns the token collection symbol.
1753      */
1754     function symbol() external view returns (string memory);
1755 
1756     /**
1757      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1758      */
1759     function tokenURI(uint256 tokenId) external view returns (string memory);
1760 }
1761 
1762 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1763 
1764 
1765 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1766 
1767 pragma solidity ^0.8.0;
1768 
1769 
1770 
1771 
1772 
1773 
1774 
1775 
1776 /**
1777  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1778  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1779  * {ERC721Enumerable}.
1780  */
1781 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1782     using Address for address;
1783     using Strings for uint256;
1784 
1785     // Token name
1786     string private _name;
1787 
1788     // Token symbol
1789     string private _symbol;
1790 
1791     // Mapping from token ID to owner address
1792     mapping(uint256 => address) private _owners;
1793 
1794     // Mapping owner address to token count
1795     mapping(address => uint256) private _balances;
1796 
1797     // Mapping from token ID to approved address
1798     mapping(uint256 => address) private _tokenApprovals;
1799 
1800     // Mapping from owner to operator approvals
1801     mapping(address => mapping(address => bool)) private _operatorApprovals;
1802 
1803     /**
1804      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1805      */
1806     constructor(string memory name_, string memory symbol_) {
1807         _name = name_;
1808         _symbol = symbol_;
1809     }
1810 
1811     /**
1812      * @dev See {IERC165-supportsInterface}.
1813      */
1814     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1815         return
1816             interfaceId == type(IERC721).interfaceId ||
1817             interfaceId == type(IERC721Metadata).interfaceId ||
1818             super.supportsInterface(interfaceId);
1819     }
1820 
1821     /**
1822      * @dev See {IERC721-balanceOf}.
1823      */
1824     function balanceOf(address owner) public view virtual override returns (uint256) {
1825         require(owner != address(0), "ERC721: balance query for the zero address");
1826         return _balances[owner];
1827     }
1828 
1829     /**
1830      * @dev See {IERC721-ownerOf}.
1831      */
1832     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1833         address owner = _owners[tokenId];
1834         require(owner != address(0), "ERC721: owner query for nonexistent token");
1835         return owner;
1836     }
1837 
1838     /**
1839      * @dev See {IERC721Metadata-name}.
1840      */
1841     function name() public view virtual override returns (string memory) {
1842         return _name;
1843     }
1844 
1845     /**
1846      * @dev See {IERC721Metadata-symbol}.
1847      */
1848     function symbol() public view virtual override returns (string memory) {
1849         return _symbol;
1850     }
1851 
1852     /**
1853      * @dev See {IERC721Metadata-tokenURI}.
1854      */
1855     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1856         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1857 
1858         string memory baseURI = _baseURI();
1859         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1860     }
1861 
1862     /**
1863      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1864      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1865      * by default, can be overridden in child contracts.
1866      */
1867     function _baseURI() internal view virtual returns (string memory) {
1868         return "";
1869     }
1870 
1871     /**
1872      * @dev See {IERC721-approve}.
1873      */
1874     function approve(address to, uint256 tokenId) public virtual override {
1875         address owner = ERC721.ownerOf(tokenId);
1876         require(to != owner, "ERC721: approval to current owner");
1877 
1878         require(
1879             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1880             "ERC721: approve caller is not owner nor approved for all"
1881         );
1882 
1883         _approve(to, tokenId);
1884     }
1885 
1886     /**
1887      * @dev See {IERC721-getApproved}.
1888      */
1889     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1890         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1891 
1892         return _tokenApprovals[tokenId];
1893     }
1894 
1895     /**
1896      * @dev See {IERC721-setApprovalForAll}.
1897      */
1898     function setApprovalForAll(address operator, bool approved) public virtual override {
1899         _setApprovalForAll(_msgSender(), operator, approved);
1900     }
1901 
1902     /**
1903      * @dev See {IERC721-isApprovedForAll}.
1904      */
1905     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1906         return _operatorApprovals[owner][operator];
1907     }
1908 
1909     /**
1910      * @dev See {IERC721-transferFrom}.
1911      */
1912     function transferFrom(
1913         address from,
1914         address to,
1915         uint256 tokenId
1916     ) public virtual override {
1917         //solhint-disable-next-line max-line-length
1918         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1919 
1920         _transfer(from, to, tokenId);
1921     }
1922 
1923     /**
1924      * @dev See {IERC721-safeTransferFrom}.
1925      */
1926     function safeTransferFrom(
1927         address from,
1928         address to,
1929         uint256 tokenId
1930     ) public virtual override {
1931         safeTransferFrom(from, to, tokenId, "");
1932     }
1933 
1934     /**
1935      * @dev See {IERC721-safeTransferFrom}.
1936      */
1937     function safeTransferFrom(
1938         address from,
1939         address to,
1940         uint256 tokenId,
1941         bytes memory _data
1942     ) public virtual override {
1943         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1944         _safeTransfer(from, to, tokenId, _data);
1945     }
1946 
1947     /**
1948      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1949      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1950      *
1951      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1952      *
1953      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1954      * implement alternative mechanisms to perform token transfer, such as signature-based.
1955      *
1956      * Requirements:
1957      *
1958      * - `from` cannot be the zero address.
1959      * - `to` cannot be the zero address.
1960      * - `tokenId` token must exist and be owned by `from`.
1961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1962      *
1963      * Emits a {Transfer} event.
1964      */
1965     function _safeTransfer(
1966         address from,
1967         address to,
1968         uint256 tokenId,
1969         bytes memory _data
1970     ) internal virtual {
1971         _transfer(from, to, tokenId);
1972         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1973     }
1974 
1975     /**
1976      * @dev Returns whether `tokenId` exists.
1977      *
1978      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1979      *
1980      * Tokens start existing when they are minted (`_mint`),
1981      * and stop existing when they are burned (`_burn`).
1982      */
1983     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1984         return _owners[tokenId] != address(0);
1985     }
1986 
1987     /**
1988      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1989      *
1990      * Requirements:
1991      *
1992      * - `tokenId` must exist.
1993      */
1994     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1995         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1996         address owner = ERC721.ownerOf(tokenId);
1997         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1998     }
1999 
2000     /**
2001      * @dev Safely mints `tokenId` and transfers it to `to`.
2002      *
2003      * Requirements:
2004      *
2005      * - `tokenId` must not exist.
2006      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2007      *
2008      * Emits a {Transfer} event.
2009      */
2010     function _safeMint(address to, uint256 tokenId) internal virtual {
2011         _safeMint(to, tokenId, "");
2012     }
2013 
2014     /**
2015      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2016      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2017      */
2018     function _safeMint(
2019         address to,
2020         uint256 tokenId,
2021         bytes memory _data
2022     ) internal virtual {
2023         _mint(to, tokenId);
2024         require(
2025             _checkOnERC721Received(address(0), to, tokenId, _data),
2026             "ERC721: transfer to non ERC721Receiver implementer"
2027         );
2028     }
2029 
2030     /**
2031      * @dev Mints `tokenId` and transfers it to `to`.
2032      *
2033      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2034      *
2035      * Requirements:
2036      *
2037      * - `tokenId` must not exist.
2038      * - `to` cannot be the zero address.
2039      *
2040      * Emits a {Transfer} event.
2041      */
2042     function _mint(address to, uint256 tokenId) internal virtual {
2043         require(to != address(0), "ERC721: mint to the zero address");
2044         require(!_exists(tokenId), "ERC721: token already minted");
2045 
2046         _beforeTokenTransfer(address(0), to, tokenId);
2047 
2048         _balances[to] += 1;
2049         _owners[tokenId] = to;
2050 
2051         emit Transfer(address(0), to, tokenId);
2052 
2053         _afterTokenTransfer(address(0), to, tokenId);
2054     }
2055 
2056     /**
2057      * @dev Destroys `tokenId`.
2058      * The approval is cleared when the token is burned.
2059      *
2060      * Requirements:
2061      *
2062      * - `tokenId` must exist.
2063      *
2064      * Emits a {Transfer} event.
2065      */
2066     function _burn(uint256 tokenId) internal virtual {
2067         address owner = ERC721.ownerOf(tokenId);
2068 
2069         _beforeTokenTransfer(owner, address(0), tokenId);
2070 
2071         // Clear approvals
2072         _approve(address(0), tokenId);
2073 
2074         _balances[owner] -= 1;
2075         delete _owners[tokenId];
2076 
2077         emit Transfer(owner, address(0), tokenId);
2078 
2079         _afterTokenTransfer(owner, address(0), tokenId);
2080     }
2081 
2082     /**
2083      * @dev Transfers `tokenId` from `from` to `to`.
2084      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2085      *
2086      * Requirements:
2087      *
2088      * - `to` cannot be the zero address.
2089      * - `tokenId` token must be owned by `from`.
2090      *
2091      * Emits a {Transfer} event.
2092      */
2093     function _transfer(
2094         address from,
2095         address to,
2096         uint256 tokenId
2097     ) internal virtual {
2098         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2099         require(to != address(0), "ERC721: transfer to the zero address");
2100 
2101         _beforeTokenTransfer(from, to, tokenId);
2102 
2103         // Clear approvals from the previous owner
2104         _approve(address(0), tokenId);
2105 
2106         _balances[from] -= 1;
2107         _balances[to] += 1;
2108         _owners[tokenId] = to;
2109 
2110         emit Transfer(from, to, tokenId);
2111 
2112         _afterTokenTransfer(from, to, tokenId);
2113     }
2114 
2115     /**
2116      * @dev Approve `to` to operate on `tokenId`
2117      *
2118      * Emits a {Approval} event.
2119      */
2120     function _approve(address to, uint256 tokenId) internal virtual {
2121         _tokenApprovals[tokenId] = to;
2122         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2123     }
2124 
2125     /**
2126      * @dev Approve `operator` to operate on all of `owner` tokens
2127      *
2128      * Emits a {ApprovalForAll} event.
2129      */
2130     function _setApprovalForAll(
2131         address owner,
2132         address operator,
2133         bool approved
2134     ) internal virtual {
2135         require(owner != operator, "ERC721: approve to caller");
2136         _operatorApprovals[owner][operator] = approved;
2137         emit ApprovalForAll(owner, operator, approved);
2138     }
2139 
2140     /**
2141      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2142      * The call is not executed if the target address is not a contract.
2143      *
2144      * @param from address representing the previous owner of the given token ID
2145      * @param to target address that will receive the tokens
2146      * @param tokenId uint256 ID of the token to be transferred
2147      * @param _data bytes optional data to send along with the call
2148      * @return bool whether the call correctly returned the expected magic value
2149      */
2150     function _checkOnERC721Received(
2151         address from,
2152         address to,
2153         uint256 tokenId,
2154         bytes memory _data
2155     ) private returns (bool) {
2156         if (to.isContract()) {
2157             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2158                 return retval == IERC721Receiver.onERC721Received.selector;
2159             } catch (bytes memory reason) {
2160                 if (reason.length == 0) {
2161                     revert("ERC721: transfer to non ERC721Receiver implementer");
2162                 } else {
2163                     assembly {
2164                         revert(add(32, reason), mload(reason))
2165                     }
2166                 }
2167             }
2168         } else {
2169             return true;
2170         }
2171     }
2172 
2173     /**
2174      * @dev Hook that is called before any token transfer. This includes minting
2175      * and burning.
2176      *
2177      * Calling conditions:
2178      *
2179      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2180      * transferred to `to`.
2181      * - When `from` is zero, `tokenId` will be minted for `to`.
2182      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2183      * - `from` and `to` are never both zero.
2184      *
2185      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2186      */
2187     function _beforeTokenTransfer(
2188         address from,
2189         address to,
2190         uint256 tokenId
2191     ) internal virtual {}
2192 
2193     /**
2194      * @dev Hook that is called after any transfer of tokens. This includes
2195      * minting and burning.
2196      *
2197      * Calling conditions:
2198      *
2199      * - when `from` and `to` are both non-zero.
2200      * - `from` and `to` are never both zero.
2201      *
2202      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2203      */
2204     function _afterTokenTransfer(
2205         address from,
2206         address to,
2207         uint256 tokenId
2208     ) internal virtual {}
2209 }
2210 
2211 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2212 
2213 
2214 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
2215 
2216 pragma solidity ^0.8.0;
2217 
2218 
2219 
2220 /**
2221  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2222  * enumerability of all the token ids in the contract as well as all token ids owned by each
2223  * account.
2224  */
2225 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2226     // Mapping from owner to list of owned token IDs
2227     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2228 
2229     // Mapping from token ID to index of the owner tokens list
2230     mapping(uint256 => uint256) private _ownedTokensIndex;
2231 
2232     // Array with all token ids, used for enumeration
2233     uint256[] private _allTokens;
2234 
2235     // Mapping from token id to position in the allTokens array
2236     mapping(uint256 => uint256) private _allTokensIndex;
2237 
2238     /**
2239      * @dev See {IERC165-supportsInterface}.
2240      */
2241     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2242         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2243     }
2244 
2245     /**
2246      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2247      */
2248     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2249         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2250         return _ownedTokens[owner][index];
2251     }
2252 
2253     /**
2254      * @dev See {IERC721Enumerable-totalSupply}.
2255      */
2256     function totalSupply() public view virtual override returns (uint256) {
2257         return _allTokens.length;
2258     }
2259 
2260     /**
2261      * @dev See {IERC721Enumerable-tokenByIndex}.
2262      */
2263     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2264         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2265         return _allTokens[index];
2266     }
2267 
2268     /**
2269      * @dev Hook that is called before any token transfer. This includes minting
2270      * and burning.
2271      *
2272      * Calling conditions:
2273      *
2274      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2275      * transferred to `to`.
2276      * - When `from` is zero, `tokenId` will be minted for `to`.
2277      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2278      * - `from` cannot be the zero address.
2279      * - `to` cannot be the zero address.
2280      *
2281      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2282      */
2283     function _beforeTokenTransfer(
2284         address from,
2285         address to,
2286         uint256 tokenId
2287     ) internal virtual override {
2288         super._beforeTokenTransfer(from, to, tokenId);
2289 
2290         if (from == address(0)) {
2291             _addTokenToAllTokensEnumeration(tokenId);
2292         } else if (from != to) {
2293             _removeTokenFromOwnerEnumeration(from, tokenId);
2294         }
2295         if (to == address(0)) {
2296             _removeTokenFromAllTokensEnumeration(tokenId);
2297         } else if (to != from) {
2298             _addTokenToOwnerEnumeration(to, tokenId);
2299         }
2300     }
2301 
2302     /**
2303      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2304      * @param to address representing the new owner of the given token ID
2305      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2306      */
2307     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2308         uint256 length = ERC721.balanceOf(to);
2309         _ownedTokens[to][length] = tokenId;
2310         _ownedTokensIndex[tokenId] = length;
2311     }
2312 
2313     /**
2314      * @dev Private function to add a token to this extension's token tracking data structures.
2315      * @param tokenId uint256 ID of the token to be added to the tokens list
2316      */
2317     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2318         _allTokensIndex[tokenId] = _allTokens.length;
2319         _allTokens.push(tokenId);
2320     }
2321 
2322     /**
2323      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2324      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2325      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2326      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2327      * @param from address representing the previous owner of the given token ID
2328      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2329      */
2330     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2331         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2332         // then delete the last slot (swap and pop).
2333 
2334         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2335         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2336 
2337         // When the token to delete is the last token, the swap operation is unnecessary
2338         if (tokenIndex != lastTokenIndex) {
2339             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2340 
2341             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2342             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2343         }
2344 
2345         // This also deletes the contents at the last position of the array
2346         delete _ownedTokensIndex[tokenId];
2347         delete _ownedTokens[from][lastTokenIndex];
2348     }
2349 
2350     /**
2351      * @dev Private function to remove a token from this extension's token tracking data structures.
2352      * This has O(1) time complexity, but alters the order of the _allTokens array.
2353      * @param tokenId uint256 ID of the token to be removed from the tokens list
2354      */
2355     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2356         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2357         // then delete the last slot (swap and pop).
2358 
2359         uint256 lastTokenIndex = _allTokens.length - 1;
2360         uint256 tokenIndex = _allTokensIndex[tokenId];
2361 
2362         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2363         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2364         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2365         uint256 lastTokenId = _allTokens[lastTokenIndex];
2366 
2367         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2368         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2369 
2370         // This also deletes the contents at the last position of the array
2371         delete _allTokensIndex[tokenId];
2372         _allTokens.pop();
2373     }
2374 }
2375 
2376 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
2377 
2378 
2379 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
2380 
2381 pragma solidity ^0.8.0;
2382 
2383 
2384 
2385 /**
2386  * @dev ERC721 token with pausable token transfers, minting and burning.
2387  *
2388  * Useful for scenarios such as preventing trades until the end of an evaluation
2389  * period, or having an emergency switch for freezing all token transfers in the
2390  * event of a large bug.
2391  */
2392 abstract contract ERC721Pausable is ERC721, Pausable {
2393     /**
2394      * @dev See {ERC721-_beforeTokenTransfer}.
2395      *
2396      * Requirements:
2397      *
2398      * - the contract must not be paused.
2399      */
2400     function _beforeTokenTransfer(
2401         address from,
2402         address to,
2403         uint256 tokenId
2404     ) internal virtual override {
2405         super._beforeTokenTransfer(from, to, tokenId);
2406 
2407         require(!paused(), "ERC721Pausable: token transfer while paused");
2408     }
2409 }
2410 
2411 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
2412 
2413 
2414 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
2415 
2416 pragma solidity ^0.8.0;
2417 
2418 
2419 
2420 /**
2421  * @title ERC721 Burnable Token
2422  * @dev ERC721 Token that can be irreversibly burned (destroyed).
2423  */
2424 abstract contract ERC721Burnable is Context, ERC721 {
2425     /**
2426      * @dev Burns `tokenId`. See {ERC721-_burn}.
2427      *
2428      * Requirements:
2429      *
2430      * - The caller must own `tokenId` or be an approved operator.
2431      */
2432     function burn(uint256 tokenId) public virtual {
2433         //solhint-disable-next-line max-line-length
2434         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
2435         _burn(tokenId);
2436     }
2437 }
2438 
2439 // File: NFTERC721.sol
2440 
2441 
2442 pragma solidity ^0.8.7;
2443 
2444 
2445 
2446 
2447 
2448 
2449 
2450 
2451 
2452 
2453 
2454 contract NFTERC721 is
2455     INFT,
2456     ERC721,
2457     ERC721Burnable,
2458     ERC721Pausable,
2459     ERC721Enumerable,
2460     AccessControl,
2461     Ownable,
2462     ContextMixin,
2463     NativeMetaTransaction
2464 {
2465     // Create a new role identifier for the minter role
2466     bytes32 public constant MINER_ROLE = keccak256("MINER_ROLE");
2467     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2468     using Counters for Counters.Counter;
2469     Counters.Counter private currentTokenId;
2470     /// @dev Base token URI used as a prefix by tokenURI().
2471     string private baseTokenURI;
2472     string private collectionURI;
2473     uint256 public constant TOTAL_SUPPLY = 10800;
2474 
2475     constructor() ERC721("SONNY", "HM-SON") {
2476         _initializeEIP712("SONNY");
2477         baseTokenURI = "https://cdn.nftstar.com/hm-son/metadata/";
2478         collectionURI = "https://cdn.nftstar.com/hm-son/meta-son-heung-min.json";
2479         // Grant the contract deployer the default admin role: it will be able to grant and revoke any roles
2480         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2481         _setupRole(MINER_ROLE, msg.sender);
2482         _setupRole(PAUSER_ROLE, msg.sender);
2483     }
2484 
2485     function totalSupply() public pure override returns (uint256) {
2486         return TOTAL_SUPPLY;
2487     }
2488 
2489     function remaining() public view override returns (uint256) {
2490         return TOTAL_SUPPLY - currentTokenId.current();
2491     }
2492 
2493     function mintTo(address recipient)
2494         public
2495         override
2496         onlyRole(MINER_ROLE)
2497         returns (uint256)
2498     {
2499         uint256 tokenId = currentTokenId.current();
2500         require(tokenId < TOTAL_SUPPLY, "Max supply reached");
2501         currentTokenId.increment();
2502         uint256 newItemId = currentTokenId.current();
2503         _safeMint(recipient, newItemId);
2504         return newItemId;
2505     }
2506 
2507     function ownerTokens(address owner) public view returns (uint256[] memory) {
2508         uint256 size = ERC721.balanceOf(owner);
2509         uint256[] memory items = new uint256[](size);
2510         for (uint256 i = 0; i < size; i++) {
2511             items[i] = tokenOfOwnerByIndex(owner, i);
2512         }
2513         return items;
2514     }
2515 
2516     /**
2517      * @dev Pauses all token transfers.
2518      *
2519      * See {ERC721Pausable} and {Pausable-_pause}.
2520      *
2521      * Requirements:
2522      *
2523      * - the caller must have the `PAUSER_ROLE`.
2524      */
2525     function pause() public virtual {
2526         require(
2527             hasRole(PAUSER_ROLE, msgSender()),
2528             "NFT: must have pauser role to pause"
2529         );
2530         _pause();
2531     }
2532 
2533     /**
2534      * @dev Unpauses all token transfers.
2535      *
2536      * See {ERC721Pausable} and {Pausable-_unpause}.
2537      *
2538      * Requirements:
2539      *
2540      * - the caller must have the `PAUSER_ROLE`.
2541      */
2542     function unpause() public virtual {
2543         require(
2544             hasRole(PAUSER_ROLE, msgSender()),
2545             "NFT: must have pauser role to unpause"
2546         );
2547         _unpause();
2548     }
2549 
2550     function current() public view returns (uint256) {
2551         return currentTokenId.current();
2552     }
2553 
2554     function contractURI() public view returns (string memory) {
2555         return collectionURI;
2556     }
2557 
2558     function setContractURI(string memory _contractURI) public onlyOwner {
2559         collectionURI = _contractURI;
2560     }
2561 
2562     /// @dev Returns an URI for a given token ID
2563     function _baseURI() internal view virtual override returns (string memory) {
2564         return baseTokenURI;
2565     }
2566 
2567     /// @dev Sets the base token URI prefix.
2568     function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
2569         baseTokenURI = _baseTokenURI;
2570     }
2571 
2572     function transferRoleAdmin(address newDefaultAdmin)
2573         external
2574         onlyRole(DEFAULT_ADMIN_ROLE)
2575     {
2576         _setupRole(DEFAULT_ADMIN_ROLE, newDefaultAdmin);
2577     }
2578 
2579     /**
2580      * @dev See {IERC165-supportsInterface}.
2581      */
2582     function supportsInterface(bytes4 interfaceId)
2583         public
2584         view
2585         virtual
2586         override(AccessControl, ERC721, ERC721Enumerable)
2587         returns (bool)
2588     {
2589         return
2590             interfaceId == type(INFT).interfaceId ||
2591             super.supportsInterface(interfaceId);
2592     }
2593 
2594     function _beforeTokenTransfer(
2595         address from,
2596         address to,
2597         uint256 amount
2598     ) internal virtual override(ERC721, ERC721Pausable, ERC721Enumerable) {
2599         super._beforeTokenTransfer(from, to, amount);
2600     }
2601 }
2602 
2603 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2604 
2605 
2606 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
2607 
2608 pragma solidity ^0.8.0;
2609 
2610 /**
2611  * @dev Contract module that helps prevent reentrant calls to a function.
2612  *
2613  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2614  * available, which can be applied to functions to make sure there are no nested
2615  * (reentrant) calls to them.
2616  *
2617  * Note that because there is a single `nonReentrant` guard, functions marked as
2618  * `nonReentrant` may not call one another. This can be worked around by making
2619  * those functions `private`, and then adding `external` `nonReentrant` entry
2620  * points to them.
2621  *
2622  * TIP: If you would like to learn more about reentrancy and alternative ways
2623  * to protect against it, check out our blog post
2624  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2625  */
2626 abstract contract ReentrancyGuard {
2627     // Booleans are more expensive than uint256 or any type that takes up a full
2628     // word because each write operation emits an extra SLOAD to first read the
2629     // slot's contents, replace the bits taken up by the boolean, and then write
2630     // back. This is the compiler's defense against contract upgrades and
2631     // pointer aliasing, and it cannot be disabled.
2632 
2633     // The values being non-zero value makes deployment a bit more expensive,
2634     // but in exchange the refund on every call to nonReentrant will be lower in
2635     // amount. Since refunds are capped to a percentage of the total
2636     // transaction's gas, it is best to keep them low in cases like this one, to
2637     // increase the likelihood of the full refund coming into effect.
2638     uint256 private constant _NOT_ENTERED = 1;
2639     uint256 private constant _ENTERED = 2;
2640 
2641     uint256 private _status;
2642 
2643     constructor() {
2644         _status = _NOT_ENTERED;
2645     }
2646 
2647     /**
2648      * @dev Prevents a contract from calling itself, directly or indirectly.
2649      * Calling a `nonReentrant` function from another `nonReentrant`
2650      * function is not supported. It is possible to prevent this from happening
2651      * by making the `nonReentrant` function external, and making it call a
2652      * `private` function that does the actual work.
2653      */
2654     modifier nonReentrant() {
2655         // On the first call to nonReentrant, _notEntered will be true
2656         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2657 
2658         // Any calls to nonReentrant after this point will fail
2659         _status = _ENTERED;
2660 
2661         _;
2662 
2663         // By storing the original value once again, a refund is triggered (see
2664         // https://eips.ethereum.org/EIPS/eip-2200)
2665         _status = _NOT_ENTERED;
2666     }
2667 }
2668 
2669 // File: NFTFactory.sol
2670 
2671 
2672 pragma solidity ^0.8.7;
2673 
2674 
2675 
2676 
2677 
2678 
2679 
2680 contract NFTFactory is
2681     IERC721,
2682     AllowsConfigurableProxy,
2683     Pausable,
2684     ReentrancyGuard
2685 {
2686     using Strings for uint256;
2687     uint256 public NUM_OPTIONS;
2688     /// @notice Base URI for constructing tokenURI values for options.
2689     string public optionURI;
2690     /// @notice Contract that deployed this factory.
2691     FactoryMintable public token;
2692 
2693     constructor(
2694         string memory _baseOptionURI,
2695         address _owner,
2696         uint256 _numOptions,
2697         address _proxyAddress
2698     ) AllowsConfigurableProxy(_proxyAddress, true) {
2699         token = FactoryMintable(msg.sender);
2700         NUM_OPTIONS = _numOptions;
2701         optionURI = _baseOptionURI;
2702         transferOwnership(_owner);
2703         createOptionsAndEmitTransfers();
2704     }
2705 
2706     error NotOwnerOrProxy();
2707     error InvalidOptionId();
2708 
2709     modifier onlyOwnerOrProxy() {
2710         if (
2711             _msgSender() != owner() &&
2712             !isApprovedForProxy(owner(), _msgSender())
2713         ) {
2714             revert NotOwnerOrProxy();
2715         }
2716         _;
2717     }
2718 
2719     modifier checkValidOptionId(uint256 _optionId) {
2720         // options are 1-indexed so check should be inclusive
2721         if (_optionId > NUM_OPTIONS) {
2722             revert InvalidOptionId();
2723         }
2724         _;
2725     }
2726 
2727     modifier interactBurnInvalidOptionId(uint256 _optionId) {
2728         _;
2729         _burnInvalidOptions();
2730     }
2731 
2732     /// @notice Sets the nft address for FactoryMintable.
2733     function setNFT(address _token) external onlyOwner {
2734         token = FactoryMintable(_token);
2735     }
2736 
2737     /// @notice Sets the base URI for constructing tokenURI values for options.
2738     function setBaseOptionURI(string memory _baseOptionURI) public onlyOwner {
2739         optionURI = _baseOptionURI;
2740     }
2741 
2742     /**
2743     @notice Returns a URL specifying option metadata, conforming to standard
2744     ERC1155 metadata format.
2745      */
2746     function tokenURI(uint256 _optionId) external view returns (string memory) {
2747         return string(abi.encodePacked(optionURI, _optionId.toString()));
2748     }
2749 
2750     /**
2751     @dev Return true if operator is an approved proxy of Owner
2752      */
2753     function isApprovedForAll(address _owner, address _operator)
2754         public
2755         view
2756         override
2757         returns (bool)
2758     {
2759         return isApprovedForProxy(_owner, _operator);
2760     }
2761 
2762     ///@notice public facing method for _burnInvalidOptions in case state of tokenContract changes
2763     function burnInvalidOptions() public onlyOwner {
2764         _burnInvalidOptions();
2765     }
2766 
2767     ///@notice "burn" option by sending it to 0 address. This will hide all active listings. Called as part of interactBurnInvalidOptionIds
2768     function _burnInvalidOptions() internal {
2769         for (uint256 i = 1; i <= NUM_OPTIONS; ++i) {
2770             if (!token.factoryCanMint(i)) {
2771                 emit Transfer(owner(), address(0), i);
2772             }
2773         }
2774     }
2775 
2776     /**
2777     @notice emit a transfer event for a "burn" option back to the owner if factoryCanMint the optionId
2778     @dev will re-validate listings on OpenSea frontend if an option becomes eligible to mint again
2779     eg, if max supply is increased
2780     */
2781     function restoreOption(uint256 _optionId) external onlyOwner {
2782         if (token.factoryCanMint(_optionId)) {
2783             emit Transfer(address(0), owner(), _optionId);
2784         }
2785     }
2786 
2787     /**
2788     @notice Emits standard ERC721.Transfer events for each option so NFT indexers pick them up.
2789     Does not need to fire on contract ownership transfer because once the tokens exist, the `ownerOf`
2790     check will always pass for contract owner.
2791      */
2792     function createOptionsAndEmitTransfers() internal {
2793         for (uint256 i = 1; i <= NUM_OPTIONS; i++) {
2794             emit Transfer(address(0), owner(), i);
2795         }
2796     }
2797 
2798     function approve(address operator, uint256) external override onlyOwner {
2799         setProxyAddress(operator);
2800     }
2801 
2802     function getApproved(uint256)
2803         external
2804         view
2805         override
2806         returns (address operator)
2807     {
2808         return proxyAddress();
2809     }
2810 
2811     function setApprovalForAll(address operator, bool)
2812         external
2813         override
2814         onlyOwner
2815     {
2816         setProxyAddress(operator);
2817     }
2818 
2819     function supportsFactoryInterface() public pure returns (bool) {
2820         return true;
2821     }
2822 
2823     function supportsInterface(bytes4 interfaceId)
2824         public
2825         view
2826         virtual
2827         override
2828         returns (bool)
2829     {
2830         return
2831             interfaceId == type(IERC721).interfaceId ||
2832             interfaceId == type(IERC165).interfaceId;
2833     }
2834 
2835     function balanceOf(address _owner)
2836         external
2837         view
2838         override
2839         returns (uint256)
2840     {
2841         return _owner == owner() ? NUM_OPTIONS : 0;
2842     }
2843 
2844     /**
2845     @notice Returns owner if _optionId is valid so posted orders pass validation
2846      */
2847     function ownerOf(uint256 _optionId) public view override returns (address) {
2848         return token.factoryCanMint(_optionId) ? owner() : address(0);
2849     }
2850 
2851     function safeTransferFrom(
2852         address,
2853         address _to,
2854         uint256 _optionId
2855     )
2856         public
2857         override
2858         nonReentrant
2859         onlyOwnerOrProxy
2860         whenNotPaused
2861         interactBurnInvalidOptionId(_optionId)
2862     {
2863         token.factoryMint(_optionId, _to);
2864     }
2865 
2866     function safeTransferFrom(
2867         address,
2868         address _to,
2869         uint256 _optionId,
2870         bytes calldata
2871     ) external override {
2872         safeTransferFrom(_to, _to, _optionId);
2873     }
2874 
2875     /**
2876     @notice hack: transferFrom is called on sale , this method mints the real token
2877      */
2878     function transferFrom(
2879         address,
2880         address _to,
2881         uint256 _optionId
2882     )
2883         public
2884         override
2885         nonReentrant
2886         onlyOwnerOrProxy
2887         whenNotPaused
2888         interactBurnInvalidOptionId(_optionId)
2889     {
2890         token.factoryMint(_optionId, _to);
2891     }
2892 }
2893 
2894 // File: NFTFactoryERC721.sol
2895 
2896 
2897 pragma solidity ^0.8.7;
2898 
2899 
2900 
2901 
2902 
2903 
2904 contract NFTFactoryERC721 is
2905     NFTERC721,
2906     FactoryMintable,
2907     ReentrancyGuard,
2908     AllowsConfigurableProxy
2909 {
2910     using Strings for uint256;
2911     uint256 public maxSupply;
2912 
2913     error NewMaxSupplyMustBeGreater();
2914 
2915     constructor(address _proxyAddress)
2916         AllowsConfigurableProxy(_proxyAddress, true)
2917     {
2918         maxSupply = totalSupply();
2919         tokenFactory = address(
2920             new NFTFactory(
2921                 "https://cdn.nftstar.com/hm-son-mint/metadata/",
2922                 owner(),
2923                 5,
2924                 _proxyAddress
2925             )
2926         );
2927         _setupRole(MINER_ROLE, tokenFactory);
2928         //emit Transfer(address(0), owner(), 0);
2929     }
2930 
2931     function factoryMint(uint256 _optionId, address _to)
2932         public
2933         override
2934         nonReentrant
2935         onlyFactory
2936         canMint(_optionId)
2937     {
2938         for (uint256 i; i < _optionId; ++i) {
2939             mintTo(_to);
2940         }
2941     }
2942 
2943     function factoryCanMint(uint256 _optionId)
2944         public
2945         view
2946         virtual
2947         override
2948         returns (bool)
2949     {
2950         if (_optionId == 0 || _optionId > maxSupply) {
2951             return false;
2952         }
2953         if (_optionId > (maxSupply - current())) {
2954             return false;
2955         }
2956         return true;
2957     }
2958 
2959     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2960         if (_maxSupply <= maxSupply) {
2961             revert NewMaxSupplyMustBeGreater();
2962         }
2963         maxSupply = _maxSupply;
2964     }
2965 }