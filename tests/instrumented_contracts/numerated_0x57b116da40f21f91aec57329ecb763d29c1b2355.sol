1 pragma solidity ^0.4.0;
2 
3 interface ERC20 {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 // GOO - Crypto Idle Game
16 // https://ethergoo.io
17 
18 contract Goo is ERC20 {
19     
20     string public constant name  = "IdleEth";
21     string public constant symbol = "Goo";
22     uint8 public constant decimals = 0;
23     uint256 private roughSupply;
24     uint256 public totalGooProduction;
25     address public owner; // Minor management of game
26     bool public gameStarted;
27     
28     uint256 public researchDivPercent = 8;
29     uint256 public gooDepositDivPercent = 2;
30     
31     uint256 public totalEtherGooResearchPool; // Eth dividends to be split between players' goo production
32     uint256[] private totalGooProductionSnapshots; // The total goo production for each prior day past
33     uint256[] private totalGooDepositSnapshots;  // The total goo deposited for each prior day past
34     uint256[] private allocatedGooResearchSnapshots; // Div pot #1 (research eth allocated to each prior day past)
35     uint256[] private allocatedGooDepositSnapshots;  // Div pot #2 (deposit eth allocated to each prior day past)
36     uint256 public nextSnapshotTime;
37     
38     // Balances for each player
39     mapping(address => uint256) private ethBalance;
40     mapping(address => uint256) private gooBalance;
41     mapping(address => mapping(uint256 => uint256)) private gooProductionSnapshots; // Store player's goo production for given day (snapshot)
42     mapping(address => mapping(uint256 => uint256)) private gooDepositSnapshots;    // Store player's goo deposited for given day (snapshot)
43     mapping(address => mapping(uint256 => bool)) private gooProductionZeroedSnapshots; // This isn't great but we need know difference between 0 production and an unused/inactive day.
44     
45     mapping(address => uint256) private lastGooSaveTime; // Seconds (last time player claimed their produced goo)
46     mapping(address => uint256) public lastGooProductionUpdate; // Days (last snapshot player updated their production)
47     mapping(address => uint256) private lastGooResearchFundClaim; // Days (snapshot number)
48     mapping(address => uint256) private lastGooDepositFundClaim; // Days (snapshot number)
49     mapping(address => uint256) private battleCooldown; // If user attacks they cannot attack again for short time
50     
51     // Stuff owned by each player
52     mapping(address => mapping(uint256 => uint256)) private unitsOwned;
53     mapping(address => mapping(uint256 => bool)) private upgradesOwned;
54     mapping(uint256 => address) private rareItemOwner;
55     mapping(uint256 => uint256) private rareItemPrice;
56     
57     // Rares & Upgrades (Increase unit's production / attack etc.)
58     mapping(address => mapping(uint256 => uint256)) private unitGooProductionIncreases; // Adds to the goo per second
59     mapping(address => mapping(uint256 => uint256)) private unitGooProductionMultiplier; // Multiplies the goo per second
60     mapping(address => mapping(uint256 => uint256)) private unitAttackIncreases;
61     mapping(address => mapping(uint256 => uint256)) private unitAttackMultiplier;
62     mapping(address => mapping(uint256 => uint256)) private unitDefenseIncreases;
63     mapping(address => mapping(uint256 => uint256)) private unitDefenseMultiplier;
64     mapping(address => mapping(uint256 => uint256)) private unitGooStealingIncreases;
65     mapping(address => mapping(uint256 => uint256)) private unitGooStealingMultiplier;
66     mapping(address => mapping(uint256 => uint256)) private unitMaxCap;
67     
68     // Mapping of approved ERC20 transfers (by player)
69     mapping(address => mapping(address => uint256)) private allowed;
70     mapping(address => bool) private protectedAddresses; // For npc exchanges (requires 0 goo production)
71     
72     // Raffle structures
73     struct TicketPurchases {
74         TicketPurchase[] ticketsBought;
75         uint256 numPurchases; // Allows us to reset without clearing TicketPurchase[] (avoids potential for gas limit)
76         uint256 raffleId;
77     }
78     
79     // Allows us to query winner without looping (avoiding potential for gas limit)
80     struct TicketPurchase {
81         uint256 startId;
82         uint256 endId;
83     }
84     
85     // Raffle tickets
86     mapping(address => TicketPurchases) private rareItemTicketsBoughtByPlayer;
87     mapping(uint256 => address[]) private itemRafflePlayers;
88     
89     // Duplicating for the two raffles is not ideal
90     mapping(address => TicketPurchases) private rareUnitTicketsBoughtByPlayer;
91     mapping(uint256 => address[]) private unitRafflePlayers;
92 
93     // Item raffle info
94     uint256 private constant RAFFLE_TICKET_BASE_GOO_PRICE = 1000;
95     uint256 private itemRaffleEndTime;
96     uint256 private itemRaffleRareId;
97     uint256 private itemRaffleTicketsBought;
98     address private itemRaffleWinner; // Address of winner
99     bool private itemRaffleWinningTicketSelected;
100     uint256 private itemRaffleTicketThatWon;
101     
102      // Unit raffle info
103     uint256 private unitRaffleEndTime;
104     uint256 private unitRaffleId;     // Raffle Id
105     uint256 private unitRaffleRareId; // Unit Id
106     uint256 private unitRaffleTicketsBought;
107     address private unitRaffleWinner; // Address of winner
108     bool private unitRaffleWinningTicketSelected;
109     uint256 private unitRaffleTicketThatWon;
110     
111     // Minor game events
112     event UnitBought(address player, uint256 unitId, uint256 amount);
113     event UnitSold(address player, uint256 unitId, uint256 amount);
114     event PlayerAttacked(address attacker, address target, bool success, uint256 gooStolen);
115     
116     event ReferalGain(address player, address referal, uint256 amount);
117     event UpgradeMigration(address player, uint256 upgradeId, uint256 txProof);
118     
119     GooGameConfig schema = GooGameConfig(0xf925a82b8c26520170c8d51b65a7def6364877b3);
120     
121     // Constructor
122     function Goo() public payable {
123         owner = msg.sender;
124     }
125     
126     function() payable {
127         // Fallback will donate to pot
128         totalEtherGooResearchPool += msg.value;
129     }
130     
131     function beginGame(uint256 firstDivsTime) external payable {
132         require(msg.sender == owner);
133         require(!gameStarted);
134         
135         gameStarted = true; // GO-OOOO!
136         nextSnapshotTime = firstDivsTime;
137         totalGooDepositSnapshots.push(0); // Add initial-zero snapshot
138         totalEtherGooResearchPool = msg.value; // Seed pot
139     }
140     
141     // Incase community prefers goo deposit payments over production %, can be tweaked for balance
142     function tweakDailyDividends(uint256 newResearchPercent, uint256 newGooDepositPercent) external {
143         require(msg.sender == owner);
144         require(newResearchPercent > 0 && newResearchPercent <= 10);
145         require(newGooDepositPercent > 0 && newGooDepositPercent <= 10);
146         
147         researchDivPercent = newResearchPercent;
148         gooDepositDivPercent = newGooDepositPercent;
149     }
150     
151     function totalSupply() public constant returns(uint256) {
152         return roughSupply; // Stored goo (rough supply as it ignores earned/unclaimed goo)
153     }
154     
155     function balanceOf(address player) public constant returns(uint256) {
156         return gooBalance[player] + balanceOfUnclaimedGoo(player);
157     }
158     
159     function balanceOfUnclaimedGoo(address player) internal constant returns (uint256) {
160         uint256 lastSave = lastGooSaveTime[player];
161         if (lastSave > 0 && lastSave < block.timestamp) {
162             return (getGooProduction(player) * (block.timestamp - lastSave)) / 100;
163         }
164         return 0;
165     }
166     
167     function etherBalanceOf(address player) public constant returns(uint256) {
168         return ethBalance[player];
169     }
170     
171     function transfer(address recipient, uint256 amount) public returns (bool) {
172         updatePlayersGoo(msg.sender);
173         require(amount <= gooBalance[msg.sender]);
174         
175         gooBalance[msg.sender] -= amount;
176         gooBalance[recipient] += amount;
177         
178         emit Transfer(msg.sender, recipient, amount);
179         return true;
180     }
181     
182     function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
183         updatePlayersGoo(player);
184         require(amount <= allowed[player][msg.sender] && amount <= gooBalance[player]);
185         
186         gooBalance[player] -= amount;
187         gooBalance[recipient] += amount;
188         allowed[player][msg.sender] -= amount;
189         
190         emit Transfer(player, recipient, amount);
191         return true;
192     }
193     
194     function approve(address approvee, uint256 amount) public returns (bool){
195         allowed[msg.sender][approvee] = amount;
196         emit Approval(msg.sender, approvee, amount);
197         return true;
198     }
199     
200     function allowance(address player, address approvee) public constant returns(uint256){
201         return allowed[player][approvee];
202     }
203     
204     function getGooProduction(address player) public constant returns (uint256){
205         return gooProductionSnapshots[player][lastGooProductionUpdate[player]];
206     }
207     
208     function updatePlayersGoo(address player) internal {
209         uint256 gooGain = balanceOfUnclaimedGoo(player);
210         lastGooSaveTime[player] = block.timestamp;
211         roughSupply += gooGain;
212         gooBalance[player] += gooGain;
213     }
214     
215     function updatePlayersGooFromPurchase(address player, uint256 purchaseCost) internal {
216         uint256 unclaimedGoo = balanceOfUnclaimedGoo(player);
217         
218         if (purchaseCost > unclaimedGoo) {
219             uint256 gooDecrease = purchaseCost - unclaimedGoo;
220             require(gooBalance[player] >= gooDecrease);
221             roughSupply -= gooDecrease;
222             gooBalance[player] -= gooDecrease;
223         } else {
224             uint256 gooGain = unclaimedGoo - purchaseCost;
225             roughSupply += gooGain;
226             gooBalance[player] += gooGain;
227         }
228         
229         lastGooSaveTime[player] = block.timestamp;
230     }
231     
232     function increasePlayersGooProduction(address player, uint256 increase) internal {
233         gooProductionSnapshots[player][allocatedGooResearchSnapshots.length] = getGooProduction(player) + increase;
234         lastGooProductionUpdate[player] = allocatedGooResearchSnapshots.length;
235         totalGooProduction += increase;
236     }
237     
238     function reducePlayersGooProduction(address player, uint256 decrease) internal {
239         uint256 previousProduction = getGooProduction(player);
240         uint256 newProduction = SafeMath.sub(previousProduction, decrease);
241         
242         if (newProduction == 0) { // Special case which tangles with "inactive day" snapshots (claiming divs)
243             gooProductionZeroedSnapshots[player][allocatedGooResearchSnapshots.length] = true;
244             delete gooProductionSnapshots[player][allocatedGooResearchSnapshots.length]; // 0
245         } else {
246             gooProductionSnapshots[player][allocatedGooResearchSnapshots.length] = newProduction;
247         }
248         
249         lastGooProductionUpdate[player] = allocatedGooResearchSnapshots.length;
250         totalGooProduction -= decrease;
251     }
252     
253     
254     function buyBasicUnit(uint256 unitId, uint256 amount) external {
255         uint256 schemaUnitId;
256         uint256 gooProduction;
257         uint256 gooCost;
258         uint256 ethCost;
259         uint256 existing = unitsOwned[msg.sender][unitId];
260         (schemaUnitId, gooProduction, gooCost, ethCost) = schema.getUnitInfo(unitId, existing, amount);
261         
262         require(gameStarted);
263         require(schemaUnitId > 0); // Valid unit
264         require(ethCost == 0); // Free unit
265         
266         uint256 newTotal = SafeMath.add(existing, amount);
267         if (newTotal > 99) { // Default unit limit
268             require(newTotal <= unitMaxCap[msg.sender][unitId]); // Housing upgrades (allow more units)
269         }
270         
271         // Update players goo
272         updatePlayersGooFromPurchase(msg.sender, gooCost);
273         
274         if (gooProduction > 0) {
275             increasePlayersGooProduction(msg.sender, getUnitsProduction(msg.sender, unitId, amount));
276         }
277         
278         unitsOwned[msg.sender][unitId] = newTotal;
279         emit UnitBought(msg.sender, unitId, amount);
280     }
281     
282     
283     function buyEthUnit(uint256 unitId, uint256 amount) external payable {
284         uint256 schemaUnitId;
285         uint256 gooProduction;
286         uint256 gooCost;
287         uint256 ethCost;
288         uint256 existing = unitsOwned[msg.sender][unitId];
289         (schemaUnitId, gooProduction, gooCost, ethCost) = schema.getUnitInfo(unitId, existing, amount);
290         
291         require(gameStarted);
292         require(schemaUnitId > 0);
293         require(ethBalance[msg.sender] + msg.value >= ethCost);
294 
295         if (ethCost > msg.value) {
296             ethBalance[msg.sender] -= (ethCost - msg.value);
297         }
298         
299         uint256 devFund = ethCost / 50; // 2% fee on purchases (marketing, gameplay & maintenance)
300         uint256 dividends = (ethCost - devFund) / 4; // 25% goes to pool (75% retained for sale value)
301         totalEtherGooResearchPool += dividends;
302         ethBalance[owner] += devFund;
303         
304         
305         uint256 newTotal = SafeMath.add(existing, amount);
306         if (newTotal > 99) { // Default unit limit
307             require(newTotal <= unitMaxCap[msg.sender][unitId]); // Housing upgrades (allow more units)
308         }
309         
310         // Update players goo
311         updatePlayersGooFromPurchase(msg.sender, gooCost);
312         
313         if (gooProduction > 0) {
314             increasePlayersGooProduction(msg.sender, getUnitsProduction(msg.sender, unitId, amount));
315         }
316         
317         unitsOwned[msg.sender][unitId] += amount;
318         emit UnitBought(msg.sender, unitId, amount);
319     }
320     
321     
322     function sellUnit(uint256 unitId, uint256 amount) external {
323         uint256 existing = unitsOwned[msg.sender][unitId];
324         require(existing >= amount && amount > 0);
325         existing -= amount;
326         unitsOwned[msg.sender][unitId] = existing;
327         
328         uint256 schemaUnitId;
329         uint256 gooProduction;
330         uint256 gooCost;
331         uint256 ethCost;
332         (schemaUnitId, gooProduction, gooCost, ethCost) = schema.getUnitInfo(unitId, existing, amount);
333         require(schema.unitSellable(unitId));
334         
335         uint256 gooChange = balanceOfUnclaimedGoo(msg.sender) + ((gooCost * 3) / 4); // Claim unsaved goo whilst here
336         lastGooSaveTime[msg.sender] = block.timestamp;
337         roughSupply += gooChange;
338         gooBalance[msg.sender] += gooChange;
339         
340         if (gooProduction > 0) {
341             reducePlayersGooProduction(msg.sender, getUnitsProduction(msg.sender, unitId, amount));
342         }
343         
344         if (ethCost > 0) { // Premium units sell for 75% of buy cost
345             ethBalance[msg.sender] += (ethCost * 3) / 4;
346         }
347         
348         emit UnitSold(msg.sender, unitId, amount);
349     }
350     
351     
352     function buyUpgrade(uint256 upgradeId) external payable {
353         uint256 gooCost;
354         uint256 ethCost;
355         uint256 upgradeClass;
356         uint256 unitId;
357         uint256 upgradeValue;
358         uint256 prerequisiteUpgrade;
359         (gooCost, ethCost, upgradeClass, unitId, upgradeValue, prerequisiteUpgrade) = schema.getUpgradeInfo(upgradeId);
360         
361         require(gameStarted);
362         require(unitId > 0); // Valid upgrade
363         require(!upgradesOwned[msg.sender][upgradeId]); // Haven't already purchased
364         
365         if (prerequisiteUpgrade > 0) {
366             require(upgradesOwned[msg.sender][prerequisiteUpgrade]);
367         }
368         
369         if (ethCost > 0) {
370             require(ethBalance[msg.sender] + msg.value >= ethCost);
371              if (ethCost > msg.value) { // They can use their balance instead
372                 ethBalance[msg.sender] -= (ethCost - msg.value);
373             }
374         
375             uint256 devFund = ethCost / 50; // 2% fee on purchases (marketing, gameplay & maintenance)
376             totalEtherGooResearchPool += (ethCost - devFund); // Rest goes to div pool (Can't sell upgrades)
377             ethBalance[owner] += devFund;
378         }
379         
380         // Update players goo
381         updatePlayersGooFromPurchase(msg.sender, gooCost);
382 
383         upgradeUnitMultipliers(msg.sender, upgradeClass, unitId, upgradeValue);
384         upgradesOwned[msg.sender][upgradeId] = true;
385     }
386     
387     function upgradeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) internal {
388         uint256 productionGain;
389         if (upgradeClass == 0) {
390             unitGooProductionIncreases[player][unitId] += upgradeValue;
391             productionGain = unitsOwned[player][unitId] * upgradeValue * (10 + unitGooProductionMultiplier[player][unitId]);
392             increasePlayersGooProduction(player, productionGain);
393         } else if (upgradeClass == 1) {
394             unitGooProductionMultiplier[player][unitId] += upgradeValue;
395             productionGain = unitsOwned[player][unitId] * upgradeValue * (schema.unitGooProduction(unitId) + unitGooProductionIncreases[player][unitId]);
396             increasePlayersGooProduction(player, productionGain);
397         } else if (upgradeClass == 2) {
398             unitAttackIncreases[player][unitId] += upgradeValue;
399         } else if (upgradeClass == 3) {
400             unitAttackMultiplier[player][unitId] += upgradeValue;
401         } else if (upgradeClass == 4) {
402             unitDefenseIncreases[player][unitId] += upgradeValue;
403         } else if (upgradeClass == 5) {
404             unitDefenseMultiplier[player][unitId] += upgradeValue;
405         } else if (upgradeClass == 6) {
406             unitGooStealingIncreases[player][unitId] += upgradeValue;
407         } else if (upgradeClass == 7) {
408             unitGooStealingMultiplier[player][unitId] += upgradeValue;
409         } else if (upgradeClass == 8) {
410             unitMaxCap[player][unitId] = upgradeValue; // Housing upgrade (new capacity)
411         }
412     }
413     
414     function removeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) internal {
415         uint256 productionLoss;
416         if (upgradeClass == 0) {
417             unitGooProductionIncreases[player][unitId] -= upgradeValue;
418             productionLoss = unitsOwned[player][unitId] * upgradeValue * (10 + unitGooProductionMultiplier[player][unitId]);
419             reducePlayersGooProduction(player, productionLoss);
420         } else if (upgradeClass == 1) {
421             unitGooProductionMultiplier[player][unitId] -= upgradeValue;
422             productionLoss = unitsOwned[player][unitId] * upgradeValue * (schema.unitGooProduction(unitId) + unitGooProductionIncreases[player][unitId]);
423             reducePlayersGooProduction(player, productionLoss);
424         } else if (upgradeClass == 2) {
425             unitAttackIncreases[player][unitId] -= upgradeValue;
426         } else if (upgradeClass == 3) {
427             unitAttackMultiplier[player][unitId] -= upgradeValue;
428         } else if (upgradeClass == 4) {
429             unitDefenseIncreases[player][unitId] -= upgradeValue;
430         } else if (upgradeClass == 5) {
431             unitDefenseMultiplier[player][unitId] -= upgradeValue;
432         } else if (upgradeClass == 6) {
433             unitGooStealingIncreases[player][unitId] -= upgradeValue;
434         } else if (upgradeClass == 7) {
435             unitGooStealingMultiplier[player][unitId] -= upgradeValue;
436         }
437     }
438     
439     function buyRareItem(uint256 rareId) external payable {
440         uint256 upgradeClass;
441         uint256 unitId;
442         uint256 upgradeValue;
443         (upgradeClass, unitId, upgradeValue) = schema.getRareInfo(rareId);
444 
445         address previousOwner = rareItemOwner[rareId];
446         require(previousOwner != 0);
447         require(unitId > 0);
448         
449         // We have to claim buyer's goo before updating their production values
450         updatePlayersGoo(msg.sender);
451         upgradeUnitMultipliers(msg.sender, upgradeClass, unitId, upgradeValue);
452         
453         // We have to claim seller's goo before reducing their production values
454         updatePlayersGoo(previousOwner);
455         removeUnitMultipliers(previousOwner, upgradeClass, unitId, upgradeValue);
456         
457         uint256 ethCost = rareItemPrice[rareId];
458         require(ethBalance[msg.sender] + msg.value >= ethCost);
459         
460         // Splitbid/Overbid
461         if (ethCost > msg.value) {
462             // Earlier require() said they can still afford it (so use their ingame balance)
463             ethBalance[msg.sender] -= (ethCost - msg.value);
464         } else if (msg.value > ethCost) {
465             // Store overbid in their balance
466             ethBalance[msg.sender] += msg.value - ethCost;
467         }
468         
469         // Distribute ethCost
470         uint256 devFund = ethCost / 50; // 2% fee on purchases (marketing, gameplay & maintenance)
471         uint256 dividends = ethCost / 20; // 5% goes to pool (~93% goes to player)
472         totalEtherGooResearchPool += dividends;
473         ethBalance[owner] += devFund;
474         
475         // Transfer / update rare item
476         rareItemOwner[rareId] = msg.sender;
477         rareItemPrice[rareId] = (ethCost * 5) / 4; // 25% price flip increase
478         ethBalance[previousOwner] += ethCost - (dividends + devFund);
479     }
480     
481     function withdrawEther(uint256 amount) external {
482         require(amount <= ethBalance[msg.sender]);
483         ethBalance[msg.sender] -= amount;
484         msg.sender.transfer(amount);
485     }
486     
487     function fundGooResearch(uint256 amount) external {
488         updatePlayersGooFromPurchase(msg.sender, amount);
489         gooDepositSnapshots[msg.sender][totalGooDepositSnapshots.length - 1] += amount;
490         totalGooDepositSnapshots[totalGooDepositSnapshots.length - 1] += amount;
491     }
492     
493     function claimResearchDividends(address referer, uint256 startSnapshot, uint256 endSnapShot) external {
494         require(startSnapshot <= endSnapShot);
495         require(startSnapshot >= lastGooResearchFundClaim[msg.sender]);
496         require(endSnapShot < allocatedGooResearchSnapshots.length);
497         
498         uint256 researchShare;
499         uint256 previousProduction = gooProductionSnapshots[msg.sender][lastGooResearchFundClaim[msg.sender] - 1]; // Underflow won't be a problem as gooProductionSnapshots[][0xffffffffff] = 0;
500         for (uint256 i = startSnapshot; i <= endSnapShot; i++) {
501             
502             // Slightly complex things by accounting for days/snapshots when user made no tx's
503             uint256 productionDuringSnapshot = gooProductionSnapshots[msg.sender][i];
504             bool soldAllProduction = gooProductionZeroedSnapshots[msg.sender][i];
505             if (productionDuringSnapshot == 0 && !soldAllProduction) {
506                 productionDuringSnapshot = previousProduction;
507             } else {
508                previousProduction = productionDuringSnapshot;
509             }
510             
511             researchShare += (allocatedGooResearchSnapshots[i] * productionDuringSnapshot) / totalGooProductionSnapshots[i];
512         }
513         
514         
515         if (gooProductionSnapshots[msg.sender][endSnapShot] == 0 && !gooProductionZeroedSnapshots[msg.sender][endSnapShot] && previousProduction > 0) {
516             gooProductionSnapshots[msg.sender][endSnapShot] = previousProduction; // Checkpoint for next claim
517         }
518         
519         lastGooResearchFundClaim[msg.sender] = endSnapShot + 1;
520         
521         uint256 referalDivs;
522         if (referer != address(0) && referer != msg.sender) {
523             referalDivs = researchShare / 100; // 1%
524             ethBalance[referer] += referalDivs;
525             emit ReferalGain(referer, msg.sender, referalDivs);
526         }
527         
528         ethBalance[msg.sender] += researchShare - referalDivs;
529     }
530     
531     
532     function claimGooDepositDividends(address referer, uint256 startSnapshot, uint256 endSnapShot) external {
533         require(startSnapshot <= endSnapShot);
534         require(startSnapshot >= lastGooDepositFundClaim[msg.sender]);
535         require(endSnapShot < allocatedGooDepositSnapshots.length);
536         
537         uint256 depositShare;
538         for (uint256 i = startSnapshot; i <= endSnapShot; i++) {
539             depositShare += (allocatedGooDepositSnapshots[i] * gooDepositSnapshots[msg.sender][i]) / totalGooDepositSnapshots[i];
540         }
541         
542         lastGooDepositFundClaim[msg.sender] = endSnapShot + 1;
543         
544         uint256 referalDivs;
545         if (referer != address(0) && referer != msg.sender) {
546             referalDivs = depositShare / 100; // 1%
547             ethBalance[referer] += referalDivs;
548             emit ReferalGain(referer, msg.sender, referalDivs);
549         }
550         
551         ethBalance[msg.sender] += depositShare - referalDivs;
552     }
553     
554     
555     // Allocate pot #1 divs for the day (00:00 cron job)
556     function snapshotDailyGooResearchFunding() external {
557         require(msg.sender == owner);
558         
559         uint256 todaysGooResearchFund = (totalEtherGooResearchPool * researchDivPercent) / 100; // 8% of pool daily
560         totalEtherGooResearchPool -= todaysGooResearchFund;
561         
562         totalGooProductionSnapshots.push(totalGooProduction);
563         allocatedGooResearchSnapshots.push(todaysGooResearchFund);
564         nextSnapshotTime = block.timestamp + 24 hours;
565     }
566     
567     // Allocate pot #2 divs for the day (12:00 cron job)
568     function snapshotDailyGooDepositFunding() external {
569         require(msg.sender == owner);
570         
571         uint256 todaysGooDepositFund = (totalEtherGooResearchPool * gooDepositDivPercent) / 100; // 2% of pool daily
572         totalEtherGooResearchPool -= todaysGooDepositFund;
573         totalGooDepositSnapshots.push(0); // Reset for to store next day's deposits
574         allocatedGooDepositSnapshots.push(todaysGooDepositFund); // Store to payout divs for previous day deposits
575     }
576     
577     
578     // Raffle for rare items
579     function buyItemRaffleTicket(uint256 amount) external {
580         require(itemRaffleEndTime >= block.timestamp);
581         require(amount > 0);
582         
583         uint256 ticketsCost = SafeMath.mul(RAFFLE_TICKET_BASE_GOO_PRICE, amount);
584         require(balanceOf(msg.sender) >= ticketsCost);
585         
586         // Update players goo
587         updatePlayersGooFromPurchase(msg.sender, ticketsCost);
588         
589         // Handle new tickets
590         TicketPurchases storage purchases = rareItemTicketsBoughtByPlayer[msg.sender];
591         
592         // If we need to reset tickets from a previous raffle
593         if (purchases.raffleId != itemRaffleRareId) {
594             purchases.numPurchases = 0;
595             purchases.raffleId = itemRaffleRareId;
596             itemRafflePlayers[itemRaffleRareId].push(msg.sender); // Add user to raffle
597         }
598         
599         // Store new ticket purchase
600         if (purchases.numPurchases == purchases.ticketsBought.length) {
601             purchases.ticketsBought.length += 1;
602         }
603         purchases.ticketsBought[purchases.numPurchases++] = TicketPurchase(itemRaffleTicketsBought, itemRaffleTicketsBought + (amount - 1)); // (eg: buy 10, get id's 0-9)
604         
605         // Finally update ticket total
606         itemRaffleTicketsBought += amount;
607     }
608     
609     // Raffle for rare units
610     function buyUnitRaffleTicket(uint256 amount) external {
611         require(unitRaffleEndTime >= block.timestamp);
612         require(amount > 0);
613         
614         uint256 ticketsCost = SafeMath.mul(RAFFLE_TICKET_BASE_GOO_PRICE, amount);
615         require(balanceOf(msg.sender) >= ticketsCost);
616         
617         // Update players goo
618         updatePlayersGooFromPurchase(msg.sender, ticketsCost);
619         
620         // Handle new tickets
621         TicketPurchases storage purchases = rareUnitTicketsBoughtByPlayer[msg.sender];
622         
623         // If we need to reset tickets from a previous raffle
624         if (purchases.raffleId != unitRaffleId) {
625             purchases.numPurchases = 0;
626             purchases.raffleId = unitRaffleId;
627             unitRafflePlayers[unitRaffleId].push(msg.sender); // Add user to raffle
628         }
629         
630         // Store new ticket purchase
631         if (purchases.numPurchases == purchases.ticketsBought.length) {
632             purchases.ticketsBought.length += 1;
633         }
634         purchases.ticketsBought[purchases.numPurchases++] = TicketPurchase(unitRaffleTicketsBought, unitRaffleTicketsBought + (amount - 1)); // (eg: buy 10, get id's 0-9)
635         
636         // Finally update ticket total
637         unitRaffleTicketsBought += amount;
638     }
639     
640     function startItemRaffle(uint256 endTime, uint256 rareId) external {
641         require(msg.sender == owner);
642         require(schema.validRareId(rareId));
643         require(rareItemOwner[rareId] == 0);
644         require(block.timestamp < endTime);
645         
646         if (itemRaffleRareId != 0) { // Sanity to assure raffle has ended before next one starts
647             require(itemRaffleWinner != 0);
648         }
649         
650         // Reset previous raffle info
651         itemRaffleWinningTicketSelected = false;
652         itemRaffleTicketThatWon = 0;
653         itemRaffleWinner = 0;
654         itemRaffleTicketsBought = 0;
655         
656         // Set current raffle info
657         itemRaffleEndTime = endTime;
658         itemRaffleRareId = rareId;
659     }
660     
661     function startUnitRaffle(uint256 endTime, uint256 unitId) external {
662         require(msg.sender == owner);
663         require(block.timestamp < endTime);
664         
665         if (unitRaffleRareId != 0) { // Sanity to assure raffle has ended before next one starts
666             require(unitRaffleWinner != 0);
667         }
668         
669         // Reset previous raffle info
670         unitRaffleWinningTicketSelected = false;
671         unitRaffleTicketThatWon = 0;
672         unitRaffleWinner = 0;
673         unitRaffleTicketsBought = 0;
674         
675         // Set current raffle info
676         unitRaffleEndTime = endTime;
677         unitRaffleRareId = unitId;
678         unitRaffleId++; // Can't use unitRaffleRareId (as rare units are not unique)
679     }
680     
681     function awardItemRafflePrize(address checkWinner, uint256 checkIndex) external {
682         require(itemRaffleEndTime < block.timestamp);
683         require(itemRaffleWinner == 0);
684         require(rareItemOwner[itemRaffleRareId] == 0);
685         
686         if (!itemRaffleWinningTicketSelected) {
687             drawRandomItemWinner(); // Ideally do it in one call (gas limit cautious)
688         }
689         
690         // Reduce gas by (optionally) offering an address to _check_ for winner
691         if (checkWinner != 0) {
692             TicketPurchases storage tickets = rareItemTicketsBoughtByPlayer[checkWinner];
693             if (tickets.numPurchases > 0 && checkIndex < tickets.numPurchases && tickets.raffleId == itemRaffleRareId) {
694                 TicketPurchase storage checkTicket = tickets.ticketsBought[checkIndex];
695                 if (itemRaffleTicketThatWon >= checkTicket.startId && itemRaffleTicketThatWon <= checkTicket.endId) {
696                     assignItemRafflePrize(checkWinner); // WINNER!
697                     return;
698                 }
699             }
700         }
701         
702         // Otherwise just naively try to find the winner (will work until mass amounts of players)
703         for (uint256 i = 0; i < itemRafflePlayers[itemRaffleRareId].length; i++) {
704             address player = itemRafflePlayers[itemRaffleRareId][i];
705             TicketPurchases storage playersTickets = rareItemTicketsBoughtByPlayer[player];
706             
707             uint256 endIndex = playersTickets.numPurchases - 1;
708             // Minor optimization to avoid checking every single player
709             if (itemRaffleTicketThatWon >= playersTickets.ticketsBought[0].startId && itemRaffleTicketThatWon <= playersTickets.ticketsBought[endIndex].endId) {
710                 for (uint256 j = 0; j < playersTickets.numPurchases; j++) {
711                     TicketPurchase storage playerTicket = playersTickets.ticketsBought[j];
712                     if (itemRaffleTicketThatWon >= playerTicket.startId && itemRaffleTicketThatWon <= playerTicket.endId) {
713                         assignItemRafflePrize(player); // WINNER!
714                         return;
715                     }
716                 }
717             }
718         }
719     }
720     
721     function awardUnitRafflePrize(address checkWinner, uint256 checkIndex) external {
722         require(unitRaffleEndTime < block.timestamp);
723         require(unitRaffleWinner == 0);
724         
725         if (!unitRaffleWinningTicketSelected) {
726             drawRandomUnitWinner(); // Ideally do it in one call (gas limit cautious)
727         }
728         
729         // Reduce gas by (optionally) offering an address to _check_ for winner
730         if (checkWinner != 0) {
731             TicketPurchases storage tickets = rareUnitTicketsBoughtByPlayer[checkWinner];
732             if (tickets.numPurchases > 0 && checkIndex < tickets.numPurchases && tickets.raffleId == unitRaffleId) {
733                 TicketPurchase storage checkTicket = tickets.ticketsBought[checkIndex];
734                 if (unitRaffleTicketThatWon >= checkTicket.startId && unitRaffleTicketThatWon <= checkTicket.endId) {
735                     assignUnitRafflePrize(checkWinner); // WINNER!
736                     return;
737                 }
738             }
739         }
740         
741         // Otherwise just naively try to find the winner (will work until mass amounts of players)
742         for (uint256 i = 0; i < unitRafflePlayers[unitRaffleId].length; i++) {
743             address player = unitRafflePlayers[unitRaffleId][i];
744             TicketPurchases storage playersTickets = rareUnitTicketsBoughtByPlayer[player];
745             
746             uint256 endIndex = playersTickets.numPurchases - 1;
747             // Minor optimization to avoid checking every single player
748             if (unitRaffleTicketThatWon >= playersTickets.ticketsBought[0].startId && unitRaffleTicketThatWon <= playersTickets.ticketsBought[endIndex].endId) {
749                 for (uint256 j = 0; j < playersTickets.numPurchases; j++) {
750                     TicketPurchase storage playerTicket = playersTickets.ticketsBought[j];
751                     if (unitRaffleTicketThatWon >= playerTicket.startId && unitRaffleTicketThatWon <= playerTicket.endId) {
752                         assignUnitRafflePrize(player); // WINNER!
753                         return;
754                     }
755                 }
756             }
757         }
758     }
759     
760     function assignItemRafflePrize(address winner) internal {
761         itemRaffleWinner = winner;
762         rareItemOwner[itemRaffleRareId] = winner;
763         rareItemPrice[itemRaffleRareId] = (schema.rareStartPrice(itemRaffleRareId) * 21) / 20; // Buy price slightly higher (Div pool cut)
764         
765         updatePlayersGoo(winner);
766         uint256 upgradeClass;
767         uint256 unitId;
768         uint256 upgradeValue;
769         (upgradeClass, unitId, upgradeValue) = schema.getRareInfo(itemRaffleRareId);
770         upgradeUnitMultipliers(winner, upgradeClass, unitId, upgradeValue);
771     }
772     
773     function assignUnitRafflePrize(address winner) internal {
774         unitRaffleWinner = winner;
775         updatePlayersGoo(winner);
776         increasePlayersGooProduction(winner, getUnitsProduction(winner, unitRaffleRareId, 1));
777         unitsOwned[winner][unitRaffleRareId] += 1;
778     }
779     
780     // Random enough for small contests (Owner only to prevent trial & error execution)
781     function drawRandomItemWinner() public {
782         require(msg.sender == owner);
783         require(itemRaffleEndTime < block.timestamp);
784         require(!itemRaffleWinningTicketSelected);
785         
786         uint256 seed = itemRaffleTicketsBought + block.timestamp;
787         itemRaffleTicketThatWon = addmod(uint256(block.blockhash(block.number-1)), seed, itemRaffleTicketsBought);
788         itemRaffleWinningTicketSelected = true;
789     }
790     
791     function drawRandomUnitWinner() public {
792         require(msg.sender == owner);
793         require(unitRaffleEndTime < block.timestamp);
794         require(!unitRaffleWinningTicketSelected);
795         
796         uint256 seed = unitRaffleTicketsBought + block.timestamp;
797         unitRaffleTicketThatWon = addmod(uint256(block.blockhash(block.number-1)), seed, unitRaffleTicketsBought);
798         unitRaffleWinningTicketSelected = true;
799     }
800     
801     // Gives players the upgrades they 'previously paid for' (i.e. will be one of same unit/type/value of their v1 purchase)
802     // Tx of their (prior) purchase is provided so can be validated by anyone for 0 abuse
803     function migrateV1Upgrades(address[] playerToCredit, uint256[] upgradeIds, uint256[] txProof) external {
804         require(msg.sender == owner);
805         require(!gameStarted); // Pre-game migration
806         
807         for (uint256 i = 0; i < txProof.length; i++) {
808             address player = playerToCredit[i];
809             uint256 upgradeId = upgradeIds[i];
810             
811             uint256 unitId = schema.upgradeUnitId(upgradeId);
812             if (unitId > 0 && !upgradesOwned[player][upgradeId]) { // Upgrade valid (and haven't already migrated)
813                 uint256 upgradeClass = schema.upgradeClass(upgradeId);
814                 uint256 upgradeValue = schema.upgradeValue(upgradeId);
815         
816                 upgradeUnitMultipliers(player, upgradeClass, unitId, upgradeValue);
817                 upgradesOwned[player][upgradeId] = true;
818                 emit UpgradeMigration(player, upgradeId, txProof[i]);
819             }
820         }
821     }
822     
823     function protectAddress(address exchange, bool shouldProtect) external {
824         require(msg.sender == owner);
825         if (shouldProtect) {
826             require(getGooProduction(exchange) == 0); // Can't protect actual players
827         }
828         protectedAddresses[exchange] = shouldProtect;
829     }
830     
831     function attackPlayer(address target) external {
832         require(battleCooldown[msg.sender] < block.timestamp);
833         require(target != msg.sender);
834         require(!protectedAddresses[target]); // Target not whitelisted (i.e. exchange wallets)
835         
836         uint256 attackingPower;
837         uint256 defendingPower;
838         uint256 stealingPower;
839         (attackingPower, defendingPower, stealingPower) = getPlayersBattlePower(msg.sender, target);
840         
841         if (battleCooldown[target] > block.timestamp) { // When on battle cooldown you're vulnerable (starting value is 50% normal power)
842             defendingPower = schema.getWeakenedDefensePower(defendingPower);
843         }
844         
845         if (attackingPower > defendingPower) {
846             battleCooldown[msg.sender] = block.timestamp + 30 minutes;
847             if (balanceOf(target) > stealingPower) {
848                 // Save all their unclaimed goo, then steal attacker's max capacity (at same time)
849                 uint256 unclaimedGoo = balanceOfUnclaimedGoo(target);
850                 if (stealingPower > unclaimedGoo) {
851                     uint256 gooDecrease = stealingPower - unclaimedGoo;
852                     gooBalance[target] -= gooDecrease;
853                     roughSupply -= gooDecrease;
854                 } else {
855                     uint256 gooGain = unclaimedGoo - stealingPower;
856                     gooBalance[target] += gooGain;
857                     roughSupply += gooGain;
858                 }
859                 gooBalance[msg.sender] += stealingPower;
860                 emit PlayerAttacked(msg.sender, target, true, stealingPower);
861             } else {
862                 emit PlayerAttacked(msg.sender, target, true, balanceOf(target));
863                 gooBalance[msg.sender] += balanceOf(target);
864                 gooBalance[target] = 0;
865             }
866             
867             lastGooSaveTime[target] = block.timestamp;
868             // We don't need to claim/save msg.sender's goo (as production delta is unchanged)
869         } else {
870             battleCooldown[msg.sender] = block.timestamp + 10 minutes;
871             emit PlayerAttacked(msg.sender, target, false, 0);
872         }
873     }
874     
875     function getPlayersBattlePower(address attacker, address defender) internal constant returns (uint256, uint256, uint256) {
876         uint256 startId;
877         uint256 endId;
878         (startId, endId) = schema.battleUnitIdRange();
879         
880         uint256 attackingPower;
881         uint256 defendingPower;
882         uint256 stealingPower;
883 
884         // Not ideal but will only be a small number of units (and saves gas when buying units)
885         while (startId <= endId) {
886             attackingPower += getUnitsAttack(attacker, startId, unitsOwned[attacker][startId]);
887             stealingPower += getUnitsStealingCapacity(attacker, startId, unitsOwned[attacker][startId]);
888             
889             defendingPower += getUnitsDefense(defender, startId, unitsOwned[defender][startId]);
890             startId++;
891         }
892         
893         return (attackingPower, defendingPower, stealingPower);
894     }
895     
896     function getPlayersBattleStats(address player) external constant returns (uint256, uint256, uint256, uint256) {
897         uint256 startId;
898         uint256 endId;
899         (startId, endId) = schema.battleUnitIdRange();
900         
901         uint256 attackingPower;
902         uint256 defendingPower;
903         uint256 stealingPower;
904 
905         // Not ideal but will only be a small number of units (and saves gas when buying units)
906         while (startId <= endId) {
907             attackingPower += getUnitsAttack(player, startId, unitsOwned[player][startId]);
908             stealingPower += getUnitsStealingCapacity(player, startId, unitsOwned[player][startId]);
909             defendingPower += getUnitsDefense(player, startId, unitsOwned[player][startId]);
910             startId++;
911         }
912         
913         if (battleCooldown[player] > block.timestamp) { // When on battle cooldown you're vulnerable (starting value is 50% normal power)
914             defendingPower = schema.getWeakenedDefensePower(defendingPower);
915         }
916         
917         return (attackingPower, defendingPower, stealingPower, battleCooldown[player]);
918     }
919     
920     function getUnitsProduction(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
921         return (amount * (schema.unitGooProduction(unitId) + unitGooProductionIncreases[player][unitId]) * (10 + unitGooProductionMultiplier[player][unitId]));
922     }
923     
924     function getUnitsAttack(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
925         return (amount * (schema.unitAttack(unitId) + unitAttackIncreases[player][unitId]) * (10 + unitAttackMultiplier[player][unitId])) / 10;
926     }
927     
928     function getUnitsDefense(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
929         return (amount * (schema.unitDefense(unitId) + unitDefenseIncreases[player][unitId]) * (10 + unitDefenseMultiplier[player][unitId])) / 10;
930     }
931     
932     function getUnitsStealingCapacity(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
933         return (amount * (schema.unitStealingCapacity(unitId) + unitGooStealingIncreases[player][unitId]) * (10 + unitGooStealingMultiplier[player][unitId])) / 10;
934     }
935     
936     
937     // To display on website
938     function getGameInfo() external constant returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256[], bool[]){
939         uint256[] memory units = new uint256[](schema.currentNumberOfUnits());
940         bool[] memory upgrades = new bool[](schema.currentNumberOfUpgrades());
941         
942         uint256 startId;
943         uint256 endId;
944         (startId, endId) = schema.productionUnitIdRange();
945         
946         uint256 i;
947         while (startId <= endId) {
948             units[i] = unitsOwned[msg.sender][startId];
949             i++;
950             startId++;
951         }
952         
953         (startId, endId) = schema.battleUnitIdRange();
954         while (startId <= endId) {
955             units[i] = unitsOwned[msg.sender][startId];
956             i++;
957             startId++;
958         }
959         
960         // Reset for upgrades
961         i = 0;
962         (startId, endId) = schema.upgradeIdRange();
963         while (startId <= endId) {
964             upgrades[i] = upgradesOwned[msg.sender][startId];
965             i++;
966             startId++;
967         }
968         
969         return (block.timestamp, totalEtherGooResearchPool, totalGooProduction, totalGooDepositSnapshots[totalGooDepositSnapshots.length - 1],  gooDepositSnapshots[msg.sender][totalGooDepositSnapshots.length - 1],
970         nextSnapshotTime, balanceOf(msg.sender), ethBalance[msg.sender], getGooProduction(msg.sender), units, upgrades);
971     }
972     
973     // To display on website
974     function getRareItemInfo() external constant returns (address[], uint256[]) {
975         address[] memory itemOwners = new address[](schema.currentNumberOfRares());
976         uint256[] memory itemPrices = new uint256[](schema.currentNumberOfRares());
977         
978         uint256 startId;
979         uint256 endId;
980         (startId, endId) = schema.rareIdRange();
981         
982         uint256 i;
983         while (startId <= endId) {
984             itemOwners[i] = rareItemOwner[startId];
985             itemPrices[i] = rareItemPrice[startId];
986             
987             i++;
988             startId++;
989         }
990         
991         return (itemOwners, itemPrices);
992     }
993     
994     // To display on website
995     function viewUnclaimedResearchDividends() external constant returns (uint256, uint256, uint256) {
996         uint256 startSnapshot = lastGooResearchFundClaim[msg.sender];
997         uint256 latestSnapshot = allocatedGooResearchSnapshots.length - 1; // No snapshots to begin with
998         
999         uint256 researchShare;
1000         uint256 previousProduction = gooProductionSnapshots[msg.sender][lastGooResearchFundClaim[msg.sender] - 1]; // Underflow won't be a problem as gooProductionSnapshots[][0xfffffffffffff] = 0;
1001         for (uint256 i = startSnapshot; i <= latestSnapshot; i++) {
1002             
1003             // Slightly complex things by accounting for days/snapshots when user made no tx's
1004             uint256 productionDuringSnapshot = gooProductionSnapshots[msg.sender][i];
1005             bool soldAllProduction = gooProductionZeroedSnapshots[msg.sender][i];
1006             if (productionDuringSnapshot == 0 && !soldAllProduction) {
1007                 productionDuringSnapshot = previousProduction;
1008             } else {
1009                previousProduction = productionDuringSnapshot;
1010             }
1011             
1012             researchShare += (allocatedGooResearchSnapshots[i] * productionDuringSnapshot) / totalGooProductionSnapshots[i];
1013         }
1014         return (researchShare, startSnapshot, latestSnapshot);
1015     }
1016     
1017     // To display on website
1018     function viewUnclaimedDepositDividends() external constant returns (uint256, uint256, uint256) {
1019         uint256 startSnapshot = lastGooDepositFundClaim[msg.sender];
1020         uint256 latestSnapshot = allocatedGooDepositSnapshots.length - 1; // No snapshots to begin with
1021         
1022         uint256 depositShare;
1023         for (uint256 i = startSnapshot; i <= latestSnapshot; i++) {
1024             depositShare += (allocatedGooDepositSnapshots[i] * gooDepositSnapshots[msg.sender][i]) / totalGooDepositSnapshots[i];
1025         }
1026         return (depositShare, startSnapshot, latestSnapshot);
1027     }
1028     
1029     
1030     // To allow clients to verify contestants
1031     function getItemRafflePlayers(uint256 raffleId) external constant returns (address[]) {
1032         return (itemRafflePlayers[raffleId]);
1033     }
1034     
1035     // To allow clients to verify contestants
1036     function getUnitRafflePlayers(uint256 raffleId) external constant returns (address[]) {
1037         return (unitRafflePlayers[raffleId]);
1038     }
1039     
1040     // To allow clients to verify contestants
1041     function getPlayersItemTickets(address player) external constant returns (uint256[], uint256[]) {
1042         TicketPurchases storage playersTickets = rareItemTicketsBoughtByPlayer[player];
1043         
1044         if (playersTickets.raffleId == itemRaffleRareId) {
1045             uint256[] memory startIds = new uint256[](playersTickets.numPurchases);
1046             uint256[] memory endIds = new uint256[](playersTickets.numPurchases);
1047             
1048             for (uint256 i = 0; i < playersTickets.numPurchases; i++) {
1049                 startIds[i] = playersTickets.ticketsBought[i].startId;
1050                 endIds[i] = playersTickets.ticketsBought[i].endId;
1051             }
1052         }
1053         
1054         return (startIds, endIds);
1055     }
1056     
1057     // To allow clients to verify contestants
1058     function getPlayersUnitTickets(address player) external constant returns (uint256[], uint256[]) {
1059         TicketPurchases storage playersTickets = rareUnitTicketsBoughtByPlayer[player];
1060         
1061         if (playersTickets.raffleId == unitRaffleId) {
1062             uint256[] memory startIds = new uint256[](playersTickets.numPurchases);
1063             uint256[] memory endIds = new uint256[](playersTickets.numPurchases);
1064             
1065             for (uint256 i = 0; i < playersTickets.numPurchases; i++) {
1066                 startIds[i] = playersTickets.ticketsBought[i].startId;
1067                 endIds[i] = playersTickets.ticketsBought[i].endId;
1068             }
1069         }
1070         
1071         return (startIds, endIds);
1072     }
1073     
1074     // To display on website
1075     function getLatestItemRaffleInfo() external constant returns (uint256, uint256, uint256, address, uint256) {
1076         return (itemRaffleEndTime, itemRaffleRareId, itemRaffleTicketsBought, itemRaffleWinner, itemRaffleTicketThatWon);
1077     }
1078     
1079     // To display on website
1080     function getLatestUnitRaffleInfo() external constant returns (uint256, uint256, uint256, address, uint256) {
1081         return (unitRaffleEndTime, unitRaffleRareId, unitRaffleTicketsBought, unitRaffleWinner, unitRaffleTicketThatWon);
1082     }
1083     
1084     
1085     // New units may be added in future, but check it matches existing schema so no-one can abuse selling.
1086     function updateGooConfig(address newSchemaAddress) external {
1087         require(msg.sender == owner);
1088         
1089         GooGameConfig newSchema = GooGameConfig(newSchemaAddress);
1090         
1091         requireExistingUnitsSame(newSchema);
1092         requireExistingUpgradesSame(newSchema);
1093         
1094         // Finally update config
1095         schema = GooGameConfig(newSchema);
1096     }
1097     
1098     function requireExistingUnitsSame(GooGameConfig newSchema) internal constant {
1099         // Requires units eth costs match up or fail execution
1100         
1101         uint256 startId;
1102         uint256 endId;
1103         (startId, endId) = schema.productionUnitIdRange();
1104         while (startId <= endId) {
1105             require(schema.unitEthCost(startId) == newSchema.unitEthCost(startId));
1106             require(schema.unitGooProduction(startId) == newSchema.unitGooProduction(startId));
1107             startId++;
1108         }
1109         
1110         (startId, endId) = schema.battleUnitIdRange();
1111         while (startId <= endId) {
1112             require(schema.unitEthCost(startId) == newSchema.unitEthCost(startId));
1113             require(schema.unitAttack(startId) == newSchema.unitAttack(startId));
1114             require(schema.unitDefense(startId) == newSchema.unitDefense(startId));
1115             require(schema.unitStealingCapacity(startId) == newSchema.unitStealingCapacity(startId));
1116             startId++;
1117         }
1118     }
1119     
1120     function requireExistingUpgradesSame(GooGameConfig newSchema) internal constant {
1121         uint256 startId;
1122         uint256 endId;
1123         
1124         // Requires ALL upgrade stats match up or fail execution
1125         (startId, endId) = schema.upgradeIdRange();
1126         while (startId <= endId) {
1127             require(schema.upgradeGooCost(startId) == newSchema.upgradeGooCost(startId));
1128             require(schema.upgradeEthCost(startId) == newSchema.upgradeEthCost(startId));
1129             require(schema.upgradeClass(startId) == newSchema.upgradeClass(startId));
1130             require(schema.upgradeUnitId(startId) == newSchema.upgradeUnitId(startId));
1131             require(schema.upgradeValue(startId) == newSchema.upgradeValue(startId));
1132             startId++;
1133         }
1134         
1135         // Requires ALL rare stats match up or fail execution
1136         (startId, endId) = schema.rareIdRange();
1137         while (startId <= endId) {
1138             uint256 oldClass;
1139             uint256 oldUnitId;
1140             uint256 oldValue;
1141             
1142             uint256 newClass;
1143             uint256 newUnitId;
1144             uint256 newValue;
1145             (oldClass, oldUnitId, oldValue) = schema.getRareInfo(startId);
1146             (newClass, newUnitId, newValue) = newSchema.getRareInfo(startId);
1147             
1148             require(oldClass == newClass);
1149             require(oldUnitId == newUnitId);
1150             require(oldValue == newValue);
1151             startId++;
1152         }
1153     }
1154 }
1155 
1156 
1157 contract GooGameConfig {
1158     
1159     mapping(uint256 => Unit) private unitInfo;
1160     mapping(uint256 => Upgrade) private upgradeInfo;
1161     mapping(uint256 => Rare) private rareInfo;
1162     
1163     uint256 public constant currentNumberOfUnits = 15;
1164     uint256 public constant currentNumberOfUpgrades = 210;
1165     uint256 public constant currentNumberOfRares = 2;
1166     
1167     address public owner;
1168     
1169     struct Unit {
1170         uint256 unitId;
1171         uint256 baseGooCost;
1172         uint256 gooCostIncreaseHalf; // Halfed to make maths slightly less (cancels a 2 out)
1173         uint256 ethCost;
1174         uint256 baseGooProduction;
1175         
1176         uint256 attackValue;
1177         uint256 defenseValue;
1178         uint256 gooStealingCapacity;
1179         bool unitSellable; // Rare units (from raffle) not sellable
1180     }
1181     
1182     struct Upgrade {
1183         uint256 upgradeId;
1184         uint256 gooCost;
1185         uint256 ethCost;
1186         uint256 upgradeClass;
1187         uint256 unitId;
1188         uint256 upgradeValue;
1189         uint256 prerequisiteUpgrade;
1190     }
1191     
1192     struct Rare {
1193         uint256 rareId;
1194         uint256 ethCost;
1195         uint256 rareClass;
1196         uint256 unitId;
1197         uint256 rareValue;
1198     }
1199     
1200     function GooGameConfig() public {
1201         owner = msg.sender;
1202         
1203         rareInfo[1] = Rare(1, 0.5 ether, 1, 1, 40); // 40 = +400%
1204         rareInfo[2] = Rare(2, 0.5 ether, 0, 2, 35); // +35
1205         
1206         unitInfo[1] = Unit(1, 0, 10, 0, 2, 0, 0, 0, true);
1207         unitInfo[2] = Unit(2, 100, 50, 0, 5, 0, 0, 0, true);
1208         unitInfo[3] = Unit(3, 0, 0, 0.01 ether, 100, 0, 0, 0, true);
1209         unitInfo[4] = Unit(4, 200, 100, 0, 10, 0, 0, 0, true);
1210         unitInfo[5] = Unit(5, 500, 250, 0, 20, 0, 0, 0, true);
1211         unitInfo[6] = Unit(6, 1000, 500, 0, 40, 0, 0, 0, true);
1212         unitInfo[7] = Unit(7, 0, 1000, 0.05 ether, 500, 0, 0, 0, true);
1213         unitInfo[8] = Unit(8, 1500, 750, 0, 60, 0, 0, 0, true);
1214         unitInfo[9] = Unit(9, 0, 0, 10 ether, 6000, 0, 0, 0, false); // First secret rare unit from raffle (unsellable)
1215         
1216         unitInfo[40] = Unit(40, 50, 25, 0, 0, 10, 10, 10000, true);
1217         unitInfo[41] = Unit(41, 100, 50, 0, 0, 1, 25, 500, true);
1218         unitInfo[42] = Unit(42, 0, 0, 0.01 ether, 0, 200, 10, 50000, true);
1219         unitInfo[43] = Unit(43, 250, 125, 0, 0, 25, 1, 15000, true);
1220         unitInfo[44] = Unit(44, 500, 250, 0, 0, 20, 40, 5000, true);
1221         unitInfo[45] = Unit(45, 0, 2500, 0.02 ether, 0, 0, 0, 100000, true);
1222     }
1223     
1224     address allowedConfig;
1225     function setConfigSetupContract(address schema) external {
1226         require(msg.sender == owner);
1227         allowedConfig = schema;
1228     }
1229     
1230     function addUpgrade(uint256 id, uint256 goo, uint256 eth, uint256 class, uint256 unit, uint256 value, uint256 prereq) external {
1231         require(msg.sender == allowedConfig);
1232         upgradeInfo[id] = Upgrade(id, goo, eth, class, unit, value, prereq);
1233     }
1234     
1235     function getGooCostForUnit(uint256 unitId, uint256 existing, uint256 amount) public constant returns (uint256) {
1236         Unit storage unit = unitInfo[unitId];
1237         if (amount == 1) { // 1
1238             if (existing == 0) {
1239                 return unit.baseGooCost;
1240             } else {
1241                 return unit.baseGooCost + (existing * unit.gooCostIncreaseHalf * 2);
1242             }
1243         } else if (amount > 1) {
1244             uint256 existingCost;
1245             if (existing > 0) { // Gated by unit limit
1246                 existingCost = (unit.baseGooCost * existing) + (existing * (existing - 1) * unit.gooCostIncreaseHalf);
1247             }
1248             
1249             existing = SafeMath.add(existing, amount);
1250             return SafeMath.add(SafeMath.mul(unit.baseGooCost, existing), SafeMath.mul(SafeMath.mul(existing, (existing - 1)), unit.gooCostIncreaseHalf)) - existingCost;
1251         }
1252     }
1253     
1254     function getWeakenedDefensePower(uint256 defendingPower) external constant returns (uint256) {
1255         return defendingPower / 2;
1256     }
1257     
1258     function validRareId(uint256 rareId) external constant returns (bool) {
1259         return (rareId > 0 && rareId < 3);
1260     }
1261     
1262     function unitSellable(uint256 unitId) external constant returns (bool) {
1263         return unitInfo[unitId].unitSellable;
1264     }
1265     
1266     function unitEthCost(uint256 unitId) external constant returns (uint256) {
1267         return unitInfo[unitId].ethCost;
1268     }
1269     
1270     function unitGooProduction(uint256 unitId) external constant returns (uint256) {
1271         return unitInfo[unitId].baseGooProduction;
1272     }
1273     
1274     function unitAttack(uint256 unitId) external constant returns (uint256) {
1275         return unitInfo[unitId].attackValue;
1276     }
1277     
1278     function unitDefense(uint256 unitId) external constant returns (uint256) {
1279         return unitInfo[unitId].defenseValue;
1280     }
1281     
1282     function unitStealingCapacity(uint256 unitId) external constant returns (uint256) {
1283         return unitInfo[unitId].gooStealingCapacity;
1284     }
1285     
1286     function rareStartPrice(uint256 rareId) external constant returns (uint256) {
1287         return rareInfo[rareId].ethCost;
1288     }
1289     
1290     function upgradeGooCost(uint256 upgradeId) external constant returns (uint256) {
1291         return upgradeInfo[upgradeId].gooCost;
1292     }
1293     
1294     function upgradeEthCost(uint256 upgradeId) external constant returns (uint256) {
1295         return upgradeInfo[upgradeId].ethCost;
1296     }
1297     
1298     function upgradeClass(uint256 upgradeId) external constant returns (uint256) {
1299         return upgradeInfo[upgradeId].upgradeClass;
1300     }
1301     
1302     function upgradeUnitId(uint256 upgradeId) external constant returns (uint256) {
1303         return upgradeInfo[upgradeId].unitId;
1304     }
1305     
1306     function upgradeValue(uint256 upgradeId) external constant returns (uint256) {
1307         return upgradeInfo[upgradeId].upgradeValue;
1308     }
1309     
1310     function productionUnitIdRange() external constant returns (uint256, uint256) {
1311         return (1, 9);
1312     }
1313     
1314     function battleUnitIdRange() external constant returns (uint256, uint256) {
1315         return (40, 45);
1316     }
1317     
1318     function upgradeIdRange() external constant returns (uint256, uint256) {
1319         return (1, 210);
1320     }
1321     
1322     function rareIdRange() external constant returns (uint256, uint256) {
1323         return (1, 2);
1324     }
1325     
1326     function getUpgradeInfo(uint256 upgradeId) external constant returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1327         return (upgradeInfo[upgradeId].gooCost, upgradeInfo[upgradeId].ethCost, upgradeInfo[upgradeId].upgradeClass,
1328         upgradeInfo[upgradeId].unitId, upgradeInfo[upgradeId].upgradeValue, upgradeInfo[upgradeId].prerequisiteUpgrade);
1329     }
1330     
1331     function getRareInfo(uint256 rareId) external constant returns (uint256, uint256, uint256) {
1332         return (rareInfo[rareId].rareClass, rareInfo[rareId].unitId, rareInfo[rareId].rareValue);
1333     }
1334     
1335     function getUnitInfo(uint256 unitId, uint256 existing, uint256 amount) external constant returns (uint256, uint256, uint256, uint256) {
1336         return (unitInfo[unitId].unitId, unitInfo[unitId].baseGooProduction, getGooCostForUnit(unitId, existing, amount), SafeMath.mul(unitInfo[unitId].ethCost, amount));
1337     }
1338     
1339 }
1340 
1341 
1342 library SafeMath {
1343 
1344   /**
1345   * @dev Multiplies two numbers, throws on overflow.
1346   */
1347   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1348     if (a == 0) {
1349       return 0;
1350     }
1351     uint256 c = a * b;
1352     assert(c / a == b);
1353     return c;
1354   }
1355 
1356   /**
1357   * @dev Integer division of two numbers, truncating the quotient.
1358   */
1359   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1360     // assert(b > 0); // Solidity automatically throws when dividing by 0
1361     uint256 c = a / b;
1362     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1363     return c;
1364   }
1365 
1366   /**
1367   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1368   */
1369   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1370     assert(b <= a);
1371     return a - b;
1372   }
1373 
1374   /**
1375   * @dev Adds two numbers, throws on overflow.
1376   */
1377   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1378     uint256 c = a + b;
1379     assert(c >= a);
1380     return c;
1381   }
1382 }