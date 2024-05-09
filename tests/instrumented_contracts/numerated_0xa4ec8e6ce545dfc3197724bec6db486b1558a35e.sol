1 pragma solidity 0.4.25;
2 
3 library SafeMath8 {
4 
5     function mul(uint8 a, uint8 b) internal pure returns (uint8) {
6         if (a == 0) {
7             return 0;
8         }
9         uint8 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint8 a, uint8 b) internal pure returns (uint8) {
15         return a / b;
16     }
17 
18     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint8 a, uint8 b) internal pure returns (uint8) {
24         uint8 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint8 a, uint8 b) internal pure returns (uint8) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint8 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 library SafeMath16 {
40 
41     function mul(uint16 a, uint16 b) internal pure returns (uint16) {
42         if (a == 0) {
43             return 0;
44         }
45         uint16 c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49 
50     function div(uint16 a, uint16 b) internal pure returns (uint16) {
51         return a / b;
52     }
53 
54     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
55         assert(b <= a);
56         return a - b;
57     }
58 
59     function add(uint16 a, uint16 b) internal pure returns (uint16) {
60         uint16 c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 
65     function pow(uint16 a, uint16 b) internal pure returns (uint16) {
66         if (a == 0) return 0;
67         if (b == 0) return 1;
68 
69         uint16 c = a ** b;
70         assert(c / (a ** (b - 1)) == a);
71         return c;
72     }
73 }
74 
75 library SafeMath32 {
76 
77     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
78         if (a == 0) {
79             return 0;
80         }
81         uint32 c = a * b;
82         assert(c / a == b);
83         return c;
84     }
85 
86     function div(uint32 a, uint32 b) internal pure returns (uint32) {
87         return a / b;
88     }
89 
90     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
91         assert(b <= a);
92         return a - b;
93     }
94 
95     function add(uint32 a, uint32 b) internal pure returns (uint32) {
96         uint32 c = a + b;
97         assert(c >= a);
98         return c;
99     }
100 
101     function pow(uint32 a, uint32 b) internal pure returns (uint32) {
102         if (a == 0) return 0;
103         if (b == 0) return 1;
104 
105         uint32 c = a ** b;
106         assert(c / (a ** (b - 1)) == a);
107         return c;
108     }
109 }
110 
111 library SafeMath256 {
112 
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         if (a == 0) {
115             return 0;
116         }
117         uint256 c = a * b;
118         assert(c / a == b);
119         return c;
120     }
121 
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a / b;
124     }
125 
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         assert(b <= a);
128         return a - b;
129     }
130 
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         assert(c >= a);
134         return c;
135     }
136 
137     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
138         if (a == 0) return 0;
139         if (b == 0) return 1;
140 
141         uint256 c = a ** b;
142         assert(c / (a ** (b - 1)) == a);
143         return c;
144     }
145 }
146 
147 contract Ownable {
148     address public owner;
149 
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     function _validateAddress(address _addr) internal pure {
153         require(_addr != address(0), "invalid address");
154     }
155 
156     constructor() public {
157         owner = msg.sender;
158     }
159 
160     modifier onlyOwner() {
161         require(msg.sender == owner, "not a contract owner");
162         _;
163     }
164 
165     function transferOwnership(address newOwner) public onlyOwner {
166         _validateAddress(newOwner);
167         emit OwnershipTransferred(owner, newOwner);
168         owner = newOwner;
169     }
170 
171 }
172 
173 contract Controllable is Ownable {
174     mapping(address => bool) controllers;
175 
176     modifier onlyController {
177         require(_isController(msg.sender), "no controller rights");
178         _;
179     }
180 
181     function _isController(address _controller) internal view returns (bool) {
182         return controllers[_controller];
183     }
184 
185     function _setControllers(address[] _controllers) internal {
186         for (uint256 i = 0; i < _controllers.length; i++) {
187             _validateAddress(_controllers[i]);
188             controllers[_controllers[i]] = true;
189         }
190     }
191 }
192 
193 contract Upgradable is Controllable {
194     address[] internalDependencies;
195     address[] externalDependencies;
196 
197     function getInternalDependencies() public view returns(address[]) {
198         return internalDependencies;
199     }
200 
201     function getExternalDependencies() public view returns(address[]) {
202         return externalDependencies;
203     }
204 
205     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
206         for (uint256 i = 0; i < _newDependencies.length; i++) {
207             _validateAddress(_newDependencies[i]);
208         }
209         internalDependencies = _newDependencies;
210     }
211 
212     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
213         externalDependencies = _newDependencies;
214         _setControllers(_newDependencies);
215     }
216 }
217 
218 contract DragonCore {
219     function setRemainingHealthAndMana(uint256, uint32, uint32) external;
220     function increaseExperience(uint256, uint256) external;
221     function payDNAPointsForBreeding(uint256) external;
222     function upgradeGenes(uint256, uint16[10]) external;
223     function increaseWins(uint256) external;
224     function increaseDefeats(uint256) external;
225     function setTactics(uint256, uint8, uint8) external;
226     function setSpecialPeacefulSkill(uint256, uint8) external;
227     function useSpecialPeacefulSkill(address, uint256, uint256) external;
228     function setBuff(uint256, uint8, uint32) external;
229     function createDragon(address, uint16, uint256[2], uint256[4], uint8[11]) external returns (uint256);
230     function setName(uint256, string) external returns (bytes32);
231 }
232 
233 contract DragonGetter {
234     function getAmount() external view returns (uint256);
235     function getComposedGenome(uint256) external view returns (uint256[4]);
236     function getCoolness(uint256) public view returns (uint32);
237     function getFullRegenerationTime(uint256) external view returns (uint32);
238     function getDragonTypes(uint256) external view returns (uint8[11]);
239     function getGeneration(uint256) external view returns (uint16);
240     function getParents(uint256) external view returns (uint256[2]);
241 }
242 
243 contract DragonGenetics {
244     function createGenome(uint256[2], uint256[4], uint256[4], uint256) external view returns (uint256[4], uint8[11]);
245     function createGenomeForGenesis(uint8, uint256) external view returns (uint256[4]);
246 }
247 
248 contract EggCore {
249     function ownerOf(uint256) external view returns (address);
250     function get(uint256) external view returns (uint256[2], uint8);
251     function isOwner(address, uint256) external view returns (bool);
252     function getAllEggs() external view returns (uint256[]);
253     function create(address, uint256[2], uint8) external returns (uint256);
254     function remove(address, uint256) external;
255 }
256 
257 contract DragonLeaderboard {
258     function update(uint256, uint32) external;
259     function getDragonsFromLeaderboard() external view returns (uint256[10]);
260     function updateRewardTime() external;
261     function getRewards(uint256) external view returns (uint256[10]);
262     function getDate() external view returns (uint256, uint256);
263 }
264 
265 contract Nest {
266     mapping (uint256 => bool) public inNest;
267     function getEggs() external view returns (uint256[2]);
268     function add(uint256) external returns (bool, uint256, uint256);
269 }
270 
271 
272 
273 
274 //////////////CONTRACT//////////////
275 
276 
277 
278 
279 contract Core is Upgradable {
280     using SafeMath8 for uint8;
281     using SafeMath16 for uint16;
282     using SafeMath32 for uint32;
283     using SafeMath256 for uint256;
284 
285     DragonCore dragonCore;
286     DragonGetter dragonGetter;
287     DragonGenetics dragonGenetics;
288     EggCore eggCore;
289     DragonLeaderboard leaderboard;
290     Nest nest;
291     
292     uint256 public peacefulSkillCooldown;
293     mapping (uint256 => uint256) public lastPeacefulSkillsUsageDates;
294     
295     constructor() public {
296         peacefulSkillCooldown = 14 days;
297     }
298     
299     function _checkPossibilityOfUsingSpecialPeacefulSkill(uint256 _id) internal view {
300         uint256 _availableFrom = lastPeacefulSkillsUsageDates[_id].add(peacefulSkillCooldown);
301         require(_availableFrom <= now, "special peaceful skill is not yet available");
302     }
303     
304     function setCooldown(uint256 _value) external onlyOwner {
305         peacefulSkillCooldown = _value;
306     }
307 
308     function _max(uint16 lth, uint16 rth) internal pure returns (uint16) {
309         if (lth > rth) {
310             return lth;
311         } else {
312             return rth;
313         }
314     }
315 
316     function createEgg(
317         address _sender,
318         uint8 _dragonType
319     ) external onlyController returns (uint256) {
320         return eggCore.create(_sender, [uint256(0), uint256(0)], _dragonType);
321     }
322 
323     function sendToNest(
324         uint256 _id
325     ) external onlyController returns (
326         bool isHatched,
327         uint256 newDragonId,
328         uint256 hatchedId,
329         address owner
330     ) {
331         uint256 _randomForEggOpening;
332         (isHatched, hatchedId, _randomForEggOpening) = nest.add(_id);
333         // if any egg was hatched
334         if (isHatched) {
335             owner = eggCore.ownerOf(hatchedId);
336             newDragonId = openEgg(owner, hatchedId, _randomForEggOpening);
337         }
338     }
339 
340     function openEgg(
341         address _owner,
342         uint256 _eggId,
343         uint256 _random
344     ) internal returns (uint256 newDragonId) {
345         uint256[2] memory _parents;
346         uint8 _dragonType;
347         (_parents, _dragonType) = eggCore.get(_eggId);
348 
349         uint256[4] memory _genome;
350         uint8[11] memory _dragonTypesArray;
351         uint16 _generation;
352         // if genesis
353         if (_parents[0] == 0 && _parents[1] == 0) {
354             _generation = 0;
355             _genome = dragonGenetics.createGenomeForGenesis(_dragonType, _random);
356             _dragonTypesArray[_dragonType] = 40; // 40 genes of 1 type
357         } else {
358             uint256[4] memory _momGenome = dragonGetter.getComposedGenome(_parents[0]);
359             uint256[4] memory _dadGenome = dragonGetter.getComposedGenome(_parents[1]);
360             (_genome, _dragonTypesArray) = dragonGenetics.createGenome(_parents, _momGenome, _dadGenome, _random);
361             _generation = _max(
362                 dragonGetter.getGeneration(_parents[0]),
363                 dragonGetter.getGeneration(_parents[1])
364             ).add(1);
365         }
366 
367         newDragonId = dragonCore.createDragon(_owner, _generation, _parents, _genome, _dragonTypesArray);
368         eggCore.remove(_owner, _eggId);
369 
370         uint32 _coolness = dragonGetter.getCoolness(newDragonId);
371         leaderboard.update(newDragonId, _coolness);
372     }
373 
374     function breed(
375         address _sender,
376         uint256 _momId,
377         uint256 _dadId
378     ) external onlyController returns (uint256) {
379         dragonCore.payDNAPointsForBreeding(_momId);
380         dragonCore.payDNAPointsForBreeding(_dadId);
381         return eggCore.create(_sender, [_momId, _dadId], 0);
382     }
383 
384     function setDragonRemainingHealthAndMana(uint256 _id, uint32 _health, uint32 _mana) external onlyController {
385         return dragonCore.setRemainingHealthAndMana(_id, _health, _mana);
386     }
387 
388     function increaseDragonExperience(uint256 _id, uint256 _factor) external onlyController {
389         dragonCore.increaseExperience(_id, _factor);
390     }
391 
392     function upgradeDragonGenes(uint256 _id, uint16[10] _dnaPoints) external onlyController {
393         dragonCore.upgradeGenes(_id, _dnaPoints);
394 
395         uint32 _coolness = dragonGetter.getCoolness(_id);
396         leaderboard.update(_id, _coolness);
397     }
398 
399     function increaseDragonWins(uint256 _id) external onlyController {
400         dragonCore.increaseWins(_id);
401     }
402 
403     function increaseDragonDefeats(uint256 _id) external onlyController {
404         dragonCore.increaseDefeats(_id);
405     }
406 
407     function setDragonTactics(uint256 _id, uint8 _melee, uint8 _attack) external onlyController {
408         dragonCore.setTactics(_id, _melee, _attack);
409     }
410 
411     function setDragonName(uint256 _id, string _name) external onlyController returns (bytes32) {
412         return dragonCore.setName(_id, _name);
413     }
414 
415     function setDragonSpecialPeacefulSkill(uint256 _id, uint8 _class) external onlyController {
416         dragonCore.setSpecialPeacefulSkill(_id, _class);
417     }
418 
419     function useDragonSpecialPeacefulSkill(
420         address _sender,
421         uint256 _id,
422         uint256 _target
423     ) external onlyController {
424         _checkPossibilityOfUsingSpecialPeacefulSkill(_id);
425         dragonCore.useSpecialPeacefulSkill(_sender, _id, _target);
426         lastPeacefulSkillsUsageDates[_id] = now;
427     }
428 
429     function resetDragonBuffs(uint256 _id) external onlyController {
430         dragonCore.setBuff(_id, 1, 0); // attack
431         dragonCore.setBuff(_id, 2, 0); // defense
432         dragonCore.setBuff(_id, 3, 0); // stamina
433         dragonCore.setBuff(_id, 4, 0); // speed
434         dragonCore.setBuff(_id, 5, 0); // intelligence
435     }
436 
437     function updateLeaderboardRewardTime() external onlyController {
438         return leaderboard.updateRewardTime();
439     }
440 
441     // GETTERS
442 
443     function getDragonFullRegenerationTime(uint256 _id) external view returns (uint32 time) {
444         return dragonGetter.getFullRegenerationTime(_id);
445     }
446 
447     function isEggOwner(address _user, uint256 _tokenId) external view returns (bool) {
448         return eggCore.isOwner(_user, _tokenId);
449     }
450 
451     function isEggInNest(uint256 _id) external view returns (bool) {
452         return nest.inNest(_id);
453     }
454 
455     function getEggsInNest() external view returns (uint256[2]) {
456         return nest.getEggs();
457     }
458 
459     function getEgg(uint256 _id) external view returns (uint16, uint32, uint256[2], uint8[11], uint8[11]) {
460         uint256[2] memory parents;
461         uint8 _dragonType;
462         (parents, _dragonType) = eggCore.get(_id);
463 
464         uint8[11] memory momDragonTypes;
465         uint8[11] memory dadDragonTypes;
466         uint32 coolness;
467         uint16 gen;
468         // if genesis
469         if (parents[0] == 0 && parents[1] == 0) {
470             momDragonTypes[_dragonType] = 100;
471             dadDragonTypes[_dragonType] = 100;
472             coolness = 3600;
473         } else {
474             momDragonTypes = dragonGetter.getDragonTypes(parents[0]);
475             dadDragonTypes = dragonGetter.getDragonTypes(parents[1]);
476             coolness = dragonGetter.getCoolness(parents[0]).add(dragonGetter.getCoolness(parents[1])).div(2);
477             uint16 _momGeneration = dragonGetter.getGeneration(parents[0]);
478             uint16 _dadGeneration = dragonGetter.getGeneration(parents[1]);
479             gen = _max(_momGeneration, _dadGeneration).add(1);
480         }
481         return (gen, coolness, parents, momDragonTypes, dadDragonTypes);
482     }
483 
484     function getDragonChildren(uint256 _id) external view returns (
485         uint256[10] dragonsChildren,
486         uint256[10] eggsChildren
487     ) {
488         uint8 _counter;
489         uint256[2] memory _parents;
490         uint256 i;
491         for (i = _id.add(1); i <= dragonGetter.getAmount() && _counter < 10; i++) {
492             _parents = dragonGetter.getParents(i);
493             if (_parents[0] == _id || _parents[1] == _id) {
494                 dragonsChildren[_counter] = i;
495                 _counter = _counter.add(1);
496             }
497         }
498         _counter = 0;
499         uint256[] memory eggs = eggCore.getAllEggs();
500         for (i = 0; i < eggs.length && _counter < 10; i++) {
501             (_parents, ) = eggCore.get(eggs[i]);
502             if (_parents[0] == _id || _parents[1] == _id) {
503                 eggsChildren[_counter] = eggs[i];
504                 _counter = _counter.add(1);
505             }
506         }
507     }
508 
509     function getDragonsFromLeaderboard() external view returns (uint256[10]) {
510         return leaderboard.getDragonsFromLeaderboard();
511     }
512 
513     function getLeaderboardRewards(
514         uint256 _hatchingPrice
515     ) external view returns (
516         uint256[10]
517     ) {
518         return leaderboard.getRewards(_hatchingPrice);
519     }
520 
521     function getLeaderboardRewardDate() external view returns (uint256, uint256) {
522         return leaderboard.getDate();
523     }
524 
525     // UPDATE CONTRACT
526 
527     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
528         super.setInternalDependencies(_newDependencies);
529 
530         dragonCore = DragonCore(_newDependencies[0]);
531         dragonGetter = DragonGetter(_newDependencies[1]);
532         dragonGenetics = DragonGenetics(_newDependencies[2]);
533         eggCore = EggCore(_newDependencies[3]);
534         leaderboard = DragonLeaderboard(_newDependencies[4]);
535         nest = Nest(_newDependencies[5]);
536     }
537 }