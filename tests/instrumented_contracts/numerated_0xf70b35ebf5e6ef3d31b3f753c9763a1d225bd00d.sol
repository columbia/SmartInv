1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 library RLPReader {
56     uint8 constant STRING_SHORT_START = 0x80;
57     uint8 constant STRING_LONG_START  = 0xb8;
58     uint8 constant LIST_SHORT_START   = 0xc0;
59     uint8 constant LIST_LONG_START    = 0xf8;
60 
61     uint8 constant WORD_SIZE = 32;
62 
63     struct RLPItem {
64         uint len;
65         uint memPtr;
66     }
67 
68     /*
69     * @param item RLP encoded bytes
70     */
71     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
72         if (item.length == 0)
73             return RLPItem(0, 0);
74 
75         uint memPtr;
76         assembly {
77             memPtr := add(item, 0x20)
78         }
79 
80         return RLPItem(item.length, memPtr);
81     }
82 
83     /*
84     * @param item RLP encoded list in bytes
85     */
86     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory result) {
87         require(isList(item));
88 
89         uint items = numItems(item);
90         result = new RLPItem[](items);
91 
92         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
93         uint dataLen;
94         for (uint i = 0; i < items; i++) {
95             dataLen = _itemLength(memPtr);
96             result[i] = RLPItem(dataLen, memPtr);
97             memPtr = memPtr + dataLen;
98         }
99     }
100 
101     /*
102     * Helpers
103     */
104 
105     // @return indicator whether encoded payload is a list. negate this function call for isData.
106     function isList(RLPItem memory item) internal pure returns (bool) {
107         uint8 byte0;
108         uint memPtr = item.memPtr;
109         assembly {
110             byte0 := byte(0, mload(memPtr))
111         }
112 
113         if (byte0 < LIST_SHORT_START)
114             return false;
115         return true;
116     }
117 
118     // @return number of payload items inside an encoded list.
119     function numItems(RLPItem memory item) internal pure returns (uint) {
120         uint count = 0;
121         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
122         uint endPtr = item.memPtr + item.len;
123         while (currPtr < endPtr) {
124             currPtr = currPtr + _itemLength(currPtr); // skip over an item
125             count++;
126         }
127 
128         return count;
129     }
130 
131     // @return entire rlp item byte length
132     function _itemLength(uint memPtr) internal pure returns (uint len) {
133         uint byte0;
134         assembly {
135             byte0 := byte(0, mload(memPtr))
136         }
137 
138         if (byte0 < STRING_SHORT_START)
139             return 1;
140 
141         else if (byte0 < STRING_LONG_START)
142             return byte0 - STRING_SHORT_START + 1;
143 
144         else if (byte0 < LIST_SHORT_START) {
145             assembly {
146                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
147                 memPtr := add(memPtr, 1) // skip over the first byte
148 
149             /* 32 byte word size */
150                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
151                 len := add(dataLen, add(byteLen, 1))
152             }
153         }
154 
155         else if (byte0 < LIST_LONG_START) {
156             return byte0 - LIST_SHORT_START + 1;
157         }
158 
159         else {
160             assembly {
161                 let byteLen := sub(byte0, 0xf7)
162                 memPtr := add(memPtr, 1)
163 
164                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
165                 len := add(dataLen, add(byteLen, 1))
166             }
167         }
168     }
169 
170     // @return number of bytes until the data
171     function _payloadOffset(uint memPtr) internal pure returns (uint) {
172         uint byte0;
173         assembly {
174             byte0 := byte(0, mload(memPtr))
175         }
176 
177         if (byte0 < STRING_SHORT_START)
178             return 0;
179         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
180             return 1;
181         else if (byte0 < LIST_SHORT_START)  // being explicit
182             return byte0 - (STRING_LONG_START - 1) + 1;
183         else
184             return byte0 - (LIST_LONG_START - 1) + 1;
185     }
186 
187     /** RLPItem conversions into data types **/
188 
189     function toBoolean(RLPItem memory item) internal pure returns (bool) {
190         require(item.len == 1, "Invalid RLPItem. Booleans are encoded in 1 byte");
191         uint result;
192         uint memPtr = item.memPtr;
193         assembly {
194             result := byte(0, mload(memPtr))
195         }
196 
197         return result == 0 ? false : true;
198     }
199 
200     function toAddress(RLPItem memory item) internal pure returns (address) {
201         // 1 byte for the length prefix according to RLP spec
202         require(item.len == 21, "Invalid RLPItem. Addresses are encoded in 20 bytes");
203 
204         uint memPtr = item.memPtr + 1; // skip the length prefix
205         uint addr;
206         assembly {
207             addr := div(mload(memPtr), exp(256, 12)) // right shift 12 bytes. we want the most significant 20 bytes
208         }
209 
210         return address(addr);
211     }
212 
213     function toUint(RLPItem memory item) internal pure returns (uint) {
214         uint offset = _payloadOffset(item.memPtr);
215         uint len = item.len - offset;
216         uint memPtr = item.memPtr + offset;
217 
218         uint result;
219         assembly {
220             result := div(mload(memPtr), exp(256, sub(32, len))) // shift to the correct location
221         }
222 
223         return result;
224     }
225 
226     function toBytes(RLPItem memory item) internal pure returns (bytes) {
227         uint offset = _payloadOffset(item.memPtr);
228         uint len = item.len - offset; // data length
229         bytes memory result = new bytes(len);
230 
231         uint destPtr;
232         assembly {
233             destPtr := add(0x20, result)
234         }
235 
236         copy(item.memPtr + offset, destPtr, len);
237         return result;
238     }
239 
240 
241     /*
242     * @param src Pointer to source
243     * @param dest Pointer to destination
244     * @param len Amount of memory to copy from the source
245     */
246     function copy(uint src, uint dest, uint len) internal pure {
247         // copy as many word sizes as possible
248         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
249             assembly {
250                 mstore(dest, mload(src))
251             }
252 
253             src += WORD_SIZE;
254             dest += WORD_SIZE;
255         }
256 
257         // left over bytes
258         uint mask = 256 ** (WORD_SIZE - len) - 1;
259         assembly {
260             let srcpart := and(mload(src), not(mask)) // zero out src
261             let destpart := and(mload(dest), mask) // retrieve the bytes
262             mstore(dest, or(destpart, srcpart))
263         }
264     }
265 }
266 
267 library RLPWriter {
268     function toRlp(bytes memory _value) internal pure returns (bytes memory _bytes) {
269         uint _valuePtr;
270         uint _rplPtr;
271         uint _valueLength = _value.length;
272 
273         assembly {
274             _valuePtr := add(_value, 0x20)
275             _bytes := mload(0x40)                   // Free memory ptr
276             _rplPtr := add(_bytes, 0x20)            // RLP first byte ptr
277         }
278 
279         // [0x00, 0x7f]
280         if (_valueLength == 1 && _value[0] <= 0x7f) {
281             assembly {
282                 mstore(_bytes, 1)                   // Bytes size is 1
283                 mstore(_rplPtr, mload(_valuePtr))  // Set value as-is
284                 mstore(0x40, add(_rplPtr, 1))       // Update free ptr
285             }
286             return;
287         }
288 
289         // [0x80, 0xb7]
290         if (_valueLength <= 55) {
291             assembly {
292                 mstore(_bytes, add(1, _valueLength))            // Bytes size
293                 mstore8(_rplPtr, add(0x80, _valueLength))       // RLP small string size
294                 mstore(0x40, add(add(_rplPtr, 1), _valueLength)) // Update free ptr
295             }
296 
297             copy(_valuePtr, _rplPtr + 1, _valueLength);
298             return;
299         }
300 
301         // [0xb8, 0xbf]
302         uint _lengthSize = uintMinimalSize(_valueLength);
303 
304         assembly {
305             mstore(_bytes, add(add(1, _lengthSize), _valueLength))  // Bytes size
306             mstore8(_rplPtr, add(0xb7, _lengthSize))                // RLP long string "size size"
307             mstore(add(_rplPtr, 1), mul(_valueLength, exp(256, sub(32, _lengthSize)))) // Bitshift to store the length only _lengthSize bytes
308             mstore(0x40, add(add(add(_rplPtr, 1), _lengthSize), _valueLength))  // Update free ptr
309         }
310 
311         copy(_valuePtr, _rplPtr + 1 + _lengthSize, _valueLength);
312         return;
313     }
314 
315     function toRlp(uint _value) internal pure returns (bytes memory _bytes) {
316         uint _size = uintMinimalSize(_value);
317 
318         bytes memory _valueBytes = new bytes(_size);
319 
320         assembly {
321             mstore(add(_valueBytes, 0x20), mul(_value, exp(256, sub(32, _size))))
322         }
323 
324         return toRlp(_valueBytes);
325     }
326 
327     function toRlp(bytes[] memory _values) internal pure returns (bytes memory _bytes) {
328         uint _ptr;
329         uint _size;
330         uint i;
331 
332         // compute data size
333         for(; i < _values.length; ++i)
334             _size += _values[i].length;
335 
336         // create rlp header
337         assembly {
338             _bytes := mload(0x40)
339             _ptr := add(_bytes, 0x20)
340         }
341 
342         if (_size <= 55) {
343             assembly {
344                 mstore8(_ptr, add(0xc0, _size))
345                 _ptr := add(_ptr, 1)
346             }
347         } else {
348             uint _size2 = uintMinimalSize(_size);
349 
350             assembly {
351                 mstore8(_ptr, add(0xf7, _size2))
352                 _ptr := add(_ptr, 1)
353                 mstore(_ptr, mul(_size, exp(256, sub(32, _size2))))
354                 _ptr := add(_ptr, _size2)
355             }
356         }
357 
358         // copy data
359         for(i = 0; i < _values.length; ++i) {
360             bytes memory _val = _values[i];
361             uint _valPtr;
362 
363             assembly {
364                 _valPtr := add(_val, 0x20)
365             }
366 
367             copy(_valPtr, _ptr, _val.length);
368 
369             _ptr += _val.length;
370         }
371 
372         assembly {
373             mstore(0x40, _ptr)
374             mstore(_bytes, sub(sub(_ptr, _bytes), 0x20))
375         }
376     }
377 
378     function uintMinimalSize(uint _value) internal pure returns (uint _size) {
379         for (; _value != 0; _size++)
380             _value /= 256;
381     }
382 
383     /*
384     * @param src Pointer to source
385     * @param dest Pointer to destination
386     * @param len Amount of memory to copy from the source
387     */
388     function copy(uint src, uint dest, uint len) internal pure {
389         // copy as many word sizes as possible
390         for (; len >= 32; len -= 32) {
391             assembly {
392                 mstore(dest, mload(src))
393             }
394 
395             src += 32;
396             dest += 32;
397         }
398 
399         // left over bytes
400         uint mask = 256 ** (32 - len) - 1;
401         assembly {
402             let srcpart := and(mload(src), not(mask)) // zero out src
403             let destpart := and(mload(dest), mask) // retrieve the bytes
404             mstore(dest, or(destpart, srcpart))
405         }
406     }
407 }
408 
409 
410 library AuctionityLibraryDecodeRawTx {
411 
412     using RLPReader for RLPReader.RLPItem;
413     using RLPReader for bytes;
414 
415     function decodeRawTxGetBiddingInfo(bytes memory _signedRawTxBidding, uint8 _chainId) internal pure returns (bytes32 _hashRawTxTokenTransfer, address _auctionContractAddress, uint256 _bidAmount, address _signerBid) {
416 
417         bytes memory _auctionBidlData;
418         RLPReader.RLPItem[] memory _signedRawTxBiddingRLPItem = _signedRawTxBidding.toRlpItem().toList();
419 
420         _auctionContractAddress = _signedRawTxBiddingRLPItem[3].toAddress();
421         _auctionBidlData = _signedRawTxBiddingRLPItem[5].toBytes();
422 
423         bytes4 _selector;
424         assembly { _selector := mload(add(_auctionBidlData,0x20))}
425 
426         _signerBid = getSignerFromSignedRawTxRLPItemp(_signedRawTxBiddingRLPItem,_chainId);
427 
428         // 0x1d03ae68 : bytes4(keccak256('bid(uint256,address,bytes32)'))
429         if(_selector == 0x1d03ae68 ) {
430 
431             assembly {
432                 _bidAmount := mload(add(_auctionBidlData,add(4,0x20)))
433                 _hashRawTxTokenTransfer := mload(add(_auctionBidlData,add(68,0x20)))
434             }
435 
436         }
437 
438     }
439 
440 
441 
442     function decodeRawTxGetCreateAuctionInfo(bytes memory _signedRawTxCreateAuction, uint8 _chainId) internal pure returns (
443         bytes32 _tokenHash,
444         address _auctionFactoryContractAddress,
445         address _signerCreate,
446         address _tokenContractAddress,
447         uint256 _tokenId,
448         uint8 _rewardPercent
449     ) {
450 
451         bytes memory _createAuctionlData;
452         RLPReader.RLPItem[] memory _signedRawTxCreateAuctionRLPItem = _signedRawTxCreateAuction.toRlpItem().toList();
453 
454 
455         _auctionFactoryContractAddress = _signedRawTxCreateAuctionRLPItem[3].toAddress();
456         _createAuctionlData = _signedRawTxCreateAuctionRLPItem[5].toBytes();
457 
458 
459         _signerCreate = getSignerFromSignedRawTxRLPItemp(_signedRawTxCreateAuctionRLPItem,_chainId);
460 
461         bytes memory _signedRawTxTokenTransfer;
462 
463         (_signedRawTxTokenTransfer, _tokenContractAddress,_tokenId,_rewardPercent) = decodeRawTxGetCreateAuctionInfoData( _createAuctionlData);
464 
465 
466 
467         _tokenHash = keccak256(_signedRawTxTokenTransfer);
468 
469     }
470 
471     function decodeRawTxGetCreateAuctionInfoData(bytes memory _createAuctionlData) internal pure returns(
472         bytes memory _signedRawTxTokenTransfer,
473         address _tokenContractAddress,
474         uint256 _tokenId,
475         uint8 _rewardPercent
476     ) {
477         bytes4 _selector;
478         assembly { _selector := mload(add(_createAuctionlData,0x20))}
479 
480         uint _positionOfSignedRawTxTokenTransfer;
481         uint _sizeOfSignedRawTxTokenTransfer;
482 
483         // 0xffd6d828 : bytes4(keccak256('create(bytes,address,uint256,bytes,address,uint8)'))
484         if(_selector == 0xffd6d828) {
485 
486             assembly {
487                 _positionOfSignedRawTxTokenTransfer := mload(add(_createAuctionlData,add(4,0x20)))
488                 _sizeOfSignedRawTxTokenTransfer := mload(add(_createAuctionlData,add(add(_positionOfSignedRawTxTokenTransfer,4),0x20)))
489 
490             // tokenContractAddress : get 2th param
491                 _tokenContractAddress := mload(add(_createAuctionlData,add(add(mul(1,32),4),0x20)))
492             // tockenId : get 3th param
493                 _tokenId := mload(add(_createAuctionlData,add(add(mul(2,32),4),0x20)))
494             // rewardPercent : get 6th param
495                 _rewardPercent := mload(add(_createAuctionlData,add(add(mul(5,32),4),0x20)))
496 
497             }
498 
499             _signedRawTxTokenTransfer = new bytes(_sizeOfSignedRawTxTokenTransfer);
500 
501             for (uint i = 0; i < _sizeOfSignedRawTxTokenTransfer; i++) {
502                 _signedRawTxTokenTransfer[i] = _createAuctionlData[i + _positionOfSignedRawTxTokenTransfer + 4 + 32 ];
503             }
504 
505         }
506 
507     }
508 
509     function ecrecoverSigner(
510         bytes32 _hashTx,
511         bytes _rsvTx,
512         uint offset
513     ) internal pure returns (address ecrecoverAddress){
514 
515         bytes32 r;
516         bytes32 s;
517         bytes1 v;
518 
519         assembly {
520             r := mload(add(_rsvTx,add(offset,0x20)))
521             s := mload(add(_rsvTx,add(offset,0x40)))
522             v := mload(add(_rsvTx,add(offset,0x60)))
523         }
524 
525         ecrecoverAddress = ecrecover(
526             _hashTx,
527             uint8(v),
528             r,
529             s
530         );
531     }
532 
533 
534 
535     function decodeRawTxGetWithdrawalInfo(bytes memory _signedRawTxWithdrawal, uint8 _chainId) internal pure returns (address withdrawalSigner, uint256 withdrawalAmount) {
536 
537         bytes4 _selector;
538         bytes memory _withdrawalData;
539         RLPReader.RLPItem[] memory _signedRawTxWithdrawalRLPItem = _signedRawTxWithdrawal.toRlpItem().toList();
540 
541         _withdrawalData = _signedRawTxWithdrawalRLPItem[5].toBytes();
542 
543         assembly { _selector := mload(add(_withdrawalData,0x20))}
544 
545         withdrawalSigner = getSignerFromSignedRawTxRLPItemp(_signedRawTxWithdrawalRLPItem,_chainId);
546 
547         // 0x835fc6ca : bytes4(keccak256('withdrawal(uint256)'))
548         if(_selector == 0x835fc6ca ) {
549 
550             assembly {
551                 withdrawalAmount := mload(add(_withdrawalData,add(4,0x20)))
552             }
553 
554         }
555 
556     }
557 
558 
559 
560     function getSignerFromSignedRawTxRLPItemp(RLPReader.RLPItem[] memory _signedTxRLPItem, uint8 _chainId) internal pure returns (address ecrecoverAddress) {
561         bytes memory _rawTx;
562         bytes memory _rsvTx;
563 
564         (_rawTx, _rsvTx ) = explodeSignedRawTxRLPItem(_signedTxRLPItem, _chainId);
565         return ecrecoverSigner(keccak256(_rawTx), _rsvTx,0);
566     }
567 
568     function explodeSignedRawTxRLPItem(RLPReader.RLPItem[] memory _signedTxRLPItem, uint8 _chainId) internal pure returns (bytes memory _rawTx,bytes memory _rsvTx){
569 
570         bytes[] memory _signedTxRLPItemRaw = new bytes[](9);
571 
572         _signedTxRLPItemRaw[0] = RLPWriter.toRlp(_signedTxRLPItem[0].toBytes());
573         _signedTxRLPItemRaw[1] = RLPWriter.toRlp(_signedTxRLPItem[1].toBytes());
574         _signedTxRLPItemRaw[2] = RLPWriter.toRlp(_signedTxRLPItem[2].toBytes());
575         _signedTxRLPItemRaw[3] = RLPWriter.toRlp(_signedTxRLPItem[3].toBytes());
576         _signedTxRLPItemRaw[4] = RLPWriter.toRlp(_signedTxRLPItem[4].toBytes());
577         _signedTxRLPItemRaw[5] = RLPWriter.toRlp(_signedTxRLPItem[5].toBytes());
578 
579         _signedTxRLPItemRaw[6] = RLPWriter.toRlp(_chainId);
580         _signedTxRLPItemRaw[7] = RLPWriter.toRlp(0);
581         _signedTxRLPItemRaw[8] = RLPWriter.toRlp(0);
582 
583         _rawTx = RLPWriter.toRlp(_signedTxRLPItemRaw);
584 
585         uint8 i;
586         _rsvTx = new bytes(65);
587 
588         bytes32 tmp = bytes32(_signedTxRLPItem[7].toUint());
589         for (i = 0; i < 32; i++) {
590             _rsvTx[i] = tmp[i];
591         }
592 
593         tmp = bytes32(_signedTxRLPItem[8].toUint());
594 
595         for (i = 0; i < 32; i++) {
596             _rsvTx[i + 32] = tmp[i];
597         }
598 
599         _rsvTx[64] = bytes1(_signedTxRLPItem[6].toUint() - uint(_chainId * 2) - 8);
600 
601     }
602 
603 }
604 library AuctionityLibraryDeposit{
605 
606     function sendTransfer(address _tokenContractAddress, bytes memory _transfer, uint _offset) internal returns (bool){
607 
608         if(!isContract(_tokenContractAddress)){
609             return false;
610         }
611 
612         uint8 _numberOfTransfer = uint8(_transfer[_offset]);
613 
614         _offset += 1;
615 
616         bool _success;
617         for (uint8 i = 0; i < _numberOfTransfer; i++){
618             (_offset,_success) = decodeTransferCall(_tokenContractAddress, _transfer,_offset);
619             
620             if(!_success) {
621                 return false;
622             }
623         }
624 
625         return true;
626 
627     }
628 
629     function decodeTransferCall(address _tokenContractAddress, bytes memory _transfer, uint _offset) internal returns (uint, bool) {
630 
631 
632         bytes memory _sizeOfCallBytes;
633         bytes memory _callData;
634 
635         uint _sizeOfCallUint;
636 
637         if(_transfer[_offset] == 0xb8) {
638             _sizeOfCallBytes = new bytes(1);
639             _sizeOfCallBytes[0] = bytes1(_transfer[_offset + 1]);
640 
641             _offset+=2;
642         }
643         if(_transfer[_offset] == 0xb9) {
644 
645             _sizeOfCallBytes = new bytes(2);
646             _sizeOfCallBytes[0] = bytes1(_transfer[_offset + 1]);
647             _sizeOfCallBytes[1] = bytes1(_transfer[_offset + 2]);
648             _offset+=3;
649         }
650 
651         _sizeOfCallUint = bytesToUint(_sizeOfCallBytes);
652 
653         _callData = new bytes(_sizeOfCallUint);
654         for (uint j = 0; j < _sizeOfCallUint; j++) {
655             _callData[j] = _transfer[(j + _offset)];
656         }
657 
658         _offset+=_sizeOfCallUint;
659 
660         return (_offset, sendCallData(_tokenContractAddress, _sizeOfCallUint, _callData));
661 
662 
663     }
664 
665     function sendCallData(address _tokenContractAddress, uint _sizeOfCallUint, bytes memory _callData) internal returns (bool) {
666 
667         bool _success;
668         bytes4 sig;
669 
670         assembly {
671 
672             let _ptr := mload(0x40)
673             sig := mload(add(_callData,0x20))
674 
675             mstore(_ptr,sig) //Place signature at begining of empty storage
676             for { let i := 0x04 } lt(i, _sizeOfCallUint) { i := add(i, 0x20) } {
677                 mstore(add(_ptr,i),mload(add(_callData,add(0x20,i)))) //Add each param
678             }
679 
680 
681             _success := call(      //This is the critical change (Pop the top stack value)
682             sub (gas, 10000), // gas
683             _tokenContractAddress, //To addr
684             0,    //No value
685             _ptr,    //Inputs are stored at location _ptr
686             _sizeOfCallUint, //Inputs _size
687             _ptr,    //Store output over input (saves space)
688             0x20) //Outputs are 32 bytes long
689 
690         }
691 
692         return _success;
693     }
694 
695     
696     function isContract(address _contractAddress) internal view returns (bool) {
697         uint _size;
698         assembly { _size := extcodesize(_contractAddress) }
699         return _size > 0;
700     }
701 
702     function bytesToUint(bytes b) internal pure returns (uint256){
703         uint256 _number;
704         for(uint i=0;i<b.length;i++){
705             _number = _number + uint(b[i])*(2**(8*(b.length-(i+1))));
706         }
707         return _number;
708     }
709 
710 }
711 
712 
713 contract AuctionityDepositEth {
714     using SafeMath for uint256;
715 
716     string public version = "deposit-eth-v1";
717 
718     address public owner;
719     address public oracle;
720     uint8 public ethereumChainId;
721     uint8 public auctionityChainId;
722     bool public migrationLock;
723     bool public maintenanceLock;
724 
725     mapping (address => uint256) public depotEth;  // Depot for users (concatenate struct into uint256)
726 
727     bytes32[] public withdrawalVoucherList;                     // List of withdrawal voucher
728     mapping (bytes32 => bool) public withdrawalVoucherSubmitted; // is withdrawal voucher is already submitted
729 
730     bytes32[] public auctionEndVoucherList;                     // List of auction end voucher
731     mapping (bytes32 => bool) public auctionEndVoucherSubmitted; // is auction end voucher is already submitted
732 
733     struct InfoFromCreateAuction {
734         address tokenContractAddress;
735         address auctionSeller;
736         uint256 tokenId;
737         uint8 rewardPercent;
738         bytes32 tokenHash;
739     }
740 
741     struct InfoFromBidding {
742         address auctionContractAddress;
743         address signer;
744         uint256 amount;
745     }
746 
747     // events
748     event LogDeposed(address user, uint256 amount);
749     event LogWithdrawalVoucherSubmitted(address user, uint256 amount, bytes32 withdrawalVoucherHash);
750 
751     event LogAuctionEndVoucherSubmitted(
752         address indexed auctionContractAddress,
753         address tokenContractAddress,
754         uint256 tokenId,
755         address indexed seller,
756         address indexed winner,
757         uint256 amount
758     );
759     event LogSentEthToWinner(address auction, address user, uint256 amount);
760     event LogSentEthToAuctioneer(address auction, address user, uint256 amount);
761     event LogSentDepotEth(address user, uint256 amount);
762     event LogSentRewardsDepotEth(address[] user, uint256[] amount);
763 
764     event LogError(string version,string error);
765     event LogErrorWithData(string version, string error, bytes32[] data);
766 
767 
768     constructor(uint8 _ethereumChainId, uint8 _auctionityChainId) public {
769         ethereumChainId = _ethereumChainId;
770         auctionityChainId = _auctionityChainId;
771         owner = msg.sender;
772     }
773 
774     // Modifier
775     modifier isOwner() {
776         require(msg.sender == owner, "Sender must be owner");
777         _;
778     }
779 
780     modifier isOracle() {
781         require(msg.sender == oracle, "Sender must be oracle");
782         _;
783     }
784 
785     function setOracle(address _oracle) public isOwner {
786         oracle = _oracle;
787     }
788 
789     modifier migrationLockable() {
790         require(!migrationLock || msg.sender == owner, "MIGRATION_LOCKED");
791         _;
792     }
793 
794     function setMigrationLock(bool _lock) public isOwner {
795         migrationLock = _lock;
796     }
797 
798     modifier maintenanceLockable() {
799         require(!maintenanceLock || msg.sender == owner, "MAINTENANCE_LOCKED");
800         _;
801     } 
802 
803     function setMaintenanceLock(bool _lock) public isOwner {
804         maintenanceLock = _lock;
805     }
806 
807     // add depot from user
808     function addDepotEth(address _user, uint256 _amount) private returns (bool) {
809         depotEth[_user] = depotEth[_user].add(_amount);
810         return true;
811     }
812 
813     // sub depot from user
814     function subDepotEth(address _user, uint256 _amount) private returns (bool) {
815         if(depotEth[_user] < _amount){
816             return false;
817         }
818 
819         depotEth[_user] = depotEth[_user].sub(_amount);
820         return true;
821     }
822 
823     // get amount of user's deposit
824     function getDepotEth(address _user) public view returns(uint256 _amount) {
825         return depotEth[_user];
826     }
827 
828     // fallback payable function , with revert if is deactivated
829     function() public payable {
830         return depositEth();
831     }
832 
833     // payable deposit eth
834     function depositEth() public payable migrationLockable maintenanceLockable {
835         bytes32[] memory _errorData;
836         uint256 _amount = uint256(msg.value);
837         require(_amount > 0, "Amount must be greater than 0");
838 
839         if(!addDepotEth(msg.sender, _amount)) {
840             _errorData = new bytes32[](1);
841             _errorData[0] = bytes32(_amount);
842             emit LogErrorWithData(version, "DEPOSED_ADD_DATA_FAILED", _errorData);
843             return;
844         }
845 
846         emit LogDeposed(msg.sender, _amount);
847     }
848 
849     /**
850      * withdraw
851      * @dev Param
852      *      bytes32 r ECDSA signature
853      *      bytes32 s ECDSA signature
854      *      uint8 v ECDSA signature
855      *      address user
856      *      uint256 amount
857      *      bytes32 key : anti replay
858      * @dev Log
859      *      LogWithdrawalVoucherSubmitted : successful
860      */
861     function withdrawalVoucher(
862         bytes memory _data,
863         bytes memory _signedRawTxWithdrawal
864     ) public maintenanceLockable {
865         bytes32 _withdrawalVoucherHash = keccak256(_signedRawTxWithdrawal);
866 
867         // if withdrawal voucher is already submitted
868         if(withdrawalVoucherSubmitted[_withdrawalVoucherHash] == true) {
869             emit LogError(version, "WITHDRAWAL_VOUCHER_ALREADY_SUBMITED");
870             return;
871         }
872 
873         address _withdrawalSigner;
874         uint _withdrawalAmount;
875 
876         (_withdrawalSigner, _withdrawalAmount) = AuctionityLibraryDecodeRawTx.decodeRawTxGetWithdrawalInfo(_signedRawTxWithdrawal, auctionityChainId);
877         
878         if(_withdrawalAmount == uint256(0)) {
879             emit LogError(version,'WITHDRAWAL_VOUCHER_AMOUNT_INVALID');
880             return;
881         }
882 
883         if(_withdrawalSigner == address(0)) {
884             emit LogError(version,'WITHDRAWAL_VOUCHER_SIGNER_INVALID');
885             return;
886         }
887 
888         // if depot is smaller than amount
889         if(depotEth[_withdrawalSigner] < _withdrawalAmount) {
890             emit LogError(version,'WITHDRAWAL_VOUCHER_DEPOT_AMOUNT_TOO_LOW');
891             return;
892         }
893 
894         if(!withdrawalVoucherOracleSignatureVerification(_data, _withdrawalSigner, _withdrawalAmount, _withdrawalVoucherHash)) {
895             emit LogError(version,'WITHDRAWAL_VOUCHER_ORACLE_INVALID_SIGNATURE');
896             return;
897         }
898 
899         // send amount
900         if(!_withdrawalSigner.send(_withdrawalAmount)) {
901             emit LogError(version, "WITHDRAWAL_VOUCHER_ETH_TRANSFER_FAILED");
902             return;
903         }
904 
905         subDepotEth(_withdrawalSigner,_withdrawalAmount);
906 
907         withdrawalVoucherList.push(_withdrawalVoucherHash);
908         withdrawalVoucherSubmitted[_withdrawalVoucherHash] = true;
909 
910         emit LogWithdrawalVoucherSubmitted(_withdrawalSigner,_withdrawalAmount, _withdrawalVoucherHash);
911     }
912 
913     function withdrawalVoucherOracleSignatureVerification(
914         bytes memory _data,
915         address _withdrawalSigner,
916         uint256 _withdrawalAmount,
917         bytes32 _withdrawalVoucherHash
918     ) internal view returns (bool)
919     {
920 
921         // if oracle is the signer of this auction end voucher
922         return oracle == AuctionityLibraryDecodeRawTx.ecrecoverSigner(
923             keccak256(
924                 abi.encodePacked(
925                     "\x19Ethereum Signed Message:\n32",
926                     keccak256(
927                         abi.encodePacked(
928                             address(this),
929                             _withdrawalSigner,
930                             _withdrawalAmount,
931                             _withdrawalVoucherHash
932                         )
933                     )
934                 )
935             ),
936             _data,
937             0
938         );
939     }
940 
941     /**
942      * auctionEndVoucher
943      * @dev Param
944      *      bytes _data is a  concatenate of :
945      *            bytes64 biddingHashProof
946      *            bytes130 rsv ECDSA signature of oracle validation AEV
947      *            bytes transfer token
948      *      bytes _signedRawTxCreateAuction raw transaction with rsv of bidding transaction on auction smart contract
949      *      bytes _signedRawTxBidding raw transaction with rsv of bidding transaction on auction smart contract
950      *      bytes _send list of sending eth
951      * @dev Log
952      *      LogAuctionEndVoucherSubmitted : successful
953      */
954 
955     function auctionEndVoucher(
956         bytes memory _data,
957         bytes memory _signedRawTxCreateAuction,
958         bytes memory _signedRawTxBidding,
959         bytes memory _send
960     ) public maintenanceLockable {
961         bytes32 _auctionEndVoucherHash = keccak256(_signedRawTxCreateAuction);
962         // if auction end voucher is already submitted
963         if(auctionEndVoucherSubmitted[_auctionEndVoucherHash] == true) {
964             emit LogError(version, "AUCTION_END_VOUCHER_ALREADY_SUBMITED");
965             return;
966         }
967 
968         InfoFromCreateAuction memory _infoFromCreateAuction = getInfoFromCreateAuction(_signedRawTxCreateAuction);
969 
970         address _auctionContractAddress;
971         address _winnerSigner;
972         uint256 _winnerAmount;
973 
974         InfoFromBidding memory _infoFromBidding;
975 
976         if(_signedRawTxBidding.length > 1) {
977             _infoFromBidding = getInfoFromBidding(_signedRawTxBidding, _infoFromCreateAuction.tokenHash);
978 
979             if(!verifyWinnerDepot(_infoFromBidding)) {
980                 return;
981             }
982         }
983 
984         if(!auctionEndVoucherOracleSignatureVerification(
985             _data,
986             keccak256(_send),
987             _infoFromCreateAuction,
988             _infoFromBidding
989         )) {
990             emit LogError(version, "AUCTION_END_VOUCHER_ORACLE_INVALID_SIGNATURE");
991             return;
992         }
993 
994         if(!AuctionityLibraryDeposit.sendTransfer(_infoFromCreateAuction.tokenContractAddress, _data, 97)){
995             if(_data[97] > 0x01) {// if more than 1 transfer function to call
996                 revert("More than one transfer function to call");
997             } else {
998                 emit LogError(version, "AUCTION_END_VOUCHER_TRANSFER_FAILED");
999                 return;
1000             }
1001         }
1002 
1003         if(_signedRawTxBidding.length > 1) {
1004             if(!sendExchange(_send, _infoFromCreateAuction, _infoFromBidding)) {
1005                 return;
1006             }
1007         }
1008 
1009 
1010         auctionEndVoucherList.push(_auctionEndVoucherHash);
1011         auctionEndVoucherSubmitted[_auctionEndVoucherHash] = true;
1012         emit LogAuctionEndVoucherSubmitted(
1013             _infoFromBidding.auctionContractAddress,
1014             _infoFromCreateAuction.tokenContractAddress,
1015             _infoFromCreateAuction.tokenId,
1016             _infoFromCreateAuction.auctionSeller,
1017             _infoFromBidding.signer,
1018             _infoFromBidding.amount
1019         );
1020     }
1021 
1022     function getInfoFromCreateAuction(bytes _signedRawTxCreateAuction) internal view returns
1023         (InfoFromCreateAuction memory _infoFromCreateAuction)
1024     {
1025         (
1026             _infoFromCreateAuction.tokenHash,
1027             ,
1028             _infoFromCreateAuction.auctionSeller,
1029             _infoFromCreateAuction.tokenContractAddress,
1030             _infoFromCreateAuction.tokenId,
1031             _infoFromCreateAuction.rewardPercent
1032         ) = AuctionityLibraryDecodeRawTx.decodeRawTxGetCreateAuctionInfo(_signedRawTxCreateAuction,auctionityChainId);
1033     }
1034 
1035     function getInfoFromBidding(bytes _signedRawTxBidding, bytes32 _hashSignedRawTxTokenTransfer) internal returns (InfoFromBidding memory _infoFromBidding) {
1036         bytes32 _hashRawTxTokenTransferFromBid;
1037 
1038         (
1039             _hashRawTxTokenTransferFromBid,
1040             _infoFromBidding.auctionContractAddress,
1041             _infoFromBidding.amount,
1042             _infoFromBidding.signer
1043         ) = AuctionityLibraryDecodeRawTx.decodeRawTxGetBiddingInfo(_signedRawTxBidding,auctionityChainId);
1044 
1045         if(_hashRawTxTokenTransferFromBid != _hashSignedRawTxTokenTransfer) {
1046             emit LogError(version, "AUCTION_END_VOUCHER_hashRawTxTokenTransfer_INVALID");
1047             return;
1048         }
1049 
1050         if(_infoFromBidding.amount == uint256(0)){
1051             emit LogError(version, "AUCTION_END_VOUCHER_BIDDING_AMOUNT_INVALID");
1052             return;
1053         }
1054 
1055     }    
1056 
1057     function verifyWinnerDepot(InfoFromBidding memory _infoFromBidding) internal returns(bool) {
1058         // if depot is smaller than amount
1059         if(depotEth[_infoFromBidding.signer] < _infoFromBidding.amount) {
1060             emit LogError(version, "AUCTION_END_VOUCHER_DEPOT_AMOUNT_TOO_LOW");
1061             return false;
1062         }
1063 
1064         return true;
1065     }
1066 
1067     function sendExchange(
1068         bytes memory _send,
1069         InfoFromCreateAuction memory _infoFromCreateAuction,
1070         InfoFromBidding memory _infoFromBidding
1071     ) internal returns(bool) {
1072         if(!subDepotEth(_infoFromBidding.signer, _infoFromBidding.amount)){
1073             emit LogError(version, "AUCTION_END_VOUCHER_DEPOT_AMOUNT_TOO_LOW");
1074             return false;
1075         }
1076 
1077         uint offset;
1078         address _sendAddress;
1079         uint256 _sendAmount;
1080         bytes12 _sendAmountGwei;
1081         uint256 _sentAmount;
1082 
1083         assembly {
1084             _sendAddress := mload(add(_send,add(offset,0x14)))
1085             _sendAmount := mload(add(_send,add(add(offset,20),0x20)))
1086         }
1087 
1088         if(_sendAddress != _infoFromCreateAuction.auctionSeller){
1089             emit LogError(version, "AUCTION_END_VOUCHER_SEND_TO_SELLER_INVALID");
1090             return false;
1091         }
1092 
1093         _sentAmount += _sendAmount;
1094         offset += 52;
1095 
1096         if(!_sendAddress.send(_sendAmount)) {
1097             revert("Failed to send funds");
1098         }
1099 
1100         emit LogSentEthToWinner(_infoFromBidding.auctionContractAddress, _sendAddress, _sendAmount);
1101 
1102         if(_infoFromCreateAuction.rewardPercent > 0) {
1103             assembly {
1104                 _sendAddress := mload(add(_send,add(offset,0x14)))
1105                 _sendAmount := mload(add(_send,add(add(offset,20),0x20)))
1106             }
1107 
1108             _sentAmount += _sendAmount;
1109             offset += 52;
1110 
1111             if(!_sendAddress.send(_sendAmount)) {
1112                 revert("Failed to send funds");
1113             }
1114 
1115             emit LogSentEthToAuctioneer(_infoFromBidding.auctionContractAddress, _sendAddress, _sendAmount);
1116 
1117             bytes2 _numberOfSendDepositBytes2;
1118             assembly {
1119                 _numberOfSendDepositBytes2 := mload(add(_send,add(offset,0x20)))
1120             }
1121 
1122             offset += 2;
1123 
1124             address[] memory _rewardsAddress = new address[](uint16(_numberOfSendDepositBytes2));
1125             uint256[] memory _rewardsAmount = new uint256[](uint16(_numberOfSendDepositBytes2));
1126 
1127             for (uint16 i = 0; i < uint16(_numberOfSendDepositBytes2); i++){
1128 
1129                 assembly {
1130                     _sendAddress := mload(add(_send,add(offset,0x14)))
1131                     _sendAmountGwei := mload(add(_send,add(add(offset,20),0x20)))
1132                 }
1133 
1134                 _sendAmount = uint96(_sendAmountGwei) * 1000000000;
1135                 _sentAmount += _sendAmount;
1136                 offset += 32;
1137 
1138                 if(!addDepotEth(_sendAddress, _sendAmount)) {
1139                     revert("Can't add deposit");
1140                 }
1141 
1142                 _rewardsAddress[i] = _sendAddress;
1143                 _rewardsAmount[i] = uint256(_sendAmount);
1144             }
1145 
1146             emit LogSentRewardsDepotEth(_rewardsAddress, _rewardsAmount);
1147         }
1148 
1149         if(uint256(_infoFromBidding.amount) != _sentAmount) {
1150             revert("Bidding amount is not equal to sent amount");
1151         }
1152 
1153         return true;
1154     }
1155 
1156     function getTransferDataHash(bytes memory _data) internal returns (bytes32 _transferDataHash){
1157         bytes memory _transferData = new bytes(_data.length - 97);
1158 
1159         for (uint i = 0; i < (_data.length - 97); i++) {
1160             _transferData[i] = _data[i + 97];
1161         }
1162         return keccak256(_transferData);
1163 
1164     }
1165 
1166     function auctionEndVoucherOracleSignatureVerification(
1167         bytes memory _data,
1168         bytes32 _sendDataHash,
1169         InfoFromCreateAuction memory _infoFromCreateAuction,
1170         InfoFromBidding memory _infoFromBidding
1171     ) internal returns (bool) {
1172         bytes32 _biddingHashProof;
1173         assembly { _biddingHashProof := mload(add(_data,add(0,0x20))) }
1174 
1175         bytes32 _transferDataHash = getTransferDataHash(_data);
1176 
1177         // if oracle is the signer of this auction end voucher
1178         return oracle == AuctionityLibraryDecodeRawTx.ecrecoverSigner(
1179             keccak256(
1180                 abi.encodePacked(
1181                     "\x19Ethereum Signed Message:\n32",
1182                     keccak256(
1183                         abi.encodePacked(
1184                             address(this),
1185                             _infoFromCreateAuction.tokenContractAddress,
1186                             _infoFromCreateAuction.tokenId,
1187                             _infoFromCreateAuction.auctionSeller,
1188                             _infoFromBidding.signer,
1189                             _infoFromBidding.amount,
1190                             _biddingHashProof,
1191                             _infoFromCreateAuction.rewardPercent,
1192                             _transferDataHash,
1193                             _sendDataHash
1194                         )
1195                     )
1196                 )
1197             ),
1198             _data,
1199             32
1200         );
1201 
1202     }
1203 }