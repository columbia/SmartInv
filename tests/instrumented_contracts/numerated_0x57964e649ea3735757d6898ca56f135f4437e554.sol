1 // Lowest version pragma solidity 0.4.16 compiled with 0.4.19
2 pragma solidity ^0.4.16;
3 
4 // copyright contact@EtherMon.io
5 
6 contract SafeMath {
7 
8     /* function assert(bool assertion) internal { */
9     /*   if (!assertion) { */
10     /*     throw; */
11     /*   } */
12     /* }      // assert no longer needed once solidity is on 0.4.10 */
13 
14     function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
15       uint256 z = x + y;
16       assert((z >= x) && (z >= y));
17       return z;
18     }
19 
20     function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
21       assert(x >= y);
22       uint256 z = x - y;
23       return z;
24     }
25 
26     function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
27       uint256 z = x * y;
28       assert((x == 0)||(z/x == y));
29       return z;
30     }
31 
32 }
33 
34 contract BasicAccessControl {
35     address public owner;
36     // address[] public moderators;
37     uint16 public totalModerators = 0;
38     mapping (address => bool) public moderators;
39     bool public isMaintaining = false;
40 
41     function BasicAccessControl() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     modifier onlyModerators() {
51         require(msg.sender == owner || moderators[msg.sender] == true);
52         _;
53     }
54 
55     modifier isActive {
56         require(!isMaintaining);
57         _;
58     }
59 
60     function ChangeOwner(address _newOwner) onlyOwner public {
61         if (_newOwner != address(0)) {
62             owner = _newOwner;
63         }
64     }
65 
66 
67     function AddModerator(address _newModerator) onlyOwner public {
68         if (moderators[_newModerator] == false) {
69             moderators[_newModerator] = true;
70             totalModerators += 1;
71         }
72     }
73     
74     function RemoveModerator(address _oldModerator) onlyOwner public {
75         if (moderators[_oldModerator] == true) {
76             moderators[_oldModerator] = false;
77             totalModerators -= 1;
78         }
79     }
80 
81     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
82         isMaintaining = _isMaintaining;
83     }
84 }
85 
86 contract EtheremonEnum {
87 
88     enum ResultCode {
89         SUCCESS,
90         ERROR_CLASS_NOT_FOUND,
91         ERROR_LOW_BALANCE,
92         ERROR_SEND_FAIL,
93         ERROR_NOT_TRAINER,
94         ERROR_NOT_ENOUGH_MONEY,
95         ERROR_INVALID_AMOUNT,
96         ERROR_OBJ_NOT_FOUND,
97         ERROR_OBJ_INVALID_OWNERSHIP
98     }
99     
100     enum ArrayType {
101         CLASS_TYPE,
102         STAT_STEP,
103         STAT_START,
104         STAT_BASE,
105         OBJ_SKILL
106     }
107 }
108 
109 contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
110     
111     uint64 public totalMonster;
112     uint32 public totalClass;
113     
114     // write
115     function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
116     function removeElementOfArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);
117     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);
118     function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);
119     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;
120     function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
121     function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;
122     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
123     function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;
124     function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);
125     function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);
126     function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);
127     function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
128     function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);
129     function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;
130     
131     // read
132     function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
133     function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
134     function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
135     function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
136     function getMonsterName(uint64 _objId) constant public returns(string name);
137     function getExtraBalance(address _trainer) constant public returns(uint256);
138     function getMonsterDexSize(address _trainer) constant public returns(uint);
139     function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
140     function getExpectedBalance(address _trainer) constant public returns(uint256);
141     function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
142 }
143 
144 interface EtheremonBattleInterface {
145     function isOnBattle(uint64 _objId) constant external returns(bool) ;
146 }
147 
148 interface EtheremonMonsterNFTInterface {
149    function triggerTransferEvent(address _from, address _to, uint _tokenId) external;
150    function getMonsterCP(uint64 _monsterId) constant external returns(uint cp);
151 }
152 
153 contract EtheremonTradeData is BasicAccessControl {
154     struct BorrowItem {
155         uint index;
156         address owner;
157         address borrower;
158         uint price;
159         bool lent;
160         uint releaseTime;
161         uint createTime;
162     }
163     
164     struct SellingItem {
165         uint index;
166         uint price;
167         uint createTime;
168     }
169 
170     mapping(uint => SellingItem) public sellingDict; // monster id => item
171     uint[] public sellingList; // monster id
172     
173     mapping(uint => BorrowItem) public borrowingDict;
174     uint[] public borrowingList;
175 
176     mapping(address => uint[]) public lendingList;
177     
178     function removeSellingItem(uint _itemId) onlyModerators external {
179         SellingItem storage item = sellingDict[_itemId];
180         if (item.index == 0)
181             return;
182         
183         if (item.index <= sellingList.length) {
184             // Move an existing element into the vacated key slot.
185             sellingDict[sellingList[sellingList.length-1]].index = item.index;
186             sellingList[item.index-1] = sellingList[sellingList.length-1];
187             sellingList.length -= 1;
188             delete sellingDict[_itemId];
189         }
190     }
191     
192     function addSellingItem(uint _itemId, uint _price, uint _createTime) onlyModerators external {
193         SellingItem storage item = sellingDict[_itemId];
194         item.price = _price;
195         item.createTime = _createTime;
196         
197         if (item.index == 0) {
198             item.index = ++sellingList.length;
199             sellingList[item.index - 1] = _itemId;
200         }
201     }
202     
203     function removeBorrowingItem(uint _itemId) onlyModerators external {
204         BorrowItem storage item = borrowingDict[_itemId];
205         if (item.index == 0)
206             return;
207         
208         if (item.index <= borrowingList.length) {
209             // Move an existing element into the vacated key slot.
210             borrowingDict[borrowingList[borrowingList.length-1]].index = item.index;
211             borrowingList[item.index-1] = borrowingList[borrowingList.length-1];
212             borrowingList.length -= 1;
213             delete borrowingDict[_itemId];
214         }
215     }
216 
217     function addBorrowingItem(address _owner, uint _itemId, uint _price, address _borrower, bool _lent, uint _releaseTime, uint _createTime) onlyModerators external {
218         BorrowItem storage item = borrowingDict[_itemId];
219         item.owner = _owner;
220         item.borrower = _borrower;
221         item.price = _price;
222         item.lent = _lent;
223         item.releaseTime = _releaseTime;
224         item.createTime = _createTime;
225         
226         if (item.index == 0) {
227             item.index = ++borrowingList.length;
228             borrowingList[item.index - 1] = _itemId;
229         }
230     }
231     
232     function addItemLendingList(address _trainer, uint _objId) onlyModerators external {
233         lendingList[_trainer].push(_objId);
234     }
235     
236     function removeItemLendingList(address _trainer, uint _objId) onlyModerators external {
237         uint foundIndex = 0;
238         uint[] storage objList = lendingList[_trainer];
239         for (; foundIndex < objList.length; foundIndex++) {
240             if (objList[foundIndex] == _objId) {
241                 break;
242             }
243         }
244         if (foundIndex < objList.length) {
245             objList[foundIndex] = objList[objList.length-1];
246             delete objList[objList.length-1];
247             objList.length--;
248         }
249     }
250 
251     // read access
252     function isOnBorrow(uint _objId) constant external returns(bool) {
253         return (borrowingDict[_objId].index > 0);
254     }
255     
256     function isOnSell(uint _objId) constant external returns(bool) {
257         return (sellingDict[_objId].index > 0);
258     }
259     
260     function isOnLent(uint _objId) constant external returns(bool) {
261         return borrowingDict[_objId].lent;
262     }
263     
264     function getSellPrice(uint _objId) constant external returns(uint) {
265         return sellingDict[_objId].price;
266     }
267     
268     function isOnTrade(uint _objId) constant external returns(bool) {
269         return ((borrowingDict[_objId].index > 0) || (sellingDict[_objId].index > 0)); 
270     }
271     
272     function getBorrowBasicInfo(uint _objId) constant external returns(address owner, bool lent) {
273         BorrowItem storage borrowItem = borrowingDict[_objId];
274         return (borrowItem.owner, borrowItem.lent);
275     }
276     
277     function getBorrowInfo(uint _objId) constant external returns(uint index, address owner, address borrower, uint price, bool lent, uint createTime, uint releaseTime) {
278         BorrowItem storage borrowItem = borrowingDict[_objId];
279         return (borrowItem.index, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime);
280     }
281     
282     function getSellInfo(uint _objId) constant external returns(uint index, uint price, uint createTime) {
283         SellingItem storage item = sellingDict[_objId];
284         return (item.index, item.price, item.createTime);
285     }
286     
287     function getTotalSellingItem() constant external returns(uint) {
288         return sellingList.length;
289     }
290     
291     function getTotalBorrowingItem() constant external returns(uint) {
292         return borrowingList.length;
293     }
294     
295     function getTotalLendingItem(address _trainer) constant external returns(uint) {
296         return lendingList[_trainer].length;
297     }
298     
299     function getSellingInfoByIndex(uint _index) constant external returns(uint objId, uint price, uint createTime) {
300         objId = sellingList[_index];
301         SellingItem storage item = sellingDict[objId];
302         price = item.price;
303         createTime = item.createTime;
304     }
305     
306     function getBorrowInfoByIndex(uint _index) constant external returns(uint objId, address owner, address borrower, uint price, bool lent, uint createTime, uint releaseTime) {
307         objId = borrowingList[_index];
308         BorrowItem storage borrowItem = borrowingDict[objId];
309         return (objId, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime);
310     }
311     
312     function getLendingObjId(address _trainer, uint _index) constant external returns(uint) {
313         return lendingList[_trainer][_index];
314     }
315     
316     function getLendingInfo(address _trainer, uint _index) constant external returns(uint objId, address owner, address borrower, uint price, bool lent, uint createTime, uint releaseTime) {
317         objId = lendingList[_trainer][_index];
318         BorrowItem storage borrowItem = borrowingDict[objId];
319         return (objId, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime);
320     }
321     
322     function getTradingInfo(uint _objId) constant external returns(uint sellingPrice, uint lendingPrice, bool lent, uint releaseTime, address owner, address borrower) {
323         SellingItem storage item = sellingDict[_objId];
324         sellingPrice = item.price;
325         BorrowItem storage borrowItem = borrowingDict[_objId];
326         lendingPrice = borrowItem.price;
327         lent = borrowItem.lent;
328         releaseTime = borrowItem.releaseTime;
329         owner = borrowItem.owner;
330         borrower = borrower;
331     }
332 }
333 
334 contract EtheremonTrade is EtheremonEnum, BasicAccessControl, SafeMath {
335     
336     uint8 constant public GEN0_NO = 24;
337 
338     struct MonsterClassAcc {
339         uint32 classId;
340         uint256 price;
341         uint256 returnPrice;
342         uint32 total;
343         bool catchable;
344     }
345 
346     struct MonsterObjAcc {
347         uint64 monsterId;
348         uint32 classId;
349         address trainer;
350         string name;
351         uint32 exp;
352         uint32 createIndex;
353         uint32 lastClaimIndex;
354         uint createTime;
355     }
356     
357     // Gen0 has return price & no longer can be caught when this contract is deployed
358     struct Gen0Config {
359         uint32 classId;
360         uint256 originalPrice;
361         uint256 returnPrice;
362         uint32 total; // total caught (not count those from eggs)
363     }
364     
365     struct BorrowItem {
366         uint index;
367         address owner;
368         address borrower;
369         uint price;
370         bool lent;
371         uint releaseTime;
372         uint createTime;
373     }
374     
375     // data contract
376     address public dataContract;
377     address public battleContract;
378     address public tradingMonDataContract;
379     address public monsterNFTContract;
380     
381     mapping(uint32 => Gen0Config) public gen0Config;
382     
383     // trading fee
384     uint16 public tradingFeePercentage = 3;
385     
386     // event
387     event EventPlaceSellOrder(address indexed seller, uint objId, uint price);
388     event EventRemoveSellOrder(address indexed seller, uint objId);
389     event EventCompleteSellOrder(address indexed seller, address indexed buyer, uint objId, uint price);
390     event EventOfferBorrowingItem(address indexed lender, uint objId, uint price, uint releaseTime);
391     event EventRemoveOfferBorrowingItem(address indexed lender, uint objId);
392     event EventAcceptBorrowItem(address indexed lender, address indexed borrower, uint objId, uint price);
393     event EventGetBackItem(address indexed lender, address indexed borrower, uint objId);
394     
395     // constructor
396     function EtheremonTrade(address _dataContract, address _battleContract, address _tradingMonDataContract, address _monsterNFTContract) public {
397         dataContract = _dataContract;
398         battleContract = _battleContract;
399         tradingMonDataContract = _tradingMonDataContract;
400         monsterNFTContract = _monsterNFTContract;
401     }
402     
403      // admin & moderators
404     function setOriginalPriceGen0() onlyModerators public {
405         gen0Config[1] = Gen0Config(1, 0.3 ether, 0.003 ether, 374);
406         gen0Config[2] = Gen0Config(2, 0.3 ether, 0.003 ether, 408);
407         gen0Config[3] = Gen0Config(3, 0.3 ether, 0.003 ether, 373);
408         gen0Config[4] = Gen0Config(4, 0.2 ether, 0.002 ether, 437);
409         gen0Config[5] = Gen0Config(5, 0.1 ether, 0.001 ether, 497);
410         gen0Config[6] = Gen0Config(6, 0.3 ether, 0.003 ether, 380); 
411         gen0Config[7] = Gen0Config(7, 0.2 ether, 0.002 ether, 345);
412         gen0Config[8] = Gen0Config(8, 0.1 ether, 0.001 ether, 518); 
413         gen0Config[9] = Gen0Config(9, 0.1 ether, 0.001 ether, 447);
414         gen0Config[10] = Gen0Config(10, 0.2 ether, 0.002 ether, 380); 
415         gen0Config[11] = Gen0Config(11, 0.2 ether, 0.002 ether, 354);
416         gen0Config[12] = Gen0Config(12, 0.2 ether, 0.002 ether, 346);
417         gen0Config[13] = Gen0Config(13, 0.2 ether, 0.002 ether, 351); 
418         gen0Config[14] = Gen0Config(14, 0.2 ether, 0.002 ether, 338);
419         gen0Config[15] = Gen0Config(15, 0.2 ether, 0.002 ether, 341);
420         gen0Config[16] = Gen0Config(16, 0.35 ether, 0.0035 ether, 384);
421         gen0Config[17] = Gen0Config(17, 1 ether, 0.01 ether, 305); 
422         gen0Config[18] = Gen0Config(18, 0.1 ether, 0.001 ether, 427);
423         gen0Config[19] = Gen0Config(19, 1 ether, 0.01 ether, 304);
424         gen0Config[20] = Gen0Config(20, 0.4 ether, 0.05 ether, 82);
425         gen0Config[21] = Gen0Config(21, 1, 1, 123);
426         gen0Config[22] = Gen0Config(22, 0.2 ether, 0.001 ether, 468);
427         gen0Config[23] = Gen0Config(23, 0.5 ether, 0.0025 ether, 302);
428         gen0Config[24] = Gen0Config(24, 1 ether, 0.005 ether, 195);
429     }
430     
431     function setContract(address _dataContract, address _battleContract, address _tradingMonDataContract, address _monsterNFTContract) onlyModerators public {
432         dataContract = _dataContract;
433         battleContract = _battleContract;
434         tradingMonDataContract = _tradingMonDataContract;
435         monsterNFTContract = _monsterNFTContract;
436     }
437     
438     function updateConfig(uint16 _fee) onlyModerators public {
439         tradingFeePercentage = _fee;
440     }
441     
442     function withdrawEther(address _sendTo, uint _amount) onlyModerators public {
443         // no user money is kept in this contract, only trasaction fee
444         if (_amount > this.balance) {
445             revert();
446         }
447         _sendTo.transfer(_amount);
448     }
449 
450     function _triggerNFTEvent(address _from, address _to, uint _objId) internal {
451         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
452         monsterNFT.triggerTransferEvent(_from, _to, _objId);
453     }
454     
455     // public
456     function placeSellOrder(uint _objId, uint _price) isActive external {
457         if (_price == 0)
458             revert();
459         
460         // not on borrowing
461         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
462         if (monTradeData.isOnBorrow(_objId))
463             revert();
464 
465         // not on battle 
466         EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
467         if (battle.isOnBattle(uint64(_objId)))
468             revert();
469         
470         // check ownership
471         EtheremonDataBase data = EtheremonDataBase(dataContract);
472         MonsterObjAcc memory obj;
473         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_objId));
474 
475         if (obj.trainer != msg.sender) {
476             revert();
477         }
478         
479         monTradeData.addSellingItem(_objId, _price, block.timestamp);
480         EventPlaceSellOrder(msg.sender, _objId, _price);
481     }
482     
483     function removeSellOrder(uint _objId) isActive external {
484         // check ownership
485         EtheremonDataBase data = EtheremonDataBase(dataContract);
486         MonsterObjAcc memory obj;
487         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_objId));
488 
489         if (obj.trainer != msg.sender) {
490             revert();
491         }
492         
493         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
494         monTradeData.removeSellingItem(_objId);
495         
496         EventRemoveSellOrder(msg.sender, _objId);
497     }
498     
499     function buyItem(uint _objId) isActive external payable {
500         // check item is valid to sell
501         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
502         uint requestPrice = monTradeData.getSellPrice(_objId);
503         if (requestPrice == 0 || msg.value != requestPrice) {
504             revert();
505         }
506 
507         // check obj
508         EtheremonDataBase data = EtheremonDataBase(dataContract);
509         MonsterObjAcc memory obj;
510         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_objId));
511         // can not buy from yourself
512         if (obj.monsterId == 0 || obj.trainer == msg.sender) {
513             revert();
514         }
515         
516         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
517 
518         uint fee = requestPrice * tradingFeePercentage / 100;
519         monTradeData.removeSellingItem(_objId);
520         
521         // transfer owner
522         data.removeMonsterIdMapping(obj.trainer, obj.monsterId);
523         data.addMonsterIdMapping(msg.sender, obj.monsterId);
524         monsterNFT.triggerTransferEvent(obj.trainer, msg.sender, _objId);
525         
526         // transfer money
527         obj.trainer.transfer(safeSubtract(requestPrice, fee));
528         
529         EventCompleteSellOrder(obj.trainer, msg.sender, _objId, requestPrice);
530     }
531     
532     function offerBorrowingItem(uint _objId, uint _price, uint _releaseTime) isActive external {
533         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
534         if (monTradeData.isOnSell(_objId) || monTradeData.isOnLent(_objId)) revert();
535 
536          // check ownership
537         EtheremonDataBase data = EtheremonDataBase(dataContract);
538         MonsterObjAcc memory obj;
539         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_objId));
540 
541         if (obj.trainer != msg.sender) {
542             revert();
543         }
544 
545         // not on battle 
546         EtheremonBattleInterface battle = EtheremonBattleInterface(battleContract);
547         if (battle.isOnBattle(obj.monsterId))
548             revert();
549         
550         monTradeData.addBorrowingItem(msg.sender, _objId, _price, address(0), false, _releaseTime, block.timestamp);
551         EventOfferBorrowingItem(msg.sender, _objId, _price, _releaseTime);
552     }
553     
554     function removeBorrowingOfferItem(uint _objId) isActive external {
555         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
556         address owner;
557         bool lent;
558         (owner, lent) = monTradeData.getBorrowBasicInfo(_objId);
559         if (owner != msg.sender || lent == true)
560             revert();
561         
562         monTradeData.removeBorrowingItem(_objId);
563         EventRemoveOfferBorrowingItem(msg.sender, _objId);
564     }
565     
566     function borrowItem(uint _objId) isActive external payable {
567         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
568         BorrowItem memory borrowItem;
569         (borrowItem.index, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime) = monTradeData.getBorrowInfo(_objId);
570         if (borrowItem.index == 0 || borrowItem.lent == true) revert();
571         if (borrowItem.owner == msg.sender) revert(); // can not borrow from yourself
572         if (borrowItem.price != msg.value)
573             revert();
574 
575         // check obj
576         EtheremonDataBase data = EtheremonDataBase(dataContract);
577         MonsterObjAcc memory obj;
578         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_objId));
579         if (obj.trainer != borrowItem.owner) {
580             revert();
581         }
582         
583         // update borrow data
584         monTradeData.addBorrowingItem(borrowItem.owner, _objId, borrowItem.price, msg.sender, true, (borrowItem.releaseTime + block.timestamp), borrowItem.createTime);
585         
586         data.removeMonsterIdMapping(obj.trainer, obj.monsterId);
587         data.addMonsterIdMapping(msg.sender, obj.monsterId);
588         _triggerNFTEvent(obj.trainer, msg.sender, _objId);
589         
590         obj.trainer.transfer(safeSubtract(borrowItem.price, borrowItem.price * tradingFeePercentage / 100));
591         monTradeData.addItemLendingList(obj.trainer, _objId);
592         EventAcceptBorrowItem(obj.trainer, msg.sender, _objId, borrowItem.price);
593     }
594     
595     function getBackLendingItem(uint64 _objId) isActive external {
596         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
597         BorrowItem memory borrowItem;
598         (borrowItem.index, borrowItem.owner, borrowItem.borrower, borrowItem.price, borrowItem.lent, borrowItem.createTime, borrowItem.releaseTime) = monTradeData.getBorrowInfo(_objId);
599         
600         if (borrowItem.index == 0)
601             revert();
602         if (borrowItem.lent == false)
603             revert();
604         if (borrowItem.releaseTime > block.timestamp)
605             revert();
606         
607         if (msg.sender != borrowItem.owner)
608             revert();
609         
610         monTradeData.removeBorrowingItem(_objId);
611         
612         EtheremonDataBase data = EtheremonDataBase(dataContract);
613         data.removeMonsterIdMapping(borrowItem.borrower, _objId);
614         data.addMonsterIdMapping(msg.sender, _objId);
615         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
616         monsterNFT.triggerTransferEvent(borrowItem.borrower, msg.sender, _objId);
617         
618         monTradeData.removeItemLendingList(msg.sender, _objId);
619         EventGetBackItem(msg.sender, borrowItem.borrower, _objId);
620     }
621     
622     // read access
623     function getObjInfoWithBp(uint64 _objId) constant public returns(address owner, uint32 classId, uint32 exp, uint32 createIndex, uint bp) {
624         EtheremonDataBase data = EtheremonDataBase(dataContract);
625         MonsterObjAcc memory obj;
626         (obj.monsterId, classId, owner, exp, createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
627         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
628         bp = monsterNFT.getMonsterCP(_objId);
629     }
630     
631     function getTotalSellingMonsters() constant external returns(uint) {
632         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
633         return monTradeData.getTotalSellingItem();
634     }
635     
636     function getTotalBorrowingMonsters() constant external returns(uint) {
637         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
638         return monTradeData.getTotalBorrowingItem();
639     }
640 
641     function getSellingItem(uint _index) constant external returns(uint objId, uint32 classId, uint32 exp, uint bp, address trainer, uint32 createIndex, uint256 price, uint createTime) {
642         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
643         (objId, price, createTime) = monTradeData.getSellingInfoByIndex(_index);
644         if (objId > 0) {
645             (trainer, classId, exp, createIndex, bp) = getObjInfoWithBp(uint64(objId));
646         }
647     }
648     
649     function getSellingItemByObjId(uint64 _objId) constant external returns(uint32 classId, uint32 exp, uint bp, address trainer, uint32 createIndex, uint256 price, uint createTime) {
650         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
651         uint index;
652         (index, price, createTime) = monTradeData.getSellInfo(_objId);
653         if (price > 0) {
654             (trainer, classId, exp, createIndex, bp) = getObjInfoWithBp(_objId);
655         }
656     }
657 
658     function getBorrowingItem(uint _index) constant external returns(uint objId, address owner, address borrower, 
659         uint256 price, bool lent, uint createTime, uint releaseTime) {
660         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);    
661         (objId, owner, borrower, price, lent, createTime, releaseTime) = monTradeData.getBorrowInfoByIndex(_index);
662     }
663     
664     function getBorrowingItemByObjId(uint64 _objId) constant external returns(uint index, address owner, address borrower, 
665         uint256 price, bool lent, uint createTime, uint releaseTime) {
666         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);    
667         (index, owner, borrower, price, lent, createTime, releaseTime) = monTradeData.getBorrowInfo(_objId);
668     }
669     
670     
671     function getLendingItemLength(address _trainer) constant external returns(uint) {
672         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);    
673         return monTradeData.getTotalLendingItem(_trainer);
674     }
675     
676     function getLendingItemInfo(address _trainer, uint _index) constant external returns(uint objId, address owner, address borrower, 
677         uint256 price, bool lent, uint createTime, uint releaseTime) {
678         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
679         (objId, owner, borrower, price, lent, createTime, releaseTime) = monTradeData.getLendingInfo(_trainer, _index);
680     }
681     
682     function getTradingInfo(uint _objId) constant external returns(address owner, address borrower, uint256 sellingPrice, uint256 lendingPrice, bool lent, uint releaseTime) {
683         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
684         (sellingPrice, lendingPrice, lent, releaseTime, owner, borrower) = monTradeData.getTradingInfo(_objId);
685     }
686     
687     function isOnTrading(uint _objId) constant external returns(bool) {
688         EtheremonTradeData monTradeData = EtheremonTradeData(tradingMonDataContract);
689         return monTradeData.isOnTrade(_objId);
690     }
691 }