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
50         require(moderators[msg.sender] == true);
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
65     function AddModerator(address _newModerator) onlyOwner public {
66         if (moderators[_newModerator] == false) {
67             moderators[_newModerator] = true;
68             totalModerators += 1;
69         }
70     }
71     
72     function RemoveModerator(address _oldModerator) onlyOwner public {
73         if (moderators[_oldModerator] == true) {
74             moderators[_oldModerator] = false;
75             totalModerators -= 1;
76         }
77     }
78     
79     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
80         isMaintaining = _isMaintaining;
81     }
82 }
83 
84 contract EtheremonEnum {
85 
86     enum ResultCode {
87         SUCCESS,
88         ERROR_CLASS_NOT_FOUND,
89         ERROR_LOW_BALANCE,
90         ERROR_SEND_FAIL,
91         ERROR_NOT_TRAINER,
92         ERROR_NOT_ENOUGH_MONEY,
93         ERROR_INVALID_AMOUNT
94     }
95     
96     enum ArrayType {
97         CLASS_TYPE,
98         STAT_STEP,
99         STAT_START,
100         STAT_BASE,
101         OBJ_SKILL
102     }
103     
104     enum PropertyType {
105         ANCESTOR,
106         XFACTOR
107     }
108 }
109 
110 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
111     
112     uint64 public totalMonster;
113     uint32 public totalClass;
114     
115     // write
116     function withdrawEther(address _sendTo, uint _amount) onlyOwner public returns(ResultCode);
117     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
118     function updateIndexOfArrayType(ArrayType _type, uint64 _id, uint _index, uint8 _value) onlyModerators public returns(uint);
119     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);
120     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);
121     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;
122     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
123     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
124     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
125     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
126     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);
127     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);
128     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);
129     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
130     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
131     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;
132     
133     // read
134     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
135     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
136     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
137     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
138     function getMonsterName(uint64 _objId) constant public returns(string name);
139     function getExtraBalance(address _trainer) constant public returns(uint256);
140     function getMonsterDexSize(address _trainer) constant public returns(uint);
141     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
142     function getExpectedBalance(address _trainer) constant public returns(uint256);
143     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
144 }
145 
146 contract EtheremonGateway is EtheremonEnum, BasicAccessControl {
147     // using for battle contract later
148     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
149     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
150     
151     // read 
152     function isGason(uint64 _objId) constant external returns(bool);
153     function getObjBattleInfo(uint64 _objId) constant external returns(uint32 classId, uint32 exp, bool isGason, 
154         uint ancestorLength, uint xfactorsLength);
155     function getClassPropertySize(uint32 _classId, PropertyType _type) constant external returns(uint);
156     function getClassPropertyValue(uint32 _classId, PropertyType _type, uint index) constant external returns(uint32);
157 }
158 
159 contract EtheremonWorld is EtheremonGateway, SafeMath {
160     // old processor
161     address constant public ETHEREMON_PROCESSOR = address(0x8a60806F05876f4d6dB00c877B0558DbCAD30682);
162     uint8 constant public STAT_COUNT = 6;
163     uint8 constant public STAT_MAX = 32;
164     uint8 constant public GEN0_NO = 24;
165     
166     struct MonsterClassAcc {
167         uint32 classId;
168         uint256 price;
169         uint256 returnPrice;
170         uint32 total;
171         bool catchable;
172     }
173 
174     struct MonsterObjAcc {
175         uint64 monsterId;
176         uint32 classId;
177         address trainer;
178         string name;
179         uint32 exp;
180         uint32 createIndex;
181         uint32 lastClaimIndex;
182         uint createTime;
183     }
184     
185     // Gen0 has return price & no longer can be caught when this contract is deployed
186     struct Gen0Config {
187         uint32 classId;
188         uint256 originalPrice;
189         uint256 returnPrice;
190         uint32 total; // total caught (not count those from eggs)
191     }
192     
193     struct GenXProperty {
194         uint32 classId;
195         bool isGason;
196         uint32[] ancestors;
197         uint32[] xfactors;
198     }
199     
200     mapping(uint32 => Gen0Config) public gen0Config;
201     mapping(uint32 => GenXProperty) public genxProperty;
202     uint256 public totalCashout = 0; // for admin
203     uint256 public totalEarn = 0; // exclude gen 0
204     uint16 public priceIncreasingRatio = 1000;
205     uint public maxDexSize = 500;
206     
207     address private lastHunter = address(0x0);
208 
209     // data contract
210     address public dataContract;
211     
212     // event
213     event EventCatchMonster(address indexed trainer, uint64 objId);
214     event EventCashOut(address indexed trainer, ResultCode result, uint256 amount);
215     event EventWithdrawEther(address indexed sendTo, ResultCode result, uint256 amount);
216     
217     function EtheremonWorld(address _dataContract) public {
218         dataContract = _dataContract;
219     }
220     
221      // admin & moderators
222     function setMaxDexSize(uint _value) onlyModerators external {
223         maxDexSize = _value;
224     }
225     
226     function setOriginalPriceGen0() onlyModerators external {
227         gen0Config[1] = Gen0Config(1, 0.3 ether, 0.003 ether, 374);
228         gen0Config[2] = Gen0Config(2, 0.3 ether, 0.003 ether, 408);
229         gen0Config[3] = Gen0Config(3, 0.3 ether, 0.003 ether, 373);
230         gen0Config[4] = Gen0Config(4, 0.2 ether, 0.002 ether, 437);
231         gen0Config[5] = Gen0Config(5, 0.1 ether, 0.001 ether, 497);
232         gen0Config[6] = Gen0Config(6, 0.3 ether, 0.003 ether, 380); 
233         gen0Config[7] = Gen0Config(7, 0.2 ether, 0.002 ether, 345);
234         gen0Config[8] = Gen0Config(8, 0.1 ether, 0.001 ether, 518); 
235         gen0Config[9] = Gen0Config(9, 0.1 ether, 0.001 ether, 447);
236         gen0Config[10] = Gen0Config(10, 0.2 ether, 0.002 ether, 380); 
237         gen0Config[11] = Gen0Config(11, 0.2 ether, 0.002 ether, 354);
238         gen0Config[12] = Gen0Config(12, 0.2 ether, 0.002 ether, 346);
239         gen0Config[13] = Gen0Config(13, 0.2 ether, 0.002 ether, 351); 
240         gen0Config[14] = Gen0Config(14, 0.2 ether, 0.002 ether, 338);
241         gen0Config[15] = Gen0Config(15, 0.2 ether, 0.002 ether, 341);
242         gen0Config[16] = Gen0Config(16, 0.35 ether, 0.0035 ether, 384);
243         gen0Config[17] = Gen0Config(17, 0.1 ether, 0.001 ether, 305); 
244         gen0Config[18] = Gen0Config(18, 0.1 ether, 0.001 ether, 427);
245         gen0Config[19] = Gen0Config(19, 0.1 ether, 0.001 ether, 304);
246         gen0Config[20] = Gen0Config(20, 0.4 ether, 0.005 ether, 82);
247         gen0Config[21] = Gen0Config(21, 1, 1, 123);
248         gen0Config[22] = Gen0Config(22, 0.2 ether, 0.001 ether, 468);
249         gen0Config[23] = Gen0Config(23, 0.5 ether, 0.0025 ether, 302);
250         gen0Config[24] = Gen0Config(24, 1 ether, 0.005 ether, 195);
251     }
252 
253     function getEarningAmount() constant public returns(uint256) {
254         // calculate value for gen0
255         uint256 totalValidAmount = 0;
256         for (uint32 classId=1; classId <= GEN0_NO; classId++) {
257             // make sure there is a class
258             Gen0Config storage gen0 = gen0Config[classId];
259             if (gen0.total >0 && gen0.classId == classId && gen0.originalPrice > 0 && gen0.returnPrice > 0) {
260                 uint256 rate = gen0.originalPrice/gen0.returnPrice;
261                 if (rate < gen0.total) {
262                     totalValidAmount += (gen0.originalPrice + gen0.returnPrice) * rate / 2;
263                     totalValidAmount += (gen0.total - rate) * gen0.returnPrice;
264                 } else {
265                     totalValidAmount += (gen0.originalPrice + gen0.returnPrice * (rate - gen0.total + 1)) / 2 * gen0.total;
266                 }
267             }
268         }
269         
270         // add in earn from genx
271         totalValidAmount = safeAdd(totalValidAmount, totalEarn);
272         // deduct amount of cashing out 
273         totalValidAmount = safeSubtract(totalValidAmount, totalCashout);
274         
275         return totalValidAmount;
276     }
277     
278     function withdrawEther(address _sendTo, uint _amount) onlyModerators external returns(ResultCode) {
279         if (_amount > this.balance) {
280             EventWithdrawEther(_sendTo, ResultCode.ERROR_INVALID_AMOUNT, 0);
281             return ResultCode.ERROR_INVALID_AMOUNT;
282         }
283         
284         uint256 totalValidAmount = getEarningAmount();
285         if (_amount > totalValidAmount) {
286             EventWithdrawEther(_sendTo, ResultCode.ERROR_INVALID_AMOUNT, 0);
287             return ResultCode.ERROR_INVALID_AMOUNT;
288         }
289         
290         _sendTo.transfer(_amount);
291         totalCashout += _amount;
292         EventWithdrawEther(_sendTo, ResultCode.SUCCESS, _amount);
293         return ResultCode.SUCCESS;
294     }
295 
296     // convenient tool to add monster
297     function addMonsterClassBasic(uint32 _classId, uint8 _type, uint256 _price, uint256 _returnPrice,
298         uint8 _ss1, uint8 _ss2, uint8 _ss3, uint8 _ss4, uint8 _ss5, uint8 _ss6) onlyModerators external {
299         
300         EtheremonDataBase data = EtheremonDataBase(dataContract);
301         MonsterClassAcc memory class;
302         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
303         // can add only one time
304         if (_classId == 0 || class.classId == _classId)
305             revert();
306 
307         data.setMonsterClass(_classId, _price, _returnPrice, true);
308         data.addElementToArrayType(ArrayType.CLASS_TYPE, uint64(_classId), _type);
309         
310         // add stat step
311         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss1);
312         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss2);
313         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss3);
314         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss4);
315         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss5);
316         data.addElementToArrayType(ArrayType.STAT_START, uint64(_classId), _ss6);
317         
318     }
319     
320     function addMonsterClassExtend(uint32 _classId, uint8 _type2, uint8 _type3, 
321         uint8 _st1, uint8 _st2, uint8 _st3, uint8 _st4, uint8 _st5, uint8 _st6 ) onlyModerators external {
322 
323         EtheremonDataBase data = EtheremonDataBase(dataContract);
324         if (_classId == 0 || data.getSizeArrayType(ArrayType.STAT_STEP, uint64(_classId)) > 0)
325             revert();
326 
327         if (_type2 > 0) {
328             data.addElementToArrayType(ArrayType.CLASS_TYPE, uint64(_classId), _type2);
329         }
330         if (_type3 > 0) {
331             data.addElementToArrayType(ArrayType.CLASS_TYPE, uint64(_classId), _type3);
332         }
333         
334         // add stat base
335         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st1);
336         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st2);
337         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st3);
338         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st4);
339         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st5);
340         data.addElementToArrayType(ArrayType.STAT_STEP, uint64(_classId), _st6);
341     }
342     
343     function setCatchable(uint32 _classId, bool catchable) onlyModerators external {
344         // can not edit gen 0 - can not catch forever
345         Gen0Config storage gen0 = gen0Config[_classId];
346         if (gen0.classId == _classId)
347             revert();
348         
349         EtheremonDataBase data = EtheremonDataBase(dataContract);
350         MonsterClassAcc memory class;
351         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
352         data.setMonsterClass(class.classId, class.price, class.returnPrice, catchable);
353     }
354     
355     function setPriceIncreasingRatio(uint16 _ratio) onlyModerators external {
356         priceIncreasingRatio = _ratio;
357     }
358     
359     function setGason(uint32 _classId, bool _isGason) onlyModerators external {
360         GenXProperty storage pro = genxProperty[_classId];
361         pro.isGason = _isGason;
362     }
363     
364     function addClassProperty(uint32 _classId, PropertyType _type, uint32 value) onlyModerators external {
365         GenXProperty storage pro = genxProperty[_classId];
366         pro.classId = _classId;
367         if (_type == PropertyType.ANCESTOR) {
368             pro.ancestors.push(value);
369         } else {
370             pro.xfactors.push(value);
371         }
372     }
373     
374     // gate way 
375     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public {
376         EtheremonDataBase data = EtheremonDataBase(dataContract);
377         data.increaseMonsterExp(_objId, amount);
378     }
379     
380     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public {
381         EtheremonDataBase data = EtheremonDataBase(dataContract);
382         data.decreaseMonsterExp(_objId, amount);
383     }
384     
385     // helper
386     function getRandom(uint8 maxRan, uint8 index, address priAddress) constant public returns(uint8) {
387         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);
388         for (uint8 i = 0; i < index && i < 6; i ++) {
389             genNum /= 256;
390         }
391         return uint8(genNum % maxRan);
392     }
393     
394     function () payable public {
395         if (msg.sender != ETHEREMON_PROCESSOR)
396             revert();
397     }
398     
399     // public
400     
401     function isGason(uint64 _objId) constant external returns(bool) {
402         EtheremonDataBase data = EtheremonDataBase(dataContract);
403         MonsterObjAcc memory obj;
404         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
405         GenXProperty storage pro = genxProperty[obj.classId];
406         return pro.isGason;
407     }
408     
409     function getObjIndex(uint64 _objId) constant public returns(uint32 classId, uint32 createIndex, uint32 lastClaimIndex) {
410         EtheremonDataBase data = EtheremonDataBase(dataContract);
411         MonsterObjAcc memory obj;
412         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
413         return (obj.classId, obj.createIndex, obj.lastClaimIndex);
414     }
415     
416     function getObjBattleInfo(uint64 _objId) constant external returns(uint32 classId, uint32 exp, bool isGason, 
417         uint ancestorLength, uint xfactorsLength) {
418         EtheremonDataBase data = EtheremonDataBase(dataContract);
419         MonsterObjAcc memory obj;
420         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
421         GenXProperty storage pro = genxProperty[obj.classId];
422         return (obj.classId, obj.exp, pro.isGason, pro.ancestors.length, pro.xfactors.length);
423     }
424     
425     function getClassPropertySize(uint32 _classId, PropertyType _type) constant external returns(uint) {
426         if (_type == PropertyType.ANCESTOR) 
427             return genxProperty[_classId].ancestors.length;
428         else
429             return genxProperty[_classId].xfactors.length;
430     }
431     
432     function getClassPropertyValue(uint32 _classId, PropertyType _type, uint index) constant external returns(uint32) {
433         if (_type == PropertyType.ANCESTOR)
434             return genxProperty[_classId].ancestors[index];
435         else
436             return genxProperty[_classId].xfactors[index];
437     }
438     
439     // only gen 0
440     function getGen0COnfig(uint32 _classId) constant public returns(uint32, uint256, uint32) {
441         Gen0Config storage gen0 = gen0Config[_classId];
442         return (gen0.classId, gen0.originalPrice, gen0.total);
443     }
444     
445     // only gen 0
446     function getReturnFromMonster(uint64 _objId) constant public returns(uint256 current, uint256 total) {
447         /*
448         1. Gen 0 can not be caught anymore.
449         2. Egg will not give return.
450         */
451         
452         uint32 classId = 0;
453         uint32 createIndex = 0;
454         uint32 lastClaimIndex = 0;
455         (classId, createIndex, lastClaimIndex) = getObjIndex(_objId);
456         Gen0Config storage gen0 = gen0Config[classId];
457         if (gen0.classId != classId) {
458             return (0, 0);
459         }
460         
461         uint32 currentGap = 0;
462         uint32 totalGap = 0;
463         if (lastClaimIndex < gen0.total)
464             currentGap = gen0.total - lastClaimIndex;
465         if (createIndex < gen0.total)
466             totalGap = gen0.total - createIndex;
467         return (safeMult(currentGap, gen0.returnPrice), safeMult(totalGap, gen0.returnPrice));
468     }
469     
470     // write access
471     
472     function moveDataContractBalanceToWorld() external {
473         EtheremonDataBase data = EtheremonDataBase(dataContract);
474         data.withdrawEther(address(this), data.balance);
475     }
476     
477     function renameMonster(uint64 _objId, string name) isActive external {
478         EtheremonDataBase data = EtheremonDataBase(dataContract);
479         MonsterObjAcc memory obj;
480         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
481         if (obj.monsterId != _objId || obj.trainer != msg.sender) {
482             revert();
483         }
484         data.setMonsterObj(_objId, name, obj.exp, obj.createIndex, obj.lastClaimIndex);
485     }
486     
487     function catchMonster(uint32 _classId, string _name) isActive external payable {
488         EtheremonDataBase data = EtheremonDataBase(dataContract);
489         MonsterClassAcc memory class;
490         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
491         
492         if (class.classId == 0 || class.catchable == false) {
493             revert();
494         }
495         
496         // can not keep too much etheremon 
497         if (data.getMonsterDexSize(msg.sender) > maxDexSize)
498             revert();
499         
500         uint256 totalBalance = safeAdd(msg.value, data.getExtraBalance(msg.sender));
501         uint256 payPrice = class.price;
502         // increase price for each etheremon created
503         if (class.total > 0)
504             payPrice += class.price*(class.total-1)/priceIncreasingRatio;
505         if (payPrice > totalBalance) {
506             revert();
507         }
508         totalEarn += payPrice;
509         
510         // deduct the balance
511         data.setExtraBalance(msg.sender, safeSubtract(totalBalance, payPrice));
512         
513         // add monster
514         uint64 objId = data.addMonsterObj(_classId, msg.sender, _name);
515         // generate base stat for the previous one
516         for (uint i=0; i < STAT_COUNT; i+= 1) {
517             uint8 value = getRandom(STAT_MAX, uint8(i), lastHunter) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);
518             data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);
519         }
520         
521         lastHunter = msg.sender;
522         EventCatchMonster(msg.sender, objId);
523     }
524 
525 
526     function cashOut(uint256 _amount) public returns(ResultCode) {
527         EtheremonDataBase data = EtheremonDataBase(dataContract);
528         
529         uint256 totalAmount = data.getExtraBalance(msg.sender);
530         uint64 objId = 0;
531 
532         // collect gen 0 return price 
533         uint dexSize = data.getMonsterDexSize(msg.sender);
534         for (uint i = 0; i < dexSize; i++) {
535             objId = data.getMonsterObjId(msg.sender, i);
536             if (objId > 0) {
537                 MonsterObjAcc memory obj;
538                 (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(objId);
539                 Gen0Config storage gen0 = gen0Config[obj.classId];
540                 if (gen0.classId == obj.classId) {
541                     if (obj.lastClaimIndex < gen0.total) {
542                         uint32 gap = uint32(safeSubtract(gen0.total, obj.lastClaimIndex));
543                         if (gap > 0) {
544                             totalAmount += safeMult(gap, gen0.returnPrice);
545                             // reset total (except name is cleared :( )
546                             data.setMonsterObj(obj.monsterId, " name me ", obj.exp, obj.createIndex, gen0.total);
547                         }
548                     }
549                 }
550             }
551         }
552         
553         // default to cash out all
554         if (_amount == 0) {
555             _amount = totalAmount;
556         }
557         if (_amount > totalAmount) {
558             revert();
559         }
560         
561         // check contract has enough money
562         if (this.balance + data.balance < _amount){
563             revert();
564         } else if (this.balance < _amount) {
565             data.withdrawEther(address(this), data.balance);
566         }
567         
568         if (_amount > 0) {
569             data.setExtraBalance(msg.sender, totalAmount - _amount);
570             if (!msg.sender.send(_amount)) {
571                 data.setExtraBalance(msg.sender, totalAmount);
572                 EventCashOut(msg.sender, ResultCode.ERROR_SEND_FAIL, 0);
573                 return ResultCode.ERROR_SEND_FAIL;
574             }
575         }
576         
577         EventCashOut(msg.sender, ResultCode.SUCCESS, _amount);
578         return ResultCode.SUCCESS;
579     }
580     
581     // read access
582     
583     function getTrainerEarn(address _trainer) constant public returns(uint256) {
584         EtheremonDataBase data = EtheremonDataBase(dataContract);
585         uint256 returnFromMonster = 0;
586         // collect gen 0 return price 
587         uint256 gen0current = 0;
588         uint256 gen0total = 0;
589         uint64 objId = 0;
590         uint dexSize = data.getMonsterDexSize(_trainer);
591         for (uint i = 0; i < dexSize; i++) {
592             objId = data.getMonsterObjId(_trainer, i);
593             if (objId > 0) {
594                 (gen0current, gen0total) = getReturnFromMonster(objId);
595                 returnFromMonster += gen0current;
596             }
597         }
598         return returnFromMonster;
599     }
600     
601     function getTrainerBalance(address _trainer) constant external returns(uint256) {
602         EtheremonDataBase data = EtheremonDataBase(dataContract);
603         
604         uint256 userExtraBalance = data.getExtraBalance(_trainer);
605         uint256 returnFromMonster = getTrainerEarn(_trainer);
606 
607         return (userExtraBalance + returnFromMonster);
608     }
609     
610     function getMonsterClassBasic(uint32 _classId) constant external returns(uint256, uint256, uint256, bool) {
611         EtheremonDataBase data = EtheremonDataBase(dataContract);
612         MonsterClassAcc memory class;
613         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
614         return (class.price, class.returnPrice, class.total, class.catchable);
615     }
616 
617 }