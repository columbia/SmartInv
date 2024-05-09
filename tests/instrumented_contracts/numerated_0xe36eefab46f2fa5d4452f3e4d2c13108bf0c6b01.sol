1 pragma solidity ^0.4.13;
2 
3 contract Commons {
4 
5     int256 constant INT256_MIN = int256((uint256(1) << 255));
6     int256 constant INT256_MAX = int256(~((uint256(1) << 255)));
7     uint256 constant UINT256_MIN = 0;
8     uint256 constant UINT256_MAX = ~uint256(0);
9 
10     struct IndexElem {
11         bytes32 mappingId;
12         int nOp;
13     }
14 
15     function Commons() internal { }
16 }
17 
18 contract Ownable {
19 
20     address internal owner;
21 
22     event LogTransferOwnership(address previousOwner, address newOwner);
23 
24     /**
25     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26     * account.
27     */
28     function Ownable() internal
29     {
30         owner = msg.sender;
31     }
32 
33     /**
34     * @dev Throws if called by any account other than the owner.
35     */
36     modifier ownerOnly()
37     {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     /**
43     * @dev Allows the current owner to transfer control of the contract to a newOwner.
44     * @param _newOwner The address to transfer ownership to.
45     */
46     function transferOwnership(address _newOwner) external
47         ownerOnly
48     {
49         require(_newOwner != address(0));
50         emit LogTransferOwnership(owner, _newOwner);
51         owner = _newOwner;
52     }
53 
54     /**
55      *
56      */
57     function getOwner() external view returns (address) {
58         return owner;
59     }
60 }
61 
62 contract Authorized is Ownable {
63 
64     struct User {
65         string friendlyName;
66         string offChainIdentity;
67         bool isRegulator;
68         bool isProducer;
69         bool isWinery;
70     }
71 
72     mapping (address => User) public onChainIdentities;    
73     mapping (bytes32 => address) public onChainAddresses;
74 
75     event LogSetUser
76     (
77         address account, 
78         string oldFriendlyName, 
79         string oldOffChainIdentity, 
80         bool oldIsProducer, 
81         bool oldIsWinery, 
82         bool oldIsRegulator, 
83         address indexed operationSender
84     );
85 
86     event LogSetWinery
87     (
88         address winery, 
89         bool oldIsValid, 
90         bool isValid, 
91         address indexed operationSender
92     );
93 
94     event LogSetRegulator
95     (
96         address regulator, 
97         bool oldValue, 
98         bool value, 
99         address indexed operationSender
100     );
101 
102     event LogSetProducer
103     (
104         address producer, 
105         bool oldValue, 
106         bool value, 
107         address indexed operationSender
108     );
109 
110     function Authorized() internal { }
111 
112     modifier producersOnly() {
113         require(onChainIdentities[msg.sender].isProducer);
114         _;
115     }
116 
117     modifier wineriesOnly() {
118         require(onChainIdentities[msg.sender].isWinery);
119         _;
120     }
121 
122     modifier regulatorsOnly() {
123         require(onChainIdentities[msg.sender].isRegulator);
124         _;
125     }
126 
127     function setUser(
128         address _address,
129         string _friendlyName,
130         string _offChainIdentity,
131         bool _isRegulator,
132         bool _isProducer,
133         bool _isWinery
134     ) 
135         public
136         ownerOnly
137     {
138         emit LogSetUser (
139             _address, 
140             onChainIdentities[_address].friendlyName, 
141             onChainIdentities[_address].offChainIdentity, 
142             onChainIdentities[_address].isProducer, 
143             onChainIdentities[_address].isWinery, 
144             onChainIdentities[_address].isRegulator, 
145             msg.sender
146         );
147         onChainAddresses[keccak256(_offChainIdentity)] = _address;
148         onChainIdentities[_address].friendlyName = _friendlyName;
149         onChainIdentities[_address].offChainIdentity = _offChainIdentity;
150         onChainIdentities[_address].isRegulator = _isRegulator;
151         onChainIdentities[_address].isProducer = _isProducer;
152         onChainIdentities[_address].isWinery = _isWinery;
153     }
154 
155     function getOffChainIdentity(address _address) internal view returns (string offChainIdentity)
156     {
157         return onChainIdentities[_address].offChainIdentity;
158     }
159 
160     function getUser(address _address)
161         external view
162         returns (
163             string friendlyName, 
164             string offChainIdentity, 
165             bool isRegulator, 
166             bool isProducer, 
167             bool isWinery
168         ) 
169     {
170         return (
171             onChainIdentities[_address].friendlyName,
172             onChainIdentities[_address].offChainIdentity,
173             onChainIdentities[_address].isRegulator,
174             onChainIdentities[_address].isProducer,
175             onChainIdentities[_address].isWinery
176         );
177     }
178 
179     function getAddress(string _offChainIdentity) public view returns (address) {
180         return onChainAddresses[keccak256(_offChainIdentity)];
181     }
182 
183     function setRegulator(address _address, bool _newValue) external ownerOnly {
184         emit LogSetRegulator(_address, onChainIdentities[_address].isRegulator, _newValue, msg.sender);
185         onChainIdentities[_address].isRegulator = _newValue;
186     }
187 
188     function setProducer(address _address, bool _newValue) external ownerOnly {
189         emit LogSetProducer(_address, onChainIdentities[_address].isProducer, _newValue, msg.sender);
190         onChainIdentities[_address].isProducer = _newValue;
191     }
192 
193     function setWinery(address _address, bool _newValue) external ownerOnly {
194         emit LogSetProducer(_address, onChainIdentities[_address].isWinery, _newValue, msg.sender);
195         onChainIdentities[_address].isWinery = _newValue;
196     }
197 
198 }
199 
200 contract WineryOperations is Commons, Authorized {
201 
202     uint256 constant OPERATION_SEARCH_MAX = uint(INT256_MAX);
203 
204     struct WineryOperation {
205         address operationSender;
206         string offChainIdentity;   //cuaa
207         string operationID;        // hash (offChainIdentity, operationDate, operationCode)
208         string operationCode;      //Es. IMBO
209         uint operationDate;
210         uint16 areaCode;           // mapping
211         string codeICQRF;          // codice_icqrf_stabilimento
212         string attributes;
213         Product[] prods;
214         IndexElem[] parentList;
215         IndexElem[] childList;        
216     }
217 
218     struct Product {
219         string productID;      // codice_primario + codice_secondario
220         string quantity;        // 1,345 kg
221         string attributes;      // dsda; dasd;; sadas;
222     }
223 
224     mapping(bytes32 => WineryOperation[]) public wineries;
225 
226     event LogAddWineryOperation(
227         string _trackID,
228         address operationSender,
229         address indexed onChainIdentity,
230         string operationID,      
231         uint index
232     );
233 
234     event LogAddProduct(
235         string _trackID,
236         address operationSender,
237         address indexed onChainIdentity,
238         string indexed operationID,
239         string productID
240     );
241 
242     function WineryOperations() internal { }
243     
244     // ============================================================================================
245     // External functions for wineries
246     // ============================================================================================
247 
248     function addWineryOperation(
249         string _trackID,
250         string _operationID,
251         string _operationCode,
252         uint _operationDate,
253         uint16 _areaCode,
254         string _codeICQRF
255     )
256         external
257         wineriesOnly
258         returns (bool success)
259     {
260         bytes32 _mappingID = keccak256(_trackID, msg.sender);
261         addWineryOperation(
262             _mappingID,
263             msg.sender,
264             onChainIdentities[msg.sender].offChainIdentity,
265             _operationID,
266             _operationCode,
267             _operationDate,
268             _areaCode,
269             _codeICQRF
270         );
271         emit LogAddWineryOperation(
272             _trackID,
273             msg.sender,
274             msg.sender,
275             _operationID,
276             wineries[_mappingID].length
277         );
278         return true;
279     }
280 
281     function addProduct(
282         string _trackID,
283         uint _index,
284         string _productID,
285         string _quantity,
286         string _attributes
287     )
288         external
289         wineriesOnly
290         returns (bool success)
291     {
292         bytes32 _mappingID = keccak256(_trackID, msg.sender);
293         addProduct(
294             _mappingID,
295             _index,
296             _productID,
297             _quantity,
298             _attributes
299         );
300         emit LogAddProduct(
301             _trackID,
302             msg.sender,
303             msg.sender,
304             wineries[_mappingID][_index].operationID,
305             _productID
306         );
307         return true;
308     }
309 
310     function addReferenceParentWineryOperation(
311         string _trackID,
312         uint _numCurOperation,
313         string _parentTrackID,
314         address _parentWinery,
315         int _numParent        
316     )
317         external
318         wineriesOnly
319         returns (bool success)
320     {
321         addRelationshipBindingWineryOperation(
322             keccak256(_trackID, msg.sender),
323             _numCurOperation,
324             keccak256(_parentTrackID, _parentWinery),
325             _numParent
326         );
327         return true;
328     }
329 
330     function setOperationAttributes(
331         string _trackID,
332         uint _operationIndex,
333         string attributes
334     )
335         external
336         wineriesOnly
337         returns (bool success)
338     {
339         bytes32 _mappingID = keccak256(_trackID, msg.sender);
340         wineries[_mappingID][_operationIndex].attributes = attributes;
341         return true;
342     }
343 
344     function setProductAttributes(
345         string _trackID,
346         uint _operationIndex,
347         uint _productIndex,
348         string attributes
349     )
350         external
351         wineriesOnly
352         returns (bool success)
353     {
354         bytes32 _mappingID = keccak256(_trackID, msg.sender);
355         wineries[_mappingID][_operationIndex].prods[_productIndex].attributes = attributes;
356         return true;
357     }
358 
359     // ============================================================================================
360     // External functions for regulators
361     // ============================================================================================
362 
363     function addWineryOperationByRegulator(
364         string _trackID,
365         string _offChainIdentity,
366         string _operationID,
367         string _operationCode,
368         uint _operationDate,
369         uint16 _areaCode,
370         string _codeICQRF
371     )
372         external
373         regulatorsOnly
374     {
375         address _winery = getAddress(_offChainIdentity);
376         bytes32 _mappingID = keccak256(_trackID, _winery);
377         addWineryOperation(
378             _mappingID,
379             msg.sender,
380             _offChainIdentity,
381             _operationID,
382             _operationCode,
383             _operationDate,
384             _areaCode,
385             _codeICQRF
386         );
387         emit LogAddWineryOperation(
388             _trackID,
389             msg.sender,
390             _winery,
391             _operationID,
392             wineries[_mappingID].length
393         );
394     }
395     
396     function addProductByRegulator(
397         string _trackID,
398         uint _index,
399         string _offChainIdentity,
400         string _productID,
401         string _quantity,
402         string _attributes
403     )
404         external
405         regulatorsOnly
406     {
407         address _winery = getAddress(_offChainIdentity);
408         bytes32 _mappingID = keccak256(_trackID, _winery);
409         addProduct(
410             _mappingID,
411             _index,
412             _productID,
413             _quantity,
414             _attributes
415         );
416         emit LogAddProduct(
417             _trackID,
418             msg.sender,
419             _winery,
420             wineries[_mappingID][_index].operationID,
421             _productID
422         );
423     }
424 
425     function setOperationAttributesByRegulator(
426         string _trackID,
427         string _offChainIdentity,
428         uint _operationIndex,
429         string attributes
430     )
431         external
432         regulatorsOnly
433         returns (bool success)
434     {     
435         address _winery = getAddress(_offChainIdentity);
436         bytes32 _mappingID = keccak256(_trackID, _winery);
437         wineries[_mappingID][_operationIndex].attributes = attributes;
438         return true;
439     }
440 
441     function setProductAttributesByRegulator(
442         string _trackID,
443         string _offChainIdentity,
444         uint _operationIndex,
445         uint _productIndex,
446         string attributes
447     )
448         external
449         regulatorsOnly
450         returns (bool success)
451     {
452         address _winery = getAddress(_offChainIdentity);
453         bytes32 _mappingID = keccak256(_trackID, _winery);
454         wineries[_mappingID][_operationIndex].prods[_productIndex].attributes = attributes;
455         return true;
456     }
457 
458     function addReferenceParentWineryOperationByRegulator(
459         string _trackID,
460         string _offChainIdentity,
461         uint _numCurOperation,
462         string _parentTrackID,
463         string _parentOffChainIdentity,
464         int _numParent        
465     )
466         external
467         regulatorsOnly
468         returns (bool success)
469     {
470         address _winery = getAddress(_offChainIdentity);
471         address _parentWinery = getAddress(_parentOffChainIdentity);
472         addRelationshipBindingWineryOperation(
473             keccak256(_trackID, _winery),
474             _numCurOperation,
475             keccak256(_parentTrackID, _parentWinery),
476             _numParent
477         );
478         return true;
479     }
480 
481     // ============================================================================================
482     // Helpers for ÐApps
483     // ============================================================================================
484     
485     /// @notice ****
486     function getWineryOperation(string _trackID, address _winery, uint _index)
487         external view
488         returns (
489             address operationSender,
490             string offChainIdentity,
491             string operationID,
492             string operationCode,
493             uint operationDate,
494             uint16 areaCode,
495             string codeICQRF,
496             string attributes
497         )
498     {
499         bytes32 _mappingID = keccak256(_trackID, _winery);
500         operationSender = wineries[_mappingID][_index].operationSender;
501         offChainIdentity = wineries[_mappingID][_index].offChainIdentity;
502         operationID = wineries[_mappingID][_index].operationID;
503         operationCode = wineries[_mappingID][_index].operationCode;
504         operationDate = wineries[_mappingID][_index].operationDate;
505         areaCode = wineries[_mappingID][_index].areaCode;
506         codeICQRF = wineries[_mappingID][_index].codeICQRF;
507         attributes = wineries[_mappingID][_index].attributes;
508     }
509 
510     function getProductOperation(string _trackID, address _winery, uint _index, uint _productIndex)
511         external view
512         returns (
513             string productID,
514             string quantity,
515             string attributes
516         )
517     {
518         bytes32 _mappingID = keccak256(_trackID, _winery);
519         productID = wineries[_mappingID][_index].prods[_productIndex].productID;
520         quantity = wineries[_mappingID][_index].prods[_productIndex].quantity;
521         attributes = wineries[_mappingID][_index].prods[_productIndex].attributes;
522     }
523 
524     function getNumPositionOperation(string _trackID, address _winery, string _operationID)
525         external view
526         returns (int position)
527     {
528         bytes32 _mappingID = keccak256(_trackID, _winery);
529         for (uint i = 0; i < wineries[_mappingID].length && i < OPERATION_SEARCH_MAX; i++) {
530             if (keccak256(wineries[_mappingID][i].operationID) == keccak256(_operationID)) {
531                 return int(i);
532             }
533         }
534         return -1;
535     }
536 
537     // ============================================================================================
538     // Private functions
539     // ============================================================================================
540 
541     /// @notice TODO Commenti
542     function addWineryOperation(
543         bytes32 _mappingID,
544         address _operationSender,
545         string _offChainIdentity,
546         string _operationID,
547         string _operationCode,
548         uint _operationDate,
549         uint16 _areaCode,
550         string _codeICQRF
551     )
552         private
553     {
554         uint size = wineries[_mappingID].length;
555         wineries[_mappingID].length++;
556         wineries[_mappingID][size].operationSender = _operationSender;
557         wineries[_mappingID][size].offChainIdentity = _offChainIdentity;
558         wineries[_mappingID][size].operationID = _operationID;
559         wineries[_mappingID][size].operationCode = _operationCode;
560         wineries[_mappingID][size].operationDate = _operationDate;
561         wineries[_mappingID][size].areaCode = _areaCode;
562         wineries[_mappingID][size].codeICQRF = _codeICQRF;
563     }
564 
565     /// @notice TODO Commenti
566     function addProduct(
567         bytes32 _mappingID,
568         uint _index,
569         string _productID,
570         string _quantity,
571         string _attributes
572     )
573         private
574     {
575         wineries[_mappingID][_index].prods.push(
576             Product(
577                 _productID,
578                 _quantity,
579                 _attributes
580             )
581         );
582     }
583 
584     function addRelationshipBindingWineryOperation(
585         bytes32 _mappingID,
586         uint _numCurOperation,
587         bytes32 _parentMappingID,        
588         int _numParent        
589     )
590         private
591     {
592         require(_numCurOperation < OPERATION_SEARCH_MAX);
593         require(_numParent >= 0);
594         uint _parentIndex = uint(_numParent);
595         int _numCurOperationINT = int(_numCurOperation);
596         wineries[_mappingID][_numCurOperation].parentList.push(IndexElem(_parentMappingID, _numParent));
597         wineries[_parentMappingID][_parentIndex].childList.push(IndexElem(_mappingID, _numCurOperationINT));
598     }
599 
600   /*
601     
602     // ======================================================================================
603     // ÐApps helpers
604     // ======================================================================================
605 
606 
607 
608 
609     function getParentOperation(bytes32 _mappingID, uint8 _index, uint8 _nParent) external view returns (bytes32 id, int num) {
610         id = wineries[_mappingID][_index].parentList[_nParent].mappingId;
611         num = wineries[_mappingID][_index].parentList[_nParent].nOp;
612     }
613 
614     function getNumParentOperation(bytes32 _mappingID, uint8 _index) external view returns (uint num) {
615         num = wineries[_mappingID][_index].parentList.length;
616     }
617 
618     function getChildOperation(bytes32 _mappingID, uint8 _index, uint8 _nParent) external view returns (bytes32 id, int num) {
619         id = wineries[_mappingID][_index].childList[_nParent].mappingId;
620         num = wineries[_mappingID][_index].childList[_nParent].nOp;
621     }
622 
623     function getNumChildOperation(bytes32 _mappingID, uint8 _index) external view returns (uint num) {
624         num = wineries[_mappingID][_index].childList.length;
625     }
626     
627     function getNumPositionProduct(bytes32 _mappingID, uint8 _nPosOp, string _productId) external view returns (int position) {
628         position = -1;
629         for (uint8 i = 0; i < wineries[_mappingID][_nPosOp].prods.length; i++) {
630             if (keccak256(wineries[_mappingID][_nPosOp].prods[i].productID) == keccak256(_productId))
631                 position = i;
632         }
633     }
634 
635     function getNumWineryOperation(bytes32 _mappingID) external view returns (uint num) {
636         num = wineries[_mappingID].length;
637     }
638 
639     */
640 
641 }
642 
643 contract ProducerOperations is Commons, Authorized {
644 
645     // ============================================================================================
646     // Producer operations
647     // ============================================================================================
648 
649     struct HarvestOperation {
650         address operationSender;
651         string offChainIdentity;
652         string operationID;    // codice_allegato
653         uint32 quantity;        // uva_rivendicata (kg)
654         uint24 areaCode;        // cod_istat regione_provenienza_uve, mapping
655         uint16 year;            // anno raccolta
656         string attributes;      
657         IndexElem child;
658         Vineyard[] vineyards;
659     }
660 
661     struct Vineyard {
662         uint16 variety;        // varietà mapping descrizione_varieta
663         uint24 areaCode;       // codice_istat_comune, mapping dal quale si ricaverà anche prov. e descrizione
664         uint32 usedSurface;    // vigneto utilizzato (superficie_utilizzata) mq2
665         uint16 plantingYear;
666     }
667 
668     mapping(bytes32 => HarvestOperation) public harvests;
669     
670     event LogStoreHarvestOperation(
671         string trackIDs,
672         address operationSender,
673         address indexed onChainIdentity,
674         string operationID
675     );
676 
677     event LogAddVineyard(
678         string trackIDs,
679         address operationSender,
680         address indexed onChainIdentity,
681         uint24 indexed areaCode       
682     );
683 
684     function ProducerOperations() internal { }
685     
686     // ============================================================================================
687     // External functions for producers
688     // ============================================================================================
689 
690     /// @notice ****
691     /// @dev ****
692     /// @param _trackIDs ****
693     /// @return true if operation is successful
694     function storeHarvestOperation(
695         string _trackIDs,
696         string _operationID,
697         uint32 _quantity,
698         uint16 _areaCode,
699         uint16 _year,
700         string _attributes
701     )
702         external
703         producersOnly
704         returns (bool success)
705     {
706         storeHarvestOperation(
707             keccak256(_trackIDs, msg.sender),
708             msg.sender,
709             getOffChainIdentity(msg.sender),
710             _operationID,            
711             _quantity,
712             _areaCode,
713             _year,
714             _attributes
715         );
716         emit LogStoreHarvestOperation(
717             _trackIDs,
718             msg.sender,
719             msg.sender,
720             _operationID
721         );
722         return true;
723     }
724 
725     /// @notice ****
726     /// @dev ****
727     /// @param _trackIDs ****
728     /// @return true if operation is successful
729     function addVineyard(
730         string _trackIDs,
731         uint16 _variety,
732         uint24 _areaCode,
733         uint32 _usedSurface,
734         uint16 _plantingYear
735     )
736         external
737         producersOnly
738         returns (bool success)
739     {
740         addVineyard(
741             keccak256(_trackIDs, msg.sender),
742             _variety,
743             _areaCode,            
744             _usedSurface,
745             _plantingYear
746         );
747         emit LogAddVineyard(_trackIDs, msg.sender, msg.sender, _areaCode);
748         return true;
749     }
750 
751     // ============================================================================================
752     // External functions for regulators
753     // ============================================================================================
754 
755     function storeHarvestOperationByRegulator(
756         string _trackIDs,
757         string _offChainIdentity,
758         string _operationID,
759         uint32 _quantity,
760         uint16 _areaCode,
761         uint16 _year,
762         string _attributes
763     )
764         external
765         regulatorsOnly
766         returns (bool success)
767     {
768         address _producer = getAddress(_offChainIdentity);
769         storeHarvestOperation(
770             keccak256(_trackIDs,_producer),
771             msg.sender,
772             _offChainIdentity,
773             _operationID,
774             _quantity,
775             _areaCode,
776             _year,
777             _attributes
778         );
779         emit LogStoreHarvestOperation(
780             _trackIDs,
781             msg.sender,
782             _producer,
783             _operationID
784         );
785         return true;
786     }
787 
788     function addVineyardByRegulator(
789         string _trackIDs,
790         string _offChainIdentity,
791         uint16 _variety,
792         uint24 _areaCode,
793         uint32 _usedSurface,
794         uint16 _plantingYear
795     )
796         external
797         regulatorsOnly
798         returns (bool success)
799     {
800         address _producer = getAddress(_offChainIdentity);
801         require(_producer != address(0));
802         addVineyard(
803             keccak256(_trackIDs,_producer),
804             _variety,
805             _areaCode,
806             _usedSurface,
807             _plantingYear
808         );
809         emit LogAddVineyard(_trackIDs, msg.sender, _producer, _areaCode);
810         return true;
811     }
812 
813     // ============================================================================================
814     // Helpers for ÐApps
815     // ============================================================================================
816 
817     function getHarvestOperation(string _trackID, address _producer)
818         external view
819         returns (
820             address operationSender,
821             string offChainIdentity,
822             string operationID,
823             uint32 quantity,
824             uint24 areaCode,
825             uint16 year,
826             string attributes
827         )
828     {
829         bytes32 _mappingID32 = keccak256(_trackID, _producer);
830         operationSender = harvests[_mappingID32].operationSender;
831         offChainIdentity = harvests[_mappingID32].offChainIdentity;
832         operationID = harvests[_mappingID32].operationID;
833         quantity = harvests[_mappingID32].quantity;
834         areaCode = harvests[_mappingID32].areaCode;
835         year = harvests[_mappingID32].year;
836         attributes = harvests[_mappingID32].attributes;
837     }
838 
839     function getVineyard(string _trackID, address _producer, uint _index)
840         external view
841         returns (
842             uint32 variety,
843             uint32 areaCode,
844             uint32 usedSurface,
845             uint16 plantingYear
846         )
847     {
848         bytes32 _mappingID32 = keccak256(_trackID, _producer);
849         variety = harvests[_mappingID32].vineyards[_index].variety;
850         areaCode = harvests[_mappingID32].vineyards[_index].areaCode;
851         usedSurface = harvests[_mappingID32].vineyards[_index].usedSurface;
852         plantingYear = harvests[_mappingID32].vineyards[_index].plantingYear;
853     }
854 
855     function getVineyardCount(string _trackID, address _producer)
856         external view
857         returns (uint numberOfVineyards)
858     {
859         bytes32 _mappingID32 = keccak256(_trackID, _producer);
860         numberOfVineyards = harvests[_mappingID32].vineyards.length;
861     }
862 
863     // ============================================================================================
864     // Private functions
865     // ============================================================================================
866 
867     function storeHarvestOperation(
868         bytes32 _mappingID,
869         address _operationSender,
870         string _offChainIdentity,
871         string _operationID,
872         uint32 _quantity,
873         uint24 _areaCode,        
874         uint16 _year,
875         string _attributes
876     )
877         private
878     {
879         harvests[_mappingID].operationSender = _operationSender;
880         harvests[_mappingID].offChainIdentity = _offChainIdentity;
881         harvests[_mappingID].operationID = _operationID;
882         harvests[_mappingID].quantity = _quantity;
883         harvests[_mappingID].areaCode = _areaCode;
884         harvests[_mappingID].year = _year;
885         harvests[_mappingID].attributes = _attributes;
886     }
887 
888     function addVineyard(
889         bytes32 _mappingID,
890         uint16 _variety,
891         uint24 _areaCode,
892         uint32 _usedSurface,
893         uint16 _plantingYear        
894     )
895         private
896     {
897         harvests[_mappingID].vineyards.push(
898             Vineyard(_variety, _areaCode, _usedSurface, _plantingYear)
899         );
900     }
901     
902 }
903 
904 contract Upgradable is Ownable {
905 
906     address public newAddress;
907     uint    public deprecatedSince;
908     string  public version;
909     string  public newVersion;
910     string  public reason;
911 
912     event LogSetDeprecated(address newAddress, string newVersion, string reason);
913 
914     /**
915      *
916      */
917     function Upgradable(string _version) internal
918     {
919         version = _version;
920     }
921 
922     /**
923      *
924      */
925     function setDeprecated(address _newAddress, string _newVersion, string _reason) external
926         ownerOnly
927         returns (bool success)
928     {
929         require(!isDeprecated());
930         require(_newAddress != address(this));
931         require(!Upgradable(_newAddress).isDeprecated());
932         deprecatedSince = now;
933         newAddress = _newAddress;
934         newVersion = _newVersion;
935         reason = _reason;
936         emit LogSetDeprecated(_newAddress, _newVersion, _reason);
937         return true;
938     }
939 
940     /**
941      * @notice check if the contract is deprecated
942      */
943     function isDeprecated() public view returns (bool deprecated)
944     {
945         return (deprecatedSince != 0);
946     }
947 }
948 
949 contract SmartBinding is Authorized {
950 
951     mapping (bytes32 => bytes32) public bindingSmartIdentity;
952  
953     event LogBindSmartIdentity (
954         string _trackIDs,
955         address operationSender,
956         address onChainIdentity,
957         string smartIdentity
958     );
959 
960     function SmartBinding() internal { }
961 
962     // ============================================================================================
963     // External functions for wineries
964     // ============================================================================================
965 
966     /// @notice ****
967     /// @dev ****
968     /// @param _trackIDs ****
969     /// @return true if operation is successful
970     function bindSmartIdentity(string _trackIDs, string _smartIdentity)
971         external
972         wineriesOnly
973     {
974         bindingSmartIdentity[keccak256(_smartIdentity, msg.sender)] = keccak256(_trackIDs, msg.sender);
975         emit LogBindSmartIdentity(_trackIDs, msg.sender, msg.sender, _smartIdentity);
976     }
977 
978     // ============================================================================================
979     // External functions for regulators
980     // ============================================================================================
981     
982     /// @notice ****
983     /// @dev ****
984     /// @param _trackIDs ****
985     /// @return true if operation is successful
986     function bindSmartIdentityByRegulator(
987         string _trackIDs,
988         string _offChainIdentity,  
989         string _smartIdentity
990     )
991         external
992         regulatorsOnly
993     {
994         address winery = getAddress(_offChainIdentity);
995         bindingSmartIdentity[keccak256(_smartIdentity, winery)] = keccak256(_trackIDs, winery);
996         emit LogBindSmartIdentity(_trackIDs, msg.sender, winery, _smartIdentity);
997     }
998 
999     // ======================================================================================
1000     // ÐApps helpers
1001     // ======================================================================================
1002 
1003     function getWineryMappingID(string _smartIdentity, string _offChainIdentity)
1004         external view
1005         returns (bytes32 wineryMappingID)
1006     {
1007         bytes32 index = keccak256(_smartIdentity, getAddress(_offChainIdentity));
1008         wineryMappingID = bindingSmartIdentity[index];
1009     }
1010 
1011 }
1012 
1013 contract WineSupplyChain is
1014     Commons,
1015     Authorized,
1016     Upgradable,
1017     ProducerOperations,
1018     WineryOperations,
1019     SmartBinding
1020 {
1021 
1022     address public endorsements;
1023 
1024     function WineSupplyChain(address _endorsements) Upgradable("1.0.0") public {
1025         endorsements = _endorsements;
1026     }
1027 
1028     // ============================================================================================
1029     // External functions for regulators
1030     // ============================================================================================
1031 
1032     /// @notice TODO Inserire commenti
1033     function startWineryProductByRegulator(
1034         string _harvestTrackID,
1035         string _producerOffChainIdentity,
1036         string _wineryOperationTrackIDs,
1037         string _wineryOffChainIdentity,
1038         int _productIndex
1039     )
1040         external
1041         regulatorsOnly
1042         returns (bool success)
1043     {
1044         require(_productIndex >= 0);
1045         address producer = getAddress(_producerOffChainIdentity);
1046         bytes32 harvestMappingID = keccak256(_harvestTrackID, producer);
1047         address winery = getAddress(_wineryOffChainIdentity);
1048         bytes32 wineryOperationMappingID = keccak256(_wineryOperationTrackIDs, winery);
1049         harvests[harvestMappingID].child = IndexElem(wineryOperationMappingID, _productIndex);
1050         wineries[wineryOperationMappingID][uint(_productIndex)].parentList.push(
1051             IndexElem(harvestMappingID, -1));
1052         return true;
1053     }
1054 
1055     /// @notice TODO Commenti
1056     // TOCHECK AGGIUNGERE REQUIRE SU TIPO_OPERAZIONE = 'CASD' ???
1057     function startWinery(
1058         string _harvestTrackID,
1059         string _offChainProducerIdentity,
1060         string _wineryTrackID,
1061         uint _productIndex
1062     )
1063         external
1064         wineriesOnly
1065     {
1066         require(_productIndex >= 0);
1067         address producer = getAddress(_offChainProducerIdentity);
1068         bytes32 harvestMappingID = keccak256(_harvestTrackID, producer);
1069         bytes32 wineryOperationMappingID = keccak256(_wineryTrackID, msg.sender);
1070         wineries[wineryOperationMappingID][_productIndex].parentList.push(
1071             IndexElem(harvestMappingID, -1));
1072     }
1073 
1074     /// @notice TODO Commenti
1075     // TOCHECK AGGIUNGERE REQUIRE SU TIPO_OPERAZIONE = 'CASD' ???
1076     function startProduct(
1077         string _harvestTrackID,
1078         string _wineryTrackID,
1079         string _offChainWineryIdentity,
1080         int _productIndex
1081     )
1082         external
1083         producersOnly
1084     {
1085         require(_productIndex > 0);
1086         bytes32 harvestMappingID = keccak256(_harvestTrackID, msg.sender);
1087         address winery = getAddress(_offChainWineryIdentity);
1088         bytes32 wineryOperationMappingID = keccak256(_wineryTrackID, winery);
1089         harvests[harvestMappingID].child = IndexElem(wineryOperationMappingID, _productIndex);
1090     }
1091 
1092     /// @notice ***
1093     /// @dev ****
1094     /// @param _trackIDs **
1095     /// @param _address **
1096     /// @return mappingID if ***
1097     function getMappingID(string _trackIDs, address _address)
1098         external pure
1099         returns (bytes32 mappingID)
1100     {
1101         mappingID = keccak256(_trackIDs, _address);
1102     }
1103 
1104 }