1 pragma solidity ^0.5.2;
2 
3 
4 interface IGovernance {
5     function update(address target, bytes calldata data) external;
6 }
7 
8 
9 
10 contract Governable {
11     IGovernance public governance;
12 
13     constructor(address _governance) public {
14         governance = IGovernance(_governance);
15     }
16 
17     modifier onlyGovernance() {
18         _assertGovernance();
19         _;
20     }
21 
22     function _assertGovernance() private view {
23         require(
24             msg.sender == address(governance),
25             "Only governance contract is authorized"
26         );
27     }
28 }
29 
30 
31 
32 contract IWithdrawManager {
33     function createExitQueue(address token) external;
34 
35     function verifyInclusion(
36         bytes calldata data,
37         uint8 offset,
38         bool verifyTxInclusion
39     ) external view returns (uint256 age);
40 
41     function addExitToQueue(
42         address exitor,
43         address childToken,
44         address rootToken,
45         uint256 exitAmountOrTokenId,
46         bytes32 txHash,
47         bool isRegularExit,
48         uint256 priority
49     ) external;
50 
51     function addInput(
52         uint256 exitId,
53         uint256 age,
54         address utxoOwner,
55         address token
56     ) external;
57 
58     function challengeExit(
59         uint256 exitId,
60         uint256 inputId,
61         bytes calldata challengeData,
62         address adjudicatorPredicate
63     ) external;
64 }
65 
66 
67 
68 
69 contract Registry is Governable {
70     // @todo hardcode constants
71     bytes32 private constant WETH_TOKEN = keccak256("wethToken");
72     bytes32 private constant DEPOSIT_MANAGER = keccak256("depositManager");
73     bytes32 private constant STAKE_MANAGER = keccak256("stakeManager");
74     bytes32 private constant VALIDATOR_SHARE = keccak256("validatorShare");
75     bytes32 private constant WITHDRAW_MANAGER = keccak256("withdrawManager");
76     bytes32 private constant CHILD_CHAIN = keccak256("childChain");
77     bytes32 private constant STATE_SENDER = keccak256("stateSender");
78     bytes32 private constant SLASHING_MANAGER = keccak256("slashingManager");
79 
80     address public erc20Predicate;
81     address public erc721Predicate;
82 
83     mapping(bytes32 => address) public contractMap;
84     mapping(address => address) public rootToChildToken;
85     mapping(address => address) public childToRootToken;
86     mapping(address => bool) public proofValidatorContracts;
87     mapping(address => bool) public isERC721;
88 
89     enum Type {Invalid, ERC20, ERC721, Custom}
90     struct Predicate {
91         Type _type;
92     }
93     mapping(address => Predicate) public predicates;
94 
95     event TokenMapped(address indexed rootToken, address indexed childToken);
96     event ProofValidatorAdded(address indexed validator, address indexed from);
97     event ProofValidatorRemoved(address indexed validator, address indexed from);
98     event PredicateAdded(address indexed predicate, address indexed from);
99     event PredicateRemoved(address indexed predicate, address indexed from);
100     event ContractMapUpdated(bytes32 indexed key, address indexed previousContract, address indexed newContract);
101 
102     constructor(address _governance) public Governable(_governance) {}
103 
104     function updateContractMap(bytes32 _key, address _address) external onlyGovernance {
105         emit ContractMapUpdated(_key, contractMap[_key], _address);
106         contractMap[_key] = _address;
107     }
108 
109     /**
110      * @dev Map root token to child token
111      * @param _rootToken Token address on the root chain
112      * @param _childToken Token address on the child chain
113      * @param _isERC721 Is the token being mapped ERC721
114      */
115     function mapToken(
116         address _rootToken,
117         address _childToken,
118         bool _isERC721
119     ) external onlyGovernance {
120         require(_rootToken != address(0x0) && _childToken != address(0x0), "INVALID_TOKEN_ADDRESS");
121         rootToChildToken[_rootToken] = _childToken;
122         childToRootToken[_childToken] = _rootToken;
123         isERC721[_rootToken] = _isERC721;
124         IWithdrawManager(contractMap[WITHDRAW_MANAGER]).createExitQueue(_rootToken);
125         emit TokenMapped(_rootToken, _childToken);
126     }
127 
128     function addErc20Predicate(address predicate) public onlyGovernance {
129         require(predicate != address(0x0), "Can not add null address as predicate");
130         erc20Predicate = predicate;
131         addPredicate(predicate, Type.ERC20);
132     }
133 
134     function addErc721Predicate(address predicate) public onlyGovernance {
135         erc721Predicate = predicate;
136         addPredicate(predicate, Type.ERC721);
137     }
138 
139     function addPredicate(address predicate, Type _type) public onlyGovernance {
140         require(predicates[predicate]._type == Type.Invalid, "Predicate already added");
141         predicates[predicate]._type = _type;
142         emit PredicateAdded(predicate, msg.sender);
143     }
144 
145     function removePredicate(address predicate) public onlyGovernance {
146         require(predicates[predicate]._type != Type.Invalid, "Predicate does not exist");
147         delete predicates[predicate];
148         emit PredicateRemoved(predicate, msg.sender);
149     }
150 
151     function getValidatorShareAddress() public view returns (address) {
152         return contractMap[VALIDATOR_SHARE];
153     }
154 
155     function getWethTokenAddress() public view returns (address) {
156         return contractMap[WETH_TOKEN];
157     }
158 
159     function getDepositManagerAddress() public view returns (address) {
160         return contractMap[DEPOSIT_MANAGER];
161     }
162 
163     function getStakeManagerAddress() public view returns (address) {
164         return contractMap[STAKE_MANAGER];
165     }
166 
167     function getSlashingManagerAddress() public view returns (address) {
168         return contractMap[SLASHING_MANAGER];
169     }
170 
171     function getWithdrawManagerAddress() public view returns (address) {
172         return contractMap[WITHDRAW_MANAGER];
173     }
174 
175     function getChildChainAndStateSender() public view returns (address, address) {
176         return (contractMap[CHILD_CHAIN], contractMap[STATE_SENDER]);
177     }
178 
179     function isTokenMapped(address _token) public view returns (bool) {
180         return rootToChildToken[_token] != address(0x0);
181     }
182 
183     function isTokenMappedAndIsErc721(address _token) public view returns (bool) {
184         require(isTokenMapped(_token), "TOKEN_NOT_MAPPED");
185         return isERC721[_token];
186     }
187 
188     function isTokenMappedAndGetPredicate(address _token) public view returns (address) {
189         if (isTokenMappedAndIsErc721(_token)) {
190             return erc721Predicate;
191         }
192         return erc20Predicate;
193     }
194 
195     function isChildTokenErc721(address childToken) public view returns (bool) {
196         address rootToken = childToRootToken[childToken];
197         require(rootToken != address(0x0), "Child token is not mapped");
198         return isERC721[rootToken];
199     }
200 }
201 
202 
203 /*
204 * @author Hamdi Allam hamdi.allam97@gmail.com
205 * Please reach out with any questions or concerns
206 */
207 
208 library RLPReader {
209     uint8 constant STRING_SHORT_START = 0x80;
210     uint8 constant STRING_LONG_START  = 0xb8;
211     uint8 constant LIST_SHORT_START   = 0xc0;
212     uint8 constant LIST_LONG_START    = 0xf8;
213     uint8 constant WORD_SIZE = 32;
214 
215     struct RLPItem {
216         uint len;
217         uint memPtr;
218     }
219 
220     struct Iterator {
221         RLPItem item;   // Item that's being iterated over.
222         uint nextPtr;   // Position of the next item in the list.
223     }
224 
225     /*
226     * @dev Returns the next element in the iteration. Reverts if it has not next element.
227     * @param self The iterator.
228     * @return The next element in the iteration.
229     */
230     function next(Iterator memory self) internal pure returns (RLPItem memory) {
231         require(hasNext(self));
232 
233         uint ptr = self.nextPtr;
234         uint itemLength = _itemLength(ptr);
235         self.nextPtr = ptr + itemLength;
236 
237         return RLPItem(itemLength, ptr);
238     }
239 
240     /*
241     * @dev Returns true if the iteration has more elements.
242     * @param self The iterator.
243     * @return true if the iteration has more elements.
244     */
245     function hasNext(Iterator memory self) internal pure returns (bool) {
246         RLPItem memory item = self.item;
247         return self.nextPtr < item.memPtr + item.len;
248     }
249 
250     /*
251     * @param item RLP encoded bytes
252     */
253     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
254         uint memPtr;
255         assembly {
256             memPtr := add(item, 0x20)
257         }
258 
259         return RLPItem(item.length, memPtr);
260     }
261 
262     /*
263     * @dev Create an iterator. Reverts if item is not a list.
264     * @param self The RLP item.
265     * @return An 'Iterator' over the item.
266     */
267     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
268         require(isList(self));
269 
270         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
271         return Iterator(self, ptr);
272     }
273 
274     /*
275     * @param item RLP encoded bytes
276     */
277     function rlpLen(RLPItem memory item) internal pure returns (uint) {
278         return item.len;
279     }
280 
281     /*
282     * @param item RLP encoded bytes
283     */
284     function payloadLen(RLPItem memory item) internal pure returns (uint) {
285         return item.len - _payloadOffset(item.memPtr);
286     }
287 
288     /*
289     * @param item RLP encoded list in bytes
290     */
291     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
292         require(isList(item));
293 
294         uint items = numItems(item);
295         RLPItem[] memory result = new RLPItem[](items);
296 
297         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
298         uint dataLen;
299         for (uint i = 0; i < items; i++) {
300             dataLen = _itemLength(memPtr);
301             result[i] = RLPItem(dataLen, memPtr); 
302             memPtr = memPtr + dataLen;
303         }
304 
305         return result;
306     }
307 
308     // @return indicator whether encoded payload is a list. negate this function call for isData.
309     function isList(RLPItem memory item) internal pure returns (bool) {
310         if (item.len == 0) return false;
311 
312         uint8 byte0;
313         uint memPtr = item.memPtr;
314         assembly {
315             byte0 := byte(0, mload(memPtr))
316         }
317 
318         if (byte0 < LIST_SHORT_START)
319             return false;
320         return true;
321     }
322 
323     /** RLPItem conversions into data types **/
324 
325     // @returns raw rlp encoding in bytes
326     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
327         bytes memory result = new bytes(item.len);
328         if (result.length == 0) return result;
329         
330         uint ptr;
331         assembly {
332             ptr := add(0x20, result)
333         }
334 
335         copy(item.memPtr, ptr, item.len);
336         return result;
337     }
338 
339     // any non-zero byte is considered true
340     function toBoolean(RLPItem memory item) internal pure returns (bool) {
341         require(item.len == 1);
342         uint result;
343         uint memPtr = item.memPtr;
344         assembly {
345             result := byte(0, mload(memPtr))
346         }
347 
348         return result == 0 ? false : true;
349     }
350 
351     function toAddress(RLPItem memory item) internal pure returns (address) {
352         // 1 byte for the length prefix
353         require(item.len == 21);
354 
355         return address(toUint(item));
356     }
357 
358     function toUint(RLPItem memory item) internal pure returns (uint) {
359         require(item.len > 0 && item.len <= 33);
360 
361         uint offset = _payloadOffset(item.memPtr);
362         uint len = item.len - offset;
363 
364         uint result;
365         uint memPtr = item.memPtr + offset;
366         assembly {
367             result := mload(memPtr)
368 
369             // shfit to the correct location if neccesary
370             if lt(len, 32) {
371                 result := div(result, exp(256, sub(32, len)))
372             }
373         }
374 
375         return result;
376     }
377 
378     // enforces 32 byte length
379     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
380         // one byte prefix
381         require(item.len == 33);
382 
383         uint result;
384         uint memPtr = item.memPtr + 1;
385         assembly {
386             result := mload(memPtr)
387         }
388 
389         return result;
390     }
391 
392     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
393         require(item.len > 0);
394 
395         uint offset = _payloadOffset(item.memPtr);
396         uint len = item.len - offset; // data length
397         bytes memory result = new bytes(len);
398 
399         uint destPtr;
400         assembly {
401             destPtr := add(0x20, result)
402         }
403 
404         copy(item.memPtr + offset, destPtr, len);
405         return result;
406     }
407 
408     /*
409     * Private Helpers
410     */
411 
412     // @return number of payload items inside an encoded list.
413     function numItems(RLPItem memory item) private pure returns (uint) {
414         if (item.len == 0) return 0;
415 
416         uint count = 0;
417         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
418         uint endPtr = item.memPtr + item.len;
419         while (currPtr < endPtr) {
420            currPtr = currPtr + _itemLength(currPtr); // skip over an item
421            count++;
422         }
423 
424         return count;
425     }
426 
427     // @return entire rlp item byte length
428     function _itemLength(uint memPtr) private pure returns (uint) {
429         uint itemLen;
430         uint byte0;
431         assembly {
432             byte0 := byte(0, mload(memPtr))
433         }
434 
435         if (byte0 < STRING_SHORT_START)
436             itemLen = 1;
437         
438         else if (byte0 < STRING_LONG_START)
439             itemLen = byte0 - STRING_SHORT_START + 1;
440 
441         else if (byte0 < LIST_SHORT_START) {
442             assembly {
443                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
444                 memPtr := add(memPtr, 1) // skip over the first byte
445                 
446                 /* 32 byte word size */
447                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
448                 itemLen := add(dataLen, add(byteLen, 1))
449             }
450         }
451 
452         else if (byte0 < LIST_LONG_START) {
453             itemLen = byte0 - LIST_SHORT_START + 1;
454         } 
455 
456         else {
457             assembly {
458                 let byteLen := sub(byte0, 0xf7)
459                 memPtr := add(memPtr, 1)
460 
461                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
462                 itemLen := add(dataLen, add(byteLen, 1))
463             }
464         }
465 
466         return itemLen;
467     }
468 
469     // @return number of bytes until the data
470     function _payloadOffset(uint memPtr) private pure returns (uint) {
471         uint byte0;
472         assembly {
473             byte0 := byte(0, mload(memPtr))
474         }
475 
476         if (byte0 < STRING_SHORT_START) 
477             return 0;
478         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
479             return 1;
480         else if (byte0 < LIST_SHORT_START)  // being explicit
481             return byte0 - (STRING_LONG_START - 1) + 1;
482         else
483             return byte0 - (LIST_LONG_START - 1) + 1;
484     }
485 
486     /*
487     * @param src Pointer to source
488     * @param dest Pointer to destination
489     * @param len Amount of memory to copy from the source
490     */
491     function copy(uint src, uint dest, uint len) private pure {
492         if (len == 0) return;
493 
494         // copy as many word sizes as possible
495         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
496             assembly {
497                 mstore(dest, mload(src))
498             }
499 
500             src += WORD_SIZE;
501             dest += WORD_SIZE;
502         }
503 
504         // left over bytes. Mask is used to remove unwanted bytes from the word
505         uint mask = 256 ** (WORD_SIZE - len) - 1;
506         assembly {
507             let srcpart := and(mload(src), not(mask)) // zero out src
508             let destpart := and(mload(dest), mask) // retrieve the bytes
509             mstore(dest, or(destpart, srcpart))
510         }
511     }
512 }
513 
514 
515 
516 /**
517  * @title SafeMath
518  * @dev Unsigned math operations with safety checks that revert on error
519  */
520 library SafeMath {
521     /**
522      * @dev Multiplies two unsigned integers, reverts on overflow.
523      */
524     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
525         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
526         // benefit is lost if 'b' is also tested.
527         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
528         if (a == 0) {
529             return 0;
530         }
531 
532         uint256 c = a * b;
533         require(c / a == b);
534 
535         return c;
536     }
537 
538     /**
539      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
540      */
541     function div(uint256 a, uint256 b) internal pure returns (uint256) {
542         // Solidity only automatically asserts when dividing by 0
543         require(b > 0);
544         uint256 c = a / b;
545         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
546 
547         return c;
548     }
549 
550     /**
551      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
552      */
553     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
554         require(b <= a);
555         uint256 c = a - b;
556 
557         return c;
558     }
559 
560     /**
561      * @dev Adds two unsigned integers, reverts on overflow.
562      */
563     function add(uint256 a, uint256 b) internal pure returns (uint256) {
564         uint256 c = a + b;
565         require(c >= a);
566 
567         return c;
568     }
569 
570     /**
571      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
572      * reverts when dividing by zero.
573      */
574     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
575         require(b != 0);
576         return a % b;
577     }
578 }
579 
580 
581 
582 /**
583  * @title Ownable
584  * @dev The Ownable contract has an owner address, and provides basic authorization control
585  * functions, this simplifies the implementation of "user permissions".
586  */
587 contract Ownable {
588     address private _owner;
589 
590     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
591 
592     /**
593      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
594      * account.
595      */
596     constructor () internal {
597         _owner = msg.sender;
598         emit OwnershipTransferred(address(0), _owner);
599     }
600 
601     /**
602      * @return the address of the owner.
603      */
604     function owner() public view returns (address) {
605         return _owner;
606     }
607 
608     /**
609      * @dev Throws if called by any account other than the owner.
610      */
611     modifier onlyOwner() {
612         require(isOwner());
613         _;
614     }
615 
616     /**
617      * @return true if `msg.sender` is the owner of the contract.
618      */
619     function isOwner() public view returns (bool) {
620         return msg.sender == _owner;
621     }
622 
623     /**
624      * @dev Allows the current owner to relinquish control of the contract.
625      * It will not be possible to call the functions with the `onlyOwner`
626      * modifier anymore.
627      * @notice Renouncing ownership will leave the contract without an owner,
628      * thereby removing any functionality that is only available to the owner.
629      */
630     function renounceOwnership() public onlyOwner {
631         emit OwnershipTransferred(_owner, address(0));
632         _owner = address(0);
633     }
634 
635     /**
636      * @dev Allows the current owner to transfer control of the contract to a newOwner.
637      * @param newOwner The address to transfer ownership to.
638      */
639     function transferOwnership(address newOwner) public onlyOwner {
640         _transferOwnership(newOwner);
641     }
642 
643     /**
644      * @dev Transfers control of the contract to a newOwner.
645      * @param newOwner The address to transfer ownership to.
646      */
647     function _transferOwnership(address newOwner) internal {
648         require(newOwner != address(0));
649         emit OwnershipTransferred(_owner, newOwner);
650         _owner = newOwner;
651     }
652 }
653 
654 
655 
656 contract ProxyStorage is Ownable {
657     address internal proxyTo;
658 }
659 
660 
661 
662 contract ChainIdMixin {
663   bytes constant public networkId = hex"6D";
664   uint256 constant public CHAINID = 109;
665 }
666 
667 
668 
669 
670 
671 contract RootChainHeader {
672     event NewHeaderBlock(
673         address indexed proposer,
674         uint256 indexed headerBlockId,
675         uint256 indexed reward,
676         uint256 start,
677         uint256 end,
678         bytes32 root
679     );
680     // housekeeping event
681     event ResetHeaderBlock(address indexed proposer, uint256 indexed headerBlockId);
682     struct HeaderBlock {
683         bytes32 root;
684         uint256 start;
685         uint256 end;
686         uint256 createdAt;
687         address proposer;
688     }
689 }
690 
691 
692 contract RootChainStorage is ProxyStorage, RootChainHeader, ChainIdMixin {
693     bytes32 public heimdallId;
694     uint8 public constant VOTE_TYPE = 2;
695 
696     uint16 internal constant MAX_DEPOSITS = 10000;
697     uint256 public _nextHeaderBlock = MAX_DEPOSITS;
698     uint256 internal _blockDepositId = 1;
699     mapping(uint256 => HeaderBlock) public headerBlocks;
700     Registry internal registry;
701 }
702 
703 
704 
705 contract IStakeManager {
706     // validator replacement
707     function startAuction(
708         uint256 validatorId,
709         uint256 amount,
710         bool acceptDelegation,
711         bytes calldata signerPubkey
712     ) external;
713 
714     function confirmAuctionBid(uint256 validatorId, uint256 heimdallFee) external;
715 
716     function transferFunds(
717         uint256 validatorId,
718         uint256 amount,
719         address delegator
720     ) external returns (bool);
721 
722     function delegationDeposit(
723         uint256 validatorId,
724         uint256 amount,
725         address delegator
726     ) external returns (bool);
727 
728     function unstake(uint256 validatorId) external;
729 
730     function totalStakedFor(address addr) external view returns (uint256);
731 
732     function stakeFor(
733         address user,
734         uint256 amount,
735         uint256 heimdallFee,
736         bool acceptDelegation,
737         bytes memory signerPubkey
738     ) public;
739 
740     function checkSignatures(
741         uint256 blockInterval,
742         bytes32 voteHash,
743         bytes32 stateRoot,
744         address proposer,
745         uint[3][] calldata sigs
746     ) external returns (uint256);
747 
748     function updateValidatorState(uint256 validatorId, int256 amount) public;
749 
750     function ownerOf(uint256 tokenId) public view returns (address);
751 
752     function slash(bytes calldata slashingInfoList) external returns (uint256);
753 
754     function validatorStake(uint256 validatorId) public view returns (uint256);
755 
756     function epoch() public view returns (uint256);
757 
758     function getRegistry() public view returns (address);
759 
760     function withdrawalDelay() public view returns (uint256);
761 
762     function delegatedAmount(uint256 validatorId) public view returns(uint256);
763 
764     function decreaseValidatorDelegatedAmount(uint256 validatorId, uint256 amount) public;
765 
766     function withdrawDelegatorsReward(uint256 validatorId) public returns(uint256);
767 
768     function delegatorsReward(uint256 validatorId) public view returns(uint256);
769 
770     function dethroneAndStake(
771         address auctionUser,
772         uint256 heimdallFee,
773         uint256 validatorId,
774         uint256 auctionAmount,
775         bool acceptDelegation,
776         bytes calldata signerPubkey
777     ) external;
778 }
779 
780 
781 
782 
783 interface IRootChain {
784     function slash() external;
785 
786     function submitHeaderBlock(bytes calldata data, bytes calldata sigs)
787         external;
788     
789     function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs)
790         external;
791 
792     function getLastChildBlock() external view returns (uint256);
793 
794     function currentHeaderBlock() external view returns (uint256);
795 }
796 
797 
798 
799 
800 
801 
802 contract RootChain is RootChainStorage, IRootChain {
803     using SafeMath for uint256;
804     using RLPReader for bytes;
805     using RLPReader for RLPReader.RLPItem;
806 
807     modifier onlyDepositManager() {
808         require(msg.sender == registry.getDepositManagerAddress(), "UNAUTHORIZED_DEPOSIT_MANAGER_ONLY");
809         _;
810     }
811 
812     function submitHeaderBlock(bytes calldata data, bytes calldata sigs) external {
813         revert();
814     }
815 
816     function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs) external {
817         (address proposer, uint256 start, uint256 end, bytes32 rootHash, bytes32 accountHash, uint256 _borChainID) = abi
818             .decode(data, (address, uint256, uint256, bytes32, bytes32, uint256));
819         require(CHAINID == _borChainID, "Invalid bor chain id");
820 
821         require(_buildHeaderBlock(proposer, start, end, rootHash), "INCORRECT_HEADER_DATA");
822 
823         // check if it is better to keep it in local storage instead
824         IStakeManager stakeManager = IStakeManager(registry.getStakeManagerAddress());
825         uint256 _reward = stakeManager.checkSignatures(
826             end.sub(start).add(1),
827             /**  
828                 prefix 01 to data 
829                 01 represents positive vote on data and 00 is negative vote
830                 malicious validator can try to send 2/3 on negative vote so 01 is appended
831              */
832             keccak256(abi.encodePacked(bytes(hex"01"), data)),
833             accountHash,
834             proposer,
835             sigs
836         );
837 
838         require(_reward != 0, "Invalid checkpoint");
839         emit NewHeaderBlock(proposer, _nextHeaderBlock, _reward, start, end, rootHash);
840         _nextHeaderBlock = _nextHeaderBlock.add(MAX_DEPOSITS);
841         _blockDepositId = 1;
842     }
843 
844     function updateDepositId(uint256 numDeposits) external onlyDepositManager returns (uint256 depositId) {
845         depositId = currentHeaderBlock().add(_blockDepositId);
846         // deposit ids will be (_blockDepositId, _blockDepositId + 1, .... _blockDepositId + numDeposits - 1)
847         _blockDepositId = _blockDepositId.add(numDeposits);
848         require(
849             // Since _blockDepositId is initialized to 1; only (MAX_DEPOSITS - 1) deposits per header block are allowed
850             _blockDepositId <= MAX_DEPOSITS,
851             "TOO_MANY_DEPOSITS"
852         );
853     }
854 
855     function getLastChildBlock() external view returns (uint256) {
856         return headerBlocks[currentHeaderBlock()].end;
857     }
858 
859     function slash() external {
860         //TODO: future implementation
861     }
862 
863     function currentHeaderBlock() public view returns (uint256) {
864         return _nextHeaderBlock.sub(MAX_DEPOSITS);
865     }
866 
867     function _buildHeaderBlock(
868         address proposer,
869         uint256 start,
870         uint256 end,
871         bytes32 rootHash
872     ) private returns (bool) {
873         uint256 nextChildBlock;
874         /*
875     The ID of the 1st header block is MAX_DEPOSITS.
876     if _nextHeaderBlock == MAX_DEPOSITS, then the first header block is yet to be submitted, hence nextChildBlock = 0
877     */
878         if (_nextHeaderBlock > MAX_DEPOSITS) {
879             nextChildBlock = headerBlocks[currentHeaderBlock()].end + 1;
880         }
881         if (nextChildBlock != start) {
882             return false;
883         }
884 
885         HeaderBlock memory headerBlock = HeaderBlock({
886             root: rootHash,
887             start: nextChildBlock,
888             end: end,
889             createdAt: now,
890             proposer: proposer
891         });
892 
893         headerBlocks[_nextHeaderBlock] = headerBlock;
894         return true;
895     }
896 
897     // Housekeeping function. @todo remove later
898     function setNextHeaderBlock(uint256 _value) public onlyOwner {
899         require(_value % MAX_DEPOSITS == 0, "Invalid value");
900         for (uint256 i = _value; i < _nextHeaderBlock; i += MAX_DEPOSITS) {
901             delete headerBlocks[i];
902         }
903         _nextHeaderBlock = _value;
904         _blockDepositId = 1;
905         emit ResetHeaderBlock(msg.sender, _nextHeaderBlock);
906     }
907 
908     // Housekeeping function. @todo remove later
909     function setHeimdallId(string memory _heimdallId) public onlyOwner {
910         heimdallId = keccak256(abi.encodePacked(_heimdallId));
911     }
912 }
913 
914 
915 
916 
917 contract StateSender is Ownable {
918     using SafeMath for uint256;
919 
920     uint256 public counter;
921     mapping(address => address) public registrations;
922 
923     event NewRegistration(
924         address indexed user,
925         address indexed sender,
926         address indexed receiver
927     );
928     event RegistrationUpdated(
929         address indexed user,
930         address indexed sender,
931         address indexed receiver
932     );
933     event StateSynced(
934         uint256 indexed id,
935         address indexed contractAddress,
936         bytes data
937     );
938 
939     modifier onlyRegistered(address receiver) {
940         require(registrations[receiver] == msg.sender, "Invalid sender");
941         _;
942     }
943 
944     function syncState(address receiver, bytes calldata data)
945         external
946         onlyRegistered(receiver)
947     {
948         counter = counter.add(1);
949         emit StateSynced(counter, receiver, data);
950     }
951 
952     // register new contract for state sync
953     function register(address sender, address receiver) public {
954         require(
955             isOwner() || registrations[receiver] == msg.sender,
956             "StateSender.register: Not authorized to register"
957         );
958         registrations[receiver] = sender;
959         if (registrations[receiver] == address(0)) {
960             emit NewRegistration(msg.sender, sender, receiver);
961         } else {
962             emit RegistrationUpdated(msg.sender, sender, receiver);
963         }
964     }
965 }
966 
967 
968 
969 contract Lockable {
970     bool public locked;
971 
972     modifier onlyWhenUnlocked() {
973         _assertUnlocked();
974         _;
975     }
976 
977     function _assertUnlocked() private view {
978         require(!locked, "locked");
979     }
980 
981     function lock() public {
982         locked = true;
983     }
984 
985     function unlock() public {
986         locked = false;
987     }
988 }
989 
990 
991 
992 
993 contract GovernanceLockable is Lockable, Governable {
994     constructor(address governance) public Governable(governance) {}
995 
996     function lock() public onlyGovernance {
997         super.lock();
998     }
999 
1000     function unlock() public onlyGovernance {
1001         super.unlock();
1002     }
1003 }
1004 
1005 
1006 
1007 
1008 
1009 
1010 
1011 contract DepositManagerHeader {
1012     event NewDepositBlock(address indexed owner, address indexed token, uint256 amountOrNFTId, uint256 depositBlockId);
1013     event MaxErc20DepositUpdate(uint256 indexed oldLimit, uint256 indexed newLimit);
1014 
1015     struct DepositBlock {
1016         bytes32 depositHash;
1017         uint256 createdAt;
1018     }
1019 }
1020 
1021 
1022 contract DepositManagerStorage is ProxyStorage, GovernanceLockable, DepositManagerHeader {
1023     Registry public registry;
1024     RootChain public rootChain;
1025     StateSender public stateSender;
1026 
1027     mapping(uint256 => DepositBlock) public deposits;
1028 
1029     address public childChain;
1030     uint256 public maxErc20Deposit = 100 * (10**18);
1031 }
1032 
1033 
1034 /*
1035  * SPDX-License-Identitifer:    MIT
1036  */
1037 
1038 
1039 // See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-897.md
1040 
1041 interface ERCProxy {
1042     function proxyType() external pure returns (uint256 proxyTypeId);
1043     function implementation() external view returns (address codeAddr);
1044 }
1045 
1046 
1047 
1048 contract DelegateProxyForwarder {
1049     function delegatedFwd(address _dst, bytes memory _calldata) internal {
1050         // solium-disable-next-line security/no-inline-assembly
1051         assembly {
1052             let result := delegatecall(
1053                 sub(gas, 10000),
1054                 _dst,
1055                 add(_calldata, 0x20),
1056                 mload(_calldata),
1057                 0,
1058                 0
1059             )
1060             let size := returndatasize
1061 
1062             let ptr := mload(0x40)
1063             returndatacopy(ptr, 0, size)
1064 
1065             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
1066             // if the call returned error data, forward it
1067             switch result
1068                 case 0 {
1069                     revert(ptr, size)
1070                 }
1071                 default {
1072                     return(ptr, size)
1073                 }
1074         }
1075     }
1076     
1077     function isContract(address _target) internal view returns (bool) {
1078         if (_target == address(0)) {
1079             return false;
1080         }
1081 
1082         uint256 size;
1083         assembly {
1084             size := extcodesize(_target)
1085         }
1086         return size > 0;
1087     }
1088 }
1089 
1090 
1091 
1092 
1093 contract DelegateProxy is ERCProxy, DelegateProxyForwarder {
1094     function proxyType() external pure returns (uint256 proxyTypeId) {
1095         // Upgradeable proxy
1096         proxyTypeId = 2;
1097     }
1098 
1099     function implementation() external view returns (address);
1100 }
1101 
1102 
1103 
1104 
1105 contract Proxy is ProxyStorage, DelegateProxy {
1106     event ProxyUpdated(address indexed _new, address indexed _old);
1107     event OwnerUpdate(address _prevOwner, address _newOwner);
1108 
1109     constructor(address _proxyTo) public {
1110         updateImplementation(_proxyTo);
1111     }
1112 
1113     function() external payable {
1114         // require(currentContract != 0, "If app code has not been set yet, do not call");
1115         // Todo: filter out some calls or handle in the end fallback
1116         delegatedFwd(proxyTo, msg.data);
1117     }
1118 
1119     function implementation() external view returns (address) {
1120         return proxyTo;
1121     }
1122 
1123     function updateImplementation(address _newProxyTo) public onlyOwner {
1124         require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
1125         require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
1126         emit ProxyUpdated(_newProxyTo, proxyTo);
1127         proxyTo = _newProxyTo;
1128     }
1129 
1130     function isContract(address _target) internal view returns (bool) {
1131         if (_target == address(0)) {
1132             return false;
1133         }
1134 
1135         uint256 size;
1136         assembly {
1137             size := extcodesize(_target)
1138         }
1139         return size > 0;
1140     }
1141 }
1142 
1143 
1144 
1145 
1146 
1147 
1148 
1149 contract DepositManagerProxy is Proxy, DepositManagerStorage {
1150     constructor(
1151         address _proxyTo,
1152         address _registry,
1153         address _rootChain,
1154         address _governance
1155     ) public Proxy(_proxyTo) GovernanceLockable(_governance) {
1156         registry = Registry(_registry);
1157         rootChain = RootChain(_rootChain);
1158     }
1159 }