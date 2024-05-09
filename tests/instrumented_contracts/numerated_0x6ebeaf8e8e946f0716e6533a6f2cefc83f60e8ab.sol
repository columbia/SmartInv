1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface ERC165 {
8 
9   /**
10    * @notice Query if a contract implements an interface
11    * @param _interfaceId The interface identifier, as specified in ERC-165
12    * @dev Interface identification is specified in ERC-165. This function
13    * uses less than 30,000 gas.
14    */
15   function supportsInterface(bytes4 _interfaceId) external view returns (bool);
16   
17 }
18 
19 contract ERC721Basic is ERC165 {
20     
21     event Transfer(
22         address indexed _from,
23         address indexed _to,
24         uint256 indexed _tokenId
25     );
26     event Approval(
27         address indexed _owner,
28         address indexed _approved,
29         uint256 indexed _tokenId
30     );
31     event ApprovalForAll(
32         address indexed _owner,
33         address indexed _operator,
34         bool _approved
35     );
36 
37     function balanceOf(address _owner) public view returns (uint256 _balance);
38     function ownerOf(uint256 _tokenId) public view returns (address _owner);
39     function exists(uint256 _tokenId) public view returns (bool _exists);
40 
41     function approve(address _to, uint256 _tokenId) public;
42     function getApproved(uint256 _tokenId)
43         public view returns (address _operator);
44 
45     function setApprovalForAll(address _operator, bool _approved) public;
46     function isApprovedForAll(address _owner, address _operator)
47         public view returns (bool);
48 
49     function transferFrom(address _from, address _to, uint256 _tokenId) public;
50     function safeTransferFrom(address _from, address _to, uint256 _tokenId)
51         public;
52 
53     function safeTransferFrom(
54         address _from,
55         address _to,
56         uint256 _tokenId,
57         bytes _data
58     )
59         public;
60 }
61 
62 
63 /**
64  * @title SupportsInterfaceWithLookup
65  * @author Matt Condon (@shrugs)
66  * @dev Implements ERC165 using a lookup table.
67  */
68 contract SupportsInterfaceWithLookup is ERC165 {
69     bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
70     /**
71     * 0x01ffc9a7 ===
72     *   bytes4(keccak256('supportsInterface(bytes4)'))
73     */
74 
75     /**
76     * @dev a mapping of interface id to whether or not it's supported
77     */
78     mapping(bytes4 => bool) internal supportedInterfaces;
79 
80     /**
81     * @dev A contract implementing SupportsInterfaceWithLookup
82     * implement ERC165 itself
83     */
84     constructor() public {
85         _registerInterface(InterfaceId_ERC165);
86     }
87 
88     /**
89     * @dev implement supportsInterface(bytes4) using a lookup table
90     */
91     function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
92         return supportedInterfaces[_interfaceId];
93     }
94 
95     /**
96     * @dev private method for registering an interface
97     */
98     function _registerInterface(bytes4 _interfaceId) internal {
99         require(_interfaceId != 0xffffffff);
100         supportedInterfaces[_interfaceId] = true;
101     }
102 }
103 
104 contract Governable {
105 
106     event Pause();
107     event Unpause();
108 
109     address public governor;
110     bool public paused = false;
111 
112     constructor() public {
113         governor = msg.sender;
114     }
115 
116     function setGovernor(address _gov) public onlyGovernor {
117         governor = _gov;
118     }
119 
120     modifier onlyGovernor {
121         require(msg.sender == governor);
122         _;
123     }
124 
125     /**
126     * @dev Modifier to make a function callable only when the contract is not paused.
127     */
128     modifier whenNotPaused() {
129         require(!paused);
130         _;
131     }
132 
133     /**
134     * @dev Modifier to make a function callable only when the contract is paused.
135     */
136     modifier whenPaused() {
137         require(paused);
138         _;
139     }
140 
141     /**
142     * @dev called by the owner to pause, triggers stopped state
143     */
144     function pause() onlyGovernor whenNotPaused public {
145         paused = true;
146         emit Pause();
147     }
148 
149     /**
150     * @dev called by the owner to unpause, returns to normal state
151     */
152     function unpause() onlyGovernor whenPaused public {
153         paused = false;
154         emit Unpause();
155     }
156 
157 }
158 
159 contract CardBase is Governable {
160 
161     struct Card {
162         uint16 proto;
163         uint16 purity;
164     }
165 
166     function getCard(uint id) public view returns (uint16 proto, uint16 purity) {
167         Card memory card = cards[id];
168         return (card.proto, card.purity);
169     }
170 
171     function getShine(uint16 purity) public pure returns (uint8) {
172         return uint8(purity / 1000);
173     }
174 
175     Card[] public cards;
176     
177 }
178 
179 contract CardProto is CardBase {
180 
181     event NewProtoCard(
182         uint16 id, uint8 season, uint8 god, 
183         Rarity rarity, uint8 mana, uint8 attack, 
184         uint8 health, uint8 cardType, uint8 tribe, bool packable
185     );
186 
187     struct Limit {
188         uint64 limit;
189         bool exists;
190     }
191 
192     // limits for mythic cards
193     mapping(uint16 => Limit) public limits;
194 
195     // can only set limits once
196     function setLimit(uint16 id, uint64 limit) public onlyGovernor {
197         Limit memory l = limits[id];
198         require(!l.exists);
199         limits[id] = Limit({
200             limit: limit,
201             exists: true
202         });
203     }
204 
205     function getLimit(uint16 id) public view returns (uint64 limit, bool set) {
206         Limit memory l = limits[id];
207         return (l.limit, l.exists);
208     }
209 
210     // could make these arrays to save gas
211     // not really necessary - will be update a very limited no of times
212     mapping(uint8 => bool) public seasonTradable;
213     mapping(uint8 => bool) public seasonTradabilityLocked;
214     uint8 public currentSeason;
215 
216     function makeTradable(uint8 season) public onlyGovernor {
217         seasonTradable[season] = true;
218     }
219 
220     function makeUntradable(uint8 season) public onlyGovernor {
221         require(!seasonTradabilityLocked[season]);
222         seasonTradable[season] = false;
223     }
224 
225     function makePermanantlyTradable(uint8 season) public onlyGovernor {
226         require(seasonTradable[season]);
227         seasonTradabilityLocked[season] = true;
228     }
229 
230     function isTradable(uint16 proto) public view returns (bool) {
231         return seasonTradable[protos[proto].season];
232     }
233 
234     function nextSeason() public onlyGovernor {
235         //Seasons shouldn't go to 0 if there is more than the uint8 should hold, the governor should know this ¯\_(ツ)_/¯ -M
236         require(currentSeason <= 255); 
237 
238         currentSeason++;
239         mythic.length = 0;
240         legendary.length = 0;
241         epic.length = 0;
242         rare.length = 0;
243         common.length = 0;
244     }
245 
246     enum Rarity {
247         Common,
248         Rare,
249         Epic,
250         Legendary, 
251         Mythic
252     }
253 
254     uint8 constant SPELL = 1;
255     uint8 constant MINION = 2;
256     uint8 constant WEAPON = 3;
257     uint8 constant HERO = 4;
258 
259     struct ProtoCard {
260         bool exists;
261         uint8 god;
262         uint8 season;
263         uint8 cardType;
264         Rarity rarity;
265         uint8 mana;
266         uint8 attack;
267         uint8 health;
268         uint8 tribe;
269     }
270 
271     // there is a particular design decision driving this:
272     // need to be able to iterate over mythics only for card generation
273     // don't store 5 different arrays: have to use 2 ids
274     // better to bear this cost (2 bytes per proto card)
275     // rather than 1 byte per instance
276 
277     uint16 public protoCount;
278     
279     mapping(uint16 => ProtoCard) protos;
280 
281     uint16[] public mythic;
282     uint16[] public legendary;
283     uint16[] public epic;
284     uint16[] public rare;
285     uint16[] public common;
286 
287     function addProtos(
288         uint16[] externalIDs, uint8[] gods, Rarity[] rarities, uint8[] manas, uint8[] attacks, 
289         uint8[] healths, uint8[] cardTypes, uint8[] tribes, bool[] packable
290     ) public onlyGovernor returns(uint16) {
291 
292         for (uint i = 0; i < externalIDs.length; i++) {
293 
294             ProtoCard memory card = ProtoCard({
295                 exists: true,
296                 god: gods[i],
297                 season: currentSeason,
298                 cardType: cardTypes[i],
299                 rarity: rarities[i],
300                 mana: manas[i],
301                 attack: attacks[i],
302                 health: healths[i],
303                 tribe: tribes[i]
304             });
305 
306             _addProto(externalIDs[i], card, packable[i]);
307         }
308         
309     }
310 
311     function addProto(
312         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 cardType, uint8 tribe, bool packable
313     ) public onlyGovernor returns(uint16) {
314         ProtoCard memory card = ProtoCard({
315             exists: true,
316             god: god,
317             season: currentSeason,
318             cardType: cardType,
319             rarity: rarity,
320             mana: mana,
321             attack: attack,
322             health: health,
323             tribe: tribe
324         });
325 
326         _addProto(externalID, card, packable);
327     }
328 
329     function addWeapon(
330         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 durability, bool packable
331     ) public onlyGovernor returns(uint16) {
332 
333         ProtoCard memory card = ProtoCard({
334             exists: true,
335             god: god,
336             season: currentSeason,
337             cardType: WEAPON,
338             rarity: rarity,
339             mana: mana,
340             attack: attack,
341             health: durability,
342             tribe: 0
343         });
344 
345         _addProto(externalID, card, packable);
346     }
347 
348     function addSpell(uint16 externalID, uint8 god, Rarity rarity, uint8 mana, bool packable) public onlyGovernor returns(uint16) {
349 
350         ProtoCard memory card = ProtoCard({
351             exists: true,
352             god: god,
353             season: currentSeason,
354             cardType: SPELL,
355             rarity: rarity,
356             mana: mana,
357             attack: 0,
358             health: 0,
359             tribe: 0
360         });
361 
362         _addProto(externalID, card, packable);
363     }
364 
365     function addMinion(
366         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe, bool packable
367     ) public onlyGovernor returns(uint16) {
368 
369         ProtoCard memory card = ProtoCard({
370             exists: true,
371             god: god,
372             season: currentSeason,
373             cardType: MINION,
374             rarity: rarity,
375             mana: mana,
376             attack: attack,
377             health: health,
378             tribe: tribe
379         });
380 
381         _addProto(externalID, card, packable);
382     }
383 
384     function _addProto(uint16 externalID, ProtoCard memory card, bool packable) internal {
385 
386         require(!protos[externalID].exists);
387 
388         card.exists = true;
389 
390         protos[externalID] = card;
391 
392         protoCount++;
393 
394         emit NewProtoCard(
395             externalID, currentSeason, card.god, 
396             card.rarity, card.mana, card.attack, 
397             card.health, card.cardType, card.tribe, packable
398         );
399 
400         if (packable) {
401             Rarity rarity = card.rarity;
402             if (rarity == Rarity.Common) {
403                 common.push(externalID);
404             } else if (rarity == Rarity.Rare) {
405                 rare.push(externalID);
406             } else if (rarity == Rarity.Epic) {
407                 epic.push(externalID);
408             } else if (rarity == Rarity.Legendary) {
409                 legendary.push(externalID);
410             } else if (rarity == Rarity.Mythic) {
411                 mythic.push(externalID);
412             } else {
413                 require(false);
414             }
415         }
416     }
417 
418     function getProto(uint16 id) public view returns(
419         bool exists, uint8 god, uint8 season, uint8 cardType, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe
420     ) {
421         ProtoCard memory proto = protos[id];
422         return (
423             proto.exists,
424             proto.god,
425             proto.season,
426             proto.cardType,
427             proto.rarity,
428             proto.mana,
429             proto.attack,
430             proto.health,
431             proto.tribe
432         );
433     }
434 
435     function getRandomCard(Rarity rarity, uint16 random) public view returns (uint16) {
436         // modulo bias is fine - creates rarity tiers etc
437         // will obviously revert is there are no cards of that type: this is expected - should never happen
438         if (rarity == Rarity.Common) {
439             return common[random % common.length];
440         } else if (rarity == Rarity.Rare) {
441             return rare[random % rare.length];
442         } else if (rarity == Rarity.Epic) {
443             return epic[random % epic.length];
444         } else if (rarity == Rarity.Legendary) {
445             return legendary[random % legendary.length];
446         } else if (rarity == Rarity.Mythic) {
447             // make sure a mythic is available
448             uint16 id;
449             uint64 limit;
450             bool set;
451             for (uint i = 0; i < mythic.length; i++) {
452                 id = mythic[(random + i) % mythic.length];
453                 (limit, set) = getLimit(id);
454                 if (set && limit > 0){
455                     return id;
456                 }
457             }
458             // if not, they get a legendary :(
459             return legendary[random % legendary.length];
460         }
461         require(false);
462         return 0;
463     }
464 
465     // can never adjust tradable cards
466     // each season gets a 'balancing beta'
467     // totally immutable: season, rarity
468     function replaceProto(
469         uint16 index, uint8 god, uint8 cardType, uint8 mana, uint8 attack, uint8 health, uint8 tribe
470     ) public onlyGovernor {
471         ProtoCard memory pc = protos[index];
472         require(!seasonTradable[pc.season]);
473         protos[index] = ProtoCard({
474             exists: true,
475             god: god,
476             season: pc.season,
477             cardType: cardType,
478             rarity: pc.rarity,
479             mana: mana,
480             attack: attack,
481             health: health,
482             tribe: tribe
483         });
484     }
485 
486 }
487 
488 contract ERC721Receiver {
489     /**
490     * @dev Magic value to be returned upon successful reception of an NFT
491     *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
492     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
493     */
494     bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
495 
496     /**
497     * @notice Handle the receipt of an NFT
498     * @dev The ERC721 smart contract calls this function on the recipient
499     * after a `safetransfer`. This function MAY throw to revert and reject the
500     * transfer. Return of other than the magic value MUST result in the 
501     * transaction being reverted.
502     * Note: the contract address is always the message sender.
503     * @param _operator The address which called `safeTransferFrom` function
504     * @param _from The address which previously owned the token
505     * @param _tokenId The NFT identifier which is being transfered
506     * @param _data Additional data with no specified format
507     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
508     */
509     function onERC721Received(
510         address _operator,
511         address _from,
512         uint256 _tokenId,
513         bytes _data
514     )
515         public
516         returns(bytes4);
517 }
518 
519 library AddressUtils {
520 
521   /**
522    * Returns whether the target address is a contract
523    * @dev This function will return false if invoked during the constructor of a contract,
524    * as the code is not actually created until after the constructor finishes.
525    * @param addr address to check
526    * @return whether the target address is a contract
527    */
528     function isContract(address addr) internal view returns (bool) {
529         uint256 size;
530         // XXX Currently there is no better way to check if there is a contract in an address
531         // than to check the size of the code at that address.
532         // See https://ethereum.stackexchange.com/a/14016/36603
533         // for more details about how this works.
534         // TODO Check this again before the Serenity release, because all addresses will be
535         // contracts then.
536         // solium-disable-next-line security/no-inline-assembly
537         assembly { size := extcodesize(addr) }
538         return size > 0;
539     }
540 
541 }
542 
543 library SafeMath {
544 
545   /**
546   * @dev Multiplies two numbers, throws on overflow.
547   */
548   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
549     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
550     // benefit is lost if 'b' is also tested.
551     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
552     if (a == 0) {
553       return 0;
554     }
555 
556     c = a * b;
557     assert(c / a == b);
558     return c;
559   }
560 
561   /**
562   * @dev Integer division of two numbers, truncating the quotient.
563   */
564   function div(uint256 a, uint256 b) internal pure returns (uint256) {
565     // assert(b > 0); // Solidity automatically throws when dividing by 0
566     // uint256 c = a / b;
567     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
568     return a / b;
569   }
570 
571   /**
572   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
573   */
574   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
575     assert(b <= a);
576     return a - b;
577   }
578 
579   /**
580   * @dev Adds two numbers, throws on overflow.
581   */
582   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
583     c = a + b;
584     assert(c >= a);
585     return c;
586   }
587 }
588 
589 contract ERC721BasicToken is CardProto, SupportsInterfaceWithLookup, ERC721Basic {
590 
591     bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
592     /*
593     * 0x80ac58cd ===
594     *   bytes4(keccak256('balanceOf(address)')) ^
595     *   bytes4(keccak256('ownerOf(uint256)')) ^
596     *   bytes4(keccak256('approve(address,uint256)')) ^
597     *   bytes4(keccak256('getApproved(uint256)')) ^
598     *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
599     *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
600     *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
601     *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
602     *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
603     */
604 
605     bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
606     /*
607     * 0x4f558e79 ===
608     *   bytes4(keccak256('exists(uint256)'))
609     */
610 
611     using SafeMath for uint256;
612     using AddressUtils for address;
613 
614     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
615     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
616     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
617 
618     // Mapping from token ID to owner
619     mapping (uint256 => address) internal tokenOwner;
620 
621     // Mapping from token ID to approved address
622     mapping (uint256 => address) internal tokenApprovals;
623 
624     // Mapping from owner to number of owned token
625     // mapping (address => uint256) internal ownedTokensCount;
626 
627     // Mapping from owner to operator approvals
628     mapping (address => mapping (address => bool)) internal operatorApprovals;
629 
630     /**
631     * @dev Guarantees msg.sender is owner of the given token
632     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
633     */
634     modifier onlyOwnerOf(uint256 _tokenId) {
635         require(ownerOf(_tokenId) == msg.sender);
636         _;
637     }
638 
639     /**
640     * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
641     * @param _tokenId uint256 ID of the token to validate
642     */
643     modifier canTransfer(uint256 _tokenId) {
644         require(isApprovedOrOwner(msg.sender, _tokenId));
645         _;
646     }
647 
648     constructor()
649         public
650     {
651         // register the supported interfaces to conform to ERC721 via ERC165
652         _registerInterface(InterfaceId_ERC721);
653         _registerInterface(InterfaceId_ERC721Exists);
654     }
655 
656     /**
657     * @dev Gets the balance of the specified address
658     * @param _owner address to query the balance of
659     * @return uint256 representing the amount owned by the passed address
660     */
661     function balanceOf(address _owner) public view returns (uint256);
662 
663     /**
664     * @dev Gets the owner of the specified token ID
665     * @param _tokenId uint256 ID of the token to query the owner of
666     * @return owner address currently marked as the owner of the given token ID
667     */
668     function ownerOf(uint256 _tokenId) public view returns (address) {
669         address owner = tokenOwner[_tokenId];
670         require(owner != address(0));
671         return owner;
672     }
673 
674     /**
675     * @dev Returns whether the specified token exists
676     * @param _tokenId uint256 ID of the token to query the existence of
677     * @return whether the token exists
678     */
679     function exists(uint256 _tokenId) public view returns (bool) {
680         address owner = tokenOwner[_tokenId];
681         return owner != address(0);
682     }
683 
684     /**
685     * @dev Approves another address to transfer the given token ID
686     * The zero address indicates there is no approved address.
687     * There can only be one approved address per token at a given time.
688     * Can only be called by the token owner or an approved operator.
689     * @param _to address to be approved for the given token ID
690     * @param _tokenId uint256 ID of the token to be approved
691     */
692     function approve(address _to, uint256 _tokenId) public {
693         address owner = ownerOf(_tokenId);
694         require(_to != owner);
695         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
696 
697         tokenApprovals[_tokenId] = _to;
698         emit Approval(owner, _to, _tokenId);
699     }
700 
701     /**
702     * @dev Gets the approved address for a token ID, or zero if no address set
703     * @param _tokenId uint256 ID of the token to query the approval of
704     * @return address currently approved for the given token ID
705     */
706     function getApproved(uint256 _tokenId) public view returns (address) {
707         return tokenApprovals[_tokenId];
708     }
709 
710     /**
711     * @dev Sets or unsets the approval of a given operator
712     * An operator is allowed to transfer all tokens of the sender on their behalf
713     * @param _to operator address to set the approval
714     * @param _approved representing the status of the approval to be set
715     */
716     function setApprovalForAll(address _to, bool _approved) public {
717         require(_to != msg.sender);
718         operatorApprovals[msg.sender][_to] = _approved;
719         emit ApprovalForAll(msg.sender, _to, _approved);
720     }
721 
722     /**
723     * @dev Tells whether an operator is approved by a given owner
724     * @param _owner owner address which you want to query the approval of
725     * @param _operator operator address which you want to query the approval of
726     * @return bool whether the given operator is approved by the given owner
727     */
728     function isApprovedForAll(
729         address _owner,
730         address _operator
731     )
732         public
733         view
734         returns (bool)
735     {
736         return operatorApprovals[_owner][_operator];
737     }
738 
739     /**
740     * @dev Transfers the ownership of a given token ID to another address
741     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
742     * Requires the msg sender to be the owner, approved, or operator
743     * @param _from current owner of the token
744     * @param _to address to receive the ownership of the given token ID
745     * @param _tokenId uint256 ID of the token to be transferred
746     */
747     function transferFrom(
748         address _from,
749         address _to,
750         uint256 _tokenId
751     )
752         public
753         canTransfer(_tokenId)
754     {
755         require(_from != address(0));
756         require(_to != address(0));
757 
758         clearApproval(_from, _tokenId);
759         removeTokenFrom(_from, _tokenId);
760         addTokenTo(_to, _tokenId);
761 
762         emit Transfer(_from, _to, _tokenId);
763     }
764 
765     /**
766     * @dev Safely transfers the ownership of a given token ID to another address
767     * If the target address is a contract, it must implement `onERC721Received`,
768     * which is called upon a safe transfer, and return the magic value
769     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
770     * the transfer is reverted.
771     *
772     * Requires the msg sender to be the owner, approved, or operator
773     * @param _from current owner of the token
774     * @param _to address to receive the ownership of the given token ID
775     * @param _tokenId uint256 ID of the token to be transferred
776     */
777     function safeTransferFrom(
778         address _from,
779         address _to,
780         uint256 _tokenId
781     )
782         public
783         canTransfer(_tokenId)
784     {
785         // solium-disable-next-line arg-overflow
786         safeTransferFrom(_from, _to, _tokenId, "");
787     }
788 
789     /**
790     * @dev Safely transfers the ownership of a given token ID to another address
791     * If the target address is a contract, it must implement `onERC721Received`,
792     * which is called upon a safe transfer, and return the magic value
793     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
794     * the transfer is reverted.
795     * Requires the msg sender to be the owner, approved, or operator
796     * @param _from current owner of the token
797     * @param _to address to receive the ownership of the given token ID
798     * @param _tokenId uint256 ID of the token to be transferred
799     * @param _data bytes data to send along with a safe transfer check
800     */
801     function safeTransferFrom(
802         address _from,
803         address _to,
804         uint256 _tokenId,
805         bytes _data
806     )
807         public
808         canTransfer(_tokenId)
809     {
810         transferFrom(_from, _to, _tokenId);
811         // solium-disable-next-line arg-overflow
812         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
813     }
814 
815     /**
816     * @dev Returns whether the given spender can transfer a given token ID
817     * @param _spender address of the spender to query
818     * @param _tokenId uint256 ID of the token to be transferred
819     * @return bool whether the msg.sender is approved for the given token ID,
820     *  is an operator of the owner, or is the owner of the token
821     */
822     function isApprovedOrOwner(
823         address _spender,
824         uint256 _tokenId
825     )
826         internal
827         view
828         returns (bool)
829     {
830         address owner = ownerOf(_tokenId);
831         // Disable solium check because of
832         // https://github.com/duaraghav8/Solium/issues/175
833         // solium-disable-next-line operator-whitespace
834         return (
835         _spender == owner ||
836         getApproved(_tokenId) == _spender ||
837         isApprovedForAll(owner, _spender)
838         );
839     }
840 
841     /**
842     * @dev Internal function to clear current approval of a given token ID
843     * Reverts if the given address is not indeed the owner of the token
844     * @param _owner owner of the token
845     * @param _tokenId uint256 ID of the token to be transferred
846     */
847     function clearApproval(address _owner, uint256 _tokenId) internal {
848         require(ownerOf(_tokenId) == _owner);
849         if (tokenApprovals[_tokenId] != address(0)) {
850             tokenApprovals[_tokenId] = address(0);
851         }
852     }
853 
854     /**
855     * @dev Internal function to mint a new token
856     * Reverts if the given token ID already exists
857     * @param _to The address that will own the minted token
858     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
859     */
860     function _mint(address _to, uint256 _tokenId) internal {
861         require(_to != address(0));
862         addNewTokenTo(_to, _tokenId);
863         emit Transfer(address(0), _to, _tokenId);
864     }
865 
866 
867     /**
868     * @dev Internal function to burn a specific token
869     * Reverts if the token does not exist
870     * @param _tokenId uint256 ID of the token being burned by the msg.sender
871     */
872     function _burn(address _owner, uint256 _tokenId) internal {
873         clearApproval(_owner, _tokenId);
874         removeTokenFrom(_owner, _tokenId);
875         emit Transfer(_owner, address(0), _tokenId);
876     }
877 
878     function addNewTokenTo(address _to, uint256 _tokenId) internal {
879         require(tokenOwner[_tokenId] == address(0));
880         tokenOwner[_tokenId] = _to;
881     }
882 
883     /**
884     * @dev Internal function to add a token ID to the list of a given address
885     * @param _to address representing the new owner of the given token ID
886     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
887     */
888     function addTokenTo(address _to, uint256 _tokenId) internal {
889         require(tokenOwner[_tokenId] == address(0));
890         tokenOwner[_tokenId] = _to;
891         // ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
892     }
893 
894     /**
895     * @dev Internal function to remove a token ID from the list of a given address
896     * @param _from address representing the previous owner of the given token ID
897     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
898     */
899     function removeTokenFrom(address _from, uint256 _tokenId) internal {
900         require(ownerOf(_tokenId) == _from);
901         // ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
902         tokenOwner[_tokenId] = address(0);
903     }
904 
905     /**
906     * @dev Internal function to invoke `onERC721Received` on a target address
907     * The call is not executed if the target address is not a contract
908     * @param _from address representing the previous owner of the given token ID
909     * @param _to target address that will receive the tokens
910     * @param _tokenId uint256 ID of the token to be transferred
911     * @param _data bytes optional data to send along with the call
912     * @return whether the call correctly returned the expected magic value
913     */
914     function checkAndCallSafeTransfer(
915         address _from,
916         address _to,
917         uint256 _tokenId,
918         bytes _data
919     )
920         internal
921         returns (bool)
922     {
923         if (!_to.isContract()) {
924             return true;
925         }
926         bytes4 retval = ERC721Receiver(_to).onERC721Received(
927         msg.sender, _from, _tokenId, _data);
928         return (retval == ERC721_RECEIVED);
929     }
930 
931 }
932 
933 
934 
935 contract ERC721Enumerable is ERC721Basic {
936     function totalSupply() public view returns (uint256);
937     function tokenOfOwnerByIndex(
938         address _owner,
939         uint256 _index
940     )
941         public
942         view
943         returns (uint256 _tokenId);
944 
945     function tokenByIndex(uint256 _index) public view returns (uint256);
946 }
947 
948 contract ERC721Metadata is ERC721Basic {
949     function name() external view returns (string _name);
950     function symbol() external view returns (string _symbol);
951     function tokenURI(uint256 _tokenId) public view returns (string);
952 }
953 
954 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
955 
956 }
957 
958 
959 
960 
961 library Strings {
962     
963   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
964   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
965       bytes memory _ba = bytes(_a);
966       bytes memory _bb = bytes(_b);
967       bytes memory _bc = bytes(_c);
968       bytes memory _bd = bytes(_d);
969       bytes memory _be = bytes(_e);
970       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
971       bytes memory babcde = bytes(abcde);
972       uint k = 0;
973       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
974       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
975       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
976       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
977       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
978       return string(babcde);
979     }
980 
981     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
982         return strConcat(_a, _b, _c, _d, "");
983     }
984 
985     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
986         return strConcat(_a, _b, _c, "", "");
987     }
988 
989     function strConcat(string _a, string _b) internal pure returns (string) {
990         return strConcat(_a, _b, "", "", "");
991     }
992 
993     function uint2str(uint i) internal pure returns (string) {
994         if (i == 0) return "0";
995         uint j = i;
996         uint len;
997         while (j != 0){
998             len++;
999             j /= 10;
1000         }
1001         bytes memory bstr = new bytes(len);
1002         uint k = len - 1;
1003         while (i != 0){
1004             bstr[k--] = byte(48 + i % 10);
1005             i /= 10;
1006         }
1007         return string(bstr);
1008     }
1009 }
1010 
1011 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
1012 
1013     using Strings for string;
1014 
1015     bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
1016     /**
1017     * 0x780e9d63 ===
1018     *   bytes4(keccak256('totalSupply()')) ^
1019     *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
1020     *   bytes4(keccak256('tokenByIndex(uint256)'))
1021     */
1022 
1023     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
1024     /**
1025     * 0x5b5e139f ===
1026     *   bytes4(keccak256('name()')) ^
1027     *   bytes4(keccak256('symbol()')) ^
1028     *   bytes4(keccak256('tokenURI(uint256)'))
1029     */
1030 
1031     /*** Constants ***/
1032     // Configure these for your own deployment
1033     string public constant NAME = "Gods Unchained";
1034     string public constant SYMBOL = "GODS";
1035     string public tokenMetadataBaseURI = "https://api.godsunchained.com/card/";
1036 
1037     // Mapping from owner to list of owned token IDs
1038     // EDITED: limit to 2^40 (around 1T)
1039     mapping(address => uint40[]) internal ownedTokens;
1040 
1041     uint32[] ownedTokensIndex;
1042 
1043     /**
1044     * @dev Constructor function
1045     */
1046     constructor() public {
1047 
1048         // register the supported interfaces to conform to ERC721 via ERC165
1049         _registerInterface(InterfaceId_ERC721Enumerable);
1050         _registerInterface(InterfaceId_ERC721Metadata);
1051     }
1052 
1053     /**
1054     * @dev Gets the token name
1055     * @return string representing the token name
1056     */
1057     function name() external view returns (string) {
1058         return NAME;
1059     }
1060 
1061     /**
1062     * @dev Gets the token symbol
1063     * @return string representing the token symbol
1064     */
1065     function symbol() external view returns (string) {
1066         return SYMBOL;
1067     }
1068 
1069     /**
1070     * @dev Returns an URI for a given token ID
1071     * Throws if the token ID does not exist. May return an empty string.
1072     * @param _tokenId uint256 ID of the token to query
1073     */
1074     function tokenURI(uint256 _tokenId) public view returns (string) {
1075         return Strings.strConcat(
1076             tokenMetadataBaseURI,
1077             Strings.uint2str(_tokenId)
1078         );
1079     }
1080 
1081     /**
1082     * @dev Gets the token ID at a given index of the tokens list of the requested owner
1083     * @param _owner address owning the tokens list to be accessed
1084     * @param _index uint256 representing the index to be accessed of the requested tokens list
1085     * @return uint256 token ID at the given index of the tokens list owned by the requested address
1086     */
1087     function tokenOfOwnerByIndex(
1088         address _owner,
1089         uint256 _index
1090     )
1091         public
1092         view
1093         returns (uint256)
1094     {
1095         require(_index < balanceOf(_owner));
1096         return ownedTokens[_owner][_index];
1097     }
1098 
1099     /**
1100     * @dev Gets the total amount of tokens stored by the contract
1101     * @return uint256 representing the total amount of tokens
1102     */
1103     function totalSupply() public view returns (uint256) {
1104         return cards.length;
1105     }
1106 
1107     /**
1108     * @dev Gets the token ID at a given index of all the tokens in this contract
1109     * Reverts if the index is greater or equal to the total number of tokens
1110     * @param _index uint256 representing the index to be accessed of the tokens list
1111     * @return uint256 token ID at the given index of the tokens list
1112     */
1113     function tokenByIndex(uint256 _index) public view returns (uint256) {
1114         require(_index < totalSupply());
1115         return _index;
1116     }
1117 
1118     /**
1119     * @dev Internal function to add a token ID to the list of a given address
1120     * @param _to address representing the new owner of the given token ID
1121     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1122     */
1123     function addTokenTo(address _to, uint256 _tokenId) internal {
1124         super.addTokenTo(_to, _tokenId);
1125         uint256 length = ownedTokens[_to].length;
1126         // EDITED: prevent overflow
1127         require(length == uint32(length));
1128         ownedTokens[_to].push(uint40(_tokenId));
1129 
1130         ownedTokensIndex[_tokenId] = uint32(length);
1131     }
1132 
1133     // EDITED
1134     // have to have in order to use array rather than mapping
1135     function addNewTokenTo(address _to, uint256 _tokenId) internal {
1136         super.addNewTokenTo(_to, _tokenId);
1137         uint256 length = ownedTokens[_to].length;
1138         // EDITED: prevent overflow
1139         require(length == uint32(length));
1140         ownedTokens[_to].push(uint40(_tokenId));
1141         ownedTokensIndex.push(uint32(length));
1142     }
1143 
1144     /**
1145     * @dev Internal function to remove a token ID from the list of a given address
1146     * @param _from address representing the previous owner of the given token ID
1147     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1148     */
1149     function removeTokenFrom(address _from, uint256 _tokenId) internal {
1150         super.removeTokenFrom(_from, _tokenId);
1151 
1152         uint32 tokenIndex = ownedTokensIndex[_tokenId];
1153         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1154         uint40 lastToken = ownedTokens[_from][lastTokenIndex];
1155 
1156         ownedTokens[_from][tokenIndex] = lastToken;
1157         ownedTokens[_from][lastTokenIndex] = 0;
1158         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1159         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1160         // the lastToken to the first position, and then dropping the element placed in the last position of the list
1161 
1162         ownedTokens[_from].length--;
1163         ownedTokensIndex[_tokenId] = 0;
1164         ownedTokensIndex[lastToken] = tokenIndex;
1165     }
1166 
1167     /**
1168     * @dev Gets the balance of the specified address - overrriden from previous to save gas
1169     * @param _owner address to query the balance of
1170     * @return uint256 representing the amount owned by the passed address
1171     */
1172     function balanceOf(address _owner) public view returns (uint256) {
1173         return ownedTokens[_owner].length;
1174     }
1175 
1176 }
1177 
1178 contract CardOwnershipTwo is ERC721Token {
1179 
1180     uint public burnCount;
1181 
1182     function getActiveCards() public view returns (uint) {
1183         return totalSupply() - burnCount;
1184     }
1185 
1186     /**
1187     * @param to : the address to which the card will be transferred
1188     * @param id : the id of the card to be transferred
1189     */
1190     function transfer(address to, uint id) public payable onlyOwnerOf(id) {
1191         require(isTradable(cards[id].proto));
1192         require(to != address(0));
1193         
1194         _transfer(msg.sender, to, id);
1195     }
1196     
1197     function _transfer(address from, address to, uint id) internal {
1198 
1199         clearApproval(from, id);
1200 
1201         removeTokenFrom(from, id);
1202 
1203         addTokenTo(to, id);
1204 
1205         emit Transfer(from, to, id);
1206     }
1207 
1208     /**
1209     * @param to : the address to which the cards will be transferred
1210     * @param ids : the ids of the cards to be transferred
1211     */
1212     function transferAll(address to, uint[] ids) public payable {
1213         for (uint i = 0; i < ids.length; i++) {
1214             transfer(to, ids[i]);
1215         }
1216     }
1217 
1218     /**
1219     * @param proposed : the claimed owner of the cards
1220     * @param ids : the ids of the cards to check
1221     * @return whether proposed owns all of the cards 
1222     */
1223     function ownsAll(address proposed, uint[] ids) public view returns (bool) {
1224         require(ids.length > 0);
1225         for (uint i = 0; i < ids.length; i++) {
1226             if (!owns(proposed, ids[i])) {
1227                 return false;
1228             }
1229         }
1230         return true;
1231     }
1232 
1233     /**
1234     * @param proposed : the claimed owner of the card
1235     * @param id : the id of the card to check
1236     * @return whether proposed owns the card
1237     */
1238     function owns(address proposed, uint id) public view returns (bool) {
1239         return ownerOf(id) == proposed;
1240     }
1241 
1242     function burn(uint id) public onlyOwnerOf(id) {
1243         burnCount++;
1244         _burn(msg.sender, id);
1245     }
1246 
1247     /**
1248     * @param ids : the indices of the tokens to burn
1249     */
1250     function burnAll(uint[] ids) public {
1251         for (uint i = 0; i < ids.length; i++){
1252             burn(ids[i]);
1253         }
1254     }
1255 
1256     /**
1257     * @param to : the address to approve for transfer
1258     * @param id : the index of the card to be approved
1259     */
1260     function approve(address to, uint id) public {
1261         require(isTradable(cards[id].proto));
1262         super.approve(to, id);
1263     }
1264 
1265     /**
1266     * @param to : the address to approve for transfer
1267     * @param ids : the indices of the cards to be approved
1268     */
1269     function approveAll(address to, uint[] ids) public {
1270         for (uint i = 0; i < ids.length; i++) {
1271             approve(to, ids[i]);
1272         }
1273     }
1274 
1275     /**
1276     * @param to : the address to which the token should be transferred
1277     * @param id : the index of the token to transfer
1278     */
1279     function transferFrom(address from, address to, uint id) public {
1280         require(isTradable(cards[id].proto));
1281         super.transferFrom(from, to, id);
1282     }
1283 
1284     /**
1285     * @param to : the address to which the tokens should be transferred
1286     * @param ids : the indices of the tokens to transfer
1287     */
1288     function transferAllFrom(address from, address to, uint[] ids) public {
1289         for (uint i = 0; i < ids.length; i++) {
1290             transferFrom(from, to, ids[i]);
1291         }
1292     }
1293 
1294     /**
1295      * @return the number of cards which have been burned
1296      */
1297     function getBurnCount() public view returns (uint) {
1298         return burnCount;
1299     }
1300 
1301 }
1302 
1303 contract CardIntegrationTwo is CardOwnershipTwo {
1304     
1305     address[] public packs;
1306 
1307     event CardCreated(uint indexed id, uint16 proto, uint16 purity, address owner);
1308 
1309     function addPack(address approved) public onlyGovernor {
1310         packs.push(approved);
1311     }
1312 
1313     modifier onlyApprovedPacks {
1314         require(_isApprovedPack());
1315         _;
1316     }
1317 
1318     function _isApprovedPack() private view returns (bool) {
1319         for (uint i = 0; i < packs.length; i++) {
1320             if (msg.sender == address(packs[i])) {
1321                 return true;
1322             }
1323         }
1324         return false;
1325     }
1326 
1327     function createCard(address owner, uint16 proto, uint16 purity) public whenNotPaused onlyApprovedPacks returns (uint) {
1328         ProtoCard memory card = protos[proto];
1329         require(card.season == currentSeason);
1330         if (card.rarity == Rarity.Mythic) {
1331             uint64 limit;
1332             bool exists;
1333             (limit, exists) = getLimit(proto);
1334             require(!exists || limit > 0);
1335             limits[proto].limit--;
1336         }
1337         return _createCard(owner, proto, purity);
1338     }
1339 
1340     function _createCard(address owner, uint16 proto, uint16 purity) internal returns (uint) {
1341         Card memory card = Card({
1342             proto: proto,
1343             purity: purity
1344         });
1345 
1346         uint id = cards.push(card) - 1;
1347 
1348         _mint(owner, id);
1349         
1350         emit CardCreated(id, proto, purity, owner);
1351 
1352         return id;
1353     }
1354 
1355     /*function combineCards(uint[] ids) public whenNotPaused {
1356         require(ids.length == 5);
1357         require(ownsAll(msg.sender, ids));
1358         Card memory first = cards[ids[0]];
1359         uint16 proto = first.proto;
1360         uint8 shine = _getShine(first.purity);
1361         require(shine < shineLimit);
1362         uint16 puritySum = first.purity - (shine * 1000);
1363         burn(ids[0]);
1364         for (uint i = 1; i < ids.length; i++) {
1365             Card memory next = cards[ids[i]];
1366             require(next.proto == proto);
1367             require(_getShine(next.purity) == shine);
1368             puritySum += (next.purity - (shine * 1000));
1369             burn(ids[i]);
1370         }
1371         uint16 newPurity = uint16(((shine + 1) * 1000) + (puritySum / ids.length));
1372         _createCard(msg.sender, proto, newPurity);
1373     }*/
1374 
1375 
1376     // PURITY NOTES
1377     // currently, we only
1378     // however, to protect rarity, you'll never be abl
1379     // this is enforced by the restriction in the create-card function
1380     // no cards above this point can be found in packs
1381 
1382     
1383 
1384 }
1385 
1386 contract PreviousInterface {
1387 
1388     function ownerOf(uint id) public view returns (address);
1389 
1390     function getCard(uint id) public view returns (uint16, uint16);
1391 
1392     function totalSupply() public view returns (uint);
1393 
1394     function burnCount() public view returns (uint);
1395 
1396 }
1397 
1398 contract CardMigration is CardIntegrationTwo {
1399 
1400     constructor(PreviousInterface previous) public {
1401         old = previous;
1402     }
1403 
1404     // use interface to lower deployment cost
1405     PreviousInterface old;
1406 
1407     mapping(uint => bool) public migrated;
1408 
1409     function migrate(uint id) public {
1410 
1411         require(!migrated[id]);
1412         
1413         migrated[id] = true;
1414 
1415         address owner = old.ownerOf(id);
1416 
1417         uint16 proto;
1418         uint16 purity;
1419     
1420         (proto, purity) = old.getCard(id);
1421 
1422         _createCard(owner, proto, purity);
1423     }
1424 
1425     function migrateAll(uint[] ids) public {
1426 
1427         for (uint i = 0; i < ids.length; i++){
1428             migrate(ids[i]);
1429         }
1430 
1431     }
1432 
1433 }