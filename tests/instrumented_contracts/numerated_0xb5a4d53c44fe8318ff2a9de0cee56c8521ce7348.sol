1 pragma solidity 0.4.19;
2 
3 
4 contract Admin {
5     address public godAddress;
6     address public managerAddress;
7     address public bursarAddress;
8 
9     // God has more priviledges than other admins
10     modifier requireGod() {
11         require(msg.sender == godAddress);
12         _;
13     }
14 
15     modifier requireManager() {
16         require(msg.sender == managerAddress);
17         _;
18     }
19 
20     modifier requireAdmin() {
21         require(msg.sender == managerAddress || msg.sender == godAddress);
22         _;
23     }
24 
25     modifier requireBursar() {
26         require(msg.sender == bursarAddress);
27       _;
28     }
29 
30     /// @notice Assigns a new address to act as the God. Only available to the current God.
31     /// @param _newGod The address of the new God
32     function setGod(address _newGod) external requireGod {
33         require(_newGod != address(0));
34 
35         godAddress = _newGod;
36     }
37 
38     /// @notice Assigns a new address to act as the Manager. Only available to the current God.
39     /// @param _newManager The address of the new Manager
40     function setManager(address _newManager) external requireGod {
41         require(_newManager != address(0));
42 
43         managerAddress = _newManager;
44     }
45 
46     /// @notice Assigns a new address to act as the Bursar. Only available to the current God.
47     /// @param _newBursar The address of the new Bursar
48     function setBursar(address _newBursar) external requireGod {
49         require(_newBursar != address(0));
50 
51         bursarAddress = _newBursar;
52     }
53 
54     /// @notice !!! COMPLETELY DESTROYS THE CONTRACT !!!
55     function destroy() external requireGod {
56         selfdestruct(godAddress);
57     }
58 }
59 
60 
61 
62 contract Pausable is Admin {
63     bool public paused = false;
64 
65     modifier whenNotPaused() {
66         require(!paused);
67         _;
68     }
69 
70     modifier whenPaused {
71         require(paused);
72         _;
73     }
74 
75     function pause() external requireAdmin whenNotPaused {
76         paused = true;
77     }
78 
79     function unpause() external requireGod whenPaused {
80         paused = false;
81     }
82 }
83 
84 
85 contract CryptoFamousBase is Pausable {
86 
87   // DATA TYPES
88   struct Card {
89         // Social network type id (1 - Twitter, others TBD)
90         uint8 socialNetworkType;
91         // The social network id of the social account backing this card.
92         uint64 socialId;
93         // The ethereum address that most recently claimed this card.
94         address claimer;
95         // Increased whenever the card is claimed by an address
96         uint16 claimNonce;
97         // Reserved for future use
98         uint8 reserved1;
99   }
100 
101   struct SaleInfo {
102       uint128 timestamp;
103       uint128 price;
104   }
105 
106 }
107 
108 
109 contract CryptoFamousOwnership is CryptoFamousBase {
110   // EVENTS
111   /// @dev emitted when a new Card is created. Can happen when a social identity is claimed or stolen for the first time.
112   event CardCreated(uint256 indexed cardId, uint8 socialNetworkType, uint64 socialId, address claimer, address indexed owner);
113 
114   // STORAGE
115   /// @dev contains all the Cards in the system. Card with ID 0 is invalid.
116   Card[] public allCards;
117 
118   /// @dev SocialNetworkType -> (SocialId -> CardId)
119   mapping (uint8 => mapping (uint64 => uint256)) private socialIdentityMappings;
120 
121   /// @dev getter for `socialIdentityMappings`
122   function socialIdentityToCardId(uint256 _socialNetworkType, uint256 _socialId) public view returns (uint256 cardId) {
123     uint8 _socialNetworkType8 = uint8(_socialNetworkType);
124     require(_socialNetworkType == uint256(_socialNetworkType8));
125 
126     uint64 _socialId64 = uint64(_socialId);
127     require(_socialId == uint256(_socialId64));
128 
129     cardId = socialIdentityMappings[_socialNetworkType8][_socialId64];
130     return cardId;
131   }
132 
133   mapping (uint8 => mapping (address => uint256)) private claimerAddressToCardIdMappings;
134 
135   /// @dev returns the last Card ID claimed by `_claimerAddress` in network with `_socialNetworkType`
136   function lookUpClaimerAddress(uint256 _socialNetworkType, address _claimerAddress) public view returns (uint256 cardId) {
137     uint8 _socialNetworkType8 = uint8(_socialNetworkType);
138     require(_socialNetworkType == uint256(_socialNetworkType8));
139 
140     cardId = claimerAddressToCardIdMappings[_socialNetworkType8][_claimerAddress];
141     return cardId;
142   }
143 
144   /// @dev A mapping from Card ID to the timestamp of the first completed Claim of that Card
145   mapping (uint256 => uint128) public cardIdToFirstClaimTimestamp;
146 
147   /// @dev A mapping from Card ID to the current owner address of that Card
148   mapping (uint256 => address) public cardIdToOwner;
149 
150   /// @dev A mapping from owner address to the number of Cards currently owned by it
151   mapping (address => uint256) internal ownerAddressToCardCount;
152 
153   function _changeOwnership(address _from, address _to, uint256 _cardId) internal whenNotPaused {
154       ownerAddressToCardCount[_to]++;
155       cardIdToOwner[_cardId] = _to;
156 
157       if (_from != address(0)) {
158           ownerAddressToCardCount[_from]--;
159       }
160   }
161 
162   function _recordFirstClaimTimestamp(uint256 _cardId) internal {
163     cardIdToFirstClaimTimestamp[_cardId] = uint128(now); //solhint-disable-line not-rely-on-time
164   }
165 
166   function _createCard(
167       uint256 _socialNetworkType,
168       uint256 _socialId,
169       address _owner,
170       address _claimer
171   )
172       internal
173       whenNotPaused
174       returns (uint256)
175   {
176       uint8 _socialNetworkType8 = uint8(_socialNetworkType);
177       require(_socialNetworkType == uint256(_socialNetworkType8));
178 
179       uint64 _socialId64 = uint64(_socialId);
180       require(_socialId == uint256(_socialId64));
181 
182       uint16 claimNonce = 0;
183       if (_claimer != address(0)) {
184         claimNonce = 1;
185       }
186 
187       Card memory _card = Card({
188           socialNetworkType: _socialNetworkType8,
189           socialId: _socialId64,
190           claimer: _claimer,
191           claimNonce: claimNonce,
192           reserved1: 0
193       });
194       uint256 newCardId = allCards.push(_card) - 1;
195       socialIdentityMappings[_socialNetworkType8][_socialId64] = newCardId;
196 
197       if (_claimer != address(0)) {
198         claimerAddressToCardIdMappings[_socialNetworkType8][_claimer] = newCardId;
199         _recordFirstClaimTimestamp(newCardId);
200       }
201 
202       // event CardCreated(uint256 indexed cardId, uint8 socialNetworkType, uint64 socialId, address claimer, address indexed owner);
203       CardCreated(
204           newCardId,
205           _socialNetworkType8,
206           _socialId64,
207           _claimer,
208           _owner
209       );
210 
211       _changeOwnership(0, _owner, newCardId);
212 
213       return newCardId;
214   }
215 
216   /// @dev Returns the toal number of Cards in existence
217   function totalNumberOfCards() public view returns (uint) {
218       return allCards.length - 1;
219   }
220 
221   /// @notice Returns a list of all Card IDs currently owned by `_owner`
222   /// @dev (this thing iterates, don't call from smart contract code)
223   function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
224       uint256 tokenCount = ownerAddressToCardCount[_owner];
225 
226       if (tokenCount == 0) {
227           return new uint256[](0);
228       }
229 
230       uint256[] memory result = new uint256[](tokenCount);
231       uint256 total = totalNumberOfCards();
232       uint256 resultIndex = 0;
233 
234       uint256 cardId;
235 
236       for (cardId = 1; cardId <= total; cardId++) {
237           if (cardIdToOwner[cardId] == _owner) {
238               result[resultIndex] = cardId;
239               resultIndex++;
240           }
241       }
242 
243       return result;
244   }
245 }
246 
247 
248 contract CryptoFamousStorage is CryptoFamousOwnership {
249   function CryptoFamousStorage() public {
250       godAddress = msg.sender;
251       managerAddress = msg.sender;
252       bursarAddress = msg.sender;
253 
254       // avoid zero identifiers
255       _createCard(0, 0, address(0), address(0));
256   }
257 
258   function() external payable {
259       // just let msg.value be added to this.balance
260       FallbackEtherReceived(msg.sender, msg.value);
261   }
262 
263   event FallbackEtherReceived(address from, uint256 value);
264 
265   /// @dev Only this address will be allowed to call functions marked with `requireAuthorizedLogicContract`
266   address public authorizedLogicContractAddress;
267   modifier requireAuthorizedLogicContract() {
268       require(msg.sender == authorizedLogicContractAddress);
269       _;
270   }
271 
272   /// @dev mapping from Card ID to information about that card's last trade
273   mapping (uint256 => SaleInfo) public cardIdToSaleInfo;
274 
275   /// @dev mapping from Card ID to the current value stashed away for a future claimer
276   mapping (uint256 => uint256) public cardIdToStashedPayout;
277   /// @dev total amount of stashed payouts
278   uint256 public totalStashedPayouts;
279 
280   /// @dev if we fail to send any value to a Card's previous owner as part of the
281   /// invite/steal transaction we'll hold it in this contract. This mapping records the amount
282   /// owed to that "previous owner".
283   mapping (address => uint256) public addressToFailedOldOwnerTransferAmount;
284   /// @dev total amount of failed old owner transfers
285   uint256 public totalFailedOldOwnerTransferAmounts;
286 
287   /// @dev mapping from Card ID to that card's current perk text
288   mapping (uint256 => string) public cardIdToPerkText;
289 
290   function authorized_setCardPerkText(uint256 _cardId, string _perkText) external requireAuthorizedLogicContract {
291     cardIdToPerkText[_cardId] = _perkText;
292   }
293 
294   function setAuthorizedLogicContractAddress(address _newAuthorizedLogicContractAddress) external requireGod {
295     authorizedLogicContractAddress = _newAuthorizedLogicContractAddress;
296   }
297 
298   function authorized_changeOwnership(address _from, address _to, uint256 _cardId) external requireAuthorizedLogicContract {
299     _changeOwnership(_from, _to, _cardId);
300   }
301 
302   function authorized_createCard(uint256 _socialNetworkType, uint256 _socialId, address _owner, address _claimer) external requireAuthorizedLogicContract returns (uint256) {
303     return _createCard(_socialNetworkType, _socialId, _owner, _claimer);
304   }
305 
306   function authorized_updateSaleInfo(uint256 _cardId, uint256 _sentValue) external requireAuthorizedLogicContract {
307     cardIdToSaleInfo[_cardId] = SaleInfo(uint128(now), uint128(_sentValue)); // solhint-disable-line not-rely-on-time
308   }
309 
310   function authorized_updateCardClaimerAddress(uint256 _cardId, address _claimerAddress) external requireAuthorizedLogicContract {
311     Card storage card = allCards[_cardId];
312     if (card.claimer == address(0)) {
313       _recordFirstClaimTimestamp(_cardId);
314     }
315     card.claimer = _claimerAddress;
316     card.claimNonce += 1;
317   }
318 
319   function authorized_updateCardReserved1(uint256 _cardId, uint8 _reserved) external requireAuthorizedLogicContract {
320     uint8 _reserved8 = uint8(_reserved);
321     require(_reserved == uint256(_reserved8));
322 
323     Card storage card = allCards[_cardId];
324     card.reserved1 = _reserved8;
325   }
326 
327   function authorized_triggerStashedPayoutTransfer(uint256 _cardId) external requireAuthorizedLogicContract {
328     Card storage card = allCards[_cardId];
329     address claimerAddress = card.claimer;
330 
331     require(claimerAddress != address(0));
332 
333     uint256 stashedPayout = cardIdToStashedPayout[_cardId];
334 
335     require(stashedPayout > 0);
336 
337     cardIdToStashedPayout[_cardId] = 0;
338     totalStashedPayouts -= stashedPayout;
339 
340     claimerAddress.transfer(stashedPayout);
341   }
342 
343   function authorized_recordStashedPayout(uint256 _cardId) external payable requireAuthorizedLogicContract {
344       cardIdToStashedPayout[_cardId] += msg.value;
345       totalStashedPayouts += msg.value;
346   }
347 
348   function authorized_recordFailedOldOwnerTransfer(address _oldOwner) external payable requireAuthorizedLogicContract {
349       addressToFailedOldOwnerTransferAmount[_oldOwner] += msg.value;
350       totalFailedOldOwnerTransferAmounts += msg.value;
351   }
352 
353   // solhint-disable-next-line no-empty-blocks
354   function authorized_recordPlatformFee() external payable requireAuthorizedLogicContract {
355       // just let msg.value be added to this.balance
356   }
357 
358   /// @dev returns the current contract balance after subtracting the amounts stashed away for others
359   function netContractBalance() public view returns (uint256 balance) {
360     balance = this.balance - totalStashedPayouts - totalFailedOldOwnerTransferAmounts;
361     return balance;
362   }
363 
364   /// @dev the Bursar account can use this to withdraw the contract's net balance
365   function bursarPayOutNetContractBalance(address _to) external requireBursar {
366       uint256 payout = netContractBalance();
367 
368       if (_to == address(0)) {
369           bursarAddress.transfer(payout);
370       } else {
371           _to.transfer(payout);
372       }
373   }
374 
375   /// @dev Any wallet owed value that's recorded under `addressToFailedOldOwnerTransferAmount`
376   /// can use this function to withdraw that value.
377   function withdrawFailedOldOwnerTransferAmount() external whenNotPaused {
378       uint256 failedTransferAmount = addressToFailedOldOwnerTransferAmount[msg.sender];
379 
380       require(failedTransferAmount > 0);
381 
382       addressToFailedOldOwnerTransferAmount[msg.sender] = 0;
383       totalFailedOldOwnerTransferAmounts -= failedTransferAmount;
384 
385       msg.sender.transfer(failedTransferAmount);
386   }
387 }
388 
389 
390 contract CryptoFamous is CryptoFamousBase {
391     function CryptoFamous(address _storageContractAddress) public {
392         godAddress = msg.sender;
393         managerAddress = msg.sender;
394         bursarAddress = msg.sender;
395         verifierAddress = msg.sender;
396         storageContract = CryptoFamousStorage(_storageContractAddress);
397     }
398 
399     function() external payable {
400         // just let msg.value be added to this.balance
401         FallbackEtherReceived(msg.sender, msg.value);
402     }
403 
404     event FallbackEtherReceived(address from, uint256 value);
405 
406     event EconomyParametersUpdated(uint128 _newMinCardPrice, uint128 _newInitialCardPrice, uint128 _newPurchasePremiumRate, uint128 _newHourlyValueDecayRate, uint128 _newOwnerTakeShare, uint128 _newCardTakeShare, uint128 _newPlatformFeeRate);
407 
408     /// @dev Fired whenever a Card is stolen.
409     event CardStealCompleted(uint256 indexed cardId, address claimer, uint128 oldPrice, uint128 sentValue, address indexed prevOwner, address indexed newOwner, uint128 totalOwnerPayout, uint128 totalCardPayout);
410 
411     /// @dev Fired whenever a Card is claimed.
412     event CardClaimCompleted(uint256 indexed cardId, address previousClaimer, address newClaimer, address indexed owner);
413 
414     /// @dev Fired whenever a Card's perk text is updated.
415     event CardPerkTextUpdated(uint256 indexed cardId, string newPerkText);
416 
417     /// @notice Reference to the contract that handles the creation and ownership changes between cards.
418     CryptoFamousStorage public storageContract;
419 
420     uint16 private constant TWITTER = 1;
421 
422     // solhint-disable-next-line var-name-mixedcase
423     uint128 public MIN_CARD_PRICE = 0.01 ether;
424     function _setMinCardPrice(uint128 _newMinCardPrice) private {
425         MIN_CARD_PRICE = _newMinCardPrice;
426     }
427 
428     // solhint-disable-next-line var-name-mixedcase
429     uint128 public INITIAL_CARD_PRICE = 0.01 ether;
430     function _setInitialCardPrice(uint128 _newInitialCardPrice) private {
431         INITIAL_CARD_PRICE = _newInitialCardPrice;
432     }
433 
434     // solhint-disable-next-line var-name-mixedcase
435     uint128 public PURCHASE_PREMIUM_RATE = 10000; // basis points OF LAST SALE PRICE
436     function _setPurchasePremiumRate(uint128 _newPurchasePremiumRate) private {
437         PURCHASE_PREMIUM_RATE = _newPurchasePremiumRate;
438     }
439 
440     // solhint-disable-next-line var-name-mixedcase
441     uint128 public HOURLY_VALUE_DECAY_RATE = 21; // basis points OF STARTING PRICE
442     function _setHourlyValueDecayRate(uint128 _newHourlyValueDecayRate) private {
443         HOURLY_VALUE_DECAY_RATE = _newHourlyValueDecayRate;
444     }
445 
446     // solhint-disable var-name-mixedcase
447     uint128 public OWNER_TAKE_SHARE = 5000; // basis points OF PROFIT
448     uint128 public CARD_TAKE_SHARE = 5000; // basis points OF PROFIT
449     // solhint-enable var-name-mixedcase
450 
451     function _setProfitSharingParameters(uint128 _newOwnerTakeShare, uint128 _newCardTakeShare) private {
452       require(_newOwnerTakeShare + _newCardTakeShare == 10000);
453 
454       OWNER_TAKE_SHARE = _newOwnerTakeShare;
455       CARD_TAKE_SHARE = _newCardTakeShare;
456     }
457 
458     // solhint-disable-next-line var-name-mixedcase
459     uint128 public PLATFORM_FEE_RATE = 600; // basis points OF PROFIT
460     function _setPlatformFeeRate(uint128 _newPlatformFeeRate) private {
461         require(_newPlatformFeeRate < 10000);
462         PLATFORM_FEE_RATE = _newPlatformFeeRate;
463     }
464 
465     /// @dev Used to update all the parameters of the economy in one go
466     function setEconomyParameters(uint128 _newMinCardPrice, uint128 _newInitialCardPrice, uint128 _newPurchasePremiumRate, uint128 _newHourlyValueDecayRate, uint128 _newOwnerTakeShare, uint128 _newCardTakeShare, uint128 _newPlatformFeeRate) external requireAdmin {
467         _setMinCardPrice(_newMinCardPrice);
468         _setInitialCardPrice(_newInitialCardPrice);
469         _setPurchasePremiumRate(_newPurchasePremiumRate);
470         _setHourlyValueDecayRate(_newHourlyValueDecayRate);
471         _setProfitSharingParameters(_newOwnerTakeShare, _newCardTakeShare);
472         _setPlatformFeeRate(_newPlatformFeeRate);
473         EconomyParametersUpdated(_newMinCardPrice, _newInitialCardPrice, _newPurchasePremiumRate, _newHourlyValueDecayRate, _newOwnerTakeShare, _newCardTakeShare, _newPlatformFeeRate);
474     }
475 
476     address public verifierAddress;
477     /// @notice Assigns a new address to act as the Verifier. Only available to the current God.
478     /// @notice The Verifier address is used to confirm the authenticity of the claim signature.
479     /// @param _newVerifier The address of the new Verifier
480     function setVerifier(address _newVerifier) external requireGod {
481         require(_newVerifier != address(0));
482 
483         verifierAddress = _newVerifier;
484     }
485 
486     // mimicking eth_sign.
487     function prefixed(bytes32 hash) private pure returns (bytes32) {
488         return keccak256("\x19Ethereum Signed Message:\n32", hash);
489     }
490 
491     function claimTwitterId(uint256 _twitterId, address _claimerAddress, uint8 _v, bytes32 _r, bytes32 _s) external whenNotPaused returns (uint256) {
492       return _claimSocialNetworkIdentity(TWITTER, _twitterId, _claimerAddress, _v, _r, _s);
493     }
494 
495     function claimSocialNetworkIdentity(uint256 _socialNetworkType, uint256 _socialId, address _claimerAddress, uint8 _v, bytes32 _r, bytes32 _s) external whenNotPaused returns (uint256) {
496       return _claimSocialNetworkIdentity(_socialNetworkType, _socialId, _claimerAddress, _v, _r, _s);
497     }
498 
499     /// @dev claiming a social identity requires a signature provided by the CryptoFamous backend
500     /// to verify the authenticity of the claim. Once a Card is claimed by an address, that address
501     /// has access to the Card's current and future earnings on the system.
502     function _claimSocialNetworkIdentity(uint256 _socialNetworkType, uint256 _socialId, address _claimerAddress, uint8 _v, bytes32 _r, bytes32 _s) private returns (uint256) {
503       uint8 _socialNetworkType8 = uint8(_socialNetworkType);
504       require(_socialNetworkType == uint256(_socialNetworkType8));
505 
506       uint64 _socialId64 = uint64(_socialId);
507       require(_socialId == uint256(_socialId64));
508 
509       uint256 cardId = storageContract.socialIdentityToCardId(_socialNetworkType8, _socialId64);
510 
511       uint16 claimNonce = 0;
512       if (cardId != 0) {
513         (, , , claimNonce, ) = storageContract.allCards(cardId);
514       }
515 
516       bytes32 prefixedAndHashedAgain = prefixed(
517         keccak256(
518           _socialNetworkType, _socialId, _claimerAddress, uint256(claimNonce)
519         )
520       );
521 
522       address recoveredSignerAddress = ecrecover(prefixedAndHashedAgain, _v, _r, _s);
523       require(recoveredSignerAddress == verifierAddress);
524 
525       if (cardId == 0) {
526         return storageContract.authorized_createCard(_socialNetworkType8, _socialId64, _claimerAddress, _claimerAddress);
527       } else {
528         _claimExistingCard(cardId, _claimerAddress);
529         return cardId;
530       }
531     }
532 
533     function _claimExistingCard(uint256 _cardId, address _claimerAddress) private {
534         address previousClaimer;
535         (, , previousClaimer, ,) = storageContract.allCards(_cardId);
536         address owner = storageContract.cardIdToOwner(_cardId);
537 
538         _updateCardClaimerAddress(_cardId, _claimerAddress);
539 
540         CardClaimCompleted(_cardId, previousClaimer, _claimerAddress, owner);
541 
542         uint256 stashedPayout = storageContract.cardIdToStashedPayout(_cardId);
543         if (stashedPayout > 0) {
544           _triggerStashedPayoutTransfer(_cardId);
545         }
546     }
547 
548     /// @dev The Card's perk text is displayed prominently on its profile and will likely be
549     /// used for promotional reasons.
550     function setCardPerkText(uint256 _cardId, string _perkText) external whenNotPaused {
551       address cardClaimer;
552       (, , cardClaimer, , ) = storageContract.allCards(_cardId);
553 
554       require(cardClaimer == msg.sender);
555 
556       require(bytes(_perkText).length <= 280);
557 
558       _updateCardPerkText(_cardId, _perkText);
559       CardPerkTextUpdated(_cardId, _perkText);
560     }
561 
562     function stealCardWithTwitterId(uint256 _twitterId) external payable whenNotPaused {
563       _stealCardWithSocialIdentity(TWITTER, _twitterId);
564     }
565 
566     function stealCardWithSocialIdentity(uint256 _socialNetworkType, uint256 _socialId) external payable whenNotPaused {
567       _stealCardWithSocialIdentity(_socialNetworkType, _socialId);
568     }
569 
570     function _stealCardWithSocialIdentity(uint256 _socialNetworkType, uint256 _socialId) private {
571       // Avoid zeroth
572       require(_socialId != 0);
573 
574       uint8 _socialNetworkType8 = uint8(_socialNetworkType);
575       require(_socialNetworkType == uint256(_socialNetworkType8));
576 
577       uint64 _socialId64 = uint64(_socialId);
578       require(_socialId == uint256(_socialId64));
579 
580       uint256 cardId = storageContract.socialIdentityToCardId(_socialNetworkType8, _socialId64);
581       if (cardId == 0) {
582         cardId = storageContract.authorized_createCard(_socialNetworkType8, _socialId64, address(0), address(0));
583         _stealCardWithId(cardId);
584       } else {
585         _stealCardWithId(cardId);
586       }
587     }
588 
589     function stealCardWithId(uint256 _cardId) external payable whenNotPaused {
590       // Avoid zeroth
591       require(_cardId != 0);
592 
593       _stealCardWithId(_cardId);
594     }
595 
596     function claimTwitterIdIfNeededThenStealCardWithTwitterId(
597       uint256 _twitterIdToClaim,
598       address _claimerAddress,
599       uint8 _v,
600       bytes32 _r,
601       bytes32 _s,
602       uint256 _twitterIdToSteal
603       ) external payable whenNotPaused returns (uint256) {
604           return _claimIfNeededThenSteal(TWITTER, _twitterIdToClaim, _claimerAddress, _v, _r, _s, TWITTER, _twitterIdToSteal);
605       }
606 
607     function claimIfNeededThenSteal(
608       uint256 _socialNetworkTypeToClaim,
609       uint256 _socialIdToClaim,
610       address _claimerAddress,
611       uint8 _v,
612       bytes32 _r,
613       bytes32 _s,
614       uint256 _socialNetworkTypeToSteal,
615       uint256 _socialIdToSteal
616       ) external payable whenNotPaused returns (uint256) {
617           return _claimIfNeededThenSteal(_socialNetworkTypeToClaim, _socialIdToClaim, _claimerAddress, _v, _r, _s, _socialNetworkTypeToSteal, _socialIdToSteal);
618     }
619 
620     /// @dev "Convenience" function allowing us to avoid forcing the user to go through an extra
621     /// Ethereum transactions if they really, really want to do their first steal right now.
622     function _claimIfNeededThenSteal(
623       uint256 _socialNetworkTypeToClaim,
624       uint256 _socialIdToClaim,
625       address _claimerAddress,
626       uint8 _v,
627       bytes32 _r,
628       bytes32 _s,
629       uint256 _socialNetworkTypeToSteal,
630       uint256 _socialIdToSteal
631       ) private returns (uint256) {
632         uint8 _socialNetworkTypeToClaim8 = uint8(_socialNetworkTypeToClaim);
633         require(_socialNetworkTypeToClaim == uint256(_socialNetworkTypeToClaim8));
634 
635         uint64 _socialIdToClaim64 = uint64(_socialIdToClaim);
636         require(_socialIdToClaim == uint256(_socialIdToClaim64));
637 
638         uint256 claimedCardId = storageContract.socialIdentityToCardId(_socialNetworkTypeToClaim8, _socialIdToClaim64);
639 
640         address currentClaimer = address(0);
641         if (claimedCardId != 0) {
642           (, , currentClaimer, , ) = storageContract.allCards(claimedCardId);
643         }
644 
645         if (currentClaimer == address(0)) {
646           claimedCardId = _claimSocialNetworkIdentity(_socialNetworkTypeToClaim, _socialIdToClaim, _claimerAddress, _v, _r, _s);
647         }
648 
649         _stealCardWithSocialIdentity(_socialNetworkTypeToSteal, _socialIdToSteal);
650 
651         return claimedCardId;
652     }
653 
654     function _stealCardWithId(uint256 _cardId) private { // solhint-disable-line function-max-lines, code-complexity
655         // Make sure the card already exists
656         uint64 twitterId;
657         address cardClaimer;
658         (, twitterId, cardClaimer, , ) = storageContract.allCards(_cardId);
659         require(twitterId != 0);
660 
661         address oldOwner = storageContract.cardIdToOwner(_cardId);
662         address newOwner = msg.sender;
663 
664         // Making sure not stealing from self
665         require(oldOwner != newOwner);
666 
667         require(newOwner != address(0));
668 
669         // Check for sent value overflow (which realistically wouldn't happen)
670         uint128 sentValue = uint128(msg.value);
671         require(uint256(sentValue) == msg.value);
672 
673         uint128 lastPrice;
674         uint128 decayedPrice;
675         uint128 profit;
676         // uint128 ownerProfitTake;
677         // uint128 cardProfitTake;
678         uint128 totalOwnerPayout;
679         uint128 totalCardPayout;
680         uint128 platformFee;
681 
682         (lastPrice,
683         decayedPrice,
684         profit,
685         , // ownerProfitTake,
686         , // cardProfitTake,
687         totalOwnerPayout,
688         totalCardPayout,
689         platformFee
690         ) = currentPriceInfoOf(_cardId, sentValue);
691 
692         require(sentValue >= decayedPrice);
693 
694         _updateSaleInfo(_cardId, sentValue);
695         storageContract.authorized_changeOwnership(oldOwner, newOwner, _cardId);
696 
697         CardStealCompleted(_cardId, cardClaimer, lastPrice, sentValue, oldOwner, newOwner, totalOwnerPayout, totalCardPayout);
698 
699         if (platformFee > 0) {
700           _recordPlatformFee(platformFee);
701         }
702 
703         if (totalCardPayout > 0) {
704             if (cardClaimer == address(0)) {
705                 _recordStashedPayout(_cardId, totalCardPayout);
706             } else {
707                 // Because the caller can manipulate the .send to fail, we need a fallback
708                 if (!cardClaimer.send(totalCardPayout)) {
709                   _recordStashedPayout(_cardId, totalCardPayout);
710                 }
711             }
712         }
713 
714         if (totalOwnerPayout > 0) {
715           if (oldOwner != address(0)) {
716               // Because the caller can manipulate the .send to fail, we need a fallback
717               if (!oldOwner.send(totalOwnerPayout)) { // solhint-disable-line multiple-sends
718                 _recordFailedOldOwnerTransfer(oldOwner, totalOwnerPayout);
719               }
720           }
721         }
722     }
723 
724     function currentPriceInfoOf(uint256 _cardId, uint256 _sentGrossPrice) public view returns (
725         uint128 lastPrice,
726         uint128 decayedPrice,
727         uint128 profit,
728         uint128 ownerProfitTake,
729         uint128 cardProfitTake,
730         uint128 totalOwnerPayout,
731         uint128 totalCardPayout,
732         uint128 platformFee
733     ) {
734         uint128 lastTimestamp;
735         (lastTimestamp, lastPrice) = storageContract.cardIdToSaleInfo(_cardId);
736 
737         decayedPrice = decayedPriceFrom(lastPrice, lastTimestamp);
738         require(_sentGrossPrice >= decayedPrice);
739 
740         platformFee = uint128(_sentGrossPrice) * PLATFORM_FEE_RATE / 10000;
741         uint128 sentNetPrice = uint128(_sentGrossPrice) - platformFee;
742 
743         if (sentNetPrice > lastPrice) {
744             profit = sentNetPrice - lastPrice;
745             ownerProfitTake = profit * OWNER_TAKE_SHARE / 10000;
746             cardProfitTake = profit * CARD_TAKE_SHARE / 10000;
747         } else {
748             profit = 0;
749             ownerProfitTake = 0;
750             cardProfitTake = 0;
751         }
752 
753         totalOwnerPayout = ownerProfitTake + (sentNetPrice - profit);
754         totalCardPayout = cardProfitTake;
755 
756         // Special adjustment if there is no current owner
757         address currentOwner = storageContract.cardIdToOwner(_cardId);
758         if (currentOwner == address(0)) {
759           totalCardPayout = totalCardPayout + totalOwnerPayout;
760           totalOwnerPayout = 0;
761         }
762 
763         require(_sentGrossPrice >= (totalCardPayout + totalOwnerPayout + platformFee));
764 
765         return (lastPrice, decayedPrice, profit, ownerProfitTake, cardProfitTake, totalOwnerPayout, totalCardPayout, platformFee);
766     }
767 
768     function decayedPriceFrom(uint256 _lastPrice, uint256 _lastTimestamp) public view returns (uint128 decayedPrice) {
769         if (_lastTimestamp == 0) {
770             decayedPrice = INITIAL_CARD_PRICE;
771         } else {
772             uint128 startPrice = uint128(_lastPrice) + (uint128(_lastPrice) * PURCHASE_PREMIUM_RATE / 10000);
773             require(startPrice >= uint128(_lastPrice));
774 
775             uint128 secondsLapsed;
776             if (now > _lastTimestamp) { // solhint-disable-line not-rely-on-time
777                 secondsLapsed = uint128(now) - uint128(_lastTimestamp); // solhint-disable-line not-rely-on-time
778             } else {
779                 secondsLapsed = 0;
780             }
781             uint128 hoursLapsed = secondsLapsed / 1 hours;
782             uint128 totalDecay = (hoursLapsed * (startPrice * HOURLY_VALUE_DECAY_RATE / 10000));
783 
784             if (totalDecay > startPrice) {
785                 decayedPrice = MIN_CARD_PRICE;
786             } else {
787                 decayedPrice = startPrice - totalDecay;
788                 if (decayedPrice < MIN_CARD_PRICE) {
789                   decayedPrice = MIN_CARD_PRICE;
790                 }
791             }
792         }
793 
794         return decayedPrice;
795     }
796 
797     //////////////// STORAGE CONTRACT MUTATION
798 
799     function _updateSaleInfo(uint256 _cardId, uint256 _sentValue) private {
800         storageContract.authorized_updateSaleInfo(_cardId, _sentValue);
801     }
802 
803     function _updateCardClaimerAddress(uint256 _cardId, address _claimerAddress) private {
804         storageContract.authorized_updateCardClaimerAddress(_cardId, _claimerAddress);
805     }
806 
807     function _recordStashedPayout(uint256 _cardId, uint256 _stashedPayout) private {
808         storageContract.authorized_recordStashedPayout.value(_stashedPayout)(_cardId);
809     }
810 
811     function _triggerStashedPayoutTransfer(uint256 _cardId) private {
812         storageContract.authorized_triggerStashedPayoutTransfer(_cardId);
813     }
814 
815     function _recordFailedOldOwnerTransfer(address _oldOwner, uint256 _oldOwnerPayout) private {
816         storageContract.authorized_recordFailedOldOwnerTransfer.value(_oldOwnerPayout)(_oldOwner);
817     }
818 
819     function _recordPlatformFee(uint256 _platformFee) private {
820         storageContract.authorized_recordPlatformFee.value(_platformFee)();
821     }
822 
823     function _updateCardPerkText(uint256 _cardId, string _perkText) private {
824         storageContract.authorized_setCardPerkText(_cardId, _perkText);
825     }
826 
827     /////////////// QUERY FUNCTIONS
828 
829     // solhint-disable-next-line func-order
830     function decayedPriceOfTwitterId(uint256 _twitterId) public view returns (uint128) {
831       return decayedPriceOfSocialIdentity(TWITTER, _twitterId);
832     }
833 
834     function decayedPriceOfSocialIdentity(uint256 _socialNetworkType, uint256 _socialId) public view returns (uint128) {
835       uint8 _socialNetworkType8 = uint8(_socialNetworkType);
836       require(_socialNetworkType == uint256(_socialNetworkType8));
837 
838       uint64 _socialId64 = uint64(_socialId);
839       require(_socialId == uint256(_socialId64));
840 
841       uint256 cardId = storageContract.socialIdentityToCardId(_socialNetworkType8, _socialId64);
842 
843       return decayedPriceOfCard(cardId);
844     }
845 
846     function decayedPriceOfCard(uint256 _cardId) public view returns (uint128) {
847       uint128 lastTimestamp;
848       uint128 lastPrice;
849       (lastTimestamp, lastPrice) = storageContract.cardIdToSaleInfo(_cardId);
850       return decayedPriceFrom(lastPrice, lastTimestamp);
851     }
852 
853     function ownerOfTwitterId(uint256 _twitterId) public view returns (address) {
854       return ownerOfSocialIdentity(TWITTER, _twitterId);
855     }
856 
857     function ownerOfSocialIdentity(uint256 _socialNetworkType, uint256 _socialId) public view returns (address) {
858       uint8 _socialNetworkType8 = uint8(_socialNetworkType);
859       require(_socialNetworkType == uint256(_socialNetworkType8));
860 
861       uint64 _socialId64 = uint64(_socialId);
862       require(_socialId == uint256(_socialId64));
863 
864       uint256 cardId = storageContract.socialIdentityToCardId(_socialNetworkType8, _socialId64);
865 
866       address ownerAddress = storageContract.cardIdToOwner(cardId);
867       return ownerAddress;
868     }
869 
870     function claimerOfTwitterId(uint256 _twitterId) public view returns (address) {
871       return claimerOfSocialIdentity(TWITTER, _twitterId);
872     }
873 
874     function claimerOfSocialIdentity(uint256 _socialNetworkType, uint256 _socialId) public view returns (address) {
875       uint8 _socialNetworkType8 = uint8(_socialNetworkType);
876       require(_socialNetworkType == uint256(_socialNetworkType8));
877 
878       uint64 _socialId64 = uint64(_socialId);
879       require(_socialId == uint256(_socialId64));
880 
881       uint256 cardId = storageContract.socialIdentityToCardId(_socialNetworkType8, _socialId64);
882 
883       address claimerAddress;
884       (, , claimerAddress, ,) = storageContract.allCards(cardId);
885 
886       return claimerAddress;
887     }
888 
889     function twitterIdOfClaimerAddress(address _claimerAddress) public view returns (uint64) {
890       return socialIdentityOfClaimerAddress(TWITTER, _claimerAddress);
891     }
892 
893     function socialIdentityOfClaimerAddress(uint256 _socialNetworkType, address _claimerAddress) public view returns (uint64) {
894       uint256 cardId = storageContract.lookUpClaimerAddress(_socialNetworkType, _claimerAddress);
895 
896       uint64 socialId;
897       (, socialId, , ,) = storageContract.allCards(cardId);
898       return socialId;
899     }
900 
901     function withdrawContractBalance(address _to) external requireBursar {
902       if (_to == address(0)) {
903           bursarAddress.transfer(this.balance);
904       } else {
905           _to.transfer(this.balance);
906       }
907     }
908 }