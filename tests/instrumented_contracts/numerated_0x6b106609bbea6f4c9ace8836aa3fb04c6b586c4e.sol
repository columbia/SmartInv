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
46 contract NewWorld {
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
60   string public constant NAME = "world-youCollect";
61   string public constant SYMBOL = "WYC";
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
83 
84   uint16 constant MAX_CONTINENT_INDEX = 10;
85   uint16 constant MAX_SUBCONTINENT_INDEX = 100;
86   uint16 constant MAX_COUNTRY_INDEX = 10000;
87   uint64 constant DOUBLE_TOKENS_INDEX = 10000000000000;
88   uint128 constant TRIBLE_TOKENS_INDEX = 10000000000000000000000;
89   uint128 constant FIFTY_TOKENS_INDEX = 10000000000000000000000000000000;
90   uint256 private constant PROMO_CREATION_LIMIT = 50000;
91   uint256 public promoCreatedCount;
92   uint8 constant WORLD_TOKEN_ID = 0;
93   uint256 constant START_PRICE_CITY = 1 finney;
94   uint256 constant START_PRICE_COUNTRY = 10 finney;
95   uint256 constant START_PRICE_SUBCONTINENT = 100 finney;
96   uint256 constant START_PRICE_CONTINENT = 1 ether;
97   uint256 constant START_PRICE_WORLD = 10 ether;
98 
99 
100   /*** CONSTRUCTOR ***/
101   function NewWorld() public {
102     ceoAddress = msg.sender;
103     cooAddress = msg.sender;
104   }
105   function getTotalSupply() public view returns (uint) {
106     return tokens.length;
107   }
108   function getInitialPriceOfToken(uint _tokenId) public pure returns (uint) {
109     if (_tokenId > MAX_COUNTRY_INDEX)
110       return START_PRICE_CITY;
111     if (_tokenId > MAX_SUBCONTINENT_INDEX)
112       return START_PRICE_COUNTRY;
113     if (_tokenId > MAX_CONTINENT_INDEX)
114       return START_PRICE_SUBCONTINENT;
115     if (_tokenId > 0)
116       return START_PRICE_CONTINENT;
117     return START_PRICE_WORLD;
118   }
119 
120   function getNextPrice(uint price, uint _tokenId) public pure returns (uint) {
121     if (_tokenId>DOUBLE_TOKENS_INDEX)
122       return price.mul(2);
123     if (_tokenId>TRIBLE_TOKENS_INDEX)
124       return price.mul(3);
125     if (_tokenId>FIFTY_TOKENS_INDEX)
126       return price.mul(3).div(2);
127     if (price < 1.2 ether)
128       return price.mul(200).div(92);
129     if (price < 5 ether)
130       return price.mul(150).div(92);
131     return price.mul(120).div(92);
132   }
133 
134   function buyToken(uint _tokenId) public payable {
135     address oldOwner = collectibleIndexToOwner[_tokenId];
136     require(oldOwner!=msg.sender);
137     uint256 sellingPrice = collectibleIndexToPrice[_tokenId];
138     if (sellingPrice==0) {
139       sellingPrice = getInitialPriceOfToken(_tokenId);
140       // if it is a new city or other subcountryToken, the creator is saved for rewards on later trades
141       if (_tokenId>MAX_COUNTRY_INDEX)
142         subTokenCreator[_tokenId] = msg.sender;
143     }
144 
145     require(msg.value >= sellingPrice);
146     uint256 purchaseExcess = msg.value.sub(sellingPrice);
147 
148     uint256 payment = sellingPrice.mul(92).div(100);
149     uint256 feeOnce = sellingPrice.sub(payment).div(8);
150 
151     if (_tokenId > 0) {
152       // Taxes for World owner
153       if (collectibleIndexToOwner[WORLD_TOKEN_ID]!=address(0))
154         collectibleIndexToOwner[WORLD_TOKEN_ID].transfer(feeOnce);
155       if (_tokenId > MAX_CONTINENT_INDEX) {
156         // Taxes for continent owner
157         if (collectibleIndexToOwner[_tokenId % MAX_CONTINENT_INDEX]!=address(0))
158           collectibleIndexToOwner[_tokenId % MAX_CONTINENT_INDEX].transfer(feeOnce);
159         if (_tokenId > MAX_SUBCONTINENT_INDEX) {
160           // Taxes for subcontinent owner
161           if (collectibleIndexToOwner[_tokenId % MAX_SUBCONTINENT_INDEX]!=address(0))
162             collectibleIndexToOwner[_tokenId % MAX_SUBCONTINENT_INDEX].transfer(feeOnce);
163           if (_tokenId > MAX_COUNTRY_INDEX) {
164             // Taxes for country owner
165             if (collectibleIndexToOwner[_tokenId % MAX_COUNTRY_INDEX]!=address(0))
166               collectibleIndexToOwner[_tokenId % MAX_COUNTRY_INDEX].transfer(feeOnce);
167             // Taxes for city creator
168             subTokenCreator[_tokenId].transfer(feeOnce);
169           }
170         }
171       }
172     }
173     // Transfers the Token
174     collectibleIndexToOwner[_tokenId] = msg.sender;
175     if (oldOwner != address(0)) {
176       // Payment for old owner
177       oldOwner.transfer(payment);
178       // clear any previously approved ownership exchange
179       delete collectibleIndexToApproved[_tokenId];
180     } else {
181       Birth(_tokenId, sellingPrice);
182       tokens.push(_tokenId);
183     }
184     // Update prices
185     collectibleIndexToPrice[_tokenId] = getNextPrice(sellingPrice, _tokenId);
186 
187     TokenSold(_tokenId, sellingPrice, oldOwner, msg.sender);
188     Transfer(oldOwner, msg.sender, _tokenId);
189     // refund when paid too much
190     if (purchaseExcess>0)
191       msg.sender.transfer(purchaseExcess);
192   }
193 
194 
195 
196   /*** ACCESS MODIFIERS ***/
197   /// @dev Access modifier for CEO-only functionality
198   modifier onlyCEO() {
199     require(msg.sender == ceoAddress);
200     _;
201   }
202 
203   /// @dev Access modifier for COO-only functionality
204   modifier onlyCOO() {
205     require(msg.sender == cooAddress);
206     _;
207   }
208 
209   /// Access modifier for contract owner only functionality
210   modifier onlyCLevel() {
211     require(
212       msg.sender == ceoAddress ||
213       msg.sender == cooAddress
214     );
215     _;
216   }
217 
218   /*** PUBLIC FUNCTIONS ***/
219   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
220   /// @param _to The address to be granted transfer approval. Pass address(0) to
221   ///  clear all approvals.
222   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
223   /// @dev Required for ERC-721 compliance.
224   function approve(
225     address _to,
226     uint256 _tokenId
227   ) public {
228     // Caller must own token.
229     require(_owns(msg.sender, _tokenId));
230 
231     collectibleIndexToApproved[_tokenId] = _to;
232 
233     Approval(msg.sender, _to, _tokenId);
234   }
235 
236   /// @dev Creates a new promo collectible with the given name, with given _price and assignes it to an address.
237   function createPromoCollectible(uint256 tokenId, address _owner, uint256 _price) public onlyCOO {
238     require(collectibleIndexToOwner[tokenId]==address(0));
239     require(promoCreatedCount < PROMO_CREATION_LIMIT);
240 
241     address collectibleOwner = _owner;
242     if (collectibleOwner == address(0)) {
243       collectibleOwner = cooAddress;
244     }
245 
246     if (_price <= 0) {
247       _price = getInitialPriceOfToken(tokenId);
248     }
249 
250     promoCreatedCount++;
251     _createCollectible(tokenId, _price);
252     // This will assign ownership, and also emit the Transfer event as
253     // per ERC721 draft
254     _transfer(address(0), collectibleOwner, tokenId);
255 
256   }
257 
258   bool isChangePriceLocked = true;
259   // allows owners of tokens to decrease the price of them or if there is no owner the coo can do it
260   function changePrice(uint256 newPrice, uint256 _tokenId) public {
261     require((_owns(msg.sender, _tokenId) && !isChangePriceLocked) || (_owns(address(0), _tokenId) && msg.sender == cooAddress));
262     require(newPrice<collectibleIndexToPrice[_tokenId]);
263     collectibleIndexToPrice[_tokenId] = newPrice;
264   }
265   function unlockPriceChange() public onlyCOO {
266     isChangePriceLocked = false;
267   }
268 
269   /// @notice Returns all the relevant information about a specific collectible.
270   /// @param _tokenId The tokenId of the collectible of interest.
271   function getToken(uint256 _tokenId) public view returns (uint256 tokenId, uint256 sellingPrice, address owner, uint256 nextSellingPrice) {
272     tokenId = _tokenId;
273     sellingPrice = collectibleIndexToPrice[_tokenId];
274     if (sellingPrice == 0)
275       sellingPrice = getInitialPriceOfToken(_tokenId);
276     owner = collectibleIndexToOwner[_tokenId];
277     nextSellingPrice = getNextPrice(sellingPrice, _tokenId);
278   }
279 
280   function implementsERC721() public pure returns (bool) {
281     return true;
282   }
283 
284   /// @dev Required for ERC-721 compliance.
285   function name() public pure returns (string) {
286     return NAME;
287   }
288 
289   /// For querying owner of token
290   /// @param _tokenId The tokenID for owner inquiry
291   /// @dev Required for ERC-721 compliance.
292   function ownerOf(uint256 _tokenId)
293     public
294     view
295     returns (address owner)
296   {
297     owner = collectibleIndexToOwner[_tokenId];
298     require(owner != address(0));
299   }
300 
301   function payout(address _to) public onlyCLevel {
302     _payout(_to);
303   }
304 
305 
306   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
307     price = collectibleIndexToPrice[_tokenId];
308     if (price == 0)
309       price = getInitialPriceOfToken(_tokenId);
310   }
311 
312   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
313   /// @param _newCEO The address of the new CEO
314   function setCEO(address _newCEO) public onlyCEO {
315     require(_newCEO != address(0));
316 
317     ceoAddress = _newCEO;
318   }
319 
320   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
321   /// @param _newCOO The address of the new COO
322   function setCOO(address _newCOO) public onlyCEO {
323     require(_newCOO != address(0));
324 
325     cooAddress = _newCOO;
326   }
327 
328   /// @dev Required for ERC-721 compliance.
329   function symbol() public pure returns (string) {
330     return SYMBOL;
331   }
332 
333   /// @notice Allow pre-approved user to take ownership of a token
334   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
335   /// @dev Required for ERC-721 compliance.
336   function takeOwnership(uint256 _tokenId) public {
337     address newOwner = msg.sender;
338     address oldOwner = collectibleIndexToOwner[_tokenId];
339 
340     // Safety check to prevent against an unexpected 0x0 default.
341     require(_addressNotNull(newOwner));
342 
343     // Making sure transfer is approved
344     require(_approved(newOwner, _tokenId));
345 
346     _transfer(oldOwner, newOwner, _tokenId);
347   }
348 
349   /// Owner initates the transfer of the token to another account
350   /// @param _to The address for the token to be transferred to.
351   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
352   /// @dev Required for ERC-721 compliance.
353   function transfer(
354     address _to,
355     uint256 _tokenId
356   ) public {
357     require(_owns(msg.sender, _tokenId));
358     require(_addressNotNull(_to));
359 
360     _transfer(msg.sender, _to, _tokenId);
361   }
362 
363   /// Third-party initiates transfer of token from address _from to address _to
364   /// @param _from The address for the token to be transferred from.
365   /// @param _to The address for the token to be transferred to.
366   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
367   /// @dev Required for ERC-721 compliance.
368   function transferFrom(
369     address _from,
370     address _to,
371     uint256 _tokenId
372   ) public {
373     require(_owns(_from, _tokenId));
374     require(_approved(_to, _tokenId));
375     require(_addressNotNull(_to));
376 
377     _transfer(_from, _to, _tokenId);
378   }
379 
380   /*** PRIVATE FUNCTIONS ***/
381   /// Safety check on _to address to prevent against an unexpected 0x0 default.
382   function _addressNotNull(address _to) private pure returns (bool) {
383     return _to != address(0);
384   }
385 
386   /// For checking approval of transfer for address _to
387   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
388     return collectibleIndexToApproved[_tokenId] == _to;
389   }
390 
391   /// For creating Collectible
392   function _createCollectible(uint256 tokenId, uint256 _price) private {
393     collectibleIndexToPrice[tokenId] = _price;
394     Birth(tokenId, _price);
395     tokens.push(tokenId);
396   }
397 
398   /// Check for token ownership
399   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
400     return claimant == collectibleIndexToOwner[_tokenId];
401   }
402 
403   /// For paying out balance on contract
404   function _payout(address _to) private {
405     if (_to == address(0)) {
406       ceoAddress.transfer(this.balance);
407     } else {
408       _to.transfer(this.balance);
409     }
410   }
411 
412   /// For querying balance of a particular account
413   /// @param _owner The address for balance query
414   /// @dev Required for ERC-721 compliance.
415   function balanceOf(address _owner) public view returns (uint256 result) {
416       uint256 totalTokens = tokens.length;
417       uint256 tokenIndex;
418       uint256 tokenId;
419       result = 0;
420       for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
421         tokenId = tokens[tokenIndex];
422         if (collectibleIndexToOwner[tokenId] == _owner) {
423           result = result.add(1);
424         }
425       }
426       return result;
427   }
428 
429   /// @dev Assigns ownership of a specific Collectible to an address.
430   function _transfer(address _from, address _to, uint256 _tokenId) private {
431     //transfer ownership
432     collectibleIndexToOwner[_tokenId] = _to;
433 
434     // When creating new collectibles _from is 0x0, but we can't account that address.
435     if (_from != address(0)) {
436       // clear any previously approved ownership exchange
437       delete collectibleIndexToApproved[_tokenId];
438     }
439 
440     // Emit the transfer event.
441     Transfer(_from, _to, _tokenId);
442   }
443 
444 
445    /// @param _owner The owner whose celebrity tokens we are interested in.
446   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
447   ///  expensive (it walks the entire tokens array looking for tokens belonging to owner),
448   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
449   ///  not contract-to-contract calls.
450   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
451     uint256 tokenCount = balanceOf(_owner);
452     if (tokenCount == 0) {
453         // Return an empty array
454       return new uint256[](0);
455     } else {
456       uint256[] memory result = new uint256[](tokenCount);
457       uint256 totalTokens = getTotalSupply();
458       uint256 resultIndex = 0;
459 
460       uint256 tokenIndex;
461       uint256 tokenId;
462       for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
463         tokenId = tokens[tokenIndex];
464         if (collectibleIndexToOwner[tokenId] == _owner) {
465           result[resultIndex] = tokenId;
466           resultIndex = resultIndex.add(1);
467         }
468       }
469       return result;
470     }
471   }
472 }