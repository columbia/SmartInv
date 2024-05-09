1 pragma solidity ^0.4.24;
2 
3 
4 /*
5  * Ownable
6  *
7  * Base contract with an owner.
8  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
9  */
10 
11 contract Ownable {
12     address public owner;
13 
14     constructor()
15         public
16     {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function transferOwnership(address newOwner)
26         public
27         onlyOwner
28     {
29         if (newOwner != address(0)) {
30             owner = newOwner;
31         }
32     }
33 }
34 
35 library SafeMath {
36     function safeMul(uint a, uint b)
37         internal
38         pure
39         returns (uint256)
40     {
41         uint c = a * b;
42         assert(a == 0 || c / a == b);
43         return c;
44     }
45 
46     function safeDiv(uint a, uint b)
47         internal
48         pure
49         returns (uint256)
50     {
51         uint c = a / b;
52         return c;
53     }
54 
55     function safeSub(uint a, uint b)
56         internal
57         pure
58         returns (uint256)
59     {
60         assert(b <= a);
61         return a - b;
62     }
63 
64     function safeAdd(uint a, uint b)
65         internal
66         pure
67         returns (uint256)
68     {
69         uint c = a + b;
70         assert(c >= a);
71         return c;
72     }
73 
74     function max64(uint64 a, uint64 b)
75         internal
76         pure
77         returns (uint256)
78     {
79         return a >= b ? a : b;
80     }
81 
82     function min64(uint64 a, uint64 b)
83         internal
84         pure
85         returns (uint256)
86     {
87         return a < b ? a : b;
88     }
89 
90     function max256(uint256 a, uint256 b)
91         internal
92         pure
93         returns (uint256)
94     {
95         return a >= b ? a : b;
96     }
97 
98     function min256(uint256 a, uint256 b)
99         internal
100         pure
101         returns (uint256)
102     {
103         return a < b ? a : b;
104     }
105 }
106 
107 
108 /**
109  * @title BytesToTypes
110  * @dev The BytesToTypes contract converts the memory byte arrays to the standard solidity types
111  * @author pouladzade@gmail.com
112  */
113 
114 contract BytesToTypes {
115     
116 
117     function bytesToAddress(uint _offst, bytes memory _input) internal pure returns (address _output) {
118         
119         assembly {
120             _output := mload(add(_input, _offst))
121         }
122     } 
123     
124     function bytesToBool(uint _offst, bytes memory _input) internal pure returns (bool _output) {
125         
126         uint8 x;
127         assembly {
128             x := mload(add(_input, _offst))
129         }
130         x==0 ? _output = false : _output = true;
131     }   
132         
133     function getStringSize(uint _offst, bytes memory _input) internal pure returns(uint size){
134         
135         assembly{
136             
137             size := mload(add(_input,_offst))
138             let chunk_count := add(div(size,32),1) // chunk_count = size/32 + 1
139             
140             if gt(mod(size,32),0) {// if size%32 > 0
141                 chunk_count := add(chunk_count,1)
142             } 
143             
144              size := mul(chunk_count,32)// first 32 bytes reseves for size in strings
145         }
146     }
147 
148     function bytesToString(uint _offst, bytes memory _input, bytes memory _output) internal  {
149 
150         uint size = 32;
151         assembly {
152             let loop_index:= 0
153                   
154             let chunk_count
155             
156             size := mload(add(_input,_offst))
157             chunk_count := add(div(size,32),1) // chunk_count = size/32 + 1
158             
159             if gt(mod(size,32),0) {
160                 chunk_count := add(chunk_count,1)  // chunk_count++
161             }
162                 
163             
164             loop:
165                 mstore(add(_output,mul(loop_index,32)),mload(add(_input,_offst)))
166                 _offst := sub(_offst,32)           // _offst -= 32
167                 loop_index := add(loop_index,1)
168                 
169             jumpi(loop , lt(loop_index , chunk_count))
170             
171         }
172     }
173 
174     function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes) {
175         require(_bytes.length >= (_start + _length));
176 
177         bytes memory tempBytes;
178 
179         assembly {
180             switch iszero(_length)
181             case 0 {
182                 // Get a location of some free memory and store it in tempBytes as
183                 // Solidity does for memory variables.
184                 tempBytes := mload(0x40)
185 
186                 // The first word of the slice result is potentially a partial
187                 // word read from the original array. To read it, we calculate
188                 // the length of that partial word and start copying that many
189                 // bytes into the array. The first word we copy will start with
190                 // data we don't care about, but the last `lengthmod` bytes will
191                 // land at the beginning of the contents of the new array. When
192                 // we're done copying, we overwrite the full first word with
193                 // the actual length of the slice.
194                 let lengthmod := and(_length, 31)
195 
196                 // The multiplication in the next line is necessary
197                 // because when slicing multiples of 32 bytes (lengthmod == 0)
198                 // the following copy loop was copying the origin's length
199                 // and then ending prematurely not copying everything it should.
200                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
201                 let end := add(mc, _length)
202 
203                 for {
204                     // The multiplication in the next line has the same exact purpose
205                     // as the one above.
206                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
207                 } lt(mc, end) {
208                     mc := add(mc, 0x20)
209                     cc := add(cc, 0x20)
210                 } {
211                     mstore(mc, mload(cc))
212                 }
213 
214                 mstore(tempBytes, _length)
215 
216                 //update free-memory pointer
217                 //allocating the array padded to 32 bytes like the compiler does now
218                 mstore(0x40, and(add(mc, 31), not(31)))
219             }
220             //if we want a zero-length slice let's just return a zero-length array
221             default {
222                 tempBytes := mload(0x40)
223 
224                 mstore(0x40, add(tempBytes, 0x20))
225             }
226         }
227 
228         return tempBytes;
229     }
230 
231 
232     function bytesToBytes32(uint _offst, bytes memory  _input) internal pure returns (bytes32 _output) {
233 
234         assembly {
235             _output := mload(add(_input, _offst))
236         }
237     }
238 
239     /*function bytesToBytes32(uint _offst, bytes memory  _input, bytes32 _output) internal pure {
240         
241         assembly {
242             mstore(_output , add(_input, _offst))
243             mstore(add(_output,32) , add(add(_input, _offst),32))
244         }
245     }*/
246     
247     function bytesToInt8(uint _offst, bytes memory  _input) internal pure returns (int8 _output) {
248         
249         assembly {
250             _output := mload(add(_input, _offst))
251         }
252     }
253     
254     function bytesToInt16(uint _offst, bytes memory _input) internal pure returns (int16 _output) {
255         
256         assembly {
257             _output := mload(add(_input, _offst))
258         }
259     }
260 
261     function bytesToInt24(uint _offst, bytes memory _input) internal pure returns (int24 _output) {
262         
263         assembly {
264             _output := mload(add(_input, _offst))
265         }
266     }
267 
268     function bytesToInt32(uint _offst, bytes memory _input) internal pure returns (int32 _output) {
269         
270         assembly {
271             _output := mload(add(_input, _offst))
272         }
273     }
274 
275     function bytesToInt40(uint _offst, bytes memory _input) internal pure returns (int40 _output) {
276         
277         assembly {
278             _output := mload(add(_input, _offst))
279         }
280     }
281 
282     function bytesToInt48(uint _offst, bytes memory _input) internal pure returns (int48 _output) {
283         
284         assembly {
285             _output := mload(add(_input, _offst))
286         }
287     }
288 
289     function bytesToInt56(uint _offst, bytes memory _input) internal pure returns (int56 _output) {
290         
291         assembly {
292             _output := mload(add(_input, _offst))
293         }
294     }
295 
296     function bytesToInt64(uint _offst, bytes memory _input) internal pure returns (int64 _output) {
297         
298         assembly {
299             _output := mload(add(_input, _offst))
300         }
301     }
302 
303     function bytesToInt72(uint _offst, bytes memory _input) internal pure returns (int72 _output) {
304         
305         assembly {
306             _output := mload(add(_input, _offst))
307         }
308     }
309 
310     function bytesToInt80(uint _offst, bytes memory _input) internal pure returns (int80 _output) {
311         
312         assembly {
313             _output := mload(add(_input, _offst))
314         }
315     }
316 
317     function bytesToInt88(uint _offst, bytes memory _input) internal pure returns (int88 _output) {
318         
319         assembly {
320             _output := mload(add(_input, _offst))
321         }
322     }
323 
324     function bytesToInt96(uint _offst, bytes memory _input) internal pure returns (int96 _output) {
325         
326         assembly {
327             _output := mload(add(_input, _offst))
328         }
329     }
330 	
331 	function bytesToInt104(uint _offst, bytes memory _input) internal pure returns (int104 _output) {
332         
333         assembly {
334             _output := mload(add(_input, _offst))
335         }
336     }
337     
338     function bytesToInt112(uint _offst, bytes memory _input) internal pure returns (int112 _output) {
339         
340         assembly {
341             _output := mload(add(_input, _offst))
342         }
343     }
344 
345     function bytesToInt120(uint _offst, bytes memory _input) internal pure returns (int120 _output) {
346         
347         assembly {
348             _output := mload(add(_input, _offst))
349         }
350     }
351 
352     function bytesToInt128(uint _offst, bytes memory _input) internal pure returns (int128 _output) {
353         
354         assembly {
355             _output := mload(add(_input, _offst))
356         }
357     }
358 
359     function bytesToInt136(uint _offst, bytes memory _input) internal pure returns (int136 _output) {
360         
361         assembly {
362             _output := mload(add(_input, _offst))
363         }
364     }
365 
366     function bytesToInt144(uint _offst, bytes memory _input) internal pure returns (int144 _output) {
367         
368         assembly {
369             _output := mload(add(_input, _offst))
370         }
371     }
372 
373     function bytesToInt152(uint _offst, bytes memory _input) internal pure returns (int152 _output) {
374         
375         assembly {
376             _output := mload(add(_input, _offst))
377         }
378     }
379 
380     function bytesToInt160(uint _offst, bytes memory _input) internal pure returns (int160 _output) {
381         
382         assembly {
383             _output := mload(add(_input, _offst))
384         }
385     }
386 
387     function bytesToInt168(uint _offst, bytes memory _input) internal pure returns (int168 _output) {
388         
389         assembly {
390             _output := mload(add(_input, _offst))
391         }
392     }
393 
394     function bytesToInt176(uint _offst, bytes memory _input) internal pure returns (int176 _output) {
395         
396         assembly {
397             _output := mload(add(_input, _offst))
398         }
399     }
400 
401     function bytesToInt184(uint _offst, bytes memory _input) internal pure returns (int184 _output) {
402         
403         assembly {
404             _output := mload(add(_input, _offst))
405         }
406     }
407 
408     function bytesToInt192(uint _offst, bytes memory _input) internal pure returns (int192 _output) {
409         
410         assembly {
411             _output := mload(add(_input, _offst))
412         }
413     }
414 
415     function bytesToInt200(uint _offst, bytes memory _input) internal pure returns (int200 _output) {
416         
417         assembly {
418             _output := mload(add(_input, _offst))
419         }
420     }
421 
422     function bytesToInt208(uint _offst, bytes memory _input) internal pure returns (int208 _output) {
423         
424         assembly {
425             _output := mload(add(_input, _offst))
426         }
427     }
428 
429     function bytesToInt216(uint _offst, bytes memory _input) internal pure returns (int216 _output) {
430         
431         assembly {
432             _output := mload(add(_input, _offst))
433         }
434     }
435 
436     function bytesToInt224(uint _offst, bytes memory _input) internal pure returns (int224 _output) {
437         
438         assembly {
439             _output := mload(add(_input, _offst))
440         }
441     }
442 
443     function bytesToInt232(uint _offst, bytes memory _input) internal pure returns (int232 _output) {
444         
445         assembly {
446             _output := mload(add(_input, _offst))
447         }
448     }
449 
450     function bytesToInt240(uint _offst, bytes memory _input) internal pure returns (int240 _output) {
451         
452         assembly {
453             _output := mload(add(_input, _offst))
454         }
455     }
456 
457     function bytesToInt248(uint _offst, bytes memory _input) internal pure returns (int248 _output) {
458         
459         assembly {
460             _output := mload(add(_input, _offst))
461         }
462     }
463 
464     function bytesToInt256(uint _offst, bytes memory _input) internal pure returns (int256 _output) {
465         
466         assembly {
467             _output := mload(add(_input, _offst))
468         }
469     }
470 
471 	function bytesToUint8(uint _offst, bytes memory _input) internal pure returns (uint8 _output) {
472         
473         assembly {
474             _output := mload(add(_input, _offst))
475         }
476     } 
477 
478 	function bytesToUint16(uint _offst, bytes memory _input) internal pure returns (uint16 _output) {
479         
480         assembly {
481             _output := mload(add(_input, _offst))
482         }
483     } 
484 
485 	function bytesToUint24(uint _offst, bytes memory _input) internal pure returns (uint24 _output) {
486         
487         assembly {
488             _output := mload(add(_input, _offst))
489         }
490     } 
491 
492 	function bytesToUint32(uint _offst, bytes memory _input) internal pure returns (uint32 _output) {
493         
494         assembly {
495             _output := mload(add(_input, _offst))
496         }
497     } 
498 
499 	function bytesToUint40(uint _offst, bytes memory _input) internal pure returns (uint40 _output) {
500         
501         assembly {
502             _output := mload(add(_input, _offst))
503         }
504     } 
505 
506 	function bytesToUint48(uint _offst, bytes memory _input) internal pure returns (uint48 _output) {
507         
508         assembly {
509             _output := mload(add(_input, _offst))
510         }
511     } 
512 
513 	function bytesToUint56(uint _offst, bytes memory _input) internal pure returns (uint56 _output) {
514         
515         assembly {
516             _output := mload(add(_input, _offst))
517         }
518     } 
519 
520 	function bytesToUint64(uint _offst, bytes memory _input) internal pure returns (uint64 _output) {
521         
522         assembly {
523             _output := mload(add(_input, _offst))
524         }
525     } 
526 
527 	function bytesToUint72(uint _offst, bytes memory _input) internal pure returns (uint72 _output) {
528         
529         assembly {
530             _output := mload(add(_input, _offst))
531         }
532     } 
533 
534 	function bytesToUint80(uint _offst, bytes memory _input) internal pure returns (uint80 _output) {
535         
536         assembly {
537             _output := mload(add(_input, _offst))
538         }
539     } 
540 
541 	function bytesToUint88(uint _offst, bytes memory _input) internal pure returns (uint88 _output) {
542         
543         assembly {
544             _output := mload(add(_input, _offst))
545         }
546     } 
547 
548 	function bytesToUint96(uint _offst, bytes memory _input) internal pure returns (uint96 _output) {
549         
550         assembly {
551             _output := mload(add(_input, _offst))
552         }
553     } 
554 	
555 	function bytesToUint104(uint _offst, bytes memory _input) internal pure returns (uint104 _output) {
556         
557         assembly {
558             _output := mload(add(_input, _offst))
559         }
560     } 
561 
562     function bytesToUint112(uint _offst, bytes memory _input) internal pure returns (uint112 _output) {
563         
564         assembly {
565             _output := mload(add(_input, _offst))
566         }
567     } 
568 
569     function bytesToUint120(uint _offst, bytes memory _input) internal pure returns (uint120 _output) {
570         
571         assembly {
572             _output := mload(add(_input, _offst))
573         }
574     } 
575 
576     function bytesToUint128(uint _offst, bytes memory _input) internal pure returns (uint128 _output) {
577         
578         assembly {
579             _output := mload(add(_input, _offst))
580         }
581     } 
582 
583     function bytesToUint136(uint _offst, bytes memory _input) internal pure returns (uint136 _output) {
584         
585         assembly {
586             _output := mload(add(_input, _offst))
587         }
588     } 
589 
590     function bytesToUint144(uint _offst, bytes memory _input) internal pure returns (uint144 _output) {
591         
592         assembly {
593             _output := mload(add(_input, _offst))
594         }
595     } 
596 
597     function bytesToUint152(uint _offst, bytes memory _input) internal pure returns (uint152 _output) {
598         
599         assembly {
600             _output := mload(add(_input, _offst))
601         }
602     } 
603 
604     function bytesToUint160(uint _offst, bytes memory _input) internal pure returns (uint160 _output) {
605         
606         assembly {
607             _output := mload(add(_input, _offst))
608         }
609     } 
610 
611     function bytesToUint168(uint _offst, bytes memory _input) internal pure returns (uint168 _output) {
612         
613         assembly {
614             _output := mload(add(_input, _offst))
615         }
616     } 
617 
618     function bytesToUint176(uint _offst, bytes memory _input) internal pure returns (uint176 _output) {
619         
620         assembly {
621             _output := mload(add(_input, _offst))
622         }
623     } 
624 
625     function bytesToUint184(uint _offst, bytes memory _input) internal pure returns (uint184 _output) {
626         
627         assembly {
628             _output := mload(add(_input, _offst))
629         }
630     } 
631 
632     function bytesToUint192(uint _offst, bytes memory _input) internal pure returns (uint192 _output) {
633         
634         assembly {
635             _output := mload(add(_input, _offst))
636         }
637     } 
638 
639     function bytesToUint200(uint _offst, bytes memory _input) internal pure returns (uint200 _output) {
640         
641         assembly {
642             _output := mload(add(_input, _offst))
643         }
644     } 
645 
646     function bytesToUint208(uint _offst, bytes memory _input) internal pure returns (uint208 _output) {
647         
648         assembly {
649             _output := mload(add(_input, _offst))
650         }
651     } 
652 
653     function bytesToUint216(uint _offst, bytes memory _input) internal pure returns (uint216 _output) {
654         
655         assembly {
656             _output := mload(add(_input, _offst))
657         }
658     } 
659 
660     function bytesToUint224(uint _offst, bytes memory _input) internal pure returns (uint224 _output) {
661         
662         assembly {
663             _output := mload(add(_input, _offst))
664         }
665     } 
666 
667     function bytesToUint232(uint _offst, bytes memory _input) internal pure returns (uint232 _output) {
668         
669         assembly {
670             _output := mload(add(_input, _offst))
671         }
672     } 
673 
674     function bytesToUint240(uint _offst, bytes memory _input) internal pure returns (uint240 _output) {
675         
676         assembly {
677             _output := mload(add(_input, _offst))
678         }
679     } 
680 
681     function bytesToUint248(uint _offst, bytes memory _input) internal pure returns (uint248 _output) {
682         
683         assembly {
684             _output := mload(add(_input, _offst))
685         }
686     } 
687 
688     function bytesToUint256(uint _offst, bytes memory _input) internal pure returns (uint256 _output) {
689         
690         assembly {
691             _output := mload(add(_input, _offst))
692         }
693     } 
694     
695 }
696 
697 
698 interface ITradeable {
699     
700     /// @param _owner The address from which the balance will be retrieved
701     /// @return The balance
702     function balanceOf(address _owner) external view returns (uint balance);
703     
704     /// @notice send `_value` token to `_to` from `msg.sender`
705     /// @param _to The address of the recipient
706     /// @param _value The amount of token to be transferred
707     /// @return Whether the transfer was successful or not
708     function transfer(address _to, uint _value) external returns (bool success);
709 
710     /// @param _from The address of the sender
711     /// @param _to The address of the recipient
712     /// @param _value The amount of token to be transferred
713     /// @return Whether the transfer was successful or not
714     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
715 
716     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
717     /// @param _spender The address of the account able to transfer the tokens
718     /// @param _value The amount of wei to be approved for transfer
719     /// @return Whether the approval was successful or not
720     function approve(address _spender, uint _value) external returns (bool success);
721     
722     /// @param _owner The address of the account owning tokens
723     /// @param _spender The address of the account able to transfer the tokens
724     /// @return Amount of remaining tokens allowed to spent
725     function allowance(address _owner, address _spender) external view returns (uint remaining);
726 }
727 
728 
729 
730 contract ITrader {
731 
732   function getDataLength(
733   ) public pure returns (uint256);
734 
735   function getProtocol(
736   ) public pure returns (uint8);
737 
738   function getAvailableVolume(
739     bytes orderData
740   ) public view returns(uint);
741 
742   function isExpired(
743     bytes orderData
744   ) public view returns (bool); 
745 
746   function trade(
747     bool isSell,
748     bytes orderData,
749     uint volume,
750     uint volumeEth
751   ) public;
752   
753   function getFillVolumes(
754     bool isSell,
755     bytes orderData,
756     uint volume,
757     uint volumeEth
758   ) public view returns(uint, uint);
759 
760 }
761 
762 contract ITraders {
763 
764   /// @dev Add a valid trader address. Only owner.
765   function addTrader(uint8 id, ITrader trader) public;
766 
767   /// @dev Remove a trader address. Only owner.
768   function removeTrader(uint8 id) public;
769 
770   /// @dev Get trader by id.
771   function getTrader(uint8 id) public view returns(ITrader);
772 
773   /// @dev Check if an address is a valid trader.
774   function isValidTraderAddress(address addr) public view returns(bool);
775 
776 }
777 
778 contract Members is Ownable {
779 
780   mapping(address => bool) public members; // Mappings of addresses of allowed addresses
781 
782   modifier onlyMembers() {
783     require(isValidMember(msg.sender));
784     _;
785   }
786 
787   /// @dev Check if an address is a valid member.
788   function isValidMember(address _member) public view returns(bool) {
789     return members[_member];
790   }
791 
792   /// @dev Add a valid member address. Only owner.
793   function addMember(address _member) public onlyOwner {
794     members[_member] = true;
795   }
796 
797   /// @dev Remove a member address. Only owner.
798   function removeMember(address _member) public onlyOwner {
799     delete members[_member];
800   }
801 }
802 
803 
804 contract IFeeWallet {
805 
806   function getFee(
807     uint amount) public view returns(uint);
808 
809   function collect(
810     address _affiliate) public payable;
811 }
812 
813 
814 contract FeeWallet is IFeeWallet, Ownable, Members {
815 
816   address public serviceAccount; // Address of service account
817   uint public servicePercentage; // Percentage times (1 ether)
818   uint public affiliatePercentage; // Percentage times (1 ether)
819 
820   mapping (address => uint) public pendingWithdrawals; // Balances
821 
822   constructor(
823     address _serviceAccount,
824     uint _servicePercentage,
825     uint _affiliatePercentage) public
826   {
827     serviceAccount = _serviceAccount;
828     servicePercentage = _servicePercentage;
829     affiliatePercentage = _affiliatePercentage;
830   }
831 
832   /// @dev Set the new service account. Only owner.
833   function changeServiceAccount(address _serviceAccount) public onlyOwner {
834     serviceAccount = _serviceAccount;
835   }
836 
837   /// @dev Set the service percentage. Only owner.
838   function changeServicePercentage(uint _servicePercentage) public onlyOwner {
839     servicePercentage = _servicePercentage;
840   }
841 
842   /// @dev Set the affiliate percentage. Only owner.
843   function changeAffiliatePercentage(uint _affiliatePercentage) public onlyOwner {
844     affiliatePercentage = _affiliatePercentage;
845   }
846 
847   /// @dev Calculates the service fee for a specific amount. Only owner.
848   function getFee(uint amount) public view returns(uint)  {
849     return SafeMath.safeMul(amount, servicePercentage) / (1 ether);
850   }
851 
852   /// @dev Calculates the affiliate amount for a specific amount. Only owner.
853   function getAffiliateAmount(uint amount) public view returns(uint)  {
854     return SafeMath.safeMul(amount, affiliatePercentage) / (1 ether);
855   }
856 
857   /// @dev Collects fees according to last payment receivedi. Only valid smart contracts.
858   function collect(
859     address _affiliate) public payable onlyMembers
860   {
861     if(_affiliate == address(0))
862       pendingWithdrawals[serviceAccount] += msg.value;
863     else {
864       uint affiliateAmount = getAffiliateAmount(msg.value);
865       pendingWithdrawals[_affiliate] += affiliateAmount;
866       pendingWithdrawals[serviceAccount] += SafeMath.safeSub(msg.value, affiliateAmount);
867     }
868   }
869 
870   /// @dev Withdraw.
871   function withdraw() public {
872     uint amount = pendingWithdrawals[msg.sender];
873     pendingWithdrawals[msg.sender] = 0;
874     msg.sender.transfer(amount);
875   }
876 }
877 contract ZodiacERC20 is Ownable, BytesToTypes {
878   string constant public VERSION = '2.0.0';
879 
880   ITraders public traders; // Smart contract that hold the list of valid traders
881   IFeeWallet public feeWallet; // Smart contract that hold the fees collected
882   bool public tradingEnabled; // Switch to enable or disable the contract
883 
884   event Sell(
885     address account,
886     address destinationAddr,
887     address traedeable,
888     uint volume,
889     uint volumeEth,
890     uint volumeEffective,
891     uint volumeEthEffective
892   );
893   event Buy(
894     address account,
895     address destinationAddr,
896     address traedeable,
897     uint volume,
898     uint volumeEth,
899     uint volumeEffective,
900     uint volumeEthEffective
901   );
902 
903 
904   constructor(ITraders _traders, IFeeWallet _feeWallet) public {
905     traders = _traders;
906     feeWallet = _feeWallet;
907     tradingEnabled = true;
908   }
909 
910   /// @dev Only accepts payment from smart contract traders.
911   function() public payable {
912   //  require(traders.isValidTraderAddress(msg.sender));
913   }
914 
915   /// @dev Setter for feeWallet smart contract (Only owner)
916   function changeFeeWallet(IFeeWallet _feeWallet) public onlyOwner {
917     feeWallet = _feeWallet;
918   }
919 
920   /// @dev Setter for traders smart contract (Only owner)
921   function changeTraders(ITraders _traders) public onlyOwner {
922     traders = _traders;
923   }
924 
925   /// @dev Enable/Disable trading with smart contract (Only owner)
926   function changeTradingEnabled(bool enabled) public onlyOwner {
927     tradingEnabled = enabled;
928   }
929 
930   /// @dev Buy a token.
931   function buy(
932     ITradeable tradeable,
933     uint volume,
934     bytes ordersData,
935     address destinationAddr,
936     address affiliate
937   ) external payable
938   {
939 
940     require(tradingEnabled);
941 
942     // Execute the trade (at most fullfilling volume)
943     trade(
944       false,
945       tradeable,
946       volume,
947       ordersData,
948       affiliate
949     );
950 
951     // Since our balance before trade was 0. What we bought is our current balance.
952     uint volumeEffective = tradeable.balanceOf(this);
953 
954     // We make sure that something was traded
955     require(volumeEffective > 0);
956 
957     // Used ethers are: balance_before - balance_after.
958     // And since before call balance=0; then balance_before = msg.value
959     uint volumeEthEffective = SafeMath.safeSub(msg.value, address(this).balance);
960 
961     // IMPORTANT: Check that: effective_price <= agreed_price (guarantee a good deal for the buyer)
962     require(
963       SafeMath.safeDiv(volumeEthEffective, volumeEffective) <=
964       SafeMath.safeDiv(msg.value, volume)
965     );
966 
967     // Return remaining ethers
968     if(address(this).balance > 0) {
969       destinationAddr.transfer(address(this).balance);
970     }
971 
972     // Send the tokens
973     transferTradeable(tradeable, destinationAddr, volumeEffective);
974 
975     emit Buy(msg.sender, destinationAddr, tradeable, volume, msg.value, volumeEffective, volumeEthEffective);
976   }
977 
978   /// @dev sell a token.
979   function sell(
980     ITradeable tradeable,
981     uint volume,
982     uint volumeEth,
983     bytes ordersData,
984     address destinationAddr,
985     address affiliate
986   ) external
987   {
988     require(tradingEnabled);
989 
990     // We transfer to ouselves the user's trading volume, to operate on it
991     // note: Our balance is 0 before this
992     require(tradeable.transferFrom(msg.sender, this, volume));
993 
994     // Execute the trade (at most fullfilling volume)
995     trade(
996       true,
997       tradeable,
998       volume,
999       ordersData,
1000       affiliate
1001     );
1002 
1003     // Check how much we traded. Our balance = volume - tradedVolume
1004     // then: tradedVolume = volume - balance
1005     uint volumeEffective = SafeMath.safeSub(volume, tradeable.balanceOf(this));
1006 
1007     // We make sure that something was traded
1008     require(volumeEffective > 0);
1009 
1010     // Collects service fee
1011     uint volumeEthEffective = collectSellFee(affiliate);
1012 
1013     // IMPORTANT: Check that: effective_price >= agreed_price (guarantee a good deal for the seller)
1014     require(
1015       SafeMath.safeDiv(volumeEthEffective, volumeEffective) >=
1016       SafeMath.safeDiv(volumeEth, volume)
1017     );
1018 
1019     // Return remaining volume
1020     if (volumeEffective < volume) {
1021      transferTradeable(tradeable, destinationAddr, SafeMath.safeSub(volume, volumeEffective));
1022     }
1023 
1024     // Send ethers obtained
1025     destinationAddr.transfer(volumeEthEffective);
1026 
1027     emit Sell(msg.sender, destinationAddr, tradeable, volume, volumeEth, volumeEffective, volumeEthEffective);
1028   }
1029 
1030 
1031   /// @dev Trade buy or sell orders.
1032   function trade(
1033     bool isSell,
1034     ITradeable tradeable,
1035     uint volume,
1036     bytes ordersData,
1037     address affiliate
1038   ) internal
1039   {
1040     uint remainingVolume = volume;
1041     uint offset = ordersData.length;
1042 
1043     while(offset > 0 && remainingVolume > 0) {
1044       //Get the trader
1045       uint8 protocolId = bytesToUint8(offset, ordersData);
1046       ITrader trader = traders.getTrader(protocolId);
1047       require(trader != address(0));
1048 
1049       //Get the order data
1050       uint dataLength = trader.getDataLength();
1051       offset = SafeMath.safeSub(offset, dataLength);
1052       bytes memory orderData = slice(ordersData, offset, dataLength);
1053 
1054       //Fill order
1055       remainingVolume = fillOrder(
1056          isSell,
1057          tradeable,
1058          trader,
1059          remainingVolume,
1060          orderData,
1061          affiliate
1062       );
1063     }
1064   }
1065 
1066   /// @dev Fills a buy order.
1067   function fillOrder(
1068     bool isSell,
1069     ITradeable tradeable,
1070     ITrader trader,
1071     uint remaining,
1072     bytes memory orderData,
1073     address affiliate
1074     ) internal returns(uint)
1075   {
1076 
1077     //Checks that there is enoughh amount to execute the trade
1078     uint volume;
1079     uint volumeEth;
1080     (volume, volumeEth) = trader.getFillVolumes(
1081       isSell,
1082       orderData,
1083       remaining,
1084       address(this).balance
1085     );
1086 
1087     if(volume > 0) {
1088 
1089       if(isSell) {
1090         //Approve available amount of token to trader
1091         require(tradeable.approve(trader, volume));
1092       } else {
1093         //Collects service fee
1094         //TODO: transfer fees after all iteration
1095         volumeEth = collectBuyFee(volumeEth, affiliate);
1096         address(trader).transfer(volumeEth);
1097       }
1098 
1099       //Call trader to trade orders
1100       trader.trade(
1101         isSell,
1102         orderData,
1103         volume,
1104         volumeEth
1105       );
1106 
1107     }
1108 
1109     return SafeMath.safeSub(remaining, volume);
1110   }
1111 
1112   /// @dev Transfer tradeables to user account.
1113   function transferTradeable(ITradeable tradeable, address account, uint amount) internal {
1114     require(tradeable.transfer(account, amount));
1115   }
1116 
1117   // @dev Collect service/affiliate fee for a buy
1118   function collectBuyFee(uint ethers, address affiliate) internal returns(uint) {
1119     uint remaining;
1120     uint fee = feeWallet.getFee(ethers);
1121     //If there is enough remaining to pay fee, it substract from the balance
1122     if(SafeMath.safeSub(address(this).balance, ethers) >= fee)
1123       remaining = ethers;
1124     else
1125       remaining = SafeMath.safeSub(SafeMath.safeSub(ethers, address(this).balance), fee);
1126     feeWallet.collect.value(fee)(affiliate);
1127     return remaining;
1128   }
1129 
1130   // @dev Collect service/affiliate fee for a sell
1131   function collectSellFee(address affiliate) internal returns(uint) {
1132     uint fee = feeWallet.getFee(address(this).balance);
1133     feeWallet.collect.value(fee)(affiliate);
1134     return address(this).balance;
1135   }
1136 
1137 }