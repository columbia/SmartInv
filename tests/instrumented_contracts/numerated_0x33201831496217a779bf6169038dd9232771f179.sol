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
53 contract IBattleboardData is AccessControl  {
54 
55   
56 
57       // write functions
58   
59 function createBattleboard(uint prize, uint8 restrictions) onlySERAPHIM external returns (uint16);
60 function killMonster(uint16 battleboardId, uint8 monsterId)  onlySERAPHIM external;
61 function createNullTile(uint16 _battleboardId) private ;
62 function createTile(uint16 _battleboardId, uint8 _tileType, uint8 _value, uint8 _position, uint32 _hp, uint16 _petPower, uint64 _angelId, uint64 _petId, address _owner, uint8 _team) onlySERAPHIM external  returns (uint8);
63 function killTile(uint16 battleboardId, uint8 tileId) onlySERAPHIM external ;
64 function addTeamtoBoard(uint16 battleboardId, address owner, uint8 team) onlySERAPHIM external;
65 function setTilePosition (uint16 battleboardId, uint8 tileId, uint8 _positionTo) onlySERAPHIM public ;
66 function setTileHp(uint16 battleboardId, uint8 tileId, uint32 _hp) onlySERAPHIM external ;
67 function addMedalBurned(uint16 battleboardId) onlySERAPHIM external ;
68 function setLastMoveTime(uint16 battleboardId) onlySERAPHIM external ;
69 function iterateTurn(uint16 battleboardId) onlySERAPHIM external ;
70 function killBoard(uint16 battleboardId) onlySERAPHIM external ;
71 function clearAngelsFromBoard(uint16 battleboardId) private;
72 //Read functions
73      
74 function getTileHp(uint16 battleboardId, uint8 tileId) constant external returns (uint32) ;
75 function getMedalsBurned(uint16 battleboardId) constant external returns (uint8) ;
76 function getTeam(uint16 battleboardId, uint8 tileId) external returns (uint8) ;
77 function getMaxFreeTeams() constant public returns (uint8);
78 function getBarrierNum(uint16 battleboardId) public constant returns (uint8) ;
79 function getTileFromBattleboard(uint16 battleboardId, uint8 tileId) public constant returns (uint8 tileType, uint8 value, uint8 id, uint8 position, uint32 hp, uint16 petPower, uint64 angelId, uint64 petId, bool isLive, address owner)   ;
80 function getTileIDByOwner(uint16 battleboardId, address _owner) constant public returns (uint8) ;
81 function getPetbyTileId( uint16 battleboardId, uint8 tileId) constant public returns (uint64) ;
82 function getOwner (uint16 battleboardId, uint8 team,  uint8 ownerNumber) constant external returns (address);
83 function getTileIDbyPosition(uint16 battleboardId, uint8 position) public constant returns (uint8) ;
84 function getPositionFromBattleboard(uint16 battleboardId, uint8 _position) public constant returns (uint8 tileType, uint8 value, uint8 id, uint8 position, uint32 hp, uint32 petPower, uint64 angelId, uint64 petId, bool isLive)  ;
85 function getBattleboard(uint16 id) public constant returns (uint8 turn, bool isLive, uint prize, uint8 numTeams, uint8 numTiles, uint8 createdBarriers, uint8 restrictions, uint lastMoveTime, uint8 numTeams1, uint8 numTeams2, uint8 monster1, uint8 monster2) ;
86 function isBattleboardLive(uint16 battleboardId) constant public returns (bool);
87 function isTileLive(uint16 battleboardId, uint8 tileId) constant  external returns (bool) ;
88 function getLastMoveTime(uint16 battleboardId) constant public returns (uint) ;
89 function getNumTilesFromBoard (uint16 _battleboardId) constant public returns (uint8) ; 
90 function angelOnBattleboards(uint64 angelID) external constant returns (bool) ;
91 function getTurn(uint16 battleboardId) constant public returns (address) ;
92 function getNumTeams(uint16 battleboardId, uint8 team) public constant returns (uint8);
93 function getMonsters(uint16 BattleboardId) external constant returns (uint8 monster1, uint8 monster2) ;
94 function getTotalBattleboards() public constant returns (uint16) ;
95   
96         
97  
98    
99 }
100 
101 contract BattleboardData is IBattleboardData  {
102 
103     /*** DATA TYPES ***/
104        
105   
106   //Most main pieces on the board are tiles.   
107       struct Tile {
108         uint8 tileType;
109         uint8 value; //speed for angels, otherwise value of other types. 
110         uint8 id;
111         uint8 position;
112         uint32 hp;
113         uint16 petPower;
114         uint8 team; //which team they are on. 
115         uint64 angelId;
116         uint64 petId;
117         bool isLive;
118         address owner;
119         
120     }
121     
122       struct Battleboard {
123         uint8 turn; //turn number - turn 0 is the first player who enters the board. 
124         address[] players;
125         bool isLive;
126         uint prize;
127         uint16 id;
128         uint8 numTeams; //number of angel/pet teams on the board, different than TEAM1 vs TEAM2
129         uint8 numTiles;
130         uint8 createdBarriers;
131         uint8 restrictions; //number of which angels can be added. 
132         uint lastMoveTime;
133         address[] team1;
134         address[] team2; //addresses of the owners of teams 1 and 2
135         uint8 numTeams1;
136         uint8 numTeams2;
137         uint8 monster1; //tile number of the monster locations. 
138         uint8 monster2;
139         uint8 medalsBurned;
140     }
141 
142     //main storage
143     Battleboard []  Battleboards;
144     
145     uint16 public totalBattleboards;
146     
147     uint8 maxFreeTeams = 6;
148     uint8 maxPaidTeams = 4;
149     
150     //Each angel can only be on one board at a time. 
151     mapping (uint64 => bool) angelsOnBattleboards; 
152 
153     //Map the battleboard ID to an array of all tiles on that board. 
154     mapping (uint32 => Tile[]) TilesonBoard;
155     
156     //for each battleboardId(uint16) there is a number with the tileId of the tile. TileId 0 means blank. 
157     mapping (uint16 => uint8 [64]) positionsTiles;
158     
159     
160     
161       // write functions
162   
163        function createBattleboard(uint prize, uint8 restrictions) onlySERAPHIM external returns (uint16) {
164            Battleboard memory battleboard;
165            battleboard.restrictions = restrictions;
166            battleboard.isLive = false; //will be live once ALL teams are added. 
167            battleboard.prize = prize;
168            battleboard.id = totalBattleboards;
169            battleboard.numTeams = 0;
170            battleboard.lastMoveTime = now;
171            totalBattleboards += 1;
172            battleboard.numTiles = 0;
173           //set the monster positions
174            battleboard.monster1 = getRandomNumber(30,17,1);
175            battleboard.monster2 = getRandomNumber(48,31,2); 
176            Battleboards.push(battleboard);
177           createNullTile(totalBattleboards-1);
178            return (totalBattleboards - 1);
179        }
180        
181          
182       
183       function killMonster(uint16 battleboardId, uint8 monsterId)  onlySERAPHIM external{
184           if (monsterId == 1) {
185               Battleboards[battleboardId].monster1 = 0;
186           }
187           if (monsterId ==2) {
188                Battleboards[battleboardId].monster2 = 0;
189           }
190       }
191         
192         function createNullTile(uint16 _battleboardId) private    {
193       //We need to create a tile with ID 0 that won't be on the board. This lets us know if any other tile is ID 0 then that means it's a blank tile. 
194         if ((_battleboardId <0) || (_battleboardId > totalBattleboards)) {revert();}
195         Tile memory tile ;
196         tile.tileType = 0; 
197         tile.id = 0;
198         tile.isLive = true;
199         TilesonBoard[_battleboardId].push(tile);
200      
201     }
202         
203         function createTile(uint16 _battleboardId, uint8 _tileType, uint8 _value, uint8 _position, uint32 _hp, uint16 _petPower, uint64 _angelId, uint64 _petId, address _owner, uint8 _team) onlySERAPHIM external  returns (uint8)   {
204       //main function to create a tile and add it to the board. 
205         if ((_battleboardId <0) || (_battleboardId > totalBattleboards)) {revert();}
206         if ((angelsOnBattleboards[_angelId] == true) && (_angelId != 0)) {revert();}
207         angelsOnBattleboards[_angelId] = true;
208         Tile memory tile ;
209         tile.tileType = _tileType; 
210         tile.value = _value;
211         tile.position= _position;
212         tile.hp = _hp;
213         Battleboards[_battleboardId].numTiles +=1;
214         tile.id = Battleboards[_battleboardId].numTiles;
215         positionsTiles[_battleboardId][_position+1] = tile.id;
216         tile.petPower = _petPower;
217         tile.angelId = _angelId;
218         tile.petId = _petId;
219         tile.owner = _owner;
220         tile.team = _team;
221         tile.isLive = true;
222         TilesonBoard[_battleboardId].push(tile);
223         return (Battleboards[_battleboardId].numTiles);
224     }
225      
226      function killTile(uint16 battleboardId, uint8 tileId) onlySERAPHIM external {
227      
228       TilesonBoard[battleboardId][tileId].isLive= false;
229       TilesonBoard[battleboardId][tileId].tileType= 0;
230       for (uint i =0; i< Battleboards[battleboardId].team1.length; i++) {
231           if (Battleboards[battleboardId].team1[i] == TilesonBoard[battleboardId][tileId].owner) {
232              //should be safe because a team can't be killed if there are 0 teams to kill. 
233              Battleboards[battleboardId].numTeams1 -= 1; 
234           }
235       }
236       for (i =0; i< Battleboards[battleboardId].team2.length; i++) {
237           if (Battleboards[battleboardId].team2[i] == TilesonBoard[battleboardId][tileId].owner) {
238              //should be safe because a team can't be killed if there are 0 teams to kill. 
239              Battleboards[battleboardId].numTeams2 -= 1; 
240           }
241       }
242     }
243      
244      function addTeamtoBoard(uint16 battleboardId, address owner, uint8 team) onlySERAPHIM external {
245         
246         //Can't add a team if the board is live, or if the board is already full of teams. 
247          if (Battleboards[battleboardId].isLive == true) {revert();}
248          if ((Battleboards[battleboardId].prize == 0) &&(Battleboards[battleboardId].numTeams == maxFreeTeams)) {revert();}
249          if ((Battleboards[battleboardId].prize != 0) &&(Battleboards[battleboardId].numTeams == maxPaidTeams)) {revert();}
250          
251          //only one team per address can be on the board. 
252          for (uint i =0; i<Battleboards[battleboardId].numTeams; i++) {
253              if (Battleboards[battleboardId].players[i] == owner) {revert();}
254          }
255          Battleboards[battleboardId].numTeams += 1;
256          Battleboards[battleboardId].players.push(owner);
257          
258          if (team == 1) {
259          Battleboards[battleboardId].numTeams1 += 1;
260          Battleboards[battleboardId].team1.push(owner);
261          }
262          if (team == 2) {
263          Battleboards[battleboardId].numTeams2 += 1;
264          Battleboards[battleboardId].team2.push(owner);
265          
266          //if the board is now full, then go ahead and make it live. 
267          if ((Battleboards[battleboardId].numTeams1 == 3) && (Battleboards[battleboardId].numTeams2 ==3)) {Battleboards[battleboardId].isLive = true;}
268         if ((Battleboards[battleboardId].prize != 0) &&(Battleboards[battleboardId].numTeams == maxPaidTeams)) {Battleboards[battleboardId].isLive = true;}
269          }
270           
271      }
272        
273         function setTilePosition (uint16 battleboardId, uint8 tileId, uint8 _positionTo) onlySERAPHIM public  {
274             TilesonBoard[battleboardId][tileId].position= _positionTo;
275             positionsTiles[battleboardId][_positionTo+1] = tileId;
276             
277         }
278         
279         function setTileHp(uint16 battleboardId, uint8 tileId, uint32 _hp) onlySERAPHIM external {
280             TilesonBoard[battleboardId][tileId].hp = _hp;
281         }
282         
283           function addMedalBurned(uint16 battleboardId) onlySERAPHIM external {
284             Battleboards[battleboardId].medalsBurned += 1;
285         }
286         
287         function withdrawEther()  onlyCREATOR external {
288    //shouldn't have any eth here but just in case. 
289     creatorAddress.transfer(this.balance);
290 }
291 
292 function setLastMoveTime(uint16 battleboardId) onlySERAPHIM external {
293         Battleboards[battleboardId].lastMoveTime = now;
294         
295         
296     }
297     
298       function iterateTurn(uint16 battleboardId) onlySERAPHIM external {
299             if (Battleboards[battleboardId].turn  == (Battleboards[battleboardId].players.length-1)) {
300                 Battleboards[battleboardId].turn = 0;
301             } 
302             else {Battleboards[battleboardId].turn += 1;}
303         }
304         
305          function killBoard(uint16 battleboardId) onlySERAPHIM external {
306            Battleboards[battleboardId].isLive = false;
307            clearAngelsFromBoard(battleboardId);
308        }
309     
310     
311         function clearAngelsFromBoard(uint16 battleboardId) private {
312          //Free up angels to be used on other boards. 
313          for (uint i = 0; i < Battleboards[battleboardId].numTiles; i++) {
314             if (TilesonBoard[battleboardId][i].angelId != 0) {
315                 angelsOnBattleboards[TilesonBoard[battleboardId][i].angelId] = false;
316               }
317          } 
318   
319     }
320 
321 //Read functions
322      
323         function getTileHp(uint16 battleboardId, uint8 tileId) constant external returns (uint32) {
324             return TilesonBoard[battleboardId][tileId].hp;
325         }
326         
327       
328         function getMedalsBurned(uint16 battleboardId) constant external returns (uint8) {
329             return Battleboards[battleboardId].medalsBurned;
330         }
331   
332  
333  function getTeam(uint16 battleboardId, uint8 tileId) external returns (uint8) {
334      TilesonBoard[battleboardId][tileId].team;
335  }
336         
337 
338 
339 function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
340         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
341         return uint8(genNum % (maxRandom - min + 1)+min);
342         }
343 
344        
345        function getMaxFreeTeams() constant public returns (uint8) {
346           return maxFreeTeams;
347        }
348   
349         function getBarrierNum(uint16 battleboardId) public constant returns (uint8) {
350             return Battleboards[battleboardId].createdBarriers;
351         }
352 
353     // Call to get the specified tile at a certain position of a certain board. 
354    function getTileFromBattleboard(uint16 battleboardId, uint8 tileId) public constant returns (uint8 tileType, uint8 value, uint8 id, uint8 position, uint32 hp, uint16 petPower, uint64 angelId, uint64 petId, bool isLive, address owner)   {
355       
356         if ((battleboardId <0) ||  (battleboardId > totalBattleboards)) {revert();}
357         Battleboard memory battleboard = Battleboards[battleboardId];
358         Tile memory tile;
359         if ((tileId <0) || (tileId> battleboard.numTiles)) {revert();}
360         tile = TilesonBoard[battleboardId][tileId];
361         tileType = tile.tileType; 
362         value = tile.value;
363         id= tile.id;
364         position = tile.position;
365         hp = tile.hp;
366         petPower = tile.petPower;
367         angelId = tile.angelId;
368         petId = tile.petId;
369         owner = tile.owner;
370         isLive = tile.isLive;
371         
372     }
373     
374     //Each player (address) can only have one tile on each board. 
375     function getTileIDByOwner(uint16 battleboardId, address _owner) constant public returns (uint8) {
376         for (uint8 i = 0; i < Battleboards[battleboardId].numTiles+1; i++) {
377             if (TilesonBoard[battleboardId][i].owner == _owner) {
378                 return TilesonBoard[battleboardId][i].id;
379         }
380     }
381        return 0;
382     }
383     
384     
385     
386     function getPetbyTileId( uint16 battleboardId, uint8 tileId) constant public returns (uint64) {
387        return TilesonBoard[battleboardId][tileId].petId;
388     }
389     
390     function getOwner (uint16 battleboardId, uint8 team,  uint8 ownerNumber) constant external returns (address) {
391         
392        if (team == 0) {return Battleboards[battleboardId].players[ownerNumber];}
393        if (team == 1) {return Battleboards[battleboardId].team1[ownerNumber];}
394        if (team == 2) {return Battleboards[battleboardId].team2[ownerNumber];}
395        
396        
397     }
398     
399 
400     
401       function getTileIDbyPosition(uint16 battleboardId, uint8 position) public constant returns (uint8) {
402         return positionsTiles[battleboardId][position+1];
403     }
404     //If tile is empty, this returns 0
405      
406         // Call to get the specified tile at a certain position of a certain board. 
407    function getPositionFromBattleboard(uint16 battleboardId, uint8 _position) public constant returns (uint8 tileType, uint8 value, uint8 id, uint8 position, uint32 hp, uint32 petPower, uint64 angelId, uint64 petId, bool isLive)   {
408       
409         if ((battleboardId <0) ||  (battleboardId > totalBattleboards)) {revert();}
410     
411         Tile memory tile;
412         uint8 tileId = positionsTiles[battleboardId][_position+1];
413         tile = TilesonBoard[battleboardId][tileId];
414         tileType = tile.tileType; 
415         value = tile.value;
416         id= tile.id;
417         position = tile.position;
418         hp = tile.hp;
419         petPower = tile.petPower;
420         angelId = tile.angelId;
421         petId = tile.petId;
422         isLive = tile.isLive;
423         
424     } 
425      
426  
427     function getBattleboard(uint16 id) public constant returns (uint8 turn, bool isLive, uint prize, uint8 numTeams, uint8 numTiles, uint8 createdBarriers, uint8 restrictions, uint lastMoveTime, uint8 numTeams1, uint8 numTeams2, uint8 monster1, uint8 monster2) {
428             
429             Battleboard memory battleboard = Battleboards[id];
430     
431         turn = battleboard.turn;
432         isLive = battleboard.isLive;
433         prize = battleboard.prize;
434         numTeams = battleboard.numTeams;
435         numTiles = battleboard.numTiles;
436         createdBarriers = battleboard.createdBarriers;
437         restrictions = battleboard.restrictions;
438         lastMoveTime = battleboard.lastMoveTime;
439         numTeams1 = battleboard.numTeams1;
440         numTeams2 = battleboard.numTeams2;
441         monster1 = battleboard.monster1;
442         monster2 = battleboard.monster2;
443     }
444 
445     
446     
447 
448      
449      function isBattleboardLive(uint16 battleboardId) constant public returns (bool) {
450          return Battleboards[battleboardId].isLive;
451      }
452 
453 
454      function isTileLive(uint16 battleboardId, uint8 tileId) constant  external returns (bool) {
455      
456       return TilesonBoard[battleboardId][tileId].isLive;
457     }
458     
459     function getLastMoveTime(uint16 battleboardId) constant public returns (uint) {
460         return Battleboards[battleboardId].lastMoveTime;
461     }
462      
463   
464         function getNumTilesFromBoard (uint16 _battleboardId) constant public returns (uint8) {
465             return Battleboards[_battleboardId].numTiles;
466         }
467    
468         
469         //each angel can only be on ONE sponsored battleboard at a time. 
470         function angelOnBattleboards(uint64 angelID) external constant returns (bool) {
471            
472             return angelsOnBattleboards[angelID]; 
473         }
474    
475         
476         function getTurn(uint16 battleboardId) constant public returns (address) {
477             return Battleboards[battleboardId].players[Battleboards[battleboardId].turn];
478         }
479         
480       
481      
482      function getNumTeams(uint16 battleboardId, uint8 team) public constant returns (uint8) {
483          if (team == 1) {return Battleboards[battleboardId].numTeams1;}
484          if (team == 2) {return Battleboards[battleboardId].numTeams2;}
485      }
486         
487       
488     
489     function getMonsters(uint16 BattleboardId) external constant returns (uint8 monster1, uint8 monster2) {
490         
491         monster1 = Battleboards[BattleboardId].monster1;
492         monster2 = Battleboards[BattleboardId].monster2;
493    
494     }
495     
496     
497     function safeMult(uint x, uint y) pure internal returns(uint) {
498       uint z = x * y;
499       assert((x == 0)||(z/x == y));
500       return z;
501     }
502     
503      function SafeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
504     // assert(b > 0); // Solidity automatically throws when dividing by 0
505     uint256 c = a / b;
506     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
507     return c;
508     /// Read access
509      }
510    
511    
512     function getTotalBattleboards() public constant returns (uint16) {
513         return totalBattleboards;
514     }
515       
516   
517         
518    
519         
520         
521         
522    
523       
524         
525    
526 }