1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC721 interface
5  * @dev see https://github.com/ethereum/eips/issues/721
6  */
7 contract ERC721 {
8   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
9   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
10 
11   function balanceOf(address _owner) public view returns (uint256 _balance);
12   function ownerOf(uint256 _tokenId) public view returns (address _owner);
13   function transfer(address _to, uint256 _tokenId) public;
14   function approve(address _to, uint256 _tokenId) public;
15   function takeOwnership(uint256 _tokenId) public;
16 }
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 /**
61  * @title Pausable
62  * @dev Base contract which allows children to implement an emergency stop mechanism.
63  */
64 contract Pausable is Ownable {
65   event Pause();
66   event Unpause();
67 
68   bool public paused = false;
69 
70 
71   /**
72    * @dev Modifier to make a function callable only when the contract is not paused.
73    */
74   modifier whenNotPaused() {
75     require(!paused);
76     _;
77   }
78 
79   /**
80    * @dev Modifier to make a function callable only when the contract is paused.
81    */
82   modifier whenPaused() {
83     require(paused);
84     _;
85   }
86 
87   /**
88    * @dev called by the owner to pause, triggers stopped state
89    */
90   function pause() onlyOwner whenNotPaused public {
91     paused = true;
92     Pause();
93   }
94 
95   /**
96    * @dev called by the owner to unpause, returns to normal state
97    */
98   function unpause() onlyOwner whenPaused public {
99     paused = false;
100     Unpause();
101   }
102 }
103 
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that throw on error
107  */
108 library SafeMath {
109   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
110     uint256 c = a * b;
111     assert(a == 0 || c / a == b);
112     return c;
113   }
114 
115   function div(uint256 a, uint256 b) internal constant returns (uint256) {
116     // assert(b > 0); // Solidity automatically throws when dividing by 0
117     uint256 c = a / b;
118     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119     return c;
120   }
121 
122   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
123     assert(b <= a);
124     return a - b;
125   }
126   
127   function add(uint256 a, uint256 b) internal constant returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134 /**
135  * @title ERC721Token
136  * Generic implementation for the required functionality of the ERC721 standard
137  */
138 contract BurritoToken is ERC721, Ownable, Pausable {
139   using SafeMath for uint256;
140 
141   // Total amount of tokens
142   uint256 private totalTokens;
143   uint256[] private listed;
144   uint256 public devOwed;
145   uint256 public burritoPoolTotal;
146   uint256 public tacoPoolTotal;
147   uint256 public saucePoolTotal;
148   uint256 public lastPurchase;
149 
150   // Burrito Data
151   mapping (uint256 => Token) private tokens;
152 
153   // Mapping from token ID to owner
154   mapping (uint256 => address) private tokenOwner;
155 
156   // Mapping from token ID to approved address
157   mapping (uint256 => address) private tokenApprovals;
158 
159   // Mapping from owner to list of owned token IDs
160   mapping (address => uint256[]) private ownedTokens;
161 
162   // Mapping from token ID to index of the owner tokens list
163   mapping(uint256 => uint256) private ownedTokensIndex;
164 
165   // Balances from % payouts.
166   mapping (address => uint256) private payoutBalances; 
167 
168   // Events
169   event Purchased(uint256 indexed _tokenId, address indexed _owner, uint256 _purchasePrice);
170 
171   // Purchasing Caps for Determining Next Pool Cut
172   uint256 private firstCap  = 0.5 ether;
173   uint256 private secondCap = 1.0 ether;
174   uint256 private thirdCap  = 3.0 ether;
175   uint256 private finalCap  = 5.0 ether;
176 
177   // Percentages
178   uint256 public feePercentage = 5;
179   uint256 public dividendCutPercentage = 100; // 100 / 10000
180   uint256 public dividendDecreaseFactor = 2;
181   uint256 public megabossCutPercentage = 1;
182   uint256 public bossCutPercentage = 1;
183   uint256 public mainPoolCutPercentage = 15;
184 
185   // Bosses
186   uint256 private megabossTokenId = 10000000;
187 
188   uint256 private BURRITO_KIND = 1;
189   uint256 private TACO_KIND = 2;
190   uint256 private SAUCE_KIND = 3;
191 
192   // Struct to store Burrito Data
193   struct Token {
194       uint256 price;         // Current price of the item.
195       uint256 lastPrice;     // lastPrice this was sold for, used for adding to pool.
196       uint256 payout;        // The percent of the pool rewarded.
197       uint256 withdrawn;     // The amount of Eth this token has withdrawn from the pool.
198       address owner;         // Current owner of the item.
199       uint256 bossTokenId;   // Current boss of the token - 1% bossCut
200       uint8   kind;          // 1 - burrito, 2 - taco, 3 - sauce
201       address[5] previousOwners;
202   }
203 
204   /**
205   * @dev createListing Adds new ERC721 Token
206   * @param _tokenId uint256 ID of new token
207   * @param _price uint256 starting price in wei
208   * @param _payoutPercentage uint256 payout percentage (divisible by 10)
209   * @param _owner address of new owner
210   */
211   function createToken(uint256 _tokenId, uint256 _price, uint256 _lastPrice, uint256 _payoutPercentage, uint8 _kind, uint256 _bossTokenId, address _owner) onlyOwner() public {
212     require(_price > 0);
213     require(_lastPrice < _price);
214     // make sure token hasn't been used yet
215     require(tokens[_tokenId].price == 0);
216     // check for kinds
217     require(_kind > 0 && _kind <= 3);
218     
219     // create new token
220     Token storage newToken = tokens[_tokenId];
221 
222     newToken.owner = _owner;
223     newToken.price = _price;
224     newToken.lastPrice = _lastPrice;
225     newToken.payout = _payoutPercentage;
226     newToken.kind = _kind;
227     newToken.bossTokenId = _bossTokenId;
228     newToken.previousOwners = [address(this), address(this), address(this), address(this), address(this)];
229 
230     // store burrito in storage
231     listed.push(_tokenId);
232     
233     // mint new token
234     _mint(_owner, _tokenId);
235   }
236 
237   function createMultiple (uint256[] _itemIds, uint256[] _prices, uint256[] _lastPrices, uint256[] _payouts, uint8[] _kinds, uint256[] _bossTokenIds, address[] _owners) onlyOwner() external {
238     for (uint256 i = 0; i < _itemIds.length; i++) {
239       createToken(_itemIds[i], _prices[i], _lastPrices[i], _payouts[i], _kinds[i], _bossTokenIds[i], _owners[i]);
240     }
241   }
242 
243   /**
244   * @dev Determines next price of token
245   * @param _price uint256 ID of current price
246   */
247   function getNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
248     if (_price < firstCap) {
249       return _price.mul(200).div(100 - feePercentage);
250     } else if (_price < secondCap) {
251       return _price.mul(135).div(100 - feePercentage);
252     } else if (_price < thirdCap) {
253       return _price.mul(125).div(100 - feePercentage);
254     } else if (_price < finalCap) {
255       return _price.mul(117).div(100 - feePercentage);
256     } else {
257       return _price.mul(115).div(100 - feePercentage);
258     }
259   }
260 
261   function calculatePoolCut (uint256 _price) public view returns (uint256 _poolCut) {
262     if (_price < firstCap) {
263       return _price.mul(10).div(100);
264     } else if (_price < secondCap) {
265       return _price.mul(9).div(100);
266     } else if (_price < thirdCap) {
267       return _price.mul(8).div(100);
268     } else if (_price < finalCap) {
269       return _price.mul(7).div(100);
270     } else {
271       return _price.mul(5).div(100);
272     }
273   }
274 
275   /**
276   * @dev Purchase burrito from previous owner
277   * @param _tokenId uint256 of token
278   */
279   function purchase(uint256 _tokenId) public 
280     payable
281     isNotContract(msg.sender)
282   {
283     require(!paused);
284 
285     // get data from storage
286     Token storage token = tokens[_tokenId];
287     uint256 price = token.price;
288     address oldOwner = token.owner;
289 
290     // revert checks
291     require(price > 0);
292     require(msg.value >= price);
293     require(oldOwner != msg.sender);
294 
295     // Calculate pool cut for taxes.
296     uint256 priceDelta = price.sub(token.lastPrice);
297     uint256 poolCut = calculatePoolCut(priceDelta);
298     
299     _updatePools(token.kind, poolCut);
300     
301     uint256 fee = price.mul(feePercentage).div(100);
302     devOwed = devOwed.add(fee);
303 
304     // Dividends
305     uint256 taxesPaid = _payDividendsAndBosses(token, price);
306 
307     _shiftPreviousOwners(token, msg.sender);
308 
309     transferToken(oldOwner, msg.sender, _tokenId);
310 
311     // Transfer payment to old owner minus the developer's and pool's cut.
312     // Calculate the winnings for the previous owner.
313     uint256 finalPayout = price.sub(fee).sub(poolCut).sub(taxesPaid);
314 
315     // set new prices
316     token.lastPrice = price;
317     token.price = getNextPrice(price);
318 
319     // raise event
320     Purchased(_tokenId, msg.sender, price);
321 
322     if (oldOwner != address(this)) {
323       oldOwner.transfer(finalPayout);
324     }
325 
326     // Calculate overspending
327     uint256 excess = msg.value - price;
328     
329     if (excess > 0) {
330         // Refund overspending
331         msg.sender.transfer(excess);
332     }
333     
334     // set last purchase price to storage
335     lastPurchase = now;
336   }
337 
338     /// @dev Shift the 6 most recent buyers, and add the new buyer
339   /// to the front.
340   /// @param _newOwner The buyer to add to the front of the recent
341   /// buyers list.
342   function _shiftPreviousOwners(Token storage _token, address _newOwner) private {
343       _token.previousOwners[4] = _token.previousOwners[3];
344       _token.previousOwners[3] = _token.previousOwners[2];
345       _token.previousOwners[2] = _token.previousOwners[1];
346       _token.previousOwners[1] = _token.previousOwners[0];
347       _token.previousOwners[0] = _newOwner;
348   }
349 
350   function _updatePools(uint8 _kind, uint256 _poolCut) internal {
351     uint256 poolCutToMain = _poolCut.mul(mainPoolCutPercentage).div(100);
352 
353     if (_kind == BURRITO_KIND) {
354       burritoPoolTotal += _poolCut;
355     } else if (_kind == TACO_KIND) {
356       burritoPoolTotal += poolCutToMain;
357 
358       tacoPoolTotal += _poolCut.sub(poolCutToMain);
359     } else if (_kind == SAUCE_KIND) {
360       burritoPoolTotal += poolCutToMain;
361 
362       saucePoolTotal += _poolCut.sub(poolCutToMain);
363     }
364   }
365 
366   // 1%, 0.5%, 0.25%, 0.125%, 0.0625%
367   function _payDividendsAndBosses(Token _token, uint256 _price) private returns (uint256 paid) {
368     uint256 dividend0 = _price.mul(dividendCutPercentage).div(10000);
369     uint256 dividend1 = dividend0.div(dividendDecreaseFactor);
370     uint256 dividend2 = dividend1.div(dividendDecreaseFactor);
371     uint256 dividend3 = dividend2.div(dividendDecreaseFactor);
372     uint256 dividend4 = dividend3.div(dividendDecreaseFactor);
373 
374     // Pay first dividend.
375     if (_token.previousOwners[0] != address(this)) {_token.previousOwners[0].transfer(dividend0); paid = paid.add(dividend0);}
376     if (_token.previousOwners[1] != address(this)) {_token.previousOwners[1].transfer(dividend1); paid = paid.add(dividend1);}
377     if (_token.previousOwners[2] != address(this)) {_token.previousOwners[2].transfer(dividend2); paid = paid.add(dividend2);}
378     if (_token.previousOwners[3] != address(this)) {_token.previousOwners[3].transfer(dividend3); paid = paid.add(dividend3);}
379     if (_token.previousOwners[4] != address(this)) {_token.previousOwners[4].transfer(dividend4); paid = paid.add(dividend4);}
380 
381     uint256 tax = _price.mul(1).div(100);
382 
383     if (tokens[megabossTokenId].owner != address(0)) {
384       tokens[megabossTokenId].owner.transfer(tax);
385       paid = paid.add(tax);
386     }
387 
388     if (tokens[_token.bossTokenId].owner != address(0)) { 
389       tokens[_token.bossTokenId].owner.transfer(tax);
390       paid = paid.add(tax);
391     }
392   }
393 
394   /**
395   * @dev Transfer Token from Previous Owner to New Owner
396   * @param _from previous owner address
397   * @param _to new owner address
398   * @param _tokenId uint256 ID of token
399   */
400   function transferToken(address _from, address _to, uint256 _tokenId) internal {
401 
402     // check token exists
403     require(tokenExists(_tokenId));
404 
405     // make sure previous owner is correct
406     require(tokens[_tokenId].owner == _from);
407 
408     require(_to != address(0));
409     require(_to != address(this));
410 
411     // pay any unpaid payouts to previous owner of burrito
412     updateSinglePayout(_from, _tokenId);
413 
414     // clear approvals linked to this token
415     clearApproval(_from, _tokenId);
416 
417     // remove token from previous owner
418     removeToken(_from, _tokenId);
419 
420     // update owner and add token to new owner
421     tokens[_tokenId].owner = _to;
422     addToken(_to, _tokenId);
423 
424    //raise event
425     Transfer(_from, _to, _tokenId);
426   }
427 
428   /**
429   * @dev Withdraw dev's cut
430   */
431   function withdraw() onlyOwner public {
432     owner.transfer(devOwed);
433     devOwed = 0;
434   }
435 
436   /**
437   * @dev Updates the payout for the burritos the owner has
438   * @param _owner address of token owner
439   */
440   // function updatePayout(address _owner) public {
441   //   uint256[] memory ownerTokens = ownedTokens[_owner];
442   //   uint256 owed;
443   //   for (uint256 i = 0; i < ownerTokens.length; i++) {
444   //     owed += _calculateOnePayout(ownerTokens[i]);
445   //   }
446 
447   //   payoutBalances[_owner] += owed;
448   // }
449 
450   function updatePayout(address _owner) public {
451     uint256[] memory ownerTokens = ownedTokens[_owner];
452     uint256 owed;
453     for (uint256 i = 0; i < ownerTokens.length; i++) {
454         uint256 totalOwed;
455         
456         if (tokens[ownerTokens[i]].kind == BURRITO_KIND) {
457           totalOwed = burritoPoolTotal * tokens[ownerTokens[i]].payout / 10000;
458         } else if (tokens[ownerTokens[i]].kind == TACO_KIND) {
459           totalOwed = tacoPoolTotal * tokens[ownerTokens[i]].payout / 10000;
460         } else if (tokens[ownerTokens[i]].kind == SAUCE_KIND) {
461           totalOwed = saucePoolTotal * tokens[ownerTokens[i]].payout / 10000;
462         }
463 
464         uint256 totalTokenOwed = totalOwed.sub(tokens[ownerTokens[i]].withdrawn);
465         owed += totalTokenOwed;
466         
467         tokens[ownerTokens[i]].withdrawn += totalTokenOwed;
468     }
469     payoutBalances[_owner] += owed;
470   }
471 
472   function priceOf(uint256 _tokenId) public view returns (uint256) {
473     return tokens[_tokenId].price;
474   }
475 
476   /**
477    * @dev Update a single burrito payout for transfers.
478    * @param _owner Address of the owner of the burrito.
479    * @param _tokenId Unique Id of the token.
480   **/
481   function updateSinglePayout(address _owner, uint256 _tokenId) internal {
482     uint256 totalOwed;
483         
484     if (tokens[_tokenId].kind == BURRITO_KIND) {
485       totalOwed = burritoPoolTotal * tokens[_tokenId].payout / 10000;
486     } else if (tokens[_tokenId].kind == TACO_KIND) {
487       totalOwed = tacoPoolTotal * tokens[_tokenId].payout / 10000;
488     } else if (tokens[_tokenId].kind == SAUCE_KIND) {
489       totalOwed = saucePoolTotal * tokens[_tokenId].payout / 10000;
490     }
491 
492     uint256 totalTokenOwed = totalOwed.sub(tokens[_tokenId].withdrawn);
493         
494     tokens[_tokenId].withdrawn += totalTokenOwed;
495     payoutBalances[_owner] += totalTokenOwed;
496   }
497 
498   /**
499   * @dev Owner can withdraw their accumulated payouts
500   * @param _owner address of token owner
501   */
502   function withdrawRent(address _owner) public {
503     require(_owner != address(0));
504     updatePayout(_owner);
505     uint256 payout = payoutBalances[_owner];
506     payoutBalances[_owner] = 0;
507     _owner.transfer(payout);
508   }
509 
510   function getRentOwed(address _owner) public view returns (uint256 owed) {
511     require(_owner != address(0));
512     updatePayout(_owner);
513     return payoutBalances[_owner];
514   }
515 
516   /**
517   * @dev Return all burrito data
518   * @param _tokenId uint256 of token
519   */
520   function getToken (uint256 _tokenId) external view 
521   returns (address _owner, uint256 _price, uint256 _lastPrice, uint256 _nextPrice, uint256 _payout, uint8 _kind, uint256 _bossTokenId, address[5] _previosOwners) 
522   {
523     Token memory token = tokens[_tokenId];
524     return (token.owner, token.price, token.lastPrice, getNextPrice(token.price), token.payout, token.kind, token.bossTokenId, token.previousOwners);
525   }
526 
527   /**
528   * @dev Determines if token exists by checking it's price
529   * @param _tokenId uint256 ID of token
530   */
531   function tokenExists (uint256 _tokenId) public view returns (bool _exists) {
532     return tokens[_tokenId].price > 0;
533   }
534 
535   /**
536   * @dev Guarantees msg.sender is owner of the given token
537   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
538   */
539   modifier onlyOwnerOf(uint256 _tokenId) {
540     require(ownerOf(_tokenId) == msg.sender);
541     _;
542   }
543 
544   /**
545   * @dev Guarantees msg.sender is not a contract
546   * @param _buyer address of person buying burrito
547   */
548   modifier isNotContract(address _buyer) {
549     uint size;
550     assembly { size := extcodesize(_buyer) }
551     require(size == 0);
552     _;
553   }
554 
555 
556   /**
557   * @dev Gets the total amount of tokens stored by the contract
558   * @return uint256 representing the total amount of tokens
559   */
560   function totalSupply() public view returns (uint256) {
561     return totalTokens;
562   }
563 
564   /**
565   * @dev Gets the balance of the specified address
566   * @param _owner address to query the balance of
567   * @return uint256 representing the amount owned by the passed address
568   */
569   function balanceOf(address _owner) public view returns (uint256) {
570     return ownedTokens[_owner].length;
571   }
572 
573   /**
574   * @dev Gets the list of tokens owned by a given address
575   * @param _owner address to query the tokens of
576   * @return uint256[] representing the list of tokens owned by the passed address
577   */
578   function tokensOf(address _owner) public view returns (uint256[]) {
579     return ownedTokens[_owner];
580   }
581 
582   /**
583   * @dev Gets the owner of the specified token ID
584   * @param _tokenId uint256 ID of the token to query the owner of
585   * @return owner address currently marked as the owner of the given token ID
586   */
587   function ownerOf(uint256 _tokenId) public view returns (address) {
588     address owner = tokenOwner[_tokenId];
589     require(owner != address(0));
590     return owner;
591   }
592 
593   /**
594    * @dev Gets the approved address to take ownership of a given token ID
595    * @param _tokenId uint256 ID of the token to query the approval of
596    * @return address currently approved to take ownership of the given token ID
597    */
598   function approvedFor(uint256 _tokenId) public view returns (address) {
599     return tokenApprovals[_tokenId];
600   }
601 
602   /**
603   * @dev Transfers the ownership of a given token ID to another address
604   * @param _to address to receive the ownership of the given token ID
605   * @param _tokenId uint256 ID of the token to be transferred
606   */
607   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
608     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
609   }
610 
611   /**
612   * @dev Approves another address to claim for the ownership of the given token ID
613   * @param _to address to be approved for the given token ID
614   * @param _tokenId uint256 ID of the token to be approved
615   */
616   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
617     address owner = ownerOf(_tokenId);
618     require(_to != owner);
619     if (approvedFor(_tokenId) != 0 || _to != 0) {
620       tokenApprovals[_tokenId] = _to;
621       Approval(owner, _to, _tokenId);
622     }
623   }
624 
625   /**
626   * @dev Claims the ownership of a given token ID
627   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
628   */
629   function takeOwnership(uint256 _tokenId) public {
630     require(isApprovedFor(msg.sender, _tokenId));
631     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
632   }
633 
634   /**
635    * @dev Tells whether the msg.sender is approved for the given token ID or not
636    * This function is not private so it can be extended in further implementations like the operatable ERC721
637    * @param _owner address of the owner to query the approval of
638    * @param _tokenId uint256 ID of the token to query the approval of
639    * @return bool whether the msg.sender is approved for the given token ID or not
640    */
641   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
642     return approvedFor(_tokenId) == _owner;
643   }
644   
645   /**
646   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
647   * @param _from address which you want to send tokens from
648   * @param _to address which you want to transfer the token to
649   * @param _tokenId uint256 ID of the token to be transferred
650   */
651   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal isNotContract(_to) {
652     require(_to != address(0));
653     require(_to != ownerOf(_tokenId));
654     require(ownerOf(_tokenId) == _from);
655 
656     clearApproval(_from, _tokenId);
657     updateSinglePayout(_from, _tokenId);
658     removeToken(_from, _tokenId);
659     addToken(_to, _tokenId);
660     Transfer(_from, _to, _tokenId);
661   }
662 
663   /**
664   * @dev Internal function to clear current approval of a given token ID
665   * @param _tokenId uint256 ID of the token to be transferred
666   */
667   function clearApproval(address _owner, uint256 _tokenId) private {
668     require(ownerOf(_tokenId) == _owner);
669     tokenApprovals[_tokenId] = 0;
670     Approval(_owner, 0, _tokenId);
671   }
672 
673 
674     /**
675   * @dev Mint token function
676   * @param _to The address that will own the minted token
677   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
678   */
679   function _mint(address _to, uint256 _tokenId) internal {
680     require(_to != address(0));
681     addToken(_to, _tokenId);
682     Transfer(0x0, _to, _tokenId);
683   }
684 
685   /**
686   * @dev Internal function to add a token ID to the list of a given address
687   * @param _to address representing the new owner of the given token ID
688   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
689   */
690   function addToken(address _to, uint256 _tokenId) private {
691     require(tokenOwner[_tokenId] == address(0));
692     tokenOwner[_tokenId] = _to;
693     tokens[_tokenId].owner = _to;
694     uint256 length = balanceOf(_to);
695     ownedTokens[_to].push(_tokenId);
696     ownedTokensIndex[_tokenId] = length;
697     totalTokens = totalTokens.add(1);
698   }
699 
700   /**
701   * @dev Internal function to remove a token ID from the list of a given address
702   * @param _from address representing the previous owner of the given token ID
703   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
704   */
705   function removeToken(address _from, uint256 _tokenId) private {
706     require(ownerOf(_tokenId) == _from);
707 
708     uint256 tokenIndex = ownedTokensIndex[_tokenId];
709     uint256 lastTokenIndex = balanceOf(_from).sub(1);
710     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
711 
712     tokenOwner[_tokenId] = 0;
713     ownedTokens[_from][tokenIndex] = lastToken;
714     ownedTokens[_from][lastTokenIndex] = 0;
715     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
716     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
717     // the lastToken to the first position, and then dropping the element placed in the last position of the list
718 
719     ownedTokens[_from].length--;
720     ownedTokensIndex[_tokenId] = 0;
721     ownedTokensIndex[lastToken] = tokenIndex;
722     totalTokens = totalTokens.sub(1);
723   }
724 
725   function name() public pure returns (string _name) {
726     return "CryptoBurrito.co";
727   }
728 
729   function symbol() public pure returns (string _symbol) {
730     return "MBT";
731   }
732 
733   function setFeePercentage(uint256 _newFee) onlyOwner public {
734     require(_newFee <= 5);
735     require(_newFee >= 3);
736 
737     feePercentage = _newFee;
738   }
739   
740   function setMainPoolCutPercentage(uint256 _newFee) onlyOwner public {
741     require(_newFee <= 30);
742     require(_newFee >= 5);
743 
744     mainPoolCutPercentage = _newFee;
745   }
746 
747   function setDividendCutPercentage(uint256 _newFee) onlyOwner public {
748     require(_newFee <= 200);
749     require(_newFee >= 50);
750 
751     dividendCutPercentage = _newFee;
752   }
753 
754   // Migration
755   OldContract oldContract;
756 
757   function setOldContract(address _addr) onlyOwner public {
758     oldContract = OldContract(_addr);
759   }
760 
761   function populateFromOldContract(uint256[] _ids) onlyOwner public {
762     for (uint256 i = 0; i < _ids.length; i++) {
763       // Can't rewrite tokens
764       if (tokens[_ids[i]].price == 0) {
765         address _owner;
766         uint256 _price;
767         uint256 _lastPrice;
768         uint256 _nextPrice;
769         uint256 _payout;
770         uint8 _kind;
771         uint256 _bossTokenId;
772 
773         (_owner, _price, _lastPrice, _nextPrice, _payout, _kind, _bossTokenId) = oldContract.getToken(_ids[i]);
774 
775         createToken(_ids[i], _price, _lastPrice, _payout, _kind, _bossTokenId, _owner);
776       }
777     }
778   }
779 }
780 
781 interface OldContract {
782   function getToken (uint256 _tokenId) external view 
783   returns (address _owner, uint256 _price, uint256 _lastPrice, uint256 _nextPrice, uint256 _payout, uint8 _kind, uint256 _bossTokenId);
784 }