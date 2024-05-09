1 pragma solidity ^0.4.20;
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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48   event Pause();
49   event Unpause();
50 
51   bool public paused = false;
52 
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     Unpause();
84   }
85 }
86 
87 contract MintableToken {
88   event Mint(address indexed to, uint256 amount);
89   function leave() public;
90   function mint(address _to, uint256 _amount) public returns (bool);
91 }
92 
93 contract CryptoColors is Pausable {
94   using SafeMath for uint256;
95 
96   // CONSTANT
97 
98   string public constant name = "Pixinch Color";
99   string public constant symbol = "PCLR";
100   uint public constant totalSupply = 16777216;
101 
102   // PUBLIC VARs
103   // the total number of colors bought
104   uint256 public totalBoughtColor;
105   // start and end timestamps where investments are allowed (both inclusive)
106   uint256 public startTime;
107   uint256 public endTime;
108   
109   // address where funds are collected
110   address public wallet;
111   // price for a color
112   uint256 public colorPrice;
113   // nb token supply when a color is bought
114   uint public supplyPerColor;
115   // the part on the supply that is collected by Pixinch
116   uint8 public ownerPart;
117 
118   uint8 public bonusStep;
119   uint public nextBonusStepLimit = 500000;
120 
121   // MODIFIER
122   
123   /**
124   * @dev Guarantees msg.sender is owner of the given token
125   * @param _index uint256 Index of the token to validate its ownership belongs to msg.sender
126   */
127   modifier onlyOwnerOf(uint _index) {
128     require(tree[_index].owner == msg.sender);
129     _;
130   }
131 
132   /**
133   * @dev Garantee index and token are valid value
134   */
135   modifier isValid(uint _tokenId, uint _index) {
136     require(_validToken(_tokenId) && _validIndex(_index));
137     _;
138   }
139 
140   /**
141   * @dev Guarantees all color have been sold
142   */
143   modifier whenActive() {
144     require(isCrowdSaleActive());
145     _;
146   }
147 
148   /**
149   * @dev Guarantees all color have been sold
150   */
151   modifier whenGameActive() {
152     require(isGameActivated());
153     _;
154   }
155 
156   // EVENTS
157   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
158   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
159   event ColorPurchased(address indexed from, address indexed to, uint256 color, uint256 value);
160   event ColorReserved(address indexed to, uint256 qty);
161 
162 
163   // PRIVATE
164   // amount of raised money in wei and cap in wei
165   uint256 weiRaised;
166   uint256 cap;
167   // part of mint token for the wallet
168   uint8 walletPart;
169   // address of the mintable token
170   MintableToken token;
171   // starting color price
172   uint startPrice = 10 finney;
173 
174   struct BlockRange {
175     uint start;
176     uint end;
177     uint next;
178     address owner;
179     uint price;
180   }
181 
182   BlockRange[totalSupply+1] tree;
183   // minId available in the tree
184   uint minId = 1;
185   // min block index available in the tree;
186   uint lastBlockId = 0;
187   // mapping of owner and range index in the tree
188   mapping(address => uint256[]) ownerRangeIndex;
189   // Mapping from token ID to approved address
190   mapping (uint256 => address) tokenApprovals;
191   // pending payments
192   mapping(address => uint) private payments;
193   // mapping owner balance
194   mapping(address => uint) private ownerBalance;
195   
196 
197   // CONSTRUCTOR
198 
199   function CryptoColors(uint256 _startTime, uint256 _endTime, address _token, address _wallet) public {
200     require(_token != address(0));
201     require(_wallet != address(0));
202     require(_startTime > 0);
203     require(_endTime > now);
204 
205     owner = msg.sender;
206     
207     colorPrice = 0.001 ether;
208     supplyPerColor = 4;
209     ownerPart = 50;
210     walletPart = 50;
211 
212     startTime = _startTime;
213     endTime = _endTime;
214     cap = 98000 ether;
215     
216     token = MintableToken(_token);
217     wallet = _wallet;
218     
219     // booked for airdrop and rewards
220     reserveRange(owner, 167770);
221   }
222 
223   // fallback function can be used to buy tokens
224   function () external payable {
225     buy();
226   }
227 
228   // VIEWS
229   
230   function myPendingPayment() public view returns (uint) {
231     return payments[msg.sender];
232   }
233 
234   function isGameActivated() public view returns (bool) {
235     return totalSupply == totalBoughtColor || now > endTime;
236   }
237 
238   function isCrowdSaleActive() public view returns (bool) {
239     return now < endTime && now >= startTime && weiRaised < cap;
240   }
241 
242   function balanceOf(address _owner) public view returns (uint256 balance) {
243     return ownerBalance[_owner];
244   }
245 
246   function ownerOf(uint256 _tokenId) whenGameActive public view returns (address owner) {
247     require(_validToken(_tokenId));
248     uint index = lookupIndex(_tokenId);
249     return tree[index].owner;
250   }
251 
252   // return tokens index own by address (including history)
253   function tokensIndexOf(address _owner, bool _withHistory) whenGameActive public view returns (uint[] result) {
254     require(_owner != address(0));
255     if (_withHistory) {
256       return ownerRangeIndex[_owner];
257     } else {
258       uint[] memory indexes = ownerRangeIndex[_owner];
259       result = new uint[](indexes.length);
260       uint i = 0;
261       for (uint index = 0; index < indexes.length; index++) {
262         BlockRange storage br = tree[indexes[index]];
263         if (br.owner == _owner) {
264           result[i] = indexes[index];
265           i++;
266         }
267       }
268       return;
269     }
270   }
271 
272   function approvedFor(uint256 _tokenId) whenGameActive public view returns (address) {
273     require(_validToken(_tokenId));
274     return tokenApprovals[_tokenId];
275   }
276 
277   /**
278   * @dev Gets the range store at the specified index.
279   * @param _index The index to query the tree of.
280   * @return An Array of value is this order: start, end, owner, next, price.
281   */
282   function getRange(uint _index) public view returns (uint, uint, address, uint, uint) {
283     BlockRange storage range = tree[_index];
284     require(range.owner != address(0));
285     return (range.start, range.end, range.owner, range.next, range.price);
286   }
287 
288   function lookupIndex(uint _tokenId) public view returns (uint index) {
289     return lookupIndex(_tokenId, 1);
290   }
291 
292   function lookupIndex(uint _tokenId, uint _start) public view returns (uint index) {
293     if (_tokenId > totalSupply || _tokenId > minId) {
294       return 0;
295     }
296     BlockRange storage startBlock = tree[_tokenId];
297     if (startBlock.owner != address(0)) {
298       return _tokenId;
299     }
300     index = _start;
301     startBlock = tree[index];
302     require(startBlock.owner != address(0));
303     while (startBlock.end < _tokenId && startBlock.next != 0 ) {
304       index = startBlock.next;
305       startBlock = tree[index];
306     }
307     return;
308   }
309 
310   // PAYABLE
311 
312   function buy() public payable whenActive whenNotPaused returns (string thanks) {
313     require(msg.sender != address(0));
314     require(msg.value.div(colorPrice) > 0);
315     uint _nbColors = 0;
316     uint value = msg.value;
317     if (totalSupply > totalBoughtColor) {
318       (_nbColors, value) = buyColors(msg.sender, value);
319     }
320     if (totalSupply == totalBoughtColor) {
321       // require(value >= colorPrice && weiRaised.add(value) <= cap);
322       if (weiRaised.add(value) > cap) {
323         value = cap.sub(weiRaised);
324       }
325       _nbColors = _nbColors.add(value.div(colorPrice));
326       mintPin(msg.sender, _nbColors);
327       if (weiRaised == cap ) {
328         endTime = now;
329         token.leave();
330       }
331     }
332     forwardFunds(value);
333     return "thank you for your participation.";
334   }
335 
336   function purchase(uint _tokenId) public payable whenGameActive {
337     uint _index = lookupIndex(_tokenId);
338     return purchaseWithIndex(_tokenId, _index);
339   }
340   
341   function purchaseWithIndex(uint _tokenId, uint _index) public payable whenGameActive isValid(_tokenId, _index) {
342     require(msg.sender != address(0));
343 
344     BlockRange storage bRange = tree[_index];
345     require(bRange.start <= _tokenId && _tokenId <= bRange.end);
346     if (bRange.start < bRange.end) {
347       // split and update index;
348       _index = splitRange(_index, _tokenId, _tokenId);
349       bRange = tree[_index];
350     }
351 
352     uint price = bRange.price;
353     address prevOwner = bRange.owner;
354     require(msg.value >= price && prevOwner != msg.sender);
355     if (prevOwner != address(0)) {
356       payments[prevOwner] = payments[prevOwner].add(price);
357       ownerBalance[prevOwner]--;
358     }
359     // add is less expensive than mul
360     bRange.price = bRange.price.add(bRange.price);
361     bRange.owner = msg.sender;
362 
363     // update ownedColors
364     ownerRangeIndex[msg.sender].push(_index);
365     ownerBalance[msg.sender]++;
366 
367     ColorPurchased(prevOwner, msg.sender, _tokenId, price);
368     msg.sender.transfer(msg.value.sub(price));
369   }
370 
371   // PUBLIC
372 
373   function updateToken(address _token) onlyOwner public {
374     require(_token != address(0));
375     token = MintableToken(_token);
376   }
377 
378   function updateWallet(address _wallet) onlyOwner public {
379     require(_wallet != address(0));
380     wallet = _wallet;
381   }
382 
383   function withdrawPayment() public whenGameActive {
384     uint refund = payments[msg.sender];
385     payments[msg.sender] = 0;
386     msg.sender.transfer(refund);
387   }
388 
389   function transfer(address _to, uint256 _tokenId) public {
390     uint _index = lookupIndex(_tokenId);
391     return transferWithIndex(_to, _tokenId, _index);
392   }
393   
394   function transferWithIndex(address _to, uint256 _tokenId, uint _index) public isValid(_tokenId, _index) onlyOwnerOf(_index) {
395     BlockRange storage bRange = tree[_index];
396     if (bRange.start > _tokenId || _tokenId > bRange.end) {
397       _index = lookupIndex(_tokenId, _index);
398       require(_index > 0);
399       bRange = tree[_index];
400     }
401     if (bRange.start < bRange.end) {
402       _index = splitRange(_index, _tokenId, _tokenId);
403       bRange = tree[_index];
404     }
405     require(_to != address(0) && bRange.owner != _to);
406     bRange.owner = _to;
407     ownerRangeIndex[msg.sender].push(_index);
408     Transfer(msg.sender, _to, _tokenId);
409     ownerBalance[_to]++;
410     ownerBalance[msg.sender]--;
411   }
412 
413   function approve(address _to, uint256 _tokenId) public {
414     uint _index = lookupIndex(_tokenId);
415     return approveWithIndex(_to, _tokenId, _index);
416   }
417   
418   function approveWithIndex(address _to, uint256 _tokenId, uint _index) public isValid(_tokenId, _index) onlyOwnerOf(_index) {
419     require(_to != address(0));
420     BlockRange storage bRange = tree[_index];
421     if (bRange.start > _tokenId || _tokenId > bRange.end) {
422       _index = lookupIndex(_tokenId, _index);
423       require(_index > 0);
424       bRange = tree[_index];
425     }
426     require(_to != bRange.owner);
427     if (bRange.start < bRange.end) {
428       splitRange(_index, _tokenId, _tokenId);
429     }
430     tokenApprovals[_tokenId] = _to;
431     Approval(msg.sender, _to, _tokenId);
432   }
433 
434   function takeOwnership(uint256 _tokenId) public {
435     uint index = lookupIndex(_tokenId);
436     return takeOwnershipWithIndex(_tokenId, index);
437   }
438 
439   function takeOwnershipWithIndex(uint256 _tokenId, uint _index) public isValid(_tokenId, _index) {
440     require(tokenApprovals[_tokenId] == msg.sender);
441     BlockRange storage bRange = tree[_index];
442     require(bRange.start <= _tokenId && _tokenId <= bRange.end);
443     ownerBalance[bRange.owner]--;
444     bRange.owner = msg.sender;
445     ownerRangeIndex[msg.sender].push(_index); 
446     ownerBalance[msg.sender]++;
447     Transfer(bRange.owner, msg.sender, _tokenId);
448     delete tokenApprovals[_tokenId];
449   }
450 
451 
452   // INTERNAL
453   function forwardFunds(uint256 value) private {
454     wallet.transfer(value);
455     weiRaised = weiRaised.add(value);
456     msg.sender.transfer(msg.value.sub(value));
457   }
458 
459   function mintPin(address _to, uint _nbColors) private {
460     uint _supply = supplyPerColor.mul(_nbColors);
461     if (_supply == 0) {
462       return;
463     }
464     uint _ownerPart = _supply.mul(ownerPart)/100;
465     token.mint(_to, uint256(_ownerPart.mul(100000000)));
466     uint _walletPart = _supply.mul(walletPart)/100;
467     token.mint(wallet, uint256(_walletPart.mul(100000000)));
468   }
469 
470   function buyColors(address _to, uint256 value) private returns (uint _nbColors, uint valueRest) {
471     _nbColors = value.div(colorPrice);
472     if (bonusStep < 3 && totalBoughtColor.add(_nbColors) > nextBonusStepLimit) {
473       uint max = nextBonusStepLimit.sub(totalBoughtColor);
474       uint val = max.mul(colorPrice);
475       if (max == 0 || val > value) {
476         return (0, value);
477       }
478       valueRest = value.sub(val);
479       reserveColors(_to, max);
480       uint _c;
481       uint _v;
482       (_c, _v) = buyColors(_to, valueRest);
483       return (_c.add(max), _v.add(val));
484     }
485     reserveColors(_to, _nbColors);
486     return (_nbColors, value);
487   }
488 
489   function reserveColors(address _to, uint _nbColors) private returns (uint) {
490     if (_nbColors > totalSupply - totalBoughtColor) {
491       _nbColors = totalSupply - totalBoughtColor;
492     }
493     if (_nbColors == 0) {
494       return;
495     }
496     reserveRange(_to, _nbColors);
497     ColorReserved(_to, _nbColors);
498     mintPin(_to, _nbColors);
499     checkForSteps();
500     return _nbColors;
501   }
502 
503   function checkForSteps() private {
504     if (bonusStep < 3 && totalBoughtColor >= nextBonusStepLimit) {
505       if ( bonusStep == 0) {
506         colorPrice = colorPrice + colorPrice;
507       } else {
508         colorPrice = colorPrice + colorPrice - (1 * 0.001 finney);
509       }
510       bonusStep = bonusStep + 1;
511       nextBonusStepLimit = nextBonusStepLimit + (50000 + (bonusStep+1) * 100000);
512     }
513     if (isGameActivated()) {
514       colorPrice = 1 finney;
515       ownerPart = 70;
516       walletPart = 30;
517       endTime = now.add(120 hours);
518     }
519   }
520 
521   function _validIndex(uint _index) internal view returns (bool) {
522     return _index > 0 && _index < tree.length;
523   }
524 
525   function _validToken(uint _tokenId) internal pure returns (bool) {
526     return _tokenId > 0 && _tokenId <= totalSupply;
527   }
528 
529   function reserveRange(address _to, uint _nbTokens) internal {
530     require(_nbTokens <= totalSupply);
531     BlockRange storage rblock = tree[minId];
532     rblock.start = minId;
533     rblock.end = minId.add(_nbTokens).sub(1);
534     rblock.owner = _to;
535     rblock.price = startPrice;
536     
537     rblock = tree[lastBlockId];
538     rblock.next = minId;
539     
540     lastBlockId = minId;
541     ownerRangeIndex[_to].push(minId);
542     
543     ownerBalance[_to] = ownerBalance[_to].add(_nbTokens);
544     minId = minId.add(_nbTokens);
545     totalBoughtColor = totalBoughtColor.add(_nbTokens);
546   }
547 
548   function splitRange(uint index, uint start, uint end) internal returns (uint) {
549     require(index > 0);
550     require(start <= end);
551     BlockRange storage startBlock = tree[index];
552     require(startBlock.start < startBlock.end && startBlock.start <= start && startBlock.end >= end);
553 
554     BlockRange memory rblockUnique = tree[start];
555     rblockUnique.start = start;
556     rblockUnique.end = end;
557     rblockUnique.owner = startBlock.owner;
558     rblockUnique.price = startBlock.price;
559     
560     uint nextStart = end.add(1);
561     if (nextStart <= totalSupply) {
562       rblockUnique.next = nextStart;
563 
564       BlockRange storage rblockEnd = tree[nextStart];
565       rblockEnd.start = nextStart;
566       rblockEnd.end = startBlock.end;
567       rblockEnd.owner = startBlock.owner;
568       rblockEnd.next = startBlock.next;
569       rblockEnd.price = startBlock.price;
570     }
571 
572     if (startBlock.start < start) {
573       startBlock.end = start.sub(1);
574     } else {
575       startBlock.end = start;
576     }
577     startBlock.next = start;
578     tree[start] = rblockUnique;
579     // update own color
580     if (rblockUnique.next != startBlock.next) {
581       ownerRangeIndex[startBlock.owner].push(startBlock.next);
582     }
583     if (rblockUnique.next != 0) {
584       ownerRangeIndex[startBlock.owner].push(rblockUnique.next);
585     }
586     
587     return startBlock.next;
588   }
589 }
590 
591 /**
592  * @title SafeMath
593  * @dev Math operations with safety checks that throw on error
594  */
595 library SafeMath {
596 
597   /**
598   * @dev Multiplies two numbers, throws on overflow.
599   */
600   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
601     if (a == 0) {
602       return 0;
603     }
604     uint256 c = a * b;
605     assert(c / a == b);
606     return c;
607   }
608 
609   /**
610   * @dev Integer division of two numbers, truncating the quotient.
611   */
612   function div(uint256 a, uint256 b) internal pure returns (uint256) {
613     // assert(b > 0); // Solidity automatically throws when dividing by 0
614     uint256 c = a / b;
615     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
616     return c;
617   }
618 
619   /**
620   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
621   */
622   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
623     assert(b <= a);
624     return a - b;
625   }
626 
627   /**
628   * @dev Adds two numbers, throws on overflow.
629   */
630   function add(uint256 a, uint256 b) internal pure returns (uint256) {
631     uint256 c = a + b;
632     assert(c >= a);
633     return c;
634   }
635 }