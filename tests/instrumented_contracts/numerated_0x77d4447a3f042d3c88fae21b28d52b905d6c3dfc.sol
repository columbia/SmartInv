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
134 contract IPetCardData is AccessControl, Enums {
135     uint8 public totalPetCardSeries;    
136     uint64 public totalPets;
137     
138     // write
139     function createPetCardSeries(uint8 _petCardSeriesId, uint32 _maxTotal) onlyCREATOR public returns(uint8);
140     function setPet(uint8 _petCardSeriesId, address _owner, string _name, uint8 _luck, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue) onlySERAPHIM external returns(uint64);
141     function setPetAuras(uint64 _petId, uint8 _auraRed, uint8 _auraBlue, uint8 _auraYellow) onlySERAPHIM external;
142     function setPetLastTrainingTime(uint64 _petId) onlySERAPHIM external;
143     function setPetLastBreedingTime(uint64 _petId) onlySERAPHIM external;
144     function addPetIdMapping(address _owner, uint64 _petId) private;
145     function transferPet(address _from, address _to, uint64 _petId) onlySERAPHIM public returns(ResultCode);
146     function ownerPetTransfer (address _to, uint64 _petId)  public;
147     function setPetName(string _name, uint64 _petId) public;
148 
149     // read
150     function getPetCardSeries(uint8 _petCardSeriesId) constant public returns(uint8 petCardSeriesId, uint32 currentPetTotal, uint32 maxPetTotal);
151     function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, string name, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, uint64 lastTrainingTime, uint64 lastBreedingTime, address owner);
152     function getOwnerPetCount(address _owner) constant public returns(uint);
153     function getPetByIndex(address _owner, uint _index) constant public returns(uint);
154     function getTotalPetCardSeries() constant public returns (uint8);
155     function getTotalPets() constant public returns (uint);
156 }
157 
158 contract IMedalData is AccessControl {
159   
160     modifier onlyOwnerOf(uint256 _tokenId) {
161     require(ownerOf(_tokenId) == msg.sender);
162     _;
163   }
164    
165 function totalSupply() public view returns (uint256);
166 function setMaxTokenNumbers()  onlyCREATOR external;
167 function balanceOf(address _owner) public view returns (uint256);
168 function tokensOf(address _owner) public view returns (uint256[]) ;
169 function ownerOf(uint256 _tokenId) public view returns (address);
170 function approvedFor(uint256 _tokenId) public view returns (address) ;
171 function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId);
172 function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId);
173 function takeOwnership(uint256 _tokenId) public;
174 function _createMedal(address _to, uint8 _seriesID) onlySERAPHIM public ;
175 function getCurrentTokensByType(uint32 _seriesID) public constant returns (uint32);
176 function getMedalType (uint256 _tokenId) public constant returns (uint8);
177 function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) external;
178 function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) ;
179 function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal;
180 function clearApproval(address _owner, uint256 _tokenId) private;
181 function addToken(address _to, uint256 _tokenId) private ;
182 function removeToken(address _from, uint256 _tokenId) private;
183 }
184 
185 contract IBattleboardData is AccessControl  {
186 
187   
188 
189       // write functions
190   
191 function createBattleboard(uint prize, uint8 restrictions) onlySERAPHIM external returns (uint16);
192 function killMonster(uint16 battleboardId, uint8 monsterId)  onlySERAPHIM external;
193 function createNullTile(uint16 _battleboardId) private ;
194 function createTile(uint16 _battleboardId, uint8 _tileType, uint8 _value, uint8 _position, uint32 _hp, uint16 _petPower, uint64 _angelId, uint64 _petId, address _owner, uint8 _team) onlySERAPHIM external  returns (uint8);
195 function killTile(uint16 battleboardId, uint8 tileId) onlySERAPHIM external ;
196 function addTeamtoBoard(uint16 battleboardId, address owner, uint8 team) onlySERAPHIM external;
197 function setTilePosition (uint16 battleboardId, uint8 tileId, uint8 _positionTo) onlySERAPHIM public ;
198 function setTileHp(uint16 battleboardId, uint8 tileId, uint32 _hp) onlySERAPHIM external ;
199 function addMedalBurned(uint16 battleboardId) onlySERAPHIM external ;
200 function setLastMoveTime(uint16 battleboardId) onlySERAPHIM external ;
201 function iterateTurn(uint16 battleboardId) onlySERAPHIM external ;
202 function killBoard(uint16 battleboardId) onlySERAPHIM external ;
203 function clearAngelsFromBoard(uint16 battleboardId) private;
204 //Read functions
205      
206 function getTileHp(uint16 battleboardId, uint8 tileId) constant external returns (uint32) ;
207 function getMedalsBurned(uint16 battleboardId) constant external returns (uint8) ;
208 function getTeam(uint16 battleboardId, uint8 tileId) constant external returns (uint8) ;
209 function getMaxFreeTeams() constant public returns (uint8);
210 function getBarrierNum(uint16 battleboardId) public constant returns (uint8) ;
211 function getTileFromBattleboard(uint16 battleboardId, uint8 tileId) public constant returns (uint8 tileType, uint8 value, uint8 id, uint8 position, uint32 hp, uint16 petPower, uint64 angelId, uint64 petId, bool isLive, address owner)   ;
212 function getTileIDByOwner(uint16 battleboardId, address _owner) constant public returns (uint8) ;
213 function getPetbyTileId( uint16 battleboardId, uint8 tileId) constant public returns (uint64) ;
214 function getOwner (uint16 battleboardId, uint8 team,  uint8 ownerNumber) constant external returns (address);
215 function getTileIDbyPosition(uint16 battleboardId, uint8 position) public constant returns (uint8) ;
216 function getPositionFromBattleboard(uint16 battleboardId, uint8 _position) public constant returns (uint8 tileType, uint8 value, uint8 id, uint8 position, uint32 hp, uint32 petPower, uint64 angelId, uint64 petId, bool isLive)  ;
217 function getBattleboard(uint16 id) public constant returns (uint8 turn, bool isLive, uint prize, uint8 numTeams, uint8 numTiles, uint8 createdBarriers, uint8 restrictions, uint lastMoveTime, uint8 numTeams1, uint8 numTeams2, uint8 monster1, uint8 monster2) ;
218 function isBattleboardLive(uint16 battleboardId) constant public returns (bool);
219 function isTileLive(uint16 battleboardId, uint8 tileId) constant  external returns (bool) ;
220 function getLastMoveTime(uint16 battleboardId) constant public returns (uint) ;
221 function getNumTilesFromBoard (uint16 _battleboardId) constant public returns (uint8) ; 
222 function angelOnBattleboards(uint64 angelID) external constant returns (bool) ;
223 function getTurn(uint16 battleboardId) constant public returns (address) ;
224 function getNumTeams(uint16 battleboardId, uint8 team) public constant returns (uint8);
225 function getMonsters(uint16 BattleboardId) external constant returns (uint8 monster1, uint8 monster2) ;
226 function getTotalBattleboards() public constant returns (uint16) ;
227   
228         
229  
230    
231 }
232 
233 
234 contract Battleboards is AccessControl, SafeMath  {
235 
236     /*** DATA TYPES ***/
237     address public angelCardDataContract = 0x6D2E76213615925c5fc436565B5ee788Ee0E86DC;
238     address public petCardDataContract = 0xB340686da996b8B3d486b4D27E38E38500A9E926;
239     address public medalDataContract =  0x33A104dCBEd81961701900c06fD14587C908EAa3;
240     address public battleboardDataContract =0xE60fC4632bD6713E923FE93F8c244635E6d5009e;
241 
242      // events
243      event EventMonsterStrike(uint16 battleboardId, uint64 angel, uint16 amount);
244      event EventBarrier(uint16 battleboardId,uint64 angelId, uint8 color, uint8 damage);
245      event EventBattleResult(uint16 battleboardId, uint8 tile1Id, uint8 tile2Id, bool angel1win);
246     
247     
248     uint8 public delayHours = 12;
249     uint16 public petHpThreshold = 250;
250     uint16 public maxMonsterHit = 200;
251     uint16 public minMonsterHit = 50;
252          
253       struct Tile {
254         uint8 tileType;
255         uint8 value;
256         uint8 id;
257         uint8 position;
258         uint32 hp;
259         uint32 petPower;
260         uint64 angelId;
261         uint64 petId;
262         bool isLive;
263         address owner;
264         
265     }
266     
267     
268     
269     
270     //Aura Boosts
271     // Red - Burning Strike - + 10 battle power  
272     // Green - Healing Light - 20% chance to heal 75 hp each battle
273     //Yellow - Guiding Path - 5 hp recovered each turn.
274     //Purple - Uncontroled Fury - 10% chance for sudden kill 
275     //Orange - Radiant Power - +100 max hp on joining board. 
276     //Blue - Friend to all - immunity from monster attacks 
277     
278       
279           // Utility Functions
280     function DataContacts(address _angelCardDataContract, address _petCardDataContract,  address _medalDataContract, address _battleboardDataContract) onlyCREATOR external {
281         angelCardDataContract = _angelCardDataContract;
282         petCardDataContract = _petCardDataContract;
283         medalDataContract = _medalDataContract;
284         battleboardDataContract = _battleboardDataContract;
285     }
286     
287     function setVariables(uint8 _delayHours, uint16 _petHpThreshold,  uint16 _maxMonsterHit, uint16 _minMonsterHit) onlyCREATOR external {
288         delayHours = _delayHours;
289         petHpThreshold = _petHpThreshold;
290         maxMonsterHit = _maxMonsterHit;
291         minMonsterHit = _minMonsterHit;
292         
293     }
294       
295 
296       
297     
298         function removeDeadTurns(uint16 battleboardId) private {
299             //This function iterates through turns of players whose tiles may already be dead 
300             IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
301             uint8 oldTurnTileID;
302             for (uint8 i = 0; i<6; i++) {
303             oldTurnTileID = battleboardData.getTileIDByOwner(battleboardId, battleboardData.getTurn(battleboardId));
304             if (battleboardData.isTileLive(battleboardId, oldTurnTileID) == false) {battleboardData.iterateTurn(battleboardId);}
305             else {i=9;} //break loop
306             }
307         }
308     
309        function move(uint16 battleboardId, uint8 tileId, uint8 positionTo) external {
310            //Can't move off the board
311            if ((positionTo <= 0) || (positionTo >64)) {revert();}
312            IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
313            
314            //if it's not your turn. 
315            if (msg.sender != battleboardData.getTurn(battleboardId)) {
316                //first check to see if the team whose turn it is is dead.
317               removeDeadTurns(battleboardId);
318               if (msg.sender != battleboardData.getTurn(battleboardId)) {
319                   //if it's still not your turn, revert if it's also not past the real turn's delay time. 
320                if  (now  < battleboardData.getLastMoveTime(battleboardId) + (3600* delayHours)) {revert();}
321               }
322            }
323            Tile memory tile;
324             //get the tile to be moved. 
325            (tile.tileType, tile.value ,, tile.position, tile.hp,,,, tile.isLive,tile.owner) = battleboardData.getTileFromBattleboard(battleboardId, tileId) ;
326            //first see if the move is legal
327            if (canMove(battleboardId, tile.position, positionTo) == false) {revert();}
328            
329            //Regardless of if the ower moves its tile normally or if someone else moves it, it has to move on its turn. 
330            if (battleboardData.getTurn(battleboardId) != tile.owner) {revert();}
331            
332            //can't move if your tile isn't live. 
333            if (tile.isLive == false) {revert();}
334            
335            
336             //Tile TYPES
337     // 0 - Empty Space
338     // 1 - Team (Angel + Pet)
339     // 3 - Red Barrier (red is hurt)
340     // 4 - Yellow barrier (yellow is hurt)
341     // 5 - Blue barrier (blue is hurt)
342     // 6 - Exp Boost (permanent)
343     // 7 - HP boost (temp)
344     // 8 - Eth boost
345     // 9 - Warp
346     // 10 - Medal
347     // 11 - Pet permanent Aura boost random color
348     
349            battleboardData.iterateTurn(battleboardId);
350            battleboardData.setLastMoveTime(battleboardId);
351            
352            //Tile 2 is the tile that the angel team will interact with. 
353            Tile memory tile2;
354             tile2.id = battleboardData.getTileIDbyPosition(battleboardId, positionTo);
355            
356           (tile2.tileType, tile2.value ,,,,, tile2.angelId, tile2.petId, tile2.isLive,) = battleboardData.getTileFromBattleboard(battleboardId, tile2.id) ;
357            
358            if ((tile2.tileType == 0) || (tile2.isLive == false)) {
359                //Empty Space
360                battleboardData.setTilePosition(battleboardId,tileId, positionTo);
361            }
362            if (tile2.isLive == true) {
363             if (tile2.tileType == 1) {
364                 if (battleboardData.getTeam(battleboardId, tileId) == battleboardData.getTeam(battleboardId, tile2.id)) {revert();}
365                //Fight Team
366                if (fightTeams(battleboardId, tileId, tile2.id) == true) {
367                    //challenger won. 
368                    battleboardData.setTilePosition(battleboardId,tileId, positionTo);
369                    battleboardData.killTile(battleboardId, tile2.id);
370                    EventBattleResult(battleboardId, tileId, tile2.id, true);
371                }
372                else {battleboardData.killTile(battleboardId, tileId);
373                    EventBattleResult(battleboardId, tileId, tile2.id, false);
374                } //challenger lost
375               
376            }
377           
378              if (tile2.tileType == 3) {
379                //Red barrier
380                battleboardData.setTilePosition(battleboardId,tileId, positionTo);
381                if (isVulnerable (tile.angelId,1) == true) {
382                     if (tile.hp > tile2.value) {battleboardData.setTileHp(battleboardId, tileId, (tile.hp - tile2.value));}
383                     else {battleboardData.killTile(battleboardId, tileId);}
384                }
385                EventBarrier(battleboardId, tile.angelId,3, tile2.value);
386                
387            }
388              if (tile2.tileType == 4) {
389                //Yellow barrier
390              battleboardData.setTilePosition(battleboardId,tileId, positionTo);
391               if (isVulnerable (tile.angelId,2) == true) {
392                     if (tile.hp > tile2.value) {battleboardData.setTileHp(battleboardId, tileId, (tile.hp - tile2.value));}
393                     else {battleboardData.killTile(battleboardId, tileId);}
394                     
395                }
396                EventBarrier(battleboardId, tile.angelId,4, tile2.value);
397            }
398              if (tile2.tileType == 5) {
399                //Blue barrier
400                battleboardData.setTilePosition(battleboardId,tileId, positionTo);
401                 if (isVulnerable (tile.angelId,3) == true) {
402                     if (tile.hp > tile2.value) {battleboardData.setTileHp(battleboardId, tileId, (tile.hp - tile2.value));}
403                     else {battleboardData.killTile(battleboardId, tileId);}
404                }
405                EventBarrier(battleboardId, tile.angelId,5, tile2.value);
406            }
407              if (tile2.tileType == 6) {
408                //Exp boost
409                battleboardData.setTilePosition(battleboardId,tileId, positionTo);
410                IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
411                angelCardData.addToAngelExperienceLevel(tile.angelId,tile2.value);
412                battleboardData.killTile(battleboardId,tile2.id);
413                
414            }
415              if (tile2.tileType == 7) {
416                //HP boost
417                battleboardData.setTileHp(battleboardId,tileId, tile.hp+ tile2.value);
418                battleboardData.setTilePosition(battleboardId,tileId, positionTo);
419                battleboardData.killTile(battleboardId,tile2.id);
420            }
421              if (tile2.tileType == 8){
422                //ETH Boost - to be used only in paid boards. 
423                battleboardData.setTilePosition(battleboardId,tileId, positionTo);
424                battleboardData.killTile(battleboardId,tile2.id);
425            }
426              if (tile2.tileType ==9) {
427                //Warp tile
428                if  (battleboardData.getTileIDbyPosition(battleboardId, tile2.value) == 0) {battleboardData.setTilePosition(battleboardId,tileId, tile2.value);}
429                //check if warping directly onto another tile
430                else {battleboardData.setTilePosition(battleboardId,tileId, positionTo);}
431                //if warping directly onto another tile, just stay at the warp tile position. 
432            }
433              if (tile2.tileType ==10){
434                //Medal
435                battleboardData.setTilePosition(battleboardId,tileId, positionTo);
436                IMedalData medalData = IMedalData(medalDataContract);
437                medalData._createMedal(tile.owner,uint8(tile2.value));
438                battleboardData.killTile(battleboardId,tile2.id);
439            }
440             if (tile2.tileType==11) {
441                //Pet Aura Boost
442                battleboardData.setTilePosition(battleboardId,tileId, positionTo);
443                randomPetAuraBoost(tile.petId,tile2.value);
444                battleboardData.killTile(battleboardId,tile2.id);
445             }
446             
447            }
448             //check if yellow HP Boost
449             if (getAuraColor(tile.angelId) == 1) {battleboardData.setTileHp(battleboardId,tileId, tile.hp+ 5);}
450             
451             //check if new position is vulnerable to monster attack. 
452             checkMonsterAttack(battleboardId,tileId,positionTo);
453             
454        }
455        
456        function checkMonsterAttack(uint16 battleboardId, uint8 tileId, uint8 position) private  {
457             IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
458            //get the monster locations
459            uint8 m1;
460            uint8 m2;
461            (m1,m2) = battleboardData.getMonsters(battleboardId);
462            //If a monster is within 2 spots it will automatically attack. 
463            if ((position == m1) || (position == m1 +1) || (position == m1 +2) || (position == m1 +8) || (position == m1 +16) || (position == m1 - 1) || (position == m1 -2) || (position == m1 -8) || (position == m1 -16)) {
464                 if (m1 != 0) {
465                fightMonster(battleboardId, tileId, 1);
466                 }
467            }
468            
469             if ((position == m2) || (position == m2 +1) || (position == m2 +2) || (position == m2 +8) || (position == m2 +16) || (position == m2 -1) || (position == m2 -2) || (position == m2 -8) || (position == m2 -16)) {
470                  if (m2 != 0) {
471                fightMonster(battleboardId, tileId, 2);
472                  }
473            }
474            
475        }
476     
477        function getAngelInfoByTile (uint16 battleboardId, uint8 tileId) public constant returns (uint16 bp, uint8 aura) {
478              IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
479              uint64 angelId;
480             (, ,,,,,angelId,,,) = battleboardData.getTileFromBattleboard(battleboardId, tileId);
481            IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
482            (,,bp,aura,,,,,,,) = angelCardData.getAngel(angelId);
483            return;
484        }
485        
486        function getFastest(uint16 battleboardId, uint8 tile1Id, uint8 tile2Id) public constant returns (bool) {
487           IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
488            uint8 speed1;
489            uint8 speed2;
490               (, speed1,,,,,,,,) = battleboardData.getTileFromBattleboard(battleboardId, tile1Id);
491             (, speed2,,,, ,,,,) = battleboardData.getTileFromBattleboard(battleboardId, tile2Id);
492             if (speed1 >= speed2) return true;
493             return false;
494            
495        }
496        function fightTeams(uint16 battleboardId, uint8 tile1Id, uint8 tile2Id) private returns (bool) {
497            //True return means that team 1 won, false return means team 2 won. 
498            
499            //First get the parameters. 
500            IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
501         
502            uint32 hp1;
503            uint32 hp2;
504     
505            uint16 petPower1;
506            uint16 petPower2;
507            (,,,,hp1, petPower1,,,,) = battleboardData.getTileFromBattleboard(battleboardId, tile1Id);
508            (,,,,hp2, petPower2,,,,) = battleboardData.getTileFromBattleboard(battleboardId, tile2Id);
509            
510           uint16 angel1BP;
511           uint16 angel2BP;
512           uint8 angel1aura;
513           uint8 angel2aura;
514           
515          (angel1BP, angel1aura) = getAngelInfoByTile(battleboardId, tile1Id);
516          (angel2BP, angel2aura) = getAngelInfoByTile(battleboardId, tile2Id);
517         
518         
519         //If red aura, boost battle power
520         if (angel1aura == 4) {angel1BP += 10;}
521         if (angel2aura == 4) {angel2BP += 10;}
522         
523         //if purple aura, 10% chance of sudden kill
524         if ((angel1aura == 2) && (getRandomNumber(100,0,msg.sender) <10)) {return true;}
525         if ((angel2aura == 2) && (getRandomNumber(100,0,msg.sender) <10)) {return false;}
526         
527         
528         //if green aura, 20% chance of +75 hp
529         if ((angel1aura == 5) && (getRandomNumber(100,0,msg.sender) <20)) {hp1 += 75;}
530         if ((angel2aura == 5) && (getRandomNumber(100,0,msg.sender) <20)) {hp2 +=75;}
531         
532         
533            uint16 strike;
534            
535            //attacker (team 1) gets the first strike.
536            //see if strike will be angel and pet or just angel. 
537            strike = Strike(angel1BP,hp1,petPower1,1);
538            if (hp2 > strike) {hp2 = hp2 - strike;}
539            else {return true;}
540            
541            //defender gets the second strike if still alive.  
542            strike = Strike(angel2BP,hp2,petPower2,2);
543            if (hp1 > strike) {hp1 = hp1 - strike;}
544            else {
545                battleboardData.setTileHp(battleboardId, tile2Id, hp2);
546                return false;}
547            
548         // second round (if necessary)
549         
550         if (getFastest(battleboardId, tile1Id, tile2Id)==true) {
551             if (getRandomNumber(100,0,2) > 30) {
552                 //team 1 attacks first. 
553                    strike = Strike(angel1BP,hp1,petPower1,3);
554                    if (hp2 > strike) {hp2 = hp2 - strike;}
555                    else {
556                        battleboardData.setTileHp(battleboardId, tile1Id, hp1);
557                        return true;}
558             }
559             else {
560             //team 2 attacks first    
561             strike = Strike(angel2BP,hp2,petPower2,4);
562            if (hp1 > strike) {hp1 = hp1 - strike;}
563            else {
564            battleboardData.setTileHp(battleboardId, tile2Id, hp2);
565            return false;}
566         }
567         }
568         if (getFastest(battleboardId, tile1Id, tile2Id) == false) {
569                if (getRandomNumber(100,0,2) >70) {
570                 //team 1 attacks first. 
571                    strike = Strike(angel1BP,hp1,petPower1,5);
572                    if (hp2 > strike) {hp2 = hp2 - strike;}
573                    else {
574                        battleboardData.setTileHp(battleboardId, tile1Id, hp1);
575                        return true;}
576                  }
577             else {
578             //team 2 attacks first    
579             strike = Strike(angel2BP,hp2,petPower2,6);
580            if (hp1 > strike) {hp1 = hp1 - strike;}
581            else {
582            battleboardData.setTileHp(battleboardId, tile2Id, hp2);
583            return false;}
584             }
585            }
586            
587              // third round (if necessary)
588         
589         if (getFastest(battleboardId, tile1Id, tile2Id)==true) {
590             if (getRandomNumber(100,0,2) > 30) {
591                 //team 1 attacks first. 
592                    strike = Strike(angel1BP,hp1,petPower1,7);
593                    if (hp2 > strike) {hp2 = hp2 - strike;}
594                    else {
595                        battleboardData.setTileHp(battleboardId, tile1Id, hp1);
596                        return true;}
597             }
598         }
599             else {
600             //team 2 attacks first    
601             strike = Strike(angel2BP,hp2,petPower2,8);
602            if (hp1 > strike) {hp1 = hp1 - strike;}
603            else {battleboardData.setTileHp(battleboardId, tile2Id, hp2);
604                return false;}
605         }
606         if (getFastest(battleboardId, tile1Id, tile2Id) == false) {
607                if (getRandomNumber(100,0,2) >70) {
608                 //team 1 attacks first. 
609                    strike = Strike(angel1BP,hp1,petPower1,9);
610                    if (hp2 > strike) {hp2 = hp2 - strike;}
611                    else {
612                        battleboardData.setTileHp(battleboardId, tile1Id, hp1);
613                        return true;}
614                  }
615             else {
616             //team 2 attacks first    
617             strike = Strike(angel2BP,hp2,petPower2,10);
618            if (hp1 > strike) {hp1 = hp1 - strike;}
619            else {
620                battleboardData.setTileHp(battleboardId, tile2Id, hp2);
621                return false;}
622             }
623            }
624           
625           if (hp1 > hp2) {
626               battleboardData.setTileHp(battleboardId, tile1Id, hp1-hp2);
627               return true;
628           }
629           if (hp1 < hp2) {
630               battleboardData.setTileHp(battleboardId, tile2Id, hp2-hp1);
631               return false;
632           }
633             if (hp1 == hp2) {
634               battleboardData.setTileHp(battleboardId, tile1Id, 1);
635               return true;
636           }
637         //if these titans are still left after 3 rounds, the winner is the one with the most HP. 
638         //The loser's HP goes to 0 and the winner's HP is reduced by the  losers. In the unlikely event of a tie, the winner gets 1 hp. 
639         
640         }
641         function Strike(uint16 bp, uint32 hp, uint16 petPower, uint8 seed) public constant returns (uint16) {
642             if (hp > petHpThreshold) {return getRandomNumber(bp+petPower,20,seed);}
643             return getRandomNumber(bp,20,seed);
644             //Your strike is a return of a random from 20 to bp 
645         }
646         
647            
648        function fightMonster(uint16 battleboardId, uint8 tile1Id, uint8 monsterId) private {
649              //First get the parameters. 
650            IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
651           
652            uint32 hp;
653            uint16 monsterHit= getRandomNumber(maxMonsterHit, uint8(minMonsterHit), msg.sender);
654            uint64 angelId;
655            (, ,,, hp, ,angelId ,,,) = battleboardData.getTileFromBattleboard(battleboardId, tile1Id);
656       
657            if (getAuraColor(angelId) != 0) { // blue angels are immune to monsters. 
658            //see if the angel team dies or just loses hp
659            if (hp > monsterHit) {
660                battleboardData.setTileHp(battleboardId, tile1Id, (hp-monsterHit));
661            }
662            else {battleboardData.killTile(battleboardId, tile1Id);}
663           battleboardData.killMonster(battleboardId, monsterId); 
664            }
665            EventMonsterStrike(battleboardId, angelId, monsterHit);
666            
667        }
668        
669        
670        function canMove(uint16 battleboardId, uint8 position1, uint8 position2) public constant  returns (bool) {
671            //returns true if a piece can move from position 1 to position 2. 
672            
673            //moves up and down are protected from moving off the board by the position numbers. 
674            //Check if trying to move off the board to left 
675            if (((position1 % 8) == 1) && ((position2 == position1-1 ) || (position2 == position1 -2))) {return false;}
676            if (((position1 % 8) == 2) && (position2 == (position1-2))) {return false;}
677            
678            //Now check if trying to move off board to right. 
679             if (((position1 % 8) == 0) && ((position2 == position1+1 ) || (position2 == position1 +2))) {return false;}
680            if (((position1 % 8) == 7) && (position2 == (position1+2))) {return false;}
681            
682              IBattleboardData battleboardData = IBattleboardData(battleboardDataContract);
683            //legal move left. Either move one space or move two spaces, with nothing blocking the first move. 
684            if ((position2 == uint8(safeSubtract(position1,1))) || ((position2 == uint8(safeSubtract(position1,2)))  && (battleboardData.getTileIDbyPosition(battleboardId,position1-1) == 0))) {return true;}
685            
686            //legal move right
687            if ((position2 == position1 +1) || ((position2 == position1 + 2) && (battleboardData.getTileIDbyPosition(battleboardId, position1+1) == 0))) {return true;}
688            
689            //legal move down
690            if ((position2 == position1 +8) || ((position2 == position1 + 16) && (battleboardData.getTileIDbyPosition(battleboardId, position1+8) == 0))) {return true;}
691            
692            //legal move up
693             if ((position2 == uint8(safeSubtract(position1,8))) || ((position2 == uint8(safeSubtract(position1,16)))  && (battleboardData.getTileIDbyPosition(battleboardId,position1-8) == 0))) {return true;}
694           return false;
695            
696        }
697        
698        
699 
700        
701     
702        function randomPetAuraBoost (uint64 _petId, uint8 _boost) private  {
703        IPetCardData petCardData = IPetCardData(petCardDataContract);
704         uint16 auraRed;
705         uint16 auraBlue;
706         uint16 auraYellow;
707         (,,,,auraRed,auraBlue,auraYellow,,,) = petCardData.getPet(_petId);
708                uint8 chance = getRandomNumber(2,0,msg.sender);
709                if (chance ==0) {petCardData.setPetAuras(_petId, uint8(auraRed + _boost), uint8(auraBlue), uint8(auraYellow));}
710                if (chance ==1) {petCardData.setPetAuras(_petId, uint8(auraRed), uint8(auraBlue + _boost), uint8(auraYellow));}
711                if (chance ==2) {petCardData.setPetAuras(_petId, uint8(auraRed), uint8(auraBlue), uint8(auraYellow+ _boost));}
712                }
713          
714          
715 
716 
717 
718        
719        
720        function getAuraColor(uint64 angelId) private constant returns (uint8) {
721               uint8 angelAura;
722             IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
723             (,,,angelAura,,,,,,,) = angelCardData.getAngel(angelId);
724            return angelAura;
725        }
726 
727         function isVulnerable(uint64 _angelId, int8 color) public constant returns (bool) {
728             //Returns true if an angel is vulnerable to a certain color trap 
729             //Red is 1, Yellow is 2, blue is 3
730             uint8 angelAura;
731             IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
732             (,,,angelAura,,,,,,,) = angelCardData.getAngel(_angelId);
733             
734             if (color == 1) {
735                 if ((angelAura == 2) || (angelAura == 3) || (angelAura == 4)) {return true;}
736             }
737             
738             if (color == 2) {
739                 if ((angelAura == 1) || (angelAura == 3) || (angelAura == 5)) {return true;}
740             }
741             
742             if (color == 3) {
743                 if ((angelAura == 0) || (angelAura == 2) || (angelAura == 5)) {return true;}
744             }
745             
746             
747             
748         }
749   
750            function kill() onlyCREATOR external {
751         selfdestruct(creatorAddress);
752     }
753  
754         
755 function withdrawEther()  onlyCREATOR external {
756     creatorAddress.transfer(this.balance);
757 }
758 
759       
760         
761    
762 }