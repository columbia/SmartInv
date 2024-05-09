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
149     function isLeapYear(uint16 year) public pure returns (bool);
150     function getYear(uint timestamp) public pure returns (uint16);
151     function getMonth(uint timestamp) public pure returns (uint8);
152     function getDay(uint timestamp) public pure returns (uint8);
153 }
154 
155 
156 /**
157  * OwnTheDay Contract Interface
158  */
159 contract OwnTheDayContract {
160     function ownerOf(uint256 _tokenId) public view returns (address);
161 }
162 
163 
164 /**
165  * @title CryptoTorchToken
166  */
167 contract CryptoTorchToken {
168     function contractBalance() public view returns (uint256);
169     function totalSupply() public view returns(uint256);
170     function balanceOf(address _playerAddress) public view returns(uint256);
171     function dividendsOf(address _playerAddress) public view returns(uint256);
172     function profitsOf(address _playerAddress) public view returns(uint256);
173     function referralBalanceOf(address _playerAddress) public view returns(uint256);
174     function sellPrice() public view returns(uint256);
175     function buyPrice() public view returns(uint256);
176     function calculateTokensReceived(uint256 _etherToSpend) public view returns(uint256);
177     function calculateEtherReceived(uint256 _tokensToSell) public view returns(uint256);
178 
179     function sellFor(address _for, uint256 _amountOfTokens) public;
180     function withdrawFor(address _for) public;
181     function mint(address _to, uint256 _amountForTokens, address _referredBy) public payable returns(uint256);
182 }
183 
184 
185 /**
186  * @title Crypto-Torch Contract
187  */
188 contract CryptoTorch is Pausable, ReentrancyGuard {
189     using SafeMath for uint256;
190 
191     //
192     // Events
193     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
194     //
195     event onTorchPassed(
196         address indexed from,
197         address indexed to,
198         uint256 pricePaid
199     );
200 
201     //
202     // Types
203     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
204     //
205     struct HighPrice {
206         uint256 price;
207         address owner;
208     }
209 
210     struct HighMileage {
211         uint256 miles;
212         address owner;
213     }
214 
215     struct PlayerData {
216         string name;
217         string note;
218         string coords;
219         uint256 dividends; // earnings waiting to be paid out
220         uint256 profits;   // earnings already paid out
221         bool champion;     // ran the torch while owning the day?
222     }
223 
224     //
225     // Payout Structure
226     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
227     //
228     //  Dev Fee               - 5%
229     //  Token Pool            - 75%
230     //    - Referral                - 10%
231     //  Remaining             - 20%
232     //    - Day Owner               - 10-25%
233     //    - Remaining               - 75-90%
234     //        - Last Runner             - 60%
235     //        - Second Last Runner      - 30%
236     //        - Third Last Runner       - 10%
237     //
238 
239     //
240     // Player Data
241     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
242     //
243     uint8 public constant maxLeaders = 3; // Gold, Silver, Bronze
244 
245     uint256 private _lowestHighPrice;
246     uint256 private _lowestHighMiles;
247     uint256 public whaleIncreaseLimit = 2 ether;
248     uint256 public whaleMax = 20 ether;
249 
250     HighPrice[maxLeaders] private _highestPrices;
251     HighMileage[maxLeaders] private _highestMiles;
252 
253     address[maxLeaders] public torchRunners;
254     address internal donationsReceiver_;
255     mapping (address => PlayerData) private playerData_;
256 
257     DateTime internal DateTimeLib_;
258     CryptoTorchToken internal CryptoTorchToken_;
259     OwnTheDayContract internal OwnTheDayContract_;
260     string[3] internal holidayMap_;
261 
262     //
263     // Modifiers
264     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
265     //
266     // ensures that the first tokens in the contract will be equally distributed
267     // meaning, no divine dump will be possible
268     modifier antiWhalePrice(uint256 _amount) {
269         require(
270             whaleIncreaseLimit == 0 ||
271             (
272                 _amount <= (whaleIncreaseLimit.add(_highestPrices[0].price)) &&
273                 playerData_[msg.sender].dividends.add(playerData_[msg.sender].profits).add(_amount) <= whaleMax
274             )
275         );
276         _;
277     }
278 
279     //
280     // Contract Initialization
281     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
282     //
283     /**
284      * Set the Owner to the First Torch Runner
285      */
286     function CryptoTorch() public {
287         torchRunners[0] = msg.sender;
288     }
289 
290     /**
291      * Initializes the Contract Dependencies as well as the Holiday Mapping for OwnTheDay.io
292      */
293     function initialize(address _dateTimeAddress, address _tokenAddress, address _otdAddress) public onlyOwner {
294         DateTimeLib_ = DateTime(_dateTimeAddress);
295         CryptoTorchToken_ = CryptoTorchToken(_tokenAddress);
296         OwnTheDayContract_ = OwnTheDayContract(_otdAddress);
297         holidayMap_[0] = "10000110000001100000000000000101100000000011101000000000000011000000000000001001000010000101100010100110000100001000110000";
298         holidayMap_[1] = "10111000100101000111000000100100000100010001001000100000000010010000000001000000110000000000000100000000010001100001100000";
299         holidayMap_[2] = "01000000000100000101011000000110000001100000000100000000000011100001000100000000101000000000100000000000000000010011000001";
300     }
301 
302     /**
303      * Sets the external contract address of the DateTime Library
304      */
305     function setDateTimeLib(address _dateTimeAddress) public onlyOwner {
306         DateTimeLib_ = DateTime(_dateTimeAddress);
307     }
308 
309     /**
310      * Sets the external contract address of the Token Contract
311      */
312     function setTokenContract(address _tokenAddress) public onlyOwner {
313         CryptoTorchToken_ = CryptoTorchToken(_tokenAddress);
314     }
315 
316     /**
317      * Sets the external contract address of OwnTheDay.io
318      */
319     function setOwnTheDayContract(address _otdAddress) public onlyOwner {
320         OwnTheDayContract_ = OwnTheDayContract(_otdAddress);
321     }
322 
323     /**
324      * Set the Contract Donations Receiver
325      */
326     function setDonationsReceiver(address _receiver) public onlyOwner {
327         donationsReceiver_ = _receiver;
328     }
329 
330     /**
331      * The Max Price-Paid Limit for Whales during the Anti-Whale Phase
332      */
333     function setWhaleMax(uint256 _max) public onlyOwner {
334         whaleMax = _max;
335     }
336 
337     /**
338      * The Max Price-Increase Limit for Whales during the Anti-Whale Phase
339      */
340     function setWhaleIncreaseLimit(uint256 _limit) public onlyOwner {
341         whaleIncreaseLimit = _limit;
342     }
343 
344     /**
345      * Updates the Holiday Mappings in case of updates/changes at OwnTheDay.io
346      */
347     function updateHolidayState(uint8 _listIndex, string _holidayMap) public onlyOwner {
348         require(_listIndex >= 0 && _listIndex < 3);
349         holidayMap_[_listIndex] = _holidayMap;
350     }
351 
352     //
353     // Public Functions
354     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
355     //
356     /**
357      * Checks if a specific day is a holiday at OwnTheDay.io
358      */
359     function isHoliday(uint256 _dayIndex) public view returns (bool) {
360         require(_dayIndex >= 0 && _dayIndex < 366);
361         return (getHolidayByIndex_(_dayIndex) == 1);
362     }
363 
364     /**
365      * Checks if Today is a holiday at OwnTheDay.io
366      */
367     function isHolidayToday() public view returns (bool) {
368         uint256 _dayIndex = getDayIndex_(now);
369         return (getHolidayByIndex_(_dayIndex) == 1);
370     }
371 
372     /**
373      * Gets the Day-Index of Today at OwnTheDay.io
374      */
375     function getTodayIndex() public view returns (uint256) {
376         return getDayIndex_(now);
377     }
378 
379     /**
380      * Gets the Owner Name of the Day at OwnTheDay.io
381      */
382     function getTodayOwnerName() public view returns (string) {
383         address dayOwner = OwnTheDayContract_.ownerOf(getTodayIndex());
384         return playerData_[dayOwner].name; // Get Name from THIS contract
385     }
386 
387     /**
388      * Gets the Owner Address of the Day at OwnTheDay.io
389      */
390     function getTodayOwnerAddress() public view returns (address) {
391         return OwnTheDayContract_.ownerOf(getTodayIndex());
392     }
393 
394     /**
395      * Sets the Nickname for an Account Address
396      */
397     function setAccountNickname(string _nickname) public whenNotPaused {
398         require(msg.sender != address(0));
399         require(bytes(_nickname).length > 0);
400         playerData_[msg.sender].name = _nickname;
401     }
402 
403     /**
404      * Gets the Nickname for an Account Address
405      */
406     function getAccountNickname(address _playerAddress) public view returns (string) {
407         return playerData_[_playerAddress].name;
408     }
409 
410     /**
411      * Sets the Note for an Account Address
412      */
413     function setAccountNote(string _note) public whenNotPaused {
414         require(msg.sender != address(0));
415         playerData_[msg.sender].note = _note;
416     }
417 
418     /**
419      * Gets the Note for an Account Address
420      */
421     function getAccountNote(address _playerAddress) public view returns (string) {
422         return playerData_[_playerAddress].note;
423     }
424 
425     /**
426      * Sets the Note for an Account Address
427      */
428     function setAccountCoords(string _coords) public whenNotPaused {
429         require(msg.sender != address(0));
430         playerData_[msg.sender].coords = _coords;
431     }
432 
433     /**
434      * Gets the Note for an Account Address
435      */
436     function getAccountCoords(address _playerAddress) public view returns (string) {
437         return playerData_[_playerAddress].coords;
438     }
439 
440     /**
441      * Gets the Note for an Account Address
442      */
443     function isChampionAccount(address _playerAddress) public view returns (bool) {
444         return playerData_[_playerAddress].champion;
445     }
446 
447     /**
448      * Take the Torch!
449      *  The Purchase Price is Paid to the Previous Torch Holder, and is also used
450      *  as the Purchasers Mileage Multiplier
451      */
452     function takeTheTorch(address _referredBy) public nonReentrant whenNotPaused payable {
453         takeTheTorch_(msg.value, msg.sender, _referredBy);
454     }
455 
456     /**
457      * Do not make payments directly to this contract (unless it is a donation! :)
458      *  - payments made directly to the contract do not receive tokens.  Tokens
459      *    are only available via "takeTheTorch()" or through the Dapp at https://cryptotorch.io
460      */
461     function() payable public {
462         if (msg.value > 0 && donationsReceiver_ != 0x0) {
463             donationsReceiver_.transfer(msg.value); // donations?  Thank you!  :)
464         }
465     }
466 
467     /**
468      * Sell some tokens for Ether
469      */
470     function sell(uint256 _amountOfTokens) public {
471         CryptoTorchToken_.sellFor(msg.sender, _amountOfTokens);
472     }
473 
474     /**
475      * Withdraw the earned Dividends to Ether
476      *  - Includes Torch + Token Dividends and Token Referral Bonuses
477      */
478     function withdrawDividends() public returns (uint256) {
479         CryptoTorchToken_.withdrawFor(msg.sender);
480         return withdrawFor_(msg.sender);
481     }
482 
483     //
484     // Helper Functions
485     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
486     //
487     /**
488      * View the total balance of this contract
489      */
490     function torchContractBalance() public view returns (uint256) {
491         return this.balance;
492     }
493 
494     /**
495      * View the total balance of the token contract
496      */
497     function tokenContractBalance() public view returns (uint256) {
498         return CryptoTorchToken_.contractBalance();
499     }
500 
501     /**
502      * Retrieve the total token supply.
503      */
504     function totalSupply() public view returns(uint256) {
505         return CryptoTorchToken_.totalSupply();
506     }
507 
508     /**
509      * Retrieve the token balance of any single address.
510      */
511     function balanceOf(address _playerAddress) public view returns(uint256) {
512         return CryptoTorchToken_.balanceOf(_playerAddress);
513     }
514 
515     /**
516      * Retrieve the token dividend balance of any single address.
517      */
518     function tokenDividendsOf(address _playerAddress) public view returns(uint256) {
519         return CryptoTorchToken_.dividendsOf(_playerAddress);
520     }
521 
522     /**
523      * Retrieve the referral dividend balance of any single address.
524      */
525     function referralDividendsOf(address _playerAddress) public view returns(uint256) {
526         return CryptoTorchToken_.referralBalanceOf(_playerAddress);
527     }
528 
529     /**
530      * Retrieve the dividend balance of any single address.
531      */
532     function torchDividendsOf(address _playerAddress) public view returns(uint256) {
533         return playerData_[_playerAddress].dividends;
534     }
535 
536     /**
537      * Retrieve the dividend balance of any single address.
538      */
539     function profitsOf(address _playerAddress) public view returns(uint256) {
540         return playerData_[_playerAddress].profits.add(CryptoTorchToken_.profitsOf(_playerAddress));
541     }
542 
543     /**
544      * Return the sell price of 1 individual token.
545      */
546     function sellPrice() public view returns(uint256) {
547         return CryptoTorchToken_.sellPrice();
548     }
549 
550     /**
551      * Return the buy price of 1 individual token.
552      */
553     function buyPrice() public view returns(uint256) {
554         return CryptoTorchToken_.buyPrice();
555     }
556 
557     /**
558      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
559      */
560     function calculateTokensReceived(uint256 _etherToSpend) public view returns(uint256) {
561         uint256 forTokens = _etherToSpend.sub(_etherToSpend.div(4));
562         return CryptoTorchToken_.calculateTokensReceived(forTokens);
563     }
564 
565     /**
566      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
567      */
568     function calculateEtherReceived(uint256 _tokensToSell) public view returns(uint256) {
569         return CryptoTorchToken_.calculateEtherReceived(_tokensToSell);
570     }
571 
572     /**
573      * Get the Max Price of the Torch during the Anti-Whale Phase
574      */
575     function getMaxPrice() public view returns (uint256) {
576         if (whaleIncreaseLimit == 0) { return 0; }  // no max price
577         return whaleIncreaseLimit.add(_highestPrices[0].price);
578     }
579 
580     /**
581      * Get the Highest Price per each Medal Leader
582      */
583     function getHighestPriceAt(uint _index) public view returns (uint256) {
584         require(_index >= 0 && _index < maxLeaders);
585         return _highestPrices[_index].price;
586     }
587 
588     /**
589      * Get the Highest Price Owner per each Medal Leader
590      */
591     function getHighestPriceOwnerAt(uint _index) public view returns (address) {
592         require(_index >= 0 && _index < maxLeaders);
593         return _highestPrices[_index].owner;
594     }
595 
596     /**
597      * Get the Highest Miles per each Medal Leader
598      */
599     function getHighestMilesAt(uint _index) public view returns (uint256) {
600         require(_index >= 0 && _index < maxLeaders);
601         return _highestMiles[_index].miles;
602     }
603 
604     /**
605      * Get the Highest Miles Owner per each Medal Leader
606      */
607     function getHighestMilesOwnerAt(uint _index) public view returns (address) {
608         require(_index >= 0 && _index < maxLeaders);
609         return _highestMiles[_index].owner;
610     }
611 
612     //
613     // Internal Functions
614     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
615     //
616     /**
617      * Take the Torch!  And receive KMS Tokens!
618      */
619     function takeTheTorch_(uint256 _amountPaid, address _takenBy, address _referredBy) internal antiWhalePrice(_amountPaid) returns (uint256) {
620         require(_takenBy != address(0));
621         require(_amountPaid >= 5 finney);
622         require(_takenBy != torchRunners[0]); // Torch must be passed on
623         if (_referredBy == address(this)) { _referredBy = address(0); }
624 
625         // Pass the Torch
626         address previousLast = torchRunners[2];
627         torchRunners[2] = torchRunners[1];
628         torchRunners[1] = torchRunners[0];
629         torchRunners[0] = _takenBy;
630 
631         // Get the Current Day Owner at OwnTheDay
632         address dayOwner = OwnTheDayContract_.ownerOf(getDayIndex_(now));
633 
634         // Calculate Portions
635         uint256 forDev = _amountPaid.mul(5).div(100);
636         uint256 forTokens = _amountPaid.sub(_amountPaid.div(4));
637         uint256 forPayout = _amountPaid.sub(forDev).sub(forTokens);
638         uint256 forDayOwner = calculateDayOwnerCut_(forPayout);
639         if (dayOwner == _takenBy) {
640             forTokens = forTokens.add(forDayOwner);
641             forPayout = _amountPaid.sub(forDev).sub(forTokens);
642             playerData_[_takenBy].champion = true;
643         } else {
644             forPayout = forPayout.sub(forDayOwner);
645         }
646 
647         // Fire Events
648         onTorchPassed(torchRunners[1], _takenBy, _amountPaid);
649 
650         // Grant Mileage Tokens to Torch Holder
651         uint256 mintedTokens = CryptoTorchToken_.mint.value(forTokens)(_takenBy, forTokens, _referredBy);
652 
653         // Update LeaderBoards
654         updateLeaders_(_takenBy, _amountPaid);
655 
656         // Handle Payouts
657         handlePayouts_(forDev, forPayout, forDayOwner, _takenBy, previousLast, dayOwner);
658         return mintedTokens;
659     }
660 
661     /**
662      * Payouts to the last 3 Torch Runners, the Day Owner & Dev
663      */
664     function handlePayouts_(uint256 _forDev, uint256 _forPayout, uint256 _forDayOwner, address _takenBy, address _previousLast, address _dayOwner) internal {
665         uint256[] memory runnerPortions = new uint256[](3);
666 
667         // Determine Runner Portions
668         //  Note, torch has already been passed, so torchRunners[0]
669         //  is the current torch runner
670         if (_previousLast != address(0)) {
671             runnerPortions[2] = _forPayout.mul(10).div(100);
672         }
673         if (torchRunners[2] != address(0)) {
674             runnerPortions[1] = _forPayout.mul(30).div(100);
675         }
676         runnerPortions[0] = _forPayout.sub(runnerPortions[1]).sub(runnerPortions[2]);
677 
678         // Update Player Dividends
679         playerData_[_previousLast].dividends = playerData_[_previousLast].dividends.add(runnerPortions[2]);
680         playerData_[torchRunners[2]].dividends = playerData_[torchRunners[2]].dividends.add(runnerPortions[1]);
681         playerData_[torchRunners[1]].dividends = playerData_[torchRunners[1]].dividends.add(runnerPortions[0]);
682 
683         // Track Profits
684         playerData_[owner].profits = playerData_[owner].profits.add(_forDev);
685         if (_dayOwner != _takenBy) {
686             playerData_[_dayOwner].profits = playerData_[_dayOwner].profits.add(_forDayOwner);
687         }
688 
689         // Transfer Funds
690         //  - Transfer directly since these accounts are not, or may not be, existing
691         //    Torch-Runners and therefore cannot "exit" this contract
692         owner.transfer(_forDev);
693         if (_dayOwner != _takenBy) {
694             _dayOwner.transfer(_forDayOwner);
695         }
696     }
697 
698     /**
699      * Withdraw the earned Torch Dividends to Ether
700      *  - Does not touch Token Dividends or Token Referral Bonuses
701      */
702     function withdrawFor_(address _for) internal returns (uint256) {
703         uint256 torchDividends = playerData_[_for].dividends;
704         if (playerData_[_for].dividends > 0) {
705             playerData_[_for].dividends = 0;
706             playerData_[_for].profits = playerData_[_for].profits.add(torchDividends);
707             _for.transfer(torchDividends);
708         }
709         return torchDividends;
710     }
711 
712     /**
713      * Update the Medal Leader Boards
714      */
715     function updateLeaders_(address _takenBy, uint256 _amountPaid) internal {
716         // Owner can't be leader; conflict of interest
717         if (_takenBy == owner || _takenBy == donationsReceiver_) { return; }
718 
719         // Update Highest Prices
720         if (_amountPaid > _lowestHighPrice) {
721             updateHighestPrices_(_amountPaid, _takenBy);
722         }
723 
724         // Update Highest Mileage
725         uint256 tokenBalance = CryptoTorchToken_.balanceOf(_takenBy);
726         if (tokenBalance > _lowestHighMiles) {
727             updateHighestMiles_(tokenBalance, _takenBy);
728         }
729     }
730 
731     /**
732      * Calculate the amount of Payout for the Day Owner (Holidays receive extra)
733      */
734     function calculateDayOwnerCut_(uint256 _price) internal view returns (uint256) {
735         if (getHolidayByIndex_(getDayIndex_(now)) == 1) {
736             return _price.mul(25).div(100);
737         }
738         return _price.mul(10).div(100);
739     }
740 
741     /**
742      * Get the Day-Index of the current Day for Mapping with OwnTheDay.io
743      */
744     function getDayIndex_(uint timestamp) internal view returns (uint256) {
745         uint16[12] memory offset = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
746         uint8 day = DateTimeLib_.getDay(timestamp);
747         uint8 month = DateTimeLib_.getMonth(timestamp) - 1;
748         bool isLeapYear = DateTimeLib_.isLeapYear(DateTimeLib_.getYear(timestamp));
749         // OwnTheDay always includes Feb 29
750         if (isLeapYear && month > 1) { day = day + 1; }
751         return offset[month] + day;
752     }
753 
754     /**
755      * Determine if Day-Index is a Holiday or not
756      */
757     function getHolidayByIndex_(uint256 _dayIndex) internal view returns (uint result) {
758         if (_dayIndex < 122) {
759             return getFromList_(0, _dayIndex);
760         }
761         if (_dayIndex < 244) {
762             return getFromList_(1, _dayIndex-122);
763         }
764         return getFromList_(2, _dayIndex-244);
765     }
766     function getFromList_(uint8 _idx, uint256 _dayIndex) internal view returns (uint result) {
767         result = parseInt_(uint(bytes(holidayMap_[_idx])[_dayIndex]));
768     }
769     function parseInt_(uint c) internal pure returns (uint result) {
770         if (c >= 48 && c <= 57) {
771             result = result * 10 + (c - 48);
772         }
773     }
774 
775     /**
776      * Update the Medal Leaderboard for the Highest Price
777      */
778     function updateHighestPrices_(uint256 _price, address _owner) internal {
779         uint256 newPos = maxLeaders;
780         uint256 oldPos = maxLeaders;
781         uint256 i;
782         HighPrice memory tmp;
783 
784         // Determine positions
785         for (i = maxLeaders-1; i >= 0; i--) {
786             if (_price >= _highestPrices[i].price) {
787                 newPos = i;
788             }
789             if (_owner == _highestPrices[i].owner) {
790                 oldPos = i;
791             }
792             if (i == 0) { break; } // prevent i going below 0
793         }
794         // Insert or update leader
795         if (newPos < maxLeaders) {
796             if (oldPos < maxLeaders-1) {
797                 // update price for existing leader
798                 _highestPrices[oldPos].price = _price;
799                 if (newPos != oldPos) {
800                     // swap
801                     tmp = _highestPrices[newPos];
802                     _highestPrices[newPos] = _highestPrices[oldPos];
803                     _highestPrices[oldPos] = tmp;
804                 }
805             } else {
806                 // shift down
807                 for (i = maxLeaders-1; i > newPos; i--) {
808                     _highestPrices[i] = _highestPrices[i-1];
809                 }
810                 // insert
811                 _highestPrices[newPos].price = _price;
812                 _highestPrices[newPos].owner = _owner;
813             }
814             // track lowest value
815             _lowestHighPrice = _highestPrices[maxLeaders-1].price;
816         }
817     }
818 
819     /**
820      * Update the Medal Leaderboard for the Highest Miles
821      */
822     function updateHighestMiles_(uint256 _miles, address _owner) internal {
823         uint256 newPos = maxLeaders;
824         uint256 oldPos = maxLeaders;
825         uint256 i;
826         HighMileage memory tmp;
827 
828         // Determine positions
829         for (i = maxLeaders-1; i >= 0; i--) {
830             if (_miles >= _highestMiles[i].miles) {
831                 newPos = i;
832             }
833             if (_owner == _highestMiles[i].owner) {
834                 oldPos = i;
835             }
836             if (i == 0) { break; } // prevent i going below 0
837         }
838         // Insert or update leader
839         if (newPos < maxLeaders) {
840             if (oldPos < maxLeaders-1) {
841                 // update miles for existing leader
842                 _highestMiles[oldPos].miles = _miles;
843                 if (newPos != oldPos) {
844                     // swap
845                     tmp = _highestMiles[newPos];
846                     _highestMiles[newPos] = _highestMiles[oldPos];
847                     _highestMiles[oldPos] = tmp;
848                 }
849             } else {
850                 // shift down
851                 for (i = maxLeaders-1; i > newPos; i--) {
852                     _highestMiles[i] = _highestMiles[i-1];
853                 }
854                 // insert
855                 _highestMiles[newPos].miles = _miles;
856                 _highestMiles[newPos].owner = _owner;
857             }
858             // track lowest value
859             _lowestHighMiles = _highestMiles[maxLeaders-1].miles;
860         }
861     }
862 }