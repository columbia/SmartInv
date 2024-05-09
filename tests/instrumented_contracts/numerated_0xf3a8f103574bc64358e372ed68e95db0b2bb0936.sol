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
251     event EventLayEgg(address indexed trainer, uint64 objId, uint64 eggId);
252     event EventHatchEgg(address indexed trainer, uint64 eggId, uint64 objId);
253     event EventTransform(address indexed trainer, uint64 oldObjId, uint64 newObjId);
254     event EventRelease(address indexed trainer, uint64 objId);
255     
256     // modifier
257     
258     modifier requireDataContract {
259         require(dataContract != address(0));
260         _;
261     }
262     
263     modifier requireTransformDataContract {
264         require(transformDataContract != address(0));
265         _;
266     }
267     
268     modifier requireBattleContract {
269         require(battleContract != address(0));
270         _;
271     }
272     
273     modifier requireTradeContract {
274         require(tradeContract != address(0));
275         _;        
276     }
277     
278     
279     // constructor
280     function EtheremonTransform(address _dataContract, address _worldContract, address _transformDataContract, address _battleContract, address _tradeContract) public {
281         dataContract = _dataContract;
282         worldContract = _worldContract;
283         transformDataContract = _transformDataContract;
284         battleContract = _battleContract;
285         tradeContract = _tradeContract;
286     }
287     
288     // helper
289     function getRandom(uint16 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
290         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
291         for (uint8 i = 0; i < index && i < 6; i ++) {
292             genNum /= 256;
293         }
294         return uint8(genNum % maxRan);
295     }
296     
297     function addNewObj(address _trainer, uint32 _classId) private returns(uint64) {
298         EtheremonDataBase data = EtheremonDataBase(dataContract);
299         uint64 objId = data.addMonsterObj(_classId, _trainer, "..name me...");
300         for (uint i=0; i < STAT_COUNT; i+= 1) {
301             uint8 value = getRandom(STAT_MAX, uint8(i), lastHatchingAddress) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);
302             data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);
303         }
304         return objId;
305     }
306     
307     // admin & moderators
308     function setContract(address _dataContract, address _worldContract, address _transformDataContract, address _battleContract, address _tradeContract) onlyModerators external {
309         dataContract = _dataContract;
310         worldContract = _worldContract;
311         transformDataContract = _transformDataContract;
312         battleContract = _battleContract;
313         tradeContract = _tradeContract;
314     }
315 
316     function setOriginalPriceGen0() onlyModerators external {
317         gen0Config[1] = Gen0Config(1, 0.3 ether, 0.003 ether, 374);
318         gen0Config[2] = Gen0Config(2, 0.3 ether, 0.003 ether, 408);
319         gen0Config[3] = Gen0Config(3, 0.3 ether, 0.003 ether, 373);
320         gen0Config[4] = Gen0Config(4, 0.2 ether, 0.002 ether, 437);
321         gen0Config[5] = Gen0Config(5, 0.1 ether, 0.001 ether, 497);
322         gen0Config[6] = Gen0Config(6, 0.3 ether, 0.003 ether, 380); 
323         gen0Config[7] = Gen0Config(7, 0.2 ether, 0.002 ether, 345);
324         gen0Config[8] = Gen0Config(8, 0.1 ether, 0.001 ether, 518); 
325         gen0Config[9] = Gen0Config(9, 0.1 ether, 0.001 ether, 447);
326         gen0Config[10] = Gen0Config(10, 0.2 ether, 0.002 ether, 380); 
327         gen0Config[11] = Gen0Config(11, 0.2 ether, 0.002 ether, 354);
328         gen0Config[12] = Gen0Config(12, 0.2 ether, 0.002 ether, 346);
329         gen0Config[13] = Gen0Config(13, 0.2 ether, 0.002 ether, 351); 
330         gen0Config[14] = Gen0Config(14, 0.2 ether, 0.002 ether, 338);
331         gen0Config[15] = Gen0Config(15, 0.2 ether, 0.002 ether, 341);
332         gen0Config[16] = Gen0Config(16, 0.35 ether, 0.0035 ether, 384);
333         gen0Config[17] = Gen0Config(17, 1 ether, 0.01 ether, 305); 
334         gen0Config[18] = Gen0Config(18, 0.1 ether, 0.001 ether, 427);
335         gen0Config[19] = Gen0Config(19, 1 ether, 0.01 ether, 304);
336         gen0Config[20] = Gen0Config(20, 0.4 ether, 0.05 ether, 82);
337         gen0Config[21] = Gen0Config(21, 1, 1, 123);
338         gen0Config[22] = Gen0Config(22, 0.2 ether, 0.001 ether, 468);
339         gen0Config[23] = Gen0Config(23, 0.5 ether, 0.0025 ether, 302);
340         gen0Config[24] = Gen0Config(24, 1 ether, 0.005 ether, 195);
341     }    
342 
343     function updateHatchingRange(uint16 _start, uint16 _max) onlyModerators external {
344         hatchStartTime = _start;
345         hatchMaxTime = _max;
346     }
347 
348     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
349         // no user money is kept in this contract, only trasaction fee
350         if (_amount > this.balance) {
351             revert();
352         }
353         _sendTo.transfer(_amount);
354     }
355 
356     function setConfigClass(uint32 _classId, uint8 _layingLevel, uint8 _layingCost, uint8 _transformLevel, uint32 _tranformClass) onlyModerators external {
357         layingEggLevels[_classId] = _layingLevel;
358         layingEggDeductions[_classId] = _layingCost;
359         transformLevels[_classId] = _transformLevel;
360         transformClasses[_classId] = _tranformClass;
361     }
362     
363     function setConfig(uint _removeHatchingTimeFee, uint _buyEggFee) onlyModerators external {
364         removeHatchingTimeFee = _removeHatchingTimeFee;
365         buyEggFee = _buyEggFee;
366     }
367 
368     function genLevelExp() onlyModerators external {
369         uint8 level = 1;
370         uint32 requirement = 100;
371         uint32 sum = requirement;
372         while(level <= 100) {
373             levelExps[level] = sum;
374             level += 1;
375             requirement = (requirement * 11) / 10 + 5;
376             sum += requirement;
377         }
378     }
379     
380     function addRandomClass(uint32 _newClassId) onlyModerators public {
381         if (_newClassId > 0) {
382             for (uint index = 0; index < randomClassIds.length; index++) {
383                 if (randomClassIds[index] == _newClassId) {
384                     return;
385                 }
386             }
387             randomClassIds.push(_newClassId);
388         }
389     }
390     
391     function removeRandomClass(uint32 _oldClassId) onlyModerators public {
392         uint foundIndex = 0;
393         for (; foundIndex < randomClassIds.length; foundIndex++) {
394             if (randomClassIds[foundIndex] == _oldClassId) {
395                 break;
396             }
397         }
398         if (foundIndex < randomClassIds.length) {
399             randomClassIds[foundIndex] = randomClassIds[randomClassIds.length-1];
400             delete randomClassIds[randomClassIds.length-1];
401             randomClassIds.length--;
402         }
403     }
404     
405     function removeHatchingTimeWithToken(address _trainer) isActive onlyModerators requireDataContract requireTransformDataContract external {
406         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
407         MonsterEgg memory egg;
408         (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(_trainer);
409         // not hatching any egg
410         if (egg.eggId == 0 || egg.trainer != _trainer || egg.newObjId > 0)
411             revert();
412         
413         transformData.setHatchTime(egg.eggId, 0);
414     }    
415     
416     function buyEggWithToken(address _trainer) isActive onlyModerators requireDataContract requireTransformDataContract external {
417         if (randomClassIds.length == 0) {
418             revert();
419         }
420         
421         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
422         // make sure no hatching egg at the same time
423         if (transformData.getHatchingEggId(_trainer) > 0) {
424             revert();
425         }
426 
427         // add random egg
428         uint8 classIndex = getRandom(uint16(randomClassIds.length), 1, lastHatchingAddress);
429         uint64 eggId = transformData.addEgg(0, randomClassIds[classIndex], _trainer, block.timestamp + (hatchStartTime + getRandom(hatchMaxTime, 0, lastHatchingAddress)) * 3600);
430         // deduct exp
431         EventLayEgg(msg.sender, 0, eggId);
432     }
433     
434     // public
435 
436     function ceil(uint a, uint m) pure public returns (uint) {
437         return ((a + m - 1) / m) * m;
438     }
439 
440     function getLevel(uint32 exp) view public returns (uint8) {
441         uint8 minIndex = 1;
442         uint8 maxIndex = 100;
443         uint8 currentIndex;
444      
445         while (minIndex < maxIndex) {
446             currentIndex = (minIndex + maxIndex) / 2;
447             if (exp < levelExps[currentIndex])
448                 maxIndex = currentIndex;
449             else
450                 minIndex = currentIndex + 1;
451         }
452 
453         return minIndex;
454     }
455 
456     function getGen0ObjInfo(uint64 _objId) constant public returns(uint32, uint32, uint256) {
457         EtheremonDataBase data = EtheremonDataBase(dataContract);
458         
459         MonsterObjAcc memory obj;
460         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
461         
462         Gen0Config memory gen0 = gen0Config[obj.classId];
463         if (gen0.classId != obj.classId) {
464             return (gen0.classId, obj.createIndex, 0);
465         }
466         
467         uint32 totalGap = 0;
468         if (obj.createIndex < gen0.total)
469             totalGap = gen0.total - obj.createIndex;
470         
471         return (obj.classId, obj.createIndex, safeMult(totalGap, gen0.returnPrice));
472     }
473     
474     function getObjClassId(uint64 _objId) requireDataContract constant public returns(uint32, address, uint8) {
475         EtheremonDataBase data = EtheremonDataBase(dataContract);
476         MonsterObjAcc memory obj;
477         uint32 _ = 0;
478         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
479         return (obj.classId, obj.trainer, getLevel(obj.exp));
480     }
481     
482     function getClassCheckOwner(uint64 _objId, address _trainer) requireDataContract constant public returns(uint32) {
483         EtheremonDataBase data = EtheremonDataBase(dataContract);
484         MonsterObjAcc memory obj;
485         uint32 _ = 0;
486         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
487         if (_trainer != obj.trainer)
488             return 0;
489         return obj.classId;
490     }
491 
492     function calculateMaxEggG0(uint64 _objId) constant public returns(uint) {
493         uint32 classId;
494         uint32 createIndex; 
495         uint256 totalEarn;
496         (classId, createIndex, totalEarn) = getGen0ObjInfo(_objId);
497         if (classId > GEN0_NO || classId == 20 || classId == 21)
498             return 0;
499         
500         Gen0Config memory config = gen0Config[classId];
501         // the one from egg can not lay
502         if (createIndex > config.total)
503             return 0;
504 
505         // calculate agv price
506         uint256 avgPrice = config.originalPrice;
507         uint rate = config.originalPrice/config.returnPrice;
508         if (config.total > rate) {
509             uint k = config.total - rate;
510             avgPrice = (config.total * config.originalPrice + config.returnPrice * k * (k+1) / 2) / config.total;
511         }
512         uint256 catchPrice = config.originalPrice;            
513         if (createIndex > rate) {
514             catchPrice += config.returnPrice * safeSubtract(createIndex, rate);
515         }
516         if (totalEarn >= catchPrice) {
517             return 0;
518         }
519         return ceil((catchPrice - totalEarn)*15*1000/avgPrice, 10000)/10000;
520     }
521     
522     function canLayEgg(uint64 _objId, uint32 _classId, uint32 _level) constant public returns(bool) {
523         if (_classId <= GEN0_NO) {
524             EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
525             // legends
526             if (transformData.countEgg(_objId) >= calculateMaxEggG0(_objId))
527                 return false;
528             return true;
529         } else {
530             if (layingEggLevels[_classId] == 0 || _level < layingEggLevels[_classId])
531                 return false;
532             return true;
533         }
534     }
535     
536     function layEgg(uint64 _objId) isActive requireDataContract requireTransformDataContract external {
537         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
538         // make sure no hatching egg at the same time
539         if (transformData.getHatchingEggId(msg.sender) > 0) {
540             revert();
541         }
542         
543         // can not lay egg when trading
544         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
545         if (trade.isOnTrading(_objId))
546             revert();
547         
548         // check obj 
549         EtheremonDataBase data = EtheremonDataBase(dataContract);
550         MonsterObjAcc memory obj;
551         uint32 _ = 0;
552         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
553         if (obj.monsterId != _objId || obj.trainer != msg.sender) {
554             revert();
555         }
556         
557         // check lay egg condition
558         uint8 currentLevel = getLevel(obj.exp);
559         uint8 afterLevel = 0;
560         if (!canLayEgg(_objId, obj.classId, currentLevel))
561             revert();
562         if (layingEggDeductions[obj.classId] >= currentLevel)
563             revert();
564         afterLevel = currentLevel - layingEggDeductions[obj.classId];
565 
566         // add egg 
567         uint64 eggId = transformData.addEgg(obj.monsterId, obj.classId, msg.sender, block.timestamp + (hatchStartTime + getRandom(hatchMaxTime, 0, lastHatchingAddress)) * 3600);
568         
569         // deduct exp 
570         if (afterLevel < currentLevel)
571             data.decreaseMonsterExp(_objId, obj.exp - levelExps[afterLevel-1]);
572         EventLayEgg(msg.sender, _objId, eggId);
573     }
574     
575     function hatchEgg() isActive requireDataContract requireTransformDataContract external {
576         // use as a seed for random
577         lastHatchingAddress = msg.sender;
578         
579         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
580         MonsterEgg memory egg;
581         (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(msg.sender);
582         // not hatching any egg
583         if (egg.eggId == 0 || egg.trainer != msg.sender)
584             revert();
585         // need more time
586         if (egg.newObjId > 0 || egg.hatchTime > block.timestamp) {
587             revert();
588         }
589         
590         uint64 objId = addNewObj(msg.sender, egg.classId);
591         transformData.setHatchedEgg(egg.eggId, objId);
592         EventHatchEgg(msg.sender, egg.eggId, objId);
593     }
594     
595     function removeHatchingTime() isActive requireDataContract requireTransformDataContract external payable  {
596         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
597         MonsterEgg memory egg;
598         (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(msg.sender);
599         // not hatching any egg
600         if (egg.eggId == 0 || egg.trainer != msg.sender || egg.newObjId > 0)
601             revert();
602         
603         if (msg.value != removeHatchingTimeFee) {
604             revert();
605         }
606         transformData.setHatchTime(egg.eggId, 0);
607     }
608 
609     
610     function checkAncestors(uint32 _classId, address _trainer, uint64 _a1, uint64 _a2, uint64 _a3) constant public returns(bool) {
611         EtheremonWorld world = EtheremonWorld(worldContract);
612         uint index = 0;
613         uint32 temp = 0;
614         // check ancestor
615         uint32[3] memory ancestors;
616         uint32[3] memory requestAncestors;
617         index = world.getClassPropertySize(_classId, PropertyType.ANCESTOR);
618         while (index > 0) {
619             index -= 1;
620             ancestors[index] = world.getClassPropertyValue(_classId, PropertyType.ANCESTOR, index);
621         }
622             
623         if (_a1 > 0) {
624             temp = getClassCheckOwner(_a1, _trainer);
625             if (temp == 0)
626                 return false;
627             requestAncestors[0] = temp;
628         }
629         if (_a2 > 0) {
630             temp = getClassCheckOwner(_a2, _trainer);
631             if (temp == 0)
632                 return false;
633             requestAncestors[1] = temp;
634         }
635         if (_a3 > 0) {
636             temp = getClassCheckOwner(_a3, _trainer);
637             if (temp == 0)
638                 return false;
639             requestAncestors[2] = temp;
640         }
641             
642         if (requestAncestors[0] > 0 && (requestAncestors[0] == requestAncestors[1] || requestAncestors[0] == requestAncestors[2]))
643             return false;
644         if (requestAncestors[1] > 0 && (requestAncestors[1] == requestAncestors[2]))
645             return false;
646                 
647         for (index = 0; index < ancestors.length; index++) {
648             temp = ancestors[index];
649             if (temp > 0 && temp != requestAncestors[0]  && temp != requestAncestors[1] && temp != requestAncestors[2])
650                 return false;
651         }
652         
653         return true;
654     }
655     
656     function transform(uint64 _objId, uint64 _a1, uint64 _a2, uint64 _a3) isActive requireDataContract requireTransformDataContract external payable {
657         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
658         if (transformData.getTranformedId(_objId) > 0)
659             revert();
660         
661         EtheremonBattle battle = EtheremonBattle(battleContract);
662         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
663         if (battle.isOnBattle(_objId) || trade.isOnTrading(_objId))
664             revert();
665         
666         EtheremonDataBase data = EtheremonDataBase(dataContract);
667         
668         BasicObjInfo memory objInfo;
669         (objInfo.classId, objInfo.owner, objInfo.level) = getObjClassId(_objId);
670         uint32 transformClass = transformClasses[objInfo.classId];
671         if (objInfo.classId == 0 || objInfo.owner != msg.sender)
672             revert();
673         if (transformLevels[objInfo.classId] == 0 || objInfo.level < transformLevels[objInfo.classId])
674             revert();
675         if (transformClass == 0)
676             revert();
677         
678         
679         // gen0 - can not transform if it has bonus egg 
680         if (objInfo.classId <= GEN0_NO) {
681             // legends
682             if (getBonusEgg(_objId) > 0)
683                 revert();
684         } else {
685             if (!checkAncestors(objInfo.classId, msg.sender, _a1, _a2, _a3))
686                 revert();
687         }
688         
689         uint64 newObjId = addNewObj(msg.sender, transformClass);
690         // remove old one
691         data.removeMonsterIdMapping(msg.sender, _objId);
692         transformData.setTranformed(_objId, newObjId);
693         EventTransform(msg.sender, _objId, newObjId);
694     }
695     
696     function buyEgg() isActive requireDataContract requireTransformDataContract external payable {
697         if (msg.value != buyEggFee) {
698             revert();
699         }
700         
701         if (randomClassIds.length == 0) {
702             revert();
703         }
704         
705         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
706         // make sure no hatching egg at the same time
707         if (transformData.getHatchingEggId(msg.sender) > 0) {
708             revert();
709         }
710 
711         // add random egg
712         uint8 classIndex = getRandom(uint16(randomClassIds.length), 1, lastHatchingAddress);
713         uint64 eggId = transformData.addEgg(0, randomClassIds[classIndex], msg.sender, block.timestamp + (hatchStartTime + getRandom(hatchMaxTime, 0, lastHatchingAddress)) * 3600);
714         // deduct exp
715         EventLayEgg(msg.sender, 0, eggId);
716     }
717     
718     // read
719     function getBonusEgg(uint64 _objId) constant public returns(uint) {
720         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
721         uint totalBonusEgg = calculateMaxEggG0(_objId);
722         if (totalBonusEgg > 0) {
723             return (totalBonusEgg - transformData.countEgg(_objId));
724         }
725         return 0;
726     }
727     
728 }