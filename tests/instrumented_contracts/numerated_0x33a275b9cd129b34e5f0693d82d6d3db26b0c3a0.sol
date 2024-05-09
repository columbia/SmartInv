1 pragma solidity ^0.4.18;
2 
3 
4 contract InterfaceContentCreatorUniverse {
5   function ownerOf(uint256 _tokenId) public view returns (address _owner);
6   function priceOf(uint256 _tokenId) public view returns (uint256 price);
7   function getNextPrice(uint price, uint _tokenId) public pure returns (uint);
8   function lastSubTokenBuyerOf(uint tokenId) public view returns(address);
9   function lastSubTokenCreatorOf(uint tokenId) public view returns(address);
10 
11   //
12   function createCollectible(uint256 tokenId, uint256 _price, address creator, address owner) external ;
13 }
14 
15 contract InterfaceYCC {
16   function payForUpgrade(address user, uint price) external  returns (bool success);
17   function mintCoinsForOldCollectibles(address to, uint256 amount, address universeOwner) external  returns (bool success);
18   function tradePreToken(uint price, address buyer, address seller, uint burnPercent, address universeOwner) external;
19   function payoutForMining(address user, uint amount) external;
20   uint256 public totalSupply;
21 }
22 
23 contract InterfaceMining {
24   function createMineForToken(uint tokenId, uint level, uint xp, uint nextLevelBreak, uint blocknumber) external;
25   function payoutMining(uint tokenId, address owner, address newOwner) external;
26   function levelUpMining(uint tokenId) external;
27 }
28 
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   /**
54   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 contract Owned {
72   // The addresses of the accounts (or contracts) that can execute actions within each roles.
73   address public ceoAddress;
74   address public cooAddress;
75   address private newCeoAddress;
76   address private newCooAddress;
77 
78 
79   function Owned() public {
80       ceoAddress = msg.sender;
81       cooAddress = msg.sender;
82   }
83 
84   /*** ACCESS MODIFIERS ***/
85   /// @dev Access modifier for CEO-only functionality
86   modifier onlyCEO() {
87     require(msg.sender == ceoAddress);
88     _;
89   }
90 
91   /// @dev Access modifier for COO-only functionality
92   modifier onlyCOO() {
93     require(msg.sender == cooAddress);
94     _;
95   }
96 
97   /// Access modifier for contract owner only functionality
98   modifier onlyCLevel() {
99     require(
100       msg.sender == ceoAddress ||
101       msg.sender == cooAddress
102     );
103     _;
104   }
105 
106   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
107   /// @param _newCEO The address of the new CEO
108   function setCEO(address _newCEO) public onlyCEO {
109     require(_newCEO != address(0));
110     newCeoAddress = _newCEO;
111   }
112 
113   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
114   /// @param _newCOO The address of the new COO
115   function setCOO(address _newCOO) public onlyCEO {
116     require(_newCOO != address(0));
117     newCooAddress = _newCOO;
118   }
119 
120   function acceptCeoOwnership() public {
121       require(msg.sender == newCeoAddress);
122       require(address(0) != newCeoAddress);
123       ceoAddress = newCeoAddress;
124       newCeoAddress = address(0);
125   }
126 
127   function acceptCooOwnership() public {
128       require(msg.sender == newCooAddress);
129       require(address(0) != newCooAddress);
130       cooAddress = newCooAddress;
131       newCooAddress = address(0);
132   }
133 
134   mapping (address => bool) public youCollectContracts;
135   function addYouCollectContract(address contractAddress, bool active) public onlyCOO {
136     youCollectContracts[contractAddress] = active;
137   }
138   modifier onlyYCC() {
139     require(youCollectContracts[msg.sender]);
140     _;
141   }
142 
143   InterfaceYCC ycc;
144   InterfaceContentCreatorUniverse yct;
145   InterfaceMining ycm;
146   function setMainYouCollectContractAddresses(address yccContract, address yctContract, address ycmContract, address[] otherContracts) public onlyCOO {
147     ycc = InterfaceYCC(yccContract);
148     yct = InterfaceContentCreatorUniverse(yctContract);
149     ycm = InterfaceMining(ycmContract);
150     youCollectContracts[yccContract] = true;
151     youCollectContracts[yctContract] = true;
152     youCollectContracts[ycmContract] = true;
153     for (uint16 index = 0; index < otherContracts.length; index++) {
154       youCollectContracts[otherContracts[index]] = true;
155     }
156   }
157   function setYccContractAddress(address yccContract) public onlyCOO {
158     ycc = InterfaceYCC(yccContract);
159     youCollectContracts[yccContract] = true;
160   }
161   function setYctContractAddress(address yctContract) public onlyCOO {
162     yct = InterfaceContentCreatorUniverse(yctContract);
163     youCollectContracts[yctContract] = true;
164   }
165   function setYcmContractAddress(address ycmContract) public onlyCOO {
166     ycm = InterfaceMining(ycmContract);
167     youCollectContracts[ycmContract] = true;
168   }
169 
170 }
171 
172 contract TransferInterfaceERC721YC {
173   function transferToken(address to, uint256 tokenId) public returns (bool success);
174 }
175 contract TransferInterfaceERC20 {
176   function transfer(address to, uint tokens) public returns (bool success);
177 }
178 
179 // ----------------------------------------------------------------------------
180 // ERC Token Standard #20 Interface
181 // https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20.sol
182 // ----------------------------------------------------------------------------
183 contract YouCollectBase is Owned {
184   using SafeMath for uint256;
185 
186   event RedButton(uint value, uint totalSupply);
187 
188   // Payout
189   function payout(address _to) public onlyCLevel {
190     _payout(_to, this.balance);
191   }
192   function payout(address _to, uint amount) public onlyCLevel {
193     if (amount>this.balance)
194       amount = this.balance;
195     _payout(_to, amount);
196   }
197   function _payout(address _to, uint amount) private {
198     if (_to == address(0)) {
199       ceoAddress.transfer(amount);
200     } else {
201       _to.transfer(amount);
202     }
203   }
204 
205   // ------------------------------------------------------------------------
206   // Owner can transfer out any accidentally sent ERC20 tokens
207   // ------------------------------------------------------------------------
208   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyCEO returns (bool success) {
209       return TransferInterfaceERC20(tokenAddress).transfer(ceoAddress, tokens);
210   }
211 }
212 
213 // ----------------------------------------------------------------------------
214 // Contract function to receive approval and execute function in one call
215 // ----------------------------------------------------------------------------
216 contract ApproveAndCallFallBack {
217     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
218 }
219 
220 contract ERC721YC is YouCollectBase {
221   //
222   // ERC721
223 
224     /*** STORAGE ***/
225     string public constant NAME = "YouCollectTokens";
226     string public constant SYMBOL = "YCT";
227     uint256[] public tokens;
228 
229     /// @dev A mapping from collectible IDs to the address that owns them. All collectibles have
230     ///  some valid owner address.
231     mapping (uint256 => address) public tokenIndexToOwner;
232 
233     /// @dev A mapping from CollectibleIDs to an address that has been approved to call
234     ///  transferFrom(). Each Collectible can only have one approved address for transfer
235     ///  at any time. A zero value means no approval is outstanding.
236     mapping (uint256 => address) public tokenIndexToApproved;
237 
238     // @dev A mapping from CollectibleIDs to the price of the token.
239     mapping (uint256 => uint256) public tokenIndexToPrice;
240 
241     /*** EVENTS ***/
242     /// @dev The Birth event is fired whenever a new collectible comes into existence.
243     event Birth(uint256 tokenId, uint256 startPrice);
244     /// @dev The TokenSold event is fired whenever a token is sold.
245     event TokenSold(uint256 indexed tokenId, uint256 price, address prevOwner, address winner);
246     // ERC721 Transfer
247     event Transfer(address indexed from, address indexed to, uint256 tokenId);
248     // ERC721 Approval
249     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
250 
251     /*** PUBLIC FUNCTIONS ***/
252     /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
253     /// @param _to The address to be granted transfer approval. Pass address(0) to
254     ///  clear all approvals.
255     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
256     /// @dev Required for ERC-721 compliance.
257     function approveToken(
258       address _to,
259       uint256 _tokenId
260     ) public returns (bool) {
261       // Caller must own token.
262       require(_ownsToken(msg.sender, _tokenId));
263 
264       tokenIndexToApproved[_tokenId] = _to;
265 
266       Approval(msg.sender, _to, _tokenId);
267       return true;
268     }
269 
270 
271     function getTotalSupply() public view returns (uint) {
272       return tokens.length;
273     }
274 
275     function implementsERC721() public pure returns (bool) {
276       return true;
277     }
278 
279 
280     /// For querying owner of token
281     /// @param _tokenId The tokenID for owner inquiry
282     /// @dev Required for ERC-721 compliance.
283     function ownerOf(uint256 _tokenId)
284       public
285       view
286       returns (address owner)
287     {
288       owner = tokenIndexToOwner[_tokenId];
289     }
290 
291 
292     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
293       price = tokenIndexToPrice[_tokenId];
294     }
295 
296 
297     /// @notice Allow pre-approved user to take ownership of a token
298     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
299     /// @dev Required for ERC-721 compliance.
300     function takeOwnership(uint256 _tokenId) public {
301       address newOwner = msg.sender;
302       address oldOwner = tokenIndexToOwner[_tokenId];
303 
304       // Safety check to prevent against an unexpected 0x0 default.
305       require(newOwner != address(0));
306 
307       // Making sure transfer is approved
308       require(_approved(newOwner, _tokenId));
309 
310       _transfer(oldOwner, newOwner, _tokenId);
311     }
312 
313     /// Owner initates the transfer of the token to another account
314     /// @param _to The address for the token to be transferred to.
315     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
316     /// @dev Required for ERC-721 compliance.
317     function transfer(
318       address _to,
319       uint256 _tokenId
320     ) public returns (bool) {
321       require(_ownsToken(msg.sender, _tokenId));
322       _transfer(msg.sender, _to, _tokenId);
323       return true;
324     }
325 
326     /// Third-party initiates transfer of token from address _from to address _to
327     /// @param _from The address for the token to be transferred from.
328     /// @param _to The address for the token to be transferred to.
329     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
330     /// @dev Required for ERC-721 compliance.
331     function transferFrom(
332       address _from,
333       address _to,
334       uint256 _tokenId
335     ) public returns (bool) {
336       require(_ownsToken(_from, _tokenId));
337       require(_approved(_to, _tokenId));
338 
339       _transfer(_from, _to, _tokenId);
340       return true;
341     }
342 
343 
344     /// For checking approval of transfer for address _to
345     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
346       return tokenIndexToApproved[_tokenId] == _to;
347     }
348 
349     /// Check for token ownership
350     function _ownsToken(address claimant, uint256 _tokenId) internal view returns (bool) {
351       return claimant == tokenIndexToOwner[_tokenId];
352     }
353     // For Upcoming Price Change Features
354     function changeTokenPrice(uint256 newPrice, uint256 _tokenId) external onlyYCC {
355       tokenIndexToPrice[_tokenId] = newPrice;
356     }
357 
358     /// For querying balance of a particular account
359     /// @param _owner The address for balance query
360     /// @dev Required for ERC-721 compliance.
361     function balanceOf(address _owner) public view returns (uint256 result) {
362         uint256 totalTokens = tokens.length;
363         uint256 tokenIndex;
364         uint256 tokenId;
365         result = 0;
366         for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
367           tokenId = tokens[tokenIndex];
368           if (tokenIndexToOwner[tokenId] == _owner) {
369             result++;
370           }
371         }
372         return result;
373     }
374 
375     /// @dev Assigns ownership of a specific Collectible to an address.
376     function _transfer(address _from, address _to, uint256 _tokenId) internal {
377       //transfer ownership
378       tokenIndexToOwner[_tokenId] = _to;
379 
380       // When creating new collectibles _from is 0x0, but we can't account that address.
381       if (_from != address(0)) {
382         // clear any previously approved ownership exchange
383         delete tokenIndexToApproved[_tokenId];
384       }
385 
386       // Emit the transfer event.
387       Transfer(_from, _to, _tokenId);
388     }
389 
390 
391     /// @param _owner The owner whose celebrity tokens we are interested in.
392     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
393     ///  expensive (it walks the entire tokens array looking for tokens belonging to owner),
394     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
395     ///  not contract-to-contract calls.
396     function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
397       uint256 tokenCount = balanceOf(_owner);
398       if (tokenCount == 0) {
399           // Return an empty array
400         return new uint256[](0);
401       } else {
402         uint256[] memory result = new uint256[](tokenCount);
403         uint256 totalTokens = getTotalSupply();
404         uint256 resultIndex = 0;
405 
406         uint256 tokenIndex;
407         uint256 tokenId;
408         for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
409           tokenId = tokens[tokenIndex];
410           if (tokenIndexToOwner[tokenId] == _owner) {
411             result[resultIndex] = tokenId;
412             resultIndex = resultIndex.add(1);
413           }
414         }
415         return result;
416       }
417     }
418 
419 
420       // uint256[] storage _result = new uint256[]();
421       // uint256 totalTokens = getTotalSupply();
422 
423       // for (uint256 tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
424       //   if (tokenIndexToOwner[tokens[tokenIndex]] == _owner) {
425       //     _result.push(tokens[tokenIndex]);
426       //   }
427       // }
428       // return _result;
429 
430 
431     /// @dev returns an array with all token ids
432     function getTokenIds() public view returns(uint256[]) {
433       return tokens;
434     }
435 
436   //
437   //  ERC721 end
438   //
439 }
440 
441 contract Universe is ERC721YC {
442 
443   mapping (uint => address) private subTokenCreator;
444   mapping (uint => address) private lastSubTokenBuyer;
445 
446   uint16 constant MAX_WORLD_INDEX = 1000;
447   uint24 constant MAX_CONTINENT_INDEX = 10000000;
448   uint64 constant MAX_SUBCONTINENT_INDEX = 10000000000000;
449   uint64 constant MAX_COUNTRY_INDEX = 10000000000000000000;
450   uint128 constant FIFTY_TOKENS_INDEX = 100000000000000000000000000000000;
451   uint256 constant TRIBLE_TOKENS_INDEX = 1000000000000000000000000000000000000000000000;
452   uint256 constant DOUBLE_TOKENS_INDEX = 10000000000000000000000000000000000000000000000000000000000;
453   uint8 constant UNIVERSE_TOKEN_ID = 0;
454   uint public minSelfBuyPrice = 10 ether;
455   uint public minPriceForMiningUpgrade = 5 ether;
456 
457   /*** CONSTRUCTOR ***/
458   function Universe() public {
459   }
460 
461   function changePriceLimits(uint _minSelfBuyPrice, uint _minPriceForMiningUpgrade) public onlyCOO {
462     minSelfBuyPrice = _minSelfBuyPrice;
463     minPriceForMiningUpgrade = _minPriceForMiningUpgrade;
464   }
465 
466   function getNextPrice(uint price, uint _tokenId) public pure returns (uint) {
467     if (_tokenId>DOUBLE_TOKENS_INDEX)
468       return price.mul(2);
469     if (_tokenId>TRIBLE_TOKENS_INDEX)
470       return price.mul(3);
471     if (_tokenId>FIFTY_TOKENS_INDEX)
472       return price.mul(3).div(2);
473     if (price < 1.2 ether)
474       return price.mul(200).div(91);
475     if (price < 5 ether)
476       return price.mul(150).div(91);
477     return price.mul(120).div(91);
478   }
479 
480 
481   function buyToken(uint _tokenId) public payable {
482     address oldOwner = tokenIndexToOwner[_tokenId];
483     uint256 sellingPrice = tokenIndexToPrice[_tokenId];
484     require(oldOwner!=msg.sender || sellingPrice > minSelfBuyPrice);
485     require(msg.value >= sellingPrice);
486     require(sellingPrice > 0);
487 
488     uint256 purchaseExcess = msg.value.sub(sellingPrice);
489     uint256 payment = sellingPrice.mul(91).div(100);
490     uint256 feeOnce = sellingPrice.sub(payment).div(9);
491 
492     // Update prices
493     tokenIndexToPrice[_tokenId] = getNextPrice(sellingPrice, _tokenId);
494     // Transfers the Token
495     tokenIndexToOwner[_tokenId] = msg.sender;
496     // clear any previously approved ownership exchange
497     delete tokenIndexToApproved[_tokenId];
498     // payout mining reward
499     if (_tokenId>MAX_SUBCONTINENT_INDEX) {
500       ycm.payoutMining(_tokenId, oldOwner, msg.sender);
501       if (sellingPrice > minPriceForMiningUpgrade)
502         ycm.levelUpMining(_tokenId);
503     }
504 
505     if (_tokenId > 0) {
506       // Taxes for Universe owner
507       if (tokenIndexToOwner[UNIVERSE_TOKEN_ID]!=address(0))
508         tokenIndexToOwner[UNIVERSE_TOKEN_ID].transfer(feeOnce);
509       if (_tokenId > MAX_WORLD_INDEX) {
510         // Taxes for world owner
511         if (tokenIndexToOwner[_tokenId % MAX_WORLD_INDEX]!=address(0))
512           tokenIndexToOwner[_tokenId % MAX_WORLD_INDEX].transfer(feeOnce);
513         if (_tokenId > MAX_CONTINENT_INDEX) {
514           // Taxes for continent owner
515           if (tokenIndexToOwner[_tokenId % MAX_CONTINENT_INDEX]!=address(0))
516             tokenIndexToOwner[_tokenId % MAX_CONTINENT_INDEX].transfer(feeOnce);
517           if (_tokenId > MAX_SUBCONTINENT_INDEX) {
518             // Taxes for subcontinent owner
519             if (tokenIndexToOwner[_tokenId % MAX_SUBCONTINENT_INDEX]!=address(0))
520               tokenIndexToOwner[_tokenId % MAX_SUBCONTINENT_INDEX].transfer(feeOnce);
521             if (_tokenId > MAX_COUNTRY_INDEX) {
522               // Taxes for country owner
523               if (tokenIndexToOwner[_tokenId % MAX_COUNTRY_INDEX]!=address(0))
524                 tokenIndexToOwner[_tokenId % MAX_COUNTRY_INDEX].transfer(feeOnce);
525               lastSubTokenBuyer[UNIVERSE_TOKEN_ID] = msg.sender;
526               lastSubTokenBuyer[_tokenId % MAX_WORLD_INDEX] = msg.sender;
527               lastSubTokenBuyer[_tokenId % MAX_CONTINENT_INDEX] = msg.sender;
528               lastSubTokenBuyer[_tokenId % MAX_SUBCONTINENT_INDEX] = msg.sender;
529               lastSubTokenBuyer[_tokenId % MAX_COUNTRY_INDEX] = msg.sender;
530             } else {
531               if (lastSubTokenBuyer[_tokenId] != address(0))
532                 lastSubTokenBuyer[_tokenId].transfer(feeOnce*2);
533             }
534           } else {
535             if (lastSubTokenBuyer[_tokenId] != address(0))
536               lastSubTokenBuyer[_tokenId].transfer(feeOnce*2);
537           }
538         } else {
539           if (lastSubTokenBuyer[_tokenId] != address(0))
540             lastSubTokenBuyer[_tokenId].transfer(feeOnce*2);
541         }
542       } else {
543         if (lastSubTokenBuyer[_tokenId] != address(0))
544           lastSubTokenBuyer[_tokenId].transfer(feeOnce*2);
545       }
546     } else {
547       if (lastSubTokenBuyer[_tokenId] != address(0))
548         lastSubTokenBuyer[_tokenId].transfer(feeOnce*2);
549     }
550     // Taxes for collectible creator (first owner)
551     if (subTokenCreator[_tokenId]!=address(0))
552       subTokenCreator[_tokenId].transfer(feeOnce);
553     // Payment for old owner
554     if (oldOwner != address(0)) {
555       oldOwner.transfer(payment);
556     }
557 
558     TokenSold(_tokenId, sellingPrice, oldOwner, msg.sender);
559     Transfer(oldOwner, msg.sender, _tokenId);
560     // refund when paid too much
561     if (purchaseExcess>0)
562       msg.sender.transfer(purchaseExcess);
563   }
564   
565   /// For creating Collectible
566   function createCollectible(uint256 tokenId, uint256 _price, address creator, address owner) external onlyYCC {
567     tokenIndexToPrice[tokenId] = _price;
568     tokenIndexToOwner[tokenId] = owner;
569     subTokenCreator[tokenId] = creator;
570     Birth(tokenId, _price);
571     tokens.push(tokenId);
572   }
573 
574   function lastSubTokenBuyerOf(uint tokenId) public view returns(address) {
575     return lastSubTokenBuyer[tokenId];
576   }
577   function lastSubTokenCreatorOf(uint tokenId) public view returns(address) {
578     return subTokenCreator[tokenId];
579   }
580 
581 }