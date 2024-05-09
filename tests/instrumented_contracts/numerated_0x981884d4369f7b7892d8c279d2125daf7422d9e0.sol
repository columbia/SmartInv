1 
2 // File: ../../mosaic-contracts/contracts/lib/CircularBufferUint.sol
3 
4 pragma solidity ^0.5.0;
5 
6 // Copyright 2019 OpenST Ltd.
7 //
8 // Licensed under the Apache License, Version 2.0 (the "License");
9 // you may not use this file except in compliance with the License.
10 // You may obtain a copy of the License at
11 //
12 //    http://www.apache.org/licenses/LICENSE-2.0
13 //
14 // Unless required by applicable law or agreed to in writing, software
15 // distributed under the License is distributed on an "AS IS" BASIS,
16 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
17 // See the License for the specific language governing permissions and
18 // limitations under the License.
19 //
20 // ----------------------------------------------------------------------------
21 //
22 // http://www.simpletoken.org/
23 //
24 // ----------------------------------------------------------------------------
25 
26 /**
27  * @title Circular buffer for `uint`s.
28  *
29  * @notice This contract represents a circular buffer that stores `uint`s. When
30  *         a set number of `uint`s have been stored, the storage starts
31  *         overwriting older entries. It overwrites always the oldest entry in
32  *         the buffer.
33  */
34 contract CircularBufferUint {
35 
36     /* Storage */
37 
38     /**
39      * The circular buffer that stores the latest `items.length` items. Once
40      * `items.length` items were stored, items will be overwritten starting at
41      * zero.
42      */
43     uint256[] private items;
44 
45     /**
46      * The current index in the items array. The index increases up to
47      * `items.length - 1` and then resets to zero in an endless loop. This
48      * means that a new item will always overwrite the oldest item.
49      */
50     uint256 private index;
51 
52 
53     /* Constructor */
54 
55     /**
56      * @notice Create a new buffer with the size `_maxItems`.
57      *
58      * @param _maxItems Defines how many items this buffer stores before
59      *                  overwriting older items.
60      */
61     constructor(uint256 _maxItems) public {
62         require(
63             _maxItems > 0,
64             "The max number of items to store in a circular buffer must be greater than 0."
65         );
66 
67         items.length = _maxItems;
68     }
69 
70 
71     /* Internal functions */
72 
73     /**
74      * @notice Store a new item in the circular buffer.
75      *
76      * @param _item The item to store in the circular buffer.
77      *
78      * @return overwrittenItem_ The item that was in the circular buffer's
79      *                          position where the new item is now stored. The
80      *                          overwritten item is no longer available in the
81      *                          circular buffer.
82      */
83     function store(uint256 _item) internal returns(uint256 overwrittenItem_) {
84         nextIndex();
85 
86         /*
87          * Retrieve the old item from the circular buffer before overwriting it
88          * with the new item.
89          */
90         overwrittenItem_ = items[index];
91         items[index] = _item;
92     }
93 
94     /**
95      * @notice Get the most recent item that was stored in the circular buffer.
96      *
97      * @return head_ The most recently stored item.
98      */
99     function head() internal view returns(uint256 head_) {
100         head_ = items[index];
101     }
102 
103 
104     /* Private functions */
105 
106     /**
107      * @notice Updates the index of the circular buffer to point to the next
108      *         slot of where to store an item. Resets to zero if it gets to the
109      *         end of the array that represents the circular.
110      */
111     function nextIndex() private {
112         index++;
113         if (index == items.length) {
114             index = 0;
115         }
116     }
117 }
118 
119 // File: ../../mosaic-contracts/contracts/lib/RLP.sol
120 
121 pragma solidity ^0.5.0;
122 
123 /**
124 * @title RLPReader
125 *
126 * RLPReader is used to read and parse RLP encoded data in memory.
127 *
128 * @author Andreas Olofsson (androlo1980@gmail.com)
129 */
130 library RLP {
131 
132     /** Constants */
133     uint constant DATA_SHORT_START = 0x80;
134     uint constant DATA_LONG_START = 0xB8;
135     uint constant LIST_SHORT_START = 0xC0;
136     uint constant LIST_LONG_START = 0xF8;
137 
138     uint constant DATA_LONG_OFFSET = 0xB7;
139     uint constant LIST_LONG_OFFSET = 0xF7;
140 
141     /** Storage */
142     struct RLPItem {
143         uint _unsafe_memPtr;    // Pointer to the RLP-encoded bytes.
144         uint _unsafe_length;    // Number of bytes. This is the full length of the string.
145     }
146 
147     struct Iterator {
148         RLPItem _unsafe_item;   // Item that's being iterated over.
149         uint _unsafe_nextPtr;   // Position of the next item in the list.
150     }
151 
152     /* Internal Functions */
153 
154     /** Iterator */
155 
156     function next(
157         Iterator memory self
158     )
159         internal
160         pure
161         returns (RLPItem memory subItem_)
162     {
163         require(hasNext(self));
164         uint ptr = self._unsafe_nextPtr;
165         uint itemLength = _itemLength(ptr);
166         subItem_._unsafe_memPtr = ptr;
167         subItem_._unsafe_length = itemLength;
168         self._unsafe_nextPtr = ptr + itemLength;
169     }
170 
171     function next(
172         Iterator memory self,
173         bool strict
174     )
175         internal
176         pure
177         returns (RLPItem memory subItem_)
178     {
179         subItem_ = next(self);
180         require(!(strict && !_validate(subItem_)));
181     }
182 
183     function hasNext(Iterator memory self) internal pure returns (bool) {
184         RLPItem memory item = self._unsafe_item;
185         return self._unsafe_nextPtr < item._unsafe_memPtr + item._unsafe_length;
186     }
187 
188     /** RLPItem */
189 
190     /**
191     *  @dev Creates an RLPItem from an array of RLP encoded bytes.
192     *
193     *  @param self The RLP encoded bytes.
194     *
195     *  @return An RLPItem.
196     */
197     function toRLPItem(
198         bytes memory self
199     )
200         internal
201         pure
202         returns (RLPItem memory)
203     {
204         uint len = self.length;
205         if (len == 0) {
206             return RLPItem(0, 0);
207         }
208         uint memPtr;
209 
210         /* solium-disable-next-line */
211         assembly {
212             memPtr := add(self, 0x20)
213         }
214 
215         return RLPItem(memPtr, len);
216     }
217 
218     /**
219     *  @dev Creates an RLPItem from an array of RLP encoded bytes.
220     *
221     *  @param self The RLP encoded bytes.
222     *  @param strict Will throw if the data is not RLP encoded.
223     *
224     *  @return An RLPItem.
225     */
226     function toRLPItem(
227         bytes memory self,
228         bool strict
229     )
230         internal
231         pure
232         returns (RLPItem memory)
233     {
234         RLPItem memory item = toRLPItem(self);
235         if(strict) {
236             uint len = self.length;
237             require(_payloadOffset(item) <= len);
238             require(_itemLength(item._unsafe_memPtr) == len);
239             require(_validate(item));
240         }
241         return item;
242     }
243 
244     /**
245     *  @dev Check if the RLP item is null.
246     *
247     *  @param self The RLP item.
248     *
249     *  @return 'true' if the item is null.
250     */
251     function isNull(RLPItem memory self) internal pure returns (bool ret) {
252         return self._unsafe_length == 0;
253     }
254 
255     /**
256     *  @dev Check if the RLP item is a list.
257     *
258     *  @param self The RLP item.
259     *
260     *  @return 'true' if the item is a list.
261     */
262     function isList(RLPItem memory self) internal pure returns (bool ret) {
263         if (self._unsafe_length == 0) {
264             return false;
265         }
266         uint memPtr = self._unsafe_memPtr;
267 
268         /* solium-disable-next-line */
269         assembly {
270             ret := iszero(lt(byte(0, mload(memPtr)), 0xC0))
271         }
272     }
273 
274     /**
275     *  @dev Check if the RLP item is data.
276     *
277     *  @param self The RLP item.
278     *
279     *  @return 'true' if the item is data.
280     */
281     function isData(RLPItem memory self) internal pure returns (bool ret) {
282         if (self._unsafe_length == 0) {
283             return false;
284         }
285         uint memPtr = self._unsafe_memPtr;
286 
287         /* solium-disable-next-line */
288         assembly {
289             ret := lt(byte(0, mload(memPtr)), 0xC0)
290         }
291     }
292 
293     /**
294     *  @dev Check if the RLP item is empty (string or list).
295     *
296     *  @param self The RLP item.
297     *
298     *  @return 'true' if the item is null.
299     */
300     function isEmpty(RLPItem memory self) internal pure returns (bool ret) {
301         if(isNull(self)) {
302             return false;
303         }
304         uint b0;
305         uint memPtr = self._unsafe_memPtr;
306 
307         /* solium-disable-next-line */
308         assembly {
309             b0 := byte(0, mload(memPtr))
310         }
311         return (b0 == DATA_SHORT_START || b0 == LIST_SHORT_START);
312     }
313 
314     /**
315     *  @dev Get the number of items in an RLP encoded list.
316     *
317     *  @param self The RLP item.
318     *
319     *  @return The number of items.
320     */
321     function items(RLPItem memory self) internal pure returns (uint) {
322         if (!isList(self)) {
323             return 0;
324         }
325         uint b0;
326         uint memPtr = self._unsafe_memPtr;
327 
328         /* solium-disable-next-line */
329         assembly {
330             b0 := byte(0, mload(memPtr))
331         }
332         uint pos = memPtr + _payloadOffset(self);
333         uint last = memPtr + self._unsafe_length - 1;
334         uint itms;
335         while(pos <= last) {
336             pos += _itemLength(pos);
337             itms++;
338         }
339         return itms;
340     }
341 
342     /**
343     *  @dev Create an iterator.
344     *
345     *  @param self The RLP item.
346     *
347     *  @return An 'Iterator' over the item.
348     */
349     function iterator(
350         RLPItem memory self
351     )
352         internal
353         pure
354         returns (Iterator memory it_)
355     {
356         require (isList(self));
357         uint ptr = self._unsafe_memPtr + _payloadOffset(self);
358         it_._unsafe_item = self;
359         it_._unsafe_nextPtr = ptr;
360     }
361 
362     /**
363     *  @dev Return the RLP encoded bytes.
364     *
365     *  @param self The RLPItem.
366     *
367     *  @return The bytes.
368     */
369     function toBytes(
370         RLPItem memory self
371     )
372         internal
373         pure
374         returns (bytes memory bts_)
375     {
376         uint len = self._unsafe_length;
377         if (len == 0) {
378             return bts_;
379         }
380         bts_ = new bytes(len);
381         _copyToBytes(self._unsafe_memPtr, bts_, len);
382     }
383 
384     /**
385     *  @dev Decode an RLPItem into bytes. This will not work if the RLPItem is a list.
386     *
387     *  @param self The RLPItem.
388     *
389     *  @return The decoded string.
390     */
391     function toData(
392         RLPItem memory self
393     )
394         internal
395         pure
396         returns (bytes memory bts_)
397     {
398         require(isData(self));
399         uint rStartPos;
400         uint len;
401         (rStartPos, len) = _decode(self);
402         bts_ = new bytes(len);
403         _copyToBytes(rStartPos, bts_, len);
404     }
405 
406     /**
407     *  @dev Get the list of sub-items from an RLP encoded list.
408     *       Warning: This is inefficient, as it requires that the list is read twice.
409     *
410     *  @param self The RLP item.
411     *
412     *  @return Array of RLPItems.
413     */
414     function toList(
415         RLPItem memory self
416     )
417         internal
418         pure
419         returns (RLPItem[] memory list_)
420     {
421         require(isList(self));
422         uint numItems = items(self);
423         list_ = new RLPItem[](numItems);
424         Iterator memory it = iterator(self);
425         uint idx = 0;
426         while(hasNext(it)) {
427             list_[idx] = next(it);
428             idx++;
429         }
430     }
431 
432     /**
433     *  @dev Decode an RLPItem into an ascii string. This will not work if the
434     *       RLPItem is a list.
435     *
436     *  @param self The RLPItem.
437     *
438     *  @return The decoded string.
439     */
440     function toAscii(
441         RLPItem memory self
442     )
443         internal
444         pure
445         returns (string memory str_)
446     {
447         require(isData(self));
448         uint rStartPos;
449         uint len;
450         (rStartPos, len) = _decode(self);
451         bytes memory bts = new bytes(len);
452         _copyToBytes(rStartPos, bts, len);
453         str_ = string(bts);
454     }
455 
456     /**
457     *  @dev Decode an RLPItem into a uint. This will not work if the
458     *  RLPItem is a list.
459     *
460     *  @param self The RLPItem.
461     *
462     *  @return The decoded string.
463     */
464     function toUint(RLPItem memory self) internal pure returns (uint data_) {
465         require(isData(self));
466         uint rStartPos;
467         uint len;
468         (rStartPos, len) = _decode(self);
469         if (len > 32 || len == 0) {
470             revert();
471         }
472 
473         /* solium-disable-next-line */
474         assembly {
475             data_ := div(mload(rStartPos), exp(256, sub(32, len)))
476         }
477     }
478 
479     /**
480     *  @dev Decode an RLPItem into a boolean. This will not work if the
481     *       RLPItem is a list.
482     *
483     *  @param self The RLPItem.
484     *
485     *  @return The decoded string.
486     */
487     function toBool(RLPItem memory self) internal pure returns (bool data) {
488         require(isData(self));
489         uint rStartPos;
490         uint len;
491         (rStartPos, len) = _decode(self);
492         require(len == 1);
493         uint temp;
494 
495         /* solium-disable-next-line */
496         assembly {
497             temp := byte(0, mload(rStartPos))
498         }
499         require (temp <= 1);
500 
501         return temp == 1 ? true : false;
502     }
503 
504     /**
505     *  @dev Decode an RLPItem into a byte. This will not work if the
506     *       RLPItem is a list.
507     *
508     *  @param self The RLPItem.
509     *
510     *  @return The decoded string.
511     */
512     function toByte(RLPItem memory self) internal pure returns (byte data) {
513         require(isData(self));
514         uint rStartPos;
515         uint len;
516         (rStartPos, len) = _decode(self);
517         require(len == 1);
518         uint temp;
519 
520         /* solium-disable-next-line */
521         assembly {
522             temp := byte(0, mload(rStartPos))
523         }
524 
525         return byte(uint8(temp));
526     }
527 
528     /**
529     *  @dev Decode an RLPItem into an int. This will not work if the
530     *       RLPItem is a list.
531     *
532     *  @param self The RLPItem.
533     *
534     *  @return The decoded string.
535     */
536     function toInt(RLPItem memory self) internal pure returns (int data) {
537         return int(toUint(self));
538     }
539 
540     /**
541     *  @dev Decode an RLPItem into a bytes32. This will not work if the
542     *       RLPItem is a list.
543     *
544     *  @param self The RLPItem.
545     *
546     *  @return The decoded string.
547     */
548     function toBytes32(
549         RLPItem memory self
550     )
551         internal
552         pure
553         returns (bytes32 data)
554     {
555         return bytes32(toUint(self));
556     }
557 
558     /**
559     *  @dev Decode an RLPItem into an address. This will not work if the
560     *       RLPItem is a list.
561     *
562     *  @param self The RLPItem.
563     *
564     *  @return The decoded string.
565     */
566     function toAddress(
567         RLPItem memory self
568     )
569         internal
570         pure
571         returns (address data)
572     {
573         require(isData(self));
574         uint rStartPos;
575         uint len;
576         (rStartPos, len) = _decode(self);
577         require (len == 20);
578 
579         /* solium-disable-next-line */
580         assembly {
581             data := div(mload(rStartPos), exp(256, 12))
582         }
583     }
584 
585     /**
586     *  @dev Decode an RLPItem into an address. This will not work if the
587     *       RLPItem is a list.
588     *
589     *  @param self The RLPItem.
590     *
591     *  @return Get the payload offset.
592     */
593     function _payloadOffset(RLPItem memory self) private pure returns (uint) {
594         if(self._unsafe_length == 0)
595             return 0;
596         uint b0;
597         uint memPtr = self._unsafe_memPtr;
598 
599         /* solium-disable-next-line */
600         assembly {
601             b0 := byte(0, mload(memPtr))
602         }
603         if(b0 < DATA_SHORT_START)
604             return 0;
605         if(b0 < DATA_LONG_START || (b0 >= LIST_SHORT_START && b0 < LIST_LONG_START))
606             return 1;
607         if(b0 < LIST_SHORT_START)
608             return b0 - DATA_LONG_OFFSET + 1;
609         return b0 - LIST_LONG_OFFSET + 1;
610     }
611 
612     /**
613     *  @dev Decode an RLPItem into an address. This will not work if the
614     *       RLPItem is a list.
615     *
616     *  @param memPtr Memory pointer.
617     *
618     *  @return Get the full length of an RLP item.
619     */
620     function _itemLength(uint memPtr) private pure returns (uint len) {
621         uint b0;
622 
623         /* solium-disable-next-line */
624         assembly {
625             b0 := byte(0, mload(memPtr))
626         }
627         if (b0 < DATA_SHORT_START) {
628             len = 1;
629         } else if (b0 < DATA_LONG_START) {
630             len = b0 - DATA_SHORT_START + 1;
631         } else if (b0 < LIST_SHORT_START) {
632             /* solium-disable-next-line */
633             assembly {
634                 let bLen := sub(b0, 0xB7) // bytes length (DATA_LONG_OFFSET)
635                 let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
636                 len := add(1, add(bLen, dLen)) // total length
637             }
638         } else if (b0 < LIST_LONG_START) {
639             len = b0 - LIST_SHORT_START + 1;
640         } else {
641             /* solium-disable-next-line */
642             assembly {
643                 let bLen := sub(b0, 0xF7) // bytes length (LIST_LONG_OFFSET)
644                 let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
645                 len := add(1, add(bLen, dLen)) // total length
646             }
647         }
648     }
649 
650     /**
651     *  @dev Decode an RLPItem into an address. This will not work if the
652     *       RLPItem is a list.
653     *
654     *  @param self The RLPItem.
655     *
656     *  @return Get the full length of an RLP item.
657     */
658     function _decode(
659         RLPItem memory self
660     )
661         private
662         pure
663         returns (uint memPtr_, uint len_)
664     {
665         require(isData(self));
666         uint b0;
667         uint start = self._unsafe_memPtr;
668 
669         /* solium-disable-next-line */
670         assembly {
671             b0 := byte(0, mload(start))
672         }
673         if (b0 < DATA_SHORT_START) {
674             memPtr_ = start;
675             len_ = 1;
676 
677             return (memPtr_, len_);
678         }
679         if (b0 < DATA_LONG_START) {
680             len_ = self._unsafe_length - 1;
681             memPtr_ = start + 1;
682         } else {
683             uint bLen;
684 
685             /* solium-disable-next-line */
686             assembly {
687                 bLen := sub(b0, 0xB7) // DATA_LONG_OFFSET
688             }
689             len_ = self._unsafe_length - 1 - bLen;
690             memPtr_ = start + bLen + 1;
691         }
692     }
693 
694     /**
695     *  @dev Assumes that enough memory has been allocated to store in target.
696     *       Gets the full length of an RLP item.
697     *
698     *  @param btsPtr Bytes pointer.
699     *  @param tgt Last item to be allocated.
700     *  @param btsLen Bytes length.
701     */
702     function _copyToBytes(
703         uint btsPtr,
704         bytes memory tgt,
705         uint btsLen
706     )
707         private
708         pure
709     {
710         // Exploiting the fact that 'tgt' was the last thing to be allocated,
711         // we can write entire words, and just overwrite any excess.
712         /* solium-disable-next-line */
713         assembly {
714                 let i := 0 // Start at arr + 0x20
715                 let stopOffset := add(btsLen, 31)
716                 let rOffset := btsPtr
717                 let wOffset := add(tgt, 32)
718                 for {} lt(i, stopOffset) { i := add(i, 32) }
719                 {
720                     mstore(add(wOffset, i), mload(add(rOffset, i)))
721                 }
722         }
723     }
724 
725     /**
726     *  @dev Check that an RLP item is valid.
727     *
728     *  @param self The RLPItem.
729     */
730     function _validate(RLPItem memory self) private pure returns (bool ret) {
731         // Check that RLP is well-formed.
732         uint b0;
733         uint b1;
734         uint memPtr = self._unsafe_memPtr;
735 
736         /* solium-disable-next-line */
737         assembly {
738             b0 := byte(0, mload(memPtr))
739             b1 := byte(1, mload(memPtr))
740         }
741         if(b0 == DATA_SHORT_START + 1 && b1 < DATA_SHORT_START)
742             return false;
743         return true;
744     }
745 }
746 
747 // File: ../../mosaic-contracts/contracts/lib/MerklePatriciaProof.sol
748 
749 pragma solidity ^0.5.0;
750 /**
751  * @title MerklePatriciaVerifier
752  * @author Sam Mayo (sammayo888@gmail.com)
753  *
754  * @dev Library for verifing merkle patricia proofs.
755  */
756 
757 
758 library MerklePatriciaProof {
759     /**
760      * @dev Verifies a merkle patricia proof.
761      * @param value The terminating value in the trie.
762      * @param encodedPath The path in the trie leading to value.
763      * @param rlpParentNodes The rlp encoded stack of nodes.
764      * @param root The root hash of the trie.
765      * @return The boolean validity of the proof.
766      */
767     function verify(
768         bytes32 value,
769         bytes calldata encodedPath,
770         bytes calldata rlpParentNodes,
771         bytes32 root
772     )
773         external
774         pure
775         returns (bool)
776     {
777         RLP.RLPItem memory item = RLP.toRLPItem(rlpParentNodes);
778         RLP.RLPItem[] memory parentNodes = RLP.toList(item);
779 
780         bytes memory currentNode;
781         RLP.RLPItem[] memory currentNodeList;
782 
783         bytes32 nodeKey = root;
784         uint pathPtr = 0;
785 
786         bytes memory path = _getNibbleArray2(encodedPath);
787         if(path.length == 0) {return false;}
788 
789         for (uint i=0; i<parentNodes.length; i++) {
790             if(pathPtr > path.length) {return false;}
791 
792             currentNode = RLP.toBytes(parentNodes[i]);
793             if(nodeKey != keccak256(abi.encodePacked(currentNode))) {return false;}
794             currentNodeList = RLP.toList(parentNodes[i]);
795 
796             if(currentNodeList.length == 17) {
797                 if(pathPtr == path.length) {
798                     if(keccak256(abi.encodePacked(RLP.toBytes(currentNodeList[16]))) == value) {
799                         return true;
800                     } else {
801                         return false;
802                     }
803                 }
804 
805                 uint8 nextPathNibble = uint8(path[pathPtr]);
806                 if(nextPathNibble > 16) {return false;}
807                 nodeKey = RLP.toBytes32(currentNodeList[nextPathNibble]);
808                 pathPtr += 1;
809             } else if(currentNodeList.length == 2) {
810 
811                 // Count of matching node key nibbles in path starting from pathPtr.
812                 uint traverseLength = _nibblesToTraverse(RLP.toData(currentNodeList[0]), path, pathPtr);
813 
814                 if(pathPtr + traverseLength == path.length) { //leaf node
815                     if(keccak256(abi.encodePacked(RLP.toData(currentNodeList[1]))) == value) {
816                         return true;
817                     } else {
818                         return false;
819                     }
820                 } else if (traverseLength == 0) { // error: couldn't traverse path
821                     return false;
822                 } else { // extension node
823                     pathPtr += traverseLength;
824                     nodeKey = RLP.toBytes32(currentNodeList[1]);
825                 }
826 
827             } else {
828                 return false;
829             }
830         }
831     }
832 
833     function verifyDebug(
834         bytes32 value,
835         bytes memory not_encodedPath,
836         bytes memory rlpParentNodes,
837         bytes32 root
838     )
839         public
840         pure
841         returns (bool res_, uint loc_, bytes memory path_debug_)
842     {
843         RLP.RLPItem memory item = RLP.toRLPItem(rlpParentNodes);
844         RLP.RLPItem[] memory parentNodes = RLP.toList(item);
845 
846         bytes memory currentNode;
847         RLP.RLPItem[] memory currentNodeList;
848 
849         bytes32 nodeKey = root;
850         uint pathPtr = 0;
851 
852         bytes memory path = _getNibbleArray2(not_encodedPath);
853         path_debug_ = path;
854         if(path.length == 0) {
855             loc_ = 0;
856             res_ = false;
857             return (res_, loc_, path_debug_);
858         }
859 
860         for (uint i=0; i<parentNodes.length; i++) {
861             if(pathPtr > path.length) {
862                 loc_ = 1;
863                 res_ = false;
864                 return (res_, loc_, path_debug_);
865             }
866 
867             currentNode = RLP.toBytes(parentNodes[i]);
868             if(nodeKey != keccak256(abi.encodePacked(currentNode))) {
869                 res_ = false;
870                 loc_ = 100 + i;
871                 return (res_, loc_, path_debug_);
872             }
873             currentNodeList = RLP.toList(parentNodes[i]);
874 
875             loc_ = currentNodeList.length;
876 
877             if(currentNodeList.length == 17) {
878                 if(pathPtr == path.length) {
879                     if(keccak256(abi.encodePacked(RLP.toBytes(currentNodeList[16]))) == value) {
880                         res_ = true;
881                         return (res_, loc_, path_debug_);
882                     } else {
883                         loc_ = 3;
884                         return (res_, loc_, path_debug_);
885                     }
886                 }
887 
888                 uint8 nextPathNibble = uint8(path[pathPtr]);
889                 if(nextPathNibble > 16) {
890                     loc_ = 4;
891                     return (res_, loc_, path_debug_);
892                 }
893                 nodeKey = RLP.toBytes32(currentNodeList[nextPathNibble]);
894                 pathPtr += 1;
895             } else if(currentNodeList.length == 2) {
896                 pathPtr += _nibblesToTraverse(RLP.toData(currentNodeList[0]), path, pathPtr);
897 
898                 if(pathPtr == path.length) {//leaf node
899                     if(keccak256(abi.encodePacked(RLP.toData(currentNodeList[1]))) == value) {
900                         res_ = true;
901                         return (res_, loc_, path_debug_);
902                     } else {
903                         loc_ = 5;
904                         return (res_, loc_, path_debug_);
905                     }
906                 }
907                 //extension node
908                 if(_nibblesToTraverse(RLP.toData(currentNodeList[0]), path, pathPtr) == 0) {
909                     loc_ = 6;
910                     res_ = (keccak256(abi.encodePacked()) == value);
911                     return (res_, loc_, path_debug_);
912                 }
913 
914                 nodeKey = RLP.toBytes32(currentNodeList[1]);
915             } else {
916                 loc_ = 7;
917                 return (res_, loc_, path_debug_);
918             }
919         }
920 
921         loc_ = 8;
922     }
923 
924     function _nibblesToTraverse(
925         bytes memory encodedPartialPath,
926         bytes memory path,
927         uint pathPtr
928     )
929         private
930         pure
931         returns (uint len_)
932     {
933         // encodedPartialPath has elements that are each two hex characters (1 byte), but partialPath
934         // and slicedPath have elements that are each one hex character (1 nibble)
935         bytes memory partialPath = _getNibbleArray(encodedPartialPath);
936         bytes memory slicedPath = new bytes(partialPath.length);
937 
938         // pathPtr counts nibbles in path
939         // partialPath.length is a number of nibbles
940         for(uint i=pathPtr; i<pathPtr+partialPath.length; i++) {
941             byte pathNibble = path[i];
942             slicedPath[i-pathPtr] = pathNibble;
943         }
944 
945         if(keccak256(abi.encodePacked(partialPath)) == keccak256(abi.encodePacked(slicedPath))) {
946             len_ = partialPath.length;
947         } else {
948             len_ = 0;
949         }
950     }
951 
952     // bytes b must be hp encoded
953     function _getNibbleArray(
954         bytes memory b
955     )
956         private
957         pure
958         returns (bytes memory nibbles_)
959     {
960         if(b.length>0) {
961             uint8 offset;
962             uint8 hpNibble = uint8(_getNthNibbleOfBytes(0,b));
963             if(hpNibble == 1 || hpNibble == 3) {
964                 nibbles_ = new bytes(b.length*2-1);
965                 byte oddNibble = _getNthNibbleOfBytes(1,b);
966                 nibbles_[0] = oddNibble;
967                 offset = 1;
968             } else {
969                 nibbles_ = new bytes(b.length*2-2);
970                 offset = 0;
971             }
972 
973             for(uint i=offset; i<nibbles_.length; i++) {
974                 nibbles_[i] = _getNthNibbleOfBytes(i-offset+2,b);
975             }
976         }
977     }
978 
979     // normal byte array, no encoding used
980     function _getNibbleArray2(
981         bytes memory b
982     )
983         private
984         pure
985         returns (bytes memory nibbles_)
986     {
987         nibbles_ = new bytes(b.length*2);
988         for (uint i = 0; i < nibbles_.length; i++) {
989             nibbles_[i] = _getNthNibbleOfBytes(i, b);
990         }
991     }
992 
993     function _getNthNibbleOfBytes(
994         uint n,
995         bytes memory str
996     )
997         private
998         pure returns (byte)
999     {
1000         return byte(n%2==0 ? uint8(str[n/2])/0x10 : uint8(str[n/2])%0x10);
1001     }
1002 }
1003 
1004 // File: ../../mosaic-contracts/contracts/lib/OrganizationInterface.sol
1005 
1006 pragma solidity ^0.5.0;
1007 
1008 // Copyright 2019 OpenST Ltd.
1009 //
1010 // Licensed under the Apache License, Version 2.0 (the "License");
1011 // you may not use this file except in compliance with the License.
1012 // You may obtain a copy of the License at
1013 //
1014 //    http://www.apache.org/licenses/LICENSE-2.0
1015 //
1016 // Unless required by applicable law or agreed to in writing, software
1017 // distributed under the License is distributed on an "AS IS" BASIS,
1018 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1019 // See the License for the specific language governing permissions and
1020 // limitations under the License.
1021 //
1022 // ----------------------------------------------------------------------------
1023 //
1024 // http://www.simpletoken.org/
1025 //
1026 // ----------------------------------------------------------------------------
1027 
1028 /**
1029  *  @title OrganizationInterface provides methods to check if an address is
1030  *         currently registered as an active participant in the organization.
1031  */
1032 interface OrganizationInterface {
1033 
1034     /**
1035      * @notice Checks if an address is currently registered as the organization.
1036      *
1037      * @param _organization Address to check.
1038      *
1039      * @return isOrganization_ True if the given address represents the
1040      *                         organization. Returns false otherwise.
1041      */
1042     function isOrganization(
1043         address _organization
1044     )
1045         external
1046         view
1047         returns (bool isOrganization_);
1048 
1049     /**
1050      * @notice Checks if an address is currently registered as an active worker.
1051      *
1052      * @param _worker Address to check.
1053      *
1054      * @return isWorker_ True if the given address is a registered, active
1055      *                   worker. Returns false otherwise.
1056      */
1057     function isWorker(address _worker) external view returns (bool isWorker_);
1058 
1059 }
1060 
1061 // File: ../../mosaic-contracts/contracts/lib/Organized.sol
1062 
1063 pragma solidity ^0.5.0;
1064 
1065 // Copyright 2019 OpenST Ltd.
1066 //
1067 // Licensed under the Apache License, Version 2.0 (the "License");
1068 // you may not use this file except in compliance with the License.
1069 // You may obtain a copy of the License at
1070 //
1071 //    http://www.apache.org/licenses/LICENSE-2.0
1072 //
1073 // Unless required by applicable law or agreed to in writing, software
1074 // distributed under the License is distributed on an "AS IS" BASIS,
1075 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1076 // See the License for the specific language governing permissions and
1077 // limitations under the License.
1078 //
1079 // ----------------------------------------------------------------------------
1080 //
1081 // http://www.simpletoken.org/
1082 //
1083 // ----------------------------------------------------------------------------
1084 
1085 
1086 /**
1087  * @title Organized contract.
1088  *
1089  * @notice The Organized contract facilitates integration of
1090  *         organization administration keys with different contracts.
1091  */
1092 contract Organized {
1093 
1094 
1095     /* Storage */
1096 
1097     /** Organization which holds all the keys needed to administer the economy. */
1098     OrganizationInterface public organization;
1099 
1100 
1101     /* Modifiers */
1102 
1103     modifier onlyOrganization()
1104     {
1105         require(
1106             organization.isOrganization(msg.sender),
1107             "Only the organization is allowed to call this method."
1108         );
1109 
1110         _;
1111     }
1112 
1113     modifier onlyWorker()
1114     {
1115         require(
1116             organization.isWorker(msg.sender),
1117             "Only whitelisted workers are allowed to call this method."
1118         );
1119 
1120         _;
1121     }
1122 
1123 
1124     /* Constructor */
1125 
1126     /**
1127      * @notice Sets the address of the organization contract.
1128      *
1129      * @param _organization A contract that manages worker keys.
1130      */
1131     constructor(OrganizationInterface _organization) public {
1132         require(
1133             address(_organization) != address(0),
1134             "Organization contract address must not be zero."
1135         );
1136 
1137         organization = _organization;
1138     }
1139 
1140 }
1141 
1142 // File: ../../mosaic-contracts/contracts/lib/SafeMath.sol
1143 
1144 pragma solidity ^0.5.0;
1145 
1146 // Copyright 2019 OpenST Ltd.
1147 //
1148 // Licensed under the Apache License, Version 2.0 (the "License");
1149 // you may not use this file except in compliance with the License.
1150 // You may obtain a copy of the License at
1151 //
1152 //    http://www.apache.org/licenses/LICENSE-2.0
1153 //
1154 // Unless required by applicable law or agreed to in writing, software
1155 // distributed under the License is distributed on an "AS IS" BASIS,
1156 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1157 // See the License for the specific language governing permissions and
1158 // limitations under the License.
1159 // 
1160 // ----------------------------------------------------------------------------
1161 //
1162 // http://www.simpletoken.org/
1163 //
1164 // Based on the SafeMath library by the OpenZeppelin team.
1165 // Copyright (c) 2018 Smart Contract Solutions, Inc.
1166 // https://github.com/OpenZeppelin/zeppelin-solidity
1167 // The MIT License.
1168 // ----------------------------------------------------------------------------
1169 
1170 
1171 /**
1172  * @title SafeMath library.
1173  *
1174  * @notice Based on the SafeMath library by the OpenZeppelin team.
1175  *
1176  * @dev Math operations with safety checks that revert on error.
1177  */
1178 library SafeMath {
1179 
1180     /* Internal Functions */
1181 
1182     /**
1183      * @notice Multiplies two numbers, reverts on overflow.
1184      *
1185      * @param a Unsigned integer multiplicand.
1186      * @param b Unsigned integer multiplier.
1187      *
1188      * @return uint256 Product.
1189      */
1190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1191         /*
1192          * Gas optimization: this is cheaper than requiring 'a' not being zero,
1193          * but the benefit is lost if 'b' is also tested.
1194          * See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1195          */
1196         if (a == 0) {
1197             return 0;
1198         }
1199 
1200         uint256 c = a * b;
1201         require(
1202             c / a == b,
1203             "Overflow when multiplying."
1204         );
1205 
1206         return c;
1207     }
1208 
1209     /**
1210      * @notice Integer division of two numbers truncating the quotient, reverts
1211      *         on division by zero.
1212      *
1213      * @param a Unsigned integer dividend.
1214      * @param b Unsigned integer divisor.
1215      *
1216      * @return uint256 Quotient.
1217      */
1218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1219         // Solidity only automatically asserts when dividing by 0.
1220         require(
1221             b > 0,
1222             "Cannot do attempted division by less than or equal to zero."
1223         );
1224         uint256 c = a / b;
1225 
1226         // There is no case in which the following doesn't hold:
1227         // assert(a == b * c + a % b);
1228 
1229         return c;
1230     }
1231 
1232     /**
1233      * @notice Subtracts two numbers, reverts on underflow (i.e. if subtrahend
1234      *         is greater than minuend).
1235      *
1236      * @param a Unsigned integer minuend.
1237      * @param b Unsigned integer subtrahend.
1238      *
1239      * @return uint256 Difference.
1240      */
1241     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1242         require(
1243             b <= a,
1244             "Underflow when subtracting."
1245         );
1246         uint256 c = a - b;
1247 
1248         return c;
1249     }
1250 
1251     /**
1252      * @notice Adds two numbers, reverts on overflow.
1253      *
1254      * @param a Unsigned integer augend.
1255      * @param b Unsigned integer addend.
1256      *
1257      * @return uint256 Sum.
1258      */
1259     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1260         uint256 c = a + b;
1261         require(
1262             c >= a,
1263             "Overflow when adding."
1264         );
1265 
1266         return c;
1267     }
1268 
1269     /**
1270      * @notice Divides two numbers and returns the remainder (unsigned integer
1271      *         modulo), reverts when dividing by zero.
1272      *
1273      * @param a Unsigned integer dividend.
1274      * @param b Unsigned integer divisor.
1275      *
1276      * @return uint256 Remainder.
1277      */
1278     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1279         require(
1280             b != 0,
1281             "Cannot do attempted division by zero (in `mod()`)."
1282         );
1283 
1284         return a % b;
1285     }
1286 }
1287 
1288 // File: ../../mosaic-contracts/contracts/lib/StateRootInterface.sol
1289 
1290 pragma solidity ^0.5.0;
1291 
1292 // Copyright 2019 OpenST Ltd.
1293 //
1294 // Licensed under the Apache License, Version 2.0 (the "License");
1295 // you may not use this file except in compliance with the License.
1296 // You may obtain a copy of the License at
1297 //
1298 //    http://www.apache.org/licenses/LICENSE-2.0
1299 //
1300 // Unless required by applicable law or agreed to in writing, software
1301 // distributed under the License is distributed on an "AS IS" BASIS,
1302 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1303 // See the License for the specific language governing permissions and
1304 // limitations under the License.
1305 //
1306 // ----------------------------------------------------------------------------
1307 //
1308 // http://www.simpletoken.org/
1309 //
1310 // ----------------------------------------------------------------------------
1311 
1312 /** @title An interface to an get state root. */
1313 interface StateRootInterface {
1314 
1315     /**
1316      * @notice Gets the block number of latest committed state root.
1317      *
1318      * @return height_ Block height of the latest committed state root.
1319      */
1320     function getLatestStateRootBlockHeight()
1321         external
1322         view
1323         returns (uint256 height_);
1324 
1325     /**
1326      * @notice Get the state root for the given block height.
1327      *
1328      * @param _blockHeight The block height for which the state root is fetched.
1329      *
1330      * @return bytes32 State root at the given height.
1331      */
1332     function getStateRoot(uint256 _blockHeight)
1333         external
1334         view
1335         returns (bytes32 stateRoot_);
1336 
1337 }
1338 
1339 // File: ../../mosaic-contracts/contracts/anchor/Anchor.sol
1340 
1341 pragma solidity ^0.5.0;
1342 
1343 // Copyright 2019 OpenST Ltd.
1344 //
1345 // Licensed under the Apache License, Version 2.0 (the "License");
1346 // you may not use this file except in compliance with the License.
1347 // You may obtain a copy of the License at
1348 //
1349 //    http://www.apache.org/licenses/LICENSE-2.0
1350 //
1351 // Unless required by applicable law or agreed to in writing, software
1352 // distributed under the License is distributed on an "AS IS" BASIS,
1353 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1354 // See the License for the specific language governing permissions and
1355 // limitations under the License.
1356 //
1357 // ----------------------------------------------------------------------------
1358 //
1359 // http://www.simpletoken.org/
1360 //
1361 // ----------------------------------------------------------------------------
1362 
1363 
1364 
1365 
1366 
1367 
1368 
1369 
1370 /**
1371  * @title Anchor contract which implements StateRootInterface.
1372  *
1373  * @notice Anchor stores another chain's state roots. It stores the address of
1374  *         the co-anchor, which will be the anchor on the other chain. State
1375  *         roots are exchanged bidirectionally between the anchor and the
1376  *         co-anchor by the organization.
1377  */
1378 contract Anchor is StateRootInterface, Organized, CircularBufferUint {
1379 
1380     /* Usings */
1381 
1382     using SafeMath for uint256;
1383 
1384 
1385     /* Events */
1386 
1387     event StateRootAvailable(uint256 _blockHeight, bytes32 _stateRoot);
1388 
1389 
1390     /* Storage */
1391 
1392     /** Maps block heights to their respective state root. */
1393     mapping (uint256 => bytes32) private stateRoots;
1394 
1395     /**
1396      * The remote chain ID is the remote chain id where anchor contract is
1397      * deployed.
1398      */
1399     uint256 private remoteChainId;
1400 
1401     /** Address of the anchor on the auxiliary chain. Can be zero. */
1402     address public coAnchor;
1403 
1404 
1405     /*  Constructor */
1406 
1407     /**
1408      * @notice Contract constructor.
1409      *
1410      * @param _remoteChainId The chain id of the chain that is tracked by this
1411      *                       anchor.
1412      * @param _blockHeight Block height at which _stateRoot needs to store.
1413      * @param _stateRoot State root hash of given _blockHeight.
1414      * @param _maxStateRoots The max number of state roots to store in the
1415      *                       circular buffer.
1416      * @param _organization Address of an organization contract.
1417      */
1418     constructor(
1419         uint256 _remoteChainId,
1420         uint256 _blockHeight,
1421         bytes32 _stateRoot,
1422         uint256 _maxStateRoots,
1423         OrganizationInterface _organization
1424     )
1425         Organized(_organization)
1426         CircularBufferUint(_maxStateRoots)
1427         public
1428     {
1429         require(
1430             _remoteChainId != 0,
1431             "Remote chain Id must not be 0."
1432         );
1433 
1434         remoteChainId = _remoteChainId;
1435 
1436         stateRoots[_blockHeight] = _stateRoot;
1437         CircularBufferUint.store(_blockHeight);
1438     }
1439 
1440 
1441     /* External functions */
1442 
1443     /**
1444      *  @notice The Co-Anchor address is the address of the anchor that is
1445      *          deployed on the other (origin/auxiliary) chain.
1446      *
1447      *  @param _coAnchor Address of the Co-Anchor on auxiliary.
1448      */
1449     function setCoAnchorAddress(address _coAnchor)
1450         external
1451         onlyOrganization
1452         returns (bool success_)
1453     {
1454 
1455         require(
1456             _coAnchor != address(0),
1457             "Co-Anchor address must not be 0."
1458         );
1459 
1460         require(
1461             coAnchor == address(0),
1462             "Co-Anchor has already been set and cannot be updated."
1463         );
1464 
1465         coAnchor = _coAnchor;
1466 
1467         success_ = true;
1468     }
1469 
1470     /**
1471      * @notice Get the state root for the given block height.
1472      *
1473      * @param _blockHeight The block height for which the state root is needed.
1474      *
1475      * @return bytes32 State root of the given height.
1476      */
1477     function getStateRoot(
1478         uint256 _blockHeight
1479     )
1480         external
1481         view
1482         returns (bytes32 stateRoot_)
1483     {
1484         stateRoot_ = stateRoots[_blockHeight];
1485     }
1486 
1487     /**
1488      * @notice Gets the block height of latest anchored state root.
1489      *
1490      * @return uint256 Block height of the latest anchored state root.
1491      */
1492     function getLatestStateRootBlockHeight()
1493         external
1494         view
1495         returns (uint256 height_)
1496     {
1497         height_ = CircularBufferUint.head();
1498     }
1499 
1500     /**
1501      *  @notice External function anchorStateRoot.
1502      *
1503      *  @dev anchorStateRoot Called from game process.
1504      *       Anchor new state root for a block height.
1505      *
1506      *  @param _blockHeight Block height for which stateRoots mapping needs to
1507      *                      update.
1508      *  @param _stateRoot State root of input block height.
1509      *
1510      *  @return bytes32 stateRoot
1511      */
1512     function anchorStateRoot(
1513         uint256 _blockHeight,
1514         bytes32 _stateRoot
1515     )
1516         external
1517         onlyOrganization
1518         returns (bool success_)
1519     {
1520         // State root should be valid
1521         require(
1522             _stateRoot != bytes32(0),
1523             "State root must not be zero."
1524         );
1525 
1526         // Input block height should be valid.
1527         require(
1528             _blockHeight > CircularBufferUint.head(),
1529             "Given block height is lower or equal to highest anchored state root block height."
1530         );
1531 
1532         stateRoots[_blockHeight] = _stateRoot;
1533         uint256 oldestStoredBlockHeight = CircularBufferUint.store(_blockHeight);
1534         delete stateRoots[oldestStoredBlockHeight];
1535 
1536         emit StateRootAvailable(_blockHeight, _stateRoot);
1537 
1538         success_ = true;
1539     }
1540 
1541     /**
1542      *  @notice Get the remote chain id of this anchor.
1543      *
1544      *  @return remoteChainId_ The remote chain id.
1545      */
1546     function getRemoteChainId()
1547         external
1548         view
1549         returns (uint256 remoteChainId_)
1550     {
1551         remoteChainId_ = remoteChainId;
1552     }
1553 }
