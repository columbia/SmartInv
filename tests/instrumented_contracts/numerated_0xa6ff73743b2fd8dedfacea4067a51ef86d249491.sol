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
38     bool public isMaintaining = false;
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
111 }
112 
113 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
114     
115     uint64 public totalMonster;
116     uint32 public totalClass;
117     
118     // write
119     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
120     function removeElementOfArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
121     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);
122     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);
123     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;
124     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
125     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
126     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
127     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
128     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);
129     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);
130     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);
131     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
132     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
133     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;
134     
135     // read
136     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
137     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
138     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
139     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
140     function getMonsterName(uint64 _objId) constant public returns(string name);
141     function getExtraBalance(address _trainer) constant public returns(uint256);
142     function getMonsterDexSize(address _trainer) constant public returns(uint);
143     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
144     function getExpectedBalance(address _trainer) constant public returns(uint256);
145     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
146 }
147 
148 contract EtheremonTransformData {
149     uint64 public totalEgg = 0;
150     function getHatchingEggId(address _trainer) constant external returns(uint64);
151     function getHatchingEggData(address _trainer) constant external returns(uint64, uint64, uint32, address, uint, uint64);
152     function getTranformedId(uint64 _objId) constant external returns(uint64);
153     function countEgg(uint64 _objId) constant external returns(uint);
154     
155     function setHatchTime(uint64 _eggId, uint _hatchTime) external;
156     function setHatchedEgg(uint64 _eggId, uint64 _newObjId) external;
157     function addEgg(uint64 _objId, uint32 _classId, address _trainer, uint _hatchTime) external returns(uint64);
158     function setTranformed(uint64 _objId, uint64 _newObjId) external;
159 }
160 
161 contract EtheremonWorld is EtheremonEnum {
162     
163     function getGen0COnfig(uint32 _classId) constant public returns(uint32, uint256, uint32);
164     function getTrainerEarn(address _trainer) constant public returns(uint256);
165     function getReturnFromMonster(uint64 _objId) constant public returns(uint256 current, uint256 total);
166     function getClassPropertyValue(uint32 _classId, PropertyType _type, uint index) constant external returns(uint32);
167     function getClassPropertySize(uint32 _classId, PropertyType _type) constant external returns(uint);
168 }
169 
170 interface EtheremonBattle {
171     function isOnBattle(uint64 _objId) constant external returns(bool);
172     function getMonsterLevel(uint64 _objId) constant public returns(uint8);
173 }
174 
175 interface EtheremonTradeInterface {
176     function isOnTrading(uint64 _objId) constant external returns(bool);
177 }
178 
179 contract EtheremonTransform is EtheremonEnum, BasicAccessControl, SafeMath {
180     uint8 constant public STAT_COUNT = 6;
181     uint8 constant public STAT_MAX = 32;
182     uint8 constant public GEN0_NO = 24;
183     
184     struct MonsterClassAcc {
185         uint32 classId;
186         uint256 price;
187         uint256 returnPrice;
188         uint32 total;
189         bool catchable;
190     }
191 
192     struct MonsterObjAcc {
193         uint64 monsterId;
194         uint32 classId;
195         address trainer;
196         string name;
197         uint32 exp;
198         uint32 createIndex;
199         uint32 lastClaimIndex;
200         uint createTime;
201     }
202     
203     struct MonsterEgg {
204         uint64 eggId;
205         uint64 objId;
206         uint32 classId;
207         address trainer;
208         uint hatchTime;
209         uint64 newObjId;
210     }
211     
212     struct BasicObjInfo {
213         uint32 classId;
214         address owner;
215         uint8 level;
216     }
217     
218     // Gen0 has return price & no longer can be caught when this contract is deployed
219     struct Gen0Config {
220         uint32 classId;
221         uint256 originalPrice;
222         uint256 returnPrice;
223         uint32 total; // total caught (not count those from eggs)
224     }
225     
226     // hatching range
227     uint16 public hatchStartTime = 2; // hour
228     uint16 public hatchMaxTime = 46; // hour
229     uint public removeHatchingTimeFee = 0.05 ether; // ETH
230     uint public buyEggFee = 0.06 ether; // ETH
231     
232     uint32[] public randomClassIds;
233     mapping(uint32 => uint8) public layingEggLevels;
234     mapping(uint32 => uint8) public layingEggDeductions;
235     mapping(uint32 => uint8) public transformLevels;
236     mapping(uint32 => uint32) public transformClasses;
237 
238     mapping(uint8 => uint32) public levelExps;
239     address private lastHatchingAddress;
240     
241     mapping(uint32 => Gen0Config) public gen0Config;
242     
243     // linked smart contract
244     address public dataContract;
245     address public worldContract;
246     address public transformDataContract;
247     address public battleContract;
248     address public tradeContract;
249     
250     // events
251     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
252     event EventLayEgg(address indexed trainer, uint64 objId, uint64 eggId);
253     
254     // modifier
255     
256     modifier requireDataContract {
257         require(dataContract != address(0));
258         _;
259     }
260     
261     modifier requireTransformDataContract {
262         require(transformDataContract != address(0));
263         _;
264     }
265     
266     modifier requireBattleContract {
267         require(battleContract != address(0));
268         _;
269     }
270     
271     modifier requireTradeContract {
272         require(tradeContract != address(0));
273         _;        
274     }
275     
276     
277     // constructor
278     function EtheremonTransform(address _dataContract, address _worldContract, address _transformDataContract, address _battleContract, address _tradeContract) public {
279         dataContract = _dataContract;
280         worldContract = _worldContract;
281         transformDataContract = _transformDataContract;
282         battleContract = _battleContract;
283         tradeContract = _tradeContract;
284     }
285     
286     // helper
287     function getRandom(uint16 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
288         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
289         for (uint8 i = 0; i < index && i < 6; i ++) {
290             genNum /= 256;
291         }
292         return uint8(genNum % maxRan);
293     }
294     
295     function addNewObj(address _trainer, uint32 _classId) private returns(uint64) {
296         EtheremonDataBase data = EtheremonDataBase(dataContract);
297         uint64 objId = data.addMonsterObj(_classId, _trainer, "..name me...");
298         for (uint i=0; i < STAT_COUNT; i+= 1) {
299             uint8 value = getRandom(STAT_MAX, uint8(i), lastHatchingAddress) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);
300             data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);
301         }
302         return objId;
303     }
304     
305     // admin & moderators
306     function setContract(address _dataContract, address _worldContract, address _transformDataContract, address _battleContract, address _tradeContract) onlyModerators external {
307         dataContract = _dataContract;
308         worldContract = _worldContract;
309         transformDataContract = _transformDataContract;
310         battleContract = _battleContract;
311         tradeContract = _tradeContract;
312     }
313 
314     function setOriginalPriceGen0() onlyModerators external {
315         gen0Config[1] = Gen0Config(1, 0.3 ether, 0.003 ether, 374);
316         gen0Config[2] = Gen0Config(2, 0.3 ether, 0.003 ether, 408);
317         gen0Config[3] = Gen0Config(3, 0.3 ether, 0.003 ether, 373);
318         gen0Config[4] = Gen0Config(4, 0.2 ether, 0.002 ether, 437);
319         gen0Config[5] = Gen0Config(5, 0.1 ether, 0.001 ether, 497);
320         gen0Config[6] = Gen0Config(6, 0.3 ether, 0.003 ether, 380); 
321         gen0Config[7] = Gen0Config(7, 0.2 ether, 0.002 ether, 345);
322         gen0Config[8] = Gen0Config(8, 0.1 ether, 0.001 ether, 518); 
323         gen0Config[9] = Gen0Config(9, 0.1 ether, 0.001 ether, 447);
324         gen0Config[10] = Gen0Config(10, 0.2 ether, 0.002 ether, 380); 
325         gen0Config[11] = Gen0Config(11, 0.2 ether, 0.002 ether, 354);
326         gen0Config[12] = Gen0Config(12, 0.2 ether, 0.002 ether, 346);
327         gen0Config[13] = Gen0Config(13, 0.2 ether, 0.002 ether, 351); 
328         gen0Config[14] = Gen0Config(14, 0.2 ether, 0.002 ether, 338);
329         gen0Config[15] = Gen0Config(15, 0.2 ether, 0.002 ether, 341);
330         gen0Config[16] = Gen0Config(16, 0.35 ether, 0.0035 ether, 384);
331         gen0Config[17] = Gen0Config(17, 1 ether, 0.01 ether, 305); 
332         gen0Config[18] = Gen0Config(18, 0.1 ether, 0.001 ether, 427);
333         gen0Config[19] = Gen0Config(19, 1 ether, 0.01 ether, 304);
334         gen0Config[20] = Gen0Config(20, 0.4 ether, 0.05 ether, 82);
335         gen0Config[21] = Gen0Config(21, 1, 1, 123);
336         gen0Config[22] = Gen0Config(22, 0.2 ether, 0.001 ether, 468);
337         gen0Config[23] = Gen0Config(23, 0.5 ether, 0.0025 ether, 302);
338         gen0Config[24] = Gen0Config(24, 1 ether, 0.005 ether, 195);
339     }    
340 
341     function updateHatchingRange(uint16 _start, uint16 _max) onlyModerators external {
342         hatchStartTime = _start;
343         hatchMaxTime = _max;
344     }
345 
346     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
347         // no user money is kept in this contract, only trasaction fee
348         if (_amount > this.balance) {
349             revert();
350         }
351         _sendTo.transfer(_amount);
352     }
353 
354     function setConfigClass(uint32 _classId, uint8 _layingLevel, uint8 _layingCost, uint8 _transformLevel, uint32 _tranformClass) onlyModerators external {
355         layingEggLevels[_classId] = _layingLevel;
356         layingEggDeductions[_classId] = _layingCost;
357         transformLevels[_classId] = _transformLevel;
358         transformClasses[_classId] = _tranformClass;
359     }
360     
361     function setConfig(uint _removeHatchingTimeFee, uint _buyEggFee) onlyModerators external {
362         removeHatchingTimeFee = _removeHatchingTimeFee;
363         buyEggFee = _buyEggFee;
364     }
365 
366     function genLevelExp() onlyModerators external {
367         uint8 level = 1;
368         uint32 requirement = 100;
369         uint32 sum = requirement;
370         while(level <= 100) {
371             levelExps[level] = sum;
372             level += 1;
373             requirement = (requirement * 11) / 10 + 5;
374             sum += requirement;
375         }
376     }
377     
378     function addRandomClass(uint32 _newClassId) onlyModerators public {
379         if (_newClassId > 0) {
380             for (uint index = 0; index < randomClassIds.length; index++) {
381                 if (randomClassIds[index] == _newClassId) {
382                     return;
383                 }
384             }
385             randomClassIds.push(_newClassId);
386         }
387     }
388     
389     function removeRandomClass(uint32 _oldClassId) onlyModerators public {
390         uint foundIndex = 0;
391         for (; foundIndex < randomClassIds.length; foundIndex++) {
392             if (randomClassIds[foundIndex] == _oldClassId) {
393                 break;
394             }
395         }
396         if (foundIndex < randomClassIds.length) {
397             randomClassIds[foundIndex] = randomClassIds[randomClassIds.length-1];
398             delete randomClassIds[randomClassIds.length-1];
399             randomClassIds.length--;
400         }
401     }
402     
403     function removeHatchingTimeWithToken(address _trainer) isActive onlyModerators requireDataContract requireTransformDataContract external {
404         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
405         MonsterEgg memory egg;
406         (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(_trainer);
407         // not hatching any egg
408         if (egg.eggId == 0 || egg.trainer != _trainer || egg.newObjId > 0)
409             revert();
410         
411         transformData.setHatchTime(egg.eggId, 0);
412     }    
413     
414     function buyEggWithToken(address _trainer) isActive onlyModerators requireDataContract requireTransformDataContract external {
415         if (randomClassIds.length == 0) {
416             revert();
417         }
418         
419         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
420         // make sure no hatching egg at the same time
421         if (transformData.getHatchingEggId(_trainer) > 0) {
422             revert();
423         }
424 
425         // add random egg
426         uint8 classIndex = getRandom(uint16(randomClassIds.length), 1, lastHatchingAddress);
427         uint64 eggId = transformData.addEgg(0, randomClassIds[classIndex], _trainer, block.timestamp + (hatchStartTime + getRandom(hatchMaxTime, 0, lastHatchingAddress)) * 3600);
428         // deduct exp
429         EventLayEgg(msg.sender, 0, eggId);
430     }
431     
432     // public
433 
434     function ceil(uint a, uint m) pure public returns (uint) {
435         return ((a + m - 1) / m) * m;
436     }
437 
438     function getLevel(uint32 exp) view public returns (uint8) {
439         uint8 minIndex = 1;
440         uint8 maxIndex = 100;
441         uint8 currentIndex;
442      
443         while (minIndex < maxIndex) {
444             currentIndex = (minIndex + maxIndex) / 2;
445             if (exp < levelExps[currentIndex])
446                 maxIndex = currentIndex;
447             else
448                 minIndex = currentIndex + 1;
449         }
450 
451         return minIndex;
452     }
453 
454     function getGen0ObjInfo(uint64 _objId) constant public returns(uint32, uint32, uint256) {
455         EtheremonDataBase data = EtheremonDataBase(dataContract);
456         
457         MonsterObjAcc memory obj;
458         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
459         
460         Gen0Config memory gen0 = gen0Config[obj.classId];
461         if (gen0.classId != obj.classId) {
462             return (gen0.classId, obj.createIndex, 0);
463         }
464         
465         uint32 totalGap = 0;
466         if (obj.createIndex < gen0.total)
467             totalGap = gen0.total - obj.createIndex;
468         
469         return (obj.classId, obj.createIndex, safeMult(totalGap, gen0.returnPrice));
470     }
471     
472     function getObjClassId(uint64 _objId) requireDataContract constant public returns(uint32, address, uint8) {
473         EtheremonDataBase data = EtheremonDataBase(dataContract);
474         MonsterObjAcc memory obj;
475         uint32 _ = 0;
476         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
477         return (obj.classId, obj.trainer, getLevel(obj.exp));
478     }
479     
480     function getClassCheckOwner(uint64 _objId, address _trainer) requireDataContract constant public returns(uint32) {
481         EtheremonDataBase data = EtheremonDataBase(dataContract);
482         MonsterObjAcc memory obj;
483         uint32 _ = 0;
484         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
485         if (_trainer != obj.trainer)
486             return 0;
487         return obj.classId;
488     }
489 
490     function calculateMaxEggG0(uint64 _objId) constant public returns(uint) {
491         uint32 classId;
492         uint32 createIndex; 
493         uint256 totalEarn;
494         (classId, createIndex, totalEarn) = getGen0ObjInfo(_objId);
495         if (classId > GEN0_NO || classId == 20 || classId == 21)
496             return 0;
497         
498         Gen0Config memory config = gen0Config[classId];
499         // the one from egg can not lay
500         if (createIndex > config.total)
501             return 0;
502 
503         // calculate agv price
504         uint256 avgPrice = config.originalPrice;
505         uint rate = config.originalPrice/config.returnPrice;
506         if (config.total > rate) {
507             uint k = config.total - rate;
508             avgPrice = (config.total * config.originalPrice + config.returnPrice * k * (k+1) / 2) / config.total;
509         }
510         uint256 catchPrice = config.originalPrice;            
511         if (createIndex > rate) {
512             catchPrice += config.returnPrice * safeSubtract(createIndex, rate);
513         }
514         if (totalEarn >= catchPrice) {
515             return 0;
516         }
517         return ceil((catchPrice - totalEarn)*15*1000/avgPrice, 10000)/10000;
518     }
519     
520     function canLayEgg(uint64 _objId, uint32 _classId, uint32 _level) constant public returns(bool) {
521         if (_classId <= GEN0_NO) {
522             EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
523             // legends
524             if (transformData.countEgg(_objId) >= calculateMaxEggG0(_objId))
525                 return false;
526             return true;
527         } else {
528             if (layingEggLevels[_classId] == 0 || _level < layingEggLevels[_classId])
529                 return false;
530             return true;
531         }
532     }
533     
534     function layEgg(uint64 _objId) isActive requireDataContract requireTransformDataContract external {
535         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
536         // make sure no hatching egg at the same time
537         if (transformData.getHatchingEggId(msg.sender) > 0) {
538             revert();
539         }
540         
541         // can not lay egg when trading
542         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
543         if (trade.isOnTrading(_objId))
544             revert();
545         
546         // check obj 
547         EtheremonDataBase data = EtheremonDataBase(dataContract);
548         MonsterObjAcc memory obj;
549         uint32 _ = 0;
550         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
551         if (obj.monsterId != _objId || obj.trainer != msg.sender) {
552             revert();
553         }
554         
555         // check lay egg condition
556         uint8 currentLevel = getLevel(obj.exp);
557         uint8 afterLevel = 0;
558         if (!canLayEgg(_objId, obj.classId, currentLevel))
559             revert();
560         if (layingEggDeductions[obj.classId] >= currentLevel)
561             revert();
562         afterLevel = currentLevel - layingEggDeductions[obj.classId];
563 
564         // add egg 
565         uint64 eggId = transformData.addEgg(obj.monsterId, obj.classId, msg.sender, block.timestamp + (hatchStartTime + getRandom(hatchMaxTime, 0, lastHatchingAddress)) * 3600);
566         
567         // deduct exp 
568         if (afterLevel < currentLevel)
569             data.decreaseMonsterExp(_objId, obj.exp - levelExps[afterLevel-1]);
570         EventLayEgg(msg.sender, _objId, eggId);
571     }
572     
573     function hatchEgg() isActive requireDataContract requireTransformDataContract external {
574         // use as a seed for random
575         lastHatchingAddress = msg.sender;
576         
577         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
578         MonsterEgg memory egg;
579         (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(msg.sender);
580         // not hatching any egg
581         if (egg.eggId == 0 || egg.trainer != msg.sender)
582             revert();
583         // need more time
584         if (egg.newObjId > 0 || egg.hatchTime > block.timestamp) {
585             revert();
586         }
587         
588         uint64 objId = addNewObj(msg.sender, egg.classId);
589         transformData.setHatchedEgg(egg.eggId, objId);
590         
591         Transfer(address(0), msg.sender, objId);
592     }
593     
594     function removeHatchingTime() isActive requireDataContract requireTransformDataContract external payable  {
595         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
596         MonsterEgg memory egg;
597         (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(msg.sender);
598         // not hatching any egg
599         if (egg.eggId == 0 || egg.trainer != msg.sender || egg.newObjId > 0)
600             revert();
601         
602         if (msg.value != removeHatchingTimeFee) {
603             revert();
604         }
605         transformData.setHatchTime(egg.eggId, 0);
606     }
607 
608     
609     function checkAncestors(uint32 _classId, address _trainer, uint64 _a1, uint64 _a2, uint64 _a3) constant public returns(bool) {
610         EtheremonWorld world = EtheremonWorld(worldContract);
611         uint index = 0;
612         uint32 temp = 0;
613         // check ancestor
614         uint32[3] memory ancestors;
615         uint32[3] memory requestAncestors;
616         index = world.getClassPropertySize(_classId, PropertyType.ANCESTOR);
617         while (index > 0) {
618             index -= 1;
619             ancestors[index] = world.getClassPropertyValue(_classId, PropertyType.ANCESTOR, index);
620         }
621             
622         if (_a1 > 0) {
623             temp = getClassCheckOwner(_a1, _trainer);
624             if (temp == 0)
625                 return false;
626             requestAncestors[0] = temp;
627         }
628         if (_a2 > 0) {
629             temp = getClassCheckOwner(_a2, _trainer);
630             if (temp == 0)
631                 return false;
632             requestAncestors[1] = temp;
633         }
634         if (_a3 > 0) {
635             temp = getClassCheckOwner(_a3, _trainer);
636             if (temp == 0)
637                 return false;
638             requestAncestors[2] = temp;
639         }
640             
641         if (requestAncestors[0] > 0 && (requestAncestors[0] == requestAncestors[1] || requestAncestors[0] == requestAncestors[2]))
642             return false;
643         if (requestAncestors[1] > 0 && (requestAncestors[1] == requestAncestors[2]))
644             return false;
645                 
646         for (index = 0; index < ancestors.length; index++) {
647             temp = ancestors[index];
648             if (temp > 0 && temp != requestAncestors[0]  && temp != requestAncestors[1] && temp != requestAncestors[2])
649                 return false;
650         }
651         
652         return true;
653     }
654     
655     function transform(uint64 _objId, uint64 _a1, uint64 _a2, uint64 _a3) isActive requireDataContract requireTransformDataContract external payable {
656         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
657         if (transformData.getTranformedId(_objId) > 0)
658             revert();
659         
660         EtheremonBattle battle = EtheremonBattle(battleContract);
661         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
662         if (battle.isOnBattle(_objId) || trade.isOnTrading(_objId))
663             revert();
664         
665         EtheremonDataBase data = EtheremonDataBase(dataContract);
666         
667         BasicObjInfo memory objInfo;
668         (objInfo.classId, objInfo.owner, objInfo.level) = getObjClassId(_objId);
669         uint32 transformClass = transformClasses[objInfo.classId];
670         if (objInfo.classId == 0 || objInfo.owner != msg.sender)
671             revert();
672         if (transformLevels[objInfo.classId] == 0 || objInfo.level < transformLevels[objInfo.classId])
673             revert();
674         if (transformClass == 0)
675             revert();
676         
677         
678         // gen0 - can not transform if it has bonus egg 
679         if (objInfo.classId <= GEN0_NO) {
680             // legends
681             if (getBonusEgg(_objId) > 0)
682                 revert();
683         } else {
684             if (!checkAncestors(objInfo.classId, msg.sender, _a1, _a2, _a3))
685                 revert();
686         }
687         
688         uint64 newObjId = addNewObj(msg.sender, transformClass);
689         // remove old one
690         data.removeMonsterIdMapping(msg.sender, _objId);
691         transformData.setTranformed(_objId, newObjId);
692         
693         Transfer(msg.sender, address(0), _objId);
694         Transfer(address(0), msg.sender, newObjId);
695     }
696     
697     function buyEgg() isActive requireDataContract requireTransformDataContract external payable {
698         if (msg.value != buyEggFee) {
699             revert();
700         }
701         
702         if (randomClassIds.length == 0) {
703             revert();
704         }
705         
706         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
707         // make sure no hatching egg at the same time
708         if (transformData.getHatchingEggId(msg.sender) > 0) {
709             revert();
710         }
711 
712         // add random egg
713         uint8 classIndex = getRandom(uint16(randomClassIds.length), 1, lastHatchingAddress);
714         uint64 eggId = transformData.addEgg(0, randomClassIds[classIndex], msg.sender, block.timestamp + (hatchStartTime + getRandom(hatchMaxTime, 0, lastHatchingAddress)) * 3600);
715         // deduct exp
716         EventLayEgg(msg.sender, 0, eggId);
717     }
718     
719     // read
720     function getBonusEgg(uint64 _objId) constant public returns(uint) {
721         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
722         uint totalBonusEgg = calculateMaxEggG0(_objId);
723         if (totalBonusEgg > 0) {
724             return (totalBonusEgg - transformData.countEgg(_objId));
725         }
726         return 0;
727     }
728     
729 }