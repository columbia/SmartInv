1 pragma solidity 0.4.25;
2 
3 
4 
5 library SafeMath16 {
6 
7     function mul(uint16 a, uint16 b) internal pure returns (uint16) {
8         if (a == 0) {
9             return 0;
10         }
11         uint16 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint16 a, uint16 b) internal pure returns (uint16) {
17         return a / b;
18     }
19 
20     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint16 a, uint16 b) internal pure returns (uint16) {
26         uint16 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31     function pow(uint16 a, uint16 b) internal pure returns (uint16) {
32         if (a == 0) return 0;
33         if (b == 0) return 1;
34 
35         uint16 c = a ** b;
36         assert(c / (a ** (b - 1)) == a);
37         return c;
38     }
39 }
40 
41 library SafeMath32 {
42 
43     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
44         if (a == 0) {
45             return 0;
46         }
47         uint32 c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51 
52     function div(uint32 a, uint32 b) internal pure returns (uint32) {
53         return a / b;
54     }
55 
56     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
57         assert(b <= a);
58         return a - b;
59     }
60 
61     function add(uint32 a, uint32 b) internal pure returns (uint32) {
62         uint32 c = a + b;
63         assert(c >= a);
64         return c;
65     }
66 
67     function pow(uint32 a, uint32 b) internal pure returns (uint32) {
68         if (a == 0) return 0;
69         if (b == 0) return 1;
70 
71         uint32 c = a ** b;
72         assert(c / (a ** (b - 1)) == a);
73         return c;
74     }
75 }
76 
77 library SafeMath256 {
78 
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         if (a == 0) {
81             return 0;
82         }
83         uint256 c = a * b;
84         assert(c / a == b);
85         return c;
86     }
87 
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return a / b;
90     }
91 
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         assert(b <= a);
94         return a - b;
95     }
96 
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         uint256 c = a + b;
99         assert(c >= a);
100         return c;
101     }
102 
103     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) return 0;
105         if (b == 0) return 1;
106 
107         uint256 c = a ** b;
108         assert(c / (a ** (b - 1)) == a);
109         return c;
110     }
111 }
112 
113 library SafeConvert {
114 
115     function toUint8(uint256 _value) internal pure returns (uint8) {
116         assert(_value <= 255);
117         return uint8(_value);
118     }
119 
120     function toUint16(uint256 _value) internal pure returns (uint16) {
121         assert(_value <= 2**16 - 1);
122         return uint16(_value);
123     }
124 
125     function toUint32(uint256 _value) internal pure returns (uint32) {
126         assert(_value <= 2**32 - 1);
127         return uint32(_value);
128     }
129 }
130 
131 contract Ownable {
132     address public owner;
133 
134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 
136     function _validateAddress(address _addr) internal pure {
137         require(_addr != address(0), "invalid address");
138     }
139 
140     constructor() public {
141         owner = msg.sender;
142     }
143 
144     modifier onlyOwner() {
145         require(msg.sender == owner, "not a contract owner");
146         _;
147     }
148 
149     function transferOwnership(address newOwner) public onlyOwner {
150         _validateAddress(newOwner);
151         emit OwnershipTransferred(owner, newOwner);
152         owner = newOwner;
153     }
154 
155 }
156 
157 contract Controllable is Ownable {
158     mapping(address => bool) controllers;
159 
160     modifier onlyController {
161         require(_isController(msg.sender), "no controller rights");
162         _;
163     }
164 
165     function _isController(address _controller) internal view returns (bool) {
166         return controllers[_controller];
167     }
168 
169     function _setControllers(address[] _controllers) internal {
170         for (uint256 i = 0; i < _controllers.length; i++) {
171             _validateAddress(_controllers[i]);
172             controllers[_controllers[i]] = true;
173         }
174     }
175 }
176 
177 contract Upgradable is Controllable {
178     address[] internalDependencies;
179     address[] externalDependencies;
180 
181     function getInternalDependencies() public view returns(address[]) {
182         return internalDependencies;
183     }
184 
185     function getExternalDependencies() public view returns(address[]) {
186         return externalDependencies;
187     }
188 
189     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
190         for (uint256 i = 0; i < _newDependencies.length; i++) {
191             _validateAddress(_newDependencies[i]);
192         }
193         internalDependencies = _newDependencies;
194     }
195 
196     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
197         externalDependencies = _newDependencies;
198         _setControllers(_newDependencies);
199     }
200 }
201 
202 contract ERC721Token {
203     function ownerOf(uint256 _tokenId) public view returns (address _owner);
204 }
205 
206 contract DragonCoreHelper {
207     function calculateCurrent(uint256, uint32, uint32) external pure returns (uint32, uint8) {}
208     function calculateHealthAndMana(uint32, uint32, uint32, uint32) external pure returns (uint32, uint32) {}
209     function getSpecialBattleSkillDragonType(uint8[11], uint256) external pure returns (uint8) {}
210     function calculateSpecialPeacefulSkill(uint8, uint32[5], uint32[5]) external pure returns (uint32, uint32) {}
211     function calculateCoolness(uint256[4]) external pure returns (uint32) {}
212     function calculateSkills(uint256[4]) external pure returns (uint32, uint32, uint32, uint32, uint32) {}
213     function calculateExperience(uint8, uint256, uint16, uint256) external pure returns (uint8, uint256, uint16) {}
214     function checkAndConvertName(string) external pure returns(bytes32, bytes32) {}
215     function upgradeGenes(uint256[4], uint16[10], uint16) external pure returns (uint256[4], uint16) {}
216 }
217 
218 contract DragonParams {
219     function dnaPoints(uint8) external pure returns (uint16) {}
220 }
221 
222 contract DragonModel {
223 
224     struct HealthAndMana {
225         uint256 timestamp; 
226         uint32 remainingHealth;
227         uint32 remainingMana; 
228         uint32 maxHealth;
229         uint32 maxMana;
230     }
231 
232     struct Level {
233         uint8 level;
234         uint8 experience;
235         uint16 dnaPoints;
236     }
237 
238     struct Battles {
239         uint16 wins;
240         uint16 defeats;
241     }
242 
243     struct Skills {
244         uint32 attack;
245         uint32 defense;
246         uint32 stamina;
247         uint32 speed;
248         uint32 intelligence;
249     }
250 
251 }
252 
253 contract DragonStorage is DragonModel, ERC721Token {
254     mapping (bytes32 => bool) public existingNames;
255     mapping (uint256 => bytes32) public names;
256     mapping (uint256 => HealthAndMana) public healthAndMana;
257     mapping (uint256 => Battles) public battles;
258     mapping (uint256 => Skills) public skills;
259     mapping (uint256 => Level) public levels;
260     mapping (uint256 => uint8) public specialPeacefulSkills;
261     mapping (uint256 => mapping (uint8 => uint32)) public buffs;
262 
263     function getGenome(uint256) external pure returns (uint256[4]) {}
264 
265     function push(address, uint16, uint256[4], uint256[2], uint8[11]) public returns (uint256) {}
266     function setName(uint256, bytes32, bytes32) external {}
267     function setTactics(uint256, uint8, uint8) external {}
268     function setWins(uint256, uint16) external {}
269     function setDefeats(uint256, uint16) external {}
270     function setMaxHealthAndMana(uint256, uint32, uint32) external {}
271     function setRemainingHealthAndMana(uint256, uint32, uint32) external {}
272     function resetHealthAndManaTimestamp(uint256) external {}
273     function setSkills(uint256, uint32, uint32, uint32, uint32, uint32) external {}
274     function setLevel(uint256, uint8, uint8, uint16) external {}
275     function setCoolness(uint256, uint32) external {}
276     function setGenome(uint256, uint256[4]) external {}
277     function setSpecialAttack(uint256, uint8) external {}
278     function setSpecialDefense(uint256, uint8) external {}
279     function setSpecialPeacefulSkill(uint256, uint8) external {}
280     function setBuff(uint256, uint8, uint32) external {}
281 }
282 
283 contract Random {
284     function random(uint256) external pure returns (uint256) {}
285     function randomOfBlock(uint256, uint256) external pure returns (uint256) {}
286 }
287 
288 
289 
290 
291 //////////////CONTRACT//////////////
292 
293 
294 
295 
296 contract DragonBase is Upgradable {
297     using SafeMath32 for uint32;
298     using SafeMath256 for uint256;
299     using SafeConvert for uint32;
300     using SafeConvert for uint256;
301 
302     DragonStorage _storage_;
303     DragonParams params;
304     DragonCoreHelper helper;
305     Random random;
306 
307     function _identifySpecialBattleSkills(
308         uint256 _id,
309         uint8[11] _dragonTypes
310     ) internal {
311         uint256 _randomSeed = random.random(10000); // generate 4-digit number in range [0, 9999]
312         uint256 _attackRandom = _randomSeed % 100; // 2-digit number (last 2 digits)
313         uint256 _defenseRandom = _randomSeed / 100; // 2-digit number (first 2 digits)
314 
315         // we have 100 variations of random number but genes only 40, so we calculate random [0..39]
316         _attackRandom = _attackRandom.mul(4).div(10);
317         _defenseRandom = _defenseRandom.mul(4).div(10);
318 
319         uint8 _attackType = helper.getSpecialBattleSkillDragonType(_dragonTypes, _attackRandom);
320         uint8 _defenseType = helper.getSpecialBattleSkillDragonType(_dragonTypes, _defenseRandom);
321 
322         _storage_.setSpecialAttack(_id, _attackType);
323         _storage_.setSpecialDefense(_id, _defenseType);
324     }
325 
326     function _setSkillsAndHealthAndMana(uint256 _id, uint256[4] _genome, uint8[11] _dragonTypes) internal {
327         (
328             uint32 _attack,
329             uint32 _defense,
330             uint32 _stamina,
331             uint32 _speed,
332             uint32 _intelligence
333         ) = helper.calculateSkills(_genome);
334 
335         _storage_.setSkills(_id, _attack, _defense, _stamina, _speed, _intelligence);
336 
337         _identifySpecialBattleSkills(_id, _dragonTypes);
338 
339         (
340             uint32 _health,
341             uint32 _mana
342         ) = helper.calculateHealthAndMana(_stamina, _intelligence, 0, 0);
343         _storage_.setMaxHealthAndMana(_id, _health, _mana);
344     }
345 
346     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
347         super.setInternalDependencies(_newDependencies);
348 
349         _storage_ = DragonStorage(_newDependencies[0]);
350         params = DragonParams(_newDependencies[1]);
351         helper = DragonCoreHelper(_newDependencies[2]);
352         random = Random(_newDependencies[3]);
353     }
354 }
355 
356 contract DragonCore is DragonBase {
357     using SafeMath16 for uint16;
358 
359     uint8 constant MAX_LEVEL = 10; // max dragon level
360 
361     uint8 constant MAX_TACTICS_PERCENTAGE = 80;
362     uint8 constant MIN_TACTICS_PERCENTAGE = 20;
363 
364     uint8 constant MAX_GENE_LVL = 99; // max dragon gene level
365 
366     uint8 constant NUMBER_OF_SPECIAL_PEACEFUL_SKILL_CLASSES = 8; // first is empty skill
367 
368     // does dragon have enough DNA points for breeding?
369     function isBreedingAllowed(uint8 _level, uint16 _dnaPoints) public view returns (bool) {
370         return _level > 0 && _dnaPoints >= params.dnaPoints(_level);
371     }
372 
373     function _checkIfEnoughPoints(bool _isEnough) internal pure {
374         require(_isEnough, "not enough points");
375     }
376 
377     function _validateSpecialPeacefulSkillClass(uint8 _class) internal pure {
378         require(_class > 0 && _class < NUMBER_OF_SPECIAL_PEACEFUL_SKILL_CLASSES, "wrong class of special peaceful skill");
379     }
380 
381     function _checkIfSpecialPeacefulSkillAvailable(bool _isAvailable) internal pure {
382         require(_isAvailable, "special peaceful skill selection is not available");
383     }
384 
385     function _getBuff(uint256 _id, uint8 _class) internal view returns (uint32) {
386         return _storage_.buffs(_id, _class);
387     }
388 
389     function _getAllBuffs(uint256 _id) internal view returns (uint32[5]) {
390         return [
391             _getBuff(_id, 1),
392             _getBuff(_id, 2),
393             _getBuff(_id, 3),
394             _getBuff(_id, 4),
395             _getBuff(_id, 5)
396         ];
397     }
398 
399     // GETTERS
400 
401     function calculateMaxHealthAndManaWithBuffs(uint256 _id) public view returns (
402         uint32 maxHealth,
403         uint32 maxMana
404     ) {
405         (, , uint32 _stamina, , uint32 _intelligence) = _storage_.skills(_id);
406 
407         (
408             maxHealth,
409             maxMana
410         ) = helper.calculateHealthAndMana(
411             _stamina,
412             _intelligence,
413             _getBuff(_id, 3), // stamina buff
414             _getBuff(_id, 5) // intelligence buff
415         );
416     }
417 
418     function getCurrentHealthAndMana(uint256 _id) public view returns (
419         uint32 health,
420         uint32 mana,
421         uint8 healthPercentage,
422         uint8 manaPercentage
423     ) {
424         (
425             uint256 _timestamp,
426             uint32 _remainingHealth,
427             uint32 _remainingMana,
428             uint32 _maxHealth,
429             uint32 _maxMana
430         ) = _storage_.healthAndMana(_id);
431 
432         (_maxHealth, _maxMana) = calculateMaxHealthAndManaWithBuffs(_id);
433 
434         uint256 _pastTime = now.sub(_timestamp); // solium-disable-line security/no-block-members
435         (health, healthPercentage) = helper.calculateCurrent(_pastTime, _maxHealth, _remainingHealth);
436         (mana, manaPercentage) = helper.calculateCurrent(_pastTime, _maxMana, _remainingMana);
437     }
438 
439     // SETTERS
440 
441     function setRemainingHealthAndMana(
442         uint256 _id,
443         uint32 _remainingHealth,
444         uint32 _remainingMana
445     ) external onlyController {
446         _storage_.setRemainingHealthAndMana(_id, _remainingHealth, _remainingMana);
447     }
448 
449     function increaseExperience(uint256 _id, uint256 _factor) external onlyController {
450         (
451             uint8 _level,
452             uint256 _experience,
453             uint16 _dnaPoints
454         ) = _storage_.levels(_id);
455         uint8 _currentLevel = _level;
456         if (_level < MAX_LEVEL) {
457             (_level, _experience, _dnaPoints) = helper.calculateExperience(_level, _experience, _dnaPoints, _factor);
458             if (_level > _currentLevel) {
459                 // restore hp and mana if level up
460                 _storage_.resetHealthAndManaTimestamp(_id);
461             }
462             if (_level == MAX_LEVEL) {
463                 _experience = 0;
464             }
465             _storage_.setLevel(_id, _level, _experience.toUint8(), _dnaPoints);
466         }
467     }
468 
469     function payDNAPointsForBreeding(uint256 _id) external onlyController {
470         (
471             uint8 _level,
472             uint8 _experience,
473             uint16 _dnaPoints
474         ) = _storage_.levels(_id);
475 
476         _checkIfEnoughPoints(isBreedingAllowed(_level, _dnaPoints));
477         _dnaPoints = _dnaPoints.sub(params.dnaPoints(_level));
478 
479         _storage_.setLevel(_id, _level, _experience, _dnaPoints);
480     }
481 
482     function upgradeGenes(uint256 _id, uint16[10] _dnaPoints) external onlyController {
483         (
484             uint8 _level,
485             uint8 _experience,
486             uint16 _availableDNAPoints
487         ) = _storage_.levels(_id);
488 
489         uint16 _sum;
490         uint256[4] memory _newComposedGenome;
491         (
492             _newComposedGenome,
493             _sum
494         ) = helper.upgradeGenes(
495             _storage_.getGenome(_id),
496             _dnaPoints,
497             _availableDNAPoints
498         );
499 
500         require(_sum > 0, "DNA points were not used");
501 
502         _availableDNAPoints = _availableDNAPoints.sub(_sum);
503         // save data
504         _storage_.setLevel(_id, _level, _experience, _availableDNAPoints);
505         _storage_.setGenome(_id, _newComposedGenome);
506         _storage_.setCoolness(_id, helper.calculateCoolness(_newComposedGenome));
507         // recalculate skills
508         _saveSkills(_id, _newComposedGenome);
509     }
510 
511     function _saveSkills(uint256 _id, uint256[4] _genome) internal {
512         (
513             uint32 _attack,
514             uint32 _defense,
515             uint32 _stamina,
516             uint32 _speed,
517             uint32 _intelligence
518         ) = helper.calculateSkills(_genome);
519         (
520             uint32 _health,
521             uint32 _mana
522         ) = helper.calculateHealthAndMana(_stamina, _intelligence, 0, 0); // without buffs
523 
524         _storage_.setMaxHealthAndMana(_id, _health, _mana);
525         _storage_.setSkills(_id, _attack, _defense, _stamina, _speed, _intelligence);
526     }
527 
528     function increaseWins(uint256 _id) external onlyController {
529         (uint16 _wins, ) = _storage_.battles(_id);
530         _storage_.setWins(_id, _wins.add(1));
531     }
532 
533     function increaseDefeats(uint256 _id) external onlyController {
534         (, uint16 _defeats) = _storage_.battles(_id);
535         _storage_.setDefeats(_id, _defeats.add(1));
536     }
537 
538     function setTactics(uint256 _id, uint8 _melee, uint8 _attack) external onlyController {
539         require(
540             _melee >= MIN_TACTICS_PERCENTAGE &&
541             _melee <= MAX_TACTICS_PERCENTAGE &&
542             _attack >= MIN_TACTICS_PERCENTAGE &&
543             _attack <= MAX_TACTICS_PERCENTAGE,
544             "tactics value must be between 20 and 80"
545         );
546         _storage_.setTactics(_id, _melee, _attack);
547     }
548 
549     function calculateSpecialPeacefulSkill(uint256 _id) public view returns (
550         uint8 class,
551         uint32 cost,
552         uint32 effect
553     ) {
554         class = _storage_.specialPeacefulSkills(_id);
555         if (class == 0) return;
556         (
557             uint32 _attack,
558             uint32 _defense,
559             uint32 _stamina,
560             uint32 _speed,
561             uint32 _intelligence
562         ) = _storage_.skills(_id);
563 
564         (
565             cost,
566             effect
567         ) = helper.calculateSpecialPeacefulSkill(
568             class,
569             [_attack, _defense, _stamina, _speed, _intelligence],
570             _getAllBuffs(_id)
571         );
572     }
573 
574     function setSpecialPeacefulSkill(uint256 _id, uint8 _class) external onlyController {
575         (uint8 _level, , ) = _storage_.levels(_id);
576         uint8 _currentClass = _storage_.specialPeacefulSkills(_id);
577 
578         _checkIfSpecialPeacefulSkillAvailable(_level == MAX_LEVEL);
579         _validateSpecialPeacefulSkillClass(_class);
580         _checkIfSpecialPeacefulSkillAvailable(_currentClass == 0);
581 
582         _storage_.setSpecialPeacefulSkill(_id, _class);
583     }
584 
585     function _getBuffIndexBySpecialPeacefulSkillClass(
586         uint8 _class
587     ) internal pure returns (uint8) {
588         uint8[8] memory _buffsIndexes = [0, 1, 2, 3, 4, 5, 3, 5]; // 0 item - no such class
589         return _buffsIndexes[_class];
590     }
591 
592     // _id - dragon, which will use the skill
593     // _target - dragon, on which the skill will be used
594     // _sender - owner of the first dragon
595     function useSpecialPeacefulSkill(address _sender, uint256 _id, uint256 _target) external onlyController {
596         (
597             uint8 _class,
598             uint32 _cost,
599             uint32 _effect
600         ) = calculateSpecialPeacefulSkill(_id);
601         (
602             uint32 _health,
603             uint32 _mana, ,
604         ) = getCurrentHealthAndMana(_id);
605 
606         _validateSpecialPeacefulSkillClass(_class);
607         // enough mana
608         _checkIfEnoughPoints(_mana >= _cost);
609 
610         // subtract cost of special peaceful skill
611         _storage_.setRemainingHealthAndMana(_id, _health, _mana.sub(_cost));
612         // reset intelligence buff of the first dragon
613         _storage_.setBuff(_id, 5, 0);
614         // reset active skill buff of the first dragon
615         uint8 _buffIndexOfActiveSkill = _getBuffIndexBySpecialPeacefulSkillClass(_class);
616         _storage_.setBuff(_id, _buffIndexOfActiveSkill, 0);
617 
618         if (_class == 6 || _class == 7) { // health/mana restoration
619             (
620                 uint32 _targetHealth,
621                 uint32 _targetMana, ,
622             ) = getCurrentHealthAndMana(_target);
623             if (_class == 6) _targetHealth = _targetHealth.add(_effect); // restore health
624             if (_class == 7) _targetMana = _targetMana.add(_effect); // restore mana
625             // save restored health/mana
626             _storage_.setRemainingHealthAndMana(
627                 _target,
628                 _targetHealth,
629                 _targetMana
630             );
631         } else { // another special peaceful skills
632             if (_storage_.ownerOf(_target) != _sender) { // to prevert lower effect buffing
633                 require(_getBuff(_target, _class) < _effect, "you can't buff alien dragon by lower effect");
634             }
635             _storage_.setBuff(_target, _class, _effect);
636         }
637     }
638 
639     function setBuff(uint256 _id, uint8 _class, uint32 _effect) external onlyController {
640         _storage_.setBuff(_id, _class, _effect);
641     }
642 
643     function createDragon(
644         address _sender,
645         uint16 _generation,
646         uint256[2] _parents,
647         uint256[4] _genome,
648         uint8[11] _dragonTypes
649     ) external onlyController returns (uint256 newDragonId) {
650         newDragonId = _storage_.push(_sender, _generation, _genome, _parents, _dragonTypes);
651         uint32 _coolness = helper.calculateCoolness(_genome);
652         _storage_.setCoolness(newDragonId, _coolness);
653         _storage_.setTactics(newDragonId, 50, 50);
654         _setSkillsAndHealthAndMana(newDragonId, _genome, _dragonTypes);
655     }
656 
657     function setName(
658         uint256 _id,
659         string _name
660     ) external onlyController returns (bytes32) {
661         (
662             bytes32 _initial, // initial name that converted to bytes32
663             bytes32 _lowercase // name to lowercase
664         ) = helper.checkAndConvertName(_name);
665         require(!_storage_.existingNames(_lowercase), "name exists");
666         require(_storage_.names(_id) == 0x0, "dragon already has a name");
667         _storage_.setName(_id, _initial, _lowercase);
668         return _initial;
669     }
670 }