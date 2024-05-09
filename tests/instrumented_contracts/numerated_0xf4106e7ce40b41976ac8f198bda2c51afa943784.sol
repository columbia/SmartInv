1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 // File: @openzeppelin/contracts/ownership/Ownable.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be aplied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         _owner = msg.sender;
56         emit OwnershipTransferred(address(0), _owner);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(isOwner(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Returns true if the caller is the current owner.
76      */
77     function isOwner() public view returns (bool) {
78         return msg.sender == _owner;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * > Note: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public onlyOwner {
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      */
104     function _transferOwnership(address newOwner) internal {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/math/SafeMath.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b <= a, "SafeMath: subtraction overflow");
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the multiplication of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `*` operator.
166      *
167      * Requirements:
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172         // benefit is lost if 'b' is also tested.
173         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174         if (a == 0) {
175             return 0;
176         }
177 
178         uint256 c = a * b;
179         require(c / a == b, "SafeMath: multiplication overflow");
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         // Solidity only automatically asserts when dividing by 0
197         require(b > 0, "SafeMath: division by zero");
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      */
215     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216         require(b != 0, "SafeMath: modulo by zero");
217         return a % b;
218     }
219 }
220 
221 // File: contracts/UserBonus.sol
222 
223 pragma solidity ^0.5.0;
224 
225 
226 
227 
228 
229 contract UserBonus {
230 
231     using SafeMath for uint256;
232 
233     uint256 public constant BONUS_PERCENTS_PER_WEEK = 1;
234     uint256 public constant BONUS_TIME = 1 weeks;
235 
236     struct UserBonusData {
237         uint256 threadPaid;
238         uint256 lastPaidTime;
239         uint256 numberOfUsers;
240         mapping(address => bool) userRegistered;
241         mapping(address => uint256) userPaid;
242     }
243 
244     UserBonusData public bonus;
245 
246     event BonusPaid(uint256 users, uint256 amount);
247     event UserAddedToBonus(address indexed user);
248 
249     modifier payRepBonusIfNeeded {
250         payRepresentativeBonus();
251         _;
252     }
253 
254     function payRepresentativeBonus() public {
255         while (bonus.numberOfUsers > 0 && bonus.lastPaidTime.add(BONUS_TIME) <= block.timestamp) {
256             uint256 reward = address(this).balance.mul(BONUS_PERCENTS_PER_WEEK).div(100);
257             bonus.threadPaid = bonus.threadPaid.add(reward.div(bonus.numberOfUsers));
258             bonus.lastPaidTime = bonus.lastPaidTime.add(BONUS_TIME);
259             emit BonusPaid(bonus.numberOfUsers, reward);
260         }
261     }
262 
263     function userRegisteredForBonus(address user) public view returns(bool) {
264         return bonus.userRegistered[user];
265     }
266 
267     function userBonusPaid(address user) public view returns(uint256) {
268         return bonus.userPaid[user];
269     }
270 
271     function userBonusEarned(address user) public view returns(uint256) {
272         return bonus.userRegistered[user] ? bonus.threadPaid.sub(bonus.userPaid[user]) : 0;
273     }
274 
275     function retrieveBonus() public payRepBonusIfNeeded {
276         require(bonus.userRegistered[msg.sender], "User not registered for bonus");
277 
278         uint256 amount = Math.min(address(this).balance, userBonusEarned(msg.sender));
279         bonus.userPaid[msg.sender] = bonus.userPaid[msg.sender].add(amount);
280         msg.sender.transfer(amount);
281     }
282 
283     function _addUserToBonus(address user) internal payRepBonusIfNeeded {
284         require(!bonus.userRegistered[msg.sender], "User already registered for bonus");
285 
286         if (bonus.numberOfUsers == 0) {
287             bonus.lastPaidTime = block.timestamp;
288         }
289 
290         bonus.userRegistered[user] = true;
291         bonus.userPaid[user] = bonus.threadPaid;
292         bonus.numberOfUsers = bonus.numberOfUsers.add(1);
293         emit UserAddedToBonus(user);
294     }
295 }
296 
297 // File: contracts/Claimable.sol
298 
299 pragma solidity ^0.5.0;
300 
301 
302 
303 contract Claimable is Ownable {
304 
305     address public pendingOwner;
306 
307     modifier onlyPendingOwner() {
308         require(msg.sender == pendingOwner);
309         _;
310     }
311 
312     function renounceOwnership() public onlyOwner {
313         revert();
314     }
315 
316     function transferOwnership(address newOwner) public onlyOwner {
317         pendingOwner = newOwner;
318     }
319 
320     function claimOwnership() public onlyPendingOwner {
321         _transferOwnership(pendingOwner);
322         delete pendingOwner;
323     }
324 }
325 
326 // File: contracts/EtherHives.sol
327 
328 pragma solidity ^0.5.0;
329 
330 
331 
332 
333 
334 contract EtherHives is Claimable, UserBonus {
335 
336     struct Player {
337         bool registered;
338         bool airdropCollected;
339         address referrer;
340         uint256 balanceHoney;
341         uint256 balanceWax;
342         uint256 points;
343         uint256 medals;
344         uint256 qualityLevel;
345         uint256 lastTimeCollected;
346         uint256 unlockedBee;
347         uint256[BEES_COUNT] bees;
348 
349         uint256 totalDeposited;
350         uint256 totalWithdrawed;
351         uint256 referralsTotalDeposited;
352         uint256 subreferralsCount;
353         address[] referrals;
354     }
355 
356     uint256 public constant BEES_COUNT = 8;
357     uint256 public constant SUPER_BEE_INDEX = BEES_COUNT - 1;
358     uint256 public constant TRON_BEE_INDEX = BEES_COUNT - 2;
359     uint256 public constant MEDALS_COUNT = 10;
360     uint256 public constant QUALITIES_COUNT = 6;
361     uint256[BEES_COUNT] public BEES_PRICES = [0e18, 1500e18, 7500e18, 30000e18, 75000e18, 250000e18, 750000e18, 150000e18];
362     uint256[BEES_COUNT] public BEES_LEVELS_PRICES = [0e18, 0e18, 11250e18, 45000e18, 112500e18, 375000e18, 1125000e18, 0];
363     uint256[BEES_COUNT] public BEES_MONTHLY_PERCENTS = [0, 100, 102, 104, 106, 108, 111, 125];
364     uint256[MEDALS_COUNT] public MEDALS_POINTS = [0e18, 50000e18, 190000e18, 510000e18, 1350000e18, 3225000e18, 5725000e18, 8850000e18, 12725000e18, 23500000e18];
365     uint256[MEDALS_COUNT] public MEDALS_REWARDS = [0e18, 3500e18, 10500e18, 24000e18, 65000e18, 140000e18, 185000e18, 235000e18, 290000e18, 800000e18];
366     uint256[QUALITIES_COUNT] public QUALITY_HONEY_PERCENT = [40, 42, 44, 46, 48, 50];
367     uint256[QUALITIES_COUNT] public QUALITY_PRICE = [0e18, 15000e18, 50000e18, 120000e18, 250000e18, 400000e18];
368 
369     uint256 public constant COINS_PER_ETH = 250000;
370     uint256 public constant MAX_BEES_PER_TARIFF = 32;
371     uint256 public constant FIRST_BEE_AIRDROP_AMOUNT = 1000e18;
372     uint256 public constant ADMIN_PERCENT = 10;
373     uint256 public constant HONEY_DISCOUNT_PERCENT = 10;
374     uint256 public constant SUPERBEE_PERCENT_UNLOCK = 25;
375     uint256[] public REFERRAL_PERCENT_PER_LEVEL = [5, 3, 2];
376     uint256[] public REFERRAL_POINT_PERCENT = [50, 25, 0];
377 
378     uint256 public maxBalance;
379     uint256 public totalPlayers;
380     uint256 public totalDeposited;
381     uint256 public totalWithdrawed;
382     uint256 public totalBeesBought;
383     mapping(address => Player) public players;
384 
385     event Registered(address indexed user, address indexed referrer);
386     event Deposited(address indexed user, uint256 amount);
387     event Withdrawed(address indexed user, uint256 amount);
388     event ReferrerPaid(address indexed user, address indexed referrer, uint256 indexed level, uint256 amount);
389     event MedalAwarded(address indexed user, uint256 indexed medal);
390     event QualityUpdated(address indexed user, uint256 indexed quality);
391     event RewardCollected(address indexed user, uint256 honeyReward, uint256 waxReward);
392     event BeeUnlocked(address indexed user, uint256 bee);
393     event BeesBought(address indexed user, uint256 bee, uint256 count);
394 
395     constructor() public {
396         _register(owner(), address(0));
397     }
398 
399     function() external payable {
400         if (msg.value == 0) {
401             if (players[msg.sender].registered) {
402                 collect();
403             }
404         } else {
405             deposit(address(0));
406         }
407     }
408 
409     function playerBees(address who) public view returns(uint256[BEES_COUNT] memory) {
410         return players[who].bees;
411     }
412 
413     function superBeeUnlocked() public view returns(bool) {
414         uint256 adminWithdrawed = players[owner()].totalWithdrawed;
415         return address(this).balance.add(adminWithdrawed) <= maxBalance.mul(100 - SUPERBEE_PERCENT_UNLOCK).div(100);
416     }
417 
418     function referrals(address user) public view returns(address[] memory) {
419         return players[user].referrals;
420     }
421 
422     function referrerOf(address user, address ref) internal view returns(address) {
423         if (!players[user].registered && ref != user) {
424             return ref;
425         }
426         return players[user].referrer;
427     }
428 
429     function transfer(address account, uint256 amount) public returns(bool) {
430         require(msg.sender == owner());
431         _payWithWaxAndHoney(msg.sender, amount);
432         players[account].balanceWax = players[account].balanceWax.add(amount);
433         return true;
434     }
435 
436     function deposit(address ref) public payable payRepBonusIfNeeded {
437         Player storage player = players[msg.sender];
438         address refAddress = referrerOf(msg.sender, ref);
439 
440         require((msg.value == 0) != player.registered, "Send 0 for registration");
441 
442         // Register player
443         if (!player.registered) {
444             _register(msg.sender, refAddress);
445         }
446 
447         // Update player record
448         uint256 wax = msg.value.mul(COINS_PER_ETH);
449         player.balanceWax = player.balanceWax.add(wax);
450         player.totalDeposited = player.totalDeposited.add(msg.value);
451         totalDeposited = totalDeposited.add(msg.value);
452         player.points = player.points.add(wax);
453         emit Deposited(msg.sender, msg.value);
454 
455         // collectMedals(msg.sender);
456 
457         _distributeFees(msg.sender, wax, msg.value, refAddress);
458 
459         _addToBonusIfNeeded(msg.sender);
460 
461         uint256 adminWithdrawed = players[owner()].totalWithdrawed;
462         maxBalance = Math.max(maxBalance, address(this).balance.add(adminWithdrawed));
463     }
464 
465     function withdraw(uint256 amount) public {
466         Player storage player = players[msg.sender];
467 
468         collect();
469 
470         uint256 value = amount.div(COINS_PER_ETH);
471         require(value > 0, "Trying to withdraw too small");
472         player.balanceHoney = player.balanceHoney.sub(amount);
473         player.totalWithdrawed = player.totalWithdrawed.add(value);
474         totalWithdrawed = totalWithdrawed.add(value);
475         msg.sender.transfer(value);
476         emit Withdrawed(msg.sender, value);
477     }
478 
479     function collect() public payRepBonusIfNeeded {
480         Player storage player = players[msg.sender];
481         require(player.registered, "Not registered yet");
482 
483         if (userBonusEarned(msg.sender) > 0) {
484             retrieveBonus();
485         }
486 
487         (uint256 balanceHoney, uint256 balanceWax) = instantBalance(msg.sender);
488         emit RewardCollected(
489             msg.sender,
490             balanceHoney.sub(player.balanceHoney),
491             balanceWax.sub(player.balanceWax)
492         );
493 
494         if (!player.airdropCollected) {
495             player.airdropCollected = true;
496         }
497 
498         player.balanceHoney = balanceHoney;
499         player.balanceWax = balanceWax;
500         player.lastTimeCollected = block.timestamp;
501     }
502 
503     function instantBalance(address account)
504         public
505         view
506         returns(
507             uint256 balanceHoney,
508             uint256 balanceWax
509         )
510     {
511         Player storage player = players[account];
512         if (!player.registered) {
513             return (0, 0);
514         }
515 
516         balanceHoney = player.balanceHoney;
517         balanceWax = player.balanceWax;
518 
519         uint256 collected = earned(account);
520         if (!player.airdropCollected) {
521             collected = collected.sub(FIRST_BEE_AIRDROP_AMOUNT);
522             balanceWax = balanceWax.add(FIRST_BEE_AIRDROP_AMOUNT);
523         }
524 
525         uint256 honeyReward = collected.mul(QUALITY_HONEY_PERCENT[player.qualityLevel]).div(100);
526         uint256 waxReward = collected.sub(honeyReward);
527 
528         balanceHoney = balanceHoney.add(honeyReward);
529         balanceWax = balanceWax.add(waxReward);
530     }
531 
532     function unlock(uint256 bee) public payable payRepBonusIfNeeded {
533         Player storage player = players[msg.sender];
534 
535         if (msg.value > 0) {
536             deposit(address(0));
537         }
538 
539         require(bee < SUPER_BEE_INDEX, "No more levels to unlock"); // Minus last level
540         require(player.bees[bee - 1] == MAX_BEES_PER_TARIFF, "Prev level must be filled");
541         require(bee == player.unlockedBee + 1, "Trying to unlock wrong bee type");
542 
543         if (bee == TRON_BEE_INDEX) {
544             require(player.medals >= 9);
545         }
546         _payWithWaxAndHoney(msg.sender, BEES_LEVELS_PRICES[bee]);
547         player.unlockedBee = bee;
548         player.bees[bee] = 1;
549         emit BeeUnlocked(msg.sender, bee);
550     }
551 
552     function buyBees(uint256 bee, uint256 count) public payable payRepBonusIfNeeded {
553         Player storage player = players[msg.sender];
554 
555         if (msg.value > 0) {
556             deposit(address(0));
557         }
558 
559         collect();
560 
561         require(bee > 0 && bee < BEES_COUNT, "Don't try to buy bees of type 0");
562         if (bee == SUPER_BEE_INDEX) {
563             require(superBeeUnlocked(), "SuperBee is not unlocked yet");
564         } else {
565             require(bee <= player.unlockedBee, "This bee type not unlocked yet");
566         }
567 
568         require(player.bees[bee].add(count) <= MAX_BEES_PER_TARIFF);
569         player.bees[bee] = player.bees[bee].add(count);
570         totalBeesBought = totalBeesBought.add(count);
571         uint256 honeySpent = _payWithWaxAndHoney(msg.sender, BEES_PRICES[bee].mul(count));
572 
573         _distributeFees(msg.sender, honeySpent, 0, referrerOf(msg.sender, address(0)));
574 
575         emit BeesBought(msg.sender, bee, count);
576     }
577 
578     function updateQualityLevel() public payRepBonusIfNeeded {
579         Player storage player = players[msg.sender];
580 
581         collect();
582 
583         require(player.qualityLevel < QUALITIES_COUNT - 1);
584         _payWithHoneyOnly(msg.sender, QUALITY_PRICE[player.qualityLevel + 1]);
585         player.qualityLevel++;
586         emit QualityUpdated(msg.sender, player.qualityLevel);
587     }
588 
589     function earned(address user) public view returns(uint256) {
590         Player storage player = players[user];
591         if (!player.registered) {
592             return 0;
593         }
594 
595         uint256 total = 0;
596         for (uint i = 1; i < BEES_COUNT; i++) {
597             total = total.add(
598                 player.bees[i].mul(BEES_PRICES[i]).mul(BEES_MONTHLY_PERCENTS[i]).div(100)
599             );
600         }
601 
602         return total
603             .mul(block.timestamp.sub(player.lastTimeCollected))
604             .div(30 days)
605             .add(player.airdropCollected ? 0 : FIRST_BEE_AIRDROP_AMOUNT);
606     }
607 
608     function collectMedals(address user) public payRepBonusIfNeeded {
609         Player storage player = players[user];
610 
611         for (uint i = player.medals; i < MEDALS_COUNT; i++) {
612             if (player.points >= MEDALS_POINTS[i]) {
613                 player.balanceWax = player.balanceWax.add(MEDALS_REWARDS[i]);
614                 player.medals = i + 1;
615                 emit MedalAwarded(user, i + 1);
616             }
617         }
618     }
619 
620     function retrieveBonus() public {
621         totalWithdrawed = totalWithdrawed.add(userBonusEarned(msg.sender));
622         super.retrieveBonus();
623     }
624 
625     function claimOwnership() public {
626         super.claimOwnership();
627         _register(owner(), address(0));
628     }
629 
630     function _distributeFees(address user, uint256 wax, uint256 deposited, address refAddress) internal {
631         // Pay admin fee fees
632         players[owner()].balanceHoney = players[owner()].balanceHoney.add(
633             wax.mul(ADMIN_PERCENT).div(100)
634         );
635 
636         // Update referrer record if exist
637         if (refAddress != address(0)) {
638             Player storage referrer = players[refAddress];
639 
640             // Pay ref rewards
641             address to = refAddress;
642             for (uint i = 0; to != address(0) && i < REFERRAL_PERCENT_PER_LEVEL.length; i++) {
643                 uint256 reward = wax.mul(REFERRAL_PERCENT_PER_LEVEL[i]).div(100);
644                 players[to].balanceHoney = players[to].balanceHoney.add(reward);
645                 players[to].points = players[to].points.add(wax.mul(REFERRAL_POINT_PERCENT[i]).div(100));
646                 emit ReferrerPaid(user, to, i + 1, reward);
647                 // collectMedals(to);
648 
649                 to = players[to].referrer;
650             }
651 
652             referrer.referralsTotalDeposited = referrer.referralsTotalDeposited.add(deposited);
653             _addToBonusIfNeeded(refAddress);
654         }
655     }
656 
657     function _register(address user, address refAddress) internal {
658         Player storage player = players[user];
659 
660         player.registered = true;
661         player.bees[0] = MAX_BEES_PER_TARIFF;
662         player.unlockedBee = 1;
663         player.lastTimeCollected = block.timestamp;
664         totalBeesBought = totalBeesBought.add(MAX_BEES_PER_TARIFF);
665         totalPlayers++;
666 
667         if (refAddress != address(0)) {
668             player.referrer = refAddress;
669             players[refAddress].referrals.push(user);
670 
671             if (players[refAddress].referrer != address(0)) {
672                 players[players[refAddress].referrer].subreferralsCount++;
673             }
674 
675             _addToBonusIfNeeded(refAddress);
676         }
677         emit Registered(user, refAddress);
678     }
679 
680     function _payWithHoneyOnly(address user, uint256 amount) internal {
681         Player storage player = players[user];
682         player.balanceHoney = player.balanceHoney.sub(amount);
683     }
684 
685     function _payWithWaxOnly(address user, uint256 amount) internal {
686         Player storage player = players[user];
687         player.balanceWax = player.balanceWax.sub(amount);
688     }
689 
690     function _payWithWaxAndHoney(address user, uint256 amount) internal returns(uint256) {
691         Player storage player = players[user];
692 
693         uint256 wax = Math.min(amount, player.balanceWax);
694         uint256 honey = amount.sub(wax).mul(100 - HONEY_DISCOUNT_PERCENT).div(100);
695 
696         player.balanceWax = player.balanceWax.sub(wax);
697         _payWithHoneyOnly(user, honey);
698 
699         return honey;
700     }
701 
702     function _addToBonusIfNeeded(address user) internal {
703         if (user != address(0) && !bonus.userRegistered[user]) {
704             Player storage player = players[user];
705 
706             if (player.totalDeposited >= 5 ether &&
707                 player.referrals.length >= 10 &&
708                 player.referralsTotalDeposited >= 50 ether)
709             {
710                 _addUserToBonus(user);
711             }
712         }
713     }
714 }