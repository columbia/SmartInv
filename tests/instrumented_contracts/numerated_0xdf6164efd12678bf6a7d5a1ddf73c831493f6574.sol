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
305     uint8 public attackerExpAdjustment = 50; // percentage
306     uint8 public levelExpAdjustment = 3; // level
307     uint8 public castleMaxLevelGap = 5;
308     uint public brickETHPrice = 0.004 ether;
309     uint8 public minHpDeducted = 10;
310     uint public winTokenReward = 10 ** 8;
311     
312     uint256 public totalEarn = 0;
313     uint256 public totalWithdraw = 0;
314     
315     address private lastAttacker = address(0x0);
316     
317     // modifier
318     modifier requireDataContract {
319         require(dataContract != address(0));
320         _;
321     }
322     
323     modifier requireTradeContract {
324         require(tradeContract != address(0));
325         _;
326     }
327     
328     modifier requireCastleContract {
329         require(castleContract != address(0));
330         _;
331     }
332     
333     modifier requireWorldContract {
334         require(worldContract != address(0));
335         _;
336     }
337     
338     modifier requirePaymentContract {
339         require(paymentContract != address(0));
340         _;
341     }
342 
343 
344     function EtheremonBattle(address _dataContract, address _worldContract, address _tradeContract, address _castleContract, address _paymentContract) public {
345         dataContract = _dataContract;
346         worldContract = _worldContract;
347         tradeContract = _tradeContract;
348         castleContract = _castleContract;
349         paymentContract = _paymentContract;
350     }
351     
352      // admin & moderators
353     function setTypeAdvantages() onlyModerators external {
354         typeAdvantages[1] = 14;
355         typeAdvantages[2] = 16;
356         typeAdvantages[3] = 8;
357         typeAdvantages[4] = 9;
358         typeAdvantages[5] = 2;
359         typeAdvantages[6] = 11;
360         typeAdvantages[7] = 3;
361         typeAdvantages[8] = 5;
362         typeAdvantages[9] = 15;
363         typeAdvantages[11] = 18;
364         // skipp 10
365         typeAdvantages[12] = 7;
366         typeAdvantages[13] = 6;
367         typeAdvantages[14] = 17;
368         typeAdvantages[15] = 13;
369         typeAdvantages[16] = 12;
370         typeAdvantages[17] = 1;
371         typeAdvantages[18] = 4;
372     }
373     
374     function setTypeAdvantage(uint8 _type1, uint8 _type2) onlyModerators external {
375         typeAdvantages[_type1] = _type2;
376     }
377     
378     function setCacheClassInfo(uint32 _classId) onlyModerators requireDataContract requireWorldContract public {
379         EtheremonDataBase data = EtheremonDataBase(dataContract);
380          EtheremonGateway gateway = EtheremonGateway(worldContract);
381         uint i = 0;
382         CacheClassInfo storage classInfo = cacheClasses[_classId];
383 
384         // add type
385         i = data.getSizeArrayType(ArrayType.CLASS_TYPE, uint64(_classId));
386         uint8[] memory aTypes = new uint8[](i);
387         for(; i > 0 ; i--) {
388             aTypes[i-1] = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(_classId), i-1);
389         }
390         classInfo.types = aTypes;
391 
392         // add steps
393         i = data.getSizeArrayType(ArrayType.STAT_STEP, uint64(_classId));
394         uint8[] memory steps = new uint8[](i);
395         for(; i > 0 ; i--) {
396             steps[i-1] = data.getElementInArrayType(ArrayType.STAT_STEP, uint64(_classId), i-1);
397         }
398         classInfo.steps = steps;
399         
400         // add ancestor
401         i = gateway.getClassPropertySize(_classId, PropertyType.ANCESTOR);
402         uint32[] memory ancestors = new uint32[](i);
403         for(; i > 0 ; i--) {
404             ancestors[i-1] = gateway.getClassPropertyValue(_classId, PropertyType.ANCESTOR, i-1);
405         }
406         classInfo.ancestors = ancestors;
407     }
408     
409     function fastSetCacheClassInfo(uint32 _classId1, uint32 _classId2, uint32 _classId3, uint32 _classId4, uint32 _classId5, uint32 _classId6, uint32 _classId7, uint32 _classId8) 
410         onlyModerators requireDataContract requireWorldContract public {
411         setCacheClassInfo(_classId1);
412         setCacheClassInfo(_classId2);
413         setCacheClassInfo(_classId3);
414         setCacheClassInfo(_classId4);
415         setCacheClassInfo(_classId5);
416         setCacheClassInfo(_classId6);
417         setCacheClassInfo(_classId7);
418         setCacheClassInfo(_classId8);
419     }    
420      
421     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
422         if (_amount > this.balance) {
423             revert();
424         }
425         uint256 validAmount = safeSubtract(totalEarn, totalWithdraw);
426         if (_amount > validAmount) {
427             revert();
428         }
429         totalWithdraw += _amount;
430         _sendTo.transfer(_amount);
431     }
432     
433     function setContract(address _dataContract, address _worldContract, address _tradeContract, address _castleContract, address _paymentContract) onlyModerators external {
434         dataContract = _dataContract;
435         worldContract = _worldContract;
436         tradeContract = _tradeContract;
437         castleContract = _castleContract;
438         paymentContract = _paymentContract;
439     }
440     
441     function setConfig(uint8 _ancestorBuffPercentage, uint8 _gasonBuffPercentage, uint8 _typeBuffPercentage, 
442         uint8 _maxLevel, uint8 _maxRandomRound, uint8 _minHpDeducted, uint _winTokenReward) onlyModerators external{
443         ancestorBuffPercentage = _ancestorBuffPercentage;
444         gasonBuffPercentage = _gasonBuffPercentage;
445         typeBuffPercentage = _typeBuffPercentage;
446         maxLevel = _maxLevel;
447         maxRandomRound = _maxRandomRound;
448         minHpDeducted = _minHpDeducted;
449         winTokenReward = _winTokenReward;
450     }
451     
452     function setCastleConfig(uint8 _castleMaxLevelGap, uint16 _maxActiveCastle, uint _brickETHPrice, uint8 _castleExpAdjustment, uint8 _attackerExpAdjustment, uint8 _levelExpAdjustment, uint32 _castleMinBrick) onlyModerators external {
453         castleMaxLevelGap = _castleMaxLevelGap;
454         maxActiveCastle = _maxActiveCastle;
455         brickETHPrice = _brickETHPrice;
456         castleExpAdjustment = _castleExpAdjustment;
457         attackerExpAdjustment = _attackerExpAdjustment;
458         levelExpAdjustment = _levelExpAdjustment;
459         castleMinBrick = _castleMinBrick;
460     }
461     
462     function genLevelExp() onlyModerators external {
463         uint8 level = 1;
464         uint32 requirement = 100;
465         uint32 sum = requirement;
466         while(level <= 100) {
467             levelExps[level] = sum;
468             level += 1;
469             requirement = (requirement * 11) / 10 + 5;
470             sum += requirement;
471         }
472     }
473     
474     // public 
475     function getCacheClassSize(uint32 _classId) constant public returns(uint, uint, uint) {
476         CacheClassInfo storage classInfo = cacheClasses[_classId];
477         return (classInfo.types.length, classInfo.steps.length, classInfo.ancestors.length);
478     }
479     
480     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
481         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
482         for (uint8 i = 0; i < index && i < 6; i ++) {
483             genNum /= 256;
484         }
485         return uint8(genNum % maxRan);
486     }
487     
488     function getLevel(uint32 exp) view public returns (uint8) {
489         uint8 minIndex = 1;
490         uint8 maxIndex = 100;
491         uint8 currentIndex;
492      
493         while (minIndex < maxIndex) {
494             currentIndex = (minIndex + maxIndex) / 2;
495             if (exp < levelExps[currentIndex])
496                 maxIndex = currentIndex;
497             else
498                 minIndex = currentIndex + 1;
499         }
500 
501         return minIndex;
502     }
503     
504     function getGainExp(uint8 level2, uint8 level, bool _win) constant public returns(uint32){
505         uint8 halfLevel1 = level;
506         if (level > level2 + 3) {
507             halfLevel1 = (level2 + 3) / 2;
508         } else {
509             halfLevel1 = level / 2;
510         }
511         uint32 gainExp = 1;
512         uint256 rate = (21 ** uint256(halfLevel1)) * 1000 / (20 ** uint256(halfLevel1));
513         rate = rate * rate;
514         if ((level > level2 + 3 && level2 + 3 > 2 * halfLevel1) || (level <= level2 + 3 && level > 2 * halfLevel1)) rate = rate * 21 / 20;
515         if (_win) {
516             gainExp = uint32(30 * rate / 1000000);
517         } else {
518             gainExp = uint32(10 * rate / 1000000);
519         }
520         
521         if (level2 >= level + levelExpAdjustment) {
522             gainExp /= uint32(2) ** ((level2 - level) / levelExpAdjustment);
523         }
524         return gainExp;
525     }
526     
527     function getMonsterLevel(uint64 _objId) constant external returns(uint32, uint8) {
528         EtheremonDataBase data = EtheremonDataBase(dataContract);
529         MonsterObjAcc memory obj;
530         uint32 _ = 0;
531         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
532      
533         return (obj.exp, getLevel(obj.exp));
534     }
535     
536     function getMonsterCP(uint64 _objId) constant external returns(uint64) {
537         uint16[6] memory stats;
538         uint32 classId = 0;
539         uint32 exp = 0;
540         (classId, exp, stats) = getCurrentStats(_objId);
541         
542         uint256 total;
543         for(uint i=0; i < STAT_COUNT; i+=1) {
544             total += stats[i];
545         }
546         return uint64(total/STAT_COUNT);
547     }
548     
549     function isOnBattle(uint64 _objId) constant external returns(bool) {
550         EtheremonDataBase data = EtheremonDataBase(dataContract);
551         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
552         uint32 castleId;
553         uint castleIndex = 0;
554         uint256 price = 0;
555         MonsterObjAcc memory obj;
556         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
557         (castleId, castleIndex, price) = castle.getCastleBasicInfo(obj.trainer);
558         if (castleId > 0 && castleIndex > 0)
559             return castle.isOnCastle(castleId, _objId);
560         return false;
561     }
562     
563     function isValidOwner(uint64 _objId, address _owner) constant public returns(bool) {
564         EtheremonDataBase data = EtheremonDataBase(dataContract);
565         MonsterObjAcc memory obj;
566         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
567         return (obj.trainer == _owner && obj.classId != 21);
568     }
569     
570     function getObjExp(uint64 _objId) constant public returns(uint32, uint32) {
571         EtheremonDataBase data = EtheremonDataBase(dataContract);
572         MonsterObjAcc memory obj;
573         uint32 _ = 0;
574         (_objId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
575         return (obj.classId, obj.exp);
576     }
577     
578     function getCurrentStats(uint64 _objId) constant public returns(uint32, uint8, uint16[6]){
579         EtheremonDataBase data = EtheremonDataBase(dataContract);
580         uint16[6] memory stats;
581         uint32 classId;
582         uint32 exp;
583         (classId, exp) = getObjExp(_objId);
584         if (classId == 0)
585             return (classId, 0, stats);
586         
587         uint i = 0;
588         uint8 level = getLevel(exp);
589         for(i=0; i < STAT_COUNT; i+=1) {
590             stats[i] = data.getElementInArrayType(ArrayType.STAT_BASE, _objId, i);
591         }
592         for(i=0; i < cacheClasses[classId].steps.length; i++) {
593             stats[i] += uint16(safeMult(cacheClasses[classId].steps[i], level*3));
594         }
595         return (classId, level, stats);
596     }
597     
598     function safeDeduct(uint16 a, uint16 b) pure private returns(uint16){
599         if (a > b) {
600             return a - b;
601         }
602         return 0;
603     }
604     
605     function calHpDeducted(uint16 _attack, uint16 _specialAttack, uint16 _defense, uint16 _specialDefense, bool _lucky) view public returns(uint16){
606         if (_lucky) {
607             _attack = _attack * 13 / 10;
608             _specialAttack = _specialAttack * 13 / 10;
609         }
610         uint16 hpDeducted = safeDeduct(_attack, _defense * 3 /4);
611         uint16 hpSpecialDeducted = safeDeduct(_specialAttack, _specialDefense* 3 / 4);
612         if (hpDeducted < minHpDeducted && hpSpecialDeducted < minHpDeducted)
613             return minHpDeducted;
614         if (hpDeducted > hpSpecialDeducted)
615             return hpDeducted;
616         return hpSpecialDeducted;
617     }
618     
619     function getAncestorBuff(uint32 _classId, SupporterData _support) constant private returns(uint16){
620         // check ancestors
621         uint i =0;
622         uint8 countEffect = 0;
623         uint ancestorSize = cacheClasses[_classId].ancestors.length;
624         if (ancestorSize > 0) {
625             uint32 ancestorClass = 0;
626             for (i=0; i < ancestorSize; i ++) {
627                 ancestorClass = cacheClasses[_classId].ancestors[i];
628                 if (ancestorClass == _support.classId1 || ancestorClass == _support.classId2 || ancestorClass == _support.classId3) {
629                     countEffect += 1;
630                 }
631             }
632         }
633         return countEffect * ancestorBuffPercentage;
634     }
635     
636     function getGasonSupport(uint32 _classId, SupporterData _sup) constant private returns(uint16 defenseSupport) {
637         uint i = 0;
638         uint8 classType = 0;
639         defenseSupport = 0;
640         for (i = 0; i < cacheClasses[_classId].types.length; i++) {
641             classType = cacheClasses[_classId].types[i];
642              if (_sup.isGason1) {
643                 if (classType == _sup.type1) {
644                     defenseSupport += gasonBuffPercentage;
645                     continue;
646                 }
647             }
648             if (_sup.isGason2) {
649                 if (classType == _sup.type2) {
650                     defenseSupport += gasonBuffPercentage;
651                     continue;
652                 }
653             }
654             if (_sup.isGason3) {
655                 if (classType == _sup.type3) {
656                     defenseSupport += gasonBuffPercentage;
657                     continue;
658                 }
659             }
660         }
661     }
662     
663     function getTypeSupport(uint32 _aClassId, uint32 _bClassId) constant private returns (uint16 aAttackSupport, uint16 bAttackSupport) {
664         // check types 
665         bool aHasAdvantage;
666         bool bHasAdvantage;
667         for (uint i = 0; i < cacheClasses[_aClassId].types.length; i++) {
668             for (uint j = 0; j < cacheClasses[_bClassId].types.length; j++) {
669                 if (typeAdvantages[cacheClasses[_aClassId].types[i]] == cacheClasses[_bClassId].types[j]) {
670                     aHasAdvantage = true;
671                 }
672                 if (typeAdvantages[cacheClasses[_bClassId].types[j]] == cacheClasses[_aClassId].types[i]) {
673                     bHasAdvantage = true;
674                 }
675             }
676         }
677         
678         if (aHasAdvantage)
679             aAttackSupport += typeBuffPercentage;
680         if (bHasAdvantage)
681             bAttackSupport += typeBuffPercentage;
682     }
683     
684     function calculateBattleStats(AttackData att) constant private returns(uint8 aLevel, uint16[6] aStats, uint8 bLevel, uint16[6] bStats) {
685         uint32 aClassId = 0;
686         (aClassId, aLevel, aStats) = getCurrentStats(att.aa);
687         uint32 bClassId = 0;
688         (bClassId, bLevel, bStats) = getCurrentStats(att.ba);
689         
690         // check gasonsupport
691         (att.aAttackSupport, att.bAttackSupport) = getTypeSupport(aClassId, bClassId);
692         att.aAttackSupport += getAncestorBuff(aClassId, att.asup);
693         att.bAttackSupport += getAncestorBuff(bClassId, att.bsup);
694         
695         uint16 aDefenseBuff = getGasonSupport(aClassId, att.asup);
696         uint16 bDefenseBuff = getGasonSupport(bClassId, att.bsup);
697         
698         // add attack
699         aStats[1] += aStats[1] * att.aAttackSupport / 100;
700         aStats[3] += aStats[3] * att.aAttackSupport / 100;
701         bStats[1] += bStats[1] * att.bAttackSupport / 100;
702         bStats[3] += bStats[3] * att.bAttackSupport / 100;
703         
704         // add offense
705         aStats[2] += aStats[2] * aDefenseBuff / 100;
706         aStats[4] += aStats[4] * aDefenseBuff / 100;
707         bStats[2] += bStats[2] * bDefenseBuff / 100;
708         bStats[4] += bStats[4] * bDefenseBuff / 100;
709         
710     }
711     
712     function attack(AttackData att) constant private returns(uint8 aLevel, uint8 bLevel, uint8 ran, bool win) {
713         uint16[6] memory aStats;
714         uint16[6] memory bStats;
715         (aLevel, aStats, bLevel, bStats) = calculateBattleStats(att);
716         
717         ran = getRandom(maxRandomRound+2, att.index, lastAttacker);
718         uint16 round = 0;
719         while (round < maxRandomRound && aStats[0] > 0 && bStats[0] > 0) {
720             if (aStats[5] > bStats[5]) {
721                 if (round % 2 == 0) {
722                     // a attack 
723                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
724                 } else {
725                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
726                 }
727                 
728             } else {
729                 if (round % 2 != 0) {
730                     bStats[0] = safeDeduct(bStats[0], calHpDeducted(aStats[1], aStats[3], bStats[2], bStats[4], round==ran));
731                 } else {
732                     aStats[0] = safeDeduct(aStats[0], calHpDeducted(bStats[1], bStats[3], aStats[2], aStats[4], round==ran));
733                 }
734             }
735             round+= 1;
736         }
737         
738         win = aStats[0] >= bStats[0];
739     }
740     
741     function updateCastle(uint32 _castleId, address _castleOwner, bool win) requireCastleContract private{
742         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
743         uint32 totalWin;
744         uint32 totalLose;
745         uint32 brickNumber;
746         (totalWin, totalLose, brickNumber) = castle.getCastleWinLose(_castleId);
747         EtheremonPaymentInterface payment = EtheremonPaymentInterface(paymentContract);
748         
749         // if castle win, ignore
750         if (win) {
751             if (totalWin < brickNumber) {
752                  payment.giveBattleBonus(_castleOwner, winTokenReward);
753             }
754         } else {
755             if (totalWin/winBrickReturn > brickNumber) {
756                 brickNumber = 2 * brickNumber;
757             } else {
758                 brickNumber += totalWin/winBrickReturn;
759             }
760             if (brickNumber <= totalLose + 1) {
761                 castle.removeCastleFromActive(_castleId);
762                 // destroy
763             }
764             payment.giveBattleBonus(msg.sender, winTokenReward);
765         }
766     }
767     
768     function hasValidParam(address _trainer, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) constant public returns(bool) {
769         if (_a1 == 0 || _a2 == 0 || _a3 == 0)
770             return false;
771         if (_a1 == _a2 || _a1 == _a3 || _a1 == _s1 || _a1 == _s2 || _a1 == _s3)
772             return false;
773         if (_a2 == _a3 || _a2 == _s1 || _a2 == _s2 || _a2 == _s3)
774             return false;
775         if (_a3 == _s1 || _a3 == _s2 || _a3 == _s3)
776             return false;
777         if (_s1 > 0 && (_s1 == _s2 || _s1 == _s3))
778             return false;
779         if (_s2 > 0 && (_s2 == _s3))
780             return false;
781         
782         if (!isValidOwner(_a1, _trainer) || !isValidOwner(_a2, _trainer) || !isValidOwner(_a3, _trainer))
783             return false;
784         if (_s1 > 0 && !isValidOwner(_s1, _trainer))
785             return false;
786         if (_s2 > 0 && !isValidOwner(_s2, _trainer))
787             return false;
788         if (_s3 > 0 && !isValidOwner(_s3, _trainer))
789             return false;
790         return true;
791     }
792     
793     function createCastleInternal(CastleData _castleData) private {
794         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
795         uint32 castleId;
796         uint castleIndex = 0;
797         uint32 numberBrick = 0;
798         (castleId, castleIndex, numberBrick) = castle.getCastleBasicInfo(_castleData.trainer);
799         if (castleId > 0 || castleIndex > 0)
800             revert();
801 
802         if (castle.countActiveCastle() >= uint(maxActiveCastle))
803             revert();
804         castleId = castle.addCastle(_castleData.trainer, _castleData.name, _castleData.a1, _castleData.a2, _castleData.a3, 
805             _castleData.s1, _castleData.s2, _castleData.s3, _castleData.brickNumber);
806         EventCreateCastle(_castleData.trainer, castleId);
807     }
808     
809     // public
810     
811     function createCastle(string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract 
812         requireTradeContract requireCastleContract payable external {
813         
814         if (!hasValidParam(msg.sender, _a1, _a2, _a3, _s1, _s2, _s3))
815             revert();
816         
817         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
818         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
819             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
820             revert();
821         
822         uint32 numberBrick = uint32(msg.value / brickETHPrice);
823         if (numberBrick < castleMinBrick) {
824             revert();
825         }
826         
827         CastleData memory castleData;
828         castleData.trainer = msg.sender;
829         castleData.name = _name;
830         castleData.brickNumber = numberBrick;
831         castleData.a1 = _a1;
832         castleData.a2 = _a2;
833         castleData.a3 = _a3;
834         castleData.s1 = _s1;
835         castleData.s2 = _s2;
836         castleData.s3 = _s3;
837         createCastleInternal(castleData);
838         totalEarn += msg.value;
839     }
840     
841     function createCastleWithToken(address _trainer, uint32 _noBrick, string _name, uint64 _a1, uint64 _a2, uint64 _a3, uint64 _s1, uint64 _s2, uint64 _s3) isActive requireDataContract
842         requireTradeContract requireCastleContract requirePaymentContract external {
843         // only accept request from payment contract
844         if (msg.sender != paymentContract)
845             revert();
846     
847         if (!hasValidParam(_trainer, _a1, _a2, _a3, _s1, _s2, _s3))
848             revert();
849         
850         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
851         if (trade.isOnTrading(_a1) || trade.isOnTrading(_a2) || trade.isOnTrading(_a3) || 
852             trade.isOnTrading(_s1) || trade.isOnTrading(_s2) || trade.isOnTrading(_s3))
853             revert();
854         
855         if (_noBrick < castleMinBrick) {
856             revert();
857         }
858         
859         CastleData memory castleData;
860         castleData.trainer = _trainer;
861         castleData.name = _name;
862         castleData.brickNumber = _noBrick;
863         castleData.a1 = _a1;
864         castleData.a2 = _a2;
865         castleData.a3 = _a3;
866         castleData.s1 = _s1;
867         castleData.s2 = _s2;
868         castleData.s3 = _s3;
869         createCastleInternal(castleData);
870     }
871     
872     function renameCastle(uint32 _castleId, string _name) isActive requireCastleContract external {
873         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
874         uint index;
875         address owner;
876         uint256 price;
877         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
878         if (owner != msg.sender)
879             revert();
880         castle.renameCastle(_castleId, _name);
881     }
882     
883     function removeCastle(uint32 _castleId) isActive requireCastleContract external {
884         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
885         uint index;
886         address owner;
887         uint256 price;
888         (index, owner, price) = castle.getCastleBasicInfoById(_castleId);
889         if (owner != msg.sender)
890             revert();
891         if (index > 0) {
892             castle.removeCastleFromActive(_castleId);
893         }
894         EventRemoveCastle(_castleId);
895     }
896     
897     function getSupporterInfo(uint64 s1, uint64 s2, uint64 s3) constant public returns(SupporterData sData) {
898         uint temp;
899         uint32 __;
900         EtheremonGateway gateway = EtheremonGateway(worldContract);
901         if (s1 > 0)
902             (sData.classId1, __, sData.isGason1, temp, temp) = gateway.getObjBattleInfo(s1);
903         if (s2 > 0)
904             (sData.classId2, __, sData.isGason2, temp, temp) = gateway.getObjBattleInfo(s2);
905         if (s3 > 0)
906             (sData.classId3, __, sData.isGason3, temp, temp) = gateway.getObjBattleInfo(s3);
907 
908         EtheremonDataBase data = EtheremonDataBase(dataContract);
909         if (sData.isGason1) {
910             sData.type1 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId1), 0);
911         }
912         
913         if (sData.isGason2) {
914             sData.type2 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId2), 0);
915         }
916         
917         if (sData.isGason3) {
918             sData.type3 = data.getElementInArrayType(ArrayType.CLASS_TYPE, uint64(sData.classId3), 0);
919         }
920     }
921     
922     function attackCastle(uint32 _castleId, uint64 _aa1, uint64 _aa2, uint64 _aa3, uint64 _as1, uint64 _as2, uint64 _as3) isActive requireDataContract 
923         requireTradeContract requireCastleContract requirePaymentContract external {
924         if (!hasValidParam(msg.sender, _aa1, _aa2, _aa3, _as1, _as2, _as3))
925             revert();
926         
927         EtheremonCastleContract castle = EtheremonCastleContract(castleContract);
928         BattleLogData memory log;
929         (log.castleIndex, log.castleOwner, log.temp[0]) = castle.getCastleBasicInfoById(_castleId);
930         if (log.castleIndex == 0 || log.castleOwner == msg.sender)
931             revert();
932         
933         EtheremonGateway gateway = EtheremonGateway(worldContract);
934         BattleMonsterData memory b;
935         (b.a1, b.a2, b.a3, b.s1, b.s2, b.s3) = castle.getCastleObjInfo(_castleId);
936         lastAttacker = msg.sender;
937 
938         // init data
939         uint8 countWin = 0;
940         AttackData memory att;
941         att.asup = getSupporterInfo(b.s1, b.s2, b.s3);
942         att.bsup = getSupporterInfo(_as1, _as2, _as3);
943         
944         att.index = 0;
945         att.aa = b.a1;
946         att.ba = _aa1;
947         (log.monsterLevel[0], log.monsterLevel[3], log.randoms[0], log.win) = attack(att);
948         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterLevel[0], log.monsterLevel[3], log.win)*castleExpAdjustment/100);
949         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterLevel[3], log.monsterLevel[0], !log.win)*attackerExpAdjustment/100);
950         if (log.win)
951             countWin += 1;
952         
953         
954         att.index = 1;
955         att.aa = b.a2;
956         att.ba = _aa2;
957         (log.monsterLevel[1], log.monsterLevel[4], log.randoms[1], log.win) = attack(att);
958         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterLevel[1], log.monsterLevel[4], log.win)*castleExpAdjustment/100);
959         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterLevel[4], log.monsterLevel[1], !log.win)*attackerExpAdjustment/100);
960         if (log.win)
961             countWin += 1;   
962 
963         att.index = 2;
964         att.aa = b.a3;
965         att.ba = _aa3;
966         (log.monsterLevel[2], log.monsterLevel[5], log.randoms[2], log.win) = attack(att);
967         gateway.increaseMonsterExp(att.aa, getGainExp(log.monsterLevel[2], log.monsterLevel[5], log.win)*castleExpAdjustment/100);
968         gateway.increaseMonsterExp(att.ba, getGainExp(log.monsterLevel[5], log.monsterLevel[2], !log.win)*attackerExpAdjustment/100);
969         if (log.win)
970             countWin += 1; 
971         
972         if ((log.monsterLevel[0] + log.monsterLevel[1] + log.monsterLevel[2])/3 + castleMaxLevelGap < (log.monsterLevel[3] + log.monsterLevel[4] + log.monsterLevel[5])/3)
973             revert();
974         
975         updateCastle(_castleId, log.castleOwner, countWin>1);
976         if (countWin>1) {
977             log.result = BattleResult.CASTLE_WIN;
978         } else {
979             log.result = BattleResult.CASTLE_LOSE;
980         }
981         
982         log.temp[0] = levelExps[log.monsterLevel[0]]-1;
983         log.temp[1] = levelExps[log.monsterLevel[1]]-1;
984         log.temp[2] = levelExps[log.monsterLevel[2]]-1;
985         log.battleId = castle.addBattleLog(_castleId, msg.sender, log.randoms[0], log.randoms[1], log.randoms[2], 
986             uint8(log.result), log.temp[0], log.temp[1], log.temp[2]);
987         
988         log.temp[0] = levelExps[log.monsterLevel[3]]-1;
989         log.temp[1] = levelExps[log.monsterLevel[4]]-1;
990         log.temp[2] = levelExps[log.monsterLevel[5]]-1;
991         castle.addBattleLogMonsterInfo(log.battleId, _aa1, _aa2, _aa3, _as1, _as2, _as3, log.temp[0], log.temp[1], log.temp[2]);
992     
993         EventAttackCastle(msg.sender, _castleId, uint8(log.result));
994     }
995     
996 }