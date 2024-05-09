1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  * World War Goo - Competitive Idle Game
6  * 
7  * https://ethergoo.io
8  * 
9  */
10 
11 
12 contract Units {
13 
14     GooToken constant goo = GooToken(0xdf0960778c6e6597f197ed9a25f12f5d971da86c);
15     Army army = Army(0x0);
16     Clans clans = Clans(0x0);
17     Factories constant factories = Factories(0xc81068cd335889736fc485592e4d73a82403d44b);
18 
19     mapping(address => mapping(uint256 => UnitsOwned)) public unitsOwned;
20     mapping(address => mapping(uint256 => UnitExperience)) public unitExp;
21     mapping(address => mapping(uint256 => uint256)) private unitMaxCap;
22 
23     mapping(address => mapping(uint256 => UnitUpgrades)) private unitUpgrades;
24     mapping(address => mapping(uint256 => UpgradesOwned)) public upgradesOwned; // For each unitId, which upgrades owned (3 columns of uint64)
25 
26     mapping(uint256 => Unit) public unitList;
27     mapping(uint256 => Upgrade) public upgradeList;
28     mapping(address => bool) operator;
29 
30     address owner;
31 
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     struct UnitsOwned {
37         uint80 units;
38         uint8 factoryBuiltFlag; // Incase user sells units, we still want to keep factory
39     }
40 
41     struct UnitExperience {
42         uint224 experience;
43         uint32 level;
44     }
45 
46     struct UnitUpgrades {
47         uint32 prodIncrease;
48         uint32 prodMultiplier;
49 
50         uint32 attackIncrease;
51         uint32 attackMultiplier;
52         uint32 defenseIncrease;
53         uint32 defenseMultiplier;
54         uint32 lootingIncrease;
55         uint32 lootingMultiplier;
56     }
57 
58     struct UpgradesOwned {
59         uint64 column0;
60         uint64 column1;
61         uint64 column2;
62     }
63 
64 
65     // Unit & Upgrade data:
66     
67     struct Unit {
68         uint256 unitId;
69         uint224 gooCost;
70         uint256 baseProduction;
71         uint80 attack;
72         uint80 defense;
73         uint80 looting;
74     }
75 
76     struct Upgrade {
77         uint256 upgradeId;
78         uint224 gooCost;
79         uint256 unitId;
80         uint256 column; // Columns of upgrades (1st & 2nd are unit specific, then 3rd is capacity)
81         uint256 prerequisiteUpgrade;
82 
83         uint256 unitMaxCapacityGain;
84         uint32 prodIncrease;
85         uint32 prodMultiplier;
86         uint32 attackIncrease;
87         uint32 attackMultiplier;
88         uint32 defenseIncrease;
89         uint32 defenseMultiplier;
90         uint32 lootingIncrease;
91         uint32 lootingMultiplier;
92     }
93 
94     function setArmy(address armyContract) external {
95         require(msg.sender == owner);
96         army = Army(armyContract);
97     }
98 
99     function setClans(address clansContract) external {
100         require(msg.sender == owner);
101         clans = Clans(clansContract);
102     }
103 
104     function setOperator(address gameContract, bool isOperator) external {
105         require(msg.sender == owner);
106         operator[gameContract] = isOperator;
107     }
108 
109     function mintUnitExternal(uint256 unit, uint80 amount, address player, uint8 chosenPosition) external {
110         require(operator[msg.sender]);
111         mintUnit(unit, amount, player, chosenPosition);
112     }
113 
114     function mintUnit(uint256 unit, uint80 amount, address player, uint8 chosenPosition) internal {
115         UnitsOwned storage existingUnits = unitsOwned[player][unit];
116         if (existingUnits.factoryBuiltFlag == 0) {
117             // Edge case to create factory for player (on empty tile) where it is their first unit
118             uint256[] memory existingFactories = factories.getFactories(player);
119             uint256 length = existingFactories.length;
120 
121             // Provided position is not valid so find valid factory position
122             if (chosenPosition >= factories.MAX_SIZE() || (chosenPosition < length && existingFactories[chosenPosition] > 0)) {
123                 chosenPosition = 0;
124                 while (chosenPosition < length && existingFactories[chosenPosition] > 0) {
125                     chosenPosition++;
126                 }
127             }
128 
129             factories.addFactory(player, chosenPosition, unit);
130             unitsOwned[player][unit] = UnitsOwned(amount, 1); // 1 = Flag to say factory exists
131         } else {
132             existingUnits.units += amount;
133         }
134 
135         (uint80 attackStats, uint80 defenseStats, uint80 lootingStats) = getUnitsCurrentBattleStats(player, unit);
136         if (attackStats > 0 || defenseStats > 0 || lootingStats > 0) {
137             army.increasePlayersArmyPowerTrio(player, attackStats * amount, defenseStats * amount, lootingStats * amount);
138         } else {
139             uint256 prodIncrease = getUnitsCurrentProduction(player, unit) * amount;
140             goo.increasePlayersGooProduction(player, prodIncrease / 100);
141         }
142     }
143 
144 
145     function deleteUnitExternal(uint80 amount, uint256 unit, address player) external {
146         require(operator[msg.sender]);
147         deleteUnit(amount, unit, player);
148     }
149 
150     function deleteUnit(uint80 amount, uint256 unit, address player) internal {
151         (uint80 attackStats, uint80 defenseStats, uint80 lootingStats) = getUnitsCurrentBattleStats(player, unit);
152         if (attackStats > 0 || defenseStats > 0 || lootingStats > 0) {
153             army.decreasePlayersArmyPowerTrio(player, attackStats * amount, defenseStats * amount, lootingStats * amount);
154         } else {
155             uint256 prodDecrease = getUnitsCurrentProduction(player, unit) * amount;
156             goo.decreasePlayersGooProduction(player, prodDecrease / 100);
157         }
158         unitsOwned[player][unit].units -= amount;
159     }
160 
161 
162     function getUnitsCurrentBattleStats(address player, uint256 unitId) internal view returns (uint80 attack, uint80 defense, uint80 looting) {
163         Unit memory unit = unitList[unitId];
164         UnitUpgrades memory existingUpgrades = unitUpgrades[player][unitId];
165         attack = (unit.attack + existingUpgrades.attackIncrease) * (100 + existingUpgrades.attackMultiplier);
166         defense = (unit.defense + existingUpgrades.defenseIncrease) * (100 + existingUpgrades.defenseMultiplier);
167         looting = (unit.looting + existingUpgrades.lootingIncrease) * (100 + existingUpgrades.lootingMultiplier);
168     }
169     
170     function getUnitsCurrentProduction(address player, uint256 unitId) public view returns (uint256) {
171         UnitUpgrades memory existingUpgrades = unitUpgrades[player][unitId];
172         return (unitList[unitId].baseProduction + existingUpgrades.prodIncrease) * (100 + existingUpgrades.prodMultiplier);
173     }
174 
175 
176     function buyUnit(uint256 unitId, uint80 amount, uint8 position) external {
177         uint224 gooCost = SafeMath224.mul(unitList[unitId].gooCost, amount);
178         require(gooCost > 0); // Valid unit
179 
180         uint80 newTotal = unitsOwned[msg.sender][unitId].units + amount;
181         if (newTotal > 99) {
182             require(newTotal < 99 + unitMaxCap[msg.sender][unitId]);
183         }
184 
185         // Clan discount
186         uint224 unitDiscount = clans.getPlayersClanUpgrade(msg.sender, 1); // class 1 = unit discount
187         uint224 reducedGooCost = gooCost - ((gooCost * unitDiscount) / 100);
188         uint224 seventyFivePercentRefund = (gooCost * 3) / 4;
189 
190         // Update players goo
191         goo.updatePlayersGooFromPurchase(msg.sender, reducedGooCost);
192         goo.mintGoo(seventyFivePercentRefund, this); // 75% refund is stored (in this contract) for when player sells unit
193         army.depositSpentGoo(reducedGooCost - seventyFivePercentRefund); // Upto 25% Goo spent goes to divs (Remaining is discount + 75% player gets back when selling unit)
194         mintUnit(unitId, amount, msg.sender, position);
195     }
196 
197 
198     function sellUnit(uint256 unitId, uint80 amount) external {
199         require(unitsOwned[msg.sender][unitId].units >= amount && amount > 0);
200 
201         uint224 gooCost = unitList[unitId].gooCost;
202         require(gooCost > 0);
203 
204         goo.updatePlayersGoo(msg.sender);
205         deleteUnit(amount, unitId, msg.sender);
206         goo.transfer(msg.sender, (gooCost * amount * 3) / 4); // Refund 75%
207     }
208 
209 
210     function grantArmyExp(address player, uint256 unitId, uint224 amount) external returns(bool) {
211         require(operator[msg.sender]);
212 
213         UnitExperience memory existingExp = unitExp[player][unitId];
214         uint224 expRequirement = (existingExp.level + 1) * 80; // Lvl 1: 80; Lvl 2: 160, Lvl 3: 240 (480 in total) etc.
215 
216         if (existingExp.experience + amount >= expRequirement) {
217             existingExp.experience = (existingExp.experience + amount) - expRequirement;
218             existingExp.level++;
219             unitExp[player][unitId] = existingExp;
220 
221             // Grant buff to unit (5% additive multiplier)
222             UnitUpgrades memory existingUpgrades = unitUpgrades[player][unitId];
223             existingUpgrades.attackMultiplier += 5;
224             existingUpgrades.defenseMultiplier += 5;
225             existingUpgrades.lootingMultiplier += 5;
226             unitUpgrades[player][unitId] = existingUpgrades;
227 
228             // Increase player's army power
229             uint80 multiplierGain = unitsOwned[player][unitId].units * 5;
230 
231             Unit memory unit = unitList[unitId];
232             uint80 attackGain = multiplierGain * (unit.attack + existingUpgrades.attackIncrease);
233             uint80 defenseGain = multiplierGain * (unit.defense + existingUpgrades.defenseIncrease);
234             uint80 lootingGain = multiplierGain * (unit.looting + existingUpgrades.lootingIncrease);
235             army.increasePlayersArmyPowerTrio(player, attackGain, defenseGain, lootingGain);
236             return true;
237         } else {
238             unitExp[player][unitId].experience += amount;
239             return false;
240         }
241     }
242 
243     function increaseUnitCapacity(address player, uint256 upgradeGain, uint256 unitId) external {
244         require(operator[msg.sender]);
245         unitMaxCap[player][unitId] += upgradeGain;
246     }
247 
248     function decreaseUnitCapacity(address player, uint256 upgradeGain, uint256 unitId) external {
249         require(operator[msg.sender]);
250         unitMaxCap[player][unitId] -= upgradeGain;
251     }
252 
253 
254     function increaseUpgradesExternal(address player, uint256 unitId, uint32 prodIncrease, uint32 prodMultiplier, uint32 attackIncrease, uint32 attackMultiplier, uint32 defenseIncrease, uint32 defenseMultiplier, uint32 lootingIncrease, uint32 lootingMultiplier) external {
255         require(operator[msg.sender]);
256         Upgrade memory upgrade = Upgrade(0,0,0,0,0,0, prodIncrease, prodMultiplier, attackIncrease, attackMultiplier, defenseIncrease, defenseMultiplier, lootingIncrease, lootingMultiplier);
257         increaseUpgrades(player, upgrade, unitId);
258     }
259 
260 
261     function increaseUpgrades(address player, Upgrade upgrade, uint256 unitId) internal {
262         uint80 units = unitsOwned[player][unitId].units;
263         UnitUpgrades memory existingUpgrades = unitUpgrades[player][unitId];
264 
265         Unit memory unit = unitList[unitId];
266         if (unit.baseProduction > 0) {
267             // Increase goo production
268             uint256 prodGain = units * upgrade.prodMultiplier * (unit.baseProduction + existingUpgrades.prodIncrease); // Multiplier gains
269             prodGain += units * upgrade.prodIncrease * (100 + existingUpgrades.prodMultiplier); // Base prod gains
270 
271             goo.updatePlayersGoo(player);
272             goo.increasePlayersGooProduction(player, prodGain / 100);
273         } else {
274             // Increase army power
275             uint80 attackGain = units * upgrade.attackMultiplier * (unit.attack + existingUpgrades.attackIncrease); // Multiplier gains
276             uint80 defenseGain = units * upgrade.defenseMultiplier * (unit.defense + existingUpgrades.defenseIncrease); // Multiplier gains
277             uint80 lootingGain = units * upgrade.lootingMultiplier * (unit.looting + existingUpgrades.lootingIncrease); // Multiplier gains
278 
279             attackGain += units * upgrade.attackIncrease * (100 + existingUpgrades.attackMultiplier); // + Base gains
280             defenseGain += units * upgrade.defenseIncrease * (100 + existingUpgrades.defenseMultiplier); // + Base gains
281             lootingGain += units * upgrade.lootingIncrease * (100 + existingUpgrades.lootingMultiplier); // + Base gains
282 
283             army.increasePlayersArmyPowerTrio(player, attackGain, defenseGain, lootingGain);
284         }
285 
286         existingUpgrades.prodIncrease += upgrade.prodIncrease;
287         existingUpgrades.prodMultiplier += upgrade.prodMultiplier;
288         existingUpgrades.attackIncrease += upgrade.attackIncrease;
289         existingUpgrades.attackMultiplier += upgrade.attackMultiplier;
290         existingUpgrades.defenseIncrease += upgrade.defenseIncrease;
291         existingUpgrades.defenseMultiplier += upgrade.defenseMultiplier;
292         existingUpgrades.lootingIncrease += upgrade.lootingIncrease;
293         existingUpgrades.lootingMultiplier += upgrade.lootingMultiplier;
294         unitUpgrades[player][unitId] = existingUpgrades;
295     }
296 
297 
298     function decreaseUpgradesExternal(address player, uint256 unitId, uint32 prodIncrease, uint32 prodMultiplier, uint32 attackIncrease, uint32 attackMultiplier, uint32 defenseIncrease, uint32 defenseMultiplier, uint32 lootingIncrease, uint32 lootingMultiplier) external {
299         require(operator[msg.sender]);
300         Upgrade memory upgrade = Upgrade(0,0,0,0,0,0, prodIncrease, prodMultiplier, attackIncrease, attackMultiplier, defenseIncrease, defenseMultiplier, lootingIncrease, lootingMultiplier);
301         decreaseUpgrades(player, upgrade, unitId);
302     }
303 
304 
305     function decreaseUpgrades(address player, Upgrade upgrade, uint256 unitId) internal {
306         uint80 units = unitsOwned[player][unitId].units;
307         UnitUpgrades memory existingUpgrades = unitUpgrades[player][unitId];
308 
309         Unit memory unit = unitList[unitId];
310         if (unit.baseProduction > 0) {
311             // Decrease goo production
312             uint256 prodLoss = units * upgrade.prodMultiplier * (unit.baseProduction + existingUpgrades.prodIncrease); // Multiplier losses
313             prodLoss += units * upgrade.prodIncrease * (100 + existingUpgrades.prodMultiplier); // Base prod losses
314 
315             goo.updatePlayersGoo(player);
316             goo.decreasePlayersGooProduction(player, prodLoss / 100);
317         } else {
318             // Decrease army power
319             uint80 attackLoss = units * upgrade.attackMultiplier * (unit.attack + existingUpgrades.attackIncrease); // Multiplier losses
320             uint80 defenseLoss = units * upgrade.defenseMultiplier * (unit.defense + existingUpgrades.defenseIncrease); // Multiplier losses
321             uint80 lootingLoss = units * upgrade.lootingMultiplier * (unit.looting + existingUpgrades.lootingIncrease); // Multiplier losses
322 
323             attackLoss += units * upgrade.attackIncrease * (100 + existingUpgrades.attackMultiplier); // + Base losses
324             defenseLoss += units * upgrade.defenseIncrease * (100 + existingUpgrades.defenseMultiplier); // + Base losses
325             lootingLoss += units * upgrade.lootingIncrease * (100 + existingUpgrades.lootingMultiplier); // + Base losses
326             army.decreasePlayersArmyPowerTrio(player, attackLoss, defenseLoss, lootingLoss);
327         }
328 
329         existingUpgrades.prodIncrease -= upgrade.prodIncrease;
330         existingUpgrades.prodMultiplier -= upgrade.prodMultiplier;
331         existingUpgrades.attackIncrease -= upgrade.attackIncrease;
332         existingUpgrades.attackMultiplier -= upgrade.attackMultiplier;
333         existingUpgrades.defenseIncrease -= upgrade.defenseIncrease;
334         existingUpgrades.defenseMultiplier -= upgrade.defenseMultiplier;
335         existingUpgrades.lootingIncrease -= upgrade.lootingIncrease;
336         existingUpgrades.lootingMultiplier -= upgrade.lootingMultiplier;
337         unitUpgrades[player][unitId] = existingUpgrades;
338     }
339 
340     function swapUpgradesExternal(address player, uint256 unitId, uint32[8] upgradeGains, uint32[8] upgradeLosses) external {
341         require(operator[msg.sender]);
342 
343         UnitUpgrades memory existingUpgrades = unitUpgrades[player][unitId];
344         Unit memory unit = unitList[unitId];
345 
346         if (unit.baseProduction > 0) {
347             // Change goo production
348             gooProductionChange(player, unitId, existingUpgrades, unit.baseProduction, upgradeGains, upgradeLosses);
349         } else {
350             // Change army power
351             armyPowerChange(player, existingUpgrades, unit, upgradeGains, upgradeLosses);
352         }
353     }
354     
355     function armyPowerChange(address player, UnitUpgrades existingUpgrades, Unit unit, uint32[8] upgradeGains, uint32[8] upgradeLosses) internal {
356         int256 existingAttack = int256((unit.attack + existingUpgrades.attackIncrease) * (100 + existingUpgrades.attackMultiplier));
357         int256 existingDefense = int256((unit.defense + existingUpgrades.defenseIncrease) * (100 + existingUpgrades.defenseMultiplier));
358         int256 existingLooting = int256((unit.looting + existingUpgrades.lootingIncrease) * (100 + existingUpgrades.lootingMultiplier));
359     
360         existingUpgrades.attackIncrease = uint32(int(existingUpgrades.attackIncrease) + (int32(upgradeGains[2]) - int32(upgradeLosses[2])));
361         existingUpgrades.attackMultiplier = uint32(int(existingUpgrades.attackMultiplier) + (int32(upgradeGains[3]) - int32(upgradeLosses[3])));
362         existingUpgrades.defenseIncrease = uint32(int(existingUpgrades.defenseIncrease) + (int32(upgradeGains[4]) - int32(upgradeLosses[4])));
363         existingUpgrades.defenseMultiplier = uint32(int(existingUpgrades.defenseMultiplier) + (int32(upgradeGains[5]) - int32(upgradeLosses[5])));
364         existingUpgrades.lootingIncrease = uint32(int(existingUpgrades.lootingIncrease) + (int32(upgradeGains[6]) - int32(upgradeLosses[6])));
365         existingUpgrades.lootingMultiplier = uint32(int(existingUpgrades.lootingMultiplier) + (int32(upgradeGains[7]) - int32(upgradeLosses[7])));
366         
367         int256 attackChange = ((int256(unit.attack) + existingUpgrades.attackIncrease) * (100 + existingUpgrades.attackMultiplier)) - existingAttack;
368         int256 defenseChange = ((int256(unit.defense) + existingUpgrades.defenseIncrease) * (100 + existingUpgrades.defenseMultiplier)) - existingDefense;
369         int256 lootingChange = ((int256(unit.looting) + existingUpgrades.lootingIncrease) * (100 + existingUpgrades.lootingMultiplier)) - existingLooting;
370         
371         uint256 unitId = unit.unitId;
372         int256 units = int256(unitsOwned[player][unitId].units);
373         
374         army.changePlayersArmyPowerTrio(player, units * attackChange, units * defenseChange, units * lootingChange);
375         unitUpgrades[player][unitId] = existingUpgrades;
376     }
377     
378     function gooProductionChange(address player, uint256 unitId, UnitUpgrades existingUpgrades, uint256 baseProduction, uint32[8] upgradeGains, uint32[8] upgradeLosses) internal {
379         goo.updatePlayersGoo(player);
380         
381         int256 existingProd = int256((baseProduction + existingUpgrades.prodIncrease) * (100 + existingUpgrades.prodMultiplier));
382         existingUpgrades.prodIncrease = uint32(int(existingUpgrades.prodIncrease) + (int32(upgradeGains[0]) - int32(upgradeLosses[0])));
383         existingUpgrades.prodMultiplier = uint32(int(existingUpgrades.prodMultiplier) + (int32(upgradeGains[1]) - int32(upgradeLosses[1])));            
384         
385         int256 prodChange = ((int256(baseProduction) + existingUpgrades.prodIncrease) * (100 + existingUpgrades.prodMultiplier)) - existingProd;
386         if (prodChange > 0) {
387             goo.increasePlayersGooProduction(player, (unitsOwned[player][unitId].units * uint256(prodChange)) / 100);
388         } else {
389             goo.decreasePlayersGooProduction(player, (unitsOwned[player][unitId].units * uint256(-prodChange)) / 100);
390         }
391         
392         unitUpgrades[player][unitId] = existingUpgrades;
393     }
394 
395     function addUnit(uint256 id, uint224 baseGooCost, uint256 baseGooProduction, uint80 baseAttack, uint80 baseDefense, uint80 baseLooting) external {
396         require(operator[msg.sender]);
397         unitList[id] = Unit(id, baseGooCost, baseGooProduction, baseAttack, baseDefense, baseLooting);
398     }
399 
400 
401     function addUpgrade(uint256 id, uint224 gooCost, uint256 unit, uint256 column, uint256 prereq, uint256 unitMaxCapacityGain, uint32[8] upgradeGains) external {
402         require(operator[msg.sender]);
403         upgradeList[id] = Upgrade(id, gooCost, unit, column, prereq, unitMaxCapacityGain, upgradeGains[0], upgradeGains[1], upgradeGains[2], upgradeGains[3], upgradeGains[4], upgradeGains[5], upgradeGains[6], upgradeGains[7]);
404     }
405 
406     function buyUpgrade(uint64 upgradeId) external {
407         Upgrade memory upgrade = upgradeList[upgradeId];
408         uint256 unitId = upgrade.unitId;
409         UpgradesOwned memory ownedUpgrades = upgradesOwned[msg.sender][unitId];
410 
411         uint64 latestUpgradeOwnedForColumn;
412         if (upgrade.column == 0) {
413             latestUpgradeOwnedForColumn = ownedUpgrades.column0;
414             ownedUpgrades.column0 = upgradeId;  // Update upgradesOwned
415         } else if (upgrade.column == 1) {
416             latestUpgradeOwnedForColumn = ownedUpgrades.column1;
417             ownedUpgrades.column1 = upgradeId;  // Update upgradesOwned
418         } else if (upgrade.column == 2) {
419             latestUpgradeOwnedForColumn = ownedUpgrades.column2;
420             ownedUpgrades.column2 = upgradeId;  // Update upgradesOwned
421         }
422         upgradesOwned[msg.sender][unitId] = ownedUpgrades;
423 
424         require(unitId > 0); // Valid upgrade
425         require(latestUpgradeOwnedForColumn < upgradeId); // Haven't already purchased
426         require(latestUpgradeOwnedForColumn >= upgrade.prerequisiteUpgrade); // Own prequisite
427 
428         // Clan discount
429         uint224 upgradeDiscount = clans.getPlayersClanUpgrade(msg.sender, 0); // class 0 = upgrade discount
430         uint224 reducedUpgradeCost = upgrade.gooCost - ((upgrade.gooCost * upgradeDiscount) / 100);
431 
432         // Update players goo
433         goo.updatePlayersGooFromPurchase(msg.sender, reducedUpgradeCost);
434         army.depositSpentGoo(reducedUpgradeCost); // Transfer to goo bankroll
435 
436         // Update stats for upgrade
437         if (upgrade.column == 2) {
438             unitMaxCap[msg.sender][unitId] += upgrade.unitMaxCapacityGain;
439         } else if (upgrade.column == 1) {
440             increaseUpgrades(msg.sender, upgrade, unitId);
441         } else if (upgrade.column == 0) {
442             increaseUpgrades(msg.sender, upgrade, unitId);
443         }
444     }
445 
446 }
447 
448 
449 
450 
451 contract GooToken {
452     function transfer(address to, uint256 tokens) external returns (bool);
453     function increasePlayersGooProduction(address player, uint256 increase) external;
454     function decreasePlayersGooProduction(address player, uint256 decrease) external;
455     function updatePlayersGooFromPurchase(address player, uint224 purchaseCost) external;
456     function updatePlayersGoo(address player) external;
457     function mintGoo(uint224 amount, address player) external;
458 }
459 
460 contract Army {
461     function depositSpentGoo(uint224 gooSpent) external;
462     function increasePlayersArmyPowerTrio(address player, uint80 attackGain, uint80 defenseGain, uint80 lootingGain) public;
463     function decreasePlayersArmyPowerTrio(address player, uint80 attackLoss, uint80 defenseLoss, uint80 lootingLoss) public;
464     function changePlayersArmyPowerTrio(address player, int attackChange, int defenseChange, int lootingChange) public;
465 
466 }
467 
468 contract Clans {
469     mapping(uint256 => uint256) public clanTotalArmyPower;
470     function totalSupply() external view returns (uint256);
471     function depositGoo(uint256 amount, uint256 clanId) external;
472     function getPlayerFees(address player) external view returns (uint224 clansFee, uint224 leadersFee, address leader, uint224 referalsFee, address referer);
473     function getPlayersClanUpgrade(address player, uint256 upgradeClass) external view returns (uint224 upgradeGain);
474     function mintGoo(address player, uint256 amount) external;
475     function increaseClanPower(address player, uint256 amount) external;
476     function decreaseClanPower(address player, uint256 amount) external;
477 }
478 
479 contract Factories {
480     uint256 public constant MAX_SIZE = 40;
481     function getFactories(address player) external returns (uint256[]);
482     function addFactory(address player, uint8 position, uint256 unitId) external;
483 }
484 
485 
486 library SafeMath {
487 
488   /**
489   * @dev Multiplies two numbers, throws on overflow.
490   */
491   function mul(uint224 a, uint224 b) internal pure returns (uint224) {
492     if (a == 0) {
493       return 0;
494     }
495     uint224 c = a * b;
496     assert(c / a == b);
497     return c;
498   }
499 
500   /**
501   * @dev Integer division of two numbers, truncating the quotient.
502   */
503   function div(uint256 a, uint256 b) internal pure returns (uint256) {
504     // assert(b > 0); // Solidity automatically throws when dividing by 0
505     uint256 c = a / b;
506     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
507     return c;
508   }
509 
510   /**
511   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
512   */
513   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
514     assert(b <= a);
515     return a - b;
516   }
517 
518   /**
519   * @dev Adds two numbers, throws on overflow.
520   */
521   function add(uint256 a, uint256 b) internal pure returns (uint256) {
522     uint256 c = a + b;
523     assert(c >= a);
524     return c;
525   }
526 }
527 
528 
529 library SafeMath224 {
530 
531   /**
532   * @dev Multiplies two numbers, throws on overflow.
533   */
534   function mul(uint224 a, uint224 b) internal pure returns (uint224) {
535     if (a == 0) {
536       return 0;
537     }
538     uint224 c = a * b;
539     assert(c / a == b);
540     return c;
541   }
542 
543   /**
544   * @dev Integer division of two numbers, truncating the quotient.
545   */
546   function div(uint224 a, uint224 b) internal pure returns (uint224) {
547     // assert(b > 0); // Solidity automatically throws when dividing by 0
548     uint224 c = a / b;
549     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
550     return c;
551   }
552 
553   /**
554   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
555   */
556   function sub(uint224 a, uint224 b) internal pure returns (uint224) {
557     assert(b <= a);
558     return a - b;
559   }
560 
561   /**
562   * @dev Adds two numbers, throws on overflow.
563   */
564   function add(uint224 a, uint224 b) internal pure returns (uint224) {
565     uint224 c = a + b;
566     assert(c >= a);
567     return c;
568   }
569 }