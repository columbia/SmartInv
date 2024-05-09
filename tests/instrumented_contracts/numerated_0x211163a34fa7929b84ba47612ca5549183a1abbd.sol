1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     emit OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45   /**
46    * @dev Allows the current owner to relinquish control of the contract.
47    */
48   function renounceOwnership() public onlyOwner {
49     emit OwnershipRenounced(owner);
50     owner = address(0);
51   }
52 }
53 
54 /**
55  * @title Pausable
56  * @dev Base contract which allows children to implement an emergency stop mechanism.
57  */
58 contract Pausable is Ownable {
59   event Pause();
60   event Unpause();
61 
62   bool public paused = false;
63 
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is not paused.
67    */
68   modifier whenNotPaused() {
69     require(!paused);
70     _;
71   }
72 
73   /**
74    * @dev Modifier to make a function callable only when the contract is paused.
75    */
76   modifier whenPaused() {
77     require(paused);
78     _;
79   }
80 
81   /**
82    * @dev called by the owner to pause, triggers stopped state
83    */
84   function pause() onlyOwner whenNotPaused public {
85     paused = true;
86     emit Pause();
87   }
88 
89   /**
90    * @dev called by the owner to unpause, returns to normal state
91    */
92   function unpause() onlyOwner whenPaused public {
93     paused = false;
94     emit Unpause();
95   }
96 }
97 
98 /**
99  * @title SafeMath
100  * @dev Math operations with safety checks that throw on error
101  */
102 library SafeMath {
103 
104   /**
105   * @dev Multiplies two numbers, throws on overflow.
106   */
107   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
108     if (a == 0) {
109       return 0;
110     }
111     c = a * b;
112     assert(c / a == b);
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers, truncating the quotient.
118   */
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     // uint256 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return a / b;
124   }
125 
126   /**
127   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128   */
129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130     assert(b <= a);
131     return a - b;
132   }
133 
134   /**
135   * @dev Adds two numbers, throws on overflow.
136   */
137   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
138     c = a + b;
139     assert(c >= a);
140     return c;
141   }
142 }
143 
144 contract CopaCore is Ownable, Pausable {
145   using SafeMath for uint256;
146 
147   CopaMarket private copaMarket;
148 
149   uint256 public packSize;
150   uint256 public packPrice;
151   uint256 public totalCardCount;
152 
153   mapping (address => uint256[1200]) public balances;
154 
155   struct PackBuy {
156     uint256 packSize;
157     uint256 packPrice;
158     uint256[] cardIds;
159   }
160   mapping (address => PackBuy[]) private packBuys;
161 
162   event Transfer(address indexed from, address indexed to, uint256 indexed cardId, uint256 count);
163   event TransferManual(address indexed from, address indexed to, uint256[] cardIds, uint256[] counts);
164   event BuyPack(uint256 indexed id, address indexed buyer, uint256 packSize, uint256 packPrice, uint256[] cardIds);
165   event BuyPacks(uint256 indexed id, address indexed buyer, uint256 packSize, uint256 packPrice, uint256 count);
166 
167   constructor(uint256 _packSize, uint256 _packPrice, uint256 _totalCardCount) public {
168     packSize = _packSize;
169     packPrice = _packPrice;
170     totalCardCount = _totalCardCount;
171   }
172 
173   function getCopaMarketAddress() view external onlyOwner returns(address) {
174     return address(copaMarket);
175   }
176   function setCopaMarketAddress(address _copaMarketAddress) external onlyOwner {
177     copaMarket = CopaMarket(_copaMarketAddress);
178   }
179   modifier onlyCopaMarket() {
180     require(msg.sender == address(copaMarket));
181     _;
182   }
183 
184   function setPackSize(uint256 _packSize) external onlyOwner {
185     require(_packSize > 0);
186 
187     packSize = _packSize;
188   }
189   function setPrice(uint256 _packPrice) external onlyOwner {
190     require(_packPrice > 0);
191 
192     packPrice = _packPrice;
193   }
194   function setTotalCardCount(uint256 _totalCardCount) external onlyOwner {
195     require(_totalCardCount > 0);
196 
197     totalCardCount = _totalCardCount;
198   }
199 
200   function getEthBalance() view external returns(uint256) {
201     return address(this).balance;
202   }
203 
204   function withdrawEthBalance() external onlyOwner {
205     uint256 _ethBalance = address(this).balance;
206     owner.transfer(_ethBalance);
207   }
208 
209   function balanceOf(address _owner, uint256 _cardId) view external returns(uint256) {
210     return balances[_owner][_cardId];
211   }
212   function balancesOf(address _owner) view external returns (uint256[1200]) {
213     return balances[_owner];
214   }
215 
216   function getPackBuy(address _address, uint256 _id) view external returns(uint256, uint256, uint256[]){
217     return (packBuys[_address][_id].packSize, packBuys[_address][_id].packPrice, packBuys[_address][_id].cardIds);
218   }
219 
220   function transfer(address _to, uint256 _cardId, uint256 _count) external whenNotPaused returns(bool) {
221     address _from = msg.sender;
222 
223     require(_to != address(0));
224     require(_count > 0);
225     require(_count <= balances[_from][_cardId]);
226 
227     balances[_from][_cardId] = balances[_from][_cardId].sub(_count);
228     balances[_to][_cardId] = balances[_to][_cardId].add(_count);
229 
230     emit Transfer(_from, _to, _cardId, _count);
231 
232     return true;
233   }
234 
235   function transferMultiple(address _to, uint256[] _cardIds, uint256[] _counts) external whenNotPaused returns(bool) {
236     address _from = msg.sender;
237 
238     require(_to != address(0));
239 
240     for (uint256 i = 0; i < _cardIds.length; i++) {
241       uint256 _cardId = _cardIds[i];
242       uint256 _count = _counts[i];
243 
244       require(_count > 0);
245       require(_count <= balances[_from][_cardId]);
246 
247       balances[_from][_cardId] = balances[_from][_cardId].sub(_count);
248       balances[_to][_cardId] = balances[_to][_cardId].add(_count);
249 
250       emit Transfer(_from, _to, _cardId, _count);
251     }
252 
253     emit TransferManual(_from, _to, _cardIds, _counts);
254 
255     return true;
256   }
257 
258   function transferFrom(address _from, address _to, uint256 _cardId, uint256 _count) external onlyCopaMarket returns(bool) {
259     require(_to != address(0));
260     require(_count > 0);
261     require(_count <= balances[_from][_cardId]);
262 
263     balances[_from][_cardId] = balances[_from][_cardId].sub(_count);
264     balances[_to][_cardId] = balances[_to][_cardId].add(_count);
265 
266     emit Transfer(_from, _to, _cardId, _count);
267 
268     return true;
269   }
270 
271   function buyPack(uint256 _count) external payable whenNotPaused returns(bool) {
272     address _buyer = msg.sender;
273     uint256 _ethAmount = msg.value;
274     uint256 _totalPrice = packPrice * _count;
275 
276     require(_count > 0);
277     require(_ethAmount > 0);
278     require(_ethAmount >= _totalPrice);
279 
280     for (uint256 i = 0; i < _count; i++) {
281       uint256[] memory _cardsList = new uint256[](packSize);
282 
283       for (uint256 j = 0; j < packSize; j++) {
284         uint256 _cardId = dice(totalCardCount);
285 
286         balances[_buyer][_cardId] = balances[_buyer][_cardId].add(1);
287 
288         _cardsList[j] = _cardId;
289 
290         emit Transfer(0x0, _buyer, _cardId, 1);
291       }
292 
293       uint256 _id = packBuys[_buyer].length;
294       packBuys[_buyer].push(PackBuy(packSize, packPrice, _cardsList));
295 
296       emit BuyPack(_id, _buyer, packSize, packPrice, _cardsList);
297     }
298 
299     emit BuyPacks(_id, _buyer, packSize, packPrice, _count);
300 
301     return true;
302   }
303 
304   function getPack(uint256 _count) external onlyOwner whenNotPaused returns(bool) {
305     require(_count > 0);
306 
307     for (uint256 i = 0; i < _count; i++) {
308       uint256[] memory _cardsList = new uint256[](packSize);
309 
310       for (uint256 j = 0; j < packSize; j++) {
311         uint256 _cardId = dice(totalCardCount);
312 
313         balances[owner][_cardId] = balances[owner][_cardId].add(1);
314 
315         _cardsList[j] = _cardId;
316 
317         emit Transfer(0x0, owner, _cardId, 1);
318       }
319 
320       uint256 _id = packBuys[owner].length;
321       packBuys[owner].push(PackBuy(packSize, 0, _cardsList));
322 
323       emit BuyPack(_id, owner, packSize, 0, _cardsList);
324     }
325 
326     emit BuyPacks(_id, owner, packSize, 0, _count);
327 
328     return true;
329   }
330 
331   uint256 seed = 0;
332   function maxDice() private returns (uint256 diceNumber) {
333     seed = uint256(keccak256(keccak256(blockhash(block.number - 1), seed), now));
334     return seed;
335   }
336   function dice(uint256 upper) private returns (uint256 diceNumber) {
337     return maxDice() % upper;
338   }
339 }
340 
341 contract CopaMarket is Ownable, Pausable {
342   using SafeMath for uint256;
343 
344   CopaCore private copaCore;
345 
346   uint256 private lockedEth;
347   uint256 public cut;
348   uint256 public tradingFee;
349   bool private secureFees;
350 
351   struct Buy {
352     uint256 cardId;
353     uint256 count;
354     uint256 ethAmount;
355     bool open;
356   }
357   mapping (address => Buy[]) private buyers;
358 
359   struct Sell {
360     uint256 cardId;
361     uint256 count;
362     uint256 ethAmount;
363     bool open;
364   }
365   mapping (address => Sell[]) private sellers;
366 
367   struct Trade {
368     uint256[] offeredCardIds;
369     uint256[] offeredCardCounts;
370     uint256[] requestedCardIds;
371     uint256[] requestedCardCounts;
372     bool open;
373   }
374   mapping (address => Trade[]) private traders;
375 
376   event NewBuy( address indexed buyer, uint256 indexed id, uint256 cardId, uint256 count, uint256 ethAmount );
377   event CardSold( address indexed buyer, uint256 indexed id, address indexed seller, uint256 cardId, uint256 count, uint256 ethAmount );
378   event CancelBuy( address indexed buyer, uint256 indexed id, uint256 cardId, uint256 count, uint256 ethAmount );
379 
380   event NewSell( address indexed seller, uint256 indexed id, uint256 cardId, uint256 count, uint256 ethAmount );
381   event CardBought( address indexed seller, uint256 indexed id, address indexed buyer, uint256 cardId, uint256 count, uint256 ethAmount );
382   event CancelSell( address indexed seller, uint256 indexed id, uint256 cardId, uint256 count, uint256 ethAmount );
383 
384   event NewTrade( address indexed seller, uint256 indexed id, uint256[] offeredCardIds, uint256[] offeredCardCounts, uint256[] requestedCardIds, uint256[] requestedCardCounts);
385   event CardsTraded( address indexed seller, uint256 indexed id, address indexed buyer, uint256[] offeredCardIds, uint256[] offeredCardCounts, uint256[] requestedCardIds, uint256[] requestedCardCounts);
386   event CancelTrade( address indexed seller, uint256 indexed id, uint256[] offeredCardIds, uint256[] offeredCardCounts, uint256[] requestedCardIds, uint256[] requestedCardCounts);
387 
388   constructor(address _copaCoreAddress, uint256 _cut, uint256 _tradingFee, bool _secureFees) public {
389     copaCore = CopaCore(_copaCoreAddress);
390     cut = _cut;
391     tradingFee = _tradingFee;
392     secureFees = _secureFees;
393 
394     lockedEth = 0;
395   }
396 
397   function getCopaCoreAddress() view external onlyOwner returns(address) {
398     return address(copaCore);
399   }
400   function setCopaCoreAddress(address _copaCoreAddress) external onlyOwner {
401     copaCore = CopaCore(_copaCoreAddress);
402   }
403 
404   function setCut(uint256 _cut) external onlyOwner {
405     require(_cut > 0);
406     require(_cut < 10000);
407 
408     cut = _cut;
409   }
410   function setTradingFee(uint256 _tradingFee) external onlyOwner {
411     require(_tradingFee > 0);
412 
413     tradingFee = _tradingFee;
414   }
415 
416   function getSecureFees() view external onlyOwner returns(bool) {
417     return secureFees;
418   }
419   function setSecureFees(bool _secureFees) external onlyOwner {
420     secureFees = _secureFees;
421   }
422 
423   function getLockedEth() view external onlyOwner returns(uint256) {
424     return lockedEth;
425   }
426   function getEthBalance() view external returns(uint256) {
427     return address(this).balance;
428   }
429 
430   function withdrawEthBalanceSave() external onlyOwner {
431     uint256 _ethBalance = address(this).balance;
432     owner.transfer(_ethBalance - lockedEth);
433   }
434   function withdrawEthBalance() external onlyOwner {
435     uint256 _ethBalance = address(this).balance;
436     owner.transfer(_ethBalance);
437   }
438 
439   function getBuy(uint256 _id, address _address) view external returns(uint256, uint256, uint256, bool){
440     return (buyers[_address][_id].cardId, buyers[_address][_id].count, buyers[_address][_id].ethAmount, buyers[_address][_id].open);
441   }
442   function getSell(uint256 _id, address _address) view external returns(uint256, uint256, uint256, bool){
443     return (sellers[_address][_id].cardId, sellers[_address][_id].count, sellers[_address][_id].ethAmount, sellers[_address][_id].open);
444   }
445   function getTrade(uint256 _id, address _address) view external returns(uint256[], uint256[], uint256[], uint256[], bool){
446     return (traders[_address][_id].offeredCardIds, traders[_address][_id].offeredCardCounts, traders[_address][_id].requestedCardIds, traders[_address][_id].requestedCardCounts, traders[_address][_id].open);
447   }
448 
449   function addToBuyList(uint256 _cardId, uint256 _count) external payable whenNotPaused returns(bool) {
450     address _buyer = msg.sender;
451     uint256 _ethAmount = msg.value;
452 
453     require( _ethAmount > 0 );
454     require( _count > 0 );
455 
456     uint256 _id = buyers[_buyer].length;
457     buyers[_buyer].push(Buy(_cardId, _count, _ethAmount, true));
458 
459     lockedEth += _ethAmount;
460 
461     emit NewBuy(_buyer, _id, _cardId, _count, _ethAmount);
462 
463     return true;
464   }
465 
466   function sellCard(address _buyer, uint256 _id, uint256 _cardId, uint256 _count, uint256 _ethAmount) external whenNotPaused returns(bool) {
467     address _seller = msg.sender;
468 
469     uint256 _cut = 10000 - cut;
470     uint256 _ethAmountAfterCut = (_ethAmount * _cut) / 10000;
471     uint256 _fee = _ethAmount - _ethAmountAfterCut;
472 
473     require( buyers[_buyer][_id].open == true );
474     require( buyers[_buyer][_id].cardId == _cardId );
475     require( buyers[_buyer][_id].count == _count );
476     require( buyers[_buyer][_id].ethAmount == _ethAmount );
477 
478     buyers[_buyer][_id].open = false;
479     lockedEth -= _ethAmount;
480 
481     copaCore.transferFrom(_seller, _buyer, _cardId, _count);
482     _seller.transfer(_ethAmountAfterCut);
483 
484     if(secureFees) {
485       owner.transfer(_fee);
486     }
487 
488     emit CardSold(_buyer, _id, _seller, _cardId, _count, _ethAmount);
489 
490     return true;
491   }
492 
493   function cancelBuy(uint256 _id, uint256 _cardId, uint256 _count, uint256 _ethAmount) external whenNotPaused returns(bool) {
494     address _buyer = msg.sender;
495 
496     require( buyers[_buyer][_id].open == true );
497     require( buyers[_buyer][_id].cardId == _cardId );
498     require( buyers[_buyer][_id].count == _count );
499     require( buyers[_buyer][_id].ethAmount == _ethAmount );
500 
501     lockedEth -= _ethAmount;
502     buyers[_buyer][_id].open = false;
503 
504     _buyer.transfer(_ethAmount);
505 
506     emit CancelBuy(_buyer, _id, _cardId, _count, _ethAmount);
507 
508     return true;
509   }
510 
511   function addToSellList(uint256 _cardId, uint256 _count, uint256 _ethAmount) external whenNotPaused returns(bool) {
512     address _seller = msg.sender;
513 
514     require( _ethAmount > 0 );
515     require( _count > 0 );
516 
517     uint256 _id = sellers[_seller].length;
518     sellers[_seller].push(Sell(_cardId, _count, _ethAmount, true));
519 
520     copaCore.transferFrom(_seller, address(this), _cardId, _count);
521 
522     emit NewSell(_seller, _id, _cardId, _count, _ethAmount);
523 
524     return true;
525   }
526 
527   function buyCard(address _seller, uint256 _id, uint256 _cardId, uint256 _count) external payable whenNotPaused returns(bool) {
528     address _buyer = msg.sender;
529     uint256 _ethAmount = msg.value;
530 
531     uint256 _cut = 10000 - cut;
532     uint256 _ethAmountAfterCut = (_ethAmount * _cut)/10000;
533     uint256 _fee = _ethAmount - _ethAmountAfterCut;
534 
535     require( sellers[_seller][_id].open == true );
536     require( sellers[_seller][_id].cardId == _cardId );
537     require( sellers[_seller][_id].count == _count );
538     require( sellers[_seller][_id].ethAmount <= _ethAmount );
539 
540     sellers[_seller][_id].open = false;
541 
542     copaCore.transfer(_buyer, _cardId, _count);
543     _seller.transfer(_ethAmountAfterCut);
544 
545     if(secureFees) {
546       owner.transfer(_fee);
547     }
548 
549     emit CardBought(_seller, _id, _buyer, _cardId, _count, _ethAmount);
550 
551     return true;
552   }
553 
554   function cancelSell(uint256 _id, uint256 _cardId, uint256 _count, uint256 _ethAmount) external whenNotPaused returns(bool) {
555     address _seller = msg.sender;
556 
557     require( sellers[_seller][_id].open == true );
558     require( sellers[_seller][_id].cardId == _cardId );
559     require( sellers[_seller][_id].count == _count );
560     require( sellers[_seller][_id].ethAmount == _ethAmount );
561 
562     sellers[_seller][_id].open = false;
563 
564     copaCore.transfer(_seller, _cardId, _count);
565 
566     emit CancelSell(_seller, _id, _cardId, _count, _ethAmount);
567 
568     return true;
569   }
570 
571   function addToTradeList(uint256[] _offeredCardIds, uint256[] _offeredCardCounts, uint256[] _requestedCardIds, uint256[] _requestedCardCounts) external whenNotPaused returns(bool) {
572     address _seller = msg.sender;
573 
574     require(_offeredCardIds.length > 0);
575     require(_offeredCardCounts.length > 0);
576     require(_requestedCardIds.length > 0);
577     require(_requestedCardCounts.length > 0);
578 
579     uint256 _id = traders[_seller].length;
580     traders[_seller].push(Trade(_offeredCardIds, _offeredCardCounts, _requestedCardIds, _requestedCardCounts, true));
581 
582     for (uint256 i = 0; i < _offeredCardIds.length; i++) {
583       copaCore.transferFrom(_seller, address(this), _offeredCardIds[i], _offeredCardCounts[i]);
584     }
585 
586     emit NewTrade(_seller, _id, _offeredCardIds, _offeredCardCounts, _requestedCardIds, _requestedCardCounts);
587 
588     return true;
589   }
590 
591   function tradeCards(address _seller, uint256 _id) external payable whenNotPaused returns(bool) {
592     address _buyer = msg.sender;
593     uint256 _ethAmount = msg.value;
594     uint256[] memory _offeredCardIds = traders[_seller][_id].offeredCardIds;
595     uint256[] memory _offeredCardCounts = traders[_seller][_id].offeredCardCounts;
596     uint256[] memory _requestedCardIds = traders[_seller][_id].requestedCardIds;
597     uint256[] memory _requestedCardCounts = traders[_seller][_id].requestedCardCounts;
598 
599     require( traders[_seller][_id].open == true );
600     require( _ethAmount >= tradingFee );
601 
602     traders[_seller][_id].open = false;
603 
604     for (uint256 i = 0; i < _offeredCardIds.length; i++) {
605       copaCore.transfer(_buyer, _offeredCardIds[i], _offeredCardCounts[i]);
606     }
607     for (uint256 j = 0; j < _requestedCardIds.length; j++) {
608       copaCore.transferFrom(_buyer, _seller, _requestedCardIds[j], _requestedCardCounts[j]);
609     }
610 
611     if(secureFees) {
612       owner.transfer(_ethAmount);
613     }
614 
615     emit CardsTraded(_seller, _id, _buyer, _offeredCardIds, _offeredCardCounts, _requestedCardIds, _requestedCardCounts);
616 
617     return true;
618   }
619 
620   function cancelTrade(uint256 _id) external whenNotPaused returns(bool) {
621     address _seller = msg.sender;
622     uint256[] memory _offeredCardIds = traders[_seller][_id].offeredCardIds;
623     uint256[] memory _offeredCardCounts = traders[_seller][_id].offeredCardCounts;
624     uint256[] memory _requestedCardIds = traders[_seller][_id].requestedCardIds;
625     uint256[] memory _requestedCardCounts = traders[_seller][_id].requestedCardCounts;
626 
627     require( traders[_seller][_id].open == true );
628 
629     traders[_seller][_id].open = false;
630 
631     for (uint256 i = 0; i < _offeredCardIds.length; i++) {
632       copaCore.transfer(_seller, _offeredCardIds[i], _offeredCardCounts[i]);
633     }
634 
635     emit CancelTrade(_seller, _id, _offeredCardIds, _offeredCardCounts, _requestedCardIds, _requestedCardCounts);
636 
637     return true;
638   }
639 }