1 pragma solidity ^0.4.18;
2 
3 /**
4  * SpaceWar
5  * ETH Idle Game
6  * spacewar.etherfun.net
7  */
8 
9 library SafeMath {
10     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         c = a + b;
12         require(c >= a);
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         require(b <= a);
17         c = a - b;
18     }
19 
20     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24 }
25 
26 library NumericSequence
27 {
28     using SafeMath for uint256;
29     function sumOfN(uint256 basePrice, uint256 pricePerLevel, uint256 owned, uint256 count) internal pure returns (uint256 price)
30     {
31         require(count > 0);
32 
33         price = 0;
34         price += SafeMath.mul((basePrice + pricePerLevel * owned), count);
35         price += pricePerLevel * (count.mul((count-1))) / 2;
36     }
37 }
38 
39 //-----------------------------------------------------------------------
40 contract SpaceWar  {
41     using NumericSequence for uint;
42     using SafeMath for uint;
43 
44     struct MinerData
45     {
46         uint256[9]   spaces; // space types and their upgrades
47         uint8[3]     hasUpgrade;
48         uint256      money;
49         uint256      lastUpdateTime;
50         uint256      premamentMineBonusPct;
51         uint256      unclaimedPot;
52         uint256      lastPotClaimIndex;
53     }
54 
55     struct SpaceData
56     {
57         uint256 basePrice;
58         uint256 baseOutput;
59         uint256 pricePerLevel;
60         uint256 priceInETH;
61         uint256 limit;
62     }
63 
64     struct BoostData
65     {
66         uint256 percentBonus;
67         uint256 priceInWEI;
68     }
69 
70     struct PVPData
71     {
72         uint256[6] troops;
73         uint256    immunityTime;
74         uint256    exhaustTime;
75     }
76 
77     struct TroopData
78     {
79         uint256 attackPower;
80         uint256 defensePower;
81         uint256 priceGold;
82         uint256 priceETH;
83     }
84 
85     uint8 private constant NUMBER_OF_RIG_TYPES = 9;
86     SpaceData[9]  private spaceData;
87 
88     uint8 private constant NUMBER_OF_UPGRADES = 3;
89     BoostData[3] private boostData;
90 
91     uint8 private constant NUMBER_OF_TROOPS = 6;
92     uint8 private constant ATTACKER_START_IDX = 0;
93     uint8 private constant ATTACKER_END_IDX = 3;
94     uint8 private constant DEFENDER_START_IDX = 3;
95     uint8 private constant DEFENDER_END_IDX = 6;
96     TroopData[6] private troopData;
97 
98     // honey pot variables
99     uint256 private honeyPotAmount;
100     uint256 private honeyPotSharePct; // 90%
101     uint256 private jackPot;
102     uint256 private devFund;
103     uint256 private nextPotDistributionTime;
104     mapping(address => mapping(uint256 => uint256)) private minerICOPerCycle;
105     uint256[] private honeyPotPerCycle;
106     uint256[] private globalICOPerCycle;
107     uint256 private cycleCount;
108 
109     //booster info
110     uint256 private constant NUMBER_OF_BOOSTERS = 5;
111     uint256 private boosterIndex;
112     uint256 private nextBoosterPrice;
113     address[5] private boosterHolders;
114 
115     mapping(address => MinerData) private miners;
116     mapping(address => PVPData)   private pvpMap;
117     mapping(uint256 => address)   private indexes;
118     uint256 private topindex;
119 
120     address private owner;
121 
122     // ------------------------------------------------------------------------
123     // Constructor
124     // ------------------------------------------------------------------------
125     function SpaceWar() public {
126         owner = msg.sender;
127 
128         //                   price,           prod.     upgrade,        priceETH, limit
129         spaceData[0] = SpaceData(500,             1,        5,               0,          999);
130         spaceData[1] = SpaceData(50000,           10,       500,             0,          999);
131         spaceData[2] = SpaceData(5000000,         100,      50000,           0,          999);
132         spaceData[3] = SpaceData(80000000,        1000,     800000,          0,          999);
133         spaceData[4] = SpaceData(500000000,       20000,    5000000,         0.01 ether, 999);
134         spaceData[5] = SpaceData(10000000000,     100000,   100000000,       0,          999);
135         spaceData[6] = SpaceData(100000000000,    1000000,  1000000000,      0,          999);
136         spaceData[7] = SpaceData(1000000000000,   50000000, 10000000000,     0.1 ether,  999);
137         spaceData[8] = SpaceData(10000000000000,  100000000,100000000000,    0,          999);
138 
139         boostData[0] = BoostData(30,  0.01 ether);
140         boostData[1] = BoostData(50,  0.1 ether);
141         boostData[2] = BoostData(100, 1 ether);
142 
143         topindex = 0;
144         honeyPotAmount = 0;
145         devFund = 0;
146         jackPot = 0;
147         nextPotDistributionTime = block.timestamp;
148         honeyPotSharePct = 90;
149 
150         // has to be set to a value
151         boosterHolders[0] = owner;
152         boosterHolders[1] = owner;
153         boosterHolders[2] = owner;
154         boosterHolders[3] = owner;
155         boosterHolders[4] = owner;
156 
157         boosterIndex = 0;
158         nextBoosterPrice = 0.1 ether;
159 
160         //pvp
161         troopData[0] = TroopData(10,     0,      100000,   0);
162         troopData[1] = TroopData(1000,   0,      80000000, 0);
163         troopData[2] = TroopData(100000, 0,      1000000000,   0.01 ether);
164         troopData[3] = TroopData(0,      15,     100000,   0);
165         troopData[4] = TroopData(0,      1500,   80000000, 0);
166         troopData[5] = TroopData(0,      150000, 1000000000,   0.01 ether);
167 
168         honeyPotPerCycle.push(0);
169         globalICOPerCycle.push(1);
170         cycleCount = 0;
171     }
172 
173     //--------------------------------------------------------------------------
174     // Data access functions
175     //--------------------------------------------------------------------------
176     function GetMinerData(address minerAddr) public constant returns
177         (uint256 money, uint256 lastupdate, uint256 prodPerSec,
178          uint256[9] spaces, uint[3] upgrades, uint256 unclaimedPot, bool hasBooster, uint256 unconfirmedMoney)
179     {
180         uint8 i = 0;
181 
182         money = miners[minerAddr].money;
183         lastupdate = miners[minerAddr].lastUpdateTime;
184         prodPerSec = GetProductionPerSecond(minerAddr);
185 
186         for(i = 0; i < NUMBER_OF_RIG_TYPES; ++i)
187         {
188             spaces[i] = miners[minerAddr].spaces[i];
189         }
190 
191         for(i = 0; i < NUMBER_OF_UPGRADES; ++i)
192         {
193             upgrades[i] = miners[minerAddr].hasUpgrade[i];
194         }
195 
196         unclaimedPot = miners[minerAddr].unclaimedPot;
197         hasBooster = HasBooster(minerAddr);
198 
199         unconfirmedMoney = money + (prodPerSec * (now - lastupdate));
200     }
201 
202     function GetTotalMinerCount() public constant returns (uint256 count)
203     {
204         count = topindex;
205     }
206 
207     function GetMinerAt(uint256 idx) public constant returns (address minerAddr)
208     {
209         require(idx < topindex);
210         minerAddr = indexes[idx];
211     }
212 
213     function GetPotInfo() public constant returns (uint256 _honeyPotAmount, uint256 _devFunds, uint256 _jackPot, uint256 _nextDistributionTime)
214     {
215         _honeyPotAmount = honeyPotAmount;
216         _devFunds = devFund;
217         _jackPot = jackPot;
218         _nextDistributionTime = nextPotDistributionTime;
219     }
220 
221     function GetProductionPerSecond(address minerAddr) public constant returns (uint256 personalProduction)
222     {
223         MinerData storage m = miners[minerAddr];
224 
225         personalProduction = 0;
226         uint256 productionSpeed = 100 + m.premamentMineBonusPct;
227 
228         if(HasBooster(minerAddr)) // 100% bonus
229             productionSpeed += 100;
230 
231         for(uint8 j = 0; j < NUMBER_OF_RIG_TYPES; ++j)
232         {
233             personalProduction += m.spaces[j] * spaceData[j].baseOutput;
234         }
235 
236         personalProduction = personalProduction * productionSpeed / 100;
237     }
238 
239     function GetGlobalProduction() public constant returns (uint256 globalMoney, uint256 globalHashRate)
240     {
241         globalMoney = 0;
242         globalHashRate = 0;
243         uint i = 0;
244         for(i = 0; i < topindex; ++i)
245         {
246             MinerData storage m = miners[indexes[i]];
247             globalMoney += m.money;
248             globalHashRate += GetProductionPerSecond(indexes[i]);
249         }
250     }
251 
252     function GetBoosterData() public constant returns (address[5] _boosterHolders, uint256 currentPrice, uint256 currentIndex)
253     {
254         for(uint i = 0; i < NUMBER_OF_BOOSTERS; ++i)
255         {
256             _boosterHolders[i] = boosterHolders[i];
257         }
258         currentPrice = nextBoosterPrice;
259         currentIndex = boosterIndex;
260     }
261 
262     function HasBooster(address addr) public constant returns (bool hasBoost)
263     {
264         for(uint i = 0; i < NUMBER_OF_BOOSTERS; ++i)
265         {
266            if(boosterHolders[i] == addr)
267             return true;
268         }
269         return false;
270     }
271 
272     function GetPVPData(address addr) public constant returns (uint256 attackpower, uint256 defensepower, uint256 immunityTime, uint256 exhaustTime,
273     uint256[6] troops)
274     {
275         PVPData storage a = pvpMap[addr];
276 
277         immunityTime = a.immunityTime;
278         exhaustTime = a.exhaustTime;
279 
280         attackpower = 0;
281         defensepower = 0;
282         for(uint i = 0; i < NUMBER_OF_TROOPS; ++i)
283         {
284             attackpower  += a.troops[i] * troopData[i].attackPower;
285             defensepower += a.troops[i] * troopData[i].defensePower;
286 
287             troops[i] = a.troops[i];
288         }
289     }
290 
291     function GetCurrentICOCycle() public constant returns (uint256)
292     {
293         return cycleCount;
294     }
295 
296     function GetICOData(uint256 idx) public constant returns (uint256 ICOFund, uint256 ICOPot)
297     {
298         require(idx <= cycleCount);
299         ICOFund = globalICOPerCycle[idx];
300         if(idx < cycleCount)
301         {
302             ICOPot = honeyPotPerCycle[idx];
303         } else
304         {
305             ICOPot =  honeyPotAmount / 10; // actual day estimate
306         }
307     }
308 
309     function GetMinerICOData(address miner, uint256 idx) public constant returns (uint256 ICOFund, uint256 ICOShare, uint256 lastClaimIndex)
310     {
311         require(idx <= cycleCount);
312         ICOFund = minerICOPerCycle[miner][idx];
313         if(idx < cycleCount)
314         {
315             ICOShare = (honeyPotPerCycle[idx] * minerICOPerCycle[miner][idx]) / globalICOPerCycle[idx];
316         } else
317         {
318             ICOShare = (honeyPotAmount / 10) * minerICOPerCycle[miner][idx] / globalICOPerCycle[idx];
319         }
320         lastClaimIndex = miners[miner].lastPotClaimIndex;
321     }
322 
323     function GetMinerUnclaimedICOShare(address miner) public constant returns (uint256 unclaimedPot)
324     {
325         MinerData storage m = miners[miner];
326 
327         require(m.lastUpdateTime != 0);
328         require(m.lastPotClaimIndex < cycleCount);
329 
330         uint256 i = m.lastPotClaimIndex;
331         uint256 limit = cycleCount;
332 
333         if((limit - i) > 30) // more than 30 iterations(days) afk
334             limit = i + 30;
335 
336         unclaimedPot = 0;
337         for(; i < cycleCount; ++i)
338         {
339             if(minerICOPerCycle[miner][i] > 0)
340                 unclaimedPot += (honeyPotPerCycle[i] * minerICOPerCycle[miner][i]) / globalICOPerCycle[i];
341         }
342     }
343 
344     // -------------------------------------------------------------------------
345     // SpaceWars game handler functions
346     // -------------------------------------------------------------------------
347     function StartNewMiner() external
348     {
349         require(miners[msg.sender].lastUpdateTime == 0);
350 
351         miners[msg.sender].lastUpdateTime = block.timestamp;
352         miners[msg.sender].money = 0;
353         miners[msg.sender].spaces[0] = 1;
354         miners[msg.sender].unclaimedPot = 0;
355         miners[msg.sender].lastPotClaimIndex = cycleCount;
356 
357         pvpMap[msg.sender].immunityTime = block.timestamp + 14400;
358         pvpMap[msg.sender].exhaustTime  = block.timestamp;
359 
360         indexes[topindex] = msg.sender;
361         ++topindex;
362     }
363 
364     function UpgradeSpace(uint8 spaceIdx, uint16 count) external
365     {
366         require(spaceIdx < NUMBER_OF_RIG_TYPES);
367         require(count > 0);
368         require(count <= 999);
369         require(spaceData[spaceIdx].priceInETH == 0);
370         MinerData storage m = miners[msg.sender];
371 
372         require(spaceData[spaceIdx].limit >= (m.spaces[spaceIdx] + count));
373 
374         UpdateMoney();
375 
376         // the base of geometrical sequence
377         uint256 price = NumericSequence.sumOfN(spaceData[spaceIdx].basePrice, spaceData[spaceIdx].pricePerLevel, m.spaces[spaceIdx], count);
378 
379         require(m.money >= price);
380 
381         m.spaces[spaceIdx] = m.spaces[spaceIdx] + count;
382 
383         if(m.spaces[spaceIdx] > spaceData[spaceIdx].limit)
384             m.spaces[spaceIdx] = spaceData[spaceIdx].limit;
385 
386         m.money -= price;
387     }
388 
389     function UpgradeSpaceETH(uint8 spaceIdx, uint256 count) external payable
390     {
391         require(spaceIdx < NUMBER_OF_RIG_TYPES);
392         require(count > 0);
393         require(count <= 999);
394         require(spaceData[spaceIdx].priceInETH > 0);
395 
396         MinerData storage m = miners[msg.sender];
397 
398         require(spaceData[spaceIdx].limit >= (m.spaces[spaceIdx] + count));
399 
400         uint256 price = (spaceData[spaceIdx].priceInETH).mul(count);
401 
402         uint256 priceCoin = NumericSequence.sumOfN(spaceData[spaceIdx].basePrice, spaceData[spaceIdx].pricePerLevel, m.spaces[spaceIdx], count);
403 
404         UpdateMoney();
405         require(msg.value >= price);
406         require(m.money >= priceCoin);
407 
408         BuyHandler(msg.value);
409 
410         m.spaces[spaceIdx] = m.spaces[spaceIdx] + count;
411 
412         if(m.spaces[spaceIdx] > spaceData[spaceIdx].limit)
413             m.spaces[spaceIdx] = spaceData[spaceIdx].limit;
414 
415         m.money -= priceCoin;
416     }
417 
418     function UpdateMoney() private
419     {
420         require(miners[msg.sender].lastUpdateTime != 0);
421         require(block.timestamp >= miners[msg.sender].lastUpdateTime);
422 
423         MinerData storage m = miners[msg.sender];
424         uint256 diff = block.timestamp - m.lastUpdateTime;
425         uint256 revenue = GetProductionPerSecond(msg.sender);
426 
427         m.lastUpdateTime = block.timestamp;
428         if(revenue > 0)
429         {
430             revenue *= diff;
431 
432             m.money += revenue;
433         }
434     }
435 
436     function UpdateMoneyAt(address addr) private
437     {
438         require(miners[addr].lastUpdateTime != 0);
439         require(block.timestamp >= miners[addr].lastUpdateTime);
440 
441         MinerData storage m = miners[addr];
442         uint256 diff = block.timestamp - m.lastUpdateTime;
443         uint256 revenue = GetProductionPerSecond(addr);
444 
445         m.lastUpdateTime = block.timestamp;
446         if(revenue > 0)
447         {
448             revenue *= diff;
449 
450             m.money += revenue;
451         }
452     }
453 
454     function BuyUpgrade(uint256 idx) external payable
455     {
456         require(idx < NUMBER_OF_UPGRADES);
457         require(msg.value >= boostData[idx].priceInWEI);
458         require(miners[msg.sender].hasUpgrade[idx] == 0);
459         require(miners[msg.sender].lastUpdateTime != 0);
460 
461         BuyHandler(msg.value);
462 
463         UpdateMoney();
464 
465         miners[msg.sender].hasUpgrade[idx] = 1;
466         miners[msg.sender].premamentMineBonusPct +=  boostData[idx].percentBonus;
467     }
468 
469     //--------------------------------------------------------------------------
470     // BOOSTER handlers
471     //--------------------------------------------------------------------------
472     function BuyBooster() external payable
473     {
474         require(msg.value >= nextBoosterPrice);
475         require(miners[msg.sender].lastUpdateTime != 0);
476 
477         for(uint i = 0; i < NUMBER_OF_BOOSTERS; ++i)
478             if(boosterHolders[i] == msg.sender)
479                 revert();
480 
481         address beneficiary = boosterHolders[boosterIndex];
482 
483         MinerData storage m = miners[beneficiary];
484 
485         // 20% interest after 5 buys
486         m.unclaimedPot += (msg.value * 9403) / 10000;
487 
488         // distribute the rest
489         honeyPotAmount += (msg.value * 597) / 20000;
490         devFund += (msg.value * 597) / 20000;
491 
492         // increase price by 5%
493         nextBoosterPrice += nextBoosterPrice / 20;
494 
495         UpdateMoney();
496         UpdateMoneyAt(beneficiary);
497 
498         // transfer ownership
499         boosterHolders[boosterIndex] = msg.sender;
500 
501         // increase booster index
502         boosterIndex += 1;
503         if(boosterIndex >= 5)
504             boosterIndex = 0;
505     }
506 
507     //--------------------------------------------------------------------------
508     // PVP handler
509     //--------------------------------------------------------------------------
510     // 0 for attacker 1 for defender
511     function BuyTroop(uint256 idx, uint256 count) external payable
512     {
513         require(idx < NUMBER_OF_TROOPS);
514         require(count > 0);
515         require(count <= 1000);
516 
517         PVPData storage pvp = pvpMap[msg.sender];
518         MinerData storage m = miners[msg.sender];
519 
520         uint256 owned = pvp.troops[idx];
521 
522         uint256 priceGold = NumericSequence.sumOfN(troopData[idx].priceGold, troopData[idx].priceGold / 100, owned, count);
523         uint256 priceETH = (troopData[idx].priceETH).mul(count);
524 
525         UpdateMoney();
526 
527         require(m.money >= priceGold);
528         require(msg.value >= priceETH);
529 
530         if(priceGold > 0)
531             m.money -= priceGold;
532 
533         if(msg.value > 0)
534             BuyHandler(msg.value);
535 
536         pvp.troops[idx] += count;
537     }
538 
539     function Attack(address defenderAddr) external
540     {
541         require(msg.sender != defenderAddr);
542         require(miners[msg.sender].lastUpdateTime != 0);
543         require(miners[defenderAddr].lastUpdateTime != 0);
544 
545         PVPData storage attacker = pvpMap[msg.sender];
546         PVPData storage defender = pvpMap[defenderAddr];
547         uint i = 0;
548         uint256 count = 0;
549 
550         require(block.timestamp > attacker.exhaustTime);
551         require(block.timestamp > defender.immunityTime);
552 
553         // the aggressor loses immunity
554         if(attacker.immunityTime > block.timestamp)
555             attacker.immunityTime = block.timestamp - 1;
556 
557         attacker.exhaustTime = block.timestamp + 3600;
558 
559         uint256 attackpower = 0;
560         uint256 defensepower = 0;
561         for(i = 0; i < ATTACKER_END_IDX; ++i)
562         {
563             attackpower  += attacker.troops[i] * troopData[i].attackPower;
564             defensepower += defender.troops[i + DEFENDER_START_IDX] * troopData[i + DEFENDER_START_IDX].defensePower;
565         }
566 
567         if(attackpower > defensepower)
568         {
569             if(defender.immunityTime < block.timestamp + 14400)
570                 defender.immunityTime = block.timestamp + 14400;
571 
572             UpdateMoneyAt(defenderAddr);
573 
574             MinerData storage m = miners[defenderAddr];
575             MinerData storage m2 = miners[msg.sender];
576             uint256 moneyStolen = m.money / 2;
577 
578             for(i = DEFENDER_START_IDX; i < DEFENDER_END_IDX; ++i)
579             {
580                 defender.troops[i] = defender.troops[i]/2;
581             }
582 
583             for(i = ATTACKER_START_IDX; i < ATTACKER_END_IDX; ++i)
584             {
585                 if(troopData[i].attackPower > 0)
586                 {
587                     count = attacker.troops[i];
588 
589                     // if the troops overpower the total defense power only a fraction is lost
590                     if((count * troopData[i].attackPower) > defensepower)
591                         {
592                             count = count * defensepower / attackpower / 2;
593                         }
594                     else
595                          {
596                              count =  count/2;
597                          }
598                     attacker.troops[i] = SafeMath.sub(attacker.troops[i],count);
599                     defensepower -= count * troopData[i].attackPower;
600                 }
601             }
602 
603             m.money -= moneyStolen;
604             m2.money += moneyStolen;
605         } else
606         {
607             for(i = ATTACKER_START_IDX; i < ATTACKER_END_IDX; ++i)
608             {
609                 attacker.troops[i] = attacker.troops[i] / 2;
610             }
611 
612             for(i = DEFENDER_START_IDX; i < DEFENDER_END_IDX; ++i)
613             {
614                 if(troopData[i].defensePower > 0)
615                 {
616                     count = defender.troops[i];
617 
618                     // if the troops overpower the total defense power only a fraction is lost
619                     if((count * troopData[i].defensePower) > attackpower)
620                         count = count * attackpower / defensepower / 2;
621 
622                     defender.troops[i] -= count;
623                     attackpower -= count * troopData[i].defensePower;
624                 }
625             }
626         }
627     }
628 
629     //--------------------------------------------------------------------------
630     // ICO/Pot share functions
631     //--------------------------------------------------------------------------
632     function ReleaseICO() external
633     {
634         require(miners[msg.sender].lastUpdateTime != 0);
635         require(nextPotDistributionTime <= block.timestamp);
636         require(honeyPotAmount > 0);
637         require(globalICOPerCycle[cycleCount] > 0);
638 
639         nextPotDistributionTime = block.timestamp + 86400;
640 
641         honeyPotPerCycle[cycleCount] = honeyPotAmount / 10; // 10% of the pot
642 
643         honeyPotAmount -= honeyPotAmount / 10;
644 
645         honeyPotPerCycle.push(0);
646         globalICOPerCycle.push(0);
647         cycleCount = cycleCount + 1;
648 
649         MinerData storage jakpotWinner = miners[msg.sender];
650         jakpotWinner.unclaimedPot += jackPot;
651         jackPot = 0;
652     }
653 
654     function FundICO(uint amount) external
655     {
656         require(miners[msg.sender].lastUpdateTime != 0);
657         require(amount > 0);
658 
659         MinerData storage m = miners[msg.sender];
660 
661         UpdateMoney();
662 
663         require(m.money >= amount);
664 
665         m.money = (m.money).sub(amount);
666 
667         globalICOPerCycle[cycleCount] = globalICOPerCycle[cycleCount].add(uint(amount));
668         minerICOPerCycle[msg.sender][cycleCount] = minerICOPerCycle[msg.sender][cycleCount].add(uint(amount));
669     }
670 
671     function WithdrawICOEarnings() external
672     {
673         MinerData storage m = miners[msg.sender];
674 
675         require(miners[msg.sender].lastUpdateTime != 0);
676         require(miners[msg.sender].lastPotClaimIndex < cycleCount);
677 
678         uint256 i = m.lastPotClaimIndex;
679         uint256 limit = cycleCount;
680 
681         if((limit - i) > 30) // more than 30 iterations(days) afk
682             limit = i + 30;
683 
684         m.lastPotClaimIndex = limit;
685         for(; i < cycleCount; ++i)
686         {
687             if(minerICOPerCycle[msg.sender][i] > 0)
688                 m.unclaimedPot += (honeyPotPerCycle[i] * minerICOPerCycle[msg.sender][i]) / globalICOPerCycle[i];
689         }
690     }
691 
692     //--------------------------------------------------------------------------
693     // ETH handler functions
694     //--------------------------------------------------------------------------
695     function BuyHandler(uint amount) private
696     {
697         // add 90% to honeyPot
698         honeyPotAmount += (amount * honeyPotSharePct) / 100;
699         jackPot += amount / 100;
700         devFund += (amount * (100-(honeyPotSharePct+1))) / 100;
701     }
702 
703     function WithdrawPotShare() public
704     {
705         MinerData storage m = miners[msg.sender];
706 
707         require(m.unclaimedPot > 0);
708         require(m.lastUpdateTime != 0);
709 
710         uint256 amntToSend = m.unclaimedPot;
711         m.unclaimedPot = 0;
712 
713         if(msg.sender.send(amntToSend))
714         {
715             m.unclaimedPot = 0;
716         }
717     }
718 
719     function WithdrawDevFunds() public
720     {
721         require(msg.sender == owner);
722 
723         if(owner.send(devFund))
724         {
725             devFund = 0;
726         }
727     }
728 
729     // fallback payment to pot
730     function() public payable {
731          devFund += msg.value;
732     }
733 }