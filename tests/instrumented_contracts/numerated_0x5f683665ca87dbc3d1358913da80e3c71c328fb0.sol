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
204  * SPDX-License-Identitifer:    MIT
205  */
206 
207 
208 // See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-897.md
209 
210 interface ERCProxy {
211     function proxyType() external pure returns (uint256 proxyTypeId);
212     function implementation() external view returns (address codeAddr);
213 }
214 
215 
216 
217 contract DelegateProxyForwarder {
218     function delegatedFwd(address _dst, bytes memory _calldata) internal {
219         // solium-disable-next-line security/no-inline-assembly
220         assembly {
221             let result := delegatecall(
222                 sub(gas, 10000),
223                 _dst,
224                 add(_calldata, 0x20),
225                 mload(_calldata),
226                 0,
227                 0
228             )
229             let size := returndatasize
230 
231             let ptr := mload(0x40)
232             returndatacopy(ptr, 0, size)
233 
234             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
235             // if the call returned error data, forward it
236             switch result
237                 case 0 {
238                     revert(ptr, size)
239                 }
240                 default {
241                     return(ptr, size)
242                 }
243         }
244     }
245     
246     function isContract(address _target) internal view returns (bool) {
247         if (_target == address(0)) {
248             return false;
249         }
250 
251         uint256 size;
252         assembly {
253             size := extcodesize(_target)
254         }
255         return size > 0;
256     }
257 }
258 
259 
260 
261 
262 contract DelegateProxy is ERCProxy, DelegateProxyForwarder {
263     function proxyType() external pure returns (uint256 proxyTypeId) {
264         // Upgradeable proxy
265         proxyTypeId = 2;
266     }
267 
268     function implementation() external view returns (address);
269 }
270 
271 
272 
273 /**
274  * @title Ownable
275  * @dev The Ownable contract has an owner address, and provides basic authorization control
276  * functions, this simplifies the implementation of "user permissions".
277  */
278 contract Ownable {
279     address private _owner;
280 
281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
282 
283     /**
284      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
285      * account.
286      */
287     constructor () internal {
288         _owner = msg.sender;
289         emit OwnershipTransferred(address(0), _owner);
290     }
291 
292     /**
293      * @return the address of the owner.
294      */
295     function owner() public view returns (address) {
296         return _owner;
297     }
298 
299     /**
300      * @dev Throws if called by any account other than the owner.
301      */
302     modifier onlyOwner() {
303         require(isOwner());
304         _;
305     }
306 
307     /**
308      * @return true if `msg.sender` is the owner of the contract.
309      */
310     function isOwner() public view returns (bool) {
311         return msg.sender == _owner;
312     }
313 
314     /**
315      * @dev Allows the current owner to relinquish control of the contract.
316      * It will not be possible to call the functions with the `onlyOwner`
317      * modifier anymore.
318      * @notice Renouncing ownership will leave the contract without an owner,
319      * thereby removing any functionality that is only available to the owner.
320      */
321     function renounceOwnership() public onlyOwner {
322         emit OwnershipTransferred(_owner, address(0));
323         _owner = address(0);
324     }
325 
326     /**
327      * @dev Allows the current owner to transfer control of the contract to a newOwner.
328      * @param newOwner The address to transfer ownership to.
329      */
330     function transferOwnership(address newOwner) public onlyOwner {
331         _transferOwnership(newOwner);
332     }
333 
334     /**
335      * @dev Transfers control of the contract to a newOwner.
336      * @param newOwner The address to transfer ownership to.
337      */
338     function _transferOwnership(address newOwner) internal {
339         require(newOwner != address(0));
340         emit OwnershipTransferred(_owner, newOwner);
341         _owner = newOwner;
342     }
343 }
344 
345 
346 
347 contract ProxyStorage is Ownable {
348     address internal proxyTo;
349 }
350 
351 
352 
353 
354 contract Proxy is ProxyStorage, DelegateProxy {
355     event ProxyUpdated(address indexed _new, address indexed _old);
356     event OwnerUpdate(address _prevOwner, address _newOwner);
357 
358     constructor(address _proxyTo) public {
359         updateImplementation(_proxyTo);
360     }
361 
362     function() external payable {
363         // require(currentContract != 0, "If app code has not been set yet, do not call");
364         // Todo: filter out some calls or handle in the end fallback
365         delegatedFwd(proxyTo, msg.data);
366     }
367 
368     function implementation() external view returns (address) {
369         return proxyTo;
370     }
371 
372     function updateImplementation(address _newProxyTo) public onlyOwner {
373         require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
374         require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
375         emit ProxyUpdated(_newProxyTo, proxyTo);
376         proxyTo = _newProxyTo;
377     }
378 
379     function isContract(address _target) internal view returns (bool) {
380         if (_target == address(0)) {
381             return false;
382         }
383 
384         uint256 size;
385         assembly {
386             size := extcodesize(_target)
387         }
388         return size > 0;
389     }
390 }
391 
392 
393 /*
394 * @author Hamdi Allam hamdi.allam97@gmail.com
395 * Please reach out with any questions or concerns
396 */
397 
398 library RLPReader {
399     uint8 constant STRING_SHORT_START = 0x80;
400     uint8 constant STRING_LONG_START  = 0xb8;
401     uint8 constant LIST_SHORT_START   = 0xc0;
402     uint8 constant LIST_LONG_START    = 0xf8;
403     uint8 constant WORD_SIZE = 32;
404 
405     struct RLPItem {
406         uint len;
407         uint memPtr;
408     }
409 
410     struct Iterator {
411         RLPItem item;   // Item that's being iterated over.
412         uint nextPtr;   // Position of the next item in the list.
413     }
414 
415     /*
416     * @dev Returns the next element in the iteration. Reverts if it has not next element.
417     * @param self The iterator.
418     * @return The next element in the iteration.
419     */
420     function next(Iterator memory self) internal pure returns (RLPItem memory) {
421         require(hasNext(self));
422 
423         uint ptr = self.nextPtr;
424         uint itemLength = _itemLength(ptr);
425         self.nextPtr = ptr + itemLength;
426 
427         return RLPItem(itemLength, ptr);
428     }
429 
430     /*
431     * @dev Returns true if the iteration has more elements.
432     * @param self The iterator.
433     * @return true if the iteration has more elements.
434     */
435     function hasNext(Iterator memory self) internal pure returns (bool) {
436         RLPItem memory item = self.item;
437         return self.nextPtr < item.memPtr + item.len;
438     }
439 
440     /*
441     * @param item RLP encoded bytes
442     */
443     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
444         uint memPtr;
445         assembly {
446             memPtr := add(item, 0x20)
447         }
448 
449         return RLPItem(item.length, memPtr);
450     }
451 
452     /*
453     * @dev Create an iterator. Reverts if item is not a list.
454     * @param self The RLP item.
455     * @return An 'Iterator' over the item.
456     */
457     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
458         require(isList(self));
459 
460         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
461         return Iterator(self, ptr);
462     }
463 
464     /*
465     * @param item RLP encoded bytes
466     */
467     function rlpLen(RLPItem memory item) internal pure returns (uint) {
468         return item.len;
469     }
470 
471     /*
472     * @param item RLP encoded bytes
473     */
474     function payloadLen(RLPItem memory item) internal pure returns (uint) {
475         return item.len - _payloadOffset(item.memPtr);
476     }
477 
478     /*
479     * @param item RLP encoded list in bytes
480     */
481     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
482         require(isList(item));
483 
484         uint items = numItems(item);
485         RLPItem[] memory result = new RLPItem[](items);
486 
487         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
488         uint dataLen;
489         for (uint i = 0; i < items; i++) {
490             dataLen = _itemLength(memPtr);
491             result[i] = RLPItem(dataLen, memPtr); 
492             memPtr = memPtr + dataLen;
493         }
494 
495         return result;
496     }
497 
498     // @return indicator whether encoded payload is a list. negate this function call for isData.
499     function isList(RLPItem memory item) internal pure returns (bool) {
500         if (item.len == 0) return false;
501 
502         uint8 byte0;
503         uint memPtr = item.memPtr;
504         assembly {
505             byte0 := byte(0, mload(memPtr))
506         }
507 
508         if (byte0 < LIST_SHORT_START)
509             return false;
510         return true;
511     }
512 
513     /** RLPItem conversions into data types **/
514 
515     // @returns raw rlp encoding in bytes
516     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
517         bytes memory result = new bytes(item.len);
518         if (result.length == 0) return result;
519         
520         uint ptr;
521         assembly {
522             ptr := add(0x20, result)
523         }
524 
525         copy(item.memPtr, ptr, item.len);
526         return result;
527     }
528 
529     // any non-zero byte is considered true
530     function toBoolean(RLPItem memory item) internal pure returns (bool) {
531         require(item.len == 1);
532         uint result;
533         uint memPtr = item.memPtr;
534         assembly {
535             result := byte(0, mload(memPtr))
536         }
537 
538         return result == 0 ? false : true;
539     }
540 
541     function toAddress(RLPItem memory item) internal pure returns (address) {
542         // 1 byte for the length prefix
543         require(item.len == 21);
544 
545         return address(toUint(item));
546     }
547 
548     function toUint(RLPItem memory item) internal pure returns (uint) {
549         require(item.len > 0 && item.len <= 33);
550 
551         uint offset = _payloadOffset(item.memPtr);
552         uint len = item.len - offset;
553 
554         uint result;
555         uint memPtr = item.memPtr + offset;
556         assembly {
557             result := mload(memPtr)
558 
559             // shfit to the correct location if neccesary
560             if lt(len, 32) {
561                 result := div(result, exp(256, sub(32, len)))
562             }
563         }
564 
565         return result;
566     }
567 
568     // enforces 32 byte length
569     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
570         // one byte prefix
571         require(item.len == 33);
572 
573         uint result;
574         uint memPtr = item.memPtr + 1;
575         assembly {
576             result := mload(memPtr)
577         }
578 
579         return result;
580     }
581 
582     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
583         require(item.len > 0);
584 
585         uint offset = _payloadOffset(item.memPtr);
586         uint len = item.len - offset; // data length
587         bytes memory result = new bytes(len);
588 
589         uint destPtr;
590         assembly {
591             destPtr := add(0x20, result)
592         }
593 
594         copy(item.memPtr + offset, destPtr, len);
595         return result;
596     }
597 
598     /*
599     * Private Helpers
600     */
601 
602     // @return number of payload items inside an encoded list.
603     function numItems(RLPItem memory item) private pure returns (uint) {
604         if (item.len == 0) return 0;
605 
606         uint count = 0;
607         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
608         uint endPtr = item.memPtr + item.len;
609         while (currPtr < endPtr) {
610            currPtr = currPtr + _itemLength(currPtr); // skip over an item
611            count++;
612         }
613 
614         return count;
615     }
616 
617     // @return entire rlp item byte length
618     function _itemLength(uint memPtr) private pure returns (uint) {
619         uint itemLen;
620         uint byte0;
621         assembly {
622             byte0 := byte(0, mload(memPtr))
623         }
624 
625         if (byte0 < STRING_SHORT_START)
626             itemLen = 1;
627         
628         else if (byte0 < STRING_LONG_START)
629             itemLen = byte0 - STRING_SHORT_START + 1;
630 
631         else if (byte0 < LIST_SHORT_START) {
632             assembly {
633                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
634                 memPtr := add(memPtr, 1) // skip over the first byte
635                 
636                 /* 32 byte word size */
637                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
638                 itemLen := add(dataLen, add(byteLen, 1))
639             }
640         }
641 
642         else if (byte0 < LIST_LONG_START) {
643             itemLen = byte0 - LIST_SHORT_START + 1;
644         } 
645 
646         else {
647             assembly {
648                 let byteLen := sub(byte0, 0xf7)
649                 memPtr := add(memPtr, 1)
650 
651                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
652                 itemLen := add(dataLen, add(byteLen, 1))
653             }
654         }
655 
656         return itemLen;
657     }
658 
659     // @return number of bytes until the data
660     function _payloadOffset(uint memPtr) private pure returns (uint) {
661         uint byte0;
662         assembly {
663             byte0 := byte(0, mload(memPtr))
664         }
665 
666         if (byte0 < STRING_SHORT_START) 
667             return 0;
668         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
669             return 1;
670         else if (byte0 < LIST_SHORT_START)  // being explicit
671             return byte0 - (STRING_LONG_START - 1) + 1;
672         else
673             return byte0 - (LIST_LONG_START - 1) + 1;
674     }
675 
676     /*
677     * @param src Pointer to source
678     * @param dest Pointer to destination
679     * @param len Amount of memory to copy from the source
680     */
681     function copy(uint src, uint dest, uint len) private pure {
682         if (len == 0) return;
683 
684         // copy as many word sizes as possible
685         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
686             assembly {
687                 mstore(dest, mload(src))
688             }
689 
690             src += WORD_SIZE;
691             dest += WORD_SIZE;
692         }
693 
694         // left over bytes. Mask is used to remove unwanted bytes from the word
695         uint mask = 256 ** (WORD_SIZE - len) - 1;
696         assembly {
697             let srcpart := and(mload(src), not(mask)) // zero out src
698             let destpart := and(mload(dest), mask) // retrieve the bytes
699             mstore(dest, or(destpart, srcpart))
700         }
701     }
702 }
703 
704 
705 
706 /**
707  * @title SafeMath
708  * @dev Unsigned math operations with safety checks that revert on error
709  */
710 library SafeMath {
711     /**
712      * @dev Multiplies two unsigned integers, reverts on overflow.
713      */
714     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
715         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
716         // benefit is lost if 'b' is also tested.
717         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
718         if (a == 0) {
719             return 0;
720         }
721 
722         uint256 c = a * b;
723         require(c / a == b);
724 
725         return c;
726     }
727 
728     /**
729      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
730      */
731     function div(uint256 a, uint256 b) internal pure returns (uint256) {
732         // Solidity only automatically asserts when dividing by 0
733         require(b > 0);
734         uint256 c = a / b;
735         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
736 
737         return c;
738     }
739 
740     /**
741      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
742      */
743     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
744         require(b <= a);
745         uint256 c = a - b;
746 
747         return c;
748     }
749 
750     /**
751      * @dev Adds two unsigned integers, reverts on overflow.
752      */
753     function add(uint256 a, uint256 b) internal pure returns (uint256) {
754         uint256 c = a + b;
755         require(c >= a);
756 
757         return c;
758     }
759 
760     /**
761      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
762      * reverts when dividing by zero.
763      */
764     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
765         require(b != 0);
766         return a % b;
767     }
768 }
769 
770 
771 
772 contract ChainIdMixin {
773   bytes constant public networkId = hex"6D";
774   uint256 constant public CHAINID = 109;
775 }
776 
777 
778 
779 
780 
781 contract RootChainHeader {
782     event NewHeaderBlock(
783         address indexed proposer,
784         uint256 indexed headerBlockId,
785         uint256 indexed reward,
786         uint256 start,
787         uint256 end,
788         bytes32 root
789     );
790     // housekeeping event
791     event ResetHeaderBlock(address indexed proposer, uint256 indexed headerBlockId);
792     struct HeaderBlock {
793         bytes32 root;
794         uint256 start;
795         uint256 end;
796         uint256 createdAt;
797         address proposer;
798     }
799 }
800 
801 
802 contract RootChainStorage is ProxyStorage, RootChainHeader, ChainIdMixin {
803     bytes32 public heimdallId;
804     uint8 public constant VOTE_TYPE = 2;
805 
806     uint16 internal constant MAX_DEPOSITS = 10000;
807     uint256 public _nextHeaderBlock = MAX_DEPOSITS;
808     uint256 internal _blockDepositId = 1;
809     mapping(uint256 => HeaderBlock) public headerBlocks;
810     Registry internal registry;
811 }
812 
813 
814 
815 contract IStakeManager {
816     // validator replacement
817     function startAuction(
818         uint256 validatorId,
819         uint256 amount,
820         bool acceptDelegation,
821         bytes calldata signerPubkey
822     ) external;
823 
824     function confirmAuctionBid(uint256 validatorId, uint256 heimdallFee) external;
825 
826     function transferFunds(
827         uint256 validatorId,
828         uint256 amount,
829         address delegator
830     ) external returns (bool);
831 
832     function delegationDeposit(
833         uint256 validatorId,
834         uint256 amount,
835         address delegator
836     ) external returns (bool);
837 
838     function unstake(uint256 validatorId) external;
839 
840     function totalStakedFor(address addr) external view returns (uint256);
841 
842     function stakeFor(
843         address user,
844         uint256 amount,
845         uint256 heimdallFee,
846         bool acceptDelegation,
847         bytes memory signerPubkey
848     ) public;
849 
850     function checkSignatures(
851         uint256 blockInterval,
852         bytes32 voteHash,
853         bytes32 stateRoot,
854         address proposer,
855         uint[3][] calldata sigs
856     ) external returns (uint256);
857 
858     function updateValidatorState(uint256 validatorId, int256 amount) public;
859 
860     function ownerOf(uint256 tokenId) public view returns (address);
861 
862     function slash(bytes calldata slashingInfoList) external returns (uint256);
863 
864     function validatorStake(uint256 validatorId) public view returns (uint256);
865 
866     function epoch() public view returns (uint256);
867 
868     function getRegistry() public view returns (address);
869 
870     function withdrawalDelay() public view returns (uint256);
871 
872     function delegatedAmount(uint256 validatorId) public view returns(uint256);
873 
874     function decreaseValidatorDelegatedAmount(uint256 validatorId, uint256 amount) public;
875 
876     function withdrawDelegatorsReward(uint256 validatorId) public returns(uint256);
877 
878     function delegatorsReward(uint256 validatorId) public view returns(uint256);
879 
880     function dethroneAndStake(
881         address auctionUser,
882         uint256 heimdallFee,
883         uint256 validatorId,
884         uint256 auctionAmount,
885         bool acceptDelegation,
886         bytes calldata signerPubkey
887     ) external;
888 }
889 
890 
891 
892 
893 interface IRootChain {
894     function slash() external;
895 
896     function submitHeaderBlock(bytes calldata data, bytes calldata sigs)
897         external;
898     
899     function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs)
900         external;
901 
902     function getLastChildBlock() external view returns (uint256);
903 
904     function currentHeaderBlock() external view returns (uint256);
905 }
906 
907 
908 
909 
910 
911 
912 contract RootChain is RootChainStorage, IRootChain {
913     using SafeMath for uint256;
914     using RLPReader for bytes;
915     using RLPReader for RLPReader.RLPItem;
916 
917     modifier onlyDepositManager() {
918         require(msg.sender == registry.getDepositManagerAddress(), "UNAUTHORIZED_DEPOSIT_MANAGER_ONLY");
919         _;
920     }
921 
922     function submitHeaderBlock(bytes calldata data, bytes calldata sigs) external {
923         revert();
924     }
925 
926     function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs) external {
927         (address proposer, uint256 start, uint256 end, bytes32 rootHash, bytes32 accountHash, uint256 _borChainID) = abi
928             .decode(data, (address, uint256, uint256, bytes32, bytes32, uint256));
929         require(CHAINID == _borChainID, "Invalid bor chain id");
930 
931         require(_buildHeaderBlock(proposer, start, end, rootHash), "INCORRECT_HEADER_DATA");
932 
933         // check if it is better to keep it in local storage instead
934         IStakeManager stakeManager = IStakeManager(registry.getStakeManagerAddress());
935         uint256 _reward = stakeManager.checkSignatures(
936             end.sub(start).add(1),
937             /**  
938                 prefix 01 to data 
939                 01 represents positive vote on data and 00 is negative vote
940                 malicious validator can try to send 2/3 on negative vote so 01 is appended
941              */
942             keccak256(abi.encodePacked(bytes(hex"01"), data)),
943             accountHash,
944             proposer,
945             sigs
946         );
947 
948         require(_reward != 0, "Invalid checkpoint");
949         emit NewHeaderBlock(proposer, _nextHeaderBlock, _reward, start, end, rootHash);
950         _nextHeaderBlock = _nextHeaderBlock.add(MAX_DEPOSITS);
951         _blockDepositId = 1;
952     }
953 
954     function updateDepositId(uint256 numDeposits) external onlyDepositManager returns (uint256 depositId) {
955         depositId = currentHeaderBlock().add(_blockDepositId);
956         // deposit ids will be (_blockDepositId, _blockDepositId + 1, .... _blockDepositId + numDeposits - 1)
957         _blockDepositId = _blockDepositId.add(numDeposits);
958         require(
959             // Since _blockDepositId is initialized to 1; only (MAX_DEPOSITS - 1) deposits per header block are allowed
960             _blockDepositId <= MAX_DEPOSITS,
961             "TOO_MANY_DEPOSITS"
962         );
963     }
964 
965     function getLastChildBlock() external view returns (uint256) {
966         return headerBlocks[currentHeaderBlock()].end;
967     }
968 
969     function slash() external {
970         //TODO: future implementation
971     }
972 
973     function currentHeaderBlock() public view returns (uint256) {
974         return _nextHeaderBlock.sub(MAX_DEPOSITS);
975     }
976 
977     function _buildHeaderBlock(
978         address proposer,
979         uint256 start,
980         uint256 end,
981         bytes32 rootHash
982     ) private returns (bool) {
983         uint256 nextChildBlock;
984         /*
985     The ID of the 1st header block is MAX_DEPOSITS.
986     if _nextHeaderBlock == MAX_DEPOSITS, then the first header block is yet to be submitted, hence nextChildBlock = 0
987     */
988         if (_nextHeaderBlock > MAX_DEPOSITS) {
989             nextChildBlock = headerBlocks[currentHeaderBlock()].end + 1;
990         }
991         if (nextChildBlock != start) {
992             return false;
993         }
994 
995         HeaderBlock memory headerBlock = HeaderBlock({
996             root: rootHash,
997             start: nextChildBlock,
998             end: end,
999             createdAt: now,
1000             proposer: proposer
1001         });
1002 
1003         headerBlocks[_nextHeaderBlock] = headerBlock;
1004         return true;
1005     }
1006 
1007     // Housekeeping function. @todo remove later
1008     function setNextHeaderBlock(uint256 _value) public onlyOwner {
1009         require(_value % MAX_DEPOSITS == 0, "Invalid value");
1010         for (uint256 i = _value; i < _nextHeaderBlock; i += MAX_DEPOSITS) {
1011             delete headerBlocks[i];
1012         }
1013         _nextHeaderBlock = _value;
1014         _blockDepositId = 1;
1015         emit ResetHeaderBlock(msg.sender, _nextHeaderBlock);
1016     }
1017 
1018     // Housekeeping function. @todo remove later
1019     function setHeimdallId(string memory _heimdallId) public onlyOwner {
1020         heimdallId = keccak256(abi.encodePacked(_heimdallId));
1021     }
1022 }
1023 
1024 
1025 
1026 /**
1027  * @title IERC165
1028  * @dev https://eips.ethereum.org/EIPS/eip-165
1029  */
1030 interface IERC165 {
1031     /**
1032      * @notice Query if a contract implements an interface
1033      * @param interfaceId The interface identifier, as specified in ERC-165
1034      * @dev Interface identification is specified in ERC-165. This function
1035      * uses less than 30,000 gas.
1036      */
1037     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1038 }
1039 
1040 
1041 
1042 /**
1043  * @title ERC721 Non-Fungible Token Standard basic interface
1044  * @dev see https://eips.ethereum.org/EIPS/eip-721
1045  */
1046 contract IERC721 is IERC165 {
1047     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1048     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1049     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1050 
1051     function balanceOf(address owner) public view returns (uint256 balance);
1052     function ownerOf(uint256 tokenId) public view returns (address owner);
1053 
1054     function approve(address to, uint256 tokenId) public;
1055     function getApproved(uint256 tokenId) public view returns (address operator);
1056 
1057     function setApprovalForAll(address operator, bool _approved) public;
1058     function isApprovedForAll(address owner, address operator) public view returns (bool);
1059 
1060     function transferFrom(address from, address to, uint256 tokenId) public;
1061     function safeTransferFrom(address from, address to, uint256 tokenId) public;
1062 
1063     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
1064 }
1065 
1066 
1067 
1068 /**
1069  * @title ERC721 token receiver interface
1070  * @dev Interface for any contract that wants to support safeTransfers
1071  * from ERC721 asset contracts.
1072  */
1073 contract IERC721Receiver {
1074     /**
1075      * @notice Handle the receipt of an NFT
1076      * @dev The ERC721 smart contract calls this function on the recipient
1077      * after a `safeTransfer`. This function MUST return the function selector,
1078      * otherwise the caller will revert the transaction. The selector to be
1079      * returned can be obtained as `this.onERC721Received.selector`. This
1080      * function MAY throw to revert and reject the transfer.
1081      * Note: the ERC721 contract address is always the message sender.
1082      * @param operator The address which called `safeTransferFrom` function
1083      * @param from The address which previously owned the token
1084      * @param tokenId The NFT identifier which is being transferred
1085      * @param data Additional data with no specified format
1086      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1087      */
1088     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
1089     public returns (bytes4);
1090 }
1091 
1092 
1093 
1094 /**
1095  * Utility library of inline functions on addresses
1096  */
1097 library Address {
1098     /**
1099      * Returns whether the target address is a contract
1100      * @dev This function will return false if invoked during the constructor of a contract,
1101      * as the code is not actually created until after the constructor finishes.
1102      * @param account address of the account to check
1103      * @return whether the target address is a contract
1104      */
1105     function isContract(address account) internal view returns (bool) {
1106         uint256 size;
1107         // XXX Currently there is no better way to check if there is a contract in an address
1108         // than to check the size of the code at that address.
1109         // See https://ethereum.stackexchange.com/a/14016/36603
1110         // for more details about how this works.
1111         // TODO Check this again before the Serenity release, because all addresses will be
1112         // contracts then.
1113         // solhint-disable-next-line no-inline-assembly
1114         assembly { size := extcodesize(account) }
1115         return size > 0;
1116     }
1117 }
1118 
1119 
1120 
1121 /**
1122  * @title Counters
1123  * @author Matt Condon (@shrugs)
1124  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1125  * of elements in a mapping, issuing ERC721 ids, or counting request ids
1126  *
1127  * Include with `using Counters for Counters.Counter;`
1128  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
1129  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1130  * directly accessed.
1131  */
1132 library Counters {
1133     using SafeMath for uint256;
1134 
1135     struct Counter {
1136         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1137         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1138         // this feature: see https://github.com/ethereum/solidity/issues/4637
1139         uint256 _value; // default: 0
1140     }
1141 
1142     function current(Counter storage counter) internal view returns (uint256) {
1143         return counter._value;
1144     }
1145 
1146     function increment(Counter storage counter) internal {
1147         counter._value += 1;
1148     }
1149 
1150     function decrement(Counter storage counter) internal {
1151         counter._value = counter._value.sub(1);
1152     }
1153 }
1154 
1155 
1156 
1157 /**
1158  * @title ERC165
1159  * @author Matt Condon (@shrugs)
1160  * @dev Implements ERC165 using a lookup table.
1161  */
1162 contract ERC165 is IERC165 {
1163     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1164     /*
1165      * 0x01ffc9a7 ===
1166      *     bytes4(keccak256('supportsInterface(bytes4)'))
1167      */
1168 
1169     /**
1170      * @dev a mapping of interface id to whether or not it's supported
1171      */
1172     mapping(bytes4 => bool) private _supportedInterfaces;
1173 
1174     /**
1175      * @dev A contract implementing SupportsInterfaceWithLookup
1176      * implement ERC165 itself
1177      */
1178     constructor () internal {
1179         _registerInterface(_INTERFACE_ID_ERC165);
1180     }
1181 
1182     /**
1183      * @dev implement supportsInterface(bytes4) using a lookup table
1184      */
1185     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
1186         return _supportedInterfaces[interfaceId];
1187     }
1188 
1189     /**
1190      * @dev internal method for registering an interface
1191      */
1192     function _registerInterface(bytes4 interfaceId) internal {
1193         require(interfaceId != 0xffffffff);
1194         _supportedInterfaces[interfaceId] = true;
1195     }
1196 }
1197 
1198 
1199 
1200 
1201 
1202 
1203 
1204 
1205 /**
1206  * @title ERC721 Non-Fungible Token Standard basic implementation
1207  * @dev see https://eips.ethereum.org/EIPS/eip-721
1208  */
1209 contract ERC721 is ERC165, IERC721 {
1210     using SafeMath for uint256;
1211     using Address for address;
1212     using Counters for Counters.Counter;
1213 
1214     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1215     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1216     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1217 
1218     // Mapping from token ID to owner
1219     mapping (uint256 => address) private _tokenOwner;
1220 
1221     // Mapping from token ID to approved address
1222     mapping (uint256 => address) private _tokenApprovals;
1223 
1224     // Mapping from owner to number of owned token
1225     mapping (address => Counters.Counter) private _ownedTokensCount;
1226 
1227     // Mapping from owner to operator approvals
1228     mapping (address => mapping (address => bool)) private _operatorApprovals;
1229 
1230     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1231     /*
1232      * 0x80ac58cd ===
1233      *     bytes4(keccak256('balanceOf(address)')) ^
1234      *     bytes4(keccak256('ownerOf(uint256)')) ^
1235      *     bytes4(keccak256('approve(address,uint256)')) ^
1236      *     bytes4(keccak256('getApproved(uint256)')) ^
1237      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1238      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
1239      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1240      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1241      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1242      */
1243 
1244     constructor () public {
1245         // register the supported interfaces to conform to ERC721 via ERC165
1246         _registerInterface(_INTERFACE_ID_ERC721);
1247     }
1248 
1249     /**
1250      * @dev Gets the balance of the specified address
1251      * @param owner address to query the balance of
1252      * @return uint256 representing the amount owned by the passed address
1253      */
1254     function balanceOf(address owner) public view returns (uint256) {
1255         require(owner != address(0));
1256         return _ownedTokensCount[owner].current();
1257     }
1258 
1259     /**
1260      * @dev Gets the owner of the specified token ID
1261      * @param tokenId uint256 ID of the token to query the owner of
1262      * @return address currently marked as the owner of the given token ID
1263      */
1264     function ownerOf(uint256 tokenId) public view returns (address) {
1265         address owner = _tokenOwner[tokenId];
1266         require(owner != address(0));
1267         return owner;
1268     }
1269 
1270     /**
1271      * @dev Approves another address to transfer the given token ID
1272      * The zero address indicates there is no approved address.
1273      * There can only be one approved address per token at a given time.
1274      * Can only be called by the token owner or an approved operator.
1275      * @param to address to be approved for the given token ID
1276      * @param tokenId uint256 ID of the token to be approved
1277      */
1278     function approve(address to, uint256 tokenId) public {
1279         address owner = ownerOf(tokenId);
1280         require(to != owner);
1281         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1282 
1283         _tokenApprovals[tokenId] = to;
1284         emit Approval(owner, to, tokenId);
1285     }
1286 
1287     /**
1288      * @dev Gets the approved address for a token ID, or zero if no address set
1289      * Reverts if the token ID does not exist.
1290      * @param tokenId uint256 ID of the token to query the approval of
1291      * @return address currently approved for the given token ID
1292      */
1293     function getApproved(uint256 tokenId) public view returns (address) {
1294         require(_exists(tokenId));
1295         return _tokenApprovals[tokenId];
1296     }
1297 
1298     /**
1299      * @dev Sets or unsets the approval of a given operator
1300      * An operator is allowed to transfer all tokens of the sender on their behalf
1301      * @param to operator address to set the approval
1302      * @param approved representing the status of the approval to be set
1303      */
1304     function setApprovalForAll(address to, bool approved) public {
1305         require(to != msg.sender);
1306         _operatorApprovals[msg.sender][to] = approved;
1307         emit ApprovalForAll(msg.sender, to, approved);
1308     }
1309 
1310     /**
1311      * @dev Tells whether an operator is approved by a given owner
1312      * @param owner owner address which you want to query the approval of
1313      * @param operator operator address which you want to query the approval of
1314      * @return bool whether the given operator is approved by the given owner
1315      */
1316     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1317         return _operatorApprovals[owner][operator];
1318     }
1319 
1320     /**
1321      * @dev Transfers the ownership of a given token ID to another address
1322      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1323      * Requires the msg.sender to be the owner, approved, or operator
1324      * @param from current owner of the token
1325      * @param to address to receive the ownership of the given token ID
1326      * @param tokenId uint256 ID of the token to be transferred
1327      */
1328     function transferFrom(address from, address to, uint256 tokenId) public {
1329         require(_isApprovedOrOwner(msg.sender, tokenId));
1330 
1331         _transferFrom(from, to, tokenId);
1332     }
1333 
1334     /**
1335      * @dev Safely transfers the ownership of a given token ID to another address
1336      * If the target address is a contract, it must implement `onERC721Received`,
1337      * which is called upon a safe transfer, and return the magic value
1338      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1339      * the transfer is reverted.
1340      * Requires the msg.sender to be the owner, approved, or operator
1341      * @param from current owner of the token
1342      * @param to address to receive the ownership of the given token ID
1343      * @param tokenId uint256 ID of the token to be transferred
1344      */
1345     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1346         safeTransferFrom(from, to, tokenId, "");
1347     }
1348 
1349     /**
1350      * @dev Safely transfers the ownership of a given token ID to another address
1351      * If the target address is a contract, it must implement `onERC721Received`,
1352      * which is called upon a safe transfer, and return the magic value
1353      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1354      * the transfer is reverted.
1355      * Requires the msg.sender to be the owner, approved, or operator
1356      * @param from current owner of the token
1357      * @param to address to receive the ownership of the given token ID
1358      * @param tokenId uint256 ID of the token to be transferred
1359      * @param _data bytes data to send along with a safe transfer check
1360      */
1361     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1362         transferFrom(from, to, tokenId);
1363         require(_checkOnERC721Received(from, to, tokenId, _data));
1364     }
1365 
1366     /**
1367      * @dev Returns whether the specified token exists
1368      * @param tokenId uint256 ID of the token to query the existence of
1369      * @return bool whether the token exists
1370      */
1371     function _exists(uint256 tokenId) internal view returns (bool) {
1372         address owner = _tokenOwner[tokenId];
1373         return owner != address(0);
1374     }
1375 
1376     /**
1377      * @dev Returns whether the given spender can transfer a given token ID
1378      * @param spender address of the spender to query
1379      * @param tokenId uint256 ID of the token to be transferred
1380      * @return bool whether the msg.sender is approved for the given token ID,
1381      * is an operator of the owner, or is the owner of the token
1382      */
1383     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1384         address owner = ownerOf(tokenId);
1385         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1386     }
1387 
1388     /**
1389      * @dev Internal function to mint a new token
1390      * Reverts if the given token ID already exists
1391      * @param to The address that will own the minted token
1392      * @param tokenId uint256 ID of the token to be minted
1393      */
1394     function _mint(address to, uint256 tokenId) internal {
1395         require(to != address(0));
1396         require(!_exists(tokenId));
1397 
1398         _tokenOwner[tokenId] = to;
1399         _ownedTokensCount[to].increment();
1400 
1401         emit Transfer(address(0), to, tokenId);
1402     }
1403 
1404     /**
1405      * @dev Internal function to burn a specific token
1406      * Reverts if the token does not exist
1407      * Deprecated, use _burn(uint256) instead.
1408      * @param owner owner of the token to burn
1409      * @param tokenId uint256 ID of the token being burned
1410      */
1411     function _burn(address owner, uint256 tokenId) internal {
1412         require(ownerOf(tokenId) == owner);
1413 
1414         _clearApproval(tokenId);
1415 
1416         _ownedTokensCount[owner].decrement();
1417         _tokenOwner[tokenId] = address(0);
1418 
1419         emit Transfer(owner, address(0), tokenId);
1420     }
1421 
1422     /**
1423      * @dev Internal function to burn a specific token
1424      * Reverts if the token does not exist
1425      * @param tokenId uint256 ID of the token being burned
1426      */
1427     function _burn(uint256 tokenId) internal {
1428         _burn(ownerOf(tokenId), tokenId);
1429     }
1430 
1431     /**
1432      * @dev Internal function to transfer ownership of a given token ID to another address.
1433      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1434      * @param from current owner of the token
1435      * @param to address to receive the ownership of the given token ID
1436      * @param tokenId uint256 ID of the token to be transferred
1437      */
1438     function _transferFrom(address from, address to, uint256 tokenId) internal {
1439         require(ownerOf(tokenId) == from);
1440         require(to != address(0));
1441 
1442         _clearApproval(tokenId);
1443 
1444         _ownedTokensCount[from].decrement();
1445         _ownedTokensCount[to].increment();
1446 
1447         _tokenOwner[tokenId] = to;
1448 
1449         emit Transfer(from, to, tokenId);
1450     }
1451 
1452     /**
1453      * @dev Internal function to invoke `onERC721Received` on a target address
1454      * The call is not executed if the target address is not a contract
1455      * @param from address representing the previous owner of the given token ID
1456      * @param to target address that will receive the tokens
1457      * @param tokenId uint256 ID of the token to be transferred
1458      * @param _data bytes optional data to send along with the call
1459      * @return bool whether the call correctly returned the expected magic value
1460      */
1461     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1462         internal returns (bool)
1463     {
1464         if (!to.isContract()) {
1465             return true;
1466         }
1467 
1468         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1469         return (retval == _ERC721_RECEIVED);
1470     }
1471 
1472     /**
1473      * @dev Private function to clear current approval of a given token ID
1474      * @param tokenId uint256 ID of the token to be transferred
1475      */
1476     function _clearApproval(uint256 tokenId) private {
1477         if (_tokenApprovals[tokenId] != address(0)) {
1478             _tokenApprovals[tokenId] = address(0);
1479         }
1480     }
1481 }
1482 
1483 
1484 
1485 
1486 contract ExitNFT is ERC721 {
1487     Registry internal registry;
1488 
1489     modifier onlyWithdrawManager() {
1490         require(
1491             msg.sender == registry.getWithdrawManagerAddress(),
1492             "UNAUTHORIZED_WITHDRAW_MANAGER_ONLY"
1493         );
1494         _;
1495     }
1496 
1497     constructor(address _registry) public {
1498         registry = Registry(_registry);
1499     }
1500 
1501     function mint(address _owner, uint256 _tokenId)
1502         external
1503         onlyWithdrawManager
1504     {
1505         _mint(_owner, _tokenId);
1506     }
1507 
1508     function burn(uint256 _tokenId) external onlyWithdrawManager {
1509         _burn(_tokenId);
1510     }
1511 
1512     function exists(uint256 tokenId) public view returns (bool) {
1513         return _exists(tokenId);
1514     }
1515 }
1516 
1517 
1518 
1519 
1520 
1521 
1522 contract ExitsDataStructure {
1523     struct Input {
1524         address utxoOwner;
1525         address predicate;
1526         address token;
1527     }
1528 
1529     struct PlasmaExit {
1530         uint256 receiptAmountOrNFTId;
1531         bytes32 txHash;
1532         address owner;
1533         address token;
1534         bool isRegularExit;
1535         address predicate;
1536         // Mapping from age of input to Input
1537         mapping(uint256 => Input) inputs;
1538     }
1539 }
1540 
1541 
1542 contract WithdrawManagerHeader is ExitsDataStructure {
1543     event Withdraw(uint256 indexed exitId, address indexed user, address indexed token, uint256 amount);
1544 
1545     event ExitStarted(
1546         address indexed exitor,
1547         uint256 indexed exitId,
1548         address indexed token,
1549         uint256 amount,
1550         bool isRegularExit
1551     );
1552 
1553     event ExitUpdated(uint256 indexed exitId, uint256 indexed age, address signer);
1554     event ExitPeriodUpdate(uint256 indexed oldExitPeriod, uint256 indexed newExitPeriod);
1555 
1556     event ExitCancelled(uint256 indexed exitId);
1557 }
1558 
1559 
1560 contract WithdrawManagerStorage is ProxyStorage, WithdrawManagerHeader {
1561     // 0.5 week = 7 * 86400 / 2 = 302400
1562     uint256 public HALF_EXIT_PERIOD = 302400;
1563 
1564     // Bonded exits collaterized at 0.1 ETH
1565     uint256 internal constant BOND_AMOUNT = 10**17;
1566 
1567     Registry internal registry;
1568     RootChain internal rootChain;
1569 
1570     mapping(uint128 => bool) isKnownExit;
1571     mapping(uint256 => PlasmaExit) public exits;
1572     // mapping with token => (owner => exitId) keccak(token+owner) keccak(token+owner+tokenId)
1573     mapping(bytes32 => uint256) public ownerExits;
1574     mapping(address => address) public exitsQueues;
1575     ExitNFT public exitNft;
1576 
1577     // ERC721, ERC20 and Weth transfers require 155000, 100000, 52000 gas respectively
1578     // Processing each exit in a while loop iteration requires ~52000 gas (@todo check if this changed)
1579     // uint32 constant internal ITERATION_GAS = 52000;
1580 
1581     // So putting an upper limit of 155000 + 52000 + leeway
1582     uint32 public ON_FINALIZE_GAS_LIMIT = 300000;
1583 
1584     uint256 public exitWindow;
1585 }
1586 
1587 
1588 
1589 
1590 
1591 
1592 
1593 contract WithdrawManagerProxy is Proxy, WithdrawManagerStorage {
1594     constructor(
1595         address _proxyTo,
1596         address _registry,
1597         address _rootChain,
1598         address _exitNft
1599     ) public Proxy(_proxyTo) {
1600         registry = Registry(_registry);
1601         rootChain = RootChain(_rootChain);
1602         exitNft = ExitNFT(_exitNft);
1603     }
1604 }