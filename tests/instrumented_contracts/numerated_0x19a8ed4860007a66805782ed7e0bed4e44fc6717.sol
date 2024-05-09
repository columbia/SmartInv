1 pragma solidity ^0.4.24;
2 
3 // File: zos-lib/contracts/migrations/Migratable.sol
4 
5 /**
6  * @title Migratable
7  * Helper contract to support intialization and migration schemes between
8  * different implementations of a contract in the context of upgradeability.
9  * To use it, replace the constructor with a function that has the
10  * `isInitializer` modifier starting with `"0"` as `migrationId`.
11  * When you want to apply some migration code during an upgrade, increase
12  * the `migrationId`. Or, if the migration code must be applied only after
13  * another migration has been already applied, use the `isMigration` modifier.
14  * This helper supports multiple inheritance.
15  * WARNING: It is the developer's responsibility to ensure that migrations are
16  * applied in a correct order, or that they are run at all.
17  * See `Initializable` for a simpler version.
18  */
19 contract Migratable {
20   /**
21    * @dev Emitted when the contract applies a migration.
22    * @param contractName Name of the Contract.
23    * @param migrationId Identifier of the migration applied.
24    */
25   event Migrated(string contractName, string migrationId);
26 
27   /**
28    * @dev Mapping of the already applied migrations.
29    * (contractName => (migrationId => bool))
30    */
31   mapping (string => mapping (string => bool)) internal migrated;
32 
33   /**
34    * @dev Internal migration id used to specify that a contract has already been initialized.
35    */
36   string constant private INITIALIZED_ID = "initialized";
37 
38 
39   /**
40    * @dev Modifier to use in the initialization function of a contract.
41    * @param contractName Name of the contract.
42    * @param migrationId Identifier of the migration.
43    */
44   modifier isInitializer(string contractName, string migrationId) {
45     validateMigrationIsPending(contractName, INITIALIZED_ID);
46     validateMigrationIsPending(contractName, migrationId);
47     _;
48     emit Migrated(contractName, migrationId);
49     migrated[contractName][migrationId] = true;
50     migrated[contractName][INITIALIZED_ID] = true;
51   }
52 
53   /**
54    * @dev Modifier to use in the migration of a contract.
55    * @param contractName Name of the contract.
56    * @param requiredMigrationId Identifier of the previous migration, required
57    * to apply new one.
58    * @param newMigrationId Identifier of the new migration to be applied.
59    */
60   modifier isMigration(string contractName, string requiredMigrationId, string newMigrationId) {
61     require(isMigrated(contractName, requiredMigrationId), "Prerequisite migration ID has not been run yet");
62     validateMigrationIsPending(contractName, newMigrationId);
63     _;
64     emit Migrated(contractName, newMigrationId);
65     migrated[contractName][newMigrationId] = true;
66   }
67 
68   /**
69    * @dev Returns true if the contract migration was applied.
70    * @param contractName Name of the contract.
71    * @param migrationId Identifier of the migration.
72    * @return true if the contract migration was applied, false otherwise.
73    */
74   function isMigrated(string contractName, string migrationId) public view returns(bool) {
75     return migrated[contractName][migrationId];
76   }
77 
78   /**
79    * @dev Initializer that marks the contract as initialized.
80    * It is important to run this if you had deployed a previous version of a Migratable contract.
81    * For more information see https://github.com/zeppelinos/zos-lib/issues/158.
82    */
83   function initialize() isInitializer("Migratable", "1.2.1") public {
84   }
85 
86   /**
87    * @dev Reverts if the requested migration was already executed.
88    * @param contractName Name of the contract.
89    * @param migrationId Identifier of the migration.
90    */
91   function validateMigrationIsPending(string contractName, string migrationId) private view {
92     require(!isMigrated(contractName, migrationId), "Requested target migration ID has already been run");
93   }
94 }
95 
96 // File: openzeppelin-zos/contracts/ownership/Ownable.sol
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable is Migratable {
104   address public owner;
105 
106 
107   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109   /**
110    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
111    * account.
112    */
113   function initialize(address _sender) public isInitializer("Ownable", "1.9.0") {
114     owner = _sender;
115   }
116 
117   /**
118    * @dev Throws if called by any account other than the owner.
119    */
120   modifier onlyOwner() {
121     require(msg.sender == owner);
122     _;
123   }
124 
125   /**
126    * @dev Allows the current owner to transfer control of the contract to a newOwner.
127    * @param newOwner The address to transfer ownership to.
128    */
129   function transferOwnership(address newOwner) public onlyOwner {
130     require(newOwner != address(0));
131     emit OwnershipTransferred(owner, newOwner);
132     owner = newOwner;
133   }
134 
135 }
136 
137 // File: openzeppelin-zos/contracts/lifecycle/Pausable.sol
138 
139 /**
140  * @title Pausable
141  * @dev Base contract which allows children to implement an emergency stop mechanism.
142  */
143 contract Pausable is Migratable, Ownable {
144   event Pause();
145   event Unpause();
146 
147   bool public paused = false;
148 
149 
150   function initialize(address _sender) isInitializer("Pausable", "1.9.0")  public {
151     Ownable.initialize(_sender);
152   }
153 
154   /**
155    * @dev Modifier to make a function callable only when the contract is not paused.
156    */
157   modifier whenNotPaused() {
158     require(!paused);
159     _;
160   }
161 
162   /**
163    * @dev Modifier to make a function callable only when the contract is paused.
164    */
165   modifier whenPaused() {
166     require(paused);
167     _;
168   }
169 
170   /**
171    * @dev called by the owner to pause, triggers stopped state
172    */
173   function pause() onlyOwner whenNotPaused public {
174     paused = true;
175     emit Pause();
176   }
177 
178   /**
179    * @dev called by the owner to unpause, returns to normal state
180    */
181   function unpause() onlyOwner whenPaused public {
182     paused = false;
183     emit Unpause();
184   }
185 }
186 
187 // File: openzeppelin-zos/contracts/math/SafeMath.sol
188 
189 /**
190  * @title SafeMath
191  * @dev Math operations with safety checks that throw on error
192  */
193 library SafeMath {
194 
195   /**
196   * @dev Multiplies two numbers, throws on overflow.
197   */
198   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
199     if (a == 0) {
200       return 0;
201     }
202     c = a * b;
203     assert(c / a == b);
204     return c;
205   }
206 
207   /**
208   * @dev Integer division of two numbers, truncating the quotient.
209   */
210   function div(uint256 a, uint256 b) internal pure returns (uint256) {
211     // assert(b > 0); // Solidity automatically throws when dividing by 0
212     // uint256 c = a / b;
213     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214     return a / b;
215   }
216 
217   /**
218   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
219   */
220   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
221     assert(b <= a);
222     return a - b;
223   }
224 
225   /**
226   * @dev Adds two numbers, throws on overflow.
227   */
228   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
229     c = a + b;
230     assert(c >= a);
231     return c;
232   }
233 }
234 
235 // File: openzeppelin-zos/contracts/AddressUtils.sol
236 
237 /**
238  * Utility library of inline functions on addresses
239  */
240 library AddressUtils {
241 
242   /**
243    * Returns whether the target address is a contract
244    * @dev This function will return false if invoked during the constructor of a contract,
245    *  as the code is not actually created until after the constructor finishes.
246    * @param addr address to check
247    * @return whether the target address is a contract
248    */
249   function isContract(address addr) internal view returns (bool) {
250     uint256 size;
251     // XXX Currently there is no better way to check if there is a contract in an address
252     // than to check the size of the code at that address.
253     // See https://ethereum.stackexchange.com/a/14016/36603
254     // for more details about how this works.
255     // TODO Check this again before the Serenity release, because all addresses will be
256     // contracts then.
257     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
258     return size > 0;
259   }
260 
261 }
262 
263 // File: contracts/marketplace/MarketplaceStorage.sol
264 
265 /**
266  * @title Interface for contracts conforming to ERC-20
267  */
268 contract ERC20Interface {
269   function transferFrom(address from, address to, uint tokens) public returns (bool success);
270 }
271 
272 
273 /**
274  * @title Interface for contracts conforming to ERC-721
275  */
276 contract ERC721Interface {
277   function ownerOf(uint256 _tokenId) public view returns (address _owner);
278   function approve(address _to, uint256 _tokenId) public;
279   function getApproved(uint256 _tokenId) public view returns (address);
280   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
281   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
282   function supportsInterface(bytes4) public view returns (bool);
283 }
284 
285 
286 contract ERC721Verifiable is ERC721Interface {
287   function verifyFingerprint(uint256, bytes) public view returns (bool);
288 }
289 
290 
291 contract MarketplaceStorage {
292   ERC20Interface public acceptedToken;
293 
294   struct Order {
295     // Order ID
296     bytes32 id;
297     // Owner of the NFT
298     address seller;
299     // NFT registry address
300     address nftAddress;
301     // Price (in wei) for the published item
302     uint256 price;
303     // Time when this sale ends
304     uint256 expiresAt;
305   }
306 
307   // From ERC721 registry assetId to Order (to avoid asset collision)
308   mapping (address => mapping(uint256 => Order)) public orderByAssetId;
309 
310   uint256 public ownerCutPerMillion;
311   uint256 public publicationFeeInWei;
312 
313   address public legacyNFTAddress;
314 
315   bytes4 public constant InterfaceId_ValidateFingerprint = bytes4(
316     keccak256("verifyFingerprint(uint256,bytes)")
317   );
318 
319   bytes4 public constant ERC721_Interface = bytes4(0x80ac58cd);
320 
321   // EVENTS
322   event OrderCreated(
323     bytes32 id,
324     uint256 indexed assetId,
325     address indexed seller,
326     address nftAddress,
327     uint256 priceInWei,
328     uint256 expiresAt
329   );
330   event OrderSuccessful(
331     bytes32 id,
332     uint256 indexed assetId,
333     address indexed seller,
334     address nftAddress,
335     uint256 totalPrice,
336     address indexed buyer
337   );
338   event OrderCancelled(
339     bytes32 id,
340     uint256 indexed assetId,
341     address indexed seller,
342     address nftAddress
343   );
344 
345   event ChangedPublicationFee(uint256 publicationFee);
346   event ChangedOwnerCutPerMillion(uint256 ownerCutPerMillion);
347   event ChangeLegacyNFTAddress(address indexed legacyNFTAddress);
348 
349   // [LEGACY] Auction events
350   event AuctionCreated(
351     bytes32 id,
352     uint256 indexed assetId,
353     address indexed seller,
354     uint256 priceInWei,
355     uint256 expiresAt
356   );
357   event AuctionSuccessful(
358     bytes32 id,
359     uint256 indexed assetId,
360     address indexed seller,
361     uint256 totalPrice,
362     address indexed winner
363   );
364   event AuctionCancelled(
365     bytes32 id,
366     uint256 indexed assetId,
367     address indexed seller
368   );
369 }
370 
371 // File: contracts/marketplace/Marketplace.sol
372 
373 contract Marketplace is Migratable, Ownable, Pausable, MarketplaceStorage {
374   using SafeMath for uint256;
375   using AddressUtils for address;
376 
377   /**
378     * @dev Sets the publication fee that's charged to users to publish items
379     * @param _publicationFee - Fee amount in wei this contract charges to publish an item
380     */
381   function setPublicationFee(uint256 _publicationFee) external onlyOwner {
382     publicationFeeInWei = _publicationFee;
383     emit ChangedPublicationFee(publicationFeeInWei);
384   }
385 
386   /**
387     * @dev Sets the share cut for the owner of the contract that's
388     *  charged to the seller on a successful sale
389     * @param _ownerCutPerMillion - Share amount, from 0 to 999,999
390     */
391   function setOwnerCutPerMillion(uint256 _ownerCutPerMillion) external onlyOwner {
392     require(_ownerCutPerMillion < 1000000, "The owner cut should be between 0 and 999,999");
393 
394     ownerCutPerMillion = _ownerCutPerMillion;
395     emit ChangedOwnerCutPerMillion(ownerCutPerMillion);
396   }
397 
398   /**
399     * @dev Sets the legacy NFT address to be used
400     * @param _legacyNFTAddress - Address of the NFT address used for legacy methods that don't have nftAddress as parameter
401     */
402   function setLegacyNFTAddress(address _legacyNFTAddress) external onlyOwner {
403     _requireERC721(_legacyNFTAddress);
404 
405     legacyNFTAddress = _legacyNFTAddress;
406     emit ChangeLegacyNFTAddress(legacyNFTAddress);
407   }
408 
409   /**
410     * @dev Initialize this contract. Acts as a constructor
411     * @param _acceptedToken - Address of the ERC20 accepted for this marketplace
412     * @param _legacyNFTAddress - Address of the NFT address used for legacy methods that don't have nftAddress as parameter
413     */
414   function initialize(
415     address _acceptedToken,
416     address _legacyNFTAddress,
417     address _owner
418   )
419     public
420     isInitializer("Marketplace", "0.0.1")
421   {
422 
423     // msg.sender is the App contract not the real owner. Calls ownable behind the scenes...sigh
424     require(_owner != address(0), "Invalid owner");
425     Pausable.initialize(_owner);
426 
427     require(_acceptedToken.isContract(), "The accepted token address must be a deployed contract");
428     acceptedToken = ERC20Interface(_acceptedToken);
429 
430     _requireERC721(_legacyNFTAddress);
431     legacyNFTAddress = _legacyNFTAddress;
432   }
433 
434   /**
435     * @dev Creates a new order
436     * @param nftAddress - Non fungible registry address
437     * @param assetId - ID of the published NFT
438     * @param priceInWei - Price in Wei for the supported coin
439     * @param expiresAt - Duration of the order (in hours)
440     */
441   function createOrder(
442     address nftAddress,
443     uint256 assetId,
444     uint256 priceInWei,
445     uint256 expiresAt
446   )
447     public
448     whenNotPaused
449   {
450     _createOrder(
451       nftAddress,
452       assetId,
453       priceInWei,
454       expiresAt
455     );
456   }
457 
458   /**
459     * @dev [LEGACY] Creates a new order
460     * @param assetId - ID of the published NFT
461     * @param priceInWei - Price in Wei for the supported coin
462     * @param expiresAt - Duration of the order (in hours)
463     */
464   function createOrder(
465     uint256 assetId,
466     uint256 priceInWei,
467     uint256 expiresAt
468   )
469     public
470     whenNotPaused
471   {
472     _createOrder(
473       legacyNFTAddress,
474       assetId,
475       priceInWei,
476       expiresAt
477     );
478 
479     Order memory order = orderByAssetId[legacyNFTAddress][assetId];
480     emit AuctionCreated(
481       order.id,
482       assetId,
483       order.seller,
484       order.price,
485       order.expiresAt
486     );
487   }
488 
489   /**
490     * @dev Cancel an already published order
491     *  can only be canceled by seller or the contract owner
492     * @param nftAddress - Address of the NFT registry
493     * @param assetId - ID of the published NFT
494     */
495   function cancelOrder(address nftAddress, uint256 assetId) public whenNotPaused {
496     _cancelOrder(nftAddress, assetId);
497   }
498 
499   /**
500     * @dev [LEGACY] Cancel an already published order
501     *  can only be canceled by seller or the contract owner
502     * @param assetId - ID of the published NFT
503     */
504   function cancelOrder(uint256 assetId) public whenNotPaused {
505     Order memory order = _cancelOrder(legacyNFTAddress, assetId);
506 
507     emit AuctionCancelled(
508       order.id,
509       assetId,
510       order.seller
511     );
512   }
513 
514   /**
515     * @dev Executes the sale for a published NFT and checks for the asset fingerprint
516     * @param nftAddress - Address of the NFT registry
517     * @param assetId - ID of the published NFT
518     * @param price - Order price
519     * @param fingerprint - Verification info for the asset
520     */
521   function safeExecuteOrder(
522     address nftAddress,
523     uint256 assetId,
524     uint256 price,
525     bytes fingerprint
526   )
527    public
528    whenNotPaused
529   {
530     _executeOrder(
531       nftAddress,
532       assetId,
533       price,
534       fingerprint
535     );
536   }
537 
538   /**
539     * @dev Executes the sale for a published NFT
540     * @param nftAddress - Address of the NFT registry
541     * @param assetId - ID of the published NFT
542     * @param price - Order price
543     */
544   function executeOrder(
545     address nftAddress,
546     uint256 assetId,
547     uint256 price
548   )
549    public
550    whenNotPaused
551   {
552     _executeOrder(
553       nftAddress,
554       assetId,
555       price,
556       ""
557     );
558   }
559 
560   /**
561     * @dev [LEGACY] Executes the sale for a published NFT
562     * @param assetId - ID of the published NFT
563     * @param price - Order price
564     */
565   function executeOrder(
566     uint256 assetId,
567     uint256 price
568   )
569    public
570    whenNotPaused
571   {
572     Order memory order = _executeOrder(
573       legacyNFTAddress,
574       assetId,
575       price,
576       ""
577     );
578 
579     emit AuctionSuccessful(
580       order.id,
581       assetId,
582       order.seller,
583       price,
584       msg.sender
585     );
586   }
587 
588   /**
589     * @dev [LEGACY] Gets an order using the legacy NFT address.
590     * @dev It's equivalent to orderByAssetId[legacyNFTAddress][assetId] but returns same structure as the old Auction
591     * @param assetId - ID of the published NFT
592     */
593   function auctionByAssetId(
594     uint256 assetId
595   )
596     public
597     view
598     returns
599     (bytes32, address, uint256, uint256)
600   {
601     Order memory order = orderByAssetId[legacyNFTAddress][assetId];
602     return (order.id, order.seller, order.price, order.expiresAt);
603   }
604 
605   /**
606     * @dev Creates a new order
607     * @param nftAddress - Non fungible registry address
608     * @param assetId - ID of the published NFT
609     * @param priceInWei - Price in Wei for the supported coin
610     * @param expiresAt - Duration of the order (in hours)
611     */
612   function _createOrder(
613     address nftAddress,
614     uint256 assetId,
615     uint256 priceInWei,
616     uint256 expiresAt
617   )
618     internal
619   {
620     _requireERC721(nftAddress);
621 
622     ERC721Interface nftRegistry = ERC721Interface(nftAddress);
623     address assetOwner = nftRegistry.ownerOf(assetId);
624 
625     require(msg.sender == assetOwner, "Only the owner can create orders");
626     require(
627       nftRegistry.getApproved(assetId) == address(this) || nftRegistry.isApprovedForAll(assetOwner, address(this)),
628       "The contract is not authorized to manage the asset"
629     );
630     require(priceInWei > 0, "Price should be bigger than 0");
631     require(expiresAt > block.timestamp.add(1 minutes), "Publication should be more than 1 minute in the future");
632 
633     bytes32 orderId = keccak256(
634       abi.encodePacked(
635         block.timestamp,
636         assetOwner,
637         assetId,
638         nftAddress,
639         priceInWei
640       )
641     );
642 
643     orderByAssetId[nftAddress][assetId] = Order({
644       id: orderId,
645       seller: assetOwner,
646       nftAddress: nftAddress,
647       price: priceInWei,
648       expiresAt: expiresAt
649     });
650 
651     // Check if there's a publication fee and
652     // transfer the amount to marketplace owner
653     if (publicationFeeInWei > 0) {
654       require(
655         acceptedToken.transferFrom(msg.sender, owner, publicationFeeInWei),
656         "Transfering the publication fee to the Marketplace owner failed"
657       );
658     }
659 
660     emit OrderCreated(
661       orderId,
662       assetId,
663       assetOwner,
664       nftAddress,
665       priceInWei,
666       expiresAt
667     );
668   }
669 
670   /**
671     * @dev Cancel an already published order
672     *  can only be canceled by seller or the contract owner
673     * @param nftAddress - Address of the NFT registry
674     * @param assetId - ID of the published NFT
675     */
676   function _cancelOrder(address nftAddress, uint256 assetId) internal returns (Order) {
677     Order memory order = orderByAssetId[nftAddress][assetId];
678 
679     require(order.id != 0, "Asset not published");
680     require(order.seller == msg.sender || msg.sender == owner, "Unauthorized user");
681 
682     bytes32 orderId = order.id;
683     address orderSeller = order.seller;
684     address orderNftAddress = order.nftAddress;
685     delete orderByAssetId[nftAddress][assetId];
686 
687     emit OrderCancelled(
688       orderId,
689       assetId,
690       orderSeller,
691       orderNftAddress
692     );
693 
694     return order;
695   }
696 
697   /**
698     * @dev Executes the sale for a published NFT
699     * @param nftAddress - Address of the NFT registry
700     * @param assetId - ID of the published NFT
701     * @param price - Order price
702     * @param fingerprint - Verification info for the asset
703     */
704   function _executeOrder(
705     address nftAddress,
706     uint256 assetId,
707     uint256 price,
708     bytes fingerprint
709   )
710    internal returns (Order)
711   {
712     _requireERC721(nftAddress);
713 
714     ERC721Verifiable nftRegistry = ERC721Verifiable(nftAddress);
715 
716     if (nftRegistry.supportsInterface(InterfaceId_ValidateFingerprint)) {
717       require(
718         nftRegistry.verifyFingerprint(assetId, fingerprint),
719         "The asset fingerprint is not valid"
720       );
721     }
722     Order memory order = orderByAssetId[nftAddress][assetId];
723 
724     require(order.id != 0, "Asset not published");
725 
726     address seller = order.seller;
727 
728     require(seller != address(0), "Invalid address");
729     require(seller != msg.sender, "Unauthorized user");
730     require(order.price == price, "The price is not correct");
731     require(block.timestamp < order.expiresAt, "The order expired");
732     require(seller == nftRegistry.ownerOf(assetId), "The seller is no longer the owner");
733 
734     uint saleShareAmount = 0;
735 
736     bytes32 orderId = order.id;
737     delete orderByAssetId[nftAddress][assetId];
738 
739     if (ownerCutPerMillion > 0) {
740       // Calculate sale share
741       saleShareAmount = price.mul(ownerCutPerMillion).div(1000000);
742 
743       // Transfer share amount for marketplace Owner
744       require(
745         acceptedToken.transferFrom(msg.sender, owner, saleShareAmount),
746         "Transfering the cut to the Marketplace owner failed"
747       );
748     }
749 
750     // Transfer sale amount to seller
751     require(
752       acceptedToken.transferFrom(msg.sender, seller, price.sub(saleShareAmount)),
753       "Transfering the sale amount to the seller failed"
754     );
755 
756     // Transfer asset owner
757     nftRegistry.safeTransferFrom(
758       seller,
759       msg.sender,
760       assetId
761     );
762 
763     emit OrderSuccessful(
764       orderId,
765       assetId,
766       seller,
767       nftAddress,
768       price,
769       msg.sender
770     );
771 
772     return order;
773   }
774 
775   function _requireERC721(address nftAddress) internal view {
776     require(nftAddress.isContract(), "The NFT Address should be a contract");
777 
778     ERC721Interface nftRegistry = ERC721Interface(nftAddress);
779     require(
780       nftRegistry.supportsInterface(ERC721_Interface),
781       "The NFT contract has an invalid ERC721 implementation"
782     );
783   }
784 }