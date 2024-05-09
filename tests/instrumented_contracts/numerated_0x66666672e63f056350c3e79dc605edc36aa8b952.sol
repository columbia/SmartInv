1 pragma solidity ^0.5.0;
2 
3 contract UtilETHMagic {
4     uint ethWei = 1 ether;
5 
6     function getLevel(uint value) internal view returns(uint) {
7         if (value >= 1*ethWei && value <= 5*ethWei) {
8             return 1;
9         }
10         if (value >= 6*ethWei && value <= 10*ethWei) {
11             return 2;
12         }
13         if (value >= 11*ethWei && value <= 15*ethWei) {
14             return 3;
15         }
16         return 0;
17     }
18 
19     function getLineLevel(uint value) internal view returns(uint) {
20         if (value >= 1*ethWei && value <= 5*ethWei) {
21             return 1;
22         }
23         if (value >= 6*ethWei && value <= 10*ethWei) {
24             return 2;
25         }
26         if (value >= 11*ethWei) {
27             return 3;
28         }
29         return 0;
30     }
31 
32     function getScByLevel(uint level) internal pure returns(uint) {
33         if (level == 1) {
34             return 5;
35         }
36         if (level == 2) {
37             return 7;
38         }
39         if (level == 3) {
40             return 10;
41         }
42         return 0;
43     }
44 
45     function getFireScByLevel(uint level) internal pure returns(uint) {
46         if (level == 1) {
47             return 3;
48         }
49         if (level == 2) {
50             return 6;
51         }
52         if (level == 3) {
53             return 10;
54         }
55         return 0;
56     }
57 
58     function getRecommendScaleByLevelAndTim(uint level,uint times) internal pure returns(uint){
59         if (level == 1 && times == 1) {
60             return 50;
61         }
62         if (level == 2 && times == 1) {
63             return 70;
64         }
65         if (level == 2 && times == 2) {
66             return 50;
67         }
68         if (level == 3) {
69             if(times == 1){
70                 return 100;
71             }
72             if (times == 2) {
73                 return 70;
74             }
75             if (times == 3) {
76                 return 50;
77             }
78             if (times >= 4 && times <= 10) {
79                 return 10;
80             }
81             if (times >= 11 && times <= 20) {
82                 return 5;
83             }
84             if (times >= 21) {
85                 return 1;
86             }
87         }
88         return 0;
89     }
90 
91     function compareStr(string memory _str, string memory str) internal pure returns(bool) {
92         if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
93             return true;
94         }
95         return false;
96     }
97 }
98 
99 /*
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with GSN meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 contract Context {
110     // Empty internal constructor, to prevent people from mistakenly deploying
111     // an instance of this contract, which should be used via inheritance.
112     constructor() internal {}
113     // solhint-disable-previous-line no-empty-blocks
114 
115     function _msgSender() internal view returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view returns (bytes memory) {
120         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
121         return msg.data;
122     }
123 }
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor () internal {
143         _owner = _msgSender();
144         emit OwnershipTransferred(address(0), _owner);
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         require(isOwner(), "Ownable: caller is not the owner");
159         _;
160     }
161 
162     /**
163      * @dev Returns true if the caller is the current owner.
164      */
165     function isOwner() public view returns (bool) {
166         return _msgSender() == _owner;
167     }
168 
169     /**
170      * @dev Leaves the contract without owner. It will not be possible to call
171      * `onlyOwner` functions anymore. Can only be called by the current owner.
172      *
173      * NOTE: Renouncing ownership will leave the contract without an owner,
174      * thereby removing any functionality that is only available to the owner.
175      */
176     function renounceOwnership() public onlyOwner {
177         emit OwnershipTransferred(_owner, address(0));
178         _owner = address(0);
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Can only be called by the current owner.
184      */
185     function transferOwnership(address newOwner) public onlyOwner {
186         _transferOwnership(newOwner);
187     }
188 
189     /**
190      * @dev Transfers ownership of the contract to a new account (`newOwner`).
191      */
192     function _transferOwnership(address newOwner) internal {
193         require(newOwner != address(0), "Ownable: new owner is the zero address");
194         emit OwnershipTransferred(_owner, newOwner);
195         _owner = newOwner;
196     }
197 }
198 
199 /**
200  * @title Roles
201  * @dev Library for managing addresses assigned to a Role.
202  */
203 library Roles {
204     struct Role {
205         mapping (address => bool) bearer;
206     }
207 
208     /**
209      * @dev Give an account access to this role.
210      */
211     function add(Role storage role, address account) internal {
212         require(!has(role, account), "Roles: account already has role");
213         role.bearer[account] = true;
214     }
215 
216     /**
217      * @dev Remove an account's access to this role.
218      */
219     function remove(Role storage role, address account) internal {
220         require(has(role, account), "Roles: account does not have role");
221         role.bearer[account] = false;
222     }
223 
224     /**
225      * @dev Check if an account has this role.
226      * @return bool
227      */
228     function has(Role storage role, address account) internal view returns (bool) {
229         require(account != address(0), "Roles: account is the zero address");
230         return role.bearer[account];
231     }
232 }
233 
234 /**
235  * @title WhitelistAdminRole
236  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
237  */
238 contract WhitelistAdminRole is Context, Ownable {
239     using Roles for Roles.Role;
240 
241     event WhitelistAdminAdded(address indexed account);
242     event WhitelistAdminRemoved(address indexed account);
243 
244     Roles.Role private _whitelistAdmins;
245 
246     constructor () internal {
247         _addWhitelistAdmin(_msgSender());
248     }
249 
250     modifier onlyWhitelistAdmin() {
251         require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
252         _;
253     }
254 
255     function isWhitelistAdmin(address account) public view returns (bool) {
256         return _whitelistAdmins.has(account);
257     }
258 
259     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
260         _addWhitelistAdmin(account);
261     }
262 
263     function removeWhitelistAdmin(address account) public onlyOwner {
264         _whitelistAdmins.remove(account);
265         emit WhitelistAdminRemoved(account);
266     }
267 
268     function renounceWhitelistAdmin() public {
269         _removeWhitelistAdmin(_msgSender());
270     }
271 
272     function _addWhitelistAdmin(address account) internal {
273         _whitelistAdmins.add(account);
274         emit WhitelistAdminAdded(account);
275     }
276 
277     function _removeWhitelistAdmin(address account) internal {
278         _whitelistAdmins.remove(account);
279         emit WhitelistAdminRemoved(account);
280     }
281 }
282 
283 contract ETHMagic is UtilETHMagic, WhitelistAdminRole {
284 
285     using SafeMath for *;
286 
287     string constant private name = "eth magic foundation";
288 
289     uint ethWei = 1 ether;
290 
291     address payable private devAddr = address(0xCdC8a5090D01b750E396c306528D16d1423c05bC);
292     address payable private savingAddr = address(0xf494EDE0FFf005286fB4CD3028ea988891F74ff4);
293     address payable private follow = address(0xE89FF0053Cabd88e9faB814d75e2a971f28aAFd7);
294 
295     struct User{
296         uint id;
297         address userAddress;
298         string inviteCode;
299         string referrer;
300         uint staticLevel;
301         uint dynamicLevel;
302         uint allInvest;
303         uint freezeAmount;
304         uint unlockAmount;
305         uint allStaticAmount;
306         uint allDynamicAmount;
307         uint hisStaticAmount;
308         uint hisDynamicAmount;
309         uint inviteAmount;
310         uint reInvestCount;
311         uint lastReInvestTime;
312         Invest[] invests;
313         uint staticFlag;
314     }
315 
316     struct GameInfo {
317         uint luckPort;
318         address[] specialUsers;
319     }
320 
321     struct UserGlobal {
322         uint id;
323         address userAddress;
324         string inviteCode;
325         string referrer;
326     }
327 
328     struct Invest{
329         address userAddress;
330         uint investAmount;
331         uint investTime;
332         uint times;
333     }
334 
335     uint coefficient = 10;
336     uint startTime;
337     uint investCount = 0;
338     mapping(uint => uint) rInvestCount;
339     uint investMoney = 0;
340     mapping(uint => uint) rInvestMoney;
341     mapping(uint => GameInfo) rInfo;
342     uint uid = 0;
343     uint rid = 1;
344     uint period = 3 days;
345     mapping (uint => mapping(address => User)) userRoundMapping;
346     mapping(address => UserGlobal) userMapping;
347     mapping (string => address) addressMapping;
348     mapping (uint => address) public indexMapping;
349 
350     /**
351      * @dev Just a simply check to prevent contract
352      * @dev this by calling method in constructor.
353      */
354     modifier isHuman() {
355         address addr = msg.sender;
356         uint codeLength;
357 
358         assembly {codeLength := extcodesize(addr)}
359         require(codeLength == 0, "sorry humans only");
360         require(tx.origin == msg.sender, "sorry, human only");
361         _;
362     }
363 
364     event LogInvestIn(address indexed who, uint indexed uid, uint amount, uint time, string inviteCode, string referrer, uint typeFlag);
365     event LogWithdrawProfit(address indexed who, uint indexed uid, uint amount, uint time);
366     event LogRedeem(address indexed who, uint indexed uid, uint amount, uint now);
367 
368     //==============================================================================
369     // Constructor
370     //==============================================================================
371     constructor () public {
372     }
373 
374     function () external payable {
375     }
376 
377     function activeGame(uint time) external onlyWhitelistAdmin
378     {
379         require(time > now, "invalid game start time");
380         startTime = time;
381     }
382 
383     function setCoefficient(uint coeff) external onlyWhitelistAdmin
384     {
385         require(coeff > 0, "invalid coeff");
386         coefficient = coeff;
387     }
388 
389     function gameStart() private view returns(bool) {
390         return startTime != 0 && now > startTime;
391     }
392 
393     function investIn(string memory inviteCode, string memory referrer)
394         public
395         isHuman()
396         payable
397     {
398         require(gameStart(), "game not start");
399         require(msg.value >= 1*ethWei && msg.value <= 15*ethWei, "between 1 and 15");
400         require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");
401 
402         UserGlobal storage userGlobal = userMapping[msg.sender];
403         if (userGlobal.id == 0) {
404             require(!compareStr(inviteCode, ""), "empty invite code");
405             address referrerAddr = getUserAddressByCode(referrer);
406             require(uint(referrerAddr) != 0, "referer not exist");
407             require(referrerAddr != msg.sender, "referrer can't be self");
408             require(!isUsed(inviteCode), "invite code is used");
409 
410             registerUser(msg.sender, inviteCode, referrer);
411         }
412 
413         User storage user = userRoundMapping[rid][msg.sender];
414         if (uint(user.userAddress) != 0) {
415             require(user.freezeAmount.add(msg.value) <= 15*ethWei, "can not beyond 15 eth");
416             user.allInvest = user.allInvest.add(msg.value);
417             user.freezeAmount = user.freezeAmount.add(msg.value);
418             user.staticLevel = getLevel(user.freezeAmount);
419             user.dynamicLevel = getLineLevel(user.freezeAmount.add(user.unlockAmount));
420         } else {
421             user.id = userGlobal.id;
422             user.userAddress = msg.sender;
423             user.freezeAmount = msg.value;
424             user.staticLevel = getLevel(msg.value);
425             user.allInvest = msg.value;
426             user.dynamicLevel = getLineLevel(msg.value);
427             user.inviteCode = userGlobal.inviteCode;
428             user.referrer = userGlobal.referrer;
429 
430             if (!compareStr(userGlobal.referrer, "")) {
431                 address referrerAddr = getUserAddressByCode(userGlobal.referrer);
432                 userRoundMapping[rid][referrerAddr].inviteAmount++;
433             }
434         }
435 
436         Invest memory invest = Invest(msg.sender, msg.value, now, 0);
437         user.invests.push(invest);
438 
439         if (rInvestMoney[rid] != 0 && (rInvestMoney[rid].div(10000).div(ethWei) != rInvestMoney[rid].add(msg.value).div(10000).div(ethWei))) {
440             bool isEnough;
441             uint sendMoney;
442             (isEnough, sendMoney) = isEnoughBalance(rInfo[rid].luckPort);
443             if (sendMoney > 0) {
444                 sendMoneyToUser(msg.sender, sendMoney);
445             }
446             rInfo[rid].luckPort = 0;
447             if (!isEnough) {
448                 endRound();
449                 return;
450             }
451         }
452 
453         investCount = investCount.add(1);
454         investMoney = investMoney.add(msg.value);
455         rInvestCount[rid] = rInvestCount[rid].add(1);
456         rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
457         rInfo[rid].luckPort = rInfo[rid].luckPort.add(msg.value.mul(2).div(1000));
458 
459         sendFeetoAdmin(msg.value);
460         emit LogInvestIn(msg.sender, userGlobal.id, msg.value, now, userGlobal.inviteCode, userGlobal.referrer, 0);
461     }
462 
463 
464     function reInvestIn() public {
465         require(gameStart(), "game not start");
466         User storage user = userRoundMapping[rid][msg.sender];
467         require(user.id > 0, "user haven't invest in round before");
468         calStaticProfitInner(msg.sender);
469 
470         uint reInvestAmount = user.unlockAmount;
471         if (user.freezeAmount > 15*ethWei) {
472             user.freezeAmount = 15*ethWei;
473         }
474         if (user.freezeAmount.add(reInvestAmount) > 15*ethWei) {
475             reInvestAmount = (15*ethWei).sub(user.freezeAmount);
476         }
477 
478         if (reInvestAmount == 0) {
479             return;
480         }
481 
482         uint leastAmount = reInvestAmount.mul(47).div(1000);
483         bool isEnough;
484         uint sendMoney;
485         (isEnough, sendMoney) = isEnoughBalance(leastAmount);
486         if (!isEnough) {
487             if (sendMoney > 0) {
488                 sendMoneyToUser(msg.sender, sendMoney);
489             }
490             endRound();
491             return;
492         }
493 
494         user.unlockAmount = user.unlockAmount.sub(reInvestAmount);
495         user.allInvest = user.allInvest.add(reInvestAmount);
496         user.freezeAmount = user.freezeAmount.add(reInvestAmount);
497         user.staticLevel = getLevel(user.freezeAmount);
498         user.dynamicLevel = getLineLevel(user.freezeAmount.add(user.unlockAmount));
499         if ((now - user.lastReInvestTime) > 5 days) {
500             user.reInvestCount = user.reInvestCount.add(1);
501             user.lastReInvestTime = now;
502         }
503 
504         if (user.reInvestCount == 12) {
505             rInfo[rid].specialUsers.push(msg.sender);
506         }
507 
508         Invest memory invest = Invest(msg.sender, reInvestAmount, now, 0);
509         user.invests.push(invest);
510 
511         if (rInvestMoney[rid] != 0 && (rInvestMoney[rid].div(10000).div(ethWei) != rInvestMoney[rid].add(reInvestAmount).div(10000).div(ethWei))) {
512             (isEnough, sendMoney) = isEnoughBalance(rInfo[rid].luckPort);
513             if (sendMoney > 0) {
514                 sendMoneyToUser(msg.sender, sendMoney);
515             }
516             rInfo[rid].luckPort = 0;
517             if (!isEnough) {
518                 endRound();
519                 return;
520             }
521         }
522 
523         investCount = investCount.add(1);
524         investMoney = investMoney.add(reInvestAmount);
525         rInvestCount[rid] = rInvestCount[rid].add(1);
526         rInvestMoney[rid] = rInvestMoney[rid].add(reInvestAmount);
527         rInfo[rid].luckPort = rInfo[rid].luckPort.add(reInvestAmount.mul(2).div(1000));
528 
529         sendFeetoAdmin(reInvestAmount);
530         emit LogInvestIn(msg.sender, user.id, reInvestAmount, now, user.inviteCode, user.referrer, 1);
531     }
532 
533     function withdrawProfit()
534         public
535         isHuman()
536     {
537         require(gameStart(), "game not start");
538         User storage user = userRoundMapping[rid][msg.sender];
539         uint sendMoney = user.allStaticAmount.add(user.allDynamicAmount);
540 
541         bool isEnough = false;
542         uint resultMoney = 0;
543         (isEnough, resultMoney) = isEnoughBalance(sendMoney);
544         if (resultMoney > 0) {
545             sendMoneyToUser(msg.sender, resultMoney.mul(98).div(100));
546             savingAddr.transfer(resultMoney.mul(2).div(100));
547             user.allStaticAmount = 0;
548             user.allDynamicAmount = 0;
549             emit LogWithdrawProfit(msg.sender, user.id, resultMoney, now);
550         }
551 
552         if (!isEnough) {
553             endRound();
554         }
555     }
556 
557     function isEnoughBalance(uint sendMoney) private view returns (bool, uint){
558         if (sendMoney >= address(this).balance) {
559             return (false, address(this).balance);
560         } else {
561             return (true, sendMoney);
562         }
563     }
564 
565     function sendMoneyToUser(address payable userAddress, uint money) private {
566         userAddress.transfer(money);
567     }
568 
569     function calStaticProfit(address userAddr) external onlyWhitelistAdmin returns(uint)
570     {
571         return calStaticProfitInner(userAddr);
572     }
573 
574     function calStaticProfitInner(address userAddr) private returns(uint)
575     {
576         User storage user = userRoundMapping[rid][userAddr];
577         if (user.id == 0) {
578             return 0;
579         }
580 
581         uint scale = getScByLevel(user.staticLevel);
582         uint allStatic = 0;
583         for (uint i = user.staticFlag; i < user.invests.length; i++) {
584             Invest storage invest = user.invests[i];
585             uint startDay = invest.investTime.sub(4 hours).div(1 days).mul(1 days);
586             uint staticGaps = now.sub(4 hours).sub(startDay).div(1 days);
587 
588             uint unlockDay = now.sub(invest.investTime).div(1 days);
589 
590             if(staticGaps > 5){
591                 staticGaps = 5;
592             }
593             if (staticGaps > invest.times) {
594                 allStatic += staticGaps.sub(invest.times).mul(scale).mul(invest.investAmount).div(1000);
595                 invest.times = staticGaps;
596             }
597 
598             if (unlockDay >= 5) {
599                 user.staticFlag = user.staticFlag.add(1);
600                 user.freezeAmount = user.freezeAmount.sub(invest.investAmount);
601                 user.unlockAmount = user.unlockAmount.add(invest.investAmount);
602                 user.staticLevel = getLevel(user.freezeAmount);
603             }
604 
605         }
606         allStatic = allStatic.mul(coefficient).div(10);
607         user.allStaticAmount = user.allStaticAmount.add(allStatic);
608         user.hisStaticAmount = user.hisStaticAmount.add(allStatic);
609         return user.allStaticAmount;
610     }
611 
612     function calDynamicProfit(uint start, uint end) external onlyWhitelistAdmin {
613         for (uint i = start; i <= end; i++) {
614             address userAddr = indexMapping[i];
615             User memory user = userRoundMapping[rid][userAddr];
616             if (user.freezeAmount >= 1*ethWei) {
617                 uint scale = getScByLevel(user.staticLevel);
618                 calUserDynamicProfit(user.referrer, user.freezeAmount, scale);
619             }
620             calStaticProfitInner(userAddr);
621         }
622     }
623 
624     function registerUserInfo(address user, string calldata inviteCode, string calldata referrer) external onlyOwner {
625         registerUser(user, inviteCode, referrer);
626     }
627 
628     function calUserDynamicProfit(string memory referrer, uint money, uint shareSc) private {
629         string memory tmpReferrer = referrer;
630         
631         for (uint i = 1; i <= 30; i++) {
632             if (compareStr(tmpReferrer, "")) {
633                 break;
634             }
635             address tmpUserAddr = addressMapping[tmpReferrer];
636             User storage calUser = userRoundMapping[rid][tmpUserAddr];
637             
638             uint fireSc = getFireScByLevel(calUser.dynamicLevel);
639             uint recommendSc = getRecommendScaleByLevelAndTim(calUser.dynamicLevel, i);
640             uint moneyResult = 0;
641             if (money <= calUser.freezeAmount.add(calUser.unlockAmount)) {
642                 moneyResult = money;
643             } else {
644                 moneyResult = calUser.freezeAmount.add(calUser.unlockAmount);
645             }
646             
647             if (recommendSc != 0) {
648                 uint tmpDynamicAmount = moneyResult.mul(shareSc).mul(fireSc).mul(recommendSc);
649                 tmpDynamicAmount = tmpDynamicAmount.div(1000).div(10).div(100);
650 
651                 tmpDynamicAmount = tmpDynamicAmount.mul(coefficient).div(10);
652                 calUser.allDynamicAmount = calUser.allDynamicAmount.add(tmpDynamicAmount);
653                 calUser.hisDynamicAmount = calUser.hisDynamicAmount.add(tmpDynamicAmount);
654             }
655 
656             tmpReferrer = calUser.referrer;
657         }
658     }
659 
660     function redeem()
661         public
662         isHuman()
663     {
664         require(gameStart(), "game not start");
665         User storage user = userRoundMapping[rid][msg.sender];
666         require(user.id > 0, "user not exist");
667 
668         calStaticProfitInner(msg.sender);
669 
670         uint sendMoney = user.unlockAmount;
671 
672         bool isEnough = false;
673         uint resultMoney = 0;
674 
675         (isEnough, resultMoney) = isEnoughBalance(sendMoney);
676         if (resultMoney > 0) {
677             sendMoneyToUser(msg.sender, resultMoney);
678             user.unlockAmount = 0;
679             user.staticLevel = getLevel(user.freezeAmount);
680             user.dynamicLevel = getLineLevel(user.freezeAmount);
681 
682             emit LogRedeem(msg.sender, user.id, resultMoney, now);
683         }
684 
685         if (user.reInvestCount < 12) {
686             user.reInvestCount = 0;
687         }
688 
689         if (!isEnough) {
690             endRound();
691         }
692     }
693 
694     function endRound() private {
695         rid++;
696         startTime = now.add(period).div(1 days).mul(1 days);
697         coefficient = 10;
698     }
699 
700     function isUsed(string memory code) public view returns(bool) {
701         address user = getUserAddressByCode(code);
702         return uint(user) != 0;
703     }
704 
705     function getUserAddressByCode(string memory code) public view returns(address) {
706         return addressMapping[code];
707     }
708 
709     function sendFeetoAdmin(uint amount) private {
710         devAddr.transfer(amount.mul(4).div(100));
711         follow.transfer(amount.mul(5).div(1000));
712     }
713 
714     function getGameInfo() public isHuman() view returns(uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
715         return (
716             rid,
717             uid,
718             startTime,
719             investCount,
720             investMoney,
721             rInvestCount[rid],
722             rInvestMoney[rid],
723             coefficient,
724             rInfo[rid].luckPort,
725             rInfo[rid].specialUsers.length
726         );
727     }
728 
729     function getUserInfo(address user, uint roundId, uint i) public isHuman() view returns(
730         uint[17] memory ct, string memory inviteCode, string memory referrer
731     ) {
732 
733         if(roundId == 0){
734             roundId = rid;
735         }
736 
737         User memory userInfo = userRoundMapping[roundId][user];
738 
739         ct[0] = userInfo.id;
740         ct[1] = userInfo.staticLevel;
741         ct[2] = userInfo.dynamicLevel;
742         ct[3] = userInfo.allInvest;
743         ct[4] = userInfo.freezeAmount;
744         ct[5] = userInfo.unlockAmount;
745         ct[6] = userInfo.allStaticAmount;
746         ct[7] = userInfo.allDynamicAmount;
747         ct[8] = userInfo.hisStaticAmount;
748         ct[9] = userInfo.hisDynamicAmount;
749         ct[10] = userInfo.inviteAmount;
750         ct[11] = userInfo.reInvestCount;
751         ct[12] = userInfo.staticFlag;
752         ct[13] = userInfo.invests.length;
753         if (ct[13] != 0) {
754             ct[14] = userInfo.invests[i].investAmount;
755             ct[15] = userInfo.invests[i].investTime;
756             ct[16] = userInfo.invests[i].times;
757         } else {
758             ct[14] = 0;
759             ct[15] = 0;
760             ct[16] = 0;
761         }
762         
763 
764         inviteCode = userMapping[user].inviteCode;
765         referrer = userMapping[user].referrer;
766 
767         return (
768             ct,
769             inviteCode,
770             referrer
771         );
772     }
773 
774     function getSpecialUser(uint _rid, uint i) public view returns(address) {
775         return rInfo[_rid].specialUsers[i];
776     }
777 
778     function getLatestUnlockAmount(address userAddr) public view returns(uint)
779     {
780         User memory user = userRoundMapping[rid][userAddr];
781         uint allUnlock = user.unlockAmount;
782         for (uint i = user.staticFlag; i < user.invests.length; i++) {
783             Invest memory invest = user.invests[i];
784             uint unlockDay = now.sub(invest.investTime).div(1 days);
785 
786             if (unlockDay >= 5) {
787                 allUnlock = allUnlock.add(invest.investAmount);
788             }
789         }
790         return allUnlock;
791     }
792 
793     function registerUser(address user, string memory inviteCode, string memory referrer) private {
794         UserGlobal storage userGlobal = userMapping[user];
795         uid++;
796         userGlobal.id = uid;
797         userGlobal.userAddress = user;
798         userGlobal.inviteCode = inviteCode;
799         userGlobal.referrer = referrer;
800 
801         addressMapping[inviteCode] = user;
802         indexMapping[uid] = user;
803     }
804 }
805 
806 /**
807  * @title SafeMath
808  * @dev Math operations with safety checks that revert on error
809  */
810 library SafeMath {
811 
812     /**
813     * @dev Multiplies two numbers, reverts on overflow.
814     */
815     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
816         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
817         // benefit is lost if 'b' is also tested.
818         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
819         if (a == 0) {
820             return 0;
821         }
822 
823         uint256 c = a * b;
824         require(c / a == b, "mul overflow");
825 
826         return c;
827     }
828 
829     /**
830     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
831     */
832     function div(uint256 a, uint256 b) internal pure returns (uint256) {
833         require(b > 0, "div zero"); // Solidity only automatically asserts when dividing by 0
834         uint256 c = a / b;
835         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
836 
837         return c;
838     }
839 
840     /**
841     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
842     */
843     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
844         require(b <= a, "lower sub bigger");
845         uint256 c = a - b;
846 
847         return c;
848     }
849 
850     /**
851     * @dev Adds two numbers, reverts on overflow.
852     */
853     function add(uint256 a, uint256 b) internal pure returns (uint256) {
854         uint256 c = a + b;
855         require(c >= a, "overflow");
856 
857         return c;
858     }
859 
860     /**
861     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
862     * reverts when dividing by zero.
863     */
864     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
865         require(b != 0, "mod zero");
866         return a % b;
867     }
868 }