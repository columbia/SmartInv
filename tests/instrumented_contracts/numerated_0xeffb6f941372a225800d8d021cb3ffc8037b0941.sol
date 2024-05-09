1 pragma solidity ^0.4.18;
2 
3 library NumericSequence
4 {
5     function sumOfN(uint basePrice, uint pricePerLevel, uint owned, uint count) internal pure returns (uint price)
6     {
7         require(count > 0);
8         
9         price = 0;
10         price += (basePrice + pricePerLevel * owned) * count;
11         price += pricePerLevel * ((count-1) * count) / 2;
12     }
13 }
14 
15 contract ERC20 {
16     function totalSupply() public constant returns (uint);
17     function balanceOf(address tokenOwner) public constant returns (uint balance);
18     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
19     function transfer(address to, uint tokens) public returns (bool success);
20     function approve(address spender, uint tokens) public returns (bool success);
21     function transferFrom(address from, address to, uint tokens) public returns (bool success);
22 
23     event Transfer(address indexed from, address indexed to, uint tokens);
24     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
25 }
26 
27 //-----------------------------------------------------------------------
28 contract RigIdle is ERC20  {
29     using NumericSequence for uint;
30 
31     struct MinerData 
32     {
33         uint[9]   rigs; // rig types and their upgrades
34         uint8[3]  hasUpgrade;
35         uint      money;
36         uint      lastUpdateTime;
37         uint      premamentMineBonusPct;
38         uint      unclaimedPot;
39         uint      lastPotShare;
40     }
41     
42     struct RigData
43     {
44         uint basePrice;
45         uint baseOutput;
46         uint pricePerLevel;
47         uint priceInETH;
48         uint limit;
49     }
50     
51     struct BoostData
52     {
53         uint percentBonus;
54         uint priceInWEI;
55     }
56     
57     struct PVPData
58     {
59         uint[6] troops;
60         uint immunityTime;
61         uint exhaustTime;
62     }
63     
64     struct TroopData
65     {
66         uint attackPower;
67         uint defensePower;
68         uint priceGold;
69         uint priceETH;
70     }
71     
72     uint8 private constant NUMBER_OF_RIG_TYPES = 9;
73     RigData[9]  private rigData;
74     
75     uint8 private constant NUMBER_OF_UPGRADES = 3;
76     BoostData[3] private boostData;
77     
78     uint8 private constant NUMBER_OF_TROOPS = 6;
79     uint8 private constant ATTACKER_START_IDX = 0;
80     uint8 private constant ATTACKER_END_IDX = 3;
81     uint8 private constant DEFENDER_START_IDX = 3;
82     uint8 private constant DEFENDER_END_IDX = 6;
83     TroopData[6] private troopData;
84 
85     // honey pot variables
86     uint private honeyPotAmount;
87     uint private honeyPotSharePct;
88     uint private jackPot;
89     uint private devFund;
90     uint private nextPotDistributionTime;
91     
92     //booster info
93     uint public constant NUMBER_OF_BOOSTERS = 5;
94     uint       boosterIndex;
95     uint       nextBoosterPrice;
96     address[5] boosterHolders;
97     
98     mapping(address => MinerData) private miners;
99     mapping(address => PVPData)   private pvpMap;
100     mapping(uint => address)  private indexes;
101     uint private topindex;
102     
103     address public owner;
104     
105     // ERC20 functionality
106     mapping(address => mapping(address => uint256)) private allowed;
107     string public constant name  = "RigWarsIdle";
108     string public constant symbol = "RIG";
109     uint8 public constant decimals = 8;
110     uint256 private estimatedSupply;
111     
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     function RigIdle() public {
116         owner = msg.sender;
117         
118         //                   price,           prod.     upgrade,        priceETH, limit
119         rigData[0] = RigData(128,             1,        64,              0,          64);
120         rigData[1] = RigData(1024,            64,       512,             0,          64);
121         rigData[2] = RigData(204800,          1024,     102400,          0,          128);
122         rigData[3] = RigData(25600000,        8192,     12800000,        0,          128);
123         rigData[4] = RigData(30000000000,     65536,    30000000000,     0.01 ether, 256);
124         rigData[5] = RigData(30000000000,     100000,   10000000000,     0,          256);
125         rigData[6] = RigData(300000000000,    500000,   100000000000,    0,          256);
126         rigData[7] = RigData(50000000000000,  3000000,  12500000000000,  0.1 ether,  256);
127         rigData[8] = RigData(100000000000000, 30000000, 50000000000000,  0,          256);
128         
129         boostData[0] = BoostData(30,  0.01 ether);
130         boostData[1] = BoostData(50,  0.1 ether);
131         boostData[2] = BoostData(100, 1 ether);
132         
133         topindex = 0;
134         honeyPotAmount = 0;
135         devFund = 0;
136         jackPot = 0;
137         nextPotDistributionTime = block.timestamp;
138         // default 90% honeypot, 8% for DevFund + transaction fees, 2% safe deposit
139         honeyPotSharePct = 90;
140         
141         // has to be set to a value
142         boosterHolders[0] = owner;
143         boosterHolders[1] = owner;
144         boosterHolders[2] = owner;
145         boosterHolders[3] = owner;
146         boosterHolders[4] = owner;
147         
148         boosterIndex = 0;
149         nextBoosterPrice = 0.1 ether;
150         
151         //pvp
152         troopData[0] = TroopData(10,     0,      100000,   0);
153         troopData[1] = TroopData(1000,   0,      80000000, 0);
154         troopData[2] = TroopData(100000, 0,      0,        0.01 ether);
155         troopData[3] = TroopData(0,      15,     100000,   0);
156         troopData[4] = TroopData(0,      1500,   80000000, 0);
157         troopData[5] = TroopData(0,      150000, 0,        0.01 ether);
158         
159         estimatedSupply = 80000000;
160     }
161     
162     //--------------------------------------------------------------------------
163     // Data access functions
164     //--------------------------------------------------------------------------
165     function GetNumberOfRigs() public pure returns (uint8 rigNum)
166     {
167         rigNum = NUMBER_OF_RIG_TYPES;
168     }
169     
170     function GetRigData(uint8 rigIdx) public constant returns (uint price, uint production, uint upgrade, uint limit, uint priceETH)
171     {
172         require(rigIdx < NUMBER_OF_RIG_TYPES);
173         price =      rigData[rigIdx].basePrice;
174         production = rigData[rigIdx].baseOutput;
175         upgrade =    rigData[rigIdx].pricePerLevel;
176         limit =      rigData[rigIdx].limit;
177         priceETH =   rigData[rigIdx].priceInETH;
178     }
179     
180     function GetMinerData(address minerAddr) public constant returns 
181         (uint money, uint lastupdate, uint prodPerSec, 
182          uint[9] rigs, uint[3] upgrades, uint unclaimedPot, uint lastPot, bool hasBooster, uint unconfirmedMoney)
183     {
184         uint8 i = 0;
185         
186         money = miners[minerAddr].money;
187         lastupdate = miners[minerAddr].lastUpdateTime;
188         prodPerSec = GetProductionPerSecond(minerAddr);
189         
190         for(i = 0; i < NUMBER_OF_RIG_TYPES; ++i)
191         {
192             rigs[i] = miners[minerAddr].rigs[i];
193         }
194         
195         for(i = 0; i < NUMBER_OF_UPGRADES; ++i)
196         {
197             upgrades[i] = miners[minerAddr].hasUpgrade[i];
198         }
199         
200         unclaimedPot = miners[minerAddr].unclaimedPot;
201         lastPot = miners[minerAddr].lastPotShare;
202         hasBooster = HasBooster(minerAddr);
203         
204         unconfirmedMoney = money + (prodPerSec * (now - lastupdate));
205     }
206     
207     function GetTotalMinerCount() public constant returns (uint count)
208     {
209         count = topindex;
210     }
211     
212     function GetMinerAt(uint idx) public constant returns (address minerAddr)
213     {
214         require(idx < topindex);
215         minerAddr = indexes[idx];
216     }
217     
218     function GetPriceOfRigs(uint rigIdx, uint count, uint owned) public constant returns (uint price)
219     {
220         require(rigIdx < NUMBER_OF_RIG_TYPES);
221         require(count > 0);
222         price = NumericSequence.sumOfN(rigData[rigIdx].basePrice, rigData[rigIdx].pricePerLevel, owned, count); 
223     }
224     
225     function GetPotInfo() public constant returns (uint _honeyPotAmount, uint _devFunds, uint _jackPot, uint _nextDistributionTime)
226     {
227         _honeyPotAmount = honeyPotAmount;
228         _devFunds = devFund;
229         _jackPot = jackPot;
230         _nextDistributionTime = nextPotDistributionTime;
231     }
232     
233     function GetProductionPerSecond(address minerAddr) public constant returns (uint personalProduction)
234     {
235         MinerData storage m = miners[minerAddr];
236         
237         personalProduction = 0;
238         uint productionSpeed = 100 + m.premamentMineBonusPct;
239         
240         if(HasBooster(minerAddr)) // 500% bonus
241             productionSpeed += 500;
242         
243         for(uint8 j = 0; j < NUMBER_OF_RIG_TYPES; ++j)
244         {
245             personalProduction += m.rigs[j] * rigData[j].baseOutput;
246         }
247         
248         personalProduction = personalProduction * productionSpeed / 100;
249     }
250     
251     function GetGlobalProduction() public constant returns (uint globalMoney, uint globalHashRate)
252     {
253         globalMoney = 0;
254         globalHashRate = 0;
255         uint i = 0;
256         for(i = 0; i < topindex; ++i)
257         {
258             MinerData storage m = miners[indexes[i]];
259             globalMoney += m.money;
260             globalHashRate += GetProductionPerSecond(indexes[i]);
261         }
262     }
263     
264     function GetBoosterData() public constant returns (address[5] _boosterHolders, uint currentPrice, uint currentIndex)
265     {
266         for(uint i = 0; i < NUMBER_OF_BOOSTERS; ++i)
267         {
268             _boosterHolders[i] = boosterHolders[i];
269         }
270         currentPrice = nextBoosterPrice;
271         currentIndex = boosterIndex;
272     }
273     
274     function HasBooster(address addr) public constant returns (bool hasBoost)
275     { 
276         for(uint i = 0; i < NUMBER_OF_BOOSTERS; ++i)
277         {
278            if(boosterHolders[i] == addr)
279             return true;
280         }
281         return false;
282     }
283     
284     function GetPVPData(address addr) public constant returns (uint attackpower, uint defensepower, uint immunityTime, uint exhaustTime,
285     uint[6] troops)
286     {
287         PVPData storage a = pvpMap[addr];
288             
289         immunityTime = a.immunityTime;
290         exhaustTime = a.exhaustTime;
291         
292         attackpower = 0;
293         defensepower = 0;
294         for(uint i = 0; i < NUMBER_OF_TROOPS; ++i)
295         {
296             attackpower  += a.troops[i] * troopData[i].attackPower;
297             defensepower += a.troops[i] * troopData[i].defensePower;
298             
299             troops[i] = a.troops[i];
300         }
301     }
302     
303     function GetPriceOfTroops(uint idx, uint count, uint owned) public constant returns (uint price, uint priceETH)
304     {
305         require(idx < NUMBER_OF_TROOPS);
306         require(count > 0);
307         price = NumericSequence.sumOfN(troopData[idx].priceGold, troopData[idx].priceGold, owned, count);
308         priceETH = troopData[idx].priceETH * count;
309     }
310     
311     // -------------------------------------------------------------------------
312     // RigWars game handler functions
313     // -------------------------------------------------------------------------
314     function StartNewMiner() public
315     {
316         require(miners[msg.sender].lastUpdateTime == 0);
317         
318         miners[msg.sender].lastUpdateTime = block.timestamp;
319         miners[msg.sender].money = 0;
320         miners[msg.sender].rigs[0] = 1;
321         miners[msg.sender].unclaimedPot = 0;
322         miners[msg.sender].lastPotShare = 0;
323         
324         pvpMap[msg.sender].troops[0] = 0;
325         pvpMap[msg.sender].troops[1] = 0;
326         pvpMap[msg.sender].troops[2] = 0;
327         pvpMap[msg.sender].troops[3] = 0;
328         pvpMap[msg.sender].troops[4] = 0;
329         pvpMap[msg.sender].troops[5] = 0;
330         pvpMap[msg.sender].immunityTime = block.timestamp + 28800;
331         pvpMap[msg.sender].exhaustTime  = block.timestamp;
332         
333         indexes[topindex] = msg.sender;
334         ++topindex;
335     }
336     
337     function UpgradeRig(uint8 rigIdx, uint count) public
338     {
339         require(rigIdx < NUMBER_OF_RIG_TYPES);
340         require(count > 0);
341         
342         MinerData storage m = miners[msg.sender];
343         
344         require(rigData[rigIdx].limit >= (m.rigs[rigIdx] + count));
345         
346         UpdateMoney();
347      
348         // the base of geometrical sequence
349         uint price = NumericSequence.sumOfN(rigData[rigIdx].basePrice, rigData[rigIdx].pricePerLevel, m.rigs[rigIdx], count); 
350        
351         require(m.money >= price);
352         
353         m.rigs[rigIdx] = m.rigs[rigIdx] + count;
354         m.money -= price;
355     }
356     
357     function UpgradeRigETH(uint8 rigIdx, uint count) public payable
358     {
359         require(rigIdx < NUMBER_OF_RIG_TYPES);
360         require(count > 0);
361         require(rigData[rigIdx].priceInETH > 0);
362         
363         MinerData storage m = miners[msg.sender];
364         
365         require(rigData[rigIdx].limit >= (m.rigs[rigIdx] + count));
366       
367         uint price = rigData[rigIdx].priceInETH * count; 
368        
369         require(msg.value >= price);
370         
371         BuyHandler(msg.value);
372         
373         UpdateMoney();
374         
375         m.rigs[rigIdx] = m.rigs[rigIdx] + count;
376     }
377     
378     function UpdateMoney() public
379     {
380         require(miners[msg.sender].lastUpdateTime != 0);
381         
382         MinerData storage m = miners[msg.sender];
383         uint diff = block.timestamp - m.lastUpdateTime;
384         uint revenue = GetProductionPerSecond(msg.sender);
385    
386         m.lastUpdateTime = block.timestamp;
387         if(revenue > 0)
388         {
389             revenue *= diff;
390             
391             m.money += revenue;
392         }
393     }
394     
395     function UpdateMoneyAt(address addr) internal
396     {
397         require(miners[addr].lastUpdateTime != 0);
398         
399         MinerData storage m = miners[addr];
400         uint diff = block.timestamp - m.lastUpdateTime;
401         uint revenue = GetProductionPerSecond(addr);
402    
403         m.lastUpdateTime = block.timestamp;
404         if(revenue > 0)
405         {
406             revenue *= diff;
407             
408             m.money += revenue;
409         }
410     }
411     
412     function BuyUpgrade(uint idx) public payable
413     {
414         require(idx < NUMBER_OF_UPGRADES);
415         require(msg.value >= boostData[idx].priceInWEI);
416         require(miners[msg.sender].hasUpgrade[idx] == 0);
417         require(miners[msg.sender].lastUpdateTime != 0);
418         
419         BuyHandler(msg.value);
420         
421         UpdateMoney();
422         
423         miners[msg.sender].hasUpgrade[idx] = 1;
424         miners[msg.sender].premamentMineBonusPct +=  boostData[idx].percentBonus;
425     }
426     
427     //--------------------------------------------------------------------------
428     // BOOSTER handlers
429     //--------------------------------------------------------------------------
430     function BuyBooster() public payable 
431     {
432         require(msg.value >= nextBoosterPrice);
433         require(miners[msg.sender].lastUpdateTime != 0);
434         
435         for(uint i = 0; i < NUMBER_OF_BOOSTERS; ++i)
436             if(boosterHolders[i] == msg.sender)
437                 revert();
438                 
439         address beneficiary = boosterHolders[boosterIndex];
440         
441         MinerData storage m = miners[beneficiary];
442         
443         // 95% goes to the owner (21% interest after 5 buys)
444         m.unclaimedPot += nextBoosterPrice * 95 / 100;
445         
446         // 5% to the pot
447         BuyHandler((nextBoosterPrice / 20));
448         
449         // increase price by 5%
450         nextBoosterPrice += nextBoosterPrice / 20;
451         
452         UpdateMoney();
453         UpdateMoneyAt(beneficiary);
454         
455         // transfer ownership    
456         boosterHolders[boosterIndex] = msg.sender;
457         
458         // increase booster index
459         boosterIndex += 1;
460         if(boosterIndex >= 5)
461             boosterIndex = 0;
462     }
463     
464     //--------------------------------------------------------------------------
465     // PVP handler
466     //--------------------------------------------------------------------------
467     // 0 for attacker 1 for defender
468     function BuyTroop(uint idx, uint count) public payable
469     {
470         require(idx < NUMBER_OF_TROOPS);
471         require(count > 0);
472         require(count <= 1000);
473         
474         PVPData storage pvp = pvpMap[msg.sender];
475         MinerData storage m = miners[msg.sender];
476         
477         uint owned = pvp.troops[idx];
478         
479         uint priceGold = NumericSequence.sumOfN(troopData[idx].priceGold, troopData[idx].priceGold, owned, count); 
480         uint priceETH = troopData[idx].priceETH * count;
481         
482         UpdateMoney();
483         
484         require(m.money >= priceGold);
485         require(msg.value >= priceETH);
486         
487         if(priceGold > 0)
488             m.money -= priceGold;
489          
490         if(msg.value > 0)
491             BuyHandler(msg.value);
492         
493         pvp.troops[idx] += count;
494     }
495     
496     function Attack(address defenderAddr) public
497     {
498         require(msg.sender != defenderAddr);
499         require(miners[msg.sender].lastUpdateTime != 0);
500         require(miners[defenderAddr].lastUpdateTime != 0);
501         
502         PVPData storage attacker = pvpMap[msg.sender];
503         PVPData storage defender = pvpMap[defenderAddr];
504         uint i = 0;
505         uint count = 0;
506         
507         require(block.timestamp > attacker.exhaustTime);
508         require(block.timestamp > defender.immunityTime);
509         
510         // the aggressor loses immunity
511         if(attacker.immunityTime > block.timestamp)
512             attacker.immunityTime = block.timestamp - 1;
513             
514         attacker.exhaustTime = block.timestamp + 7200;
515         
516         uint attackpower = 0;
517         uint defensepower = 0;
518         for(i = 0; i < NUMBER_OF_TROOPS; ++i)
519         {
520             attackpower  += attacker.troops[i] * troopData[i].attackPower;
521             defensepower += defender.troops[i] * troopData[i].defensePower;
522         }
523         
524         if(attackpower > defensepower)
525         {
526             if(defender.immunityTime < block.timestamp + 14400)
527                 defender.immunityTime = block.timestamp + 14400;
528             
529             UpdateMoneyAt(defenderAddr);
530             
531             MinerData storage m = miners[defenderAddr];
532             MinerData storage m2 = miners[msg.sender];
533             uint moneyStolen = m.money / 2;
534          
535             for(i = DEFENDER_START_IDX; i < DEFENDER_END_IDX; ++i)
536             {
537                 defender.troops[i] = 0;
538             }
539             
540             for(i = ATTACKER_START_IDX; i < ATTACKER_END_IDX; ++i)
541             {
542                 if(troopData[i].attackPower > 0)
543                 {
544                     count = attacker.troops[i];
545                     
546                     // if the troops overpower the total defense power only a fraction is lost
547                     if((count * troopData[i].attackPower) > defensepower)
548                         count = defensepower / troopData[i].attackPower;
549                         
550                     attacker.troops[i] -= count;
551                     defensepower -= count * troopData[i].attackPower;
552                 }
553             }
554             
555             m.money -= moneyStolen;
556             m2.money += moneyStolen;
557         } else
558         {
559             for(i = ATTACKER_START_IDX; i < ATTACKER_END_IDX; ++i)
560             {
561                 attacker.troops[i] = 0;
562             }
563             
564             for(i = DEFENDER_START_IDX; i < DEFENDER_END_IDX; ++i)
565             {
566                 if(troopData[i].defensePower > 0)
567                 {
568                     count = defender.troops[i];
569                     
570                     // if the troops overpower the total defense power only a fraction is lost
571                     if((count * troopData[i].defensePower) > attackpower)
572                         count = attackpower / troopData[i].defensePower;
573                         
574                     defender.troops[i] -= count;
575                     attackpower -= count * troopData[i].defensePower;
576                 }
577             }
578         }
579     }
580     
581     //--------------------------------------------------------------------------
582     // ETH handler functions
583     //--------------------------------------------------------------------------
584     function BuyHandler(uint amount) public payable
585     {
586         // add 2% to jakcpot
587         // add 90% (default) to honeyPot
588         honeyPotAmount += (amount * honeyPotSharePct) / 100;
589         jackPot += amount / 50;
590         // default 100 - (90+2) = 8%
591         devFund += (amount * (100-(honeyPotSharePct+2))) / 100;
592     }
593     
594     function WithdrawPotShare() public
595     {
596         MinerData storage m = miners[msg.sender];
597         
598         require(m.unclaimedPot > 0);
599         
600         uint amntToSend = m.unclaimedPot;
601         m.unclaimedPot = 0;
602         
603         if(msg.sender.send(amntToSend))
604         {
605             m.unclaimedPot = 0;
606         }
607     }
608     
609     function WithdrawDevFunds(uint amount) public
610     {
611         require(msg.sender == owner);
612         
613         if(amount == 0)
614         {
615             if(owner.send(devFund))
616             {
617                 devFund = 0;
618             }
619         } else
620         {
621             // should never be used! this is only in case of emergency
622             // if some error happens with distribution someone has to access
623             // and distribute the funds manually
624             owner.transfer(amount);
625         }
626     }
627     
628     function SnapshotAndDistributePot() public
629     {
630         require(honeyPotAmount > 0);
631         require(gasleft() >= 1000000);
632         require(nextPotDistributionTime <= block.timestamp);
633         
634         uint globalMoney = 1;
635         uint i = 0;
636         for(i = 0; i < topindex; ++i)
637         {
638             globalMoney += miners[indexes[i]].money;
639         }
640         
641         estimatedSupply = globalMoney;
642         
643         uint remainingPot = honeyPotAmount;
644         
645         // 20% of the total pot
646         uint potFraction = honeyPotAmount / 5;
647                 
648         honeyPotAmount -= potFraction;
649         
650         potFraction /= 10000;
651         
652         for(i = 0; i < topindex; ++i)
653         {
654             // lowest limit of pot share is 0.01%
655             MinerData storage m = miners[indexes[i]];
656             uint share = (m.money * 10000) / globalMoney;
657             if(share > 0)
658             {
659                 uint newPot = potFraction * share;
660                 
661                 if(newPot <= remainingPot)
662                 {
663                     m.unclaimedPot += newPot;
664                     m.lastPotShare = newPot;
665                     remainingPot   -= newPot;
666                 }
667             }
668         }
669         
670         nextPotDistributionTime = block.timestamp + 86400;
671         
672         MinerData storage jakpotWinner = miners[msg.sender];
673         jakpotWinner.unclaimedPot += jackPot;
674         jackPot = 0;
675     }
676     
677     // fallback payment to pot
678     function() public payable {
679     }
680     
681     //--------------------------------------------------------------------------
682     // ERC20 support
683     //--------------------------------------------------------------------------
684     function totalSupply() public constant returns(uint256) {
685         return estimatedSupply;
686     }
687     
688     function balanceOf(address miner) public constant returns(uint256) {
689         return miners[miner].money;
690     }
691     
692      function transfer(address recipient, uint256 amount) public returns (bool) {
693         require(amount <= miners[msg.sender].money);
694         require(miners[recipient].lastUpdateTime != 0);
695         
696         miners[msg.sender].money -= amount * (10**uint(decimals));
697         miners[recipient].money += amount * (10**uint(decimals));
698         
699         emit Transfer(msg.sender, recipient, amount);
700         return true;
701     }
702     
703     function transferFrom(address miner, address recipient, uint256 amount) public returns (bool) {
704         require(amount <= allowed[miner][msg.sender] && amount <= balanceOf(miner));
705         require(miners[recipient].lastUpdateTime != 0);
706         
707         miners[miner].money -= amount * (10**uint(decimals));
708         miners[recipient].money += amount * (10**uint(decimals));
709         allowed[miner][msg.sender] -= amount * (10**uint(decimals));
710         
711         emit Transfer(miner, recipient, amount);
712         return true;
713     }
714     
715     function approve(address approvee, uint256 amount) public returns (bool){
716         allowed[msg.sender][approvee] = amount * (10**uint(decimals));
717         emit Approval(msg.sender, approvee, amount);
718         return true;
719     }
720     
721     function allowance(address miner, address approvee) public constant returns(uint256){
722         return allowed[miner][approvee];
723     }
724 }