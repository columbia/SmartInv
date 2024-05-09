1 pragma solidity ^0.4.8;
2 
3 
4 /**
5 * @title RLPReader
6 *
7 * RLPReader is used to read and parse RLP encoded data in memory.
8 *
9 * @author Andreas Olofsson (androlo1980@gmail.com)
10 */
11 library RLP {
12 
13  uint constant DATA_SHORT_START = 0x80;
14  uint constant DATA_LONG_START = 0xB8;
15  uint constant LIST_SHORT_START = 0xC0;
16  uint constant LIST_LONG_START = 0xF8;
17 
18  uint constant DATA_LONG_OFFSET = 0xB7;
19  uint constant LIST_LONG_OFFSET = 0xF7;
20 
21 
22  struct RLPItem {
23      uint _unsafe_memPtr;    // Pointer to the RLP-encoded bytes.
24      uint _unsafe_length;    // Number of bytes. This is the full length of the string.
25  }
26 
27  struct Iterator {
28      RLPItem _unsafe_item;   // Item that's being iterated over.
29      uint _unsafe_nextPtr;   // Position of the next item in the list.
30  }
31 
32  /* Iterator */
33 
34  function next(Iterator memory self) internal constant returns (RLPItem memory subItem) {
35      if(hasNext(self)) {
36          var ptr = self._unsafe_nextPtr;
37          var itemLength = _itemLength(ptr);
38          subItem._unsafe_memPtr = ptr;
39          subItem._unsafe_length = itemLength;
40          self._unsafe_nextPtr = ptr + itemLength;
41      }
42      else
43          throw;
44  }
45 
46  function next(Iterator memory self, bool strict) internal constant returns (RLPItem memory subItem) {
47      subItem = next(self);
48      if(strict && !_validate(subItem))
49          throw;
50      return;
51  }
52 
53  function hasNext(Iterator memory self) internal constant returns (bool) {
54      var item = self._unsafe_item;
55      return self._unsafe_nextPtr < item._unsafe_memPtr + item._unsafe_length;
56  }
57 
58  /* RLPItem */
59 
60  /// @dev Creates an RLPItem from an array of RLP encoded bytes.
61  /// @param self The RLP encoded bytes.
62  /// @return An RLPItem
63  function toRLPItem(bytes memory self) internal constant returns (RLPItem memory) {
64      uint len = self.length;
65      if (len == 0) {
66          return RLPItem(0, 0);
67      }
68      uint memPtr;
69      assembly {
70          memPtr := add(self, 0x20)
71      }
72      return RLPItem(memPtr, len);
73  }
74 
75  /// @dev Creates an RLPItem from an array of RLP encoded bytes.
76  /// @param self The RLP encoded bytes.
77  /// @param strict Will throw if the data is not RLP encoded.
78  /// @return An RLPItem
79  function toRLPItem(bytes memory self, bool strict) internal constant returns (RLPItem memory) {
80      var item = toRLPItem(self);
81      if(strict) {
82          uint len = self.length;
83          if(_payloadOffset(item) > len)
84              throw;
85          if(_itemLength(item._unsafe_memPtr) != len)
86              throw;
87          if(!_validate(item))
88              throw;
89      }
90      return item;
91  }
92 
93  /// @dev Check if the RLP item is null.
94  /// @param self The RLP item.
95  /// @return 'true' if the item is null.
96  function isNull(RLPItem memory self) internal constant returns (bool ret) {
97      return self._unsafe_length == 0;
98  }
99 
100  /// @dev Check if the RLP item is a list.
101  /// @param self The RLP item.
102  /// @return 'true' if the item is a list.
103  function isList(RLPItem memory self) internal constant returns (bool ret) {
104      if (self._unsafe_length == 0)
105          return false;
106      uint memPtr = self._unsafe_memPtr;
107      assembly {
108          ret := iszero(lt(byte(0, mload(memPtr)), 0xC0))
109      }
110  }
111 
112  /// @dev Check if the RLP item is data.
113  /// @param self The RLP item.
114  /// @return 'true' if the item is data.
115  function isData(RLPItem memory self) internal constant returns (bool ret) {
116      if (self._unsafe_length == 0)
117          return false;
118      uint memPtr = self._unsafe_memPtr;
119      assembly {
120          ret := lt(byte(0, mload(memPtr)), 0xC0)
121      }
122  }
123 
124  /// @dev Check if the RLP item is empty (string or list).
125  /// @param self The RLP item.
126  /// @return 'true' if the item is null.
127  function isEmpty(RLPItem memory self) internal constant returns (bool ret) {
128      if(isNull(self))
129          return false;
130      uint b0;
131      uint memPtr = self._unsafe_memPtr;
132      assembly {
133          b0 := byte(0, mload(memPtr))
134      }
135      return (b0 == DATA_SHORT_START || b0 == LIST_SHORT_START);
136  }
137 
138  /// @dev Get the number of items in an RLP encoded list.
139  /// @param self The RLP item.
140  /// @return The number of items.
141  function items(RLPItem memory self) internal constant returns (uint) {
142      if (!isList(self))
143          return 0;
144      uint b0;
145      uint memPtr = self._unsafe_memPtr;
146      assembly {
147          b0 := byte(0, mload(memPtr))
148      }
149      uint pos = memPtr + _payloadOffset(self);
150      uint last = memPtr + self._unsafe_length - 1;
151      uint itms;
152      while(pos <= last) {
153          pos += _itemLength(pos);
154          itms++;
155      }
156      return itms;
157  }
158 
159  /// @dev Create an iterator.
160  /// @param self The RLP item.
161  /// @return An 'Iterator' over the item.
162  function iterator(RLPItem memory self) internal constant returns (Iterator memory it) {
163      if (!isList(self))
164          throw;
165      uint ptr = self._unsafe_memPtr + _payloadOffset(self);
166      it._unsafe_item = self;
167      it._unsafe_nextPtr = ptr;
168  }
169 
170  /// @dev Return the RLP encoded bytes.
171  /// @param self The RLPItem.
172  /// @return The bytes.
173  function toBytes(RLPItem memory self) internal constant returns (bytes memory bts) {
174      var len = self._unsafe_length;
175      if (len == 0)
176          return;
177      bts = new bytes(len);
178      _copyToBytes(self._unsafe_memPtr, bts, len);
179  }
180 
181  /// @dev Decode an RLPItem into bytes. This will not work if the
182  /// RLPItem is a list.
183  /// @param self The RLPItem.
184  /// @return The decoded string.
185  function toData(RLPItem memory self) internal constant returns (bytes memory bts) {
186      if(!isData(self))
187          throw;
188      var (rStartPos, len) = _decode(self);
189      bts = new bytes(len);
190      _copyToBytes(rStartPos, bts, len);
191  }
192 
193  /// @dev Get the list of sub-items from an RLP encoded list.
194  /// Warning: This is inefficient, as it requires that the list is read twice.
195  /// @param self The RLP item.
196  /// @return Array of RLPItems.
197  function toList(RLPItem memory self) internal constant returns (RLPItem[] memory list) {
198      if(!isList(self))
199          throw;
200      var numItems = items(self);
201      list = new RLPItem[](numItems);
202      var it = iterator(self);
203      uint idx;
204      while(hasNext(it)) {
205          list[idx] = next(it);
206          idx++;
207      }
208  }
209 
210  /// @dev Decode an RLPItem into an ascii string. This will not work if the
211  /// RLPItem is a list.
212  /// @param self The RLPItem.
213  /// @return The decoded string.
214  function toAscii(RLPItem memory self) internal constant returns (string memory str) {
215      if(!isData(self))
216          throw;
217      var (rStartPos, len) = _decode(self);
218      bytes memory bts = new bytes(len);
219      _copyToBytes(rStartPos, bts, len);
220      str = string(bts);
221  }
222 
223  /// @dev Decode an RLPItem into a uint. This will not work if the
224  /// RLPItem is a list.
225  /// @param self The RLPItem.
226  /// @return The decoded string.
227  function toUint(RLPItem memory self) internal constant returns (uint data) {
228      if(!isData(self))
229          throw;
230      var (rStartPos, len) = _decode(self);
231      if (len > 32 || len == 0)
232          throw;
233      assembly {
234          data := div(mload(rStartPos), exp(256, sub(32, len)))
235      }
236  }
237 
238  /// @dev Decode an RLPItem into a boolean. This will not work if the
239  /// RLPItem is a list.
240  /// @param self The RLPItem.
241  /// @return The decoded string.
242  function toBool(RLPItem memory self) internal constant returns (bool data) {
243      if(!isData(self))
244          throw;
245      var (rStartPos, len) = _decode(self);
246      if (len != 1)
247          throw;
248      uint temp;
249      assembly {
250          temp := byte(0, mload(rStartPos))
251      }
252      if (temp > 1)
253          throw;
254      return temp == 1 ? true : false;
255  }
256 
257  /// @dev Decode an RLPItem into a byte. This will not work if the
258  /// RLPItem is a list.
259  /// @param self The RLPItem.
260  /// @return The decoded string.
261  function toByte(RLPItem memory self) internal constant returns (byte data) {
262      if(!isData(self))
263          throw;
264      var (rStartPos, len) = _decode(self);
265      if (len != 1)
266          throw;
267      uint temp;
268      assembly {
269          temp := byte(0, mload(rStartPos))
270      }
271      return byte(temp);
272  }
273 
274  /// @dev Decode an RLPItem into an int. This will not work if the
275  /// RLPItem is a list.
276  /// @param self The RLPItem.
277  /// @return The decoded string.
278  function toInt(RLPItem memory self) internal constant returns (int data) {
279      return int(toUint(self));
280  }
281 
282  /// @dev Decode an RLPItem into a bytes32. This will not work if the
283  /// RLPItem is a list.
284  /// @param self The RLPItem.
285  /// @return The decoded string.
286  function toBytes32(RLPItem memory self) internal constant returns (bytes32 data) {
287      return bytes32(toUint(self));
288  }
289 
290  /// @dev Decode an RLPItem into an address. This will not work if the
291  /// RLPItem is a list.
292  /// @param self The RLPItem.
293  /// @return The decoded string.
294  function toAddress(RLPItem memory self) internal constant returns (address data) {
295      if(!isData(self))
296          throw;
297      var (rStartPos, len) = _decode(self);
298      if (len != 20)
299          throw;
300      assembly {
301          data := div(mload(rStartPos), exp(256, 12))
302      }
303  }
304 
305  // Get the payload offset.
306  function _payloadOffset(RLPItem memory self) private constant returns (uint) {
307      if(self._unsafe_length == 0)
308          return 0;
309      uint b0;
310      uint memPtr = self._unsafe_memPtr;
311      assembly {
312          b0 := byte(0, mload(memPtr))
313      }
314      if(b0 < DATA_SHORT_START)
315          return 0;
316      if(b0 < DATA_LONG_START || (b0 >= LIST_SHORT_START && b0 < LIST_LONG_START))
317          return 1;
318      if(b0 < LIST_SHORT_START)
319          return b0 - DATA_LONG_OFFSET + 1;
320      return b0 - LIST_LONG_OFFSET + 1;
321  }
322 
323  // Get the full length of an RLP item.
324  function _itemLength(uint memPtr) private constant returns (uint len) {
325      uint b0;
326      assembly {
327          b0 := byte(0, mload(memPtr))
328      }
329      if (b0 < DATA_SHORT_START)
330          len = 1;
331      else if (b0 < DATA_LONG_START)
332          len = b0 - DATA_SHORT_START + 1;
333      else if (b0 < LIST_SHORT_START) {
334          assembly {
335              let bLen := sub(b0, 0xB7) // bytes length (DATA_LONG_OFFSET)
336              let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
337              len := add(1, add(bLen, dLen)) // total length
338          }
339      }
340      else if (b0 < LIST_LONG_START)
341          len = b0 - LIST_SHORT_START + 1;
342      else {
343          assembly {
344              let bLen := sub(b0, 0xF7) // bytes length (LIST_LONG_OFFSET)
345              let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
346              len := add(1, add(bLen, dLen)) // total length
347          }
348      }
349  }
350 
351  // Get start position and length of the data.
352  function _decode(RLPItem memory self) private constant returns (uint memPtr, uint len) {
353      if(!isData(self))
354          throw;
355      uint b0;
356      uint start = self._unsafe_memPtr;
357      assembly {
358          b0 := byte(0, mload(start))
359      }
360      if (b0 < DATA_SHORT_START) {
361          memPtr = start;
362          len = 1;
363          return;
364      }
365      if (b0 < DATA_LONG_START) {
366          len = self._unsafe_length - 1;
367          memPtr = start + 1;
368      } else {
369          uint bLen;
370          assembly {
371              bLen := sub(b0, 0xB7) // DATA_LONG_OFFSET
372          }
373          len = self._unsafe_length - 1 - bLen;
374          memPtr = start + bLen + 1;
375      }
376      return;
377  }
378 
379  // Assumes that enough memory has been allocated to store in target.
380  function _copyToBytes(uint btsPtr, bytes memory tgt, uint btsLen) private constant {
381      // Exploiting the fact that 'tgt' was the last thing to be allocated,
382      // we can write entire words, and just overwrite any excess.
383      assembly {
384          {
385                  let i := 0 // Start at arr + 0x20
386                  let words := div(add(btsLen, 31), 32)
387                  let rOffset := btsPtr
388                  let wOffset := add(tgt, 0x20)
389              tag_loop:
390                  jumpi(end, eq(i, words))
391                  {
392                      let offset := mul(i, 0x20)
393                      mstore(add(wOffset, offset), mload(add(rOffset, offset)))
394                      i := add(i, 1)
395                  }
396                  jump(tag_loop)
397              end:
398                  mstore(add(tgt, add(0x20, mload(tgt))), 0)
399          }
400      }
401  }
402 
403      // Check that an RLP item is valid.
404      function _validate(RLPItem memory self) private constant returns (bool ret) {
405          // Check that RLP is well-formed.
406          uint b0;
407          uint b1;
408          uint memPtr = self._unsafe_memPtr;
409          assembly {
410              b0 := byte(0, mload(memPtr))
411              b1 := byte(1, mload(memPtr))
412          }
413          if(b0 == DATA_SHORT_START + 1 && b1 < DATA_SHORT_START)
414              return false;
415          return true;
416      }
417 }
418 
419 
420 contract RLPReaderTest {
421 
422     using RLP for RLP.RLPItem;
423     using RLP for RLP.Iterator;
424     using RLP for bytes;
425 
426     function RLPReaderTest() {}
427 
428     function testItemStrict(bytes rlp) constant returns (bool res) {
429         res = true;
430         rlp.toRLPItem(true);
431     }
432 
433     function testFirst(bytes rlp) constant returns (uint memPtr, uint len, byte first) {
434         var item = rlp.toRLPItem();
435         memPtr = item._unsafe_memPtr;
436         len = item._unsafe_length;
437         uint b0;
438         assembly {
439             b0 := byte(0, mload(memPtr))
440         }
441         first = byte(b0);
442     }
443 
444     function testIsList(bytes rlp) constant returns (bool ret) {
445         ret = rlp.toRLPItem().isList();
446     }
447 
448     function testIsData(bytes rlp) constant returns (bool ret) {
449         ret = rlp.toRLPItem().isData();
450     }
451 
452     function testIsNull(bytes rlp) constant returns (bool ret) {
453         ret = rlp.toRLPItem().isNull();
454     }
455 
456     function testIsEmpty(bytes rlp) constant returns (bool ret) {
457         ret = rlp.toRLPItem().isEmpty();
458     }
459 
460     function testItems(bytes rlp) constant returns (uint) {
461         return rlp.toRLPItem().items();
462     }
463 
464     function testSubItem(bytes rlp, uint index) constant returns (uint memPtr, uint len, bool isList, uint[] list, uint listLen) {
465         var it = rlp.toRLPItem().iterator();
466         uint idx;
467         while(it.hasNext() && idx < index) {
468             it.next();
469             idx++;
470         }
471        var si = it.next();
472        return _testItem(si);
473     }
474 
475     function testToData(bytes rlp) constant returns (bytes memory bts) {
476         bts = rlp.toRLPItem().toData();
477     }
478 
479     function testToUint(bytes rlp) constant returns (uint) {
480         return rlp.toRLPItem().toUint();
481     }
482 
483     function testToInt(bytes rlp) constant returns (int) {
484         return rlp.toRLPItem().toInt();
485     }
486 
487     function testToBytes32(bytes rlp) constant returns (bytes32) {
488         return rlp.toRLPItem().toBytes32();
489     }
490 
491     function testToAddress(bytes rlp) constant returns (address) {
492         return rlp.toRLPItem().toAddress();
493     }
494 
495     function testToByte(bytes rlp) constant returns (byte) {
496         return rlp.toRLPItem().toByte();
497     }
498 
499     function testToBool(bytes rlp) constant returns (bool) {
500         return rlp.toRLPItem().toBool();
501     }
502 
503     function _testItem(RLP.RLPItem item) internal constant returns (uint memPtr, uint len, bool isList, uint[] memory list, uint listLen) {
504         memPtr = item._unsafe_memPtr;
505         len = item._unsafe_length;
506         isList = item.isList();
507 
508         if (isList) {
509             uint i;
510             listLen = item.items();
511             list = new uint[](listLen);
512             var it = item.iterator();
513             while(it.hasNext() && i < listLen) {
514                 var si = it.next();
515                 uint ptr;
516                 assembly {
517                     ptr := mload(si)
518                 }
519                 list[i] = ptr;
520                 i++;
521             }
522         }
523     }
524     
525     function testItem(bytes rlp) constant returns (uint memPtr, uint len, bool isList, uint[] list, uint listLen) {
526         var item = rlp.toRLPItem();
527         return _testItem(item);
528     }
529     
530     function getItem(bytes rlp, uint itemIndex) constant returns(uint) {
531         var it = rlp.toRLPItem().iterator();        
532         uint idx;
533         while(it.hasNext() && idx < itemIndex) {
534             it.next();                    
535             idx++;
536         }
537 
538         
539         return it.next().toUint();
540     }
541     
542 }
543 
544 
545     
546 
547 
548 contract SHA3_512 {
549     function SHA3_512() {}
550 
551     function keccak_f(uint[25] A) constant internal returns(uint[25]) {
552         uint[5] memory C;
553         uint[5] memory D;
554         uint x;
555         uint y;
556         //uint D_0; uint D_1; uint D_2; uint D_3; uint D_4;
557         uint[25] memory B;
558         
559         uint[24] memory RC= [
560                    uint(0x0000000000000001),
561                    0x0000000000008082,
562                    0x800000000000808A,
563                    0x8000000080008000,
564                    0x000000000000808B,
565                    0x0000000080000001,
566                    0x8000000080008081,
567                    0x8000000000008009,
568                    0x000000000000008A,
569                    0x0000000000000088,
570                    0x0000000080008009,
571                    0x000000008000000A,
572                    0x000000008000808B,
573                    0x800000000000008B,
574                    0x8000000000008089,
575                    0x8000000000008003,
576                    0x8000000000008002,
577                    0x8000000000000080,
578                    0x000000000000800A,
579                    0x800000008000000A,
580                    0x8000000080008081,
581                    0x8000000000008080,
582                    0x0000000080000001,
583                    0x8000000080008008 ];
584         
585         for( uint i = 0 ; i < 24 ; i++ ) {
586             /*
587             for( x = 0 ; x < 5 ; x++ ) {
588                 C[x] = A[5*x]^A[5*x+1]^A[5*x+2]^A[5*x+3]^A[5*x+4];                
589             }*/
590                        
591             C[0]=A[0]^A[1]^A[2]^A[3]^A[4];
592             C[1]=A[5]^A[6]^A[7]^A[8]^A[9];
593             C[2]=A[10]^A[11]^A[12]^A[13]^A[14];
594             C[3]=A[15]^A[16]^A[17]^A[18]^A[19];
595             C[4]=A[20]^A[21]^A[22]^A[23]^A[24];
596 
597             /*
598             for( x = 0 ; x < 5 ; x++ ) {
599                 D[x] = C[(x+4)%5]^((C[(x+1)%5] * 2)&0xffffffffffffffff | (C[(x+1)%5]/(2**63)));
600             }*/
601                         
602             
603             D[0]=C[4] ^ ((C[1] * 2)&0xffffffffffffffff | (C[1] / (2 ** 63)));
604             D[1]=C[0] ^ ((C[2] * 2)&0xffffffffffffffff | (C[2] / (2 ** 63)));
605             D[2]=C[1] ^ ((C[3] * 2)&0xffffffffffffffff | (C[3] / (2 ** 63)));
606             D[3]=C[2] ^ ((C[4] * 2)&0xffffffffffffffff | (C[4] / (2 ** 63)));
607             D[4]=C[3] ^ ((C[0] * 2)&0xffffffffffffffff | (C[0] / (2 ** 63)));
608 
609             /*
610             for( x = 0 ; x < 5 ; x++ ) {
611                 for( y = 0 ; y < 5 ; y++ ) {
612                     A[5*x+y] = A[5*x+y] ^ D[x];
613                 }            
614             }*/
615             
616 
617             
618             A[0]=A[0] ^ D[0];
619             A[1]=A[1] ^ D[0];
620             A[2]=A[2] ^ D[0];
621             A[3]=A[3] ^ D[0];
622             A[4]=A[4] ^ D[0];
623             A[5]=A[5] ^ D[1];
624             A[6]=A[6] ^ D[1];
625             A[7]=A[7] ^ D[1];
626             A[8]=A[8] ^ D[1];
627             A[9]=A[9] ^ D[1];
628             A[10]=A[10] ^ D[2];
629             A[11]=A[11] ^ D[2];
630             A[12]=A[12] ^ D[2];
631             A[13]=A[13] ^ D[2];
632             A[14]=A[14] ^ D[2];
633             A[15]=A[15] ^ D[3];
634             A[16]=A[16] ^ D[3];
635             A[17]=A[17] ^ D[3];
636             A[18]=A[18] ^ D[3];
637             A[19]=A[19] ^ D[3];
638             A[20]=A[20] ^ D[4];
639             A[21]=A[21] ^ D[4];
640             A[22]=A[22] ^ D[4];
641             A[23]=A[23] ^ D[4];
642             A[24]=A[24] ^ D[4];
643 
644             /*Rho and pi steps*/            
645             B[0]=A[0];
646             B[8]=((A[1] * (2 ** 36))&0xffffffffffffffff | (A[1] / (2 ** 28)));
647             B[11]=((A[2] * (2 ** 3))&0xffffffffffffffff | (A[2] / (2 ** 61)));
648             B[19]=((A[3] * (2 ** 41))&0xffffffffffffffff | (A[3] / (2 ** 23)));
649             B[22]=((A[4] * (2 ** 18))&0xffffffffffffffff | (A[4] / (2 ** 46)));
650             B[2]=((A[5] * (2 ** 1))&0xffffffffffffffff | (A[5] / (2 ** 63)));
651             B[5]=((A[6] * (2 ** 44))&0xffffffffffffffff | (A[6] / (2 ** 20)));
652             B[13]=((A[7] * (2 ** 10))&0xffffffffffffffff | (A[7] / (2 ** 54)));
653             B[16]=((A[8] * (2 ** 45))&0xffffffffffffffff | (A[8] / (2 ** 19)));
654             B[24]=((A[9] * (2 ** 2))&0xffffffffffffffff | (A[9] / (2 ** 62)));
655             B[4]=((A[10] * (2 ** 62))&0xffffffffffffffff | (A[10] / (2 ** 2)));
656             B[7]=((A[11] * (2 ** 6))&0xffffffffffffffff | (A[11] / (2 ** 58)));
657             B[10]=((A[12] * (2 ** 43))&0xffffffffffffffff | (A[12] / (2 ** 21)));
658             B[18]=((A[13] * (2 ** 15))&0xffffffffffffffff | (A[13] / (2 ** 49)));
659             B[21]=((A[14] * (2 ** 61))&0xffffffffffffffff | (A[14] / (2 ** 3)));
660             B[1]=((A[15] * (2 ** 28))&0xffffffffffffffff | (A[15] / (2 ** 36)));
661             B[9]=((A[16] * (2 ** 55))&0xffffffffffffffff | (A[16] / (2 ** 9)));
662             B[12]=((A[17] * (2 ** 25))&0xffffffffffffffff | (A[17] / (2 ** 39)));
663             B[15]=((A[18] * (2 ** 21))&0xffffffffffffffff | (A[18] / (2 ** 43)));
664             B[23]=((A[19] * (2 ** 56))&0xffffffffffffffff | (A[19] / (2 ** 8)));
665             B[3]=((A[20] * (2 ** 27))&0xffffffffffffffff | (A[20] / (2 ** 37)));
666             B[6]=((A[21] * (2 ** 20))&0xffffffffffffffff | (A[21] / (2 ** 44)));
667             B[14]=((A[22] * (2 ** 39))&0xffffffffffffffff | (A[22] / (2 ** 25)));
668             B[17]=((A[23] * (2 ** 8))&0xffffffffffffffff | (A[23] / (2 ** 56)));
669             B[20]=((A[24] * (2 ** 14))&0xffffffffffffffff | (A[24] / (2 ** 50)));
670 
671             /*Xi state*/
672             /*
673             for( x = 0 ; x < 5 ; x++ ) {
674                 for( y = 0 ; y < 5 ; y++ ) {
675                     A[5*x+y] = B[5*x+y]^((~B[5*((x+1)%5)+y]) & B[5*((x+2)%5)+y]);
676                 }
677             }*/
678             
679             
680             A[0]=B[0]^((~B[5]) & B[10]);
681             A[1]=B[1]^((~B[6]) & B[11]);
682             A[2]=B[2]^((~B[7]) & B[12]);
683             A[3]=B[3]^((~B[8]) & B[13]);
684             A[4]=B[4]^((~B[9]) & B[14]);
685             A[5]=B[5]^((~B[10]) & B[15]);
686             A[6]=B[6]^((~B[11]) & B[16]);
687             A[7]=B[7]^((~B[12]) & B[17]);
688             A[8]=B[8]^((~B[13]) & B[18]);
689             A[9]=B[9]^((~B[14]) & B[19]);
690             A[10]=B[10]^((~B[15]) & B[20]);
691             A[11]=B[11]^((~B[16]) & B[21]);
692             A[12]=B[12]^((~B[17]) & B[22]);
693             A[13]=B[13]^((~B[18]) & B[23]);
694             A[14]=B[14]^((~B[19]) & B[24]);
695             A[15]=B[15]^((~B[20]) & B[0]);
696             A[16]=B[16]^((~B[21]) & B[1]);
697             A[17]=B[17]^((~B[22]) & B[2]);
698             A[18]=B[18]^((~B[23]) & B[3]);
699             A[19]=B[19]^((~B[24]) & B[4]);
700             A[20]=B[20]^((~B[0]) & B[5]);
701             A[21]=B[21]^((~B[1]) & B[6]);
702             A[22]=B[22]^((~B[2]) & B[7]);
703             A[23]=B[23]^((~B[3]) & B[8]);
704             A[24]=B[24]^((~B[4]) & B[9]);
705 
706             /*Last step*/
707             A[0]=A[0]^RC[i];            
708         }
709 
710         
711         return A;
712     }
713  
714     
715     function sponge(uint[9] M) constant internal returns(uint[16]) {
716         if( (M.length * 8) != 72 ) throw;
717         M[5] = 0x01;
718         M[8] = 0x8000000000000000;
719         
720         uint r = 72;
721         uint w = 8;
722         uint size = M.length * 8;
723         
724         uint[25] memory S;
725         uint i; uint y; uint x;
726         /*Absorbing Phase*/
727         for( i = 0 ; i < size/r ; i++ ) {
728             for( y = 0 ; y < 5 ; y++ ) {
729                 for( x = 0 ; x < 5 ; x++ ) {
730                     if( (x+5*y) < (r/w) ) {
731                         S[5*x+y] = S[5*x+y] ^ M[i*9 + x + 5*y];
732                     }
733                 }
734             }
735             S = keccak_f(S);
736         }
737 
738         /*Squeezing phase*/
739         uint[16] memory result;
740         uint b = 0;
741         while( b < 16 ) {
742             for( y = 0 ; y < 5 ; y++ ) {
743                 for( x = 0 ; x < 5 ; x++ ) {
744                     if( (x+5*y)<(r/w) && (b<16) ) {
745                         result[b] = S[5*x+y] & 0xFFFFFFFF; 
746                         result[b+1] = S[5*x+y] / 0x100000000;
747                         b+=2;
748                     }
749                 }
750             }
751         }
752          
753         return result;
754    }
755 
756 }
757 
758 ////////////////////////////////////////////////////////////////////////////////
759 
760 contract Ethash is SHA3_512 {
761     
762     address public owner;    
763     
764     struct EthashCacheData {
765         uint128 merkleRoot;
766         uint64  fullSizeIn128Resultion;
767         uint64  branchDepth;
768     }
769     
770     mapping(uint=>EthashCacheData) epochData;    
771     
772     using RLP for RLP.RLPItem;
773     using RLP for RLP.Iterator;
774     using RLP for bytes;
775  
776     struct BlockHeader {
777         uint       prevBlockHash; // 0
778         uint       coinbase;      // 1
779         uint       blockNumber;   // 8
780         uint       timestamp;     // 11
781         bytes32    extraData;     // 12
782     }
783     
784     function Ethash() {
785         owner = msg.sender;
786     }
787            
788     function setEpochData( uint128 merkleRoot, uint64 fullSizeIn128Resultion, uint64 branchDepth, uint epoch ) {
789         EthashCacheData memory data;
790         data.merkleRoot = merkleRoot;
791         data.fullSizeIn128Resultion = fullSizeIn128Resultion;
792         data.branchDepth = branchDepth;
793         
794         epochData[epoch] = data;        
795     }    
796       
797     function parseBlockHeader( bytes rlpHeader ) constant internal returns(BlockHeader) {
798         BlockHeader memory header;
799         
800         var it = rlpHeader.toRLPItem().iterator();        
801         uint idx;
802         while(it.hasNext()) {
803             if( idx == 0 ) header.prevBlockHash = it.next().toUint();
804             else if ( idx == 2 ) header.coinbase = it.next().toUint();
805             else if ( idx == 8 ) header.blockNumber = it.next().toUint();
806             else if ( idx == 11 ) header.timestamp = it.next().toUint();
807             else if ( idx == 12 ) header.extraData = bytes32(it.next().toUint());
808             else it.next();
809             
810             idx++;
811         }
812  
813         return header;        
814     }
815         
816      
817     function fnv( uint v1, uint v2 ) constant internal returns(uint) {
818         return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
819     }
820 
821 
822 
823     function computeCacheRoot( uint index,
824                                uint indexInElementsArray,
825                                uint[] elements,
826                                uint[] witness,
827                                uint branchSize ) constant private returns(uint) {
828  
829                        
830         uint leaf = computeLeaf(elements, indexInElementsArray) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
831 
832         uint left;
833         uint right;
834         uint node;
835         bool oddBranchSize = (branchSize % 2) > 0;
836          
837         assembly {
838             branchSize := div(branchSize,2)
839             //branchSize /= 2;
840         }
841         uint witnessIndex = indexInElementsArray * branchSize;
842         if( oddBranchSize ) witnessIndex += indexInElementsArray;  
843 
844         for( uint depth = 0 ; depth < branchSize ; depth++ ) {
845             assembly {
846                 node := mload(add(add(witness,0x20),mul(add(depth,witnessIndex),0x20)))
847             }
848             //node  = witness[witnessIndex + depth] & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
849             if( index & 0x1 == 0 ) {
850                 left = leaf;
851                 assembly{
852                     //right = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;                
853                     right := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
854                 }
855                 
856             }
857             else {
858                 assembly{
859                     //left = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
860                     left := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
861                 }
862                 right = leaf;
863             }
864             
865             leaf = uint(sha3(left,right)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
866             assembly {
867                 index := div(index,2) 
868             }
869             //index = index / 2;
870 
871             //node  = witness[witnessIndex + depth] / (2**128);
872             if( index & 0x1 == 0 ) {
873                 left = leaf;
874                 assembly{
875                     right := div(node,0x100000000000000000000000000000000)
876                     //right = node / 0x100000000000000000000000000000000;
877                 }
878             }
879             else {
880                 assembly {
881                     //left = node / 0x100000000000000000000000000000000;
882                     left := div(node,0x100000000000000000000000000000000)
883                 }
884                 right = leaf;
885             }
886             
887             leaf = uint(sha3(left,right)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
888             assembly {
889                 index := div(index,2) 
890             }
891             //index = index / 2;
892         }
893         
894         if( oddBranchSize ) {
895             assembly {
896                 node := mload(add(add(witness,0x20),mul(add(depth,witnessIndex),0x20)))
897             }
898         
899             //node  = witness[witnessIndex + depth] & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
900             if( index & 0x1 == 0 ) {
901                 left = leaf;
902                 assembly{
903                     //right = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;                
904                     right := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
905                 }                
906             }
907             else {
908                 assembly{
909                     //left = node & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;                
910                     left := and(node,0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
911                 }
912             
913                 right = leaf;
914             }
915             
916             leaf = uint(sha3(left,right)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;        
917         }
918         
919         
920         return leaf;
921     }
922 
923     
924     function toBE( uint x ) constant internal returns(uint) {
925         uint y = 0;
926         for( uint i = 0 ; i < 32 ; i++ ) {
927             y = y * 256;
928             y += (x & 0xFF);
929             x = x / 256;            
930         }
931         
932         return y;
933         
934     }
935     
936     function computeSha3( uint[16] s, uint[8] cmix ) constant internal returns(uint) {
937         uint s0 = s[0] + s[1] * (2**32) + s[2] * (2**64) + s[3] * (2**96) +
938                   (s[4] + s[5] * (2**32) + s[6] * (2**64) + s[7] * (2**96))*(2**128);
939 
940         uint s1 = s[8] + s[9] * (2**32) + s[10] * (2**64) + s[11] * (2**96) +
941                   (s[12] + s[13] * (2**32) + s[14] * (2**64) + s[15] * (2**96))*(2**128);
942                   
943         uint c = cmix[0] + cmix[1] * (2**32) + cmix[2] * (2**64) + cmix[3] * (2**96) +
944                   (cmix[4] + cmix[5] * (2**32) + cmix[6] * (2**64) + cmix[7] * (2**96))*(2**128);
945 
946         
947         /* god knows why need to convert to big endian */
948         return uint( sha3(toBE(s0),toBE(s1),toBE(c)) );
949     }
950  
951  
952     function computeLeaf( uint[] dataSetLookup, uint index ) constant internal returns(uint) {
953         return uint( sha3(dataSetLookup[4*index],
954                           dataSetLookup[4*index + 1],
955                           dataSetLookup[4*index + 2],
956                           dataSetLookup[4*index + 3]) );
957                                     
958     }
959  
960     function computeS( uint header, uint nonceLe ) constant internal returns(uint[16]) {
961         uint[9]  memory M;
962         
963         header = reverseBytes(header);
964         
965         M[0] = uint(header) & 0xFFFFFFFFFFFFFFFF;
966         header = header / 2**64;
967         M[1] = uint(header) & 0xFFFFFFFFFFFFFFFF;
968         header = header / 2**64;
969         M[2] = uint(header) & 0xFFFFFFFFFFFFFFFF;
970         header = header / 2**64;
971         M[3] = uint(header) & 0xFFFFFFFFFFFFFFFF;
972 
973         // make little endian nonce
974         M[4] = nonceLe;
975         return sponge(M);
976     }
977     
978     function reverseBytes( uint input ) constant internal returns(uint) {
979         uint result = 0;
980         for(uint i = 0 ; i < 32 ; i++ ) {
981             result = result * 256;
982             result += input & 0xff;
983             
984             input /= 256;
985         }
986         
987         return result;
988     }
989     
990     function hashimoto( bytes32 header,
991                         bytes8 nonceLe,
992                         uint fullSizeIn128Resultion,
993                         uint[] dataSetLookup,
994                         uint[] witnessForLookup,
995                         uint   branchSize,
996                         uint   root ) constant returns(uint) {
997          
998         uint[16] memory s;
999         uint[32] memory mix;
1000         uint[8]  memory cmix;
1001                 
1002         uint i;
1003         uint j;
1004         
1005 
1006         
1007         s = computeS(uint(header), uint(nonceLe));
1008         for( i = 0 ; i < 16 ; i++ ) {            
1009             assembly {
1010                 let offset := mul(i,0x20)
1011                 
1012                 //mix[i] = s[i];
1013                 mstore(add(mix,offset),mload(add(s,offset)))
1014                 
1015                 // mix[i+16] = s[i];
1016                 mstore(add(mix,add(0x200,offset)),mload(add(s,offset)))    
1017             }
1018         }
1019         
1020         for( i = 0 ; i < 64 ; i++ ) {
1021             uint p = fnv( i ^ s[0], mix[i % 32]) % fullSizeIn128Resultion;
1022             if( computeCacheRoot( p, i, dataSetLookup,  witnessForLookup, branchSize )  != root ) {
1023                 // PoW failed
1024                 return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1025             }        
1026 
1027             for( j = 0 ; j < 8 ; j++ ) {
1028 
1029                 assembly{
1030                     //mix[j] = fnv(mix[j], dataSetLookup[4*i] & varFFFFFFFF );
1031                     let dataOffset := add(mul(0x80,i),add(dataSetLookup,0x20))
1032                     let dataValue   := and(mload(dataOffset),0xFFFFFFFF)
1033                     
1034                     let mixOffset := add(mix,mul(0x20,j))
1035                     let mixValue  := mload(mixOffset)
1036                     
1037                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
1038                     let fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
1039                     mstore(mixOffset,fnvValue)
1040                     
1041                     //mix[j+8] = fnv(mix[j+8], dataSetLookup[4*i + 1] & 0xFFFFFFFF );
1042                     dataOffset := add(dataOffset,0x20)
1043                     dataValue   := and(mload(dataOffset),0xFFFFFFFF)
1044                     
1045                     mixOffset := add(mixOffset,0x100)
1046                     mixValue  := mload(mixOffset)
1047                     
1048                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
1049                     let fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
1050                     mstore(mixOffset,fnvValue)
1051 
1052                     //mix[j+16] = fnv(mix[j+16], dataSetLookup[4*i + 2] & 0xFFFFFFFF );
1053                     dataOffset := add(dataOffset,0x20)
1054                     dataValue   := and(mload(dataOffset),0xFFFFFFFF)
1055                     
1056                     mixOffset := add(mixOffset,0x100)
1057                     mixValue  := mload(mixOffset)
1058                     
1059                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
1060                     let fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
1061                     mstore(mixOffset,fnvValue)
1062 
1063                     //mix[j+24] = fnv(mix[j+24], dataSetLookup[4*i + 3] & 0xFFFFFFFF );
1064                     dataOffset := add(dataOffset,0x20)
1065                     dataValue   := and(mload(dataOffset),0xFFFFFFFF)
1066                     
1067                     mixOffset := add(mixOffset,0x100)
1068                     mixValue  := mload(mixOffset)
1069                     
1070                     // fnv = return ((v1*0x01000193) ^ v2) & 0xFFFFFFFF;
1071                     let fnvValue := and(xor(mul(mixValue,0x01000193),dataValue),0xFFFFFFFF)                    
1072                     mstore(mixOffset,fnvValue)                    
1073                                         
1074                 }
1075 
1076                 
1077                 //mix[j] = fnv(mix[j], dataSetLookup[4*i] & 0xFFFFFFFF );
1078                 //mix[j+8] = fnv(mix[j+8], dataSetLookup[4*i + 1] & 0xFFFFFFFF );
1079                 //mix[j+16] = fnv(mix[j+16], dataSetLookup[4*i + 2] & 0xFFFFFFFF );                
1080                 //mix[j+24] = fnv(mix[j+24], dataSetLookup[4*i + 3] & 0xFFFFFFFF );
1081                 
1082                 
1083                 //dataSetLookup[4*i    ] = dataSetLookup[4*i    ]/(2**32);
1084                 //dataSetLookup[4*i + 1] = dataSetLookup[4*i + 1]/(2**32);
1085                 //dataSetLookup[4*i + 2] = dataSetLookup[4*i + 2]/(2**32);
1086                 //dataSetLookup[4*i + 3] = dataSetLookup[4*i + 3]/(2**32);                
1087                 
1088                 assembly{
1089                     let offset := add(add(dataSetLookup,0x20),mul(i,0x80))
1090                     let value  := div(mload(offset),0x100000000)
1091                     mstore(offset,value)
1092                                        
1093                     offset := add(offset,0x20)
1094                     value  := div(mload(offset),0x100000000)
1095                     mstore(offset,value)
1096                     
1097                     offset := add(offset,0x20)
1098                     value  := div(mload(offset),0x100000000)
1099                     mstore(offset,value)                    
1100                     
1101                     offset := add(offset,0x20)
1102                     value  := div(mload(offset),0x100000000)
1103                     mstore(offset,value)                                                                                
1104                 }                
1105             }
1106         }
1107         
1108         
1109         for( i = 0 ; i < 32 ; i += 4) {
1110             cmix[i/4] = (fnv(fnv(fnv(mix[i], mix[i+1]), mix[i+2]), mix[i+3]));
1111         }
1112         
1113 
1114         uint result = computeSha3(s,cmix); 
1115         return result;        
1116     }    
1117 
1118     event EthashValue( uint value );
1119         
1120     function verifyHash( bytes rlpHeader,
1121                           uint  nonce,
1122                           uint[] dataSetLookup,
1123                           uint[] witnessForLookup ) constant returns(uint) {
1124                           
1125         BlockHeader memory header = parseBlockHeader(rlpHeader);        
1126         
1127         uint leafHash = uint(sha3(rlpHeader));                          
1128         
1129         // get epoch data
1130         EthashCacheData memory eData = epochData[header.blockNumber / 30000];
1131         
1132         // verify ethash
1133         uint ethash = hashimoto( bytes32(leafHash),
1134                                  bytes8(nonce),
1135                                  eData.fullSizeIn128Resultion,
1136                                  dataSetLookup,
1137                                  witnessForLookup,                                 
1138                                  eData.branchDepth,
1139                                  eData.merkleRoot );
1140                                  
1141         EthashValue( ethash );
1142         
1143         return ethash;
1144     }             
1145 }