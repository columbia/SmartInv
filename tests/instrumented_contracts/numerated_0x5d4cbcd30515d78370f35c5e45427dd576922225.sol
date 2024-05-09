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
20 library GeometricSequence
21 {
22     using SafeMath for uint256;
23     function sumOfNGeom(uint256 basePrice, uint256 owned, uint256 count) internal pure returns (uint256 price)
24     {
25         require(count > 0);
26         
27         uint256 multiplier = 5;
28         
29         uint256 basePower = owned / multiplier;
30         uint256 endPower = (owned + count) / multiplier;
31         
32         price = (basePrice * (2**basePower) * multiplier).mul((2**((endPower-basePower)+1))-1);
33         
34         price = price.sub((basePrice * 2**basePower) * (owned % multiplier));
35         price = price.sub((basePrice * 2**endPower) * (multiplier - ((owned + count) % multiplier)));
36     }
37 }
38 
39 contract ERC20 {
40     function totalSupply() public constant returns (uint);
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 //-----------------------------------------------------------------------
52 contract RigIdle is ERC20 {
53     using GeometricSequence for uint;
54     using SafeMath for uint;
55 
56     struct MinerData 
57     {
58         // rigs and their upgrades
59         mapping(uint256=>uint256)  rigCount;
60         mapping(int256=>uint256)   rigPctBonus;
61         mapping(int256=>uint256)   rigFlatBonus;
62         
63         uint256 money;
64         uint256 lastUpdateTime;
65         uint256 unclaimedPot;
66         uint256 lastPotClaimIndex;
67         uint256 prestigeLevel; 
68         uint256 prestigeBonusPct;
69     }
70   
71     struct BoostData
72     {
73         int256  rigIndex;
74         uint256 flatBonus;
75         uint256 percentBonus;
76         
77         uint256 priceInWEI;
78         uint256 priceIncreasePct;
79         uint256 totalCount;
80         uint256 currentIndex;
81         address[] boostHolders;
82     }
83     
84     struct RigData
85     {
86         uint256 basePrice;
87         uint256 baseOutput;
88         uint256 unlockMultiplier;
89     }
90     
91     struct PrestigeData
92     {
93         uint256 price;
94         uint256 productionBonusPct;
95     }
96     
97     mapping(uint256=>RigData) private rigData;
98     uint256 private numberOfRigs;
99 
100     // honey pot variables
101     uint256 private honeyPotAmount;
102     uint256 private devFund;
103     uint256 private nextPotDistributionTime;
104     mapping(address => mapping(uint256 => uint256)) private minerICOPerCycle;
105     uint256[] private honeyPotPerCycle;
106     uint256[] private globalICOPerCycle;
107     uint256 private cycleCount;
108     
109     //booster info
110     uint256 private numberOfBoosts;
111     mapping(uint256=>BoostData) private boostData;
112 
113     //prestige info
114     uint256 private maxPrestige;
115     mapping(uint256=>PrestigeData) prestigeData;
116     
117     // miner info
118     mapping(address => MinerData) private miners;
119     mapping(uint256 => address)   private indexes;
120     uint256 private topindex;
121     
122     address private owner;
123     
124     // ERC20 functionality
125     mapping(address => mapping(address => uint256)) private allowed;
126     string public constant name  = "RigWarsIdle";
127     string public constant symbol = "RIG";
128     uint8 public constant decimals = 8;
129     uint256 private estimatedSupply;
130     
131     // referral
132     mapping(address=>address) referrals;
133     
134     // Data Store Management
135     mapping(uint256=>uint256) private prestigeFinalizeTime;
136     mapping(uint256=>uint256) private rigFinalizeTime;
137     mapping(uint256=>uint256) private boostFinalizeTime;
138     
139     // ------------------------------------------------------------------------
140     // Constructor
141     // ------------------------------------------------------------------------
142     function RigIdle() public {
143         owner = msg.sender;
144         
145         //                   price,           prod.     unlockMultiplier
146         rigData[0] = RigData(32,              1,        1);
147         rigData[1] = RigData(256,             4,        1); 
148         rigData[2] = RigData(25600,           64,       2); 
149         rigData[3] = RigData(512000,          512,      1); 
150         rigData[4] = RigData(10240000,        8192,     4); 
151         rigData[5] = RigData(3000000000,      50000,    8); 
152         rigData[6] = RigData(75000000000,     250000,   10); 
153         rigData[7] = RigData(2500000000000,   1500000,  1);
154 
155         numberOfRigs = 8;
156         
157         topindex = 0;
158         honeyPotAmount = 0;
159         devFund = 0;
160         nextPotDistributionTime = block.timestamp;
161         
162         miners[msg.sender].lastUpdateTime = block.timestamp;
163         miners[msg.sender].rigCount[0] = 1;
164       
165         indexes[topindex] = msg.sender;
166         ++topindex;
167         
168         boostData[0] = BoostData(-1, 0, 100, 0.1 ether, 5, 5, 0, new address[](5));
169         boostData[0].boostHolders[0] = 0xe57A18783640c9fA3c5e8E4d4b4443E2024A7ff9;
170         boostData[0].boostHolders[1] = 0xf0333B94F895eb5aAb3822Da376F9CbcfcE8A19C;
171         boostData[0].boostHolders[2] = 0x85abE8E3bed0d4891ba201Af1e212FE50bb65a26;
172         boostData[0].boostHolders[3] = 0x11e52c75998fe2E7928B191bfc5B25937Ca16741;
173         boostData[0].boostHolders[4] = 0x522273122b20212FE255875a4737b6F50cc72006;
174         
175         numberOfBoosts = 1;
176         
177         prestigeData[0] = PrestigeData(25000, 100);       // before lvl 3
178         prestigeData[1] = PrestigeData(25000000, 200);    // befroe lvl 5 ~30min with 30k prod
179         prestigeData[2] = PrestigeData(20000000000, 400); // befroe lvl 7 ~6h with 25-30 lvl6 rig
180         
181         maxPrestige = 3;
182         
183         honeyPotPerCycle.push(0);
184         globalICOPerCycle.push(1);
185         cycleCount = 0;
186         
187         estimatedSupply = 1000000000000000000000000000;
188     }
189     
190     //--------------------------------------------------------------------------
191     // Data access functions
192     //--------------------------------------------------------------------------
193     function GetTotalMinerCount() public constant returns (uint256 count)
194     {
195         count = topindex;
196     }
197     
198     function GetMinerAt(uint256 idx) public constant returns (address minerAddr)
199     {
200         require(idx < topindex);
201         minerAddr = indexes[idx];
202     }
203     
204     function GetProductionPerSecond(address minerAddr) public constant returns (uint256 personalProduction)
205     {
206         MinerData storage m = miners[minerAddr];
207         
208         personalProduction = 0;
209         uint256 productionSpeedFlat = m.rigFlatBonus[-1];
210         
211         for(uint8 j = 0; j < numberOfRigs; ++j)
212         {
213             if(m.rigCount[j] > 0)
214                 personalProduction += (rigData[j].baseOutput + productionSpeedFlat + m.rigFlatBonus[j]) * m.rigCount[j] * (100 + m.rigPctBonus[j]);
215             else
216                 break;
217         }
218         
219         personalProduction = (personalProduction * ((100 + m.prestigeBonusPct) * (100 + m.rigPctBonus[-1]))) / 1000000;
220     }
221     
222     function GetMinerData(address minerAddr) public constant returns 
223         (uint256 money, uint256 lastupdate, uint256 prodPerSec, 
224          uint256 unclaimedPot, uint256 globalFlat, uint256 globalPct, uint256 prestigeLevel)
225     {
226         money = miners[minerAddr].money;
227         lastupdate = miners[minerAddr].lastUpdateTime;
228         prodPerSec = GetProductionPerSecond(minerAddr);
229      
230         unclaimedPot = miners[minerAddr].unclaimedPot;
231         
232         globalFlat = miners[minerAddr].rigFlatBonus[-1];
233         globalPct  = miners[minerAddr].rigPctBonus[-1];
234         
235         prestigeLevel = miners[minerAddr].prestigeLevel;
236     }
237     
238     function GetMinerRigsCount(address minerAddr, uint256 startIdx) public constant returns (uint256[10] rigs, uint256[10] totalProduction)
239     {
240         uint256 i = startIdx;
241         MinerData storage m = miners[minerAddr];
242         
243         for(i = startIdx; i < (startIdx+10) && i < numberOfRigs; ++i)
244         {
245             rigs[i]      = miners[minerAddr].rigCount[i];
246             totalProduction[i] = (rigData[i].baseOutput + m.rigFlatBonus[-1] + m.rigFlatBonus[int256(i)]) * ((100 + m.rigPctBonus[int256(i)]) *
247               (100 + m.prestigeBonusPct) * (100 + m.rigPctBonus[-1])) / 1000000;
248         }
249     }
250     
251     function GetTotalRigCount() public constant returns (uint256)
252     {
253         return numberOfRigs;
254     }
255     
256     function GetRigData(uint256 idx) public constant returns (uint256 _basePrice, uint256 _baseOutput, uint256 _unlockMultiplier, uint256 _lockTime)
257     {
258         require(idx < numberOfRigs);
259         
260         _basePrice  = rigData[idx].basePrice;
261         _baseOutput = rigData[idx].baseOutput;
262         _unlockMultiplier  = rigData[idx].unlockMultiplier;
263         _lockTime = rigFinalizeTime[idx];
264     }
265     
266     function CalculatePriceofRigs(uint256 idx, uint256 owned, uint256 count) public constant returns (uint256)
267     {
268         if(idx >= numberOfRigs)
269             return 0;
270             
271         if(owned == 0)
272             return (rigData[idx].basePrice * rigData[idx].unlockMultiplier);
273             
274         return GeometricSequence.sumOfNGeom(rigData[idx].basePrice, owned, count); 
275     }
276     
277     function GetMaxPrestigeLevel() public constant returns (uint256)
278     {
279         return maxPrestige;
280     }
281     
282     function GetPrestigeInfo(uint256 idx) public constant returns (uint256 price, uint256 bonusPct, uint256 _lockTime)
283     {
284         require(idx < maxPrestige);
285         
286         price = prestigeData[idx].price;
287         bonusPct = prestigeData[idx].productionBonusPct;
288         _lockTime = prestigeFinalizeTime[idx];
289     }
290   
291     function GetPotInfo() public constant returns (uint256 _honeyPotAmount, uint256 _devFunds, uint256 _nextDistributionTime)
292     {
293         _honeyPotAmount = honeyPotAmount;
294         _devFunds = devFund;
295         _nextDistributionTime = nextPotDistributionTime;
296     }
297     
298     function GetGlobalProduction() public constant returns (uint256 globalMoney, uint256 globalHashRate)
299     {
300         globalMoney = 0;
301         globalHashRate = 0;
302         uint i = 0;
303         for(i = 0; i < topindex; ++i)
304         {
305             MinerData storage m = miners[indexes[i]];
306             globalMoney += m.money;
307             globalHashRate += GetProductionPerSecond(indexes[i]);
308         }
309     }
310     
311     function GetBoosterCount() public constant returns (uint256)
312     {
313         return numberOfBoosts;
314     }
315   
316     function GetBoosterData(uint256 idx) public constant returns (int256 rigIdx, uint256 flatBonus, uint256 ptcBonus, 
317         uint256 currentPrice, uint256 increasePct, uint256 maxNumber, uint256 _lockTime)
318     {
319         require(idx < numberOfBoosts);
320         
321         rigIdx       = boostData[idx].rigIndex;
322         flatBonus    = boostData[idx].flatBonus;
323         ptcBonus     = boostData[idx].percentBonus;
324         currentPrice = boostData[idx].priceInWEI;
325         increasePct  = boostData[idx].priceIncreasePct;
326         maxNumber    = boostData[idx].totalCount;
327         _lockTime    = boostFinalizeTime[idx];
328     }
329     
330     function HasBooster(address addr, uint256 startIdx) public constant returns (uint8[10] hasBoost)
331     { 
332         require(startIdx < numberOfBoosts);
333         
334         uint j = 0;
335         
336         for( ;j < 10 && (j + startIdx) < numberOfBoosts; ++j)
337         {
338             BoostData storage b = boostData[j + startIdx];
339             hasBoost[j] = 0;
340             for(uint i = 0; i < b.totalCount; ++i)
341             {
342                if(b.boostHolders[i] == addr)
343                     hasBoost[j] = 1;
344             }
345         }
346         for( ;j < 10; ++j)
347         {
348             hasBoost[j] = 0;
349         }
350     }
351     
352     function GetCurrentICOCycle() public constant returns (uint256)
353     {
354         return cycleCount;
355     }
356     
357     function GetICOData(uint256 idx) public constant returns (uint256 ICOFund, uint256 ICOPot)
358     {
359         require(idx <= cycleCount);
360         ICOFund = globalICOPerCycle[idx];
361         if(idx < cycleCount)
362         {
363             ICOPot = honeyPotPerCycle[idx];
364         } else
365         {
366             ICOPot =  honeyPotAmount / 5; // actual day estimate
367         }
368     }
369     
370     function GetMinerICOData(address miner, uint256 idx) public constant returns (uint256 ICOFund, uint256 ICOShare, uint256 lastClaimIndex)
371     {
372         require(idx <= cycleCount);
373         ICOFund = minerICOPerCycle[miner][idx];
374         if(idx < cycleCount)
375         {
376             ICOShare = (honeyPotPerCycle[idx] * minerICOPerCycle[miner][idx]) / globalICOPerCycle[idx];
377         } else 
378         {
379             ICOShare = (honeyPotAmount / 5) * minerICOPerCycle[miner][idx] / globalICOPerCycle[idx];
380         }
381         lastClaimIndex = miners[miner].lastPotClaimIndex;
382     }
383     
384     function GetMinerUnclaimedICOShare(address miner) public constant returns (uint256 unclaimedPot)
385     {
386         MinerData storage m = miners[miner];
387         
388         require(m.lastUpdateTime != 0);
389         require(m.lastPotClaimIndex <= cycleCount);
390         
391         uint256 i = m.lastPotClaimIndex;
392         uint256 limit = cycleCount;
393         
394         if((limit - i) > 30) // more than 30 iterations(days) afk
395             limit = i + 30;
396         
397         unclaimedPot = 0;
398         for(; i < cycleCount; ++i)
399         {
400             if(minerICOPerCycle[msg.sender][i] > 0)
401                 unclaimedPot += (honeyPotPerCycle[i] * minerICOPerCycle[msg.sender][i]) / globalICOPerCycle[i];
402         }
403     }
404     
405     // -------------------------------------------------------------------------
406     // RigWars game handler functions
407     // -------------------------------------------------------------------------
408     function StartNewMiner(address referral) external
409     {
410         require(miners[msg.sender].lastUpdateTime == 0);
411         require(referral != msg.sender);
412         
413         miners[msg.sender].lastUpdateTime = block.timestamp;
414         miners[msg.sender].lastPotClaimIndex = cycleCount;
415         
416         miners[msg.sender].rigCount[0] = 1;
417         
418         indexes[topindex] = msg.sender;
419         ++topindex;
420         
421         if(referral != owner && referral != 0 && miners[referral].lastUpdateTime != 0)
422         {
423             referrals[msg.sender] = referral;
424             miners[msg.sender].rigCount[0] += 9;
425         }
426     }
427     
428     function UpgradeRig(uint8 rigIdx, uint256 count) external
429     {
430         require(rigIdx < numberOfRigs);
431         require(count > 0);
432         require(count <= 512);
433         require(rigFinalizeTime[rigIdx] < block.timestamp);
434         require(miners[msg.sender].lastUpdateTime != 0);
435         
436         MinerData storage m = miners[msg.sender];
437         
438         require(m.rigCount[rigIdx] > 0);
439         require(512 >= (m.rigCount[rigIdx] + count));
440         
441         UpdateMoney(msg.sender);
442      
443         // the base of geometrical sequence
444         uint256 price = GeometricSequence.sumOfNGeom(rigData[rigIdx].basePrice, m.rigCount[rigIdx], count); 
445        
446         require(m.money >= price);
447         
448         m.rigCount[rigIdx] = m.rigCount[rigIdx] + count;
449         
450         m.money -= price;
451     }
452     
453     function UnlockRig(uint8 rigIdx) external
454     {
455         require(rigIdx < numberOfRigs);
456         require(rigIdx > 0);
457         require(rigFinalizeTime[rigIdx] < block.timestamp);
458         require(miners[msg.sender].lastUpdateTime != 0);
459         
460         MinerData storage m = miners[msg.sender];
461         
462         require(m.rigCount[rigIdx] == 0);
463         require(m.rigCount[rigIdx-1] > 0);
464         
465         UpdateMoney(msg.sender);
466         
467         uint256 price = rigData[rigIdx].basePrice * rigData[rigIdx].unlockMultiplier;
468         
469         require(m.money >= price);
470         
471         m.rigCount[rigIdx] = 1;
472         m.money -= price;
473     }
474     
475     function PrestigeUp() external
476     {
477         require(miners[msg.sender].lastUpdateTime != 0);
478         require(prestigeFinalizeTime[m.prestigeLevel] < block.timestamp);
479         
480         MinerData storage m = miners[msg.sender];
481         
482         require(m.prestigeLevel < maxPrestige);
483         
484         UpdateMoney(msg.sender);
485         
486         require(m.money >= prestigeData[m.prestigeLevel].price);
487         
488         if(referrals[msg.sender] != 0)
489         {
490             miners[referrals[msg.sender]].money += prestigeData[m.prestigeLevel].price / 2;
491         }
492         
493         for(uint256 i = 0; i < numberOfRigs; ++i)
494         {
495             if(m.rigCount[i] > 1)
496                 m.rigCount[i] = m.rigCount[i] / 2; 
497         }
498         
499         m.money = 0;
500         m.prestigeBonusPct += prestigeData[m.prestigeLevel].productionBonusPct;
501         m.prestigeLevel += 1;
502     }
503  
504     function UpdateMoney(address addr) private
505     {
506         require(block.timestamp > miners[addr].lastUpdateTime);
507         
508         if(miners[addr].lastUpdateTime != 0)
509         {
510             MinerData storage m = miners[addr];
511             uint256 diff = block.timestamp - m.lastUpdateTime;
512             uint256 revenue = GetProductionPerSecond(addr);
513        
514             m.lastUpdateTime = block.timestamp;
515             if(revenue > 0)
516             {
517                 revenue *= diff;
518                 
519                 m.money += revenue;
520             }
521         }
522     }
523     
524     //--------------------------------------------------------------------------
525     // BOOSTER handlers
526     //--------------------------------------------------------------------------
527     function BuyBooster(uint256 idx) external payable 
528     {
529         require(miners[msg.sender].lastUpdateTime != 0);
530         require(idx < numberOfBoosts);
531         require(boostFinalizeTime[idx] < block.timestamp);
532         
533         BoostData storage b = boostData[idx];
534         
535         require(msg.value >= b.priceInWEI);
536         
537         for(uint i = 0; i < b.totalCount; ++i)
538             if(b.boostHolders[i] == msg.sender)
539                 revert();
540                 
541         address beneficiary = b.boostHolders[b.currentIndex];
542         
543         MinerData storage m = miners[beneficiary];
544         MinerData storage m2 = miners[msg.sender];
545         
546         // distribute the ETH
547         m.unclaimedPot += (msg.value * 9) / 10;
548         honeyPotAmount += msg.value / 20;
549         devFund += msg.value / 20;
550         
551         // increase price by X%
552         b.priceInWEI += (b.priceInWEI * b.priceIncreasePct) / 100;
553         
554         UpdateMoney(msg.sender);
555         UpdateMoney(beneficiary);
556         
557         // transfer ownership    
558         b.boostHolders[b.currentIndex] = msg.sender;
559         
560         // handle booster bonuses
561         if(m.rigFlatBonus[b.rigIndex] >= b.flatBonus){
562             m.rigFlatBonus[b.rigIndex] -= b.flatBonus;
563         } else {
564             m.rigFlatBonus[b.rigIndex] = 0;
565         }
566         
567         if(m.rigPctBonus[b.rigIndex] >= b.percentBonus) {
568             m.rigPctBonus[b.rigIndex] -= b.percentBonus;
569         } else {
570             m.rigPctBonus[b.rigIndex] = 0;
571         }
572         
573         m2.rigFlatBonus[b.rigIndex] += b.flatBonus;
574         m2.rigPctBonus[b.rigIndex] += b.percentBonus;
575         
576         // increase booster index
577         b.currentIndex += 1;
578         if(b.currentIndex >= b.totalCount)
579             b.currentIndex = 0;
580     }
581     
582     //--------------------------------------------------------------------------
583     // ICO/Pot share functions
584     //--------------------------------------------------------------------------
585     function ReleaseICO() external
586     {
587         require(miners[msg.sender].lastUpdateTime != 0);
588         require(nextPotDistributionTime <= block.timestamp);
589         require(honeyPotAmount > 0);
590         require(globalICOPerCycle[cycleCount] > 0);
591 
592         nextPotDistributionTime = block.timestamp + 86400;
593 
594         honeyPotPerCycle[cycleCount] = honeyPotAmount / 4; // 25% of the pot
595         
596         honeyPotAmount -= honeyPotAmount / 4;
597 
598         honeyPotPerCycle.push(0);
599         globalICOPerCycle.push(0);
600         cycleCount = cycleCount + 1;
601     }
602     
603     function FundICO(uint amount) external
604     {
605         require(miners[msg.sender].lastUpdateTime != 0);
606         require(amount > 0);
607         
608         MinerData storage m = miners[msg.sender];
609         
610         UpdateMoney(msg.sender);
611         
612         require(m.money >= amount);
613         
614         m.money = (m.money).sub(amount);
615         
616         globalICOPerCycle[cycleCount] = globalICOPerCycle[cycleCount].add(uint(amount));
617         minerICOPerCycle[msg.sender][cycleCount] = minerICOPerCycle[msg.sender][cycleCount].add(uint(amount));
618     }
619     
620     function WithdrawICOEarnings() external
621     {
622         MinerData storage m = miners[msg.sender];
623         
624         require(miners[msg.sender].lastUpdateTime != 0);
625         require(miners[msg.sender].lastPotClaimIndex < cycleCount);
626         
627         uint256 i = m.lastPotClaimIndex;
628         uint256 limit = cycleCount;
629         
630         if((limit - i) > 30) // more than 30 iterations(days) afk
631             limit = i + 30;
632         
633         m.lastPotClaimIndex = limit;
634         for(; i < cycleCount; ++i)
635         {
636             if(minerICOPerCycle[msg.sender][i] > 0)
637                 m.unclaimedPot += (honeyPotPerCycle[i] * minerICOPerCycle[msg.sender][i]) / globalICOPerCycle[i];
638         }
639     }
640     
641     //--------------------------------------------------------------------------
642     // Data Storage Management
643     //--------------------------------------------------------------------------
644      function AddNewBooster(uint256 idx, int256 _rigType, uint256 _flatBonus, uint256 _pctBonus, 
645       uint256 _ETHPrice, uint256 _priceIncreasePct, uint256 _totalCount) external
646     {
647         require(msg.sender == owner);
648         require(idx <= numberOfBoosts);
649         
650         if(idx < numberOfBoosts)
651             require(boostFinalizeTime[idx] > block.timestamp); 
652             
653         boostFinalizeTime[idx] = block.timestamp + 7200;
654         
655         boostData[idx].rigIndex = _rigType;
656         boostData[idx].flatBonus = _flatBonus;
657         boostData[idx].percentBonus = _pctBonus;
658         
659         boostData[idx].priceInWEI = _ETHPrice;
660         boostData[idx].priceIncreasePct = _priceIncreasePct;
661         boostData[idx].totalCount = _totalCount;
662         boostData[idx].currentIndex = 0;
663         
664         boostData[idx].boostHolders = new address[](_totalCount);
665         
666         for(uint256 i = 0; i < _totalCount; ++i)
667             boostData[idx].boostHolders[i] = owner;
668         
669         if(idx == numberOfBoosts)    
670             numberOfBoosts += 1;
671     }
672     
673     function AddorModifyRig(uint256 idx, uint256 _basePrice, uint256 _baseOutput, uint256 _unlockMultiplier) external
674     {
675         require(msg.sender == owner);
676         require(idx <= numberOfRigs);
677         
678         if(idx < numberOfRigs)
679             require(rigFinalizeTime[idx] > block.timestamp); 
680             
681         rigFinalizeTime[idx] = block.timestamp + 7200;
682         
683         rigData[idx].basePrice     = _basePrice;
684         rigData[idx].baseOutput    = _baseOutput;
685         rigData[idx].unlockMultiplier = _unlockMultiplier;
686         
687         if(idx == numberOfRigs)
688             numberOfRigs += 1;
689     }
690     
691     function AddNewPrestige(uint256 idx, uint256 _price, uint256 _bonusPct) public
692     {
693         require(msg.sender == owner);
694         require(idx <= maxPrestige);
695         
696         if(idx < maxPrestige)
697             require(prestigeFinalizeTime[idx] > block.timestamp); 
698             
699         prestigeFinalizeTime[idx] = block.timestamp + 7200;
700         
701         prestigeData[idx].price = _price;
702         prestigeData[idx].productionBonusPct = _bonusPct;
703         
704         if(idx == maxPrestige)
705             maxPrestige += 1;
706     }
707     
708     //--------------------------------------------------------------------------
709     // ETH handler functions
710     //--------------------------------------------------------------------------
711     function WithdrawPotShare() public
712     {
713         MinerData storage m = miners[msg.sender];
714         
715         require(m.unclaimedPot > 0);
716         require(m.lastUpdateTime != 0);
717         
718         uint256 amntToSend = m.unclaimedPot;
719         m.unclaimedPot = 0;
720         
721         if(msg.sender.send(amntToSend))
722         {
723             m.unclaimedPot = 0;
724         }
725     }
726     
727     function WithdrawDevFunds() public
728     {
729         require(msg.sender == owner);
730 
731         if(owner.send(devFund))
732         {
733             devFund = 0;
734         }
735     }
736     
737     // fallback payment to pot
738     function() public payable {
739          devFund += msg.value;
740     }
741     
742     //--------------------------------------------------------------------------
743     // ERC20 support
744     //--------------------------------------------------------------------------
745     function totalSupply() public constant returns(uint256) {
746         return estimatedSupply;
747     }
748     
749     function balanceOf(address miner) public constant returns(uint256) {
750         return miners[miner].money;
751     }
752     
753      function transfer(address recipient, uint256 amount) public returns (bool) {
754         require(amount <= miners[msg.sender].money);
755         
756         miners[msg.sender].money = (miners[msg.sender].money).sub(amount);
757         miners[recipient].money  = (miners[recipient].money).add(amount);
758         
759         emit Transfer(msg.sender, recipient, amount);
760         return true;
761     }
762     
763     function transferFrom(address miner, address recipient, uint256 amount) public returns (bool) {
764         require(amount <= allowed[miner][msg.sender] && amount <= balanceOf(miner));
765         
766         miners[miner].money        = (miners[miner].money).sub(amount);
767         miners[recipient].money    = (miners[recipient].money).add(amount);
768         allowed[miner][msg.sender] = (allowed[miner][msg.sender]).sub(amount);
769         
770         emit Transfer(miner, recipient, amount);
771         return true;
772     }
773     
774     function approve(address approvee, uint256 amount) public returns (bool){
775         require(amount <= miners[msg.sender].money);
776         
777         allowed[msg.sender][approvee] = amount;
778         emit Approval(msg.sender, approvee, amount);
779         return true;
780     }
781     
782     function allowance(address miner, address approvee) public constant returns(uint256){
783         return allowed[miner][approvee];
784     }
785 }