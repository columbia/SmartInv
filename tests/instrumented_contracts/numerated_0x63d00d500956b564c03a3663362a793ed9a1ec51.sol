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
201 interface CSportsMinter {
202 
203     /// @dev Called by league roster contract as a sanity check
204     function isMinter() external pure returns (bool);
205 
206     /// @dev The method called by the league roster contract to mint a new player and create its commissioner auction
207     function mintPlayers(uint128[] _md5Tokens, uint256 _startPrice, uint256 _endPrice, uint256 _duration) external;
208 }
209 /// @dev This is the data structure that holds a roster player in the CSportsLeagueRoster
210 /// contract. Also referenced by CSportsCore.
211 /// @author CryptoSports, Inc. (http://cryptosports.team)
212 contract CSportsRosterPlayer {
213 
214     struct RealWorldPlayer {
215 
216         // The player's certified identification. This is the md5 hash of
217         // {player's last name}-{player's first name}-{player's birthday in YYYY-MM-DD format}-{serial number}
218         // where the serial number is usually 0, but gives us an ability to deal with making
219         // sure all MD5s are unique.
220         uint128 md5Token;
221 
222         // Stores the average sale price of the most recent 2 commissioner sales
223         uint128 prevCommissionerSalePrice;
224 
225         // The last time this real world player was minted.
226         uint64 lastMintedTime;
227 
228         // The number of PlayerTokens minted for this real world player
229         uint32 mintedCount;
230 
231         // When true, there is an active auction for this player owned by
232         // the commissioner (indicating a gen0 minting auction is in progress)
233         bool hasActiveCommissionerAuction;
234 
235         // Indicates this real world player can be actively minted
236         bool mintingEnabled;
237 
238         // Any metadata we want to attach to this player (in JSON format)
239         string metadata;
240 
241     }
242 
243 }
244 
245 /// @title Contract that holds all of the real world player data. This data is
246 /// added by the commissioner and represents an on-blockchain database of
247 /// players in the league.
248 /// @author CryptoSports, Inc. (http://cryptosports.team)
249 contract CSportsLeagueRoster is CSportsAuth, CSportsRosterPlayer  {
250 
251   /*** STORAGE ***/
252 
253   /// @dev Holds the coreContract which supports the CSportsMinter interface
254   CSportsMinter public minterContract;
255 
256   /// @dev Holds one entry for each real-world player available in the
257   /// current league (e.g. NFL). There can be a maximum of 4,294,967,295
258   /// entries in this array (plenty) because it is indexed by a uint32.
259   /// This structure is constantly updated by a commissioner. If the
260   /// realWorldPlayer[<whatever].mintingEnabled property is true, then playerTokens
261   /// tied to this realWorldPlayer entry will automatically be minted.
262   RealWorldPlayer[] public realWorldPlayers;
263 
264   mapping (uint128 => uint32) public md5TokenToRosterIndex;
265 
266   /*** MODIFIERS ***/
267 
268   /// @dev Access modifier for core contract only functions
269   modifier onlyCoreContract() {
270       require(msg.sender == address(minterContract));
271       _;
272   }
273 
274   /*** FUNCTIONS ***/
275 
276   /// @dev Contract constructor. All "C" level authorized addresses
277   /// are set to the contract creator.
278   constructor() public {
279     ceoAddress = msg.sender;
280     cfoAddress = msg.sender;
281     cooAddress = msg.sender;
282     commissionerAddress = msg.sender;
283   }
284 
285   /// @dev Sanity check that identifies this contract is a league roster contract
286   function isLeagueRosterContract() public pure returns (bool) {
287     return true;
288   }
289 
290   /// @dev Returns the full player structure from the league roster contract given its index.
291   /// @param idx Index of player we are interested in
292   function realWorldPlayerFromIndex(uint128 idx) public view returns (uint128 md5Token, uint128 prevCommissionerSalePrice, uint64 lastMintedTime, uint32 mintedCount, bool hasActiveCommissionerAuction, bool mintingEnabled) {
293     RealWorldPlayer memory _rwp;
294     _rwp = realWorldPlayers[idx];
295     md5Token = _rwp.md5Token;
296     prevCommissionerSalePrice = _rwp.prevCommissionerSalePrice;
297     lastMintedTime = _rwp.lastMintedTime;
298     mintedCount = _rwp.mintedCount;
299     hasActiveCommissionerAuction = _rwp.hasActiveCommissionerAuction;
300     mintingEnabled = _rwp.mintingEnabled;
301   }
302 
303   /// @dev Sets the coreContractAddress that will restrict access
304   /// to certin functions
305   function setCoreContractAddress(address _address) public onlyCEO {
306 
307     CSportsMinter candidateContract = CSportsMinter(_address);
308     // NOTE: verify that a contract is what we expect (not foolproof, just
309     // a sanity check)
310     require(candidateContract.isMinter());
311     // Set the new contract address
312     minterContract = candidateContract;
313 
314   }
315 
316   /// @return uint32 count -  # of entries in the realWorldPlayer array
317   function playerCount() public view returns (uint32 count) {
318     return uint32(realWorldPlayers.length);
319   }
320 
321   /// @dev Creates and adds realWorldPlayer entries, and mints a new ERC721 token for each, and puts each on
322   /// auction as a commissioner auction.
323   /// @param _md5Tokens The MD5s to be associated with the roster entries we are adding
324   /// @param _mintingEnabled An array (of equal length to _md5Tokens) indicating the minting status of that player
325   ///        (if an entry is not true, that player will not be minted and no auction created)
326   /// @param _startPrice The starting price for the auction we will create for the newly minted token
327   /// @param _endPrice The ending price for the auction we will create for the newly minted token
328   /// @param _duration The duration for the auction we will create for the newly minted token
329   function addAndMintPlayers(uint128[] _md5Tokens, bool[] _mintingEnabled, uint256 _startPrice, uint256 _endPrice, uint256 _duration) public onlyCommissioner {
330 
331     // Add the real world players to the roster
332     addRealWorldPlayers(_md5Tokens, _mintingEnabled);
333 
334     // Mint the newly added players and create commissioner auctions
335     minterContract.mintPlayers(_md5Tokens, _startPrice, _endPrice, _duration);
336 
337   }
338 
339   /// @dev Creates and adds a RealWorldPlayer entry.
340   /// @param _md5Tokens - An array of MD5 tokens for players to be added to our realWorldPlayers array.
341   /// @param _mintingEnabled - An array (of equal length to _md5Tokens) indicating the minting status of that player
342   function addRealWorldPlayers(uint128[] _md5Tokens, bool[] _mintingEnabled) public onlyCommissioner {
343     if (_md5Tokens.length != _mintingEnabled.length) {
344       revert();
345     }
346     for (uint32 i = 0; i < _md5Tokens.length; i++) {
347       // We won't try to put an md5Token duplicate by using the md5TokenToRosterIndex
348       // mapping (notice we need to deal with the fact that a non-existent mapping returns 0)
349       if ( (realWorldPlayers.length == 0) ||
350            ((md5TokenToRosterIndex[_md5Tokens[i]] == 0) && (realWorldPlayers[0].md5Token != _md5Tokens[i])) ) {
351         RealWorldPlayer memory _realWorldPlayer = RealWorldPlayer({
352                                                       md5Token: _md5Tokens[i],
353                                                       prevCommissionerSalePrice: 0,
354                                                       lastMintedTime: 0,
355                                                       mintedCount: 0,
356                                                       hasActiveCommissionerAuction: false,
357                                                       mintingEnabled: _mintingEnabled[i],
358                                                       metadata: ""
359                                                   });
360         uint256 _rosterIndex = realWorldPlayers.push(_realWorldPlayer) - 1;
361 
362         // It's probably never going to happen, but just in case, we need
363         // to make sure our realWorldPlayers can be indexed by a uint32
364         require(_rosterIndex < 4294967295);
365 
366         // Map the md5Token to its rosterIndex
367         md5TokenToRosterIndex[_md5Tokens[i]] = uint32(_rosterIndex);
368       }
369     }
370   }
371 
372   /// @dev Sets the metadata for a real world player token that has already been added.
373   /// @param _md5Token The MD5 key of the token to update
374   /// @param _metadata The JSON string representing the metadata for the token
375   function setMetadata(uint128 _md5Token, string _metadata) public onlyCommissioner {
376       uint32 _rosterIndex = md5TokenToRosterIndex[_md5Token];
377       if ((_rosterIndex > 0) || ((realWorldPlayers.length > 0) && (realWorldPlayers[0].md5Token == _md5Token))) {
378         // Valid MD5 token
379         realWorldPlayers[_rosterIndex].metadata = _metadata;
380       }
381   }
382 
383   /// @dev Returns the metadata for a specific token
384   /// @param _md5Token MD5 key for token we want the metadata for
385   function getMetadata(uint128 _md5Token) public view returns (string metadata) {
386     uint32 _rosterIndex = md5TokenToRosterIndex[_md5Token];
387     if ((_rosterIndex > 0) || ((realWorldPlayers.length > 0) && (realWorldPlayers[0].md5Token == _md5Token))) {
388       // Valid MD5 token
389       metadata = realWorldPlayers[_rosterIndex].metadata;
390     } else {
391       metadata = "";
392     }
393   }
394 
395   /// @dev Function to remove a particular md5Token from our array of players. This function
396   ///   will be blocked after we are completed with development. Deleting entries would
397   ///   screw up the ids of realWorldPlayers held by the core contract's playerTokens structure.
398   /// @param _md5Token - The MD5 token of the entry to remove.
399   function removeRealWorldPlayer(uint128 _md5Token) public onlyCommissioner onlyUnderDevelopment  {
400     for (uint32 i = 0; i < uint32(realWorldPlayers.length); i++) {
401       RealWorldPlayer memory player = realWorldPlayers[i];
402       if (player.md5Token == _md5Token) {
403         uint32 stopAt = uint32(realWorldPlayers.length - 1);
404         for (uint32 j = i; j < stopAt; j++){
405             realWorldPlayers[j] = realWorldPlayers[j+1];
406             md5TokenToRosterIndex[realWorldPlayers[j].md5Token] = j;
407         }
408         delete realWorldPlayers[realWorldPlayers.length-1];
409         realWorldPlayers.length--;
410         break;
411       }
412     }
413   }
414 
415   /// @dev Returns TRUE if there is an open commissioner auction for a realWorldPlayer
416   /// @param _md5Token - md5Token of the player of interest
417   function hasOpenCommissionerAuction(uint128 _md5Token) public view onlyCommissioner returns (bool) {
418     uint128 _rosterIndex = this.getRealWorldPlayerRosterIndex(_md5Token);
419     if (_rosterIndex == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
420       revert();
421     } else {
422       return realWorldPlayers[_rosterIndex].hasActiveCommissionerAuction;
423     }
424   }
425 
426   /// @dev Returns the rosterId of the player identified with an md5Token
427   /// @param _md5Token = md5Token of exisiting
428   function getRealWorldPlayerRosterIndex(uint128 _md5Token) public view returns (uint128) {
429 
430     uint32 _rosterIndex = md5TokenToRosterIndex[_md5Token];
431     if (_rosterIndex == 0) {
432       // Deal with the fact that mappings return 0 for non-existent members and 0 is
433       // a valid rosterIndex for the 0th (first) entry in the realWorldPlayers array.
434       if ((realWorldPlayers.length > 0) && (realWorldPlayers[0].md5Token == _md5Token)) {
435         return uint128(0);
436       }
437     } else {
438       return uint128(_rosterIndex);
439     }
440 
441     // Intentionally returning an invalid rosterIndex (too big) as an indicator that
442     // the md5 passed was not found.
443     return uint128(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
444   }
445 
446   /// @dev Enables (or disables) minting for a particular real world player.
447   /// @param _md5Tokens - The md5Token of the player to be updated
448   /// @param _mintingEnabled - True to enable, false to disable minting for the player
449   function enableRealWorldPlayerMinting(uint128[] _md5Tokens, bool[] _mintingEnabled) public onlyCommissioner {
450     if (_md5Tokens.length != _mintingEnabled.length) {
451       revert();
452     }
453     for (uint32 i = 0; i < _md5Tokens.length; i++) {
454       uint32 _rosterIndex = md5TokenToRosterIndex[_md5Tokens[i]];
455       if ((_rosterIndex > 0) || ((realWorldPlayers.length > 0) && (realWorldPlayers[0].md5Token == _md5Tokens[i]))) {
456         // _rosterIndex is valid
457         realWorldPlayers[_rosterIndex].mintingEnabled = _mintingEnabled[i];
458       } else {
459         // Tried to enable/disable minting on non-existent realWorldPlayer
460         revert();
461       }
462     }
463   }
464 
465   /// @dev Returns a boolean indicating whether or not a particular real world player is minting
466   /// @param _md5Token - The player to look at
467   function isRealWorldPlayerMintingEnabled(uint128 _md5Token) public view returns (bool) {
468     // Have to deal with the fact that the 0th entry is a valid one.
469     uint32 _rosterIndex = md5TokenToRosterIndex[_md5Token];
470     if ((_rosterIndex > 0) || ((realWorldPlayers.length > 0) && (realWorldPlayers[0].md5Token == _md5Token))) {
471       // _rosterIndex is valid
472       return realWorldPlayers[_rosterIndex].mintingEnabled;
473     } else {
474       // Tried to enable/disable minting on non-existent realWorldPlayer
475       revert();
476     }
477   }
478 
479   /// @dev Updates a particular realRealWorldPlayer. Note that the md5Token is immutable. Can only be
480   ///   called by the core contract.
481   /// @param _rosterIndex - Index into realWorldPlayers of the entry to change.
482   /// @param _prevCommissionerSalePrice - Average of the 2 most recent sale prices in commissioner auctions
483   /// @param _lastMintedTime - Time this real world player was last minted
484   /// @param _mintedCount - The number of playerTokens that have been minted for this player
485   /// @param _hasActiveCommissionerAuction - Whether or not there is an active commissioner auction for this player
486   /// @param _mintingEnabled - Denotes whether or not we should mint this real world player
487   function updateRealWorldPlayer(uint32 _rosterIndex, uint128 _prevCommissionerSalePrice, uint64 _lastMintedTime, uint32 _mintedCount, bool _hasActiveCommissionerAuction, bool _mintingEnabled) public onlyCoreContract {
488     require(_rosterIndex < realWorldPlayers.length);
489     RealWorldPlayer storage _realWorldPlayer = realWorldPlayers[_rosterIndex];
490     _realWorldPlayer.prevCommissionerSalePrice = _prevCommissionerSalePrice;
491     _realWorldPlayer.lastMintedTime = _lastMintedTime;
492     _realWorldPlayer.mintedCount = _mintedCount;
493     _realWorldPlayer.hasActiveCommissionerAuction = _hasActiveCommissionerAuction;
494     _realWorldPlayer.mintingEnabled = _mintingEnabled;
495   }
496 
497   /// @dev Marks a real world player record as having an active commissioner auction.
498   ///   Will throw if there is hasActiveCommissionerAuction was already true upon entry.
499   /// @param _rosterIndex - Index to the real world player record.
500   function setHasCommissionerAuction(uint32 _rosterIndex) public onlyCoreContract {
501     require(_rosterIndex < realWorldPlayers.length);
502     RealWorldPlayer storage _realWorldPlayer = realWorldPlayers[_rosterIndex];
503     require(!_realWorldPlayer.hasActiveCommissionerAuction);
504     _realWorldPlayer.hasActiveCommissionerAuction = true;
505   }
506 
507   /// @param _rosterIndex - Index into our roster that we want to record the fact that there is
508   ///   no longer an active commissioner auction.
509   /// @param _price - The price we want to record
510   function commissionerAuctionComplete(uint32 _rosterIndex, uint128 _price) public onlyCoreContract {
511     require(_rosterIndex < realWorldPlayers.length);
512     RealWorldPlayer storage _realWorldPlayer = realWorldPlayers[_rosterIndex];
513     require(_realWorldPlayer.hasActiveCommissionerAuction);
514     if (_realWorldPlayer.prevCommissionerSalePrice == 0) {
515       _realWorldPlayer.prevCommissionerSalePrice = _price;
516     } else {
517       _realWorldPlayer.prevCommissionerSalePrice = (_realWorldPlayer.prevCommissionerSalePrice + _price)/2;
518     }
519     _realWorldPlayer.hasActiveCommissionerAuction = false;
520 
521     // Finally, re-mint another player token for this realWorldPlayer and put him up for auction
522     // at the default pricing and duration (auto mint)
523     if (_realWorldPlayer.mintingEnabled) {
524       uint128[] memory _md5Tokens = new uint128[](1);
525       _md5Tokens[0] = _realWorldPlayer.md5Token;
526       minterContract.mintPlayers(_md5Tokens, 0, 0, 0);
527     }
528   }
529 
530   /// @param _rosterIndex - Index into our roster that we want to record the fact that there is
531   ///   no longer an active commissioner auction.
532   function commissionerAuctionCancelled(uint32 _rosterIndex) public view onlyCoreContract {
533     require(_rosterIndex < realWorldPlayers.length);
534     RealWorldPlayer storage _realWorldPlayer = realWorldPlayers[_rosterIndex];
535     require(_realWorldPlayer.hasActiveCommissionerAuction);
536 
537     // We do not clear the hasActiveCommissionerAuction bit on a cancel. This will
538     // continue to block the minting of new commissioner tokens (limiting supply).
539     // The only way this RWP can be back on a commissioner auction is by the commish
540     // putting the token corresponding to the canceled auction back on auction.
541   }
542 
543 }