1 //SPDX-License-Identifier: MIT
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 
39 /**
40  * @dev Contract module which allows children to implement an emergency stop
41  * mechanism that can be triggered by an authorized account.
42  *
43  * This module is used through inheritance. It will make available the
44  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
45  * the functions of your contract. Note that they will not be pausable by
46  * simply including this module, only once the modifiers are put in place.
47  */
48 abstract contract Pausable is Context {
49     /**
50      * @dev Emitted when the pause is triggered by `account`.
51      */
52     event Paused(address account);
53 
54     /**
55      * @dev Emitted when the pause is lifted by `account`.
56      */
57     event Unpaused(address account);
58 
59     bool private _paused;
60 
61     /**
62      * @dev Initializes the contract in unpaused state.
63      */
64     constructor() {
65         _paused = false;
66     }
67 
68     /**
69      * @dev Modifier to make a function callable only when the contract is not paused.
70      *
71      * Requirements:
72      *
73      * - The contract must not be paused.
74      */
75     modifier whenNotPaused() {
76         _requireNotPaused();
77         _;
78     }
79 
80     /**
81      * @dev Modifier to make a function callable only when the contract is paused.
82      *
83      * Requirements:
84      *
85      * - The contract must be paused.
86      */
87     modifier whenPaused() {
88         _requirePaused();
89         _;
90     }
91 
92     /**
93      * @dev Returns true if the contract is paused, and false otherwise.
94      */
95     function paused() public view virtual returns (bool) {
96         return _paused;
97     }
98 
99     /**
100      * @dev Throws if the contract is paused.
101      */
102     function _requireNotPaused() internal view virtual {
103         require(!paused(), "Pausable: paused");
104     }
105 
106     /**
107      * @dev Throws if the contract is not paused.
108      */
109     function _requirePaused() internal view virtual {
110         require(paused(), "Pausable: not paused");
111     }
112 
113     /**
114      * @dev Triggers stopped state.
115      *
116      * Requirements:
117      *
118      * - The contract must not be paused.
119      */
120     function _pause() internal virtual whenNotPaused {
121         _paused = true;
122         emit Paused(_msgSender());
123     }
124 
125     /**
126      * @dev Returns to normal state.
127      *
128      * Requirements:
129      *
130      * - The contract must be paused.
131      */
132     function _unpause() internal virtual whenPaused {
133         _paused = false;
134         emit Unpaused(_msgSender());
135     }
136 }
137 
138 // File: contracts/VOXOVTNFT.sol
139 
140 
141 // File: @maticnetwork/fx-portal/contracts/lib/Merkle.sol
142 
143 
144 pragma solidity ^0.8.0;
145 
146 library Merkle {
147     function checkMembership(
148         bytes32 leaf,
149         uint256 index,
150         bytes32 rootHash,
151         bytes memory proof
152     ) internal pure returns (bool) {
153         require(proof.length % 32 == 0, "Invalid proof length");
154         uint256 proofHeight = proof.length / 32;
155         // Proof of size n means, height of the tree is n+1.
156         // In a tree of height n+1, max #leafs possible is 2 ^ n
157         require(index < 2 ** proofHeight, "Leaf index is too big");
158 
159         bytes32 proofElement;
160         bytes32 computedHash = leaf;
161         for (uint256 i = 32; i <= proof.length; i += 32) {
162             assembly {
163                 proofElement := mload(add(proof, i))
164             }
165 
166             if (index % 2 == 0) {
167                 computedHash = keccak256(
168                     abi.encodePacked(computedHash, proofElement)
169                 );
170             } else {
171                 computedHash = keccak256(
172                     abi.encodePacked(proofElement, computedHash)
173                 );
174             }
175 
176             index = index / 2;
177         }
178         return computedHash == rootHash;
179     }
180 }
181 
182 // File: @maticnetwork/fx-portal/contracts/lib/RLPReader.sol
183 
184 
185 /*
186 * @author Hamdi Allam hamdi.allam97@gmail.com
187 * Please reach out with any questions or concerns
188 */
189 pragma solidity ^0.8.0;
190 
191 library RLPReader {
192     uint8 constant STRING_SHORT_START = 0x80;
193     uint8 constant STRING_LONG_START  = 0xb8;
194     uint8 constant LIST_SHORT_START   = 0xc0;
195     uint8 constant LIST_LONG_START    = 0xf8;
196     uint8 constant WORD_SIZE = 32;
197 
198     struct RLPItem {
199         uint len;
200         uint memPtr;
201     }
202 
203     struct Iterator {
204         RLPItem item;   // Item that's being iterated over.
205         uint nextPtr;   // Position of the next item in the list.
206     }
207 
208     /*
209     * @dev Returns the next element in the iteration. Reverts if it has not next element.
210     * @param self The iterator.
211     * @return The next element in the iteration.
212     */
213     function next(Iterator memory self) internal pure returns (RLPItem memory) {
214         require(hasNext(self));
215 
216         uint ptr = self.nextPtr;
217         uint itemLength = _itemLength(ptr);
218         self.nextPtr = ptr + itemLength;
219 
220         return RLPItem(itemLength, ptr);
221     }
222 
223     /*
224     * @dev Returns true if the iteration has more elements.
225     * @param self The iterator.
226     * @return true if the iteration has more elements.
227     */
228     function hasNext(Iterator memory self) internal pure returns (bool) {
229         RLPItem memory item = self.item;
230         return self.nextPtr < item.memPtr + item.len;
231     }
232 
233     /*
234     * @param item RLP encoded bytes
235     */
236     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
237         uint memPtr;
238         assembly {
239             memPtr := add(item, 0x20)
240         }
241 
242         return RLPItem(item.length, memPtr);
243     }
244 
245     /*
246     * @dev Create an iterator. Reverts if item is not a list.
247     * @param self The RLP item.
248     * @return An 'Iterator' over the item.
249     */
250     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
251         require(isList(self));
252 
253         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
254         return Iterator(self, ptr);
255     }
256 
257     /*
258     * @param item RLP encoded bytes
259     */
260     function rlpLen(RLPItem memory item) internal pure returns (uint) {
261         return item.len;
262     }
263 
264     /*
265     * @param item RLP encoded bytes
266     */
267     function payloadLen(RLPItem memory item) internal pure returns (uint) {
268         return item.len - _payloadOffset(item.memPtr);
269     }
270 
271     /*
272     * @param item RLP encoded list in bytes
273     */
274     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
275         require(isList(item));
276 
277         uint items = numItems(item);
278         RLPItem[] memory result = new RLPItem[](items);
279 
280         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
281         uint dataLen;
282         for (uint i = 0; i < items; i++) {
283             dataLen = _itemLength(memPtr);
284             result[i] = RLPItem(dataLen, memPtr); 
285             memPtr = memPtr + dataLen;
286         }
287 
288         return result;
289     }
290 
291     // @return indicator whether encoded payload is a list. negate this function call for isData.
292     function isList(RLPItem memory item) internal pure returns (bool) {
293         if (item.len == 0) return false;
294 
295         uint8 byte0;
296         uint memPtr = item.memPtr;
297         assembly {
298             byte0 := byte(0, mload(memPtr))
299         }
300 
301         if (byte0 < LIST_SHORT_START)
302             return false;
303         return true;
304     }
305 
306     /*
307      * @dev A cheaper version of keccak256(toRlpBytes(item)) that avoids copying memory.
308      * @return keccak256 hash of RLP encoded bytes.
309      */
310     function rlpBytesKeccak256(RLPItem memory item) internal pure returns (bytes32) {
311         uint256 ptr = item.memPtr;
312         uint256 len = item.len;
313         bytes32 result;
314         assembly {
315             result := keccak256(ptr, len)
316         }
317         return result;
318     }
319 
320     function payloadLocation(RLPItem memory item) internal pure returns (uint, uint) {
321         uint offset = _payloadOffset(item.memPtr);
322         uint memPtr = item.memPtr + offset;
323         uint len = item.len - offset; // data length
324         return (memPtr, len);
325     }
326 
327     /*
328      * @dev A cheaper version of keccak256(toBytes(item)) that avoids copying memory.
329      * @return keccak256 hash of the item payload.
330      */
331     function payloadKeccak256(RLPItem memory item) internal pure returns (bytes32) {
332         (uint memPtr, uint len) = payloadLocation(item);
333         bytes32 result;
334         assembly {
335             result := keccak256(memPtr, len)
336         }
337         return result;
338     }
339 
340     /** RLPItem conversions into data types **/
341 
342     // @returns raw rlp encoding in bytes
343     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
344         bytes memory result = new bytes(item.len);
345         if (result.length == 0) return result;
346         
347         uint ptr;
348         assembly {
349             ptr := add(0x20, result)
350         }
351 
352         copy(item.memPtr, ptr, item.len);
353         return result;
354     }
355 
356     // any non-zero byte is considered true
357     function toBoolean(RLPItem memory item) internal pure returns (bool) {
358         require(item.len == 1);
359         uint result;
360         uint memPtr = item.memPtr;
361         assembly {
362             result := byte(0, mload(memPtr))
363         }
364 
365         return result == 0 ? false : true;
366     }
367 
368     function toAddress(RLPItem memory item) internal pure returns (address) {
369         // 1 byte for the length prefix
370         require(item.len == 21);
371 
372         return address(uint160(toUint(item)));
373     }
374 
375     function toUint(RLPItem memory item) internal pure returns (uint) {
376         require(item.len > 0 && item.len <= 33);
377 
378         uint offset = _payloadOffset(item.memPtr);
379         uint len = item.len - offset;
380 
381         uint result;
382         uint memPtr = item.memPtr + offset;
383         assembly {
384             result := mload(memPtr)
385 
386             // shfit to the correct location if neccesary
387             if lt(len, 32) {
388                 result := div(result, exp(256, sub(32, len)))
389             }
390         }
391 
392         return result;
393     }
394 
395     // enforces 32 byte length
396     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
397         // one byte prefix
398         require(item.len == 33);
399 
400         uint result;
401         uint memPtr = item.memPtr + 1;
402         assembly {
403             result := mload(memPtr)
404         }
405 
406         return result;
407     }
408 
409     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
410         require(item.len > 0);
411 
412         uint offset = _payloadOffset(item.memPtr);
413         uint len = item.len - offset; // data length
414         bytes memory result = new bytes(len);
415 
416         uint destPtr;
417         assembly {
418             destPtr := add(0x20, result)
419         }
420 
421         copy(item.memPtr + offset, destPtr, len);
422         return result;
423     }
424 
425     /*
426     * Private Helpers
427     */
428 
429     // @return number of payload items inside an encoded list.
430     function numItems(RLPItem memory item) private pure returns (uint) {
431         if (item.len == 0) return 0;
432 
433         uint count = 0;
434         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
435         uint endPtr = item.memPtr + item.len;
436         while (currPtr < endPtr) {
437            currPtr = currPtr + _itemLength(currPtr); // skip over an item
438            count++;
439         }
440 
441         return count;
442     }
443 
444     // @return entire rlp item byte length
445     function _itemLength(uint memPtr) private pure returns (uint) {
446         uint itemLen;
447         uint byte0;
448         assembly {
449             byte0 := byte(0, mload(memPtr))
450         }
451 
452         if (byte0 < STRING_SHORT_START)
453             itemLen = 1;
454         
455         else if (byte0 < STRING_LONG_START)
456             itemLen = byte0 - STRING_SHORT_START + 1;
457 
458         else if (byte0 < LIST_SHORT_START) {
459             assembly {
460                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
461                 memPtr := add(memPtr, 1) // skip over the first byte
462                 /* 32 byte word size */
463                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
464                 itemLen := add(dataLen, add(byteLen, 1))
465             }
466         }
467 
468         else if (byte0 < LIST_LONG_START) {
469             itemLen = byte0 - LIST_SHORT_START + 1;
470         } 
471 
472         else {
473             assembly {
474                 let byteLen := sub(byte0, 0xf7)
475                 memPtr := add(memPtr, 1)
476 
477                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
478                 itemLen := add(dataLen, add(byteLen, 1))
479             }
480         }
481 
482         return itemLen;
483     }
484 
485     // @return number of bytes until the data
486     function _payloadOffset(uint memPtr) private pure returns (uint) {
487         uint byte0;
488         assembly {
489             byte0 := byte(0, mload(memPtr))
490         }
491 
492         if (byte0 < STRING_SHORT_START) 
493             return 0;
494         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
495             return 1;
496         else if (byte0 < LIST_SHORT_START)  // being explicit
497             return byte0 - (STRING_LONG_START - 1) + 1;
498         else
499             return byte0 - (LIST_LONG_START - 1) + 1;
500     }
501 
502     /*
503     * @param src Pointer to source
504     * @param dest Pointer to destination
505     * @param len Amount of memory to copy from the source
506     */
507     function copy(uint src, uint dest, uint len) private pure {
508         if (len == 0) return;
509 
510         // copy as many word sizes as possible
511         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
512             assembly {
513                 mstore(dest, mload(src))
514             }
515 
516             src += WORD_SIZE;
517             dest += WORD_SIZE;
518         }
519 
520         if (len == 0) return;
521 
522         // left over bytes. Mask is used to remove unwanted bytes from the word
523         uint mask = 256 ** (WORD_SIZE - len) - 1;
524 
525         assembly {
526             let srcpart := and(mload(src), not(mask)) // zero out src
527             let destpart := and(mload(dest), mask) // retrieve the bytes
528             mstore(dest, or(destpart, srcpart))
529         }
530     }
531 }
532 
533 // File: @maticnetwork/fx-portal/contracts/lib/ExitPayloadReader.sol
534 
535 
536 pragma solidity ^0.8.0;
537 
538 
539 library ExitPayloadReader {
540   using RLPReader for bytes;
541   using RLPReader for RLPReader.RLPItem;
542 
543   uint8 constant WORD_SIZE = 32;
544 
545   struct ExitPayload {
546     RLPReader.RLPItem[] data;
547   }
548 
549   struct Receipt {
550     RLPReader.RLPItem[] data;
551     bytes raw;
552     uint256 logIndex;
553   }
554 
555   struct Log {
556     RLPReader.RLPItem data;
557     RLPReader.RLPItem[] list;
558   }
559 
560   struct LogTopics {
561     RLPReader.RLPItem[] data;
562   }
563 
564   // copy paste of private copy() from RLPReader to avoid changing of existing contracts
565   function copy(uint src, uint dest, uint len) private pure {
566         if (len == 0) return;
567 
568         // copy as many word sizes as possible
569         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
570             assembly {
571                 mstore(dest, mload(src))
572             }
573 
574             src += WORD_SIZE;
575             dest += WORD_SIZE;
576         }
577 
578         // left over bytes. Mask is used to remove unwanted bytes from the word
579         uint mask = 256 ** (WORD_SIZE - len) - 1;
580         assembly {
581             let srcpart := and(mload(src), not(mask)) // zero out src
582             let destpart := and(mload(dest), mask) // retrieve the bytes
583             mstore(dest, or(destpart, srcpart))
584         }
585     }
586 
587   function toExitPayload(bytes memory data)
588         internal
589         pure
590         returns (ExitPayload memory)
591     {
592         RLPReader.RLPItem[] memory payloadData = data
593             .toRlpItem()
594             .toList();
595 
596         return ExitPayload(payloadData);
597     }
598 
599     function getHeaderNumber(ExitPayload memory payload) internal pure returns(uint256) {
600       return payload.data[0].toUint();
601     }
602 
603     function getBlockProof(ExitPayload memory payload) internal pure returns(bytes memory) {
604       return payload.data[1].toBytes();
605     }
606 
607     function getBlockNumber(ExitPayload memory payload) internal pure returns(uint256) {
608       return payload.data[2].toUint();
609     }
610 
611     function getBlockTime(ExitPayload memory payload) internal pure returns(uint256) {
612       return payload.data[3].toUint();
613     }
614 
615     function getTxRoot(ExitPayload memory payload) internal pure returns(bytes32) {
616       return bytes32(payload.data[4].toUint());
617     }
618 
619     function getReceiptRoot(ExitPayload memory payload) internal pure returns(bytes32) {
620       return bytes32(payload.data[5].toUint());
621     }
622 
623     function getReceipt(ExitPayload memory payload) internal pure returns(Receipt memory receipt) {
624       receipt.raw = payload.data[6].toBytes();
625       RLPReader.RLPItem memory receiptItem = receipt.raw.toRlpItem();
626 
627       if (receiptItem.isList()) {
628           // legacy tx
629           receipt.data = receiptItem.toList();
630       } else {
631           // pop first byte before parsting receipt
632           bytes memory typedBytes = receipt.raw;
633           bytes memory result = new bytes(typedBytes.length - 1);
634           uint256 srcPtr;
635           uint256 destPtr;
636           assembly {
637               srcPtr := add(33, typedBytes)
638               destPtr := add(0x20, result)
639           }
640 
641           copy(srcPtr, destPtr, result.length);
642           receipt.data = result.toRlpItem().toList();
643       }
644 
645       receipt.logIndex = getReceiptLogIndex(payload);
646       return receipt;
647     }
648 
649     function getReceiptProof(ExitPayload memory payload) internal pure returns(bytes memory) {
650       return payload.data[7].toBytes();
651     }
652 
653     function getBranchMaskAsBytes(ExitPayload memory payload) internal pure returns(bytes memory) {
654       return payload.data[8].toBytes();
655     }
656 
657     function getBranchMaskAsUint(ExitPayload memory payload) internal pure returns(uint256) {
658       return payload.data[8].toUint();
659     }
660 
661     function getReceiptLogIndex(ExitPayload memory payload) internal pure returns(uint256) {
662       return payload.data[9].toUint();
663     }
664     
665     // Receipt methods
666     function toBytes(Receipt memory receipt) internal pure returns(bytes memory) {
667         return receipt.raw;
668     }
669 
670     function getLog(Receipt memory receipt) internal pure returns(Log memory) {
671         RLPReader.RLPItem memory logData = receipt.data[3].toList()[receipt.logIndex];
672         return Log(logData, logData.toList());
673     }
674 
675     // Log methods
676     function getEmitter(Log memory log) internal pure returns(address) {
677       return RLPReader.toAddress(log.list[0]);
678     }
679 
680     function getTopics(Log memory log) internal pure returns(LogTopics memory) {
681         return LogTopics(log.list[1].toList());
682     }
683 
684     function getData(Log memory log) internal pure returns(bytes memory) {
685         return log.list[2].toBytes();
686     }
687 
688     function toRlpBytes(Log memory log) internal pure returns(bytes memory) {
689       return log.data.toRlpBytes();
690     }
691 
692     // LogTopics methods
693     function getField(LogTopics memory topics, uint256 index) internal pure returns(RLPReader.RLPItem memory) {
694       return topics.data[index];
695     }
696 }
697 
698 // File: @maticnetwork/fx-portal/contracts/lib/MerklePatriciaProof.sol
699 
700 
701 pragma solidity ^0.8.0;
702 
703 
704 library MerklePatriciaProof {
705     /*
706      * @dev Verifies a merkle patricia proof.
707      * @param value The terminating value in the trie.
708      * @param encodedPath The path in the trie leading to value.
709      * @param rlpParentNodes The rlp encoded stack of nodes.
710      * @param root The root hash of the trie.
711      * @return The boolean validity of the proof.
712      */
713     function verify(
714         bytes memory value,
715         bytes memory encodedPath,
716         bytes memory rlpParentNodes,
717         bytes32 root
718     ) internal pure returns (bool _bool) {
719         RLPReader.RLPItem memory item = RLPReader.toRlpItem(rlpParentNodes);
720         RLPReader.RLPItem[] memory parentNodes = RLPReader.toList(item);
721 
722         bytes memory currentNode;
723         RLPReader.RLPItem[] memory currentNodeList;
724 
725         bytes32 nodeKey = root;
726         uint256 pathPtr = 0;
727 
728         bytes memory path = _getNibbleArray(encodedPath);
729         if (path.length == 0) {
730             _bool =  false;
731         }
732 
733         for (uint256 i = 0; i < parentNodes.length; i++) {
734             if (pathPtr > path.length) {
735                 _bool = false;
736             }
737 
738             currentNode = RLPReader.toRlpBytes(parentNodes[i]);
739             if (nodeKey != keccak256(currentNode)) {
740                 _bool = false;
741             }
742             currentNodeList = RLPReader.toList(parentNodes[i]);
743 
744             if (currentNodeList.length == 17) {
745                 if (pathPtr == path.length) {
746                     if (
747                         keccak256(RLPReader.toBytes(currentNodeList[16])) ==
748                         keccak256(value)
749                     ) {
750                         _bool = true;
751                     } else {
752                         _bool = false;
753                     }
754                 }
755 
756                 uint8 nextPathNibble = uint8(path[pathPtr]);
757                 if (nextPathNibble > 16) {
758                     _bool = false;
759                 }
760                 nodeKey = bytes32(
761                     RLPReader.toUintStrict(currentNodeList[nextPathNibble])
762                 );
763                 pathPtr += 1;
764             } else if (currentNodeList.length == 2) {
765                 uint256 traversed = _nibblesToTraverse(
766                     RLPReader.toBytes(currentNodeList[0]),
767                     path,
768                     pathPtr
769                 );
770                 if (pathPtr + traversed == path.length) {
771                     //leaf node
772                     if (
773                         keccak256(RLPReader.toBytes(currentNodeList[1])) ==
774                         keccak256(value)
775                     ) {
776                         _bool = true;
777                     } else {
778                         _bool = false;
779                     }
780                 }
781 
782                 //extension node
783                 if (traversed == 0) {
784                     _bool = false;
785                 }
786 
787                 pathPtr += traversed;
788                 nodeKey = bytes32(RLPReader.toUintStrict(currentNodeList[1]));
789             } else {
790                 _bool = false;
791             }
792         }
793     }
794 
795     function _nibblesToTraverse(
796         bytes memory encodedPartialPath,
797         bytes memory path,
798         uint256 pathPtr
799     ) private pure returns (uint256) {
800         uint256 len = 0;
801         // encodedPartialPath has elements that are each two hex characters (1 byte), but partialPath
802         // and slicedPath have elements that are each one hex character (1 nibble)
803         bytes memory partialPath = _getNibbleArray(encodedPartialPath);
804         bytes memory slicedPath = new bytes(partialPath.length);
805 
806         // pathPtr counts nibbles in path
807         // partialPath.length is a number of nibbles
808         for (uint256 i = pathPtr; i < pathPtr + partialPath.length; i++) {
809             bytes1 pathNibble = path[i];
810             slicedPath[i - pathPtr] = pathNibble;
811         }
812 
813         if (keccak256(partialPath) == keccak256(slicedPath)) {
814             len = partialPath.length;
815         } else {
816             len = 0;
817         }
818         return len;
819     }
820 
821     // bytes b must be hp encoded
822     function _getNibbleArray(bytes memory b)
823         internal
824         pure
825         returns (bytes memory)
826     {
827         bytes memory nibbles = "";
828         if (b.length > 0) {
829             uint8 offset;
830             uint8 hpNibble = uint8(_getNthNibbleOfBytes(0, b));
831             if (hpNibble == 1 || hpNibble == 3) {
832                 nibbles = new bytes(b.length * 2 - 1);
833                 bytes1 oddNibble = _getNthNibbleOfBytes(1, b);
834                 nibbles[0] = oddNibble;
835                 offset = 1;
836             } else {
837                 nibbles = new bytes(b.length * 2 - 2);
838                 offset = 0;
839             }
840 
841             for (uint256 i = offset; i < nibbles.length; i++) {
842                 nibbles[i] = _getNthNibbleOfBytes(i - offset + 2, b);
843             }
844         }
845         return nibbles;
846     }
847 
848     function _getNthNibbleOfBytes(uint256 n, bytes memory str)
849         private
850         pure
851         returns (bytes1)
852     {
853         return
854             bytes1(
855                 n % 2 == 0 ? uint8(str[n / 2]) / 0x10 : uint8(str[n / 2]) % 0x10
856             );
857     }
858 }
859 // File: @maticnetwork/fx-portal/contracts/tunnel/FxBaseRootTunnel.sol
860 
861 
862 pragma solidity ^0.8.0;
863 
864 
865 
866 
867 
868 
869 interface IFxStateSender {
870     function sendMessageToChild(address _receiver, bytes calldata _data) external;
871 }
872 
873 contract ICheckpointManager {
874     struct HeaderBlock {
875         bytes32 root;
876         uint256 start;
877         uint256 end;
878         uint256 createdAt;
879         address proposer;
880     }
881 
882     /**
883      * @notice mapping of checkpoint header numbers to block details
884      * @dev These checkpoints are submited by plasma contracts
885      */
886     mapping(uint256 => HeaderBlock) public headerBlocks;
887 }
888 
889 abstract contract FxBaseRootTunnel {
890     using RLPReader for RLPReader.RLPItem;
891     using Merkle for bytes32;
892     using ExitPayloadReader for bytes;
893     using ExitPayloadReader for ExitPayloadReader.ExitPayload;
894     using ExitPayloadReader for ExitPayloadReader.Log;
895     using ExitPayloadReader for ExitPayloadReader.LogTopics;
896     using ExitPayloadReader for ExitPayloadReader.Receipt;
897 
898     // keccak256(MessageSent(bytes))
899     bytes32 public constant SEND_MESSAGE_EVENT_SIG = 0x8c5261668696ce22758910d05bab8f186d6eb247ceac2af2e82c7dc17669b036;
900 
901     // state sender contract
902     IFxStateSender public fxRoot;
903     // root chain manager
904     ICheckpointManager public checkpointManager;
905     // child tunnel contract which receives and sends messages 
906     address public fxChildTunnel;
907 
908     // storage to avoid duplicate exits
909     mapping(bytes32 => bool) public processedExits;
910 
911     constructor(address _checkpointManager, address _fxRoot) {
912         checkpointManager = ICheckpointManager(_checkpointManager);
913         fxRoot = IFxStateSender(_fxRoot);
914     }
915 
916     // set fxChildTunnel if not set already
917     function setFxChildTunnel(address _fxChildTunnel) public {
918         require(fxChildTunnel == address(0x0), "FxBaseRootTunnel: CHILD_TUNNEL_ALREADY_SET");
919         fxChildTunnel = _fxChildTunnel;
920     }
921 
922     /**
923      * @notice Send bytes message to Child Tunnel
924      * @param message bytes message that will be sent to Child Tunnel
925      * some message examples -
926      *   abi.encode(tokenId);
927      *   abi.encode(tokenId, tokenMetadata);
928      *   abi.encode(messageType, messageData);
929      */
930     function _sendMessageToChild(bytes memory message) internal {
931         fxRoot.sendMessageToChild(fxChildTunnel, message);
932     }
933 
934     function _validateAndExtractMessage(bytes memory inputData) internal returns (bytes memory) {
935         ExitPayloadReader.ExitPayload memory payload = inputData.toExitPayload();
936 
937         bytes memory branchMaskBytes = payload.getBranchMaskAsBytes();
938         uint256 blockNumber = payload.getBlockNumber();
939         // checking if exit has already been processed
940         // unique exit is identified using hash of (blockNumber, branchMask, receiptLogIndex)
941         bytes32 exitHash = keccak256(
942             abi.encodePacked(
943                 blockNumber,
944                 // first 2 nibbles are dropped while generating nibble array
945                 // this allows branch masks that are valid but bypass exitHash check (changing first 2 nibbles only)
946                 // so converting to nibble array and then hashing it
947                 MerklePatriciaProof._getNibbleArray(branchMaskBytes),
948                 payload.getReceiptLogIndex()
949             )
950         );
951         require(
952             processedExits[exitHash] == false,
953             "FxRootTunnel: EXIT_ALREADY_PROCESSED"
954         );
955         processedExits[exitHash] = true;
956 
957         ExitPayloadReader.Receipt memory receipt = payload.getReceipt();
958         ExitPayloadReader.Log memory log = receipt.getLog();
959 
960         // check child tunnel
961         require(fxChildTunnel == log.getEmitter(), "FxRootTunnel: INVALID_FX_CHILD_TUNNEL");
962 
963         bytes32 receiptRoot = payload.getReceiptRoot();
964         // verify receipt inclusion
965         require(
966             MerklePatriciaProof.verify(
967                 receipt.toBytes(), 
968                 branchMaskBytes, 
969                 payload.getReceiptProof(), 
970                 receiptRoot
971             ),
972             "FxRootTunnel: INVALID_RECEIPT_PROOF"
973         );
974 
975         // verify checkpoint inclusion
976         _checkBlockMembershipInCheckpoint(
977             blockNumber,
978             payload.getBlockTime(),
979             payload.getTxRoot(),
980             receiptRoot,
981             payload.getHeaderNumber(),
982             payload.getBlockProof()
983         );
984 
985         ExitPayloadReader.LogTopics memory topics = log.getTopics();
986 
987         require(
988             bytes32(topics.getField(0).toUint()) == SEND_MESSAGE_EVENT_SIG, // topic0 is event sig
989             "FxRootTunnel: INVALID_SIGNATURE"
990         );
991 
992         // received message data
993         (bytes memory message) = abi.decode(log.getData(), (bytes)); // event decodes params again, so decoding bytes to get message
994         return message;
995     }
996 
997     function _checkBlockMembershipInCheckpoint(
998         uint256 blockNumber,
999         uint256 blockTime,
1000         bytes32 txRoot,
1001         bytes32 receiptRoot,
1002         uint256 headerNumber,
1003         bytes memory blockProof
1004     ) private view returns (uint256) {
1005         (
1006             bytes32 headerRoot,
1007             uint256 startBlock,
1008             ,
1009             uint256 createdAt,
1010 
1011         ) = checkpointManager.headerBlocks(headerNumber);
1012 
1013         require(
1014             keccak256(
1015                 abi.encodePacked(blockNumber, blockTime, txRoot, receiptRoot)
1016             )
1017                 .checkMembership(
1018                 blockNumber-startBlock,
1019                 headerRoot,
1020                 blockProof
1021             ),
1022             "FxRootTunnel: INVALID_HEADER"
1023         );
1024         return createdAt;
1025     }
1026 
1027     /**
1028      * @notice receive message from  L2 to L1, validated by proof
1029      * @dev This function verifies if the transaction actually happened on child chain
1030      *
1031      * @param inputData RLP encoded data of the reference tx containing following list of fields
1032      *  0 - headerNumber - Checkpoint header block number containing the reference tx
1033      *  1 - blockProof - Proof that the block header (in the child chain) is a leaf in the submitted merkle root
1034      *  2 - blockNumber - Block number containing the reference tx on child chain
1035      *  3 - blockTime - Reference tx block time
1036      *  4 - txRoot - Transactions root of block
1037      *  5 - receiptRoot - Receipts root of block
1038      *  6 - receipt - Receipt of the reference transaction
1039      *  7 - receiptProof - Merkle proof of the reference receipt
1040      *  8 - branchMask - 32 bits denoting the path of receipt in merkle tree
1041      *  9 - receiptLogIndex - Log Index to read from the receipt
1042      */
1043     function receiveMessage(bytes memory inputData) public virtual {
1044         bytes memory message = _validateAndExtractMessage(inputData);
1045         _processMessageFromChild(message);
1046     }
1047 
1048     /**
1049      * @notice Process message received from Child Tunnel
1050      * @dev function needs to be implemented to handle message as per requirement
1051      * This is called by onStateReceive function.
1052      * Since it is called via a system call, any event will not be emitted during its execution.
1053      * @param message bytes message that was sent from Child Tunnel
1054      */
1055     function _processMessageFromChild(bytes memory message) virtual internal;
1056 }
1057 
1058 // File: contracts/vvotOMMP.sol
1059 
1060 
1061 
1062 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1063 pragma solidity ^0.8.0;
1064 
1065 
1066 
1067 /**
1068  * @dev Interface of the ERC165 standard, as defined in the
1069  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1070  *
1071  * Implementers can declare support of contract interfaces, which can then be
1072  * queried by others ({ERC165Checker}).
1073  *
1074  * For an implementation, see {ERC165}.
1075  */
1076 interface IERC165 {
1077     /**
1078      * @dev Returns true if this contract implements the interface defined by
1079      * `interfaceId`. See the corresponding
1080      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1081      * to learn more about how these ids are created.
1082      *
1083      * This function call must use less than 30 000 gas.
1084      */
1085     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1086 }
1087 
1088 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1089 pragma solidity ^0.8.0;
1090 /**
1091  * @dev Required interface of an ERC721 compliant contract.
1092  */
1093 /**
1094  * @dev Required interface of an ERC721 compliant contract.
1095  */
1096 interface IERC721 is IERC165 {
1097     /**
1098      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1099      */
1100     event Transfer(
1101         address indexed from,
1102         address indexed to,
1103         uint256 indexed tokenId
1104     );
1105 
1106     /**
1107      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1108      */
1109     event Approval(
1110         address indexed owner,
1111         address indexed approved,
1112         uint256 indexed tokenId
1113     );
1114 
1115     /**
1116      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1117      */
1118     event ApprovalForAll(
1119         address indexed owner,
1120         address indexed operator,
1121         bool approved
1122     );
1123 
1124     event fxcall(
1125         address indexed to
1126     );
1127 
1128     /**
1129      * @dev Returns the number of tokens in ``owner``'s account.
1130      */
1131     function balanceOf(address owner) external view returns (uint256 balance);
1132 
1133     /**
1134      * @dev Returns the owner of the `tokenId` token.
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must exist.
1139      */
1140     function ownerOf(uint256 tokenId) external view returns (address owner);
1141 
1142     /**
1143      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1144      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1145      *
1146      * Requirements:
1147      *
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must exist and be owned by `from`.
1151      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function safeTransferFrom(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) external;
1161 
1162     /**
1163      * @dev Transfers `tokenId` token from `from` to `to`.
1164      *
1165      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1166      *
1167      * Requirements:
1168      *
1169      * - `from` cannot be the zero address.
1170      * - `to` cannot be the zero address.
1171      * - `tokenId` token must be owned by `from`.
1172      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1173      *
1174      * Emits a {Transfer} event.
1175      */
1176     function transferFrom(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) external;
1181 
1182     /**
1183      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1184      * The approval is cleared when the token is transferred.
1185      *
1186      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1187      *
1188      * Requirements:
1189      *
1190      * - The caller must own the token or be an approved operator.
1191      * - `tokenId` must exist.
1192      *
1193      * Emits an {Approval} event.
1194      */
1195     function approve(address to, uint256 tokenId) external;
1196 
1197     /**
1198      * @dev Returns the account approved for `tokenId` token.
1199      *
1200      * Requirements:
1201      *
1202      * - `tokenId` must exist.
1203      */
1204     function getApproved(uint256 tokenId)
1205         external
1206         view
1207         returns (address operator);
1208 
1209     /**
1210      * @dev Approve or remove `operator` as an operator for the caller.
1211      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1212      *
1213      * Requirements:
1214      *
1215      * - The `operator` cannot be the caller.
1216      *
1217      * Emits an {ApprovalForAll} event.
1218      */
1219     function setApprovalForAll(address operator, bool _approved) external;
1220 
1221     /**
1222      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1223      *
1224      * See {setApprovalForAll}
1225      */
1226     function isApprovedForAll(address owner, address operator)
1227         external
1228         view
1229         returns (bool);
1230 
1231     /**
1232      * @dev Safely transfers `tokenId` token from `from` to `to`.
1233      *
1234      * Requirements:
1235      *
1236      * - `from` cannot be the zero address.
1237      * - `to` cannot be the zero address.
1238      * - `tokenId` token must exist and be owned by `from`.
1239      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function safeTransferFrom(
1245         address from,
1246         address to,
1247         uint256 tokenId,
1248         bytes calldata data
1249     ) external;
1250 }
1251 
1252 
1253 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1254 pragma solidity ^0.8.0;
1255 /**
1256  * @dev Implementation of the {IERC165} interface.
1257  *
1258  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1259  * for the additional interface id that will be supported. For example:
1260  *
1261  * ```solidity
1262  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1263  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1264  * }
1265  * ```
1266  *
1267  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1268  */
1269 abstract contract ERC165 is IERC165 {
1270     /**
1271      * @dev See {IERC165-supportsInterface}.
1272      */
1273     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1274         return interfaceId == type(IERC165).interfaceId;
1275     }
1276 }
1277 
1278 // File: @openzeppelin/contracts/utils/Strings.sol
1279 
1280 
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 /**
1285  * @dev String operations.
1286  */
1287 library Strings {
1288     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1289 
1290     /**
1291      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1292      */
1293     function toString(uint256 value) internal pure returns (string memory) {
1294         // Inspired by OraclizeAPI's implementation - MIT licence
1295         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1296 
1297         if (value == 0) {
1298             return "0";
1299         }
1300         uint256 temp = value;
1301         uint256 digits;
1302         while (temp != 0) {
1303             digits++;
1304             temp /= 10;
1305         }
1306         bytes memory buffer = new bytes(digits);
1307         while (value != 0) {
1308             digits -= 1;
1309             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1310             value /= 10;
1311         }
1312         return string(buffer);
1313     }
1314 
1315     /**
1316      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1317      */
1318     function toHexString(uint256 value) internal pure returns (string memory) {
1319         if (value == 0) {
1320             return "0x00";
1321         }
1322         uint256 temp = value;
1323         uint256 length = 0;
1324         while (temp != 0) {
1325             length++;
1326             temp >>= 8;
1327         }
1328         return toHexString(value, length);
1329     }
1330 
1331     /**
1332      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1333      */
1334     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1335         bytes memory buffer = new bytes(2 * length + 2);
1336         buffer[0] = "0";
1337         buffer[1] = "x";
1338         for (uint256 i = 2 * length + 1; i > 1; --i) {
1339             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1340             value >>= 4;
1341         }
1342         require(value == 0, "Strings: hex length insufficient");
1343         return string(buffer);
1344     }
1345 }
1346 
1347 // File: @openzeppelin/contracts/utils/Address.sol
1348 
1349 
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 /**
1354  * @dev Collection of functions related to the address type
1355  */
1356 library Address {
1357     /**
1358      * @dev Returns true if `account` is a contract.
1359      *
1360      * [IMPORTANT]
1361      * ====
1362      * It is unsafe to assume that an address for which this function returns
1363      * false is an externally-owned account (EOA) and not a contract.
1364      *
1365      * Among others, `isContract` will return false for the following
1366      * types of addresses:
1367      *
1368      *  - an externally-owned account
1369      *  - a contract in construction
1370      *  - an address where a contract will be created
1371      *  - an address where a contract lived, but was destroyed
1372      * ====
1373      */
1374     function isContract(address account) internal view returns (bool) {
1375         // This method relies on extcodesize, which returns 0 for contracts in
1376         // construction, since the code is only stored at the end of the
1377         // constructor execution.
1378 
1379         uint256 size;
1380         assembly {
1381             size := extcodesize(account)
1382         }
1383         return size > 0;
1384     }
1385 
1386     /**
1387      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1388      * `recipient`, forwarding all available gas and reverting on errors.
1389      *
1390      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1391      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1392      * imposed by `transfer`, making them unable to receive funds via
1393      * `transfer`. {sendValue} removes this limitation.
1394      *
1395      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1396      *
1397      * IMPORTANT: because control is transferred to `recipient`, care must be
1398      * taken to not create reentrancy vulnerabilities. Consider using
1399      * {ReentrancyGuard} or the
1400      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1401      */
1402     function sendValue(address payable recipient, uint256 amount) internal {
1403         require(address(this).balance >= amount, "Address: insufficient balance");
1404 
1405         (bool success, ) = recipient.call{value: amount}("");
1406         require(success, "Address: unable to send value, recipient may have reverted");
1407     }
1408 
1409     /**
1410      * @dev Performs a Solidity function call using a low level `call`. A
1411      * plain `call` is an unsafe replacement for a function call: use this
1412      * function instead.
1413      *
1414      * If `target` reverts with a revert reason, it is bubbled up by this
1415      * function (like regular Solidity function calls).
1416      *
1417      * Returns the raw returned data. To convert to the expected return value,
1418      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1419      *
1420      * Requirements:
1421      *
1422      * - `target` must be a contract.
1423      * - calling `target` with `data` must not revert.
1424      *
1425      * _Available since v3.1._
1426      */
1427     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1428         return functionCall(target, data, "Address: low-level call failed");
1429     }
1430 
1431     /**
1432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1433      * `errorMessage` as a fallback revert reason when `target` reverts.
1434      *
1435      * _Available since v3.1._
1436      */
1437     function functionCall(
1438         address target,
1439         bytes memory data,
1440         string memory errorMessage
1441     ) internal returns (bytes memory) {
1442         return functionCallWithValue(target, data, 0, errorMessage);
1443     }
1444 
1445     /**
1446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1447      * but also transferring `value` wei to `target`.
1448      *
1449      * Requirements:
1450      *
1451      * - the calling contract must have an ETH balance of at least `value`.
1452      * - the called Solidity function must be `payable`.
1453      *
1454      * _Available since v3.1._
1455      */
1456     function functionCallWithValue(
1457         address target,
1458         bytes memory data,
1459         uint256 value
1460     ) internal returns (bytes memory) {
1461         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1462     }
1463 
1464     /**
1465      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1466      * with `errorMessage` as a fallback revert reason when `target` reverts.
1467      *
1468      * _Available since v3.1._
1469      */
1470     function functionCallWithValue(
1471         address target,
1472         bytes memory data,
1473         uint256 value,
1474         string memory errorMessage
1475     ) internal returns (bytes memory) {
1476         require(address(this).balance >= value, "Address: insufficient balance for call");
1477         require(isContract(target), "Address: call to non-contract");
1478 
1479         (bool success, bytes memory returndata) = target.call{value: value}(data);
1480         return verifyCallResult(success, returndata, errorMessage);
1481     }
1482 
1483     /**
1484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1485      * but performing a static call.
1486      *
1487      * _Available since v3.3._
1488      */
1489     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1490         return functionStaticCall(target, data, "Address: low-level static call failed");
1491     }
1492 
1493     /**
1494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1495      * but performing a static call.
1496      *
1497      * _Available since v3.3._
1498      */
1499     function functionStaticCall(
1500         address target,
1501         bytes memory data,
1502         string memory errorMessage
1503     ) internal view returns (bytes memory) {
1504         require(isContract(target), "Address: static call to non-contract");
1505 
1506         (bool success, bytes memory returndata) = target.staticcall(data);
1507         return verifyCallResult(success, returndata, errorMessage);
1508     }
1509 
1510     /**
1511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1512      * but performing a delegate call.
1513      *
1514      * _Available since v3.4._
1515      */
1516     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1517         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1518     }
1519 
1520     /**
1521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1522      * but performing a delegate call.
1523      *
1524      * _Available since v3.4._
1525      */
1526     function functionDelegateCall(
1527         address target,
1528         bytes memory data,
1529         string memory errorMessage
1530     ) internal returns (bytes memory) {
1531         require(isContract(target), "Address: delegate call to non-contract");
1532 
1533         (bool success, bytes memory returndata) = target.delegatecall(data);
1534         return verifyCallResult(success, returndata, errorMessage);
1535     }
1536 
1537     /**
1538      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1539      * revert reason using the provided one.
1540      *
1541      * _Available since v4.3._
1542      */
1543     function verifyCallResult(
1544         bool success,
1545         bytes memory returndata,
1546         string memory errorMessage
1547     ) internal pure returns (bytes memory) {
1548         if (success) {
1549             return returndata;
1550         } else {
1551             // Look for revert reason and bubble it up if present
1552             if (returndata.length > 0) {
1553                 // The easiest way to bubble the revert reason is using memory via assembly
1554 
1555                 assembly {
1556                     let returndata_size := mload(returndata)
1557                     revert(add(32, returndata), returndata_size)
1558                 }
1559             } else {
1560                 revert(errorMessage);
1561             }
1562         }
1563     }
1564 }
1565 
1566 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1567 
1568 
1569 
1570 pragma solidity ^0.8.0;
1571 
1572 
1573 /**
1574  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1575  * @dev See https://eips.ethereum.org/EIPS/eip-721
1576  */
1577 interface IERC721Metadata is IERC721 {
1578     /**
1579      * @dev Returns the token collection name.
1580      */
1581     function name() external view returns (string memory);
1582 
1583     /**
1584      * @dev Returns the token collection symbol.
1585      */
1586     function symbol() external view returns (string memory);
1587 
1588     /**
1589      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1590      */
1591     function tokenURI(uint256 tokenId) external view returns (string memory);
1592 }
1593 
1594 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1595 
1596 
1597 
1598 pragma solidity ^0.8.0;
1599 
1600 /**
1601  * @title ERC721 token receiver interface
1602  * @dev Interface for any contract that wants to support safeTransfers
1603  * from ERC721 asset contracts.
1604  */
1605 interface IERC721Receiver {
1606     /**
1607      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1608      * by `operator` from `from`, this function is called.
1609      *
1610      * It must return its Solidity selector to confirm the token transfer.
1611      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1612      *
1613      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1614      */
1615     function onERC721Received(
1616         address operator,
1617         address from,
1618         uint256 tokenId,
1619         bytes calldata data
1620     ) external returns (bytes4);
1621 }
1622 
1623 
1624 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1625 pragma solidity ^0.8.0;
1626 
1627 /**
1628  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1629  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1630  * {ERC721Enumerable}.
1631  */
1632 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata{
1633 
1634     using Address for address;
1635     using Strings for uint256;
1636 
1637     // Token name
1638     string private _name;
1639 
1640     // Token symbol
1641     string private _symbol;
1642 
1643     // Mapping from token ID to owner address
1644     mapping(uint256 => address) private _owners;
1645 
1646     // Mapping owner address to token count
1647     mapping(address => uint256) private _balances;
1648 
1649     // Mapping from token ID to approved address
1650     mapping(uint256 => address) private _tokenApprovals;
1651 
1652     // Mapping from owner to operator approvals
1653     mapping(address => mapping(address => bool)) private _operatorApprovals;
1654 
1655     /**
1656      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1657      */
1658     constructor(
1659         string memory name_, 
1660         string memory symbol_
1661         ) {
1662         _name = name_;
1663         _symbol = symbol_;
1664 
1665     }
1666 
1667     
1668 
1669     /**
1670      * @dev See {IERC165-supportsInterface}.
1671      */
1672     function supportsInterface(bytes4 interfaceId)
1673         public
1674         view
1675         virtual
1676         override(ERC165, IERC165)
1677         returns (bool)
1678     {
1679         return
1680             interfaceId == type(IERC721).interfaceId ||
1681             interfaceId == type(IERC721Metadata).interfaceId ||
1682             super.supportsInterface(interfaceId);
1683     }
1684 
1685     /**
1686      * @dev See {IERC721-balanceOf}.
1687      */
1688     function balanceOf(address owner)
1689         public
1690         view
1691         virtual
1692         override
1693         returns (uint256)
1694     {
1695         require(
1696             owner != address(0),
1697             "ERC721: balance query for the zero address"
1698         );
1699         return _balances[owner];
1700     }
1701 
1702     /**
1703      * @dev See {IERC721-ownerOf}.
1704      */
1705     function ownerOf(uint256 tokenId)
1706         public
1707         view
1708         virtual
1709         override
1710         returns (address)
1711     {
1712         address owner = _owners[tokenId];
1713         require(
1714             owner != address(0),
1715             "ERC721: owner query for nonexistent token"
1716         );
1717         return owner;
1718     }
1719 
1720     /**
1721      * @dev See {IERC721Metadata-name}.
1722      */
1723     function name() public view virtual override returns (string memory) {
1724         return _name;
1725     }
1726 
1727     /**
1728      * @dev See {IERC721Metadata-symbol}.
1729      */
1730     function symbol() public view virtual override returns (string memory) {
1731         return _symbol;
1732     }
1733 
1734     /**
1735      * @dev See {IERC721Metadata-tokenURI}.
1736      */
1737     function tokenURI(uint256 tokenId)
1738         public
1739         view
1740         virtual
1741         override
1742         returns (string memory)
1743     {
1744         require(
1745             _exists(tokenId),
1746             "ERC721Metadata: URI query for nonexistent token"
1747         );
1748 
1749         string memory baseURI = _baseURI();
1750         return
1751             bytes(baseURI).length > 0
1752                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1753                 : "";
1754     }
1755 
1756     /**
1757      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1758      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1759      * by default, can be overriden in child contracts.
1760      */
1761     function _baseURI() internal view virtual returns (string memory) {
1762         return "";
1763     }
1764 
1765     /**
1766      * @dev See {IERC721-approve}.
1767      */
1768     function approve(address to, uint256 tokenId) public virtual override {
1769         address owner = ERC721.ownerOf(tokenId);
1770         require(to != owner, "ERC721: approval to current owner");
1771 
1772         require(
1773             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1774             "ERC721: approve caller is not owner nor approved for all"
1775         );
1776 
1777         _approve(to, tokenId);
1778     }
1779 
1780     /**
1781      * @dev See {IERC721-getApproved}.
1782      */
1783     function getApproved(uint256 tokenId)
1784         public
1785         view
1786         virtual
1787         override
1788         returns (address)
1789     {
1790         require(
1791             _exists(tokenId),
1792             "ERC721: approved query for nonexistent token"
1793         );
1794 
1795         return _tokenApprovals[tokenId];
1796     }
1797 
1798     /**
1799      * @dev See {IERC721-setApprovalForAll}.
1800      */
1801     function setApprovalForAll(address operator, bool approved)
1802         public
1803         virtual
1804         override
1805     {
1806         _setApprovalForAll(_msgSender(), operator, approved);
1807     }
1808 
1809     /**
1810      * @dev See {IERC721-isApprovedForAll}.
1811      */
1812     function isApprovedForAll(address owner, address operator)
1813         public
1814         view
1815         virtual
1816         override
1817         returns (bool)
1818     {
1819         return _operatorApprovals[owner][operator];
1820     }
1821 
1822     /**
1823      * @dev See {IERC721-transferFrom}.
1824      */
1825     function transferFrom(
1826         address from,
1827         address to,
1828         uint256 tokenId
1829     ) public virtual override {
1830         //solhint-disable-next-line max-line-length
1831         require(
1832             _isApprovedOrOwner(_msgSender(), tokenId),
1833             "ERC721: transfer caller is not owner nor approved"
1834         );
1835 
1836         _transfer(from, to, tokenId);
1837     }
1838 
1839     /**
1840      * @dev See {IERC721-safeTransferFrom}.
1841      */
1842     function safeTransferFrom(
1843         address from,
1844         address to,
1845         uint256 tokenId
1846     ) public virtual override {
1847         safeTransferFrom(from, to, tokenId, "");
1848     }
1849 
1850     /**
1851      * @dev See {IERC721-safeTransferFrom}.
1852      */
1853     function safeTransferFrom(
1854         address from,
1855         address to,
1856         uint256 tokenId,
1857         bytes memory _data
1858     ) public virtual override {
1859         require(
1860             _isApprovedOrOwner(_msgSender(), tokenId),
1861             "ERC721: transfer caller is not owner nor approved"
1862         );
1863         _safeTransfer(from, to, tokenId, _data);
1864     }
1865 
1866     /**
1867      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1868      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1869      *
1870      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1871      *
1872      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1873      * implement alternative mechanisms to perform token transfer, such as signature-based.
1874      *
1875      * Requirements:
1876      *
1877      * - `from` cannot be the zero address.
1878      * - `to` cannot be the zero address.
1879      * - `tokenId` token must exist and be owned by `from`.
1880      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1881      *
1882      * Emits a {Transfer} event.
1883      */
1884     function _safeTransfer(
1885         address from,
1886         address to,
1887         uint256 tokenId,
1888         bytes memory _data
1889     ) internal virtual {
1890         _transfer(from, to, tokenId);
1891         require(
1892             _checkOnERC721Received(from, to, tokenId, _data),
1893             "ERC721: transfer to non ERC721Receiver implementer"
1894         );
1895     }
1896 
1897     /**
1898      * @dev Returns whether `tokenId` exists.
1899      *
1900      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1901      *
1902      * Tokens start existing when they are minted (`_mint`),
1903      * and stop existing when they are burned (`_burn`).
1904      */
1905     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1906         return _owners[tokenId] != address(0);
1907     }
1908 
1909     /**
1910      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1911      *
1912      * Requirements:
1913      *
1914      * - `tokenId` must exist.
1915      */
1916     function _isApprovedOrOwner(address spender, uint256 tokenId)
1917         internal
1918         view
1919         virtual
1920         returns (bool)
1921     {
1922         require(
1923             _exists(tokenId),
1924             "ERC721: operator query for nonexistent token"
1925         );
1926         address owner = ERC721.ownerOf(tokenId);
1927         return (spender == owner ||
1928             getApproved(tokenId) == spender ||
1929             isApprovedForAll(owner, spender));
1930     }
1931 
1932     /**
1933      * @dev Safely mints `tokenId` and transfers it to `to`.
1934      *
1935      * Requirements:
1936      *
1937      * - `tokenId` must not exist.
1938      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1939      *
1940      * Emits a {Transfer} event.
1941      */
1942     function _safeMint(address to, uint256 tokenId) internal virtual {
1943         _safeMint(to, tokenId, "");
1944     }
1945 
1946     /**
1947      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1948      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1949      */
1950     function _safeMint(
1951         address to,
1952         uint256 tokenId,
1953         bytes memory _data
1954     ) internal virtual {
1955         _mint(to, tokenId);
1956         require(
1957             _checkOnERC721Received(address(0), to, tokenId, _data),
1958             "ERC721: transfer to non ERC721Receiver implementer"
1959         );
1960     }
1961 
1962     /**
1963      * @dev Mints `tokenId` and transfers it to `to`.
1964      *
1965      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1966      *
1967      * Requirements:
1968      *
1969      * - `tokenId` must not exist.
1970      * - `to` cannot be the zero address.
1971      *
1972      * Emits a {Transfer} event.
1973      */
1974     function _mint(address to, uint256 tokenId) internal virtual {
1975         require(to != address(0), "ERC721: mint to the zero address");
1976         require(!_exists(tokenId), "ERC721: token already minted");
1977 
1978         _beforeTokenTransfer(address(0), to, tokenId);
1979 
1980         _balances[to] += 1;
1981         _owners[tokenId] = to;
1982 
1983         emit Transfer(address(0), to, tokenId);
1984     }
1985 
1986     /**
1987      * @dev Destroys `tokenId`.
1988      * The approval is cleared when the token is burned.
1989      *
1990      * Requirements:
1991      *
1992      * - `tokenId` must exist.
1993      *
1994      * Emits a {Transfer} event.
1995      */
1996     function _burn(uint256 tokenId) internal virtual {
1997         address owner = ERC721.ownerOf(tokenId);
1998 
1999         _beforeTokenTransfer(owner, address(0), tokenId);
2000 
2001         // Clear approvals
2002         _approve(address(0), tokenId);
2003 
2004         _balances[owner] -= 1;
2005         delete _owners[tokenId];
2006 
2007         emit Transfer(owner, address(0), tokenId);
2008     }
2009 
2010     /**
2011      * @dev Transfers `tokenId` from `from` to `to`.
2012      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2013      *
2014      * Requirements:
2015      *
2016      * - `to` cannot be the zero address.
2017      * - `tokenId` token must be owned by `from`.
2018      *
2019      * Emits a {Transfer} event.
2020      */
2021     function _transfer(
2022         address from,
2023         address to,
2024         uint256 tokenId
2025     ) internal virtual {
2026         require(
2027             ERC721.ownerOf(tokenId) == from,
2028             "ERC721: transfer of token that is not own"
2029         );
2030         require(to != address(0), "ERC721: transfer to the zero address");
2031 
2032         _beforeTokenTransfer(from, to, tokenId);
2033 
2034         // Clear approvals from the previous owner
2035         _approve(address(0), tokenId);
2036 
2037         _balances[from] -= 1;
2038         _balances[to] += 1;
2039         _owners[tokenId] = to;
2040         emit Transfer(from, to, tokenId);
2041     }
2042 
2043     /**
2044      * @dev Approve `to` to operate on `tokenId`
2045      *
2046      * Emits a {Approval} event.
2047      */
2048     function _approve(address to, uint256 tokenId) internal virtual {
2049         _tokenApprovals[tokenId] = to;
2050         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2051     }
2052 
2053     /**
2054      * @dev Approve `operator` to operate on all of `owner` tokens
2055      *
2056      * Emits a {ApprovalForAll} event.
2057      */
2058     function _setApprovalForAll(
2059         address owner,
2060         address operator,
2061         bool approved
2062     ) internal virtual {
2063         require(owner != operator, "ERC721: approve to caller");
2064         _operatorApprovals[owner][operator] = approved;
2065         emit ApprovalForAll(owner, operator, approved);
2066     }
2067 
2068     /**
2069      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2070      * The call is not executed if the target address is not a contract.
2071      *
2072      * @param from address representing the previous owner of the given token ID
2073      * @param to target address that will receive the tokens
2074      * @param tokenId uint256 ID of the token to be transferred
2075      * @param _data bytes optional data to send along with the call
2076      * @return bool whether the call correctly returned the expected magic value
2077      */
2078     function _checkOnERC721Received(
2079         address from,
2080         address to,
2081         uint256 tokenId,
2082         bytes memory _data
2083     ) private returns (bool) {
2084         if (to.isContract()) {
2085             try
2086                 IERC721Receiver(to).onERC721Received(
2087                     _msgSender(),
2088                     from,
2089                     tokenId,
2090                     _data
2091                 )
2092             returns (bytes4 retval) {
2093                 return retval == IERC721Receiver.onERC721Received.selector;
2094             } catch (bytes memory reason) {
2095                 if (reason.length == 0) {
2096                     revert(
2097                         "ERC721: transfer to non ERC721Receiver implementer"
2098                     );
2099                 } else {
2100                     assembly {
2101                         revert(add(32, reason), mload(reason))
2102                     }
2103                 }
2104             }
2105         } else {
2106             return true;
2107         }
2108     }
2109 
2110     /**
2111      * @dev Hook that is called before any token transfer. This includes minting
2112      * and burning.
2113      *
2114      * Calling conditions:
2115      *
2116      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2117      * transferred to `to`.
2118      * - When `from` is zero, `tokenId` will be minted for `to`.
2119      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2120      * - `from` and `to` are never both zero.
2121      *
2122      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2123      */
2124     function _beforeTokenTransfer(
2125         address from,
2126         address to,
2127         uint256 tokenId
2128     ) internal virtual {}
2129 }
2130 
2131 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2132 
2133 
2134 
2135 
2136 
2137 
2138 // File: @openzeppelin/contracts/access/Ownable.sol
2139 pragma solidity ^0.8.0;
2140 /**
2141  * @dev Contract module which provides a basic access control mechanism, where
2142  * there is an account (an owner) that can be granted exclusive access to
2143  * specific functions.
2144  *
2145  * By default, the owner account will be the one that deploys the contract. This
2146  * can later be changed with {transferOwnership}.
2147  *
2148  * This module is used through inheritance. It will make available the modifier
2149  * `onlyOwner`, which can be applied to your functions to restrict their use to
2150  * the owner.
2151  */
2152 abstract contract Ownable is Context {
2153     address private _owner;
2154 
2155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2156 
2157     /**
2158      * @dev Initializes the contract setting the deployer as the initial owner.
2159      */
2160     constructor() {
2161         _setOwner(_msgSender());
2162     }
2163 
2164     /**
2165      * @dev Returns the address of the current owner.
2166      */
2167     function owner() public view virtual returns (address) {
2168         return _owner;
2169     }
2170 
2171     /**
2172      * @dev Throws if called by any account other than the owner.
2173      */
2174     modifier onlyOwner() {
2175         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2176         _;
2177     }
2178 
2179     /**
2180      * @dev Leaves the contract without owner. It will not be possible to call
2181      * `onlyOwner` functions anymore. Can only be called by the current owner.
2182      *
2183      * NOTE: Renouncing ownership will leave the contract without an owner,
2184      * thereby removing any functionality that is only available to the owner.
2185      */
2186     function renounceOwnership() public virtual onlyOwner {
2187         _setOwner(address(0));
2188     }
2189 
2190     /**
2191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2192      * Can only be called by the current owner.
2193      */
2194     function transferOwnership(address newOwner) public virtual onlyOwner {
2195         require(newOwner != address(0), "Ownable: new owner is the zero address");
2196         _setOwner(newOwner);
2197     }
2198 
2199     function _setOwner(address newOwner) private {
2200         address oldOwner = _owner;
2201         _owner = newOwner;
2202         emit OwnershipTransferred(oldOwner, newOwner);
2203     }
2204 }
2205 
2206 error OnlyBlackVox();
2207 error OverMaxSupply();
2208 error NonexistentToken();
2209 error InvalidInput();
2210 error ExcessMint();
2211 
2212 pragma solidity >=0.7.0 <0.9.0;
2213 
2214 abstract contract ownerdataInterface {
2215     function setChildPurpose(address _from, address _to, uint256 _tokenID, address _owner) public virtual;
2216 }
2217 
2218 //tested contract
2219 contract VOXVOT_Gen2 is ERC721, Ownable, Pausable{
2220   using Strings for uint256;
2221 
2222   string baseURI;
2223   string public baseExtension = ".json";
2224   uint256 public maxSupply = 6666;
2225   uint256 public totalSupply;
2226 
2227   //FXportal
2228   ownerdataInterface public ownerdatainterface;
2229   address mintFromAddress = address(0);
2230   address private stakingContract;
2231   address public BlindVoxAddr;
2232 
2233   constructor(
2234     string memory _name,
2235     string memory _symbol,
2236     string memory _initBaseURI,
2237     address _fxRootAddress
2238   ) ERC721(_name, _symbol) {
2239     setBaseURI(_initBaseURI);
2240     ownerdatainterface = ownerdataInterface(_fxRootAddress);
2241   }
2242 
2243   modifier onlyBlindVox(){
2244       if(msg.sender != BlindVoxAddr) revert OnlyBlackVox();
2245       _;
2246   }
2247 
2248   // internal
2249   function _baseURI() internal view virtual override returns (string memory) {
2250     return baseURI;
2251   }
2252 
2253   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override
2254   {
2255     if(msg.sender == stakingContract){
2256           ownerdatainterface.setChildPurpose(from,to,tokenId, from);
2257     } else {
2258           ownerdatainterface.setChildPurpose(from,to,tokenId, to);
2259     }
2260     super._beforeTokenTransfer(from, to, tokenId);
2261   }
2262 
2263   function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2264   {
2265     if(!_exists(tokenId)) revert NonexistentToken();
2266 
2267     string memory currentBaseURI = _baseURI();
2268     return bytes(currentBaseURI).length > 0
2269         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
2270         : "";
2271   }
2272 
2273   function openVox(address to,uint256 tokenId) public whenNotPaused onlyBlindVox {
2274     if (totalSupply + 1 > maxSupply) revert ExcessMint();
2275     totalSupply += 1;
2276     _safeMint(to, tokenId);
2277   }
2278 
2279   //-----only owner-----
2280   function setBaseURI(string memory _newBaseURI) public onlyOwner {
2281     baseURI = _newBaseURI;
2282   }
2283 
2284   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
2285     baseExtension = _newBaseExtension;
2286   }
2287 
2288   function setMaxSupply (uint256 _newSupply) external onlyOwner {
2289       if(_newSupply > maxSupply) revert InvalidInput();
2290       maxSupply = _newSupply;
2291   }
2292 
2293   function setStakingContractAddr (address _newAddr) external onlyOwner {
2294       stakingContract = _newAddr;
2295   }
2296 
2297   function setBlindVoxAddr(address _newAddr) public onlyOwner{
2298       BlindVoxAddr = _newAddr;
2299   }
2300 
2301   function pause() external onlyOwner 
2302   {
2303 	_pause();
2304   }
2305 
2306 	function unpause() external onlyOwner 
2307   {
2308 	_unpause();
2309   }
2310 }