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
143 interface EtheremonTradeInterface {
144     function isOnTrading(uint64 _objId) constant external returns(bool);
145 }
146 
147 contract EtheremonGateway is EtheremonEnum, BasicAccessControl {
148     // using for battle contract later
149     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
150     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
151     
152     // read 
153     function isGason(uint64 _objId) constant external returns(bool);
154     function getObjBattleInfo(uint64 _objId) constant external returns(uint32 classId, uint32 exp, bool isGason, 
155         uint ancestorLength, uint xfactorsLength);
156     function getClassPropertySize(uint32 _classId, PropertyType _type) constant external returns(uint);
157     function getClassPropertyValue(uint32 _classId, PropertyType _type, uint index) constant external returns(uint32);
158 }
159 
160 contract EtheremonCastleContract is EtheremonEnum, BasicAccessControl{
161 
162     uint32 public totalCastle = 0;
163     uint64 public totalBattle = 0;
164     
165     function getCastleBasicInfo(address _owner) constant external returns(uint32, uint, uint32);
166     function getCastleBasicInfoById(uint32 _castleId) constant external returns(uint, address, uint32);
167     function countActiveCastle() constant external returns(uint);
168     function getCastleObjInfo(uint32 _castleId) constant external returns(uint64, uint64, uint64, uint64, uint64, uint64);
169     function getCastleStats(uint32 _castleId) constant external returns(string, address, uint32, uint32, uint32, uint);
170     function isOnCastle(uint32 _castleId, uint64 _objId) constant external returns(bool);
171     function getCastleWinLose(uint32 _castleId) constant external returns(uint32, uint32, uint32);
172     function getTrainerBrick(address _trainer) constant external returns(uint32);
173 
174     function addCastle(address _trainer, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3, uint32 _brickNumber) 
175         onlyModerators external returns(uint32 currentCastleId);
176     function renameCastle(uint32 _castleId, string _name) onlyModerators external;
177     function removeCastleFromActive(uint32 _castleId) onlyModerators external;
178     
179     function addBattleLog(uint32 _castleId, address _attacker, 
180         uint8 _ran1, uint8 _ran2, uint8 _ran3, uint8 _result, uint32 _castleExp1, uint32 _castleExp2, uint32 _castleExp3) onlyModerators external returns(uint64);
181     function addBattleLogMonsterInfo(uint64 _battleId, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3, uint32 _exp1, uint32 _exp2, uint32 _exp3) onlyModerators external;
182 }
183 
184 contract EtheremonBattle is EtheremonEnum, BasicAccessControl, SafeMath {
185     uint8 constant public NO_MONSTER = 3;
186     uint8 constant public STAT_COUNT = 6;
187     uint8 constant public GEN0_NO = 24;
188     
189     struct MonsterClassAcc {
190         uint32 classId;
191         uint256 price;
192         uint256 returnPrice;
193         uint32 total;
194         bool catchable;
195     }
196 
197     struct MonsterObjAcc {
198         uint64 monsterId;
199         uint32 classId;
200         address trainer;
201         string name;
202         uint32 exp;
203         uint32 createIndex;
204         uint32 lastClaimIndex;
205         uint createTime;
206     }
207     
208     struct BattleMonsterData {
209         uint64 a1;
210         uint64 a2;
211         uint64 a3;
212         uint64 s1;
213         uint64 s2;
214         uint64 s3;
215     }
216 
217     struct SupporterData {
218         uint32 classId1;
219         bool isGason1;
220         uint8 type1;
221         uint32 classId2;
222         bool isGason2;
223         uint8 type2;
224         uint32 classId3;
225         bool isGason3;
226         uint8 type3;
227     }
228 
229     struct AttackData {
230         uint64 aa;
231         SupporterData asup;
232         uint16 aAttackSupport;
233         uint64 ba;
234         SupporterData bsup;
235         uint16 bAttackSupport;
236         uint8 index;
237     }
238     
239     struct MonsterBattleLog {
240         uint64 objId;
241         uint32 exp;
242     }
243     
244     struct BattleLogData {
245         address castleOwner;
246         uint64 battleId;
247         uint32 castleId;
248         uint32 castleBrickBonus;
249         uint castleIndex;
250         uint32[6] monsterExp;
251         uint8[3] randoms;
252         bool win;
253         BattleResult result;
254     }
255     
256     struct CacheClassInfo {
257         uint8[] types;
258         uint8[] steps;
259         uint32[] ancestors;
260     }
261 
262     // event
263     event EventCreateCastle(address indexed owner, uint32 castleId);
264     event EventAttackCastle(address indexed attacker, uint32 castleId, uint8 result);
265     event EventRemoveCastle(uint32 indexed castleId);
266     
267     // linked smart contract
268     address public worldContract;
269     address public dataContract;
270     address public tradeContract;
271     address public castleContract;
272     
273     // global variable
274     mapping(uint8 => uint8) typeAdvantages;
275     mapping(uint32 => CacheClassInfo) cacheClasses;
276     mapping(uint8 => uint32) levelExps;
277     uint8 public ancestorBuffPercentage = 10;
278     uint8 public gasonBuffPercentage = 10;
279     uint8 public typeBuffPercentage = 20;
280     uint8 public maxLevel = 100;
281     uint16 public maxActiveCastle = 30;
282     uint8 public maxRandomRound = 4;
283     
284     uint8 public winBrickReturn = 8;
285     uint32 public castleMinBrick = 5;
286     uint256 public brickPrice = 0.008 ether;
287     uint8 public minHpDeducted = 10;
288     
289     uint256 public totalEarn = 0;
290     uint256 public totalWithdraw = 0;
291     
292     address private lastAttacker = address(0x0);
293     
294     // modifier
295     modifier requireDataContract {
296         require(dataContract != address(0));
297         _;
298     }
299     
300     modifier requireTradeContract {
301         require(tradeContract != address(0));
302         _;
303     }
304     
305     modifier requireCastleContract {
306         require(castleContract != address(0));
307         _;
308     }
309     
310     modifier requireWorldContract {
311         require(worldContract != address(0));
312         _;
313     }
314 
315 
316     function EtheremonBattle(address _dataContract, address _worldContract, address _tradeContract, address _castleContract) public {
317         dataContract = _dataContract;
318         worldContract = _worldContract;
319         tradeContract = _tradeContract;
320         castleContract = _castleContract;
321     }
322     
323      // admin & moderators
324     function setTypeAdvantages() onlyModerators external {
325         typeAdvantages[1] = 14;
326         typeAdvantages[2] = 16;
327         typeAdvantages[3] = 8;
328         typeAdvantages[4] = 9;
329         typeAdvantages[5] = 2;
330         typeAdvantages[6] = 11;
331         typeAdvantages[7] = 3;
332         typeAdvantages[8] = 5;
333         typeAdvantages[9] = 15;
334         typeAdvantages[11] = 18;
335         // skipp 10
336         typeAdvantages[12] = 7;
337         typeAdvantages[13] = 6;
338         typeAdvantages[14] = 17;
339         typeAdvantages[15] = 13;
340         typeAdvantages[16] = 12;
341         typeAdvantages[17] = 1;
342         typeAdvantages[18] = 4;
343     }
344     
345     function setTypeAdvantage(uint8 _type1, uint8 _type2) onlyModerators external {
346         typeAdvantages[_type1] = _type2;
347     }
348     
349     function setCacheClassInfo(uint32 _classId) onlyModerators requireDataContract requireWorldContract public {
350         EtheremonDataBase data = EtheremonDataBase(dataContract);
351          EtheremonGateway gateway = EtheremonGateway(worldContract);
352         uint i = 0;
353         CacheClassInfo storage classInfo = cacheClasses[_classId];
354 
355         // add type
356         i = data.getSizeArrayType(ArrayType.CLASS_TYPE, uint64(_classId));
357         uint8[] memory aTypes = new uint8[](i);
358         for(; i > 0 ; i--) {
359             aTypes[i-1] = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(_classId), i-1);
360         }
361         classInfo.types = aTypes;
362 
363         // add steps
364         i = data.getSizeArrayType(ArrayType.STAT_STEP, uint64(_classId));
365         uint8[] memory steps = new uint8[](i);
366         for(; i > 0 ; i--) {
367             steps[i-1] = data.getElementInArrayType(ArrayType.STAT_STEP, uint64(_classId), i-1);
368         }
369         classInfo.steps = steps;
370         
371         // add ancestor
372         i = gateway.getClassPropertySize(_classId, PropertyType.ANCESTOR);
373         uint32[] memory ancestors = new uint32[](i);
374         for(; i > 0 ; i--) {
375             ancestors[i-1] = gateway.getClassPropertyValue(_classId, PropertyType.ANCESTOR, i-1);
376         }
377         classInfo.ancestors = ancestors;
378     }
379      
380     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
381         if (_amount > this.balance) {
382             revert();
383         }
384         uint256 validAmount = safeSubtract(totalEarn, totalWithdraw);
385         if (_amount > validAmount) {
386             revert();
387         }
388         totalWithdraw += _amount;
389         _sendTo.transfer(_amount);
390     }
391     
392     function setContract(address _dataContract, address _worldContract, address _tradeContract, address _castleContract) onlyModerators external {
393         dataContract = _dataContract;
394         worldContract = _worldContract;
395         tradeContract = _tradeContract;
396         castleContract = _castleContract;
397     }
398     
399     function setConfig(uint8 _ancestorBuffPercentage, uint8 _gasonBuffPercentage, uint8 _typeBuffPercentage, uint32 _castleMinBrick, 
400         uint8 _maxLevel, uint16 _maxActiveCastle, uint8 _maxRandomRound, uint8 _minHpDeducted) onlyModerators external{
401         ancestorBuffPercentage = _ancestorBuffPercentage;
402         gasonBuffPercentage = _gasonBuffPercentage;
403         typeBuffPercentage = _typeBuffPercentage;
404         castleMinBrick = _castleMinBrick;
405         maxLevel = _maxLevel;
406         maxActiveCastle = _maxActiveCastle;
407         maxRandomRound = _maxRandomRound;
408         minHpDeducted = _minHpDeducted;
409     }
410     
411     function genLevelExp() onlyModerators external {
412         uint8 level = 1;
413         uint32 requirement = 100;
414         uint32 sum = requirement;
415         while(level <= 100) {
416             levelExps[level] = sum;
417             level += 1;
418             requirement = (requirement * 11) / 10 + 5;
419             sum += requirement;
420         }
421     }
422     
423     // public 
424     function getCacheClassSize(uint32 _classId) constant public returns(uint, uint, uint) {
425         CacheClassInfo storage classInfo = cacheClasses[_classId];
426         return (classInfo.types.length, classInfo.steps.length, classInfo.ancestors.length);
427     }
428     
429     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
430         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
431         for (uint8 i = 0; i < index && i < 6; i ++) {
432             genNum /= 256;
433         }
434         return uint8(genNum % maxRan);
435     }
436     
437     function getLevel(uint32 exp) view public returns (uint8) {
438         uint8 minIndex = 1;
439         uint8 maxIndex = 100;
440         uint8 currentIndex;
441      
442         while (minIndex < maxIndex) {
443             currentIndex = (minIndex + maxIndex) / 2;
444             while (minIndex < maxIndex) {
445                 currentIndex = (minIndex + maxIndex) / 2;
446                 if (exp < levelExps[currentIndex])
447                     maxIndex = currentIndex;
448                 else
449                     minIndex = currentIndex + 1;
450             }
451         }
452         return minIndex;
453     }
454     
455     function getGainExp(uint32 _exp1, uint32 _exp2, bool _win) view public returns(uint32){
456         uint8 level = getLevel(_exp2);
457         uint8 level2 = getLevel(_exp1);
458         uint8 halfLevel1 = level;
459         if (level > level2 + 3) {
460             halfLevel1 = (level2 + 3) / 2;
461         } else {
462             halfLevel1 = level / 2;
463         }
464         uint32 gainExp = 1;
465         uint256 rate = (21 ** uint256(halfLevel1)) * 1000 / (20 ** uint256(halfLevel1));
466         rate = rate * rate;
467         if ((level > level2 + 3 && level2 + 3 > 2 * halfLevel1) || (level <= level2 + 3 && level > 2 * halfLevel1)) rate = rate * 21 / 20;
468         if (_win) {
469             gainExp = uint32(30 * rate / 1000000);
470         } else {
471             gainExp = uint32(10 * rate / 1000000);
472         }
473         
474         if (level2 >= level + 5) {
475             gainExp /= uint32(2) ** ((level2 - level) / 5);
476         }
477         return gainExp;
478     }
479     
480     function getMonsterLevel(uint64 _objId) constant external returns(uint32, uint8) {
481         EtheremonDataBase data = EtheremonDataBase(dataContract);
482         MonsterObjAcc memory obj;
483         uint32 _ = 0;
484         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
485      
486         return (obj.exp, getLevel(obj.exp));
487     }
488     
489     function getMonsterCP(uint64 _objId) constant external returns(uint64) {
490         uint16[6] memory stats;
491         uint32 classId = 0;
492         uint32 exp = 0;
493         (classId, exp, stats) = getCurrentStats(_objId);
494         
495         uint256 total;
496         for(uint i=0; i < STAT_COUNT; i+=1) {
497             total += stats[i];
498         }
499         return uint64(total/STAT_COUNT);
500     }
501     
502     function isOnBattle(uint64 _objId) constant external returns(bool) {
503         EtheremonDataBase data = EtheremonDataBase(dataContract);
504         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
505         uint32 castleId;
506         uint castleIndex = 0;
507         uint256 price = 0;
508         MonsterObjAcc memory obj;
509         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
510         (castleId, castleIndex, price) = castle.getCastleBasicInfo(obj.trainer);
511         if (castleId > 0 && castleIndex > 0)
512             return castle.isOnCastle(castleId, _objId);
513         return false;
514     }
515     
516     function isValidOwner(uint64 _objId, address _owner) constant public returns(bool) {
517         EtheremonDataBase data = EtheremonDataBase(dataContract);
518         MonsterObjAcc memory obj;
519         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
520         return (obj.trainer == _owner);
521     }
522     
523     function getObjExp(uint64 _objId) constant public returns(uint32, uint32) {
524         EtheremonDataBase data = EtheremonDataBase(dataContract);
525         MonsterObjAcc memory obj;
526         uint32 _ = 0;
527         (_objId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
528         return (obj.classId, obj.exp);
529     }
530     
531     function getCurrentStats(uint64 _objId) constant public returns(uint32, uint32, uint16[6]){
532         EtheremonDataBase data = EtheremonDataBase(dataContract);
533         uint16[6] memory stats;
534         uint32 classId;
535         uint32 exp;
536         (classId, exp) = getObjExp(_objId);
537         if (classId == 0)
538             return (classId, exp, stats);
539         
540         uint i = 0;
541         uint8 level = getLevel(exp);
542         for(i=0; i < STAT_COUNT; i+=1) {
543             stats[i] += data.getElementInArrayType(ArrayType.STAT_BASE, _objId, i);
544         }
545         for(i=0; i < cacheClasses[classId].steps.length; i++) {
546             stats[i] += uint16(safeMult(cacheClasses[classId].steps[i], level*3));
547         }
548         return (classId, exp, stats);
549     }
550     
551     function safeDeduct(uint16 a, uint16 b) pure private returns(uint16){
552         if (a > b) {
553             return a - b;
554         }
555         return 0;
556     }
557     
558     function calHpDeducted(uint16 _attack, uint16 _specialAttack, uint16 _defense, uint16 _specialDefense, bool _lucky) view public returns(uint16){
559         if (_lucky) {
560             _attack = _attack * 13 / 10;
561             _specialAttack = _specialAttack * 13 / 10;
562         }
563         uint16 hpDeducted = safeDeduct(_attack, _defense * 3 /4);
564         uint16 hpSpecialDeducted = safeDeduct(_specialAttack, _specialDefense* 3 / 4);
565         if (hpDeducted < minHpDeducted && hpSpecialDeducted < minHpDeducted)
566             return minHpDeducted;
567         if (hpDeducted > hpSpecialDeducted)
568             return hpDeducted;
569         return hpSpecialDeducted;
570     }
571     
572     function getAncestorBuff(uint32 _classId, SupporterData _support) constant private returns(uint16){
573         // check ancestors
574         uint i =0;
575         uint8 countEffect = 0;
576         uint ancestorSize = cacheClasses[_classId].ancestors.length;
577         if (ancestorSize > 0) {
578             uint32 ancestorClass = 0;
579             for (i=0; i < ancestorSize; i ++) {
580                 ancestorClass = cacheClasses[_classId].ancestors[i];
581                 if (ancestorClass == _support.classId1 || ancestorClass == _support.classId2 || ancestorClass == _support.classId3) {
582                     countEffect += 1;
583                 }
584             }
585         }
586         return countEffect * ancestorBuffPercentage;
587     }
588     
589     function getGasonSupport(uint32 _classId, SupporterData _sup) constant private returns(uint16 defenseSupport) {
590         uint i = 0;
591         uint8 classType = 0;
592         for (i = 0; i < cacheClasses[_classId].types.length; i++) {
593             classType = cacheClasses[_classId].types[i];
594              if (_sup.isGason1) {
595                 if (classType == _sup.type1) {
596                     defenseSupport += 1;
597                     continue;
598                 }
599             }
600             if (_sup.isGason2) {
601                 if (classType == _sup.type2) {
602                     defenseSupport += 1;
603                     continue;
604                 }
605             }
606             if (_sup.isGason3) {
607                 if (classType == _sup.type3) {
608                     defenseSupport += 1;
609                     continue;
610                 }
611             }
612             defenseSupport = defenseSupport * gasonBuffPercentage;
613         }
614     }
615     
616     function getTypeSupport(uint32 _aClassId, uint32 _bClassId) constant private returns (uint16 aAttackSupport, uint16 bAttackSupport) {
617         // check types 
618         bool aHasAdvantage;
619         bool bHasAdvantage;
620         for (uint i = 0; i < cacheClasses[_aClassId].types.length; i++) {
621             for (uint j = 0; j < cacheClasses[_bClassId].types.length; j++) {
622                 if (typeAdvantages[cacheClasses[_aClassId].types[i]] == cacheClasses[_bClassId].types[j]) {
623                     aHasAdvantage = true;
624                 }
625                 if (typeAdvantages[cacheClasses[_bClassId].types[j]] == cacheClasses[_aClassId].types[i]) {
626                     bHasAdvantage = true;
627                 }
628             }
629         }
630         
631         if (aHasAdvantage)
632             aAttackSupport += typeBuffPercentage;
633         if (bHasAdvantage)
634             bAttackSupport += typeBuffPercentage;
635     }
636     
637     function calculateBattleStats(AttackData att) constant private returns(uint32 aExp, uint16[6] aStats, uint32 bExp, uint16[6] bStats) {
638         uint32 aClassId = 0;
639         (aClassId, aExp, aStats) = getCurrentStats(att.aa);
640         uint32 bClassId = 0;
641         (bClassId, bExp, bStats) = getCurrentStats(att.ba);
642         
643         // check gasonsupport
644         (att.aAttackSupport, att.bAttackSupport) = getTypeSupport(aClassId, bClassId);
645         att.aAttackSupport += getAncestorBuff(aClassId, att.asup);
646         att.bAttackSupport += getAncestorBuff(bClassId, att.bsup);
647         
648         uint16 aDefenseBuff = getGasonSupport(aClassId, att.asup);
649         uint16 bDefenseBuff = getGasonSupport(bClassId, att.bsup);
650         
651         // add attack
652         aStats[1] += aStats[1] * att.aAttackSupport;
653         aStats[3] += aStats[3] * att.aAttackSupport;
654         bStats[1] += bStats[1] * att.aAttackSupport;
655         bStats[3] += bStats[3] * att.aAttackSupport;
656         
657         // add offense
658         aStats[2] += aStats[2] * aDefenseBuff;
659         aStats[4] += aStats[4] * aDefenseBuff;
660         bStats[2] += bStats[2] * bDefenseBuff;
661         bStats[4] += bStats[4] * bDefenseBuff;
662         
663     }
664     
665     function attack(AttackData att) constant private returns(uint32 aExp, uint32 bExp, uint8 ran, bool win) {
666         uint16[6] memory aStats;
667         uint16[6] memory bStats;
668         (aExp, aStats, bExp, bStats) = calculateBattleStats(att);
669         
670         ran = getRandom(maxRandomRound+2, att.index, lastAttacker);
671         uint16 round = 0;
672         while (round < maxRandomRound && aStats[0] > 0 && bStats[0] > 0) {
673             if (aStats[5] > bStats[5]) {
674                 if (round % 2 == 0) {
675                     // a attack 
676                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
677                 } else {
678                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
679                 }
680                 
681             } else {
682                 if (round % 2 != 0) {
683                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
684                 } else {
685                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
686                 }
687             }
688             round+= 1;
689         }
690         
691         win = aStats[0] >= bStats[0];
692     }
693     
694     function destroyCastle(uint32 _castleId, bool win) requireCastleContract private returns(uint32){
695         // if castle win, ignore
696         if (win)
697             return 0;
698         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
699         uint32 totalWin;
700         uint32 totalLose;
701         uint32 brickNumber;
702         (totalWin, totalLose, brickNumber) = castle.getCastleWinLose(_castleId);
703         if (brickNumber + totalWin/winBrickReturn <= totalLose + 1) {
704             castle.removeCastleFromActive(_castleId);
705             return brickNumber;
706         }
707         return 0;
708     }
709     
710     function hasValidParam(address trainer, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) constant public returns(bool) {
711         if (_a1 == 0 || _a2 == 0 || _a3 == 0)
712             return false;
713         if (_a1 == _a2 || _a1 == _a3 || _a1 == _s1 || _a1 == _s2 || _a1 == _s3)
714             return false;
715         if (_a2 == _a3 || _a2 == _s1 || _a2 == _s2 || _a2 == _s3)
716             return false;
717         if (_a3 == _s1 || _a3 == _s2 || _a3 == _s3)
718             return false;
719         if (_s1 > 0 && (_s1 == _s2 || _s1 == _s3))
720             return false;
721         if (_s2 > 0 && (_s2 == _s3))
722             return false;
723         
724         if (!isValidOwner(_a1, trainer) || !isValidOwner(_a2, trainer) || !isValidOwner(_a3, trainer))
725             return false;
726         if (_s1 > 0 && !isValidOwner(_s1, trainer))
727             return false;
728         if (_s2 > 0 && !isValidOwner(_s2, trainer))
729             return false;
730         if (_s3 > 0 && !isValidOwner(_s3, trainer))
731             return false;
732         return true;
733     }
734     
735     // public
736     function createCastle(string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract 
737         requireTradeContract requireCastleContract payable external {
738         
739         if (!hasValidParam(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3))
740             revert();
741         
742         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
743         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
744             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
745             revert();
746         
747         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
748         uint32 castleId;
749         uint castleIndex = 0;
750         uint32 numberBrick = 0;
751         (castleId, castleIndex, numberBrick) = castle.getCastleBasicInfo(msg.sender);
752         if (castleId > 0 || castleIndex > 0)
753             revert();
754 
755         if (castle.countActiveCastle() >= uint(maxActiveCastle))
756             revert();
757         numberBrick = uint32(msg.value / brickPrice) + castle.getTrainerBrick(msg.sender);
758         if (numberBrick < castleMinBrick) {
759             revert();
760         }
761         totalEarn += msg.value;
762         castleId = castle.addCastle(msg.sender, _name, _a1, _a2, _a3, _s1, _s2, _s3, numberBrick);
763         EventCreateCastle(msg.sender, castleId);
764     }
765     
766     function renameCastle(uint32 _castleId, string _name) isActive requireCastleContract external {
767         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
768         uint index;
769         address owner;
770         uint256 price;
771         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
772         if (owner != msg.sender)
773             revert();
774         castle.renameCastle(_castleId, _name);
775     }
776     
777     function removeCastle(uint32 _castleId) isActive requireCastleContract external {
778         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
779         uint index;
780         address owner;
781         uint256 price;
782         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
783         if (owner != msg.sender)
784             revert();
785         if (index > 0) {
786             castle.removeCastleFromActive(_castleId);
787         }
788         EventRemoveCastle(_castleId);
789     }
790     
791     function getSupporterInfo(uint64 s1, uint64 s2, uint64 s3) constant public returns(SupporterData sData) {
792         uint temp;
793         uint32 __;
794         EtheremonGateway gateway = EtheremonGateway(worldContract);
795         if (s1 > 0)
796             (sData.classId1, __, sData.isGason1, temp, temp) = gateway.getObjBattleInfo(s1);
797         if (s2 > 0)
798             (sData.classId2, __, sData.isGason2, temp, temp) = gateway.getObjBattleInfo(s2);
799         if (s3 > 0)
800             (sData.classId3, __, sData.isGason3, temp, temp) = gateway.getObjBattleInfo(s3);
801 
802         EtheremonDataBase data = EtheremonDataBase(dataContract);
803         if (sData.isGason1) {
804             sData.type1 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId1), 0);
805         }
806         
807         if (sData.isGason2) {
808             sData.type2 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId2), 0);
809         }
810         
811         if (sData.isGason3) {
812             sData.type3 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId3), 0);
813         }
814     }
815     
816     function attackCastle(uint32 _castleId, uint64 _aa1, uint64 _aa2, uint64 _aa3, uint64 _as1, uint64 _as2, uint64 _as3) isActive requireDataContract 
817         requireTradeContract requireCastleContract external {
818         if (!hasValidParam(msg.sender, _aa1, _aa2, _aa3, _as1, _as2, _as3))
819             revert();
820         
821         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
822         BattleLogData memory log;
823         (log.castleIndex, log.castleOwner, log.castleBrickBonus) = castle.getCastleBasicInfoById(_castleId);
824         if (log.castleIndex == 0 || log.castleOwner == msg.sender)
825             revert();
826         
827         EtheremonGateway gateway = EtheremonGateway(worldContract);
828         BattleMonsterData memory b;
829         (b.a1, b.a2, b.a3, b.s1, b.s2, b.s3) = castle.getCastleObjInfo(_castleId);
830         lastAttacker = msg.sender;
831 
832         // init data
833         uint8 countWin = 0;
834         AttackData memory att;
835         att.asup = getSupporterInfo(b.s1, b.s2, b.s3);
836         att.bsup = getSupporterInfo(_as1, _as2, _as3);
837         
838         att.index = 0;
839         att.aa = b.a1;
840         att.ba = _aa1;
841         (log.monsterExp[0], log.monsterExp[3], log.randoms[0], log.win) = attack(att);
842         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[0], log.monsterExp[3], log.win));
843         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[3], log.monsterExp[0], !log.win));
844         if (log.win)
845             countWin += 1;
846         
847         
848         att.index = 1;
849         att.aa = b.a2;
850         att.ba = _aa2;
851         (log.monsterExp[1], log.monsterExp[4], log.randoms[1], log.win) = attack(att);
852         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[1], log.monsterExp[4], log.win));
853         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[4], log.monsterExp[1], !log.win));
854         if (log.win)
855             countWin += 1;   
856 
857         att.index = 2;
858         att.aa = b.a3;
859         att.ba = _aa3;
860         (log.monsterExp[2], log.monsterExp[5], log.randoms[2], log.win) = attack(att);
861         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[2], log.monsterExp[5], log.win));
862         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[5], log.monsterExp[2], !log.win));
863         if (log.win)
864             countWin += 1; 
865         
866         
867         log.castleBrickBonus = destroyCastle(_castleId, countWin>1);
868         if (countWin>1) {
869             log.result = BattleResult.CASTLE_WIN;
870         } else {
871             if (log.castleBrickBonus > 0) {
872                 log.result = BattleResult.CASTLE_DESTROYED;
873             } else {
874                 log.result = BattleResult.CASTLE_LOSE;
875             }
876         }
877         
878         log.battleId = castle.addBattleLog(_castleId, msg.sender, log.randoms[0], log.randoms[1], log.randoms[2], 
879             uint8(log.result), log.monsterExp[0], log.monsterExp[1], log.monsterExp[2]);
880         
881         castle.addBattleLogMonsterInfo(log.battleId, _aa1, _aa2, _aa3, _as1, _as2, _as3, log.monsterExp[3], log.monsterExp[4], log.monsterExp[5]);
882     
883         EventAttackCastle(msg.sender, _castleId, uint8(log.result));
884     }
885     
886 }