1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73    @title ERC827 interface, an extension of ERC20 token standard
74 
75    Interface of a ERC827 token, following the ERC20 standard with extra
76    methods to transfer value and data and execute calls in transfers and
77    approvals.
78  */
79 contract ERC827 is ERC20 {
80 
81   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
82   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
83   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
84 
85 }
86 
87 contract AccessControl {
88     address public ceoAddress;
89     address public cfoAddress;
90     address public cooAddress;
91 
92     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
93     bool public paused = false;
94 
95     /// @dev Access modifier for CEO-only functionality
96     modifier onlyCEO() {
97         require(msg.sender == ceoAddress);
98         _;
99     }
100 
101     /// @dev Access modifier for CFO-only functionality
102     modifier onlyCFO() {
103         require(msg.sender == cfoAddress);
104         _;
105     }
106 
107     /// @dev Access modifier for COO-only functionality
108     modifier onlyCOO() {
109         require(msg.sender == cooAddress);
110         _;
111     }
112 
113     modifier onlyCLevel() {
114         require(
115             msg.sender == cooAddress || 
116             msg.sender == ceoAddress || 
117             msg.sender == cfoAddress
118         );
119         _;
120     }
121 
122     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
123     /// @param _newCEO The address of the new CEO
124     function setCEO(address _newCEO) external onlyCEO {
125         require(_newCEO != address(0));
126 
127         ceoAddress = _newCEO;
128     }
129 
130     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
131     /// @param _newCFO The address of the new CFO
132     function setCFO(address _newCFO) external onlyCEO {
133         require(_newCFO != address(0));
134 
135         cfoAddress = _newCFO;
136     }
137 
138     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
139     /// @param _newCOO The address of the new COO
140     function setCOO(address _newCOO) external onlyCEO {
141         require(_newCOO != address(0));
142 
143         cooAddress = _newCOO;
144     }
145 
146     /*** Pausable functionality adapted from OpenZeppelin ***/
147 
148     /// @dev Modifier to allow actions only when the contract IS NOT paused
149     modifier whenNotPaused() {
150         require(!paused);
151         _;
152     }
153 
154     /// @dev Modifier to allow actions only when the contract IS paused
155     modifier whenPaused {
156         require(paused);
157         _;
158     }
159 
160     /// @dev Called by any "C-level" role to pause the contract. Used only when
161     ///  a bug or exploit is detected and we need to limit damage.
162     function pause() external onlyCLevel whenNotPaused {
163         paused = true;
164     }
165 
166     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
167     ///  one reason we may pause the contract is when CFO or COO accounts are
168     ///  compromised.
169     /// @notice This is public rather than external so it can be called by
170     ///  derived contracts.
171     function unpause() public onlyCEO whenPaused {
172         paused = false;
173     }
174 }
175 
176 /// @title 
177 contract TournamentInterface {
178     /// @dev simply a boolean to indicate this is the contract we expect to be
179     function isTournament() public pure returns (bool);
180     function isPlayerIdle(address _owner, uint256 _playerId) public view returns (bool);
181 }
182 
183 /// @title Base contract for BS. Holds all common structs, events and base variables.
184 contract BSBase is AccessControl {
185     /*** EVENTS ***/
186 
187     /// @dev The Birth event is fired whenever a new player comes into existence. 
188     event Birth(address owner, uint32 playerId, uint16 typeId, uint8 attack, uint8 defense, uint8 stamina, uint8 xp, uint8 isKeeper, uint16 skillId);
189 
190     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a player
191     ///  ownership is assigned, including births.
192     event Transfer(address from, address to, uint256 tokenId);
193 
194     struct Player {
195         uint16 typeId;
196         uint8 attack;
197         uint8 defense;
198         uint8 stamina;
199         uint8 xp;
200         uint8 isKeeper;
201         uint16 skillId;
202         uint8 isSkillOn;
203     }
204 
205     Player[] players;
206     uint256 constant commonPlayerCount = 10;
207     uint256 constant totalPlayerSupplyLimit = 80000000;
208     mapping (uint256 => address) public playerIndexToOwner;
209     mapping (address => uint256) ownershipTokenCount;
210     mapping (uint256 => address) public playerIndexToApproved;
211     /// SaleClockAuction public saleAuction;
212     ERC827 public joyTokenContract;
213     TournamentInterface public tournamentContract;
214 
215     /// @dev Assigns ownership of a specific Player to an address.
216     function _transfer(address _from, address _to, uint256 _tokenId) internal {
217         // since the number of players is capped to 2^32
218         // there is no way to overflow this
219         ownershipTokenCount[_to]++;
220         // transfer ownership
221         playerIndexToOwner[_tokenId] = _to;
222         // When creating new player _from is 0x0, but we can't account that address.
223         if (_from != address(0)) {
224             ownershipTokenCount[_from]--;
225             // clear any previously approved ownership exchange
226             delete playerIndexToApproved[_tokenId];
227         }
228         // Emit the transfer event.
229         Transfer(_from, _to, _tokenId);
230     }
231 
232     function _createPlayer(
233         address _owner,
234         uint256 _typeId,
235         uint256 _attack,
236         uint256 _defense,
237         uint256 _stamina,
238         uint256 _xp,
239         uint256 _isKeeper,
240         uint256 _skillId
241     )
242         internal
243         returns (uint256)
244     {
245         Player memory _player = Player({
246             typeId: uint16(_typeId), 
247             attack: uint8(_attack), 
248             defense: uint8(_defense), 
249             stamina: uint8(_stamina),
250             xp: uint8(_xp),
251             isKeeper: uint8(_isKeeper),
252             skillId: uint16(_skillId),
253             isSkillOn: 0
254         });
255         uint256 newPlayerId = players.push(_player) - 1;
256 
257         require(newPlayerId <= totalPlayerSupplyLimit);
258 
259         // emit the birth event
260         Birth(
261             _owner,
262             uint32(newPlayerId),
263             _player.typeId,
264             _player.attack,
265             _player.defense,
266             _player.stamina,
267             _player.xp,
268             _player.isKeeper,
269             _player.skillId
270         );
271 
272         // This will assign ownership, and also emit the Transfer event as
273         // per ERC721 draft
274         _transfer(0, _owner, newPlayerId);
275 
276         return newPlayerId;
277     }
278 }
279 
280 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
281 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
282 contract ERC721 {
283     // Required methods
284     function totalSupply() public view returns (uint256 total);
285     function balanceOf(address _owner) public view returns (uint256 balance);
286     function ownerOf(uint256 _tokenId) public view returns (address owner);
287     function approve(address _to, uint256 _tokenId) public;
288     function transfer(address _to, uint256 _tokenId) public;
289     function transferFrom(address _from, address _to, uint256 _tokenId) public;
290 
291     // Events
292     event Transfer(address from, address to, uint256 tokenId);
293     event Approval(address owner, address approved, uint256 tokenId);
294 
295     // Optional
296     // function name() public view returns (string name);
297     // function symbol() public view returns (string symbol);
298     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
299     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
300 
301     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
302     function supportsInterface(bytes4 _interfaceID) public view returns (bool);
303 }
304 
305 /// @title The facet of the BS core contract that manages ownership, ERC-721 (draft) compliant.
306 contract BSOwnership is BSBase, ERC721 {
307 
308     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
309     string public constant name = "BitSoccer Player";
310     string public constant symbol = "BSP";
311 
312     bytes4 constant InterfaceSignature_ERC165 =
313         bytes4(keccak256("supportsInterface(bytes4)"));
314 
315     bytes4 constant InterfaceSignature_ERC721 =
316         bytes4(keccak256("name()")) ^
317         bytes4(keccak256("symbol()")) ^
318         bytes4(keccak256("totalSupply()")) ^
319         bytes4(keccak256("balanceOf(address)")) ^
320         bytes4(keccak256("ownerOf(uint256)")) ^
321         bytes4(keccak256("approve(address,uint256)")) ^
322         bytes4(keccak256("transfer(address,uint256)")) ^
323         bytes4(keccak256("transferFrom(address,address,uint256)")) ^
324         bytes4(keccak256("tokensOfOwner(address)"));
325 
326     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
327     ///  Returns true for any standardized interfaces implemented by this contract. We implement
328     ///  ERC-165 (obviously!) and ERC-721.
329     function supportsInterface(bytes4 _interfaceID) public view returns (bool)
330     {
331         // DEBUG ONLY
332         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9f40b779));
333 
334         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
335     }
336 
337     // Internal utility functions: These functions all assume that their input arguments
338     // are valid. We leave it to public methods to sanitize their inputs and follow
339     // the required logic.
340 
341     /// @dev Checks if a given address is the current owner of a particular Player.
342     /// @param _claimant the address we are validating against.
343     /// @param _tokenId player id, only valid when > 0
344     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
345         return playerIndexToOwner[_tokenId] == _claimant;
346     }
347 
348     function _isIdle(address _owner, uint256 _tokenId) internal view returns (bool) {
349         return (tournamentContract == address(0) || tournamentContract.isPlayerIdle(_owner, _tokenId));
350     }
351 
352     /// @dev Checks if a given address currently has transferApproval for a particular Player.
353     /// @param _claimant the address we are confirming player is approved for.
354     /// @param _tokenId player id, only valid when > 0
355     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
356         return playerIndexToApproved[_tokenId] == _claimant;
357     }
358 
359     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
360     ///  approval. Setting _approved to address(0) clears all transfer approval.
361     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
362     ///  _approve() and transferFrom() are used together for putting players on auction, and
363     ///  there is no value in spamming the log with Approval events in that case.
364     function _approve(uint256 _tokenId, address _approved) internal {
365         playerIndexToApproved[_tokenId] = _approved;
366     }
367 
368     /// @notice Returns the number of players owned by a specific address.
369     /// @param _owner The owner address to check.
370     /// @dev Required for ERC-721 compliance
371     function balanceOf(address _owner) public view returns (uint256 count) {
372         return ownershipTokenCount[_owner];
373     }
374 
375     /// @notice Transfers a Player to another address. If transferring to a smart
376     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
377     ///  BSPlayers specifically) or your Player may be lost forever. Seriously.
378     /// @param _to The address of the recipient, can be a user or contract.
379     /// @param _tokenId The ID of the player to transfer.
380     /// @dev Required for ERC-721 compliance.
381     function transfer(
382         address _to,
383         uint256 _tokenId
384     )
385         public
386         whenNotPaused
387     {
388         // Safety check to prevent against an unexpected 0x0 default.
389         require(_to != address(0));
390         // Disallow transfers to this contract to prevent accidental misuse.
391         require(_to != address(this));
392 
393         // Disallow transfers to the auction contracts to prevent accidental
394         // misuse. Auction contracts should only take ownership of players
395         // through the allow + transferFrom flow.
396         // require(_to != address(saleAuction));
397 
398         // You can only send your own player.
399         require(_owns(msg.sender, _tokenId));
400         require(_isIdle(msg.sender, _tokenId));
401 
402         // Reassign ownership, clear pending approvals, emit Transfer event.
403         _transfer(msg.sender, _to, _tokenId);
404     }
405 
406     /// @notice Grant another address the right to transfer a specific Player via
407     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
408     /// @param _to The address to be granted transfer approval. Pass address(0) to
409     ///  clear all approvals.
410     /// @param _tokenId The ID of the Player that can be transferred if this call succeeds.
411     /// @dev Required for ERC-721 compliance.
412     function approve(
413         address _to,
414         uint256 _tokenId
415     )
416         public
417         whenNotPaused
418     {
419         // Only an owner can grant transfer approval.
420         require(_owns(msg.sender, _tokenId));
421         require(_isIdle(msg.sender, _tokenId));
422 
423         // Register the approval (replacing any previous approval).
424         _approve(_tokenId, _to);
425 
426         // Emit approval event.
427         Approval(msg.sender, _to, _tokenId);
428     }
429 
430     /// @notice Transfer a Player owned by another address, for which the calling address
431     ///  has previously been granted transfer approval by the owner.
432     /// @param _from The address that owns the Player to be transfered.
433     /// @param _to The address that should take ownership of the Player. Can be any address,
434     ///  including the caller.
435     /// @param _tokenId The ID of the player to be transferred.
436     /// @dev Required for ERC-721 compliance.
437     function transferFrom(
438         address _from,
439         address _to,
440         uint256 _tokenId
441     )
442         public
443         whenNotPaused
444     {
445         // Safety check to prevent against an unexpected 0x0 default.
446         require(_to != address(0));
447         // Disallow transfers to this contract to prevent accidental misuse.
448         require(_to != address(this));
449         // Check for approval and valid ownership
450         require(_approvedFor(msg.sender, _tokenId));
451         require(_owns(_from, _tokenId));
452         require(_isIdle(_from, _tokenId));
453 
454         // Reassign ownership (also clears pending approvals and emits Transfer event).
455         _transfer(_from, _to, _tokenId);
456     }
457 
458     /// @notice Returns the total number of Players currently in existence.
459     /// @dev Required for ERC-721 compliance.
460     function totalSupply() public view returns (uint) {
461         return players.length;
462     }
463 
464     /// @notice Returns the address currently assigned ownership of a given Player.
465     /// @dev Required for ERC-721 compliance.
466     function ownerOf(uint256 _tokenId)
467         public
468         view
469         returns (address owner)
470     {
471         owner = playerIndexToOwner[_tokenId];
472 
473         require(owner != address(0));
474     }
475 
476     /// @notice Returns a list of all Player IDs assigned to an address.
477     /// @param _owner The owner whose Players we are interested in.
478     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
479     ///  expensive (it walks the entire Player array looking for players belonging to owner),
480     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
481     ///  not contract-to-contract calls.
482     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
483         uint256 tokenCount = balanceOf(_owner);
484 
485         uint256[] memory result = new uint256[](tokenCount+commonPlayerCount);
486         uint256 resultIndex = 0;
487 
488         uint256 playerId;
489         for (playerId = 1; playerId <= commonPlayerCount; playerId++) {
490             result[resultIndex] = playerId;
491             resultIndex++;
492         }
493 
494         if (tokenCount == 0) {
495             return result;
496         } else {
497             uint256 totalPlayers = totalSupply();
498 
499             for (; playerId < totalPlayers; playerId++) {
500                 if (playerIndexToOwner[playerId] == _owner) {
501                     result[resultIndex] = playerId;
502                     resultIndex++;
503                 }
504             }
505 
506             return result;
507         }
508     }
509 }
510 
511 /// @title 
512 interface RandomPlayerInterface {
513     /// @dev simply a boolean to indicate this is the contract we expect to be
514     function isRandomPlayer() public pure returns (bool);
515 
516     /// @return a random player
517     function gen() public returns (uint256 typeId, uint256 attack, uint256 defense, uint256 stamina, uint256 xp, uint256 isKeeper, uint256 skillId);
518 }
519 
520 contract BSMinting is BSOwnership {
521         /// @dev The address of the sibling contract that is used to generate player
522     ///  genetic combination algorithm.
523     using SafeMath for uint256;
524     RandomPlayerInterface public randomPlayer;
525 
526     uint256 constant public exchangePlayerTokenCount = 100 * (10**18);
527 
528     uint256 constant promoCreationPlayerLimit = 50000;
529 
530     uint256 public promoCreationPlayerCount;
531 
532     uint256 public promoEndTime;
533     mapping (address => uint256) public userToken2PlayerCount;
534 
535     event ExchangePlayer(address indexed user, uint256 count);
536 
537     function BSMinting() public {
538         promoEndTime = now + 2 weeks;
539     }
540 
541     function setPromoEndTime(uint256 _endTime) external onlyCOO {
542         promoEndTime = _endTime;
543     }
544 
545     /// @dev Update the address of the generator contract, can only be called by the CEO.
546     /// @param _address An address of a contract instance to be used from this point forward.
547     function setRandomPlayerAddress(address _address) external onlyCEO {
548         RandomPlayerInterface candidateContract = RandomPlayerInterface(_address);
549 
550         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
551         require(candidateContract.isRandomPlayer());
552 
553         // Set the new contract address
554         randomPlayer = candidateContract;
555     }
556 
557     function createPromoPlayer(address _owner, uint256 _typeId, uint256 _attack, uint256 _defense,
558             uint256 _stamina, uint256 _xp, uint256 _isKeeper, uint256 _skillId) external onlyCOO {
559         address sender = _owner;
560         if (sender == address(0)) {
561              sender = cooAddress;
562         }
563 
564         require(promoCreationPlayerCount < promoCreationPlayerLimit);
565         promoCreationPlayerCount++;
566         _createPlayer(sender, _typeId, _attack, _defense, _stamina, _xp, _isKeeper, _skillId);
567     }
568 
569     function token2Player(address _sender, uint256 _count) public whenNotPaused returns (bool) {
570         require(msg.sender == address(joyTokenContract) || msg.sender == _sender);
571         require(_count > 0);
572         uint256 totalTokenCount = _count.mul(exchangePlayerTokenCount);
573         require(joyTokenContract.transferFrom(_sender, cfoAddress, totalTokenCount));
574 
575         uint256 typeId;
576         uint256 attack;
577         uint256 defense;
578         uint256 stamina;
579         uint256 xp;
580         uint256 isKeeper;
581         uint256 skillId;
582         for (uint256 i = 0; i < _count; i++) {
583             (typeId, attack, defense, stamina, xp, isKeeper, skillId) = randomPlayer.gen();
584             _createPlayer(_sender, typeId, attack, defense, stamina, xp, isKeeper, skillId);
585         }
586 
587         if (now < promoEndTime) {
588             _onPromo(_sender, _count);
589         }
590         ExchangePlayer(_sender, _count);
591         return true;
592     }
593 
594     function _onPromo(address _sender, uint256 _count) internal {
595         uint256 userCount = userToken2PlayerCount[_sender];
596         uint256 userCountNow = userCount.add(_count);
597         userToken2PlayerCount[_sender] = userCountNow;
598         if (userCount == 0) {
599             _createPlayer(_sender, 14, 88, 35, 58, 1, 0, 56);
600         }
601         if (userCount < 5 && userCountNow >= 5) {
602             _createPlayer(_sender, 13, 42, 80, 81, 1, 0, 70);
603         }
604     }
605 
606     function createCommonPlayer() external onlyCOO returns (uint256)
607     {
608         require(players.length == 0);
609         players.length++;
610 
611         uint16 commonTypeId = 1;
612         address commonAdress = address(0);
613 
614         _createPlayer(commonAdress, commonTypeId++, 40, 12, 25, 1, 0, 0);
615         _createPlayer(commonAdress, commonTypeId++, 16, 32, 39, 3, 0, 0);
616         _createPlayer(commonAdress, commonTypeId++, 30, 35, 13, 3, 0, 0);
617         _createPlayer(commonAdress, commonTypeId++, 22, 30, 24, 5, 0, 0);
618         _createPlayer(commonAdress, commonTypeId++, 25, 14, 43, 3, 0, 0);
619         _createPlayer(commonAdress, commonTypeId++, 15, 40, 22, 5, 0, 0);
620         _createPlayer(commonAdress, commonTypeId++, 17, 39, 25, 3, 0, 0);
621         _createPlayer(commonAdress, commonTypeId++, 41, 22, 13, 3, 0, 0);
622         _createPlayer(commonAdress, commonTypeId++, 30, 31, 28, 1, 0, 0);
623         _createPlayer(commonAdress, commonTypeId++, 13, 45, 11, 3, 1, 0);
624 
625         require(commonPlayerCount+1 == players.length);
626         return commonPlayerCount;
627     }
628 }
629 
630 /// @title 
631 contract SaleClockAuctionInterface {
632     /// @dev simply a boolean to indicate this is the contract we expect to be
633     function isSaleClockAuction() public pure returns (bool);
634     function createAuction(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, address _seller) external;
635 }
636 
637 /// @title Handles creating auctions for sale and siring of players.
638 ///  This wrapper of ReverseAuction exists only so that users can create
639 ///  auctions with only one transaction.
640 contract BSAuction is BSMinting {
641 
642     /// @dev The address of the ClockAuction contract that handles sales of players. 
643     SaleClockAuctionInterface public saleAuction;
644 
645     /// @dev Sets the reference to the sale auction.
646     /// @param _address - Address of sale contract.
647     function setSaleAuctionAddress(address _address) public onlyCEO {
648         SaleClockAuctionInterface candidateContract = SaleClockAuctionInterface(_address);
649 
650         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
651         require(candidateContract.isSaleClockAuction());
652 
653         // Set the new contract address
654         saleAuction = candidateContract;
655     }
656 
657     /// @dev Put a player up for auction.
658     ///  Does some ownership trickery to create auctions in one tx.
659     function createSaleAuction(
660         uint256 _playerId,
661         uint256 _startingPrice,
662         uint256 _endingPrice,
663         uint256 _duration
664     )
665         public
666         whenNotPaused
667     {
668         // Auction contract checks input sizes
669         // If player is already on any auction, this will throw
670         // because it will be owned by the auction contract.
671         require(_owns(msg.sender, _playerId));
672         _approve(_playerId, saleAuction);
673         // Sale auction throws if inputs are invalid and clears
674         // transfer and sire approval after escrowing the player.
675         saleAuction.createAuction(
676             _playerId,
677             _startingPrice,
678             _endingPrice,
679             _duration,
680             msg.sender
681         );
682     }
683 }
684 
685 contract GlobalDefines {
686     uint8 constant TYPE_SKILL_ATTRI_ATTACK = 0;
687     uint8 constant TYPE_SKILL_ATTRI_DEFENSE = 1;
688     uint8 constant TYPE_SKILL_ATTRI_STAMINA = 2;
689     uint8 constant TYPE_SKILL_ATTRI_GOALKEEPER = 3;
690 }
691 
692 /// @title Interface for PlayerInterface
693 contract PlayerInterface {
694     function checkOwner(address _owner, uint32[11] _ids) public view returns (bool);
695     function queryPlayerType(uint32[11] _ids) public view returns (uint32[11] playerTypes);
696     function queryPlayer(uint32 _id) public view returns (uint16[8]);
697     function queryPlayerUnAwakeSkillIds(uint32[11] _playerIds) public view returns (uint16[11] playerUnAwakeSkillIds);
698     function tournamentResult(uint32[3][11][32] _playerAwakeSkills) public;
699 }
700 
701 contract BSCore is GlobalDefines, BSAuction, PlayerInterface {
702 
703     // This is the main BS contract.
704 
705     /// @notice Creates the main BS smart contract instance.
706     function BSCore() public {
707         // Starts paused.
708         paused = true;
709 
710         // the creator of the contract is the initial CEO
711         ceoAddress = msg.sender;
712 
713         // the creator of the contract is also the initial COO
714         cooAddress = msg.sender;
715     }
716 
717     /// @dev Sets the reference to the JOY token contract.
718     /// @param _address - Address of JOY token contract.
719     function setJOYTokenAddress(address _address) external onlyCOO {
720         // Set the new contract address
721         joyTokenContract = ERC827(_address);
722     }
723 
724     /// @dev Sets the reference to the Tournament token contract.
725     /// @param _address - Address of Tournament token contract.
726     function setTournamentAddress(address _address) external onlyCOO {
727         TournamentInterface candidateContract = TournamentInterface(_address);
728 
729         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
730         require(candidateContract.isTournament());
731 
732         // Set the new contract address
733         tournamentContract = candidateContract;
734     }
735 
736     function() external {
737         revert();
738     }
739 
740     function withdrawJOYTokens() external onlyCFO {
741         uint256 value = joyTokenContract.balanceOf(address(this));
742         joyTokenContract.transfer(cfoAddress, value);
743     }
744 
745     /// @notice Returns all the relevant information about a specific player.
746     /// @param _id The ID of the player of interest.
747     function getPlayer(uint256 _id)
748         external
749         view
750         returns (
751         uint256 typeId,
752         uint256 attack,
753         uint256 defense,
754         uint256 stamina,
755         uint256 xp,
756         uint256 isKeeper,
757         uint256 skillId,
758         uint256 isSkillOn
759     ) {
760         Player storage player = players[_id];
761 
762         typeId = uint256(player.typeId);
763         attack = uint256(player.attack);
764         defense = uint256(player.defense);
765         stamina = uint256(player.stamina);
766         xp = uint256(player.xp);
767         isKeeper = uint256(player.isKeeper);
768         skillId = uint256(player.skillId);
769         isSkillOn = uint256(player.isSkillOn);
770     }
771 
772     function checkOwner(address _owner, uint32[11] _ids) public view returns (bool) {
773         for (uint256 i = 0; i < _ids.length; i++) {
774             uint256 _id = _ids[i];
775             if ((_id <= 0 || _id > commonPlayerCount) && !_owns(_owner, _id)) {
776                 return false;
777             }
778         }
779         return true;
780     }
781 
782     function queryPlayerType(uint32[11] _ids) public view returns (uint32[11] playerTypes) {
783         for (uint256 i = 0; i < _ids.length; i++) {
784             uint256 _id = _ids[i];
785             Player storage player = players[_id];
786             playerTypes[i] = player.typeId;
787         }
788     }
789 
790     function queryPlayer(uint32 _id)
791         public
792         view
793         returns (
794         uint16[8]
795     ) {
796         Player storage player = players[_id];
797         return [player.typeId, player.attack, player.defense, player.stamina, player.xp, player.isKeeper, player.skillId, player.isSkillOn];
798     }
799 
800     function queryPlayerUnAwakeSkillIds(uint32[11] _playerIds)
801         public
802         view
803         returns (
804         uint16[11] playerUnAwakeSkillIds
805     ) {
806         for (uint256 i = 0; i < _playerIds.length; i++) {
807             Player storage player = players[_playerIds[i]];
808             if (player.skillId > 0 && player.isSkillOn == 0)
809             {
810                 playerUnAwakeSkillIds[i] = player.skillId;
811             }
812         }
813     }
814 
815     function tournamentResult(uint32[3][11][32] _playerAwakeSkills) public {
816         require(msg.sender == address(tournamentContract));
817 
818         for (uint8 i = 0; i < 32; i++) {
819             for (uint8 j = 0; j < 11; j++) {
820                 uint32 _id = _playerAwakeSkills[i][j][0];
821                 Player storage player = players[_id];
822                 if (player.skillId > 0 && player.isSkillOn == 0) {
823                     uint32 skillType = _playerAwakeSkills[i][j][1];
824                     uint8 skillAddAttri = uint8(_playerAwakeSkills[i][j][2]);
825 
826                     if (skillType == TYPE_SKILL_ATTRI_ATTACK) {
827                         player.attack += skillAddAttri;
828                         player.isSkillOn = 1;
829                     }
830 
831                     if (skillType == TYPE_SKILL_ATTRI_DEFENSE) {
832                         player.defense += skillAddAttri;
833                         player.isSkillOn = 1;
834                     }
835 
836                     if (skillType == TYPE_SKILL_ATTRI_STAMINA) {
837                         player.stamina += skillAddAttri;
838                         player.isSkillOn = 1;
839                     }
840 
841                     if (skillType == TYPE_SKILL_ATTRI_GOALKEEPER && player.isKeeper == 0) {
842                         player.isKeeper = 1;
843                         player.isSkillOn = 1;
844                     }
845                 }
846             }
847         }
848     }
849 }