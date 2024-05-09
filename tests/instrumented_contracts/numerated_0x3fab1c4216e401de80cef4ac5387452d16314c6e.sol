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
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a * b;
67     assert(a == 0 || c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal constant returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82   
83   function add(uint256 a, uint256 b) internal constant returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 /**
91  * @title ERC721Token
92  * Generic implementation for the required functionality of the ERC721 standard
93  */
94 contract BurritoToken is ERC721, Ownable {
95   using SafeMath for uint256;
96 
97   // Total amount of tokens
98   uint256 private totalTokens;
99   uint256[] private listed;
100   uint256 public devOwed;
101   uint256 public poolTotal;
102   uint256 public lastPurchase;
103 
104   // Burrito Data
105   mapping (uint256 => Burrito) public burritoData;
106 
107   // Mapping from token ID to owner
108   mapping (uint256 => address) private tokenOwner;
109 
110   // Mapping from token ID to approved address
111   mapping (uint256 => address) private tokenApprovals;
112 
113   // Mapping from owner to list of owned token IDs
114   mapping (address => uint256[]) private ownedTokens;
115 
116   // Mapping from token ID to index of the owner tokens list
117   mapping(uint256 => uint256) private ownedTokensIndex;
118 
119   // Balances from % payouts.
120   mapping (address => uint256) private payoutBalances; 
121 
122   // Events
123   event BurritoPurchased(uint256 indexed _tokenId, address indexed _owner, uint256 _purchasePrice);
124 
125   // Purchasing Caps for Determining Next Pool Cut
126   uint256 private firstCap  = 0.5 ether;
127   uint256 private secondCap = 1.0 ether;
128   uint256 private thirdCap  = 3.0 ether;
129   uint256 private finalCap  = 5.0 ether;
130 
131   // Dev
132   uint256 public devCutPercentage = 4;
133 
134   // Struct to store Burrito Data
135   struct Burrito {
136       uint256 startingPrice; // Price the item started at.
137       uint256 price;         // Current price of the item.
138       uint256 lastPrice;     // lastPrice this was sold for, used for adding to pool.
139       uint256 payout;        // The percent of the pool rewarded.
140       uint256 withdrawn;     // The amount of Eth this burrito has withdrawn from the pool.
141       address owner;         // Current owner of the item.
142   }
143 
144   /**
145   * @dev createListing Adds new ERC721 Token
146   * @param _tokenId uint256 ID of new token
147   * @param _startingPrice uint256 starting price in wei
148   * @param _payoutPercentage uint256 payout percentage (divisible by 10)
149   * @param _owner address of new owner
150   */
151   function createListing(uint256 _tokenId, uint256 _startingPrice, uint256 _payoutPercentage, address _owner) onlyOwner() public {
152 
153     // make sure price > 0
154     require(_startingPrice > 0);
155     // make sure token hasn't been used yet
156     require(burritoData[_tokenId].price == 0);
157     
158     // create new token
159     Burrito storage newBurrito = burritoData[_tokenId];
160 
161     newBurrito.owner = _owner;
162     newBurrito.price = getNextPrice(_startingPrice);
163     newBurrito.lastPrice = _startingPrice;
164     newBurrito.payout = _payoutPercentage;
165     newBurrito.startingPrice = _startingPrice;
166 
167     // store burrito in storage
168     listed.push(_tokenId);
169     
170     // mint new token
171     _mint(_owner, _tokenId);
172   }
173 
174   function createMultiple (uint256[] _itemIds, uint256[] _prices, uint256[] _payouts, address[] _owners) onlyOwner() external {
175     for (uint256 i = 0; i < _itemIds.length; i++) {
176       createListing(_itemIds[i], _prices[i], _payouts[i], _owners[i]);
177     }
178   }
179 
180   /**
181   * @dev Determines next price of token
182   * @param _price uint256 ID of current price
183   */
184   function getNextPrice (uint256 _price) private view returns (uint256 _nextPrice) {
185     if (_price < firstCap) {
186       return _price.mul(200).div(95);
187     } else if (_price < secondCap) {
188       return _price.mul(135).div(96);
189     } else if (_price < thirdCap) {
190       return _price.mul(125).div(97);
191     } else if (_price < finalCap) {
192       return _price.mul(117).div(97);
193     } else {
194       return _price.mul(115).div(98);
195     }
196   }
197 
198   function calculatePoolCut (uint256 _price) public view returns (uint256 _poolCut) {
199     if (_price < firstCap) {
200       return _price.mul(10).div(100); // 5%
201     } else if (_price < secondCap) {
202       return _price.mul(9).div(100); // 4%
203     } else if (_price < thirdCap) {
204       return _price.mul(8).div(100); // 3%
205     } else if (_price < finalCap) {
206       return _price.mul(7).div(100); // 3%
207     } else {
208       return _price.mul(5).div(100); // 2%
209     }
210   }
211 
212   /**
213   * @dev Purchase burrito from previous owner
214   * @param _tokenId uint256 of token
215   */
216   function purchase(uint256 _tokenId) public 
217     payable
218     isNotContract(msg.sender)
219   {
220 
221     // get data from storage
222     Burrito storage burrito = burritoData[_tokenId];
223     uint256 price = burrito.price;
224     address oldOwner = burrito.owner;
225     address newOwner = msg.sender;
226     uint256 excess = msg.value.sub(price);
227 
228     // revert checks
229     require(price > 0);
230     require(msg.value >= price);
231     require(oldOwner != msg.sender);
232 
233     // Calculate pool cut for taxes.
234     uint256 profit = price.sub(burrito.lastPrice);
235     uint256 poolCut = calculatePoolCut(profit);
236     poolTotal += poolCut;
237     
238     // % goes to developers
239     uint256 devCut = price.mul(devCutPercentage).div(100);
240     devOwed = devOwed.add(devCut);
241 
242     transferBurrito(oldOwner, newOwner, _tokenId);
243 
244     // set new prices
245     burrito.lastPrice = price;
246     burrito.price = getNextPrice(price);
247 
248     // raise event
249     BurritoPurchased(_tokenId, newOwner, price);
250 
251     // Transfer payment to old owner minus the developer's and pool's cut.
252     oldOwner.transfer(price.sub(devCut.add(poolCut)));
253 
254     // Send refund to owner if needed
255     if (excess > 0) {
256       newOwner.transfer(excess);
257     }
258     
259     // set last purchase price to storage
260     lastPurchase = now;
261 
262   }
263 
264   /**
265   * @dev Transfer Burrito from Previous Owner to New Owner
266   * @param _from previous owner address
267   * @param _to new owner address
268   * @param _tokenId uint256 ID of token
269   */
270   function transferBurrito(address _from, address _to, uint256 _tokenId) internal {
271 
272     // check token exists
273     require(tokenExists(_tokenId));
274 
275     // make sure previous owner is correct
276     require(burritoData[_tokenId].owner == _from);
277 
278     require(_to != address(0));
279     require(_to != address(this));
280 
281     // pay any unpaid payouts to previous owner of burrito
282     updateSinglePayout(_from, _tokenId);
283 
284     // clear approvals linked to this token
285     clearApproval(_from, _tokenId);
286 
287     // remove token from previous owner
288     removeToken(_from, _tokenId);
289 
290     // update owner and add token to new owner
291     burritoData[_tokenId].owner = _to;
292     addToken(_to, _tokenId);
293 
294    //raise event
295     Transfer(_from, _to, _tokenId);
296   }
297 
298   /**
299   * @dev Withdraw dev's cut
300   */
301   function withdraw() onlyOwner public {
302     owner.transfer(devOwed);
303     devOwed = 0;
304   }
305 
306   /**
307   * @dev Updates the payout for the burritos the owner has
308   * @param _owner address of token owner
309   */
310   function updatePayout(address _owner) public {
311     uint256[] memory burritos = ownedTokens[_owner];
312     uint256 owed;
313     for (uint256 i = 0; i < burritos.length; i++) {
314         uint256 totalBurritoOwed = poolTotal * burritoData[burritos[i]].payout / 10000;
315         uint256 burritoOwed = totalBurritoOwed.sub(burritoData[burritos[i]].withdrawn);
316         owed += burritoOwed;
317         
318         burritoData[burritos[i]].withdrawn += burritoOwed;
319     }
320     payoutBalances[_owner] += owed;
321   }
322 
323   /**
324    * @dev Update a single burrito payout for transfers.
325    * @param _owner Address of the owner of the burrito.
326    * @param _itemId Unique Id of the token.
327   **/
328   function updateSinglePayout(address _owner, uint256 _itemId) internal {
329     uint256 totalBurritoOwed = poolTotal * burritoData[_itemId].payout / 10000;
330     uint256 burritoOwed = totalBurritoOwed.sub(burritoData[_itemId].withdrawn);
331         
332     burritoData[_itemId].withdrawn += burritoOwed;
333     payoutBalances[_owner] += burritoOwed;
334   }
335 
336   /**
337   * @dev Owner can withdraw their accumulated payouts
338   * @param _owner address of token owner
339   */
340   function withdrawRent(address _owner) public {
341       updatePayout(_owner);
342       uint256 payout = payoutBalances[_owner];
343       payoutBalances[_owner] = 0;
344       _owner.transfer(payout);
345   }
346 
347   function getRentOwed(address _owner) public view returns (uint256 owed) {
348     updatePayout(_owner);
349     return payoutBalances[_owner];
350   }
351 
352   /**
353   * @dev Return all burrito data
354   * @param _tokenId uint256 of token
355   */
356   function getBurritoData (uint256 _tokenId) external view 
357   returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice, uint256 _payout) 
358   {
359     Burrito memory burrito = burritoData[_tokenId];
360     return (burrito.owner, burrito.startingPrice, burrito.price, getNextPrice(burrito.price), burrito.payout);
361   }
362 
363   /**
364   * @dev Determines if token exists by checking it's price
365   * @param _tokenId uint256 ID of token
366   */
367   function tokenExists (uint256 _tokenId) public view returns (bool _exists) {
368     return burritoData[_tokenId].price > 0;
369   }
370 
371   /**
372   * @dev Guarantees msg.sender is owner of the given token
373   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
374   */
375   modifier onlyOwnerOf(uint256 _tokenId) {
376     require(ownerOf(_tokenId) == msg.sender);
377     _;
378   }
379 
380   /**
381   * @dev Guarantees msg.sender is not a contract
382   * @param _buyer address of person buying burrito
383   */
384   modifier isNotContract(address _buyer) {
385     uint size;
386     assembly { size := extcodesize(_buyer) }
387     require(size == 0);
388     _;
389   }
390 
391 
392   /**
393   * @dev Gets the total amount of tokens stored by the contract
394   * @return uint256 representing the total amount of tokens
395   */
396   function totalSupply() public view returns (uint256) {
397     return totalTokens;
398   }
399 
400   /**
401   * @dev Gets the balance of the specified address
402   * @param _owner address to query the balance of
403   * @return uint256 representing the amount owned by the passed address
404   */
405   function balanceOf(address _owner) public view returns (uint256) {
406     return ownedTokens[_owner].length;
407   }
408 
409   /**
410   * @dev Gets the list of tokens owned by a given address
411   * @param _owner address to query the tokens of
412   * @return uint256[] representing the list of tokens owned by the passed address
413   */
414   function tokensOf(address _owner) public view returns (uint256[]) {
415     return ownedTokens[_owner];
416   }
417 
418   /**
419   * @dev Gets the owner of the specified token ID
420   * @param _tokenId uint256 ID of the token to query the owner of
421   * @return owner address currently marked as the owner of the given token ID
422   */
423   function ownerOf(uint256 _tokenId) public view returns (address) {
424     address owner = tokenOwner[_tokenId];
425     require(owner != address(0));
426     return owner;
427   }
428 
429   /**
430    * @dev Gets the approved address to take ownership of a given token ID
431    * @param _tokenId uint256 ID of the token to query the approval of
432    * @return address currently approved to take ownership of the given token ID
433    */
434   function approvedFor(uint256 _tokenId) public view returns (address) {
435     return tokenApprovals[_tokenId];
436   }
437 
438   /**
439   * @dev Transfers the ownership of a given token ID to another address
440   * @param _to address to receive the ownership of the given token ID
441   * @param _tokenId uint256 ID of the token to be transferred
442   */
443   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
444     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
445   }
446 
447   /**
448   * @dev Approves another address to claim for the ownership of the given token ID
449   * @param _to address to be approved for the given token ID
450   * @param _tokenId uint256 ID of the token to be approved
451   */
452   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
453     address owner = ownerOf(_tokenId);
454     require(_to != owner);
455     if (approvedFor(_tokenId) != 0 || _to != 0) {
456       tokenApprovals[_tokenId] = _to;
457       Approval(owner, _to, _tokenId);
458     }
459   }
460 
461   /**
462   * @dev Claims the ownership of a given token ID
463   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
464   */
465   function takeOwnership(uint256 _tokenId) public {
466     require(isApprovedFor(msg.sender, _tokenId));
467     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
468   }
469 
470   /**
471    * @dev Tells whether the msg.sender is approved for the given token ID or not
472    * This function is not private so it can be extended in further implementations like the operatable ERC721
473    * @param _owner address of the owner to query the approval of
474    * @param _tokenId uint256 ID of the token to query the approval of
475    * @return bool whether the msg.sender is approved for the given token ID or not
476    */
477   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
478     return approvedFor(_tokenId) == _owner;
479   }
480   
481   /**
482   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
483   * @param _from address which you want to send tokens from
484   * @param _to address which you want to transfer the token to
485   * @param _tokenId uint256 ID of the token to be transferred
486   */
487   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal isNotContract(_to) {
488     require(_to != address(0));
489     require(_to != ownerOf(_tokenId));
490     require(ownerOf(_tokenId) == _from);
491 
492     clearApproval(_from, _tokenId);
493     updateSinglePayout(_from, _tokenId);
494     removeToken(_from, _tokenId);
495     addToken(_to, _tokenId);
496     Transfer(_from, _to, _tokenId);
497   }
498 
499   /**
500   * @dev Internal function to clear current approval of a given token ID
501   * @param _tokenId uint256 ID of the token to be transferred
502   */
503   function clearApproval(address _owner, uint256 _tokenId) private {
504     require(ownerOf(_tokenId) == _owner);
505     tokenApprovals[_tokenId] = 0;
506     Approval(_owner, 0, _tokenId);
507   }
508 
509 
510     /**
511   * @dev Mint token function
512   * @param _to The address that will own the minted token
513   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
514   */
515   function _mint(address _to, uint256 _tokenId) internal {
516     require(_to != address(0));
517     addToken(_to, _tokenId);
518     Transfer(0x0, _to, _tokenId);
519   }
520 
521   /**
522   * @dev Internal function to add a token ID to the list of a given address
523   * @param _to address representing the new owner of the given token ID
524   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
525   */
526   function addToken(address _to, uint256 _tokenId) private {
527     require(tokenOwner[_tokenId] == address(0));
528     tokenOwner[_tokenId] = _to;
529     burritoData[_tokenId].owner = _to;
530     uint256 length = balanceOf(_to);
531     ownedTokens[_to].push(_tokenId);
532     ownedTokensIndex[_tokenId] = length;
533     totalTokens = totalTokens.add(1);
534   }
535 
536   /**
537   * @dev Internal function to remove a token ID from the list of a given address
538   * @param _from address representing the previous owner of the given token ID
539   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
540   */
541   function removeToken(address _from, uint256 _tokenId) private {
542     require(ownerOf(_tokenId) == _from);
543 
544     uint256 tokenIndex = ownedTokensIndex[_tokenId];
545     uint256 lastTokenIndex = balanceOf(_from).sub(1);
546     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
547 
548     tokenOwner[_tokenId] = 0;
549     ownedTokens[_from][tokenIndex] = lastToken;
550     ownedTokens[_from][lastTokenIndex] = 0;
551     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
552     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
553     // the lastToken to the first position, and then dropping the element placed in the last position of the list
554 
555     ownedTokens[_from].length--;
556     ownedTokensIndex[_tokenId] = 0;
557     ownedTokensIndex[lastToken] = tokenIndex;
558     totalTokens = totalTokens.sub(1);
559   }
560 
561   function name() public pure returns (string _name) {
562     return "CryptoBurrito.co Burrito";
563   }
564 
565   function symbol() public pure returns (string _symbol) {
566     return "BURRITO";
567   }
568 
569   function setDevCutPercentage(uint256 _newCut) onlyOwner public {
570     require(_newCut <= 6);
571     require(_newCut >= 3);
572 
573     devCutPercentage = _newCut;
574   }
575 }