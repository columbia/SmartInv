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
154 /**
155  * @dev Interface of the ERC20 standard as defined in the EIP.
156  */
157 interface IERC20 {
158     /**
159      * @dev Returns the amount of tokens in existence.
160      */
161     function totalSupply() external view returns (uint256);
162 
163     /**
164      * @dev Returns the amount of tokens owned by `account`.
165      */
166     function balanceOf(address account) external view returns (uint256);
167 
168     /**
169      * @dev Moves `amount` tokens from the caller's account to `recipient`.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transfer(address recipient, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Returns the remaining number of tokens that `spender` will be
179      * allowed to spend on behalf of `owner` through {transferFrom}. This is
180      * zero by default.
181      *
182      * This value changes when {approve} or {transferFrom} are called.
183      */
184     function allowance(address owner, address spender) external view returns (uint256);
185 
186     /**
187      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * IMPORTANT: Beware that changing an allowance with this method brings the risk
192      * that someone may use both the old and the new allowance by unfortunate
193      * transaction ordering. One possible solution to mitigate this race
194      * condition is to first reduce the spender's allowance to 0 and set the
195      * desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      *
198      * Emits an {Approval} event.
199      */
200     function approve(address spender, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Moves `amount` tokens from `sender` to `recipient` using the
204      * allowance mechanism. `amount` is then deducted from the caller's
205      * allowance.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Emitted when `value` tokens are moved from one account (`from`) to
215      * another (`to`).
216      *
217      * Note that `value` may be zero.
218      */
219     event Transfer(address indexed from, address indexed to, uint256 value);
220 
221     /**
222      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
223      * a call to {approve}. `value` is the new allowance.
224      */
225     event Approval(address indexed owner, address indexed spender, uint256 value);
226 }
227 
228 /**
229  * @title Ownable is a contract the provides contract ownership functionality, including a two-
230  * phase transfer.
231  */
232 contract Ownable {
233     address private _owner;
234     address private _authorizedNewOwner;
235 
236     /**
237      * @notice Emitted when the owner authorizes ownership transfer to a new address
238      * @param authorizedAddress New owner address
239      */
240     event OwnershipTransferAuthorization(address indexed authorizedAddress);
241 
242     /**
243      * @notice Emitted when the authorized address assumed ownership
244      * @param oldValue Old owner
245      * @param newValue New owner
246      */
247     event OwnerUpdate(address indexed oldValue, address indexed newValue);
248 
249     /**
250      * @notice Sets the owner to the sender / contract creator
251      */
252     constructor() internal {
253         _owner = msg.sender;
254     }
255 
256     /**
257      * @notice Retrieves the owner of the contract
258      * @return The contract owner
259      */
260     function owner() public view returns (address) {
261         return _owner;
262     }
263 
264     /**
265      * @notice Retrieves the authorized new owner of the contract
266      * @return The authorized new contract owner
267      */
268     function authorizedNewOwner() public view returns (address) {
269         return _authorizedNewOwner;
270     }
271 
272     /**
273      * @notice Authorizes the transfer of ownership from owner to the provided address.
274      * NOTE: No transfer will occur unless authorizedAddress calls assumeOwnership().
275      * This authorization may be removed by another call to this function authorizing the zero
276      * address.
277      * @param _authorizedAddress The address authorized to become the new owner
278      */
279     function authorizeOwnershipTransfer(address _authorizedAddress) external {
280         require(msg.sender == _owner, "Invalid sender");
281 
282         _authorizedNewOwner = _authorizedAddress;
283 
284         emit OwnershipTransferAuthorization(_authorizedNewOwner);
285     }
286 
287     /**
288      * @notice Transfers ownership of this contract to the _authorizedNewOwner
289      * @dev Error invalid sender.
290      */
291     function assumeOwnership() external {
292         require(msg.sender == _authorizedNewOwner, "Invalid sender");
293 
294         address oldValue = _owner;
295         _owner = _authorizedNewOwner;
296         _authorizedNewOwner = address(0);
297 
298         emit OwnerUpdate(oldValue, _owner);
299     }
300 }
301 
302 abstract contract ERC1820Registry {
303     function setInterfaceImplementer(
304         address _addr,
305         bytes32 _interfaceHash,
306         address _implementer
307     ) external virtual;
308 
309     function getInterfaceImplementer(address _addr, bytes32 _interfaceHash)
310         external
311         virtual
312         view
313         returns (address);
314 
315     function setManager(address _addr, address _newManager) external virtual;
316 
317     function getManager(address _addr) public virtual view returns (address);
318 }
319 
320 /// Base client to interact with the registry.
321 contract ERC1820Client {
322     ERC1820Registry constant ERC1820REGISTRY = ERC1820Registry(
323         0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24
324     );
325 
326     function setInterfaceImplementation(
327         string memory _interfaceLabel,
328         address _implementation
329     ) internal {
330         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
331         ERC1820REGISTRY.setInterfaceImplementer(
332             address(this),
333             interfaceHash,
334             _implementation
335         );
336     }
337 
338     function interfaceAddr(address addr, string memory _interfaceLabel)
339         internal
340         view
341         returns (address)
342     {
343         bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
344         return ERC1820REGISTRY.getInterfaceImplementer(addr, interfaceHash);
345     }
346 
347     function delegateManagement(address _newManager) internal {
348         ERC1820REGISTRY.setManager(address(this), _newManager);
349     }
350 }
351 
352 contract ERC1820Implementer {
353     /**
354      * @dev ERC1820 well defined magic value indicating the contract has
355      * registered with the ERC1820Registry that it can implement an interface.
356      */
357     bytes32 constant ERC1820_ACCEPT_MAGIC = keccak256(
358         abi.encodePacked("ERC1820_ACCEPT_MAGIC")
359     );
360 
361     /**
362      * @dev Mapping of interface name keccak256 hashes for which this contract
363      * implements the interface.
364      * @dev Only settable internally.
365      */
366     mapping(bytes32 => bool) internal _interfaceHashes;
367 
368     /**
369      * @notice Indicates whether the contract implements the interface `_interfaceHash`
370      * for the address `_addr`.
371      * @param _interfaceHash keccak256 hash of the name of the interface.
372      * @return ERC1820_ACCEPT_MAGIC only if the contract implements `ìnterfaceHash`
373      * for the address `_addr`.
374      * @dev In this implementation, the `_addr` (the address for which the
375      * contract will implement the interface) is always `address(this)`.
376      */
377     function canImplementInterfaceForAddress(
378         bytes32 _interfaceHash,
379         address // Comments to avoid compilation warnings for unused variables. /*addr*/
380     ) external view returns (bytes32) {
381         if (_interfaceHashes[_interfaceHash]) {
382             return ERC1820_ACCEPT_MAGIC;
383         } else {
384             return "";
385         }
386     }
387 
388     /**
389      * @notice Internally set the fact this contract implements the interface
390      * identified by `_interfaceLabel`
391      * @param _interfaceLabel String representation of the interface.
392      */
393     function _setInterface(string memory _interfaceLabel) internal {
394         _interfaceHashes[keccak256(abi.encodePacked(_interfaceLabel))] = true;
395     }
396 }
397 
398 /**
399  * @title IAmpTokensSender
400  * @dev IAmpTokensSender token transfer hook interface
401  */
402 interface IAmpTokensSender {
403     /**
404      * @dev Report if the transfer will succeed from the pespective of the
405      * token sender
406      */
407     function canTransfer(
408         bytes4 functionSig,
409         bytes32 partition,
410         address operator,
411         address from,
412         address to,
413         uint256 value,
414         bytes calldata data,
415         bytes calldata operatorData
416     ) external view returns (bool);
417 
418     /**
419      * @dev Hook executed upon a transfer on behalf of the sender
420      */
421     function tokensToTransfer(
422         bytes4 functionSig,
423         bytes32 partition,
424         address operator,
425         address from,
426         address to,
427         uint256 value,
428         bytes calldata data,
429         bytes calldata operatorData
430     ) external;
431 }
432 
433 /**
434  * @title IAmpTokensRecipient
435  * @dev IAmpTokensRecipient token transfer hook interface
436  */
437 interface IAmpTokensRecipient {
438     /**
439      * @dev Report if the recipient will successfully receive the tokens
440      */
441     function canReceive(
442         bytes4 functionSig,
443         bytes32 partition,
444         address operator,
445         address from,
446         address to,
447         uint256 value,
448         bytes calldata data,
449         bytes calldata operatorData
450     ) external view returns (bool);
451 
452     /**
453      * @dev Hook executed upon a transfer to the recipient
454      */
455     function tokensReceived(
456         bytes4 functionSig,
457         bytes32 partition,
458         address operator,
459         address from,
460         address to,
461         uint256 value,
462         bytes calldata data,
463         bytes calldata operatorData
464     ) external;
465 }
466 
467 /**
468  * @notice Partition strategy validator hooks for Amp
469  */
470 interface IAmpPartitionStrategyValidator {
471     function tokensFromPartitionToValidate(
472         bytes4 _functionSig,
473         bytes32 _partition,
474         address _operator,
475         address _from,
476         address _to,
477         uint256 _value,
478         bytes calldata _data,
479         bytes calldata _operatorData
480     ) external;
481 
482     function tokensToPartitionToValidate(
483         bytes4 _functionSig,
484         bytes32 _partition,
485         address _operator,
486         address _from,
487         address _to,
488         uint256 _value,
489         bytes calldata _data,
490         bytes calldata _operatorData
491     ) external;
492 
493     function isOperatorForPartitionScope(
494         bytes32 _partition,
495         address _operator,
496         address _tokenHolder
497     ) external view returns (bool);
498 }
499 
500 /**
501  * @title PartitionUtils
502  * @notice Partition related helper functions.
503  */
504 
505 library PartitionUtils {
506     bytes32 public constant CHANGE_PARTITION_FLAG = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
507 
508     /**
509      * @notice Retrieve the destination partition from the 'data' field.
510      * A partition change is requested ONLY when 'data' starts with the flag:
511      *
512      *   0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
513      *
514      * When the flag is detected, the destination partition is extracted from the
515      * 32 bytes following the flag.
516      * @param _data Information attached to the transfer. Will contain the
517      * destination partition if a change is requested.
518      * @param _fallbackPartition Partition value to return if a partition change
519      * is not requested in the `_data`.
520      * @return toPartition Destination partition. If the `_data` does not contain
521      * the prefix and bytes32 partition in the first 64 bytes, the method will
522      * return the provided `_fromPartition`.
523      */
524     function _getDestinationPartition(bytes memory _data, bytes32 _fallbackPartition)
525         internal
526         pure
527         returns (bytes32)
528     {
529         if (_data.length < 64) {
530             return _fallbackPartition;
531         }
532 
533         (bytes32 flag, bytes32 toPartition) = abi.decode(_data, (bytes32, bytes32));
534         if (flag == CHANGE_PARTITION_FLAG) {
535             return toPartition;
536         }
537 
538         return _fallbackPartition;
539     }
540 
541     /**
542      * @notice Helper to get the strategy identifying prefix from the `_partition`.
543      * @param _partition Partition to get the prefix for.
544      * @return 4 byte partition strategy prefix.
545      */
546     function _getPartitionPrefix(bytes32 _partition) internal pure returns (bytes4) {
547         return bytes4(_partition);
548     }
549 
550     /**
551      * @notice Helper method to split the partition into the prefix, sub partition
552      * and partition owner components.
553      * @param _partition The partition to split into parts.
554      * @return The 4 byte partition prefix, 8 byte sub partition, and final 20
555      * bytes representing an address.
556      */
557     function _splitPartition(bytes32 _partition)
558         internal
559         pure
560         returns (
561             bytes4,
562             bytes8,
563             address
564         )
565     {
566         bytes4 prefix = bytes4(_partition);
567         bytes8 subPartition = bytes8(_partition << 32);
568         address addressPart = address(uint160(uint256(_partition)));
569         return (prefix, subPartition, addressPart);
570     }
571 
572     /**
573      * @notice Helper method to get a partition strategy ERC1820 interface name
574      * based on partition prefix.
575      * @param _prefix 4 byte partition prefix.
576      * @dev Each 4 byte prefix has a unique interface name so that an individual
577      * hook implementation can be set for each prefix.
578      */
579     function _getPartitionStrategyValidatorIName(bytes4 _prefix)
580         internal
581         pure
582         returns (string memory)
583     {
584         return string(abi.encodePacked("AmpPartitionStrategyValidator", _prefix));
585     }
586 }
587 
588 /**
589  * @title ErrorCodes
590  * @notice Amp error codes.
591  */
592 contract ErrorCodes {
593     string internal EC_50_TRANSFER_FAILURE = "50";
594     string internal EC_51_TRANSFER_SUCCESS = "51";
595     string internal EC_52_INSUFFICIENT_BALANCE = "52";
596     string internal EC_53_INSUFFICIENT_ALLOWANCE = "53";
597 
598     string internal EC_56_INVALID_SENDER = "56";
599     string internal EC_57_INVALID_RECEIVER = "57";
600     string internal EC_58_INVALID_OPERATOR = "58";
601 
602     string internal EC_59_INSUFFICIENT_RIGHTS = "59";
603 
604     string internal EC_5A_INVALID_SWAP_TOKEN_ADDRESS = "5A";
605     string internal EC_5B_INVALID_VALUE_0 = "5B";
606     string internal EC_5C_ADDRESS_CONFLICT = "5C";
607     string internal EC_5D_PARTITION_RESERVED = "5D";
608     string internal EC_5E_PARTITION_PREFIX_CONFLICT = "5E";
609     string internal EC_5F_INVALID_PARTITION_PREFIX_0 = "5F";
610     string internal EC_60_SWAP_TRANSFER_FAILURE = "60";
611 }
612 
613 interface ISwapToken {
614     function allowance(address owner, address spender)
615         external
616         view
617         returns (uint256 remaining);
618 
619     function transferFrom(
620         address from,
621         address to,
622         uint256 value
623     ) external returns (bool success);
624 }
625 
626 /**
627  * @title Amp
628  * @notice Amp is an ERC20 compatible collateral token designed to support
629  * multiple classes of collateralization systems.
630  * @dev The Amp token contract includes the following features:
631  *
632  * Partitions
633  *   Tokens can be segmented within a given address by "partition", which in
634  *   pracice is a 32 byte identifier. These partitions can have unique
635  *   permissions globally, through the using of partition strategies, and
636  *   locally, on a per address basis. The ability to create the sub-segments
637  *   of tokens and assign special behavior gives collateral managers
638  *   flexibility in how they are implemented.
639  *
640  * Operators
641  *   Inspired by ERC777, Amp allows token holders to assign "operators" on
642  *   all (or any number of partitions) of their tokens. Operators are allowed
643  *   to execute transfers on behalf of token owners without the need to use the
644  *   ERC20 "allowance" semantics.
645  *
646  * Transfers with Data
647  *   Inspired by ERC777, Amp transfers can include arbitrary data, as well as
648  *   operator data. This data can be used to change the partition of tokens,
649  *   be used by collateral manager hooks to validate a transfer, be propagated
650  *   via event to an off chain system, etc.
651  *
652  * Token Transfer Hooks on Send and Receive
653  *   Inspired by ERC777, Amp uses the ERC1820 Registry to allow collateral
654  *   manager implementations to register hooks to be called upon sending to
655  *   or transferring from the collateral manager's address or, using partition
656  *   strategies, owned partition space. The hook implementations can be used
657  *   to validate transfer properties, gate transfers, emit custom events,
658  *   update local state, etc.
659  *
660  * Collateral Management Partition Strategies
661  *   Amp is able to define certain sets of partitions, identified by a 4 byte
662  *   prefix, that will allow special, custom logic to be executed when transfers
663  *   are made to or from those partitions. This opens up the possibility of
664  *   entire classes of collateral management systems that would not be possible
665  *   without it.
666  *
667  * These features give collateral manager implementers flexibility while
668  * providing a consistent, "collateral-in-place", interface for interacting
669  * with collateral systems directly through the Amp contract.
670  */
671 contract Amp is IERC20, ERC1820Client, ERC1820Implementer, ErrorCodes, Ownable {
672     using SafeMath for uint256;
673 
674     /**************************************************************************/
675     /********************** ERC1820 Interface Constants ***********************/
676 
677     /**
678      * @dev AmpToken interface label.
679      */
680     string internal constant AMP_INTERFACE_NAME = "AmpToken";
681 
682     /**
683      * @dev ERC20Token interface label.
684      */
685     string internal constant ERC20_INTERFACE_NAME = "ERC20Token";
686 
687     /**
688      * @dev AmpTokensSender interface label.
689      */
690     string internal constant AMP_TOKENS_SENDER = "AmpTokensSender";
691 
692     /**
693      * @dev AmpTokensRecipient interface label.
694      */
695     string internal constant AMP_TOKENS_RECIPIENT = "AmpTokensRecipient";
696 
697     /**
698      * @dev AmpTokensChecker interface label.
699      */
700     string internal constant AMP_TOKENS_CHECKER = "AmpTokensChecker";
701 
702     /**************************************************************************/
703     /*************************** Token properties *****************************/
704 
705     /**
706      * @dev Token name (Amp).
707      */
708     string internal _name;
709 
710     /**
711      * @dev Token symbol (AMP).
712      */
713     string internal _symbol;
714 
715     /**
716      * @dev Total minted supply of token. This will increase comensurately with
717      * successful swaps of the swap token.
718      */
719     uint256 internal _totalSupply;
720 
721     /**
722      * @dev The granularity of the token. Hard coded to 1.
723      */
724     uint256 internal constant _granularity = 1;
725 
726     /**************************************************************************/
727     /***************************** Token mappings *****************************/
728 
729     /**
730      * @dev Mapping from tokenHolder to balance. This reflects the balance
731      * across all partitions of an address.
732      */
733     mapping(address => uint256) internal _balances;
734 
735     /**************************************************************************/
736     /************************** Partition mappings ****************************/
737 
738     /**
739      * @dev List of active partitions. This list reflects all partitions that
740      * have tokens assigned to them.
741      */
742     bytes32[] internal _totalPartitions;
743 
744     /**
745      * @dev Mapping from partition to their index.
746      */
747     mapping(bytes32 => uint256) internal _indexOfTotalPartitions;
748 
749     /**
750      * @dev Mapping from partition to global balance of corresponding partition.
751      */
752     mapping(bytes32 => uint256) public totalSupplyByPartition;
753 
754     /**
755      * @dev Mapping from tokenHolder to their partitions.
756      */
757     mapping(address => bytes32[]) internal _partitionsOf;
758 
759     /**
760      * @dev Mapping from (tokenHolder, partition) to their index.
761      */
762     mapping(address => mapping(bytes32 => uint256)) internal _indexOfPartitionsOf;
763 
764     /**
765      * @dev Mapping from (tokenHolder, partition) to balance of corresponding
766      * partition.
767      */
768     mapping(address => mapping(bytes32 => uint256)) internal _balanceOfByPartition;
769 
770     /**
771      * @notice Default partition of the token.
772      * @dev All ERC20 operations operate solely on this partition.
773      */
774     bytes32
775         public constant defaultPartition = 0x0000000000000000000000000000000000000000000000000000000000000000;
776 
777     /**
778      * @dev Zero partition prefix. Parititions with this prefix can not have
779      * a strategy assigned, and partitions with a different prefix must have one.
780      */
781     bytes4 internal constant ZERO_PREFIX = 0x00000000;
782 
783     /**************************************************************************/
784     /***************************** Operator mappings **************************/
785 
786     /**
787      * @dev Mapping from (tokenHolder, operator) to authorized status. This is
788      * specific to the token holder.
789      */
790     mapping(address => mapping(address => bool)) internal _authorizedOperator;
791 
792     /**************************************************************************/
793     /********************** Partition operator mappings ***********************/
794 
795     /**
796      * @dev Mapping from (partition, tokenHolder, spender) to allowed value.
797      * This is specific to the token holder.
798      */
799     mapping(bytes32 => mapping(address => mapping(address => uint256)))
800         internal _allowedByPartition;
801 
802     /**
803      * @dev Mapping from (tokenHolder, partition, operator) to 'approved for
804      * partition' status. This is specific to the token holder.
805      */
806     mapping(address => mapping(bytes32 => mapping(address => bool)))
807         internal _authorizedOperatorByPartition;
808 
809     /**************************************************************************/
810     /********************** Collateral Manager mappings ***********************/
811     /**
812      * @notice Collection of registered collateral managers.
813      */
814     address[] public collateralManagers;
815     /**
816      * @dev Mapping of collateral manager addresses to registration status.
817      */
818     mapping(address => bool) internal _isCollateralManager;
819 
820     /**************************************************************************/
821     /********************* Partition Strategy mappings ************************/
822 
823     /**
824      * @notice Collection of reserved partition strategies.
825      */
826     bytes4[] public partitionStrategies;
827 
828     /**
829      * @dev Mapping of partition strategy flag to registration status.
830      */
831     mapping(bytes4 => bool) internal _isPartitionStrategy;
832 
833     /**************************************************************************/
834     /***************************** Swap storage *******************************/
835 
836     /**
837      * @notice Swap token address. Immutable.
838      */
839     ISwapToken public swapToken;
840 
841     /**
842      * @notice Swap token graveyard address.
843      * @dev This is the address that the incoming swapped tokens will be
844      * forwarded to upon successfully minting Amp.
845      */
846     address
847         public constant swapTokenGraveyard = 0x000000000000000000000000000000000000dEaD;
848 
849     /**************************************************************************/
850     /** EVENTS ****************************************************************/
851     /**************************************************************************/
852 
853     /**************************************************************************/
854     /**************************** Transfer Events *****************************/
855 
856     /**
857      * @notice Emitted when a transfer has been successfully completed.
858      * @param fromPartition The partition the tokens were transfered from.
859      * @param operator The address that initiated the transfer.
860      * @param from The address the tokens were transferred from.
861      * @param to The address the tokens were transferred to.
862      * @param value The amount of tokens transferred.
863      * @param data Additional metadata included with the transfer. Can include
864      * the partition the tokens were transferred to (if different than
865      * `fromPartition`).
866      * @param operatorData Additional metadata included with the transfer on
867      * behalf of the operator.
868      */
869     event TransferByPartition(
870         bytes32 indexed fromPartition,
871         address operator,
872         address indexed from,
873         address indexed to,
874         uint256 value,
875         bytes data,
876         bytes operatorData
877     );
878 
879     /**
880      * @notice Emitted when a transfer has been successfully completed and the
881      * tokens that were transferred have changed partitions.
882      * @param fromPartition The partition the tokens were transfered from.
883      * @param toPartition The partition the tokens were transfered to.
884      * @param value The amount of tokens transferred.
885      */
886     event ChangedPartition(
887         bytes32 indexed fromPartition,
888         bytes32 indexed toPartition,
889         uint256 value
890     );
891 
892     /**************************************************************************/
893     /**************************** Operator Events *****************************/
894 
895     /**
896      * @notice Emitted when a token holder specifies an amount of tokens in a
897      * a partition that an operator can transfer.
898      * @param partition The partition of the tokens the holder has authorized the
899      * operator to transfer from.
900      * @param owner The token holder.
901      * @param spender The operator the `owner` has authorized the allowance for.
902      */
903     event ApprovalByPartition(
904         bytes32 indexed partition,
905         address indexed owner,
906         address indexed spender,
907         uint256 value
908     );
909 
910     /**
911      * @notice Emitted when a token holder has authorized an operator for their
912      * tokens.
913      * @dev This event applies to the token holder address across all partitions.
914      * @param operator The address that was authorized to transfer tokens on
915      * behalf of the `tokenHolder`.
916      * @param tokenHolder The address that authorized the `operator` to transfer
917      * their tokens.
918      */
919     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
920 
921     /**
922      * @notice Emitted when a token holder has de-authorized an operator from
923      * transferring their tokens.
924      * @dev This event applies to the token holder address across all partitions.
925      * @param operator The address that was de-authorized from transferring tokens
926      * on behalf of the `tokenHolder`.
927      * @param tokenHolder The address that revoked the `operator`'s permission
928      * to transfer their tokens.
929      */
930     event RevokedOperator(address indexed operator, address indexed tokenHolder);
931 
932     /**
933      * @notice Emitted when a token holder has authorized an operator to transfer
934      * their tokens of one partition.
935      * @param partition The partition the `operator` is allowed to transfer
936      * tokens from.
937      * @param operator The address that was authorized to transfer tokens on
938      * behalf of the `tokenHolder`.
939      * @param tokenHolder The address that authorized the `operator` to transfer
940      * their tokens in `partition`.
941      */
942     event AuthorizedOperatorByPartition(
943         bytes32 indexed partition,
944         address indexed operator,
945         address indexed tokenHolder
946     );
947 
948     /**
949      * @notice Emitted when a token holder has de-authorized an operator from
950      * transferring their tokens from a specific partition.
951      * @param partition The partition the `operator` is no longer allowed to
952      * transfer tokens from on behalf of the `tokenHolder`.
953      * @param operator The address that was de-authorized from transferring
954      * tokens on behalf of the `tokenHolder`.
955      * @param tokenHolder The address that revoked the `operator`'s permission
956      * to transfer their tokens from `partition`.
957      */
958     event RevokedOperatorByPartition(
959         bytes32 indexed partition,
960         address indexed operator,
961         address indexed tokenHolder
962     );
963 
964     /**************************************************************************/
965     /********************** Collateral Manager Events *************************/
966 
967     /**
968      * @notice Emitted when a collateral manager has been registered.
969      * @param collateralManager The address of the collateral manager.
970      */
971     event CollateralManagerRegistered(address collateralManager);
972 
973     /**************************************************************************/
974     /*********************** Partition Strategy Events ************************/
975 
976     /**
977      * @notice Emitted when a new partition strategy validator is set.
978      * @param flag The 4 byte prefix of the partitions that the stratgy affects.
979      * @param name The name of the partition strategy.
980      * @param implementation The address of the partition strategy hook
981      * implementation.
982      */
983     event PartitionStrategySet(bytes4 flag, string name, address indexed implementation);
984 
985     // ************** Mint & Swap **************
986 
987     /**
988      * @notice Emitted when tokens are minted as a result of a token swap
989      * @param operator Address that executed the swap that resulted in tokens being minted
990      * @param to Address that received the newly minted tokens.
991      * @param value Amount of tokens minted
992      * @param data Empty bytes, required for interface compatibility
993      */
994     event Minted(address indexed operator, address indexed to, uint256 value, bytes data);
995 
996     /**
997      * @notice Indicates tokens swapped for Amp.
998      * @dev The tokens that are swapped for Amp will be transferred to a
999      * graveyard address that is for all practical purposes inaccessible.
1000      * @param operator Address that executed the swap.
1001      * @param from Address that the tokens were swapped from, and Amp minted for.
1002      * @param value Amount of tokens swapped into Amp.
1003      */
1004     event Swap(address indexed operator, address indexed from, uint256 value);
1005 
1006     /**************************************************************************/
1007     /** CONSTRUCTOR ***********************************************************/
1008     /**************************************************************************/
1009 
1010     /**
1011      * @notice Initialize Amp, initialize the default partition, and register the
1012      * contract implementation in the global ERC1820Registry.
1013      * @param _swapTokenAddress_ The address of the ERC20 token that is set to be
1014      * swappable for Amp.
1015      * @param _name_ Name of the token.
1016      * @param _symbol_ Symbol of the token.
1017      */
1018     constructor(
1019         address _swapTokenAddress_,
1020         string memory _name_,
1021         string memory _symbol_
1022     ) public {
1023         // "Swap token cannot be 0 address"
1024         require(_swapTokenAddress_ != address(0), EC_5A_INVALID_SWAP_TOKEN_ADDRESS);
1025         swapToken = ISwapToken(_swapTokenAddress_);
1026 
1027         _name = _name_;
1028         _symbol = _symbol_;
1029         _totalSupply = 0;
1030 
1031         // Add the default partition to the total partitions on deploy
1032         _addPartitionToTotalPartitions(defaultPartition);
1033 
1034         // Register contract in ERC1820 registry
1035         ERC1820Client.setInterfaceImplementation(AMP_INTERFACE_NAME, address(this));
1036         ERC1820Client.setInterfaceImplementation(ERC20_INTERFACE_NAME, address(this));
1037 
1038         // Indicate token verifies Amp and ERC20 interfaces
1039         ERC1820Implementer._setInterface(AMP_INTERFACE_NAME);
1040         ERC1820Implementer._setInterface(ERC20_INTERFACE_NAME);
1041     }
1042 
1043     /**************************************************************************/
1044     /** EXTERNAL FUNCTIONS (ERC20) ********************************************/
1045     /**************************************************************************/
1046 
1047     /**
1048      * @notice Get the total number of issued tokens.
1049      * @return Total supply of tokens currently in circulation.
1050      */
1051     function totalSupply() external override view returns (uint256) {
1052         return _totalSupply;
1053     }
1054 
1055     /**
1056      * @notice Get the balance of the account with address `_tokenHolder`.
1057      * @dev This returns the balance of the holder across all partitions. Note
1058      * that due to other functionality in Amp, this figure should not be used
1059      * as the arbiter of the amount a token holder will successfully be able to
1060      * send via the ERC20 compatible `transfer` method. In order to get that
1061      * figure, use `balanceOfByParition` and to get the balance of the default
1062      * partition.
1063      * @param _tokenHolder Address for which the balance is returned.
1064      * @return Amount of token held by `_tokenHolder` in the default partition.
1065      */
1066     function balanceOf(address _tokenHolder) external override view returns (uint256) {
1067         return _balances[_tokenHolder];
1068     }
1069 
1070     /**
1071      * @notice Transfer token for a specified address.
1072      * @dev This method is for ERC20 compatibility, and only affects the
1073      * balance of the `msg.sender` address's default partition.
1074      * @param _to The address to transfer to.
1075      * @param _value The value to be transferred.
1076      * @return A boolean that indicates if the operation was successful.
1077      */
1078     function transfer(address _to, uint256 _value) external override returns (bool) {
1079         _transferByDefaultPartition(msg.sender, msg.sender, _to, _value, "");
1080         return true;
1081     }
1082 
1083     /**
1084      * @notice Transfer tokens from one address to another.
1085      * @dev This method is for ERC20 compatibility, and only affects the
1086      * balance and allowance of the `_from` address's default partition.
1087      * @param _from The address which you want to transfer tokens from.
1088      * @param _to The address which you want to transfer to.
1089      * @param _value The amount of tokens to be transferred.
1090      * @return A boolean that indicates if the operation was successful.
1091      */
1092     function transferFrom(
1093         address _from,
1094         address _to,
1095         uint256 _value
1096     ) external override returns (bool) {
1097         _transferByDefaultPartition(msg.sender, _from, _to, _value, "");
1098         return true;
1099     }
1100 
1101     /**
1102      * @notice Check the value of tokens that an owner allowed to a spender.
1103      * @dev This method is for ERC20 compatibility, and only affects the
1104      * allowance of the `msg.sender`'s default partition.
1105      * @param _owner address The address which owns the funds.
1106      * @param _spender address The address which will spend the funds.
1107      * @return A uint256 specifying the value of tokens still available for the
1108      * spender.
1109      */
1110     function allowance(address _owner, address _spender)
1111         external
1112         override
1113         view
1114         returns (uint256)
1115     {
1116         return _allowedByPartition[defaultPartition][_owner][_spender];
1117     }
1118 
1119     /**
1120      * @notice Approve the passed address to spend the specified amount of
1121      * tokens from the default partition on behalf of 'msg.sender'.
1122      * @dev This method is for ERC20 compatibility, and only affects the
1123      * allowance of the `msg.sender`'s default partition.
1124      * @param _spender The address which will spend the funds.
1125      * @param _value The amount of tokens to be spent.
1126      * @return A boolean that indicates if the operation was successful.
1127      */
1128     function approve(address _spender, uint256 _value) external override returns (bool) {
1129         _approveByPartition(defaultPartition, msg.sender, _spender, _value);
1130         return true;
1131     }
1132 
1133     /**
1134      * @notice Atomically increases the allowance granted to `_spender` by the
1135      * for caller.
1136      * @dev This is an alternative to {approve} that can be used as a mitigation
1137      * problems described in {IERC20-approve}.
1138      * Emits an {Approval} event indicating the updated allowance.
1139      * Requirements:
1140      * - `_spender` cannot be the zero address.
1141      * @dev This method is for ERC20 compatibility, and only affects the
1142      * allowance of the `msg.sender`'s default partition.
1143      * @param _spender Operator allowed to transfer the tokens
1144      * @param _addedValue Additional amount of the `msg.sender`s tokens `_spender`
1145      * is allowed to transfer
1146      * @return 'true' is successful, 'false' otherwise
1147      */
1148     function increaseAllowance(address _spender, uint256 _addedValue)
1149         external
1150         returns (bool)
1151     {
1152         _approveByPartition(
1153             defaultPartition,
1154             msg.sender,
1155             _spender,
1156             _allowedByPartition[defaultPartition][msg.sender][_spender].add(_addedValue)
1157         );
1158         return true;
1159     }
1160 
1161     /**
1162      * @notice Atomically decreases the allowance granted to `_spender` by the
1163      * caller.
1164      * @dev This is an alternative to {approve} that can be used as a mitigation
1165      * for bugs caused by reentrancy.
1166      * Emits an {Approval} event indicating the updated allowance.
1167      * Requirements:
1168      * - `_spender` cannot be the zero address.
1169      * - `_spender` must have allowance for the caller of at least
1170      * `_subtractedValue`.
1171      * @dev This method is for ERC20 compatibility, and only affects the
1172      * allowance of the `msg.sender`'s default partition.
1173      * @param _spender Operator allowed to transfer the tokens
1174      * @param _subtractedValue Amount of the `msg.sender`s tokens `_spender`
1175      * is no longer allowed to transfer
1176      * @return 'true' is successful, 'false' otherwise
1177      */
1178     function decreaseAllowance(address _spender, uint256 _subtractedValue)
1179         external
1180         returns (bool)
1181     {
1182         _approveByPartition(
1183             defaultPartition,
1184             msg.sender,
1185             _spender,
1186             _allowedByPartition[defaultPartition][msg.sender][_spender].sub(
1187                 _subtractedValue
1188             )
1189         );
1190         return true;
1191     }
1192 
1193     /**************************************************************************/
1194     /** EXTERNAL FUNCTIONS (AMP) **********************************************/
1195     /**************************************************************************/
1196 
1197     /******************************** Swap  ***********************************/
1198 
1199     /**
1200      * @notice Swap tokens to mint AMP.
1201      * @dev Requires `_from` to have given allowance of swap token to contract.
1202      * Otherwise will throw error code 53 (Insuffient Allowance).
1203      * @param _from Token holder to execute the swap for.
1204      */
1205     function swap(address _from) public {
1206         uint256 amount = swapToken.allowance(_from, address(this));
1207         require(amount > 0, EC_53_INSUFFICIENT_ALLOWANCE);
1208 
1209         require(
1210             swapToken.transferFrom(_from, swapTokenGraveyard, amount),
1211             EC_60_SWAP_TRANSFER_FAILURE
1212         );
1213 
1214         _mint(msg.sender, _from, amount);
1215 
1216         emit Swap(msg.sender, _from, amount);
1217     }
1218 
1219     /**************************************************************************/
1220     /************************** Holder information ****************************/
1221 
1222     /**
1223      * @notice Get balance of a tokenholder for a specific partition.
1224      * @param _partition Name of the partition.
1225      * @param _tokenHolder Address for which the balance is returned.
1226      * @return Amount of token of partition `_partition` held by `_tokenHolder` in the token contract.
1227      */
1228     function balanceOfByPartition(bytes32 _partition, address _tokenHolder)
1229         external
1230         view
1231         returns (uint256)
1232     {
1233         return _balanceOfByPartition[_tokenHolder][_partition];
1234     }
1235 
1236     /**
1237      * @notice Get partitions index of a token holder.
1238      * @param _tokenHolder Address for which the partitions index are returned.
1239      * @return Array of partitions index of '_tokenHolder'.
1240      */
1241     function partitionsOf(address _tokenHolder) external view returns (bytes32[] memory) {
1242         return _partitionsOf[_tokenHolder];
1243     }
1244 
1245     /**************************************************************************/
1246     /************************** Advanced Transfers ****************************/
1247 
1248     /**
1249      * @notice Transfer tokens from a specific partition on behalf of a token
1250      * holder, optionally changing the parittion and optionally including
1251      * arbitrary data with the transfer.
1252      * @dev This can be used to transfer an address's own tokens, or transfer
1253      * a different addresses tokens by specifying the `_from` param. If
1254      * attempting to transfer from a different address than `msg.sender`, the
1255      * `msg.sender` will need to be an operator or have enough allowance for the
1256      * `_partition` of the `_from` address.
1257      * @param _partition Name of the partition to transfer from.
1258      * @param _from Token holder.
1259      * @param _to Token recipient.
1260      * @param _value Number of tokens to transfer.
1261      * @param _data Information attached to the transfer. Will contain the
1262      * destination partition (if changing partitions).
1263      * @param _operatorData Information attached to the transfer, by the operator.
1264      * @return Destination partition.
1265      */
1266     function transferByPartition(
1267         bytes32 _partition,
1268         address _from,
1269         address _to,
1270         uint256 _value,
1271         bytes calldata _data,
1272         bytes calldata _operatorData
1273     ) external returns (bytes32) {
1274         return
1275             _transferByPartition(
1276                 _partition,
1277                 msg.sender,
1278                 _from,
1279                 _to,
1280                 _value,
1281                 _data,
1282                 _operatorData
1283             );
1284     }
1285 
1286     /**************************************************************************/
1287     /************************** Operator Management ***************************/
1288 
1289     /**
1290      * @notice Set a third party operator address as an operator of 'msg.sender'
1291      * to transfer and redeem tokens on its behalf.
1292      * @dev The msg.sender is always an operator for itself, and does not need to
1293      * be explicitly added.
1294      * @param _operator Address to set as an operator for 'msg.sender'.
1295      */
1296     function authorizeOperator(address _operator) external {
1297         require(_operator != msg.sender, EC_58_INVALID_OPERATOR);
1298 
1299         _authorizedOperator[msg.sender][_operator] = true;
1300         emit AuthorizedOperator(_operator, msg.sender);
1301     }
1302 
1303     /**
1304      * @notice Remove the right of the operator address to be an operator for
1305      * 'msg.sender' and to transfer and redeem tokens on its behalf.
1306      * @dev The msg.sender is always an operator for itself, and cannot be
1307      * removed.
1308      * @param _operator Address to rescind as an operator for 'msg.sender'.
1309      */
1310     function revokeOperator(address _operator) external {
1311         require(_operator != msg.sender, EC_58_INVALID_OPERATOR);
1312 
1313         _authorizedOperator[msg.sender][_operator] = false;
1314         emit RevokedOperator(_operator, msg.sender);
1315     }
1316 
1317     /**
1318      * @notice Set `_operator` as an operator for 'msg.sender' for a given partition.
1319      * @dev The msg.sender is always an operator for itself, and does not need to
1320      * be explicitly added to a partition.
1321      * @param _partition Name of the partition.
1322      * @param _operator Address to set as an operator for 'msg.sender'.
1323      */
1324     function authorizeOperatorByPartition(bytes32 _partition, address _operator)
1325         external
1326     {
1327         require(_operator != msg.sender, EC_58_INVALID_OPERATOR);
1328 
1329         _authorizedOperatorByPartition[msg.sender][_partition][_operator] = true;
1330         emit AuthorizedOperatorByPartition(_partition, _operator, msg.sender);
1331     }
1332 
1333     /**
1334      * @notice Remove the right of the operator address to be an operator on a
1335      * given partition for 'msg.sender' and to transfer and redeem tokens on its
1336      * behalf.
1337      * @dev The msg.sender is always an operator for itself, and cannot be
1338      * removed from a partition.
1339      * @param _partition Name of the partition.
1340      * @param _operator Address to rescind as an operator on given partition for
1341      * 'msg.sender'.
1342      */
1343     function revokeOperatorByPartition(bytes32 _partition, address _operator) external {
1344         require(_operator != msg.sender, EC_58_INVALID_OPERATOR);
1345 
1346         _authorizedOperatorByPartition[msg.sender][_partition][_operator] = false;
1347         emit RevokedOperatorByPartition(_partition, _operator, msg.sender);
1348     }
1349 
1350     /**************************************************************************/
1351     /************************** Operator Information **************************/
1352     /**
1353      * @notice Indicate whether the `_operator` address is an operator of the
1354      * `_tokenHolder` address.
1355      * @dev An operator in this case is an operator across all of the partitions
1356      * of the `msg.sender` address.
1357      * @param _operator Address which may be an operator of `_tokenHolder`.
1358      * @param _tokenHolder Address of a token holder which may have the
1359      * `_operator` address as an operator.
1360      * @return 'true' if operator is an operator of 'tokenHolder' and 'false'
1361      * otherwise.
1362      */
1363     function isOperator(address _operator, address _tokenHolder)
1364         external
1365         view
1366         returns (bool)
1367     {
1368         return _isOperator(_operator, _tokenHolder);
1369     }
1370 
1371     /**
1372      * @notice Indicate whether the operator address is an operator of the
1373      * `_tokenHolder` address for the given partition.
1374      * @param _partition Name of the partition.
1375      * @param _operator Address which may be an operator of tokenHolder for the
1376      * given partition.
1377      * @param _tokenHolder Address of a token holder which may have the
1378      * `_operator` address as an operator for the given partition.
1379      * @return 'true' if 'operator' is an operator of `_tokenHolder` for
1380      * partition '_partition' and 'false' otherwise.
1381      */
1382     function isOperatorForPartition(
1383         bytes32 _partition,
1384         address _operator,
1385         address _tokenHolder
1386     ) external view returns (bool) {
1387         return _isOperatorForPartition(_partition, _operator, _tokenHolder);
1388     }
1389 
1390     /**
1391      * @notice Indicate when the `_operator` address is an operator of the
1392      * `_collateralManager` address for the given partition.
1393      * @dev This method is the same as `isOperatorForPartition`, except that it
1394      * also requires the address that `_operator` is being checked for MUST be
1395      * a registered collateral manager, and this method will not execute
1396      * partition strategy operator check hooks.
1397      * @param _partition Name of the partition.
1398      * @param _operator Address which may be an operator of `_collateralManager`
1399      * for the given partition.
1400      * @param _collateralManager Address of a collateral manager which may have
1401      * the `_operator` address as an operator for the given partition.
1402      */
1403     function isOperatorForCollateralManager(
1404         bytes32 _partition,
1405         address _operator,
1406         address _collateralManager
1407     ) external view returns (bool) {
1408         return
1409             _isCollateralManager[_collateralManager] &&
1410             (_isOperator(_operator, _collateralManager) ||
1411                 _authorizedOperatorByPartition[_collateralManager][_partition][_operator]);
1412     }
1413 
1414     /**************************************************************************/
1415     /***************************** Token metadata *****************************/
1416     /**
1417      * @notice Get the name of the token (Amp).
1418      * @return Name of the token.
1419      */
1420     function name() external view returns (string memory) {
1421         return _name;
1422     }
1423 
1424     /**
1425      * @notice Get the symbol of the token (AMP).
1426      * @return Symbol of the token.
1427      */
1428     function symbol() external view returns (string memory) {
1429         return _symbol;
1430     }
1431 
1432     /**
1433      * @notice Get the number of decimals of the token.
1434      * @dev Hard coded to 18.
1435      * @return The number of decimals of the token (18).
1436      */
1437     function decimals() external pure returns (uint8) {
1438         return uint8(18);
1439     }
1440 
1441     /**
1442      * @notice Get the smallest part of the token that’s not divisible.
1443      * @dev Hard coded to 1.
1444      * @return The smallest non-divisible part of the token.
1445      */
1446     function granularity() external pure returns (uint256) {
1447         return _granularity;
1448     }
1449 
1450     /**
1451      * @notice Get list of existing partitions.
1452      * @return Array of all exisiting partitions.
1453      */
1454     function totalPartitions() external view returns (bytes32[] memory) {
1455         return _totalPartitions;
1456     }
1457 
1458     /************************************************************************************************/
1459     /******************************** Partition Token Allowances ************************************/
1460     /**
1461      * @notice Check the value of tokens that an owner allowed to a spender.
1462      * @param _partition Name of the partition.
1463      * @param _owner The address which owns the tokens.
1464      * @param _spender The address which will spend the tokens.
1465      * @return The value of tokens still for the spender to transfer.
1466      */
1467     function allowanceByPartition(
1468         bytes32 _partition,
1469         address _owner,
1470         address _spender
1471     ) external view returns (uint256) {
1472         return _allowedByPartition[_partition][_owner][_spender];
1473     }
1474 
1475     /**
1476      * @notice Approve the `_spender` address to spend the specified amount of
1477      * tokens in `_partition` on behalf of 'msg.sender'.
1478      * @param _partition Name of the partition.
1479      * @param _spender The address which will spend the tokens.
1480      * @param _value The amount of tokens to be tokens.
1481      * @return A boolean that indicates if the operation was successful.
1482      */
1483     function approveByPartition(
1484         bytes32 _partition,
1485         address _spender,
1486         uint256 _value
1487     ) external returns (bool) {
1488         _approveByPartition(_partition, msg.sender, _spender, _value);
1489         return true;
1490     }
1491 
1492     /**
1493      * @notice Atomically increases the allowance granted to `_spender` by the
1494      * caller.
1495      * @dev This is an alternative to {approveByPartition} that can be used as
1496      * a mitigation for bugs caused by reentrancy.
1497      * Emits an {ApprovalByPartition} event indicating the updated allowance.
1498      * Requirements:
1499      * - `_spender` cannot be the zero address.
1500      * @param _partition Name of the partition.
1501      * @param _spender Operator allowed to transfer the tokens
1502      * @param _addedValue Additional amount of the `msg.sender`s tokens `_spender`
1503      * is allowed to transfer
1504      * @return 'true' is successful, 'false' otherwise
1505      */
1506     function increaseAllowanceByPartition(
1507         bytes32 _partition,
1508         address _spender,
1509         uint256 _addedValue
1510     ) external returns (bool) {
1511         _approveByPartition(
1512             _partition,
1513             msg.sender,
1514             _spender,
1515             _allowedByPartition[_partition][msg.sender][_spender].add(_addedValue)
1516         );
1517         return true;
1518     }
1519 
1520     /**
1521      * @notice Atomically decreases the allowance granted to `_spender` by the
1522      * caller.
1523      * @dev This is an alternative to {approveByPartition} that can be used as
1524      * a mitigation for bugs caused by reentrancy.
1525      * Emits an {ApprovalByPartition} event indicating the updated allowance.
1526      * Requirements:
1527      * - `_spender` cannot be the zero address.
1528      * - `_spender` must have allowance for the caller of at least
1529      * `_subtractedValue`.
1530      * @param _spender Operator allowed to transfer the tokens
1531      * @param _subtractedValue Amount of the `msg.sender`s tokens `_spender` is
1532      * no longer allowed to transfer
1533      * @return 'true' is successful, 'false' otherwise
1534      */
1535     function decreaseAllowanceByPartition(
1536         bytes32 _partition,
1537         address _spender,
1538         uint256 _subtractedValue
1539     ) external returns (bool) {
1540         // TOOD: Figure out if safe math will panic below 0
1541         _approveByPartition(
1542             _partition,
1543             msg.sender,
1544             _spender,
1545             _allowedByPartition[_partition][msg.sender][_spender].sub(_subtractedValue)
1546         );
1547         return true;
1548     }
1549 
1550     /**************************************************************************/
1551     /************************ Collateral Manager Admin ************************/
1552 
1553     /**
1554      * @notice Allow a collateral manager to self-register.
1555      * @dev Error 0x5c.
1556      */
1557     function registerCollateralManager() external {
1558         // Short circuit a double registry
1559         require(!_isCollateralManager[msg.sender], EC_5C_ADDRESS_CONFLICT);
1560 
1561         collateralManagers.push(msg.sender);
1562         _isCollateralManager[msg.sender] = true;
1563 
1564         emit CollateralManagerRegistered(msg.sender);
1565     }
1566 
1567     /**
1568      * @notice Get the status of a collateral manager.
1569      * @param _collateralManager The address of the collateral mananger in question.
1570      * @return 'true' if `_collateralManager` has self registered, 'false'
1571      * otherwise.
1572      */
1573     function isCollateralManager(address _collateralManager)
1574         external
1575         view
1576         returns (bool)
1577     {
1578         return _isCollateralManager[_collateralManager];
1579     }
1580 
1581     /**************************************************************************/
1582     /************************ Partition Strategy Admin ************************/
1583     /**
1584      * @notice Sets an implementation for a partition strategy identified by prefix.
1585      * @dev This is an administration method, callable only by the owner of the
1586      * Amp contract.
1587      * @param _prefix The 4 byte partition prefix the strategy applies to.
1588      * @param _implementation The address of the implementation of the strategy hooks.
1589      */
1590     function setPartitionStrategy(bytes4 _prefix, address _implementation) external {
1591         require(msg.sender == owner(), EC_56_INVALID_SENDER);
1592         require(!_isPartitionStrategy[_prefix], EC_5E_PARTITION_PREFIX_CONFLICT);
1593         require(_prefix != ZERO_PREFIX, EC_5F_INVALID_PARTITION_PREFIX_0);
1594 
1595         string memory iname = PartitionUtils._getPartitionStrategyValidatorIName(_prefix);
1596 
1597         ERC1820Client.setInterfaceImplementation(iname, _implementation);
1598         partitionStrategies.push(_prefix);
1599         _isPartitionStrategy[_prefix] = true;
1600 
1601         emit PartitionStrategySet(_prefix, iname, _implementation);
1602     }
1603 
1604     /**
1605      * @notice Return if a partition strategy has been reserved and has an
1606      * implementation registered.
1607      * @param _prefix The partition strategy identifier.
1608      * @return 'true' if the strategy has been registered, 'false' if not.
1609      */
1610     function isPartitionStrategy(bytes4 _prefix) external view returns (bool) {
1611         return _isPartitionStrategy[_prefix];
1612     }
1613 
1614     /**************************************************************************/
1615     /*************************** INTERNAL FUNCTIONS ***************************/
1616     /**************************************************************************/
1617 
1618     /**************************************************************************/
1619     /**************************** Token Transfers *****************************/
1620 
1621     /**
1622      * @dev Transfer tokens from a specific partition.
1623      * @param _fromPartition Partition of the tokens to transfer.
1624      * @param _operator The address performing the transfer.
1625      * @param _from Token holder.
1626      * @param _to Token recipient.
1627      * @param _value Number of tokens to transfer.
1628      * @param _data Information attached to the transfer. Contains the destination
1629      * partition if a partition change is requested.
1630      * @param _operatorData Information attached to the transfer, by the operator
1631      * (if any).
1632      * @return Destination partition.
1633      */
1634     function _transferByPartition(
1635         bytes32 _fromPartition,
1636         address _operator,
1637         address _from,
1638         address _to,
1639         uint256 _value,
1640         bytes memory _data,
1641         bytes memory _operatorData
1642     ) internal returns (bytes32) {
1643         require(_to != address(0), EC_57_INVALID_RECEIVER);
1644 
1645         // If the `_operator` is attempting to transfer from a different `_from`
1646         // address, first check that they have the requisite operator or
1647         // allowance permissions.
1648         if (_from != _operator) {
1649             require(
1650                 _isOperatorForPartition(_fromPartition, _operator, _from) ||
1651                     (_value <= _allowedByPartition[_fromPartition][_from][_operator]),
1652                 EC_53_INSUFFICIENT_ALLOWANCE
1653             );
1654 
1655             // If the sender has an allowance for the partition, that should
1656             // be decremented
1657             if (_allowedByPartition[_fromPartition][_from][_operator] >= _value) {
1658                 _allowedByPartition[_fromPartition][_from][msg
1659                     .sender] = _allowedByPartition[_fromPartition][_from][_operator].sub(
1660                     _value
1661                 );
1662             } else {
1663                 _allowedByPartition[_fromPartition][_from][_operator] = 0;
1664             }
1665         }
1666 
1667         _callPreTransferHooks(
1668             _fromPartition,
1669             _operator,
1670             _from,
1671             _to,
1672             _value,
1673             _data,
1674             _operatorData
1675         );
1676 
1677         require(
1678             _balanceOfByPartition[_from][_fromPartition] >= _value,
1679             EC_52_INSUFFICIENT_BALANCE
1680         );
1681 
1682         bytes32 toPartition = PartitionUtils._getDestinationPartition(
1683             _data,
1684             _fromPartition
1685         );
1686 
1687         _removeTokenFromPartition(_from, _fromPartition, _value);
1688         _addTokenToPartition(_to, toPartition, _value);
1689         _callPostTransferHooks(
1690             toPartition,
1691             _operator,
1692             _from,
1693             _to,
1694             _value,
1695             _data,
1696             _operatorData
1697         );
1698 
1699         emit Transfer(_from, _to, _value);
1700         emit TransferByPartition(
1701             _fromPartition,
1702             _operator,
1703             _from,
1704             _to,
1705             _value,
1706             _data,
1707             _operatorData
1708         );
1709 
1710         if (toPartition != _fromPartition) {
1711             emit ChangedPartition(_fromPartition, toPartition, _value);
1712         }
1713 
1714         return toPartition;
1715     }
1716 
1717     /**
1718      * @notice Transfer tokens from default partitions.
1719      * @dev Used as a helper method for ERC20 compatibility.
1720      * @param _operator The address performing the transfer.
1721      * @param _from Token holder.
1722      * @param _to Token recipient.
1723      * @param _value Number of tokens to transfer.
1724      * @param _data Information attached to the transfer, and intended for the
1725      * token holder (`_from`). Should contain the destination partition if
1726      * changing partitions.
1727      */
1728     function _transferByDefaultPartition(
1729         address _operator,
1730         address _from,
1731         address _to,
1732         uint256 _value,
1733         bytes memory _data
1734     ) internal {
1735         _transferByPartition(defaultPartition, _operator, _from, _to, _value, _data, "");
1736     }
1737 
1738     /**
1739      * @dev Remove a token from a specific partition.
1740      * @param _from Token holder.
1741      * @param _partition Name of the partition.
1742      * @param _value Number of tokens to transfer.
1743      */
1744     function _removeTokenFromPartition(
1745         address _from,
1746         bytes32 _partition,
1747         uint256 _value
1748     ) internal {
1749         if (_value == 0) {
1750             return;
1751         }
1752 
1753         _balances[_from] = _balances[_from].sub(_value);
1754 
1755         _balanceOfByPartition[_from][_partition] = _balanceOfByPartition[_from][_partition]
1756             .sub(_value);
1757         totalSupplyByPartition[_partition] = totalSupplyByPartition[_partition].sub(
1758             _value
1759         );
1760 
1761         // If the total supply is zero, finds and deletes the partition.
1762         // Do not delete the _defaultPartition from totalPartitions.
1763         if (totalSupplyByPartition[_partition] == 0 && _partition != defaultPartition) {
1764             _removePartitionFromTotalPartitions(_partition);
1765         }
1766 
1767         // If the balance of the TokenHolder's partition is zero, finds and
1768         // deletes the partition.
1769         if (_balanceOfByPartition[_from][_partition] == 0) {
1770             uint256 index = _indexOfPartitionsOf[_from][_partition];
1771 
1772             if (index == 0) {
1773                 return;
1774             }
1775 
1776             // move the last item into the index being vacated
1777             bytes32 lastValue = _partitionsOf[_from][_partitionsOf[_from].length - 1];
1778             _partitionsOf[_from][index - 1] = lastValue; // adjust for 1-based indexing
1779             _indexOfPartitionsOf[_from][lastValue] = index;
1780 
1781             _partitionsOf[_from].pop();
1782             _indexOfPartitionsOf[_from][_partition] = 0;
1783         }
1784     }
1785 
1786     /**
1787      * @dev Add a token to a specific partition.
1788      * @param _to Token recipient.
1789      * @param _partition Name of the partition.
1790      * @param _value Number of tokens to transfer.
1791      */
1792     function _addTokenToPartition(
1793         address _to,
1794         bytes32 _partition,
1795         uint256 _value
1796     ) internal {
1797         if (_value == 0) {
1798             return;
1799         }
1800 
1801         _balances[_to] = _balances[_to].add(_value);
1802 
1803         if (_indexOfPartitionsOf[_to][_partition] == 0) {
1804             _partitionsOf[_to].push(_partition);
1805             _indexOfPartitionsOf[_to][_partition] = _partitionsOf[_to].length;
1806         }
1807         _balanceOfByPartition[_to][_partition] = _balanceOfByPartition[_to][_partition]
1808             .add(_value);
1809 
1810         if (_indexOfTotalPartitions[_partition] == 0) {
1811             _addPartitionToTotalPartitions(_partition);
1812         }
1813         totalSupplyByPartition[_partition] = totalSupplyByPartition[_partition].add(
1814             _value
1815         );
1816     }
1817 
1818     /**
1819      * @dev Add a partition to the total partitions collection.
1820      * @param _partition Name of the partition.
1821      */
1822     function _addPartitionToTotalPartitions(bytes32 _partition) internal {
1823         _totalPartitions.push(_partition);
1824         _indexOfTotalPartitions[_partition] = _totalPartitions.length;
1825     }
1826 
1827     /**
1828      * @dev Remove a partition to the total partitions collection.
1829      * @param _partition Name of the partition.
1830      */
1831     function _removePartitionFromTotalPartitions(bytes32 _partition) internal {
1832         uint256 index = _indexOfTotalPartitions[_partition];
1833 
1834         if (index == 0) {
1835             return;
1836         }
1837 
1838         // move the last item into the index being vacated
1839         bytes32 lastValue = _totalPartitions[_totalPartitions.length - 1];
1840         _totalPartitions[index - 1] = lastValue; // adjust for 1-based indexing
1841         _indexOfTotalPartitions[lastValue] = index;
1842 
1843         _totalPartitions.pop();
1844         _indexOfTotalPartitions[_partition] = 0;
1845     }
1846 
1847     /**************************************************************************/
1848     /********************************* Hooks **********************************/
1849     /**
1850      * @notice Check for and call the 'AmpTokensSender' hook on the sender address
1851      * (`_from`), and, if `_fromPartition` is within the scope of a strategy,
1852      * check for and call the 'AmpPartitionStrategy.tokensFromPartitionToTransfer'
1853      * hook for the strategy.
1854      * @param _fromPartition Name of the partition to transfer tokens from.
1855      * @param _operator Address which triggered the balance decrease (through
1856      * transfer).
1857      * @param _from Token holder.
1858      * @param _to Token recipient for a transfer.
1859      * @param _value Number of tokens the token holder balance is decreased by.
1860      * @param _data Extra information, pertaining to the `_from` address.
1861      * @param _operatorData Extra information, attached by the operator (if any).
1862      */
1863     function _callPreTransferHooks(
1864         bytes32 _fromPartition,
1865         address _operator,
1866         address _from,
1867         address _to,
1868         uint256 _value,
1869         bytes memory _data,
1870         bytes memory _operatorData
1871     ) internal {
1872         address senderImplementation;
1873         senderImplementation = interfaceAddr(_from, AMP_TOKENS_SENDER);
1874         if (senderImplementation != address(0)) {
1875             IAmpTokensSender(senderImplementation).tokensToTransfer(
1876                 msg.sig,
1877                 _fromPartition,
1878                 _operator,
1879                 _from,
1880                 _to,
1881                 _value,
1882                 _data,
1883                 _operatorData
1884             );
1885         }
1886 
1887         // Used to ensure that hooks implemented by a collateral manager to validate
1888         // transfers from it's owned partitions are called
1889         bytes4 fromPartitionPrefix = PartitionUtils._getPartitionPrefix(_fromPartition);
1890         if (_isPartitionStrategy[fromPartitionPrefix]) {
1891             address fromPartitionValidatorImplementation;
1892             fromPartitionValidatorImplementation = interfaceAddr(
1893                 address(this),
1894                 PartitionUtils._getPartitionStrategyValidatorIName(fromPartitionPrefix)
1895             );
1896             if (fromPartitionValidatorImplementation != address(0)) {
1897                 IAmpPartitionStrategyValidator(fromPartitionValidatorImplementation)
1898                     .tokensFromPartitionToValidate(
1899                     msg.sig,
1900                     _fromPartition,
1901                     _operator,
1902                     _from,
1903                     _to,
1904                     _value,
1905                     _data,
1906                     _operatorData
1907                 );
1908             }
1909         }
1910     }
1911 
1912     /**
1913      * @dev Check for 'AmpTokensRecipient' hook on the recipient and call it.
1914      * @param _toPartition Name of the partition the tokens were transferred to.
1915      * @param _operator Address which triggered the balance increase (through
1916      * transfer or mint).
1917      * @param _from Token holder for a transfer (0x when mint).
1918      * @param _to Token recipient.
1919      * @param _value Number of tokens the recipient balance is increased by.
1920      * @param _data Extra information related to the token holder (`_from`).
1921      * @param _operatorData Extra information attached by the operator (if any).
1922      */
1923     function _callPostTransferHooks(
1924         bytes32 _toPartition,
1925         address _operator,
1926         address _from,
1927         address _to,
1928         uint256 _value,
1929         bytes memory _data,
1930         bytes memory _operatorData
1931     ) internal {
1932         bytes4 toPartitionPrefix = PartitionUtils._getPartitionPrefix(_toPartition);
1933         if (_isPartitionStrategy[toPartitionPrefix]) {
1934             address partitionManagerImplementation;
1935             partitionManagerImplementation = interfaceAddr(
1936                 address(this),
1937                 PartitionUtils._getPartitionStrategyValidatorIName(toPartitionPrefix)
1938             );
1939             if (partitionManagerImplementation != address(0)) {
1940                 IAmpPartitionStrategyValidator(partitionManagerImplementation)
1941                     .tokensToPartitionToValidate(
1942                     msg.sig,
1943                     _toPartition,
1944                     _operator,
1945                     _from,
1946                     _to,
1947                     _value,
1948                     _data,
1949                     _operatorData
1950                 );
1951             }
1952         } else {
1953             require(toPartitionPrefix == ZERO_PREFIX, EC_5D_PARTITION_RESERVED);
1954         }
1955 
1956         address recipientImplementation;
1957         recipientImplementation = interfaceAddr(_to, AMP_TOKENS_RECIPIENT);
1958 
1959         if (recipientImplementation != address(0)) {
1960             IAmpTokensRecipient(recipientImplementation).tokensReceived(
1961                 msg.sig,
1962                 _toPartition,
1963                 _operator,
1964                 _from,
1965                 _to,
1966                 _value,
1967                 _data,
1968                 _operatorData
1969             );
1970         }
1971     }
1972 
1973     /**************************************************************************/
1974     /******************************* Allowance ********************************/
1975     /**
1976      * @notice Approve the `_spender` address to spend the specified amount of
1977      * tokens in `_partition` on behalf of 'msg.sender'.
1978      * @param _partition Name of the partition.
1979      * @param _tokenHolder Owner of the tokens.
1980      * @param _spender The address which will spend the tokens.
1981      * @param _amount The amount of tokens to be tokens.
1982      */
1983     function _approveByPartition(
1984         bytes32 _partition,
1985         address _tokenHolder,
1986         address _spender,
1987         uint256 _amount
1988     ) internal {
1989         require(_tokenHolder != address(0), EC_56_INVALID_SENDER);
1990         require(_spender != address(0), EC_58_INVALID_OPERATOR);
1991 
1992         _allowedByPartition[_partition][_tokenHolder][_spender] = _amount;
1993         emit ApprovalByPartition(_partition, _tokenHolder, _spender, _amount);
1994 
1995         if (_partition == defaultPartition) {
1996             emit Approval(_tokenHolder, _spender, _amount);
1997         }
1998     }
1999 
2000     /**************************************************************************/
2001     /************************** Operator Information **************************/
2002     /**
2003      * @dev Indicate whether the operator address is an operator of the
2004      * tokenHolder address. An operator in this case is an operator across all
2005      * partitions of the `msg.sender` address.
2006      * @param _operator Address which may be an operator of '_tokenHolder'.
2007      * @param _tokenHolder Address of a token holder which may have the '_operator'
2008      * address as an operator.
2009      * @return 'true' if `_operator` is an operator of `_tokenHolder` and 'false'
2010      * otherwise.
2011      */
2012     function _isOperator(address _operator, address _tokenHolder)
2013         internal
2014         view
2015         returns (bool)
2016     {
2017         return (_operator == _tokenHolder ||
2018             _authorizedOperator[_tokenHolder][_operator]);
2019     }
2020 
2021     /**
2022      * @dev Indicate whether the operator address is an operator of the
2023      * tokenHolder address for the given partition.
2024      * @param _partition Name of the partition.
2025      * @param _operator Address which may be an operator of tokenHolder for the
2026      * given partition.
2027      * @param _tokenHolder Address of a token holder which may have the operator
2028      * address as an operator for the given partition.
2029      * @return 'true' if 'operator' is an operator of 'tokenHolder' for partition
2030      * `_partition` and 'false' otherwise.
2031      */
2032     function _isOperatorForPartition(
2033         bytes32 _partition,
2034         address _operator,
2035         address _tokenHolder
2036     ) internal view returns (bool) {
2037         return (_isOperator(_operator, _tokenHolder) ||
2038             _authorizedOperatorByPartition[_tokenHolder][_partition][_operator] ||
2039             _callPartitionStrategyOperatorHook(_partition, _operator, _tokenHolder));
2040     }
2041 
2042     /**
2043      * @notice Check if the `_partition` is within the scope of a strategy, and
2044      * call it's isOperatorForPartitionScope hook if so.
2045      * @dev This allows implicit granting of operatorByPartition permissions
2046      * based on the partition being used being of a strategy.
2047      * @param _partition The partition to check.
2048      * @param _operator The address to check if is an operator for `_tokenHolder`.
2049      * @param _tokenHolder The address to validate that `_operator` is an
2050      * operator for.
2051      */
2052     function _callPartitionStrategyOperatorHook(
2053         bytes32 _partition,
2054         address _operator,
2055         address _tokenHolder
2056     ) internal view returns (bool) {
2057         bytes4 prefix = PartitionUtils._getPartitionPrefix(_partition);
2058 
2059         if (!_isPartitionStrategy[prefix]) {
2060             return false;
2061         }
2062 
2063         address strategyValidatorImplementation;
2064         strategyValidatorImplementation = interfaceAddr(
2065             address(this),
2066             PartitionUtils._getPartitionStrategyValidatorIName(prefix)
2067         );
2068         if (strategyValidatorImplementation != address(0)) {
2069             return
2070                 IAmpPartitionStrategyValidator(strategyValidatorImplementation)
2071                     .isOperatorForPartitionScope(_partition, _operator, _tokenHolder);
2072         }
2073 
2074         // Not a partition format that imbues special operator rules
2075         return false;
2076     }
2077 
2078     /**************************************************************************/
2079     /******************************** Minting *********************************/
2080     /**
2081      * @notice Perform the minting of tokens.
2082      * @dev The tokens will be minted on behalf of the `_to` address, and will be
2083      * minted to the address's default partition.
2084      * @param _operator Address which triggered the issuance.
2085      * @param _to Token recipient.
2086      * @param _value Number of tokens issued.
2087      */
2088     function _mint(
2089         address _operator,
2090         address _to,
2091         uint256 _value
2092     ) internal {
2093         require(_to != address(0), EC_57_INVALID_RECEIVER);
2094 
2095         _totalSupply = _totalSupply.add(_value);
2096         _addTokenToPartition(_to, defaultPartition, _value);
2097         _callPostTransferHooks(
2098             defaultPartition,
2099             _operator,
2100             address(0),
2101             _to,
2102             _value,
2103             "",
2104             ""
2105         );
2106 
2107         emit Minted(_operator, _to, _value, "");
2108         emit Transfer(address(0), _to, _value);
2109         emit TransferByPartition(bytes32(0), _operator, address(0), _to, _value, "", "");
2110     }
2111 }