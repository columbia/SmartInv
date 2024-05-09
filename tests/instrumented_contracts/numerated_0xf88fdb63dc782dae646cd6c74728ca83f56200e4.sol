1 pragma solidity 0.4.25;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     function _validateAddress(address _addr) internal pure {
9         require(_addr != address(0), "invalid address");
10     }
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner() {
17         require(msg.sender == owner, "not a contract owner");
18         _;
19     }
20 
21     function transferOwnership(address newOwner) public onlyOwner {
22         _validateAddress(newOwner);
23         emit OwnershipTransferred(owner, newOwner);
24         owner = newOwner;
25     }
26 
27 }
28 
29 contract Controllable is Ownable {
30     mapping(address => bool) controllers;
31 
32     modifier onlyController {
33         require(_isController(msg.sender), "no controller rights");
34         _;
35     }
36 
37     function _isController(address _controller) internal view returns (bool) {
38         return controllers[_controller];
39     }
40 
41     function _setControllers(address[] _controllers) internal {
42         for (uint256 i = 0; i < _controllers.length; i++) {
43             _validateAddress(_controllers[i]);
44             controllers[_controllers[i]] = true;
45         }
46     }
47 }
48 
49 contract Upgradable is Controllable {
50     address[] internalDependencies;
51     address[] externalDependencies;
52 
53     function getInternalDependencies() public view returns(address[]) {
54         return internalDependencies;
55     }
56 
57     function getExternalDependencies() public view returns(address[]) {
58         return externalDependencies;
59     }
60 
61     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
62         for (uint256 i = 0; i < _newDependencies.length; i++) {
63             _validateAddress(_newDependencies[i]);
64         }
65         internalDependencies = _newDependencies;
66     }
67 
68     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
69         externalDependencies = _newDependencies;
70         _setControllers(_newDependencies);
71     }
72 }
73 
74 contract Core {
75     function isEggInNest(uint256) external view returns (bool);
76     function getEggsInNest() external view returns (uint256[2]);
77     function getDragonsFromLeaderboard() external view returns (uint256[10]);
78     function getLeaderboardRewards(uint256) external view returns (uint256[10]);
79     function getLeaderboardRewardDate() external view returns (uint256, uint256);
80     function getEgg(uint256) external view returns (uint16, uint32, uint256[2], uint8[11], uint8[11]);
81     function getDragonChildren(uint256) external view returns (uint256[10], uint256[10]);
82 }
83 
84 contract DragonParams {
85     function getDragonTypesFactors() external view returns (uint8[55]);
86     function getBodyPartsFactors() external view returns (uint8[50]);
87     function getGeneTypesFactors() external view returns (uint8[50]);
88     function getExperienceToNextLevel() external view returns (uint8[10]);
89     function getDNAPoints() external view returns (uint16[11]);
90     function battlePoints() external view returns (uint8);
91     function getGeneUpgradeDNAPoints() external view returns (uint8[99]);
92 }
93 
94 contract DragonGetter {
95     function getAmount() external view returns (uint256);
96     function isOwner(address, uint256) external view returns (bool);
97     function ownerOf(uint256) external view returns (address);
98     function getGenome(uint256) public view returns (uint8[30]);
99     function getComposedGenome(uint256) external view returns (uint256[4]);
100     function getSkills(uint256) external view returns (uint32, uint32, uint32, uint32, uint32);
101     function getCoolness(uint256) public view returns (uint32);
102     function getLevel(uint256) public view returns (uint8);
103     function getHealthAndMana(uint256) external view returns (uint256, uint32, uint32, uint32, uint32);
104     function getCurrentHealthAndMana(uint256) external view returns (uint32, uint32, uint8, uint8);
105     function getFullRegenerationTime(uint256) external view returns (uint32);
106     function getDragonTypes(uint256) external view returns (uint8[11]);
107     function getProfile(uint256) external view returns (bytes32, uint16, uint256, uint8, uint8, uint16, bool, uint32);
108     function getGeneration(uint256) external view returns (uint16);
109     function isBreedingAllowed(uint256) external view returns (bool);
110     function getTactics(uint256) external view returns (uint8, uint8);
111     function getBattles(uint256) external view returns (uint16, uint16);
112     function getParents(uint256) external view returns (uint256[2]);
113     function getSpecialAttack(uint256) external view returns (uint8, uint32, uint8, uint8);
114     function getSpecialDefense(uint256) external view returns (uint8, uint32, uint8, uint8);
115     function getSpecialPeacefulSkill(uint256) external view returns (uint8, uint32, uint32);
116     function getBuffs(uint256) external view returns (uint32[5]);
117     function getDragonStrength(uint256) external view returns (uint32);
118     function getDragonNamePriceByLength(uint256) external pure returns (uint256);
119     function getDragonNamePrices() external pure returns (uint8[3], uint256[3]);
120 }
121 
122 contract Distribution {
123     function getInfo() external view returns (uint256, uint256, uint256, uint256, uint256);
124 }
125 
126 contract Treasury {
127     uint256 public hatchingPrice;
128     function remainingGold() external view returns (uint256);
129 }
130 
131 contract GladiatorBattle {
132     function isDragonChallenging(uint256) public view returns (bool);
133 }
134 
135 contract GladiatorBattleStorage {
136     function challengesAmount() external view returns (uint256);
137     function getUserChallenges(address) external view returns (uint256[]);
138     function getChallengeApplicants(uint256) external view returns (uint256[]);
139     function getDragonApplication(uint256) external view returns (uint256, uint8[2], address);
140     function getUserApplications(address) external view returns (uint256[]);
141     function getChallengeParticipants(uint256) external view returns (address, uint256, address, uint256, address, uint256);
142     function getChallengeDetails(uint256) external view returns (bool, uint256, uint16, uint256, bool, uint256, bool, uint256, uint256, uint256);
143 }
144 
145 contract SkillMarketplace {
146     function getAuction(uint256) external view returns (uint256);
147     function getAllTokens() external view returns (uint256[]);
148 }
149 
150 contract Marketplace {
151     function getAuction(uint256 _id) external view returns (address, uint256, uint256, uint256, uint16, uint256, bool);
152 }
153 
154 contract BreedingMarketplace is Marketplace {}
155 contract EggMarketplace is Marketplace {}
156 contract DragonMarketplace is Marketplace {}
157 
158 
159 
160 
161 //////////////CONTRACT//////////////
162 
163 
164 
165 
166 contract Getter is Upgradable {
167 
168     Core core;
169     DragonParams dragonParams;
170     DragonGetter dragonGetter;
171     SkillMarketplace skillMarketplace;
172     Distribution distribution;
173     Treasury treasury;
174     GladiatorBattle gladiatorBattle;
175     GladiatorBattleStorage gladiatorBattleStorage;
176 
177     BreedingMarketplace public breedingMarketplace;
178     EggMarketplace public eggMarketplace;
179     DragonMarketplace public dragonMarketplace;
180 
181 
182     function _isValidAddress(address _addr) internal pure returns (bool) {
183         return _addr != address(0);
184     }
185 
186     // MODEL
187 
188     function getEgg(uint256 _id) external view returns (
189         uint16 gen,
190         uint32 coolness,
191         uint256[2] parents,
192         uint8[11] momDragonTypes,
193         uint8[11] dadDragonTypes
194     ) {
195         return core.getEgg(_id);
196     }
197 
198     function getDragonGenome(uint256 _id) external view returns (uint8[30]) {
199         return dragonGetter.getGenome(_id);
200     }
201 
202     function getDragonTypes(uint256 _id) external view returns (uint8[11]) {
203         return dragonGetter.getDragonTypes(_id);
204     }
205 
206     function getDragonProfile(uint256 _id) external view returns (
207         bytes32 name,
208         uint16 generation,
209         uint256 birth,
210         uint8 level,
211         uint8 experience,
212         uint16 dnaPoints,
213         bool isBreedingAllowed,
214         uint32 coolness
215     ) {
216         return dragonGetter.getProfile(_id);
217     }
218 
219     function getDragonTactics(uint256 _id) external view returns (uint8 melee, uint8 attack) {
220         return dragonGetter.getTactics(_id);
221     }
222 
223     function getDragonBattles(uint256 _id) external view returns (uint16 wins, uint16 defeats) {
224         return dragonGetter.getBattles(_id);
225     }
226 
227     function getDragonSkills(uint256 _id) external view returns (
228         uint32 attack,
229         uint32 defense,
230         uint32 stamina,
231         uint32 speed,
232         uint32 intelligence
233     ) {
234         return dragonGetter.getSkills(_id);
235     }
236 
237     function getDragonStrength(uint256 _id) external view returns (uint32) {
238         return dragonGetter.getDragonStrength(_id);
239     }
240 
241     function getDragonCurrentHealthAndMana(uint256 _id) external view returns (
242         uint32 health,
243         uint32 mana,
244         uint8 healthPercentage,
245         uint8 manaPercentage
246     ) {
247         return dragonGetter.getCurrentHealthAndMana(_id);
248     }
249 
250     function getDragonMaxHealthAndMana(uint256 _id) external view returns (uint32 maxHealth, uint32 maxMana) {
251         ( , , , maxHealth, maxMana) = dragonGetter.getHealthAndMana(_id);
252     }
253 
254     function getDragonHealthAndMana(uint256 _id) external view returns (
255         uint256 timestamp,
256         uint32 remainingHealth,
257         uint32 remainingMana,
258         uint32 maxHealth,
259         uint32 maxMana
260     ) {
261         return dragonGetter.getHealthAndMana(_id);
262     }
263 
264     function getDragonParents(uint256 _id) external view returns (uint256[2]) {
265         return dragonGetter.getParents(_id);
266     }
267 
268     function getDragonSpecialAttack(uint256 _id) external view returns (
269         uint8 dragonType,
270         uint32 cost,
271         uint8 factor,
272         uint8 chance
273     ) {
274         return dragonGetter.getSpecialAttack(_id);
275     }
276 
277     function getDragonSpecialDefense(uint256 _id) external view returns (
278         uint8 dragonType,
279         uint32 cost,
280         uint8 factor,
281         uint8 chance
282     ) {
283         return dragonGetter.getSpecialDefense(_id);
284     }
285 
286     function getDragonSpecialPeacefulSkill(uint256 _id) external view returns (
287         uint8 class,
288         uint32 cost,
289         uint32 effect
290     ) {
291         return dragonGetter.getSpecialPeacefulSkill(_id);
292     }
293 
294     function getDragonsAmount() external view returns (uint256) {
295         return dragonGetter.getAmount();
296     }
297 
298     function getDragonChildren(uint256 _id) external view returns (uint256[10] dragons, uint256[10] eggs) {
299         return core.getDragonChildren(_id);
300     }
301 
302     function getDragonBuffs(uint256 _id) external view returns (uint32[5]) {
303         return dragonGetter.getBuffs(_id);
304     }
305 
306     function isDragonBreedingAllowed(uint256 _id) external view returns (bool) {
307         return dragonGetter.isBreedingAllowed(_id);
308     }
309 
310     function isDragonUsed(uint256 _id) external view returns (
311         bool isOnSale,
312         bool isOnBreeding,
313         bool isInGladiatorBattle
314     ) {
315         return (
316             isDragonOnSale(_id),
317             isBreedingOnSale(_id),
318             isDragonInGladiatorBattle(_id)
319         );
320     }
321 
322     // CONSTANTS
323 
324     function getDragonExperienceToNextLevel() external view returns (uint8[10]) {
325         return dragonParams.getExperienceToNextLevel();
326     }
327 
328     function getDragonGeneUpgradeDNAPoints() external view returns (uint8[99]) {
329         return dragonParams.getGeneUpgradeDNAPoints();
330     }
331 
332     function getDragonLevelUpDNAPoints() external view returns (uint16[11]) {
333         return dragonParams.getDNAPoints();
334     }
335 
336     function getDragonTypesFactors() external view returns (uint8[55]) {
337         return dragonParams.getDragonTypesFactors();
338     }
339 
340     function getDragonBodyPartsFactors() external view returns (uint8[50]) {
341         return dragonParams.getBodyPartsFactors();
342     }
343 
344     function getDragonGeneTypesFactors() external view returns (uint8[50]) {
345         return dragonParams.getGeneTypesFactors();
346     }
347 
348     function getHatchingPrice() external view returns (uint256) {
349         return treasury.hatchingPrice();
350     }
351 
352     function getDragonNamePrices() external view returns (uint8[3] lengths, uint256[3] prices) {
353         return dragonGetter.getDragonNamePrices();
354     }
355 
356     function getDragonNamePriceByLength(uint256 _length) external view returns (uint256 price) {
357         return dragonGetter.getDragonNamePriceByLength(_length);
358     }
359 
360     // MARKETPLACE
361 
362     function getDragonOnSaleInfo(uint256 _id) public view returns (
363         address seller,
364         uint256 currentPrice,
365         uint256 startPrice,
366         uint256 endPrice,
367         uint16 period,
368         uint256 created,
369         bool isGold
370     ) {
371         return dragonMarketplace.getAuction(_id);
372     }
373 
374     function getBreedingOnSaleInfo(uint256 _id) public view returns (
375         address seller,
376         uint256 currentPrice,
377         uint256 startPrice,
378         uint256 endPrice,
379         uint16 period,
380         uint256 created,
381         bool isGold
382     ) {
383         return breedingMarketplace.getAuction(_id);
384     }
385 
386     function getEggOnSaleInfo(uint256 _id) public view returns (
387         address seller,
388         uint256 currentPrice,
389         uint256 startPrice,
390         uint256 endPrice,
391         uint16 period,
392         uint256 created,
393         bool isGold
394     ) {
395         return eggMarketplace.getAuction(_id);
396     }
397 
398     function getSkillOnSaleInfo(uint256 _id) public view returns (address seller, uint256 price) {
399         seller = ownerOfDragon(_id);
400         price = skillMarketplace.getAuction(_id);
401     }
402 
403     function isEggOnSale(uint256 _tokenId) external view returns (bool) {
404         (address _seller, , , , , , ) = getEggOnSaleInfo(_tokenId);
405 
406         return _isValidAddress(_seller);
407     }
408 
409     function isDragonOnSale(uint256 _tokenId) public view returns (bool) {
410         (address _seller, , , , , , ) = getDragonOnSaleInfo(_tokenId);
411 
412         return _isValidAddress(_seller);
413     }
414 
415     function isBreedingOnSale(uint256 _tokenId) public view returns (bool) {
416         (address _seller, , , , , , ) = getBreedingOnSaleInfo(_tokenId);
417 
418         return _isValidAddress(_seller);
419     }
420 
421     function isSkillOnSale(uint256 _tokenId) external view returns (bool) {
422         (address _seller, ) = getSkillOnSaleInfo(_tokenId);
423 
424         return _isValidAddress(_seller);
425     }
426 
427     function getSkillsOnSale() public view returns (uint256[]) {
428         return skillMarketplace.getAllTokens();
429     }
430 
431     // OWNER
432 
433     function isDragonOwner(address _user, uint256 _tokenId) external view returns (bool) {
434         return dragonGetter.isOwner(_user, _tokenId);
435     }
436 
437     function ownerOfDragon(uint256 _tokenId) public view returns (address) {
438         return dragonGetter.ownerOf(_tokenId);
439     }
440 
441     // NEST
442 
443     function isEggInNest(uint256 _id) external view returns (bool) {
444         return core.isEggInNest(_id);
445     }
446 
447     function getEggsInNest() external view returns (uint256[2]) {
448         return core.getEggsInNest();
449     }
450 
451     // LEADERBOARD
452 
453     function getDragonsFromLeaderboard() external view returns (uint256[10]) {
454         return core.getDragonsFromLeaderboard();
455     }
456 
457     function getLeaderboardRewards() external view returns (uint256[10]) {
458         return core.getLeaderboardRewards(treasury.hatchingPrice());
459     }
460 
461     function getLeaderboardRewardDate() external view returns (uint256 lastRewardDate, uint256 rewardPeriod) {
462         return core.getLeaderboardRewardDate();
463     }
464 
465     // GEN 0 DISTRIBUTION
466 
467     function getDistributionInfo() external view returns (
468         uint256 restAmount,
469         uint256 releasedAmount,
470         uint256 lastBlock,
471         uint256 intervalInBlocks,
472         uint256 numberOfTypes
473     ) {
474         return distribution.getInfo();
475     }
476 
477     // GLADIATOR BATTLE
478 
479     function gladiatorBattlesAmount() external view returns (uint256) {
480         return gladiatorBattleStorage.challengesAmount();
481     }
482 
483     function getUserGladiatorBattles(address _user) external view returns (uint256[]) {
484         return gladiatorBattleStorage.getUserChallenges(_user);
485     }
486 
487     function getGladiatorBattleApplicants(uint256 _challengeId) external view returns (uint256[]) {
488         return gladiatorBattleStorage.getChallengeApplicants(_challengeId);
489     }
490 
491     function getDragonApplicationForGladiatorBattle(
492         uint256 _dragonId
493     ) external view returns (
494         uint256 gladiatorBattleId,
495         uint8[2] tactics,
496         address owner
497     ) {
498         return gladiatorBattleStorage.getDragonApplication(_dragonId);
499     }
500 
501     function getUserApplicationsForGladiatorBattles(address _user) external view returns (uint256[]) {
502         return gladiatorBattleStorage.getUserApplications(_user);
503     }
504 
505     function getGladiatorBattleDetails(
506         uint256 _challengeId
507     ) external view returns (
508         bool isGold, uint256 bet, uint16 counter,
509         uint256 blockNumber, bool active,
510         uint256 autoSelectBlock, bool cancelled,
511         uint256 compensation, uint256 extensionTimePrice,
512         uint256 battleId
513     ) {
514         return gladiatorBattleStorage.getChallengeDetails(_challengeId);
515     }
516 
517     function getGladiatorBattleParticipants(
518         uint256 _challengeId
519     ) external view returns (
520         address firstUser, uint256 firstDragonId,
521         address secondUser, uint256 secondDragonId,
522         address winnerUser, uint256 winnerDragonId
523     ) {
524         return gladiatorBattleStorage.getChallengeParticipants(_challengeId);
525     }
526 
527     function isDragonInGladiatorBattle(uint256 _battleId) public view returns (bool) {
528         return gladiatorBattle.isDragonChallenging(_battleId);
529     }
530 
531     // UPDATE CONTRACT
532 
533     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
534         super.setInternalDependencies(_newDependencies);
535 
536         core = Core(_newDependencies[0]);
537         dragonParams = DragonParams(_newDependencies[1]);
538         dragonGetter = DragonGetter(_newDependencies[2]);
539         dragonMarketplace = DragonMarketplace(_newDependencies[3]);
540         breedingMarketplace = BreedingMarketplace(_newDependencies[4]);
541         eggMarketplace = EggMarketplace(_newDependencies[5]);
542         skillMarketplace = SkillMarketplace(_newDependencies[6]);
543         distribution = Distribution(_newDependencies[7]);
544         treasury = Treasury(_newDependencies[8]);
545         gladiatorBattle = GladiatorBattle(_newDependencies[9]);
546         gladiatorBattleStorage = GladiatorBattleStorage(_newDependencies[10]);
547     }
548 }