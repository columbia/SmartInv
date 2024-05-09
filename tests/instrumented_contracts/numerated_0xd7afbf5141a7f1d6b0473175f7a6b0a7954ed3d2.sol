1 pragma solidity ^0.4.25;
2 
3 /*
4 * CryptoMiningWar - Blockchain-based strategy game
5 * Author: InspiGames
6 * Website: https://cryptominingwar.github.io/
7 */
8 
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function min(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a < b ? a : b;
52     }
53 }
54 contract PullPayment {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) public payments;
58   uint256 public totalPayments;
59 
60   /**
61   * @dev Withdraw accumulated balance, called by payee.
62   */
63   function withdrawPayments() public {
64     address payee = msg.sender;
65     uint256 payment = payments[payee];
66 
67     require(payment != 0);
68     require(address(this).balance >= payment);
69 
70     totalPayments = totalPayments.sub(payment);
71     payments[payee] = 0;
72 
73     payee.transfer(payment);
74   }
75 
76   /**
77   * @dev Called by the payer to store the sent amount as credit to be pulled.
78   * @param dest The destination address of the funds.
79   * @param amount The amount to transfer.
80   */
81   function asyncSend(address dest, uint256 amount) internal {
82     payments[dest] = payments[dest].add(amount);
83     totalPayments = totalPayments.add(amount);
84   }
85 }
86 interface CryptoMiningWarInterface {
87     function calCurrentCrystals(address /*_addr*/) external view returns(uint256 /*_currentCrystals*/);
88     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure;
89     function fallback() external payable;
90     function isMiningWarContract() external pure returns(bool);
91 }
92 interface MiniGameInterface {
93     function isContractMiniGame() external pure returns( bool _isContractMiniGame );
94     function fallback() external payable;
95 }
96 contract CryptoEngineer is PullPayment{
97     // engineer info
98 	address public administrator;
99     uint256 public prizePool = 0;
100     uint256 public numberOfEngineer = 8;
101     uint256 public numberOfBoosts = 5;
102     address public gameSponsor;
103     uint256 public gameSponsorPrice = 0.32 ether;
104     uint256 public VIRUS_MINING_PERIOD = 86400; 
105     
106     // mining war game infomation
107     uint256 public CRTSTAL_MINING_PERIOD = 86400;
108     uint256 public BASE_PRICE = 0.01 ether;
109 
110     address public miningWarAddress; 
111     CryptoMiningWarInterface   public MiningWar;
112     
113     // engineer player information
114     mapping(address => Player) public players;
115     // engineer boost information
116     mapping(uint256 => BoostData) public boostData;
117     // engineer information
118     mapping(uint256 => EngineerData) public engineers;
119     
120     // minigame info
121     mapping(address => bool) public miniGames; 
122     
123     struct Player {
124         mapping(uint256 => uint256) engineersCount;
125         uint256 virusNumber;
126         uint256 research;
127         uint256 lastUpdateTime;
128         bool endLoadOldData;
129     }
130     struct BoostData {
131         address owner;
132         uint256 boostRate;
133         uint256 basePrice;
134     }
135     struct EngineerData {
136         uint256 basePrice;
137         uint256 baseETH;
138         uint256 baseResearch;
139         uint256 limit;
140     }
141     modifier disableContract()
142     {
143         require(tx.origin == msg.sender);
144         _;
145     }
146     modifier isAdministrator()
147     {
148         require(msg.sender == administrator);
149         _;
150     }
151     modifier onlyContractsMiniGame() 
152     {
153         require(miniGames[msg.sender] == true);
154         _;
155     }
156 
157     event BuyEngineer(address _addr, uint256[8] engineerNumbers, uint256 _crytalsPrice, uint256 _ethPrice, uint256 _researchBuy);
158     event BuyBooster(address _addr, uint256 _boostIdx, address beneficiary);
159     event ChangeVirus(address _addr, uint256 _virus, uint256 _type); // 1: add, 2: sub
160     event BecomeGameSponsor(address _addr, uint256 _price);
161     event UpdateResearch(address _addr, uint256 _currentResearch);
162 
163     //--------------------------------------------------------------------------
164     // INIT CONTRACT 
165     //--------------------------------------------------------------------------
166     constructor() public {
167         administrator = msg.sender;
168 
169         initBoostData();
170         initEngineer();
171         // set interface main contract
172         setMiningWarInterface(0x1b002cd1ba79dfad65e8abfbb3a97826e4960fe5);        
173     }
174     function initEngineer() private
175     {
176         //                          price crystals    price ETH         research  limit                         
177         engineers[0] = EngineerData(10,               BASE_PRICE * 0,   10,       10   );   //lv1 
178         engineers[1] = EngineerData(50,               BASE_PRICE * 1,   3356,     2    );   //lv2
179         engineers[2] = EngineerData(200,              BASE_PRICE * 2,   8390,     4    );   //lv3
180         engineers[3] = EngineerData(800,              BASE_PRICE * 4,   20972,    8    );   //lv4
181         engineers[4] = EngineerData(3200,             BASE_PRICE * 8,   52430,    16   );   //lv5
182         engineers[5] = EngineerData(12800,            BASE_PRICE * 16,  131072,   32   );   //lv6
183         engineers[6] = EngineerData(102400,           BASE_PRICE * 32,  327680,   64   );   //lv7
184         engineers[7] = EngineerData(819200,           BASE_PRICE * 64,  819200,   65536);   //lv8
185     }
186     function initBoostData() private 
187     {
188         boostData[0] = BoostData(0x0, 150, BASE_PRICE * 1);
189         boostData[1] = BoostData(0x0, 175, BASE_PRICE * 2);
190         boostData[2] = BoostData(0x0, 200, BASE_PRICE * 4);
191         boostData[3] = BoostData(0x0, 225, BASE_PRICE * 8);
192         boostData[4] = BoostData(0x0, 250, BASE_PRICE * 16);
193     }
194     /** 
195     * @dev MainContract used this function to verify game's contract
196     */
197     function isContractMiniGame() public pure returns(bool _isContractMiniGame)
198     {
199     	_isContractMiniGame = true;
200     }
201     function isEngineerContract() public pure returns(bool)
202     {
203         return true;
204     }
205     function () public payable
206     {
207         addPrizePool(msg.value);
208     }
209     /** 
210     * @dev Main Contract call this function to setup mini game.
211     */
212     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/ ) public
213     {
214         require(msg.sender == miningWarAddress);
215         MiningWar.fallback.value(SafeMath.div(SafeMath.mul(prizePool, 5), 100))();
216         prizePool = SafeMath.sub(prizePool, SafeMath.div(SafeMath.mul(prizePool, 5), 100));
217     }
218     //--------------------------------------------------------------------------
219     // SETTING CONTRACT MINI GAME 
220     //--------------------------------------------------------------------------
221     function setMiningWarInterface(address _addr) public isAdministrator
222     {
223         CryptoMiningWarInterface miningWarInterface = CryptoMiningWarInterface(_addr);
224 
225         require(miningWarInterface.isMiningWarContract() == true);
226         
227         miningWarAddress = _addr;
228         
229         MiningWar = miningWarInterface;
230     }
231     function setContractsMiniGame( address _addr ) public isAdministrator 
232     {
233         MiniGameInterface MiniGame = MiniGameInterface( _addr );
234         
235         if( MiniGame.isContractMiniGame() == false ) { revert(); }
236 
237         miniGames[_addr] = true;
238     }
239     /**
240     * @dev remove mini game contract from main contract
241     * @param _addr mini game contract address
242     */
243     function removeContractMiniGame(address _addr) public isAdministrator
244     {
245         miniGames[_addr] = false;
246     }
247     //@dev use this function in case of bug
248     function upgrade(address addr) public isAdministrator
249     {
250         selfdestruct(addr);
251     }
252     //--------------------------------------------------------------------------
253     // BOOSTER 
254     //--------------------------------------------------------------------------
255     function buyBooster(uint256 idx) public payable 
256     {
257         require(idx < numberOfBoosts);
258         BoostData storage b = boostData[idx];
259 
260         if (msg.value < b.basePrice || msg.sender == b.owner) revert();
261         
262         address beneficiary = b.owner;
263         uint256 devFeePrize = devFee(b.basePrice);
264         
265         distributedToOwner(devFeePrize);
266         addMiningWarPrizePool(devFeePrize);
267         addPrizePool(SafeMath.sub(msg.value, SafeMath.mul(devFeePrize,3)));
268         
269         updateVirus(msg.sender);
270 
271         if ( beneficiary != 0x0 ) updateVirus(beneficiary);
272         
273         // transfer ownership    
274         b.owner = msg.sender;
275 
276         emit BuyBooster(msg.sender, idx, beneficiary );
277     }
278     function getBoosterData(uint256 idx) public view returns (address _owner,uint256 _boostRate, uint256 _basePrice)
279     {
280         require(idx < numberOfBoosts);
281         BoostData memory b = boostData[idx];
282         _owner = b.owner;
283         _boostRate = b.boostRate; 
284         _basePrice = b.basePrice;
285     }
286     function hasBooster(address addr) public view returns (uint256 _boostIdx)
287     {         
288         _boostIdx = 999;
289         for(uint256 i = 0; i < numberOfBoosts; i++){
290             uint256 revert_i = numberOfBoosts - i - 1;
291             if(boostData[revert_i].owner == addr){
292                 _boostIdx = revert_i;
293                 break;
294             }
295         }
296     }
297     //--------------------------------------------------------------------------
298     // GAME SPONSOR
299     //--------------------------------------------------------------------------
300     /**
301     */
302     function becomeGameSponsor() public payable disableContract
303     {
304         uint256 gameSponsorPriceFee = SafeMath.div(SafeMath.mul(gameSponsorPrice, 150), 100);
305         require(msg.value >= gameSponsorPriceFee);
306         require(msg.sender != gameSponsor);
307         // 
308         uint256 repayPrice = SafeMath.div(SafeMath.mul(gameSponsorPrice, 110), 100);
309         gameSponsor.transfer(repayPrice);
310         
311         // add to prize pool
312         addPrizePool(SafeMath.sub(msg.value, repayPrice));
313         // update game sponsor info
314         gameSponsor = msg.sender;
315         gameSponsorPrice = gameSponsorPriceFee;
316 
317         emit BecomeGameSponsor(msg.sender, msg.value);
318     }
319 
320 
321     function addEngineer(address _addr, uint256 idx, uint256 _value) public isAdministrator
322     {
323         require(idx < numberOfEngineer);
324         require(_value != 0);
325 
326         Player storage p = players[_addr];
327         EngineerData memory e = engineers[idx];
328 
329         if (SafeMath.add(p.engineersCount[idx], _value) > e.limit) revert();
330 
331         updateVirus(_addr);
332 
333         p.engineersCount[idx] = SafeMath.add(p.engineersCount[idx], _value);
334 
335         updateResearch(_addr, SafeMath.mul(_value, e.baseResearch));
336     }
337 
338     // ----------------------------------------------------------------------------------------
339     // USING FOR MINI GAME CONTRACT
340     // ---------------------------------------------------------------------------------------
341     function setBoostData(uint256 idx, address owner, uint256 boostRate, uint256 basePrice)  public onlyContractsMiniGame
342     {
343         require(owner != 0x0);
344         BoostData storage b = boostData[idx];
345         b.owner     = owner;
346         b.boostRate = boostRate;
347         b.basePrice = basePrice;
348     }
349     function setGameSponsorInfo(address _addr, uint256 _value) public onlyContractsMiniGame
350     {
351         gameSponsor      = _addr;
352         gameSponsorPrice = _value;
353     }
354     function setPlayerLastUpdateTime(address _addr) public onlyContractsMiniGame
355     {
356         require(players[_addr].endLoadOldData == false);
357         players[_addr].lastUpdateTime = now;
358         players[_addr].endLoadOldData = true;
359     }
360     function setPlayerEngineersCount( address _addr, uint256 idx, uint256 _value) public onlyContractsMiniGame
361     {
362          players[_addr].engineersCount[idx] = _value;
363     }
364     function setPlayerResearch(address _addr, uint256 _value) public onlyContractsMiniGame
365     {        
366         players[_addr].research = _value;
367     }
368     function setPlayerVirusNumber(address _addr, uint256 _value) public onlyContractsMiniGame
369     {
370         players[_addr].virusNumber = _value;
371     }
372     function addResearch(address _addr, uint256 _value) public onlyContractsMiniGame
373     {
374         updateVirus(_addr);
375 
376         Player storage p = players[_addr];
377 
378         p.research = SafeMath.add(p.research, _value);
379 
380         emit UpdateResearch(_addr, p.research);
381     }
382     function subResearch(address _addr, uint256 _value) public onlyContractsMiniGame
383     {
384         updateVirus(_addr);
385 
386         Player storage p = players[_addr];
387         
388         if (p.research < _value) revert();
389         
390         p.research = SafeMath.sub(p.research, _value);
391 
392         emit UpdateResearch(_addr, p.research);
393     }
394     /**
395     * @dev add virus for player
396     * @param _addr player address
397     * @param _value number of virus
398     */
399     function addVirus(address _addr, uint256 _value) public onlyContractsMiniGame
400     {
401         Player storage p = players[_addr];
402 
403         uint256 additionalVirus = SafeMath.mul(_value,VIRUS_MINING_PERIOD);
404         
405         p.virusNumber = SafeMath.add(p.virusNumber, additionalVirus);
406 
407         emit ChangeVirus(_addr, _value, 1);
408     }
409     /**
410     * @dev subtract virus of player
411     * @param _addr player address 
412     * @param _value number virus subtract 
413     */
414     function subVirus(address _addr, uint256 _value) public onlyContractsMiniGame
415     {
416         updateVirus(_addr);
417 
418         Player storage p = players[_addr];
419         
420         uint256 subtractVirus = SafeMath.mul(_value,VIRUS_MINING_PERIOD);
421         
422         if ( p.virusNumber < subtractVirus ) { revert(); }
423 
424         p.virusNumber = SafeMath.sub(p.virusNumber, subtractVirus);
425 
426         emit ChangeVirus(_addr, _value, 2);
427     }
428     /**
429     * @dev claim price pool to next new game
430     * @param _addr mini game contract address
431     * @param _value eth claim;
432     */
433     function claimPrizePool(address _addr, uint256 _value) public onlyContractsMiniGame 
434     {
435         require(prizePool > _value);
436 
437         prizePool = SafeMath.sub(prizePool, _value);
438 
439         MiniGameInterface MiniGame = MiniGameInterface( _addr );
440         
441         MiniGame.fallback.value(_value)();
442     }
443     //--------------------------------------------------------------------------
444     // PLAYERS
445     //--------------------------------------------------------------------------
446     /**
447     */
448     function buyEngineer(uint256[8] engineerNumbers) public payable disableContract
449     {        
450         updateVirus(msg.sender);
451 
452         Player storage p = players[msg.sender];
453         
454         uint256 priceCrystals = 0;
455         uint256 priceEth = 0;
456         uint256 research = 0;
457         for (uint256 engineerIdx = 0; engineerIdx < numberOfEngineer; engineerIdx++) {
458             uint256 engineerNumber = engineerNumbers[engineerIdx];
459             EngineerData memory e = engineers[engineerIdx];
460             // require for engineerNumber 
461             if(engineerNumber > e.limit || engineerNumber < 0) revert();
462             
463             // engineer you want buy
464             if (engineerNumber > 0) {
465                 uint256 currentEngineerCount = p.engineersCount[engineerIdx];
466                 // update player data
467                 p.engineersCount[engineerIdx] = SafeMath.min(e.limit, SafeMath.add(p.engineersCount[engineerIdx], engineerNumber));
468                 // calculate no research you want buy
469                 research = SafeMath.add(research, SafeMath.mul(SafeMath.sub(p.engineersCount[engineerIdx],currentEngineerCount), e.baseResearch));
470                 // calculate price crystals and eth you will pay
471                 priceCrystals = SafeMath.add(priceCrystals, SafeMath.mul(e.basePrice, engineerNumber));
472                 priceEth = SafeMath.add(priceEth, SafeMath.mul(e.baseETH, engineerNumber));
473             }
474         }
475         // check price eth
476         if (priceEth < msg.value) revert();
477 
478         uint256 devFeePrize = devFee(priceEth);
479         distributedToOwner(devFeePrize);
480         addMiningWarPrizePool(devFeePrize);
481         addPrizePool(SafeMath.sub(msg.value, SafeMath.mul(devFeePrize,3)));        
482 
483         // pay and update
484         MiningWar.subCrystal(msg.sender, priceCrystals);
485         updateResearch(msg.sender, research);
486 
487         emit BuyEngineer(msg.sender, engineerNumbers, priceCrystals, priceEth, research);
488     }
489      /**
490     * @dev update virus for player 
491     * @param _addr player address
492     */
493     function updateVirus(address _addr) private
494     {
495         Player storage p = players[_addr]; 
496         p.virusNumber = calCurrentVirus(_addr);
497         p.lastUpdateTime = now;
498     }
499     function calCurrentVirus(address _addr) public view returns(uint256 _currentVirus)
500     {
501         Player memory p = players[_addr]; 
502         uint256 secondsPassed = SafeMath.sub(now, p.lastUpdateTime);
503         uint256 researchPerDay = getResearchPerDay(_addr);   
504         _currentVirus = p.virusNumber;
505         if (researchPerDay > 0) {
506             _currentVirus = SafeMath.add(_currentVirus, SafeMath.mul(researchPerDay, secondsPassed));
507         }   
508     }
509     /**
510     * @dev update research for player
511     * @param _addr player address
512     * @param _research number research want to add
513     */
514     function updateResearch(address _addr, uint256 _research) private 
515     {
516         Player storage p = players[_addr];
517         p.research = SafeMath.add(p.research, _research);
518 
519         emit UpdateResearch(_addr, p.research);
520     }
521     function getResearchPerDay(address _addr) public view returns( uint256 _researchPerDay)
522     {
523         Player memory p = players[_addr];
524         _researchPerDay =  p.research;
525         uint256 boosterIdx = hasBooster(_addr);
526         if (boosterIdx != 999) {
527             BoostData memory b = boostData[boosterIdx];
528             _researchPerDay = SafeMath.div(SafeMath.mul(_researchPerDay, b.boostRate), 100);
529         } 
530     }
531     /**
532     * @dev get player data
533     * @param _addr player address
534     */
535     function getPlayerData(address _addr) 
536     public 
537     view 
538     returns(
539         uint256 _virusNumber, 
540         uint256 _currentVirus,
541         uint256 _research, 
542         uint256 _researchPerDay, 
543         uint256 _lastUpdateTime, 
544         uint256[8] _engineersCount
545     )
546     {
547         Player storage p = players[_addr];
548         for ( uint256 idx = 0; idx < numberOfEngineer; idx++ ) {
549             _engineersCount[idx] = p.engineersCount[idx];
550         }
551         _currentVirus= SafeMath.div(calCurrentVirus(_addr), VIRUS_MINING_PERIOD);
552         _virusNumber = SafeMath.div(p.virusNumber, VIRUS_MINING_PERIOD);
553         _lastUpdateTime = p.lastUpdateTime;
554         _research = p.research;
555         _researchPerDay = getResearchPerDay(_addr);
556     }
557     //--------------------------------------------------------------------------
558     // INTERNAL 
559     //--------------------------------------------------------------------------
560     function addPrizePool(uint256 _value) private 
561     {
562         prizePool = SafeMath.add(prizePool, _value);
563     }
564     /**
565     * @dev add 5% value of transaction payable
566     */
567     function addMiningWarPrizePool(uint256 _value) private
568     {
569         MiningWar.fallback.value(_value)();
570     }
571     /**
572     * @dev calculate current crystals of player
573     * @param _addr player address
574     */
575     function calCurrentCrystals(address _addr) public view returns(uint256 _currentCrystals)
576     {
577         _currentCrystals = SafeMath.div(MiningWar.calCurrentCrystals(_addr), CRTSTAL_MINING_PERIOD);
578     }
579     function devFee(uint256 _amount) private pure returns(uint256)
580     {
581         return SafeMath.div(SafeMath.mul(_amount, 5), 100);
582     }
583     /**
584     * @dev with transaction payable send 5% value for admin and sponsor
585     * @param _value fee 
586     */
587     function distributedToOwner(uint256 _value) private
588     {
589         gameSponsor.transfer(_value);
590         administrator.transfer(_value);
591     }
592 }