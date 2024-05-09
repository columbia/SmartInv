1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
5 contract ERC721 {
6   // Required methods
7   function approve(address _to, uint256 _tokenId) public;
8   function balanceOf(address _owner) public view returns (uint256 balance);
9   function implementsERC721() public pure returns (bool);
10   function ownerOf(uint256 _tokenId) public view returns (address addr);
11   function takeOwnership(uint256 _tokenId) public;
12   function totalSupply() public view returns (uint256 total);
13   function transferFrom(address _from, address _to, uint256 _tokenId) public;
14   function transfer(address _to, uint256 _tokenId) public;
15 
16   event Transfer(address indexed from, address indexed to, uint256 tokenId);
17   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
18 
19   // Optional
20   // function name() public view returns (string name);
21   // function symbol() public view returns (string symbol);
22   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
23   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
24 }
25 
26 contract EtherNumbers is ERC721 {
27 
28   /*** EVENTS ***/
29 
30   /// @dev The Birth event is fired whenever a new Gem comes into existence.
31   event Birth(uint256 tokenId, string name, address owner);
32 
33   /// @dev The TokenSold event is fired whenever a token is sold.
34   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
35 
36   /// @dev Transfer event as defined in current draft of ERC721.
37   ///  ownership is assigned, including births.
38   event Transfer(address from, address to, uint256 tokenId);
39 
40   /*** CONSTANTS ***/
41 
42   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
43   string public constant NAME = "EtherNumbers"; // solhint-disable-line
44   string public constant SYMBOL = "NumberToken"; // solhint-disable-line
45 
46   uint256 private startingPrice = 0.001 ether;
47   uint256 private constant PROMO_CREATION_LIMIT = 10000;
48   uint256 private firstStepLimit =  0.053613 ether;
49   uint256 private secondStepLimit = 0.564957 ether;
50 
51   /*** STORAGE ***/
52 
53   /// @dev A mapping from gem IDs to the address that owns them. All gems have
54   ///  some valid owner address.
55   mapping (uint256 => address) public gemIndexToOwner;
56 
57   // @dev A mapping from owner address to count of tokens that address owns.
58   //  Used internally inside balanceOf() to resolve ownership count.
59   mapping (address => uint256) private ownershipTokenCount;
60 
61   /// @dev A mapping from GemIDs to an address that has been approved to call
62   ///  transferFrom(). Each Gem can only have one approved address for transfer
63   ///  at any time. A zero value means no approval is outstanding.
64   mapping (uint256 => address) public gemIndexToApproved;
65 
66   // @dev A mapping from GemIDs to the price of the token.
67   mapping (uint256 => uint256) private gemIndexToPrice;
68 
69   // The addresses of the accounts (or contracts) that can execute actions within each roles.
70   address public ceoAddress;
71   address public cooAddress;
72 
73   uint256 public promoCreatedCount;
74 
75   /*** DATATYPES ***/
76   struct Gem {
77     string name;
78   }
79 
80   Gem[] private gems;
81 
82   /*** ACCESS MODIFIERS ***/
83   /// @dev Access modifier for CEO-only functionality
84   modifier onlyCEO() {
85     require(msg.sender == ceoAddress);
86     _;
87   }
88 
89   /// @dev Access modifier for COO-only functionality
90   modifier onlyCOO() {
91     require(msg.sender == cooAddress);
92     _;
93   }
94 
95   /// Access modifier for contract owner only functionality
96   modifier onlyCLevel() {
97     require(
98       msg.sender == ceoAddress ||
99       msg.sender == cooAddress
100     );
101     _;
102   }
103 
104   /*** CONSTRUCTOR ***/
105   function EtherNumbers() public {
106     ceoAddress = msg.sender;
107     cooAddress = msg.sender;
108   }
109 
110   /*** PUBLIC FUNCTIONS ***/
111   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
112   /// @param _to The address to be granted transfer approval. Pass address(0) to
113   ///  clear all approvals.
114   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
115   /// @dev Required for ERC-721 compliance.
116   function approve(
117     address _to,
118     uint256 _tokenId
119   ) public {
120     // Caller must own token.
121     require(_owns(msg.sender, _tokenId));
122 
123     gemIndexToApproved[_tokenId] = _to;
124 
125     Approval(msg.sender, _to, _tokenId);
126   }
127 
128   /// For querying balance of a particular account
129   /// @param _owner The address for balance query
130   /// @dev Required for ERC-721 compliance.
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return ownershipTokenCount[_owner];
133   }
134 
135   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
136   function createPromoNumber(address _owner, string _name, uint256 _price) public onlyCOO {
137     require(promoCreatedCount < PROMO_CREATION_LIMIT);
138 
139     address personOwner = _owner;
140     if (personOwner == address(0)) {
141       personOwner = cooAddress;
142     }
143 
144     if (_price <= 0) {
145       _price = startingPrice;
146     }
147 
148     promoCreatedCount++;
149     _createGem(_name, personOwner, _price);
150   }
151 
152 
153   /// @dev Creates a new Gem with the given name.
154   function createContractGem(string _name) public onlyCLevel {
155     _createGem(_name, address(this), startingPrice);
156   }
157 
158   /// @notice Returns all the relevant information about a specific gem.
159   /// @param _tokenId The tokenId of the gem of interest.
160   function getGem(uint256 _tokenId) public view returns (
161     string gemName,
162     uint256 sellingPrice,
163     address owner
164   ) {
165     Gem storage gem = gems[_tokenId];
166     gemName = gem.name;
167     sellingPrice = gemIndexToPrice[_tokenId];
168     owner = gemIndexToOwner[_tokenId];
169   }
170 
171   function implementsERC721() public pure returns (bool) {
172     return true;
173   }
174 
175   /// @dev Required for ERC-721 compliance.
176   function name() public pure returns (string) {
177     return NAME;
178   }
179 
180   /// For querying owner of token
181   /// @param _tokenId The tokenID for owner inquiry
182   /// @dev Required for ERC-721 compliance.
183   function ownerOf(uint256 _tokenId)
184     public
185     view
186     returns (address owner)
187   {
188     owner = gemIndexToOwner[_tokenId];
189     require(owner != address(0));
190   }
191 
192   function payout(address _to) public onlyCLevel {
193     _payout(_to);
194   }
195 
196   // Allows someone to send ether and obtain the token
197   function purchase(uint256 _tokenId) public payable {
198     address oldOwner = gemIndexToOwner[_tokenId];
199     address newOwner = msg.sender;
200 
201     uint256 sellingPrice = gemIndexToPrice[_tokenId];
202 
203     // Making sure token owner is not sending to self
204     require(oldOwner != newOwner);
205 
206     // Safety check to prevent against an unexpected 0x0 default.
207     require(_addressNotNull(newOwner));
208 
209     // Making sure sent amount is greater than or equal to the sellingPrice
210     require(msg.value >= sellingPrice);
211 
212     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 82), 100));
213     uint256 dividends = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 10), 100));
214     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
215 
216     // Update prices
217     if (sellingPrice < firstStepLimit) {
218       // first stage
219       gemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);
220     } else if (sellingPrice < secondStepLimit) {
221       // second stage
222       gemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 140), 92);
223     } else {
224       // third stage
225       gemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 92);
226     }
227 
228 
229     if (balanceOf(ownerOf(0)) >= 3 || ownerOf(0) == ownerOf(getNumberOne()) || ownerOf(0) == ownerOf(getNumberTwo()) || ownerOf(0) == ownerOf(getNumberThree()) && oldOwner != address(this)) {
230         ownerOf(0).transfer(SafeMath.mul(SafeMath.div(dividends, 100), 15));
231     } else {
232         oldOwner.transfer(SafeMath.mul(SafeMath.div(dividends, 100), 15));
233     }
234 
235     if (balanceOf(ownerOf(1)) >= 3 || ownerOf(1) == ownerOf(getNumberOne()) || ownerOf(1) == ownerOf(getNumberTwo()) || ownerOf(1) == ownerOf(getNumberThree()) && oldOwner != address(this)) {
236         ownerOf(1).transfer(SafeMath.mul(SafeMath.div(dividends, 100), 14));
237     } else {
238         oldOwner.transfer(SafeMath.mul(SafeMath.div(dividends, 100), 14));
239     }
240 
241     if (balanceOf(ownerOf(2)) >= 3 || ownerOf(2) == ownerOf(getNumberOne()) || ownerOf(2) == ownerOf(getNumberTwo()) || ownerOf(2) == ownerOf(getNumberThree()) && oldOwner != address(this)) {
242         ownerOf(2).transfer(SafeMath.mul(SafeMath.div(dividends, 100), 13));
243     } else {
244         oldOwner.transfer(SafeMath.mul(SafeMath.div(dividends, 100), 13));
245     }
246 
247     if (balanceOf(ownerOf(3)) >= 3 || ownerOf(3) == ownerOf(getNumberOne()) || ownerOf(3) == ownerOf(getNumberTwo()) || ownerOf(3) == ownerOf(getNumberThree()) && oldOwner != address(this)) {
248         ownerOf(3).transfer(SafeMath.mul(SafeMath.div(dividends, 100), 12));
249     } else {
250         oldOwner.transfer(SafeMath.mul(SafeMath.div(dividends, 100), 12));
251     }
252 
253     if (balanceOf(ownerOf(4)) >= 3 || ownerOf(4) == ownerOf(getNumberOne()) || ownerOf(4) == ownerOf(getNumberTwo()) || ownerOf(4) == ownerOf(getNumberThree()) && oldOwner != address(this)) {
254         ownerOf(4).transfer(SafeMath.mul(SafeMath.div(dividends, 100), 11));
255     } else {
256         oldOwner.transfer(SafeMath.mul(SafeMath.div(dividends, 100), 11));
257     }
258 
259     if (balanceOf(ownerOf(5)) >= 3 || ownerOf(5) == ownerOf(getNumberOne()) || ownerOf(5) == ownerOf(getNumberTwo()) || ownerOf(5) == ownerOf(getNumberThree()) && oldOwner != address(this)) {
260         ownerOf(5).transfer(SafeMath.mul(SafeMath.div(dividends, 100), 9));
261     } else {
262         oldOwner.transfer(SafeMath.mul(SafeMath.div(dividends, 100), 9));
263     }
264 
265     if (balanceOf(ownerOf(6)) >= 3 || ownerOf(6) == ownerOf(getNumberOne()) || ownerOf(6) == ownerOf(getNumberTwo()) || ownerOf(6) == ownerOf(getNumberThree()) && oldOwner != address(this)) {
266         ownerOf(6).transfer(SafeMath.mul(SafeMath.div(dividends, 100), 8));
267     } else {
268         oldOwner.transfer(SafeMath.mul(SafeMath.div(dividends, 100), 8));
269     }
270 
271     if (balanceOf(ownerOf(7)) >= 3 || ownerOf(7) == ownerOf(getNumberOne()) || ownerOf(7) == ownerOf(getNumberTwo()) || ownerOf(7) == ownerOf(getNumberThree()) && oldOwner != address(this)) {
272         ownerOf(7).transfer(SafeMath.mul(SafeMath.div(dividends, 100), 7));
273     } else {
274         oldOwner.transfer(SafeMath.mul(SafeMath.div(dividends, 100), 7));
275     }
276 
277     if (balanceOf(ownerOf(8)) >= 3 || ownerOf(8) == ownerOf(getNumberOne()) || ownerOf(8) == ownerOf(getNumberTwo()) || ownerOf(8) == ownerOf(getNumberThree()) && oldOwner != address(this)) {
278         ownerOf(8).transfer(SafeMath.mul(SafeMath.div(dividends, 100), 6));
279     } else {
280         oldOwner.transfer(SafeMath.mul(SafeMath.div(dividends, 100), 6));
281     }
282 
283     if (balanceOf(ownerOf(9)) >= 3 || ownerOf(9) == ownerOf(getNumberOne()) || ownerOf(9) == ownerOf(getNumberTwo()) || ownerOf(9) == ownerOf(getNumberThree()) && oldOwner != address(this)) {
284         ownerOf(9).transfer(SafeMath.mul(SafeMath.div(dividends, 100), 5));
285     } else {
286         oldOwner.transfer(SafeMath.mul(SafeMath.div(dividends, 100), 5));
287     }
288 
289 
290     _transfer(oldOwner, newOwner, _tokenId);
291 
292     // Pay previous tokenOwner if owner is not contract
293     if (oldOwner != address(this)) {
294       oldOwner.transfer(payment); //(1-0.08)
295     }
296 
297 
298 
299 
300     TokenSold(_tokenId, sellingPrice, gemIndexToPrice[_tokenId], oldOwner, newOwner, gems[_tokenId].name);
301 
302     msg.sender.transfer(purchaseExcess);
303   }
304 
305 
306     uint256 numberOne;
307     uint256 numberTwo;
308     uint256 numberThree;
309 
310 
311   function setNumberOne(uint256 number) public onlyCEO {
312       numberOne = number;
313   }
314 
315   function setNumberTwo(uint256 number) public onlyCEO {
316       numberTwo = number;
317   }
318 
319   function setNumberThree(uint256 number) public onlyCEO {
320       numberThree = number;
321   }
322 
323   function getNumberOne() public view returns (uint256 dailyNumber) {
324       return numberOne;
325   }
326 
327   function getNumberTwo() public view returns (uint256 dailyNumber) {
328       return numberTwo;
329   }
330 
331   function getNumberThree() public view returns (uint256 dailyNumber) {
332       return numberThree;
333   }
334 
335 
336 
337 
338   function changePrice(uint256 _tokenId) public  {
339     require(_owns(msg.sender, _tokenId));
340 
341     uint256 currentPrice = gemIndexToPrice[_tokenId];
342     uint256 onePercent = SafeMath.div(currentPrice, 100);
343     uint256 newPrice = SafeMath.mul(onePercent,95);
344     gemIndexToPrice[_tokenId] = newPrice;
345 
346   }
347 
348   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
349     return gemIndexToPrice[_tokenId];
350   }
351 
352   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
353   /// @param _newCEO The address of the new CEO
354   function setCEO(address _newCEO) public onlyCEO {
355     require(_newCEO != address(0));
356 
357     ceoAddress = _newCEO;
358   }
359 
360   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
361   /// @param _newCOO The address of the new COO
362   function setCOO(address _newCOO) public onlyCEO {
363     require(_newCOO != address(0));
364 
365     cooAddress = _newCOO;
366   }
367 
368   /// @dev Required for ERC-721 compliance.
369   function symbol() public pure returns (string) {
370     return SYMBOL;
371   }
372 
373   /// @notice Allow pre-approved user to take ownership of a token
374   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
375   /// @dev Required for ERC-721 compliance.
376   function takeOwnership(uint256 _tokenId) public {
377     address newOwner = msg.sender;
378     address oldOwner = gemIndexToOwner[_tokenId];
379 
380     // Safety check to prevent against an unexpected 0x0 default.
381     require(_addressNotNull(newOwner));
382 
383     // Making sure transfer is approved
384     require(_approved(newOwner, _tokenId));
385 
386     _transfer(oldOwner, newOwner, _tokenId);
387   }
388 
389   /// @param _owner The owner whose celebrity tokens we are interested in.
390   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
391   ///  expensive (it walks the entire Gems array looking for gems belonging to owner),
392   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
393   ///  not contract-to-contract calls.
394   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
395     uint256 tokenCount = balanceOf(_owner);
396     if (tokenCount == 0) {
397         // Return an empty array
398       return new uint256[](0);
399     } else {
400       uint256[] memory result = new uint256[](tokenCount);
401       uint256 totalGems = totalSupply();
402       uint256 resultIndex = 0;
403 
404       uint256 gemId;
405       for (gemId = 0; gemId <= totalGems; gemId++) {
406         if (gemIndexToOwner[gemId] == _owner) {
407           result[resultIndex] = gemId;
408           resultIndex++;
409         }
410       }
411       return result;
412     }
413   }
414 
415   /// For querying totalSupply of token
416   /// @dev Required for ERC-721 compliance.
417   function totalSupply() public view returns (uint256 total) {
418     return gems.length;
419   }
420 
421   /// Owner initates the transfer of the token to another account
422   /// @param _to The address for the token to be transferred to.
423   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
424   /// @dev Required for ERC-721 compliance.
425   function transfer(
426     address _to,
427     uint256 _tokenId
428   ) public {
429     require(_owns(msg.sender, _tokenId));
430     require(_addressNotNull(_to));
431 
432     _transfer(msg.sender, _to, _tokenId);
433   }
434 
435   /// Third-party initiates transfer of token from address _from to address _to
436   /// @param _from The address for the token to be transferred from.
437   /// @param _to The address for the token to be transferred to.
438   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
439   /// @dev Required for ERC-721 compliance.
440   function transferFrom(
441     address _from,
442     address _to,
443     uint256 _tokenId
444   ) public {
445     require(_owns(_from, _tokenId));
446     require(_approved(_to, _tokenId));
447     require(_addressNotNull(_to));
448 
449     _transfer(_from, _to, _tokenId);
450   }
451 
452   /*** PRIVATE FUNCTIONS ***/
453   /// Safety check on _to address to prevent against an unexpected 0x0 default.
454   function _addressNotNull(address _to) private pure returns (bool) {
455     return _to != address(0);
456   }
457 
458   /// For checking approval of transfer for address _to
459   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
460     return gemIndexToApproved[_tokenId] == _to;
461   }
462 
463   /// For creating Gem
464   function _createGem(string _name, address _owner, uint256 _price) private {
465     Gem memory _gem = Gem({
466       name: _name
467     });
468     uint256 newGemId = gems.push(_gem) - 1;
469 
470     // It's probably never going to happen, 4 billion tokens are A LOT, but
471     // let's just be 100% sure we never let this happen.
472     require(newGemId == uint256(uint32(newGemId)));
473 
474     Birth(newGemId, _name, _owner);
475 
476     gemIndexToPrice[newGemId] = _price;
477 
478     // This will assign ownership, and also emit the Transfer event as
479     // per ERC721 draft
480     _transfer(address(0), _owner, newGemId);
481   }
482 
483   /// Check for token ownership
484   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
485     return claimant == gemIndexToOwner[_tokenId];
486   }
487 
488   /// For paying out balance on contract
489   function _payout(address _to) private {
490     if (_to == address(0)) {
491       ceoAddress.transfer(this.balance);
492     } else {
493       _to.transfer(this.balance);
494     }
495   }
496 
497   /// @dev Assigns ownership of a specific Gem to an address.
498   function _transfer(address _from, address _to, uint256 _tokenId) private {
499     // Since the number of gems is capped to 2^32 we can't overflow this
500     ownershipTokenCount[_to]++;
501     //transfer ownership
502     gemIndexToOwner[_tokenId] = _to;
503 
504     // When creating new gems _from is 0x0, but we can't account that address.
505     if (_from != address(0)) {
506       ownershipTokenCount[_from]--;
507       // clear any previously approved ownership exchange
508       delete gemIndexToApproved[_tokenId];
509     }
510 
511     // Emit the transfer event.
512     Transfer(_from, _to, _tokenId);
513   }
514 }
515 library SafeMath {
516 
517   /**
518   * @dev Multiplies two numbers, throws on overflow.
519   */
520   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
521     if (a == 0) {
522       return 0;
523     }
524     uint256 c = a * b;
525     assert(c / a == b);
526     return c;
527   }
528 
529   /**
530   * @dev Integer division of two numbers, truncating the quotient.
531   */
532   function div(uint256 a, uint256 b) internal pure returns (uint256) {
533     // assert(b > 0); // Solidity automatically throws when dividing by 0
534     uint256 c = a / b;
535     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
536     return c;
537   }
538 
539   /**
540   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
541   */
542   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
543     assert(b <= a);
544     return a - b;
545   }
546 
547   /**
548   * @dev Adds two numbers, throws on overflow.
549   */
550   function add(uint256 a, uint256 b) internal pure returns (uint256) {
551     uint256 c = a + b;
552     assert(c >= a);
553     return c;
554   }
555 }