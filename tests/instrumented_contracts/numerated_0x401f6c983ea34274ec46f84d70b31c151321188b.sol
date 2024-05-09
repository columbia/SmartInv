1 // File: contracts/common/governance/IGovernance.sol
2 
3 pragma solidity ^0.5.2;
4 
5 interface IGovernance {
6     function update(address target, bytes calldata data) external;
7 }
8 
9 // File: contracts/common/governance/Governable.sol
10 
11 pragma solidity ^0.5.2;
12 
13 
14 contract Governable {
15     IGovernance public governance;
16 
17     constructor(address _governance) public {
18         governance = IGovernance(_governance);
19     }
20 
21     modifier onlyGovernance() {
22         require(
23             msg.sender == address(governance),
24             "Only governance contract is authorized"
25         );
26         _;
27     }
28 }
29 
30 // File: contracts/root/withdrawManager/IWithdrawManager.sol
31 
32 pragma solidity ^0.5.2;
33 
34 contract IWithdrawManager {
35     function createExitQueue(address token) external;
36 
37     function verifyInclusion(
38         bytes calldata data,
39         uint8 offset,
40         bool verifyTxInclusion
41     ) external view returns (uint256 age);
42 
43     function addExitToQueue(
44         address exitor,
45         address childToken,
46         address rootToken,
47         uint256 exitAmountOrTokenId,
48         bytes32 txHash,
49         bool isRegularExit,
50         uint256 priority
51     ) external;
52 
53     function addInput(
54         uint256 exitId,
55         uint256 age,
56         address utxoOwner,
57         address token
58     ) external;
59 
60     function challengeExit(
61         uint256 exitId,
62         uint256 inputId,
63         bytes calldata challengeData,
64         address adjudicatorPredicate
65     ) external;
66 }
67 
68 // File: contracts/common/Registry.sol
69 
70 pragma solidity ^0.5.2;
71 
72 
73 
74 
75 contract Registry is Governable {
76     // @todo hardcode constants
77     bytes32 private constant WETH_TOKEN = keccak256("wethToken");
78     bytes32 private constant DEPOSIT_MANAGER = keccak256("depositManager");
79     bytes32 private constant STAKE_MANAGER = keccak256("stakeManager");
80     bytes32 private constant VALIDATOR_SHARE = keccak256("validatorShare");
81     bytes32 private constant WITHDRAW_MANAGER = keccak256("withdrawManager");
82     bytes32 private constant CHILD_CHAIN = keccak256("childChain");
83     bytes32 private constant STATE_SENDER = keccak256("stateSender");
84     bytes32 private constant SLASHING_MANAGER = keccak256("slashingManager");
85 
86     address public erc20Predicate;
87     address public erc721Predicate;
88 
89     mapping(bytes32 => address) public contractMap;
90     mapping(address => address) public rootToChildToken;
91     mapping(address => address) public childToRootToken;
92     mapping(address => bool) public proofValidatorContracts;
93     mapping(address => bool) public isERC721;
94 
95     enum Type {Invalid, ERC20, ERC721, Custom}
96     struct Predicate {
97         Type _type;
98     }
99     mapping(address => Predicate) public predicates;
100 
101     event TokenMapped(address indexed rootToken, address indexed childToken);
102     event ProofValidatorAdded(address indexed validator, address indexed from);
103     event ProofValidatorRemoved(address indexed validator, address indexed from);
104     event PredicateAdded(address indexed predicate, address indexed from);
105     event PredicateRemoved(address indexed predicate, address indexed from);
106     event ContractMapUpdated(bytes32 indexed key, address indexed previousContract, address indexed newContract);
107 
108     constructor(address _governance) public Governable(_governance) {}
109 
110     function updateContractMap(bytes32 _key, address _address) external onlyGovernance {
111         emit ContractMapUpdated(_key, contractMap[_key], _address);
112         contractMap[_key] = _address;
113     }
114 
115     /**
116      * @dev Map root token to child token
117      * @param _rootToken Token address on the root chain
118      * @param _childToken Token address on the child chain
119      * @param _isERC721 Is the token being mapped ERC721
120      */
121     function mapToken(
122         address _rootToken,
123         address _childToken,
124         bool _isERC721
125     ) external onlyGovernance {
126         require(_rootToken != address(0x0) && _childToken != address(0x0), "INVALID_TOKEN_ADDRESS");
127         rootToChildToken[_rootToken] = _childToken;
128         childToRootToken[_childToken] = _rootToken;
129         isERC721[_rootToken] = _isERC721;
130         IWithdrawManager(contractMap[WITHDRAW_MANAGER]).createExitQueue(_rootToken);
131         emit TokenMapped(_rootToken, _childToken);
132     }
133 
134     function addErc20Predicate(address predicate) public onlyGovernance {
135         require(predicate != address(0x0), "Can not add null address as predicate");
136         erc20Predicate = predicate;
137         addPredicate(predicate, Type.ERC20);
138     }
139 
140     function addErc721Predicate(address predicate) public onlyGovernance {
141         erc721Predicate = predicate;
142         addPredicate(predicate, Type.ERC721);
143     }
144 
145     function addPredicate(address predicate, Type _type) public onlyGovernance {
146         require(predicates[predicate]._type == Type.Invalid, "Predicate already added");
147         predicates[predicate]._type = _type;
148         emit PredicateAdded(predicate, msg.sender);
149     }
150 
151     function removePredicate(address predicate) public onlyGovernance {
152         require(predicates[predicate]._type != Type.Invalid, "Predicate does not exist");
153         delete predicates[predicate];
154         emit PredicateRemoved(predicate, msg.sender);
155     }
156 
157     function getValidatorShareAddress() public view returns (address) {
158         return contractMap[VALIDATOR_SHARE];
159     }
160 
161     function getWethTokenAddress() public view returns (address) {
162         return contractMap[WETH_TOKEN];
163     }
164 
165     function getDepositManagerAddress() public view returns (address) {
166         return contractMap[DEPOSIT_MANAGER];
167     }
168 
169     function getStakeManagerAddress() public view returns (address) {
170         return contractMap[STAKE_MANAGER];
171     }
172 
173     function getSlashingManagerAddress() public view returns (address) {
174         return contractMap[SLASHING_MANAGER];
175     }
176 
177     function getWithdrawManagerAddress() public view returns (address) {
178         return contractMap[WITHDRAW_MANAGER];
179     }
180 
181     function getChildChainAndStateSender() public view returns (address, address) {
182         return (contractMap[CHILD_CHAIN], contractMap[STATE_SENDER]);
183     }
184 
185     function isTokenMapped(address _token) public view returns (bool) {
186         return rootToChildToken[_token] != address(0x0);
187     }
188 
189     function isTokenMappedAndIsErc721(address _token) public view returns (bool) {
190         require(isTokenMapped(_token), "TOKEN_NOT_MAPPED");
191         return isERC721[_token];
192     }
193 
194     function isTokenMappedAndGetPredicate(address _token) public view returns (address) {
195         if (isTokenMappedAndIsErc721(_token)) {
196             return erc721Predicate;
197         }
198         return erc20Predicate;
199     }
200 
201     function isChildTokenErc721(address childToken) public view returns (bool) {
202         address rootToken = childToRootToken[childToken];
203         require(rootToken != address(0x0), "Child token is not mapped");
204         return isERC721[rootToken];
205     }
206 }
207 
208 // File: solidity-rlp/contracts/RLPReader.sol
209 
210 /*
211 * @author Hamdi Allam hamdi.allam97@gmail.com
212 * Please reach out with any questions or concerns
213 */
214 pragma solidity ^0.5.0;
215 
216 library RLPReader {
217     uint8 constant STRING_SHORT_START = 0x80;
218     uint8 constant STRING_LONG_START  = 0xb8;
219     uint8 constant LIST_SHORT_START   = 0xc0;
220     uint8 constant LIST_LONG_START    = 0xf8;
221     uint8 constant WORD_SIZE = 32;
222 
223     struct RLPItem {
224         uint len;
225         uint memPtr;
226     }
227 
228     struct Iterator {
229         RLPItem item;   // Item that's being iterated over.
230         uint nextPtr;   // Position of the next item in the list.
231     }
232 
233     /*
234     * @dev Returns the next element in the iteration. Reverts if it has not next element.
235     * @param self The iterator.
236     * @return The next element in the iteration.
237     */
238     function next(Iterator memory self) internal pure returns (RLPItem memory) {
239         require(hasNext(self));
240 
241         uint ptr = self.nextPtr;
242         uint itemLength = _itemLength(ptr);
243         self.nextPtr = ptr + itemLength;
244 
245         return RLPItem(itemLength, ptr);
246     }
247 
248     /*
249     * @dev Returns true if the iteration has more elements.
250     * @param self The iterator.
251     * @return true if the iteration has more elements.
252     */
253     function hasNext(Iterator memory self) internal pure returns (bool) {
254         RLPItem memory item = self.item;
255         return self.nextPtr < item.memPtr + item.len;
256     }
257 
258     /*
259     * @param item RLP encoded bytes
260     */
261     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
262         uint memPtr;
263         assembly {
264             memPtr := add(item, 0x20)
265         }
266 
267         return RLPItem(item.length, memPtr);
268     }
269 
270     /*
271     * @dev Create an iterator. Reverts if item is not a list.
272     * @param self The RLP item.
273     * @return An 'Iterator' over the item.
274     */
275     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
276         require(isList(self));
277 
278         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
279         return Iterator(self, ptr);
280     }
281 
282     /*
283     * @param item RLP encoded bytes
284     */
285     function rlpLen(RLPItem memory item) internal pure returns (uint) {
286         return item.len;
287     }
288 
289     /*
290     * @param item RLP encoded bytes
291     */
292     function payloadLen(RLPItem memory item) internal pure returns (uint) {
293         return item.len - _payloadOffset(item.memPtr);
294     }
295 
296     /*
297     * @param item RLP encoded list in bytes
298     */
299     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
300         require(isList(item));
301 
302         uint items = numItems(item);
303         RLPItem[] memory result = new RLPItem[](items);
304 
305         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
306         uint dataLen;
307         for (uint i = 0; i < items; i++) {
308             dataLen = _itemLength(memPtr);
309             result[i] = RLPItem(dataLen, memPtr); 
310             memPtr = memPtr + dataLen;
311         }
312 
313         return result;
314     }
315 
316     // @return indicator whether encoded payload is a list. negate this function call for isData.
317     function isList(RLPItem memory item) internal pure returns (bool) {
318         if (item.len == 0) return false;
319 
320         uint8 byte0;
321         uint memPtr = item.memPtr;
322         assembly {
323             byte0 := byte(0, mload(memPtr))
324         }
325 
326         if (byte0 < LIST_SHORT_START)
327             return false;
328         return true;
329     }
330 
331     /** RLPItem conversions into data types **/
332 
333     // @returns raw rlp encoding in bytes
334     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
335         bytes memory result = new bytes(item.len);
336         if (result.length == 0) return result;
337         
338         uint ptr;
339         assembly {
340             ptr := add(0x20, result)
341         }
342 
343         copy(item.memPtr, ptr, item.len);
344         return result;
345     }
346 
347     // any non-zero byte is considered true
348     function toBoolean(RLPItem memory item) internal pure returns (bool) {
349         require(item.len == 1);
350         uint result;
351         uint memPtr = item.memPtr;
352         assembly {
353             result := byte(0, mload(memPtr))
354         }
355 
356         return result == 0 ? false : true;
357     }
358 
359     function toAddress(RLPItem memory item) internal pure returns (address) {
360         // 1 byte for the length prefix
361         require(item.len == 21);
362 
363         return address(toUint(item));
364     }
365 
366     function toUint(RLPItem memory item) internal pure returns (uint) {
367         require(item.len > 0 && item.len <= 33);
368 
369         uint offset = _payloadOffset(item.memPtr);
370         uint len = item.len - offset;
371 
372         uint result;
373         uint memPtr = item.memPtr + offset;
374         assembly {
375             result := mload(memPtr)
376 
377             // shfit to the correct location if neccesary
378             if lt(len, 32) {
379                 result := div(result, exp(256, sub(32, len)))
380             }
381         }
382 
383         return result;
384     }
385 
386     // enforces 32 byte length
387     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
388         // one byte prefix
389         require(item.len == 33);
390 
391         uint result;
392         uint memPtr = item.memPtr + 1;
393         assembly {
394             result := mload(memPtr)
395         }
396 
397         return result;
398     }
399 
400     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
401         require(item.len > 0);
402 
403         uint offset = _payloadOffset(item.memPtr);
404         uint len = item.len - offset; // data length
405         bytes memory result = new bytes(len);
406 
407         uint destPtr;
408         assembly {
409             destPtr := add(0x20, result)
410         }
411 
412         copy(item.memPtr + offset, destPtr, len);
413         return result;
414     }
415 
416     /*
417     * Private Helpers
418     */
419 
420     // @return number of payload items inside an encoded list.
421     function numItems(RLPItem memory item) private pure returns (uint) {
422         if (item.len == 0) return 0;
423 
424         uint count = 0;
425         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
426         uint endPtr = item.memPtr + item.len;
427         while (currPtr < endPtr) {
428            currPtr = currPtr + _itemLength(currPtr); // skip over an item
429            count++;
430         }
431 
432         return count;
433     }
434 
435     // @return entire rlp item byte length
436     function _itemLength(uint memPtr) private pure returns (uint) {
437         uint itemLen;
438         uint byte0;
439         assembly {
440             byte0 := byte(0, mload(memPtr))
441         }
442 
443         if (byte0 < STRING_SHORT_START)
444             itemLen = 1;
445         
446         else if (byte0 < STRING_LONG_START)
447             itemLen = byte0 - STRING_SHORT_START + 1;
448 
449         else if (byte0 < LIST_SHORT_START) {
450             assembly {
451                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
452                 memPtr := add(memPtr, 1) // skip over the first byte
453                 
454                 /* 32 byte word size */
455                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
456                 itemLen := add(dataLen, add(byteLen, 1))
457             }
458         }
459 
460         else if (byte0 < LIST_LONG_START) {
461             itemLen = byte0 - LIST_SHORT_START + 1;
462         } 
463 
464         else {
465             assembly {
466                 let byteLen := sub(byte0, 0xf7)
467                 memPtr := add(memPtr, 1)
468 
469                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
470                 itemLen := add(dataLen, add(byteLen, 1))
471             }
472         }
473 
474         return itemLen;
475     }
476 
477     // @return number of bytes until the data
478     function _payloadOffset(uint memPtr) private pure returns (uint) {
479         uint byte0;
480         assembly {
481             byte0 := byte(0, mload(memPtr))
482         }
483 
484         if (byte0 < STRING_SHORT_START) 
485             return 0;
486         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
487             return 1;
488         else if (byte0 < LIST_SHORT_START)  // being explicit
489             return byte0 - (STRING_LONG_START - 1) + 1;
490         else
491             return byte0 - (LIST_LONG_START - 1) + 1;
492     }
493 
494     /*
495     * @param src Pointer to source
496     * @param dest Pointer to destination
497     * @param len Amount of memory to copy from the source
498     */
499     function copy(uint src, uint dest, uint len) private pure {
500         if (len == 0) return;
501 
502         // copy as many word sizes as possible
503         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
504             assembly {
505                 mstore(dest, mload(src))
506             }
507 
508             src += WORD_SIZE;
509             dest += WORD_SIZE;
510         }
511 
512         // left over bytes. Mask is used to remove unwanted bytes from the word
513         uint mask = 256 ** (WORD_SIZE - len) - 1;
514         assembly {
515             let srcpart := and(mload(src), not(mask)) // zero out src
516             let destpart := and(mload(dest), mask) // retrieve the bytes
517             mstore(dest, or(destpart, srcpart))
518         }
519     }
520 }
521 
522 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
523 
524 pragma solidity ^0.5.2;
525 
526 /**
527  * @title SafeMath
528  * @dev Unsigned math operations with safety checks that revert on error
529  */
530 library SafeMath {
531     /**
532      * @dev Multiplies two unsigned integers, reverts on overflow.
533      */
534     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
535         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
536         // benefit is lost if 'b' is also tested.
537         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
538         if (a == 0) {
539             return 0;
540         }
541 
542         uint256 c = a * b;
543         require(c / a == b);
544 
545         return c;
546     }
547 
548     /**
549      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
550      */
551     function div(uint256 a, uint256 b) internal pure returns (uint256) {
552         // Solidity only automatically asserts when dividing by 0
553         require(b > 0);
554         uint256 c = a / b;
555         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
556 
557         return c;
558     }
559 
560     /**
561      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
562      */
563     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
564         require(b <= a);
565         uint256 c = a - b;
566 
567         return c;
568     }
569 
570     /**
571      * @dev Adds two unsigned integers, reverts on overflow.
572      */
573     function add(uint256 a, uint256 b) internal pure returns (uint256) {
574         uint256 c = a + b;
575         require(c >= a);
576 
577         return c;
578     }
579 
580     /**
581      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
582      * reverts when dividing by zero.
583      */
584     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
585         require(b != 0);
586         return a % b;
587     }
588 }
589 
590 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
591 
592 pragma solidity ^0.5.2;
593 
594 /**
595  * @title Ownable
596  * @dev The Ownable contract has an owner address, and provides basic authorization control
597  * functions, this simplifies the implementation of "user permissions".
598  */
599 contract Ownable {
600     address private _owner;
601 
602     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
603 
604     /**
605      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
606      * account.
607      */
608     constructor () internal {
609         _owner = msg.sender;
610         emit OwnershipTransferred(address(0), _owner);
611     }
612 
613     /**
614      * @return the address of the owner.
615      */
616     function owner() public view returns (address) {
617         return _owner;
618     }
619 
620     /**
621      * @dev Throws if called by any account other than the owner.
622      */
623     modifier onlyOwner() {
624         require(isOwner());
625         _;
626     }
627 
628     /**
629      * @return true if `msg.sender` is the owner of the contract.
630      */
631     function isOwner() public view returns (bool) {
632         return msg.sender == _owner;
633     }
634 
635     /**
636      * @dev Allows the current owner to relinquish control of the contract.
637      * It will not be possible to call the functions with the `onlyOwner`
638      * modifier anymore.
639      * @notice Renouncing ownership will leave the contract without an owner,
640      * thereby removing any functionality that is only available to the owner.
641      */
642     function renounceOwnership() public onlyOwner {
643         emit OwnershipTransferred(_owner, address(0));
644         _owner = address(0);
645     }
646 
647     /**
648      * @dev Allows the current owner to transfer control of the contract to a newOwner.
649      * @param newOwner The address to transfer ownership to.
650      */
651     function transferOwnership(address newOwner) public onlyOwner {
652         _transferOwnership(newOwner);
653     }
654 
655     /**
656      * @dev Transfers control of the contract to a newOwner.
657      * @param newOwner The address to transfer ownership to.
658      */
659     function _transferOwnership(address newOwner) internal {
660         require(newOwner != address(0));
661         emit OwnershipTransferred(_owner, newOwner);
662         _owner = newOwner;
663     }
664 }
665 
666 // File: contracts/common/misc/ProxyStorage.sol
667 
668 pragma solidity ^0.5.2;
669 
670 
671 contract ProxyStorage is Ownable {
672     address internal proxyTo;
673 }
674 
675 // File: contracts/common/mixin/ChainIdMixin.sol
676 
677 pragma solidity ^0.5.2;
678 
679 contract ChainIdMixin {
680   bytes constant public networkId = hex"89";
681   uint256 constant public CHAINID = 137;
682 }
683 
684 // File: contracts/root/RootChainStorage.sol
685 
686 pragma solidity ^0.5.2;
687 
688 
689 
690 
691 
692 contract RootChainHeader {
693     event NewHeaderBlock(
694         address indexed proposer,
695         uint256 indexed headerBlockId,
696         uint256 indexed reward,
697         uint256 start,
698         uint256 end,
699         bytes32 root
700     );
701     // housekeeping event
702     event ResetHeaderBlock(address indexed proposer, uint256 indexed headerBlockId);
703     struct HeaderBlock {
704         bytes32 root;
705         uint256 start;
706         uint256 end;
707         uint256 createdAt;
708         address proposer;
709     }
710 }
711 
712 
713 contract RootChainStorage is ProxyStorage, RootChainHeader, ChainIdMixin {
714     bytes32 public heimdallId;
715     uint8 public constant VOTE_TYPE = 2;
716 
717     uint16 internal constant MAX_DEPOSITS = 10000;
718     uint256 public _nextHeaderBlock = MAX_DEPOSITS;
719     uint256 internal _blockDepositId = 1;
720     mapping(uint256 => HeaderBlock) public headerBlocks;
721     Registry internal registry;
722 }
723 
724 // File: contracts/staking/stakeManager/IStakeManager.sol
725 
726 pragma solidity ^0.5.2;
727 
728 
729 contract IStakeManager {
730     // validator replacement
731     function startAuction(uint256 validatorId, uint256 amount) external;
732 
733     function confirmAuctionBid(
734         uint256 validatorId,
735         uint256 heimdallFee,
736         bool acceptDelegation,
737         bytes calldata signerPubkey
738     ) external;
739 
740     function transferFunds(
741         uint256 validatorId,
742         uint256 amount,
743         address delegator
744     ) external returns (bool);
745 
746     function delegationDeposit(
747         uint256 validatorId,
748         uint256 amount,
749         address delegator
750     ) external returns (bool);
751 
752     function stake(
753         uint256 amount,
754         uint256 heimdallFee,
755         bool acceptDelegation,
756         bytes calldata signerPubkey
757     ) external;
758 
759     function unstake(uint256 validatorId) external;
760 
761     function totalStakedFor(address addr) external view returns (uint256);
762 
763     function supportsHistory() external pure returns (bool);
764 
765     function stakeFor(
766         address user,
767         uint256 amount,
768         uint256 heimdallFee,
769         bool acceptDelegation,
770         bytes memory signerPubkey
771     ) public;
772 
773     function checkSignatures(
774         uint256 blockInterval,
775         bytes32 voteHash,
776         bytes32 stateRoot,
777         address proposer,
778         bytes memory sigs
779     ) public returns (uint256);
780 
781     function updateValidatorState(uint256 validatorId, int256 amount) public;
782 
783     function ownerOf(uint256 tokenId) public view returns (address);
784 
785     function slash(bytes memory slashingInfoList) public returns (uint256);
786 
787     function validatorStake(uint256 validatorId) public view returns (uint256);
788 
789     function epoch() public view returns (uint256);
790 
791     function withdrawalDelay() public view returns (uint256);
792 }
793 
794 // File: contracts/root/IRootChain.sol
795 
796 pragma solidity ^0.5.2;
797 
798 
799 interface IRootChain {
800     function slash() external;
801 
802     function submitHeaderBlock(bytes calldata data, bytes calldata sigs)
803         external;
804 
805     function getLastChildBlock() external view returns (uint256);
806 
807     function currentHeaderBlock() external view returns (uint256);
808 }
809 
810 // File: contracts/root/RootChain.sol
811 
812 pragma solidity ^0.5.2;
813 
814 
815 
816 
817 
818 
819 
820 
821 contract RootChain is RootChainStorage, IRootChain {
822     using SafeMath for uint256;
823     using RLPReader for bytes;
824     using RLPReader for RLPReader.RLPItem;
825 
826     modifier onlyDepositManager() {
827         require(msg.sender == registry.getDepositManagerAddress(), "UNAUTHORIZED_DEPOSIT_MANAGER_ONLY");
828         _;
829     }
830 
831     function submitHeaderBlock(bytes calldata data, bytes calldata sigs) external {
832         (address proposer, uint256 start, uint256 end, bytes32 rootHash, bytes32 accountHash, uint256 _borChainID) = abi
833             .decode(data, (address, uint256, uint256, bytes32, bytes32, uint256));
834         require(CHAINID == _borChainID, "Invalid bor chain id");
835 
836         require(_buildHeaderBlock(proposer, start, end, rootHash), "INCORRECT_HEADER_DATA");
837 
838         // check if it is better to keep it in local storage instead
839         IStakeManager stakeManager = IStakeManager(registry.getStakeManagerAddress());
840         uint256 _reward = stakeManager.checkSignatures(
841             end.sub(start).add(1),
842             /**  
843                 prefix 01 to data 
844                 01 represents positive vote on data and 00 is negative vote
845                 malicious validator can try to send 2/3 on negative vote so 01 is appended
846              */
847             keccak256(abi.encodePacked(bytes(hex"01"), data)),
848             accountHash,
849             proposer,
850             sigs
851         );
852 
853         require(_reward != 0, "Invalid checkpoint");
854         emit NewHeaderBlock(proposer, _nextHeaderBlock, _reward, start, end, rootHash);
855         _nextHeaderBlock = _nextHeaderBlock.add(MAX_DEPOSITS);
856         _blockDepositId = 1;
857     }
858 
859     function updateDepositId(uint256 numDeposits) external onlyDepositManager returns (uint256 depositId) {
860         depositId = currentHeaderBlock().add(_blockDepositId);
861         // deposit ids will be (_blockDepositId, _blockDepositId + 1, .... _blockDepositId + numDeposits - 1)
862         _blockDepositId = _blockDepositId.add(numDeposits);
863         require(
864             // Since _blockDepositId is initialized to 1; only (MAX_DEPOSITS - 1) deposits per header block are allowed
865             _blockDepositId <= MAX_DEPOSITS,
866             "TOO_MANY_DEPOSITS"
867         );
868     }
869 
870     function getLastChildBlock() external view returns (uint256) {
871         return headerBlocks[currentHeaderBlock()].end;
872     }
873 
874     function slash() external {
875         //TODO: future implementation
876     }
877 
878     function currentHeaderBlock() public view returns (uint256) {
879         return _nextHeaderBlock.sub(MAX_DEPOSITS);
880     }
881 
882     function _buildHeaderBlock(
883         address proposer,
884         uint256 start,
885         uint256 end,
886         bytes32 rootHash
887     ) private returns (bool) {
888         uint256 nextChildBlock;
889         /*
890     The ID of the 1st header block is MAX_DEPOSITS.
891     if _nextHeaderBlock == MAX_DEPOSITS, then the first header block is yet to be submitted, hence nextChildBlock = 0
892     */
893         if (_nextHeaderBlock > MAX_DEPOSITS) {
894             nextChildBlock = headerBlocks[currentHeaderBlock()].end + 1;
895         }
896         if (nextChildBlock != start) {
897             return false;
898         }
899 
900         HeaderBlock memory headerBlock = HeaderBlock({
901             root: rootHash,
902             start: nextChildBlock,
903             end: end,
904             createdAt: now,
905             proposer: proposer
906         });
907 
908         headerBlocks[_nextHeaderBlock] = headerBlock;
909         return true;
910     }
911 
912     // Housekeeping function. @todo remove later
913     function setNextHeaderBlock(uint256 _value) public onlyOwner {
914         require(_value % MAX_DEPOSITS == 0, "Invalid value");
915         for (uint256 i = _value; i < _nextHeaderBlock; i += MAX_DEPOSITS) {
916             delete headerBlocks[i];
917         }
918         _nextHeaderBlock = _value;
919         _blockDepositId = 1;
920         emit ResetHeaderBlock(msg.sender, _nextHeaderBlock);
921     }
922 
923     // Housekeeping function. @todo remove later
924     function setHeimdallId(string memory _heimdallId) public onlyOwner {
925         heimdallId = keccak256(abi.encodePacked(_heimdallId));
926     }
927 }
928 
929 // File: contracts/root/stateSyncer/StateSender.sol
930 
931 pragma solidity ^0.5.2;
932 
933 
934 
935 contract StateSender is Ownable {
936     using SafeMath for uint256;
937 
938     uint256 public counter;
939     mapping(address => address) public registrations;
940 
941     event NewRegistration(
942         address indexed user,
943         address indexed sender,
944         address indexed receiver
945     );
946     event RegistrationUpdated(
947         address indexed user,
948         address indexed sender,
949         address indexed receiver
950     );
951     event StateSynced(
952         uint256 indexed id,
953         address indexed contractAddress,
954         bytes data
955     );
956 
957     modifier onlyRegistered(address receiver) {
958         require(registrations[receiver] == msg.sender, "Invalid sender");
959         _;
960     }
961 
962     function syncState(address receiver, bytes calldata data)
963         external
964         onlyRegistered(receiver)
965     {
966         counter = counter.add(1);
967         emit StateSynced(counter, receiver, data);
968     }
969 
970     // register new contract for state sync
971     function register(address sender, address receiver) public {
972         require(
973             isOwner() || registrations[receiver] == msg.sender,
974             "StateSender.register: Not authorized to register"
975         );
976         registrations[receiver] = sender;
977         if (registrations[receiver] == address(0)) {
978             emit NewRegistration(msg.sender, sender, receiver);
979         } else {
980             emit RegistrationUpdated(msg.sender, sender, receiver);
981         }
982     }
983 }
984 
985 // File: contracts/common/mixin/Lockable.sol
986 
987 pragma solidity ^0.5.2;
988 
989 
990 contract Lockable is Governable {
991     bool public locked;
992 
993     modifier onlyWhenUnlocked() {
994         require(!locked, "Is Locked");
995         _;
996     }
997 
998     constructor(address _governance) public Governable(_governance) {}
999 
1000     function lock() external onlyGovernance {
1001         locked = true;
1002     }
1003 
1004     function unlock() external onlyGovernance {
1005         locked = false;
1006     }
1007 }
1008 
1009 // File: contracts/root/depositManager/DepositManagerStorage.sol
1010 
1011 pragma solidity ^0.5.2;
1012 
1013 
1014 
1015 
1016 
1017 
1018 
1019 contract DepositManagerHeader {
1020     event NewDepositBlock(address indexed owner, address indexed token, uint256 amountOrNFTId, uint256 depositBlockId);
1021     event MaxErc20DepositUpdate(uint256 indexed oldLimit, uint256 indexed newLimit);
1022 
1023     struct DepositBlock {
1024         bytes32 depositHash;
1025         uint256 createdAt;
1026     }
1027 }
1028 
1029 
1030 contract DepositManagerStorage is ProxyStorage, Lockable, DepositManagerHeader {
1031     Registry public registry;
1032     RootChain public rootChain;
1033     StateSender public stateSender;
1034 
1035     mapping(uint256 => DepositBlock) public deposits;
1036 
1037     address public childChain;
1038     uint256 public maxErc20Deposit = 100 * (10**18);
1039 }
1040 
1041 // File: contracts/common/misc/ERCProxy.sol
1042 
1043 /*
1044  * SPDX-License-Identitifer:    MIT
1045  */
1046 
1047 pragma solidity ^0.5.2;
1048 
1049 // See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-897.md
1050 
1051 interface ERCProxy {
1052     function proxyType() external pure returns (uint256 proxyTypeId);
1053     function implementation() external view returns (address codeAddr);
1054 }
1055 
1056 // File: contracts/common/misc/DelegateProxy.sol
1057 
1058 pragma solidity ^0.5.2;
1059 
1060 
1061 
1062 contract DelegateProxy is ERCProxy {
1063     function proxyType() external pure returns (uint256 proxyTypeId) {
1064         // Upgradeable proxy
1065         proxyTypeId = 2;
1066     }
1067 
1068     function implementation() external view returns (address);
1069 
1070     function delegatedFwd(address _dst, bytes memory _calldata) internal {
1071         // solium-disable-next-line security/no-inline-assembly
1072         assembly {
1073             let result := delegatecall(
1074                 sub(gas, 10000),
1075                 _dst,
1076                 add(_calldata, 0x20),
1077                 mload(_calldata),
1078                 0,
1079                 0
1080             )
1081             let size := returndatasize
1082 
1083             let ptr := mload(0x40)
1084             returndatacopy(ptr, 0, size)
1085 
1086             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
1087             // if the call returned error data, forward it
1088             switch result
1089                 case 0 {
1090                     revert(ptr, size)
1091                 }
1092                 default {
1093                     return(ptr, size)
1094                 }
1095         }
1096     }
1097 }
1098 
1099 // File: contracts/common/misc/Proxy.sol
1100 
1101 pragma solidity ^0.5.2;
1102 
1103 
1104 
1105 
1106 contract Proxy is ProxyStorage, DelegateProxy {
1107     event ProxyUpdated(address indexed _new, address indexed _old);
1108     event OwnerUpdate(address _prevOwner, address _newOwner);
1109 
1110     constructor(address _proxyTo) public {
1111         updateImplementation(_proxyTo);
1112     }
1113 
1114     function() external payable {
1115         // require(currentContract != 0, "If app code has not been set yet, do not call");
1116         // Todo: filter out some calls or handle in the end fallback
1117         delegatedFwd(proxyTo, msg.data);
1118     }
1119 
1120     function implementation() external view returns (address) {
1121         return proxyTo;
1122     }
1123 
1124     function updateImplementation(address _newProxyTo) public onlyOwner {
1125         require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
1126         require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
1127         emit ProxyUpdated(_newProxyTo, proxyTo);
1128         proxyTo = _newProxyTo;
1129     }
1130 
1131     function isContract(address _target) internal view returns (bool) {
1132         if (_target == address(0)) {
1133             return false;
1134         }
1135 
1136         uint256 size;
1137         assembly {
1138             size := extcodesize(_target)
1139         }
1140         return size > 0;
1141     }
1142 }
1143 
1144 // File: contracts/root/depositManager/DepositManagerProxy.sol
1145 
1146 pragma solidity ^0.5.2;
1147 
1148 
1149 
1150 
1151 
1152 
1153 contract DepositManagerProxy is Proxy, DepositManagerStorage {
1154     constructor(
1155         address _proxyTo,
1156         address _registry,
1157         address _rootChain,
1158         address _governance
1159     ) public Proxy(_proxyTo) Lockable(_governance) {
1160         registry = Registry(_registry);
1161         rootChain = RootChain(_rootChain);
1162     }
1163 }