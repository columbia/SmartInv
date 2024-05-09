1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract Dogs {
47   using SafeMath for uint256;
48   /*** EVENTS ***/
49   /// @dev The Birth event is fired whenever a new collectible comes into existence.
50   event Birth(uint256 tokenId, uint256 startPrice);
51   /// @dev The TokenSold event is fired whenever a token is sold.
52   event TokenSold(uint256 indexed tokenId, uint256 price, address prevOwner, address winner);
53   // ERC721 Transfer
54   event Transfer(address indexed from, address indexed to, uint256 tokenId);
55   // ERC721 Approval
56   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
57 
58   /*** CONSTANTS ***/
59 
60   string public constant NAME = "dogs-youCollect";
61   string public constant SYMBOL = "DYC";
62   uint256[] private tokens;
63 
64   /*** STORAGE ***/
65 
66   /// @dev A mapping from collectible IDs to the address that owns them. All collectibles have
67   ///  some valid owner address.
68   mapping (uint256 => address) public collectibleIndexToOwner;
69 
70   /// @dev A mapping from CollectibleIDs to an address that has been approved to call
71   ///  transferFrom(). Each Collectible can only have one approved address for transfer
72   ///  at any time. A zero value means no approval is outstanding.
73   mapping (uint256 => address) public collectibleIndexToApproved;
74 
75   // @dev A mapping from CollectibleIDs to the price of the token.
76   mapping (uint256 => uint256) public collectibleIndexToPrice;
77 
78   // The addresses of the accounts (or contracts) that can execute actions within each roles.
79   address public ceoAddress;
80   address public cooAddress;
81 
82   mapping (uint => address) private subTokenCreator;
83   mapping (uint => address) private lastSubTokenBuyer;
84   mapping (uint => bool) private unlocked;
85 
86   uint8 constant BASE_TOKEN_ID = 0;
87   uint16 constant MAX_SETS_INDEX = 10000;
88   uint64 constant FIFTY_TOKENS_INDEX = 1000000000000000;
89   uint128 constant TRIBLE_TOKENS_INDEX = 100000000000000000000000;
90   uint128 constant DOUBLE_TOKENS_INDEX = 100000000000000000000000000000000;
91   uint256 private constant PROMO_CREATION_LIMIT = 50000;
92   uint256 public promoCreatedCount;
93   uint256 constant START_PRICE_DOG = 1 finney;
94   uint256 constant START_PRICE_SETS = 100 finney;
95   uint256 constant START_PRICE_BASE_DOG = 10 ether;
96 
97 
98   /*** CONSTRUCTOR ***/
99   function Dogs() public {
100     ceoAddress = msg.sender;
101     cooAddress = msg.sender;
102   }
103   function getTotalSupply() public view returns (uint) {
104     return tokens.length;
105   }
106   function getInitialPriceOfToken(uint _tokenId) public pure returns (uint) {
107     if (_tokenId > MAX_SETS_INDEX)
108       return START_PRICE_DOG;
109     if (_tokenId > 0)
110       return START_PRICE_SETS;
111     return START_PRICE_BASE_DOG;
112   }
113 
114   function getNextPrice(uint price, uint _tokenId) public pure returns (uint) {
115     if (_tokenId>DOUBLE_TOKENS_INDEX)
116       return price.mul(2);
117     if (_tokenId>TRIBLE_TOKENS_INDEX)
118       return price.mul(3);
119     if (_tokenId>FIFTY_TOKENS_INDEX)
120       return price.mul(3).div(2);
121     if (price < 1.2 ether)
122       return price.mul(200).div(92);
123     if (price < 5 ether)
124       return price.mul(150).div(92);
125     return price.mul(120).div(92);
126   }
127 
128   function buyToken(uint _tokenId) public payable {
129     address oldOwner = collectibleIndexToOwner[_tokenId];
130     require(oldOwner!=msg.sender);
131     uint256 sellingPrice = collectibleIndexToPrice[_tokenId];
132     if (sellingPrice==0) {
133       sellingPrice = getInitialPriceOfToken(_tokenId);
134       if (_tokenId>MAX_SETS_INDEX)
135         subTokenCreator[_tokenId] = msg.sender;
136     }
137 
138     require(msg.value >= sellingPrice);
139     uint256 purchaseExcess = msg.value.sub(sellingPrice);
140 
141     uint256 payment = sellingPrice.mul(92).div(100);
142     uint256 feeOnce = sellingPrice.sub(payment).div(8);
143 
144     // transfer taxes
145     if (_tokenId > 0) {
146       if (collectibleIndexToOwner[BASE_TOKEN_ID]!=address(0))
147         collectibleIndexToOwner[BASE_TOKEN_ID].transfer(feeOnce);
148       if (_tokenId > MAX_SETS_INDEX) {
149         if (collectibleIndexToOwner[_tokenId % MAX_SETS_INDEX]!=address(0))
150           collectibleIndexToOwner[_tokenId % MAX_SETS_INDEX].transfer(feeOnce);
151         if (subTokenCreator[_tokenId]!=address(0))
152           subTokenCreator[_tokenId].transfer(feeOnce);
153 
154         if (unlocked[_tokenId]) {
155           lastSubTokenBuyer[BASE_TOKEN_ID] = msg.sender;
156           lastSubTokenBuyer[_tokenId % MAX_SETS_INDEX] = msg.sender;
157         }
158       } else {
159         lastSubTokenBuyer[_tokenId].transfer(feeOnce*2);
160       }
161     } else {
162       lastSubTokenBuyer[_tokenId].transfer(feeOnce*2);
163     }
164     // Transfers the Token
165     collectibleIndexToOwner[_tokenId] = msg.sender;
166     if (oldOwner != address(0)) {
167       // Payment for old owner
168       oldOwner.transfer(payment);
169       // clear any previously approved ownership exchange
170       delete collectibleIndexToApproved[_tokenId];
171     } else {
172       Birth(_tokenId, sellingPrice);
173       tokens.push(_tokenId);
174     }
175     // Update prices
176     collectibleIndexToPrice[_tokenId] = getNextPrice(sellingPrice, _tokenId);
177 
178     TokenSold(_tokenId, sellingPrice, oldOwner, msg.sender);
179     Transfer(oldOwner, msg.sender, _tokenId);
180     // refund when paid too much
181     if (purchaseExcess>0)
182       msg.sender.transfer(purchaseExcess);
183   }
184 
185 
186 
187   /*** ACCESS MODIFIERS ***/
188   /// @dev Access modifier for CEO-only functionality
189   modifier onlyCEO() {
190     require(msg.sender == ceoAddress);
191     _;
192   }
193 
194   /// @dev Access modifier for COO-only functionality
195   modifier onlyCOO() {
196     require(msg.sender == cooAddress);
197     _;
198   }
199 
200   /// Access modifier for contract owner only functionality
201   modifier onlyCLevel() {
202     require(
203       msg.sender == ceoAddress ||
204       msg.sender == cooAddress
205     );
206     _;
207   }
208 
209   /*** PUBLIC FUNCTIONS ***/
210   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
211   /// @param _to The address to be granted transfer approval. Pass address(0) to
212   ///  clear all approvals.
213   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
214   /// @dev Required for ERC-721 compliance.
215   function approve(
216     address _to,
217     uint256 _tokenId
218   ) public {
219     // Caller must own token.
220     require(_owns(msg.sender, _tokenId));
221 
222     collectibleIndexToApproved[_tokenId] = _to;
223 
224     Approval(msg.sender, _to, _tokenId);
225   }
226 
227   /// @dev Creates a new promo collectible with the given name, with given _price and assignes it to an address.
228   function createPromoCollectible(uint256 tokenId, address _owner, uint256 _price) public onlyCOO {
229     require(collectibleIndexToOwner[tokenId]==address(0));
230     require(promoCreatedCount < PROMO_CREATION_LIMIT);
231 
232     address collectibleOwner = _owner;
233     if (collectibleOwner == address(0)) {
234       collectibleOwner = cooAddress;
235     }
236 
237     if (_price <= 0) {
238       _price = getInitialPriceOfToken(tokenId);
239     }
240 
241     promoCreatedCount++;
242     _createCollectible(tokenId, _price);
243     subTokenCreator[tokenId] = collectibleOwner;
244     unlocked[tokenId] = true;
245     // This will assign ownership, and also emit the Transfer event as
246     // per ERC721 draft
247     _transfer(address(0), collectibleOwner, tokenId);
248 
249   }
250 
251   function createSecondPromoCollectible(uint256 tokenId, address _creator, uint256 _price, address _owner) public onlyCOO {
252     require(collectibleIndexToOwner[tokenId]==address(0));
253     require(promoCreatedCount < PROMO_CREATION_LIMIT);
254 
255     address collectibleOwner = _owner;
256     if (collectibleOwner == address(0)) {
257       collectibleOwner = cooAddress;
258     }
259 
260     if (_price <= 0) {
261       _price = getInitialPriceOfToken(tokenId);
262     }
263 
264     promoCreatedCount++;
265     _createCollectible(tokenId, _price);
266     subTokenCreator[tokenId] = _creator;
267     unlocked[tokenId] = true;
268     // This will assign ownership, and also emit the Transfer event as
269     // per ERC721 draft
270     _transfer(address(0), collectibleOwner, tokenId);
271 
272   }
273 
274   bool isChangePriceLocked = true;
275   // allows owners of tokens to decrease the price of them or if there is no owner the coo can do it
276   function changePrice(uint256 newPrice, uint256 _tokenId) public {
277     require((_owns(msg.sender, _tokenId) && !isChangePriceLocked) || (_owns(address(0), _tokenId) && msg.sender == cooAddress));
278     require(newPrice<collectibleIndexToPrice[_tokenId]);
279     collectibleIndexToPrice[_tokenId] = newPrice;
280   }
281   function unlockToken(uint tokenId) public onlyCOO {
282     unlocked[tokenId] = true;
283   }
284   function unlockPriceChange() public onlyCOO {
285     isChangePriceLocked = false;
286   }
287 
288   /// @notice Returns all the relevant information about a specific collectible.
289   /// @param _tokenId The tokenId of the collectible of interest.
290   function getToken(uint256 _tokenId) public view returns (uint256 tokenId, uint256 sellingPrice, address owner, uint256 nextSellingPrice) {
291     tokenId = _tokenId;
292     sellingPrice = collectibleIndexToPrice[_tokenId];
293     if (sellingPrice == 0)
294       sellingPrice = getInitialPriceOfToken(_tokenId);
295     owner = collectibleIndexToOwner[_tokenId];
296     nextSellingPrice = getNextPrice(sellingPrice, _tokenId);
297   }
298 
299   function implementsERC721() public pure returns (bool) {
300     return true;
301   }
302 
303   /// @dev Required for ERC-721 compliance.
304   function name() public pure returns (string) {
305     return NAME;
306   }
307 
308   /// For querying owner of token
309   /// @param _tokenId The tokenID for owner inquiry
310   /// @dev Required for ERC-721 compliance.
311   function ownerOf(uint256 _tokenId)
312     public
313     view
314     returns (address owner)
315   {
316     owner = collectibleIndexToOwner[_tokenId];
317     require(owner != address(0));
318   }
319 
320   function payout(address _to) public onlyCLevel {
321     _payout(_to);
322   }
323 
324 
325   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
326     price = collectibleIndexToPrice[_tokenId];
327     if (price == 0)
328       price = getInitialPriceOfToken(_tokenId);
329   }
330 
331   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
332   /// @param _newCEO The address of the new CEO
333   function setCEO(address _newCEO) public onlyCEO {
334     require(_newCEO != address(0));
335 
336     ceoAddress = _newCEO;
337   }
338 
339   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
340   /// @param _newCOO The address of the new COO
341   function setCOO(address _newCOO) public onlyCEO {
342     require(_newCOO != address(0));
343 
344     cooAddress = _newCOO;
345   }
346 
347   /// @dev Required for ERC-721 compliance.
348   function symbol() public pure returns (string) {
349     return SYMBOL;
350   }
351 
352   /// @notice Allow pre-approved user to take ownership of a token
353   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
354   /// @dev Required for ERC-721 compliance.
355   function takeOwnership(uint256 _tokenId) public {
356     address newOwner = msg.sender;
357     address oldOwner = collectibleIndexToOwner[_tokenId];
358 
359     // Safety check to prevent against an unexpected 0x0 default.
360     require(_addressNotNull(newOwner));
361 
362     // Making sure transfer is approved
363     require(_approved(newOwner, _tokenId));
364 
365     _transfer(oldOwner, newOwner, _tokenId);
366   }
367 
368   /// Owner initates the transfer of the token to another account
369   /// @param _to The address for the token to be transferred to.
370   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
371   /// @dev Required for ERC-721 compliance.
372   function transfer(
373     address _to,
374     uint256 _tokenId
375   ) public {
376     require(_owns(msg.sender, _tokenId));
377     require(_addressNotNull(_to));
378 
379     _transfer(msg.sender, _to, _tokenId);
380   }
381 
382   /// Third-party initiates transfer of token from address _from to address _to
383   /// @param _from The address for the token to be transferred from.
384   /// @param _to The address for the token to be transferred to.
385   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
386   /// @dev Required for ERC-721 compliance.
387   function transferFrom(
388     address _from,
389     address _to,
390     uint256 _tokenId
391   ) public {
392     require(_owns(_from, _tokenId));
393     require(_approved(_to, _tokenId));
394     require(_addressNotNull(_to));
395 
396     _transfer(_from, _to, _tokenId);
397   }
398 
399   /*** PRIVATE FUNCTIONS ***/
400   /// Safety check on _to address to prevent against an unexpected 0x0 default.
401   function _addressNotNull(address _to) private pure returns (bool) {
402     return _to != address(0);
403   }
404 
405   /// For checking approval of transfer for address _to
406   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
407     return collectibleIndexToApproved[_tokenId] == _to;
408   }
409 
410   /// For creating Collectible
411   function _createCollectible(uint256 tokenId, uint256 _price) private {
412     collectibleIndexToPrice[tokenId] = _price;
413     Birth(tokenId, _price);
414     tokens.push(tokenId);
415   }
416 
417   /// Check for token ownership
418   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
419     return claimant == collectibleIndexToOwner[_tokenId];
420   }
421 
422   /// For paying out balance on contract
423   function _payout(address _to) private {
424     if (_to == address(0)) {
425       ceoAddress.transfer(this.balance);
426     } else {
427       _to.transfer(this.balance);
428     }
429   }
430 
431   /// For querying balance of a particular account
432   /// @param _owner The address for balance query
433   /// @dev Required for ERC-721 compliance.
434   function balanceOf(address _owner) public view returns (uint256 result) {
435       uint256 totalTokens = tokens.length;
436       uint256 tokenIndex;
437       uint256 tokenId;
438       result = 0;
439       for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
440         tokenId = tokens[tokenIndex];
441         if (collectibleIndexToOwner[tokenId] == _owner) {
442           result = result.add(1);
443         }
444       }
445       return result;
446   }
447 
448   /// @dev Assigns ownership of a specific Collectible to an address.
449   function _transfer(address _from, address _to, uint256 _tokenId) private {
450     //transfer ownership
451     collectibleIndexToOwner[_tokenId] = _to;
452 
453     // When creating new collectibles _from is 0x0, but we can't account that address.
454     if (_from != address(0)) {
455       // clear any previously approved ownership exchange
456       delete collectibleIndexToApproved[_tokenId];
457     }
458 
459     // Emit the transfer event.
460     Transfer(_from, _to, _tokenId);
461   }
462 
463 
464    /// @param _owner The owner whose celebrity tokens we are interested in.
465   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
466   ///  expensive (it walks the entire tokens array looking for tokens belonging to owner),
467   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
468   ///  not contract-to-contract calls.
469   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
470     uint256 tokenCount = balanceOf(_owner);
471     if (tokenCount == 0) {
472         // Return an empty array
473       return new uint256[](0);
474     } else {
475       uint256[] memory result = new uint256[](tokenCount);
476       uint256 totalTokens = getTotalSupply();
477       uint256 resultIndex = 0;
478 
479       uint256 tokenIndex;
480       uint256 tokenId;
481       for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
482         tokenId = tokens[tokenIndex];
483         if (collectibleIndexToOwner[tokenId] == _owner) {
484           result[resultIndex] = tokenId;
485           resultIndex = resultIndex.add(1);
486         }
487       }
488       return result;
489     }
490   }
491 }