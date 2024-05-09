1 pragma solidity ^0.4.19;
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract CSCERC721 {
8   // Required methods
9   function balanceOf(address _owner) public view returns (uint256 balance) { 
10       return 0;
11       
12   }
13   function ownerOf(uint256 _tokenId) public view returns (address owner) { return;}
14 
15   function getCollectibleDetails(uint256 _assetId) external view returns(uint256 assetId, uint256 sequenceId, uint256 collectibleType, uint256 collectibleClass, bool isRedeemed, address owner) {
16         assetId = 0;
17         sequenceId = 0;
18         collectibleType = 0;
19         collectibleClass = 0;
20         owner = 0;
21         isRedeemed = false;
22   }
23 
24    function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
25         return;
26    }
27 
28 }
29 
30 contract CSCFactoryERC721 {
31     
32     function ownerOf(uint256 _tokenId) public view returns (address owner) { return;}
33 
34     function getCollectibleDetails(uint256 _tokenId) external view returns(uint256 assetId, uint256 sequenceId, uint256 collectibleType, uint256 collectibleClass, bytes32 collectibleName, bool isRedeemed, address owner) {
35 
36         assetId = 0;
37         sequenceId = 0;
38         collectibleType = 0;
39         collectibleClass = 0;
40         owner = 0;
41         collectibleName = 0x0;
42         isRedeemed = false;
43     }
44 
45     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
46         return;
47    }
48 }
49 
50 contract ERC20 {
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53 }
54 
55 contract CSCResourceFactory {
56     mapping(uint16 => address) public resourceIdToAddress; 
57 }
58 
59 
60 contract MEAHiddenLogic {
61 
62 
63     function getTotalTonsClaimed() external view returns(uint32) {
64         return;
65     }
66 
67     function getTotalSupply() external view returns(uint32) {
68         return;
69     }
70 
71      function getStarTotalSupply(uint8 _starId) external view returns(uint32) {
72         return;
73     }
74 
75     function getReturnTime(uint256 _assetId) external view returns(uint256 time) {
76         return;
77     }
78 
79     //uint256 iron, uint256 quartz, uint256 nickel, uint256 cobalt, uint256 silver, uint256 titanium, uint256 lucinite, uint256 gold, uint256 cosmethyst, uint256 allurum,  uint256 platinum,  uint256 trilite 
80     function setResourceForStar(uint8[5] _resourceTypes, uint16[5] _resourcePer, uint32[5] _resourceAmounts) public returns(uint8 starId) {
81     }
82 
83     
84     /// @dev Method to fetch collected ore details
85     function getAssetCollectedOreBallances(uint256 _assetID) external view returns(uint256 iron, uint256 quartz, uint256 nickel, uint256 cobalt, uint256 silver, uint256 titanium, uint256 lucinite, uint256 gold, uint256 cosmethyst, uint256 allurum,  uint256 platinum,  uint256 trilite);
86 
87     function getAssetCollectedOreBallancesArray(uint256 _assetID) external view returns(uint256[12] ores);
88 
89     function emptyShipCargo(uint32 _assetId) external;
90 
91      /// @dev For creating CSC Collectible
92     function startMEAMission(uint256 _assetId, uint256 oreMax, uint8 starId, uint256 _travelTime) public returns(uint256);
93 
94     
95 }
96 
97 /* Controls state and access rights for contract functions
98  * @title Operational Control
99  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
100  * Inspired and adapted from contract created by OpenZeppelin
101  * Ref: https://github.com/OpenZeppelin/zeppelin-solidity/
102  */
103 contract OperationalControl {
104     // Facilitates access & control for the game.
105     // Roles:
106     //  -The Managers (Primary/Secondary): Has universal control of all elements (No ability to withdraw)
107     //  -The Banker: The Bank can withdraw funds and adjust fees / prices.
108     //  -otherManagers: Contracts that need access to functions for gameplay
109 
110     /// @dev Emited when contract is upgraded
111     event ContractUpgrade(address newContract);
112 
113     /// @dev Emited when other manager is set
114     event OtherManagerUpdated(address otherManager, uint256 state);
115 
116     // The addresses of the accounts (or contracts) that can execute actions within each roles.
117     address public managerPrimary;
118     address public managerSecondary;
119     address public bankManager;
120 
121     // Contracts that require access for gameplay
122     mapping(address => uint8) public otherManagers;
123 
124     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
125     bool public paused = false;
126 
127     // @dev Keeps track whether the contract erroredOut. When that is true, most actions are blocked & refund can be claimed
128     bool public error = false;
129 
130     /// @dev Operation modifiers for limiting access
131     modifier onlyManager() {
132         require(msg.sender == managerPrimary || msg.sender == managerSecondary);
133         _;
134     }
135 
136     modifier onlyBanker() {
137         require(msg.sender == bankManager);
138         _;
139     }
140 
141     modifier onlyOtherManagers() {
142         require(otherManagers[msg.sender] == 1);
143         _;
144     }
145 
146 
147     modifier anyOperator() {
148         require(
149             msg.sender == managerPrimary ||
150             msg.sender == managerSecondary ||
151             msg.sender == bankManager ||
152             otherManagers[msg.sender] == 1
153         );
154         _;
155     }
156 
157     /// @dev Assigns a new address to act as the Other Manager. (State = 1 is active, 0 is disabled)
158     function setOtherManager(address _newOp, uint8 _state) external onlyManager {
159         require(_newOp != address(0));
160 
161         otherManagers[_newOp] = _state;
162 
163         OtherManagerUpdated(_newOp,_state);
164     }
165 
166     /// @dev Assigns a new address to act as the Primary Manager.
167     function setPrimaryManager(address _newGM) external onlyManager {
168         require(_newGM != address(0));
169 
170         managerPrimary = _newGM;
171     }
172 
173     /// @dev Assigns a new address to act as the Secondary Manager.
174     function setSecondaryManager(address _newGM) external onlyManager {
175         require(_newGM != address(0));
176 
177         managerSecondary = _newGM;
178     }
179 
180     /// @dev Assigns a new address to act as the Banker.
181     function setBanker(address _newBK) external onlyManager {
182         require(_newBK != address(0));
183 
184         bankManager = _newBK;
185     }
186 
187     /*** Pausable functionality adapted from OpenZeppelin ***/
188 
189     /// @dev Modifier to allow actions only when the contract IS NOT paused
190     modifier whenNotPaused() {
191         require(!paused);
192         _;
193     }
194 
195     /// @dev Modifier to allow actions only when the contract IS paused
196     modifier whenPaused {
197         require(paused);
198         _;
199     }
200 
201     /// @dev Modifier to allow actions only when the contract has Error
202     modifier whenError {
203         require(error);
204         _;
205     }
206 
207     /// @dev Called by any Operator role to pause the contract.
208     /// Used only if a bug or exploit is discovered (Here to limit losses / damage)
209     function pause() external onlyManager whenNotPaused {
210         paused = true;
211     }
212 
213     /// @dev Unpauses the smart contract. Can only be called by the Game Master
214     /// @notice This is public rather than external so it can be called by derived contracts. 
215     function unpause() public onlyManager whenPaused {
216         // can't unpause if contract was upgraded
217         paused = false;
218     }
219 
220     /// @dev Unpauses the smart contract. Can only be called by the Game Master
221     /// @notice This is public rather than external so it can be called by derived contracts. 
222     function hasError() public onlyManager whenPaused {
223         error = true;
224     }
225 
226     /// @dev Unpauses the smart contract. Can only be called by the Game Master
227     /// @notice This is public rather than external so it can be called by derived contracts. 
228     function noError() public onlyManager whenPaused {
229         error = false;
230     }
231 }
232 
233 contract MEAManager is OperationalControl {
234 
235     /*** EVENTS ***/
236 
237     /*** CONSTANTS ***/
238     uint256 public constant REAPER_INTREPID = 3; 
239     uint256 public constant REAPER_INTREPID_EXTRACTION_BASE = 10; // tons per hour of mining
240     uint256 public constant REAPER_INTREPID_FTL_SPEED = 900; // Seconds to travel 1 light year
241     uint256 public constant REAPER_INTREPID_MAX_CARGO = 320;
242 
243     uint256 public constant PHOENIX_CORSAIR = 2;
244     uint256 public constant PHOENIX_CORSAIR_EXTRACTION_BASE = 40; // tons per hour of mining
245     uint256 public constant PHOENIX_CORSAIR_FTL_SPEED = 1440; // Seconds to travel 1 light year
246     uint256 public constant PHOENIX_CORSAIR_MAX_CARGO = 1500;
247 
248     uint256 public constant VULCAN_PROMETHEUS = 1;
249     uint256 public constant VULCAN_PROMETHEUS_EXTRACTION_BASE = 300; // tons per hour of mining
250     uint256 public constant VULCAN_PROMETHEUS_FTL_SPEED = 2057; // Seconds to travel 1 light year
251     uint256 public constant VULCAN_PROMETHEUS_MAX_CARGO = 6000; 
252 
253     uint256 public constant SIGMA = 4;
254     uint256 public constant SIGMA_EXTRACTION_BASE = 150; // tons per hour of mining
255     uint256 public constant SIGMA_FTL_SPEED = 4235; // Seconds to travel 1 light year
256     uint256 public constant SIGMA_MAX_CARGO = 15000; 
257 
258     uint256 public constant HAYATO = 5;
259     uint256 public constant HAYATO_EXTRACTION_BASE = 150; // tons per hour of mining
260     uint256 public constant HAYATO_FTL_SPEED = 360; // Seconds to travel 1 light year
261     uint256 public constant HAYATO_MAX_CARGO = 1500; 
262 
263     uint256 public constant CPGPEREGRINE = 6;
264     uint256 public constant CPGPEREGRINE_EXTRACTION_BASE = 150; // tons per hour of mining
265     uint256 public constant CPGPEREGRINE_FTL_SPEED = 720; // Seconds to travel 1 light year
266     uint256 public constant CPGPEREGRINE_MAX_CARGO = 4000; 
267 
268     uint256 public constant TACTICALCRUISER = 7;
269     uint256 public constant TACTICALCRUISER_EXTRACTION_BASE = 150; // tons per hour of mining
270     uint256 public constant TACTICALCRUISER_FTL_SPEED = 720; // Seconds to travel 1 light year
271     uint256 public constant TACTICALCRUISER_MAX_CARGO = 1000;
272 
273     uint256 public constant OTHERCRUISER = 8;
274     uint256 public constant OTHERCRUISER_EXTRACTION_BASE = 100; // tons per hour of mining
275     uint256 public constant OTHERCRUISER_FTL_SPEED = 720; // Seconds to travel 1 light year
276     uint256 public constant OTHERCRUISER_MAX_CARGO = 1500;  
277 
278     uint256 public constant VULCAN_POD = 9;
279     uint256 public constant VULCAN_POD_EXTRACTION_BASE = 1; // tons per hour of mining
280     uint256 public constant VULCAN_POD_FTL_SPEED = 2000; // Seconds to travel 1 light year
281     uint256 public constant VULCAN_POD_MAX_CARGO = 75;  
282 
283     //For Devs to Travel Around
284     uint256 public constant DEVCLASS = 99;
285     uint256 public constant DEVCLASS_EXTRACTION_BASE = 50; // tons per hour of mining
286     uint256 public constant DEVCLASS_FTL_SPEED = 10; // Seconds to travel 1 light year
287     uint256 public constant DEVCLASS_MAX_CARGO = 500; 
288     
289     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
290     string public constant NAME = "MEAGameManager";
291 
292     /*** Mappings ***/
293 
294      /// @dev assetID to ore type to qty collected
295     mapping(uint32 => mapping(uint8 => uint32)) public collectedOreAssetMapping;
296 
297     /// @dev owner address to ore type to qty collected
298     mapping(address => mapping(uint8 => uint32)) public collectedOreBalanceMapping;
299 
300     /// @dev owner address to ore type to qty collected
301     mapping(address => mapping(uint8 => uint32)) public distributedOreBalanceMapping;
302 
303     /// @dev assetID to number of MEA trips it has completed
304     mapping(uint32 => uint32) public assetIdNumberOfTripsMapping;
305 
306     /// @dev assetID to ore type to qty collected
307     mapping(uint8 => uint16) public starLightyearDistanceMapping;
308 
309     /// @dev assetID to last star visited
310     mapping(uint32 => uint8) public assetIdToStarVisitedMapping;
311 
312     /// @dev assetID to last star visited
313     mapping(uint16 => address) public resourceERC20Address;
314 
315     /// @dev assetID to Start Time of Current Trip
316     mapping(uint32 => uint32) public assetIdCurrentTripStartTimeMapping;
317 
318 
319     /*** Variables ***/
320     uint256 public miningTimePerTrip = 3600; // 3600 for 1 hour 10
321     uint256 public aimeIncreasePerTrip = 2500; // 25.00
322 
323     address cscERC721Address;
324     address cscFactoryERC721Address;
325     address hiddenLogicAddress;
326  
327 
328     function MEAManager() public {
329         require(msg.sender != address(0));
330         paused = true; 
331         managerPrimary = msg.sender;
332         managerSecondary = msg.sender;
333         bankManager = msg.sender;
334         cscERC721Address = address(0xe4f5e0d5c033f517a943602df942e794a06bc123);
335         cscFactoryERC721Address = address(0xcc9a66acf8574141b0e025202dd57649765a4be7);
336     }
337 
338     /*** Management Functions ***/
339 
340     /// @dev Set HiddenLogic
341     function setHiddenLogic(address _hiddenLogicAddress) public onlyManager {
342         hiddenLogicAddress = _hiddenLogicAddress;
343     }
344 
345     /// @dev Set HiddenLogic
346     function setResourceERC20Address(uint16 _resId, address _reourceAddress) public onlyManager {
347         resourceERC20Address[_resId] = _reourceAddress;
348     }
349 
350     /// @dev Set HiddenLogic
351     function setAllResourceERC20Addresses(address _master) public onlyManager {
352         CSCResourceFactory factory = CSCResourceFactory(_master);
353         for(uint8 i = 0; i < 12; i++) {
354             resourceERC20Address[i] = factory.resourceIdToAddress(i);
355         }
356     }
357 
358     /// @dev Set CSCErc721 Contract
359     function setCSCERC721(address _cscERC721Address) public onlyManager {
360         cscERC721Address = _cscERC721Address;
361     }
362 
363      /// @dev Set CSCFactoryErc721 Contract
364     function setCSCFactoryERC721(address _cscFactoryERC721Address) public onlyManager {
365         cscFactoryERC721Address = _cscFactoryERC721Address;
366     }
367 
368     /// @dev Set / Modify Lightyear Distance 3.456 ly = 3456
369     function setStarDistance(uint8 _starId, uint16 _lightyearsInThousands) public anyOperator {
370         starLightyearDistanceMapping[_starId] = _lightyearsInThousands;
371     }
372 
373     /// @dev Set / Modify MEA Game Attributes
374     function setMEAAttributes(uint256 _aime, uint256 _miningTime) public onlyManager {
375         aimeIncreasePerTrip = _aime;
376         miningTimePerTrip = _miningTime;
377     }
378 
379     /// @dev Withdraw Remaining Resource Tokens
380     function reclaimResourceDeposits(address _withdrawAddress) public onlyManager {
381         require(_withdrawAddress != address(0));
382         for(uint8 ii = 0; ii < 12; ii++) {
383             if(resourceERC20Address[ii] != 0) {
384                 ERC20 resCont = ERC20(resourceERC20Address[ii]);
385                 uint256 bal = resCont.balanceOf(this);
386                 resCont.transfer(_withdrawAddress, bal);
387             }
388         }
389     }
390 
391     /*** Public Functions ***/
392 
393      /// @dev Get Current Cargo Hold of AssetId (item names)
394     function getAssetIdCargo(uint32 _assetId) public view returns(uint256 iron, uint256 quartz, uint256 nickel, uint256 cobalt, uint256 silver, uint256 titanium, uint256 lucinite, uint256 gold, uint256 cosmethyst, uint256 allurum,  uint256 platinum,  uint256 trilite) {
395         uint256[12] memory _ores = getAssetIdCargoArray(_assetId);
396         iron = _ores[0];
397         quartz = _ores[1];
398         nickel = _ores[2];
399         cobalt = _ores[3];
400         silver = _ores[4];
401         titanium = _ores[5];
402         lucinite = _ores[6];
403         gold = _ores[7];
404         cosmethyst = _ores[8];
405         allurum = _ores[9];
406         platinum = _ores[10];
407         trilite = _ores[11];
408     }
409 
410     // function getAllShipStats(uint32[] _shipIds) public view returns(uint32[] results) {
411     //     //loop all results
412     //     for(uint i = 0; i < _shipIds.length; i++) {
413     //         results[]];
414     //     }
415 
416     // }
417 
418     /// @dev Get Current Cargo Hold of AssetId (array)
419     function getAssetIdCargoArray (uint32 _assetId) public view returns(uint256[12])  {
420         MEAHiddenLogic logic = MEAHiddenLogic(hiddenLogicAddress);
421         return logic.getAssetCollectedOreBallancesArray(_assetId);
422     }
423 
424     /// @dev Get AssetId Trip Completed Time
425     function getAssetIdTripCompletedTime(uint256 _assetId) external view returns(uint256 time) {
426         MEAHiddenLogic logic = MEAHiddenLogic(hiddenLogicAddress);
427         return logic.getReturnTime(uint32(_assetId));
428     }
429 
430     /// @dev Get AssetId Trip Completed Time
431     function getAssetIdTripStartTime(uint256 _assetId) external view returns(uint256 time) {
432 
433         return assetIdCurrentTripStartTimeMapping[uint32(_assetId)];
434     }
435 
436     function getLastStarOfAssetId(uint32 _assetId) public view returns(uint8 starId){
437         return assetIdToStarVisitedMapping[_assetId];
438     }
439 
440     /// @dev Get Resource Address
441     function getResourceERC20Address(uint16 _resId) public view returns(address resourceContract) {
442         return resourceERC20Address[_resId];
443     }
444 
445     /// @dev Get Time
446     function getMEATime() external view returns(uint256 time) {
447         return now;
448     }
449 
450     /// @dev Method to fetch processed ore details
451     function getCollectedOreBalances(address _owner) external view returns(uint256 iron, uint256 quartz, uint256 nickel, uint256 cobalt, uint256 silver, uint256 titanium, uint256 lucinite, uint256 gold, uint256 cosmethyst, uint256 allurum,  uint256 platinum,  uint256 trilite) {
452 
453         iron = collectedOreBalanceMapping[_owner][0];
454         quartz = collectedOreBalanceMapping[_owner][1];
455         nickel = collectedOreBalanceMapping[_owner][2];
456         cobalt = collectedOreBalanceMapping[_owner][3];
457         silver = collectedOreBalanceMapping[_owner][4];
458         titanium = collectedOreBalanceMapping[_owner][5];
459         lucinite = collectedOreBalanceMapping[_owner][6];
460         gold = collectedOreBalanceMapping[_owner][7];
461         cosmethyst = collectedOreBalanceMapping[_owner][8];
462         allurum = collectedOreBalanceMapping[_owner][9];
463         platinum = collectedOreBalanceMapping[_owner][10];
464         trilite = collectedOreBalanceMapping[_owner][11];
465     }
466 
467     /// @dev Method to fetch processed ore details
468     function getDistributedOreBalances(address _owner) external view returns(uint256 iron, uint256 quartz, uint256 nickel, uint256 cobalt, uint256 silver, uint256 titanium, uint256 lucinite, uint256 gold, uint256 cosmethyst, uint256 allurum,  uint256 platinum,  uint256 trilite) {
469 
470         iron = distributedOreBalanceMapping[_owner][0];
471         quartz = distributedOreBalanceMapping[_owner][1];
472         nickel = distributedOreBalanceMapping[_owner][2];
473         cobalt = distributedOreBalanceMapping[_owner][3];
474         silver = distributedOreBalanceMapping[_owner][4];
475         titanium = distributedOreBalanceMapping[_owner][5];
476         lucinite = distributedOreBalanceMapping[_owner][6];
477         gold = distributedOreBalanceMapping[_owner][7];
478         cosmethyst = distributedOreBalanceMapping[_owner][8];
479         allurum = distributedOreBalanceMapping[_owner][9];
480         platinum = distributedOreBalanceMapping[_owner][10];
481         trilite = distributedOreBalanceMapping[_owner][11];
482     }
483 
484     function withdrawCollectedResources() public {
485 
486         for(uint8 ii = 0; ii < 12; ii++) {
487             require(resourceERC20Address[ii] != address(0));
488             uint32 oreOutstanding = collectedOreBalanceMapping[msg.sender][ii] - distributedOreBalanceMapping[msg.sender][ii];
489             if(oreOutstanding > 0) {
490                 ERC20 resCont = ERC20(resourceERC20Address[ii]);
491                 distributedOreBalanceMapping[msg.sender][ii] += oreOutstanding;
492                 resCont.transfer(msg.sender, oreOutstanding);
493             }
494         }
495 
496     }
497 
498     //Gets star distance in thousandths of ly
499     function getStarDistanceInLyThousandths(uint8 _starId) public view returns (uint32 total) {
500         return starLightyearDistanceMapping[_starId];
501     }
502     
503     //Gets total resources already claimed by commanders
504     function totalMEATonsClaimed() public view returns (uint32 total) {
505         MEAHiddenLogic logic = MEAHiddenLogic(hiddenLogicAddress);
506         return logic.getTotalTonsClaimed();
507     }
508 
509     //Gets total seeded supply commanders
510     function totalMEATonsSupply() public view returns (uint32 total) {
511         MEAHiddenLogic logic = MEAHiddenLogic(hiddenLogicAddress);
512         return logic.getTotalSupply();
513     }
514 
515      function totalStarSupplyRemaining(uint8 _starId) external view returns(uint32) {
516         MEAHiddenLogic logic = MEAHiddenLogic(hiddenLogicAddress);
517         return logic.getStarTotalSupply(_starId);
518     }
519 
520     function claimOreOnlyFromAssetId(uint256 _assetId) {
521         uint256 collectibleClass = 0;
522         address shipOwner;
523         (collectibleClass, shipOwner) = _getShipInfo(_assetId);
524 
525          require(shipOwner == msg.sender);
526 
527         _claimOreAndClear(uint32(_assetId), 0);
528     }
529     /// @dev For creating CSC Collectible
530     function launchShipOnMEA(uint256 _assetId, uint8 starId) public whenNotPaused returns(uint256) {
531         
532         MEAHiddenLogic logic = MEAHiddenLogic(hiddenLogicAddress);
533 
534         uint256 collectibleClass = 0;
535         address shipOwner;
536 
537         (collectibleClass, shipOwner) = _getShipInfo(_assetId);
538 
539         //Check if the ship owner is sender
540         require(shipOwner == msg.sender);
541 
542         //Check if ship is back at earth
543         require(now > logic.getReturnTime(_assetId));
544         
545         //Claims ore and clears
546         _claimOreAndClear(uint32(_assetId), starId);
547 
548         //Get Asset Stats
549         uint tripCount = assetIdNumberOfTripsMapping[uint32(_assetId)];
550         uint starTripDist = starLightyearDistanceMapping[starId];
551         uint256 oreMax = 5;
552         uint256 tripSeconds = 10;
553 
554         if(collectibleClass == REAPER_INTREPID) {
555             oreMax = REAPER_INTREPID_EXTRACTION_BASE + (REAPER_INTREPID_EXTRACTION_BASE * tripCount * aimeIncreasePerTrip / 10000);
556             tripSeconds = REAPER_INTREPID_FTL_SPEED * starTripDist / 1000; // 4LPH - 900 seconds per light year
557             if(oreMax > REAPER_INTREPID_MAX_CARGO)
558                 oreMax = REAPER_INTREPID_MAX_CARGO;
559         }
560         else if(collectibleClass == PHOENIX_CORSAIR) {
561             oreMax = PHOENIX_CORSAIR_EXTRACTION_BASE + (PHOENIX_CORSAIR_EXTRACTION_BASE * tripCount * aimeIncreasePerTrip / 10000);
562             tripSeconds = PHOENIX_CORSAIR_FTL_SPEED * starTripDist / 1000; // 2.5LPH - 1440 seconds per light year
563             if(oreMax > PHOENIX_CORSAIR_MAX_CARGO)
564                 oreMax = PHOENIX_CORSAIR_MAX_CARGO;
565         }
566         else if(collectibleClass == VULCAN_PROMETHEUS) {
567             oreMax = VULCAN_PROMETHEUS_EXTRACTION_BASE + (VULCAN_PROMETHEUS_EXTRACTION_BASE * tripCount * aimeIncreasePerTrip / 10000);
568             tripSeconds = VULCAN_PROMETHEUS_FTL_SPEED * starTripDist / 1000; // 1.75LPH - 2057 seconds per light year
569             if(oreMax > VULCAN_PROMETHEUS_MAX_CARGO)
570                 oreMax = VULCAN_PROMETHEUS_MAX_CARGO;
571         }
572         else if(collectibleClass == SIGMA) {
573             oreMax = SIGMA_EXTRACTION_BASE + (SIGMA_EXTRACTION_BASE * tripCount * aimeIncreasePerTrip / 10000);
574             tripSeconds = SIGMA_FTL_SPEED * starTripDist / 1000; // 0.85LPH - 4235 seconds per light year
575             if(oreMax > SIGMA_MAX_CARGO)
576                 oreMax = SIGMA_MAX_CARGO;
577         }
578         else if(collectibleClass == HAYATO) { //Hayato
579             oreMax = HAYATO_EXTRACTION_BASE + (HAYATO_EXTRACTION_BASE * tripCount * aimeIncreasePerTrip / 10000);
580             tripSeconds = HAYATO_FTL_SPEED * starTripDist / 1000; // 10LPH - 360 seconds per light year
581             if(oreMax > HAYATO_MAX_CARGO)
582                 oreMax = HAYATO_MAX_CARGO;
583         }
584         else if(collectibleClass == CPGPEREGRINE) { //CPG Peregrine
585             oreMax = CPGPEREGRINE_EXTRACTION_BASE + (CPGPEREGRINE_EXTRACTION_BASE * tripCount * aimeIncreasePerTrip / 10000);
586             tripSeconds = CPGPEREGRINE_FTL_SPEED * starTripDist / 1000; // 5LPH -720 seconds per light year
587             if(oreMax > CPGPEREGRINE_MAX_CARGO)
588                 oreMax = CPGPEREGRINE_MAX_CARGO;
589         }
590         else if(collectibleClass == TACTICALCRUISER) { //TACTICA CRUISER Ships
591             oreMax = TACTICALCRUISER_EXTRACTION_BASE + (TACTICALCRUISER_EXTRACTION_BASE * tripCount * aimeIncreasePerTrip / 10000);
592             tripSeconds = TACTICALCRUISER_FTL_SPEED * starTripDist / 1000; 
593             if(oreMax > TACTICALCRUISER_MAX_CARGO)
594                 oreMax = TACTICALCRUISER_MAX_CARGO;
595         }
596         else if(collectibleClass == VULCAN_POD) { //TACTICA CRUISER Ships
597             oreMax = VULCAN_POD_EXTRACTION_BASE + (VULCAN_POD_EXTRACTION_BASE * tripCount * aimeIncreasePerTrip / 10000);
598             tripSeconds = VULCAN_POD_FTL_SPEED * starTripDist / 1000; 
599             if(oreMax > VULCAN_POD_MAX_CARGO)
600                 oreMax = VULCAN_POD_MAX_CARGO;
601         }
602         else if(collectibleClass >= DEVCLASS) { //Dev Ships
603             oreMax = DEVCLASS_EXTRACTION_BASE + (DEVCLASS_EXTRACTION_BASE * tripCount * aimeIncreasePerTrip / 10000);
604             tripSeconds = DEVCLASS_FTL_SPEED * starTripDist / 1000;
605             if(oreMax > DEVCLASS_MAX_CARGO)
606                 oreMax = DEVCLASS_MAX_CARGO;
607         } else {
608             if(collectibleClass >= OTHERCRUISER) { //Support Other Promo Ships
609                 oreMax = OTHERCRUISER_EXTRACTION_BASE + (OTHERCRUISER_EXTRACTION_BASE * tripCount * aimeIncreasePerTrip / 10000);
610                 tripSeconds = OTHERCRUISER_FTL_SPEED * starTripDist / 1000; 
611                 if(oreMax > OTHERCRUISER_MAX_CARGO)
612                     oreMax = OTHERCRUISER_MAX_CARGO;
613             }
614         }
615 
616         //Make Round Trip + Mining
617         tripSeconds = ((tripSeconds * 2) + miningTimePerTrip); //3600 for an hour - 0 for testing ***************************
618 
619         //calculate travel time
620         uint256 returnTime = logic.startMEAMission(_assetId, oreMax, starId, tripSeconds);
621 
622         //Confirm trip
623         if(returnTime > 0) {
624             assetIdNumberOfTripsMapping[uint32(_assetId)] += 1;
625             assetIdToStarVisitedMapping[uint32(_assetId)] = starId;
626             assetIdCurrentTripStartTimeMapping[uint32(_assetId)] = uint32(now);
627         }
628         
629         return returnTime;
630     }
631 
632 
633     /*** PRIVATE FUNCTIONS ***/
634 
635     /// @dev  Safety check on _to address to prevent against an unexpected 0x0 default.
636     function _addressNotNull(address _to) internal pure returns (bool) {
637         return _to != address(0);
638     }
639 
640     /// @dev  Claims and clears cargo -- ONLY INTERNAL
641     function _claimOreAndClear (uint32 _assetId, uint8 _starId) internal {
642         MEAHiddenLogic logic = MEAHiddenLogic(hiddenLogicAddress);
643         uint256[12] memory _ores = logic.getAssetCollectedOreBallancesArray(_assetId);
644         bool hasItems = false;
645 
646         for(uint8 i = 0; i < 12; i++) {
647             if(_ores[i] > 0) {
648                 collectedOreBalanceMapping[msg.sender][i] += uint32(_ores[i]);
649                 hasItems = true;
650             }
651         }
652 
653         //Doesn't Let you Travel to empty stars but lets you collect
654         if(hasItems == false && _starId > 0) {
655             require(logic.getStarTotalSupply(_starId) > 0);
656         }
657 
658         logic.emptyShipCargo(_assetId);
659     }
660 
661     function _getShipInfo(uint256 _assetId) internal view returns (uint256 collectibleClass, address owner) {
662         
663         uint256 nulldata;
664         bool nullbool;
665         uint256 collectibleType;
666 
667         if(_assetId <= 3000) {
668             CSCERC721 shipData = CSCERC721(cscERC721Address);
669             (nulldata, nulldata, collectibleType, collectibleClass, nullbool, owner) = shipData.getCollectibleDetails(_assetId);
670         } else {
671             bytes32 nullstring;
672             CSCFactoryERC721 shipFData = CSCFactoryERC721(cscFactoryERC721Address);
673             (nulldata, nulldata, collectibleType, collectibleClass, nullstring, nullbool, owner) = shipFData.getCollectibleDetails(_assetId);
674         }
675 
676     }
677 
678     
679     
680     
681     
682 }