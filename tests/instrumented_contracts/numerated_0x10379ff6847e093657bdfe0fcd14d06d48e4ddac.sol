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
178     function deductTrainerBrick(address _trainer, uint32 _deductAmount) onlyModerators external returns(bool);
179     
180     function addBattleLog(uint32 _castleId, address _attacker, 
181         uint8 _ran1, uint8 _ran2, uint8 _ran3, uint8 _result, uint32 _castleExp1, uint32 _castleExp2, uint32 _castleExp3) onlyModerators external returns(uint64);
182     function addBattleLogMonsterInfo(uint64 _battleId, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3, uint32 _exp1, uint32 _exp2, uint32 _exp3) onlyModerators external;
183 }
184 
185 contract EtheremonBattle is EtheremonEnum, BasicAccessControl, SafeMath {
186     uint8 constant public NO_MONSTER = 3;
187     uint8 constant public STAT_COUNT = 6;
188     uint8 constant public GEN0_NO = 24;
189     
190     struct MonsterClassAcc {
191         uint32 classId;
192         uint256 price;
193         uint256 returnPrice;
194         uint32 total;
195         bool catchable;
196     }
197 
198     struct MonsterObjAcc {
199         uint64 monsterId;
200         uint32 classId;
201         address trainer;
202         string name;
203         uint32 exp;
204         uint32 createIndex;
205         uint32 lastClaimIndex;
206         uint createTime;
207     }
208     
209     struct BattleMonsterData {
210         uint64 a1;
211         uint64 a2;
212         uint64 a3;
213         uint64 s1;
214         uint64 s2;
215         uint64 s3;
216     }
217 
218     struct SupporterData {
219         uint32 classId1;
220         bool isGason1;
221         uint8 type1;
222         uint32 classId2;
223         bool isGason2;
224         uint8 type2;
225         uint32 classId3;
226         bool isGason3;
227         uint8 type3;
228     }
229 
230     struct AttackData {
231         uint64 aa;
232         SupporterData asup;
233         uint16 aAttackSupport;
234         uint64 ba;
235         SupporterData bsup;
236         uint16 bAttackSupport;
237         uint8 index;
238     }
239     
240     struct MonsterBattleLog {
241         uint64 objId;
242         uint32 exp;
243     }
244     
245     struct BattleLogData {
246         address castleOwner;
247         uint64 battleId;
248         uint32 castleId;
249         uint32 castleBrickBonus;
250         uint castleIndex;
251         uint32[6] monsterExp;
252         uint8[3] randoms;
253         bool win;
254         BattleResult result;
255     }
256     
257     struct CacheClassInfo {
258         uint8[] types;
259         uint8[] steps;
260         uint32[] ancestors;
261     }
262 
263     // event
264     event EventCreateCastle(address indexed owner, uint32 castleId);
265     event EventAttackCastle(address indexed attacker, uint32 castleId, uint8 result);
266     event EventRemoveCastle(uint32 indexed castleId);
267     
268     // linked smart contract
269     address public worldContract;
270     address public dataContract;
271     address public tradeContract;
272     address public castleContract;
273     
274     // global variable
275     mapping(uint8 => uint8) typeAdvantages;
276     mapping(uint32 => CacheClassInfo) cacheClasses;
277     mapping(uint8 => uint32) levelExps;
278     uint8 public ancestorBuffPercentage = 10;
279     uint8 public gasonBuffPercentage = 10;
280     uint8 public typeBuffPercentage = 20;
281     uint8 public maxLevel = 100;
282     uint16 public maxActiveCastle = 30;
283     uint8 public maxRandomRound = 4;
284     
285     uint8 public winBrickReturn = 8;
286     uint32 public castleMinBrick = 5;
287     uint256 public brickPrice = 0.008 ether;
288     uint8 public minHpDeducted = 10;
289     
290     uint256 public totalEarn = 0;
291     uint256 public totalWithdraw = 0;
292     
293     address private lastAttacker = address(0x0);
294     
295     // modifier
296     modifier requireDataContract {
297         require(dataContract != address(0));
298         _;
299     }
300     
301     modifier requireTradeContract {
302         require(tradeContract != address(0));
303         _;
304     }
305     
306     modifier requireCastleContract {
307         require(castleContract != address(0));
308         _;
309     }
310     
311     modifier requireWorldContract {
312         require(worldContract != address(0));
313         _;
314     }
315 
316 
317     function EtheremonBattle(address _dataContract, address _worldContract, address _tradeContract, address _castleContract) public {
318         dataContract = _dataContract;
319         worldContract = _worldContract;
320         tradeContract = _tradeContract;
321         castleContract = _castleContract;
322     }
323     
324      // admin & moderators
325     function setTypeAdvantages() onlyModerators external {
326         typeAdvantages[1] = 14;
327         typeAdvantages[2] = 16;
328         typeAdvantages[3] = 8;
329         typeAdvantages[4] = 9;
330         typeAdvantages[5] = 2;
331         typeAdvantages[6] = 11;
332         typeAdvantages[7] = 3;
333         typeAdvantages[8] = 5;
334         typeAdvantages[9] = 15;
335         typeAdvantages[11] = 18;
336         // skipp 10
337         typeAdvantages[12] = 7;
338         typeAdvantages[13] = 6;
339         typeAdvantages[14] = 17;
340         typeAdvantages[15] = 13;
341         typeAdvantages[16] = 12;
342         typeAdvantages[17] = 1;
343         typeAdvantages[18] = 4;
344     }
345     
346     function setTypeAdvantage(uint8 _type1, uint8 _type2) onlyModerators external {
347         typeAdvantages[_type1] = _type2;
348     }
349     
350     function setCacheClassInfo(uint32 _classId) onlyModerators requireDataContract requireWorldContract public {
351         EtheremonDataBase data = EtheremonDataBase(dataContract);
352          EtheremonGateway gateway = EtheremonGateway(worldContract);
353         uint i = 0;
354         CacheClassInfo storage classInfo = cacheClasses[_classId];
355 
356         // add type
357         i = data.getSizeArrayType(ArrayType.CLASS_TYPE, uint64(_classId));
358         uint8[] memory aTypes = new uint8[](i);
359         for(; i > 0 ; i--) {
360             aTypes[i-1] = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(_classId), i-1);
361         }
362         classInfo.types = aTypes;
363 
364         // add steps
365         i = data.getSizeArrayType(ArrayType.STAT_STEP, uint64(_classId));
366         uint8[] memory steps = new uint8[](i);
367         for(; i > 0 ; i--) {
368             steps[i-1] = data.getElementInArrayType(ArrayType.STAT_STEP, uint64(_classId), i-1);
369         }
370         classInfo.steps = steps;
371         
372         // add ancestor
373         i = gateway.getClassPropertySize(_classId, PropertyType.ANCESTOR);
374         uint32[] memory ancestors = new uint32[](i);
375         for(; i > 0 ; i--) {
376             ancestors[i-1] = gateway.getClassPropertyValue(_classId, PropertyType.ANCESTOR, i-1);
377         }
378         classInfo.ancestors = ancestors;
379     }
380      
381     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
382         if (_amount > this.balance) {
383             revert();
384         }
385         uint256 validAmount = safeSubtract(totalEarn, totalWithdraw);
386         if (_amount > validAmount) {
387             revert();
388         }
389         totalWithdraw += _amount;
390         _sendTo.transfer(_amount);
391     }
392     
393     function setContract(address _dataContract, address _worldContract, address _tradeContract, address _castleContract) onlyModerators external {
394         dataContract = _dataContract;
395         worldContract = _worldContract;
396         tradeContract = _tradeContract;
397         castleContract = _castleContract;
398     }
399     
400     function setConfig(uint8 _ancestorBuffPercentage, uint8 _gasonBuffPercentage, uint8 _typeBuffPercentage, uint32 _castleMinBrick, 
401         uint8 _maxLevel, uint16 _maxActiveCastle, uint8 _maxRandomRound, uint8 _minHpDeducted) onlyModerators external{
402         ancestorBuffPercentage = _ancestorBuffPercentage;
403         gasonBuffPercentage = _gasonBuffPercentage;
404         typeBuffPercentage = _typeBuffPercentage;
405         castleMinBrick = _castleMinBrick;
406         maxLevel = _maxLevel;
407         maxActiveCastle = _maxActiveCastle;
408         maxRandomRound = _maxRandomRound;
409         minHpDeducted = _minHpDeducted;
410     }
411     
412     function genLevelExp() onlyModerators external {
413         uint8 level = 1;
414         uint32 requirement = 100;
415         uint32 sum = requirement;
416         while(level <= 100) {
417             levelExps[level] = sum;
418             level += 1;
419             requirement = (requirement * 11) / 10 + 5;
420             sum += requirement;
421         }
422     }
423     
424     // public 
425     function getCacheClassSize(uint32 _classId) constant public returns(uint, uint, uint) {
426         CacheClassInfo storage classInfo = cacheClasses[_classId];
427         return (classInfo.types.length, classInfo.steps.length, classInfo.ancestors.length);
428     }
429     
430     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
431         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
432         for (uint8 i = 0; i < index && i < 6; i ++) {
433             genNum /= 256;
434         }
435         return uint8(genNum % maxRan);
436     }
437     
438     function getLevel(uint32 exp) view public returns (uint8) {
439         uint8 minIndex = 1;
440         uint8 maxIndex = 100;
441         uint8 currentIndex;
442      
443         while (minIndex < maxIndex) {
444             currentIndex = (minIndex + maxIndex) / 2;
445             while (minIndex < maxIndex) {
446                 currentIndex = (minIndex + maxIndex) / 2;
447                 if (exp < levelExps[currentIndex])
448                     maxIndex = currentIndex;
449                 else
450                     minIndex = currentIndex + 1;
451             }
452         }
453         return minIndex;
454     }
455     
456     function getGainExp(uint32 _exp1, uint32 _exp2, bool _win) view public returns(uint32){
457         uint8 level = getLevel(_exp2);
458         uint8 level2 = getLevel(_exp1);
459         uint8 halfLevel1 = level;
460         if (level > level2 + 3) {
461             halfLevel1 = (level2 + 3) / 2;
462         } else {
463             halfLevel1 = level / 2;
464         }
465         uint32 gainExp = 1;
466         uint256 rate = (21 ** uint256(halfLevel1)) * 1000 / (20 ** uint256(halfLevel1));
467         rate = rate * rate;
468         if ((level > level2 + 3 && level2 + 3 > 2 * halfLevel1) || (level <= level2 + 3 && level > 2 * halfLevel1)) rate = rate * 21 / 20;
469         if (_win) {
470             gainExp = uint32(30 * rate / 1000000);
471         } else {
472             gainExp = uint32(10 * rate / 1000000);
473         }
474         
475         if (level2 >= level + 5) {
476             gainExp /= uint32(2) ** ((level2 - level) / 5);
477         }
478         return gainExp;
479     }
480     
481     function getMonsterLevel(uint64 _objId) constant external returns(uint32, uint8) {
482         EtheremonDataBase data = EtheremonDataBase(dataContract);
483         MonsterObjAcc memory obj;
484         uint32 _ = 0;
485         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
486      
487         return (obj.exp, getLevel(obj.exp));
488     }
489     
490     function getMonsterCP(uint64 _objId) constant external returns(uint64) {
491         uint16[6] memory stats;
492         uint32 classId = 0;
493         uint32 exp = 0;
494         (classId, exp, stats) = getCurrentStats(_objId);
495         
496         uint256 total;
497         for(uint i=0; i < STAT_COUNT; i+=1) {
498             total += stats[i];
499         }
500         return uint64(total/STAT_COUNT);
501     }
502     
503     function isOnBattle(uint64 _objId) constant external returns(bool) {
504         EtheremonDataBase data = EtheremonDataBase(dataContract);
505         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
506         uint32 castleId;
507         uint castleIndex = 0;
508         uint256 price = 0;
509         MonsterObjAcc memory obj;
510         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
511         (castleId, castleIndex, price) = castle.getCastleBasicInfo(obj.trainer);
512         if (castleId > 0 && castleIndex > 0)
513             return castle.isOnCastle(castleId, _objId);
514         return false;
515     }
516     
517     function isValidOwner(uint64 _objId, address _owner) constant public returns(bool) {
518         EtheremonDataBase data = EtheremonDataBase(dataContract);
519         MonsterObjAcc memory obj;
520         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
521         return (obj.trainer == _owner);
522     }
523     
524     function getObjExp(uint64 _objId) constant public returns(uint32, uint32) {
525         EtheremonDataBase data = EtheremonDataBase(dataContract);
526         MonsterObjAcc memory obj;
527         uint32 _ = 0;
528         (_objId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
529         return (obj.classId, obj.exp);
530     }
531     
532     function getCurrentStats(uint64 _objId) constant public returns(uint32, uint32, uint16[6]){
533         EtheremonDataBase data = EtheremonDataBase(dataContract);
534         uint16[6] memory stats;
535         uint32 classId;
536         uint32 exp;
537         (classId, exp) = getObjExp(_objId);
538         if (classId == 0)
539             return (classId, exp, stats);
540         
541         uint i = 0;
542         uint8 level = getLevel(exp);
543         for(i=0; i < STAT_COUNT; i+=1) {
544             stats[i] += data.getElementInArrayType(ArrayType.STAT_BASE, _objId, i);
545         }
546         for(i=0; i < cacheClasses[classId].steps.length; i++) {
547             stats[i] += uint16(safeMult(cacheClasses[classId].steps[i], level*3));
548         }
549         return (classId, exp, stats);
550     }
551     
552     function safeDeduct(uint16 a, uint16 b) pure private returns(uint16){
553         if (a > b) {
554             return a - b;
555         }
556         return 0;
557     }
558     
559     function calHpDeducted(uint16 _attack, uint16 _specialAttack, uint16 _defense, uint16 _specialDefense, bool _lucky) view public returns(uint16){
560         if (_lucky) {
561             _attack = _attack * 13 / 10;
562             _specialAttack = _specialAttack * 13 / 10;
563         }
564         uint16 hpDeducted = safeDeduct(_attack, _defense * 3 /4);
565         uint16 hpSpecialDeducted = safeDeduct(_specialAttack, _specialDefense* 3 / 4);
566         if (hpDeducted < minHpDeducted && hpSpecialDeducted < minHpDeducted)
567             return minHpDeducted;
568         if (hpDeducted > hpSpecialDeducted)
569             return hpDeducted;
570         return hpSpecialDeducted;
571     }
572     
573     function getAncestorBuff(uint32 _classId, SupporterData _support) constant private returns(uint16){
574         // check ancestors
575         uint i =0;
576         uint8 countEffect = 0;
577         uint ancestorSize = cacheClasses[_classId].ancestors.length;
578         if (ancestorSize > 0) {
579             uint32 ancestorClass = 0;
580             for (i=0; i < ancestorSize; i ++) {
581                 ancestorClass = cacheClasses[_classId].ancestors[i];
582                 if (ancestorClass == _support.classId1 || ancestorClass == _support.classId2 || ancestorClass == _support.classId3) {
583                     countEffect += 1;
584                 }
585             }
586         }
587         return countEffect * ancestorBuffPercentage;
588     }
589     
590     function getGasonSupport(uint32 _classId, SupporterData _sup) constant private returns(uint16 defenseSupport) {
591         uint i = 0;
592         uint8 classType = 0;
593         for (i = 0; i < cacheClasses[_classId].types.length; i++) {
594             classType = cacheClasses[_classId].types[i];
595              if (_sup.isGason1) {
596                 if (classType == _sup.type1) {
597                     defenseSupport += 1;
598                     continue;
599                 }
600             }
601             if (_sup.isGason2) {
602                 if (classType == _sup.type2) {
603                     defenseSupport += 1;
604                     continue;
605                 }
606             }
607             if (_sup.isGason3) {
608                 if (classType == _sup.type3) {
609                     defenseSupport += 1;
610                     continue;
611                 }
612             }
613             defenseSupport = defenseSupport * gasonBuffPercentage;
614         }
615     }
616     
617     function getTypeSupport(uint32 _aClassId, uint32 _bClassId) constant private returns (uint16 aAttackSupport, uint16 bAttackSupport) {
618         // check types 
619         bool aHasAdvantage;
620         bool bHasAdvantage;
621         for (uint i = 0; i < cacheClasses[_aClassId].types.length; i++) {
622             for (uint j = 0; j < cacheClasses[_bClassId].types.length; j++) {
623                 if (typeAdvantages[cacheClasses[_aClassId].types[i]] == cacheClasses[_bClassId].types[j]) {
624                     aHasAdvantage = true;
625                 }
626                 if (typeAdvantages[cacheClasses[_bClassId].types[j]] == cacheClasses[_aClassId].types[i]) {
627                     bHasAdvantage = true;
628                 }
629             }
630         }
631         
632         if (aHasAdvantage)
633             aAttackSupport += typeBuffPercentage;
634         if (bHasAdvantage)
635             bAttackSupport += typeBuffPercentage;
636     }
637     
638     function calculateBattleStats(AttackData att) constant private returns(uint32 aExp, uint16[6] aStats, uint32 bExp, uint16[6] bStats) {
639         uint32 aClassId = 0;
640         (aClassId, aExp, aStats) = getCurrentStats(att.aa);
641         uint32 bClassId = 0;
642         (bClassId, bExp, bStats) = getCurrentStats(att.ba);
643         
644         // check gasonsupport
645         (att.aAttackSupport, att.bAttackSupport) = getTypeSupport(aClassId, bClassId);
646         att.aAttackSupport += getAncestorBuff(aClassId, att.asup);
647         att.bAttackSupport += getAncestorBuff(bClassId, att.bsup);
648         
649         uint16 aDefenseBuff = getGasonSupport(aClassId, att.asup);
650         uint16 bDefenseBuff = getGasonSupport(bClassId, att.bsup);
651         
652         // add attack
653         aStats[1] += aStats[1] * att.aAttackSupport;
654         aStats[3] += aStats[3] * att.aAttackSupport;
655         bStats[1] += bStats[1] * att.aAttackSupport;
656         bStats[3] += bStats[3] * att.aAttackSupport;
657         
658         // add offense
659         aStats[2] += aStats[2] * aDefenseBuff;
660         aStats[4] += aStats[4] * aDefenseBuff;
661         bStats[2] += bStats[2] * bDefenseBuff;
662         bStats[4] += bStats[4] * bDefenseBuff;
663         
664     }
665     
666     function attack(AttackData att) constant private returns(uint32 aExp, uint32 bExp, uint8 ran, bool win) {
667         uint16[6] memory aStats;
668         uint16[6] memory bStats;
669         (aExp, aStats, bExp, bStats) = calculateBattleStats(att);
670         
671         ran = getRandom(maxRandomRound+2, att.index, lastAttacker);
672         uint16 round = 0;
673         while (round < maxRandomRound && aStats[0] > 0 && bStats[0] > 0) {
674             if (aStats[5] > bStats[5]) {
675                 if (round % 2 == 0) {
676                     // a attack 
677                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
678                 } else {
679                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
680                 }
681                 
682             } else {
683                 if (round % 2 != 0) {
684                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
685                 } else {
686                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
687                 }
688             }
689             round+= 1;
690         }
691         
692         win = aStats[0] >= bStats[0];
693     }
694     
695     function destroyCastle(uint32 _castleId, bool win) requireCastleContract private returns(uint32){
696         // if castle win, ignore
697         if (win)
698             return 0;
699         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
700         uint32 totalWin;
701         uint32 totalLose;
702         uint32 brickNumber;
703         (totalWin, totalLose, brickNumber) = castle.getCastleWinLose(_castleId);
704         if (brickNumber + totalWin/winBrickReturn <= totalLose + 1) {
705             castle.removeCastleFromActive(_castleId);
706             return brickNumber;
707         }
708         return 0;
709     }
710     
711     function hasValidParam(address trainer, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) constant public returns(bool) {
712         if (_a1 == 0 || _a2 == 0 || _a3 == 0)
713             return false;
714         if (_a1 == _a2 || _a1 == _a3 || _a1 == _s1 || _a1 == _s2 || _a1 == _s3)
715             return false;
716         if (_a2 == _a3 || _a2 == _s1 || _a2 == _s2 || _a2 == _s3)
717             return false;
718         if (_a3 == _s1 || _a3 == _s2 || _a3 == _s3)
719             return false;
720         if (_s1 > 0 && (_s1 == _s2 || _s1 == _s3))
721             return false;
722         if (_s2 > 0 && (_s2 == _s3))
723             return false;
724         
725         if (!isValidOwner(_a1, trainer) || !isValidOwner(_a2, trainer) || !isValidOwner(_a3, trainer))
726             return false;
727         if (_s1 > 0 && !isValidOwner(_s1, trainer))
728             return false;
729         if (_s2 > 0 && !isValidOwner(_s2, trainer))
730             return false;
731         if (_s3 > 0 && !isValidOwner(_s3, trainer))
732             return false;
733         return true;
734     }
735     
736     // public
737     function createCastle(string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract 
738         requireTradeContract requireCastleContract payable external {
739         
740         if (!hasValidParam(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3))
741             revert();
742         
743         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
744         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
745             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
746             revert();
747         
748         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
749         uint32 castleId;
750         uint castleIndex = 0;
751         uint32 numberBrick = 0;
752         (castleId, castleIndex, numberBrick) = castle.getCastleBasicInfo(msg.sender);
753         if (castleId > 0 || castleIndex > 0)
754             revert();
755 
756         if (castle.countActiveCastle() >= uint(maxActiveCastle))
757             revert();
758         numberBrick = uint32(msg.value / brickPrice) + castle.getTrainerBrick(msg.sender);
759         if (numberBrick < castleMinBrick) {
760             revert();
761         }
762         castle.deductTrainerBrick(msg.sender, castle.getTrainerBrick(msg.sender));
763         totalEarn += msg.value;
764         castleId = castle.addCastle(msg.sender, _name, _a1, _a2, _a3, _s1, _s2, _s3, numberBrick);
765         EventCreateCastle(msg.sender, castleId);
766     }
767     
768     function renameCastle(uint32 _castleId, string _name) isActive requireCastleContract external {
769         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
770         uint index;
771         address owner;
772         uint256 price;
773         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
774         if (owner != msg.sender)
775             revert();
776         castle.renameCastle(_castleId, _name);
777     }
778     
779     function removeCastle(uint32 _castleId) isActive requireCastleContract external {
780         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
781         uint index;
782         address owner;
783         uint256 price;
784         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
785         if (owner != msg.sender)
786             revert();
787         if (index > 0) {
788             castle.removeCastleFromActive(_castleId);
789         }
790         EventRemoveCastle(_castleId);
791     }
792     
793     function getSupporterInfo(uint64 s1, uint64 s2, uint64 s3) constant public returns(SupporterData sData) {
794         uint temp;
795         uint32 __;
796         EtheremonGateway gateway = EtheremonGateway(worldContract);
797         if (s1 > 0)
798             (sData.classId1, __, sData.isGason1, temp, temp) = gateway.getObjBattleInfo(s1);
799         if (s2 > 0)
800             (sData.classId2, __, sData.isGason2, temp, temp) = gateway.getObjBattleInfo(s2);
801         if (s3 > 0)
802             (sData.classId3, __, sData.isGason3, temp, temp) = gateway.getObjBattleInfo(s3);
803 
804         EtheremonDataBase data = EtheremonDataBase(dataContract);
805         if (sData.isGason1) {
806             sData.type1 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId1), 0);
807         }
808         
809         if (sData.isGason2) {
810             sData.type2 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId2), 0);
811         }
812         
813         if (sData.isGason3) {
814             sData.type3 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId3), 0);
815         }
816     }
817     
818     function attackCastle(uint32 _castleId, uint64 _aa1, uint64 _aa2, uint64 _aa3, uint64 _as1, uint64 _as2, uint64 _as3) isActive requireDataContract 
819         requireTradeContract requireCastleContract external {
820         if (!hasValidParam(msg.sender, _aa1, _aa2, _aa3, _as1, _as2, _as3))
821             revert();
822         
823         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
824         BattleLogData memory log;
825         (log.castleIndex, log.castleOwner, log.castleBrickBonus) = castle.getCastleBasicInfoById(_castleId);
826         if (log.castleIndex == 0 || log.castleOwner == msg.sender)
827             revert();
828         
829         EtheremonGateway gateway = EtheremonGateway(worldContract);
830         BattleMonsterData memory b;
831         (b.a1, b.a2, b.a3, b.s1, b.s2, b.s3) = castle.getCastleObjInfo(_castleId);
832         lastAttacker = msg.sender;
833 
834         // init data
835         uint8 countWin = 0;
836         AttackData memory att;
837         att.asup = getSupporterInfo(b.s1, b.s2, b.s3);
838         att.bsup = getSupporterInfo(_as1, _as2, _as3);
839         
840         att.index = 0;
841         att.aa = b.a1;
842         att.ba = _aa1;
843         (log.monsterExp[0], log.monsterExp[3], log.randoms[0], log.win) = attack(att);
844         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[0], log.monsterExp[3], log.win));
845         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[3], log.monsterExp[0], !log.win));
846         if (log.win)
847             countWin += 1;
848         
849         
850         att.index = 1;
851         att.aa = b.a2;
852         att.ba = _aa2;
853         (log.monsterExp[1], log.monsterExp[4], log.randoms[1], log.win) = attack(att);
854         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[1], log.monsterExp[4], log.win));
855         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[4], log.monsterExp[1], !log.win));
856         if (log.win)
857             countWin += 1;   
858 
859         att.index = 2;
860         att.aa = b.a3;
861         att.ba = _aa3;
862         (log.monsterExp[2], log.monsterExp[5], log.randoms[2], log.win) = attack(att);
863         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[2], log.monsterExp[5], log.win));
864         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[5], log.monsterExp[2], !log.win));
865         if (log.win)
866             countWin += 1; 
867         
868         
869         log.castleBrickBonus = destroyCastle(_castleId, countWin>1);
870         if (countWin>1) {
871             log.result = BattleResult.CASTLE_WIN;
872         } else {
873             if (log.castleBrickBonus > 0) {
874                 log.result = BattleResult.CASTLE_DESTROYED;
875             } else {
876                 log.result = BattleResult.CASTLE_LOSE;
877             }
878         }
879         
880         log.battleId = castle.addBattleLog(_castleId, msg.sender, log.randoms[0], log.randoms[1], log.randoms[2], 
881             uint8(log.result), log.monsterExp[0], log.monsterExp[1], log.monsterExp[2]);
882         
883         castle.addBattleLogMonsterInfo(log.battleId, _aa1, _aa2, _aa3, _as1, _as2, _as3, log.monsterExp[3], log.monsterExp[4], log.monsterExp[5]);
884     
885         EventAttackCastle(msg.sender, _castleId, uint8(log.result));
886     }
887     
888 }