1 pragma solidity ^0.5.0;
2 
3     contract UtilFast2Win {
4         using SafeMath for uint;
5         uint ETH = 1 ether;
6 
7         //Membership Grade
8         function getLevel(uint value) internal view returns(uint) {
9             if (value >= 1*ETH && value <= 5*ETH) {
10                 return 1; //low
11             }
12             if (value >= 6*ETH && value <= 10*ETH) {
13                 return 2; //medium
14             }
15             if (value >= 11*ETH && value <= 15*ETH) {
16                 return 3; //high
17             }
18             return 0;
19         }
20         //dynamic level
21         function getLineLevel(uint value) internal view returns(uint) {
22             if (value >= 1*ETH && value <= 5*ETH) {
23                 return 1;
24             }
25             if (value >= 6*ETH && value <= 10*ETH) {
26                 return 2;
27             }
28             if (value >= 11*ETH) {
29                 return 3;
30             }
31             return 0;
32         }
33         //static dividend everyday gain
34         function getScByLevel(uint level, uint reInvestCount) internal pure returns(uint) {
35             uint reInvestBouns = reInvestCount.mul(5);
36             if (level == 1) {
37                 return reInvestBouns.add(10);
38             }
39             if (level == 2) {
40                 return reInvestBouns.add(15);
41             }
42             if (level == 3) {
43                 return reInvestBouns.add(20);
44             }
45             return 0;
46         }
47         //reward burn if self level < refer level
48         function getBurnByLevel(uint level) internal pure returns(uint) {
49             if (level == 1) {
50                 return 3;
51             }
52             if (level == 2) {
53                 return 6;
54             }
55             if (level == 3) {
56                 return 10;
57             }
58             return 0;
59         }
60         //dynamic generation percent
61         function getRecommendScaleByLevelAndTim(uint level,uint times) internal pure returns(uint){
62             if (level == 1 && times == 1) {
63                 return 50;
64             }
65             if (level == 2 && times == 1) {
66                 return 70;
67             }
68             if (level == 2 && times == 2) {
69                 return 50;
70             }
71             if (level == 3) {
72                 if(times == 1){
73                     return 100;
74                 }
75                 if (times == 2) {
76                     return 70;
77                 }
78                 if (times == 3) {
79                     return 50;
80                 }
81                 if (times >= 4 && times <= 10) {
82                     return 10;
83                 }
84                 if (times >= 11 && times <= 20) {
85                     return 5;
86                 }
87                 if (times >= 21) {
88                     return 1;
89                 }
90             }
91             return 0;
92         }
93 
94         function compareStr(string memory _str, string memory str) internal pure returns(bool) {
95             if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
96                 return true;
97             }
98             return false;
99         }
100     }
101 
102     /*
103      * @dev Provides information about the current execution context, including the
104      * sender of the transaction and its data. While these are generally available
105      * via msg.sender and msg.data, they should not be accessed in such a direct
106      * manner, since when dealing with GSN meta-transactions the account sending and
107      * paying for execution may not be the actual sender (as far as an application
108      * is concerned).
109      *
110      * This contract is only required for intermediate, library-like contracts.
111      */
112     contract Context {
113         // Empty internal constructor, to prevent people from mistakenly deploying
114         // an instance of this contract, which should be used via inheritance.
115         constructor() internal {}
116         // solhint-disable-previous-line no-empty-blocks
117 
118         function _msgSender() internal view returns (address) {
119             return msg.sender;
120         }
121 
122         function _msgData() internal view returns (bytes memory) {
123             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
124             return msg.data;
125         }
126     }
127 
128     /**
129      * @dev Contract module which provides a basic access control mechanism, where
130      * there is an account (an owner) that can be granted exclusive access to
131      * specific functions.
132      *
133      * This module is used through inheritance. It will make available the modifier
134      * `onlyOwner`, which can be applied to your functions to restrict their use to
135      * the owner.
136      */
137     contract Ownable is Context {
138         address private _owner;
139 
140         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142         /**
143          * @dev Initializes the contract setting the deployer as the initial owner.
144          */
145         constructor () internal {
146             _owner = _msgSender();
147             emit OwnershipTransferred(address(0), _owner);
148         }
149 
150         /**
151          * @dev Returns the address of the current owner.
152          */
153         function owner() public view returns (address) {
154             return _owner;
155         }
156 
157         /**
158          * @dev Throws if called by any account other than the owner.
159          */
160         modifier onlyOwner() {
161             require(isOwner(), "Ownable: caller is not the owner");
162             _;
163         }
164 
165         /**
166          * @dev Returns true if the caller is the current owner.
167          */
168         function isOwner() public view returns (bool) {
169             return _msgSender() == _owner;
170         }
171 
172         /**
173          * @dev Leaves the contract without owner. It will not be possible to call
174          * `onlyOwner` functions anymore. Can only be called by the current owner.
175          *
176          * NOTE: Renouncing ownership will leave the contract without an owner,
177          * thereby removing any functionality that is only available to the owner.
178          */
179         function renounceOwnership() public onlyOwner {
180             emit OwnershipTransferred(_owner, address(0));
181             _owner = address(0);
182         }
183 
184         /**
185          * @dev Transfers ownership of the contract to a new account (`newOwner`).
186          * Can only be called by the current owner.
187          */
188         function transferOwnership(address newOwner) public onlyOwner {
189             _transferOwnership(newOwner);
190         }
191 
192         /**
193          * @dev Transfers ownership of the contract to a new account (`newOwner`).
194          */
195         function _transferOwnership(address newOwner) internal {
196             require(newOwner != address(0), "Ownable: new owner is the zero address");
197             emit OwnershipTransferred(_owner, newOwner);
198             _owner = newOwner;
199         }
200     }
201 
202     /**
203      * @title Roles
204      * @dev Library for managing addresses assigned to a Role.
205      */
206     library Roles {
207         struct Role {
208             mapping (address => bool) bearer;
209         }
210 
211         /**
212          * @dev Give an account access to this role.
213          */
214         function add(Role storage role, address account) internal {
215             require(!has(role, account), "Roles: account already has role");
216             role.bearer[account] = true;
217         }
218 
219         /**
220          * @dev Remove an account's access to this role.
221          */
222         function remove(Role storage role, address account) internal {
223             require(has(role, account), "Roles: account does not have role");
224             role.bearer[account] = false;
225         }
226 
227         /**
228          * @dev Check if an account has this role.
229          * @return bool
230          */
231         function has(Role storage role, address account) internal view returns (bool) {
232             require(account != address(0), "Roles: account is the zero address");
233             return role.bearer[account];
234         }
235     }
236 
237     /**
238      * @title WhitelistAdminRole
239      * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
240      */
241     contract WhitelistAdminRole is Context, Ownable {
242         using Roles for Roles.Role;
243 
244         event WhitelistAdminAdded(address indexed account);
245         event WhitelistAdminRemoved(address indexed account);
246 
247         Roles.Role private _whitelistAdmins;
248 
249         constructor () internal {
250             _addWhitelistAdmin(_msgSender());
251         }
252 
253         modifier onlyWhitelistAdmin() {
254             require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
255             _;
256         }
257 
258         function isWhitelistAdmin(address account) public view returns (bool) {
259             return _whitelistAdmins.has(account);
260         }
261 
262         function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
263             _addWhitelistAdmin(account);
264         }
265 
266         function removeWhitelistAdmin(address account) public onlyOwner {
267             _whitelistAdmins.remove(account);
268             emit WhitelistAdminRemoved(account);
269         }
270 
271         function renounceWhitelistAdmin() public {
272             _removeWhitelistAdmin(_msgSender());
273         }
274 
275         function _addWhitelistAdmin(address account) internal {
276             _whitelistAdmins.add(account);
277             emit WhitelistAdminAdded(account);
278         }
279 
280         function _removeWhitelistAdmin(address account) internal {
281             _whitelistAdmins.remove(account);
282             emit WhitelistAdminRemoved(account);
283         }
284     }
285 
286     contract Fast2Win is UtilFast2Win, WhitelistAdminRole {
287 
288         using SafeMath for uint;
289 
290         string constant private name = "fast2win foundation";
291 
292         uint ETH = 1 ether;
293 
294         address payable private devAddr;//admin fee pool
295         address payable private savingAddr;//savior pool
296         address payable private follow;//follower pool
297 
298         struct User{
299             uint id;
300             address userAddress;
301             uint refId;
302             uint staticLevel;
303             uint dynamicLevel;
304             uint allInvest;
305             uint freezeAmount;
306             uint unlockAmount;
307             uint allStaticAmount;
308             uint allDynamicAmount;
309             uint hisStaticAmount;
310             uint hisDynamicAmount;
311             uint inviteAmount;
312             uint reInvestCount;
313             uint lastReInvestTime;
314             Invest[] invests;
315             uint staticFlag;
316         }
317 
318         struct GameInfo {
319             uint luckPort;
320             address[] specialUsers;
321         }
322 
323         struct UserGlobal {
324             uint id;
325             address userAddress;
326             uint refId;
327         }
328 
329         struct Invest{
330             address userAddress;
331             uint investAmount;
332             uint investTime;
333             uint times;
334         }
335 
336         uint coefficient = 10;
337         uint startTime;
338         uint investCount = 0;
339         mapping(uint => uint) rInvestCount;
340         uint investMoney = 0;
341         mapping(uint => uint) rInvestMoney;
342         mapping(uint => GameInfo) rInfo;
343         uint uid = 0;
344         uint rid = 1;
345         uint constant private PERIOD = 1 days;//1 days
346         uint constant private restTime = 2*PERIOD;
347         uint constant private HOURS = 1 hours;//1 hours
348         uint checkInCount = 0;
349         mapping (uint => mapping(address => User)) userRoundMapping;
350         mapping(address => UserGlobal) public userMapping;
351         mapping (uint => address) public indexMapping;
352 
353         /**
354          * @dev Just a simply check to prevent contract
355          * @dev this by calling method in constructor.
356          */
357         modifier isHuman() {
358             address addr = msg.sender;
359             uint codeLength;
360 
361             assembly {codeLength := extcodesize(addr)}
362             require(codeLength == 0, "sorry humans only");
363             require(tx.origin == msg.sender, "sorry, human only");
364             _;
365         }
366 
367         event LogInvestIn(address indexed who, uint indexed uid, uint amount, uint time, uint refId, uint typeFlag);
368         event LogWithdrawProfit(address indexed who, uint indexed uid, uint amount, uint time);
369         event LogRedeem(address indexed who, uint indexed uid, uint amount, uint now);
370         event RegisterUser(address indexed who, uint indexed uid, uint refId, uint now);
371 
372         //==============================================================================
373         // Constructor
374         //==============================================================================
375         constructor (address _devAddr, address _savingAddr, address _follow) public {
376             devAddr = address(uint160(_devAddr));
377             savingAddr = address(uint160(_savingAddr));
378             follow = address(uint160(_follow));
379 
380             //register owner
381             address _msgSender = msg.sender;
382             UserGlobal storage userGlobal = userMapping[_msgSender];
383             userGlobal.id = uid;
384             userGlobal.userAddress = _msgSender;
385             userGlobal.refId = uid;
386             indexMapping[uid] = _msgSender;
387         }
388 
389         function () external payable {
390         }
391 
392         function activeGame(uint time) external onlyWhitelistAdmin
393         {
394             require(time > now, "invalid game start time");
395             startTime = time;
396         }
397 
398         function setCoefficient(uint coeff) external onlyWhitelistAdmin
399         {
400             require(coeff > 0, "invalid coeff");
401             coefficient = coeff;
402         }
403 
404         function gameStart() private view returns(bool) {
405             return startTime != 0 && now > startTime;
406         }
407 
408         function viewNow() public view onlyWhitelistAdmin returns(uint) {
409             return now;
410         }
411 
412         function investIn(uint refId)
413             public
414             isHuman()
415             payable
416         {
417             require(gameStart(), "game not start");
418             require(msg.value >= 1*ETH && msg.value <= 15*ETH, "between 1 and 15");
419             require(msg.value == msg.value.div(ETH).mul(ETH), "invalid msg value");
420 
421             registerUser(msg.sender, refId);
422             UserGlobal storage userGlobal = userMapping[msg.sender];
423             User storage user = userRoundMapping[rid][msg.sender];
424             if (uint(user.userAddress) != 0) {
425                 require(user.freezeAmount.add(msg.value) <= 15*ETH, "can not beyond 15 eth");
426                 user.allInvest = user.allInvest.add(msg.value);
427                 user.freezeAmount = user.freezeAmount.add(msg.value);
428                 user.staticLevel = getLevel(user.freezeAmount);
429                 user.dynamicLevel = getLineLevel(user.freezeAmount.add(user.unlockAmount));
430             } else {
431                 //no invest this round
432                 user.id = userGlobal.id;
433                 user.userAddress = msg.sender;
434                 user.freezeAmount = msg.value;
435                 user.staticLevel = getLevel(msg.value);
436                 user.allInvest = msg.value;
437                 user.dynamicLevel = getLineLevel(msg.value);
438                 user.refId = userGlobal.refId;
439 
440                 if (refId != 0 && userGlobal.refId == refId) {
441                     address refIdAddr = getUserAddressByCode(userGlobal.refId);
442                     userRoundMapping[rid][refIdAddr].inviteAmount++;
443                 }
444             }
445 
446             Invest memory invest = Invest(msg.sender, msg.value, now, 0);
447             user.invests.push(invest);
448 
449             if (rInvestMoney[rid] != 0 && (rInvestMoney[rid].div(10000).div(ETH) != rInvestMoney[rid].add(msg.value).div(10000).div(ETH))) {
450                 bool isEnough;
451                 uint sendMoney;
452                 (isEnough, sendMoney) = isEnoughBalance(rInfo[rid].luckPort);
453                 if (sendMoney > 0) {
454                     sendMoneyToUser(msg.sender, sendMoney);
455                 }
456                 rInfo[rid].luckPort = 0;
457                 if (!isEnough) {
458                     endRound();
459                     return;
460                 }
461             }
462 
463             investCount = investCount.add(1);
464             investMoney = investMoney.add(msg.value);
465             rInvestCount[rid] = rInvestCount[rid].add(1);
466             rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
467             rInfo[rid].luckPort = rInfo[rid].luckPort.add(msg.value.mul(2).div(1000));//lucky
468 
469             sendFeetoAdmin(msg.value);
470             emit LogInvestIn(msg.sender, userGlobal.id, msg.value, now, userGlobal.refId, 0);
471         }
472 
473 
474         function reInvestIn() public {
475             require(gameStart(), "game not start");
476             User storage user = userRoundMapping[rid][msg.sender];
477             require(user.id > 0, "user haven't invest in round before");
478             calStaticProfitInner(msg.sender);
479 
480             uint reInvestAmount = user.unlockAmount;
481             if (user.freezeAmount > 15*ETH) {
482                 user.freezeAmount = 15*ETH;
483             }
484             if (user.freezeAmount.add(reInvestAmount) > 15*ETH) {
485                 reInvestAmount = (15*ETH).sub(user.freezeAmount);
486             }
487 
488             if (reInvestAmount == 0) {
489                 return;
490             }
491 
492             uint leastAmount = reInvestAmount.mul(47).div(1000);
493             bool isEnough;
494             uint sendMoney;
495             (isEnough, sendMoney) = isEnoughBalance(leastAmount);
496             if (!isEnough) {
497                 if (sendMoney > 0) {
498                     sendMoneyToUser(msg.sender, sendMoney);
499                 }
500                 endRound();
501                 return;
502             }
503 
504             user.unlockAmount = user.unlockAmount.sub(reInvestAmount);
505             user.allInvest = user.allInvest.add(reInvestAmount);
506             user.freezeAmount = user.freezeAmount.add(reInvestAmount);
507             user.staticLevel = getLevel(user.freezeAmount);
508             user.dynamicLevel = getLineLevel(user.freezeAmount.add(user.unlockAmount));
509             if ((now - user.lastReInvestTime) > 5*PERIOD) {
510                 user.reInvestCount = user.reInvestCount.add(1);
511                 user.lastReInvestTime = now;
512             }
513 
514             if (user.reInvestCount == 5) {
515                 rInfo[rid].specialUsers.push(msg.sender);
516             }
517 
518             Invest memory invest = Invest(msg.sender, reInvestAmount, now, 0);
519             user.invests.push(invest);
520 
521             if (rInvestMoney[rid] != 0 && (rInvestMoney[rid].div(10000).div(ETH) != rInvestMoney[rid].add(reInvestAmount).div(10000).div(ETH))) {
522                 (isEnough, sendMoney) = isEnoughBalance(rInfo[rid].luckPort);
523                 if (sendMoney > 0) {
524                     sendMoneyToUser(msg.sender, sendMoney);
525                 }
526                 rInfo[rid].luckPort = 0;
527                 if (!isEnough) {
528                     endRound();
529                     return;
530                 }
531             }
532 
533             investCount = investCount.add(1);
534             investMoney = investMoney.add(reInvestAmount);
535             rInvestCount[rid] = rInvestCount[rid].add(1);
536             rInvestMoney[rid] = rInvestMoney[rid].add(reInvestAmount);
537             rInfo[rid].luckPort = rInfo[rid].luckPort.add(reInvestAmount.mul(2).div(1000)); //lucky
538 
539             sendFeetoAdmin(reInvestAmount);
540             emit LogInvestIn(msg.sender, user.id, reInvestAmount, now, user.refId, 1);
541         }
542 
543         function withdrawProfit()
544             public
545             isHuman()
546         {
547             require(gameStart(), "game not start");
548             User storage user = userRoundMapping[rid][msg.sender];
549             uint sendMoney = user.allStaticAmount.add(user.allDynamicAmount);
550 
551             bool isEnough = false;
552             uint resultMoney = 0;
553             (isEnough, resultMoney) = isEnoughBalance(sendMoney);
554             if (resultMoney > 0) {
555                 sendMoneyToUser(msg.sender, resultMoney.mul(98).div(100));
556                 savingAddr.transfer(resultMoney.mul(5).div(100));  //savior
557                 user.allStaticAmount = 0;
558                 user.allDynamicAmount = 0;
559                 emit LogWithdrawProfit(msg.sender, user.id, resultMoney, now);
560             }
561 
562             if (!isEnough) {
563                 endRound();
564             }
565         }
566 
567         function isEnoughBalance(uint sendMoney) private view returns (bool, uint){
568             if (sendMoney >= address(this).balance) {
569                 return (false, address(this).balance);
570             } else {
571                 return (true, sendMoney);
572             }
573         }
574 
575         function sendMoneyToUser(address payable userAddress, uint money) private {
576             userAddress.transfer(money);
577         }
578 
579         function calStaticProfit(address userAddr) external onlyWhitelistAdmin returns(uint)
580         {
581             return calStaticProfitInner(userAddr);
582         }
583 
584         function calStaticProfitInner(address userAddr) private returns(uint)
585         {
586             User storage user = userRoundMapping[rid][userAddr];
587             if (user.id == 0) {
588                 return 0;
589             }
590 
591             uint scale = getScByLevel(user.staticLevel, user.reInvestCount);
592             uint allStatic = 0;
593             for (uint i = user.staticFlag; i < user.invests.length; i++) {
594                 Invest storage invest = user.invests[i];
595                 uint startDay = invest.investTime.sub(4*HOURS).div(1*PERIOD).mul(1*PERIOD);
596                 uint staticGaps = now.sub(4*HOURS).sub(startDay).div(1*PERIOD);
597 
598                 uint unlockDay = now.sub(invest.investTime).div(1*PERIOD);
599 
600                 if(staticGaps > 5){
601                     staticGaps = 5;
602                 }
603 
604                 //withdraw*PERIOD
605                 if (staticGaps > invest.times) {
606                     allStatic += staticGaps.sub(invest.times).mul(scale).mul(invest.investAmount).div(1000);
607                     invest.times = staticGaps;
608                 }
609 
610                 if (unlockDay >= 5) {
611                     user.staticFlag = user.staticFlag.add(1);
612                     user.freezeAmount = user.freezeAmount.sub(invest.investAmount);
613                     user.unlockAmount = user.unlockAmount.add(invest.investAmount);
614                     user.staticLevel = getLevel(user.freezeAmount);
615                 }
616 
617             }
618             allStatic = allStatic.mul(coefficient).div(10);
619             user.allStaticAmount = user.allStaticAmount.add(allStatic);
620             user.hisStaticAmount = user.hisStaticAmount.add(allStatic);
621             return user.allStaticAmount;
622         }
623 
624         function viewScLevel(address userAddr) public view returns(uint) {
625             User memory user = userRoundMapping[rid][userAddr];
626             uint scale = getScByLevel(user.staticLevel, user.reInvestCount);
627             return scale;
628         }
629 
630         function viewStaticProfit(address userAddr) public view returns(uint)
631         {
632             User memory user = userRoundMapping[rid][userAddr];
633             if (user.id == 0) {
634                 return 0;
635             }
636 
637             uint scale = getScByLevel(user.staticLevel, user.reInvestCount);
638             uint allStatic = 0;
639             for (uint i = user.staticFlag; i < user.invests.length; i++) {
640                 Invest memory invest = user.invests[i];
641                 uint staticGaps = now.sub(invest.investTime);
642                 if(staticGaps > 5*PERIOD){
643                     staticGaps = 5*PERIOD;
644                 }
645                 //withdraw days
646 
647                 if (staticGaps > invest.times.mul(1*PERIOD)) {
648                   allStatic += staticGaps.sub(invest.times.mul(1*PERIOD)).mul(scale).mul(invest.investAmount).div(1000).div(1*PERIOD);
649                 }
650 
651             }
652             allStatic = allStatic.mul(coefficient).div(10);
653             return user.allStaticAmount.add(allStatic);
654         }
655 
656         function calDynamicProfit(uint start, uint end) external onlyWhitelistAdmin {
657             for (uint i = start; i <= end; i++) {
658                 address userAddr = indexMapping[i];
659                 User memory user = userRoundMapping[rid][userAddr];
660                 if (user.freezeAmount >= 1*ETH) {
661                     uint scale = getScByLevel(user.staticLevel, user.reInvestCount);
662                     calUserDynamicProfit(user.refId, user.freezeAmount, scale);
663                 }
664                 calStaticProfitInner(userAddr);
665             }
666         }
667 
668         function registerSelfInfo(uint refId) public isHuman(){
669             registerUser(msg.sender, refId);
670         }
671 
672         function registerUserInfo(address usr, uint refId) public onlyWhitelistAdmin {
673             registerUser(usr, refId);
674         }
675 
676         function calUserDynamicProfit(uint refId, uint money, uint shareSc) private {
677            uint tmprefId = refId;
678 
679             for (uint i = 1; i <= 30; i++) {
680                 if (tmprefId == 0) {
681                     break;
682                 }
683                 address tmpUserAddr = indexMapping[tmprefId];
684                 User storage calUser = userRoundMapping[rid][tmpUserAddr];
685 
686                 uint burnSc = getBurnByLevel(calUser.dynamicLevel);
687                 uint recommendSc = getRecommendScaleByLevelAndTim(calUser.dynamicLevel, i);
688                 uint moneyResult = 0;
689                 if (money <= calUser.freezeAmount.add(calUser.unlockAmount)) {
690                     moneyResult = money;
691                 } else {
692                     moneyResult = calUser.freezeAmount.add(calUser.unlockAmount);
693                 }
694 
695                 if (recommendSc != 0) {
696                     uint tmpDynamicAmount = moneyResult.mul(shareSc).mul(burnSc).mul(recommendSc);
697                     tmpDynamicAmount = tmpDynamicAmount.div(1000).div(10).div(100);
698 
699                     tmpDynamicAmount = tmpDynamicAmount.mul(coefficient).div(10);
700                     calUser.allDynamicAmount = calUser.allDynamicAmount.add(tmpDynamicAmount);
701                     calUser.hisDynamicAmount = calUser.hisDynamicAmount.add(tmpDynamicAmount);
702                 }
703 
704                 tmprefId = calUser.refId;
705             }
706         }
707 
708         function redeem() // withdraw
709             public
710             isHuman()
711         {
712             require(gameStart(), "game not start");
713             User storage user = userRoundMapping[rid][msg.sender];
714             require(user.id > 0, "user not exist");
715 
716             calStaticProfitInner(msg.sender);
717 
718             uint sendMoney = user.unlockAmount;
719 
720             bool isEnough = false;
721             uint resultMoney = 0;
722 
723             (isEnough, resultMoney) = isEnoughBalance(sendMoney);
724             if (resultMoney > 0) {
725                 sendMoneyToUser(msg.sender, resultMoney);
726                 user.unlockAmount = 0;
727                 user.staticLevel = getLevel(user.freezeAmount);
728                 user.dynamicLevel = getLineLevel(user.freezeAmount);
729 
730                 emit LogRedeem(msg.sender, user.id, resultMoney, now);
731             }
732 
733             // if (user.reInvestCount < 5) {
734             //     user.reInvestCount = 0;
735             // }
736             user.reInvestCount = 0;
737 
738             if (!isEnough) {
739                 endRound();
740             }
741         }
742 
743         function endRound() private {
744             rid++;
745             startTime = now.add(restTime).div(1*PERIOD).mul(1*PERIOD);
746             coefficient = 10;
747         }
748 
749         function getUserAddressByCode(uint code) public view returns(address) {
750             return indexMapping[code];
751         }
752 
753         function sendFeetoAdmin(uint amount) private {
754             devAddr.transfer(amount.mul(5).div(100)); //admin fee
755             follow.transfer(amount.mul(1).div(100)); //follower
756             follow.transfer(amount.mul(1).div(100)); //FOMO
757         }
758 
759         function getGameInfo() public isHuman() view returns(uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
760             return (
761                 rid,
762                 uid,
763                 startTime,
764                 investCount,
765                 investMoney,
766                 rInvestCount[rid],
767                 rInvestMoney[rid],
768                 coefficient,
769                 rInfo[rid].luckPort,
770                 rInfo[rid].specialUsers.length
771             );
772         }
773 
774         function getUserInfo(address user, uint roundId, uint i) public isHuman() view returns(
775             uint[17] memory ct, uint refId
776         ) {
777 
778             if(roundId == 0){
779                 roundId = rid;
780             }
781 
782             User memory userInfo = userRoundMapping[roundId][user];
783 
784             ct[0] = userInfo.id;
785             ct[1] = userInfo.staticLevel;
786             ct[2] = userInfo.dynamicLevel;
787             ct[3] = userInfo.allInvest;
788             ct[4] = userInfo.freezeAmount;
789             ct[5] = userInfo.unlockAmount;
790             ct[6] = userInfo.allStaticAmount;
791             ct[7] = userInfo.allDynamicAmount;
792             ct[8] = userInfo.hisStaticAmount;
793             ct[9] = userInfo.hisDynamicAmount;
794             ct[10] = userInfo.inviteAmount;
795             ct[11] = userInfo.reInvestCount;
796             ct[12] = userInfo.staticFlag;
797             ct[13] = userInfo.invests.length;
798             if (ct[13] != 0) {
799                 ct[14] = userInfo.invests[i].investAmount;
800                 ct[15] = userInfo.invests[i].investTime;
801                 ct[16] = userInfo.invests[i].times;
802             } else {
803                 ct[14] = 0;
804                 ct[15] = 0;
805                 ct[16] = 0;
806             }
807 
808             refId = userMapping[user].refId;
809 
810             return (
811                 ct,
812                 refId
813             );
814         }
815         //follower
816         function getSpecialUser(uint _rid, uint i) public view returns(address) {
817             return rInfo[_rid].specialUsers[i];
818         }
819 
820         function getLatestUnlockAmount(address userAddr) public view returns(uint)
821         {
822             User memory user = userRoundMapping[rid][userAddr];
823             uint allUnlock = user.unlockAmount;
824             for (uint i = user.staticFlag; i < user.invests.length; i++) {
825                 Invest memory invest = user.invests[i];
826                 uint unlockDay = now.sub(invest.investTime).div(1*PERIOD);
827 
828                 if (unlockDay >= 5) {
829                     allUnlock = allUnlock.add(invest.investAmount);
830                 }
831             }
832             return allUnlock;
833         }
834 
835         function registerUser(address user, uint refId) internal {
836             UserGlobal storage userGlobal = userMapping[user];
837             if (userGlobal.id == 0) {
838                 address refIdAddr = getUserAddressByCode(refId);
839                 require(uint(refIdAddr) != 0, "referer not exist");
840                 require(refIdAddr != user, "refId can't be self");
841                 uid++;
842                 userGlobal.id = uid;
843                 userGlobal.userAddress = user;
844                 userGlobal.refId = refId;
845                 indexMapping[uid] = user;
846 
847                 emit RegisterUser(user, uid, refId, now);
848             }
849         }
850 
851         function verifyRefId(address user, uint refId) public view returns (bool){
852             UserGlobal storage userGlobal = userMapping[user];
853             if (userGlobal.id == 0) {
854                 address refIdAddr = getUserAddressByCode(refId);
855                 if(uint(refIdAddr) != 0 && refIdAddr != user) {
856                     return true;
857                 }
858             }
859             return false;
860         }
861 
862         function dailyCheckIn() public isHuman() returns (uint){
863             checkInCount++;
864             return checkInCount;
865         }
866     }
867 
868     /**
869      * @title SafeMath
870      * @dev Math operations with safety checks that revert on error
871      */
872     library SafeMath {
873 
874         /**
875         * @dev Multiplies two numbers, reverts on overflow.
876         */
877         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
878             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
879             // benefit is lost if 'b' is also tested.
880             // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
881             if (a == 0) {
882                 return 0;
883             }
884 
885             uint256 c = a * b;
886             require(c / a == b, "mul overflow");
887 
888             return c;
889         }
890 
891         /**
892         * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
893         */
894         function div(uint256 a, uint256 b) internal pure returns (uint256) {
895             require(b > 0, "div zero"); // Solidity only automatically asserts when dividing by 0
896             uint256 c = a / b;
897             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
898 
899             return c;
900         }
901 
902         /**
903         * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
904         */
905         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
906             require(b <= a, "lower sub bigger");
907             uint256 c = a - b;
908 
909             return c;
910         }
911 
912         /**
913         * @dev Adds two numbers, reverts on overflow.
914         */
915         function add(uint256 a, uint256 b) internal pure returns (uint256) {
916             uint256 c = a + b;
917             require(c >= a, "overflow");
918 
919             return c;
920         }
921 
922         /**
923         * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
924         * reverts when dividing by zero.
925         */
926         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
927             require(b != 0, "mod zero");
928             return a % b;
929         }
930     }