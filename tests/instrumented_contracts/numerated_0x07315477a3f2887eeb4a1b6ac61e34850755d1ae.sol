1 // Copyright (c) 2016 Chronicled, Inc. All rights reserved.
2 // http://explorer.chronicled.org
3 // http://demo.chronicled.org
4 // http://chronicled.org
5 
6 contract Registrar {
7     address public registrar;
8 
9     /**
10 
11     * Created event, gets triggered when a new registrant gets created
12     * event
13     * @param registrant - The registrant address.
14     * @param registrar - The registrar address.
15     * @param data - The data of the registrant.
16     */
17     event Created(address indexed registrant, address registrar, bytes data);
18 
19     /**
20     * Updated event, gets triggered when a new registrant id Updated
21     * event
22     * @param registrant - The registrant address.
23     * @param registrar - The registrar address.
24     * @param data - The data of the registrant.
25     */
26     event Updated(address indexed registrant, address registrar, bytes data, bool active);
27 
28     /**
29     * Error event.
30     * event
31     * @param code - The error code.
32     * 1: Permission denied.
33     * 2: Duplicate Registrant address.
34     * 3: No such Registrant.
35     */
36     event Error(uint code);
37 
38     struct Registrant {
39         address addr;
40         bytes data;
41         bool active;
42     }
43 
44     mapping(address => uint) public registrantIndex;
45     Registrant[] public registrants;
46 
47     /**
48     * Function can't have ether.
49     * modifier
50     */
51     modifier noEther() {
52         if (msg.value > 0) throw;
53         _
54     }
55 
56     modifier isRegistrar() {
57       if (msg.sender != registrar) {
58         Error(1);
59         return;
60       }
61       else {
62         _
63       }
64     }
65 
66     /**
67     * Construct registry with and starting registrants lenght of one, and registrar as msg.sender
68     * constructor
69     */
70     function Registrar() {
71         registrar = msg.sender;
72         registrants.length++;
73     }
74 
75     /**
76     * Add a registrant, only registrar allowed
77     * public_function
78     * @param _registrant - The registrant address.
79     * @param _data - The registrant data string.
80     */
81     function add(address _registrant, bytes _data) isRegistrar noEther returns (bool) {
82         if (registrantIndex[_registrant] > 0) {
83             Error(2); // Duplicate registrant
84             return false;
85         }
86         uint pos = registrants.length++;
87         registrants[pos] = Registrant(_registrant, _data, true);
88         registrantIndex[_registrant] = pos;
89         Created(_registrant, msg.sender, _data);
90         return true;
91     }
92 
93     /**
94     * Edit a registrant, only registrar allowed
95     * public_function
96     * @param _registrant - The registrant address.
97     * @param _data - The registrant data string.
98     */
99     function edit(address _registrant, bytes _data, bool _active) isRegistrar noEther returns (bool) {
100         if (registrantIndex[_registrant] == 0) {
101             Error(3); // No such registrant
102             return false;
103         }
104         Registrant registrant = registrants[registrantIndex[_registrant]];
105         registrant.data = _data;
106         registrant.active = _active;
107         Updated(_registrant, msg.sender, _data, _active);
108         return true;
109     }
110 
111     /**
112     * Set new registrar address, only registrar allowed
113     * public_function
114     * @param _registrar - The new registrar address.
115     */
116     function setNextRegistrar(address _registrar) isRegistrar noEther returns (bool) {
117         registrar = _registrar;
118         return true;
119     }
120 
121     /**
122     * Get if a regsitrant is active or not.
123     * constant_function
124     * @param _registrant - The registrant address.
125     */
126     function isActiveRegistrant(address _registrant) constant returns (bool) {
127         uint pos = registrantIndex[_registrant];
128         return (pos > 0 && registrants[pos].active);
129     }
130 
131     /**
132     * Get all the registrants.
133     * constant_function
134     */
135     function getRegistrants() constant returns (address[]) {
136         address[] memory result = new address[](registrants.length-1);
137         for (uint j = 1; j < registrants.length; j++) {
138             result[j-1] = registrants[j].addr;
139         }
140         return result;
141     }
142 
143     /**
144     * Function to reject value sends to the contract.
145     * fallback_function
146     */
147     function () noEther {}
148 
149     /**
150     * Desctruct the smart contract. Since this is first, alpha release of Open Registry for IoT, updated versions will follow.
151     * Registry's discontinue must be executed first.
152     */
153     function discontinue() isRegistrar noEther {
154       selfdestruct(msg.sender);
155     }
156 }
157 
158 
159 contract Registry {
160     // Address of the Registrar contract which holds all the Registrants
161     address public registrarAddress;
162     // Address of the account which deployed the contract. Used only to configure contract.
163     address public deployerAddress;
164 
165     /**
166     * Creation event that gets triggered when a thing is created.
167     * event
168     * @param ids - The identity of the thing.
169     * @param owner - The owner address.
170     */
171     event Created(bytes32[] ids, address indexed owner);
172 
173     /**
174     * Update event that gets triggered when a thing is updated.
175     * event
176     * @param ids - The identity of the thing.
177     * @param owner - The owner address.
178     * @param isValid - The validity of the thing.
179     */
180     event Updated(bytes32[] ids, address indexed owner, bool isValid);
181 
182     /**
183     * Delete event, triggered when Thing is deleted.
184     * event
185     * @param ids - The identity of the thing.
186     * @param owner - The owner address.
187     */
188     event Deleted(bytes32[] ids, address indexed owner);
189 
190     /**
191     * Generic error event.
192     * event
193     * @param code - The error code.
194     * @param reference - Related references data for the Error event, e.g.: Identity, Address, etc.
195     * 1: Identity collision, already assigned to another Thing.
196     * 2: Not found, identity does not exist.
197     * 3: Unauthorized, modification only by owner.
198     * 4: Unknown schema specified.
199     * 5: Incorrect input, at least one identity is required.
200     * 6: Incorrect input, data is required.
201     * 7: Incorrect format of the identity, schema length and identity length cannot be empty.
202     * 8: Incorrect format of the identity, identity must be padded with trailing 0s.
203     * 9: Contract already configured
204     */
205     event Error(uint code, bytes32[] reference);
206 
207     struct Thing {
208       // All identities of a Thing. e.g.: BLE ID, public key, etc.
209       bytes32[] identities;
210       // Metadata of the Thing. Hex of ProtoBuffer structure.
211       bytes32[] data;
212       // Registrant address, who have added the thing.
213       address ownerAddress;
214       // Index of ProtoBuffer schema used. Optimized to fit in one bytes32.
215       uint88 schemaIndex;
216       // Status of the Thing. false if compromised, revoked, etc.
217       bool isValid;
218     }
219 
220     // Things are stored in the array
221     Thing[] public things;
222 
223     // Identity to Thing index pointer for lookups and duplicates prevention.
224     mapping(bytes32 => uint) public idToThing;
225 
226     // Content of ProtoBuffer schema.
227     bytes[] public schemas;
228 
229     /**
230     * Function can't contain Ether value.
231     * modifier
232     */
233     modifier noEther() {
234         if (msg.value > 0) throw;
235         _
236     }
237 
238     /**
239     * Allow only registrants to exec the function.
240     * modifier
241     */
242     modifier isRegistrant() {
243         Registrar registrar = Registrar(registrarAddress);
244         if (registrar.isActiveRegistrant(msg.sender)) {
245             _
246         }
247     }
248 
249     /**
250     * Allow only registrar to exec the function.
251     * modifier
252     */
253     modifier isRegistrar() {
254         Registrar registrar = Registrar(registrarAddress);
255         if (registrar.registrar() == msg.sender) {
256             _
257         }
258     }
259 
260     /**
261     * Initialization of the contract
262     * constructor
263     */
264     function Registry() {
265         // Initialize arrays. Leave first element empty, since mapping points non-existent keys to 0.
266         things.length++;
267         schemas.length++;
268         deployerAddress = msg.sender;
269     }
270 
271     /**
272     * Add Identities to already existing Thing.
273     * internal_function
274     * @param _thingIndex - The position of the Thing in the array.
275     * @param _ids - Identities of the Thing in chunked format. Maximum size of one Identity is 2057 bytes32 elements.
276     */
277     function _addIdentities(uint _thingIndex, bytes32[] _ids) internal returns(bool){
278         // Checks if there's duplicates and creates references
279         if (false == _rewireIdentities(_ids, 0, _thingIndex, 0)) {
280             return false;
281         }
282 
283         // Thing don't have Identities yet.
284         if (things[_thingIndex].identities.length == 0) {
285             // Copy directly. Cheaper than one by one.
286             things[_thingIndex].identities = _ids;
287         }
288         else {
289             // _ids array current element pointer.
290             // uint32 technically allows to put 128Gb of Identities into one Thing.
291             uint32 cell = uint32(things[_thingIndex].identities.length);
292             // Copy new IDs to the end of array one by one
293             things[_thingIndex].identities.length += _ids.length;
294             // If someone will provide _ids array with more than 2^32, it will go into infinite loop at a caller's expense.
295             for (uint32 k = 0; k < _ids.length; k++) {
296                 things[_thingIndex].identities[cell++] = _ids[k];
297             }
298         }
299         return true;
300     }
301 
302     /**
303     * Point provided Identities to the desired "things" array index in the lookup hash table idToThing.
304     * internal_function
305     * @param _ids - Identities of the Thing.
306     * @param _oldIndex - Previous index that this Identities pointed to, prevents accidental rewiring and duplicate Identities.
307     * @param _newIndex - things array index the Identities should point to.
308     * @param _newIndex - things array index the Identities should point to.
309     * @param _idsForcedLength — Internal use only. Zero by default. Used to revert side effects if execution fails at any point.
310     *       Prevents infinity loop in recursion. Though recursion is not desirable, it's used to avoid over-complication of the code.
311     */
312     function _rewireIdentities(bytes32[] _ids, uint _oldIndex, uint _newIndex, uint32 _idsForcedLength) internal returns(bool) {
313         // Current ID cell pointer
314         uint32 cell = 0;
315         // Length of namespace part of the Identity in URN format
316         uint16 urnNamespaceLength;
317         // Length of ID part of the Identity, though only uint16 needed but extended to uint24 for correct calculations.
318         uint24 idLength;
319         // Array cells used for current ID. uint24 to match idLength type, so no conversions needed.
320         uint24 cellsPerId;
321         // Hash of current ID
322         bytes32 idHash;
323         // How many bytes of payload are there in the last cell of single ID.
324         uint8 lastCellBytesCnt;
325         // Number of elements that needs to be processed in _ids array
326         uint32 idsLength = _idsForcedLength > 0 ? _idsForcedLength : uint32(_ids.length);
327 
328         // No Identities provided
329         if (idsLength == 0) {
330             Error(5, _ids);
331             return false;
332         }
333 
334         // Each ID
335         while (cell < idsLength) {
336             // Get length of schema. First byte of packed ID.
337             // Means that next urnNamespaceLength bytes is the schema definition.
338             urnNamespaceLength = uint8(_ids[cell][0]);
339             // Length of ID part of this URN Identity.
340             idLength =
341                 // First byte
342                 uint16(_ids[cell + (urnNamespaceLength + 1) / 32][(urnNamespaceLength + 1) % 32]) * 2 ** 8 |
343                 // Second byte
344                 uint8(_ids[cell + (urnNamespaceLength + 2) / 32][(urnNamespaceLength + 2) % 32]);
345 
346             // We deal with the new Identity (instead rewiring after deletion)
347             if (_oldIndex == 0 && (urnNamespaceLength == 0 || idLength == 0)) {
348                 // Incorrect Identity structure.
349                 Error(7, _ids);
350 
351                 // If at least one Identity already wired. And if this is not a recursive call.
352                 if (cell > 0 && _idsForcedLength == 0) {
353                     _rewireIdentities(_ids, _newIndex, _oldIndex, cell); // Revert changes made so far
354                 }
355                 return false;
356             }
357 
358             // Total bytes32 cells devoted for this ID. Maximum 2057 is possible.
359             cellsPerId = (idLength + urnNamespaceLength + 3) / 32;
360             if ((idLength + urnNamespaceLength + 3) % 32 != 0) {
361                 // Identity uses one more cell partially
362                 cellsPerId++;
363                 // For new identity, ensure that complies with the format, specifically padding is done with 0s.
364                 // This prevents from adding duplicated identities, which might be accepted because generate a different hash.
365                 if (_oldIndex == 0) {
366                     // How many bytes the ID occupies in the last cell.
367                     lastCellBytesCnt = uint8((idLength + urnNamespaceLength + 3) % 32);
368 
369                     // Check if padded with zeros. Explicitly converting 2 into uint256 for correct calculations.
370                     if (uint256(_ids[cell + cellsPerId - 1]) * (uint256(2) ** (lastCellBytesCnt * 8)) > 0) {  // Bitwise left shift, result have to be 0
371                         // Identity is not padded with 0s
372                         Error(8, _ids);
373                         // If at least one Identity already wired. And if this is not a recursive call.
374                         if (cell > 0 && _idsForcedLength == 0) {
375                             _rewireIdentities(_ids, _newIndex, _oldIndex, cell); // Revert changes made so far
376                         }
377                         return false;
378                     }
379                 }
380             }
381 
382             // Single Identity array
383             bytes32[] memory id = new bytes32[](cellsPerId);
384 
385             for (uint8 j = 0; j < cellsPerId; j++) {
386                 id[j] = _ids[cell++];
387             }
388 
389             // Uniqueness check and reference for lookups
390             idHash = sha3(id);
391 
392             // If it points to where it's expected.
393             if (idToThing[idHash] == _oldIndex) {
394                 // Wire Identity
395                 idToThing[idHash] = _newIndex;
396             } else {
397                 // References to a wrong Thing, e.g. Identity already exists, etc.
398                 Error(1, _ids);
399                 // If at least one Identity already wired. And if this is not a recursive call.
400                 if (cell - cellsPerId > 0 && _idsForcedLength == 0) {
401                     _rewireIdentities(_ids, _newIndex, _oldIndex, cell - cellsPerId); // Revert changes made so far
402                 }
403                 return false;
404             }
405         }
406 
407         return true;
408     }
409 
410 
411     //
412     // Public Functions
413     //
414 
415 
416     /**
417     * Set the registrar address for the contract, (This function can be called only once).
418     * public_function
419     * @param _registrarAddress - The Registrar contract address.
420     */
421     function configure(address _registrarAddress) noEther returns(bool) {
422         // Convert into array to properly generate Error event
423         bytes32[] memory ref = new bytes32[](1);
424         ref[0] = bytes32(registrarAddress);
425 
426         if (msg.sender != deployerAddress) {
427             Error(3, ref);
428             return false;
429         }
430 
431         if (registrarAddress != 0x0) {
432             Error(9, ref);
433             return false;
434         }
435 
436         registrarAddress = _registrarAddress;
437         return true;
438     }
439 
440     /**
441     * Create a new Thing in the Registry, only for registrants.
442     * public_function
443     * @param _ids - The chunked identities array.
444     * @param _data - Thing chunked data array.
445     * @param _schemaIndex - Index of the schema to parse Thing's data.
446     */
447     function createThing(bytes32[] _ids, bytes32[] _data, uint88 _schemaIndex) isRegistrant returns(bool) {
448         // No data provided
449         if (_data.length == 0) {
450             Error(6, _ids);
451             return false;
452         }
453 
454         if (_schemaIndex >= schemas.length || _schemaIndex == 0) {
455             Error(4, _ids);
456             return false;
457         }
458 
459         // Wiring identities to non-existent Thing.
460         // This optimization reduces transaction cost by 100k of gas on avg (or by 3x), in case if _rewireIdentities will fail.
461         // Which leads to less damage to the caller, who provided incorrect data.
462         if (false == _rewireIdentities(_ids, 0, things.length, 0)) {
463             // Incorrect IDs format or duplicate Identities provided.
464             return false;
465         }
466 
467         // Now after all verifications passed we can add a the Thing.
468         things.length++;
469         // Creating structure in-place is 11k gas cheaper than assigning parameters separately.
470         // That's why methods like updateThingData, addIdentities are not reused here.
471         things[things.length - 1] = Thing(_ids, _data, msg.sender, _schemaIndex, true);
472 
473         // "Broadcast" event
474         Created(_ids, msg.sender);
475         return true;
476     }
477 
478     /**
479     * Create multiple Things at once.
480     * Review: user should be aware that if there will be not enough identities transaction will run out of gas.
481     * Review: user should be aware that providing too many identities will result in some of them not being used.
482     * public_function
483     * @param _ids - The Thing's IDs to be added in bytes32 chunks
484     * @param _idsPerThing — number of IDs per thing, in relevant order
485     * @param _data - The data chunks
486     * @param _dataLength - The data length of every Thing to add, in relevant order
487     * @param _schemaIndex -Index of the schema to parse Thing's data
488     */
489     function createThings(bytes32[] _ids, uint16[] _idsPerThing, bytes32[] _data, uint16[] _dataLength, uint88 _schemaIndex) isRegistrant noEther  {
490         // Current _id array index
491         uint16 idIndex = 0;
492         // Current _data array index
493         uint16 dataIndex = 0;
494         // Counter of total id cells per one thing
495         uint24 idCellsPerThing = 0;
496         // Length of namespace part of the Identity in URN format
497         uint16 urnNamespaceLength;
498         // Length of ID part of the Identity, though only uint16 needed but extended to uint24 for correct calculations.
499         uint24 idLength;
500 
501         // Each Thing
502         for (uint16 i = 0; i < _idsPerThing.length; i++) {
503             // Reset for each thing
504             idCellsPerThing = 0;
505             // Calculate number of cells for current Thing
506             for (uint16 j = 0; j < _idsPerThing[i]; j++) {
507                 urnNamespaceLength = uint8(_ids[idIndex + idCellsPerThing][0]);
508                 idLength =
509                     // First byte
510                     uint16(_ids[idIndex + idCellsPerThing + (urnNamespaceLength + 1) / 32][(urnNamespaceLength + 1) % 32]) * 2 ** 8 |
511                     // Second byte
512                     uint8(_ids[idIndex + idCellsPerThing + (urnNamespaceLength + 2) / 32][(urnNamespaceLength + 2) % 32]);
513 
514                 idCellsPerThing += (idLength + urnNamespaceLength + 3) / 32;
515                 if ((idLength + urnNamespaceLength + 3) % 32 != 0) {
516                     idCellsPerThing++;
517                 }
518             }
519 
520             // Extract ids for a single Thing
521             bytes32[] memory ids = new bytes32[](idCellsPerThing);
522             // Reusing var name to maintain stack size in limits
523             for (j = 0; j < idCellsPerThing; j++) {
524                 ids[j] = _ids[idIndex++];
525             }
526 
527             bytes32[] memory data = new bytes32[](_dataLength[i]);
528             for (j = 0; j < _dataLength[i]; j++) {
529                 data[j] = _data[dataIndex++];
530             }
531 
532             createThing(ids, data, _schemaIndex);
533         }
534     }
535 
536     /**
537     * Add new IDs to the Thing, only registrants allowed.
538     * public_function
539     * @param _id - ID of the existing Thing
540     * @param _newIds - IDs to be added.
541     */
542     function addIdentities(bytes32[] _id, bytes32[] _newIds) isRegistrant noEther returns(bool) {
543         var index = idToThing[sha3(_id)];
544 
545         // There no Thing with such ID
546         if (index == 0) {
547             Error(2, _id);
548             return false;
549         }
550 
551         if (_newIds.length == 0) {
552             Error(5, _id);
553             return false;
554         }
555 
556         if (things[index].ownerAddress != 0x0 && things[index].ownerAddress != msg.sender) {
557             Error(3, _id);
558             return false;
559         }
560 
561         if (_addIdentities(index, _newIds)) {
562             Updated(_id, things[index].ownerAddress, things[index].isValid);
563             return true;
564         }
565         return false;
566     }
567 
568     /**
569     * Update Thing's data.
570     * public_function
571     * @param _id - The identity array.
572     * @param _data - Thing data array.
573     * @param _schemaIndex - The schema index of the schema to parse the thing.
574     */
575     function updateThingData(bytes32[] _id, bytes32[] _data, uint88 _schemaIndex) isRegistrant noEther returns(bool) {
576         uint index = idToThing[sha3(_id)];
577 
578         if (index == 0) {
579             Error(2, _id);
580             return false;
581         }
582 
583         if (things[index].ownerAddress != 0x0 && things[index].ownerAddress != msg.sender) {
584             Error(3, _id);
585             return false;
586         }
587 
588         if (_schemaIndex > schemas.length || _schemaIndex == 0) {
589             Error(4, _id);
590             return false;
591         }
592 
593         if (_data.length == 0) {
594             Error(6, _id);
595             return false;
596         }
597 
598         things[index].schemaIndex = _schemaIndex;
599         things[index].data = _data;
600         Updated(_id, things[index].ownerAddress, things[index].isValid);
601         return true;
602     }
603 
604     /**
605     * Set validity of a thing, only registrants allowed.
606     * public_function
607     * @param _id - The identity to change.
608     * @param _isValid - The new validity of the thing.
609     */
610     function setThingValid(bytes32[] _id, bool _isValid) isRegistrant noEther returns(bool) {
611         uint index = idToThing[sha3(_id)];
612 
613         if (index == 0) {
614             Error(2, _id);
615             return false;
616         }
617 
618         if (things[index].ownerAddress != msg.sender) {
619             Error(3, _id);
620             return false;
621         }
622 
623         things[index].isValid = _isValid;
624         // Broadcast event
625         Updated(_id, things[index].ownerAddress, things[index].isValid);
626         return true;
627     }
628 
629     /**
630     * Delete previously added Thing
631     * public_function
632     * @param _id - One of Thing's Identities.
633     */
634     function deleteThing(bytes32[] _id) isRegistrant noEther returns(bool) {
635         uint index = idToThing[sha3(_id)];
636 
637         if (index == 0) {
638             Error(2, _id);
639             return false;
640         }
641 
642         if (things[index].ownerAddress != msg.sender) {
643             Error(3, _id);
644             return false;
645         }
646 
647         // Rewire Thing's identities to index 0, e.g. delete.
648         if (false == _rewireIdentities(things[index].identities, index, 0, 0)) {
649             // Cannot rewire, should never happen
650             return false;
651         }
652 
653         // Put last element in place of deleted one
654         if (index != things.length - 1) {
655             // Rewire identities of the last Thing to the new prospective index.
656             if (false == _rewireIdentities(things[things.length - 1].identities, things.length - 1, index, 0)) {
657                 // Cannot rewire, should never happen
658                 _rewireIdentities(things[index].identities, 0, index, 0); // Rollback
659                 return false;
660             }
661 
662             // "Broadcast" event with identities before they're lost.
663             Deleted(things[index].identities, things[index].ownerAddress);
664 
665             // Move last Thing to the place of deleted one.
666             things[index] = things[things.length - 1];
667         }
668 
669         // Delete last Thing
670         things.length--;
671 
672         return true;
673     }
674 
675     /**
676     * Get length of the schemas array
677     * constant_function
678     */
679     function getSchemasLenght() constant returns(uint) {
680         return schemas.length;
681     }
682 
683     /**
684     * Get Thing's information
685     * constant_function
686     * @param _id - identity of the thing.
687     */
688     function getThing(bytes32[] _id) constant returns(bytes32[], bytes32[], uint88, bytes, address, bool) {
689         var index = idToThing[sha3(_id)];
690         // No such Thing
691         if (index == 0) {
692             Error(2, _id);
693             return;
694         }
695         Thing thing = things[index];
696         return (thing.identities, thing.data, thing.schemaIndex, schemas[thing.schemaIndex], thing.ownerAddress, thing.isValid);
697     }
698 
699     /**
700     * Check if Thing is present in the registry by it's ID
701     * constant_function
702     * @param _id - identity for lookup.
703     */
704 
705     // Todo: reevaluate this method. Do we need it?
706     function thingExist(bytes32[] _id) constant returns(bool) {
707         return idToThing[sha3(_id)] > 0;
708     }
709 
710     /**
711     * Create a new schema. Provided as hex of ProtoBuf-encoded schema data.
712     * public_function
713     * @param _schema - New schema string to add.
714     */
715     function createSchema(bytes _schema) isRegistrar noEther returns(uint) {
716         uint pos = schemas.length++;
717         schemas[pos] = _schema;
718         return pos;
719     }
720 
721     /**
722     * Fallback
723     */
724     function () noEther {}
725 
726 
727     /**
728     * Desctruct the smart contract. Since this is first, alpha release of Open Registry for IoT, updated versions will follow.
729     * Execute this prior to Registrar's contract discontinue()
730     */
731     function discontinue() isRegistrar noEther returns(bool) {
732       selfdestruct(msg.sender);
733       return true;
734     }
735 }