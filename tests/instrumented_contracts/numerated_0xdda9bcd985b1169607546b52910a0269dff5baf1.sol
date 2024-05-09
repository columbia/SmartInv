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
28     uint256 public totalEtherGooResearchPool; // Eth dividends to be split between players' goo production
29     uint256[] public totalGooProductionSnapshots; // The total goo production for each prior day past
30     uint256[] public allocatedGooResearchSnapshots; // The research eth allocated to each prior day past
31     uint256 public nextSnapshotTime;
32     
33     uint256 private MAX_PRODUCTION_UNITS = 999; // Per type (makes balancing slightly easier)
34     uint256 private constant RAFFLE_TICKET_BASE_GOO_PRICE = 1000;
35     
36     // Balances for each player
37     mapping(address => uint256) private ethBalance;
38     mapping(address => uint256) private gooBalance;
39     mapping(address => mapping(uint256 => uint256)) private gooProductionSnapshots; // Store player's goo production for given day (snapshot)
40     mapping(address => mapping(uint256 => bool)) private gooProductionZeroedSnapshots; // This isn't great but we need know difference between 0 production and an unused/inactive day.
41     
42     mapping(address => uint256) private lastGooSaveTime; // Seconds (last time player claimed their produced goo)
43     mapping(address => uint256) public lastGooProductionUpdate; // Days (last snapshot player updated their production)
44     mapping(address => uint256) private lastGooResearchFundClaim; // Days (snapshot number)
45     mapping(address => uint256) private battleCooldown; // If user attacks they cannot attack again for short time
46     
47     // Stuff owned by each player
48     mapping(address => mapping(uint256 => uint256)) private unitsOwned;
49     mapping(address => mapping(uint256 => bool)) private upgradesOwned;
50     mapping(uint256 => address) private rareItemOwner;
51     mapping(uint256 => uint256) private rareItemPrice;
52     
53     // Rares & Upgrades (Increase unit's production / attack etc.)
54     mapping(address => mapping(uint256 => uint256)) private unitGooProductionIncreases; // Adds to the goo per second
55     mapping(address => mapping(uint256 => uint256)) private unitGooProductionMultiplier; // Multiplies the goo per second
56     mapping(address => mapping(uint256 => uint256)) private unitAttackIncreases;
57     mapping(address => mapping(uint256 => uint256)) private unitAttackMultiplier;
58     mapping(address => mapping(uint256 => uint256)) private unitDefenseIncreases;
59     mapping(address => mapping(uint256 => uint256)) private unitDefenseMultiplier;
60     mapping(address => mapping(uint256 => uint256)) private unitGooStealingIncreases;
61     mapping(address => mapping(uint256 => uint256)) private unitGooStealingMultiplier;
62     
63     // Mapping of approved ERC20 transfers (by player)
64     mapping(address => mapping(address => uint256)) private allowed;
65     mapping(address => bool) private protectedAddresses; // For npc exchanges (requires 0 goo production)
66     
67     // Raffle structures
68     struct TicketPurchases {
69         TicketPurchase[] ticketsBought;
70         uint256 numPurchases; // Allows us to reset without clearing TicketPurchase[] (avoids potential for gas limit)
71         uint256 raffleRareId;
72     }
73     
74     // Allows us to query winner without looping (avoiding potential for gas limit)
75     struct TicketPurchase {
76         uint256 startId;
77         uint256 endId;
78     }
79     
80     // Raffle tickets
81     mapping(address => TicketPurchases) private ticketsBoughtByPlayer;
82     mapping(uint256 => address[]) private rafflePlayers; // Keeping a seperate list for each raffle has it's benefits.
83 
84     // Current raffle info
85     uint256 private raffleEndTime;
86     uint256 private raffleRareId;
87     uint256 private raffleTicketsBought;
88     address private raffleWinner; // Address of winner
89     bool private raffleWinningTicketSelected;
90     uint256 private raffleTicketThatWon;
91     
92     // Minor game events
93     event UnitBought(address player, uint256 unitId, uint256 amount);
94     event UnitSold(address player, uint256 unitId, uint256 amount);
95     event PlayerAttacked(address attacker, address target, bool success, uint256 gooStolen);
96     
97     GooGameConfig schema;
98     
99     // Constructor
100     function Goo() public payable {
101         owner = msg.sender;
102         schema = GooGameConfig(0x21912e81d7eff8bff895302b45da76f7f070e3b9);
103     }
104     
105     function() payable { }
106     
107     function beginGame(uint256 firstDivsTime) external payable {
108         require(msg.sender == owner);
109         require(!gameStarted);
110         
111         gameStarted = true; // GO-OOOO!
112         nextSnapshotTime = firstDivsTime;
113         totalEtherGooResearchPool = msg.value; // Seed pot
114     }
115     
116     function totalSupply() public constant returns(uint256) {
117         return roughSupply; // Stored goo (rough supply as it ignores earned/unclaimed goo)
118     }
119     
120     function balanceOf(address player) public constant returns(uint256) {
121         return gooBalance[player] + balanceOfUnclaimedGoo(player);
122     }
123     
124     function balanceOfUnclaimedGoo(address player) internal constant returns (uint256) {
125         if (lastGooSaveTime[player] > 0 && lastGooSaveTime[player] < block.timestamp) {
126             return (getGooProduction(player) * (block.timestamp - lastGooSaveTime[player]));
127         }
128         return 0;
129     }
130     
131     function etherBalanceOf(address player) public constant returns(uint256) {
132         return ethBalance[player];
133     }
134     
135     function transfer(address recipient, uint256 amount) public returns (bool) {
136         updatePlayersGoo(msg.sender);
137         require(amount <= gooBalance[msg.sender]);
138         
139         gooBalance[msg.sender] -= amount;
140         gooBalance[recipient] += amount;
141         
142         emit Transfer(msg.sender, recipient, amount);
143         return true;
144     }
145     
146     function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
147         updatePlayersGoo(player);
148         require(amount <= allowed[player][msg.sender] && amount <= gooBalance[msg.sender]);
149         
150         gooBalance[player] -= amount;
151         gooBalance[recipient] += amount;
152         allowed[player][msg.sender] -= amount;
153         
154         emit Transfer(player, recipient, amount);
155         return true;
156     }
157     
158     function approve(address approvee, uint256 amount) public returns (bool){
159         allowed[msg.sender][approvee] = amount;
160         emit Approval(msg.sender, approvee, amount);
161         return true;
162     }
163     
164     function allowance(address player, address approvee) public constant returns(uint256){
165         return allowed[player][approvee];
166     }
167     
168     function getGooProduction(address player) public constant returns (uint256){
169         return gooProductionSnapshots[player][lastGooProductionUpdate[player]];
170     }
171     
172     function updatePlayersGoo(address player) internal {
173         uint256 gooGain = balanceOfUnclaimedGoo(player);
174         lastGooSaveTime[player] = block.timestamp;
175         roughSupply += gooGain;
176         gooBalance[player] += gooGain;
177     }
178     
179     function updatePlayersGooFromPurchase(address player, uint256 purchaseCost) internal {
180         uint256 unclaimedGoo = balanceOfUnclaimedGoo(player);
181         
182         if (purchaseCost > unclaimedGoo) {
183             uint256 gooDecrease = purchaseCost - unclaimedGoo;
184             roughSupply -= gooDecrease;
185             gooBalance[player] -= gooDecrease;
186         } else {
187             uint256 gooGain = unclaimedGoo - purchaseCost;
188             roughSupply += gooGain;
189             gooBalance[player] += gooGain;
190         }
191         
192         lastGooSaveTime[player] = block.timestamp;
193     }
194     
195     function increasePlayersGooProduction(uint256 increase) internal {
196         gooProductionSnapshots[msg.sender][allocatedGooResearchSnapshots.length] = getGooProduction(msg.sender) + increase;
197         lastGooProductionUpdate[msg.sender] = allocatedGooResearchSnapshots.length;
198         totalGooProduction += increase;
199     }
200     
201     function reducePlayersGooProduction(address player, uint256 decrease) internal {
202         uint256 previousProduction = getGooProduction(player);
203         uint256 newProduction = SafeMath.sub(previousProduction, decrease);
204         
205         if (newProduction == 0) { // Special case which tangles with "inactive day" snapshots (claiming divs)
206             gooProductionZeroedSnapshots[player][allocatedGooResearchSnapshots.length] = true;
207             delete gooProductionSnapshots[player][allocatedGooResearchSnapshots.length]; // 0
208         } else {
209             gooProductionSnapshots[player][allocatedGooResearchSnapshots.length] = newProduction;
210         }
211         
212         lastGooProductionUpdate[player] = allocatedGooResearchSnapshots.length;
213         totalGooProduction -= decrease;
214     }
215     
216     function buyBasicUnit(uint256 unitId, uint256 amount) external {
217         require(gameStarted);
218         require(schema.validUnitId(unitId));
219         require(unitsOwned[msg.sender][unitId] + amount <= MAX_PRODUCTION_UNITS);
220         
221         uint256 unitCost = schema.getGooCostForUnit(unitId, unitsOwned[msg.sender][unitId], amount);
222         require(balanceOf(msg.sender) >= unitCost);
223         require(schema.unitEthCost(unitId) == 0); // Free unit
224         
225         // Update players goo
226         updatePlayersGooFromPurchase(msg.sender, unitCost);
227         
228         if (schema.unitGooProduction(unitId) > 0) {
229             increasePlayersGooProduction(getUnitsProduction(msg.sender, unitId, amount));
230         }
231         
232         unitsOwned[msg.sender][unitId] += amount;
233         emit UnitBought(msg.sender, unitId, amount);
234     }
235     
236     function buyEthUnit(uint256 unitId, uint256 amount) external payable {
237         require(gameStarted);
238         require(schema.validUnitId(unitId));
239         require(unitsOwned[msg.sender][unitId] + amount <= MAX_PRODUCTION_UNITS);
240         
241         uint256 unitCost = schema.getGooCostForUnit(unitId, unitsOwned[msg.sender][unitId], amount);
242         uint256 ethCost = SafeMath.mul(schema.unitEthCost(unitId), amount);
243         
244         require(balanceOf(msg.sender) >= unitCost);
245         require(ethBalance[msg.sender] + msg.value >= ethCost);
246         
247         // Update players goo
248         updatePlayersGooFromPurchase(msg.sender, unitCost);
249 
250         if (ethCost > msg.value) {
251             ethBalance[msg.sender] -= (ethCost - msg.value);
252         }
253         
254         uint256 devFund = ethCost / 50; // 2% fee on purchases (marketing, gameplay & maintenance)
255         uint256 dividends = (ethCost - devFund) / 4; // 25% goes to pool (75% retained for sale value)
256         totalEtherGooResearchPool += dividends;
257         ethBalance[owner] += devFund;
258         
259         if (schema.unitGooProduction(unitId) > 0) {
260             increasePlayersGooProduction(getUnitsProduction(msg.sender, unitId, amount));
261         }
262         
263         unitsOwned[msg.sender][unitId] += amount;
264         emit UnitBought(msg.sender, unitId, amount);
265     }
266     
267     function sellUnit(uint256 unitId, uint256 amount) external {
268         require(unitsOwned[msg.sender][unitId] >= amount);
269         unitsOwned[msg.sender][unitId] -= amount;
270         
271         uint256 unitSalePrice = (schema.getGooCostForUnit(unitId, unitsOwned[msg.sender][unitId], amount) * 3) / 4; // 75%
272         uint256 gooChange = balanceOfUnclaimedGoo(msg.sender) + unitSalePrice; // Claim unsaved goo whilst here
273         lastGooSaveTime[msg.sender] = block.timestamp;
274         roughSupply += gooChange;
275         gooBalance[msg.sender] += gooChange;
276         
277         if (schema.unitGooProduction(unitId) > 0) {
278             reducePlayersGooProduction(msg.sender, getUnitsProduction(msg.sender, unitId, amount));
279         }
280         
281         if (schema.unitEthCost(unitId) > 0) { // Premium units sell for 75% of buy cost
282             ethBalance[msg.sender] += ((schema.unitEthCost(unitId) * amount) * 3) / 4;
283         }
284         emit UnitSold(msg.sender, unitId, amount);
285     }
286     
287     function buyUpgrade(uint256 upgradeId) external payable {
288         require(gameStarted);
289         require(schema.validUpgradeId(upgradeId)); // Valid upgrade
290         require(!upgradesOwned[msg.sender][upgradeId]); // Haven't already purchased
291         
292         uint256 gooCost;
293         uint256 ethCost;
294         uint256 upgradeClass;
295         uint256 unitId;
296         uint256 upgradeValue;
297         (gooCost, ethCost, upgradeClass, unitId, upgradeValue) = schema.getUpgradeInfo(upgradeId);
298         
299         require(balanceOf(msg.sender) >= gooCost);
300         
301         if (ethCost > 0) {
302             require(ethBalance[msg.sender] + msg.value >= ethCost);
303              if (ethCost > msg.value) { // They can use their balance instead
304                 ethBalance[msg.sender] -= (ethCost - msg.value);
305             }
306         
307             uint256 devFund = ethCost / 50; // 2% fee on purchases (marketing, gameplay & maintenance)
308             totalEtherGooResearchPool += (ethCost - devFund); // Rest goes to div pool (Can't sell upgrades)
309             ethBalance[owner] += devFund;
310         }
311         
312         // Update players goo
313         updatePlayersGooFromPurchase(msg.sender, gooCost);
314 
315         upgradeUnitMultipliers(msg.sender, upgradeClass, unitId, upgradeValue);
316         upgradesOwned[msg.sender][upgradeId] = true;
317     }
318     
319     function upgradeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) internal {
320         uint256 productionGain;
321         if (upgradeClass == 0) {
322             unitGooProductionIncreases[player][unitId] += upgradeValue;
323             productionGain = (unitsOwned[player][unitId] * upgradeValue * (10 + unitGooProductionMultiplier[player][unitId])) / 10;
324             increasePlayersGooProduction(productionGain);
325         } else if (upgradeClass == 1) {
326             unitGooProductionMultiplier[player][unitId] += upgradeValue;
327             productionGain = (unitsOwned[player][unitId] * upgradeValue * (schema.unitGooProduction(unitId) + unitGooProductionIncreases[player][unitId])) / 10;
328             increasePlayersGooProduction(productionGain);
329         } else if (upgradeClass == 2) {
330             unitAttackIncreases[player][unitId] += upgradeValue;
331         } else if (upgradeClass == 3) {
332             unitAttackMultiplier[player][unitId] += upgradeValue;
333         } else if (upgradeClass == 4) {
334             unitDefenseIncreases[player][unitId] += upgradeValue;
335         } else if (upgradeClass == 5) {
336             unitDefenseMultiplier[player][unitId] += upgradeValue;
337         } else if (upgradeClass == 6) {
338             unitGooStealingIncreases[player][unitId] += upgradeValue;
339         } else if (upgradeClass == 7) {
340             unitGooStealingMultiplier[player][unitId] += upgradeValue;
341         }
342     }
343     
344     function removeUnitMultipliers(address player, uint256 upgradeClass, uint256 unitId, uint256 upgradeValue) internal {
345         uint256 productionLoss;
346         if (upgradeClass == 0) {
347             unitGooProductionIncreases[player][unitId] -= upgradeValue;
348             productionLoss = (unitsOwned[player][unitId] * upgradeValue * (10 + unitGooProductionMultiplier[player][unitId])) / 10;
349             reducePlayersGooProduction(player, productionLoss);
350         } else if (upgradeClass == 1) {
351             unitGooProductionMultiplier[player][unitId] -= upgradeValue;
352             productionLoss = (unitsOwned[player][unitId] * upgradeValue * (schema.unitGooProduction(unitId) + unitGooProductionIncreases[player][unitId])) / 10;
353             reducePlayersGooProduction(player, productionLoss);
354         } else if (upgradeClass == 2) {
355             unitAttackIncreases[player][unitId] -= upgradeValue;
356         } else if (upgradeClass == 3) {
357             unitAttackMultiplier[player][unitId] -= upgradeValue;
358         } else if (upgradeClass == 4) {
359             unitDefenseIncreases[player][unitId] -= upgradeValue;
360         } else if (upgradeClass == 5) {
361             unitDefenseMultiplier[player][unitId] -= upgradeValue;
362         } else if (upgradeClass == 6) {
363             unitGooStealingIncreases[player][unitId] -= upgradeValue;
364         } else if (upgradeClass == 7) {
365             unitGooStealingMultiplier[player][unitId] -= upgradeValue;
366         }
367     }
368     
369     function buyRareItem(uint256 rareId) external payable {
370         require(schema.validRareId(rareId));
371         
372         address previousOwner = rareItemOwner[rareId];
373         require(previousOwner != 0);
374 
375         uint256 ethCost = rareItemPrice[rareId];
376         require(ethBalance[msg.sender] + msg.value >= ethCost);
377         
378         // We have to claim buyer's goo before updating their production values
379         updatePlayersGoo(msg.sender);
380         
381         uint256 upgradeClass;
382         uint256 unitId;
383         uint256 upgradeValue;
384         (upgradeClass, unitId, upgradeValue) = schema.getRareInfo(rareId);
385         upgradeUnitMultipliers(msg.sender, upgradeClass, unitId, upgradeValue);
386         
387         // We have to claim seller's goo before reducing their production values
388         updatePlayersGoo(previousOwner);
389         removeUnitMultipliers(previousOwner, upgradeClass, unitId, upgradeValue);
390         
391         // Splitbid/Overbid
392         if (ethCost > msg.value) {
393             // Earlier require() said they can still afford it (so use their ingame balance)
394             ethBalance[msg.sender] -= (ethCost - msg.value);
395         } else if (msg.value > ethCost) {
396             // Store overbid in their balance
397             ethBalance[msg.sender] += msg.value - ethCost;
398         }
399         
400         // Distribute ethCost
401         uint256 devFund = ethCost / 50; // 2% fee on purchases (marketing, gameplay & maintenance)
402         uint256 dividends = ethCost / 20; // 5% goes to pool (~93% goes to player)
403         totalEtherGooResearchPool += dividends;
404         ethBalance[owner] += devFund;
405         
406         // Transfer / update rare item
407         rareItemOwner[rareId] = msg.sender;
408         rareItemPrice[rareId] = (ethCost * 5) / 4; // 25% price flip increase
409         ethBalance[previousOwner] += ethCost - (dividends + devFund);
410     }
411     
412     function withdrawEther(uint256 amount) external {
413         require(amount <= ethBalance[msg.sender]);
414         ethBalance[msg.sender] -= amount;
415         msg.sender.transfer(amount);
416     }
417     
418     function claimResearchDividends(address referer, uint256 startSnapshot, uint256 endSnapShot) external {
419         require(startSnapshot <= endSnapShot);
420         require(startSnapshot >= lastGooResearchFundClaim[msg.sender]);
421         require(endSnapShot < allocatedGooResearchSnapshots.length);
422         
423         uint256 researchShare;
424         uint256 previousProduction = gooProductionSnapshots[msg.sender][lastGooResearchFundClaim[msg.sender] - 1]; // Underflow won't be a problem as gooProductionSnapshots[][0xffffffffff] = 0;
425         for (uint256 i = startSnapshot; i <= endSnapShot; i++) {
426             
427             // Slightly complex things by accounting for days/snapshots when user made no tx's
428             uint256 productionDuringSnapshot = gooProductionSnapshots[msg.sender][i];
429             bool soldAllProduction = gooProductionZeroedSnapshots[msg.sender][i];
430             if (productionDuringSnapshot == 0 && !soldAllProduction) {
431                 productionDuringSnapshot = previousProduction;
432             } else {
433                previousProduction = productionDuringSnapshot;
434             }
435             
436             researchShare += (allocatedGooResearchSnapshots[i] * productionDuringSnapshot) / totalGooProductionSnapshots[i];
437         }
438         
439         
440         if (gooProductionSnapshots[msg.sender][endSnapShot] == 0 && !gooProductionZeroedSnapshots[msg.sender][i] && previousProduction > 0) {
441             gooProductionSnapshots[msg.sender][endSnapShot] = previousProduction; // Checkpoint for next claim
442         }
443         
444         lastGooResearchFundClaim[msg.sender] = endSnapShot + 1;
445         
446         uint256 referalDivs;
447         if (referer != address(0) && referer != msg.sender) {
448             referalDivs = researchShare / 100; // 1%
449             ethBalance[referer] += referalDivs;
450         }
451         
452         ethBalance[msg.sender] += researchShare - referalDivs;
453     }
454     
455     // Allocate divs for the day (cron job)
456     function snapshotDailyGooResearchFunding() external {
457         require(msg.sender == owner);
458         //require(block.timestamp >= (nextSnapshotTime - 30 minutes)); // Small bit of leeway for cron / network
459         
460         uint256 todaysEtherResearchFund = (totalEtherGooResearchPool / 10); // 10% of pool daily
461         totalEtherGooResearchPool -= todaysEtherResearchFund;
462         
463         totalGooProductionSnapshots.push(totalGooProduction);
464         allocatedGooResearchSnapshots.push(todaysEtherResearchFund);
465         nextSnapshotTime = block.timestamp + 24 hours;
466     }
467     
468     
469     
470     // Raffle for rare items
471     function buyRaffleTicket(uint256 amount) external {
472         require(raffleEndTime >= block.timestamp);
473         require(amount > 0);
474         
475         uint256 ticketsCost = SafeMath.mul(RAFFLE_TICKET_BASE_GOO_PRICE, amount);
476         require(balanceOf(msg.sender) >= ticketsCost);
477         
478         // Update players goo
479         updatePlayersGooFromPurchase(msg.sender, ticketsCost);
480         
481         // Handle new tickets
482         TicketPurchases storage purchases = ticketsBoughtByPlayer[msg.sender];
483         
484         // If we need to reset tickets from a previous raffle
485         if (purchases.raffleRareId != raffleRareId) {
486             purchases.numPurchases = 0;
487             purchases.raffleRareId = raffleRareId;
488             rafflePlayers[raffleRareId].push(msg.sender); // Add user to raffle
489         }
490         
491         // Store new ticket purchase 
492         if (purchases.numPurchases == purchases.ticketsBought.length) {
493             purchases.ticketsBought.length += 1;
494         }
495         purchases.ticketsBought[purchases.numPurchases++] = TicketPurchase(raffleTicketsBought, raffleTicketsBought + (amount - 1)); // (eg: buy 10, get id's 0-9)
496         
497         // Finally update ticket total
498         raffleTicketsBought += amount;
499     }
500     
501     function startRareRaffle(uint256 endTime, uint256 rareId) external {
502         require(msg.sender == owner);
503         require(schema.validRareId(rareId));
504         require(rareItemOwner[rareId] == 0);
505         
506         // Reset previous raffle info
507         raffleWinningTicketSelected = false;
508         raffleTicketThatWon = 0;
509         raffleWinner = 0;
510         raffleTicketsBought = 0;
511         
512         // Set current raffle info
513         raffleEndTime = endTime;
514         raffleRareId = rareId;
515     }
516     
517     function awardRafflePrize(address checkWinner, uint256 checkIndex) external {
518         require(raffleEndTime < block.timestamp);
519         require(raffleWinner == 0);
520         require(rareItemOwner[raffleRareId] == 0);
521         
522         if (!raffleWinningTicketSelected) {
523             drawRandomWinner(); // Ideally do it in one call (gas limit cautious)
524         }
525         
526         // Reduce gas by (optionally) offering an address to _check_ for winner
527         if (checkWinner != 0) {
528             TicketPurchases storage tickets = ticketsBoughtByPlayer[checkWinner];
529             if (tickets.numPurchases > 0 && checkIndex < tickets.numPurchases && tickets.raffleRareId == raffleRareId) {
530                 TicketPurchase storage checkTicket = tickets.ticketsBought[checkIndex];
531                 if (raffleTicketThatWon >= checkTicket.startId && raffleTicketThatWon <= checkTicket.endId) {
532                     assignRafflePrize(checkWinner); // WINNER!
533                     return;
534                 }
535             }
536         }
537         
538         // Otherwise just naively try to find the winner (will work until mass amounts of players)
539         for (uint256 i = 0; i < rafflePlayers[raffleRareId].length; i++) {
540             address player = rafflePlayers[raffleRareId][i];
541             TicketPurchases storage playersTickets = ticketsBoughtByPlayer[player];
542             
543             uint256 endIndex = playersTickets.numPurchases - 1;
544             // Minor optimization to avoid checking every single player
545             if (raffleTicketThatWon >= playersTickets.ticketsBought[0].startId && raffleTicketThatWon <= playersTickets.ticketsBought[endIndex].endId) {
546                 for (uint256 j = 0; j < playersTickets.numPurchases; j++) {
547                     TicketPurchase storage playerTicket = playersTickets.ticketsBought[j];
548                     if (raffleTicketThatWon >= playerTicket.startId && raffleTicketThatWon <= playerTicket.endId) {
549                         assignRafflePrize(player); // WINNER!
550                         return;
551                     }
552                 }
553             }
554         }
555     }
556     
557     function assignRafflePrize(address winner) internal {
558         raffleWinner = winner;
559         rareItemOwner[raffleRareId] = winner;
560         rareItemPrice[raffleRareId] = (schema.rareStartPrice(raffleRareId) * 21) / 20; // Buy price slightly higher (Div pool cut)
561         
562         updatePlayersGoo(winner);
563         uint256 upgradeClass;
564         uint256 unitId;
565         uint256 upgradeValue;
566         (upgradeClass, unitId, upgradeValue) = schema.getRareInfo(raffleRareId);
567         upgradeUnitMultipliers(winner, upgradeClass, unitId, upgradeValue);
568     }
569     
570     // Random enough for small contests (Owner only to prevent trial & error execution)
571     function drawRandomWinner() public {
572         require(msg.sender == owner);
573         require(raffleEndTime < block.timestamp);
574         require(!raffleWinningTicketSelected);
575         
576         uint256 seed = raffleTicketsBought + block.timestamp;
577         raffleTicketThatWon = addmod(uint256(block.blockhash(block.number-1)), seed, raffleTicketsBought);
578         raffleWinningTicketSelected = true;
579     }
580     
581     
582     
583     function protectAddress(address exchange, bool isProtected) external {
584         require(msg.sender == owner);
585         require(getGooProduction(exchange) == 0); // Can't protect actual players
586         protectedAddresses[exchange] = isProtected;
587     }
588     
589     function attackPlayer(address target) external {
590         require(battleCooldown[msg.sender] < block.timestamp);
591         require(target != msg.sender);
592         require(!protectedAddresses[target]); //target not whitelisted (i.e. exchange wallets)
593         
594         uint256 attackingPower;
595         uint256 defendingPower;
596         uint256 stealingPower;
597         (attackingPower, defendingPower, stealingPower) = getPlayersBattlePower(msg.sender, target);
598         
599         if (battleCooldown[target] > block.timestamp) { // When on battle cooldown you're vulnerable (starting value is 50% normal power)
600             defendingPower = schema.getWeakenedDefensePower(defendingPower);
601         }
602         
603         if (attackingPower > defendingPower) {
604             battleCooldown[msg.sender] = block.timestamp + 30 minutes;
605             if (balanceOf(target) > stealingPower) {
606                 // Save all their unclaimed goo, then steal attacker's max capacity (at same time)
607                 uint256 unclaimedGoo = balanceOfUnclaimedGoo(target);
608                 if (stealingPower > unclaimedGoo) {
609                     uint256 gooDecrease = stealingPower - unclaimedGoo;
610                     gooBalance[target] -= gooDecrease;
611                 } else {
612                     uint256 gooGain = unclaimedGoo - stealingPower;
613                     gooBalance[target] += gooGain;
614                 }
615                 gooBalance[msg.sender] += stealingPower;
616                 emit PlayerAttacked(msg.sender, target, true, stealingPower);
617             } else {
618                 emit PlayerAttacked(msg.sender, target, true, balanceOf(target));
619                 gooBalance[msg.sender] += balanceOf(target);
620                 gooBalance[target] = 0;
621             }
622             
623             lastGooSaveTime[target] = block.timestamp; 
624             // We don't need to claim/save msg.sender's goo (as production delta is unchanged)
625         } else {
626             battleCooldown[msg.sender] = block.timestamp + 10 minutes;
627             emit PlayerAttacked(msg.sender, target, false, 0);
628         }
629     }
630     
631     function getPlayersBattlePower(address attacker, address defender) internal constant returns (uint256, uint256, uint256) {
632         uint256 startId;
633         uint256 endId;
634         (startId, endId) = schema.battleUnitIdRange();
635         
636         uint256 attackingPower;
637         uint256 defendingPower;
638         uint256 stealingPower;
639 
640         // Not ideal but will only be a small number of units (and saves gas when buying units)
641         while (startId <= endId) {
642             attackingPower += getUnitsAttack(attacker, startId, unitsOwned[attacker][startId]);
643             stealingPower += getUnitsStealingCapacity(attacker, startId, unitsOwned[attacker][startId]);
644             
645             defendingPower += getUnitsDefense(defender, startId, unitsOwned[defender][startId]);
646             startId++;
647         }
648         return (attackingPower, defendingPower, stealingPower);
649     }
650     
651     function getPlayersBattleStats(address player) external constant returns (uint256, uint256, uint256) {
652         uint256 startId;
653         uint256 endId;
654         (startId, endId) = schema.battleUnitIdRange();
655         
656         uint256 attackingPower;
657         uint256 defendingPower;
658         uint256 stealingPower;
659 
660         // Not ideal but will only be a small number of units (and saves gas when buying units)
661         while (startId <= endId) {
662             attackingPower += getUnitsAttack(player, startId, unitsOwned[player][startId]);
663             stealingPower += getUnitsStealingCapacity(player, startId, unitsOwned[player][startId]);
664             defendingPower += getUnitsDefense(player, startId, unitsOwned[player][startId]);
665             startId++;
666         }
667         return (attackingPower, defendingPower, stealingPower);
668     }
669     
670     function getUnitsProduction(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
671         return (amount * (schema.unitGooProduction(unitId) + unitGooProductionIncreases[player][unitId]) * (10 + unitGooProductionMultiplier[player][unitId])) / 10;
672     }
673     
674     function getUnitsAttack(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
675         return (amount * (schema.unitAttack(unitId) + unitAttackIncreases[player][unitId]) * (10 + unitAttackMultiplier[player][unitId])) / 10;
676     }
677     
678     function getUnitsDefense(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
679         return (amount * (schema.unitDefense(unitId) + unitDefenseIncreases[player][unitId]) * (10 + unitDefenseMultiplier[player][unitId])) / 10;
680     }
681     
682     function getUnitsStealingCapacity(address player, uint256 unitId, uint256 amount) internal constant returns (uint256) {
683         return (amount * (schema.unitStealingCapacity(unitId) + unitGooStealingIncreases[player][unitId]) * (10 + unitGooStealingMultiplier[player][unitId])) / 10;
684     }
685     
686     
687     // To display on website
688     function getGameInfo() external constant returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256[], bool[]){
689         uint256[] memory units = new uint256[](schema.currentNumberOfUnits());
690         bool[] memory upgrades = new bool[](schema.currentNumberOfUpgrades());
691         
692         uint256 startId;
693         uint256 endId;
694         (startId, endId) = schema.productionUnitIdRange();
695         
696         uint256 i;
697         while (startId <= endId) {
698             units[i] = unitsOwned[msg.sender][startId];
699             i++;
700             startId++;
701         }
702         
703         (startId, endId) = schema.battleUnitIdRange();
704         while (startId <= endId) {
705             units[i] = unitsOwned[msg.sender][startId];
706             i++;
707             startId++;
708         }
709         
710         // Reset for upgrades
711         i = 0;
712         (startId, endId) = schema.upgradeIdRange();
713         while (startId <= endId) {
714             upgrades[i] = upgradesOwned[msg.sender][startId];
715             i++;
716             startId++;
717         }
718         
719         return (block.timestamp, totalEtherGooResearchPool, totalGooProduction, nextSnapshotTime, balanceOf(msg.sender), ethBalance[msg.sender], getGooProduction(msg.sender), units, upgrades);
720     }
721     
722     // To display on website
723     function getRareItemInfo() external constant returns (address[], uint256[]) {
724         address[] memory itemOwners = new address[](schema.currentNumberOfRares());
725         uint256[] memory itemPrices = new uint256[](schema.currentNumberOfRares());
726         
727         uint256 startId;
728         uint256 endId;
729         (startId, endId) = schema.rareIdRange();
730         
731         uint256 i;
732         while (startId <= endId) {
733             itemOwners[i] = rareItemOwner[startId];
734             itemPrices[i] = rareItemPrice[startId];
735             
736             i++;
737             startId++;
738         }
739         
740         return (itemOwners, itemPrices);
741     }
742     
743     // To display on website
744      function viewUnclaimedResearchDividends() external constant returns (uint256, uint256, uint256) {
745         uint256 startSnapshot = lastGooResearchFundClaim[msg.sender];
746         uint256 latestSnapshot = allocatedGooResearchSnapshots.length - 1; // No snapshots to begin with
747         
748         uint256 researchShare;
749         uint256 previousProduction = gooProductionSnapshots[msg.sender][lastGooResearchFundClaim[msg.sender] - 1]; // Underflow won't be a problem as gooProductionSnapshots[][0xfffffffffffff] = 0;
750         for (uint256 i = startSnapshot; i <= latestSnapshot; i++) {
751             
752             // Slightly complex things by accounting for days/snapshots when user made no tx's
753             uint256 productionDuringSnapshot = gooProductionSnapshots[msg.sender][i];
754             bool soldAllProduction = gooProductionZeroedSnapshots[msg.sender][i];
755             if (productionDuringSnapshot == 0 && !soldAllProduction) {
756                 productionDuringSnapshot = previousProduction;
757             } else {
758                previousProduction = productionDuringSnapshot;
759             }
760             
761             researchShare += (allocatedGooResearchSnapshots[i] * productionDuringSnapshot) / totalGooProductionSnapshots[i];
762         }
763         return (researchShare, startSnapshot, latestSnapshot);
764     }
765     
766     
767     // To allow clients to verify contestants
768     function getRafflePlayers(uint256 raffleId) external constant returns (address[]) {
769         return (rafflePlayers[raffleId]);
770     }
771     
772     // To allow clients to verify contestants
773     function getPlayersTickets(address player) external constant returns (uint256[], uint256[]) {
774         TicketPurchases storage playersTickets = ticketsBoughtByPlayer[player];
775         
776         if (playersTickets.raffleRareId == raffleRareId) {
777             uint256[] memory startIds = new uint256[](playersTickets.numPurchases);
778             uint256[] memory endIds = new uint256[](playersTickets.numPurchases);
779             
780             for (uint256 i = 0; i < playersTickets.numPurchases; i++) {
781                 startIds[i] = playersTickets.ticketsBought[i].startId;
782                 endIds[i] = playersTickets.ticketsBought[i].endId;
783             }
784         }
785         
786         return (startIds, endIds);
787     }
788     
789     // To display on website
790     function getLatestRaffleInfo() external constant returns (uint256, uint256, uint256, address, uint256) {
791         return (raffleEndTime, raffleRareId, raffleTicketsBought, raffleWinner, raffleTicketThatWon);
792     }
793     
794     
795     // New units may be added in future, but check it matches existing schema so no-one can abuse selling.
796     function updateGooConfig(address newSchemaAddress) external {
797         require(msg.sender == owner);
798         
799         GooGameConfig newSchema = GooGameConfig(newSchemaAddress);
800         requireExistingUnitsSame(newSchema);
801         requireExistingUpgradesSame(newSchema);
802         
803         // Finally update config
804         schema = GooGameConfig(newSchema);
805     }
806     
807     function requireExistingUnitsSame(GooGameConfig newSchema) internal constant {
808         // Requires units eth costs match up or fail execution
809         
810         uint256 startId;
811         uint256 endId;
812         (startId, endId) = schema.productionUnitIdRange();
813         while (startId <= endId) {
814             require(schema.unitEthCost(startId) == newSchema.unitEthCost(startId));
815             require(schema.unitGooProduction(startId) == newSchema.unitGooProduction(startId));
816             startId++;
817         }
818         
819         (startId, endId) = schema.battleUnitIdRange();
820         while (startId <= endId) {
821             require(schema.unitEthCost(startId) == newSchema.unitEthCost(startId));
822             require(schema.unitAttack(startId) == newSchema.unitAttack(startId));
823             require(schema.unitDefense(startId) == newSchema.unitDefense(startId));
824             require(schema.unitStealingCapacity(startId) == newSchema.unitStealingCapacity(startId));
825             startId++;
826         }
827     }
828     
829     function requireExistingUpgradesSame(GooGameConfig newSchema) internal constant {
830         uint256 startId;
831         uint256 endId;
832         
833         uint256 oldClass;
834         uint256 oldUnitId;
835         uint256 oldValue;
836         
837         uint256 newClass;
838         uint256 newUnitId;
839         uint256 newValue;
840         
841         // Requires ALL upgrade stats match up or fail execution
842         (startId, endId) = schema.rareIdRange();
843         while (startId <= endId) {
844             uint256 oldGooCost;
845             uint256 oldEthCost;
846             (oldGooCost, oldEthCost, oldClass, oldUnitId, oldValue) = schema.getUpgradeInfo(startId);
847             
848             uint256 newGooCost;
849             uint256 newEthCost;
850             (newGooCost, newEthCost, newClass, newUnitId, newValue) = newSchema.getUpgradeInfo(startId);
851             
852             require(oldGooCost == newGooCost);
853             require(oldEthCost == oldEthCost);
854             require(oldClass == oldClass);
855             require(oldUnitId == newUnitId);
856             require(oldValue == newValue);
857             startId++;
858         }
859         
860         // Requires ALL rare stats match up or fail execution
861         (startId, endId) = schema.rareIdRange();
862         while (startId <= endId) {
863             (oldClass, oldUnitId, oldValue) = schema.getRareInfo(startId);
864             (newClass, newUnitId, newValue) = newSchema.getRareInfo(startId);
865             
866             require(oldClass == newClass);
867             require(oldUnitId == newUnitId);
868             require(oldValue == newValue);
869             startId++;
870         }
871     }
872 }
873 
874 
875 contract GooGameConfig {
876     
877     mapping(uint256 => Unit) private unitInfo;
878     mapping(uint256 => Upgrade) private upgradeInfo;
879     mapping(uint256 => Rare) private rareInfo;
880     
881     uint256 public constant currentNumberOfUnits = 14;
882     uint256 public constant currentNumberOfUpgrades = 42;
883     uint256 public constant currentNumberOfRares = 2;
884     
885     struct Unit {
886         uint256 unitId;
887         uint256 baseGooCost;
888         uint256 gooCostIncreaseHalf; // Halfed to make maths slightly less (cancels a 2 out)
889         uint256 ethCost;
890         uint256 baseGooProduction;
891         
892         uint256 attackValue;
893         uint256 defenseValue;
894         uint256 gooStealingCapacity;
895     }
896     
897     struct Upgrade {
898         uint256 upgradeId;
899         uint256 gooCost;
900         uint256 ethCost;
901         uint256 upgradeClass;
902         uint256 unitId;
903         uint256 upgradeValue;
904     }
905     
906      struct Rare {
907         uint256 rareId;
908         uint256 ethCost;
909         uint256 rareClass;
910         uint256 unitId;
911         uint256 rareValue;
912     }
913     
914     // Constructor
915     function GooGameConfig() public {
916         
917         unitInfo[1] = Unit(1, 0, 10, 0, 1, 0, 0, 0);
918         unitInfo[2] = Unit(2, 100, 50, 0, 2, 0, 0, 0);
919         unitInfo[3] = Unit(3, 0, 0, 0.01 ether, 12, 0, 0, 0);
920         unitInfo[4] = Unit(4, 500, 250, 0, 4, 0, 0, 0);
921         unitInfo[5] = Unit(5, 2500, 1250, 0, 6, 0, 0, 0);
922         unitInfo[6] = Unit(6, 10000, 5000, 0, 8, 0, 0, 0);
923         unitInfo[7] = Unit(7, 0, 1000, 0.05 ether, 60, 0, 0, 0);
924         unitInfo[8] = Unit(8, 25000, 12500, 0, 10, 0, 0, 0);
925         
926         unitInfo[40] = Unit(40, 100, 50, 0, 0, 10, 10, 20);
927         unitInfo[41] = Unit(41, 250, 125, 0, 0, 1, 25, 1);
928         unitInfo[42] = Unit(42, 0, 50, 0.01 ether, 0, 100, 10, 5);
929         unitInfo[43] = Unit(43, 1000, 500, 0, 0, 25, 1, 50);
930         unitInfo[44] = Unit(44, 2500, 1250, 0, 0, 20, 40, 100);
931         unitInfo[45] = Unit(45, 0, 500, 0.02 ether, 0, 0, 0, 1000);
932         
933         upgradeInfo[1] = Upgrade(1, 500, 0, 0, 1, 1); // +1
934         upgradeInfo[2] = Upgrade(2, 0, 0.1 ether, 1, 1, 10); // 10 = +100%
935         upgradeInfo[3] = Upgrade(3, 10000, 0, 1, 1, 5); // 5 = +50%
936         
937         upgradeInfo[4] = Upgrade(4, 0, 0.1 ether, 0, 2, 2); // +1
938         upgradeInfo[5] = Upgrade(5, 2000, 0, 1, 2, 5); // 10 = +50%
939         upgradeInfo[6] = Upgrade(6, 0, 0.2 ether, 0, 2, 2); // +2
940         
941         upgradeInfo[7] = Upgrade(7, 2500, 0, 0, 3, 2); // +2
942         upgradeInfo[8] = Upgrade(8, 0, 0.5 ether, 1, 3, 10); // 10 = +100%
943         upgradeInfo[9] = Upgrade(9, 25000, 0, 1, 3, 5); // 5 = +50%
944         
945         upgradeInfo[10] = Upgrade(10, 0, 0.1 ether, 0, 4, 1); // +1
946         upgradeInfo[11] = Upgrade(11, 5000, 0, 1, 4, 5); // 10 = +50%
947         upgradeInfo[12] = Upgrade(12, 0, 0.2 ether, 0, 4, 2); // +2
948         
949         upgradeInfo[13] = Upgrade(13, 10000, 0, 0, 5, 2); // +2
950         upgradeInfo[14] = Upgrade(14, 0, 0.5 ether, 1, 5, 10); // 10 = +100%
951         upgradeInfo[15] = Upgrade(15, 25000, 0, 1, 5, 5); // 5 = +50%
952         
953         upgradeInfo[16] = Upgrade(16, 0, 0.1 ether, 0, 6, 1); // +1
954         upgradeInfo[17] = Upgrade(17, 25000, 0, 1, 6, 5); // 10 = +50%
955         upgradeInfo[18] = Upgrade(18, 0, 0.2 ether, 0, 6, 2); // +2
956         
957         upgradeInfo[19] = Upgrade(13, 50000, 0, 0, 7, 2); // +2
958         upgradeInfo[20] = Upgrade(20, 0, 0.2 ether, 1, 7, 5); // 5 = +50%
959         upgradeInfo[21] = Upgrade(21, 100000, 0, 1, 7, 5); // 5 = +50%
960         
961         upgradeInfo[22] = Upgrade(22, 0, 0.1 ether, 0, 8, 2); // +1
962         upgradeInfo[23] = Upgrade(23, 25000, 0, 1, 8, 5); // 10 = +50%
963         upgradeInfo[24] = Upgrade(24, 0, 0.2 ether, 0, 8, 4); // +2
964         
965         
966         
967         upgradeInfo[25] = Upgrade(25, 500, 0, 2, 40, 10); // +10
968         upgradeInfo[26] = Upgrade(26, 0, 0.1 ether, 4, 40, 10); // +10
969         upgradeInfo[27] = Upgrade(27, 10000, 0, 6, 40, 10); // +10
970         
971         upgradeInfo[28] = Upgrade(28, 0, 0.2 ether, 3, 41, 5); // +50 %
972         upgradeInfo[29] = Upgrade(29, 5000, 0, 4, 41, 10); // +10
973         upgradeInfo[30] = Upgrade(30, 0, 0.5 ether, 6, 41, 4); // +4
974         
975         upgradeInfo[31] = Upgrade(31, 2500, 0, 5, 42, 5); // +50 %
976         upgradeInfo[32] = Upgrade(32, 0, 0.2 ether, 6, 42, 10); // +10
977         upgradeInfo[33] = Upgrade(33, 20000, 0, 7, 42, 5); // +50 %
978         
979         upgradeInfo[34] = Upgrade(34, 0, 0.1 ether, 2, 43, 5); // +5
980         upgradeInfo[35] = Upgrade(35, 10000, 0, 4, 43, 5); // +5
981         upgradeInfo[36] = Upgrade(36, 0, 0.2 ether, 5, 43, 5); // +50%
982         
983         upgradeInfo[37] = Upgrade(37, 0, 0.1 ether, 2, 44, 15); // +15
984         upgradeInfo[38] = Upgrade(38, 25000, 0, 3, 44, 5); // +50%
985         upgradeInfo[39] = Upgrade(39, 0, 0.2 ether, 4, 44, 15); // +15
986         
987         upgradeInfo[40] = Upgrade(40, 50000, 0, 6, 45, 500); // +500
988         upgradeInfo[41] = Upgrade(41, 0, 0.5 ether, 7, 45, 10); // +100 %
989         upgradeInfo[42] = Upgrade(42, 250000, 0, 7, 45, 5); // +50 %
990     
991         
992         rareInfo[1] = Rare(1, 0.5 ether, 1, 1, 30); // 30 = +300%
993         rareInfo[2] = Rare(2, 0.5 ether, 0, 2, 4); // +4
994     }
995     
996     function getGooCostForUnit(uint256 unitId, uint256 existing, uint256 amount) public constant returns (uint256) {
997         if (amount == 1) { // 1
998             if (existing == 0) {
999                 return unitInfo[unitId].baseGooCost;
1000             } else {
1001                 return unitInfo[unitId].baseGooCost + (existing * unitInfo[unitId].gooCostIncreaseHalf * 2);
1002             }
1003         } else if (amount > 1) {
1004             uint256 existingCost;
1005             if (existing > 0) {
1006                 existingCost = (unitInfo[unitId].baseGooCost * existing) + (existing * (existing - 1) * unitInfo[unitId].gooCostIncreaseHalf);
1007             }
1008             
1009             existing += amount;
1010             uint256 newCost = SafeMath.add(SafeMath.mul(unitInfo[unitId].baseGooCost, existing), SafeMath.mul(SafeMath.mul(existing, (existing - 1)), unitInfo[unitId].gooCostIncreaseHalf));
1011             return newCost - existingCost;
1012         }
1013     }
1014     
1015     function getWeakenedDefensePower(uint256 defendingPower) external constant returns (uint256) {
1016         return defendingPower / 2;
1017     }
1018     
1019     function validUnitId(uint256 unitId) external constant returns (bool) {
1020         return ((unitId > 0 && unitId < 9) || (unitId > 39 && unitId < 46));
1021     }
1022     
1023     function validUpgradeId(uint256 upgradeId) external constant returns (bool) {
1024         return (upgradeId > 0 && upgradeId < 43);
1025     }
1026     
1027     function validRareId(uint256 rareId) external constant returns (bool) {
1028         return (rareId > 0 && rareId < 3);
1029     }
1030     
1031     function unitEthCost(uint256 unitId) external constant returns (uint256) {
1032         return unitInfo[unitId].ethCost;
1033     }
1034     
1035     function unitGooProduction(uint256 unitId) external constant returns (uint256) {
1036         return unitInfo[unitId].baseGooProduction;
1037     }
1038     
1039     function unitAttack(uint256 unitId) external constant returns (uint256) {
1040         return unitInfo[unitId].attackValue;
1041     }
1042     
1043     function unitDefense(uint256 unitId) external constant returns (uint256) {
1044         return unitInfo[unitId].defenseValue;
1045     }
1046     
1047     function unitStealingCapacity(uint256 unitId) external constant returns (uint256) {
1048         return unitInfo[unitId].gooStealingCapacity;
1049     }
1050     
1051     function rareStartPrice(uint256 rareId) external constant returns (uint256) {
1052         return rareInfo[rareId].ethCost;
1053     }
1054     
1055     function productionUnitIdRange() external constant returns (uint256, uint256) {
1056         return (1, 8);
1057     }
1058     
1059     function battleUnitIdRange() external constant returns (uint256, uint256) {
1060         return (40, 45);
1061     }
1062     
1063     function upgradeIdRange() external constant returns (uint256, uint256) {
1064         return (1, 42);
1065     }
1066     
1067     function rareIdRange() external constant returns (uint256, uint256) {
1068         return (1, 2);
1069     }
1070     
1071     function getUpgradeInfo(uint256 upgradeId) external constant returns (uint256, uint256, uint256, uint256, uint256) {
1072         return (upgradeInfo[upgradeId].gooCost, upgradeInfo[upgradeId].ethCost, upgradeInfo[upgradeId].upgradeClass,
1073         upgradeInfo[upgradeId].unitId, upgradeInfo[upgradeId].upgradeValue);
1074     }
1075     
1076     function getRareInfo(uint256 rareId) external constant returns (uint256, uint256, uint256) {
1077         return (rareInfo[rareId].rareClass, rareInfo[rareId].unitId, rareInfo[rareId].rareValue);
1078     }
1079     
1080 }
1081 
1082 library SafeMath {
1083 
1084   /**
1085   * @dev Multiplies two numbers, throws on overflow.
1086   */
1087   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1088     if (a == 0) {
1089       return 0;
1090     }
1091     uint256 c = a * b;
1092     assert(c / a == b);
1093     return c;
1094   }
1095 
1096   /**
1097   * @dev Integer division of two numbers, truncating the quotient.
1098   */
1099   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1100     // assert(b > 0); // Solidity automatically throws when dividing by 0
1101     uint256 c = a / b;
1102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1103     return c;
1104   }
1105 
1106   /**
1107   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1108   */
1109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1110     assert(b <= a);
1111     return a - b;
1112   }
1113 
1114   /**
1115   * @dev Adds two numbers, throws on overflow.
1116   */
1117   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1118     uint256 c = a + b;
1119     assert(c >= a);
1120     return c;
1121   }
1122 }