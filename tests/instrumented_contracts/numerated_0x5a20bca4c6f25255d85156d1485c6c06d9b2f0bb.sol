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
65   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a * b;
67     assert(a == 0 || c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal pure returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82   
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
94 contract CryptoColors is ERC721, Ownable {
95   using SafeMath for uint256;
96 
97   // Total amount of tokens
98   uint256 private totalTokens;
99   uint256[] private listedCryptoColors;
100   uint256 public devOwed;
101   uint256 public poolTotal;
102   uint256 public lastPurchase;
103 
104   // CryptoColor Data
105   mapping (uint256 => CryptoColor) public cryptoColorData;
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
123   event TokenSold(uint256 indexed _tokenId, address indexed _owner, uint256 _purchasePrice, uint256 _price, address indexed _prevOwner);
124 
125   // Purchasing Caps for Determining Next Pool Cut
126   uint256 private firstCap  = 0.5 ether;
127   uint256 private secondCap = 1.0 ether;
128   uint256 private thirdCap  = 3.0 ether;
129   uint256 private finalCap  = 5.0 ether;
130 
131   // Struct to store CryptoColor Data
132   struct CryptoColor {
133       uint256 startingPrice; // Price the item started at.
134       uint256 price;         // Current price of the item.
135       uint256 lastPrice;     // lastPrice this was sold for, used for adding to pool.
136       uint256 payout;        // The percent of the pool rewarded.
137       uint256 withdrawn;     // The amount of Eth this CryptoColor has withdrawn from the pool.
138       address owner;         // Current owner of the item.
139   }
140 
141   /**
142   * @dev createContractToken Adds new ERC721 Token
143   * @param _tokenId uint256 ID of new token
144   * @param _startingPrice uint256 starting price in wei
145   * @param _payoutPercentage uint256 payout percentage (divisible by 10)
146   * @param _owner address of new owner
147   */
148   function createContractToken(uint256 _tokenId, uint256 _startingPrice, uint256 _payoutPercentage, address _owner) onlyOwner() public {
149 
150     // make sure price > 0
151     require(_startingPrice > 0);
152     // make sure token hasn't been used yet
153     require(cryptoColorData[_tokenId].price == 0);
154     
155     // create new token
156     CryptoColor storage newCryptoColor = cryptoColorData[_tokenId];
157 
158     newCryptoColor.owner = _owner;
159     newCryptoColor.price = getNextPrice(_startingPrice);
160     newCryptoColor.lastPrice = _startingPrice;
161     newCryptoColor.payout = _payoutPercentage;
162     newCryptoColor.startingPrice = _startingPrice;
163 
164     // store cryptoColor in storage
165     listedCryptoColors.push(_tokenId);
166     
167     // mint new token
168     _mint(_owner, _tokenId);
169   }
170 
171   function createMultiple (uint256[] _itemIds, uint256[] _prices, uint256[] _payouts, address[] _owners) onlyOwner() external {
172     for (uint256 i = 0; i < _itemIds.length; i++) {
173       createContractToken(_itemIds[i], _prices[i], _payouts[i], _owners[i]);
174     }
175   }
176 
177   /**
178   * @dev Determines next price of token
179   * @param _price uint256 ID of current price
180   */
181   function getNextPrice (uint256 _price) private view returns (uint256 _nextPrice) {
182     if (_price < firstCap) {
183       return _price.mul(200).div(100);
184     } else if (_price < secondCap) {
185       return _price.mul(135).div(100);
186     } else if (_price < thirdCap) {
187       return _price.mul(125).div(100);
188     } else if (_price < finalCap) {
189       return _price.mul(117).div(100);
190     } else {
191       return _price.mul(115).div(100);
192     }
193   }
194 
195   function calculatePoolCut (uint256 _price) public view returns (uint256 _poolCut) {
196     if (_price < firstCap) {
197       return _price.mul(10).div(100); // 5%
198     } else if (_price < secondCap) {
199       return _price.mul(9).div(100); // 4%
200     } else if (_price < thirdCap) {
201       return _price.mul(8).div(100); // 3%
202     } else if (_price < finalCap) {
203       return _price.mul(7).div(100); // 3%
204     } else {
205       return _price.mul(5).div(100); // 2%
206     }
207   }
208 
209   /**
210   * @dev Purchase CryptoColor from previous owner
211   * @param _tokenId uint256 of token
212   */
213   function purchase(uint256 _tokenId) public 
214     payable
215     isNotContract(msg.sender)
216   {
217 
218     // get data from storage
219     CryptoColor storage cryptoColor = cryptoColorData[_tokenId];
220     uint256 price = cryptoColor.price;
221     address oldOwner = cryptoColor.owner;
222     address newOwner = msg.sender;
223     uint256 excess = msg.value.sub(price);
224 
225     // revert checks
226     require(price > 0);
227     require(msg.value >= price);
228     require(oldOwner != msg.sender);
229 
230     // Calculate pool cut for dividents.
231     uint256 profit = price.sub(cryptoColor.lastPrice);
232     uint256 poolCut = calculatePoolCut(profit);
233     poolTotal += poolCut;
234     
235     //% goes to developers
236     uint256 devCut = price.mul(5).div(100);
237     devOwed = devOwed.add(devCut);
238 
239     transfer(oldOwner, newOwner, _tokenId);
240 
241     // set new prices
242     cryptoColor.lastPrice = price;
243     cryptoColor.price = getNextPrice(price);
244 
245     // raise event
246     TokenSold(_tokenId, newOwner, price, cryptoColor.price, oldOwner);
247 
248     // Transfer payment to old owner minus the developer's and pool's cut.
249     oldOwner.transfer(price.sub(devCut.add(poolCut)));
250 
251     // Send refund to owner if needed
252     if (excess > 0) {
253       newOwner.transfer(excess);
254     }
255     
256     // Set last purchase price to storage
257     lastPurchase = now;
258 
259   }
260 
261   /**
262   * @dev Transfer CryptoColor from Previous Owner to New Owner
263   * @param _from previous owner address
264   * @param _to new owner address
265   * @param _tokenId uint256 ID of token
266   */
267   function transfer(address _from, address _to, uint256 _tokenId) internal {
268 
269     // check token exists
270     require(tokenExists(_tokenId));
271 
272     // make sure previous owner is correct
273     require(cryptoColorData[_tokenId].owner == _from);
274 
275     require(_to != address(0));
276     require(_to != address(this));
277 
278     // pay any unpaid payouts to previous owner of cryptoColor
279     updateSinglePayout(_from, _tokenId);
280 
281     // clear approvals linked to this token
282     clearApproval(_from, _tokenId);
283 
284     // remove token from previous owner
285     removeToken(_from, _tokenId);
286 
287     // update owner and add token to new owner
288     cryptoColorData[_tokenId].owner = _to;
289     addToken(_to, _tokenId);
290 
291    //raise event
292     Transfer(_from, _to, _tokenId);
293   }
294 
295   /**
296   * @dev Withdraw dev's cut
297   */
298   function withdraw() onlyOwner public {
299     owner.transfer(devOwed);
300     devOwed = 0;
301   }
302 
303   /**
304   * @dev Updates the payout for the cryptoColors the owner has
305   * @param _owner address of token owner
306   */
307   function updatePayout(address _owner) public {
308     uint256[] memory cryptoColors = ownedTokens[_owner];
309     uint256 owed;
310     for (uint256 i = 0; i < cryptoColors.length; i++) {
311         uint256 totalcryptoColorOwed = poolTotal * cryptoColorData[cryptoColors[i]].payout / 10000;
312         uint256 cryptoColorOwed = totalcryptoColorOwed.sub(cryptoColorData[cryptoColors[i]].withdrawn);
313         owed += cryptoColorOwed;
314         
315         cryptoColorData[cryptoColors[i]].withdrawn += cryptoColorOwed;
316     }
317     payoutBalances[_owner] += owed;
318   }
319 
320   /**
321    * @dev Update a single cryptoColor payout for transfers.
322    * @param _owner Address of the owner of the cryptoColor.
323    * @param _itemId Unique Id of the token.
324   **/
325   function updateSinglePayout(address _owner, uint256 _itemId) internal {
326     uint256 totalcryptoColorOwed = poolTotal * cryptoColorData[_itemId].payout / 10000;
327     uint256 cryptoColorOwed = totalcryptoColorOwed.sub(cryptoColorData[_itemId].withdrawn);
328         
329     cryptoColorData[_itemId].withdrawn += cryptoColorOwed;
330     payoutBalances[_owner] += cryptoColorOwed;
331   }
332 
333   /**
334   * @dev Owner can withdraw their accumulated payouts
335   * @param _owner address of token owner
336   */
337   function withdrawRent(address _owner) public payable {
338       updatePayout(_owner);
339       uint256 payout = payoutBalances[_owner];
340       payoutBalances[_owner] = 0;
341       _owner.transfer(payout);
342   }
343 
344   function getRentOwed(address _owner) public view returns (uint256 owed) {
345     updatePayout(_owner);
346     return payoutBalances[_owner];
347   }
348 
349   /**
350   * @dev Return all cryptoColor data
351   * @param _tokenId uint256 of token
352   */
353   function getToken (uint256 _tokenId) external view 
354   returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice, uint256 _payout, uint256 _id) 
355   {
356     CryptoColor memory cryptoColor = cryptoColorData[_tokenId];
357     return (cryptoColor.owner, cryptoColor.startingPrice, cryptoColor.price, getNextPrice(cryptoColor.price), cryptoColor.payout, _tokenId);
358   }
359 
360   /**
361   * @dev Determines if token exists by checking it's price
362   * @param _tokenId uint256 ID of token
363   */
364   function tokenExists (uint256 _tokenId) public view returns (bool _exists) {
365     return cryptoColorData[_tokenId].price > 0;
366   }
367 
368   /**
369   * @dev Guarantees msg.sender is owner of the given token
370   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
371   */
372   modifier onlyOwnerOf(uint256 _tokenId) {
373     require(ownerOf(_tokenId) == msg.sender);
374     _;
375   }
376 
377   /**
378   * @dev Guarantees msg.sender is not a contract
379   * @param _buyer address of person buying cryptoColor
380   */
381   modifier isNotContract(address _buyer) {
382     uint size;
383     assembly { size := extcodesize(_buyer) }
384     require(size == 0);
385     _;
386   }
387 
388   /**
389   * @dev Gets the total amount of tokens stored by the contract
390   * @return uint256 representing the total amount of tokens
391   */
392   function totalSupply() public view returns (uint256) {
393     return totalTokens;
394   }
395 
396   /**
397   * @dev Gets the balance of the specified address
398   * @param _owner address to query the balance of
399   * @return uint256 representing the amount owned by the passed address
400   */
401   function balanceOf(address _owner) public view returns (uint256) {
402     return ownedTokens[_owner].length;
403   }
404 
405   /**
406   * @dev Gets the list of tokens owned by a given address
407   * @param _owner address to query the tokens of
408   * @return uint256[] representing the list of tokens owned by the passed address
409   */
410   function tokensOf(address _owner) public view returns (uint256[]) {
411     return ownedTokens[_owner];
412   }
413 
414   /**
415   * @dev Gets the owner of the specified token ID
416   * @param _tokenId uint256 ID of the token to query the owner of
417   * @return owner address currently marked as the owner of the given token ID
418   */
419   function ownerOf(uint256 _tokenId) public view returns (address) {
420     address owner = tokenOwner[_tokenId];
421     require(owner != address(0));
422     return owner;
423   }
424 
425   /**
426    * @dev Gets the approved address to take ownership of a given token ID
427    * @param _tokenId uint256 ID of the token to query the approval of
428    * @return address currently approved to take ownership of the given token ID
429    */
430   function approvedFor(uint256 _tokenId) public view returns (address) {
431     return tokenApprovals[_tokenId];
432   }
433 
434   /**
435   * @dev Transfers the ownership of a given token ID to another address
436   * @param _to address to receive the ownership of the given token ID
437   * @param _tokenId uint256 ID of the token to be transferred
438   */
439   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
440     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
441   }
442 
443   /**
444   * @dev Approves another address to claim for the ownership of the given token ID
445   * @param _to address to be approved for the given token ID
446   * @param _tokenId uint256 ID of the token to be approved
447   */
448   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
449     address owner = ownerOf(_tokenId);
450     require(_to != owner);
451     if (approvedFor(_tokenId) != 0 || _to != 0) {
452       tokenApprovals[_tokenId] = _to;
453       Approval(owner, _to, _tokenId);
454     }
455   }
456 
457   /**
458   * @dev Claims the ownership of a given token ID
459   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
460   */
461   function takeOwnership(uint256 _tokenId) public {
462     require(isApprovedFor(msg.sender, _tokenId));
463     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
464   }
465 
466   /**
467    * @dev Tells whether the msg.sender is approved for the given token ID or not
468    * This function is not private so it can be extended in further implementations like the operatable ERC721
469    * @param _owner address of the owner to query the approval of
470    * @param _tokenId uint256 ID of the token to query the approval of
471    * @return bool whether the msg.sender is approved for the given token ID or not
472    */
473   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
474     return approvedFor(_tokenId) == _owner;
475   }
476   
477   /**
478   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
479   * @param _from address which you want to send tokens from
480   * @param _to address which you want to transfer the token to
481   * @param _tokenId uint256 ID of the token to be transferred
482   */
483   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal isNotContract(_to) {
484     require(_to != address(0));
485     require(_to != ownerOf(_tokenId));
486     require(ownerOf(_tokenId) == _from);
487 
488     clearApproval(_from, _tokenId);
489     updateSinglePayout(_from, _tokenId);
490     removeToken(_from, _tokenId);
491     addToken(_to, _tokenId);
492     Transfer(_from, _to, _tokenId);
493   }
494 
495   /**
496   * @dev Internal function to clear current approval of a given token ID
497   * @param _tokenId uint256 ID of the token to be transferred
498   */
499   function clearApproval(address _owner, uint256 _tokenId) private {
500     require(ownerOf(_tokenId) == _owner);
501     tokenApprovals[_tokenId] = 0;
502     Approval(_owner, 0, _tokenId);
503   }
504 
505 
506     /**
507   * @dev Mint token function
508   * @param _to The address that will own the minted token
509   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
510   */
511   function _mint(address _to, uint256 _tokenId) internal {
512     require(_to != address(0));
513     addToken(_to, _tokenId);
514     Transfer(0x0, _to, _tokenId);
515   }
516 
517   /**
518   * @dev Internal function to add a token ID to the list of a given address
519   * @param _to address representing the new owner of the given token ID
520   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
521   */
522   function addToken(address _to, uint256 _tokenId) private {
523     require(tokenOwner[_tokenId] == address(0));
524     tokenOwner[_tokenId] = _to;
525     cryptoColorData[_tokenId].owner = _to;
526     uint256 length = balanceOf(_to);
527     ownedTokens[_to].push(_tokenId);
528     ownedTokensIndex[_tokenId] = length;
529     totalTokens = totalTokens.add(1);
530   }
531 
532   /**
533   * @dev Internal function to remove a token ID from the list of a given address
534   * @param _from address representing the previous owner of the given token ID
535   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
536   */
537   function removeToken(address _from, uint256 _tokenId) private {
538     require(ownerOf(_tokenId) == _from);
539 
540     uint256 tokenIndex = ownedTokensIndex[_tokenId];
541     uint256 lastTokenIndex = balanceOf(_from).sub(1);
542     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
543 
544     tokenOwner[_tokenId] = 0;
545     ownedTokens[_from][tokenIndex] = lastToken;
546     ownedTokens[_from][lastTokenIndex] = 0;
547     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
548     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
549     // the lastToken to the first position, and then dropping the element placed in the last position of the list
550 
551     ownedTokens[_from].length--;
552     ownedTokensIndex[_tokenId] = 0;
553     ownedTokensIndex[lastToken] = tokenIndex;
554     totalTokens = totalTokens.sub(1);
555   }
556 
557   function name() public pure returns (string _name) {
558     return "CryptoColor";
559   }
560 
561   function symbol() public pure returns (string _symbol) {
562     return "CCLR";
563   }
564 }