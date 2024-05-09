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
45 contract ERC721 {
46   // Required methods
47   function approve(address _to, uint256 _tokenId) public;
48   function balanceOf(address _owner) public view returns (uint256 balance);
49   function implementsERC721() public pure returns (bool);
50   function ownerOf(uint256 _tokenId) public view returns (address addr);
51   function takeOwnership(uint256 _tokenId) public;
52   function totalSupply() public view returns (uint256 total);
53   function transferFrom(address _from, address _to, uint256 _tokenId) public;
54   function transfer(address _to, uint256 _tokenId) public;
55 
56   event Transfer(address indexed from, address indexed to, uint256 tokenId);
57   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
58 
59   // Optional
60   // function name() public view returns (string name);
61   // function symbol() public view returns (string symbol);
62   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
63   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
64 }
65 
66 contract CryptoNFT is ERC721 {
67 
68   /*** EVENTS ***/
69 
70   /// @dev The Birth event is fired whenever a new person comes into existence.
71   event Birth(uint256 tokenId, string name, address owner);
72 
73   /// @dev The TokenSold event is fired whenever a token is sold.
74   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
75 
76   /// @dev Transfer event as defined in current draft of ERC721. 
77   ///  ownership is assigned, including births.
78   event Transfer(address from, address to, uint256 tokenId);
79 
80   /*** CONSTANTS ***/
81   uint256 internal startingPrice = 0.01 ether;
82 
83   // uint256 internal toPlayerMultiplier = uint256(0.94);
84   /*** STORAGE ***/
85 
86   /// @dev A mapping from person IDs to the address that owns them. All persons have
87   ///  some valid owner address.
88   mapping (uint256 => address) public personIndexToOwner;
89 
90   // @dev A mapping from owner address to count of tokens that address owns.
91   //  Used internally inside balanceOf() to resolve ownership count.
92   mapping (address => uint256) private ownershipTokenCount;
93 
94   /// @dev A mapping from PersonIDs to an address that has been approved to call
95   ///  transferFrom(). Each Person can only have one approved address for transfer
96   ///  at any time. A zero value means no approval is outstanding.
97   mapping (uint256 => address) public personIndexToApproved;
98 
99   // @dev A mapping from PersonIDs to the price of the token.
100   mapping (uint256 => uint256) internal personIndexToPrice;
101 
102   // The addresses of the accounts (or contracts) that can execute actions within each roles.
103   address public ceoAddress;
104   address public cooAddress;
105 
106   /*** DATATYPES ***/
107   struct Person {
108     string name;
109   }
110 
111   Person[] private persons;
112 
113   /*** ACCESS MODIFIERS ***/
114   /// @dev Access modifier for CEO-only functionality
115   modifier onlyCEO() {
116     require(msg.sender == ceoAddress);
117     _;
118   }
119 
120   /// @dev Access modifier for COO-only functionality
121   modifier onlyCOO() {
122     require(msg.sender == cooAddress);
123     _;
124   }
125 
126   /// Access modifier for contract owner only functionality
127   modifier onlyCLevel() {
128     require(
129       msg.sender == ceoAddress ||
130       msg.sender == cooAddress
131     );
132     _;
133   }
134 
135   /*** CONSTRUCTOR ***/
136   function CryptoNFT() public {
137     ceoAddress = msg.sender;
138     cooAddress = msg.sender;
139   }
140 
141   /*** PUBLIC FUNCTIONS ***/
142   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
143   /// @param _to The address to be granted transfer approval. Pass address(0) to
144   ///  clear all approvals.
145   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
146   /// @dev Required for ERC-721 compliance.
147   function approve(
148     address _to,
149     uint256 _tokenId
150   ) public {
151     // Caller must own token.
152     require(_owns(msg.sender, _tokenId));
153 
154     personIndexToApproved[_tokenId] = _to;
155 
156     Approval(msg.sender, _to, _tokenId);
157   }
158 
159   /// For querying balance of a particular account
160   /// @param _owner The address for balance query
161   /// @dev Required for ERC-721 compliance.
162   function balanceOf(address _owner) public view returns (uint256 balance) {
163     return ownershipTokenCount[_owner];
164   }
165 
166   
167 
168   /// @dev Creates a new Person with the given name.
169   function createContractPerson(string _name) public onlyCOO {
170     _createPerson(_name, address(this), startingPrice);
171   }
172 
173   /// @notice Returns all the relevant information about a specific person.
174   /// @param _tokenId The tokenId of the person of interest.
175   function getPerson(uint256 _tokenId) public view returns (
176     string personName,
177     uint256 sellingPrice,
178     address owner
179   ) {
180     Person storage person = persons[_tokenId];
181     personName = person.name;
182     sellingPrice = personIndexToPrice[_tokenId];
183     owner = personIndexToOwner[_tokenId];
184   }
185 
186   function implementsERC721() public pure returns (bool) {
187     return true;
188   }
189 
190 
191   /// For querying owner of token
192   /// @param _tokenId The tokenID for owner inquiry
193   /// @dev Required for ERC-721 compliance.
194   function ownerOf(uint256 _tokenId)
195     public
196     view
197     returns (address owner)
198   {
199     owner = personIndexToOwner[_tokenId];
200     require(owner != address(0));
201   }
202 
203   function payout(address _to) public onlyCEO {
204     _payout(_to, this.balance);
205   }
206 
207   // Allows someone to send ether and obtain the token
208   function purchase(uint256 _tokenId) public payable {
209     address oldOwner = personIndexToOwner[_tokenId];
210     address newOwner = msg.sender;
211 
212     uint256 sellingPrice = personIndexToPrice[_tokenId];
213 
214     // Making sure token owner is not sending to self
215     require(oldOwner != newOwner);
216 
217     // Safety check to prevent against an unexpected 0x0 default.
218     require(_addressNotNull(newOwner));
219 
220     // Making sure sent amount is greater than or equal to the sellingPrice
221     require(msg.value >= sellingPrice);
222 
223     uint256 payment = calcPaymentToOldOwner(sellingPrice);
224     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
225 
226     // Update prices
227     personIndexToPrice[_tokenId] = calcNextSellingPrice(sellingPrice);
228 
229     _transfer(oldOwner, newOwner, _tokenId);
230 
231     // Pay previous tokenOwner if owner is not contract
232     if (oldOwner != address(this)) {
233       oldOwner.transfer(payment); //(1-0.06)
234     }
235 
236     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner, persons[_tokenId].name);
237 
238     msg.sender.transfer(purchaseExcess);
239   }
240 
241   function calcPaymentToOldOwner(uint256 sellingPrice) internal returns (uint256 payToOldOwner);
242   function calcNextSellingPrice(uint256 currentSellingPrice) internal returns (uint256 newSellingPrice);
243 
244   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
245     return personIndexToPrice[_tokenId];
246   }
247 
248   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
249   /// @param _newCEO The address of the new CEO
250   function setCEO(address _newCEO) public onlyCEO {
251     require(_newCEO != address(0));
252 
253     ceoAddress = _newCEO;
254   }
255 
256   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
257   /// @param _newCOO The address of the new COO
258   function setCOO(address _newCOO) public onlyCEO {
259     require(_newCOO != address(0));
260 
261     cooAddress = _newCOO;
262   }
263 
264   /// @notice Allow pre-approved user to take ownership of a token
265   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
266   /// @dev Required for ERC-721 compliance.
267   function takeOwnership(uint256 _tokenId) public {
268     address newOwner = msg.sender;
269     address oldOwner = personIndexToOwner[_tokenId];
270 
271     // Safety check to prevent against an unexpected 0x0 default.
272     require(_addressNotNull(newOwner));
273 
274     // Making sure transfer is approved
275     require(_approved(newOwner, _tokenId));
276 
277     _transfer(oldOwner, newOwner, _tokenId);
278   }
279 
280   /// @param _owner The owner whose celebrity tokens we are interested in.
281   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
282   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
283   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
284   ///  not contract-to-contract calls.
285   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
286     uint256 tokenCount = balanceOf(_owner);
287     if (tokenCount == 0) {
288         // Return an empty array
289       return new uint256[](0);
290     } else {
291       uint256[] memory result = new uint256[](tokenCount);
292       uint256 totalPersons = totalSupply();
293       uint256 resultIndex = 0;
294 
295       uint256 personId;
296       for (personId = 0; personId <= totalPersons; personId++) {
297         if (personIndexToOwner[personId] == _owner) {
298           result[resultIndex] = personId;
299           resultIndex++;
300         }
301       }
302       return result;
303     }
304   }
305 
306   /// For querying totalSupply of token
307   /// @dev Required for ERC-721 compliance.
308   function totalSupply() public view returns (uint256 total) {
309     return persons.length;
310   }
311 
312   /// Owner initates the transfer of the token to another account
313   /// @param _to The address for the token to be transferred to.
314   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
315   /// @dev Required for ERC-721 compliance.
316   function transfer(
317     address _to,
318     uint256 _tokenId
319   ) public {
320     require(_owns(msg.sender, _tokenId));
321     require(_addressNotNull(_to));
322 
323     _transfer(msg.sender, _to, _tokenId);
324   }
325 
326   /// Third-party initiates transfer of token from address _from to address _to
327   /// @param _from The address for the token to be transferred from.
328   /// @param _to The address for the token to be transferred to.
329   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
330   /// @dev Required for ERC-721 compliance.
331   function transferFrom(
332     address _from,
333     address _to,
334     uint256 _tokenId
335   ) public {
336     require(_owns(_from, _tokenId));
337     require(_approved(_to, _tokenId));
338     require(_addressNotNull(_to));
339 
340     _transfer(_from, _to, _tokenId);
341   }
342 
343   /*** PRIVATE FUNCTIONS ***/
344   /// Safety check on _to address to prevent against an unexpected 0x0 default.
345   function _addressNotNull(address _to) private pure returns (bool) {
346     return _to != address(0);
347   }
348 
349   /// For checking approval of transfer for address _to
350   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
351     return personIndexToApproved[_tokenId] == _to;
352   }
353 
354   /// For creating Person
355   function _createPerson(string _name, address _owner, uint256 _price) internal {
356     Person memory _person = Person({
357       name: _name
358     });
359     uint256 newPersonId = persons.push(_person) - 1;
360 
361     // It's probably never going to happen, 4 billion tokens are A LOT, but
362     // let's just be 100% sure we never let this happen.
363     require(newPersonId == uint256(uint32(newPersonId)));
364 
365     Birth(newPersonId, _name, _owner);
366 
367     personIndexToPrice[newPersonId] = _price;
368 
369     // This will assign ownership, and also emit the Transfer event as
370     // per ERC721 draft
371     _transfer(address(0), _owner, newPersonId);
372   }
373 
374   /// Check for token ownership
375   function _owns(address claimant, uint256 _tokenId) internal view returns (bool) {
376     return claimant == personIndexToOwner[_tokenId];
377   }
378 
379   /// For paying out balance on contract
380   function _payout(address _to, uint256 amount) internal {
381     require(amount<=this.balance);
382     if (_to == address(0)) {
383       ceoAddress.transfer(amount);
384     } else {
385       _to.transfer(amount);
386     }
387   }
388 
389   /// @dev Assigns ownership of a specific Person to an address.
390   function _transfer(address _from, address _to, uint256 _tokenId) private {
391     // Since the number of persons is capped to 2^32 we can't overflow this
392     ownershipTokenCount[_to]++;
393     //transfer ownership
394     personIndexToOwner[_tokenId] = _to;
395 
396     // When creating new persons _from is 0x0, but we can't account that address.
397     if (_from != address(0)) {
398       ownershipTokenCount[_from]--;
399       // clear any previously approved ownership exchange
400       delete personIndexToApproved[_tokenId];
401     }
402 
403     // Emit the transfer event.
404     Transfer(_from, _to, _tokenId);
405   }
406 }
407 
408 contract EtherAthlete is CryptoNFT {
409     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
410     string public constant NAME = "EtherAthlete"; // solhint-disable-line
411     string public constant SYMBOL = "EAT"; // solhint-disable-line
412 
413     uint256 private constant PROMO_CREATION_LIMIT = 5000;
414     uint256 public promoCreatedCount;
415 
416     bool public allowPriceUpdate;
417 
418     /*** CONSTANTS ***/
419     uint256 private firstStepLimit =  0.32 ether;
420     uint256 private secondStepLimit = 2.8629151 ether;
421 
422     uint256 private defaultIncreasePercent = 200;
423     uint256 private fsIncreasePercent = 155;
424     uint256 private ssIncreasePercent = 130;
425 
426     uint256 private defaultPlayerPercent = 7500;
427     uint256 private fsPlayerPercent = 8400;
428     uint256 private ssPlayerPercent = 9077;
429 
430     // The addresses of the charity account.
431     address public charityAddress;
432     uint256 private charityPercent = 3;
433     uint256 public charityBalance;
434 
435 
436     /*** CONSTRUCTOR ***/
437     function EtherAthlete() public {
438         allowPriceUpdate = false;
439         charityAddress = msg.sender;
440         charityBalance = 0 ether;
441     }
442     
443     /*** PUBLIC FUNCTIONS ***/
444 
445     /// @dev Required for ERC-721 compliance.
446     function name() public pure returns (string) {
447         return NAME;
448     }
449     /// @dev Required for ERC-721 compliance.
450     function symbol() public pure returns (string) {
451         return SYMBOL;
452     }
453 
454     /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
455     function createPromoPerson(address _owner, string _name, uint256 _price) public onlyCOO {
456         require(promoCreatedCount < PROMO_CREATION_LIMIT);
457 
458         address personOwner = _owner;
459         if (personOwner == address(0)) {
460         personOwner = cooAddress;
461         }
462 
463         if (_price <= 0) {
464         _price = startingPrice;
465         }
466 
467         promoCreatedCount++;
468         _createPerson(_name, personOwner, _price);
469     }
470 
471     function setAllowPriceUpdate(bool _bValue) public onlyCOO {
472         allowPriceUpdate = _bValue;
473     }
474 
475     /*** PRIVATE FUNCTIONS ***/
476     /// Overrides Abstract internal method to calculate payment proportion for old owner
477     /// out of selling price in current purchase
478     function calcPaymentToOldOwner(uint256 sellingPrice) internal returns (uint256 payToOldOwner) {
479         if (sellingPrice <= firstStepLimit) {
480             // first stage
481             payToOldOwner = uint256(SafeMath.div(SafeMath.mul(sellingPrice, defaultPlayerPercent),10000));
482         } else if (sellingPrice <= secondStepLimit) {
483             // second stage
484             payToOldOwner = uint256(SafeMath.div(SafeMath.mul(sellingPrice, fsPlayerPercent),10000));
485         } else {
486             // third stage
487             payToOldOwner = uint256(SafeMath.div(SafeMath.mul(sellingPrice, ssPlayerPercent),10000));
488         }
489 
490         // Update the charity balance
491         uint256 gainToHouse = SafeMath.sub(sellingPrice, payToOldOwner);
492         charityBalance = SafeMath.add(charityBalance, SafeMath.div(SafeMath.mul(gainToHouse, charityPercent),100));
493     }
494 
495     /// Overrides the abstract method to calculate the next selling price based on
496     /// current selling prices of the asset.
497     function calcNextSellingPrice(uint256 currentSellingPrice) internal returns (uint256 newSellingPrice) {
498         if (currentSellingPrice < firstStepLimit) {
499             // first stage
500             newSellingPrice = SafeMath.div(SafeMath.mul(currentSellingPrice, defaultIncreasePercent), 100);
501         } else if (currentSellingPrice < secondStepLimit) {
502             // second stage
503             newSellingPrice = SafeMath.div(SafeMath.mul(currentSellingPrice, fsIncreasePercent), 100);
504         } else {
505             // third stage
506             newSellingPrice = SafeMath.div(SafeMath.mul(currentSellingPrice, ssIncreasePercent), 100);
507         }
508     }
509 
510     function setCharityAddress(address _charityAddress) public onlyCEO {
511         charityAddress = _charityAddress;
512     }
513 
514     function payout(address _to) public onlyCEO {
515         uint256 amountToCharity = charityBalance;
516         uint256 amount = SafeMath.sub(this.balance, charityBalance);
517         charityBalance = 0;
518         _payout(charityAddress, amountToCharity);
519         _payout(_to, amount);
520     }
521 
522     function updateTokenSellingPrice(uint256 _tokenId, uint256 sellingPrice) public {
523         require(allowPriceUpdate);
524         require(_owns(msg.sender, _tokenId));
525         require(sellingPrice < personIndexToPrice[_tokenId]);
526         require(sellingPrice >= startingPrice);
527         personIndexToPrice[_tokenId] = sellingPrice;
528     }
529 }