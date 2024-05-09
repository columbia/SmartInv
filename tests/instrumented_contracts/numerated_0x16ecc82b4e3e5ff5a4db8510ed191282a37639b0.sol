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
113 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl {
114     
115     uint64 public totalMonster;
116     uint32 public totalClass;
117     
118     // write
119     function decreaseMonsterExp(uint64 _objId, uint32 amount) external;
120     
121     // read
122     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
123     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
124     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
125     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
126     function getMonsterName(uint64 _objId) constant public returns(string name);
127     function getExtraBalance(address _trainer) constant public returns(uint256);
128     function getMonsterDexSize(address _trainer) constant public returns(uint);
129     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
130     function getExpectedBalance(address _trainer) constant public returns(uint256);
131     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
132 }
133 
134 contract EtheremonTransformData {
135     uint64 public totalEgg = 0;
136     function getHatchingEggId(address _trainer) constant external returns(uint64);
137     function getHatchingEggData(address _trainer) constant external returns(uint64, uint64, uint32, address, uint, uint64);
138     function getTranformedId(uint64 _objId) constant external returns(uint64);
139     function countEgg(uint64 _objId) constant external returns(uint);
140     
141     function setHatchTime(uint64 _eggId, uint _hatchTime) external;
142     function setHatchedEgg(uint64 _eggId, uint64 _newObjId) external;
143     function addEgg(uint64 _objId, uint32 _classId, address _trainer, uint _hatchTime) external returns(uint64);
144     function setTranformed(uint64 _objId, uint64 _newObjId) external;
145 }
146 
147 contract EtheremonWorld {
148     function getGen0COnfig(uint32 _classId) constant public returns(uint32, uint256, uint32);
149     function getTrainerEarn(address _trainer) constant public returns(uint256);
150     function getReturnFromMonster(uint64 _objId) constant public returns(uint256 current, uint256 total);
151     function getClassPropertyValue(uint32 _classId, EtheremonEnum.PropertyType _type, uint index) constant external returns(uint32);
152     function getClassPropertySize(uint32 _classId, EtheremonEnum.PropertyType _type) constant external returns(uint);
153 }
154 
155 interface EtheremonBattle {
156     function isOnBattle(uint64 _objId) constant external returns(bool);
157     function getMonsterLevel(uint64 _objId) constant public returns(uint8);
158 }
159 
160 interface EtheremonTradeInterface {
161     function isOnTrading(uint64 _objId) constant external returns(bool);
162 }
163 
164 interface EtheremonMonsterNFTInterface {
165     function mintMonster(uint32 _classId, address _trainer, string _name) external returns(uint);
166     function burnMonster(uint64 _tokenId) external;
167 }
168 
169 interface EtheremonTransformSettingInterface {
170     function getRandomClassId(uint _seed) constant external returns(uint32);
171     function getLayEggInfo(uint32 _classId) constant external returns(uint8 layingLevel, uint8 layingCost);
172     function getTransformInfo(uint32 _classId) constant external returns(uint32 transformClassId, uint8 level);
173     function getClassTransformInfo(uint32 _classId) constant external returns(uint8 layingLevel, uint8 layingCost, uint8 transformLevel, uint32 transformCLassId);
174 }
175 
176 contract EtheremonTransform is EtheremonEnum, BasicAccessControl, SafeMath {
177     uint8 constant public STAT_COUNT = 6;
178     uint8 constant public STAT_MAX = 32;
179     uint8 constant public GEN0_NO = 24;
180 
181     struct MonsterObjAcc {
182         uint64 monsterId;
183         uint32 classId;
184         address trainer;
185         string name;
186         uint32 exp;
187         uint32 createIndex;
188         uint32 lastClaimIndex;
189         uint createTime;
190     }
191     
192     struct MonsterEgg {
193         uint64 eggId;
194         uint64 objId;
195         uint32 classId;
196         address trainer;
197         uint hatchTime;
198         uint64 newObjId;
199     }
200     
201     struct BasicObjInfo {
202         uint32 classId;
203         address owner;
204         uint8 level;
205         uint32 exp;
206     }
207     
208     // Gen0 has return price & no longer can be caught when this contract is deployed
209     struct Gen0Config {
210         uint32 classId;
211         uint256 originalPrice;
212         uint256 returnPrice;
213         uint32 total; // total caught (not count those from eggs)
214     }
215     
216     // hatching range
217     uint public hatchStartTime = 2; // hour
218     uint public hatchMaxTime = 46; // hour
219     uint public removeHatchingTimeFee = 0.05 ether; // ETH
220     uint public buyEggFee = 0.09 ether; // ETH
221 
222     mapping(uint8 => uint32) public levelExps;
223     mapping(uint32 => Gen0Config) public gen0Config;
224     
225     // linked smart contract
226     address public dataContract;
227     address public worldContract;
228     address public transformDataContract;
229     address public transformSettingContract;
230     address public battleContract;
231     address public tradeContract;
232     address public monsterNFTContract;
233     
234     // events
235     event EventLayEgg(address indexed trainer, uint objId, uint eggId);
236     event EventHatchEgg(address indexed trainer, uint eggId, uint objId);
237     event EventTransform(address indexed trainer, uint oldObjId, uint newObjId);
238     
239     // constructor
240     function EtheremonTransform(address _dataContract, address _worldContract, address _transformDataContract, address _transformSettingContract,
241         address _battleContract, address _tradeContract, address _monsterNFTContract) public {
242         dataContract = _dataContract;
243         worldContract = _worldContract;
244         transformDataContract = _transformDataContract;
245         transformSettingContract = _transformSettingContract;
246         battleContract = _battleContract;
247         tradeContract = _tradeContract;
248         monsterNFTContract = _monsterNFTContract;
249     }
250     
251     // helper
252     function getRandom(address _player, uint _block, uint64 _count) constant public returns(uint) {
253         return uint(keccak256(block.blockhash(_block), _player, _count));
254     }
255     
256     // admin & moderators
257     function setContract(address _dataContract, address _worldContract, address _transformDataContract, address _transformSettingContract,
258         address _battleContract, address _tradeContract, address _monsterNFTContract) onlyModerators external {
259         dataContract = _dataContract;
260         worldContract = _worldContract;
261         transformDataContract = _transformDataContract;
262         transformSettingContract = _transformSettingContract;
263         battleContract = _battleContract;
264         tradeContract = _tradeContract;
265         monsterNFTContract = _monsterNFTContract;
266     }
267 
268     function setOriginalPriceGen0() onlyModerators external {
269         gen0Config[1] = Gen0Config(1, 0.3 ether, 0.003 ether, 374);
270         gen0Config[2] = Gen0Config(2, 0.3 ether, 0.003 ether, 408);
271         gen0Config[3] = Gen0Config(3, 0.3 ether, 0.003 ether, 373);
272         gen0Config[4] = Gen0Config(4, 0.2 ether, 0.002 ether, 437);
273         gen0Config[5] = Gen0Config(5, 0.1 ether, 0.001 ether, 497);
274         gen0Config[6] = Gen0Config(6, 0.3 ether, 0.003 ether, 380); 
275         gen0Config[7] = Gen0Config(7, 0.2 ether, 0.002 ether, 345);
276         gen0Config[8] = Gen0Config(8, 0.1 ether, 0.001 ether, 518); 
277         gen0Config[9] = Gen0Config(9, 0.1 ether, 0.001 ether, 447);
278         gen0Config[10] = Gen0Config(10, 0.2 ether, 0.002 ether, 380); 
279         gen0Config[11] = Gen0Config(11, 0.2 ether, 0.002 ether, 354);
280         gen0Config[12] = Gen0Config(12, 0.2 ether, 0.002 ether, 346);
281         gen0Config[13] = Gen0Config(13, 0.2 ether, 0.002 ether, 351); 
282         gen0Config[14] = Gen0Config(14, 0.2 ether, 0.002 ether, 338);
283         gen0Config[15] = Gen0Config(15, 0.2 ether, 0.002 ether, 341);
284         gen0Config[16] = Gen0Config(16, 0.35 ether, 0.0035 ether, 384);
285         gen0Config[17] = Gen0Config(17, 1 ether, 0.01 ether, 305); 
286         gen0Config[18] = Gen0Config(18, 0.1 ether, 0.001 ether, 427);
287         gen0Config[19] = Gen0Config(19, 1 ether, 0.01 ether, 304);
288         gen0Config[20] = Gen0Config(20, 0.4 ether, 0.05 ether, 82);
289         gen0Config[21] = Gen0Config(21, 1, 1, 123);
290         gen0Config[22] = Gen0Config(22, 0.2 ether, 0.001 ether, 468);
291         gen0Config[23] = Gen0Config(23, 0.5 ether, 0.0025 ether, 302);
292         gen0Config[24] = Gen0Config(24, 1 ether, 0.005 ether, 195);
293     } 
294 
295     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
296         // no user money is kept in this contract, only trasaction fee
297         if (_amount > this.balance) {
298             revert();
299         }
300         _sendTo.transfer(_amount);
301     }
302     
303     function setConfig(uint _removeHatchingTimeFee, uint _buyEggFee, uint _hatchStartTime, uint _hatchMaxTime) onlyModerators external {
304         removeHatchingTimeFee = _removeHatchingTimeFee;
305         buyEggFee = _buyEggFee;
306         hatchStartTime = _hatchStartTime;
307         hatchMaxTime = _hatchMaxTime;
308     }
309 
310     function genLevelExp() onlyModerators external {
311         uint8 level = 1;
312         uint32 requirement = 100;
313         uint32 sum = requirement;
314         while(level <= 100) {
315             levelExps[level] = sum;
316             level += 1;
317             requirement = (requirement * 11) / 10 + 5;
318             sum += requirement;
319         }
320     }
321     
322     function removeHatchingTimeWithToken(address _trainer) isActive onlyModerators external {
323         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
324         MonsterEgg memory egg;
325         (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(_trainer);
326         // not hatching any egg
327         if (egg.eggId == 0 || egg.trainer != _trainer || egg.newObjId > 0)
328             revert();
329         
330         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
331         uint objId = monsterNFT.mintMonster(egg.classId, egg.trainer, "..name me...");
332         transformData.setHatchedEgg(egg.eggId, uint64(objId));
333         EventHatchEgg(egg.trainer, egg.eggId, objId);
334     }    
335     
336     function buyEggWithToken(address _trainer) isActive onlyModerators external {
337         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
338         // make sure no hatching egg at the same time
339         if (transformData.getHatchingEggId(_trainer) > 0) {
340             revert();
341         }
342 
343         // add random egg
344         uint seed = getRandom(_trainer, block.number - 1, transformData.totalEgg());
345         uint32 classId = EtheremonTransformSettingInterface(transformSettingContract).getRandomClassId(seed);
346         if (classId == 0) revert();
347         uint64 eggId = transformData.addEgg(0, classId, _trainer, block.timestamp + (hatchStartTime + seed % hatchMaxTime) * 3600);
348         // deduct exp
349         EventLayEgg(_trainer, 0, eggId);
350     }
351     
352     // public
353 
354     function ceil(uint a, uint m) pure public returns (uint) {
355         return ((a + m - 1) / m) * m;
356     }
357 
358     function getLevel(uint32 exp) view public returns (uint8) {
359         uint8 minIndex = 1;
360         uint8 maxIndex = 100;
361         uint8 currentIndex;
362      
363         while (minIndex < maxIndex) {
364             currentIndex = (minIndex + maxIndex) / 2;
365             if (exp < levelExps[currentIndex])
366                 maxIndex = currentIndex;
367             else
368                 minIndex = currentIndex + 1;
369         }
370 
371         return minIndex;
372     }
373 
374     function getGen0ObjInfo(uint64 _objId) constant public returns(uint32, uint32, uint256) {
375         EtheremonDataBase data = EtheremonDataBase(dataContract);
376         
377         MonsterObjAcc memory obj;
378         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
379         
380         Gen0Config memory gen0 = gen0Config[obj.classId];
381         if (gen0.classId != obj.classId) {
382             return (gen0.classId, obj.createIndex, 0);
383         }
384         
385         uint32 totalGap = 0;
386         if (obj.createIndex < gen0.total)
387             totalGap = gen0.total - obj.createIndex;
388         
389         return (obj.classId, obj.createIndex, safeMult(totalGap, gen0.returnPrice));
390     }
391     
392     function getObjClassExp(uint64 _objId) constant public returns(uint32, address, uint32) {
393         EtheremonDataBase data = EtheremonDataBase(dataContract);
394         MonsterObjAcc memory obj;
395         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
396         return (obj.classId, obj.trainer, obj.exp);
397     }
398     
399     function getClassCheckOwner(uint64 _objId, address _trainer) constant public returns(uint32) {
400         EtheremonDataBase data = EtheremonDataBase(dataContract);
401         MonsterObjAcc memory obj;
402         uint32 _ = 0;
403         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
404         if (_trainer != obj.trainer)
405             return 0;
406         return obj.classId;
407     }
408 
409     function calculateMaxEggG0(uint64 _objId) constant public returns(uint) {
410         uint32 classId;
411         uint32 createIndex; 
412         uint256 totalEarn;
413         (classId, createIndex, totalEarn) = getGen0ObjInfo(_objId);
414         if (classId > GEN0_NO || classId == 20 || classId == 21)
415             return 0;
416         
417         Gen0Config memory config = gen0Config[classId];
418         // the one from egg can not lay
419         if (createIndex > config.total)
420             return 0;
421 
422         // calculate agv price
423         uint256 avgPrice = config.originalPrice;
424         uint rate = config.originalPrice/config.returnPrice;
425         if (config.total > rate) {
426             uint k = config.total - rate;
427             avgPrice = (config.total * config.originalPrice + config.returnPrice * k * (k+1) / 2) / config.total;
428         }
429         uint256 catchPrice = config.originalPrice;            
430         if (createIndex > rate) {
431             catchPrice += config.returnPrice * safeSubtract(createIndex, rate);
432         }
433         if (totalEarn >= catchPrice) {
434             return 0;
435         }
436         return ceil((catchPrice - totalEarn)*15*1000/avgPrice, 10000)/10000;
437     }
438     
439     function layEgg(uint64 _objId) isActive external {
440         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
441         // make sure no hatching egg at the same time
442         if (transformData.getHatchingEggId(msg.sender) > 0) {
443             revert();
444         }
445         
446         // can not lay egg when trading
447         if (EtheremonTradeInterface(tradeContract).isOnTrading(_objId))
448             revert();
449         
450         // check obj 
451         uint32 classId;
452         address owner;
453         uint32 exp;
454         uint8 currentLevel;
455         (classId, owner, exp) = getObjClassExp(_objId);
456         currentLevel = getLevel(exp);
457         if (classId == 0 || owner != msg.sender) {
458             revert();
459         }
460         
461         // check lay egg condition
462         uint8 temp = 0;
463         
464         if (classId <= GEN0_NO) {
465             // legends
466             if (transformData.countEgg(_objId) >= calculateMaxEggG0(_objId))
467                 revert();
468             temp = currentLevel;
469         } else {
470             uint8 layingLevel;
471             (layingLevel, temp) = EtheremonTransformSettingInterface(transformSettingContract).getLayEggInfo(classId);
472             if (layingLevel == 0 || currentLevel < layingLevel || currentLevel < temp)
473                 revert();
474             temp = currentLevel - temp;
475         }
476         
477         // add egg 
478         uint seed = getRandom(msg.sender, block.number - 1, transformData.totalEgg());
479         uint64 eggId = transformData.addEgg(_objId, classId, msg.sender, block.timestamp + (hatchStartTime + seed % hatchMaxTime) * 3600);
480         
481         // deduct exp 
482         if (temp < currentLevel) {
483             EtheremonDataBase data = EtheremonDataBase(dataContract);
484             data.decreaseMonsterExp(_objId, exp - levelExps[temp-1]);
485         }
486         EventLayEgg(msg.sender, _objId, eggId);
487     }
488     
489     function hatchEgg() isActive external {
490         // use as a seed for random
491         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
492         MonsterEgg memory egg;
493         (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(msg.sender);
494         // not hatching any egg
495         if (egg.eggId == 0 || egg.trainer != msg.sender)
496             revert();
497         // need more time
498         if (egg.newObjId > 0 || egg.hatchTime > block.timestamp) {
499             revert();
500         }
501         
502         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
503         uint objId = monsterNFT.mintMonster(egg.classId, egg.trainer, "..name me...");
504         transformData.setHatchedEgg(egg.eggId, uint64(objId));
505         EventHatchEgg(egg.trainer, egg.eggId, objId);
506     }
507     
508     function removeHatchingTime() isActive external payable  {
509         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
510         MonsterEgg memory egg;
511         (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(msg.sender);
512         // not hatching any egg
513         if (egg.eggId == 0 || egg.trainer != msg.sender || egg.newObjId > 0)
514             revert();
515         
516         if (msg.value != removeHatchingTimeFee) {
517             revert();
518         }
519         
520         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
521         uint objId = monsterNFT.mintMonster(egg.classId, egg.trainer, "..name me...");
522         transformData.setHatchedEgg(egg.eggId, uint64(objId));
523         EventHatchEgg(egg.trainer, egg.eggId, objId);
524     }
525 
526     
527     function checkAncestors(uint32 _classId, address _trainer, uint64 _a1, uint64 _a2, uint64 _a3) constant public returns(bool) {
528         EtheremonWorld world = EtheremonWorld(worldContract);
529         uint index = 0;
530         uint32 temp = 0;
531         // check ancestor
532         uint32[3] memory ancestors;
533         uint32[3] memory requestAncestors;
534         index = world.getClassPropertySize(_classId, PropertyType.ANCESTOR);
535         while (index > 0) {
536             index -= 1;
537             ancestors[index] = world.getClassPropertyValue(_classId, PropertyType.ANCESTOR, index);
538         }
539             
540         if (_a1 > 0) {
541             temp = getClassCheckOwner(_a1, _trainer);
542             if (temp == 0)
543                 return false;
544             requestAncestors[0] = temp;
545         }
546         if (_a2 > 0) {
547             temp = getClassCheckOwner(_a2, _trainer);
548             if (temp == 0)
549                 return false;
550             requestAncestors[1] = temp;
551         }
552         if (_a3 > 0) {
553             temp = getClassCheckOwner(_a3, _trainer);
554             if (temp == 0)
555                 return false;
556             requestAncestors[2] = temp;
557         }
558             
559         if (requestAncestors[0] > 0 && (requestAncestors[0] == requestAncestors[1] || requestAncestors[0] == requestAncestors[2]))
560             return false;
561         if (requestAncestors[1] > 0 && (requestAncestors[1] == requestAncestors[2]))
562             return false;
563                 
564         for (index = 0; index < ancestors.length; index++) {
565             temp = ancestors[index];
566             if (temp > 0 && temp != requestAncestors[0]  && temp != requestAncestors[1] && temp != requestAncestors[2])
567                 return false;
568         }
569         
570         return true;
571     }
572     
573     function transform(uint64 _objId, uint64 _a1, uint64 _a2, uint64 _a3) isActive external payable {
574         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
575         if (transformData.getTranformedId(_objId) > 0)
576             revert();
577         
578         EtheremonBattle battle = EtheremonBattle(battleContract);
579         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
580         if (battle.isOnBattle(_objId) || trade.isOnTrading(_objId))
581             revert();
582         
583         BasicObjInfo memory objInfo;
584         (objInfo.classId, objInfo.owner, objInfo.exp) = getObjClassExp(_objId);
585         objInfo.level = getLevel(objInfo.exp);
586         if (objInfo.classId == 0 || objInfo.owner != msg.sender)
587             revert();
588         
589         uint32 transformClass;
590         uint8 transformLevel;
591         (transformClass, transformLevel) = EtheremonTransformSettingInterface(transformSettingContract).getTransformInfo(objInfo.classId);
592         if (transformClass == 0 || transformLevel == 0) revert();
593         if (objInfo.level < transformLevel) revert();
594         
595         // gen0 - can not transform if it has bonus egg 
596         if (objInfo.classId <= GEN0_NO) {
597             // legends
598             if (getBonusEgg(_objId) > 0)
599                 revert();
600         } else {
601             if (!checkAncestors(objInfo.classId, msg.sender, _a1, _a2, _a3))
602                 revert();
603         }
604         
605         
606         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
607         uint newObjId = monsterNFT.mintMonster(transformClass, msg.sender, "..name me...");
608         monsterNFT.burnMonster(_objId);
609 
610         transformData.setTranformed(_objId, uint64(newObjId));
611         EventTransform(msg.sender, _objId, newObjId);
612     }
613     
614     function buyEgg() isActive external payable {
615         if (msg.value != buyEggFee) {
616             revert();
617         }
618         
619         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
620         // make sure no hatching egg at the same time
621         if (transformData.getHatchingEggId(msg.sender) > 0) {
622             revert();
623         }
624         
625         // add random egg
626         uint seed = getRandom(msg.sender, block.number - 1, transformData.totalEgg());
627         uint32 classId = EtheremonTransformSettingInterface(transformSettingContract).getRandomClassId(seed);
628         if (classId == 0) revert();
629         uint64 eggId = transformData.addEgg(0, classId, msg.sender, block.timestamp + (hatchStartTime + seed % hatchMaxTime) * 3600);
630         // deduct exp
631         EventLayEgg(msg.sender, 0, eggId);
632     }
633     
634     // read
635     function getBonusEgg(uint64 _objId) constant public returns(uint) {
636         EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);
637         uint totalBonusEgg = calculateMaxEggG0(_objId);
638         if (totalBonusEgg > 0) {
639             return (totalBonusEgg - transformData.countEgg(_objId));
640         }
641         return 0;
642     }
643 }