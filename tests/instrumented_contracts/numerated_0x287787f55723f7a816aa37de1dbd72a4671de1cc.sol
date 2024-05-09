1 // File: default_workspace/contracts/Ownable.sol
2 
3 
4 pragma solidity ^0.8.10;
5 
6 error NotOwner();
7 
8 // https://github.com/m1guelpf/erc721-drop/blob/main/src/LilOwnable.sol
9 abstract contract Ownable {
10     address internal _owner;
11 
12     event OwnershipTransferred(
13         address indexed previousOwner,
14         address indexed newOwner
15     );
16 
17     modifier onlyOwner() {
18         require(_owner == msg.sender);
19         _;
20     }
21 
22     constructor() {
23         _owner = msg.sender;
24     }
25 
26     function owner() external view returns (address) {
27         return _owner;
28     }
29 
30     function transferOwnership(address _newOwner) external {
31         if (msg.sender != _owner) revert NotOwner();
32 
33         _owner = _newOwner;
34     }
35 
36     function renounceOwnership() public {
37         if (msg.sender != _owner) revert NotOwner();
38 
39         _owner = address(0);
40     }
41 
42     function supportsInterface(bytes4 interfaceId)
43         public
44         pure
45         virtual
46         returns (bool)
47     {
48         return interfaceId == 0x7f5828d0; // ERC165 Interface ID for ERC173
49     }
50 }
51 
52 // File: default_workspace/contracts/lib/Merkle.sol
53 
54 
55 pragma solidity ^0.8.0;
56 
57 library Merkle {
58     function checkMembership(
59         bytes32 leaf,
60         uint256 index,
61         bytes32 rootHash,
62         bytes memory proof
63     ) internal pure returns (bool) {
64         require(proof.length % 32 == 0, "Invalid proof length");
65         uint256 proofHeight = proof.length / 32;
66         // Proof of size n means, height of the tree is n+1.
67         // In a tree of height n+1, max #leafs possible is 2 ^ n
68         require(index < 2**proofHeight, "Leaf index is too big");
69 
70         bytes32 proofElement;
71         bytes32 computedHash = leaf;
72         for (uint256 i = 32; i <= proof.length; i += 32) {
73             assembly {
74                 proofElement := mload(add(proof, i))
75             }
76 
77             if (index % 2 == 0) {
78                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
79             } else {
80                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
81             }
82 
83             index = index / 2;
84         }
85         return computedHash == rootHash;
86     }
87 }
88 
89 // File: default_workspace/contracts/lib/RLPReader.sol
90 
91 /*
92  * @author Hamdi Allam hamdi.allam97@gmail.com
93  * Please reach out with any questions or concerns
94  */
95 pragma solidity ^0.8.0;
96 
97 library RLPReader {
98     uint8 constant STRING_SHORT_START = 0x80;
99     uint8 constant STRING_LONG_START = 0xb8;
100     uint8 constant LIST_SHORT_START = 0xc0;
101     uint8 constant LIST_LONG_START = 0xf8;
102     uint8 constant WORD_SIZE = 32;
103 
104     struct RLPItem {
105         uint256 len;
106         uint256 memPtr;
107     }
108 
109     struct Iterator {
110         RLPItem item; // Item that's being iterated over.
111         uint256 nextPtr; // Position of the next item in the list.
112     }
113 
114     /*
115      * @dev Returns the next element in the iteration. Reverts if it has not next element.
116      * @param self The iterator.
117      * @return The next element in the iteration.
118      */
119     function next(Iterator memory self) internal pure returns (RLPItem memory) {
120         require(hasNext(self));
121 
122         uint256 ptr = self.nextPtr;
123         uint256 itemLength = _itemLength(ptr);
124         self.nextPtr = ptr + itemLength;
125 
126         return RLPItem(itemLength, ptr);
127     }
128 
129     /*
130      * @dev Returns true if the iteration has more elements.
131      * @param self The iterator.
132      * @return true if the iteration has more elements.
133      */
134     function hasNext(Iterator memory self) internal pure returns (bool) {
135         RLPItem memory item = self.item;
136         return self.nextPtr < item.memPtr + item.len;
137     }
138 
139     /*
140      * @param item RLP encoded bytes
141      */
142     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
143         uint256 memPtr;
144         assembly {
145             memPtr := add(item, 0x20)
146         }
147 
148         return RLPItem(item.length, memPtr);
149     }
150 
151     /*
152      * @dev Create an iterator. Reverts if item is not a list.
153      * @param self The RLP item.
154      * @return An 'Iterator' over the item.
155      */
156     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
157         require(isList(self));
158 
159         uint256 ptr = self.memPtr + _payloadOffset(self.memPtr);
160         return Iterator(self, ptr);
161     }
162 
163     /*
164      * @param item RLP encoded bytes
165      */
166     function rlpLen(RLPItem memory item) internal pure returns (uint256) {
167         return item.len;
168     }
169 
170     /*
171      * @param item RLP encoded bytes
172      */
173     function payloadLen(RLPItem memory item) internal pure returns (uint256) {
174         return item.len - _payloadOffset(item.memPtr);
175     }
176 
177     /*
178      * @param item RLP encoded list in bytes
179      */
180     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
181         require(isList(item));
182 
183         uint256 items = numItems(item);
184         RLPItem[] memory result = new RLPItem[](items);
185 
186         uint256 memPtr = item.memPtr + _payloadOffset(item.memPtr);
187         uint256 dataLen;
188         for (uint256 i = 0; i < items; i++) {
189             dataLen = _itemLength(memPtr);
190             result[i] = RLPItem(dataLen, memPtr);
191             memPtr = memPtr + dataLen;
192         }
193 
194         return result;
195     }
196 
197     // @return indicator whether encoded payload is a list. negate this function call for isData.
198     function isList(RLPItem memory item) internal pure returns (bool) {
199         if (item.len == 0) return false;
200 
201         uint8 byte0;
202         uint256 memPtr = item.memPtr;
203         assembly {
204             byte0 := byte(0, mload(memPtr))
205         }
206 
207         if (byte0 < LIST_SHORT_START) return false;
208         return true;
209     }
210 
211     /*
212      * @dev A cheaper version of keccak256(toRlpBytes(item)) that avoids copying memory.
213      * @return keccak256 hash of RLP encoded bytes.
214      */
215     function rlpBytesKeccak256(RLPItem memory item) internal pure returns (bytes32) {
216         uint256 ptr = item.memPtr;
217         uint256 len = item.len;
218         bytes32 result;
219         assembly {
220             result := keccak256(ptr, len)
221         }
222         return result;
223     }
224 
225     function payloadLocation(RLPItem memory item) internal pure returns (uint256, uint256) {
226         uint256 offset = _payloadOffset(item.memPtr);
227         uint256 memPtr = item.memPtr + offset;
228         uint256 len = item.len - offset; // data length
229         return (memPtr, len);
230     }
231 
232     /*
233      * @dev A cheaper version of keccak256(toBytes(item)) that avoids copying memory.
234      * @return keccak256 hash of the item payload.
235      */
236     function payloadKeccak256(RLPItem memory item) internal pure returns (bytes32) {
237         (uint256 memPtr, uint256 len) = payloadLocation(item);
238         bytes32 result;
239         assembly {
240             result := keccak256(memPtr, len)
241         }
242         return result;
243     }
244 
245     /** RLPItem conversions into data types **/
246 
247     // @returns raw rlp encoding in bytes
248     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
249         bytes memory result = new bytes(item.len);
250         if (result.length == 0) return result;
251 
252         uint256 ptr;
253         assembly {
254             ptr := add(0x20, result)
255         }
256 
257         copy(item.memPtr, ptr, item.len);
258         return result;
259     }
260 
261     // any non-zero byte is considered true
262     function toBoolean(RLPItem memory item) internal pure returns (bool) {
263         require(item.len == 1);
264         uint256 result;
265         uint256 memPtr = item.memPtr;
266         assembly {
267             result := byte(0, mload(memPtr))
268         }
269 
270         return result == 0 ? false : true;
271     }
272 
273     function toAddress(RLPItem memory item) internal pure returns (address) {
274         // 1 byte for the length prefix
275         require(item.len == 21);
276 
277         return address(uint160(toUint(item)));
278     }
279 
280     function toUint(RLPItem memory item) internal pure returns (uint256) {
281         require(item.len > 0 && item.len <= 33);
282 
283         uint256 offset = _payloadOffset(item.memPtr);
284         uint256 len = item.len - offset;
285 
286         uint256 result;
287         uint256 memPtr = item.memPtr + offset;
288         assembly {
289             result := mload(memPtr)
290 
291             // shfit to the correct location if neccesary
292             if lt(len, 32) {
293                 result := div(result, exp(256, sub(32, len)))
294             }
295         }
296 
297         return result;
298     }
299 
300     // enforces 32 byte length
301     function toUintStrict(RLPItem memory item) internal pure returns (uint256) {
302         // one byte prefix
303         require(item.len == 33);
304 
305         uint256 result;
306         uint256 memPtr = item.memPtr + 1;
307         assembly {
308             result := mload(memPtr)
309         }
310 
311         return result;
312     }
313 
314     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
315         require(item.len > 0);
316 
317         uint256 offset = _payloadOffset(item.memPtr);
318         uint256 len = item.len - offset; // data length
319         bytes memory result = new bytes(len);
320 
321         uint256 destPtr;
322         assembly {
323             destPtr := add(0x20, result)
324         }
325 
326         copy(item.memPtr + offset, destPtr, len);
327         return result;
328     }
329 
330     /*
331      * Private Helpers
332      */
333 
334     // @return number of payload items inside an encoded list.
335     function numItems(RLPItem memory item) private pure returns (uint256) {
336         if (item.len == 0) return 0;
337 
338         uint256 count = 0;
339         uint256 currPtr = item.memPtr + _payloadOffset(item.memPtr);
340         uint256 endPtr = item.memPtr + item.len;
341         while (currPtr < endPtr) {
342             currPtr = currPtr + _itemLength(currPtr); // skip over an item
343             count++;
344         }
345 
346         return count;
347     }
348 
349     // @return entire rlp item byte length
350     function _itemLength(uint256 memPtr) private pure returns (uint256) {
351         uint256 itemLen;
352         uint256 byte0;
353         assembly {
354             byte0 := byte(0, mload(memPtr))
355         }
356 
357         if (byte0 < STRING_SHORT_START) itemLen = 1;
358         else if (byte0 < STRING_LONG_START) itemLen = byte0 - STRING_SHORT_START + 1;
359         else if (byte0 < LIST_SHORT_START) {
360             assembly {
361                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
362                 memPtr := add(memPtr, 1) // skip over the first byte
363                 /* 32 byte word size */
364                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
365                 itemLen := add(dataLen, add(byteLen, 1))
366             }
367         } else if (byte0 < LIST_LONG_START) {
368             itemLen = byte0 - LIST_SHORT_START + 1;
369         } else {
370             assembly {
371                 let byteLen := sub(byte0, 0xf7)
372                 memPtr := add(memPtr, 1)
373 
374                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
375                 itemLen := add(dataLen, add(byteLen, 1))
376             }
377         }
378 
379         return itemLen;
380     }
381 
382     // @return number of bytes until the data
383     function _payloadOffset(uint256 memPtr) private pure returns (uint256) {
384         uint256 byte0;
385         assembly {
386             byte0 := byte(0, mload(memPtr))
387         }
388 
389         if (byte0 < STRING_SHORT_START) return 0;
390         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START)) return 1;
391         else if (byte0 < LIST_SHORT_START)
392             // being explicit
393             return byte0 - (STRING_LONG_START - 1) + 1;
394         else return byte0 - (LIST_LONG_START - 1) + 1;
395     }
396 
397     /*
398      * @param src Pointer to source
399      * @param dest Pointer to destination
400      * @param len Amount of memory to copy from the source
401      */
402     function copy(
403         uint256 src,
404         uint256 dest,
405         uint256 len
406     ) private pure {
407         if (len == 0) return;
408 
409         // copy as many word sizes as possible
410         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
411             assembly {
412                 mstore(dest, mload(src))
413             }
414 
415             src += WORD_SIZE;
416             dest += WORD_SIZE;
417         }
418 
419         if (len == 0) return;
420 
421         // left over bytes. Mask is used to remove unwanted bytes from the word
422         uint256 mask = 256**(WORD_SIZE - len) - 1;
423 
424         assembly {
425             let srcpart := and(mload(src), not(mask)) // zero out src
426             let destpart := and(mload(dest), mask) // retrieve the bytes
427             mstore(dest, or(destpart, srcpart))
428         }
429     }
430 }
431 
432 // File: default_workspace/contracts/lib/ExitPayloadReader.sol
433 
434 pragma solidity ^0.8.0;
435 
436 
437 library ExitPayloadReader {
438     using RLPReader for bytes;
439     using RLPReader for RLPReader.RLPItem;
440 
441     uint8 constant WORD_SIZE = 32;
442 
443     struct ExitPayload {
444         RLPReader.RLPItem[] data;
445     }
446 
447     struct Receipt {
448         RLPReader.RLPItem[] data;
449         bytes raw;
450         uint256 logIndex;
451     }
452 
453     struct Log {
454         RLPReader.RLPItem data;
455         RLPReader.RLPItem[] list;
456     }
457 
458     struct LogTopics {
459         RLPReader.RLPItem[] data;
460     }
461 
462     // copy paste of private copy() from RLPReader to avoid changing of existing contracts
463     function copy(
464         uint256 src,
465         uint256 dest,
466         uint256 len
467     ) private pure {
468         if (len == 0) return;
469 
470         // copy as many word sizes as possible
471         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
472             assembly {
473                 mstore(dest, mload(src))
474             }
475 
476             src += WORD_SIZE;
477             dest += WORD_SIZE;
478         }
479 
480         // left over bytes. Mask is used to remove unwanted bytes from the word
481         uint256 mask = 256**(WORD_SIZE - len) - 1;
482         assembly {
483             let srcpart := and(mload(src), not(mask)) // zero out src
484             let destpart := and(mload(dest), mask) // retrieve the bytes
485             mstore(dest, or(destpart, srcpart))
486         }
487     }
488 
489     function toExitPayload(bytes memory data) internal pure returns (ExitPayload memory) {
490         RLPReader.RLPItem[] memory payloadData = data.toRlpItem().toList();
491 
492         return ExitPayload(payloadData);
493     }
494 
495     function getHeaderNumber(ExitPayload memory payload) internal pure returns (uint256) {
496         return payload.data[0].toUint();
497     }
498 
499     function getBlockProof(ExitPayload memory payload) internal pure returns (bytes memory) {
500         return payload.data[1].toBytes();
501     }
502 
503     function getBlockNumber(ExitPayload memory payload) internal pure returns (uint256) {
504         return payload.data[2].toUint();
505     }
506 
507     function getBlockTime(ExitPayload memory payload) internal pure returns (uint256) {
508         return payload.data[3].toUint();
509     }
510 
511     function getTxRoot(ExitPayload memory payload) internal pure returns (bytes32) {
512         return bytes32(payload.data[4].toUint());
513     }
514 
515     function getReceiptRoot(ExitPayload memory payload) internal pure returns (bytes32) {
516         return bytes32(payload.data[5].toUint());
517     }
518 
519     function getReceipt(ExitPayload memory payload) internal pure returns (Receipt memory receipt) {
520         receipt.raw = payload.data[6].toBytes();
521         RLPReader.RLPItem memory receiptItem = receipt.raw.toRlpItem();
522 
523         if (receiptItem.isList()) {
524             // legacy tx
525             receipt.data = receiptItem.toList();
526         } else {
527             // pop first byte before parsting receipt
528             bytes memory typedBytes = receipt.raw;
529             bytes memory result = new bytes(typedBytes.length - 1);
530             uint256 srcPtr;
531             uint256 destPtr;
532             assembly {
533                 srcPtr := add(33, typedBytes)
534                 destPtr := add(0x20, result)
535             }
536 
537             copy(srcPtr, destPtr, result.length);
538             receipt.data = result.toRlpItem().toList();
539         }
540 
541         receipt.logIndex = getReceiptLogIndex(payload);
542         return receipt;
543     }
544 
545     function getReceiptProof(ExitPayload memory payload) internal pure returns (bytes memory) {
546         return payload.data[7].toBytes();
547     }
548 
549     function getBranchMaskAsBytes(ExitPayload memory payload) internal pure returns (bytes memory) {
550         return payload.data[8].toBytes();
551     }
552 
553     function getBranchMaskAsUint(ExitPayload memory payload) internal pure returns (uint256) {
554         return payload.data[8].toUint();
555     }
556 
557     function getReceiptLogIndex(ExitPayload memory payload) internal pure returns (uint256) {
558         return payload.data[9].toUint();
559     }
560 
561     // Receipt methods
562     function toBytes(Receipt memory receipt) internal pure returns (bytes memory) {
563         return receipt.raw;
564     }
565 
566     function getLog(Receipt memory receipt) internal pure returns (Log memory) {
567         RLPReader.RLPItem memory logData = receipt.data[3].toList()[receipt.logIndex];
568         return Log(logData, logData.toList());
569     }
570 
571     // Log methods
572     function getEmitter(Log memory log) internal pure returns (address) {
573         return RLPReader.toAddress(log.list[0]);
574     }
575 
576     function getTopics(Log memory log) internal pure returns (LogTopics memory) {
577         return LogTopics(log.list[1].toList());
578     }
579 
580     function getData(Log memory log) internal pure returns (bytes memory) {
581         return log.list[2].toBytes();
582     }
583 
584     function toRlpBytes(Log memory log) internal pure returns (bytes memory) {
585         return log.data.toRlpBytes();
586     }
587 
588     // LogTopics methods
589     function getField(LogTopics memory topics, uint256 index) internal pure returns (RLPReader.RLPItem memory) {
590         return topics.data[index];
591     }
592 }
593 
594 // File: default_workspace/contracts/lib/MerklePatriciaProof.sol
595 
596 
597 pragma solidity ^0.8.0;
598 
599 
600 library MerklePatriciaProof {
601     /*
602      * @dev Verifies a merkle patricia proof.
603      * @param value The terminating value in the trie.
604      * @param encodedPath The path in the trie leading to value.
605      * @param rlpParentNodes The rlp encoded stack of nodes.
606      * @param root The root hash of the trie.
607      * @return The boolean validity of the proof.
608      */
609     function verify(
610         bytes memory value,
611         bytes memory encodedPath,
612         bytes memory rlpParentNodes,
613         bytes32 root
614     ) internal pure returns (bool) {
615         RLPReader.RLPItem memory item = RLPReader.toRlpItem(rlpParentNodes);
616         RLPReader.RLPItem[] memory parentNodes = RLPReader.toList(item);
617 
618         bytes memory currentNode;
619         RLPReader.RLPItem[] memory currentNodeList;
620 
621         bytes32 nodeKey = root;
622         uint256 pathPtr = 0;
623 
624         bytes memory path = _getNibbleArray(encodedPath);
625         if (path.length == 0) {
626             return false;
627         }
628 
629         for (uint256 i = 0; i < parentNodes.length; i++) {
630             if (pathPtr > path.length) {
631                 return false;
632             }
633 
634             currentNode = RLPReader.toRlpBytes(parentNodes[i]);
635             if (nodeKey != keccak256(currentNode)) {
636                 return false;
637             }
638             currentNodeList = RLPReader.toList(parentNodes[i]);
639 
640             if (currentNodeList.length == 17) {
641                 if (pathPtr == path.length) {
642                     if (keccak256(RLPReader.toBytes(currentNodeList[16])) == keccak256(value)) {
643                         return true;
644                     } else {
645                         return false;
646                     }
647                 }
648 
649                 uint8 nextPathNibble = uint8(path[pathPtr]);
650                 if (nextPathNibble > 16) {
651                     return false;
652                 }
653                 nodeKey = bytes32(RLPReader.toUintStrict(currentNodeList[nextPathNibble]));
654                 pathPtr += 1;
655             } else if (currentNodeList.length == 2) {
656                 uint256 traversed = _nibblesToTraverse(RLPReader.toBytes(currentNodeList[0]), path, pathPtr);
657                 if (pathPtr + traversed == path.length) {
658                     //leaf node
659                     if (keccak256(RLPReader.toBytes(currentNodeList[1])) == keccak256(value)) {
660                         return true;
661                     } else {
662                         return false;
663                     }
664                 }
665 
666                 //extension node
667                 if (traversed == 0) {
668                     return false;
669                 }
670 
671                 pathPtr += traversed;
672                 nodeKey = bytes32(RLPReader.toUintStrict(currentNodeList[1]));
673             } else {
674                 return false;
675             }
676         }
677     }
678 
679     function _nibblesToTraverse(
680         bytes memory encodedPartialPath,
681         bytes memory path,
682         uint256 pathPtr
683     ) private pure returns (uint256) {
684         uint256 len = 0;
685         // encodedPartialPath has elements that are each two hex characters (1 byte), but partialPath
686         // and slicedPath have elements that are each one hex character (1 nibble)
687         bytes memory partialPath = _getNibbleArray(encodedPartialPath);
688         bytes memory slicedPath = new bytes(partialPath.length);
689 
690         // pathPtr counts nibbles in path
691         // partialPath.length is a number of nibbles
692         for (uint256 i = pathPtr; i < pathPtr + partialPath.length; i++) {
693             bytes1 pathNibble = path[i];
694             slicedPath[i - pathPtr] = pathNibble;
695         }
696 
697         if (keccak256(partialPath) == keccak256(slicedPath)) {
698             len = partialPath.length;
699         } else {
700             len = 0;
701         }
702         return len;
703     }
704 
705     // bytes b must be hp encoded
706     function _getNibbleArray(bytes memory b) internal pure returns (bytes memory) {
707         bytes memory nibbles = "";
708         if (b.length > 0) {
709             uint8 offset;
710             uint8 hpNibble = uint8(_getNthNibbleOfBytes(0, b));
711             if (hpNibble == 1 || hpNibble == 3) {
712                 nibbles = new bytes(b.length * 2 - 1);
713                 bytes1 oddNibble = _getNthNibbleOfBytes(1, b);
714                 nibbles[0] = oddNibble;
715                 offset = 1;
716             } else {
717                 nibbles = new bytes(b.length * 2 - 2);
718                 offset = 0;
719             }
720 
721             for (uint256 i = offset; i < nibbles.length; i++) {
722                 nibbles[i] = _getNthNibbleOfBytes(i - offset + 2, b);
723             }
724         }
725         return nibbles;
726     }
727 
728     function _getNthNibbleOfBytes(uint256 n, bytes memory str) private pure returns (bytes1) {
729         return bytes1(n % 2 == 0 ? uint8(str[n / 2]) / 0x10 : uint8(str[n / 2]) % 0x10);
730     }
731 }
732 
733 // File: default_workspace/contracts/tunnel/FxBaseRootTunnel.sol
734 
735 
736 pragma solidity ^0.8.0;
737 
738 
739 
740 
741 
742 interface IFxStateSender {
743     function sendMessageToChild(address _receiver, bytes calldata _data) external;
744 }
745 
746 contract ICheckpointManager {
747     struct HeaderBlock {
748         bytes32 root;
749         uint256 start;
750         uint256 end;
751         uint256 createdAt;
752         address proposer;
753     }
754 
755     /**
756      * @notice mapping of checkpoint header numbers to block details
757      * @dev These checkpoints are submited by plasma contracts
758      */
759     mapping(uint256 => HeaderBlock) public headerBlocks;
760 }
761 
762 abstract contract FxBaseRootTunnel {
763     using RLPReader for RLPReader.RLPItem;
764     using Merkle for bytes32;
765     using ExitPayloadReader for bytes;
766     using ExitPayloadReader for ExitPayloadReader.ExitPayload;
767     using ExitPayloadReader for ExitPayloadReader.Log;
768     using ExitPayloadReader for ExitPayloadReader.LogTopics;
769     using ExitPayloadReader for ExitPayloadReader.Receipt;
770 
771     // keccak256(MessageSent(bytes))
772     bytes32 public constant SEND_MESSAGE_EVENT_SIG = 0x8c5261668696ce22758910d05bab8f186d6eb247ceac2af2e82c7dc17669b036;
773 
774     // state sender contract
775     IFxStateSender public fxRoot;
776     // root chain manager
777     ICheckpointManager public checkpointManager;
778     // child tunnel contract which receives and sends messages
779     address public fxChildTunnel;
780 
781     // storage to avoid duplicate exits
782     mapping(bytes32 => bool) public processedExits;
783 
784     constructor(address _checkpointManager, address _fxRoot) {
785         checkpointManager = ICheckpointManager(_checkpointManager);
786         fxRoot = IFxStateSender(_fxRoot);
787     }
788 
789     // set fxChildTunnel if not set already
790     function setFxChildTunnel(address _fxChildTunnel) public virtual {
791         require(fxChildTunnel == address(0x0), "FxBaseRootTunnel: CHILD_TUNNEL_ALREADY_SET");
792         fxChildTunnel = _fxChildTunnel;
793     }
794 
795     /**
796      * @notice Send bytes message to Child Tunnel
797      * @param message bytes message that will be sent to Child Tunnel
798      * some message examples -
799      *   abi.encode(tokenId);
800      *   abi.encode(tokenId, tokenMetadata);
801      *   abi.encode(messageType, messageData);
802      */
803     function _sendMessageToChild(bytes memory message) internal {
804         fxRoot.sendMessageToChild(fxChildTunnel, message);
805     }
806 
807     function _validateAndExtractMessage(bytes memory inputData) internal returns (bytes memory) {
808         ExitPayloadReader.ExitPayload memory payload = inputData.toExitPayload();
809 
810         bytes memory branchMaskBytes = payload.getBranchMaskAsBytes();
811         uint256 blockNumber = payload.getBlockNumber();
812         // checking if exit has already been processed
813         // unique exit is identified using hash of (blockNumber, branchMask, receiptLogIndex)
814         bytes32 exitHash = keccak256(
815             abi.encodePacked(
816                 blockNumber,
817                 // first 2 nibbles are dropped while generating nibble array
818                 // this allows branch masks that are valid but bypass exitHash check (changing first 2 nibbles only)
819                 // so converting to nibble array and then hashing it
820                 MerklePatriciaProof._getNibbleArray(branchMaskBytes),
821                 payload.getReceiptLogIndex()
822             )
823         );
824         require(processedExits[exitHash] == false, "FxRootTunnel: EXIT_ALREADY_PROCESSED");
825         processedExits[exitHash] = true;
826 
827         ExitPayloadReader.Receipt memory receipt = payload.getReceipt();
828         ExitPayloadReader.Log memory log = receipt.getLog();
829 
830         // check child tunnel
831         require(fxChildTunnel == log.getEmitter(), "FxRootTunnel: INVALID_FX_CHILD_TUNNEL");
832 
833         bytes32 receiptRoot = payload.getReceiptRoot();
834         // verify receipt inclusion
835         require(
836             MerklePatriciaProof.verify(receipt.toBytes(), branchMaskBytes, payload.getReceiptProof(), receiptRoot),
837             "FxRootTunnel: INVALID_RECEIPT_PROOF"
838         );
839 
840         // verify checkpoint inclusion
841         _checkBlockMembershipInCheckpoint(
842             blockNumber,
843             payload.getBlockTime(),
844             payload.getTxRoot(),
845             receiptRoot,
846             payload.getHeaderNumber(),
847             payload.getBlockProof()
848         );
849 
850         ExitPayloadReader.LogTopics memory topics = log.getTopics();
851 
852         require(
853             bytes32(topics.getField(0).toUint()) == SEND_MESSAGE_EVENT_SIG, // topic0 is event sig
854             "FxRootTunnel: INVALID_SIGNATURE"
855         );
856 
857         // received message data
858         bytes memory message = abi.decode(log.getData(), (bytes)); // event decodes params again, so decoding bytes to get message
859         return message;
860     }
861 
862     function _checkBlockMembershipInCheckpoint(
863         uint256 blockNumber,
864         uint256 blockTime,
865         bytes32 txRoot,
866         bytes32 receiptRoot,
867         uint256 headerNumber,
868         bytes memory blockProof
869     ) private view returns (uint256) {
870         (bytes32 headerRoot, uint256 startBlock, , uint256 createdAt, ) = checkpointManager.headerBlocks(headerNumber);
871 
872         require(
873             keccak256(abi.encodePacked(blockNumber, blockTime, txRoot, receiptRoot)).checkMembership(
874                 blockNumber - startBlock,
875                 headerRoot,
876                 blockProof
877             ),
878             "FxRootTunnel: INVALID_HEADER"
879         );
880         return createdAt;
881     }
882 
883     /**
884      * @notice receive message from  L2 to L1, validated by proof
885      * @dev This function verifies if the transaction actually happened on child chain
886      *
887      * @param inputData RLP encoded data of the reference tx containing following list of fields
888      *  0 - headerNumber - Checkpoint header block number containing the reference tx
889      *  1 - blockProof - Proof that the block header (in the child chain) is a leaf in the submitted merkle root
890      *  2 - blockNumber - Block number containing the reference tx on child chain
891      *  3 - blockTime - Reference tx block time
892      *  4 - txRoot - Transactions root of block
893      *  5 - receiptRoot - Receipts root of block
894      *  6 - receipt - Receipt of the reference transaction
895      *  7 - receiptProof - Merkle proof of the reference receipt
896      *  8 - branchMask - 32 bits denoting the path of receipt in merkle tree
897      *  9 - receiptLogIndex - Log Index to read from the receipt
898      */
899     function receiveMessage(bytes memory inputData) public virtual {
900         bytes memory message = _validateAndExtractMessage(inputData);
901         _processMessageFromChild(message);
902     }
903 
904     /**
905      * @notice Process message received from Child Tunnel
906      * @dev function needs to be implemented to handle message as per requirement
907      * This is called by onStateReceive function.
908      * Since it is called via a system call, any event will not be emitted during its execution.
909      * @param message bytes message that was sent from Child Tunnel
910      */
911     function _processMessageFromChild(bytes memory message) internal virtual;
912 }
913 
914 // File: default_workspace/contracts/IDungeonRewards.sol
915 
916 
917 pragma solidity ^0.8.12;
918 
919 interface IDungeonRewards {
920 
921     // so we can confirm whether a wallet holds any staked dungeons, useful for Generative Avatars gas-only mint
922     function balanceOfDungeons(address owner) external view returns (uint256);
923     // so we can confirm when a wallet staked their dungeons, useful for Generative Avatars gas-only mint
924     function dungeonFirstStaked(address owner) external view returns (uint256);
925 
926     function balanceOfAvatars(address owner) external view returns (uint256);
927     function avatarFirstStaked(address owner) external  view returns (uint256);
928 
929     function balanceOfQuests(address owner) external view returns (uint256);
930     function questFirstStaked(address owner) external view returns (uint256);
931 
932     function getStakedTokens(address user) external view returns (uint256[] memory dungeons, uint256[] memory avatars, 
933                                                                   uint256[] memory quests);
934   
935 }
936 // File: default_workspace/contracts/ERC721.sol
937 
938 
939 pragma solidity >=0.8.0;
940 
941 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
942 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
943 /// @dev Note that balanceOf does not revert if passed the zero address, in defiance of the ERC.
944 abstract contract ERC721 {
945     /*///////////////////////////////////////////////////////////////
946                                  EVENTS
947     //////////////////////////////////////////////////////////////*/
948 
949     event Transfer(address indexed from, address indexed to, uint256 indexed id);
950 
951     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
952 
953     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
954 
955     /*///////////////////////////////////////////////////////////////
956                           METADATA STORAGE/LOGIC
957     //////////////////////////////////////////////////////////////*/
958 
959     string public name;
960 
961     string public symbol;
962 
963     function tokenURI(uint256 id) public view virtual returns (string memory);
964 
965     /*///////////////////////////////////////////////////////////////
966                             ERC721 STORAGE                        
967     //////////////////////////////////////////////////////////////*/
968 
969     mapping(address => uint256) public balanceOf;
970 
971     mapping(uint256 => address) public ownerOf;
972 
973     mapping(uint256 => address) public getApproved;
974 
975     mapping(address => mapping(address => bool)) public isApprovedForAll;
976 
977     /*///////////////////////////////////////////////////////////////
978                               CONSTRUCTOR
979     //////////////////////////////////////////////////////////////*/
980 
981     constructor(string memory _name, string memory _symbol) {
982         name = _name;
983         symbol = _symbol;
984     }
985 
986     /*///////////////////////////////////////////////////////////////
987                               ERC721 LOGIC
988     //////////////////////////////////////////////////////////////*/
989 
990     function approve(address spender, uint256 id) public virtual {
991         address owner = ownerOf[id];
992 
993         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
994 
995         getApproved[id] = spender;
996 
997         emit Approval(owner, spender, id);
998     }
999 
1000     function setApprovalForAll(address operator, bool approved) public virtual {
1001         isApprovedForAll[msg.sender][operator] = approved;
1002 
1003         emit ApprovalForAll(msg.sender, operator, approved);
1004     }
1005 
1006     function transferFrom(
1007         address from,
1008         address to,
1009         uint256 id
1010     ) public virtual {
1011         require(from == ownerOf[id], "WRONG_FROM");
1012 
1013         require(to != address(0), "INVALID_RECIPIENT");
1014 
1015         require(
1016             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
1017             "NOT_AUTHORIZED"
1018         );
1019 
1020         // Underflow of the sender's balance is impossible because we check for
1021         // ownership above and the recipient's balance can't realistically overflow.
1022         unchecked {
1023             balanceOf[from]--;
1024 
1025             balanceOf[to]++;
1026         }
1027 
1028         ownerOf[id] = to;
1029 
1030         delete getApproved[id];
1031 
1032         emit Transfer(from, to, id);
1033     }
1034 
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 id
1039     ) public virtual {
1040         transferFrom(from, to, id);
1041 
1042         require(
1043             to.code.length == 0 ||
1044                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
1045                 ERC721TokenReceiver.onERC721Received.selector,
1046             "UNSAFE_RECIPIENT"
1047         );
1048     }
1049 
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 id,
1054         bytes memory data
1055     ) public virtual {
1056         transferFrom(from, to, id);
1057 
1058         require(
1059             to.code.length == 0 ||
1060                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
1061                 ERC721TokenReceiver.onERC721Received.selector,
1062             "UNSAFE_RECIPIENT"
1063         );
1064     }
1065 
1066     /*///////////////////////////////////////////////////////////////
1067                               ERC165 LOGIC
1068     //////////////////////////////////////////////////////////////*/
1069 
1070     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
1071         return
1072             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
1073             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
1074             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
1075     }
1076 
1077     /*///////////////////////////////////////////////////////////////
1078                        INTERNAL MINT/BURN LOGIC
1079     //////////////////////////////////////////////////////////////*/
1080 
1081     function _mint(address to, uint256 id) internal virtual {
1082         require(to != address(0), "INVALID_RECIPIENT");
1083 
1084         require(ownerOf[id] == address(0), "ALREADY_MINTED");
1085 
1086         // Counter overflow is incredibly unrealistic.
1087         unchecked {
1088             balanceOf[to]++;
1089         }
1090 
1091         ownerOf[id] = to;
1092 
1093         emit Transfer(address(0), to, id);
1094     }
1095 
1096     function _burn(uint256 id) internal virtual {
1097         address owner = ownerOf[id];
1098 
1099         require(ownerOf[id] != address(0), "NOT_MINTED");
1100 
1101         // Ownership check above ensures no underflow.
1102         unchecked {
1103             balanceOf[owner]--;
1104         }
1105 
1106         delete ownerOf[id];
1107 
1108         delete getApproved[id];
1109 
1110         emit Transfer(owner, address(0), id);
1111     }
1112 
1113     /*///////////////////////////////////////////////////////////////
1114                        INTERNAL SAFE MINT LOGIC
1115     //////////////////////////////////////////////////////////////*/
1116 
1117     function _safeMint(address to, uint256 id) internal virtual {
1118         _mint(to, id);
1119 
1120         require(
1121             to.code.length == 0 ||
1122                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
1123                 ERC721TokenReceiver.onERC721Received.selector,
1124             "UNSAFE_RECIPIENT"
1125         );
1126     }
1127 
1128     function _safeMint(
1129         address to,
1130         uint256 id,
1131         bytes memory data
1132     ) internal virtual {
1133         _mint(to, id);
1134 
1135         require(
1136             to.code.length == 0 ||
1137                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
1138                 ERC721TokenReceiver.onERC721Received.selector,
1139             "UNSAFE_RECIPIENT"
1140         );
1141     }
1142 }
1143 
1144 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
1145 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
1146 interface ERC721TokenReceiver {
1147     function onERC721Received(
1148         address operator,
1149         address from,
1150         uint256 id,
1151         bytes calldata data
1152     ) external returns (bytes4);
1153 }
1154 
1155 // File: default_workspace/contracts/IDNGToken.sol
1156 
1157 
1158 pragma solidity ^0.8.12;
1159 
1160 interface IDNGToken {
1161     enum NftType {
1162         Dungeon,
1163         Avatar,
1164         Quest
1165     }
1166 }
1167 
1168 // File: default_workspace/contracts/DungeonRewards.sol
1169 
1170 
1171 pragma solidity ^0.8.12;
1172 
1173 
1174 
1175 
1176 
1177 
1178 /**
1179  ________  ___  ___  ________   ________  _______   ________  ________          
1180 |\   ___ \|\  \|\  \|\   ___  \|\   ____\|\  ___ \ |\   __  \|\   ___  \        
1181 \ \  \_|\ \ \  \\\  \ \  \\ \  \ \  \___|\ \   __/|\ \  \|\  \ \  \\ \  \       
1182  \ \  \ \\ \ \  \\\  \ \  \\ \  \ \  \  __\ \  \_|/_\ \  \\\  \ \  \\ \  \      
1183   \ \  \_\\ \ \  \\\  \ \  \\ \  \ \  \|\  \ \  \_|\ \ \  \\\  \ \  \\ \  \     
1184    \ \_______\ \_______\ \__\\ \__\ \_______\ \_______\ \_______\ \__\\ \__\    
1185     \|_______|\|_______|\|__| \|__|\|_______|\|_______|\|_______|\|__| \|__|    
1186                                                                                 
1187                                                                                 
1188                                                                                 
1189  ________  _______   ___       __   ________  ________  ________  ________      
1190 |\   __  \|\  ___ \ |\  \     |\  \|\   __  \|\   __  \|\   ___ \|\   ____\     
1191 \ \  \|\  \ \   __/|\ \  \    \ \  \ \  \|\  \ \  \|\  \ \  \_|\ \ \  \___|_    
1192  \ \   _  _\ \  \_|/_\ \  \  __\ \  \ \   __  \ \   _  _\ \  \ \\ \ \_____  \   
1193   \ \  \\  \\ \  \_|\ \ \  \|\__\_\  \ \  \ \  \ \  \\  \\ \  \_\\ \|____|\  \  
1194    \ \__\\ _\\ \_______\ \____________\ \__\ \__\ \__\\ _\\ \_______\____\_\  \ 
1195     \|__|\|__|\|_______|\|____________|\|__|\|__|\|__|\|__|\|_______|\_________\
1196                                                                     \|_________|
1197                                                                                 
1198 **/
1199 
1200 contract DungeonRewards is IDungeonRewards, IDNGToken, FxBaseRootTunnel, Ownable {
1201     /*///////////////////////////////////////////////////////////////
1202                             STORAGE
1203     //////////////////////////////////////////////////////////////*/
1204 
1205     ERC721 public dungeonContract;
1206     ERC721 public avatarContract;
1207     ERC721 public questContract;
1208 
1209     struct Staker {
1210         uint256[] stakedDungeons;
1211         uint256 dungeonStakedOn;     // timestamp of when holder first staked their dungeon(s) (used to calculated eligibility for avatars).
1212         uint256[] stakedAvatars;
1213         uint256 avatarStakedOn;     // timestamp of when holder first staked their avatar(s)
1214         uint256[] stakedQuests;
1215         uint256 questStakedOn;     // timestamp of when holder first staked their quest(s)
1216     }
1217 
1218     mapping(address => Staker) public userInfo;
1219 
1220     bool public stakingPaused;
1221 
1222     constructor(
1223         address checkpointManager,
1224         address fxRoot,
1225         address _dungeonContract
1226     ) FxBaseRootTunnel(checkpointManager, fxRoot) {
1227         dungeonContract = ERC721(_dungeonContract);
1228     }
1229 
1230     // @notice Set the contract addresses for all future instances.
1231     function setContractAddresses(
1232         address _avatarContract,
1233         address _questContract
1234     ) public onlyOwner {
1235         avatarContract = ERC721(_avatarContract);
1236         questContract = ERC721(_questContract);
1237     }
1238 
1239     // Pause staking and unstaking
1240     function setStakingPaused(bool paused) public onlyOwner {
1241         stakingPaused = paused;
1242     }
1243 
1244 
1245     // For collab.land to give a role based on staking status
1246     function balanceOf(address owner) public view returns (uint256) {
1247         if(balanceOfDungeons(owner)>0 && balanceOfAvatars(owner)>0 && balanceOfQuests(owner)>0) return 3;
1248         if(balanceOfDungeons(owner)>0 && balanceOfAvatars(owner)>0 && balanceOfQuests(owner)==0) return 2;
1249         if(balanceOfDungeons(owner)>0 && balanceOfAvatars(owner)==0 && balanceOfQuests(owner)==0) return 1;
1250         return 0;
1251     }
1252 
1253     // so we can confirm whether a wallet holds any staked dungeons, useful for Generative Avatars gas-only mint
1254     function balanceOfDungeons(address owner) public view returns (uint256) {
1255         return userInfo[owner].stakedDungeons.length;
1256     }
1257     // so we can confirm when a wallet staked their dungeons, useful for Generative Avatars gas-only mint
1258     function dungeonFirstStaked(address owner) public view returns (uint256) {
1259         return userInfo[owner].dungeonStakedOn;
1260     }
1261 
1262     function balanceOfAvatars(address owner) public view returns (uint256) {
1263         return userInfo[owner].stakedAvatars.length;
1264     }
1265     function avatarFirstStaked(address owner) public view returns (uint256) {
1266         return userInfo[owner].avatarStakedOn;
1267     }
1268 
1269     function balanceOfQuests(address owner) public view returns (uint256) {
1270         return userInfo[owner].stakedQuests.length;
1271     }
1272     function questFirstStaked(address owner) public view returns (uint256) {
1273         return userInfo[owner].questStakedOn;
1274     }
1275 
1276 
1277     // get staked tokens for address
1278     function getStakedTokens(address user) public view returns (
1279             uint256[] memory dungeons,
1280             uint256[] memory avatars,
1281             uint256[] memory quests
1282         )
1283     {
1284         Staker memory staker = userInfo[user];
1285         return (
1286             staker.stakedDungeons,
1287             staker.stakedAvatars,
1288             staker.stakedQuests
1289         );
1290     }
1291 
1292     function bulkStake(
1293         uint256[] memory dungeons,
1294         uint256[] memory avatars,
1295         uint256[] memory quests
1296     ) public {
1297         if (dungeons.length > 0) stakeMultipleDungeons(dungeons);
1298         if (avatars.length > 0) stakeMultipleAvatars(avatars);
1299         if (quests.length > 0) stakeMultipleQuests(quests);        
1300     }
1301 
1302     function bulkUnstake(
1303         uint256[] memory dungeons,
1304         uint256[] memory avatars,
1305         uint256[] memory quests
1306     ) public {
1307         if (dungeons.length > 0) unstakeMultipleDungeons(dungeons);
1308         if (avatars.length > 0) unstakeMultipleAvatars(avatars);
1309         if (quests.length > 0) unstakeMultipleQuests(quests);        
1310     }
1311 
1312     function stakeMultipleDungeons(uint256[] memory tokenIds) public {
1313         require(!stakingPaused, "Staking currently paused.");
1314         require(tokenIds.length>0, "No tokenIds provided.");
1315 
1316         Staker storage staker = userInfo[msg.sender];
1317 
1318         if (staker.dungeonStakedOn == 0) { // set our dungeon staked on once (if they unstake, it resets to zero and will be reset when they stake again)
1319             staker.dungeonStakedOn = block.timestamp; 
1320         }
1321 
1322         for (uint256 i = 0; i < tokenIds.length; i++) {
1323             staker.stakedDungeons.push(tokenIds[i]);
1324             dungeonContract.transferFrom(
1325                 msg.sender,
1326                 address(this),
1327                 tokenIds[i]
1328             );
1329         }
1330         // start accumulating $DNG rewards on polygon
1331         _sendMessageToChild(
1332             abi.encode(
1333                 msg.sender,
1334                 uint256(NftType.Dungeon),
1335                 tokenIds.length,
1336                 true
1337             )
1338         );
1339     }
1340 
1341     function unstakeMultipleDungeons(uint256[] memory tokenIds) public {
1342         require(!stakingPaused, "Staking is currently paused.");
1343         Staker storage staker = userInfo[msg.sender];
1344         for (uint256 i = 0; i < tokenIds.length; i++) {
1345             uint256 tokenId = tokenIds[i];
1346             require(containsElement(staker.stakedDungeons, tokenId), "Not dungeon owner.");
1347             dungeonContract.transferFrom(
1348                 address(this),
1349                 msg.sender,
1350                 tokenId
1351             );
1352             removeDungeonFromStaker(staker, tokenId);
1353         }
1354 
1355         if (staker.stakedDungeons.length == 0) { // no more staked dungeons? 
1356             staker.dungeonStakedOn = 0; // then we reset the staked on date to 0 (so can be set to block.timestamp when it's staked again)
1357         }
1358         // stop accumulating $DNG rewards on polygon for these dungeons
1359         _sendMessageToChild(
1360             abi.encode(
1361                 msg.sender,
1362                 uint256(NftType.Dungeon),
1363                 tokenIds.length,
1364                 false
1365             )
1366         );
1367     }
1368 
1369     // Stake a single Dungeon (separate function to optimize for gas)
1370     // @param tokenId The tokenId of the dungeon to stake
1371     function stakeDungeon(uint256 tokenId) external {
1372         require(!stakingPaused, "Staking is currently paused.");
1373         Staker storage staker = userInfo[msg.sender];
1374         staker.stakedDungeons.push(tokenId);
1375         dungeonContract.transferFrom(
1376             msg.sender,
1377             address(this),
1378             tokenId
1379         );
1380         if (staker.dungeonStakedOn == 0) { // set our dungeon staked on once (if they unstake, it resets to zero and will be reset when they stake again)
1381             staker.dungeonStakedOn = block.timestamp; 
1382         }
1383         // start accumulating $DNG rewards on polygon
1384         _sendMessageToChild(
1385             abi.encode(
1386                 msg.sender,
1387                 uint256(NftType.Dungeon),
1388                 1,
1389                 true
1390             )
1391         );
1392     }
1393 
1394     // Unstake a Dungeon
1395     // @param tokenId The tokenId of the dungeon to unstake
1396     function unstakeDungeon(uint256 tokenId) external {
1397         require(!stakingPaused, "Staking is currently paused.");
1398         Staker storage staker = userInfo[msg.sender];
1399         require(containsElement(staker.stakedDungeons, tokenId), "Not dungeon owner.");
1400 
1401         dungeonContract.transferFrom(
1402             address(this),
1403             msg.sender,
1404             tokenId
1405         );
1406 
1407         removeDungeonFromStaker(staker, tokenId);
1408 
1409         if (staker.stakedDungeons.length == 0) { // no more staked dungeons? 
1410             staker.dungeonStakedOn = 0; // then we reset the staked on date to 0 (so can be set to block.timestamp when it's staked again)
1411         }
1412 
1413         // stop accumulating $DNG rewards on polygon for these dungeons
1414         _sendMessageToChild(
1415             abi.encode(
1416                 msg.sender,
1417                 uint256(NftType.Dungeon),
1418                 1,
1419                 false
1420             )
1421         );
1422 
1423     }
1424 
1425     function stakeMultipleAvatars(uint256[] memory tokenIds) public {
1426         require(!stakingPaused, "Staking currently paused.");
1427         require(tokenIds.length>0, "No tokenIds provided.");
1428 
1429         Staker storage staker = userInfo[msg.sender];
1430 
1431         if (staker.avatarStakedOn == 0) { // set our avatar staked on once (if they unstake, it resets to zero and will be reset when they stake again)
1432             staker.avatarStakedOn = block.timestamp; 
1433         }
1434 
1435         for (uint256 i = 0; i < tokenIds.length; i++) {
1436             staker.stakedAvatars.push(tokenIds[i]);
1437             avatarContract.transferFrom(
1438                 msg.sender,
1439                 address(this),
1440                 tokenIds[i]
1441             );
1442         }
1443         // start accumulating $DNG rewards on polygon
1444         _sendMessageToChild(
1445             abi.encode(
1446                 msg.sender,
1447                 uint256(NftType.Avatar),
1448                 tokenIds.length,
1449                 true
1450             )
1451         );
1452     }
1453 
1454     function unstakeMultipleAvatars(uint256[] memory tokenIds) public {
1455         require(!stakingPaused, "Staking is currently paused.");
1456         Staker storage staker = userInfo[msg.sender];
1457         for (uint256 i = 0; i < tokenIds.length; i++) {
1458             uint256 tokenId = tokenIds[i];
1459             require(containsElement(staker.stakedAvatars, tokenId), "Not avatar owner.");
1460             avatarContract.transferFrom(
1461                 address(this),
1462                 msg.sender,
1463                 tokenId
1464             );
1465             removeAvatarFromStaker(staker, tokenId);
1466         }
1467 
1468         if (staker.stakedAvatars.length == 0) { // no more staked avatars? 
1469             staker.avatarStakedOn = 0; // then we reset the staked on date to 0 (so can be set to block.timestamp when it's staked again)
1470         }
1471         // stop accumulating $DNG rewards on polygon for these avatars
1472         _sendMessageToChild(
1473             abi.encode(
1474                 msg.sender,
1475                 uint256(NftType.Avatar),
1476                 tokenIds.length,
1477                 false
1478             )
1479         );
1480     }
1481 
1482     // Stake a single Avatar (separate function to optimize for gas)
1483     // @param tokenId The tokenId of the avatar to stake
1484     function stakeAvatar(uint256 tokenId) external {
1485         require(!stakingPaused, "Staking is currently paused.");
1486         Staker storage staker = userInfo[msg.sender];
1487         staker.stakedAvatars.push(tokenId);
1488         avatarContract.transferFrom(
1489             msg.sender,
1490             address(this),
1491             tokenId
1492         );
1493         if (staker.avatarStakedOn == 0) { // set our avatar staked on once (if they unstake, it resets to zero and will be reset when they stake again)
1494             staker.avatarStakedOn = block.timestamp; 
1495         }
1496         // start accumulating $DNG rewards on polygon
1497         _sendMessageToChild(
1498             abi.encode(
1499                 msg.sender,
1500                 uint256(NftType.Avatar),
1501                 1,
1502                 true
1503             )
1504         );
1505     }
1506 
1507     // Unstake a Avatar
1508     // @param tokenId The tokenId of the avatar to unstake
1509     function unstakeAvatar(uint256 tokenId) external {
1510         require(!stakingPaused, "Staking is currently paused.");
1511         Staker storage staker = userInfo[msg.sender];
1512         require(containsElement(staker.stakedAvatars, tokenId), "Not avatar owner.");
1513 
1514         avatarContract.transferFrom(
1515             address(this),
1516             msg.sender,
1517             tokenId
1518         );
1519 
1520         removeAvatarFromStaker(staker, tokenId);
1521 
1522         if (staker.stakedAvatars.length == 0) { // no more staked avatars? 
1523             staker.avatarStakedOn = 0; // then we reset the staked on date to 0 (so can be set to block.timestamp when it's staked again)
1524         }
1525 
1526         // stop accumulating $DNG rewards on polygon for these avatars
1527         _sendMessageToChild(
1528             abi.encode(
1529                 msg.sender,
1530                 uint256(NftType.Avatar),
1531                 1,
1532                 false
1533             )
1534         );
1535 
1536     }
1537 
1538 
1539     function stakeMultipleQuests(uint256[] memory tokenIds) public {
1540         require(!stakingPaused, "Staking currently paused.");
1541         require(tokenIds.length>0, "No tokenIds provided.");
1542 
1543         Staker storage staker = userInfo[msg.sender];
1544 
1545         if (staker.questStakedOn == 0) { // set our quest staked on once (if they unstake, it resets to zero and will be reset when they stake again)
1546             staker.questStakedOn = block.timestamp; 
1547         }
1548 
1549         for (uint256 i = 0; i < tokenIds.length; i++) {
1550             staker.stakedQuests.push(tokenIds[i]);
1551             questContract.transferFrom(
1552                 msg.sender,
1553                 address(this),
1554                 tokenIds[i]
1555             );
1556         }
1557         // start accumulating $DNG rewards on polygon
1558         _sendMessageToChild(
1559             abi.encode(
1560                 msg.sender,
1561                 uint256(NftType.Quest),
1562                 tokenIds.length,
1563                 true
1564             )
1565         );
1566     }
1567 
1568     function unstakeMultipleQuests(uint256[] memory tokenIds) public {
1569         require(!stakingPaused, "Staking is currently paused.");
1570         Staker storage staker = userInfo[msg.sender];
1571         for (uint256 i = 0; i < tokenIds.length; i++) {
1572             uint256 tokenId = tokenIds[i];
1573             require(containsElement(staker.stakedQuests, tokenId), "Not quest owner.");
1574             questContract.transferFrom(
1575                 address(this),
1576                 msg.sender,
1577                 tokenId
1578             );
1579             removeQuestFromStaker(staker, tokenId);
1580         }
1581 
1582         if (staker.stakedQuests.length == 0) { // no more staked quests? 
1583             staker.questStakedOn = 0; // then we reset the staked on date to 0 (so can be set to block.timestamp when it's staked again)
1584         }
1585         // stop accumulating $DNG rewards on polygon for these quests
1586         _sendMessageToChild(
1587             abi.encode(
1588                 msg.sender,
1589                 uint256(NftType.Quest),
1590                 tokenIds.length,
1591                 false
1592             )
1593         );
1594     }
1595 
1596     // Stake a single Quest (separate function to optimize for gas)
1597     // @param tokenId The tokenId of the quest to stake
1598     function stakeQuest(uint256 tokenId) external {
1599         require(!stakingPaused, "Staking is currently paused.");
1600         Staker storage staker = userInfo[msg.sender];
1601         staker.stakedQuests.push(tokenId);
1602         questContract.transferFrom(
1603             msg.sender,
1604             address(this),
1605             tokenId
1606         );
1607         if (staker.questStakedOn == 0) { // set our quest staked on once (if they unstake, it resets to zero and will be reset when they stake again)
1608             staker.questStakedOn = block.timestamp; 
1609         }
1610 
1611         // start accumulating $DNG rewards on polygon
1612         _sendMessageToChild(
1613             abi.encode(
1614                 msg.sender,
1615                 uint256(NftType.Quest),
1616                 1,
1617                 true
1618             )
1619         );
1620     }
1621 
1622     // Unstake a Quest
1623     // @param tokenId The tokenId of the quest to unstake
1624     function unstakeQuest(uint256 tokenId) external {
1625         require(!stakingPaused, "Staking is currently paused.");
1626         Staker storage staker = userInfo[msg.sender];
1627         require(containsElement(staker.stakedQuests, tokenId), "Not quest owner.");
1628 
1629         questContract.transferFrom(
1630             address(this),
1631             msg.sender,
1632             tokenId
1633         );
1634 
1635         removeQuestFromStaker(staker, tokenId);
1636 
1637         if (staker.stakedQuests.length == 0) { // no more staked quests? 
1638             staker.questStakedOn = 0; // then we reset the staked on date to 0 (so can be set to block.timestamp when it's staked again)
1639         }
1640 
1641         // stop accumulating $DNG rewards on polygon for these quests
1642         _sendMessageToChild(
1643             abi.encode(
1644                 msg.sender,
1645                 uint256(NftType.Quest),
1646                 1,
1647                 false
1648             )
1649         );
1650 
1651     }
1652 
1653     function removeDungeonFromStaker(Staker storage staker, uint256 tokenId) private {
1654         uint256[] memory stakedDungeons = staker.stakedDungeons;
1655         uint256 index;
1656         for (uint256 j; j < stakedDungeons.length; j++) {
1657             if (stakedDungeons[j] == tokenId) index = j;
1658         }
1659         if (stakedDungeons[index] == tokenId) {
1660             staker.stakedDungeons[index] = stakedDungeons[
1661                 staker.stakedDungeons.length - 1
1662             ];
1663             staker.stakedDungeons.pop();
1664         }
1665     }
1666 
1667     function removeAvatarFromStaker(Staker storage staker, uint256 tokenId) private {
1668         uint256[] memory stakedAvatars = staker.stakedAvatars;
1669         uint256 index;
1670         for (uint256 j; j < stakedAvatars.length; j++) {
1671             if (stakedAvatars[j] == tokenId) index = j;
1672         }
1673         if (stakedAvatars[index] == tokenId) {
1674             staker.stakedAvatars[index] = stakedAvatars[
1675                 staker.stakedAvatars.length - 1
1676             ];
1677             staker.stakedAvatars.pop();
1678         }
1679     }
1680 
1681     function removeQuestFromStaker(Staker storage staker, uint256 tokenId) private {
1682         uint256[] memory stakedQuests = staker.stakedQuests;
1683         uint256 index;
1684         for (uint256 j; j < stakedQuests.length; j++) {
1685             if (stakedQuests[j] == tokenId) index = j;
1686         }
1687         if (stakedQuests[index] == tokenId) {
1688             staker.stakedQuests[index] = stakedQuests[
1689                 staker.stakedQuests.length - 1
1690             ];
1691             staker.stakedQuests.pop();
1692         }
1693     }
1694 
1695     function _processMessageFromChild(bytes memory message) internal override {
1696         // we don't process any messages from the child chain (Polygon)
1697     }
1698 
1699     function containsElement(uint[] memory elements, uint tokenId) internal pure returns (bool) {
1700         for (uint256 i = 0; i < elements.length; i++) {
1701            if(elements[i] == tokenId) return true;
1702         }
1703         return false;
1704     }
1705 
1706 
1707     /**
1708      * Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1709      * by `operator` from `from`, this function is called.
1710      *
1711      * It must return its Solidity selector to confirm the token transfer.
1712      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1713      *
1714      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1715      */
1716     function onERC721Received(
1717         address operator,
1718         address from,
1719         uint256 id,
1720         bytes calldata data
1721     ) external pure returns (bytes4) {
1722         return ERC721TokenReceiver.onERC721Received.selector;
1723     }
1724 
1725 }