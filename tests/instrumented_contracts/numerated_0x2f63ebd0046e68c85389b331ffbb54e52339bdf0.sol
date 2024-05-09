1 pragma solidity ^0.4.21;
2 
3 
4 /// @title A base contract to control ownership
5 /// @author cuilichen
6 contract OwnerBase {
7 
8     // The addresses of the accounts that can execute actions within each roles.
9     address public ceoAddress;
10     address public cfoAddress;
11     address public cooAddress;
12 
13     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
14     bool public paused = false;
15     
16     /// constructor
17     function OwnerBase() public {
18        ceoAddress = msg.sender;
19        cfoAddress = msg.sender;
20        cooAddress = msg.sender;
21     }
22 
23     /// @dev Access modifier for CEO-only functionality
24     modifier onlyCEO() {
25         require(msg.sender == ceoAddress);
26         _;
27     }
28 
29     /// @dev Access modifier for CFO-only functionality
30     modifier onlyCFO() {
31         require(msg.sender == cfoAddress);
32         _;
33     }
34     
35     /// @dev Access modifier for COO-only functionality
36     modifier onlyCOO() {
37         require(msg.sender == cooAddress);
38         _;
39     }
40 
41     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
42     /// @param _newCEO The address of the new CEO
43     function setCEO(address _newCEO) external onlyCEO {
44         require(_newCEO != address(0));
45 
46         ceoAddress = _newCEO;
47     }
48 
49 
50     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
51     /// @param _newCFO The address of the new COO
52     function setCFO(address _newCFO) external onlyCEO {
53         require(_newCFO != address(0));
54 
55         cfoAddress = _newCFO;
56     }
57     
58     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
59     /// @param _newCOO The address of the new COO
60     function setCOO(address _newCOO) external onlyCEO {
61         require(_newCOO != address(0));
62 
63         cooAddress = _newCOO;
64     }
65 
66     /// @dev Modifier to allow actions only when the contract IS NOT paused
67     modifier whenNotPaused() {
68         require(!paused);
69         _;
70     }
71 
72     /// @dev Modifier to allow actions only when the contract IS paused
73     modifier whenPaused {
74         require(paused);
75         _;
76     }
77 
78     /// @dev Called by any "C-level" role to pause the contract. Used only when
79     ///  a bug or exploit is detected and we need to limit damage.
80     function pause() external onlyCOO whenNotPaused {
81         paused = true;
82     }
83 
84     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
85     ///  one reason we may pause the contract is when CFO or COO accounts are
86     ///  compromised.
87     /// @notice This is public rather than external so it can be called by
88     ///  derived contracts.
89     function unpause() public onlyCOO whenPaused {
90         // can't unpause if contract was upgraded
91         paused = false;
92     }
93     
94     
95     /// @dev check wether target address is a contract or not
96     function isNormalUser(address addr) internal view returns (bool) {
97         if (addr == address(0)) {
98             return false;
99         }
100         uint size = 0;
101         assembly { 
102             size := extcodesize(addr) 
103         } 
104         return size == 0;
105     }
106 }
107 
108 
109 
110 /// @title Base contract for Chaotic. Holds all common structs, events and base variables.
111 /// @author cuilichen
112 contract BaseFight is OwnerBase {
113 
114     event FighterReady(uint32 season);
115     
116     // data of fighter
117     struct Fighter {
118         uint tokenID;
119         address hometown;
120         address owner;
121         uint16 power;
122     }
123     
124     
125     mapping (uint => Fighter) public soldiers; // key is (season * 1000 + index)
126     
127     // time for matches
128     mapping (uint32 => uint64 ) public matchTime;// key is season
129     
130     
131     mapping (uint32 => uint64 ) public seedFromCOO; // key is season
132     
133     
134     mapping (uint32 => uint8 ) public finished; // key is season
135     
136     //
137     uint32[] seasonIDs;
138     
139     
140     
141     /// @dev get base infomation of the seasons
142     function getSeasonInfo(uint32[99] _seasons) view public returns (uint length,uint[99] matchTimes, uint[99] results) {
143         for (uint i = 0; i < _seasons.length; i++) {    
144             uint32 _season = _seasons[i];
145             if(_season >0){
146                 matchTimes[i] = matchTime[_season];
147                 results[i] = finished[_season];
148             }else{
149                 length = i;
150                 break;
151             }
152         }
153     }
154     
155     
156     
157     
158     /// @dev check seed form coo
159     function checkCooSeed(uint32 _season) public view returns (uint64) {
160         require(finished[_season] > 0);
161         return seedFromCOO[_season];
162     }
163 
164     
165     /// @dev set a fighter for a season, prepare for combat.
166     function createSeason(uint32 _season, uint64 fightTime, uint64 _seedFromCOO, address[8] _home, uint[8] _tokenID, uint16[8] _power, address[8] _owner) external onlyCOO {
167         require(matchTime[_season] <= 0);
168         require(fightTime > 0);
169         require(_seedFromCOO > 0);
170         seasonIDs.push(_season);// a new season
171         matchTime[_season] = fightTime;
172         seedFromCOO[_season] = _seedFromCOO;
173         
174         for (uint i = 0; i < 8; i++) {        
175             Fighter memory soldier = Fighter({
176                 hometown:_home[i],
177                 owner:_owner[i],
178                 tokenID:_tokenID[i],
179                 power: _power[i]
180             });
181                 
182             uint key = _season * 1000 + i;
183             soldiers[key] = soldier;
184             
185         }
186         
187         //fire the event
188         emit FighterReady(_season);
189     }
190     
191     
192     
193     /// @dev process a fight
194     function _localFight(uint32 _season, uint32 _seed) internal returns (uint8 winner)
195     {
196         require(finished[_season] == 0);//make sure a season just match once.
197         
198         uint[] memory powers = new uint[](8);
199         
200         uint sumPower = 0;
201         uint8 i = 0;
202         uint key = 0;
203         Fighter storage soldier = soldiers[0];
204         for (i = 0; i < 8; i++) {
205             key = _season * 1000 + i;
206             soldier = soldiers[key];
207             powers[i] = soldier.power;
208             sumPower = sumPower + soldier.power;
209         }
210         
211         uint sumValue = 0;
212         uint tmpPower = 0;
213         for (i = 0; i < 8; i++) {
214             tmpPower = powers[i] ** 5;//
215             sumValue += tmpPower;
216             powers[i] = sumValue;
217         }
218         uint singleDeno = sumPower ** 5;
219         uint randomVal = _getRandom(_seed);
220         
221         winner = 0;
222         uint shoot = sumValue * randomVal * 10000000000 / singleDeno / 0xffffffff;
223         for (i = 0; i < 8; i++) {
224             tmpPower = powers[i];
225             if (shoot <= tmpPower * 10000000000 / singleDeno) {
226                 winner = i;
227                 break;
228             }
229         }
230         
231         finished[_season] = uint8(100 + winner);
232         return winner;
233     }
234     
235     
236     /// @dev give a seed and get a random value between 0 and 0xffffffff.
237     /// @param _seed an uint32 value from users
238     function _getRandom(uint32 _seed) pure internal returns(uint32) {
239         return uint32(keccak256(_seed));
240     }
241 }
242 
243 
244 
245 /**
246  * Math operations with safety checks
247  */
248 contract SafeMath {
249     function safeMul(uint a, uint b) internal pure returns (uint) {
250         uint c = a * b;
251         assert(a == 0 || c / a == b);
252         return c;
253     }
254 
255     function safeDiv(uint a, uint b) internal pure returns (uint) {
256         assert(b > 0);
257         uint c = a / b;
258         assert(a == b * c + a % b);
259         return c;
260     }
261 
262     function safeSub(uint a, uint b) internal pure returns (uint) {
263         assert(b <= a);
264         return a - b;
265     }
266 
267     function safeAdd(uint a, uint b) internal pure returns (uint) {
268         uint c = a + b;
269         assert(c>=a && c>=b);
270         return c;
271     }
272 
273     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
274         return a >= b ? a : b;
275     }
276 
277     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
278         return a < b ? a : b;
279     }
280 
281     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a >= b ? a : b;
283     }
284 
285     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a < b ? a : b;
287     }
288  
289 }
290 
291 
292  
293 
294 /**
295  * 
296  * @title Interface of contract for partner
297  * @author cuilichen
298  */
299 contract PartnerHolder {
300     //
301     function isHolder() public pure returns (bool);
302     
303     // Required methods
304     function bonusAll() payable public ;
305     
306     
307     function bonusOne(uint id) payable public ;
308     
309 }
310 
311 
312 
313 contract BetOnMatch is BaseFight, SafeMath {
314 
315     event Betted( uint32 indexed season, uint32 indexed index, address indexed account, uint amount);
316     event SeasonNone( uint32 season);
317     event SeasonWinner( uint32 indexed season, uint winnerID);
318     event LogFighter( uint32 indexed season, address indexed fighterOwner, uint fighterKey, uint fund, address fighterContract, uint fighterTokenID, uint power, uint8 isWin,uint reward, uint64 fightTime);
319     event LogMatch( uint32 indexed season, uint sumFund, uint64 fightTime, uint sumSeed, uint fighterKey, address fighterContract, uint fighterTokenID ,bool isRefound);
320     event LogBet( uint32 indexed season, address indexed sender, uint fund, uint seed, uint fighterKey, address fighterContract, uint fighterTokenID );
321     
322     struct Betting {
323         // user 
324         address account;
325         
326         uint32 season;
327         
328         uint32 index;
329         
330         address invitor;
331         
332         uint seed;
333         //
334         uint amount;
335     }
336     
337     // contract of partners
338     PartnerHolder public partners;
339     
340     // all betting data
341     mapping (uint => Betting[]) public allBittings; // key is season * 1000 + index
342     
343     // bet on the fighter,
344     mapping (uint => uint) public betOnFighter; // key is season * 1000 + index
345     
346     // address to balance.
347     mapping( address => uint) public balances;
348     
349     
350     /// @dev constructor of contract, set partners
351     function BetOnMatch(address _partners) public {
352         ceoAddress = msg.sender;
353         cooAddress = msg.sender;
354         cfoAddress = msg.sender;
355         
356         partners = PartnerHolder(_partners);
357     }
358         
359     
360     
361     /// @dev bet to the match
362     function betOn(
363         uint32 _season, 
364         uint32 _index, 
365         uint _seed, 
366         address _invitor) 
367     payable external returns (bool){
368         require(isNormalUser(msg.sender));
369         require(matchTime[_season] > 0);
370         require(now < matchTime[_season] - 300); // 5 minites before match.
371         require(msg.value >= 1 finney && msg.value < 99999 ether );
372         
373         
374         Betting memory tmp = Betting({
375             account:msg.sender,
376             season:_season,
377             index:_index,
378             seed:_seed,
379             invitor:_invitor,
380             amount:msg.value
381         });
382         
383         
384         uint key = _season * 1000 + _index;
385         betOnFighter[key] = safeAdd(betOnFighter[key], msg.value);
386         Betting[] storage items = allBittings[key];
387         items.push(tmp);
388         
389         Fighter storage soldier = soldiers[key];
390         
391         emit Betted( _season, _index, msg.sender, msg.value);
392         emit LogBet( _season, msg.sender, msg.value, _seed, key, soldier.hometown, soldier.tokenID );
393     }
394     
395     
396     /// @dev set a fighter for a season, prepare for combat.
397     function getFighters( uint32 _season) public view returns (address[8] outHome, uint[8] outTokenID, uint[8] power,  address[8] owner, uint[8] funds) {
398         for (uint i = 0; i < 8; i++) {  
399             uint key = _season * 1000 + i;
400             funds[i] = betOnFighter[key];
401             
402             Fighter storage soldier = soldiers[key];
403             outHome[i] = soldier.hometown;
404             outTokenID[i] = soldier.tokenID;
405             power[i] = soldier.power;
406             owner[i] = soldier.owner;
407         }
408     }
409     
410     
411     
412     /// @notice process a combat, it is expencive, so provide enough gas
413     function processSeason(uint32 _season) public onlyCOO
414     {
415         uint64 fightTime = matchTime[_season];
416         require(now >= fightTime && fightTime > 0);
417         
418         uint sumFund = 0;
419         uint sumSeed = 0;
420         (sumFund, sumSeed) = _getFightData(_season);
421         if (sumFund == 0) {
422             finished[_season] = 110;
423             doLogFighter(_season,0,0);
424             emit SeasonNone(_season);
425             emit LogMatch( _season, sumFund, fightTime, sumSeed, 0, 0, 0, false );
426         } else {
427             uint8 champion = _localFight(_season, uint32(sumSeed));
428         
429             uint percentile = safeDiv(sumFund, 100);
430             uint devCut = percentile * 4; // for developer
431             uint partnerCut = percentile * 5; // for partners
432             uint fighterCut = percentile * 1; // for fighters
433             uint bonusWinner = percentile * 80; // for winner
434             // for salesman percentile * 10
435             
436             _bonusToPartners(partnerCut);
437             _bonusToFighters(_season, champion, fighterCut);
438             bool isRefound = _bonusToBettor(_season, champion, bonusWinner);
439             _addMoney(cfoAddress, devCut);
440             
441             uint key = _season * 1000 + champion;
442             Fighter storage soldier = soldiers[key];
443             doLogFighter(_season,key,fighterCut);
444             emit SeasonWinner(_season, champion);        
445             emit LogMatch( _season, sumFund, fightTime, sumSeed, key, soldier.hometown, soldier.tokenID, isRefound );
446         }
447         clearTheSeason(_season);
448     }
449     
450     
451     
452     function clearTheSeason( uint32 _season) internal {
453         for (uint i = 0; i < 8; i++){
454             uint key = _season * 1000 + i;
455             delete soldiers[key];
456             delete allBittings[key];
457         }
458     }
459     
460     
461     
462     /// @dev write log about 8 fighters
463     function doLogFighter( uint32 _season, uint _winnerKey, uint fighterReward) internal {
464         for (uint i = 0; i < 8; i++){
465             uint key = _season * 1000 + i;
466             uint8 isWin = 0;
467             uint64 fightTime = matchTime[_season];
468             uint winMoney = safeDiv(fighterReward, 10);
469             if(key == _winnerKey){
470                 isWin = 1;
471                 winMoney = safeMul(winMoney, 3);
472             }
473             Fighter storage soldier = soldiers[key];
474             emit LogFighter( _season, soldier.owner, key, betOnFighter[key], soldier.hometown, soldier.tokenID, soldier.power, isWin,winMoney,fightTime);
475         }
476     }
477     
478     
479     
480     /// @dev caculate fund and seed value
481     function _getFightData(uint32 _season) internal returns (uint outFund, uint outSeed){
482         outSeed = seedFromCOO[_season];
483         for (uint i = 0; i < 8; i++){
484             uint key = _season * 1000 + i;
485             uint fund = 0;
486             Betting[] storage items = allBittings[key]; 
487             for (uint j = 0; j < items.length; j++) {
488                 Betting storage item = items[j];
489                 outSeed += item.seed;
490                 fund += item.amount;
491                 
492                 uint forSaler = safeDiv(item.amount, 10); // 0.1 for salesman
493                 if (item.invitor == address(0)){
494                     _addMoney(cfoAddress, forSaler);
495                 } else {
496                     _addMoney(item.invitor, forSaler);
497                 }
498             }
499             outFund += fund;
500         }
501     }
502     
503     /// @dev add fund to the address.
504     function _addMoney( address user, uint val) internal {
505         uint oldValue = balances[user];
506         balances[user] = safeAdd(oldValue, val);
507     }
508     
509     
510     
511     
512     /// @dev bonus to partners.
513     function _bonusToPartners(uint _amount) internal {
514         if (partners == address(0)) {
515             _addMoney(cfoAddress, _amount);
516         } else {
517             partners.bonusAll.value(_amount)();
518         }
519     }
520     
521     
522     /// @dev bonus to the fighters in the season.
523     function _bonusToFighters(uint32 _season, uint8 _winner, uint _reward) internal {
524         for (uint i = 0; i < 8; i++) {
525             uint key = _season * 1000 + i;
526             Fighter storage item = soldiers[key];
527             address owner = item.owner;
528             uint fund = safeDiv(_reward, 10);
529             if (i == _winner) {
530                 fund = safeMul(fund, 3);
531             }
532             if (owner == address(0)) {
533                 _addMoney(cfoAddress, fund);
534             } else {
535                 _addMoney(owner, fund);
536             }
537         }
538     }
539     
540     
541     /// @dev bonus to bettors who won.
542     function _bonusToBettor(uint32 _season, uint8 _winner, uint bonusWinner) internal returns (bool) {
543         uint winnerBet = _getWinnerBetted(_season, _winner);
544         uint key = _season * 1000 + _winner;
545         Betting[] storage items = allBittings[key];
546         if (items.length == 0) {
547             backToAll(_season);
548             return true;
549         } else {
550             for (uint j = 0; j < items.length; j++) {
551                 Betting storage item = items[j];
552                 address account = item.account;
553                 uint newFund = safeDiv(safeMul(bonusWinner, item.amount), winnerBet); 
554                 _addMoney(account, newFund);
555             }
556             return false;
557         }
558     }
559     
560     /// @dev nobody win, return fund back to all bettors.
561     function backToAll(uint32 _season) internal {
562         for (uint i = 0; i < 8; i++) {
563             uint key = _season * 1000 + i;
564             Betting[] storage items = allBittings[key];
565             for (uint j = 0; j < items.length; j++) {
566                 Betting storage item = items[j];
567                 address account = item.account;
568                 uint backVal = safeDiv(safeMul(item.amount, 8), 10); // amount * 0.8
569                 _addMoney(account, backVal);
570             }
571         }
572     }
573     
574     
575     
576     /// @dev caculate total amount betted on winner
577     function _getWinnerBetted(uint32 _season, uint32 _winner) internal view returns (uint){
578         uint sum = 0;
579         uint key = _season * 1000 + _winner;
580         Betting[] storage items = allBittings[key];
581         for (uint j = 0; j < items.length; j++) {
582             Betting storage item = items[j];
583             sum += item.amount;
584         }
585         return sum;
586     }
587     
588     
589     
590     /// @dev partner withdraw, 
591     function userWithdraw() public {
592         uint fund = balances[msg.sender];
593         require (fund > 0);
594         delete balances[msg.sender];
595         msg.sender.transfer(fund);
596     }
597     
598     
599     /// @dev cfo withdraw dead ether. 
600     function withdrawDeadFund( address addr) external onlyCFO {
601         uint fund = balances[addr];
602         require (fund > 0);
603         delete balances[addr];
604         cfoAddress.transfer(fund);
605     }
606 
607 }