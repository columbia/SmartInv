1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public Master;
10 
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     function Ownable() public {
17         Master = msg.sender;
18     }
19 
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyMaster() {
25         require(msg.sender == Master);
26         _;
27     }
28 
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newMaster.
32      * @param newMaster The address to transfer ownership to.
33      */
34     function transferOwnership(address newMaster) public onlyMaster {
35         if (newMaster != address(0)) {
36             Master = newMaster;
37         }
38     }
39 
40 }
41 
42 
43 
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50     event Pause();
51     event Unpause();
52 
53     bool public paused = false;
54 
55 
56     /**
57      * @dev modifier to allow actions only when the contract IS paused
58      */
59     modifier whenNotPaused() {
60         require(!paused);
61         _;
62     }
63 
64     /**
65      * @dev modifier to allow actions only when the contract IS NOT paused
66      */
67     modifier whenPaused {
68         require(paused);
69         _;
70     }
71 
72     /**
73      * @dev called by the owner to pause, triggers stopped state
74      */
75     function pause() public onlyMaster whenNotPaused returns (bool) {
76         paused = true;
77         Pause();
78         return true;
79     }
80 
81     /**
82      * @dev called by the owner to unpause, returns to normal state
83      */
84     function unpause() public onlyMaster whenPaused returns (bool) {
85         paused = false;
86         Unpause();
87         return true;
88     }
89 }
90 
91 //
92 contract UpgradeInterface {
93 
94     function isUpgradeInterface() public pure returns (bool) {
95         return true;
96     }
97 
98     function tryUpgrade(uint32 carID, uint8 upgradeID) public returns (bool);
99 
100 }
101 
102 contract EtherRacingCore is Ownable, Pausable {
103 
104     uint64 _seed = 0;
105 
106     function random(uint64 upper) internal returns (uint64) {
107         _seed = uint64(keccak256(keccak256(block.blockhash(block.number), _seed), now));
108         return _seed % upper;
109     }
110 
111     struct CarProduct {
112         string name;
113         uint32 basePR; // 44.4 * 100 => 4440
114         uint32 baseTopSpeed; // 155mph * 100 => 15500
115         uint32 baseAcceleration; // 2.70s * 100 => 270
116         uint32 baseBraking; // 99ft * 100 => 9900
117         uint32 baseGrip; // 1.20g * 100 => 120
118 
119         // variables for auction
120         uint256 startPrice;
121         uint256 currentPrice;
122 
123         uint256 earning;
124         uint256 createdAt;
125 
126         //
127         uint32 entityCounter;
128         bool sale;
129     }
130 
131     struct CarEntity {
132         uint32 productID;
133         address owner;
134         address earner;
135         bool selling;
136         uint256 auctionID;
137 
138         // Each car has unique stats.
139         uint32 level;
140         uint32 exp;
141         uint64 genes;
142         uint8[8] upgrades;
143 
144         //
145         uint32 lastCashoutIndex;
146     }
147 
148 
149     struct AuctionEntity {
150         uint32 carID;
151         uint256 startPrice;
152         uint256 finishPrice;
153         uint256 startTime;
154         uint256 duration;
155     }
156 
157     //
158     uint32 public newCarID = 1;
159     uint32 public newCarProductID = 1;
160     uint256 public newAuctionID = 1;
161     bool canInit = true;
162 
163     mapping(uint32 => CarEntity) cars;
164     mapping(uint32 => CarProduct) carProducts;
165     mapping(uint256 => AuctionEntity) auctions;
166     mapping(address => uint256) balances;
167 
168     event EventCashOut (
169         address indexed player,
170         uint256 amount
171     );
172 
173     event EventWinReward (
174         address indexed player,
175         uint256 amount
176     );
177 
178     event EventUpgradeCar (
179         address indexed player,
180         uint32 carID,
181         uint8 statID,
182         uint8 upgradeLevel
183     );
184 
185     event EventLevelUp (
186         uint32 carID,
187         uint32 level,
188         uint32 exp
189     );
190 
191     event EventTransfer (
192         address indexed player,
193         address indexed receiver,
194         uint32 carID
195     );
196 
197     event EventTransferAction (
198         address indexed player,
199         address indexed receiver,
200         uint32 carID,
201         uint8 actionType
202     );
203 
204     event EventAuction (
205         address indexed player,
206         uint32 carID,
207         uint256 startPrice,
208         uint256 finishPrice,
209         uint256 duration,
210         uint256 createdAt
211     );
212 
213     event EventCancelAuction (
214         uint32 carID
215     );
216 
217     event EventBid (
218         address indexed player,
219         uint32 carID
220     );
221 
222     event EventProduct (
223         uint32 productID,
224         string name,
225         uint32 basePR,
226         uint32 baseTopSpeed,
227         uint32 baseAcceleration,
228         uint32 baseBraking,
229         uint32 baseGrip,
230         uint256 price,
231         uint256 earning,
232         uint256 createdAt
233     );
234 
235     event EventProductEndSale (
236         uint32 productID
237     );
238 
239     event EventBuyCar (
240         address indexed player,
241         uint32 productID,
242         uint32 carID
243     );
244 
245 
246     UpgradeInterface upgradeInterface;
247     uint256 public constant upgradePrice = 50 finney;
248     uint256 public constant ownerCut = 500;
249 
250     function setUpgradeAddress(address _address) external onlyMaster {
251         UpgradeInterface c = UpgradeInterface(_address);
252         require(c.isUpgradeInterface());
253 
254         // Set the new contract address
255         upgradeInterface = c;
256     }
257 
258     function EtherRacingCore() public {
259 
260         addCarProduct("ER-1", 830,  15500, 530, 11200, 90,  10 finney,   0.1 finney);
261         addCarProduct("ER-2", 1910, 17100, 509, 10700, 95,  50 finney,   0.5 finney);
262         addCarProduct("ER-3", 2820, 18300, 450, 10500, 100, 100 finney,  1 finney);
263         addCarProduct("ER-4", 3020, 17700, 419, 10400, 99,  500 finney,  5 finney);
264         addCarProduct("ER-5", 4440, 20500, 379, 10100, 99,  1000 finney, 10 finney);
265         addCarProduct("ER-6", 4520, 22000, 350, 10400, 104, 1500 finney, 15 finney);
266         addCarProduct("ER-7", 4560, 20500, 340, 10200, 104, 2000 finney, 20 finney);
267         addCarProduct("ER-8", 6600, 21700, 290, 9100,  139, 2500 finney, 25 finney);
268     }
269 
270     function CompleteInit() public onlyMaster {
271         canInit = false;
272     }
273 
274     function cashOut(uint256 _amount) public whenNotPaused {
275         require(_amount >= 0);
276         require(_amount == uint256(uint128(_amount)));
277         require(this.balance >= _amount);
278         require(balances[msg.sender] >= _amount);
279 
280         if (_amount == 0)
281             _amount = balances[msg.sender];
282 
283         balances[msg.sender] -= _amount;
284 
285         if (!msg.sender.send(_amount))
286             balances[msg.sender] += _amount;
287 
288         EventCashOut(msg.sender, _amount);
289     }
290 
291     function cashOutCar(uint32 _carID) public whenNotPaused {
292         require(_carID > 0 && _carID < newCarID);
293         require(cars[_carID].owner == msg.sender);
294         uint256 _amount = getCarEarning(_carID);
295         require(this.balance >= _amount);
296         require(_amount > 0);
297 
298         var car = cars[_carID];
299 
300         var lastCashoutIndex = car.lastCashoutIndex;
301         var limitCashoutIndex = carProducts[car.productID].entityCounter;
302 
303         //
304         cars[_carID].lastCashoutIndex = limitCashoutIndex;
305 
306         // if fail, revert.
307         if (!car.owner.send(_amount))
308             cars[_carID].lastCashoutIndex = lastCashoutIndex;
309 
310         EventCashOut(msg.sender, _amount);
311     }
312 
313     function upgradeCar(uint32 _carID, uint8 _statID) public payable whenNotPaused {
314         require(_carID > 0 && _carID < newCarID);
315         require(cars[_carID].owner == msg.sender);
316         require(_statID >= 0 && _statID < 8);
317         require(cars[_statID].upgrades[_statID] < 20);
318         require(msg.value >= upgradePrice);
319         require(upgradeInterface != address(0));
320 
321         //
322         if (upgradeInterface.tryUpgrade(_carID, _statID)) {
323             cars[_carID].upgrades[_statID]++;
324         }
325 
326         //
327         balances[msg.sender] += msg.value - upgradePrice;
328         balances[Master] += upgradePrice;
329 
330         EventUpgradeCar(msg.sender, _carID, _statID, cars[_carID].upgrades[_statID]);
331     }
332 
333     function levelUpCar(uint32 _carID, uint32 _level, uint32 _exp) public onlyMaster {
334         require(_carID > 0 && _carID < newCarID);
335 
336         cars[_carID].level = _level;
337         cars[_carID].exp = _exp;
338 
339         EventLevelUp(_carID, _level, _exp);
340     }
341 
342     function _transfer(uint32 _carID, address _receiver) public whenNotPaused {
343         require(_carID > 0 && _carID < newCarID);
344         require(cars[_carID].owner == msg.sender);
345         require(msg.sender != _receiver);
346         require(cars[_carID].selling == false);
347         cars[_carID].owner = _receiver;
348         cars[_carID].earner = _receiver;
349 
350         EventTransfer(msg.sender, _receiver, _carID);
351     }
352 
353     function _transferAction(uint32 _carID, address _receiver, uint8 _ActionType) public whenNotPaused {
354         require(_carID > 0 && _carID < newCarID);
355         require(cars[_carID].owner == msg.sender);
356         require(msg.sender != _receiver);
357         require(cars[_carID].selling == false);
358         cars[_carID].owner = _receiver;
359 
360         EventTransferAction(msg.sender, _receiver, _carID, _ActionType);
361     }
362 
363     function addAuction(uint32 _carID, uint256 _startPrice, uint256 _finishPrice, uint256 _duration) public whenNotPaused {
364         require(_carID > 0 && _carID < newCarID);
365         require(cars[_carID].owner == msg.sender);
366         require(cars[_carID].selling == false);
367         require(_startPrice >= _finishPrice);
368         require(_startPrice > 0 && _finishPrice >= 0);
369         require(_duration > 0);
370         require(_startPrice == uint256(uint128(_startPrice)));
371         require(_finishPrice == uint256(uint128(_finishPrice)));
372 
373         auctions[newAuctionID] = AuctionEntity(_carID, _startPrice, _finishPrice, now, _duration);
374         cars[_carID].selling = true;
375         cars[_carID].auctionID = newAuctionID++;
376 
377         EventAuction(msg.sender, _carID, _startPrice, _finishPrice, _duration, now);
378     }
379 
380     function bid(uint32 _carID) public payable whenNotPaused {
381         require(_carID > 0 && _carID < newCarID);
382         require(cars[_carID].selling == true);
383 
384         //
385         uint256 currentPrice = getCarCurrentPriceAuction(_carID);
386         require(currentPrice >= 0);
387         require(msg.value >= currentPrice);
388 
389         //
390         uint256 marketFee = currentPrice * ownerCut / 10000;
391         balances[cars[_carID].owner] += currentPrice - marketFee;
392         balances[Master] += marketFee;
393         balances[msg.sender] += msg.value - currentPrice;
394 
395         //
396         cars[_carID].owner = msg.sender;
397         cars[_carID].selling = false;
398         delete auctions[cars[_carID].auctionID];
399         cars[_carID].auctionID = 0;
400 
401         //
402         EventBid(msg.sender, _carID);
403     }
404 
405     // Cancel auction
406     function cancelAuction(uint32 _carID) public whenNotPaused {
407         require(_carID > 0 && _carID < newCarID);
408         require(cars[_carID].selling == true);
409         require(cars[_carID].owner == msg.sender);
410         // only owner can do this.
411         cars[_carID].selling = false;
412         delete auctions[cars[_carID].auctionID];
413         cars[_carID].auctionID = 0;
414 
415         //
416         EventCancelAuction(_carID);
417     }
418 
419     function addCarProduct(string _name, uint32 pr,
420         uint32 topSpeed, uint32 acceleration, uint32 braking, uint32 grip, uint256 _price, uint256 _earning) public onlyMaster {
421         carProducts[newCarProductID++] = CarProduct(_name,
422             pr, topSpeed, acceleration, braking, grip, _price, _price, _earning, now, 0, true);
423 
424         EventProduct(newCarProductID - 1, _name,
425             pr, topSpeed, acceleration, braking, grip, _price, _earning, now);
426     }
427 
428     // car sales are limited
429     function endSaleCarProduct(uint32 _carProductID) public onlyMaster {
430         require(_carProductID > 0 && _carProductID < newCarProductID);
431         carProducts[_carProductID].sale = false;
432 
433         EventProductEndSale(_carProductID);
434     }
435 
436     function addCarInit(address owner, uint32 _carProductID, uint32 level, uint32 exp, uint64 genes) public onlyMaster {
437         require(canInit == true);
438         require(_carProductID > 0 && _carProductID < newCarProductID);
439 
440         //
441         carProducts[_carProductID].currentPrice += carProducts[_carProductID].earning;
442 
443         //
444         cars[newCarID++] = CarEntity(_carProductID, owner, owner, false, 0,
445             level, exp, genes,
446             [0, 0, 0, 0, 0, 0, 0, 0], ++carProducts[_carProductID].entityCounter);
447 
448         //
449         EventBuyCar(owner, _carProductID, newCarID - 1);
450     }
451 
452     function buyCar(uint32 _carProductID) public payable {
453         require(_carProductID > 0 && _carProductID < newCarProductID);
454         require(carProducts[_carProductID].currentPrice > 0 && msg.value > 0);
455         require(msg.value >= carProducts[_carProductID].currentPrice);
456         require(carProducts[_carProductID].sale);
457 
458         //
459         if (msg.value > carProducts[_carProductID].currentPrice)
460             balances[msg.sender] += msg.value - carProducts[_carProductID].currentPrice;
461 
462         carProducts[_carProductID].currentPrice += carProducts[_carProductID].earning;
463 
464         //
465         cars[newCarID++] = CarEntity(_carProductID, msg.sender, msg.sender, false, 0,
466             1, 0, random(~uint64(0)),
467             [0, 0, 0, 0, 0, 0, 0, 0], ++carProducts[_carProductID].entityCounter);
468 
469         // send balance to Master
470         balances[Master] += carProducts[_carProductID].startPrice;
471 
472         //
473         EventBuyCar(msg.sender, _carProductID, newCarID - 1);
474     }
475 
476     function getCarProductName(uint32 _id) public constant returns (string) {
477         return carProducts[_id].name;
478     }
479 
480     function getCarProduct(uint32 _id) public constant returns (uint32[6]) {
481         var carProduct = carProducts[_id];
482         return [carProduct.basePR,
483         carProduct.baseTopSpeed,
484         carProduct.baseAcceleration,
485         carProduct.baseBraking,
486         carProduct.baseGrip,
487         uint32(carProducts[_id].createdAt)];
488     }
489 
490     function getCarDetails(uint32 _id) public constant returns (uint64[12]) {
491         var car = cars[_id];
492         return [uint64(car.productID),
493         uint64(car.genes),
494         uint64(car.upgrades[0]),
495         uint64(car.upgrades[1]),
496         uint64(car.upgrades[2]),
497         uint64(car.upgrades[3]),
498         uint64(car.upgrades[4]),
499         uint64(car.upgrades[5]),
500         uint64(car.upgrades[6]),
501         uint64(car.upgrades[7]),
502         uint64(car.level),
503         uint64(car.exp)
504         ];
505     }
506 
507     function getCarOwner(uint32 _id) public constant returns (address) {
508         return cars[_id].owner;
509     }
510 
511     function getCarSelling(uint32 _id) public constant returns (bool) {
512         return cars[_id].selling;
513     }
514 
515     function getCarAuctionID(uint32 _id) public constant returns (uint256) {
516         return cars[_id].auctionID;
517     }
518 
519     function getCarEarning(uint32 _id) public constant returns (uint256) {
520         var car = cars[_id];
521         var carProduct = carProducts[car.productID];
522         var limitCashoutIndex = carProduct.entityCounter;
523 
524         //
525         return carProduct.earning *
526             (limitCashoutIndex - car.lastCashoutIndex);
527     }
528 
529     function getCarCount() public constant returns (uint32) {
530         return newCarID-1;
531     }
532 
533     function getCarCurrentPriceAuction(uint32 _id) public constant returns (uint256) {
534         require(getCarSelling(_id));
535         var car = cars[_id];
536         var currentAuction = auctions[car.auctionID];
537         uint256 currentPrice = currentAuction.startPrice
538         - (((currentAuction.startPrice - currentAuction.finishPrice) / (currentAuction.duration)) * (now - currentAuction.startTime));
539         if (currentPrice < currentAuction.finishPrice)
540             currentPrice = currentAuction.finishPrice;
541         return currentPrice;
542     }
543 
544     function getCarProductCurrentPrice(uint32 _id) public constant returns (uint256) {
545         return carProducts[_id].currentPrice;
546     }
547 
548     function getCarProductEarning(uint32 _id) public constant returns (uint256) {
549         return carProducts[_id].earning;
550     }
551 
552     function getCarProductCount() public constant returns (uint32) {
553         return newCarProductID-1;
554     }
555 
556     function getPlayerBalance(address _player) public constant returns (uint256) {
557         return balances[_player];
558     }
559 }