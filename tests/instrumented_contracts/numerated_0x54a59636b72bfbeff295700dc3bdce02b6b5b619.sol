1 pragma solidity ^0.4.23;
2 
3 // Standard ERC721 functions import
4 contract ERC721 {
5   // Required methods
6   function approve(address _to, uint256 _tokenId) public;
7   function balanceOf(address _owner) public view returns (uint256 balance);
8   function implementsERC721() public pure returns (bool);
9   function ownerOf(uint256 _tokenId) public view returns (address addr);
10   function takeOwnership(uint256 _tokenId) public;
11   function totalSupply() public view returns (uint256 total);
12   function transferFrom(address _from, address _to, uint256 _tokenId) public;
13   function transfer(address _to, uint256 _tokenId) public;
14 
15   event Transfer(address indexed from, address indexed to, uint256 tokenId);
16   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
17 
18 }
19 
20 contract CryptoWorldCupToken is ERC721 {
21 
22   // ********************************************************************************************************
23   //    EVENTS
24   // ********************************************************************************************************
25   // @dev events to catch with web3/js
26   // ********************************************************************************************************
27 
28   /// @dev The NewPlayerCreated event is fired whenever a new Player comes into existence.
29   event NewPlayerCreated(uint256 tokenId, uint256 id, string prename, string surname, address owner, uint256 price);
30 
31   /// @dev The PlayerWasSold event is fired whenever a token is sold.
32   event PlayerWasSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string prename, string surname);
33 
34   /// @dev Transfer event as defined in current draft of ERC721.
35   ///  ownership is assigned, including NewPlayerCreateds.
36   event Transfer(address from, address to, uint256 tokenId);
37 
38   ///@dev Country won a game and all players prices increased by 5%
39   event countryWonAndPlayersValueIncreased(string country, string prename, string surname);
40 
41   ///@dev New User has been registered
42   event NewUserRegistered(string userName);
43 
44   // ********************************************************************************************************
45   // Constants
46   // ********************************************************************************************************
47   // @dev Definition of constants
48   // ********************************************************************************************************
49 
50   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
51   string public constant NAME = "CryptoWorldCup";
52   string public constant SYMBOL = "CryptoWorldCupToken";
53 
54   //@dev network fee address
55   address private netFee = 0x5e02f153d571C1FBB6851928975079812DF4c8cd;
56 
57   //@dev ether value to calculate the int-value prices
58   uint256 public myFinneyValue =  100 finney;
59   uint256 public myWeiValue = 1 wei;
60 
61   // presale boolean to enable selling
62   bool public presaleIsRunning;
63 
64    uint256 public currentwealth;
65 
66    // The addresses of the accounts (or contracts) that can execute actions within each roles.
67   address public ceoAddress;
68 
69   // ********************************************************************************************************
70   // Tracking Variables
71   // ********************************************************************************************************
72   // @dev Needed for smoother web3 calls
73   // ********************************************************************************************************
74   uint256 public totalTxVolume = 0;
75   uint256 public totalContractsAvailable = 0;
76   uint256 public totalContractHolders = 0;
77   uint256 public totalUsers = 0;
78 
79   // ********************************************************************************************************
80   // Storage
81   // ********************************************************************************************************
82   // @dev Mappings for easier access
83   // ********************************************************************************************************
84 
85   /// @dev A mapping from Player IDs to the address that owns them. All Players have
86   ///  some valid owner address.
87   mapping (uint256 => address) public PlayerIndexToOwner;
88 
89   // @dev A mapping from owner address to count of tokens that address owns.
90   //  Used internally inside balanceOf() to resolve ownership count.
91   mapping (address => uint256) private ownershipTokenCount;
92 
93   /// @dev A mapping from PlayerIDs to an address that has been approved to call
94   ///  transferFrom(). Each Player can only have one approved address for transfer
95   ///  at any time. A zero value means no approval is outstanding.
96   mapping (uint256 => address) public PlayerIndexToApproved;
97 
98   // @dev A mapping from PlayerIDs to the price of the token.
99   mapping (uint256 => uint256) private PlayerIndexToPrice;
100   mapping (uint256 => uint256) private PlayerInternalIndexToGlobalIndex;
101 
102   //@dev A mapping from the UserIDs to the usernames.
103   mapping (uint256 => address) private UserIDsToWallet;
104   mapping (uint256 => string) private UserIDToUsername;
105   mapping (address => uint256) private UserWalletToID;
106   mapping (address => bool) private isUser;
107 
108   mapping (address => uint256) private addressWealth;
109 
110   mapping (address => bool) blacklist;
111 
112   mapping (uint256 => PlayerIDs) PlayerIDsToUniqueID;
113 
114   // ********************************************************************************************************
115   // Individual datatypes
116   // ********************************************************************************************************
117   // @dev Structs to generate specific datatypes
118   // ********************************************************************************************************
119   struct Player {
120     uint256 id;
121     uint256 countryId;
122     string country;
123     string surname;
124     string middlename;
125     string prename;
126     string position;
127     uint256 age;
128     uint64 offensive;
129     uint64 defensive;
130     uint64 totalRating;
131     uint256 price;
132     string pictureUrl;
133     string flagUrl;
134   }
135 
136   Player[] private players;
137 
138   struct User{
139     uint256 id;
140     address userAddress;
141     string userName;
142   }
143 
144   User[] private users;
145 
146   struct PlayerIDs {
147         uint256 id;
148         uint256 countryId;
149   }
150 
151   PlayerIDs[] public PlayerIDsArrayForMapping;
152 
153   // ********************************************************************************************************
154   // Access modifiers
155   // ********************************************************************************************************
156   // @dev No need for the same require anymore
157   // ********************************************************************************************************
158   modifier onlyCEO() {
159     require(msg.sender == ceoAddress);
160     _;
161   }
162 
163   modifier onlyDuringPresale(){
164       require(presaleIsRunning);
165       _;
166   }
167 
168   // ********************************************************************************************************
169   // Constructor & Needed stuff
170   // ********************************************************************************************************
171   // @dev Called exactly once during the creation of the contract
172   // ********************************************************************************************************
173   constructor() public {
174     presaleIsRunning = true;
175     ceoAddress = msg.sender;
176   }
177 
178   function implementsERC721() public pure returns (bool) {
179     return true;
180   }
181 
182   /// @dev Required for ERC-721 compliance.
183   function name() public pure returns (string) {
184     return NAME;
185   }
186 
187   /// @dev Required for ERC-721 compliance.
188   function symbol() public pure returns (string) {
189     return SYMBOL;
190   }
191 
192   // ********************************************************************************************************
193   // ONLYCEO FUNKTIONS
194   // ********************************************************************************************************
195   // @dev All functions that are only executable by the owner of the contract
196   // ********************************************************************************************************
197 
198   function endPresale() public onlyCEO{
199     require(presaleIsRunning == true);
200     presaleIsRunning = false;
201   }
202 
203 
204   function blackListUser(address _address) public onlyCEO{
205       blacklist[_address] = true;
206   }
207 
208   function deleteUser(address _address) public onlyCEO{
209 
210       uint256 userID = getUserIDByWallet(_address) + 1;
211       delete users[userID];
212 
213       isUser[_address] = false;
214 
215       uint256 userIDForMappings = UserWalletToID[_address];
216 
217      delete UserIDsToWallet[userIDForMappings];
218      delete UserIDToUsername[userIDForMappings];
219      delete UserWalletToID[_address];
220 
221       totalUsers = totalUsers - 1;
222   }
223 
224   function payout(address _to) public onlyCEO {
225     _payout(_to);
226   }
227 
228   // ********************************************************************************************************
229   // ONLYCEO FUNCTIONS
230   // ********************************************************************************************************
231   // @dev All functions that are only executable by the owner of the contract
232   // PLAYER CREATIN RELATED
233   // ********************************************************************************************************
234 
235   function createPlayer(uint256 _id, uint256 _countryId, string _country, string _prename, string _middlename, string _surname, string _pictureUrl, string _flagUrl, address _owner, uint256 _price) public onlyCEO onlyDuringPresale{
236 
237     uint256 newPrice = SafeMath.mul(_price, myFinneyValue);
238 
239     Player memory _player = Player({
240      id: _id,
241      countryId: _countryId,
242      country: _country,
243      surname: _surname,
244      middlename: _middlename,
245      prename: _prename,
246      price: newPrice,
247      pictureUrl: _pictureUrl,
248      flagUrl: _flagUrl,
249      position: "",
250      age: 0,
251      offensive: 0,
252      defensive: 0,
253      totalRating: 0
254     });
255 
256     uint256 newPlayerId = players.push(_player) - 1;
257 
258     // It's probably never going to happen, 4 billion tokens are A LOT, but
259     // let's just be 100% sure we never let this happen.
260     require(newPlayerId == uint256(uint32(newPlayerId)));
261 
262     emit NewPlayerCreated(newPlayerId, newPlayerId, _prename, _surname, _owner, _price);
263 
264     addMappingForPlayerIDs (newPlayerId, _id, _countryId );
265 
266     PlayerIndexToPrice[newPlayerId] = newPrice;
267     PlayerInternalIndexToGlobalIndex[newPlayerId] = newPlayerId;
268 
269     currentwealth =   addressWealth[_owner];
270     addressWealth[_owner] = currentwealth + newPrice;
271 
272     totalTxVolume = totalTxVolume + newPrice;
273 
274     // This will assign ownership, and also emit the Transfer event as
275     // per ERC721 draft
276     _transfer(address(0), _owner, newPlayerId);
277 
278     totalContractsAvailable = totalContractsAvailable;
279 
280     if(numberOfTokensOfOwner(_owner) == 0 || numberOfTokensOfOwner(_owner) == 1){
281         totalContractHolders = totalContractHolders + 1;
282     }
283   }
284 
285   function deletePlayer (uint256 _uniqueID) public onlyCEO{
286       uint256 arrayPos = _uniqueID + 1;
287       address _owner = PlayerIndexToOwner[_uniqueID];
288 
289       currentwealth =   addressWealth[_owner];
290     addressWealth[_owner] = currentwealth + priceOf(_uniqueID);
291 
292     totalContractsAvailable = totalContractsAvailable - 1;
293 
294     if(numberOfTokensOfOwner(_owner) != 0 || numberOfTokensOfOwner(_owner) == 1){
295         totalContractHolders = totalContractHolders - 1;
296     }
297 
298       delete players[arrayPos];
299       delete PlayerIndexToOwner[_uniqueID];
300       delete PlayerIndexToPrice[_uniqueID];
301 
302   }
303 
304   function adjustPriceOfCountryPlayersAfterWin(uint256 _tokenId) public onlyCEO {
305     uint256 _price = SafeMath.mul(105, SafeMath.div(players[_tokenId].price, 100));
306     uint256 playerInternalIndex = _tokenId;
307     uint256 playerGlobalIndex = PlayerInternalIndexToGlobalIndex[playerInternalIndex];
308     PlayerIndexToPrice[playerGlobalIndex] = _price;
309 
310     emit countryWonAndPlayersValueIncreased(players[_tokenId].country, players[_tokenId].prename, players[_tokenId].surname);
311   }
312 
313   function adjustPriceAndOwnerOfPlayerDuringPresale(uint256 _tokenId, address _newOwner, uint256 _newPrice) public onlyCEO{
314     require(presaleIsRunning);
315     _newPrice = SafeMath.mul(_newPrice, myFinneyValue);
316     PlayerIndexToPrice[_tokenId] = _newPrice;
317     PlayerIndexToOwner[_tokenId] = _newOwner;
318   }
319 
320   function addPlayerData(uint256 _playerId, uint256 _countryId, string _position, uint256 _age, uint64 _offensive, uint64 _defensive, uint64 _totalRating) public onlyCEO{
321 
322        uint256 _id = getIDMapping(_playerId, _countryId);
323 
324        players[_id].position = _position;
325        players[_id].age = _age;
326        players[_id].offensive = _offensive;
327        players[_id].defensive = _defensive;
328        players[_id].totalRating = _totalRating;
329     }
330 
331 
332     function addMappingForPlayerIDs (uint256 _uniquePlayerId, uint256 _playerId, uint256 _countryId ) private{
333 
334         PlayerIDs memory _playerIdStruct = PlayerIDs({
335             id: _playerId,
336             countryId: _countryId
337         });
338 
339         PlayerIDsArrayForMapping.push(_playerIdStruct)-1;
340 
341         PlayerIDsToUniqueID[_uniquePlayerId] = _playerIdStruct;
342 
343     }
344 
345   // ********************************************************************************************************
346   // Helper FUNCTIONS
347   // ********************************************************************************************************
348   // @dev All functions that make our life easier
349   // ********************************************************************************************************
350 
351  /// For querying balance of a particular account
352   /// @param _owner The address for balance query
353   /// @dev Required for ERC-721 compliance.
354   function balanceOf(address _owner) public view returns (uint256 balance) {
355     return ownershipTokenCount[_owner];
356   }
357 
358   function isUserBlacklisted(address _address) public view returns (bool){
359       return blacklist[_address];
360   }
361 
362    function getPlayerFrontDataForMarketPlaceCards(uint256 _tokenId) public view returns (
363     uint256 _id,
364     uint256 _countryId,
365     string _country,
366     string _surname,
367     string _prename,
368     uint256 _sellingPrice,
369     string _picUrl,
370     string _flagUrl
371   ) {
372     Player storage player = players[_tokenId];
373     _id = player.id;
374     _countryId = player.countryId;
375     _country = player.country;
376     _surname = player.surname;
377     _prename = player.prename;
378     _sellingPrice = PlayerIndexToPrice[_tokenId];
379     _picUrl = player.pictureUrl;
380     _flagUrl = player.flagUrl;
381 
382     return (_id, _countryId, _country, _surname, _prename, _sellingPrice, _picUrl, _flagUrl);
383 
384   }
385 
386     function getPlayerBackDataForMarketPlaceCards(uint256 _tokenId) public view returns (
387     uint256 _id,
388     uint256 _countryId,
389     string _country,
390     string _surname,
391     string _prename,
392     string _position,
393     uint256 _age,
394     uint64 _offensive,
395     uint64 _defensive,
396     uint64 _totalRating
397   ) {
398     Player storage player = players[_tokenId];
399     _id = player.id;
400     _countryId = player.countryId;
401     _country = player.country;
402     _surname = player.surname;
403     _prename = player.prename;
404     _age = player.age;
405 
406     _position = player.position;
407     _offensive = player.offensive;
408     _defensive = player.defensive;
409     _totalRating = player.totalRating;
410 
411     return (_id, _countryId, _country, _surname, _prename, _position, _age, _offensive,_defensive, _totalRating);
412   }
413 
414   /// For querying owner of token
415   /// @param _tokenId The tokenID for owner inquiry
416   /// @dev Required for ERC-721 compliance.
417   function ownerOf(uint256 _tokenId)
418     public
419     view
420     returns (address owner)
421   {
422     owner = PlayerIndexToOwner[_tokenId];
423     require(owner != address(0));
424   }
425 
426   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
427     return PlayerIndexToPrice[_tokenId];
428   }
429 
430   function calcNetworkFee(uint256 _tokenId) public view returns (uint256 networkFee) {
431     uint256 price = PlayerIndexToPrice[_tokenId];
432     networkFee = SafeMath.div(price, 100);
433     return networkFee;
434   }
435 
436   function getLeaderBoardData(address _owner)public view returns (address _user, uint256 _token, uint _wealth){
437       _user = _owner;
438       _token = numberOfTokensOfOwner(_owner);
439       _wealth = getWealthOfUser(_owner);
440       return (_user, _token, _wealth);
441   }
442 
443   // ********************************************************************************************************
444   // GETTER FUNCTIONS
445   // ********************************************************************************************************
446   // @dev All functions that get us stuff
447   // ********************************************************************************************************
448 
449   function getUserByID(uint256 _id) public view returns (address _wallet, string _username){
450     _username = UserIDToUsername[_id];
451     _wallet = UserIDsToWallet[_id];
452     return (_wallet, _username);
453   }
454 
455    function getUserWalletByID(uint256 _id) public view returns (address _wallet){
456     _wallet = UserIDsToWallet[_id];
457     return (_wallet);
458   }
459 
460   function getUserNameByWallet(address _wallet) public view returns (string _username){
461     require(isAlreadyUser(_wallet));
462     uint256 _id = UserWalletToID[_wallet];
463     _username = UserIDToUsername[_id];
464     return _username;
465   }
466 
467   function getUserIDByWallet(address _wallet) public view returns (uint256 _id){
468     _id = UserWalletToID[_wallet];
469     return _id;
470   }
471 
472   function getUniqueIdOfPlayerByPlayerAndCountryID(uint256 _tokenId) public view returns (uint256 id){
473       uint256 idOfPlyaer = players[_tokenId].id;
474       return idOfPlyaer;
475   }
476 
477   function getIDMapping (uint256 _playerId, uint256 _countryId) public view returns (uint256 _uniqueId){
478 
479         for (uint64 x=0; x<totalSupply(); x++){
480             PlayerIDs memory _player = PlayerIDsToUniqueID[x];
481             if(_player.id == _playerId && _player.countryId == _countryId){
482                 _uniqueId = x;
483             }
484         }
485 
486         return _uniqueId;
487    }
488 
489   function getWealthOfUser(address _address) private view returns (uint256 _wealth){
490     return addressWealth[_address];
491   }
492 
493   // ********************************************************************************************************
494   // PURCHASE FUNCTIONS
495   // ********************************************************************************************************
496   // @dev Purchase related stuff
497   // ********************************************************************************************************
498 
499   function adjustAddressWealthOnSale(uint256 _tokenId, address _oldOwner, address _newOwner,uint256 _sellingPrice) private {
500         uint256 currentOldOwnerWealth = addressWealth[_oldOwner];
501         uint256 currentNewOwnerWealth = addressWealth[_newOwner];
502         addressWealth[_oldOwner] = currentOldOwnerWealth - _sellingPrice;
503         addressWealth[_newOwner] = currentNewOwnerWealth + PlayerIndexToPrice[_tokenId];
504     }
505 
506   // Allows someone to send ether and obtain the token
507   // HAS TOBE AMENDED SO THE FEE WILL SPLIT BETWEEN
508   // 1. THE CURRENT OWNER OF THE CONTRACT
509   // 2. THE PRIOR OWNERS OF THE CONTRACT
510   // 3. (OPTIONAL) THE NETWORK FEE - BUT COULD BE OBSOLETE, IF WE ARE THE VERY FIRST OWNER OF EVERY CONTRACT
511   function purchase(uint256 _tokenId) public payable {
512 
513     //check if presale is still running
514     require(presaleIsRunning == false);
515 
516     address oldOwner = PlayerIndexToOwner[_tokenId];
517     address newOwner = msg.sender;
518 
519     uint256 sellingPrice = PlayerIndexToPrice[_tokenId];
520     uint256 payment = SafeMath.mul(99,(SafeMath.div(PlayerIndexToPrice[_tokenId],100)));
521     uint256 networkFee  = calcNetworkFee(_tokenId);
522 
523     // Making sure token owner is not sending to self
524     require(oldOwner != newOwner);
525 
526     // Safety check to prevent against an unexpected 0x0 default.
527     require(_addressNotNull(newOwner));
528 
529     // Making sure sent amount is greater than or equal to the sellingPrice
530     require(msg.value >= sellingPrice);
531 
532     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
533 
534     PlayerIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 110), 100);
535 
536     _transfer(oldOwner, newOwner, _tokenId);
537 
538     // Pay previous tokenOwner if owner is not contract
539     if (oldOwner != address(this)) {
540       oldOwner.transfer(payment); //(1-0.06)
541     }
542 
543     emit PlayerWasSold(_tokenId, sellingPrice, PlayerIndexToPrice[_tokenId], oldOwner, newOwner, players[_tokenId].prename, players[_tokenId].surname);
544 
545     msg.sender.transfer(purchaseExcess);
546 
547     //send network fee
548     netFee.transfer(networkFee);
549 
550     totalTxVolume = totalTxVolume + msg.value;
551 
552     if(numberOfTokensOfOwner(msg.sender) == 1){
553         totalContractHolders = totalContractHolders + 1;
554     }
555 
556     if(numberOfTokensOfOwner(oldOwner) == 0){
557         totalContractHolders = totalContractHolders - 1;
558     }
559 
560     adjustAddressWealthOnSale(_tokenId, oldOwner, newOwner,sellingPrice);
561 
562   }
563 
564   /// @notice Allow pre-approved user to take ownership of a token
565   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
566   /// @dev Required for ERC-721 compliance.
567   function takeOwnership(uint256 _tokenId) public {
568     address newOwner = msg.sender;
569     address oldOwner = PlayerIndexToOwner[_tokenId];
570 
571     // Safety check to prevent against an unexpected 0x0 default.
572     require(_addressNotNull(newOwner));
573 
574     // Making sure transfer is approved
575     require(_approved(newOwner, _tokenId));
576 
577     _transfer(oldOwner, newOwner, _tokenId);
578   }
579 
580   /// @param _owner The owner whose celebrity tokens we are interested in.
581   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
582   ///  expensive (it walks the entire Players array looking for Players belonging to owner),
583   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
584   ///  not contract-to-contract calls.
585   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
586     uint256 tokenCount = balanceOf(_owner);
587     if (tokenCount == 0) {
588         // Return an empty array
589       return new uint256[](0);
590     } else {
591       uint256[] memory result = new uint256[](tokenCount);
592       uint256 totalPlayers = totalSupply();
593       uint256 resultIndex = 0;
594 
595       uint256 PlayerId;
596       for (PlayerId = 0; PlayerId <= totalPlayers; PlayerId++) {
597         if (PlayerIndexToOwner[PlayerId] == _owner) {
598           result[resultIndex] = PlayerId;
599           resultIndex++;
600         }
601       }
602       return result;
603     }
604   }
605 
606   function numberOfTokensOfOwner(address _owner) private view returns(uint256 numberOfTokens){
607       return tokensOfOwner(_owner).length;
608   }
609 
610   /// For querying totalSupply of token
611   /// @dev Required for ERC-721 compliance.
612   function totalSupply() public view returns (uint256 total) {
613     return players.length;
614   }
615 
616   /// Owner initates the transfer of the token to another account
617   /// @param _to The address for the token to be transferred to.
618   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
619   /// @dev Required for ERC-721 compliance.
620   function transfer(
621     address _to,
622     uint256 _tokenId
623   ) public {
624     require(_owns(msg.sender, _tokenId));
625     require(_addressNotNull(_to));
626 
627     _transfer(msg.sender, _to, _tokenId);
628   }
629 
630   /// Third-party initiates transfer of token from address _from to address _to
631   /// @param _from The address for the token to be transferred from.
632   /// @param _to The address for the token to be transferred to.
633   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
634   /// @dev Required for ERC-721 compliance.
635   function transferFrom(
636     address _from,
637     address _to,
638     uint256 _tokenId
639   ) public {
640     require(_owns(_from, _tokenId));
641     require(_approved(_to, _tokenId));
642     require(_addressNotNull(_to));
643 
644     _transfer(_from, _to, _tokenId);
645   }
646 
647   // ********************************************************************************************************
648   // USER FUNCTIONS
649   // ********************************************************************************************************
650   // @dev User related stuff
651   // ********************************************************************************************************
652  /// For creating players
653 
654   function createNewUser(address _address, string _username) public {
655 
656     require(!blacklist[_address]);
657     require(!isAlreadyUser(_address));
658 
659     uint256 userIdForMapping = users.length;
660 
661     User memory _user = User({
662       id: userIdForMapping,
663       userAddress: _address,
664       userName: _username
665     });
666 
667 
668     uint256 newUserId = users.push(_user) - 1;
669 
670     // It's probably never going to happen, 4 billion tokens are A LOT, but
671     // let's just be 100% sure we never let this happen.
672     require(newUserId == uint256(uint32(newUserId)));
673 
674     emit NewUserRegistered(_username);
675 
676     UserIDsToWallet[userIdForMapping] = _address;
677     UserIDToUsername[userIdForMapping] = _username;
678     UserWalletToID[_address] = userIdForMapping;
679     isUser[_address] = true;
680 
681     totalUsers = totalUsers + 1;
682   }
683 
684   function isAlreadyUser(address _address) public view returns (bool status){
685     if (isUser[_address]){
686       return true;
687     } else {
688       return false;
689     }
690   }
691 
692   /*** PRIVATE FUNCTIONS ***/
693   /// Safety check on _to address to prevent against an unexpected 0x0 default.
694   function _addressNotNull(address _to) private pure returns (bool) {
695     return _to != address(0);
696   }
697 
698 
699   // ********************************************************************************************************
700   //FIX FUNKTIONS
701   // ********************************************************************************************************
702   // @dev possibility to adjust single data fields of players during presale
703   // ********************************************************************************************************
704 
705     function fixPlayerID(uint256 _uniqueID, uint256 _playerID) public onlyCEO onlyDuringPresale{
706         players[_uniqueID].id = _playerID;
707     }
708 
709       function fixPlayerCountryId(uint256 _uniqueID, uint256 _countryID) public onlyCEO onlyDuringPresale{
710         players[_uniqueID].countryId = _countryID;
711     }
712 
713     function fixPlayerCountryString(uint256 _uniqueID, string _country) public onlyCEO onlyDuringPresale{
714         players[_uniqueID].country = _country;
715     }
716 
717     function fixPlayerPrename(uint256 _uniqueID, string _prename) public onlyCEO onlyDuringPresale{
718         players[_uniqueID].prename = _prename;
719     }
720 
721     function fixPlayerMiddlename(uint256 _uniqueID, string _middlename) public onlyCEO onlyDuringPresale{
722          players[_uniqueID].middlename = _middlename;
723     }
724 
725     function fixPlayerSurname(uint256 _uniqueID, string _surname) public onlyCEO onlyDuringPresale{
726          players[_uniqueID].surname = _surname;
727     }
728 
729     function fixPlayerFlag(uint256 _uniqueID, string _flag) public onlyCEO onlyDuringPresale{
730          players[_uniqueID].flagUrl = _flag;
731     }
732 
733     function fixPlayerGraphic(uint256 _uniqueID, string _pictureUrl) public onlyCEO onlyDuringPresale{
734          players[_uniqueID].pictureUrl = _pictureUrl;
735     }
736 
737 
738 
739   // ********************************************************************************************************
740   // LEGACY FUNCTIONS
741   // ********************************************************************************************************
742   // @dev
743   // ********************************************************************************************************
744  /// For creating players
745   /*** PUBLIC FUNCTIONS ***/
746   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
747   /// @param _to The address to be granted transfer approval. Pass address(0) to
748   ///  clear all approvals.
749   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
750   /// @dev Required for ERC-721 compliance.
751   function approve(
752     address _to,
753     uint256 _tokenId
754   ) public {
755     // Caller must own token.
756     require(_owns(msg.sender, _tokenId));
757 
758     PlayerIndexToApproved[_tokenId] = _to;
759 
760     emit Approval(msg.sender, _to, _tokenId);
761   }
762 
763   /// For checking approval of transfer for address _to
764   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
765     return PlayerIndexToApproved[_tokenId] == _to;
766   }
767 
768   /// Check for token ownership
769   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
770     return claimant == PlayerIndexToOwner[_tokenId];
771   }
772 
773   /// For paying out balance on contract
774   function _payout(address _to) private {
775     if (_to == address(0)) {
776         ceoAddress.transfer(address(this).balance);
777     } else {
778       _to.transfer(address(this).balance);
779     }
780   }
781 
782   /// @dev Assigns ownership of a specific Player to an address.
783   function _transfer(address _from, address _to, uint256 _tokenId) private {
784     // Since the number of Players is capped to 2^32 we can't overflow this
785     ownershipTokenCount[_to]++;
786     //transfer ownership
787     PlayerIndexToOwner[_tokenId] = _to;
788 
789     // When creating new Players _from is 0x0, but we can't account that address.
790     if (_from != address(0)) {
791       ownershipTokenCount[_from]--;
792       // clear any previously approved ownership exchange
793       delete PlayerIndexToApproved[_tokenId];
794     }
795 
796     // Emit the transfer event.
797     emit Transfer(_from, _to, _tokenId);
798   }
799 }
800 
801 library SafeMath {
802 
803   /**
804   * @dev Multiplies two numbers, throws on overflow.
805   */
806   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
807     if (a == 0) {
808       return 0;
809     }
810     uint256 c = a * b;
811     assert(c / a == b);
812     return c;
813   }
814 
815   /**
816   * @dev Integer division of two numbers, truncating the quotient.
817   */
818   function div(uint256 a, uint256 b) internal pure returns (uint256) {
819     // assert(b > 0); // Solidity automatically throws when dividing by 0
820     uint256 c = a / b;
821     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
822     return c;
823   }
824 
825   /**
826   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
827   */
828   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
829     assert(b <= a);
830     return a - b;
831   }
832 
833   /**
834   * @dev Adds two numbers, throws on overflow.
835   */
836   function add(uint256 a, uint256 b) internal pure returns (uint256) {
837     uint256 c = a + b;
838     assert(c >= a);
839     return c;
840   }
841 }