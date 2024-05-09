1 /// @title Contract that supports the receival of ERC223 tokens.
2 contract ERC223ReceivingContract {
3 
4     /// @dev Standard ERC223 function that will handle incoming token transfers.
5     /// @param _from  Token sender address.
6     /// @param _value Amount of tokens.
7     /// @param _data  Transaction metadata.
8     function tokenFallback(address _from, uint _value, bytes _data) public;
9 
10 }
11 
12 
13 contract SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   /**
38   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 contract ERC223Basic is ERC20Basic {
64 
65     /**
66       * @dev Transfer the specified amount of tokens to the specified address.
67       *      Now with a new parameter _data.
68       *
69       * @param _to    Receiver address.
70       * @param _value Amount of tokens that will be transferred.
71       * @param _data  Transaction metadata.
72       */
73     function transfer(address _to, uint _value, bytes _data) public returns (bool);
74 
75     /**
76       * @dev triggered when transfer is successfully called.
77       *
78       * @param _from  Sender address.
79       * @param _to    Receiver address.
80       * @param _value Amount of tokens that will be transferred.
81       * @param _data  Transaction metadata.
82       */
83     event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data);
84 }
85 
86 library BytesLib {
87     function concat(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bytes) {
88         bytes memory tempBytes;
89 
90         assembly {
91             // Get a location of some free memory and store it in tempBytes as
92             // Solidity does for memory variables.
93             tempBytes := mload(0x40)
94 
95             // Store the length of the first bytes array at the beginning of
96             // the memory for tempBytes.
97             let length := mload(_preBytes)
98             mstore(tempBytes, length)
99 
100             // Maintain a memory counter for the current write location in the
101             // temp bytes array by adding the 32 bytes for the array length to
102             // the starting location.
103             let mc := add(tempBytes, 0x20)
104             // Stop copying when the memory counter reaches the length of the
105             // first bytes array.
106             let end := add(mc, length)
107 
108             for {
109                 // Initialize a copy counter to the start of the _preBytes data,
110                 // 32 bytes into its memory.
111                 let cc := add(_preBytes, 0x20)
112             } lt(mc, end) {
113                 // Increase both counters by 32 bytes each iteration.
114                 mc := add(mc, 0x20)
115                 cc := add(cc, 0x20)
116             } {
117                 // Write the _preBytes data into the tempBytes memory 32 bytes
118                 // at a time.
119                 mstore(mc, mload(cc))
120             }
121 
122             // Add the length of _postBytes to the current length of tempBytes
123             // and store it as the new length in the first 32 bytes of the
124             // tempBytes memory.
125             length := mload(_postBytes)
126             mstore(tempBytes, add(length, mload(tempBytes)))
127 
128             // Move the memory counter back from a multiple of 0x20 to the
129             // actual end of the _preBytes data.
130             mc := end
131             // Stop copying when the memory counter reaches the new combined
132             // length of the arrays.
133             end := add(mc, length)
134 
135             for {
136                 let cc := add(_postBytes, 0x20)
137             } lt(mc, end) {
138                 mc := add(mc, 0x20)
139                 cc := add(cc, 0x20)
140             } {
141                 mstore(mc, mload(cc))
142             }
143 
144             // Update the free-memory pointer by padding our last write location
145             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
146             // next 32 byte block, then round down to the nearest multiple of
147             // 32. If the sum of the length of the two arrays is zero then add
148             // one before rounding down to leave a blank 32 bytes (the length block with 0).
149             mstore(0x40, and(
150               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
151               not(31) // Round down to the nearest 32 bytes.
152             ))
153         }
154 
155         return tempBytes;
156     }
157 
158     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
159         assembly {
160             // Read the first 32 bytes of _preBytes storage, which is the length
161             // of the array. (We don't need to use the offset into the slot
162             // because arrays use the entire slot.)
163             let fslot := sload(_preBytes_slot)
164             // Arrays of 31 bytes or less have an even value in their slot,
165             // while longer arrays have an odd value. The actual length is
166             // the slot divided by two for odd values, and the lowest order
167             // byte divided by two for even values.
168             // If the slot is even, bitwise and the slot with 255 and divide by
169             // two to get the length. If the slot is odd, bitwise and the slot
170             // with -1 and divide by two.
171             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
172             let mlength := mload(_postBytes)
173             let newlength := add(slength, mlength)
174             // slength can contain both the length and contents of the array
175             // if length < 32 bytes so let's prepare for that
176             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
177             switch add(lt(slength, 32), lt(newlength, 32))
178             case 2 {
179                 // Since the new array still fits in the slot, we just need to
180                 // update the contents of the slot.
181                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
182                 sstore(
183                     _preBytes_slot,
184                     // all the modifications to the slot are inside this
185                     // next block
186                     add(
187                         // we can just add to the slot contents because the
188                         // bytes we want to change are the LSBs
189                         fslot,
190                         add(
191                             mul(
192                                 div(
193                                     // load the bytes from memory
194                                     mload(add(_postBytes, 0x20)),
195                                     // zero all bytes to the right
196                                     exp(0x100, sub(32, mlength))
197                                 ),
198                                 // and now shift left the number of bytes to
199                                 // leave space for the length in the slot
200                                 exp(0x100, sub(32, newlength))
201                             ),
202                             // increase length by the double of the memory
203                             // bytes length
204                             mul(mlength, 2)
205                         )
206                     )
207                 )
208             }
209             case 1 {
210                 // The stored value fits in the slot, but the combined value
211                 // will exceed it.
212                 // get the keccak hash to get the contents of the array
213                 mstore(0x0, _preBytes_slot)
214                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
215 
216                 // save new length
217                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
218 
219                 // The contents of the _postBytes array start 32 bytes into
220                 // the structure. Our first read should obtain the `submod`
221                 // bytes that can fit into the unused space in the last word
222                 // of the stored array. To get this, we read 32 bytes starting
223                 // from `submod`, so the data we read overlaps with the array
224                 // contents by `submod` bytes. Masking the lowest-order
225                 // `submod` bytes allows us to add that value directly to the
226                 // stored value.
227 
228                 let submod := sub(32, slength)
229                 let mc := add(_postBytes, submod)
230                 let end := add(_postBytes, mlength)
231                 let mask := sub(exp(0x100, submod), 1)
232 
233                 sstore(
234                     sc,
235                     add(
236                         and(
237                             fslot,
238                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
239                         ),
240                         and(mload(mc), mask)
241                     )
242                 )
243 
244                 for {
245                     mc := add(mc, 0x20)
246                     sc := add(sc, 1)
247                 } lt(mc, end) {
248                     sc := add(sc, 1)
249                     mc := add(mc, 0x20)
250                 } {
251                     sstore(sc, mload(mc))
252                 }
253 
254                 mask := exp(0x100, sub(mc, end))
255 
256                 sstore(sc, mul(div(mload(mc), mask), mask))
257             }
258             default {
259                 // get the keccak hash to get the contents of the array
260                 mstore(0x0, _preBytes_slot)
261                 // Start copying to the last used word of the stored array.
262                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
263 
264                 // save new length
265                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
266 
267                 // Copy over the first `submod` bytes of the new data as in
268                 // case 1 above.
269                 let slengthmod := mod(slength, 32)
270                 let mlengthmod := mod(mlength, 32)
271                 let submod := sub(32, slengthmod)
272                 let mc := add(_postBytes, submod)
273                 let end := add(_postBytes, mlength)
274                 let mask := sub(exp(0x100, submod), 1)
275 
276                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
277 
278                 for {
279                     sc := add(sc, 1)
280                     mc := add(mc, 0x20)
281                 } lt(mc, end) {
282                     sc := add(sc, 1)
283                     mc := add(mc, 0x20)
284                 } {
285                     sstore(sc, mload(mc))
286                 }
287 
288                 mask := exp(0x100, sub(mc, end))
289 
290                 sstore(sc, mul(div(mload(mc), mask), mask))
291             }
292         }
293     }
294 
295     function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes) {
296         require(_bytes.length >= (_start + _length));
297 
298         bytes memory tempBytes;
299 
300         assembly {
301             switch iszero(_length)
302             case 0 {
303                 // Get a location of some free memory and store it in tempBytes as
304                 // Solidity does for memory variables.
305                 tempBytes := mload(0x40)
306 
307                 // The first word of the slice result is potentially a partial
308                 // word read from the original array. To read it, we calculate
309                 // the length of that partial word and start copying that many
310                 // bytes into the array. The first word we copy will start with
311                 // data we don't care about, but the last `lengthmod` bytes will
312                 // land at the beginning of the contents of the new array. When
313                 // we're done copying, we overwrite the full first word with
314                 // the actual length of the slice.
315                 let lengthmod := and(_length, 31)
316 
317                 // The multiplication in the next line is necessary
318                 // because when slicing multiples of 32 bytes (lengthmod == 0)
319                 // the following copy loop was copying the origin's length
320                 // and then ending prematurely not copying everything it should.
321                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
322                 let end := add(mc, _length)
323 
324                 for {
325                     // The multiplication in the next line has the same exact purpose
326                     // as the one above.
327                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
328                 } lt(mc, end) {
329                     mc := add(mc, 0x20)
330                     cc := add(cc, 0x20)
331                 } {
332                     mstore(mc, mload(cc))
333                 }
334 
335                 mstore(tempBytes, _length)
336 
337                 //update free-memory pointer
338                 //allocating the array padded to 32 bytes like the compiler does now
339                 mstore(0x40, and(add(mc, 31), not(31)))
340             }
341             //if we want a zero-length slice let's just return a zero-length array
342             default {
343                 tempBytes := mload(0x40)
344 
345                 mstore(0x40, add(tempBytes, 0x20))
346             }
347         }
348 
349         return tempBytes;
350     }
351 
352     function toAddress(bytes _bytes, uint _start) internal  pure returns (address) {
353         require(_bytes.length >= (_start + 20));
354         address tempAddress;
355 
356         assembly {
357             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
358         }
359 
360         return tempAddress;
361     }
362 
363     function toUint(bytes _bytes, uint _start) internal  pure returns (uint256) {
364         require(_bytes.length >= (_start + 32));
365         uint256 tempUint;
366 
367         assembly {
368             tempUint := mload(add(add(_bytes, 0x20), _start))
369         }
370 
371         return tempUint;
372     }
373 
374     function toBytes32(bytes _bytes, uint _start) internal  pure returns (bytes32) {
375         require(_bytes.length >= (_start + 32));
376         bytes32 tempBytes32;
377 
378         assembly {
379             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
380         }
381 
382         return tempBytes32;
383     }
384 
385     function toBytes16(bytes _bytes, uint _start) internal  pure returns (bytes16) {
386         require(_bytes.length >= (_start + 16));
387         bytes16 tempBytes16;
388 
389         assembly {
390             tempBytes16 := mload(add(add(_bytes, 0x20), _start))
391         }
392 
393         return tempBytes16;
394     }
395 
396     function toBytes2(bytes _bytes, uint _start) internal  pure returns (bytes2) {
397         require(_bytes.length >= (_start + 2));
398         bytes2 tempBytes2;
399 
400         assembly {
401             tempBytes2 := mload(add(add(_bytes, 0x20), _start))
402         }
403 
404         return tempBytes2;
405     }
406 
407     function toBytes4(bytes _bytes, uint _start) internal  pure returns (bytes4) {
408         require(_bytes.length >= (_start + 4));
409         bytes4 tempBytes4;
410 
411         assembly {
412             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
413         }
414         return tempBytes4;
415     }
416 
417     function toBytes1(bytes _bytes, uint _start) internal  pure returns (bytes1) {
418         require(_bytes.length >= (_start + 1));
419         bytes1 tempBytes1;
420 
421         assembly {
422             tempBytes1 := mload(add(add(_bytes, 0x20), _start))
423         }
424 
425         return tempBytes1;
426     }
427 
428     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
429         bool success = true;
430 
431         assembly {
432             let length := mload(_preBytes)
433 
434             // if lengths don't match the arrays are not equal
435             switch eq(length, mload(_postBytes))
436             case 1 {
437                 // cb is a circuit breaker in the for loop since there's
438                 //  no said feature for inline assembly loops
439                 // cb = 1 - don't breaker
440                 // cb = 0 - break
441                 let cb := 1
442 
443                 let mc := add(_preBytes, 0x20)
444                 let end := add(mc, length)
445 
446                 for {
447                     let cc := add(_postBytes, 0x20)
448                 // the next line is the loop condition:
449                 // while(uint(mc < end) + cb == 2)
450                 } eq(add(lt(mc, end), cb), 2) {
451                     mc := add(mc, 0x20)
452                     cc := add(cc, 0x20)
453                 } {
454                     // if any of these checks fails then arrays are not equal
455                     if iszero(eq(mload(mc), mload(cc))) {
456                         // unsuccess:
457                         success := 0
458                         cb := 0
459                     }
460                 }
461             }
462             default {
463                 // unsuccess:
464                 success := 0
465             }
466         }
467 
468         return success;
469     }
470 
471     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
472         bool success = true;
473 
474         assembly {
475             // we know _preBytes_offset is 0
476             let fslot := sload(_preBytes_slot)
477             // Decode the length of the stored array like in concatStorage().
478             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
479             let mlength := mload(_postBytes)
480 
481             // if lengths don't match the arrays are not equal
482             switch eq(slength, mlength)
483             case 1 {
484                 // slength can contain both the length and contents of the array
485                 // if length < 32 bytes so let's prepare for that
486                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
487                 if iszero(iszero(slength)) {
488                     switch lt(slength, 32)
489                     case 1 {
490                         // blank the last byte which is the length
491                         fslot := mul(div(fslot, 0x100), 0x100)
492 
493                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
494                             // unsuccess:
495                             success := 0
496                         }
497                     }
498                     default {
499                         // cb is a circuit breaker in the for loop since there's
500                         //  no said feature for inline assembly loops
501                         // cb = 1 - don't breaker
502                         // cb = 0 - break
503                         let cb := 1
504 
505                         // get the keccak hash to get the contents of the array
506                         mstore(0x0, _preBytes_slot)
507                         let sc := keccak256(0x0, 0x20)
508 
509                         let mc := add(_postBytes, 0x20)
510                         let end := add(mc, mlength)
511 
512                         // the next line is the loop condition:
513                         // while(uint(mc < end) + cb == 2)
514                         for {} eq(add(lt(mc, end), cb), 2) {
515                             sc := add(sc, 1)
516                             mc := add(mc, 0x20)
517                         } {
518                             if iszero(eq(sload(sc), mload(mc))) {
519                                 // unsuccess:
520                                 success := 0
521                                 cb := 0
522                             }
523                         }
524                     }
525                 }
526             }
527             default {
528                 // unsuccess:
529                 success := 0
530             }
531         }
532 
533         return success;
534     }
535 }
536 contract Ownable {
537   address public owner;
538 
539 
540   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
541 
542 
543   /**
544    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
545    * account.
546    */
547   function Ownable() public {
548     owner = msg.sender;
549   }
550 
551   /**
552    * @dev Throws if called by any account other than the owner.
553    */
554   modifier onlyOwner() {
555     require(msg.sender == owner);
556     _;
557   }
558 
559   /**
560    * @dev Allows the current owner to transfer control of the contract to a newOwner.
561    * @param newOwner The address to transfer ownership to.
562    */
563   function transferOwnership(address newOwner) public onlyOwner {
564     require(newOwner != address(0));
565     OwnershipTransferred(owner, newOwner);
566     owner = newOwner;
567   }
568 
569 }
570 
571 
572 contract DateTime {
573         /*
574          *  Date and Time utilities for ethereum contracts
575          *
576          */
577         struct _DateTime {
578                 uint16 year;
579                 uint8 month;
580                 uint8 day;
581                 uint8 hour;
582                 uint8 minute;
583                 uint8 second;
584                 uint8 weekday;
585         }
586 
587         uint constant DAY_IN_SECONDS = 86400;
588         uint constant YEAR_IN_SECONDS = 31536000;
589         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
590 
591         uint constant HOUR_IN_SECONDS = 3600;
592         uint constant MINUTE_IN_SECONDS = 60;
593 
594         uint16 constant ORIGIN_YEAR = 1970;
595 
596         function isLeapYear(uint16 year) public pure returns (bool) {
597                 if (year % 4 != 0) {
598                         return false;
599                 }
600                 if (year % 100 != 0) {
601                         return true;
602                 }
603                 if (year % 400 != 0) {
604                         return false;
605                 }
606                 return true;
607         }
608 
609         function leapYearsBefore(uint year) public pure returns (uint) {
610                 year -= 1;
611                 return year / 4 - year / 100 + year / 400;
612         }
613 
614         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
615                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
616                         return 31;
617                 }
618                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
619                         return 30;
620                 }
621                 else if (isLeapYear(year)) {
622                         return 29;
623                 }
624                 else {
625                         return 28;
626                 }
627         }
628 
629         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
630                 uint secondsAccountedFor = 0;
631                 uint buf;
632                 uint8 i;
633 
634                 // Year
635                 dt.year = getYear(timestamp);
636                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
637 
638                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
639                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
640 
641                 // Month
642                 uint secondsInMonth;
643                 for (i = 1; i <= 12; i++) {
644                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
645                         if (secondsInMonth + secondsAccountedFor > timestamp) {
646                                 dt.month = i;
647                                 break;
648                         }
649                         secondsAccountedFor += secondsInMonth;
650                 }
651 
652                 // Day
653                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
654                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
655                                 dt.day = i;
656                                 break;
657                         }
658                         secondsAccountedFor += DAY_IN_SECONDS;
659                 }
660 
661                 // Hour
662                 dt.hour = getHour(timestamp);
663 
664                 // Minute
665                 dt.minute = getMinute(timestamp);
666 
667                 // Second
668                 dt.second = getSecond(timestamp);
669 
670                 // Day of week.
671                 dt.weekday = getWeekday(timestamp);
672         }
673 
674         function getYear(uint timestamp) public pure returns (uint16) {
675                 uint secondsAccountedFor = 0;
676                 uint16 year;
677                 uint numLeapYears;
678 
679                 // Year
680                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
681                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
682 
683                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
684                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
685 
686                 while (secondsAccountedFor > timestamp) {
687                         if (isLeapYear(uint16(year - 1))) {
688                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
689                         }
690                         else {
691                                 secondsAccountedFor -= YEAR_IN_SECONDS;
692                         }
693                         year -= 1;
694                 }
695                 return year;
696         }
697 
698         function getMonth(uint timestamp) public pure returns (uint8) {
699                 return parseTimestamp(timestamp).month;
700         }
701 
702         function getDay(uint timestamp) public pure returns (uint8) {
703                 return parseTimestamp(timestamp).day;
704         }
705 
706         function getHour(uint timestamp) public pure returns (uint8) {
707                 return uint8((timestamp / 60 / 60) % 24);
708         }
709 
710         function getMinute(uint timestamp) public pure returns (uint8) {
711                 return uint8((timestamp / 60) % 60);
712         }
713 
714         function getSecond(uint timestamp) public pure returns (uint8) {
715                 return uint8(timestamp % 60);
716         }
717 
718         function getWeekday(uint timestamp) public pure returns (uint8) {
719                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
720         }
721 
722         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
723                 return toTimestamp(year, month, day, 0, 0, 0);
724         }
725 
726         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
727                 return toTimestamp(year, month, day, hour, 0, 0);
728         }
729 
730         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
731                 return toTimestamp(year, month, day, hour, minute, 0);
732         }
733 
734         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
735                 uint16 i;
736 
737                 // Year
738                 for (i = ORIGIN_YEAR; i < year; i++) {
739                         if (isLeapYear(i)) {
740                                 timestamp += LEAP_YEAR_IN_SECONDS;
741                         }
742                         else {
743                                 timestamp += YEAR_IN_SECONDS;
744                         }
745                 }
746 
747                 // Month
748                 uint8[12] memory monthDayCounts;
749                 monthDayCounts[0] = 31;
750                 if (isLeapYear(year)) {
751                         monthDayCounts[1] = 29;
752                 }
753                 else {
754                         monthDayCounts[1] = 28;
755                 }
756                 monthDayCounts[2] = 31;
757                 monthDayCounts[3] = 30;
758                 monthDayCounts[4] = 31;
759                 monthDayCounts[5] = 30;
760                 monthDayCounts[6] = 31;
761                 monthDayCounts[7] = 31;
762                 monthDayCounts[8] = 30;
763                 monthDayCounts[9] = 31;
764                 monthDayCounts[10] = 30;
765                 monthDayCounts[11] = 31;
766 
767                 for (i = 1; i < month; i++) {
768                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
769                 }
770 
771                 // Day
772                 timestamp += DAY_IN_SECONDS * (day - 1);
773 
774                 // Hour
775                 timestamp += HOUR_IN_SECONDS * (hour);
776 
777                 // Minute
778                 timestamp += MINUTE_IN_SECONDS * (minute);
779 
780                 // Second
781                 timestamp += second;
782 
783                 return timestamp;
784         }
785 }
786 
787 
788 contract DetherBank is ERC223ReceivingContract, Ownable, SafeMath, DateTime {
789   using BytesLib for bytes;
790 
791   /*
792    * Event
793    */
794   event receiveDth(address _from, uint amount);
795   event receiveEth(address _from, uint amount);
796   event sendDth(address _from, uint amount);
797   event sendEth(address _from, uint amount);
798 
799   mapping(address => uint) public dthShopBalance;
800   mapping(address => uint) public dthTellerBalance;
801   mapping(address => uint) public ethShopBalance;
802   mapping(address => uint) public ethTellerBalance;
803 
804 
805   // store a mapping with per day/month/year a uint256 containing the wei sold amount on that date
806   //
807   //      user               day               month             year      weiSold
808   mapping(address => mapping(uint16 => mapping(uint16 => mapping(uint16 => uint256)))) ethSellsUserToday;
809 
810   ERC223Basic public dth;
811   bool public isInit = false;
812 
813   /**
814    * INIT
815    */
816   function setDth (address _dth) external onlyOwner {
817     require(!isInit);
818     dth = ERC223Basic(_dth);
819     isInit = true;
820   }
821 
822   /**
823    * Core fonction
824    */
825   // withdraw DTH when teller delete
826   function withdrawDthTeller(address _receiver) external onlyOwner {
827     require(dthTellerBalance[_receiver] > 0);
828     uint tosend = dthTellerBalance[_receiver];
829     dthTellerBalance[_receiver] = 0;
830     require(dth.transfer(_receiver, tosend));
831   }
832   // withdraw DTH when shop delete
833   function withdrawDthShop(address _receiver) external onlyOwner  {
834     require(dthShopBalance[_receiver] > 0);
835     uint tosend = dthShopBalance[_receiver];
836     dthShopBalance[_receiver] = 0;
837     require(dth.transfer(_receiver, tosend));
838   }
839   // withdraw DTH when a shop add by admin is delete
840   function withdrawDthShopAdmin(address _from, address _receiver) external onlyOwner  {
841     require(dthShopBalance[_from]  > 0);
842     uint tosend = dthShopBalance[_from];
843     dthShopBalance[_from] = 0;
844     require(dth.transfer(_receiver, tosend));
845   }
846 
847   // add DTH when shop register
848   function addTokenShop(address _from, uint _value) external onlyOwner {
849     dthShopBalance[_from] = SafeMath.add(dthShopBalance[_from], _value);
850   }
851   // add DTH when token register
852   function addTokenTeller(address _from, uint _value) external onlyOwner{
853     dthTellerBalance[_from] = SafeMath.add(dthTellerBalance[_from], _value);
854   }
855   // add ETH for escrow teller
856   function addEthTeller(address _from, uint _value) external payable onlyOwner returns (bool) {
857     ethTellerBalance[_from] = SafeMath.add(ethTellerBalance[_from] ,_value);
858     return true;
859   }
860   // helper function to extra date info from block.timestamp
861   function getDateInfo(uint timestamp) internal view returns(_DateTime) {
862     // use DateTime.sol to extract date info from the timestamp
863     _DateTime memory date = parseTimestamp(timestamp);
864     return date;
865   }
866   // withdraw ETH for teller escrow + save amount sold today for the _from user
867   function withdrawEth(address _from, address _to, uint _amount) external onlyOwner {
868     require(ethTellerBalance[_from] >= _amount);
869     ethTellerBalance[_from] = SafeMath.sub(ethTellerBalance[_from], _amount);
870 
871     uint256 weiSoldToday = getWeiSoldToday(_from);
872 
873     _DateTime memory date = getDateInfo(block.timestamp);
874 
875     // add the sold amount, should not exceed daily limit (checked in DetherCore)
876     ethSellsUserToday[_from][date.day][date.month][date.year] = SafeMath.add(weiSoldToday, _amount);
877 
878     _to.transfer(_amount);
879   }
880   // refund all ETH from teller contract
881   function refundEth(address _from) external onlyOwner {
882     uint toSend = ethTellerBalance[_from];
883     if (toSend > 0) {
884       ethTellerBalance[_from] = 0;
885       _from.transfer(toSend);
886     }
887   }
888 
889   /**
890    * GETTER
891    */
892   function getDthTeller(address _user) public view returns (uint) {
893     return dthTellerBalance[_user];
894   }
895   function getDthShop(address _user) public view returns (uint) {
896     return dthShopBalance[_user];
897   }
898 
899   function getEthBalTeller(address _user) public view returns (uint) {
900     return ethTellerBalance[_user];
901   }
902 
903   // get amount wei sold today for this user
904   function getWeiSoldToday(address _user) public view returns (uint256 weiSoldToday) {
905     // use DateTime.sol to extract date info from the timestamp
906     _DateTime memory date = getDateInfo(block.timestamp);
907     weiSoldToday = ethSellsUserToday[_user][date.day][date.month][date.year];
908   }
909 
910   /// @dev Standard ERC223 function that will handle incoming token transfers.
911   // DO NOTHING but allow to receive token when addToken* function are called
912   // by the dethercore contract
913   function tokenFallback(address _from, uint _value, bytes _data) {
914     require(msg.sender == address(dth));
915   }
916 
917 }