1 // CryptoTorch Source code
2 // copyright 2018 CryptoTorch <https://cryptotorch.io>
3 
4 pragma solidity 0.4.19;
5 
6 
7 /**
8  * @title SafeMath
9  * Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     /**
36     * Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 /**
55 * @title Ownable
56  *
57  * Owner rights:
58  *   - change the name of the contract
59  *   - change the name of the token
60  *   - change the Proof of Stake difficulty
61  *   - pause/unpause the contract
62  *   - transfer ownership
63  *
64  * Owner CANNOT:
65  *   - withdrawal funds
66  *   - disable withdrawals
67  *   - kill the contract
68  *   - change the price of tokens
69 */
70 contract Ownable {
71     address public owner;
72 
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     function Ownable() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address newOwner) public onlyOwner {
85         require(newOwner != address(0));
86         OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 }
90 
91 
92 /**
93  * @title Pausable
94  *
95  * Pausing the contract will only disable deposits,
96  * it will not prevent player dividend withdraws or token sales
97  */
98 contract Pausable is Ownable {
99     event OnPause();
100     event OnUnpause();
101 
102     bool public paused = false;
103 
104     modifier whenNotPaused() {
105         require(!paused);
106         _;
107     }
108 
109     modifier whenPaused() {
110         require(paused);
111         _;
112     }
113 
114     function pause() public onlyOwner whenNotPaused {
115         paused = true;
116         OnPause();
117     }
118 
119     function unpause() public onlyOwner whenPaused {
120         paused = false;
121         OnUnpause();
122     }
123 }
124 
125 
126 /**
127 * @title ReentrancyGuard
128 * Helps contracts guard against reentrancy attacks.
129 * @author Remco Bloemen <remco@2π.com>
130 */
131 contract ReentrancyGuard {
132     bool private reentrancyLock = false;
133 
134     modifier nonReentrant() {
135         require(!reentrancyLock);
136         reentrancyLock = true;
137         _;
138         reentrancyLock = false;
139     }
140 }
141 
142 
143 /**
144  * DateTime Contract Interface
145  * see https://github.com/pipermerriam/ethereum-datetime
146  * Live Contract Address: 0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce
147  */
148 contract DateTime {
149     function getMonth(uint timestamp) public pure returns (uint8);
150     function getDay(uint timestamp) public pure returns (uint8);
151 }
152 
153 
154 /**
155  * OwnTheDay Contract Interface
156  */
157 contract OwnTheDayContract {
158     function ownerOf(uint256 _tokenId) public view returns (address);
159 }
160 
161 
162 /**
163  * @title CryptoTorchToken
164  */
165 contract CryptoTorchToken {
166     function contractBalance() public view returns (uint256);
167     function totalSupply() public view returns(uint256);
168     function balanceOf(address _playerAddress) public view returns(uint256);
169     function dividendsOf(address _playerAddress) public view returns(uint256);
170     function profitsOf(address _playerAddress) public view returns(uint256);
171     function referralBalanceOf(address _playerAddress) public view returns(uint256);
172     function sellPrice() public view returns(uint256);
173     function buyPrice() public view returns(uint256);
174     function calculateTokensReceived(uint256 _etherToSpend) public view returns(uint256);
175     function calculateEtherReceived(uint256 _tokensToSell) public view returns(uint256);
176 
177     function sellFor(address _for, uint256 _amountOfTokens) public;
178     function withdrawFor(address _for) public;
179     function mint(address _to, uint256 _amountForTokens, address _referredBy) public payable returns(uint256);
180 }
181 
182 
183 /**
184  * @title Crypto-Torch Contract
185  */
186 contract CryptoTorch is Pausable, ReentrancyGuard {
187     using SafeMath for uint256;
188 
189     //
190     // Events
191     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
192     //
193     event onTorchPassed(
194         address indexed from,
195         address indexed to,
196         uint256 pricePaid
197     );
198 
199     //
200     // Types
201     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
202     //
203     struct HighPrice {
204         uint256 price;
205         address owner;
206     }
207 
208     struct HighMileage {
209         uint256 miles;
210         address owner;
211     }
212 
213     struct PlayerData {
214         string name;
215         string note;
216         string coords;
217         uint256 dividends; // earnings waiting to be paid out
218         uint256 profits;   // earnings already paid out
219         bool champion;     // ran the torch while owning the day?
220     }
221 
222     //
223     // Payout Structure
224     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
225     //
226     //  Dev Fee               - 5%
227     //  Token Pool            - 75%
228     //    - Referral                - 10%
229     //  Remaining             - 20%
230     //    - Day Owner               - 10-25%
231     //    - Remaining               - 75-90%
232     //        - Last Runner             - 60%
233     //        - Second Last Runner      - 30%
234     //        - Third Last Runner       - 10%
235     //
236 
237     //
238     // Player Data
239     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
240     //
241     uint8 public constant maxLeaders = 3; // Gold, Silver, Bronze
242 
243     uint256 private _lowestHighPrice;
244     uint256 private _lowestHighMiles;
245     uint256 public whaleIncreaseLimit = 2 ether;
246     uint256 public whaleMax = 20 ether;
247 
248     HighPrice[maxLeaders] private _highestPrices;
249     HighMileage[maxLeaders] private _highestMiles;
250 
251     address[maxLeaders] public torchRunners;
252     address internal donationsReceiver_;
253     mapping (address => PlayerData) private playerData_;
254 
255     DateTime internal DateTimeLib_;
256     CryptoTorchToken internal CryptoTorchToken_;
257     OwnTheDayContract internal OwnTheDayContract_;
258     string[3] internal holidayMap_;
259 
260     //
261     // Modifiers
262     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
263     //
264     // ensures that the first tokens in the contract will be equally distributed
265     // meaning, no divine dump will be possible
266     modifier antiWhalePrice(uint256 _amount) {
267         require(
268             whaleIncreaseLimit == 0 ||
269             (
270                 _amount <= (whaleIncreaseLimit.add(_highestPrices[0].price)) &&
271                 playerData_[msg.sender].dividends.add(playerData_[msg.sender].profits).add(_amount) <= whaleMax
272             )
273         );
274         _;
275     }
276 
277     //
278     // Contract Initialization
279     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
280     //
281     /**
282      * Set the Owner to the First Torch Runner
283      */
284     function CryptoTorch() public {
285         torchRunners[0] = msg.sender;
286     }
287 
288     /**
289      * Initializes the Contract Dependencies as well as the Holiday Mapping for OwnTheDay.io
290      */
291     function initialize(address _dateTimeAddress, address _tokenAddress, address _otdAddress) public onlyOwner {
292         DateTimeLib_ = DateTime(_dateTimeAddress);
293         CryptoTorchToken_ = CryptoTorchToken(_tokenAddress);
294         OwnTheDayContract_ = OwnTheDayContract(_otdAddress);
295         holidayMap_[0] = "10000110000001100000000000000101100000000011101000000000000011000000000000001001000010000101100010100110000100001000110000";
296         holidayMap_[1] = "10111000100101000111000000100100000100010001001000100000000010010000000001000000110000000000000100000000010001100001100000";
297         holidayMap_[2] = "01000000000100000101011000000110000001100000000100000000000011100001000100000000101000000000100000000000000000010011000001";
298     }
299 
300     /**
301      * Sets the external contract address of the DateTime Library
302      */
303     function setDateTimeLib(address _dateTimeAddress) public onlyOwner {
304         DateTimeLib_ = DateTime(_dateTimeAddress);
305     }
306 
307     /**
308      * Sets the external contract address of the Token Contract
309      */
310     function setTokenContract(address _tokenAddress) public onlyOwner {
311         CryptoTorchToken_ = CryptoTorchToken(_tokenAddress);
312     }
313 
314     /**
315      * Sets the external contract address of OwnTheDay.io
316      */
317     function setOwnTheDayContract(address _otdAddress) public onlyOwner {
318         OwnTheDayContract_ = OwnTheDayContract(_otdAddress);
319     }
320 
321     /**
322      * Set the Contract Donations Receiver
323      */
324     function setDonationsReceiver(address _receiver) public onlyOwner {
325         donationsReceiver_ = _receiver;
326     }
327 
328     /**
329      * The Max Price-Paid Limit for Whales during the Anti-Whale Phase
330      */
331     function setWhaleMax(uint256 _max) public onlyOwner {
332         whaleMax = _max;
333     }
334 
335     /**
336      * The Max Price-Increase Limit for Whales during the Anti-Whale Phase
337      */
338     function setWhaleIncreaseLimit(uint256 _limit) public onlyOwner {
339         whaleIncreaseLimit = _limit;
340     }
341 
342     /**
343      * Updates the Holiday Mappings in case of updates/changes at OwnTheDay.io
344      */
345     function updateHolidayState(uint8 _listIndex, string _holidayMap) public onlyOwner {
346         require(_listIndex >= 0 && _listIndex < 3);
347         holidayMap_[_listIndex] = _holidayMap;
348     }
349 
350     //
351     // Public Functions
352     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
353     //
354     /**
355      * Checks if a specific day is a holiday at OwnTheDay.io
356      */
357     function isHoliday(uint256 _dayIndex) public view returns (bool) {
358         require(_dayIndex >= 0 && _dayIndex < 366);
359         return (getHolidayByIndex_(_dayIndex) == 1);
360     }
361 
362     /**
363      * Checks if Today is a holiday at OwnTheDay.io
364      */
365     function isHolidayToday() public view returns (bool) {
366         uint256 _dayIndex = getDayIndex_(now);
367         return (getHolidayByIndex_(_dayIndex) == 1);
368     }
369 
370     /**
371      * Gets the Day-Index of Today at OwnTheDay.io
372      */
373     function getTodayIndex() public view returns (uint256) {
374         return getDayIndex_(now);
375     }
376 
377     /**
378      * Gets the Owner Name of the Day at OwnTheDay.io
379      */
380     function getTodayOwnerName() public view returns (string) {
381         address dayOwner = OwnTheDayContract_.ownerOf(getTodayIndex());
382         return playerData_[dayOwner].name; // Get Name from THIS contract
383     }
384 
385     /**
386      * Gets the Owner Address of the Day at OwnTheDay.io
387      */
388     function getTodayOwnerAddress() public view returns (address) {
389         return OwnTheDayContract_.ownerOf(getTodayIndex());
390     }
391 
392     /**
393      * Sets the Nickname for an Account Address
394      */
395     function setAccountNickname(string _nickname) public whenNotPaused {
396         require(msg.sender != address(0));
397         require(bytes(_nickname).length > 0);
398         playerData_[msg.sender].name = _nickname;
399     }
400 
401     /**
402      * Gets the Nickname for an Account Address
403      */
404     function getAccountNickname(address _playerAddress) public view returns (string) {
405         return playerData_[_playerAddress].name;
406     }
407 
408     /**
409      * Sets the Note for an Account Address
410      */
411     function setAccountNote(string _note) public whenNotPaused {
412         require(msg.sender != address(0));
413         playerData_[msg.sender].note = _note;
414     }
415 
416     /**
417      * Gets the Note for an Account Address
418      */
419     function getAccountNote(address _playerAddress) public view returns (string) {
420         return playerData_[_playerAddress].note;
421     }
422 
423     /**
424      * Sets the Note for an Account Address
425      */
426     function setAccountCoords(string _coords) public whenNotPaused {
427         require(msg.sender != address(0));
428         playerData_[msg.sender].coords = _coords;
429     }
430 
431     /**
432      * Gets the Note for an Account Address
433      */
434     function getAccountCoords(address _playerAddress) public view returns (string) {
435         return playerData_[_playerAddress].coords;
436     }
437 
438     /**
439      * Gets the Note for an Account Address
440      */
441     function isChampionAccount(address _playerAddress) public view returns (bool) {
442         return playerData_[_playerAddress].champion;
443     }
444 
445     /**
446      * Take the Torch!
447      *  The Purchase Price is Paid to the Previous Torch Holder, and is also used
448      *  as the Purchasers Mileage Multiplier
449      */
450     function takeTheTorch(address _referredBy) public nonReentrant whenNotPaused payable {
451         takeTheTorch_(msg.value, msg.sender, _referredBy);
452     }
453 
454     /**
455      * Do not make payments directly to this contract (unless it is a donation! :)
456      *  - payments made directly to the contract do not receive tokens.  Tokens
457      *    are only available via "takeTheTorch()" or through the Dapp at https://cryptotorch.io
458      */
459     function() payable public {
460         if (msg.value > 0 && donationsReceiver_ != 0x0) {
461             donationsReceiver_.transfer(msg.value); // donations?  Thank you!  :)
462         }
463     }
464 
465     /**
466      * Sell some tokens for Ether
467      */
468     function sell(uint256 _amountOfTokens) public {
469         CryptoTorchToken_.sellFor(msg.sender, _amountOfTokens);
470     }
471 
472     /**
473      * Withdraw the earned Dividends to Ether
474      *  - Includes Torch + Token Dividends and Token Referral Bonuses
475      */
476     function withdrawDividends() public returns (uint256) {
477         CryptoTorchToken_.withdrawFor(msg.sender);
478         return withdrawFor_(msg.sender);
479     }
480 
481     //
482     // Helper Functions
483     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
484     //
485     /**
486      * View the total balance of this contract
487      */
488     function torchContractBalance() public view returns (uint256) {
489         return this.balance;
490     }
491 
492     /**
493      * View the total balance of the token contract
494      */
495     function tokenContractBalance() public view returns (uint256) {
496         return CryptoTorchToken_.contractBalance();
497     }
498 
499     /**
500      * Retrieve the total token supply.
501      */
502     function totalSupply() public view returns(uint256) {
503         return CryptoTorchToken_.totalSupply();
504     }
505 
506     /**
507      * Retrieve the token balance of any single address.
508      */
509     function balanceOf(address _playerAddress) public view returns(uint256) {
510         return CryptoTorchToken_.balanceOf(_playerAddress);
511     }
512 
513     /**
514      * Retrieve the token dividend balance of any single address.
515      */
516     function tokenDividendsOf(address _playerAddress) public view returns(uint256) {
517         return CryptoTorchToken_.dividendsOf(_playerAddress);
518     }
519 
520     /**
521      * Retrieve the referral dividend balance of any single address.
522      */
523     function referralDividendsOf(address _playerAddress) public view returns(uint256) {
524         return CryptoTorchToken_.referralBalanceOf(_playerAddress);
525     }
526 
527     /**
528      * Retrieve the dividend balance of any single address.
529      */
530     function torchDividendsOf(address _playerAddress) public view returns(uint256) {
531         return playerData_[_playerAddress].dividends;
532     }
533 
534     /**
535      * Retrieve the dividend balance of any single address.
536      */
537     function profitsOf(address _playerAddress) public view returns(uint256) {
538         return playerData_[_playerAddress].profits.add(CryptoTorchToken_.profitsOf(_playerAddress));
539     }
540 
541     /**
542      * Return the sell price of 1 individual token.
543      */
544     function sellPrice() public view returns(uint256) {
545         return CryptoTorchToken_.sellPrice();
546     }
547 
548     /**
549      * Return the buy price of 1 individual token.
550      */
551     function buyPrice() public view returns(uint256) {
552         return CryptoTorchToken_.buyPrice();
553     }
554 
555     /**
556      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
557      */
558     function calculateTokensReceived(uint256 _etherToSpend) public view returns(uint256) {
559         uint256 forTokens = _etherToSpend.sub(_etherToSpend.div(4));
560         return CryptoTorchToken_.calculateTokensReceived(forTokens);
561     }
562 
563     /**
564      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
565      */
566     function calculateEtherReceived(uint256 _tokensToSell) public view returns(uint256) {
567         return CryptoTorchToken_.calculateEtherReceived(_tokensToSell);
568     }
569 
570     /**
571      * Get the Max Price of the Torch during the Anti-Whale Phase
572      */
573     function getMaxPrice() public view returns (uint256) {
574         if (whaleIncreaseLimit == 0) { return 0; }  // no max price
575         return whaleIncreaseLimit.add(_highestPrices[0].price);
576     }
577 
578     /**
579      * Get the Highest Price per each Medal Leader
580      */
581     function getHighestPriceAt(uint _index) public view returns (uint256) {
582         require(_index >= 0 && _index < maxLeaders);
583         return _highestPrices[_index].price;
584     }
585 
586     /**
587      * Get the Highest Price Owner per each Medal Leader
588      */
589     function getHighestPriceOwnerAt(uint _index) public view returns (address) {
590         require(_index >= 0 && _index < maxLeaders);
591         return _highestPrices[_index].owner;
592     }
593 
594     /**
595      * Get the Highest Miles per each Medal Leader
596      */
597     function getHighestMilesAt(uint _index) public view returns (uint256) {
598         require(_index >= 0 && _index < maxLeaders);
599         return _highestMiles[_index].miles;
600     }
601 
602     /**
603      * Get the Highest Miles Owner per each Medal Leader
604      */
605     function getHighestMilesOwnerAt(uint _index) public view returns (address) {
606         require(_index >= 0 && _index < maxLeaders);
607         return _highestMiles[_index].owner;
608     }
609 
610     //
611     // Internal Functions
612     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
613     //
614     /**
615      * Take the Torch!  And receive KMS Tokens!
616      */
617     function takeTheTorch_(uint256 _amountPaid, address _takenBy, address _referredBy) internal antiWhalePrice(_amountPaid) returns (uint256) {
618         require(_takenBy != address(0));
619         require(_amountPaid >= 5 finney);
620         require(_takenBy != torchRunners[0]); // Torch must be passed on
621         if (_referredBy == address(this)) { _referredBy = address(0); }
622 
623         // Pass the Torch
624         address previousLast = torchRunners[2];
625         torchRunners[2] = torchRunners[1];
626         torchRunners[1] = torchRunners[0];
627         torchRunners[0] = _takenBy;
628 
629         // Get the Current Day Owner at OwnTheDay
630         address dayOwner = OwnTheDayContract_.ownerOf(getDayIndex_(now));
631 
632         // Calculate Portions
633         uint256 forDev = _amountPaid.mul(5).div(100);
634         uint256 forTokens = _amountPaid.sub(_amountPaid.div(4));
635         uint256 forPayout = _amountPaid.sub(forDev).sub(forTokens);
636         uint256 forDayOwner = calculateDayOwnerCut_(forPayout);
637         if (dayOwner == _takenBy) {
638             forTokens = forTokens.add(forDayOwner);
639             forPayout = _amountPaid.sub(forDev).sub(forTokens);
640             playerData_[_takenBy].champion = true;
641         } else {
642             forPayout = forPayout.sub(forDayOwner);
643         }
644 
645         // Fire Events
646         onTorchPassed(torchRunners[1], _takenBy, _amountPaid);
647 
648         // Grant Mileage Tokens to Torch Holder
649         uint256 mintedTokens = CryptoTorchToken_.mint.value(forTokens)(_takenBy, forTokens, _referredBy);
650 
651         // Update LeaderBoards
652         updateLeaders_(_takenBy, _amountPaid);
653 
654         // Handle Payouts
655         handlePayouts_(forDev, forPayout, forDayOwner, _takenBy, previousLast, dayOwner);
656         return mintedTokens;
657     }
658 
659     /**
660      * Payouts to the last 3 Torch Runners, the Day Owner & Dev
661      */
662     function handlePayouts_(uint256 _forDev, uint256 _forPayout, uint256 _forDayOwner, address _takenBy, address _previousLast, address _dayOwner) internal {
663         uint256[] memory runnerPortions = new uint256[](3);
664 
665         // Determine Runner Portions
666         //  Note, torch has already been passed, so torchRunners[0]
667         //  is the current torch runner
668         if (_previousLast != address(0)) {
669             runnerPortions[2] = _forPayout.mul(10).div(100);
670         }
671         if (torchRunners[2] != address(0)) {
672             runnerPortions[1] = _forPayout.mul(30).div(100);
673         }
674         runnerPortions[0] = _forPayout.sub(runnerPortions[1]).sub(runnerPortions[2]);
675 
676         // Update Player Dividends
677         playerData_[_previousLast].dividends = playerData_[_previousLast].dividends.add(runnerPortions[2]);
678         playerData_[torchRunners[2]].dividends = playerData_[torchRunners[2]].dividends.add(runnerPortions[1]);
679         playerData_[torchRunners[1]].dividends = playerData_[torchRunners[1]].dividends.add(runnerPortions[0]);
680 
681         // Track Profits
682         playerData_[owner].profits = playerData_[owner].profits.add(_forDev);
683         if (_dayOwner != _takenBy) {
684             playerData_[_dayOwner].profits = playerData_[_dayOwner].profits.add(_forDayOwner);
685         }
686 
687         // Transfer Funds
688         //  - Transfer directly since these accounts are not, or may not be, existing
689         //    Torch-Runners and therefore cannot "exit" this contract
690         owner.transfer(_forDev);
691         if (_dayOwner != _takenBy) {
692             _dayOwner.transfer(_forDayOwner);
693         }
694     }
695 
696     /**
697      * Withdraw the earned Torch Dividends to Ether
698      *  - Does not touch Token Dividends or Token Referral Bonuses
699      */
700     function withdrawFor_(address _for) internal returns (uint256) {
701         uint256 torchDividends = playerData_[_for].dividends;
702         if (playerData_[_for].dividends > 0) {
703             playerData_[_for].dividends = 0;
704             playerData_[_for].profits = playerData_[_for].profits.add(torchDividends);
705             _for.transfer(torchDividends);
706         }
707         return torchDividends;
708     }
709 
710     /**
711      * Update the Medal Leader Boards
712      */
713     function updateLeaders_(address _takenBy, uint256 _amountPaid) internal {
714         // Owner can't be leader; conflict of interest
715         if (_takenBy == owner || _takenBy == donationsReceiver_) { return; }
716 
717         // Update Highest Prices
718         if (_amountPaid > _lowestHighPrice) {
719             updateHighestPrices_(_amountPaid, _takenBy);
720         }
721 
722         // Update Highest Mileage
723         uint256 tokenBalance = CryptoTorchToken_.balanceOf(_takenBy);
724         if (tokenBalance > _lowestHighMiles) {
725             updateHighestMiles_(tokenBalance, _takenBy);
726         }
727     }
728 
729     /**
730      * Calculate the amount of Payout for the Day Owner (Holidays receive extra)
731      */
732     function calculateDayOwnerCut_(uint256 _price) internal view returns (uint256) {
733         if (getHolidayByIndex_(getDayIndex_(now)) == 1) {
734             return _price.mul(25).div(100);
735         }
736         return _price.mul(10).div(100);
737     }
738 
739     /**
740      * Get the Day-Index of the current Day for Mapping with OwnTheDay.io
741      */
742     function getDayIndex_(uint timestamp) internal view returns (uint256) {
743         uint8 day = DateTimeLib_.getDay(timestamp);
744         uint8 month = DateTimeLib_.getMonth(timestamp);
745         // OwnTheDay always includes Feb 29
746         uint16[12] memory offset = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335];
747         return offset[month-1] + day;
748     }
749 
750     /**
751      * Determine if Day-Index is a Holiday or not
752      */
753     function getHolidayByIndex_(uint256 _dayIndex) internal view returns (uint result) {
754         if (_dayIndex < 122) {
755             return getFromList_(0, _dayIndex);
756         }
757         if (_dayIndex < 244) {
758             return getFromList_(1, _dayIndex-122);
759         }
760         return getFromList_(2, _dayIndex-244);
761     }
762     function getFromList_(uint8 _idx, uint256 _dayIndex) internal view returns (uint result) {
763         result = parseInt_(uint(bytes(holidayMap_[_idx])[_dayIndex]));
764     }
765     function parseInt_(uint c) internal pure returns (uint result) {
766         if (c >= 48 && c <= 57) {
767             result = result * 10 + (c - 48);
768         }
769     }
770 
771     /**
772      * Update the Medal Leaderboard for the Highest Price
773      */
774     function updateHighestPrices_(uint256 _price, address _owner) internal {
775         uint256 newPos = maxLeaders;
776         uint256 oldPos = maxLeaders;
777         uint256 i;
778         HighPrice memory tmp;
779 
780         // Determine positions
781         for (i = maxLeaders-1; i >= 0; i--) {
782             if (_price >= _highestPrices[i].price) {
783                 newPos = i;
784             }
785             if (_owner == _highestPrices[i].owner) {
786                 oldPos = i;
787             }
788             if (i == 0) { break; } // prevent i going below 0
789         }
790         // Insert or update leader
791         if (newPos < maxLeaders) {
792             if (oldPos < maxLeaders-1) {
793                 // update price for existing leader
794                 _highestPrices[oldPos].price = _price;
795                 if (newPos != oldPos) {
796                     // swap
797                     tmp = _highestPrices[newPos];
798                     _highestPrices[newPos] = _highestPrices[oldPos];
799                     _highestPrices[oldPos] = tmp;
800                 }
801             } else {
802                 // shift down
803                 for (i = maxLeaders-1; i > newPos; i--) {
804                     _highestPrices[i] = _highestPrices[i-1];
805                 }
806                 // insert
807                 _highestPrices[newPos].price = _price;
808                 _highestPrices[newPos].owner = _owner;
809             }
810             // track lowest value
811             _lowestHighPrice = _highestPrices[maxLeaders-1].price;
812         }
813     }
814 
815     /**
816      * Update the Medal Leaderboard for the Highest Miles
817      */
818     function updateHighestMiles_(uint256 _miles, address _owner) internal {
819         uint256 newPos = maxLeaders;
820         uint256 oldPos = maxLeaders;
821         uint256 i;
822         HighMileage memory tmp;
823 
824         // Determine positions
825         for (i = maxLeaders-1; i >= 0; i--) {
826             if (_miles >= _highestMiles[i].miles) {
827                 newPos = i;
828             }
829             if (_owner == _highestMiles[i].owner) {
830                 oldPos = i;
831             }
832             if (i == 0) { break; } // prevent i going below 0
833         }
834         // Insert or update leader
835         if (newPos < maxLeaders) {
836             if (oldPos < maxLeaders-1) {
837                 // update miles for existing leader
838                 _highestMiles[oldPos].miles = _miles;
839                 if (newPos != oldPos) {
840                     // swap
841                     tmp = _highestMiles[newPos];
842                     _highestMiles[newPos] = _highestMiles[oldPos];
843                     _highestMiles[oldPos] = tmp;
844                 }
845             } else {
846                 // shift down
847                 for (i = maxLeaders-1; i > newPos; i--) {
848                     _highestMiles[i] = _highestMiles[i-1];
849                 }
850                 // insert
851                 _highestMiles[newPos].miles = _miles;
852                 _highestMiles[newPos].owner = _owner;
853             }
854             // track lowest value
855             _lowestHighMiles = _highestMiles[maxLeaders-1].miles;
856         }
857     }
858 }