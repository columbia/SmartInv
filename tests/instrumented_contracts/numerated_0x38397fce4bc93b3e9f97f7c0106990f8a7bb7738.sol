1 // Sources flattened with hardhat v2.4.3 https://hardhat.org
2 
3 // File contracts/common/lib/RLPReader.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 /*
8 * @author Hamdi Allam hamdi.allam97@gmail.com
9 * Please reach out with any questions or concerns
10 */
11 pragma solidity ^0.8.0;
12 
13 library RLPReader {
14     uint8 constant STRING_SHORT_START = 0x80;
15     uint8 constant STRING_LONG_START  = 0xb8;
16     uint8 constant LIST_SHORT_START   = 0xc0;
17     uint8 constant LIST_LONG_START    = 0xf8;
18     uint8 constant WORD_SIZE = 32;
19 
20     struct RLPItem {
21         uint len;
22         uint memPtr;
23     }
24 
25     struct Iterator {
26         RLPItem item;   // Item that's being iterated over.
27         uint nextPtr;   // Position of the next item in the list.
28     }
29 
30     /*
31     * @dev Returns the next element in the iteration. Reverts if it has not next element.
32     * @param self The iterator.
33     * @return The next element in the iteration.
34     */
35     function next(Iterator memory self) internal pure returns (RLPItem memory) {
36         require(hasNext(self));
37 
38         uint ptr = self.nextPtr;
39         uint itemLength = _itemLength(ptr);
40         self.nextPtr = ptr + itemLength;
41 
42         return RLPItem(itemLength, ptr);
43     }
44 
45     /*
46     * @dev Returns true if the iteration has more elements.
47     * @param self The iterator.
48     * @return true if the iteration has more elements.
49     */
50     function hasNext(Iterator memory self) internal pure returns (bool) {
51         RLPItem memory item = self.item;
52         return self.nextPtr < item.memPtr + item.len;
53     }
54 
55     /*
56     * @param item RLP encoded bytes
57     */
58     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
59         uint memPtr;
60         assembly {
61             memPtr := add(item, 0x20)
62         }
63 
64         return RLPItem(item.length, memPtr);
65     }
66 
67     /*
68     * @dev Create an iterator. Reverts if item is not a list.
69     * @param self The RLP item.
70     * @return An 'Iterator' over the item.
71     */
72     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
73         require(isList(self));
74 
75         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
76         return Iterator(self, ptr);
77     }
78 
79     /*
80     * @param item RLP encoded bytes
81     */
82     function rlpLen(RLPItem memory item) internal pure returns (uint) {
83         return item.len;
84     }
85 
86     /*
87     * @param item RLP encoded bytes
88     */
89     function payloadLen(RLPItem memory item) internal pure returns (uint) {
90         return item.len - _payloadOffset(item.memPtr);
91     }
92 
93     /*
94     * @param item RLP encoded list in bytes
95     */
96     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
97         require(isList(item));
98 
99         uint items = numItems(item);
100         RLPItem[] memory result = new RLPItem[](items);
101 
102         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
103         uint dataLen;
104         for (uint i = 0; i < items; i++) {
105             dataLen = _itemLength(memPtr);
106             result[i] = RLPItem(dataLen, memPtr); 
107             memPtr = memPtr + dataLen;
108         }
109 
110         return result;
111     }
112 
113     // @return indicator whether encoded payload is a list. negate this function call for isData.
114     function isList(RLPItem memory item) internal pure returns (bool) {
115         if (item.len == 0) return false;
116 
117         uint8 byte0;
118         uint memPtr = item.memPtr;
119         assembly {
120             byte0 := byte(0, mload(memPtr))
121         }
122 
123         if (byte0 < LIST_SHORT_START)
124             return false;
125         return true;
126     }
127 
128     /*
129      * @dev A cheaper version of keccak256(toRlpBytes(item)) that avoids copying memory.
130      * @return keccak256 hash of RLP encoded bytes.
131      */
132     function rlpBytesKeccak256(RLPItem memory item) internal pure returns (bytes32) {
133         uint256 ptr = item.memPtr;
134         uint256 len = item.len;
135         bytes32 result;
136         assembly {
137             result := keccak256(ptr, len)
138         }
139         return result;
140     }
141 
142     function payloadLocation(RLPItem memory item) internal pure returns (uint, uint) {
143         uint offset = _payloadOffset(item.memPtr);
144         uint memPtr = item.memPtr + offset;
145         uint len = item.len - offset; // data length
146         return (memPtr, len);
147     }
148 
149     /*
150      * @dev A cheaper version of keccak256(toBytes(item)) that avoids copying memory.
151      * @return keccak256 hash of the item payload.
152      */
153     function payloadKeccak256(RLPItem memory item) internal pure returns (bytes32) {
154         (uint memPtr, uint len) = payloadLocation(item);
155         bytes32 result;
156         assembly {
157             result := keccak256(memPtr, len)
158         }
159         return result;
160     }
161 
162     /** RLPItem conversions into data types **/
163 
164     // @returns raw rlp encoding in bytes
165     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
166         bytes memory result = new bytes(item.len);
167         if (result.length == 0) return result;
168         
169         uint ptr;
170         assembly {
171             ptr := add(0x20, result)
172         }
173 
174         copy(item.memPtr, ptr, item.len);
175         return result;
176     }
177 
178     // any non-zero byte is considered true
179     function toBoolean(RLPItem memory item) internal pure returns (bool) {
180         require(item.len == 1);
181         uint result;
182         uint memPtr = item.memPtr;
183         assembly {
184             result := byte(0, mload(memPtr))
185         }
186 
187         return result == 0 ? false : true;
188     }
189 
190     function toAddress(RLPItem memory item) internal pure returns (address) {
191         // 1 byte for the length prefix
192         require(item.len == 21);
193 
194         return address(uint160(toUint(item)));
195     }
196 
197     function toUint(RLPItem memory item) internal pure returns (uint) {
198         require(item.len > 0 && item.len <= 33);
199 
200         uint offset = _payloadOffset(item.memPtr);
201         uint len = item.len - offset;
202 
203         uint result;
204         uint memPtr = item.memPtr + offset;
205         assembly {
206             result := mload(memPtr)
207 
208             // shfit to the correct location if neccesary
209             if lt(len, 32) {
210                 result := div(result, exp(256, sub(32, len)))
211             }
212         }
213 
214         return result;
215     }
216 
217     // enforces 32 byte length
218     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
219         // one byte prefix
220         require(item.len == 33);
221 
222         uint result;
223         uint memPtr = item.memPtr + 1;
224         assembly {
225             result := mload(memPtr)
226         }
227 
228         return result;
229     }
230 
231     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
232         require(item.len > 0);
233 
234         uint offset = _payloadOffset(item.memPtr);
235         uint len = item.len - offset; // data length
236         bytes memory result = new bytes(len);
237 
238         uint destPtr;
239         assembly {
240             destPtr := add(0x20, result)
241         }
242 
243         copy(item.memPtr + offset, destPtr, len);
244         return result;
245     }
246 
247     /*
248     * Private Helpers
249     */
250 
251     // @return number of payload items inside an encoded list.
252     function numItems(RLPItem memory item) private pure returns (uint) {
253         if (item.len == 0) return 0;
254 
255         uint count = 0;
256         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
257         uint endPtr = item.memPtr + item.len;
258         while (currPtr < endPtr) {
259            currPtr = currPtr + _itemLength(currPtr); // skip over an item
260            count++;
261         }
262 
263         return count;
264     }
265 
266     // @return entire rlp item byte length
267     function _itemLength(uint memPtr) private pure returns (uint) {
268         uint itemLen;
269         uint byte0;
270         assembly {
271             byte0 := byte(0, mload(memPtr))
272         }
273 
274         if (byte0 < STRING_SHORT_START)
275             itemLen = 1;
276         
277         else if (byte0 < STRING_LONG_START)
278             itemLen = byte0 - STRING_SHORT_START + 1;
279 
280         else if (byte0 < LIST_SHORT_START) {
281             assembly {
282                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
283                 memPtr := add(memPtr, 1) // skip over the first byte
284                 /* 32 byte word size */
285                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
286                 itemLen := add(dataLen, add(byteLen, 1))
287             }
288         }
289 
290         else if (byte0 < LIST_LONG_START) {
291             itemLen = byte0 - LIST_SHORT_START + 1;
292         } 
293 
294         else {
295             assembly {
296                 let byteLen := sub(byte0, 0xf7)
297                 memPtr := add(memPtr, 1)
298 
299                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
300                 itemLen := add(dataLen, add(byteLen, 1))
301             }
302         }
303 
304         return itemLen;
305     }
306 
307     // @return number of bytes until the data
308     function _payloadOffset(uint memPtr) private pure returns (uint) {
309         uint byte0;
310         assembly {
311             byte0 := byte(0, mload(memPtr))
312         }
313 
314         if (byte0 < STRING_SHORT_START) 
315             return 0;
316         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
317             return 1;
318         else if (byte0 < LIST_SHORT_START)  // being explicit
319             return byte0 - (STRING_LONG_START - 1) + 1;
320         else
321             return byte0 - (LIST_LONG_START - 1) + 1;
322     }
323 
324     /*
325     * @param src Pointer to source
326     * @param dest Pointer to destination
327     * @param len Amount of memory to copy from the source
328     */
329     function copy(uint src, uint dest, uint len) private pure {
330         unchecked {
331             if (len == 0) return;
332 
333             // copy as many word sizes as possible
334             for (; len >= WORD_SIZE; len -= WORD_SIZE) {
335                 assembly {
336                     mstore(dest, mload(src))
337                 }
338 
339                 src += WORD_SIZE;
340                 dest += WORD_SIZE;
341             }
342 
343             // left over bytes. Mask is used to remove unwanted bytes from the word
344             uint mask = 256 ** (WORD_SIZE - len) - 1;
345             assembly {
346                 let srcpart := and(mload(src), not(mask)) // zero out src
347                 let destpart := and(mload(dest), mask) // retrieve the bytes
348                 mstore(dest, or(destpart, srcpart))
349             }
350         }
351     }
352 }
353 
354 
355 // File contracts/common/lib/MerklePatriciaProof.sol
356 
357 
358 pragma solidity ^0.8.0;
359 
360 library MerklePatriciaProof {
361     /*
362      * @dev Verifies a merkle patricia proof.
363      * @param value The terminating value in the trie.
364      * @param encodedPath The path in the trie leading to value.
365      * @param rlpParentNodes The rlp encoded stack of nodes.
366      * @param root The root hash of the trie.
367      * @return The boolean validity of the proof.
368      */
369     function verify(
370         bytes memory value,
371         bytes memory encodedPath,
372         bytes memory rlpParentNodes,
373         bytes32 root
374     ) internal pure returns (bool) {
375         RLPReader.RLPItem memory item = RLPReader.toRlpItem(rlpParentNodes);
376         RLPReader.RLPItem[] memory parentNodes = RLPReader.toList(item);
377 
378         bytes memory currentNode;
379         RLPReader.RLPItem[] memory currentNodeList;
380 
381         bytes32 nodeKey = root;
382         uint256 pathPtr = 0;
383 
384         bytes memory path = _getNibbleArray(encodedPath);
385         if (path.length == 0) {
386             return false;
387         }
388 
389         for (uint256 i = 0; i < parentNodes.length; i++) {
390             if (pathPtr > path.length) {
391                 return false;
392             }
393 
394             currentNode = RLPReader.toRlpBytes(parentNodes[i]);
395             if (nodeKey != keccak256(currentNode)) {
396                 return false;
397             }
398             currentNodeList = RLPReader.toList(parentNodes[i]);
399 
400             if (currentNodeList.length == 17) {
401                 if (pathPtr == path.length) {
402                     if (
403                         keccak256(RLPReader.toBytes(currentNodeList[16])) ==
404                         keccak256(value)
405                     ) {
406                         return true;
407                     } else {
408                         return false;
409                     }
410                 }
411 
412                 uint8 nextPathNibble = uint8(path[pathPtr]);
413                 if (nextPathNibble > 16) {
414                     return false;
415                 }
416                 nodeKey = bytes32(
417                     RLPReader.toUintStrict(currentNodeList[nextPathNibble])
418                 );
419                 pathPtr += 1;
420             } else if (currentNodeList.length == 2) {
421                 uint256 traversed = _nibblesToTraverse(
422                     RLPReader.toBytes(currentNodeList[0]),
423                     path,
424                     pathPtr
425                 );
426                 if (pathPtr + traversed == path.length) {
427                     //leaf node
428                     if (
429                         keccak256(RLPReader.toBytes(currentNodeList[1])) ==
430                         keccak256(value)
431                     ) {
432                         return true;
433                     } else {
434                         return false;
435                     }
436                 }
437 
438                 //extension node
439                 if (traversed == 0) {
440                     return false;
441                 }
442 
443                 pathPtr += traversed;
444                 nodeKey = bytes32(RLPReader.toUintStrict(currentNodeList[1]));
445             } else {
446                 return false;
447             }
448         }
449     }
450 
451     function _nibblesToTraverse(
452         bytes memory encodedPartialPath,
453         bytes memory path,
454         uint256 pathPtr
455     ) private pure returns (uint256) {
456         uint256 len = 0;
457         // encodedPartialPath has elements that are each two hex characters (1 byte), but partialPath
458         // and slicedPath have elements that are each one hex character (1 nibble)
459         bytes memory partialPath = _getNibbleArray(encodedPartialPath);
460         bytes memory slicedPath = new bytes(partialPath.length);
461 
462         // pathPtr counts nibbles in path
463         // partialPath.length is a number of nibbles
464         for (uint256 i = pathPtr; i < pathPtr + partialPath.length; i++) {
465             bytes1 pathNibble = path[i];
466             slicedPath[i - pathPtr] = pathNibble;
467         }
468 
469         if (keccak256(partialPath) == keccak256(slicedPath)) {
470             len = partialPath.length;
471         } else {
472             len = 0;
473         }
474         return len;
475     }
476 
477     // bytes b must be hp encoded
478     function _getNibbleArray(bytes memory b)
479         internal
480         pure
481         returns (bytes memory)
482     {
483         bytes memory nibbles = "";
484         if (b.length > 0) {
485             uint8 offset;
486             uint8 hpNibble = uint8(_getNthNibbleOfBytes(0, b));
487             if (hpNibble == 1 || hpNibble == 3) {
488                 nibbles = new bytes(b.length * 2 - 1);
489                 bytes1 oddNibble = _getNthNibbleOfBytes(1, b);
490                 nibbles[0] = oddNibble;
491                 offset = 1;
492             } else {
493                 nibbles = new bytes(b.length * 2 - 2);
494                 offset = 0;
495             }
496 
497             for (uint256 i = offset; i < nibbles.length; i++) {
498                 nibbles[i] = _getNthNibbleOfBytes(i - offset + 2, b);
499             }
500         }
501         return nibbles;
502     }
503 
504     function _getNthNibbleOfBytes(uint256 n, bytes memory str)
505         private
506         pure
507         returns (bytes1)
508     {
509         return
510             bytes1(
511                 n % 2 == 0 ? uint8(str[n / 2]) / 0x10 : uint8(str[n / 2]) % 0x10
512             );
513     }
514 }
515 
516 
517 // File contracts/common/lib/Merkle.sol
518 
519 
520 pragma solidity ^0.8.0;
521 
522 library Merkle {
523     function checkMembership(
524         bytes32 leaf,
525         uint256 index,
526         bytes32 rootHash,
527         bytes memory proof
528     ) internal pure returns (bool) {
529         require(proof.length % 32 == 0, "Invalid proof length");
530         uint256 proofHeight = proof.length / 32;
531         // Proof of size n means, height of the tree is n+1.
532         // In a tree of height n+1, max #leafs possible is 2 ^ n
533         require(index < 2 ** proofHeight, "Leaf index is too big");
534 
535         bytes32 proofElement;
536         bytes32 computedHash = leaf;
537         for (uint256 i = 32; i <= proof.length; i += 32) {
538             assembly {
539                 proofElement := mload(add(proof, i))
540             }
541 
542             if (index % 2 == 0) {
543                 computedHash = keccak256(
544                     abi.encodePacked(computedHash, proofElement)
545                 );
546             } else {
547                 computedHash = keccak256(
548                     abi.encodePacked(proofElement, computedHash)
549                 );
550             }
551 
552             index = index / 2;
553         }
554         return computedHash == rootHash;
555     }
556 }
557 
558 
559 // File contracts/common/matic-sync/FxBaseRootTunnel.sol
560 
561 
562 pragma solidity ^0.8.0;
563 
564 
565 
566 interface IFxStateSender {
567     function sendMessageToChild(address _receiver, bytes calldata _data) external;
568 }
569 
570 contract ICheckpointManager {
571     struct HeaderBlock {
572         bytes32 root;
573         uint256 start;
574         uint256 end;
575         uint256 createdAt;
576         address proposer;
577     }
578 
579     /**
580      * @notice mapping of checkpoint header numbers to block details
581      * @dev These checkpoints are submited by plasma contracts
582      */
583     mapping(uint256 => HeaderBlock) public headerBlocks;
584 }
585 
586 abstract contract FxBaseRootTunnel {
587     using RLPReader for bytes;
588     using RLPReader for RLPReader.RLPItem;
589     using Merkle for bytes32;
590 
591     // keccak256(MessageSent(bytes))
592     bytes32 public constant SEND_MESSAGE_EVENT_SIG = 0x8c5261668696ce22758910d05bab8f186d6eb247ceac2af2e82c7dc17669b036;
593 
594     // state sender contract
595     IFxStateSender public fxRoot;
596     // root chain manager
597     ICheckpointManager public checkpointManager;
598     // child tunnel contract which receives and sends messages 
599     address public fxChildTunnel;
600 
601     // storage to avoid duplicate exits
602     mapping(bytes32 => bool) public processedExits;
603 
604     constructor(address _checkpointManager, address _fxRoot) {
605         checkpointManager = ICheckpointManager(_checkpointManager);
606         fxRoot = IFxStateSender(_fxRoot);
607     }
608 
609     // set fxChildTunnel if not set already
610     function setFxChildTunnel(address _fxChildTunnel) public {
611         require(fxChildTunnel == address(0x0), "FxBaseRootTunnel: CHILD_TUNNEL_ALREADY_SET");
612         fxChildTunnel = _fxChildTunnel;
613     }
614 
615     /**
616      * @notice Send bytes message to Child Tunnel
617      * @param message bytes message that will be sent to Child Tunnel
618      * some message examples -
619      *   abi.encode(tokenId);
620      *   abi.encode(tokenId, tokenMetadata);
621      *   abi.encode(messageType, messageData);
622      */
623     function _sendMessageToChild(bytes memory message) internal {
624         fxRoot.sendMessageToChild(fxChildTunnel, message);
625     }
626 
627     function _validateAndExtractMessage(bytes memory inputData) internal returns (bytes memory) {
628         RLPReader.RLPItem[] memory inputDataRLPList = inputData
629             .toRlpItem()
630             .toList();
631 
632         // checking if exit has already been processed
633         // unique exit is identified using hash of (blockNumber, branchMask, receiptLogIndex)
634         bytes32 exitHash = keccak256(
635             abi.encodePacked(
636                 inputDataRLPList[2].toUint(), // blockNumber
637                 // first 2 nibbles are dropped while generating nibble array
638                 // this allows branch masks that are valid but bypass exitHash check (changing first 2 nibbles only)
639                 // so converting to nibble array and then hashing it
640                 MerklePatriciaProof._getNibbleArray(inputDataRLPList[8].toBytes()), // branchMask
641                 inputDataRLPList[9].toUint() // receiptLogIndex
642             )
643         );
644         require(
645             processedExits[exitHash] == false,
646             "FxRootTunnel: EXIT_ALREADY_PROCESSED"
647         );
648         processedExits[exitHash] = true;
649 
650         RLPReader.RLPItem[] memory receiptRLPList = inputDataRLPList[6]
651             .toBytes()
652             .toRlpItem()
653             .toList();
654         RLPReader.RLPItem memory logRLP = receiptRLPList[3]
655             .toList()[
656                 inputDataRLPList[9].toUint() // receiptLogIndex
657             ];
658 
659         RLPReader.RLPItem[] memory logRLPList = logRLP.toList();
660         
661         // check child tunnel
662         require(fxChildTunnel == RLPReader.toAddress(logRLPList[0]), "FxRootTunnel: INVALID_FX_CHILD_TUNNEL");
663 
664         // verify receipt inclusion
665         require(
666             MerklePatriciaProof.verify(
667                 inputDataRLPList[6].toBytes(), // receipt
668                 inputDataRLPList[8].toBytes(), // branchMask
669                 inputDataRLPList[7].toBytes(), // receiptProof
670                 bytes32(inputDataRLPList[5].toUint()) // receiptRoot
671             ),
672             "FxRootTunnel: INVALID_RECEIPT_PROOF"
673         );
674 
675         // verify checkpoint inclusion
676         _checkBlockMembershipInCheckpoint(
677             inputDataRLPList[2].toUint(), // blockNumber
678             inputDataRLPList[3].toUint(), // blockTime
679             bytes32(inputDataRLPList[4].toUint()), // txRoot
680             bytes32(inputDataRLPList[5].toUint()), // receiptRoot
681             inputDataRLPList[0].toUint(), // headerNumber
682             inputDataRLPList[1].toBytes() // blockProof
683         );
684 
685         RLPReader.RLPItem[] memory logTopicRLPList = logRLPList[1].toList(); // topics
686 
687         require(
688             bytes32(logTopicRLPList[0].toUint()) == SEND_MESSAGE_EVENT_SIG, // topic0 is event sig
689             "FxRootTunnel: INVALID_SIGNATURE"
690         );
691 
692         // received message data
693         bytes memory receivedData = logRLPList[2].toBytes();
694         (bytes memory message) = abi.decode(receivedData, (bytes)); // event decodes params again, so decoding bytes to get message
695         return message;
696     }
697 
698     function _checkBlockMembershipInCheckpoint(
699         uint256 blockNumber,
700         uint256 blockTime,
701         bytes32 txRoot,
702         bytes32 receiptRoot,
703         uint256 headerNumber,
704         bytes memory blockProof
705     ) private view returns (uint256) {
706         (
707             bytes32 headerRoot,
708             uint256 startBlock,
709             ,
710             uint256 createdAt,
711 
712         ) = checkpointManager.headerBlocks(headerNumber);
713 
714         require(
715             keccak256(
716                 abi.encodePacked(blockNumber, blockTime, txRoot, receiptRoot)
717             )
718                 .checkMembership(
719                 blockNumber-startBlock,
720                 headerRoot,
721                 blockProof
722             ),
723             "FxRootTunnel: INVALID_HEADER"
724         );
725         return createdAt;
726     }
727 
728     /**
729      * @notice receive message from  L2 to L1, validated by proof
730      * @dev This function verifies if the transaction actually happened on child chain
731      *
732      * @param inputData RLP encoded data of the reference tx containing following list of fields
733      *  0 - headerNumber - Checkpoint header block number containing the reference tx
734      *  1 - blockProof - Proof that the block header (in the child chain) is a leaf in the submitted merkle root
735      *  2 - blockNumber - Block number containing the reference tx on child chain
736      *  3 - blockTime - Reference tx block time
737      *  4 - txRoot - Transactions root of block
738      *  5 - receiptRoot - Receipts root of block
739      *  6 - receipt - Receipt of the reference transaction
740      *  7 - receiptProof - Merkle proof of the reference receipt
741      *  8 - branchMask - 32 bits denoting the path of receipt in merkle tree
742      *  9 - receiptLogIndex - Log Index to read from the receipt
743      */
744     function receiveMessage(bytes memory inputData) public virtual {
745         bytes memory message = _validateAndExtractMessage(inputData);
746         _processMessageFromChild(message);
747     }
748 
749     /**
750      * @notice Process message received from Child Tunnel
751      * @dev function needs to be implemented to handle message as per requirement
752      * This is called by onStateReceive function.
753      * Since it is called via a system call, any event will not be emitted during its execution.
754      * @param message bytes message that was sent from Child Tunnel
755      */
756     function _processMessageFromChild(bytes memory message) virtual internal;
757 }
758 
759 
760 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
761 
762 
763 
764 pragma solidity ^0.8.0;
765 
766 /**
767  * @dev Interface of the ERC20 standard as defined in the EIP.
768  */
769 interface IERC20 {
770     /**
771      * @dev Returns the amount of tokens in existence.
772      */
773     function totalSupply() external view returns (uint256);
774 
775     /**
776      * @dev Returns the amount of tokens owned by `account`.
777      */
778     function balanceOf(address account) external view returns (uint256);
779 
780     /**
781      * @dev Moves `amount` tokens from the caller's account to `recipient`.
782      *
783      * Returns a boolean value indicating whether the operation succeeded.
784      *
785      * Emits a {Transfer} event.
786      */
787     function transfer(address recipient, uint256 amount) external returns (bool);
788 
789     /**
790      * @dev Returns the remaining number of tokens that `spender` will be
791      * allowed to spend on behalf of `owner` through {transferFrom}. This is
792      * zero by default.
793      *
794      * This value changes when {approve} or {transferFrom} are called.
795      */
796     function allowance(address owner, address spender) external view returns (uint256);
797 
798     /**
799      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
800      *
801      * Returns a boolean value indicating whether the operation succeeded.
802      *
803      * IMPORTANT: Beware that changing an allowance with this method brings the risk
804      * that someone may use both the old and the new allowance by unfortunate
805      * transaction ordering. One possible solution to mitigate this race
806      * condition is to first reduce the spender's allowance to 0 and set the
807      * desired value afterwards:
808      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
809      *
810      * Emits an {Approval} event.
811      */
812     function approve(address spender, uint256 amount) external returns (bool);
813 
814     /**
815      * @dev Moves `amount` tokens from `sender` to `recipient` using the
816      * allowance mechanism. `amount` is then deducted from the caller's
817      * allowance.
818      *
819      * Returns a boolean value indicating whether the operation succeeded.
820      *
821      * Emits a {Transfer} event.
822      */
823     function transferFrom(
824         address sender,
825         address recipient,
826         uint256 amount
827     ) external returns (bool);
828 
829     /**
830      * @dev Emitted when `value` tokens are moved from one account (`from`) to
831      * another (`to`).
832      *
833      * Note that `value` may be zero.
834      */
835     event Transfer(address indexed from, address indexed to, uint256 value);
836 
837     /**
838      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
839      * a call to {approve}. `value` is the new allowance.
840      */
841     event Approval(address indexed owner, address indexed spender, uint256 value);
842 }
843 
844 
845 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.2.0
846 
847 
848 
849 pragma solidity ^0.8.0;
850 
851 /**
852  * @dev Contract module that helps prevent reentrant calls to a function.
853  *
854  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
855  * available, which can be applied to functions to make sure there are no nested
856  * (reentrant) calls to them.
857  *
858  * Note that because there is a single `nonReentrant` guard, functions marked as
859  * `nonReentrant` may not call one another. This can be worked around by making
860  * those functions `private`, and then adding `external` `nonReentrant` entry
861  * points to them.
862  *
863  * TIP: If you would like to learn more about reentrancy and alternative ways
864  * to protect against it, check out our blog post
865  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
866  */
867 abstract contract ReentrancyGuard {
868     // Booleans are more expensive than uint256 or any type that takes up a full
869     // word because each write operation emits an extra SLOAD to first read the
870     // slot's contents, replace the bits taken up by the boolean, and then write
871     // back. This is the compiler's defense against contract upgrades and
872     // pointer aliasing, and it cannot be disabled.
873 
874     // The values being non-zero value makes deployment a bit more expensive,
875     // but in exchange the refund on every call to nonReentrant will be lower in
876     // amount. Since refunds are capped to a percentage of the total
877     // transaction's gas, it is best to keep them low in cases like this one, to
878     // increase the likelihood of the full refund coming into effect.
879     uint256 private constant _NOT_ENTERED = 1;
880     uint256 private constant _ENTERED = 2;
881 
882     uint256 private _status;
883 
884     constructor() {
885         _status = _NOT_ENTERED;
886     }
887 
888     /**
889      * @dev Prevents a contract from calling itself, directly or indirectly.
890      * Calling a `nonReentrant` function from another `nonReentrant`
891      * function is not supported. It is possible to prevent this from happening
892      * by making the `nonReentrant` function external, and make it call a
893      * `private` function that does the actual work.
894      */
895     modifier nonReentrant() {
896         // On the first call to nonReentrant, _notEntered will be true
897         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
898 
899         // Any calls to nonReentrant after this point will fail
900         _status = _ENTERED;
901 
902         _;
903 
904         // By storing the original value once again, a refund is triggered (see
905         // https://eips.ethereum.org/EIPS/eip-2200)
906         _status = _NOT_ENTERED;
907     }
908 }
909 
910 
911 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
912 
913 
914 
915 pragma solidity ^0.8.0;
916 
917 /*
918  * @dev Provides information about the current execution context, including the
919  * sender of the transaction and its data. While these are generally available
920  * via msg.sender and msg.data, they should not be accessed in such a direct
921  * manner, since when dealing with meta-transactions the account sending and
922  * paying for execution may not be the actual sender (as far as an application
923  * is concerned).
924  *
925  * This contract is only required for intermediate, library-like contracts.
926  */
927 abstract contract Context {
928     function _msgSender() internal view virtual returns (address) {
929         return msg.sender;
930     }
931 
932     function _msgData() internal view virtual returns (bytes calldata) {
933         return msg.data;
934     }
935 }
936 
937 
938 // File @openzeppelin/contracts/security/Pausable.sol@v4.2.0
939 
940 
941 
942 pragma solidity ^0.8.0;
943 
944 /**
945  * @dev Contract module which allows children to implement an emergency stop
946  * mechanism that can be triggered by an authorized account.
947  *
948  * This module is used through inheritance. It will make available the
949  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
950  * the functions of your contract. Note that they will not be pausable by
951  * simply including this module, only once the modifiers are put in place.
952  */
953 abstract contract Pausable is Context {
954     /**
955      * @dev Emitted when the pause is triggered by `account`.
956      */
957     event Paused(address account);
958 
959     /**
960      * @dev Emitted when the pause is lifted by `account`.
961      */
962     event Unpaused(address account);
963 
964     bool private _paused;
965 
966     /**
967      * @dev Initializes the contract in unpaused state.
968      */
969     constructor() {
970         _paused = false;
971     }
972 
973     /**
974      * @dev Returns true if the contract is paused, and false otherwise.
975      */
976     function paused() public view virtual returns (bool) {
977         return _paused;
978     }
979 
980     /**
981      * @dev Modifier to make a function callable only when the contract is not paused.
982      *
983      * Requirements:
984      *
985      * - The contract must not be paused.
986      */
987     modifier whenNotPaused() {
988         require(!paused(), "Pausable: paused");
989         _;
990     }
991 
992     /**
993      * @dev Modifier to make a function callable only when the contract is paused.
994      *
995      * Requirements:
996      *
997      * - The contract must be paused.
998      */
999     modifier whenPaused() {
1000         require(paused(), "Pausable: not paused");
1001         _;
1002     }
1003 
1004     /**
1005      * @dev Triggers stopped state.
1006      *
1007      * Requirements:
1008      *
1009      * - The contract must not be paused.
1010      */
1011     function _pause() internal virtual whenNotPaused {
1012         _paused = true;
1013         emit Paused(_msgSender());
1014     }
1015 
1016     /**
1017      * @dev Returns to normal state.
1018      *
1019      * Requirements:
1020      *
1021      * - The contract must be paused.
1022      */
1023     function _unpause() internal virtual whenPaused {
1024         _paused = false;
1025         emit Unpaused(_msgSender());
1026     }
1027 }
1028 
1029 
1030 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
1031 
1032 
1033 
1034 pragma solidity ^0.8.0;
1035 
1036 /**
1037  * @dev String operations.
1038  */
1039 library Strings {
1040     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1041 
1042     /**
1043      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1044      */
1045     function toString(uint256 value) internal pure returns (string memory) {
1046         // Inspired by OraclizeAPI's implementation - MIT licence
1047         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1048 
1049         if (value == 0) {
1050             return "0";
1051         }
1052         uint256 temp = value;
1053         uint256 digits;
1054         while (temp != 0) {
1055             digits++;
1056             temp /= 10;
1057         }
1058         bytes memory buffer = new bytes(digits);
1059         while (value != 0) {
1060             digits -= 1;
1061             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1062             value /= 10;
1063         }
1064         return string(buffer);
1065     }
1066 
1067     /**
1068      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1069      */
1070     function toHexString(uint256 value) internal pure returns (string memory) {
1071         if (value == 0) {
1072             return "0x00";
1073         }
1074         uint256 temp = value;
1075         uint256 length = 0;
1076         while (temp != 0) {
1077             length++;
1078             temp >>= 8;
1079         }
1080         return toHexString(value, length);
1081     }
1082 
1083     /**
1084      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1085      */
1086     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1087         bytes memory buffer = new bytes(2 * length + 2);
1088         buffer[0] = "0";
1089         buffer[1] = "x";
1090         for (uint256 i = 2 * length + 1; i > 1; --i) {
1091             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1092             value >>= 4;
1093         }
1094         require(value == 0, "Strings: hex length insufficient");
1095         return string(buffer);
1096     }
1097 }
1098 
1099 
1100 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
1101 
1102 
1103 
1104 pragma solidity ^0.8.0;
1105 
1106 /**
1107  * @dev Interface of the ERC165 standard, as defined in the
1108  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1109  *
1110  * Implementers can declare support of contract interfaces, which can then be
1111  * queried by others ({ERC165Checker}).
1112  *
1113  * For an implementation, see {ERC165}.
1114  */
1115 interface IERC165 {
1116     /**
1117      * @dev Returns true if this contract implements the interface defined by
1118      * `interfaceId`. See the corresponding
1119      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1120      * to learn more about how these ids are created.
1121      *
1122      * This function call must use less than 30 000 gas.
1123      */
1124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1125 }
1126 
1127 
1128 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
1129 
1130 
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 /**
1135  * @dev Implementation of the {IERC165} interface.
1136  *
1137  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1138  * for the additional interface id that will be supported. For example:
1139  *
1140  * ```solidity
1141  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1142  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1143  * }
1144  * ```
1145  *
1146  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1147  */
1148 abstract contract ERC165 is IERC165 {
1149     /**
1150      * @dev See {IERC165-supportsInterface}.
1151      */
1152     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1153         return interfaceId == type(IERC165).interfaceId;
1154     }
1155 }
1156 
1157 
1158 // File @openzeppelin/contracts/access/AccessControl.sol@v4.2.0
1159 
1160 
1161 
1162 pragma solidity ^0.8.0;
1163 
1164 
1165 
1166 /**
1167  * @dev External interface of AccessControl declared to support ERC165 detection.
1168  */
1169 interface IAccessControl {
1170     function hasRole(bytes32 role, address account) external view returns (bool);
1171 
1172     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1173 
1174     function grantRole(bytes32 role, address account) external;
1175 
1176     function revokeRole(bytes32 role, address account) external;
1177 
1178     function renounceRole(bytes32 role, address account) external;
1179 }
1180 
1181 /**
1182  * @dev Contract module that allows children to implement role-based access
1183  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1184  * members except through off-chain means by accessing the contract event logs. Some
1185  * applications may benefit from on-chain enumerability, for those cases see
1186  * {AccessControlEnumerable}.
1187  *
1188  * Roles are referred to by their `bytes32` identifier. These should be exposed
1189  * in the external API and be unique. The best way to achieve this is by
1190  * using `public constant` hash digests:
1191  *
1192  * ```
1193  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1194  * ```
1195  *
1196  * Roles can be used to represent a set of permissions. To restrict access to a
1197  * function call, use {hasRole}:
1198  *
1199  * ```
1200  * function foo() public {
1201  *     require(hasRole(MY_ROLE, msg.sender));
1202  *     ...
1203  * }
1204  * ```
1205  *
1206  * Roles can be granted and revoked dynamically via the {grantRole} and
1207  * {revokeRole} functions. Each role has an associated admin role, and only
1208  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1209  *
1210  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1211  * that only accounts with this role will be able to grant or revoke other
1212  * roles. More complex role relationships can be created by using
1213  * {_setRoleAdmin}.
1214  *
1215  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1216  * grant and revoke this role. Extra precautions should be taken to secure
1217  * accounts that have been granted it.
1218  */
1219 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1220     struct RoleData {
1221         mapping(address => bool) members;
1222         bytes32 adminRole;
1223     }
1224 
1225     mapping(bytes32 => RoleData) private _roles;
1226 
1227     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1228 
1229     /**
1230      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1231      *
1232      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1233      * {RoleAdminChanged} not being emitted signaling this.
1234      *
1235      * _Available since v3.1._
1236      */
1237     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1238 
1239     /**
1240      * @dev Emitted when `account` is granted `role`.
1241      *
1242      * `sender` is the account that originated the contract call, an admin role
1243      * bearer except when using {_setupRole}.
1244      */
1245     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1246 
1247     /**
1248      * @dev Emitted when `account` is revoked `role`.
1249      *
1250      * `sender` is the account that originated the contract call:
1251      *   - if using `revokeRole`, it is the admin role bearer
1252      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1253      */
1254     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1255 
1256     /**
1257      * @dev Modifier that checks that an account has a specific role. Reverts
1258      * with a standardized message including the required role.
1259      *
1260      * The format of the revert reason is given by the following regular expression:
1261      *
1262      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1263      *
1264      * _Available since v4.1._
1265      */
1266     modifier onlyRole(bytes32 role) {
1267         _checkRole(role, _msgSender());
1268         _;
1269     }
1270 
1271     /**
1272      * @dev See {IERC165-supportsInterface}.
1273      */
1274     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1275         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1276     }
1277 
1278     /**
1279      * @dev Returns `true` if `account` has been granted `role`.
1280      */
1281     function hasRole(bytes32 role, address account) public view override returns (bool) {
1282         return _roles[role].members[account];
1283     }
1284 
1285     /**
1286      * @dev Revert with a standard message if `account` is missing `role`.
1287      *
1288      * The format of the revert reason is given by the following regular expression:
1289      *
1290      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1291      */
1292     function _checkRole(bytes32 role, address account) internal view {
1293         if (!hasRole(role, account)) {
1294             revert(
1295                 string(
1296                     abi.encodePacked(
1297                         "AccessControl: account ",
1298                         Strings.toHexString(uint160(account), 20),
1299                         " is missing role ",
1300                         Strings.toHexString(uint256(role), 32)
1301                     )
1302                 )
1303             );
1304         }
1305     }
1306 
1307     /**
1308      * @dev Returns the admin role that controls `role`. See {grantRole} and
1309      * {revokeRole}.
1310      *
1311      * To change a role's admin, use {_setRoleAdmin}.
1312      */
1313     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1314         return _roles[role].adminRole;
1315     }
1316 
1317     /**
1318      * @dev Grants `role` to `account`.
1319      *
1320      * If `account` had not been already granted `role`, emits a {RoleGranted}
1321      * event.
1322      *
1323      * Requirements:
1324      *
1325      * - the caller must have ``role``'s admin role.
1326      */
1327     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1328         _grantRole(role, account);
1329     }
1330 
1331     /**
1332      * @dev Revokes `role` from `account`.
1333      *
1334      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1335      *
1336      * Requirements:
1337      *
1338      * - the caller must have ``role``'s admin role.
1339      */
1340     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1341         _revokeRole(role, account);
1342     }
1343 
1344     /**
1345      * @dev Revokes `role` from the calling account.
1346      *
1347      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1348      * purpose is to provide a mechanism for accounts to lose their privileges
1349      * if they are compromised (such as when a trusted device is misplaced).
1350      *
1351      * If the calling account had been granted `role`, emits a {RoleRevoked}
1352      * event.
1353      *
1354      * Requirements:
1355      *
1356      * - the caller must be `account`.
1357      */
1358     function renounceRole(bytes32 role, address account) public virtual override {
1359         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1360 
1361         _revokeRole(role, account);
1362     }
1363 
1364     /**
1365      * @dev Grants `role` to `account`.
1366      *
1367      * If `account` had not been already granted `role`, emits a {RoleGranted}
1368      * event. Note that unlike {grantRole}, this function doesn't perform any
1369      * checks on the calling account.
1370      *
1371      * [WARNING]
1372      * ====
1373      * This function should only be called from the constructor when setting
1374      * up the initial roles for the system.
1375      *
1376      * Using this function in any other way is effectively circumventing the admin
1377      * system imposed by {AccessControl}.
1378      * ====
1379      */
1380     function _setupRole(bytes32 role, address account) internal virtual {
1381         _grantRole(role, account);
1382     }
1383 
1384     /**
1385      * @dev Sets `adminRole` as ``role``'s admin role.
1386      *
1387      * Emits a {RoleAdminChanged} event.
1388      */
1389     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1390         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1391         _roles[role].adminRole = adminRole;
1392     }
1393 
1394     function _grantRole(bytes32 role, address account) private {
1395         if (!hasRole(role, account)) {
1396             _roles[role].members[account] = true;
1397             emit RoleGranted(role, account, _msgSender());
1398         }
1399     }
1400 
1401     function _revokeRole(bytes32 role, address account) private {
1402         if (hasRole(role, account)) {
1403             _roles[role].members[account] = false;
1404             emit RoleRevoked(role, account, _msgSender());
1405         }
1406     }
1407 }
1408 
1409 
1410 // File contracts/common/AccessControlMixin.sol
1411 
1412 
1413 pragma solidity 0.8.4;
1414 
1415 contract AccessControlMixin is AccessControl {
1416     string private _revertMsg;
1417     function _setupContractId(string memory contractId) internal {
1418         _revertMsg = string(abi.encodePacked(contractId, ": INSUFFICIENT_PERMISSIONS"));
1419     }
1420 
1421     modifier only(bytes32 role) {
1422         require(
1423             hasRole(role, _msgSender()),
1424             _revertMsg
1425         );
1426         _;
1427     }
1428 }
1429 
1430 
1431 // File contracts/common/ContextMixin.sol
1432 
1433 
1434 pragma solidity 0.8.4;
1435 
1436 abstract contract ContextMixin {
1437     function msgSender()
1438         internal
1439         view
1440         returns (address sender)
1441     {
1442         if (msg.sender == address(this)) {
1443             bytes memory array = msg.data;
1444             uint256 index = msg.data.length;
1445             assembly {
1446                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1447                 sender := and(
1448                     mload(add(array, index)),
1449                     0xffffffffffffffffffffffffffffffffffffffff
1450                 )
1451             }
1452         } else {
1453             sender = msg.sender;
1454         }
1455         return sender;
1456     }
1457 }
1458 
1459 
1460 // File contracts/ethereum/Moonchest.sol
1461 
1462 
1463 pragma solidity 0.8.4;
1464 
1465 
1466 
1467 
1468 
1469 
1470 /** 
1471  * @title Moonchest contract
1472  */
1473 contract Moonchest is FxBaseRootTunnel, AccessControlMixin, ContextMixin, ReentrancyGuard, Pausable {
1474 
1475     // STATE CONSTANTS
1476     bytes32 public constant PRICE_ADMIN_ROLE = keccak256("PRICE_ADMIN_ROLE");
1477 
1478     // STATE VARIABLES
1479     IERC20 private _moonieToken;
1480     address private _bank;
1481 
1482     uint256 public moonchestPrice;
1483     uint256 public maxMoonchests;
1484 
1485     // MODIFIERS
1486 
1487     modifier moonchestLimit(uint256 amount) 
1488     {
1489         require(amount <= maxMoonchests, "Moonchest: Too many moonchests");
1490         _;
1491     }
1492 
1493     // CONSTRUCTOR
1494 
1495     constructor(address moonieToken, address checkpointManager, address fxRoot, address bank)  FxBaseRootTunnel(checkpointManager, fxRoot) Pausable() {
1496         _moonieToken = IERC20(moonieToken);
1497         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1498         _bank = bank;
1499         _pause();
1500     }
1501 
1502     // EXTERNAL FUNCTIONS
1503 
1504     function openMoonchests(uint256 amount) external nonReentrant whenNotPaused moonchestLimit(amount) {
1505         require(_moonieToken.transferFrom(msg.sender, _bank, amount * moonchestPrice), "Moonchest: There was a problem with MNY transfer");
1506         _sendMessageToChild(abi.encode(msg.sender, amount));
1507     }
1508 
1509     function setBank(address bank) external only(DEFAULT_ADMIN_ROLE) {
1510         _bank = bank;
1511     }
1512 
1513     function setMoonchestPrice(uint256 price) external only(PRICE_ADMIN_ROLE) {
1514         moonchestPrice = price;
1515     }
1516 
1517     function setMoonchestLimit(uint256 limit) external only(DEFAULT_ADMIN_ROLE) {
1518         maxMoonchests = limit;
1519     }
1520 
1521     function pause() external only(DEFAULT_ADMIN_ROLE) {
1522         _pause();
1523     }
1524 
1525     function unpause() external only(DEFAULT_ADMIN_ROLE) {
1526         _unpause();
1527     }
1528 
1529     // INTERNAL FUNCTIONS
1530 
1531     function _processMessageFromChild(bytes memory data) internal override {
1532     }
1533 
1534 }