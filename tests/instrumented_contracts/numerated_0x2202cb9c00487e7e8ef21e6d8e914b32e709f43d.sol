1 // SPDX-License-Identifier: MIT
2 
3 //     _   ______________                                       
4 //    / | / / ____/_  __/                                       
5 //   /  |/ / /_    / /                                          
6 //  / /|  / __/   / /                                           
7 // /_/ |_/_/ ____/_/_    _______________  ______________  _   __
8 //    / __ \/ ____/ /   / ____/ ____/   |/_  __/  _/ __ \/ | / /
9 //   / / / / __/ / /   / __/ / / __/ /| | / /  / // / / /  |/ / 
10 //  / /_/ / /___/ /___/ /___/ /_/ / ___ |/ / _/ // /_/ / /|  /  
11 // /_____/_____/_____/_____/\____/_/  |_/_/ /___/\____/_/ |_/   
12                                                              
13 
14 /**
15  *
16  *  @title: NFTDelegation.com Management Contract
17  *  @date: 20-Apr-2023 - 16:27
18  *  @version: 5.20.15
19  *  @notes: An advanced open-source trustless delegation and consolidation management contract.
20  *  @author: 6529 team
21  *  @contributors: https://github.com/6529-Collections/nftdelegation/graphs/contributors
22  *
23  */
24 
25 pragma solidity ^0.8.18;
26 
27 contract DelegationManagementContract {
28     // Constant declarations
29     address constant ALL_COLLECTIONS = 0x8888888888888888888888888888888888888888;
30     uint256 constant USE_CASE_SUB_DELEGATION = 998;
31     uint256 constant USE_CASE_CONSOLIDATION = 999;
32 
33     // Variable declarations
34     uint256 public useCaseCounter;
35 
36     // Mapping declarations
37     mapping(bytes32 => address[]) public delegatorHashes;
38     mapping(bytes32 => address[]) public delegationAddressHashes;
39 
40     struct GlobalData {
41         address delegatorAddress;
42         address delegationAddress;
43         uint256 registeredDate;
44         uint256 expiryDate;
45         bool allTokens;
46         uint256 tokens;
47     }
48 
49     // Mapping of GlobalData struct declaration
50     mapping(bytes32 => GlobalData[]) public globalDelegationHashes;
51 
52     // Events declaration
53     event RegisterDelegation(address indexed from, address indexed collectionAddress, address indexed delegationAddress, uint256 useCase, bool allTokens, uint256 _tokenId);
54     event RegisterDelegationUsingSubDelegation(address indexed delegator, address from, address indexed collectionAddress, address indexed delegationAddress, uint256 useCase, bool allTokens, uint256 _tokenId);
55     event RevokeDelegation(address indexed from, address indexed collectionAddress, address indexed delegationAddress, uint256 useCase);
56     event RevokeDelegationUsingSubDelegation(address indexed delegator, address from, address indexed collectionAddress, address indexed delegationAddress, uint256 useCase);
57     event UpdateDelegation(address indexed from, address indexed collectionAddress, address olddelegationAddress, address indexed newdelegationAddress, uint256 useCase, bool allTokens, uint256 _tokenId);
58 
59     // Locks declarations
60     mapping(address => bool) public globalLock;
61     mapping(bytes32 => bool) public collectionLock;
62     mapping(bytes32 => bool) public collectionUsecaseLock;
63 
64     // Constructor
65     constructor() {
66         useCaseCounter = 999;
67     }
68 
69     /**
70      * @notice Delegator assigns a delegation address for a specific use case on a specific NFT collection for a certain duration
71      * @notice _collectionAddress --> ALL_COLLECTIONS = Applies to all collections
72      * @notice For all Tokens-- > _allTokens needs to be true, _tokenId does not matter
73      */
74 
75     function registerDelegationAddress(address _collectionAddress, address _delegationAddress, uint256 _expiryDate, uint256 _useCase, bool _allTokens, uint256 _tokenId) public {
76         require((_useCase > 0 && _useCase <= useCaseCounter));
77         bytes32 delegatorHash;
78         bytes32 delegationAddressHash;
79         bytes32 globalHash;
80         bytes32 collectionLockHash;
81         bytes32 collectionUsecaseLockHash;
82         bytes32 collectionUsecaseLockHashAll;
83         // Locks
84         collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
85         collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase));
86         collectionUsecaseLockHashAll = keccak256(abi.encodePacked(ALL_COLLECTIONS, _delegationAddress, _useCase));
87         require(globalLock[_delegationAddress] == false);
88         require(collectionLock[collectionLockHash] == false);
89         require(collectionUsecaseLock[collectionUsecaseLockHash] == false);
90         require(collectionUsecaseLock[collectionUsecaseLockHashAll] == false);
91         // Push data to mappings
92         globalHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _delegationAddress, _useCase));
93         delegatorHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _useCase));
94         // Stores delegation addresses on a delegator hash
95         delegationAddressHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
96         delegatorHashes[delegatorHash].push(_delegationAddress);
97         // Stores delegators addresses on a delegation address hash
98         delegationAddressHashes[delegationAddressHash].push(msg.sender);
99         // Push additional data to the globalDelegationHashes mapping
100         if (_allTokens == true) {
101             GlobalData memory newdelegationGlobalData = GlobalData(msg.sender, _delegationAddress, block.timestamp, _expiryDate, true, 0);
102             globalDelegationHashes[globalHash].push(newdelegationGlobalData);
103         } else {
104             GlobalData memory newdelegationGlobalData = GlobalData(msg.sender, _delegationAddress, block.timestamp, _expiryDate, false, _tokenId);
105             globalDelegationHashes[globalHash].push(newdelegationGlobalData);
106         }
107         emit RegisterDelegation(msg.sender, _collectionAddress, _delegationAddress, _useCase, _allTokens, _tokenId);
108     }
109 
110     /**
111      * @notice Function to support subDelegation rights
112      * @notice A delegation Address that has subDelegation rights given by a Delegator can register Delegations on behalf of Delegator
113      */
114 
115     function registerDelegationAddressUsingSubDelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _expiryDate, uint256 _useCase, bool _allTokens, uint256 _tokenId) public {
116         // Check subdelegation rights for the specific collection
117         {
118             bool subdelegationRightsCol;
119             address[] memory allDelegators = retrieveDelegators(msg.sender, _collectionAddress, USE_CASE_SUB_DELEGATION);
120             if (allDelegators.length > 0) {
121                 for (uint i = 0; i < allDelegators.length; ) {
122                     if (_delegatorAddress == allDelegators[i]) {
123                         subdelegationRightsCol = true;
124                         break;
125                     }
126 
127                     unchecked {
128                         ++i;
129                     }
130                 }
131             }
132             // Check subdelegation rights for All collections
133             allDelegators = retrieveDelegators(msg.sender, ALL_COLLECTIONS, USE_CASE_SUB_DELEGATION);
134             if (allDelegators.length > 0) {
135                 if (subdelegationRightsCol != true) {
136                     for (uint i = 0; i < allDelegators.length; ) {
137                         if (_delegatorAddress == allDelegators[i]) {
138                             subdelegationRightsCol = true;
139                             break;
140                         }
141 
142                         unchecked {
143                             ++i;
144                         }
145                     }
146                 }
147             }
148             // Allow to register
149             require((subdelegationRightsCol == true));
150         }
151         // If check passed then register delegation address for Delegator
152         require((_useCase > 0 && _useCase <= useCaseCounter));
153         bytes32 delegatorHash;
154         bytes32 delegationAddressHash;
155         bytes32 globalHash;
156         bytes32 collectionLockHash;
157         bytes32 collectionUsecaseLockHash;
158         bytes32 collectionUsecaseLockHashAll;
159         // Locks
160         collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
161         collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase));
162         collectionUsecaseLockHashAll = keccak256(abi.encodePacked(ALL_COLLECTIONS, _delegationAddress, _useCase));
163         require(globalLock[_delegationAddress] == false);
164         require(collectionLock[collectionLockHash] == false);
165         require(collectionUsecaseLock[collectionUsecaseLockHash] == false);
166         require(collectionUsecaseLock[collectionUsecaseLockHashAll] == false);
167         // Push data to mappings
168         globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _delegationAddress, _useCase));
169         delegatorHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _useCase));
170         // Stores delegation addresses on a delegator hash
171         delegationAddressHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
172         delegatorHashes[delegatorHash].push(_delegationAddress);
173         // Stores delegators addresses on a delegation address hash
174         delegationAddressHashes[delegationAddressHash].push(_delegatorAddress);
175         // Push additional data to the globalDelegationHashes mapping
176         if (_allTokens == true) {
177             GlobalData memory newdelegationGlobalData = GlobalData(_delegatorAddress, _delegationAddress, block.timestamp, _expiryDate, true, 0);
178             globalDelegationHashes[globalHash].push(newdelegationGlobalData);
179         } else {
180             GlobalData memory newdelegationGlobalData = GlobalData(_delegatorAddress, _delegationAddress, block.timestamp, _expiryDate, false, _tokenId);
181             globalDelegationHashes[globalHash].push(newdelegationGlobalData);
182         }
183         emit RegisterDelegationUsingSubDelegation(_delegatorAddress, msg.sender, _collectionAddress, _delegationAddress, _useCase, _allTokens, _tokenId);
184     }
185 
186     /**
187      * @notice Delegator revokes delegation rights given to a delegation address on a specific use case on a specific NFT collection
188      * @notice This function does not remove the delegation from the collectionsRegistered or useCaseRegistered as we want to track delegations history
189      */
190 
191     function revokeDelegationAddress(address _collectionAddress, address _delegationAddress, uint256 _useCase) public {
192         bytes32 delegatorHash;
193         bytes32 delegationAddressHash;
194         bytes32 globalHash;
195         uint256 count;
196         globalHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _delegationAddress, _useCase));
197         delegatorHash = keccak256(abi.encodePacked(msg.sender, _collectionAddress, _useCase));
198         delegationAddressHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
199         // Revoke delegation Address from the delegatorHashes mapping
200         count = 0;
201         if (delegatorHashes[delegatorHash].length > 0) {
202             for (uint256 i = 0; i < delegatorHashes[delegatorHash].length; ) {
203                 if (_delegationAddress == delegatorHashes[delegatorHash][i]) {
204                     count = count + 1;
205                 }
206 
207                 unchecked {
208                     ++i;
209                 }
210             }
211             uint256[] memory delegationsPerUser = new uint256[](count);
212             uint256 count1 = 0;
213             for (uint256 i = 0; i < delegatorHashes[delegatorHash].length; ) {
214                 if (_delegationAddress == delegatorHashes[delegatorHash][i]) {
215                     delegationsPerUser[count1] = i;
216                     count1 = count1 + 1;
217                 }
218 
219                 unchecked {
220                     ++i;
221                 }
222             }
223 
224             if (count1 > 0) {
225                 for (uint256 j = 0; j < delegationsPerUser.length; ) {
226                     uint256 temp1;
227                     uint256 temp2;
228                     temp1 = delegationsPerUser[delegationsPerUser.length - 1 - j];
229                     temp2 = delegatorHashes[delegatorHash].length - 1;
230                     delegatorHashes[delegatorHash][temp1] = delegatorHashes[delegatorHash][temp2];
231                     delegatorHashes[delegatorHash].pop();
232 
233                     unchecked {
234                         ++j;
235                     }
236                 }                
237             }
238             // Revoke delegator Address from the delegationAddressHashes mapping
239             uint256 countDA = 0;
240             for (uint256 i = 0; i < delegationAddressHashes[delegationAddressHash].length; ) {
241                 if (msg.sender == delegationAddressHashes[delegationAddressHash][i]) {
242                     countDA = countDA + 1;
243                 }
244 
245                 unchecked {
246                     ++i;
247                 }
248             }
249             uint256[] memory delegatorsPerUser = new uint256[](countDA);
250             uint256 countDA1 = 0;
251             for (uint256 i = 0; i < delegationAddressHashes[delegationAddressHash].length; ) {
252                 if (msg.sender == delegationAddressHashes[delegationAddressHash][i]) {
253                     delegatorsPerUser[countDA1] = i;
254                     countDA1 = countDA1 + 1;
255                 }
256 
257                 unchecked {
258                     ++i;
259                 }
260             }
261             if (countDA1 > 0) {
262                 for (uint256 j = 0; j < delegatorsPerUser.length; ) {
263                     uint256 temp1;
264                     uint256 temp2;
265                     temp1 = delegatorsPerUser[delegatorsPerUser.length - 1 - j];
266                     temp2 = delegationAddressHashes[delegationAddressHash].length - 1;
267                     delegationAddressHashes[delegationAddressHash][temp1] = delegationAddressHashes[delegationAddressHash][temp2];
268                     delegationAddressHashes[delegationAddressHash].pop();
269 
270                     unchecked {
271                         ++j;
272                     }
273                 }
274             }
275             // Delete global delegation data and emit event
276             delete globalDelegationHashes[globalHash];
277             emit RevokeDelegation(msg.sender, _collectionAddress, _delegationAddress, _useCase);
278         }
279     }
280 
281     /**
282      * @notice This function supports the revoking of a Delegation Address using an address with Subdelegation rights
283      */
284 
285     function revokeDelegationAddressUsingSubdelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _useCase) public {
286         // Check subdelegation rights for the specific collection
287         {
288             bool subdelegationRightsCol;
289             address[] memory allDelegators = retrieveDelegators(msg.sender, _collectionAddress, USE_CASE_SUB_DELEGATION);
290             if (allDelegators.length > 0) {
291                 for (uint i = 0; i < allDelegators.length; ) {
292                     if (_delegatorAddress == allDelegators[i]) {
293                         subdelegationRightsCol = true;
294                         break;
295                     }
296 
297                     unchecked {
298                         ++i;
299                     }
300                 }     
301             }
302             // Check subdelegation rights for All collections
303             allDelegators = retrieveDelegators(msg.sender, ALL_COLLECTIONS, USE_CASE_SUB_DELEGATION);
304             if (allDelegators.length > 0) {
305                 if (subdelegationRightsCol != true) {
306                     for (uint i = 0; i < allDelegators.length; ) {
307                         if (_delegatorAddress == allDelegators[i]) {
308                             subdelegationRightsCol = true;
309                             break;
310                         }
311 
312                         unchecked {
313                             ++i;
314                         }
315                     }
316                 }
317             }
318             // Allow to revoke
319             require((subdelegationRightsCol == true));
320         }
321         // If check passed then revoke delegation address for Delegator
322         bytes32 delegatorHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _useCase));
323         bytes32 delegationAddressHash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
324         bytes32 globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _delegationAddress, _useCase));
325         uint256 count;
326         count = 0;
327         if (delegatorHashes[delegatorHash].length > 0) {
328             for (uint256 i = 0; i < delegatorHashes[delegatorHash].length; ) {
329                 if (_delegationAddress == delegatorHashes[delegatorHash][i]) {
330                     count = count + 1;
331                 }
332 
333                 unchecked {
334                     ++i;
335                 }
336             }
337             uint256[] memory delegationsPerUser = new uint256[](count);
338             uint256 count1 = 0;
339             for (uint256 i = 0; i < delegatorHashes[delegatorHash].length; ) {
340                 if (_delegationAddress == delegatorHashes[delegatorHash][i]) {
341                     delegationsPerUser[count1] = i;
342                     count1 = count1 + 1;
343                 }
344 
345                 unchecked {
346                     ++i;
347                 }
348             }
349             if (count1 > 0) {
350                 for (uint256 j = 0; j < delegationsPerUser.length; ) {
351                     uint256 temp1;
352                     uint256 temp2;
353                     temp1 = delegationsPerUser[delegationsPerUser.length - 1 - j];
354                     temp2 = delegatorHashes[delegatorHash].length - 1;
355                     delegatorHashes[delegatorHash][temp1] = delegatorHashes[delegatorHash][temp2];
356                     delegatorHashes[delegatorHash].pop();
357 
358                     unchecked {
359                         ++j;
360                     }
361                 }
362             }
363             // Revoke delegator Address from the delegationAddressHashes mapping
364             uint256 countDA = 0;
365             for (uint256 i = 0; i < delegationAddressHashes[delegationAddressHash].length; ) {
366                 if (_delegatorAddress == delegationAddressHashes[delegationAddressHash][i]) {
367                     countDA = countDA + 1;
368                 }
369 
370                 unchecked {
371                     ++i;
372                 }
373             }
374             uint256[] memory delegatorsPerUser = new uint256[](countDA);
375             uint256 countDA1 = 0;
376             for (uint256 i = 0; i < delegationAddressHashes[delegationAddressHash].length; ) {
377                 if (_delegatorAddress == delegationAddressHashes[delegationAddressHash][i]) {
378                     delegatorsPerUser[countDA1] = i;
379                     countDA1 = countDA1 + 1;
380                 }
381 
382                 unchecked {
383                     ++i;
384                 }
385             }
386             if (countDA1 > 0) {
387                 for (uint256 j = 0; j < delegatorsPerUser.length; ) {
388                     uint256 temp1;
389                     uint256 temp2;
390                     temp1 = delegatorsPerUser[delegatorsPerUser.length - 1 - j];
391                     temp2 = delegationAddressHashes[delegationAddressHash].length - 1;
392                     delegationAddressHashes[delegationAddressHash][temp1] = delegationAddressHashes[delegationAddressHash][temp2];
393                     delegationAddressHashes[delegationAddressHash].pop();
394 
395                     unchecked {
396                         ++j;
397                     }
398                 }
399             }
400             // Delete global delegation data and emit event
401             delete globalDelegationHashes[globalHash];
402             emit RevokeDelegationUsingSubDelegation(_delegatorAddress, msg.sender, _collectionAddress, _delegationAddress, _useCase);
403         }
404     }
405 
406     /**
407      * @notice Batch revoking (up to 5 delegation addresses)
408      */
409 
410     function batchRevocations(address[] memory _collectionAddresses, address[] memory _delegationAddresses, uint256[] memory _useCases) public {
411         require(_collectionAddresses.length < 6);
412         for (uint256 i = 0; i < _collectionAddresses.length; ) {
413             revokeDelegationAddress(_collectionAddresses[i], _delegationAddresses[i], _useCases[i]);
414 
415             unchecked {
416                 ++i;
417             }
418         }
419     }
420 
421     /**
422      * @notice Delegator updates a delegation address for a specific use case on a specific NFT collection for a certain duration
423      */
424 
425     function updateDelegationAddress(address _collectionAddress, address _olddelegationAddress, address _newdelegationAddress, uint256 _expiryDate, uint256 _useCase, bool _allTokens, uint256 _tokenId) public {
426         revokeDelegationAddress(_collectionAddress, _olddelegationAddress, _useCase);
427         registerDelegationAddress(_collectionAddress, _newdelegationAddress, _expiryDate, _useCase, _allTokens, _tokenId);
428         emit UpdateDelegation(msg.sender, _collectionAddress, _olddelegationAddress, _newdelegationAddress, _useCase, _allTokens, _tokenId);
429     }
430 
431     /**
432      * @notice Batch registrations function (up to 5 delegation addresses)
433      */
434 
435     function batchDelegations(address[] memory _collectionAddresses, address[] memory _delegationAddresses, uint256[] memory _expiryDates, uint256[] memory _useCases, bool[] memory _allTokens, uint256[] memory _tokenIds) public {
436         require(_collectionAddresses.length < 6);
437         for (uint256 i = 0; i < _collectionAddresses.length; ) {
438             registerDelegationAddress(_collectionAddresses[i], _delegationAddresses[i], _expiryDates[i], _useCases[i], _allTokens[i], _tokenIds[i]);
439 
440             unchecked {
441                 ++i;
442             }
443         }
444     }
445 
446     /**
447      * @notice Set global Lock status (hot wallet)
448      */
449 
450     function setGlobalLock(bool _status) public {
451         globalLock[msg.sender] = _status;
452     }
453 
454     /**
455      * @notice Set collection Lock status (hot wallet)
456      */
457 
458     function setCollectionLock(address _collectionAddress, bool _status) public {
459         if (_collectionAddress == ALL_COLLECTIONS) {
460             setGlobalLock(_status);
461         } else {
462             bytes32 collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, msg.sender));
463             collectionLock[collectionLockHash] = _status;
464         }
465     }
466 
467     /**
468      * @notice Set collection usecase Lock status (hot wallet)
469      */
470 
471     function setCollectionUsecaseLock(address _collectionAddress, uint256 _useCase, bool _status) public {
472         if (_useCase==1) {
473             setCollectionLock(_collectionAddress, _status);
474         } else {
475             bytes32 collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, msg.sender, _useCase));
476             collectionUsecaseLock[collectionUsecaseLockHash] = _status;
477         }
478     }
479 
480     /**
481      * @notice This function updates the number of Use Cases in case more usecases are needed
482      */
483 
484     function updateUseCaseCounter() public {
485         useCaseCounter = useCaseCounter + 1;
486     }
487 
488     // A full list of Available Getter functions
489 
490     /**
491      * @notice Retrieve Global Lock Status
492      */
493 
494     function retrieveGlobalLockStatus(address _delegationAddress) public view returns (bool) {
495         return globalLock[_delegationAddress];
496     }
497 
498     /**
499      * @notice Retrieve Collection Lock Status
500      */
501 
502     function retrieveCollectionLockStatus(address _collectionAddress, address _delegationAddress) public view returns (bool) {
503         if (_collectionAddress == ALL_COLLECTIONS) {
504             return retrieveGlobalLockStatus(_delegationAddress);
505         } else {
506             bytes32 collectionLockHash;
507             collectionLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress));
508             return collectionLock[collectionLockHash];
509         }
510     }
511 
512     /**
513      * @notice Retrieve Collection Use Case Lock Status
514      */
515 
516     function retrieveCollectionUseCaseLockStatus(address _collectionAddress, address _delegationAddress, uint256 _useCase) public view returns (bool) {
517         if (_useCase == 1) {
518             return retrieveCollectionLockStatus(_collectionAddress, _delegationAddress);
519         } else {
520             bytes32 collectionUsecaseLockHash;
521             collectionUsecaseLockHash = keccak256(abi.encodePacked(_collectionAddress, _delegationAddress, _useCase));
522             return collectionUsecaseLock[collectionUsecaseLockHash];
523         }
524     }
525 
526     /**
527      * @notice Retrieve Collection Use Case Lock Status for both specific colleciton and ALL_COLLECTIONS
528      */
529 
530     function retrieveCollectionUseCaseLockStatusOneCall(address _collectionAddress, address _delegationAddress, uint256 _useCase) public view returns (bool) {
531         if (_useCase == 1) {
532             return retrieveCollectionLockStatus(_collectionAddress, _delegationAddress);
533         } else {
534             return retrieveCollectionUseCaseLockStatus(_collectionAddress, _delegationAddress, _useCase) || retrieveCollectionUseCaseLockStatus(ALL_COLLECTIONS, _delegationAddress, _useCase);
535         }
536     }
537 
538     /**
539      * @notice Support function to retrieve the hash given specific parameters
540      */
541 
542     function retrieveLocalHash(address _walletAddress, address _collectionAddress, uint256 _useCase) public pure returns (bytes32) {
543         bytes32 hash;
544         hash = keccak256(abi.encodePacked(_walletAddress, _collectionAddress, _useCase));
545         return (hash);
546     }
547 
548     /**
549      * @notice Support function to retrieve the global hash given specific parameters
550      */
551 
552     function retrieveGlobalHash(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _useCase) public pure returns (bytes32) {
553         bytes32 globalHash;
554         globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _delegationAddress, _useCase));
555         return (globalHash);
556     }
557 
558     /**
559      * @notice Returns an array of all delegation addresses (active AND inactive) assigned by a delegator for a specific use case on a specific NFT collection
560      */
561 
562     function retrieveDelegationAddresses(address _delegatorAddress, address _collectionAddress, uint256 _useCase) public view returns (address[] memory) {
563         bytes32 hash;
564         hash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _useCase));
565         return (delegatorHashes[hash]);
566     }
567 
568     /**
569      * @notice Returns an array of all delegators (active AND inactive) that delegated to a delegationAddress for a specific use case on a specific NFT collection
570      */
571 
572     function retrieveDelegators(address _delegationAddress, address _collectionAddress, uint256 _useCase) public view returns (address[] memory) {
573         bytes32 hash;
574         hash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
575         return (delegationAddressHashes[hash]);
576     }
577 
578     /**
579      * @notice Returns the status of a collection/delegation for a delegator (cold wallet)
580      * @notice false means that the cold wallet did not register a delegation or the delegation was revoked from the delegatorHashes mapping
581      */
582 
583     function retrieveDelegatorStatusOfDelegation(address _delegatorAddress, address _collectionAddress, uint256 _useCase) public view returns (bool) {
584         bytes32 hash;
585         hash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _useCase));
586         return delegatorHashes[hash].length > 0;
587     }
588 
589     /**
590      * @notice Returns the status of a collection/delegation given a delegation address (hot wallet)
591      * @notice false means that a delegation address is not registered or it was revoked from the delegationAddressHashes mapping
592      */
593 
594     function retrieveDelegationAddressStatusOfDelegation(address _delegationAddress, address _collectionAddress, uint256 _useCase) public view returns (bool) {
595         bytes32 hash;
596         hash = keccak256(abi.encodePacked(_delegationAddress, _collectionAddress, _useCase));
597         return delegationAddressHashes[hash].length > 0;
598     }
599 
600     /**
601      * @notice Returns the status of a delegation given the delegator address as well as the delegation address
602      */
603 
604     function retrieveGlobalStatusOfDelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _useCase) public view returns (bool) {
605         bytes32 hash;
606         hash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _delegationAddress, _useCase));
607         return globalDelegationHashes[hash].length > 0;
608     }
609 
610     /**
611      * @notice Returns the status of a delegation given the delegator address, the collection address, the delegation address as well as a specific token id
612      */
613 
614     function retrieveTokenStatus(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _useCase, uint256 _tokenId) public view returns (bool) {
615         bytes32 hash;
616         hash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, _delegationAddress, _useCase));
617         bool status;
618         if (globalDelegationHashes[hash].length > 0) {
619             for (uint256 i = 0; i < globalDelegationHashes[hash].length; ) {
620                 if ((globalDelegationHashes[hash][i].allTokens == false) && (globalDelegationHashes[hash][i].tokens == _tokenId)) {
621                     status = true;
622                     break;
623                 } else {
624                     status = false;
625                 }
626 
627                 unchecked {
628                     ++i;
629                 }
630             }
631             return status;
632         } else {
633             return false;
634         }
635     }
636 
637     /**
638      * @notice Checks if the delegation address performing actions is the most recent delegated by the specific delegator
639      */
640 
641     function retrieveStatusOfMostRecentDelegation(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _useCase) public view returns (bool) {
642         return _delegationAddress == retrieveMostRecentDelegation(_delegatorAddress, _collectionAddress, _useCase);
643     }
644 
645     /**
646      * @notice Checks if a delegator granted subdelegation status to an Address
647      */
648 
649     function retrieveSubDelegationStatus(address _delegatorAddress, address _collectionAddress, address _delegationAddress) public view returns (bool) {
650         bool subdelegationRights;
651         address[] memory allDelegators = retrieveDelegators(_delegationAddress, _collectionAddress, USE_CASE_SUB_DELEGATION);
652         if (allDelegators.length > 0) {
653             for (uint i = 0; i < allDelegators.length; ) {
654                 if (_delegatorAddress == allDelegators[i]) {
655                     subdelegationRights = true;
656                     break;
657                 }
658 
659                 unchecked {
660                     ++i;
661                 }
662             }
663         }
664         if (subdelegationRights == true) {
665             return (true);
666         } else {
667             return (false);
668         }
669     }
670 
671     /**
672      * @notice Checks the status of an active delegator for a delegation Address
673      */
674 
675     function retrieveStatusOfActiveDelegator(address _delegatorAddress, address _collectionAddress, address _delegationAddress, uint256 _date, uint256 _useCase) public view returns (bool) {
676         address[] memory allActiveDelegators = retrieveActiveDelegators(_delegationAddress, _collectionAddress, _date, _useCase);
677         bool status;
678         if (allActiveDelegators.length > 0) {
679             for (uint256 i = 0; i < allActiveDelegators.length; ) {
680                 if (_delegatorAddress == allActiveDelegators[i]) {
681                     status = true;
682                     break;
683                 } else {
684                     status = false;
685                 }
686 
687                 unchecked {
688                     ++i;
689                 }
690             }
691             return status;
692         } else {
693             return false;
694         }
695     }
696 
697     // Retrieve Delegations delegated by a Delegator
698     // This set of functions is used to retrieve info for a Delegator (cold address)
699 
700     function retrieveDelegationAddressesTokensIDsandExpiredDates(address _delegatorAddress, address _collectionAddress, uint256 _useCase) public view returns (address[] memory, uint256[] memory, bool[] memory, uint256[] memory) {
701         address[] memory allDelegations = retrieveDelegationAddresses(_delegatorAddress, _collectionAddress, _useCase);
702         bytes32 globalHash;
703         bytes32[] memory allGlobalHashes = new bytes32[](allDelegations.length);
704         uint256 count1 = 0;
705         uint256 count2 = 0;
706         uint256 k = 0;
707         if (allDelegations.length > 0) {
708             for (uint256 i = 0; i < allDelegations.length; ) {
709                 globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, allDelegations[i], _useCase));
710                 allGlobalHashes[count1] = globalHash;
711                 count1 = count1 + 1;
712 
713                 unchecked {
714                     ++i;
715                 }
716             }
717             //Removes duplicates
718             for (uint256 i = 0; i < allGlobalHashes.length - 1; ) {
719                 for (uint256 j = i + 1; j < allGlobalHashes.length; ) {
720                     if (allGlobalHashes[i] == allGlobalHashes[j]) {
721                         delete allGlobalHashes[i];
722                     }
723 
724                     unchecked {
725                         ++j;
726                     }
727                 }
728 
729                 unchecked {
730                     ++i;
731                 }
732             }
733             for (uint256 i = 0; i < allGlobalHashes.length; ) {
734                 k = globalDelegationHashes[allGlobalHashes[i]].length + k;
735 
736                 unchecked {
737                     ++i;
738                 }
739             }
740             //Declare local arrays
741             address[] memory allDelegationAddresses = new address[](k);
742             uint256[] memory tokensIDs = new uint256[](k);
743             bool[] memory allTokens = new bool[](k);
744             uint256[] memory allExpirations = new uint256[](k);
745             for (uint256 y = 0; y < k; ) {
746                 if (globalDelegationHashes[allGlobalHashes[y]].length > 0) {
747                     for (uint256 w = 0; w < globalDelegationHashes[allGlobalHashes[y]].length; ) {
748                         allDelegationAddresses[count2] = globalDelegationHashes[allGlobalHashes[y]][w].delegationAddress;
749                         allExpirations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].expiryDate;
750                         allTokens[count2] = globalDelegationHashes[allGlobalHashes[y]][w].allTokens;
751                         tokensIDs[count2] = globalDelegationHashes[allGlobalHashes[y]][w].tokens;
752                         count2 = count2 + 1;
753 
754                         unchecked {
755                             ++w;
756                         }
757                     }
758                 }
759 
760                 unchecked {
761                     ++y;
762                 }
763             }
764             return (allDelegationAddresses, allExpirations, allTokens, tokensIDs);
765         } else {
766             address[] memory allDelegations1 = new address[](0);
767             uint256[] memory tokensIDs = new uint256[](0);
768             bool[] memory allTokens = new bool[](0);
769             uint256[] memory allExpirations = new uint256[](0);
770             return (allDelegations1, allExpirations, allTokens, tokensIDs);
771         }
772     }
773 
774     /**
775      * @notice Returns an array of all active delegation addresses on a certain date for a specific use case on a specific NFT collection given a delegation Address
776      */
777 
778     function retrieveActiveDelegations(address _delegatorAddress, address _collectionAddress, uint256 _date, uint256 _useCase) public view returns (address[] memory) {
779         address[] memory allDelegations = retrieveDelegationAddresses(_delegatorAddress, _collectionAddress, _useCase);
780         bytes32 globalHash;
781         bytes32[] memory allGlobalHashes = new bytes32[](allDelegations.length);
782         uint256 count1 = 0;
783         uint256 count2 = 0;
784         uint256 count3 = 0;
785         uint256 k = 0;
786         if (allDelegations.length > 0) {
787             for (uint256 i = 0; i < allDelegations.length; ) {
788                 globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, allDelegations[i], _useCase));
789                 allGlobalHashes[count1] = globalHash;
790                 count1 = count1 + 1;
791 
792                 unchecked {
793                     ++i;
794                 }
795             }
796             //Remove duplicates
797             for (uint256 i = 0; i < allGlobalHashes.length - 1; ) {
798                 for (uint256 j = i + 1; j < allGlobalHashes.length; ) {
799                     if (allGlobalHashes[i] == allGlobalHashes[j]) {
800                         delete allGlobalHashes[i];
801                     }
802 
803                     unchecked {
804                         ++j;
805                     }
806                 }
807 
808                 unchecked {
809                     ++i;
810                 }
811             }
812             for (uint256 i = 0; i < allGlobalHashes.length; ) {
813                 k = globalDelegationHashes[allGlobalHashes[i]].length + k;
814 
815                 unchecked {
816                     ++i;
817                 }
818             }
819             //Declare local arrays
820             address[] memory allDelegationAddresses = new address[](k);
821             uint256[] memory allExpirations = new uint256[](k);
822             for (uint256 y = 0; y < k; ) {
823                 if (globalDelegationHashes[allGlobalHashes[y]].length > 0) {
824                     for (uint256 w = 0; w < globalDelegationHashes[allGlobalHashes[y]].length; ) {
825                         allDelegationAddresses[count2] = globalDelegationHashes[allGlobalHashes[y]][w].delegationAddress;
826                         allExpirations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].expiryDate;
827                         count2 = count2 + 1;
828 
829                         unchecked {
830                             ++w;
831                         }
832                     }
833                 }
834 
835                 unchecked {
836                     ++y;
837                 }
838             }
839             address[] memory allActive = new address[](allExpirations.length);
840             for (uint256 y = 0; y < k; ) {
841                 if (allExpirations[y] > _date) {
842                     allActive[count3] = allDelegationAddresses[y];
843                     count3 = count3 + 1;
844                 }
845 
846                 unchecked {
847                     ++y;
848                 }
849             }
850             return (allActive);
851         } else {
852             address[] memory allActive = new address[](0);
853             return (allActive);
854         }
855     }
856 
857     /**
858      * @notice Returns the most recent delegation address delegated for a specific use case on a specific NFT collection
859      */
860 
861     function retrieveMostRecentDelegation(address _delegatorAddress, address _collectionAddress, uint256 _useCase) public view returns (address) {
862         address[] memory allDelegations = retrieveDelegationAddresses(_delegatorAddress, _collectionAddress, _useCase);
863         bytes32 globalHash;
864         bytes32[] memory allGlobalHashes = new bytes32[](allDelegations.length);
865         uint256 count1 = 0;
866         uint256 count2 = 0;
867         uint256 k = 0;
868         if (allDelegations.length > 0) {
869             for (uint256 i = 0; i < allDelegations.length; ) {
870                 globalHash = keccak256(abi.encodePacked(_delegatorAddress, _collectionAddress, allDelegations[i], _useCase));
871                 allGlobalHashes[count1] = globalHash;
872                 count1 = count1 + 1;
873 
874                 unchecked {
875                     ++i;
876                 }
877             }
878             //Removes duplicates
879             for (uint256 i = 0; i < allGlobalHashes.length - 1; ) {
880                 for (uint256 j = i + 1; j < allGlobalHashes.length; ) {
881                     if (allGlobalHashes[i] == allGlobalHashes[j]) {
882                         delete allGlobalHashes[i];
883                     }
884 
885                     unchecked {
886                         ++j;
887                     }
888                 }
889 
890                 unchecked {
891                     ++i;
892                 }
893             }
894             for (uint256 i = 0; i < allGlobalHashes.length; ) {
895                 k = globalDelegationHashes[allGlobalHashes[i]].length + k;
896 
897                 unchecked {
898                     ++i;
899                 }
900             }
901             //Declare local arrays
902             address[] memory allDelegationAddresses = new address[](k);
903             uint256[] memory allRegistrations = new uint256[](k);
904             for (uint256 y = 0; y < k; ) {
905                 if (globalDelegationHashes[allGlobalHashes[y]].length > 0) {
906                     for (uint256 w = 0; w < globalDelegationHashes[allGlobalHashes[y]].length; ) {
907                         allDelegationAddresses[count2] = globalDelegationHashes[allGlobalHashes[y]][w].delegationAddress;
908                         allRegistrations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].registeredDate;
909                         count2 = count2 + 1;
910 
911                         unchecked {
912                             ++w;
913                         }
914                     }
915                 }
916 
917                 unchecked {
918                     ++y;
919                 }
920             }
921             address recentDelegationAddress = allDelegationAddresses[0];
922             uint256 time = allRegistrations[0];
923             for (uint256 i = 0; i < allDelegationAddresses.length; ) {
924                 if (allRegistrations[i] >= time) {
925                     time = allRegistrations[i];
926                     recentDelegationAddress = allDelegationAddresses[i];
927                 }
928 
929                 unchecked {
930                     ++i;
931                 }
932             }
933             return (recentDelegationAddress);
934         } else {
935             return (0x0000000000000000000000000000000000000000);
936         }
937     }
938 
939     // Retrieve Delegators delegated to a hot wallet
940     // This set of functions is used to retrieve info for a hot wallet
941 
942     /**
943      * @notice Returns an array of all token ids delegated by a Delegator for a specific usecase on specific collection given a delegation Address
944      */
945 
946     function retrieveDelegatorsTokensIDsandExpiredDates(address _delegationAddress, address _collectionAddress, uint256 _useCase) public view returns (address[] memory, uint256[] memory, bool[] memory, uint256[] memory) {
947         address[] memory allDelegators = retrieveDelegators(_delegationAddress, _collectionAddress, _useCase);
948         bytes32 globalHash;
949         bytes32[] memory allGlobalHashes = new bytes32[](allDelegators.length);
950         uint256 count1 = 0;
951         uint256 count2 = 0;
952         uint256 k = 0;
953         if (allDelegators.length > 0) {
954             for (uint256 i = 0; i < allDelegators.length; ) {
955                 globalHash = keccak256(abi.encodePacked(allDelegators[i], _collectionAddress, _delegationAddress, _useCase));
956                 allGlobalHashes[count1] = globalHash;
957                 count1 = count1 + 1;
958 
959                 unchecked {
960                     ++i;
961                 }
962             }
963             //Removes duplicates
964             for (uint256 i = 0; i < allGlobalHashes.length - 1; ) {
965                 for (uint256 j = i + 1; j < allGlobalHashes.length; ) {
966                     if (allGlobalHashes[i] == allGlobalHashes[j]) {
967                         delete allGlobalHashes[i];
968                     }
969 
970                     unchecked {
971                         ++j;
972                     }
973                 }
974 
975                 unchecked {
976                     ++i;
977                 }
978             }
979             for (uint256 i = 0; i < allGlobalHashes.length; ) {
980                 k = globalDelegationHashes[allGlobalHashes[i]].length + k;
981 
982                 unchecked {
983                     ++i;
984                 }
985             }
986             //Declare local arrays
987             address[] memory allDelegatorsAddresses = new address[](k);
988             uint256[] memory tokensIDs = new uint256[](k);
989             bool[] memory allTokens = new bool[](k);
990             uint256[] memory allExpirations = new uint256[](k);
991             for (uint256 y = 0; y < k; ) {
992                 if (globalDelegationHashes[allGlobalHashes[y]].length > 0) {
993                     for (uint256 w = 0; w < globalDelegationHashes[allGlobalHashes[y]].length; ) {
994                         allDelegatorsAddresses[count2] = globalDelegationHashes[allGlobalHashes[y]][w].delegatorAddress;
995                         allExpirations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].expiryDate;
996                         allTokens[count2] = globalDelegationHashes[allGlobalHashes[y]][w].allTokens;
997                         tokensIDs[count2] = globalDelegationHashes[allGlobalHashes[y]][w].tokens;
998                         count2 = count2 + 1;
999 
1000                         unchecked {
1001                             ++w;
1002                         }
1003                     }
1004                 }
1005 
1006                 unchecked {
1007                     ++y;
1008                 }
1009             }
1010             return (allDelegatorsAddresses, allExpirations, allTokens, tokensIDs);
1011         } else {
1012             address[] memory allDelegations1 = new address[](0);
1013             uint256[] memory tokensIDs = new uint256[](0);
1014             bool[] memory allTokens = new bool[](0);
1015             uint256[] memory allExpirations = new uint256[](0);
1016             return (allDelegations1, allExpirations, allTokens, tokensIDs);
1017         }
1018     }
1019 
1020     /**
1021      * @notice Returns an array of all active delegators on a certain date for a specific use case on a specific NFT collection given a delegation Address
1022      */
1023 
1024     function retrieveActiveDelegators(address _delegationAddress, address _collectionAddress, uint256 _date, uint256 _useCase) public view returns (address[] memory) {
1025         address[] memory allDelegators = retrieveDelegators(_delegationAddress, _collectionAddress, _useCase);
1026         bytes32 globalHash;
1027         bytes32[] memory allGlobalHashes = new bytes32[](allDelegators.length);
1028         uint256 count1 = 0;
1029         uint256 count2 = 0;
1030         uint256 count3 = 0;
1031         uint256 k = 0;
1032         if (allDelegators.length > 0) {
1033             for (uint256 i = 0; i < allDelegators.length; ) {
1034                 globalHash = keccak256(abi.encodePacked(allDelegators[i], _collectionAddress, _delegationAddress, _useCase));
1035                 allGlobalHashes[count1] = globalHash;
1036                 count1 = count1 + 1;
1037 
1038                 unchecked {
1039                     ++i;
1040                 }
1041             }
1042             //Remove duplicates
1043             for (uint256 i = 0; i < allGlobalHashes.length - 1; ) {
1044                 for (uint256 j = i + 1; j < allGlobalHashes.length; ) {
1045                     if (allGlobalHashes[i] == allGlobalHashes[j]) {
1046                         delete allGlobalHashes[i];
1047                     }
1048 
1049                     unchecked {
1050                         ++j;
1051                     }
1052                 }
1053 
1054                 unchecked {
1055                     ++i;
1056                 }
1057             }
1058             for (uint256 i = 0; i < allGlobalHashes.length; ) {
1059                 k = globalDelegationHashes[allGlobalHashes[i]].length + k;
1060 
1061                 unchecked {
1062                     ++i;
1063                 }
1064             }
1065             //Declare local arrays
1066             address[] memory allDelegatorsAddresses = new address[](k);
1067             uint256[] memory allExpirations = new uint256[](k);
1068             for (uint256 y = 0; y < k; ) {
1069                 if (globalDelegationHashes[allGlobalHashes[y]].length > 0) {
1070                     for (uint256 w = 0; w < globalDelegationHashes[allGlobalHashes[y]].length; ) {
1071                         allDelegatorsAddresses[count2] = globalDelegationHashes[allGlobalHashes[y]][w].delegatorAddress;
1072                         allExpirations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].expiryDate;
1073                         count2 = count2 + 1;
1074 
1075                         unchecked {
1076                             ++w;
1077                         }
1078                     }
1079                 }
1080 
1081                 unchecked {
1082                     ++y;
1083                 }
1084             }
1085             address[] memory allActive = new address[](allExpirations.length);
1086             for (uint256 y = 0; y < k; ) {
1087                 if (allExpirations[y] > _date) {
1088                     allActive[count3] = allDelegatorsAddresses[y];
1089                     count3 = count3 + 1;
1090                 }
1091 
1092                 unchecked {
1093                     ++y;
1094                 }
1095             }
1096             return (allActive);
1097         } else {
1098             address[] memory allActive = new address[](0);
1099             return (allActive);
1100         }
1101     }
1102 
1103     /**
1104      * @notice Returns the most recent delegator for a specific use case on a specific NFT collection given a delegation Address
1105      */
1106 
1107     function retrieveMostRecentDelegator(address _delegationAddress, address _collectionAddress, uint256 _useCase) public view returns (address) {
1108         address[] memory allDelegators = retrieveDelegators(_delegationAddress, _collectionAddress, _useCase);
1109         bytes32 globalHash;
1110         bytes32[] memory allGlobalHashes = new bytes32[](allDelegators.length);
1111         uint256 count1 = 0;
1112         uint256 count2 = 0;
1113         uint256 k = 0;
1114         if (allDelegators.length > 0) {
1115             for (uint256 i = 0; i < allDelegators.length; ) {
1116                 globalHash = keccak256(abi.encodePacked(allDelegators[i], _collectionAddress, _delegationAddress, _useCase));
1117                 allGlobalHashes[count1] = globalHash;
1118                 count1 = count1 + 1;
1119 
1120                 unchecked {
1121                     ++i;
1122                 }
1123             }
1124             //Removes duplicates
1125             for (uint256 i = 0; i < allGlobalHashes.length - 1; ) {
1126                 for (uint256 j = i + 1; j < allGlobalHashes.length; ) {
1127                     if (allGlobalHashes[i] == allGlobalHashes[j]) {
1128                         delete allGlobalHashes[i];
1129                     }
1130 
1131                     unchecked {
1132                         ++j;
1133                     }
1134                 }
1135 
1136                 unchecked {
1137                     ++i;
1138                 }
1139             }
1140             for (uint256 i = 0; i < allGlobalHashes.length; ) {
1141                 k = globalDelegationHashes[allGlobalHashes[i]].length + k;
1142 
1143                 unchecked {
1144                     ++i;
1145                 }
1146             }
1147             //Declare local arrays
1148             address[] memory allDelegatorsAddresses = new address[](k);
1149             uint256[] memory allRegistrations = new uint256[](k);
1150             for (uint256 y = 0; y < k; ) {
1151                 if (globalDelegationHashes[allGlobalHashes[y]].length > 0) {
1152                     for (uint256 w = 0; w < globalDelegationHashes[allGlobalHashes[y]].length; ) {
1153                         allDelegatorsAddresses[count2] = globalDelegationHashes[allGlobalHashes[y]][w].delegatorAddress;
1154                         allRegistrations[count2] = globalDelegationHashes[allGlobalHashes[y]][w].registeredDate;
1155                         count2 = count2 + 1;
1156 
1157                         unchecked {
1158                             ++w;
1159                         }
1160                     }
1161                 }
1162 
1163                 unchecked {
1164                     ++y;
1165                 }
1166             }
1167             address recentDelegatorAddress = allDelegatorsAddresses[0];
1168             uint256 time = allRegistrations[0];
1169             for (uint256 i = 0; i < allDelegatorsAddresses.length; ) {
1170                 if (allRegistrations[i] >= time) {
1171                     time = allRegistrations[i];
1172                     recentDelegatorAddress = allDelegatorsAddresses[i];
1173                 }
1174 
1175                 unchecked {
1176                     ++i;
1177                 }
1178             }
1179             return (recentDelegatorAddress);
1180         } else {
1181             return (0x0000000000000000000000000000000000000000);
1182         }
1183     }
1184 
1185     /**
1186      * @notice This function checks the Consolidation status between 2 addresses
1187      */
1188 
1189     function checkConsolidationStatus(address _wallet1, address _wallet2, address _collectionAddress) public view returns (bool) {
1190         bool wallet1HasWallet2Consolidation = retrieveGlobalStatusOfDelegation(_wallet1, _collectionAddress, _wallet2, USE_CASE_CONSOLIDATION);
1191         bool wallet2HasWallet1Consolidation = retrieveGlobalStatusOfDelegation(_wallet2, _collectionAddress, _wallet1, USE_CASE_CONSOLIDATION);
1192         bool wallet1HasWallet2ConsolidationAll = retrieveGlobalStatusOfDelegation(_wallet1, ALL_COLLECTIONS, _wallet2, USE_CASE_CONSOLIDATION);
1193         bool wallet2HasWallet1ConsolidationAll = retrieveGlobalStatusOfDelegation(_wallet2, ALL_COLLECTIONS, _wallet1, USE_CASE_CONSOLIDATION);
1194         if (wallet1HasWallet2Consolidation == true && wallet2HasWallet1Consolidation == true) {
1195             return true;
1196         } else if (wallet1HasWallet2Consolidation == true && wallet2HasWallet1ConsolidationAll == true) {
1197             return true;
1198         } else if (wallet2HasWallet1Consolidation == true && wallet1HasWallet2ConsolidationAll == true) {
1199             return true;
1200         } else if (wallet1HasWallet2ConsolidationAll ==  true && wallet2HasWallet1ConsolidationAll == true) {
1201             return true;
1202         } else {
1203         return false;
1204         }
1205     }
1206 
1207 }