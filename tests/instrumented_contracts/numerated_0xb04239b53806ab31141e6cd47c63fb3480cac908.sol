1 pragma solidity 0.5.11;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract SafeMath {
6 
7     function safeMul(uint256 a, uint256 b)
8         internal
9         pure
10         returns (uint256)
11     {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         require(
17             c / a == b,
18             "UINT256_OVERFLOW"
19         );
20         return c;
21     }
22 
23     function safeDiv(uint256 a, uint256 b)
24         internal
25         pure
26         returns (uint256)
27     {
28         uint256 c = a / b;
29         return c;
30     }
31 
32     function safeSub(uint256 a, uint256 b)
33         internal
34         pure
35         returns (uint256)
36     {
37         require(
38             b <= a,
39             "UINT256_UNDERFLOW"
40         );
41         return a - b;
42     }
43 
44     function safeAdd(uint256 a, uint256 b)
45         internal
46         pure
47         returns (uint256)
48     {
49         uint256 c = a + b;
50         require(
51             c >= a,
52             "UINT256_OVERFLOW"
53         );
54         return c;
55     }
56 
57     function max64(uint64 a, uint64 b)
58         internal
59         pure
60         returns (uint256)
61     {
62         return a >= b ? a : b;
63     }
64 
65     function min64(uint64 a, uint64 b)
66         internal
67         pure
68         returns (uint256)
69     {
70         return a < b ? a : b;
71     }
72 
73     function max256(uint256 a, uint256 b)
74         internal
75         pure
76         returns (uint256)
77     {
78         return a >= b ? a : b;
79     }
80 
81     function min256(uint256 a, uint256 b)
82         internal
83         pure
84         returns (uint256)
85     {
86         return a < b ? a : b;
87     }
88 }
89 
90 contract LibFillResults is
91     SafeMath
92 {
93     struct FillResults {
94         uint256 makerAssetFilledAmount;  
95         uint256 takerAssetFilledAmount;  
96         uint256 makerFeePaid;            
97         uint256 takerFeePaid;            
98     }
99 
100     struct MatchedFillResults {
101         FillResults left;                    
102         FillResults right;                   
103         uint256 leftMakerAssetSpreadAmount;  
104     }
105 
106     
107     
108     
109     
110     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
111         internal
112         pure
113     {
114         totalFillResults.makerAssetFilledAmount = safeAdd(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
115         totalFillResults.takerAssetFilledAmount = safeAdd(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
116         totalFillResults.makerFeePaid = safeAdd(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
117         totalFillResults.takerFeePaid = safeAdd(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
118     }
119 }
120 
121 contract LibEIP712 {
122 
123     
124     string constant internal EIP191_HEADER = "\x19\x01";
125 
126     
127     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
128 
129     
130     string constant internal EIP712_DOMAIN_VERSION = "2";
131 
132     
133     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
134         "EIP712Domain(",
135         "string name,",
136         "string version,",
137         "address verifyingContract",
138         ")"
139     ));
140 
141     
142     
143     bytes32 public EIP712_DOMAIN_HASH;
144 
145     constructor ()
146         public
147     {
148         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
149             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
150             keccak256(bytes(EIP712_DOMAIN_NAME)),
151             keccak256(bytes(EIP712_DOMAIN_VERSION)),
152             uint256(address(this))
153         ));
154     }
155 
156     
157     
158     
159     function hashEIP712Message(bytes32 hashStruct)
160         internal
161         view
162         returns (bytes32 result)
163     {
164         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
165 
166         
167         
168         
169         
170         
171         
172 
173         assembly {
174             
175             let memPtr := mload(64)
176 
177             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  
178             mstore(add(memPtr, 2), eip712DomainHash)                                            
179             mstore(add(memPtr, 34), hashStruct)                                                 
180 
181             
182             result := keccak256(memPtr, 66)
183         }
184         return result;
185     }
186 }
187 
188 contract LibOrder is
189     LibEIP712
190 {
191     
192     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
193         "Order(",
194         "address makerAddress,",
195         "address takerAddress,",
196         "address feeRecipientAddress,",
197         "address senderAddress,",
198         "uint256 makerAssetAmount,",
199         "uint256 takerAssetAmount,",
200         "uint256 makerFee,",
201         "uint256 takerFee,",
202         "uint256 expirationTimeSeconds,",
203         "uint256 salt,",
204         "bytes makerAssetData,",
205         "bytes takerAssetData",
206         ")"
207     ));
208 
209     
210     
211     enum OrderStatus {
212         INVALID,                     
213         INVALID_MAKER_ASSET_AMOUNT,  
214         INVALID_TAKER_ASSET_AMOUNT,  
215         FILLABLE,                    
216         EXPIRED,                     
217         FULLY_FILLED,                
218         CANCELLED                    
219     }
220 
221     
222     struct Order {
223         address makerAddress;           
224         address takerAddress;           
225         address feeRecipientAddress;    
226         address senderAddress;          
227         uint256 makerAssetAmount;       
228         uint256 takerAssetAmount;       
229         uint256 makerFee;               
230         uint256 takerFee;               
231         uint256 expirationTimeSeconds;  
232         uint256 salt;                   
233         bytes makerAssetData;           
234         bytes takerAssetData;           
235     }
236     
237 
238     struct OrderInfo {
239         uint8 orderStatus;                    
240         bytes32 orderHash;                    
241         uint256 orderTakerAssetFilledAmount;  
242     }
243 
244     
245     
246     
247     function getOrderHash(Order memory order)
248         internal
249         view
250         returns (bytes32 orderHash)
251     {
252         orderHash = hashEIP712Message(hashOrder(order));
253         return orderHash;
254     }
255 
256     
257     
258     
259     function hashOrder(Order memory order)
260         internal
261         pure
262         returns (bytes32 result)
263     {
264         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
265         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
266         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
267 
268         
269         
270         
271         
272         
273         
274         
275         
276         
277         
278         
279         
280         
281         
282         
283         
284 
285         assembly {
286             
287             let pos1 := sub(order, 32)
288             let pos2 := add(order, 320)
289             let pos3 := add(order, 352)
290 
291             
292             let temp1 := mload(pos1)
293             let temp2 := mload(pos2)
294             let temp3 := mload(pos3)
295             
296             
297             mstore(pos1, schemaHash)
298             mstore(pos2, makerAssetDataHash)
299             mstore(pos3, takerAssetDataHash)
300             result := keccak256(pos1, 416)
301             
302             
303             mstore(pos1, temp1)
304             mstore(pos2, temp2)
305             mstore(pos3, temp3)
306         }
307         return result;
308     }
309 }
310 
311 interface IERC20 {
312     
313     function totalSupply() external view returns (uint256);
314 
315     
316     function balanceOf(address account) external view returns (uint256);
317 
318     
319     function transfer(address recipient, uint256 amount) external returns (bool);
320 
321     
322     function allowance(address owner, address spender) external view returns (uint256);
323 
324     
325     function approve(address spender, uint256 amount) external returns (bool);
326 
327     
328     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
329 
330     
331     event Transfer(address indexed from, address indexed to, uint256 value);
332 
333     
334     event Approval(address indexed owner, address indexed spender, uint256 value);
335 }
336 
337 interface IERC165 {
338     
339     function supportsInterface(bytes4 interfaceId) external view returns (bool);
340 }
341 
342 contract IERC721 is IERC165 {
343     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
344     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
345     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
346 
347     
348     function balanceOf(address owner) public view returns (uint256 balance);
349 
350     
351     function ownerOf(uint256 tokenId) public view returns (address owner);
352 
353     
354     function safeTransferFrom(address from, address to, uint256 tokenId) public;
355     
356     function transferFrom(address from, address to, uint256 tokenId) public;
357     function approve(address to, uint256 tokenId) public;
358     function getApproved(uint256 tokenId) public view returns (address operator);
359 
360     function setApprovalForAll(address operator, bool _approved) public;
361     function isApprovedForAll(address owner, address operator) public view returns (bool);
362 
363 
364     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
365 }
366 
367 contract IExchange {
368 
369     
370     
371     
372     
373     function fillOrKillOrder(
374         LibOrder.Order memory order,
375         uint256 takerAssetFillAmount,
376         bytes memory signature
377     )
378         public
379         returns (LibFillResults.FillResults memory fillResults);
380 
381     
382     
383     
384     
385     
386     
387     function fillOrderNoThrow(
388         LibOrder.Order memory order,
389         uint256 takerAssetFillAmount,
390         bytes memory signature
391     )
392         public
393         returns (LibFillResults.FillResults memory fillResults);
394 
395     
396     
397     
398     
399     
400     function batchFillOrders(
401         LibOrder.Order[] memory orders,
402         uint256[] memory takerAssetFillAmounts,
403         bytes[] memory signatures
404     )
405         public
406         returns (LibFillResults.FillResults memory totalFillResults);
407 
408     
409     
410     
411     
412     
413     function batchFillOrKillOrders(
414         LibOrder.Order[] memory orders,
415         uint256[] memory takerAssetFillAmounts,
416         bytes[] memory signatures
417     )
418         public
419         returns (LibFillResults.FillResults memory totalFillResults);
420 
421     
422     
423     
424     
425     
426     
427     function batchFillOrdersNoThrow(
428         LibOrder.Order[] memory orders,
429         uint256[] memory takerAssetFillAmounts,
430         bytes[] memory signatures
431     )
432         public
433         returns (LibFillResults.FillResults memory totalFillResults);
434 
435     
436     
437     
438     
439     
440     function marketSellOrders(
441         LibOrder.Order[] memory orders,
442         uint256 takerAssetFillAmount,
443         bytes[] memory signatures
444     )
445         public
446         returns (LibFillResults.FillResults memory totalFillResults);
447 
448     
449     
450     
451     
452     
453     
454     function marketSellOrdersNoThrow(
455         LibOrder.Order[] memory orders,
456         uint256 takerAssetFillAmount,
457         bytes[] memory signatures
458     )
459         public
460         returns (LibFillResults.FillResults memory totalFillResults);
461 
462     
463     
464     
465     
466     
467     function marketBuyOrders(
468         LibOrder.Order[] memory orders,
469         uint256 makerAssetFillAmount,
470         bytes[] memory signatures
471     )
472         public
473         returns (LibFillResults.FillResults memory totalFillResults);
474 
475     
476     
477     
478     
479     
480     
481     function marketBuyOrdersNoThrow(
482         LibOrder.Order[] memory orders,
483         uint256 makerAssetFillAmount,
484         bytes[] memory signatures
485     )
486         public
487         returns (LibFillResults.FillResults memory totalFillResults);
488 
489     
490     
491     function batchCancelOrders(LibOrder.Order[] memory orders)
492         public;
493 
494     
495     
496     
497     function getOrdersInfo(LibOrder.Order[] memory orders)
498         public
499         view
500         returns (LibOrder.OrderInfo[] memory);
501 }
502 
503 contract IEtherToken is IERC20 {
504     function deposit() public payable;
505     function withdraw(uint256 _amount) public;
506     function withdrawTo(address _to, uint256 _amount) public;
507 }
508 
509 library LibBytesRichErrors {
510 
511     enum InvalidByteOperationErrorCodes {
512         FromLessThanOrEqualsToRequired,
513         ToLessThanOrEqualsLengthRequired,
514         LengthGreaterThanZeroRequired,
515         LengthGreaterThanOrEqualsFourRequired,
516         LengthGreaterThanOrEqualsTwentyRequired,
517         LengthGreaterThanOrEqualsThirtyTwoRequired,
518         LengthGreaterThanOrEqualsNestedBytesLengthRequired,
519         DestinationLengthGreaterThanOrEqualSourceLengthRequired
520     }
521 
522     
523     bytes4 internal constant INVALID_BYTE_OPERATION_ERROR_SELECTOR =
524         0x28006595;
525 
526     
527     function InvalidByteOperationError(
528         InvalidByteOperationErrorCodes errorCode,
529         uint256 offset,
530         uint256 required
531     )
532         internal
533         pure
534         returns (bytes memory)
535     {
536         return abi.encodeWithSelector(
537             INVALID_BYTE_OPERATION_ERROR_SELECTOR,
538             errorCode,
539             offset,
540             required
541         );
542     }
543 }
544 
545 library LibRichErrors {
546 
547     
548     bytes4 internal constant STANDARD_ERROR_SELECTOR =
549         0x08c379a0;
550 
551     
552     
553     
554     
555     
556     
557     function StandardError(
558         string memory message
559     )
560         internal
561         pure
562         returns (bytes memory)
563     {
564         return abi.encodeWithSelector(
565             STANDARD_ERROR_SELECTOR,
566             bytes(message)
567         );
568     }
569     
570 
571     
572     
573     function rrevert(bytes memory errorData)
574         internal
575         pure
576     {
577         assembly {
578             revert(add(errorData, 0x20), mload(errorData))
579         }
580     }
581 }
582 
583 library LibBytes {
584 
585     using LibBytes for bytes;
586 
587     
588     
589     
590     
591     
592     function rawAddress(bytes memory input)
593         internal
594         pure
595         returns (uint256 memoryAddress)
596     {
597         assembly {
598             memoryAddress := input
599         }
600         return memoryAddress;
601     }
602 
603     
604     
605     
606     function contentAddress(bytes memory input)
607         internal
608         pure
609         returns (uint256 memoryAddress)
610     {
611         assembly {
612             memoryAddress := add(input, 32)
613         }
614         return memoryAddress;
615     }
616 
617     
618     
619     
620     
621     function memCopy(
622         uint256 dest,
623         uint256 source,
624         uint256 length
625     )
626         internal
627         pure
628     {
629         if (length < 32) {
630             
631             
632             
633             assembly {
634                 let mask := sub(exp(256, sub(32, length)), 1)
635                 let s := and(mload(source), not(mask))
636                 let d := and(mload(dest), mask)
637                 mstore(dest, or(s, d))
638             }
639         } else {
640             
641             if (source == dest) {
642                 return;
643             }
644 
645             
646             
647             
648             
649             
650             
651             
652             
653             
654             
655             
656             
657             
658             
659             
660             if (source > dest) {
661                 assembly {
662                     
663                     
664                     
665                     
666                     length := sub(length, 32)
667                     let sEnd := add(source, length)
668                     let dEnd := add(dest, length)
669 
670                     
671                     
672                     
673                     
674                     let last := mload(sEnd)
675 
676                     
677                     
678                     
679                     
680                     for {} lt(source, sEnd) {} {
681                         mstore(dest, mload(source))
682                         source := add(source, 32)
683                         dest := add(dest, 32)
684                     }
685 
686                     
687                     mstore(dEnd, last)
688                 }
689             } else {
690                 assembly {
691                     
692                     
693                     length := sub(length, 32)
694                     let sEnd := add(source, length)
695                     let dEnd := add(dest, length)
696 
697                     
698                     
699                     
700                     
701                     let first := mload(source)
702 
703                     
704                     
705                     
706                     
707                     
708                     
709                     
710                     
711                     for {} slt(dest, dEnd) {} {
712                         mstore(dEnd, mload(sEnd))
713                         sEnd := sub(sEnd, 32)
714                         dEnd := sub(dEnd, 32)
715                     }
716 
717                     
718                     mstore(dest, first)
719                 }
720             }
721         }
722     }
723 
724     
725     
726     
727     
728     
729     function slice(
730         bytes memory b,
731         uint256 from,
732         uint256 to
733     )
734         internal
735         pure
736         returns (bytes memory result)
737     {
738         
739         
740         if (from > to) {
741             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
742                 LibBytesRichErrors.InvalidByteOperationErrorCodes.FromLessThanOrEqualsToRequired,
743                 from,
744                 to
745             ));
746         }
747         if (to > b.length) {
748             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
749                 LibBytesRichErrors.InvalidByteOperationErrorCodes.ToLessThanOrEqualsLengthRequired,
750                 to,
751                 b.length
752             ));
753         }
754 
755         
756         result = new bytes(to - from);
757         memCopy(
758             result.contentAddress(),
759             b.contentAddress() + from,
760             result.length
761         );
762         return result;
763     }
764 
765     
766     
767     
768     
769     
770     
771     function sliceDestructive(
772         bytes memory b,
773         uint256 from,
774         uint256 to
775     )
776         internal
777         pure
778         returns (bytes memory result)
779     {
780         
781         
782         if (from > to) {
783             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
784                 LibBytesRichErrors.InvalidByteOperationErrorCodes.FromLessThanOrEqualsToRequired,
785                 from,
786                 to
787             ));
788         }
789         if (to > b.length) {
790             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
791                 LibBytesRichErrors.InvalidByteOperationErrorCodes.ToLessThanOrEqualsLengthRequired,
792                 to,
793                 b.length
794             ));
795         }
796 
797         
798         assembly {
799             result := add(b, from)
800             mstore(result, sub(to, from))
801         }
802         return result;
803     }
804 
805     
806     
807     
808     function popLastByte(bytes memory b)
809         internal
810         pure
811         returns (bytes1 result)
812     {
813         if (b.length == 0) {
814             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
815                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanZeroRequired,
816                 b.length,
817                 0
818             ));
819         }
820 
821         
822         result = b[b.length - 1];
823 
824         assembly {
825             
826             let newLen := sub(mload(b), 1)
827             mstore(b, newLen)
828         }
829         return result;
830     }
831 
832     
833     
834     
835     
836     function equals(
837         bytes memory lhs,
838         bytes memory rhs
839     )
840         internal
841         pure
842         returns (bool equal)
843     {
844         
845         
846         
847         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
848     }
849 
850     
851     
852     
853     
854     function readAddress(
855         bytes memory b,
856         uint256 index
857     )
858         internal
859         pure
860         returns (address result)
861     {
862         if (b.length < index + 20) {
863             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
864                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsTwentyRequired,
865                 b.length,
866                 index + 20 
867             ));
868         }
869 
870         
871         
872         
873         index += 20;
874 
875         
876         assembly {
877             
878             
879             
880             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
881         }
882         return result;
883     }
884 
885     
886     
887     
888     
889     function writeAddress(
890         bytes memory b,
891         uint256 index,
892         address input
893     )
894         internal
895         pure
896     {
897         if (b.length < index + 20) {
898             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
899                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsTwentyRequired,
900                 b.length,
901                 index + 20 
902             ));
903         }
904 
905         
906         
907         
908         index += 20;
909 
910         
911         assembly {
912             
913             
914             
915             
916 
917             
918             
919             
920             let neighbors := and(
921                 mload(add(b, index)),
922                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
923             )
924 
925             
926             
927             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
928 
929             
930             mstore(add(b, index), xor(input, neighbors))
931         }
932     }
933 
934     
935     
936     
937     
938     function readBytes32(
939         bytes memory b,
940         uint256 index
941     )
942         internal
943         pure
944         returns (bytes32 result)
945     {
946         if (b.length < index + 32) {
947             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
948                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsThirtyTwoRequired,
949                 b.length,
950                 index + 32
951             ));
952         }
953 
954         
955         index += 32;
956 
957         
958         assembly {
959             result := mload(add(b, index))
960         }
961         return result;
962     }
963 
964     
965     
966     
967     
968     function writeBytes32(
969         bytes memory b,
970         uint256 index,
971         bytes32 input
972     )
973         internal
974         pure
975     {
976         if (b.length < index + 32) {
977             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
978                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsThirtyTwoRequired,
979                 b.length,
980                 index + 32
981             ));
982         }
983 
984         
985         index += 32;
986 
987         
988         assembly {
989             mstore(add(b, index), input)
990         }
991     }
992 
993     
994     
995     
996     
997     function readUint256(
998         bytes memory b,
999         uint256 index
1000     )
1001         internal
1002         pure
1003         returns (uint256 result)
1004     {
1005         result = uint256(readBytes32(b, index));
1006         return result;
1007     }
1008 
1009     
1010     
1011     
1012     
1013     function writeUint256(
1014         bytes memory b,
1015         uint256 index,
1016         uint256 input
1017     )
1018         internal
1019         pure
1020     {
1021         writeBytes32(b, index, bytes32(input));
1022     }
1023 
1024     
1025     
1026     
1027     
1028     function readBytes4(
1029         bytes memory b,
1030         uint256 index
1031     )
1032         internal
1033         pure
1034         returns (bytes4 result)
1035     {
1036         if (b.length < index + 4) {
1037             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1038                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsFourRequired,
1039                 b.length,
1040                 index + 4
1041             ));
1042         }
1043 
1044         
1045         index += 32;
1046 
1047         
1048         assembly {
1049             result := mload(add(b, index))
1050             
1051             
1052             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
1053         }
1054         return result;
1055     }
1056 
1057     
1058     
1059     
1060     
1061     
1062     function writeLength(bytes memory b, uint256 length)
1063         internal
1064         pure
1065     {
1066         assembly {
1067             mstore(b, length)
1068         }
1069     }
1070 }
1071 
1072 contract Forwarder is LibOrder {
1073 
1074     using LibBytes for bytes;
1075 
1076     address public ZERO_EX_EXCHANGE;
1077     address public ZERO_EX_TOKEN_PROXY;
1078 
1079     address payable public ETHER_TOKEN;
1080 
1081     constructor(
1082         address zeroExExchange,
1083         address zeroExProxy,
1084         address payable etherToken
1085     )
1086         public
1087     {
1088         ZERO_EX_EXCHANGE = zeroExExchange;
1089         ZERO_EX_TOKEN_PROXY = zeroExProxy;
1090         ETHER_TOKEN = etherToken;
1091 
1092         
1093         IEtherToken(ETHER_TOKEN).approve(ZERO_EX_TOKEN_PROXY, (2**256)-1);
1094     }
1095 
1096     function fillOrders(
1097         LibOrder.Order[] memory orders,
1098         uint256[] memory takerAssetFillAmounts,
1099         bytes[] memory signatures
1100     )
1101         public
1102         payable
1103     {
1104         
1105         IEtherToken token = IEtherToken(ETHER_TOKEN);
1106         IExchange v2Exchange = IExchange(ZERO_EX_EXCHANGE);
1107 
1108         token.deposit.value(msg.value)();
1109 
1110         
1111         
1112         for (uint i = 0; i < orders.length; i++) {
1113             LibFillResults.FillResults memory result = v2Exchange.fillOrderNoThrow(
1114                 orders[i],
1115                 takerAssetFillAmounts[i],
1116                 signatures[i]
1117             );
1118 
1119             
1120             (address cardToken, uint256 tokenId) = abi.decode(
1121                 orders[i].makerAssetData.sliceDestructive(
1122                     4,
1123                     orders[i].makerAssetData.length
1124                 ),
1125                 (address, uint256)
1126             );
1127 
1128             
1129             if (result.takerAssetFilledAmount == takerAssetFillAmounts[i]) {
1130                 IERC721(cardToken).transferFrom(address(this), msg.sender, tokenId);
1131             }
1132         }
1133 
1134         uint remainingBalance = token.balanceOf(address(this));
1135         token.withdraw(remainingBalance);
1136 
1137         
1138         address(msg.sender).transfer(remainingBalance);
1139 
1140         
1141         require(
1142             address(this).balance == 0,
1143             "Forwarder: must have zero ETH at the end"
1144         );
1145 
1146     }
1147 
1148     function ()
1149         external
1150         payable
1151     {
1152         require(
1153             msg.sender == address(ETHER_TOKEN),
1154             "Forwarder: will not accept ETH from only ether token address"
1155         );
1156     }
1157 
1158 }