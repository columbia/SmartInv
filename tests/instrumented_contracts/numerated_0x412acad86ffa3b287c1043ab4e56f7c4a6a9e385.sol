1 // SPDX-License-Identifier: MIT
2 // File: contracts/fx-portal/lib/Merkle.sol
3 
4 
5 pragma solidity ^0.8.0;
6 
7 library Merkle {
8     function checkMembership(
9         bytes32 leaf,
10         uint256 index,
11         bytes32 rootHash,
12         bytes memory proof
13     ) internal pure returns (bool) {
14         require(proof.length % 32 == 0, "Invalid proof length");
15         uint256 proofHeight = proof.length / 32;
16         // Proof of size n means, height of the tree is n+1.
17         // In a tree of height n+1, max #leafs possible is 2 ^ n
18         require(index < 2**proofHeight, "Leaf index is too big");
19 
20         bytes32 proofElement;
21         bytes32 computedHash = leaf;
22         for (uint256 i = 32; i <= proof.length; i += 32) {
23             assembly {
24                 proofElement := mload(add(proof, i))
25             }
26 
27             if (index % 2 == 0) {
28                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
29             } else {
30                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
31             }
32 
33             index = index / 2;
34         }
35         return computedHash == rootHash;
36     }
37 }
38 
39 // File: contracts/fx-portal/lib/RLPReader.sol
40 
41 /*
42  * @author Hamdi Allam hamdi.allam97@gmail.com
43  * Please reach out with any questions or concerns
44  */
45 pragma solidity ^0.8.0;
46 
47 library RLPReader {
48     uint8 constant STRING_SHORT_START = 0x80;
49     uint8 constant STRING_LONG_START = 0xb8;
50     uint8 constant LIST_SHORT_START = 0xc0;
51     uint8 constant LIST_LONG_START = 0xf8;
52     uint8 constant WORD_SIZE = 32;
53 
54     struct RLPItem {
55         uint256 len;
56         uint256 memPtr;
57     }
58 
59     struct Iterator {
60         RLPItem item; // Item that's being iterated over.
61         uint256 nextPtr; // Position of the next item in the list.
62     }
63 
64     /*
65      * @dev Returns the next element in the iteration. Reverts if it has not next element.
66      * @param self The iterator.
67      * @return The next element in the iteration.
68      */
69     function next(Iterator memory self) internal pure returns (RLPItem memory) {
70         require(hasNext(self));
71 
72         uint256 ptr = self.nextPtr;
73         uint256 itemLength = _itemLength(ptr);
74         self.nextPtr = ptr + itemLength;
75 
76         return RLPItem(itemLength, ptr);
77     }
78 
79     /*
80      * @dev Returns true if the iteration has more elements.
81      * @param self The iterator.
82      * @return true if the iteration has more elements.
83      */
84     function hasNext(Iterator memory self) internal pure returns (bool) {
85         RLPItem memory item = self.item;
86         return self.nextPtr < item.memPtr + item.len;
87     }
88 
89     /*
90      * @param item RLP encoded bytes
91      */
92     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
93         uint256 memPtr;
94         assembly {
95             memPtr := add(item, 0x20)
96         }
97 
98         return RLPItem(item.length, memPtr);
99     }
100 
101     /*
102      * @dev Create an iterator. Reverts if item is not a list.
103      * @param self The RLP item.
104      * @return An 'Iterator' over the item.
105      */
106     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
107         require(isList(self));
108 
109         uint256 ptr = self.memPtr + _payloadOffset(self.memPtr);
110         return Iterator(self, ptr);
111     }
112 
113     /*
114      * @param item RLP encoded bytes
115      */
116     function rlpLen(RLPItem memory item) internal pure returns (uint256) {
117         return item.len;
118     }
119 
120     /*
121      * @param item RLP encoded bytes
122      */
123     function payloadLen(RLPItem memory item) internal pure returns (uint256) {
124         return item.len - _payloadOffset(item.memPtr);
125     }
126 
127     /*
128      * @param item RLP encoded list in bytes
129      */
130     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
131         require(isList(item));
132 
133         uint256 items = numItems(item);
134         RLPItem[] memory result = new RLPItem[](items);
135 
136         uint256 memPtr = item.memPtr + _payloadOffset(item.memPtr);
137         uint256 dataLen;
138         for (uint256 i = 0; i < items; i++) {
139             dataLen = _itemLength(memPtr);
140             result[i] = RLPItem(dataLen, memPtr);
141             memPtr = memPtr + dataLen;
142         }
143 
144         return result;
145     }
146 
147     // @return indicator whether encoded payload is a list. negate this function call for isData.
148     function isList(RLPItem memory item) internal pure returns (bool) {
149         if (item.len == 0) return false;
150 
151         uint8 byte0;
152         uint256 memPtr = item.memPtr;
153         assembly {
154             byte0 := byte(0, mload(memPtr))
155         }
156 
157         if (byte0 < LIST_SHORT_START) return false;
158         return true;
159     }
160 
161     /*
162      * @dev A cheaper version of keccak256(toRlpBytes(item)) that avoids copying memory.
163      * @return keccak256 hash of RLP encoded bytes.
164      */
165     function rlpBytesKeccak256(RLPItem memory item) internal pure returns (bytes32) {
166         uint256 ptr = item.memPtr;
167         uint256 len = item.len;
168         bytes32 result;
169         assembly {
170             result := keccak256(ptr, len)
171         }
172         return result;
173     }
174 
175     function payloadLocation(RLPItem memory item) internal pure returns (uint256, uint256) {
176         uint256 offset = _payloadOffset(item.memPtr);
177         uint256 memPtr = item.memPtr + offset;
178         uint256 len = item.len - offset; // data length
179         return (memPtr, len);
180     }
181 
182     /*
183      * @dev A cheaper version of keccak256(toBytes(item)) that avoids copying memory.
184      * @return keccak256 hash of the item payload.
185      */
186     function payloadKeccak256(RLPItem memory item) internal pure returns (bytes32) {
187         (uint256 memPtr, uint256 len) = payloadLocation(item);
188         bytes32 result;
189         assembly {
190             result := keccak256(memPtr, len)
191         }
192         return result;
193     }
194 
195     /** RLPItem conversions into data types **/
196 
197     // @returns raw rlp encoding in bytes
198     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
199         bytes memory result = new bytes(item.len);
200         if (result.length == 0) return result;
201 
202         uint256 ptr;
203         assembly {
204             ptr := add(0x20, result)
205         }
206 
207         copy(item.memPtr, ptr, item.len);
208         return result;
209     }
210 
211     // any non-zero byte is considered true
212     function toBoolean(RLPItem memory item) internal pure returns (bool) {
213         require(item.len == 1);
214         uint256 result;
215         uint256 memPtr = item.memPtr;
216         assembly {
217             result := byte(0, mload(memPtr))
218         }
219 
220         return result == 0 ? false : true;
221     }
222 
223     function toAddress(RLPItem memory item) internal pure returns (address) {
224         // 1 byte for the length prefix
225         require(item.len == 21);
226 
227         return address(uint160(toUint(item)));
228     }
229 
230     function toUint(RLPItem memory item) internal pure returns (uint256) {
231         require(item.len > 0 && item.len <= 33);
232 
233         uint256 offset = _payloadOffset(item.memPtr);
234         uint256 len = item.len - offset;
235 
236         uint256 result;
237         uint256 memPtr = item.memPtr + offset;
238         assembly {
239             result := mload(memPtr)
240 
241             // shfit to the correct location if neccesary
242             if lt(len, 32) {
243                 result := div(result, exp(256, sub(32, len)))
244             }
245         }
246 
247         return result;
248     }
249 
250     // enforces 32 byte length
251     function toUintStrict(RLPItem memory item) internal pure returns (uint256) {
252         // one byte prefix
253         require(item.len == 33);
254 
255         uint256 result;
256         uint256 memPtr = item.memPtr + 1;
257         assembly {
258             result := mload(memPtr)
259         }
260 
261         return result;
262     }
263 
264     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
265         require(item.len > 0);
266 
267         uint256 offset = _payloadOffset(item.memPtr);
268         uint256 len = item.len - offset; // data length
269         bytes memory result = new bytes(len);
270 
271         uint256 destPtr;
272         assembly {
273             destPtr := add(0x20, result)
274         }
275 
276         copy(item.memPtr + offset, destPtr, len);
277         return result;
278     }
279 
280     /*
281      * Private Helpers
282      */
283 
284     // @return number of payload items inside an encoded list.
285     function numItems(RLPItem memory item) private pure returns (uint256) {
286         if (item.len == 0) return 0;
287 
288         uint256 count = 0;
289         uint256 currPtr = item.memPtr + _payloadOffset(item.memPtr);
290         uint256 endPtr = item.memPtr + item.len;
291         while (currPtr < endPtr) {
292             currPtr = currPtr + _itemLength(currPtr); // skip over an item
293             count++;
294         }
295 
296         return count;
297     }
298 
299     // @return entire rlp item byte length
300     function _itemLength(uint256 memPtr) private pure returns (uint256) {
301         uint256 itemLen;
302         uint256 byte0;
303         assembly {
304             byte0 := byte(0, mload(memPtr))
305         }
306 
307         if (byte0 < STRING_SHORT_START) itemLen = 1;
308         else if (byte0 < STRING_LONG_START) itemLen = byte0 - STRING_SHORT_START + 1;
309         else if (byte0 < LIST_SHORT_START) {
310             assembly {
311                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
312                 memPtr := add(memPtr, 1) // skip over the first byte
313                 /* 32 byte word size */
314                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
315                 itemLen := add(dataLen, add(byteLen, 1))
316             }
317         } else if (byte0 < LIST_LONG_START) {
318             itemLen = byte0 - LIST_SHORT_START + 1;
319         } else {
320             assembly {
321                 let byteLen := sub(byte0, 0xf7)
322                 memPtr := add(memPtr, 1)
323 
324                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
325                 itemLen := add(dataLen, add(byteLen, 1))
326             }
327         }
328 
329         return itemLen;
330     }
331 
332     // @return number of bytes until the data
333     function _payloadOffset(uint256 memPtr) private pure returns (uint256) {
334         uint256 byte0;
335         assembly {
336             byte0 := byte(0, mload(memPtr))
337         }
338 
339         if (byte0 < STRING_SHORT_START) return 0;
340         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START)) return 1;
341         else if (byte0 < LIST_SHORT_START)
342             // being explicit
343             return byte0 - (STRING_LONG_START - 1) + 1;
344         else return byte0 - (LIST_LONG_START - 1) + 1;
345     }
346 
347     /*
348      * @param src Pointer to source
349      * @param dest Pointer to destination
350      * @param len Amount of memory to copy from the source
351      */
352     function copy(
353         uint256 src,
354         uint256 dest,
355         uint256 len
356     ) private pure {
357         if (len == 0) return;
358 
359         // copy as many word sizes as possible
360         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
361             assembly {
362                 mstore(dest, mload(src))
363             }
364 
365             src += WORD_SIZE;
366             dest += WORD_SIZE;
367         }
368 
369         if (len == 0) return;
370 
371         // left over bytes. Mask is used to remove unwanted bytes from the word
372         uint256 mask = 256**(WORD_SIZE - len) - 1;
373 
374         assembly {
375             let srcpart := and(mload(src), not(mask)) // zero out src
376             let destpart := and(mload(dest), mask) // retrieve the bytes
377             mstore(dest, or(destpart, srcpart))
378         }
379     }
380 }
381 
382 // File: contracts/fx-portal/lib/ExitPayloadReader.sol
383 
384 pragma solidity ^0.8.0;
385 
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
412     // copy paste of private copy() from RLPReader to avoid changing of existing contracts
413     function copy(
414         uint256 src,
415         uint256 dest,
416         uint256 len
417     ) private pure {
418         if (len == 0) return;
419 
420         // copy as many word sizes as possible
421         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
422             assembly {
423                 mstore(dest, mload(src))
424             }
425 
426             src += WORD_SIZE;
427             dest += WORD_SIZE;
428         }
429 
430         // left over bytes. Mask is used to remove unwanted bytes from the word
431         uint256 mask = 256**(WORD_SIZE - len) - 1;
432         assembly {
433             let srcpart := and(mload(src), not(mask)) // zero out src
434             let destpart := and(mload(dest), mask) // retrieve the bytes
435             mstore(dest, or(destpart, srcpart))
436         }
437     }
438 
439     function toExitPayload(bytes memory data) internal pure returns (ExitPayload memory) {
440         RLPReader.RLPItem[] memory payloadData = data.toRlpItem().toList();
441 
442         return ExitPayload(payloadData);
443     }
444 
445     function getHeaderNumber(ExitPayload memory payload) internal pure returns (uint256) {
446         return payload.data[0].toUint();
447     }
448 
449     function getBlockProof(ExitPayload memory payload) internal pure returns (bytes memory) {
450         return payload.data[1].toBytes();
451     }
452 
453     function getBlockNumber(ExitPayload memory payload) internal pure returns (uint256) {
454         return payload.data[2].toUint();
455     }
456 
457     function getBlockTime(ExitPayload memory payload) internal pure returns (uint256) {
458         return payload.data[3].toUint();
459     }
460 
461     function getTxRoot(ExitPayload memory payload) internal pure returns (bytes32) {
462         return bytes32(payload.data[4].toUint());
463     }
464 
465     function getReceiptRoot(ExitPayload memory payload) internal pure returns (bytes32) {
466         return bytes32(payload.data[5].toUint());
467     }
468 
469     function getReceipt(ExitPayload memory payload) internal pure returns (Receipt memory receipt) {
470         receipt.raw = payload.data[6].toBytes();
471         RLPReader.RLPItem memory receiptItem = receipt.raw.toRlpItem();
472 
473         if (receiptItem.isList()) {
474             // legacy tx
475             receipt.data = receiptItem.toList();
476         } else {
477             // pop first byte before parsting receipt
478             bytes memory typedBytes = receipt.raw;
479             bytes memory result = new bytes(typedBytes.length - 1);
480             uint256 srcPtr;
481             uint256 destPtr;
482             assembly {
483                 srcPtr := add(33, typedBytes)
484                 destPtr := add(0x20, result)
485             }
486 
487             copy(srcPtr, destPtr, result.length);
488             receipt.data = result.toRlpItem().toList();
489         }
490 
491         receipt.logIndex = getReceiptLogIndex(payload);
492         return receipt;
493     }
494 
495     function getReceiptProof(ExitPayload memory payload) internal pure returns (bytes memory) {
496         return payload.data[7].toBytes();
497     }
498 
499     function getBranchMaskAsBytes(ExitPayload memory payload) internal pure returns (bytes memory) {
500         return payload.data[8].toBytes();
501     }
502 
503     function getBranchMaskAsUint(ExitPayload memory payload) internal pure returns (uint256) {
504         return payload.data[8].toUint();
505     }
506 
507     function getReceiptLogIndex(ExitPayload memory payload) internal pure returns (uint256) {
508         return payload.data[9].toUint();
509     }
510 
511     // Receipt methods
512     function toBytes(Receipt memory receipt) internal pure returns (bytes memory) {
513         return receipt.raw;
514     }
515 
516     function getLog(Receipt memory receipt) internal pure returns (Log memory) {
517         RLPReader.RLPItem memory logData = receipt.data[3].toList()[receipt.logIndex];
518         return Log(logData, logData.toList());
519     }
520 
521     // Log methods
522     function getEmitter(Log memory log) internal pure returns (address) {
523         return RLPReader.toAddress(log.list[0]);
524     }
525 
526     function getTopics(Log memory log) internal pure returns (LogTopics memory) {
527         return LogTopics(log.list[1].toList());
528     }
529 
530     function getData(Log memory log) internal pure returns (bytes memory) {
531         return log.list[2].toBytes();
532     }
533 
534     function toRlpBytes(Log memory log) internal pure returns (bytes memory) {
535         return log.data.toRlpBytes();
536     }
537 
538     // LogTopics methods
539     function getField(LogTopics memory topics, uint256 index) internal pure returns (RLPReader.RLPItem memory) {
540         return topics.data[index];
541     }
542 }
543 
544 // File: contracts/fx-portal/lib/MerklePatriciaProof.sol
545 
546 
547 pragma solidity ^0.8.0;
548 
549 
550 library MerklePatriciaProof {
551     /*
552      * @dev Verifies a merkle patricia proof.
553      * @param value The terminating value in the trie.
554      * @param encodedPath The path in the trie leading to value.
555      * @param rlpParentNodes The rlp encoded stack of nodes.
556      * @param root The root hash of the trie.
557      * @return The boolean validity of the proof.
558      */
559     function verify(
560         bytes memory value,
561         bytes memory encodedPath,
562         bytes memory rlpParentNodes,
563         bytes32 root
564     ) internal pure returns (bool) {
565         RLPReader.RLPItem memory item = RLPReader.toRlpItem(rlpParentNodes);
566         RLPReader.RLPItem[] memory parentNodes = RLPReader.toList(item);
567 
568         bytes memory currentNode;
569         RLPReader.RLPItem[] memory currentNodeList;
570 
571         bytes32 nodeKey = root;
572         uint256 pathPtr = 0;
573 
574         bytes memory path = _getNibbleArray(encodedPath);
575         if (path.length == 0) {
576             return false;
577         }
578 
579         for (uint256 i = 0; i < parentNodes.length; i++) {
580             if (pathPtr > path.length) {
581                 return false;
582             }
583 
584             currentNode = RLPReader.toRlpBytes(parentNodes[i]);
585             if (nodeKey != keccak256(currentNode)) {
586                 return false;
587             }
588             currentNodeList = RLPReader.toList(parentNodes[i]);
589 
590             if (currentNodeList.length == 17) {
591                 if (pathPtr == path.length) {
592                     if (keccak256(RLPReader.toBytes(currentNodeList[16])) == keccak256(value)) {
593                         return true;
594                     } else {
595                         return false;
596                     }
597                 }
598 
599                 uint8 nextPathNibble = uint8(path[pathPtr]);
600                 if (nextPathNibble > 16) {
601                     return false;
602                 }
603                 nodeKey = bytes32(RLPReader.toUintStrict(currentNodeList[nextPathNibble]));
604                 pathPtr += 1;
605             } else if (currentNodeList.length == 2) {
606                 uint256 traversed = _nibblesToTraverse(RLPReader.toBytes(currentNodeList[0]), path, pathPtr);
607                 if (pathPtr + traversed == path.length) {
608                     //leaf node
609                     if (keccak256(RLPReader.toBytes(currentNodeList[1])) == keccak256(value)) {
610                         return true;
611                     } else {
612                         return false;
613                     }
614                 }
615 
616                 //extension node
617                 if (traversed == 0) {
618                     return false;
619                 }
620 
621                 pathPtr += traversed;
622                 nodeKey = bytes32(RLPReader.toUintStrict(currentNodeList[1]));
623             } else {
624                 return false;
625             }
626         }
627     }
628 
629     function _nibblesToTraverse(
630         bytes memory encodedPartialPath,
631         bytes memory path,
632         uint256 pathPtr
633     ) private pure returns (uint256) {
634         uint256 len = 0;
635         // encodedPartialPath has elements that are each two hex characters (1 byte), but partialPath
636         // and slicedPath have elements that are each one hex character (1 nibble)
637         bytes memory partialPath = _getNibbleArray(encodedPartialPath);
638         bytes memory slicedPath = new bytes(partialPath.length);
639 
640         // pathPtr counts nibbles in path
641         // partialPath.length is a number of nibbles
642         for (uint256 i = pathPtr; i < pathPtr + partialPath.length; i++) {
643             bytes1 pathNibble = path[i];
644             slicedPath[i - pathPtr] = pathNibble;
645         }
646 
647         if (keccak256(partialPath) == keccak256(slicedPath)) {
648             len = partialPath.length;
649         } else {
650             len = 0;
651         }
652         return len;
653     }
654 
655     // bytes b must be hp encoded
656     function _getNibbleArray(bytes memory b) internal pure returns (bytes memory) {
657         bytes memory nibbles = "";
658         if (b.length > 0) {
659             uint8 offset;
660             uint8 hpNibble = uint8(_getNthNibbleOfBytes(0, b));
661             if (hpNibble == 1 || hpNibble == 3) {
662                 nibbles = new bytes(b.length * 2 - 1);
663                 bytes1 oddNibble = _getNthNibbleOfBytes(1, b);
664                 nibbles[0] = oddNibble;
665                 offset = 1;
666             } else {
667                 nibbles = new bytes(b.length * 2 - 2);
668                 offset = 0;
669             }
670 
671             for (uint256 i = offset; i < nibbles.length; i++) {
672                 nibbles[i] = _getNthNibbleOfBytes(i - offset + 2, b);
673             }
674         }
675         return nibbles;
676     }
677 
678     function _getNthNibbleOfBytes(uint256 n, bytes memory str) private pure returns (bytes1) {
679         return bytes1(n % 2 == 0 ? uint8(str[n / 2]) / 0x10 : uint8(str[n / 2]) % 0x10);
680     }
681 }
682 
683 // File: contracts/fx-portal/tunnel/FxBaseRootTunnel.sol
684 
685 
686 pragma solidity ^0.8.0;
687 
688 
689 
690 
691 
692 interface IFxStateSender {
693     function sendMessageToChild(address _receiver, bytes calldata _data) external;
694 }
695 
696 contract ICheckpointManager {
697     struct HeaderBlock {
698         bytes32 root;
699         uint256 start;
700         uint256 end;
701         uint256 createdAt;
702         address proposer;
703     }
704 
705     /**
706      * @notice mapping of checkpoint header numbers to block details
707      * @dev These checkpoints are submited by plasma contracts
708      */
709     mapping(uint256 => HeaderBlock) public headerBlocks;
710 }
711 
712 abstract contract FxBaseRootTunnel {
713     using RLPReader for RLPReader.RLPItem;
714     using Merkle for bytes32;
715     using ExitPayloadReader for bytes;
716     using ExitPayloadReader for ExitPayloadReader.ExitPayload;
717     using ExitPayloadReader for ExitPayloadReader.Log;
718     using ExitPayloadReader for ExitPayloadReader.LogTopics;
719     using ExitPayloadReader for ExitPayloadReader.Receipt;
720 
721     // keccak256(MessageSent(bytes))
722     bytes32 public constant SEND_MESSAGE_EVENT_SIG = 0x8c5261668696ce22758910d05bab8f186d6eb247ceac2af2e82c7dc17669b036;
723 
724     // state sender contract
725     IFxStateSender public fxRoot;
726     // root chain manager
727     ICheckpointManager public checkpointManager;
728     // child tunnel contract which receives and sends messages
729     address public fxChildTunnel;
730 
731     // storage to avoid duplicate exits
732     mapping(bytes32 => bool) public processedExits;
733 
734     constructor(address _checkpointManager, address _fxRoot) {
735         checkpointManager = ICheckpointManager(_checkpointManager);
736         fxRoot = IFxStateSender(_fxRoot);
737     }
738 
739     // set fxChildTunnel if not set already
740     function setFxChildTunnel(address _fxChildTunnel) public virtual {
741         require(fxChildTunnel == address(0x0), "FxBaseRootTunnel: CHILD_TUNNEL_ALREADY_SET");
742         fxChildTunnel = _fxChildTunnel;
743     }
744 
745     /**
746      * @notice Send bytes message to Child Tunnel
747      * @param message bytes message that will be sent to Child Tunnel
748      * some message examples -
749      *   abi.encode(tokenId);
750      *   abi.encode(tokenId, tokenMetadata);
751      *   abi.encode(messageType, messageData);
752      */
753     function _sendMessageToChild(bytes memory message) internal {
754         fxRoot.sendMessageToChild(fxChildTunnel, message);
755     }
756 
757     function _validateAndExtractMessage(bytes memory inputData) internal returns (bytes memory) {
758         ExitPayloadReader.ExitPayload memory payload = inputData.toExitPayload();
759 
760         bytes memory branchMaskBytes = payload.getBranchMaskAsBytes();
761         uint256 blockNumber = payload.getBlockNumber();
762         // checking if exit has already been processed
763         // unique exit is identified using hash of (blockNumber, branchMask, receiptLogIndex)
764         bytes32 exitHash = keccak256(
765             abi.encodePacked(
766                 blockNumber,
767                 // first 2 nibbles are dropped while generating nibble array
768                 // this allows branch masks that are valid but bypass exitHash check (changing first 2 nibbles only)
769                 // so converting to nibble array and then hashing it
770                 MerklePatriciaProof._getNibbleArray(branchMaskBytes),
771                 payload.getReceiptLogIndex()
772             )
773         );
774         require(processedExits[exitHash] == false, "FxRootTunnel: EXIT_ALREADY_PROCESSED");
775         processedExits[exitHash] = true;
776 
777         ExitPayloadReader.Receipt memory receipt = payload.getReceipt();
778         ExitPayloadReader.Log memory log = receipt.getLog();
779 
780         // check child tunnel
781         require(fxChildTunnel == log.getEmitter(), "FxRootTunnel: INVALID_FX_CHILD_TUNNEL");
782 
783         bytes32 receiptRoot = payload.getReceiptRoot();
784         // verify receipt inclusion
785         require(
786             MerklePatriciaProof.verify(receipt.toBytes(), branchMaskBytes, payload.getReceiptProof(), receiptRoot),
787             "FxRootTunnel: INVALID_RECEIPT_PROOF"
788         );
789 
790         // verify checkpoint inclusion
791         _checkBlockMembershipInCheckpoint(
792             blockNumber,
793             payload.getBlockTime(),
794             payload.getTxRoot(),
795             receiptRoot,
796             payload.getHeaderNumber(),
797             payload.getBlockProof()
798         );
799 
800         ExitPayloadReader.LogTopics memory topics = log.getTopics();
801 
802         require(
803             bytes32(topics.getField(0).toUint()) == SEND_MESSAGE_EVENT_SIG, // topic0 is event sig
804             "FxRootTunnel: INVALID_SIGNATURE"
805         );
806 
807         // received message data
808         bytes memory message = abi.decode(log.getData(), (bytes)); // event decodes params again, so decoding bytes to get message
809         return message;
810     }
811 
812     function _checkBlockMembershipInCheckpoint(
813         uint256 blockNumber,
814         uint256 blockTime,
815         bytes32 txRoot,
816         bytes32 receiptRoot,
817         uint256 headerNumber,
818         bytes memory blockProof
819     ) private view returns (uint256) {
820         (bytes32 headerRoot, uint256 startBlock, , uint256 createdAt, ) = checkpointManager.headerBlocks(headerNumber);
821 
822         require(
823             keccak256(abi.encodePacked(blockNumber, blockTime, txRoot, receiptRoot)).checkMembership(
824                 blockNumber - startBlock,
825                 headerRoot,
826                 blockProof
827             ),
828             "FxRootTunnel: INVALID_HEADER"
829         );
830         return createdAt;
831     }
832 
833     /**
834      * @notice receive message from  L2 to L1, validated by proof
835      * @dev This function verifies if the transaction actually happened on child chain
836      *
837      * @param inputData RLP encoded data of the reference tx containing following list of fields
838      *  0 - headerNumber - Checkpoint header block number containing the reference tx
839      *  1 - blockProof - Proof that the block header (in the child chain) is a leaf in the submitted merkle root
840      *  2 - blockNumber - Block number containing the reference tx on child chain
841      *  3 - blockTime - Reference tx block time
842      *  4 - txRoot - Transactions root of block
843      *  5 - receiptRoot - Receipts root of block
844      *  6 - receipt - Receipt of the reference transaction
845      *  7 - receiptProof - Merkle proof of the reference receipt
846      *  8 - branchMask - 32 bits denoting the path of receipt in merkle tree
847      *  9 - receiptLogIndex - Log Index to read from the receipt
848      */
849     function receiveMessage(bytes memory inputData) public virtual {
850         bytes memory message = _validateAndExtractMessage(inputData);
851         _processMessageFromChild(message);
852     }
853 
854     /**
855      * @notice Process message received from Child Tunnel
856      * @dev function needs to be implemented to handle message as per requirement
857      * This is called by onStateReceive function.
858      * Since it is called via a system call, any event will not be emitted during its execution.
859      * @param message bytes message that was sent from Child Tunnel
860      */
861     function _processMessageFromChild(bytes memory message) internal virtual;
862 }
863 
864 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
865 
866 
867 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
868 
869 pragma solidity ^0.8.0;
870 
871 /**
872  * @dev Interface of the ERC165 standard, as defined in the
873  * https://eips.ethereum.org/EIPS/eip-165[EIP].
874  *
875  * Implementers can declare support of contract interfaces, which can then be
876  * queried by others ({ERC165Checker}).
877  *
878  * For an implementation, see {ERC165}.
879  */
880 interface IERC165 {
881     /**
882      * @dev Returns true if this contract implements the interface defined by
883      * `interfaceId`. See the corresponding
884      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
885      * to learn more about how these ids are created.
886      *
887      * This function call must use less than 30 000 gas.
888      */
889     function supportsInterface(bytes4 interfaceId) external view returns (bool);
890 }
891 
892 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
893 
894 
895 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
896 
897 pragma solidity ^0.8.0;
898 
899 
900 /**
901  * @dev Required interface of an ERC721 compliant contract.
902  */
903 interface IERC721 is IERC165 {
904     /**
905      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
906      */
907     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
908 
909     /**
910      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
911      */
912     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
913 
914     /**
915      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
916      */
917     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
918 
919     /**
920      * @dev Returns the number of tokens in ``owner``'s account.
921      */
922     function balanceOf(address owner) external view returns (uint256 balance);
923 
924     /**
925      * @dev Returns the owner of the `tokenId` token.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must exist.
930      */
931     function ownerOf(uint256 tokenId) external view returns (address owner);
932 
933     /**
934      * @dev Safely transfers `tokenId` token from `from` to `to`.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must exist and be owned by `from`.
941      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
943      *
944      * Emits a {Transfer} event.
945      */
946     function safeTransferFrom(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes calldata data
951     ) external;
952 
953     /**
954      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
955      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
956      *
957      * Requirements:
958      *
959      * - `from` cannot be the zero address.
960      * - `to` cannot be the zero address.
961      * - `tokenId` token must exist and be owned by `from`.
962      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
963      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
964      *
965      * Emits a {Transfer} event.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint256 tokenId
971     ) external;
972 
973     /**
974      * @dev Transfers `tokenId` token from `from` to `to`.
975      *
976      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
977      *
978      * Requirements:
979      *
980      * - `from` cannot be the zero address.
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must be owned by `from`.
983      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
984      *
985      * Emits a {Transfer} event.
986      */
987     function transferFrom(
988         address from,
989         address to,
990         uint256 tokenId
991     ) external;
992 
993     /**
994      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
995      * The approval is cleared when the token is transferred.
996      *
997      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
998      *
999      * Requirements:
1000      *
1001      * - The caller must own the token or be an approved operator.
1002      * - `tokenId` must exist.
1003      *
1004      * Emits an {Approval} event.
1005      */
1006     function approve(address to, uint256 tokenId) external;
1007 
1008     /**
1009      * @dev Approve or remove `operator` as an operator for the caller.
1010      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1011      *
1012      * Requirements:
1013      *
1014      * - The `operator` cannot be the caller.
1015      *
1016      * Emits an {ApprovalForAll} event.
1017      */
1018     function setApprovalForAll(address operator, bool _approved) external;
1019 
1020     /**
1021      * @dev Returns the account approved for `tokenId` token.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must exist.
1026      */
1027     function getApproved(uint256 tokenId) external view returns (address operator);
1028 
1029     /**
1030      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1031      *
1032      * See {setApprovalForAll}
1033      */
1034     function isApprovedForAll(address owner, address operator) external view returns (bool);
1035 }
1036 
1037 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1038 
1039 
1040 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 
1045 /**
1046  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1047  * @dev See https://eips.ethereum.org/EIPS/eip-721
1048  */
1049 interface IERC721Metadata is IERC721 {
1050     /**
1051      * @dev Returns the token collection name.
1052      */
1053     function name() external view returns (string memory);
1054 
1055     /**
1056      * @dev Returns the token collection symbol.
1057      */
1058     function symbol() external view returns (string memory);
1059 
1060     /**
1061      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1062      */
1063     function tokenURI(uint256 tokenId) external view returns (string memory);
1064 }
1065 
1066 // File: @openzeppelin/contracts/utils/Context.sol
1067 
1068 
1069 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 /**
1074  * @dev Provides information about the current execution context, including the
1075  * sender of the transaction and its data. While these are generally available
1076  * via msg.sender and msg.data, they should not be accessed in such a direct
1077  * manner, since when dealing with meta-transactions the account sending and
1078  * paying for execution may not be the actual sender (as far as an application
1079  * is concerned).
1080  *
1081  * This contract is only required for intermediate, library-like contracts.
1082  */
1083 abstract contract Context {
1084     function _msgSender() internal view virtual returns (address) {
1085         return msg.sender;
1086     }
1087 
1088     function _msgData() internal view virtual returns (bytes calldata) {
1089         return msg.data;
1090     }
1091 }
1092 
1093 // File: contracts/access/DeveloperAccess.sol
1094 
1095 
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 
1100 /**
1101  * @dev Contract module which provides a basic access control mechanism, where
1102  * there is an account (an developer) that can be granted exclusive access to
1103  * specific functions.
1104  *
1105  * By default, the developer account will be the one that deploys the contract. This
1106  * can later be changed with {transferDevelopership}.
1107  *
1108  * This module is used through inheritance. It will make available the modifier
1109  * `onlyDeveloper`, which can be applied to your functions to restrict their use to
1110  * the developer.
1111  */
1112 abstract contract DeveloperAccess is Context {
1113     address private _developer;
1114 
1115     event DevelopershipTransferred(address indexed previousDeveloper, address indexed newDeveloper);
1116 
1117     /**
1118      * @dev Initializes the contract setting the deployer as the initial developer.
1119      */
1120     constructor(address dev) {
1121         _setDeveloper(dev);
1122     }
1123 
1124     /**
1125      * @dev Returns the address of the current developer.
1126      */
1127     function developer() public view virtual returns (address) {
1128         return _developer;
1129     }
1130 
1131     /**
1132      * @dev Throws if called by any account other than the developer.
1133      */
1134     modifier onlyDeveloper() {
1135         require(developer() == _msgSender(), "Ownable: caller is not the developer");
1136         _;
1137     }
1138 
1139     /**
1140      * @dev Leaves the contract without developer. It will not be possible to call
1141      * `onlyDeveloper` functions anymore. Can only be called by the current developer.
1142      *
1143      * NOTE: Renouncing developership will leave the contract without an developer,
1144      * thereby removing any functionality that is only available to the developer.
1145      */
1146     function renounceDevelopership() public virtual onlyDeveloper {
1147         _setDeveloper(address(0));
1148     }
1149 
1150     /**
1151      * @dev Transfers developership of the contract to a new account (`newDeveloper`).
1152      * Can only be called by the current developer.
1153      */
1154     function transferDevelopership(address newDeveloper) public virtual onlyDeveloper {
1155         require(newDeveloper != address(0), "Ownable: new developer is the zero address");
1156         _setDeveloper(newDeveloper);
1157     }
1158 
1159     function _setDeveloper(address newDeveloper) private {
1160         address oldDeveloper = _developer;
1161         _developer = newDeveloper;
1162         emit DevelopershipTransferred(oldDeveloper, newDeveloper);
1163     }
1164 }
1165 
1166 // File: @openzeppelin/contracts/access/Ownable.sol
1167 
1168 
1169 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 
1174 /**
1175  * @dev Contract module which provides a basic access control mechanism, where
1176  * there is an account (an owner) that can be granted exclusive access to
1177  * specific functions.
1178  *
1179  * By default, the owner account will be the one that deploys the contract. This
1180  * can later be changed with {transferOwnership}.
1181  *
1182  * This module is used through inheritance. It will make available the modifier
1183  * `onlyOwner`, which can be applied to your functions to restrict their use to
1184  * the owner.
1185  */
1186 abstract contract Ownable is Context {
1187     address private _owner;
1188 
1189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1190 
1191     /**
1192      * @dev Initializes the contract setting the deployer as the initial owner.
1193      */
1194     constructor() {
1195         _transferOwnership(_msgSender());
1196     }
1197 
1198     /**
1199      * @dev Returns the address of the current owner.
1200      */
1201     function owner() public view virtual returns (address) {
1202         return _owner;
1203     }
1204 
1205     /**
1206      * @dev Throws if called by any account other than the owner.
1207      */
1208     modifier onlyOwner() {
1209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1210         _;
1211     }
1212 
1213     /**
1214      * @dev Leaves the contract without owner. It will not be possible to call
1215      * `onlyOwner` functions anymore. Can only be called by the current owner.
1216      *
1217      * NOTE: Renouncing ownership will leave the contract without an owner,
1218      * thereby removing any functionality that is only available to the owner.
1219      */
1220     function renounceOwnership() public virtual onlyOwner {
1221         _transferOwnership(address(0));
1222     }
1223 
1224     /**
1225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1226      * Can only be called by the current owner.
1227      */
1228     function transferOwnership(address newOwner) public virtual onlyOwner {
1229         require(newOwner != address(0), "Ownable: new owner is the zero address");
1230         _transferOwnership(newOwner);
1231     }
1232 
1233     /**
1234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1235      * Internal function without access restriction.
1236      */
1237     function _transferOwnership(address newOwner) internal virtual {
1238         address oldOwner = _owner;
1239         _owner = newOwner;
1240         emit OwnershipTransferred(oldOwner, newOwner);
1241     }
1242 }
1243 
1244 // File: contracts/GACStaking.sol
1245 
1246 
1247 
1248 pragma solidity ^0.8.10;
1249 
1250 
1251 
1252 
1253 
1254 /**
1255  * The staking contract designated to exist on the Ethereum chain,
1256  * briged to Polygon (MATIC) via FX-Portal.
1257  *
1258  * Author: Cory Cherven (Animalmix55/ToxicPizza)
1259  */
1260 contract GACStaking is FxBaseRootTunnel, Ownable, DeveloperAccess {
1261     IERC721Metadata public gacToken;
1262     bool public stakingPaused;
1263 
1264     /**
1265      * Users' staked tokens mapped from their address
1266      */
1267     mapping(address => mapping(uint256 => bool)) public staked;
1268 
1269     constructor(
1270         address checkpointManager,
1271         address fxRoot,
1272         address devAddress,
1273         address tokenAddress
1274     ) FxBaseRootTunnel(checkpointManager, fxRoot) DeveloperAccess(devAddress) {
1275         gacToken = IERC721Metadata(tokenAddress);
1276     }
1277 
1278     // ----------------------------------------------- PUBLIC FUNCTIONS ----------------------------------------------
1279 
1280     /**
1281      * Stakes the given token ids, provided the contract is approved to move them.
1282      * @param tokenIds - the token ids to stake
1283      */
1284     function stake(uint256[] calldata tokenIds) external {
1285         require(!stakingPaused, "Staking paused");
1286         for (uint256 i; i < tokenIds.length; i++) {
1287             gacToken.transferFrom(msg.sender, address(this), tokenIds[i]);
1288             staked[msg.sender][tokenIds[i]] = true;
1289         }
1290 
1291         _informChildOfEvent(msg.sender, tokenIds.length, true);
1292     }
1293 
1294     /**
1295      * Unstakes the given token ids.
1296      * @param tokenIds - the token ids to unstake
1297      */
1298     function unstake(uint256[] calldata tokenIds) external {
1299         for (uint256 i; i < tokenIds.length; i++) {
1300             require(staked[msg.sender][tokenIds[i]], "Not owned");
1301             gacToken.transferFrom(address(this), msg.sender, tokenIds[i]);
1302             staked[msg.sender][tokenIds[i]] = false;
1303         }
1304 
1305         _informChildOfEvent(msg.sender, tokenIds.length, false);
1306     }
1307 
1308     // -------------------------------------------- ADMIN FUNCTIONS --------------------------------------------------
1309 
1310     /**
1311      * @dev Throws if called by any account other than the developer/owner.
1312      */
1313     modifier onlyOwnerOrDeveloper() {
1314         require(
1315             developer() == _msgSender() || owner() == _msgSender(),
1316             "Ownable: caller is not the owner or developer"
1317         );
1318         _;
1319     }
1320 
1321     /**
1322      * Updates the paused state of staking.
1323      * @param paused - the state's new value.
1324      */
1325     function setStakingPaused(bool paused) external onlyOwnerOrDeveloper {
1326         stakingPaused = paused;
1327     }
1328 
1329     /**
1330      * Allows permissioned setting of fxChildTunnel
1331      * @param _fxChildTunnel - the fxChildTunnel address
1332      */
1333     function setFxChildTunnel(address _fxChildTunnel) public override onlyOwnerOrDeveloper {
1334         fxChildTunnel = _fxChildTunnel;
1335     }
1336 
1337     // -------------------------------------------- INTERNAL FUNCTIONS ----------------------------------------------
1338 
1339     /**
1340      * Informs the child contract, via FX-Portal, that a staking event has occurred.
1341      * @param from - the user that staked/unstaked
1342      * @param count - the number staked/unstaked
1343      * @param isInbound - true if staking, false if unstaking
1344      */
1345     function _informChildOfEvent(
1346         address from,
1347         uint256 count,
1348         bool isInbound
1349     ) internal {
1350         _sendMessageToChild(abi.encode(from, count, isInbound));
1351     }
1352 
1353     /**
1354      * A stub that does nothing. We will not anticipate receiving messages from Polygon,
1355      * we will only send messages to Polygon via FX-Portal.
1356      */
1357     function _processMessageFromChild(bytes memory) internal override {}
1358 }