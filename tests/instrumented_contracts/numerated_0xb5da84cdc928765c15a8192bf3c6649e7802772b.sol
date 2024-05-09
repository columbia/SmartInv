1 pragma solidity ^0.4.13;
2 
3 interface ERC721Enumerable /* is ERC721 */ {
4     /// @notice Count NFTs tracked by this contract
5     /// @return A count of valid NFTs tracked by this contract, where each one of
6     ///  them has an assigned and queryable owner not equal to the zero address
7     function totalSupply() public view returns (uint256);
8 
9     /// @notice Enumerate valid NFTs
10     /// @dev Throws if `_index` >= `totalSupply()`.
11     /// @param _index A counter less than `totalSupply()`
12     /// @return The token identifier for the `_index`th NFT,
13     ///  (sort order not specified)
14     function tokenByIndex(uint256 _index) external view returns (uint256);
15 
16     /// @notice Enumerate NFTs assigned to an owner
17     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
18     ///  `_owner` is the zero address, representing invalid NFTs.
19     /// @param _owner An address where we are interested in NFTs owned by them
20     /// @param _index A counter less than `balanceOf(_owner)`
21     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
22     ///   (sort order not specified)
23     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId);
24 }
25 
26 interface ERC721Metadata /* is ERC721 */ {
27     /// @notice A descriptive name for a collection of NFTs in this contract
28     function name() external pure returns (string _name);
29 
30     /// @notice An abbreviated name for NFTs in this contract
31     function symbol() external pure returns (string _symbol);
32 
33     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
34     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
35     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
36     ///  Metadata JSON Schema".
37     function tokenURI(uint256 _tokenId) external view returns (string);
38 }
39 
40 contract Ownable {
41   address public owner;
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     require(_newOwner != address(0));
67     OwnershipTransferred(owner, _newOwner);
68     owner = _newOwner;
69   }
70 
71 }
72 
73 interface ERC721TokenReceiver {
74     /// @notice Handle the receipt of an NFT
75     /// @dev The ERC721 smart contract calls this function on the recipient
76     ///  after a `transfer`. This function MAY throw to revert and reject the
77     ///  transfer. This function MUST use 50,000 gas or less. Return of other
78     ///  than the magic value MUST result in the transaction being reverted.
79     ///  Note: the contract address is always the message sender.
80     /// @param _from The sending address
81     /// @param _tokenId The NFT identifier which is being transfered
82     /// @param _data Additional data with no specified format
83     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
84     ///  unless throwing
85 	function onERC721Received(address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
86 }
87 
88 library Math {
89   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
90     return a >= b ? a : b;
91   }
92 
93   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
94     return a < b ? a : b;
95   }
96 
97   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
98     return a >= b ? a : b;
99   }
100 
101   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
102     return a < b ? a : b;
103   }
104 }
105 
106 contract LicenseAccessControl {
107   /**
108    * @notice ContractUpgrade is the event that will be emitted if we set a new contract address
109    */
110   event ContractUpgrade(address newContract);
111   event Paused();
112   event Unpaused();
113 
114   /**
115    * @notice CEO's address FOOBAR
116    */
117   address public ceoAddress;
118 
119   /**
120    * @notice CFO's address
121    */
122   address public cfoAddress;
123 
124   /**
125    * @notice COO's address
126    */
127   address public cooAddress;
128 
129   /**
130    * @notice withdrawal address
131    */
132   address public withdrawalAddress;
133 
134   bool public paused = false;
135 
136   /**
137    * @dev Modifier to make a function only callable by the CEO
138    */
139   modifier onlyCEO() {
140     require(msg.sender == ceoAddress);
141     _;
142   }
143 
144   /**
145    * @dev Modifier to make a function only callable by the CFO
146    */
147   modifier onlyCFO() {
148     require(msg.sender == cfoAddress);
149     _;
150   }
151 
152   /**
153    * @dev Modifier to make a function only callable by the COO
154    */
155   modifier onlyCOO() {
156     require(msg.sender == cooAddress);
157     _;
158   }
159 
160   /**
161    * @dev Modifier to make a function only callable by C-level execs
162    */
163   modifier onlyCLevel() {
164     require(
165       msg.sender == cooAddress ||
166       msg.sender == ceoAddress ||
167       msg.sender == cfoAddress
168     );
169     _;
170   }
171 
172   /**
173    * @dev Modifier to make a function only callable by CEO or CFO
174    */
175   modifier onlyCEOOrCFO() {
176     require(
177       msg.sender == cfoAddress ||
178       msg.sender == ceoAddress
179     );
180     _;
181   }
182 
183   /**
184    * @dev Modifier to make a function only callable by CEO or COO
185    */
186   modifier onlyCEOOrCOO() {
187     require(
188       msg.sender == cooAddress ||
189       msg.sender == ceoAddress
190     );
191     _;
192   }
193 
194   /**
195    * @notice Sets a new CEO
196    * @param _newCEO - the address of the new CEO
197    */
198   function setCEO(address _newCEO) external onlyCEO {
199     require(_newCEO != address(0));
200     ceoAddress = _newCEO;
201   }
202 
203   /**
204    * @notice Sets a new CFO
205    * @param _newCFO - the address of the new CFO
206    */
207   function setCFO(address _newCFO) external onlyCEO {
208     require(_newCFO != address(0));
209     cfoAddress = _newCFO;
210   }
211 
212   /**
213    * @notice Sets a new COO
214    * @param _newCOO - the address of the new COO
215    */
216   function setCOO(address _newCOO) external onlyCEO {
217     require(_newCOO != address(0));
218     cooAddress = _newCOO;
219   }
220 
221   /**
222    * @notice Sets a new withdrawalAddress
223    * @param _newWithdrawalAddress - the address where we'll send the funds
224    */
225   function setWithdrawalAddress(address _newWithdrawalAddress) external onlyCEO {
226     require(_newWithdrawalAddress != address(0));
227     withdrawalAddress = _newWithdrawalAddress;
228   }
229 
230   /**
231    * @notice Withdraw the balance to the withdrawalAddress
232    * @dev We set a withdrawal address seperate from the CFO because this allows us to withdraw to a cold wallet.
233    */
234   function withdrawBalance() external onlyCEOOrCFO {
235     require(withdrawalAddress != address(0));
236     withdrawalAddress.transfer(this.balance);
237   }
238 
239   /** Pausable functionality adapted from OpenZeppelin **/
240 
241   /**
242    * @dev Modifier to make a function callable only when the contract is not paused.
243    */
244   modifier whenNotPaused() {
245     require(!paused);
246     _;
247   }
248 
249   /**
250    * @dev Modifier to make a function callable only when the contract is paused.
251    */
252   modifier whenPaused() {
253     require(paused);
254     _;
255   }
256 
257   /**
258    * @notice called by any C-level to pause, triggers stopped state
259    */
260   function pause() public onlyCLevel whenNotPaused {
261     paused = true;
262     Paused();
263   }
264 
265   /**
266    * @notice called by the CEO to unpause, returns to normal state
267    */
268   function unpause() public onlyCEO whenPaused {
269     paused = false;
270     Unpaused();
271   }
272 }
273 
274 contract LicenseBase is LicenseAccessControl {
275   /**
276    * @notice Issued is emitted when a new license is issued
277    */
278   event LicenseIssued(
279     address indexed owner,
280     address indexed purchaser,
281     uint256 licenseId,
282     uint256 productId,
283     uint256 attributes,
284     uint256 issuedTime,
285     uint256 expirationTime,
286     address affiliate
287   );
288 
289   event LicenseRenewal(
290     address indexed owner,
291     address indexed purchaser,
292     uint256 licenseId,
293     uint256 productId,
294     uint256 expirationTime
295   );
296 
297   struct License {
298     uint256 productId;
299     uint256 attributes;
300     uint256 issuedTime;
301     uint256 expirationTime;
302     address affiliate;
303   }
304 
305   /**
306    * @notice All licenses in existence.
307    * @dev The ID of each license is an index in this array.
308    */
309   License[] licenses;
310 
311   /** internal **/
312   function _isValidLicense(uint256 _licenseId) internal view returns (bool) {
313     return licenseProductId(_licenseId) != 0;
314   }
315 
316   /** anyone **/
317 
318   /**
319    * @notice Get a license's productId
320    * @param _licenseId the license id
321    */
322   function licenseProductId(uint256 _licenseId) public view returns (uint256) {
323     return licenses[_licenseId].productId;
324   }
325 
326   /**
327    * @notice Get a license's attributes
328    * @param _licenseId the license id
329    */
330   function licenseAttributes(uint256 _licenseId) public view returns (uint256) {
331     return licenses[_licenseId].attributes;
332   }
333 
334   /**
335    * @notice Get a license's issueTime
336    * @param _licenseId the license id
337    */
338   function licenseIssuedTime(uint256 _licenseId) public view returns (uint256) {
339     return licenses[_licenseId].issuedTime;
340   }
341 
342   /**
343    * @notice Get a license's issueTime
344    * @param _licenseId the license id
345    */
346   function licenseExpirationTime(uint256 _licenseId) public view returns (uint256) {
347     return licenses[_licenseId].expirationTime;
348   }
349 
350   /**
351    * @notice Get a the affiliate credited for the sale of this license
352    * @param _licenseId the license id
353    */
354   function licenseAffiliate(uint256 _licenseId) public view returns (address) {
355     return licenses[_licenseId].affiliate;
356   }
357 
358   /**
359    * @notice Get a license's info
360    * @param _licenseId the license id
361    */
362   function licenseInfo(uint256 _licenseId)
363     public view returns (uint256, uint256, uint256, uint256, address)
364   {
365     return (
366       licenseProductId(_licenseId),
367       licenseAttributes(_licenseId),
368       licenseIssuedTime(_licenseId),
369       licenseExpirationTime(_licenseId),
370       licenseAffiliate(_licenseId)
371     );
372   }
373 }
374 
375 contract Pausable is Ownable {
376   event Pause();
377   event Unpause();
378 
379   bool public paused = false;
380 
381 
382   /**
383    * @dev Modifier to make a function callable only when the contract is not paused.
384    */
385   modifier whenNotPaused() {
386     require(!paused);
387     _;
388   }
389 
390   /**
391    * @dev Modifier to make a function callable only when the contract is paused.
392    */
393   modifier whenPaused() {
394     require(paused);
395     _;
396   }
397 
398   /**
399    * @dev called by the owner to pause, triggers stopped state
400    */
401   function pause() onlyOwner whenNotPaused public {
402     paused = true;
403     Pause();
404   }
405 
406   /**
407    * @dev called by the owner to unpause, returns to normal state
408    */
409   function unpause() onlyOwner whenPaused public {
410     paused = false;
411     Unpause();
412   }
413 }
414 
415 contract AffiliateProgram is Pausable {
416   using SafeMath for uint256;
417 
418   event AffiliateCredit(
419     // The address of the affiliate
420     address affiliate,
421     // The store's ID of what was sold (e.g. a tokenId)
422     uint256 productId,
423     // The amount owed this affiliate in this sale
424     uint256 amount
425   );
426 
427   event Withdraw(address affiliate, address to, uint256 amount);
428   event Whitelisted(address affiliate, uint256 amount);
429   event RateChanged(uint256 rate, uint256 amount);
430 
431   // @notice A mapping from affiliate address to their balance
432   mapping (address => uint256) public balances;
433 
434   // @notice A mapping from affiliate address to the time of last deposit
435   mapping (address => uint256) public lastDepositTimes;
436 
437   // @notice The last deposit globally
438   uint256 public lastDepositTime;
439 
440   // @notice The maximum rate for any affiliate
441   // @dev The hard-coded maximum affiliate rate (in basis points)
442   // All rates are measured in basis points (1/100 of a percent)
443   // Values 0-10,000 map to 0%-100%
444   uint256 private constant hardCodedMaximumRate = 5000;
445 
446   // @notice The commission exiration time
447   // @dev Affiliate commissions expire if they are unclaimed after this amount of time
448   uint256 private constant commissionExpiryTime = 30 days;
449 
450   // @notice The baseline affiliate rate (in basis points) for non-whitelisted referrals
451   uint256 public baselineRate = 0;
452 
453   // @notice A mapping from whitelisted referrals to their individual rates
454   mapping (address => uint256) public whitelistRates;
455 
456   // @notice The maximum rate for any affiliate
457   // @dev overrides individual rates. This can be used to clip the rate used in bulk, if necessary
458   uint256 public maximumRate = 5000;
459 
460   // @notice The address of the store selling products
461   address public storeAddress;
462 
463   // @notice The contract is retired
464   // @dev If we decide to retire this program, this value will be set to true
465   // and then the contract cannot be unpaused
466   bool public retired = false;
467 
468 
469   /**
470    * @dev Modifier to make a function only callable by the store or the owner
471    */
472   modifier onlyStoreOrOwner() {
473     require(
474       msg.sender == storeAddress ||
475       msg.sender == owner);
476     _;
477   }
478 
479   /**
480    * @dev AffiliateProgram constructor - keeps the address of it's parent store
481    * and pauses the contract
482    */
483   function AffiliateProgram(address _storeAddress) public {
484     require(_storeAddress != address(0));
485     storeAddress = _storeAddress;
486     paused = true;
487   }
488 
489   /**
490    * @notice Exposes that this contract thinks it is an AffiliateProgram
491    */
492   function isAffiliateProgram() public pure returns (bool) {
493     return true;
494   }
495 
496   /**
497    * @notice returns the commission rate for a sale
498    *
499    * @dev rateFor returns the rate which should be used to calculate the comission
500    *  for this affiliate/sale combination, in basis points (1/100th of a percent).
501    *
502    *  We may want to completely blacklist a particular address (e.g. a known bad actor affilite).
503    *  To that end, if the whitelistRate is exactly 1bp, we use that as a signal for blacklisting
504    *  and return a rate of zero. The upside is that we can completely turn off
505    *  sending transactions to a particular address when this is needed. The
506    *  downside is that you can't issued 1/100th of a percent commission.
507    *  However, since this is such a small amount its an acceptable tradeoff.
508    *
509    *  This implementation does not use the _productId, _pruchaseId,
510    *  _purchaseAmount, but we include them here as part of the protocol, because
511    *  they could be useful in more advanced affiliate programs.
512    *
513    * @param _affiliate - the address of the affiliate to check for
514    */
515   function rateFor(
516     address _affiliate,
517     uint256 /*_productId*/,
518     uint256 /*_purchaseId*/,
519     uint256 /*_purchaseAmount*/)
520     public
521     view
522     returns (uint256)
523   {
524     uint256 whitelistedRate = whitelistRates[_affiliate];
525     if(whitelistedRate > 0) {
526       // use 1 bp as a blacklist signal
527       if(whitelistedRate == 1) {
528         return 0;
529       } else {
530         return Math.min256(whitelistedRate, maximumRate);
531       }
532     } else {
533       return Math.min256(baselineRate, maximumRate);
534     }
535   }
536 
537   /**
538    * @notice cutFor returns the affiliate cut for a sale
539    * @dev cutFor returns the cut (amount in wei) to give in comission to the affiliate
540    *
541    * @param _affiliate - the address of the affiliate to check for
542    * @param _productId - the productId in the sale
543    * @param _purchaseId - the purchaseId in the sale
544    * @param _purchaseAmount - the purchaseAmount
545    */
546   function cutFor(
547     address _affiliate,
548     uint256 _productId,
549     uint256 _purchaseId,
550     uint256 _purchaseAmount)
551     public
552     view
553     returns (uint256)
554   {
555     uint256 rate = rateFor(
556       _affiliate,
557       _productId,
558       _purchaseId,
559       _purchaseAmount);
560     require(rate <= hardCodedMaximumRate);
561     return (_purchaseAmount.mul(rate)).div(10000);
562   }
563 
564   /**
565    * @notice credit an affiliate for a purchase
566    * @dev credit accepts eth and credits the affiliate's balance for the amount
567    *
568    * @param _affiliate - the address of the affiliate to credit
569    * @param _purchaseId - the purchaseId of the sale
570    */
571   function credit(
572     address _affiliate,
573     uint256 _purchaseId)
574     public
575     onlyStoreOrOwner
576     whenNotPaused
577     payable
578   {
579     require(msg.value > 0);
580     require(_affiliate != address(0));
581     balances[_affiliate] += msg.value;
582     lastDepositTimes[_affiliate] = now; // solium-disable-line security/no-block-members
583     lastDepositTime = now; // solium-disable-line security/no-block-members
584     AffiliateCredit(_affiliate, _purchaseId, msg.value);
585   }
586 
587   /**
588    * @dev _performWithdraw performs a withdrawal from address _from and
589    * transfers it to _to. This can be different because we allow the owner
590    * to withdraw unclaimed funds after a period of time.
591    *
592    * @param _from - the address to subtract balance from
593    * @param _to - the address to transfer ETH to
594    */
595   function _performWithdraw(address _from, address _to) private {
596     require(balances[_from] > 0);
597     uint256 balanceValue = balances[_from];
598     balances[_from] = 0;
599     _to.transfer(balanceValue);
600     Withdraw(_from, _to, balanceValue);
601   }
602 
603   /**
604    * @notice withdraw
605    * @dev withdraw the msg.sender's balance
606    */
607   function withdraw() public whenNotPaused {
608     _performWithdraw(msg.sender, msg.sender);
609   }
610 
611   /**
612    * @notice withdraw from a specific account
613    * @dev withdrawFrom allows the owner to withdraw an affiliate's unclaimed
614    * ETH, after the alotted time.
615    *
616    * This function can be called even if the contract is paused
617    *
618    * @param _affiliate - the address of the affiliate
619    * @param _to - the address to send ETH to
620    */
621   function withdrawFrom(address _affiliate, address _to) onlyOwner public {
622     // solium-disable-next-line security/no-block-members
623     require(now > lastDepositTimes[_affiliate].add(commissionExpiryTime));
624     _performWithdraw(_affiliate, _to);
625   }
626 
627   /**
628    * @notice retire the contract (dangerous)
629    * @dev retire - withdraws the entire balance and marks the contract as retired, which
630    * prevents unpausing.
631    *
632    * If no new comissions have been deposited for the alotted time,
633    * then the owner may pause the program and retire this contract.
634    * This may only be performed once as the contract cannot be unpaused.
635    *
636    * We do this as an alternative to selfdestruct, because certain operations
637    * can still be performed after the contract has been selfdestructed, such as
638    * the owner withdrawing ETH accidentally sent here.
639    */
640   function retire(address _to) onlyOwner whenPaused public {
641     // solium-disable-next-line security/no-block-members
642     require(now > lastDepositTime.add(commissionExpiryTime));
643     _to.transfer(this.balance);
644     retired = true;
645   }
646 
647   /**
648    * @notice whitelist an affiliate address
649    * @dev whitelist - white listed affiliates can receive a different
650    *   rate than the general public (whitelisted accounts would generally get a
651    *   better rate).
652    * @param _affiliate - the affiliate address to whitelist
653    * @param _rate - the rate, in basis-points (1/100th of a percent) to give this affiliate in each sale. NOTE: a rate of exactly 1 is the signal to blacklist this affiliate. That is, a rate of 1 will set the commission to 0.
654    */
655   function whitelist(address _affiliate, uint256 _rate) onlyOwner public {
656     require(_rate <= hardCodedMaximumRate);
657     whitelistRates[_affiliate] = _rate;
658     Whitelisted(_affiliate, _rate);
659   }
660 
661   /**
662    * @notice set the rate for non-whitelisted affiliates
663    * @dev setBaselineRate - sets the baseline rate for any affiliate that is not whitelisted
664    * @param _newRate - the rate, in bp (1/100th of a percent) to give any non-whitelisted affiliate. Set to zero to "turn off"
665    */
666   function setBaselineRate(uint256 _newRate) onlyOwner public {
667     require(_newRate <= hardCodedMaximumRate);
668     baselineRate = _newRate;
669     RateChanged(0, _newRate);
670   }
671 
672   /**
673    * @notice set the maximum rate for any affiliate
674    * @dev setMaximumRate - Set the maximum rate for any affiliate, including whitelists. That is, this overrides individual rates.
675    * @param _newRate - the rate, in bp (1/100th of a percent)
676    */
677   function setMaximumRate(uint256 _newRate) onlyOwner public {
678     require(_newRate <= hardCodedMaximumRate);
679     maximumRate = _newRate;
680     RateChanged(1, _newRate);
681   }
682 
683   /**
684    * @notice unpause the contract
685    * @dev called by the owner to unpause, returns to normal state. Will not
686    * unpause if the contract is retired.
687    */
688   function unpause() onlyOwner whenPaused public {
689     require(!retired);
690     paused = false;
691     Unpause();
692   }
693 
694 }
695 
696 contract ERC721 {
697   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
698   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
699   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
700 
701   function balanceOf(address _owner) public view returns (uint256 _balance);
702   function ownerOf(uint256 _tokenId) public view returns (address _owner);
703   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public;
704   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
705   function transfer(address _to, uint256 _tokenId) external;
706   function transferFrom(address _from, address _to, uint256 _tokenId) public;
707   function approve(address _to, uint256 _tokenId) external;
708   function setApprovalForAll(address _to, bool _approved) external;
709   function getApproved(uint256 _tokenId) public view returns (address);
710   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
711 }
712 
713 contract LicenseInventory is LicenseBase {
714   using SafeMath for uint256;
715 
716   event ProductCreated(
717     uint256 id,
718     uint256 price,
719     uint256 available,
720     uint256 supply,
721     uint256 interval,
722     bool renewable
723   );
724   event ProductInventoryAdjusted(uint256 productId, uint256 available);
725   event ProductPriceChanged(uint256 productId, uint256 price);
726   event ProductRenewableChanged(uint256 productId, bool renewable);
727 
728 
729   /**
730    * @notice Product defines a product
731    * * renewable: There may come a time when we which to disable the ability to renew a subscription. For example, a plan we no longer wish to support. Obviously care needs to be taken with how we communicate this to customers, but contract-wise, we want to support the ability to discontinue renewal of certain plans.
732   */
733   struct Product {
734     uint256 id;
735     uint256 price;
736     uint256 available;
737     uint256 supply;
738     uint256 sold;
739     uint256 interval;
740     bool renewable;
741   }
742 
743   // @notice All products in existence
744   uint256[] public allProductIds;
745 
746   // @notice A mapping from product ids to Products
747   mapping (uint256 => Product) public products;
748 
749   /*** internal ***/
750 
751   /**
752    * @notice _productExists checks to see if a product exists
753    */
754   function _productExists(uint256 _productId) internal view returns (bool) {
755     return products[_productId].id != 0;
756   }
757 
758   function _productDoesNotExist(uint256 _productId) internal view returns (bool) {
759     return products[_productId].id == 0;
760   }
761 
762   function _createProduct(
763     uint256 _productId,
764     uint256 _initialPrice,
765     uint256 _initialInventoryQuantity,
766     uint256 _supply,
767     uint256 _interval)
768     internal
769   {
770     require(_productDoesNotExist(_productId));
771     require(_initialInventoryQuantity <= _supply);
772 
773     Product memory _product = Product({
774       id: _productId,
775       price: _initialPrice,
776       available: _initialInventoryQuantity,
777       supply: _supply,
778       sold: 0,
779       interval: _interval,
780       renewable: _interval == 0 ? false : true
781     });
782 
783     products[_productId] = _product;
784     allProductIds.push(_productId);
785 
786     ProductCreated(
787       _product.id,
788       _product.price,
789       _product.available,
790       _product.supply,
791       _product.interval,
792       _product.renewable
793       );
794   }
795 
796   function _incrementInventory(
797     uint256 _productId,
798     uint256 _inventoryAdjustment)
799     internal
800   {
801     require(_productExists(_productId));
802     uint256 newInventoryLevel = products[_productId].available.add(_inventoryAdjustment);
803 
804     // A supply of "0" means "unlimited". Otherwise we need to ensure that we're not over-creating this product
805     if(products[_productId].supply > 0) {
806       // you have to take already sold into account
807       require(products[_productId].sold.add(newInventoryLevel) <= products[_productId].supply);
808     }
809 
810     products[_productId].available = newInventoryLevel;
811   }
812 
813   function _decrementInventory(
814     uint256 _productId,
815     uint256 _inventoryAdjustment)
816     internal
817   {
818     require(_productExists(_productId));
819     uint256 newInventoryLevel = products[_productId].available.sub(_inventoryAdjustment);
820     // unnecessary because we're using SafeMath and an unsigned int
821     // require(newInventoryLevel >= 0);
822     products[_productId].available = newInventoryLevel;
823   }
824 
825   function _clearInventory(uint256 _productId) internal
826   {
827     require(_productExists(_productId));
828     products[_productId].available = 0;
829   }
830 
831   function _setPrice(uint256 _productId, uint256 _price) internal
832   {
833     require(_productExists(_productId));
834     products[_productId].price = _price;
835   }
836 
837   function _setRenewable(uint256 _productId, bool _isRenewable) internal
838   {
839     require(_productExists(_productId));
840     products[_productId].renewable = _isRenewable;
841   }
842 
843   function _purchaseOneUnitInStock(uint256 _productId) internal {
844     require(_productExists(_productId));
845     require(availableInventoryOf(_productId) > 0);
846 
847     // lower inventory
848     _decrementInventory(_productId, 1);
849 
850     // record that one was sold
851     products[_productId].sold = products[_productId].sold.add(1);
852   }
853 
854   function _requireRenewableProduct(uint256 _productId) internal view {
855     // productId must exist
856     require(_productId != 0);
857     // You can only renew a subscription product
858     require(isSubscriptionProduct(_productId));
859     // The product must currently be renewable
860     require(renewableOf(_productId));
861   }
862 
863   /*** public ***/
864 
865   /** executives-only **/
866 
867   /**
868    * @notice createProduct creates a new product in the system
869    * @param _productId - the id of the product to use (cannot be changed)
870    * @param _initialPrice - the starting price (price can be changed)
871    * @param _initialInventoryQuantity - the initial inventory (inventory can be changed)
872    * @param _supply - the total supply - use `0` for "unlimited" (cannot be changed)
873    */
874   function createProduct(
875     uint256 _productId,
876     uint256 _initialPrice,
877     uint256 _initialInventoryQuantity,
878     uint256 _supply,
879     uint256 _interval)
880     external
881     onlyCEOOrCOO
882   {
883     _createProduct(
884       _productId,
885       _initialPrice,
886       _initialInventoryQuantity,
887       _supply,
888       _interval);
889   }
890 
891   /**
892    * @notice incrementInventory - increments the inventory of a product
893    * @param _productId - the product id
894    * @param _inventoryAdjustment - the amount to increment
895    */
896   function incrementInventory(
897     uint256 _productId,
898     uint256 _inventoryAdjustment)
899     external
900     onlyCLevel
901   {
902     _incrementInventory(_productId, _inventoryAdjustment);
903     ProductInventoryAdjusted(_productId, availableInventoryOf(_productId));
904   }
905 
906   /**
907   * @notice decrementInventory removes inventory levels for a product
908   * @param _productId - the product id
909   * @param _inventoryAdjustment - the amount to decrement
910   */
911   function decrementInventory(
912     uint256 _productId,
913     uint256 _inventoryAdjustment)
914     external
915     onlyCLevel
916   {
917     _decrementInventory(_productId, _inventoryAdjustment);
918     ProductInventoryAdjusted(_productId, availableInventoryOf(_productId));
919   }
920 
921   /**
922   * @notice clearInventory clears the inventory of a product.
923   * @dev decrementInventory verifies inventory levels, whereas this method
924   * simply sets the inventory to zero. This is useful, for example, if an
925   * executive wants to take a product off the market quickly. There could be a
926   * race condition with decrementInventory where a product is sold, which could
927   * cause the admins decrement to fail (because it may try to decrement more
928   * than available).
929   *
930   * @param _productId - the product id
931   */
932   function clearInventory(uint256 _productId)
933     external
934     onlyCLevel
935   {
936     _clearInventory(_productId);
937     ProductInventoryAdjusted(_productId, availableInventoryOf(_productId));
938   }
939 
940   /**
941   * @notice setPrice - sets the price of a product
942   * @param _productId - the product id
943   * @param _price - the product price
944   */
945   function setPrice(uint256 _productId, uint256 _price)
946     external
947     onlyCLevel
948   {
949     _setPrice(_productId, _price);
950     ProductPriceChanged(_productId, _price);
951   }
952 
953   /**
954   * @notice setRenewable - sets if a product is renewable
955   * @param _productId - the product id
956   * @param _newRenewable - the new renewable setting
957   */
958   function setRenewable(uint256 _productId, bool _newRenewable)
959     external
960     onlyCLevel
961   {
962     _setRenewable(_productId, _newRenewable);
963     ProductRenewableChanged(_productId, _newRenewable);
964   }
965 
966   /** anyone **/
967 
968   /**
969   * @notice The price of a product
970   * @param _productId - the product id
971   */
972   function priceOf(uint256 _productId) public view returns (uint256) {
973     return products[_productId].price;
974   }
975 
976   /**
977   * @notice The available inventory of a product
978   * @param _productId - the product id
979   */
980   function availableInventoryOf(uint256 _productId) public view returns (uint256) {
981     return products[_productId].available;
982   }
983 
984   /**
985   * @notice The total supply of a product
986   * @param _productId - the product id
987   */
988   function totalSupplyOf(uint256 _productId) public view returns (uint256) {
989     return products[_productId].supply;
990   }
991 
992   /**
993   * @notice The total sold of a product
994   * @param _productId - the product id
995   */
996   function totalSold(uint256 _productId) public view returns (uint256) {
997     return products[_productId].sold;
998   }
999 
1000   /**
1001   * @notice The renewal interval of a product in seconds
1002   * @param _productId - the product id
1003   */
1004   function intervalOf(uint256 _productId) public view returns (uint256) {
1005     return products[_productId].interval;
1006   }
1007 
1008   /**
1009   * @notice Is this product renewable?
1010   * @param _productId - the product id
1011   */
1012   function renewableOf(uint256 _productId) public view returns (bool) {
1013     return products[_productId].renewable;
1014   }
1015 
1016 
1017   /**
1018   * @notice The product info for a product
1019   * @param _productId - the product id
1020   */
1021   function productInfo(uint256 _productId)
1022     public
1023     view
1024     returns (uint256, uint256, uint256, uint256, bool)
1025   {
1026     return (
1027       priceOf(_productId),
1028       availableInventoryOf(_productId),
1029       totalSupplyOf(_productId),
1030       intervalOf(_productId),
1031       renewableOf(_productId));
1032   }
1033 
1034   /**
1035   * @notice Get all product ids
1036   */
1037   function getAllProductIds() public view returns (uint256[]) {
1038     return allProductIds;
1039   }
1040 
1041   /**
1042    * @notice returns the total cost to renew a product for a number of cycles
1043    * @dev If a product is a subscription, the interval defines the period of
1044    * time, in seconds, users can subscribe for. E.g. 1 month or 1 year.
1045    * _numCycles is the number of these intervals we want to use in the
1046    * calculation of the price.
1047    *
1048    * We require that the end user send precisely the amount required (instead
1049    * of dealing with excess refunds). This method is public so that clients can
1050    * read the exact amount our contract expects to receive.
1051    *
1052    * @param _productId - the product we're calculating for
1053    * @param _numCycles - the number of cycles to calculate for
1054    */
1055   function costForProductCycles(uint256 _productId, uint256 _numCycles)
1056     public
1057     view
1058     returns (uint256)
1059   {
1060     return priceOf(_productId).mul(_numCycles);
1061   }
1062 
1063   /**
1064    * @notice returns if this product is a subscription or not
1065    * @dev Some products are subscriptions and others are not. An interval of 0
1066    * means the product is not a subscription
1067    * @param _productId - the product we're checking
1068    */
1069   function isSubscriptionProduct(uint256 _productId) public view returns (bool) {
1070     return intervalOf(_productId) > 0;
1071   }
1072 
1073 }
1074 
1075 library SafeMath {
1076 
1077   /**
1078   * @dev Multiplies two numbers, throws on overflow.
1079   */
1080   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1081     if (a == 0) {
1082       return 0;
1083     }
1084     uint256 c = a * b;
1085     assert(c / a == b);
1086     return c;
1087   }
1088 
1089   /**
1090   * @dev Integer division of two numbers, truncating the quotient.
1091   */
1092   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1093     // assert(b > 0); // Solidity automatically throws when dividing by 0
1094     uint256 c = a / b;
1095     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1096     return c;
1097   }
1098 
1099   /**
1100   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1101   */
1102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1103     assert(b <= a);
1104     return a - b;
1105   }
1106 
1107   /**
1108   * @dev Adds two numbers, throws on overflow.
1109   */
1110   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1111     uint256 c = a + b;
1112     assert(c >= a);
1113     return c;
1114   }
1115 }
1116 
1117 interface ERC165 {
1118     /// @notice Query if a contract implements an interface
1119     /// @param interfaceID The interface identifier, as specified in ERC-165
1120     /// @dev Interface identification is specified in ERC-165. This function
1121     ///  uses less than 30,000 gas.
1122     /// @return `true` if the contract implements `interfaceID` and
1123     ///  `interfaceID` is not 0xffffffff, `false` otherwise
1124     function supportsInterface(bytes4 interfaceID) external view returns (bool);
1125 }
1126 
1127 contract LicenseOwnership is LicenseInventory, ERC721, ERC165, ERC721Metadata, ERC721Enumerable {
1128   using SafeMath for uint256;
1129 
1130   // Total amount of tokens
1131   uint256 private totalTokens;
1132 
1133   // Mapping from token ID to owner
1134   mapping (uint256 => address) private tokenOwner;
1135 
1136   // Mapping from token ID to approved address
1137   mapping (uint256 => address) private tokenApprovals;
1138 
1139   // Mapping from owner address to operator address to approval
1140   mapping (address => mapping (address => bool)) private operatorApprovals;
1141 
1142   // Mapping from owner to list of owned token IDs
1143   mapping (address => uint256[]) private ownedTokens;
1144 
1145   // Mapping from token ID to index of the owner tokens list
1146   mapping(uint256 => uint256) private ownedTokensIndex;
1147 
1148   /*** Constants ***/
1149   // Configure these for your own deployment
1150   string public constant NAME = "Dottabot";
1151   string public constant SYMBOL = "DOTTA";
1152   string public tokenMetadataBaseURI = "https://api.dottabot.com/";
1153 
1154   /**
1155    * @notice token's name
1156    */
1157   function name() external pure returns (string) {
1158     return NAME;
1159   }
1160 
1161   /**
1162    * @notice symbols's name
1163    */
1164   function symbol() external pure returns (string) {
1165     return SYMBOL;
1166   }
1167 
1168   function implementsERC721() external pure returns (bool) {
1169     return true;
1170   }
1171 
1172   function tokenURI(uint256 _tokenId)
1173     external
1174     view
1175     returns (string infoUrl)
1176   {
1177     return Strings.strConcat(
1178       tokenMetadataBaseURI,
1179       Strings.uint2str(_tokenId));
1180   }
1181 
1182   function supportsInterface(
1183     bytes4 interfaceID) // solium-disable-line dotta/underscore-function-arguments
1184     external view returns (bool)
1185   {
1186     return
1187       interfaceID == this.supportsInterface.selector || // ERC165
1188       interfaceID == 0x5b5e139f || // ERC721Metadata
1189       interfaceID == 0x6466353c || // ERC-721 on 3/7/2018
1190       interfaceID == 0x780e9d63; // ERC721Enumerable
1191   }
1192 
1193   function setTokenMetadataBaseURI(string _newBaseURI) external onlyCEOOrCOO {
1194     tokenMetadataBaseURI = _newBaseURI;
1195   }
1196 
1197   /**
1198   * @notice Guarantees msg.sender is owner of the given token
1199   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
1200   */
1201   modifier onlyOwnerOf(uint256 _tokenId) {
1202     require(ownerOf(_tokenId) == msg.sender);
1203     _;
1204   }
1205 
1206   /**
1207   * @notice Gets the total amount of tokens stored by the contract
1208   * @return uint256 representing the total amount of tokens
1209   */
1210   function totalSupply() public view returns (uint256) {
1211     return totalTokens;
1212   }
1213 
1214   /**
1215   * @notice Enumerate valid NFTs
1216   * @dev Our Licenses are kept in an array and each new License-token is just
1217   * the next element in the array. This method is required for ERC721Enumerable
1218   * which may support more complicated storage schemes. However, in our case the
1219   * _index is the tokenId
1220   * @param _index A counter less than `totalSupply()`
1221   * @return The token identifier for the `_index`th NFT
1222   */
1223   function tokenByIndex(uint256 _index) external view returns (uint256) {
1224     require(_index < totalSupply());
1225     return _index;
1226   }
1227 
1228   /**
1229   * @notice Gets the balance of the specified address
1230   * @param _owner address to query the balance of
1231   * @return uint256 representing the amount owned by the passed address
1232   */
1233   function balanceOf(address _owner) public view returns (uint256) {
1234     require(_owner != address(0));
1235     return ownedTokens[_owner].length;
1236   }
1237 
1238   /**
1239   * @notice Gets the list of tokens owned by a given address
1240   * @param _owner address to query the tokens of
1241   * @return uint256[] representing the list of tokens owned by the passed address
1242   */
1243   function tokensOf(address _owner) public view returns (uint256[]) {
1244     return ownedTokens[_owner];
1245   }
1246 
1247   /**
1248   * @notice Enumerate NFTs assigned to an owner
1249   * @dev Throws if `_index` >= `balanceOf(_owner)` or if
1250   *  `_owner` is the zero address, representing invalid NFTs.
1251   * @param _owner An address where we are interested in NFTs owned by them
1252   * @param _index A counter less than `balanceOf(_owner)`
1253   * @return The token identifier for the `_index`th NFT assigned to `_owner`,
1254   */
1255   function tokenOfOwnerByIndex(address _owner, uint256 _index)
1256     external
1257     view
1258     returns (uint256 _tokenId)
1259   {
1260     require(_index < balanceOf(_owner));
1261     return ownedTokens[_owner][_index];
1262   }
1263 
1264   /**
1265   * @notice Gets the owner of the specified token ID
1266   * @param _tokenId uint256 ID of the token to query the owner of
1267   * @return owner address currently marked as the owner of the given token ID
1268   */
1269   function ownerOf(uint256 _tokenId) public view returns (address) {
1270     address owner = tokenOwner[_tokenId];
1271     require(owner != address(0));
1272     return owner;
1273   }
1274 
1275   /**
1276    * @notice Gets the approved address to take ownership of a given token ID
1277    * @param _tokenId uint256 ID of the token to query the approval of
1278    * @return address currently approved to take ownership of the given token ID
1279    */
1280   function getApproved(uint256 _tokenId) public view returns (address) {
1281     return tokenApprovals[_tokenId];
1282   }
1283 
1284   /**
1285    * @notice Tells whether the msg.sender is approved to transfer the given token ID or not
1286    * Checks both for specific approval and operator approval
1287    * @param _tokenId uint256 ID of the token to query the approval of
1288    * @return bool whether transfer by msg.sender is approved for the given token ID or not
1289    */
1290   function isSenderApprovedFor(uint256 _tokenId) internal view returns (bool) {
1291     return
1292       ownerOf(_tokenId) == msg.sender ||
1293       isSpecificallyApprovedFor(msg.sender, _tokenId) ||
1294       isApprovedForAll(ownerOf(_tokenId), msg.sender);
1295   }
1296 
1297   /**
1298    * @notice Tells whether the msg.sender is approved for the given token ID or not
1299    * @param _asker address of asking for approval
1300    * @param _tokenId uint256 ID of the token to query the approval of
1301    * @return bool whether the msg.sender is approved for the given token ID or not
1302    */
1303   function isSpecificallyApprovedFor(address _asker, uint256 _tokenId) internal view returns (bool) {
1304     return getApproved(_tokenId) == _asker;
1305   }
1306 
1307   /**
1308    * @notice Tells whether an operator is approved by a given owner
1309    * @param _owner owner address which you want to query the approval of
1310    * @param _operator operator address which you want to query the approval of
1311    * @return bool whether the given operator is approved by the given owner
1312    */
1313   function isApprovedForAll(address _owner, address _operator) public view returns (bool)
1314   {
1315     return operatorApprovals[_owner][_operator];
1316   }
1317 
1318   /**
1319   * @notice Transfers the ownership of a given token ID to another address
1320   * @param _to address to receive the ownership of the given token ID
1321   * @param _tokenId uint256 ID of the token to be transferred
1322   */
1323   function transfer(address _to, uint256 _tokenId)
1324     external
1325     whenNotPaused
1326     onlyOwnerOf(_tokenId)
1327   {
1328     _clearApprovalAndTransfer(msg.sender, _to, _tokenId);
1329   }
1330 
1331   /**
1332   * @notice Approves another address to claim for the ownership of the given token ID
1333   * @param _to address to be approved for the given token ID
1334   * @param _tokenId uint256 ID of the token to be approved
1335   */
1336   function approve(address _to, uint256 _tokenId)
1337     external
1338     whenNotPaused
1339     onlyOwnerOf(_tokenId)
1340   {
1341     address owner = ownerOf(_tokenId);
1342     require(_to != owner);
1343     if (getApproved(_tokenId) != 0 || _to != 0) {
1344       tokenApprovals[_tokenId] = _to;
1345       Approval(owner, _to, _tokenId);
1346     }
1347   }
1348 
1349   /**
1350   * @notice Enable or disable approval for a third party ("operator") to manage all your assets
1351   * @dev Emits the ApprovalForAll event
1352   * @param _to Address to add to the set of authorized operators.
1353   * @param _approved True if the operators is approved, false to revoke approval
1354   */
1355   function setApprovalForAll(address _to, bool _approved)
1356     external
1357     whenNotPaused
1358   {
1359     if(_approved) {
1360       approveAll(_to);
1361     } else {
1362       disapproveAll(_to);
1363     }
1364   }
1365 
1366   /**
1367   * @notice Approves another address to claim for the ownership of any tokens owned by this account
1368   * @param _to address to be approved for the given token ID
1369   */
1370   function approveAll(address _to)
1371     public
1372     whenNotPaused
1373   {
1374     require(_to != msg.sender);
1375     require(_to != address(0));
1376     operatorApprovals[msg.sender][_to] = true;
1377     ApprovalForAll(msg.sender, _to, true);
1378   }
1379 
1380   /**
1381   * @notice Removes approval for another address to claim for the ownership of any
1382   *  tokens owned by this account.
1383   * @dev Note that this only removes the operator approval and
1384   *  does not clear any independent, specific approvals of token transfers to this address
1385   * @param _to address to be disapproved for the given token ID
1386   */
1387   function disapproveAll(address _to)
1388     public
1389     whenNotPaused
1390   {
1391     require(_to != msg.sender);
1392     delete operatorApprovals[msg.sender][_to];
1393     ApprovalForAll(msg.sender, _to, false);
1394   }
1395 
1396   /**
1397   * @notice Claims the ownership of a given token ID
1398   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
1399   */
1400   function takeOwnership(uint256 _tokenId)
1401    external
1402    whenNotPaused
1403   {
1404     require(isSenderApprovedFor(_tokenId));
1405     _clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
1406   }
1407 
1408   /**
1409   * @notice Transfer a token owned by another address, for which the calling address has
1410   *  previously been granted transfer approval by the owner.
1411   * @param _from The address that owns the token
1412   * @param _to The address that will take ownership of the token. Can be any address, including the caller
1413   * @param _tokenId The ID of the token to be transferred
1414   */
1415   function transferFrom(
1416     address _from,
1417     address _to,
1418     uint256 _tokenId
1419   )
1420     public
1421     whenNotPaused
1422   {
1423     require(isSenderApprovedFor(_tokenId));
1424     require(ownerOf(_tokenId) == _from);
1425     _clearApprovalAndTransfer(ownerOf(_tokenId), _to, _tokenId);
1426   }
1427 
1428   /**
1429   * @notice Transfers the ownership of an NFT from one address to another address
1430   * @dev Throws unless `msg.sender` is the current owner, an authorized
1431   * operator, or the approved address for this NFT. Throws if `_from` is
1432   * not the current owner. Throws if `_to` is the zero address. Throws if
1433   * `_tokenId` is not a valid NFT. When transfer is complete, this function
1434   * checks if `_to` is a smart contract (code size > 0). If so, it calls
1435   * `onERC721Received` on `_to` and throws if the return value is not
1436   * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
1437   * @param _from The current owner of the NFT
1438   * @param _to The new owner
1439   * @param _tokenId The NFT to transfer
1440   * @param _data Additional data with no specified format, sent in call to `_to`
1441   */
1442   function safeTransferFrom(
1443     address _from,
1444     address _to,
1445     uint256 _tokenId,
1446     bytes _data
1447   )
1448     public
1449     whenNotPaused
1450   {
1451     require(_to != address(0));
1452     require(_isValidLicense(_tokenId));
1453     transferFrom(_from, _to, _tokenId);
1454     if (_isContract(_to)) {
1455       bytes4 tokenReceiverResponse = ERC721TokenReceiver(_to).onERC721Received.gas(50000)(
1456         _from, _tokenId, _data
1457       );
1458       require(tokenReceiverResponse == bytes4(keccak256("onERC721Received(address,uint256,bytes)")));
1459     }
1460   }
1461 
1462   /*
1463    * @notice Transfers the ownership of an NFT from one address to another address
1464    * @dev This works identically to the other function with an extra data parameter,
1465    *  except this function just sets data to ""
1466    * @param _from The current owner of the NFT
1467    * @param _to The new owner
1468    * @param _tokenId The NFT to transfer
1469   */
1470   function safeTransferFrom(
1471     address _from,
1472     address _to,
1473     uint256 _tokenId
1474   )
1475     external
1476     whenNotPaused
1477   {
1478     safeTransferFrom(_from, _to, _tokenId, "");
1479   }
1480 
1481   /**
1482   * @notice Mint token function
1483   * @param _to The address that will own the minted token
1484   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1485   */
1486   function _mint(address _to, uint256 _tokenId) internal {
1487     require(_to != address(0));
1488     _addToken(_to, _tokenId);
1489     Transfer(0x0, _to, _tokenId);
1490   }
1491 
1492   /**
1493   * @notice Internal function to clear current approval and transfer the ownership of a given token ID
1494   * @param _from address which you want to send tokens from
1495   * @param _to address which you want to transfer the token to
1496   * @param _tokenId uint256 ID of the token to be transferred
1497   */
1498   function _clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
1499     require(_to != address(0));
1500     require(_to != ownerOf(_tokenId));
1501     require(ownerOf(_tokenId) == _from);
1502     require(_isValidLicense(_tokenId));
1503 
1504     _clearApproval(_from, _tokenId);
1505     _removeToken(_from, _tokenId);
1506     _addToken(_to, _tokenId);
1507     Transfer(_from, _to, _tokenId);
1508   }
1509 
1510   /**
1511   * @notice Internal function to clear current approval of a given token ID
1512   * @param _tokenId uint256 ID of the token to be transferred
1513   */
1514   function _clearApproval(address _owner, uint256 _tokenId) private {
1515     require(ownerOf(_tokenId) == _owner);
1516     tokenApprovals[_tokenId] = 0;
1517     Approval(_owner, 0, _tokenId);
1518   }
1519 
1520   /**
1521   * @notice Internal function to add a token ID to the list of a given address
1522   * @param _to address representing the new owner of the given token ID
1523   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1524   */
1525   function _addToken(address _to, uint256 _tokenId) private {
1526     require(tokenOwner[_tokenId] == address(0));
1527     tokenOwner[_tokenId] = _to;
1528     uint256 length = balanceOf(_to);
1529     ownedTokens[_to].push(_tokenId);
1530     ownedTokensIndex[_tokenId] = length;
1531     totalTokens = totalTokens.add(1);
1532   }
1533 
1534   /**
1535   * @notice Internal function to remove a token ID from the list of a given address
1536   * @param _from address representing the previous owner of the given token ID
1537   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1538   */
1539   function _removeToken(address _from, uint256 _tokenId) private {
1540     require(ownerOf(_tokenId) == _from);
1541 
1542     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1543     uint256 lastTokenIndex = balanceOf(_from).sub(1);
1544     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1545 
1546     tokenOwner[_tokenId] = 0;
1547     ownedTokens[_from][tokenIndex] = lastToken;
1548     ownedTokens[_from][lastTokenIndex] = 0;
1549     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1550     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1551     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1552 
1553     ownedTokens[_from].length--;
1554     ownedTokensIndex[_tokenId] = 0;
1555     ownedTokensIndex[lastToken] = tokenIndex;
1556     totalTokens = totalTokens.sub(1);
1557   }
1558 
1559   function _isContract(address addr) internal view returns (bool) {
1560     uint size;
1561     assembly { size := extcodesize(addr) }
1562     return size > 0;
1563   }
1564 }
1565 
1566 contract LicenseSale is LicenseOwnership {
1567   AffiliateProgram public affiliateProgram;
1568 
1569   /**
1570    * @notice We credit affiliates for renewals that occur within this time of
1571    * original purchase. E.g. If this is set to 1 year, and someone subscribes to
1572    * a monthly plan, the affiliate will receive credits for that whole year, as
1573    * the user renews their plan
1574    */
1575   uint256 public renewalsCreditAffiliatesFor = 1 years;
1576 
1577   /** internal **/
1578   function _performPurchase(
1579     uint256 _productId,
1580     uint256 _numCycles,
1581     address _assignee,
1582     uint256 _attributes,
1583     address _affiliate)
1584     internal returns (uint)
1585   {
1586     _purchaseOneUnitInStock(_productId);
1587     return _createLicense(
1588       _productId,
1589       _numCycles,
1590       _assignee,
1591       _attributes,
1592       _affiliate
1593       );
1594   }
1595 
1596   function _createLicense(
1597     uint256 _productId,
1598     uint256 _numCycles,
1599     address _assignee,
1600     uint256 _attributes,
1601     address _affiliate)
1602     internal
1603     returns (uint)
1604   {
1605     // You cannot create a subscription license with zero cycles
1606     if(isSubscriptionProduct(_productId)) {
1607       require(_numCycles != 0);
1608     }
1609 
1610     // Non-subscription products have an expiration time of 0, meaning "no-expiration"
1611     uint256 expirationTime = isSubscriptionProduct(_productId) ?
1612       now.add(intervalOf(_productId).mul(_numCycles)) : // solium-disable-line security/no-block-members
1613       0;
1614 
1615     License memory _license = License({
1616       productId: _productId,
1617       attributes: _attributes,
1618       issuedTime: now, // solium-disable-line security/no-block-members
1619       expirationTime: expirationTime,
1620       affiliate: _affiliate
1621     });
1622 
1623     uint256 newLicenseId = licenses.push(_license) - 1; // solium-disable-line zeppelin/no-arithmetic-operations
1624     LicenseIssued(
1625       _assignee,
1626       msg.sender,
1627       newLicenseId,
1628       _license.productId,
1629       _license.attributes,
1630       _license.issuedTime,
1631       _license.expirationTime,
1632       _license.affiliate);
1633     _mint(_assignee, newLicenseId);
1634     return newLicenseId;
1635   }
1636 
1637   function _handleAffiliate(
1638     address _affiliate,
1639     uint256 _productId,
1640     uint256 _licenseId,
1641     uint256 _purchaseAmount)
1642     internal
1643   {
1644     uint256 affiliateCut = affiliateProgram.cutFor(
1645       _affiliate,
1646       _productId,
1647       _licenseId,
1648       _purchaseAmount);
1649     if(affiliateCut > 0) {
1650       require(affiliateCut < _purchaseAmount);
1651       affiliateProgram.credit.value(affiliateCut)(_affiliate, _licenseId);
1652     }
1653   }
1654 
1655   function _performRenewal(uint256 _tokenId, uint256 _numCycles) internal {
1656     // You cannot renew a non-expiring license
1657     // ... but in what scenario can this happen?
1658     // require(licenses[_tokenId].expirationTime != 0);
1659     uint256 productId = licenseProductId(_tokenId);
1660 
1661     // If our expiration is in the future, renewing adds time to that future expiration
1662     // If our expiration has passed already, then we use `now` as the base.
1663     uint256 renewalBaseTime = Math.max256(now, licenses[_tokenId].expirationTime);
1664 
1665     // We assume that the payment has been validated outside of this function
1666     uint256 newExpirationTime = renewalBaseTime.add(intervalOf(productId).mul(_numCycles));
1667 
1668     licenses[_tokenId].expirationTime = newExpirationTime;
1669 
1670     LicenseRenewal(
1671       ownerOf(_tokenId),
1672       msg.sender,
1673       _tokenId,
1674       productId,
1675       newExpirationTime
1676     );
1677   }
1678 
1679   function _affiliateProgramIsActive() internal view returns (bool) {
1680     return
1681       affiliateProgram != address(0) &&
1682       affiliateProgram.storeAddress() == address(this) &&
1683       !affiliateProgram.paused();
1684   }
1685 
1686   /** executives **/
1687   function setAffiliateProgramAddress(address _address) external onlyCEO {
1688     AffiliateProgram candidateContract = AffiliateProgram(_address);
1689     require(candidateContract.isAffiliateProgram());
1690     affiliateProgram = candidateContract;
1691   }
1692 
1693   function setRenewalsCreditAffiliatesFor(uint256 _newTime) external onlyCEO {
1694     renewalsCreditAffiliatesFor = _newTime;
1695   }
1696 
1697   function createPromotionalPurchase(
1698     uint256 _productId,
1699     uint256 _numCycles,
1700     address _assignee,
1701     uint256 _attributes
1702     )
1703     external
1704     onlyCEOOrCOO
1705     whenNotPaused
1706     returns (uint256)
1707   {
1708     return _performPurchase(
1709       _productId,
1710       _numCycles,
1711       _assignee,
1712       _attributes,
1713       address(0));
1714   }
1715 
1716   function createPromotionalRenewal(
1717     uint256 _tokenId,
1718     uint256 _numCycles
1719     )
1720     external
1721     onlyCEOOrCOO
1722     whenNotPaused
1723   {
1724     uint256 productId = licenseProductId(_tokenId);
1725     _requireRenewableProduct(productId);
1726 
1727     return _performRenewal(_tokenId, _numCycles);
1728   }
1729 
1730   /** anyone **/
1731 
1732   /**
1733   * @notice Makes a purchase of a product.
1734   * @dev Requires that the value sent is exactly the price of the product
1735   * @param _productId - the product to purchase
1736   * @param _numCycles - the number of cycles being purchased. This number should be `1` for non-subscription products and the number of cycles for subscriptions.
1737   * @param _assignee - the address to assign the purchase to (doesn't have to be msg.sender)
1738   * @param _affiliate - the address to of the affiliate - use address(0) if none
1739   */
1740   function purchase(
1741     uint256 _productId,
1742     uint256 _numCycles,
1743     address _assignee,
1744     address _affiliate
1745     )
1746     external
1747     payable
1748     whenNotPaused
1749     returns (uint256)
1750   {
1751     require(_productId != 0);
1752     require(_numCycles != 0);
1753     require(_assignee != address(0));
1754     // msg.value can be zero: free products are supported
1755 
1756     // Don't bother dealing with excess payments. Ensure the price paid is
1757     // accurate. No more, no less.
1758     require(msg.value == costForProductCycles(_productId, _numCycles));
1759 
1760     // Non-subscription products should send a _numCycle of 1 -- you can't buy a
1761     // multiple quantity of a non-subscription product with this function
1762     if(!isSubscriptionProduct(_productId)) {
1763       require(_numCycles == 1);
1764     }
1765 
1766     // this can, of course, be gamed by malicious miners. But it's adequate for our application
1767     // Feel free to add your own strategies for product attributes
1768     // solium-disable-next-line security/no-block-members, zeppelin/no-arithmetic-operations
1769     uint256 attributes = uint256(keccak256(block.blockhash(block.number-1)))^_productId^(uint256(_assignee));
1770     uint256 licenseId = _performPurchase(
1771       _productId,
1772       _numCycles,
1773       _assignee,
1774       attributes,
1775       _affiliate);
1776 
1777     if(
1778       priceOf(_productId) > 0 &&
1779       _affiliate != address(0) &&
1780       _affiliateProgramIsActive()
1781     ) {
1782       _handleAffiliate(
1783         _affiliate,
1784         _productId,
1785         licenseId,
1786         msg.value);
1787     }
1788 
1789     return licenseId;
1790   }
1791 
1792   /**
1793    * @notice Renews a subscription
1794    */
1795   function renew(
1796     uint256 _tokenId,
1797     uint256 _numCycles
1798     )
1799     external
1800     payable
1801     whenNotPaused
1802   {
1803     require(_numCycles != 0);
1804     require(ownerOf(_tokenId) != address(0));
1805 
1806     uint256 productId = licenseProductId(_tokenId);
1807     _requireRenewableProduct(productId);
1808 
1809     // No excess payments. Ensure the price paid is exactly accurate. No more,
1810     // no less.
1811     uint256 renewalCost = costForProductCycles(productId, _numCycles);
1812     require(msg.value == renewalCost);
1813 
1814     _performRenewal(_tokenId, _numCycles);
1815 
1816     if(
1817       renewalCost > 0 &&
1818       licenseAffiliate(_tokenId) != address(0) &&
1819       _affiliateProgramIsActive() &&
1820       licenseIssuedTime(_tokenId).add(renewalsCreditAffiliatesFor) > now
1821     ) {
1822       _handleAffiliate(
1823         licenseAffiliate(_tokenId),
1824         productId,
1825         _tokenId,
1826         msg.value);
1827     }
1828   }
1829 
1830 }
1831 
1832 contract LicenseCore is LicenseSale {
1833   address public newContractAddress;
1834 
1835   function LicenseCore() public {
1836     paused = true;
1837 
1838     ceoAddress = msg.sender;
1839     cooAddress = msg.sender;
1840     cfoAddress = msg.sender;
1841     withdrawalAddress = msg.sender;
1842   }
1843 
1844   function setNewAddress(address _v2Address) external onlyCEO whenPaused {
1845     newContractAddress = _v2Address;
1846     ContractUpgrade(_v2Address);
1847   }
1848 
1849   function() external {
1850     assert(false);
1851   }
1852 
1853   function unpause() public onlyCEO whenPaused {
1854     require(newContractAddress == address(0));
1855     super.unpause();
1856   }
1857 }
1858 
1859 library Strings {
1860   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1861   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1862       bytes memory _ba = bytes(_a);
1863       bytes memory _bb = bytes(_b);
1864       bytes memory _bc = bytes(_c);
1865       bytes memory _bd = bytes(_d);
1866       bytes memory _be = bytes(_e);
1867       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1868       bytes memory babcde = bytes(abcde);
1869       uint k = 0;
1870       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1871       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1872       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1873       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1874       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1875       return string(babcde);
1876     }
1877 
1878     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1879         return strConcat(_a, _b, _c, _d, "");
1880     }
1881 
1882     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1883         return strConcat(_a, _b, _c, "", "");
1884     }
1885 
1886     function strConcat(string _a, string _b) internal pure returns (string) {
1887         return strConcat(_a, _b, "", "", "");
1888     }
1889 
1890     function uint2str(uint i) internal pure returns (string) {
1891         if (i == 0) return "0";
1892         uint j = i;
1893         uint len;
1894         while (j != 0){
1895             len++;
1896             j /= 10;
1897         }
1898         bytes memory bstr = new bytes(len);
1899         uint k = len - 1;
1900         while (i != 0){
1901             bstr[k--] = byte(48 + i % 10);
1902             i /= 10;
1903         }
1904         return string(bstr);
1905     }
1906 }