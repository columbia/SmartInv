1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.10;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         return mod(a, b, "SafeMath: modulo by zero");
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts with custom message when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b != 0, errorMessage);
150         return a % b;
151     }
152 }
153 
154 interface IAmp {
155     function registerCollateralManager() external;
156 }
157 
158 /**
159  * @title Ownable is a contract the provides contract ownership functionality, including a two-
160  * phase transfer.
161  */
162 contract Ownable {
163     address private _owner;
164     address private _authorizedNewOwner;
165 
166     /**
167      * @notice Emitted when the owner authorizes ownership transfer to a new address
168      * @param authorizedAddress New owner address
169      */
170     event OwnershipTransferAuthorization(address indexed authorizedAddress);
171 
172     /**
173      * @notice Emitted when the authorized address assumed ownership
174      * @param oldValue Old owner
175      * @param newValue New owner
176      */
177     event OwnerUpdate(address indexed oldValue, address indexed newValue);
178 
179     /**
180      * @notice Sets the owner to the sender / contract creator
181      */
182     constructor() internal {
183         _owner = msg.sender;
184     }
185 
186     /**
187      * @notice Retrieves the owner of the contract
188      * @return The contract owner
189      */
190     function owner() public view returns (address) {
191         return _owner;
192     }
193 
194     /**
195      * @notice Retrieves the authorized new owner of the contract
196      * @return The authorized new contract owner
197      */
198     function authorizedNewOwner() public view returns (address) {
199         return _authorizedNewOwner;
200     }
201 
202     /**
203      * @notice Authorizes the transfer of ownership from owner to the provided address.
204      * NOTE: No transfer will occur unless authorizedAddress calls assumeOwnership().
205      * This authorization may be removed by another call to this function authorizing the zero
206      * address.
207      * @param _authorizedAddress The address authorized to become the new owner
208      */
209     function authorizeOwnershipTransfer(address _authorizedAddress) external {
210         require(msg.sender == _owner, "Invalid sender");
211 
212         _authorizedNewOwner = _authorizedAddress;
213 
214         emit OwnershipTransferAuthorization(_authorizedNewOwner);
215     }
216 
217     /**
218      * @notice Transfers ownership of this contract to the _authorizedNewOwner
219      * @dev Error invalid sender.
220      */
221     function assumeOwnership() external {
222         require(msg.sender == _authorizedNewOwner, "Invalid sender");
223 
224         address oldValue = _owner;
225         _owner = _authorizedNewOwner;
226         _authorizedNewOwner = address(0);
227 
228         emit OwnerUpdate(oldValue, _owner);
229     }
230 }
231 
232 abstract contract ERC1820Registry {
233     function setInterfaceImplementer(
234         address _addr,
235         bytes32 _interfaceHash,
236         address _implementer
237     ) external virtual;
238 
239     function getInterfaceImplementer(address _addr, bytes32 _interfaceHash)
240         external
241         virtual
242         view
243         returns (address);
244 
245     function setManager(address _addr, address _newManager) external virtual;
246 
247     function getManager(address _addr) public virtual view returns (address);
248 }
249 
250 /// Base client to interact with the registry.
251 contract ERC1820Client {
252     ERC1820Registry constant ERC1820REGISTRY = ERC1820Registry(
253         0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24
254     );
255 
256     function setInterfaceImplementation(
257         string memory _interfaceLabel,
258         address _implementation
259     ) internal {
260         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
261         ERC1820REGISTRY.setInterfaceImplementer(
262             address(this),
263             interfaceHash,
264             _implementation
265         );
266     }
267 
268     function interfaceAddr(address addr, string memory _interfaceLabel)
269         internal
270         view
271         returns (address)
272     {
273         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
274         return ERC1820REGISTRY.getInterfaceImplementer(addr, interfaceHash);
275     }
276 
277     function delegateManagement(address _newManager) internal {
278         ERC1820REGISTRY.setManager(address(this), _newManager);
279     }
280 }
281 
282 /**
283  * @title IAmpTokensRecipient
284  * @dev IAmpTokensRecipient token transfer hook interface
285  */
286 interface IAmpTokensRecipient {
287     /**
288      * @dev Report if the recipient will successfully receive the tokens
289      */
290     function canReceive(
291         bytes4 functionSig,
292         bytes32 partition,
293         address operator,
294         address from,
295         address to,
296         uint256 value,
297         bytes calldata data,
298         bytes calldata operatorData
299     ) external view returns (bool);
300 
301     /**
302      * @dev Hook executed upon a transfer to the recipient
303      */
304     function tokensReceived(
305         bytes4 functionSig,
306         bytes32 partition,
307         address operator,
308         address from,
309         address to,
310         uint256 value,
311         bytes calldata data,
312         bytes calldata operatorData
313     ) external;
314 }
315 
316 /**
317  * @title IAmpTokensSender
318  * @dev IAmpTokensSender token transfer hook interface
319  */
320 interface IAmpTokensSender {
321     /**
322      * @dev Report if the transfer will succeed from the pespective of the
323      * token sender
324      */
325     function canTransfer(
326         bytes4 functionSig,
327         bytes32 partition,
328         address operator,
329         address from,
330         address to,
331         uint256 value,
332         bytes calldata data,
333         bytes calldata operatorData
334     ) external view returns (bool);
335 
336     /**
337      * @dev Hook executed upon a transfer on behalf of the sender
338      */
339     function tokensToTransfer(
340         bytes4 functionSig,
341         bytes32 partition,
342         address operator,
343         address from,
344         address to,
345         uint256 value,
346         bytes calldata data,
347         bytes calldata operatorData
348     ) external;
349 }
350 
351 /**
352  * @title PartitionUtils
353  * @notice Partition related helper functions.
354  */
355 
356 library PartitionUtils {
357     bytes32 public constant CHANGE_PARTITION_FLAG = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
358 
359     /**
360      * @notice Retrieve the destination partition from the 'data' field.
361      * A partition change is requested ONLY when 'data' starts with the flag:
362      *
363      *   0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
364      *
365      * When the flag is detected, the destination partition is extracted from the
366      * 32 bytes following the flag.
367      * @param _data Information attached to the transfer. Will contain the
368      * destination partition if a change is requested.
369      * @param _fallbackPartition Partition value to return if a partition change
370      * is not requested in the `_data`.
371      * @return toPartition Destination partition. If the `_data` does not contain
372      * the prefix and bytes32 partition in the first 64 bytes, the method will
373      * return the provided `_fromPartition`.
374      */
375     function _getDestinationPartition(bytes memory _data, bytes32 _fallbackPartition)
376         internal
377         pure
378         returns (bytes32)
379     {
380         if (_data.length < 64) {
381             return _fallbackPartition;
382         }
383 
384         (bytes32 flag, bytes32 toPartition) = abi.decode(_data, (bytes32, bytes32));
385         if (flag == CHANGE_PARTITION_FLAG) {
386             return toPartition;
387         }
388 
389         return _fallbackPartition;
390     }
391 
392     /**
393      * @notice Helper to get the strategy identifying prefix from the `_partition`.
394      * @param _partition Partition to get the prefix for.
395      * @return 4 byte partition strategy prefix.
396      */
397     function _getPartitionPrefix(bytes32 _partition) internal pure returns (bytes4) {
398         return bytes4(_partition);
399     }
400 
401     /**
402      * @notice Helper method to split the partition into the prefix, sub partition
403      * and partition owner components.
404      * @param _partition The partition to split into parts.
405      * @return The 4 byte partition prefix, 8 byte sub partition, and final 20
406      * bytes representing an address.
407      */
408     function _splitPartition(bytes32 _partition)
409         internal
410         pure
411         returns (
412             bytes4,
413             bytes8,
414             address
415         )
416     {
417         bytes4 prefix = bytes4(_partition);
418         bytes8 subPartition = bytes8(_partition << 32);
419         address addressPart = address(uint160(uint256(_partition)));
420         return (prefix, subPartition, addressPart);
421     }
422 
423     /**
424      * @notice Helper method to get a partition strategy ERC1820 interface name
425      * based on partition prefix.
426      * @param _prefix 4 byte partition prefix.
427      * @dev Each 4 byte prefix has a unique interface name so that an individual
428      * hook implementation can be set for each prefix.
429      */
430     function _getPartitionStrategyValidatorIName(bytes4 _prefix)
431         internal
432         pure
433         returns (string memory)
434     {
435         return string(abi.encodePacked("AmpPartitionStrategyValidator", _prefix));
436     }
437 }
438 
439 /**
440  * @title FlexaCollateralManager is an implementation of IAmpTokensSender and IAmpTokensRecipient
441  * which serves as the Amp collateral manager for the Flexa Network.
442  */
443 contract FlexaCollateralManager is Ownable, IAmpTokensSender, IAmpTokensRecipient, ERC1820Client {
444     /**
445      * @dev AmpTokensSender interface label.
446      */
447     string internal constant AMP_TOKENS_SENDER = "AmpTokensSender";
448 
449     /**
450      * @dev AmpTokensRecipient interface label.
451      */
452     string internal constant AMP_TOKENS_RECIPIENT = "AmpTokensRecipient";
453 
454     /**
455      * @dev Change Partition Flag used in transfer data parameters to signal which partition
456      * will receive the tokens.
457      */
458     bytes32
459         internal constant CHANGE_PARTITION_FLAG = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
460 
461     /**
462      * @dev Required prefix for all registered partitions. Used to ensure the Collateral Pool
463      * Partition Validator is used within Amp.
464      */
465     bytes4 internal constant PARTITION_PREFIX = 0xCCCCCCCC;
466 
467     /**********************************************************************************************
468      * Operator Data Flags
469      *********************************************************************************************/
470 
471     /**
472      * @dev Flag used in operator data parameters to indicate the transfer is a withdrawal
473      */
474     bytes32
475         internal constant WITHDRAWAL_FLAG = 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
476 
477     /**
478      * @dev Flag used in operator data parameters to indicate the transfer is a fallback
479      * withdrawal
480      */
481     bytes32
482         internal constant FALLBACK_WITHDRAWAL_FLAG = 0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb;
483 
484     /**
485      * @dev Flag used in operator data parameters to indicate the transfer is a supply refund
486      */
487     bytes32
488         internal constant REFUND_FLAG = 0xcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc;
489 
490     /**
491      * @dev Flag used in operator data parameters to indicate the transfer is a direct transfer
492      */
493     bytes32
494         internal constant DIRECT_TRANSFER_FLAG = 0xdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd;
495 
496     /**********************************************************************************************
497      * Configuration
498      *********************************************************************************************/
499 
500     /**
501      * @notice Address of the Amp contract. Immutable.
502      */
503     address public amp;
504 
505     /**
506      * @notice Permitted partitions
507      */
508     mapping(bytes32 => bool) public partitions;
509 
510     /**********************************************************************************************
511      * Roles
512      *********************************************************************************************/
513 
514     /**
515      * @notice Address authorized to publish withdrawal roots
516      */
517     address public withdrawalPublisher;
518 
519     /**
520      * @notice Address authorized to publish fallback withdrawal roots
521      */
522     address public fallbackPublisher;
523 
524     /**
525      * @notice Address authorized to adjust the withdrawal limit
526      */
527     address public withdrawalLimitPublisher;
528 
529     /**
530      * @notice Address authorized to directly transfer tokens
531      */
532     address public directTransferer;
533 
534     /**
535      * @notice Address authorized to manage permitted partition
536      */
537     address public partitionManager;
538 
539     /**
540      * @notice Struct used to record received tokens that can be recovered during the fallback
541      * withdrawal period
542      * @param supplier Token supplier
543      * @param partition Partition which received the tokens
544      * @param amount Number of tokens received
545      */
546     struct Supply {
547         address supplier;
548         bytes32 partition;
549         uint256 amount;
550     }
551 
552     /**********************************************************************************************
553      * Supply State
554      *********************************************************************************************/
555 
556     /**
557      * @notice Supply nonce used to track incoming token transfers
558      */
559     uint256 public supplyNonce = 0;
560 
561     /**
562      * @notice Mapping of all incoming token transfers
563      */
564     mapping(uint256 => Supply) public nonceToSupply;
565 
566     /**********************************************************************************************
567      * Withdrawal State
568      *********************************************************************************************/
569 
570     /**
571      * @notice Remaining withdrawal limit. Initially set to 100,000 Amp.
572      */
573     uint256 public withdrawalLimit = 100 * 1000 * (10**18);
574 
575     /**
576      * @notice Withdrawal maximum root nonce
577      */
578     uint256 public maxWithdrawalRootNonce = 0;
579 
580     /**
581      * @notice Active set of withdrawal roots
582      */
583     mapping(bytes32 => uint256) public withdrawalRootToNonce;
584 
585     /**
586      * @notice Last invoked withdrawal root for each account, per partition
587      */
588     mapping(bytes32 => mapping(address => uint256)) public addressToWithdrawalNonce;
589 
590     /**
591      * @notice Total amount withdrawn for each account, per partition
592      */
593     mapping(bytes32 => mapping(address => uint256)) public addressToCumulativeAmountWithdrawn;
594 
595     /**********************************************************************************************
596      * Fallback Withdrawal State
597      *********************************************************************************************/
598 
599     /**
600      * @notice Withdrawal fallback delay. Initially set to one week.
601      */
602     uint256 public fallbackWithdrawalDelaySeconds = 1 weeks;
603 
604     /**
605      * @notice Current fallback withdrawal root
606      */
607     bytes32 public fallbackRoot;
608 
609     /**
610      * @notice Timestamp of when the last fallback root was published
611      */
612     uint256 public fallbackSetDate = 2**200; // very far in the future
613 
614     /**
615      * @notice Latest supply reflected in the fallback withdrawal authorization tree
616      */
617     uint256 public fallbackMaxIncludedSupplyNonce = 0;
618 
619     /**********************************************************************************************
620      * Supplier Events
621      *********************************************************************************************/
622 
623     /**
624      * @notice Indicates a token supply has been received
625      * @param supplier Token supplier
626      * @param amount Number of tokens transferred
627      * @param nonce Nonce of the supply
628      */
629     event SupplyReceipt(
630         address indexed supplier,
631         bytes32 indexed partition,
632         uint256 amount,
633         uint256 indexed nonce
634     );
635 
636     /**
637      * @notice Indicates that a withdrawal was executed
638      * @param supplier Address whose withdrawal authorization was executed
639      * @param partition Partition from which the tokens were transferred
640      * @param amount Amount of tokens transferred
641      * @param rootNonce Nonce of the withdrawal root used for authorization
642      * @param authorizedAccountNonce Maximum previous nonce used by the account
643      */
644     event Withdrawal(
645         address indexed supplier,
646         bytes32 indexed partition,
647         uint256 amount,
648         uint256 indexed rootNonce,
649         uint256 authorizedAccountNonce
650     );
651 
652     /**
653      * @notice Indicates a fallback withdrawal was executed
654      * @param supplier Address whose fallback withdrawal authorization was executed
655      * @param partition Partition from which the tokens were transferred
656      * @param amount Amount of tokens transferred
657      */
658     event FallbackWithdrawal(
659         address indexed supplier,
660         bytes32 indexed partition,
661         uint256 indexed amount
662     );
663 
664     /**
665      * @notice Indicates a release of supply is requested
666      * @param supplier Token supplier
667      * @param partition Parition from which the tokens should be released
668      * @param amount Number of tokens requested to be released
669      * @param data Metadata provided by the requestor
670      */
671     event ReleaseRequest(
672         address indexed supplier,
673         bytes32 indexed partition,
674         uint256 indexed amount,
675         bytes data
676     );
677 
678     /**
679      * @notice Indicates a supply refund was executed
680      * @param supplier Address whose refund authorization was executed
681      * @param partition Partition from which the tokens were transferred
682      * @param amount Amount of tokens transferred
683      * @param nonce Nonce of the original supply
684      */
685     event SupplyRefund(
686         address indexed supplier,
687         bytes32 indexed partition,
688         uint256 amount,
689         uint256 indexed nonce
690     );
691 
692     /**********************************************************************************************
693      * Direct Transfer Events
694      *********************************************************************************************/
695 
696     /**
697      * @notice Emitted when tokens are directly transfered
698      * @param operator Address that executed the direct transfer
699      * @param from_partition Partition from which the tokens were transferred
700      * @param to_address Address to which the tokens were transferred
701      * @param to_partition Partition to which the tokens were transferred
702      * @param value Amount of tokens transferred
703      */
704     event DirectTransfer(
705         address operator,
706         bytes32 indexed from_partition,
707         address indexed to_address,
708         bytes32 indexed to_partition,
709         uint256 value
710     );
711 
712     /**********************************************************************************************
713      * Admin Configuration Events
714      *********************************************************************************************/
715 
716     /**
717      * @notice Emitted when a partition is permitted for supply
718      * @param partition Partition added to the permitted set
719      */
720     event PartitionAdded(bytes32 indexed partition);
721 
722     /**
723      * @notice Emitted when a partition is removed from the set permitted for supply
724      * @param partition Partition removed from the permitted set
725      */
726     event PartitionRemoved(bytes32 indexed partition);
727 
728     /**********************************************************************************************
729      * Admin Withdrawal Management Events
730      *********************************************************************************************/
731 
732     /**
733      * @notice Emitted when a new withdrawal root hash is added to the active set
734      * @param rootHash Merkle root hash.
735      * @param nonce Nonce of the Merkle root hash.
736      */
737     event WithdrawalRootHashAddition(bytes32 indexed rootHash, uint256 indexed nonce);
738 
739     /**
740      * @notice Emitted when a withdrawal root hash is removed from the active set
741      * @param rootHash Merkle root hash.
742      * @param nonce Nonce of the Merkle root hash.
743      */
744     event WithdrawalRootHashRemoval(bytes32 indexed rootHash, uint256 indexed nonce);
745 
746     /**
747      * @notice Emitted when the withdrawal limit is updated
748      * @param oldValue Old limit.
749      * @param newValue New limit.
750      */
751     event WithdrawalLimitUpdate(uint256 indexed oldValue, uint256 indexed newValue);
752 
753     /**********************************************************************************************
754      * Admin Fallback Management Events
755      *********************************************************************************************/
756 
757     /**
758      * @notice Emitted when a new fallback withdrawal root hash is set
759      * @param rootHash Merkle root hash
760      * @param maxSupplyNonceIncluded Nonce of the last supply reflected in the tree data
761      * @param setDate Timestamp of when the root hash was set
762      */
763     event FallbackRootHashSet(
764         bytes32 indexed rootHash,
765         uint256 indexed maxSupplyNonceIncluded,
766         uint256 setDate
767     );
768 
769     /**
770      * @notice Emitted when the fallback root hash set date is reset
771      * @param newDate Timestamp of when the fallback reset date was set
772      */
773     event FallbackMechanismDateReset(uint256 indexed newDate);
774 
775     /**
776      * @notice Emitted when the fallback delay is updated
777      * @param oldValue Old delay
778      * @param newValue New delay
779      */
780     event FallbackWithdrawalDelayUpdate(uint256 indexed oldValue, uint256 indexed newValue);
781 
782     /**********************************************************************************************
783      * Role Management Events
784      *********************************************************************************************/
785 
786     /**
787      * @notice Emitted when the Withdrawal Publisher is updated
788      * @param oldValue Old publisher
789      * @param newValue New publisher
790      */
791     event WithdrawalPublisherUpdate(address indexed oldValue, address indexed newValue);
792 
793     /**
794      * @notice Emitted when the Fallback Publisher is updated
795      * @param oldValue Old publisher
796      * @param newValue New publisher
797      */
798     event FallbackPublisherUpdate(address indexed oldValue, address indexed newValue);
799 
800     /**
801      * @notice Emitted when Withdrawal Limit Publisher is updated
802      * @param oldValue Old publisher
803      * @param newValue New publisher
804      */
805     event WithdrawalLimitPublisherUpdate(address indexed oldValue, address indexed newValue);
806 
807     /**
808      * @notice Emitted when the DirectTransferer address is updated
809      * @param oldValue Old DirectTransferer address
810      * @param newValue New DirectTransferer address
811      */
812     event DirectTransfererUpdate(address indexed oldValue, address indexed newValue);
813 
814     /**
815      * @notice Emitted when the Partition Manager address is updated
816      * @param oldValue Old Partition Manager address
817      * @param newValue New Partition Manager address
818      */
819     event PartitionManagerUpdate(address indexed oldValue, address indexed newValue);
820 
821     /**********************************************************************************************
822      * Constructor
823      *********************************************************************************************/
824 
825     /**
826      * @notice FlexaCollateralManager constructor
827      * @param _amp Address of the Amp token contract
828      */
829     constructor(address _amp) public {
830         amp = _amp;
831 
832         ERC1820Client.setInterfaceImplementation(AMP_TOKENS_RECIPIENT, address(this));
833         ERC1820Client.setInterfaceImplementation(AMP_TOKENS_SENDER, address(this));
834 
835         IAmp(amp).registerCollateralManager();
836     }
837 
838     /**********************************************************************************************
839      * IAmpTokensRecipient Hooks
840      *********************************************************************************************/
841 
842     /**
843      * @notice Validates where the supplied parameters are valid for a transfer of tokens to this
844      * contract
845      * @dev Implements IAmpTokensRecipient
846      * @param _partition Partition from which the tokens were transferred
847      * @param _to The destination address of the tokens. Must be this.
848      * @param _data Optional data sent with the transfer. Used to set the destination partition.
849      * @return true if the tokens can be received, otherwise false
850      */
851     function canReceive(
852         bytes4, /* functionSig */
853         bytes32 _partition,
854         address, /* operator */
855         address, /* from */
856         address _to,
857         uint256, /* value */
858         bytes calldata _data,
859         bytes calldata /* operatorData */
860     ) external override view returns (bool) {
861         if (msg.sender != amp || _to != address(this)) {
862             return false;
863         }
864 
865         bytes32 _destinationPartition = PartitionUtils._getDestinationPartition(_data, _partition);
866 
867         return partitions[_destinationPartition];
868     }
869 
870     /**
871      * @notice Function called by the token contract after executing a transfer.
872      * @dev Implements IAmpTokensRecipient
873      * @param _partition Partition from which the tokens were transferred
874      * @param _operator Address which triggered the transfer. This address will be credited with
875      * the supply.
876      * @param _to The destination address of the tokens. Must be this.
877      * @param _value Number of tokens the token holder balance is decreased by.
878      * @param _data Optional data sent with the transfer. Used to set the destination partition.
879      */
880     function tokensReceived(
881         bytes4, /* functionSig */
882         bytes32 _partition,
883         address _operator,
884         address, /* from */
885         address _to,
886         uint256 _value,
887         bytes calldata _data,
888         bytes calldata /* operatorData */
889     ) external override {
890         require(msg.sender == amp, "Invalid sender");
891         require(_to == address(this), "Invalid to address");
892 
893         bytes32 _destinationPartition = PartitionUtils._getDestinationPartition(_data, _partition);
894 
895         require(partitions[_destinationPartition], "Invalid destination partition");
896 
897         supplyNonce = SafeMath.add(supplyNonce, 1);
898         nonceToSupply[supplyNonce].supplier = _operator;
899         nonceToSupply[supplyNonce].partition = _destinationPartition;
900         nonceToSupply[supplyNonce].amount = _value;
901 
902         emit SupplyReceipt(_operator, _destinationPartition, _value, supplyNonce);
903     }
904 
905     /**********************************************************************************************
906      * IAmpTokensSender Hooks
907      *********************************************************************************************/
908 
909     /**
910      * @notice Validates where the supplied parameters are valid for a transfer of tokens from this
911      * contract
912      * @dev Implements IAmpTokensSender
913      * @param _partition Source partition of the tokens
914      * @param _operator Address which triggered the transfer
915      * @param _from The source address of the tokens. Must be this.
916      * @param _value Amount of tokens to be transferred
917      * @param _operatorData Extra information attached by the operator. Must include the transfer
918      * operation flag and additional authorization data custom for each transfer operation type.
919      * @return true if the token transfer would succeed, otherwise false
920      */
921     function canTransfer(
922         bytes4, /*functionSig*/
923         bytes32 _partition,
924         address _operator,
925         address _from,
926         address, /* to */
927         uint256 _value,
928         bytes calldata, /* data */
929         bytes calldata _operatorData
930     ) external override view returns (bool) {
931         if (msg.sender != amp || _from != address(this)) {
932             return false;
933         }
934 
935         bytes32 flag = _decodeOperatorDataFlag(_operatorData);
936 
937         if (flag == WITHDRAWAL_FLAG) {
938             return _validateWithdrawal(_partition, _operator, _value, _operatorData);
939         }
940         if (flag == FALLBACK_WITHDRAWAL_FLAG) {
941             return _validateFallbackWithdrawal(_partition, _operator, _value, _operatorData);
942         }
943         if (flag == REFUND_FLAG) {
944             return _validateRefund(_partition, _operator, _value, _operatorData);
945         }
946         if (flag == DIRECT_TRANSFER_FLAG) {
947             return _validateDirectTransfer(_operator, _value);
948         }
949 
950         return false;
951     }
952 
953     /**
954      * @notice Function called by the token contract when executing a transfer
955      * @dev Implements IAmpTokensSender
956      * @param _partition Source partition of the tokens
957      * @param _operator Address which triggered the transfer
958      * @param _from The source address of the tokens. Must be this.
959      * @param _to The target address of the tokens.
960      * @param _value Amount of tokens to be transferred
961      * @param _data Data attached to the transfer. Typically includes partition change information.
962      * @param _operatorData Extra information attached by the operator. Must include the transfer
963      * operation flag and additional authorization data custom for each transfer operation type.
964      */
965     function tokensToTransfer(
966         bytes4, /* functionSig */
967         bytes32 _partition,
968         address _operator,
969         address _from,
970         address _to,
971         uint256 _value,
972         bytes calldata _data,
973         bytes calldata _operatorData
974     ) external override {
975         require(msg.sender == amp, "Invalid sender");
976         require(_from == address(this), "Invalid from address");
977 
978         bytes32 flag = _decodeOperatorDataFlag(_operatorData);
979 
980         if (flag == WITHDRAWAL_FLAG) {
981             _executeWithdrawal(_partition, _operator, _value, _operatorData);
982         } else if (flag == FALLBACK_WITHDRAWAL_FLAG) {
983             _executeFallbackWithdrawal(_partition, _operator, _value, _operatorData);
984         } else if (flag == REFUND_FLAG) {
985             _executeRefund(_partition, _operator, _value, _operatorData);
986         } else if (flag == DIRECT_TRANSFER_FLAG) {
987             _executeDirectTransfer(_partition, _operator, _to, _value, _data);
988         } else {
989             revert("invalid flag");
990         }
991     }
992 
993     /**********************************************************************************************
994      * Withdrawals
995      *********************************************************************************************/
996 
997     /**
998      * @notice Validates withdrawal data
999      * @param _partition Source partition of the withdrawal
1000      * @param _operator Address that is invoking the transfer
1001      * @param _value Number of tokens to be transferred
1002      * @param _operatorData Contains the withdrawal authorization data
1003      * @return true if the withdrawal data is valid, otherwise false
1004      */
1005     function _validateWithdrawal(
1006         bytes32 _partition,
1007         address _operator,
1008         uint256 _value,
1009         bytes memory _operatorData
1010     ) internal view returns (bool) {
1011         (
1012             address supplier,
1013             uint256 maxAuthorizedAccountNonce,
1014             uint256 withdrawalRootNonce
1015         ) = _getWithdrawalData(_partition, _value, _operatorData);
1016 
1017         return
1018             _validateWithdrawalData(
1019                 _partition,
1020                 _operator,
1021                 _value,
1022                 supplier,
1023                 maxAuthorizedAccountNonce,
1024                 withdrawalRootNonce
1025             );
1026     }
1027 
1028     /**
1029      * @notice Validates the withdrawal data and updates state to reflect the transfer
1030      * @param _partition Source partition of the withdrawal
1031      * @param _operator Address that is invoking the transfer
1032      * @param _value Number of tokens to be transferred
1033      * @param _operatorData Contains the withdrawal authorization data
1034      */
1035     function _executeWithdrawal(
1036         bytes32 _partition,
1037         address _operator,
1038         uint256 _value,
1039         bytes memory _operatorData
1040     ) internal {
1041         (
1042             address supplier,
1043             uint256 maxAuthorizedAccountNonce,
1044             uint256 withdrawalRootNonce
1045         ) = _getWithdrawalData(_partition, _value, _operatorData);
1046 
1047         require(
1048             _validateWithdrawalData(
1049                 _partition,
1050                 _operator,
1051                 _value,
1052                 supplier,
1053                 maxAuthorizedAccountNonce,
1054                 withdrawalRootNonce
1055             ),
1056             "Transfer unauthorized"
1057         );
1058 
1059         addressToCumulativeAmountWithdrawn[_partition][supplier] = SafeMath.add(
1060             _value,
1061             addressToCumulativeAmountWithdrawn[_partition][supplier]
1062         );
1063 
1064         addressToWithdrawalNonce[_partition][supplier] = withdrawalRootNonce;
1065 
1066         withdrawalLimit = SafeMath.sub(withdrawalLimit, _value);
1067 
1068         emit Withdrawal(
1069             supplier,
1070             _partition,
1071             _value,
1072             withdrawalRootNonce,
1073             maxAuthorizedAccountNonce
1074         );
1075     }
1076 
1077     /**
1078      * @notice Extracts withdrawal data from the supplied parameters
1079      * @param _partition Source partition of the withdrawal
1080      * @param _value Number of tokens to be transferred
1081      * @param _operatorData Contains the withdrawal authorization data, including the withdrawal
1082      * operation flag, supplier, maximum authorized account nonce, and Merkle proof.
1083      * @return supplier, the address whose account is authorized
1084      * @return maxAuthorizedAccountNonce, the maximum existing used withdrawal nonce for the
1085      * supplier and partition
1086      * @return withdrawalRootNonce, the active withdrawal root nonce found based on the supplied
1087      * data and Merkle proof
1088      */
1089     function _getWithdrawalData(
1090         bytes32 _partition,
1091         uint256 _value,
1092         bytes memory _operatorData
1093     )
1094         internal
1095         view
1096         returns (
1097             address, /* supplier */
1098             uint256, /* maxAuthorizedAccountNonce */
1099             uint256 /* withdrawalRootNonce */
1100         )
1101     {
1102         (
1103             address supplier,
1104             uint256 maxAuthorizedAccountNonce,
1105             bytes32[] memory merkleProof
1106         ) = _decodeWithdrawalOperatorData(_operatorData);
1107 
1108         bytes32 leafDataHash = _calculateWithdrawalLeaf(
1109             supplier,
1110             _partition,
1111             _value,
1112             maxAuthorizedAccountNonce
1113         );
1114 
1115         bytes32 calculatedRoot = _calculateMerkleRoot(merkleProof, leafDataHash);
1116         uint256 withdrawalRootNonce = withdrawalRootToNonce[calculatedRoot];
1117 
1118         return (supplier, maxAuthorizedAccountNonce, withdrawalRootNonce);
1119     }
1120 
1121     /**
1122      * @notice Validates that the parameters are valid for the requested withdrawal
1123      * @param _partition Source partition of the tokens
1124      * @param _operator Address that is executing the withdrawal
1125      * @param _value Number of tokens to be transferred
1126      * @param _supplier The address whose account is authorized
1127      * @param _maxAuthorizedAccountNonce The maximum existing used withdrawal nonce for the
1128      * supplier and partition
1129      * @param _withdrawalRootNonce The active withdrawal root nonce found based on the supplied
1130      * data and Merkle proof
1131      * @return true if the withdrawal data is valid, otherwise false
1132      */
1133     function _validateWithdrawalData(
1134         bytes32 _partition,
1135         address _operator,
1136         uint256 _value,
1137         address _supplier,
1138         uint256 _maxAuthorizedAccountNonce,
1139         uint256 _withdrawalRootNonce
1140     ) internal view returns (bool) {
1141         return
1142             // Only owner, withdrawal publisher or supplier can invoke withdrawals
1143             (_operator == owner() || _operator == withdrawalPublisher || _operator == _supplier) &&
1144             // Ensure maxAuthorizedAccountNonce has not been exceeded
1145             (addressToWithdrawalNonce[_partition][_supplier] <= _maxAuthorizedAccountNonce) &&
1146             // Ensure we are within the global withdrawal limit
1147             (_value <= withdrawalLimit) &&
1148             // Merkle tree proof is valid
1149             (_withdrawalRootNonce > 0) &&
1150             // Ensure the withdrawal root is more recent than the maxAuthorizedAccountNonce
1151             (_withdrawalRootNonce > _maxAuthorizedAccountNonce);
1152     }
1153 
1154     /**********************************************************************************************
1155      * Fallback Withdrawals
1156      *********************************************************************************************/
1157 
1158     /**
1159      * @notice Validates fallback withdrawal data
1160      * @param _partition Source partition of the withdrawal
1161      * @param _operator Address that is invoking the transfer
1162      * @param _value Number of tokens to be transferred
1163      * @param _operatorData Contains the fallback withdrawal authorization data
1164      * @return true if the fallback withdrawal data is valid, otherwise false
1165      */
1166     function _validateFallbackWithdrawal(
1167         bytes32 _partition,
1168         address _operator,
1169         uint256 _value,
1170         bytes memory _operatorData
1171     ) internal view returns (bool) {
1172         (
1173             address supplier,
1174             uint256 maxCumulativeWithdrawalAmount,
1175             uint256 newCumulativeWithdrawalAmount,
1176             bytes32 calculatedRoot
1177         ) = _getFallbackWithdrawalData(_partition, _value, _operatorData);
1178 
1179         return
1180             _validateFallbackWithdrawalData(
1181                 _operator,
1182                 maxCumulativeWithdrawalAmount,
1183                 newCumulativeWithdrawalAmount,
1184                 supplier,
1185                 calculatedRoot
1186             );
1187     }
1188 
1189     /**
1190      * @notice Validates the fallback withdrawal data and updates state to reflect the transfer
1191      * @param _partition Source partition of the withdrawal
1192      * @param _operator Address that is invoking the transfer
1193      * @param _value Number of tokens to be transferred
1194      * @param _operatorData Contains the fallback withdrawal authorization data
1195      */
1196     function _executeFallbackWithdrawal(
1197         bytes32 _partition,
1198         address _operator,
1199         uint256 _value,
1200         bytes memory _operatorData
1201     ) internal {
1202         (
1203             address supplier,
1204             uint256 maxCumulativeWithdrawalAmount,
1205             uint256 newCumulativeWithdrawalAmount,
1206             bytes32 calculatedRoot
1207         ) = _getFallbackWithdrawalData(_partition, _value, _operatorData);
1208 
1209         require(
1210             _validateFallbackWithdrawalData(
1211                 _operator,
1212                 maxCumulativeWithdrawalAmount,
1213                 newCumulativeWithdrawalAmount,
1214                 supplier,
1215                 calculatedRoot
1216             ),
1217             "Transfer unauthorized"
1218         );
1219 
1220         addressToCumulativeAmountWithdrawn[_partition][supplier] = newCumulativeWithdrawalAmount;
1221 
1222         addressToWithdrawalNonce[_partition][supplier] = maxWithdrawalRootNonce;
1223 
1224         emit FallbackWithdrawal(supplier, _partition, _value);
1225     }
1226 
1227     /**
1228      * @notice Extracts withdrawal data from the supplied parameters
1229      * @param _partition Source partition of the withdrawal
1230      * @param _value Number of tokens to be transferred
1231      * @param _operatorData Contains the fallback withdrawal authorization data, including the
1232      * fallback withdrawal operation flag, supplier, max cumulative withdrawal amount, and Merkle
1233      * proof.
1234      * @return supplier, the address whose account is authorized
1235      * @return maxCumulativeWithdrawalAmount, the maximum amount of tokens that can be withdrawn
1236      * for the supplier's account, including both withdrawals and fallback withdrawals
1237      * @return newCumulativeWithdrawalAmount, the new total of all withdrawals include the
1238      * current request
1239      * @return calculatedRoot, the Merkle tree root calculated based on the supplied data and proof
1240      */
1241     function _getFallbackWithdrawalData(
1242         bytes32 _partition,
1243         uint256 _value,
1244         bytes memory _operatorData
1245     )
1246         internal
1247         view
1248         returns (
1249             address, /* supplier */
1250             uint256, /* maxCumulativeWithdrawalAmount */
1251             uint256, /* newCumulativeWithdrawalAmount */
1252             bytes32 /* calculatedRoot */
1253         )
1254     {
1255         (
1256             address supplier,
1257             uint256 maxCumulativeWithdrawalAmount,
1258             bytes32[] memory merkleProof
1259         ) = _decodeWithdrawalOperatorData(_operatorData);
1260 
1261         uint256 newCumulativeWithdrawalAmount = SafeMath.add(
1262             _value,
1263             addressToCumulativeAmountWithdrawn[_partition][supplier]
1264         );
1265 
1266         bytes32 leafDataHash = _calculateFallbackLeaf(
1267             supplier,
1268             _partition,
1269             maxCumulativeWithdrawalAmount
1270         );
1271         bytes32 calculatedRoot = _calculateMerkleRoot(merkleProof, leafDataHash);
1272 
1273         return (
1274             supplier,
1275             maxCumulativeWithdrawalAmount,
1276             newCumulativeWithdrawalAmount,
1277             calculatedRoot
1278         );
1279     }
1280 
1281     /**
1282      * @notice Validates that the parameters are valid for the requested fallback withdrawal
1283      * @param _operator Address that is executing the withdrawal
1284      * @param _maxCumulativeWithdrawalAmount, the maximum amount of tokens that can be withdrawn
1285      * for the supplier's account, including both withdrawals and fallback withdrawals
1286      * @param _newCumulativeWithdrawalAmount, the new total of all withdrawals include the
1287      * current request
1288      * @param _supplier The address whose account is authorized
1289      * @param _calculatedRoot The Merkle tree root calculated based on the supplied data and proof
1290      * @return true if the fallback withdrawal data is valid, otherwise false
1291      */
1292     function _validateFallbackWithdrawalData(
1293         address _operator,
1294         uint256 _maxCumulativeWithdrawalAmount,
1295         uint256 _newCumulativeWithdrawalAmount,
1296         address _supplier,
1297         bytes32 _calculatedRoot
1298     ) internal view returns (bool) {
1299         return
1300             // Only owner or supplier can invoke the fallback withdrawal
1301             (_operator == owner() || _operator == _supplier) &&
1302             // Ensure we have entered fallback mode
1303             (SafeMath.add(fallbackSetDate, fallbackWithdrawalDelaySeconds) <= block.timestamp) &&
1304             // Check that the maximum allowable withdrawal for the supplier has not been exceeded
1305             (_newCumulativeWithdrawalAmount <= _maxCumulativeWithdrawalAmount) &&
1306             // Merkle tree proof is valid
1307             (fallbackRoot == _calculatedRoot);
1308     }
1309 
1310     /**********************************************************************************************
1311      * Supply Refunds
1312      *********************************************************************************************/
1313 
1314     /**
1315      * @notice Validates refund data
1316      * @param _partition Source partition of the refund
1317      * @param _operator Address that is invoking the transfer
1318      * @param _value Number of tokens to be transferred
1319      * @param _operatorData Contains the refund authorization data
1320      * @return true if the refund data is valid, otherwise false
1321      */
1322     function _validateRefund(
1323         bytes32 _partition,
1324         address _operator,
1325         uint256 _value,
1326         bytes memory _operatorData
1327     ) internal view returns (bool) {
1328         (uint256 _supplyNonce, Supply memory supply) = _getRefundData(_operatorData);
1329 
1330         return _verifyRefundData(_partition, _operator, _value, _supplyNonce, supply);
1331     }
1332 
1333     /**
1334      * @notice Validates the refund data and updates state to reflect the transfer
1335      * @param _partition Source partition of the refund
1336      * @param _operator Address that is invoking the transfer
1337      * @param _value Number of tokens to be transferred
1338      * @param _operatorData Contains the refund authorization data
1339      */
1340     function _executeRefund(
1341         bytes32 _partition,
1342         address _operator,
1343         uint256 _value,
1344         bytes memory _operatorData
1345     ) internal {
1346         (uint256 nonce, Supply memory supply) = _getRefundData(_operatorData);
1347 
1348         require(
1349             _verifyRefundData(_partition, _operator, _value, nonce, supply),
1350             "Transfer unauthorized"
1351         );
1352 
1353         delete nonceToSupply[nonce];
1354 
1355         emit SupplyRefund(supply.supplier, _partition, supply.amount, nonce);
1356     }
1357 
1358     /**
1359      * @notice Extracts refund data from the supplied parameters
1360      * @param _operatorData Contains the refund authorization data, including the refund
1361      * operation flag and supply nonce.
1362      * @return supplyNonce, nonce of the recorded supply
1363      * @return supply, The supplier, partition and amount of tokens in the original supply
1364      */
1365     function _getRefundData(bytes memory _operatorData)
1366         internal
1367         view
1368         returns (uint256, Supply memory)
1369     {
1370         uint256 _supplyNonce = _decodeRefundOperatorData(_operatorData);
1371         Supply memory supply = nonceToSupply[_supplyNonce];
1372 
1373         return (_supplyNonce, supply);
1374     }
1375 
1376     /**
1377      * @notice Validates that the parameters are valid for the requested refund
1378      * @param _partition Source partition of the tokens
1379      * @param _operator Address that is executing the refund
1380      * @param _value Number of tokens to be transferred
1381      * @param _supplyNonce nonce of the recorded supply
1382      * @param _supply The supplier, partition and amount of tokens in the original supply
1383      * @return true if the refund data is valid, otherwise false
1384      */
1385     function _verifyRefundData(
1386         bytes32 _partition,
1387         address _operator,
1388         uint256 _value,
1389         uint256 _supplyNonce,
1390         Supply memory _supply
1391     ) internal view returns (bool) {
1392         return
1393             // Supply record exists
1394             (_supply.amount > 0) &&
1395             // Only owner or supplier can invoke the refund
1396             (_operator == owner() || _operator == _supply.supplier) &&
1397             // Requested partition matches the Supply record
1398             (_partition == _supply.partition) &&
1399             // Requested value matches the Supply record
1400             (_value == _supply.amount) &&
1401             // Ensure we have entered fallback mode
1402             (SafeMath.add(fallbackSetDate, fallbackWithdrawalDelaySeconds) <= block.timestamp) &&
1403             // Supply has not already been included in the fallback withdrawal data
1404             (_supplyNonce > fallbackMaxIncludedSupplyNonce);
1405     }
1406 
1407     /**********************************************************************************************
1408      * Direct Transfers
1409      *********************************************************************************************/
1410 
1411     /**
1412      * @notice Validates direct transfer data
1413      * @param _operator Address that is invoking the transfer
1414      * @param _value Number of tokens to be transferred
1415      * @return true if the direct transfer data is valid, otherwise false
1416      */
1417     function _validateDirectTransfer(address _operator, uint256 _value)
1418         internal
1419         view
1420         returns (bool)
1421     {
1422         return
1423             // Only owner and directTransferer can invoke withdrawals
1424             (_operator == owner() || _operator == directTransferer) &&
1425             // Ensure we are within the global withdrawal limit
1426             (_value <= withdrawalLimit);
1427     }
1428 
1429     /**
1430      * @notice Validates the direct transfer data and updates state to reflect the transfer
1431      * @param _partition Source partition of the direct transfer
1432      * @param _operator Address that is invoking the transfer
1433      * @param _to The target address of the tokens.
1434      * @param _value Number of tokens to be transferred
1435      * @param _data Data attached to the transfer. Typically includes partition change information.
1436      */
1437     function _executeDirectTransfer(
1438         bytes32 _partition,
1439         address _operator,
1440         address _to,
1441         uint256 _value,
1442         bytes memory _data
1443     ) internal {
1444         require(_validateDirectTransfer(_operator, _value), "Transfer unauthorized");
1445 
1446         withdrawalLimit = SafeMath.sub(withdrawalLimit, _value);
1447 
1448         bytes32 to_partition = PartitionUtils._getDestinationPartition(_data, _partition);
1449 
1450         emit DirectTransfer(_operator, _partition, _to, to_partition, _value);
1451     }
1452 
1453     /**********************************************************************************************
1454      * Release Request
1455      *********************************************************************************************/
1456 
1457     /**
1458      * @notice Emits a release request event that can be used to trigger the release of tokens
1459      * @param _partition Parition from which the tokens should be released
1460      * @param _amount Number of tokens requested to be released
1461      * @param _data Metadata to include with the release request
1462      */
1463     function requestRelease(
1464         bytes32 _partition,
1465         uint256 _amount,
1466         bytes memory _data
1467     ) external {
1468         emit ReleaseRequest(msg.sender, _partition, _amount, _data);
1469     }
1470 
1471     /**********************************************************************************************
1472      * Partition Management
1473      *********************************************************************************************/
1474 
1475     /**
1476      * @notice Adds a partition to the set allowed to receive tokens
1477      * @param _partition Parition to be permitted for incoming transfers
1478      */
1479     function addPartition(bytes32 _partition) external {
1480         require(msg.sender == owner() || msg.sender == partitionManager, "Invalid sender");
1481         require(partitions[_partition] == false, "Partition already permitted");
1482 
1483         (bytes4 prefix, , address partitionOwner) = PartitionUtils._splitPartition(_partition);
1484 
1485         require(prefix == PARTITION_PREFIX, "Invalid partition prefix");
1486         require(partitionOwner == address(this), "Invalid partition owner");
1487 
1488         partitions[_partition] = true;
1489 
1490         emit PartitionAdded(_partition);
1491     }
1492 
1493     /**
1494      * @notice Removes a partition from the set allowed to receive tokens
1495      * @param _partition Parition to be disallowed from incoming transfers
1496      */
1497     function removePartition(bytes32 _partition) external {
1498         require(msg.sender == owner() || msg.sender == partitionManager, "Invalid sender");
1499         require(partitions[_partition], "Partition not permitted");
1500 
1501         delete partitions[_partition];
1502 
1503         emit PartitionRemoved(_partition);
1504     }
1505 
1506     /**********************************************************************************************
1507      * Withdrawal Management
1508      *********************************************************************************************/
1509 
1510     /**
1511      * @notice Modifies the withdrawal limit by the provided amount.
1512      * @param _amount Limit delta
1513      */
1514     function modifyWithdrawalLimit(int256 _amount) external {
1515         require(msg.sender == owner() || msg.sender == withdrawalLimitPublisher, "Invalid sender");
1516         uint256 oldLimit = withdrawalLimit;
1517         if (_amount < 0) {
1518             uint256 unsignedAmount = uint256(-_amount);
1519             withdrawalLimit = SafeMath.sub(withdrawalLimit, unsignedAmount);
1520         } else {
1521             uint256 unsignedAmount = uint256(_amount);
1522             withdrawalLimit = SafeMath.add(withdrawalLimit, unsignedAmount);
1523         }
1524         emit WithdrawalLimitUpdate(oldLimit, withdrawalLimit);
1525     }
1526 
1527     /**
1528      * @notice Adds the root hash of a Merkle tree containing authorized token withdrawals to the
1529      * active set
1530      * @param _root The root hash to be added to the active set
1531      * @param _nonce The nonce of the new root hash. Must be exactly one higher than the existing
1532      * max nonce.
1533      * @param _replacedRoots The root hashes to be removed from the repository.
1534      */
1535     function addWithdrawalRoot(
1536         bytes32 _root,
1537         uint256 _nonce,
1538         bytes32[] calldata _replacedRoots
1539     ) external {
1540         require(msg.sender == owner() || msg.sender == withdrawalPublisher, "Invalid sender");
1541 
1542         require(_root != 0, "Invalid root");
1543         require(maxWithdrawalRootNonce + 1 == _nonce, "Nonce not current max plus one");
1544         require(withdrawalRootToNonce[_root] == 0, "Nonce already used");
1545 
1546         withdrawalRootToNonce[_root] = _nonce;
1547         maxWithdrawalRootNonce = _nonce;
1548 
1549         emit WithdrawalRootHashAddition(_root, _nonce);
1550 
1551         for (uint256 i = 0; i < _replacedRoots.length; i++) {
1552             deleteWithdrawalRoot(_replacedRoots[i]);
1553         }
1554     }
1555 
1556     /**
1557      * @notice Removes withdrawal root hashes from active set
1558      * @param _roots The root hashes to be removed from the active set
1559      */
1560     function removeWithdrawalRoots(bytes32[] calldata _roots) external {
1561         require(msg.sender == owner() || msg.sender == withdrawalPublisher, "Invalid sender");
1562 
1563         for (uint256 i = 0; i < _roots.length; i++) {
1564             deleteWithdrawalRoot(_roots[i]);
1565         }
1566     }
1567 
1568     /**
1569      * @notice Removes a withdrawal root hash from active set
1570      * @param _root The root hash to be removed from the active set
1571      */
1572     function deleteWithdrawalRoot(bytes32 _root) private {
1573         uint256 nonce = withdrawalRootToNonce[_root];
1574 
1575         require(nonce > 0, "Root not found");
1576 
1577         delete withdrawalRootToNonce[_root];
1578 
1579         emit WithdrawalRootHashRemoval(_root, nonce);
1580     }
1581 
1582     /**********************************************************************************************
1583      * Fallback Management
1584      *********************************************************************************************/
1585 
1586     /**
1587      * @notice Sets the root hash of the Merkle tree containing fallback
1588      * withdrawal authorizations.
1589      * @param _root The root hash of a Merkle tree containing the fallback withdrawal
1590      * authorizations
1591      * @param _maxSupplyNonce The nonce of the latest supply whose value is reflected in the
1592      * fallback withdrawal authorizations.
1593      */
1594     function setFallbackRoot(bytes32 _root, uint256 _maxSupplyNonce) external {
1595         require(msg.sender == owner() || msg.sender == fallbackPublisher, "Invalid sender");
1596         require(_root != 0, "Invalid root");
1597         require(
1598             SafeMath.add(fallbackSetDate, fallbackWithdrawalDelaySeconds) > block.timestamp,
1599             "Fallback is active"
1600         );
1601         require(
1602             _maxSupplyNonce >= fallbackMaxIncludedSupplyNonce,
1603             "Included supply nonce decreased"
1604         );
1605         require(_maxSupplyNonce <= supplyNonce, "Included supply nonce exceeds latest supply");
1606 
1607         fallbackRoot = _root;
1608         fallbackMaxIncludedSupplyNonce = _maxSupplyNonce;
1609         fallbackSetDate = block.timestamp;
1610 
1611         emit FallbackRootHashSet(_root, fallbackMaxIncludedSupplyNonce, block.timestamp);
1612     }
1613 
1614     /**
1615      * @notice Resets the fallback set date to the current block's timestamp. This can be used to
1616      * delay the start of the fallback period without publishing a new root, or to deactivate the
1617      * fallback mechanism so a new fallback root may be published.
1618      */
1619     function resetFallbackMechanismDate() external {
1620         require(msg.sender == owner() || msg.sender == fallbackPublisher, "Invalid sender");
1621         fallbackSetDate = block.timestamp;
1622 
1623         emit FallbackMechanismDateReset(fallbackSetDate);
1624     }
1625 
1626     /**
1627      * @notice Updates the time-lock period before the fallback mechanism is activated after the
1628      * last fallback root was published.
1629      * @param _newFallbackDelaySeconds The new delay period in seconds
1630      */
1631     function setFallbackWithdrawalDelay(uint256 _newFallbackDelaySeconds) external {
1632         require(msg.sender == owner(), "Invalid sender");
1633         require(_newFallbackDelaySeconds != 0, "Invalid zero delay seconds");
1634         require(_newFallbackDelaySeconds < 10 * 365 days, "Invalid delay over 10 years");
1635 
1636         uint256 oldDelay = fallbackWithdrawalDelaySeconds;
1637         fallbackWithdrawalDelaySeconds = _newFallbackDelaySeconds;
1638 
1639         emit FallbackWithdrawalDelayUpdate(oldDelay, _newFallbackDelaySeconds);
1640     }
1641 
1642     /**********************************************************************************************
1643      * Role Management
1644      *********************************************************************************************/
1645 
1646     /**
1647      * @notice Updates the Withdrawal Publisher address, the only address other than the owner that
1648      * can publish / remove withdrawal Merkle tree roots.
1649      * @param _newWithdrawalPublisher The address of the new Withdrawal Publisher
1650      * @dev Error invalid sender.
1651      */
1652     function setWithdrawalPublisher(address _newWithdrawalPublisher) external {
1653         require(msg.sender == owner(), "Invalid sender");
1654 
1655         address oldValue = withdrawalPublisher;
1656         withdrawalPublisher = _newWithdrawalPublisher;
1657 
1658         emit WithdrawalPublisherUpdate(oldValue, withdrawalPublisher);
1659     }
1660 
1661     /**
1662      * @notice Updates the Fallback Publisher address, the only address other than the owner that
1663      * can publish / remove fallback withdrawal Merkle tree roots.
1664      * @param _newFallbackPublisher The address of the new Fallback Publisher
1665      * @dev Error invalid sender.
1666      */
1667     function setFallbackPublisher(address _newFallbackPublisher) external {
1668         require(msg.sender == owner(), "Invalid sender");
1669 
1670         address oldValue = fallbackPublisher;
1671         fallbackPublisher = _newFallbackPublisher;
1672 
1673         emit FallbackPublisherUpdate(oldValue, fallbackPublisher);
1674     }
1675 
1676     /**
1677      * @notice Updates the Withdrawal Limit Publisher address, the only address other than the
1678      * owner that can set the withdrawal limit.
1679      * @param _newWithdrawalLimitPublisher The address of the new Withdrawal Limit Publisher
1680      * @dev Error invalid sender.
1681      */
1682     function setWithdrawalLimitPublisher(address _newWithdrawalLimitPublisher) external {
1683         require(msg.sender == owner(), "Invalid sender");
1684 
1685         address oldValue = withdrawalLimitPublisher;
1686         withdrawalLimitPublisher = _newWithdrawalLimitPublisher;
1687 
1688         emit WithdrawalLimitPublisherUpdate(oldValue, withdrawalLimitPublisher);
1689     }
1690 
1691     /**
1692      * @notice Updates the DirectTransferer address, the only address other than the owner that
1693      * can execute direct transfers
1694      * @param _newDirectTransferer The address of the new DirectTransferer
1695      */
1696     function setDirectTransferer(address _newDirectTransferer) external {
1697         require(msg.sender == owner(), "Invalid sender");
1698 
1699         address oldValue = directTransferer;
1700         directTransferer = _newDirectTransferer;
1701 
1702         emit DirectTransfererUpdate(oldValue, directTransferer);
1703     }
1704 
1705     /**
1706      * @notice Updates the Partition Manager address, the only address other than the owner that
1707      * can add and remove permitted partitions
1708      * @param _newPartitionManager The address of the new PartitionManager
1709      */
1710     function setPartitionManager(address _newPartitionManager) external {
1711         require(msg.sender == owner(), "Invalid sender");
1712 
1713         address oldValue = partitionManager;
1714         partitionManager = _newPartitionManager;
1715 
1716         emit PartitionManagerUpdate(oldValue, partitionManager);
1717     }
1718 
1719     /**********************************************************************************************
1720      * Operator Data Decoders
1721      *********************************************************************************************/
1722 
1723     /**
1724      * @notice Extract flag from operatorData
1725      * @param _operatorData The operator data to be decoded
1726      * @return flag, the transfer operation type
1727      */
1728     function _decodeOperatorDataFlag(bytes memory _operatorData) internal pure returns (bytes32) {
1729         return abi.decode(_operatorData, (bytes32));
1730     }
1731 
1732     /**
1733      * @notice Extracts the supplier, max authorized nonce, and Merkle proof from the operator data
1734      * @param _operatorData The operator data to be decoded
1735      * @return supplier, the address whose account is authorized
1736      * @return For withdrawals: max authorized nonce, the last used withdrawal root nonce for the
1737      * supplier and partition. For fallback withdrawals: max cumulative withdrawal amount, the
1738      * maximum amount of tokens that can be withdrawn for the supplier's account, including both
1739      * withdrawals and fallback withdrawals
1740      * @return proof, the Merkle proof to be used for the authorization
1741      */
1742     function _decodeWithdrawalOperatorData(bytes memory _operatorData)
1743         internal
1744         pure
1745         returns (
1746             address,
1747             uint256,
1748             bytes32[] memory
1749         )
1750     {
1751         (, address supplier, uint256 nonce, bytes32[] memory proof) = abi.decode(
1752             _operatorData,
1753             (bytes32, address, uint256, bytes32[])
1754         );
1755 
1756         return (supplier, nonce, proof);
1757     }
1758 
1759     /**
1760      * @notice Extracts the supply nonce from the operator data
1761      * @param _operatorData The operator data to be decoded
1762      * @return nonce, the nonce of the supply to be refunded
1763      */
1764     function _decodeRefundOperatorData(bytes memory _operatorData) internal pure returns (uint256) {
1765         (, uint256 nonce) = abi.decode(_operatorData, (bytes32, uint256));
1766 
1767         return nonce;
1768     }
1769 
1770     /**********************************************************************************************
1771      * Merkle Tree Verification
1772      *********************************************************************************************/
1773 
1774     /**
1775      * @notice Hashes the supplied data and returns the hash to be used in conjunction with a proof
1776      * to calculate the Merkle tree root
1777      * @param _supplier The address whose account is authorized
1778      * @param _partition Source partition of the tokens
1779      * @param _value Number of tokens to be transferred
1780      * @param _maxAuthorizedAccountNonce The maximum existing used withdrawal nonce for the
1781      * supplier and partition
1782      * @return leaf, the hash of the supplied data
1783      */
1784     function _calculateWithdrawalLeaf(
1785         address _supplier,
1786         bytes32 _partition,
1787         uint256 _value,
1788         uint256 _maxAuthorizedAccountNonce
1789     ) internal pure returns (bytes32) {
1790         return
1791             keccak256(abi.encodePacked(_supplier, _partition, _value, _maxAuthorizedAccountNonce));
1792     }
1793 
1794     /**
1795      * @notice Hashes the supplied data and returns the hash to be used in conjunction with a proof
1796      * to calculate the Merkle tree root
1797      * @param _supplier The address whose account is authorized
1798      * @param _partition Source partition of the tokens
1799      * @param _maxCumulativeWithdrawalAmount, the maximum amount of tokens that can be withdrawn
1800      * for the supplier's account, including both withdrawals and fallback withdrawals
1801      * @return leaf, the hash of the supplied data
1802      */
1803     function _calculateFallbackLeaf(
1804         address _supplier,
1805         bytes32 _partition,
1806         uint256 _maxCumulativeWithdrawalAmount
1807     ) internal pure returns (bytes32) {
1808         return keccak256(abi.encodePacked(_supplier, _partition, _maxCumulativeWithdrawalAmount));
1809     }
1810 
1811     /**
1812      * @notice Calculates the Merkle root for the unique Merkle tree described by the provided
1813        Merkle proof and leaf hash.
1814      * @param _merkleProof The sibling node hashes at each level of the tree.
1815      * @param _leafHash The hash of the leaf data for which merkleProof is an inclusion proof.
1816      * @return The calculated Merkle root.
1817      */
1818     function _calculateMerkleRoot(bytes32[] memory _merkleProof, bytes32 _leafHash)
1819         private
1820         pure
1821         returns (bytes32)
1822     {
1823         bytes32 computedHash = _leafHash;
1824 
1825         for (uint256 i = 0; i < _merkleProof.length; i++) {
1826             bytes32 proofElement = _merkleProof[i];
1827 
1828             if (computedHash < proofElement) {
1829                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1830             } else {
1831                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1832             }
1833         }
1834 
1835         return computedHash;
1836     }
1837 }