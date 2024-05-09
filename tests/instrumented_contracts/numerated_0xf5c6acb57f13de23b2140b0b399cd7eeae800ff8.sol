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
292     function _max(uint16 lth, uint16 rth) internal pure returns (uint16) {
293         if (lth > rth) {
294             return lth;
295         } else {
296             return rth;
297         }
298     }
299 
300     function createEgg(
301         address _sender,
302         uint8 _dragonType
303     ) external onlyController returns (uint256) {
304         return eggCore.create(_sender, [uint256(0), uint256(0)], _dragonType);
305     }
306 
307     function sendToNest(
308         uint256 _id
309     ) external onlyController returns (
310         bool isHatched,
311         uint256 newDragonId,
312         uint256 hatchedId,
313         address owner
314     ) {
315         uint256 _randomForEggOpening;
316         (isHatched, hatchedId, _randomForEggOpening) = nest.add(_id);
317         // if any egg was hatched
318         if (isHatched) {
319             owner = eggCore.ownerOf(hatchedId);
320             newDragonId = openEgg(owner, hatchedId, _randomForEggOpening);
321         }
322     }
323 
324     function openEgg(
325         address _owner,
326         uint256 _eggId,
327         uint256 _random
328     ) internal returns (uint256 newDragonId) {
329         uint256[2] memory _parents;
330         uint8 _dragonType;
331         (_parents, _dragonType) = eggCore.get(_eggId);
332 
333         uint256[4] memory _genome;
334         uint8[11] memory _dragonTypesArray;
335         uint16 _generation;
336         // if genesis
337         if (_parents[0] == 0 && _parents[1] == 0) {
338             _generation = 0;
339             _genome = dragonGenetics.createGenomeForGenesis(_dragonType, _random);
340             _dragonTypesArray[_dragonType] = 40; // 40 genes of 1 type
341         } else {
342             uint256[4] memory _momGenome = dragonGetter.getComposedGenome(_parents[0]);
343             uint256[4] memory _dadGenome = dragonGetter.getComposedGenome(_parents[1]);
344             (_genome, _dragonTypesArray) = dragonGenetics.createGenome(_parents, _momGenome, _dadGenome, _random);
345             _generation = _max(
346                 dragonGetter.getGeneration(_parents[0]),
347                 dragonGetter.getGeneration(_parents[1])
348             ).add(1);
349         }
350 
351         newDragonId = dragonCore.createDragon(_owner, _generation, _parents, _genome, _dragonTypesArray);
352         eggCore.remove(_owner, _eggId);
353 
354         uint32 _coolness = dragonGetter.getCoolness(newDragonId);
355         leaderboard.update(newDragonId, _coolness);
356     }
357 
358     function breed(
359         address _sender,
360         uint256 _momId,
361         uint256 _dadId
362     ) external onlyController returns (uint256) {
363         dragonCore.payDNAPointsForBreeding(_momId);
364         dragonCore.payDNAPointsForBreeding(_dadId);
365         return eggCore.create(_sender, [_momId, _dadId], 0);
366     }
367 
368     function setDragonRemainingHealthAndMana(uint256 _id, uint32 _health, uint32 _mana) external onlyController {
369         return dragonCore.setRemainingHealthAndMana(_id, _health, _mana);
370     }
371 
372     function increaseDragonExperience(uint256 _id, uint256 _factor) external onlyController {
373         dragonCore.increaseExperience(_id, _factor);
374     }
375 
376     function upgradeDragonGenes(uint256 _id, uint16[10] _dnaPoints) external onlyController {
377         dragonCore.upgradeGenes(_id, _dnaPoints);
378 
379         uint32 _coolness = dragonGetter.getCoolness(_id);
380         leaderboard.update(_id, _coolness);
381     }
382 
383     function increaseDragonWins(uint256 _id) external onlyController {
384         dragonCore.increaseWins(_id);
385     }
386 
387     function increaseDragonDefeats(uint256 _id) external onlyController {
388         dragonCore.increaseDefeats(_id);
389     }
390 
391     function setDragonTactics(uint256 _id, uint8 _melee, uint8 _attack) external onlyController {
392         dragonCore.setTactics(_id, _melee, _attack);
393     }
394 
395     function setDragonName(uint256 _id, string _name) external onlyController returns (bytes32) {
396         return dragonCore.setName(_id, _name);
397     }
398 
399     function setDragonSpecialPeacefulSkill(uint256 _id, uint8 _class) external onlyController {
400         dragonCore.setSpecialPeacefulSkill(_id, _class);
401     }
402 
403     function useDragonSpecialPeacefulSkill(
404         address _sender,
405         uint256 _id,
406         uint256 _target
407     ) external onlyController {
408         dragonCore.useSpecialPeacefulSkill(_sender, _id, _target);
409     }
410 
411     function resetDragonBuffs(uint256 _id) external onlyController {
412         dragonCore.setBuff(_id, 1, 0); // attack
413         dragonCore.setBuff(_id, 2, 0); // defense
414         dragonCore.setBuff(_id, 3, 0); // stamina
415         dragonCore.setBuff(_id, 4, 0); // speed
416         dragonCore.setBuff(_id, 5, 0); // intelligence
417     }
418 
419     function updateLeaderboardRewardTime() external onlyController {
420         return leaderboard.updateRewardTime();
421     }
422 
423     // GETTERS
424 
425     function getDragonFullRegenerationTime(uint256 _id) external view returns (uint32 time) {
426         return dragonGetter.getFullRegenerationTime(_id);
427     }
428 
429     function isEggOwner(address _user, uint256 _tokenId) external view returns (bool) {
430         return eggCore.isOwner(_user, _tokenId);
431     }
432 
433     function isEggInNest(uint256 _id) external view returns (bool) {
434         return nest.inNest(_id);
435     }
436 
437     function getEggsInNest() external view returns (uint256[2]) {
438         return nest.getEggs();
439     }
440 
441     function getEgg(uint256 _id) external view returns (uint16, uint32, uint256[2], uint8[11], uint8[11]) {
442         uint256[2] memory parents;
443         uint8 _dragonType;
444         (parents, _dragonType) = eggCore.get(_id);
445 
446         uint8[11] memory momDragonTypes;
447         uint8[11] memory dadDragonTypes;
448         uint32 coolness;
449         uint16 gen;
450         // if genesis
451         if (parents[0] == 0 && parents[1] == 0) {
452             momDragonTypes[_dragonType] = 100;
453             dadDragonTypes[_dragonType] = 100;
454             coolness = 3600;
455         } else {
456             momDragonTypes = dragonGetter.getDragonTypes(parents[0]);
457             dadDragonTypes = dragonGetter.getDragonTypes(parents[1]);
458             coolness = dragonGetter.getCoolness(parents[0]).add(dragonGetter.getCoolness(parents[1])).div(2);
459             uint16 _momGeneration = dragonGetter.getGeneration(parents[0]);
460             uint16 _dadGeneration = dragonGetter.getGeneration(parents[1]);
461             gen = _max(_momGeneration, _dadGeneration).add(1);
462         }
463         return (gen, coolness, parents, momDragonTypes, dadDragonTypes);
464     }
465 
466     function getDragonChildren(uint256 _id) external view returns (
467         uint256[10] dragonsChildren,
468         uint256[10] eggsChildren
469     ) {
470         uint8 _counter;
471         uint256[2] memory _parents;
472         uint256 i;
473         for (i = _id.add(1); i <= dragonGetter.getAmount() && _counter < 10; i++) {
474             _parents = dragonGetter.getParents(i);
475             if (_parents[0] == _id || _parents[1] == _id) {
476                 dragonsChildren[_counter] = i;
477                 _counter = _counter.add(1);
478             }
479         }
480         _counter = 0;
481         uint256[] memory eggs = eggCore.getAllEggs();
482         for (i = 0; i < eggs.length && _counter < 10; i++) {
483             (_parents, ) = eggCore.get(eggs[i]);
484             if (_parents[0] == _id || _parents[1] == _id) {
485                 eggsChildren[_counter] = eggs[i];
486                 _counter = _counter.add(1);
487             }
488         }
489     }
490 
491     function getDragonsFromLeaderboard() external view returns (uint256[10]) {
492         return leaderboard.getDragonsFromLeaderboard();
493     }
494 
495     function getLeaderboardRewards(
496         uint256 _hatchingPrice
497     ) external view returns (
498         uint256[10]
499     ) {
500         return leaderboard.getRewards(_hatchingPrice);
501     }
502 
503     function getLeaderboardRewardDate() external view returns (uint256, uint256) {
504         return leaderboard.getDate();
505     }
506 
507     // UPDATE CONTRACT
508 
509     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
510         super.setInternalDependencies(_newDependencies);
511 
512         dragonCore = DragonCore(_newDependencies[0]);
513         dragonGetter = DragonGetter(_newDependencies[1]);
514         dragonGenetics = DragonGenetics(_newDependencies[2]);
515         eggCore = EggCore(_newDependencies[3]);
516         leaderboard = DragonLeaderboard(_newDependencies[4]);
517         nest = Nest(_newDependencies[5]);
518     }
519 }