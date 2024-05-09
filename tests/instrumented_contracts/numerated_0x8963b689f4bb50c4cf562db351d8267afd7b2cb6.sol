1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 library Math {
7     
8     function max(uint256 a, uint256 b) internal pure returns (uint256) {
9         return a >= b ? a : b;
10     }
11 
12     
13     function min(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a < b ? a : b;
15     }
16 
17     
18     function average(uint256 a, uint256 b) internal pure returns (uint256) {
19         
20         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
21     }
22 }
23 
24 contract Context {
25     
26     
27     constructor () internal { }
28 
29     function _msgSender() internal view virtual returns (address payable) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes memory) {
34         this; 
35         return msg.data;
36     }
37 }
38 
39 contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     
45     constructor () internal {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     
52     function owner() public view returns (address) {
53         return _owner;
54     }
55 
56     
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     
63     function renounceOwnership() public virtual onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67 
68     
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 library SafeMath {
77     
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81 
82         return c;
83     }
84 
85     
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89 
90     
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         
101         
102         
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109 
110         return c;
111     }
112 
113     
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         
124 
125         return c;
126     }
127 
128     
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         return mod(a, b, "SafeMath: modulo by zero");
131     }
132 
133     
134     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b != 0, errorMessage);
136         return a % b;
137     }
138 }
139 
140 contract UserBonus {
141 
142     using SafeMath for uint256;
143 
144     uint256 public constant BONUS_PERCENTS_PER_WEEK = 1;
145     uint256 public constant BONUS_TIME = 1 weeks;
146 
147     struct UserBonusData {
148         uint256 threadPaid;
149         uint256 lastPaidTime;
150         uint256 numberOfUsers;
151         mapping(address => bool) userRegistered;
152         mapping(address => uint256) userPaid;
153     }
154 
155     UserBonusData public bonus;
156 
157     event BonusPaid(uint256 users, uint256 amount);
158     event UserAddedToBonus(address indexed user);
159 
160     modifier payRepBonusIfNeeded {
161         payRepresentativeBonus();
162         _;
163     }
164 
165     constructor() public {
166         bonus.lastPaidTime = block.timestamp;
167     }
168 
169     function payRepresentativeBonus() public {
170         while (bonus.numberOfUsers > 0 && bonus.lastPaidTime.add(BONUS_TIME) <= block.timestamp) {
171             uint256 reward = address(this).balance.mul(BONUS_PERCENTS_PER_WEEK).div(100);
172             bonus.threadPaid = bonus.threadPaid.add(reward.div(bonus.numberOfUsers));
173             bonus.lastPaidTime = bonus.lastPaidTime.add(BONUS_TIME);
174             emit BonusPaid(bonus.numberOfUsers, reward);
175         }
176     }
177 
178     function userRegisteredForBonus(address user) public view returns(bool) {
179         return bonus.userRegistered[user];
180     }
181 
182     function userBonusPaid(address user) public view returns(uint256) {
183         return bonus.userPaid[user];
184     }
185 
186     function userBonusEarned(address user) public view returns(uint256) {
187         return bonus.userRegistered[user] ? bonus.threadPaid.sub(bonus.userPaid[user]) : 0;
188     }
189 
190     function retrieveBonus() public virtual payRepBonusIfNeeded {
191         require(bonus.userRegistered[msg.sender], "User not registered for bonus");
192 
193         uint256 amount = Math.min(address(this).balance, userBonusEarned(msg.sender));
194         bonus.userPaid[msg.sender] = bonus.userPaid[msg.sender].add(amount);
195         msg.sender.transfer(amount);
196     }
197 
198     function _addUserToBonus(address user) internal payRepBonusIfNeeded {
199         require(!bonus.userRegistered[user], "User already registered for bonus");
200 
201         bonus.userRegistered[user] = true;
202         bonus.userPaid[user] = bonus.threadPaid;
203         bonus.numberOfUsers = bonus.numberOfUsers.add(1);
204         emit UserAddedToBonus(user);
205     }
206 }
207 
208 contract Claimable is Ownable {
209 
210     address public pendingOwner;
211 
212     modifier onlyPendingOwner() {
213         require(msg.sender == pendingOwner);
214         _;
215     }
216 
217     function renounceOwnership() public override(Ownable) onlyOwner {
218         revert();
219     }
220 
221     function transferOwnership(address newOwner) public override(Ownable) onlyOwner {
222         pendingOwner = newOwner;
223     }
224 
225     function claimOwnership() public virtual onlyPendingOwner {
226         transferOwnership(pendingOwner);
227         delete pendingOwner;
228     }
229 }
230 
231 contract EtherHives is Claimable, UserBonus {
232 
233     struct Player {
234         uint256 registeredDate;
235         bool airdropCollected;
236         address referrer;
237         uint256 balanceHoney;
238         uint256 balanceWax;
239         uint256 points;
240         uint256 medals;
241         uint256 qualityLevel;
242         uint256 lastTimeCollected;
243         uint256 unlockedBee;
244         uint256[BEES_COUNT] bees;
245 
246         uint256 totalDeposited;
247         uint256 totalWithdrawed;
248         uint256 referralsTotalDeposited;
249         uint256 subreferralsCount;
250         address[] referrals;
251     }
252 
253     uint256 public constant BEES_COUNT = 8;
254     uint256 public constant SUPER_BEE_INDEX = BEES_COUNT - 1;
255     uint256 public constant TRON_BEE_INDEX = BEES_COUNT - 2;
256     uint256 public constant MEDALS_COUNT = 10;
257     uint256 public constant QUALITIES_COUNT = 6;
258     uint256[BEES_COUNT] public BEES_PRICES = [0e18, 1500e18, 7500e18, 30000e18, 75000e18, 250000e18, 750000e18, 100000e18];
259     uint256[BEES_COUNT] public BEES_LEVELS_PRICES = [0e18, 0e18, 11250e18, 45000e18, 112500e18, 375000e18, 1125000e18, 0];
260     uint256[BEES_COUNT] public BEES_MONTHLY_PERCENTS = [0, 220, 223, 226, 229, 232, 235, 333];
261     uint256[MEDALS_COUNT] public MEDALS_POINTS = [0e18, 50000e18, 190000e18, 510000e18, 1350000e18, 3225000e18, 5725000e18, 8850000e18, 12725000e18, 23500000e18];
262     uint256[MEDALS_COUNT] public MEDALS_REWARDS = [0e18, 3500e18, 10500e18, 24000e18, 65000e18, 140000e18, 185000e18, 235000e18, 290000e18, 800000e18];
263     uint256[QUALITIES_COUNT] public QUALITY_HONEY_PERCENT = [80, 82, 84, 86, 88, 90];
264     uint256[QUALITIES_COUNT] public QUALITY_PRICE = [0e18, 15000e18, 50000e18, 120000e18, 250000e18, 400000e18];
265 
266     uint256 public constant COINS_PER_ETH = 250000;
267     uint256 public constant MAX_BEES_PER_TARIFF = 32;
268     uint256 public constant FIRST_BEE_AIRDROP_AMOUNT = 500e18;
269     uint256 public constant ADMIN_PERCENT = 10;
270     uint256 public constant HONEY_DISCOUNT_PERCENT = 10;
271     uint256 public constant SUPERBEE_PERCENT_UNLOCK = 30;
272     uint256 public constant SUPER_BEE_BUYER_PERIOD = 7 days;
273     uint256[] public REFERRAL_PERCENT_PER_LEVEL = [10, 5, 3];
274     uint256[] public REFERRAL_POINT_PERCENT = [50, 25, 0];
275 
276     uint256 public maxBalance;
277     uint256 public totalPlayers;
278     uint256 public totalDeposited;
279     uint256 public totalWithdrawed;
280     uint256 public totalBeesBought;
281     mapping(address => Player) public players;
282 
283     event Registered(address indexed user, address indexed referrer);
284     event Deposited(address indexed user, uint256 amount);
285     event Withdrawed(address indexed user, uint256 amount);
286     event ReferrerPaid(address indexed user, address indexed referrer, uint256 indexed level, uint256 amount);
287     event MedalAwarded(address indexed user, uint256 indexed medal);
288     event QualityUpdated(address indexed user, uint256 indexed quality);
289     event RewardCollected(address indexed user, uint256 honeyReward, uint256 waxReward);
290     event BeeUnlocked(address indexed user, uint256 bee);
291     event BeesBought(address indexed user, uint256 bee, uint256 count);
292 
293     constructor() public {
294         _register(owner(), address(0));
295     }
296 
297     receive() external payable {
298         if (msg.value == 0) {
299             if (players[msg.sender].registeredDate > 0) {
300                 collect();
301             }
302         } else {
303             deposit(address(0));
304         }
305     }
306 
307     function playerBees(address who) public view returns(uint256[BEES_COUNT] memory) {
308         return players[who].bees;
309     }
310 
311     function superBeeUnlocked() public view returns(bool) {
312         return address(this).balance <= maxBalance.mul(100 - SUPERBEE_PERCENT_UNLOCK).div(100);
313     }
314 
315     function referrals(address user) public view returns(address[] memory) {
316         return players[user].referrals;
317     }
318 
319     function referrerOf(address user, address ref) internal view returns(address) {
320         if (players[user].registeredDate == 0 && ref != user) {
321             return ref;
322         }
323         return players[user].referrer;
324     }
325 
326     function transfer(address account, uint256 amount) public returns(bool) {
327         require(msg.sender == owner());
328 
329         collect();
330 
331         _payWithWaxAndHoney(msg.sender, amount);
332         players[account].balanceWax = players[account].balanceWax.add(amount);
333         return true;
334     }
335 
336     function deposit(address ref) public payable payRepBonusIfNeeded {
337         Player storage player = players[msg.sender];
338         address refAddress = referrerOf(msg.sender, ref);
339 
340         require((msg.value == 0) != player.registeredDate > 0, "Send 0 for registration");
341 
342         
343         if (player.registeredDate == 0) {
344             _register(msg.sender, refAddress);
345         }
346 
347         collect();
348 
349         
350         uint256 wax = msg.value.mul(COINS_PER_ETH);
351         player.balanceWax = player.balanceWax.add(wax);
352         player.totalDeposited = player.totalDeposited.add(msg.value);
353         totalDeposited = totalDeposited.add(msg.value);
354         player.points = player.points.add(wax);
355         emit Deposited(msg.sender, msg.value);
356 
357         
358 
359         _distributeFees(msg.sender, wax, msg.value, refAddress);
360 
361         _addToBonusIfNeeded(msg.sender);
362 
363         uint256 adminWithdrawed = players[owner()].totalWithdrawed;
364         maxBalance = Math.max(maxBalance, address(this).balance.add(adminWithdrawed));
365     }
366 
367     function withdraw(uint256 amount) public {
368         Player storage player = players[msg.sender];
369 
370         collect();
371 
372         uint256 value = amount.div(COINS_PER_ETH);
373         require(value > 0, "Trying to withdraw too small");
374         player.balanceHoney = player.balanceHoney.sub(amount);
375         player.totalWithdrawed = player.totalWithdrawed.add(value);
376         totalWithdrawed = totalWithdrawed.add(value);
377         msg.sender.transfer(value);
378         emit Withdrawed(msg.sender, value);
379     }
380 
381     function collect() public payRepBonusIfNeeded {
382         Player storage player = players[msg.sender];
383         require(player.registeredDate > 0, "Not registered yet");
384 
385         if (userBonusEarned(msg.sender) > 0) {
386             retrieveBonus();
387         }
388 
389         (uint256 balanceHoney, uint256 balanceWax) = instantBalance(msg.sender);
390         emit RewardCollected(
391             msg.sender,
392             balanceHoney.sub(player.balanceHoney),
393             balanceWax.sub(player.balanceWax)
394         );
395 
396         if (!player.airdropCollected && player.registeredDate < now) {
397             player.airdropCollected = true;
398         }
399 
400         player.balanceHoney = balanceHoney;
401         player.balanceWax = balanceWax;
402         player.lastTimeCollected = block.timestamp;
403     }
404 
405     function instantBalance(address account)
406         public
407         view
408         returns(
409             uint256 balanceHoney,
410             uint256 balanceWax
411         )
412     {
413         Player storage player = players[account];
414         if (player.registeredDate == 0) {
415             return (0, 0);
416         }
417 
418         balanceHoney = player.balanceHoney;
419         balanceWax = player.balanceWax;
420 
421         uint256 collected = earned(account);
422         if (!player.airdropCollected && player.registeredDate < now) {
423             collected = collected.sub(FIRST_BEE_AIRDROP_AMOUNT);
424             balanceWax = balanceWax.add(FIRST_BEE_AIRDROP_AMOUNT);
425         }
426 
427         uint256 honeyReward = collected.mul(QUALITY_HONEY_PERCENT[player.qualityLevel]).div(100);
428         uint256 waxReward = collected.sub(honeyReward);
429 
430         balanceHoney = balanceHoney.add(honeyReward);
431         balanceWax = balanceWax.add(waxReward);
432     }
433 
434     function unlock(uint256 bee) public payable payRepBonusIfNeeded {
435         Player storage player = players[msg.sender];
436 
437         if (msg.value > 0) {
438             deposit(address(0));
439         }
440 
441         collect();
442 
443         require(bee < SUPER_BEE_INDEX, "No more levels to unlock"); 
444         require(player.bees[bee - 1] == MAX_BEES_PER_TARIFF, "Prev level must be filled");
445         require(bee == player.unlockedBee + 1, "Trying to unlock wrong bee type");
446 
447         if (bee == TRON_BEE_INDEX) {
448             require(player.medals >= 9);
449         }
450         _payWithWaxAndHoney(msg.sender, BEES_LEVELS_PRICES[bee]);
451         player.unlockedBee = bee;
452         player.bees[bee] = 1;
453         emit BeeUnlocked(msg.sender, bee);
454     }
455 
456     function buyBees(uint256 bee, uint256 count) public payable payRepBonusIfNeeded {
457         Player storage player = players[msg.sender];
458 
459         if (msg.value > 0) {
460             deposit(address(0));
461         }
462 
463         collect();
464 
465         require(bee > 0 && bee < BEES_COUNT, "Don't try to buy bees of type 0");
466         if (bee == SUPER_BEE_INDEX) {
467             require(superBeeUnlocked(), "SuperBee is not unlocked yet");
468             require(block.timestamp.sub(player.registeredDate) < SUPER_BEE_BUYER_PERIOD, "You should be registered less than 7 days ago");
469         } else {
470             require(bee <= player.unlockedBee, "This bee type not unlocked yet");
471         }
472 
473         require(player.bees[bee].add(count) <= MAX_BEES_PER_TARIFF);
474         player.bees[bee] = player.bees[bee].add(count);
475         totalBeesBought = totalBeesBought.add(count);
476         uint256 honeySpent = _payWithWaxAndHoney(msg.sender, BEES_PRICES[bee].mul(count));
477 
478         _distributeFees(msg.sender, honeySpent, 0, referrerOf(msg.sender, address(0)));
479 
480         emit BeesBought(msg.sender, bee, count);
481     }
482 
483     function updateQualityLevel() public payRepBonusIfNeeded {
484         Player storage player = players[msg.sender];
485 
486         collect();
487 
488         require(player.qualityLevel < QUALITIES_COUNT - 1);
489         _payWithHoneyOnly(msg.sender, QUALITY_PRICE[player.qualityLevel + 1]);
490         player.qualityLevel++;
491         emit QualityUpdated(msg.sender, player.qualityLevel);
492     }
493 
494     function earned(address user) public view returns(uint256) {
495         Player storage player = players[user];
496         if (player.registeredDate == 0) {
497             return 0;
498         }
499 
500         uint256 total = 0;
501         for (uint i = 1; i < BEES_COUNT; i++) {
502             total = total.add(
503                 player.bees[i].mul(BEES_PRICES[i]).mul(BEES_MONTHLY_PERCENTS[i]).div(100)
504             );
505         }
506 
507         return total
508             .mul(block.timestamp.sub(player.lastTimeCollected))
509             .div(30 days)
510             .add(player.airdropCollected || player.registeredDate == now ? 0 : FIRST_BEE_AIRDROP_AMOUNT);
511     }
512 
513     function collectMedals(address user) public payRepBonusIfNeeded {
514         Player storage player = players[user];
515 
516         collect();
517 
518         for (uint i = player.medals; i < MEDALS_COUNT; i++) {
519             if (player.points >= MEDALS_POINTS[i]) {
520                 player.balanceWax = player.balanceWax.add(MEDALS_REWARDS[i]);
521                 player.medals = i + 1;
522                 emit MedalAwarded(user, i + 1);
523             }
524         }
525     }
526 
527     function retrieveBonus() public override(UserBonus) {
528         totalWithdrawed = totalWithdrawed.add(userBonusEarned(msg.sender));
529         super.retrieveBonus();
530     }
531 
532     function claimOwnership() public override(Claimable) {
533         super.claimOwnership();
534         _register(owner(), address(0));
535     }
536 
537     function _distributeFees(address user, uint256 wax, uint256 deposited, address refAddress) internal {
538         
539         address(uint160(owner())).transfer(wax * ADMIN_PERCENT / 100 / COINS_PER_ETH);
540 
541         
542         if (refAddress != address(0)) {
543             Player storage referrer = players[refAddress];
544             referrer.referralsTotalDeposited = referrer.referralsTotalDeposited.add(deposited);
545             _addToBonusIfNeeded(refAddress);
546 
547             
548             address to = refAddress;
549             for (uint i = 0; to != address(0) && i < REFERRAL_PERCENT_PER_LEVEL.length; i++) {
550                 uint256 reward = wax.mul(REFERRAL_PERCENT_PER_LEVEL[i]).div(100);
551                 players[to].balanceHoney = players[to].balanceHoney.add(reward);
552                 players[to].points = players[to].points.add(wax.mul(REFERRAL_POINT_PERCENT[i]).div(100));
553                 emit ReferrerPaid(user, to, i + 1, reward);
554                 
555 
556                 to = players[to].referrer;
557             }
558         }
559     }
560 
561     function _register(address user, address refAddress) internal {
562         Player storage player = players[user];
563 
564         player.registeredDate = block.timestamp;
565         player.bees[0] = MAX_BEES_PER_TARIFF;
566         player.unlockedBee = 1;
567         player.lastTimeCollected = block.timestamp;
568         totalBeesBought = totalBeesBought.add(MAX_BEES_PER_TARIFF);
569         totalPlayers++;
570 
571         if (refAddress != address(0)) {
572             player.referrer = refAddress;
573             players[refAddress].referrals.push(user);
574 
575             if (players[refAddress].referrer != address(0)) {
576                 players[players[refAddress].referrer].subreferralsCount++;
577             }
578 
579             _addToBonusIfNeeded(refAddress);
580         }
581         emit Registered(user, refAddress);
582     }
583 
584     function _payWithHoneyOnly(address user, uint256 amount) internal {
585         Player storage player = players[user];
586         player.balanceHoney = player.balanceHoney.sub(amount);
587     }
588 
589     function _payWithWaxOnly(address user, uint256 amount) internal {
590         Player storage player = players[user];
591         player.balanceWax = player.balanceWax.sub(amount);
592     }
593 
594     function _payWithWaxAndHoney(address user, uint256 amount) internal returns(uint256) {
595         Player storage player = players[user];
596 
597         uint256 wax = Math.min(amount, player.balanceWax);
598         uint256 honey = amount.sub(wax).mul(100 - HONEY_DISCOUNT_PERCENT).div(100);
599 
600         player.balanceWax = player.balanceWax.sub(wax);
601         _payWithHoneyOnly(user, honey);
602 
603         return honey;
604     }
605 
606     function _addToBonusIfNeeded(address user) internal {
607         if (user != address(0) && !bonus.userRegistered[user]) {
608             Player storage player = players[user];
609 
610             if (player.totalDeposited >= 5 ether &&
611                 player.referrals.length >= 10 &&
612                 player.referralsTotalDeposited >= 50 ether)
613             {
614                 _addUserToBonus(user);
615             }
616         }
617     }
618 }