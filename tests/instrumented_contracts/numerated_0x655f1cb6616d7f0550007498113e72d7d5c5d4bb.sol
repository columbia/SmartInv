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
52 
53 contract SafeMath {
54     function safeAdd(uint x, uint y) pure internal returns(uint) {
55       uint z = x + y;
56       assert((z >= x) && (z >= y));
57       return z;
58     }
59 
60     function safeSubtract(uint x, uint y) pure internal returns(uint) {
61       assert(x >= y);
62       uint z = x - y;
63       return z;
64     }
65 
66     function safeMult(uint x, uint y) pure internal returns(uint) {
67       uint z = x * y;
68       assert((x == 0)||(z/x == y));
69       return z;
70     }
71 
72     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
73         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
74         return uint8(genNum % (maxRandom - min + 1)+min);
75     }
76 }
77 
78 contract Enums {
79     enum ResultCode {
80         SUCCESS,
81         ERROR_CLASS_NOT_FOUND,
82         ERROR_LOW_BALANCE,
83         ERROR_SEND_FAIL,
84         ERROR_NOT_OWNER,
85         ERROR_NOT_ENOUGH_MONEY,
86         ERROR_INVALID_AMOUNT
87     }
88 
89     enum AngelAura { 
90         Blue, 
91         Yellow, 
92         Purple, 
93         Orange, 
94         Red, 
95         Green 
96     }
97 }
98 
99 
100 contract IAngelCardData is AccessControl, Enums {
101     uint8 public totalAngelCardSeries;
102     uint64 public totalAngels;
103 
104     
105     // write
106     // angels
107     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
108     function updateAngelCardSeries(uint8 _angelCardSeriesId, uint64 _newPrice, uint64 _newMaxTotal) onlyCREATOR external;
109     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
110     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
111     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
112     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
113     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
114     function addAngelIdMapping(address _owner, uint64 _angelId) private;
115     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
116     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
117     function updateAngelLock (uint64 _angelId, bool newValue) public;
118     function removeCreator() onlyCREATOR external;
119 
120     // read
121     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
122     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
123     function getOwnerAngelCount(address _owner) constant public returns(uint);
124     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
125     function getTotalAngelCardSeries() constant public returns (uint8);
126     function getTotalAngels() constant public returns (uint64);
127     function getAngelLockStatus(uint64 _angelId) constant public returns (bool);
128 }
129 
130 
131 contract IPetCardData is AccessControl, Enums {
132     uint8 public totalPetCardSeries;    
133     uint64 public totalPets;
134     
135     // write
136     function createPetCardSeries(uint8 _petCardSeriesId, uint32 _maxTotal) onlyCREATOR public returns(uint8);
137     function setPet(uint8 _petCardSeriesId, address _owner, string _name, uint8 _luck, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue) onlySERAPHIM external returns(uint64);
138     function setPetAuras(uint64 _petId, uint8 _auraRed, uint8 _auraBlue, uint8 _auraYellow) onlySERAPHIM external;
139     function setPetLastTrainingTime(uint64 _petId) onlySERAPHIM external;
140     function setPetLastBreedingTime(uint64 _petId) onlySERAPHIM external;
141     function addPetIdMapping(address _owner, uint64 _petId) private;
142     function transferPet(address _from, address _to, uint64 _petId) onlySERAPHIM public returns(ResultCode);
143     function ownerPetTransfer (address _to, uint64 _petId)  public;
144     function setPetName(string _name, uint64 _petId) public;
145 
146     // read
147     function getPetCardSeries(uint8 _petCardSeriesId) constant public returns(uint8 petCardSeriesId, uint32 currentPetTotal, uint32 maxPetTotal);
148     function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, string name, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, uint64 lastTrainingTime, uint64 lastBreedingTime, address owner);
149     function getOwnerPetCount(address _owner) constant public returns(uint);
150     function getPetByIndex(address _owner, uint _index) constant public returns(uint);
151     function getTotalPetCardSeries() constant public returns (uint8);
152     function getTotalPets() constant public returns (uint);
153 }
154 contract IAccessoryData is AccessControl, Enums {
155     uint8 public totalAccessorySeries;    
156     uint32 public totalAccessories;
157     
158  
159     /*** FUNCTIONS ***/
160     //*** Write Access ***//
161     function createAccessorySeries(uint8 _AccessorySeriesId, uint32 _maxTotal, uint _price) onlyCREATOR public returns(uint8) ;
162 	function setAccessory(uint8 _AccessorySeriesId, address _owner) onlySERAPHIM external returns(uint64);
163    function addAccessoryIdMapping(address _owner, uint64 _accessoryId) private;
164 	function transferAccessory(address _from, address _to, uint64 __accessoryId) onlySERAPHIM public returns(ResultCode);
165     function ownerAccessoryTransfer (address _to, uint64 __accessoryId)  public;
166     function updateAccessoryLock (uint64 _accessoryId, bool newValue) public;
167     function removeCreator() onlyCREATOR external;
168     
169     //*** Read Access ***//
170     function getAccessorySeries(uint8 _accessorySeriesId) constant public returns(uint8 accessorySeriesId, uint32 currentTotal, uint32 maxTotal, uint price) ;
171 	function getAccessory(uint _accessoryId) constant public returns(uint accessoryID, uint8 AccessorySeriesID, address owner);
172 	function getOwnerAccessoryCount(address _owner) constant public returns(uint);
173 	function getAccessoryByIndex(address _owner, uint _index) constant public returns(uint) ;
174     function getTotalAccessorySeries() constant public returns (uint8) ;
175     function getTotalAccessories() constant public returns (uint);
176     function getAccessoryLockStatus(uint64 _acessoryId) constant public returns (bool);
177 }
178 
179 
180 contract ILeaderboardData is AccessControl, SafeMath {
181 
182     /*** DATA TYPES ***/
183 
184     uint8 public maxRankingSpots;
185     uint8 public teamsOnLeaderboard;
186 
187     // write functions
188  
189       
190     function setMaxRankingSpots(uint8 spots)  onlyCREATOR external ;
191         function startLeaderboard (uint64 angelId, uint64 petId, uint64 accessoryId)  onlyCREATOR external;
192         function addtoLeaderboard(uint64 angelId, uint64 petId, uint64 accessoryId)  onlySERAPHIM external ;
193         function newTeamOnEnd(uint64 angelId, uint64 petId, uint64 accessoryId)  onlySERAPHIM external ;
194         function switchRankings (uint8 spot,uint64 angel1ID, uint64 pet1ID, uint64 accessory1ID,uint64 angel2ID,uint64 pet2ID,uint64 accessory2ID ) onlySERAPHIM external ;
195         function verifyPosition(uint8 spot, uint64 angelID, uint64 petID, uint64 accessoryID) external constant onlySERAPHIM returns (bool) ;
196         function angelOnLeaderboard(uint64 angelID) external onlySERAPHIM constant returns (bool);
197         function petOnLeaderboard(uint64 petID) external onlySERAPHIM constant returns (bool);
198         
199 
200     /// Read access
201     
202     function getMaxRankingSpots () public constant returns (uint16) ;
203     function getTeamByPosition (uint8 position) external constant returns (uint64 angelId, uint64 petId, uint64 accessoryId);
204     function getTeamsOnLeaderboard() public constant returns (uint16);
205       
206 } 
207 
208 contract IMedalData is AccessControl {
209   
210     modifier onlyOwnerOf(uint256 _tokenId) {
211     require(ownerOf(_tokenId) == msg.sender);
212     _;
213   }
214    
215 function totalSupply() public view returns (uint256);
216 function setMaxTokenNumbers()  onlyCREATOR external;
217 function balanceOf(address _owner) public view returns (uint256);
218 function tokensOf(address _owner) public view returns (uint256[]) ;
219 function ownerOf(uint256 _tokenId) public view returns (address);
220 function approvedFor(uint256 _tokenId) public view returns (address) ;
221 function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId);
222 function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId);
223 function takeOwnership(uint256 _tokenId) public;
224 function _createMedal(address _to, uint8 _seriesID) onlySERAPHIM public ;
225 function getCurrentTokensByType(uint32 _seriesID) public constant returns (uint32);
226 function getMedalType (uint256 _tokenId) public constant returns (uint8);
227 function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) external;
228 function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) ;
229 function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal;
230 function clearApproval(address _owner, uint256 _tokenId) private;
231 function addToken(address _to, uint256 _tokenId) private ;
232 function removeToken(address _from, uint256 _tokenId) private;
233 }
234 
235 //INSTURCTIONS: You can access this contract through our webUI at angelbattles.com (preferred)
236 //You can also access this contract directly by sending a transaction the the medal you wish to claim
237 //Variable names are self explanatory, but contact us if you have any questions. 
238 
239 contract MedalClaim is AccessControl, SafeMath  {
240     // Addresses for other contracts MedalClaim interacts with. 
241     address public angelCardDataContract = 0x6D2E76213615925c5fc436565B5ee788Ee0E86DC;
242     address public petCardDataContract = 0xB340686da996b8B3d486b4D27E38E38500A9E926;
243     address public accessoryDataContract = 0x466c44812835f57b736ef9F63582b8a6693A14D0;
244     address public leaderboardDataContract = 0x9A1C755305c6fbf361B4856c9b6b6Bbfe3aCE738;
245     address public medalDataContract =  0x33A104dCBEd81961701900c06fD14587C908EAa3;
246     
247     // events
248      event EventMedalSuccessful(address owner,uint64 Medal);
249   
250 
251     /*** DATA TYPES ***/
252 
253     struct Angel {
254         uint64 angelId;
255         uint8 angelCardSeriesId;
256         address owner;
257         uint16 battlePower;
258         uint8 aura;
259         uint16 experience;
260       
261     }
262 
263     struct Pet {
264         uint64 petId;
265         uint8 petCardSeriesId;
266         address owner;
267         string name;
268         uint8 luck;
269         uint16 auraRed;
270         uint16 auraYellow;
271         uint16 auraBlue;
272      
273     }
274     
275      struct Accessory {
276         uint accessoryId;
277         uint8 accessorySeriesId;
278         address owner;
279     }
280     
281          // Stores which address have claimed which tokens, to avoid one address claiming the same token twice.
282          //Note - this does NOT affect medals won on the sponsored leaderboards;
283   mapping (address => bool[12]) public claimedbyAddress;
284   
285   //Stores which cards have been used to claim medals, to avoid transfering a key card to another account and claiming another medal. 
286   mapping (uint64 => bool) public angelsClaimedCardboard;
287   mapping (uint64 => bool) public petsClaimedGold;
288 
289 
290     // write functions
291     function DataContacts(address _angelCardDataContract, address _petCardDataContract, address _accessoryDataContract, address _leaderboardDataContract, address _medalDataContract) onlyCREATOR external {
292         angelCardDataContract = _angelCardDataContract;
293         petCardDataContract = _petCardDataContract;
294         accessoryDataContract = _accessoryDataContract;
295         leaderboardDataContract = _leaderboardDataContract;
296         medalDataContract = _medalDataContract;
297     }
298        
299     function checkExistsOwnedAngel (uint64 angelId) private constant returns (bool) {
300         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
301        
302         if ((angelId <= 0) || (angelId > angelCardData.getTotalAngels())) {return false;}
303         address angelowner;
304         (,,,,,,,,,,angelowner) = angelCardData.getAngel(angelId);
305         if (angelowner == msg.sender) {return true;}
306         
307        else  return false;
308 }
309 
310     function checkExistsOwnedPet (uint64 petId) private constant returns (bool) {
311           IPetCardData petCardData = IPetCardData(petCardDataContract);
312        
313         if ((petId <= 0) || (petId > petCardData.getTotalPets())) {return false;}
314         address petowner;
315          (,,,,,,,petowner) = petCardData.getPet(petId);
316         if (petowner == msg.sender) {return true;}
317         
318        else  return false;
319 }
320 
321 
322     function getPetCardSeries (uint64 petId) public constant returns (uint8) {
323           IPetCardData petCardData = IPetCardData(petCardDataContract);
324        
325         if ((petId <= 0) || (petId > petCardData.getTotalPets())) {revert();}
326         uint8 seriesId;
327          (,seriesId,,,,,,,,) = petCardData.getPet(petId);
328         return uint8(seriesId);
329         }
330 
331      function claim1Ply(uint64 angel1Id, uint64 angel2Id, uint64 angel3Id, uint64 angel4Id, uint64 angel5Id) public {
332          
333          //can only claim each medal once per address. 
334          if (claimedbyAddress[msg.sender][0] == true) {revert();}
335          
336          //angelIds must be called in ORDER. This prevents computationally expensive checks to avoid duplicates. 
337          if ((angel1Id < angel2Id) && (angel2Id < angel3Id) && (angel3Id < angel4Id) && (angel4Id <angel5Id)) {
338              if ((checkExistsOwnedAngel(angel1Id) == true) && (checkExistsOwnedAngel(angel2Id) == true) && (checkExistsOwnedAngel(angel3Id) == true) && (checkExistsOwnedAngel(angel4Id) == true)  && (checkExistsOwnedAngel(angel5Id) == true)) {
339              IMedalData medalData = IMedalData(medalDataContract);   
340              medalData._createMedal(msg.sender, 0);
341              EventMedalSuccessful(msg.sender,0);
342              claimedbyAddress[msg.sender][0] = true;
343              }
344              
345          }
346      }
347         
348          function claim2Ply(uint64 geckoId, uint64 parakeetId, uint64 catId, uint64 horseId) public {
349         
350           //can only claim each medal once per address. 
351          if (claimedbyAddress[msg.sender][1] == true) {revert();}
352          if ((getPetCardSeries(geckoId) == 1) && (getPetCardSeries(parakeetId) == 2) && (getPetCardSeries(catId) == 3) && (getPetCardSeries(horseId) == 4)) {
353              if ((checkExistsOwnedPet(geckoId) == true) && (checkExistsOwnedPet(parakeetId) == true) && (checkExistsOwnedPet(catId) == true) && (checkExistsOwnedPet(horseId) == true)) {
354              IMedalData medalData = IMedalData(medalDataContract);   
355              claimedbyAddress[msg.sender][1] = true;
356              medalData._createMedal(msg.sender, 1);
357              EventMedalSuccessful(msg.sender,1);
358              }
359              
360          }
361      }
362         function claimCardboard(uint64 angelId) public {
363             
364               //can only claim each medal once per address. 
365          if (claimedbyAddress[msg.sender][2] == true) {revert();}
366         
367             if  (checkExistsOwnedAngel(angelId) == true) {
368                     IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
369                     uint16 experience;
370                     (,,,,experience,,,,,,) = angelCardData.getAngel(angelId);
371                     if (experience >= 100) {
372                          claimedbyAddress[msg.sender][2] = true;
373                          IMedalData medalData = IMedalData(medalDataContract);   
374                          medalData._createMedal(msg.sender, 2);
375                          EventMedalSuccessful(msg.sender,2);
376                     }
377             }
378          }
379              
380   
381              
382          function claimSilver(uint64 blueAngel, uint64 redAngel, uint64 greenAngel, uint64 purpleAngel, uint64 yellowAngel, uint64 orangeAngel) public {
383              
384                  //can only claim each medal once per address. 
385             if (claimedbyAddress[msg.sender][4] == true) {revert();}
386                 uint8[6] memory Auras;
387                 IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
388             if  ((checkExistsOwnedAngel(blueAngel) == true) && (checkExistsOwnedAngel(redAngel) == true) && (checkExistsOwnedAngel(greenAngel) == true) && (checkExistsOwnedAngel(purpleAngel) == true) && (checkExistsOwnedAngel(yellowAngel) == true) && (checkExistsOwnedAngel(orangeAngel) == true)) {
389                    //read all Aura colors       
390                     (,,,Auras[0],,,,,,,) = angelCardData.getAngel(blueAngel);
391                     (,,,Auras[1],,,,,,,) = angelCardData.getAngel(yellowAngel);
392                     (,,,Auras[2],,,,,,,) = angelCardData.getAngel(purpleAngel);
393                     (,,,Auras[3],,,,,,,) = angelCardData.getAngel(orangeAngel);
394                     (,,,Auras[4],,,,,,,) = angelCardData.getAngel(redAngel);
395                     (,,,Auras[5],,,,,,,) = angelCardData.getAngel(greenAngel);
396                     //make sure each angel is of appropriate aura color
397                     for (uint i=0;i<6;i++) {
398                         if (Auras[i] != i) {revert();}
399                     }
400                         claimedbyAddress[msg.sender][4] == true;
401                         IMedalData medalData = IMedalData(medalDataContract);   
402                         medalData._createMedal(msg.sender, 4);
403                         EventMedalSuccessful(msg.sender,4);
404                     }
405         
406          }
407         
408         function claimGold(uint64 direDragonId, uint64 phoenixId, uint64 ligerId, uint64 alicornId) public  {
409            //can only claim each medal once per address
410          if (claimedbyAddress[msg.sender][5] == true) {revert();}
411          
412          //pets can each only be used once for this medal
413          if ((petsClaimedGold[direDragonId] == true) || (petsClaimedGold[phoenixId] == true) || (petsClaimedGold[ligerId] == true) || (petsClaimedGold[alicornId]== true)) {revert();}
414          
415          if ((getPetCardSeries(direDragonId) == 13) && (getPetCardSeries(phoenixId) == 14) && (getPetCardSeries(ligerId) == 15) && (getPetCardSeries(alicornId) == 16)) {
416              if ((checkExistsOwnedPet(direDragonId) == true) && (checkExistsOwnedPet(phoenixId) == true) && (checkExistsOwnedPet(ligerId) == true) && (checkExistsOwnedPet(alicornId) == true)) {
417              petsClaimedGold[direDragonId] = true;
418              petsClaimedGold[phoenixId] = true;
419              petsClaimedGold[ligerId] = true;
420              petsClaimedGold[alicornId] = true;
421              claimedbyAddress[msg.sender][5] = true;
422              IMedalData medalData = IMedalData(medalDataContract);   
423              medalData._createMedal(msg.sender, 5);
424              EventMedalSuccessful(msg.sender,5);
425              }
426              
427          }
428      }
429           
430         
431            function claimPlatinum(uint64 angelId) public {
432         
433          //can only claim each medal once per address
434          if (claimedbyAddress[msg.sender][6] == true) {revert();}
435             if  (checkExistsOwnedAngel(angelId) == true) {
436                      ILeaderboardData leaderboardData = ILeaderboardData(leaderboardDataContract);   
437             if ((leaderboardData.verifyPosition(0, angelId, 0, 0) == true) || (leaderboardData.verifyPosition(1, angelId, 0, 0) == true)  || (leaderboardData.verifyPosition(2, angelId, 0, 0) == true)) {
438                          claimedbyAddress[msg.sender][6] = true;
439                          IMedalData medalData = IMedalData(medalDataContract);   
440                         medalData._createMedal(msg.sender, 6);
441                          EventMedalSuccessful(msg.sender,6);
442                     }
443             }
444          }
445          
446               
447         function claimStupidFluffyPink(uint64 petId) public {
448          //can only claim each medal once per address
449          if (claimedbyAddress[msg.sender][7] == true) {revert();}
450          
451          if ((getPetCardSeries(petId) == 13) || (getPetCardSeries(petId) == 14) || (getPetCardSeries(petId) == 15) || (getPetCardSeries(petId) == 16)) {
452              if ((checkExistsOwnedPet(petId) == true) ) {
453              IMedalData medalData = IMedalData(medalDataContract); 
454              claimedbyAddress[msg.sender][7] = true;
455              medalData._createMedal(msg.sender, 7);
456              EventMedalSuccessful(msg.sender,7);
457              }
458              
459          }
460      }
461      
462      function ClaimOrichalcum() public {
463          
464             //can only claim each medal once per address
465          if (claimedbyAddress[msg.sender][8] == true) {revert();}
466               IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
467               IPetCardData petCardData = IPetCardData(petCardDataContract);
468               IAccessoryData accessoryData = IAccessoryData(accessoryDataContract);
469               
470               if ((angelCardData.getOwnerAngelCount(msg.sender) >= 15) && (petCardData.getOwnerPetCount(msg.sender) >= 25) && (accessoryData.getOwnerAccessoryCount(msg.sender) >= 10) ) {
471              IMedalData medalData = IMedalData(medalDataContract);
472              claimedbyAddress[msg.sender][8] = true;
473              medalData._createMedal(msg.sender, 8);
474              EventMedalSuccessful(msg.sender,8);    
475               }
476      }
477      
478      
479       
480       function getAngelClaims (uint64 angelId) public constant returns (bool claimedCardboard) {
481           //before purchasing an angel card, anyone can verify if that card has already been used to claim medals
482           if (angelId < 0) {revert();}
483           claimedCardboard = angelsClaimedCardboard[angelId];
484 
485       }
486       
487           function getPetClaims (uint64 petId) public constant returns (bool claimedGold) {
488           //before purchasing a pet card, anyone can verify if that card has already been used to claim medals
489           if (petId < 0) {revert();}
490 
491           claimedGold = petsClaimedGold[petId];
492       }
493       
494      
495      
496      function getAddressClaims(address _address, uint8 _medal) public constant returns (bool) {
497          return claimedbyAddress[_address][_medal];
498      }
499      
500      
501       
502       function kill() onlyCREATOR external {
503         selfdestruct(creatorAddress);
504     }
505 }