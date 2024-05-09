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
61 contract Pausable is Admin {
62     bool public paused = false;
63 
64     modifier whenNotPaused() {
65         require(!paused);
66         _;
67     }
68 
69     modifier whenPaused {
70         require(paused);
71         _;
72     }
73 
74     function pause() external requireAdmin whenNotPaused {
75         paused = true;
76     }
77 
78     function unpause() external requireGod whenPaused {
79         paused = false;
80     }
81 }
82 
83 
84 contract CryptoFamousBase is Pausable {
85 
86   // DATA TYPES
87   struct Card {
88         // Social network type id (1 - Twitter, others TBD)
89         uint8 socialNetworkType;
90         // The social network id of the social account backing this card.
91         uint64 socialId;
92         // The ethereum address that most recently claimed this card.
93         address claimer;
94         // Increased whenever the card is claimed by an address
95         uint16 claimNonce;
96         // Reserved for future use
97         uint8 reserved1;
98   }
99 
100   struct SaleInfo {
101       uint128 timestamp;
102       uint128 price;
103   }
104 
105 }
106 
107 
108 contract CryptoFamousOwnership is CryptoFamousBase {
109   // EVENTS
110   /// @dev emitted when a new Card is created. Can happen when a social identity is claimed or stolen for the first time.
111   event CardCreated(uint256 indexed cardId, uint8 socialNetworkType, uint64 socialId, address claimer, address indexed owner);
112 
113   // STORAGE
114   /// @dev contains all the Cards in the system. Card with ID 0 is invalid.
115   Card[] public allCards;
116 
117   /// @dev SocialNetworkType -> (SocialId -> CardId)
118   mapping (uint8 => mapping (uint64 => uint256)) private socialIdentityMappings;
119 
120   /// @dev getter for `socialIdentityMappings`
121   function socialIdentityToCardId(uint256 _socialNetworkType, uint256 _socialId) public view returns (uint256 cardId) {
122     uint8 _socialNetworkType8 = uint8(_socialNetworkType);
123     require(_socialNetworkType == uint256(_socialNetworkType8));
124 
125     uint64 _socialId64 = uint64(_socialId);
126     require(_socialId == uint256(_socialId64));
127 
128     cardId = socialIdentityMappings[_socialNetworkType8][_socialId64];
129     return cardId;
130   }
131 
132   mapping (uint8 => mapping (address => uint256)) private claimerAddressToCardIdMappings;
133 
134   /// @dev returns the last Card ID claimed by `_claimerAddress` in network with `_socialNetworkType`
135   function lookUpClaimerAddress(uint256 _socialNetworkType, address _claimerAddress) public view returns (uint256 cardId) {
136     uint8 _socialNetworkType8 = uint8(_socialNetworkType);
137     require(_socialNetworkType == uint256(_socialNetworkType8));
138 
139     cardId = claimerAddressToCardIdMappings[_socialNetworkType8][_claimerAddress];
140     return cardId;
141   }
142 
143   /// @dev A mapping from Card ID to the timestamp of the first completed Claim of that Card
144   mapping (uint256 => uint128) public cardIdToFirstClaimTimestamp;
145 
146   /// @dev A mapping from Card ID to the current owner address of that Card
147   mapping (uint256 => address) public cardIdToOwner;
148 
149   /// @dev A mapping from owner address to the number of Cards currently owned by it
150   mapping (address => uint256) internal ownerAddressToCardCount;
151 
152   function _changeOwnership(address _from, address _to, uint256 _cardId) internal whenNotPaused {
153       ownerAddressToCardCount[_to]++;
154       cardIdToOwner[_cardId] = _to;
155 
156       if (_from != address(0)) {
157           ownerAddressToCardCount[_from]--;
158       }
159   }
160 
161   function _recordFirstClaimTimestamp(uint256 _cardId) internal {
162     cardIdToFirstClaimTimestamp[_cardId] = uint128(now); //solhint-disable-line not-rely-on-time
163   }
164 
165   function _createCard(
166       uint256 _socialNetworkType,
167       uint256 _socialId,
168       address _owner,
169       address _claimer
170   )
171       internal
172       whenNotPaused
173       returns (uint256)
174   {
175       uint8 _socialNetworkType8 = uint8(_socialNetworkType);
176       require(_socialNetworkType == uint256(_socialNetworkType8));
177 
178       uint64 _socialId64 = uint64(_socialId);
179       require(_socialId == uint256(_socialId64));
180 
181       uint16 claimNonce = 0;
182       if (_claimer != address(0)) {
183         claimNonce = 1;
184       }
185 
186       Card memory _card = Card({
187           socialNetworkType: _socialNetworkType8,
188           socialId: _socialId64,
189           claimer: _claimer,
190           claimNonce: claimNonce,
191           reserved1: 0
192       });
193       uint256 newCardId = allCards.push(_card) - 1;
194       socialIdentityMappings[_socialNetworkType8][_socialId64] = newCardId;
195 
196       if (_claimer != address(0)) {
197         claimerAddressToCardIdMappings[_socialNetworkType8][_claimer] = newCardId;
198         _recordFirstClaimTimestamp(newCardId);
199       }
200 
201       // event CardCreated(uint256 indexed cardId, uint8 socialNetworkType, uint64 socialId, address claimer, address indexed owner);
202       CardCreated(
203           newCardId,
204           _socialNetworkType8,
205           _socialId64,
206           _claimer,
207           _owner
208       );
209 
210       _changeOwnership(0, _owner, newCardId);
211 
212       return newCardId;
213   }
214 
215   /// @dev Returns the toal number of Cards in existence
216   function totalNumberOfCards() public view returns (uint) {
217       return allCards.length - 1;
218   }
219 
220   /// @notice Returns a list of all Card IDs currently owned by `_owner`
221   /// @dev (this thing iterates, don't call from smart contract code)
222   function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
223       uint256 tokenCount = ownerAddressToCardCount[_owner];
224 
225       if (tokenCount == 0) {
226           return new uint256[](0);
227       }
228 
229       uint256[] memory result = new uint256[](tokenCount);
230       uint256 total = totalNumberOfCards();
231       uint256 resultIndex = 0;
232 
233       uint256 cardId;
234 
235       for (cardId = 1; cardId <= total; cardId++) {
236           if (cardIdToOwner[cardId] == _owner) {
237               result[resultIndex] = cardId;
238               resultIndex++;
239           }
240       }
241 
242       return result;
243   }
244 }
245 
246 
247 contract CryptoFamousStorage is CryptoFamousOwnership {
248   function CryptoFamousStorage() public {
249       godAddress = msg.sender;
250       managerAddress = msg.sender;
251       bursarAddress = msg.sender;
252 
253       // avoid zero identifiers
254       _createCard(0, 0, address(0), address(0));
255   }
256 
257   function() external payable {
258       // just let msg.value be added to this.balance
259       FallbackEtherReceived(msg.sender, msg.value);
260   }
261 
262   event FallbackEtherReceived(address from, uint256 value);
263 
264   /// @dev Only this address will be allowed to call functions marked with `requireAuthorizedLogicContract`
265   address public authorizedLogicContractAddress;
266   modifier requireAuthorizedLogicContract() {
267       require(msg.sender == authorizedLogicContractAddress);
268       _;
269   }
270 
271   /// @dev mapping from Card ID to information about that card's last trade
272   mapping (uint256 => SaleInfo) public cardIdToSaleInfo;
273 
274   /// @dev mapping from Card ID to the current value stashed away for a future claimer
275   mapping (uint256 => uint256) public cardIdToStashedPayout;
276   /// @dev total amount of stashed payouts
277   uint256 public totalStashedPayouts;
278 
279   /// @dev if we fail to send any value to a Card's previous owner as part of the
280   /// invite/steal transaction we'll hold it in this contract. This mapping records the amount
281   /// owed to that "previous owner".
282   mapping (address => uint256) public addressToFailedOldOwnerTransferAmount;
283   /// @dev total amount of failed old owner transfers
284   uint256 public totalFailedOldOwnerTransferAmounts;
285 
286   /// @dev mapping from Card ID to that card's current perk text
287   mapping (uint256 => string) public cardIdToPerkText;
288 
289   function authorized_setCardPerkText(uint256 _cardId, string _perkText) external requireAuthorizedLogicContract {
290     cardIdToPerkText[_cardId] = _perkText;
291   }
292 
293   function setAuthorizedLogicContractAddress(address _newAuthorizedLogicContractAddress) external requireGod {
294     authorizedLogicContractAddress = _newAuthorizedLogicContractAddress;
295   }
296 
297   function authorized_changeOwnership(address _from, address _to, uint256 _cardId) external requireAuthorizedLogicContract {
298     _changeOwnership(_from, _to, _cardId);
299   }
300 
301   function authorized_createCard(uint256 _socialNetworkType, uint256 _socialId, address _owner, address _claimer) external requireAuthorizedLogicContract returns (uint256) {
302     return _createCard(_socialNetworkType, _socialId, _owner, _claimer);
303   }
304 
305   function authorized_updateSaleInfo(uint256 _cardId, uint256 _sentValue) external requireAuthorizedLogicContract {
306     cardIdToSaleInfo[_cardId] = SaleInfo(uint128(now), uint128(_sentValue)); // solhint-disable-line not-rely-on-time
307   }
308 
309   function authorized_updateCardClaimerAddress(uint256 _cardId, address _claimerAddress) external requireAuthorizedLogicContract {
310     Card storage card = allCards[_cardId];
311     if (card.claimer == address(0)) {
312       _recordFirstClaimTimestamp(_cardId);
313     }
314     card.claimer = _claimerAddress;
315     card.claimNonce += 1;
316   }
317 
318   function authorized_updateCardReserved1(uint256 _cardId, uint8 _reserved) external requireAuthorizedLogicContract {
319     uint8 _reserved8 = uint8(_reserved);
320     require(_reserved == uint256(_reserved8));
321 
322     Card storage card = allCards[_cardId];
323     card.reserved1 = _reserved8;
324   }
325 
326   function authorized_triggerStashedPayoutTransfer(uint256 _cardId) external requireAuthorizedLogicContract {
327     Card storage card = allCards[_cardId];
328     address claimerAddress = card.claimer;
329 
330     require(claimerAddress != address(0));
331 
332     uint256 stashedPayout = cardIdToStashedPayout[_cardId];
333 
334     require(stashedPayout > 0);
335 
336     cardIdToStashedPayout[_cardId] = 0;
337     totalStashedPayouts -= stashedPayout;
338 
339     claimerAddress.transfer(stashedPayout);
340   }
341 
342   function authorized_recordStashedPayout(uint256 _cardId) external payable requireAuthorizedLogicContract {
343       cardIdToStashedPayout[_cardId] += msg.value;
344       totalStashedPayouts += msg.value;
345   }
346 
347   function authorized_recordFailedOldOwnerTransfer(address _oldOwner) external payable requireAuthorizedLogicContract {
348       addressToFailedOldOwnerTransferAmount[_oldOwner] += msg.value;
349       totalFailedOldOwnerTransferAmounts += msg.value;
350   }
351 
352   // solhint-disable-next-line no-empty-blocks
353   function authorized_recordPlatformFee() external payable requireAuthorizedLogicContract {
354       // just let msg.value be added to this.balance
355   }
356 
357   /// @dev returns the current contract balance after subtracting the amounts stashed away for others
358   function netContractBalance() public view returns (uint256 balance) {
359     balance = this.balance - totalStashedPayouts - totalFailedOldOwnerTransferAmounts;
360     return balance;
361   }
362 
363   /// @dev the Bursar account can use this to withdraw the contract's net balance
364   function bursarPayOutNetContractBalance(address _to) external requireBursar {
365       uint256 payout = netContractBalance();
366 
367       if (_to == address(0)) {
368           bursarAddress.transfer(payout);
369       } else {
370           _to.transfer(payout);
371       }
372   }
373 
374   /// @dev Any wallet owed value that's recorded under `addressToFailedOldOwnerTransferAmount`
375   /// can use this function to withdraw that value.
376   function withdrawFailedOldOwnerTransferAmount() external whenNotPaused {
377       uint256 failedTransferAmount = addressToFailedOldOwnerTransferAmount[msg.sender];
378 
379       require(failedTransferAmount > 0);
380 
381       addressToFailedOldOwnerTransferAmount[msg.sender] = 0;
382       totalFailedOldOwnerTransferAmounts -= failedTransferAmount;
383 
384       msg.sender.transfer(failedTransferAmount);
385   }
386 }