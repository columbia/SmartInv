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
147 library SafeConvert {
148 
149     function toUint8(uint256 _value) internal pure returns (uint8) {
150         assert(_value <= 255);
151         return uint8(_value);
152     }
153 
154     function toUint16(uint256 _value) internal pure returns (uint16) {
155         assert(_value <= 2**16 - 1);
156         return uint16(_value);
157     }
158 
159     function toUint32(uint256 _value) internal pure returns (uint32) {
160         assert(_value <= 2**32 - 1);
161         return uint32(_value);
162     }
163 }
164 
165 contract Ownable {
166     address public owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     function _validateAddress(address _addr) internal pure {
171         require(_addr != address(0), "invalid address");
172     }
173 
174     constructor() public {
175         owner = msg.sender;
176     }
177 
178     modifier onlyOwner() {
179         require(msg.sender == owner, "not a contract owner");
180         _;
181     }
182 
183     function transferOwnership(address newOwner) public onlyOwner {
184         _validateAddress(newOwner);
185         emit OwnershipTransferred(owner, newOwner);
186         owner = newOwner;
187     }
188 
189 }
190 
191 contract Controllable is Ownable {
192     mapping(address => bool) controllers;
193 
194     modifier onlyController {
195         require(_isController(msg.sender), "no controller rights");
196         _;
197     }
198 
199     function _isController(address _controller) internal view returns (bool) {
200         return controllers[_controller];
201     }
202 
203     function _setControllers(address[] _controllers) internal {
204         for (uint256 i = 0; i < _controllers.length; i++) {
205             _validateAddress(_controllers[i]);
206             controllers[_controllers[i]] = true;
207         }
208     }
209 }
210 
211 contract Upgradable is Controllable {
212     address[] internalDependencies;
213     address[] externalDependencies;
214 
215     function getInternalDependencies() public view returns(address[]) {
216         return internalDependencies;
217     }
218 
219     function getExternalDependencies() public view returns(address[]) {
220         return externalDependencies;
221     }
222 
223     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
224         for (uint256 i = 0; i < _newDependencies.length; i++) {
225             _validateAddress(_newDependencies[i]);
226         }
227         internalDependencies = _newDependencies;
228     }
229 
230     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
231         externalDependencies = _newDependencies;
232         _setControllers(_newDependencies);
233     }
234 }
235 
236 contract DragonParams {
237     function dragonTypesFactors(uint8) external view returns (uint8[5]) {}
238     function bodyPartsFactors(uint8) external view returns (uint8[5]) {}
239     function geneTypesFactors(uint8) external view returns (uint8[5]) {}
240     function experienceToNextLevel(uint8) external view returns (uint8) {}
241     function dnaPoints(uint8) external view returns (uint16) {}
242     function geneUpgradeDNAPoints(uint8) external view returns (uint8) {}
243     function battlePoints() external view returns (uint8) {}
244 }
245 
246 contract Name {
247     using SafeMath256 for uint256;
248 
249     uint8 constant MIN_NAME_LENGTH = 2;
250     uint8 constant MAX_NAME_LENGTH = 32;
251 
252     function _convertName(string _input) internal pure returns(bytes32 _initial, bytes32 _lowercase) {
253         bytes memory _initialBytes = bytes(_input);
254         assembly {
255             _initial := mload(add(_initialBytes, 32))
256         }
257         _lowercase = _toLowercase(_input);
258     }
259 
260 
261     function _toLowercase(string _input) internal pure returns(bytes32 result) {
262         bytes memory _temp = bytes(_input);
263         uint256 _length = _temp.length;
264 
265         //sorry limited to 32 characters
266         require (_length <= 32 && _length >= 2, "string must be between 2 and 32 characters");
267         // make sure it doesnt start with or end with space
268         require(_temp[0] != 0x20 && _temp[_length.sub(1)] != 0x20, "string cannot start or end with space");
269         // make sure first two characters are not 0x
270         if (_temp[0] == 0x30)
271         {
272             require(_temp[1] != 0x78, "string cannot start with 0x");
273             require(_temp[1] != 0x58, "string cannot start with 0X");
274         }
275 
276         // create a bool to track if we have a non number character
277         bool _hasNonNumber;
278 
279         // convert & check
280         for (uint256 i = 0; i < _length; i = i.add(1))
281         {
282             // if its uppercase A-Z
283             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
284             {
285                 // convert to lower case a-z
286                 _temp[i] = byte(uint256(_temp[i]).add(32));
287 
288                 // we have a non number
289                 if (_hasNonNumber == false)
290                     _hasNonNumber = true;
291             } else {
292                 require
293                 (
294                     // require character is a space
295                     _temp[i] == 0x20 ||
296                     // OR lowercase a-z
297                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
298                     // or 0-9
299                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
300                     "string contains invalid characters"
301                 );
302                 // make sure theres not 2x spaces in a row
303                 if (_temp[i] == 0x20)
304                     require(_temp[i.add(1)] != 0x20, "string cannot contain consecutive spaces");
305 
306                 // see if we have a character other than a number
307                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
308                     _hasNonNumber = true;
309             }
310         }
311 
312         require(_hasNonNumber == true, "string cannot be only numbers");
313 
314         assembly {
315             result := mload(add(_temp, 32))
316         }
317     }
318 }
319 
320 contract DragonUtils {
321     using SafeMath8 for uint8;
322     using SafeMath256 for uint256;
323 
324     using SafeConvert for uint256;
325 
326 
327     function _getActiveGene(uint8[16] _gene) internal pure returns (uint8[3] gene) {
328         uint8 _index = _getActiveGeneIndex(_gene); // find active gene
329         for (uint8 i = 0; i < 3; i++) {
330             gene[i] = _gene[i + (_index * 4)]; // get all data for this gene
331         }
332     }
333 
334     function _getActiveGeneIndex(uint8[16] _gene) internal pure returns (uint8) {
335         return _gene[3] >= _gene[7] ? 0 : 1;
336     }
337 
338     // returns 10 active genes (one for each part of the body) with the next structure:
339     // each gene is an array of 3 elements:
340     // 0 - type of dragon
341     // 1 - gene type
342     // 2 - gene level
343     function _getActiveGenes(uint8[16][10] _genome) internal pure returns (uint8[30] genome) {
344         uint8[3] memory _activeGene;
345         for (uint8 i = 0; i < 10; i++) {
346             _activeGene = _getActiveGene(_genome[i]);
347             genome[i * 3] = _activeGene[0];
348             genome[i * 3 + 1] = _activeGene[1];
349             genome[i * 3 + 2] = _activeGene[2];
350         }
351     }
352 
353     function _getIndexAndFactor(uint8 _counter) internal pure returns (uint8 index, uint8 factor) {
354         if (_counter < 44) index = 0;
355         else if (_counter < 88) index = 1;
356         else if (_counter < 132) index = 2;
357         else index = 3;
358         factor = _counter.add(1) % 4 == 0 ? 10 : 100;
359     }
360 
361     function _parseGenome(uint256[4] _composed) internal pure returns (uint8[16][10] parsed) {
362         uint8 counter = 160; // 40 genes with 4 values in each one
363         uint8 _factor;
364         uint8 _index;
365 
366         for (uint8 i = 0; i < 10; i++) {
367             for (uint8 j = 0; j < 16; j++) {
368                 counter = counter.sub(1);
369                 // _index - index of value in genome array where current gene is stored
370                 // _factor - denominator that determines the number of digits
371                 (_index, _factor) = _getIndexAndFactor(counter);
372                 parsed[9 - i][15 - j] = (_composed[_index] % _factor).toUint8();
373                 _composed[_index] /= _factor;
374             }
375         }
376     }
377 
378     function _composeGenome(uint8[16][10] _parsed) internal pure returns (uint256[4] composed) {
379         uint8 counter = 0;
380         uint8 _index;
381         uint8 _factor;
382 
383         for (uint8 i = 0; i < 10; i++) {
384             for (uint8 j = 0; j < 16; j++) {
385                 (_index, _factor) = _getIndexAndFactor(counter);
386                 composed[_index] = composed[_index].mul(_factor);
387                 composed[_index] = composed[_index].add(_parsed[i][j]);
388                 counter = counter.add(1);
389             }
390         }
391     }
392 }
393 
394 contract DragonCoreHelper is Upgradable, DragonUtils, Name {
395     using SafeMath16 for uint16;
396     using SafeMath32 for uint32;
397     using SafeMath256 for uint256;
398     using SafeConvert for uint32;
399     using SafeConvert for uint256;
400 
401     DragonParams params;
402 
403     uint8 constant PERCENT_MULTIPLIER = 100;
404     uint8 constant MAX_PERCENTAGE = 100;
405 
406     uint8 constant MAX_GENE_LVL = 99;
407 
408     uint8 constant MAX_LEVEL = 10;
409 
410     function _min(uint32 lth, uint32 rth) internal pure returns (uint32) {
411         return lth > rth ? rth : lth;
412     }
413 
414     function _calculateSkillWithBuff(uint32 _skill, uint32 _buff) internal pure returns (uint32) {
415         return _buff > 0 ? _skill.mul(_buff).div(100) : _skill; // buff is multiplied by 100
416     }
417 
418     function _calculateRegenerationSpeed(uint32 _max) internal pure returns (uint32) {
419         // because HP/mana is multiplied by 100 so we need to have step multiplied by 100 too
420         return _sqrt(_max.mul(100)).div(2).div(1 minutes); // hp/mana in second
421     }
422 
423     function calculateFullRegenerationTime(uint32 _max) external pure returns (uint32) { // in seconds
424         return _max.div(_calculateRegenerationSpeed(_max));
425     }
426 
427     function calculateCurrent(
428         uint256 _pastTime,
429         uint32 _max,
430         uint32 _remaining
431     ) external pure returns (
432         uint32 current,
433         uint8 percentage
434     ) {
435         if (_remaining >= _max) {
436             return (_max, MAX_PERCENTAGE);
437         }
438         uint32 _speed = _calculateRegenerationSpeed(_max); // points per second
439         uint32 _secondsToFull = _max.sub(_remaining).div(_speed); // seconds to full
440         uint32 _secondsPassed = _pastTime.toUint32(); // seconds that already passed
441         if (_secondsPassed >= _secondsToFull.add(1)) {
442             return (_max, MAX_PERCENTAGE); // return full if passed more or equal to needed
443         }
444         current = _min(_max, _remaining.add(_speed.mul(_secondsPassed)));
445         percentage = _min(MAX_PERCENTAGE, current.mul(PERCENT_MULTIPLIER).div(_max)).toUint8();
446     }
447 
448     function calculateHealthAndMana(
449         uint32 _initStamina,
450         uint32 _initIntelligence,
451         uint32 _staminaBuff,
452         uint32 _intelligenceBuff
453     ) external pure returns (uint32 health, uint32 mana) {
454         uint32 _stamina = _initStamina;
455         uint32 _intelligence = _initIntelligence;
456 
457         _stamina = _calculateSkillWithBuff(_stamina, _staminaBuff);
458         _intelligence = _calculateSkillWithBuff(_intelligence, _intelligenceBuff);
459 
460         health = _stamina.mul(5);
461         mana = _intelligence.mul(5);
462     }
463 
464     function _sqrt(uint32 x) internal pure returns (uint32 y) {
465         uint32 z = x.add(1).div(2);
466         y = x;
467         while (z < y) {
468             y = z;
469             z = x.div(z).add(z).div(2);
470         }
471     }
472 
473     // _dragonTypes[i] in [0..39] range, sum of all _dragonTypes items = 40 (number of genes)
474     // _random in [0..39] range
475     function getSpecialBattleSkillDragonType(uint8[11] _dragonTypes, uint256 _random) external pure returns (uint8 skillDragonType) {
476         uint256 _currentChance;
477         for (uint8 i = 0; i < 11; i++) {
478             _currentChance = _currentChance.add(_dragonTypes[i]);
479             if (_random < _currentChance) {
480                 skillDragonType = i;
481                 break;
482             }
483         }
484     }
485 
486     function _getBaseSkillIndex(uint8 _dragonType) internal pure returns (uint8) {
487         // 2 - stamina
488         // 0 - attack
489         // 3 - speed
490         // 1 - defense
491         // 4 - intelligence
492         uint8[5] memory _skills = [2, 0, 3, 1, 4];
493         return _skills[_dragonType];
494     }
495 
496     function calculateSpecialBattleSkill(
497         uint8 _dragonType,
498         uint32[5] _skills
499     ) external pure returns (
500         uint32 cost,
501         uint8 factor,
502         uint8 chance
503     ) {
504         uint32 _baseSkill = _skills[_getBaseSkillIndex(_dragonType)];
505         uint32 _intelligence = _skills[4];
506 
507         cost = _baseSkill.mul(3);
508         factor = _sqrt(_baseSkill.div(3)).add(10).toUint8(); // factor is increased by 10
509         // skill is multiplied by 100 so we divide the result by sqrt(100) = 10
510         chance = _sqrt(_intelligence).div(10).add(10).toUint8();
511     }
512 
513     function _getSkillIndexBySpecialPeacefulSkillClass(
514         uint8 _class
515     ) internal pure returns (uint8) {
516         // 0 - attack
517         // 1 - defense
518         // 2 - stamina
519         // 3 - speed
520         // 4 - intelligence
521         uint8[8] memory _buffsIndexes = [0, 0, 1, 2, 3, 4, 2, 4]; // 0 item - no such class
522         return _buffsIndexes[_class];
523     }
524 
525     function calculateSpecialPeacefulSkill(
526         uint8 _class,
527         uint32[5] _skills,
528         uint32[5] _buffs
529     ) external pure returns (uint32 cost, uint32 effect) {
530         uint32 _index = _getSkillIndexBySpecialPeacefulSkillClass(_class);
531         uint32 _skill = _calculateSkillWithBuff(_skills[_index], _buffs[_index]);
532         if (_class == 6 || _class == 7) { // healing or mana recharge
533             effect = _skill.mul(2);
534         } else {
535             // sqrt(skill / 30) + 1
536             effect = _sqrt(_skill.mul(10).div(3)).add(100); // effect is increased by 100 as skills
537         }
538         cost = _skill.mul(3);
539     }
540 
541     function _getGeneVarietyFactor(uint8 _type) internal pure returns (uint32 value) {
542         // multiplied by 10
543         if (_type == 0) value = 5;
544         else if (_type < 5) value = 12;
545         else if (_type < 8) value = 16;
546         else value = 28;
547     }
548 
549     function calculateCoolness(uint256[4] _composedGenome) external pure returns (uint32 coolness) {
550         uint8[16][10] memory _genome = _parseGenome(_composedGenome);
551         uint32 _geneVarietyFactor; // multiplied by 10
552         uint8 _strengthCoefficient; // multiplied by 10
553         uint8 _geneLevel;
554         for (uint8 i = 0; i < 10; i++) {
555             for (uint8 j = 0; j < 4; j++) {
556                 _geneVarietyFactor = _getGeneVarietyFactor(_genome[i][(j * 4) + 1]);
557                 _strengthCoefficient = (_genome[i][(j * 4) + 3] == 0) ? 7 : 10; // recessive or dominant
558                 _geneLevel = _genome[i][(j * 4) + 2];
559                 coolness = coolness.add(_geneVarietyFactor.mul(_geneLevel).mul(_strengthCoefficient));
560             }
561         }
562     }
563 
564     function calculateSkills(
565         uint256[4] _composed
566     ) external view returns (
567         uint32, uint32, uint32, uint32, uint32
568     ) {
569         uint8[30] memory _activeGenes = _getActiveGenes(_parseGenome(_composed));
570         uint8[5] memory _dragonTypeFactors;
571         uint8[5] memory _bodyPartFactors;
572         uint8[5] memory _geneTypeFactors;
573         uint8 _level;
574         uint32[5] memory _skills;
575 
576         for (uint8 i = 0; i < 10; i++) {
577             _bodyPartFactors = params.bodyPartsFactors(i);
578             _dragonTypeFactors = params.dragonTypesFactors(_activeGenes[i * 3]);
579             _geneTypeFactors = params.geneTypesFactors(_activeGenes[i * 3 + 1]);
580             _level = _activeGenes[i * 3 + 2];
581 
582             for (uint8 j = 0; j < 5; j++) {
583                 _skills[j] = _skills[j].add(uint32(_dragonTypeFactors[j]).mul(_bodyPartFactors[j]).mul(_geneTypeFactors[j]).mul(_level));
584             }
585         }
586         return (_skills[0], _skills[1], _skills[2], _skills[3], _skills[4]);
587     }
588 
589     function calculateExperience(
590         uint8 _level,
591         uint256 _experience,
592         uint16 _dnaPoints,
593         uint256 _factor
594     ) external view returns (
595         uint8 level,
596         uint256 experience,
597         uint16 dnaPoints
598     ) {
599         level = _level;
600         experience = _experience;
601         dnaPoints = _dnaPoints;
602 
603         uint8 _expToNextLvl;
604         // _factor is multiplied by 10
605         experience = experience.add(uint256(params.battlePoints()).mul(_factor).div(10));
606         _expToNextLvl = params.experienceToNextLevel(level);
607         while (experience >= _expToNextLvl && level < MAX_LEVEL) {
608             experience = experience.sub(_expToNextLvl);
609             level = level.add(1);
610             dnaPoints = dnaPoints.add(params.dnaPoints(level));
611             if (level < MAX_LEVEL) {
612                 _expToNextLvl = params.experienceToNextLevel(level);
613             }
614         }
615     }
616 
617     function checkAndConvertName(string _input) external pure returns(bytes32, bytes32) {
618         return _convertName(_input);
619     }
620 
621     function _checkIfEnoughDNAPoints(bool _isEnough) internal pure {
622         require(_isEnough, "not enough DNA points for upgrade");
623     }
624 
625     function upgradeGenes(
626         uint256[4] _composedGenome,
627         uint16[10] _dnaPoints,
628         uint16 _availableDNAPoints
629     ) external view returns (
630         uint256[4],
631         uint16
632     ) {
633         uint16 _sum;
634         uint8 _i;
635         for (_i = 0; _i < 10; _i++) {
636             _checkIfEnoughDNAPoints(_dnaPoints[_i] <= _availableDNAPoints);
637             _sum = _sum.add(_dnaPoints[_i]);
638         }
639         _checkIfEnoughDNAPoints(_sum <= _availableDNAPoints);
640         _sum = 0;
641 
642         uint8[16][10] memory _genome = _parseGenome(_composedGenome);
643         uint8 _geneLevelIndex;
644         uint8 _geneLevel;
645         uint16 _geneUpgradeDNAPoints;
646         uint8 _levelsToUpgrade;
647         uint16 _specificDNAPoints;
648         for (_i = 0; _i < 10; _i++) { // 10 active genes
649             _specificDNAPoints = _dnaPoints[_i]; // points to upgrade current gene
650             if (_specificDNAPoints > 0) {
651                 _geneLevelIndex = _getActiveGeneIndex(_genome[_i]).mul(4).add(2); // index of main gene level in genome
652                 _geneLevel = _genome[_i][_geneLevelIndex]; // current level of gene
653                 if (_geneLevel < MAX_GENE_LVL) {
654                     // amount of points to upgrade to next level
655                     _geneUpgradeDNAPoints = params.geneUpgradeDNAPoints(_geneLevel);
656                     // while enough points and gene level is lower than max gene level
657                     while (_specificDNAPoints >= _geneUpgradeDNAPoints && _geneLevel.add(_levelsToUpgrade) < MAX_GENE_LVL) {
658                         _levelsToUpgrade = _levelsToUpgrade.add(1);
659                         _specificDNAPoints = _specificDNAPoints.sub(_geneUpgradeDNAPoints);
660                         _sum = _sum.add(_geneUpgradeDNAPoints); // the sum of used points
661                         if (_geneLevel.add(_levelsToUpgrade) < MAX_GENE_LVL) {
662                             _geneUpgradeDNAPoints = params.geneUpgradeDNAPoints(_geneLevel.add(_levelsToUpgrade));
663                         }
664                     }
665                     _genome[_i][_geneLevelIndex] = _geneLevel.add(_levelsToUpgrade); // add levels to current gene
666                     _levelsToUpgrade = 0;
667                 }
668             }
669         }
670         return (_composeGenome(_genome), _sum);
671     }
672 
673     function getActiveGenes(uint256[4] _composed) external pure returns (uint8[30]) {
674         uint8[16][10] memory _genome = _parseGenome(_composed);
675         return _getActiveGenes(_genome);
676     }
677 
678     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
679         super.setInternalDependencies(_newDependencies);
680 
681         params = DragonParams(_newDependencies[0]);
682     }
683 }