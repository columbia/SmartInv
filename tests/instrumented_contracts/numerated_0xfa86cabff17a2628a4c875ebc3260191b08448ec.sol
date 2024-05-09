1 pragma solidity ^0.5.2 <0.6.0;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @return the address of the owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner());
29         _;
30     }
31 
32     /**
33      * @return true if `msg.sender` is the owner of the contract.
34      */
35     function isOwner() public view returns (bool) {
36         return msg.sender == _owner;
37     }
38 
39     /**
40      * @dev Allows the current owner to relinquish control of the contract.
41      * @notice Renouncing to ownership will leave the contract without an owner.
42      * It will not be possible to call the functions with the `onlyOwner`
43      * modifier anymore.
44      */
45     function renounceOwnership() public onlyOwner {
46         emit OwnershipTransferred(_owner, address(0));
47         _owner = address(0);
48     }
49 
50     /**
51      * @dev Allows the current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57 
58     /**
59      * @dev Transfers control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0));
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 library RLP {
69 
70     uint constant DATA_SHORT_START = 0x80;
71     uint constant DATA_LONG_START = 0xB8;
72     uint constant LIST_SHORT_START = 0xC0;
73     uint constant LIST_LONG_START = 0xF8;
74 
75     uint constant DATA_LONG_OFFSET = 0xB7;
76     uint constant LIST_LONG_OFFSET = 0xF7;
77 
78 
79     struct RLPItem {
80         uint _unsafe_memPtr;    // Pointer to the RLP-encoded bytes.
81         uint _unsafe_length;    // Number of bytes. This is the full length of the string.
82     }
83 
84     struct Iterator {
85         RLPItem _unsafe_item;   // Item that's being iterated over.
86         uint _unsafe_nextPtr;   // Position of the next item in the list.
87     }
88 
89     /* Iterator */
90 
91     function next(Iterator memory self) internal pure returns (RLPItem memory subItem) {
92         if(hasNext(self)) {
93             uint256 ptr = self._unsafe_nextPtr;
94             uint256 itemLength = _itemLength(ptr);
95             subItem._unsafe_memPtr = ptr;
96             subItem._unsafe_length = itemLength;
97             self._unsafe_nextPtr = ptr + itemLength;
98         }
99         else
100             revert();
101     }
102 
103     function next(Iterator memory self, bool strict) internal pure returns (RLPItem memory subItem) {
104         subItem = next(self);
105         if(strict && !_validate(subItem))
106             revert();
107         return subItem;
108     }
109 
110     function hasNext(
111         Iterator memory self
112     ) internal pure returns (bool) {
113         RLP.RLPItem memory item = self._unsafe_item;
114         return self._unsafe_nextPtr < item._unsafe_memPtr + item._unsafe_length;
115     }
116 
117     /* RLPItem */
118 
119     /// @dev Creates an RLPItem from an array of RLP encoded bytes.
120     /// @param self The RLP encoded bytes.
121     /// @return An RLPItem
122     function toRLPItem(bytes memory self) internal pure returns (RLPItem memory) {
123         uint len = self.length;
124         if (len == 0) {
125             return RLPItem(0, 0);
126         }
127         uint memPtr;
128         assembly {
129             memPtr := add(self, 0x20)
130         }
131         return RLPItem(memPtr, len);
132     }
133 
134     /// @dev Creates an RLPItem from an array of RLP encoded bytes.
135     /// @param self The RLP encoded bytes.
136     /// @param strict Will throw if the data is not RLP encoded.
137     /// @return An RLPItem
138     function toRLPItem(bytes memory self, bool strict) internal pure returns (RLPItem memory) {
139         RLP.RLPItem memory item = toRLPItem(self);
140         if(strict) {
141             uint len = self.length;
142             if(_payloadOffset(item) > len)
143                 revert();
144             if(_itemLength(item._unsafe_memPtr) != len)
145                 revert();
146             if(!_validate(item))
147                 revert();
148         }
149         return item;
150     }
151 
152     /// @dev Check if the RLP item is null.
153     /// @param self The RLP item.
154     /// @return 'true' if the item is null.
155     function isNull(RLPItem memory self) internal pure returns (bool ret) {
156         return self._unsafe_length == 0;
157     }
158 
159     /// @dev Check if the RLP item is a list.
160     /// @param self The RLP item.
161     /// @return 'true' if the item is a list.
162     function isList(RLPItem memory self) internal pure returns (bool ret) {
163         if (self._unsafe_length == 0)
164             return false;
165         uint memPtr = self._unsafe_memPtr;
166         assembly {
167             ret := iszero(lt(byte(0, mload(memPtr)), 0xC0))
168         }
169     }
170 
171     /// @dev Check if the RLP item is data.
172     /// @param self The RLP item.
173     /// @return 'true' if the item is data.
174     function isData(RLPItem memory self) internal pure returns (bool ret) {
175         if (self._unsafe_length == 0)
176             return false;
177         uint memPtr = self._unsafe_memPtr;
178         assembly {
179             ret := lt(byte(0, mload(memPtr)), 0xC0)
180         }
181     }
182 
183     /// @dev Check if the RLP item is empty (string or list).
184     /// @param self The RLP item.
185     /// @return 'true' if the item is null.
186     function isEmpty(RLPItem memory self) internal pure returns (bool ret) {
187         if(isNull(self))
188             return false;
189         uint b0;
190         uint memPtr = self._unsafe_memPtr;
191         assembly {
192             b0 := byte(0, mload(memPtr))
193         }
194         return (b0 == DATA_SHORT_START || b0 == LIST_SHORT_START);
195     }
196 
197     /// @dev Get the number of items in an RLP encoded list.
198     /// @param self The RLP item.
199     /// @return The number of items.
200     function items(RLPItem memory self) internal pure returns (uint) {
201         if (!isList(self))
202             return 0;
203         uint b0;
204         uint memPtr = self._unsafe_memPtr;
205         assembly {
206             b0 := byte(0, mload(memPtr))
207         }
208         uint pos = memPtr + _payloadOffset(self);
209         uint last = memPtr + self._unsafe_length - 1;
210         uint itms;
211         while(pos <= last) {
212             pos += _itemLength(pos);
213             itms++;
214         }
215         return itms;
216     }
217 
218     /// @dev Create an iterator.
219     /// @param self The RLP item.
220     /// @return An 'Iterator' over the item.
221     function iterator(RLPItem memory self) internal pure returns (Iterator memory it) {
222         require(isList(self));
223         uint ptr = self._unsafe_memPtr + _payloadOffset(self);
224         it._unsafe_item = self;
225         it._unsafe_nextPtr = ptr;
226     }
227 
228     /// @dev Return the RLP encoded bytes.
229     /// @param self The RLPItem.
230     /// @return The bytes.
231     function toBytes(RLPItem memory self) internal pure returns (bytes memory bts) {
232         uint256 len = self._unsafe_length;
233         if (len == 0)
234             return bts;
235         bts = new bytes(len);
236         _copyToBytes(self._unsafe_memPtr, bts, len);
237 //
238 //        uint256 len = self._unsafe_length;
239 //
240 //        if (len == 0) {
241 //            return bts;
242 //        } else if (len == 1) {
243 //            bts = new bytes(len);
244 //            _copyToBytes(self._unsafe_memPtr, bts, len);
245 //            return bts;
246 //        }
247 //
248 //        bts = new bytes(len-_payloadOffset(self));
249 //        uint start = self._unsafe_memPtr + _payloadOffset(self);
250 //        _copyToBytes(start, bts, len-_payloadOffset(self));
251     }
252 
253     /// @dev Decode an RLPItem into bytes. This will not work if the
254     /// RLPItem is a list.
255     /// @param self The RLPItem.
256     /// @return The decoded string.
257     function toData(RLPItem memory self) internal pure returns (bytes memory bts) {
258         require(isData(self));
259         (uint256 rStartPos, uint256 len) = _decode(self);
260         bts = new bytes(len);
261         _copyToBytes(rStartPos, bts, len);
262     }
263 
264     /// @dev Get the list of sub-items from an RLP encoded list.
265     /// Warning: This is inefficient, as it requires that the list is read twice.
266     /// @param self The RLP item.
267     /// @return Array of RLPItems.
268     function toList(RLPItem memory self) internal pure returns (RLPItem[] memory list) {
269         require(isList(self));
270         uint256 numItems = items(self);
271         list = new RLPItem[](numItems);
272         RLP.Iterator memory it = iterator(self);
273         uint idx;
274         while(hasNext(it)) {
275             list[idx] = next(it);
276             idx++;
277         }
278     }
279 
280     /// @dev Decode an RLPItem into an ascii string. This will not work if the
281     /// RLPItem is a list.
282     /// @param self The RLPItem.
283     /// @return The decoded string.
284     function toAscii(RLPItem memory self) internal pure returns (string memory str) {
285         require(isData(self));
286         (uint256 rStartPos, uint256 len) = _decode(self);
287         bytes memory bts = new bytes(len);
288         _copyToBytes(rStartPos, bts, len);
289         str = string(bts);
290     }
291 
292     /// @dev Decode an RLPItem into a uint. This will not work if the
293     /// RLPItem is a list.
294     /// @param self The RLPItem.
295     /// @return The decoded string.
296     function toUint(RLPItem memory self) internal pure returns (uint data) {
297         require(isData(self));
298         (uint256 rStartPos, uint256 len) = _decode(self);
299         require(len <= 32);
300         assembly {
301             data := div(mload(rStartPos), exp(256, sub(32, len)))
302         }
303     }
304 
305     /// @dev Decode an RLPItem into a boolean. This will not work if the
306     /// RLPItem is a list.
307     /// @param self The RLPItem.
308     /// @return The decoded string.
309     function toBool(RLPItem memory self) internal pure returns (bool data) {
310         require(isData(self));
311         (uint256 rStartPos, uint256 len) = _decode(self);
312         require(len == 1);
313         uint temp;
314         assembly {
315             temp := byte(0, mload(rStartPos))
316         }
317         require(temp == 1 || temp == 0);
318         return temp == 1 ? true : false;
319     }
320 
321     /// @dev Decode an RLPItem into a byte. This will not work if the
322     /// RLPItem is a list.
323     /// @param self The RLPItem.
324     /// @return The decoded string.
325     function toByte(RLPItem memory self)
326     internal
327     pure
328     returns (byte data)
329     {
330         require(isData(self));
331 
332         (uint256 rStartPos, uint256 len) = _decode(self);
333 
334         require(len == 1);
335 
336         byte temp;
337         assembly {
338             temp := byte(0, mload(rStartPos))
339         }
340         return temp;
341     }
342 
343     /// @dev Decode an RLPItem into an int. This will not work if the
344     /// RLPItem is a list.
345     /// @param self The RLPItem.
346     /// @return The decoded string.
347     function toInt(RLPItem memory self)
348     internal
349     pure
350     returns (int data)
351     {
352         return int(toUint(self));
353     }
354 
355     /// @dev Decode an RLPItem into a bytes32. This will not work if the
356     /// RLPItem is a list.
357     /// @param self The RLPItem.
358     /// @return The decoded string.
359     function toBytes32(RLPItem memory self)
360     internal
361     pure
362     returns (bytes32 data)
363     {
364         return bytes32(toUint(self));
365     }
366 
367     /// @dev Decode an RLPItem into an address. This will not work if the
368     /// RLPItem is a list.
369     /// @param self The RLPItem.
370     /// @return The decoded string.
371     function toAddress(RLPItem memory self)
372     internal
373     pure
374     returns (address data)
375     {
376         (, uint256 len) = _decode(self);
377         require(len <= 20);
378         return address(toUint(self));
379     }
380 
381     // Get the payload offset.
382     function _payloadOffset(RLPItem memory self)
383     private
384     pure
385     returns (uint)
386     {
387         if(self._unsafe_length == 0)
388             return 0;
389         uint b0;
390         uint memPtr = self._unsafe_memPtr;
391         assembly {
392             b0 := byte(0, mload(memPtr))
393         }
394         if(b0 < DATA_SHORT_START)
395             return 0;
396         if(b0 < DATA_LONG_START || (b0 >= LIST_SHORT_START && b0 < LIST_LONG_START))
397             return 1;
398         if(b0 < LIST_SHORT_START)
399             return b0 - DATA_LONG_OFFSET + 1;
400         return b0 - LIST_LONG_OFFSET + 1;
401     }
402 
403     // Get the full length of an RLP item.
404     function _itemLength(uint memPtr)
405     private
406     pure
407     returns (uint len)
408     {
409         uint b0;
410         assembly {
411             b0 := byte(0, mload(memPtr))
412         }
413         if (b0 < DATA_SHORT_START)
414             len = 1;
415         else if (b0 < DATA_LONG_START)
416             len = b0 - DATA_SHORT_START + 1;
417         else if (b0 < LIST_SHORT_START) {
418             assembly {
419                 let bLen := sub(b0, 0xB7) // bytes length (DATA_LONG_OFFSET)
420                 let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
421                 len := add(1, add(bLen, dLen)) // total length
422             }
423         } else if (b0 < LIST_LONG_START) {
424             len = b0 - LIST_SHORT_START + 1;
425         } else {
426             assembly {
427                 let bLen := sub(b0, 0xF7) // bytes length (LIST_LONG_OFFSET)
428                 let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
429                 len := add(1, add(bLen, dLen)) // total length
430             }
431         }
432     }
433 
434     // Get start position and length of the data.
435     function _decode(RLPItem memory self)
436     private
437     pure
438     returns (uint memPtr, uint len)
439     {
440         require(isData(self));
441         uint b0;
442         uint start = self._unsafe_memPtr;
443         assembly {
444             b0 := byte(0, mload(start))
445         }
446         if (b0 < DATA_SHORT_START) {
447             memPtr = start;
448             len = 1;
449             return (memPtr, len);
450         }
451         if (b0 < DATA_LONG_START) {
452             len = self._unsafe_length - 1;
453             memPtr = start + 1;
454         } else {
455             uint bLen;
456             assembly {
457                 bLen := sub(b0, 0xB7) // DATA_LONG_OFFSET
458             }
459             len = self._unsafe_length - 1 - bLen;
460             memPtr = start + bLen + 1;
461         }
462         return (memPtr, len);
463     }
464 
465     // Assumes that enough memory has been allocated to store in target.
466     function _copyToBytes(
467         uint btsPtr,
468         bytes memory tgt,
469         uint btsLen) private pure
470     {
471         // Exploiting the fact that 'tgt' was the last thing to be allocated,
472         // we can write entire words, and just overwrite any excess.
473         assembly {
474             {
475                 let words := div(add(btsLen, 31), 32)
476                 let rOffset := btsPtr
477                 let wOffset := add(tgt, 0x20)
478 
479                 for { let i := 0 } lt(i, words) { i := add(i, 1) } {
480                     let offset := mul(i, 0x20)
481                     mstore(add(wOffset, offset), mload(add(rOffset, offset)))
482                 }
483 
484                 mstore(add(tgt, add(0x20, mload(tgt))), 0)
485             }
486 
487         }
488     }
489 
490     // Check that an RLP item is valid.
491     function _validate(RLPItem memory self)
492     private
493     pure
494     returns (bool ret)
495     {
496         // Check that RLP is well-formed.
497         uint b0;
498         uint b1;
499         uint memPtr = self._unsafe_memPtr;
500         assembly {
501             b0 := byte(0, mload(memPtr))
502             b1 := byte(1, mload(memPtr))
503         }
504         if(b0 == DATA_SHORT_START + 1 && b1 < DATA_SHORT_START)
505             return false;
506         return true;
507     }
508 }
509 library Object {
510     using RLP for bytes;
511     using RLP for bytes[];
512     using RLP for RLP.RLPItem;
513     using RLP for RLP.Iterator;
514 
515     struct Data {
516         uint sura;
517         uint ayat;
518         bytes text;
519     }
520 
521     function createData(bytes memory dataBytes)
522         internal
523         pure
524         returns (Data memory)
525     {
526         RLP.RLPItem[] memory dataList = dataBytes.toRLPItem().toList();
527         return Data({
528             sura: dataList[0].toUint(),
529             ayat: dataList[1].toUint(),
530             text: dataList[2].toBytes()
531         });
532     }
533 }
534 
535 contract Storage is Ownable {
536     using Object for bytes;
537     using RLP for bytes;
538     using RLP for bytes[];
539     using RLP for RLP.RLPItem;
540     using RLP for RLP.Iterator;
541 
542     struct coord {
543         uint sura;
544         uint ayat;
545     }
546 
547     // @dev Mapping ayat's hash with its text.
548     mapping(bytes32 => bytes) public content;
549     mapping(uint => mapping(uint => bytes32)) public coordinates;
550     mapping(bytes32 => coord[]) public all_coordinates;
551 
552     /** @dev Adds content.
553       * @param text Ayat text.
554       * @param sura Sura number.
555       * @param ayat Ayat number.
556       */
557     function add_content(
558         bytes memory text,
559         uint sura,
560         uint ayat
561     ) public onlyOwner {
562         bytes32 hash = keccak256(text);
563         if (coordinates[sura][ayat] != 0x0000000000000000000000000000000000000000000000000000000000000000) {
564             return;
565         }
566 
567         coordinates[sura][ayat] = hash;
568         all_coordinates[hash].push(coord({sura:sura, ayat: ayat}));
569         content[hash] = text;
570     }
571 
572     /** @dev Adds packed data.
573       * @param data RLP packed objects.
574       */
575     function add_data(bytes memory data) public onlyOwner {
576         RLP.RLPItem[] memory list = data.toRLPItem().toList();
577 
578         for (uint index = 0; index < list.length; index++) {
579             RLP.RLPItem[] memory item = list[index].toList();
580 
581             uint sura = item[0].toUint();
582             uint ayat = item[1].toUint();
583             bytes memory text = item[2].toData();
584 
585             add_content(text, sura, ayat);
586         }
587     }
588 
589     /** @dev Gets ayat text by hash.
590       * @param ayat_hash Ayat keccak256 hash of compressed text (gzip).
591       * @return Ayat compressed text.
592       */
593     function get_ayat_text_by_hash(
594         bytes32 ayat_hash
595     ) public view returns (bytes  memory text) {
596         text = content[ayat_hash];
597     }
598 
599     /** @dev Gets ayat text by coordinates.
600       * @param sura Sura number.
601       * @param ayat Ayat number.
602       * @return Ayat compressed text.
603       */
604     function get_ayat_text_by_coordinates(
605         uint sura,
606         uint ayat
607     ) public view returns (bytes memory text) {
608         bytes32 hash = coordinates[sura][ayat];
609         text = content[hash];
610     }
611 
612     /** @dev Gets number of ayats by hash.
613       * @param hash Ayat keccak256 hash of compressed text (gzip).
614       * @return Ayats number.
615       */
616     function get_ayats_length(
617         bytes32 hash
618     ) public view returns (uint) {
619         return all_coordinates[hash].length;
620     }
621 
622     /** @dev Gets an ayat's number and a sura number by a hash and a index in an array.
623       * @param hash Ayat keccak256 hash of compressed text (gzip).
624       * @param index Ayat index. Ayat text is not unique in the Quran, so this may be several options.
625       */
626     function get_ayat_coordinates_by_index(
627         bytes32 hash,
628         uint index
629     ) public view returns (uint sura, uint ayat) {
630         coord memory data = all_coordinates[hash][index];
631         sura = data.sura;
632         ayat = data.ayat;
633     }
634 
635     /** @dev Verifying the text of an ayat.
636       * @param text Ayat compressed text (gzip).
637       * @return bool
638       */
639     function check_ayat_text(
640         bytes memory text
641     ) public view returns(bool) {
642         bytes32 hash = keccak256(text);
643         bytes memory ayat_data = content[hash];
644         return ayat_data.length != 0;
645     }
646 }