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
84 
85   uint8 constant BASE_TOKEN_ID = 0;
86   uint16 constant MAX_SETS_INDEX = 10000;
87   uint64 constant FIFTY_TOKENS_INDEX = 1000000000000000;
88   uint128 constant TRIBLE_TOKENS_INDEX = 100000000000000000000000;
89   uint128 constant DOUBLE_TOKENS_INDEX = 100000000000000000000000000000000;
90   uint256 private constant PROMO_CREATION_LIMIT = 50000;
91   uint256 public promoCreatedCount;
92   uint256 constant START_PRICE_DOG = 1 finney;
93   uint256 constant START_PRICE_SETS = 100 finney;
94   uint256 constant START_PRICE_BASE_DOG = 10 ether;
95 
96 
97   /*** CONSTRUCTOR ***/
98   function Dogs() public {
99     ceoAddress = msg.sender;
100     cooAddress = msg.sender;
101   }
102   function getTotalSupply() public view returns (uint) {
103     return tokens.length;
104   }
105   function getInitialPriceOfToken(uint _tokenId) public pure returns (uint) {
106     if (_tokenId > MAX_SETS_INDEX)
107       return START_PRICE_DOG;
108     if (_tokenId > 0)
109       return START_PRICE_SETS;
110     return START_PRICE_BASE_DOG;
111   }
112 
113   function getNextPrice(uint price, uint _tokenId) public pure returns (uint) {
114     if (_tokenId>DOUBLE_TOKENS_INDEX)
115       return price.mul(2);
116     if (_tokenId>TRIBLE_TOKENS_INDEX)
117       return price.mul(3);
118     if (_tokenId>FIFTY_TOKENS_INDEX)
119       return price.mul(3).div(2);
120     if (price < 1.2 ether)
121       return price.mul(200).div(92);
122     if (price < 5 ether)
123       return price.mul(150).div(92);
124     return price.mul(120).div(92);
125   }
126 
127   function buyToken(uint _tokenId) public payable {
128     address oldOwner = collectibleIndexToOwner[_tokenId];
129     require(oldOwner!=msg.sender);
130     uint256 sellingPrice = collectibleIndexToPrice[_tokenId];
131     if (sellingPrice==0) {
132       sellingPrice = getInitialPriceOfToken(_tokenId);
133       if (_tokenId>MAX_SETS_INDEX)
134         subTokenCreator[_tokenId] = msg.sender;
135     }
136 
137     require(msg.value >= sellingPrice);
138     uint256 purchaseExcess = msg.value.sub(sellingPrice);
139 
140     uint256 payment = sellingPrice.mul(92).div(100);
141     uint256 feeOnce = sellingPrice.sub(payment).div(8);
142 
143     // transfer taxes
144     if (_tokenId > 0) {
145       if (collectibleIndexToOwner[BASE_TOKEN_ID]!=address(0))
146         collectibleIndexToOwner[BASE_TOKEN_ID].transfer(feeOnce);
147       if (_tokenId > MAX_SETS_INDEX) {
148         if (collectibleIndexToOwner[_tokenId % MAX_SETS_INDEX]!=address(0))
149           collectibleIndexToOwner[_tokenId % MAX_SETS_INDEX].transfer(feeOnce);
150         if (subTokenCreator[_tokenId]!=address(0))
151           subTokenCreator[_tokenId].transfer(feeOnce);
152 
153         lastSubTokenBuyer[BASE_TOKEN_ID] = msg.sender;
154         lastSubTokenBuyer[_tokenId % MAX_SETS_INDEX] = msg.sender;
155       } else {
156         lastSubTokenBuyer[_tokenId].transfer(feeOnce*2);
157       }
158     } else {
159       lastSubTokenBuyer[_tokenId].transfer(feeOnce*2);
160     }
161     // Transfers the Token
162     collectibleIndexToOwner[_tokenId] = msg.sender;
163     if (oldOwner != address(0)) {
164       // Payment for old owner
165       oldOwner.transfer(payment);
166       // clear any previously approved ownership exchange
167       delete collectibleIndexToApproved[_tokenId];
168     } else {
169       Birth(_tokenId, sellingPrice);
170       tokens.push(_tokenId);
171     }
172     // Update prices
173     collectibleIndexToPrice[_tokenId] = getNextPrice(sellingPrice, _tokenId);
174 
175     TokenSold(_tokenId, sellingPrice, oldOwner, msg.sender);
176     Transfer(oldOwner, msg.sender, _tokenId);
177     // refund when paid too much
178     if (purchaseExcess>0)
179       msg.sender.transfer(purchaseExcess);
180   }
181 
182 
183 
184   /*** ACCESS MODIFIERS ***/
185   /// @dev Access modifier for CEO-only functionality
186   modifier onlyCEO() {
187     require(msg.sender == ceoAddress);
188     _;
189   }
190 
191   /// @dev Access modifier for COO-only functionality
192   modifier onlyCOO() {
193     require(msg.sender == cooAddress);
194     _;
195   }
196 
197   /// Access modifier for contract owner only functionality
198   modifier onlyCLevel() {
199     require(
200       msg.sender == ceoAddress ||
201       msg.sender == cooAddress
202     );
203     _;
204   }
205 
206   /*** PUBLIC FUNCTIONS ***/
207   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
208   /// @param _to The address to be granted transfer approval. Pass address(0) to
209   ///  clear all approvals.
210   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
211   /// @dev Required for ERC-721 compliance.
212   function approve(
213     address _to,
214     uint256 _tokenId
215   ) public {
216     // Caller must own token.
217     require(_owns(msg.sender, _tokenId));
218 
219     collectibleIndexToApproved[_tokenId] = _to;
220 
221     Approval(msg.sender, _to, _tokenId);
222   }
223 
224   /// @dev Creates a new promo collectible with the given name, with given _price and assignes it to an address.
225   function createPromoCollectible(uint256 tokenId, address _owner, uint256 _price) public onlyCOO {
226     require(collectibleIndexToOwner[tokenId]==address(0));
227     require(promoCreatedCount < PROMO_CREATION_LIMIT);
228 
229     address collectibleOwner = _owner;
230     if (collectibleOwner == address(0)) {
231       collectibleOwner = cooAddress;
232     }
233 
234     if (_price <= 0) {
235       _price = getInitialPriceOfToken(tokenId);
236     }
237 
238     promoCreatedCount++;
239     _createCollectible(tokenId, _price);
240     subTokenCreator[tokenId] = collectibleOwner;
241     // This will assign ownership, and also emit the Transfer event as
242     // per ERC721 draft
243     _transfer(address(0), collectibleOwner, tokenId);
244 
245   }
246 
247   bool isChangePriceLocked = true;
248   // allows owners of tokens to decrease the price of them or if there is no owner the coo can do it
249   function changePrice(uint256 newPrice, uint256 _tokenId) public {
250     require((_owns(msg.sender, _tokenId) && !isChangePriceLocked) || (_owns(address(0), _tokenId) && msg.sender == cooAddress));
251     require(newPrice<collectibleIndexToPrice[_tokenId]);
252     collectibleIndexToPrice[_tokenId] = newPrice;
253   }
254   function unlockPriceChange() public onlyCOO {
255     isChangePriceLocked = false;
256   }
257 
258   /// @notice Returns all the relevant information about a specific collectible.
259   /// @param _tokenId The tokenId of the collectible of interest.
260   function getToken(uint256 _tokenId) public view returns (uint256 tokenId, uint256 sellingPrice, address owner, uint256 nextSellingPrice) {
261     tokenId = _tokenId;
262     sellingPrice = collectibleIndexToPrice[_tokenId];
263     if (sellingPrice == 0)
264       sellingPrice = getInitialPriceOfToken(_tokenId);
265     owner = collectibleIndexToOwner[_tokenId];
266     nextSellingPrice = getNextPrice(sellingPrice, _tokenId);
267   }
268 
269   function implementsERC721() public pure returns (bool) {
270     return true;
271   }
272 
273   /// @dev Required for ERC-721 compliance.
274   function name() public pure returns (string) {
275     return NAME;
276   }
277 
278   /// For querying owner of token
279   /// @param _tokenId The tokenID for owner inquiry
280   /// @dev Required for ERC-721 compliance.
281   function ownerOf(uint256 _tokenId)
282     public
283     view
284     returns (address owner)
285   {
286     owner = collectibleIndexToOwner[_tokenId];
287     require(owner != address(0));
288   }
289 
290   function payout(address _to) public onlyCLevel {
291     _payout(_to);
292   }
293 
294 
295   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
296     price = collectibleIndexToPrice[_tokenId];
297     if (price == 0)
298       price = getInitialPriceOfToken(_tokenId);
299   }
300 
301   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
302   /// @param _newCEO The address of the new CEO
303   function setCEO(address _newCEO) public onlyCEO {
304     require(_newCEO != address(0));
305 
306     ceoAddress = _newCEO;
307   }
308 
309   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
310   /// @param _newCOO The address of the new COO
311   function setCOO(address _newCOO) public onlyCEO {
312     require(_newCOO != address(0));
313 
314     cooAddress = _newCOO;
315   }
316 
317   /// @dev Required for ERC-721 compliance.
318   function symbol() public pure returns (string) {
319     return SYMBOL;
320   }
321 
322   /// @notice Allow pre-approved user to take ownership of a token
323   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
324   /// @dev Required for ERC-721 compliance.
325   function takeOwnership(uint256 _tokenId) public {
326     address newOwner = msg.sender;
327     address oldOwner = collectibleIndexToOwner[_tokenId];
328 
329     // Safety check to prevent against an unexpected 0x0 default.
330     require(_addressNotNull(newOwner));
331 
332     // Making sure transfer is approved
333     require(_approved(newOwner, _tokenId));
334 
335     _transfer(oldOwner, newOwner, _tokenId);
336   }
337 
338   /// Owner initates the transfer of the token to another account
339   /// @param _to The address for the token to be transferred to.
340   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
341   /// @dev Required for ERC-721 compliance.
342   function transfer(
343     address _to,
344     uint256 _tokenId
345   ) public {
346     require(_owns(msg.sender, _tokenId));
347     require(_addressNotNull(_to));
348 
349     _transfer(msg.sender, _to, _tokenId);
350   }
351 
352   /// Third-party initiates transfer of token from address _from to address _to
353   /// @param _from The address for the token to be transferred from.
354   /// @param _to The address for the token to be transferred to.
355   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
356   /// @dev Required for ERC-721 compliance.
357   function transferFrom(
358     address _from,
359     address _to,
360     uint256 _tokenId
361   ) public {
362     require(_owns(_from, _tokenId));
363     require(_approved(_to, _tokenId));
364     require(_addressNotNull(_to));
365 
366     _transfer(_from, _to, _tokenId);
367   }
368 
369   /*** PRIVATE FUNCTIONS ***/
370   /// Safety check on _to address to prevent against an unexpected 0x0 default.
371   function _addressNotNull(address _to) private pure returns (bool) {
372     return _to != address(0);
373   }
374 
375   /// For checking approval of transfer for address _to
376   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
377     return collectibleIndexToApproved[_tokenId] == _to;
378   }
379 
380   /// For creating Collectible
381   function _createCollectible(uint256 tokenId, uint256 _price) private {
382     collectibleIndexToPrice[tokenId] = _price;
383     Birth(tokenId, _price);
384     tokens.push(tokenId);
385   }
386 
387   /// Check for token ownership
388   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
389     return claimant == collectibleIndexToOwner[_tokenId];
390   }
391 
392   /// For paying out balance on contract
393   function _payout(address _to) private {
394     if (_to == address(0)) {
395       ceoAddress.transfer(this.balance);
396     } else {
397       _to.transfer(this.balance);
398     }
399   }
400 
401   /// For querying balance of a particular account
402   /// @param _owner The address for balance query
403   /// @dev Required for ERC-721 compliance.
404   function balanceOf(address _owner) public view returns (uint256 result) {
405       uint256 totalTokens = tokens.length;
406       uint256 tokenIndex;
407       uint256 tokenId;
408       result = 0;
409       for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
410         tokenId = tokens[tokenIndex];
411         if (collectibleIndexToOwner[tokenId] == _owner) {
412           result = result.add(1);
413         }
414       }
415       return result;
416   }
417 
418   /// @dev Assigns ownership of a specific Collectible to an address.
419   function _transfer(address _from, address _to, uint256 _tokenId) private {
420     //transfer ownership
421     collectibleIndexToOwner[_tokenId] = _to;
422 
423     // When creating new collectibles _from is 0x0, but we can't account that address.
424     if (_from != address(0)) {
425       // clear any previously approved ownership exchange
426       delete collectibleIndexToApproved[_tokenId];
427     }
428 
429     // Emit the transfer event.
430     Transfer(_from, _to, _tokenId);
431   }
432 
433 
434    /// @param _owner The owner whose celebrity tokens we are interested in.
435   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
436   ///  expensive (it walks the entire tokens array looking for tokens belonging to owner),
437   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
438   ///  not contract-to-contract calls.
439   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
440     uint256 tokenCount = balanceOf(_owner);
441     if (tokenCount == 0) {
442         // Return an empty array
443       return new uint256[](0);
444     } else {
445       uint256[] memory result = new uint256[](tokenCount);
446       uint256 totalTokens = getTotalSupply();
447       uint256 resultIndex = 0;
448 
449       uint256 tokenIndex;
450       uint256 tokenId;
451       for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
452         tokenId = tokens[tokenIndex];
453         if (collectibleIndexToOwner[tokenId] == _owner) {
454           result[resultIndex] = tokenId;
455           resultIndex = resultIndex.add(1);
456         }
457       }
458       return result;
459     }
460   }
461 }