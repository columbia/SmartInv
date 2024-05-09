1 pragma solidity 0.4.24;
2 
3 contract Governable {
4 
5     event Pause();
6     event Unpause();
7 
8     address public governor;
9     bool public paused = false;
10 
11     constructor() public {
12         governor = msg.sender;
13     }
14 
15     function setGovernor(address _gov) public onlyGovernor {
16         governor = _gov;
17     }
18 
19     modifier onlyGovernor {
20         require(msg.sender == governor);
21         _;
22     }
23 
24     /**
25     * @dev Modifier to make a function callable only when the contract is not paused.
26     */
27     modifier whenNotPaused() {
28         require(!paused);
29         _;
30     }
31 
32     /**
33     * @dev Modifier to make a function callable only when the contract is paused.
34     */
35     modifier whenPaused() {
36         require(paused);
37         _;
38     }
39 
40     /**
41     * @dev called by the owner to pause, triggers stopped state
42     */
43     function pause() onlyGovernor whenNotPaused public {
44         paused = true;
45         emit Pause();
46     }
47 
48     /**
49     * @dev called by the owner to unpause, returns to normal state
50     */
51     function unpause() onlyGovernor whenPaused public {
52         paused = false;
53         emit Unpause();
54     }
55 
56 }
57 
58 contract CardBase is Governable {
59 
60 
61     struct Card {
62         uint16 proto;
63         uint16 purity;
64     }
65 
66     function getCard(uint id) public view returns (uint16 proto, uint16 purity) {
67         Card memory card = cards[id];
68         return (card.proto, card.purity);
69     }
70 
71     function getShine(uint16 purity) public pure returns (uint8) {
72         return uint8(purity / 1000);
73     }
74 
75     Card[] public cards;
76     
77 }
78 
79 contract CardProto is CardBase {
80 
81     event NewProtoCard(
82         uint16 id, uint8 season, uint8 god, 
83         Rarity rarity, uint8 mana, uint8 attack, 
84         uint8 health, uint8 cardType, uint8 tribe, bool packable
85     );
86 
87     struct Limit {
88         uint64 limit;
89         bool exists;
90     }
91 
92     // limits for mythic cards
93     mapping(uint16 => Limit) public limits;
94 
95     // can only set limits once
96     function setLimit(uint16 id, uint64 limit) public onlyGovernor {
97         Limit memory l = limits[id];
98         require(!l.exists);
99         limits[id] = Limit({
100             limit: limit,
101             exists: true
102         });
103     }
104 
105     function getLimit(uint16 id) public view returns (uint64 limit, bool set) {
106         Limit memory l = limits[id];
107         return (l.limit, l.exists);
108     }
109 
110     // could make these arrays to save gas
111     // not really necessary - will be update a very limited no of times
112     mapping(uint8 => bool) public seasonTradable;
113     mapping(uint8 => bool) public seasonTradabilityLocked;
114     uint8 public currentSeason;
115 
116     function makeTradeable(uint8 season) public onlyGovernor {
117         seasonTradable[season] = true;
118     }
119 
120     function makeUntradable(uint8 season) public onlyGovernor {
121         require(!seasonTradabilityLocked[season]);
122         seasonTradable[season] = false;
123     }
124 
125     function makePermanantlyTradable(uint8 season) public onlyGovernor {
126         require(seasonTradable[season]);
127         seasonTradabilityLocked[season] = true;
128     }
129 
130     function isTradable(uint16 proto) public view returns (bool) {
131         return seasonTradable[protos[proto].season];
132     }
133 
134     function nextSeason() public onlyGovernor {
135         //Seasons shouldn't go to 0 if there is more than the uint8 should hold, the governor should know this ¯\_(ツ)_/¯ -M
136         require(currentSeason <= 255); 
137 
138         currentSeason++;
139         mythic.length = 0;
140         legendary.length = 0;
141         epic.length = 0;
142         rare.length = 0;
143         common.length = 0;
144     }
145 
146     enum Rarity {
147         Common,
148         Rare,
149         Epic,
150         Legendary, 
151         Mythic
152     }
153 
154     uint8 constant SPELL = 1;
155     uint8 constant MINION = 2;
156     uint8 constant WEAPON = 3;
157     uint8 constant HERO = 4;
158 
159     struct ProtoCard {
160         bool exists;
161         uint8 god;
162         uint8 season;
163         uint8 cardType;
164         Rarity rarity;
165         uint8 mana;
166         uint8 attack;
167         uint8 health;
168         uint8 tribe;
169     }
170 
171     // there is a particular design decision driving this:
172     // need to be able to iterate over mythics only for card generation
173     // don't store 5 different arrays: have to use 2 ids
174     // better to bear this cost (2 bytes per proto card)
175     // rather than 1 byte per instance
176 
177     uint16 public protoCount;
178     
179     mapping(uint16 => ProtoCard) protos;
180 
181     uint16[] public mythic;
182     uint16[] public legendary;
183     uint16[] public epic;
184     uint16[] public rare;
185     uint16[] public common;
186 
187     function addProtos(
188         uint16[] externalIDs, uint8[] gods, Rarity[] rarities, uint8[] manas, uint8[] attacks, uint8[] healths, uint8[] cardTypes, uint8[] tribes, bool[] packable
189     ) public onlyGovernor returns(uint16) {
190 
191         for (uint i = 0; i < externalIDs.length; i++) {
192 
193             ProtoCard memory card = ProtoCard({
194                 exists: true,
195                 god: gods[i],
196                 season: currentSeason,
197                 cardType: cardTypes[i],
198                 rarity: rarities[i],
199                 mana: manas[i],
200                 attack: attacks[i],
201                 health: healths[i],
202                 tribe: tribes[i]
203             });
204 
205             _addProto(externalIDs[i], card, packable[i]);
206         }
207         
208     }
209 
210     function addProto(
211         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 cardType, uint8 tribe, bool packable
212     ) public onlyGovernor returns(uint16) {
213         ProtoCard memory card = ProtoCard({
214             exists: true,
215             god: god,
216             season: currentSeason,
217             cardType: cardType,
218             rarity: rarity,
219             mana: mana,
220             attack: attack,
221             health: health,
222             tribe: tribe
223         });
224 
225         _addProto(externalID, card, packable);
226     }
227 
228     function addWeapon(
229         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 durability, bool packable
230     ) public onlyGovernor returns(uint16) {
231 
232         ProtoCard memory card = ProtoCard({
233             exists: true,
234             god: god,
235             season: currentSeason,
236             cardType: WEAPON,
237             rarity: rarity,
238             mana: mana,
239             attack: attack,
240             health: durability,
241             tribe: 0
242         });
243 
244         _addProto(externalID, card, packable);
245     }
246 
247     function addSpell(uint16 externalID, uint8 god, Rarity rarity, uint8 mana, bool packable) public onlyGovernor returns(uint16) {
248 
249         ProtoCard memory card = ProtoCard({
250             exists: true,
251             god: god,
252             season: currentSeason,
253             cardType: SPELL,
254             rarity: rarity,
255             mana: mana,
256             attack: 0,
257             health: 0,
258             tribe: 0
259         });
260 
261         _addProto(externalID, card, packable);
262     }
263 
264     function addMinion(
265         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe, bool packable
266     ) public onlyGovernor returns(uint16) {
267 
268         ProtoCard memory card = ProtoCard({
269             exists: true,
270             god: god,
271             season: currentSeason,
272             cardType: MINION,
273             rarity: rarity,
274             mana: mana,
275             attack: attack,
276             health: health,
277             tribe: tribe
278         });
279 
280         _addProto(externalID, card, packable);
281     }
282 
283     function _addProto(uint16 externalID, ProtoCard memory card, bool packable) internal {
284 
285         require(!protos[externalID].exists);
286 
287         card.exists = true;
288 
289         protos[externalID] = card;
290 
291         protoCount++;
292 
293         emit NewProtoCard(
294             externalID, currentSeason, card.god, 
295             card.rarity, card.mana, card.attack, 
296             card.health, card.cardType, card.tribe, packable
297         );
298 
299         if (packable) {
300             Rarity rarity = card.rarity;
301             if (rarity == Rarity.Common) {
302                 common.push(externalID);
303             } else if (rarity == Rarity.Rare) {
304                 rare.push(externalID);
305             } else if (rarity == Rarity.Epic) {
306                 epic.push(externalID);
307             } else if (rarity == Rarity.Legendary) {
308                 legendary.push(externalID);
309             } else if (rarity == Rarity.Mythic) {
310                 mythic.push(externalID);
311             } else {
312                 require(false);
313             }
314         }
315     }
316 
317     function getProto(uint16 id) public view returns(
318         bool exists, uint8 god, uint8 season, uint8 cardType, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe
319     ) {
320         ProtoCard memory proto = protos[id];
321         return (
322             proto.exists,
323             proto.god,
324             proto.season,
325             proto.cardType,
326             proto.rarity,
327             proto.mana,
328             proto.attack,
329             proto.health,
330             proto.tribe
331         );
332     }
333 
334     function getRandomCard(Rarity rarity, uint16 random) public view returns (uint16) {
335         // modulo bias is fine - creates rarity tiers etc
336         // will obviously revert is there are no cards of that type: this is expected - should never happen
337         if (rarity == Rarity.Common) {
338             return common[random % common.length];
339         } else if (rarity == Rarity.Rare) {
340             return rare[random % rare.length];
341         } else if (rarity == Rarity.Epic) {
342             return epic[random % epic.length];
343         } else if (rarity == Rarity.Legendary) {
344             return legendary[random % legendary.length];
345         } else if (rarity == Rarity.Mythic) {
346             // make sure a mythic is available
347             uint16 id;
348             uint64 limit;
349             bool set;
350             for (uint i = 0; i < mythic.length; i++) {
351                 id = mythic[(random + i) % mythic.length];
352                 (limit, set) = getLimit(id);
353                 if (set && limit > 0){
354                     return id;
355                 }
356             }
357             // if not, they get a legendary :(
358             return legendary[random % legendary.length];
359         }
360         require(false);
361         return 0;
362     }
363 
364     // can never adjust tradable cards
365     // each season gets a 'balancing beta'
366     // totally immutable: season, rarity
367     function replaceProto(
368         uint16 index, uint8 god, uint8 cardType, uint8 mana, uint8 attack, uint8 health, uint8 tribe
369     ) public onlyGovernor {
370         ProtoCard memory pc = protos[index];
371         require(!seasonTradable[pc.season]);
372         protos[index] = ProtoCard({
373             exists: true,
374             god: god,
375             season: pc.season,
376             cardType: cardType,
377             rarity: pc.rarity,
378             mana: mana,
379             attack: attack,
380             health: health,
381             tribe: tribe
382         });
383     }
384 
385 }
386 
387 interface ERC721Metadata /* is ERC721 */ {
388     /// @notice A descriptive name for a collection of NFTs in this contract
389     function name() external pure returns (string _name);
390 
391     /// @notice An abbreviated name for NFTs in this contract
392     function symbol() external pure returns (string _symbol);
393 
394     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
395     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
396     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
397     ///  Metadata JSON Schema".
398     function tokenURI(uint256 _tokenId) external view returns (string);
399 }
400 
401 interface ERC721Enumerable /* is ERC721 */ {
402     /// @notice Count NFTs tracked by this contract
403     /// @return A count of valid NFTs tracked by this contract, where each one of
404     ///  them has an assigned and queryable owner not equal to the zero address
405     function totalSupply() public view returns (uint256);
406 
407     /// @notice Enumerate valid NFTs
408     /// @dev Throws if `_index` >= `totalSupply()`.
409     /// @param _index A counter less than `totalSupply()`
410     /// @return The token identifier for the `_index`th NFT,
411     ///  (sort order not specified)
412     function tokenByIndex(uint256 _index) external view returns (uint256);
413 
414     /// @notice Enumerate NFTs assigned to an owner
415     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
416     ///  `_owner` is the zero address, representing invalid NFTs.
417     /// @param _owner An address where we are interested in NFTs    owned by them
418     /// @param _index A counter less than `balanceOf(_owner)`
419     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
420     ///   (sort order not specified)
421     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId);
422 }
423 
424 interface ERC165 {
425     /// @notice Query if a contract implements an interface
426     /// @param interfaceID The interface identifier, as specified in ERC-165
427     /// @dev Interface identification is specified in ERC-165. This function
428     ///  uses less than 30,000 gas.
429     /// @return `true` if the contract implements `interfaceID` and
430     ///  `interfaceID` is not 0xffffffff, `false` otherwise
431     function supportsInterface(bytes4 interfaceID) external view returns (bool);
432 }
433 
434 contract ERC721 {
435     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
436     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
437     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
438 
439     function balanceOf(address _owner) public view returns (uint256 _balance);
440     function ownerOf(uint256 _tokenId) public view returns (address _owner);
441     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public payable;
442     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable;
443     function transfer(address _to, uint256 _tokenId) public payable;
444     function transferFrom(address _from, address _to, uint256 _tokenId) public payable;
445     function approve(address _to, uint256 _tokenId) public payable;
446     function setApprovalForAll(address _to, bool _approved) public;
447     function getApproved(uint256 _tokenId) public view returns (address);
448     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
449 }
450 
451 contract NFT is ERC721, ERC165, ERC721Metadata, ERC721Enumerable {}
452 
453 contract CardOwnership is NFT, CardProto {
454 
455     // doing this strategy doesn't save gas
456     // even setting the length to the max and filling in
457     // unfortunately - maybe if we stop it boundschecking
458     // address[] owners;
459     mapping(uint => address) owners;
460     mapping(uint => address) approved;
461     // support multiple operators
462     mapping(address => mapping(address => bool)) operators;
463 
464     // save space, limits us to 2^40 tokens (>1t)
465     mapping(address => uint40[]) public ownedTokens;
466 
467     mapping(uint => string) uris;
468 
469     // save space, limits us to 2^24 tokens per user (~17m)
470     uint24[] indices;
471 
472     uint public burnCount;
473 
474     /**
475     * @return the name of this token
476     */
477     function name() public view returns (string) {
478         return "Gods Unchained";
479     }
480 
481     /**
482     * @return the symbol of this token
483     */  
484     function symbol() public view returns (string) {
485         return "GODS";
486     }
487 
488     /**
489     * @return the total number of cards in circulation
490     */
491     function totalSupply() public view returns (uint) {
492         return cards.length - burnCount;
493     }
494 
495     /**
496     * @param to : the address to which the card will be transferred
497     * @param id : the id of the card to be transferred
498     */
499     function transfer(address to, uint id) public payable {
500         require(owns(msg.sender, id));
501         require(isTradable(cards[id].proto));
502         require(to != address(0));
503         _transfer(msg.sender, to, id);
504     }
505 
506     /**
507     * internal transfer function which skips checks - use carefully
508     * @param from : the address from which the card will be transferred
509     * @param to : the address to which the card will be transferred
510     * @param id : the id of the card to be transferred
511     */
512     function _transfer(address from, address to, uint id) internal {
513         approved[id] = address(0);
514         owners[id] = to;
515         _addToken(to, id);
516         _removeToken(from, id);
517         emit Transfer(from, to, id);
518     }
519 
520     /**
521     * initial internal transfer function which skips checks and saves gas - use carefully
522     * @param to : the address to which the card will be transferred
523     * @param id : the id of the card to be transferred
524     */
525     function _create(address to, uint id) internal {
526         owners[id] = to;
527         _addToken(to, id);
528         emit Transfer(address(0), to, id);
529     }
530 
531     /**
532     * @param to : the address to which the cards will be transferred
533     * @param ids : the ids of the cards to be transferred
534     */
535     function transferAll(address to, uint[] ids) public payable {
536         for (uint i = 0; i < ids.length; i++) {
537             transfer(to, ids[i]);
538         }
539     }
540 
541     /**
542     * @param proposed : the claimed owner of the cards
543     * @param ids : the ids of the cards to check
544     * @return whether proposed owns all of the cards 
545     */
546     function ownsAll(address proposed, uint[] ids) public view returns (bool) {
547         for (uint i = 0; i < ids.length; i++) {
548             if (!owns(proposed, ids[i])) {
549                 return false;
550             }
551         }
552         return true;
553     }
554 
555     /**
556     * @param proposed : the claimed owner of the card
557     * @param id : the id of the card to check
558     * @return whether proposed owns the card
559     */
560     function owns(address proposed, uint id) public view returns (bool) {
561         return ownerOf(id) == proposed;
562     }
563 
564     /**
565     * @param id : the id of the card
566     * @return the address of the owner of the card
567     */
568     function ownerOf(uint id) public view returns (address) {
569         return owners[id];
570     }
571 
572     /**
573     * @param id : the index of the token to burn
574     */
575     function burn(uint id) public {
576         // require(isTradable(cards[id].proto));
577         require(owns(msg.sender, id));
578         burnCount++;
579         // use the internal transfer function as the external
580         // has a guard to prevent transfers to 0x0
581         _transfer(msg.sender, address(0), id);
582     }
583 
584     /**
585     * @param ids : the indices of the tokens to burn
586     */
587     function burnAll(uint[] ids) public {
588         for (uint i = 0; i < ids.length; i++){
589             burn(ids[i]);
590         }
591     }
592 
593     /**
594     * @param to : the address to approve for transfer
595     * @param id : the index of the card to be approved
596     */
597     function approve(address to, uint id) public payable {
598         require(owns(msg.sender, id));
599         require(isTradable(cards[id].proto));
600         approved[id] = to;
601         emit Approval(msg.sender, to, id);
602     }
603 
604     /**
605     * @param to : the address to approve for transfer
606     * @param ids : the indices of the cards to be approved
607     */
608     function approveAll(address to, uint[] ids) public payable {
609         for (uint i = 0; i < ids.length; i++) {
610             approve(to, ids[i]);
611         }
612     }
613 
614     /**
615     * @param id : the index of the token to check
616     * @return the address approved to transfer this token
617     */
618     function getApproved(uint id) public view returns(address) {
619         return approved[id];
620     }
621 
622     /**
623     * @param owner : the address to check
624     * @return the number of tokens controlled by owner
625     */
626     function balanceOf(address owner) public view returns (uint) {
627         return ownedTokens[owner].length;
628     }
629 
630     /**
631     * @param id : the index of the proposed token
632     * @return whether the token is owned by a non-zero address
633     */
634     function exists(uint id) public view returns (bool) {
635         return owners[id] != address(0);
636     }
637 
638     /**
639     * @param to : the address to which the token should be transferred
640     * @param id : the index of the token to transfer
641     */
642     function transferFrom(address from, address to, uint id) public payable {
643         
644         require(to != address(0));
645         require(to != address(this));
646 
647         // TODO: why is this necessary
648         // if you're approved, why does it matter where it comes from?
649         require(ownerOf(id) == from);
650 
651         require(isSenderApprovedFor(id));
652 
653         require(isTradable(cards[id].proto));
654 
655         _transfer(ownerOf(id), to, id);
656     }
657 
658     /**
659     * @param to : the address to which the tokens should be transferred
660     * @param ids : the indices of the tokens to transfer
661     */
662     function transferAllFrom(address to, uint[] ids) public payable {
663         for (uint i = 0; i < ids.length; i++) {
664             transferFrom(address(0), to, ids[i]);
665         }
666     }
667 
668     /**
669      * @return the number of cards which have been burned
670      */
671     function getBurnCount() public view returns (uint) {
672         return burnCount;
673     }
674 
675     function isApprovedForAll(address owner, address operator) public view returns (bool) {
676         return operators[owner][operator];
677     }
678 
679     function setApprovalForAll(address to, bool toApprove) public {
680         require(to != msg.sender);
681         operators[msg.sender][to] = toApprove;
682         emit ApprovalForAll(msg.sender, to, toApprove);
683     }
684 
685     bytes4 constant magic = bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
686 
687     function safeTransferFrom(address from, address to, uint id, bytes data) public payable {
688         require(to != address(0));
689         transferFrom(from, to, id);
690         if (_isContract(to)) {
691             bytes4 response = ERC721TokenReceiver(to).onERC721Received.gas(50000)(from, id, data);
692             require(response == magic);
693         }
694     }
695 
696     function safeTransferFrom(address from, address to, uint id) public payable {
697         safeTransferFrom(from, to, id, "");
698     }
699 
700     function _addToken(address to, uint id) private {
701         uint pos = ownedTokens[to].push(uint40(id)) - 1;
702         indices.push(uint24(pos));
703     }
704 
705     function _removeToken(address from, uint id) public payable {
706         uint24 index = indices[id];
707         uint lastIndex = ownedTokens[from].length - 1;
708         uint40 lastId = ownedTokens[from][lastIndex];
709 
710         ownedTokens[from][index] = lastId;
711         ownedTokens[from][lastIndex] = 0;
712         ownedTokens[from].length--;
713     }
714 
715     function isSenderApprovedFor(uint256 id) internal view returns (bool) {
716         return owns(msg.sender, id) || getApproved(id) == msg.sender || isApprovedForAll(ownerOf(id), msg.sender);
717     }
718 
719     function _isContract(address test) internal view returns (bool) {
720         uint size; 
721         assembly {
722             size := extcodesize(test)
723         }
724         return (size > 0);
725     }
726 
727     function tokenURI(uint id) public view returns (string) {
728         return uris[id];
729     }
730     
731     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 _tokenId){
732         return ownedTokens[owner][index];
733     }
734 
735     function tokenByIndex(uint256 index) external view returns (uint256){
736         return index;
737     }
738 
739     function supportsInterface(bytes4 interfaceID) public view returns (bool) {
740         return (
741             interfaceID == this.supportsInterface.selector || // ERC165
742             interfaceID == 0x5b5e139f || // ERC721Metadata
743             interfaceID == 0x6466353c || // ERC-721 on 3/7/2018
744             interfaceID == 0x780e9d63
745         ); // ERC721Enumerable
746     }
747 
748     function implementsERC721() external pure returns (bool) {
749         return true;
750     }
751 
752     function getOwnedTokens(address user) public view returns (uint40[]) {
753         return ownedTokens[user];
754     }
755     
756 
757 }
758 
759 /// @dev Note: the ERC-165 identifier for this interface is 0xf0b9e5ba
760 interface ERC721TokenReceiver {
761     /// @notice Handle the receipt of an NFT
762     /// @dev The ERC721 smart contract calls this function on the recipient
763     ///  after a `transfer`. This function MAY throw to revert and reject the
764     ///  transfer. This function MUST use 50,000 gas or less. Return of other
765     ///  than the magic value MUST result in the transaction being reverted.
766     ///  Note: the contract address is always the message sender.
767     /// @param _from The sending address
768     /// @param _tokenId The NFT identifier which is being transfered
769     /// @param _data Additional data with no specified format
770     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
771     ///  unless throwing
772 	function onERC721Received(address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
773 }
774 
775 
776 
777 contract CardIntegration is CardOwnership {
778     
779     CardPack[] packs;
780 
781     event CardCreated(uint indexed id, uint16 proto, uint16 purity, address owner);
782 
783     function addPack(CardPack approved) public onlyGovernor {
784         packs.push(approved);
785     }
786 
787     modifier onlyApprovedPacks {
788         require(_isApprovedPack());
789         _;
790     }
791 
792     function _isApprovedPack() private view returns (bool) {
793         for (uint i = 0; i < packs.length; i++) {
794             if (msg.sender == address(packs[i])) {
795                 return true;
796             }
797         }
798         return false;
799     }
800 
801     function createCard(address owner, uint16 proto, uint16 purity) public whenNotPaused onlyApprovedPacks returns (uint) {
802         ProtoCard memory card = protos[proto];
803         require(card.season == currentSeason);
804         if (card.rarity == Rarity.Mythic) {
805             uint64 limit;
806             bool exists;
807             (limit, exists) = getLimit(proto);
808             require(!exists || limit > 0);
809             limits[proto].limit--;
810         }
811         return _createCard(owner, proto, purity);
812     }
813 
814     function _createCard(address owner, uint16 proto, uint16 purity) internal returns (uint) {
815         Card memory card = Card({
816             proto: proto,
817             purity: purity
818         });
819 
820         uint id = cards.push(card) - 1;
821 
822         _create(owner, id);
823         
824         emit CardCreated(id, proto, purity, owner);
825 
826         return id;
827     }
828 
829     /*function combineCards(uint[] ids) public whenNotPaused {
830         require(ids.length == 5);
831         require(ownsAll(msg.sender, ids));
832         Card memory first = cards[ids[0]];
833         uint16 proto = first.proto;
834         uint8 shine = _getShine(first.purity);
835         require(shine < shineLimit);
836         uint16 puritySum = first.purity - (shine * 1000);
837         burn(ids[0]);
838         for (uint i = 1; i < ids.length; i++) {
839             Card memory next = cards[ids[i]];
840             require(next.proto == proto);
841             require(_getShine(next.purity) == shine);
842             puritySum += (next.purity - (shine * 1000));
843             burn(ids[i]);
844         }
845         uint16 newPurity = uint16(((shine + 1) * 1000) + (puritySum / ids.length));
846         _createCard(msg.sender, proto, newPurity);
847     }*/
848 
849 
850     // PURITY NOTES
851     // currently, we only
852     // however, to protect rarity, you'll never be abl
853     // this is enforced by the restriction in the create-card function
854     // no cards above this point can be found in packs
855 
856     
857 
858 }
859 
860 contract CardPack {
861 
862     CardIntegration public integration;
863     uint public creationBlock;
864 
865     constructor(CardIntegration _integration) public payable {
866         integration = _integration;
867         creationBlock = block.number;
868     }
869 
870     event Referral(address indexed referrer, uint value, address purchaser);
871 
872     /**
873     * purchase 'count' of this type of pack
874     */
875     function purchase(uint16 packCount, address referrer) public payable;
876 
877     // store purity and shine as one number to save users gas
878     function _getPurity(uint16 randOne, uint16 randTwo) internal pure returns (uint16) {
879         if (randOne >= 998) {
880             return 3000 + randTwo;
881         } else if (randOne >= 988) {
882             return 2000 + randTwo;
883         } else if (randOne >= 938) {
884             return 1000 + randTwo;
885         } else {
886             return randTwo;
887         }
888     }
889 
890 }
891 
892 contract Ownable {
893 
894    address public owner;
895 
896    constructor() public {
897        owner = msg.sender;
898    }
899 
900    function setOwner(address _owner) public onlyOwner {
901        owner = _owner;
902    }
903 
904    modifier onlyOwner {
905        require(msg.sender == owner);
906        _;
907    }
908 
909 }
910 
911 contract Vault is Ownable {
912 
913    function () public payable {
914 
915    }
916 
917    function getBalance() public view returns (uint) {
918        return address(this).balance;
919    }
920 
921    function withdraw(uint amount) public onlyOwner {
922        require(address(this).balance >= amount);
923        owner.transfer(amount);
924    }
925 
926    function withdrawAll() public onlyOwner {
927        withdraw(address(this).balance);
928    }
929 }
930 
931 contract CappedVault is Vault { 
932 
933     uint public limit;
934     uint withdrawn = 0;
935 
936     constructor() public {
937         limit = 33333 ether;
938     }
939 
940     function () public payable {
941         require(total() + msg.value <= limit);
942     }
943 
944     function total() public view returns(uint) {
945         return getBalance() + withdrawn;
946     }
947 
948     function withdraw(uint amount) public onlyOwner {
949         require(address(this).balance >= amount);
950         owner.transfer(amount);
951         withdrawn += amount;
952     }
953 
954 }
955 
956 
957 contract Pausable is Ownable {
958     
959     event Pause();
960     event Unpause();
961 
962     bool public paused = false;
963 
964 
965     /**
966     * @dev Modifier to make a function callable only when the contract is not paused.
967     */
968     modifier whenNotPaused() {
969         require(!paused);
970         _;
971     }
972 
973     /**
974     * @dev Modifier to make a function callable only when the contract is paused.
975     */
976     modifier whenPaused() {
977         require(paused);
978         _;
979     }
980 
981     /**
982     * @dev called by the owner to pause, triggers stopped state
983     */
984     function pause() onlyOwner whenNotPaused public {
985         paused = true;
986         emit Pause();
987     }
988 
989     /**
990     * @dev called by the owner to unpause, returns to normal state
991     */
992     function unpause() onlyOwner whenPaused public {
993         paused = false;
994         emit Unpause();
995     }
996 }
997 
998 contract PresalePack is CardPack, Pausable {
999 
1000     CappedVault public vault;
1001 
1002     Purchase[] purchases;
1003 
1004     struct Purchase {
1005         uint16 current;
1006         uint16 count;
1007         address user;
1008         uint randomness;
1009         uint64 commit;
1010     }
1011 
1012     event PacksPurchased(uint indexed id, address indexed user, uint16 count);
1013     event PackOpened(uint indexed id, uint16 startIndex, address indexed user, uint[] cardIDs);
1014     event RandomnessReceived(uint indexed id, address indexed user, uint16 count, uint randomness);
1015 
1016     constructor(CardIntegration integration, CappedVault _vault) public payable CardPack(integration) {
1017         vault = _vault;
1018     }
1019 
1020     function basePrice() public returns (uint);
1021     function getCardDetails(uint16 packIndex, uint8 cardIndex, uint result) public view returns (uint16 proto, uint16 purity);
1022     
1023     function packSize() public view returns (uint8) {
1024         return 5;
1025     }
1026 
1027     function packsPerClaim() public view returns (uint16) {
1028         return 15;
1029     }
1030 
1031     // start in bytes, length in bytes
1032     function extract(uint num, uint length, uint start) internal pure returns (uint) {
1033         return (((1 << (length * 8)) - 1) & (num >> ((start * 8) - 1)));
1034     }
1035 
1036     uint public purchaseCount;
1037     uint public totalCount;
1038 
1039     function purchase(uint16 packCount, address referrer) whenNotPaused public payable {
1040 
1041         require(packCount > 0);
1042         require(referrer != msg.sender);
1043 
1044         uint price = calculatePrice(basePrice(), packCount);
1045 
1046         require(msg.value >= price);
1047 
1048         Purchase memory p = Purchase({
1049             user: msg.sender,
1050             count: packCount,
1051             commit: uint64(block.number),
1052             randomness: 0,
1053             current: 0
1054         });
1055 
1056         uint id = purchases.push(p) - 1;
1057 
1058         emit PacksPurchased(id, msg.sender, packCount);
1059 
1060         if (referrer != address(0)) {
1061             uint commission = price / 10;
1062             referrer.transfer(commission);
1063             price -= commission;
1064             emit Referral(referrer, commission, msg.sender);
1065         }
1066         
1067         address(vault).transfer(price); 
1068     }
1069 
1070     // can be called by anybody
1071     function callback(uint id) public {
1072 
1073         Purchase storage p = purchases[id];
1074 
1075         require(p.randomness == 0);
1076 
1077         bytes32 bhash = blockhash(p.commit);
1078 
1079         uint random = uint(keccak256(abi.encodePacked(totalCount, bhash)));
1080 
1081         totalCount += p.count;
1082 
1083         if (uint(bhash) == 0) {
1084             // should never happen (must call within next 256 blocks)
1085             // if it does, just give them 1: will become common and therefore less valuable
1086             // set to 1 rather than 0 to avoid calling claim before randomness
1087             p.randomness = 1;
1088         } else {
1089             p.randomness = random;
1090         }
1091 
1092         emit RandomnessReceived(id, p.user, p.count, p.randomness);
1093     }
1094 
1095     
1096 
1097     function claim(uint id) public {
1098         
1099         Purchase storage p = purchases[id];
1100 
1101         require(canClaim);
1102 
1103         uint16 proto;
1104         uint16 purity;
1105         uint16 count = p.count;
1106         uint result = p.randomness;
1107         uint8 size = packSize();
1108 
1109         address user = p.user;
1110         uint16 current = p.current;
1111 
1112         require(result != 0); // have to wait for the callback
1113         // require(user == msg.sender); // not needed
1114         require(count > 0);
1115 
1116         uint[] memory ids = new uint[](size);
1117 
1118         uint16 end = current + packsPerClaim() > count ? count : current + packsPerClaim();
1119 
1120         require(end > current);
1121 
1122         for (uint16 i = current; i < end; i++) {
1123             for (uint8 j = 0; j < size; j++) {
1124                 (proto, purity) = getCardDetails(i, j, result);
1125                 ids[j] = integration.createCard(user, proto, purity);
1126             }
1127             emit PackOpened(id, (i * size), user, ids);
1128         }
1129         p.current += (end - current);
1130     }
1131 
1132     function predictPacks(uint id) external view returns (uint16[] protos, uint16[] purities) {
1133 
1134         Purchase memory p = purchases[id];
1135 
1136         uint16 proto;
1137         uint16 purity;
1138         uint16 count = p.count;
1139         uint result = p.randomness;
1140         uint8 size = packSize();
1141 
1142         purities = new uint16[](size * count);
1143         protos = new uint16[](size * count);
1144 
1145         for (uint16 i = 0; i < count; i++) {
1146             for (uint8 j = 0; j < size; j++) {
1147                 (proto, purity) = getCardDetails(i, j, result);
1148                 purities[(i * size) + j] = purity;
1149                 protos[(i * size) + j] = proto;
1150             }
1151         }
1152         return (protos, purities);
1153     }
1154 
1155     function calculatePrice(uint base, uint16 packCount) public view returns (uint) {
1156         // roughly 6k blocks per day
1157         uint difference = block.number - creationBlock;
1158         uint numDays = difference / 6000;
1159         if (20 > numDays) {
1160             return (base - (((20 - numDays) * base) / 100)) * packCount;
1161         }
1162         return base * packCount;
1163     }
1164 
1165     function _getCommonPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
1166         if (rand == 999999) {
1167             return CardProto.Rarity.Mythic;
1168         } else if (rand >= 998345) {
1169             return CardProto.Rarity.Legendary;
1170         } else if (rand >= 986765) {
1171             return CardProto.Rarity.Epic;
1172         } else if (rand >= 924890) {
1173             return CardProto.Rarity.Rare;
1174         } else {
1175             return CardProto.Rarity.Common;
1176         }
1177     }
1178 
1179     function _getRarePlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
1180         if (rand == 999999) {
1181             return CardProto.Rarity.Mythic;
1182         } else if (rand >= 981615) {
1183             return CardProto.Rarity.Legendary;
1184         } else if (rand >= 852940) {
1185             return CardProto.Rarity.Epic;
1186         } else {
1187             return CardProto.Rarity.Rare;
1188         } 
1189     }
1190 
1191     function _getEpicPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
1192         if (rand == 999999) {
1193             return CardProto.Rarity.Mythic;
1194         } else if (rand >= 981615) {
1195             return CardProto.Rarity.Legendary;
1196         } else {
1197             return CardProto.Rarity.Epic;
1198         }
1199     }
1200 
1201     function _getLegendaryPlusRarity(uint32 rand) internal pure returns (CardProto.Rarity) {
1202         if (rand == 999999) {
1203             return CardProto.Rarity.Mythic;
1204         } else {
1205             return CardProto.Rarity.Legendary;
1206         } 
1207     }
1208 
1209     bool public canClaim = true;
1210 
1211     function setCanClaim(bool claim) public onlyOwner {
1212         canClaim = claim;
1213     }
1214 
1215     function getComponents(
1216         uint16 i, uint8 j, uint rand
1217     ) internal returns (
1218         uint random, uint32 rarityRandom, uint16 purityOne, uint16 purityTwo, uint16 protoRandom
1219     ) {
1220         random = uint(keccak256(abi.encodePacked(i, rand, j)));
1221         rarityRandom = uint32(extract(random, 4, 10) % 1000000);
1222         purityOne = uint16(extract(random, 2, 4) % 1000);
1223         purityTwo = uint16(extract(random, 2, 6) % 1000);
1224         protoRandom = uint16(extract(random, 2, 8) % (2**16-1));
1225         return (random, rarityRandom, purityOne, purityTwo, protoRandom);
1226     }
1227 
1228     function withdraw() public onlyOwner {
1229         owner.transfer(address(this).balance);
1230     }
1231 
1232 }
1233 
1234 contract ERC20 {
1235 
1236     event Approval(address indexed owner, address indexed spender, uint256 value);
1237     event Transfer(address indexed from, address indexed to, uint256 value);
1238     
1239     function allowance(address owner, address spender) public view returns (uint256);
1240     
1241     function transferFrom(address from, address to, uint256 value) public returns (bool);
1242 
1243     function approve(address spender, uint256 value) public returns (bool);
1244 
1245     function totalSupply() public view returns (uint256);
1246 
1247     function balanceOf(address who) public view returns (uint256);
1248     
1249     function transfer(address to, uint256 value) public returns (bool);
1250     
1251   
1252 }
1253 
1254 pragma solidity 0.4.24;
1255 
1256 // from OZ
1257 
1258 /**
1259  * @title SafeMath
1260  * @dev Math operations with safety checks that throw on error
1261  */
1262 library SafeMath {
1263 
1264   /**
1265   * @dev Multiplies two numbers, throws on overflow.
1266   */
1267   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1268     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1269     // benefit is lost if 'b' is also tested.
1270     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1271     if (a == 0) {
1272       return 0;
1273     }
1274 
1275     c = a * b;
1276     assert(c / a == b);
1277     return c;
1278   }
1279 
1280   /**
1281   * @dev Integer division of two numbers, truncating the quotient.
1282   */
1283   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1284     // assert(b > 0); // Solidity automatically throws when dividing by 0
1285     // uint256 c = a / b;
1286     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1287     return a / b;
1288   }
1289 
1290   /**
1291   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1292   */
1293   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1294     assert(b <= a);
1295     return a - b;
1296   }
1297 
1298   /**
1299   * @dev Adds two numbers, throws on overflow.
1300   */
1301   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1302     c = a + b;
1303     assert(c >= a);
1304     return c;
1305   }
1306 }
1307 
1308 contract TournamentPass is ERC20, Ownable {
1309 
1310     using SafeMath for uint256;
1311 
1312     Vault vault;
1313 
1314     constructor(Vault _vault) public {
1315         vault = _vault;
1316     }
1317 
1318     mapping(address => uint256) balances;
1319     mapping (address => mapping (address => uint256)) internal allowed;
1320     address[] public minters;
1321     uint256 supply;
1322     uint mintLimit = 20000;
1323     
1324     function name() public view returns (string){
1325         return "GU Tournament Passes";
1326     }
1327 
1328     function symbol() public view returns (string) {
1329         return "PASS";
1330     }
1331 
1332     function addMinter(address minter) public onlyOwner {
1333         minters.push(minter);
1334     }
1335 
1336     function totalSupply() public view returns (uint256) {
1337         return supply;
1338     }
1339 
1340     function transfer(address _to, uint256 _value) public returns (bool) {
1341         require(_to != address(0));
1342         require(_value <= balances[msg.sender]);
1343 
1344         balances[msg.sender] = balances[msg.sender].sub(_value);
1345         balances[_to] = balances[_to].add(_value);
1346         emit Transfer(msg.sender, _to, _value);
1347         return true;
1348     }
1349 
1350     function balanceOf(address _owner) public view returns (uint256) {
1351         return balances[_owner];
1352     }
1353 
1354     function isMinter(address test) internal view returns (bool) {
1355         for (uint i = 0; i < minters.length; i++) {
1356             if (minters[i] == test) {
1357                 return true;
1358             }
1359         }
1360         return false;
1361     }
1362 
1363     function mint(address to, uint amount) public returns (bool) {
1364         require(isMinter(msg.sender));
1365         if (amount.add(supply) > mintLimit) {
1366             return false;
1367         } 
1368         supply = supply.add(amount);
1369         balances[to] = balances[to].add(amount);
1370         emit Transfer(address(0), to, amount);
1371         return true;
1372     }
1373 
1374     function approve(address _spender, uint256 _value) public returns (bool) {
1375         allowed[msg.sender][_spender] = _value;
1376         emit Approval(msg.sender, _spender, _value);
1377         return true;
1378     }
1379 
1380     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1381         require(_to != address(0));
1382         require(_value <= balances[_from]);
1383         require(_value <= allowed[_from][msg.sender]);
1384 
1385         balances[_from] = balances[_from].sub(_value);
1386         balances[_to] = balances[_to].add(_value);
1387         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1388         emit Transfer(_from, _to, _value);
1389         return true;
1390     }
1391 
1392     function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
1393         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
1394         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
1395         return true;
1396     }
1397 
1398     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
1399         uint256 oldValue = allowed[msg.sender][spender];
1400         if (subtractedValue > oldValue) {
1401             allowed[msg.sender][spender] = 0;
1402         } else {
1403             allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
1404         }
1405         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
1406         return true;
1407     }
1408 
1409     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
1410         return allowed[_owner][_spender];
1411     }
1412 
1413     uint public price = 250 finney;
1414 
1415     function purchase(uint amount) public payable {
1416         
1417         require(msg.value >= price.mul(amount));
1418         require(supply.add(amount) <= mintLimit);
1419 
1420         supply = supply.add(amount);
1421         balances[msg.sender] = balances[msg.sender].add(amount);
1422         emit Transfer(address(0), msg.sender, amount);
1423 
1424         address(vault).transfer(msg.value);
1425     }
1426 
1427 }
1428 
1429 contract LegendaryPack is PresalePack {
1430 
1431     TournamentPass pass;
1432 
1433     constructor(CardIntegration integration, CappedVault _vault, TournamentPass _pass) public payable PresalePack(integration, _vault) {
1434         pass = _pass;
1435     }
1436 
1437     function purchase(uint16 packCount, address referrer) public payable {
1438         super.purchase(packCount, referrer);
1439         pass.mint(msg.sender, packCount);
1440     }
1441 
1442     function basePrice() public returns (uint) {
1443         return 450 finney;
1444     }
1445 
1446     function getCardDetails(uint16 packIndex, uint8 cardIndex, uint result) public view returns (uint16 proto, uint16 purity) {
1447         uint random;
1448         uint32 rarityRandom;
1449         uint16 protoRandom;
1450         uint16 purityOne;
1451         uint16 purityTwo;
1452 
1453         CardProto.Rarity rarity;
1454 
1455         (random, rarityRandom, purityOne, purityTwo, protoRandom) = getComponents(packIndex, cardIndex, result);
1456 
1457         if (cardIndex == 4) {
1458             rarity = _getLegendaryPlusRarity(rarityRandom);
1459         } else if (cardIndex == 3) {
1460             rarity = _getRarePlusRarity(rarityRandom);
1461         } else {
1462             rarity = _getCommonPlusRarity(rarityRandom);
1463         }
1464 
1465         purity = _getPurity(purityOne, purityTwo);
1466     
1467         proto = integration.getRandomCard(rarity, protoRandom);
1468 
1469         return (proto, purity);
1470     } 
1471     
1472 }