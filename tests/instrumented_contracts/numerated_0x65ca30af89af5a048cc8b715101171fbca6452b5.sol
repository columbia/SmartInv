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
381     function fastSetCacheClassInfo(uint32 _classId1, uint32 _classId2, uint32 _classId3, uint32 _classId4) onlyModerators requireDataContract requireWorldContract public {
382         setCacheClassInfo(_classId1);
383         setCacheClassInfo(_classId2);
384         setCacheClassInfo(_classId3);
385         setCacheClassInfo(_classId4);
386     }    
387      
388     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
389         if (_amount > this.balance) {
390             revert();
391         }
392         uint256 validAmount = safeSubtract(totalEarn, totalWithdraw);
393         if (_amount > validAmount) {
394             revert();
395         }
396         totalWithdraw += _amount;
397         _sendTo.transfer(_amount);
398     }
399     
400     function setContract(address _dataContract, address _worldContract, address _tradeContract, address _castleContract) onlyModerators external {
401         dataContract = _dataContract;
402         worldContract = _worldContract;
403         tradeContract = _tradeContract;
404         castleContract = _castleContract;
405     }
406     
407     function setConfig(uint8 _ancestorBuffPercentage, uint8 _gasonBuffPercentage, uint8 _typeBuffPercentage, uint32 _castleMinBrick, 
408         uint8 _maxLevel, uint16 _maxActiveCastle, uint8 _maxRandomRound, uint8 _minHpDeducted) onlyModerators external{
409         ancestorBuffPercentage = _ancestorBuffPercentage;
410         gasonBuffPercentage = _gasonBuffPercentage;
411         typeBuffPercentage = _typeBuffPercentage;
412         castleMinBrick = _castleMinBrick;
413         maxLevel = _maxLevel;
414         maxActiveCastle = _maxActiveCastle;
415         maxRandomRound = _maxRandomRound;
416         minHpDeducted = _minHpDeducted;
417     }
418     
419     function genLevelExp() onlyModerators external {
420         uint8 level = 1;
421         uint32 requirement = 100;
422         uint32 sum = requirement;
423         while(level <= 100) {
424             levelExps[level] = sum;
425             level += 1;
426             requirement = (requirement * 11) / 10 + 5;
427             sum += requirement;
428         }
429     }
430     
431     // public 
432     function getCacheClassSize(uint32 _classId) constant public returns(uint, uint, uint) {
433         CacheClassInfo storage classInfo = cacheClasses[_classId];
434         return (classInfo.types.length, classInfo.steps.length, classInfo.ancestors.length);
435     }
436     
437     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
438         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
439         for (uint8 i = 0; i < index && i < 6; i ++) {
440             genNum /= 256;
441         }
442         return uint8(genNum % maxRan);
443     }
444     
445     function getLevel(uint32 exp) view public returns (uint8) {
446         uint8 minIndex = 1;
447         uint8 maxIndex = 100;
448         uint8 currentIndex;
449      
450         while (minIndex < maxIndex) {
451             currentIndex = (minIndex + maxIndex) / 2;
452             while (minIndex < maxIndex) {
453                 currentIndex = (minIndex + maxIndex) / 2;
454                 if (exp < levelExps[currentIndex])
455                     maxIndex = currentIndex;
456                 else
457                     minIndex = currentIndex + 1;
458             }
459         }
460         return minIndex;
461     }
462     
463     function getGainExp(uint32 _exp1, uint32 _exp2, bool _win) view public returns(uint32){
464         uint8 level = getLevel(_exp2);
465         uint8 level2 = getLevel(_exp1);
466         uint8 halfLevel1 = level;
467         if (level > level2 + 3) {
468             halfLevel1 = (level2 + 3) / 2;
469         } else {
470             halfLevel1 = level / 2;
471         }
472         uint32 gainExp = 1;
473         uint256 rate = (21 ** uint256(halfLevel1)) * 1000 / (20 ** uint256(halfLevel1));
474         rate = rate * rate;
475         if ((level > level2 + 3 && level2 + 3 > 2 * halfLevel1) || (level <= level2 + 3 && level > 2 * halfLevel1)) rate = rate * 21 / 20;
476         if (_win) {
477             gainExp = uint32(30 * rate / 1000000);
478         } else {
479             gainExp = uint32(10 * rate / 1000000);
480         }
481         
482         if (level2 >= level + 5) {
483             gainExp /= uint32(2) ** ((level2 - level) / 5);
484         }
485         return gainExp;
486     }
487     
488     function getMonsterLevel(uint64 _objId) constant external returns(uint32, uint8) {
489         EtheremonDataBase data = EtheremonDataBase(dataContract);
490         MonsterObjAcc memory obj;
491         uint32 _ = 0;
492         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
493      
494         return (obj.exp, getLevel(obj.exp));
495     }
496     
497     function getMonsterCP(uint64 _objId) constant external returns(uint64) {
498         uint16[6] memory stats;
499         uint32 classId = 0;
500         uint32 exp = 0;
501         (classId, exp, stats) = getCurrentStats(_objId);
502         
503         uint256 total;
504         for(uint i=0; i < STAT_COUNT; i+=1) {
505             total += stats[i];
506         }
507         return uint64(total/STAT_COUNT);
508     }
509     
510     function isOnBattle(uint64 _objId) constant external returns(bool) {
511         EtheremonDataBase data = EtheremonDataBase(dataContract);
512         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
513         uint32 castleId;
514         uint castleIndex = 0;
515         uint256 price = 0;
516         MonsterObjAcc memory obj;
517         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
518         (castleId, castleIndex, price) = castle.getCastleBasicInfo(obj.trainer);
519         if (castleId > 0 && castleIndex > 0)
520             return castle.isOnCastle(castleId, _objId);
521         return false;
522     }
523     
524     function isValidOwner(uint64 _objId, address _owner) constant public returns(bool) {
525         EtheremonDataBase data = EtheremonDataBase(dataContract);
526         MonsterObjAcc memory obj;
527         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
528         return (obj.trainer == _owner && obj.classId != 21);
529     }
530     
531     function getObjExp(uint64 _objId) constant public returns(uint32, uint32) {
532         EtheremonDataBase data = EtheremonDataBase(dataContract);
533         MonsterObjAcc memory obj;
534         uint32 _ = 0;
535         (_objId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
536         return (obj.classId, obj.exp);
537     }
538     
539     function getCurrentStats(uint64 _objId) constant public returns(uint32, uint32, uint16[6]){
540         EtheremonDataBase data = EtheremonDataBase(dataContract);
541         uint16[6] memory stats;
542         uint32 classId;
543         uint32 exp;
544         (classId, exp) = getObjExp(_objId);
545         if (classId == 0)
546             return (classId, exp, stats);
547         
548         uint i = 0;
549         uint8 level = getLevel(exp);
550         for(i=0; i < STAT_COUNT; i+=1) {
551             stats[i] = data.getElementInArrayType(ArrayType.STAT_BASE, _objId, i);
552         }
553         for(i=0; i < cacheClasses[classId].steps.length; i++) {
554             stats[i] += uint16(safeMult(cacheClasses[classId].steps[i], level*3));
555         }
556         return (classId, exp, stats);
557     }
558     
559     function safeDeduct(uint16 a, uint16 b) pure private returns(uint16){
560         if (a > b) {
561             return a - b;
562         }
563         return 0;
564     }
565     
566     function calHpDeducted(uint16 _attack, uint16 _specialAttack, uint16 _defense, uint16 _specialDefense, bool _lucky) view public returns(uint16){
567         if (_lucky) {
568             _attack = _attack * 13 / 10;
569             _specialAttack = _specialAttack * 13 / 10;
570         }
571         uint16 hpDeducted = safeDeduct(_attack, _defense * 3 /4);
572         uint16 hpSpecialDeducted = safeDeduct(_specialAttack, _specialDefense* 3 / 4);
573         if (hpDeducted < minHpDeducted && hpSpecialDeducted < minHpDeducted)
574             return minHpDeducted;
575         if (hpDeducted > hpSpecialDeducted)
576             return hpDeducted;
577         return hpSpecialDeducted;
578     }
579     
580     function getAncestorBuff(uint32 _classId, SupporterData _support) constant private returns(uint16){
581         // check ancestors
582         uint i =0;
583         uint8 countEffect = 0;
584         uint ancestorSize = cacheClasses[_classId].ancestors.length;
585         if (ancestorSize > 0) {
586             uint32 ancestorClass = 0;
587             for (i=0; i < ancestorSize; i ++) {
588                 ancestorClass = cacheClasses[_classId].ancestors[i];
589                 if (ancestorClass == _support.classId1 || ancestorClass == _support.classId2 || ancestorClass == _support.classId3) {
590                     countEffect += 1;
591                 }
592             }
593         }
594         return countEffect * ancestorBuffPercentage;
595     }
596     
597     function getGasonSupport(uint32 _classId, SupporterData _sup) constant private returns(uint16 defenseSupport) {
598         uint i = 0;
599         uint8 classType = 0;
600         defenseSupport = 0;
601         for (i = 0; i < cacheClasses[_classId].types.length; i++) {
602             classType = cacheClasses[_classId].types[i];
603              if (_sup.isGason1) {
604                 if (classType == _sup.type1) {
605                     defenseSupport += gasonBuffPercentage;
606                     continue;
607                 }
608             }
609             if (_sup.isGason2) {
610                 if (classType == _sup.type2) {
611                     defenseSupport += gasonBuffPercentage;
612                     continue;
613                 }
614             }
615             if (_sup.isGason3) {
616                 if (classType == _sup.type3) {
617                     defenseSupport += gasonBuffPercentage;
618                     continue;
619                 }
620             }
621         }
622     }
623     
624     function getTypeSupport(uint32 _aClassId, uint32 _bClassId) constant private returns (uint16 aAttackSupport, uint16 bAttackSupport) {
625         // check types 
626         bool aHasAdvantage;
627         bool bHasAdvantage;
628         for (uint i = 0; i < cacheClasses[_aClassId].types.length; i++) {
629             for (uint j = 0; j < cacheClasses[_bClassId].types.length; j++) {
630                 if (typeAdvantages[cacheClasses[_aClassId].types[i]] == cacheClasses[_bClassId].types[j]) {
631                     aHasAdvantage = true;
632                 }
633                 if (typeAdvantages[cacheClasses[_bClassId].types[j]] == cacheClasses[_aClassId].types[i]) {
634                     bHasAdvantage = true;
635                 }
636             }
637         }
638         
639         if (aHasAdvantage)
640             aAttackSupport += typeBuffPercentage;
641         if (bHasAdvantage)
642             bAttackSupport += typeBuffPercentage;
643     }
644     
645     function calculateBattleStats(AttackData att) constant private returns(uint32 aExp, uint16[6] aStats, uint32 bExp, uint16[6] bStats) {
646         uint32 aClassId = 0;
647         (aClassId, aExp, aStats) = getCurrentStats(att.aa);
648         uint32 bClassId = 0;
649         (bClassId, bExp, bStats) = getCurrentStats(att.ba);
650         
651         // check gasonsupport
652         (att.aAttackSupport, att.bAttackSupport) = getTypeSupport(aClassId, bClassId);
653         att.aAttackSupport += getAncestorBuff(aClassId, att.asup);
654         att.bAttackSupport += getAncestorBuff(bClassId, att.bsup);
655         
656         uint16 aDefenseBuff = getGasonSupport(aClassId, att.asup);
657         uint16 bDefenseBuff = getGasonSupport(bClassId, att.bsup);
658         
659         // add attack
660         aStats[1] += aStats[1] * att.aAttackSupport / 100;
661         aStats[3] += aStats[3] * att.aAttackSupport / 100;
662         bStats[1] += bStats[1] * att.bAttackSupport / 100;
663         bStats[3] += bStats[3] * att.bAttackSupport / 100;
664         
665         // add offense
666         aStats[2] += aStats[2] * aDefenseBuff / 100;
667         aStats[4] += aStats[4] * aDefenseBuff / 100;
668         bStats[2] += bStats[2] * bDefenseBuff / 100;
669         bStats[4] += bStats[4] * bDefenseBuff / 100;
670         
671     }
672     
673     function attack(AttackData att) constant private returns(uint32 aExp, uint32 bExp, uint8 ran, bool win) {
674         uint16[6] memory aStats;
675         uint16[6] memory bStats;
676         (aExp, aStats, bExp, bStats) = calculateBattleStats(att);
677         
678         ran = getRandom(maxRandomRound+2, att.index, lastAttacker);
679         uint16 round = 0;
680         while (round < maxRandomRound && aStats[0] > 0 && bStats[0] > 0) {
681             if (aStats[5] > bStats[5]) {
682                 if (round % 2 == 0) {
683                     // a attack 
684                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
685                 } else {
686                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
687                 }
688                 
689             } else {
690                 if (round % 2 != 0) {
691                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
692                 } else {
693                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
694                 }
695             }
696             round+= 1;
697         }
698         
699         win = aStats[0] >= bStats[0];
700     }
701     
702     function destroyCastle(uint32 _castleId, bool win) requireCastleContract private returns(uint32){
703         // if castle win, ignore
704         if (win)
705             return 0;
706         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
707         uint32 totalWin;
708         uint32 totalLose;
709         uint32 brickNumber;
710         (totalWin, totalLose, brickNumber) = castle.getCastleWinLose(_castleId);
711         if (brickNumber + totalWin/winBrickReturn <= totalLose + 1) {
712             castle.removeCastleFromActive(_castleId);
713             return brickNumber;
714         }
715         return 0;
716     }
717     
718     function hasValidParam(address trainer, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) constant public returns(bool) {
719         if (_a1 == 0 || _a2 == 0 || _a3 == 0)
720             return false;
721         if (_a1 == _a2 || _a1 == _a3 || _a1 == _s1 || _a1 == _s2 || _a1 == _s3)
722             return false;
723         if (_a2 == _a3 || _a2 == _s1 || _a2 == _s2 || _a2 == _s3)
724             return false;
725         if (_a3 == _s1 || _a3 == _s2 || _a3 == _s3)
726             return false;
727         if (_s1 > 0 && (_s1 == _s2 || _s1 == _s3))
728             return false;
729         if (_s2 > 0 && (_s2 == _s3))
730             return false;
731         
732         if (!isValidOwner(_a1, trainer) || !isValidOwner(_a2, trainer) || !isValidOwner(_a3, trainer))
733             return false;
734         if (_s1 > 0 && !isValidOwner(_s1, trainer))
735             return false;
736         if (_s2 > 0 && !isValidOwner(_s2, trainer))
737             return false;
738         if (_s3 > 0 && !isValidOwner(_s3, trainer))
739             return false;
740         return true;
741     }
742     
743     // public
744     function createCastle(string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract 
745         requireTradeContract requireCastleContract payable external {
746         
747         if (!hasValidParam(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3))
748             revert();
749         
750         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
751         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
752             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
753             revert();
754         
755         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
756         uint32 castleId;
757         uint castleIndex = 0;
758         uint32 numberBrick = 0;
759         (castleId, castleIndex, numberBrick) = castle.getCastleBasicInfo(msg.sender);
760         if (castleId > 0 || castleIndex > 0)
761             revert();
762 
763         if (castle.countActiveCastle() >= uint(maxActiveCastle))
764             revert();
765         numberBrick = uint32(msg.value / brickPrice) + castle.getTrainerBrick(msg.sender);
766         if (numberBrick < castleMinBrick) {
767             revert();
768         }
769         castle.deductTrainerBrick(msg.sender, castle.getTrainerBrick(msg.sender));
770         totalEarn += msg.value;
771         castleId = castle.addCastle(msg.sender, _name, _a1, _a2, _a3, _s1, _s2, _s3, numberBrick);
772         EventCreateCastle(msg.sender, castleId);
773     }
774     
775     function renameCastle(uint32 _castleId, string _name) isActive requireCastleContract external {
776         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
777         uint index;
778         address owner;
779         uint256 price;
780         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
781         if (owner != msg.sender)
782             revert();
783         castle.renameCastle(_castleId, _name);
784     }
785     
786     function removeCastle(uint32 _castleId) isActive requireCastleContract external {
787         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
788         uint index;
789         address owner;
790         uint256 price;
791         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
792         if (owner != msg.sender)
793             revert();
794         if (index > 0) {
795             castle.removeCastleFromActive(_castleId);
796         }
797         EventRemoveCastle(_castleId);
798     }
799     
800     function getSupporterInfo(uint64 s1, uint64 s2, uint64 s3) constant public returns(SupporterData sData) {
801         uint temp;
802         uint32 __;
803         EtheremonGateway gateway = EtheremonGateway(worldContract);
804         if (s1 > 0)
805             (sData.classId1, __, sData.isGason1, temp, temp) = gateway.getObjBattleInfo(s1);
806         if (s2 > 0)
807             (sData.classId2, __, sData.isGason2, temp, temp) = gateway.getObjBattleInfo(s2);
808         if (s3 > 0)
809             (sData.classId3, __, sData.isGason3, temp, temp) = gateway.getObjBattleInfo(s3);
810 
811         EtheremonDataBase data = EtheremonDataBase(dataContract);
812         if (sData.isGason1) {
813             sData.type1 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId1), 0);
814         }
815         
816         if (sData.isGason2) {
817             sData.type2 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId2), 0);
818         }
819         
820         if (sData.isGason3) {
821             sData.type3 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId3), 0);
822         }
823     }
824     
825     function attackCastle(uint32 _castleId, uint64 _aa1, uint64 _aa2, uint64 _aa3, uint64 _as1, uint64 _as2, uint64 _as3) isActive requireDataContract 
826         requireTradeContract requireCastleContract external {
827         if (!hasValidParam(msg.sender, _aa1, _aa2, _aa3, _as1, _as2, _as3))
828             revert();
829         
830         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
831         BattleLogData memory log;
832         (log.castleIndex, log.castleOwner, log.castleBrickBonus) = castle.getCastleBasicInfoById(_castleId);
833         if (log.castleIndex == 0 || log.castleOwner == msg.sender)
834             revert();
835         
836         EtheremonGateway gateway = EtheremonGateway(worldContract);
837         BattleMonsterData memory b;
838         (b.a1, b.a2, b.a3, b.s1, b.s2, b.s3) = castle.getCastleObjInfo(_castleId);
839         lastAttacker = msg.sender;
840 
841         // init data
842         uint8 countWin = 0;
843         AttackData memory att;
844         att.asup = getSupporterInfo(b.s1, b.s2, b.s3);
845         att.bsup = getSupporterInfo(_as1, _as2, _as3);
846         
847         att.index = 0;
848         att.aa = b.a1;
849         att.ba = _aa1;
850         (log.monsterExp[0], log.monsterExp[3], log.randoms[0], log.win) = attack(att);
851         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[0], log.monsterExp[3], log.win));
852         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[3], log.monsterExp[0], !log.win));
853         if (log.win)
854             countWin += 1;
855         
856         
857         att.index = 1;
858         att.aa = b.a2;
859         att.ba = _aa2;
860         (log.monsterExp[1], log.monsterExp[4], log.randoms[1], log.win) = attack(att);
861         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[1], log.monsterExp[4], log.win));
862         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[4], log.monsterExp[1], !log.win));
863         if (log.win)
864             countWin += 1;   
865 
866         att.index = 2;
867         att.aa = b.a3;
868         att.ba = _aa3;
869         (log.monsterExp[2], log.monsterExp[5], log.randoms[2], log.win) = attack(att);
870         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterExp[2], log.monsterExp[5], log.win));
871         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterExp[5], log.monsterExp[2], !log.win));
872         if (log.win)
873             countWin += 1; 
874         
875         
876         log.castleBrickBonus = destroyCastle(_castleId, countWin>1);
877         if (countWin>1) {
878             log.result = BattleResult.CASTLE_WIN;
879         } else {
880             if (log.castleBrickBonus > 0) {
881                 log.result = BattleResult.CASTLE_DESTROYED;
882             } else {
883                 log.result = BattleResult.CASTLE_LOSE;
884             }
885         }
886         
887         log.battleId = castle.addBattleLog(_castleId, msg.sender, log.randoms[0], log.randoms[1], log.randoms[2], 
888             uint8(log.result), log.monsterExp[0], log.monsterExp[1], log.monsterExp[2]);
889         
890         castle.addBattleLogMonsterInfo(log.battleId, _aa1, _aa2, _aa3, _as1, _as2, _as3, log.monsterExp[3], log.monsterExp[4], log.monsterExp[5]);
891     
892         EventAttackCastle(msg.sender, _castleId, uint8(log.result));
893     }
894     
895 }