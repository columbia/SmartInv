1 pragma solidity ^0.5.0;
2 
3 contract UtilMutualAlliance{
4     uint ethWei = 1 ether;
5 
6     function getLevel(uint value) internal view returns (uint) {
7         if (value >= 1 * ethWei && value <= 5 * ethWei) {
8             return 1;
9         }
10         if (value >= 6 * ethWei && value <= 14 * ethWei) {
11             return 2;
12         }
13         if (value >= 15 * ethWei && value <= 20 * ethWei) {
14             return 3;
15         }
16         return 0;
17     }
18 
19     function getLineLevel(uint value) internal view returns (uint) {
20         if (value >= 1 * ethWei && value <= 5 * ethWei) {
21             return 1;
22         }
23         if (value >= 6 * ethWei && value <= 14 * ethWei) {
24             return 2;
25         }
26         if (value >= 15 * ethWei) {
27             return 3;
28         }
29         return 0;
30     }
31 
32     function getSepScByLevel(uint level) internal pure returns(uint) {
33         if (level == 1) {
34             return 65;
35         }
36         if (level == 2) {
37             return 85;
38         }
39         if (level == 3) {
40             return 120;
41         }
42 
43         return 0;
44     }
45 
46     function getScByLevel(uint level, uint reInvestCount) internal pure returns (uint) {
47         if (level == 1) {
48             if (reInvestCount == 0) {
49                 return 20;
50             }
51             if (reInvestCount == 1) {
52                 return 25;
53             }
54             if (reInvestCount == 2) {
55                 return 30;
56             }
57             if (reInvestCount == 3) {
58                 return 35;
59             }
60             if (reInvestCount >= 4) {
61                 return 50;
62             }
63         }
64         if (level == 2) {
65             if (reInvestCount == 0) {
66                 return 30;
67             }
68             if (reInvestCount == 1) {
69                 return 40;
70             }
71             if (reInvestCount == 2) {
72                 return 50;
73             }
74             if (reInvestCount == 3) {
75                 return 60;
76             }
77             if (reInvestCount >= 4) {
78                 return 70;
79             }
80         }
81         if (level == 3) {
82             if (reInvestCount == 0) {
83                 return 60;
84             }
85             if (reInvestCount == 1) {
86                 return 70;
87             }
88             if (reInvestCount == 2) {
89                 return 80;
90             }
91             if (reInvestCount == 3) {
92                 return 90;
93             }
94             if (reInvestCount >= 4) {
95                 return 100;
96             }
97         }
98         return 0;
99     }
100 
101     function getFireScByLevel(uint level) internal pure returns (uint) {
102         if (level == 1) {
103             return 3;
104         }
105         if (level == 2) {
106             return 6;
107         }
108         if (level == 3) {
109             return 10;
110         }
111         return 0;
112     }
113 
114     function getDynamicFloor(uint level) internal pure returns (uint) {
115         if (level == 1) {
116             return 1;
117         }
118         if (level == 2) {
119             return 2;
120         }
121         if (level == 3) {
122             return 20;
123         }
124 
125         return 0;
126     }
127 
128     function getFloorIndex(uint floor) internal pure returns (uint) {
129         if (floor == 1) {
130             return 1;
131         }
132         if (floor == 2) {
133             return 2;
134         }
135         if (floor == 3) {
136             return 3;
137         }
138         if (floor >= 4 && floor <= 5) {
139             return 4;
140         }
141         if (floor >= 6 && floor <= 10) {
142             return 5;
143         }
144         if (floor >= 11) {
145             return 6;
146         }
147 
148         return 0;
149     }
150 
151     function getRecommendScaleByLevelAndTim(uint level, uint floorIndex) internal pure returns (uint){
152         if (level == 1 && floorIndex == 1) {
153             return 20;
154         }
155         if (level == 2) {
156             if (floorIndex == 1) {
157                 return 30;
158             }
159             if (floorIndex == 2) {
160                 return 20;
161             }
162         }
163         if (level == 3) {
164             if (floorIndex == 1) {
165                 return 50;
166             }
167             if (floorIndex == 2) {
168                 return 30;
169             }
170             if (floorIndex == 3) {
171                 return 20;
172             }
173             if (floorIndex == 4) {
174                 return 10;
175             }
176             if (floorIndex == 5) {
177                 return 5;
178             }
179             if (floorIndex >= 6) {
180                 return 2;
181             }
182         }
183         return 0;
184     }
185 
186     function isEmpty(string memory str) internal pure returns (bool) {
187         if (bytes(str).length == 0) {
188             return true;
189         }
190 
191         return false;
192     }
193 }
194 
195 /*
196  * @dev Provides information about the current execution context, including the
197  * sender of the transaction and its data. While these are generally available
198  * via msg.sender and msg.data, they should not be accessed in such a direct
199  * manner, since when dealing with GSN meta-transactions the account sending and
200  * paying for execution may not be the actual sender (as far as an application
201  * is concerned).
202  *
203  * This contract is only required for intermediate, library-like contracts.
204  */
205 contract Context {
206     // Empty internal constructor, to prevent people from mistakenly deploying
207     // an instance of this contract, which should be used via inheritance.
208     constructor() internal {}
209     // solhint-disable-previous-line no-empty-blocks
210 
211     function _msgSender() internal view returns (address) {
212         return msg.sender;
213     }
214 
215     function _msgData() internal view returns (bytes memory) {
216         this;
217         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
218         return msg.data;
219     }
220 }
221 
222 /**
223  * @dev Contract module which provides a basic access control mechanism, where
224  * there is an account (an owner) that can be granted exclusive access to
225  * specific functions.
226  *
227  * This module is used through inheritance. It will make available the modifier
228  * `onlyOwner`, which can be applied to your functions to restrict their use to
229  * the owner.
230  */
231 contract Ownable is Context {
232     address private _owner;
233 
234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236     /**
237      * @dev Initializes the contract setting the deployer as the initial owner.
238      */
239     constructor () internal {
240         _owner = _msgSender();
241         emit OwnershipTransferred(address(0), _owner);
242     }
243 
244     /**
245      * @dev Returns the address of the current owner.
246      */
247     function owner() public view returns (address) {
248         return _owner;
249     }
250 
251     /**
252      * @dev Throws if called by any account other than the owner.
253      */
254     modifier onlyOwner() {
255         require(isOwner(), "Ownable: caller is not the owner");
256         _;
257     }
258 
259     /**
260      * @dev Returns true if the caller is the current owner.
261      */
262     function isOwner() public view returns (bool) {
263         return _msgSender() == _owner;
264     }
265 
266     /**
267      * @dev Leaves the contract without owner. It will not be possible to call
268      * `onlyOwner` functions anymore. Can only be called by the current owner.
269      *
270      * NOTE: Renouncing ownership will leave the contract without an owner,
271      * thereby removing any functionality that is only available to the owner.
272      */
273     function renounceOwnership() public onlyOwner {
274         emit OwnershipTransferred(_owner, address(0));
275         _owner = address(0);
276     }
277 
278     /**
279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
280      * Can only be called by the current owner.
281      */
282     function transferOwnership(address newOwner) public onlyOwner {
283         _transferOwnership(newOwner);
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      */
289     function _transferOwnership(address newOwner) internal {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         emit OwnershipTransferred(_owner, newOwner);
292         _owner = newOwner;
293     }
294 }
295 
296 /**
297  * @title Roles
298  * @dev Library for managing addresses assigned to a Role.
299  */
300 library Roles {
301     struct Role {
302         mapping(address => bool) bearer;
303     }
304 
305     /**
306      * @dev Give an account access to this role.
307      */
308     function add(Role storage role, address account) internal {
309         require(!has(role, account), "Roles: account already has role");
310         role.bearer[account] = true;
311     }
312 
313     /**
314      * @dev Remove an account's access to this role.
315      */
316     function remove(Role storage role, address account) internal {
317         require(has(role, account), "Roles: account does not have role");
318         role.bearer[account] = false;
319     }
320 
321     /**
322      * @dev Check if an account has this role.
323      * @return bool
324      */
325     function has(Role storage role, address account) internal view returns (bool) {
326         require(account != address(0), "Roles: account is the zero address");
327         return role.bearer[account];
328     }
329 }
330 
331 /**
332  * @title WhitelistAdminRole
333  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
334  */
335 contract WhitelistAdminRole is Context, Ownable {
336     using Roles for Roles.Role;
337 
338     event WhitelistAdminAdded(address indexed account);
339     event WhitelistAdminRemoved(address indexed account);
340 
341     Roles.Role private _whitelistAdmins;
342 
343     constructor () internal {
344         _addWhitelistAdmin(_msgSender());
345     }
346 
347     modifier onlyWhitelistAdmin() {
348         require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
349         _;
350     }
351 
352     function isWhitelistAdmin(address account) public view returns (bool) {
353         return _whitelistAdmins.has(account);
354     }
355 
356     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
357         _addWhitelistAdmin(account);
358     }
359 
360     function removeWhitelistAdmin(address account) public onlyOwner {
361         _whitelistAdmins.remove(account);
362         emit WhitelistAdminRemoved(account);
363     }
364 
365     function renounceWhitelistAdmin() public {
366         _removeWhitelistAdmin(_msgSender());
367     }
368 
369     function _addWhitelistAdmin(address account) internal {
370         _whitelistAdmins.add(account);
371         emit WhitelistAdminAdded(account);
372     }
373 
374     function _removeWhitelistAdmin(address account) internal {
375         _whitelistAdmins.remove(account);
376         emit WhitelistAdminRemoved(account);
377     }
378 }
379 
380 contract MutualAlliance is UtilMutualAlliance, WhitelistAdminRole {
381 
382     using SafeMath for *;
383 
384     string constant private name = "MutualAlliance Official";
385 
386     uint ethWei = 1 ether;
387 
388     address payable private devAddr = address(0x3fd4967d8C5079c2D37cbaac8014c1e9584Fe5Dd);
389 
390     address payable private loyal = address(0x0EF71a4b3b37dbAb581bEc482bcd0eE7429917A3);
391 
392     address payable private other = address(0x0040E7d9808e9D344158D7379E0b91b61B93CC9F);
393 
394     struct User {
395         uint id;
396         address userAddress;
397         uint staticLevel;
398         uint dynamicLevel;
399         uint allInvest;
400         uint freezeAmount;
401         uint unlockAmount;
402         uint unlockAmountRedeemTime;
403         uint allStaticAmount;
404         uint hisStaticAmount;
405         uint dynamicWithdrawn;
406         uint staticWithdrawn;
407         Invest[] invests;
408         uint staticFlag;
409 
410         mapping(uint => mapping(uint => uint)) dynamicProfits;
411         uint reInvestCount;
412         uint inviteAmount;
413         uint solitaire;
414         uint hisSolitaire;
415     }
416 
417     struct UserGlobal {
418         uint id;
419         address userAddress;
420         string inviteCode;
421         string referrer;
422     }
423 
424     struct Invest {
425         address userAddress;
426         uint investAmount;
427         uint investTime;
428         uint realityInvestTime;
429         uint times;
430         uint modeFlag;
431         bool isSuspendedInvest;
432     }
433 
434     uint coefficient = 10;
435     uint startTime;
436     uint baseTime;
437     uint investCount = 0;
438     mapping(uint => uint) rInvestCount;
439     uint investMoney = 0;
440     mapping(uint => uint) rInvestMoney;
441     uint uid = 0;
442     uint rid = 1;
443     uint period = 3 days;
444     uint suspendedTime = 0;
445     uint suspendedDays = 0 days;
446     uint lastInvestTime = 0;
447     mapping(uint => mapping(address => User)) userRoundMapping;
448     mapping(address => UserGlobal) userMapping;
449     mapping(string => address) addressMapping;
450     mapping(uint => address) public indexMapping;
451     mapping(uint => uint) public everyDayInvestMapping;
452     mapping(uint => uint[]) investAmountList;
453     mapping(uint => uint) transformAmount;
454     uint baseLimit = 300 * ethWei;
455 
456     /**
457      * @dev Just a simply check to prevent contract
458      * @dev this by calling method in constructor.
459      */
460     modifier isHuman() {
461         address addr = msg.sender;
462         uint codeLength;
463 
464         assembly {codeLength := extcodesize(addr)}
465         require(codeLength == 0, "sorry humans only");
466         require(tx.origin == msg.sender, "sorry, human only");
467         _;
468     }
469 
470     modifier isSuspended() {
471         require(notSuspended(), "suspended");
472         _;
473     }
474 
475     event LogInvestIn(address indexed who, uint indexed uid, uint amount, uint time, uint investTime, string inviteCode, string referrer, uint t);
476     event LogWithdrawProfit(address indexed who, uint indexed uid, uint amount, uint time, uint t);
477     event LogRedeem(address indexed who, uint indexed uid, uint amount, uint now);
478 
479     constructor () public {
480     }
481 
482     function() external payable {
483     }
484 
485     function activeGame(uint time, uint _baseTime) external onlyWhitelistAdmin
486     {
487         require(time > now, "invalid game start time");
488         startTime = time;
489 
490         if (baseTime == 0) {
491             baseTime = _baseTime;
492         }
493     }
494 
495     function setCoefficient(uint coeff, uint _baseLimit) external onlyWhitelistAdmin
496     {
497         require(coeff > 0, "invalid coeff");
498         coefficient = coeff;
499         require(_baseLimit > 0, "invalue base limit");
500         baseLimit = _baseLimit;
501     }
502 
503     function gameStart() public view returns (bool) {
504         return startTime != 0 && now > startTime;
505     }
506 
507     function investIn(string memory inviteCode, string memory referrer, uint flag)
508     public
509     isHuman()
510     payable
511     {
512         require(flag == 0 || flag == 1, "invalid flag");
513         require(gameStart(), "game not start");
514         require(msg.value >= 1 * ethWei && msg.value <= 20 * ethWei, "between 1 and 20");
515         require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");
516         uint investTime = getInvestTime(msg.value);
517         uint investDay = getCurrentInvestDay(investTime);
518         everyDayInvestMapping[investDay] = msg.value.add(everyDayInvestMapping[investDay]);
519         calUserQueueingStatic(msg.sender);
520 
521         UserGlobal storage userGlobal = userMapping[msg.sender];
522         if (userGlobal.id == 0) {
523             require(!isEmpty(inviteCode), "empty invite code");
524             address referrerAddr = getUserAddressByCode(referrer);
525             require(uint(referrerAddr) != 0, "referer not exist");
526             require(referrerAddr != msg.sender, "referrer can't be self");
527             require(!isUsed(inviteCode), "invite code is used");
528 
529             registerUser(msg.sender, inviteCode, referrer);
530         }
531 
532         User storage user = userRoundMapping[rid][msg.sender];
533         if (uint(user.userAddress) != 0) {
534             require(user.freezeAmount == 0 && user.unlockAmount == 0, "your invest not unlocked");
535             user.allInvest = user.allInvest.add(msg.value);
536             user.freezeAmount = msg.value;
537             user.staticLevel = getLevel(msg.value);
538             user.dynamicLevel = getLineLevel(msg.value);
539         } else {
540             user.id = userGlobal.id;
541             user.userAddress = msg.sender;
542             user.freezeAmount = msg.value;
543             user.staticLevel = getLevel(msg.value);
544             user.dynamicLevel = getLineLevel(msg.value);
545             user.allInvest = msg.value;
546             if (!isEmpty(userGlobal.referrer)) {
547                 address referrerAddr = getUserAddressByCode(userGlobal.referrer);
548                 if (referrerAddr != address(0)) {
549                     userRoundMapping[rid][referrerAddr].inviteAmount++;
550                 }
551             }
552         }
553         Invest memory invest = Invest(msg.sender, msg.value, investTime, now, 0, flag, !notSuspended(investTime));
554         user.invests.push(invest);
555         lastInvestTime = investTime;
556 
557         investCount = investCount.add(1);
558         investMoney = investMoney.add(msg.value);
559         rInvestCount[rid] = rInvestCount[rid].add(1);
560         rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
561         
562         if (user.staticLevel >= 3) {
563             storeSolitaire(msg.sender);
564         }
565         investAmountList[rid].push(msg.value);
566 
567         storeDynamicPreProfits(msg.sender, getDayForProfits(investTime), flag);
568 
569         sendFeetoAdmin(msg.value);
570         trySendTransform(msg.value);
571 
572         emit LogInvestIn(msg.sender, userGlobal.id, msg.value, now, investTime, userGlobal.inviteCode, userGlobal.referrer, 0);
573     }
574 
575     function reInvestIn() external payable {
576         require(gameStart(), "game not start");
577         User storage user = userRoundMapping[rid][msg.sender];
578         require(user.id > 0, "user haven't invest in round before");
579         calStaticProfitInner(msg.sender);
580         require(user.freezeAmount == 0, "user have had invest in round");
581         require(user.unlockAmount > 0, "user must have unlockAmount");
582         require(user.unlockAmount.add(msg.value) <= 20 * ethWei, "can not beyond 20 eth");
583         require(user.unlockAmount.add(msg.value) == user.unlockAmount.add(msg.value).div(ethWei).mul(ethWei), "invalid msg value");
584 
585         bool isEnough;
586         uint sendMoney;
587         sendMoney = calDynamicProfits(msg.sender);
588         if (sendMoney > 0) {
589             (isEnough, sendMoney) = isEnoughBalance(sendMoney);
590 
591             if (sendMoney > 0) {
592                 user.dynamicWithdrawn = user.dynamicWithdrawn.add(sendMoney);
593                 sendMoneyToUser(msg.sender, sendMoney.mul(90).div(100));
594                 sendMoneyToUser(loyal, sendMoney.mul(10).div(100));
595                 emit LogWithdrawProfit(msg.sender, user.id, sendMoney, now, 2);
596             }
597             if (!isEnough) {
598                 endRound();
599                 return;
600             }
601         }
602 
603         uint reInvestAmount = user.unlockAmount.add(msg.value);
604 
605         uint investTime = now;
606         calUserQueueingStatic(msg.sender);
607 
608         uint leastAmount = reInvestAmount.mul(4).div(100);
609         (isEnough, sendMoney) = isEnoughBalance(leastAmount);
610         if (!isEnough) {
611             if (sendMoney > 0) {
612                 sendMoneyToUser(msg.sender, sendMoney);
613             }
614             endRound();
615             return;
616         }
617 
618         user.unlockAmount = 0;
619         user.allInvest = user.allInvest.add(reInvestAmount);
620         user.freezeAmount = user.freezeAmount.add(reInvestAmount);
621         user.staticLevel = getLevel(user.freezeAmount);
622         user.dynamicLevel = getLineLevel(user.freezeAmount);
623         user.reInvestCount = user.reInvestCount.add(1);
624         user.unlockAmountRedeemTime = 0;
625 
626         uint flag = user.invests[user.invests.length-1].modeFlag;
627         Invest memory invest = Invest(msg.sender, reInvestAmount, investTime, now, 0, flag, !notSuspended(investTime));
628         user.invests.push(invest);
629         if (investTime > lastInvestTime) {
630             lastInvestTime = investTime;
631         }
632 
633         investCount = investCount.add(1);
634         investMoney = investMoney.add(reInvestAmount);
635         rInvestCount[rid] = rInvestCount[rid].add(1);
636         rInvestMoney[rid] = rInvestMoney[rid].add(reInvestAmount);
637         if (user.staticLevel >= 3) {
638             storeSolitaire(msg.sender);
639         }
640         investAmountList[rid].push(reInvestAmount);
641         storeDynamicPreProfits(msg.sender, getDayForProfits(investTime), flag);
642 
643         sendFeetoAdmin(reInvestAmount);
644         trySendTransform(reInvestAmount);
645         emit LogInvestIn(msg.sender, user.id, reInvestAmount, now, investTime, userMapping[msg.sender].inviteCode, userMapping[msg.sender].referrer, 1);
646     }
647 
648     function storeSolitaire(address user) private {
649         uint len = investAmountList[rid].length;
650         if (len != 0) {
651             uint tmpTotalInvest;
652             for (uint i = 1; i <= 20 && i <= len; i++) {
653                 tmpTotalInvest = tmpTotalInvest.add(investAmountList[rid][len-i]);
654             }
655             uint reward = tmpTotalInvest.mul(1).div(10000).mul(6);
656             if (reward > 0) {
657                 userRoundMapping[rid][user].solitaire = userRoundMapping[rid][user].solitaire.add(reward);
658             }
659         }
660     }
661 
662     function withdrawProfit()
663     public
664     isHuman()
665     {
666         require(gameStart(), "game not start");
667         User storage user = userRoundMapping[rid][msg.sender];
668         calStaticProfitInner(msg.sender);
669 
670         uint sendMoney = user.allStaticAmount;
671 
672         bool isEnough = false;
673         uint resultMoney = 0;
674         (isEnough, resultMoney) = isEnoughBalance(sendMoney);
675         if (!isEnough) {
676             endRound();
677         }
678 
679         if (resultMoney > 0) {
680             sendMoneyToUser(msg.sender, resultMoney);
681             user.staticWithdrawn = user.staticWithdrawn.add(sendMoney);
682             user.allStaticAmount = 0;
683             emit LogWithdrawProfit(msg.sender, user.id, resultMoney, now, 1);
684         }
685     }
686 
687     function isEnoughBalance(uint sendMoney) private view returns (bool, uint){
688         if (sendMoney >= address(this).balance) {
689             return (false, address(this).balance);
690         } else {
691             return (true, sendMoney);
692         }
693     }
694 
695     function isEnoughBalanceToRedeem(uint sendMoney, uint reInvestCount, uint hisStaticAmount) private view returns (bool, uint){
696         uint deductedStaticAmount = 0;
697         if (reInvestCount >= 0 && reInvestCount <= 6) {
698             deductedStaticAmount = hisStaticAmount.mul(5).div(10);
699             sendMoney = sendMoney.sub(deductedStaticAmount);
700         }
701         if (reInvestCount > 6 && reInvestCount <= 18) {
702             deductedStaticAmount = hisStaticAmount.mul(4).div(10);
703             sendMoney = sendMoney.sub(deductedStaticAmount);
704         }
705         if (reInvestCount > 18 && reInvestCount <= 36) {
706             deductedStaticAmount = hisStaticAmount.mul(3).div(10);
707             sendMoney = sendMoney.sub(deductedStaticAmount);
708         }
709         if (reInvestCount >= 37) {
710             deductedStaticAmount = hisStaticAmount.mul(1).div(10);
711             sendMoney = sendMoney.sub(deductedStaticAmount);
712         }
713         if (sendMoney >= address(this).balance) {
714             return (false, address(this).balance);
715         } else {
716             return (true, sendMoney);
717         }
718     }
719 
720     function sendMoneyToUser(address payable userAddress, uint money) private {
721         userAddress.transfer(money);
722     }
723 
724     function calStaticProfitInner(address payable userAddr) private returns (uint){
725         User storage user = userRoundMapping[rid][userAddr];
726         if (user.id == 0 || user.freezeAmount == 0) {
727             return 0;
728         }
729         uint allStatic = 0;
730         uint i = user.invests.length.sub(1);
731         Invest storage invest = user.invests[i];
732         uint scale;
733         if (invest.modeFlag == 0) {
734             scale = getScByLevel(user.staticLevel, user.reInvestCount);
735         } else if (invest.modeFlag == 1) {
736             scale = getSepScByLevel(user.staticLevel);
737         }
738         uint startDay = invest.investTime.sub(8 hours).div(1 days).mul(1 days);
739         if (now.sub(8 hours) < startDay) {
740             return 0;
741         }
742         uint staticGaps = now.sub(8 hours).sub(startDay).div(1 days);
743 
744         if (staticGaps > 6) {
745             staticGaps = 6;
746         }
747         if (staticGaps > invest.times) {
748             if (invest.isSuspendedInvest) {
749                 allStatic = staticGaps.sub(invest.times).mul(scale).mul(invest.investAmount).div(10000).mul(2);
750                 invest.times = staticGaps;
751             } else {
752                 allStatic = staticGaps.sub(invest.times).mul(scale).mul(invest.investAmount).div(10000);
753                 invest.times = staticGaps;
754             }
755         }
756 
757         (uint unlockDay, uint unlockAmountRedeemTime) = getUnLockDay(invest.investTime);
758 
759         if (unlockDay >= 6 && user.freezeAmount != 0) {
760             user.staticFlag = user.staticFlag.add(1);
761             user.freezeAmount = user.freezeAmount.sub(invest.investAmount);
762             user.unlockAmount = user.unlockAmount.add(invest.investAmount);
763             user.unlockAmountRedeemTime = unlockAmountRedeemTime;
764             user.staticLevel = getLevel(user.freezeAmount);
765 
766             if (user.solitaire > 0) {
767                 userAddr.transfer(user.solitaire);
768                 user.hisSolitaire = user.hisSolitaire.add(user.solitaire);
769                 emit LogWithdrawProfit(userAddr, user.id, user.solitaire, now, 3);
770             }
771             user.solitaire = 0;
772         }
773 
774         allStatic = allStatic.mul(coefficient).div(10);
775         user.allStaticAmount = user.allStaticAmount.add(allStatic);
776         user.hisStaticAmount = user.hisStaticAmount.add(allStatic);
777         return user.allStaticAmount;
778     }
779 
780     function getStaticProfits(address userAddr) public view returns(uint, uint, uint) {
781         User memory user = userRoundMapping[rid][userAddr];
782         if (user.id == 0 || user.invests.length == 0) {
783             return (0, 0, 0);
784         }
785         if (user.freezeAmount == 0) {
786             return (0, user.hisStaticAmount, user.staticWithdrawn);
787         }
788         uint allStatic = 0;
789         uint i = user.invests.length.sub(1);
790         Invest memory invest = user.invests[i];
791         uint scale;
792         if (invest.modeFlag == 0) {
793             scale = getScByLevel(user.staticLevel, user.reInvestCount);
794         } else if (invest.modeFlag == 1) {
795             scale = getSepScByLevel(user.staticLevel);
796         }
797         uint startDay = invest.investTime.sub(8 hours).div(1 days).mul(1 days);
798         if (now.sub(8 hours) < startDay) {
799             return (0, user.hisStaticAmount, user.staticWithdrawn);
800         }
801         uint staticGaps = now.sub(8 hours).sub(startDay).div(1 days);
802 
803         if (staticGaps > 6) {
804             staticGaps = 6;
805         }
806         if (staticGaps > invest.times) {
807             if (invest.isSuspendedInvest) {
808                 allStatic = staticGaps.sub(invest.times).mul(scale).mul(invest.investAmount).div(10000).mul(2);
809             } else {
810                 allStatic = staticGaps.sub(invest.times).mul(scale).mul(invest.investAmount).div(10000);
811             }
812         }
813 
814         allStatic = allStatic.mul(coefficient).div(10);
815         return (
816             user.allStaticAmount.add(allStatic),
817             user.hisStaticAmount.add(allStatic),
818             user.staticWithdrawn
819         );
820     }
821 
822     function storeDynamicPreProfits(address userAddr, uint investDay, uint modeFlag) private {
823         uint freezeAmount = userRoundMapping[rid][userAddr].freezeAmount;
824         if (freezeAmount >= 1 * ethWei) {
825             uint scale;
826             if (modeFlag == 0) {
827                 scale = getScByLevel(userRoundMapping[rid][userAddr].staticLevel, userRoundMapping[rid][userAddr].reInvestCount);
828             } else if (modeFlag == 1) {
829                 scale = getSepScByLevel(userRoundMapping[rid][userAddr].staticLevel);
830             }
831             uint staticMoney = freezeAmount.mul(scale).div(10000);
832             updateReferrerPreProfits(userMapping[userAddr].referrer, investDay, staticMoney);
833         }
834     }
835 
836     function updateReferrerPreProfits(string memory referrer, uint day, uint staticMoney) private {
837         string memory tmpReferrer = referrer;
838 
839         for (uint i = 1; i <= 20; i++) {
840             if (isEmpty(tmpReferrer)) {
841                 break;
842             }
843             uint floorIndex = getFloorIndex(i);
844             address tmpUserAddr = addressMapping[tmpReferrer];
845             if (tmpUserAddr == address(0)) {
846                 break;
847             }
848 
849             for (uint j = 0; j < 6; j++) {
850                 uint dayIndex = day.add(j);
851                 uint currentMoney = userRoundMapping[rid][tmpUserAddr].dynamicProfits[floorIndex][dayIndex];
852                 userRoundMapping[rid][tmpUserAddr].dynamicProfits[floorIndex][dayIndex] = currentMoney.add(staticMoney);
853             }
854             tmpReferrer = userMapping[tmpUserAddr].referrer;
855         }
856     }
857 
858     function calDynamicProfits(address user) public view returns (uint) {
859         uint len = userRoundMapping[rid][user].invests.length;
860         if (len == 0) {
861             return 0;
862         }
863         uint userInvestDay = getDayForProfits(userRoundMapping[rid][user].invests[len - 1].investTime);
864         uint totalProfits;
865 
866         uint floor;
867         uint dynamicLevel = userRoundMapping[rid][user].dynamicLevel;
868         floor = getDynamicFloor(dynamicLevel);
869         if (floor > 20) {
870             floor = 20;
871         }
872         uint floorCap = getFloorIndex(floor);
873         uint fireSc = getFireScByLevel(dynamicLevel);
874 
875         for (uint i = 1; i <= floorCap; i++) {
876             uint recommendSc = getRecommendScaleByLevelAndTim(dynamicLevel, i);
877             for (uint j = 0; j < 6; j++) {
878                 uint day = userInvestDay.add(j);
879                 uint staticProfits = userRoundMapping[rid][user].dynamicProfits[i][day];
880 
881                 if (recommendSc != 0) {
882                     uint tmpDynamicAmount = staticProfits.mul(fireSc).mul(recommendSc);
883                     totalProfits = tmpDynamicAmount.div(10).div(100).add(totalProfits);
884                 }
885             }
886         }
887 
888         return totalProfits;
889     }
890 
891     function registerUserInfo(address user, string calldata inviteCode, string calldata referrer) external onlyOwner {
892         registerUser(user, inviteCode, referrer);
893     }
894 
895     function calUserQueueingStatic(address userAddress) private returns(uint) {
896         User storage calUser = userRoundMapping[rid][userAddress];
897 
898         uint investLength = calUser.invests.length;
899         if (investLength == 0) {
900             return 0;
901         }
902 
903         Invest memory invest = calUser.invests[investLength - 1];
904         if (invest.investTime <= invest.realityInvestTime) {
905             return 0;
906         }
907 
908         uint staticGaps = getQueueingStaticGaps(invest.investTime, invest.realityInvestTime);
909         if (staticGaps <= 0) {
910             return 0;
911         }
912         uint staticAmount = invest.investAmount.mul(staticGaps).mul(5).div(10000);
913         calUser.hisStaticAmount = calUser.hisStaticAmount.add(staticAmount);
914         calUser.allStaticAmount = calUser.allStaticAmount.add(staticAmount);
915         return staticAmount;
916     }
917 
918     function getQueueingStaticGaps(uint investTime, uint realityInvestTime) private pure returns (uint){
919         if(investTime <= realityInvestTime){
920             return 0;
921         }
922         uint startDay = realityInvestTime.sub(8 hours).div(1 days).mul(1 days);
923         uint staticGaps = investTime.sub(8 hours).sub(startDay).div(1 days);
924         return staticGaps;
925     }
926 
927     function redeem()
928     public
929     isHuman()
930     isSuspended()
931     {
932         require(gameStart(), "game not start");
933         User storage user = userRoundMapping[rid][msg.sender];
934         require(user.id > 0, "user not exist");
935         withdrawProfit();
936         require(now >= user.unlockAmountRedeemTime, "redeem time non-arrival");
937 
938         uint sendMoney = user.unlockAmount;
939         require(sendMoney != 0, "you don't have unlock money");
940         uint reInvestCount = user.reInvestCount;
941         uint hisStaticAmount = user.hisStaticAmount;
942 
943         bool isEnough = false;
944         uint resultMoney = 0;
945 
946         uint index = user.invests.length - 1;
947         if (user.invests[index].modeFlag == 0) {
948             (isEnough, resultMoney) = isEnoughBalanceToRedeem(sendMoney, reInvestCount, hisStaticAmount);
949         } else if (user.invests[index].modeFlag == 1) {
950             require(reInvestCount == 4 || (reInvestCount>4 && (reInvestCount-4)%5 == 0), "reInvest time not enough");
951             (isEnough, resultMoney) = isEnoughBalance(sendMoney);
952         } else {
953             revert("invalid flag");
954         }
955 
956         if (!isEnough) {
957             endRound();
958         }
959         if (resultMoney > 0) {
960             sendMoneyToUser(msg.sender, resultMoney);
961             user.unlockAmount = 0;
962             user.staticLevel = getLevel(user.freezeAmount);
963             user.dynamicLevel = 0;
964             user.reInvestCount = 0;
965             user.hisStaticAmount = 0;
966             emit LogRedeem(msg.sender, user.id, resultMoney, now);
967         }
968     }
969 
970     function getUnLockDay(uint investTime) public view returns (uint unlockDay, uint unlockAmountRedeemTime){
971         uint gameStartTime = startTime;
972         if (gameStartTime <= 0 || investTime > now || investTime < gameStartTime) {
973             return (0, 0);
974         }
975         unlockDay = now.sub(investTime).div(1 days);
976         unlockAmountRedeemTime = 0;
977         if (unlockDay < 6) {
978             return (unlockDay, unlockAmountRedeemTime);
979         }
980         unlockAmountRedeemTime = investTime.add(uint(6).mul(1 days));
981 
982         uint stopTime = suspendedTime;
983         if (stopTime == 0) {
984             return (unlockDay, unlockAmountRedeemTime);
985         }
986 
987         uint stopDays = suspendedDays;
988         uint stopEndTime = stopTime.add(stopDays.mul(1 days));
989         if (investTime < stopTime){
990             if(unlockAmountRedeemTime >= stopEndTime){
991                 unlockAmountRedeemTime = unlockAmountRedeemTime.add(stopDays.mul(1 days));
992             }else if(unlockAmountRedeemTime < stopEndTime && unlockAmountRedeemTime > stopTime){
993                 unlockAmountRedeemTime = stopEndTime.add(unlockAmountRedeemTime.sub(stopTime));
994             }
995         }
996         if (investTime >= stopTime && investTime < stopEndTime){
997             if(unlockAmountRedeemTime >= stopEndTime){
998                 unlockAmountRedeemTime = unlockAmountRedeemTime.add(stopEndTime.sub(investTime));
999             }else if(unlockAmountRedeemTime < stopEndTime && unlockAmountRedeemTime > stopTime){
1000                 unlockAmountRedeemTime = stopEndTime.add(uint(6).mul(1 days));
1001             }
1002         }
1003         return (unlockDay, unlockAmountRedeemTime);
1004     }
1005 
1006     function endRound() private {
1007         rid++;
1008         startTime = now.add(period).div(1 days).mul(1 days);
1009         coefficient = 10;
1010     }
1011 
1012     function isUsed(string memory code) public view returns (bool) {
1013         address user = getUserAddressByCode(code);
1014         return uint(user) != 0;
1015     }
1016 
1017     function getUserAddressByCode(string memory code) public view returns (address) {
1018         return addressMapping[code];
1019     }
1020 
1021     function sendFeetoAdmin(uint amount) private {
1022         devAddr.transfer(amount.div(25));
1023     }
1024 
1025     function trySendTransform(uint amount) private {
1026         if (transformAmount[rid] > 500 * ethWei) {
1027             return;
1028         }
1029         uint sendAmount = amount.div(100);
1030         transformAmount[rid] = transformAmount[rid].add(sendAmount);
1031         other.transfer(sendAmount);
1032     }
1033 
1034     function getGameInfo() public isHuman() view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
1035         uint dayInvest;
1036         uint dayLimit;
1037         dayInvest = everyDayInvestMapping[getCurrentInvestDay(now)];
1038         dayLimit = getCurrentInvestLimit(now);
1039         return (
1040         rid,
1041         uid,
1042         startTime,
1043         investCount,
1044         investMoney,
1045         rInvestCount[rid],
1046         rInvestMoney[rid],
1047         coefficient,
1048         dayInvest,
1049         dayLimit,
1050         now,
1051         lastInvestTime
1052         );
1053     }
1054 
1055     function getUserInfo(address user, uint roundId) public isHuman() view returns (
1056         uint[19] memory ct, string memory inviteCode, string memory referrer
1057     ) {
1058 
1059         if (roundId == 0) {
1060             roundId = rid;
1061         }
1062 
1063         User memory userInfo = userRoundMapping[roundId][user];
1064 
1065         ct[0] = userInfo.id;
1066         ct[1] = userInfo.staticLevel;
1067         ct[2] = userInfo.dynamicLevel;
1068         ct[3] = userInfo.allInvest;
1069         Invest memory invest;
1070         if (userInfo.invests.length == 0) {
1071             ct[4] = 0;
1072         } else {
1073             invest = userInfo.invests[userInfo.invests.length-1];
1074             if (invest.modeFlag == 0) {
1075                 ct[4] = getScByLevel(userInfo.staticLevel, userInfo.reInvestCount);
1076             } else if(invest.modeFlag == 1) {
1077                 ct[4] = getSepScByLevel(userInfo.staticLevel);
1078             } else {
1079                 ct[4] = 0;
1080             }
1081         }
1082         ct[5] = userInfo.inviteAmount;
1083         ct[6] = userInfo.freezeAmount;
1084         ct[7] = userInfo.staticWithdrawn.add(userInfo.dynamicWithdrawn);
1085         ct[8] = userInfo.staticWithdrawn;
1086         ct[9] = userInfo.dynamicWithdrawn;
1087         uint canWithdrawn;
1088         uint hisWithdrawn;
1089         uint staticWithdrawn;
1090         (canWithdrawn, hisWithdrawn, staticWithdrawn) = getStaticProfits(user);
1091         ct[10] = canWithdrawn;
1092         ct[11] = calDynamicProfits(user);
1093         uint lockDay;
1094         uint redeemTime;
1095         (lockDay, redeemTime) = getUnLockDay(invest.investTime);
1096         ct[12] = lockDay;
1097         ct[13] = redeemTime;
1098         ct[14] = userInfo.reInvestCount;
1099         ct[15] = invest.modeFlag;
1100         ct[16] = userInfo.unlockAmount;
1101         ct[17] = invest.investTime;
1102         ct[18] = userInfo.hisSolitaire;
1103 
1104         inviteCode = userMapping[user].inviteCode;
1105         referrer = userMapping[user].referrer;
1106         return (
1107         ct,
1108         inviteCode,
1109         referrer
1110         );
1111     }
1112 
1113     function getInvestTime(uint amount) public view returns (uint){
1114         uint lastTime = lastInvestTime;
1115 
1116         uint investTime = 0;
1117 
1118         if (isLessThanLimit(amount, now)) {
1119             if (now < lastTime) {
1120                 investTime = lastTime.add(1 seconds);
1121             } else {
1122                 investTime = now;
1123             }
1124         } else {
1125             investTime = lastTime.add(1 seconds);
1126             if (!isLessThanLimit(amount, investTime)) {
1127                 investTime = getCurrentInvestDay(lastTime).mul(1 days).add(baseTime);
1128             }
1129         }
1130         return investTime;
1131     }
1132 
1133 
1134     function getDayForProfits(uint investTime) private pure returns (uint) {
1135         return investTime.sub(8 hours).div(1 days);
1136     }
1137 
1138     function getCurrentInvestLimit(uint investTime) public view returns (uint){
1139         uint currentDays = getCurrentInvestDay(investTime).sub(1);
1140         uint currentRound = currentDays.div(6).add(1);
1141         uint x = 3 ** (currentRound.sub(1));
1142         uint y = 2 ** (currentRound.sub(1));
1143         return baseLimit.mul(x).div(y);
1144     }
1145 
1146     function getCurrentInvestDay(uint investTime) public view returns (uint){
1147         uint gameStartTime = baseTime;
1148         if (gameStartTime == 0 || investTime < gameStartTime) {
1149             return 0;
1150         }
1151         uint currentInvestDay = investTime.sub(gameStartTime).div(1 days).add(1);
1152         return currentInvestDay;
1153     }
1154     function isLessThanLimit(uint amount, uint investTime) public view returns (bool){
1155         return getCurrentInvestLimit(investTime) >= amount.add(everyDayInvestMapping[getCurrentInvestDay(investTime)]);
1156     }
1157     function notSuspended() public view returns (bool) {
1158         uint sTime = suspendedTime;
1159         uint sDays = suspendedDays;
1160         return sTime == 0 || now < sTime || now >= sDays.mul(1 days).add(sTime);
1161     }
1162 
1163     function notSuspended(uint investTime) public view returns (bool) {
1164         uint sTime = suspendedTime;
1165         uint sDays = suspendedDays;
1166         return sTime == 0 || investTime < sTime || investTime >= sDays.mul(1 days).add(sTime);
1167     }
1168 
1169     function suspended(uint stopTime, uint stopDays) external onlyWhitelistAdmin {
1170         require(gameStart(), "game not start");
1171         require(stopTime > now, "stopTime shoule gt now");
1172         require(stopTime > lastInvestTime, "stopTime shoule gt lastInvestTime");
1173         suspendedTime = stopTime;
1174         suspendedDays = stopDays;
1175     }
1176 
1177     function getUserById(uint id) public view returns (address){
1178         return indexMapping[id];
1179     }
1180 
1181     function getAvailableReInvestInAmount(address userAddr) public view returns (uint){
1182         User memory user = userRoundMapping[rid][userAddr];
1183         if(user.freezeAmount == 0){
1184             return user.unlockAmount;
1185         }else{
1186             Invest memory invest = user.invests[user.invests.length - 1];
1187             (uint unlockDay, uint unlockAmountRedeemTime) = getUnLockDay(invest.investTime);
1188             if(unlockDay >= 6){
1189                 return invest.investAmount;
1190             }
1191         }
1192         return 0;
1193     }
1194 
1195     function getAvailableRedeemAmount(address userAddr) public view returns (uint){
1196         User memory user = userRoundMapping[rid][userAddr];
1197         if (now < user.unlockAmountRedeemTime) {
1198             return 0;
1199         }
1200         uint allUnlock = user.unlockAmount;
1201         if (user.freezeAmount > 0) {
1202             Invest memory invest = user.invests[user.invests.length - 1];
1203             (uint unlockDay, uint unlockAmountRedeemTime) = getUnLockDay(invest.investTime);
1204             if (unlockDay >= 6 && now >= unlockAmountRedeemTime) {
1205                 allUnlock = invest.investAmount;
1206             }
1207             if(invest.modeFlag == 1){
1208                 if(user.reInvestCount < 4 || (user.reInvestCount - 4)%5 != 0){
1209                     allUnlock = 0;
1210                 }
1211             }
1212         }
1213         return allUnlock;
1214     }
1215 
1216     function registerUser(address user, string memory inviteCode, string memory referrer) private {
1217         UserGlobal storage userGlobal = userMapping[user];
1218         if (userGlobal.id != 0) {
1219             userGlobal.userAddress = user;
1220             userGlobal.inviteCode = inviteCode;
1221             userGlobal.referrer = referrer;
1222             
1223             addressMapping[inviteCode] = user;
1224             indexMapping[uid] = user;
1225         } else {
1226             uid++;
1227             userGlobal.id = uid;
1228             userGlobal.userAddress = user;
1229             userGlobal.inviteCode = inviteCode;
1230             userGlobal.referrer = referrer;
1231             
1232             addressMapping[inviteCode] = user;
1233             indexMapping[uid] = user;
1234         }
1235         
1236     }
1237 }
1238 
1239 /**
1240  * @title SafeMath
1241  * @dev Math operations with safety checks that revert on error
1242  */
1243 library SafeMath {
1244 
1245     /**
1246     * @dev Multiplies two numbers, reverts on overflow.
1247     */
1248     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1249         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1250         // benefit is lost if 'b' is also tested.
1251         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1252         if (a == 0) {
1253             return 0;
1254         }
1255 
1256         uint256 c = a * b;
1257         require(c / a == b, "mul overflow");
1258 
1259         return c;
1260     }
1261 
1262     /**
1263     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1264     */
1265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1266         require(b > 0, "div zero");
1267         // Solidity only automatically asserts when dividing by 0
1268         uint256 c = a / b;
1269         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1270 
1271         return c;
1272     }
1273 
1274     /**
1275     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1276     */
1277     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1278         require(b <= a, "lower sub bigger");
1279         uint256 c = a - b;
1280 
1281         return c;
1282     }
1283 
1284     /**
1285     * @dev Adds two numbers, reverts on overflow.
1286     */
1287     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1288         uint256 c = a + b;
1289         require(c >= a, "overflow");
1290 
1291         return c;
1292     }
1293 
1294     /**
1295     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1296     * reverts when dividing by zero.
1297     */
1298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1299         require(b != 0, "mod zero");
1300         return a % b;
1301     }
1302 }