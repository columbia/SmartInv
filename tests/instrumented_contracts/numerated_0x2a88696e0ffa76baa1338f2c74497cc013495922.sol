1 // File: contracts/common/governance/IGovernance.sol
2 
3 pragma solidity ^0.5.2;
4 
5 
6 interface IGovernance {
7     function update(address target, bytes calldata data) external;
8 }
9 
10 // File: contracts/common/governance/Governable.sol
11 
12 pragma solidity ^0.5.2;
13 
14 
15 contract Governable {
16     IGovernance public governance;
17 
18     constructor(address _governance) public {
19         governance = IGovernance(_governance);
20     }
21 
22     modifier onlyGovernance() {
23         require(msg.sender == address(governance), "Only governance contract is authorized");
24         _;
25     }
26 }
27 
28 // File: contracts/root/withdrawManager/IWithdrawManager.sol
29 
30 pragma solidity ^0.5.2;
31 
32 
33 contract IWithdrawManager {
34     function createExitQueue(address token) external;
35 
36     function verifyInclusion(
37         bytes calldata data,
38         uint8 offset,
39         bool verifyTxInclusion
40     ) external view returns (uint256 age);
41 
42     function addExitToQueue(
43         address exitor,
44         address childToken,
45         address rootToken,
46         uint256 exitAmountOrTokenId,
47         bytes32 txHash,
48         bool isRegularExit,
49         uint256 priority
50     ) external;
51 
52     function addInput(
53         uint256 exitId,
54         uint256 age,
55         address utxoOwner,
56         address token
57     ) external;
58 
59     function challengeExit(
60         uint256 exitId,
61         uint256 inputId,
62         bytes calldata challengeData,
63         address adjudicatorPredicate
64     ) external;
65 }
66 
67 // File: contracts/common/Registry.sol
68 
69 pragma solidity ^0.5.2;
70 
71 
72 contract Registry is Governable {
73     // @todo hardcode constants
74     bytes32 private constant WETH_TOKEN = keccak256("wethToken");
75     bytes32 private constant DEPOSIT_MANAGER = keccak256("depositManager");
76     bytes32 private constant STAKE_MANAGER = keccak256("stakeManager");
77     bytes32 private constant VALIDATOR_SHARE = keccak256("validatorShare");
78     bytes32 private constant WITHDRAW_MANAGER = keccak256("withdrawManager");
79     bytes32 private constant CHILD_CHAIN = keccak256("childChain");
80     bytes32 private constant STATE_SENDER = keccak256("stateSender");
81     bytes32 private constant SLASHING_MANAGER = keccak256("slashingManager");
82 
83     address public erc20Predicate;
84     address public erc721Predicate;
85 
86     mapping(bytes32 => address) public contractMap;
87     mapping(address => address) public rootToChildToken;
88     mapping(address => address) public childToRootToken;
89     mapping(address => bool) public proofValidatorContracts;
90     mapping(address => bool) public isERC721;
91 
92     enum Type {Invalid, ERC20, ERC721, Custom}
93     struct Predicate {
94         Type _type;
95     }
96     mapping(address => Predicate) public predicates;
97 
98     event TokenMapped(address indexed rootToken, address indexed childToken);
99     event ProofValidatorAdded(address indexed validator, address indexed from);
100     event ProofValidatorRemoved(address indexed validator, address indexed from);
101     event PredicateAdded(address indexed predicate, address indexed from);
102     event PredicateRemoved(address indexed predicate, address indexed from);
103     event ContractMapUpdated(bytes32 indexed key, address indexed previousContract, address indexed newContract);
104 
105     constructor(address _governance) public Governable(_governance) {}
106 
107     function updateContractMap(bytes32 _key, address _address) external onlyGovernance {
108         emit ContractMapUpdated(_key, contractMap[_key], _address);
109         contractMap[_key] = _address;
110     }
111 
112     /**
113      * @dev Map root token to child token
114      * @param _rootToken Token address on the root chain
115      * @param _childToken Token address on the child chain
116      * @param _isERC721 Is the token being mapped ERC721
117      */
118     function mapToken(
119         address _rootToken,
120         address _childToken,
121         bool _isERC721
122     ) external onlyGovernance {
123         require(_rootToken != address(0x0) && _childToken != address(0x0), "INVALID_TOKEN_ADDRESS");
124         rootToChildToken[_rootToken] = _childToken;
125         childToRootToken[_childToken] = _rootToken;
126         isERC721[_rootToken] = _isERC721;
127         IWithdrawManager(contractMap[WITHDRAW_MANAGER]).createExitQueue(_rootToken);
128         emit TokenMapped(_rootToken, _childToken);
129     }
130 
131     function addErc20Predicate(address predicate) public onlyGovernance {
132         require(predicate != address(0x0), "Can not add null address as predicate");
133         erc20Predicate = predicate;
134         addPredicate(predicate, Type.ERC20);
135     }
136 
137     function addErc721Predicate(address predicate) public onlyGovernance {
138         erc721Predicate = predicate;
139         addPredicate(predicate, Type.ERC721);
140     }
141 
142     function addPredicate(address predicate, Type _type) public onlyGovernance {
143         require(predicates[predicate]._type == Type.Invalid, "Predicate already added");
144         predicates[predicate]._type = _type;
145         emit PredicateAdded(predicate, msg.sender);
146     }
147 
148     function removePredicate(address predicate) public onlyGovernance {
149         require(predicates[predicate]._type != Type.Invalid, "Predicate does not exist");
150         delete predicates[predicate];
151         emit PredicateRemoved(predicate, msg.sender);
152     }
153 
154     function getValidatorShareAddress() public view returns (address) {
155         return contractMap[VALIDATOR_SHARE];
156     }
157 
158     function getWethTokenAddress() public view returns (address) {
159         return contractMap[WETH_TOKEN];
160     }
161 
162     function getDepositManagerAddress() public view returns (address) {
163         return contractMap[DEPOSIT_MANAGER];
164     }
165 
166     function getStakeManagerAddress() public view returns (address) {
167         return contractMap[STAKE_MANAGER];
168     }
169 
170     function getSlashingManagerAddress() public view returns (address) {
171         return contractMap[SLASHING_MANAGER];
172     }
173 
174     function getWithdrawManagerAddress() public view returns (address) {
175         return contractMap[WITHDRAW_MANAGER];
176     }
177 
178     function getChildChainAndStateSender() public view returns (address, address) {
179         return (contractMap[CHILD_CHAIN], contractMap[STATE_SENDER]);
180     }
181 
182     function isTokenMapped(address _token) public view returns (bool) {
183         return rootToChildToken[_token] != address(0x0);
184     }
185 
186     function isTokenMappedAndIsErc721(address _token) public view returns (bool) {
187         require(isTokenMapped(_token), "TOKEN_NOT_MAPPED");
188         return isERC721[_token];
189     }
190 
191     function isTokenMappedAndGetPredicate(address _token) public view returns (address) {
192         if (isTokenMappedAndIsErc721(_token)) {
193             return erc721Predicate;
194         }
195         return erc20Predicate;
196     }
197 
198     function isChildTokenErc721(address childToken) public view returns (bool) {
199         address rootToken = childToRootToken[childToken];
200         require(rootToken != address(0x0), "Child token is not mapped");
201         return isERC721[rootToken];
202     }
203 }
204 
205 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
206 
207 pragma solidity ^0.5.2;
208 
209 
210 /**
211  * @title Ownable
212  * @dev The Ownable contract has an owner address, and provides basic authorization control
213  * functions, this simplifies the implementation of "user permissions".
214  */
215 contract Ownable {
216     address private _owner;
217 
218     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
219 
220     /**
221      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
222      * account.
223      */
224     constructor() internal {
225         _owner = msg.sender;
226         emit OwnershipTransferred(address(0), _owner);
227     }
228 
229     /**
230      * @return the address of the owner.
231      */
232     function owner() public view returns (address) {
233         return _owner;
234     }
235 
236     /**
237      * @dev Throws if called by any account other than the owner.
238      */
239     modifier onlyOwner() {
240         require(isOwner());
241         _;
242     }
243 
244     /**
245      * @return true if `msg.sender` is the owner of the contract.
246      */
247     function isOwner() public view returns (bool) {
248         return msg.sender == _owner;
249     }
250 
251     /**
252      * @dev Allows the current owner to relinquish control of the contract.
253      * It will not be possible to call the functions with the `onlyOwner`
254      * modifier anymore.
255      * @notice Renouncing ownership will leave the contract without an owner,
256      * thereby removing any functionality that is only available to the owner.
257      */
258     function renounceOwnership() public onlyOwner {
259         emit OwnershipTransferred(_owner, address(0));
260         _owner = address(0);
261     }
262 
263     /**
264      * @dev Allows the current owner to transfer control of the contract to a newOwner.
265      * @param newOwner The address to transfer ownership to.
266      */
267     function transferOwnership(address newOwner) public onlyOwner {
268         _transferOwnership(newOwner);
269     }
270 
271     /**
272      * @dev Transfers control of the contract to a newOwner.
273      * @param newOwner The address to transfer ownership to.
274      */
275     function _transferOwnership(address newOwner) internal {
276         require(newOwner != address(0));
277         emit OwnershipTransferred(_owner, newOwner);
278         _owner = newOwner;
279     }
280 }
281 
282 // File: contracts/common/misc/ProxyStorage.sol
283 
284 pragma solidity ^0.5.2;
285 
286 
287 contract ProxyStorage is Ownable {
288     address internal proxyTo;
289 }
290 
291 // File: contracts/common/misc/ERCProxy.sol
292 
293 /*
294  * SPDX-License-Identitifer:    MIT
295  */
296 
297 pragma solidity ^0.5.2;
298 
299 
300 // See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-897.md
301 
302 interface ERCProxy {
303     function proxyType() external pure returns (uint256 proxyTypeId);
304 
305     function implementation() external view returns (address codeAddr);
306 }
307 
308 // File: contracts/common/misc/DelegateProxy.sol
309 
310 pragma solidity ^0.5.2;
311 
312 
313 contract DelegateProxy is ERCProxy {
314     function proxyType() external pure returns (uint256 proxyTypeId) {
315         // Upgradeable proxy
316         proxyTypeId = 2;
317     }
318 
319     function implementation() external view returns (address);
320 
321     function delegatedFwd(address _dst, bytes memory _calldata) internal {
322         // solium-disable-next-line security/no-inline-assembly
323         assembly {
324             let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
325             let size := returndatasize
326 
327             let ptr := mload(0x40)
328             returndatacopy(ptr, 0, size)
329 
330             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
331             // if the call returned error data, forward it
332             switch result
333                 case 0 {
334                     revert(ptr, size)
335                 }
336                 default {
337                     return(ptr, size)
338                 }
339         }
340     }
341 }
342 
343 // File: contracts/common/misc/Proxy.sol
344 
345 pragma solidity ^0.5.2;
346 
347 
348 contract Proxy is ProxyStorage, DelegateProxy {
349     event ProxyUpdated(address indexed _new, address indexed _old);
350     event OwnerUpdate(address _prevOwner, address _newOwner);
351 
352     constructor(address _proxyTo) public {
353         updateImplementation(_proxyTo);
354     }
355 
356     function() external payable {
357         // require(currentContract != 0, "If app code has not been set yet, do not call");
358         // Todo: filter out some calls or handle in the end fallback
359         delegatedFwd(proxyTo, msg.data);
360     }
361 
362     function implementation() external view returns (address) {
363         return proxyTo;
364     }
365 
366     function updateImplementation(address _newProxyTo) public onlyOwner {
367         require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
368         require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
369         emit ProxyUpdated(_newProxyTo, proxyTo);
370         proxyTo = _newProxyTo;
371     }
372 
373     function isContract(address _target) internal view returns (bool) {
374         if (_target == address(0)) {
375             return false;
376         }
377 
378         uint256 size;
379         assembly {
380             size := extcodesize(_target)
381         }
382         return size > 0;
383     }
384 }
385 
386 // File: solidity-rlp/contracts/RLPReader.sol
387 
388 /*
389  * @author Hamdi Allam hamdi.allam97@gmail.com
390  * Please reach out with any questions or concerns
391  */
392 pragma solidity ^0.5.0;
393 
394 
395 library RLPReader {
396     uint8 constant STRING_SHORT_START = 0x80;
397     uint8 constant STRING_LONG_START = 0xb8;
398     uint8 constant LIST_SHORT_START = 0xc0;
399     uint8 constant LIST_LONG_START = 0xf8;
400     uint8 constant WORD_SIZE = 32;
401 
402     struct RLPItem {
403         uint256 len;
404         uint256 memPtr;
405     }
406 
407     struct Iterator {
408         RLPItem item; // Item that's being iterated over.
409         uint256 nextPtr; // Position of the next item in the list.
410     }
411 
412     /*
413      * @dev Returns the next element in the iteration. Reverts if it has not next element.
414      * @param self The iterator.
415      * @return The next element in the iteration.
416      */
417     function next(Iterator memory self) internal pure returns (RLPItem memory) {
418         require(hasNext(self));
419 
420         uint256 ptr = self.nextPtr;
421         uint256 itemLength = _itemLength(ptr);
422         self.nextPtr = ptr + itemLength;
423 
424         return RLPItem(itemLength, ptr);
425     }
426 
427     /*
428      * @dev Returns true if the iteration has more elements.
429      * @param self The iterator.
430      * @return true if the iteration has more elements.
431      */
432     function hasNext(Iterator memory self) internal pure returns (bool) {
433         RLPItem memory item = self.item;
434         return self.nextPtr < item.memPtr + item.len;
435     }
436 
437     /*
438      * @param item RLP encoded bytes
439      */
440     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
441         uint256 memPtr;
442         assembly {
443             memPtr := add(item, 0x20)
444         }
445 
446         return RLPItem(item.length, memPtr);
447     }
448 
449     /*
450      * @dev Create an iterator. Reverts if item is not a list.
451      * @param self The RLP item.
452      * @return An 'Iterator' over the item.
453      */
454     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
455         require(isList(self));
456 
457         uint256 ptr = self.memPtr + _payloadOffset(self.memPtr);
458         return Iterator(self, ptr);
459     }
460 
461     /*
462      * @param item RLP encoded bytes
463      */
464     function rlpLen(RLPItem memory item) internal pure returns (uint256) {
465         return item.len;
466     }
467 
468     /*
469      * @param item RLP encoded bytes
470      */
471     function payloadLen(RLPItem memory item) internal pure returns (uint256) {
472         return item.len - _payloadOffset(item.memPtr);
473     }
474 
475     /*
476      * @param item RLP encoded list in bytes
477      */
478     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
479         require(isList(item));
480 
481         uint256 items = numItems(item);
482         RLPItem[] memory result = new RLPItem[](items);
483 
484         uint256 memPtr = item.memPtr + _payloadOffset(item.memPtr);
485         uint256 dataLen;
486         for (uint256 i = 0; i < items; i++) {
487             dataLen = _itemLength(memPtr);
488             result[i] = RLPItem(dataLen, memPtr);
489             memPtr = memPtr + dataLen;
490         }
491 
492         return result;
493     }
494 
495     // @return indicator whether encoded payload is a list. negate this function call for isData.
496     function isList(RLPItem memory item) internal pure returns (bool) {
497         if (item.len == 0) return false;
498 
499         uint8 byte0;
500         uint256 memPtr = item.memPtr;
501         assembly {
502             byte0 := byte(0, mload(memPtr))
503         }
504 
505         if (byte0 < LIST_SHORT_START) return false;
506         return true;
507     }
508 
509     /** RLPItem conversions into data types **/
510 
511     // @returns raw rlp encoding in bytes
512     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
513         bytes memory result = new bytes(item.len);
514         if (result.length == 0) return result;
515 
516         uint256 ptr;
517         assembly {
518             ptr := add(0x20, result)
519         }
520 
521         copy(item.memPtr, ptr, item.len);
522         return result;
523     }
524 
525     // any non-zero byte is considered true
526     function toBoolean(RLPItem memory item) internal pure returns (bool) {
527         require(item.len == 1);
528         uint256 result;
529         uint256 memPtr = item.memPtr;
530         assembly {
531             result := byte(0, mload(memPtr))
532         }
533 
534         return result == 0 ? false : true;
535     }
536 
537     function toAddress(RLPItem memory item) internal pure returns (address) {
538         // 1 byte for the length prefix
539         require(item.len == 21);
540 
541         return address(toUint(item));
542     }
543 
544     function toUint(RLPItem memory item) internal pure returns (uint256) {
545         require(item.len > 0 && item.len <= 33);
546 
547         uint256 offset = _payloadOffset(item.memPtr);
548         uint256 len = item.len - offset;
549 
550         uint256 result;
551         uint256 memPtr = item.memPtr + offset;
552         assembly {
553             result := mload(memPtr)
554 
555             // shfit to the correct location if neccesary
556             if lt(len, 32) {
557                 result := div(result, exp(256, sub(32, len)))
558             }
559         }
560 
561         return result;
562     }
563 
564     // enforces 32 byte length
565     function toUintStrict(RLPItem memory item) internal pure returns (uint256) {
566         // one byte prefix
567         require(item.len == 33);
568 
569         uint256 result;
570         uint256 memPtr = item.memPtr + 1;
571         assembly {
572             result := mload(memPtr)
573         }
574 
575         return result;
576     }
577 
578     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
579         require(item.len > 0);
580 
581         uint256 offset = _payloadOffset(item.memPtr);
582         uint256 len = item.len - offset; // data length
583         bytes memory result = new bytes(len);
584 
585         uint256 destPtr;
586         assembly {
587             destPtr := add(0x20, result)
588         }
589 
590         copy(item.memPtr + offset, destPtr, len);
591         return result;
592     }
593 
594     /*
595      * Private Helpers
596      */
597 
598     // @return number of payload items inside an encoded list.
599     function numItems(RLPItem memory item) private pure returns (uint256) {
600         if (item.len == 0) return 0;
601 
602         uint256 count = 0;
603         uint256 currPtr = item.memPtr + _payloadOffset(item.memPtr);
604         uint256 endPtr = item.memPtr + item.len;
605         while (currPtr < endPtr) {
606             currPtr = currPtr + _itemLength(currPtr); // skip over an item
607             count++;
608         }
609 
610         return count;
611     }
612 
613     // @return entire rlp item byte length
614     function _itemLength(uint256 memPtr) private pure returns (uint256) {
615         uint256 itemLen;
616         uint256 byte0;
617         assembly {
618             byte0 := byte(0, mload(memPtr))
619         }
620 
621         if (byte0 < STRING_SHORT_START) itemLen = 1;
622         else if (byte0 < STRING_LONG_START) itemLen = byte0 - STRING_SHORT_START + 1;
623         else if (byte0 < LIST_SHORT_START) {
624             assembly {
625                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
626                 memPtr := add(memPtr, 1) // skip over the first byte
627 
628                 /* 32 byte word size */
629                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
630                 itemLen := add(dataLen, add(byteLen, 1))
631             }
632         } else if (byte0 < LIST_LONG_START) {
633             itemLen = byte0 - LIST_SHORT_START + 1;
634         } else {
635             assembly {
636                 let byteLen := sub(byte0, 0xf7)
637                 memPtr := add(memPtr, 1)
638 
639                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
640                 itemLen := add(dataLen, add(byteLen, 1))
641             }
642         }
643 
644         return itemLen;
645     }
646 
647     // @return number of bytes until the data
648     function _payloadOffset(uint256 memPtr) private pure returns (uint256) {
649         uint256 byte0;
650         assembly {
651             byte0 := byte(0, mload(memPtr))
652         }
653 
654         if (byte0 < STRING_SHORT_START) return 0;
655         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START)) return 1;
656         else if (byte0 < LIST_SHORT_START)
657             // being explicit
658             return byte0 - (STRING_LONG_START - 1) + 1;
659         else return byte0 - (LIST_LONG_START - 1) + 1;
660     }
661 
662     /*
663      * @param src Pointer to source
664      * @param dest Pointer to destination
665      * @param len Amount of memory to copy from the source
666      */
667     function copy(
668         uint256 src,
669         uint256 dest,
670         uint256 len
671     ) private pure {
672         if (len == 0) return;
673 
674         // copy as many word sizes as possible
675         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
676             assembly {
677                 mstore(dest, mload(src))
678             }
679 
680             src += WORD_SIZE;
681             dest += WORD_SIZE;
682         }
683 
684         // left over bytes. Mask is used to remove unwanted bytes from the word
685         uint256 mask = 256**(WORD_SIZE - len) - 1;
686         assembly {
687             let srcpart := and(mload(src), not(mask)) // zero out src
688             let destpart := and(mload(dest), mask) // retrieve the bytes
689             mstore(dest, or(destpart, srcpart))
690         }
691     }
692 }
693 
694 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
695 
696 pragma solidity ^0.5.2;
697 
698 
699 /**
700  * @title SafeMath
701  * @dev Unsigned math operations with safety checks that revert on error
702  */
703 library SafeMath {
704     /**
705      * @dev Multiplies two unsigned integers, reverts on overflow.
706      */
707     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
708         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
709         // benefit is lost if 'b' is also tested.
710         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
711         if (a == 0) {
712             return 0;
713         }
714 
715         uint256 c = a * b;
716         require(c / a == b);
717 
718         return c;
719     }
720 
721     /**
722      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
723      */
724     function div(uint256 a, uint256 b) internal pure returns (uint256) {
725         // Solidity only automatically asserts when dividing by 0
726         require(b > 0);
727         uint256 c = a / b;
728         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
729 
730         return c;
731     }
732 
733     /**
734      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
735      */
736     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
737         require(b <= a);
738         uint256 c = a - b;
739 
740         return c;
741     }
742 
743     /**
744      * @dev Adds two unsigned integers, reverts on overflow.
745      */
746     function add(uint256 a, uint256 b) internal pure returns (uint256) {
747         uint256 c = a + b;
748         require(c >= a);
749 
750         return c;
751     }
752 
753     /**
754      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
755      * reverts when dividing by zero.
756      */
757     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
758         require(b != 0);
759         return a % b;
760     }
761 }
762 
763 // File: contracts/common/mixin/ChainIdMixin.sol
764 
765 pragma solidity ^0.5.2;
766 
767 
768 contract ChainIdMixin {
769     bytes public constant networkId = hex"89";
770     uint256 public constant CHAINID = 137;
771 }
772 
773 // File: contracts/root/RootChainStorage.sol
774 
775 pragma solidity ^0.5.2;
776 
777 
778 contract RootChainHeader {
779     event NewHeaderBlock(
780         address indexed proposer,
781         uint256 indexed headerBlockId,
782         uint256 indexed reward,
783         uint256 start,
784         uint256 end,
785         bytes32 root
786     );
787     // housekeeping event
788     event ResetHeaderBlock(address indexed proposer, uint256 indexed headerBlockId);
789     struct HeaderBlock {
790         bytes32 root;
791         uint256 start;
792         uint256 end;
793         uint256 createdAt;
794         address proposer;
795     }
796 }
797 
798 
799 contract RootChainStorage is ProxyStorage, RootChainHeader, ChainIdMixin {
800     bytes32 public heimdallId;
801     uint8 public constant VOTE_TYPE = 2;
802 
803     uint16 internal constant MAX_DEPOSITS = 10000;
804     uint256 public _nextHeaderBlock = MAX_DEPOSITS;
805     uint256 internal _blockDepositId = 1;
806     mapping(uint256 => HeaderBlock) public headerBlocks;
807     Registry internal registry;
808 }
809 
810 // File: contracts/staking/stakeManager/IStakeManager.sol
811 
812 pragma solidity ^0.5.2;
813 
814 
815 contract IStakeManager {
816     // validator replacement
817     function startAuction(uint256 validatorId, uint256 amount) external;
818 
819     function confirmAuctionBid(
820         uint256 validatorId,
821         uint256 heimdallFee,
822         bool acceptDelegation,
823         bytes calldata signerPubkey
824     ) external;
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
838     function stake(
839         uint256 amount,
840         uint256 heimdallFee,
841         bool acceptDelegation,
842         bytes calldata signerPubkey
843     ) external;
844 
845     function unstake(uint256 validatorId) external;
846 
847     function totalStakedFor(address addr) external view returns (uint256);
848 
849     function supportsHistory() external pure returns (bool);
850 
851     function stakeFor(
852         address user,
853         uint256 amount,
854         uint256 heimdallFee,
855         bool acceptDelegation,
856         bytes memory signerPubkey
857     ) public;
858 
859     function checkSignatures(
860         uint256 blockInterval,
861         bytes32 voteHash,
862         bytes32 stateRoot,
863         address proposer,
864         bytes memory sigs
865     ) public returns (uint256);
866 
867     function updateValidatorState(uint256 validatorId, int256 amount) public;
868 
869     function ownerOf(uint256 tokenId) public view returns (address);
870 
871     function slash(bytes memory slashingInfoList) public returns (uint256);
872 
873     function validatorStake(uint256 validatorId) public view returns (uint256);
874 
875     function epoch() public view returns (uint256);
876 
877     function withdrawalDelay() public view returns (uint256);
878 }
879 
880 // File: contracts/root/IRootChain.sol
881 
882 pragma solidity ^0.5.2;
883 
884 
885 interface IRootChain {
886     function slash() external;
887 
888     function submitHeaderBlock(bytes calldata data, bytes calldata sigs) external;
889 
890     function getLastChildBlock() external view returns (uint256);
891 
892     function currentHeaderBlock() external view returns (uint256);
893 }
894 
895 // File: contracts/root/RootChain.sol
896 
897 pragma solidity ^0.5.2;
898 
899 
900 contract RootChain is RootChainStorage, IRootChain {
901     using SafeMath for uint256;
902     using RLPReader for bytes;
903     using RLPReader for RLPReader.RLPItem;
904 
905     modifier onlyDepositManager() {
906         require(msg.sender == registry.getDepositManagerAddress(), "UNAUTHORIZED_DEPOSIT_MANAGER_ONLY");
907         _;
908     }
909 
910     function submitHeaderBlock(bytes calldata data, bytes calldata sigs) external {
911         (address proposer, uint256 start, uint256 end, bytes32 rootHash, bytes32 accountHash, uint256 _borChainID) = abi
912             .decode(data, (address, uint256, uint256, bytes32, bytes32, uint256));
913         require(CHAINID == _borChainID, "Invalid bor chain id");
914 
915         require(_buildHeaderBlock(proposer, start, end, rootHash), "INCORRECT_HEADER_DATA");
916 
917         // check if it is better to keep it in local storage instead
918         IStakeManager stakeManager = IStakeManager(registry.getStakeManagerAddress());
919         uint256 _reward = stakeManager.checkSignatures(
920             end.sub(start).add(1),
921             /**  
922                 prefix 01 to data 
923                 01 represents positive vote on data and 00 is negative vote
924                 malicious validator can try to send 2/3 on negative vote so 01 is appended
925              */
926             keccak256(abi.encodePacked(bytes(hex"01"), data)),
927             accountHash,
928             proposer,
929             sigs
930         );
931 
932         require(_reward != 0, "Invalid checkpoint");
933         emit NewHeaderBlock(proposer, _nextHeaderBlock, _reward, start, end, rootHash);
934         _nextHeaderBlock = _nextHeaderBlock.add(MAX_DEPOSITS);
935         _blockDepositId = 1;
936     }
937 
938     function updateDepositId(uint256 numDeposits) external onlyDepositManager returns (uint256 depositId) {
939         depositId = currentHeaderBlock().add(_blockDepositId);
940         // deposit ids will be (_blockDepositId, _blockDepositId + 1, .... _blockDepositId + numDeposits - 1)
941         _blockDepositId = _blockDepositId.add(numDeposits);
942         require(
943             // Since _blockDepositId is initialized to 1; only (MAX_DEPOSITS - 1) deposits per header block are allowed
944             _blockDepositId <= MAX_DEPOSITS,
945             "TOO_MANY_DEPOSITS"
946         );
947     }
948 
949     function getLastChildBlock() external view returns (uint256) {
950         return headerBlocks[currentHeaderBlock()].end;
951     }
952 
953     function slash() external {
954         //TODO: future implementation
955     }
956 
957     function currentHeaderBlock() public view returns (uint256) {
958         return _nextHeaderBlock.sub(MAX_DEPOSITS);
959     }
960 
961     function _buildHeaderBlock(
962         address proposer,
963         uint256 start,
964         uint256 end,
965         bytes32 rootHash
966     ) private returns (bool) {
967         uint256 nextChildBlock;
968         /*
969     The ID of the 1st header block is MAX_DEPOSITS.
970     if _nextHeaderBlock == MAX_DEPOSITS, then the first header block is yet to be submitted, hence nextChildBlock = 0
971     */
972         if (_nextHeaderBlock > MAX_DEPOSITS) {
973             nextChildBlock = headerBlocks[currentHeaderBlock()].end + 1;
974         }
975         if (nextChildBlock != start) {
976             return false;
977         }
978 
979         HeaderBlock memory headerBlock = HeaderBlock({
980             root: rootHash,
981             start: nextChildBlock,
982             end: end,
983             createdAt: now,
984             proposer: proposer
985         });
986 
987         headerBlocks[_nextHeaderBlock] = headerBlock;
988         return true;
989     }
990 
991     // Housekeeping function. @todo remove later
992     function setNextHeaderBlock(uint256 _value) public onlyOwner {
993         require(_value % MAX_DEPOSITS == 0, "Invalid value");
994         for (uint256 i = _value; i < _nextHeaderBlock; i += MAX_DEPOSITS) {
995             delete headerBlocks[i];
996         }
997         _nextHeaderBlock = _value;
998         _blockDepositId = 1;
999         emit ResetHeaderBlock(msg.sender, _nextHeaderBlock);
1000     }
1001 
1002     // Housekeeping function. @todo remove later
1003     function setHeimdallId(string memory _heimdallId) public onlyOwner {
1004         heimdallId = keccak256(abi.encodePacked(_heimdallId));
1005     }
1006 }
1007 
1008 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
1009 
1010 pragma solidity ^0.5.2;
1011 
1012 
1013 /**
1014  * @title IERC165
1015  * @dev https://eips.ethereum.org/EIPS/eip-165
1016  */
1017 interface IERC165 {
1018     /**
1019      * @notice Query if a contract implements an interface
1020      * @param interfaceId The interface identifier, as specified in ERC-165
1021      * @dev Interface identification is specified in ERC-165. This function
1022      * uses less than 30,000 gas.
1023      */
1024     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1025 }
1026 
1027 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
1028 
1029 pragma solidity ^0.5.2;
1030 
1031 
1032 /**
1033  * @title ERC721 Non-Fungible Token Standard basic interface
1034  * @dev see https://eips.ethereum.org/EIPS/eip-721
1035  */
1036 contract IERC721 is IERC165 {
1037     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1038     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1039     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1040 
1041     function balanceOf(address owner) public view returns (uint256 balance);
1042 
1043     function ownerOf(uint256 tokenId) public view returns (address owner);
1044 
1045     function approve(address to, uint256 tokenId) public;
1046 
1047     function getApproved(uint256 tokenId) public view returns (address operator);
1048 
1049     function setApprovalForAll(address operator, bool _approved) public;
1050 
1051     function isApprovedForAll(address owner, address operator) public view returns (bool);
1052 
1053     function transferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) public;
1058 
1059     function safeTransferFrom(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) public;
1064 
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory data
1070     ) public;
1071 }
1072 
1073 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
1074 
1075 pragma solidity ^0.5.2;
1076 
1077 
1078 /**
1079  * @title ERC721 token receiver interface
1080  * @dev Interface for any contract that wants to support safeTransfers
1081  * from ERC721 asset contracts.
1082  */
1083 contract IERC721Receiver {
1084     /**
1085      * @notice Handle the receipt of an NFT
1086      * @dev The ERC721 smart contract calls this function on the recipient
1087      * after a `safeTransfer`. This function MUST return the function selector,
1088      * otherwise the caller will revert the transaction. The selector to be
1089      * returned can be obtained as `this.onERC721Received.selector`. This
1090      * function MAY throw to revert and reject the transfer.
1091      * Note: the ERC721 contract address is always the message sender.
1092      * @param operator The address which called `safeTransferFrom` function
1093      * @param from The address which previously owned the token
1094      * @param tokenId The NFT identifier which is being transferred
1095      * @param data Additional data with no specified format
1096      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1097      */
1098     function onERC721Received(
1099         address operator,
1100         address from,
1101         uint256 tokenId,
1102         bytes memory data
1103     ) public returns (bytes4);
1104 }
1105 
1106 // File: openzeppelin-solidity/contracts/utils/Address.sol
1107 
1108 pragma solidity ^0.5.2;
1109 
1110 
1111 /**
1112  * Utility library of inline functions on addresses
1113  */
1114 library Address {
1115     /**
1116      * Returns whether the target address is a contract
1117      * @dev This function will return false if invoked during the constructor of a contract,
1118      * as the code is not actually created until after the constructor finishes.
1119      * @param account address of the account to check
1120      * @return whether the target address is a contract
1121      */
1122     function isContract(address account) internal view returns (bool) {
1123         uint256 size;
1124         // XXX Currently there is no better way to check if there is a contract in an address
1125         // than to check the size of the code at that address.
1126         // See https://ethereum.stackexchange.com/a/14016/36603
1127         // for more details about how this works.
1128         // TODO Check this again before the Serenity release, because all addresses will be
1129         // contracts then.
1130         // solhint-disable-next-line no-inline-assembly
1131         assembly {
1132             size := extcodesize(account)
1133         }
1134         return size > 0;
1135     }
1136 }
1137 
1138 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
1139 
1140 pragma solidity ^0.5.2;
1141 
1142 
1143 /**
1144  * @title Counters
1145  * @author Matt Condon (@shrugs)
1146  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1147  * of elements in a mapping, issuing ERC721 ids, or counting request ids
1148  *
1149  * Include with `using Counters for Counters.Counter;`
1150  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
1151  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1152  * directly accessed.
1153  */
1154 library Counters {
1155     using SafeMath for uint256;
1156 
1157     struct Counter {
1158         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1159         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1160         // this feature: see https://github.com/ethereum/solidity/issues/4637
1161         uint256 _value; // default: 0
1162     }
1163 
1164     function current(Counter storage counter) internal view returns (uint256) {
1165         return counter._value;
1166     }
1167 
1168     function increment(Counter storage counter) internal {
1169         counter._value += 1;
1170     }
1171 
1172     function decrement(Counter storage counter) internal {
1173         counter._value = counter._value.sub(1);
1174     }
1175 }
1176 
1177 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
1178 
1179 pragma solidity ^0.5.2;
1180 
1181 
1182 /**
1183  * @title ERC165
1184  * @author Matt Condon (@shrugs)
1185  * @dev Implements ERC165 using a lookup table.
1186  */
1187 contract ERC165 is IERC165 {
1188     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1189     /*
1190      * 0x01ffc9a7 ===
1191      *     bytes4(keccak256('supportsInterface(bytes4)'))
1192      */
1193 
1194     /**
1195      * @dev a mapping of interface id to whether or not it's supported
1196      */
1197     mapping(bytes4 => bool) private _supportedInterfaces;
1198 
1199     /**
1200      * @dev A contract implementing SupportsInterfaceWithLookup
1201      * implement ERC165 itself
1202      */
1203     constructor() internal {
1204         _registerInterface(_INTERFACE_ID_ERC165);
1205     }
1206 
1207     /**
1208      * @dev implement supportsInterface(bytes4) using a lookup table
1209      */
1210     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
1211         return _supportedInterfaces[interfaceId];
1212     }
1213 
1214     /**
1215      * @dev internal method for registering an interface
1216      */
1217     function _registerInterface(bytes4 interfaceId) internal {
1218         require(interfaceId != 0xffffffff);
1219         _supportedInterfaces[interfaceId] = true;
1220     }
1221 }
1222 
1223 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
1224 
1225 pragma solidity ^0.5.2;
1226 
1227 
1228 /**
1229  * @title ERC721 Non-Fungible Token Standard basic implementation
1230  * @dev see https://eips.ethereum.org/EIPS/eip-721
1231  */
1232 contract ERC721 is ERC165, IERC721 {
1233     using SafeMath for uint256;
1234     using Address for address;
1235     using Counters for Counters.Counter;
1236 
1237     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1238     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1239     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1240 
1241     // Mapping from token ID to owner
1242     mapping(uint256 => address) private _tokenOwner;
1243 
1244     // Mapping from token ID to approved address
1245     mapping(uint256 => address) private _tokenApprovals;
1246 
1247     // Mapping from owner to number of owned token
1248     mapping(address => Counters.Counter) private _ownedTokensCount;
1249 
1250     // Mapping from owner to operator approvals
1251     mapping(address => mapping(address => bool)) private _operatorApprovals;
1252 
1253     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1254 
1255     /*
1256      * 0x80ac58cd ===
1257      *     bytes4(keccak256('balanceOf(address)')) ^
1258      *     bytes4(keccak256('ownerOf(uint256)')) ^
1259      *     bytes4(keccak256('approve(address,uint256)')) ^
1260      *     bytes4(keccak256('getApproved(uint256)')) ^
1261      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1262      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
1263      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1264      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1265      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1266      */
1267 
1268     constructor() public {
1269         // register the supported interfaces to conform to ERC721 via ERC165
1270         _registerInterface(_INTERFACE_ID_ERC721);
1271     }
1272 
1273     /**
1274      * @dev Gets the balance of the specified address
1275      * @param owner address to query the balance of
1276      * @return uint256 representing the amount owned by the passed address
1277      */
1278     function balanceOf(address owner) public view returns (uint256) {
1279         require(owner != address(0));
1280         return _ownedTokensCount[owner].current();
1281     }
1282 
1283     /**
1284      * @dev Gets the owner of the specified token ID
1285      * @param tokenId uint256 ID of the token to query the owner of
1286      * @return address currently marked as the owner of the given token ID
1287      */
1288     function ownerOf(uint256 tokenId) public view returns (address) {
1289         address owner = _tokenOwner[tokenId];
1290         require(owner != address(0));
1291         return owner;
1292     }
1293 
1294     /**
1295      * @dev Approves another address to transfer the given token ID
1296      * The zero address indicates there is no approved address.
1297      * There can only be one approved address per token at a given time.
1298      * Can only be called by the token owner or an approved operator.
1299      * @param to address to be approved for the given token ID
1300      * @param tokenId uint256 ID of the token to be approved
1301      */
1302     function approve(address to, uint256 tokenId) public {
1303         address owner = ownerOf(tokenId);
1304         require(to != owner);
1305         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1306 
1307         _tokenApprovals[tokenId] = to;
1308         emit Approval(owner, to, tokenId);
1309     }
1310 
1311     /**
1312      * @dev Gets the approved address for a token ID, or zero if no address set
1313      * Reverts if the token ID does not exist.
1314      * @param tokenId uint256 ID of the token to query the approval of
1315      * @return address currently approved for the given token ID
1316      */
1317     function getApproved(uint256 tokenId) public view returns (address) {
1318         require(_exists(tokenId));
1319         return _tokenApprovals[tokenId];
1320     }
1321 
1322     /**
1323      * @dev Sets or unsets the approval of a given operator
1324      * An operator is allowed to transfer all tokens of the sender on their behalf
1325      * @param to operator address to set the approval
1326      * @param approved representing the status of the approval to be set
1327      */
1328     function setApprovalForAll(address to, bool approved) public {
1329         require(to != msg.sender);
1330         _operatorApprovals[msg.sender][to] = approved;
1331         emit ApprovalForAll(msg.sender, to, approved);
1332     }
1333 
1334     /**
1335      * @dev Tells whether an operator is approved by a given owner
1336      * @param owner owner address which you want to query the approval of
1337      * @param operator operator address which you want to query the approval of
1338      * @return bool whether the given operator is approved by the given owner
1339      */
1340     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1341         return _operatorApprovals[owner][operator];
1342     }
1343 
1344     /**
1345      * @dev Transfers the ownership of a given token ID to another address
1346      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1347      * Requires the msg.sender to be the owner, approved, or operator
1348      * @param from current owner of the token
1349      * @param to address to receive the ownership of the given token ID
1350      * @param tokenId uint256 ID of the token to be transferred
1351      */
1352     function transferFrom(
1353         address from,
1354         address to,
1355         uint256 tokenId
1356     ) public {
1357         require(_isApprovedOrOwner(msg.sender, tokenId));
1358 
1359         _transferFrom(from, to, tokenId);
1360     }
1361 
1362     /**
1363      * @dev Safely transfers the ownership of a given token ID to another address
1364      * If the target address is a contract, it must implement `onERC721Received`,
1365      * which is called upon a safe transfer, and return the magic value
1366      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1367      * the transfer is reverted.
1368      * Requires the msg.sender to be the owner, approved, or operator
1369      * @param from current owner of the token
1370      * @param to address to receive the ownership of the given token ID
1371      * @param tokenId uint256 ID of the token to be transferred
1372      */
1373     function safeTransferFrom(
1374         address from,
1375         address to,
1376         uint256 tokenId
1377     ) public {
1378         safeTransferFrom(from, to, tokenId, "");
1379     }
1380 
1381     /**
1382      * @dev Safely transfers the ownership of a given token ID to another address
1383      * If the target address is a contract, it must implement `onERC721Received`,
1384      * which is called upon a safe transfer, and return the magic value
1385      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1386      * the transfer is reverted.
1387      * Requires the msg.sender to be the owner, approved, or operator
1388      * @param from current owner of the token
1389      * @param to address to receive the ownership of the given token ID
1390      * @param tokenId uint256 ID of the token to be transferred
1391      * @param _data bytes data to send along with a safe transfer check
1392      */
1393     function safeTransferFrom(
1394         address from,
1395         address to,
1396         uint256 tokenId,
1397         bytes memory _data
1398     ) public {
1399         transferFrom(from, to, tokenId);
1400         require(_checkOnERC721Received(from, to, tokenId, _data));
1401     }
1402 
1403     /**
1404      * @dev Returns whether the specified token exists
1405      * @param tokenId uint256 ID of the token to query the existence of
1406      * @return bool whether the token exists
1407      */
1408     function _exists(uint256 tokenId) internal view returns (bool) {
1409         address owner = _tokenOwner[tokenId];
1410         return owner != address(0);
1411     }
1412 
1413     /**
1414      * @dev Returns whether the given spender can transfer a given token ID
1415      * @param spender address of the spender to query
1416      * @param tokenId uint256 ID of the token to be transferred
1417      * @return bool whether the msg.sender is approved for the given token ID,
1418      * is an operator of the owner, or is the owner of the token
1419      */
1420     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1421         address owner = ownerOf(tokenId);
1422         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1423     }
1424 
1425     /**
1426      * @dev Internal function to mint a new token
1427      * Reverts if the given token ID already exists
1428      * @param to The address that will own the minted token
1429      * @param tokenId uint256 ID of the token to be minted
1430      */
1431     function _mint(address to, uint256 tokenId) internal {
1432         require(to != address(0));
1433         require(!_exists(tokenId));
1434 
1435         _tokenOwner[tokenId] = to;
1436         _ownedTokensCount[to].increment();
1437 
1438         emit Transfer(address(0), to, tokenId);
1439     }
1440 
1441     /**
1442      * @dev Internal function to burn a specific token
1443      * Reverts if the token does not exist
1444      * Deprecated, use _burn(uint256) instead.
1445      * @param owner owner of the token to burn
1446      * @param tokenId uint256 ID of the token being burned
1447      */
1448     function _burn(address owner, uint256 tokenId) internal {
1449         require(ownerOf(tokenId) == owner);
1450 
1451         _clearApproval(tokenId);
1452 
1453         _ownedTokensCount[owner].decrement();
1454         _tokenOwner[tokenId] = address(0);
1455 
1456         emit Transfer(owner, address(0), tokenId);
1457     }
1458 
1459     /**
1460      * @dev Internal function to burn a specific token
1461      * Reverts if the token does not exist
1462      * @param tokenId uint256 ID of the token being burned
1463      */
1464     function _burn(uint256 tokenId) internal {
1465         _burn(ownerOf(tokenId), tokenId);
1466     }
1467 
1468     /**
1469      * @dev Internal function to transfer ownership of a given token ID to another address.
1470      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1471      * @param from current owner of the token
1472      * @param to address to receive the ownership of the given token ID
1473      * @param tokenId uint256 ID of the token to be transferred
1474      */
1475     function _transferFrom(
1476         address from,
1477         address to,
1478         uint256 tokenId
1479     ) internal {
1480         require(ownerOf(tokenId) == from);
1481         require(to != address(0));
1482 
1483         _clearApproval(tokenId);
1484 
1485         _ownedTokensCount[from].decrement();
1486         _ownedTokensCount[to].increment();
1487 
1488         _tokenOwner[tokenId] = to;
1489 
1490         emit Transfer(from, to, tokenId);
1491     }
1492 
1493     /**
1494      * @dev Internal function to invoke `onERC721Received` on a target address
1495      * The call is not executed if the target address is not a contract
1496      * @param from address representing the previous owner of the given token ID
1497      * @param to target address that will receive the tokens
1498      * @param tokenId uint256 ID of the token to be transferred
1499      * @param _data bytes optional data to send along with the call
1500      * @return bool whether the call correctly returned the expected magic value
1501      */
1502     function _checkOnERC721Received(
1503         address from,
1504         address to,
1505         uint256 tokenId,
1506         bytes memory _data
1507     ) internal returns (bool) {
1508         if (!to.isContract()) {
1509             return true;
1510         }
1511 
1512         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1513         return (retval == _ERC721_RECEIVED);
1514     }
1515 
1516     /**
1517      * @dev Private function to clear current approval of a given token ID
1518      * @param tokenId uint256 ID of the token to be transferred
1519      */
1520     function _clearApproval(uint256 tokenId) private {
1521         if (_tokenApprovals[tokenId] != address(0)) {
1522             _tokenApprovals[tokenId] = address(0);
1523         }
1524     }
1525 }
1526 
1527 // File: contracts/root/withdrawManager/ExitNFT.sol
1528 
1529 pragma solidity ^0.5.2;
1530 
1531 
1532 contract ExitNFT is ERC721 {
1533     Registry internal registry;
1534 
1535     modifier onlyWithdrawManager() {
1536         require(msg.sender == registry.getWithdrawManagerAddress(), "UNAUTHORIZED_WITHDRAW_MANAGER_ONLY");
1537         _;
1538     }
1539 
1540     constructor(address _registry) public {
1541         registry = Registry(_registry);
1542     }
1543 
1544     function mint(address _owner, uint256 _tokenId) external onlyWithdrawManager {
1545         _mint(_owner, _tokenId);
1546     }
1547 
1548     function burn(uint256 _tokenId) external onlyWithdrawManager {
1549         _burn(_tokenId);
1550     }
1551 
1552     function exists(uint256 tokenId) public view returns (bool) {
1553         return _exists(tokenId);
1554     }
1555 }
1556 
1557 // File: contracts/root/withdrawManager/WithdrawManagerStorage.sol
1558 
1559 pragma solidity ^0.5.2;
1560 
1561 
1562 contract ExitsDataStructure {
1563     struct Input {
1564         address utxoOwner;
1565         address predicate;
1566         address token;
1567     }
1568 
1569     struct PlasmaExit {
1570         uint256 receiptAmountOrNFTId;
1571         bytes32 txHash;
1572         address owner;
1573         address token;
1574         bool isRegularExit;
1575         address predicate;
1576         // Mapping from age of input to Input
1577         mapping(uint256 => Input) inputs;
1578     }
1579 }
1580 
1581 
1582 contract WithdrawManagerHeader is ExitsDataStructure {
1583     event Withdraw(uint256 indexed exitId, address indexed user, address indexed token, uint256 amount);
1584 
1585     event ExitStarted(
1586         address indexed exitor,
1587         uint256 indexed exitId,
1588         address indexed token,
1589         uint256 amount,
1590         bool isRegularExit
1591     );
1592 
1593     event ExitUpdated(uint256 indexed exitId, uint256 indexed age, address signer);
1594     event ExitPeriodUpdate(uint256 indexed oldExitPeriod, uint256 indexed newExitPeriod);
1595 
1596     event ExitCancelled(uint256 indexed exitId);
1597 }
1598 
1599 
1600 contract WithdrawManagerStorage is ProxyStorage, WithdrawManagerHeader {
1601     // 0.5 week = 7 * 86400 / 2 = 302400
1602     uint256 public HALF_EXIT_PERIOD = 302400;
1603 
1604     // Bonded exits collaterized at 0.1 ETH
1605     uint256 internal constant BOND_AMOUNT = 10**17;
1606 
1607     Registry internal registry;
1608     RootChain internal rootChain;
1609 
1610     mapping(uint128 => bool) isKnownExit;
1611     mapping(uint256 => PlasmaExit) public exits;
1612     // mapping with token => (owner => exitId) keccak(token+owner) keccak(token+owner+tokenId)
1613     mapping(bytes32 => uint256) public ownerExits;
1614     mapping(address => address) public exitsQueues;
1615     ExitNFT public exitNft;
1616 
1617     // ERC721, ERC20 and Weth transfers require 155000, 100000, 52000 gas respectively
1618     // Processing each exit in a while loop iteration requires ~52000 gas (@todo check if this changed)
1619     // uint32 constant internal ITERATION_GAS = 52000;
1620 
1621     // So putting an upper limit of 155000 + 52000 + leeway
1622     uint32 public ON_FINALIZE_GAS_LIMIT = 300000;
1623 
1624     uint256 public exitWindow;
1625 }
1626 
1627 // File: contracts/root/withdrawManager/WithdrawManagerProxy.sol
1628 
1629 pragma solidity ^0.5.2;
1630 
1631 
1632 contract WithdrawManagerProxy is Proxy, WithdrawManagerStorage {
1633     constructor(
1634         address _proxyTo,
1635         address _registry,
1636         address _rootChain,
1637         address _exitNft
1638     ) public Proxy(_proxyTo) {
1639         registry = Registry(_registry);
1640         rootChain = RootChain(_rootChain);
1641         exitNft = ExitNFT(_exitNft);
1642     }
1643 }