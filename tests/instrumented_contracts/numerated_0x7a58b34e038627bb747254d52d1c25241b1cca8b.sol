1 pragma solidity ^0.4.18;
2 /** 
3 *@title ERC721 interface
4 */
5 contract ERC721 {
6   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
7   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
8 
9   function balanceOf(address _owner) public view returns (uint256 _balance);
10   function ownerOf(uint256 _tokenId) public view returns (address _owner);
11   function transfer(address _to, uint256 _tokenId) public;
12   function approve(address _to, uint256 _tokenId) public;
13   function takeOwnership(uint256 _tokenId) public;
14 }
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22   address public owner;
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   function Ownable() public {
31     owner = msg.sender;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) onlyOwner public {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 }
52 
53 /**
54  * @title Pausable
55  * @dev Base contract which allows children to implement an emergency stop mechanism.
56  */
57 contract Pausable is Ownable {
58   event Pause();
59   event Unpause();
60 
61   bool public paused = false;
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is not paused.
65    */
66   modifier whenNotPaused() {
67     require(!paused);
68     _;
69   }
70 
71   /**
72    * @dev Modifier to make a function callable only when the contract is paused.
73    */
74   modifier whenPaused() {
75     require(paused);
76     _;
77   }
78 
79   /**
80    * @dev called by the owner to pause, triggers stopped state
81    */
82   function pause() onlyOwner whenNotPaused public {
83     paused = true;
84     Pause();
85   }
86 
87   /**
88    * @dev called by the owner to unpause, returns to normal state
89    */
90   function unpause() onlyOwner whenPaused public {
91     paused = false;
92     Unpause();
93   }
94 }
95 
96 /**
97  * @title SafeMath
98  * @dev Math operations with safety checks that throw on error
99  */
100 library SafeMath {
101 
102   /**
103   * @dev Multiplies two numbers, throws on overflow.
104   */
105   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106     if (a == 0) {
107       return 0;
108     }
109     uint256 c = a * b;
110     assert(c / a == b);
111     return c;
112   }
113 
114   /**
115   * @dev Integer division of two numbers, truncating the quotient.
116   */
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return c;
122   }
123 
124   /**
125   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126   */
127   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128     assert(b <= a);
129     return a - b;
130   }
131 
132   /**
133   * @dev Adds two numbers, throws on overflow.
134   */
135   function add(uint256 a, uint256 b) internal pure returns (uint256) {
136     uint256 c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }
141 
142 /**
143  * @title ERC721Token
144  * Generic implementation for the required functionality of the ERC721 standard
145  */
146 contract CryptoMayorToken is ERC721, Ownable, Pausable {
147   using SafeMath for uint256;
148 
149   // Total amount of tokens
150   uint256 private totalTokens;
151   uint256[] private listed;
152   uint256 public devOwed;
153   uint256 public cityPoolTotal;
154   uint256 public landmarkPoolTotal;
155   uint256 public otherPoolTotal;
156   uint256 public lastPurchase;
157 
158   // Token Data
159   mapping (uint256 => Token) private tokens;
160 
161   // Mapping from token ID to owner
162   mapping (uint256 => address) private tokenOwner;
163 
164   // Mapping from token ID to approved address
165   mapping (uint256 => address) private tokenApprovals;
166 
167   // Mapping from owner to list of owned token IDs
168   mapping (address => uint256[]) private ownedTokens;
169 
170   // Mapping from token ID to index of the owner tokens list
171   mapping(uint256 => uint256) private ownedTokensIndex;
172 
173   // Balances from % payouts.
174   mapping (address => uint256) private payoutBalances; 
175 
176   // Events
177   event Purchased(uint256 indexed _tokenId, address indexed _owner, uint256 _purchasePrice);
178 
179   // Purchasing Caps for Determining Next Pool Cut
180   uint256 private firstCap  = 0.5 ether;
181   uint256 private secondCap = 1.0 ether;
182   uint256 private thirdCap  = 3.0 ether;
183   uint256 private finalCap  = 5.0 ether;
184 
185   // Percentages
186   uint256 public feePercentage = 5;
187   uint256 public dividendCutPercentage = 100; // 100 / 10000
188   uint256 public dividendDecreaseFactor = 2;
189   uint256 public powermayorCutPercentage = 1;
190   uint256 public mayorCutPercentage = 1;
191   uint256 public cityPoolCutPercentage = 15;
192 
193   // Mayors
194   uint256 private powermayorTokenId = 10000000;
195 
196   uint256 private CITY = 1;
197   uint256 private LANDMARK = 2;
198   uint256 private OTHER = 3;
199 
200   // Struct to store Token Data
201   struct Token {
202       uint256 price;         // Current price of the item.
203       uint256 lastPrice;     // lastPrice this was sold for, used for adding to pool.
204       uint256 payout;        // The percent of the pool rewarded.
205       uint256 withdrawn;     // The amount of Eth this token has withdrawn from the pool.
206       address owner;         // Current owner of the item.
207       uint256 mayorTokenId;   // Current mayor of the token - 1% mayorCut
208       uint8   kind;          // 1 - city, 2 - landmark, 3 - other
209       address[5] previousOwners;
210   }
211 
212   /**
213   * @dev createListing Adds new ERC721 Token
214   * @param _tokenId uint256 ID of new token
215   * @param _price uint256 starting price in wei
216   * @param _payoutPercentage uint256 payout percentage (divisible by 10)
217   * @param _owner address of new owner
218   */
219   function createToken(uint256 _tokenId, uint256 _price, uint256 _lastPrice, uint256 _payoutPercentage, uint8 _kind, uint256 _mayorTokenId, address _owner) onlyOwner() public {
220     require(_price > 0);
221     require(_lastPrice < _price);
222     
223     // make sure token hasn't been used yet
224     require(tokens[_tokenId].price == 0);
225     
226     // check for kinds
227     require(_kind > 0 && _kind <= 3);
228     
229     // create new token
230     Token storage newToken = tokens[_tokenId];
231 
232     newToken.owner = _owner;
233     newToken.price = _price;
234     newToken.lastPrice = _lastPrice;
235     newToken.payout = _payoutPercentage;
236     newToken.kind = _kind;
237     newToken.mayorTokenId = _mayorTokenId;
238     newToken.previousOwners = [address(this), address(this), address(this), address(this), address(this)];
239 
240     // store token in storage
241     listed.push(_tokenId);
242     
243     // mint new token
244     _mint(_owner, _tokenId);
245   }
246 
247   function createMultiple (uint256[] _itemIds, uint256[] _prices, uint256[] _lastPrices, uint256[] _payouts, uint8[] _kinds, uint256[] _mayorTokenIds, address[] _owners) onlyOwner() external {
248     for (uint256 i = 0; i < _itemIds.length; i++) {
249       createToken(_itemIds[i], _prices[i], _lastPrices[i], _payouts[i], _kinds[i], _mayorTokenIds[i], _owners[i]);
250     }
251   }
252 
253   /**
254   * @dev Determines next price of token
255   * @param _price uint256 ID of current price
256   */
257   function getNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
258     if (_price < firstCap) {
259       return _price.mul(200).div(100 - feePercentage);
260     } else if (_price < secondCap) {
261       return _price.mul(135).div(100 - feePercentage);
262     } else if (_price < thirdCap) {
263       return _price.mul(125).div(100 - feePercentage);
264     } else if (_price < finalCap) {
265       return _price.mul(117).div(100 - feePercentage);
266     } else {
267       return _price.mul(115).div(100 - feePercentage);
268     }
269   }
270 
271   function calculatePoolCut (uint256 _price) public view returns (uint256 _poolCut) {
272     if (_price < firstCap) {
273       return _price.mul(10).div(100);
274     } else if (_price < secondCap) {
275       return _price.mul(9).div(100);
276     } else if (_price < thirdCap) {
277       return _price.mul(8).div(100);
278     } else if (_price < finalCap) {
279       return _price.mul(7).div(100);
280     } else {
281       return _price.mul(5).div(100);
282     }
283   }
284 
285   /**
286   * @dev Purchase toekn from previous owner
287   * @param _tokenId uint256 of token
288   */
289   function purchase(uint256 _tokenId) public 
290     payable
291     isNotContract(msg.sender)
292   {
293     require(!paused);
294 
295     // get data from storage
296     Token storage token = tokens[_tokenId];
297     uint256 price = token.price;
298     address oldOwner = token.owner;
299 
300     // revert checks
301     require(price > 0);
302     require(msg.value >= price);
303     require(oldOwner != msg.sender);
304 
305     // Calculate pool cut for taxes.
306     uint256 priceDelta = price.sub(token.lastPrice);
307     uint256 poolCut = calculatePoolCut(priceDelta);
308     
309     _updatePools(token.kind, poolCut);
310     
311     uint256 fee = price.mul(feePercentage).div(100);
312     devOwed = devOwed.add(fee);
313 
314     // Dividends
315     uint256 taxesPaid = _payDividendsAndMayors(token, price);
316 
317     _shiftPreviousOwners(token, msg.sender);
318 
319     transferToken(oldOwner, msg.sender, _tokenId);
320 
321     // Transfer payment to old owner minus the developer's and pool's cut.
322     // Calculate the winnings for the previous owner.
323     uint256 finalPayout = price.sub(fee).sub(poolCut).sub(taxesPaid);
324 
325     // set new prices
326     token.lastPrice = price;
327     token.price = getNextPrice(price);
328 
329     // raise event
330     Purchased(_tokenId, msg.sender, price);
331 
332     if (oldOwner != address(this)) {
333       oldOwner.transfer(finalPayout);
334     }
335 
336     // Calculate overspending
337     uint256 excess = msg.value - price;
338     
339     if (excess > 0) {
340         // Refund overspending
341         msg.sender.transfer(excess);
342     }
343     
344     // set last purchase price to storage
345     lastPurchase = now;
346   }
347 
348     /// @dev Shift the 6 most recent buyers, and add the new buyer
349     /// to the front.
350     /// @param _newOwner The buyer to add to the front of the recent
351     /// buyers list.
352   function _shiftPreviousOwners(Token storage _token, address _newOwner) private {
353       _token.previousOwners[4] = _token.previousOwners[3];
354       _token.previousOwners[3] = _token.previousOwners[2];
355       _token.previousOwners[2] = _token.previousOwners[1];
356       _token.previousOwners[1] = _token.previousOwners[0];
357       _token.previousOwners[0] = _newOwner;
358   }
359 
360   function _updatePools(uint8 _kind, uint256 _poolCut) internal {
361     uint256 poolCutToMain = _poolCut.mul(cityPoolCutPercentage).div(100);
362 
363     if (_kind == CITY) {
364       cityPoolTotal += _poolCut;
365     } else if (_kind == LANDMARK) {
366       cityPoolTotal += poolCutToMain;
367 
368       landmarkPoolTotal += _poolCut.sub(poolCutToMain);
369     } else if (_kind == OTHER) {
370       cityPoolTotal += poolCutToMain;
371 
372       otherPoolTotal += _poolCut.sub(poolCutToMain);
373     }
374   }
375 
376   // 1%, 0.5%, 0.25%, 0.125%, 0.0625%
377   function _payDividendsAndMayors(Token _token, uint256 _price) private returns (uint256 paid) {
378     uint256 dividend0 = _price.mul(dividendCutPercentage).div(10000);
379     uint256 dividend1 = dividend0.div(dividendDecreaseFactor);
380     uint256 dividend2 = dividend1.div(dividendDecreaseFactor);
381     uint256 dividend3 = dividend2.div(dividendDecreaseFactor);
382     uint256 dividend4 = dividend3.div(dividendDecreaseFactor);
383 
384     // Pay first dividend.
385     if (_token.previousOwners[0] != address(this)) {_token.previousOwners[0].transfer(dividend0); paid = paid.add(dividend0);}
386     if (_token.previousOwners[1] != address(this)) {_token.previousOwners[1].transfer(dividend1); paid = paid.add(dividend1);}
387     if (_token.previousOwners[2] != address(this)) {_token.previousOwners[2].transfer(dividend2); paid = paid.add(dividend2);}
388     if (_token.previousOwners[3] != address(this)) {_token.previousOwners[3].transfer(dividend3); paid = paid.add(dividend3);}
389     if (_token.previousOwners[4] != address(this)) {_token.previousOwners[4].transfer(dividend4); paid = paid.add(dividend4);}
390 
391     uint256 tax = _price.mul(1).div(100);
392 
393     if (tokens[powermayorTokenId].owner != address(0)) {
394       tokens[powermayorTokenId].owner.transfer(tax);
395       paid = paid.add(tax);
396     }
397 
398     if (tokens[_token.mayorTokenId].owner != address(0)) { 
399       tokens[_token.mayorTokenId].owner.transfer(tax);
400       paid = paid.add(tax);
401     }
402   }
403 
404   /**
405   * @dev Transfer Token from Previous Owner to New Owner
406   * @param _from previous owner address
407   * @param _to new owner address
408   * @param _tokenId uint256 ID of token
409   */
410   function transferToken(address _from, address _to, uint256 _tokenId) internal {
411 
412     // check token exists
413     require(tokenExists(_tokenId));
414 
415     // make sure previous owner is correct
416     require(tokens[_tokenId].owner == _from);
417 
418     require(_to != address(0));
419     require(_to != address(this));
420 
421     // pay any unpaid payouts to previous owner of token
422     updateSinglePayout(_from, _tokenId);
423 
424     // clear approvals linked to this token
425     clearApproval(_from, _tokenId);
426 
427     // remove token from previous owner
428     removeToken(_from, _tokenId);
429 
430     // update owner and add token to new owner
431     tokens[_tokenId].owner = _to;
432     addToken(_to, _tokenId);
433 
434    //raise event
435     Transfer(_from, _to, _tokenId);
436   }
437 
438   /**
439   * @dev Withdraw dev's cut
440   */
441   function withdraw() onlyOwner public {
442     owner.transfer(devOwed);
443     devOwed = 0;
444   }
445 
446   /**
447   * @dev Updates the payout for the token the owner has
448   * @param _owner address of token owner
449   */
450   function updatePayout(address _owner) public {
451     uint256[] memory ownerTokens = ownedTokens[_owner];
452     uint256 owed;
453     for (uint256 i = 0; i < ownerTokens.length; i++) {
454         uint256 totalOwed;
455         
456         if (tokens[ownerTokens[i]].kind == CITY) {
457           totalOwed = cityPoolTotal * tokens[ownerTokens[i]].payout / 10000;
458         } else if (tokens[ownerTokens[i]].kind == LANDMARK) {
459           totalOwed = landmarkPoolTotal * tokens[ownerTokens[i]].payout / 10000;
460         } else if (tokens[ownerTokens[i]].kind == OTHER) {
461           totalOwed = otherPoolTotal * tokens[ownerTokens[i]].payout / 10000;
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
477    * @dev Update a single toekn payout for transfers.
478    * @param _owner Address of the owner of the token.
479    * @param _tokenId Unique Id of the token.
480   **/
481   function updateSinglePayout(address _owner, uint256 _tokenId) internal {
482     uint256 totalOwed;
483         
484     if (tokens[_tokenId].kind == CITY) {
485       totalOwed = cityPoolTotal * tokens[_tokenId].payout / 10000;
486     } else if (tokens[_tokenId].kind == LANDMARK) {
487       totalOwed = landmarkPoolTotal * tokens[_tokenId].payout / 10000;
488     } else if (tokens[_tokenId].kind == OTHER) {
489       totalOwed = otherPoolTotal * tokens[_tokenId].payout / 10000;
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
517   * @dev Return all token data
518   * @param _tokenId uint256 of token
519   */
520   function getToken (uint256 _tokenId) external view 
521   returns (address _owner, uint256 _price, uint256 _lastPrice, uint256 _nextPrice, uint256 _payout, uint8 _kind, uint256 _mayorTokenId, address[5] _previosOwners) 
522   {
523     Token memory token = tokens[_tokenId];
524     return (token.owner, token.price, token.lastPrice, getNextPrice(token.price), token.payout, token.kind, token.mayorTokenId, token.previousOwners);
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
546   * @param _buyer address of person buying token
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
726     return "CryptoMayor.io";
727   }
728 
729   function symbol() public pure returns (string _symbol) {
730     return "CMC";
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
744     cityPoolCutPercentage = _newFee;
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
771         uint256 _mayorTokenId;
772 
773         (_owner, _price, _lastPrice, _nextPrice, _payout, _kind, _mayorTokenId) = oldContract.getToken(_ids[i]);
774 
775         createToken(_ids[i], _price, _lastPrice, _payout, _kind, _mayorTokenId, _owner);
776       }
777     }
778   }
779 }
780 
781 interface OldContract {
782   function getToken (uint256 _tokenId) external view 
783   returns (address _owner, uint256 _price, uint256 _lastPrice, uint256 _nextPrice, uint256 _payout, uint8 _kind, uint256 _mayorTokenId);
784 }