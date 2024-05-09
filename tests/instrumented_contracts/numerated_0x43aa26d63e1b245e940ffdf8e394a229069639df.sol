1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  *                                ...........       ...........
6  *                           .....                              t...
7  *                          TT..                                  ..T.
8  *                       TUx.                                        .TT
9  *                       .XtTT......                          ....TTtXXT
10  *                        UT..  ....                                 XU.
11  *                        Tt .                                      TUX.
12  *                        TXT..                  ..                .UU.
13  *                        .UU T.                 ....              TXT
14  *                         tX...                   T.. .           UX.
15  *                         TXT..      .             ......        .UU
16  *                         TUU..     TT.           ..    ..       TXx
17  *                         xtUT..     ....uUXUXXUT...    ..       UXT
18  *                          Utx .       TXUXXXXXUXU. .....       .UU
19  *                          tUt .       XXtTXUUXuUXU      .      TXx
20  *                          TXt..       XX .tXT. uXX   ....      UXT
21  *                          uUUT .      TX.     .XXX.   ..  . . .XUx
22  *                           Utx .T.  . .X...... XUXu      .... .XTx
23  *                           uxu ..xT. TXT        XUXt.   . .   TXT.
24  *                           Txt . TXXUXT .        UXXXt        tXt.
25  *                           uUx  XUXXXUXUXx      XUUUXUXT... . Uxx
26  *                            Xt  .XUXUXXXX.  .x.tUXUXXXXT.Tu.  .Tu
27  *                            tx.  .XxXXt.  .  x............x. ..TX.
28  *                            TT.....  .  .txt x   rm-rf/  .x.. .Tt
29  *                            xTT. ... . TUUU..x ...........x.. .Tt
30  *                             xT........ .UXTTTT.TTxTTTTTTut...Tx
31  *                             ttt..........xTTxTTTuxxuxTTTTTu. Tt
32  *                             uUt........  .................. .T
33  *                              Xxtt........     ....    . ....Tt
34  *                               xxuU... .     .       . . tttUu
35  *                                 UTuut                uuuUu..
36  *                                   T...................TT..
37  *
38  *
39  *
40  * @title CCCosmos SAT
41  *  
42  * The only official website: https://cccosmos.com
43  * 
44  *     CCCosmos is a game Dapp that runs on Ethereum. The mode of smart contract makes it run in a decentralized way. 
45  * Code logic prevents any others' control and keep the game fun, fair, and feasible. Unlike most DApps that require a browser
46  * plug-in, the well-designed CCCosmos can easily help you win great bonuses via any decentralized Ethereum wallet 
47  * on your phone.
48  *   
49  *                                        ///Game Description///
50  * # The first-time user can activate his/her Ethereum address by just paying an amount more than 0.01eth.
51  * 
52  * # The contract will automatically calculate the user's SAT account according to the price, and may immediately 
53  * receive up to seven-fold rewards.
54  * 
55  * # Holding SAT brings users continuous earnings; if you are the last one to get SAT at the end of the game, you 
56  * will win the huge sum in the final pot!
57  * 
58  * # Final Prize
59  * As the game countdown ends, the last SAT buyer will win the Final Pot.
60  * 
61  * # Early Birds
62  * Whenever a player buys SAT, the SAT price goes up; the early birds would get rich earnings.
63  * 
64  * # Late Surprise
65  * SAT buyers will have the chance to win multiplied rewards in betting; later users may win more eths.
66  * 
67  * # Be Dealers
68  * The top three users holding the most SATs are dealers who will continuously receive dealer funds for the day.
69  * 
70  * # Happy Ending
71  * After the game is over, all users will divide up the whole prize pot to win bonuses, and then a new round of 
72  * game starts.
73  * 
74  *                                              ///Rules///
75  * 1. The countdown to the end is initially set to be 24 hours. Whenever a user buys a SAT, the remaining time will 
76  * be extended by 30 seconds; but the total extension will not exceed 24 hours.
77  * 
78  * 2. Any amount of eth a user transfers to the contract address, with 0.01 eth deducted for activation fee, can be 
79  * used to buy SAT. The remaining sum of SAT can be checked in any Ethereum wallet.
80  * 
81  * 3. The initial SAT price is 0.000088eth, and the price will increase by 0.000000002eth for every SAT purchased.
82  * 
83  * 4. All eths the users spent on SAT are put into the prize pot, 50% of which enters the Share Pot, 20% the Final 
84  * Pot, 25.5% the Lucky Pot, and the rest 4.5% the Dealer Pot.
85  * 
86  * 5. When users transfer a certain amount of SAT to the contract address, the corresponding response function 
87  * will be triggered and then the transferred SAT will be refunded in full.
88  * 
89  *    # To get all the eth gains earned at your address by transferring back 0.08 SAT.
90  * 
91  *    # To make an instant re-investment and buy SAT with all eth gains earned at your address by transferring 
92  *      back 0.01 SAT.
93  * 
94  *    # After the game is over, you can get all the eth gains earned at your address by transferring back any 
95  *      amount of SAT.
96  * 
97  *    # The average withdrawal rate is less than 7.5% and decreases as the total SAT issuance increases. When the 
98  *      SAT price reaches 0.1eth, zero-fee is charged!
99  * 
100  * 6. Users have a 50% chance to get instant rewards in different proportions, maximally seven-fold, after they buy 
101  * SAT immediately.! (The maximum amount of the rewards cannot exceed 1/2 of the current lucky pot.)
102  * 
103  *                             Probability of Winning Rewards
104  * 
105  *                          Reward ratio           probability
106  *                               10%                   30%
107  *                               20%                   10%
108  *                               50%                   5%
109  *                               100%                  3%
110  *                               300%                  2%
111  *                               700%                  1%
112  * 
113  * 7. Users can log into cccosmos.com to check the earnings and get other detailed information.
114  * 
115  * 8. The top three Ethereum addresses with the most SAT purchase for the day will divide up the present Dealer 
116  *    Fund!
117  * 
118  * 9. One month after the game ends, the unclaimed eths will be automatically transferred to the CCCosmos 
119  *    Developer Fund for subsequent development and services.
120  */
121 
122 /**
123  * @title SafeMath
124  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
125  * @dev Math operations with safety checks that throw on error
126  */
127 library SafeMath {
128 
129     /**
130     * @dev Multiplies two numbers, throws on overflow.
131     */
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         if (a == 0) {
134             return 0;
135         }
136         uint256 c = a * b;
137         assert(c / a == b);
138         return c;
139     }
140 
141     /**
142     * @dev Integer division of two numbers, truncating the quotient.
143     */
144     function div(uint256 a, uint256 b) internal pure returns (uint256) {
145         // assert(b > 0); // Solidity automatically throws when dividing by 0
146         // uint256 c = a / b;
147         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148         return a / b;
149     }
150 
151     /**
152     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
153     */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         assert(b <= a);
156         return a - b;
157     }
158 
159     /**
160     * @dev Adds two numbers, throws on overflow.
161     */
162     function add(uint256 a, uint256 b) internal pure returns (uint256) {
163         uint256 c = a + b;
164         assert(c >= a);
165         return c;
166     }
167 
168     /**
169      * @dev gives square root of given x.
170      */
171     function sqrt(uint256 x) internal pure returns (uint256 y) {
172         uint256 z = ((add(x,1)) / 2);
173         y = x;
174         while (z < y) {
175             y = z;
176             z = ((add((x / z),z)) / 2);
177         }
178     }
179 }
180 
181 /**
182  * @title Ownable
183  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
184  * @dev The Ownable contract has an owner address, and provides basic authorization control
185  * functions, this simplifies the implementation of "user permissions".
186  */
187 contract Ownable {
188     address public owner;
189 
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     /**
194      * @dev Throws if called by any account other than the owner.
195      */
196     modifier onlyOwner() {
197         require(msg.sender == owner);
198         _;
199     }
200 
201     /**
202      * @dev Allows the current owner to transfer control of the contract to a newOwner.
203      * @param newOwner The address to transfer ownership to.
204      */
205     function transferOwnership(address newOwner) public onlyOwner {
206         require(newOwner != address(0));
207         emit OwnershipTransferred(owner, newOwner);
208         owner = newOwner;
209     }
210 
211 }
212 
213 /**
214  * @title Saturn
215  * @dev The Saturn token.
216  */
217 contract Saturn is Ownable {
218     using SafeMath for uint256;
219 
220     struct Player {
221         uint256 pid; // player ID, start with 1
222         uint256 ethTotal; // total buy amount in ETH
223         uint256 ethBalance; // the ETH balance which can be withdraw
224         uint256 ethWithdraw; // total eth which has already been withdrawn by player
225         uint256 ethShareWithdraw; // total shared pot which has already been withdrawn by player
226         uint256 tokenBalance; // token balance
227         uint256 tokenDay; // the day which player last buy
228         uint256 tokenDayBalance; // the token balance for last day
229     }
230 
231     struct LuckyRecord {
232         address player; // player address
233         uint256 amount; // lucky reward amount
234         uint64 txId; // tx ID
235         uint64 time; // lucky reward time
236         // lucky reward level.
237         // reward amount: 1: 700%, 2: 300%, 3: 100%, 4: 50%, 5: 20%, 6: 10%
238         // reward chance: 1: 1%, 2: 2%, 3: 3%, 4: 5%, 5: 10%, 6: 30%
239         uint64 level;
240     }
241 
242     // Keep lucky player which is pending for reward after next block
243     struct LuckyPending {
244         address player; // player address
245         uint256 amount; // player total eth for this tx
246         uint64 txId; // tx id
247         uint64 block; // current block number
248         uint64 level; // lucky level
249     }
250 
251     struct InternalBuyEvent {
252         // flag1
253         // 0 - new player (bool)
254         // 1-20 - tx ID
255         // 21-31 - finish time
256         // 32-46 - dealer1 ID
257         // 47-61 - dealer2 ID
258         // 62-76 - dealer3 ID
259         uint256 flag1;
260     }
261 
262     event Transfer(address indexed _from, address indexed _to, uint256 _value);
263     event Buy(
264         address indexed _token, address indexed _player, uint256 _amount, uint256 _total,
265         uint256 _totalSupply, uint256 _totalPot, uint256 _sharePot, uint256 _finalPot, uint256 _luckyPot,
266         uint256 _price, uint256 _flag1
267     );
268     event Withdraw(address indexed _token, address indexed _player, uint256 _amount);
269     event Win(address indexed _token, address indexed _winner, uint256 _winAmount);
270 
271     string constant public name = "Saturn";
272     string constant public symbol = "SAT";
273     uint8 constant public decimals = 18;
274 
275     uint256 constant private FEE_REGISTER_ACCOUNT = 10 finney; // register fee per player
276     uint256 constant private BUY_AMOUNT_MIN = 1000000000; // buy token minimal ETH
277     uint256 constant private BUY_AMOUNT_MAX = 100000000000000000000000; // buy token maximal ETH
278     uint256 constant private TIME_DURATION_INCREASE = 30 seconds; // time increased by each token
279     uint256 constant private TIME_DURATION_MAX = 24 hours; // max duration for game
280     uint256 constant private ONE_TOKEN = 1000000000000000000; // one token which is 10^18
281 
282     mapping(address => Player) public playerOf; // player address => player info
283     mapping(uint256 => address) public playerIdOf; // player id => player address
284     uint256 public playerCount; // total player
285 
286     uint256 public totalSupply; // token total supply
287 
288     uint256 public totalPot; // total eth which players bought
289     uint256 public sharePot; // shared pot for all players
290     uint256 public finalPot; // final win pot for winner (last player)
291     uint256 public luckyPot; // lucky pot based on random number.
292 
293     uint64 public txCount; // total transaction
294     uint256 public finishTime; // game finish time. It will be set startTime+24 hours when activate the contract.
295     uint256 public startTime; // the game is activated when now>=startTime.
296 
297     address public lastPlayer; // last player which by at least one key.
298     address public winner; // winner for final pot.
299     uint256 public winAmount; // win amount for winner, which will be final pot.
300 
301     uint256 public price; // token price
302 
303     address[3] public dealers; // top 3 token owners for daily. Dealers will be reset every midnight (00:00) UTC±00:00
304     uint256 public dealerDay; // The midnight time in UTC±00:00 which last player bought the token (without hour, minute, second)
305 
306     LuckyPending[] public luckyPendings;
307     uint256 public luckyPendingIndex;
308     LuckyRecord[] public luckyRecords; // The lucky player history.
309 
310     address public feeOwner; // fee owner. all fee will be send to this address.
311     uint256 public feeAmount; // current fee amount. new fee will be added to it.
312 
313     // withdraw fee price levels.
314     uint64[16] public feePrices = [uint64(88000000000000),140664279921934,224845905067685,359406674201608,574496375292119,918308169866219,1467876789325690,2346338995279770,3750523695724810,5995053579423660,9582839714125510,15317764181758900,24484798507285300,39137915352965200,62560303190573500,99999999999999100];
315     // withdraw fee percent. if feePrices[i]<=current price<feePrices[i + 1], then the withdraw fee will be (feePercents[i]/1000)*withdrawAmount
316     uint8[16] public feePercents = [uint8(150),140,130,120,110,100,90,80,70,60,50,40,30,20,10,0];
317     // current withdraw fee index. it will be updated when player buy token
318     uint256 public feeIndex;
319 
320     /**
321     * @dev Init the contract with fee owner. the game is not ready before activate function is called.
322     * Token total supply will be 0.
323     */
324     constructor(uint256 _startTime, address _feeOwner) public {
325         require(_startTime >= now && _feeOwner != address(0));
326         startTime = _startTime;
327         finishTime = _startTime + TIME_DURATION_MAX;
328         totalSupply = 0;
329         price = 88000000000000;
330         feeOwner = _feeOwner;
331         owner = msg.sender;
332     }
333 
334     /**
335      * @dev Throws if game is not ready
336      */
337     modifier isActivated() {
338         require(now >= startTime);
339         _;
340     }
341 
342     /**
343      * @dev Throws if sender is not account (contract etc.).
344      * This is not 100% guarantee that the caller is account (ie after account abstraction is implemented), but it is good enough.
345      */
346     modifier isAccount() {
347         address _address = msg.sender;
348         uint256 _codeLength;
349 
350         assembly {_codeLength := extcodesize(_address)}
351         require(_codeLength == 0 && tx.origin == msg.sender);
352         _;
353     }
354 
355     /**
356      * @dev Token balance for player
357      */
358     function balanceOf(address _owner) public view returns (uint256) {
359         return playerOf[_owner].tokenBalance;
360     }
361 
362     /**
363      * @dev Get lucky pending size
364      */
365     function getLuckyPendingSize() public view returns (uint256) {
366         return luckyPendings.length;
367     }
368     /**
369      * @dev Get lucky record size
370      */
371     function getLuckyRecordSize() public view returns (uint256) {
372         return luckyRecords.length;
373     }
374 
375     /**
376      * @dev Get the game info
377      */
378     function getGameInfo() public view returns (
379         uint256 _balance, uint256 _totalPot, uint256 _sharePot, uint256 _finalPot, uint256 _luckyPot, uint256 _rewardPot, uint256 _price,
380         uint256 _totalSupply, uint256 _now, uint256 _timeLeft, address _winner, uint256 _winAmount, uint8 _feePercent
381     ) {
382         _balance = address(this).balance;
383         _totalPot = totalPot;
384         _sharePot = sharePot;
385         _finalPot = finalPot;
386         _luckyPot = luckyPot;
387         _rewardPot = _sharePot;
388         uint256 _withdraw = _sharePot.add(_finalPot).add(_luckyPot);
389         if (_totalPot > _withdraw) {
390             _rewardPot = _rewardPot.add(_totalPot.sub(_withdraw));
391         }
392         _price = price;
393         _totalSupply = totalSupply;
394         _now = now;
395         _feePercent = feeIndex >= feePercents.length ? 0 : feePercents[feeIndex];
396         if (now < finishTime) {
397             _timeLeft = finishTime - now;
398         } else {
399             _timeLeft = 0;
400             _winner = winner != address(0) ? winner : lastPlayer;
401             _winAmount = winner != address(0) ? winAmount : finalPot;
402         }
403     }
404 
405     /**
406      * @dev Get the player info by address
407      */
408     function getPlayerInfo(address _playerAddress) public view returns (
409         uint256 _pid, uint256 _ethTotal, uint256 _ethBalance, uint256 _ethWithdraw,
410         uint256 _tokenBalance, uint256 _tokenDayBalance
411     ) {
412         Player storage _player = playerOf[_playerAddress];
413         if (_player.pid > 0) {
414             _pid = _player.pid;
415             _ethTotal = _player.ethTotal;
416             uint256 _sharePot = _player.tokenBalance.mul(sharePot).div(totalSupply); // all share pot the player will get.
417             _ethBalance = _player.ethBalance;
418             if (_sharePot > _player.ethShareWithdraw) {
419                 _ethBalance = _ethBalance.add(_sharePot.sub(_player.ethShareWithdraw));
420             }
421             _ethWithdraw = _player.ethWithdraw;
422             _tokenBalance = _player.tokenBalance;
423             uint256 _day = (now / 86400) * 86400;
424             if (_player.tokenDay == _day) {
425                 _tokenDayBalance = _player.tokenDayBalance;
426             }
427         }
428     }
429 
430     /**
431      * @dev Get dealer and lucky records
432      */
433     function getDealerAndLuckyInfo(uint256 _luckyOffset) public view returns (
434         address[3] _dealerPlayers, uint256[3] _dealerDayTokens, uint256[3] _dealerTotalTokens,
435         address[5] _luckyPlayers, uint256[5] _luckyAmounts, uint256[5] _luckyLevels, uint256[5] _luckyTimes
436     ) {
437         uint256 _day = (now / 86400) * 86400;
438         if (dealerDay == _day) {
439             for (uint256 _i = 0; _i < 3; ++_i) {
440                 if (dealers[_i] != address(0)) {
441                     Player storage _player = playerOf[dealers[_i]];
442                     _dealerPlayers[_i] = dealers[_i];
443                     _dealerDayTokens[_i] = _player.tokenDayBalance;
444                     _dealerTotalTokens[_i] = _player.tokenBalance;
445                 }
446             }
447         }
448         uint256 _size = _luckyOffset >= luckyRecords.length ? 0 : luckyRecords.length - _luckyOffset;
449         if (_luckyPlayers.length < _size) {
450             _size = _luckyPlayers.length;
451         }
452         for (_i = 0; _i < _size; ++_i) {
453             LuckyRecord memory _record = luckyRecords[luckyRecords.length - _luckyOffset - 1 - _i];
454             _luckyPlayers[_i] = _record.player;
455             _luckyAmounts[_i] = _record.amount;
456             _luckyLevels[_i] = _record.level;
457             _luckyTimes[_i] = _record.time;
458         }
459     }
460 
461     /**
462     * @dev Withdraw the balance and share pot.
463     *
464     * Override ERC20 transfer token function. This token is not allowed to transfer between players.
465     * So the _to address must be the contract address.
466     * 1. When game already finished: Player can send any amount of token to contract, and the contract will send the eth balance and share pot to player.
467     * 2. When game is not finished yet:
468     *    A. Withdraw. Player send 0.08 Token to contract, and the contract will send the eth balance and share pot to player.
469     *    B. ReBuy. Player send 0.01 Token to contract, then player's eth balance and share pot will be used to buy token.
470     *    C. Invalid. Other value is invalid.
471     * @param _to address The address which you want to transfer/sell to. MUST be contract address.
472     * @param _value uint256 the amount of tokens to be transferred/sold.
473     */
474     function transfer(address _to, uint256 _value) isActivated isAccount public returns (bool) {
475         require(_to == address(this));
476         Player storage _player = playerOf[msg.sender];
477         require(_player.pid > 0);
478         if (now >= finishTime) {
479             if (winner == address(0)) {
480                 // If the endGame is not called, then call it.
481                 endGame();
482             }
483             // Player want to withdraw.
484             _value = 80000000000000000;
485         } else {
486             // Only withdraw or rebuy allowed.
487             require(_value == 80000000000000000 || _value == 10000000000000000);
488         }
489         uint256 _sharePot = _player.tokenBalance.mul(sharePot).div(totalSupply); // all share pot the player will get.
490         uint256 _eth = 0;
491         // the total share pot need to sub amount which already be withdrawn by player.
492         if (_sharePot > _player.ethShareWithdraw) {
493             _eth = _sharePot.sub(_player.ethShareWithdraw);
494             _player.ethShareWithdraw = _sharePot;
495         }
496         // add the player's eth balance
497         _eth = _eth.add(_player.ethBalance);
498         _player.ethBalance = 0;
499         _player.ethWithdraw = _player.ethWithdraw.add(_eth);
500         if (_value == 80000000000000000) {
501             // Player want to withdraw
502             // Calculate fee based on price level.
503             uint256 _fee = _eth.mul(feeIndex >= feePercents.length ? 0 : feePercents[feeIndex]).div(1000);
504             if (_fee > 0) {
505                 feeAmount = feeAmount.add(_fee);
506                 _eth = _eth.sub(_fee);
507             }
508             sendFeeIfAvailable();
509             msg.sender.transfer(_eth);
510             emit Withdraw(_to, msg.sender, _eth);
511             emit Transfer(msg.sender, _to, 0);
512         } else {
513             // Player want to rebuy token
514             InternalBuyEvent memory _buyEvent = InternalBuyEvent({
515                 flag1: 0
516                 });
517             buy(_player, _buyEvent, _eth);
518         }
519         return true;
520     }
521 
522     /**
523     * @dev Buy token using ETH
524     * Player sends ETH to this contract, then his token balance will be increased based on price.
525     * The total supply will also be increased.
526     * Player need 0.01 ETH register fee to register this address (first time buy).
527     * The buy amount need between 0.000000001ETH and 100000ETH
528     */
529     function() isActivated isAccount payable public {
530         uint256 _eth = msg.value;
531         require(now < finishTime);
532         InternalBuyEvent memory _buyEvent = InternalBuyEvent({
533             flag1: 0
534             });
535         Player storage _player = playerOf[msg.sender];
536         if (_player.pid == 0) {
537             // Register the player, make sure the eth is enough.
538             require(_eth >= FEE_REGISTER_ACCOUNT);
539             // Reward player BUY_AMOUNT_MIN for register. So the final register fee will be FEE_REGISTER_ACCOUNT-BUY_AMOUNT_MIN
540             uint256 _fee = FEE_REGISTER_ACCOUNT.sub(BUY_AMOUNT_MIN);
541             _eth = _eth.sub(_fee);
542             // The register fee will go to fee owner
543             feeAmount = feeAmount.add(_fee);
544             playerCount = playerCount.add(1);
545             Player memory _p = Player({
546                 pid: playerCount,
547                 ethTotal: 0,
548                 ethBalance: 0,
549                 ethWithdraw: 0,
550                 ethShareWithdraw: 0,
551                 tokenBalance: 0,
552                 tokenDay: 0,
553                 tokenDayBalance: 0
554                 });
555             playerOf[msg.sender] = _p;
556             playerIdOf[_p.pid] = msg.sender;
557             _player = playerOf[msg.sender];
558             // The player is newly register first time.
559             _buyEvent.flag1 += 1;
560         }
561         buy(_player, _buyEvent, _eth);
562     }
563 
564     /**
565      * @dev Buy the token
566      */
567     function buy(Player storage _player, InternalBuyEvent memory _buyEvent, uint256 _amount) private {
568         require(now < finishTime && _amount >= BUY_AMOUNT_MIN && _amount <= BUY_AMOUNT_MAX);
569         // Calculate the midnight
570         uint256 _day = (now / 86400) * 86400;
571         uint256 _backEth = 0;
572         uint256 _eth = _amount;
573         if (totalPot < 200000000000000000000) {
574             // If the totalPot<200ETH, we are allow to buy 5ETH each time.
575             if (_eth >= 5000000000000000000) {
576                 // the other eth will add to player's ethBalance
577                 _backEth = _eth.sub(5000000000000000000);
578                 _eth = 5000000000000000000;
579             }
580         }
581         txCount = txCount + 1; // do not need use safe math
582         _buyEvent.flag1 += txCount * 10; // do not need use safe math
583         _player.ethTotal = _player.ethTotal.add(_eth);
584         totalPot = totalPot.add(_eth);
585         // Calculate the new total supply based on totalPot
586         uint256 _newTotalSupply = calculateTotalSupply(totalPot);
587         // The player will get the token with totalSupply delta
588         uint256 _tokenAmount = _newTotalSupply.sub(totalSupply);
589         _player.tokenBalance = _player.tokenBalance.add(_tokenAmount);
590         // If the player buy token before today, then add the tokenDayBalance.
591         // otherwise reset tokenDayBalance
592         if (_player.tokenDay == _day) {
593             _player.tokenDayBalance = _player.tokenDayBalance.add(_tokenAmount);
594         } else {
595             _player.tokenDay = _day;
596             _player.tokenDayBalance = _tokenAmount;
597         }
598         // Update the token price by new total supply
599         updatePrice(_newTotalSupply);
600         handlePot(_day, _eth, _newTotalSupply, _tokenAmount, _player, _buyEvent);
601         if (_backEth > 0) {
602             _player.ethBalance = _player.ethBalance.add(_backEth);
603         }
604         sendFeeIfAvailable();
605         emitEndTxEvents(_eth, _tokenAmount, _buyEvent);
606     }
607 
608     /**
609      * @dev Handle the pot (share, final, lucky and dealer)
610      */
611     function handlePot(uint256 _day, uint256 _eth, uint256 _newTotalSupply, uint256 _tokenAmount, Player storage _player, InternalBuyEvent memory _buyEvent) private {
612         uint256 _sharePotDelta = _eth.div(2); // share pot: 50%
613         uint256 _finalPotDelta = _eth.div(5); // final pot: 20%;
614         uint256 _luckyPotDelta = _eth.mul(255).div(1000); // lucky pot: 25.5%;
615         uint256 _dealerPotDelta = _eth.sub(_sharePotDelta).sub(_finalPotDelta).sub(_luckyPotDelta); // dealer pot: 4.5%
616         sharePot = sharePot.add(_sharePotDelta);
617         finalPot = finalPot.add(_finalPotDelta);
618         luckyPot = luckyPot.add(_luckyPotDelta);
619         totalSupply = _newTotalSupply;
620         handleDealerPot(_day, _dealerPotDelta, _player, _buyEvent);
621         handleLuckyPot(_eth, _player);
622         // The player need to buy at least one token to change the finish time and last player.
623         if (_tokenAmount >= ONE_TOKEN) {
624             updateFinishTime(_tokenAmount);
625             lastPlayer = msg.sender;
626         }
627         _buyEvent.flag1 += finishTime * 1000000000000000000000; // do not need use safe math
628     }
629 
630     /**
631      * @dev Handle lucky pot. The player can lucky pot by random number. The maximum amount will be half of total lucky pot
632      * The lucky reward will be added to player's eth balance
633      */
634     function handleLuckyPot(uint256 _eth, Player storage _player) private {
635         uint256 _seed = uint256(keccak256(abi.encodePacked(
636                 (block.timestamp).add
637                 (block.difficulty).add
638                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
639                 (block.gaslimit).add
640                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
641                 (block.number)
642             )));
643         _seed = _seed - ((_seed / 1000) * 1000);
644         uint64 _level = 0;
645         if (_seed < 227) { // 22.7%
646             _level = 1;
647         } else if (_seed < 422) { // 19.5%
648             _level = 2;
649         } else if (_seed < 519) { // 9.7%
650             _level = 3;
651         } else if (_seed < 600) { // 8.1%
652             _level = 4;
653         } else if (_seed < 700) { // 10%
654             _level = 5;
655         } else {  // 30%
656             _level = 6;
657         }
658         if (_level >= 5) {
659             // if level is 5 and 6, we will reward immediately
660             handleLuckyReward(txCount, _level, _eth, _player);
661         } else {
662             // otherwise we will save it for next block to check if it is reward or not
663             LuckyPending memory _pending = LuckyPending({
664                 player: msg.sender,
665                 amount: _eth,
666                 txId: txCount,
667                 block: uint64(block.number + 1),
668                 level: _level
669                 });
670             luckyPendings.push(_pending);
671         }
672         // handle the pending lucky reward
673         handleLuckyPending(_level >= 5 ? 0 : 1);
674     }
675 
676     function handleLuckyPending(uint256 _pendingSkipSize) private {
677         if (luckyPendingIndex < luckyPendings.length - _pendingSkipSize) {
678             LuckyPending storage _pending = luckyPendings[luckyPendingIndex];
679             if (_pending.block <= block.number) {
680                 uint256 _seed = uint256(keccak256(abi.encodePacked(
681                         (block.timestamp).add
682                         (block.difficulty).add
683                         ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
684                         (block.gaslimit).add
685                         (block.number)
686                     )));
687                 _seed = _seed - ((_seed / 1000) * 1000);
688                 handleLucyPendingForOne(_pending, _seed);
689                 if (luckyPendingIndex < luckyPendings.length - _pendingSkipSize) {
690                     _pending = luckyPendings[luckyPendingIndex];
691                     if (_pending.block <= block.number) {
692                         handleLucyPendingForOne(_pending, _seed);
693                     }
694                 }
695             }
696         }
697     }
698 
699     function handleLucyPendingForOne(LuckyPending storage _pending, uint256 _seed) private {
700         luckyPendingIndex = luckyPendingIndex.add(1);
701         bool _reward = false;
702         if (_pending.level == 4) {
703             _reward = _seed < 617;
704         } else if (_pending.level == 3) {
705             _reward = _seed < 309;
706         } else if (_pending.level == 2) {
707             _reward = _seed < 102;
708         } else if (_pending.level == 1) {
709             _reward = _seed < 44;
710         }
711         if (_reward) {
712             handleLuckyReward(_pending.txId, _pending.level, _pending.amount, playerOf[_pending.player]);
713         }
714     }
715 
716     function handleLuckyReward(uint64 _txId, uint64 _level, uint256 _eth, Player storage _player) private {
717         uint256 _amount;
718         if (_level == 1) {
719             _amount = _eth.mul(7); // 700%
720         } else if (_level == 2) {
721             _amount = _eth.mul(3); // 300%
722         } else if (_level == 3) {
723             _amount = _eth;        // 100%
724         } else if (_level == 4) {
725             _amount = _eth.div(2); // 50%
726         } else if (_level == 5) {
727             _amount = _eth.div(5); // 20%
728         } else if (_level == 6) {
729             _amount = _eth.div(10); // 10%
730         }
731         uint256 _maxPot = luckyPot.div(2);
732         if (_amount > _maxPot) {
733             _amount = _maxPot;
734         }
735         luckyPot = luckyPot.sub(_amount);
736         _player.ethBalance = _player.ethBalance.add(_amount);
737         LuckyRecord memory _record = LuckyRecord({
738             player: msg.sender,
739             amount: _amount,
740             txId: _txId,
741             level: _level,
742             time: uint64(now)
743             });
744         luckyRecords.push(_record);
745     }
746 
747     /**
748      * @dev Handle dealer pot. The top 3 of total day token (daily) will get dealer reward.
749      * The dealer reward will be added to player's eth balance
750      */
751     function handleDealerPot(uint256 _day, uint256 _dealerPotDelta, Player storage _player, InternalBuyEvent memory _buyEvent) private {
752         uint256 _potUnit = _dealerPotDelta.div(dealers.length);
753         // If this is the first buy in today, then reset the dealers info.
754         if (dealerDay != _day || dealers[0] == address(0)) {
755             dealerDay = _day;
756             dealers[0] = msg.sender;
757             dealers[1] = address(0);
758             dealers[2] = address(0);
759             _player.ethBalance = _player.ethBalance.add(_potUnit);
760             feeAmount = feeAmount.add(_dealerPotDelta.sub(_potUnit));
761             _buyEvent.flag1 += _player.pid * 100000000000000000000000000000000; // do not need safe math
762             return;
763         }
764         // Sort the dealers info by daily token balance.
765         for (uint256 _i = 0; _i < dealers.length; ++_i) {
766             if (dealers[_i] == address(0)) {
767                 dealers[_i] = msg.sender;
768                 break;
769             }
770             if (dealers[_i] == msg.sender) {
771                 break;
772             }
773             Player storage _dealer = playerOf[dealers[_i]];
774             if (_dealer.tokenDayBalance < _player.tokenDayBalance) {
775                 for (uint256 _j = dealers.length - 1; _j > _i; --_j) {
776                     if (dealers[_j - 1] != msg.sender) {
777                         dealers[_j] = dealers[_j - 1];
778                     }
779                 }
780                 dealers[_i] = msg.sender;
781                 break;
782             }
783         }
784         // the all dealers share the dealer reward.
785         uint256 _fee = _dealerPotDelta;
786         for (_i = 0; _i < dealers.length; ++_i) {
787             if (dealers[_i] == address(0)) {
788                 break;
789             }
790             _dealer = playerOf[dealers[_i]];
791             _dealer.ethBalance = _dealer.ethBalance.add(_potUnit);
792             _fee = _fee.sub(_potUnit);
793             _buyEvent.flag1 += _dealer.pid *
794             (_i == 0 ? 100000000000000000000000000000000 :
795             (_i == 1 ? 100000000000000000000000000000000000000000000000 :
796             (_i == 2 ? 100000000000000000000000000000000000000000000000000000000000000 : 0))); // do not need safe math, only keep top 3 dealers ID
797         }
798         if (_fee > 0) {
799             feeAmount = feeAmount.add(_fee);
800         }
801     }
802 
803     function emitEndTxEvents(uint256 _eth, uint256 _tokenAmount, InternalBuyEvent memory _buyEvent) private {
804         emit Transfer(address(this), msg.sender, _tokenAmount);
805         emit Buy(
806             address(this), msg.sender, _eth, _tokenAmount,
807             totalSupply, totalPot, sharePot, finalPot, luckyPot,
808             price, _buyEvent.flag1
809         );
810     }
811 
812     /**
813      * @dev End the game.
814      */
815     function endGame() private {
816         // The fee owner will get the lucky pot, because no player will allow to buy the token.
817         if (luckyPot > 0) {
818             feeAmount = feeAmount.add(luckyPot);
819             luckyPot = 0;
820         }
821         // Set the winner information if it is not set.
822         // The winner reward will go to winner eth balance.
823         if (winner == address(0) && lastPlayer != address(0)) {
824             winner = lastPlayer;
825             lastPlayer = address(0);
826             winAmount = finalPot;
827             finalPot = 0;
828             Player storage _player = playerOf[winner];
829             _player.ethBalance = _player.ethBalance.add(winAmount);
830             emit Win(address(this), winner, winAmount);
831         }
832     }
833 
834     /**
835      * @dev Update the finish time. each token will increase 30 seconds, up to 24 hours
836      */
837     function updateFinishTime(uint256 _tokenAmount) private {
838         uint256 _timeDelta = _tokenAmount.div(ONE_TOKEN).mul(TIME_DURATION_INCREASE);
839         uint256 _finishTime = finishTime.add(_timeDelta);
840         uint256 _maxTime = now.add(TIME_DURATION_MAX);
841         finishTime = _finishTime <= _maxTime ? _finishTime : _maxTime;
842     }
843 
844     function updatePrice(uint256 _newTotalSupply) private {
845         price = _newTotalSupply.mul(2).div(10000000000).add(88000000000000);
846         uint256 _idx = feeIndex + 1;
847         while (_idx < feePrices.length && price >= feePrices[_idx]) {
848             feeIndex = _idx;
849             ++_idx;
850         }
851     }
852 
853     function calculateTotalSupply(uint256 _newTotalPot) private pure returns(uint256) {
854         return _newTotalPot.mul(10000000000000000000000000000)
855         .add(193600000000000000000000000000000000000000000000)
856         .sqrt()
857         .sub(440000000000000000000000);
858     }
859 
860     function sendFeeIfAvailable() private {
861         if (feeAmount > 1000000000000000000) {
862             feeOwner.transfer(feeAmount);
863             feeAmount = 0;
864         }
865     }
866 
867     /**
868     * @dev Change the fee owner.
869     *
870     * @param _feeOwner The new fee owner.
871     */
872     function changeFeeOwner(address _feeOwner) onlyOwner public {
873         require(_feeOwner != feeOwner && _feeOwner != address(0));
874         feeOwner = _feeOwner;
875     }
876 
877     /**
878     * @dev Withdraw the fee. The owner can withdraw the money after 30 days of game finish.
879     * This prevents the money is not locked in this contract.
880     * Player can contact the contract owner to get back money if the money is withdrawn.
881     * @param _amount The amount which will be withdrawn.
882     */
883     function withdrawFee(uint256 _amount) onlyOwner public {
884         require(now >= finishTime.add(30 days));
885         if (winner == address(0)) {
886             endGame();
887         }
888         feeAmount = feeAmount > _amount ? feeAmount.sub(_amount) : 0;
889         feeOwner.transfer(_amount);
890     }
891 
892 }