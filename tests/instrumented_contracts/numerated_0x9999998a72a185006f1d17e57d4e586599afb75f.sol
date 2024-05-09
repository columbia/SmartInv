1 pragma solidity ^0.5.0;
2 
3 contract UtilFairWin {
4     uint ethWei = 1 ether;
5 
6     function getLevel(uint value) public view returns(uint) {
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
19     function getLineLevel(uint value) public view returns(uint) {
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
32     function getScByLevel(uint level) public pure returns(uint) {
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
45     function getFireScByLevel(uint level) public pure returns(uint) {
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
58     function getRecommendScaleByLevelAndTim(uint level,uint times) public pure returns(uint){
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
91     function compareStr(string memory _str, string memory str) public pure returns(bool) {
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
283 contract HyperFair is UtilFairWin, WhitelistAdminRole {
284 
285     using SafeMath for *;
286 
287     string constant private name = "HyperFair Official";
288 
289     uint ethWei = 1 ether;
290 
291     address payable private devAddr = address(0x0E605b87ad99F9D5515badfF8e228cF2238AD29f);
292 
293     struct User{
294         uint id;
295         address userAddress;
296         string inviteCode;
297         string referrer;
298         uint staticLevel;
299         uint dynamicLevel;
300         uint allInvest;
301         uint freezeAmount;
302         uint unlockAmount;
303         uint allStaticAmount;
304         uint allDynamicAmount;
305         uint hisStaticAmount;
306         uint hisDynamicAmount;
307         Invest[] invests;
308         uint staticFlag;
309     }
310 
311     struct UserGlobal {
312         uint id;
313         address userAddress;
314         string inviteCode;
315         string referrer;
316     }
317 
318     struct Invest{
319         address userAddress;
320         uint investAmount;
321         uint investTime;
322         uint times;
323     }
324 
325     string constant systemCode = "99999999";
326     uint coefficient = 10;
327     uint startTime;
328     uint investCount = 0;
329     mapping(uint => uint) rInvestCount;
330     uint investMoney = 0;
331     mapping(uint => uint) rInvestMoney;
332     uint uid = 0;
333     uint rid = 1;
334     uint period = 3 days;
335     mapping (uint => mapping(address => User)) userRoundMapping;
336     mapping(address => UserGlobal) userMapping;
337     mapping (string => address) addressMapping;
338     mapping (uint => address) public indexMapping;
339 
340 
341     modifier isHuman() {
342         address addr = msg.sender;
343         uint codeLength;
344 
345         assembly {codeLength := extcodesize(addr)}
346         require(codeLength == 0, "sorry humans only");
347         require(tx.origin == msg.sender, "sorry, human only");
348         _;
349     }
350 
351     event LogInvestIn(address indexed who, uint indexed uid, uint amount, uint time, string inviteCode, string referrer);
352     event LogWithdrawProfit(address indexed who, uint indexed uid, uint amount, uint time);
353     event LogRedeem(address indexed who, uint indexed uid, uint amount, uint now);
354 
355     
356     constructor () public {
357     }
358 
359     function () external payable {
360     }
361 
362     function activeGame(uint time) external onlyWhitelistAdmin
363     {
364         require(time > now, "invalid game start time");
365         startTime = time;
366     }
367 
368     function setCoefficient(uint coeff) external onlyWhitelistAdmin
369     {
370         require(coeff > 0, "invalid coeff");
371         coefficient = coeff;
372     }
373 
374     function gameStart() public view returns(bool) {
375         return startTime != 0 && now > startTime;
376     }
377 
378     function investIn(string memory inviteCode, string memory referrer)
379         public
380         isHuman()
381         payable
382     {
383         require(gameStart(), "game not start");
384         require(msg.value >= 1*ethWei && msg.value <= 15*ethWei, "between 1 and 15");
385         require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");
386 
387         UserGlobal storage userGlobal = userMapping[msg.sender];
388         if (userGlobal.id == 0) {
389             require(!compareStr(inviteCode, ""), "empty invite code");
390             address referrerAddr = getUserAddressByCode(referrer);
391             require(uint(referrerAddr) != 0, "referer not exist");
392             require(referrerAddr != msg.sender, "referrer can't be self");
393             
394             require(!isUsed(inviteCode), "invite code is used");
395 
396             registerUser(msg.sender, inviteCode, referrer);
397         }
398 
399         User storage user = userRoundMapping[rid][msg.sender];
400         if (uint(user.userAddress) != 0) {
401             require(user.freezeAmount.add(msg.value) <= 15*ethWei, "can not beyond 15 eth");
402             user.allInvest = user.allInvest.add(msg.value);
403             user.freezeAmount = user.freezeAmount.add(msg.value);
404             user.staticLevel = getLevel(user.freezeAmount);
405             user.dynamicLevel = getLineLevel(user.freezeAmount.add(user.unlockAmount));
406         } else {
407             user.id = userGlobal.id;
408             user.userAddress = msg.sender;
409             user.freezeAmount = msg.value;
410             user.staticLevel = getLevel(msg.value);
411             user.allInvest = msg.value;
412             user.dynamicLevel = getLineLevel(msg.value);
413             user.inviteCode = userGlobal.inviteCode;
414             user.referrer = userGlobal.referrer;
415         }
416 
417         Invest memory invest = Invest(msg.sender, msg.value, now, 0);
418         user.invests.push(invest);
419 
420         investCount = investCount.add(1);
421         investMoney = investMoney.add(msg.value);
422         rInvestCount[rid] = rInvestCount[rid].add(1);
423         rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
424 
425         sendFeetoAdmin(msg.value);
426         emit LogInvestIn(msg.sender, userGlobal.id, msg.value, now, userGlobal.inviteCode, userGlobal.referrer);
427     }
428 
429     function withdrawProfit()
430         public
431         isHuman()
432     {
433         require(gameStart(), "game not start");
434         User storage user = userRoundMapping[rid][msg.sender];
435         uint sendMoney = user.allStaticAmount.add(user.allDynamicAmount);
436 
437         bool isEnough = false;
438         uint resultMoney = 0;
439         (isEnough, resultMoney) = isEnoughBalance(sendMoney);
440         if (!isEnough) {
441             endRound();
442         }
443 
444         if (resultMoney > 0) {
445             sendMoneyToUser(msg.sender, resultMoney);
446             user.allStaticAmount = 0;
447             user.allDynamicAmount = 0;
448             emit LogWithdrawProfit(msg.sender, user.id, resultMoney, now);
449         }
450     }
451 
452     function isEnoughBalance(uint sendMoney) private view returns (bool, uint){
453         if (sendMoney >= address(this).balance) {
454             return (false, address(this).balance);
455         } else {
456             return (true, sendMoney);
457         }
458     }
459 
460     function sendMoneyToUser(address payable userAddress, uint money) private {
461         userAddress.transfer(money);
462     }
463 
464     function calStaticProfit(address userAddr) external onlyWhitelistAdmin returns(uint)
465     {
466         return calStaticProfitInner(userAddr);
467     }
468 
469     function calStaticProfitInner(address userAddr) private returns(uint)
470     {
471         User storage user = userRoundMapping[rid][userAddr];
472         if (user.id == 0) {
473             return 0;
474         }
475 
476         uint scale = getScByLevel(user.staticLevel);
477         uint allStatic = 0;
478         for (uint i = user.staticFlag; i < user.invests.length; i++) {
479             Invest storage invest = user.invests[i];
480             uint startDay = invest.investTime.sub(8 hours).div(1 days).mul(1 days);
481             uint staticGaps = now.sub(8 hours).sub(startDay).div(1 days);
482 
483             uint unlockDay = now.sub(invest.investTime).div(1 days);
484 
485             if(staticGaps > 5){
486                 staticGaps = 5;
487             }
488             if (staticGaps > invest.times) {
489                 allStatic += staticGaps.sub(invest.times).mul(scale).mul(invest.investAmount).div(1000);
490                 invest.times = staticGaps;
491             }
492 
493             if (unlockDay >= 5) {
494                 user.staticFlag++;
495                 user.freezeAmount = user.freezeAmount.sub(invest.investAmount);
496                 user.unlockAmount = user.unlockAmount.add(invest.investAmount);
497                 user.staticLevel = getLevel(user.freezeAmount);
498             }
499 
500         }
501         allStatic = allStatic.mul(coefficient).div(10);
502         user.allStaticAmount = user.allStaticAmount.add(allStatic);
503         user.hisStaticAmount = user.hisStaticAmount.add(allStatic);
504         userRoundMapping[rid][userAddr] = user;
505         return user.allStaticAmount;
506     }
507 
508     function calDynamicProfit(uint start, uint end) external onlyWhitelistAdmin {
509         for (uint i = start; i <= end; i++) {
510             address userAddr = indexMapping[i];
511             User memory user = userRoundMapping[rid][userAddr];
512             calStaticProfitInner(userAddr);
513             if (user.freezeAmount >= 1*ethWei) {
514                 uint scale = getScByLevel(user.staticLevel);
515                 calUserDynamicProfit(user.referrer, user.freezeAmount, scale);
516             }
517         }
518     }
519 
520     function registerUserInfo(address user, string calldata inviteCode, string calldata referrer) external onlyOwner {
521         registerUser(user, inviteCode, referrer);
522     }
523 
524     function calUserDynamicProfit(string memory referrer, uint money, uint shareSc) private {
525         string memory tmpReferrer = referrer;
526         
527         for (uint i = 1; i <= 30; i++) {
528             if (compareStr(tmpReferrer, "")) {
529                 break;
530             }
531             address tmpUserAddr = addressMapping[tmpReferrer];
532             User storage calUser = userRoundMapping[rid][tmpUserAddr];
533             
534             uint fireSc = getFireScByLevel(calUser.staticLevel);
535             uint recommendSc = getRecommendScaleByLevelAndTim(calUser.dynamicLevel, i);
536             uint moneyResult = 0;
537             if (money <= calUser.freezeAmount.add(calUser.unlockAmount)) {
538                 moneyResult = money;
539             } else {
540                 moneyResult = calUser.freezeAmount.add(calUser.unlockAmount);
541             }
542             
543             if (recommendSc != 0) {
544                 uint tmpDynamicAmount = moneyResult.mul(shareSc).mul(fireSc).mul(recommendSc);
545                 tmpDynamicAmount = tmpDynamicAmount.div(1000).div(10).div(100);
546 
547                 tmpDynamicAmount = tmpDynamicAmount.mul(coefficient).div(10);
548                 calUser.allDynamicAmount = calUser.allDynamicAmount.add(tmpDynamicAmount);
549                 calUser.hisDynamicAmount = calUser.hisDynamicAmount.add(tmpDynamicAmount);
550             }
551 
552             tmpReferrer = calUser.referrer;
553         }
554     }
555 
556     function redeem()
557         public
558         isHuman()
559     {
560         require(gameStart(), "game not start");
561         User storage user = userRoundMapping[rid][msg.sender];
562         require(user.id > 0, "user not exist");
563 
564         calStaticProfitInner(msg.sender);
565 
566         uint sendMoney = user.unlockAmount;
567 
568         bool isEnough = false;
569         uint resultMoney = 0;
570 
571         (isEnough, resultMoney) = isEnoughBalance(sendMoney);
572 
573         if (!isEnough) {
574             endRound();
575         }
576 
577         if (resultMoney > 0) {
578             sendMoneyToUser(msg.sender, resultMoney);
579             user.unlockAmount = 0;
580             user.staticLevel = getLevel(user.freezeAmount);
581             user.dynamicLevel = getLineLevel(user.freezeAmount);
582 
583             emit LogRedeem(msg.sender, user.id, resultMoney, now);
584         }
585     }
586 
587     function endRound() private {
588         rid++;
589         startTime = now.add(period).div(1 days).mul(1 days);
590         coefficient = 10;
591     }
592 
593     function isUsed(string memory code) public view returns(bool) {
594         address user = getUserAddressByCode(code);
595         return uint(user) != 0;
596     }
597 
598     function getUserAddressByCode(string memory code) public view returns(address) {
599         return addressMapping[code];
600     }
601 
602     function sendFeetoAdmin(uint amount) private {
603         devAddr.transfer(amount.div(25));
604     }
605 
606     function getGameInfo() public isHuman() view returns(uint, uint, uint, uint, uint, uint, uint, uint) {
607         return (
608             rid,
609             uid,
610             startTime,
611             investCount,
612             investMoney,
613             rInvestCount[rid],
614             rInvestMoney[rid],
615             coefficient
616         );
617     }
618 
619     function getUserInfo(address user, uint roundId) public isHuman() view returns(
620         uint[10] memory ct, string memory inviteCode, string memory referrer
621     ) {
622 
623         if(roundId == 0){
624             roundId = rid;
625         }
626 
627         User memory userInfo = userRoundMapping[roundId][user];
628 
629         ct[0] = userInfo.id;
630         ct[1] = userInfo.staticLevel;
631         ct[2] = userInfo.dynamicLevel;
632         ct[3] = userInfo.allInvest;
633         ct[4] = userInfo.freezeAmount;
634         ct[5] = userInfo.unlockAmount;
635         ct[6] = userInfo.allStaticAmount;
636         ct[7] = userInfo.allDynamicAmount;
637         ct[8] = userInfo.hisStaticAmount;
638         ct[9] = userInfo.hisDynamicAmount;
639 
640         inviteCode = userInfo.inviteCode;
641         referrer = userInfo.referrer;
642 
643         return (
644             ct,
645             inviteCode,
646             referrer
647         );
648     }
649 
650     function getUserById(uint id) public view returns(address){
651         return indexMapping[id];
652     }
653 
654     function getLatestUnlockAmount(address userAddr) public view returns(uint)
655     {
656         User memory user = userRoundMapping[rid][userAddr];
657         uint allUnlock = user.unlockAmount;
658         for (uint i = user.staticFlag; i < user.invests.length; i++) {
659             Invest memory invest = user.invests[i];
660             uint unlockDay = now.sub(invest.investTime).div(1 days);
661 
662             if (unlockDay >= 5) {
663                 allUnlock = allUnlock.add(invest.investAmount);
664             }
665         }
666         return allUnlock;
667     }
668 
669     function registerUser(address user, string memory inviteCode, string memory referrer) private {
670         UserGlobal storage userGlobal = userMapping[user];
671         uid++;
672         userGlobal.id = uid;
673         userGlobal.userAddress = user;
674         userGlobal.inviteCode = inviteCode;
675         userGlobal.referrer = referrer;
676 
677         addressMapping[inviteCode] = user;
678         indexMapping[uid] = user;
679     }
680 }
681 
682 /**
683  * @title SafeMath
684  * @dev Math operations with safety checks that revert on error
685  */
686 library SafeMath {
687 
688     /**
689     * @dev Multiplies two numbers, reverts on overflow.
690     */
691     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
692         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
693         // benefit is lost if 'b' is also tested.
694         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
695         if (a == 0) {
696             return 0;
697         }
698 
699         uint256 c = a * b;
700         require(c / a == b, "mul overflow");
701 
702         return c;
703     }
704 
705     /**
706     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
707     */
708     function div(uint256 a, uint256 b) internal pure returns (uint256) {
709         require(b > 0, "div zero"); // Solidity only automatically asserts when dividing by 0
710         uint256 c = a / b;
711         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
712 
713         return c;
714     }
715 
716     /**
717     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
718     */
719     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
720         require(b <= a, "lower sub bigger");
721         uint256 c = a - b;
722 
723         return c;
724     }
725 
726     /**
727     * @dev Adds two numbers, reverts on overflow.
728     */
729     function add(uint256 a, uint256 b) internal pure returns (uint256) {
730         uint256 c = a + b;
731         require(c >= a, "overflow");
732 
733         return c;
734     }
735 
736     /**
737     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
738     * reverts when dividing by zero.
739     */
740     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
741         require(b != 0, "mod zero");
742         return a % b;
743     }
744 }