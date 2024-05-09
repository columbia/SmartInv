1 pragma solidity 0.4.25;
2 
3 library SafeMath32 {
4 
5     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
6         if (a == 0) {
7             return 0;
8         }
9         uint32 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint32 a, uint32 b) internal pure returns (uint32) {
15         return a / b;
16     }
17 
18     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint32 a, uint32 b) internal pure returns (uint32) {
24         uint32 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint32 a, uint32 b) internal pure returns (uint32) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint32 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 library SafeMath256 {
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a / b;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         assert(b <= a);
56         return a - b;
57     }
58 
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 
65     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) return 0;
67         if (b == 0) return 1;
68 
69         uint256 c = a ** b;
70         assert(c / (a ** (b - 1)) == a);
71         return c;
72     }
73 }
74 
75 contract Ownable {
76     address public owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     function _validateAddress(address _addr) internal pure {
81         require(_addr != address(0), "invalid address");
82     }
83 
84     constructor() public {
85         owner = msg.sender;
86     }
87 
88     modifier onlyOwner() {
89         require(msg.sender == owner, "not a contract owner");
90         _;
91     }
92 
93     function transferOwnership(address newOwner) public onlyOwner {
94         _validateAddress(newOwner);
95         emit OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97     }
98 
99 }
100 
101 contract Controllable is Ownable {
102     mapping(address => bool) controllers;
103 
104     modifier onlyController {
105         require(_isController(msg.sender), "no controller rights");
106         _;
107     }
108 
109     function _isController(address _controller) internal view returns (bool) {
110         return controllers[_controller];
111     }
112 
113     function _setControllers(address[] _controllers) internal {
114         for (uint256 i = 0; i < _controllers.length; i++) {
115             _validateAddress(_controllers[i]);
116             controllers[_controllers[i]] = true;
117         }
118     }
119 }
120 
121 contract Upgradable is Controllable {
122     address[] internalDependencies;
123     address[] externalDependencies;
124 
125     function getInternalDependencies() public view returns(address[]) {
126         return internalDependencies;
127     }
128 
129     function getExternalDependencies() public view returns(address[]) {
130         return externalDependencies;
131     }
132 
133     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
134         for (uint256 i = 0; i < _newDependencies.length; i++) {
135             _validateAddress(_newDependencies[i]);
136         }
137         internalDependencies = _newDependencies;
138     }
139 
140     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
141         externalDependencies = _newDependencies;
142         _setControllers(_newDependencies);
143     }
144 }
145 
146 contract ERC721Token {
147     function ownerOf(uint256) public view returns (address);
148     function exists(uint256) public view returns (bool);
149 }
150 
151 contract DragonModel {
152 
153     struct HealthAndMana {
154         uint256 timestamp; 
155         uint32 remainingHealth;
156         uint32 remainingMana; 
157         uint32 maxHealth;
158         uint32 maxMana;
159     }
160 
161     struct Level {
162         uint8 level;
163         uint8 experience;
164         uint16 dnaPoints;
165     }
166     
167     struct Tactics {
168         uint8 melee;
169         uint8 attack;
170     }
171 
172     struct Battles {
173         uint16 wins;
174         uint16 defeats;
175     }
176 
177     struct Skills {
178         uint32 attack;
179         uint32 defense;
180         uint32 stamina;
181         uint32 speed;
182         uint32 intelligence;
183     }
184     
185     struct Dragon {
186         uint16 generation;
187         uint256[4] genome;
188         uint256[2] parents;
189         uint8[11] types;
190         uint256 birth;
191     }
192 
193 }
194 
195 contract DragonStorage is DragonModel, ERC721Token {
196     Dragon[] public dragons;
197     mapping (uint256 => bytes32) public names;
198     mapping (uint256 => HealthAndMana) public healthAndMana;
199     mapping (uint256 => Tactics) public tactics;
200     mapping (uint256 => Battles) public battles;
201     mapping (uint256 => Skills) public skills;
202     mapping (uint256 => Level) public levels;
203     mapping (uint256 => uint32) public coolness;
204     mapping (uint256 => uint8) public specialAttacks;
205     mapping (uint256 => uint8) public specialDefenses;
206     mapping (uint256 => mapping (uint8 => uint32)) public buffs;
207 
208     function length() external view returns (uint256) {}
209     function getGenome(uint256 _id) external view returns (uint256[4]) {}
210     function getParents(uint256 _id) external view returns (uint256[2]) {}
211     function getDragonTypes(uint256 _id) external view returns (uint8[11]) {}
212 }
213 
214 contract DragonCoreHelper {
215     function calculateFullRegenerationTime(uint32) external pure returns (uint32) {}
216     function calculateSpecialBattleSkill(uint8, uint32[5]) external pure returns (uint32, uint8, uint8) {}
217     function getActiveGenes(uint256[4]) external pure returns (uint8[30]) {}
218 }
219 
220 contract DragonCore {
221     function isBreedingAllowed(uint8, uint16) public view returns (bool) {}
222     function calculateMaxHealthAndManaWithBuffs(uint256) public view returns (uint32, uint32) {}
223     function getCurrentHealthAndMana(uint256) public view returns (uint32, uint32, uint8, uint8) {}
224     function calculateSpecialPeacefulSkill(uint256) public view returns (uint8, uint32, uint32) {}
225 }
226 
227 
228 
229 
230 //////////////CONTRACT//////////////
231 
232 
233 
234 
235 contract DragonGetter is Upgradable {
236     using SafeMath32 for uint32;
237     using SafeMath256 for uint256;
238 
239     DragonStorage _storage_;
240     DragonCore dragonCore;
241     DragonCoreHelper helper;
242 
243     uint256 constant GOLD_DECIMALS = 10 ** 18;
244 
245     uint256 constant DRAGON_NAME_2_LETTERS_PRICE = 100000 * GOLD_DECIMALS;
246     uint256 constant DRAGON_NAME_3_LETTERS_PRICE = 10000 * GOLD_DECIMALS;
247     uint256 constant DRAGON_NAME_4_LETTERS_PRICE = 1000 * GOLD_DECIMALS;
248 
249     function _checkExistence(uint256 _id) internal view {
250         require(_storage_.exists(_id), "dragon doesn't exist");
251     }
252 
253     function _min(uint32 lth, uint32 rth) internal pure returns (uint32) {
254         return lth > rth ? rth : lth;
255     }
256 
257     // GETTERS
258 
259     function getAmount() external view returns (uint256) {
260         return _storage_.length().sub(1);
261     }
262 
263     function isOwner(address _user, uint256 _tokenId) external view returns (bool) {
264         return _user == _storage_.ownerOf(_tokenId);
265     }
266 
267     function ownerOf(uint256 _tokenId) external view returns (address) {
268         return _storage_.ownerOf(_tokenId);
269     }
270 
271     function getGenome(uint256 _id) public view returns (uint8[30]) {
272         _checkExistence(_id);
273         return helper.getActiveGenes(_storage_.getGenome(_id));
274     }
275 
276     function getComposedGenome(uint256 _id) external view returns (uint256[4]) {
277         _checkExistence(_id);
278         return _storage_.getGenome(_id);
279     }
280 
281     function getSkills(uint256 _id) external view returns (uint32, uint32, uint32, uint32, uint32) {
282         _checkExistence(_id);
283         return _storage_.skills(_id);
284     }
285 
286     // should be divided by 100
287     function getCoolness(uint256 _id) public view returns (uint32) {
288         _checkExistence(_id);
289         return _storage_.coolness(_id);
290     }
291 
292     function getLevel(uint256 _id) public view returns (uint8 level) {
293         _checkExistence(_id);
294         (level, , ) = _storage_.levels(_id);
295     }
296 
297     function getHealthAndMana(uint256 _id) external view returns (
298         uint256 timestamp,
299         uint32 remainingHealth,
300         uint32 remainingMana,
301         uint32 maxHealth,
302         uint32 maxMana
303     ) {
304         _checkExistence(_id);
305         (
306             timestamp,
307             remainingHealth,
308             remainingMana,
309             maxHealth,
310             maxMana
311         ) = _storage_.healthAndMana(_id);
312         (maxHealth, maxMana) = dragonCore.calculateMaxHealthAndManaWithBuffs(_id);
313 
314         remainingHealth = _min(remainingHealth, maxHealth);
315         remainingMana = _min(remainingMana, maxMana);
316     }
317 
318     function getCurrentHealthAndMana(uint256 _id) external view returns (
319         uint32, uint32, uint8, uint8
320     ) {
321         _checkExistence(_id);
322         return dragonCore.getCurrentHealthAndMana(_id);
323     }
324 
325     function getFullRegenerationTime(uint256 _id) external view returns (uint32) {
326         _checkExistence(_id);
327         ( , , , uint32 _maxHealth, ) = _storage_.healthAndMana(_id);
328         return helper.calculateFullRegenerationTime(_maxHealth);
329     }
330 
331     function getDragonTypes(uint256 _id) external view returns (uint8[11]) {
332         _checkExistence(_id);
333         return _storage_.getDragonTypes(_id);
334     }
335 
336     function getProfile(uint256 _id) external view returns (
337         bytes32 name,
338         uint16 generation,
339         uint256 birth,
340         uint8 level,
341         uint8 experience,
342         uint16 dnaPoints,
343         bool isBreedingAllowed,
344         uint32 coolness
345     ) {
346         _checkExistence(_id);
347         name = _storage_.names(_id);
348         (level, experience, dnaPoints) = _storage_.levels(_id);
349         isBreedingAllowed = dragonCore.isBreedingAllowed(level, dnaPoints);
350         (generation, birth) = _storage_.dragons(_id);
351         coolness = _storage_.coolness(_id);
352 
353     }
354 
355     function getGeneration(uint256 _id) external view returns (uint16 generation) {
356         _checkExistence(_id);
357         (generation, ) = _storage_.dragons(_id);
358     }
359 
360     function isBreedingAllowed(uint256 _id) external view returns (bool) {
361         _checkExistence(_id);
362         uint8 _level;
363         uint16 _dnaPoints;
364         (_level, , _dnaPoints) = _storage_.levels(_id);
365         return dragonCore.isBreedingAllowed(_level, _dnaPoints);
366     }
367 
368     function getTactics(uint256 _id) external view returns (uint8, uint8) {
369         _checkExistence(_id);
370         return _storage_.tactics(_id);
371     }
372 
373     function getBattles(uint256 _id) external view returns (uint16, uint16) {
374         _checkExistence(_id);
375         return _storage_.battles(_id);
376     }
377 
378     function getParents(uint256 _id) external view returns (uint256[2]) {
379         _checkExistence(_id);
380         return _storage_.getParents(_id);
381     }
382 
383     function _getSpecialBattleSkill(uint256 _id, uint8 _dragonType) internal view returns (
384         uint32 cost,
385         uint8 factor,
386         uint8 chance
387     ) {
388         _checkExistence(_id);
389         uint32 _attack;
390         uint32 _defense;
391         uint32 _stamina;
392         uint32 _speed;
393         uint32 _intelligence;
394         (_attack, _defense, _stamina, _speed, _intelligence) = _storage_.skills(_id);
395         return helper.calculateSpecialBattleSkill(_dragonType, [_attack, _defense, _stamina, _speed, _intelligence]);
396     }
397 
398     function getSpecialAttack(uint256 _id) external view returns (
399         uint8 dragonType,
400         uint32 cost,
401         uint8 factor,
402         uint8 chance
403     ) {
404         _checkExistence(_id);
405         dragonType = _storage_.specialAttacks(_id);
406         (cost, factor, chance) = _getSpecialBattleSkill(_id, dragonType);
407     }
408 
409     function getSpecialDefense(uint256 _id) external view returns (
410         uint8 dragonType,
411         uint32 cost,
412         uint8 factor,
413         uint8 chance
414     ) {
415         _checkExistence(_id);
416         dragonType = _storage_.specialDefenses(_id);
417         (cost, factor, chance) = _getSpecialBattleSkill(_id, dragonType);
418     }
419 
420     function getSpecialPeacefulSkill(uint256 _id) external view returns (uint8, uint32, uint32) {
421         _checkExistence(_id);
422         return dragonCore.calculateSpecialPeacefulSkill(_id);
423     }
424 
425     function getBuffs(uint256 _id) external view returns (uint32[5]) {
426         _checkExistence(_id);
427         return [
428             _storage_.buffs(_id, 1), // attack
429             _storage_.buffs(_id, 2), // defense
430             _storage_.buffs(_id, 3), // stamina
431             _storage_.buffs(_id, 4), // speed
432             _storage_.buffs(_id, 5)  // intelligence
433         ];
434     }
435 
436     function getDragonStrength(uint256 _id) external view returns (uint32 sum) {
437         _checkExistence(_id);
438         uint32 _attack;
439         uint32 _defense;
440         uint32 _stamina;
441         uint32 _speed;
442         uint32 _intelligence;
443         (_attack, _defense, _stamina, _speed, _intelligence) = _storage_.skills(_id);
444         sum = sum.add(_attack.mul(69));
445         sum = sum.add(_defense.mul(217));
446         sum = sum.add(_stamina.mul(232));
447         sum = sum.add(_speed.mul(114));
448         sum = sum.add(_intelligence.mul(151));
449         sum = sum.div(100);
450     }
451 
452     function getDragonNamePriceByLength(uint256 _length) external pure returns (uint256) {
453         if (_length == 2) {
454             return DRAGON_NAME_2_LETTERS_PRICE;
455         } else if (_length == 3) {
456             return DRAGON_NAME_3_LETTERS_PRICE;
457         } else {
458             return DRAGON_NAME_4_LETTERS_PRICE;
459         }
460     }
461 
462     function getDragonNamePrices() external pure returns (uint8[3] lengths, uint256[3] prices) {
463         lengths = [2, 3, 4];
464         prices = [
465             DRAGON_NAME_2_LETTERS_PRICE,
466             DRAGON_NAME_3_LETTERS_PRICE,
467             DRAGON_NAME_4_LETTERS_PRICE
468         ];
469     }
470 
471     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
472         super.setInternalDependencies(_newDependencies);
473 
474         _storage_ = DragonStorage(_newDependencies[0]);
475         dragonCore = DragonCore(_newDependencies[1]);
476         helper = DragonCoreHelper(_newDependencies[2]);
477     }
478 }