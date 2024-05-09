1 /**
2  *
3  *  Provable Connector v1.3.0
4  *
5  *  Copyright (c) 2015-2016 Oraclize SRL
6  *  Copyright (c) 2016-2019 Oraclize LTD
7  *  Copyright (c) 2019 Provable Things LTD
8  *
9  */
10 pragma solidity 0.4.24;
11 
12 interface ERC20Interface {
13 
14   function balanceOf(address who) external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20 }
21 
22 contract Oraclize {
23 
24     mapping (address => uint256) requestCounter;
25     mapping (address => byte) public callbackAddresses;
26     mapping (address => bool) public offchainPayment;
27     address admin;
28     address paymentFlagger;
29     uint256 gasPrice = 20e9;
30     mapping (address => byte) addressProofType;
31     mapping (address => uint256) addressCustomGasPrice;
32     uint256 public basePrice;
33     mapping (bytes32 => uint256) public price;
34     mapping (bytes32 => uint256) priceMultiplier;
35     bytes32[] datasources;
36     bytes32[] public randomDS_sessionPublicKeyHash;
37     uint256 constant BASE_TX_COST = 21e3;
38     uint256 constant DEFAULT_GAS_LIMIT = 2e5;
39     mapping (address => uint256) public amplifiedTokenPrices;
40     mapping (address => address) public addressCustomPaymentToken;
41 
42     event Log1(
43         address sender,
44         bytes32 cid,
45         uint256 timestamp,
46         string datasource,
47         string arg,
48         uint256 gaslimit,
49         byte proofType,
50         uint256 gasPrice
51     );
52 
53     event Log1_byte(
54         address sender,
55         bytes32 cid,
56         uint256 timestamp,
57         byte datasource,
58         string arg,
59         uint256 gaslimit,
60         byte proofType,
61         uint256 gasPrice
62     );
63 
64     event Log2(
65         address sender,
66         bytes32 cid,
67         uint256 timestamp,
68         string datasource,
69         string arg1,
70         string arg2,
71         uint256 gaslimit,
72         byte proofType,
73         uint256 gasPrice
74     );
75 
76     event Log2_byte(
77         address sender,
78         bytes32 cid,
79         uint256 timestamp,
80         byte datasource,
81         string arg1,
82         string arg2,
83         uint256 gaslimit,
84         byte proofType,
85         uint256 gasPrice
86     );
87 
88     event LogN(
89         address sender,
90         bytes32 cid,
91         uint256 timestamp,
92         string datasource,
93         bytes args,
94         uint256 gaslimit,
95         byte proofType,
96         uint256 gasPrice
97     );
98 
99     event LogN_byte(
100         address sender,
101         bytes32 cid,
102         uint256 timestamp,
103         byte datasource,
104         bytes args,
105         uint256 gaslimit,
106         byte proofType,
107         uint256 gasPrice
108     );
109 
110     event Emit_OffchainPaymentFlag(
111         address indexed idx_sender,
112         address sender,
113         bool indexed idx_flag,
114         bool flag
115     );
116 
117     event CallbackRebroadcastRequest(
118       bytes32 indexed queryId,
119       uint256 gasLimit,
120       uint256 gasPrice
121     );
122 
123     event LogTokenWhitelistRemoval(
124         address tokenAddress
125     );
126 
127     event LogTokenWhitelisting(
128         string tokenTicker,
129         address tokenAddress
130     );
131 
132     event EnableCache(
133         address indexed sender,
134         bytes32 cid
135     );
136 
137     event LogCached(
138         address sender,
139         bytes32 cid,
140         uint256 value
141     );
142 
143     constructor() public {
144         admin = msg.sender;
145     }
146 
147     function onlyAdmin()
148         view
149         private
150     {
151         require(msg.sender == admin);
152     }
153 
154     function onlyManagers()
155         view
156         private
157     {
158         require(msg.sender == admin || msg.sender == paymentFlagger);
159     }
160 
161     /**
162      * @notice  The price amplification allows representation of lower-priced
163      *          tokens by the connector, & maintains higher precision during the
164      *          the conversion of a query price in ETH to it's token equivalent.
165      *
166      * @dev     Token price amplified via: tokenUSDPrice * 1e3.
167      */
168     function whitelistToken(
169         string _tokenTicker,
170         address _tokenAddress,
171         uint256 _amplifiedTokenPrice
172     )
173         external
174     {
175         onlyAdmin();
176         amplifiedTokenPrices[_tokenAddress] = _amplifiedTokenPrice;
177         emit LogTokenWhitelisting(_tokenTicker, _tokenAddress);
178     }
179 
180     function updateTokenAmplifiedPrice(
181         address _tokenAddress,
182         uint256 _newAmplifiedTokenPrice
183     )
184         external
185     {
186         onlyManagers();
187         amplifiedTokenPrices[_tokenAddress] = _newAmplifiedTokenPrice;
188     }
189 
190     function revokeTokenWhitelisting(address _tokenAddress)
191         external
192     {
193         onlyManagers();
194         delete amplifiedTokenPrices[_tokenAddress];
195         emit LogTokenWhitelistRemoval(_tokenAddress);
196     }
197 
198     function setCustomTokenPayment(address _tokenAddress)
199         external
200     {
201         require(amplifiedTokenPrices[_tokenAddress] > 0);
202         addressCustomPaymentToken[msg.sender] = _tokenAddress;
203     }
204 
205     function unsetCustomTokenPayment()
206         external
207     {
208         delete addressCustomPaymentToken[msg.sender];
209     }
210 
211     function getTokenBalance(address _tokenAddress)
212     view
213         public
214         returns (uint256 _tokenBalance)
215     {
216         return ERC20Interface(_tokenAddress).balanceOf(address(this));
217     }
218 
219     function withdrawTokens(address _tokenAddress)
220         external
221     {
222         onlyAdmin();
223         withdrawTokens(
224             _tokenAddress,
225             msg.sender,
226             getTokenBalance(_tokenAddress)
227         );
228     }
229 
230     function withdrawTokens(
231         address _tokenAddress,
232         address _recipient,
233         uint256 _amount
234     )
235         public
236     {
237         onlyAdmin();
238         require(_recipient != address(0));
239         ERC20Interface(_tokenAddress).transfer(_recipient, _amount);
240     }
241 
242     function migrateRequestCounter(
243         address _address,
244         uint256 _requestCounter
245     )
246         private
247     {
248         require(requestCounter[_address] == 0);
249         requestCounter[_address] = _requestCounter;
250     }
251 
252     function batchMigrateRequestCounters(
253         address[] _addresses,
254         uint256[] _requestCounters
255     )
256         public
257     {
258         onlyManagers();
259         for (uint256 i = 0; i < _addresses.length; i++) {
260             migrateRequestCounter(
261                 _addresses[i],
262                 _requestCounters[i]
263             );
264         }
265     }
266     function migrateCustomSettings(
267         address _address,
268         byte _proofType,
269         uint256 _gasPrice,
270         bool _offchainPayer,
271         uint256 _requestCounter
272     )
273         private
274     {
275         require(requestCounter[_address] == 0);
276         addressProofType[_address] = _proofType;
277         requestCounter[_address] = _requestCounter;
278         offchainPayment[_address] = _offchainPayer;
279         addressCustomGasPrice[_address] = _gasPrice;
280     }
281 
282     function batchMigrateCustomSettings(
283         address[] _addresses,
284         byte[] _proofTypes,
285         uint256[] _gasPrices,
286         bool[] _offchainPayers,
287         uint256[] _requestCounters
288     )
289         public
290     {
291         onlyManagers();
292         for (uint256 i = 0; i < _addresses.length; i++) {
293             migrateCustomSettings(
294                 _addresses[i],
295                 _proofTypes[i],
296                 _gasPrices[i],
297                 _offchainPayers[i],
298                 _requestCounters[i]
299             );
300         }
301     }
302 
303     function costs(
304         string _datasource,
305         uint256 _gasLimit
306     )
307         private
308     {
309         settlePayment(getPrice(_datasource, _gasLimit, msg.sender));
310     }
311 
312     function costs(
313         byte _datasource,
314         uint256 _gasLimit
315     )
316         private
317     {
318         settlePayment(getPrice(_datasource, _gasLimit, msg.sender));
319     }
320 
321     /**
322      * @dev Any ETH sent over and above a query price is refunded. Please note
323      *      that the same is NOT true for any queries paid for by ERC20 tokens.
324      *      In such cases, please ensure no ETH is sent along with query
325      *      function calls.
326      */
327     function settlePayment(uint256 _price)
328         private
329     {
330         if (msg.value == _price) {
331             return;
332         }
333         else if (msg.value > _price) {
334             msg.sender.transfer(msg.value - _price);
335             return;
336         }
337         address tokenAddress = addressCustomPaymentToken[msg.sender];
338         if (tokenAddress != address(0)) {
339             makeERC20Payment(
340                 msg.sender,
341                 convertToERC20Price(_price, tokenAddress)
342             );
343             return;
344         }
345         else {
346             revert('Error settling query payment');
347         }
348     }
349 
350     /**
351      * @notice  The amplified token price here allows higher precision when
352      *          converting the query price in wei to its token equivalent.
353      */
354     function convertToERC20Price(
355         uint256 _queryPriceInWei,
356         address _tokenAddress
357     )
358         view
359         public
360         returns (uint256 _price)
361     {
362         uint256 erc20Price = (_queryPriceInWei * 1 ether) / (amplifiedTokenPrices[_tokenAddress] * basePrice);
363         require(erc20Price > 0);
364         return erc20Price;
365     }
366 
367     function makeERC20Payment(
368         address _address,
369         uint256 _amount
370     )
371         private
372     {
373         ERC20Interface(addressCustomPaymentToken[_address])
374             .transferFrom(
375                 _address,
376                 address(this),
377                 _amount
378             );
379     }
380 
381     function changeAdmin(address _newAdmin)
382         external
383     {
384         onlyAdmin();
385         admin = _newAdmin;
386     }
387 
388     function changePaymentFlagger(address _newFlagger)
389         external
390     {
391         onlyAdmin();
392         paymentFlagger = _newFlagger;
393     }
394 
395     function addCallbackAddress(
396         address _newCallbackAddress,
397         byte _addressType
398     )
399         public
400     {
401         onlyAdmin();
402         addCallbackAddress(
403             _newCallbackAddress,
404             _addressType,
405             hex''
406         );
407     }
408 
409     /**
410      * @dev "proof" is currently a placeholder for when associated proof
411      *      for _addressType is added.
412      */
413     function addCallbackAddress(
414         address _newCallbackAddress,
415         byte _addressType,
416         bytes _proof
417     )
418         public
419     {
420         onlyAdmin();
421         callbackAddresses[_newCallbackAddress] = _addressType;
422     }
423 
424     function removeCallbackAddress(address _callbackAddress)
425         public
426     {
427         onlyAdmin();
428         delete callbackAddresses[_callbackAddress];
429     }
430 
431     function isOriginCallbackAddress()
432         public
433         view
434         returns (bool _isCallback)
435     {
436         if (callbackAddresses[tx.origin] != 0)
437             return true;
438     }
439 
440     function addDatasource(
441         string _datasourceName,
442         uint256 _multiplier
443     )
444         public
445     {
446         addDatasource(_datasourceName, 0x00, _multiplier);
447     }
448 
449     function addDatasource(
450         byte _datasourceName,
451         uint256 _multiplier
452     )
453         external
454     {
455         addDatasource(_datasourceName, 0x00, _multiplier);
456     }
457 
458     function addDatasource(
459         string _datasourceName,
460         byte _proofType,
461         uint256 _multiplier
462     )
463         public
464     {
465         onlyAdmin();
466         bytes32 dsname_hash = keccak256(
467             _datasourceName,
468             _proofType
469         );
470         datasources[datasources.length++] = dsname_hash;
471         priceMultiplier[dsname_hash] = _multiplier;
472     }
473 
474     function addDatasource(
475         byte _datasourceName,
476         byte _proofType,
477         uint256 _multiplier
478     )
479         public
480     {
481         onlyAdmin();
482         bytes32 dsname_hash = keccak256(
483             _datasourceName,
484             _proofType
485         );
486         datasources[datasources.length++] = dsname_hash;
487         priceMultiplier[dsname_hash] = _multiplier;
488     }
489 
490     /**
491      * @notice  Used by the "ethereum-bridge"
492      *
493      * @dev     Calculate dsHash via:
494      *          bytes32 hash = keccak256(DATASOURCE_NAME, PROOF_TYPE);
495      */
496     function multiAddDatasources(
497         bytes32[] _datasourceHash,
498         uint256[] _multiplier
499     )
500         public
501     {
502         onlyAdmin();
503         for (uint256 i = 0; i < _datasourceHash.length; i++) {
504             datasources[datasources.length++] = _datasourceHash[i];
505             priceMultiplier[_datasourceHash[i]] = _multiplier[i];
506         }
507     }
508 
509     function multiSetProofTypes(
510         uint256[] _proofType,
511         address[] _address
512     )
513         public
514     {
515         onlyAdmin();
516         for (uint256 i = 0; i < _address.length; i++) {
517             addressProofType[_address[i]] = byte(_proofType[i]);
518         }
519     }
520 
521     function multiSetCustomGasPrices(
522         uint256[] _gasPrice,
523         address[] _address
524     )
525         public
526     {
527         onlyAdmin();
528         for (uint256 i = 0; i < _address.length; i++) {
529             addressCustomGasPrice[_address[i]] = _gasPrice[i];
530         }
531     }
532 
533     function setGasPrice(uint256 _newGasPrice)
534         external
535     {
536         onlyAdmin();
537         gasPrice = _newGasPrice;
538     }
539 
540     /**
541      * @notice  Base price is maintained @ 0.001 USD in ether. Notice too that
542      *          any datasources need to be added before setting the base price
543      *          in order for datasource prices to be correctly persisted.
544      *
545      * @dev     To calculate base price:
546      *          uint256 basePrice = 1 * 10 ** _tokenDecimals / _USDPrice * 1000;
547      *
548      */
549     function setBasePrice(uint256 _newBasePrice)
550         external
551     {
552         onlyManagers();
553         basePrice = _newBasePrice;
554         for (uint256 i = 0; i < datasources.length; i++) {
555             price[datasources[i]] = _newBasePrice * priceMultiplier[datasources[i]];
556         }
557     }
558 
559 
560     function setOffchainPayment(
561         address _address,
562         bool _flag
563     )
564         external
565     {
566         onlyManagers();
567         offchainPayment[_address] = _flag;
568         emit Emit_OffchainPaymentFlag(_address, _address, _flag, _flag);
569     }
570 
571     function withdrawFunds(address _address)
572         external
573     {
574         onlyAdmin();
575         _address.transfer(address(this).balance);
576     }
577 
578     function randomDS_updateSessionPublicKeyHash(bytes32[] _newSessionPublicKeyHash)
579         public
580     {
581         onlyAdmin();
582         randomDS_sessionPublicKeyHash.length = 0;
583         for (uint256 i = 0; i < _newSessionPublicKeyHash.length; i++) {
584             randomDS_sessionPublicKeyHash.push(_newSessionPublicKeyHash[i]);
585         }
586     }
587 
588     function randomDS_getSessionPublicKeyHash()
589         public
590         view
591         returns (bytes32)
592     {
593         uint256 i = uint256(keccak256(requestCounter[msg.sender])) % randomDS_sessionPublicKeyHash.length;
594         return randomDS_sessionPublicKeyHash[i];
595     }
596 
597     function setCustomProofType(byte _proofType)
598         public
599     {
600         addressProofType[msg.sender] = _proofType;
601     }
602 
603     function setCustomGasPrice(uint256 _gasPrice)
604         external
605     {
606         addressCustomGasPrice[msg.sender] = _gasPrice;
607     }
608 
609     function getPrice(string _datasource)
610         view
611         public
612         returns (uint256 _datasourcePrice)
613     {
614         return getPrice(_datasource, msg.sender);
615     }
616 
617     function getPrice(byte _datasource)
618         view
619         public
620         returns (uint256 _datasourcePrice)
621     {
622         return getPrice(_datasource, msg.sender);
623     }
624 
625     function getPrice(
626         string _datasource,
627         uint256 _gasLimit
628     )
629         view
630         public
631         returns (uint256 _datasourcePrice)
632     {
633         return getPrice(_datasource, _gasLimit, msg.sender);
634     }
635 
636     function getPrice(
637         byte _datasource,
638         uint256 _gasLimit
639     )
640         view
641         public
642         returns (uint256 _datasourcePrice)
643     {
644         return getPrice(_datasource, _gasLimit, msg.sender);
645     }
646 
647     function getPrice(
648         string _datasource,
649         address _address
650     )
651         view
652         public
653         returns (uint256 _datasourcePrice)
654     {
655         return getPrice(_datasource, DEFAULT_GAS_LIMIT, _address);
656     }
657 
658 
659     function getPrice(
660         byte _datasource,
661         address _address
662     )
663         view
664         public
665         returns (uint256 _datasourcePrice)
666     {
667         return getPrice(_datasource, DEFAULT_GAS_LIMIT, _address);
668     }
669 
670     /**
671      * @dev The ordering of the comparatives in the third `if` statement
672      *      provide the greatest efficiency with respect to gas prices.
673      */
674     function getPrice(
675         string _datasource,
676         uint256 _gasLimit,
677         address _address
678     )
679         view
680         public
681         returns (uint256 _datasourcePrice)
682     {
683         if (offchainPayment[_address]) return 0;
684         uint256 customGasPrice = addressCustomGasPrice[_address];
685         if (requestCounter[_address] == 0 &&
686             _gasLimit <= DEFAULT_GAS_LIMIT &&
687             customGasPrice <= gasPrice &&
688             !isOriginCallbackAddress()) return 0;
689         if (customGasPrice == 0) customGasPrice = gasPrice;
690        _datasourcePrice = price[keccak256(
691             _datasource,
692             addressProofType[_address]
693         )];
694         _datasourcePrice += _gasLimit * customGasPrice;
695         return _datasourcePrice;
696     }
697 
698     /**
699      * @dev Ibid.
700     */
701     function getPrice(
702         byte _datasource,
703         uint256 _gasLimit,
704         address _address
705     )
706         view
707         public
708         returns (uint256 _datasourcePrice)
709     {
710 
711         if (offchainPayment[_address]) return 0;
712         uint256 customGasPrice = addressCustomGasPrice[_address];
713         if (requestCounter[_address] == 0 &&
714             _gasLimit <= DEFAULT_GAS_LIMIT &&
715             customGasPrice <= gasPrice &&
716             !isOriginCallbackAddress()) return 0;
717         if (customGasPrice == 0) customGasPrice = gasPrice;
718        _datasourcePrice = price[keccak256(
719             _datasource,
720             addressProofType[_address]
721         )];
722         _datasourcePrice += _gasLimit * customGasPrice;
723         return _datasourcePrice;
724     }
725 
726     function query(
727         string _datasource,
728         string _arg
729     )
730         payable
731         external
732         returns (bytes32 _id)
733     {
734         return query1(0, _datasource, _arg, DEFAULT_GAS_LIMIT);
735     }
736 
737     function query(
738         byte _datasource,
739         string _arg
740     )
741         payable
742         external
743         returns (bytes32 _id)
744     {
745         return query1(0, _datasource, _arg, DEFAULT_GAS_LIMIT);
746     }
747 
748     function query1(
749         string _datasource,
750         string _arg
751     )
752         payable
753         external
754         returns (bytes32 _id)
755     {
756         return query1(0, _datasource, _arg, DEFAULT_GAS_LIMIT);
757     }
758 
759     function query1(
760         byte _datasource,
761         string _arg
762     )
763         payable
764         external
765         returns (bytes32 _id)
766     {
767         return query1(0, _datasource, _arg, DEFAULT_GAS_LIMIT);
768     }
769 
770    function query2(
771         string _datasource,
772         string _arg1,
773         string _arg2
774     )
775         payable
776         external
777         returns (bytes32 _id)
778     {
779         return query2(0, _datasource, _arg1, _arg2, DEFAULT_GAS_LIMIT);
780     }
781 
782     function query2(
783         byte _datasource,
784         string _arg1,
785         string _arg2
786     )
787         payable
788         external
789         returns (bytes32 _id)
790     {
791         return query2(0, _datasource, _arg1, _arg2, DEFAULT_GAS_LIMIT);
792     }
793 
794     function queryN(
795         string _datasource,
796         bytes _args
797     )
798         payable
799         external
800         returns (bytes32 _id)
801     {
802         return queryN(0, _datasource, _args, DEFAULT_GAS_LIMIT);
803     }
804 
805     function queryN(
806         byte _datasource,
807         bytes _args
808     )
809         payable
810         external
811         returns (bytes32 _id)
812     {
813         return queryN(0, _datasource, _args, DEFAULT_GAS_LIMIT);
814     }
815 
816     function query(
817         uint256 _timestamp,
818         string _datasource,
819         string _arg
820     )
821         payable
822         external
823         returns (bytes32 _id)
824     {
825         return query1(_timestamp, _datasource, _arg, DEFAULT_GAS_LIMIT);
826     }
827 
828     function query(
829         uint256 _timestamp,
830         byte _datasource,
831         string _arg
832     )
833         payable
834         external
835         returns (bytes32 _id)
836     {
837         return query1(_timestamp, _datasource, _arg, DEFAULT_GAS_LIMIT);
838     }
839 
840     function query1(
841         uint256 _timestamp,
842         string _datasource,
843         string _arg
844     )
845         payable
846         external
847         returns (bytes32 _id)
848     {
849         return query1(_timestamp, _datasource, _arg, DEFAULT_GAS_LIMIT);
850     }
851 
852     function query1(
853         uint256 _timestamp,
854         byte _datasource,
855         string _arg
856     )
857         payable
858         external
859         returns (bytes32 _id)
860     {
861         return query1(_timestamp, _datasource, _arg, DEFAULT_GAS_LIMIT);
862     }
863 
864     function query2(
865         uint256 _timestamp,
866         string _datasource,
867         string _arg1,
868         string _arg2
869     )
870         payable
871         external
872         returns (bytes32 _id)
873     {
874         return query2(_timestamp, _datasource, _arg1, _arg2, DEFAULT_GAS_LIMIT);
875     }
876 
877     function query2(
878         uint256 _timestamp,
879         byte _datasource,
880         string _arg1,
881         string _arg2
882     )
883         payable
884         external
885         returns (bytes32 _id)
886     {
887         return query2(_timestamp, _datasource, _arg1, _arg2, DEFAULT_GAS_LIMIT);
888     }
889 
890     function queryN(
891         uint256 _timestamp,
892         string _datasource,
893         bytes _args
894     )
895         payable
896         external
897         returns (bytes32 _id)
898     {
899         return queryN(_timestamp, _datasource, _args, DEFAULT_GAS_LIMIT);
900     }
901 
902     function queryN(
903         uint256 _timestamp,
904         byte _datasource,
905         bytes _args
906     )
907         payable
908         external
909         returns (bytes32 _id)
910     {
911         return queryN(_timestamp, _datasource, _args, DEFAULT_GAS_LIMIT);
912     }
913 
914     function queryWithGasLimit(
915         uint256 _timestamp,
916         string _datasource,
917         string _arg,
918         uint256 _gasLimit
919     )
920         payable
921         external
922         returns (bytes32 _id)
923     {
924         return query1(_timestamp, _datasource, _arg, _gasLimit);
925     }
926 
927     function queryWithGasLimit(
928         uint256 _timestamp,
929         byte _datasource,
930         string _arg,
931         uint256 _gasLimit
932     )
933         payable
934         external
935         returns (bytes32 _id)
936     {
937         return query1(_timestamp, _datasource, _arg, _gasLimit);
938     }
939 
940     function query1WithGasLimit(
941         uint256 _timestamp,
942         string _datasource,
943         string _arg,
944         uint256 _gasLimit
945     )
946         payable
947         external
948         returns (bytes32 _id)
949     {
950         return query1(_timestamp, _datasource, _arg, _gasLimit);
951     }
952 
953     function query1WithGasLimit(
954         uint256 _timestamp,
955         byte _datasource,
956         string _arg,
957         uint256 _gasLimit
958     )
959         payable
960         external
961         returns (bytes32 _id)
962     {
963         return query1(_timestamp, _datasource, _arg, _gasLimit);
964     }
965 
966     function query2WithGasLimit(
967         uint256 _timestamp,
968         string _datasource,
969         string _arg1,
970         string _arg2,
971         uint256 _gasLimit
972     )
973         payable
974         external
975         returns (bytes32 _id)
976     {
977         return query2(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
978     }
979 
980     function query2WithGasLimit(
981         uint256 _timestamp,
982         byte _datasource,
983         string _arg1,
984         string _arg2,
985         uint256 _gasLimit
986     )
987         payable
988         external
989         returns (bytes32 _id)
990     {
991         return query2(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
992     }
993 
994     function queryNWithGasLimit(
995         uint256 _timestamp,
996         string _datasource,
997         bytes _args,
998         uint256 _gasLimit
999     )
1000         payable
1001         external
1002         returns (bytes32 _id)
1003     {
1004         return queryN(_timestamp, _datasource, _args, _gasLimit);
1005     }
1006 
1007     function queryNWithGasLimit(
1008         uint256 _timestamp,
1009         byte _datasource,
1010         bytes _args,
1011         uint256 _gasLimit
1012     )
1013         payable
1014         external
1015         returns (bytes32 _id)
1016     {
1017         return queryN(_timestamp, _datasource, _args, _gasLimit);
1018     }
1019 
1020     /**
1021      * @dev In the following `query` functions, any timestamps that pertain
1022      *      to a delay greater than 60 days are invalid. This is enforced
1023      *      off-chain and thus no check appears here.
1024      *
1025      *      Also enforced off-chain and so not checked herein is that the
1026      *      provided `_gasLimit` is less than or equal to the current block
1027      *      gas limit.
1028      */
1029     function query1(
1030         uint256 _timestamp,
1031         string _datasource,
1032         string _arg,
1033         uint256 _gasLimit
1034     )
1035         payable
1036         public
1037         returns (bytes32 _id)
1038     {
1039         costs(_datasource, _gasLimit);
1040         _id = keccak256(
1041             this,
1042             msg.sender,
1043             requestCounter[msg.sender]++
1044         );
1045         emit Log1(
1046             msg.sender,
1047             _id,
1048             _timestamp,
1049             _datasource,
1050             _arg,
1051             _gasLimit,
1052             addressProofType[msg.sender],
1053             addressCustomGasPrice[msg.sender]
1054         );
1055         return _id;
1056     }
1057 
1058     function query1(
1059         uint256 _timestamp,
1060         byte _datasource,
1061         string _arg,
1062         uint256 _gasLimit
1063     )
1064         payable
1065         public
1066         returns (bytes32 _id)
1067     {
1068         costs(_datasource, _gasLimit);
1069         _id = keccak256(
1070             this,
1071             msg.sender,
1072             requestCounter[msg.sender]++
1073         );
1074         emit Log1_byte(
1075             msg.sender,
1076             _id,
1077             _timestamp,
1078             _datasource,
1079             _arg,
1080             _gasLimit,
1081             addressProofType[msg.sender],
1082             addressCustomGasPrice[msg.sender]
1083         );
1084         return _id;
1085     }
1086 
1087     function query2(
1088         uint256 _timestamp,
1089         string _datasource,
1090         string _arg1,
1091         string _arg2,
1092         uint256 _gasLimit
1093     )
1094         payable
1095         public
1096         returns (bytes32 _id)
1097     {
1098         costs(_datasource, _gasLimit);
1099         _id = keccak256(
1100             this,
1101             msg.sender,
1102             requestCounter[msg.sender]++
1103         );
1104         emit Log2(
1105             msg.sender,
1106             _id,
1107             _timestamp,
1108             _datasource,
1109             _arg1,
1110             _arg2,
1111             _gasLimit,
1112             addressProofType[msg.sender],
1113             addressCustomGasPrice[msg.sender]
1114         );
1115         return _id;
1116     }
1117 
1118     function query2(
1119         uint256 _timestamp,
1120         byte _datasource,
1121         string _arg1,
1122         string _arg2,
1123         uint256 _gasLimit
1124     )
1125         payable
1126         public
1127         returns (bytes32 _id)
1128     {
1129         costs(_datasource, _gasLimit);
1130         _id = keccak256(
1131             this,
1132             msg.sender,
1133             requestCounter[msg.sender]++
1134         );
1135         emit Log2_byte(
1136             msg.sender,
1137             _id,
1138             _timestamp,
1139             _datasource,
1140             _arg1,
1141             _arg2,
1142             _gasLimit,
1143             addressProofType[msg.sender],
1144             addressCustomGasPrice[msg.sender]
1145         );
1146         return _id;
1147     }
1148 
1149     function queryN(
1150         uint256 _timestamp,
1151         string _datasource,
1152         bytes _args,
1153         uint256 _gasLimit
1154     )
1155         payable
1156         public
1157         returns (bytes32 _id)
1158     {
1159         costs(_datasource, _gasLimit);
1160         _id = keccak256(
1161             this,
1162             msg.sender,
1163             requestCounter[msg.sender]++
1164         );
1165         emit LogN(
1166             msg.sender,
1167             _id,
1168             _timestamp,
1169             _datasource,
1170             _args,
1171             _gasLimit,
1172             addressProofType[msg.sender],
1173             addressCustomGasPrice[msg.sender]
1174         );
1175         return _id;
1176     }
1177 
1178     function queryN(
1179         uint256 _timestamp,
1180         byte _datasource,
1181         bytes _args,
1182         uint256 _gasLimit
1183     )
1184         payable
1185         public
1186         returns (bytes32 _id)
1187     {
1188         costs(_datasource, _gasLimit);
1189         _id = keccak256(
1190             this,
1191             msg.sender,
1192             requestCounter[msg.sender]++
1193         );
1194         emit LogN_byte(
1195             msg.sender,
1196             _id,
1197             _timestamp,
1198             _datasource,
1199             _args,
1200             _gasLimit,
1201             addressProofType[msg.sender],
1202             addressCustomGasPrice[msg.sender]
1203         );
1204         return _id;
1205     }
1206 
1207     function getRebroadcastCost(
1208         uint256 _gasLimit,
1209         uint256 _gasPrice
1210     )
1211         pure
1212         public
1213         returns (uint256 _rebroadcastCost)
1214     {
1215         _rebroadcastCost = _gasPrice * _gasLimit;
1216         /**
1217          * @dev gas limit sanity check and overflow test
1218          */
1219         require(
1220             _gasLimit >= BASE_TX_COST &&
1221             _rebroadcastCost / _gasPrice == _gasLimit
1222         );
1223 
1224         return _rebroadcastCost;
1225     }
1226 
1227     /**
1228      * @dev     Allows a user to increase the gas price of a query to aid in
1229      *          ensuring prompt service during unexpected network traffic spikes.
1230      *
1231      * @notice  This function foregoes validation of the parameters provided
1232      *          and retains any passing value sent to it. Parameters provided
1233      *          are validated in the off-chain context, and irregular or
1234      *          impossible parameters will simply be ignored (e.g. gas limit
1235      *          above the current block gas limit).
1236      */
1237     function requestCallbackRebroadcast(
1238         bytes32 _queryId,
1239         uint256 _gasLimit,
1240         uint256 _gasPrice
1241     )
1242         payable
1243         external
1244     {
1245         uint256 ethCost = getRebroadcastCost(
1246             _gasLimit,
1247             _gasPrice
1248         );
1249 
1250         require (msg.value >= ethCost);
1251 
1252         if (msg.value > ethCost) {
1253             msg.sender.transfer(msg.value - ethCost);
1254         }
1255 
1256         emit CallbackRebroadcastRequest(
1257             _queryId,
1258             _gasLimit,
1259             _gasPrice
1260         );
1261     }
1262 
1263     /**
1264      * @dev Fires an event the engine watches for, to notify it to cache the
1265      *      specified query's parameters. ALL parameters for that specific
1266      *      query are cached, including timestamps & gas prices. When calling
1267      *      this function, a queryID needs to be explicitly sent in order to
1268      *      specify the exact query whose parameters the caller wants cached.
1269      */
1270     function requestQueryCaching(
1271         bytes32 _queryId
1272     )
1273         external
1274     {
1275         require(requestCounter[msg.sender] > 0);
1276 
1277         emit EnableCache(
1278             msg.sender,
1279             _queryId
1280         );
1281     }
1282 
1283     /**
1284      * @dev     Function which requests the calling contract's cached query
1285      *          be processed.
1286      *
1287      * @notice  A query must be cached by the sender first. Correct funding
1288      *          must be provided, or will be ignored by the Provable service.
1289      *          In order to make query-caching as efficient as possible there
1290      *          are NO on-chain checks regarding sufficient payment. Thus any
1291      *          queries found to be under-funded will be dropped by Provable.
1292      */
1293     function queryCached()
1294         payable
1295         external
1296         returns (bytes32 _id)
1297     {
1298         _id = keccak256(
1299             this,
1300             msg.sender,
1301             requestCounter[msg.sender]++
1302         );
1303 
1304         emit LogCached(
1305             msg.sender,
1306             _id,
1307             msg.value
1308         );
1309     }
1310 
1311     /**
1312      * @notice  The following functions provide backwards-compatibility
1313      *          with previous Provable connectors.
1314      *
1315      */
1316     function setProofType(byte _proofType)
1317         external
1318     {
1319         setCustomProofType(_proofType);
1320     }
1321 
1322     function removeCbAddress(address _callbackAddress)
1323         external
1324     {
1325         removeCallbackAddress(_callbackAddress);
1326     }
1327 
1328     function cbAddresses(address _address)
1329         external
1330         view
1331         returns (byte)
1332     {
1333         return callbackAddresses[_address];
1334     }
1335 
1336 
1337     function cbAddress()
1338         public
1339         view
1340         returns (address _callbackAddress)
1341     {
1342         if (callbackAddresses[tx.origin] != 0)
1343             _callbackAddress = tx.origin;
1344     }
1345 
1346     function addCbAddress(
1347         address _newCallbackAddress,
1348         byte _addressType
1349     )
1350         external
1351     {
1352         addCallbackAddress(
1353             _newCallbackAddress,
1354             _addressType
1355         );
1356     }
1357 
1358     function addCbAddress(
1359         address _newCallbackAddress,
1360         byte _addressType,
1361         bytes _proof
1362     )
1363         external
1364     {
1365         addCallbackAddress(
1366             _newCallbackAddress,
1367             _addressType,
1368             _proof
1369         );
1370     }
1371 
1372     function addDSource(
1373         string _datasourceName,
1374         uint256 _multiplier
1375     )
1376         external
1377     {
1378         addDatasource(
1379             _datasourceName,
1380             _multiplier
1381         );
1382     }
1383 
1384     function multiAddDSource(
1385         bytes32[] _datasourceHashes,
1386         uint256[] _multipliers
1387     )
1388         external
1389     {
1390         multiAddDatasources(
1391             _datasourceHashes,
1392             _multipliers
1393         );
1394     }
1395 
1396     function multisetProofType(
1397         uint256[] _proofTypes,
1398         address[] _addresses
1399     )
1400         external
1401     {
1402         multiSetProofTypes(
1403             _proofTypes,
1404             _addresses
1405         );
1406     }
1407 
1408     function multisetCustomGasPrice(
1409         uint256[] _gasPrice,
1410         address[] _addr
1411     )
1412         external
1413     {
1414         multiSetCustomGasPrices(
1415             _gasPrice,
1416             _addr
1417         );
1418     }
1419 
1420     function randomDS_getSessionPubKeyHash()
1421         external
1422         view
1423         returns (bytes32)
1424     {
1425         return randomDS_getSessionPublicKeyHash();
1426     }
1427 
1428 
1429     function randomDS_updateSessionPubKeysHash(
1430         bytes32[] _newSessionPublicKeyHash
1431     )
1432         external
1433     {
1434         randomDS_updateSessionPublicKeyHash(_newSessionPublicKeyHash);
1435     }
1436 
1437     function query_withGasLimit(
1438         uint256 _timestamp,
1439         string _datasource,
1440         string _arg,
1441         uint256 _gasLimit
1442     )
1443         payable
1444         external
1445         returns (bytes32 _id)
1446     {
1447         return query1(
1448             _timestamp,
1449             _datasource,
1450             _arg,
1451             _gasLimit
1452         );
1453     }
1454 
1455     function query1_withGasLimit(
1456         uint256 _timestamp,
1457         string _datasource,
1458         string _arg,
1459         uint256 _gasLimit
1460     )
1461         payable
1462         external
1463         returns (bytes32 _id)
1464     {
1465         return query1(
1466             _timestamp,
1467             _datasource,
1468             _arg,
1469             _gasLimit
1470         );
1471     }
1472 
1473     function query2_withGasLimit(
1474         uint256 _timestamp,
1475         string _datasource,
1476         string _arg1,
1477         string _arg2,
1478         uint256 _gasLimit
1479     )
1480         payable
1481         external
1482         returns (bytes32 _id)
1483     {
1484         return query2(
1485             _timestamp,
1486             _datasource,
1487             _arg1,
1488             _arg2,
1489             _gasLimit
1490         );
1491     }
1492 
1493     function queryN_withGasLimit(
1494         uint256 _timestamp,
1495         string _datasource,
1496         bytes _args,
1497         uint256 _gasLimit
1498     )
1499         payable
1500         external
1501         returns (bytes32 _id)
1502     {
1503         return queryN(
1504             _timestamp,
1505             _datasource,
1506             _args,
1507             _gasLimit
1508         );
1509     }
1510 }