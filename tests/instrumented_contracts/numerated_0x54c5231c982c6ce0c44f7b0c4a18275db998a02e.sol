1 pragma solidity 0.4.25;
2 
3 library SafeConvert {
4 
5     function toUint8(uint256 _value) internal pure returns (uint8) {
6         assert(_value <= 255);
7         return uint8(_value);
8     }
9 
10     function toUint16(uint256 _value) internal pure returns (uint16) {
11         assert(_value <= 2**16 - 1);
12         return uint16(_value);
13     }
14 
15     function toUint32(uint256 _value) internal pure returns (uint32) {
16         assert(_value <= 2**32 - 1);
17         return uint32(_value);
18     }
19 }
20 
21 library SafeMath8 {
22 
23     function mul(uint8 a, uint8 b) internal pure returns (uint8) {
24         if (a == 0) {
25             return 0;
26         }
27         uint8 c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     function div(uint8 a, uint8 b) internal pure returns (uint8) {
33         return a / b;
34     }
35 
36     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint8 a, uint8 b) internal pure returns (uint8) {
42         uint8 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 
47     function pow(uint8 a, uint8 b) internal pure returns (uint8) {
48         if (a == 0) return 0;
49         if (b == 0) return 1;
50 
51         uint8 c = a ** b;
52         assert(c / (a ** (b - 1)) == a);
53         return c;
54     }
55 }
56 
57 library SafeMath32 {
58 
59     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
60         if (a == 0) {
61             return 0;
62         }
63         uint32 c = a * b;
64         assert(c / a == b);
65         return c;
66     }
67 
68     function div(uint32 a, uint32 b) internal pure returns (uint32) {
69         return a / b;
70     }
71 
72     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
73         assert(b <= a);
74         return a - b;
75     }
76 
77     function add(uint32 a, uint32 b) internal pure returns (uint32) {
78         uint32 c = a + b;
79         assert(c >= a);
80         return c;
81     }
82 
83     function pow(uint32 a, uint32 b) internal pure returns (uint32) {
84         if (a == 0) return 0;
85         if (b == 0) return 1;
86 
87         uint32 c = a ** b;
88         assert(c / (a ** (b - 1)) == a);
89         return c;
90     }
91 }
92 
93 library SafeMath256 {
94 
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         if (a == 0) {
97             return 0;
98         }
99         uint256 c = a * b;
100         assert(c / a == b);
101         return c;
102     }
103 
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return a / b;
106     }
107 
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         assert(b <= a);
110         return a - b;
111     }
112 
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         assert(c >= a);
116         return c;
117     }
118 
119     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
120         if (a == 0) return 0;
121         if (b == 0) return 1;
122 
123         uint256 c = a ** b;
124         assert(c / (a ** (b - 1)) == a);
125         return c;
126     }
127 }
128 
129 contract Ownable {
130     address public owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     function _validateAddress(address _addr) internal pure {
135         require(_addr != address(0), "invalid address");
136     }
137 
138     constructor() public {
139         owner = msg.sender;
140     }
141 
142     modifier onlyOwner() {
143         require(msg.sender == owner, "not a contract owner");
144         _;
145     }
146 
147     function transferOwnership(address newOwner) public onlyOwner {
148         _validateAddress(newOwner);
149         emit OwnershipTransferred(owner, newOwner);
150         owner = newOwner;
151     }
152 
153 }
154 
155 contract Controllable is Ownable {
156     mapping(address => bool) controllers;
157 
158     modifier onlyController {
159         require(_isController(msg.sender), "no controller rights");
160         _;
161     }
162 
163     function _isController(address _controller) internal view returns (bool) {
164         return controllers[_controller];
165     }
166 
167     function _setControllers(address[] _controllers) internal {
168         for (uint256 i = 0; i < _controllers.length; i++) {
169             _validateAddress(_controllers[i]);
170             controllers[_controllers[i]] = true;
171         }
172     }
173 }
174 
175 contract Upgradable is Controllable {
176     address[] internalDependencies;
177     address[] externalDependencies;
178 
179     function getInternalDependencies() public view returns(address[]) {
180         return internalDependencies;
181     }
182 
183     function getExternalDependencies() public view returns(address[]) {
184         return externalDependencies;
185     }
186 
187     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
188         for (uint256 i = 0; i < _newDependencies.length; i++) {
189             _validateAddress(_newDependencies[i]);
190         }
191         internalDependencies = _newDependencies;
192     }
193 
194     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
195         externalDependencies = _newDependencies;
196         _setControllers(_newDependencies);
197     }
198 }
199 
200 contract Getter {
201     function getDragonTypes(uint256) external view returns (uint8[11]) {}
202     function getDragonTactics(uint256) external view returns (uint8, uint8) {}
203     function getDragonSkills(uint256) external view returns (uint32, uint32, uint32, uint32, uint32) {}
204     function getDragonCurrentHealthAndMana(uint256) external view returns (uint32, uint32, uint8, uint8) {}
205     function getDragonMaxHealthAndMana(uint256) external view returns (uint32, uint32) {}
206     function getDragonSpecialAttack(uint256) external view returns (uint8, uint32, uint8, uint8) {}
207     function getDragonSpecialDefense(uint256) external view returns (uint8, uint32, uint8, uint8) {}
208     function getDragonBuffs(uint256) external view returns (uint32[5]) {}
209 }
210 
211 
212 
213 
214 //////////////CONTRACT//////////////
215 
216 
217 
218 
219 contract Battle is Upgradable {
220     using SafeMath8 for uint8;
221     using SafeMath32 for uint32;
222     using SafeMath256 for uint256;
223     using SafeConvert for uint256;
224 
225     Getter getter;
226 
227     struct Dragon {
228         uint256 id;
229         uint8 attackChance;
230         uint8 meleeChance;
231         uint32 health;
232         uint32 mana;
233         uint32 speed;
234         uint32 attack;
235         uint32 defense;
236         uint32 specialAttackCost;
237         uint8 specialAttackFactor;
238         uint8 specialAttackChance;
239         uint32 specialDefenseCost;
240         uint8 specialDefenseFactor;
241         uint8 specialDefenseChance;
242         bool blocking;
243         bool specialBlocking;
244     }
245 
246     uint8 constant __FLOAT_NUMBER_MULTIPLY = 10;
247 
248     // We have to divide each calculations
249     // with "__" postfix by __FLOAT_NUMBER_MULTIPLY
250     uint8 constant DISTANCE_ATTACK_WEAK__ = 8; // 0.8
251     uint8 constant DEFENSE_SUCCESS_MULTIPLY__ = 10; // 1
252     uint8 constant DEFENSE_FAIL_MULTIPLY__ = 2; // 0.2
253     uint8 constant FALLBACK_SPEED_FACTOR__ = 7; // 0.7
254 
255     uint32 constant MAX_MELEE_ATTACK_DISTANCE = 100; // 1, multiplied as skills
256     uint32 constant MIN_RANGE_ATTACK_DISTANCE = 300; // 3, multiplied as skills
257 
258     uint8 constant MAX_TURNS = 70;
259 
260     uint8 constant DRAGON_TYPE_FACTOR = 5; // 0.5
261 
262     uint16 constant DRAGON_TYPE_MULTIPLY = 1600;
263 
264     uint8 constant PERCENT_MULTIPLIER = 100;
265 
266 
267     uint256 battlesCounter;
268 
269     // values in the range of 0..99
270     function _getRandomNumber(
271         uint256 _initialSeed,
272         uint256 _currentSeed_
273     ) internal pure returns(uint8, uint256) {
274         uint256 _currentSeed = _currentSeed_;
275         if (_currentSeed == 0) {
276             _currentSeed = _initialSeed;
277         }
278         uint8 _random = (_currentSeed % 100).toUint8();
279         _currentSeed = _currentSeed.div(100);
280         return (_random, _currentSeed);
281     }
282 
283     function _safeSub(uint32 a, uint32 b) internal pure returns(uint32) {
284         return b > a ? 0 : a.sub(b);
285     }
286 
287     function _multiplyByFloatNumber(uint32 _number, uint8 _multiplier) internal pure returns (uint32) {
288         return _number.mul(_multiplier).div(__FLOAT_NUMBER_MULTIPLY);
289     }
290 
291     function _calculatePercentage(uint32 _part, uint32 _full) internal pure returns (uint32) {
292         return _part.mul(PERCENT_MULTIPLIER).div(_full);
293     }
294 
295     function _calculateDragonTypeMultiply(uint8[11] _attackerTypesArray, uint8[11] _defenderTypesArray) internal pure returns (uint32) {
296         uint32 dragonTypeSumMultiply = 0;
297         uint8 _currentDefenderType;
298         uint32 _dragonTypeMultiply;
299 
300         for (uint8 _attackerType = 0; _attackerType < _attackerTypesArray.length; _attackerType++) {
301             if (_attackerTypesArray[_attackerType] != 0) {
302                 for (uint8 _defenderType = 0; _defenderType < _defenderTypesArray.length; _defenderType++) {
303                     if (_defenderTypesArray[_defenderType] != 0) {
304                         _currentDefenderType = _defenderType;
305 
306                         if (_currentDefenderType < _attackerType) {
307                             _currentDefenderType = _currentDefenderType.add(_defenderTypesArray.length.toUint8());
308                         }
309 
310                         if (_currentDefenderType.add(_attackerType).add(1) % 2 == 0) {
311                             _dragonTypeMultiply = _attackerTypesArray[_attackerType];
312                             _dragonTypeMultiply = _dragonTypeMultiply.mul(_defenderTypesArray[_defenderType]);
313                             dragonTypeSumMultiply = dragonTypeSumMultiply.add(_dragonTypeMultiply);
314                         }
315                     }
316                 }
317             }
318         }
319 
320         return _multiplyByFloatNumber(dragonTypeSumMultiply, DRAGON_TYPE_FACTOR).add(DRAGON_TYPE_MULTIPLY);
321     }
322 
323     function _initBaseDragon(
324         uint256 _id,
325         uint256 _opponentId,
326         uint8 _meleeChance,
327         uint8 _attackChance,
328         bool _isGladiator
329     ) internal view returns (Dragon) {
330         uint32 _health;
331         uint32 _mana;
332         if (_isGladiator) {
333             (_health, _mana) = getter.getDragonMaxHealthAndMana(_id);
334         } else {
335             (_health, _mana, , ) = getter.getDragonCurrentHealthAndMana(_id);
336         }
337 
338         if (_meleeChance == 0 || _attackChance == 0) {
339             (_meleeChance, _attackChance) = getter.getDragonTactics(_id);
340         }
341         uint8[11] memory _attackerTypes = getter.getDragonTypes(_id);
342         uint8[11] memory _opponentTypes = getter.getDragonTypes(_opponentId);
343         uint32 _attack;
344         uint32 _defense;
345         uint32 _speed;
346         (_attack, _defense, , _speed, ) = getter.getDragonSkills(_id);
347 
348         return Dragon({
349             id: _id,
350             attackChance: _attackChance,
351             meleeChance: _meleeChance,
352             health: _health,
353             mana: _mana,
354             speed: _speed,
355             attack: _attack.mul(_calculateDragonTypeMultiply(_attackerTypes, _opponentTypes)).div(DRAGON_TYPE_MULTIPLY),
356             defense: _defense,
357             specialAttackCost: 0,
358             specialAttackFactor: 0,
359             specialAttackChance: 0,
360             specialDefenseCost: 0,
361             specialDefenseFactor: 0,
362             specialDefenseChance: 0,
363             blocking: false,
364             specialBlocking: false
365         });
366     }
367 
368     function _initDragon(
369         uint256 _id,
370         uint256 _opponentId,
371         uint8[2] _tactics,
372         bool _isGladiator
373     ) internal view returns (Dragon dragon) {
374         dragon = _initBaseDragon(_id, _opponentId, _tactics[0], _tactics[1], _isGladiator);
375 
376         uint32 _specialAttackCost;
377         uint8 _specialAttackFactor;
378         uint8 _specialAttackChance;
379         uint32 _specialDefenseCost;
380         uint8 _specialDefenseFactor;
381         uint8 _specialDefenseChance;
382 
383         ( , _specialAttackCost, _specialAttackFactor, _specialAttackChance) = getter.getDragonSpecialAttack(_id);
384         ( , _specialDefenseCost, _specialDefenseFactor, _specialDefenseChance) = getter.getDragonSpecialDefense(_id);
385 
386         dragon.specialAttackCost = _specialAttackCost;
387         dragon.specialAttackFactor = _specialAttackFactor;
388         dragon.specialAttackChance = _specialAttackChance;
389         dragon.specialDefenseCost = _specialDefenseCost;
390         dragon.specialDefenseFactor = _specialDefenseFactor;
391         dragon.specialDefenseChance = _specialDefenseChance;
392 
393         uint32[5] memory _buffs = getter.getDragonBuffs(_id);
394 
395         if (_buffs[0] > 0) {
396             dragon.attack = dragon.attack.mul(_buffs[0]).div(100);
397         }
398         if (_buffs[1] > 0) {
399             dragon.defense = dragon.defense.mul(_buffs[1]).div(100);
400         }
401         if (_buffs[3] > 0) {
402             dragon.speed = dragon.speed.mul(_buffs[3]).div(100);
403         }
404     }
405 
406     function _resetBlocking(Dragon dragon) internal pure returns (Dragon) {
407         dragon.blocking = false;
408         dragon.specialBlocking = false;
409 
410         return dragon;
411     }
412 
413     function _attack(
414         uint8 turnId,
415         bool isMelee,
416         Dragon attacker,
417         Dragon opponent,
418         uint8 _random
419     ) internal pure returns (
420         Dragon,
421         Dragon
422     ) {
423 
424         uint8 _turnModificator = 10; // multiplied by 10
425         if (turnId > 30) {
426             uint256 _modif = uint256(turnId).sub(30);
427             _modif = _modif.mul(50);
428             _modif = _modif.div(40);
429             _modif = _modif.add(10);
430             _turnModificator = _modif.toUint8();
431         }
432 
433         bool isSpecial = _random < _multiplyByFloatNumber(attacker.specialAttackChance, _turnModificator);
434 
435         uint32 damage = _multiplyByFloatNumber(attacker.attack, _turnModificator);
436 
437         if (isSpecial && attacker.mana >= attacker.specialAttackCost) {
438             attacker.mana = attacker.mana.sub(attacker.specialAttackCost);
439             damage = _multiplyByFloatNumber(damage, attacker.specialAttackFactor);
440         }
441 
442         if (!isMelee) {
443             damage = _multiplyByFloatNumber(damage, DISTANCE_ATTACK_WEAK__);
444         }
445 
446         uint32 defense = opponent.defense;
447 
448         if (opponent.blocking) {
449             defense = _multiplyByFloatNumber(defense, DEFENSE_SUCCESS_MULTIPLY__);
450 
451             if (opponent.specialBlocking) {
452                 defense = _multiplyByFloatNumber(defense, opponent.specialDefenseFactor);
453             }
454         } else {
455             defense = _multiplyByFloatNumber(defense, DEFENSE_FAIL_MULTIPLY__);
456         }
457 
458         if (damage > defense) {
459             opponent.health = _safeSub(opponent.health, damage.sub(defense));
460         } else if (isMelee) {
461             attacker.health = _safeSub(attacker.health, defense.sub(damage));
462         }
463 
464         return (attacker, opponent);
465     }
466 
467     function _defense(
468         Dragon attacker,
469         uint256 initialSeed,
470         uint256 currentSeed
471     ) internal pure returns (
472         Dragon,
473         uint256
474     ) {
475         uint8 specialRandom;
476 
477         (specialRandom, currentSeed) = _getRandomNumber(initialSeed, currentSeed);
478         bool isSpecial = specialRandom < attacker.specialDefenseChance;
479 
480         if (isSpecial && attacker.mana >= attacker.specialDefenseCost) {
481             attacker.mana = attacker.mana.sub(attacker.specialDefenseCost);
482             attacker.specialBlocking = true;
483         }
484         attacker.blocking = true;
485 
486         return (attacker, currentSeed);
487     }
488 
489     function _turn(
490         uint8 turnId,
491         uint256 initialSeed,
492         uint256 currentSeed,
493         uint32 distance,
494         Dragon currentDragon,
495         Dragon currentEnemy
496     ) internal view returns (
497         Dragon winner,
498         Dragon looser
499     ) {
500         uint8 rand;
501 
502         (rand, currentSeed) = _getRandomNumber(initialSeed, currentSeed);
503         bool isAttack = rand < currentDragon.attackChance;
504 
505         if (isAttack) {
506             (rand, currentSeed) = _getRandomNumber(initialSeed, currentSeed);
507             bool isMelee = rand < currentDragon.meleeChance;
508 
509             if (isMelee && distance > MAX_MELEE_ATTACK_DISTANCE) {
510                 distance = _safeSub(distance, currentDragon.speed);
511             } else if (!isMelee && distance < MIN_RANGE_ATTACK_DISTANCE) {
512                 distance = distance.add(_multiplyByFloatNumber(currentDragon.speed, FALLBACK_SPEED_FACTOR__));
513             } else {
514                 (rand, currentSeed) = _getRandomNumber(initialSeed, currentSeed);
515                 (currentDragon, currentEnemy) = _attack(turnId, isMelee, currentDragon, currentEnemy, rand);
516             }
517         } else {
518             (currentDragon, currentSeed) = _defense(currentDragon, initialSeed, currentSeed);
519         }
520 
521         currentEnemy = _resetBlocking(currentEnemy);
522 
523         if (currentDragon.health == 0) {
524             return (currentEnemy, currentDragon);
525         } else if (currentEnemy.health == 0) {
526             return (currentDragon, currentEnemy);
527         } else if (turnId < MAX_TURNS) {
528             return _turn(turnId.add(1), initialSeed, currentSeed, distance, currentEnemy, currentDragon);
529         } else {
530             uint32 _dragonMaxHealth;
531             uint32 _enemyMaxHealth;
532             (_dragonMaxHealth, ) = getter.getDragonMaxHealthAndMana(currentDragon.id);
533             (_enemyMaxHealth, ) = getter.getDragonMaxHealthAndMana(currentEnemy.id);
534             if (_calculatePercentage(currentDragon.health, _dragonMaxHealth) >= _calculatePercentage(currentEnemy.health, _enemyMaxHealth)) {
535                 return (currentDragon, currentEnemy);
536             } else {
537                 return (currentEnemy, currentDragon);
538             }
539         }
540     }
541 
542     function _start(
543         uint256 _firstDragonId,
544         uint256 _secondDragonId,
545         uint8[2] _firstTactics,
546         uint8[2] _secondTactics,
547         uint256 _seed,
548         bool _isGladiator
549     ) internal view returns (
550         uint256[2],
551         uint32,
552         uint32,
553         uint32,
554         uint32
555     ) {
556         Dragon memory _firstDragon = _initDragon(_firstDragonId, _secondDragonId, _firstTactics, _isGladiator);
557         Dragon memory _secondDragon = _initDragon(_secondDragonId, _firstDragonId, _secondTactics, _isGladiator);
558 
559         if (_firstDragon.speed >= _secondDragon.speed) {
560             (_firstDragon, _secondDragon) = _turn(1, _seed, _seed, MAX_MELEE_ATTACK_DISTANCE, _firstDragon, _secondDragon);
561         } else {
562             (_firstDragon, _secondDragon) = _turn(1, _seed, _seed, MAX_MELEE_ATTACK_DISTANCE, _secondDragon, _firstDragon);
563         }
564 
565         return (
566             [_firstDragon.id,  _secondDragon.id],
567             _firstDragon.health,
568             _firstDragon.mana,
569             _secondDragon.health,
570             _secondDragon.mana
571         );
572     }
573 
574     function start(
575         uint256 _firstDragonId,
576         uint256 _secondDragonId,
577         uint8[2] _tactics,
578         uint8[2] _tactics2,
579         uint256 _seed,
580         bool _isGladiator
581     ) external onlyController returns (
582         uint256[2] winnerLooserIds,
583         uint32 winnerHealth,
584         uint32 winnerMana,
585         uint32 looserHealth,
586         uint32 looserMana,
587         uint256 battleId
588     ) {
589 
590         (
591             winnerLooserIds,
592             winnerHealth,
593             winnerMana,
594             looserHealth,
595             looserMana
596         ) = _start(
597             _firstDragonId,
598             _secondDragonId,
599             _tactics,
600             _tactics2,
601             _seed,
602             _isGladiator
603         );
604 
605         battleId = battlesCounter;
606         battlesCounter = battlesCounter.add(1);
607     }
608 
609     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
610         super.setInternalDependencies(_newDependencies);
611 
612         getter = Getter(_newDependencies[0]);
613     }
614 }