1 /**
2  * @title 凌霄之光 v0.1.0
3  * @author http://www.jsq.ink
4  * @developoer 微信：dappai 
5 **/
6 
7 pragma solidity ^0.5.0;
8 
9 interface tokenTransfer {
10     function transfer(address receiver, uint amount) external;
11     function transferFrom(address _from, address _to, uint256 _value) external;
12     function balanceOf(address receiver) external returns(uint256);
13 }
14 
15 contract UtilLXZG {
16     uint ethWei = 1 ether;
17 
18     function getLevel(uint value) internal view returns(uint) {
19         if (value >= 1*ethWei && value <= 5*ethWei) {
20             return 1;
21         }
22         if (value >= 6*ethWei && value <= 10*ethWei) {
23             return 2;
24         }
25         if (value >= 11*ethWei && value <= 15*ethWei) {
26             return 3;
27         }
28         return 0;
29     }
30 
31     function getLineLevel(uint value) internal view returns(uint) {
32         if (value >= 1*ethWei && value <= 5*ethWei) {
33             return 1;
34         }
35         if (value >= 6*ethWei && value <= 10*ethWei) {
36             return 2;
37         }
38         if (value >= 11*ethWei) {
39             return 3;
40         }
41         return 0;
42     }
43 
44     function getScByLevel(uint level) internal pure returns(uint) {
45         if (level == 1) {
46             return 5;
47         }
48         if (level == 2) {
49             return 7;
50         }
51         if (level == 3) {
52             return 10;
53         }
54         return 0;
55     }
56     
57     function getRecommendScaleByLevelAndTim(uint performance,uint times) internal view returns(uint){
58         if (times == 1) {
59             return 10;
60         }
61         if(performance >= 1000*ethWei && performance <= 3000*ethWei){
62             if(times >= 2 && times <= 4){
63                 return 4;
64             }
65         }
66         if(performance > 3000*ethWei && performance <= 6000*ethWei){
67             if(times >= 2 && times <= 4){
68                 return 4;
69             }
70             if(times >= 5 && times <= 10){
71                 return 3;
72             }
73         }
74         if(performance > 6000*ethWei && performance <= 10000*ethWei){
75             if(times >= 2 && times <= 4){
76                 return 4;
77             }
78             if(times >= 5 && times <= 10){
79                 return 3;
80             }
81             if(times >= 11 && times <= 15){
82                 return 1;
83             }
84         }
85         if(performance >= 10000*ethWei){
86             if(times >= 2 && times <= 4){
87                 return 4;
88             }
89             if(times >= 5 && times <= 10){
90                 return 3;
91             }
92             if(times >= 11 && times <= 20){
93                 return 1;
94             }
95         }
96         return 0;
97     }
98 
99     function compareStr(string memory _str, string memory str) internal pure returns(bool) {
100         if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
101             return true;
102         }
103         return false;
104     }
105 }
106 
107 /*
108  * @dev Provides information about the current execution context, including the
109  * sender of the transaction and its data. While these are generally available
110  * via msg.sender and msg.data, they should not be accessed in such a direct
111  * manner, since when dealing with GSN meta-transactions the account sending and
112  * paying for execution may not be the actual sender (as far as an application
113  * is concerned).
114  *
115  * This contract is only required for intermediate, library-like contracts.
116  */
117 contract Context {
118     // Empty internal constructor, to prevent people from mistakenly deploying
119     // an instance of this contract, which should be used via inheritance.
120     constructor() internal {}
121     // solhint-disable-previous-line no-empty-blocks
122 
123     function _msgSender() internal view returns (address) {
124         return msg.sender;
125     }
126 
127     function _msgData() internal view returns (bytes memory) {
128         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
129         return msg.data;
130     }
131 }
132 
133 /**
134  * @dev Contract module which provides a basic access control mechanism, where
135  * there is an account (an owner) that can be granted exclusive access to
136  * specific functions.
137  *
138  * This module is used through inheritance. It will make available the modifier
139  * `onlyOwner`, which can be applied to your functions to restrict their use to
140  * the owner.
141  */
142 contract Ownable is Context {
143     address private _owner;
144 
145     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
146 
147     /**
148      * @dev Initializes the contract setting the deployer as the initial owner.
149      */
150     constructor () internal {
151         _owner = _msgSender();
152         emit OwnershipTransferred(address(0), _owner);
153     }
154 
155     /**
156      * @dev Returns the address of the current owner.
157      */
158     function owner() public view returns (address) {
159         return _owner;
160     }
161 
162     /**
163      * @dev Throws if called by any account other than the owner.
164      */
165     modifier onlyOwner() {
166         require(isOwner(), "Ownable: caller is not the owner");
167         _;
168     }
169 
170     /**
171      * @dev Returns true if the caller is the current owner.
172      */
173     function isOwner() public view returns (bool) {
174         return _msgSender() == _owner;
175     }
176 
177     /**
178      * @dev Leaves the contract without owner. It will not be possible to call
179      * `onlyOwner` functions anymore. Can only be called by the current owner.
180      *
181      * NOTE: Renouncing ownership will leave the contract without an owner,
182      * thereby removing any functionality that is only available to the owner.
183      */
184     function renounceOwnership() public onlyOwner {
185         emit OwnershipTransferred(_owner, address(0));
186         _owner = address(0);
187     }
188 
189     /**
190      * @dev Transfers ownership of the contract to a new account (`newOwner`).
191      * Can only be called by the current owner.
192      */
193     function transferOwnership(address newOwner) public onlyOwner {
194         _transferOwnership(newOwner);
195     }
196 
197     /**
198      * @dev Transfers ownership of the contract to a new account (`newOwner`).
199      */
200     function _transferOwnership(address newOwner) internal {
201         require(newOwner != address(0), "Ownable: new owner is the zero address");
202         emit OwnershipTransferred(_owner, newOwner);
203         _owner = newOwner;
204     }
205 }
206 
207 /**
208  * @title Roles
209  * @dev Library for managing addresses assigned to a Role.
210  */
211 library Roles {
212     struct Role {
213         mapping (address => bool) bearer;
214     }
215 
216     /**
217      * @dev Give an account access to this role.
218      */
219     function add(Role storage role, address account) internal {
220         require(!has(role, account), "Roles: account already has role");
221         role.bearer[account] = true;
222     }
223 
224     /**
225      * @dev Remove an account's access to this role.
226      */
227     function remove(Role storage role, address account) internal {
228         require(has(role, account), "Roles: account does not have role");
229         role.bearer[account] = false;
230     }
231 
232     /**
233      * @dev Check if an account has this role.
234      * @return bool
235      */
236     function has(Role storage role, address account) internal view returns (bool) {
237         require(account != address(0), "Roles: account is the zero address");
238         return role.bearer[account];
239     }
240 }
241 
242 /**
243  * @title WhitelistAdminRole
244  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
245  */
246 contract WhitelistAdminRole is Context, Ownable {
247     using Roles for Roles.Role;
248 
249     event WhitelistAdminAdded(address indexed account);
250     event WhitelistAdminRemoved(address indexed account);
251 
252     Roles.Role private _whitelistAdmins;
253 
254     constructor () internal {
255         _addWhitelistAdmin(_msgSender());
256     }
257 
258     modifier onlyWhitelistAdmin() {
259         require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
260         _;
261     }
262 
263     function isWhitelistAdmin(address account) public view returns (bool) {
264         return _whitelistAdmins.has(account);
265     }
266 
267     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
268         _addWhitelistAdmin(account);
269     }
270 
271     function removeWhitelistAdmin(address account) public onlyOwner {
272         _whitelistAdmins.remove(account);
273         emit WhitelistAdminRemoved(account);
274     }
275 
276     function renounceWhitelistAdmin() public {
277         _removeWhitelistAdmin(_msgSender());
278     }
279 
280     function _addWhitelistAdmin(address account) internal {
281         _whitelistAdmins.add(account);
282         emit WhitelistAdminAdded(account);
283     }
284 
285     function _removeWhitelistAdmin(address account) internal {
286         _whitelistAdmins.remove(account);
287         emit WhitelistAdminRemoved(account);
288     }
289 }
290 
291 contract LXZG is UtilLXZG, WhitelistAdminRole {
292 
293     using SafeMath for *;
294 
295     string constant private name = "lxzg foundation";
296 
297     uint ethWei = 1 ether;
298     
299     tokenTransfer zxlContract = tokenTransfer(address(0xfb3B4D413Fb8dF96C6336E8DD103f8af38B48F87));
300     tokenTransfer fzcContract = tokenTransfer(address(0x04423d360B5F2A65266a150AC109534c47830E66));
301 
302     struct User{
303         uint id;
304         address userAddress;
305         string inviteCode;
306         string referrer;
307         uint staticLevel;
308         uint dynamicLevel;
309         uint allInvest;
310         uint freezeAmount;
311         uint allStaticAmount;
312         uint allDynamicAmount;
313         uint hisStaticAmount;
314         uint hisDynamicAmount;
315         uint inviteAmount;
316         uint performance;
317         uint reInvestCount;
318         uint lastReInvestTime;
319         uint seedFreezeAmount;
320         uint seedAllStaticAmount;
321         uint seedHisStaticAmount;
322         uint seedUnlockAmount;
323         SeedInvest[] seedInvests;
324         Invest[] invests;
325         uint staticFlag;
326         uint seedStaticFlag;
327     }
328 
329     struct GameInfo {
330         uint luckPort;
331         address[] specialUsers;
332     }
333 
334     struct UserGlobal {
335         uint id;
336         address userAddress;
337         string inviteCode;
338         string referrer;
339     }
340 
341     struct Invest{
342         address userAddress;
343         uint investAmount;
344         uint limitAmount;
345         uint earnAmount;
346         uint investTime;
347     }
348     
349     struct SeedInvest{
350         address userAddress;
351         uint investAmount;
352         uint earnAmount;
353         uint investTime;
354         uint releaseTime;
355         uint times;
356     }
357 
358     uint startTime;
359     uint endTime;
360     uint investCount = 0;
361     mapping(uint => uint) rInvestCount;
362     uint investMoney = 0;
363     mapping(uint => uint) rInvestMoney;
364     mapping(uint => GameInfo) rInfo;
365     uint uid = 0;
366     uint rid = 1;
367     uint period = 3 days;
368     uint dividendRate = 3;
369     uint statisticsDay = 0;
370     mapping (uint => mapping(address => User)) userRoundMapping;
371     mapping(address => UserGlobal) userMapping;
372     mapping (string => address) addressMapping;
373     mapping (uint => address) public indexMapping;
374 
375     /**
376      * @dev Just a simply check to prevent contract
377      * @dev this by calling method in constructor.
378      */
379     modifier isHuman() {
380         address addr = msg.sender;
381         uint codeLength;
382 
383         assembly {codeLength := extcodesize(addr)}
384         require(codeLength == 0, "sorry humans only");
385         require(tx.origin == msg.sender, "sorry, human only");
386         _;
387     }
388 
389     event LogInvestIn(address indexed who, uint indexed uid, uint amount, uint time, string inviteCode, string referrer, uint typeFlag);
390     event LogWithdrawProfit(address indexed who, uint indexed uid, uint amount, uint time);
391     event LogRedeem(address indexed who, uint indexed uid, uint amount, uint now,string tokenType);
392 
393     //==============================================================================
394     // Constructor
395     //==============================================================================
396     constructor () public {
397     }
398 
399     function () external payable {
400     }
401     
402     function investIn(string memory inviteCode, string memory referrer,uint256 value)
403         public
404         isHuman()
405         payable
406     {
407         require(value >= 10*ethWei && value <= 20000 * ethWei, "between 10 and 20000 fzc");
408         require(value == value.div(ethWei).mul(ethWei), "invalid msg value");
409         
410         //gas 10%
411         uint256 gas = value.div(10);
412         
413         //transferFrom
414         zxlContract.transferFrom(msg.sender,address(this),gas);
415         fzcContract.transferFrom(msg.sender,address(this),value);
416         zxlContract.transfer(address(0x1111111111111111111111111111111111111111),gas);
417         
418         //30 and 70
419         uint256 seedValue = value.mul(30).div(100);
420         uint256 walletValue = value.mul(70).div(100);
421 
422         UserGlobal storage userGlobal = userMapping[msg.sender];
423         if (userGlobal.id == 0) {
424             require(!compareStr(inviteCode, ""), "empty invite code");
425             address referrerAddr = getUserAddressByCode(referrer);
426             require(uint(referrerAddr) != 0, "referer not exist");
427             require(referrerAddr != msg.sender, "referrer can't be self");
428             require(!isUsed(inviteCode), "invite code is used");
429 
430             registerUser(msg.sender, inviteCode, referrer);
431         }
432 
433         User storage user = userRoundMapping[rid][msg.sender];
434         if (uint(user.userAddress) != 0) {
435             require(user.freezeAmount.add(user.seedFreezeAmount).add(value) <= 20000*ethWei, "can not beyond 20000 fzc");
436             user.allInvest = user.allInvest.add(value);
437             user.freezeAmount = user.freezeAmount.add(walletValue);
438             user.seedFreezeAmount = user.seedFreezeAmount.add(seedValue);
439             user.staticLevel = getLevel(user.freezeAmount);
440             user.dynamicLevel = getLineLevel(user.freezeAmount);
441             
442             if (!compareStr(userGlobal.referrer, "")) {
443                 address referrerAddr = getUserAddressByCode(userGlobal.referrer);
444                 userRoundMapping[rid][referrerAddr].performance = userRoundMapping[rid][referrerAddr].performance.add(value);
445             }
446         } else {
447             user.id = userGlobal.id;
448             user.userAddress = msg.sender;
449             user.freezeAmount = walletValue;
450             user.seedFreezeAmount = seedValue;
451             user.staticLevel = getLevel(walletValue);
452             user.dynamicLevel = getLineLevel(walletValue);
453             user.allInvest = value;
454             user.inviteCode = userGlobal.inviteCode;
455             user.referrer = userGlobal.referrer;
456             
457             if (!compareStr(userGlobal.referrer, "")) {
458                 address referrerAddr = getUserAddressByCode(userGlobal.referrer);
459                 userRoundMapping[rid][referrerAddr].inviteAmount++;
460                 userRoundMapping[rid][referrerAddr].performance = userRoundMapping[rid][referrerAddr].performance.add(value);
461             }
462         }
463         
464         //钱包账户放大三倍
465         uint limitAmount = walletValue.mul(3);
466         Invest memory invest = Invest(msg.sender, walletValue, limitAmount,0,now);
467         user.invests.push(invest);
468         
469         //种子钱包
470         uint releaseTime = now.add(5184000);
471         SeedInvest memory seedInvest = SeedInvest(msg.sender, seedValue, 0,now,releaseTime, 0);
472         user.seedInvests.push(seedInvest);
473 
474         investCount = investCount.add(1);
475         investMoney = investMoney.add(value);
476         statisticsDay = statisticsDay.add(value);
477         
478         //Partner
479         sendMoneyToPartner(value);
480         
481         //DynamicProfit
482         calUserDynamicProfit(userGlobal.referrer,walletValue);
483         
484         //Statistics
485         endStatistics();
486         
487         emit LogInvestIn(msg.sender, userGlobal.id, value, now, userGlobal.inviteCode, userGlobal.referrer, 0);
488     }
489 
490     function withdrawProfit()
491         public
492         isHuman()
493     {
494         endStatistics();
495         
496         User storage user = userRoundMapping[rid][msg.sender];
497         uint resultMoney = user.allStaticAmount.add(user.allDynamicAmount);
498 
499         if (resultMoney > 0) {
500             fzcContract.transfer(msg.sender,resultMoney);
501             
502             user.allStaticAmount = 0;
503             user.allDynamicAmount = 0;
504             
505             emit LogWithdrawProfit(msg.sender, user.id, resultMoney, now);
506         }
507     }
508     
509     function sendMoneyToPartner(uint money) private {
510         uint resultMoney = money.mul(45).div(1000);
511         address payable userAddress = address(0xf98F474f323ac1aa7078Fc0cddB198DA5fEf9294);
512         fzcContract.transfer(userAddress,resultMoney);
513     }
514     
515     function calStaticProfit(address userAddr) external onlyWhitelistAdmin returns(uint)
516     {
517         return calStaticProfitInner(userAddr);
518     }
519     
520     function calStaticProfitInner(address userAddr) private returns(uint)
521     {
522         User storage user = userRoundMapping[rid][userAddr];
523         if (user.id == 0) {
524             return 0;
525         }
526         
527         uint allStatic = 0;
528         for (uint i = user.staticFlag; i < user.invests.length; i++) {
529             Invest storage invest = user.invests[i];
530             
531             uint income = invest.investAmount.mul(dividendRate).div(1000);
532             allStatic = allStatic.add(income);
533             invest.earnAmount = invest.earnAmount.add(income);
534             
535             if (invest.earnAmount >= invest.limitAmount) {
536                 user.staticFlag = user.staticFlag.add(1);
537                 user.freezeAmount = user.freezeAmount.sub(invest.investAmount);
538             }
539         }
540         
541         user.allStaticAmount = user.allStaticAmount.add(allStatic);
542         user.hisStaticAmount = user.hisStaticAmount.add(allStatic);
543         return user.allStaticAmount;
544     }
545     
546     function calDynamicProfit(uint start, uint end) external onlyWhitelistAdmin {
547         for (uint i = start; i <= end; i++) {
548             address userAddr = indexMapping[i];
549             calStaticProfitInner(userAddr);
550         }
551     }
552 
553     function registerUserInfo(address user, string calldata inviteCode, string calldata referrer) external onlyOwner {
554         registerUser(user, inviteCode, referrer);
555     }
556     
557     function calUserDynamicProfit(string memory referrer, uint money) private {
558         string memory tmpReferrer = referrer;
559         
560         for (uint i = 1; i <= 20; i++) {
561             if (compareStr(tmpReferrer, "")) {
562                 break;
563             }
564             address tmpUserAddr = addressMapping[tmpReferrer];
565             User storage calUser = userRoundMapping[rid][tmpUserAddr];
566             if (calUser.id == 0) {
567                 break;
568             }
569         
570             uint recommendSc = getRecommendScaleByLevelAndTim(calUser.performance, i);
571             uint moneyResult = 0;
572             if (money <= calUser.freezeAmount) {
573                 moneyResult = money;
574             } else {
575                 moneyResult = calUser.freezeAmount;
576             }
577             
578             if (recommendSc != 0) {
579                 uint tmpDynamicAmount = moneyResult.mul(recommendSc).div(100);
580 
581                 //如果用户还有投资,则加速3倍出局，否则无收益
582                 if(calUser.freezeAmount > 0){
583                     calUser.allDynamicAmount = calUser.allDynamicAmount.add(tmpDynamicAmount);
584                     calUser.hisDynamicAmount = calUser.hisDynamicAmount.add(tmpDynamicAmount);
585                 
586                     Invest storage invest = calUser.invests[calUser.staticFlag];
587                     invest.earnAmount = invest.earnAmount.add(tmpDynamicAmount);
588                     if (invest.earnAmount >= invest.limitAmount) {
589                         calUser.staticFlag = calUser.staticFlag.add(1);
590                         calUser.freezeAmount = calUser.freezeAmount.sub(invest.investAmount);
591                     }
592                 }
593             }
594 
595             tmpReferrer = calUser.referrer;
596         }
597     }
598 
599     function seedRedeem()
600         public
601         isHuman()
602     {
603         User storage user = userRoundMapping[rid][msg.sender];
604         require(user.id > 0, "user not exist");
605         endStatistics();
606         
607         uint _now = now;
608         for (uint i = user.seedStaticFlag; i < user.seedInvests.length; i++) {
609             SeedInvest storage invest = user.seedInvests[i];
610             
611             if(_now >= invest.releaseTime){
612                 user.seedStaticFlag = user.seedStaticFlag.add(1);
613                 
614                 uint zxlIncome = invest.investAmount.mul(5).mul(60).mul(85);
615                 zxlIncome = zxlIncome.div(1000).div(100);
616         
617                 invest.earnAmount = invest.earnAmount.add(zxlIncome); 
618                 
619                 user.seedHisStaticAmount = user.seedHisStaticAmount.add(invest.earnAmount);
620                 user.seedAllStaticAmount = user.seedAllStaticAmount.add(invest.earnAmount);
621                 user.seedFreezeAmount = user.seedFreezeAmount.sub(invest.investAmount);
622                 user.seedUnlockAmount = user.seedUnlockAmount.add(invest.investAmount);
623             }
624         }
625         
626         if(user.seedUnlockAmount > 0){
627             fzcContract.transfer(msg.sender,user.seedUnlockAmount);
628             zxlContract.transfer(msg.sender,user.seedAllStaticAmount);
629             
630             user.seedUnlockAmount = 0;
631             user.seedAllStaticAmount = 0;
632             
633             emit LogRedeem(msg.sender, user.id, user.seedAllStaticAmount, now,"ZXL");
634             emit LogRedeem(msg.sender, user.id, user.seedUnlockAmount, now,"FZC");
635         }
636     }
637 
638     function isUsed(string memory code) public view returns(bool) {
639         address user = getUserAddressByCode(code);
640         return uint(user) != 0;
641     }
642 
643     function getUserAddressByCode(string memory code) public view returns(address) {
644         return addressMapping[code];
645     }
646 
647     function getGameInfo() public isHuman() view returns(uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
648         return (
649             rid,
650             uid,
651             endTime,
652             investCount,
653             investMoney,
654             rInvestCount[rid],
655             rInvestMoney[rid],
656             dividendRate,
657             rInfo[rid].luckPort,
658             rInfo[rid].specialUsers.length
659         );
660     }
661 
662     function getUserInfo(address user, uint roundId, uint i) public isHuman() view returns(
663         uint[24] memory ct, string memory inviteCode, string memory referrer
664     ) {
665         if(roundId == 0){
666             roundId = rid;
667         }
668 
669         User memory userInfo = userRoundMapping[roundId][user];
670 
671         ct[0] = userInfo.id;
672         ct[1] = userInfo.staticLevel;
673         ct[2] = userInfo.dynamicLevel;
674         ct[3] = userInfo.allInvest;
675         ct[4] = userInfo.freezeAmount;
676         ct[5] = 0;
677         ct[6] = userInfo.allStaticAmount;
678         ct[7] = userInfo.allDynamicAmount;
679         ct[8] = userInfo.hisStaticAmount;
680         ct[9] = userInfo.hisDynamicAmount;
681         ct[10] = userInfo.inviteAmount;
682         ct[11] = userInfo.reInvestCount;
683         ct[12] = userInfo.staticFlag;
684         ct[13] = userInfo.invests.length;
685         if (ct[13] != 0) {
686             ct[14] = userInfo.invests[i].investAmount;
687             ct[15] = userInfo.invests[i].limitAmount;
688             ct[16] = userInfo.invests[i].earnAmount;
689             ct[17] = userInfo.invests[i].investTime;
690         } else {
691             ct[14] = 0;
692             ct[15] = 0;
693             ct[16] = 0;
694             ct[17] = 0;
695         }
696         ct[18] = userInfo.performance;
697         
698         ct[19] = userInfo.seedInvests.length;
699         ct[20] = userInfo.seedFreezeAmount;
700         ct[21] = userInfo.seedAllStaticAmount;
701         ct[22] = userInfo.seedHisStaticAmount;
702         ct[23] = userInfo.seedUnlockAmount;
703         
704         inviteCode = userMapping[user].inviteCode;
705         referrer = userMapping[user].referrer;
706 
707         return (
708             ct,
709             inviteCode,
710             referrer
711         );
712     }
713     
714     function getSeedInfo(address user, uint roundId, uint i) public isHuman() view returns(
715         uint[5] memory ct
716     ) {
717         if(roundId == 0){
718             roundId = rid;
719         }
720         User memory userInfo = userRoundMapping[roundId][user];
721         
722         ct[0] = userInfo.seedInvests.length;
723         if (ct[0] != 0) {
724             ct[1] = userInfo.seedInvests[i].investAmount;
725             ct[2] = userInfo.seedInvests[i].earnAmount;
726             ct[3] = userInfo.seedInvests[i].investTime;
727             ct[4] = userInfo.seedInvests[i].releaseTime;
728         } else {
729             ct[1] = 0;
730             ct[2] = 0;
731             ct[3] = 0;
732             ct[4] = 0;
733         }
734        
735         return (
736             ct
737         );
738     }
739     
740     function activeGame(uint time) external onlyWhitelistAdmin
741     {
742         require(time > now, "invalid game start time");
743         startTime = time;
744         endTime = startTime.add(86400);
745     }
746     
747     function correctionStatistics(uint _statisticsDay) external onlyWhitelistAdmin
748     {
749         //handle rate
750         if(_statisticsDay != 0){
751             uint betting = _statisticsDay * ethWei;
752             dividendRate = getDividendRate(betting);
753         }
754     }
755 
756     function endStatistics() private {
757         bool flag = getTimeLeft() <= 0;
758         if(flag){
759             //tomorrow
760             startTime = now;
761             endTime = startTime.add(86400);
762             
763             //handle rate
764             uint newRate = getDividendRate(statisticsDay);
765             dividendRate = newRate;
766             statisticsDay = 0;
767         }
768     }
769     
770     function getTimeLeft()
771         public
772         view
773         returns(uint256)
774     {
775         // grab time
776         uint256 _now = now;
777 
778         if (_now < endTime)
779             if (_now > startTime)
780                 return( endTime.sub(_now) );
781             else
782                 return( (startTime).sub(_now) );
783         else
784             return(0);
785     }
786     
787     function getDividendRate(uint yeji) internal view returns(uint) {
788         if (yeji <= 50000 * ethWei) {
789             return 3;
790         }
791         if (yeji > 50000 * ethWei && yeji <= 100000 * ethWei) {
792             return 5;
793         }
794         if (yeji > 100000 * ethWei && yeji <= 150000 * ethWei) {
795             return 8;
796         }
797         if (yeji > 150000 * ethWei && yeji <= 200000 * ethWei) {
798             return 10;
799         }
800         if (yeji > 200000 * ethWei && yeji <= 250000 * ethWei) {
801             return 15;
802         }
803         if (yeji > 250000 * ethWei ) {
804             return 20;
805         }
806         return 0;
807     }
808 
809     function registerUser(address user, string memory inviteCode, string memory referrer) private {
810         UserGlobal storage userGlobal = userMapping[user];
811         uid++;
812         userGlobal.id = uid;
813         userGlobal.userAddress = user;
814         userGlobal.inviteCode = inviteCode;
815         userGlobal.referrer = referrer;
816 
817         addressMapping[inviteCode] = user;
818         indexMapping[uid] = user;
819     }
820 }
821 
822 /**
823  * @title SafeMath
824  * @dev Math operations with safety checks that revert on error
825  */
826 library SafeMath {
827 
828     /**
829     * @dev Multiplies two numbers, reverts on overflow.
830     */
831     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
832         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
833         // benefit is lost if 'b' is also tested.
834         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
835         if (a == 0) {
836             return 0;
837         }
838 
839         uint256 c = a * b;
840         require(c / a == b, "mul overflow");
841 
842         return c;
843     }
844 
845     /**
846     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
847     */
848     function div(uint256 a, uint256 b) internal pure returns (uint256) {
849         require(b > 0, "div zero"); // Solidity only automatically asserts when dividing by 0
850         uint256 c = a / b;
851         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
852 
853         return c;
854     }
855 
856     /**
857     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
858     */
859     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
860         require(b <= a, "lower sub bigger");
861         uint256 c = a - b;
862 
863         return c;
864     }
865 
866     /**
867     * @dev Adds two numbers, reverts on overflow.
868     */
869     function add(uint256 a, uint256 b) internal pure returns (uint256) {
870         uint256 c = a + b;
871         require(c >= a, "overflow");
872 
873         return c;
874     }
875 
876     /**
877     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
878     * reverts when dividing by zero.
879     */
880     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
881         require(b != 0, "mod zero");
882         return a % b;
883     }
884 }