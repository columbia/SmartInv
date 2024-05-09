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
304     uint8 public castleExpAdjustment = 150; // percentage
305     uint8 public castleMaxLevelGap = 5;
306     uint public brickETHPrice = 0.004 ether;
307     uint8 public minHpDeducted = 10;
308     uint public winTokenReward = 10 ** 8;
309     
310     uint256 public totalEarn = 0;
311     uint256 public totalWithdraw = 0;
312     
313     address private lastAttacker = address(0x0);
314     
315     // modifier
316     modifier requireDataContract {
317         require(dataContract != address(0));
318         _;
319     }
320     
321     modifier requireTradeContract {
322         require(tradeContract != address(0));
323         _;
324     }
325     
326     modifier requireCastleContract {
327         require(castleContract != address(0));
328         _;
329     }
330     
331     modifier requireWorldContract {
332         require(worldContract != address(0));
333         _;
334     }
335     
336     modifier requirePaymentContract {
337         require(paymentContract != address(0));
338         _;
339     }
340 
341 
342     function EtheremonBattle(address _dataContract, address _worldContract, address _tradeContract, address _castleContract, address _paymentContract) public {
343         dataContract = _dataContract;
344         worldContract = _worldContract;
345         tradeContract = _tradeContract;
346         castleContract = _castleContract;
347         paymentContract = _paymentContract;
348     }
349     
350      // admin & moderators
351     function setTypeAdvantages() onlyModerators external {
352         typeAdvantages[1] = 14;
353         typeAdvantages[2] = 16;
354         typeAdvantages[3] = 8;
355         typeAdvantages[4] = 9;
356         typeAdvantages[5] = 2;
357         typeAdvantages[6] = 11;
358         typeAdvantages[7] = 3;
359         typeAdvantages[8] = 5;
360         typeAdvantages[9] = 15;
361         typeAdvantages[11] = 18;
362         // skipp 10
363         typeAdvantages[12] = 7;
364         typeAdvantages[13] = 6;
365         typeAdvantages[14] = 17;
366         typeAdvantages[15] = 13;
367         typeAdvantages[16] = 12;
368         typeAdvantages[17] = 1;
369         typeAdvantages[18] = 4;
370     }
371     
372     function setTypeAdvantage(uint8 _type1, uint8 _type2) onlyModerators external {
373         typeAdvantages[_type1] = _type2;
374     }
375     
376     function setCacheClassInfo(uint32 _classId) onlyModerators requireDataContract requireWorldContract public {
377         EtheremonDataBase data = EtheremonDataBase(dataContract);
378          EtheremonGateway gateway = EtheremonGateway(worldContract);
379         uint i = 0;
380         CacheClassInfo storage classInfo = cacheClasses[_classId];
381 
382         // add type
383         i = data.getSizeArrayType(ArrayType.CLASS_TYPE, uint64(_classId));
384         uint8[] memory aTypes = new uint8[](i);
385         for(; i > 0 ; i--) {
386             aTypes[i-1] = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(_classId), i-1);
387         }
388         classInfo.types = aTypes;
389 
390         // add steps
391         i = data.getSizeArrayType(ArrayType.STAT_STEP, uint64(_classId));
392         uint8[] memory steps = new uint8[](i);
393         for(; i > 0 ; i--) {
394             steps[i-1] = data.getElementInArrayType(ArrayType.STAT_STEP, uint64(_classId), i-1);
395         }
396         classInfo.steps = steps;
397         
398         // add ancestor
399         i = gateway.getClassPropertySize(_classId, PropertyType.ANCESTOR);
400         uint32[] memory ancestors = new uint32[](i);
401         for(; i > 0 ; i--) {
402             ancestors[i-1] = gateway.getClassPropertyValue(_classId, PropertyType.ANCESTOR, i-1);
403         }
404         classInfo.ancestors = ancestors;
405     }
406     
407     function fastSetCacheClassInfo(uint32 _classId1, uint32 _classId2, uint32 _classId3, uint32 _classId4, uint32 _classId5, uint32 _classId6, uint32 _classId7, uint32 _classId8) 
408         onlyModerators requireDataContract requireWorldContract public {
409         setCacheClassInfo(_classId1);
410         setCacheClassInfo(_classId2);
411         setCacheClassInfo(_classId3);
412         setCacheClassInfo(_classId4);
413         setCacheClassInfo(_classId5);
414         setCacheClassInfo(_classId6);
415         setCacheClassInfo(_classId7);
416         setCacheClassInfo(_classId8);
417     }    
418      
419     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
420         if (_amount > this.balance) {
421             revert();
422         }
423         uint256 validAmount = safeSubtract(totalEarn, totalWithdraw);
424         if (_amount > validAmount) {
425             revert();
426         }
427         totalWithdraw += _amount;
428         _sendTo.transfer(_amount);
429     }
430     
431     function setContract(address _dataContract, address _worldContract, address _tradeContract, address _castleContract, address _paymentContract) onlyModerators external {
432         dataContract = _dataContract;
433         worldContract = _worldContract;
434         tradeContract = _tradeContract;
435         castleContract = _castleContract;
436         paymentContract = _paymentContract;
437     }
438     
439     function setConfig(uint8 _ancestorBuffPercentage, uint8 _gasonBuffPercentage, uint8 _typeBuffPercentage, 
440         uint8 _maxLevel, uint8 _maxRandomRound, uint8 _minHpDeducted, uint _winTokenReward) onlyModerators external{
441         ancestorBuffPercentage = _ancestorBuffPercentage;
442         gasonBuffPercentage = _gasonBuffPercentage;
443         typeBuffPercentage = _typeBuffPercentage;
444         maxLevel = _maxLevel;
445         maxRandomRound = _maxRandomRound;
446         minHpDeducted = _minHpDeducted;
447         winTokenReward = _winTokenReward;
448     }
449     
450     function setCastleConfig(uint8 _castleMaxLevelGap, uint16 _maxActiveCastle, uint _brickETHPrice, uint8 _castleExpAdjustment, uint32 _castleMinBrick) onlyModerators external {
451         castleMaxLevelGap = _castleMaxLevelGap;
452         maxActiveCastle = _maxActiveCastle;
453         brickETHPrice = _brickETHPrice;
454         castleExpAdjustment = _castleExpAdjustment;
455         castleMinBrick = _castleMinBrick;
456     }
457     
458     function genLevelExp() onlyModerators external {
459         uint8 level = 1;
460         uint32 requirement = 100;
461         uint32 sum = requirement;
462         while(level <= 100) {
463             levelExps[level] = sum;
464             level += 1;
465             requirement = (requirement * 11) / 10 + 5;
466             sum += requirement;
467         }
468     }
469     
470     // public 
471     function getCacheClassSize(uint32 _classId) constant public returns(uint, uint, uint) {
472         CacheClassInfo storage classInfo = cacheClasses[_classId];
473         return (classInfo.types.length, classInfo.steps.length, classInfo.ancestors.length);
474     }
475     
476     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
477         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
478         for (uint8 i = 0; i < index && i < 6; i ++) {
479             genNum /= 256;
480         }
481         return uint8(genNum % maxRan);
482     }
483     
484     function getLevel(uint32 exp) view public returns (uint8) {
485         uint8 minIndex = 1;
486         uint8 maxIndex = 100;
487         uint8 currentIndex;
488      
489         while (minIndex < maxIndex) {
490             currentIndex = (minIndex + maxIndex) / 2;
491             if (exp < levelExps[currentIndex])
492                 maxIndex = currentIndex;
493             else
494                 minIndex = currentIndex + 1;
495         }
496 
497         return minIndex;
498     }
499     
500     function getGainExp(uint8 level2, uint8 level, bool _win) pure public returns(uint32){
501         uint8 halfLevel1 = level;
502         if (level > level2 + 3) {
503             halfLevel1 = (level2 + 3) / 2;
504         } else {
505             halfLevel1 = level / 2;
506         }
507         uint32 gainExp = 1;
508         uint256 rate = (21 ** uint256(halfLevel1)) * 1000 / (20 ** uint256(halfLevel1));
509         rate = rate * rate;
510         if ((level > level2 + 3 && level2 + 3 > 2 * halfLevel1) || (level <= level2 + 3 && level > 2 * halfLevel1)) rate = rate * 21 / 20;
511         if (_win) {
512             gainExp = uint32(30 * rate / 1000000);
513         } else {
514             gainExp = uint32(10 * rate / 1000000);
515         }
516         
517         if (level2 >= level + 5) {
518             gainExp /= uint32(2) ** ((level2 - level) / 5);
519         }
520         return gainExp;
521     }
522     
523     function getMonsterLevel(uint64 _objId) constant external returns(uint32, uint8) {
524         EtheremonDataBase data = EtheremonDataBase(dataContract);
525         MonsterObjAcc memory obj;
526         uint32 _ = 0;
527         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
528      
529         return (obj.exp, getLevel(obj.exp));
530     }
531     
532     function getMonsterCP(uint64 _objId) constant external returns(uint64) {
533         uint16[6] memory stats;
534         uint32 classId = 0;
535         uint32 exp = 0;
536         (classId, exp, stats) = getCurrentStats(_objId);
537         
538         uint256 total;
539         for(uint i=0; i < STAT_COUNT; i+=1) {
540             total += stats[i];
541         }
542         return uint64(total/STAT_COUNT);
543     }
544     
545     function isOnBattle(uint64 _objId) constant external returns(bool) {
546         EtheremonDataBase data = EtheremonDataBase(dataContract);
547         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
548         uint32 castleId;
549         uint castleIndex = 0;
550         uint256 price = 0;
551         MonsterObjAcc memory obj;
552         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
553         (castleId, castleIndex, price) = castle.getCastleBasicInfo(obj.trainer);
554         if (castleId > 0 && castleIndex > 0)
555             return castle.isOnCastle(castleId, _objId);
556         return false;
557     }
558     
559     function isValidOwner(uint64 _objId, address _owner) constant public returns(bool) {
560         EtheremonDataBase data = EtheremonDataBase(dataContract);
561         MonsterObjAcc memory obj;
562         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
563         return (obj.trainer == _owner && obj.classId != 21);
564     }
565     
566     function getObjExp(uint64 _objId) constant public returns(uint32, uint32) {
567         EtheremonDataBase data = EtheremonDataBase(dataContract);
568         MonsterObjAcc memory obj;
569         uint32 _ = 0;
570         (_objId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
571         return (obj.classId, obj.exp);
572     }
573     
574     function getCurrentStats(uint64 _objId) constant public returns(uint32, uint8, uint16[6]){
575         EtheremonDataBase data = EtheremonDataBase(dataContract);
576         uint16[6] memory stats;
577         uint32 classId;
578         uint32 exp;
579         (classId, exp) = getObjExp(_objId);
580         if (classId == 0)
581             return (classId, 0, stats);
582         
583         uint i = 0;
584         uint8 level = getLevel(exp);
585         for(i=0; i < STAT_COUNT; i+=1) {
586             stats[i] = data.getElementInArrayType(ArrayType.STAT_BASE, _objId, i);
587         }
588         for(i=0; i < cacheClasses[classId].steps.length; i++) {
589             stats[i] += uint16(safeMult(cacheClasses[classId].steps[i], level*3));
590         }
591         return (classId, level, stats);
592     }
593     
594     function safeDeduct(uint16 a, uint16 b) pure private returns(uint16){
595         if (a > b) {
596             return a - b;
597         }
598         return 0;
599     }
600     
601     function calHpDeducted(uint16 _attack, uint16 _specialAttack, uint16 _defense, uint16 _specialDefense, bool _lucky) view public returns(uint16){
602         if (_lucky) {
603             _attack = _attack * 13 / 10;
604             _specialAttack = _specialAttack * 13 / 10;
605         }
606         uint16 hpDeducted = safeDeduct(_attack, _defense * 3 /4);
607         uint16 hpSpecialDeducted = safeDeduct(_specialAttack, _specialDefense* 3 / 4);
608         if (hpDeducted < minHpDeducted && hpSpecialDeducted < minHpDeducted)
609             return minHpDeducted;
610         if (hpDeducted > hpSpecialDeducted)
611             return hpDeducted;
612         return hpSpecialDeducted;
613     }
614     
615     function getAncestorBuff(uint32 _classId, SupporterData _support) constant private returns(uint16){
616         // check ancestors
617         uint i =0;
618         uint8 countEffect = 0;
619         uint ancestorSize = cacheClasses[_classId].ancestors.length;
620         if (ancestorSize > 0) {
621             uint32 ancestorClass = 0;
622             for (i=0; i < ancestorSize; i ++) {
623                 ancestorClass = cacheClasses[_classId].ancestors[i];
624                 if (ancestorClass == _support.classId1 || ancestorClass == _support.classId2 || ancestorClass == _support.classId3) {
625                     countEffect += 1;
626                 }
627             }
628         }
629         return countEffect * ancestorBuffPercentage;
630     }
631     
632     function getGasonSupport(uint32 _classId, SupporterData _sup) constant private returns(uint16 defenseSupport) {
633         uint i = 0;
634         uint8 classType = 0;
635         defenseSupport = 0;
636         for (i = 0; i < cacheClasses[_classId].types.length; i++) {
637             classType = cacheClasses[_classId].types[i];
638              if (_sup.isGason1) {
639                 if (classType == _sup.type1) {
640                     defenseSupport += gasonBuffPercentage;
641                     continue;
642                 }
643             }
644             if (_sup.isGason2) {
645                 if (classType == _sup.type2) {
646                     defenseSupport += gasonBuffPercentage;
647                     continue;
648                 }
649             }
650             if (_sup.isGason3) {
651                 if (classType == _sup.type3) {
652                     defenseSupport += gasonBuffPercentage;
653                     continue;
654                 }
655             }
656         }
657     }
658     
659     function getTypeSupport(uint32 _aClassId, uint32 _bClassId) constant private returns (uint16 aAttackSupport, uint16 bAttackSupport) {
660         // check types 
661         bool aHasAdvantage;
662         bool bHasAdvantage;
663         for (uint i = 0; i < cacheClasses[_aClassId].types.length; i++) {
664             for (uint j = 0; j < cacheClasses[_bClassId].types.length; j++) {
665                 if (typeAdvantages[cacheClasses[_aClassId].types[i]] == cacheClasses[_bClassId].types[j]) {
666                     aHasAdvantage = true;
667                 }
668                 if (typeAdvantages[cacheClasses[_bClassId].types[j]] == cacheClasses[_aClassId].types[i]) {
669                     bHasAdvantage = true;
670                 }
671             }
672         }
673         
674         if (aHasAdvantage)
675             aAttackSupport += typeBuffPercentage;
676         if (bHasAdvantage)
677             bAttackSupport += typeBuffPercentage;
678     }
679     
680     function calculateBattleStats(AttackData att) constant private returns(uint8 aLevel, uint16[6] aStats, uint8 bLevel, uint16[6] bStats) {
681         uint32 aClassId = 0;
682         (aClassId, aLevel, aStats) = getCurrentStats(att.aa);
683         uint32 bClassId = 0;
684         (bClassId, bLevel, bStats) = getCurrentStats(att.ba);
685         
686         // check gasonsupport
687         (att.aAttackSupport, att.bAttackSupport) = getTypeSupport(aClassId, bClassId);
688         att.aAttackSupport += getAncestorBuff(aClassId, att.asup);
689         att.bAttackSupport += getAncestorBuff(bClassId, att.bsup);
690         
691         uint16 aDefenseBuff = getGasonSupport(aClassId, att.asup);
692         uint16 bDefenseBuff = getGasonSupport(bClassId, att.bsup);
693         
694         // add attack
695         aStats[1] += aStats[1] * att.aAttackSupport / 100;
696         aStats[3] += aStats[3] * att.aAttackSupport / 100;
697         bStats[1] += bStats[1] * att.bAttackSupport / 100;
698         bStats[3] += bStats[3] * att.bAttackSupport / 100;
699         
700         // add offense
701         aStats[2] += aStats[2] * aDefenseBuff / 100;
702         aStats[4] += aStats[4] * aDefenseBuff / 100;
703         bStats[2] += bStats[2] * bDefenseBuff / 100;
704         bStats[4] += bStats[4] * bDefenseBuff / 100;
705         
706     }
707     
708     function attack(AttackData att) constant private returns(uint8 aLevel, uint8 bLevel, uint8 ran, bool win) {
709         uint16[6] memory aStats;
710         uint16[6] memory bStats;
711         (aLevel, aStats, bLevel, bStats) = calculateBattleStats(att);
712         
713         ran = getRandom(maxRandomRound+2, att.index, lastAttacker);
714         uint16 round = 0;
715         while (round < maxRandomRound && aStats[0] > 0 && bStats[0] > 0) {
716             if (aStats[5] > bStats[5]) {
717                 if (round % 2 == 0) {
718                     // a attack 
719                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
720                 } else {
721                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
722                 }
723                 
724             } else {
725                 if (round % 2 != 0) {
726                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
727                 } else {
728                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
729                 }
730             }
731             round+= 1;
732         }
733         
734         win = aStats[0] >= bStats[0];
735     }
736     
737     function updateCastle(uint32 _castleId, address _castleOwner, bool win) requireCastleContract private{
738         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
739         uint32 totalWin;
740         uint32 totalLose;
741         uint32 brickNumber;
742         (totalWin, totalLose, brickNumber) = castle.getCastleWinLose(_castleId);
743         EtheremonPaymentInterface payment = EtheremonPaymentInterface(paymentContract);
744         
745         // if castle win, ignore
746         if (win) {
747             if (totalWin < brickNumber) {
748                  payment.giveBattleBonus(_castleOwner, winTokenReward);
749             }
750         } else {
751             if (totalWin/winBrickReturn > brickNumber) {
752                 brickNumber = 2 * brickNumber;
753             } else {
754                 brickNumber += totalWin/winBrickReturn;
755             }
756             if (brickNumber <= totalLose + 1) {
757                 castle.removeCastleFromActive(_castleId);
758                 // destroy
759             }
760             payment.giveBattleBonus(msg.sender, winTokenReward);
761         }
762     }
763     
764     function hasValidParam(address _trainer, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) constant public returns(bool) {
765         if (_a1 == 0 || _a2 == 0 || _a3 == 0)
766             return false;
767         if (_a1 == _a2 || _a1 == _a3 || _a1 == _s1 || _a1 == _s2 || _a1 == _s3)
768             return false;
769         if (_a2 == _a3 || _a2 == _s1 || _a2 == _s2 || _a2 == _s3)
770             return false;
771         if (_a3 == _s1 || _a3 == _s2 || _a3 == _s3)
772             return false;
773         if (_s1 > 0 && (_s1 == _s2 || _s1 == _s3))
774             return false;
775         if (_s2 > 0 && (_s2 == _s3))
776             return false;
777         
778         if (!isValidOwner(_a1, _trainer) || !isValidOwner(_a2, _trainer) || !isValidOwner(_a3, _trainer))
779             return false;
780         if (_s1 > 0 && !isValidOwner(_s1, _trainer))
781             return false;
782         if (_s2 > 0 && !isValidOwner(_s2, _trainer))
783             return false;
784         if (_s3 > 0 && !isValidOwner(_s3, _trainer))
785             return false;
786         return true;
787     }
788     
789     function createCastleInternal(CastleData _castleData) private {
790         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
791         uint32 castleId;
792         uint castleIndex = 0;
793         uint32 numberBrick = 0;
794         (castleId, castleIndex, numberBrick) = castle.getCastleBasicInfo(_castleData.trainer);
795         if (castleId > 0 || castleIndex > 0)
796             revert();
797 
798         if (castle.countActiveCastle() >= uint(maxActiveCastle))
799             revert();
800         castleId = castle.addCastle(_castleData.trainer, _castleData.name, _castleData.a1, _castleData.a2, _castleData.a3, 
801             _castleData.s1, _castleData.s2, _castleData.s3, _castleData.brickNumber);
802         EventCreateCastle(_castleData.trainer, castleId);
803     }
804     
805     // public
806     
807     function createCastle(string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract 
808         requireTradeContract requireCastleContract payable external {
809         
810         if (!hasValidParam(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3))
811             revert();
812         
813         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
814         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
815             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
816             revert();
817         
818         uint32 numberBrick = uint32(msg.value / brickETHPrice);
819         if (numberBrick < castleMinBrick) {
820             revert();
821         }
822         
823         CastleData memory castleData;
824         castleData.trainer = msg.sender;
825         castleData.name = _name;
826         castleData.brickNumber = numberBrick;
827         castleData.a1 = _a1;
828         castleData.a2 = _a2;
829         castleData.a3 = _a3;
830         castleData.s1 = _s1;
831         castleData.s2 = _s2;
832         castleData.s3 = _s3;
833         createCastleInternal(castleData);
834         totalEarn += msg.value;
835     }
836     
837     function createCastleWithToken(address _trainer, uint32 _noBrick, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract
838         requireTradeContract requireCastleContract requirePaymentContract external {
839         // only accept request from payment contract
840         if (msg.sender != paymentContract)
841             revert();
842     
843         if (!hasValidParam(_trainer, _a1, _a2, _a3, _s1, _s2, _s3))
844             revert();
845         
846         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
847         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
848             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
849             revert();
850         
851         if (_noBrick < castleMinBrick) {
852             revert();
853         }
854         
855         CastleData memory castleData;
856         castleData.trainer = _trainer;
857         castleData.name = _name;
858         castleData.brickNumber = _noBrick;
859         castleData.a1 = _a1;
860         castleData.a2 = _a2;
861         castleData.a3 = _a3;
862         castleData.s1 = _s1;
863         castleData.s2 = _s2;
864         castleData.s3 = _s3;
865         createCastleInternal(castleData);
866     }
867     
868     function renameCastle(uint32 _castleId, string _name) isActive requireCastleContract external {
869         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
870         uint index;
871         address owner;
872         uint256 price;
873         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
874         if (owner != msg.sender)
875             revert();
876         castle.renameCastle(_castleId, _name);
877     }
878     
879     function removeCastle(uint32 _castleId) isActive requireCastleContract external {
880         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
881         uint index;
882         address owner;
883         uint256 price;
884         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
885         if (owner != msg.sender)
886             revert();
887         if (index > 0) {
888             castle.removeCastleFromActive(_castleId);
889         }
890         EventRemoveCastle(_castleId);
891     }
892     
893     function getSupporterInfo(uint64 s1, uint64 s2, uint64 s3) constant public returns(SupporterData sData) {
894         uint temp;
895         uint32 __;
896         EtheremonGateway gateway = EtheremonGateway(worldContract);
897         if (s1 > 0)
898             (sData.classId1, __, sData.isGason1, temp, temp) = gateway.getObjBattleInfo(s1);
899         if (s2 > 0)
900             (sData.classId2, __, sData.isGason2, temp, temp) = gateway.getObjBattleInfo(s2);
901         if (s3 > 0)
902             (sData.classId3, __, sData.isGason3, temp, temp) = gateway.getObjBattleInfo(s3);
903 
904         EtheremonDataBase data = EtheremonDataBase(dataContract);
905         if (sData.isGason1) {
906             sData.type1 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId1), 0);
907         }
908         
909         if (sData.isGason2) {
910             sData.type2 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId2), 0);
911         }
912         
913         if (sData.isGason3) {
914             sData.type3 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId3), 0);
915         }
916     }
917     
918     function attackCastle(uint32 _castleId, uint64 _aa1, uint64 _aa2, uint64 _aa3, uint64 _as1, uint64 _as2, uint64 _as3) isActive requireDataContract 
919         requireTradeContract requireCastleContract requirePaymentContract external {
920         if (!hasValidParam(msg.sender, _aa1, _aa2, _aa3, _as1, _as2, _as3))
921             revert();
922         
923         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
924         BattleLogData memory log;
925         (log.castleIndex, log.castleOwner, log.temp[0]) = castle.getCastleBasicInfoById(_castleId);
926         if (log.castleIndex == 0 || log.castleOwner == msg.sender)
927             revert();
928         
929         EtheremonGateway gateway = EtheremonGateway(worldContract);
930         BattleMonsterData memory b;
931         (b.a1, b.a2, b.a3, b.s1, b.s2, b.s3) = castle.getCastleObjInfo(_castleId);
932         lastAttacker = msg.sender;
933 
934         // init data
935         uint8 countWin = 0;
936         AttackData memory att;
937         att.asup = getSupporterInfo(b.s1, b.s2, b.s3);
938         att.bsup = getSupporterInfo(_as1, _as2, _as3);
939         
940         att.index = 0;
941         att.aa = b.a1;
942         att.ba = _aa1;
943         (log.monsterLevel[0], log.monsterLevel[3], log.randoms[0], log.win) = attack(att);
944         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterLevel[0], log.monsterLevel[3], log.win)*castleExpAdjustment/100);
945         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterLevel[3], log.monsterLevel[0], !log.win));
946         if (log.win)
947             countWin += 1;
948         
949         
950         att.index = 1;
951         att.aa = b.a2;
952         att.ba = _aa2;
953         (log.monsterLevel[1], log.monsterLevel[4], log.randoms[1], log.win) = attack(att);
954         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterLevel[1], log.monsterLevel[4], log.win)*castleExpAdjustment/100);
955         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterLevel[4], log.monsterLevel[1], !log.win));
956         if (log.win)
957             countWin += 1;   
958 
959         att.index = 2;
960         att.aa = b.a3;
961         att.ba = _aa3;
962         (log.monsterLevel[2], log.monsterLevel[5], log.randoms[2], log.win) = attack(att);
963         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterLevel[2], log.monsterLevel[5], log.win)*castleExpAdjustment/100);
964         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterLevel[5], log.monsterLevel[2], !log.win));
965         if (log.win)
966             countWin += 1; 
967         
968         if ((log.monsterLevel[0] + log.monsterLevel[1] + log.monsterLevel[2])/3 + castleMaxLevelGap < (log.monsterLevel[3] + log.monsterLevel[4] + log.monsterLevel[5])/3)
969             revert();
970         
971         updateCastle(_castleId, log.castleOwner, countWin>1);
972         if (countWin>1) {
973             log.result = BattleResult.CASTLE_WIN;
974         } else {
975             log.result = BattleResult.CASTLE_LOSE;
976         }
977         
978         log.temp[0] = levelExps[log.monsterLevel[0]]-1;
979         log.temp[1] = levelExps[log.monsterLevel[1]]-1;
980         log.temp[2] = levelExps[log.monsterLevel[2]]-1;
981         log.battleId = castle.addBattleLog(_castleId, msg.sender, log.randoms[0], log.randoms[1], log.randoms[2], 
982             uint8(log.result), log.temp[0], log.temp[1], log.temp[2]);
983         
984         log.temp[0] = levelExps[log.monsterLevel[3]]-1;
985         log.temp[1] = levelExps[log.monsterLevel[4]]-1;
986         log.temp[2] = levelExps[log.monsterLevel[5]]-1;
987         castle.addBattleLogMonsterInfo(log.battleId, _aa1, _aa2, _aa3, _as1, _as2, _as3, log.temp[0], log.temp[1], log.temp[2]);
988     
989         EventAttackCastle(msg.sender, _castleId, uint8(log.result));
990     }
991     
992 }