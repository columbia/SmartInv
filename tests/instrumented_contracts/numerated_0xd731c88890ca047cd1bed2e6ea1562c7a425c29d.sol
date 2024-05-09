1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         c = a + b;
6         require(c >= a);
7     }
8 
9     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         require(b <= a);
11         c = a - b;
12     }
13 
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18 }
19 
20 library NumericSequence
21 {
22     using SafeMath for uint256;
23     function sumOfN(uint256 basePrice, uint256 pricePerLevel, uint256 owned, uint256 count) internal pure returns (uint256 price)
24     {
25         require(count > 0);
26         
27         price = 0;
28         price += SafeMath.mul((basePrice + pricePerLevel * owned), count);
29         price += pricePerLevel * (count.mul((count-1))) / 2;
30     }
31 }
32 
33 //-----------------------------------------------------------------------
34 contract RigIdle  {
35     using NumericSequence for uint;
36     using SafeMath for uint;
37 
38     struct MinerData 
39     {
40         uint256[9]   rigs; // rig types and their upgrades
41         uint8[3]     hasUpgrade;
42         uint256      money;
43         uint256      lastUpdateTime;
44         uint256      premamentMineBonusPct;
45         uint256      unclaimedPot;
46         uint256      lastPotClaimIndex;
47     }
48     
49     struct RigData
50     {
51         uint256 basePrice;
52         uint256 baseOutput;
53         uint256 pricePerLevel;
54         uint256 priceInETH;
55         uint256 limit;
56     }
57     
58     struct BoostData
59     {
60         uint256 percentBonus;
61         uint256 priceInWEI;
62     }
63     
64     struct PVPData
65     {
66         uint256[6] troops;
67         uint256    immunityTime;
68         uint256    exhaustTime;
69     }
70     
71     struct TroopData
72     {
73         uint256 attackPower;
74         uint256 defensePower;
75         uint256 priceGold;
76         uint256 priceETH;
77     }
78     
79     uint8 private constant NUMBER_OF_RIG_TYPES = 9;
80     RigData[9]  private rigData;
81     
82     uint8 private constant NUMBER_OF_UPGRADES = 3;
83     BoostData[3] private boostData;
84     
85     uint8 private constant NUMBER_OF_TROOPS = 6;
86     uint8 private constant ATTACKER_START_IDX = 0;
87     uint8 private constant ATTACKER_END_IDX = 3;
88     uint8 private constant DEFENDER_START_IDX = 3;
89     uint8 private constant DEFENDER_END_IDX = 6;
90     TroopData[6] private troopData;
91 
92     // honey pot variables
93     uint256 private honeyPotAmount;
94     uint256 private honeyPotSharePct; // 90%
95     uint256 private jackPot;
96     uint256 private devFund;
97     uint256 private nextPotDistributionTime;
98     mapping(address => mapping(uint256 => uint256)) private minerICOPerCycle;
99     uint256[] private honeyPotPerCycle;
100     uint256[] private globalICOPerCycle;
101     uint256 private cycleCount;
102     
103     //booster info
104     uint256 private constant NUMBER_OF_BOOSTERS = 5;
105     uint256 private boosterIndex;
106     uint256 private nextBoosterPrice;
107     address[5] private boosterHolders;
108     
109     mapping(address => MinerData) private miners;
110     mapping(address => PVPData)   private pvpMap;
111     mapping(uint256 => address)   private indexes;
112     uint256 private topindex;
113     
114     address private owner;
115     
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     function RigIdle() public {
120         owner = msg.sender;
121         
122         //                   price,           prod.     upgrade,        priceETH, limit
123         rigData[0] = RigData(128,             1,        64,              0,          64);
124         rigData[1] = RigData(1024,            64,       512,             0,          64);
125         rigData[2] = RigData(204800,          1024,     102400,          0,          128);
126         rigData[3] = RigData(25600000,        8192,     12800000,        0,          128);
127         rigData[4] = RigData(30000000000,     65536,    30000000000,     0.01 ether, 256);
128         rigData[5] = RigData(30000000000,     100000,   10000000000,     0,          256);
129         rigData[6] = RigData(300000000000,    500000,   100000000000,    0,          256);
130         rigData[7] = RigData(50000000000000,  3000000,  12500000000000,  0.1 ether,  256);
131         rigData[8] = RigData(100000000000000, 30000000, 50000000000000,  0,          256);
132         
133         boostData[0] = BoostData(30,  0.01 ether);
134         boostData[1] = BoostData(50,  0.1 ether);
135         boostData[2] = BoostData(100, 1 ether);
136         
137         topindex = 0;
138         honeyPotAmount = 0;
139         devFund = 0;
140         jackPot = 0;
141         nextPotDistributionTime = block.timestamp;
142         honeyPotSharePct = 90;
143         
144         // has to be set to a value
145         boosterHolders[0] = owner;
146         boosterHolders[1] = owner;
147         boosterHolders[2] = owner;
148         boosterHolders[3] = owner;
149         boosterHolders[4] = owner;
150         
151         boosterIndex = 0;
152         nextBoosterPrice = 0.1 ether;
153         
154         //pvp
155         troopData[0] = TroopData(10,     0,      100000,   0);
156         troopData[1] = TroopData(1000,   0,      80000000, 0);
157         troopData[2] = TroopData(100000, 0,      0,        0.01 ether);
158         troopData[3] = TroopData(0,      15,     100000,   0);
159         troopData[4] = TroopData(0,      1500,   80000000, 0);
160         troopData[5] = TroopData(0,      150000, 0,        0.01 ether);
161         
162         honeyPotPerCycle.push(0);
163         globalICOPerCycle.push(1);
164         cycleCount = 0;
165     }
166     
167     //--------------------------------------------------------------------------
168     // Data access functions
169     //--------------------------------------------------------------------------
170     function GetMinerData(address minerAddr) public constant returns 
171         (uint256 money, uint256 lastupdate, uint256 prodPerSec, 
172          uint256[9] rigs, uint[3] upgrades, uint256 unclaimedPot, bool hasBooster, uint256 unconfirmedMoney)
173     {
174         uint8 i = 0;
175         
176         money = miners[minerAddr].money;
177         lastupdate = miners[minerAddr].lastUpdateTime;
178         prodPerSec = GetProductionPerSecond(minerAddr);
179         
180         for(i = 0; i < NUMBER_OF_RIG_TYPES; ++i)
181         {
182             rigs[i] = miners[minerAddr].rigs[i];
183         }
184         
185         for(i = 0; i < NUMBER_OF_UPGRADES; ++i)
186         {
187             upgrades[i] = miners[minerAddr].hasUpgrade[i];
188         }
189         
190         unclaimedPot = miners[minerAddr].unclaimedPot;
191         hasBooster = HasBooster(minerAddr);
192         
193         unconfirmedMoney = money + (prodPerSec * (now - lastupdate));
194     }
195     
196     function GetTotalMinerCount() public constant returns (uint256 count)
197     {
198         count = topindex;
199     }
200     
201     function GetMinerAt(uint256 idx) public constant returns (address minerAddr)
202     {
203         require(idx < topindex);
204         minerAddr = indexes[idx];
205     }
206     
207     function GetPotInfo() public constant returns (uint256 _honeyPotAmount, uint256 _devFunds, uint256 _jackPot, uint256 _nextDistributionTime)
208     {
209         _honeyPotAmount = honeyPotAmount;
210         _devFunds = devFund;
211         _jackPot = jackPot;
212         _nextDistributionTime = nextPotDistributionTime;
213     }
214     
215     function GetProductionPerSecond(address minerAddr) public constant returns (uint256 personalProduction)
216     {
217         MinerData storage m = miners[minerAddr];
218         
219         personalProduction = 0;
220         uint256 productionSpeed = 100 + m.premamentMineBonusPct;
221         
222         if(HasBooster(minerAddr)) // 500% bonus
223             productionSpeed += 500;
224         
225         for(uint8 j = 0; j < NUMBER_OF_RIG_TYPES; ++j)
226         {
227             personalProduction += m.rigs[j] * rigData[j].baseOutput;
228         }
229         
230         personalProduction = personalProduction * productionSpeed / 100;
231     }
232     
233     function GetGlobalProduction() public constant returns (uint256 globalMoney, uint256 globalHashRate)
234     {
235         globalMoney = 0;
236         globalHashRate = 0;
237         uint i = 0;
238         for(i = 0; i < topindex; ++i)
239         {
240             MinerData storage m = miners[indexes[i]];
241             globalMoney += m.money;
242             globalHashRate += GetProductionPerSecond(indexes[i]);
243         }
244     }
245     
246     function GetBoosterData() public constant returns (address[5] _boosterHolders, uint256 currentPrice, uint256 currentIndex)
247     {
248         for(uint i = 0; i < NUMBER_OF_BOOSTERS; ++i)
249         {
250             _boosterHolders[i] = boosterHolders[i];
251         }
252         currentPrice = nextBoosterPrice;
253         currentIndex = boosterIndex;
254     }
255     
256     function HasBooster(address addr) public constant returns (bool hasBoost)
257     { 
258         for(uint i = 0; i < NUMBER_OF_BOOSTERS; ++i)
259         {
260            if(boosterHolders[i] == addr)
261             return true;
262         }
263         return false;
264     }
265     
266     function GetPVPData(address addr) public constant returns (uint256 attackpower, uint256 defensepower, uint256 immunityTime, uint256 exhaustTime,
267     uint256[6] troops)
268     {
269         PVPData storage a = pvpMap[addr];
270             
271         immunityTime = a.immunityTime;
272         exhaustTime = a.exhaustTime;
273         
274         attackpower = 0;
275         defensepower = 0;
276         for(uint i = 0; i < NUMBER_OF_TROOPS; ++i)
277         {
278             attackpower  += a.troops[i] * troopData[i].attackPower;
279             defensepower += a.troops[i] * troopData[i].defensePower;
280             
281             troops[i] = a.troops[i];
282         }
283     }
284     
285     function GetCurrentICOCycle() public constant returns (uint256)
286     {
287         return cycleCount;
288     }
289     
290     function GetICOData(uint256 idx) public constant returns (uint256 ICOFund, uint256 ICOPot)
291     {
292         require(idx <= cycleCount);
293         ICOFund = globalICOPerCycle[idx];
294         if(idx < cycleCount)
295         {
296             ICOPot = honeyPotPerCycle[idx];
297         } else
298         {
299             ICOPot =  honeyPotAmount / 5; // actual day estimate
300         }
301     }
302     
303     function GetMinerICOData(address miner, uint256 idx) public constant returns (uint256 ICOFund, uint256 ICOShare, uint256 lastClaimIndex)
304     {
305         require(idx <= cycleCount);
306         ICOFund = minerICOPerCycle[miner][idx];
307         if(idx < cycleCount)
308         {
309             ICOShare = (honeyPotPerCycle[idx] * minerICOPerCycle[miner][idx]) / globalICOPerCycle[idx];
310         } else 
311         {
312             ICOShare = (honeyPotAmount / 5) * minerICOPerCycle[miner][idx] / globalICOPerCycle[idx];
313         }
314         lastClaimIndex = miners[miner].lastPotClaimIndex;
315     }
316     
317     function GetMinerUnclaimedICOShare(address miner) public constant returns (uint256 unclaimedPot)
318     {
319         MinerData storage m = miners[miner];
320         
321         require(m.lastUpdateTime != 0);
322         require(m.lastPotClaimIndex < cycleCount);
323         
324         uint256 i = m.lastPotClaimIndex;
325         uint256 limit = cycleCount;
326         
327         if((limit - i) > 30) // more than 30 iterations(days) afk
328             limit = i + 30;
329         
330         unclaimedPot = 0;
331         for(; i < cycleCount; ++i)
332         {
333             if(minerICOPerCycle[msg.sender][i] > 0)
334                 unclaimedPot += (honeyPotPerCycle[i] * minerICOPerCycle[miner][i]) / globalICOPerCycle[i];
335         }
336     }
337     
338     // -------------------------------------------------------------------------
339     // RigWars game handler functions
340     // -------------------------------------------------------------------------
341     function StartNewMiner() external
342     {
343         require(miners[msg.sender].lastUpdateTime == 0);
344         
345         miners[msg.sender].lastUpdateTime = block.timestamp;
346         miners[msg.sender].money = 0;
347         miners[msg.sender].rigs[0] = 1;
348         miners[msg.sender].unclaimedPot = 0;
349         miners[msg.sender].lastPotClaimIndex = cycleCount;
350         
351         pvpMap[msg.sender].immunityTime = block.timestamp + 28800;
352         pvpMap[msg.sender].exhaustTime  = block.timestamp;
353         
354         indexes[topindex] = msg.sender;
355         ++topindex;
356     }
357     
358     function UpgradeRig(uint8 rigIdx, uint16 count) external
359     {
360         require(rigIdx < NUMBER_OF_RIG_TYPES);
361         require(count > 0);
362         require(count <= 256);
363         
364         MinerData storage m = miners[msg.sender];
365         
366         require(rigData[rigIdx].limit >= (m.rigs[rigIdx] + count));
367         
368         UpdateMoney();
369      
370         // the base of geometrical sequence
371         uint256 price = NumericSequence.sumOfN(rigData[rigIdx].basePrice, rigData[rigIdx].pricePerLevel, m.rigs[rigIdx], count); 
372        
373         require(m.money >= price);
374         
375         m.rigs[rigIdx] = m.rigs[rigIdx] + count;
376         
377         if(m.rigs[rigIdx] > rigData[rigIdx].limit)
378             m.rigs[rigIdx] = rigData[rigIdx].limit;
379         
380         m.money -= price;
381     }
382     
383     function UpgradeRigETH(uint8 rigIdx, uint256 count) external payable
384     {
385         require(rigIdx < NUMBER_OF_RIG_TYPES);
386         require(count > 0);
387         require(count <= 256);
388         require(rigData[rigIdx].priceInETH > 0);
389         
390         MinerData storage m = miners[msg.sender];
391         
392         require(rigData[rigIdx].limit >= (m.rigs[rigIdx] + count));
393       
394         uint256 price = (rigData[rigIdx].priceInETH).mul(count); 
395        
396         require(msg.value >= price);
397         
398         BuyHandler(msg.value);
399         
400         UpdateMoney();
401         
402         m.rigs[rigIdx] = m.rigs[rigIdx] + count;
403         
404         if(m.rigs[rigIdx] > rigData[rigIdx].limit)
405             m.rigs[rigIdx] = rigData[rigIdx].limit;
406     }
407     
408     function UpdateMoney() private
409     {
410         require(miners[msg.sender].lastUpdateTime != 0);
411         require(block.timestamp >= miners[msg.sender].lastUpdateTime);
412         
413         MinerData storage m = miners[msg.sender];
414         uint256 diff = block.timestamp - m.lastUpdateTime;
415         uint256 revenue = GetProductionPerSecond(msg.sender);
416    
417         m.lastUpdateTime = block.timestamp;
418         if(revenue > 0)
419         {
420             revenue *= diff;
421             
422             m.money += revenue;
423         }
424     }
425     
426     function UpdateMoneyAt(address addr) private
427     {
428         require(miners[addr].lastUpdateTime != 0);
429         require(block.timestamp >= miners[addr].lastUpdateTime);
430         
431         MinerData storage m = miners[addr];
432         uint256 diff = block.timestamp - m.lastUpdateTime;
433         uint256 revenue = GetProductionPerSecond(addr);
434    
435         m.lastUpdateTime = block.timestamp;
436         if(revenue > 0)
437         {
438             revenue *= diff;
439             
440             m.money += revenue;
441         }
442     }
443     
444     function BuyUpgrade(uint256 idx) external payable
445     {
446         require(idx < NUMBER_OF_UPGRADES);
447         require(msg.value >= boostData[idx].priceInWEI);
448         require(miners[msg.sender].hasUpgrade[idx] == 0);
449         require(miners[msg.sender].lastUpdateTime != 0);
450         
451         BuyHandler(msg.value);
452         
453         UpdateMoney();
454         
455         miners[msg.sender].hasUpgrade[idx] = 1;
456         miners[msg.sender].premamentMineBonusPct +=  boostData[idx].percentBonus;
457     }
458     
459     //--------------------------------------------------------------------------
460     // BOOSTER handlers
461     //--------------------------------------------------------------------------
462     function BuyBooster() external payable 
463     {
464         require(msg.value >= nextBoosterPrice);
465         require(miners[msg.sender].lastUpdateTime != 0);
466         
467         for(uint i = 0; i < NUMBER_OF_BOOSTERS; ++i)
468             if(boosterHolders[i] == msg.sender)
469                 revert();
470                 
471         address beneficiary = boosterHolders[boosterIndex];
472         
473         MinerData storage m = miners[beneficiary];
474         
475         // 20% interest after 5 buys
476         m.unclaimedPot += (msg.value * 9403) / 10000;
477         
478         // distribute the rest
479         honeyPotAmount += (msg.value * 597) / 20000;
480         devFund += (msg.value * 597) / 20000;
481         
482         // increase price by 5%
483         nextBoosterPrice += nextBoosterPrice / 20;
484         
485         UpdateMoney();
486         UpdateMoneyAt(beneficiary);
487         
488         // transfer ownership    
489         boosterHolders[boosterIndex] = msg.sender;
490         
491         // increase booster index
492         boosterIndex += 1;
493         if(boosterIndex >= 5)
494             boosterIndex = 0;
495     }
496     
497     //--------------------------------------------------------------------------
498     // PVP handler
499     //--------------------------------------------------------------------------
500     // 0 for attacker 1 for defender
501     function BuyTroop(uint256 idx, uint256 count) external payable
502     {
503         require(idx < NUMBER_OF_TROOPS);
504         require(count > 0);
505         require(count <= 1000);
506         
507         PVPData storage pvp = pvpMap[msg.sender];
508         MinerData storage m = miners[msg.sender];
509         
510         uint256 owned = pvp.troops[idx];
511         
512         uint256 priceGold = NumericSequence.sumOfN(troopData[idx].priceGold, troopData[idx].priceGold, owned, count); 
513         uint256 priceETH = (troopData[idx].priceETH).mul(count);
514         
515         UpdateMoney();
516         
517         require(m.money >= priceGold);
518         require(msg.value >= priceETH);
519         
520         if(priceGold > 0)
521             m.money -= priceGold;
522          
523         if(msg.value > 0)
524             BuyHandler(msg.value);
525         
526         pvp.troops[idx] += count;
527     }
528     
529     function Attack(address defenderAddr) external
530     {
531         require(msg.sender != defenderAddr);
532         require(miners[msg.sender].lastUpdateTime != 0);
533         require(miners[defenderAddr].lastUpdateTime != 0);
534         
535         PVPData storage attacker = pvpMap[msg.sender];
536         PVPData storage defender = pvpMap[defenderAddr];
537         uint i = 0;
538         uint256 count = 0;
539         
540         require(block.timestamp > attacker.exhaustTime);
541         require(block.timestamp > defender.immunityTime);
542         
543         // the aggressor loses immunity
544         if(attacker.immunityTime > block.timestamp)
545             attacker.immunityTime = block.timestamp - 1;
546             
547         attacker.exhaustTime = block.timestamp + 7200;
548         
549         uint256 attackpower = 0;
550         uint256 defensepower = 0;
551         for(i = 0; i < ATTACKER_END_IDX; ++i)
552         {
553             attackpower  += attacker.troops[i] * troopData[i].attackPower;
554             defensepower += defender.troops[i + DEFENDER_START_IDX] * troopData[i + DEFENDER_START_IDX].defensePower;
555         }
556         
557         if(attackpower > defensepower)
558         {
559             if(defender.immunityTime < block.timestamp + 14400)
560                 defender.immunityTime = block.timestamp + 14400;
561             
562             UpdateMoneyAt(defenderAddr);
563             
564             MinerData storage m = miners[defenderAddr];
565             MinerData storage m2 = miners[msg.sender];
566             uint256 moneyStolen = m.money / 2;
567          
568             for(i = DEFENDER_START_IDX; i < DEFENDER_END_IDX; ++i)
569             {
570                 defender.troops[i] = 0;
571             }
572             
573             for(i = ATTACKER_START_IDX; i < ATTACKER_END_IDX; ++i)
574             {
575                 if(troopData[i].attackPower > 0)
576                 {
577                     count = attacker.troops[i];
578                     
579                     // if the troops overpower the total defense power only a fraction is lost
580                     if((count * troopData[i].attackPower) > defensepower)
581                         count = defensepower / troopData[i].attackPower;
582                         
583                     attacker.troops[i] -= count;
584                     defensepower -= count * troopData[i].attackPower;
585                 }
586             }
587             
588             m.money -= moneyStolen;
589             m2.money += moneyStolen;
590         } else
591         {
592             for(i = ATTACKER_START_IDX; i < ATTACKER_END_IDX; ++i)
593             {
594                 attacker.troops[i] = 0;
595             }
596             
597             for(i = DEFENDER_START_IDX; i < DEFENDER_END_IDX; ++i)
598             {
599                 if(troopData[i].defensePower > 0)
600                 {
601                     count = defender.troops[i];
602                     
603                     // if the troops overpower the total defense power only a fraction is lost
604                     if((count * troopData[i].defensePower) > attackpower)
605                         count = attackpower / troopData[i].defensePower;
606                         
607                     defender.troops[i] -= count;
608                     attackpower -= count * troopData[i].defensePower;
609                 }
610             }
611         }
612     }
613     
614     //--------------------------------------------------------------------------
615     // ICO/Pot share functions
616     //--------------------------------------------------------------------------
617     function ReleaseICO() external
618     {
619         require(miners[msg.sender].lastUpdateTime != 0);
620         require(nextPotDistributionTime <= block.timestamp);
621         require(honeyPotAmount > 0);
622         require(globalICOPerCycle[cycleCount] > 0);
623 
624         nextPotDistributionTime = block.timestamp + 86400;
625 
626         honeyPotPerCycle[cycleCount] = honeyPotAmount / 5; // 20% of the pot
627         
628         honeyPotAmount -= honeyPotAmount / 5;
629 
630         honeyPotPerCycle.push(0);
631         globalICOPerCycle.push(0);
632         cycleCount = cycleCount + 1;
633 
634         MinerData storage jakpotWinner = miners[msg.sender];
635         jakpotWinner.unclaimedPot += jackPot;
636         jackPot = 0;
637     }
638     
639     function FundICO(uint amount) external
640     {
641         require(miners[msg.sender].lastUpdateTime != 0);
642         require(amount > 0);
643         
644         MinerData storage m = miners[msg.sender];
645         
646         UpdateMoney();
647         
648         require(m.money >= amount);
649         
650         m.money = (m.money).sub(amount);
651         
652         globalICOPerCycle[cycleCount] = globalICOPerCycle[cycleCount].add(uint(amount));
653         minerICOPerCycle[msg.sender][cycleCount] = minerICOPerCycle[msg.sender][cycleCount].add(uint(amount));
654     }
655     
656     function WithdrawICOEarnings() external
657     {
658         MinerData storage m = miners[msg.sender];
659         
660         require(miners[msg.sender].lastUpdateTime != 0);
661         require(miners[msg.sender].lastPotClaimIndex < cycleCount);
662         
663         uint256 i = m.lastPotClaimIndex;
664         uint256 limit = cycleCount;
665         
666         if((limit - i) > 30) // more than 30 iterations(days) afk
667             limit = i + 30;
668         
669         m.lastPotClaimIndex = limit;
670         for(; i < cycleCount; ++i)
671         {
672             if(minerICOPerCycle[msg.sender][i] > 0)
673                 m.unclaimedPot += (honeyPotPerCycle[i] * minerICOPerCycle[msg.sender][i]) / globalICOPerCycle[i];
674         }
675     }
676     
677     //--------------------------------------------------------------------------
678     // ETH handler functions
679     //--------------------------------------------------------------------------
680     function BuyHandler(uint amount) private
681     {
682         // add 90% to honeyPot
683         honeyPotAmount += (amount * honeyPotSharePct) / 100;
684         jackPot += amount / 100;
685         devFund += (amount * (100-(honeyPotSharePct+1))) / 100;
686     }
687     
688     function WithdrawPotShare() public
689     {
690         MinerData storage m = miners[msg.sender];
691         
692         require(m.unclaimedPot > 0);
693         require(m.lastUpdateTime != 0);
694         
695         uint256 amntToSend = m.unclaimedPot;
696         m.unclaimedPot = 0;
697         
698         if(msg.sender.send(amntToSend))
699         {
700             m.unclaimedPot = 0;
701         }
702     }
703     
704     function WithdrawDevFunds() public
705     {
706         require(msg.sender == owner);
707 
708         if(owner.send(devFund))
709         {
710             devFund = 0;
711         }
712     }
713     
714     // fallback payment to pot
715     function() public payable {
716          devFund += msg.value;
717     }
718 }