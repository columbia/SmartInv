1 pragma solidity ^0.4.13;
2 
3 library CertsLib {
4   struct SignatureData {
5     /* 
6      * status == 0x0 => UNKNOWN
7      * status == 0x1 => PENDING
8      * status == 0x2 => SIGNED
9      * Otherwise     => Purpose (sha-256 of data)
10      */
11     bytes32 status;
12     uint exp; // Expiration Date
13   }
14 
15   struct TransferData {
16     address newOwner;
17     uint newEntityId;
18   }
19 
20   struct CertData {
21     /*
22      * owner == 0 => POE_CERTIFICATE
23      * owner != 0 => PROPIETARY_CERTIFICATE
24      */
25     address owner; // owner of the certificate (in case of being a peer)
26     uint entityId; // owner of the certificate (in case of being an entity)
27     bytes32 certHash; // sha256 checksum of the certificate JSON data
28     string ipfsCertHash; // ipfs multihash address of certificate in json format
29     bytes32 dataHash; // sha256 hash of certified data
30     string ipfsDataHash; // ipfs multihash address of certified data
31     mapping(uint => SignatureData) entities; // signatures from signing entities and their expiration date
32     uint[] entitiesArr;
33     mapping(address => SignatureData) signatures; // signatures from peers and their expiration date
34     address[] signaturesArr;
35   }
36 
37   struct Data {
38     mapping(uint => CertData) certificates;
39     mapping(uint => TransferData) transferRequests;
40     uint nCerts;
41   }
42 
43   // METHODS
44 
45   /**
46    * Creates a new POE certificate
47    * @param self {object} - The data containing the certificate mappings
48    * @param dataHash {bytes32} - The hash of the certified data
49    * @param certHash {bytes32} - The sha256 hash of the json certificate
50    * @param ipfsDataHash {string} - The ipfs multihash address of the data (0x00 means unkwon)
51    * @param ipfsCertHash {string} - The ipfs multihash address of the certificate in json format (0x00 means unkwon)
52    * @return The id of the created certificate     
53    */
54   function createPOECertificate(Data storage self, bytes32 dataHash, bytes32 certHash, string ipfsDataHash, string ipfsCertHash) public returns (uint) {
55     require (hasData(dataHash, certHash, ipfsDataHash, ipfsCertHash));
56 
57     uint certId = ++self.nCerts;
58     self.certificates[certId] = CertData({
59       owner: 0,
60       entityId: 0,
61       certHash: certHash,
62       ipfsCertHash: ipfsCertHash,
63       dataHash: dataHash,
64       ipfsDataHash: ipfsDataHash,
65       entitiesArr: new uint[](0),
66       signaturesArr: new address[](0)
67     });
68 
69     POECertificate(certId);
70     return certId;
71   }
72 
73   /**
74    * Creates a new certificate (with known owner). The owner will be the sender unless the entityId (issuer) is supplied.
75    * @param self {object} - The data containing the certificate mappings
76    * @param ed {object} - The data containing the entity mappings
77    * @param dataHash {bytes32} - The hash of the certified data
78    * @param certHash {bytes32} - The sha256 hash of the json certificate
79    * @param ipfsDataHash {string} - The ipfs multihash address of the data (0x00 means unkwon)
80    * @param ipfsCertHash {string} - The ipfs multihash address of the certificate in json format (0x00 means unkwon)
81    * @param entityId {uint} - The entity id which issues the certificate (0 if not issued by an entity)
82    * @return {uint} The id of the created certificate     
83    */
84   function createCertificate(Data storage self, EntityLib.Data storage ed, bytes32 dataHash, bytes32 certHash, string ipfsDataHash, string ipfsCertHash, uint entityId) senderCanIssueEntityCerts(ed, entityId) public returns (uint) {
85     require (hasData(dataHash, certHash, ipfsDataHash, ipfsCertHash));
86 
87     uint certId = ++self.nCerts;
88     self.certificates[certId] = CertData({
89       owner: entityId == 0 ? msg.sender : 0,
90       entityId: entityId,
91       certHash: certHash,
92       ipfsCertHash: ipfsCertHash,
93       dataHash: dataHash,
94       ipfsDataHash: ipfsDataHash,
95       entitiesArr: new uint[](0),
96       signaturesArr: new address[](0)
97     });
98 
99     Certificate(certId);
100     return certId;
101   }
102 
103   /**
104    * Transfers a certificate owner. The owner can be a peer or an entity (never both), so only one of newOwner or newEntity must be different than 0.
105    * If the specified certificateId belongs to an entity, the msg.sender must be a valid signer for the entity. Otherwise the msg.sender must be the current owner.
106    * @param self {object} - The data containing the certificate mappings
107    * @param ed {object} - The data containing the entity mappings
108    * @param certificateId {uint} - The id of the certificate to transfer
109    * @param newOwner {address} - The address of the new owner
110    */
111   function requestCertificateTransferToPeer(Data storage self, EntityLib.Data storage ed, uint certificateId, address newOwner) canTransferCertificate(self, ed, certificateId) public {
112     self.transferRequests[certificateId] = TransferData({
113       newOwner: newOwner,
114       newEntityId: 0
115     });
116 
117     CertificateTransferRequestedToPeer(certificateId, newOwner);
118   }
119 
120   /**
121    * Transfers a certificate owner. The owner can be a peer or an entity (never both), so only one of newOwner or newEntity must be different than 0.
122    * If the specified certificateId belongs to an entity, the msg.sender must be a valid signer for the entity. Otherwise the msg.sender must be the current owner.
123    * @param self {object} - The data containing the certificate mappings
124    * @param ed {object} - The data containing the entity mappings
125    * @param certificateId {uint} - The id of the certificate to transfer
126    * @param newEntityId {uint} - The id of the new entity
127    */
128   function requestCertificateTransferToEntity(Data storage self, EntityLib.Data storage ed, uint certificateId, uint newEntityId) entityExists(ed, newEntityId) canTransferCertificate(self, ed, certificateId) public {
129     self.transferRequests[certificateId] = TransferData({
130       newOwner: 0,
131       newEntityId: newEntityId
132     });
133 
134     CertificateTransferRequestedToEntity(certificateId, newEntityId);
135   }
136 
137   /**
138    * Accept the certificate transfer
139    * @param self {object} - The data containing the certificate mappings
140    * @param ed {object} - The data containing the entity mappings
141    * @param certificateId {uint} - The id of the certificate to transfer
142    */
143   function acceptCertificateTransfer(Data storage self, EntityLib.Data storage ed, uint certificateId) canAcceptTransfer(self, ed, certificateId) public {
144     TransferData storage reqData = self.transferRequests[certificateId];
145     self.certificates[certificateId].owner = reqData.newOwner;
146     self.certificates[certificateId].entityId = reqData.newEntityId;    
147     CertificateTransferAccepted(certificateId, reqData.newOwner, reqData.newEntityId);
148     delete self.transferRequests[certificateId];
149   }
150 
151   /**
152    * Cancel any certificate transfer request
153    * @param self {object} - The data containing the certificate mappings
154    * @param ed {object} - The data containing the entity mappings
155    * @param certificateId {uint} - The id of the certificate to transfer
156    */
157   function cancelCertificateTransfer(Data storage self, EntityLib.Data storage ed, uint certificateId) canTransferCertificate(self, ed, certificateId) public {
158     self.transferRequests[certificateId] = TransferData({
159       newOwner: 0,
160       newEntityId: 0
161     });
162 
163     CertificateTransferCancelled(certificateId);
164   }
165 
166   /**
167    * Updates ipfs multihashes of a particular certificate
168    * @param self {object} - The data containing the certificate mappings
169    * @param certId {uint} - The id of the certificate
170    * @param ipfsDataHash {string} - The ipfs multihash address of the data (0x00 means unkwon)
171    * @param ipfsCertHash {string} - The ipfs multihash address of the certificate in json format (0x00 means unkwon)
172    */
173   function setIPFSData(Data storage self, uint certId, string ipfsDataHash, string ipfsCertHash) ownsCertificate(self, certId) public {
174       self.certificates[certId].ipfsDataHash = ipfsDataHash;
175       self.certificates[certId].ipfsCertHash = ipfsCertHash;
176       UpdatedIPFSData(certId);
177   }
178 
179   // HELPERS
180 
181   /**
182    * Returns true if the certificate has valid data
183    * @param dataHash {bytes32} - The hash of the certified data
184    * @param certHash {bytes32} - The sha256 hash of the json certificate
185    * @param ipfsDataHash {string} - The ipfs multihash address of the data (0x00 means unkwon)
186    * @param ipfsCertHash {string} - The ipfs multihash address of the certificate in json format (0x00 means unkwon)   * @return {bool} - True if the certificate contains valid data
187    */
188   function hasData(bytes32 dataHash, bytes32 certHash, string ipfsDataHash, string ipfsCertHash) pure public returns (bool) {
189     return certHash != 0
190     || dataHash != 0
191     || bytes(ipfsDataHash).length != 0
192     || bytes(ipfsCertHash).length != 0;
193   }
194 
195   // MODIFIERS
196   
197  /**
198    * Returns True if msg.sender is the owner of the specified certificate. False otherwise.
199    * @param self {object} - The data containing the certificate mappings
200    * @param id {uint} - The id of the certificate 
201    */
202   modifier ownsCertificate(Data storage self, uint id) {
203     require (self.certificates[id].owner == msg.sender);
204     _;
205   }
206 
207 
208   /**
209    * Returns TRUE if the specified entity is valid and the sender is a valid signer from the entity.
210    * If the entityId is 0 (not provided), it also returns TRUE
211    * @param ed {object} - The data containing the entity mappings
212    * @param entityId {uint} - The entityId which will issue the certificate
213    */
214   modifier senderCanIssueEntityCerts(EntityLib.Data storage ed, uint entityId) {
215     require (entityId == 0 
216      || (EntityLib.isValid(ed, entityId) && ed.entities[entityId].signers[msg.sender].status == 2));
217     _;    
218   }
219 
220   /**
221    * Returns TRUE if the certificate has data and can be transfered to the new owner:
222    * - When the certificate is owned by a peer: the sender must be the owner of the certificate
223    * - When the certificate belongs to an entity: the entity must be valid 
224    *   AND the signer must be a valid signer of the entity
225    * @param self {object} - The data containing the certificate mappings
226    * @param ed {object} - The data containing the entity mappings
227    * @param certificateId {uint} - The certificateId which transfer is required
228    */
229   modifier canTransferCertificate(Data storage self, EntityLib.Data storage ed, uint certificateId) {
230     CertData storage cert = self.certificates[certificateId];
231     require (hasData(cert.dataHash, cert.certHash, cert.ipfsDataHash, cert.ipfsCertHash));
232 
233     if (cert.owner != 0) {
234       require (cert.owner == msg.sender);
235       _;
236     } else if (cert.entityId != 0) {
237       EntityLib.EntityData storage entity = ed.entities[cert.entityId];
238       require (EntityLib.isValid(ed, cert.entityId) && entity.signers[msg.sender].status == 2);
239       _;
240     }
241   }
242 
243   /**
244    * Returns TRUE if the entity exists
245    */
246   modifier entityExists(EntityLib.Data storage ed, uint entityId) {
247     require (EntityLib.exists(ed, entityId));
248     _;
249   }
250 
251   /**
252    * Returns TRUE if the msg.sender can accept the certificate transfer
253    * @param self {object} - The data containing the certificate mappings
254    * @param ed {object} - The data containing the entity mappings
255    * @param certificateId {uint} - The certificateId which transfer is required
256    */
257   modifier canAcceptTransfer(Data storage self, EntityLib.Data storage ed, uint certificateId) {
258     CertData storage cert = self.certificates[certificateId];
259     require (hasData(cert.dataHash, cert.certHash, cert.ipfsDataHash, cert.ipfsCertHash));
260 
261     TransferData storage reqData = self.transferRequests[certificateId];
262     require(reqData.newEntityId != 0 || reqData.newOwner != 0);
263 
264     if (reqData.newOwner == msg.sender) {
265       _;
266     } else if (reqData.newEntityId != 0) {      
267       EntityLib.EntityData storage newEntity = ed.entities[reqData.newEntityId];
268       require (EntityLib.isValid(ed, reqData.newEntityId) && newEntity.signers[msg.sender].status == 2);
269        _;
270     }
271   }
272 
273   // EVENTS
274 
275   event POECertificate(uint indexed certificateId);
276   event Certificate(uint indexed certificateId);
277   event CertificateTransferRequestedToPeer(uint indexed certificateId, address newOwner);
278   event CertificateTransferRequestedToEntity(uint indexed certificateId, uint newEntityId);
279   event CertificateTransferAccepted(uint indexed certificateId, address newOwner, uint newEntityId);
280   event CertificateTransferCancelled(uint indexed certificateId);
281   event UpdatedIPFSData(uint indexed certificateId);
282 }
283 
284 library EntityLib {
285   struct SignerData {
286     string signerDataHash;
287     /*
288      * status == 0 => NOT_VALID
289      * status == 1 => VALIDATION_PENDING
290      * status == 2 => VALID
291      * status == 3 => DATA_UPDATED
292      */
293     uint status;
294   }
295 
296   struct EntityData {
297     address owner;
298     string dataHash; // hash entity data
299     /*
300       * status == 0 => NOT_VALID
301       * status == 1 => VALIDATION_PENDING
302       * status == 2 => VALID
303       * status == 4 => RENEWAL_REQUESTED
304       * status == 8 => CLOSED
305       * otherwise => UNKNOWN
306       */
307     uint status;
308     bytes32 urlHash;         // hash url only
309     uint expiration;         // Expiration date
310     uint renewalPeriod;      // Renewal period to be used for 3rd party renewals (3rd party paying the validation expenses)
311     bytes32 oraclizeQueryId; // Last query Id from oraclize. We will only process the last request
312 
313     /*
314       * signers[a] == 0;
315       * signers[a] = ipfs multihash address for signer data file in json format
316       */
317     mapping(address => SignerData) signers;
318     address[] signersArr;
319   }
320 
321   struct Data {
322     mapping(uint => EntityData) entities;
323     mapping(bytes32 => uint) entityIds;
324     uint nEntities;
325   }
326 
327   // METHODS
328 
329   /**
330    * Creates a new entity
331    * @param self {object} - The data containing the entity mappings
332    * @param entitDatayHash {string} - The ipfs multihash address of the entity information in json format
333    * @param urlHash {bytes32} - The sha256 hash of the URL of the entity
334    * @param expirationDate {uint} - The expiration date of the current entity
335    * @param renewalPeriod {uint} - The time period which will be added to the current date or expiration date when a renewal is requested
336    * @return {uint} The id of the created entity
337    */
338   function create(Data storage self, uint entityId, string entitDatayHash, bytes32 urlHash, uint expirationDate, uint renewalPeriod) isExpirationDateValid(expirationDate) isRenewalPeriodValid(renewalPeriod) public {
339     self.entities[entityId] = EntityData({
340         owner: msg.sender,
341         dataHash: entitDatayHash,
342         urlHash: urlHash,
343         status: 1,
344         expiration: expirationDate,
345         renewalPeriod: renewalPeriod,
346         oraclizeQueryId: 0,
347         signersArr: new address[](0)
348     });
349     EntityCreated(entityId);
350   }
351 
352   /**
353    * Process validation after the oraclize callback
354    * @param self {object} - The data containing the entity mappings
355    * @param queryId {bytes32} - The id of the oraclize query (returned by the call to oraclize_query method)
356    * @param result {string} - The result of the query
357    */
358   function processValidation(Data storage self, bytes32 queryId, string result) public {
359     uint entityId = self.entityIds[queryId];
360     self.entityIds[queryId] = 0;
361     
362     EntityData storage entity = self.entities[entityId];
363 
364     require (queryId == entity.oraclizeQueryId);
365 
366     string memory entityIdStr = uintToString(entityId);
367     string memory toCompare = strConcat(entityIdStr, ":", entity.dataHash); 
368 
369     if (stringsEqual(result, toCompare)) {
370       if (entity.status == 4) { // if entity is waiting for renewal
371         uint initDate = max(entity.expiration, now);
372         entity.expiration = initDate + entity.renewalPeriod;
373       }
374 
375       entity.status = 2; // set entity status to valid
376       EntityValidated(entityId);
377     } else {
378       entity.status = 1;  // set entity status to validation pending
379       EntityInvalid(entityId);
380     }
381   }
382 
383   /**
384    * Sets a new expiration date for the entity. It will trigger an entity validation through the oracle, so it must be paid.
385    * @param self {object} - The data containing the entity mappings
386    * @param entityId {uint} - The id of the entity
387    * @param expirationDate {uint} - The new expiration date of the entity
388    */
389   function setExpiration (Data storage self, uint entityId, uint expirationDate) isNotClosed(self, entityId) onlyEntity(self, entityId) isExpirationDateValid(expirationDate) public {
390     EntityData storage entity = self.entities[entityId];
391     entity.status = 1;
392     entity.expiration = expirationDate;
393     EntityExpirationSet(entityId);
394   }
395   
396   /**
397    * Sets a new renewal interval
398    * @param self {object} - The data containing the entity mappings
399    * @param entityId {uint} - The id of the entity
400    * @param renewalPeriod {uint} - The new renewal interval (in seconds)
401    */
402   function setRenewalPeriod (Data storage self, uint entityId, uint renewalPeriod) isNotClosed(self, entityId) onlyEntity(self, entityId) isRenewalPeriodValid(renewalPeriod) public {
403     EntityData storage entity = self.entities[entityId];
404     entity.renewalPeriod = renewalPeriod;
405     EntityRenewalSet(entityId);
406   }
407 
408   /**
409    * Close an entity. This status will not allow further operations on the entity.
410    * @param self {object} - The data containing the entity mappings
411    * @param entityId {uint} - The id of the entity
412    */
413   function closeEntity(Data storage self, uint entityId) isNotClosed(self, entityId) onlyEntity(self, entityId) public {
414     self.entities[entityId].status = 8;
415     EntityClosed(entityId);
416   }
417 
418   /**
419    * Registers a new signer in an entity
420    * @param self {object} - The data containing the entity mappings
421    * @param entityId {uint} - The id of the entity
422    * @param signerAddress {address} - The address of the signer to be registered
423    * @param signerDataHash {uint} - The IPFS multihash address of signer information in json format
424    */
425   function registerSigner(Data storage self, uint entityId, address signerAddress, string signerDataHash) isValidEntity(self, entityId) onlyEntity(self, entityId) signerIsNotYetRegistered(self, entityId, signerAddress) public {
426     self.entities[entityId].signersArr.push(signerAddress);
427     self.entities[entityId].signers[signerAddress] = SignerData({
428       signerDataHash: signerDataHash,
429       status: 1
430     });
431     SignerAdded(entityId, signerAddress);
432   }
433 
434   /**
435    * Confirms signer registration
436    * @param self {object} - The data containing the entity mappings
437    * @param entityId {uint} - The id of the entity
438    * @param signerDataHash {string} - The ipfs data hash of the signer to confirm
439    */
440   function confirmSignerRegistration(Data storage self, uint entityId, string signerDataHash) isValidEntity(self, entityId) isWaitingConfirmation(self, entityId, signerDataHash) public {
441     self.entities[entityId].signers[msg.sender].status = 2;
442     SignerConfirmed(entityId, msg.sender);
443   }
444 
445   /**
446    * Removes a signer from an entity
447    * @param self {object} - The data containing the entity mappings
448    * @param entityId {uint} - The id of the entity
449    * @param signerAddress {address} - The address of the signer to be removed
450    */
451   function removeSigner(Data storage self, uint entityId, address signerAddress) isValidEntity(self, entityId) onlyEntity(self, entityId) public {
452     internalRemoveSigner(self, entityId, signerAddress);
453   }
454 
455 
456   /**
457    * Removes a signer from an entity (internal use, without modifiers)
458    * @param self {object} - The data containing the entity mappings
459    * @param entityId {uint} - The id of the entity
460    * @param signerAddress {address} - The address of the signer to be removed
461    */
462   function internalRemoveSigner(Data storage self, uint entityId, address signerAddress) private {
463     EntityData storage entity = self.entities[entityId];
464     address[] storage signersArr = entity.signersArr;
465     SignerData storage signer = entity.signers[signerAddress];
466 
467     if (bytes(signer.signerDataHash).length != 0 || signer.status != 0) {
468       signer.status = 0;
469       signer.signerDataHash = '';
470       delete entity.signers[signerAddress];
471 
472       // Update array for iterator
473       uint i = 0;
474       for (i; signerAddress != signersArr[i]; i++) {}
475       signersArr[i] = signersArr[signersArr.length - 1];
476       signersArr[signersArr.length - 1] = 0;
477       signersArr.length = signersArr.length - 1;
478       
479       SignerRemoved(entityId, signerAddress);
480     }
481   }
482 
483   /**
484    * Leave the specified entity (remove signer if found)
485    * @param self {object} - The data containing the entity mappings
486    * @param entityId {uint} - The id of the entity
487    */
488   function leaveEntity(Data storage self, uint entityId) signerBelongsToEntity(self, entityId) public {
489     internalRemoveSigner(self, entityId, msg.sender);
490   }
491 
492   /**
493     * Checks if an entity can be validated
494     * @param entityId {uint} - The id of the entity to validate
495     * @param url {string} - The URL of the entity
496     * @return {bytes32} - The id of the oraclize query
497     */
498   function canValidateSigningEntity(Data storage self, uint entityId, string url) isNotClosed(self, entityId) isRegisteredURL(self, entityId, url) view public returns (bool) {
499     return true;
500   }
501 
502   /**
503    * Checks if an entity validity can be renewed
504    * @param self {object} - The data containing the entity mappings
505    * @param entityId {uint} - The id of the entity to validate
506    * @param url {string} - The URL of the entity
507    * @return {bool} - True if renewal is possible
508    */
509   function canRenew(Data storage self, uint entityId, string url) isValidatedEntity(self, entityId) isRenewalPeriod(self, entityId) isRegisteredURL(self, entityId, url) view public returns (bool) {
510     return true;
511   }
512 
513   /**
514    * Checks if an entity can issue certificate (from its signers)
515    * @param self {object} - The data containing the entity mappings
516    * @param entityId {uint} - The id of the entity to check
517    * @return {bool} - True if issuance is possible
518    */
519   function canIssueCertificates(Data storage self, uint entityId) isNotClosed(self, entityId) notExpired(self, entityId) signerBelongsToEntity(self, entityId) view public returns (bool) {
520     return true;
521   }
522 
523   /**
524    * @dev Updates entity data
525    * @param self {object} - The data containing the entity mappings
526    * @param entityId {uint} - The id of the entity
527    * @param entityDataHash {string} - The ipfs multihash address of the entity information in json format
528    * @param urlHash {bytes32} - The sha256 hash of the URL of the entity
529    */
530   function updateEntityData(Data storage self, uint entityId, string entityDataHash, bytes32 urlHash) isNotClosed(self, entityId) onlyEntity(self, entityId) public {
531     EntityData storage entity = self.entities[entityId];
532     entity.dataHash = entityDataHash;
533     entity.urlHash = urlHash;
534     entity.status = 1;
535     EntityDataUpdated(entityId);
536   }
537 
538 
539   /**
540    * Update the signer data in the requestes entities
541    * @param self {object} - The data containing the entity mappings
542    * @param entityIds {array} - The ids of the entities to update
543    * @param signerDataHash {string} - The ipfs multihash of the new signer data
544    */
545   function updateSignerData(Data storage self, uint[] entityIds, string signerDataHash) signerBelongsToEntities(self, entityIds) public {
546     uint[] memory updated = new uint[](entityIds.length);
547     for (uint i = 0; i < entityIds.length; i++) {
548       uint entityId = entityIds[i];
549       SignerData storage signer = self.entities[entityId].signers[msg.sender];
550 
551       if (signer.status != 2) {
552         continue;
553       }
554       signer.status = 3;
555       signer.signerDataHash = signerDataHash;
556       updated[i] = entityId;
557     }
558     SignerDataUpdated(updated, msg.sender);
559   }
560 
561   /**
562    * Accepts a new signer data update in the entity
563    * @param self {object} - The data containing the entity mappings
564    * @param entityId {uint} - The id of the entity
565    * @param signerAddress {address} - The address of the signer update to be accepted
566    * @param signerDataHash {uint} - The IPFS multihash address of signer information in json format to be accepted
567    */
568   function acceptSignerUpdate(Data storage self, uint entityId, address signerAddress, string signerDataHash) onlyEntity(self, entityId) notExpired(self, entityId) signerUpdateCanBeAccepted(self, entityId, signerAddress, signerDataHash) public {
569     EntityData storage entity = self.entities[entityId];
570     entity.signers[signerAddress].status = 2;
571     SignerUpdateAccepted(entityId, signerAddress);
572   }
573 
574   // HELPER METHODS
575 
576   /**
577    * Returns the max of two numbers
578    * @param a {uint} - Input number a
579    * @param b {uint} - Input number b
580    * @return {uint} - The maximum of the two inputs
581    */
582   function max(uint a, uint b) pure public returns(uint) {
583     if (a > b) {
584       return a;
585     } else {
586       return b;
587     }
588   }
589 
590   /**
591    * @dev Compares two strings
592    * @param _a {string} - One of the strings
593    * @param _b {string} - The other string
594    * @return {bool} True if the two strings are equal, false otherwise
595    */
596   function stringsEqual(string memory _a, string memory _b) pure internal returns (bool) {
597     bytes memory a = bytes(_a);
598     bytes memory b = bytes(_b);
599     if (a.length != b.length)
600       return false;
601     for (uint i = 0; i < a.length; i ++) {
602       if (a[i] != b[i])
603         return false;
604         }
605     return true;
606   }
607 
608   function strConcat(string _a, string _b, string _c, string _d, string _e) pure internal returns (string){
609     bytes memory _ba = bytes(_a);
610     bytes memory _bb = bytes(_b);
611     bytes memory _bc = bytes(_c);
612     bytes memory _bd = bytes(_d);
613     bytes memory _be = bytes(_e);
614     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
615     bytes memory babcde = bytes(abcde);
616     uint k = 0;
617     for (uint i = 0; i < _ba.length; i++) {babcde[k++] = _ba[i];}
618     for (i = 0; i < _bb.length; i++) {babcde[k++] = _bb[i];}
619     for (i = 0; i < _bc.length; i++) {babcde[k++] = _bc[i];}
620     for (i = 0; i < _bd.length; i++) {babcde[k++] = _bd[i];}
621     for (i = 0; i < _be.length; i++) {babcde[k++] = _be[i];}
622     return string(babcde);
623   }
624 
625   function strConcat(string _a, string _b, string _c, string _d) pure internal returns (string) {
626       return strConcat(_a, _b, _c, _d, "");
627   }
628 
629   function strConcat(string _a, string _b, string _c) pure internal returns (string) {
630       return strConcat(_a, _b, _c, "", "");
631   }
632 
633   function strConcat(string _a, string _b) pure internal returns (string) {
634       return strConcat(_a, _b, "", "", "");
635   }
636 
637   // uint to string
638   function uintToString(uint v) pure public returns (string) {
639     uint maxlength = 100;
640     bytes memory reversed = new bytes(maxlength);
641     uint i = 0;
642     while (v != 0) {
643       uint remainder = v % 10;
644       v = v / 10;
645       reversed[i++] = byte(48 + remainder);
646     }
647     bytes memory s = new bytes(i); // i + 1 is inefficient
648     for (uint j = 0; j < i; j++) {
649         s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
650     }
651     string memory str = string(s); // memory isn't implicitly convertible to storage
652     return str;
653   }
654 
655   /**
656    * Set the oraclize query id of the last request
657    * @param self {object} - The data containing the entity mappings
658    * @param id {uint} - The id of the entity
659    * @param queryId {bytes32} - The query id from the oraclize request
660    */
661   function setOraclizeQueryId(Data storage self, uint id, bytes32 queryId) public {
662     self.entities[id].oraclizeQueryId = queryId;
663   }
664 
665   // Helper functions
666 
667   /**
668    * Returns True if specified entity is validated or waiting to be renewed. False otherwise.
669    * @param self {object} - The data containing the entity mappings
670    * @param id {uint} - The id of the entity to check 
671    * @return {bool} - True if the entity is validated
672    */
673   function isValidated(Data storage self, uint id) view public returns (bool) {
674     return (id > 0 && (self.entities[id].status == 2 || self.entities[id].status == 4));
675   }
676 
677  /**
678   * Returns True if specified entity is not expired. False otherwise.
679   * @param self {object} - The data containing the entity mappings
680   * @param id {uint} - The id of the entity to check 
681   * @return {bool} - True if the entity is not expired
682   */
683   function isExpired(Data storage self, uint id) view public returns (bool) {
684     return (id > 0 && (self.entities[id].expiration < now));
685   }
686 
687   /**
688   * Returns True if specified entity is closed.
689   * @param self {object} - The data containing the entity mappings
690   * @param id {uint} - The id of the entity to check 
691   * @return {bool} - True if the entity is closed
692   */
693   function isClosed(Data storage self, uint id) view public returns (bool) {
694     return self.entities[id].status == 8;
695   }
696 
697  /**
698    * Returns True if specified entity is validated and not expired
699    * @param self {object} - The data containing the entity mappings
700    * @param id {uint} - The id of the entity to check 
701    * @return {bool} - True if the entity is validated
702    */
703   function isValid(Data storage self, uint id) view public returns (bool) {
704     return isValidated(self, id) && !isExpired(self, id) && !isClosed(self, id);
705   }
706 
707  /**
708    * Returns True if specified entity exists
709    * @param self {object} - The data containing the entity mappings
710    * @param id {uint} - The id of the entity to check 
711    * @return {bool} - True if the entity exists
712    */
713   function exists(Data storage self, uint id) view public returns(bool) {
714     EntityData storage entity = self.entities[id];
715     return entity.status > 0;
716   }
717 
718   // MODIFIERS
719   
720   /**
721    * Valid if the renewal period is less than 31 days
722    * @param renewalPeriod {uint} - The renewal period to check (in seconds)
723    */
724   modifier isRenewalPeriodValid(uint renewalPeriod) {
725     require(renewalPeriod >= 0 && renewalPeriod <= 32 * 24 * 60 * 60); // Renewal period less than 32 days
726     _;
727   }
728 
729   /**
730    * Valid if the expiration date is in less than 31 days
731    * @param expiration {uint} - The expiration date (in seconds)
732    */
733   modifier isExpirationDateValid(uint expiration) {
734     require(expiration - now > 0 && expiration - now <= 32 * 24 * 60 * 60); // Expiration date is in less than 32 days in the future
735     _;
736   }
737   
738   /**
739    * Returns True if specified entity is validated or waiting to be renewed. False otherwise.
740    * @param self {object} - The data containing the entity mappings
741    * @param id {uint} - The id of the entity to check 
742    */
743   modifier isValidatedEntity(Data storage self, uint id) {
744     require (isValidated(self, id));
745     _;
746   }
747 
748   /**
749    * Returns True if specified entity is validated or waiting to be renewed, not expired and not closed. False otherwise.
750    * @param self {object} - The data containing the entity mappings
751    * @param id {uint} - The id of the entity to check 
752    */
753   modifier isValidEntity(Data storage self, uint id) {
754     require (isValid(self, id));
755     _;
756   }
757 
758   /**
759   * Returns True if specified entity is validated. False otherwise.
760   * @param self {object} - The data containing the entity mappings
761   * @param id {uint} - The id of the entity to check 
762   */
763   modifier notExpired(Data storage self, uint id) {
764     require (!isExpired(self, id));
765     _;  
766   }
767 
768   /**
769     * Returns True if tansaction sent by owner of entity. False otherwise.
770     * @param self {object} - The data containing the entity mappings
771     * @param id {uint} - The id of the entity to check
772     */
773   modifier onlyEntity(Data storage self, uint id) {
774     require (msg.sender == self.entities[id].owner);
775     _;
776   }
777 
778   /**
779     * Returns True if an URL is the one associated to the entity. False otherwise.
780     * @param self {object} - The data containing the entity mappings
781     * @param entityId {uint} - The id of the entity
782     * @param url {string} - The  URL
783     */
784   modifier isRegisteredURL(Data storage self, uint entityId, string url) {
785     require (self.entities[entityId].urlHash == sha256(url));
786     _;
787   }
788 
789   /**
790    * Returns True if current time is in renewal period for a valid entity. False otherwise.
791    * @param self {object} - The data containing the entity mappings
792    * @param entityId {uint} - The id of the entity to check 
793    */
794   modifier isRenewalPeriod(Data storage self, uint entityId) {
795     EntityData storage entity = self.entities[entityId];
796     require (entity.renewalPeriod > 0 && entityId > 0 && (entity.expiration - entity.renewalPeriod < now) && entity.status == 2);
797     _;
798   }
799 
800   /**
801    * True if sender is registered in entity. False otherwise.
802    * @param self {object} - The data containing the entity mappings
803    * @param entityId {uint} - The id of the entity 
804    */
805   modifier signerBelongsToEntity(Data storage self, uint entityId) {
806     EntityData storage entity = self.entities[entityId];
807     require (entityId > 0 && (bytes(entity.signers[msg.sender].signerDataHash).length != 0) && (entity.signers[msg.sender].status == 2));
808     _;
809   }
810 
811   /**
812    * True if sender is registered in all the entities. False otherwise.
813    * @param self {object} - The data containing the entity mappings
814    * @param entityIds {array} - The ids of the entities
815    */
816   modifier signerBelongsToEntities(Data storage self, uint[] entityIds) {
817     for (uint i = 0; i < entityIds.length; i++) {
818       uint entityId = entityIds[i];
819       EntityData storage entity = self.entities[entityId];
820       require (entityId > 0 && (entity.signers[msg.sender].status != 0));
821     }
822     _;
823   }
824 
825   /**
826    * True if the signer was not yet added to an entity.
827    * @param self {object} - The data containing the entity mappings
828    * @param entityId {uint} - The id of the entity 
829    * @param signerAddress {address} - The signer to check
830    */
831   modifier signerIsNotYetRegistered(Data storage self, uint entityId, address signerAddress) {
832     EntityData storage entity = self.entities[entityId];
833     require (entity.signers[signerAddress].status == 0);
834     _;
835   }
836 
837   /**
838    * True if the entity is validated AND the signer has a pending update with a matching IPFS data hash
839    * @param self {object} - The data containing the entity mappings
840    * @param entityId {uint} - The id of the entity 
841    * @param signerAddress {address} - The signer to check
842    * @param signerDataHash {string} - The signer IPFS data pending of confirmation
843    */
844   modifier signerUpdateCanBeAccepted(Data storage self, uint entityId, address signerAddress, string signerDataHash) {
845     require (isValid(self, entityId));
846     EntityData storage entity = self.entities[entityId];
847     string memory oldSignerDatHash = entity.signers[signerAddress].signerDataHash;
848     require (entity.signers[signerAddress].status == 3 && stringsEqual(oldSignerDatHash, signerDataHash));
849     _;
850   }
851 
852   /**
853    * True if the sender is registered as a signer in entityId and the status is VALIDATION_PENDING. False otherwise.
854    * @param self {object} - The data containing the entity mappings
855    * @param entityId {uint} - The id of the entity to check
856    */
857   modifier isWaitingConfirmation(Data storage self, uint entityId, string signerDataHash) {
858     EntityData storage entity = self.entities[entityId];
859     SignerData storage signer = entity.signers[msg.sender];
860     require ((bytes(signer.signerDataHash).length != 0) && (signer.status == 1) && stringsEqual(signer.signerDataHash, signerDataHash));
861     _;
862   }
863 
864   /**
865    * True if the entity has not been closed
866    * @param self {object} - The data containing the entity mappings
867    * @param entityId {uint} - The id of the entity to check
868    */
869   modifier isNotClosed(Data storage self, uint entityId) {
870     require(!isClosed(self, entityId));
871     _;
872   }
873 
874   // EVENTS
875 
876   event EntityCreated(uint indexed entityId);
877   event EntityValidated(uint indexed entityId);
878   event EntityDataUpdated(uint indexed entityId);
879   event EntityInvalid(uint indexed entityId);
880   event SignerAdded(uint indexed entityId, address indexed signerAddress);
881   event SignerDataUpdated(uint[] entities, address indexed signerAddress);
882   event SignerUpdateAccepted(uint indexed entityId, address indexed signerAddress);
883   event SignerRemoved(uint indexed entityId, address signerAddress);
884   event EntityClosed(uint indexed entityId);
885   event SignerConfirmed(uint indexed entityId, address signerAddress);
886   event EntityExpirationSet(uint indexed entityId);
887   event EntityRenewalSet(uint indexed entityId);  
888  }
889 
890 library SignLib {
891 
892   // METHODS
893 
894   /**
895    * Requests the signature for a certificate to an entity.
896    * Only one request possible (future ones are renewals)
897    * @param ed {object} - The data containing the entity mappings
898    * @param cd {object} - The data containing the certificate mappings
899    * @param certificateId {uint} - The id of the certificate
900    * @param entityId {uint} - The id of the entity
901    */
902   function requestSignatureToEntity(EntityLib.Data storage ed, CertsLib.Data storage cd, uint certificateId, uint entityId) canRequestSignature(ed, cd, certificateId) isValid(ed, entityId) notHasSigningRequest(cd, certificateId, entityId) public {
903     CertsLib.CertData storage certificate = cd.certificates[certificateId];
904     addMissingSignature(certificate, entityId, 0x1, 0);
905     EntitySignatureRequested(certificateId, entityId);
906   }
907 
908   /**
909    * Requests the signature for a certificate to a peer
910    * Only one request possible (future ones are renewals)
911    * @param cd {object} - The data containing the certificate mappings
912    * @param certificateId {uint} - The id of the certificate
913    * @param peer {address} - The address of the peer
914    */
915   function requestSignatureToPeer(EntityLib.Data storage ed, CertsLib.Data storage cd, uint certificateId, address peer) canRequestSignature(ed, cd, certificateId) notHasPeerSignature(cd, certificateId, peer) public {
916     CertsLib.CertData storage certificate = cd.certificates[certificateId];
917     addMissingPeerSignature(certificate, peer, 0x1, 0);
918     PeerSignatureRequested(certificateId, peer);
919   }
920 
921     /**
922     * Entity signs a certificate with pending request
923     * @param ed {object} - The data containing the entity mappings
924     * @param cd {object} - The data containing the certificate mappings
925     * @param entityId {uint} - The id of the entity
926     * @param certificateId {uint} - The id of the certificate
927     * @param expiration {uint} - The expiration time of the signature (in seconds)
928     * @param _purpose {bytes32} - The sha-256 hash of the purpose data
929     */
930   function signCertificateAsEntity(EntityLib.Data storage ed, CertsLib.Data storage cd, uint entityId, uint certificateId, uint expiration, bytes32 _purpose) isValid(ed, entityId) signerBelongsToEntity(ed, entityId) hasPendingSignatureOrIsOwner(ed, cd, certificateId, entityId) public {
931     CertsLib.CertData storage certificate = cd.certificates[certificateId];
932     bytes32 purpose = (_purpose == 0x0 || _purpose == 0x1) ? bytes32(0x2) : _purpose;
933     addMissingSignature(certificate, entityId, purpose, expiration);
934     CertificateSignedByEntity(certificateId, entityId, msg.sender);
935   }
936 
937   /**
938    * Peer signs a certificate with pending request
939    * @param cd {object} - The data containing the certificate mappings
940    * @param certificateId {uint} - The id of the certificate
941    * @param expiration {uint} - The expiration time of the signature (in seconds)
942    * @param _purpose {bytes32} - The sha-256 hash of the purpose data
943    */
944   function signCertificateAsPeer(CertsLib.Data storage cd, uint certificateId, uint expiration, bytes32 _purpose) hasPendingPeerSignatureOrIsOwner(cd, certificateId) public {
945     CertsLib.CertData storage certificate = cd.certificates[certificateId];
946     bytes32 purpose = (_purpose == 0x0 || _purpose == 0x1) ? bytes32(0x2) : _purpose;
947     addMissingPeerSignature(certificate, msg.sender, purpose, expiration);
948     CertificateSignedByPeer(certificateId, msg.sender);
949   }
950 
951   // HELPER FUNCTIONS
952 
953   /**
954    * Add an entity signature to the entity signatures array (if missing) and set the specified status and expiration
955    * @param certificate {object} - The certificate to add the peer signature
956    * @param entityId {uint} - The id of the entity signing the certificate
957    * @param status {uint} - The status/purpose of the signature
958    * @param expiration {uint} - The expiration time of the signature (in seconds)
959    */
960   function addMissingSignature(CertsLib.CertData storage certificate, uint entityId, bytes32 status, uint expiration) private {
961     uint[] storage entitiesArr = certificate.entitiesArr;
962     for (uint i = 0; i < entitiesArr.length && entitiesArr[i] != entityId; i++) {}
963     if (i == entitiesArr.length) {
964       entitiesArr.push(entityId);
965     }
966     certificate.entities[entityId].status = status;
967     certificate.entities[entityId].exp = expiration;
968   }
969 
970   /**
971    * Add a peer signature to the signatures array (if missing) and set the specified status and expiration
972    * @param certificate {object} - The certificate to add the peer signature
973    * @param peer {address} - The address of the peer to add signature
974    * @param status {uint} - The status/purpose of the signature
975    * @param expiration {uint} - The expiration time of the signature (in seconds)
976    */
977   function addMissingPeerSignature(CertsLib.CertData storage certificate, address peer, bytes32 status, uint expiration) private {
978     address[] storage signaturesArr = certificate.signaturesArr;
979     for (uint i = 0; i < signaturesArr.length && signaturesArr[i] != peer; i++) {}
980     if (i == signaturesArr.length) {
981       signaturesArr.push(peer);
982     }
983     certificate.signatures[peer].status = status;
984     certificate.signatures[peer].exp = expiration;
985   }
986 
987   // MODIFIERS
988 
989   /**
990    * Returns True if msg.sender is the owner of the specified certificate or the sender is a confirmed signer of certificate entity. False otherwise.
991    * @param cd {object} - The data containing the certificate mappings
992    * @param id {uint} - The id of the certificate
993    */
994   modifier canRequestSignature(EntityLib.Data storage ed, CertsLib.Data storage cd, uint id) {
995     require (cd.certificates[id].owner == msg.sender ||
996       (cd.certificates[id].entityId > 0 && EntityLib.isValid(ed, cd.certificates[id].entityId) && ed.entities[cd.certificates[id].entityId].signers[msg.sender].status == 0x2)
997     );
998     _;
999   }
1000 
1001   /**
1002    * Returns True if specified entity is validated or waiting to be renewed, not expired and not closed. False otherwise.
1003    * @param ed {object} - The data containing the entity mappings
1004    * @param id {uint} - The id of the entity to check 
1005    */
1006   modifier isValid(EntityLib.Data storage ed, uint id) {
1007     require (EntityLib.isValid(ed, id));
1008     _;
1009   }
1010 
1011   /**
1012    * Returns True if specified certificate has not been validated yet by entity. False otherwise.
1013    * @param cd {object} - The data containing the certificate mappings
1014    * @param certificateId {uint} - The id of the certificate to check
1015    * @param entityId {uint} - The id of the entity to check
1016    */
1017   modifier notHasSigningRequest(CertsLib.Data storage cd, uint certificateId, uint entityId) {
1018     require (cd.certificates[certificateId].entities[entityId].status != 0x1);
1019     _;    
1020   }
1021 
1022   /**
1023    * Returns True if specified certificate has not been signed yet. False otherwise;   
1024    * @param cd {object} - The data containing the certificate mappings
1025    * @param certificateId {uint} - The id of the certificate to check
1026    * @param signerAddress {address} - The id of the certificate to check
1027    */
1028   modifier notHasPeerSignature(CertsLib.Data storage cd, uint certificateId, address signerAddress) {    
1029     require (cd.certificates[certificateId].signatures[signerAddress].status != 0x1);
1030     _;
1031   }
1032 
1033   /**
1034    * True if sender address is the owner of the entity or is a signer registered in entity. False otherwise.
1035    * @param ed {object} - The data containing the entity mappings
1036    * @param entityId {uint} - The id of the entity 
1037    */
1038   modifier signerBelongsToEntity(EntityLib.Data storage ed, uint entityId) {
1039     require (entityId > 0 && (bytes(ed.entities[entityId].signers[msg.sender].signerDataHash).length != 0) && (ed.entities[entityId].signers[msg.sender].status == 0x2));
1040     _;
1041   }
1042 
1043   /**
1044    * True if a signature request has been sent to entity or the issuer of the certificate is requested entity itself. False otherwise.
1045    * @param cd {object} - The data containing the certificate mappings
1046    * @param certificateId {uint} - The id of the certificate to check
1047    * @param entityId {uint} - The id of the entity to check
1048    */
1049   modifier hasPendingSignatureOrIsOwner(EntityLib.Data storage ed, CertsLib.Data storage cd, uint certificateId, uint entityId) {
1050     require (cd.certificates[certificateId].entities[entityId].status == 0x1 || cd.certificates[certificateId].entityId == entityId);
1051     _;
1052   }
1053 
1054   /**
1055    * True if a signature is pending for the sender or the sender is the owner. False otherwise.
1056    * @param cd {object} - The data containing the certificate mappings
1057    * @param certificateId {uint} - The id of the certificate to check
1058    */
1059   modifier hasPendingPeerSignatureOrIsOwner(CertsLib.Data storage cd, uint certificateId) {
1060     require (cd.certificates[certificateId].signatures[msg.sender].status == 0x1 || cd.certificates[certificateId].owner == msg.sender);
1061     _;
1062   }
1063 
1064   // EVENTS
1065   event EntitySignatureRequested(uint indexed certificateId, uint indexed entityId);
1066   event PeerSignatureRequested(uint indexed certificateId, address indexed signerAddress);
1067   event CertificateSignedByEntity(uint indexed certificateId, uint indexed entityId, address indexed signerAddress);
1068   event CertificateSignedByPeer(uint indexed certificateId, address indexed signerAddress);
1069 }
1070 
1071 contract OraclizeI {
1072     address public cbAddress;
1073     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
1074     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
1075     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
1076     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
1077     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
1078     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
1079     function getPrice(string _datasource) returns (uint _dsprice);
1080     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
1081     function useCoupon(string _coupon);
1082     function setProofType(byte _proofType);
1083     function setConfig(bytes32 _config);
1084     function setCustomGasPrice(uint _gasPrice);
1085     function randomDS_getSessionPubKeyHash() returns(bytes32);
1086 }
1087 
1088 contract OraclizeAddrResolverI {
1089     function getAddress() returns (address _addr);
1090 }
1091 
1092 library Buffer {
1093     struct buffer {
1094         bytes buf;
1095         uint capacity;
1096     }
1097 
1098     function init(buffer memory buf, uint capacity) internal constant {
1099         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
1100         // Allocate space for the buffer data
1101         buf.capacity = capacity;
1102         assembly {
1103             let ptr := mload(0x40)
1104             mstore(buf, ptr)
1105             mstore(0x40, add(ptr, capacity))
1106         }
1107     }
1108 
1109     function resize(buffer memory buf, uint capacity) private constant {
1110         bytes memory oldbuf = buf.buf;
1111         init(buf, capacity);
1112         append(buf, oldbuf);
1113     }
1114 
1115     function max(uint a, uint b) private constant returns(uint) {
1116         if(a > b) {
1117             return a;
1118         }
1119         return b;
1120     }
1121 
1122     /**
1123      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
1124      *      would exceed the capacity of the buffer.
1125      * @param buf The buffer to append to.
1126      * @param data The data to append.
1127      * @return The original buffer.
1128      */
1129     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
1130         if(data.length + buf.buf.length > buf.capacity) {
1131             resize(buf, max(buf.capacity, data.length) * 2);
1132         }
1133 
1134         uint dest;
1135         uint src;
1136         uint len = data.length;
1137         assembly {
1138             // Memory address of the buffer data
1139             let bufptr := mload(buf)
1140             // Length of existing buffer data
1141             let buflen := mload(bufptr)
1142             // Start address = buffer address + buffer length + sizeof(buffer length)
1143             dest := add(add(bufptr, buflen), 32)
1144             // Update buffer length
1145             mstore(bufptr, add(buflen, mload(data)))
1146             src := add(data, 32)
1147         }
1148 
1149         // Copy word-length chunks while possible
1150         for(; len >= 32; len -= 32) {
1151             assembly {
1152                 mstore(dest, mload(src))
1153             }
1154             dest += 32;
1155             src += 32;
1156         }
1157 
1158         // Copy remaining bytes
1159         uint mask = 256 ** (32 - len) - 1;
1160         assembly {
1161             let srcpart := and(mload(src), not(mask))
1162             let destpart := and(mload(dest), mask)
1163             mstore(dest, or(destpart, srcpart))
1164         }
1165 
1166         return buf;
1167     }
1168 
1169     /**
1170      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
1171      * exceed the capacity of the buffer.
1172      * @param buf The buffer to append to.
1173      * @param data The data to append.
1174      * @return The original buffer.
1175      */
1176     function append(buffer memory buf, uint8 data) internal constant {
1177         if(buf.buf.length + 1 > buf.capacity) {
1178             resize(buf, buf.capacity * 2);
1179         }
1180 
1181         assembly {
1182             // Memory address of the buffer data
1183             let bufptr := mload(buf)
1184             // Length of existing buffer data
1185             let buflen := mload(bufptr)
1186             // Address = buffer address + buffer length + sizeof(buffer length)
1187             let dest := add(add(bufptr, buflen), 32)
1188             mstore8(dest, data)
1189             // Update buffer length
1190             mstore(bufptr, add(buflen, 1))
1191         }
1192     }
1193 
1194     /**
1195      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
1196      * exceed the capacity of the buffer.
1197      * @param buf The buffer to append to.
1198      * @param data The data to append.
1199      * @return The original buffer.
1200      */
1201     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
1202         if(len + buf.buf.length > buf.capacity) {
1203             resize(buf, max(buf.capacity, len) * 2);
1204         }
1205 
1206         uint mask = 256 ** len - 1;
1207         assembly {
1208             // Memory address of the buffer data
1209             let bufptr := mload(buf)
1210             // Length of existing buffer data
1211             let buflen := mload(bufptr)
1212             // Address = buffer address + buffer length + sizeof(buffer length) + len
1213             let dest := add(add(bufptr, buflen), len)
1214             mstore(dest, or(and(mload(dest), not(mask)), data))
1215             // Update buffer length
1216             mstore(bufptr, add(buflen, len))
1217         }
1218         return buf;
1219     }
1220 }
1221 
1222 library CBOR {
1223     using Buffer for Buffer.buffer;
1224 
1225     uint8 private constant MAJOR_TYPE_INT = 0;
1226     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
1227     uint8 private constant MAJOR_TYPE_BYTES = 2;
1228     uint8 private constant MAJOR_TYPE_STRING = 3;
1229     uint8 private constant MAJOR_TYPE_ARRAY = 4;
1230     uint8 private constant MAJOR_TYPE_MAP = 5;
1231     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
1232 
1233     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
1234         return x * (2 ** y);
1235     }
1236 
1237     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
1238         if(value <= 23) {
1239             buf.append(uint8(shl8(major, 5) | value));
1240         } else if(value <= 0xFF) {
1241             buf.append(uint8(shl8(major, 5) | 24));
1242             buf.appendInt(value, 1);
1243         } else if(value <= 0xFFFF) {
1244             buf.append(uint8(shl8(major, 5) | 25));
1245             buf.appendInt(value, 2);
1246         } else if(value <= 0xFFFFFFFF) {
1247             buf.append(uint8(shl8(major, 5) | 26));
1248             buf.appendInt(value, 4);
1249         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
1250             buf.append(uint8(shl8(major, 5) | 27));
1251             buf.appendInt(value, 8);
1252         }
1253     }
1254 
1255     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
1256         buf.append(uint8(shl8(major, 5) | 31));
1257     }
1258 
1259     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
1260         encodeType(buf, MAJOR_TYPE_INT, value);
1261     }
1262 
1263     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
1264         if(value >= 0) {
1265             encodeType(buf, MAJOR_TYPE_INT, uint(value));
1266         } else {
1267             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
1268         }
1269     }
1270 
1271     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
1272         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
1273         buf.append(value);
1274     }
1275 
1276     function encodeString(Buffer.buffer memory buf, string value) internal constant {
1277         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
1278         buf.append(bytes(value));
1279     }
1280 
1281     function startArray(Buffer.buffer memory buf) internal constant {
1282         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
1283     }
1284 
1285     function startMap(Buffer.buffer memory buf) internal constant {
1286         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
1287     }
1288 
1289     function endSequence(Buffer.buffer memory buf) internal constant {
1290         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
1291     }
1292 }
1293 
1294 contract usingOraclize {
1295     uint constant day = 60*60*24;
1296     uint constant week = 60*60*24*7;
1297     uint constant month = 60*60*24*30;
1298     byte constant proofType_NONE = 0x00;
1299     byte constant proofType_TLSNotary = 0x10;
1300     byte constant proofType_Android = 0x20;
1301     byte constant proofType_Ledger = 0x30;
1302     byte constant proofType_Native = 0xF0;
1303     byte constant proofStorage_IPFS = 0x01;
1304     uint8 constant networkID_auto = 0;
1305     uint8 constant networkID_mainnet = 1;
1306     uint8 constant networkID_testnet = 2;
1307     uint8 constant networkID_morden = 2;
1308     uint8 constant networkID_consensys = 161;
1309 
1310     OraclizeAddrResolverI OAR;
1311 
1312     OraclizeI oraclize;
1313     modifier oraclizeAPI {
1314         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
1315             oraclize_setNetwork(networkID_auto);
1316 
1317         if(address(oraclize) != OAR.getAddress())
1318             oraclize = OraclizeI(OAR.getAddress());
1319 
1320         _;
1321     }
1322     modifier coupon(string code){
1323         oraclize = OraclizeI(OAR.getAddress());
1324         oraclize.useCoupon(code);
1325         _;
1326     }
1327 
1328     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
1329         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
1330             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1331             oraclize_setNetworkName("eth_mainnet");
1332             return true;
1333         }
1334         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
1335             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1336             oraclize_setNetworkName("eth_ropsten3");
1337             return true;
1338         }
1339         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
1340             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1341             oraclize_setNetworkName("eth_kovan");
1342             return true;
1343         }
1344         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
1345             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1346             oraclize_setNetworkName("eth_rinkeby");
1347             return true;
1348         }
1349         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
1350             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1351             return true;
1352         }
1353         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
1354             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1355             return true;
1356         }
1357         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
1358             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1359             return true;
1360         }
1361         return false;
1362     }
1363 
1364     function __callback(bytes32 myid, string result) {
1365         __callback(myid, result, new bytes(0));
1366     }
1367     function __callback(bytes32 myid, string result, bytes proof) {
1368     }
1369 
1370     function oraclize_useCoupon(string code) oraclizeAPI internal {
1371         oraclize.useCoupon(code);
1372     }
1373 
1374     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
1375         return oraclize.getPrice(datasource);
1376     }
1377 
1378     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
1379         return oraclize.getPrice(datasource, gaslimit);
1380     }
1381 
1382     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1383         uint price = oraclize.getPrice(datasource);
1384         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1385         return oraclize.query.value(price)(0, datasource, arg);
1386     }
1387     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1388         uint price = oraclize.getPrice(datasource);
1389         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1390         return oraclize.query.value(price)(timestamp, datasource, arg);
1391     }
1392     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1393         uint price = oraclize.getPrice(datasource, gaslimit);
1394         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1395         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
1396     }
1397     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1398         uint price = oraclize.getPrice(datasource, gaslimit);
1399         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1400         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
1401     }
1402     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1403         uint price = oraclize.getPrice(datasource);
1404         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1405         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
1406     }
1407     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1408         uint price = oraclize.getPrice(datasource);
1409         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1410         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
1411     }
1412     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1413         uint price = oraclize.getPrice(datasource, gaslimit);
1414         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1415         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
1416     }
1417     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1418         uint price = oraclize.getPrice(datasource, gaslimit);
1419         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1420         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
1421     }
1422     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1423         uint price = oraclize.getPrice(datasource);
1424         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1425         bytes memory args = stra2cbor(argN);
1426         return oraclize.queryN.value(price)(0, datasource, args);
1427     }
1428     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1429         uint price = oraclize.getPrice(datasource);
1430         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1431         bytes memory args = stra2cbor(argN);
1432         return oraclize.queryN.value(price)(timestamp, datasource, args);
1433     }
1434     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1435         uint price = oraclize.getPrice(datasource, gaslimit);
1436         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1437         bytes memory args = stra2cbor(argN);
1438         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1439     }
1440     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1441         uint price = oraclize.getPrice(datasource, gaslimit);
1442         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1443         bytes memory args = stra2cbor(argN);
1444         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1445     }
1446     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1447         string[] memory dynargs = new string[](1);
1448         dynargs[0] = args[0];
1449         return oraclize_query(datasource, dynargs);
1450     }
1451     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1452         string[] memory dynargs = new string[](1);
1453         dynargs[0] = args[0];
1454         return oraclize_query(timestamp, datasource, dynargs);
1455     }
1456     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1457         string[] memory dynargs = new string[](1);
1458         dynargs[0] = args[0];
1459         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1460     }
1461     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1462         string[] memory dynargs = new string[](1);
1463         dynargs[0] = args[0];
1464         return oraclize_query(datasource, dynargs, gaslimit);
1465     }
1466 
1467     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1468         string[] memory dynargs = new string[](2);
1469         dynargs[0] = args[0];
1470         dynargs[1] = args[1];
1471         return oraclize_query(datasource, dynargs);
1472     }
1473     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1474         string[] memory dynargs = new string[](2);
1475         dynargs[0] = args[0];
1476         dynargs[1] = args[1];
1477         return oraclize_query(timestamp, datasource, dynargs);
1478     }
1479     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1480         string[] memory dynargs = new string[](2);
1481         dynargs[0] = args[0];
1482         dynargs[1] = args[1];
1483         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1484     }
1485     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1486         string[] memory dynargs = new string[](2);
1487         dynargs[0] = args[0];
1488         dynargs[1] = args[1];
1489         return oraclize_query(datasource, dynargs, gaslimit);
1490     }
1491     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1492         string[] memory dynargs = new string[](3);
1493         dynargs[0] = args[0];
1494         dynargs[1] = args[1];
1495         dynargs[2] = args[2];
1496         return oraclize_query(datasource, dynargs);
1497     }
1498     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1499         string[] memory dynargs = new string[](3);
1500         dynargs[0] = args[0];
1501         dynargs[1] = args[1];
1502         dynargs[2] = args[2];
1503         return oraclize_query(timestamp, datasource, dynargs);
1504     }
1505     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1506         string[] memory dynargs = new string[](3);
1507         dynargs[0] = args[0];
1508         dynargs[1] = args[1];
1509         dynargs[2] = args[2];
1510         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1511     }
1512     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1513         string[] memory dynargs = new string[](3);
1514         dynargs[0] = args[0];
1515         dynargs[1] = args[1];
1516         dynargs[2] = args[2];
1517         return oraclize_query(datasource, dynargs, gaslimit);
1518     }
1519 
1520     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1521         string[] memory dynargs = new string[](4);
1522         dynargs[0] = args[0];
1523         dynargs[1] = args[1];
1524         dynargs[2] = args[2];
1525         dynargs[3] = args[3];
1526         return oraclize_query(datasource, dynargs);
1527     }
1528     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1529         string[] memory dynargs = new string[](4);
1530         dynargs[0] = args[0];
1531         dynargs[1] = args[1];
1532         dynargs[2] = args[2];
1533         dynargs[3] = args[3];
1534         return oraclize_query(timestamp, datasource, dynargs);
1535     }
1536     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1537         string[] memory dynargs = new string[](4);
1538         dynargs[0] = args[0];
1539         dynargs[1] = args[1];
1540         dynargs[2] = args[2];
1541         dynargs[3] = args[3];
1542         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1543     }
1544     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1545         string[] memory dynargs = new string[](4);
1546         dynargs[0] = args[0];
1547         dynargs[1] = args[1];
1548         dynargs[2] = args[2];
1549         dynargs[3] = args[3];
1550         return oraclize_query(datasource, dynargs, gaslimit);
1551     }
1552     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1553         string[] memory dynargs = new string[](5);
1554         dynargs[0] = args[0];
1555         dynargs[1] = args[1];
1556         dynargs[2] = args[2];
1557         dynargs[3] = args[3];
1558         dynargs[4] = args[4];
1559         return oraclize_query(datasource, dynargs);
1560     }
1561     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1562         string[] memory dynargs = new string[](5);
1563         dynargs[0] = args[0];
1564         dynargs[1] = args[1];
1565         dynargs[2] = args[2];
1566         dynargs[3] = args[3];
1567         dynargs[4] = args[4];
1568         return oraclize_query(timestamp, datasource, dynargs);
1569     }
1570     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1571         string[] memory dynargs = new string[](5);
1572         dynargs[0] = args[0];
1573         dynargs[1] = args[1];
1574         dynargs[2] = args[2];
1575         dynargs[3] = args[3];
1576         dynargs[4] = args[4];
1577         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1578     }
1579     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1580         string[] memory dynargs = new string[](5);
1581         dynargs[0] = args[0];
1582         dynargs[1] = args[1];
1583         dynargs[2] = args[2];
1584         dynargs[3] = args[3];
1585         dynargs[4] = args[4];
1586         return oraclize_query(datasource, dynargs, gaslimit);
1587     }
1588     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1589         uint price = oraclize.getPrice(datasource);
1590         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1591         bytes memory args = ba2cbor(argN);
1592         return oraclize.queryN.value(price)(0, datasource, args);
1593     }
1594     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1595         uint price = oraclize.getPrice(datasource);
1596         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1597         bytes memory args = ba2cbor(argN);
1598         return oraclize.queryN.value(price)(timestamp, datasource, args);
1599     }
1600     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1601         uint price = oraclize.getPrice(datasource, gaslimit);
1602         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1603         bytes memory args = ba2cbor(argN);
1604         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1605     }
1606     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1607         uint price = oraclize.getPrice(datasource, gaslimit);
1608         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1609         bytes memory args = ba2cbor(argN);
1610         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1611     }
1612     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1613         bytes[] memory dynargs = new bytes[](1);
1614         dynargs[0] = args[0];
1615         return oraclize_query(datasource, dynargs);
1616     }
1617     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1618         bytes[] memory dynargs = new bytes[](1);
1619         dynargs[0] = args[0];
1620         return oraclize_query(timestamp, datasource, dynargs);
1621     }
1622     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1623         bytes[] memory dynargs = new bytes[](1);
1624         dynargs[0] = args[0];
1625         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1626     }
1627     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1628         bytes[] memory dynargs = new bytes[](1);
1629         dynargs[0] = args[0];
1630         return oraclize_query(datasource, dynargs, gaslimit);
1631     }
1632 
1633     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1634         bytes[] memory dynargs = new bytes[](2);
1635         dynargs[0] = args[0];
1636         dynargs[1] = args[1];
1637         return oraclize_query(datasource, dynargs);
1638     }
1639     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1640         bytes[] memory dynargs = new bytes[](2);
1641         dynargs[0] = args[0];
1642         dynargs[1] = args[1];
1643         return oraclize_query(timestamp, datasource, dynargs);
1644     }
1645     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1646         bytes[] memory dynargs = new bytes[](2);
1647         dynargs[0] = args[0];
1648         dynargs[1] = args[1];
1649         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1650     }
1651     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1652         bytes[] memory dynargs = new bytes[](2);
1653         dynargs[0] = args[0];
1654         dynargs[1] = args[1];
1655         return oraclize_query(datasource, dynargs, gaslimit);
1656     }
1657     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1658         bytes[] memory dynargs = new bytes[](3);
1659         dynargs[0] = args[0];
1660         dynargs[1] = args[1];
1661         dynargs[2] = args[2];
1662         return oraclize_query(datasource, dynargs);
1663     }
1664     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1665         bytes[] memory dynargs = new bytes[](3);
1666         dynargs[0] = args[0];
1667         dynargs[1] = args[1];
1668         dynargs[2] = args[2];
1669         return oraclize_query(timestamp, datasource, dynargs);
1670     }
1671     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1672         bytes[] memory dynargs = new bytes[](3);
1673         dynargs[0] = args[0];
1674         dynargs[1] = args[1];
1675         dynargs[2] = args[2];
1676         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1677     }
1678     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1679         bytes[] memory dynargs = new bytes[](3);
1680         dynargs[0] = args[0];
1681         dynargs[1] = args[1];
1682         dynargs[2] = args[2];
1683         return oraclize_query(datasource, dynargs, gaslimit);
1684     }
1685 
1686     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1687         bytes[] memory dynargs = new bytes[](4);
1688         dynargs[0] = args[0];
1689         dynargs[1] = args[1];
1690         dynargs[2] = args[2];
1691         dynargs[3] = args[3];
1692         return oraclize_query(datasource, dynargs);
1693     }
1694     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1695         bytes[] memory dynargs = new bytes[](4);
1696         dynargs[0] = args[0];
1697         dynargs[1] = args[1];
1698         dynargs[2] = args[2];
1699         dynargs[3] = args[3];
1700         return oraclize_query(timestamp, datasource, dynargs);
1701     }
1702     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1703         bytes[] memory dynargs = new bytes[](4);
1704         dynargs[0] = args[0];
1705         dynargs[1] = args[1];
1706         dynargs[2] = args[2];
1707         dynargs[3] = args[3];
1708         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1709     }
1710     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1711         bytes[] memory dynargs = new bytes[](4);
1712         dynargs[0] = args[0];
1713         dynargs[1] = args[1];
1714         dynargs[2] = args[2];
1715         dynargs[3] = args[3];
1716         return oraclize_query(datasource, dynargs, gaslimit);
1717     }
1718     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1719         bytes[] memory dynargs = new bytes[](5);
1720         dynargs[0] = args[0];
1721         dynargs[1] = args[1];
1722         dynargs[2] = args[2];
1723         dynargs[3] = args[3];
1724         dynargs[4] = args[4];
1725         return oraclize_query(datasource, dynargs);
1726     }
1727     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1728         bytes[] memory dynargs = new bytes[](5);
1729         dynargs[0] = args[0];
1730         dynargs[1] = args[1];
1731         dynargs[2] = args[2];
1732         dynargs[3] = args[3];
1733         dynargs[4] = args[4];
1734         return oraclize_query(timestamp, datasource, dynargs);
1735     }
1736     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1737         bytes[] memory dynargs = new bytes[](5);
1738         dynargs[0] = args[0];
1739         dynargs[1] = args[1];
1740         dynargs[2] = args[2];
1741         dynargs[3] = args[3];
1742         dynargs[4] = args[4];
1743         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1744     }
1745     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1746         bytes[] memory dynargs = new bytes[](5);
1747         dynargs[0] = args[0];
1748         dynargs[1] = args[1];
1749         dynargs[2] = args[2];
1750         dynargs[3] = args[3];
1751         dynargs[4] = args[4];
1752         return oraclize_query(datasource, dynargs, gaslimit);
1753     }
1754 
1755     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1756         return oraclize.cbAddress();
1757     }
1758     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1759         return oraclize.setProofType(proofP);
1760     }
1761     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1762         return oraclize.setCustomGasPrice(gasPrice);
1763     }
1764     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1765         return oraclize.setConfig(config);
1766     }
1767 
1768     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1769         return oraclize.randomDS_getSessionPubKeyHash();
1770     }
1771 
1772     function getCodeSize(address _addr) constant internal returns(uint _size) {
1773         assembly {
1774             _size := extcodesize(_addr)
1775         }
1776     }
1777 
1778     function parseAddr(string _a) internal returns (address){
1779         bytes memory tmp = bytes(_a);
1780         uint160 iaddr = 0;
1781         uint160 b1;
1782         uint160 b2;
1783         for (uint i=2; i<2+2*20; i+=2){
1784             iaddr *= 256;
1785             b1 = uint160(tmp[i]);
1786             b2 = uint160(tmp[i+1]);
1787             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1788             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1789             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1790             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1791             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1792             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1793             iaddr += (b1*16+b2);
1794         }
1795         return address(iaddr);
1796     }
1797 
1798     function strCompare(string _a, string _b) internal returns (int) {
1799         bytes memory a = bytes(_a);
1800         bytes memory b = bytes(_b);
1801         uint minLength = a.length;
1802         if (b.length < minLength) minLength = b.length;
1803         for (uint i = 0; i < minLength; i ++)
1804             if (a[i] < b[i])
1805                 return -1;
1806             else if (a[i] > b[i])
1807                 return 1;
1808         if (a.length < b.length)
1809             return -1;
1810         else if (a.length > b.length)
1811             return 1;
1812         else
1813             return 0;
1814     }
1815 
1816     function indexOf(string _haystack, string _needle) internal returns (int) {
1817         bytes memory h = bytes(_haystack);
1818         bytes memory n = bytes(_needle);
1819         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1820             return -1;
1821         else if(h.length > (2**128 -1))
1822             return -1;
1823         else
1824         {
1825             uint subindex = 0;
1826             for (uint i = 0; i < h.length; i ++)
1827             {
1828                 if (h[i] == n[0])
1829                 {
1830                     subindex = 1;
1831                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1832                     {
1833                         subindex++;
1834                     }
1835                     if(subindex == n.length)
1836                         return int(i);
1837                 }
1838             }
1839             return -1;
1840         }
1841     }
1842 
1843     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1844         bytes memory _ba = bytes(_a);
1845         bytes memory _bb = bytes(_b);
1846         bytes memory _bc = bytes(_c);
1847         bytes memory _bd = bytes(_d);
1848         bytes memory _be = bytes(_e);
1849         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1850         bytes memory babcde = bytes(abcde);
1851         uint k = 0;
1852         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1853         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1854         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1855         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1856         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1857         return string(babcde);
1858     }
1859 
1860     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1861         return strConcat(_a, _b, _c, _d, "");
1862     }
1863 
1864     function strConcat(string _a, string _b, string _c) internal returns (string) {
1865         return strConcat(_a, _b, _c, "", "");
1866     }
1867 
1868     function strConcat(string _a, string _b) internal returns (string) {
1869         return strConcat(_a, _b, "", "", "");
1870     }
1871 
1872     // parseInt
1873     function parseInt(string _a) internal returns (uint) {
1874         return parseInt(_a, 0);
1875     }
1876 
1877     // parseInt(parseFloat*10^_b)
1878     function parseInt(string _a, uint _b) internal returns (uint) {
1879         bytes memory bresult = bytes(_a);
1880         uint mint = 0;
1881         bool decimals = false;
1882         for (uint i=0; i<bresult.length; i++){
1883             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1884                 if (decimals){
1885                    if (_b == 0) break;
1886                     else _b--;
1887                 }
1888                 mint *= 10;
1889                 mint += uint(bresult[i]) - 48;
1890             } else if (bresult[i] == 46) decimals = true;
1891         }
1892         if (_b > 0) mint *= 10**_b;
1893         return mint;
1894     }
1895 
1896     function uint2str(uint i) internal returns (string){
1897         if (i == 0) return "0";
1898         uint j = i;
1899         uint len;
1900         while (j != 0){
1901             len++;
1902             j /= 10;
1903         }
1904         bytes memory bstr = new bytes(len);
1905         uint k = len - 1;
1906         while (i != 0){
1907             bstr[k--] = byte(48 + i % 10);
1908             i /= 10;
1909         }
1910         return string(bstr);
1911     }
1912 
1913     using CBOR for Buffer.buffer;
1914     function stra2cbor(string[] arr) internal constant returns (bytes) {
1915         Buffer.buffer memory buf;
1916         Buffer.init(buf, 1024);
1917         buf.startArray();
1918         for (uint i = 0; i < arr.length; i++) {
1919             buf.encodeString(arr[i]);
1920         }
1921         buf.endSequence();
1922         return buf.buf;
1923     }
1924 
1925     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
1926         Buffer.buffer memory buf;
1927         Buffer.init(buf, 1024);
1928         buf.startArray();
1929         for (uint i = 0; i < arr.length; i++) {
1930             buf.encodeBytes(arr[i]);
1931         }
1932         buf.endSequence();
1933         return buf.buf;
1934     }
1935 
1936     string oraclize_network_name;
1937     function oraclize_setNetworkName(string _network_name) internal {
1938         oraclize_network_name = _network_name;
1939     }
1940 
1941     function oraclize_getNetworkName() internal returns (string) {
1942         return oraclize_network_name;
1943     }
1944 
1945     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1946         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1947 	// Convert from seconds to ledger timer ticks
1948         _delay *= 10;
1949         bytes memory nbytes = new bytes(1);
1950         nbytes[0] = byte(_nbytes);
1951         bytes memory unonce = new bytes(32);
1952         bytes memory sessionKeyHash = new bytes(32);
1953         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1954         assembly {
1955             mstore(unonce, 0x20)
1956             // the following variables can be relaxed
1957             // check relaxed random contract under ethereum-examples repo
1958             // for an idea on how to override and replace comit hash vars
1959             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1960             mstore(sessionKeyHash, 0x20)
1961             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1962         }
1963         bytes memory delay = new bytes(32);
1964         assembly {
1965             mstore(add(delay, 0x20), _delay)
1966         }
1967 
1968         bytes memory delay_bytes8 = new bytes(8);
1969         copyBytes(delay, 24, 8, delay_bytes8, 0);
1970 
1971         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1972         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1973 
1974         bytes memory delay_bytes8_left = new bytes(8);
1975 
1976         assembly {
1977             let x := mload(add(delay_bytes8, 0x20))
1978             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1979             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1980             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1981             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1982             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1983             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1984             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1985             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1986 
1987         }
1988 
1989         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1990         return queryId;
1991     }
1992 
1993     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1994         oraclize_randomDS_args[queryId] = commitment;
1995     }
1996 
1997     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1998     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1999 
2000     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
2001         bool sigok;
2002         address signer;
2003 
2004         bytes32 sigr;
2005         bytes32 sigs;
2006 
2007         bytes memory sigr_ = new bytes(32);
2008         uint offset = 4+(uint(dersig[3]) - 0x20);
2009         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
2010         bytes memory sigs_ = new bytes(32);
2011         offset += 32 + 2;
2012         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
2013 
2014         assembly {
2015             sigr := mload(add(sigr_, 32))
2016             sigs := mload(add(sigs_, 32))
2017         }
2018 
2019 
2020         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
2021         if (address(sha3(pubkey)) == signer) return true;
2022         else {
2023             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
2024             return (address(sha3(pubkey)) == signer);
2025         }
2026     }
2027 
2028     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
2029         bool sigok;
2030 
2031         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
2032         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
2033         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
2034 
2035         bytes memory appkey1_pubkey = new bytes(64);
2036         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
2037 
2038         bytes memory tosign2 = new bytes(1+65+32);
2039         tosign2[0] = 1; //role
2040         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
2041         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
2042         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
2043         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
2044 
2045         if (sigok == false) return false;
2046 
2047 
2048         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
2049         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
2050 
2051         bytes memory tosign3 = new bytes(1+65);
2052         tosign3[0] = 0xFE;
2053         copyBytes(proof, 3, 65, tosign3, 1);
2054 
2055         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
2056         copyBytes(proof, 3+65, sig3.length, sig3, 0);
2057 
2058         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
2059 
2060         return sigok;
2061     }
2062 
2063     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
2064         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
2065         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
2066 
2067         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
2068         if (proofVerified == false) throw;
2069 
2070         _;
2071     }
2072 
2073     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
2074         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
2075         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
2076 
2077         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
2078         if (proofVerified == false) return 2;
2079 
2080         return 0;
2081     }
2082 
2083     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
2084         bool match_ = true;
2085 
2086 	if (prefix.length != n_random_bytes) throw;
2087 
2088         for (uint256 i=0; i< n_random_bytes; i++) {
2089             if (content[i] != prefix[i]) match_ = false;
2090         }
2091 
2092         return match_;
2093     }
2094 
2095     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
2096 
2097         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
2098         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
2099         bytes memory keyhash = new bytes(32);
2100         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
2101         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
2102 
2103         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
2104         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
2105 
2106         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
2107         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
2108 
2109         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
2110         // This is to verify that the computed args match with the ones specified in the query.
2111         bytes memory commitmentSlice1 = new bytes(8+1+32);
2112         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
2113 
2114         bytes memory sessionPubkey = new bytes(64);
2115         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
2116         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
2117 
2118         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
2119         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
2120             delete oraclize_randomDS_args[queryId];
2121         } else return false;
2122 
2123 
2124         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
2125         bytes memory tosign1 = new bytes(32+8+1+32);
2126         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
2127         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
2128 
2129         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
2130         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
2131             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
2132         }
2133 
2134         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
2135     }
2136 
2137 
2138     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2139     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
2140         uint minLength = length + toOffset;
2141 
2142         if (to.length < minLength) {
2143             // Buffer too small
2144             throw; // Should be a better way?
2145         }
2146 
2147         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
2148         uint i = 32 + fromOffset;
2149         uint j = 32 + toOffset;
2150 
2151         while (i < (32 + fromOffset + length)) {
2152             assembly {
2153                 let tmp := mload(add(from, i))
2154                 mstore(add(to, j), tmp)
2155             }
2156             i += 32;
2157             j += 32;
2158         }
2159 
2160         return to;
2161     }
2162 
2163     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2164     // Duplicate Solidity's ecrecover, but catching the CALL return value
2165     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
2166         // We do our own memory management here. Solidity uses memory offset
2167         // 0x40 to store the current end of memory. We write past it (as
2168         // writes are memory extensions), but don't update the offset so
2169         // Solidity will reuse it. The memory used here is only needed for
2170         // this context.
2171 
2172         // FIXME: inline assembly can't access return values
2173         bool ret;
2174         address addr;
2175 
2176         assembly {
2177             let size := mload(0x40)
2178             mstore(size, hash)
2179             mstore(add(size, 32), v)
2180             mstore(add(size, 64), r)
2181             mstore(add(size, 96), s)
2182 
2183             // NOTE: we can reuse the request memory because we deal with
2184             //       the return code
2185             ret := call(3000, 1, 0, size, 128, size, 32)
2186             addr := mload(size)
2187         }
2188 
2189         return (ret, addr);
2190     }
2191 
2192     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2193     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
2194         bytes32 r;
2195         bytes32 s;
2196         uint8 v;
2197 
2198         if (sig.length != 65)
2199           return (false, 0);
2200 
2201         // The signature format is a compact form of:
2202         //   {bytes32 r}{bytes32 s}{uint8 v}
2203         // Compact means, uint8 is not padded to 32 bytes.
2204         assembly {
2205             r := mload(add(sig, 32))
2206             s := mload(add(sig, 64))
2207 
2208             // Here we are loading the last 32 bytes. We exploit the fact that
2209             // 'mload' will pad with zeroes if we overread.
2210             // There is no 'mload8' to do this, but that would be nicer.
2211             v := byte(0, mload(add(sig, 96)))
2212 
2213             // Alternative solution:
2214             // 'byte' is not working due to the Solidity parser, so lets
2215             // use the second best option, 'and'
2216             // v := and(mload(add(sig, 65)), 255)
2217         }
2218 
2219         // albeit non-transactional signatures are not specified by the YP, one would expect it
2220         // to match the YP range of [27, 28]
2221         //
2222         // geth uses [0, 1] and some clients have followed. This might change, see:
2223         //  https://github.com/ethereum/go-ethereum/issues/2053
2224         if (v < 27)
2225           v += 27;
2226 
2227         if (v != 27 && v != 28)
2228             return (false, 0);
2229 
2230         return safer_ecrecover(hash, v, r, s);
2231     }
2232 
2233 }
2234 
2235 contract Ethertify is usingOraclize {
2236   EntityLib.Data ed;
2237   CertsLib.Data cd;
2238 
2239   /** 
2240    * Creates a contract
2241    */
2242   function Ethertify() public {
2243     ed.nEntities = 0;
2244     cd.nCerts = 0;
2245   }
2246 
2247   // MODIFIERS
2248 
2249  /**
2250    * True if the method is executed by oraclize. False otherwise.
2251    */
2252   modifier isOraclize() {
2253     require (msg.sender == oraclize_cbAddress());
2254     _;
2255   }
2256 
2257   // ENTITY METHODS
2258 
2259   /**
2260    * Creates a new entity
2261    * @param entityHash {string} - The ipfs multihash address of the entity information in json format
2262    * @param urlHash {bytes32} - The sha256 hash of the URL of the entityç
2263    * @param expirationDate {uint} - The expiration date of the current entity
2264    * @param renewalPeriod {uint} - The time period which will be added to the current date or expiration date when a renewal is requested
2265    * @return {uint} The id of the created entity
2266    */
2267   function createSigningEntity(string entityHash, bytes32 urlHash, uint expirationDate, uint renewalPeriod) public returns (uint) {
2268     uint entityId = ++ed.nEntities;
2269     EntityLib.create(ed, entityId, entityHash, urlHash, expirationDate, renewalPeriod);      
2270     return entityId;
2271   }
2272 
2273   /**
2274    * Sets a new expiration date for the entity. It will trigger an entity validation through the oracle, so it must be paid
2275    * @param entityId {uint} - The id of the entity
2276    * @param expirationDate {uint} - The new expiration date of the entity
2277    * @param url {string} - The URL of the entity (for validation through the oracle)
2278    * @param oraclizeGas {uint} - The maximum gas to use during the oraclize callback execution. Will default to 90000 if not provided.
2279    * @param oraclizeGasPrice {uint} - The gas price to use during the oraclize callback invocation.
2280    * @return {bytes32} - The id of the oraclize query
2281    */
2282   function setExpiration(uint entityId, uint expirationDate, string url, uint oraclizeGas, uint oraclizeGasPrice) public payable returns (bytes32) {
2283     EntityLib.setExpiration(ed, entityId, expirationDate);
2284     return validateSigningEntity(entityId, url, oraclizeGas, oraclizeGasPrice);
2285   }
2286   
2287   /**
2288    * Sets a new renewal interval
2289    * @param entityId {uint} - The id of the entity
2290    * @param renewalPeriod {uint} - The new renewal interval (in seconds)
2291    */
2292   function setRenewalPeriod (uint entityId, uint renewalPeriod) public {
2293     EntityLib.setRenewalPeriod(ed, entityId, renewalPeriod);
2294   }
2295 
2296 
2297   /**
2298    * Requests the validation of a signing entity
2299    * @param entityId {uint} - The id of the entity to validate
2300    * @param url {string} - The URL of the entity
2301    * @param oraclizeGas {uint} - The maximum gas to use during the oraclize callback execution. Will default to 90000 if not provided.
2302    * @param oraclizeGasPrice {uint} - The gas price to use during the oraclize callback invocation.
2303    * @return {bytes32} - The id of the oraclize query
2304    */
2305   function validateSigningEntity(uint entityId, string url, uint oraclizeGas, uint oraclizeGasPrice) public payable returns (bytes32) {
2306     uint maxGas = oraclizeGas == 0 ? 88000 : oraclizeGas; // 67000 gas from the process validation callback + 21000 for the transfer
2307     
2308     if (EntityLib.canValidateSigningEntity(ed, entityId, url)) {
2309       oraclize_setCustomGasPrice(oraclizeGasPrice);
2310       uint queryCost = oraclize_getPrice("URL", maxGas);
2311       if (queryCost > msg.value) {
2312         OraclizeNotEnoughFunds(entityId, queryCost);
2313         return 0;
2314       }
2315 
2316       string memory query = strConcat("html(", url, ").xpath(/html/head/meta[@name='ethertify-entity']/@content)");
2317       bytes32 queryId = oraclize_query("URL", query, maxGas);
2318       ed.entityIds[queryId] = entityId;
2319       EntityLib.setOraclizeQueryId(ed, entityId, queryId);
2320       return queryId;
2321     }
2322   }
2323 
2324   /**
2325    * Updates entity data
2326    * @param entityId {uint} - The id of the entity
2327    * @param entityHash {string} - The ipfs multihash address of the entity information in json format
2328    * @param urlHash {bytes32} - The sha256 hash of the URL of the entity
2329    * @param oraclizeGas {uint} - The maximum gas to use during the oraclize callback execution. Will default to 90000 if not provided.
2330    * @param oraclizeGasPrice {uint} - The gas price to use during the oraclize callback invocation.
2331    * @param url {string} - The url used during the validation (after setting the data)
2332    */
2333   function updateEntityData(uint entityId, string entityHash, bytes32 urlHash, string url, uint oraclizeGas, uint oraclizeGasPrice) public payable {
2334     EntityLib.updateEntityData(ed, entityId, entityHash, urlHash);
2335     validateSigningEntity(entityId, url, oraclizeGas, oraclizeGasPrice);
2336   }
2337 
2338   /**
2339    * Update the signer data in the requestes entities
2340    * @param entityIds {array} - The ids of the entities to update
2341    * @param signerDataHash {string} - The ipfs multihash of the new signer data
2342    */
2343   function updateSignerData(uint[] entityIds, string signerDataHash) public {
2344     EntityLib.updateSignerData(ed, entityIds, signerDataHash);
2345   }
2346 
2347   /**
2348    * Accepts a new signer data update in the entity
2349    * @param entityId {uint} - The id of the entity
2350    * @param signerAddress {address} - The address of the signer update to be accepted
2351    * @param signerDataHash {uint} - The IPFS multihash address of signer information in json format to be accepted
2352    */
2353   function acceptSignerUpdate(uint entityId, address signerAddress, string signerDataHash) public {
2354     EntityLib.acceptSignerUpdate(ed, entityId, signerAddress, signerDataHash);
2355   }
2356 
2357   /**
2358    * Requests the renewal of a signing entity
2359    * @param entityId {uint} - The id of the entity to validate
2360    * @param url {string} - The URL of the entity
2361    * @param oraclizeGas {uint} - The maximum gas to use during the oraclize callback execution. Will default to 90000 if not provided.
2362    * @param oraclizeGasPrice {uint} - The gas price to use during the oraclize callback invocation.
2363    * @return {bytes32} - The id of the oraclize query
2364    */
2365   function requestRenewal(uint entityId, string url, uint oraclizeGas, uint oraclizeGasPrice) public payable returns (bytes32) {
2366     if (EntityLib.canRenew(ed, entityId, url)) {
2367       ed.entities[entityId].status = 4;
2368       return validateSigningEntity(entityId, url, oraclizeGas, oraclizeGasPrice); 
2369     }
2370   }
2371 
2372   /**
2373    * Close an entity. This status will not allow further operations on the entity.
2374    * @param entityId {uint} - The id of the entity
2375    */
2376   function closeEntity(uint entityId) public {
2377     EntityLib.closeEntity(ed, entityId);
2378   }
2379   
2380   /**
2381    * Executes automatically when oraclize query is finished
2382    * @param queryId {bytes32} - The id of the oraclize query (returned by the call to oraclize_query method)
2383    * @param result {string} - The result of the query
2384    */
2385   function __callback(bytes32 queryId, string result) isOraclize() public {
2386     EntityLib.processValidation(ed, queryId, result);
2387   }
2388 
2389   /**
2390    * Registers a new signer in an entity
2391    * @param entityId {uint} - The id of the entity
2392    * @param signerAddress {address} - The address of the signer to be registered
2393    * @param signerDataHash {uint} - The IPFS multihash address of signer information in json format
2394    */
2395   function registerSigner(uint entityId, address signerAddress, string signerDataHash) public {
2396     EntityLib.registerSigner(ed, entityId, signerAddress, signerDataHash);
2397   }
2398 
2399   /**
2400    * Removes a signer from an entity
2401    * @param entityId {uint} - The id of the entity
2402    * @param signerAddress {address} - The address of the signer to be removed
2403    */
2404   function removeSigner(uint entityId, address signerAddress) public {
2405     EntityLib.removeSigner(ed, entityId, signerAddress);
2406   }
2407 
2408   /**
2409    * Leave the specified entity (remove signer if found)
2410    * @param entityId {uint} - The id of the entity
2411    */
2412   function leaveEntity(uint entityId) public {
2413     EntityLib.leaveEntity(ed, entityId);
2414   }
2415 
2416   /**
2417    * Confirms signer registration
2418    * @param entityId {uint} - The id of the entity
2419    * @param signerDataHash {string} - The ipfs data hash of the signer to confirm
2420    */
2421   function confirmSignerRegistration(uint entityId, string signerDataHash) public {
2422     EntityLib.confirmSignerRegistration(ed, entityId, signerDataHash);
2423   }
2424 
2425   // CERTIFICATE METHODS
2426 
2427   /**
2428    * Creates a new POE certificate
2429    * @param dataHash {bytes32} - The hash of the certified data
2430    * @param certHash {bytes32} - The sha256 hash of the json certificate
2431    * @param ipfsDataHash {string} - The ipfs multihash address of the data (0x00 means unkwon)
2432    * @param ipfsCertHash {string} - The ipfs multihash address of the certificate in json format (0x00 means unkwon)
2433    * @return The id of the created certificate     
2434    */
2435   function createPOECertificate(bytes32 dataHash, bytes32 certHash, string ipfsDataHash, string ipfsCertHash) public returns (uint) {
2436     return CertsLib.createPOECertificate(cd, dataHash, certHash, ipfsDataHash, ipfsCertHash);
2437   }
2438   
2439   /**
2440    * Creates a new certificate (with known owner)
2441    * @param dataHash {bytes32} - The hash of the certified data
2442    * @param certHash {bytes32} - The sha256 hash of the json certificate
2443    * @param ipfsDataHash {string} - The ipfs multihash address of the data (0x00 means unkwon)
2444    * @param ipfsCertHash {string} - The ipfs multihash address of the certificate in json format (0x00 means unkwon)
2445    * @param entityId {uint} - The entity id which issues the certificate (0 if not issued by an entity)
2446    * @return {uint} The id of the created certificate     
2447    */
2448   function createCertificate(bytes32 dataHash, bytes32 certHash, string ipfsDataHash, string ipfsCertHash, uint entityId) public returns (uint) {
2449     return CertsLib.createCertificate(cd, ed, dataHash, certHash, ipfsDataHash, ipfsCertHash, entityId);
2450   }
2451 
2452   /**
2453    * Request transfering the ownership of a certificate.
2454    * The owner can be a peer or an entity (never both), so only one of newOwner or newEntity must be different than 0.
2455    * If the specified certificateId belongs to an entity, the msg.sender must be a valid signer for the entity. Otherwise the msg.sender must be the current owner.
2456    * @param certificateId {uint} - The id of the certificate to transfer
2457    * @param newOwner {address} - The address of the new owner
2458    */
2459   function requestCertificateTransferToPeer(uint certificateId, address newOwner) public {
2460     return CertsLib.requestCertificateTransferToPeer(cd, ed, certificateId, newOwner);
2461   }
2462 
2463   /**
2464    * Request transfering the ownership of a certificate.
2465    * The owner can be a peer or an entity (never both), so only one of newOwner or newEntity must be different than 0.
2466    * If the specified certificateId belongs to an entity, the msg.sender must be a valid signer for the entity. Otherwise the msg.sender must be the current owner.
2467    * @param certificateId {uint} - The id of the certificate to transfer
2468    * @param newEntityId {uint} - The id of the new entity
2469    */
2470   function requestCertificateTransferToEntity(uint certificateId, uint newEntityId) public {
2471     return CertsLib.requestCertificateTransferToEntity(cd, ed, certificateId, newEntityId);
2472   }
2473 
2474   /**
2475    * Accept the certificate transfer
2476    * @param certificateId {uint} - The id of the certificate to transfer
2477    */
2478   function acceptCertificateTransfer(uint certificateId) public {
2479     return CertsLib.acceptCertificateTransfer(cd, ed, certificateId);
2480   }
2481 
2482   /**
2483    * Cancel the certificate transfer
2484    * @param certificateId {uint} - The id of the certificate to transfer
2485    */
2486   function cancelCertificateTransfer(uint certificateId) public {
2487     return CertsLib.cancelCertificateTransfer(cd, ed, certificateId);
2488   }
2489 
2490   /**
2491    * Updates ipfs multihashes of a particular certificate
2492    * @param certId {uint} - The id of the certificate
2493    * @param ipfsDataHash {string} - The ipfs multihash address of the data (0x00 means unkwon)
2494    * @param ipfsCertHash {string} - The ipfs multihash address of the certificate in json format (0x00 means unkwon)
2495    */
2496   function setIPFSData(uint certId, string ipfsDataHash, string ipfsCertHash) public {
2497     CertsLib.setIPFSData(cd, certId, ipfsDataHash, ipfsCertHash);
2498   }
2499   
2500   // SIGNATURE METHODS
2501 
2502   /**
2503    * Requests the signature for a certificate to an entity
2504    * @param certificateId {uint} - The id of the certificate
2505    * @param entityId {uint} - The id of the entity
2506    */
2507   function requestSignatureToEntity(uint certificateId, uint entityId) public {
2508     SignLib.requestSignatureToEntity(ed, cd, certificateId, entityId);
2509   }
2510 
2511   /**
2512    * Requests the signature for a certificate to a peer
2513    * @param certificateId {uint} - The id of the certificate
2514    * @param peer {address} - The address of the peer
2515    */
2516   function requestSignatureToPeer(uint certificateId, address peer) public {
2517     SignLib.requestSignatureToPeer(ed, cd, certificateId, peer);
2518   }
2519 
2520   /**
2521    * Entity signs a certificate with pending request
2522    * @param entityId {uint} - The id of the entity
2523    * @param certificateId {uint} - The id of the certificate
2524    * @param expiration {uint} - The expiration time of the signature (in seconds)
2525    * @param purpose {bytes32} - The sha-256 hash of the purpose data
2526    */
2527   function signCertificateAsEntity(uint entityId, uint certificateId, uint expiration, bytes32 purpose) public {
2528     SignLib.signCertificateAsEntity(ed, cd, entityId, certificateId, expiration, purpose);
2529   }
2530 
2531   /**
2532    * Peer signs a certificate with pending request
2533    * @param certificateId {uint} - The id of the certificate
2534    * @param expiration {uint} - The expiration time of the signature (in seconds)
2535    * @param purpose {bytes32} - The sha-256 hash of the purpose data
2536    */
2537   function signCertificateAsPeer(uint certificateId, uint expiration, bytes32 purpose) public {
2538     SignLib.signCertificateAsPeer(cd, certificateId, expiration, purpose);
2539   }
2540 
2541   // CUSTOM GETTERS
2542   /**
2543    * Get default info from internal contract
2544    */
2545   function internalState() constant public returns (uint numEntities, uint numCertificates) {
2546     return (
2547       ed.nEntities,
2548       cd.nCerts
2549     );
2550   }
2551 
2552   /**
2553    * Gets the entity data by id
2554    * @param entityId {uint} - The id of the entity
2555    * @return {object} The data of a signing entity
2556    */
2557   function getSigningEntityInfo(uint entityId) constant public returns (address owner, string dataHash, uint status, bytes32 urlHash, uint expiration, uint renewalPeriod, uint numSigners) {
2558     return (
2559       ed.entities[entityId].owner,
2560       ed.entities[entityId].dataHash,
2561       ed.entities[entityId].status,
2562       ed.entities[entityId].urlHash,
2563       ed.entities[entityId].expiration,
2564       ed.entities[entityId].renewalPeriod,
2565       ed.entities[entityId].signersArr.length
2566     );
2567   }
2568 
2569   /**
2570   * Get the last oraclize query Id of the specified entity
2571   * @param entityId {uint} - The id of the entity
2572   * @return {bytes32} The last oraclize query id of the entity
2573   */
2574   function getOraclizeQuery(uint entityId) constant public returns (bytes32 oraclizeQueryId) {
2575     return ed.entities[entityId].oraclizeQueryId;
2576   }
2577 
2578   /**
2579    * Gets the signers data from an entity (by address or index)
2580    * @param entityId {uint} - The id of the entity
2581    * @param signerAddress {address} - The address of the signer (if known)
2582    * @param index {uint} - The index of the signer
2583    * @return {object} The signer details
2584    */  
2585   function getSignerData(uint entityId, address signerAddress, uint index) constant public returns (address signer, uint status, string ipfsMultiHash) {
2586     uint s = 0;
2587     string memory h = "";
2588     
2589     if (signerAddress != 0) {      
2590       s = ed.entities[entityId].signers[signerAddress].status;
2591       h = ed.entities[entityId].signers[signerAddress].signerDataHash;
2592     } else if (signerAddress == 0 && index < ed.entities[entityId].signersArr.length) {
2593       signerAddress = ed.entities[entityId].signersArr[index];
2594       s = ed.entities[entityId].signers[signerAddress].status;
2595       h = ed.entities[entityId].signers[signerAddress].signerDataHash;
2596     }
2597 
2598     return (signerAddress, s, h);
2599   }
2600 
2601   /**
2602    * Gets the certificate data by id
2603    * @param certificateId {uint} - The id of the certificate
2604    * @return {object} The data of a certificate
2605    */
2606   function getCertificateInfo(uint certificateId) constant public returns (address owner, uint entityId, bytes32 certHash, string ipfsCertHash, bytes32 dataHash, string ipfsDataHash, uint numEntitySignatures, uint numPeerSignatures, address newOwnerTransferRequest, uint newEntityTransferRequest) {
2607     CertsLib.CertData storage cert = cd.certificates[certificateId];
2608     CertsLib.TransferData storage req = cd.transferRequests[certificateId];
2609     return (
2610       cert.owner,
2611       cert.entityId,
2612       cert.certHash,
2613       cert.ipfsCertHash,
2614       cert.dataHash,
2615       cert.ipfsDataHash,
2616       cert.entitiesArr.length,
2617       cert.signaturesArr.length,
2618       req.newOwner,
2619       req.newEntityId
2620     );
2621   }
2622 
2623   /**
2624    * Gets the entity signature info from a certificate and signing entity
2625    * @param certificateId {uint} - The id of the certificate
2626    * @param entityId {uint} - The id of the entity
2627    * @param entityIndex {uint} - The index of the entity in the array
2628    * @return {uint, uint} The status/purpose and expiration date
2629    */
2630   function getEntitySignatureInfoFromCertificate(uint certificateId, uint entityId, uint entityIndex) constant public returns (uint id, bytes32 status, uint expiration) {
2631     bytes32 s = 0x0;
2632     uint e = 0;
2633     if (entityId != 0 ) {
2634       s = cd.certificates[certificateId].entities[entityId].status;
2635       e = cd.certificates[certificateId].entities[entityId].exp;
2636     } else if (entityId == 0) {
2637       entityId = cd.certificates[certificateId].entitiesArr[entityIndex];
2638       s = cd.certificates[certificateId].entities[entityId].status;
2639       e = cd.certificates[certificateId].entities[entityId].exp;
2640     } else {
2641       entityId = 0;
2642     }   
2643     return (entityId, s, e);
2644   }
2645 
2646     /**
2647    * Gets the peer signature info from a certificate and signing entity
2648    * @param certificateId {uint} - The id of the certificate
2649    * @param peerAddress {address} - If the address is supplied the info is retrieved from the peer
2650    * @param peerIndex {uint} - The index of the peer to retrieve data from
2651    * @return {uint, uint} The status/purpose and expiration date
2652    */
2653   function getPeerSignatureInfoFromCertificate(uint certificateId, address peerAddress, uint peerIndex) constant public returns (address addr, bytes32 status, uint expiration) {
2654     bytes32 s = 0x0;
2655     uint e = 0;
2656     if (peerAddress != 0) {
2657       s = cd.certificates[certificateId].signatures[peerAddress].status;
2658       e = cd.certificates[certificateId].signatures[peerAddress].exp;
2659     } else if (peerAddress == 0) {
2660       peerAddress = cd.certificates[certificateId].signaturesArr[peerIndex];
2661       s = cd.certificates[certificateId].signatures[peerAddress].status;
2662       e = cd.certificates[certificateId].signatures[peerAddress].exp;
2663     }
2664     return (peerAddress, s, e);
2665   }
2666 
2667   // EVENTS  
2668   event EntityCreated(uint indexed entityId);
2669   event EntityValidated(uint indexed entityId);
2670   event EntityDataUpdated(uint indexed entityId);
2671   event EntityInvalid(uint indexed entityId);
2672   event SignerAdded(uint indexed entityId, address indexed signerAddress);
2673   event SignerDataUpdated(uint[] entities, address indexed signerAddress);
2674   event SignerUpdateAccepted(uint indexed entityId, address indexed signerAddress);
2675   event SignerRemoved(uint indexed entityId, address signerAddress);
2676   event EntityClosed(uint indexed entityId);
2677   event SignerConfirmed(uint indexed entityId, address signerAddress);
2678   event EntityExpirationSet(uint indexed entityId);
2679   event EntityRenewalSet(uint indexed entityId);
2680 
2681   event POECertificate(uint indexed certificateId);
2682   event Certificate(uint indexed certificateId);
2683   event CertificateTransferRequestedToPeer(uint indexed certificateId, address newOwner);
2684   event CertificateTransferRequestedToEntity(uint indexed certificateId, uint newEntityId);
2685   event CertificateTransferAccepted(uint indexed certificateId, address newOwner, uint newEntityId);
2686   event CertificateTransferCancelled(uint indexed certificateId);
2687 
2688   event EntitySignatureRequested(uint indexed certificateId, uint indexed entityId);
2689   event PeerSignatureRequested(uint indexed certificateId, address indexed signerAddress);
2690   event CertificateSignedByEntity(uint indexed certificateId, uint indexed entityId, address indexed signerAddress);
2691   event CertificateSignedByPeer(uint indexed certificateId, address indexed signerAddress);
2692 
2693   event OraclizeNotEnoughFunds(uint indexed entityId, uint queryCost);
2694  }