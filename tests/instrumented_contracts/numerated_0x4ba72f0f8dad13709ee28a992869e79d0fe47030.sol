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
106 }
107 
108 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
109     
110     uint64 public totalMonster;
111     uint32 public totalClass;
112     
113     // write
114     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
115     function removeElementOfArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
116     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);
117     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);
118     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;
119     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
120     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
121     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
122     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
123     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);
124     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);
125     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);
126     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
127     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
128     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;
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
143 interface EtheremonBattleInterface {
144     function isOnBattle(uint64 _objId) constant external returns(bool) ;
145     function getMonsterCP(uint64 _objId) constant external returns(uint64);
146 }
147 
148 contract EtheremonTrade is EtheremonEnum, BasicAccessControl, SafeMath {
149     
150     uint8 constant public GEN0_NO = 24;
151 
152     struct MonsterClassAcc {
153         uint32 classId;
154         uint256 price;
155         uint256 returnPrice;
156         uint32 total;
157         bool catchable;
158     }
159 
160     struct MonsterObjAcc {
161         uint64 monsterId;
162         uint32 classId;
163         address trainer;
164         string name;
165         uint32 exp;
166         uint32 createIndex;
167         uint32 lastClaimIndex;
168         uint createTime;
169     }
170     
171     // Gen0 has return price & no longer can be caught when this contract is deployed
172     struct Gen0Config {
173         uint32 classId;
174         uint256 originalPrice;
175         uint256 returnPrice;
176         uint32 total; // total caught (not count those from eggs)
177     }
178     
179     struct BorrowItem {
180         uint index;
181         address owner;
182         address borrower;
183         uint256 price;
184         bool lent;
185         uint releaseTime;
186     }
187     
188     struct SellingItem {
189         uint index;
190         uint256 price;
191     }
192     
193     struct SoldItem {
194         uint64 objId;
195         uint256 price;
196         uint time;
197     }
198     
199     // data contract
200     address public dataContract;
201     address public battleContract;
202     mapping(uint32 => Gen0Config) public gen0Config;
203     
204     // for selling
205     mapping(uint64 => SellingItem) public sellingDict;
206     uint32 public totalSellingItem;
207     uint64[] public sellingList;
208     
209     // for borrowing
210     mapping(uint64 => BorrowItem) public borrowingDict;
211     uint32 public totalBorrowingItem;
212     uint64[] public borrowingList;
213     
214     mapping(address => uint64[]) public lendingList;
215     mapping(address => SoldItem[]) public soldList;
216     
217     // trading fee
218     uint16 public tradingFeePercentage = 1;
219     uint8 public maxLendingItem = 10;
220     
221     modifier requireDataContract {
222         require(dataContract != address(0));
223         _;
224     }
225     
226     modifier requireBattleContract {
227         require(battleContract != address(0));
228         _;
229     }
230     
231     // event
232     event EventPlaceSellOrder(address indexed seller, uint64 objId);
233     event EventBuyItem(address indexed buyer, uint64 objId);
234     event EventOfferBorrowingItem(address indexed lender, uint64 objId);
235     event EventAcceptBorrowItem(address indexed borrower, uint64 objId);
236     event EventGetBackItem(address indexed owner, uint64 objId);
237     event EventFreeTransferItem(address indexed sender, address indexed receiver, uint64 objId);
238     event EventRelease(address indexed trainer, uint64 objId);
239     
240     // constructor
241     function EtheremonTrade(address _dataContract, address _battleContract) public {
242         dataContract = _dataContract;
243         battleContract = _battleContract;
244     }
245     
246      // admin & moderators
247     function setOriginalPriceGen0() onlyModerators public {
248         gen0Config[1] = Gen0Config(1, 0.3 ether, 0.003 ether, 374);
249         gen0Config[2] = Gen0Config(2, 0.3 ether, 0.003 ether, 408);
250         gen0Config[3] = Gen0Config(3, 0.3 ether, 0.003 ether, 373);
251         gen0Config[4] = Gen0Config(4, 0.2 ether, 0.002 ether, 437);
252         gen0Config[5] = Gen0Config(5, 0.1 ether, 0.001 ether, 497);
253         gen0Config[6] = Gen0Config(6, 0.3 ether, 0.003 ether, 380); 
254         gen0Config[7] = Gen0Config(7, 0.2 ether, 0.002 ether, 345);
255         gen0Config[8] = Gen0Config(8, 0.1 ether, 0.001 ether, 518); 
256         gen0Config[9] = Gen0Config(9, 0.1 ether, 0.001 ether, 447);
257         gen0Config[10] = Gen0Config(10, 0.2 ether, 0.002 ether, 380); 
258         gen0Config[11] = Gen0Config(11, 0.2 ether, 0.002 ether, 354);
259         gen0Config[12] = Gen0Config(12, 0.2 ether, 0.002 ether, 346);
260         gen0Config[13] = Gen0Config(13, 0.2 ether, 0.002 ether, 351); 
261         gen0Config[14] = Gen0Config(14, 0.2 ether, 0.002 ether, 338);
262         gen0Config[15] = Gen0Config(15, 0.2 ether, 0.002 ether, 341);
263         gen0Config[16] = Gen0Config(16, 0.35 ether, 0.0035 ether, 384);
264         gen0Config[17] = Gen0Config(17, 1 ether, 0.01 ether, 305); 
265         gen0Config[18] = Gen0Config(18, 0.1 ether, 0.001 ether, 427);
266         gen0Config[19] = Gen0Config(19, 1 ether, 0.01 ether, 304);
267         gen0Config[20] = Gen0Config(20, 0.4 ether, 0.05 ether, 82);
268         gen0Config[21] = Gen0Config(21, 1, 1, 123);
269         gen0Config[22] = Gen0Config(22, 0.2 ether, 0.001 ether, 468);
270         gen0Config[23] = Gen0Config(23, 0.5 ether, 0.0025 ether, 302);
271         gen0Config[24] = Gen0Config(24, 1 ether, 0.005 ether, 195);
272     }
273     
274     function setContract(address _dataContract, address _battleContract) onlyModerators public {
275         dataContract = _dataContract;
276         battleContract = _battleContract;
277     }
278     
279     function updateConfig(uint16 _fee, uint8 _maxLendingItem) onlyModerators public {
280         tradingFeePercentage = _fee;
281         maxLendingItem = _maxLendingItem;
282     }
283     
284     function withdrawEther(address _sendTo, uint _amount) onlyModerators public {
285         // no user money is kept in this contract, only trasaction fee
286         if (_amount > this.balance) {
287             revert();
288         }
289         _sendTo.transfer(_amount);
290     }
291     
292     
293     // helper
294     function removeSellingItem(uint64 _itemId) private {
295         SellingItem storage item = sellingDict[_itemId];
296         if (item.index == 0)
297             return;
298         
299         if (item.index <= sellingList.length) {
300             // Move an existing element into the vacated key slot.
301             sellingDict[sellingList[sellingList.length-1]].index = item.index;
302             sellingList[item.index-1] = sellingList[sellingList.length-1];
303             sellingList.length -= 1;
304             delete sellingDict[_itemId];
305         }
306     }
307     
308     function addSellingItem(uint64 _itemId, uint256 _price) private {
309         SellingItem storage item = sellingDict[_itemId];
310         item.price = _price;
311         
312         if (item.index == 0) {
313             item.index = ++sellingList.length;
314             sellingList[item.index - 1] = _itemId;
315         }
316     }
317 
318     function removeBorrowingItem(uint64 _itemId) private {
319         BorrowItem storage item = borrowingDict[_itemId];
320         if (item.index == 0)
321             return;
322         
323         if (item.index <= borrowingList.length) {
324             // Move an existing element into the vacated key slot.
325             borrowingDict[borrowingList[borrowingList.length-1]].index = item.index;
326             borrowingList[item.index-1] = borrowingList[borrowingList.length-1];
327             borrowingList.length -= 1;
328             delete borrowingDict[_itemId];
329         }
330     }
331 
332     function addBorrowingItem(address _owner, uint64 _itemId, uint256 _price, uint _releaseTime) private {
333         BorrowItem storage item = borrowingDict[_itemId];
334         item.owner = _owner;
335         item.borrower = address(0);
336         item.price = _price;
337         item.lent = false;
338         item.releaseTime = _releaseTime;
339         
340         if (item.index == 0) {
341             item.index = ++borrowingList.length;
342             borrowingList[item.index - 1] = _itemId;
343         }
344     }
345     
346     function transferMonster(address _to, uint64 _objId) private {
347         EtheremonDataBase data = EtheremonDataBase(dataContract);
348 
349         MonsterObjAcc memory obj;
350         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
351 
352         // clear balance for gen 0
353         if (obj.classId <= GEN0_NO) {
354             Gen0Config storage gen0 = gen0Config[obj.classId];
355             if (gen0.classId == obj.classId) {
356                 if (obj.lastClaimIndex < gen0.total) {
357                     uint32 gap = uint32(safeSubtract(gen0.total, obj.lastClaimIndex));
358                     if (gap > 0) {
359                         data.addExtraBalance(obj.trainer, safeMult(gap, gen0.returnPrice));
360                         // reset total (accept name is cleared :( )
361                         data.setMonsterObj(obj.monsterId, " name me ", obj.exp, obj.createIndex, gen0.total);
362                     }
363                 }
364             }
365         }
366         
367         // transfer owner
368         data.removeMonsterIdMapping(obj.trainer, _objId);
369         data.addMonsterIdMapping(_to, _objId);
370     }
371     
372     function addItemLendingList(address _trainer, uint64 _objId) private {
373         if (_trainer != address(0)) {
374             uint64[] storage objList = lendingList[_trainer];
375             for (uint index = 0; index < objList.length; index++) {
376                 if (objList[index] == _objId) {
377                     return;
378                 }
379             }
380             objList.push(_objId);
381         }
382     }
383     
384     function removeItemLendingList(address _trainer, uint64 _objId) private {
385         uint foundIndex = 0;
386         uint64[] storage objList = lendingList[_trainer];
387         for (; foundIndex < objList.length; foundIndex++) {
388             if (objList[foundIndex] == _objId) {
389                 break;
390             }
391         }
392         if (foundIndex < objList.length) {
393             objList[foundIndex] = objList[objList.length-1];
394             delete objList[objList.length-1];
395             objList.length--;
396         }
397     }
398     
399     // public
400     function placeSellOrder(uint64 _objId, uint256 _price) requireDataContract requireBattleContract isActive external {
401         if (_price == 0)
402             revert();
403         // not on borrowing
404         BorrowItem storage item = borrowingDict[_objId];
405         if (item.index > 0)
406             revert();
407         // not on battle 
408         EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
409         if (battle.isOnBattle(_objId))
410             revert();
411         
412         // check ownership
413         EtheremonDataBase data = EtheremonDataBase(dataContract);
414         MonsterObjAcc memory obj;
415         uint32 _ = 0;
416         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
417         
418         if (obj.monsterId != _objId) {
419             revert();
420         }
421         
422         if (obj.trainer != msg.sender) {
423             revert();
424         }
425         
426         // on selling, then just update price
427         if (sellingDict[_objId].index > 0){
428             sellingDict[_objId].price = _price;
429         } else {
430             addSellingItem(_objId, _price);
431         }
432         EventPlaceSellOrder(msg.sender, _objId);
433     }
434     
435     function removeSellOrder(uint64 _objId) requireDataContract requireBattleContract isActive external {
436         if (sellingDict[_objId].index == 0)
437             revert();
438         
439         // check ownership
440         EtheremonDataBase data = EtheremonDataBase(dataContract);
441         MonsterObjAcc memory obj;
442         uint32 _ = 0;
443         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
444         
445         if (obj.monsterId != _objId) {
446             revert();
447         }
448         
449         if (obj.trainer != msg.sender) {
450             revert();
451         }
452         
453         removeSellingItem(_objId);
454     }
455     
456     function buyItem(uint64 _objId) requireDataContract requireBattleContract isActive external payable {
457         // check item is valid to sell 
458         uint256 requestPrice = sellingDict[_objId].price;
459         if (requestPrice == 0 || msg.value != requestPrice) {
460             revert();
461         }
462         
463         // check obj
464         EtheremonDataBase data = EtheremonDataBase(dataContract);
465         MonsterObjAcc memory obj;
466         uint32 _ = 0;
467         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
468         if (obj.monsterId != _objId) {
469             revert();
470         }
471         // can not buy from yourself
472         if (obj.trainer == msg.sender) {
473             revert();
474         }
475         
476         address oldTrainer = obj.trainer;
477         uint256 fee = requestPrice * tradingFeePercentage / 100;
478         removeSellingItem(_objId);
479         transferMonster(msg.sender, _objId);
480         oldTrainer.transfer(safeSubtract(requestPrice, fee));
481         
482         SoldItem memory soldItem = SoldItem(_objId, requestPrice, block.timestamp);
483         soldList[oldTrainer].push(soldItem);
484         EventBuyItem(msg.sender, _objId);
485     }
486     
487     function offerBorrowingItem(uint64 _objId, uint256 _price, uint _releaseTime) requireDataContract requireBattleContract isActive external {
488         // make sure it is not on sale 
489         if (sellingDict[_objId].price > 0 || _price == 0)
490             revert();
491         // not on lent
492         BorrowItem storage item = borrowingDict[_objId];
493         if (item.lent == true)
494             revert();
495         // not on battle 
496         EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
497         if (battle.isOnBattle(_objId))
498             revert();
499         
500         
501         // check ownership
502         EtheremonDataBase data = EtheremonDataBase(dataContract);
503         MonsterObjAcc memory obj;
504         uint32 _ = 0;
505         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
506         
507         if (obj.monsterId != _objId) {
508             revert();
509         }
510         
511         if (obj.trainer != msg.sender) {
512             revert();
513         }
514         
515         if (item.index > 0) {
516             // update info 
517             item.price = _price;
518             item.releaseTime = _releaseTime;
519         } else {
520             addBorrowingItem(msg.sender, _objId, _price, _releaseTime);
521         }
522         EventOfferBorrowingItem(msg.sender, _objId);
523     }
524     
525     function removeBorrowingOfferItem(uint64 _objId) requireDataContract requireBattleContract isActive external {
526         BorrowItem storage item = borrowingDict[_objId];
527         if (item.index == 0)
528             revert();
529         
530         if (item.owner != msg.sender)
531             revert();
532         if (item.lent == true)
533             revert();
534         
535         removeBorrowingItem(_objId);
536     }
537     
538     function borrowItem(uint64 _objId) requireDataContract requireBattleContract isActive external payable {
539         BorrowItem storage item = borrowingDict[_objId];
540         if (item.index == 0)
541             revert();
542         if (item.lent == true)
543             revert();
544         uint256 itemPrice = item.price;
545         if (itemPrice != msg.value)
546             revert();
547         
548 
549         // check obj
550         EtheremonDataBase data = EtheremonDataBase(dataContract);
551         MonsterObjAcc memory obj;
552         uint32 _ = 0;
553         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
554         if (obj.monsterId != _objId) {
555             revert();
556         }
557         // can not borrow from yourself
558         if (obj.trainer == msg.sender) {
559             revert();
560         }
561         
562         uint256 fee = itemPrice * tradingFeePercentage / 100;
563         item.borrower = msg.sender;
564         item.releaseTime += block.timestamp;
565         item.lent = true;
566         address oldOwner = obj.trainer;
567         transferMonster(msg.sender, _objId);
568         oldOwner.transfer(safeSubtract(itemPrice, fee));
569         addItemLendingList(oldOwner, _objId);
570         EventAcceptBorrowItem(msg.sender, _objId);
571     }
572     
573     function getBackLendingItem(uint64 _objId) requireDataContract requireBattleContract isActive external {
574         BorrowItem storage item = borrowingDict[_objId];
575         if (item.index == 0)
576             revert();
577         if (item.lent == false)
578             revert();
579         if (item.releaseTime > block.timestamp)
580             revert();
581         
582         if (msg.sender != item.owner)
583             revert();
584         
585         removeBorrowingItem(_objId);
586         transferMonster(msg.sender, _objId);
587         removeItemLendingList(msg.sender, _objId);
588         EventGetBackItem(msg.sender, _objId);
589     }
590     
591     function freeTransferItem(uint64 _objId, address _receiver) requireDataContract requireBattleContract external {
592         // make sure it is not on sale 
593         if (sellingDict[_objId].price > 0)
594             revert();
595         // not on borrowing
596         BorrowItem storage item = borrowingDict[_objId];
597         if (item.index > 0)
598             revert();
599         // not on battle 
600         EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
601         if (battle.isOnBattle(_objId))
602             revert();
603         
604         // check ownership
605         EtheremonDataBase data = EtheremonDataBase(dataContract);
606         MonsterObjAcc memory obj;
607         uint32 _ = 0;
608         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
609         
610         if (obj.monsterId != _objId) {
611             revert();
612         }
613         
614         if (obj.trainer != msg.sender) {
615             revert();
616         }
617         
618         transferMonster(_receiver, _objId);
619         EventFreeTransferItem(msg.sender, _receiver, _objId);
620     }
621     
622     function release(uint64 _objId) requireDataContract requireBattleContract external {
623         // make sure it is not on sale 
624         if (sellingDict[_objId].price > 0)
625             revert();
626         // not on borrowing
627         BorrowItem storage item = borrowingDict[_objId];
628         if (item.index > 0)
629             revert();
630         // not on battle 
631         EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
632         if (battle.isOnBattle(_objId))
633             revert();
634         
635         // check ownership
636         EtheremonDataBase data = EtheremonDataBase(dataContract);
637         MonsterObjAcc memory obj;
638         uint32 _ = 0;
639         (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
640         
641         // can not release gen 0
642         if (obj.classId <= GEN0_NO) {
643             revert();
644         }
645         
646         if (obj.monsterId != _objId) {
647             revert();
648         }
649         
650         if (obj.trainer != msg.sender) {
651             revert();
652         }
653         
654         data.removeMonsterIdMapping(msg.sender, _objId);
655         EventRelease(msg.sender, _objId);
656     }
657     
658     // read access
659     
660     function getBasicObjInfo(uint64 _objId) constant public returns(uint32, address, uint32, uint32){
661         EtheremonDataBase data = EtheremonDataBase(dataContract);
662         MonsterObjAcc memory obj;
663         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
664         return (obj.classId, obj.trainer, obj.exp, obj.createIndex);
665     }
666     
667     function getBasicObjInfoWithBp(uint64 _objId) constant public returns(uint32, uint32, uint32, uint64) {
668         EtheremonDataBase data = EtheremonDataBase(dataContract);
669         MonsterObjAcc memory obj;
670         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
671         EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
672         uint64 bp = battle.getMonsterCP(_objId);
673         return (obj.classId, obj.exp, obj.createIndex, bp);
674     }
675     
676     function getTotalSellingItem() constant external returns(uint) {
677         return sellingList.length;
678     }
679 
680     function getSellingItem(uint _index) constant external returns(uint64 objId, uint32 classId, uint32 exp, uint64 bp, address trainer, uint createIndex, uint256 price) {
681         objId = sellingList[_index];
682         if (objId > 0) {
683             (classId, trainer, exp, createIndex) = getBasicObjInfo(objId);
684             EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
685             bp = battle.getMonsterCP(objId);
686             price = sellingDict[objId].price;
687         }
688     }
689     
690     function getSellingItemByObjId(uint64 _objId) constant external returns(uint32 classId, uint32 exp, uint64 bp, address trainer, uint createIndex, uint256 price) {
691         price = sellingDict[_objId].price;
692         if (price > 0) {
693             (classId, trainer, exp, createIndex) = getBasicObjInfo(_objId);
694             EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
695             bp = battle.getMonsterCP(_objId);
696         }
697     }
698 
699     function getTotalBorrowingItem() constant external returns(uint) {
700         return borrowingList.length;
701     }
702 
703     function getBorrowingItem(uint _index) constant external returns(uint64 objId, address owner, address borrower, 
704         uint256 price, bool lent, uint releaseTime, uint32 classId, uint32 exp, uint32 createIndex, uint64 bp) {
705         objId = borrowingList[_index];
706         BorrowItem storage item = borrowingDict[objId];
707         owner = item.owner;
708         borrower = item.borrower;
709         price = item.price;
710         lent = item.lent;
711         releaseTime = item.releaseTime;
712         
713         (classId, exp, createIndex, bp) = getBasicObjInfoWithBp(objId);
714     }
715     
716     function getBorrowingItemByObjId(uint64 _objId) constant external returns(uint index, address owner, address borrower, 
717         uint256 price, bool lent, uint releaseTime, uint32 classId, uint32 exp, uint32 createIndex, uint64 bp) {
718         BorrowItem storage item = borrowingDict[_objId];
719         index = item.index;
720         owner = item.owner;
721         borrower = item.borrower;
722         price = item.price;
723         lent = item.lent;
724         releaseTime = item.releaseTime;
725         
726         (classId, exp, createIndex, bp) = getBasicObjInfoWithBp(_objId);
727     }
728     
729     function getSoldItemLength(address _trainer) constant external returns(uint) {
730         return soldList[_trainer].length;
731     }
732     
733     function getSoldItem(address _trainer, uint _index) constant external returns(uint64 objId, uint32 classId, uint32 exp, uint64 bp, address currentOwner, 
734         uint createIndex, uint256 price, uint time) {
735         if (_index > soldList[_trainer].length)
736             return;
737         SoldItem memory soldItem = soldList[_trainer][_index];
738         objId = soldItem.objId;
739         price = soldItem.price;
740         time = soldItem.time;
741         if (objId > 0) {
742             (classId, currentOwner, exp, createIndex) = getBasicObjInfo(objId);
743             EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
744             bp = battle.getMonsterCP(objId);
745         }
746     }
747     
748     function getLendingItemLength(address _trainer) constant external returns(uint) {
749         return lendingList[_trainer].length;
750     }
751     
752     function getLendingItemInfo(address _trainer, uint _index) constant external returns(uint64 objId, address owner, address borrower, 
753         uint256 price, bool lent, uint releaseTime, uint32 classId, uint32 exp, uint32 createIndex, uint64 bp) {
754         if (_index > lendingList[_trainer].length)
755             return;
756         objId = lendingList[_trainer][_index];
757         BorrowItem storage item = borrowingDict[objId];
758         owner = item.owner;
759         borrower = item.borrower;
760         price = item.price;
761         lent = item.lent;
762         releaseTime = item.releaseTime;
763         
764         (classId, exp, createIndex, bp) = getBasicObjInfoWithBp(objId);
765     }
766     
767     function getTradingInfo(uint64 _objId) constant external returns(uint256 sellingPrice, uint256 lendingPrice, bool lent, uint releaseTime) {
768         sellingPrice = sellingDict[_objId].price;
769         BorrowItem storage item = borrowingDict[_objId];
770         lendingPrice = item.price;
771         lent = item.lent;
772         releaseTime = item.releaseTime;
773     }
774     
775     function isOnTrading(uint64 _objId) constant external returns(bool) {
776         return (sellingDict[_objId].price > 0 || borrowingDict[_objId].owner != address(0));
777     }
778 }