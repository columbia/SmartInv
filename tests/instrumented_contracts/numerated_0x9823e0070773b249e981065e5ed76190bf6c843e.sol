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
144 contract CopaMarket is Ownable, Pausable {
145   using SafeMath for uint256;
146 
147   CopaCore private copaCore;
148 
149   uint256 private lockedEth;
150   uint256 public cut;
151   uint256 public tradingFee;
152   bool private secureFees;
153 
154   struct Buy {
155     uint256 cardId;
156     uint256 count;
157     uint256 ethAmount;
158     bool open;
159   }
160 
161   mapping(address => Buy[]) private buyers;
162 
163   struct Sell {
164     uint256 cardId;
165     uint256 count;
166     uint256 ethAmount;
167     bool open;
168   }
169 
170   mapping(address => Sell[]) private sellers;
171 
172   struct Trade {
173     uint256[] offeredCardIds;
174     uint256[] offeredCardCounts;
175     uint256[] requestedCardIds;
176     uint256[] requestedCardCounts;
177     bool open;
178   }
179 
180   mapping(address => Trade[]) private traders;
181 
182   event NewBuy(address indexed buyer, uint256 indexed id, uint256 cardId, uint256 count, uint256 ethAmount);
183   event CardSold(address indexed buyer, uint256 indexed id, address indexed seller, uint256 cardId, uint256 count, uint256 ethAmount);
184   event CancelBuy(address indexed buyer, uint256 indexed id, uint256 cardId, uint256 count, uint256 ethAmount);
185 
186   event NewSell(address indexed seller, uint256 indexed id, uint256 cardId, uint256 count, uint256 ethAmount);
187   event CardBought(address indexed seller, uint256 indexed id, address indexed buyer, uint256 cardId, uint256 count, uint256 ethAmount);
188   event CancelSell(address indexed seller, uint256 indexed id, uint256 cardId, uint256 count, uint256 ethAmount);
189 
190   event NewTrade(address indexed seller, uint256 indexed id, uint256[] offeredCardIds, uint256[] offeredCardCounts, uint256[] requestedCardIds, uint256[] requestedCardCounts);
191   event CardsTraded(address indexed seller, uint256 indexed id, address indexed buyer, uint256[] offeredCardIds, uint256[] offeredCardCounts, uint256[] requestedCardIds, uint256[] requestedCardCounts);
192   event CancelTrade(address indexed seller, uint256 indexed id, uint256[] offeredCardIds, uint256[] offeredCardCounts, uint256[] requestedCardIds, uint256[] requestedCardCounts);
193 
194   constructor(address _copaCoreAddress, uint256 _cut, uint256 _tradingFee, bool _secureFees) public {
195     copaCore = CopaCore(_copaCoreAddress);
196     cut = _cut;
197     tradingFee = _tradingFee;
198     secureFees = _secureFees;
199 
200     lockedEth = 0;
201   }
202 
203   function getCopaCoreAddress() view external onlyOwner returns (address) {
204     return address(copaCore);
205   }
206 
207   function setCopaCoreAddress(address _copaCoreAddress) external onlyOwner {
208     copaCore = CopaCore(_copaCoreAddress);
209   }
210 
211   function setCut(uint256 _cut) external onlyOwner {
212     require(_cut > 0);
213     require(_cut < 10000);
214 
215     cut = _cut;
216   }
217 
218   function setTradingFee(uint256 _tradingFee) external onlyOwner {
219     require(_tradingFee > 0);
220 
221     tradingFee = _tradingFee;
222   }
223 
224   function getSecureFees() view external onlyOwner returns (bool) {
225     return secureFees;
226   }
227 
228   function setSecureFees(bool _secureFees) external onlyOwner {
229     secureFees = _secureFees;
230   }
231 
232   function getLockedEth() view external onlyOwner returns (uint256) {
233     return lockedEth;
234   }
235 
236   function getEthBalance() view external returns (uint256) {
237     return address(this).balance;
238   }
239 
240   function withdrawEthBalanceSave() external onlyOwner {
241     uint256 _ethBalance = address(this).balance;
242     owner.transfer(_ethBalance - lockedEth);
243   }
244 
245   function withdrawEthBalance() external onlyOwner {
246     uint256 _ethBalance = address(this).balance;
247     owner.transfer(_ethBalance);
248   }
249 
250   function getBuy(uint256 _id, address _address) view external returns (uint256, uint256, uint256, bool){
251     return (buyers[_address][_id].cardId, buyers[_address][_id].count, buyers[_address][_id].ethAmount, buyers[_address][_id].open);
252   }
253 
254   function getSell(uint256 _id, address _address) view external returns (uint256, uint256, uint256, bool){
255     return (sellers[_address][_id].cardId, sellers[_address][_id].count, sellers[_address][_id].ethAmount, sellers[_address][_id].open);
256   }
257 
258   function getTrade(uint256 _id, address _address) view external returns (uint256[], uint256[], uint256[], uint256[], bool){
259     return (traders[_address][_id].offeredCardIds, traders[_address][_id].offeredCardCounts, traders[_address][_id].requestedCardIds, traders[_address][_id].requestedCardCounts, traders[_address][_id].open);
260   }
261 
262   function addToBuyList(uint256 _cardId, uint256 _count) external payable whenNotPaused returns (bool) {
263     address _buyer = msg.sender;
264     uint256 _ethAmount = msg.value;
265 
266     require(_ethAmount > 0);
267     require(_count > 0);
268 
269     uint256 _id = buyers[_buyer].length;
270     buyers[_buyer].push(Buy(_cardId, _count, _ethAmount, true));
271 
272     lockedEth += _ethAmount;
273 
274     emit NewBuy(_buyer, _id, _cardId, _count, _ethAmount);
275 
276     return true;
277   }
278 
279   function sellCard(address _buyer, uint256 _id, uint256 _cardId, uint256 _count, uint256 _ethAmount) external whenNotPaused returns (bool) {
280     address _seller = msg.sender;
281 
282     uint256 _cut = 10000 - cut;
283     uint256 _ethAmountAfterCut = (_ethAmount * _cut) / 10000;
284     uint256 _fee = _ethAmount - _ethAmountAfterCut;
285 
286     require(buyers[_buyer][_id].open == true);
287     require(buyers[_buyer][_id].cardId == _cardId);
288     require(buyers[_buyer][_id].count == _count);
289     require(buyers[_buyer][_id].ethAmount == _ethAmount);
290 
291     buyers[_buyer][_id].open = false;
292     lockedEth -= _ethAmount;
293 
294     copaCore.transferFrom(_seller, _buyer, _cardId, _count);
295     _seller.transfer(_ethAmountAfterCut);
296 
297     if (secureFees) {
298       owner.transfer(_fee);
299     }
300 
301     emit CardSold(_buyer, _id, _seller, _cardId, _count, _ethAmount);
302 
303     return true;
304   }
305 
306   function cancelBuy(uint256 _id, uint256 _cardId, uint256 _count, uint256 _ethAmount) external whenNotPaused returns (bool) {
307     address _buyer = msg.sender;
308 
309     require(buyers[_buyer][_id].open == true);
310     require(buyers[_buyer][_id].cardId == _cardId);
311     require(buyers[_buyer][_id].count == _count);
312     require(buyers[_buyer][_id].ethAmount == _ethAmount);
313 
314     lockedEth -= _ethAmount;
315     buyers[_buyer][_id].open = false;
316 
317     _buyer.transfer(_ethAmount);
318 
319     emit CancelBuy(_buyer, _id, _cardId, _count, _ethAmount);
320 
321     return true;
322   }
323 
324   function addToSellList(uint256 _cardId, uint256 _count, uint256 _ethAmount) external whenNotPaused returns (bool) {
325     address _seller = msg.sender;
326 
327     require(_ethAmount > 0);
328     require(_count > 0);
329 
330     uint256 _id = sellers[_seller].length;
331     sellers[_seller].push(Sell(_cardId, _count, _ethAmount, true));
332 
333     copaCore.transferFrom(_seller, address(this), _cardId, _count);
334 
335     emit NewSell(_seller, _id, _cardId, _count, _ethAmount);
336 
337     return true;
338   }
339 
340   function buyCard(address _seller, uint256 _id, uint256 _cardId, uint256 _count) external payable whenNotPaused returns (bool) {
341     address _buyer = msg.sender;
342     uint256 _ethAmount = msg.value;
343 
344     uint256 _cut = 10000 - cut;
345     uint256 _ethAmountAfterCut = (_ethAmount * _cut) / 10000;
346     uint256 _fee = _ethAmount - _ethAmountAfterCut;
347 
348     require(sellers[_seller][_id].open == true);
349     require(sellers[_seller][_id].cardId == _cardId);
350     require(sellers[_seller][_id].count == _count);
351     require(sellers[_seller][_id].ethAmount <= _ethAmount);
352 
353     sellers[_seller][_id].open = false;
354 
355     copaCore.transfer(_buyer, _cardId, _count);
356     _seller.transfer(_ethAmountAfterCut);
357 
358     if (secureFees) {
359       owner.transfer(_fee);
360     }
361 
362     emit CardBought(_seller, _id, _buyer, _cardId, _count, _ethAmount);
363 
364     return true;
365   }
366 
367   function cancelSell(uint256 _id, uint256 _cardId, uint256 _count, uint256 _ethAmount) external whenNotPaused returns (bool) {
368     address _seller = msg.sender;
369 
370     require(sellers[_seller][_id].open == true);
371     require(sellers[_seller][_id].cardId == _cardId);
372     require(sellers[_seller][_id].count == _count);
373     require(sellers[_seller][_id].ethAmount == _ethAmount);
374 
375     sellers[_seller][_id].open = false;
376 
377     copaCore.transfer(_seller, _cardId, _count);
378 
379     emit CancelSell(_seller, _id, _cardId, _count, _ethAmount);
380 
381     return true;
382   }
383 
384   function addToTradeList(uint256[] _offeredCardIds, uint256[] _offeredCardCounts, uint256[] _requestedCardIds, uint256[] _requestedCardCounts) external whenNotPaused returns (bool) {
385     address _seller = msg.sender;
386 
387     require(_offeredCardIds.length > 0);
388     require(_offeredCardCounts.length > 0);
389     require(_requestedCardIds.length > 0);
390     require(_requestedCardCounts.length > 0);
391 
392     uint256 _id = traders[_seller].length;
393     traders[_seller].push(Trade(_offeredCardIds, _offeredCardCounts, _requestedCardIds, _requestedCardCounts, true));
394 
395     for (uint256 i = 0; i < _offeredCardIds.length; i++) {
396       copaCore.transferFrom(_seller, address(this), _offeredCardIds[i], _offeredCardCounts[i]);
397     }
398 
399     emit NewTrade(_seller, _id, _offeredCardIds, _offeredCardCounts, _requestedCardIds, _requestedCardCounts);
400 
401     return true;
402   }
403 
404   function tradeCards(address _seller, uint256 _id) external payable whenNotPaused returns (bool) {
405     address _buyer = msg.sender;
406     uint256 _ethAmount = msg.value;
407     uint256[] memory _offeredCardIds = traders[_seller][_id].offeredCardIds;
408     uint256[] memory _offeredCardCounts = traders[_seller][_id].offeredCardCounts;
409     uint256[] memory _requestedCardIds = traders[_seller][_id].requestedCardIds;
410     uint256[] memory _requestedCardCounts = traders[_seller][_id].requestedCardCounts;
411 
412     require(traders[_seller][_id].open == true);
413     require(_ethAmount >= tradingFee);
414 
415     traders[_seller][_id].open = false;
416 
417     for (uint256 i = 0; i < _offeredCardIds.length; i++) {
418       copaCore.transfer(_buyer, _offeredCardIds[i], _offeredCardCounts[i]);
419     }
420     for (uint256 j = 0; j < _requestedCardIds.length; j++) {
421       copaCore.transferFrom(_buyer, _seller, _requestedCardIds[j], _requestedCardCounts[j]);
422     }
423 
424     if (secureFees) {
425       owner.transfer(_ethAmount);
426     }
427 
428     emit CardsTraded(_seller, _id, _buyer, _offeredCardIds, _offeredCardCounts, _requestedCardIds, _requestedCardCounts);
429 
430     return true;
431   }
432 
433   function cancelTrade(uint256 _id) external whenNotPaused returns (bool) {
434     address _seller = msg.sender;
435     uint256[] memory _offeredCardIds = traders[_seller][_id].offeredCardIds;
436     uint256[] memory _offeredCardCounts = traders[_seller][_id].offeredCardCounts;
437     uint256[] memory _requestedCardIds = traders[_seller][_id].requestedCardIds;
438     uint256[] memory _requestedCardCounts = traders[_seller][_id].requestedCardCounts;
439 
440     require(traders[_seller][_id].open == true);
441 
442     traders[_seller][_id].open = false;
443 
444     for (uint256 i = 0; i < _offeredCardIds.length; i++) {
445       copaCore.transfer(_seller, _offeredCardIds[i], _offeredCardCounts[i]);
446     }
447 
448     emit CancelTrade(_seller, _id, _offeredCardIds, _offeredCardCounts, _requestedCardIds, _requestedCardCounts);
449 
450     return true;
451   }
452 }
453 
454 contract CopaCore is Ownable, Pausable {
455   using SafeMath for uint256;
456 
457   CopaMarket private copaMarket;
458 
459   uint256 public packSize;
460   uint256 public packPrice;
461   uint256 public totalCardCount;
462 
463   mapping(address => uint256[1200]) public balances;
464 
465   struct PackBuy {
466     uint256 packSize;
467     uint256 packPrice;
468     uint256[] cardIds;
469   }
470 
471   mapping(address => PackBuy[]) private packBuys;
472 
473   event Transfer(address indexed from, address indexed to, uint256 indexed cardId, uint256 count);
474   event TransferManual(address indexed from, address indexed to, uint256[] cardIds, uint256[] counts);
475   event BuyPack(uint256 indexed id, address indexed buyer, uint256 packSize, uint256 packPrice, uint256[] cardIds);
476   event BuyPacks(uint256 indexed id, address indexed buyer, uint256 packSize, uint256 packPrice, uint256 count);
477 
478   constructor(uint256 _packSize, uint256 _packPrice, uint256 _totalCardCount) public {
479     packSize = _packSize;
480     packPrice = _packPrice;
481     totalCardCount = _totalCardCount;
482   }
483 
484   function getCopaMarketAddress() view external onlyOwner returns (address) {
485     return address(copaMarket);
486   }
487 
488   function setCopaMarketAddress(address _copaMarketAddress) external onlyOwner {
489     copaMarket = CopaMarket(_copaMarketAddress);
490   }
491   modifier onlyCopaMarket() {
492     require(msg.sender == address(copaMarket));
493     _;
494   }
495 
496   function setPackSize(uint256 _packSize) external onlyOwner {
497     require(_packSize > 0);
498 
499     packSize = _packSize;
500   }
501 
502   function setPrice(uint256 _packPrice) external onlyOwner {
503     require(_packPrice > 0);
504 
505     packPrice = _packPrice;
506   }
507 
508   function setTotalCardCount(uint256 _totalCardCount) external onlyOwner {
509     require(_totalCardCount > 0);
510 
511     totalCardCount = _totalCardCount;
512   }
513 
514   function getEthBalance() view external returns (uint256) {
515     return address(this).balance;
516   }
517 
518   function withdrawEthBalance() external onlyOwner {
519     uint256 _ethBalance = address(this).balance;
520     owner.transfer(_ethBalance);
521   }
522 
523   function balanceOf(address _owner, uint256 _cardId) view external returns (uint256) {
524     return balances[_owner][_cardId];
525   }
526 
527   function balancesOf(address _owner) view external returns (uint256[1200]) {
528     return balances[_owner];
529   }
530 
531   function getPackBuy(address _address, uint256 _id) view external returns (uint256, uint256, uint256[]){
532     return (packBuys[_address][_id].packSize, packBuys[_address][_id].packPrice, packBuys[_address][_id].cardIds);
533   }
534 
535   function transfer(address _to, uint256 _cardId, uint256 _count) external whenNotPaused returns (bool) {
536     address _from = msg.sender;
537 
538     require(_to != address(0));
539     require(_count > 0);
540     require(_count <= balances[_from][_cardId]);
541 
542     balances[_from][_cardId] = balances[_from][_cardId].sub(_count);
543     balances[_to][_cardId] = balances[_to][_cardId].add(_count);
544 
545     emit Transfer(_from, _to, _cardId, _count);
546 
547     return true;
548   }
549 
550   function transferMultiple(address _to, uint256[] _cardIds, uint256[] _counts) external whenNotPaused returns (bool) {
551     address _from = msg.sender;
552 
553     require(_to != address(0));
554 
555     for (uint256 i = 0; i < _cardIds.length; i++) {
556       uint256 _cardId = _cardIds[i];
557       uint256 _count = _counts[i];
558 
559       require(_count > 0);
560       require(_count <= balances[_from][_cardId]);
561 
562       balances[_from][_cardId] = balances[_from][_cardId].sub(_count);
563       balances[_to][_cardId] = balances[_to][_cardId].add(_count);
564 
565       emit Transfer(_from, _to, _cardId, _count);
566     }
567 
568     emit TransferManual(_from, _to, _cardIds, _counts);
569 
570     return true;
571   }
572 
573   function transferFrom(address _from, address _to, uint256 _cardId, uint256 _count) external onlyCopaMarket returns (bool) {
574     require(_to != address(0));
575     require(_count > 0);
576     require(_count <= balances[_from][_cardId]);
577 
578     balances[_from][_cardId] = balances[_from][_cardId].sub(_count);
579     balances[_to][_cardId] = balances[_to][_cardId].add(_count);
580 
581     emit Transfer(_from, _to, _cardId, _count);
582 
583     return true;
584   }
585 
586   function buyPack(uint256 _count) external payable whenNotPaused returns (bool) {
587     address _buyer = msg.sender;
588     uint256 _ethAmount = msg.value;
589     uint256 _totalPrice = packPrice * _count;
590 
591     require(_count > 0);
592     require(_ethAmount > 0);
593     require(_ethAmount >= _totalPrice);
594 
595     for (uint256 i = 0; i < _count; i++) {
596       uint256[] memory _cardsList = new uint256[](packSize);
597 
598       for (uint256 j = 0; j < packSize; j++) {
599         uint256 _cardId = dice(totalCardCount);
600 
601         balances[_buyer][_cardId] = balances[_buyer][_cardId].add(1);
602 
603         _cardsList[j] = _cardId;
604 
605         emit Transfer(0x0, _buyer, _cardId, 1);
606       }
607 
608       uint256 _id = packBuys[_buyer].length;
609       packBuys[_buyer].push(PackBuy(packSize, packPrice, _cardsList));
610 
611       emit BuyPack(_id, _buyer, packSize, packPrice, _cardsList);
612     }
613 
614     emit BuyPacks(_id, _buyer, packSize, packPrice, _count);
615 
616     return true;
617   }
618 
619   function getPack(uint256 _count) external onlyOwner whenNotPaused returns (bool) {
620     require(_count > 0);
621 
622     for (uint256 i = 0; i < _count; i++) {
623       uint256[] memory _cardsList = new uint256[](packSize);
624 
625       for (uint256 j = 0; j < packSize; j++) {
626         uint256 _cardId = dice(totalCardCount);
627 
628         balances[owner][_cardId] = balances[owner][_cardId].add(1);
629 
630         _cardsList[j] = _cardId;
631 
632         emit Transfer(0x0, owner, _cardId, 1);
633       }
634 
635       uint256 _id = packBuys[owner].length;
636       packBuys[owner].push(PackBuy(packSize, 0, _cardsList));
637 
638       emit BuyPack(_id, owner, packSize, 0, _cardsList);
639     }
640 
641     emit BuyPacks(_id, owner, packSize, 0, _count);
642 
643     return true;
644   }
645 
646   uint256 seed = 0;
647 
648   function maxDice() private returns (uint256 diceNumber) {
649     seed = uint256(keccak256(keccak256(blockhash(block.number - 1), seed), now));
650     return seed;
651   }
652 
653   function dice(uint256 upper) private returns (uint256 diceNumber) {
654     return maxDice() % upper;
655   }
656 }