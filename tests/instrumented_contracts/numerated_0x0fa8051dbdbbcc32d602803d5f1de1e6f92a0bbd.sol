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
147 interface EtheremonPaymentInterface {
148     function giveBattleBonus(address _trainer, uint _amount) public; 
149 }
150 
151 contract EtheremonGateway is EtheremonEnum, BasicAccessControl {
152     // using for battle contract later
153     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
154     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
155     
156     // read 
157     function isGason(uint64 _objId) constant external returns(bool);
158     function getObjBattleInfo(uint64 _objId) constant external returns(uint32 classId, uint32 exp, bool isGason, 
159         uint ancestorLength, uint xfactorsLength);
160     function getClassPropertySize(uint32 _classId, PropertyType _type) constant external returns(uint);
161     function getClassPropertyValue(uint32 _classId, PropertyType _type, uint index) constant external returns(uint32);
162 }
163 
164 contract EtheremonCastleContract is EtheremonEnum, BasicAccessControl{
165 
166     uint32 public totalCastle = 0;
167     uint64 public totalBattle = 0;
168     
169     function getCastleBasicInfo(address _owner) constant external returns(uint32, uint, uint32);
170     function getCastleBasicInfoById(uint32 _castleId) constant external returns(uint, address, uint32);
171     function countActiveCastle() constant external returns(uint);
172     function getCastleObjInfo(uint32 _castleId) constant external returns(uint64, uint64, uint64, uint64, uint64, uint64);
173     function getCastleStats(uint32 _castleId) constant external returns(string, address, uint32, uint32, uint32, uint);
174     function isOnCastle(uint32 _castleId, uint64 _objId) constant external returns(bool);
175     function getCastleWinLose(uint32 _castleId) constant external returns(uint32, uint32, uint32);
176     function getTrainerBrick(address _trainer) constant external returns(uint32);
177 
178     function addCastle(address _trainer, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3, uint32 _brickNumber) 
179         onlyModerators external returns(uint32 currentCastleId);
180     function renameCastle(uint32 _castleId, string _name) onlyModerators external;
181     function removeCastleFromActive(uint32 _castleId) onlyModerators external;
182     function deductTrainerBrick(address _trainer, uint32 _deductAmount) onlyModerators external returns(bool);
183     
184     function addBattleLog(uint32 _castleId, address _attacker, 
185         uint8 _ran1, uint8 _ran2, uint8 _ran3, uint8 _result, uint32 _castleExp1, uint32 _castleExp2, uint32 _castleExp3) onlyModerators external returns(uint64);
186     function addBattleLogMonsterInfo(uint64 _battleId, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3, uint32 _exp1, uint32 _exp2, uint32 _exp3) onlyModerators external;
187 }
188 
189 contract EtheremonBattle is EtheremonEnum, BasicAccessControl, SafeMath {
190     uint8 constant public NO_MONSTER = 3;
191     uint8 constant public STAT_COUNT = 6;
192     uint8 constant public GEN0_NO = 24;
193     
194     struct MonsterClassAcc {
195         uint32 classId;
196         uint256 price;
197         uint256 returnPrice;
198         uint32 total;
199         bool catchable;
200     }
201 
202     struct MonsterObjAcc {
203         uint64 monsterId;
204         uint32 classId;
205         address trainer;
206         string name;
207         uint32 exp;
208         uint32 createIndex;
209         uint32 lastClaimIndex;
210         uint createTime;
211     }
212     
213     struct BattleMonsterData {
214         uint64 a1;
215         uint64 a2;
216         uint64 a3;
217         uint64 s1;
218         uint64 s2;
219         uint64 s3;
220     }
221 
222     struct SupporterData {
223         uint32 classId1;
224         bool isGason1;
225         uint8 type1;
226         uint32 classId2;
227         bool isGason2;
228         uint8 type2;
229         uint32 classId3;
230         bool isGason3;
231         uint8 type3;
232     }
233 
234     struct AttackData {
235         uint64 aa;
236         SupporterData asup;
237         uint16 aAttackSupport;
238         uint64 ba;
239         SupporterData bsup;
240         uint16 bAttackSupport;
241         uint8 index;
242     }
243     
244     struct MonsterBattleLog {
245         uint64 objId;
246         uint32 exp;
247     }
248     
249     struct BattleLogData {
250         address castleOwner;
251         uint64 battleId;
252         uint32 castleId;
253         uint32[3] temp;
254         uint castleIndex;
255         uint8[6] monsterLevel;
256         uint8[3] randoms;
257         bool win;
258         BattleResult result;
259     }
260     
261     struct CacheClassInfo {
262         uint8[] types;
263         uint8[] steps;
264         uint32[] ancestors;
265     }
266     
267     struct CastleData {
268         address trainer;
269         string name;
270         uint32 brickNumber;
271         uint64 a1;
272         uint64 a2;
273         uint64 a3;
274         uint64 s1;
275         uint64 s2;
276         uint64 s3;
277     }
278 
279     // event
280     event EventCreateCastle(address indexed owner, uint32 castleId);
281     event EventAttackCastle(address indexed attacker, uint32 castleId, uint8 result);
282     event EventRemoveCastle(uint32 indexed castleId);
283     
284     // linked smart contract
285     address public worldContract;
286     address public dataContract;
287     address public tradeContract;
288     address public castleContract;
289     address public paymentContract;
290     
291     // global variable
292     mapping(uint8 => uint8) typeAdvantages;
293     mapping(uint32 => CacheClassInfo) cacheClasses;
294     mapping(uint8 => uint32) levelExps;
295     uint8 public ancestorBuffPercentage = 10;
296     uint8 public gasonBuffPercentage = 10;
297     uint8 public typeBuffPercentage = 20;
298     uint8 public maxLevel = 100;
299     uint16 public maxActiveCastle = 30;
300     uint8 public maxRandomRound = 4;
301     
302     uint8 public winBrickReturn = 8;
303     uint32 public castleMinBrick = 5;
304     uint8 public castleExpAdjustment = 100; // percentage
305     uint public brickETHPrice = 0.004 ether;
306     uint8 public minHpDeducted = 10;
307     uint public winTokenReward = 10 ** 8;
308     
309     uint256 public totalEarn = 0;
310     uint256 public totalWithdraw = 0;
311     
312     address private lastAttacker = address(0x0);
313     
314     // modifier
315     modifier requireDataContract {
316         require(dataContract != address(0));
317         _;
318     }
319     
320     modifier requireTradeContract {
321         require(tradeContract != address(0));
322         _;
323     }
324     
325     modifier requireCastleContract {
326         require(castleContract != address(0));
327         _;
328     }
329     
330     modifier requireWorldContract {
331         require(worldContract != address(0));
332         _;
333     }
334     
335     modifier requirePaymentContract {
336         require(paymentContract != address(0));
337         _;
338     }
339 
340 
341     function EtheremonBattle(address _dataContract, address _worldContract, address _tradeContract, address _castleContract, address _paymentContract) public {
342         dataContract = _dataContract;
343         worldContract = _worldContract;
344         tradeContract = _tradeContract;
345         castleContract = _castleContract;
346         paymentContract = _paymentContract;
347     }
348     
349      // admin & moderators
350     function setTypeAdvantages() onlyModerators external {
351         typeAdvantages[1] = 14;
352         typeAdvantages[2] = 16;
353         typeAdvantages[3] = 8;
354         typeAdvantages[4] = 9;
355         typeAdvantages[5] = 2;
356         typeAdvantages[6] = 11;
357         typeAdvantages[7] = 3;
358         typeAdvantages[8] = 5;
359         typeAdvantages[9] = 15;
360         typeAdvantages[11] = 18;
361         // skipp 10
362         typeAdvantages[12] = 7;
363         typeAdvantages[13] = 6;
364         typeAdvantages[14] = 17;
365         typeAdvantages[15] = 13;
366         typeAdvantages[16] = 12;
367         typeAdvantages[17] = 1;
368         typeAdvantages[18] = 4;
369     }
370     
371     function setTypeAdvantage(uint8 _type1, uint8 _type2) onlyModerators external {
372         typeAdvantages[_type1] = _type2;
373     }
374     
375     function setCacheClassInfo(uint32 _classId) onlyModerators requireDataContract requireWorldContract public {
376         EtheremonDataBase data = EtheremonDataBase(dataContract);
377          EtheremonGateway gateway = EtheremonGateway(worldContract);
378         uint i = 0;
379         CacheClassInfo storage classInfo = cacheClasses[_classId];
380 
381         // add type
382         i = data.getSizeArrayType(ArrayType.CLASS_TYPE, uint64(_classId));
383         uint8[] memory aTypes = new uint8[](i);
384         for(; i > 0 ; i--) {
385             aTypes[i-1] = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(_classId), i-1);
386         }
387         classInfo.types = aTypes;
388 
389         // add steps
390         i = data.getSizeArrayType(ArrayType.STAT_STEP, uint64(_classId));
391         uint8[] memory steps = new uint8[](i);
392         for(; i > 0 ; i--) {
393             steps[i-1] = data.getElementInArrayType(ArrayType.STAT_STEP, uint64(_classId), i-1);
394         }
395         classInfo.steps = steps;
396         
397         // add ancestor
398         i = gateway.getClassPropertySize(_classId, PropertyType.ANCESTOR);
399         uint32[] memory ancestors = new uint32[](i);
400         for(; i > 0 ; i--) {
401             ancestors[i-1] = gateway.getClassPropertyValue(_classId, PropertyType.ANCESTOR, i-1);
402         }
403         classInfo.ancestors = ancestors;
404     }
405     
406     function fastSetCacheClassInfo(uint32 _classId1, uint32 _classId2, uint32 _classId3, uint32 _classId4, uint32 _classId5, uint32 _classId6, uint32 _classId7, uint32 _classId8) 
407         onlyModerators requireDataContract requireWorldContract public {
408         setCacheClassInfo(_classId1);
409         setCacheClassInfo(_classId2);
410         setCacheClassInfo(_classId3);
411         setCacheClassInfo(_classId4);
412         setCacheClassInfo(_classId5);
413         setCacheClassInfo(_classId6);
414         setCacheClassInfo(_classId7);
415         setCacheClassInfo(_classId8);
416     }    
417      
418     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
419         if (_amount > this.balance) {
420             revert();
421         }
422         uint256 validAmount = safeSubtract(totalEarn, totalWithdraw);
423         if (_amount > validAmount) {
424             revert();
425         }
426         totalWithdraw += _amount;
427         _sendTo.transfer(_amount);
428     }
429     
430     function setContract(address _dataContract, address _worldContract, address _tradeContract, address _castleContract, address _paymentContract) onlyModerators external {
431         dataContract = _dataContract;
432         worldContract = _worldContract;
433         tradeContract = _tradeContract;
434         castleContract = _castleContract;
435         paymentContract = _paymentContract;
436     }
437     
438     function setConfig(uint8 _ancestorBuffPercentage, uint8 _gasonBuffPercentage, uint8 _typeBuffPercentage, uint32 _castleMinBrick, 
439         uint8 _maxLevel, uint16 _maxActiveCastle, uint8 _maxRandomRound, uint8 _minHpDeducted, uint _winTokenReward, uint _brickETHPrice, uint8 _castleExpAdjustment) onlyModerators external{
440         ancestorBuffPercentage = _ancestorBuffPercentage;
441         gasonBuffPercentage = _gasonBuffPercentage;
442         typeBuffPercentage = _typeBuffPercentage;
443         castleMinBrick = _castleMinBrick;
444         maxLevel = _maxLevel;
445         maxActiveCastle = _maxActiveCastle;
446         maxRandomRound = _maxRandomRound;
447         minHpDeducted = _minHpDeducted;
448         winTokenReward = _winTokenReward;
449         brickETHPrice = _brickETHPrice;
450         castleExpAdjustment = _castleExpAdjustment;
451     }
452     
453     function genLevelExp() onlyModerators external {
454         uint8 level = 1;
455         uint32 requirement = 100;
456         uint32 sum = requirement;
457         while(level <= 100) {
458             levelExps[level] = sum;
459             level += 1;
460             requirement = (requirement * 11) / 10 + 5;
461             sum += requirement;
462         }
463     }
464     
465     // public 
466     function getCacheClassSize(uint32 _classId) constant public returns(uint, uint, uint) {
467         CacheClassInfo storage classInfo = cacheClasses[_classId];
468         return (classInfo.types.length, classInfo.steps.length, classInfo.ancestors.length);
469     }
470     
471     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
472         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
473         for (uint8 i = 0; i < index && i < 6; i ++) {
474             genNum /= 256;
475         }
476         return uint8(genNum % maxRan);
477     }
478     
479     function getLevel(uint32 exp) view public returns (uint8) {
480         uint8 minIndex = 1;
481         uint8 maxIndex = 100;
482         uint8 currentIndex;
483      
484         while (minIndex < maxIndex) {
485             currentIndex = (minIndex + maxIndex) / 2;
486             if (exp < levelExps[currentIndex])
487                 maxIndex = currentIndex;
488             else
489                 minIndex = currentIndex + 1;
490         }
491 
492         return minIndex;
493     }
494     
495     function getGainExp(uint8 level2, uint8 level, bool _win) pure public returns(uint32){
496         uint8 halfLevel1 = level;
497         if (level > level2 + 3) {
498             halfLevel1 = (level2 + 3) / 2;
499         } else {
500             halfLevel1 = level / 2;
501         }
502         uint32 gainExp = 1;
503         uint256 rate = (21 ** uint256(halfLevel1)) * 1000 / (20 ** uint256(halfLevel1));
504         rate = rate * rate;
505         if ((level > level2 + 3 && level2 + 3 > 2 * halfLevel1) || (level <= level2 + 3 && level > 2 * halfLevel1)) rate = rate * 21 / 20;
506         if (_win) {
507             gainExp = uint32(30 * rate / 1000000);
508         } else {
509             gainExp = uint32(10 * rate / 1000000);
510         }
511         
512         if (level2 >= level + 5) {
513             gainExp /= uint32(2) ** ((level2 - level) / 5);
514         }
515         return gainExp;
516     }
517     
518     function getMonsterLevel(uint64 _objId) constant external returns(uint32, uint8) {
519         EtheremonDataBase data = EtheremonDataBase(dataContract);
520         MonsterObjAcc memory obj;
521         uint32 _ = 0;
522         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
523      
524         return (obj.exp, getLevel(obj.exp));
525     }
526     
527     function getMonsterCP(uint64 _objId) constant external returns(uint64) {
528         uint16[6] memory stats;
529         uint32 classId = 0;
530         uint32 exp = 0;
531         (classId, exp, stats) = getCurrentStats(_objId);
532         
533         uint256 total;
534         for(uint i=0; i < STAT_COUNT; i+=1) {
535             total += stats[i];
536         }
537         return uint64(total/STAT_COUNT);
538     }
539     
540     function isOnBattle(uint64 _objId) constant external returns(bool) {
541         EtheremonDataBase data = EtheremonDataBase(dataContract);
542         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
543         uint32 castleId;
544         uint castleIndex = 0;
545         uint256 price = 0;
546         MonsterObjAcc memory obj;
547         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
548         (castleId, castleIndex, price) = castle.getCastleBasicInfo(obj.trainer);
549         if (castleId > 0 && castleIndex > 0)
550             return castle.isOnCastle(castleId, _objId);
551         return false;
552     }
553     
554     function isValidOwner(uint64 _objId, address _owner) constant public returns(bool) {
555         EtheremonDataBase data = EtheremonDataBase(dataContract);
556         MonsterObjAcc memory obj;
557         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
558         return (obj.trainer == _owner && obj.classId != 21);
559     }
560     
561     function getObjExp(uint64 _objId) constant public returns(uint32, uint32) {
562         EtheremonDataBase data = EtheremonDataBase(dataContract);
563         MonsterObjAcc memory obj;
564         uint32 _ = 0;
565         (_objId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
566         return (obj.classId, obj.exp);
567     }
568     
569     function getCurrentStats(uint64 _objId) constant public returns(uint32, uint8, uint16[6]){
570         EtheremonDataBase data = EtheremonDataBase(dataContract);
571         uint16[6] memory stats;
572         uint32 classId;
573         uint32 exp;
574         (classId, exp) = getObjExp(_objId);
575         if (classId == 0)
576             return (classId, 0, stats);
577         
578         uint i = 0;
579         uint8 level = getLevel(exp);
580         for(i=0; i < STAT_COUNT; i+=1) {
581             stats[i] = data.getElementInArrayType(ArrayType.STAT_BASE, _objId, i);
582         }
583         for(i=0; i < cacheClasses[classId].steps.length; i++) {
584             stats[i] += uint16(safeMult(cacheClasses[classId].steps[i], level*3));
585         }
586         return (classId, level, stats);
587     }
588     
589     function safeDeduct(uint16 a, uint16 b) pure private returns(uint16){
590         if (a > b) {
591             return a - b;
592         }
593         return 0;
594     }
595     
596     function calHpDeducted(uint16 _attack, uint16 _specialAttack, uint16 _defense, uint16 _specialDefense, bool _lucky) view public returns(uint16){
597         if (_lucky) {
598             _attack = _attack * 13 / 10;
599             _specialAttack = _specialAttack * 13 / 10;
600         }
601         uint16 hpDeducted = safeDeduct(_attack, _defense * 3 /4);
602         uint16 hpSpecialDeducted = safeDeduct(_specialAttack, _specialDefense* 3 / 4);
603         if (hpDeducted < minHpDeducted && hpSpecialDeducted < minHpDeducted)
604             return minHpDeducted;
605         if (hpDeducted > hpSpecialDeducted)
606             return hpDeducted;
607         return hpSpecialDeducted;
608     }
609     
610     function getAncestorBuff(uint32 _classId, SupporterData _support) constant private returns(uint16){
611         // check ancestors
612         uint i =0;
613         uint8 countEffect = 0;
614         uint ancestorSize = cacheClasses[_classId].ancestors.length;
615         if (ancestorSize > 0) {
616             uint32 ancestorClass = 0;
617             for (i=0; i < ancestorSize; i ++) {
618                 ancestorClass = cacheClasses[_classId].ancestors[i];
619                 if (ancestorClass == _support.classId1 || ancestorClass == _support.classId2 || ancestorClass == _support.classId3) {
620                     countEffect += 1;
621                 }
622             }
623         }
624         return countEffect * ancestorBuffPercentage;
625     }
626     
627     function getGasonSupport(uint32 _classId, SupporterData _sup) constant private returns(uint16 defenseSupport) {
628         uint i = 0;
629         uint8 classType = 0;
630         defenseSupport = 0;
631         for (i = 0; i < cacheClasses[_classId].types.length; i++) {
632             classType = cacheClasses[_classId].types[i];
633              if (_sup.isGason1) {
634                 if (classType == _sup.type1) {
635                     defenseSupport += gasonBuffPercentage;
636                     continue;
637                 }
638             }
639             if (_sup.isGason2) {
640                 if (classType == _sup.type2) {
641                     defenseSupport += gasonBuffPercentage;
642                     continue;
643                 }
644             }
645             if (_sup.isGason3) {
646                 if (classType == _sup.type3) {
647                     defenseSupport += gasonBuffPercentage;
648                     continue;
649                 }
650             }
651         }
652     }
653     
654     function getTypeSupport(uint32 _aClassId, uint32 _bClassId) constant private returns (uint16 aAttackSupport, uint16 bAttackSupport) {
655         // check types 
656         bool aHasAdvantage;
657         bool bHasAdvantage;
658         for (uint i = 0; i < cacheClasses[_aClassId].types.length; i++) {
659             for (uint j = 0; j < cacheClasses[_bClassId].types.length; j++) {
660                 if (typeAdvantages[cacheClasses[_aClassId].types[i]] == cacheClasses[_bClassId].types[j]) {
661                     aHasAdvantage = true;
662                 }
663                 if (typeAdvantages[cacheClasses[_bClassId].types[j]] == cacheClasses[_aClassId].types[i]) {
664                     bHasAdvantage = true;
665                 }
666             }
667         }
668         
669         if (aHasAdvantage)
670             aAttackSupport += typeBuffPercentage;
671         if (bHasAdvantage)
672             bAttackSupport += typeBuffPercentage;
673     }
674     
675     function calculateBattleStats(AttackData att) constant private returns(uint8 aLevel, uint16[6] aStats, uint8 bLevel, uint16[6] bStats) {
676         uint32 aClassId = 0;
677         (aClassId, aLevel, aStats) = getCurrentStats(att.aa);
678         uint32 bClassId = 0;
679         (bClassId, bLevel, bStats) = getCurrentStats(att.ba);
680         
681         // check gasonsupport
682         (att.aAttackSupport, att.bAttackSupport) = getTypeSupport(aClassId, bClassId);
683         att.aAttackSupport += getAncestorBuff(aClassId, att.asup);
684         att.bAttackSupport += getAncestorBuff(bClassId, att.bsup);
685         
686         uint16 aDefenseBuff = getGasonSupport(aClassId, att.asup);
687         uint16 bDefenseBuff = getGasonSupport(bClassId, att.bsup);
688         
689         // add attack
690         aStats[1] += aStats[1] * att.aAttackSupport / 100;
691         aStats[3] += aStats[3] * att.aAttackSupport / 100;
692         bStats[1] += bStats[1] * att.bAttackSupport / 100;
693         bStats[3] += bStats[3] * att.bAttackSupport / 100;
694         
695         // add offense
696         aStats[2] += aStats[2] * aDefenseBuff / 100;
697         aStats[4] += aStats[4] * aDefenseBuff / 100;
698         bStats[2] += bStats[2] * bDefenseBuff / 100;
699         bStats[4] += bStats[4] * bDefenseBuff / 100;
700         
701     }
702     
703     function attack(AttackData att) constant private returns(uint8 aLevel, uint8 bLevel, uint8 ran, bool win) {
704         uint16[6] memory aStats;
705         uint16[6] memory bStats;
706         (aLevel, aStats, bLevel, bStats) = calculateBattleStats(att);
707         
708         ran = getRandom(maxRandomRound+2, att.index, lastAttacker);
709         uint16 round = 0;
710         while (round < maxRandomRound && aStats[0] > 0 && bStats[0] > 0) {
711             if (aStats[5] > bStats[5]) {
712                 if (round % 2 == 0) {
713                     // a attack 
714                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
715                 } else {
716                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
717                 }
718                 
719             } else {
720                 if (round % 2 != 0) {
721                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
722                 } else {
723                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
724                 }
725             }
726             round+= 1;
727         }
728         
729         win = aStats[0] >= bStats[0];
730     }
731     
732     function updateCastle(uint32 _castleId, address _castleOwner, bool win) requireCastleContract private{
733         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
734         uint32 totalWin;
735         uint32 totalLose;
736         uint32 brickNumber;
737         (totalWin, totalLose, brickNumber) = castle.getCastleWinLose(_castleId);
738         EtheremonPaymentInterface payment = EtheremonPaymentInterface(paymentContract);
739         
740         // if castle win, ignore
741         if (win) {
742             if (totalWin < brickNumber) {
743                  payment.giveBattleBonus(_castleOwner, winTokenReward);
744             }
745         } else {
746             if (totalWin/winBrickReturn > brickNumber) {
747                 brickNumber = 2 * brickNumber;
748             } else {
749                 brickNumber += totalWin/winBrickReturn;
750             }
751             if (brickNumber <= totalLose + 1) {
752                 castle.removeCastleFromActive(_castleId);
753                 // destroy
754             }
755             payment.giveBattleBonus(msg.sender, winTokenReward);
756         }
757     }
758     
759     function hasValidParam(address _trainer, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) constant public returns(bool) {
760         if (_a1 == 0 || _a2 == 0 || _a3 == 0)
761             return false;
762         if (_a1 == _a2 || _a1 == _a3 || _a1 == _s1 || _a1 == _s2 || _a1 == _s3)
763             return false;
764         if (_a2 == _a3 || _a2 == _s1 || _a2 == _s2 || _a2 == _s3)
765             return false;
766         if (_a3 == _s1 || _a3 == _s2 || _a3 == _s3)
767             return false;
768         if (_s1 > 0 && (_s1 == _s2 || _s1 == _s3))
769             return false;
770         if (_s2 > 0 && (_s2 == _s3))
771             return false;
772         
773         if (!isValidOwner(_a1, _trainer) || !isValidOwner(_a2, _trainer) || !isValidOwner(_a3, _trainer))
774             return false;
775         if (_s1 > 0 && !isValidOwner(_s1, _trainer))
776             return false;
777         if (_s2 > 0 && !isValidOwner(_s2, _trainer))
778             return false;
779         if (_s3 > 0 && !isValidOwner(_s3, _trainer))
780             return false;
781         return true;
782     }
783     
784     function createCastleInternal(CastleData _castleData) private {
785         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
786         uint32 castleId;
787         uint castleIndex = 0;
788         uint32 numberBrick = 0;
789         (castleId, castleIndex, numberBrick) = castle.getCastleBasicInfo(_castleData.trainer);
790         if (castleId > 0 || castleIndex > 0)
791             revert();
792 
793         if (castle.countActiveCastle() >= uint(maxActiveCastle))
794             revert();
795         castleId = castle.addCastle(_castleData.trainer, _castleData.name, _castleData.a1, _castleData.a2, _castleData.a3, 
796             _castleData.s1, _castleData.s2, _castleData.s3, _castleData.brickNumber);
797         EventCreateCastle(_castleData.trainer, castleId);
798     }
799     
800     // public
801     
802     function createCastle(string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract 
803         requireTradeContract requireCastleContract payable external {
804         
805         if (!hasValidParam(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3))
806             revert();
807         
808         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
809         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
810             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
811             revert();
812         
813         uint32 numberBrick = uint32(msg.value / brickETHPrice);
814         if (numberBrick < castleMinBrick) {
815             revert();
816         }
817         
818         CastleData memory castleData;
819         castleData.trainer = msg.sender;
820         castleData.name = _name;
821         castleData.brickNumber = numberBrick;
822         castleData.a1 = _a1;
823         castleData.a2 = _a2;
824         castleData.a3 = _a3;
825         castleData.s1 = _s1;
826         castleData.s2 = _s2;
827         castleData.s3 = _s3;
828         createCastleInternal(castleData);
829         totalEarn += msg.value;
830     }
831     
832     function createCastleWithToken(address _trainer, uint32 _noBrick, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract
833         requireTradeContract requireCastleContract requirePaymentContract external {
834         // only accept request from payment contract
835         if (msg.sender != paymentContract)
836             revert();
837     
838         if (!hasValidParam(_trainer, _a1, _a2, _a3, _s1, _s2, _s3))
839             revert();
840         
841         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
842         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
843             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
844             revert();
845         
846         if (_noBrick < castleMinBrick) {
847             revert();
848         }
849         
850         CastleData memory castleData;
851         castleData.trainer = _trainer;
852         castleData.name = _name;
853         castleData.brickNumber = _noBrick;
854         castleData.a1 = _a1;
855         castleData.a2 = _a2;
856         castleData.a3 = _a3;
857         castleData.s1 = _s1;
858         castleData.s2 = _s2;
859         castleData.s3 = _s3;
860         createCastleInternal(castleData);
861     }
862     
863     function renameCastle(uint32 _castleId, string _name) isActive requireCastleContract external {
864         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
865         uint index;
866         address owner;
867         uint256 price;
868         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
869         if (owner != msg.sender)
870             revert();
871         castle.renameCastle(_castleId, _name);
872     }
873     
874     function removeCastle(uint32 _castleId) isActive requireCastleContract external {
875         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
876         uint index;
877         address owner;
878         uint256 price;
879         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
880         if (owner != msg.sender)
881             revert();
882         if (index > 0) {
883             castle.removeCastleFromActive(_castleId);
884         }
885         EventRemoveCastle(_castleId);
886     }
887     
888     function getSupporterInfo(uint64 s1, uint64 s2, uint64 s3) constant public returns(SupporterData sData) {
889         uint temp;
890         uint32 __;
891         EtheremonGateway gateway = EtheremonGateway(worldContract);
892         if (s1 > 0)
893             (sData.classId1, __, sData.isGason1, temp, temp) = gateway.getObjBattleInfo(s1);
894         if (s2 > 0)
895             (sData.classId2, __, sData.isGason2, temp, temp) = gateway.getObjBattleInfo(s2);
896         if (s3 > 0)
897             (sData.classId3, __, sData.isGason3, temp, temp) = gateway.getObjBattleInfo(s3);
898 
899         EtheremonDataBase data = EtheremonDataBase(dataContract);
900         if (sData.isGason1) {
901             sData.type1 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId1), 0);
902         }
903         
904         if (sData.isGason2) {
905             sData.type2 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId2), 0);
906         }
907         
908         if (sData.isGason3) {
909             sData.type3 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId3), 0);
910         }
911     }
912     
913     function attackCastle(uint32 _castleId, uint64 _aa1, uint64 _aa2, uint64 _aa3, uint64 _as1, uint64 _as2, uint64 _as3) isActive requireDataContract 
914         requireTradeContract requireCastleContract requirePaymentContract external {
915         if (!hasValidParam(msg.sender, _aa1, _aa2, _aa3, _as1, _as2, _as3))
916             revert();
917         
918         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
919         BattleLogData memory log;
920         (log.castleIndex, log.castleOwner, log.temp[0]) = castle.getCastleBasicInfoById(_castleId);
921         if (log.castleIndex == 0 || log.castleOwner == msg.sender)
922             revert();
923         
924         EtheremonGateway gateway = EtheremonGateway(worldContract);
925         BattleMonsterData memory b;
926         (b.a1, b.a2, b.a3, b.s1, b.s2, b.s3) = castle.getCastleObjInfo(_castleId);
927         lastAttacker = msg.sender;
928 
929         // init data
930         uint8 countWin = 0;
931         AttackData memory att;
932         att.asup = getSupporterInfo(b.s1, b.s2, b.s3);
933         att.bsup = getSupporterInfo(_as1, _as2, _as3);
934         
935         att.index = 0;
936         att.aa = b.a1;
937         att.ba = _aa1;
938         (log.monsterLevel[0], log.monsterLevel[3], log.randoms[0], log.win) = attack(att);
939         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterLevel[0], log.monsterLevel[3], log.win)*castleExpAdjustment/100);
940         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterLevel[3], log.monsterLevel[0], !log.win));
941         if (log.win)
942             countWin += 1;
943         
944         
945         att.index = 1;
946         att.aa = b.a2;
947         att.ba = _aa2;
948         (log.monsterLevel[1], log.monsterLevel[4], log.randoms[1], log.win) = attack(att);
949         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterLevel[1], log.monsterLevel[4], log.win)*castleExpAdjustment/100);
950         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterLevel[4], log.monsterLevel[1], !log.win));
951         if (log.win)
952             countWin += 1;   
953 
954         att.index = 2;
955         att.aa = b.a3;
956         att.ba = _aa3;
957         (log.monsterLevel[2], log.monsterLevel[5], log.randoms[2], log.win) = attack(att);
958         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterLevel[2], log.monsterLevel[5], log.win)*castleExpAdjustment/100);
959         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterLevel[5], log.monsterLevel[2], !log.win));
960         if (log.win)
961             countWin += 1; 
962         
963         
964         updateCastle(_castleId, log.castleOwner, countWin>1);
965         if (countWin>1) {
966             log.result = BattleResult.CASTLE_WIN;
967         } else {
968             log.result = BattleResult.CASTLE_LOSE;
969         }
970         
971         log.temp[0] = levelExps[log.monsterLevel[0]]-1;
972         log.temp[1] = levelExps[log.monsterLevel[1]]-1;
973         log.temp[2] = levelExps[log.monsterLevel[2]]-1;
974         log.battleId = castle.addBattleLog(_castleId, msg.sender, log.randoms[0], log.randoms[1], log.randoms[2], 
975             uint8(log.result), log.temp[0], log.temp[1], log.temp[2]);
976         
977         log.temp[0] = levelExps[log.monsterLevel[3]]-1;
978         log.temp[1] = levelExps[log.monsterLevel[4]]-1;
979         log.temp[2] = levelExps[log.monsterLevel[5]]-1;
980         castle.addBattleLogMonsterInfo(log.battleId, _aa1, _aa2, _aa3, _as1, _as2, _as3, log.temp[0], log.temp[1], log.temp[2]);
981     
982         EventAttackCastle(msg.sender, _castleId, uint8(log.result));
983     }
984     
985 }