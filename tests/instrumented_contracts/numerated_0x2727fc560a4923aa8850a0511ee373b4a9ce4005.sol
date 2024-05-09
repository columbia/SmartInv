1 pragma solidity 0.6.8;
2 
3 
4 // SPDX-License-Identifier: MIT
5 
6 
7 library SafeMath128{
8 
9     //Custom addition
10     function safemul(uint128 a, uint128 b) internal pure returns (uint128) {
11         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
12         // benefit is lost if 'b' is also tested.
13         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
14         if (a == 0) {
15             return 0;
16         }
17 
18         uint128 c = a * b;
19         if(!(c / a == b)){
20             c = (2**128)-1;
21         }
22 
23         return c;
24     }
25 }
26 
27 /**
28  * @dev Wrappers over Solidity's arithmetic operations with added overflow
29  * checks.
30  *
31  * Arithmetic operations in Solidity wrap on overflow. This can easily result
32  * in bugs, because programmers usually assume that an overflow raises an
33  * error, which is the standard behavior in high level programming languages.
34  * `SafeMath` restores this intuition by reverting the transaction when an
35  * operation overflows.
36  *
37  * Using this library instead of the unchecked operations eliminates an entire
38  * class of bugs, so it's recommended to use it always.
39  */
40 library SafeMath104 {
41     /**
42      * @dev Returns the addition of two unsigned integers, reverting on
43      * overflow.
44      *
45      * Counterpart to Solidity's `+` operator.
46      *
47      * Requirements:
48      *
49      * - Addition cannot overflow.
50      */
51     function add(uint112 a, uint112 b) internal pure returns (uint112) {
52         uint112 c = a + b;
53         if(!(c >= a)){
54             c = (2**112)-1;
55         }
56         require(c >= a, "addition overflow");
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      *
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint112 a, uint112 b) internal pure returns (uint112) {
72         if(!(b <= a)){
73             return 0;
74         }
75         uint112 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the multiplication of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `*` operator.
85      *
86      * Requirements:
87      *
88      * - Multiplication cannot overflow.
89      */
90     function mul(uint112 a, uint112 b) internal pure returns (uint112) {
91         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92         // benefit is lost if 'b' is also tested.
93         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint112 c = a * b;
99         if(!(c / a == b)){
100             c = (2**112)-1;
101         }
102 
103         return c;
104     }
105 
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint112 a, uint112 b) internal pure returns (uint112) {
120         require(b > 0, "div by zero");
121         uint112 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 }
127 
128 /**
129  * @dev Contract module which provides a basic access control mechanism, where
130  * there is an account (an owner) that can be granted exclusive access to
131  * specific functions.
132  *
133  * By default, the owner account will be the one that deploys the contract. This
134  * can later be changed with {transferOwnership}.
135  *
136  * This module is used through inheritance. It will make available the modifier
137  * `onlyOwner`, which can be applied to your functions to restrict their use to
138  * the owner.
139  */
140 contract Ownable {
141     address private _owner;
142 
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     /**
146      * @dev Initializes the contract setting the deployer as the initial owner.
147      */
148     constructor () internal {
149         address msgSender = msg.sender;
150         _owner = msgSender;
151         emit OwnershipTransferred(address(0), msgSender);
152     }
153 
154     /**
155      * @dev Returns the address of the current owner.
156      */
157     function owner() public view returns (address) {
158         return _owner;
159     }
160 
161     /**
162      * @dev Throws if called by any account other than the owner.
163      */
164     modifier onlyOwner() {
165         require(_owner == msg.sender, "Caller is not the owner");
166         _;
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Can only be called by the current owner.
172      */
173     function transferOwnership(address newOwner) public onlyOwner {
174         require(newOwner != address(0), "New owner is the zero address");
175         emit OwnershipTransferred(_owner, newOwner);
176         _owner = newOwner;
177     }
178 
179 }
180 
181 //Restrictions:
182 //only 2^32 Users
183 //Maximum of 2^104 / 10^18 Ether investment. Theoretically 20 Trl Ether, practically 100000000000 Ether compiles
184 //Maximum of (2^104 / 10^18 Ether) investment. Theoretically 20 Trl Ether, practically 100000000000 Ether compiles
185 contract PrestigeClub is Ownable() {
186 
187     using SafeMath104 for uint112;
188     using SafeMath128 for uint128;
189 
190     struct User {
191         uint112 deposit; //265 bits together
192         uint112 payout;
193         uint32 position;
194         uint8 qualifiedPools;
195         uint8 downlineBonus;
196         address referer;
197         address[] referrals;
198 
199         uint112 directSum;
200         uint40 lastPayout;
201 
202         uint112[5] downlineVolumes;
203     }
204     
205     event NewDeposit(address indexed addr, uint112 amount);
206     event PoolReached(address indexed addr, uint8 pool);
207     event DownlineBonusStageReached(address indexed adr, uint8 stage);
208     // event Referral(address indexed addr, address indexed referral);
209     
210     event Payout(address indexed addr, uint112 interest, uint112 direct, uint112 pool, uint112 downline, uint40 dayz); 
211     
212     event Withdraw(address indexed addr, uint112 amount);
213     
214     mapping (address => User) public users;
215     address[] public userList;
216 
217     uint32 public lastPosition;
218     
219     uint128 public depositSum;
220     
221     Pool[8] public pools;
222     
223     struct Pool {
224         uint112 minOwnInvestment;
225         uint8 minDirects;
226         uint112 minSumDirects;
227         uint8 payoutQuote; //ppm
228         uint32 numUsers;
229     }
230 
231     PoolState[] public states;
232 
233     struct PoolState {
234         uint128 totalDeposits;
235         uint32 totalUsers;
236         uint32[8] numUsers;
237     }
238     
239     DownlineBonusStage[4] downlineBonuses;
240     
241     struct DownlineBonusStage {
242         uint32 minPool;
243         uint64 payoutQuote; //ppm
244     }
245     
246     uint40 public pool_last_draw;
247     
248     constructor() public {
249  
250         uint40 timestamp = uint40(block.timestamp);
251         pool_last_draw = timestamp - (timestamp % payout_interval) - (2 * payout_interval);
252 
253 
254         pools[0] = Pool(3 ether, 1, 3 ether, 130, 0);
255         pools[1] = Pool(15 ether, 3, 5 ether, 130, 0);
256         pools[2] = Pool(15 ether, 4, 44 ether, 130, 0);
257         pools[3] = Pool(30 ether, 10, 105 ether, 130, 0);
258         pools[4] = Pool(45 ether, 15, 280 ether, 130, 0);
259         pools[5] = Pool(60 ether, 20, 530 ether, 130, 0);
260         pools[6] = Pool(150 ether, 20, 1470 ether, 80, 0);
261         pools[7] = Pool(300 ether, 20, 2950 ether, 80, 0);
262 
263         downlineBonuses[0] = DownlineBonusStage(3, 50);
264         downlineBonuses[1] = DownlineBonusStage(4, 100);
265         downlineBonuses[2] = DownlineBonusStage(5, 160);
266         downlineBonuses[3] = DownlineBonusStage(6, 210);
267 
268         userList.push(address(0));
269         
270     }
271     
272     uint112 internal minDeposit = 1 ether;
273     uint112 internal minWithdraw = 1000 wei; 
274     
275     uint40 constant internal payout_interval = 1 days;
276     
277     function recieve() public payable {
278         require((users[msg.sender].deposit * 20 / 19) >= minDeposit || msg.value >= minDeposit, "Mininum deposit value not reached");
279         
280         address sender = msg.sender;
281 
282         uint112 value = uint112(msg.value).mul(19) / 20;
283 
284         bool userExists = users[sender].position != 0;
285         
286         triggerCalculation();
287 
288         // Create a position for new accounts
289         if(!userExists){
290             lastPosition++;
291             users[sender].position = lastPosition;
292             users[sender].lastPayout = (pool_last_draw + 1);
293             userList.push(sender);
294         }
295 
296         address referer = users[sender].referer; //can put outside because referer is always set since setReferral() gets called before recieve() in recieve(address)
297 
298         if(referer != address(0)){
299             updateUpline(sender, referer, value);
300         }
301 
302         //Update Payouts
303         if(userExists){
304             updatePayout(sender);
305         }
306 
307         users[sender].deposit = users[sender].deposit.add(value);
308         
309         //Transfer fee
310         payable(owner()).transfer(msg.value - value);
311         
312         emit NewDeposit(sender, value);
313         
314         updateUserPool(sender);
315         updateDownlineBonusStage(sender);
316         if(referer != address(0)){
317             users[referer].directSum = users[referer].directSum.add(value);
318 
319             updateUserPool(referer);
320             updateDownlineBonusStage(referer);
321         }
322         
323         depositSum = depositSum + value; //Won´t do an overflow since value is uint112 and depositSum 128
324 
325     }
326     
327     
328     function recieve(address referer) public payable {
329         
330         _setReferral(referer);
331         recieve();
332         
333     }
334 
335     uint8 public downlineLimit = 31;
336 
337     function updateUpline(address reciever, address adr, uint112 addition) private {
338         
339         address current = adr;
340         uint8 bonusStage = users[reciever].downlineBonus;
341         
342         uint8 downlineLimitCounter = downlineLimit - 1;
343         
344         while(current != address(0) && downlineLimitCounter > 0){
345 
346             updatePayout(current);
347 
348             users[current].downlineVolumes[bonusStage] = users[current].downlineVolumes[bonusStage].add(addition);
349             uint8 currentBonus = users[current].downlineBonus;
350             if(currentBonus > bonusStage){
351                 bonusStage = currentBonus;
352             }
353 
354             current = users[current].referer;
355             downlineLimitCounter--;
356         }
357         
358     }
359     
360     function updatePayout(address adr) private {
361         
362         uint40 dayz = (uint40(block.timestamp) - users[adr].lastPayout) / (payout_interval);
363         if(dayz >= 1){
364             
365             uint112 interestPayout = getInterestPayout(adr);
366             uint112 poolpayout = getPoolPayout(adr, dayz);
367             uint112 directsPayout = getDirectsPayout(adr);
368             uint112 downlineBonusAmount = getDownlinePayout(adr);
369             
370             
371             uint112 sum = interestPayout.add(directsPayout).add(downlineBonusAmount); 
372             sum = (sum.mul(dayz)).add(poolpayout);
373             
374             users[adr].payout = users[adr].payout.add(sum);
375             users[adr].lastPayout += (payout_interval * dayz);
376             
377             emit Payout(adr, interestPayout, directsPayout, poolpayout, downlineBonusAmount, dayz);
378             
379         }
380     }
381     
382     function getInterestPayout(address adr) public view returns (uint112){
383         //Calculate Base Payouts
384         uint8 quote;
385         uint112 deposit = users[adr].deposit;
386         if(deposit >= 30 ether){
387             quote = 15;
388         }else{
389             quote = 10;
390         }
391         
392         return deposit.mul(quote) / 10000;
393     }
394     
395     function getPoolPayout(address adr, uint40 dayz) public view returns (uint112){
396 
397         uint40 length = (uint40)(states.length);
398 
399         uint112 poolpayout = 0;
400 
401         if(users[adr].qualifiedPools > 0){
402             for(uint40 day = length - dayz ; day < length ; day++){
403 
404 
405                 uint32 numUsers = states[day].totalUsers;
406                 uint112 streamline = uint112(states[day].totalDeposits.safemul(numUsers - users[adr].position)).div(numUsers);
407 
408 
409                 uint112 payout_day = 0; 
410                 uint32 stateNumUsers = 0;
411                 for(uint8 j = 0 ; j < users[adr].qualifiedPools ; j++){
412                     uint112 pool_base = streamline.mul(pools[j].payoutQuote) / 1000000;
413 
414                     stateNumUsers = states[day].numUsers[j];
415 
416                     if(stateNumUsers != 0){
417                         payout_day += pool_base.div(stateNumUsers);
418                     }
419                 }
420 
421                 poolpayout = poolpayout.add(payout_day);
422 
423             }
424         }
425         
426         return poolpayout;
427     }
428 
429     function getDownlinePayout(address adr) public view returns (uint112){
430 
431         //Calculate Downline Bonus
432         uint112 downlinePayout = 0;
433         
434         uint8 downlineBonus = users[adr].downlineBonus;
435         
436         if(downlineBonus > 0){
437             
438             uint64 ownPercentage = downlineBonuses[downlineBonus - 1].payoutQuote;
439 
440             for(uint8 i = 0 ; i < downlineBonus; i++){
441 
442                 uint64 quote = 0;
443                 if(i > 0){
444                     quote = downlineBonuses[i - 1].payoutQuote;
445                 }else{
446                     quote = 0;
447                 }
448 
449                 uint64 percentage = ownPercentage - quote;
450                 if(percentage > 0){ //Requiring positivity and saving gas for 0, since that returns 0
451 
452                     downlinePayout = downlinePayout.add(users[adr].downlineVolumes[i].mul(percentage) / 1000000); 
453 
454                 }
455 
456             }
457 
458             if(downlineBonus == 4){
459                 downlinePayout = downlinePayout.add(users[adr].downlineVolumes[downlineBonus].mul(50) / 1000000);
460             }
461 
462         }
463 
464         return downlinePayout;
465         
466     }
467 
468     function getDirectsPayout(address adr) public view returns (uint112) {
469         
470         //Calculate Directs Payouts
471         uint112 directsDepositSum = users[adr].directSum;
472 
473         uint112 directsPayout = directsDepositSum.mul(5) / 10000;
474 
475         return (directsPayout);
476         
477     }
478 
479     function pushPoolState() private {
480         uint32[8] memory temp;
481         for(uint8 i = 0 ; i < 8 ; i++){
482             temp[i] = pools[i].numUsers;
483         }
484         states.push(PoolState(depositSum, lastPosition, temp));
485         pool_last_draw += payout_interval;
486     }
487     
488     function updateUserPool(address adr) private {
489         
490         if(users[adr].qualifiedPools < pools.length){
491             
492             uint8 poolnum = users[adr].qualifiedPools;
493             
494             uint112 sumDirects = users[adr].directSum;
495             
496             //Check if requirements for next pool are met
497             if(users[adr].deposit >= pools[poolnum].minOwnInvestment && users[adr].referrals.length >= pools[poolnum].minDirects && sumDirects >= pools[poolnum].minSumDirects){
498                 users[adr].qualifiedPools = poolnum + 1;
499                 pools[poolnum].numUsers++;
500                 
501                 emit PoolReached(adr, poolnum + 1);
502                 
503                 updateUserPool(adr);
504             }
505             
506         }
507         
508     }
509     
510     function updateDownlineBonusStage(address adr) private {
511 
512         uint8 bonusstage = users[adr].downlineBonus;
513 
514         if(bonusstage < downlineBonuses.length){
515 
516             //Check if requirements for next stage are met
517             if(users[adr].qualifiedPools >= downlineBonuses[bonusstage].minPool){
518                 users[adr].downlineBonus += 1;
519                 
520                 //Update data in upline
521                 uint112 value = users[adr].deposit;  //Value without current stage, since that must not be subtracted
522 
523                 for(uint8 i = 0 ; i <= bonusstage ; i++){
524                     value = value.add(users[adr].downlineVolumes[i]);
525                 }
526 
527                 // uint8 previousBonusStage = bonusstage;
528                 uint8 currentBonusStage = bonusstage + 1;
529                 uint8 lastBonusStage = bonusstage;
530 
531                 address current = users[adr].referer;
532                 while(current != address(0)){
533 
534                     
535                     users[current].downlineVolumes[lastBonusStage] = users[current].downlineVolumes[lastBonusStage].sub(value);
536                     users[current].downlineVolumes[currentBonusStage] = users[current].downlineVolumes[currentBonusStage].add(value);
537 
538                     uint8 currentDB = users[current].downlineBonus;
539                     if(currentDB > currentBonusStage){
540                         currentBonusStage = currentDB;
541                     }
542                     if(currentDB > lastBonusStage){
543                         lastBonusStage = currentDB;
544                     }
545 
546                     if(lastBonusStage == currentBonusStage){
547                         break;
548                     }
549 
550                     current = users[current].referer;
551                 }
552 
553                 emit DownlineBonusStageReached(adr, users[adr].downlineBonus);
554                 
555                 updateDownlineBonusStage(adr);
556             }
557         }
558         
559     }
560     
561     function calculateDirects(address adr) external view returns (uint112, uint32) {
562         
563         address[] memory referrals = users[adr].referrals;
564         
565         uint112 sum = 0;
566         for(uint32 i = 0 ; i < referrals.length ; i++){
567             sum = sum.add(users[referrals[i]].deposit);
568         }
569         
570         return (sum, (uint32)(referrals.length));
571         
572     }
573     
574     //Endpoint to withdraw payouts
575     function withdraw(uint112 amount) public {
576         
577         updatePayout(msg.sender);
578 
579         require(amount > minWithdraw, "Minimum Withdrawal amount not met");
580         require(users[msg.sender].payout >= amount, "Not enough payout available");
581         
582         uint112 transfer = amount * 19 / 20;
583         
584         users[msg.sender].payout -= amount;
585         
586         payable(msg.sender).transfer(transfer);
587         
588         payable(owner()).transfer(amount - transfer);
589         
590         emit Withdraw(msg.sender, amount);
591         
592     }
593 
594     function _setReferral(address referer) private {
595         
596         if(users[msg.sender].referer == referer){
597             return;
598         }
599         
600         if(users[msg.sender].position != 0 && users[msg.sender].position < users[referer].position) {
601             return;
602         }
603         
604         require(users[msg.sender].referer == address(0), "Referer can only be set once");
605         require(users[referer].position > 0, "Referer does not exist");
606         require(msg.sender != referer, "Cant set oneself as referer");
607         
608         users[referer].referrals.push(msg.sender);
609         users[msg.sender].referer = referer;
610 
611         if(users[msg.sender].deposit > 0){
612             users[referer].directSum = users[referer].directSum.add(users[msg.sender].deposit);
613         }
614         
615     }
616     
617     
618     function invest(uint amount) public onlyOwner {
619         
620         payable(owner()).transfer(amount);
621     }
622     
623     function reinvest() public payable onlyOwner {
624     }
625     
626     function setLimits(uint112 _minDeposit, uint112 _minWithdrawal) public onlyOwner {
627         minDeposit = _minDeposit;
628         minWithdraw = _minWithdrawal;
629     }
630 
631     function setDownlineLimit(uint8 limit) public onlyOwner {
632         downlineLimit = limit;
633     }
634     
635     function forceSetReferral(address adr, address referer) public onlyOwner {
636         users[referer].referrals.push(adr);
637         users[adr].referer = referer;
638     }
639 
640     //Only for BO
641     function getDownline() external view returns (uint112, uint){
642         uint112 sum;
643         for(uint8 i = 0 ; i < users[msg.sender].downlineVolumes.length ; i++){
644             sum += users[msg.sender].downlineVolumes[i];
645         }
646 
647         uint numUsers = getDownlineUsers(msg.sender);
648 
649         return (sum, numUsers);
650     }
651 
652     function getDownlineUsers(address adr) public view returns (uint128){
653 
654         uint128 sum = 0;
655         uint32 length = uint32(users[adr].referrals.length);
656         sum += length;
657         for(uint32 i = 0; i < length ; i++){
658             sum += getDownlineUsers(users[adr].referrals[i]);
659         }
660         return sum;
661     }
662     
663     function reCalculateImported(uint64 from, uint64 to) public onlyOwner {
664         uint40 time = pool_last_draw - payout_interval;
665         for(uint64 i = from ; i < to + 1 ; i++){
666             address adr = userList[i];
667             users[adr].payout = 0;
668             users[adr].lastPayout = time;
669             updatePayout(adr);
670         }
671     }
672     
673     function _import(address[] memory sender, uint112[] memory deposit, address[] memory referer) public onlyOwner {
674         for(uint64 i = 0 ; i < sender.length ; i++){
675             importUser(sender[i], deposit[i], referer[i]);
676         }
677     }
678     
679     function importUser(address sender, uint112 deposit, address referer) internal onlyOwner {
680         
681         if(referer != address(0)){
682             users[referer].referrals.push(sender);
683             users[sender].referer = referer;
684         }
685 
686         uint112 value = deposit;
687 
688         // Create a position for new accounts
689         lastPosition++;
690         users[sender].position = lastPosition;
691         users[sender].lastPayout = pool_last_draw;
692         userList.push(sender);
693 
694         if(referer != address(0)){
695             updateUpline(sender, referer, value);
696         }
697 
698         users[sender].deposit += value;
699         
700         emit NewDeposit(sender, value);
701         
702         updateUserPool(sender);
703         updateDownlineBonusStage(sender);
704         
705         if(referer != address(0)){
706             users[referer].directSum += value;
707     
708             updateUserPool(referer);
709             updateDownlineBonusStage(referer);
710         }
711         
712         depositSum += value;
713         
714     }
715 
716     function getUserReferrals(address adr) public view returns (address[] memory referrals){
717         return users[adr].referrals;
718     }
719     
720     function getUserList() public view returns (address[] memory){  //TODO Probably not needed
721         return userList;
722     }
723     
724     function triggerCalculation() public {
725         if(block.timestamp > pool_last_draw + payout_interval){
726             pushPoolState();
727         }
728     }
729 }