1 pragma solidity ^0.4.17;
2 
3 contract AccessControl {
4     address public creatorAddress;
5     uint16 public totalSeraphims = 0;
6     mapping (address => bool) public seraphims;
7 
8     bool public isMaintenanceMode = true;
9  
10     modifier onlyCREATOR() {
11         require(msg.sender == creatorAddress);
12         _;
13     }
14 
15     modifier onlySERAPHIM() {
16         require(seraphims[msg.sender] == true);
17         _;
18     }
19     
20     modifier isContractActive {
21         require(!isMaintenanceMode);
22         _;
23     }
24     
25     // Constructor
26     function AccessControl() public {
27         creatorAddress = msg.sender;
28     }
29     
30 
31     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
32         if (seraphims[_newSeraphim] == false) {
33             seraphims[_newSeraphim] = true;
34             totalSeraphims += 1;
35         }
36     }
37     
38     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
39         if (seraphims[_oldSeraphim] == true) {
40             seraphims[_oldSeraphim] = false;
41             totalSeraphims -= 1;
42         }
43     }
44 
45     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
46         isMaintenanceMode = _isMaintaining;
47     }
48 
49   
50 } 
51 
52 contract SafeMath {
53     function safeAdd(uint x, uint y) pure internal returns(uint) {
54       uint z = x + y;
55       assert((z >= x) && (z >= y));
56       return z;
57     }
58 
59     function safeSubtract(uint x, uint y) pure internal returns(uint) {
60       assert(x >= y);
61       uint z = x - y;
62       return z;
63     }
64 
65     function safeMult(uint x, uint y) pure internal returns(uint) {
66       uint z = x * y;
67       assert((x == 0)||(z/x == y));
68       return z;
69     }
70     
71      function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
79         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
80         return uint8(genNum % (maxRandom - min + 1)+min);
81     }
82 }
83 
84 contract Enums {
85     enum ResultCode {
86         SUCCESS,
87         ERROR_CLASS_NOT_FOUND,
88         ERROR_LOW_BALANCE,
89         ERROR_SEND_FAIL,
90         ERROR_NOT_OWNER,
91         ERROR_NOT_ENOUGH_MONEY,
92         ERROR_INVALID_AMOUNT
93     }
94 
95     enum AngelAura { 
96         Blue, 
97         Yellow, 
98         Purple, 
99         Orange, 
100         Red, 
101         Green 
102     }
103 }
104 
105 contract IAngelCardData is AccessControl, Enums {
106     uint8 public totalAngelCardSeries;
107     uint64 public totalAngels;
108 
109     
110     // write
111     // angels
112     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
113     function updateAngelCardSeries(uint8 _angelCardSeriesId, uint64 _newPrice, uint64 _newMaxTotal) onlyCREATOR external;
114     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
115     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
116     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
117     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
118     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
119     function addAngelIdMapping(address _owner, uint64 _angelId) private;
120     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
121     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
122     function updateAngelLock (uint64 _angelId, bool newValue) public;
123     function removeCreator() onlyCREATOR external;
124 
125     // read
126     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
127     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
128     function getOwnerAngelCount(address _owner) constant public returns(uint);
129     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
130     function getTotalAngelCardSeries() constant public returns (uint8);
131     function getTotalAngels() constant public returns (uint64);
132     function getAngelLockStatus(uint64 _angelId) constant public returns (bool);
133 }
134 
135 
136 contract IPetCardData is AccessControl, Enums {
137     uint8 public totalPetCardSeries;    
138     uint64 public totalPets;
139     
140     // write
141     function createPetCardSeries(uint8 _petCardSeriesId, uint32 _maxTotal) onlyCREATOR public returns(uint8);
142     function setPet(uint8 _petCardSeriesId, address _owner, string _name, uint8 _luck, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue) onlySERAPHIM external returns(uint64);
143     function setPetAuras(uint64 _petId, uint8 _auraRed, uint8 _auraBlue, uint8 _auraYellow) onlySERAPHIM external;
144     function setPetLastTrainingTime(uint64 _petId) onlySERAPHIM external;
145     function setPetLastBreedingTime(uint64 _petId) onlySERAPHIM external;
146     function addPetIdMapping(address _owner, uint64 _petId) private;
147     function transferPet(address _from, address _to, uint64 _petId) onlySERAPHIM public returns(ResultCode);
148     function ownerPetTransfer (address _to, uint64 _petId)  public;
149     function setPetName(string _name, uint64 _petId) public;
150 
151     // read
152     function getPetCardSeries(uint8 _petCardSeriesId) constant public returns(uint8 petCardSeriesId, uint32 currentPetTotal, uint32 maxPetTotal);
153     function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, string name, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, uint64 lastTrainingTime, uint64 lastBreedingTime, address owner);
154     function getOwnerPetCount(address _owner) constant public returns(uint);
155     function getPetByIndex(address _owner, uint _index) constant public returns(uint);
156     function getTotalPetCardSeries() constant public returns (uint8);
157     function getTotalPets() constant public returns (uint);
158 }
159 
160 
161 
162 
163 contract IBattleboardData is AccessControl  {
164 
165   
166 
167       // write functions
168   
169 function createBattleboard(uint prize, uint8 restrictions) onlySERAPHIM external returns (uint16);
170 function killMonster(uint16 battleboardId, uint8 monsterId)  onlySERAPHIM external;
171 function createNullTile(uint16 _battleboardId) private ;
172 function createTile(uint16 _battleboardId, uint8 _tileType, uint8 _value, uint8 _position, uint32 _hp, uint16 _petPower, uint64 _angelId, uint64 _petId, address _owner, uint8 _team) onlySERAPHIM external  returns (uint8);
173 function killTile(uint16 battleboardId, uint8 tileId) onlySERAPHIM external ;
174 function addTeamtoBoard(uint16 battleboardId, address owner, uint8 team) onlySERAPHIM external;
175 function setTilePosition (uint16 battleboardId, uint8 tileId, uint8 _positionTo) onlySERAPHIM public ;
176 function setTileHp(uint16 battleboardId, uint8 tileId, uint32 _hp) onlySERAPHIM external ;
177 function addMedalBurned(uint16 battleboardId) onlySERAPHIM external ;
178 function setLastMoveTime(uint16 battleboardId) onlySERAPHIM external ;
179 function iterateTurn(uint16 battleboardId) onlySERAPHIM external ;
180 function killBoard(uint16 battleboardId) onlySERAPHIM external ;
181 function clearAngelsFromBoard(uint16 battleboardId) private;
182 //Read functions
183      
184 function getTileHp(uint16 battleboardId, uint8 tileId) constant external returns (uint32) ;
185 function getMedalsBurned(uint16 battleboardId) constant external returns (uint8) ;
186 function getTeam(uint16 battleboardId, uint8 tileId) external returns (uint8) ;
187 function getMaxFreeTeams() constant public returns (uint8);
188 function getBarrierNum(uint16 battleboardId) public constant returns (uint8) ;
189 function getTileFromBattleboard(uint16 battleboardId, uint8 tileId) public constant returns (uint8 tileType, uint8 value, uint8 id, uint8 position, uint32 hp, uint16 petPower, uint64 angelId, uint64 petId, bool isLive, address owner)   ;
190 function getTileIDByOwner(uint16 battleboardId, address _owner) constant public returns (uint8) ;
191 function getPetbyTileId( uint16 battleboardId, uint8 tileId) constant public returns (uint64) ;
192 function getOwner (uint16 battleboardId, uint8 team,  uint8 ownerNumber) constant external returns (address);
193 function getTileIDbyPosition(uint16 battleboardId, uint8 position) public constant returns (uint8) ;
194 function getPositionFromBattleboard(uint16 battleboardId, uint8 _position) public constant returns (uint8 tileType, uint8 value, uint8 id, uint8 position, uint32 hp, uint32 petPower, uint64 angelId, uint64 petId, bool isLive)  ;
195 function getBattleboard(uint16 id) public constant returns (uint8 turn, bool isLive, uint prize, uint8 numTeams, uint8 numTiles, uint8 createdBarriers, uint8 restrictions, uint lastMoveTime, uint8 numTeams1, uint8 numTeams2, uint8 monster1, uint8 monster2) ;
196 function isBattleboardLive(uint16 battleboardId) constant public returns (bool);
197 function isTileLive(uint16 battleboardId, uint8 tileId) constant  external returns (bool) ;
198 function getLastMoveTime(uint16 battleboardId) constant public returns (uint) ;
199 function getNumTilesFromBoard (uint16 _battleboardId) constant public returns (uint8) ; 
200 function angelOnBattleboards(uint64 angelID) external constant returns (bool) ;
201 function getTurn(uint16 battleboardId) constant public returns (address) ;
202 function getNumTeams(uint16 battleboardId, uint8 team) public constant returns (uint8);
203 function getMonsters(uint16 BattleboardId) external constant returns (uint8 monster1, uint8 monster2) ;
204 function getTotalBattleboards() public constant returns (uint16) ;
205   
206         
207  
208    
209 }
210 
211 contract IAccessoryData is AccessControl, Enums {
212     uint8 public totalAccessorySeries;    
213     uint32 public totalAccessories;
214     
215  
216     /*** FUNCTIONS ***/
217     //*** Write Access ***//
218     function createAccessorySeries(uint8 _AccessorySeriesId, uint32 _maxTotal, uint _price) onlyCREATOR public returns(uint8) ;
219 	function setAccessory(uint8 _AccessorySeriesId, address _owner) onlySERAPHIM external returns(uint64);
220    function addAccessoryIdMapping(address _owner, uint64 _accessoryId) private;
221 	function transferAccessory(address _from, address _to, uint64 __accessoryId) onlySERAPHIM public returns(ResultCode);
222     function ownerAccessoryTransfer (address _to, uint64 __accessoryId)  public;
223     function updateAccessoryLock (uint64 _accessoryId, bool newValue) public;
224     function removeCreator() onlyCREATOR external;
225     
226     //*** Read Access ***//
227     function getAccessorySeries(uint8 _accessorySeriesId) constant public returns(uint8 accessorySeriesId, uint32 currentTotal, uint32 maxTotal, uint price) ;
228 	function getAccessory(uint _accessoryId) constant public returns(uint accessoryID, uint8 AccessorySeriesID, address owner);
229 	function getOwnerAccessoryCount(address _owner) constant public returns(uint);
230 	function getAccessoryByIndex(address _owner, uint _index) constant public returns(uint) ;
231     function getTotalAccessorySeries() constant public returns (uint8) ;
232     function getTotalAccessories() constant public returns (uint);
233     function getAccessoryLockStatus(uint64 _acessoryId) constant public returns (bool);
234 
235 }
236 
237 //This contract is to Manage (open, close, add teams, etc) battleboards. Call the Battleboards contract to make moves. Both of these contracts 
238 //interface with the battleboards data contract. 
239 
240 contract ManageBattleboards is AccessControl, SafeMath  {
241 
242     /*** DATA TYPES ***/
243     address public angelCardDataContract = 0x6D2E76213615925c5fc436565B5ee788Ee0E86DC;
244     address public petCardDataContract = 0xB340686da996b8B3d486b4D27E38E38500A9E926;
245     address public accessoryDataContract = 0x466c44812835f57b736ef9F63582b8a6693A14D0;
246     address public battleboardDataContract = 0x33201831496217A779bF6169038DD9232771f179;
247 
248    
249     
250     //The reserved balance is the total balance outstanding on all open battleboards. 
251     //We keep track of this figure to prevent the developers from pulling out money currently pledged
252     //This only features in the paid boards. 
253     uint public contractReservedBalance;
254     
255     
256     //Tile TYPES
257     // 0 - Empty Space
258     // 1 - Team (Angel + Pet)
259  
260     // 3 - Red Barrier (red is hurt)
261     // 4 - Yellow barrier (yellow is hurt)
262     // 5 - Blue barrier (blue is hurt)
263     // 6 - Exp Boost (permanent)
264     // 7 - HP boost (temp)
265     // 8 - Eth boost
266     // 9 - Warp
267     // 10 - Medal
268     
269     //Aura Boosts
270     // Red - Slow Burn - Enemies lose extra 10 hp/round in battle. 
271     // Green - Healing Light - 20% chance to heal 50 hp each battle round
272     //Yellow - Guiding Path - 5 hp recovered each turn not in a battle
273     //Purple - Uncontroled Fury - 10% chance for sudden kill at start of battle. 
274     //Orange - Radiant Power - +100 max hp on joining board. 
275     //Blue - Undying Love - 30% chance to revive pet when dead. 
276     
277       
278           // Utility Functions
279     function DataContacts(address _angelCardDataContract, address _petCardDataContract, address _accessoryDataContract, address _battleboardDataContract) onlyCREATOR external {
280         angelCardDataContract = _angelCardDataContract;
281         petCardDataContract = _petCardDataContract;
282         accessoryDataContract = _accessoryDataContract;
283         battleboardDataContract = _battleboardDataContract;
284 
285     }
286     
287     function checkExistsOwnedAngel (uint64 angelId) private constant returns (bool) {
288         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
289        
290         if ((angelId <= 0) || (angelId > angelCardData.getTotalAngels())) {return false;}
291         address angelowner;
292         (,,,,,,,,,,angelowner) = angelCardData.getAngel(angelId);
293         if (angelowner == msg.sender) {return true;}
294         
295        else  return false;
296 }
297   
298     function checkExistsOwnedPet (uint64 petId) private constant returns (bool) {
299           IPetCardData petCardData = IPetCardData(petCardDataContract);
300        
301         if ((petId <= 0) || (petId > petCardData.getTotalPets())) {return false;}
302         address petowner;
303          (,,,,,,,petowner) = petCardData.getPet(petId);
304         if (petowner == msg.sender) {return true;}
305         
306        else  return false;
307 }
308 
309     function checkExistsOwnedAccessory (uint64 accessoryId) private constant returns (bool) {
310           IAccessoryData accessoryData = IAccessoryData(accessoryDataContract);
311        if (accessoryId == 0) {return true;}
312        //Not sending an accessory is valid. 
313         if ((accessoryId < 0) || (accessoryId > accessoryData.getTotalAccessories())) {return false;}
314         address owner;
315          (,,owner) = accessoryData.getAccessory(accessoryId);
316         if (owner == msg.sender) {return true;}
317         
318        else  return false;
319 }
320 
321 
322  function takePet(uint64 petId) private {
323            //This contract takes ownership of pets who are entered into battleboards and later distributes the losers' pets to the winners. 
324                IPetCardData PetCardData = IPetCardData(petCardDataContract);
325                 PetCardData.transferPet(msg.sender, address(this), petId);
326         }
327            
328            
329        function restrictionsAllow(uint64 angelId, uint8 restrictions) private constant returns (bool) {
330        //This function returns true if the restrictions of the board allow the angel and false if not. Basically
331        //Angel card series IDs get stronger BP over time, with the exception of Michael and Lucifer. 
332        //Note: Zadkiel is allowed on boards where she might be stronger - this is a rare case that will balance against
333        //EVERY player needing to pay this gas to check every time ANY angel is added to the board. 
334        
335         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
336         uint8 angelCardSeries;
337         (,angelCardSeries,,,,,,,,,) = angelCardData.getAngel(angelId);
338         
339         if (angelCardSeries > restrictions) {return false;}
340         if ((angelCardSeries == 2) && (restrictions < 19)) {return false;} //Lucifer Card 
341         if ((angelCardSeries == 3) && (restrictions < 21)) {return false;} //Michael Card
342         return true;
343        }
344        
345        
346        //Opening and Closing Functions
347       
348   
349        function createBattleboard(uint8 restrictions) external payable returns (uint16) {
350            if (restrictions <0) {revert();}
351            IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
352            return battleboardData.createBattleboard(msg.value, restrictions);
353            
354        }
355        
356         function closeBattleboard(uint16 battleboardId) external {
357        //This function can be called by ANYONE once either team 1 or team 2 has no more team members left. 
358         IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
359         address[] storage winners;
360        if (battleboardData.isBattleboardLive(battleboardId) == false) {revert();}
361        battleboardData.killBoard(battleboardId); 
362         if ((battleboardData.getNumTeams(battleboardId,1) != 0) && (battleboardData.getNumTeams(battleboardId,2) != 0)) {revert();}
363         //No teams are out, function shouldn't be called. 
364         uint8 id;
365         uint64 petId;
366         address owner;
367         if ((battleboardData.getNumTeams(battleboardId,1) == 0) && (battleboardData.getNumTeams(battleboardId,2) == 0)) {
368               //Something odd happened and BOTH teams have lost - this is a tie. 
369               IPetCardData PetCardData = IPetCardData(petCardDataContract);
370               for (uint8 i =0; i<battleboardData.getMaxFreeTeams(); i++) {
371                   owner = battleboardData.getOwner(battleboardId, 0, i);
372                   id = battleboardData.getTileIDByOwner(battleboardId,owner);
373                  petId = battleboardData.getPetbyTileId(battleboardId, id);
374                  PetCardData.transferPet(address(this), owner, petId);
375               }
376         }
377        if ((battleboardData.getNumTeams(battleboardId,1) != 0) && (battleboardData.getNumTeams(battleboardId,2) == 0)) {
378        //Team 1 won 
379        
380        //Give team 1 back their pets. 
381         for (i =0; i<(safeDiv(battleboardData.getMaxFreeTeams(),2)); i++) {
382                   owner = battleboardData.getOwner(battleboardId, 1, i);
383                   id = battleboardData.getTileIDByOwner(battleboardId,owner);
384                  petId = battleboardData.getPetbyTileId(battleboardId, id);
385                  PetCardData.transferPet(address(this), owner, petId);
386                 winners.push(owner); 
387               }
388             //give team 2's pets to team 1.   
389         for (i =0; i<(safeDiv(battleboardData.getMaxFreeTeams(),2)); i++) {
390                   owner = battleboardData.getOwner(battleboardId, 2, i);
391                   id = battleboardData.getTileIDByOwner(battleboardId,owner);
392                  petId = battleboardData.getPetbyTileId(battleboardId, id);
393                  PetCardData.transferPet(address(this), winners[i], petId);
394               }    
395        }
396           if ((battleboardData.getNumTeams(battleboardId,1) == 0) && (battleboardData.getNumTeams(battleboardId,2) != 0)) {
397        //Team 2 won 
398        
399        //Give team 2 back their pets. 
400         for (i =0; i<(safeDiv(battleboardData.getMaxFreeTeams(),2)); i++) {
401                   owner = battleboardData.getOwner(battleboardId, 2, i);
402                   id = battleboardData.getTileIDByOwner(battleboardId,owner);
403                  petId = battleboardData.getPetbyTileId(battleboardId, id);
404                  PetCardData.transferPet(address(this), owner, petId);
405                 winners.push(owner); 
406               }
407             //give team 1's pets to team 2  
408         for (i =0; i<(safeDiv(battleboardData.getMaxFreeTeams(),2)); i++) {
409                   owner = battleboardData.getOwner(battleboardId, 1, i);
410                   id = battleboardData.getTileIDByOwner(battleboardId,owner);
411                  petId = battleboardData.getPetbyTileId(battleboardId, id);
412                  PetCardData.transferPet(address(this), winners[i], petId);
413               }    
414        }
415    }
416        
417    
418         function getInitialHP (uint64 angelId, uint64 petId, uint64 accessoryId) public constant returns (uint32 hp, uint16 petAuraComposite) {
419            IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
420            
421            //need to reuse local variables to avoid stack too deep;
422            uint16 temp;
423            uint16 tempComposite;
424            uint8 aura;
425            (,,temp,aura,,,,,,,) = angelCardData.getAngel(angelId);
426            if (aura == 3) {temp += 100;} //plus 100 initial HP to orange aura angels. 
427            tempComposite = temp;
428            //first add battlePower;
429            (,,,,temp,,,,,,) = angelCardData.getAngel(angelId);
430            tempComposite += temp;
431            //now temp is experience
432             uint8 petAuraColor;
433              (petAuraComposite, petAuraColor) = findAuraComposite (petId, accessoryId);
434             hp = (aurasCompatible(angelId,petAuraColor)+ petAuraComposite + tempComposite);
435             
436             return;
437         }
438        
439        function addTeam1(uint64 angelId, uint64 petId, uint64 accessoryId, uint16 battleboardId) external payable {
440            //call this function to add your angel/pet/accessory to team 1. 
441            checkTeamToAdd(angelId,petId,accessoryId);
442             IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
443             // check if battleboard is full/open first and see where the new tesm should be placed. 
444            uint32 hp;
445            uint16 petPower;
446            uint16 speed = getSpeed(petId,accessoryId);
447            (hp, petPower) = getInitialHP(angelId,petId, accessoryId);
448            battleboardData.createTile(battleboardId, 1, uint8(speed), getNewTeamPositionAndCheck(battleboardId, 1, angelId), hp, petPower + speed,angelId, petId, msg.sender, 1);
449            battleboardData.addTeamtoBoard(battleboardId, msg.sender,1);
450            //now add one random tile to the board. 
451            addRandomTile(battleboardId, 1);
452            takePet(petId);
453        }
454        
455           function addTeam2(uint64 angelId, uint64 petId, uint64 accessoryId, uint16 battleboardId) external payable {
456            
457            checkTeamToAdd(angelId,petId,accessoryId);
458             IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
459             // check if battleboard is full/open first and see where the new tesm should be placed. 
460            uint32 hp;
461            uint16 petPower;
462            uint16 speed = getSpeed(petId,accessoryId);
463            (hp, petPower) = getInitialHP(angelId,petId, accessoryId);
464            battleboardData.createTile(battleboardId, 1, uint8(speed), getNewTeamPositionAndCheck(battleboardId, 2, angelId), hp, petPower + speed,angelId, petId, msg.sender, 2);
465            battleboardData.addTeamtoBoard(battleboardId, msg.sender,2);
466            //now add one random tile to the board. 
467            addRandomTile(battleboardId, 1);
468            takePet(petId);
469        }
470        
471        function getSpeed(uint64 petId, uint64 accessoryId) private constant returns (uint16) {
472            //this speed function returns pet's base Luck + any accessory boost from the clovers;
473            IAccessoryData accessoryData = IAccessoryData(accessoryDataContract);
474            IPetCardData petCardData = IPetCardData(petCardDataContract);
475 
476        uint16 temp;
477        uint8 accessorySeriesId;
478          (,,,temp,,,,,,) = petCardData.getPet(petId);
479          //first get the pet's base luck. 
480            (,accessorySeriesId,) = accessoryData.getAccessory(accessoryId);
481            if (accessorySeriesId == 5) {temp += 5;}
482             if (accessorySeriesId == 6) {temp += 10;}
483             return temp;
484   
485        }
486           
487         function getNewTeamPositionAndCheck (uint16 battleboardId,uint8 team, uint64 angelId) private constant returns (uint8) {
488             IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
489             uint8 numTeams1;
490             uint8 numTeams2;
491              uint8 position;
492              uint8 restrictions;
493             bool isLive;
494         
495            //Now see which tile to add the new team. Teams are added in a specified place besed on when they join. 
496              (,isLive,,,,,restrictions,, numTeams1,numTeams2,,) = battleboardData.getBattleboard(battleboardId);
497                
498              if (restrictionsAllow(angelId, restrictions) == false) {revert();} 
499             if (isLive== true) {revert();} //Can't add a team to a board that's already live.
500              if (team == 1) {
501                 if (numTeams1 == 0) {position = 10;}
502                if (numTeams1 ==1) {position = 12;}
503                if (numTeams1 == 2) {position = 14;}
504                if (numTeams1 >=3) {revert();}
505            }
506                if (team == 2) {
507                if (numTeams2 == 0) {position = 50;}
508                if (numTeams2 == 1) {position = 52;}
509                if (numTeams2 == 2) {position = 54;}
510                if (numTeams2 >=3) {revert();}
511            }
512            return position;
513         }  
514           
515           function checkTeamToAdd(uint64 angelId, uint64 petId, uint64 accessoryId) private constant {
516                if ((checkExistsOwnedAngel(angelId) == false) || (checkExistsOwnedPet(petId)== false) || (checkExistsOwnedAccessory(accessoryId) == false)) {revert();}
517           }
518           
519              
520              function addRandomTile(uint16 _battleboardId, uint8 seed) private  {
521              IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
522     
523            uint8 newTileType;
524            uint8 newTilePower;
525            
526             
527              //Tile TYPES
528     // 0 - Empty Space
529     // 1 - Team (Angel + Pet)
530     // 3 - Red Barrier (red is hurt)
531     // 4 - Yellow barrier (yellow is hurt)
532     // 5 - Blue barrier (blue is hurt)
533     // 6 - Exp Boost (permanent)
534     // 7 - HP boost (temp)
535     // 8 - Eth boost
536     // 9 - Warp
537     // 10 - Medal
538     // 11 - Pet permanent Aura boost random color
539     
540            
541            uint8 chance = getRandomNumber(100,0,seed);
542              
543               if (chance <=30)  {
544                 //Barrier tile
545                 newTileType = getRandomNumber(5,3,seed);
546                 newTilePower = getRandomNumber(30,10,seed);
547             }
548                 if ((chance >=30) && (chance <50)) {
549                 //HP boost
550                 newTileType = 7;
551                 newTilePower = getRandomNumber(45,15,seed);
552             }
553              if ((chance >=50) && (chance <60)) {
554                 //EXP boost
555                 newTileType = 6;
556                 newTilePower = getRandomNumber(5,1,seed);
557             }
558             if ((chance >=60) && (chance <80)) {
559                 //Warp
560                 newTileType = 9;
561                 newTilePower = getRandomNumber(64,1,seed);
562             }
563             if ((chance >=80) && (chance <90)) {
564                 //Medal
565                 newTileType = 10;
566                 newTilePower = getRandomNumber(2,0,seed);
567             }
568             if (chance >=90) {
569                 //Pet Aura boost 
570                 newTileType = 11;
571                 newTilePower = getRandomNumber(4,1,seed);
572             }
573             
574                 
575          uint8 position = getRandomNumber(49,15,seed);
576           //if desided position is already full, try three times to place them in an open spot. Odds are max 0.6% that the tx reverts. 
577           //Random tiles are in the middle of the board and won't conflict with anangels. 
578           //Random tiels CAN be on the same position as a monster, though. 
579            if (battleboardData.getTileIDbyPosition(_battleboardId, position)!= 0) {
580               
581               position = getRandomNumber(49,15,msg.sender);
582               if (battleboardData.getTileIDbyPosition(_battleboardId, position)!= 0) {
583                position = getRandomNumber(49,15,msg.sender);
584                 if (battleboardData.getTileIDbyPosition(_battleboardId, position)!= 0) { 
585                    position = getRandomNumber(49,15,msg.sender);
586                 if (battleboardData.getTileIDbyPosition(_battleboardId, position)!= 0) {revert();}
587               }
588            }
589            }
590          battleboardData.createTile(_battleboardId,newTileType, newTilePower, position, 0, 0, 0, 0, address(this),0);
591        }
592        
593        function aurasCompatible(uint64 angel1ID, uint8  _petAuraColor ) private constant returns (uint8) {
594             uint8 compatibility = 0;
595             
596         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
597           uint8 _angel1Aura;
598          (,,,_angel1Aura,,,,,,,) = angelCardData.getAngel(angel1ID);
599             if (_petAuraColor == 1) {
600                 if ((_angel1Aura == 2) || (_angel1Aura == 3) || (_angel1Aura == 4)) {compatibility++;}
601             }
602             if (_petAuraColor == 2) {
603                 if ((_angel1Aura == 0) || (_angel1Aura == 2) || (_angel1Aura == 5)) {compatibility++;}
604             }
605             if (_petAuraColor == 3) {
606                 if ((_angel1Aura == 1) || (_angel1Aura == 3) || (_angel1Aura == 5)) {compatibility++;}
607             }
608         return compatibility*12;
609             
610         }
611         
612         function findAuraComposite(uint64 pet1ID, uint64 accessoryId) private constant returns (uint16 composite, uint8 color) {
613         IPetCardData petCardData = IPetCardData(petCardDataContract);
614         
615        uint16 pet1auraRed;
616        uint16 pet1auraBlue;
617        uint16 pet1auraYellow;
618         (,,,,pet1auraRed,pet1auraBlue,pet1auraYellow,,,) = petCardData.getPet(pet1ID);
619         
620           IAccessoryData accessoryData = IAccessoryData(accessoryDataContract);
621            
622            uint8 accessorySeriesID;
623            
624            (,accessorySeriesID,) = accessoryData.getAccessory(accessoryId);
625         
626         if (accessorySeriesID == 7) {pet1auraRed += 6;}
627         if (accessorySeriesID == 8) {pet1auraRed += 12;}
628         if (accessorySeriesID == 9) {pet1auraYellow += 6;}
629         if (accessorySeriesID == 10) {pet1auraYellow += 12;}
630         if (accessorySeriesID == 11) {pet1auraBlue += 6;}
631         if (accessorySeriesID == 12) {pet1auraBlue += 12;}
632         
633        
634             color = 1; //assume red to start 
635             if (((pet1auraBlue) > (pet1auraRed)) && ((pet1auraBlue) > (pet1auraYellow))) {color = 2;}
636             if (((pet1auraYellow)> (pet1auraRed)) && ((pet1auraYellow)> (pet1auraBlue))) {color = 3;}
637             composite = (pet1auraRed) + (pet1auraYellow) + (pet1auraBlue);
638             return;
639             }
640         
641           function kill() onlyCREATOR external {
642         selfdestruct(creatorAddress);
643     }
644                 function withdrawEther()  onlyCREATOR external {
645    //shouldn't have any eth here but just in case. 
646     creatorAddress.transfer(this.balance);
647 }
648           
649 }