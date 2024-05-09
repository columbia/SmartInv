1 pragma solidity 0.4.19;
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
50  * @title Helps contracts guard agains reentrancy attacks.
51  * @author Remco Bloemen <remco@2π.com>
52  * @notice If you mark a function `nonReentrant`, you should also
53  * mark it `external`.
54  */
55 contract ReentrancyGuard {
56 
57   /**
58    * @dev We use a single lock for the whole contract.
59    */
60   bool private reentrancy_lock = false;
61 
62   /**
63    * @dev Prevents a contract from calling itself, directly or indirectly.
64    * @notice If you mark a function `nonReentrant`, you should also
65    * mark it `external`. Calling one nonReentrant function from
66    * another is not supported. Instead, you can implement a
67    * `private` function doing the actual work, and a `external`
68    * wrapper marked as `nonReentrant`.
69    */
70   modifier nonReentrant() {
71     require(!reentrancy_lock);
72     reentrancy_lock = true;
73     _;
74     reentrancy_lock = false;
75   }
76 
77 }
78 
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract Ownable {
85   address public owner;
86 
87   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89   /**
90    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91    * account.
92    */
93   function Ownable() public {
94     owner = msg.sender;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address newOwner) public onlyOwner {
110     require(newOwner != address(0));
111     OwnershipTransferred(owner, newOwner);
112     owner = newOwner;
113   }
114 
115 }
116 
117 /**
118  * EtherButton
119  *
120  * A game of financial hot potato. Players pay to click EtherButton.
121  * Each player is given 105% of their payment by each subsequent player.
122  * A seven hour timer resets after every click. The round advances once the timer reaches zero.
123  * 
124  * Bonus:
125  *  For every player payout, an additional 1% is stored as an end-of-round bonus.
126  *  Each player is entitled to their bonus if they click EtherButton during the *next* round.
127  *  0.500 ETH is given to the last player of every round and their bonus is unlocked immediately.
128  *  Unclaimed bonuses are rolled into future rounds.
129  **/
130 contract EtherButton is Ownable, ReentrancyGuard {
131   // Use basic math operators which have integer overflow protection built into them.
132   // Simplifies code greatly by reducing the need to constantly check inputs for overflow.
133   using SafeMath for uint;
134 
135   // Best practices say to prefix events with Log to avoid confusion.
136   // https://consensys.github.io/smart-contract-best-practices/recommendations/#differentiate-functions-and-events
137   event LogClick(
138     uint _id,
139     uint _price,
140     uint _previousPrice,
141     uint _endTime,
142     uint _clickCount,
143     uint _totalBonus,
144     address _activePlayer,
145     uint _activePlayerClickCount,
146     uint _previousRoundTotalBonus
147   );
148   event LogClaimBonus(address _recipient, uint _bonus);
149   event LogPlayerPayout(address _recipient, uint _amount);
150   event LogSendPaymentFailure(address _recipient, uint _amount);
151 
152   // Represent fractions as numerator/denominator because Solidity doesn't support decimals.
153   // It's okay to use ".5 ether" because it converts to "500000000000000000 wei"
154   uint public constant INITIAL_PRICE = .5 ether;
155   uint public constant ROUND_DURATION = 7 hours;
156   // 5% price increase is allocated to the player.
157   uint private constant PLAYER_PROFIT_NUMERATOR = 5;
158   uint private constant PLAYER_PROFIT_DENOMINATOR = 100;
159   // 1% price increase is allocated to player bonuses.
160   uint private constant BONUS_NUMERATOR = 1;
161   uint private constant BONUS_DENOMINATOR = 100; 
162   // 2.5% price increase is allocated to the owner.
163   uint private constant OWNER_FEE_NUMERATOR = 25;
164   uint private constant OWNER_FEE_DENOMINATOR = 1000;
165 
166   // EtherButton is comprised of many rounds. Each round contains
167   // an isolated instance of game state.
168   struct Round {
169     uint id;
170     uint price;
171     uint previousPrice;
172     uint endTime;
173     uint clickCount;
174     uint totalBonus;
175     uint claimedBonus;
176     address activePlayer;
177     mapping (address => uint) playerClickCounts;
178     mapping (address => bool) bonusClaimedList;
179   }
180 
181   // A list of all the rounds which have been played as well as
182   // the id of the current (active) round.
183   mapping (uint => Round) public Rounds;
184   uint public RoundId;
185 
186   /**
187    * Create the contract with an initial 'Round 0'. This round has already expired which will cause the first
188    * player interaction to start Round 1. This is simpler than introducing athe concept of a 'paused' round.
189   **/
190   function EtherButton() public {
191     initializeRound();
192     Rounds[RoundId].endTime = now.sub(1);
193   }
194 
195   /**
196    * Performs a single 'click' of EtherButton.
197    *
198    * Advances the round if the previous round's endTime has passed. This needs to be done
199    * just-in-time because code isn't able to execute on a timer - it needs funding.
200    *
201    * Refunds the player any extra money they may have sent. Pays the last player and the owner.
202    * Marks the player as the active player so that they're next to be paid.
203    *
204    * Emits an event showing the current state of EtherButton and returns the state, too.
205   **/
206   function click() nonReentrant external payable {
207     // Owner is not allowed to play.
208     require(msg.sender != owner);
209 
210     // There's no way to advance the round exactly at a specific time because the contract only runs
211     // when value is sent to it. So, round advancement must be done just-in-time whenever a player pays to click.
212     // Only advance the round when a player clicks because the next round's timer will begin immediately.
213     if (getIsRoundOver(RoundId)) {
214       advanceRound(); 
215     }
216 
217     Round storage round = Rounds[RoundId];
218 
219     // Safe-guard against spam clicks from a single player.
220     require(msg.sender != round.activePlayer);
221     // Safe-guard against underpayment.
222     require(msg.value >= round.price);
223 
224     // Refund player extra value beyond price. If EtherButton is very popular then its price may
225     // attempt to increase multiple times in a single block. In this situation, the first attempt
226     // would be successful, but subsequent attempts would fail due to insufficient funding. 
227     // To combat this issue, a player may send more value than necessary to
228     // increase the chance of the price being payable with the amount of value they sent.
229     if (msg.value > round.price) {
230       sendPayment(msg.sender, msg.value.sub(round.price));
231     }
232 
233     // Pay the active player and owner for each click past the first.
234     if (round.activePlayer != address(0)) {
235       // Pay the player first because that seems respectful.
236       // Log the player payouts to show on the website.
237       uint playerPayout = getPlayerPayout(round.previousPrice);
238       sendPayment(round.activePlayer, playerPayout);
239       LogPlayerPayout(round.activePlayer, playerPayout);
240 
241       // Pay the contract owner as fee for game creation. Thank you! <3
242       sendPayment(owner, getOwnerFee(round.previousPrice));
243 
244       // Keep track of bonuses collected at same time as sending payouts to ensure financial consistency.
245       round.totalBonus = round.totalBonus.add(getBonusFee(round.previousPrice));
246     }
247 
248     // Update round state to reflect the additional click
249     round.activePlayer = msg.sender;
250     round.playerClickCounts[msg.sender] = round.playerClickCounts[msg.sender].add(1);
251     round.clickCount = round.clickCount.add(1);
252     round.previousPrice = round.price;
253     // Increment the price by 8.50%
254     round.price = getNextPrice(round.price);
255     // Reset the round timer
256     round.endTime = now.add(ROUND_DURATION);
257     
258     // Log an event with relevant information from the round's state.
259     LogClick(
260       round.id,
261       round.price,
262       round.previousPrice,
263       round.endTime,
264       round.clickCount,
265       round.totalBonus,
266       msg.sender,
267       round.playerClickCounts[msg.sender],
268       Rounds[RoundId.sub(1)].totalBonus
269     );
270   }
271 
272   /**
273    * Provides bonus payments to players who wish to claim them.
274    * Bonuses accrue over the course of a round for those playing in the round.
275    * Bonuses may be claimed once the next round starts, but will remain locked until
276    * players participate in that round. The last active player of the previous round
277    * has their bonus unlocked immediately without need to play in the next round.
278    **/
279   function claimBonus() nonReentrant external {
280     // NOTE: The only way to advance the round is to run the 'click' method. When a round is over, it will have expired,
281     // but RoundId will not have (yet) incremented. So, claimBonus needs to check the previous round. This allows EtherButton
282     // to never enter a 'paused' state, which is less code (aka more reliable) but it does have some edge cases.
283     uint roundId = getIsRoundOver(RoundId) ? RoundId.add(1) : RoundId;
284     uint previousRoundId = roundId.sub(1);
285     bool isBonusClaimed = getIsBonusClaimed(previousRoundId, msg.sender);
286 
287     // If player has already claimed their bonus exit early to keep code simple and cheap to run.
288     if (isBonusClaimed) {
289       return;
290     }
291 
292     // If a player can't claim their bonus because they haven't played during the current round
293     // and they were not the last player in the previous round then exit as they're not authorized.
294     bool isBonusUnlockExempt = getIsBonusUnlockExempt(previousRoundId, msg.sender);
295     bool isBonusUnlocked = getPlayerClickCount(roundId, msg.sender) > 0;
296     if (!isBonusUnlockExempt && !isBonusUnlocked) {
297       return;
298     }
299 
300     // If player is owed money from participation in previous round - send it.
301     Round storage previousRound = Rounds[previousRoundId];
302     uint playerClickCount = previousRound.playerClickCounts[msg.sender];
303     uint roundClickCount = previousRound.clickCount;
304     // NOTE: Be sure to multiply first to avoid decimal precision math.
305     uint bonus = previousRound.totalBonus.mul(playerClickCount).div(roundClickCount);
306 
307     // If the current player is owed a refund from previous round fulfill that now.
308     // This is better than forcing the player to make a separate requests for
309     // bonuses and refund payouts.
310     if (previousRound.activePlayer == msg.sender) {
311       bonus = bonus.add(INITIAL_PRICE);
312     }
313 
314     previousRound.bonusClaimedList[msg.sender] = true;
315     previousRound.claimedBonus = previousRound.claimedBonus.add(bonus);
316     sendPayment(msg.sender, bonus);
317 
318     // Let the EtherButton website know a bonus was claimed successfully so it may update.
319     LogClaimBonus(msg.sender, bonus);
320   }
321 
322   /**
323    * Returns true once the given player has claimed their bonus for the given round.
324    * Bonuses are only able to be claimed once per round per player.
325    **/
326   function getIsBonusClaimed(uint roundId, address player) public view returns (bool) {
327     return Rounds[roundId].bonusClaimedList[player];
328   }
329 
330   /**
331    * Returns the number of times the given player has clicked EtherButton during the given round.
332    **/
333   function getPlayerClickCount(uint roundId, address player) public view returns (uint) {
334     return Rounds[roundId].playerClickCounts[player];
335   }
336 
337   /**
338    * Returns true if the given player does not need to be unlocked to claim their bonus.
339    * This is true when they were the last player to click EtherButton in the previous round.
340    * That player deserves freebies for losing. So, they get their bonus unlocked early.
341    **/
342   function getIsBonusUnlockExempt(uint roundId, address player) public view returns (bool) {
343     return Rounds[roundId].activePlayer == player;
344   }
345 
346   /**
347    * Returns true if enough time has elapsed since the active player clicked the
348    * button to consider the given round complete.
349    **/
350   function getIsRoundOver(uint roundId) private view returns (bool) {
351     return now > Rounds[roundId].endTime;
352   }
353 
354   /**
355    * Signal the completion of a round and the start of the next by moving RoundId forward one.
356    * As clean-up before the round change occurs, join all unclaimed player bonuses together and move them
357    * forward one round. Just-in-time initialize the next round's state once RoundId is pointing to it because
358    * an unknown number of rounds may be played. So, it's impossible to initialize all rounds at contract creation.
359    **/
360   function advanceRound() private {
361     if (RoundId > 1) {
362       // Take all of the previous rounds unclaimed bonuses and roll them forward.
363       Round storage previousRound = Rounds[RoundId.sub(1)];      
364       // If the active player of the previous round didn't claim their refund then they lose the ability to claim it.
365       // Their refund is also rolled into the bonuses for the next round.
366       uint remainingBonus = previousRound.totalBonus.add(INITIAL_PRICE).sub(previousRound.claimedBonus);
367       Rounds[RoundId].totalBonus = Rounds[RoundId].totalBonus.add(remainingBonus);
368     }
369 
370     RoundId = RoundId.add(1);
371     initializeRound();
372   }
373 
374   /**
375    * Sets the current round's default values. Initialize the price to 0.500 ETH,
376    * the endTime to 7 hours past the current time and sets the round id. The round is
377    * also started as the endTime is now ticking down.
378    **/
379   function initializeRound() private {
380     Rounds[RoundId].id = RoundId;
381     Rounds[RoundId].endTime = block.timestamp.add(ROUND_DURATION);
382     Rounds[RoundId].price = INITIAL_PRICE;
383   }
384 
385   /**
386    * Sends an amount of Ether to the recipient. Returns true if it was successful.
387    * Logs payment failures to provide documentation on attacks against the contract.
388    **/
389   function sendPayment(address recipient, uint amount) private returns (bool) {
390     assert(recipient != address(0));
391     assert(amount > 0);
392 
393     // It's considered good practice to require users to pull payments rather than pushing
394     // payments to them. Since EtherButton pays the previous player immediately, it has to mitigate
395     // a denial-of-service attack. A malicious contract might always reject money which is sent to it.
396     // This contract could be used to disrupt EtherButton if an assumption is made that money will
397     // always be sent successfully.
398     // https://github.com/ConsenSys/smart-contract-best-practices/blob/master/docs/recommendations.md#favor-pull-over-push-for-external-calls
399     // Intentionally not using recipient.transfer to prevent this DOS attack vector.
400     bool result = recipient.send(amount);
401 
402     // NOTE: Initially, this was written to allow users to reclaim funds on failure.
403     // This was removed due to concerns of allowing attackers to retrieve their funds. It is
404     // not possible for a regular wallet to reject a payment.
405     if (!result) {
406       // Log the failure so attempts to compromise the contract are documented.
407       LogSendPaymentFailure(recipient, amount);
408     }
409 
410     return result;
411   }
412 
413   /**
414     Returns the next price to click EtherButton. The returned value should be 
415     8.50% larger than the current price:
416       - 5.00% is paid to the player.
417       - 1.00% is paid as bonuses.
418       - 2.50% is paid to the owner.
419    **/
420   function getNextPrice(uint price) private pure returns (uint) {
421     uint playerFee = getPlayerFee(price);
422     assert(playerFee > 0);
423 
424     uint bonusFee = getBonusFee(price);
425     assert(bonusFee > 0);
426 
427     uint ownerFee = getOwnerFee(price);
428     assert(ownerFee > 0);
429 
430     return price.add(playerFee).add(bonusFee).add(ownerFee);
431   }
432 
433   /**
434    * Returns 1.00% of the given price. Be sure to multiply before dividing to avoid decimals.
435    **/
436   function getBonusFee(uint price) private pure returns (uint) {
437     return price.mul(BONUS_NUMERATOR).div(BONUS_DENOMINATOR);
438   }
439 
440   /**
441    * Returns 2.50% of the given price. Be sure to multiply before dividing to avoid decimals.
442    **/
443   function getOwnerFee(uint price) private pure returns (uint) {
444     return price.mul(OWNER_FEE_NUMERATOR).div(OWNER_FEE_DENOMINATOR);
445   }
446 
447   /**
448    * Returns 5.00% of the given price. Be sure to multiply before dividing to avoid decimals.
449    **/
450   function getPlayerFee(uint price) private pure returns (uint) {
451     return price.mul(PLAYER_PROFIT_NUMERATOR).div(PLAYER_PROFIT_DENOMINATOR);
452   }
453 
454   /**
455    * Returns the total amount of Ether the active player will receive. This is
456    * 105.00% of their initial price paid.
457    **/
458   function getPlayerPayout(uint price) private pure returns (uint) {
459     return price.add(getPlayerFee(price));
460   }
461 }