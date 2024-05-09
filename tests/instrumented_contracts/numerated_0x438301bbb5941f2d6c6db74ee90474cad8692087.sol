1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Ownable
5  */
6 contract Ownable {
7   address public owner;
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 }
37 
38 /**
39  * @title SafeMath Library
40  */
41 library SafeMath {
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     if (a == 0) {
47       return 0;
48     }
49     uint256 c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   /**
65   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 /**
83  * @title ERC721 interface
84  * @dev see https://github.com/ethereum/eips/issues/721
85  */
86 contract ERC721 {
87   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
88   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
89 
90   function balanceOf(address _owner) public view returns (uint256 _balance);
91   function ownerOf(uint256 _tokenId) public view returns (address _owner);
92   function transfer(address _to, uint256 _tokenId) public;
93   function approve(address _to, uint256 _tokenId) public;
94   function takeOwnership(uint256 _tokenId) public;
95 }
96 
97 /**
98  * @title ERC721Token
99  * Generic implementation for the required functionality of the ERC721 standard
100  */
101 contract ERC721Token is ERC721 {
102   using SafeMath for uint256;
103 
104   // Total amount of tokens
105   uint256 private totalTokens;
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
119   /**
120   * @dev Guarantees msg.sender is owner of the given token
121   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
122   */
123   modifier onlyOwnerOf(uint256 _tokenId) {
124     require(ownerOf(_tokenId) == msg.sender);
125     _;
126   }
127 
128   /**
129   * @dev Gets the total amount of tokens stored by the contract
130   * @return uint256 representing the total amount of tokens
131   */
132   function totalSupply() public view returns (uint256) {
133     return totalTokens;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address
138   * @param _owner address to query the balance of
139   * @return uint256 representing the amount owned by the passed address
140   */
141   function balanceOf(address _owner) public view returns (uint256) {
142     return ownedTokens[_owner].length;
143   }
144 
145   /**
146   * @dev Gets the list of tokens owned by a given address
147   * @param _owner address to query the tokens of
148   * @return uint256[] representing the list of tokens owned by the passed address
149   */
150   function tokensOf(address _owner) public view returns (uint256[]) {
151     return ownedTokens[_owner];
152   }
153 
154   /**
155   * @dev Gets the owner of the specified token ID
156   * @param _tokenId uint256 ID of the token to query the owner of
157   * @return owner address currently marked as the owner of the given token ID
158   */
159   function ownerOf(uint256 _tokenId) public view returns (address) {
160     address owner = tokenOwner[_tokenId];
161     require(owner != address(0));
162     return owner;
163   }
164 
165   /**
166    * @dev Gets the approved address to take ownership of a given token ID
167    * @param _tokenId uint256 ID of the token to query the approval of
168    * @return address currently approved to take ownership of the given token ID
169    */
170   function approvedFor(uint256 _tokenId) public view returns (address) {
171     return tokenApprovals[_tokenId];
172   }
173 
174   /**
175   * @dev Transfers the ownership of a given token ID to another address
176   * @param _to address to receive the ownership of the given token ID
177   * @param _tokenId uint256 ID of the token to be transferred
178   */
179   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
180     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
181   }
182 
183   /**
184   * @dev Approves another address to claim for the ownership of the given token ID
185   * @param _to address to be approved for the given token ID
186   * @param _tokenId uint256 ID of the token to be approved
187   */
188   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
189     address owner = ownerOf(_tokenId);
190     require(_to != owner);
191     if (approvedFor(_tokenId) != 0 || _to != 0) {
192       tokenApprovals[_tokenId] = _to;
193       Approval(owner, _to, _tokenId);
194     }
195   }
196 
197   /**
198   * @dev Claims the ownership of a given token ID
199   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
200   */
201   function takeOwnership(uint256 _tokenId) public {
202     require(isApprovedFor(msg.sender, _tokenId));
203     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
204   }
205 
206   /**
207   * @dev Mint token function
208   * @param _to The address that will own the minted token
209   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
210   */
211   function _mint(address _to, uint256 _tokenId) internal {
212     require(_to != address(0));
213     addToken(_to, _tokenId);
214     Transfer(0x0, _to, _tokenId);
215   }
216 
217   /**
218   * @dev Burns a specific token
219   * @param _tokenId uint256 ID of the token being burned by the msg.sender
220   */
221   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
222     if (approvedFor(_tokenId) != 0) {
223       clearApproval(msg.sender, _tokenId);
224     }
225     removeToken(msg.sender, _tokenId);
226     Transfer(msg.sender, 0x0, _tokenId);
227   }
228 
229   /**
230    * @dev Tells whether the msg.sender is approved for the given token ID or not
231    * This function is not private so it can be extended in further implementations like the operatable ERC721
232    * @param _owner address of the owner to query the approval of
233    * @param _tokenId uint256 ID of the token to query the approval of
234    * @return bool whether the msg.sender is approved for the given token ID or not
235    */
236   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
237     return approvedFor(_tokenId) == _owner;
238   }
239 
240   /**
241   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
242   * @param _from address which you want to send tokens from
243   * @param _to address which you want to transfer the token to
244   * @param _tokenId uint256 ID of the token to be transferred
245   */
246   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
247     require(_to != address(0));
248     require(_to != ownerOf(_tokenId));
249     require(ownerOf(_tokenId) == _from);
250 
251     clearApproval(_from, _tokenId);
252     removeToken(_from, _tokenId);
253     addToken(_to, _tokenId);
254     Transfer(_from, _to, _tokenId);
255   }
256 
257   /**
258   * @dev Internal function to clear current approval of a given token ID
259   * @param _tokenId uint256 ID of the token to be transferred
260   */
261   function clearApproval(address _owner, uint256 _tokenId) private {
262     require(ownerOf(_tokenId) == _owner);
263     tokenApprovals[_tokenId] = 0;
264     Approval(_owner, 0, _tokenId);
265   }
266 
267   /**
268   * @dev Internal function to add a token ID to the list of a given address
269   * @param _to address representing the new owner of the given token ID
270   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
271   */
272   function addToken(address _to, uint256 _tokenId) private {
273     require(tokenOwner[_tokenId] == address(0));
274     tokenOwner[_tokenId] = _to;
275     uint256 length = balanceOf(_to);
276     ownedTokens[_to].push(_tokenId);
277     ownedTokensIndex[_tokenId] = length;
278     totalTokens = totalTokens.add(1);
279   }
280 
281   /**
282   * @dev Internal function to remove a token ID from the list of a given address
283   * @param _from address representing the previous owner of the given token ID
284   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
285   */
286   function removeToken(address _from, uint256 _tokenId) private {
287     require(ownerOf(_tokenId) == _from);
288 
289     uint256 tokenIndex = ownedTokensIndex[_tokenId];
290     uint256 lastTokenIndex = balanceOf(_from).sub(1);
291     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
292 
293     tokenOwner[_tokenId] = 0;
294     ownedTokens[_from][tokenIndex] = lastToken;
295     ownedTokens[_from][lastTokenIndex] = 0;
296     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
297     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
298     // the lastToken to the first position, and then dropping the element placed in the last position of the list
299 
300     ownedTokens[_from].length--;
301     ownedTokensIndex[_tokenId] = 0;
302     ownedTokensIndex[lastToken] = tokenIndex;
303     totalTokens = totalTokens.sub(1);
304   }
305 }
306 
307 /**
308  * @title CryptoThingWithDescendants
309  */
310 contract CryptoThingWithDescendants is Ownable, ERC721Token {
311   using SafeMath for uint256;
312 
313   struct Thing {
314     uint256 id;
315     uint256 parentId;
316     uint256 purchasePrice;
317     uint256 growthRate;
318     uint256 dividendRate;
319     uint256 dividendsPaid;
320     uint256 lastAction;
321     bytes32 displayName;
322   }
323 
324   uint256 public gameCost = 10 ether;
325   uint256 public floorPrice = 10 finney;
326   uint256 public standardGrowthRate = 150;
327   uint256 public numThings;
328   mapping (uint256 => Thing) public things;
329   mapping (uint256 => uint256[]) public descendantsOfThing;
330 
331   string constant public NAME = 'Star Card';
332   string constant public SYMBOL = 'CARD';
333 
334   event DividendPaid(address indexed recipient, uint256 amount);
335   event OverpaymentRefunded(uint256 amountExpected, uint256 excessFunds);
336   event ThingBorn(uint256 indexed thingId, uint256 initialPrice);
337   event ThingDestroyed(uint256 indexed thingId);
338   event ThingSold(
339     uint256 indexed thingId,
340     uint256 oldPrice,
341     uint256 newPrice,
342     address oldOwner,
343     address newOwner
344   );
345 
346   function () payable public {
347     // someone sent a gift! yay!
348     owner.transfer(msg.value);
349   }
350 
351   function name() constant public returns (string) {
352     return NAME;
353   }
354 
355   function symbol() constant public returns (string) {
356     return SYMBOL;
357   }
358 
359   function addThing(
360     uint256 _parentId,
361     uint256 _purchasePrice,
362     uint256 _growthRate,
363     uint256 _dividendRate,
364     bytes32 _displayName
365   ) public onlyOwner returns (uint256 thingId) {
366     thingId = ++numThings;
367     things[thingId] = Thing({
368       id: thingId,
369       parentId: _parentId,
370       purchasePrice: _purchasePrice == 0 ? floorPrice : _purchasePrice,
371       growthRate: _growthRate == 0 ? standardGrowthRate : _growthRate,
372       dividendRate: _dividendRate,
373       dividendsPaid: 0,
374       lastAction: block.timestamp,
375       displayName: _displayName
376     });
377 
378     if (_parentId != 0) descendantsOfThing[_parentId].push(thingId);
379 
380     _mint(msg.sender, thingId);
381     ThingBorn(thingId, things[thingId].purchasePrice);
382   }
383 
384   function purchase(uint256 _thingId) public payable {
385     require(_thingId != 0 && _thingId <= numThings);
386 
387     address previousOwner = ownerOf(_thingId);
388     require(previousOwner != msg.sender);
389 
390     Thing storage thing = things[_thingId];
391     uint256[] storage descendants = descendantsOfThing[_thingId];
392 
393     uint256 currentPrice = getCurrentPrice(_thingId);
394     require(msg.value >= currentPrice);
395     if (msg.value > currentPrice) {
396       OverpaymentRefunded(currentPrice, msg.value.sub(currentPrice));
397       msg.sender.transfer(msg.value.sub(currentPrice));
398     }
399 
400     if (thing.dividendRate != 0 && (thing.parentId != 0 || descendants.length > 0)) {
401       uint256 numDividends = thing.parentId == 0 ? descendants.length : descendants.length.add(1);
402       uint256 dividendPerRecipient = getDividendPayout(
403         currentPrice,
404         thing.dividendRate,
405         numDividends
406       );
407 
408       address dividendRecipient = address(this);
409       for (uint256 i = 0; i < numDividends; i++) {
410         dividendRecipient = ownerOf(
411           i == descendants.length ? thing.parentId : descendants[i]
412         );
413         dividendRecipient.transfer(dividendPerRecipient);
414         DividendPaid(dividendRecipient, dividendPerRecipient);
415       }
416 
417       thing.dividendsPaid = thing.dividendsPaid.add(dividendPerRecipient.mul(numDividends));
418     }
419 
420     uint256 previousHolderShare = currentPrice.sub(
421       dividendPerRecipient.mul(numDividends)
422     );
423 
424     uint256 fee = previousHolderShare.div(20);
425     owner.transfer(fee);
426 
427     previousOwner.transfer(previousHolderShare.sub(fee));
428     thing.purchasePrice = thing.purchasePrice.mul(thing.growthRate).div(100);
429     thing.lastAction = block.timestamp;
430 
431     clearApprovalAndTransfer(previousOwner, msg.sender, _thingId);
432     ThingSold(_thingId, currentPrice, thing.purchasePrice, previousOwner, msg.sender);
433   }
434 
435   function purchaseGame() public payable {
436     require(msg.sender != owner);
437     require(msg.value >= gameCost);
438     owner.transfer(msg.value);
439     owner = msg.sender;
440     OwnershipTransferred(owner, msg.sender);
441   }
442 
443   function setGameCost(uint256 newCost) public onlyOwner {
444     gameCost = newCost;
445   }
446 
447   function getDescendantsOfThing(uint256 _thingId) public view returns (uint256[]) {
448     return descendantsOfThing[_thingId];
449   }
450 
451   function getCurrentPrice(
452     uint256 _thingId
453   ) public view returns (uint256 currentPrice) {
454     require(_thingId != 0 && _thingId <= numThings);
455     Thing storage thing = things[_thingId];
456     currentPrice = getPurchasePrice(thing.purchasePrice, thing.growthRate);
457   }
458 
459   function getPurchasePrice(
460     uint256 _currentPrice,
461     uint256 _priceIncrease
462   ) internal pure returns (uint256 currentPrice) {
463     currentPrice = _currentPrice.mul(_priceIncrease).div(100);
464   }
465 
466   function getDividendPayout(
467     uint256 _purchasePrice,
468     uint256 _dividendRate,
469     uint256 _numDividends
470   ) public pure returns (uint256 dividend) {
471     dividend = _purchasePrice.mul(
472       _dividendRate
473     ).div(
474       100
475     ).sub(
476       _purchasePrice
477     ).div(
478       _numDividends
479     );
480   }
481 }