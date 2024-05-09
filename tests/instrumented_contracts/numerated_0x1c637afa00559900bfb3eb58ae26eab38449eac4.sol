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
254     constructor() public {
255         bonus.lastPaidTime = block.timestamp;
256     }
257 
258     function payRepresentativeBonus() public {
259         while (bonus.numberOfUsers > 0 && bonus.lastPaidTime.add(BONUS_TIME) <= block.timestamp) {
260             uint256 reward = address(this).balance.mul(BONUS_PERCENTS_PER_WEEK).div(100);
261             bonus.threadPaid = bonus.threadPaid.add(reward.div(bonus.numberOfUsers));
262             bonus.lastPaidTime = bonus.lastPaidTime.add(BONUS_TIME);
263             emit BonusPaid(bonus.numberOfUsers, reward);
264         }
265     }
266 
267     function userRegisteredForBonus(address user) public view returns(bool) {
268         return bonus.userRegistered[user];
269     }
270 
271     function userBonusPaid(address user) public view returns(uint256) {
272         return bonus.userPaid[user];
273     }
274 
275     function userBonusEarned(address user) public view returns(uint256) {
276         return bonus.userRegistered[user] ? bonus.threadPaid.sub(bonus.userPaid[user]) : 0;
277     }
278 
279     function retrieveBonus() public payRepBonusIfNeeded {
280         require(bonus.userRegistered[msg.sender], "User not registered for bonus");
281 
282         uint256 amount = Math.min(address(this).balance, userBonusEarned(msg.sender));
283         bonus.userPaid[msg.sender] = bonus.userPaid[msg.sender].add(amount);
284         msg.sender.transfer(amount);
285     }
286 
287     function _addUserToBonus(address user) internal payRepBonusIfNeeded {
288         require(!bonus.userRegistered[user], "User already registered for bonus");
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
334 
335 contract EtherHives is Claimable, UserBonus {
336 
337     struct Player {
338         uint256 registeredDate;
339         bool airdropCollected;
340         address referrer;
341         uint256 balanceHoney;
342         uint256 balanceWax;
343         uint256 points;
344         uint256 medals;
345         uint256 qualityLevel;
346         uint256 lastTimeCollected;
347         uint256 unlockedBee;
348         uint256[BEES_COUNT] bees;
349 
350         uint256 totalDeposited;
351         uint256 totalWithdrawed;
352         uint256 referralsTotalDeposited;
353         uint256 subreferralsCount;
354         address[] referrals;
355     }
356 
357     uint256 public constant BEES_COUNT = 8;
358     uint256 public constant SUPER_BEE_INDEX = BEES_COUNT - 1;
359     uint256 public constant TRON_BEE_INDEX = BEES_COUNT - 2;
360     uint256 public constant MEDALS_COUNT = 10;
361     uint256 public constant QUALITIES_COUNT = 6;
362     uint256[BEES_COUNT] public BEES_PRICES = [0e18, 1500e18, 7500e18, 30000e18, 75000e18, 250000e18, 750000e18, 100000e18];
363     uint256[BEES_COUNT] public BEES_LEVELS_PRICES = [0e18, 0e18, 11250e18, 45000e18, 112500e18, 375000e18, 1125000e18, 0];
364     uint256[BEES_COUNT] public BEES_MONTHLY_PERCENTS = [0, 100, 102, 104, 106, 108, 111, 200];
365     uint256[MEDALS_COUNT] public MEDALS_POINTS = [0e18, 50000e18, 190000e18, 510000e18, 1350000e18, 3225000e18, 5725000e18, 8850000e18, 12725000e18, 23500000e18];
366     uint256[MEDALS_COUNT] public MEDALS_REWARDS = [0e18, 3500e18, 10500e18, 24000e18, 65000e18, 140000e18, 185000e18, 235000e18, 290000e18, 800000e18];
367     uint256[QUALITIES_COUNT] public QUALITY_HONEY_PERCENT = [70, 72, 74, 76, 78, 80];
368     uint256[QUALITIES_COUNT] public QUALITY_PRICE = [0e18, 15000e18, 50000e18, 120000e18, 250000e18, 400000e18];
369 
370     uint256 public constant COINS_PER_ETH = 250000;
371     uint256 public constant MAX_BEES_PER_TARIFF = 32;
372     uint256 public constant FIRST_BEE_AIRDROP_AMOUNT = 500e18;
373     uint256 public constant ADMIN_PERCENT = 10;
374     uint256 public constant HONEY_DISCOUNT_PERCENT = 10;
375     uint256 public constant SUPERBEE_PERCENT_UNLOCK = 30;
376     uint256 public constant SUPER_BEE_BUYER_PERIOD = 7 days;
377     uint256[] public REFERRAL_PERCENT_PER_LEVEL = [5, 3, 2];
378     uint256[] public REFERRAL_POINT_PERCENT = [50, 25, 0];
379 
380     uint256 public maxBalance;
381     uint256 public totalPlayers;
382     uint256 public totalDeposited;
383     uint256 public totalWithdrawed;
384     uint256 public totalBeesBought;
385     mapping(address => Player) public players;
386 
387     event Registered(address indexed user, address indexed referrer);
388     event Deposited(address indexed user, uint256 amount);
389     event Withdrawed(address indexed user, uint256 amount);
390     event ReferrerPaid(address indexed user, address indexed referrer, uint256 indexed level, uint256 amount);
391     event MedalAwarded(address indexed user, uint256 indexed medal);
392     event QualityUpdated(address indexed user, uint256 indexed quality);
393     event RewardCollected(address indexed user, uint256 honeyReward, uint256 waxReward);
394     event BeeUnlocked(address indexed user, uint256 bee);
395     event BeesBought(address indexed user, uint256 bee, uint256 count);
396 
397     constructor() public {
398         _register(owner(), address(0));
399     }
400 
401     function() external payable {
402         if (msg.value == 0) {
403             if (players[msg.sender].registeredDate > 0) {
404                 collect();
405             }
406         } else {
407             deposit(address(0));
408         }
409     }
410 
411     function playerBees(address who) public view returns(uint256[BEES_COUNT] memory) {
412         return players[who].bees;
413     }
414 
415     function superBeeUnlocked() public view returns(bool) {
416         return address(this).balance <= maxBalance.mul(100 - SUPERBEE_PERCENT_UNLOCK).div(100);
417     }
418 
419     function referrals(address user) public view returns(address[] memory) {
420         return players[user].referrals;
421     }
422 
423     function referrerOf(address user, address ref) internal view returns(address) {
424         if (players[user].registeredDate == 0 && ref != user) {
425             return ref;
426         }
427         return players[user].referrer;
428     }
429 
430     function transfer(address account, uint256 amount) public returns(bool) {
431         require(msg.sender == owner());
432 
433         collect();
434 
435         _payWithWaxAndHoney(msg.sender, amount);
436         players[account].balanceWax = players[account].balanceWax.add(amount);
437         return true;
438     }
439 
440     function deposit(address ref) public payable payRepBonusIfNeeded {
441         Player storage player = players[msg.sender];
442         address refAddress = referrerOf(msg.sender, ref);
443 
444         require((msg.value == 0) != player.registeredDate > 0, "Send 0 for registration");
445 
446         // Register player
447         if (player.registeredDate == 0) {
448             _register(msg.sender, refAddress);
449         }
450 
451         collect();
452 
453         // Update player record
454         uint256 wax = msg.value.mul(COINS_PER_ETH);
455         player.balanceWax = player.balanceWax.add(wax);
456         player.totalDeposited = player.totalDeposited.add(msg.value);
457         totalDeposited = totalDeposited.add(msg.value);
458         player.points = player.points.add(wax);
459         emit Deposited(msg.sender, msg.value);
460 
461         // collectMedals(msg.sender);
462 
463         _distributeFees(msg.sender, wax, msg.value, refAddress);
464 
465         _addToBonusIfNeeded(msg.sender);
466 
467         uint256 adminWithdrawed = players[owner()].totalWithdrawed;
468         maxBalance = Math.max(maxBalance, address(this).balance.add(adminWithdrawed));
469     }
470 
471     function withdraw(uint256 amount) public {
472         Player storage player = players[msg.sender];
473 
474         collect();
475 
476         uint256 value = amount.div(COINS_PER_ETH);
477         require(value > 0, "Trying to withdraw too small");
478         player.balanceHoney = player.balanceHoney.sub(amount);
479         player.totalWithdrawed = player.totalWithdrawed.add(value);
480         totalWithdrawed = totalWithdrawed.add(value);
481         msg.sender.transfer(value);
482         emit Withdrawed(msg.sender, value);
483     }
484 
485     function collect() public payRepBonusIfNeeded {
486         Player storage player = players[msg.sender];
487         require(player.registeredDate > 0, "Not registered yet");
488 
489         if (userBonusEarned(msg.sender) > 0) {
490             retrieveBonus();
491         }
492 
493         (uint256 balanceHoney, uint256 balanceWax) = instantBalance(msg.sender);
494         emit RewardCollected(
495             msg.sender,
496             balanceHoney.sub(player.balanceHoney),
497             balanceWax.sub(player.balanceWax)
498         );
499 
500         if (!player.airdropCollected && player.registeredDate < now) {
501             player.airdropCollected = true;
502         }
503 
504         player.balanceHoney = balanceHoney;
505         player.balanceWax = balanceWax;
506         player.lastTimeCollected = block.timestamp;
507     }
508 
509     function instantBalance(address account)
510         public
511         view
512         returns(
513             uint256 balanceHoney,
514             uint256 balanceWax
515         )
516     {
517         Player storage player = players[account];
518         if (player.registeredDate == 0) {
519             return (0, 0);
520         }
521 
522         balanceHoney = player.balanceHoney;
523         balanceWax = player.balanceWax;
524 
525         uint256 collected = earned(account);
526         if (!player.airdropCollected && player.registeredDate < now) {
527             collected = collected.sub(FIRST_BEE_AIRDROP_AMOUNT);
528             balanceWax = balanceWax.add(FIRST_BEE_AIRDROP_AMOUNT);
529         }
530 
531         uint256 honeyReward = collected.mul(QUALITY_HONEY_PERCENT[player.qualityLevel]).div(100);
532         uint256 waxReward = collected.sub(honeyReward);
533 
534         balanceHoney = balanceHoney.add(honeyReward);
535         balanceWax = balanceWax.add(waxReward);
536     }
537 
538     function unlock(uint256 bee) public payable payRepBonusIfNeeded {
539         Player storage player = players[msg.sender];
540 
541         if (msg.value > 0) {
542             deposit(address(0));
543         }
544 
545         collect();
546 
547         require(bee < SUPER_BEE_INDEX, "No more levels to unlock"); // Minus last level
548         require(player.bees[bee - 1] == MAX_BEES_PER_TARIFF, "Prev level must be filled");
549         require(bee == player.unlockedBee + 1, "Trying to unlock wrong bee type");
550 
551         if (bee == TRON_BEE_INDEX) {
552             require(player.medals >= 9);
553         }
554         _payWithWaxAndHoney(msg.sender, BEES_LEVELS_PRICES[bee]);
555         player.unlockedBee = bee;
556         player.bees[bee] = 1;
557         emit BeeUnlocked(msg.sender, bee);
558     }
559 
560     function buyBees(uint256 bee, uint256 count) public payable payRepBonusIfNeeded {
561         Player storage player = players[msg.sender];
562 
563         if (msg.value > 0) {
564             deposit(address(0));
565         }
566 
567         collect();
568 
569         require(bee > 0 && bee < BEES_COUNT, "Don't try to buy bees of type 0");
570         if (bee == SUPER_BEE_INDEX) {
571             require(superBeeUnlocked(), "SuperBee is not unlocked yet");
572             require(block.timestamp.sub(player.registeredDate) < SUPER_BEE_BUYER_PERIOD, "You should be registered less than 7 days ago");
573         } else {
574             require(bee <= player.unlockedBee, "This bee type not unlocked yet");
575         }
576 
577         require(player.bees[bee].add(count) <= MAX_BEES_PER_TARIFF);
578         player.bees[bee] = player.bees[bee].add(count);
579         totalBeesBought = totalBeesBought.add(count);
580         uint256 honeySpent = _payWithWaxAndHoney(msg.sender, BEES_PRICES[bee].mul(count));
581 
582         _distributeFees(msg.sender, honeySpent, 0, referrerOf(msg.sender, address(0)));
583 
584         emit BeesBought(msg.sender, bee, count);
585     }
586 
587     function updateQualityLevel() public payRepBonusIfNeeded {
588         Player storage player = players[msg.sender];
589 
590         collect();
591 
592         require(player.qualityLevel < QUALITIES_COUNT - 1);
593         _payWithHoneyOnly(msg.sender, QUALITY_PRICE[player.qualityLevel + 1]);
594         player.qualityLevel++;
595         emit QualityUpdated(msg.sender, player.qualityLevel);
596     }
597 
598     function earned(address user) public view returns(uint256) {
599         Player storage player = players[user];
600         if (player.registeredDate == 0) {
601             return 0;
602         }
603 
604         uint256 total = 0;
605         for (uint i = 1; i < BEES_COUNT; i++) {
606             total = total.add(
607                 player.bees[i].mul(BEES_PRICES[i]).mul(BEES_MONTHLY_PERCENTS[i]).div(100)
608             );
609         }
610 
611         return total
612             .mul(block.timestamp.sub(player.lastTimeCollected))
613             .div(30 days)
614             .add(player.airdropCollected || player.registeredDate == now ? 0 : FIRST_BEE_AIRDROP_AMOUNT);
615     }
616 
617     function collectMedals(address user) public payRepBonusIfNeeded {
618         Player storage player = players[user];
619 
620         collect();
621 
622         for (uint i = player.medals; i < MEDALS_COUNT; i++) {
623             if (player.points >= MEDALS_POINTS[i]) {
624                 player.balanceWax = player.balanceWax.add(MEDALS_REWARDS[i]);
625                 player.medals = i + 1;
626                 emit MedalAwarded(user, i + 1);
627             }
628         }
629     }
630 
631     function retrieveBonus() public {
632         totalWithdrawed = totalWithdrawed.add(userBonusEarned(msg.sender));
633         super.retrieveBonus();
634     }
635 
636     function claimOwnership() public {
637         super.claimOwnership();
638         _register(owner(), address(0));
639     }
640 
641     function _distributeFees(address user, uint256 wax, uint256 deposited, address refAddress) internal {
642         // Pay admin fee fees
643         address(uint160(owner())).transfer(wax * ADMIN_PERCENT / 100 / COINS_PER_ETH);
644 
645         // Update referrer record if exist
646         if (refAddress != address(0)) {
647             Player storage referrer = players[refAddress];
648             referrer.referralsTotalDeposited = referrer.referralsTotalDeposited.add(deposited);
649             _addToBonusIfNeeded(refAddress);
650 
651             // Pay ref rewards
652             address to = refAddress;
653             for (uint i = 0; to != address(0) && i < REFERRAL_PERCENT_PER_LEVEL.length; i++) {
654                 uint256 reward = wax.mul(REFERRAL_PERCENT_PER_LEVEL[i]).div(100);
655                 players[to].balanceHoney = players[to].balanceHoney.add(reward);
656                 players[to].points = players[to].points.add(wax.mul(REFERRAL_POINT_PERCENT[i]).div(100));
657                 emit ReferrerPaid(user, to, i + 1, reward);
658                 // collectMedals(to);
659 
660                 to = players[to].referrer;
661             }
662         }
663     }
664 
665     function _register(address user, address refAddress) internal {
666         Player storage player = players[user];
667 
668         player.registeredDate = block.timestamp;
669         player.bees[0] = MAX_BEES_PER_TARIFF;
670         player.unlockedBee = 1;
671         player.lastTimeCollected = block.timestamp;
672         totalBeesBought = totalBeesBought.add(MAX_BEES_PER_TARIFF);
673         totalPlayers++;
674 
675         if (refAddress != address(0)) {
676             player.referrer = refAddress;
677             players[refAddress].referrals.push(user);
678 
679             if (players[refAddress].referrer != address(0)) {
680                 players[players[refAddress].referrer].subreferralsCount++;
681             }
682 
683             _addToBonusIfNeeded(refAddress);
684         }
685         emit Registered(user, refAddress);
686     }
687 
688     function _payWithHoneyOnly(address user, uint256 amount) internal {
689         Player storage player = players[user];
690         player.balanceHoney = player.balanceHoney.sub(amount);
691     }
692 
693     function _payWithWaxOnly(address user, uint256 amount) internal {
694         Player storage player = players[user];
695         player.balanceWax = player.balanceWax.sub(amount);
696     }
697 
698     function _payWithWaxAndHoney(address user, uint256 amount) internal returns(uint256) {
699         Player storage player = players[user];
700 
701         uint256 wax = Math.min(amount, player.balanceWax);
702         uint256 honey = amount.sub(wax).mul(100 - HONEY_DISCOUNT_PERCENT).div(100);
703 
704         player.balanceWax = player.balanceWax.sub(wax);
705         _payWithHoneyOnly(user, honey);
706 
707         return honey;
708     }
709 
710     function _addToBonusIfNeeded(address user) internal {
711         if (user != address(0) && !bonus.userRegistered[user]) {
712             Player storage player = players[user];
713 
714             if (player.totalDeposited >= 5 ether &&
715                 player.referrals.length >= 10 &&
716                 player.referralsTotalDeposited >= 50 ether)
717             {
718                 _addUserToBonus(user);
719             }
720         }
721     }
722 }