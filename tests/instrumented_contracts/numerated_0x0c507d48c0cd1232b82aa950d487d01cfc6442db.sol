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
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   function Ownable() public {
33     owner = msg.sender;
34   }
35 
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) onlyOwner public {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 library SafeMath {
63   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68 
69   function div(uint256 a, uint256 b) internal constant returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75 
76   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80   
81   function add(uint256 a, uint256 b) internal constant returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 /**
89  * @title ERC721Token
90  * Generic implementation for the required functionality of the ERC721 standard
91  */
92 contract CountryToken is ERC721, Ownable {
93   using SafeMath for uint256;
94 
95   // Total amount of tokens
96   uint256 private totalTokens;
97   uint256[] private listedCountries;
98   uint256 public devOwed;
99   uint256 public poolTotal;
100   uint256 public lastPurchase;
101 
102   // Country Data
103   mapping (uint256 => Country) public countryData;
104 
105   // Mapping from token ID to owner
106   mapping (uint256 => address) private tokenOwner;
107 
108   // Mapping from token ID to approved address
109   mapping (uint256 => address) private tokenApprovals;
110 
111   // Mapping from owner to list of owned token IDs
112   mapping (address => uint256[]) private ownedTokens;
113 
114   // Mapping from token ID to index of the owner tokens list
115   mapping(uint256 => uint256) private ownedTokensIndex;
116 
117   // Balances from % payouts.
118   mapping (address => uint256) private payoutBalances; 
119 
120   // Events
121   event CountryPurchased(uint256 indexed _tokenId, address indexed _owner, uint256 _purchasePrice);
122 
123   // Purchasing Caps for Determining Next Pool Cut
124   uint256 private firstCap  = 0.5 ether;
125   uint256 private secondCap = 1.0 ether;
126   uint256 private thirdCap  = 3.0 ether;
127   uint256 private finalCap  = 5.0 ether;
128 
129   // Struct to store Country Data
130   struct Country {
131       uint256 startingPrice; // Price the item started at.
132       uint256 price;         // Current price of the item.
133       uint256 lastPrice;     // lastPrice this was sold for, used for adding to pool.
134       uint256 payout;        // The percent of the pool rewarded.
135       uint256 withdrawn;     // The amount of Eth this country has withdrawn from the pool.
136       address owner;         // Current owner of the item.
137   }
138 
139   /**
140   * @dev createListing Adds new ERC721 Token
141   * @param _tokenId uint256 ID of new token
142   * @param _startingPrice uint256 starting price in wei
143   * @param _payoutPercentage uint256 payout percentage (divisible by 10)
144   * @param _owner address of new owner
145   */
146   function createListing(uint256 _tokenId, uint256 _startingPrice, uint256 _payoutPercentage, address _owner) onlyOwner() public {
147 
148     // make sure price > 0
149     require(_startingPrice > 0);
150     // make sure token hasn't been used yet
151     require(countryData[_tokenId].price == 0);
152     
153     // create new token
154     Country storage newCountry = countryData[_tokenId];
155 
156     newCountry.owner = _owner;
157     newCountry.price = getNextPrice(_startingPrice);
158     newCountry.lastPrice = _startingPrice;
159     newCountry.payout = _payoutPercentage;
160     newCountry.startingPrice = _startingPrice;
161 
162     // store country in storage
163     listedCountries.push(_tokenId);
164     
165     // mint new token
166     _mint(_owner, _tokenId);
167   }
168 
169   function createMultiple (uint256[] _itemIds, uint256[] _prices, uint256[] _payouts, address[] _owners) onlyOwner() external {
170     for (uint256 i = 0; i < _itemIds.length; i++) {
171       createListing(_itemIds[i], _prices[i], _payouts[i], _owners[i]);
172     }
173   }
174 
175   /**
176   * @dev Determines next price of token
177   * @param _price uint256 ID of current price
178   */
179   function getNextPrice (uint256 _price) private view returns (uint256 _nextPrice) {
180     if (_price < firstCap) {
181       return _price.mul(200).div(95);
182     } else if (_price < secondCap) {
183       return _price.mul(135).div(96);
184     } else if (_price < thirdCap) {
185       return _price.mul(125).div(97);
186     } else if (_price < finalCap) {
187       return _price.mul(117).div(97);
188     } else {
189       return _price.mul(115).div(98);
190     }
191   }
192 
193   function calculatePoolCut (uint256 _price) public view returns (uint256 _poolCut) {
194     if (_price < firstCap) {
195       return _price.mul(10).div(100); // 5%
196     } else if (_price < secondCap) {
197       return _price.mul(9).div(100); // 4%
198     } else if (_price < thirdCap) {
199       return _price.mul(8).div(100); // 3%
200     } else if (_price < finalCap) {
201       return _price.mul(7).div(100); // 3%
202     } else {
203       return _price.mul(5).div(100); // 2%
204     }
205   }
206 
207   /**
208   * @dev Purchase country from previous owner
209   * @param _tokenId uint256 of token
210   */
211   function purchaseCountry(uint256 _tokenId) public 
212     payable
213     isNotContract(msg.sender)
214   {
215 
216     // get data from storage
217     Country storage country = countryData[_tokenId];
218     uint256 price = country.price;
219     address oldOwner = country.owner;
220     address newOwner = msg.sender;
221     uint256 excess = msg.value.sub(price);
222 
223     // revert checks
224     require(price > 0);
225     require(msg.value >= price);
226     require(oldOwner != msg.sender);
227 
228     // Calculate pool cut for taxes.
229     uint256 profit = price.sub(country.lastPrice);
230     uint256 poolCut = calculatePoolCut(profit);
231     poolTotal += poolCut;
232     
233     // 3% goes to developers
234     uint256 devCut = price.mul(3).div(100);
235     devOwed = devOwed.add(devCut);
236 
237     transferCountry(oldOwner, newOwner, _tokenId);
238 
239     // set new prices
240     country.lastPrice = price;
241     country.price = getNextPrice(price);
242 
243     // raise event
244     CountryPurchased(_tokenId, newOwner, price);
245 
246     // Transfer payment to old owner minus the developer's and pool's cut.
247     oldOwner.transfer(price.sub(devCut.add(poolCut)));
248 
249     // Send refund to owner if needed
250     if (excess > 0) {
251       newOwner.transfer(excess);
252     }
253     
254     // set last purchase price to storage
255     lastPurchase = now;
256 
257   }
258 
259   /**
260   * @dev Transfer Country from Previous Owner to New Owner
261   * @param _from previous owner address
262   * @param _to new owner address
263   * @param _tokenId uint256 ID of token
264   */
265   function transferCountry(address _from, address _to, uint256 _tokenId) internal {
266 
267     // check token exists
268     require(tokenExists(_tokenId));
269 
270     // make sure previous owner is correct
271     require(countryData[_tokenId].owner == _from);
272 
273     require(_to != address(0));
274     require(_to != address(this));
275 
276     // pay any unpaid payouts to previous owner of country
277     updateSinglePayout(_from, _tokenId);
278 
279     // clear approvals linked to this token
280     clearApproval(_from, _tokenId);
281 
282     // remove token from previous owner
283     removeToken(_from, _tokenId);
284 
285     // update owner and add token to new owner
286     countryData[_tokenId].owner = _to;
287     addToken(_to, _tokenId);
288 
289    //raise event
290     Transfer(_from, _to, _tokenId);
291   }
292 
293   /**
294   * @dev Withdraw dev's cut
295   */
296   function withdraw() onlyOwner public {
297     owner.transfer(devOwed);
298     devOwed = 0;
299   }
300 
301   /**
302   * @dev Updates the payout for the countrys the owner has
303   * @param _owner address of token owner
304   */
305   function updatePayout(address _owner) public {
306     uint256[] memory countrys = ownedTokens[_owner];
307     uint256 owed;
308     for (uint256 i = 0; i < countrys.length; i++) {
309         uint256 totalCountryOwed = poolTotal * countryData[countrys[i]].payout / 10000;
310         uint256 countryOwed = totalCountryOwed.sub(countryData[countrys[i]].withdrawn);
311         owed += countryOwed;
312         
313         countryData[countrys[i]].withdrawn += countryOwed;
314     }
315     payoutBalances[_owner] += owed;
316   }
317 
318   /**
319    * @dev Update a single country payout for transfers.
320    * @param _owner Address of the owner of the country.
321    * @param _itemId Unique Id of the token.
322   **/
323   function updateSinglePayout(address _owner, uint256 _itemId) internal {
324     uint256 totalCountryOwed = poolTotal * countryData[_itemId].payout / 10000;
325     uint256 countryOwed = totalCountryOwed.sub(countryData[_itemId].withdrawn);
326         
327     countryData[_itemId].withdrawn += countryOwed;
328     payoutBalances[_owner] += countryOwed;
329   }
330 
331   /**
332   * @dev Owner can withdraw their accumulated payouts
333   * @param _owner address of token owner
334   */
335   function withdrawRent(address _owner) public {
336       updatePayout(_owner);
337       uint256 payout = payoutBalances[_owner];
338       payoutBalances[_owner] = 0;
339       _owner.transfer(payout);
340   }
341 
342   function getRentOwed(address _owner) public view returns (uint256 owed) {
343     updatePayout(_owner);
344     return payoutBalances[_owner];
345   }
346 
347   /**
348   * @dev Return all country data
349   * @param _tokenId uint256 of token
350   */
351   function getCountryData (uint256 _tokenId) external view 
352   returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice, uint256 _payout) 
353   {
354     Country memory country = countryData[_tokenId];
355     return (country.owner, country.startingPrice, country.price, getNextPrice(country.price), country.payout);
356   }
357 
358   /**
359   * @dev Determines if token exists by checking it's price
360   * @param _tokenId uint256 ID of token
361   */
362   function tokenExists (uint256 _tokenId) public view returns (bool _exists) {
363     return countryData[_tokenId].price > 0;
364   }
365 
366   /**
367   * @dev Guarantees msg.sender is owner of the given token
368   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
369   */
370   modifier onlyOwnerOf(uint256 _tokenId) {
371     require(ownerOf(_tokenId) == msg.sender);
372     _;
373   }
374 
375   /**
376   * @dev Guarantees msg.sender is not a contract
377   * @param _buyer address of person buying country
378   */
379   modifier isNotContract(address _buyer) {
380     uint size;
381     assembly { size := extcodesize(_buyer) }
382     require(size == 0);
383     _;
384   }
385 
386 
387   /**
388   * @dev Gets the total amount of tokens stored by the contract
389   * @return uint256 representing the total amount of tokens
390   */
391   function totalSupply() public view returns (uint256) {
392     return totalTokens;
393   }
394 
395   /**
396   * @dev Gets the balance of the specified address
397   * @param _owner address to query the balance of
398   * @return uint256 representing the amount owned by the passed address
399   */
400   function balanceOf(address _owner) public view returns (uint256) {
401     return ownedTokens[_owner].length;
402   }
403 
404   /**
405   * @dev Gets the list of tokens owned by a given address
406   * @param _owner address to query the tokens of
407   * @return uint256[] representing the list of tokens owned by the passed address
408   */
409   function tokensOf(address _owner) public view returns (uint256[]) {
410     return ownedTokens[_owner];
411   }
412 
413   /**
414   * @dev Gets the owner of the specified token ID
415   * @param _tokenId uint256 ID of the token to query the owner of
416   * @return owner address currently marked as the owner of the given token ID
417   */
418   function ownerOf(uint256 _tokenId) public view returns (address) {
419     address owner = tokenOwner[_tokenId];
420     require(owner != address(0));
421     return owner;
422   }
423 
424   /**
425    * @dev Gets the approved address to take ownership of a given token ID
426    * @param _tokenId uint256 ID of the token to query the approval of
427    * @return address currently approved to take ownership of the given token ID
428    */
429   function approvedFor(uint256 _tokenId) public view returns (address) {
430     return tokenApprovals[_tokenId];
431   }
432 
433   /**
434   * @dev Transfers the ownership of a given token ID to another address
435   * @param _to address to receive the ownership of the given token ID
436   * @param _tokenId uint256 ID of the token to be transferred
437   */
438   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
439     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
440   }
441 
442   /**
443   * @dev Approves another address to claim for the ownership of the given token ID
444   * @param _to address to be approved for the given token ID
445   * @param _tokenId uint256 ID of the token to be approved
446   */
447   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
448     address owner = ownerOf(_tokenId);
449     require(_to != owner);
450     if (approvedFor(_tokenId) != 0 || _to != 0) {
451       tokenApprovals[_tokenId] = _to;
452       Approval(owner, _to, _tokenId);
453     }
454   }
455 
456   /**
457   * @dev Claims the ownership of a given token ID
458   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
459   */
460   function takeOwnership(uint256 _tokenId) public {
461     require(isApprovedFor(msg.sender, _tokenId));
462     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
463   }
464 
465   /**
466    * @dev Tells whether the msg.sender is approved for the given token ID or not
467    * This function is not private so it can be extended in further implementations like the operatable ERC721
468    * @param _owner address of the owner to query the approval of
469    * @param _tokenId uint256 ID of the token to query the approval of
470    * @return bool whether the msg.sender is approved for the given token ID or not
471    */
472   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
473     return approvedFor(_tokenId) == _owner;
474   }
475   
476   /**
477   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
478   * @param _from address which you want to send tokens from
479   * @param _to address which you want to transfer the token to
480   * @param _tokenId uint256 ID of the token to be transferred
481   */
482   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal isNotContract(_to) {
483     require(_to != address(0));
484     require(_to != ownerOf(_tokenId));
485     require(ownerOf(_tokenId) == _from);
486 
487     clearApproval(_from, _tokenId);
488     updateSinglePayout(_from, _tokenId);
489     removeToken(_from, _tokenId);
490     addToken(_to, _tokenId);
491     Transfer(_from, _to, _tokenId);
492   }
493 
494   /**
495   * @dev Internal function to clear current approval of a given token ID
496   * @param _tokenId uint256 ID of the token to be transferred
497   */
498   function clearApproval(address _owner, uint256 _tokenId) private {
499     require(ownerOf(_tokenId) == _owner);
500     tokenApprovals[_tokenId] = 0;
501     Approval(_owner, 0, _tokenId);
502   }
503 
504 
505     /**
506   * @dev Mint token function
507   * @param _to The address that will own the minted token
508   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
509   */
510   function _mint(address _to, uint256 _tokenId) internal {
511     require(_to != address(0));
512     addToken(_to, _tokenId);
513     Transfer(0x0, _to, _tokenId);
514   }
515 
516   /**
517   * @dev Internal function to add a token ID to the list of a given address
518   * @param _to address representing the new owner of the given token ID
519   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
520   */
521   function addToken(address _to, uint256 _tokenId) private {
522     require(tokenOwner[_tokenId] == address(0));
523     tokenOwner[_tokenId] = _to;
524     countryData[_tokenId].owner = _to;
525     uint256 length = balanceOf(_to);
526     ownedTokens[_to].push(_tokenId);
527     ownedTokensIndex[_tokenId] = length;
528     totalTokens = totalTokens.add(1);
529   }
530 
531   /**
532   * @dev Internal function to remove a token ID from the list of a given address
533   * @param _from address representing the previous owner of the given token ID
534   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
535   */
536   function removeToken(address _from, uint256 _tokenId) private {
537     require(ownerOf(_tokenId) == _from);
538 
539     uint256 tokenIndex = ownedTokensIndex[_tokenId];
540     uint256 lastTokenIndex = balanceOf(_from).sub(1);
541     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
542 
543     tokenOwner[_tokenId] = 0;
544     ownedTokens[_from][tokenIndex] = lastToken;
545     ownedTokens[_from][lastTokenIndex] = 0;
546     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
547     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
548     // the lastToken to the first position, and then dropping the element placed in the last position of the list
549 
550     ownedTokens[_from].length--;
551     ownedTokensIndex[_tokenId] = 0;
552     ownedTokensIndex[lastToken] = tokenIndex;
553     totalTokens = totalTokens.sub(1);
554   }
555 
556   function name() public pure returns (string _name) {
557     return "EtherCountries.io Country";
558   }
559 
560   function symbol() public pure returns (string _symbol) {
561     return "EC";
562   }
563 
564 }