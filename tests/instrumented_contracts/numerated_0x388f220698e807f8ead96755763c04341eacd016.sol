1 pragma solidity ^0.4.25;
2 
3 /// @title A facet of CSportsCore that holds all important constants and modifiers
4 /// @author CryptoSports, Inc. (https://cryptosports.team))
5 /// @dev See the CSportsCore contract documentation to understand how the various CSports contract facets are arranged.
6 contract CSportsConstants {
7 
8     /// @dev The maximum # of marketing tokens that can ever be created
9     /// by the commissioner.
10     uint16 public MAX_MARKETING_TOKENS = 2500;
11 
12     /// @dev The starting price for commissioner auctions (if the average
13     ///   of the last 2 is less than this, we will use this value)
14     ///   A finney is 1/1000 of an ether.
15     uint256 public COMMISSIONER_AUCTION_FLOOR_PRICE = 5 finney; // 5 finney for production, 15 for script testing and 1 finney for Rinkeby
16 
17     /// @dev The duration of commissioner auctions
18     uint256 public COMMISSIONER_AUCTION_DURATION = 14 days; // 30 days for testing;
19 
20     /// @dev Number of seconds in a week
21     uint32 constant WEEK_SECS = 1 weeks;
22 
23 }
24 
25 /// @title A facet of CSportsCore that manages an individual's authorized role against access privileges.
26 /// @author CryptoSports, Inc. (https://cryptosports.team))
27 /// @dev See the CSportsCore contract documentation to understand how the various CSports contract facets are arranged.
28 contract CSportsAuth is CSportsConstants {
29     // This facet controls access control for CryptoSports. There are four roles managed here:
30     //
31     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
32     //         contracts. It is also the only role that can unpause the smart contract. It is initially
33     //         set to the address that created the smart contract in the CSportsCore constructor.
34     //
35     //     - The CFO: The CFO can withdraw funds from CSportsCore and its auction contracts.
36     //
37     //     - The COO: The COO can perform administrative functions.
38     //
39     //     - The Commisioner can perform "oracle" functions like adding new real world players,
40     //       setting players active/inactive, and scoring contests.
41     //
42 
43     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
44     event ContractUpgrade(address newContract);
45 
46     /// The addresses of the accounts (or contracts) that can execute actions within each roles.
47     address public ceoAddress;
48     address public cfoAddress;
49     address public cooAddress;
50     address public commissionerAddress;
51 
52     /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
53     bool public paused = false;
54 
55     /// @dev Flag that identifies whether or not we are in development and should allow development
56     /// only functions to be called.
57     bool public isDevelopment = true;
58 
59     /// @dev Access modifier to allow access to development mode functions
60     modifier onlyUnderDevelopment() {
61       require(isDevelopment == true);
62       _;
63     }
64 
65     /// @dev Access modifier for CEO-only functionality
66     modifier onlyCEO() {
67         require(msg.sender == ceoAddress);
68         _;
69     }
70 
71     /// @dev Access modifier for CFO-only functionality
72     modifier onlyCFO() {
73         require(msg.sender == cfoAddress);
74         _;
75     }
76 
77     /// @dev Access modifier for COO-only functionality
78     modifier onlyCOO() {
79         require(msg.sender == cooAddress);
80         _;
81     }
82 
83     /// @dev Access modifier for Commissioner-only functionality
84     modifier onlyCommissioner() {
85         require(msg.sender == commissionerAddress);
86         _;
87     }
88 
89     /// @dev Requires any one of the C level addresses
90     modifier onlyCLevel() {
91         require(
92             msg.sender == cooAddress ||
93             msg.sender == ceoAddress ||
94             msg.sender == cfoAddress ||
95             msg.sender == commissionerAddress
96         );
97         _;
98     }
99 
100     /// @dev prevents contracts from hitting the method
101     modifier notContract() {
102         address _addr = msg.sender;
103         uint256 _codeLength;
104 
105         assembly {_codeLength := extcodesize(_addr)}
106         require(_codeLength == 0);
107         _;
108     }
109 
110     /// @dev One way switch to set the contract into prodution mode. This is one
111     /// way in that the contract can never be set back into development mode. Calling
112     /// this function will block all future calls to functions that are meant for
113     /// access only while we are under development. It will also enable more strict
114     /// additional checking on various parameters and settings.
115     function setProduction() public onlyCEO onlyUnderDevelopment {
116       isDevelopment = false;
117     }
118 
119     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
120     /// @param _newCEO The address of the new CEO
121     function setCEO(address _newCEO) public onlyCEO {
122         require(_newCEO != address(0));
123         ceoAddress = _newCEO;
124     }
125 
126     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
127     /// @param _newCFO The address of the new CFO
128     function setCFO(address _newCFO) public onlyCEO {
129         require(_newCFO != address(0));
130 
131         cfoAddress = _newCFO;
132     }
133 
134     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
135     /// @param _newCOO The address of the new COO
136     function setCOO(address _newCOO) public onlyCEO {
137         require(_newCOO != address(0));
138 
139         cooAddress = _newCOO;
140     }
141 
142     /// @dev Assigns a new address to act as the Commissioner. Only available to the current CEO.
143     /// @param _newCommissioner The address of the new COO
144     function setCommissioner(address _newCommissioner) public onlyCEO {
145         require(_newCommissioner != address(0));
146 
147         commissionerAddress = _newCommissioner;
148     }
149 
150     /// @dev Assigns all C-Level addresses
151     /// @param _ceo CEO address
152     /// @param _cfo CFO address
153     /// @param _coo COO address
154     /// @param _commish Commissioner address
155     function setCLevelAddresses(address _ceo, address _cfo, address _coo, address _commish) public onlyCEO {
156         require(_ceo != address(0));
157         require(_cfo != address(0));
158         require(_coo != address(0));
159         require(_commish != address(0));
160         ceoAddress = _ceo;
161         cfoAddress = _cfo;
162         cooAddress = _coo;
163         commissionerAddress = _commish;
164     }
165 
166     /// @dev Transfers the balance of this contract to the CFO
167     function withdrawBalance() external onlyCFO {
168         cfoAddress.transfer(address(this).balance);
169     }
170 
171     /*** Pausable functionality adapted from OpenZeppelin ***/
172 
173     /// @dev Modifier to allow actions only when the contract IS NOT paused
174     modifier whenNotPaused() {
175         require(!paused);
176         _;
177     }
178 
179     /// @dev Modifier to allow actions only when the contract IS paused
180     modifier whenPaused {
181         require(paused);
182         _;
183     }
184 
185     /// @dev Called by any "C-level" role to pause the contract. Used only when
186     ///  a bug or exploit is detected and we need to limit damage.
187     function pause() public onlyCLevel whenNotPaused {
188         paused = true;
189     }
190 
191     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
192     ///  one reason we may pause the contract is when CFO or COO accounts are
193     ///  compromised.
194     function unpause() public onlyCEO whenPaused {
195         paused = false;
196     }
197 }
198 
199 /// @dev Interface required by league roster contract to access
200 /// the mintPlayers(...) function
201 interface CSportsRosterInterface {
202 
203     /// @dev Called by core contract as a sanity check
204     function isLeagueRosterContract() external pure returns (bool);
205 
206     /// @dev Called to indicate that a commissioner auction has completed
207     function commissionerAuctionComplete(uint32 _rosterIndex, uint128 _price) external;
208 
209     /// @dev Called to indicate that a commissioner auction was canceled
210     function commissionerAuctionCancelled(uint32 _rosterIndex) external view;
211 
212     /// @dev Returns the metadata for a specific real world player token
213     function getMetadata(uint128 _md5Token) external view returns (string);
214 
215     /// @dev Called to return a roster index given the MD5
216     function getRealWorldPlayerRosterIndex(uint128 _md5Token) external view returns (uint128);
217 
218     /// @dev Returns a player structure given its index
219     function realWorldPlayerFromIndex(uint128 idx) external view returns (uint128 md5Token, uint128 prevCommissionerSalePrice, uint64 lastMintedTime, uint32 mintedCount, bool hasActiveCommissionerAuction, bool mintingEnabled);
220 
221     /// @dev Called to update a real world player entry - only used dureing development
222     function updateRealWorldPlayer(uint32 _rosterIndex, uint128 _prevCommissionerSalePrice, uint64 _lastMintedTime, uint32 _mintedCount, bool _hasActiveCommissionerAuction, bool _mintingEnabled) external;
223 
224 }
225 
226 /// @dev This is the data structure that holds a roster player in the CSportsLeagueRoster
227 /// contract. Also referenced by CSportsCore.
228 /// @author CryptoSports, Inc. (http://cryptosports.team)
229 contract CSportsRosterPlayer {
230 
231     struct RealWorldPlayer {
232 
233         // The player's certified identification. This is the md5 hash of
234         // {player's last name}-{player's first name}-{player's birthday in YYYY-MM-DD format}-{serial number}
235         // where the serial number is usually 0, but gives us an ability to deal with making
236         // sure all MD5s are unique.
237         uint128 md5Token;
238 
239         // Stores the average sale price of the most recent 2 commissioner sales
240         uint128 prevCommissionerSalePrice;
241 
242         // The last time this real world player was minted.
243         uint64 lastMintedTime;
244 
245         // The number of PlayerTokens minted for this real world player
246         uint32 mintedCount;
247 
248         // When true, there is an active auction for this player owned by
249         // the commissioner (indicating a gen0 minting auction is in progress)
250         bool hasActiveCommissionerAuction;
251 
252         // Indicates this real world player can be actively minted
253         bool mintingEnabled;
254 
255         // Any metadata we want to attach to this player (in JSON format)
256         string metadata;
257 
258     }
259 
260 }
261 
262 /// @title CSportsTeam Interface
263 /// @dev This interface defines methods required by the CSportsContestCore
264 ///   in implementing a contest.
265 /// @author CryptoSports
266 contract CSportsTeam {
267 
268     bool public isTeamContract;
269 
270     /// @dev Define team events
271     event TeamCreated(uint256 teamId, address owner);
272     event TeamUpdated(uint256 teamId);
273     event TeamReleased(uint256 teamId);
274     event TeamScored(uint256 teamId, int32 score, uint32 place);
275     event TeamPaid(uint256 teamId);
276 
277     function setCoreContractAddress(address _address) public;
278     function setLeagueRosterContractAddress(address _address) public;
279     function setContestContractAddress(address _address) public;
280     function createTeam(address _owner, uint32[] _tokenIds) public returns (uint32);
281     function updateTeam(address _owner, uint32 _teamId, uint8[] _indices, uint32[] _tokenIds) public;
282     function releaseTeam(uint32 _teamId) public;
283     function getTeamOwner(uint32 _teamId) public view returns (address);
284     function scoreTeams(uint32[] _teamIds, int32[] _scores, uint32[] _places) public;
285     function getScore(uint32 _teamId) public view returns (int32);
286     function getPlace(uint32 _teamId) public view returns (uint32);
287     function ownsPlayerTokens(uint32 _teamId) public view returns (bool);
288     function refunded(uint32 _teamId) public;
289     function tokenIdsForTeam(uint32 _teamId) public view returns (uint32, uint32[50]);
290     function getTeam(uint32 _teamId) public view returns (
291         address _owner,
292         int32 _score,
293         uint32 _place,
294         bool _holdsEntryFee,
295         bool _ownsPlayerTokens);
296 }
297 
298 /// @title Base contract for CryptoSports. Holds all common structs, events and base variables.
299 /// @author CryptoSports, Inc. (http://cryptosports.team)
300 /// @dev See the CSportsCore contract documentation to understand how the various contract facets are arranged.
301 contract CSportsBase is CSportsAuth, CSportsRosterPlayer {
302 
303     /// @dev This emits when ownership of any NFT changes by any mechanism.
304     ///  This event emits when NFTs are created (`from` == 0) and destroyed
305     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
306     ///  may be created and assigned without emitting Transfer. At the time of
307     ///  any transfer, the approved address for that NFT (if any) is reset to none.
308     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
309 
310     /// @dev This emits when the approved address for an NFT is changed or
311     ///  reaffirmed. The zero address indicates there is no approved address.
312     ///  When a Transfer event emits, this also indicates that the approved
313     ///  address for that NFT (if any) is reset to none.
314     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
315 
316     /// @dev This emits when an operator is enabled or disabled for an owner.
317     ///  The operator can manage all NFTs of the owner.
318     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
319 
320     /// @dev This emits when a commissioner auction is successfully closed
321     event CommissionerAuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
322 
323     /// @dev This emits when a commissioner auction is canceled
324     event CommissionerAuctionCanceled(uint256 tokenId);
325 
326     /******************/
327     /*** DATA TYPES ***/
328     /******************/
329 
330     /// @dev The main player token structure. Every released player in the League
331     ///  is represented by a single instance of this structure.
332     struct PlayerToken {
333 
334       // @dev ID of the real world player this token represents. We can only have
335       // a max of 4,294,967,295 real world players, which seems to be enough for
336       // a while (haha)
337       uint32 realWorldPlayerId;
338 
339       // @dev Serial number indicating the number of PlayerToken(s) for this
340       //  same realWorldPlayerId existed at the time this token was minted.
341       uint32 serialNumber;
342 
343       // The timestamp from the block when this player token was minted.
344       uint64 mintedTime;
345 
346       // The most recent sale price of the player token in an auction
347       uint128 mostRecentPrice;
348 
349     }
350 
351     /**************************/
352     /*** MAPPINGS (STORAGE) ***/
353     /**************************/
354 
355     /// @dev A mapping from a PlayerToken ID to the address that owns it. All
356     /// PlayerTokens have an owner (newly minted PlayerTokens are owned by
357     /// the core contract).
358     mapping (uint256 => address) public playerTokenToOwner;
359 
360     /// @dev Maps a PlayerToken ID to an address approved to take ownership.
361     mapping (uint256 => address) public playerTokenToApproved;
362 
363     // @dev A mapping to a given address' tokens
364     mapping(address => uint32[]) public ownedTokens;
365 
366     // @dev A mapping that relates a token id to an index into the
367     // ownedTokens[currentOwner] array.
368     mapping(uint32 => uint32) tokenToOwnedTokensIndex;
369 
370     /// @dev Maps operators
371     mapping(address => mapping(address => bool)) operators;
372 
373     // This mapping and corresponding uint16 represent marketing tokens
374     // that can be created by the commissioner (up to remainingMarketingTokens)
375     // and then given to third parties in the form of 4 words that sha256
376     // hash into the key for the mapping.
377     //
378     // Maps uint256(keccak256) => leagueRosterPlayerMD5
379     uint16 public remainingMarketingTokens = MAX_MARKETING_TOKENS;
380     mapping (uint256 => uint128) marketingTokens;
381 
382     /***************/
383     /*** STORAGE ***/
384     /***************/
385 
386     /// @dev Instance of our CSportsLeagueRoster contract. Can be set by
387     ///   the CEO only once because this immutable tie to the league roster
388     ///   is what relates a playerToken to a real world player. If we could
389     ///   update the leagueRosterContract, we could in effect de-value the
390     ///   ownership of a playerToken by switching the real world player it
391     ///   represents.
392     CSportsRosterInterface public leagueRosterContract;
393 
394     /// @dev Addresses of team contract that is authorized to hold player
395     ///   tokens for contests.
396     CSportsTeam public teamContract;
397 
398     /// @dev An array containing all PlayerTokens in existence.
399     PlayerToken[] public playerTokens;
400 
401     /************************************/
402     /*** RESTRICTED C-LEVEL FUNCTIONS ***/
403     /************************************/
404 
405     /// @dev Sets the reference to the CSportsLeagueRoster contract.
406     /// @param _address - Address of CSportsLeagueRoster contract.
407     function setLeagueRosterContractAddress(address _address) public onlyCEO {
408       // This method may only be called once to guarantee the immutable
409       // nature of owning a real world player.
410       if (!isDevelopment) {
411         require(leagueRosterContract == address(0));
412       }
413 
414       CSportsRosterInterface candidateContract = CSportsRosterInterface(_address);
415       // NOTE: verify that a contract is what we expect (not foolproof, just
416       // a sanity check)
417       require(candidateContract.isLeagueRosterContract());
418       // Set the new contract address
419       leagueRosterContract = candidateContract;
420     }
421 
422     /// @dev Adds an authorized team contract that can hold player tokens
423     ///   on behalf of a contest, and will return them to the original
424     ///   owner when the contest is complete (or if entry is canceled by
425     ///   the original owner, or if the contest is canceled).
426     function setTeamContractAddress(address _address) public onlyCEO {
427       CSportsTeam candidateContract = CSportsTeam(_address);
428       // NOTE: verify that a contract is what we expect (not foolproof, just
429       // a sanity check)
430       require(candidateContract.isTeamContract());
431       // Set the new contract address
432       teamContract = candidateContract;
433     }
434 
435     /**************************/
436     /*** INTERNAL FUNCTIONS ***/
437     /**************************/
438 
439     /// @dev Identifies whether or not the addressToTest is a contract or not
440     /// @param addressToTest The address we are interested in
441     function _isContract(address addressToTest) internal view returns (bool) {
442         uint size;
443         assembly {
444             size := extcodesize(addressToTest)
445         }
446         return (size > 0);
447     }
448 
449     /// @dev Returns TRUE if the token exists
450     /// @param _tokenId ID to check
451     function _tokenExists(uint256 _tokenId) internal view returns (bool) {
452         return (_tokenId < playerTokens.length);
453     }
454 
455     /// @dev An internal method that mints a new playerToken and stores it
456     ///   in the playerTokens array.
457     /// @param _realWorldPlayerId ID of the real world player to mint
458     /// @param _serialNumber - Indicates the number of playerTokens for _realWorldPlayerId
459     ///   that exist prior to this to-be-minted playerToken.
460     /// @param _owner - The owner of this newly minted playerToken
461     function _mintPlayer(uint32 _realWorldPlayerId, uint32 _serialNumber, address _owner) internal returns (uint32) {
462         // We are careful here to make sure the calling contract keeps within
463         // our structure's size constraints. Highly unlikely we would ever
464         // get to a point where these constraints would be a problem.
465         require(_realWorldPlayerId < 4294967295);
466         require(_serialNumber < 4294967295);
467 
468         PlayerToken memory _player = PlayerToken({
469           realWorldPlayerId: _realWorldPlayerId,
470           serialNumber: _serialNumber,
471           mintedTime: uint64(now),
472           mostRecentPrice: 0
473         });
474 
475         uint256 newPlayerTokenId = playerTokens.push(_player) - 1;
476 
477         // It's probably never going to happen, 4 billion playerToken(s) is A LOT, but
478         // let's just be 100% sure we never let this happen.
479         require(newPlayerTokenId < 4294967295);
480 
481         // This will assign ownership, and also emit the Transfer event as
482         // per ERC721 draft
483         _transfer(0, _owner, newPlayerTokenId);
484 
485         return uint32(newPlayerTokenId);
486     }
487 
488     /// @dev Removes a token (specified by ID) from ownedTokens and
489     /// tokenToOwnedTokensIndex mappings for a given address.
490     /// @param _from Address to remove from
491     /// @param _tokenId ID of token to remove
492     function _removeTokenFrom(address _from, uint256 _tokenId) internal {
493 
494       // Grab the index into the _from owner's ownedTokens array
495       uint32 fromIndex = tokenToOwnedTokensIndex[uint32(_tokenId)];
496 
497       // Remove the _tokenId from ownedTokens[_from] array
498       uint lastIndex = ownedTokens[_from].length - 1;
499       uint32 lastToken = ownedTokens[_from][lastIndex];
500 
501       // Swap the last token into the fromIndex position (which is _tokenId's
502       // location in the ownedTokens array) and shorten the array
503       ownedTokens[_from][fromIndex] = lastToken;
504       ownedTokens[_from].length--;
505 
506       // Since we moved lastToken, we need to update its
507       // entry in the tokenToOwnedTokensIndex
508       tokenToOwnedTokensIndex[lastToken] = fromIndex;
509 
510       // _tokenId is no longer mapped
511       tokenToOwnedTokensIndex[uint32(_tokenId)] = 0;
512 
513     }
514 
515     /// @dev Adds a token (specified by ID) to ownedTokens and
516     /// tokenToOwnedTokensIndex mappings for a given address.
517     /// @param _to Address to add to
518     /// @param _tokenId ID of token to remove
519     function _addTokenTo(address _to, uint256 _tokenId) internal {
520       uint32 toIndex = uint32(ownedTokens[_to].push(uint32(_tokenId))) - 1;
521       tokenToOwnedTokensIndex[uint32(_tokenId)] = toIndex;
522     }
523 
524     /// @dev Assigns ownership of a specific PlayerToken to an address.
525     /// @param _from - Address of who this transfer is from
526     /// @param _to - Address of who to tranfer to
527     /// @param _tokenId - The ID of the playerToken to transfer
528     function _transfer(address _from, address _to, uint256 _tokenId) internal {
529 
530         // transfer ownership
531         playerTokenToOwner[_tokenId] = _to;
532 
533         // When minting brand new PlayerTokens, the _from is 0x0, but we don't deal with
534         // owned tokens for the 0x0 address.
535         if (_from != address(0)) {
536 
537             // Remove the _tokenId from ownedTokens[_from] array (remove first because
538             // this method will zero out the tokenToOwnedTokensIndex[_tokenId], which would
539             // stomp on the _addTokenTo setting of this value)
540             _removeTokenFrom(_from, _tokenId);
541 
542             // Clear our approved mapping for this token
543             delete playerTokenToApproved[_tokenId];
544         }
545 
546         // Now add the token to the _to address' ownership structures
547         _addTokenTo(_to, _tokenId);
548 
549         // Emit the transfer event.
550         emit Transfer(_from, _to, _tokenId);
551     }
552 
553     /// @dev Converts a uint to its string equivalent
554     /// @param v uint to convert
555     function uintToString(uint v) internal pure returns (string str) {
556       bytes32 b32 = uintToBytes32(v);
557       str = bytes32ToString(b32);
558     }
559 
560     /// @dev Converts a uint to a bytes32
561     /// @param v uint to convert
562     function uintToBytes32(uint v) internal pure returns (bytes32 ret) {
563         if (v == 0) {
564             ret = '0';
565         }
566         else {
567             while (v > 0) {
568                 ret = bytes32(uint(ret) / (2 ** 8));
569                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
570                 v /= 10;
571             }
572         }
573         return ret;
574     }
575 
576     /// @dev Converts bytes32 to a string
577     /// @param data bytes32 to convert
578     function bytes32ToString (bytes32 data) internal pure returns (string) {
579 
580         uint count = 0;
581         bytes memory bytesString = new bytes(32); //  = new bytes[]; //(32);
582         for (uint j=0; j<32; j++) {
583             byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
584             if (char != 0) {
585                 bytesString[j] = char;
586                 count++;
587             } else {
588               break;
589             }
590         }
591 
592         bytes memory s = new bytes(count);
593         for (j = 0; j < count; j++) {
594             s[j] = bytesString[j];
595         }
596         return string(s);
597 
598     }
599 
600 }
601 
602 /// @title ERC-721 Non-Fungible Token Standard
603 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
604 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
605 interface ERC721 /* is ERC165 */ {
606     /// @dev This emits when ownership of any NFT changes by any mechanism.
607     ///  This event emits when NFTs are created (`from` == 0) and destroyed
608     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
609     ///  may be created and assigned without emitting Transfer. At the time of
610     ///  any transfer, the approved address for that NFT (if any) is reset to none.
611     ///
612     /// MOVED THIS TO CSportsBase because of how class structure is derived.
613     ///
614     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
615 
616     /// @dev This emits when the approved address for an NFT is changed or
617     ///  reaffirmed. The zero address indicates there is no approved address.
618     ///  When a Transfer event emits, this also indicates that the approved
619     ///  address for that NFT (if any) is reset to none.
620     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
621 
622     /// @dev This emits when an operator is enabled or disabled for an owner.
623     ///  The operator can manage all NFTs of the owner.
624     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
625 
626     /// @notice Count all NFTs assigned to an owner
627     /// @dev NFTs assigned to the zero address are considered invalid, and this
628     ///  function throws for queries about the zero address.
629     /// @param _owner An address for whom to query the balance
630     /// @return The number of NFTs owned by `_owner`, possibly zero
631     function balanceOf(address _owner) external view returns (uint256);
632 
633     /// @notice Find the owner of an NFT
634     /// @dev NFTs assigned to zero address are considered invalid, and queries
635     ///  about them do throw.
636     /// @param _tokenId The identifier for an NFT
637     /// @return The address of the owner of the NFT
638     function ownerOf(uint256 _tokenId) external view returns (address);
639 
640     /// @notice Transfers the ownership of an NFT from one address to another address
641     /// @dev Throws unless `msg.sender` is the current owner, an authorized
642     ///  operator, or the approved address for this NFT. Throws if `_from` is
643     ///  not the current owner. Throws if `_to` is the zero address. Throws if
644     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
645     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
646     ///  `onERC721Received` on `_to` and throws if the return value is not
647     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
648     /// @param _from The current owner of the NFT
649     /// @param _to The new owner
650     /// @param _tokenId The NFT to transfer
651     /// @param data Additional data with no specified format, sent in call to `_to`
652     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
653 
654     /// @notice Transfers the ownership of an NFT from one address to another address
655     /// @dev This works identically to the other function with an extra data parameter,
656     ///  except this function just sets data to "".
657     /// @param _from The current owner of the NFT
658     /// @param _to The new owner
659     /// @param _tokenId The NFT to transfer
660     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
661 
662     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
663     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
664     ///  THEY MAY BE PERMANENTLY LOST
665     /// @dev Throws unless `msg.sender` is the current owner, an authorized
666     ///  operator, or the approved address for this NFT. Throws if `_from` is
667     ///  not the current owner. Throws if `_to` is the zero address. Throws if
668     ///  `_tokenId` is not a valid NFT.
669     /// @param _from The current owner of the NFT
670     /// @param _to The new owner
671     /// @param _tokenId The NFT to transfer
672     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
673 
674     /// @notice Change or reaffirm the approved address for an NFT
675     /// @dev The zero address indicates there is no approved address.
676     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
677     ///  operator of the current owner.
678     /// @param _approved The new approved NFT controller
679     /// @param _tokenId The NFT to approve
680     function approve(address _approved, uint256 _tokenId) external payable;
681 
682     /// @notice Enable or disable approval for a third party ("operator") to manage
683     ///  all of `msg.sender`'s assets
684     /// @dev Emits the ApprovalForAll event. The contract MUST allow
685     ///  multiple operators per owner.
686     /// @param _operator Address to add to the set of authorized operators
687     /// @param _approved True if the operator is approved, false to revoke approval
688     function setApprovalForAll(address _operator, bool _approved) external;
689 
690     /// @notice Get the approved address for a single NFT
691     /// @dev Throws if `_tokenId` is not a valid NFT.
692     /// @param _tokenId The NFT to find the approved address for
693     /// @return The approved address for this NFT, or the zero address if there is none
694     function getApproved(uint256 _tokenId) external view returns (address);
695 
696     /// @notice Query if an address is an authorized operator for another address
697     /// @param _owner The address that owns the NFTs
698     /// @param _operator The address that acts on behalf of the owner
699     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
700     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
701 }
702 
703 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
704 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
705 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
706 interface ERC721Metadata /* is ERC721 */ {
707     /// @notice A descriptive name for a collection of NFTs in this contract
708     function name() external view returns (string _name);
709 
710     /// @notice An abbreviated name for NFTs in this contract
711     function symbol() external view returns (string _symbol);
712 
713     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
714     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
715     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
716     ///  Metadata JSON Schema".
717     function tokenURI(uint256 _tokenId) external view returns (string);
718 }
719 
720 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
721 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
722 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
723 interface ERC721Enumerable /* is ERC721 */ {
724     /// @notice Count NFTs tracked by this contract
725     /// @return A count of valid NFTs tracked by this contract, where each one of
726     ///  them has an assigned and queryable owner not equal to the zero address
727     function totalSupply() external view returns (uint256);
728 
729     /// @notice Enumerate valid NFTs
730     /// @dev Throws if `_index` >= `totalSupply()`.
731     /// @param _index A counter less than `totalSupply()`
732     /// @return The token identifier for the `_index`th NFT,
733     ///  (sort order not specified)
734     function tokenByIndex(uint256 _index) external view returns (uint256);
735 
736     /// @notice Enumerate NFTs assigned to an owner
737     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
738     ///  `_owner` is the zero address, representing invalid NFTs.
739     /// @param _owner An address where we are interested in NFTs owned by them
740     /// @param _index A counter less than `balanceOf(_owner)`
741     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
742     ///   (sort order not specified)
743     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
744 }
745 
746 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
747 interface ERC721TokenReceiver {
748     /// @notice Handle the receipt of an NFT
749     /// @dev The ERC721 smart contract calls this function on the recipient
750     ///  after a `transfer`. This function MAY throw to revert and reject the
751     ///  transfer. Return of other than the magic value MUST result in the
752     ///  transaction being reverted.
753     ///  Note: the contract address is always the message sender.
754     /// @param _operator The address which called `safeTransferFrom` function
755     /// @param _from The address which previously owned the token
756     /// @param _tokenId The NFT identifier which is being transferred
757     /// @param _data Additional data with no specified format
758     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
759     ///  unless throwing
760     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
761 }
762 
763 interface ERC165 {
764     /// @notice Query if a contract implements an interface
765     /// @param interfaceID The interface identifier, as specified in ERC-165
766     /// @dev Interface identification is specified in ERC-165. This function
767     ///  uses less than 30,000 gas.
768     /// @return `true` if the contract implements `interfaceID` and
769     ///  `interfaceID` is not 0xffffffff, `false` otherwise
770     function supportsInterface(bytes4 interfaceID) external view returns (bool);
771 }
772 
773 /// @title The facet of the CSports core contract that manages ownership, ERC-721 compliant.
774 /// @author CryptoSports, Inc. (http://cryptosports.team)
775 /// @dev Ref: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md#specification
776 /// See the CSportsCore contract documentation to understand how the various contract facets are arranged.
777 contract CSportsOwnership is CSportsBase {
778 
779   /// @notice These are set in the contract constructor at deployment time
780   string _name;
781   string _symbol;
782   string _tokenURI;
783 
784   // bool public implementsERC721 = true;
785   //
786   function implementsERC721() public pure returns (bool)
787   {
788       return true;
789   }
790 
791   /// @notice A descriptive name for a collection of NFTs in this contract
792   function name() external view returns (string) {
793     return _name;
794   }
795 
796   /// @notice An abbreviated name for NFTs in this contract
797   function symbol() external view returns (string) {
798     return _symbol;
799   }
800 
801   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
802   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
803   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
804   ///  Metadata JSON Schema".
805   function tokenURI(uint256 _tokenId) external view returns (string ret) {
806     string memory tokenIdAsString = uintToString(uint(_tokenId));
807     ret = string (abi.encodePacked(_tokenURI, tokenIdAsString, "/"));
808   }
809 
810   /// @notice Find the owner of an NFT
811   /// @dev NFTs assigned to zero address are considered invalid, and queries
812   ///  about them do throw.
813   /// @param _tokenId The identifier for an NFT
814   /// @return The address of the owner of the NFT
815   function ownerOf(uint256 _tokenId)
816       public
817       view
818       returns (address owner)
819   {
820       owner = playerTokenToOwner[_tokenId];
821       require(owner != address(0));
822   }
823 
824   /// @notice Count all NFTs assigned to an owner
825   /// @dev NFTs assigned to the zero address are considered invalid, and this
826   ///  function throws for queries about the zero address.
827   /// @param _owner An address for whom to query the balance
828   /// @return The number of NFTs owned by `_owner`, possibly zero
829   function balanceOf(address _owner) public view returns (uint256 count) {
830       // I am not a big fan of  referencing a property on an array element
831       // that may not exist. But if it does not exist, Solidity will return 0
832       // which is right.
833       return ownedTokens[_owner].length;
834   }
835 
836   /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
837   ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
838   ///  THEY MAY BE PERMANENTLY LOST
839   /// @dev Throws unless `msg.sender` is the current owner, an authorized
840   ///  operator, or the approved address for this NFT. Throws if `_from` is
841   ///  not the current owner. Throws if `_to` is the zero address. Throws if
842   ///  `_tokenId` is not a valid NFT.
843   /// @param _from The current owner of the NFT
844   /// @param _to The new owner
845   /// @param _tokenId The NFT to transfer
846   function transferFrom(
847       address _from,
848       address _to,
849       uint256 _tokenId
850   )
851       public
852       whenNotPaused
853   {
854       require(_to != address(0));
855       require (_tokenExists(_tokenId));
856 
857       // Check for approval and valid ownership
858       require(_approvedFor(_to, _tokenId));
859       require(_owns(_from, _tokenId));
860 
861       // Validate the sender
862       require(_owns(msg.sender, _tokenId) || // sender owns the token
863              (msg.sender == playerTokenToApproved[_tokenId]) || // sender is the approved address
864              operators[_from][msg.sender]); // sender is an authorized operator for this token
865 
866       // Reassign ownership (also clears pending approvals and emits Transfer event).
867       _transfer(_from, _to, _tokenId);
868   }
869 
870   /// @notice Transfer ownership of a batch of NFTs -- THE CALLER IS RESPONSIBLE
871   ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
872   ///  THEY MAY BE PERMANENTLY LOST
873   /// @dev Throws unless `msg.sender` is the current owner, an authorized
874   ///  operator, or the approved address for all NFTs. Throws if `_from` is
875   ///  not the current owner. Throws if `_to` is the zero address. Throws if
876   ///  any `_tokenId` is not a valid NFT.
877   /// @param _from - Current owner of the token being authorized for transfer
878   /// @param _to - Address we are transferring to
879   /// @param _tokenIds The IDs of the PlayerTokens that can be transferred if this call succeeds.
880   function batchTransferFrom(
881         address _from,
882         address _to,
883         uint32[] _tokenIds
884   )
885   public
886   whenNotPaused
887   {
888     for (uint32 i = 0; i < _tokenIds.length; i++) {
889 
890         uint32 _tokenId = _tokenIds[i];
891 
892         // Check for approval and valid ownership
893         require(_approvedFor(_to, _tokenId));
894         require(_owns(_from, _tokenId));
895 
896         // Validate the sender
897         require(_owns(msg.sender, _tokenId) || // sender owns the token
898         (msg.sender == playerTokenToApproved[_tokenId]) || // sender is the approved address
899         operators[_from][msg.sender]); // sender is an authorized operator for this token
900 
901         // Reassign ownership, clear pending approvals (not necessary here),
902         // and emit Transfer event.
903         _transfer(_from, _to, _tokenId);
904     }
905   }
906 
907   /// @notice Change or reaffirm the approved address for an NFT
908   /// @dev The zero address indicates there is no approved address.
909   ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
910   ///  operator of the current owner.
911   /// @param _to The new approved NFT controller
912   /// @param _tokenId The NFT to approve
913   function approve(
914       address _to,
915       uint256 _tokenId
916   )
917       public
918       whenNotPaused
919   {
920       address owner = ownerOf(_tokenId);
921       require(_to != owner);
922 
923       // Only an owner or authorized operator can grant transfer approval.
924       require((msg.sender == owner) || (operators[ownerOf(_tokenId)][msg.sender]));
925 
926       // Register the approval (replacing any previous approval).
927       _approve(_tokenId, _to);
928 
929       // Emit approval event.
930       emit Approval(msg.sender, _to, _tokenId);
931   }
932 
933   /// @notice Change or reaffirm the approved address for an NFT
934   /// @dev The zero address indicates there is no approved address.
935   /// Throws unless `msg.sender` is the current NFT owner, or an authorized
936   /// operator of the current owner.
937   /// @param _to The address to be granted transfer approval. Pass address(0) to
938   ///  clear all approvals.
939   /// @param _tokenIds The IDs of the PlayerTokens that can be transferred if this call succeeds.
940   function batchApprove(
941         address _to,
942         uint32[] _tokenIds
943   )
944   public
945   whenNotPaused
946   {
947     for (uint32 i = 0; i < _tokenIds.length; i++) {
948 
949         uint32 _tokenId = _tokenIds[i];
950 
951         // Only an owner or authorized operator can grant transfer approval.
952         require(_owns(msg.sender, _tokenId) || (operators[ownerOf(_tokenId)][msg.sender]));
953 
954         // Register the approval (replacing any previous approval).
955         _approve(_tokenId, _to);
956 
957         // Emit approval event.
958         emit Approval(msg.sender, _to, _tokenId);
959     }
960   }
961 
962   /// @notice Escrows all of the tokensIds passed by transfering ownership
963   ///   to the teamContract. CAN ONLY BE CALLED BY THE CURRENT TEAM CONTRACT.
964   /// @param _owner - Current owner of the token being authorized for transfer
965   /// @param _tokenIds The IDs of the PlayerTokens that can be transferred if this call succeeds.
966   function batchEscrowToTeamContract(
967     address _owner,
968     uint32[] _tokenIds
969   )
970     public
971     whenNotPaused
972   {
973     require(teamContract != address(0));
974     require(msg.sender == address(teamContract));
975 
976     for (uint32 i = 0; i < _tokenIds.length; i++) {
977 
978       uint32 _tokenId = _tokenIds[i];
979 
980       // Only an owner can transfer the token.
981       require(_owns(_owner, _tokenId));
982 
983       // Reassign ownership, clear pending approvals (not necessary here),
984       // and emit Transfer event.
985       _transfer(_owner, teamContract, _tokenId);
986     }
987   }
988 
989   bytes4 constant TOKEN_RECEIVED_SIG = bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
990 
991   /// @notice Transfers the ownership of an NFT from one address to another address
992   /// @dev Throws unless `msg.sender` is the current owner, an authorized
993   ///  operator, or the approved address for this NFT. Throws if `_from` is
994   ///  not the current owner. Throws if `_to` is the zero address. Throws if
995   ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
996   ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
997   ///  `onERC721Received` on `_to` and throws if the return value is not
998   ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
999   /// @param _from The current owner of the NFT
1000   /// @param _to The new owner
1001   /// @param _tokenId The NFT to transfer
1002   /// @param data Additional data with no specified format, sent in call to `_to`
1003   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable {
1004     transferFrom(_from, _to, _tokenId);
1005     if (_isContract(_to)) {
1006         ERC721TokenReceiver receiver = ERC721TokenReceiver(_to);
1007         bytes4 response = receiver.onERC721Received.gas(50000)(msg.sender, _from, _tokenId, data);
1008         require(response == TOKEN_RECEIVED_SIG);
1009     }
1010   }
1011 
1012   /// @notice Transfers the ownership of an NFT from one address to another address
1013   /// @dev This works identically to the other function with an extra data parameter,
1014   ///  except this function just sets data to "".
1015   /// @param _from The current owner of the NFT
1016   /// @param _to The new owner
1017   /// @param _tokenId The NFT to transfer
1018   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
1019     require(_to != address(0));
1020     transferFrom(_from, _to, _tokenId);
1021     if (_isContract(_to)) {
1022         ERC721TokenReceiver receiver = ERC721TokenReceiver(_to);
1023         bytes4 response = receiver.onERC721Received.gas(50000)(msg.sender, _from, _tokenId, "");
1024         require(response == TOKEN_RECEIVED_SIG);
1025     }
1026   }
1027 
1028   /// @notice Count NFTs tracked by this contract
1029   /// @return A count of valid NFTs tracked by this contract, where each one of
1030   ///  them has an assigned and queryable owner not equal to the zero address
1031   function totalSupply() public view returns (uint) {
1032       return playerTokens.length;
1033   }
1034 
1035   /// @notice Enumerate NFTs assigned to an owner
1036   /// @dev Throws if `index` >= `balanceOf(owner)` or if
1037   ///  `owner` is the zero address, representing invalid NFTs.
1038   /// @param owner An address where we are interested in NFTs owned by them
1039   /// @param index A counter less than `balanceOf(owner)`
1040   /// @return The token identifier for the `index`th NFT assigned to `owner`,
1041   ///   (sort order not specified)
1042   function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 _tokenId) {
1043       require(owner != address(0));
1044       require(index < balanceOf(owner));
1045       return ownedTokens[owner][index];
1046   }
1047 
1048   /// @notice Enumerate valid NFTs
1049   /// @dev Throws if `index` >= `totalSupply()`.
1050   /// @param index A counter less than `totalSupply()`
1051   /// @return The token identifier for the `index`th NFT,
1052   ///  (sort order not specified)
1053   function tokenByIndex(uint256 index) external view returns (uint256) {
1054       require (_tokenExists(index));
1055       return index;
1056   }
1057 
1058   /// @notice Enable or disable approval for a third party ("operator") to manage
1059   ///  all of `msg.sender`'s assets
1060   /// @dev Emits the ApprovalForAll event. The contract MUST allow
1061   ///  multiple operators per owner.
1062   /// @param _operator Address to add to the set of authorized operators
1063   /// @param _approved True if the operator is approved, false to revoke approval
1064   function setApprovalForAll(address _operator, bool _approved) external {
1065         require(_operator != msg.sender);
1066         operators[msg.sender][_operator] = _approved;
1067         emit ApprovalForAll(msg.sender, _operator, _approved);
1068   }
1069 
1070   /// @notice Get the approved address for a single NFT
1071   /// @dev Throws if `_tokenId` is not a valid NFT.
1072   /// @param _tokenId The NFT to find the approved address for
1073   /// @return The approved address for this NFT, or the zero address if there is none
1074   function getApproved(uint256 _tokenId) external view returns (address) {
1075       require(_tokenExists(_tokenId));
1076       return playerTokenToApproved[_tokenId];
1077   }
1078 
1079   /// @notice Query if a contract implements an interface
1080   /// @param interfaceID The interface identifier, as specified in ERC-165
1081   /// @dev Interface identification is specified in ERC-165. This function
1082   ///  uses less than 30,000 gas.
1083   /// @return `true` if the contract implements `interfaceID` and
1084   ///  `interfaceID` is not 0xffffffff, `false` otherwise
1085   function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
1086       return (
1087           interfaceID == this.supportsInterface.selector || // ERC165
1088           interfaceID == 0x5b5e139f || // ERC721Metadata
1089           interfaceID == 0x80ac58cd || // ERC-721
1090           interfaceID == 0x780e9d63);  // ERC721Enumerable
1091   }
1092 
1093   // Internal utility functions: These functions all assume that their input arguments
1094   // are valid. We leave it to public methods to sanitize their inputs and follow
1095   // the required logic.
1096 
1097   /// @dev Checks if a given address is the current owner of a particular PlayerToken.
1098   /// @param _claimant the address we are validating against.
1099   /// @param _tokenId kitten id, only valid when > 0
1100   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1101       return playerTokenToOwner[_tokenId] == _claimant;
1102   }
1103 
1104   /// @dev Checks if a given address currently has transferApproval for a particular PlayerToken.
1105   /// @param _claimant the address we are confirming PlayerToken is approved for.
1106   /// @param _tokenId PlayerToken id, only valid when > 0
1107   function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
1108       return playerTokenToApproved[_tokenId] == _claimant;
1109   }
1110 
1111   /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
1112   ///  approval. Setting _approved to address(0) clears all transfer approval.
1113   ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
1114   ///  _approve() and transferFrom() are used together for putting PlayerToken on auction, and
1115   ///  there is no value in spamming the log with Approval events in that case.
1116   function _approve(uint256 _tokenId, address _approved) internal {
1117       playerTokenToApproved[_tokenId] = _approved;
1118   }
1119 
1120 }
1121 
1122 /// @dev Interface to the sale clock auction contract
1123 interface CSportsAuctionInterface {
1124 
1125     /// @dev Sanity check that allows us to ensure that we are pointing to the
1126     ///  right auction in our setSaleAuctionAddress() call.
1127     function isSaleClockAuction() external pure returns (bool);
1128 
1129     /// @dev Creates and begins a new auction.
1130     /// @param _tokenId - ID of token to auction, sender must be owner.
1131     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1132     /// @param _endingPrice - Price of item (in wei) at end of auction.
1133     /// @param _duration - Length of auction (in seconds).
1134     /// @param _seller - Seller, if not the message sender
1135     function createAuction(
1136         uint256 _tokenId,
1137         uint256 _startingPrice,
1138         uint256 _endingPrice,
1139         uint256 _duration,
1140         address _seller
1141     ) external;
1142 
1143     /// @dev Reprices (and updates duration) of an array of tokens that are currently
1144     /// being auctioned by this contract.
1145     /// @param _tokenIds Array of tokenIds corresponding to auctions being updated
1146     /// @param _startingPrices New starting prices
1147     /// @param _endingPrices New ending price
1148     /// @param _duration New duration
1149     /// @param _seller Address of the seller in all specified auctions to be updated
1150     function repriceAuctions(
1151         uint256[] _tokenIds,
1152         uint256[] _startingPrices,
1153         uint256[] _endingPrices,
1154         uint256 _duration,
1155         address _seller
1156     ) external;
1157 
1158     /// @dev Cancels an auction that hasn't been won yet by calling
1159     ///   the super(...) and then notifying any listener.
1160     /// @param _tokenId - ID of token on auction
1161     function cancelAuction(uint256 _tokenId) external;
1162 
1163     /// @dev Withdraw the total contract balance to the core contract
1164     function withdrawBalance() external;
1165 
1166 }
1167 
1168 /// @title Interface to allow a contract to listen to auction events.
1169 contract SaleClockAuctionListener {
1170     function implementsSaleClockAuctionListener() public pure returns (bool);
1171     function auctionCreated(uint256 tokenId, address seller, uint128 startingPrice, uint128 endingPrice, uint64 duration) public;
1172     function auctionSuccessful(uint256 tokenId, uint128 totalPrice, address seller, address buyer) public;
1173     function auctionCancelled(uint256 tokenId, address seller) public;
1174 }
1175 
1176 /// @title The facet of the CSports core contract that manages interfacing with auctions
1177 /// @author CryptoSports, Inc. (http://cryptosports.team)
1178 /// See the CSportsCore contract documentation to understand how the various contract facets are arranged.
1179 contract CSportsAuction is CSportsOwnership, SaleClockAuctionListener {
1180 
1181   // Holds a reference to our saleClockAuctionContract
1182   CSportsAuctionInterface public saleClockAuctionContract;
1183 
1184   /// @dev SaleClockAuctionLIstener interface method concrete implementation
1185   function implementsSaleClockAuctionListener() public pure returns (bool) {
1186     return true;
1187   }
1188 
1189   /// @dev SaleClockAuctionLIstener interface method concrete implementation
1190   function auctionCreated(uint256 /* tokenId */, address /* seller */, uint128 /* startingPrice */, uint128 /* endingPrice */, uint64 /* duration */) public {
1191     require (saleClockAuctionContract != address(0));
1192     require (msg.sender == address(saleClockAuctionContract));
1193   }
1194 
1195   /// @dev SaleClockAuctionLIstener interface method concrete implementation
1196   /// @param tokenId - ID of the token whose auction successfully completed
1197   /// @param totalPrice - Price at which the auction closed at
1198   /// @param seller - Account address of the auction seller
1199   /// @param winner - Account address of the auction winner (buyer)
1200   function auctionSuccessful(uint256 tokenId, uint128 totalPrice, address seller, address winner) public {
1201     require (saleClockAuctionContract != address(0));
1202     require (msg.sender == address(saleClockAuctionContract));
1203 
1204     // Record the most recent sale price to the token
1205     PlayerToken storage _playerToken = playerTokens[tokenId];
1206     _playerToken.mostRecentPrice = totalPrice;
1207 
1208     if (seller == address(this)) {
1209       // We completed a commissioner auction!
1210       leagueRosterContract.commissionerAuctionComplete(playerTokens[tokenId].realWorldPlayerId, totalPrice);
1211       emit CommissionerAuctionSuccessful(tokenId, totalPrice, winner);
1212     }
1213   }
1214 
1215   /// @dev SaleClockAuctionLIstener interface method concrete implementation
1216   /// @param tokenId - ID of the token whose auction was cancelled
1217   /// @param seller - Account address of seller who decided to cancel the auction
1218   function auctionCancelled(uint256 tokenId, address seller) public {
1219     require (saleClockAuctionContract != address(0));
1220     require (msg.sender == address(saleClockAuctionContract));
1221     if (seller == address(this)) {
1222       // We cancelled a commissioner auction!
1223       leagueRosterContract.commissionerAuctionCancelled(playerTokens[tokenId].realWorldPlayerId);
1224       emit CommissionerAuctionCanceled(tokenId);
1225     }
1226   }
1227 
1228   /// @dev Sets the reference to the sale auction.
1229   /// @param _address - Address of sale contract.
1230   function setSaleAuctionContractAddress(address _address) public onlyCEO {
1231 
1232       require(_address != address(0));
1233 
1234       CSportsAuctionInterface candidateContract = CSportsAuctionInterface(_address);
1235 
1236       // Sanity check
1237       require(candidateContract.isSaleClockAuction());
1238 
1239       // Set the new contract address
1240       saleClockAuctionContract = candidateContract;
1241 
1242   }
1243 
1244   /// @dev Allows the commissioner to cancel his auctions (which are owned
1245   ///   by this contract)
1246   function cancelCommissionerAuction(uint32 tokenId) public onlyCommissioner {
1247     require(saleClockAuctionContract != address(0));
1248     saleClockAuctionContract.cancelAuction(tokenId);
1249   }
1250 
1251   /// @dev Put a player up for auction. The message sender must own the
1252   ///   player token being put up for auction.
1253   /// @param _playerTokenId - ID of playerToken to be auctioned
1254   /// @param _startingPrice - Starting price in wei
1255   /// @param _endingPrice - Ending price in wei
1256   /// @param _duration - Duration in seconds
1257   function createSaleAuction(
1258       uint256 _playerTokenId,
1259       uint256 _startingPrice,
1260       uint256 _endingPrice,
1261       uint256 _duration
1262   )
1263       public
1264       whenNotPaused
1265   {
1266       // Auction contract checks input sizes
1267       // If player is already on any auction, this will throw
1268       // because it will be owned by the auction contract.
1269       require(_owns(msg.sender, _playerTokenId));
1270       _approve(_playerTokenId, saleClockAuctionContract);
1271 
1272       // saleClockAuctionContract.createAuction throws if inputs are invalid and clears
1273       // transfer after escrowing the player.
1274       saleClockAuctionContract.createAuction(
1275           _playerTokenId,
1276           _startingPrice,
1277           _endingPrice,
1278           _duration,
1279           msg.sender
1280       );
1281   }
1282 
1283   /// @dev Transfers the balance of the sale auction contract
1284   /// to the CSportsCore contract. We use two-step withdrawal to
1285   /// avoid two transfer calls in the auction bid function.
1286   /// To withdraw from this CSportsCore contract, the CFO must call
1287   /// the withdrawBalance(...) function defined in CSportsAuth.
1288   function withdrawAuctionBalances() external onlyCOO {
1289       saleClockAuctionContract.withdrawBalance();
1290   }
1291 }
1292 
1293 /// @title The facet of the CSportsCore contract that manages minting new PlayerTokens
1294 /// @author CryptoSports, Inc. (http://cryptosports.team)
1295 /// See the CSportsCore contract documentation to understand how the various contract facets are arranged.
1296 contract CSportsMinting is CSportsAuction {
1297 
1298   /// @dev MarketingTokenRedeemed event is fired when a marketing token has been redeemed
1299   event MarketingTokenRedeemed(uint256 hash, uint128 rwpMd5, address indexed recipient);
1300 
1301   /// @dev MarketingTokenCreated event is fired when a marketing token has been created
1302   event MarketingTokenCreated(uint256 hash, uint128 rwpMd5);
1303 
1304   /// @dev MarketingTokenReplaced event is fired when a marketing token has been replaced
1305   event MarketingTokenReplaced(uint256 oldHash, uint256 newHash, uint128 rwpMd5);
1306 
1307   /// @dev Sanity check that identifies this contract as having minting capability
1308   function isMinter() public pure returns (bool) {
1309       return true;
1310   }
1311 
1312   /// @dev Utility function to make it easy to keccak256 a string in python or javascript using
1313   /// the exact algorythm used by Solidity.
1314   function getKeccak256(string stringToHash) public pure returns (uint256) {
1315       return uint256(keccak256(abi.encodePacked(stringToHash)));
1316   }
1317 
1318   /// @dev Allows the commissioner to load up our marketingTokens mapping with up to
1319   /// MAX_MARKETING_TOKENS marketing tokens that can be created if one knows the words
1320   /// to keccak256 and match the keywordHash passed here. Use web3.utils.soliditySha3(param1 [, param2, ...])
1321   /// to create this hash.
1322   ///
1323   /// ONLY THE COMMISSIONER CAN CREATE MARKETING TOKENS, AND ONLY UP TO MAX_MARKETING_TOKENS OF THEM
1324   ///
1325   /// @param keywordHash - keccak256 of a known set of keyWords
1326   /// @param md5Token - The md5 key in the leagueRosterContract that specifies the player
1327   /// player token that will be minted and transfered by the redeemMarketingToken(...) method.
1328   function addMarketingToken(uint256 keywordHash, uint128 md5Token) public onlyCommissioner {
1329 
1330     require(remainingMarketingTokens > 0);
1331     require(marketingTokens[keywordHash] == 0);
1332 
1333     // Make sure the md5Token exists in the league roster
1334     uint128 _rosterIndex = leagueRosterContract.getRealWorldPlayerRosterIndex(md5Token);
1335     require(_rosterIndex != 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1336 
1337     // Map the keyword Hash to the RWP md5 and decrement the remainingMarketingTokens property
1338     remainingMarketingTokens--;
1339     marketingTokens[keywordHash] = md5Token;
1340 
1341     emit MarketingTokenCreated(keywordHash, md5Token);
1342 
1343   }
1344 
1345   /// @dev This method allows the commish to replace an existing marketing token that has
1346   /// not been used with a new one (new hash and mdt). Since we are replacing, we co not
1347   /// have to deal with remainingMarketingTokens in any way. This is to allow for replacing
1348   /// marketing tokens that have not been redeemed and aren't likely to be redeemed (breakage)
1349   ///
1350   /// ONLY THE COMMISSIONER CAN ACCESS THIS METHOD
1351   ///
1352   /// @param oldKeywordHash Hash to replace
1353   /// @param newKeywordHash Hash to replace with
1354   /// @param md5Token The md5 key in the leagueRosterContract that specifies the player
1355   function replaceMarketingToken(uint256 oldKeywordHash, uint256 newKeywordHash, uint128 md5Token) public onlyCommissioner {
1356 
1357     uint128 _md5Token = marketingTokens[oldKeywordHash];
1358     if (_md5Token != 0) {
1359       marketingTokens[oldKeywordHash] = 0;
1360       marketingTokens[newKeywordHash] = md5Token;
1361       emit MarketingTokenReplaced(oldKeywordHash, newKeywordHash, md5Token);
1362     }
1363 
1364   }
1365 
1366   /// @dev Returns the real world player's MD5 key from a keywords string. A 0x00 returned
1367   /// value means the keyword string parameter isn't mapped to a marketing token.
1368   /// @param keyWords Keywords to use to look up RWP MD5
1369   //
1370   /// ANYONE CAN VALIDATE A KEYWORD STRING (MAP IT TO AN MD5 IF IT HAS ONE)
1371   ///
1372   /// @param keyWords - A string that will keccak256 to an entry in the marketingTokens
1373   /// mapping (or not)
1374   function MD5FromMarketingKeywords(string keyWords) public view returns (uint128) {
1375     uint256 keyWordsHash = uint256(keccak256(abi.encodePacked(keyWords)));
1376     uint128 _md5Token = marketingTokens[keyWordsHash];
1377     return _md5Token;
1378   }
1379 
1380   /// @dev Allows anyone to try to redeem a marketing token by passing N words that will
1381   /// be SHA256'ed to match an entry in our marketingTokens mapping. If a match is found,
1382   /// a CryptoSports token is created that corresponds to the md5 retrieved
1383   /// from the marketingTokens mapping and its owner is assigned as the msg.sender.
1384   ///
1385   /// ANYONE CAN REDEEM A MARKETING token
1386   ///
1387   /// @param keyWords - A string that will keccak256 to an entry in the marketingTokens mapping
1388   function redeemMarketingToken(string keyWords) public {
1389 
1390     uint256 keyWordsHash = uint256(keccak256(abi.encodePacked(keyWords)));
1391     uint128 _md5Token = marketingTokens[keyWordsHash];
1392     if (_md5Token != 0) {
1393 
1394       // Only one redemption per set of keywords
1395       marketingTokens[keyWordsHash] = 0;
1396 
1397       uint128 _rosterIndex = leagueRosterContract.getRealWorldPlayerRosterIndex(_md5Token);
1398       if (_rosterIndex != 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
1399 
1400         // Grab the real world player record from the leagueRosterContract
1401         RealWorldPlayer memory _rwp;
1402         (_rwp.md5Token, _rwp.prevCommissionerSalePrice, _rwp.lastMintedTime, _rwp.mintedCount, _rwp.hasActiveCommissionerAuction, _rwp.mintingEnabled) =  leagueRosterContract.realWorldPlayerFromIndex(_rosterIndex);
1403 
1404         // Mint this player, sending it to the message sender
1405         _mintPlayer(uint32(_rosterIndex), _rwp.mintedCount, msg.sender);
1406 
1407         // Finally, update our realWorldPlayer record to reflect the fact that we just
1408         // minted a new one, and there is an active commish auction. The only portion of
1409         // the RWP record we change here is an update to the mingedCount.
1410         leagueRosterContract.updateRealWorldPlayer(uint32(_rosterIndex), _rwp.prevCommissionerSalePrice, uint64(now), _rwp.mintedCount + 1, _rwp.hasActiveCommissionerAuction, _rwp.mintingEnabled);
1411 
1412         emit MarketingTokenRedeemed(keyWordsHash, _rwp.md5Token, msg.sender);
1413       }
1414 
1415     }
1416   }
1417 
1418   /// @dev Returns an array of minimum auction starting prices for an array of players
1419   /// specified by their MD5s.
1420   /// @param _md5Tokens MD5s in the league roster for the players we are inquiring about.
1421   function minStartPriceForCommishAuctions(uint128[] _md5Tokens) public view onlyCommissioner returns (uint128[50]) {
1422     require (_md5Tokens.length <= 50);
1423     uint128[50] memory minPricesArray;
1424     for (uint32 i = 0; i < _md5Tokens.length; i++) {
1425         uint128 _md5Token = _md5Tokens[i];
1426         uint128 _rosterIndex = leagueRosterContract.getRealWorldPlayerRosterIndex(_md5Token);
1427         if (_rosterIndex == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
1428           // Cannot mint a non-existent real world player
1429           continue;
1430         }
1431         RealWorldPlayer memory _rwp;
1432         (_rwp.md5Token, _rwp.prevCommissionerSalePrice, _rwp.lastMintedTime, _rwp.mintedCount, _rwp.hasActiveCommissionerAuction, _rwp.mintingEnabled) =  leagueRosterContract.realWorldPlayerFromIndex(_rosterIndex);
1433 
1434         // Skip this if there is no player associated with the md5 specified
1435         if (_rwp.md5Token != _md5Token) continue;
1436 
1437         minPricesArray[i] = uint128(_computeNextCommissionerPrice(_rwp.prevCommissionerSalePrice));
1438     }
1439     return minPricesArray;
1440   }
1441 
1442   /// @dev Creates newly minted playerTokens and puts them up for auction. This method
1443   ///   can only be called by the commissioner, and checks to make sure certian minting
1444   ///   conditions are met (reverting if not met):
1445   ///     * The MD5 of the RWP specified must exist in the CSportsLeagueRoster contract
1446   ///     * Cannot mint a realWorldPlayer that currently has an active commissioner auction
1447   ///     * Cannot mint realWorldPlayer that does not have minting enabled
1448   ///     * Cannot mint realWorldPlayer with a start price exceeding our minimum
1449   ///   If any of the above conditions fails to be met, then no player tokens will be
1450   ///   minted.
1451   ///
1452   /// *** ONLY THE COMMISSIONER OR THE LEAGUE ROSTER CONTRACT CAN CALL THIS FUNCTION ***
1453   ///
1454   /// @param _md5Tokens - array of md5Tokens representing realWorldPlayer that we are minting.
1455   /// @param _startPrice - the starting price for the auction (0 will set to current minimum price)
1456   function mintPlayers(uint128[] _md5Tokens, uint256 _startPrice, uint256 _endPrice, uint256 _duration) public {
1457 
1458     require(leagueRosterContract != address(0));
1459     require(saleClockAuctionContract != address(0));
1460     require((msg.sender == commissionerAddress) || (msg.sender == address(leagueRosterContract)));
1461 
1462     for (uint32 i = 0; i < _md5Tokens.length; i++) {
1463       uint128 _md5Token = _md5Tokens[i];
1464       uint128 _rosterIndex = leagueRosterContract.getRealWorldPlayerRosterIndex(_md5Token);
1465       if (_rosterIndex == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
1466         // Cannot mint a non-existent real world player
1467         continue;
1468       }
1469 
1470       // We don't have to check _rosterIndex here because the getRealWorldPlayerRosterIndex(...)
1471       // method always returns a valid index.
1472       RealWorldPlayer memory _rwp;
1473       (_rwp.md5Token, _rwp.prevCommissionerSalePrice, _rwp.lastMintedTime, _rwp.mintedCount, _rwp.hasActiveCommissionerAuction, _rwp.mintingEnabled) =  leagueRosterContract.realWorldPlayerFromIndex(_rosterIndex);
1474 
1475       if (_rwp.md5Token != _md5Token) continue;
1476       if (!_rwp.mintingEnabled) continue;
1477 
1478       // Enforce the restrictions that there can ever only be a single outstanding commissioner
1479       // auction - no new minting if there is an active commissioner auction for this real world player
1480       if (_rwp.hasActiveCommissionerAuction) continue;
1481 
1482       // Ensure that our price is not less than a minimum
1483       uint256 _minStartPrice = _computeNextCommissionerPrice(_rwp.prevCommissionerSalePrice);
1484 
1485       // Make sure the start price exceeds our minimum acceptable
1486       if (_startPrice < _minStartPrice) {
1487           _startPrice = _minStartPrice;
1488       }
1489 
1490       // Mint the new player token
1491       uint32 _playerId = _mintPlayer(uint32(_rosterIndex), _rwp.mintedCount, address(this));
1492 
1493       // @dev Approve ownership transfer to the saleClockAuctionContract (which is required by
1494       //  the createAuction(...) which will escrow the playerToken)
1495       _approve(_playerId, saleClockAuctionContract);
1496 
1497       // Apply the default duration
1498       if (_duration == 0) {
1499         _duration = COMMISSIONER_AUCTION_DURATION;
1500       }
1501 
1502       // By setting our _endPrice to zero, we become immune to the USD <==> ether
1503       // conversion rate. No matter how high ether goes, our auction price will get
1504       // to a USD value that is acceptable to someone (assuming 0 is acceptable that is).
1505       // This also helps for players that aren't in very much demand.
1506       saleClockAuctionContract.createAuction(
1507           _playerId,
1508           _startPrice,
1509           _endPrice,
1510           _duration,
1511           address(this)
1512       );
1513 
1514       // Finally, update our realWorldPlayer record to reflect the fact that we just
1515       // minted a new one, and there is an active commish auction.
1516       leagueRosterContract.updateRealWorldPlayer(uint32(_rosterIndex), _rwp.prevCommissionerSalePrice, uint64(now), _rwp.mintedCount + 1, true, _rwp.mintingEnabled);
1517     }
1518   }
1519 
1520   /// @dev Reprices (and updates duration) of an array of tokens that are currently
1521   /// being auctioned by this contract. Since this function can only be called by
1522   /// the commissioner, we don't do a lot of checking of parameters and things.
1523   /// The SaleClockAuction's repriceAuctions method assures that the CSportsCore
1524   /// contract is the "seller" of the token (meaning it is a commissioner auction).
1525   /// @param _tokenIds Array of tokenIds corresponding to auctions being updated
1526   /// @param _startingPrices New starting prices for each token being repriced
1527   /// @param _endingPrices New ending price
1528   /// @param _duration New duration
1529   function repriceAuctions(
1530       uint256[] _tokenIds,
1531       uint256[] _startingPrices,
1532       uint256[] _endingPrices,
1533       uint256 _duration
1534   ) external onlyCommissioner {
1535 
1536       // We cannot reprice below our player minimum
1537       for (uint32 i = 0; i < _tokenIds.length; i++) {
1538           uint32 _tokenId = uint32(_tokenIds[i]);
1539           PlayerToken memory pt = playerTokens[_tokenId];
1540           RealWorldPlayer memory _rwp;
1541           (_rwp.md5Token, _rwp.prevCommissionerSalePrice, _rwp.lastMintedTime, _rwp.mintedCount, _rwp.hasActiveCommissionerAuction, _rwp.mintingEnabled) = leagueRosterContract.realWorldPlayerFromIndex(pt.realWorldPlayerId);
1542           uint256 _minStartPrice = _computeNextCommissionerPrice(_rwp.prevCommissionerSalePrice);
1543 
1544           // We require the price to be >= our _minStartPrice
1545           require(_startingPrices[i] >= _minStartPrice);
1546       }
1547 
1548       // Note we pass in this CSportsCore contract address as the seller, making sure the only auctions
1549       // that can be repriced by this method are commissioner auctions.
1550       saleClockAuctionContract.repriceAuctions(_tokenIds, _startingPrices, _endingPrices, _duration, address(this));
1551   }
1552 
1553   /// @dev Allows the commissioner to create a sale auction for a token
1554   ///   that is owned by the core contract. Can only be called when not paused
1555   ///   and only by the commissioner
1556   /// @param _playerTokenId - ID of the player token currently owned by the core contract
1557   /// @param _startingPrice - Starting price for the auction
1558   /// @param _endingPrice - Ending price for the auction
1559   /// @param _duration - Duration of the auction (in seconds)
1560   function createCommissionerAuction(uint32 _playerTokenId,
1561         uint256 _startingPrice,
1562         uint256 _endingPrice,
1563         uint256 _duration)
1564         public whenNotPaused onlyCommissioner {
1565 
1566         require(leagueRosterContract != address(0));
1567         require(_playerTokenId < playerTokens.length);
1568 
1569         // If player is already on any auction, this will throw because it will not be owned by
1570         // this CSportsCore contract (as all commissioner tokens are if they are not currently
1571         // on auction).
1572         // Any token owned by the CSportsCore contract by definition is a commissioner auction
1573         // that was canceled which makes it OK to re-list.
1574         require(_owns(address(this), _playerTokenId));
1575 
1576         // (1) Grab the real world token ID (md5)
1577         PlayerToken memory pt = playerTokens[_playerTokenId];
1578 
1579         // (2) Get the full real world player record from its roster index
1580         RealWorldPlayer memory _rwp;
1581         (_rwp.md5Token, _rwp.prevCommissionerSalePrice, _rwp.lastMintedTime, _rwp.mintedCount, _rwp.hasActiveCommissionerAuction, _rwp.mintingEnabled) = leagueRosterContract.realWorldPlayerFromIndex(pt.realWorldPlayerId);
1582 
1583         // Ensure that our starting price is not less than a minimum
1584         uint256 _minStartPrice = _computeNextCommissionerPrice(_rwp.prevCommissionerSalePrice);
1585         if (_startingPrice < _minStartPrice) {
1586             _startingPrice = _minStartPrice;
1587         }
1588 
1589         // Apply the default duration
1590         if (_duration == 0) {
1591             _duration = COMMISSIONER_AUCTION_DURATION;
1592         }
1593 
1594         // Approve the token for transfer
1595         _approve(_playerTokenId, saleClockAuctionContract);
1596 
1597         // saleClockAuctionContract.createAuction throws if inputs are invalid and clears
1598         // transfer after escrowing the player.
1599         saleClockAuctionContract.createAuction(
1600             _playerTokenId,
1601             _startingPrice,
1602             _endingPrice,
1603             _duration,
1604             address(this)
1605         );
1606   }
1607 
1608   /// @dev Computes the next commissioner auction starting price equal to
1609   ///  the previous real world player sale price + 25% (with a floor).
1610   function _computeNextCommissionerPrice(uint128 prevTwoCommissionerSalePriceAve) internal view returns (uint256) {
1611 
1612       uint256 nextPrice = prevTwoCommissionerSalePriceAve + (prevTwoCommissionerSalePriceAve / 4);
1613 
1614       // sanity check to ensure we don't overflow arithmetic (this big number is 2^128-1).
1615       if (nextPrice > 340282366920938463463374607431768211455) {
1616         nextPrice = 340282366920938463463374607431768211455;
1617       }
1618 
1619       // We never auction for less than our floor
1620       if (nextPrice < COMMISSIONER_AUCTION_FLOOR_PRICE) {
1621           nextPrice = COMMISSIONER_AUCTION_FLOOR_PRICE;
1622       }
1623 
1624       return nextPrice;
1625   }
1626 
1627 }
1628 
1629 /// @notice This is the main contract that implements the csports ERC721 token.
1630 /// @author CryptoSports, Inc. (http://cryptosports.team)
1631 /// @dev This contract is made up of a series of parent classes so that we could
1632 /// break the code down into meaningful amounts of related functions in
1633 /// single files, as opposed to having one big file. The purpose of
1634 /// each facet is given here:
1635 ///
1636 ///   CSportsConstants - This facet holds constants used throughout.
1637 ///   CSportsAuth -
1638 ///   CSportsBase -
1639 ///   CSportsOwnership -
1640 ///   CSportsAuction -
1641 ///   CSportsMinting -
1642 ///   CSportsCore - This is the main CSports constract implementing the CSports
1643 ///         Fantash Football League. It manages contract upgrades (if / when
1644 ///         they might occur), and has generally useful helper methods.
1645 ///
1646 /// This CSportsCore contract interacts with the CSportsLeagueRoster contract
1647 /// to determine which PlayerTokens to mint.
1648 ///
1649 /// This CSportsCore contract interacts with the TimeAuction contract
1650 /// to implement and run PlayerToken auctions (sales).
1651 contract CSportsCore is CSportsMinting {
1652 
1653   /// @dev Used by other contracts as a sanity check
1654   bool public isCoreContract = true;
1655 
1656   // Set if (hopefully not) the core contract needs to be upgraded. Can be
1657   // set by the CEO but only when paused. When successfully set, we can never
1658   // unpause this contract. See the unpause() method overridden by this class.
1659   address public newContractAddress;
1660 
1661   /// @notice Class constructor creates the main CSportsCore smart contract instance.
1662   /// @param nftName The ERC721 name for the contract
1663   /// @param nftSymbol The ERC721 symbol for the contract
1664   /// @param nftTokenURI The ERC721 token uri for the contract
1665   constructor(string nftName, string nftSymbol, string nftTokenURI) public {
1666 
1667       // New contract starts paused.
1668       paused = true;
1669 
1670       /// @notice storage for the fields that identify this 721 token
1671       _name = nftName;
1672       _symbol = nftSymbol;
1673       _tokenURI = nftTokenURI;
1674 
1675       // All C-level roles are the message sender
1676       ceoAddress = msg.sender;
1677       cfoAddress = msg.sender;
1678       cooAddress = msg.sender;
1679       commissionerAddress = msg.sender;
1680 
1681   }
1682 
1683   /// @dev Reject all Ether except if it's from one of our approved sources
1684   function() external payable {
1685     /*require(
1686         msg.sender == address(saleClockAuctionContract)
1687     );*/
1688   }
1689 
1690   /// --------------------------------------------------------------------------- ///
1691   /// ----------------------------- PUBLIC FUNCTIONS ---------------------------- ///
1692   /// --------------------------------------------------------------------------- ///
1693 
1694   /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1695   ///  bug. This method does nothing but keep track of the new contract and
1696   ///  emit a message indicating that the new address is set. It's up to clients of this
1697   ///  contract to update to the new contract address in that case. (This contract will
1698   ///  be paused indefinitely if such an upgrade takes place.)
1699   /// @param _v2Address new address
1700   function upgradeContract(address _v2Address) public onlyCEO whenPaused {
1701       newContractAddress = _v2Address;
1702       emit ContractUpgrade(_v2Address);
1703   }
1704 
1705   /// @dev Override unpause so it requires all external contract addresses
1706   ///  to be set before contract can be unpaused. Also require that we have
1707   ///  set a valid season and the contract has not been upgraded.
1708   function unpause() public onlyCEO whenPaused {
1709       require(leagueRosterContract != address(0));
1710       require(saleClockAuctionContract != address(0));
1711       require(newContractAddress == address(0));
1712 
1713       // Actually unpause the contract.
1714       super.unpause();
1715   }
1716 
1717   /// @dev Consolidates setting of contract links into a single call for deployment expediency
1718   function setLeagueRosterAndSaleAndTeamContractAddress(address _leagueAddress, address _saleAddress, address _teamAddress) public onlyCEO {
1719       setLeagueRosterContractAddress(_leagueAddress);
1720       setSaleAuctionContractAddress(_saleAddress);
1721       setTeamContractAddress(_teamAddress);
1722   }
1723 
1724   /// @dev Returns all the relevant information about a specific playerToken.
1725   ///@param _playerTokenID - player token ID we are seeking the full player token info for
1726   function getPlayerToken(uint32 _playerTokenID) public view returns (
1727       uint32 realWorldPlayerId,
1728       uint32 serialNumber,
1729       uint64 mintedTime,
1730       uint128 mostRecentPrice) {
1731     require(_playerTokenID < playerTokens.length);
1732     PlayerToken storage pt = playerTokens[_playerTokenID];
1733     realWorldPlayerId = pt.realWorldPlayerId;
1734     serialNumber = pt.serialNumber;
1735     mostRecentPrice = pt.mostRecentPrice;
1736     mintedTime = pt.mintedTime;
1737   }
1738 
1739   /// @dev Returns the realWorldPlayer MD5 ID for a given playerTokenID
1740   /// @param _playerTokenID - player token ID we are seeking the associated realWorldPlayer md5 for
1741   function realWorldPlayerTokenForPlayerTokenId(uint32 _playerTokenID) public view returns (uint128 md5Token) {
1742       require(_playerTokenID < playerTokens.length);
1743       PlayerToken storage pt = playerTokens[_playerTokenID];
1744       RealWorldPlayer memory _rwp;
1745       (_rwp.md5Token, _rwp.prevCommissionerSalePrice, _rwp.lastMintedTime, _rwp.mintedCount, _rwp.hasActiveCommissionerAuction, _rwp.mintingEnabled) = leagueRosterContract.realWorldPlayerFromIndex(pt.realWorldPlayerId);
1746       md5Token = _rwp.md5Token;
1747   }
1748 
1749   /// @dev Returns the realWorldPlayer Metadata for a given playerTokenID
1750   /// @param _playerTokenID - player token ID we are seeking the associated realWorldPlayer md5 for
1751   function realWorldPlayerMetadataForPlayerTokenId(uint32 _playerTokenID) public view returns (string metadata) {
1752       require(_playerTokenID < playerTokens.length);
1753       PlayerToken storage pt = playerTokens[_playerTokenID];
1754       RealWorldPlayer memory _rwp;
1755       (_rwp.md5Token, _rwp.prevCommissionerSalePrice, _rwp.lastMintedTime, _rwp.mintedCount, _rwp.hasActiveCommissionerAuction, _rwp.mintingEnabled) = leagueRosterContract.realWorldPlayerFromIndex(pt.realWorldPlayerId);
1756       metadata = leagueRosterContract.getMetadata(_rwp.md5Token);
1757   }
1758 
1759   /// --------------------------------------------------------------------------- ///
1760   /// ------------------------- RESTRICTED FUNCTIONS ---------------------------- ///
1761   /// --------------------------------------------------------------------------- ///
1762 
1763   /// @dev Updates a particular realRealWorldPlayer. Note that the md5Token is immutable. Can only be
1764   ///   called by the CEO and is used in development stage only as it is only needed by our test suite.
1765   /// @param _rosterIndex - Index into realWorldPlayers of the entry to change.
1766   /// @param _prevCommissionerSalePrice - Average of the 2 most recent sale prices in commissioner auctions
1767   /// @param _lastMintedTime - Time this real world player was last minted
1768   /// @param _mintedCount - The number of playerTokens that have been minted for this player
1769   /// @param _hasActiveCommissionerAuction - Whether or not there is an active commissioner auction for this player
1770   /// @param _mintingEnabled - Denotes whether or not we should mint new playerTokens for this real world player
1771   function updateRealWorldPlayer(uint32 _rosterIndex, uint128 _prevCommissionerSalePrice, uint64 _lastMintedTime, uint32 _mintedCount, bool _hasActiveCommissionerAuction, bool _mintingEnabled) public onlyCEO onlyUnderDevelopment {
1772     require(leagueRosterContract != address(0));
1773     leagueRosterContract.updateRealWorldPlayer(_rosterIndex, _prevCommissionerSalePrice, _lastMintedTime, _mintedCount, _hasActiveCommissionerAuction, _mintingEnabled);
1774   }
1775 
1776 }