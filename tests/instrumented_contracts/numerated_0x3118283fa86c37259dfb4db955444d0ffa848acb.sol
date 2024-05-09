1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     constructor () public{
17         owner = msg.sender;
18     }
19 
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner, "401: Only the contract owner can call this method.");
26         _;
27     }
28 
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newOwner.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) public onlyOwner {
35         if (newOwner != address(0)) {
36             owner = newOwner;
37         }
38     }
39 
40 }
41 
42 contract EthEggBase is Ownable{
43     enum EggStatus{preSell, selling, brood, finished, notExist}
44     enum MsgType{other, buySuccess, buyFail, sellSuccess, prIncome, chickenDie, eggNotEnough, hatch, moneyIncorrect, prSelf, prNotBuy}
45     struct Egg{
46         uint64 eggId;
47         uint8 batchNum;
48         EggStatus eggStatus;
49         uint32 chickenId;
50         address eggOwner;
51     }
52 
53     struct Chicken{
54         uint32 chickenId;
55         uint8 bornNum;
56         address chickenOwner;
57     }
58 
59     Egg[] eggs;
60     Chicken[] chickens;
61     mapping(address=>uint32[]) userToChickenIds;
62     mapping(address=>uint64[]) userToEggIds;    //the eggs for user's chicken brood only, not include eggs from buying
63 
64 
65     uint8 currentBatchNum;
66     uint64 currentSellEggIndex;
67     uint256 currentPrice;
68     uint256 initPrice;
69     uint256 eggsCount=1;
70 
71     mapping(address=>uint32) userToChickenCnt;
72     mapping(address=>uint32) userToDeadChickenCnt;
73     mapping(uint8=>uint64) batchNumToCount;
74 
75     uint8 maxHatch;
76 
77     event Message(address _to, uint256 _val1, uint256 _val2, MsgType _msgType, uint64 _msgTime);
78     event DebugBuy(address _to, address _from, uint256 _balance, uint64 _eggId, EggStatus _eggStatus, uint32 _chickenId);
79 
80     function calcPrice() internal {
81         if (currentBatchNum == 0){
82             currentPrice = initPrice;
83         }else{
84             currentPrice = initPrice * (9**uint256(currentBatchNum)) / (10**uint256(currentBatchNum));
85         }
86 
87     }
88 
89     constructor() public {
90         currentBatchNum = 0;
91 
92         maxHatch = 99;           //default 99
93         batchNumToCount[0]=10;    //set to 100 default;
94 
95         initPrice = 1000000000000000000;
96         calcPrice();
97     }
98 
99     function initParams(uint64 _alphaEggCnt) public onlyOwner {
100         require(eggs.length==0);
101         // maxHatch = _maxHatch;           //default 99
102         batchNumToCount[0]=_alphaEggCnt;    //set to 100 default;
103         batchNumToCount[1]=_alphaEggCnt;
104         batchNumToCount[2]=batchNumToCount[1]*2;
105         batchNumToCount[3]=batchNumToCount[2]*2;
106         batchNumToCount[4]=batchNumToCount[3]*2;
107         calcBatchCnt(5,50);
108     }
109 
110     //init 100 eggs, price:1 ether
111     function initEggs(uint8 _genAmount) external {
112         require(eggs.length < batchNumToCount[0], "402:Init Eth eggs already generated.");
113 
114         for (uint8 i=1; i <= _genAmount && eggs.length<=batchNumToCount[0]; i++){
115             uint64 _eggId = uint64(eggs.length + 1);
116             Egg memory _egg = Egg({
117                 eggId:_eggId,
118                 batchNum:currentBatchNum,
119                 eggStatus:EggStatus.selling,
120                 chickenId:0,    //that means not egg for any chicken
121                 eggOwner:owner  //the contract's egg
122                 });
123             eggs.push(_egg);
124         }
125         eggsCount+=_genAmount;
126 
127     }
128 
129     function calcBatchCnt(uint8 _beginIndex, uint8 _endIndex) internal {
130         require (_beginIndex >=5);
131         require (_endIndex <= 50);
132         require (batchNumToCount[_beginIndex]==0);
133         for (uint8 _batchIndex=_beginIndex; _batchIndex< _endIndex; _batchIndex++){
134             if (batchNumToCount[_batchIndex] == 0){
135                 batchNumToCount[_batchIndex] = batchNumToCount[_batchIndex-1] * 2 - batchNumToCount[_batchIndex-5];
136             }
137         }
138     }
139 
140 }
141 contract EthEggInfo is EthEggBase {
142 
143     function getPrice() external view returns (uint256){
144         return currentPrice;
145     }
146 
147     function getEggsCount() public view returns (uint256){
148         return eggsCount - 1;
149     }
150 
151 
152 
153     function getFarm() external view returns
154     (uint32 [] chickenIds,
155         EggStatus[] eggStatus1,
156         EggStatus[] eggStatus2,
157         EggStatus[] eggStatus3,
158         EggStatus[] eggStatus4
159     ){
160         uint32[] memory _chickenIds = userToChickenIds[msg.sender];
161         EggStatus[] memory _eggStatus1 = new EggStatus[](_getChickenCnt(msg.sender));
162         EggStatus[] memory _eggStatus2 = new EggStatus[](_getChickenCnt(msg.sender));
163         EggStatus[] memory _eggStatus3 = new EggStatus[](_getChickenCnt(msg.sender));
164         EggStatus[] memory _eggStatus4 = new EggStatus[](_getChickenCnt(msg.sender));
165 
166         for (uint32 _index=0; _index < _chickenIds.length; _index++){
167             Chicken memory _c = chickens[_chickenIds[_index]-1];
168             uint8 _maxEggCount=4;
169             uint64[] memory _eggIds = userToEggIds[msg.sender];
170             for (uint64 j=0; j<_eggIds.length; j++){
171                 Egg memory _e = eggs[_eggIds[j]-1];
172                 if (_c.chickenId == _e.chickenId){
173                     if (_maxEggCount==4){
174                         _eggStatus1[_index] = getEggStatus(_e.eggStatus,_e.batchNum);
175                     }else if(_maxEggCount==3){
176                         _eggStatus2[_index] = getEggStatus(_e.eggStatus,_e.batchNum);
177                     }else if(_maxEggCount==2){
178                         _eggStatus3[_index] = getEggStatus(_e.eggStatus,_e.batchNum);
179                     }else if(_maxEggCount==1){
180                         _eggStatus4[_index] = getEggStatus(_e.eggStatus,_e.batchNum);
181                     }
182                     _maxEggCount--;
183                 }
184             }
185             for (;_maxEggCount>0;_maxEggCount--){
186                 if (_maxEggCount==4){
187                     _eggStatus1[_index] = EggStatus.notExist;
188                 }else if(_maxEggCount==3){
189                     _eggStatus2[_index] = EggStatus.notExist;
190                 }else if(_maxEggCount==2){
191                     _eggStatus3[_index] = EggStatus.notExist;
192                 }else if(_maxEggCount==1){
193                     _eggStatus4[_index] = EggStatus.notExist;
194                 }
195             }
196         }
197         chickenIds = _chickenIds;
198         eggStatus1 = _eggStatus1;
199         eggStatus2 = _eggStatus2;
200         eggStatus3 = _eggStatus3;
201         eggStatus4 = _eggStatus4;
202     }
203 
204     function getEggStatus(EggStatus _eggStatus, uint8 _batchNum) internal view returns(EggStatus){
205         if (_batchNum > currentBatchNum && _eggStatus==EggStatus.selling){
206             return EggStatus.preSell;
207         }else{
208             return _eggStatus;
209         }
210     }
211 
212     //The Amount of chicken alive
213     function getChickenAmount() public view returns (uint32){
214         return userToChickenCnt[msg.sender] - userToDeadChickenCnt[msg.sender];
215     }
216 
217     //include dead and alive chickens
218     function _getChickenCnt(address _user) internal view returns (uint16){
219         uint128 _chickenSize = uint128(chickens.length);
220         uint16 _userChickenCnt = 0;
221         for(uint128 i=_chickenSize; i>0; i--){
222             Chicken memory _c = chickens[i-1];
223             if (_user == _c.chickenOwner){
224                 _userChickenCnt++;
225             }
226         }
227         return _userChickenCnt;
228     }
229 
230     function getFreeHatchCnt() public view returns(uint32){
231         return _getFreeHatchCnt(msg.sender);
232     }
233 
234     function _getFreeHatchCnt(address _user) internal view returns(uint32){
235         uint32 _maxHatch = uint32(maxHatch);
236         if (_maxHatch >= (userToChickenCnt[_user] - userToDeadChickenCnt[_user])){
237             return _maxHatch - (userToChickenCnt[_user] - userToDeadChickenCnt[_user]);
238         } else {
239             return 0;
240         }
241     }
242 
243 
244 }
245 contract EthEggTx is EthEggInfo{
246     function buy(uint8 _buyCount) external payable {
247         uint8 _cnt = _buyCount;
248         uint256 _val = msg.value;
249         require(0<_buyCount && _buyCount<=10);
250         if (eggsCount < _cnt){
251             msg.sender.transfer(_val);
252             emit Message(msg.sender, _val, 0, MsgType.eggNotEnough, uint64(now));
253             return;
254         }
255         if (getFreeHatchCnt() < _buyCount){
256             msg.sender.transfer(_val);
257             emit Message(msg.sender, _val, 0, MsgType.hatch, uint64(now));
258             return;
259         }
260         if (_val != currentPrice * _buyCount){
261             msg.sender.transfer(_val);
262             emit Message(msg.sender, _val, 0, MsgType.moneyIncorrect, uint64(now));
263             return;
264         }
265         uint256 _servCharge = 0;
266         for (uint64 i=currentSellEggIndex; i<eggs.length; i++){
267             Egg storage _egg = eggs[i];
268             if (getEggStatus(_egg.eggStatus, _egg.batchNum) == EggStatus.preSell){
269                 break;
270             }
271             _egg.eggStatus = EggStatus.brood;
272             address _oldOwner = _egg.eggOwner;
273             _egg.eggOwner = msg.sender;
274 
275             eggsCount--;
276 
277             _oldOwner.transfer(currentPrice * 7 / 10);
278             _servCharge += currentPrice * 3/ 10;
279 
280             chickenBornEgg(_oldOwner, _egg.chickenId);
281 
282             eggBroodToChicken(msg.sender);
283 
284             _cnt--;
285 
286             //send sell success message.
287             emit Message(_oldOwner, currentPrice * 7 / 10, uint256(_egg.chickenId), MsgType.sellSuccess, uint64(now));
288 
289             if (_cnt<=0){
290                 break;
291             }
292         }
293         currentSellEggIndex = currentSellEggIndex + _buyCount - _cnt;
294         _preSellToSelling();
295         owner.transfer(_servCharge);
296 
297         //send buy success message.
298         emit Message(msg.sender, _val, uint256(_buyCount - _cnt), MsgType.buySuccess, uint64(now));
299     }
300 
301     //when user purchase an egg use a promote code
302     function buyWithPr(uint8 _buyCount, address _prUser) external payable{
303         uint8 _cnt = _buyCount;
304         uint256 _val = msg.value;
305         require(0<_buyCount && _buyCount<=10);
306         if (msg.sender == _prUser){
307             msg.sender.transfer(_val);
308             emit Message(msg.sender, _val, 0, MsgType.prSelf, uint64(now));
309             return;
310         }
311         if (userToChickenCnt[_prUser]==0){
312             msg.sender.transfer(_val);
313             emit Message(msg.sender, _val, 0, MsgType.prNotBuy, uint64(now));
314             return;
315         }
316         if (eggsCount < _cnt){
317             msg.sender.transfer(_val);
318             emit Message(msg.sender, _val, 0, MsgType.eggNotEnough, uint64(now));
319             return;
320         }
321         if (getFreeHatchCnt() < _buyCount){
322             msg.sender.transfer(_val);
323             emit Message(msg.sender, _val, 0, MsgType.hatch, uint64(now));
324             return;
325         }
326         if (_val != currentPrice * _buyCount){
327             msg.sender.transfer(_val);
328             emit Message(msg.sender, _val, 0, MsgType.moneyIncorrect, uint64(now));
329             return;
330         }
331 
332         uint256 _servCharge = 0;
333         uint256 _prIncome = 0;
334         for (uint64 i=currentSellEggIndex; i<eggs.length; i++){
335             Egg storage _egg = eggs[i];
336             if (getEggStatus(_egg.eggStatus, _egg.batchNum) == EggStatus.preSell){
337                 break;
338             }
339 
340             _egg.eggStatus = EggStatus.brood;
341             address _oldOwner = _egg.eggOwner;
342             _egg.eggOwner = msg.sender;
343 
344             eggsCount--;
345 
346             //debug message
347             // emit DebugBuy(msg.sender, _oldOwner, currentPrice, _egg.eggId, getEggStatus(_egg.eggStatus, _egg.batchNum), _egg.chickenId);
348 
349             _oldOwner.transfer(currentPrice * 7 / 10);
350             _prIncome += currentPrice * 8/ 100;
351             _servCharge += currentPrice * 22/ 100;
352 
353             chickenBornEgg(_oldOwner, _egg.chickenId);
354 
355             // userToChickenCnt[msg.sender]++;
356             eggBroodToChicken(msg.sender);
357 
358             _cnt--;
359 
360             //send sell success message.
361             emit Message(_oldOwner, currentPrice * 7 / 10, uint256(_egg.chickenId), MsgType.sellSuccess, uint64(now));
362 
363             if (_cnt<=0){
364                 break;
365             }
366         }
367         currentSellEggIndex = currentSellEggIndex + _buyCount - _cnt;
368         _preSellToSelling();
369         _prUser.transfer(_prIncome);
370         owner.transfer(_servCharge);
371 
372         //send pr message.
373         emit Message(_prUser, _prIncome, uint256(_buyCount - _cnt), MsgType.prIncome, uint64(now));
374 
375         //send buy success message.
376         emit Message(msg.sender, _val, uint256(_buyCount - _cnt), MsgType.buySuccess, uint64(now));
377     }
378 
379     function chickenBornEgg(address _user, uint32 _chickenId) internal {
380         if (_user == owner){
381             return;
382         }
383 
384         if (_chickenId == 0){
385             return;
386         }
387 
388         Chicken storage _chicken = chickens[_chickenId-1];
389         if (_chicken.bornNum < 4){
390             _chicken.bornNum++;
391             uint64 _eggId = uint64(eggs.length+1);
392             uint8 _batchNum = _getBatchNumByEggId(_eggId);
393             EggStatus _status = EggStatus.selling;
394             Egg memory _egg = Egg({
395                 eggId: _eggId,
396                 batchNum: _batchNum,
397                 eggStatus: _status,
398                 chickenId: _chickenId,
399                 eggOwner: _user
400                 });
401             eggs.push(_egg);
402             userToEggIds[_user].push(_eggId);
403         } else if (_chicken.bornNum == 4){
404             userToDeadChickenCnt[_user]++;
405             emit Message(_chicken.chickenOwner, uint256(_chickenId), uint256(_chicken.chickenId), MsgType.chickenDie, uint64(now));
406         }
407     }
408 
409     function eggBroodToChicken(address _user) internal {
410         if (owner != _user && _getFreeHatchCnt(_user) > 0){
411             uint32 _chickenId = uint32(chickens.length+1);
412             Chicken memory _chicken = Chicken({
413                 chickenId:_chickenId,
414                 bornNum:0,
415                 chickenOwner:_user
416                 });
417             chickens.push(_chicken);
418             userToChickenCnt[_user]++;
419             userToChickenIds[_user].push(_chickenId);
420 
421             //and then the chicken generate an egg.
422             chickenBornEgg(_user, _chickenId);
423         }
424 
425     }
426 
427     function _preSellToSelling() internal {
428         if (getEggsCount()==0){
429             currentBatchNum++;
430             uint64 _cnt = 0;
431             for(uint64 _index = currentSellEggIndex; _index < eggs.length; _index++){
432                 Egg memory _egg = eggs[_index];
433                 if (getEggStatus(_egg.eggStatus, _egg.batchNum) == EggStatus.preSell){
434                     break;
435                 }
436                 if (getEggStatus(_egg.eggStatus, _egg.batchNum) == EggStatus.selling){
437                     _cnt++;
438                 }
439             }
440             eggsCount = eggsCount + _cnt;
441             if (getEggsCount()>0){
442                 calcPrice();
443             }
444         }
445     }
446 
447     function _getBatchNumByEggId(uint64 _eggId) internal view returns(uint8){
448         int128 _count = int128(_eggId);
449         uint8 _batchNo = 0;
450         for(;_batchNo<=49;_batchNo++){
451             _count = _count - int128(batchNumToCount[_batchNo]);
452             if (_count <= 0){
453                 break;
454             }
455         }
456         return _batchNo;
457     }
458 
459 
460     function testEggIds() public view returns(uint64[]){
461         uint64[] memory _ids = new uint64[](eggs.length);
462         for(uint64 i=0; i < uint64(eggs.length); i++){
463             _ids[i] = eggs[i].eggId;
464         }
465         return _ids;
466     }
467 
468     function testChickenInfo(uint32 _chickenId) public view returns(uint32, uint8, address){
469         require(_chickenId>0);
470         Chicken memory _chicken = chickens[_chickenId-1];
471         return (_chicken.chickenId, _chicken.bornNum, _chicken.chickenOwner);
472     }
473 
474     function testEggInfo(uint64 _eggId) public view returns(uint64 cid, uint8 batchNum, EggStatus eggStatus, uint32 chickenId, address eggOwner){
475         require(_eggId>0);
476         Egg memory _egg = eggs[_eggId-1];
477         uint8 _batchNum = _egg.batchNum;
478         EggStatus _eggStatus = getEggStatus(_egg.eggStatus, _egg.batchNum);
479         uint32 _chickenId = _egg.chickenId;
480         address _eggOwner = _egg.eggOwner;
481         return (_eggId, _batchNum, _eggStatus, _chickenId, _eggOwner);
482     }
483 
484     function testChickenCnt() external view returns(uint32){
485         return userToChickenCnt[msg.sender];
486     }
487 
488     function testDeadChickenCnt() external view returns(uint32){
489         return userToDeadChickenCnt[msg.sender];
490     }
491 }