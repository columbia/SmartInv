1 pragma solidity ^0.4.4;
2 
3 
4 /**
5  * @title AbstractBlobStore
6  * @author Jonathan Brown <jbrown@bluedroplet.com>
7  * @dev Contracts must be able to interact with blobs regardless of which BlobStore contract they are stored in, so it is necessary for there to be an abstract contract that defines an interface for BlobStore contracts.
8  */
9 contract AbstractBlobStore {
10 
11     /**
12      * @dev Creates a new blob. It is guaranteed that different users will never receive the same blobId, even before consensus has been reached. This prevents blobId sniping. Consider createWithNonce() if not calling from another contract.
13      * @param flags Packed blob settings.
14      * @param contents Contents of the blob to be stored.
15      * @return blobId Id of the blob.
16      */
17     function create(bytes4 flags, bytes contents) external returns (bytes20 blobId);
18 
19     /**
20      * @dev Creates a new blob using provided nonce. It is guaranteed that different users will never receive the same blobId, even before consensus has been reached. This prevents blobId sniping. This method is cheaper than create(), especially if multiple blobs from the same account end up in the same block. However, it is not suitable for calling from other contracts because it will throw if a unique nonce is not provided.
21      * @param flagsNonce First 4 bytes: Packed blob settings. The parameter as a whole must never have been passed to this function from the same account, or it will throw.
22      * @param contents Contents of the blob to be stored.
23      * @return blobId Id of the blob.
24      */
25     function createWithNonce(bytes32 flagsNonce, bytes contents) external returns (bytes20 blobId);
26 
27     /**
28      * @dev Create a new blob revision.
29      * @param blobId Id of the blob.
30      * @param contents Contents of the new revision.
31      * @return revisionId The new revisionId.
32      */
33     function createNewRevision(bytes20 blobId, bytes contents) external returns (uint revisionId);
34 
35     /**
36      * @dev Update a blob's latest revision.
37      * @param blobId Id of the blob.
38      * @param contents Contents that should replace the latest revision.
39      */
40     function updateLatestRevision(bytes20 blobId, bytes contents) external;
41 
42     /**
43      * @dev Retract a blob's latest revision. Revision 0 cannot be retracted.
44      * @param blobId Id of the blob.
45      */
46     function retractLatestRevision(bytes20 blobId) external;
47 
48     /**
49      * @dev Delete all a blob's revisions and replace it with a new blob.
50      * @param blobId Id of the blob.
51      * @param contents Contents that should be stored.
52      */
53     function restart(bytes20 blobId, bytes contents) external;
54 
55     /**
56      * @dev Retract a blob.
57      * @param blobId Id of the blob. This blobId can never be used again.
58      */
59     function retract(bytes20 blobId) external;
60 
61     /**
62      * @dev Enable transfer of the blob to the current user.
63      * @param blobId Id of the blob.
64      */
65     function transferEnable(bytes20 blobId) external;
66 
67     /**
68      * @dev Disable transfer of the blob to the current user.
69      * @param blobId Id of the blob.
70      */
71     function transferDisable(bytes20 blobId) external;
72 
73     /**
74      * @dev Transfer a blob to a new user.
75      * @param blobId Id of the blob.
76      * @param recipient Address of the user to transfer to blob to.
77      */
78     function transfer(bytes20 blobId, address recipient) external;
79 
80     /**
81      * @dev Disown a blob.
82      * @param blobId Id of the blob.
83      */
84     function disown(bytes20 blobId) external;
85 
86     /**
87      * @dev Set a blob as not updatable.
88      * @param blobId Id of the blob.
89      */
90     function setNotUpdatable(bytes20 blobId) external;
91 
92     /**
93      * @dev Set a blob to enforce revisions.
94      * @param blobId Id of the blob.
95      */
96     function setEnforceRevisions(bytes20 blobId) external;
97 
98     /**
99      * @dev Set a blob to not be retractable.
100      * @param blobId Id of the blob.
101      */
102     function setNotRetractable(bytes20 blobId) external;
103 
104     /**
105      * @dev Set a blob to not be transferable.
106      * @param blobId Id of the blob.
107      */
108     function setNotTransferable(bytes20 blobId) external;
109 
110     /**
111      * @dev Get the id for this BlobStore contract.
112      * @return Id of the contract.
113      */
114     function getContractId() external constant returns (bytes12);
115 
116     /**
117      * @dev Check if a blob exists.
118      * @param blobId Id of the blob.
119      * @return exists True if the blob exists.
120      */
121     function getExists(bytes20 blobId) external constant returns (bool exists);
122 
123     /**
124      * @dev Get info about a blob.
125      * @param blobId Id of the blob.
126      * @return flags Packed blob settings.
127      * @return owner Owner of the blob.
128      * @return revisionCount How many revisions the blob has.
129      * @return blockNumbers The block numbers of the revisions.
130      */
131     function getInfo(bytes20 blobId) external constant returns (bytes4 flags, address owner, uint revisionCount, uint[] blockNumbers);
132 
133     /**
134      * @dev Get all a blob's flags.
135      * @param blobId Id of the blob.
136      * @return flags Packed blob settings.
137      */
138     function getFlags(bytes20 blobId) external constant returns (bytes4 flags);
139 
140     /**
141      * @dev Determine if a blob is updatable.
142      * @param blobId Id of the blob.
143      * @return updatable True if the blob is updatable.
144      */
145     function getUpdatable(bytes20 blobId) external constant returns (bool updatable);
146 
147     /**
148      * @dev Determine if a blob enforces revisions.
149      * @param blobId Id of the blob.
150      * @return enforceRevisions True if the blob enforces revisions.
151      */
152     function getEnforceRevisions(bytes20 blobId) external constant returns (bool enforceRevisions);
153 
154     /**
155      * @dev Determine if a blob is retractable.
156      * @param blobId Id of the blob.
157      * @return retractable True if the blob is blob retractable.
158      */
159     function getRetractable(bytes20 blobId) external constant returns (bool retractable);
160 
161     /**
162      * @dev Determine if a blob is transferable.
163      * @param blobId Id of the blob.
164      * @return transferable True if the blob is transferable.
165      */
166     function getTransferable(bytes20 blobId) external constant returns (bool transferable);
167 
168     /**
169      * @dev Get the owner of a blob.
170      * @param blobId Id of the blob.
171      * @return owner Owner of the blob.
172      */
173     function getOwner(bytes20 blobId) external constant returns (address owner);
174 
175     /**
176      * @dev Get the number of revisions a blob has.
177      * @param blobId Id of the blob.
178      * @return revisionCount How many revisions the blob has.
179      */
180     function getRevisionCount(bytes20 blobId) external constant returns (uint revisionCount);
181 
182     /**
183      * @dev Get the block numbers for all of a blob's revisions.
184      * @param blobId Id of the blob.
185      * @return blockNumbers Revision block numbers.
186      */
187     function getAllRevisionBlockNumbers(bytes20 blobId) external constant returns (uint[] blockNumbers);
188 
189 }
190 
191 
192 /**
193  * @title BlobStoreFlags
194  * @author Jonathan Brown <jbrown@bluedroplet.com>
195  */
196 contract BlobStoreFlags {
197 
198     bytes4 constant UPDATABLE = 0x01;           // True if the blob is updatable. After creation can only be disabled.
199     bytes4 constant ENFORCE_REVISIONS = 0x02;   // True if the blob is enforcing revisions. After creation can only be enabled.
200     bytes4 constant RETRACTABLE = 0x04;         // True if the blob can be retracted. After creation can only be disabled.
201     bytes4 constant TRANSFERABLE = 0x08;        // True if the blob be transfered to another user or disowned. After creation can only be disabled.
202     bytes4 constant ANONYMOUS = 0x10;           // True if the blob should not have an owner.
203 
204 }
205 
206 
207 /**
208  * @title BlobStoreRegistry
209  * @author Jonathan Brown <jbrown@bluedroplet.com>
210  */
211 contract BlobStoreRegistry {
212 
213     /**
214      * @dev Mapping of contract id to contract addresses.
215      */
216     mapping (bytes12 => address) contractAddresses;
217 
218     /**
219      * @dev An AbstractBlobStore contract has been registered.
220      * @param contractId Id of the contract.
221      * @param contractAddress Address of the contract.
222      */
223     event Register(bytes12 indexed contractId, address indexed contractAddress);
224 
225     /**
226      * @dev Throw if contract is registered.
227      * @param contractId Id of the contract.
228      */
229     modifier isNotRegistered(bytes12 contractId) {
230         if (contractAddresses[contractId] != 0) {
231             throw;
232         }
233         _;
234     }
235 
236     /**
237      * @dev Throw if contract is not registered.
238      * @param contractId Id of the contract.
239      */
240     modifier isRegistered(bytes12 contractId) {
241         if (contractAddresses[contractId] == 0) {
242             throw;
243         }
244         _;
245     }
246 
247     /**
248      * @dev Register the calling BlobStore contract.
249      * @param contractId Id of the BlobStore contract.
250      */
251     function register(bytes12 contractId) external isNotRegistered(contractId) {
252         // Record the calling contract address.
253         contractAddresses[contractId] = msg.sender;
254         // Log the registration.
255         Register(contractId, msg.sender);
256     }
257 
258     /**
259      * @dev Get an AbstractBlobStore contract.
260      * @param contractId Id of the contract.
261      * @return blobStore The AbstractBlobStore contract.
262      */
263     function getBlobStore(bytes12 contractId) external constant isRegistered(contractId) returns (AbstractBlobStore blobStore) {
264         blobStore = AbstractBlobStore(contractAddresses[contractId]);
265     }
266 
267 }
268 
269 
270 /**
271  * @title BlobStore
272  * @author Jonathan Brown <jbrown@bluedroplet.com>
273  */
274 contract BlobStore is AbstractBlobStore, BlobStoreFlags {
275 
276     /**
277      * @dev Single slot structure of blob info.
278      */
279     struct BlobInfo {
280         bytes4 flags;               // Packed blob settings.
281         uint32 revisionCount;       // Number of revisions including revision 0.
282         uint32 blockNumber;         // Block number which contains revision 0.
283         address owner;              // Who owns this blob.
284     }
285 
286     /**
287      * @dev Mapping of blobId to blob info.
288      */
289     mapping (bytes20 => BlobInfo) blobInfo;
290 
291     /**
292      * @dev Mapping of blobId to mapping of packed slots of eight 32-bit block numbers.
293      */
294     mapping (bytes20 => mapping (uint => bytes32)) packedBlockNumbers;
295 
296     /**
297      * @dev Mapping of blobId to mapping of transfer recipient addresses to enabled.
298      */
299     mapping (bytes20 => mapping (address => bool)) enabledTransfers;
300 
301     /**
302      * @dev Id of this instance of BlobStore. Unique across all blockchains.
303      */
304     bytes12 contractId;
305 
306     /**
307      * @dev A blob revision has been published.
308      * @param blobId Id of the blob.
309      * @param revisionId Id of the revision (the highest at time of logging).
310      * @param contents Contents of the blob.
311      */
312     event Store(bytes20 indexed blobId, uint indexed revisionId, bytes contents);
313 
314     /**
315      * @dev A revision has been retracted.
316      * @param blobId Id of the blob.
317      * @param revisionId Id of the revision.
318      */
319     event RetractRevision(bytes20 indexed blobId, uint revisionId);
320 
321     /**
322      * @dev An entire blob has been retracted. This cannot be undone.
323      * @param blobId Id of the blob.
324      */
325     event Retract(bytes20 indexed blobId);
326 
327     /**
328      * @dev A blob has been transfered to a new address.
329      * @param blobId Id of the blob.
330      * @param recipient The address that now owns the blob.
331      */
332     event Transfer(bytes20 indexed blobId, address recipient);
333 
334     /**
335      * @dev A blob has been disowned. This cannot be undone.
336      * @param blobId Id of the blob.
337      */
338     event Disown(bytes20 indexed blobId);
339 
340     /**
341      * @dev A blob has been set as not updatable. This cannot be undone.
342      * @param blobId Id of the blob.
343      */
344     event SetNotUpdatable(bytes20 indexed blobId);
345 
346     /**
347      * @dev A blob has been set as enforcing revisions. This cannot be undone.
348      * @param blobId Id of the blob.
349      */
350     event SetEnforceRevisions(bytes20 indexed blobId);
351 
352     /**
353      * @dev A blob has been set as not retractable. This cannot be undone.
354      * @param blobId Id of the blob.
355      */
356     event SetNotRetractable(bytes20 indexed blobId);
357 
358     /**
359      * @dev A blob has been set as not transferable. This cannot be undone.
360      * @param blobId Id of the blob.
361      */
362     event SetNotTransferable(bytes20 indexed blobId);
363 
364     /**
365      * @dev Throw if the blob has not been used before or it has been retracted.
366      * @param blobId Id of the blob.
367      */
368     modifier exists(bytes20 blobId) {
369         BlobInfo info = blobInfo[blobId];
370         if (info.blockNumber == 0 || info.blockNumber == uint32(-1)) {
371             throw;
372         }
373         _;
374     }
375 
376     /**
377      * @dev Throw if the owner of the blob is not the message sender.
378      * @param blobId Id of the blob.
379      */
380     modifier isOwner(bytes20 blobId) {
381         if (blobInfo[blobId].owner != msg.sender) {
382             throw;
383         }
384         _;
385     }
386 
387     /**
388      * @dev Throw if the blob is not updatable.
389      * @param blobId Id of the blob.
390      */
391     modifier isUpdatable(bytes20 blobId) {
392         if (blobInfo[blobId].flags & UPDATABLE == 0) {
393             throw;
394         }
395         _;
396     }
397 
398     /**
399      * @dev Throw if the blob is not enforcing revisions.
400      * @param blobId Id of the blob.
401      */
402     modifier isNotEnforceRevisions(bytes20 blobId) {
403         if (blobInfo[blobId].flags & ENFORCE_REVISIONS != 0) {
404             throw;
405         }
406         _;
407     }
408 
409     /**
410      * @dev Throw if the blob is not retractable.
411      * @param blobId Id of the blob.
412      */
413     modifier isRetractable(bytes20 blobId) {
414         if (blobInfo[blobId].flags & RETRACTABLE == 0) {
415             throw;
416         }
417         _;
418     }
419 
420     /**
421      * @dev Throw if the blob is not transferable.
422      * @param blobId Id of the blob.
423      */
424     modifier isTransferable(bytes20 blobId) {
425         if (blobInfo[blobId].flags & TRANSFERABLE == 0) {
426             throw;
427         }
428         _;
429     }
430 
431     /**
432      * @dev Throw if the blob is not transferable to a specific user.
433      * @param blobId Id of the blob.
434      * @param recipient Address of the user.
435      */
436     modifier isTransferEnabled(bytes20 blobId, address recipient) {
437         if (!enabledTransfers[blobId][recipient]) {
438             throw;
439         }
440         _;
441     }
442 
443     /**
444      * @dev Throw if the blob only has one revision.
445      * @param blobId Id of the blob.
446      */
447     modifier hasAdditionalRevisions(bytes20 blobId) {
448         if (blobInfo[blobId].revisionCount == 1) {
449             throw;
450         }
451         _;
452     }
453 
454     /**
455      * @dev Throw if a specific blob revision does not exist.
456      * @param blobId Id of the blob.
457      * @param revisionId Id of the revision.
458      */
459     modifier revisionExists(bytes20 blobId, uint revisionId) {
460         if (revisionId >= blobInfo[blobId].revisionCount) {
461             throw;
462         }
463         _;
464     }
465 
466     /**
467      * @dev Constructor.
468      * @param registry Address of BlobStoreRegistry contract to register with.
469      */
470     function BlobStore(BlobStoreRegistry registry) {
471         // Create id for this contract.
472         contractId = bytes12(keccak256(this, block.blockhash(block.number - 1)));
473         // Register this contract.
474         registry.register(contractId);
475     }
476 
477     /**
478      * @dev Creates a new blob. It is guaranteed that different users will never receive the same blobId, even before consensus has been reached. This prevents blobId sniping. Consider createWithNonce() if not calling from another contract.
479      * @param flags Packed blob settings.
480      * @param contents Contents of the blob to be stored.
481      * @return blobId Id of the blob.
482      */
483     function create(bytes4 flags, bytes contents) external returns (bytes20 blobId) {
484         // Generate the blobId.
485         blobId = bytes20(keccak256(msg.sender, block.blockhash(block.number - 1)));
486         // Make sure this blobId has not been used before (could be in the same block).
487         while (blobInfo[blobId].blockNumber != 0) {
488             blobId = bytes20(keccak256(blobId));
489         }
490         // Store blob info in state.
491         blobInfo[blobId] = BlobInfo({
492             flags: flags,
493             revisionCount: 1,
494             blockNumber: uint32(block.number),
495             owner: (flags & ANONYMOUS != 0) ? 0 : msg.sender,
496         });
497         // Store the first revision in a log in the current block.
498         Store(blobId, 0, contents);
499     }
500 
501     /**
502      * @dev Creates a new blob using provided nonce. It is guaranteed that different users will never receive the same blobId, even before consensus has been reached. This prevents blobId sniping. This method is cheaper than create(), especially if multiple blobs from the same account end up in the same block. However, it is not suitable for calling from other contracts because it will throw if a unique nonce is not provided.
503      * @param flagsNonce First 4 bytes: Packed blob settings. The parameter as a whole must never have been passed to this function from the same account, or it will throw.
504      * @param contents Contents of the blob to be stored.
505      * @return blobId Id of the blob.
506      */
507     function createWithNonce(bytes32 flagsNonce, bytes contents) external returns (bytes20 blobId) {
508         // Generate the blobId.
509         blobId = bytes20(keccak256(msg.sender, flagsNonce));
510         // Make sure this blobId has not been used before.
511         if (blobInfo[blobId].blockNumber != 0) {
512             throw;
513         }
514         // Store blob info in state.
515         blobInfo[blobId] = BlobInfo({
516             flags: bytes4(flagsNonce),
517             revisionCount: 1,
518             blockNumber: uint32(block.number),
519             owner: (bytes4(flagsNonce) & ANONYMOUS != 0) ? 0 : msg.sender,
520         });
521         // Store the first revision in a log in the current block.
522         Store(blobId, 0, contents);
523     }
524 
525     /**
526      * @dev Store a blob revision block number in a packed slot.
527      * @param blobId Id of the blob.
528      * @param offset The offset of the block number should be retreived.
529      */
530     function _setPackedBlockNumber(bytes20 blobId, uint offset) internal {
531         // Get the slot.
532         bytes32 slot = packedBlockNumbers[blobId][offset / 8];
533         // Wipe the previous block number.
534         slot &= ~bytes32(uint32(-1) * 2**((offset % 8) * 32));
535         // Insert the current block number.
536         slot |= bytes32(uint32(block.number) * 2**((offset % 8) * 32));
537         // Store the slot.
538         packedBlockNumbers[blobId][offset / 8] = slot;
539     }
540 
541     /**
542      * @dev Create a new blob revision.
543      * @param blobId Id of the blob.
544      * @param contents Contents of the new revision.
545      * @return revisionId The new revisionId.
546      */
547     function createNewRevision(bytes20 blobId, bytes contents) external isOwner(blobId) isUpdatable(blobId) returns (uint revisionId) {
548         // Increment the number of revisions.
549         revisionId = blobInfo[blobId].revisionCount++;
550         // Store the block number.
551         _setPackedBlockNumber(blobId, revisionId - 1);
552         // Store the revision in a log in the current block.
553         Store(blobId, revisionId, contents);
554     }
555 
556     /**
557      * @dev Update a blob's latest revision.
558      * @param blobId Id of the blob.
559      * @param contents Contents that should replace the latest revision.
560      */
561     function updateLatestRevision(bytes20 blobId, bytes contents) external isOwner(blobId) isUpdatable(blobId) isNotEnforceRevisions(blobId) {
562         BlobInfo info = blobInfo[blobId];
563         uint revisionId = info.revisionCount - 1;
564         // Update the block number.
565         if (revisionId == 0) {
566             info.blockNumber = uint32(block.number);
567         }
568         else {
569             _setPackedBlockNumber(blobId, revisionId - 1);
570         }
571         // Store the revision in a log in the current block.
572         Store(blobId, revisionId, contents);
573     }
574 
575     /**
576      * @dev Retract a blob's latest revision. Revision 0 cannot be retracted.
577      * @param blobId Id of the blob.
578      */
579     function retractLatestRevision(bytes20 blobId) external isOwner(blobId) isUpdatable(blobId) isNotEnforceRevisions(blobId) hasAdditionalRevisions(blobId) {
580         uint revisionId = --blobInfo[blobId].revisionCount;
581         // Delete the slot if it is no longer required.
582         if (revisionId % 8 == 1) {
583             delete packedBlockNumbers[blobId][revisionId / 8];
584         }
585         // Log the revision retraction.
586         RetractRevision(blobId, revisionId);
587     }
588 
589     /**
590      * @dev Delete all of a blob's packed revision block numbers.
591      * @param blobId Id of the blob.
592      */
593     function _deleteAllPackedRevisionBlockNumbers(bytes20 blobId) internal {
594         // Determine how many slots should be deleted.
595         // Block number of the first revision is stored in the blob info, so the first slot only needs to be deleted if there are at least 2 revisions.
596         uint slotCount = (blobInfo[blobId].revisionCount + 6) / 8;
597         // Delete the slots.
598         for (uint i = 0; i < slotCount; i++) {
599             delete packedBlockNumbers[blobId][i];
600         }
601     }
602 
603     /**
604      * @dev Delete all a blob's revisions and replace it with a new blob.
605      * @param blobId Id of the blob.
606      * @param contents Contents that should be stored.
607      */
608     function restart(bytes20 blobId, bytes contents) external isOwner(blobId) isUpdatable(blobId) isNotEnforceRevisions(blobId) {
609         // Delete the packed revision block numbers.
610         _deleteAllPackedRevisionBlockNumbers(blobId);
611         // Update the blob state info.
612         BlobInfo info = blobInfo[blobId];
613         info.revisionCount = 1;
614         info.blockNumber = uint32(block.number);
615         // Store the blob in a log in the current block.
616         Store(blobId, 0, contents);
617     }
618 
619     /**
620      * @dev Retract a blob.
621      * @param blobId Id of the blob. This blobId can never be used again.
622      */
623     function retract(bytes20 blobId) external isOwner(blobId) isRetractable(blobId) {
624         // Delete the packed revision block numbers.
625         _deleteAllPackedRevisionBlockNumbers(blobId);
626         // Mark this blob as retracted.
627         blobInfo[blobId] = BlobInfo({
628             flags: 0,
629             revisionCount: 0,
630             blockNumber: uint32(-1),
631             owner: 0,
632         });
633         // Log the blob retraction.
634         Retract(blobId);
635     }
636 
637     /**
638      * @dev Enable transfer of the blob to the current user.
639      * @param blobId Id of the blob.
640      */
641     function transferEnable(bytes20 blobId) external isTransferable(blobId) {
642         // Record in state that the current user will accept this blob.
643         enabledTransfers[blobId][msg.sender] = true;
644     }
645 
646     /**
647      * @dev Disable transfer of the blob to the current user.
648      * @param blobId Id of the blob.
649      */
650     function transferDisable(bytes20 blobId) external isTransferEnabled(blobId, msg.sender) {
651         // Record in state that the current user will not accept this blob.
652         enabledTransfers[blobId][msg.sender] = false;
653     }
654 
655     /**
656      * @dev Transfer a blob to a new user.
657      * @param blobId Id of the blob.
658      * @param recipient Address of the user to transfer to blob to.
659      */
660     function transfer(bytes20 blobId, address recipient) external isOwner(blobId) isTransferable(blobId) isTransferEnabled(blobId, recipient) {
661         // Update ownership of the blob.
662         blobInfo[blobId].owner = recipient;
663         // Disable this transfer in future and free up the slot.
664         enabledTransfers[blobId][recipient] = false;
665         // Log the transfer.
666         Transfer(blobId, recipient);
667     }
668 
669     /**
670      * @dev Disown a blob.
671      * @param blobId Id of the blob.
672      */
673     function disown(bytes20 blobId) external isOwner(blobId) isTransferable(blobId) {
674         // Remove the owner from the blob's state.
675         delete blobInfo[blobId].owner;
676         // Log that the blob has been disowned.
677         Disown(blobId);
678     }
679 
680     /**
681      * @dev Set a blob as not updatable.
682      * @param blobId Id of the blob.
683      */
684     function setNotUpdatable(bytes20 blobId) external isOwner(blobId) {
685         // Record in state that the blob is not updatable.
686         blobInfo[blobId].flags &= ~UPDATABLE;
687         // Log that the blob is not updatable.
688         SetNotUpdatable(blobId);
689     }
690 
691     /**
692      * @dev Set a blob to enforce revisions.
693      * @param blobId Id of the blob.
694      */
695     function setEnforceRevisions(bytes20 blobId) external isOwner(blobId) {
696         // Record in state that all changes to this blob must be new revisions.
697         blobInfo[blobId].flags |= ENFORCE_REVISIONS;
698         // Log that the blob now forces new revisions.
699         SetEnforceRevisions(blobId);
700     }
701 
702     /**
703      * @dev Set a blob to not be retractable.
704      * @param blobId Id of the blob.
705      */
706     function setNotRetractable(bytes20 blobId) external isOwner(blobId) {
707         // Record in state that the blob is not retractable.
708         blobInfo[blobId].flags &= ~RETRACTABLE;
709         // Log that the blob is not retractable.
710         SetNotRetractable(blobId);
711     }
712 
713     /**
714      * @dev Set a blob to not be transferable.
715      * @param blobId Id of the blob.
716      */
717     function setNotTransferable(bytes20 blobId) external isOwner(blobId) {
718         // Record in state that the blob is not transferable.
719         blobInfo[blobId].flags &= ~TRANSFERABLE;
720         // Log that the blob is not transferable.
721         SetNotTransferable(blobId);
722     }
723 
724     /**
725      * @dev Get the id for this BlobStore contract.
726      * @return Id of the contract.
727      */
728     function getContractId() external constant returns (bytes12) {
729         return contractId;
730     }
731 
732     /**
733      * @dev Check if a blob exists.
734      * @param blobId Id of the blob.
735      * @return exists True if the blob exists.
736      */
737     function getExists(bytes20 blobId) external constant returns (bool exists) {
738         BlobInfo info = blobInfo[blobId];
739         exists = info.blockNumber != 0 && info.blockNumber != uint32(-1);
740     }
741 
742     /**
743      * @dev Get the block number for a specific blob revision.
744      * @param blobId Id of the blob.
745      * @param revisionId Id of the revision.
746      * @return blockNumber Block number of the specified revision.
747      */
748     function _getRevisionBlockNumber(bytes20 blobId, uint revisionId) internal returns (uint blockNumber) {
749         if (revisionId == 0) {
750             blockNumber = blobInfo[blobId].blockNumber;
751         }
752         else {
753             bytes32 slot = packedBlockNumbers[blobId][(revisionId - 1) / 8];
754             blockNumber = uint32(uint256(slot) / 2**(((revisionId - 1) % 8) * 32));
755         }
756     }
757 
758     /**
759      * @dev Get the block numbers for all of a blob's revisions.
760      * @param blobId Id of the blob.
761      * @return blockNumbers Revision block numbers.
762      */
763     function _getAllRevisionBlockNumbers(bytes20 blobId) internal returns (uint[] blockNumbers) {
764         uint revisionCount = blobInfo[blobId].revisionCount;
765         blockNumbers = new uint[](revisionCount);
766         for (uint revisionId = 0; revisionId < revisionCount; revisionId++) {
767             blockNumbers[revisionId] = _getRevisionBlockNumber(blobId, revisionId);
768         }
769     }
770 
771     /**
772      * @dev Get info about a blob.
773      * @param blobId Id of the blob.
774      * @return flags Packed blob settings.
775      * @return owner Owner of the blob.
776      * @return revisionCount How many revisions the blob has.
777      * @return blockNumbers The block numbers of the revisions.
778      */
779     function getInfo(bytes20 blobId) external constant exists(blobId) returns (bytes4 flags, address owner, uint revisionCount, uint[] blockNumbers) {
780         BlobInfo info = blobInfo[blobId];
781         flags = info.flags;
782         owner = info.owner;
783         revisionCount = info.revisionCount;
784         blockNumbers = _getAllRevisionBlockNumbers(blobId);
785     }
786 
787     /**
788      * @dev Get all a blob's flags.
789      * @param blobId Id of the blob.
790      * @return flags Packed blob settings.
791      */
792     function getFlags(bytes20 blobId) external constant exists(blobId) returns (bytes4 flags) {
793         flags = blobInfo[blobId].flags;
794     }
795 
796     /**
797      * @dev Determine if a blob is updatable.
798      * @param blobId Id of the blob.
799      * @return updatable True if the blob is updatable.
800      */
801     function getUpdatable(bytes20 blobId) external constant exists(blobId) returns (bool updatable) {
802         updatable = blobInfo[blobId].flags & UPDATABLE != 0;
803     }
804 
805     /**
806      * @dev Determine if a blob enforces revisions.
807      * @param blobId Id of the blob.
808      * @return enforceRevisions True if the blob enforces revisions.
809      */
810     function getEnforceRevisions(bytes20 blobId) external constant exists(blobId) returns (bool enforceRevisions) {
811         enforceRevisions = blobInfo[blobId].flags & ENFORCE_REVISIONS != 0;
812     }
813 
814     /**
815      * @dev Determine if a blob is retractable.
816      * @param blobId Id of the blob.
817      * @return retractable True if the blob is blob retractable.
818      */
819     function getRetractable(bytes20 blobId) external constant exists(blobId) returns (bool retractable) {
820         retractable = blobInfo[blobId].flags & RETRACTABLE != 0;
821     }
822 
823     /**
824      * @dev Determine if a blob is transferable.
825      * @param blobId Id of the blob.
826      * @return transferable True if the blob is transferable.
827      */
828     function getTransferable(bytes20 blobId) external constant exists(blobId) returns (bool transferable) {
829         transferable = blobInfo[blobId].flags & TRANSFERABLE != 0;
830     }
831 
832     /**
833      * @dev Get the owner of a blob.
834      * @param blobId Id of the blob.
835      * @return owner Owner of the blob.
836      */
837     function getOwner(bytes20 blobId) external constant exists(blobId) returns (address owner) {
838         owner = blobInfo[blobId].owner;
839     }
840 
841     /**
842      * @dev Get the number of revisions a blob has.
843      * @param blobId Id of the blob.
844      * @return revisionCount How many revisions the blob has.
845      */
846     function getRevisionCount(bytes20 blobId) external constant exists(blobId) returns (uint revisionCount) {
847         revisionCount = blobInfo[blobId].revisionCount;
848     }
849 
850     /**
851      * @dev Get the block number for a specific blob revision.
852      * @param blobId Id of the blob.
853      * @param revisionId Id of the revision.
854      * @return blockNumber Block number of the specified revision.
855      */
856     function getRevisionBlockNumber(bytes20 blobId, uint revisionId) external constant revisionExists(blobId, revisionId) returns (uint blockNumber) {
857         blockNumber = _getRevisionBlockNumber(blobId, revisionId);
858     }
859 
860     /**
861      * @dev Get the block numbers for all of a blob's revisions.
862      * @param blobId Id of the blob.
863      * @return blockNumbers Revision block numbers.
864      */
865     function getAllRevisionBlockNumbers(bytes20 blobId) external constant exists(blobId) returns (uint[] blockNumbers) {
866         blockNumbers = _getAllRevisionBlockNumbers(blobId);
867     }
868 
869 }