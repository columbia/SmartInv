1 pragma solidity ^0.4.19;
2 
3 contract Soccer {
4   using SafeMath for uint256;
5   /*** EVENTS ***/
6   /// @dev The Birth event is fired whenever a new collectible comes into existence.
7   event Birth(uint256 tokenId, uint256 startPrice);
8   /// @dev The TokenSold event is fired whenever a token is sold.
9   event TokenSold(uint256 indexed tokenId, uint256 price, address prevOwner, address winner);
10   // ERC721 Transfer
11   event Transfer(address indexed from, address indexed to, uint256 tokenId);
12   // ERC721 Approval
13   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
14 
15   /*** CONSTANTS ***/
16 
17   string public constant NAME = "SoccerAllStars";
18   string public constant SYMBOL = "SAS";
19 
20   /*** STORAGE ***/
21   struct Token {
22     address owner;
23     uint256 price;
24   }
25   mapping (uint256 => Token) collectibleIdx;
26   mapping (uint256 => address[3]) mapToLastOwners;
27   mapping (uint256 => address) collectibleIndexToApproved;
28   uint256[] private tokens;
29 
30   // The addresses of the accounts (or contracts) that can execute actions within each roles.
31   address public ceoAddress;
32   address public cooAddress;
33 
34   uint16 constant NATION_INDEX = 1000;
35   uint32 constant CLUB_INDEX = 1000000;
36 
37   uint256 private constant PROMO_CREATION_LIMIT = 50000;
38   uint256 public promoCreatedCount;
39 
40   uint256 constant PLAYER_PRICE = 1 finney;
41   uint256 constant CLUB_PRICE = 10 finney;
42   uint256 constant NATION_PRICE = 100 finney;
43 
44   /*** CONSTRUCTOR ***/
45   function Soccer() public {
46     ceoAddress = msg.sender;
47     cooAddress = msg.sender;
48   }
49   
50   function getTotalSupply() public view returns (uint) {
51     return tokens.length;
52   }
53   
54   function getInitialPriceOfToken(uint _tokenId) public pure returns (uint) {
55     if (_tokenId > CLUB_INDEX)
56       return PLAYER_PRICE;
57     if (_tokenId > NATION_INDEX)
58       return CLUB_PRICE;
59     return NATION_PRICE;
60   }
61 
62   function getNextPrice(uint price, uint _tokenId) public pure returns (uint) {
63     if (price < 0.05 ether)
64       return price.mul(200).div(93); //x2
65     if (price < 0.5 ether)
66       return price.mul(150).div(93); //x1.5
67     if (price < 2 ether)
68       return price.mul(130).div(93); //x1.3
69     return price.mul(120).div(93); //x1.2
70   }
71 
72   function buyToken(uint _tokenId) public payable {
73     require(!isContract(msg.sender));
74     
75     Token memory token = collectibleIdx[_tokenId];
76     address oldOwner = address(0);
77     uint256 sellingPrice;
78     if (token.owner == address(0)) {
79         sellingPrice = getInitialPriceOfToken(_tokenId);
80         token = Token({
81             owner: msg.sender,
82             price: sellingPrice
83         });
84     } else {
85         oldOwner = token.owner;
86         sellingPrice = token.price;
87         require(oldOwner != msg.sender);
88     }
89     require(msg.value >= sellingPrice);
90     
91     address[3] storage lastOwners = mapToLastOwners[_tokenId];
92     uint256 payment = _handle(_tokenId, sellingPrice, lastOwners);
93 
94     // Transfers the Token
95     token.owner = msg.sender;
96     token.price = getNextPrice(sellingPrice, _tokenId);
97     mapToLastOwners[_tokenId] = _addLastOwner(lastOwners, oldOwner);
98 
99     collectibleIdx[_tokenId] = token;
100     if (oldOwner != address(0)) {
101       // Payment for old owner
102       oldOwner.transfer(payment);
103       // clear any previously approved ownership exchange
104       delete collectibleIndexToApproved[_tokenId];
105     } else {
106       Birth(_tokenId, sellingPrice);
107       tokens.push(_tokenId);
108     }
109 
110     TokenSold(_tokenId, sellingPrice, oldOwner, msg.sender);
111     Transfer(oldOwner, msg.sender, _tokenId);
112 
113     // refund when paid too much
114     uint256 purchaseExcess = msg.value.sub(sellingPrice);
115     if (purchaseExcess > 0) {
116         msg.sender.transfer(purchaseExcess);
117     }
118   }
119 
120 function _handle(uint256 _tokenId, uint256 sellingPrice, address[3] lastOwners) private returns (uint256) {
121     uint256 pPrice = sellingPrice.div(100);
122     uint256 tax = pPrice.mul(7); // initial dev cut = 7%
123     if (_tokenId > CLUB_INDEX) {
124         uint256 clubId = _tokenId % CLUB_INDEX;
125         Token storage clubToken = collectibleIdx[clubId];
126         if (clubToken.owner != address(0)) {
127             uint256 clubTax = pPrice.mul(2); // 2% club tax;
128             tax += clubTax;
129             clubToken.owner.transfer(clubTax);
130         }
131 
132         uint256 nationId = clubId % NATION_INDEX;
133         Token storage nationToken = collectibleIdx[nationId];
134         if (nationToken.owner != address(0)) {
135             tax += pPrice; // 1% nation tax;
136             nationToken.owner.transfer(pPrice);
137         }
138     } else if (_tokenId > NATION_INDEX) {
139         nationId = _tokenId % NATION_INDEX;
140         nationToken = collectibleIdx[nationId];
141         if (nationToken.owner != address(0)) {
142             tax += pPrice; // 1% nation tax;
143             nationToken.owner.transfer(pPrice);
144         }
145     }
146 
147     //Pay tax to the previous 3 owners
148     uint256 lastOwnerTax;
149     if (lastOwners[0] != address(0)) {
150       tax += pPrice; // 1% 3rd payment
151       lastOwners[0].transfer(pPrice);
152     }
153     if (lastOwners[1] != address(0)) {
154       lastOwnerTax = pPrice.mul(2); // 2% 2nd payment
155       tax += lastOwnerTax;
156       lastOwners[1].transfer(lastOwnerTax);
157     }
158     if (lastOwners[2] != address(0)) {
159       lastOwnerTax = pPrice.mul(3); // 3% 1st payment
160       tax += lastOwnerTax;
161       lastOwners[2].transfer(lastOwnerTax);
162     }
163 
164     return sellingPrice.sub(tax);
165 }
166 
167 function _addLastOwner(address[3] lastOwners, address oldOwner) pure private returns (address[3]) {
168     lastOwners[0] = lastOwners[1];
169     lastOwners[1] = lastOwners[2];
170     lastOwners[2] = oldOwner;
171     return lastOwners;
172 }
173   /*** ACCESS MODIFIERS ***/
174   /// @dev Access modifier for CEO-only functionality
175   modifier onlyCEO() {
176     require(msg.sender == ceoAddress);
177     _;
178   }
179 
180   /// @dev Access modifier for COO-only functionality
181   modifier onlyCOO() {
182     require(msg.sender == cooAddress);
183     _;
184   }
185 
186   /// Access modifier for contract owner only functionality
187   modifier onlyCLevel() {
188     require( msg.sender == ceoAddress || msg.sender == cooAddress );
189     _;
190   }
191 
192   /*** PUBLIC FUNCTIONS ***/
193   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
194   /// @param _to The address to be granted transfer approval. Pass address(0) to
195   ///  clear all approvals.
196   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
197   /// @dev Required for ERC-721 compliance.
198   function approve(address _to, uint256 _tokenId) public {
199     // Caller must own token.
200     require(_owns(msg.sender, _tokenId));
201 
202     collectibleIndexToApproved[_tokenId] = _to;
203 
204     Approval(msg.sender, _to, _tokenId);
205   }
206 
207   /// @dev Creates a new promo collectible with the given name, with given _price and assignes it to an address.
208   function createPromoCollectible(uint256 tokenId, address _owner, uint256 _price) public onlyCLevel {
209     Token memory token = collectibleIdx[tokenId];
210     require(token.owner == address(0));
211     require(promoCreatedCount < PROMO_CREATION_LIMIT);
212 
213     address collectibleOwner = _owner;
214     if (collectibleOwner == address(0)) {
215       collectibleOwner = cooAddress;
216     }
217 
218     if (_price <= 0) {
219       _price = getInitialPriceOfToken(tokenId);
220     }
221 
222     promoCreatedCount++;
223     token = Token({
224         owner: collectibleOwner,
225         price: _price
226     });
227     collectibleIdx[tokenId] = token;
228     Birth(tokenId, _price);
229     tokens.push(tokenId);
230 
231     // This will assign ownership, and also emit the Transfer event as
232     // per ERC721 draft
233     _transfer(address(0), collectibleOwner, tokenId);
234 
235   }
236 
237   bool isChangePriceLocked = false;
238   // allows owners of tokens to decrease the price of them or if there is no owner the coo can do it
239   function changePrice(uint256 _tokenId, uint256 newPrice) public {
240     require((_owns(msg.sender, _tokenId) && !isChangePriceLocked) || (_owns(address(0), _tokenId) && msg.sender == cooAddress));
241     Token storage token = collectibleIdx[_tokenId];
242     require(newPrice < token.price);
243     token.price = newPrice;
244     collectibleIdx[_tokenId] = token;
245   }
246   function unlockPriceChange() public onlyCLevel {
247     isChangePriceLocked = false;
248   }
249   function lockPriceChange() public onlyCLevel {
250     isChangePriceLocked = true;
251   }
252 
253   /// @notice Returns all the relevant information about a specific collectible.
254   /// @param _tokenId The tokenId of the collectible of interest.
255   function getToken(uint256 _tokenId) public view returns (uint256 tokenId, uint256 sellingPrice, address owner, uint256 nextSellingPrice) {
256     tokenId = _tokenId;
257     Token storage token = collectibleIdx[_tokenId];
258     sellingPrice = token.price;
259     if (sellingPrice == 0)
260       sellingPrice = getInitialPriceOfToken(_tokenId);
261     owner = token.owner;
262     nextSellingPrice = getNextPrice(sellingPrice, _tokenId);
263   }
264 
265   function implementsERC721() public pure returns (bool) {
266     return true;
267   }
268 
269   /// @dev Required for ERC-721 compliance.
270   function name() public pure returns (string) {
271     return NAME;
272   }
273 
274   /// For querying owner of token
275   /// @param _tokenId The tokenID for owner inquiry
276   /// @dev Required for ERC-721 compliance.
277   function ownerOf(uint256 _tokenId)
278     public
279     view
280     returns (address owner)
281   {
282     Token storage token = collectibleIdx[_tokenId];
283     require(token.owner != address(0));
284     owner = token.owner;
285   }
286 
287   function payout(address _to) public onlyCLevel {
288     _payout(_to);
289   }
290 
291 
292   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
293     Token storage token = collectibleIdx[_tokenId];
294     if (token.owner == address(0)) {
295         price = getInitialPriceOfToken(_tokenId);
296     } else {
297         price = token.price;
298     }
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
327     Token storage token = collectibleIdx[_tokenId];
328     require(token.owner != address(0));
329     address oldOwner = token.owner;
330 
331     // Safety check to prevent against an unexpected 0x0 default.
332     require(_addressNotNull(newOwner));
333 
334     // Making sure transfer is approved
335     require(_approved(newOwner, _tokenId));
336 
337     _transfer(oldOwner, newOwner, _tokenId);
338   }
339 
340   /// Owner initates the transfer of the token to another account
341   /// @param _to The address for the token to be transferred to.
342   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
343   /// @dev Required for ERC-721 compliance.
344   function transfer(
345     address _to,
346     uint256 _tokenId
347   ) public {
348     require(_owns(msg.sender, _tokenId));
349     require(_addressNotNull(_to));
350 
351     _transfer(msg.sender, _to, _tokenId);
352   }
353 
354   /// Third-party initiates transfer of token from address _from to address _to
355   /// @param _from The address for the token to be transferred from.
356   /// @param _to The address for the token to be transferred to.
357   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
358   /// @dev Required for ERC-721 compliance.
359   function transferFrom(
360     address _from,
361     address _to,
362     uint256 _tokenId
363   ) public {
364     require(_owns(_from, _tokenId));
365     require(_approved(_to, _tokenId));
366     require(_addressNotNull(_to));
367 
368     _transfer(_from, _to, _tokenId);
369   }
370 
371   /*** PRIVATE FUNCTIONS ***/
372   /// Safety check on _to address to prevent against an unexpected 0x0 default.
373   function _addressNotNull(address _to) private pure returns (bool) {
374     return _to != address(0);
375   }
376 
377   /// For checking approval of transfer for address _to
378   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
379     return collectibleIndexToApproved[_tokenId] == _to;
380   }
381 
382   /// Check for token ownership
383   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
384     Token storage token = collectibleIdx[_tokenId];
385     return claimant == token.owner;
386   }
387 
388   /// For paying out balance on contract
389   function _payout(address _to) private {
390     if (_to == address(0)) {
391       ceoAddress.transfer(this.balance);
392     } else {
393       _to.transfer(this.balance);
394     }
395   }
396 
397   /// For querying balance of a particular account
398   /// @param _owner The address for balance query
399   /// @dev Required for ERC-721 compliance.
400   function balanceOf(address _owner) public view returns (uint256 result) {
401       uint256 totalTokens = tokens.length;
402       uint256 tokenIndex;
403       uint256 tokenId;
404       result = 0;
405       for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
406         tokenId = tokens[tokenIndex];
407         if (collectibleIdx[tokenId].owner == _owner) {
408           result = result.add(1);
409         }
410       }
411       return result;
412   }
413 
414   /// @dev Assigns ownership of a specific Collectible to an address.
415   function _transfer(address _from, address _to, uint256 _tokenId) private {
416     //transfer ownership
417     collectibleIdx[_tokenId].owner = _to;
418 
419     // When creating new collectibles _from is 0x0, but we can't account that address.
420     if (_from != address(0)) {
421       // clear any previously approved ownership exchange
422       delete collectibleIndexToApproved[_tokenId];
423     }
424 
425     // Emit the transfer event.
426     Transfer(_from, _to, _tokenId);
427   }
428 
429 
430    /// @param _owner The owner whose celebrity tokens we are interested in.
431   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
432   ///  expensive (it walks the entire tokens array looking for tokens belonging to owner),
433   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
434   ///  not contract-to-contract calls.
435   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
436     uint256 tokenCount = balanceOf(_owner);
437     if (tokenCount == 0) {
438         // Return an empty array
439       return new uint256[](0);
440     } else {
441       uint256[] memory result = new uint256[](tokenCount);
442       uint256 totalTokens = getTotalSupply();
443       uint256 resultIndex = 0;
444 
445       uint256 tokenIndex;
446       uint256 tokenId;
447       for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
448         tokenId = tokens[tokenIndex];
449         if (collectibleIdx[tokenId].owner == _owner) {
450           result[resultIndex] = tokenId;
451           resultIndex = resultIndex.add(1);
452         }
453       }
454       return result;
455     }
456   }
457 
458     /* Util */
459   function isContract(address addr) private view returns (bool) {
460     uint size;
461     assembly { size := extcodesize(addr) } // solium-disable-line
462     return size > 0;
463   }
464 }
465 
466 
467 
468 library SafeMath {
469 
470   /**
471   * @dev Multiplies two numbers, throws on overflow.
472   */
473   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
474     if (a == 0) {
475       return 0;
476     }
477     uint256 c = a * b;
478     assert(c / a == b);
479     return c;
480   }
481 
482   /**
483   * @dev Integer division of two numbers, truncating the quotient.
484   */
485   function div(uint256 a, uint256 b) internal pure returns (uint256) {
486     // assert(b > 0); // Solidity automatically throws when dividing by 0
487     uint256 c = a / b;
488     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
489     return c;
490   }
491 
492   /**
493   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
494   */
495   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
496     assert(b <= a);
497     return a - b;
498   }
499 
500   /**
501   * @dev Adds two numbers, throws on overflow.
502   */
503   function add(uint256 a, uint256 b) internal pure returns (uint256) {
504     uint256 c = a + b;
505     assert(c >= a);
506     return c;
507   }
508 }