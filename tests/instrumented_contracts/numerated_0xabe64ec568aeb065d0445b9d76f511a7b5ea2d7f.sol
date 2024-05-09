1 pragma solidity ^0.4.17;
2 contract AccessControl {
3     address public creatorAddress;
4     uint16 public totalSeraphims = 0;
5     mapping (address => bool) public seraphims;
6 
7     bool public isMaintenanceMode = true;
8  
9     modifier onlyCREATOR() {
10         require(msg.sender == creatorAddress);
11         _;
12     }
13 
14     modifier onlySERAPHIM() {
15         require(seraphims[msg.sender] == true);
16         _;
17     }
18     
19     modifier isContractActive {
20         require(!isMaintenanceMode);
21         _;
22     }
23     
24     // Constructor
25     function AccessControl() public {
26         creatorAddress = msg.sender;
27     }
28     
29 
30     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
31         if (seraphims[_newSeraphim] == false) {
32             seraphims[_newSeraphim] = true;
33             totalSeraphims += 1;
34         }
35     }
36     
37     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
38         if (seraphims[_oldSeraphim] == true) {
39             seraphims[_oldSeraphim] = false;
40             totalSeraphims -= 1;
41         }
42     }
43 
44     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
45         isMaintenanceMode = _isMaintaining;
46     }
47 
48   
49 } 
50 contract SafeMath {
51     function safeAdd(uint x, uint y) pure internal returns(uint) {
52       uint z = x + y;
53       assert((z >= x) && (z >= y));
54       return z;
55     }
56 
57     function safeSubtract(uint x, uint y) pure internal returns(uint) {
58       assert(x >= y);
59       uint z = x - y;
60       return z;
61     }
62 
63     function safeMult(uint x, uint y) pure internal returns(uint) {
64       uint z = x * y;
65       assert((x == 0)||(z/x == y));
66       return z;
67     }
68     
69      
70 
71     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
72         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
73         return uint8(genNum % (maxRandom - min + 1)+min);
74     }
75 }
76 
77 contract Enums {
78     enum ResultCode {
79         SUCCESS,
80         ERROR_CLASS_NOT_FOUND,
81         ERROR_LOW_BALANCE,
82         ERROR_SEND_FAIL,
83         ERROR_NOT_OWNER,
84         ERROR_NOT_ENOUGH_MONEY,
85         ERROR_INVALID_AMOUNT
86     }
87 
88     enum AngelAura { 
89         Blue, 
90         Yellow, 
91         Purple, 
92         Orange, 
93         Red, 
94         Green 
95     }
96 }
97 
98 
99 contract ISponsoredLeaderboardData is AccessControl {
100 
101   
102     uint16 public totalLeaderboards;
103     
104     //The reserved balance is the total balance outstanding on all open leaderboards. 
105     //We keep track of this figure to prevent the developers from pulling out money currently pledged
106     uint public contractReservedBalance;
107     
108 
109     function setMinMaxDays(uint8 _minDays, uint8 _maxDays) external ;
110         function openLeaderboard(uint8 numDays, string message) external payable ;
111         function closeLeaderboard(uint16 leaderboardId) onlySERAPHIM external;
112         
113         function setMedalsClaimed(uint16 leaderboardId) onlySERAPHIM external ;
114     function withdrawEther() onlyCREATOR external;
115   function getTeamFromLeaderboard(uint16 leaderboardId, uint8 rank) public constant returns (uint64 angelId, uint64 petId, uint64 accessoryId) ;
116     
117     function getLeaderboard(uint16 id) public constant returns (uint startTime, uint endTime, bool isLive, address sponsor, uint prize, uint8 numTeams, string message, bool medalsClaimed);
118       function newTeamOnEnd(uint16 leaderboardId, uint64 angelId, uint64 petId, uint64 accessoryId) onlySERAPHIM external;
119        function switchRankings (uint16 leaderboardId, uint8 spot,uint64 angel1ID, uint64 pet1ID, uint64 accessory1ID,uint64 angel2ID,uint64 pet2ID,uint64 accessory2ID) onlySERAPHIM external;
120        function verifyPosition(uint16 leaderboardId, uint8 spot, uint64 angelID) external constant returns (bool); 
121         function angelOnLeaderboards(uint64 angelID) external constant returns (bool);
122          function petOnLeaderboards(uint64 petID) external constant returns (bool);
123          function accessoryOnLeaderboards(uint64 accessoryID) external constant returns (bool) ;
124     function safeMult(uint x, uint y) pure internal returns(uint) ;
125      function SafeDiv(uint256 a, uint256 b) internal pure returns (uint256) ;
126     function getTotalLeaderboards() public constant returns (uint16);
127       
128   
129         
130    
131         
132         
133         
134    
135       
136         
137    
138 }
139 contract IAngelCardData is AccessControl, Enums {
140     uint8 public totalAngelCardSeries;
141     uint64 public totalAngels;
142 
143     
144     // write
145     // angels
146     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
147     function updateAngelCardSeries(uint8 _angelCardSeriesId, uint64 _newPrice, uint64 _newMaxTotal) onlyCREATOR external;
148     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
149     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
150     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
151     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
152     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
153     function addAngelIdMapping(address _owner, uint64 _angelId) private;
154     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
155     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
156     function updateAngelLock (uint64 _angelId, bool newValue) public;
157     function removeCreator() onlyCREATOR external;
158 
159     // read
160     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
161     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
162     function getOwnerAngelCount(address _owner) constant public returns(uint);
163     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
164     function getTotalAngelCardSeries() constant public returns (uint8);
165     function getTotalAngels() constant public returns (uint64);
166     function getAngelLockStatus(uint64 _angelId) constant public returns (bool);
167 }
168 
169 //Note - due to not yet implemented features we could not store teams in an array. 
170 
171 contract SponsoredLeaderboardData is ISponsoredLeaderboardData {
172 
173     /*** DATA TYPES ***/
174         address public angelCardDataContract = 0x6D2E76213615925c5fc436565B5ee788Ee0E86DC;
175     
176       struct Team {
177         uint64 angelId;
178         uint64 petId;
179         uint64 accessoryId;
180     }
181     
182       struct Leaderboard {
183         uint startTime;
184         uint endTime;
185         Team rank0;
186         Team rank1;
187         Team rank2;
188         Team rank3;
189         bool isLive;
190         address sponsor;
191         uint prize;
192         uint16 id;
193         uint8 numTeams;
194         string message;
195         bool medalsClaimed;
196         
197     }
198 
199     //main storage
200     Leaderboard []  Leaderboards;
201     
202     uint16 public totalLeaderboards;
203     
204     uint16 minDays= 4;
205     uint16 maxDays = 10;
206     
207     //The reserved balance is the total balance outstanding on all open leaderboards. 
208     //We keep track of this figure to prevent the developers from pulling out money currently pledged
209     uint public contractReservedBalance;
210     
211     
212     mapping (uint64 => bool) angelsOnLeaderboards;
213     mapping (uint64 => bool) petsOnLeaderboards;
214     mapping (uint64 => bool) accessoriesOnLeaderboards;
215     
216     
217     
218       // write functions
219     function setMinMaxDays(uint8 _minDays, uint8 _maxDays) external {
220         minDays = _minDays;
221         maxDays = _maxDays;
222        }
223 
224   
225         function openLeaderboard(uint8 numDays, string message) external payable {
226             // This function is called by the sponsor to create the Leaderboard by sending money. 
227             
228            if (msg.value < 10000000000000000) {revert();}
229          
230          if ((numDays < minDays) || (numDays > maxDays)) {revert();}
231             Leaderboard memory leaderboard;
232             leaderboard.startTime = now;
233             leaderboard.endTime = (now + (numDays * 86400));
234             leaderboard.isLive = true;
235             leaderboard.sponsor = msg.sender;
236             leaderboard.prize = msg.value;
237             leaderboard.message = message;
238             leaderboard.id = totalLeaderboards;
239             
240             leaderboard.medalsClaimed= false;
241             leaderboard.numTeams = 4;
242     
243            Leaderboards.push(leaderboard);
244            
245             Team memory team;
246             team.angelId = 1;
247             team.petId = 1;
248             team.accessoryId = 0;
249             Leaderboards[totalLeaderboards].rank1 = team;
250             Leaderboards[totalLeaderboards].rank2 = team;
251             Leaderboards[totalLeaderboards].rank3 = team;
252             Leaderboards[totalLeaderboards].rank0 = team;
253             totalLeaderboards +=1;
254             contractReservedBalance += msg.value;
255            
256             
257         }
258         
259         function closeLeaderboard(uint16 leaderboardId) onlySERAPHIM external {
260            //will be called by the SponsoredLeaderboards contract with a certain chance after the minimum battle time. 
261            
262             Leaderboard memory leaderboard;
263             leaderboard = Leaderboards[leaderboardId];
264             if (now < leaderboard.endTime) {revert();}
265             if (leaderboard.isLive = false) {revert();}
266             Leaderboards[leaderboardId].isLive = false;
267              IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
268              
269              address owner1;
270              address owner2;
271              address owner3;
272              address owner4;
273              
274             (,,,,,,,,,,owner1) = angelCardData.getAngel(Leaderboards[leaderboardId].rank0.angelId);
275             (,,,,,,,,,,owner2) = angelCardData.getAngel(Leaderboards[leaderboardId].rank1.angelId);
276             (,,,,,,,,,,owner3) = angelCardData.getAngel(Leaderboards[leaderboardId].rank2.angelId);
277             (,,,,,,,,,,owner4) = angelCardData.getAngel(Leaderboards[leaderboardId].rank3.angelId);
278             uint prize = Leaderboards[leaderboardId].prize;
279             
280             owner1.transfer(SafeDiv(safeMult(prize,45), 100));
281             owner2.transfer(SafeDiv(safeMult(prize,25), 100));
282             owner3.transfer(SafeDiv(safeMult(prize,15), 100));
283             owner4.transfer(SafeDiv(safeMult(prize,5), 100));
284     
285             //Free up cards to be on other Leaderboards
286             
287         angelsOnLeaderboards[Leaderboards[leaderboardId].rank0.angelId] = false;
288         petsOnLeaderboards[Leaderboards[leaderboardId].rank0.petId] = false;
289         accessoriesOnLeaderboards[Leaderboards[leaderboardId].rank0.accessoryId] = false;
290          
291              
292         angelsOnLeaderboards[Leaderboards[leaderboardId].rank1.angelId] = false;
293         petsOnLeaderboards[Leaderboards[leaderboardId].rank1.petId] = false;
294         accessoriesOnLeaderboards[Leaderboards[leaderboardId].rank1.accessoryId] = false;
295         
296             
297         angelsOnLeaderboards[Leaderboards[leaderboardId].rank2.angelId] = false;
298         petsOnLeaderboards[Leaderboards[leaderboardId].rank2.petId] = false;
299         accessoriesOnLeaderboards[Leaderboards[leaderboardId].rank2.accessoryId] = false;
300         
301             
302         angelsOnLeaderboards[Leaderboards[leaderboardId].rank3.angelId] = false;
303         petsOnLeaderboards[Leaderboards[leaderboardId].rank3.petId] = false;
304         accessoriesOnLeaderboards[Leaderboards[leaderboardId].rank3.accessoryId] = false;
305             
306             
307             
308             contractReservedBalance= contractReservedBalance -  SafeDiv(safeMult(prize,90), 100);
309         }
310   
311         
312         function setMedalsClaimed(uint16 leaderboardId) onlySERAPHIM external {
313             Leaderboards[leaderboardId].medalsClaimed = true;
314         }
315         
316 function withdrawEther() external onlyCREATOR {
317     //make sure we can't transfer out balance for leaderboards that aren't open. 
318     creatorAddress.transfer(this.balance-contractReservedBalance);
319 }
320 
321     // Call to get the specified team at a certain position of a certain board. 
322    function getTeamFromLeaderboard(uint16 leaderboardId, uint8 rank) public constant returns (uint64 angelId, uint64 petId, uint64 accessoryId)   {
323       
324         if ((leaderboardId <0) || (rank <0) || (rank >3) || (leaderboardId > totalLeaderboards)) {revert();}
325         if (rank == 0) {
326        angelId = Leaderboards[leaderboardId].rank0.angelId;
327        petId = Leaderboards[leaderboardId].rank0.petId;
328        accessoryId = Leaderboards[leaderboardId].rank0.accessoryId;
329        return;
330         }
331          if (rank == 1) {
332        angelId = Leaderboards[leaderboardId].rank1.angelId;
333        petId = Leaderboards[leaderboardId].rank1.petId;
334        accessoryId = Leaderboards[leaderboardId].rank1.accessoryId;
335        return;
336         }
337           if (rank == 2) {
338        angelId = Leaderboards[leaderboardId].rank2.angelId;
339        petId = Leaderboards[leaderboardId].rank2.petId;
340        accessoryId = Leaderboards[leaderboardId].rank2.accessoryId;
341        return;
342         }
343           if (rank == 3) {
344        angelId = Leaderboards[leaderboardId].rank3.angelId;
345        petId = Leaderboards[leaderboardId].rank3.petId;
346        accessoryId = Leaderboards[leaderboardId].rank3.accessoryId;
347        return;
348         }
349     
350 
351    }
352     function getLeaderboard(uint16 id) public constant returns (uint startTime, uint endTime, bool isLive, address sponsor, uint prize, uint8 numTeams, string message, bool medalsClaimed) {
353             Leaderboard memory leaderboard;
354             leaderboard = Leaderboards[id];
355             startTime = leaderboard.startTime;
356             endTime = leaderboard.endTime;
357             isLive = leaderboard.isLive;
358             sponsor = leaderboard.sponsor;
359             prize = leaderboard.prize;
360             numTeams = leaderboard.numTeams;
361             message = leaderboard.message;
362             medalsClaimed = leaderboard.medalsClaimed;
363     }
364     
365      
366 
367 
368         function newTeamOnEnd(uint16 leaderboardId, uint64 angelId, uint64 petId, uint64 accessoryId)  onlySERAPHIM external  {
369          //to be used when a team successfully challenges the last spot and knocks the prvious team out.   
370          
371                 Team memory team;
372                //remove old team from mappings
373                 team = Leaderboards[leaderboardId].rank3;
374                 angelsOnLeaderboards[Leaderboards[leaderboardId].rank3.angelId] = false;
375                petsOnLeaderboards[Leaderboards[leaderboardId].rank3.petId] = false;
376                accessoriesOnLeaderboards[Leaderboards[leaderboardId].rank3.accessoryId] = false;
377                 
378                 //Add new team to end
379               Leaderboards[leaderboardId].rank3.angelId = angelId;
380               Leaderboards[leaderboardId].rank3.petId = petId;
381               Leaderboards[leaderboardId].rank3.accessoryId = accessoryId;
382               
383               angelsOnLeaderboards[angelId] = true;
384                petsOnLeaderboards[petId] = true;
385                accessoriesOnLeaderboards[accessoryId] = true;
386            
387             
388             
389         }
390         function switchRankings (uint16 leaderboardId, uint8 spot,uint64 angel1ID, uint64 pet1ID, uint64 accessory1ID,uint64 angel2ID,uint64 pet2ID,uint64 accessory2ID ) onlySERAPHIM external {
391         //put team 1 from spot to spot+1 and put team 2 to spot. 
392     
393                 Team memory team;
394                 team.angelId = angel1ID;
395                 team.petId = pet1ID;
396                 team.accessoryId = accessory1ID;
397                 if (spot == 0) {Leaderboards[leaderboardId].rank1 = team;}
398                 if (spot == 1) {Leaderboards[leaderboardId].rank2 = team;}
399                 if (spot == 2) {Leaderboards[leaderboardId].rank3 = team;}
400                 
401                 team.angelId = angel2ID;
402                 team.petId = pet2ID;
403                 team.accessoryId = accessory2ID;
404             
405                 if (spot == 0) {Leaderboards[leaderboardId].rank0 = team;}
406                 if (spot == 1) {Leaderboards[leaderboardId].rank1 = team;}
407                 if (spot == 2) {Leaderboards[leaderboardId].rank2 = team;}
408         
409         }
410         
411         
412         function verifyPosition(uint16 leaderboardId, uint8 spot, uint64 angelID) external constant returns (bool) {
413           
414                if (spot == 0) {
415                    if (Leaderboards[leaderboardId].rank0.angelId == angelID) {return true;}
416                }
417                if (spot == 1) {
418                    if (Leaderboards[leaderboardId].rank1.angelId == angelID) {return true;}
419                }
420                if (spot == 2) {
421                    if (Leaderboards[leaderboardId].rank2.angelId == angelID) {return true;}
422                }
423                  if (spot == 3) {
424                    if (Leaderboards[leaderboardId].rank3.angelId == angelID) {return true;}
425                }
426                
427                
428                 return false;
429                 
430         }
431         
432         //each angel can only be on ONE sponsored leaderboard at a time. 
433         function angelOnLeaderboards(uint64 angelID) external constant returns (bool) {
434            
435             return angelsOnLeaderboards[angelID]; 
436         }
437         
438         //each pet can only be on ONE sponsored leaderboard at a time. 
439          function petOnLeaderboards(uint64 petID) external constant returns (bool) {
440            
441             return petsOnLeaderboards[petID]; 
442         }
443         
444         //Each Accessory can only be on one sponsored leaderboard
445          function accessoryOnLeaderboards(uint64 accessoryID) external constant returns (bool) {
446            
447             return accessoriesOnLeaderboards[accessoryID]; 
448         }
449         
450        
451     
452     function safeMult(uint x, uint y) pure internal returns(uint) {
453       uint z = x * y;
454       assert((x == 0)||(z/x == y));
455       return z;
456     }
457     
458      function SafeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
459     // assert(b > 0); // Solidity automatically throws when dividing by 0
460     uint256 c = a / b;
461     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
462     return c;
463     /// Read access
464      }
465    
466    
467     function getTotalLeaderboards() public constant returns (uint16) {
468         return totalLeaderboards;
469     }
470       
471   
472         
473    
474         
475         
476         
477    
478       
479         
480    
481 }