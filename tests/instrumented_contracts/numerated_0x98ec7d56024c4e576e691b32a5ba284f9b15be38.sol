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
88 contract CountryToken {
89   function getCountryData (uint256 _tokenId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice, uint256 _payout);
90 }
91 
92 /**
93  * @title ERC721Token
94  * Generic implementation for the required functionality of the ERC721 standard
95  */
96 contract CityToken is ERC721, Ownable {
97   using SafeMath for uint256;
98 
99   address cAddress = 0x0c507D48C0cd1232B82aA950d487d01Cfc6442Db;
100   
101   CountryToken countryContract = CountryToken(cAddress);
102 
103   //CountryToken private countryContract;
104   uint32 constant COUNTRY_IDX = 100;
105   uint256 constant COUNTRY_PAYOUT = 15; // 15%
106 
107   // Total amount of tokens
108   uint256 private totalTokens;
109   uint256[] private listedCities;
110   uint256 public devOwed;
111   uint256 public poolTotal;
112   uint256 public lastPurchase;
113 
114   // City Data
115   mapping (uint256 => City) public cityData;
116 
117   // Mapping from token ID to owner
118   mapping (uint256 => address) private tokenOwner;
119 
120   // Mapping from token ID to approved address
121   mapping (uint256 => address) private tokenApprovals;
122 
123   // Mapping from owner to list of owned token IDs
124   mapping (address => uint256[]) private ownedTokens;
125 
126   // Mapping from token ID to index of the owner tokens list
127   mapping(uint256 => uint256) private ownedTokensIndex;
128 
129   // Balances from % payouts.
130   mapping (address => uint256) private payoutBalances; 
131 
132   // The amount of Eth this country has withdrawn from the pool.
133   mapping (uint256 => uint256) private countryWithdrawn;
134 
135   // Events
136   event CityPurchased(uint256 indexed _tokenId, address indexed _owner, uint256 _purchasePrice);
137 
138   // Purchasing Caps for Determining Next Pool Cut
139   uint256 private firstCap  = 0.12 ether;
140   uint256 private secondCap = 0.5 ether;
141   uint256 private thirdCap  = 1.5 ether;
142 
143   // Struct to store City Data
144   struct City {
145       uint256 price;         // Current price of the item.
146       uint256 lastPrice;     // lastPrice this was sold for, used for adding to pool.
147       uint256 payout;        // The percent of the pool rewarded.
148       uint256 withdrawn;     // The amount of Eth this city has withdrawn from the pool.
149       address owner;         // Current owner of the item.
150   }
151 
152   /**
153    * @param _tokenId uint256 ID of new token
154    * @param _payoutPercentage uint256 payout percentage (divisible by 10)
155    */
156    function createPromoListing(uint256 _tokenId, uint256 _startingPrice, uint256 _payoutPercentage) onlyOwner() public {
157      uint256 countryId = _tokenId % COUNTRY_IDX;
158      address countryOwner;
159      uint256 price;
160      (countryOwner,,price,,) = countryContract.getCountryData(countryId);
161      require (countryOwner != address(0));
162 
163      if (_startingPrice == 0) {
164        if (price >= thirdCap) _startingPrice = price.div(80);
165        else if (price >= secondCap) _startingPrice = price.div(75);
166        else _startingPrice = 0.002 ether;
167      }
168 
169      createListing(_tokenId, _startingPrice, _payoutPercentage, countryOwner);
170    }
171 
172   /**
173   * @dev createListing Adds new ERC721 Token
174   * @param _tokenId uint256 ID of new token
175   * @param _payoutPercentage uint256 payout percentage (divisible by 10)
176   * @param _owner address of new owner
177   */
178   function createListing(uint256 _tokenId, uint256 _startingPrice, uint256 _payoutPercentage, address _owner) onlyOwner() public {
179 
180     // make sure price > 0
181     require(_startingPrice > 0);
182     // make sure token hasn't been used yet
183     require(cityData[_tokenId].price == 0);
184     
185     // create new token
186     City storage newCity = cityData[_tokenId];
187 
188     newCity.owner = _owner;
189     newCity.price = _startingPrice;
190     newCity.lastPrice = 0;
191     newCity.payout = _payoutPercentage;
192 
193     // store city in storage
194     listedCities.push(_tokenId);
195     
196     // mint new token
197     _mint(_owner, _tokenId);
198   }
199 
200   function createMultiple (uint256[] _itemIds, uint256[] _prices, uint256[] _payouts, address _owner) onlyOwner() external {
201     for (uint256 i = 0; i < _itemIds.length; i++) {
202       createListing(_itemIds[i], _prices[i], _payouts[i], _owner);
203     }
204   }
205 
206   /**
207   * @dev Determines next price of token
208   * @param _price uint256 ID of current price
209   */
210   function getNextPrice (uint256 _price) private view returns (uint256 _nextPrice) {
211     if (_price < firstCap) {
212       return _price.mul(200).div(94);
213     } else if (_price < secondCap) {
214       return _price.mul(135).div(95);
215     } else if (_price < thirdCap) {
216       return _price.mul(118).div(96);
217     } else {
218       return _price.mul(115).div(97);
219     }
220   }
221 
222   function calculatePoolCut (uint256 _price) public view returns (uint256 _poolCut) {
223     if (_price < firstCap) {
224       return _price.mul(10).div(100); // 10%
225     } else if (_price < secondCap) {
226       return _price.mul(9).div(100); // 9%
227     } else if (_price < thirdCap) {
228       return _price.mul(8).div(100); // 8%
229     } else {
230       return _price.mul(7).div(100); // 7%
231     }
232   }
233 
234   /**
235   * @dev Purchase city from previous owner
236   * @param _tokenId uint256 of token
237   */
238   function purchaseCity(uint256 _tokenId) public 
239     payable
240     isNotContract(msg.sender)
241   {
242 
243     // get data from storage
244     City storage city = cityData[_tokenId];
245     uint256 price = city.price;
246     address oldOwner = city.owner;
247     address newOwner = msg.sender;
248 
249     // revert checks
250     require(price > 0);
251     require(msg.value >= price);
252     require(oldOwner != msg.sender);
253 
254     uint256 excess = msg.value.sub(price);
255 
256     // Calculate pool cut for taxes.
257     uint256 profit = price.sub(city.lastPrice);
258     uint256 poolCut = calculatePoolCut(profit);
259     poolTotal += poolCut;
260 
261     // 3% goes to developers
262     uint256 devCut = price.mul(3).div(100);
263     devOwed = devOwed.add(devCut);
264 
265     transferCity(oldOwner, newOwner, _tokenId);
266 
267     // set new prices
268     city.lastPrice = price;
269     city.price = getNextPrice(price);
270 
271     // raise event
272     CityPurchased(_tokenId, newOwner, price);
273 
274     // Transfer payment to old owner minus the developer's and pool's cut.
275     oldOwner.transfer(price.sub(devCut.add(poolCut)));
276 
277     // Transfer 10% profit to current country owner
278     uint256 countryId = _tokenId % COUNTRY_IDX;
279     address countryOwner;
280     (countryOwner,,,,) = countryContract.getCountryData(countryId);
281     require (countryOwner != address(0));
282     countryOwner.transfer(poolCut.mul(COUNTRY_PAYOUT).div(100));
283 
284     // Send refund to owner if needed
285     if (excess > 0) {
286       newOwner.transfer(excess);
287     }
288 
289     // set last purchase price to storage
290     lastPurchase = now;
291 
292   }
293 
294   /**
295   * @dev Transfer City from Previous Owner to New Owner
296   * @param _from previous owner address
297   * @param _to new owner address
298   * @param _tokenId uint256 ID of token
299   */
300   function transferCity(address _from, address _to, uint256 _tokenId) internal {
301 
302     // check token exists
303     require(tokenExists(_tokenId));
304 
305     // make sure previous owner is correct
306     require(cityData[_tokenId].owner == _from);
307 
308     require(_to != address(0));
309     require(_to != address(this));
310 
311     // pay any unpaid payouts to previous owner of city
312     updateSinglePayout(_from, _tokenId);
313 
314     // clear approvals linked to this token
315     clearApproval(_from, _tokenId);
316 
317     // remove token from previous owner
318     removeToken(_from, _tokenId);
319 
320     // update owner and add token to new owner
321     cityData[_tokenId].owner = _to;
322     addToken(_to, _tokenId);
323 
324    //raise event
325     Transfer(_from, _to, _tokenId);
326   }
327 
328   /**
329   * @dev Withdraw dev's cut
330   */
331   function withdraw() onlyOwner public {
332     owner.transfer(devOwed);
333     devOwed = 0;
334   }
335 
336   /**
337   * @dev Sets item's payout
338   * @param _itemId itemId to be changed
339   */
340   function setPayout(uint256 _itemId, uint256 _newPayout) onlyOwner public {
341     City storage city = cityData[_itemId];
342     city.payout = _newPayout;
343   }
344 
345   /**
346   * @dev Updates the payout for the cities the owner has
347   * @param _owner address of token owner
348   */
349   function updatePayout(address _owner) public {
350     uint256[] memory cities = ownedTokens[_owner];
351     uint256 owed;
352     for (uint256 i = 0; i < cities.length; i++) {
353         uint256 totalCityOwed = poolTotal * cityData[cities[i]].payout / 10000;
354         uint256 cityOwed = totalCityOwed.sub(cityData[cities[i]].withdrawn);
355         owed += cityOwed;
356         
357         cityData[cities[i]].withdrawn += cityOwed;
358     }
359     payoutBalances[_owner] += owed;
360   }
361 
362   /**
363    * @dev Update a single city payout for transfers.
364    * @param _owner Address of the owner of the city.
365    * @param _itemId Unique Id of the token.
366   **/
367   function updateSinglePayout(address _owner, uint256 _itemId) internal {
368     uint256 totalCityOwed = poolTotal * cityData[_itemId].payout / 10000;
369     uint256 cityOwed = totalCityOwed.sub(cityData[_itemId].withdrawn);
370         
371     cityData[_itemId].withdrawn += cityOwed;
372     payoutBalances[_owner] += cityOwed;
373   }
374 
375   /**
376   * @dev Owner can withdraw their accumulated payouts
377   * @param _owner address of token owner
378   */
379   function withdrawRent(address _owner) public {
380       updatePayout(_owner);
381       uint256 payout = payoutBalances[_owner];
382       payoutBalances[_owner] = 0;
383       _owner.transfer(payout);
384   }
385 
386   function getRentOwed(address _owner) public view returns (uint256 owed) {
387     updatePayout(_owner);
388     return payoutBalances[_owner];
389   }
390 
391   /**
392   * @dev Return all city data
393   * @param _tokenId uint256 of token
394   */
395   function getCityData (uint256 _tokenId) external view 
396   returns (address _owner, uint256 _price, uint256 _nextPrice, uint256 _payout, address _cOwner, uint256 _cPrice, uint256 _cPayout) 
397   {
398     City memory city = cityData[_tokenId];
399     address countryOwner;
400     uint256 countryPrice;
401     uint256 countryPayout;
402     (countryOwner,,countryPrice,,countryPayout) = countryContract.getCountryData(_tokenId % COUNTRY_IDX);
403     return (city.owner, city.price, getNextPrice(city.price), city.payout, countryOwner, countryPrice, countryPayout);
404   }
405 
406   /**
407   * @dev Determines if token exists by checking it's price
408   * @param _tokenId uint256 ID of token
409   */
410   function tokenExists (uint256 _tokenId) public view returns (bool _exists) {
411     return cityData[_tokenId].price > 0;
412   }
413 
414   /**
415   * @dev Guarantees msg.sender is owner of the given token
416   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
417   */
418   modifier onlyOwnerOf(uint256 _tokenId) {
419     require(ownerOf(_tokenId) == msg.sender);
420     _;
421   }
422 
423   /**
424   * @dev Guarantees msg.sender is not a contract
425   * @param _buyer address of person buying city
426   */
427   modifier isNotContract(address _buyer) {
428     uint size;
429     assembly { size := extcodesize(_buyer) }
430     require(size == 0);
431     _;
432   }
433 
434   /**
435   * @dev Gets the total amount of tokens stored by the contract
436   * @return uint256 representing the total amount of tokens
437   */
438   function totalSupply() public view returns (uint256) {
439     return totalTokens;
440   }
441 
442   /**
443   * @dev Gets the balance of the specified address
444   * @param _owner address to query the balance of
445   * @return uint256 representing the amount owned by the passed address
446   */
447   function balanceOf(address _owner) public view returns (uint256) {
448     return ownedTokens[_owner].length;
449   }
450 
451   /**
452   * @dev Gets the list of tokens owned by a given address
453   * @param _owner address to query the tokens of
454   * @return uint256[] representing the list of tokens owned by the passed address
455   */
456   function tokensOf(address _owner) public view returns (uint256[]) {
457     return ownedTokens[_owner];
458   }
459 
460   /**
461   * @dev Gets the owner of the specified token ID
462   * @param _tokenId uint256 ID of the token to query the owner of
463   * @return owner address currently marked as the owner of the given token ID
464   */
465   function ownerOf(uint256 _tokenId) public view returns (address) {
466     address owner = tokenOwner[_tokenId];
467     require(owner != address(0));
468     return owner;
469   }
470 
471   /**
472    * @dev Gets the approved address to take ownership of a given token ID
473    * @param _tokenId uint256 ID of the token to query the approval of
474    * @return address currently approved to take ownership of the given token ID
475    */
476   function approvedFor(uint256 _tokenId) public view returns (address) {
477     return tokenApprovals[_tokenId];
478   }
479 
480   /**
481   * @dev Transfers the ownership of a given token ID to another address
482   * @param _to address to receive the ownership of the given token ID
483   * @param _tokenId uint256 ID of the token to be transferred
484   */
485   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
486     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
487   }
488 
489   /**
490   * @dev Approves another address to claim for the ownership of the given token ID
491   * @param _to address to be approved for the given token ID
492   * @param _tokenId uint256 ID of the token to be approved
493   */
494   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
495     address owner = ownerOf(_tokenId);
496     require(_to != owner);
497     if (approvedFor(_tokenId) != 0 || _to != 0) {
498       tokenApprovals[_tokenId] = _to;
499       Approval(owner, _to, _tokenId);
500     }
501   }
502 
503   /**
504   * @dev Claims the ownership of a given token ID
505   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
506   */
507   function takeOwnership(uint256 _tokenId) public {
508     require(isApprovedFor(msg.sender, _tokenId));
509     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
510   }
511 
512   /**
513    * @dev Tells whether the msg.sender is approved for the given token ID or not
514    * This function is not private so it can be extended in further implementations like the operatable ERC721
515    * @param _owner address of the owner to query the approval of
516    * @param _tokenId uint256 ID of the token to query the approval of
517    * @return bool whether the msg.sender is approved for the given token ID or not
518    */
519   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
520     return approvedFor(_tokenId) == _owner;
521   }
522   
523   /**
524   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
525   * @param _from address which you want to send tokens from
526   * @param _to address which you want to transfer the token to
527   * @param _tokenId uint256 ID of the token to be transferred
528   */
529   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal isNotContract(_to) {
530     require(_to != address(0));
531     require(_to != ownerOf(_tokenId));
532     require(ownerOf(_tokenId) == _from);
533 
534     clearApproval(_from, _tokenId);
535     updateSinglePayout(_from, _tokenId);
536     removeToken(_from, _tokenId);
537     addToken(_to, _tokenId);
538     Transfer(_from, _to, _tokenId);
539   }
540 
541   /**
542   * @dev Internal function to clear current approval of a given token ID
543   * @param _tokenId uint256 ID of the token to be transferred
544   */
545   function clearApproval(address _owner, uint256 _tokenId) private {
546     require(ownerOf(_tokenId) == _owner);
547     tokenApprovals[_tokenId] = 0;
548     Approval(_owner, 0, _tokenId);
549   }
550 
551 
552     /**
553   * @dev Mint token function
554   * @param _to The address that will own the minted token
555   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
556   */
557   function _mint(address _to, uint256 _tokenId) internal {
558     require(_to != address(0));
559     addToken(_to, _tokenId);
560     Transfer(0x0, _to, _tokenId);
561   }
562 
563   /**
564   * @dev Internal function to add a token ID to the list of a given address
565   * @param _to address representing the new owner of the given token ID
566   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
567   */
568   function addToken(address _to, uint256 _tokenId) private {
569     require(tokenOwner[_tokenId] == address(0));
570     tokenOwner[_tokenId] = _to;
571     cityData[_tokenId].owner = _to;
572     uint256 length = balanceOf(_to);
573     ownedTokens[_to].push(_tokenId);
574     ownedTokensIndex[_tokenId] = length;
575     totalTokens = totalTokens.add(1);
576   }
577 
578   /**
579   * @dev Internal function to remove a token ID from the list of a given address
580   * @param _from address representing the previous owner of the given token ID
581   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
582   */
583   function removeToken(address _from, uint256 _tokenId) private {
584     require(ownerOf(_tokenId) == _from);
585 
586     uint256 tokenIndex = ownedTokensIndex[_tokenId];
587     uint256 lastTokenIndex = balanceOf(_from).sub(1);
588     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
589 
590     tokenOwner[_tokenId] = 0;
591     ownedTokens[_from][tokenIndex] = lastToken;
592     ownedTokens[_from][lastTokenIndex] = 0;
593     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
594     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
595     // the lastToken to the first position, and then dropping the element placed in the last position of the list
596 
597     ownedTokens[_from].length--;
598     ownedTokensIndex[_tokenId] = 0;
599     ownedTokensIndex[lastToken] = tokenIndex;
600     totalTokens = totalTokens.sub(1);
601   }
602 
603   function name() public pure returns (string _name) {
604     return "EtherCities.io City";
605   }
606 
607   function symbol() public pure returns (string _symbol) {
608     return "EC";
609   }
610 
611 }