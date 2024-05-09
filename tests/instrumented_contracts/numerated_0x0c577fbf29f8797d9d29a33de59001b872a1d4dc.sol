1 /*
2 
3   Copyright 2018 Dexdex.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity ^0.4.21;
20 
21 
22 /*
23  * Ownable
24  *
25  * Base contract with an owner.
26  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
27  */
28 
29 contract Ownable {
30     address public owner;
31 
32     function Ownable()
33         public
34     {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner)
44         public
45         onlyOwner
46     {
47         if (newOwner != address(0)) {
48             owner = newOwner;
49         }
50     }
51 }
52 
53 library SafeMath {
54     function safeMul(uint a, uint b)
55         internal
56         pure
57         returns (uint256)
58     {
59         uint c = a * b;
60         assert(a == 0 || c / a == b);
61         return c;
62     }
63 
64     function safeDiv(uint a, uint b)
65         internal
66         pure
67         returns (uint256)
68     {
69         uint c = a / b;
70         return c;
71     }
72 
73     function safeSub(uint a, uint b)
74         internal
75         pure
76         returns (uint256)
77     {
78         assert(b <= a);
79         return a - b;
80     }
81 
82     function safeAdd(uint a, uint b)
83         internal
84         pure
85         returns (uint256)
86     {
87         uint c = a + b;
88         assert(c >= a);
89         return c;
90     }
91 
92     function max64(uint64 a, uint64 b)
93         internal
94         pure
95         returns (uint256)
96     {
97         return a >= b ? a : b;
98     }
99 
100     function min64(uint64 a, uint64 b)
101         internal
102         pure
103         returns (uint256)
104     {
105         return a < b ? a : b;
106     }
107 
108     function max256(uint256 a, uint256 b)
109         internal
110         pure
111         returns (uint256)
112     {
113         return a >= b ? a : b;
114     }
115 
116     function min256(uint256 a, uint256 b)
117         internal
118         pure
119         returns (uint256)
120     {
121         return a < b ? a : b;
122     }
123 }
124 
125 
126 /**
127  * @title BytesToTypes
128  * @dev The BytesToTypes contract converts the memory byte arrays to the standard solidity types
129  * @author pouladzade@gmail.com
130  */
131 
132 contract BytesToTypes {
133     
134 
135     function bytesToAddress(uint _offst, bytes memory _input) internal pure returns (address _output) {
136         
137         assembly {
138             _output := mload(add(_input, _offst))
139         }
140     } 
141     
142     function bytesToBool(uint _offst, bytes memory _input) internal pure returns (bool _output) {
143         
144         uint8 x;
145         assembly {
146             x := mload(add(_input, _offst))
147         }
148         x==0 ? _output = false : _output = true;
149     }   
150         
151     function getStringSize(uint _offst, bytes memory _input) internal pure returns(uint size){
152         
153         assembly{
154             
155             size := mload(add(_input,_offst))
156             let chunk_count := add(div(size,32),1) // chunk_count = size/32 + 1
157             
158             if gt(mod(size,32),0) {// if size%32 > 0
159                 chunk_count := add(chunk_count,1)
160             } 
161             
162              size := mul(chunk_count,32)// first 32 bytes reseves for size in strings
163         }
164     }
165 
166     function bytesToString(uint _offst, bytes memory _input, bytes memory _output) internal  {
167 
168         uint size = 32;
169         assembly {
170             let loop_index:= 0
171                   
172             let chunk_count
173             
174             size := mload(add(_input,_offst))
175             chunk_count := add(div(size,32),1) // chunk_count = size/32 + 1
176             
177             if gt(mod(size,32),0) {
178                 chunk_count := add(chunk_count,1)  // chunk_count++
179             }
180                 
181             
182             loop:
183                 mstore(add(_output,mul(loop_index,32)),mload(add(_input,_offst)))
184                 _offst := sub(_offst,32)           // _offst -= 32
185                 loop_index := add(loop_index,1)
186                 
187             jumpi(loop , lt(loop_index , chunk_count))
188             
189         }
190     }
191 
192     function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes) {
193         require(_bytes.length >= (_start + _length));
194 
195         bytes memory tempBytes;
196 
197         assembly {
198             switch iszero(_length)
199             case 0 {
200                 // Get a location of some free memory and store it in tempBytes as
201                 // Solidity does for memory variables.
202                 tempBytes := mload(0x40)
203 
204                 // The first word of the slice result is potentially a partial
205                 // word read from the original array. To read it, we calculate
206                 // the length of that partial word and start copying that many
207                 // bytes into the array. The first word we copy will start with
208                 // data we don't care about, but the last `lengthmod` bytes will
209                 // land at the beginning of the contents of the new array. When
210                 // we're done copying, we overwrite the full first word with
211                 // the actual length of the slice.
212                 let lengthmod := and(_length, 31)
213 
214                 // The multiplication in the next line is necessary
215                 // because when slicing multiples of 32 bytes (lengthmod == 0)
216                 // the following copy loop was copying the origin's length
217                 // and then ending prematurely not copying everything it should.
218                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
219                 let end := add(mc, _length)
220 
221                 for {
222                     // The multiplication in the next line has the same exact purpose
223                     // as the one above.
224                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
225                 } lt(mc, end) {
226                     mc := add(mc, 0x20)
227                     cc := add(cc, 0x20)
228                 } {
229                     mstore(mc, mload(cc))
230                 }
231 
232                 mstore(tempBytes, _length)
233 
234                 //update free-memory pointer
235                 //allocating the array padded to 32 bytes like the compiler does now
236                 mstore(0x40, and(add(mc, 31), not(31)))
237             }
238             //if we want a zero-length slice let's just return a zero-length array
239             default {
240                 tempBytes := mload(0x40)
241 
242                 mstore(0x40, add(tempBytes, 0x20))
243             }
244         }
245 
246         return tempBytes;
247     }
248 
249 
250     function bytesToBytes32(uint _offst, bytes memory  _input) internal pure returns (bytes32 _output) {
251 
252         assembly {
253             _output := mload(add(_input, _offst))
254         }
255     }
256 
257     /*function bytesToBytes32(uint _offst, bytes memory  _input, bytes32 _output) internal pure {
258         
259         assembly {
260             mstore(_output , add(_input, _offst))
261             mstore(add(_output,32) , add(add(_input, _offst),32))
262         }
263     }*/
264     
265     function bytesToInt8(uint _offst, bytes memory  _input) internal pure returns (int8 _output) {
266         
267         assembly {
268             _output := mload(add(_input, _offst))
269         }
270     }
271     
272     function bytesToInt16(uint _offst, bytes memory _input) internal pure returns (int16 _output) {
273         
274         assembly {
275             _output := mload(add(_input, _offst))
276         }
277     }
278 
279     function bytesToInt24(uint _offst, bytes memory _input) internal pure returns (int24 _output) {
280         
281         assembly {
282             _output := mload(add(_input, _offst))
283         }
284     }
285 
286     function bytesToInt32(uint _offst, bytes memory _input) internal pure returns (int32 _output) {
287         
288         assembly {
289             _output := mload(add(_input, _offst))
290         }
291     }
292 
293     function bytesToInt40(uint _offst, bytes memory _input) internal pure returns (int40 _output) {
294         
295         assembly {
296             _output := mload(add(_input, _offst))
297         }
298     }
299 
300     function bytesToInt48(uint _offst, bytes memory _input) internal pure returns (int48 _output) {
301         
302         assembly {
303             _output := mload(add(_input, _offst))
304         }
305     }
306 
307     function bytesToInt56(uint _offst, bytes memory _input) internal pure returns (int56 _output) {
308         
309         assembly {
310             _output := mload(add(_input, _offst))
311         }
312     }
313 
314     function bytesToInt64(uint _offst, bytes memory _input) internal pure returns (int64 _output) {
315         
316         assembly {
317             _output := mload(add(_input, _offst))
318         }
319     }
320 
321     function bytesToInt72(uint _offst, bytes memory _input) internal pure returns (int72 _output) {
322         
323         assembly {
324             _output := mload(add(_input, _offst))
325         }
326     }
327 
328     function bytesToInt80(uint _offst, bytes memory _input) internal pure returns (int80 _output) {
329         
330         assembly {
331             _output := mload(add(_input, _offst))
332         }
333     }
334 
335     function bytesToInt88(uint _offst, bytes memory _input) internal pure returns (int88 _output) {
336         
337         assembly {
338             _output := mload(add(_input, _offst))
339         }
340     }
341 
342     function bytesToInt96(uint _offst, bytes memory _input) internal pure returns (int96 _output) {
343         
344         assembly {
345             _output := mload(add(_input, _offst))
346         }
347     }
348 	
349 	function bytesToInt104(uint _offst, bytes memory _input) internal pure returns (int104 _output) {
350         
351         assembly {
352             _output := mload(add(_input, _offst))
353         }
354     }
355     
356     function bytesToInt112(uint _offst, bytes memory _input) internal pure returns (int112 _output) {
357         
358         assembly {
359             _output := mload(add(_input, _offst))
360         }
361     }
362 
363     function bytesToInt120(uint _offst, bytes memory _input) internal pure returns (int120 _output) {
364         
365         assembly {
366             _output := mload(add(_input, _offst))
367         }
368     }
369 
370     function bytesToInt128(uint _offst, bytes memory _input) internal pure returns (int128 _output) {
371         
372         assembly {
373             _output := mload(add(_input, _offst))
374         }
375     }
376 
377     function bytesToInt136(uint _offst, bytes memory _input) internal pure returns (int136 _output) {
378         
379         assembly {
380             _output := mload(add(_input, _offst))
381         }
382     }
383 
384     function bytesToInt144(uint _offst, bytes memory _input) internal pure returns (int144 _output) {
385         
386         assembly {
387             _output := mload(add(_input, _offst))
388         }
389     }
390 
391     function bytesToInt152(uint _offst, bytes memory _input) internal pure returns (int152 _output) {
392         
393         assembly {
394             _output := mload(add(_input, _offst))
395         }
396     }
397 
398     function bytesToInt160(uint _offst, bytes memory _input) internal pure returns (int160 _output) {
399         
400         assembly {
401             _output := mload(add(_input, _offst))
402         }
403     }
404 
405     function bytesToInt168(uint _offst, bytes memory _input) internal pure returns (int168 _output) {
406         
407         assembly {
408             _output := mload(add(_input, _offst))
409         }
410     }
411 
412     function bytesToInt176(uint _offst, bytes memory _input) internal pure returns (int176 _output) {
413         
414         assembly {
415             _output := mload(add(_input, _offst))
416         }
417     }
418 
419     function bytesToInt184(uint _offst, bytes memory _input) internal pure returns (int184 _output) {
420         
421         assembly {
422             _output := mload(add(_input, _offst))
423         }
424     }
425 
426     function bytesToInt192(uint _offst, bytes memory _input) internal pure returns (int192 _output) {
427         
428         assembly {
429             _output := mload(add(_input, _offst))
430         }
431     }
432 
433     function bytesToInt200(uint _offst, bytes memory _input) internal pure returns (int200 _output) {
434         
435         assembly {
436             _output := mload(add(_input, _offst))
437         }
438     }
439 
440     function bytesToInt208(uint _offst, bytes memory _input) internal pure returns (int208 _output) {
441         
442         assembly {
443             _output := mload(add(_input, _offst))
444         }
445     }
446 
447     function bytesToInt216(uint _offst, bytes memory _input) internal pure returns (int216 _output) {
448         
449         assembly {
450             _output := mload(add(_input, _offst))
451         }
452     }
453 
454     function bytesToInt224(uint _offst, bytes memory _input) internal pure returns (int224 _output) {
455         
456         assembly {
457             _output := mload(add(_input, _offst))
458         }
459     }
460 
461     function bytesToInt232(uint _offst, bytes memory _input) internal pure returns (int232 _output) {
462         
463         assembly {
464             _output := mload(add(_input, _offst))
465         }
466     }
467 
468     function bytesToInt240(uint _offst, bytes memory _input) internal pure returns (int240 _output) {
469         
470         assembly {
471             _output := mload(add(_input, _offst))
472         }
473     }
474 
475     function bytesToInt248(uint _offst, bytes memory _input) internal pure returns (int248 _output) {
476         
477         assembly {
478             _output := mload(add(_input, _offst))
479         }
480     }
481 
482     function bytesToInt256(uint _offst, bytes memory _input) internal pure returns (int256 _output) {
483         
484         assembly {
485             _output := mload(add(_input, _offst))
486         }
487     }
488 
489 	function bytesToUint8(uint _offst, bytes memory _input) internal pure returns (uint8 _output) {
490         
491         assembly {
492             _output := mload(add(_input, _offst))
493         }
494     } 
495 
496 	function bytesToUint16(uint _offst, bytes memory _input) internal pure returns (uint16 _output) {
497         
498         assembly {
499             _output := mload(add(_input, _offst))
500         }
501     } 
502 
503 	function bytesToUint24(uint _offst, bytes memory _input) internal pure returns (uint24 _output) {
504         
505         assembly {
506             _output := mload(add(_input, _offst))
507         }
508     } 
509 
510 	function bytesToUint32(uint _offst, bytes memory _input) internal pure returns (uint32 _output) {
511         
512         assembly {
513             _output := mload(add(_input, _offst))
514         }
515     } 
516 
517 	function bytesToUint40(uint _offst, bytes memory _input) internal pure returns (uint40 _output) {
518         
519         assembly {
520             _output := mload(add(_input, _offst))
521         }
522     } 
523 
524 	function bytesToUint48(uint _offst, bytes memory _input) internal pure returns (uint48 _output) {
525         
526         assembly {
527             _output := mload(add(_input, _offst))
528         }
529     } 
530 
531 	function bytesToUint56(uint _offst, bytes memory _input) internal pure returns (uint56 _output) {
532         
533         assembly {
534             _output := mload(add(_input, _offst))
535         }
536     } 
537 
538 	function bytesToUint64(uint _offst, bytes memory _input) internal pure returns (uint64 _output) {
539         
540         assembly {
541             _output := mload(add(_input, _offst))
542         }
543     } 
544 
545 	function bytesToUint72(uint _offst, bytes memory _input) internal pure returns (uint72 _output) {
546         
547         assembly {
548             _output := mload(add(_input, _offst))
549         }
550     } 
551 
552 	function bytesToUint80(uint _offst, bytes memory _input) internal pure returns (uint80 _output) {
553         
554         assembly {
555             _output := mload(add(_input, _offst))
556         }
557     } 
558 
559 	function bytesToUint88(uint _offst, bytes memory _input) internal pure returns (uint88 _output) {
560         
561         assembly {
562             _output := mload(add(_input, _offst))
563         }
564     } 
565 
566 	function bytesToUint96(uint _offst, bytes memory _input) internal pure returns (uint96 _output) {
567         
568         assembly {
569             _output := mload(add(_input, _offst))
570         }
571     } 
572 	
573 	function bytesToUint104(uint _offst, bytes memory _input) internal pure returns (uint104 _output) {
574         
575         assembly {
576             _output := mload(add(_input, _offst))
577         }
578     } 
579 
580     function bytesToUint112(uint _offst, bytes memory _input) internal pure returns (uint112 _output) {
581         
582         assembly {
583             _output := mload(add(_input, _offst))
584         }
585     } 
586 
587     function bytesToUint120(uint _offst, bytes memory _input) internal pure returns (uint120 _output) {
588         
589         assembly {
590             _output := mload(add(_input, _offst))
591         }
592     } 
593 
594     function bytesToUint128(uint _offst, bytes memory _input) internal pure returns (uint128 _output) {
595         
596         assembly {
597             _output := mload(add(_input, _offst))
598         }
599     } 
600 
601     function bytesToUint136(uint _offst, bytes memory _input) internal pure returns (uint136 _output) {
602         
603         assembly {
604             _output := mload(add(_input, _offst))
605         }
606     } 
607 
608     function bytesToUint144(uint _offst, bytes memory _input) internal pure returns (uint144 _output) {
609         
610         assembly {
611             _output := mload(add(_input, _offst))
612         }
613     } 
614 
615     function bytesToUint152(uint _offst, bytes memory _input) internal pure returns (uint152 _output) {
616         
617         assembly {
618             _output := mload(add(_input, _offst))
619         }
620     } 
621 
622     function bytesToUint160(uint _offst, bytes memory _input) internal pure returns (uint160 _output) {
623         
624         assembly {
625             _output := mload(add(_input, _offst))
626         }
627     } 
628 
629     function bytesToUint168(uint _offst, bytes memory _input) internal pure returns (uint168 _output) {
630         
631         assembly {
632             _output := mload(add(_input, _offst))
633         }
634     } 
635 
636     function bytesToUint176(uint _offst, bytes memory _input) internal pure returns (uint176 _output) {
637         
638         assembly {
639             _output := mload(add(_input, _offst))
640         }
641     } 
642 
643     function bytesToUint184(uint _offst, bytes memory _input) internal pure returns (uint184 _output) {
644         
645         assembly {
646             _output := mload(add(_input, _offst))
647         }
648     } 
649 
650     function bytesToUint192(uint _offst, bytes memory _input) internal pure returns (uint192 _output) {
651         
652         assembly {
653             _output := mload(add(_input, _offst))
654         }
655     } 
656 
657     function bytesToUint200(uint _offst, bytes memory _input) internal pure returns (uint200 _output) {
658         
659         assembly {
660             _output := mload(add(_input, _offst))
661         }
662     } 
663 
664     function bytesToUint208(uint _offst, bytes memory _input) internal pure returns (uint208 _output) {
665         
666         assembly {
667             _output := mload(add(_input, _offst))
668         }
669     } 
670 
671     function bytesToUint216(uint _offst, bytes memory _input) internal pure returns (uint216 _output) {
672         
673         assembly {
674             _output := mload(add(_input, _offst))
675         }
676     } 
677 
678     function bytesToUint224(uint _offst, bytes memory _input) internal pure returns (uint224 _output) {
679         
680         assembly {
681             _output := mload(add(_input, _offst))
682         }
683     } 
684 
685     function bytesToUint232(uint _offst, bytes memory _input) internal pure returns (uint232 _output) {
686         
687         assembly {
688             _output := mload(add(_input, _offst))
689         }
690     } 
691 
692     function bytesToUint240(uint _offst, bytes memory _input) internal pure returns (uint240 _output) {
693         
694         assembly {
695             _output := mload(add(_input, _offst))
696         }
697     } 
698 
699     function bytesToUint248(uint _offst, bytes memory _input) internal pure returns (uint248 _output) {
700         
701         assembly {
702             _output := mload(add(_input, _offst))
703         }
704     } 
705 
706     function bytesToUint256(uint _offst, bytes memory _input) internal pure returns (uint256 _output) {
707         
708         assembly {
709             _output := mload(add(_input, _offst))
710         }
711     } 
712     
713 }
714 
715 
716 interface ITradeable {
717     
718     /// @param _owner The address from which the balance will be retrieved
719     /// @return The balance
720     function balanceOf(address _owner) external view returns (uint balance);
721     
722     /// @notice send `_value` token to `_to` from `msg.sender`
723     /// @param _to The address of the recipient
724     /// @param _value The amount of token to be transferred
725     /// @return Whether the transfer was successful or not
726     function transfer(address _to, uint _value) external returns (bool success);
727 
728     /// @param _from The address of the sender
729     /// @param _to The address of the recipient
730     /// @param _value The amount of token to be transferred
731     /// @return Whether the transfer was successful or not
732     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
733 
734     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
735     /// @param _spender The address of the account able to transfer the tokens
736     /// @param _value The amount of wei to be approved for transfer
737     /// @return Whether the approval was successful or not
738     function approve(address _spender, uint _value) external returns (bool success);
739     
740     /// @param _owner The address of the account owning tokens
741     /// @param _spender The address of the account able to transfer the tokens
742     /// @return Amount of remaining tokens allowed to spent
743     function allowance(address _owner, address _spender) external view returns (uint remaining);
744 }
745 
746 
747 
748 contract ITrader {
749 
750   function getDataLength(
751   ) public pure returns (uint256);
752 
753   function getProtocol(
754   ) public pure returns (uint8);
755 
756   function getAvailableVolume(
757     bytes orderData
758   ) public view returns(uint);
759 
760   function isExpired(
761     bytes orderData
762   ) public view returns (bool); 
763 
764   function trade(
765     bool isSell,
766     bytes orderData,
767     uint volume,
768     uint volumeEth
769   ) public;
770   
771   function getFillVolumes(
772     bool isSell,
773     bytes orderData,
774     uint volume,
775     uint volumeEth
776   ) public view returns(uint, uint);
777 
778 }
779 
780 contract ITraders {
781 
782   /// @dev Add a valid trader address. Only owner.
783   function addTrader(uint8 id, ITrader trader) public;
784 
785   /// @dev Remove a trader address. Only owner.
786   function removeTrader(uint8 id) public;
787 
788   /// @dev Get trader by id.
789   function getTrader(uint8 id) public view returns(ITrader);
790 
791   /// @dev Check if an address is a valid trader.
792   function isValidTraderAddress(address addr) public view returns(bool);
793 
794 }
795 
796 contract Members is Ownable {
797 
798   mapping(address => bool) public members; // Mappings of addresses of allowed addresses
799 
800   modifier onlyMembers() {
801     require(isValidMember(msg.sender));
802     _;
803   }
804 
805   /// @dev Check if an address is a valid member.
806   function isValidMember(address _member) public view returns(bool) {
807     return members[_member];
808   }
809 
810   /// @dev Add a valid member address. Only owner.
811   function addMember(address _member) public onlyOwner {
812     members[_member] = true;
813   }
814 
815   /// @dev Remove a member address. Only owner.
816   function removeMember(address _member) public onlyOwner {
817     delete members[_member];
818   }
819 }
820 
821 
822 contract IFeeWallet {
823 
824   function getFee(
825     uint amount) public view returns(uint);
826 
827   function collect(
828     address _affiliate) public payable;
829 }
830 
831 
832 contract FeeWallet is IFeeWallet, Ownable, Members {
833 
834   address public serviceAccount; // Address of service account
835   uint public servicePercentage; // Percentage times (1 ether)
836   uint public affiliatePercentage; // Percentage times (1 ether)
837 
838   mapping (address => uint) public pendingWithdrawals; // Balances
839 
840   function FeeWallet(
841     address _serviceAccount,
842     uint _servicePercentage,
843     uint _affiliatePercentage) public
844   {
845     serviceAccount = _serviceAccount;
846     servicePercentage = _servicePercentage;
847     affiliatePercentage = _affiliatePercentage;
848   }
849 
850   /// @dev Set the new service account. Only owner.
851   function changeServiceAccount(address _serviceAccount) public onlyOwner {
852     serviceAccount = _serviceAccount;
853   }
854 
855   /// @dev Set the service percentage. Only owner.
856   function changeServicePercentage(uint _servicePercentage) public onlyOwner {
857     servicePercentage = _servicePercentage;
858   }
859 
860   /// @dev Set the affiliate percentage. Only owner.
861   function changeAffiliatePercentage(uint _affiliatePercentage) public onlyOwner {
862     affiliatePercentage = _affiliatePercentage;
863   }
864 
865   /// @dev Calculates the service fee for a specific amount. Only owner.
866   function getFee(uint amount) public view returns(uint)  {
867     return SafeMath.safeMul(amount, servicePercentage) / (1 ether);
868   }
869 
870   /// @dev Calculates the affiliate amount for a specific amount. Only owner.
871   function getAffiliateAmount(uint amount) public view returns(uint)  {
872     return SafeMath.safeMul(amount, affiliatePercentage) / (1 ether);
873   }
874 
875   /// @dev Collects fees according to last payment receivedi. Only valid smart contracts.
876   function collect(
877     address _affiliate) public payable onlyMembers
878   {
879     if(_affiliate == address(0))
880       pendingWithdrawals[serviceAccount] += msg.value;
881     else {
882       uint affiliateAmount = getAffiliateAmount(msg.value);
883       pendingWithdrawals[_affiliate] += affiliateAmount;
884       pendingWithdrawals[serviceAccount] += SafeMath.safeSub(msg.value, affiliateAmount);
885     }
886   }
887 
888   /// @dev Withdraw.
889   function withdraw() public {
890     uint amount = pendingWithdrawals[msg.sender];
891     pendingWithdrawals[msg.sender] = 0;
892     msg.sender.transfer(amount);
893   }
894 }
895 contract DexdexERC20 is Ownable, BytesToTypes {
896   string constant public VERSION = '2.0.0';
897 
898   ITraders public traders; // Smart contract that hold the list of valid traders
899   IFeeWallet public feeWallet; // Smart contract that hold the fees collected
900   bool public tradingEnabled; // Switch to enable or disable the contract
901 
902   event Sell(
903     address account,
904     address destinationAddr,
905     address traedeable,
906     uint volume,
907     uint volumeEth,
908     uint volumeEffective,
909     uint volumeEthEffective
910   );
911   event Buy(
912     address account,
913     address destinationAddr,
914     address traedeable,
915     uint volume,
916     uint volumeEth,
917     uint volumeEffective,
918     uint volumeEthEffective
919   );
920 
921 
922   function DexdexERC20(ITraders _traders, IFeeWallet _feeWallet) public {
923     traders = _traders;
924     feeWallet = _feeWallet;
925     tradingEnabled = true;
926   }
927 
928   /// @dev Only accepts payment from smart contract traders.
929   function() public payable {
930   //  require(traders.isValidTraderAddress(msg.sender));
931   }
932 
933   /// @dev Setter for feeWallet smart contract (Only owner)
934   function changeFeeWallet(IFeeWallet _feeWallet) public onlyOwner {
935     feeWallet = _feeWallet;
936   }
937 
938   /// @dev Setter for traders smart contract (Only owner)
939   function changeTraders(ITraders _traders) public onlyOwner {
940     traders = _traders;
941   }
942 
943   /// @dev Enable/Disable trading with smart contract (Only owner)
944   function changeTradingEnabled(bool enabled) public onlyOwner {
945     tradingEnabled = enabled;
946   }
947 
948   /// @dev Buy a token.
949   function buy(
950     ITradeable tradeable,
951     uint volume,
952     bytes ordersData,
953     address destinationAddr,
954     address affiliate
955   ) external payable
956   {
957 
958     require(tradingEnabled);
959 
960     // Execute the trade (at most fullfilling volume)
961     trade(
962       false,
963       tradeable,
964       volume,
965       ordersData,
966       affiliate
967     );
968 
969     // Since our balance before trade was 0. What we bought is our current balance.
970     uint volumeEffective = tradeable.balanceOf(this);
971 
972     // We make sure that something was traded
973     require(volumeEffective > 0);
974 
975     // Used ethers are: balance_before - balance_after.
976     // And since before call balance=0; then balance_before = msg.value
977     uint volumeEthEffective = SafeMath.safeSub(msg.value, address(this).balance);
978 
979     // IMPORTANT: Check that: effective_price <= agreed_price (guarantee a good deal for the buyer)
980     require(
981       SafeMath.safeDiv(volumeEthEffective, volumeEffective) <=
982       SafeMath.safeDiv(msg.value, volume)
983     );
984 
985     // Return remaining ethers
986     if(address(this).balance > 0) {
987       destinationAddr.transfer(address(this).balance);
988     }
989 
990     // Send the tokens
991     transferTradeable(tradeable, destinationAddr, volumeEffective);
992 
993     emit Buy(msg.sender, destinationAddr, tradeable, volume, msg.value, volumeEffective, volumeEthEffective);
994   }
995 
996   /// @dev sell a token.
997   function sell(
998     ITradeable tradeable,
999     uint volume,
1000     uint volumeEth,
1001     bytes ordersData,
1002     address destinationAddr,
1003     address affiliate
1004   ) external
1005   {
1006     require(tradingEnabled);
1007 
1008     // We transfer to ouselves the user's trading volume, to operate on it
1009     // note: Our balance is 0 before this
1010     require(tradeable.transferFrom(msg.sender, this, volume));
1011 
1012     // Execute the trade (at most fullfilling volume)
1013     trade(
1014       true,
1015       tradeable,
1016       volume,
1017       ordersData,
1018       affiliate
1019     );
1020 
1021     // Check how much we traded. Our balance = volume - tradedVolume
1022     // then: tradedVolume = volume - balance
1023     uint volumeEffective = SafeMath.safeSub(volume, tradeable.balanceOf(this));
1024 
1025     // We make sure that something was traded
1026     require(volumeEffective > 0);
1027 
1028     // Collects service fee
1029     uint volumeEthEffective = collectSellFee(affiliate);
1030 
1031     // IMPORTANT: Check that: effective_price >= agreed_price (guarantee a good deal for the seller)
1032     require(
1033       SafeMath.safeDiv(volumeEthEffective, volumeEffective) >=
1034       SafeMath.safeDiv(volumeEth, volume)
1035     );
1036 
1037     // Return remaining volume
1038     if (volumeEffective < volume) {
1039      transferTradeable(tradeable, destinationAddr, SafeMath.safeSub(volume, volumeEffective));
1040     }
1041 
1042     // Send ethers obtained
1043     destinationAddr.transfer(volumeEthEffective);
1044 
1045     emit Sell(msg.sender, destinationAddr, tradeable, volume, volumeEth, volumeEffective, volumeEthEffective);
1046   }
1047 
1048 
1049   /// @dev Trade buy or sell orders.
1050   function trade(
1051     bool isSell,
1052     ITradeable tradeable,
1053     uint volume,
1054     bytes ordersData,
1055     address affiliate
1056   ) internal
1057   {
1058     uint remainingVolume = volume;
1059     uint offset = ordersData.length;
1060 
1061     while(offset > 0 && remainingVolume > 0) {
1062       //Get the trader
1063       uint8 protocolId = bytesToUint8(offset, ordersData);
1064       ITrader trader = traders.getTrader(protocolId);
1065       require(trader != address(0));
1066 
1067       //Get the order data
1068       uint dataLength = trader.getDataLength();
1069       offset = SafeMath.safeSub(offset, dataLength);
1070       bytes memory orderData = slice(ordersData, offset, dataLength);
1071 
1072       //Fill order
1073       remainingVolume = fillOrder(
1074          isSell,
1075          tradeable,
1076          trader,
1077          remainingVolume,
1078          orderData,
1079          affiliate
1080       );
1081     }
1082   }
1083 
1084   /// @dev Fills a buy order.
1085   function fillOrder(
1086     bool isSell,
1087     ITradeable tradeable,
1088     ITrader trader,
1089     uint remaining,
1090     bytes memory orderData,
1091     address affiliate
1092     ) internal returns(uint)
1093   {
1094 
1095     //Checks that there is enoughh amount to execute the trade
1096     uint volume;
1097     uint volumeEth;
1098     (volume, volumeEth) = trader.getFillVolumes(
1099       isSell,
1100       orderData,
1101       remaining,
1102       address(this).balance
1103     );
1104 
1105     if(volume > 0) {
1106 
1107       if(isSell) {
1108         //Approve available amount of token to trader
1109         require(tradeable.approve(trader, volume));
1110       } else {
1111         //Collects service fee
1112         //TODO: transfer fees after all iteration
1113         volumeEth = collectBuyFee(volumeEth, affiliate);
1114         address(trader).transfer(volumeEth);
1115       }
1116 
1117       //Call trader to trade orders
1118       trader.trade(
1119         isSell,
1120         orderData,
1121         volume,
1122         volumeEth
1123       );
1124 
1125     }
1126 
1127     return SafeMath.safeSub(remaining, volume);
1128   }
1129 
1130   /// @dev Transfer tradeables to user account.
1131   function transferTradeable(ITradeable tradeable, address account, uint amount) internal {
1132     require(tradeable.transfer(account, amount));
1133   }
1134 
1135   // @dev Collect service/affiliate fee for a buy
1136   function collectBuyFee(uint ethers, address affiliate) internal returns(uint) {
1137     uint remaining;
1138     uint fee = feeWallet.getFee(ethers);
1139     //If there is enough remaining to pay fee, it substract from the balance
1140     if(SafeMath.safeSub(address(this).balance, ethers) >= fee)
1141       remaining = ethers;
1142     else
1143       remaining = SafeMath.safeSub(SafeMath.safeSub(ethers, address(this).balance), fee);
1144     feeWallet.collect.value(fee)(affiliate);
1145     return remaining;
1146   }
1147 
1148   // @dev Collect service/affiliate fee for a sell
1149   function collectSellFee(address affiliate) internal returns(uint) {
1150     uint fee = feeWallet.getFee(address(this).balance);
1151     feeWallet.collect.value(fee)(affiliate);
1152     return address(this).balance;
1153   }
1154 
1155 }