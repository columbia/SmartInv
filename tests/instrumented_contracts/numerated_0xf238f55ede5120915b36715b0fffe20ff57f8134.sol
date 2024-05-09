1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4     address public owner;
5 
6     function Ownable()
7         public
8     {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner)
18         public
19         onlyOwner
20     {
21         if (newOwner != address(0)) {
22             owner = newOwner;
23         }
24     }
25 }
26 
27 library SafeMath {
28     function safeMul(uint a, uint b)
29         internal
30         pure
31         returns (uint256)
32     {
33         uint c = a * b;
34         assert(a == 0 || c / a == b);
35         return c;
36     }
37 
38     function safeDiv(uint a, uint b)
39         internal
40         pure
41         returns (uint256)
42     {
43         uint c = a / b;
44         return c;
45     }
46 
47     function safeSub(uint a, uint b)
48         internal
49         pure
50         returns (uint256)
51     {
52         assert(b <= a);
53         return a - b;
54     }
55 
56     function safeAdd(uint a, uint b)
57         internal
58         pure
59         returns (uint256)
60     {
61         uint c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 
66     function max64(uint64 a, uint64 b)
67         internal
68         pure
69         returns (uint256)
70     {
71         return a >= b ? a : b;
72     }
73 
74     function min64(uint64 a, uint64 b)
75         internal
76         pure
77         returns (uint256)
78     {
79         return a < b ? a : b;
80     }
81 
82     function max256(uint256 a, uint256 b)
83         internal
84         pure
85         returns (uint256)
86     {
87         return a >= b ? a : b;
88     }
89 
90     function min256(uint256 a, uint256 b)
91         internal
92         pure
93         returns (uint256)
94     {
95         return a < b ? a : b;
96     }
97 }
98 
99 
100 /**
101  * @title BytesToTypes
102  * @dev The BytesToTypes contract converts the memory byte arrays to the standard solidity types
103  */
104 
105 contract BytesToTypes {
106 
107 
108     function bytesToAddress(uint _offst, bytes memory _input) internal pure returns (address _output) {
109 
110         assembly {
111             _output := mload(add(_input, _offst))
112         }
113     }
114 
115     function bytesToBool(uint _offst, bytes memory _input) internal pure returns (bool _output) {
116 
117         uint8 x;
118         assembly {
119             x := mload(add(_input, _offst))
120         }
121         x==0 ? _output = false : _output = true;
122     }
123 
124     function getStringSize(uint _offst, bytes memory _input) internal pure returns(uint size){
125 
126         assembly{
127 
128             size := mload(add(_input,_offst))
129             let chunk_count := add(div(size,32),1) // chunk_count = size/32 + 1
130 
131             if gt(mod(size,32),0) {// if size%32 > 0
132                 chunk_count := add(chunk_count,1)
133             }
134 
135              size := mul(chunk_count,32)// first 32 bytes reseves for size in strings
136         }
137     }
138 
139     function bytesToString(uint _offst, bytes memory _input, bytes memory _output) internal  {
140 
141         uint size = 32;
142         assembly {
143             let loop_index:= 0
144 
145             let chunk_count
146 
147             size := mload(add(_input,_offst))
148             chunk_count := add(div(size,32),1) // chunk_count = size/32 + 1
149 
150             if gt(mod(size,32),0) {
151                 chunk_count := add(chunk_count,1)  // chunk_count++
152             }
153 
154 
155             loop:
156                 mstore(add(_output,mul(loop_index,32)),mload(add(_input,_offst)))
157                 _offst := sub(_offst,32)           // _offst -= 32
158                 loop_index := add(loop_index,1)
159 
160             jumpi(loop , lt(loop_index , chunk_count))
161 
162         }
163     }
164 
165     function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes) {
166         require(_bytes.length >= (_start + _length));
167 
168         bytes memory tempBytes;
169 
170         assembly {
171             switch iszero(_length)
172             case 0 {
173                 // Get a location of some free memory and store it in tempBytes as
174                 // Solidity does for memory variables.
175                 tempBytes := mload(0x40)
176 
177                 // The first word of the slice result is potentially a partial
178                 // word read from the original array. To read it, we calculate
179                 // the length of that partial word and start copying that many
180                 // bytes into the array. The first word we copy will start with
181                 // data we don't care about, but the last `lengthmod` bytes will
182                 // land at the beginning of the contents of the new array. When
183                 // we're done copying, we overwrite the full first word with
184                 // the actual length of the slice.
185                 let lengthmod := and(_length, 31)
186 
187                 // The multiplication in the next line is necessary
188                 // because when slicing multiples of 32 bytes (lengthmod == 0)
189                 // the following copy loop was copying the origin's length
190                 // and then ending prematurely not copying everything it should.
191                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
192                 let end := add(mc, _length)
193 
194                 for {
195                     // The multiplication in the next line has the same exact purpose
196                     // as the one above.
197                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
198                 } lt(mc, end) {
199                     mc := add(mc, 0x20)
200                     cc := add(cc, 0x20)
201                 } {
202                     mstore(mc, mload(cc))
203                 }
204 
205                 mstore(tempBytes, _length)
206 
207                 //update free-memory pointer
208                 //allocating the array padded to 32 bytes like the compiler does now
209                 mstore(0x40, and(add(mc, 31), not(31)))
210             }
211             //if we want a zero-length slice let's just return a zero-length array
212             default {
213                 tempBytes := mload(0x40)
214 
215                 mstore(0x40, add(tempBytes, 0x20))
216             }
217         }
218 
219         return tempBytes;
220     }
221 
222 
223     function bytesToBytes32(uint _offst, bytes memory  _input) internal pure returns (bytes32 _output) {
224 
225         assembly {
226             _output := mload(add(_input, _offst))
227         }
228     }
229 
230     function bytesToInt8(uint _offst, bytes memory  _input) internal pure returns (int8 _output) {
231 
232         assembly {
233             _output := mload(add(_input, _offst))
234         }
235     }
236 
237     function bytesToInt16(uint _offst, bytes memory _input) internal pure returns (int16 _output) {
238 
239         assembly {
240             _output := mload(add(_input, _offst))
241         }
242     }
243 
244     function bytesToInt24(uint _offst, bytes memory _input) internal pure returns (int24 _output) {
245 
246         assembly {
247             _output := mload(add(_input, _offst))
248         }
249     }
250 
251     function bytesToInt32(uint _offst, bytes memory _input) internal pure returns (int32 _output) {
252 
253         assembly {
254             _output := mload(add(_input, _offst))
255         }
256     }
257 
258     function bytesToInt40(uint _offst, bytes memory _input) internal pure returns (int40 _output) {
259 
260         assembly {
261             _output := mload(add(_input, _offst))
262         }
263     }
264 
265     function bytesToInt48(uint _offst, bytes memory _input) internal pure returns (int48 _output) {
266 
267         assembly {
268             _output := mload(add(_input, _offst))
269         }
270     }
271 
272     function bytesToInt56(uint _offst, bytes memory _input) internal pure returns (int56 _output) {
273 
274         assembly {
275             _output := mload(add(_input, _offst))
276         }
277     }
278 
279     function bytesToInt64(uint _offst, bytes memory _input) internal pure returns (int64 _output) {
280 
281         assembly {
282             _output := mload(add(_input, _offst))
283         }
284     }
285 
286     function bytesToInt72(uint _offst, bytes memory _input) internal pure returns (int72 _output) {
287 
288         assembly {
289             _output := mload(add(_input, _offst))
290         }
291     }
292 
293     function bytesToInt80(uint _offst, bytes memory _input) internal pure returns (int80 _output) {
294 
295         assembly {
296             _output := mload(add(_input, _offst))
297         }
298     }
299 
300     function bytesToInt88(uint _offst, bytes memory _input) internal pure returns (int88 _output) {
301 
302         assembly {
303             _output := mload(add(_input, _offst))
304         }
305     }
306 
307     function bytesToInt96(uint _offst, bytes memory _input) internal pure returns (int96 _output) {
308 
309         assembly {
310             _output := mload(add(_input, _offst))
311         }
312     }
313 
314 	function bytesToInt104(uint _offst, bytes memory _input) internal pure returns (int104 _output) {
315 
316         assembly {
317             _output := mload(add(_input, _offst))
318         }
319     }
320 
321     function bytesToInt112(uint _offst, bytes memory _input) internal pure returns (int112 _output) {
322 
323         assembly {
324             _output := mload(add(_input, _offst))
325         }
326     }
327 
328     function bytesToInt120(uint _offst, bytes memory _input) internal pure returns (int120 _output) {
329 
330         assembly {
331             _output := mload(add(_input, _offst))
332         }
333     }
334 
335     function bytesToInt128(uint _offst, bytes memory _input) internal pure returns (int128 _output) {
336 
337         assembly {
338             _output := mload(add(_input, _offst))
339         }
340     }
341 
342     function bytesToInt136(uint _offst, bytes memory _input) internal pure returns (int136 _output) {
343 
344         assembly {
345             _output := mload(add(_input, _offst))
346         }
347     }
348 
349     function bytesToInt144(uint _offst, bytes memory _input) internal pure returns (int144 _output) {
350 
351         assembly {
352             _output := mload(add(_input, _offst))
353         }
354     }
355 
356     function bytesToInt152(uint _offst, bytes memory _input) internal pure returns (int152 _output) {
357 
358         assembly {
359             _output := mload(add(_input, _offst))
360         }
361     }
362 
363     function bytesToInt160(uint _offst, bytes memory _input) internal pure returns (int160 _output) {
364 
365         assembly {
366             _output := mload(add(_input, _offst))
367         }
368     }
369 
370     function bytesToInt168(uint _offst, bytes memory _input) internal pure returns (int168 _output) {
371 
372         assembly {
373             _output := mload(add(_input, _offst))
374         }
375     }
376 
377     function bytesToInt176(uint _offst, bytes memory _input) internal pure returns (int176 _output) {
378 
379         assembly {
380             _output := mload(add(_input, _offst))
381         }
382     }
383 
384     function bytesToInt184(uint _offst, bytes memory _input) internal pure returns (int184 _output) {
385 
386         assembly {
387             _output := mload(add(_input, _offst))
388         }
389     }
390 
391     function bytesToInt192(uint _offst, bytes memory _input) internal pure returns (int192 _output) {
392 
393         assembly {
394             _output := mload(add(_input, _offst))
395         }
396     }
397 
398     function bytesToInt200(uint _offst, bytes memory _input) internal pure returns (int200 _output) {
399 
400         assembly {
401             _output := mload(add(_input, _offst))
402         }
403     }
404 
405     function bytesToInt208(uint _offst, bytes memory _input) internal pure returns (int208 _output) {
406 
407         assembly {
408             _output := mload(add(_input, _offst))
409         }
410     }
411 
412     function bytesToInt216(uint _offst, bytes memory _input) internal pure returns (int216 _output) {
413 
414         assembly {
415             _output := mload(add(_input, _offst))
416         }
417     }
418 
419     function bytesToInt224(uint _offst, bytes memory _input) internal pure returns (int224 _output) {
420 
421         assembly {
422             _output := mload(add(_input, _offst))
423         }
424     }
425 
426     function bytesToInt232(uint _offst, bytes memory _input) internal pure returns (int232 _output) {
427 
428         assembly {
429             _output := mload(add(_input, _offst))
430         }
431     }
432 
433     function bytesToInt240(uint _offst, bytes memory _input) internal pure returns (int240 _output) {
434 
435         assembly {
436             _output := mload(add(_input, _offst))
437         }
438     }
439 
440     function bytesToInt248(uint _offst, bytes memory _input) internal pure returns (int248 _output) {
441 
442         assembly {
443             _output := mload(add(_input, _offst))
444         }
445     }
446 
447     function bytesToInt256(uint _offst, bytes memory _input) internal pure returns (int256 _output) {
448 
449         assembly {
450             _output := mload(add(_input, _offst))
451         }
452     }
453 
454 	function bytesToUint8(uint _offst, bytes memory _input) internal pure returns (uint8 _output) {
455 
456         assembly {
457             _output := mload(add(_input, _offst))
458         }
459     }
460 
461 	function bytesToUint16(uint _offst, bytes memory _input) internal pure returns (uint16 _output) {
462 
463         assembly {
464             _output := mload(add(_input, _offst))
465         }
466     }
467 
468 	function bytesToUint24(uint _offst, bytes memory _input) internal pure returns (uint24 _output) {
469 
470         assembly {
471             _output := mload(add(_input, _offst))
472         }
473     }
474 
475 	function bytesToUint32(uint _offst, bytes memory _input) internal pure returns (uint32 _output) {
476 
477         assembly {
478             _output := mload(add(_input, _offst))
479         }
480     }
481 
482 	function bytesToUint40(uint _offst, bytes memory _input) internal pure returns (uint40 _output) {
483 
484         assembly {
485             _output := mload(add(_input, _offst))
486         }
487     }
488 
489 	function bytesToUint48(uint _offst, bytes memory _input) internal pure returns (uint48 _output) {
490 
491         assembly {
492             _output := mload(add(_input, _offst))
493         }
494     }
495 
496 	function bytesToUint56(uint _offst, bytes memory _input) internal pure returns (uint56 _output) {
497 
498         assembly {
499             _output := mload(add(_input, _offst))
500         }
501     }
502 
503 	function bytesToUint64(uint _offst, bytes memory _input) internal pure returns (uint64 _output) {
504 
505         assembly {
506             _output := mload(add(_input, _offst))
507         }
508     }
509 
510 	function bytesToUint72(uint _offst, bytes memory _input) internal pure returns (uint72 _output) {
511 
512         assembly {
513             _output := mload(add(_input, _offst))
514         }
515     }
516 
517 	function bytesToUint80(uint _offst, bytes memory _input) internal pure returns (uint80 _output) {
518 
519         assembly {
520             _output := mload(add(_input, _offst))
521         }
522     }
523 
524 	function bytesToUint88(uint _offst, bytes memory _input) internal pure returns (uint88 _output) {
525 
526         assembly {
527             _output := mload(add(_input, _offst))
528         }
529     }
530 
531 	function bytesToUint96(uint _offst, bytes memory _input) internal pure returns (uint96 _output) {
532 
533         assembly {
534             _output := mload(add(_input, _offst))
535         }
536     }
537 
538 	function bytesToUint104(uint _offst, bytes memory _input) internal pure returns (uint104 _output) {
539 
540         assembly {
541             _output := mload(add(_input, _offst))
542         }
543     }
544 
545     function bytesToUint112(uint _offst, bytes memory _input) internal pure returns (uint112 _output) {
546 
547         assembly {
548             _output := mload(add(_input, _offst))
549         }
550     }
551 
552     function bytesToUint120(uint _offst, bytes memory _input) internal pure returns (uint120 _output) {
553 
554         assembly {
555             _output := mload(add(_input, _offst))
556         }
557     }
558 
559     function bytesToUint128(uint _offst, bytes memory _input) internal pure returns (uint128 _output) {
560 
561         assembly {
562             _output := mload(add(_input, _offst))
563         }
564     }
565 
566     function bytesToUint136(uint _offst, bytes memory _input) internal pure returns (uint136 _output) {
567 
568         assembly {
569             _output := mload(add(_input, _offst))
570         }
571     }
572 
573     function bytesToUint144(uint _offst, bytes memory _input) internal pure returns (uint144 _output) {
574 
575         assembly {
576             _output := mload(add(_input, _offst))
577         }
578     }
579 
580     function bytesToUint152(uint _offst, bytes memory _input) internal pure returns (uint152 _output) {
581 
582         assembly {
583             _output := mload(add(_input, _offst))
584         }
585     }
586 
587     function bytesToUint160(uint _offst, bytes memory _input) internal pure returns (uint160 _output) {
588 
589         assembly {
590             _output := mload(add(_input, _offst))
591         }
592     }
593 
594     function bytesToUint168(uint _offst, bytes memory _input) internal pure returns (uint168 _output) {
595 
596         assembly {
597             _output := mload(add(_input, _offst))
598         }
599     }
600 
601     function bytesToUint176(uint _offst, bytes memory _input) internal pure returns (uint176 _output) {
602 
603         assembly {
604             _output := mload(add(_input, _offst))
605         }
606     }
607 
608     function bytesToUint184(uint _offst, bytes memory _input) internal pure returns (uint184 _output) {
609 
610         assembly {
611             _output := mload(add(_input, _offst))
612         }
613     }
614 
615     function bytesToUint192(uint _offst, bytes memory _input) internal pure returns (uint192 _output) {
616 
617         assembly {
618             _output := mload(add(_input, _offst))
619         }
620     }
621 
622     function bytesToUint200(uint _offst, bytes memory _input) internal pure returns (uint200 _output) {
623 
624         assembly {
625             _output := mload(add(_input, _offst))
626         }
627     }
628 
629     function bytesToUint208(uint _offst, bytes memory _input) internal pure returns (uint208 _output) {
630 
631         assembly {
632             _output := mload(add(_input, _offst))
633         }
634     }
635 
636     function bytesToUint216(uint _offst, bytes memory _input) internal pure returns (uint216 _output) {
637 
638         assembly {
639             _output := mload(add(_input, _offst))
640         }
641     }
642 
643     function bytesToUint224(uint _offst, bytes memory _input) internal pure returns (uint224 _output) {
644 
645         assembly {
646             _output := mload(add(_input, _offst))
647         }
648     }
649 
650     function bytesToUint232(uint _offst, bytes memory _input) internal pure returns (uint232 _output) {
651 
652         assembly {
653             _output := mload(add(_input, _offst))
654         }
655     }
656 
657     function bytesToUint240(uint _offst, bytes memory _input) internal pure returns (uint240 _output) {
658 
659         assembly {
660             _output := mload(add(_input, _offst))
661         }
662     }
663 
664     function bytesToUint248(uint _offst, bytes memory _input) internal pure returns (uint248 _output) {
665 
666         assembly {
667             _output := mload(add(_input, _offst))
668         }
669     }
670 
671     function bytesToUint256(uint _offst, bytes memory _input) internal pure returns (uint256 _output) {
672 
673         assembly {
674             _output := mload(add(_input, _offst))
675         }
676     }
677 
678 }
679 
680 interface ITradeable {
681 
682     /// @param _owner The address from which the balance will be retrieved
683     /// @return The balance
684     function balanceOf(address _owner) external view returns (uint balance);
685 
686     /// @notice send `_value` token to `_to` from `msg.sender`
687     /// @param _to The address of the recipient
688     /// @param _value The amount of token to be transferred
689     /// @return Whether the transfer was successful or not
690     function transfer(address _to, uint _value) external returns (bool success);
691 
692     /// @param _from The address of the sender
693     /// @param _to The address of the recipient
694     /// @param _value The amount of token to be transferred
695     /// @return Whether the transfer was successful or not
696     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
697 
698     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
699     /// @param _spender The address of the account able to transfer the tokens
700     /// @param _value The amount of wei to be approved for transfer
701     /// @return Whether the approval was successful or not
702     function approve(address _spender, uint _value) external returns (bool success);
703 
704     /// @param _owner The address of the account owning tokens
705     /// @param _spender The address of the account able to transfer the tokens
706     /// @return Amount of remaining tokens allowed to spent
707     function allowance(address _owner, address _spender) external view returns (uint remaining);
708 }
709 
710 
711 contract ITrader {
712 
713   function getDataLength(
714   ) public pure returns (uint256);
715 
716   function getProtocol(
717   ) public pure returns (uint8);
718 
719   function getAvailableVolume(
720     bytes orderData
721   ) public view returns(uint);
722 
723   function isExpired(
724     bytes orderData
725   ) public view returns (bool);
726 
727   function trade(
728     bool isSell,
729     bytes orderData,
730     uint volume,
731     uint volumeEth
732   ) public;
733 
734   function getFillVolumes(
735     bool isSell,
736     bytes orderData,
737     uint volume,
738     uint volumeEth
739   ) public view returns(uint, uint);
740 
741 }
742 
743 contract ITraders {
744 
745   /// @dev Add a valid trader address. Only owner.
746   function addTrader(uint8 id, ITrader trader) public;
747 
748   /// @dev Remove a trader address. Only owner.
749   function removeTrader(uint8 id) public;
750 
751   /// @dev Get trader by id.
752   function getTrader(uint8 id) public view returns(ITrader);
753 
754   /// @dev Check if an address is a valid trader.
755   function isValidTraderAddress(address addr) public view returns(bool);
756 
757 }
758 
759 contract Members is Ownable {
760 
761   mapping(address => bool) public members; // Mappings of addresses of allowed addresses
762 
763   modifier onlyMembers() {
764     require(isValidMember(msg.sender));
765     _;
766   }
767 
768   /// @dev Check if an address is a valid member.
769   function isValidMember(address _member) public view returns(bool) {
770     return members[_member];
771   }
772 
773   /// @dev Add a valid member address. Only owner.
774   function addMember(address _member) public onlyOwner {
775     members[_member] = true;
776   }
777 
778   /// @dev Remove a member address. Only owner.
779   function removeMember(address _member) public onlyOwner {
780     delete members[_member];
781   }
782 }
783 
784 contract ZodiacERC20 is Ownable, BytesToTypes {
785   ITraders public traders; // Smart contract that hold the list of valid traders
786   bool public tradingEnabled; // Switch to enable or disable the contract
787   uint feePercentage;
788   event Sell(
789     address account,
790     address destinationAddr,
791     address traedeable,
792     uint volume,
793     uint volumeEth,
794     uint volumeEffective,
795     uint volumeEthEffective
796   );
797   event Buy(
798     address account,
799     address destinationAddr,
800     address traedeable,
801     uint volume,
802     uint volumeEth,
803     uint volumeEffective,
804     uint volumeEthEffective
805   );
806 
807 
808   function ZodiacERC20(ITraders _traders, uint _feePercentage) public {
809     traders = _traders;
810     tradingEnabled = true;
811     feePercentage = _feePercentage;
812   }
813 
814   /// @dev Only accepts payment from smart contract traders.
815   function() public payable {
816   //  require(traders.isValidTraderAddress(msg.sender));
817   }
818 
819   function changeFeePercentage(uint _feePercentage) public onlyOwner {
820     feePercentage = _feePercentage;
821   }
822 
823   /// @dev Setter for traders smart contract (Only owner)
824   function changeTraders(ITraders _traders) public onlyOwner {
825     traders = _traders;
826   }
827 
828   /// @dev Enable/Disable trading with smart contract (Only owner)
829   function changeTradingEnabled(bool enabled) public onlyOwner {
830     tradingEnabled = enabled;
831   }
832 
833   /// @dev Buy a token.
834   function buy(
835     ITradeable tradeable,
836     uint volume,
837     bytes ordersData,
838     address destinationAddr,
839     address affiliate
840   ) external payable
841   {
842 
843     require(tradingEnabled);
844 
845     // Execute the trade (at most fullfilling volume)
846     trade(
847       false,
848       tradeable,
849       volume,
850       ordersData,
851       affiliate
852     );
853 
854     // Since our balance before trade was 0. What we bought is our current balance.
855     uint volumeEffective = tradeable.balanceOf(this);
856 
857     // We make sure that something was traded
858     require(volumeEffective > 0);
859 
860     // Used ethers are: balance_before - balance_after.
861     // And since before call balance=0; then balance_before = msg.value
862     uint volumeEthEffective = SafeMath.safeSub(msg.value, address(this).balance);
863 
864     // IMPORTANT: Check that: effective_price <= agreed_price (guarantee a good deal for the buyer)
865     require(
866       SafeMath.safeDiv(volumeEthEffective, volumeEffective) <=
867       SafeMath.safeDiv(msg.value, volume)
868     );
869 
870     // Return remaining ethers
871     if(address(this).balance > 0) {
872       destinationAddr.transfer(address(this).balance);
873     }
874 
875     // Send the tokens
876     transferTradeable(tradeable, destinationAddr, volumeEffective);
877 
878     emit Buy(msg.sender, destinationAddr, tradeable, volume, msg.value, volumeEffective, volumeEthEffective);
879   }
880 
881   /// @dev sell a token.
882   function sell(
883     ITradeable tradeable,
884     uint volume,
885     uint volumeEth,
886     bytes ordersData,
887     address destinationAddr,
888     address affiliate
889   ) external
890   {
891     require(tradingEnabled);
892 
893     // We transfer to ouselves the user's trading volume, to operate on it
894     // note: Our balance is 0 before this
895     require(tradeable.transferFrom(msg.sender, this, volume));
896 
897     // Execute the trade (at most fullfilling volume)
898     trade(
899       true,
900       tradeable,
901       volume,
902       ordersData,
903       affiliate
904     );
905 
906     // Check how much we traded. Our balance = volume - tradedVolume
907     // then: tradedVolume = volume - balance
908     uint volumeEffective = SafeMath.safeSub(volume, tradeable.balanceOf(this));
909 
910     // We make sure that something was traded
911     require(volumeEffective > 0);
912 
913     // Collects service fee
914     uint volumeEthEffective = collectSellFee();
915 
916     // IMPORTANT: Check that: effective_price >= agreed_price (guarantee a good deal for the seller)
917     require(
918       SafeMath.safeDiv(volumeEthEffective, volumeEffective) >=
919       SafeMath.safeDiv(volumeEth, volume)
920     );
921 
922     // Return remaining volume
923     if (volumeEffective < volume) {
924      transferTradeable(tradeable, destinationAddr, SafeMath.safeSub(volume, volumeEffective));
925     }
926 
927     // Send ethers obtained
928     destinationAddr.transfer(volumeEthEffective);
929 
930     emit Sell(msg.sender, destinationAddr, tradeable, volume, volumeEth, volumeEffective, volumeEthEffective);
931   }
932 
933 
934   /// @dev Trade buy or sell orders.
935   function trade(
936     bool isSell,
937     ITradeable tradeable,
938     uint volume,
939     bytes ordersData,
940     address affiliate
941   ) internal
942   {
943     uint remainingVolume = volume;
944     uint offset = ordersData.length;
945 
946     while(offset > 0 && remainingVolume > 0) {
947       //Get the trader
948       uint8 protocolId = bytesToUint8(offset, ordersData);
949       ITrader trader = traders.getTrader(protocolId);
950       require(trader != address(0));
951 
952       //Get the order data
953       uint dataLength = trader.getDataLength();
954       offset = SafeMath.safeSub(offset, dataLength);
955       bytes memory orderData = slice(ordersData, offset, dataLength);
956 
957       //Fill order
958       remainingVolume = fillOrder(
959          isSell,
960          tradeable,
961          trader,
962          remainingVolume,
963          orderData,
964          affiliate
965       );
966     }
967   }
968 
969   /// @dev Fills a buy order.
970   function fillOrder(
971     bool isSell,
972     ITradeable tradeable,
973     ITrader trader,
974     uint remaining,
975     bytes memory orderData,
976     address affiliate
977     ) internal returns(uint)
978   {
979 
980     //Checks that there is enoughh amount to execute the trade
981     uint volume;
982     uint volumeEth;
983     (volume, volumeEth) = trader.getFillVolumes(
984       isSell,
985       orderData,
986       remaining,
987       address(this).balance
988     );
989 
990     if(volume > 0) {
991 
992       if(isSell) {
993         //Approve available amount of token to trader
994         require(tradeable.approve(trader, volume));
995       } else {
996         //Collects service fee
997         //TODO: transfer fees after all iteration
998         //volumeEth = collectBuyFee(volumeEth, affiliate);
999         volumeEth = collectFee(volumeEth);
1000         address(trader).transfer(volumeEth);
1001       }
1002 
1003       //Call trader to trade orders
1004       trader.trade(
1005         isSell,
1006         orderData,
1007         volume,
1008         volumeEth
1009       );
1010 
1011     }
1012 
1013     return SafeMath.safeSub(remaining, volume);
1014   }
1015 
1016   /// @dev Transfer tradeables to user account.
1017   function transferTradeable(ITradeable tradeable, address account, uint amount) internal {
1018     require(tradeable.transfer(account, amount));
1019   }
1020 
1021   // @dev Collect service/affiliate fee for a buy
1022   function collectFee(uint ethers) internal returns(uint) {
1023     uint fee = SafeMath.safeMul(ethers, feePercentage) / (1 ether);
1024     owner.transfer(fee);
1025     uint remaining = SafeMath.safeSub(ethers, fee);
1026     return remaining;
1027   }
1028 
1029   // @dev Collect service/affiliate fee for a sell
1030   function collectSellFee() internal returns(uint) {
1031     uint fee = SafeMath.safeMul(address(this).balance, feePercentage) / (1 ether);
1032     owner.transfer(fee);
1033     return address(this).balance;
1034   }
1035 
1036 }