1 pragma solidity ^0.4.17;
2 
3 
4 contract ItemSelling {
5     using SafeMath for uint256;
6     using ArrayUtils for uint256[];
7 
8     /* Events */
9     event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
10     event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
11     event BuyBack (uint256 indexed _itemId, address indexed _owner, uint256 _price);
12     event Transfer(address indexed _from, address indexed _to, uint256 _itemId);
13     event Approval(address indexed _owner, address indexed _approved, uint256 _itemId);
14     event Dividends(address indexed _owner, uint _dividends);
15 
16     /* Items */
17     struct Item {
18         uint256 id;
19         address owner;
20         uint256 startingPrice;
21         uint256 prevPrice;
22         uint256 price;
23         uint256 transactions;
24     }
25 
26     /* Players */
27     struct Player {
28         address id;
29         uint256 transactions;
30         uint256 [] ownedItems;
31         uint256 lastPayedDividends;
32         mapping (uint => TxInfo) txHistory;
33         uint historyIdx;
34     }
35 
36     struct TxInfo {
37         address owner;
38         uint256 itemId; // if type == 2 than itemId contains number of items for dividens
39         uint256 price;  // if type == 2 than field price holds dividens amount for player
40         uint txType;  // 0 - sold, 1 - bougth, 2 -dividens
41         uint timestamp;
42     }
43 
44     mapping(uint => TxInfo) public txBuffer;
45     uint private txBufferMaxSize;
46     uint private txIdx = 0;
47     uint private playerHistoryMaxSize;
48 
49     mapping (uint256 => Item) private items;
50     uint256 [] private itemList;
51 
52     mapping(address => Player) private players;
53     address[] private playerList;
54 
55 
56     /* Administration utility */
57     address private owner;
58     mapping (address => bool) private admins;
59     bool private erc721Enabled = false;
60     mapping (uint256 => address) private approvedOfItem;
61 
62     uint256 private DIVIDEND_TRANSACTION_NUMBER = 300;
63     uint256 private dividendTransactionCount = 0;
64     uint256 private dividendsAmount = 0;
65     uint256 private lastDividendsAmount = 0;
66 
67     /* Next price calculation table */
68     uint256 private increaseLimit1 = 0.05 ether;
69     uint256 private increaseLimit2 = 0.5 ether;
70     uint256 private increaseLimit3 = 2.0 ether;
71     uint256 private increaseLimit4 = 5.0 ether;
72 
73     uint256 private fee = 6;
74     uint256 private fee100 = 106;
75 
76     /* Contract body */
77     function ItemSelling() public {
78         owner = msg.sender;
79         admins[owner] = true;
80         txBufferMaxSize = 15;
81         txIdx = 0;
82         playerHistoryMaxSize = 15;
83     }
84 
85     /* Modifiers */
86     modifier onlyOwner() {
87         require(owner == msg.sender);
88         _;
89     }
90 
91     modifier onlyAdmins() {
92         require(admins[msg.sender]);
93         _;
94     }
95 
96     modifier onlyERC721() {
97         require(erc721Enabled);
98         _;
99     }
100 
101     /* Owner */
102     function setOwner (address _owner) onlyOwner() public {
103         owner = _owner;
104     }
105 
106     /* Admins functions */
107     function addAdmin (address _admin) onlyOwner() public {
108         admins[_admin] = true;
109     }
110 
111     function removeAdmin (address _admin) onlyOwner() public {
112         delete admins[_admin];
113     }
114 
115     function isAdmin (address _admin) public view returns (bool _isAdmin) {
116         return admins[_admin];
117     }
118 
119     // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
120     function enableERC721 () onlyOwner() public {
121         erc721Enabled = true;
122     }
123 
124     function getBalance() onlyOwner view public returns (uint256 _balance) {
125         return address(this).balance;
126     }
127 
128     /* Items */
129     function addItem(uint256 _itemId, uint256 _price, address _owner) onlyAdmins public {
130         require(_price > 0);
131         require(items[_itemId].id == 0);
132 
133         Item storage item = items[_itemId];
134         item.id = _itemId;
135         item.owner = _owner;
136         item.startingPrice = _price;
137         item.prevPrice = _price;
138         item.price = _price;
139         item.transactions = 0;
140 
141         itemList.push(_itemId) - 1;
142     }
143 
144     function addItems (uint256[] _itemIds, uint256[] _prices, address _owner) onlyAdmins() public {
145         require(_itemIds.length == _prices.length);
146         for (uint256 i = 0; i < _itemIds.length; i++) {
147             addItem(_itemIds[i], _prices[i], _owner);
148         }
149     }
150 
151     function getItemIds() view public returns (uint256[]) {
152         return itemList;
153     }
154 
155     function getItemIdsPagable (uint256 _from, uint256 _pageSize) public view returns (uint256[] _items) {
156         uint256[] memory page = new uint256[](_pageSize);
157 
158         for (uint256 i = 0; i < _pageSize; i++) {
159             page[i] = itemList[_from + i];
160         }
161         return page;
162     }
163 
164     function itemExists(uint256 _itemId) view public returns (bool _exists) {
165         return items[_itemId].price > 0;
166     }
167 
168     function getItem(uint256 _itemId) view public returns (uint256, address, uint256, uint256, uint256, uint256, uint256, uint256) {
169         Item storage item = items[_itemId];
170         return (item.id, item.owner, item.startingPrice, item.price, calculateNextPrice(item.price), buybackPriceOf(_itemId), item.transactions, item.prevPrice);
171     }
172 
173     function totalItems() public view returns (uint256 _itemsNumber) {
174         return itemList.length;
175     }
176 
177     function getItemsByOwner (address _owner) public view returns (uint256[] _itemsIds) {
178         return players[_owner].ownedItems;
179     }
180 
181     function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
182         if (_price < increaseLimit1) {
183             return _price.mul(200).div(100).mul(fee100).div(100);
184         } else if (_price < increaseLimit2) {
185             return _price.mul(140).div(100).mul(fee100).div(100);
186         } else if (_price < increaseLimit3) {
187             return _price.mul(125).div(100).mul(fee100).div(100);
188         } else if (_price < increaseLimit4) {
189             return _price.mul(120).div(100).mul(fee100).div(100);
190         } else {
191             return _price.mul(119).div(100).mul(fee100).div(100);
192         }
193     }
194 
195     function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
196         if (_price < increaseLimit1) {
197             return _price.mul(fee).div(fee100); // 6%
198         } else if (_price < increaseLimit2) {
199             return _price.mul(fee).div(fee100); // 6%
200         } else if (_price < increaseLimit3) {
201             return _price.mul(fee).div(fee100); // 6%
202         } else if (_price < increaseLimit4) {
203             return _price.mul(fee).div(fee100); // 6%
204         } else {
205             return _price.mul(fee).div(fee100); // 6%
206         }
207     }
208 
209     function buybackPriceOf(uint256 _itemId) public view returns (uint256 _buybackPrice){
210         uint256 price = items[_itemId].price;
211         uint256 startPrice = items[_itemId].startingPrice;
212 
213         uint256 bp = price.div(10); // 10% = price * 10 / 100 or price / 10
214         uint256 sp = startPrice.mul(100).div(fee100);
215         return bp < sp ? sp : bp;
216     }
217 
218     /* Players */
219     function createPlayerIfNeeded(address _playerId) internal {
220 
221         if (players[_playerId].id == address(0)) {
222             Player storage player = players[_playerId];
223             player.id = _playerId;
224             player.transactions = 0;
225             player.ownedItems = new uint256[](0);
226             player.historyIdx = 0;
227             player.lastPayedDividends = 0;
228 
229             playerList.push(_playerId) -1;
230         }
231     }
232 
233     function getPlayer(address _playerId) view public returns (address, uint256, uint256, uint256, uint256) {
234         return (players[_playerId].id, players[_playerId].ownedItems.length, calculatePlayerValue(_playerId), players[_playerId].transactions, players[_playerId].lastPayedDividends);
235     }
236 
237     function getPlayerIds() view public returns (address[]) {
238         return playerList;
239     }
240 
241     function calculatePlayerValue(address _playerId) view public returns(uint256 _value) {
242         uint256 value = 0;
243         for(uint256 i = 0; i < players[_playerId].ownedItems.length; i++){
244             value += items[players[_playerId].ownedItems[i]].price;
245         }
246         return value;
247     }
248 
249     function addPlayerTxHistory(address _playerId, uint256 _itemId, uint256 _price, uint _txType, uint _timestamp) internal {
250         if (!isAdmin(_playerId)){
251             Player storage player = players[_playerId];
252 
253             player.txHistory[player.historyIdx].owner = _playerId;
254             player.txHistory[player.historyIdx].itemId = _itemId;
255             player.txHistory[player.historyIdx].price = _price;
256             player.txHistory[player.historyIdx].txType = _txType;
257             player.txHistory[player.historyIdx].timestamp = _timestamp;
258             player.historyIdx = player.historyIdx < playerHistoryMaxSize - 1 ? player.historyIdx + 1 : 0;
259         }
260     }
261 
262     // history
263     function playerTransactionList(address _playerId)
264         view
265         public
266         returns (uint256[] _itemIds, uint256[] _prices, uint[] _types, uint[] _ts )
267     {
268       //  _owners  = new address[](playerHistoryMaxSize);
269         _itemIds = new uint256[](playerHistoryMaxSize);
270         _prices  = new uint256[](playerHistoryMaxSize);
271         _types   = new uint256[](playerHistoryMaxSize);
272         _ts      = new uint[](playerHistoryMaxSize);
273 
274         uint offset = playerHistoryMaxSize - 1;
275         if (players[_playerId].historyIdx > 0) {offset = players[_playerId].historyIdx - 1;}
276         for (uint i = 0; i < playerHistoryMaxSize; i++){
277         //    _owners[i]  = txBuffer[offset].owner;
278             _itemIds[i] = players[_playerId].txHistory[offset].itemId;
279             _prices[i]  = players[_playerId].txHistory[offset].price;
280             _types[i]   = players[_playerId].txHistory[offset].txType;
281             _ts[i]      = players[_playerId].txHistory[offset].timestamp;
282 
283             offset = offset > 0 ?  offset - 1 : playerHistoryMaxSize - 1;
284         }
285     }
286 
287     /* Buy */
288     function buy (uint256 _itemId) payable public {
289         Item storage item = items[_itemId];
290 
291         require(item.price > 0);
292         require(item.owner != address(0));
293         require(msg.value >= item.price);
294         require(item.owner != msg.sender);
295         require(!isContract(msg.sender));
296         require(msg.sender != address(0));
297 
298         address oldOwner = item.owner;
299         address newOwner = msg.sender;
300         uint256 price = item.price;
301         uint256 excess = msg.value.sub(price);
302 
303         createPlayerIfNeeded(newOwner);
304 
305         _transfer(oldOwner, newOwner, _itemId);
306         addTxInBuffer(newOwner, _itemId, price, 1, now);
307         addPlayerTxHistory(newOwner, _itemId, price, 1, now);
308         addPlayerTxHistory(oldOwner, _itemId, price, 0, now);
309         item.prevPrice = price;
310         item.price = calculateNextPrice(price);
311         item.transactions += 1;
312 
313         players[newOwner].transactions += 1;
314 
315         emit Bought(_itemId, newOwner, price);
316         emit Sold(_itemId, oldOwner, price);
317 
318         // Devevloper's cut which is left in contract and accesed by
319         // `withdrawAll` and `withdrawAmountTo` methods.
320         uint256 devCut = calculateDevCut(price);
321 
322         // Transfer payment to old owner minus the developer's cut.
323         if (!isAdmin(oldOwner)){
324             oldOwner.transfer(price.sub(devCut));
325         }
326 
327         if (excess > 0) {
328             newOwner.transfer(excess);
329         }
330 
331         proceedDividends(devCut);
332         handleDividends();
333     }
334 
335     function buyback(uint256 _itemId) public {
336         Item storage item = items[_itemId];
337 
338         require(item.price > 0);
339         require(item.owner != address(0));
340         require(item.owner == msg.sender);
341         require(!isContract(msg.sender));
342         require(msg.sender != address(0));
343 
344         uint256 bprice = buybackPriceOf(_itemId);
345 
346         require(address(this).balance >= bprice);
347 
348         address oldOwner = msg.sender;
349         address newOwner = owner;
350 
351         _transfer(oldOwner, newOwner, _itemId);
352         addTxInBuffer(oldOwner, _itemId, bprice, 0, now);
353         addPlayerTxHistory(oldOwner, _itemId, bprice, 0, now);
354 
355         item.price = calculateNextPrice(bprice);
356         oldOwner.transfer(bprice);
357         emit Sold(_itemId, oldOwner, bprice);
358         emit BuyBack(_itemId, oldOwner, bprice);
359     }
360 
361     function _transfer(address _from, address _to, uint256 _itemId) internal {
362 
363         require(itemExists(_itemId));
364         require(items[_itemId].owner == _from);
365         require(_to != address(0));
366         require(_to != address(this));
367 
368         items[_itemId].owner = _to;
369      //   approvedOfItem[_itemId] = 0;
370 
371         if (!isAdmin(_to)) {
372             players[_to].ownedItems.push(_itemId) -1;
373         }
374 
375         if (!isAdmin(_from)) {
376             uint256 idx = players[_from].ownedItems.indexOf(_itemId);
377             players[_from].ownedItems.remove(idx);
378         }
379 
380         emit Transfer(_from, _to, _itemId);
381     }
382 
383     /* Dividens */
384     function getLastDividendsAmount() view public returns (uint256 _dividends) {
385       return lastDividendsAmount;
386     }
387 
388     function setDividendTransactionNumber(uint256 _txNumber) onlyAdmins public {
389         DIVIDEND_TRANSACTION_NUMBER = _txNumber;
390     }
391 
392     function getDividendTransactionLeft () view public returns (uint256 _txNumber) {
393       return DIVIDEND_TRANSACTION_NUMBER - dividendTransactionCount;
394     }
395 
396     function getTotalVolume() view public returns (uint256 _volume) {
397         uint256 sum = 0;
398         for (uint256 i = 0; i < itemList.length; i++){
399             if (!isAdmin(items[itemList[i]].owner)) {
400                 sum += items[itemList[i]].price;
401             }
402         }
403         return sum;
404     }
405 
406     function proceedDividends(uint256 _devCut) internal {
407         dividendTransactionCount += 1;
408         dividendsAmount += _devCut.div(5); // *0.2
409     }
410 
411     function handleDividends() internal {
412         if (dividendTransactionCount < DIVIDEND_TRANSACTION_NUMBER ) return;
413 
414         lastDividendsAmount = dividendsAmount;
415         dividendTransactionCount = 0;
416         dividendsAmount = 0;
417 
418         uint256 totalCurrentVolume = getTotalVolume();
419         uint256 userVolume = 0;
420         uint256 userDividens = 0;
421 
422         for (uint256 i = 0; i < playerList.length; i++) {
423             userVolume = calculatePlayerValue(playerList[i]);
424             players[playerList[i]].lastPayedDividends = 0;
425             if (userVolume > 0) {
426                 userDividens = userVolume.mul(lastDividendsAmount).div(totalCurrentVolume);
427                 players[playerList[i]].lastPayedDividends = userDividens;
428 
429                 addPlayerTxHistory(playerList[i], players[playerList[i]].ownedItems.length, userDividens, 2, now);
430                 emit Dividends(playerList[i], userDividens);
431 
432                 playerList[i].transfer(userDividens);
433             }
434             userVolume = 0;
435             userDividens = 0;
436         }
437     }
438 
439     /* Withdraw */
440     function hardWithdrawAll() onlyOwner public {
441         owner.transfer(address(this).balance);
442     }
443 
444     function withdrawAmount(uint256 _amount) onlyOwner public {
445         require(_amount <= address(this).balance);
446         owner.transfer(_amount);
447     }
448 
449     function calculateAllBuyBackSum() view public returns (uint256 _buyBackSum) {
450         uint256 sum = 0;
451         for (uint256 i = 0; i < itemList.length; i++) {
452             if (!isAdmin(items[itemList[i]].owner)) {
453                 sum += buybackPriceOf(itemList[i]);
454             }
455         }
456         return sum;
457     }
458 
459     function softWithdraw() onlyOwner public {
460         uint256 buyBackSum = calculateAllBuyBackSum();
461         uint256 requiredFunds = dividendsAmount + buyBackSum;
462 
463         uint256 withdrawal = address(this).balance - requiredFunds;
464         require(withdrawal > 0);
465 
466         owner.transfer(withdrawal);
467     }
468 
469     /* ERC721 */
470     function approvedFor(uint256 _itemId) public view returns (address _approved) {
471         return approvedOfItem[_itemId];
472     }
473 
474     function approve(address _to, uint256 _itemId) onlyERC721() public {
475         require(msg.sender != _to);
476         require(itemExists(_itemId));
477         require(items[_itemId].owner == msg.sender);
478 
479         if (_to == 0) {
480             if (approvedOfItem[_itemId] != 0) {
481                 delete approvedOfItem[_itemId];
482                 emit Approval(msg.sender, 0, _itemId);
483             }
484         } else {
485             approvedOfItem[_itemId] = _to;
486             emit Approval(msg.sender, _to, _itemId);
487         }
488     }
489 
490     /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
491     function transfer(address _to, uint256 _itemId) onlyERC721() public {
492         require(msg.sender == items[_itemId].owner);
493         createPlayerIfNeeded(_to);
494         _transfer(msg.sender, _to, _itemId);
495     }
496 
497     function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
498         require(approvedFor(_itemId) == msg.sender);
499         createPlayerIfNeeded(_to);
500         _transfer(_from, _to, _itemId);
501     }
502 
503     /* transactions */
504 
505     function addTxInBuffer(address _owner, uint256 _itemId, uint256 _price, uint _txType, uint _timestamp) internal {
506         txBuffer[txIdx].owner = _owner;
507         txBuffer[txIdx].itemId = _itemId;
508         txBuffer[txIdx].price = _price;
509         txBuffer[txIdx].txType = _txType;
510         txBuffer[txIdx].timestamp = _timestamp;
511         txIdx = txIdx  < txBufferMaxSize - 1 ? txIdx + 1 : 0;
512     }
513 
514     function transactionList()
515         view
516         public
517         returns (address[] _owners, uint256[] _itemIds, uint256[] _prices, uint[] _types, uint[] _ts )
518     {
519         _owners  = new address[](txBufferMaxSize);
520         _itemIds = new uint256[](txBufferMaxSize);
521         _prices  = new uint256[](txBufferMaxSize);
522         _types   = new uint256[](txBufferMaxSize);
523         _ts      = new uint[](txBufferMaxSize);
524 
525         uint offset = txBufferMaxSize - 1;
526         if (txIdx > 0) { offset = txIdx - 1;}
527         for (uint i = 0; i < txBufferMaxSize; i++){
528             _owners[i]  = txBuffer[offset].owner;
529             _itemIds[i] = txBuffer[offset].itemId;
530             _prices[i]  = txBuffer[offset].price;
531             _types[i]   = txBuffer[offset].txType;
532             _ts[i]      = txBuffer[offset].timestamp;
533 
534             offset = offset > 0 ?  offset - 1 : txBufferMaxSize - 1;
535         }
536     }
537 
538 
539     /* Util */
540     function isContract(address addr) internal view returns (bool) {
541         uint size;
542         assembly { size := extcodesize(addr) } // solium-disable-line
543         return size > 0;
544     }
545 
546 }
547 
548 library SafeMath {
549 
550   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
551     if (a == 0) {
552       return 0;
553     }
554     uint256 c = a * b;
555     assert(c / a == b);
556     return c;
557   }
558 
559   function div(uint256 a, uint256 b) internal pure returns (uint256) {
560     uint256 c = a / b;
561     return c;
562   }
563 
564   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
565     assert(b <= a);
566     return a - b;
567   }
568 
569   function add(uint256 a, uint256 b) internal pure returns (uint256) {
570     uint256 c = a + b;
571     assert(c >= a);
572     return c;
573   }
574 }
575 
576 library ArrayUtils {
577 
578     function remove(uint256[] storage self, uint256 _removeIdx) internal {
579         if (_removeIdx < 0 || _removeIdx >= self.length) return;
580 
581         for (uint i = _removeIdx; i < self.length - 1; i++){
582             self[i] = self[i + 1];
583         }
584         self.length--;
585     }
586 
587     function indexOf(uint[] storage self, uint value) internal view returns (uint) {
588         for (uint i = 0; i < self.length; i++){
589             if (self[i] == value) return i;
590         }
591         return uint(-1);
592     }
593 }