1 pragma solidity ^ 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10      * @dev Multiplies two numbers, throws on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22      * @dev Integer division of two numbers, truncating the quotient.
23      */
24     function div(uint256 a, uint256 b) internal pure returns(uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33      */
34     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40      * @dev Adds two numbers, throws on overflow.
41      */
42     function add(uint256 a, uint256 b) internal pure returns(uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
50 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
51 contract ERC721 {
52     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
53     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
54 
55     // Required methods for ERC-721 Compatibility.
56     function approve(address _to, uint256 _tokenId) external;
57 
58     function transfer(address _to, uint256 _tokenId) external;
59 
60     function transferFrom(address _from, address _to, uint256 _tokenId) external;
61 
62     function ownerOf(uint256 _tokenId) external view returns(address _owner);
63 
64     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
65     function supportsInterface(bytes4 _interfaceID) external view returns(bool);
66 
67     function totalSupply() public view returns(uint256 total);
68 
69     function balanceOf(address _owner) public view returns(uint256 _balance);
70 }
71 
72 contract AnimecardAccessControl {
73     /// @dev Event is fired when contract is forked.
74     event ContractFork(address newContract);
75 
76     /// - CEO: The CEO can reassign other roles, change the addresses of dependent smart contracts,
77     /// and pause/unpause the AnimecardCore contract.
78     /// - CFO: The CFO can withdraw funds from its auction and sale contracts.
79     /// - Manager: The Animator can create regular and promo AnimeCards.
80     address public ceoAddress;
81     address public cfoAddress;
82     address public animatorAddress;
83 
84     /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked.
85     bool public paused = false;
86 
87     /// @dev Access-modifier for CEO-only functionality.
88     modifier onlyCEO() {
89         require(msg.sender == ceoAddress);
90         _;
91     }
92 
93     /// @dev Access-modifier for CFO-only functionality.
94     modifier onlyCFO() {
95         require(msg.sender == cfoAddress);
96         _;
97     }
98 
99     /// @dev Access-modifier for Animator-only functionality.
100     modifier onlyAnimator() {
101         require(msg.sender == animatorAddress);
102         _;
103     }
104 
105     /// @dev Access-modifier for C-level-only functionality.
106     modifier onlyCLevel() {
107         require(
108             msg.sender == animatorAddress ||
109             msg.sender == ceoAddress ||
110             msg.sender == cfoAddress
111         );
112         _;
113     }
114 
115     /// Assigns a new address to the CEO role. Only available to the current CEO.
116     /// @param _newCEO The address of the new CEO
117     function setCEO(address _newCEO) external onlyCEO {
118         require(_newCEO != address(0));
119 
120         ceoAddress = _newCEO;
121     }
122 
123     /// Assigns a new address to act as the CFO. Only available to the current CEO.
124     /// @param _newCFO The address of the new CFO
125     function setCFO(address _newCFO) external onlyCEO {
126         require(_newCFO != address(0));
127 
128         cfoAddress = _newCFO;
129     }
130 
131     /// Assigns a new address to the Animator role. Only available to the current CEO.
132     /// @param _newAnimator The address of the new Animator
133     function setAnimator(address _newAnimator) external onlyCEO {
134         require(_newAnimator != address(0));
135 
136         animatorAddress = _newAnimator;
137     }
138 
139     /*** Pausable functionality adapted from OpenZeppelin ***/
140 
141     /// @dev Modifier to allow actions only when the contract IS NOT paused
142     modifier whenNotPaused() {
143         require(!paused);
144         _;
145     }
146 
147     /// @dev Modifier to allow actions only when the contract IS paused
148     modifier whenPaused {
149         require(paused);
150         _;
151     }
152 
153     /// @dev Called by any "C-level" role to pause the contract. Used only when
154     ///  a bug or exploit is detected and we need to limit damage.
155     function pause() external onlyCLevel whenNotPaused {
156         paused = true;
157     }
158 
159     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
160     ///  one reason we may pause the contract is when CFO or COO accounts are
161     ///  compromised.
162     /// @notice This is public rather than external so it can be called by
163     ///  derived contracts.
164     function unpause() public onlyCEO whenPaused {
165         // can't unpause if contract was upgraded
166         paused = false;
167     }
168 
169     /*** Destructible functionality adapted from OpenZeppelin ***/
170     /**
171      * @dev Transfers the current balance to the owner and terminates the contract.
172      */
173     function destroy() onlyCEO public {
174         selfdestruct(ceoAddress);
175     }
176 
177     function destroyAndSend(address _recipient) onlyCEO public {
178         selfdestruct(_recipient);
179     }
180 }
181 
182 contract AnimecardBase is AnimecardAccessControl {
183     using SafeMath
184     for uint256;
185 
186     /*** DATA TYPES ***/
187 
188     /// The main anime card struct
189     struct Animecard {
190         /// Name of the character
191         string characterName;
192         /// Name of designer & studio that created the character
193         string studioName;
194 
195         /// AWS S3-CDN URL for character image
196         string characterImageUrl;
197         /// IPFS hash of character details
198         string characterImageHash;
199         /// The timestamp from the block when this anime card was created
200         uint64 creationTime;
201     }
202 
203 
204     /*** EVENTS ***/
205     /// The Birth event is fired whenever a new anime card comes into existence.
206     event Birth(address owner, uint256 tokenId, string cardName, string studio);
207     /// Transfer event as defined in current draft of ERC721. Fired every time animecard
208     /// ownership is assigned, including births.
209     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
210     /// The TokenSold event is fired whenever a token is sold.
211     event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 price, address prevOwner, address owner, string cardName);
212 
213     /*** STORAGE ***/
214     /// An array containing all AnimeCards in existence. The id of each animecard
215     /// is an index in this array.
216     Animecard[] animecards;
217 
218     /// @dev A mapping from anime card ids to the address that owns them.
219     mapping(uint256 => address) public animecardToOwner;
220 
221     /// @dev A mapping from owner address to count of anime cards that address owns.
222     /// Used internally inside balanceOf() to resolve ownership count.
223     mapping(address => uint256) public ownerAnimecardCount;
224 
225     /// @dev A mapping from anime card ids to an address that has been approved to call
226     ///  transferFrom(). Each anime card can only have 1 approved address for transfer
227     ///  at any time. A 0 value means no approval is outstanding.
228     mapping(uint256 => address) public animecardToApproved;
229 
230     // @dev A mapping from anime card ids to their price.
231     mapping(uint256 => uint256) public animecardToPrice;
232 
233     // @dev Previous sale price of anime card
234     mapping(uint256 => uint256) public animecardPrevPrice;
235 
236     /// @dev Assigns ownership of a specific anime card to an address.
237     function _transfer(address _from, address _to, uint256 _tokenId) internal {
238         // Transfer ownership and update owner anime card counts.
239         // ownerAnimecardCount[_to] = ownerAnimecardCount[_to].add(1);
240         ownerAnimecardCount[_to]++;
241         animecardToOwner[_tokenId] = _to;
242         // When creating new tokens _from is 0x0, but we can't account that address.
243         if (_from != address(0)) {
244             // ownerAnimecardCount[_from] = ownerAnimecardCount[_from].sub(1);
245             ownerAnimecardCount[_from]--;
246             // clear any previously approved ownership exchange
247             delete animecardToApproved[_tokenId];
248         }
249         // Fire the transfer event.
250         Transfer(_from, _to, _tokenId);
251     }
252 
253     /// @dev An internal method that creates a new anime card and stores it.
254     /// @param _characterName The name of the character
255     /// @param _studioName The studio that created this character
256     /// @param _characterImageUrl AWS S3-CDN URL for character image
257     /// @param _characterImageHash IPFS hash for character image
258     /// @param _price of animecard character
259     /// @param _owner The initial owner of this anime card
260     function _createAnimecard(
261         string _characterName,
262         string _studioName,
263         string _characterImageUrl,
264         string _characterImageHash,
265         uint256 _price,
266         address _owner
267     )
268     internal
269     returns(uint) {
270 
271         Animecard memory _animecard = Animecard({
272             characterName: _characterName,
273             studioName: _studioName,
274             characterImageUrl: _characterImageUrl,
275             characterImageHash: _characterImageHash,
276             creationTime: uint64(now)
277         });
278         uint256 newAnimecardId = animecards.push(_animecard);
279         newAnimecardId = newAnimecardId.sub(1);
280 
281         // Fire the birth event.
282         Birth(
283             _owner,
284             newAnimecardId,
285             _animecard.characterName,
286             _animecard.studioName
287         );
288 
289         // Set the price for the animecard.
290         animecardToPrice[newAnimecardId] = _price;
291 
292         // This will assign ownership, and also fire the Transfer event as per ERC-721 draft.
293         _transfer(0, _owner, newAnimecardId);
294 
295         return newAnimecardId;
296 
297     }
298 }
299 
300 contract AnimecardPricing is AnimecardBase {
301 
302     /*** CONSTANTS ***/
303     // Pricing steps.
304     uint256 private constant first_step_limit = 0.05 ether;
305     uint256 private constant second_step_limit = 0.5 ether;
306     uint256 private constant third_step_limit = 2.0 ether;
307     uint256 private constant fourth_step_limit = 5.0 ether;
308 
309 
310     // Cut for studio & platform for each sale transaction
311     uint256 public platformFee = 50; // 50%
312 
313     /// @dev Set Studio Fee. Can only be called by the Animator address. 
314     function setPlatformFee(uint256 _val) external onlyAnimator {
315         platformFee = _val;
316     }
317 
318     /// @dev Computes next price of token given the current sale price.
319     function computeNextPrice(uint256 _salePrice)
320     internal
321     pure
322     returns(uint256) {
323         if (_salePrice < first_step_limit) {
324             return SafeMath.div(SafeMath.mul(_salePrice, 200), 100);
325         } else if (_salePrice < second_step_limit) {
326             return SafeMath.div(SafeMath.mul(_salePrice, 135), 100);
327         } else if (_salePrice < third_step_limit) {
328             return SafeMath.div(SafeMath.mul(_salePrice, 125), 100);
329         } else if (_salePrice < fourth_step_limit) {
330             return SafeMath.div(SafeMath.mul(_salePrice, 120), 100);
331         } else {
332             return SafeMath.div(SafeMath.mul(_salePrice, 115), 100);
333         }
334     }
335 
336     /// @dev Computes the payment for the token, which is the sale price of the token
337     /// minus the house's cut.
338     function computePayment(
339         uint256 _tokenId,
340         uint256 _salePrice)
341     internal
342     view
343     returns(uint256) {
344         uint256 prevSalePrice = animecardPrevPrice[_tokenId];
345 
346         uint256 profit = _salePrice - prevSalePrice;
347 
348         uint256 ownerCut = SafeMath.sub(100, platformFee);
349         uint256 ownerProfitShare = SafeMath.div(SafeMath.mul(profit, ownerCut), 100);
350 
351         return prevSalePrice + ownerProfitShare;
352     }
353 }
354 
355 contract AnimecardOwnership is AnimecardPricing, ERC721 {
356     /// Name of the collection of NFTs managed by this contract, as defined in ERC721.
357     string public constant NAME = "CryptoAnime";
358     /// Symbol referencing the entire collection of NFTs managed in this contract, as
359     /// defined in ERC721.
360     string public constant SYMBOL = "ANM";
361 
362     bytes4 public constant INTERFACE_SIGNATURE_ERC165 =
363         bytes4(keccak256("supportsInterface(bytes4)"));
364 
365     bytes4 public constant INTERFACE_SIGNATURE_ERC721 =
366         bytes4(keccak256("name()")) ^
367         bytes4(keccak256("symbol()")) ^
368         bytes4(keccak256("totalSupply()")) ^
369         bytes4(keccak256("balanceOf(address)")) ^
370         bytes4(keccak256("ownerOf(uint256)")) ^
371         bytes4(keccak256("approve(address,uint256)")) ^
372         bytes4(keccak256("transfer(address,uint256)")) ^
373         bytes4(keccak256("transferFrom(address,address,uint256)")) ^
374         bytes4(keccak256("tokensOfOwner(address)")) ^
375         bytes4(keccak256("tokenMetadata(uint256,string)"));
376 
377     /*** EVENTS ***/
378     /// Approval event as defined in the current draft of ERC721. Fired every time
379     /// animecard approved owners is updated. When Transfer event is emitted, this 
380     /// also indicates that approved address is reset to none.
381     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
382 
383     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
384     ///  Returns true for any standardized interfaces implemented by this contract. We implement
385     ///  ERC-165 (obviously!) and ERC-721.
386     function supportsInterface(bytes4 _interfaceID)
387     external
388     view
389     returns(bool) {
390         return ((_interfaceID == INTERFACE_SIGNATURE_ERC165) || (_interfaceID == INTERFACE_SIGNATURE_ERC721));
391     }
392 
393     // @notice Optional for ERC-20 compliance.
394     function name() external pure returns(string) {
395         return NAME;
396     }
397 
398     // @notice Optional for ERC-20 compliance.
399     function symbol() external pure returns(string) {
400         return SYMBOL;
401     }
402 
403     /// @dev Returns the total number of Animecards currently in existence.
404     /// @notice Required for ERC-20 and ERC-721 compliance.
405     function totalSupply() public view returns(uint) {
406         return animecards.length;
407     }
408 
409     /// @dev Returns the number of Animecards owned by a specific address.
410     /// @param _owner The owner address to check.
411     /// @notice Required for ERC-20 and ERC-721 compliance.
412     function balanceOf(address _owner)
413     public
414     view
415     returns(uint256 count) {
416         return ownerAnimecardCount[_owner];
417     }
418 
419     /// @dev Returns the address currently assigned ownership of a given Animecard.
420     /// @notice Required for ERC-721 compliance.
421     function ownerOf(uint256 _tokenId)
422     external
423     view
424     returns(address _owner) {
425         _owner = animecardToOwner[_tokenId];
426         require(_owner != address(0));
427     }
428 
429     /// @dev Grant another address the right to transfer a specific Anime card via
430     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
431     /// @param _to The address to be granted transfer approval. Pass address(0) to
432     ///  clear all approvals.
433     /// @param _tokenId The ID of the Animecard that can be transferred if this call succeeds.
434     /// @notice Required for ERC-20 and ERC-721 compliance.
435     function approve(address _to, uint256 _tokenId)
436     external
437     whenNotPaused {
438         // Only an owner can grant transfer approval.
439         require(_owns(msg.sender, _tokenId));
440 
441         // Register the approval (replacing any previous approval).
442         _approve(_tokenId, _to);
443 
444         // Fire approval event upon successful approval.
445         Approval(msg.sender, _to, _tokenId);
446     }
447 
448     /// @dev Transfers a Animecard to another address. If transferring to a smart
449     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 or else your
450     /// Animecard may be lost forever.
451     /// @param _to The address of the recipient, can be a user or contract.
452     /// @param _tokenId The ID of the Animecard to transfer.
453     /// @notice Required for ERC-20 and ERC-721 compliance.
454     function transfer(address _to, uint256 _tokenId)
455     external
456     whenNotPaused {
457         // Safety check to prevent against an unexpected 0x0 default.
458         require(_to != address(0));
459         // Disallow transfers to this contract to prevent accidental misuse.
460         // The contract should never own any animecard (except very briefly
461         // after a Anime card is created).
462         require(_to != address(this));
463 
464         // You can only transfer your own Animecard.
465         require(_owns(msg.sender, _tokenId));
466         // TODO - Disallow transfer to self
467 
468         // Reassign ownership, clear pending approvals, fire Transfer event.
469         _transfer(msg.sender, _to, _tokenId);
470     }
471 
472     /// @dev Transfer a Animecard owned by another address, for which the calling address
473     ///  has previously been granted transfer approval by the owner.
474     /// @param _from The address that owns the Animecard to be transfered.
475     /// @param _to The address that should take ownership of the Animecard. Can be any
476     /// address, including the caller.
477     /// @param _tokenId The ID of the Animecard to be transferred.
478     /// @notice Required for ERC-20 and ERC-721 compliance.
479     function transferFrom(address _from, address _to, uint256 _tokenId)
480     external
481     whenNotPaused {
482         // Safety check to prevent against an unexpected 0x0 default.
483         require(_to != address(0));
484         // Disallow transfers to this contract to prevent accidental misuse.
485         // The contract should never own any animecard (except very briefly
486         // after an animecard is created).
487         require(_to != address(this));
488 
489         // Check for approval and valid ownership
490         require(_approvedFor(msg.sender, _tokenId));
491         require(_owns(_from, _tokenId));
492 
493         // Reassign ownership (also clears pending approvals and fires Transfer event).
494         _transfer(_from, _to, _tokenId);
495     }
496 
497     /// @dev Returns a list of all Animecard IDs assigned to an address.
498     /// @param _owner The owner whose Animecards we are interested in.
499     ///  This method MUST NEVER be called by smart contract code. First, it is fairly
500     ///  expensive (it walks the entire Animecard array looking for Animecard belonging
501     /// to owner), but it also returns a dynamic array, which is only supported for web3
502     /// calls, and not contract-to-contract calls. Thus, this method is external rather
503     /// than public.
504     function tokensOfOwner(address _owner)
505     external
506     view
507     returns(uint256[] ownerTokens) {
508         uint256 tokenCount = balanceOf(_owner);
509 
510         if (tokenCount == 0) {
511             // Returns an empty array
512             return new uint256[](0);
513         } else {
514             uint256[] memory result = new uint256[](tokenCount);
515             uint256 totalAnimecards = totalSupply();
516             uint256 resultIndex = 0;
517 
518             uint256 animecardId;
519             for (animecardId = 0; animecardId <= totalAnimecards; animecardId++) {
520                 if (animecardToOwner[animecardId] == _owner) {
521                     result[resultIndex] = animecardId;
522                     resultIndex++;
523                 }
524             }
525 
526             return result;
527         }
528     }
529 
530     /// @dev Checks if a given address is the current owner of a particular Animecard.
531     /// @param _claimant the address we are validating against.
532     /// @param _tokenId Animecard id, only valid when > 0
533     function _owns(address _claimant, uint256 _tokenId)
534     internal
535     view
536     returns(bool) {
537         return animecardToOwner[_tokenId] == _claimant;
538     }
539 
540     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
541     /// approval. Setting _approved to address(0) clears all transfer approval.
542     /// NOTE: _approve() does NOT send the Approval event. This is intentional because
543     /// _approve() and transferFrom() are used together for putting Animecards on sale and,
544     /// there is no value in spamming the log with Approval events in that case.
545     function _approve(uint256 _tokenId, address _approved) internal {
546         animecardToApproved[_tokenId] = _approved;
547     }
548 
549     /// @dev Checks if a given address currently has transferApproval for a particular 
550     /// Animecard.
551     /// @param _claimant the address we are confirming Animecard is approved for.
552     /// @param _tokenId Animecard id, only valid when > 0
553     function _approvedFor(address _claimant, uint256 _tokenId)
554     internal
555     view
556     returns(bool) {
557         return animecardToApproved[_tokenId] == _claimant;
558     }
559 
560     /// Safety check on _to address to prevent against an unexpected 0x0 default.
561     function _addressNotNull(address _to) internal pure returns(bool) {
562         return _to != address(0);
563     }
564 
565 }
566 
567 contract AnimecardSale is AnimecardOwnership {
568 
569     // Allows someone to send ether and obtain the token
570     function purchase(uint256 _tokenId)
571     public
572     payable
573     whenNotPaused {
574         address newOwner = msg.sender;
575         address oldOwner = animecardToOwner[_tokenId];
576         uint256 salePrice = animecardToPrice[_tokenId];
577 
578         // Require that the owner of the token is not sending to self.
579         require(oldOwner != newOwner);
580 
581         // Safety check to prevent against an unexpected 0x0 default.
582         require(_addressNotNull(newOwner));
583 
584         // Check that sent amount is greater than or equal to the sale price
585         require(msg.value >= salePrice);
586 
587         uint256 payment = uint256(computePayment(_tokenId, salePrice));
588         uint256 purchaseExcess = SafeMath.sub(msg.value, salePrice);
589 
590         // Set next listing price.
591         animecardPrevPrice[_tokenId] = animecardToPrice[_tokenId];
592         animecardToPrice[_tokenId] = computeNextPrice(salePrice);
593 
594         // Transfer the Animecard to the buyer.
595         _transfer(oldOwner, newOwner, _tokenId);
596 
597         // Pay seller of the Animecard if they are not this contract.
598         if (oldOwner != address(this)) {
599             oldOwner.transfer(payment);
600         }
601 
602         TokenSold(_tokenId, salePrice, animecardToPrice[_tokenId], oldOwner, newOwner, animecards[_tokenId].characterName);
603 
604         // Reimburse the buyer of any excess paid.
605         msg.sender.transfer(purchaseExcess);
606     }
607 
608     function priceOf(uint256 _tokenId)
609     public
610     view
611     returns(uint256 price) {
612         return animecardToPrice[_tokenId];
613     }
614 
615 
616 }
617 
618 contract AnimecardMinting is AnimecardSale {
619     /*** CONSTANTS ***/
620     /// @dev Starting price of a regular Animecard.
621     // uint128 private constant STARTING_PRICE = 0.01 ether;
622 
623     /// @dev Creates a new Animecard
624     function createAnimecard(
625         string _characterName,
626         string _studioName,
627         string _characterImageUrl,
628         string _characterImageHash,
629         uint256 _price
630     )
631     public
632     onlyAnimator
633     returns(uint) {
634         uint256 animecardId = _createAnimecard(
635             _characterName, _studioName,
636             _characterImageUrl, _characterImageHash,
637             _price, address(this)
638         );
639 
640         return animecardId;
641     }
642 }
643 
644 // Cryptoanime: Anime collectibles on blockchain
645 contract AnimecardCore is AnimecardMinting {
646     // contract AnimecardCore is AnimecardMinting {
647     // Set in case the core contract is broken and a fork is required
648     address public newContractAddress;
649 
650     function AnimecardCore() public {
651         // Starts paused.
652         paused = true;
653 
654         // The creator of the contract is the initial CEO
655         ceoAddress = msg.sender;
656 
657         // The creator of the contract is also the initial Animator
658         animatorAddress = msg.sender;
659     }
660 
661     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
662     ///  breaking bug. This method does nothing but keep track of the new contract and
663     ///  emit a message indicating that the new address is set. It's up to clients of this
664     ///  contract to update to the new contract address in that case. (This contract will
665     ///  be paused indefinitely if such an upgrade takes place.)
666     /// @param _v2Address new address
667     function setNewAddress(address _v2Address)
668     external
669     onlyCEO
670     whenPaused {
671         newContractAddress = _v2Address;
672         ContractFork(_v2Address);
673     }
674 
675     /// @dev Withdraw all Ether from the contract. This includes both the studio fee
676     /// and blockpunk fee on every animecard sold and any Ether sent directly to
677     /// contract address.
678     /// Only the CFO can withdraw the balance or specify the address to send
679     /// the balance to.
680     function withdrawBalance(address _to) external onlyCFO {
681         // We are using this boolean method to make sure that even if one fails it will still work
682         if (_to == address(0)) {
683             cfoAddress.transfer(this.balance);
684         } else {
685             _to.transfer(this.balance);
686         }
687     }
688 
689     /// @notice Returns all the relevant information about a specific animecard.
690     /// @param _tokenId The tokenId of the animecard of interest.
691     function getAnimecard(uint256 _tokenId)
692     external
693     view
694     returns(
695         string characterName,
696         string studioName,
697         string characterImageUrl,
698         string characterImageHash,
699         uint256 sellingPrice,
700         address owner) {
701         Animecard storage animecard = animecards[_tokenId];
702         characterName = animecard.characterName;
703         studioName = animecard.studioName;
704         characterImageUrl = animecard.characterImageUrl;
705         characterImageHash = animecard.characterImageHash;
706         sellingPrice = animecardToPrice[_tokenId];
707         owner = animecardToOwner[_tokenId];
708     }
709 
710 
711     /// @dev Override unpause so it requires all external contract addresses
712     ///  to be set before contract can be unpaused. Also, we can't have
713     ///  newContractAddress set either, because then the contract was upgraded.
714     /// @notice This is public rather than external so we can call super.unpause
715     ///  without using an expensive call.
716     function unpause()
717     public
718     onlyCEO
719     whenPaused {
720         require(newContractAddress == address(0));
721 
722         // Actually unpause the contract.
723         super.unpause();
724     }
725 
726     /// @notice Direct donations
727     function () external payable {}
728 }