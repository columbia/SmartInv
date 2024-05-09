1 pragma solidity ^0.4.16;
2 
3 // copyright contact@Etheremon.com
4 
5 contract SafeMath {
6 
7     /* function assert(bool assertion) internal { */
8     /*   if (!assertion) { */
9     /*     throw; */
10     /*   } */
11     /* }      // assert no longer needed once solidity is on 0.4.10 */
12 
13     function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
14       uint256 z = x + y;
15       assert((z >= x) && (z >= y));
16       return z;
17     }
18 
19     function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
20       assert(x >= y);
21       uint256 z = x - y;
22       return z;
23     }
24 
25     function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
26       uint256 z = x * y;
27       assert((x == 0)||(z/x == y));
28       return z;
29     }
30 
31 }
32 
33 contract BasicAccessControl {
34     address public owner;
35     // address[] public moderators;
36     uint16 public totalModerators = 0;
37     mapping (address => bool) public moderators;
38     bool public isMaintaining = true;
39 
40     function BasicAccessControl() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     modifier onlyModerators() {
50         require(msg.sender == owner || moderators[msg.sender] == true);
51         _;
52     }
53 
54     modifier isActive {
55         require(!isMaintaining);
56         _;
57     }
58 
59     function ChangeOwner(address _newOwner) onlyOwner public {
60         if (_newOwner != address(0)) {
61             owner = _newOwner;
62         }
63     }
64 
65 
66     function AddModerator(address _newModerator) onlyOwner public {
67         if (moderators[_newModerator] == false) {
68             moderators[_newModerator] = true;
69             totalModerators += 1;
70         }
71     }
72     
73     function RemoveModerator(address _oldModerator) onlyOwner public {
74         if (moderators[_oldModerator] == true) {
75             moderators[_oldModerator] = false;
76             totalModerators -= 1;
77         }
78     }
79 
80     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
81         isMaintaining = _isMaintaining;
82     }
83 }
84 
85 contract EtheremonEnum {
86 
87     enum ResultCode {
88         SUCCESS,
89         ERROR_CLASS_NOT_FOUND,
90         ERROR_LOW_BALANCE,
91         ERROR_SEND_FAIL,
92         ERROR_NOT_TRAINER,
93         ERROR_NOT_ENOUGH_MONEY,
94         ERROR_INVALID_AMOUNT,
95         ERROR_OBJ_NOT_FOUND,
96         ERROR_OBJ_INVALID_OWNERSHIP
97     }
98     
99     enum ArrayType {
100         CLASS_TYPE,
101         STAT_STEP,
102         STAT_START,
103         STAT_BASE,
104         OBJ_SKILL
105     }
106 
107     enum PropertyType {
108         ANCESTOR,
109         XFACTOR
110     }
111     
112     enum BattleResult {
113         CASTLE_WIN,
114         CASTLE_LOSE,
115         CASTLE_DESTROYED
116     }
117     
118     enum CacheClassInfoType {
119         CLASS_TYPE,
120         CLASS_STEP,
121         CLASS_ANCESTOR
122     }
123 }
124 
125 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
126     
127     uint64 public totalMonster;
128     uint32 public totalClass;
129     
130     // read
131     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
132     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
133     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
134     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
135     function getMonsterName(uint64 _objId) constant public returns(string name);
136     function getExtraBalance(address _trainer) constant public returns(uint256);
137     function getMonsterDexSize(address _trainer) constant public returns(uint);
138     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
139     function getExpectedBalance(address _trainer) constant public returns(uint256);
140     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
141 }
142 
143 contract EtheremonGateway is EtheremonEnum, BasicAccessControl {
144     // using for battle contract later
145     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
146     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
147     
148     // read 
149     function isGason(uint64 _objId) constant external returns(bool);
150     function getObjBattleInfo(uint64 _objId) constant external returns(uint32 classId, uint32 exp, bool isGason, 
151         uint ancestorLength, uint xfactorsLength);
152     function getClassPropertySize(uint32 _classId, PropertyType _type) constant external returns(uint);
153     function getClassPropertyValue(uint32 _classId, PropertyType _type, uint index) constant external returns(uint32);
154 }
155 
156 contract EtheremonGym is EtheremonEnum, BasicAccessControl, SafeMath {
157     uint8 constant public STAT_COUNT = 6;
158     
159     struct MonsterObjAcc {
160         uint64 monsterId;
161         uint32 classId;
162         address trainer;
163         string name;
164         uint32 exp;
165         uint32 createIndex;
166         uint32 lastClaimIndex;
167         uint createTime;
168     }
169     
170     struct AttackData {
171         uint32 objClassId;
172         address trainee;
173         uint8 objLevel;
174         uint8 winCount;
175         uint32 winExp;
176         uint32 loseExp;
177     }
178     
179     struct HpData {
180         uint16 aHpAttack;
181         uint16 aHpAttackCritical;
182         uint16 bHpAttack;
183         uint16 bHpAttackCritical;        
184     }
185     
186     struct GymTrainer {
187         uint32 classId;
188         uint8[6] statBases;
189     }
190     
191     struct TrainingLog {
192         uint8[3] trainers;
193         uint8 trainerLevel;
194         uint64 objId;
195         uint8 objLevel;
196         uint8 ran;
197     }
198     
199     struct CacheClassInfo {
200         uint8[] types;
201         uint8[] steps;
202         uint32[] ancestors;
203     }
204     
205     mapping(uint8 => GymTrainer) public gymTrainers;
206     mapping(address => TrainingLog) public trainees;
207     mapping(uint8 => uint8) typeAdvantages;
208     mapping(uint32 => CacheClassInfo) cacheClasses;
209     mapping(uint8 => uint32) levelExps;
210     mapping(uint8 => uint32) levelExpGains;
211     uint256 public gymFee = 0.001 ether;
212     uint8 public maxTrainerLevel = 5;
213     uint8 public totalTrainer = 0;
214     uint8 public maxRandomRound = 4;
215     uint8 public typeBuffPercentage = 20;
216     uint8 public minHpDeducted = 10;
217     uint8 public expPercentage = 70;
218     
219     // contract
220     address public worldContract;
221     address public dataContract;
222 
223    // modifier
224     modifier requireDataContract {
225         require(dataContract != address(0));
226         _;
227     }
228     
229     modifier requireWorldContract {
230         require(worldContract != address(0));
231         _;
232     }
233     
234     // constructor
235     function EtheremonGym(address _dataContract, address _worldContract) public {
236         dataContract = _dataContract;
237         worldContract = _worldContract;
238     }
239     
240     
241      // admin & moderators
242     function setTypeAdvantages() onlyModerators external {
243         typeAdvantages[1] = 14;
244         typeAdvantages[2] = 16;
245         typeAdvantages[3] = 8;
246         typeAdvantages[4] = 9;
247         typeAdvantages[5] = 2;
248         typeAdvantages[6] = 11;
249         typeAdvantages[7] = 3;
250         typeAdvantages[8] = 5;
251         typeAdvantages[9] = 15;
252         typeAdvantages[11] = 18;
253         // skipp 10
254         typeAdvantages[12] = 7;
255         typeAdvantages[13] = 6;
256         typeAdvantages[14] = 17;
257         typeAdvantages[15] = 13;
258         typeAdvantages[16] = 12;
259         typeAdvantages[17] = 1;
260         typeAdvantages[18] = 4;
261     }
262     
263     function setTypeAdvantage(uint8 _type1, uint8 _type2) onlyModerators external {
264         typeAdvantages[_type1] = _type2;
265     }
266     
267     function setCacheClassInfo(uint32 _classId) onlyModerators requireDataContract requireWorldContract public {
268         EtheremonDataBase data = EtheremonDataBase(dataContract);
269          EtheremonGateway gateway = EtheremonGateway(worldContract);
270         uint i = 0;
271         CacheClassInfo storage classInfo = cacheClasses[_classId];
272 
273         // add type
274         i = data.getSizeArrayType(ArrayType.CLASS_TYPE, uint64(_classId));
275         uint8[] memory aTypes = new uint8[](i);
276         for(; i > 0 ; i--) {
277             aTypes[i-1] = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(_classId), i-1);
278         }
279         classInfo.types = aTypes;
280 
281         // add steps
282         i = data.getSizeArrayType(ArrayType.STAT_STEP, uint64(_classId));
283         uint8[] memory steps = new uint8[](i);
284         for(; i > 0 ; i--) {
285             steps[i-1] = data.getElementInArrayType(ArrayType.STAT_STEP, uint64(_classId), i-1);
286         }
287         classInfo.steps = steps;
288         
289         // add ancestor
290         i = gateway.getClassPropertySize(_classId, PropertyType.ANCESTOR);
291         uint32[] memory ancestors = new uint32[](i);
292         for(; i > 0 ; i--) {
293             ancestors[i-1] = gateway.getClassPropertyValue(_classId, PropertyType.ANCESTOR, i-1);
294         }
295         classInfo.ancestors = ancestors;
296     }
297     
298     function fastSetCacheClassInfo(uint32 _classId1, uint32 _classId2, uint32 _classId3, uint32 _classId4) onlyModerators requireDataContract requireWorldContract external {
299         setCacheClassInfo(_classId1);
300         setCacheClassInfo(_classId2);
301         setCacheClassInfo(_classId3);
302         setCacheClassInfo(_classId4);
303     }
304     
305     function presetGymTrainer() onlyModerators external {
306         GymTrainer storage trainer1 = gymTrainers[1];
307         trainer1.classId = 12;
308         trainer1.statBases[0] = 85;
309         trainer1.statBases[1] = 95;
310         trainer1.statBases[2] = 65;
311         trainer1.statBases[3] = 50;
312         trainer1.statBases[4] = 50;
313         trainer1.statBases[5] = 50;
314         GymTrainer storage trainer2 = gymTrainers[2];
315         trainer2.classId = 15;
316         trainer2.statBases[0] = 50;
317         trainer2.statBases[1] = 55;
318         trainer2.statBases[2] = 85;
319         trainer2.statBases[3] = 85;
320         trainer2.statBases[4] = 40;
321         trainer2.statBases[5] = 75;
322         GymTrainer storage trainer3 = gymTrainers[3];
323         trainer3.classId = 8;
324         trainer3.statBases[0] = 110;
325         trainer3.statBases[1] = 60;
326         trainer3.statBases[2] = 40;
327         trainer3.statBases[3] = 60;
328         trainer3.statBases[4] = 40;
329         trainer3.statBases[5] = 40;
330         GymTrainer storage trainer4 = gymTrainers[4];
331         trainer4.classId = 4;
332         trainer4.statBases[0] = 54;
333         trainer4.statBases[1] = 69;
334         trainer4.statBases[2] = 58;
335         trainer4.statBases[3] = 75;
336         trainer4.statBases[4] = 75;
337         trainer4.statBases[5] = 70;
338         GymTrainer storage trainer5 = gymTrainers[5];
339         trainer5.classId = 6;
340         trainer5.statBases[0] = 50;
341         trainer5.statBases[1] = 50;
342         trainer5.statBases[2] = 50;
343         trainer5.statBases[3] = 105;
344         trainer5.statBases[4] = 55;
345         trainer5.statBases[5] = 95;
346         GymTrainer storage trainer6 = gymTrainers[6];
347         trainer6.classId = 13;
348         trainer6.statBases[0] = 55;
349         trainer6.statBases[1] = 90;
350         trainer6.statBases[2] = 95;
351         trainer6.statBases[3] = 45;
352         trainer6.statBases[4] = 35;
353         trainer6.statBases[5] = 35;
354         GymTrainer storage trainer7 = gymTrainers[7];
355         trainer7.classId = 7;
356         trainer7.statBases[0] = 85;
357         trainer7.statBases[1] = 60;
358         trainer7.statBases[2] = 73;
359         trainer7.statBases[3] = 75;
360         trainer7.statBases[4] = 80;
361         trainer7.statBases[5] = 50;
362         GymTrainer storage trainer8 = gymTrainers[8];
363         trainer8.classId = 24;
364         trainer8.statBases[0] = 140;
365         trainer8.statBases[1] = 135;
366         trainer8.statBases[2] = 70;
367         trainer8.statBases[3] = 77;
368         trainer8.statBases[4] = 90;
369         trainer8.statBases[5] = 50;
370         GymTrainer storage trainer9 = gymTrainers[9];
371         trainer9.classId = 16;
372         trainer9.statBases[0] = 70;
373         trainer9.statBases[1] = 105;
374         trainer9.statBases[2] = 80;
375         trainer9.statBases[3] = 60;
376         trainer9.statBases[4] = 80;
377         trainer9.statBases[5] = 90;
378         totalTrainer = 9;
379     }
380     
381     function setGymTrainer(uint8 _trainerId, uint32 _classId, uint8 _s0, uint8 _s1, uint8 _s2, uint8 _s3, uint8 _s4, uint8 _s5) onlyModerators external {
382         GymTrainer storage trainer = gymTrainers[_trainerId];
383         if (trainer.classId == 0)
384             totalTrainer += 1;
385         trainer.classId = _classId;
386         trainer.statBases[0] = _s0;
387         trainer.statBases[1] = _s1;
388         trainer.statBases[2] = _s2;
389         trainer.statBases[3] = _s3;
390         trainer.statBases[4] = _s4;
391         trainer.statBases[5] = _s5;
392     }
393     
394     function setContract(address _dataContract, address _worldContract) onlyModerators external {
395         dataContract = _dataContract;
396         worldContract = _worldContract;
397     }
398     
399     function setConfig(uint256 _gymFee, uint8 _maxTrainerLevel, uint8 _maxRandomRound, uint8 _typeBuffPercentage, 
400         uint8 _minHpDeducted, uint8 _expPercentage) onlyModerators external {
401         gymFee = _gymFee;
402         maxTrainerLevel = _maxTrainerLevel;
403         maxRandomRound = _maxRandomRound;
404         typeBuffPercentage = _typeBuffPercentage;
405         minHpDeducted = _minHpDeducted;
406         expPercentage = _expPercentage;
407     }
408     
409     function genLevelExp() onlyModerators external {
410         uint8 level = 1;
411         uint32 requirement = 100;
412         uint32 sum = requirement;
413         while(level <= 100) {
414             levelExps[level] = sum;
415             level += 1;
416             requirement = (requirement * 11) / 10 + 5;
417             sum += requirement;
418         }
419     }
420     
421     function genLevelExpGain() onlyModerators external {
422         levelExpGains[1] = 31;
423         levelExpGains[2] = 33;
424         levelExpGains[3] = 34;
425         levelExpGains[4] = 36;
426         levelExpGains[5] = 38;
427         levelExpGains[6] = 40;
428         levelExpGains[7] = 42;
429         levelExpGains[8] = 44;
430         levelExpGains[9] = 46;
431         levelExpGains[10] = 48;
432     }
433     
434     function setLevelExpGain(uint8 _level, uint32 _exp) onlyModerators external {
435         levelExpGains[_level] = _exp;
436     }
437     
438     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
439         if (_amount > this.balance) {
440             revert();
441         }
442         _sendTo.transfer(_amount);
443     }
444     
445     // public
446     function getCacheClassSize(uint32 _classId) constant public returns(uint, uint, uint) {
447         CacheClassInfo storage classInfo = cacheClasses[_classId];
448         return (classInfo.types.length, classInfo.steps.length, classInfo.ancestors.length);
449     }
450     
451     function getTrainerInfo(uint8 _trainerId) constant external returns(uint32, uint8, uint8, uint8, uint8, uint8, uint8) {
452         GymTrainer memory trainer = gymTrainers[_trainerId];
453         return (trainer.classId, trainer.statBases[0], trainer.statBases[1], trainer.statBases[2], trainer.statBases[3],
454             trainer.statBases[4], trainer.statBases[5]);
455     }
456     
457     function getRandom(uint8 maxRan, uint8 index) constant public returns(uint8) {
458         uint256 genNum = uint256(block.blockhash(block.number-1));
459         for (uint8 i = 0; i < index && i < 6; i ++) {
460             genNum /= 256;
461         }
462         return uint8(genNum % maxRan);
463     }
464     
465     function getLevel(uint32 exp) view public returns (uint8) {
466         uint8 minIndex = 1;
467         uint8 maxIndex = 100;
468         uint8 currentIndex;
469      
470         while (minIndex < maxIndex) {
471             currentIndex = (minIndex + maxIndex) / 2;
472             if (exp < levelExps[currentIndex])
473                 maxIndex = currentIndex;
474             else
475                 minIndex = currentIndex + 1;
476         }
477         return minIndex;
478     }
479     
480     function getGainExp(uint8 xLevel, uint8 yLevel) constant public returns(uint32 winExp, uint32 loseExp){
481         winExp = levelExpGains[yLevel] * expPercentage / 100;
482         if (xLevel > yLevel) {
483             if (xLevel > yLevel + 10) {
484                 winExp = 5;
485             } else {
486                 winExp /= uint32(3) ** (xLevel - yLevel) / uint32(2) ** (xLevel - yLevel);
487                 if (winExp < 5)
488                     winExp = 5;
489             }
490         }
491         loseExp = winExp / 3;
492     }
493     
494     function safeDeduct(uint16 a, uint16 b) pure private returns(uint16){
495         if (a > b) {
496             return a - b;
497         }
498         return 0;
499     }
500     
501     function getTypeSupport(uint32 _aClassId, uint32 _bClassId) constant private returns (bool aHasAdvantage, bool bHasAdvantage) {
502         // check types 
503         for (uint i = 0; i < cacheClasses[_aClassId].types.length; i++) {
504             for (uint j = 0; j < cacheClasses[_bClassId].types.length; j++) {
505                 if (typeAdvantages[cacheClasses[_aClassId].types[i]] == cacheClasses[_bClassId].types[j]) {
506                     aHasAdvantage = true;
507                 }
508                 if (typeAdvantages[cacheClasses[_bClassId].types[j]] == cacheClasses[_aClassId].types[i]) {
509                     bHasAdvantage = true;
510                 }
511             }
512         }
513     }
514     
515     function calHpDeducted(uint16 _attack, uint16 _specialAttack, uint16 _defense, uint16 _specialDefense, bool _lucky) view public returns(uint16){
516         if (_lucky) {
517             _attack = _attack * 13 / 10;
518             _specialAttack = _specialAttack * 13 / 10;
519         }
520         uint16 hpDeducted = safeDeduct(_attack, _defense * 3 /4);
521         uint16 hpSpecialDeducted = safeDeduct(_specialAttack, _specialDefense* 3 / 4);
522         if (hpDeducted < minHpDeducted && hpSpecialDeducted < minHpDeducted)
523             return minHpDeducted;
524         if (hpDeducted > hpSpecialDeducted)
525             return hpDeducted;
526         return hpSpecialDeducted;
527     }
528     
529     function attack(uint8 _index, uint8 _ran, uint16[6] _aStats, uint16[6] _bStats) constant public returns(bool win) {
530         if (_ran < _index * maxRandomRound)
531             _ran = maxRandomRound;
532         else
533             _ran = _ran - _index * maxRandomRound;
534             
535         uint16 round = 0;
536         uint16 aHp = _aStats[0];
537         uint16 bHp = _bStats[0];
538         if (_aStats[5] > _bStats[5]) {
539             while (round < maxRandomRound && aHp > 0 && bHp > 0) {
540                 if (round % 2 == 0) {
541                     // a attack 
542                     bHp = safeDeduct(bHp, calHpDeducted(_aStats[1], _aStats[3], _bStats[2], _bStats[4], round==_ran));
543                 } else {
544                     aHp = safeDeduct(aHp, calHpDeducted(_bStats[1], _bStats[3], _aStats[2], _aStats[4], round==_ran));
545                 }
546                 round++;
547             }
548         } else {
549             while (round < maxRandomRound && aHp > 0 && bHp > 0) {
550                 if (round % 2 != 0) {
551                     bHp = safeDeduct(bHp, calHpDeducted(_aStats[1], _aStats[3], _bStats[2], _bStats[4], round==_ran));
552                 } else {
553                     aHp = safeDeduct(aHp, calHpDeducted(_bStats[1], _bStats[3], _aStats[2], _aStats[4], round==_ran));
554                 }
555                 round++;
556             }
557         }
558         
559         win = aHp >= bHp;
560     }
561     
562     function attackTrainer(uint8 _index, uint8 _ran, uint8 _trainerId, uint8 _trainerLevel, uint32 _objClassId, uint16[6] _objStats) constant public returns(bool result) {
563         GymTrainer memory trainer = gymTrainers[_trainerId];
564         uint16[6] memory trainerStats;
565         uint i = 0;
566         for (i=0; i < STAT_COUNT; i+=1) {
567             trainerStats[i] = trainer.statBases[i];
568         }
569         for (i=0; i < cacheClasses[trainer.classId].steps.length; i++) {
570             trainerStats[i] += uint16(safeMult(cacheClasses[trainer.classId].steps[i], _trainerLevel*3));
571         }
572         
573         bool objHasAdvantage;
574         bool trainerHasAdvantage;
575         (objHasAdvantage, trainerHasAdvantage) = getTypeSupport(_objClassId, trainer.classId);
576         uint16 originAttack = _objStats[1];
577         uint16 originAttackSpecial = _objStats[3];
578         if (objHasAdvantage) {
579             _objStats[1] += _objStats[1] * typeBuffPercentage / 100;
580             _objStats[3] += _objStats[3] * typeBuffPercentage / 100;
581         }
582         if (trainerHasAdvantage) {
583             trainerStats[1] += trainerStats[1] * typeBuffPercentage / 100;
584             trainerStats[3] += trainerStats[3] * typeBuffPercentage / 100;
585         }
586         result = attack(_index, _ran, _objStats, trainerStats);
587         _objStats[1] = originAttack;
588         _objStats[3] = originAttackSpecial;
589     }
590     
591     function getObjInfo(uint64 _objId) constant public returns(uint32 classId, address trainee, uint8 level) {
592         EtheremonDataBase data = EtheremonDataBase(dataContract);
593         MonsterObjAcc memory obj;
594         (obj.monsterId, classId, trainee, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
595         level = getLevel(obj.exp);
596     }
597     
598     function startTraining(uint64 _objId, uint8 _trainerLevel, uint8 _t1, uint8 _t2, uint8 _t3) isActive requireDataContract requireWorldContract payable external {
599         if (_trainerLevel > maxTrainerLevel)
600             revert();
601         if (msg.value != gymFee)
602             revert();
603         if (_t1 == _t2 || _t1 == _t3 || _t2 == _t3)
604             revert();
605         if (_t1 == 0 || _t2 == 0 || _t3 == 0 || _t1 > totalTrainer || _t2 > totalTrainer || _t3 > totalTrainer)
606             revert();
607 
608         AttackData memory att;
609         (att.objClassId, att.trainee, att.objLevel) = getObjInfo(_objId);
610         if (msg.sender != att.trainee)
611             revert();
612 
613         uint i = 0;
614         uint16[6] memory objStats;
615         EtheremonDataBase data = EtheremonDataBase(dataContract);
616         for (i=0; i < STAT_COUNT; i+=1) {
617             objStats[i] = data.getElementInArrayType(ArrayType.STAT_BASE, _objId, i);
618         }
619         for (i=0; i < cacheClasses[att.objClassId].steps.length; i++) {
620             objStats[i] += uint16(safeMult(cacheClasses[att.objClassId].steps[i], att.objLevel*3));
621         }
622         
623         att.winCount = 0;
624         uint8 ran = getRandom(maxRandomRound*3, 0);
625         if (attackTrainer(0, ran, _t1, _trainerLevel, att.objClassId, objStats))
626             att.winCount += 1;
627         if (attackTrainer(1, ran, _t2, _trainerLevel, att.objClassId, objStats))
628             att.winCount += 1;
629         if (attackTrainer(2, ran, _t3, _trainerLevel, att.objClassId, objStats))
630             att.winCount += 1;
631 
632         (att.winExp, att.loseExp) = getGainExp(att.objLevel, _trainerLevel);
633         EtheremonGateway gateway = EtheremonGateway(worldContract);
634         gateway.increaseMonsterExp(_objId, att.winCount * att.winExp + (3 - att.winCount) * att.loseExp);
635         
636         TrainingLog storage trainingLog = trainees[msg.sender];
637         trainingLog.trainers[0] = _t1;
638         trainingLog.trainers[1] = _t2;
639         trainingLog.trainers[2] = _t3;
640         trainingLog.trainerLevel = _trainerLevel;
641         trainingLog.objId = _objId;
642         trainingLog.objLevel = att.objLevel;
643         trainingLog.ran = ran;
644     }
645     
646     function getTrainingLog(address _trainee) constant external returns(uint8, uint8, uint8, uint64, uint8, uint8, uint8) {
647         TrainingLog memory trainingLog = trainees[_trainee];
648         return (trainingLog.trainers[0], trainingLog.trainers[1], trainingLog.trainers[2], 
649             trainingLog.objId, trainingLog.trainerLevel, trainingLog.objLevel, trainingLog.ran);
650     }
651 }