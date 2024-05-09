1 // CryptoRabbit Source code
2 
3 pragma solidity ^0.4.20;
4 
5 
6 /**
7  * 
8  * @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
9  * @author cuilichen
10  */
11 contract ERC721 {
12     // Required methods
13     function totalSupply() public view returns (uint total);
14     function balanceOf(address _owner) public view returns (uint balance);
15     function ownerOf(uint _tokenId) external view returns (address owner);
16     function approve(address _to, uint _tokenId) external;
17     function transfer(address _to, uint _tokenId) external;
18     function transferFrom(address _from, address _to, uint _tokenId) external;
19 
20     // Events
21     event Transfer(address indexed from, address indexed to, uint tokenId);
22     event Approval(address indexed owner, address indexed approved, uint tokenId);
23     
24 }
25 
26 
27 
28 /// @title A base contract to control ownership
29 /// @author cuilichen
30 contract OwnerBase {
31 
32     // The addresses of the accounts that can execute actions within each roles.
33     address public ceoAddress;
34     address public cfoAddress;
35     address public cooAddress;
36 
37     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
38     bool public paused = false;
39     
40     /// constructor
41     function OwnerBase() public {
42        ceoAddress = msg.sender;
43        cfoAddress = msg.sender;
44        cooAddress = msg.sender;
45     }
46 
47     /// @dev Access modifier for CEO-only functionality
48     modifier onlyCEO() {
49         require(msg.sender == ceoAddress);
50         _;
51     }
52 
53     /// @dev Access modifier for CFO-only functionality
54     modifier onlyCFO() {
55         require(msg.sender == cfoAddress);
56         _;
57     }
58     
59     /// @dev Access modifier for COO-only functionality
60     modifier onlyCOO() {
61         require(msg.sender == cooAddress);
62         _;
63     }
64 
65     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
66     /// @param _newCEO The address of the new CEO
67     function setCEO(address _newCEO) external onlyCEO {
68         require(_newCEO != address(0));
69 
70         ceoAddress = _newCEO;
71     }
72 
73 
74     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
75     /// @param _newCFO The address of the new COO
76     function setCFO(address _newCFO) external onlyCEO {
77         require(_newCFO != address(0));
78 
79         cfoAddress = _newCFO;
80     }
81     
82     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
83     /// @param _newCOO The address of the new COO
84     function setCOO(address _newCOO) external onlyCEO {
85         require(_newCOO != address(0));
86 
87         cooAddress = _newCOO;
88     }
89 
90     /// @dev Modifier to allow actions only when the contract IS NOT paused
91     modifier whenNotPaused() {
92         require(!paused);
93         _;
94     }
95 
96     /// @dev Modifier to allow actions only when the contract IS paused
97     modifier whenPaused {
98         require(paused);
99         _;
100     }
101 
102     /// @dev Called by any "C-level" role to pause the contract. Used only when
103     ///  a bug or exploit is detected and we need to limit damage.
104     function pause() external onlyCOO whenNotPaused {
105         paused = true;
106     }
107 
108     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
109     ///  one reason we may pause the contract is when CFO or COO accounts are
110     ///  compromised.
111     /// @notice This is public rather than external so it can be called by
112     ///  derived contracts.
113     function unpause() public onlyCOO whenPaused {
114         // can't unpause if contract was upgraded
115         paused = false;
116     }
117 	
118 	
119 	/// @dev check wether target address is a contract or not
120     function isNotContract(address addr) internal view returns (bool) {
121         uint size = 0;
122         assembly { 
123 		    size := extcodesize(addr) 
124 		} 
125         return size == 0;
126     }
127 }
128 
129 
130 
131 
132 /**
133  * 
134  * @title Interface for contracts conforming to fighters camp
135  * @author cuilichen
136  */
137 contract FighterCamp {
138     
139     //
140     function isCamp() public pure returns (bool);
141     
142     // Required methods
143     function getFighter(uint _tokenId) external view returns (uint32);
144     
145 }
146 
147 /// @title Base contract for CryptoRabbit. Holds all common structs, events and base variables.
148 /// @author cuilichen
149 /// @dev See the RabbitCore contract documentation to understand how the various contract facets are arranged.
150 contract RabbitBase is ERC721, OwnerBase, FighterCamp {
151 
152     /*** EVENTS ***/
153     /// @dev The Birth event is fired whenever a new rabbit comes into existence. 
154     event Birth(address owner, uint rabbitId, uint32 star, uint32 explosive, uint32 endurance, uint32 nimble, uint64 genes, uint8 isBox);
155 
156     /*** DATA TYPES ***/
157     struct RabbitData {
158         //genes for rabbit
159         uint64 genes;
160         //
161         uint32 star;
162         //
163         uint32 explosive;
164         //
165         uint32 endurance;
166         //
167         uint32 nimble;
168         //birth time 
169         uint64 birthTime;
170     }
171 
172     /// @dev An array containing the Rabbit struct for all rabbits in existence. The ID
173     ///  of each rabbit is actually an index into this array. 
174     RabbitData[] rabbits;
175 
176     /// @dev A mapping from rabbit IDs to the address that owns them. 
177     mapping (uint => address) rabbitToOwner;
178 
179     // @dev A mapping from owner address to count of tokens that address owns.
180     //  Used internally inside balanceOf() to resolve ownership count.
181     mapping (address => uint) howManyDoYouHave;
182 
183     /// @dev A mapping from RabbitIDs to an address that has been approved to call
184     ///  transfeFrom(). Each Rabbit can only have one approved address for transfer
185     ///  at any time. A zero value means no approval is outstanding.
186     mapping (uint => address) public rabbitToApproved;
187 
188 	
189 	
190     /// @dev Assigns ownership of a specific Rabbit to an address.
191     function _transItem(address _from, address _to, uint _tokenId) internal {
192         // Since the number of rabbits is capped to 2^32 we can't overflow this
193         howManyDoYouHave[_to]++;
194         // transfer ownership
195         rabbitToOwner[_tokenId] = _to;
196         // When creating new rabbits _from is 0x0, but we can't account that address.
197         if (_from != address(0)) {
198             howManyDoYouHave[_from]--;
199         }
200         // clear any previously approved ownership exchange
201         delete rabbitToApproved[_tokenId];
202         
203         // Emit the transfer event.
204 		if (_tokenId > 0) {
205 			emit Transfer(_from, _to, _tokenId);
206 		}
207     }
208 
209     /// @dev An internal method that creates a new rabbit and stores it. This
210     ///  method doesn't do any checking and should only be called when the
211     ///  input data is known to be valid. Will generate both a Birth event
212     ///  and a Transfer event.
213     function _createRabbit(
214         uint _star,
215         uint _explosive,
216         uint _endurance,
217         uint _nimble,
218         uint _genes,
219         address _owner,
220 		uint8 isBox
221     )
222         internal
223         returns (uint)
224     {
225         require(_star >= 1 && _star <= 5);
226 		
227 		RabbitData memory _tmpRbt = RabbitData({
228             genes: uint64(_genes),
229             star: uint32(_star),
230             explosive: uint32(_explosive),
231             endurance: uint32(_endurance),
232             nimble: uint32(_nimble),
233             birthTime: uint64(now)
234         });
235         uint newRabbitID = rabbits.push(_tmpRbt) - 1;
236         
237         
238         /* */
239 
240         // emit the birth event
241         emit Birth(
242             _owner,
243             newRabbitID,
244             _tmpRbt.star,
245             _tmpRbt.explosive,
246             _tmpRbt.endurance,
247             _tmpRbt.nimble,
248             _tmpRbt.genes,
249 			isBox
250         );
251 
252         // This will assign ownership, and also emit the Transfer event as
253         // per ERC721 draft
254         if (_owner != address(0)){
255             _transItem(0, _owner, newRabbitID);
256         } else {
257             _transItem(0, ceoAddress, newRabbitID);
258         }
259         
260         
261         return newRabbitID;
262     }
263     
264     /// @notice Returns all the relevant information about a specific rabbit.
265     /// @param _tokenId The ID of the rabbit of interest.
266     function getRabbit(uint _tokenId) external view returns (
267         uint32 outStar,
268         uint32 outExplosive,
269         uint32 outEndurance,
270         uint32 outNimble,
271         uint64 outGenes,
272         uint64 outBirthTime
273     ) {
274         RabbitData storage rbt = rabbits[_tokenId];
275         outStar = rbt.star;
276         outExplosive = rbt.explosive;
277         outEndurance = rbt.endurance;
278         outNimble = rbt.nimble;
279         outGenes = rbt.genes;
280         outBirthTime = rbt.birthTime;
281     }
282 	
283 	
284     function isCamp() public pure returns (bool){
285         return true;
286     }
287     
288     
289     /// @dev An external method that get infomation of the fighter
290     /// @param _tokenId The ID of the fighter.
291     function getFighter(uint _tokenId) external view returns (uint32) {
292         RabbitData storage rbt = rabbits[_tokenId];
293         uint32 strength = uint32(rbt.explosive + rbt.endurance + rbt.nimble); 
294 		return strength;
295     }
296 
297 }
298 
299 
300 
301 /// @title The facet of the CryptoRabbit core contract that manages ownership, ERC-721 (draft) compliant.
302 /// @author cuilichen
303 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
304 ///  See the RabbitCore contract documentation to understand how the various contract facets are arranged.
305 contract RabbitOwnership is RabbitBase {
306 
307     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
308     string public name;
309     string public symbol;
310     
311     //identify this is ERC721
312     function isERC721() public pure returns (bool) {
313         return true;
314     }
315 
316     // Internal utility functions: These functions all assume that their input arguments
317     // are valid. We leave it to public methods to sanitize their inputs and follow
318     // the required logic.
319 
320     /// @dev Checks if a given address is the current owner of a particular Rabbit.
321     /// @param _owner the address we are validating against.
322     /// @param _tokenId rabbit id, only valid when > 0
323     function _owns(address _owner, uint _tokenId) internal view returns (bool) {
324         return rabbitToOwner[_tokenId] == _owner;
325     }
326 
327     /// @dev Checks if a given address currently has transferApproval for a particular Rabbit.
328     /// @param _claimant the address we are confirming rabbit is approved for.
329     /// @param _tokenId rabbit id, only valid when > 0
330     function _approvedFor(address _claimant, uint _tokenId) internal view returns (bool) {
331         return rabbitToApproved[_tokenId] == _claimant;
332     }
333 
334     /// @dev Marks an address as being approved for transfeFrom(), overwriting any previous
335     ///  approval. Setting _approved to address(0) clears all transfer approval.
336     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
337     ///  _approve() and transfeFrom() are used together for putting rabbits on auction, and
338     ///  there is no value in spamming the log with Approval events in that case.
339     function _approve(uint _tokenId, address _to) internal {
340         rabbitToApproved[_tokenId] = _to;
341     }
342 
343     /// @notice Returns the number of rabbits owned by a specific address.
344     /// @param _owner The owner address to check.
345     /// @dev Required for ERC-721 compliance
346     function balanceOf(address _owner) public view returns (uint count) {
347         return howManyDoYouHave[_owner];
348     }
349 
350     /// @notice Transfers a Rabbit to another address. If transferring to a smart
351     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
352     ///  CryptoRabbit specifically) or your Rabbit may be lost forever. Seriously.
353     /// @param _to The address of the recipient, can be a user or contract.
354     /// @param _tokenId The ID of the Rabbit to transfer.
355     /// @dev Required for ERC-721 compliance.
356     function transfer(
357         address _to,
358         uint _tokenId
359     )
360         external
361         whenNotPaused
362     {
363         // Safety check to prevent against an unexpected 0x0 default.
364         require(_to != address(0));
365 		
366 		// Disallow transfers to this contract to prevent accidental misuse.
367 		require(_to != address(this));
368         
369         // You can only send your own rabbit.
370         require(_owns(msg.sender, _tokenId));
371         
372         // Reassign ownership, clear pending approvals, emit Transfer event.
373         _transItem(msg.sender, _to, _tokenId);
374     }
375 
376     /// @notice Grant another address the right to transfer a specific Rabbit via
377     ///  transfeFrom(). This is the preferred flow for transfering NFTs to contracts.
378     /// @param _to The address to be granted transfer approval. Pass address(0) to
379     ///  clear all approvals.
380     /// @param _tokenId The ID of the Rabbit that can be transferred if this call succeeds.
381     /// @dev Required for ERC-721 compliance.
382     function approve(
383         address _to,
384         uint _tokenId
385     )
386         external
387         whenNotPaused
388     {   
389         require(_owns(msg.sender, _tokenId));    // Only an owner can grant transfer approval.
390         require(msg.sender != _to);     // can not approve to itself;
391 
392         // Register the approval (replacing any previous approval).
393         _approve(_tokenId, _to);
394 
395         // Emit approval event.
396         emit Approval(msg.sender, _to, _tokenId);
397     }
398 
399     /// @notice Transfer a Rabbit owned by another address, for which the calling address
400     ///  has previously been granted transfer approval by the owner.
401     /// @param _from The address that owns the Rabbit to be transfered.
402     /// @param _to The address that should take ownership of the Rabbit. Can be any address,
403     ///  including the caller.
404     /// @param _tokenId The ID of the Rabbit to be transferred.
405     /// @dev Required for ERC-721 compliance.
406     function transferFrom(
407         address _from,
408         address _to,
409         uint _tokenId
410     )
411         external
412         whenNotPaused
413     {
414         // Safety check to prevent against an unexpected 0x0 default.
415         require(_to != address(0));
416         
417         //
418         require(_owns(_from, _tokenId));
419         
420         // Check for approval and valid ownership
421         require(_approvedFor(msg.sender, _tokenId));
422         
423         // Reassign ownership (also clears pending approvals and emits Transfer event).
424         _transItem(_from, _to, _tokenId);
425     }
426 
427     /// @notice Returns the total number of rabbits currently in existence.
428     /// @dev Required for ERC-721 compliance.
429     function totalSupply() public view returns (uint) {
430         return rabbits.length - 1;
431     }
432 
433     /// @notice Returns the address currently assigned ownership of a given Rabbit.
434     /// @dev Required for ERC-721 compliance.
435     function ownerOf(uint _tokenId)
436         external
437         view
438         returns (address owner)
439     {
440         owner = rabbitToOwner[_tokenId];
441 
442         require(owner != address(0));
443     }
444 
445     /// @notice Returns a list of all Rabbit IDs assigned to an address.
446     /// @param _owner The owner whose rabbits we are interested in.
447     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
448     ///  expensive (it walks the entire Rabbit array looking for rabbits belonging to owner),
449     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
450     ///  not contract-to-contract calls.
451     function tokensOfOwner(address _owner) external view returns(uint[] ownerTokens) {
452         uint tokenCount = balanceOf(_owner);
453 
454         if (tokenCount == 0) {
455             // Return an empty array
456             return new uint[](0);
457         } else {
458             uint[] memory result = new uint[](tokenCount);
459             uint totalCats = totalSupply();
460             uint resultIndex = 0;
461 
462             // We count on the fact that all rabbits have IDs starting at 1 and increasing
463             // sequentially up to the totalCat count.
464             uint rabbitId;
465 
466             for (rabbitId = 1; rabbitId <= totalCats; rabbitId++) {
467                 if (rabbitToOwner[rabbitId] == _owner) {
468                     result[resultIndex] = rabbitId;
469                     resultIndex++;
470                 }
471             }
472 
473             return result;
474         }
475     }
476 
477 }
478 
479 /// @title all functions related to creating rabbits and sell rabbits
480 contract RabbitMinting is RabbitOwnership {
481     
482     // Price (in wei) for star5 rabbit 
483     uint public priceStar5Now = 1 ether;
484     
485     // Price (in wei) for star4 rabbit 
486     uint public priceStar4 = 100 finney;
487     
488     // Price (in wei) for star3 rabbit 
489     uint public priceStar3 = 5 finney;    
490     
491     
492     uint private priceStar5Min = 1 ether;
493     uint private priceStar5Add = 2 finney;
494     
495     //rabbit box1 
496     uint public priceBox1 = 10 finney;
497     uint public box1Star5 = 50;
498     uint public box1Star4 = 500;
499 	
500 	//rabbit box2
501 	uint public priceBox2 = 100 finney;
502     uint public box2Star5 = 500;
503 	
504     
505     
506     // Limits the number of star5 rabbits can ever create.
507     uint public constant LIMIT_STAR5 = 2000;
508 	
509 	// Limits the number of star4 rabbits can ever create.
510     uint public constant LIMIT_STAR4 = 20000;
511     
512     // Limits the number of rabbits the contract owner can ever create.
513     uint public constant LIMIT_PROMO = 5000;
514     
515     // Counts the number of rabbits of star 5
516     uint public CREATED_STAR5;
517 	
518 	// Counts the number of rabbits of star 4
519     uint public CREATED_STAR4;
520     
521     // Counts the number of rabbits the contract owner has created.
522     uint public CREATED_PROMO;
523     
524     //an secret key used for random
525     uint private secretKey = 392828872;
526     
527     //box is on sale
528     bool private box1OnSale = true;
529 	
530 	//box is on sale
531     bool private box2OnSale = true;
532 	
533 	//record any task id for updating datas;
534 	mapping(uint => uint8) usedSignId;
535    
536     
537     /// @dev set base infomation by coo
538     function setBaseInfo(uint val, bool _onSale1, bool _onSale2) external onlyCOO {
539         secretKey = val;
540 		box1OnSale = _onSale1;
541         box2OnSale = _onSale2;
542     }
543     
544     /// @dev we can create promo rabbits, up to a limit. Only callable by COO
545     function createPromoRabbit(uint _star, address _owner) whenNotPaused external onlyCOO {
546         require (_owner != address(0));
547         require(CREATED_PROMO < LIMIT_PROMO);
548        
549         if (_star == 5){
550             require(CREATED_STAR5 < LIMIT_STAR5);
551         } else if (_star == 4){
552             require(CREATED_STAR4 < LIMIT_STAR4);
553         }
554         CREATED_PROMO++;
555         
556         _createRabbitInGrade(_star, _owner, 0);
557     }
558     
559     
560     
561     /// @dev create a rabbit with grade, and set its owner.
562     function _createRabbitInGrade(uint _star, address _owner, uint8 isBox) internal {
563         uint _genes = uint(keccak256(uint(_owner) + secretKey + rabbits.length));
564         uint _explosive = 50;
565         uint _endurance = 50;
566         uint _nimble = 50;
567         
568         if (_star < 5) {
569             uint tmp = _genes; 
570             tmp = uint(keccak256(tmp));
571             _explosive =  1 + 10 * (_star - 1) + tmp % 10;
572             tmp = uint(keccak256(tmp));
573             _endurance = 1 + 10 * (_star - 1) + tmp % 10;
574             tmp = uint(keccak256(tmp));
575             _nimble = 1 + 10 * (_star - 1) + tmp % 10;
576         } 
577 		
578 		uint64 _geneShort = uint64(_genes);
579 		if (_star == 5){
580 			CREATED_STAR5++;
581 			priceStar5Now = priceStar5Min + priceStar5Add * CREATED_STAR5;
582 			_geneShort = uint64(_geneShort - _geneShort % 2000 + CREATED_STAR5);
583 		} else if (_star == 4){
584 			CREATED_STAR4++;
585 		} 
586 		
587         _createRabbit(
588             _star, 
589             _explosive, 
590             _endurance, 
591             _nimble, 
592             _geneShort, 
593             _owner,
594 			isBox);
595     }
596     
597     
598         
599     /// @notice customer buy a rabbit
600     /// @param _star the star of the rabbit to buy
601     function buyOneRabbit(uint _star) external payable whenNotPaused returns (bool) {
602 		require(isNotContract(msg.sender));
603 		
604         uint tmpPrice = 0;
605         if (_star == 5){
606             tmpPrice = priceStar5Now;
607 			require(CREATED_STAR5 < LIMIT_STAR5);
608         } else if (_star == 4){
609             tmpPrice = priceStar4;
610 			require(CREATED_STAR4 < LIMIT_STAR4);
611         } else if (_star == 3){
612             tmpPrice = priceStar3;
613         } else {
614 			revert();
615 		}
616         
617         require(msg.value >= tmpPrice);
618         _createRabbitInGrade(_star, msg.sender, 0);
619         
620         // Return the funds. 
621         uint fundsExcess = msg.value - tmpPrice;
622         if (fundsExcess > 1 finney) {
623             msg.sender.transfer(fundsExcess);
624         }
625         return true;
626     }
627     
628     
629         
630     /// @notice customer buy a box
631     function buyBox1() external payable whenNotPaused returns (bool) {
632 		require(isNotContract(msg.sender));
633         require(box1OnSale);
634         require(msg.value >= priceBox1);
635 		
636         uint tempVal = uint(keccak256(uint(msg.sender) + secretKey + rabbits.length));
637         tempVal = tempVal % 10000;
638         uint _star = 3; //default
639         if (tempVal <= box1Star5){
640             _star = 5;
641 			require(CREATED_STAR5 < LIMIT_STAR5);
642         } else if (tempVal <= box1Star5 + box1Star4){
643             _star = 4;
644 			require(CREATED_STAR4 < LIMIT_STAR4);
645         } 
646         
647         _createRabbitInGrade(_star, msg.sender, 2);
648         
649         // Return the funds. 
650         uint fundsExcess = msg.value - priceBox1;
651         if (fundsExcess > 1 finney) {
652             msg.sender.transfer(fundsExcess);
653         }
654         return true;
655     }
656 	
657 	    
658     /// @notice customer buy a box
659     function buyBox2() external payable whenNotPaused returns (bool) {
660 		require(isNotContract(msg.sender));
661         require(box2OnSale);
662         require(msg.value >= priceBox2);
663 		
664         uint tempVal = uint(keccak256(uint(msg.sender) + secretKey + rabbits.length));
665         tempVal = tempVal % 10000;
666         uint _star = 4; //default
667         if (tempVal <= box2Star5){
668             _star = 5;
669 			require(CREATED_STAR5 < LIMIT_STAR5);
670         } else {
671 			require(CREATED_STAR4 < LIMIT_STAR4);
672 		}
673         
674         _createRabbitInGrade(_star, msg.sender, 3);
675         
676         // Return the funds. 
677         uint fundsExcess = msg.value - priceBox2;
678         if (fundsExcess > 1 finney) {
679             msg.sender.transfer(fundsExcess);
680         }
681         return true;
682     }
683 	
684 }
685 
686 
687 
688 
689 
690 /// @title all functions related to creating rabbits and sell rabbits
691 contract RabbitAuction is RabbitMinting {
692     
693     //events about auctions
694     event AuctionCreated(uint tokenId, uint startingPrice, uint endingPrice, uint duration, uint startTime, uint32 explosive, uint32 endurance, uint32 nimble, uint32 star);
695     event AuctionSuccessful(uint tokenId, uint totalPrice, address winner);
696     event AuctionCancelled(uint tokenId);
697 	event UpdateComplete(address account, uint tokenId);
698     
699     // Represents an auction on an NFT
700     struct Auction {
701         // Current owner of NFT
702         address seller;
703         // Price (in wei) at beginning of auction
704         uint128 startingPrice;
705         // Price (in wei) at end of auction
706         uint128 endingPrice;
707         // Duration (in seconds) of auction
708         uint64 duration;
709         // Time when auction started
710         uint64 startedAt;
711     }
712 
713     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
714     // Values 0-10,000 map to 0%-100%
715     uint public masterCut = 200;
716 
717     // Map from token ID to their corresponding auction.
718     mapping (uint => Auction) tokenIdToAuction;
719     
720     
721     /// @dev Creates and begins a new auction.
722     /// @param _tokenId - ID of token to auction, sender must be owner.
723     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
724     /// @param _endingPrice - Price of item (in wei) at end of auction.
725     /// @param _duration - Length of time to move between starting
726     ///  price and ending price (in seconds).
727     function createAuction(
728         uint _tokenId,
729         uint _startingPrice,
730         uint _endingPrice,
731         uint _duration
732     )
733         external whenNotPaused
734     {
735 		require(isNotContract(msg.sender));
736         require(_endingPrice >= 1 finney);
737         require(_startingPrice >= _endingPrice);
738         require(_duration <= 100 days); 
739         require(_owns(msg.sender, _tokenId));
740         
741 		//assigning the ownship to this contract,
742         _transItem(msg.sender, this, _tokenId);
743         
744         Auction memory auction = Auction(
745             msg.sender,
746             uint128(_startingPrice),
747             uint128(_endingPrice),
748             uint64(_duration),
749             uint64(now)
750         );
751         _addAuction(_tokenId, auction);
752     }
753     
754     
755     /// @dev Returns auction info for an NFT on auction.
756     /// @param _tokenId - ID of NFT on auction.
757     function getAuctionData(uint _tokenId) external view returns (
758         address seller,
759         uint startingPrice,
760         uint endingPrice,
761         uint duration,
762         uint startedAt,
763         uint currentPrice
764     ) {
765         Auction storage auction = tokenIdToAuction[_tokenId];
766         require(auction.startedAt > 0);
767         seller = auction.seller;
768         startingPrice = auction.startingPrice;
769         endingPrice = auction.endingPrice;
770         duration = auction.duration;
771         startedAt = auction.startedAt;
772         currentPrice = _calcCurrentPrice(auction);
773     }
774 
775     /// @dev Bids on an open auction, completing the auction and transferring
776     ///  ownership of the NFT if enough Ether is supplied.
777     /// @param _tokenId - ID of token to bid on.
778     function bid(uint _tokenId) external payable whenNotPaused {
779 		require(isNotContract(msg.sender));
780 		
781         // Get a reference to the auction struct
782         Auction storage auction = tokenIdToAuction[_tokenId];
783         require(auction.startedAt > 0);
784 
785         // Check that the bid is greater than or equal to the current price
786         uint price = _calcCurrentPrice(auction);
787         require(msg.value >= price);
788 
789         // Grab a reference to the seller before the auction struct gets deleted.
790         address seller = auction.seller;
791 		
792 		//
793 		require(_owns(this, _tokenId));
794 
795         // The bid is good! Remove the auction before sending the fees
796         // to the sender so we can't have a reentrancy endurance.
797         delete tokenIdToAuction[_tokenId];
798 
799         if (price > 0) {
800             // Calculate the auctioneer's cut.
801             uint auctioneerCut = price * masterCut / 10000;
802             uint sellerProceeds = price - auctioneerCut;
803 			require(sellerProceeds <= price);
804 
805             // Doing a transfer() after removing the auction
806             seller.transfer(sellerProceeds);
807         }
808 
809         // Calculate any excess funds included with the bid. 
810         uint bidExcess = msg.value - price;
811 
812         // Return the funds. 
813 		if (bidExcess >= 1 finney) {
814 			msg.sender.transfer(bidExcess);
815 		}
816 
817         // Tell the world!
818         emit AuctionSuccessful(_tokenId, price, msg.sender);
819         
820         //give goods to bidder.
821         _transItem(this, msg.sender, _tokenId);
822     }
823 
824     /// @dev Cancels an auction that hasn't been won yet.
825     ///  Returns the NFT to original owner.
826     /// @notice This is a state-modifying function that can
827     ///  be called while the contract is paused.
828     /// @param _tokenId - ID of token on auction
829     function cancelAuction(uint _tokenId) external whenNotPaused {
830         Auction storage auction = tokenIdToAuction[_tokenId];
831         require(auction.startedAt > 0);
832         address seller = auction.seller;
833         require(msg.sender == seller);
834         _cancelAuction(_tokenId);
835     }
836 
837     /// @dev Cancels an auction when the contract is paused.
838     ///  Only the owner may do this, and NFTs are returned to
839     ///  the seller. This should only be used in emergencies.
840     /// @param _tokenId - ID of the NFT on auction to cancel.
841     function cancelAuctionByMaster(uint _tokenId)
842         external onlyCOO whenPaused
843     {
844         _cancelAuction(_tokenId);
845     }
846 	
847     
848     /// @dev Adds an auction to the list of open auctions. Also fires an event.
849     /// @param _tokenId The ID of the token to be put on auction.
850     /// @param _auction Auction to add.
851     function _addAuction(uint _tokenId, Auction _auction) internal {
852         // Require that all auctions have a duration of
853         // at least one minute. (Keeps our math from getting hairy!)
854         require(_auction.duration >= 1 minutes);
855 
856         tokenIdToAuction[_tokenId] = _auction;
857         
858         RabbitData storage rdata = rabbits[_tokenId];
859 
860         emit AuctionCreated(
861             uint(_tokenId),
862             uint(_auction.startingPrice),
863             uint(_auction.endingPrice),
864             uint(_auction.duration),
865             uint(_auction.startedAt),
866             uint32(rdata.explosive),
867             uint32(rdata.endurance),
868             uint32(rdata.nimble),
869             uint32(rdata.star)
870         );
871     }
872 
873     /// @dev Cancels an auction unconditionally.
874     function _cancelAuction(uint _tokenId) internal {
875 	    Auction storage auction = tokenIdToAuction[_tokenId];
876 		_transItem(this, auction.seller, _tokenId);
877         delete tokenIdToAuction[_tokenId];
878         emit AuctionCancelled(_tokenId);
879     }
880 
881     /// @dev Returns current price of an NFT on auction. 
882     function _calcCurrentPrice(Auction storage _auction)
883         internal
884         view
885         returns (uint outPrice)
886     {
887         int256 duration = _auction.duration;
888         int256 price0 = _auction.startingPrice;
889         int256 price2 = _auction.endingPrice;
890         require(duration > 0);
891         
892         int256 secondsPassed = int256(now) - int256(_auction.startedAt);
893         require(secondsPassed >= 0);
894         if (secondsPassed < _auction.duration) {
895             int256 priceChanged = (price2 - price0) * secondsPassed / duration;
896             int256 currentPrice = price0 + priceChanged;
897             outPrice = uint(currentPrice);
898         } else {
899             outPrice = _auction.endingPrice;
900         }
901     }
902     
903 	
904 	
905 	
906 	/// @dev tranfer token to the target, in case of some error occured.
907     ///  Only the coo may do this.
908 	/// @param _to The target address.
909 	/// @param _to The id of the token.
910 	function transferOnError(address _to, uint _tokenId) external onlyCOO {
911 		require(_owns(this, _tokenId));		
912 		Auction storage auction = tokenIdToAuction[_tokenId];
913 		require(auction.startedAt == 0);
914 		
915 		_transItem(this, _to, _tokenId);
916 	}
917 	
918 	
919 	/// @dev allow the user to draw a rabbit, with a signed message from coo
920 	function getFreeRabbit(uint32 _star, uint _taskId, uint8 v, bytes32 r, bytes32 s) external {
921 		require(usedSignId[_taskId] == 0);
922 		uint[2] memory arr = [_star, _taskId];
923 		string memory text = uint2ToStr(arr);
924 		address signer = verify(text, v, r, s);
925 		require(signer == cooAddress);
926 		
927 		_createRabbitInGrade(_star, msg.sender, 4);
928 		usedSignId[_taskId] = 1;
929 	}
930 	
931 	
932 	/// @dev allow any user to set rabbit data, with a signed message from coo
933 	function setRabbitData(
934 		uint _tokenId, 
935 		uint32 _explosive, 
936 		uint32 _endurance, 
937 		uint32 _nimble,
938 		uint _taskId,
939 		uint8 v, 
940 		bytes32 r, 
941 		bytes32 s
942 	) external {
943 		require(usedSignId[_taskId] == 0);
944 		
945 		Auction storage auction = tokenIdToAuction[_tokenId];
946 		require (auction.startedAt == 0);
947 		
948 		uint[5] memory arr = [_tokenId, _explosive, _endurance, _nimble, _taskId];
949 		string memory text = uint5ToStr(arr);
950 		address signer = verify(text, v, r, s);
951 		require(signer == cooAddress);
952 		
953 		RabbitData storage rdata = rabbits[_tokenId];
954 		rdata.explosive = _explosive;
955 		rdata.endurance = _endurance;
956 		rdata.nimble = _nimble;
957 		rabbits[_tokenId] = rdata;		
958 		
959 		usedSignId[_taskId] = 1;
960 		emit UpdateComplete(msg.sender, _tokenId);
961 	}
962 	
963 	/// @dev werify wether the message is form coo or not.
964 	function verify(string text, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {		
965 		bytes32 hash = keccak256(text);
966 		bytes memory prefix = "\x19Ethereum Signed Message:\n32";
967 		bytes32 prefixedHash = keccak256(prefix, hash);
968 		address tmp = ecrecover(prefixedHash, v, r, s);
969 		return tmp;
970 	}
971     
972 	/// @dev create an string according to the array
973     function uint2ToStr(uint[2] arr) internal pure returns (string){
974     	uint length = 0;
975     	uint i = 0;
976     	uint val = 0;
977     	for(; i < arr.length; i++){
978     		val = arr[i];
979     		while(val >= 10) {
980     			length += 1;
981     			val = val / 10;
982     		}
983     		length += 1;//for single 
984     		length += 1;//for comma
985     	}
986     	length -= 1;//remove last comma
987     	
988     	//copy char to bytes
989     	bytes memory bstr = new bytes(length);
990         uint k = length - 1;
991         int j = int(arr.length - 1);
992     	while (j >= 0) {
993     		val = arr[uint(j)];
994     		if (val == 0) {
995     			bstr[k] = byte(48);
996     			if (k > 0) {
997     			    k--;
998     			}
999     		} else {
1000     		    while (val != 0){
1001     				bstr[k] = byte(48 + val % 10);
1002     				val /= 10;
1003     				if (k > 0) {
1004         			    k--;
1005         			}
1006     			}
1007     		}
1008     		
1009     		if (j > 0) { //add comma
1010 				assert(k > 0);
1011     			bstr[k] = byte(44);
1012     			k--;
1013     		}
1014     		
1015     		j--;
1016     	}
1017     	
1018         return string(bstr);
1019     }
1020 	
1021 	/// @dev create an string according to the array
1022     function uint5ToStr(uint[5] arr) internal pure returns (string){
1023     	uint length = 0;
1024     	uint i = 0;
1025     	uint val = 0;
1026     	for(; i < arr.length; i++){
1027     		val = arr[i];
1028     		while(val >= 10) {
1029     			length += 1;
1030     			val = val / 10;
1031     		}
1032     		length += 1;//for single 
1033     		length += 1;//for comma
1034     	}
1035     	length -= 1;//remove last comma
1036     	
1037     	//copy char to bytes
1038     	bytes memory bstr = new bytes(length);
1039         uint k = length - 1;
1040         int j = int(arr.length - 1);
1041     	while (j >= 0) {
1042     		val = arr[uint(j)];
1043     		if (val == 0) {
1044     			bstr[k] = byte(48);
1045     			if (k > 0) {
1046     			    k--;
1047     			}
1048     		} else {
1049     		    while (val != 0){
1050     				bstr[k] = byte(48 + val % 10);
1051     				val /= 10;
1052     				if (k > 0) {
1053         			    k--;
1054         			}
1055     			}
1056     		}
1057     		
1058     		if (j > 0) { //add comma
1059 				assert(k > 0);
1060     			bstr[k] = byte(44);
1061     			k--;
1062     		}
1063     		
1064     		j--;
1065     	}
1066     	
1067         return string(bstr);
1068     }
1069 
1070 }
1071 
1072 
1073 /// @title CryptoRabbit: Collectible, oh-so-adorable rabbits on the Ethereum blockchain.
1074 /// @author cuilichen
1075 /// @dev The main CryptoRabbit contract, keeps track of rabbits so they don't wander around and get lost.
1076 /// This is the main CryptoRabbit contract. In order to keep our code seperated into logical sections.
1077 contract RabbitCore is RabbitAuction {
1078     
1079     event ContractUpgrade(address newContract);
1080 
1081     // Set in case the core contract is broken and an upgrade is required
1082     address public newContractAddress;
1083 
1084     /// @notice Creates the main CryptoRabbit smart contract instance.
1085     function RabbitCore(string _name, string _symbol) public {
1086         name = _name;
1087         symbol = _symbol;
1088         
1089         // the creator of the contract is the initial CEO
1090         ceoAddress = msg.sender;
1091         cooAddress = msg.sender;
1092         cfoAddress = msg.sender;
1093         
1094         //first rabbit in this world
1095         _createRabbit(5, 50, 50, 50, 1, msg.sender, 0);
1096     }
1097     
1098 
1099     /// @dev Used to mark the smart contract as upgraded.
1100     /// @param _v2Address new address
1101     function upgradeContract(address _v2Address) external onlyCOO whenPaused {
1102         // See README.md for updgrade plan
1103         newContractAddress = _v2Address;
1104         emit ContractUpgrade(_v2Address);
1105     }
1106 
1107 
1108     /// @dev Override unpause so it requires all external contract addresses
1109     ///  to be set before contract can be unpaused. Also, we can't have
1110     ///  newContractAddress set either, because then the contract was upgraded.
1111     /// @notice This is public rather than external so we can call super.unpause
1112     ///  without using an expensive CALL.
1113     function unpause() public onlyCOO {
1114         require(newContractAddress == address(0));
1115         
1116         // Actually unpause the contract.
1117         super.unpause();
1118     }
1119 
1120     // @dev Allows the CEO to capture the balance available to the contract.
1121     function withdrawBalance() external onlyCFO {
1122         address tmp = address(this);
1123         cfoAddress.transfer(tmp.balance);
1124     }
1125 }