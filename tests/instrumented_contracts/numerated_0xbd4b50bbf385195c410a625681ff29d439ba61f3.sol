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
145 }
146 
147 interface EtheremonMonsterNFTInterface {
148    function triggerTransferEvent(address _from, address _to, uint _tokenId) external;
149    function getMonsterCP(uint64 _monsterId) constant external returns(uint cp);
150 }
151 
152 contract EtheremonTradeData is BasicAccessControl {
153     struct BorrowItem {
154         uint index;
155         address owner;
156         address borrower;
157         uint price;
158         bool lent;
159         uint releaseTime;
160         uint createTime;
161     }
162     
163     struct SellingItem {
164         uint index;
165         uint price;
166         uint createTime;
167     }
168 
169     mapping(uint => SellingItem) public sellingDict; // monster id => item
170     uint[] public sellingList; // monster id
171     
172     mapping(uint => BorrowItem) public borrowingDict;
173     uint[] public borrowingList;
174 
175     mapping(address => uint[]) public lendingList;
176     
177     function removeSellingItem(uint _itemId) onlyModerators external {
178         SellingItem storage item = sellingDict[_itemId];
179         if (item.index == 0)
180             return;
181         
182         if (item.index <= sellingList.length) {
183             // Move an existing element into the vacated key slot.
184             sellingDict[sellingList[sellingList.length-1]].index = item.index;
185             sellingList[item.index-1] = sellingList[sellingList.length-1];
186             sellingList.length -= 1;
187             delete sellingDict[_itemId];
188         }
189     }
190     
191     function addSellingItem(uint _itemId, uint _price, uint _createTime) onlyModerators external {
192         SellingItem storage item = sellingDict[_itemId];
193         item.price = _price;
194         item.createTime = _createTime;
195         
196         if (item.index == 0) {
197             item.index = ++sellingList.length;
198             sellingList[item.index - 1] = _itemId;
199         }
200     }
201     
202     function removeBorrowingItem(uint _itemId) onlyModerators external {
203         BorrowItem storage item = borrowingDict[_itemId];
204         if (item.index == 0)
205             return;
206         
207         if (item.index <= borrowingList.length) {
208             // Move an existing element into the vacated key slot.
209             borrowingDict[borrowingList[borrowingList.length-1]].index = item.index;
210             borrowingList[item.index-1] = borrowingList[borrowingList.length-1];
211             borrowingList.length -= 1;
212             delete borrowingDict[_itemId];
213         }
214     }
215 
216     function addBorrowingItem(address _owner, uint _itemId, uint _price, address _borrower, bool _lent, uint _releaseTime, uint _createTime) onlyModerators external {
217         BorrowItem storage item = borrowingDict[_itemId];
218         item.owner = _owner;
219         item.borrower = _borrower;
220         item.price = _price;
221         item.lent = _lent;
222         item.releaseTime = _releaseTime;
223         item.createTime = _createTime;
224         
225         if (item.index == 0) {
226             item.index = ++borrowingList.length;
227             borrowingList[item.index - 1] = _itemId;
228         }
229     }
230     
231     function addItemLendingList(address _trainer, uint _objId) onlyModerators external {
232         lendingList[_trainer].push(_objId);
233     }
234     
235     function removeItemLendingList(address _trainer, uint _objId) onlyModerators external {
236         uint foundIndex = 0;
237         uint[] storage objList = lendingList[_trainer];
238         for (; foundIndex < objList.length; foundIndex++) {
239             if (objList[foundIndex] == _objId) {
240                 break;
241             }
242         }
243         if (foundIndex < objList.length) {
244             objList[foundIndex] = objList[objList.length-1];
245             delete objList[objList.length-1];
246             objList.length--;
247         }
248     }
249 
250     // read access
251     function isOnBorrow(uint _objId) constant external returns(bool) {
252         return (borrowingDict[_objId].index > 0);
253     }
254     
255     function isOnSell(uint _objId) constant external returns(bool) {
256         return (sellingDict[_objId].index > 0);
257     }
258     
259     function isOnLent(uint _objId) constant external returns(bool) {
260         return borrowingDict[_objId].lent;
261     }
262     
263     function getSellPrice(uint _objId) constant external returns(uint) {
264         return sellingDict[_objId].price;
265     }
266     
267     function isOnTrade(uint _objId) constant external returns(bool) {
268         return ((borrowingDict[_objId].index > 0) || (sellingDict[_objId].index > 0)); 
269     }
270     
271     function getBorrowBasicInfo(uint _objId) constant external returns(address owner, bool lent) {
272         BorrowItem storage borrowItem = borrowingDict[_objId];
273         return (borrowItem.owner, borrowItem.lent);
274     }
275     
276     function getBorrowInfo(uint _objId) constant external returns(uint index, address owner, address borrower, uint price, bool lent, uint createTime, uint releaseTime) {
277         BorrowItem storage borrowItem = borrowingDict[_objId];
278         return (borrowItem.index, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime);
279     }
280     
281     function getSellInfo(uint _objId) constant external returns(uint index, uint price, uint createTime) {
282         SellingItem storage item = sellingDict[_objId];
283         return (item.index, item.price, item.createTime);
284     }
285     
286     function getTotalSellingItem() constant external returns(uint) {
287         return sellingList.length;
288     }
289     
290     function getTotalBorrowingItem() constant external returns(uint) {
291         return borrowingList.length;
292     }
293     
294     function getTotalLendingItem(address _trainer) constant external returns(uint) {
295         return lendingList[_trainer].length;
296     }
297     
298     function getSellingInfoByIndex(uint _index) constant external returns(uint objId, uint price, uint createTime) {
299         objId = sellingList[_index];
300         SellingItem storage item = sellingDict[objId];
301         price = item.price;
302         createTime = item.createTime;
303     }
304     
305     function getBorrowInfoByIndex(uint _index) constant external returns(uint objId, address owner, address borrower, uint price, bool lent, uint createTime, uint releaseTime) {
306         objId = borrowingList[_index];
307         BorrowItem storage borrowItem = borrowingDict[objId];
308         return (objId, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime);
309     }
310     
311     function getLendingObjId(address _trainer, uint _index) constant external returns(uint) {
312         return lendingList[_trainer][_index];
313     }
314     
315     function getLendingInfo(address _trainer, uint _index) constant external returns(uint objId, address owner, address borrower, uint price, bool lent, uint createTime, uint releaseTime) {
316         objId = lendingList[_trainer][_index];
317         BorrowItem storage borrowItem = borrowingDict[objId];
318         return (objId, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime);
319     }
320     
321     function getTradingInfo(uint _objId) constant external returns(uint sellingPrice, uint lendingPrice, bool lent, uint releaseTime, address owner, address borrower) {
322         SellingItem storage item = sellingDict[_objId];
323         sellingPrice = item.price;
324         BorrowItem storage borrowItem = borrowingDict[_objId];
325         lendingPrice = borrowItem.price;
326         lent = borrowItem.lent;
327         releaseTime = borrowItem.releaseTime;
328         owner = borrowItem.owner;
329         borrower = borrower;
330     }
331 }
332 
333 contract EtheremonTrade is EtheremonEnum, BasicAccessControl, SafeMath {
334     
335     uint8 constant public GEN0_NO = 24;
336 
337     struct MonsterClassAcc {
338         uint32 classId;
339         uint256 price;
340         uint256 returnPrice;
341         uint32 total;
342         bool catchable;
343     }
344 
345     struct MonsterObjAcc {
346         uint64 monsterId;
347         uint32 classId;
348         address trainer;
349         string name;
350         uint32 exp;
351         uint32 createIndex;
352         uint32 lastClaimIndex;
353         uint createTime;
354     }
355     
356     // Gen0 has return price & no longer can be caught when this contract is deployed
357     struct Gen0Config {
358         uint32 classId;
359         uint256 originalPrice;
360         uint256 returnPrice;
361         uint32 total; // total caught (not count those from eggs)
362     }
363     
364     struct BorrowItem {
365         uint index;
366         address owner;
367         address borrower;
368         uint price;
369         bool lent;
370         uint releaseTime;
371         uint createTime;
372     }
373     
374     // data contract
375     address public dataContract;
376     address public battleContract;
377     address public tradingMonDataContract;
378     address public monsterNFTContract;
379     
380     mapping(uint32 => Gen0Config) public gen0Config;
381     
382     // trading fee
383     uint16 public tradingFeePercentage = 3;
384     
385     // event
386     event EventPlaceSellOrder(address indexed seller, uint objId, uint price);
387     event EventRemoveSellOrder(address indexed seller, uint objId);
388     event EventCompleteSellOrder(address indexed seller, address indexed buyer, uint objId, uint price);
389     event EventOfferBorrowingItem(address indexed lender, uint objId, uint price, uint releaseTime);
390     event EventRemoveOfferBorrowingItem(address indexed lender, uint objId);
391     event EventAcceptBorrowItem(address indexed lender, address indexed borrower, uint objId, uint price);
392     event EventGetBackItem(address indexed lender, address indexed borrower, uint objId);
393     
394     // constructor
395     function EtheremonTrade(address _dataContract, address _battleContract, address _tradingMonDataContract, address _monsterNFTContract) public {
396         dataContract = _dataContract;
397         battleContract = _battleContract;
398         tradingMonDataContract = _tradingMonDataContract;
399         monsterNFTContract = _monsterNFTContract;
400     }
401     
402      // admin & moderators
403     function setOriginalPriceGen0() onlyModerators public {
404         gen0Config[1] = Gen0Config(1, 0.3 ether, 0.003 ether, 374);
405         gen0Config[2] = Gen0Config(2, 0.3 ether, 0.003 ether, 408);
406         gen0Config[3] = Gen0Config(3, 0.3 ether, 0.003 ether, 373);
407         gen0Config[4] = Gen0Config(4, 0.2 ether, 0.002 ether, 437);
408         gen0Config[5] = Gen0Config(5, 0.1 ether, 0.001 ether, 497);
409         gen0Config[6] = Gen0Config(6, 0.3 ether, 0.003 ether, 380); 
410         gen0Config[7] = Gen0Config(7, 0.2 ether, 0.002 ether, 345);
411         gen0Config[8] = Gen0Config(8, 0.1 ether, 0.001 ether, 518); 
412         gen0Config[9] = Gen0Config(9, 0.1 ether, 0.001 ether, 447);
413         gen0Config[10] = Gen0Config(10, 0.2 ether, 0.002 ether, 380); 
414         gen0Config[11] = Gen0Config(11, 0.2 ether, 0.002 ether, 354);
415         gen0Config[12] = Gen0Config(12, 0.2 ether, 0.002 ether, 346);
416         gen0Config[13] = Gen0Config(13, 0.2 ether, 0.002 ether, 351); 
417         gen0Config[14] = Gen0Config(14, 0.2 ether, 0.002 ether, 338);
418         gen0Config[15] = Gen0Config(15, 0.2 ether, 0.002 ether, 341);
419         gen0Config[16] = Gen0Config(16, 0.35 ether, 0.0035 ether, 384);
420         gen0Config[17] = Gen0Config(17, 1 ether, 0.01 ether, 305); 
421         gen0Config[18] = Gen0Config(18, 0.1 ether, 0.001 ether, 427);
422         gen0Config[19] = Gen0Config(19, 1 ether, 0.01 ether, 304);
423         gen0Config[20] = Gen0Config(20, 0.4 ether, 0.05 ether, 82);
424         gen0Config[21] = Gen0Config(21, 1, 1, 123);
425         gen0Config[22] = Gen0Config(22, 0.2 ether, 0.001 ether, 468);
426         gen0Config[23] = Gen0Config(23, 0.5 ether, 0.0025 ether, 302);
427         gen0Config[24] = Gen0Config(24, 1 ether, 0.005 ether, 195);
428     }
429     
430     function setContract(address _dataContract, address _battleContract, address _tradingMonDataContract, address _monsterNFTContract) onlyModerators public {
431         dataContract = _dataContract;
432         battleContract = _battleContract;
433         tradingMonDataContract = _tradingMonDataContract;
434         monsterNFTContract = _monsterNFTContract;
435     }
436     
437     function updateConfig(uint16 _fee) onlyModerators public {
438         tradingFeePercentage = _fee;
439     }
440     
441     function withdrawEther(address _sendTo, uint _amount) onlyModerators public {
442         // no user money is kept in this contract, only trasaction fee
443         if (_amount > this.balance) {
444             revert();
445         }
446         _sendTo.transfer(_amount);
447     }
448 
449     function _triggerNFTEvent(address _from, address _to, uint _objId) internal {
450         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
451         monsterNFT.triggerTransferEvent(_from, _to, _objId);
452     }
453     
454     // public
455     function placeSellOrder(uint _objId, uint _price) isActive external {
456         if (_price == 0)
457             revert();
458         
459         // not on borrowing
460         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
461         if (monTradeData.isOnBorrow(_objId))
462             revert();
463 
464         // not on battle 
465         EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
466         if (battle.isOnBattle(uint64(_objId)))
467             revert();
468         
469         // check ownership
470         EtheremonDataBase data = EtheremonDataBase(dataContract);
471         MonsterObjAcc memory obj;
472         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_objId));
473 
474         if (obj.trainer != msg.sender) {
475             revert();
476         }
477         
478         monTradeData.addSellingItem(_objId, _price, block.timestamp);
479         EventPlaceSellOrder(msg.sender, _objId, _price);
480     }
481     
482     function removeSellOrder(uint _objId) isActive external {
483         // check ownership
484         EtheremonDataBase data = EtheremonDataBase(dataContract);
485         MonsterObjAcc memory obj;
486         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_objId));
487 
488         if (obj.trainer != msg.sender) {
489             revert();
490         }
491         
492         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
493         monTradeData.removeSellingItem(_objId);
494         
495         EventRemoveSellOrder(msg.sender, _objId);
496     }
497     
498     function buyItem(uint _objId) isActive external payable {
499         // check item is valid to sell
500         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
501         uint requestPrice = monTradeData.getSellPrice(_objId);
502         if (requestPrice == 0 || msg.value != requestPrice) {
503             revert();
504         }
505 
506         // check obj
507         EtheremonDataBase data = EtheremonDataBase(dataContract);
508         MonsterObjAcc memory obj;
509         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_objId));
510         // can not buy from yourself
511         if (obj.monsterId == 0 || obj.trainer == msg.sender) {
512             revert();
513         }
514         
515         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
516 
517         uint fee = requestPrice * tradingFeePercentage / 100;
518         monTradeData.removeSellingItem(_objId);
519         
520         // transfer owner
521         data.removeMonsterIdMapping(obj.trainer, obj.monsterId);
522         data.addMonsterIdMapping(msg.sender, obj.monsterId);
523         monsterNFT.triggerTransferEvent(obj.trainer, msg.sender, _objId);
524         
525         // transfer money
526         obj.trainer.transfer(safeSubtract(requestPrice, fee));
527         
528         EventCompleteSellOrder(obj.trainer, msg.sender, _objId, requestPrice);
529     }
530     
531     function offerBorrowingItem(uint _objId, uint _price, uint _releaseTime) isActive external {
532         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
533         if (monTradeData.isOnSell(_objId) || monTradeData.isOnLent(_objId)) revert();
534 
535          // check ownership
536         EtheremonDataBase data = EtheremonDataBase(dataContract);
537         MonsterObjAcc memory obj;
538         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_objId));
539 
540         if (obj.trainer != msg.sender) {
541             revert();
542         }
543 
544         // not on battle 
545         EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
546         if (battle.isOnBattle(obj.monsterId))
547             revert();
548         
549         monTradeData.addBorrowingItem(msg.sender, _objId, _price, address(0), false, _releaseTime, block.timestamp);
550         EventOfferBorrowingItem(msg.sender, _objId, _price, _releaseTime);
551     }
552     
553     function removeBorrowingOfferItem(uint _objId) isActive external {
554         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
555         address owner;
556         bool lent;
557         (owner, lent) = monTradeData.getBorrowBasicInfo(_objId);
558         if (owner != msg.sender || lent == true)
559             revert();
560         
561         monTradeData.removeBorrowingItem(_objId);
562         EventRemoveOfferBorrowingItem(msg.sender, _objId);
563     }
564     
565     function borrowItem(uint _objId) isActive external payable {
566         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
567         BorrowItem memory borrowItem;
568         (borrowItem.index, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime) = monTradeData.getBorrowInfo(_objId);
569         if (borrowItem.index == 0 || borrowItem.lent == true) revert();
570         if (borrowItem.owner == msg.sender) revert(); // can not borrow from yourself
571         if (borrowItem.price != msg.value)
572             revert();
573 
574         // check obj
575         EtheremonDataBase data = EtheremonDataBase(dataContract);
576         MonsterObjAcc memory obj;
577         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_objId));
578         if (obj.trainer != borrowItem.owner) {
579             revert();
580         }
581         
582         // update borrow data
583         monTradeData.addBorrowingItem(borrowItem.owner, _objId, borrowItem.price, msg.sender, true, (borrowItem.releaseTime + block.timestamp), borrowItem.createTime);
584         
585         data.removeMonsterIdMapping(obj.trainer, obj.monsterId);
586         data.addMonsterIdMapping(msg.sender, obj.monsterId);
587         _triggerNFTEvent(obj.trainer, msg.sender, _objId);
588         
589         obj.trainer.transfer(safeSubtract(borrowItem.price, borrowItem.price * tradingFeePercentage / 100));
590         monTradeData.addItemLendingList(obj.trainer, _objId);
591         EventAcceptBorrowItem(obj.trainer, msg.sender, _objId, borrowItem.price);
592     }
593     
594     function getBackLendingItem(uint64 _objId) isActive external {
595         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
596         BorrowItem memory borrowItem;
597         (borrowItem.index, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime) = monTradeData.getBorrowInfo(_objId);
598         
599         if (borrowItem.index == 0)
600             revert();
601         if (borrowItem.lent == false)
602             revert();
603         if (borrowItem.releaseTime > block.timestamp)
604             revert();
605         
606         if (msg.sender != borrowItem.owner)
607             revert();
608         
609         monTradeData.removeBorrowingItem(_objId);
610         
611         EtheremonDataBase data = EtheremonDataBase(dataContract);
612         data.removeMonsterIdMapping(borrowItem.borrower, _objId);
613         data.addMonsterIdMapping(msg.sender, _objId);
614         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
615         monsterNFT.triggerTransferEvent(borrowItem.borrower, msg.sender, _objId);
616         
617         monTradeData.removeItemLendingList(msg.sender, _objId);
618         EventGetBackItem(msg.sender, borrowItem.borrower, _objId);
619     }
620     
621     // read access
622     function getObjInfoWithBp(uint64 _objId) constant public returns(address owner, uint32 classId, uint32 exp, uint32 createIndex, uint bp) {
623         EtheremonDataBase data = EtheremonDataBase(dataContract);
624         MonsterObjAcc memory obj;
625         (obj.monsterId, classId, owner, exp, createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
626         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
627         bp = monsterNFT.getMonsterCP(_objId);
628     }
629     
630     function getTotalSellingMonsters() constant external returns(uint) {
631         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
632         return monTradeData.getTotalSellingItem();
633     }
634     
635     function getTotalBorrowingMonsters() constant external returns(uint) {
636         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
637         return monTradeData.getTotalBorrowingItem();
638     }
639 
640     function getSellingItem(uint _index) constant external returns(uint objId, uint32 classId, uint32 exp, uint bp, address trainer, uint32 createIndex, uint256 price, uint createTime) {
641         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
642         (objId, price, createTime) = monTradeData.getSellingInfoByIndex(_index);
643         if (objId > 0) {
644             (trainer, classId, exp, createIndex, bp) = getObjInfoWithBp(uint64(objId));
645         }
646     }
647     
648     function getSellingItemByObjId(uint64 _objId) constant external returns(uint32 classId, uint32 exp, uint bp, address trainer, uint32 createIndex, uint256 price, uint createTime) {
649         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
650         uint index;
651         (index, price, createTime) = monTradeData.getSellInfo(_objId);
652         if (price > 0) {
653             (trainer, classId, exp, createIndex, bp) = getObjInfoWithBp(_objId);
654         }
655     }
656 
657     function getBorrowingItem(uint _index) constant external returns(uint objId, address owner, address borrower, 
658         uint256 price, bool lent, uint createTime, uint releaseTime) {
659         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);    
660         (objId, owner, borrower, price, lent, createTime, releaseTime) = monTradeData.getBorrowInfoByIndex(_index);
661     }
662     
663     function getBorrowingItemByObjId(uint64 _objId) constant external returns(uint index, address owner, address borrower, 
664         uint256 price, bool lent, uint createTime, uint releaseTime) {
665         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);    
666         (index, owner, borrower, price, lent, createTime, releaseTime) = monTradeData.getBorrowInfo(_objId);
667     }
668     
669     
670     function getLendingItemLength(address _trainer) constant external returns(uint) {
671         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);    
672         return monTradeData.getTotalLendingItem(_trainer);
673     }
674     
675     function getLendingItemInfo(address _trainer, uint _index) constant external returns(uint objId, address owner, address borrower, 
676         uint256 price, bool lent, uint createTime, uint releaseTime) {
677         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
678         (objId, owner, borrower, price, lent, createTime, releaseTime) = monTradeData.getLendingInfo(_trainer, _index);
679     }
680     
681     function getTradingInfo(uint _objId) constant external returns(address owner, address borrower, uint256 sellingPrice, uint256 lendingPrice, bool lent, uint releaseTime) {
682         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
683         (sellingPrice, lendingPrice, lent, releaseTime, owner, borrower) = monTradeData.getTradingInfo(_objId);
684     }
685     
686     function isOnTrading(uint _objId) constant external returns(bool) {
687         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
688         return monTradeData.isOnTrade(_objId);
689     }
690 }