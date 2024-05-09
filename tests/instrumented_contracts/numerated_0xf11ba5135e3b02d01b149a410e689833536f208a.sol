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
144  * @title CryptoTorchToken
145  */
146 contract CryptoTorchToken {
147     function contractBalance() public view returns (uint256);
148     function totalSupply() public view returns(uint256);
149     function balanceOf(address _playerAddress) public view returns(uint256);
150     function dividendsOf(address _playerAddress) public view returns(uint256);
151     function profitsOf(address _playerAddress) public view returns(uint256);
152     function referralBalanceOf(address _playerAddress) public view returns(uint256);
153     function sellPrice() public view returns(uint256);
154     function buyPrice() public view returns(uint256);
155     function calculateTokensReceived(uint256 _etherToSpend) public view returns(uint256);
156     function calculateEtherReceived(uint256 _tokensToSell) public view returns(uint256);
157 
158     function sellFor(address _for, uint256 _amountOfTokens) public;
159     function withdrawFor(address _for) public;
160     function mint(address _to, uint256 _amountForTokens, address _referredBy) public payable returns(uint256);
161 }
162 
163 
164 /**
165  * @title Crypto-Torch Contract v1.2
166  */
167 contract CryptoTorch is Pausable, ReentrancyGuard {
168     using SafeMath for uint256;
169 
170     //
171     // Events
172     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
173     //
174     event onTorchPassed(
175         address indexed from,
176         address indexed to,
177         uint256 pricePaid
178     );
179 
180     //
181     // Types
182     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
183     //
184     struct HighPrice {
185         uint256 price;
186         address owner;
187     }
188 
189     struct HighMileage {
190         uint256 miles;
191         address owner;
192     }
193 
194     struct PlayerData {
195         string name;
196         string note;
197         string coords;
198         uint256 dividends; // earnings waiting to be paid out
199         uint256 profits;   // earnings already paid out
200     }
201 
202     //
203     // Payout Structure
204     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
205     //  Special Olympics Donations  - 10%
206     //  Token Pool                  - 90%
207     //    - Referral                    - 10% of Token Pool
208     //
209 
210     //
211     // Player Data
212     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
213     //
214     bool private migrationFinished = false;
215     uint8 public constant maxLeaders = 3; // Gold, Silver, Bronze
216 
217     uint256 private _lowestHighPrice;
218     uint256 private _lowestHighMiles;
219     uint256 public totalDistanceRun;
220     uint256 public whaleIncreaseLimit = 2 ether;
221     uint256 public whaleMax = 20 ether;
222 
223     HighPrice[maxLeaders] private _highestPrices;
224     HighMileage[maxLeaders] private _highestMiles;
225 
226     address public torchRunner;
227     address public donationsReceiver_;
228     mapping (address => PlayerData) private playerData_;
229 
230     CryptoTorchToken internal CryptoTorchToken_;
231 
232     //
233     // Modifiers
234     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
235     //
236     // ensures that the first tokens in the contract will be equally distributed
237     // meaning, no divine dump will be possible
238     modifier antiWhalePrice(uint256 _amount) {
239         require(
240             whaleIncreaseLimit == 0 ||
241             (
242                 _amount <= (whaleIncreaseLimit.add(_highestPrices[0].price)) &&
243                 playerData_[msg.sender].dividends.add(playerData_[msg.sender].profits).add(_amount) <= whaleMax
244             )
245         );
246         _;
247     }
248 
249     modifier onlyDuringMigration() {
250         require(!migrationFinished);
251         _;
252     }
253 
254     //
255     // Contract Initialization
256     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
257     //
258     function CryptoTorch() public {}
259 
260     /**
261      * Initializes the Contract Dependencies as well as the Holiday Mapping for OwnTheDay.io
262      */
263     function initialize(address _torchRunner, address _tokenAddress) public onlyOwner {
264         torchRunner = _torchRunner;
265         CryptoTorchToken_ = CryptoTorchToken(_tokenAddress);
266     }
267 
268     /**
269      * Migrate Leader Prices
270      */
271     function migratePriceLeader(uint8 _leaderIndex, address _leaderAddress, uint256 _leaderPrice) public onlyOwner onlyDuringMigration {
272         require(_leaderIndex >= 0 && _leaderIndex < maxLeaders);
273         _highestPrices[_leaderIndex].owner = _leaderAddress;
274         _highestPrices[_leaderIndex].price = _leaderPrice;
275         if (_leaderIndex == maxLeaders-1) {
276             _lowestHighPrice = _leaderPrice;
277         }
278     }
279 
280     /**
281      * Migrate Leader Miles
282      */
283     function migrateMileageLeader(uint8 _leaderIndex, address _leaderAddress, uint256 _leaderMiles) public onlyOwner onlyDuringMigration {
284         require(_leaderIndex >= 0 && _leaderIndex < maxLeaders);
285         _highestMiles[_leaderIndex].owner = _leaderAddress;
286         _highestMiles[_leaderIndex].miles = _leaderMiles;
287         if (_leaderIndex == maxLeaders-1) {
288             _lowestHighMiles = _leaderMiles;
289         }
290     }
291 
292     /**
293      *
294      */
295     function finishMigration() public onlyOwner onlyDuringMigration {
296         migrationFinished = true;
297     }
298 
299     /**
300      *
301      */
302     function isMigrationFinished() public view returns (bool) {
303         return migrationFinished;
304     }
305 
306     /**
307      * Sets the external contract address of the Token Contract
308      */
309     function setTokenContract(address _tokenAddress) public onlyOwner {
310         CryptoTorchToken_ = CryptoTorchToken(_tokenAddress);
311     }
312 
313     /**
314      * Set the Contract Donations Receiver
315      * - Set to the Special Olympics Donations Address
316      */
317     function setDonationsReceiver(address _receiver) public onlyOwner {
318         donationsReceiver_ = _receiver;
319     }
320 
321     /**
322      * The Max Price-Paid Limit for Whales during the Anti-Whale Phase
323      */
324     function setWhaleMax(uint256 _max) public onlyOwner {
325         whaleMax = _max;
326     }
327 
328     /**
329      * The Max Price-Increase Limit for Whales during the Anti-Whale Phase
330      */
331     function setWhaleIncreaseLimit(uint256 _limit) public onlyOwner {
332         whaleIncreaseLimit = _limit;
333     }
334 
335     //
336     // Public Functions
337     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
338     //
339     /**
340      * Sets the Nickname for an Account Address
341      */
342     function setAccountNickname(string _nickname) public whenNotPaused {
343         require(msg.sender != address(0));
344         require(bytes(_nickname).length > 0);
345         playerData_[msg.sender].name = _nickname;
346     }
347 
348     /**
349      * Gets the Nickname for an Account Address
350      */
351     function getAccountNickname(address _playerAddress) public view returns (string) {
352         return playerData_[_playerAddress].name;
353     }
354 
355     /**
356      * Sets the Note for an Account Address
357      */
358     function setAccountNote(string _note) public whenNotPaused {
359         require(msg.sender != address(0));
360         playerData_[msg.sender].note = _note;
361     }
362 
363     /**
364      * Gets the Note for an Account Address
365      */
366     function getAccountNote(address _playerAddress) public view returns (string) {
367         return playerData_[_playerAddress].note;
368     }
369 
370     /**
371      * Sets the Note for an Account Address
372      */
373     function setAccountCoords(string _coords) public whenNotPaused {
374         require(msg.sender != address(0));
375         playerData_[msg.sender].coords = _coords;
376     }
377 
378     /**
379      * Gets the Note for an Account Address
380      */
381     function getAccountCoords(address _playerAddress) public view returns (string) {
382         return playerData_[_playerAddress].coords;
383     }
384 
385     /**
386      * Take the Torch!
387      *  The Purchase Price is Paid to the Previous Torch Holder, and is also used
388      *  as the Purchasers Mileage Multiplier
389      */
390     function takeTheTorch(address _referredBy) public nonReentrant whenNotPaused payable {
391         takeTheTorch_(msg.value, msg.sender, _referredBy);
392     }
393 
394     /**
395      * Payments made directly to this contract are treated as direct Donations to the Special Olympics.
396      *  - Note: payments made directly to the contract do not receive tokens.  Tokens
397      *    are only available via "takeTheTorch()" or through the Dapp at https://cryptotorch.io
398      */
399     function() payable public {
400         if (msg.value > 0 && donationsReceiver_ != 0x0) {
401             donationsReceiver_.transfer(msg.value); // donations?  Thank you!  :)
402         }
403     }
404 
405     /**
406      * Sell some tokens for Ether
407      */
408     function sell(uint256 _amountOfTokens) public {
409         CryptoTorchToken_.sellFor(msg.sender, _amountOfTokens);
410     }
411 
412     /**
413      * Withdraw the earned Dividends to Ether
414      *  - Includes Torch + Token Dividends and Token Referral Bonuses
415      */
416     function withdrawDividends() public returns (uint256) {
417         CryptoTorchToken_.withdrawFor(msg.sender);
418         return withdrawFor_(msg.sender);
419     }
420 
421     //
422     // Helper Functions
423     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
424     //
425     /**
426      * View the total balance of this contract
427      */
428     function torchContractBalance() public view returns (uint256) {
429         return this.balance;
430     }
431 
432     /**
433      * View the total balance of the token contract
434      */
435     function tokenContractBalance() public view returns (uint256) {
436         return CryptoTorchToken_.contractBalance();
437     }
438 
439     /**
440      * Retrieve the total token supply.
441      */
442     function totalSupply() public view returns(uint256) {
443         return CryptoTorchToken_.totalSupply();
444     }
445 
446     /**
447      * Retrieve the token balance of any single address.
448      */
449     function balanceOf(address _playerAddress) public view returns(uint256) {
450         return CryptoTorchToken_.balanceOf(_playerAddress);
451     }
452 
453     /**
454      * Retrieve the token dividend balance of any single address.
455      */
456     function tokenDividendsOf(address _playerAddress) public view returns(uint256) {
457         return CryptoTorchToken_.dividendsOf(_playerAddress);
458     }
459 
460     /**
461      * Retrieve the referral dividend balance of any single address.
462      */
463     function referralDividendsOf(address _playerAddress) public view returns(uint256) {
464         return CryptoTorchToken_.referralBalanceOf(_playerAddress);
465     }
466 
467     /**
468      * Retrieve the dividend balance of any single address.
469      */
470     function torchDividendsOf(address _playerAddress) public view returns(uint256) {
471         return playerData_[_playerAddress].dividends;
472     }
473 
474     /**
475      * Retrieve the dividend balance of any single address.
476      */
477     function profitsOf(address _playerAddress) public view returns(uint256) {
478         return playerData_[_playerAddress].profits.add(CryptoTorchToken_.profitsOf(_playerAddress));
479     }
480 
481     /**
482      * Return the sell price of 1 individual token.
483      */
484     function sellPrice() public view returns(uint256) {
485         return CryptoTorchToken_.sellPrice();
486     }
487 
488     /**
489      * Return the buy price of 1 individual token.
490      */
491     function buyPrice() public view returns(uint256) {
492         return CryptoTorchToken_.buyPrice();
493     }
494 
495     /**
496      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
497      */
498     function calculateTokensReceived(uint256 _etherToSpend) public view returns(uint256) {
499         uint256 forTokens = _etherToSpend.sub(_etherToSpend.div(10)); // 90% for Tokens
500         return CryptoTorchToken_.calculateTokensReceived(forTokens);
501     }
502 
503     /**
504      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
505      */
506     function calculateEtherReceived(uint256 _tokensToSell) public view returns(uint256) {
507         return CryptoTorchToken_.calculateEtherReceived(_tokensToSell);
508     }
509 
510     /**
511      * Get the Max Price of the Torch during the Anti-Whale Phase
512      */
513     function getMaxPrice() public view returns (uint256) {
514         if (whaleIncreaseLimit == 0) { return 0; }  // no max price
515         return whaleIncreaseLimit.add(_highestPrices[0].price);
516     }
517 
518     /**
519      * Get the Highest Price per each Medal Leader
520      */
521     function getHighestPriceAt(uint _index) public view returns (uint256) {
522         require(_index >= 0 && _index < maxLeaders);
523         return _highestPrices[_index].price;
524     }
525 
526     /**
527      * Get the Highest Price Owner per each Medal Leader
528      */
529     function getHighestPriceOwnerAt(uint _index) public view returns (address) {
530         require(_index >= 0 && _index < maxLeaders);
531         return _highestPrices[_index].owner;
532     }
533 
534     /**
535      * Get the Highest Miles per each Medal Leader
536      */
537     function getHighestMilesAt(uint _index) public view returns (uint256) {
538         require(_index >= 0 && _index < maxLeaders);
539         return _highestMiles[_index].miles;
540     }
541 
542     /**
543      * Get the Highest Miles Owner per each Medal Leader
544      */
545     function getHighestMilesOwnerAt(uint _index) public view returns (address) {
546         require(_index >= 0 && _index < maxLeaders);
547         return _highestMiles[_index].owner;
548     }
549 
550     //
551     // Internal Functions
552     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
553     //
554     /**
555      * Take the Torch!  And receive KMS Tokens!
556      */
557     function takeTheTorch_(uint256 _amountPaid, address _takenBy, address _referredBy) internal antiWhalePrice(_amountPaid) returns (uint256) {
558         require(_takenBy != address(0));
559         require(_amountPaid >= 1 finney);
560         require(_takenBy != torchRunner); // Torch must be passed on
561         if (_referredBy == address(this)) { _referredBy = address(0); }
562 
563         // Calculate Portions
564         uint256 forDonations = _amountPaid.div(10);
565         uint256 forTokens = _amountPaid.sub(forDonations);
566 
567         // Pass the Torch
568         onTorchPassed(torchRunner, _takenBy, _amountPaid);
569         torchRunner = _takenBy;
570 
571         // Grant Mileage Tokens to Torch Holder
572         uint256 mintedTokens = CryptoTorchToken_.mint.value(forTokens)(torchRunner, forTokens, _referredBy);
573         if (totalDistanceRun < CryptoTorchToken_.totalSupply()) {
574             totalDistanceRun = CryptoTorchToken_.totalSupply();
575         }
576 
577         // Update LeaderBoards
578         updateLeaders_(torchRunner, _amountPaid);
579 
580         // Handle Payouts
581         playerData_[donationsReceiver_].profits = playerData_[donationsReceiver_].profits.add(forDonations);
582         donationsReceiver_.transfer(forDonations);
583         return mintedTokens;
584     }
585 
586 
587     /**
588      * Withdraw the earned Torch Dividends to Ether
589      *  - Does not touch Token Dividends or Token Referral Bonuses
590      */
591     function withdrawFor_(address _for) internal returns (uint256) {
592         uint256 torchDividends = playerData_[_for].dividends;
593         if (playerData_[_for].dividends > 0) {
594             playerData_[_for].dividends = 0;
595             playerData_[_for].profits = playerData_[_for].profits.add(torchDividends);
596             _for.transfer(torchDividends);
597         }
598         return torchDividends;
599     }
600 
601     /**
602      * Update the Medal Leader Boards
603      */
604     function updateLeaders_(address _torchRunner, uint256 _amountPaid) internal {
605         // Owner can't be leader; conflict of interest
606         if (_torchRunner == owner) { return; }
607 
608         // Update Highest Prices
609         if (_amountPaid > _lowestHighPrice) {
610             updateHighestPrices_(_amountPaid, _torchRunner);
611         }
612 
613         // Update Highest Mileage
614         uint256 tokenBalance = CryptoTorchToken_.balanceOf(_torchRunner);
615         if (tokenBalance > _lowestHighMiles) {
616             updateHighestMiles_(tokenBalance, _torchRunner);
617         }
618     }
619 
620     /**
621      * Update the Medal Leaderboard for the Highest Price
622      */
623     function updateHighestPrices_(uint256 _price, address _owner) internal {
624         uint256 newPos = maxLeaders;
625         uint256 oldPos = maxLeaders;
626         uint256 i;
627         HighPrice memory tmp;
628 
629         // Determine positions
630         for (i = maxLeaders-1; i >= 0; i--) {
631             if (_price >= _highestPrices[i].price) {
632                 newPos = i;
633             }
634             if (_owner == _highestPrices[i].owner) {
635                 oldPos = i;
636             }
637             if (i == 0) { break; } // prevent i going below 0
638         }
639         // Insert or update leader
640         if (newPos < maxLeaders) {
641             if (oldPos < maxLeaders-1) {
642                 // update price for existing leader
643                 _highestPrices[oldPos].price = _price;
644                 if (newPos != oldPos) {
645                     // swap
646                     tmp = _highestPrices[newPos];
647                     _highestPrices[newPos] = _highestPrices[oldPos];
648                     _highestPrices[oldPos] = tmp;
649                 }
650             } else {
651                 // shift down
652                 for (i = maxLeaders-1; i > newPos; i--) {
653                     _highestPrices[i] = _highestPrices[i-1];
654                 }
655                 // insert
656                 _highestPrices[newPos].price = _price;
657                 _highestPrices[newPos].owner = _owner;
658             }
659             // track lowest value
660             _lowestHighPrice = _highestPrices[maxLeaders-1].price;
661         }
662     }
663 
664     /**
665      * Update the Medal Leaderboard for the Highest Miles
666      */
667     function updateHighestMiles_(uint256 _miles, address _owner) internal {
668         uint256 newPos = maxLeaders;
669         uint256 oldPos = maxLeaders;
670         uint256 i;
671         HighMileage memory tmp;
672 
673         // Determine positions
674         for (i = maxLeaders-1; i >= 0; i--) {
675             if (_miles >= _highestMiles[i].miles) {
676                 newPos = i;
677             }
678             if (_owner == _highestMiles[i].owner) {
679                 oldPos = i;
680             }
681             if (i == 0) { break; } // prevent i going below 0
682         }
683         // Insert or update leader
684         if (newPos < maxLeaders) {
685             if (oldPos < maxLeaders-1) {
686                 // update miles for existing leader
687                 _highestMiles[oldPos].miles = _miles;
688                 if (newPos != oldPos) {
689                     // swap
690                     tmp = _highestMiles[newPos];
691                     _highestMiles[newPos] = _highestMiles[oldPos];
692                     _highestMiles[oldPos] = tmp;
693                 }
694             } else {
695                 // shift down
696                 for (i = maxLeaders-1; i > newPos; i--) {
697                     _highestMiles[i] = _highestMiles[i-1];
698                 }
699                 // insert
700                 _highestMiles[newPos].miles = _miles;
701                 _highestMiles[newPos].owner = _owner;
702             }
703             // track lowest value
704             _lowestHighMiles = _highestMiles[maxLeaders-1].miles;
705         }
706     }
707 }