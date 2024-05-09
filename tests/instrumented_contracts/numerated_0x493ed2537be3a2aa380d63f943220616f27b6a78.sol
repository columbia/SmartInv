1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @title NEO TOKYO CENTRAL (Staking contract)
7  * @author 0xSumo
8  * @notice NEO TOKYO CENTRAL handles staking and unstaking of Neo Tokyo Punks and ROARS.
9  */
10 
11 /// OwnControll by 0xSumo
12 abstract contract OwnControll {
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14     event AdminSet(bytes32 indexed controllerType, bytes32 indexed controllerSlot, address indexed controller, bool status);
15     address public owner;
16     mapping(bytes32 => mapping(address => bool)) internal admin;
17     constructor() { owner = msg.sender; }
18     modifier onlyOwner() { require(owner == msg.sender, "only owner");_; }
19     modifier onlyAdmin(string memory type_) { require(isAdmin(type_, msg.sender), "only admin");_; }
20     function transferOwnership(address newOwner) external onlyOwner { emit OwnershipTransferred(owner, newOwner); owner = newOwner; }
21     function setAdmin(string calldata type_, address controller, bool status) external onlyOwner { bytes32 typeHash = keccak256(abi.encodePacked(type_)); admin[typeHash][controller] = status; emit AdminSet(typeHash, typeHash, controller, status); }
22     function isAdmin(string memory type_, address controller) public view returns (bool) { bytes32 typeHash = keccak256(abi.encodePacked(type_)); return admin[typeHash][controller]; }
23 }
24 
25 library RLPReader {
26     uint8 constant STRING_SHORT_START = 0x80;
27     uint8 constant STRING_LONG_START = 0xb8;
28     uint8 constant LIST_SHORT_START = 0xc0;
29     uint8 constant LIST_LONG_START = 0xf8;
30     uint8 constant WORD_SIZE = 32;
31 
32     struct RLPItem {
33         uint256 len;
34         uint256 memPtr;
35     }
36 
37     struct Iterator {
38         RLPItem item;
39         uint256 nextPtr;
40     }
41 
42     function next(Iterator memory self) internal pure returns (RLPItem memory) {
43         require(hasNext(self));
44         uint256 ptr = self.nextPtr;
45         uint256 itemLength = _itemLength(ptr);
46         self.nextPtr = ptr + itemLength;
47         return RLPItem(itemLength, ptr);
48     }
49 
50     function hasNext(Iterator memory self) internal pure returns (bool) {
51         RLPItem memory item = self.item;
52         return self.nextPtr < item.memPtr + item.len;
53     }
54 
55     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
56         uint256 memPtr;
57         assembly {
58             memPtr := add(item, 0x20)
59         }
60         return RLPItem(item.length, memPtr);
61     }
62 
63     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
64         require(isList(self));
65         uint256 ptr = self.memPtr + _payloadOffset(self.memPtr);
66         return Iterator(self, ptr);
67     }
68 
69     function rlpLen(RLPItem memory item) internal pure returns (uint256) {
70         return item.len;
71     }
72 
73     function payloadLen(RLPItem memory item) internal pure returns (uint256) {
74         return item.len - _payloadOffset(item.memPtr);
75     }
76 
77     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
78         require(isList(item));
79         uint256 items = numItems(item);
80         RLPItem[] memory result = new RLPItem[](items);
81         uint256 memPtr = item.memPtr + _payloadOffset(item.memPtr);
82         uint256 dataLen;
83         for (uint256 i = 0; i < items; i++) {
84             dataLen = _itemLength(memPtr);
85             result[i] = RLPItem(dataLen, memPtr);
86             memPtr = memPtr + dataLen;
87         }
88         return result;
89     }
90 
91     function isList(RLPItem memory item) internal pure returns (bool) {
92         if (item.len == 0) return false;
93 
94         uint8 byte0;
95         uint256 memPtr = item.memPtr;
96         assembly {
97             byte0 := byte(0, mload(memPtr))
98         }
99 
100         if (byte0 < LIST_SHORT_START) return false;
101         return true;
102     }
103 
104     function rlpBytesKeccak256(RLPItem memory item) internal pure returns (bytes32) {
105         uint256 ptr = item.memPtr;
106         uint256 len = item.len;
107         bytes32 result;
108         assembly {
109             result := keccak256(ptr, len)
110         }
111         return result;
112     }
113 
114     function payloadLocation(RLPItem memory item) internal pure returns (uint256, uint256) {
115         uint256 offset = _payloadOffset(item.memPtr);
116         uint256 memPtr = item.memPtr + offset;
117         uint256 len = item.len - offset; // data length
118         return (memPtr, len);
119     }
120 
121     function payloadKeccak256(RLPItem memory item) internal pure returns (bytes32) {
122         (uint256 memPtr, uint256 len) = payloadLocation(item);
123         bytes32 result;
124         assembly {
125             result := keccak256(memPtr, len)
126         }
127         return result;
128     }
129 
130     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
131         bytes memory result = new bytes(item.len);
132         if (result.length == 0) return result;
133         uint256 ptr;
134         assembly {
135             ptr := add(0x20, result)
136         }
137         copy(item.memPtr, ptr, item.len);
138         return result;
139     }
140 
141     function toBoolean(RLPItem memory item) internal pure returns (bool) {
142         require(item.len == 1);
143         uint256 result;
144         uint256 memPtr = item.memPtr;
145         assembly {
146             result := byte(0, mload(memPtr))
147         }
148 
149         return result == 0 ? false : true;
150     }
151 
152     function toAddress(RLPItem memory item) internal pure returns (address) {
153         require(item.len == 21);
154         return address(uint160(toUint(item)));
155     }
156 
157     function toUint(RLPItem memory item) internal pure returns (uint256) {
158         require(item.len > 0 && item.len <= 33);
159         uint256 offset = _payloadOffset(item.memPtr);
160         uint256 len = item.len - offset;
161         uint256 result;
162         uint256 memPtr = item.memPtr + offset;
163         assembly {
164             result := mload(memPtr)
165             if lt(len, 32) {
166                 result := div(result, exp(256, sub(32, len)))
167             }
168         }
169         return result;
170     }
171 
172     function toUintStrict(RLPItem memory item) internal pure returns (uint256) {
173         require(item.len == 33);
174         uint256 result;
175         uint256 memPtr = item.memPtr + 1;
176         assembly {
177             result := mload(memPtr)
178         }
179         return result;
180     }
181 
182     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
183         require(item.len > 0);
184         uint256 offset = _payloadOffset(item.memPtr);
185         uint256 len = item.len - offset;
186         bytes memory result = new bytes(len);
187         uint256 destPtr;
188         assembly {
189             destPtr := add(0x20, result)
190         }
191         copy(item.memPtr + offset, destPtr, len);
192         return result;
193     }
194 
195     function numItems(RLPItem memory item) private pure returns (uint256) {
196         if (item.len == 0) return 0;
197         uint256 count = 0;
198         uint256 currPtr = item.memPtr + _payloadOffset(item.memPtr);
199         uint256 endPtr = item.memPtr + item.len;
200         while (currPtr < endPtr) {
201             currPtr = currPtr + _itemLength(currPtr);
202             count++;
203         }
204         return count;
205     }
206 
207     function _itemLength(uint256 memPtr) private pure returns (uint256) {
208         uint256 itemLen;
209         uint256 byte0;
210         assembly {
211             byte0 := byte(0, mload(memPtr))
212         }
213         if (byte0 < STRING_SHORT_START) itemLen = 1;
214         else if (byte0 < STRING_LONG_START) itemLen = byte0 - STRING_SHORT_START + 1;
215         else if (byte0 < LIST_SHORT_START) {
216             assembly {
217                 let byteLen := sub(byte0, 0xb7)
218                 memPtr := add(memPtr, 1)
219                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen)))
220                 itemLen := add(dataLen, add(byteLen, 1))
221             }
222         } else if (byte0 < LIST_LONG_START) {
223             itemLen = byte0 - LIST_SHORT_START + 1;
224         } else {
225             assembly {
226                 let byteLen := sub(byte0, 0xf7)
227                 memPtr := add(memPtr, 1)
228                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen)))
229                 itemLen := add(dataLen, add(byteLen, 1))
230             }
231         }
232         return itemLen;
233     }
234 
235     function _payloadOffset(uint256 memPtr) private pure returns (uint256) {
236         uint256 byte0;
237         assembly {
238             byte0 := byte(0, mload(memPtr))
239         }
240         if (byte0 < STRING_SHORT_START) return 0;
241         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START)) return 1;
242         else if (byte0 < LIST_SHORT_START)
243             return byte0 - (STRING_LONG_START - 1) + 1;
244         else return byte0 - (LIST_LONG_START - 1) + 1;
245     }
246 
247     function copy(uint256 src, uint256 dest, uint256 len) private pure {
248         if (len == 0) return;
249         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
250             assembly {
251                 mstore(dest, mload(src))
252             }
253             src += WORD_SIZE;
254             dest += WORD_SIZE;
255         }
256         if (len == 0) return;
257         uint256 mask = 256**(WORD_SIZE - len) - 1;
258 
259         assembly {
260             let srcpart := and(mload(src), not(mask))
261             let destpart := and(mload(dest), mask)
262             mstore(dest, or(destpart, srcpart))
263         }
264     }
265 }
266 
267 library MerklePatriciaProof {
268     function verify(bytes memory value, bytes memory encodedPath, bytes memory rlpParentNodes, bytes32 root) internal pure returns (bool) {
269         RLPReader.RLPItem memory item = RLPReader.toRlpItem(rlpParentNodes);
270         RLPReader.RLPItem[] memory parentNodes = RLPReader.toList(item);
271         bytes memory currentNode;
272         RLPReader.RLPItem[] memory currentNodeList;
273         bytes32 nodeKey = root;
274         uint256 pathPtr = 0;
275         bytes memory path = _getNibbleArray(encodedPath);
276         if (path.length == 0) {
277             return false;
278         }
279         for (uint256 i = 0; i < parentNodes.length; i++) {
280             if (pathPtr > path.length) {
281                 return false;
282             }
283             currentNode = RLPReader.toRlpBytes(parentNodes[i]);
284             if (nodeKey != keccak256(currentNode)) {
285                 return false;
286             }
287             currentNodeList = RLPReader.toList(parentNodes[i]);
288             if (currentNodeList.length == 17) {
289                 if (pathPtr == path.length) {
290                     if (keccak256(RLPReader.toBytes(currentNodeList[16])) == keccak256(value)) {
291                         return true;
292                     } else {
293                         return false;
294                     }
295                 }
296                 uint8 nextPathNibble = uint8(path[pathPtr]);
297                 if (nextPathNibble > 16) {
298                     return false;
299                 }
300                 nodeKey = bytes32(RLPReader.toUintStrict(currentNodeList[nextPathNibble]));
301                 pathPtr += 1;
302             } else if (currentNodeList.length == 2) {
303                 uint256 traversed = _nibblesToTraverse(RLPReader.toBytes(currentNodeList[0]), path, pathPtr);
304                 if (pathPtr + traversed == path.length) {
305                     if (keccak256(RLPReader.toBytes(currentNodeList[1])) == keccak256(value)) {
306                         return true;
307                     } else {
308                         return false;
309                     }
310                 }
311                 if (traversed == 0) {
312                     return false;
313                 }
314                 pathPtr += traversed;
315                 nodeKey = bytes32(RLPReader.toUintStrict(currentNodeList[1]));
316             } else {
317                 return false;
318             }
319         }
320     }
321 
322     function _nibblesToTraverse(bytes memory encodedPartialPath, bytes memory path, uint256 pathPtr) private pure returns (uint256) {
323         uint256 len = 0;
324         bytes memory partialPath = _getNibbleArray(encodedPartialPath);
325         bytes memory slicedPath = new bytes(partialPath.length);
326         for (uint256 i = pathPtr; i < pathPtr + partialPath.length; i++) {
327             bytes1 pathNibble = path[i];
328             slicedPath[i - pathPtr] = pathNibble;
329         }
330         if (keccak256(partialPath) == keccak256(slicedPath)) {
331             len = partialPath.length;
332         } else {
333             len = 0;
334         }
335         return len;
336     }
337 
338     function _getNibbleArray(bytes memory b) internal pure returns (bytes memory) {
339         bytes memory nibbles = "";
340         if (b.length > 0) {
341             uint8 offset;
342             uint8 hpNibble = uint8(_getNthNibbleOfBytes(0, b));
343             if (hpNibble == 1 || hpNibble == 3) {
344                 nibbles = new bytes(b.length * 2 - 1);
345                 bytes1 oddNibble = _getNthNibbleOfBytes(1, b);
346                 nibbles[0] = oddNibble;
347                 offset = 1;
348             } else {
349                 nibbles = new bytes(b.length * 2 - 2);
350                 offset = 0;
351             }
352 
353             for (uint256 i = offset; i < nibbles.length; i++) {
354                 nibbles[i] = _getNthNibbleOfBytes(i - offset + 2, b);
355             }
356         }
357         return nibbles;
358     }
359 
360     function _getNthNibbleOfBytes(uint256 n, bytes memory str) private pure returns (bytes1) {
361         return bytes1(n % 2 == 0 ? uint8(str[n / 2]) / 0x10 : uint8(str[n / 2]) % 0x10);
362     }
363 }
364 
365 library Merkle {
366     function checkMembership(bytes32 leaf, uint256 index, bytes32 rootHash, bytes memory proof) internal pure returns (bool) {
367         require(proof.length % 32 == 0, "Invalid proof length");
368         uint256 proofHeight = proof.length / 32;
369         require(index < 2**proofHeight, "Leaf index is too big");
370         bytes32 proofElement;
371         bytes32 computedHash = leaf;
372         for (uint256 i = 32; i <= proof.length; i += 32) {
373             assembly {
374                 proofElement := mload(add(proof, i))
375             }
376             if (index % 2 == 0) {
377                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
378             } else {
379                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
380             }
381             index = index / 2;
382         }
383         return computedHash == rootHash;
384     }
385 }
386 
387 library ExitPayloadReader {
388     using RLPReader for bytes;
389     using RLPReader for RLPReader.RLPItem;
390 
391     uint8 constant WORD_SIZE = 32;
392 
393     struct ExitPayload {
394         RLPReader.RLPItem[] data;
395     }
396 
397     struct Receipt {
398         RLPReader.RLPItem[] data;
399         bytes raw;
400         uint256 logIndex;
401     }
402 
403     struct Log {
404         RLPReader.RLPItem data;
405         RLPReader.RLPItem[] list;
406     }
407 
408     struct LogTopics {
409         RLPReader.RLPItem[] data;
410     }
411 
412     function copy(uint256 src, uint256 dest, uint256 len) private pure {
413         if (len == 0) return;
414         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
415             assembly {
416                 mstore(dest, mload(src))
417             }
418             src += WORD_SIZE;
419             dest += WORD_SIZE;
420         }
421         if (len == 0) return;
422         uint256 mask = 256**(WORD_SIZE - len) - 1;
423         assembly {
424             let srcpart := and(mload(src), not(mask))
425             let destpart := and(mload(dest), mask)
426             mstore(dest, or(destpart, srcpart))
427         }
428     }
429 
430     function toExitPayload(bytes memory data) internal pure returns (ExitPayload memory) {
431         RLPReader.RLPItem[] memory payloadData = data.toRlpItem().toList();
432 
433         return ExitPayload(payloadData);
434     }
435 
436     function getHeaderNumber(ExitPayload memory payload) internal pure returns (uint256) {
437         return payload.data[0].toUint();
438     }
439 
440     function getBlockProof(ExitPayload memory payload) internal pure returns (bytes memory) {
441         return payload.data[1].toBytes();
442     }
443 
444     function getBlockNumber(ExitPayload memory payload) internal pure returns (uint256) {
445         return payload.data[2].toUint();
446     }
447 
448     function getBlockTime(ExitPayload memory payload) internal pure returns (uint256) {
449         return payload.data[3].toUint();
450     }
451 
452     function getTxRoot(ExitPayload memory payload) internal pure returns (bytes32) {
453         return bytes32(payload.data[4].toUint());
454     }
455 
456     function getReceiptRoot(ExitPayload memory payload) internal pure returns (bytes32) {
457         return bytes32(payload.data[5].toUint());
458     }
459 
460     function getReceipt(ExitPayload memory payload) internal pure returns (Receipt memory receipt) {
461         receipt.raw = payload.data[6].toBytes();
462         RLPReader.RLPItem memory receiptItem = receipt.raw.toRlpItem();
463         if (receiptItem.isList()) {
464             receipt.data = receiptItem.toList();
465         } else {
466             bytes memory typedBytes = receipt.raw;
467             bytes memory result = new bytes(typedBytes.length - 1);
468             uint256 srcPtr;
469             uint256 destPtr;
470             assembly {
471                 srcPtr := add(33, typedBytes)
472                 destPtr := add(0x20, result)
473             }
474             copy(srcPtr, destPtr, result.length);
475             receipt.data = result.toRlpItem().toList();
476         }
477         receipt.logIndex = getReceiptLogIndex(payload);
478         return receipt;
479     }
480 
481     function getReceiptProof(ExitPayload memory payload) internal pure returns (bytes memory) {
482         return payload.data[7].toBytes();
483     }
484 
485     function getBranchMaskAsBytes(ExitPayload memory payload) internal pure returns (bytes memory) {
486         return payload.data[8].toBytes();
487     }
488 
489     function getBranchMaskAsUint(ExitPayload memory payload) internal pure returns (uint256) {
490         return payload.data[8].toUint();
491     }
492 
493     function getReceiptLogIndex(ExitPayload memory payload) internal pure returns (uint256) {
494         return payload.data[9].toUint();
495     }
496 
497     function toBytes(Receipt memory receipt) internal pure returns (bytes memory) {
498         return receipt.raw;
499     }
500 
501     function getLog(Receipt memory receipt) internal pure returns (Log memory) {
502         RLPReader.RLPItem memory logData = receipt.data[3].toList()[receipt.logIndex];
503         return Log(logData, logData.toList());
504     }
505 
506     function getEmitter(Log memory log) internal pure returns (address) {
507         return RLPReader.toAddress(log.list[0]);
508     }
509 
510     function getTopics(Log memory log) internal pure returns (LogTopics memory) {
511         return LogTopics(log.list[1].toList());
512     }
513 
514     function getData(Log memory log) internal pure returns (bytes memory) {
515         return log.list[2].toBytes();
516     }
517 
518     function toRlpBytes(Log memory log) internal pure returns (bytes memory) {
519         return log.data.toRlpBytes();
520     }
521 
522     function getField(LogTopics memory topics, uint256 index) internal pure returns (RLPReader.RLPItem memory) {
523         return topics.data[index];
524     }
525 }
526 
527 interface IFxStateSender {
528     function sendMessageToChild(address _receiver, bytes calldata _data) external;
529 }
530 
531 contract ICheckpointManager {
532     struct HeaderBlock {
533         bytes32 root;
534         uint256 start;
535         uint256 end;
536         uint256 createdAt;
537         address proposer;
538     }
539 
540     mapping(uint256 => HeaderBlock) public headerBlocks;
541 }
542 
543 abstract contract FxBaseRootTunnel {
544     using RLPReader for RLPReader.RLPItem;
545     using Merkle for bytes32;
546     using ExitPayloadReader for bytes;
547     using ExitPayloadReader for ExitPayloadReader.ExitPayload;
548     using ExitPayloadReader for ExitPayloadReader.Log;
549     using ExitPayloadReader for ExitPayloadReader.LogTopics;
550     using ExitPayloadReader for ExitPayloadReader.Receipt;
551 
552     bytes32 public constant SEND_MESSAGE_EVENT_SIG = 0x8c5261668696ce22758910d05bab8f186d6eb247ceac2af2e82c7dc17669b036;
553 
554     IFxStateSender public fxRoot;
555     ICheckpointManager public checkpointManager;
556 
557     address public fxChildTunnel;
558     mapping(bytes32 => bool) public processedExits;
559 
560     constructor(address _checkpointManager, address _fxRoot) {
561         checkpointManager = ICheckpointManager(_checkpointManager);
562         fxRoot = IFxStateSender(_fxRoot);
563     }
564 
565     function setFxChildTunnel(address _fxChildTunnel) public virtual {
566         require(fxChildTunnel == address(0x0), "FxBaseRootTunnel: CHILD_TUNNEL_ALREADY_SET");
567         fxChildTunnel = _fxChildTunnel;
568     }
569 
570     function _sendMessageToChild(bytes memory message) internal {
571         fxRoot.sendMessageToChild(fxChildTunnel, message);
572     }
573 
574     function _validateAndExtractMessage(bytes memory inputData) internal returns (bytes memory) {
575         ExitPayloadReader.ExitPayload memory payload = inputData.toExitPayload();
576         bytes memory branchMaskBytes = payload.getBranchMaskAsBytes();
577         uint256 blockNumber = payload.getBlockNumber();
578         bytes32 exitHash = keccak256(
579             abi.encodePacked(
580                 blockNumber,
581                 MerklePatriciaProof._getNibbleArray(branchMaskBytes),
582                 payload.getReceiptLogIndex()
583             )
584         );
585         require(processedExits[exitHash] == false, "FxRootTunnel: EXIT_ALREADY_PROCESSED");
586         processedExits[exitHash] = true;
587         ExitPayloadReader.Receipt memory receipt = payload.getReceipt();
588         ExitPayloadReader.Log memory log = receipt.getLog();
589         require(fxChildTunnel == log.getEmitter(), "FxRootTunnel: INVALID_FX_CHILD_TUNNEL");
590         bytes32 receiptRoot = payload.getReceiptRoot();
591         require(
592             MerklePatriciaProof.verify(receipt.toBytes(), branchMaskBytes, payload.getReceiptProof(), receiptRoot),
593             "FxRootTunnel: INVALID_RECEIPT_PROOF"
594         );
595         _checkBlockMembershipInCheckpoint(
596             blockNumber,
597             payload.getBlockTime(),
598             payload.getTxRoot(),
599             receiptRoot,
600             payload.getHeaderNumber(),
601             payload.getBlockProof()
602         );
603         ExitPayloadReader.LogTopics memory topics = log.getTopics();
604         require(bytes32(topics.getField(0).toUint()) == SEND_MESSAGE_EVENT_SIG, "FxRootTunnel: INVALID_SIGNATURE");
605         bytes memory message = abi.decode(log.getData(), (bytes));
606         return message;
607     }
608 
609     function _checkBlockMembershipInCheckpoint(uint256 blockNumber, uint256 blockTime, bytes32 txRoot, bytes32 receiptRoot, uint256 headerNumber, bytes memory blockProof) private view returns (uint256) {
610         (bytes32 headerRoot, uint256 startBlock, , uint256 createdAt, ) = checkpointManager.headerBlocks(headerNumber);
611         require(
612             keccak256(abi.encodePacked(blockNumber, blockTime, txRoot, receiptRoot)).checkMembership(
613                 blockNumber - startBlock,
614                 headerRoot,
615                 blockProof
616             ),
617             "FxRootTunnel: INVALID_HEADER"
618         );
619         return createdAt;
620     }
621 
622     function receiveMessage(bytes memory inputData) public virtual {
623         bytes memory message = _validateAndExtractMessage(inputData);
624         _processMessageFromChild(message);
625     }
626 
627     function _processMessageFromChild(bytes memory message) internal virtual;
628 }
629 
630 interface IERC721 {
631     function ownerOf(uint256 tokenId_) external view returns (address);
632     function balanceOf(address owner) external view returns (uint256 balance);
633     function transferFrom(address _from, address _to, uint256 tokenId_) external;
634 }
635 
636 contract NEOTOKYOCENTRAL is FxBaseRootTunnel, OwnControll {
637 
638     address public constant NTP = 0xA65bA71d653f62c64d97099b58D25a955Eb374a0;
639     address public constant ROARS = 0x066b62EA211249925800eD8676f69eD506175714;
640 
641     bool public active;
642     IERC721 public ERC721;
643 
644     struct tokenInfoNTP { address tokenOwner; }
645     mapping(uint256 => tokenInfoNTP) public stakedTokenNTP;
646     mapping(address => uint256) public stakedTokenAmountNTP;
647 
648     struct tokenInfoROARS { address tokenOwner; }
649     mapping(uint256 => tokenInfoROARS) public stakedTokenROARS;
650     mapping(address => uint256) public stakedTokenAmountROARS;
651 
652     constructor(address checkpointManager, address fxRoot) FxBaseRootTunnel(checkpointManager, fxRoot) {}
653 
654     function setActive() public onlyAdmin("ADMIN") {
655         active = !active;
656     }
657 
658     function multiTransferFrom(address contract_, address from_, address to_, uint256[] memory tokenIds_) internal {
659         for (uint256 i = 0; i < tokenIds_.length; i++) {
660             IERC721(contract_).transferFrom(from_, to_, tokenIds_[i]);
661         }
662     }
663 
664     /// Stake NTP
665     function stakeBatchNTP(uint256[] memory tokenIds_) external {
666         require(active, "Inactive");
667         uint256 l = tokenIds_.length;
668         uint256 i; unchecked { do {
669             require(IERC721(NTP).ownerOf(tokenIds_[i]) == msg.sender, "Not Owner");
670             stakedTokenNTP[tokenIds_[i]].tokenOwner = msg.sender;
671         } while (++i < l); }
672         _sendMessageToChild(abi.encode(msg.sender, NTP, l, true));
673         stakedTokenAmountNTP[msg.sender] += l;
674         multiTransferFrom(NTP, msg.sender, address(this), tokenIds_);
675     }
676 
677     /// Unstake NTP
678     function unstakeBatchNTP(uint256[] memory tokenIds_) external {
679         uint256 l = tokenIds_.length;
680         uint256 i; unchecked { do {
681             require(stakedTokenNTP[tokenIds_[i]].tokenOwner == msg.sender, "Not Owner");
682             delete stakedTokenNTP[tokenIds_[i]];
683         } while (++i < l); }
684         _sendMessageToChild(abi.encode(msg.sender, NTP, l, false));
685         stakedTokenAmountNTP[msg.sender] -= l;
686         multiTransferFrom(NTP, address(this), msg.sender, tokenIds_);
687     }
688 
689     ///Stake ROARS
690     function stakeBatchROARS(uint256[] memory tokenIds_) external {
691         require(active, "Inactive");
692         uint256 l = tokenIds_.length;
693         uint256 i; unchecked { do {
694             require(IERC721(ROARS).ownerOf(tokenIds_[i]) == msg.sender, "Not Owner");
695             stakedTokenROARS[tokenIds_[i]].tokenOwner = msg.sender;
696         } while (++i < l); }
697         _sendMessageToChild(abi.encode(msg.sender, ROARS, l, true));
698         stakedTokenAmountROARS[msg.sender] += l;
699         multiTransferFrom(ROARS, msg.sender, address(this), tokenIds_);
700     }
701 
702     ///Unstake ROARS
703     function unstakeBatchROARS(uint256[] memory tokenIds_) external {
704         uint256 l = tokenIds_.length;
705         uint256 i; unchecked { do {
706             require(stakedTokenROARS[tokenIds_[i]].tokenOwner == msg.sender, "Not Owner");
707             delete stakedTokenROARS[tokenIds_[i]];
708         } while (++i < l); }
709         _sendMessageToChild(abi.encode(msg.sender, ROARS, l, false));
710         stakedTokenAmountROARS[msg.sender] -= l;
711         multiTransferFrom(ROARS, address(this), msg.sender, tokenIds_);
712     }
713 
714     function getUserStakedTokensNTP(address user) public view returns (uint256[] memory) {
715         uint256 stakedAmount = stakedTokenAmountNTP[user];
716         uint256[] memory stakedTokens = new uint256[](stakedAmount);
717         uint256 counter = 0;
718         for (uint256 i = 1; i <= 2222; i++) {
719             tokenInfoNTP memory st = stakedTokenNTP[i];
720             if (st.tokenOwner == user) {
721                 stakedTokens[counter] = i;
722                 counter++;
723             }
724         }
725         return stakedTokens;
726     }
727 
728     function getUserStakedTokensROARS(address user) public view returns (uint256[] memory) {
729         uint256 stakedAmount = stakedTokenAmountROARS[user];
730         uint256[] memory stakedTokens = new uint256[](stakedAmount);
731         uint256 counter = 0;
732         for (uint256 i = 1; i <= 12345; i++) {
733             tokenInfoROARS memory st = stakedTokenROARS[i];
734             if (st.tokenOwner == user) {
735                 stakedTokens[counter] = i;
736                 counter++;
737             }
738         }
739         return stakedTokens;
740     }
741 
742     function _processMessageFromChild(bytes memory message) internal override {
743         //✋👽🤚
744     }
745 }