1 pragma solidity ^0.4.19; // solhint-disable-line
2 
3 
4 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
5 /// @author Srini Vasan 
6 contract ERC721 {
7   // Required methods
8   function approve(address _to, uint256 _tokenId) public;
9   function balanceOf(address _owner) public view returns (uint256 balance);
10   function implementsERC721() public pure returns (bool);
11   function ownerOf(uint256 _tokenId) public view returns (address addr);
12   function takeOwnership(uint256 _tokenId) public;
13   function totalSupply() public view returns (uint256 total);
14   function transferFrom(address _from, address _to, uint256 _tokenId) public;
15   function transfer(address _to, uint256 _tokenId) public;
16 
17   event Transfer(address indexed from, address indexed to, uint256 tokenId);
18   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
19 
20 }
21 
22 contract CryptonToken is ERC721 {
23 
24   /*** EVENTS ***/
25 
26   /// @dev The Birth event is fired whenever a new crypton comes into existence.
27   event Birth(uint256 tokenId, string name, address owner, bool isProtected, uint8 category);
28 
29   /// @dev The TokenSold event is fired whenever a token is sold.
30   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
31 
32   /// @dev Transfer event as defined in current draft of ERC721. 
33   ///  ownership is assigned, including births.
34   event Transfer(address from, address to, uint256 tokenId);
35 
36   /// @dev the PaymentTransferredToPreviousOwner event is fired when the previous owner of the Crypton is paid after a purchase.
37   event PaymentTransferredToPreviousOwner(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
38 
39   // @dev CryptonIsProtected is fired when the Crypton is protected from snatching - i.e. owner is allowed to set the selling price for the crypton
40   event CryptonIsProtected(uint256 tokenId);
41 
42     // @dev The markup was changed
43     event MarkupChanged(string name, uint256 newMarkup);
44     
45     //@dev Selling price of protected Crypton changed
46     event ProtectedCryptonSellingPriceChanged(uint256 tokenId, uint256 newSellingPrice);
47     
48     // Owner protected their Crypton
49     event OwnerProtectedCrypton(uint256 _tokenId, uint256 newSellingPrice);
50 
51     //Contract paused event
52     event ContractIsPaused(bool paused);
53 
54   /*** CONSTANTS ***/
55 
56   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
57   string public constant NAME = "Cryptons"; // solhint-disable-line
58   string public constant SYMBOL = "CRYPTON"; // solhint-disable-line
59 
60   uint256 private startingPrice = 0.1 ether;
61   uint256 private defaultMarkup = 2 ether;
62   uint256 private FIRST_STEP_LIMIT =  1.0 ether;
63   uint16 private FIRST_STEP_MULTIPLIER = 200; // double the value
64   uint16 private SECOND_STEP_MULTIPLIER = 120; // increment value by 20%
65   uint16 private XPROMO_MULTIPLIER = 500; // 5 times the value
66   uint16 private CRYPTON_CUT = 6; // our cut
67   uint16 private NET_PRICE_PERCENT = 100 - CRYPTON_CUT; // Net price paid out after cut
68 
69   // I could have used enums - but preferered the more specific uint8 
70   uint8 private constant PROMO = 1;
71   uint8 private constant STANDARD = 2;
72   uint8 private constant RESERVED = 7;
73   uint8 private constant XPROMO = 10; // First transaction, contract sets sell price to 5x
74   
75   /*** STORAGE ***/
76 
77   /// @dev A mapping from crypton IDs to the address that owns them. All cryptons have
78   ///  some valid owner address.
79   mapping (uint256 => address) public cryptonIndexToOwner;
80 
81   mapping (uint256 => bool) public cryptonIndexToProtected;
82 
83   // @dev A mapping from owner address to count of tokens that address owns.
84   //  Used internally inside balanceOf() to resolve ownership count.
85   mapping (address => uint256) private ownershipTokenCount;
86 
87   /// @dev A mapping from CryptonIDs to an address that has been approved to call
88   ///  transferFrom(). Each Crypton can only have one approved address for transfer
89   ///  at any time. A zero value means no approval is outstanding.
90   mapping (uint256 => address) public cryptonIndexToApproved;
91 
92   // @dev A mapping from CryptonIDs to the price of the token.
93   mapping (uint256 => uint256) private cryptonIndexToPrice;
94 
95 
96   // The addresses of the accounts (or contracts) that can execute actions within each roles.
97   address public ceoAddress;
98   address public cooAddress;
99 
100   /*** DATATYPES ***/
101   struct Crypton {
102     string name;
103     uint8  category;
104     uint256 markup;
105   }
106 
107   Crypton[] private cryptons;
108 
109     /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked.
110     bool public paused = false;
111 
112   /*** ACCESS MODIFIERS ***/
113   /// @dev Access modifier for COO-only functionality
114   /// @dev Access modifier for CEO-only functionality
115   modifier onlyCEO() {
116     require(msg.sender == ceoAddress);
117     _;
118   }
119   
120   modifier onlyCOO() {
121     require(msg.sender == cooAddress);
122     _;
123   }
124 
125   /// Access modifier for contract owner only functionality
126   modifier onlyCLevel() {
127     require(
128       msg.sender == ceoAddress ||
129       msg.sender == cooAddress
130     );
131     _;
132   }
133 
134     /*** Pausable functionality adapted from OpenZeppelin ***/
135     /// @dev Modifier to allow actions only when the contract IS NOT paused
136     modifier whenNotPaused() {
137         require(!paused);
138         _;
139     }
140 
141     /// @dev Modifier to allow actions only when the contract IS paused
142     modifier whenPaused {
143         require(paused);
144         _;
145     }
146 
147     /// @dev Called by any "C-level" role to pause the contract. Used only when
148     ///  a bug or exploit is detected and we need to limit damage.
149     function pause()
150         external
151         onlyCLevel
152         whenNotPaused
153     {
154         paused = true;
155         emit ContractIsPaused(paused);
156     }
157 
158     /// @dev Unpauses the smart contract. Can only be called by the CEO
159     /// @notice This is public rather than external so it can be called by
160     ///  derived contracts.
161     function unpause()
162         public
163         onlyCEO
164         whenPaused
165     {
166         // can't unpause if contract was forked
167         paused = false;
168         emit ContractIsPaused(paused);
169     }
170   /*** CONSTRUCTOR ***/
171   constructor() public {
172     ceoAddress = msg.sender;
173     cooAddress = msg.sender;
174   }
175 
176   /*** PUBLIC FUNCTIONS ***/
177   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
178   /// @param _to The address to be granted transfer approval. Pass address(0) to
179   ///  clear all approvals.
180   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
181   /// @dev Required for ERC-721 compliance.
182   function approve(
183     address _to,
184     uint256 _tokenId
185   ) public whenNotPaused {
186     // Caller must own token.
187     require(_owns(msg.sender, _tokenId));
188 
189     cryptonIndexToApproved[_tokenId] = _to;
190 
191     emit Approval(msg.sender, _to, _tokenId);
192   }
193 
194   /// For querying balance of a particular account
195   /// @param _owner The address for balance query
196   /// @dev Required for ERC-721 compliance.
197   function balanceOf(address _owner) public view returns (uint256 balance) {
198     return ownershipTokenCount[_owner];
199   }
200 
201   /// @dev Creates a new Crypton with the given name, startingPrice, category and an (optional) owner wallet address
202   function createCrypton(
203     string _name,                           //Required
204     uint8 _category,                        //Required
205     uint256 _startingPrice,                 // Optional - defaults to startingPrice
206     uint256 _markup,                        // Optional - defaults to defaultMarkup
207     address _owner                          // Optional - deafults to contract
208     ) public onlyCLevel {
209       address cryptonOwner = _owner;
210       if (cryptonOwner == address(0)) {
211         cryptonOwner = address(this);
212       }
213       
214       if (_category == XPROMO) {    // XPROMO Cryptons - force ownership to contract
215           cryptonOwner = address(this);
216       }
217 
218       if (_markup <= 0) {
219           _markup = defaultMarkup;
220       }
221         
222       if (_category == PROMO) { // PROMO Cryptons - force markup to zero
223         _markup = 0;  
224       }
225 
226       if (_startingPrice <= 0) {
227         _startingPrice = startingPrice;
228       }
229 
230 
231       bool isProtected = (_category == PROMO)?true:false; // PROMO cryptons are protected, others are not - at creation
232       
233       _createCrypton(_name, cryptonOwner, _startingPrice, _markup, isProtected, _category);
234   }
235 
236   /// @notice Returns all the relevant information about a specific crypton.
237   /// @param _tokenId The tokenId of the crypton of interest.
238   function getCrypton(uint256 _tokenId) public view returns (
239     string cryptonName,
240     uint8 category,
241     uint256 markup,
242     uint256 sellingPrice,
243     address owner,
244     bool isProtected
245   ) {
246     Crypton storage crypton = cryptons[_tokenId];
247     cryptonName = crypton.name;
248     sellingPrice = cryptonIndexToPrice[_tokenId];
249     owner = cryptonIndexToOwner[_tokenId];
250     isProtected = cryptonIndexToProtected[_tokenId];
251     category = crypton.category;
252     markup = crypton.markup;
253   }
254 
255   function implementsERC721() public pure returns (bool) {
256     return true;
257   }
258 
259   /// @dev Required for ERC-721 compliance.
260   function name() public pure returns (string) {
261     return NAME;
262   }
263 
264   /// For querying owner of token
265   /// @param _tokenId The tokenID for owner inquiry
266   /// @dev Required for ERC-721 compliance.
267   function ownerOf(uint256 _tokenId)
268     public
269     view
270     returns (address owner)
271   {
272     owner = cryptonIndexToOwner[_tokenId];
273     require(owner != address(0));
274   }
275 
276   /// @dev This function withdraws the contract owner's cut.
277   /// Any amount may be withdrawn as there is no user funds.
278   /// User funds are immediately sent to the old owner in `purchase`
279   function payout(address _to) public onlyCLevel {
280     _payout(_to);
281   }
282 
283   /// @dev This function allows the contract owner to adjust the selling price of a protected Crypton
284   function setPriceForProtectedCrypton(uint256 _tokenId, uint256 newSellingPrice) public whenNotPaused {
285     address oldOwner = cryptonIndexToOwner[_tokenId]; // owner in blockchain
286     address newOwner = msg.sender;                    // person requesting change
287     require(oldOwner == newOwner); // Only current owner can update the price
288     require(cryptonIndexToProtected[_tokenId]); // Make sure Crypton is protected
289     require(newSellingPrice > 0);  // Make sure the price is not zero
290     cryptonIndexToPrice[_tokenId] = newSellingPrice;
291     emit ProtectedCryptonSellingPriceChanged(_tokenId, newSellingPrice);
292  }
293 
294   /// @dev This function allows the contract owner to buy protection for an unprotected that they already own
295   function setProtectionForMyUnprotectedCrypton(uint256 _tokenId, uint256 newSellingPrice) public payable whenNotPaused {
296     address oldOwner = cryptonIndexToOwner[_tokenId]; // owner in blockchain
297     address newOwner = msg.sender;                    // person requesting change
298     uint256 markup = cryptons[_tokenId].markup;
299     if (cryptons[_tokenId].category != PROMO) {
300       require(markup > 0); // if this is NOT a promotional crypton, the markup should be > zero
301     }
302     
303     require(oldOwner == newOwner); // Only current owner can buy protection for existing crypton
304     require(! cryptonIndexToProtected[_tokenId]); // Make sure Crypton is NOT already protected
305     require(newSellingPrice > 0);  // Make sure the sellingPrice is more than zero
306     require(msg.value >= markup);   // Make sure to collect the markup
307     
308     cryptonIndexToPrice[_tokenId] = newSellingPrice;
309     cryptonIndexToProtected[_tokenId] = true;
310     
311     emit OwnerProtectedCrypton(_tokenId, newSellingPrice);
312  }
313  
314   function getMarkup(uint256 _tokenId) public view returns (uint256 markup) {
315     return cryptons[_tokenId].markup;
316   }
317 
318   /// @dev This function allows the contract owner to adjust the markup value
319   function setMarkup(uint256 _tokenId, uint256 newMarkup) public onlyCLevel {
320     require(newMarkup >= 0);
321     cryptons[_tokenId].markup = newMarkup;
322     emit MarkupChanged(cryptons[_tokenId].name, newMarkup);
323   }
324     
325   // Allows someone to send ether and obtain the token
326   function purchase(uint256 _tokenId, uint256 newSellingPrice) public payable whenNotPaused {
327     address oldOwner = cryptonIndexToOwner[_tokenId];
328     address newOwner = msg.sender;
329     bool isAlreadyProtected = cryptonIndexToProtected[_tokenId];
330     
331     uint256 sellingPrice = cryptonIndexToPrice[_tokenId];
332     uint256 markup = cryptons[_tokenId].markup;
333     
334     if (cryptons[_tokenId].category != PROMO) {
335       require(markup > 0); // if this is NOT a promotional crypton, the markup should be > zero
336     }
337 
338     // Make sure token owner is not sending to self
339     require(oldOwner != newOwner);
340 
341     // Safety check to prevent against an unexpected 0x0 default.
342     require(_addressNotNull(newOwner));
343 
344     // Make sure sent amount is greater than or equal to the sellingPrice
345     require(msg.value >= sellingPrice); // this is redundant - as we are checking this below
346 
347     if (newSellingPrice > 0) { // if we are called with a new selling price, then the buyer is paying the markup or purchasing a protected crypton
348         uint256 purchasePrice = sellingPrice; //assume it is protected
349         if (! cryptonIndexToProtected[_tokenId] ) { // Crypton is not protected,
350             purchasePrice = sellingPrice + markup;  // apply markup
351         }
352 
353         // If the Crypton is not already protected, make sure that the buyer is paying markup more than the current selling price
354         // If the buyer is not paying the markup - then he cannot set the new selling price- bailout
355         require(msg.value >= purchasePrice); 
356 
357         // Ok - the buyer paid the markup or the crypton was already protected.
358         cryptonIndexToPrice[_tokenId] = newSellingPrice;  // Set the selling price that the buyer wants
359         cryptonIndexToProtected[_tokenId] = true;         // Set the Crypton to protected
360         emit CryptonIsProtected(_tokenId);                // Let the world know
361 
362     } else {
363         // Compute next listing price.
364         // Handle XPROMO case first...
365         if (
366           (oldOwner == address(this)) &&                // first transaction only`
367           (cryptons[_tokenId].category == XPROMO)      // Only for XPROMO category
368           ) 
369         {
370           cryptonIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, XPROMO_MULTIPLIER), NET_PRICE_PERCENT);            
371         } else {
372           if (sellingPrice < FIRST_STEP_LIMIT) {
373             // first stage
374             cryptonIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, FIRST_STEP_MULTIPLIER), NET_PRICE_PERCENT);
375           } else {
376             // second stage
377             cryptonIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, SECOND_STEP_MULTIPLIER), NET_PRICE_PERCENT);
378           }
379         }
380 
381     }
382        
383     _transfer(oldOwner, newOwner, _tokenId);
384 
385     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, NET_PRICE_PERCENT), 100));
386     string storage cname = cryptons[_tokenId].name;
387 
388     bool isReservedToken = (cryptons[_tokenId].category == RESERVED);
389   
390     if (isReservedToken && isAlreadyProtected) {
391       oldOwner.transfer(payment); //(1-CRYPTON_CUT/100)
392       emit PaymentTransferredToPreviousOwner(_tokenId, sellingPrice, cryptonIndexToPrice[_tokenId], oldOwner, newOwner, cname);
393       emit TokenSold(_tokenId, sellingPrice, cryptonIndexToPrice[_tokenId], oldOwner, newOwner, cname);
394       return;
395     }
396 
397     // Pay seller of the Crypton if they are not this contract or if this is a Reserved token
398     if ((oldOwner != address(this)) && !isReservedToken ) // Not a Reserved token and not owned by the contract
399     {
400       oldOwner.transfer(payment); //(1-CRYPTON_CUT/100)
401       emit PaymentTransferredToPreviousOwner(_tokenId, sellingPrice, cryptonIndexToPrice[_tokenId], oldOwner, newOwner, cname);
402     }
403 
404     emit TokenSold(_tokenId, sellingPrice, cryptonIndexToPrice[_tokenId], oldOwner, newOwner, cname);
405 
406   }
407 
408   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
409     return cryptonIndexToPrice[_tokenId];
410   }
411 
412   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
413   /// @param _newCEO The address of the new CEO
414   function setCEO(address _newCEO) public onlyCEO {
415     require(_newCEO != address(0));
416 
417     ceoAddress = _newCEO;
418   }
419 
420   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
421   /// @param _newCOO The address of the new COO
422   function setCOO(address _newCOO) public onlyCEO {
423     require(_newCOO != address(0));
424 
425     cooAddress = _newCOO;
426   }
427 
428   /// @dev Required for ERC-721 compliance.
429   function symbol() public pure returns (string) {
430     return SYMBOL;
431   }
432 
433   /// @notice Allow pre-approved user to take ownership of a token
434   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
435   /// @dev Required for ERC-721 compliance.
436   function takeOwnership(uint256 _tokenId) public whenNotPaused {
437     address newOwner = msg.sender;
438     address oldOwner = cryptonIndexToOwner[_tokenId];
439 
440     // Safety check to prevent against an unexpected 0x0 default.
441     require(_addressNotNull(newOwner));
442 
443     // Making sure transfer is approved
444     require(_approved(newOwner, _tokenId));
445 
446     _transfer(oldOwner, newOwner, _tokenId);
447   }
448 
449   /// @param _owner The owner whose Cryptons we are interested in.
450   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
451   ///  expensive (it walks the entire Cryptons array looking for cryptons belonging to owner),
452   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
453   ///  not contract-to-contract calls.
454   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
455     uint256 tokenCount = balanceOf(_owner);
456     if (tokenCount == 0) {
457         // Return an empty array
458       return new uint256[](0);
459     } else {
460       uint256[] memory result = new uint256[](tokenCount);
461       uint256 totalCryptons = totalSupply();
462       uint256 resultIndex = 0;
463 
464       uint256 cryptonId;
465       for (cryptonId = 0; cryptonId <= totalCryptons; cryptonId++) {
466         if (cryptonIndexToOwner[cryptonId] == _owner) {
467           result[resultIndex] = cryptonId;
468           resultIndex++;
469         }
470       }
471       return result;
472     }
473   }
474 
475   /// For querying totalSupply of token
476   /// @dev Required for ERC-721 compliance.
477   function totalSupply() public view returns (uint256 total) {
478     return cryptons.length;
479   }
480 
481   /// Owner initates the transfer of the token to another account
482   /// @param _to The address for the token to be transferred to.
483   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
484   /// @dev Required for ERC-721 compliance.
485   function transfer(
486     address _to,
487     uint256 _tokenId
488   ) public whenNotPaused {
489     require(_owns(msg.sender, _tokenId));
490     require(_addressNotNull(_to));
491 
492     _transfer(msg.sender, _to, _tokenId);
493   }
494 
495   /// Third-party initiates transfer of token from address _from to address _to
496   /// @param _from The address for the token to be transferred from.
497   /// @param _to The address for the token to be transferred to.
498   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
499   /// @dev Required for ERC-721 compliance.
500   function transferFrom(
501     address _from,
502     address _to,
503     uint256 _tokenId
504   ) public whenNotPaused {
505     require(_owns(_from, _tokenId));
506     require(_approved(_to, _tokenId));
507     require(_addressNotNull(_to));
508 
509     _transfer(_from, _to, _tokenId);
510   }
511 
512   /*** PRIVATE FUNCTIONS ***/
513   /// Safety check on _to address to prevent against an unexpected 0x0 default.
514   function _addressNotNull(address _to) private pure returns (bool) {
515     return _to != address(0);
516   }
517 
518   /// For checking approval of transfer for address _to
519   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
520     return cryptonIndexToApproved[_tokenId] == _to;
521   }
522 
523   /// For creating Crypton
524   function _createCrypton(string _name, address _owner, uint256 _price, uint256 _markup, bool _isProtected, uint8 _category) private {
525     Crypton memory _crypton = Crypton({
526       name: _name,
527       category: _category,
528       markup: _markup
529     });
530     uint256 newCryptonId = cryptons.push(_crypton) - 1;
531 
532     // It's probably never going to happen, 4 billion tokens are A LOT, but
533     // let's just be 100% sure we never let this happen.
534     require(newCryptonId == uint256(uint32(newCryptonId)));
535 
536     emit Birth(newCryptonId, _name, _owner, _isProtected, _category);
537 
538     cryptonIndexToPrice[newCryptonId] = _price;
539     
540     cryptonIndexToProtected[newCryptonId] = _isProtected; // _isProtected is true for promo cryptons - false for others.
541 
542     // This will assign ownership, and also emit the Transfer event as
543     // per ERC721 draft
544     _transfer(address(0), _owner, newCryptonId);
545   }
546 
547   /// Check for token ownership
548   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
549     return claimant == cryptonIndexToOwner[_tokenId];
550   }
551 
552   /// For paying out balance on contract
553   function _payout(address _to) private {
554     address myAddress = this;
555     if (_to == address(0)) {
556       ceoAddress.transfer(myAddress.balance);
557     } else {
558       _to.transfer(myAddress.balance);
559     }
560   }
561 
562   /// @dev Assigns ownership of a specific Crypton to an address.
563   function _transfer(address _from, address _to, uint256 _tokenId) private {
564     // Since the number of cryptons is capped to 2^32 we can't overflow this
565     ownershipTokenCount[_to]++;
566     //transfer ownership
567     cryptonIndexToOwner[_tokenId] = _to;
568 
569     // When creating new cryptons _from is 0x0, but we can't account that address.
570     if (_from != address(0)) {
571       ownershipTokenCount[_from]--;
572       // clear any previously approved ownership exchange
573       delete cryptonIndexToApproved[_tokenId];
574     }
575 
576     // Emit the transfer event.
577     emit Transfer(_from, _to, _tokenId);
578   }
579 
580 //various getter/setter methods
581 
582   function setFIRST_STEP_LIMIT(uint256 newLimit) public onlyCLevel {
583     require(newLimit > 0 && newLimit < 100 ether);
584     FIRST_STEP_LIMIT = newLimit;
585   }
586   function getFIRST_STEP_LIMIT() public view returns (uint256 value) {
587     return FIRST_STEP_LIMIT;
588   }
589 
590   function setFIRST_STEP_MULTIPLIER(uint16 newValue) public onlyCLevel {
591     require(newValue >= 110 && newValue <= 200);
592     FIRST_STEP_MULTIPLIER = newValue;
593   }
594   function getFIRST_STEP_MULTIPLIER() public view returns (uint16 value) {
595     return FIRST_STEP_MULTIPLIER;
596   }
597 
598   function setSECOND_STEP_MULTIPLIER(uint16 newValue) public onlyCLevel {
599     require(newValue >= 110 && newValue <= 200);
600     SECOND_STEP_MULTIPLIER = newValue;
601   }
602   function getSECOND_STEP_MULTIPLIER() public view returns (uint16 value) {
603     return SECOND_STEP_MULTIPLIER;
604   }
605 
606   function setXPROMO_MULTIPLIER(uint16 newValue) public onlyCLevel {
607     require(newValue >= 100 && newValue <= 10000); // between 0 and 100x
608     XPROMO_MULTIPLIER = newValue;
609   }
610   function getXPROMO_MULTIPLIER() public view returns (uint16 value) {
611     return XPROMO_MULTIPLIER;
612   }
613 
614   function setCRYPTON_CUT(uint16 newValue) public onlyCLevel {
615     require(newValue > 0 && newValue < 10);
616     CRYPTON_CUT = newValue;
617   }
618   function getCRYPTON_CUT() public view returns (uint16 value) {
619     return CRYPTON_CUT;
620   }
621 
622 }
623 
624 library SafeMath {
625 
626   /**
627   * @dev Multiplies two numbers, throws on overflow.
628   */
629   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
630     if (a == 0) {
631       return 0;
632     }
633     uint256 c = a * b;
634     assert(c / a == b);
635     return c;
636   }
637 
638   /**
639   * @dev Integer division of two numbers, truncating the quotient.
640   */
641   function div(uint256 a, uint256 b) internal pure returns (uint256) {
642     // assert(b > 0); // Solidity automatically throws when dividing by 0
643     uint256 c = a / b;
644     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
645     return c;
646   }
647 
648   /**
649   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
650   */
651   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
652     assert(b <= a);
653     return a - b;
654   }
655 
656   /**
657   * @dev Adds two numbers, throws on overflow.
658   */
659   function add(uint256 a, uint256 b) internal pure returns (uint256) {
660     uint256 c = a + b;
661     assert(c >= a);
662     return c;
663   }
664 }