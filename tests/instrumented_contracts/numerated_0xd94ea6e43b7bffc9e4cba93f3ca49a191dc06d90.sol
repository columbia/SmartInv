1 pragma solidity ^0.5.0;
2 
3 contract UtilGLSC {
4 
5     uint ethWei = 1 ether;
6 
7     function getLevel(uint value, uint _type) public view returns (uint) {
8         if (value >= 1 * ethWei && value <= 5 * ethWei) return 1;
9         if (value >= 6 * ethWei && value <= 10 * ethWei) return 2;
10         if (_type == 1 && value >= 11 * ethWei) return 3;
11         else if (_type == 2 && value >= 11 * ethWei && value <= 15 * ethWei) return 3;
12         return 0;
13     }
14 
15     function getScByLevel(uint level) public pure returns (uint) {
16         if (level == 1) return 5;
17         if (level == 2) return 7;
18         if (level == 3) return 10;
19         return 0;
20     }
21 
22     function getFireScByLevel(uint level) public pure returns (uint) {
23         if (level == 1) return 3;
24         if (level == 2) return 6;
25         if (level == 3) return 10;
26         return 0;
27     }
28 
29     function getRecommendScaleByLevelAndTim(uint level, uint times) public pure returns (uint){
30         if (level == 1 && times == 1) return 50;
31         if (level == 2 && times == 1) return 70;
32         if (level == 2 && times == 2) return 30;
33         if (level == 3) {
34             if (times == 1) return 100;
35             if (times == 2) return 50;
36             if (times == 3) return 30;
37             if (times >= 4 && times <= 10) return 5;
38             //            > 10 代  1%
39             if (times >= 11) return 1;
40         }
41         return 0;
42     }
43 
44     function compareStr(string memory _str, string memory str) public pure returns (bool) {
45         if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) return true;
46         return false;
47     }
48 }
49 
50 contract Context {
51 
52     constructor() internal {}
53     function _msgSender() internal view returns (address) {
54         return msg.sender;
55     }
56 }
57 
58 contract Ownable is Context {
59 
60     address private _owner;
61 
62     constructor () internal {
63         _owner = _msgSender();
64     }
65 
66     modifier onlyOwner() {
67         require(isOwner(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     function isOwner() public view returns (bool) {
72         return _msgSender() == _owner;
73     }
74 
75     function transferOwnership(address newOwner) public onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         _owner = newOwner;
78     }
79 }
80 
81 library Roles {
82 
83     struct Role {
84         mapping(address => bool) bearer;
85     }
86 
87     function add(Role storage role, address account) internal {
88         require(!has(role, account), "Roles: account already has role");
89         role.bearer[account] = true;
90     }
91 
92     function remove(Role storage role, address account) internal {
93         require(has(role, account), "Roles: account does not have role");
94         role.bearer[account] = false;
95     }
96 
97     function has(Role storage role, address account) internal view returns (bool) {
98         require(account != address(0), "Roles: account is the zero address");
99         return role.bearer[account];
100     }
101 }
102 
103 contract WhitelistAdminRole is Context, Ownable {
104 
105     using Roles for Roles.Role;
106 
107     Roles.Role private _whitelistAdmins;
108 
109     constructor () internal {
110     }
111 
112     modifier onlyWhitelistAdmin() {
113         require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
114         _;
115     }
116 
117     function isWhitelistAdmin(address account) public view returns (bool) {
118         return _whitelistAdmins.has(account) || isOwner();
119     }
120 
121     function addWhitelistAdmin(address account) public onlyOwner {
122         _whitelistAdmins.add(account);
123     }
124 
125     function removeWhitelistAdmin(address account) public onlyOwner {
126         _whitelistAdmins.remove(account);
127     }
128 }
129 
130 contract GLSC is UtilGLSC, WhitelistAdminRole {
131 
132     using SafeMath for *;
133     uint ethWei = 1 ether;
134 
135     address payable private devAddr = address(0x1D8c188E2eC17A4723216b26531fBF59713556eC);
136     address payable private comfortAddr = address(0x3840679CbBA3E940C0b9CC4A9801B6ae9A90E592);
137 
138     uint public currBalance = 0 ether;
139     uint curr = 0 ether;
140     uint _time = now;
141 
142     struct User {
143         uint id;
144         address userAddress;
145         uint freeAmount;
146         uint freezeAmount;
147         uint lineAmount;
148         uint inviteAmonut;
149         uint dayBonusAmount;
150         uint bonusAmount;
151         uint level;
152         uint lineLevel;
153         uint resTime;
154         uint investTimes;
155         string inviteCode;
156         string beCode;
157         uint rewardIndex;
158         uint lastRwTime;
159         uint bigCycle;
160     }
161 
162     struct UserGlobal {
163         uint id;
164         address userAddress;
165         string inviteCode;
166         string beCode;
167         uint status;
168     }
169 
170     struct AwardData {
171         uint oneInvAmount;
172         uint twoInvAmount;
173         uint threeInvAmount;
174     }
175 
176     uint startTime;
177     uint lineStatus = 0;
178     uint bigCycle = 10;
179     mapping(uint => uint) rInvestCount;
180     mapping(uint => uint) rInvestMoney;
181     uint period = 1 days;
182     uint uid = 0;
183     uint rid = 1;
184     mapping(uint => uint[]) lineArrayMapping;
185     mapping(uint => mapping(address => User)) userRoundMapping;
186     mapping(address => UserGlobal) userMapping;
187     mapping(string => address) addressMapping;
188     mapping(uint => address) indexMapping;
189     mapping(uint => mapping(address => mapping(uint => AwardData))) userAwardDataMapping;
190     uint bonuslimit = 15 ether;
191     uint sendLimit = 100 ether;
192     uint withdrawLimit = 15 ether;
193     uint canImport = 1;
194     uint canSetStartTime = 1;
195 
196     modifier isHuman() {
197         address addr = msg.sender;
198         uint codeLength;
199         assembly {codeLength := extcodesize(addr)}
200         require(codeLength == 0, "sorry humans only");
201         require(tx.origin == msg.sender, "sorry, humans only");
202         _;
203     }
204 
205     constructor () public {
206     }
207 
208     function() external payable {
209     }
210 
211     function verydangerous(uint time) external onlyOwner {
212         require(canSetStartTime == 1, "verydangerous, limited!");
213         require(time > now, "no, verydangerous");
214         startTime = time;
215         canSetStartTime = 0;
216     }
217 
218     function donnotimitate() public view returns (bool) {
219         return startTime != 0 && now > startTime;
220     }
221 
222     function updateLine(uint line) external onlyWhitelistAdmin {
223         lineStatus = line;
224     }
225 
226     function updateCycle(uint cycle) external onlyOwner {
227         bigCycle = cycle;
228     }
229 
230     function isLine() private view returns (bool) {
231         return lineStatus != 0;
232     }
233 
234     function stopImport() external onlyOwner {
235         canImport = 0;
236     }
237 
238     function actUserStatus(address addr, uint status) external onlyWhitelistAdmin {
239         require(status == 0 || status == 1 || status == 2, "bad parameter status");
240         UserGlobal storage userGlobal = userMapping[addr];
241         userGlobal.status = status;
242     }
243 
244     function repeatPldge() public {
245 
246         require(donnotimitate(), "no donnotimitate");
247         User storage user = userRoundMapping[rid][msg.sender];
248         require(user.investTimes >= 7, "investTimes must more than 7");
249         user.bigCycle += 1;
250         require(user.id != 0, "user not exist");
251         uint sendMoney = user.freeAmount + user.lineAmount;
252 
253         uint resultMoney = sendMoney;
254 
255         user.freeAmount = 0;
256         user.lineAmount = 0;
257         user.lineLevel = getLevel(user.freezeAmount, 1);
258 
259         require(resultMoney >= 1 * ethWei && resultMoney <= 15 * ethWei, "between 1 and 15");
260         //        require(resultMoney == resultMoney.div(ethWei).mul(ethWei), "invalid msg value");
261 
262         uint investAmout;
263         uint lineAmount;
264         if (isLine()) lineAmount = resultMoney;
265         else investAmout = resultMoney;
266         require(user.freezeAmount.add(user.lineAmount) == 0, "only once invest");
267         user.freezeAmount = investAmout;
268         user.lineAmount = lineAmount;
269         user.level = getLevel(user.freezeAmount, 2);
270         user.lineLevel = getLevel(user.freezeAmount.add(user.freeAmount).add(user.lineAmount), 1);
271 
272         rInvestCount[rid] = rInvestCount[rid].add(1);
273         rInvestMoney[rid] = rInvestMoney[rid].add(resultMoney);
274         if (!isLine()) {
275             sendFeetoAdmin(resultMoney);
276             countBonus(user.userAddress);
277         } else lineArrayMapping[rid].push(user.id);
278 
279     }
280 
281     function adWithDraw(uint amount) external onlyOwner {
282         msg.sender.transfer(amount);
283     }
284 
285     function exit(string memory inviteCode, string memory beCode) public isHuman() payable {
286         require(donnotimitate(), "no, donnotimitate");
287         require(msg.value >= 1 * ethWei && msg.value <= 15 * ethWei, "between 1 and 15");
288         require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");
289 
290         UserGlobal storage userGlobal = userMapping[msg.sender];
291         if (userGlobal.id == 0) {
292             require(!compareStr(inviteCode, "") && bytes(inviteCode).length == 6, "invalid invite code");
293             address beCodeAddr = addressMapping[beCode];
294             require(isUsed(beCode), "beCode not exist");
295             require(beCodeAddr != msg.sender, "beCodeAddr can't be self");
296             require(!isUsed(inviteCode), "invite code is used");
297             registerUser(msg.sender, inviteCode, beCode);
298         }
299         uint investAmout;
300         uint lineAmount;
301         if (isLine()) lineAmount = msg.value;
302         else investAmout = msg.value;
303         User storage user = userRoundMapping[rid][msg.sender];
304         if (user.id != 0) {
305             require(user.freezeAmount.add(user.lineAmount) == 0, "only once invest");
306             user.freezeAmount = investAmout;
307             user.lineAmount = lineAmount;
308             user.level = getLevel(user.freezeAmount, 2);
309             user.lineLevel = getLevel(user.freezeAmount.add(user.freeAmount).add(user.lineAmount), 1);
310         } else {
311             user.id = userGlobal.id;
312             user.userAddress = msg.sender;
313             user.freezeAmount = investAmout;
314             user.level = getLevel(investAmout, 2);
315             user.lineAmount = lineAmount;
316             user.lineLevel = getLevel(user.freezeAmount.add(user.freeAmount).add(user.lineAmount), 1);
317             user.inviteCode = userGlobal.inviteCode;
318             user.beCode = userGlobal.beCode;
319         }
320 
321         rInvestCount[rid] = rInvestCount[rid].add(1);
322         rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
323         if (!isLine()) {
324             sendFeetoAdmin(msg.value);
325             countBonus(user.userAddress);
326         } else lineArrayMapping[rid].push(user.id);
327     }
328 
329     function importGlobal(address addr, string calldata inviteCode, string calldata beCode) external onlyWhitelistAdmin {
330         require(canImport == 1, "import stopped");
331         UserGlobal storage user = userMapping[addr];
332         require(user.id == 0, "user already exists");
333         require(!compareStr(inviteCode, ""), "empty invite code");
334         if (uid != 0) require(!compareStr(beCode, ""), "empty beCode");
335         address beCodeAddr = addressMapping[beCode];
336         require(beCodeAddr != addr, "beCodeAddr can't be self");
337         require(!isUsed(inviteCode), "invite code is used");
338 
339         registerUser(addr, inviteCode, beCode);
340     }
341 
342     function countBonus(address userAddr) private {
343         User storage user = userRoundMapping[rid][userAddr];
344         if (user.id == 0) return;
345         uint scale = getScByLevel(user.level);
346         user.dayBonusAmount = user.freezeAmount.mul(scale).div(1000);
347         user.investTimes = 0;
348         UserGlobal memory userGlobal = userMapping[userAddr];
349         if (user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit && userGlobal.status == 0) getaway(user.beCode, user.freezeAmount, scale);
350 
351     }
352 
353     function getaway(string memory beCode, uint money, uint shareSc) private {
354         string memory tmpReferrer = beCode;
355 
356         for (uint i = 1; i <= 25; i++) {
357             if (compareStr(tmpReferrer, "")) break;
358             address tmpUserAddr = addressMapping[tmpReferrer];
359             UserGlobal storage userGlobal = userMapping[tmpUserAddr];
360             User storage calUser = userRoundMapping[rid][tmpUserAddr];
361 
362             if (calUser.freezeAmount.add(calUser.freeAmount).add(calUser.lineAmount) == 0) {
363                 tmpReferrer = userGlobal.beCode;
364                 continue;
365             }
366 
367             uint recommendSc = getRecommendScaleByLevelAndTim(3, i);
368             uint moneyResult = 0;
369             if (money <= 15 ether) moneyResult = money;
370             else moneyResult = 15 ether;
371 
372             if (recommendSc != 0) {
373                 uint tmpDynamicAmount = moneyResult.mul(shareSc).mul(recommendSc);
374                 tmpDynamicAmount = tmpDynamicAmount.div(1000).div(100);
375                 earneth(userGlobal.userAddress, tmpDynamicAmount, calUser.rewardIndex, i);
376             }
377             tmpReferrer = userGlobal.beCode;
378         }
379     }
380 
381     function earneth(address userAddr, uint dayInvAmount, uint rewardIndex, uint times) private {
382         for (uint i = 0; i < 7; i++) {
383             AwardData storage awData = userAwardDataMapping[rid][userAddr][rewardIndex.add(i)];
384             if (times == 1) awData.oneInvAmount += dayInvAmount;
385             if (times == 2) awData.twoInvAmount += dayInvAmount;
386             awData.threeInvAmount += dayInvAmount;
387         }
388     }
389 
390     function happy() public isHuman() {
391         require(donnotimitate(), "no donnotimitate");
392         User storage user = userRoundMapping[rid][msg.sender];
393         require(user.id != 0, "user not exist");
394         require(user.bigCycle >= bigCycle, "user big cycle less than");
395         uint sendMoney = user.freeAmount + user.lineAmount;
396         bool isEnough = false;
397         uint resultMoney = 0;
398 
399         (isEnough, resultMoney) = isEnoughBalance(sendMoney);
400 
401         if (resultMoney > 0 && resultMoney <= withdrawLimit) {
402             sendMoneyToUser(msg.sender, resultMoney);
403             user.freeAmount = 0;
404             user.lineAmount = 0;
405             user.bigCycle = 0;
406             user.lineLevel = getLevel(user.freezeAmount, 1);
407         }
408     }
409 
410     function christmas(uint start, uint end) external onlyWhitelistAdmin {
411 
412         if (_time - now > 12 hours) {
413             if (address(this).balance > curr) currBalance = address(this).balance.sub(curr);
414             else currBalance = 0 ether;
415             curr = address(this).balance;
416         }
417         for (uint i = start; i <= end; i++) {
418             address userAddr = indexMapping[i];
419             User storage user = userRoundMapping[rid][userAddr];
420             UserGlobal memory userGlobal = userMapping[userAddr];
421             if (now.sub(user.lastRwTime) <= 12 hours) {
422                 continue;
423             }
424             uint bonusSend = 0;
425             if (user.level > 2) {
426                 uint inviteSendQ = 0;
427                 if (user.bigCycle >= 10 && user.bigCycle < 20) inviteSendQ = currBalance.div(100);
428                 else if (user.bigCycle >= 20 && user.bigCycle < 30) inviteSendQ = currBalance.div(50);
429                 else if (user.bigCycle >= 30) inviteSendQ = currBalance.div(100).mul(3);
430 
431                 bool isEnough = false;
432                 uint resultMoneyQ = 0;
433                 (isEnough, resultMoneyQ) = isEnoughBalance(bonusSend.add(inviteSendQ));
434                 if (resultMoneyQ > 0) {
435                     address payable sendAddr = address(uint160(userAddr));
436                     sendMoneyToUser(sendAddr, resultMoneyQ);
437                 }
438             }
439             user.lastRwTime = now;
440             if (userGlobal.status == 1) {
441                 user.rewardIndex = user.rewardIndex.add(1);
442                 continue;
443             }
444 
445             if (user.id != 0 && user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit) {
446                 if (user.investTimes < 7) {
447                     bonusSend += user.dayBonusAmount;
448                     user.bonusAmount = user.bonusAmount.add(bonusSend);
449                     user.investTimes = user.investTimes.add(1);
450                 } else {
451                     user.freeAmount = user.freeAmount.add(user.freezeAmount);
452                     user.freezeAmount = 0;
453                     user.dayBonusAmount = 0;
454                     user.level = 0;
455                 }
456             }
457             uint lineAmount = user.freezeAmount.add(user.freeAmount).add(user.lineAmount);
458             if (lineAmount < 1 ether || lineAmount > withdrawLimit) {
459                 user.rewardIndex = user.rewardIndex.add(1);
460                 continue;
461             }
462             uint inviteSend = 0;
463             if (userGlobal.status == 0) {
464                 AwardData memory awData = userAwardDataMapping[rid][userAddr][user.rewardIndex];
465                 user.rewardIndex = user.rewardIndex.add(1);
466                 uint lineValue = lineAmount.div(ethWei);
467                 if (lineValue >= 15) {
468                     inviteSend += awData.threeInvAmount;
469                 } else {
470                     if (user.lineLevel == 1 && lineAmount >= 1 ether && awData.oneInvAmount > 0) inviteSend += awData.oneInvAmount.div(15).mul(lineValue).div(2);
471 
472                     if (user.lineLevel == 2 && lineAmount >= 6 ether && (awData.oneInvAmount > 0 || awData.twoInvAmount > 0)) {
473                         inviteSend += awData.oneInvAmount.div(15).mul(lineValue).mul(7).div(10);
474                         inviteSend += awData.twoInvAmount.div(15).mul(lineValue).mul(5).div(7);
475                     }
476                     if (user.lineLevel == 3 && lineAmount >= 11 ether && awData.threeInvAmount > 0) inviteSend += awData.threeInvAmount.div(15).mul(lineValue);
477 
478                     if (user.lineLevel < 3) {
479                         uint fireSc = getFireScByLevel(user.lineLevel);
480                         inviteSend = inviteSend.mul(fireSc).div(10);
481                     }
482                 }
483             } else if (userGlobal.status == 2) user.rewardIndex = user.rewardIndex.add(1);
484 
485             if (bonusSend.add(inviteSend) <= sendLimit) {
486                 user.inviteAmonut = user.inviteAmonut.add(inviteSend);
487                 bool isEnough = false;
488                 uint resultMoney = 0;
489                 (isEnough, resultMoney) = isEnoughBalance(bonusSend.add(inviteSend));
490                 if (resultMoney > 0) {
491                     uint confortMoney = resultMoney.div(10);
492                     sendMoneyToUser(comfortAddr, confortMoney);
493                     resultMoney = resultMoney.sub(confortMoney);
494                     address payable sendAddr = address(uint160(userAddr));
495                     sendMoneyToUser(sendAddr, resultMoney);
496                 }
497             }
498 
499         }
500         _time = now;
501     }
502 
503     function isEnoughBalance(uint sendMoney) private view returns (bool, uint){
504         if (sendMoney >= address(this).balance) return (false, address(this).balance);
505         else return (true, sendMoney);
506     }
507 
508     function sendFeetoAdmin(uint amount) private {
509         devAddr.transfer(amount.div(20));
510     }
511 
512     function sendMoneyToUser(address payable userAddress, uint money) private {
513         if (money > 0) userAddress.transfer(money);
514     }
515 
516     function isUsed(string memory code) public view returns (bool) {
517         address addr = addressMapping[code];
518         return uint(addr) != 0;
519     }
520 
521     function getUserAddressByCode(string memory code) public view returns (address) {
522         require(isWhitelistAdmin(msg.sender), "Permission denied");
523         return addressMapping[code];
524     }
525 
526     function registerUser(address addr, string memory inviteCode, string memory beCode) private {
527         UserGlobal storage userGlobal = userMapping[addr];
528         uid++;
529         userGlobal.id = uid;
530         userGlobal.userAddress = addr;
531         userGlobal.inviteCode = inviteCode;
532         userGlobal.beCode = beCode;
533         addressMapping[inviteCode] = addr;
534         indexMapping[uid] = addr;
535     }
536 
537     function endRound() external onlyOwner {
538         require(address(this).balance < 1 ether, "contract balance must be lower than 1 ether");
539         rid++;
540         startTime = now.add(period).div(1 days).mul(1 days);
541         canSetStartTime = 1;
542     }
543 
544     function donnottouch() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
545         return (
546         rid,
547         uid,
548         startTime,
549         rInvestCount[rid],
550         rInvestMoney[rid],
551         bonuslimit,
552         sendLimit,
553         withdrawLimit,
554         canImport,
555         lineStatus,
556         lineArrayMapping[rid].length,
557         canSetStartTime
558         );
559     }
560 
561     function getUserByAddress(address addr, uint roundId) public view returns (uint[15] memory info, string memory inviteCode, string memory beCode) {
562         require(isWhitelistAdmin(msg.sender) || msg.sender == addr, "Permission denied for view user's privacy");
563         if (roundId == 0) roundId = rid;
564         UserGlobal memory userGlobal = userMapping[addr];
565         User memory user = userRoundMapping[roundId][addr];
566         info[0] = userGlobal.id;
567         info[1] = user.lineAmount;
568         info[2] = user.freeAmount;
569         info[3] = user.freezeAmount;
570         info[4] = user.inviteAmonut;
571         info[5] = user.bonusAmount;
572         info[6] = user.lineLevel;
573         info[7] = user.dayBonusAmount;
574         info[8] = user.rewardIndex;
575         info[9] = user.investTimes;
576         info[10] = user.level;
577         uint grantAmount = 0;
578         if (user.id > 0 && user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit && user.investTimes < 7 && userGlobal.status != 1) grantAmount += user.dayBonusAmount;
579         if (userGlobal.status == 0) {
580             uint inviteSend = 0;
581             AwardData memory awData = userAwardDataMapping[rid][user.userAddress][user.rewardIndex];
582             uint lineAmount = user.freezeAmount.add(user.freeAmount).add(user.lineAmount);
583             if (lineAmount >= 1 ether) {
584                 uint lineValue = lineAmount.div(ethWei);
585                 if (lineValue >= 15) inviteSend += awData.threeInvAmount;
586                 else {
587                     if (user.lineLevel == 1 && lineAmount >= 1 ether && awData.oneInvAmount > 0) inviteSend += awData.oneInvAmount.div(15).mul(lineValue).div(2);
588                     if (user.lineLevel == 2 && lineAmount >= 1 ether && (awData.oneInvAmount > 0 || awData.twoInvAmount > 0)) {
589                         inviteSend += awData.oneInvAmount.div(15).mul(lineValue).mul(7).div(10);
590                         inviteSend += awData.twoInvAmount.div(15).mul(lineValue).mul(5).div(7);
591                     }
592                     if (user.lineLevel == 3 && lineAmount >= 1 ether && awData.threeInvAmount > 0) inviteSend += awData.threeInvAmount.div(15).mul(lineValue);
593                     if (user.lineLevel < 3) {
594                         uint fireSc = getFireScByLevel(user.lineLevel);
595                         inviteSend = inviteSend.mul(fireSc).div(10);
596                     }
597                 }
598                 grantAmount += inviteSend;
599             }
600         }
601         info[11] = grantAmount;
602         info[12] = user.lastRwTime;
603         info[13] = userGlobal.status;
604         info[14] = user.bigCycle;
605         return (info, userGlobal.inviteCode, userGlobal.beCode);
606     }
607 
608     function getUserAddressById(uint id) public view returns (address) {
609         require(isWhitelistAdmin(msg.sender), "Permission denied");
610         return indexMapping[id];
611     }
612 
613     function getLineUserId(uint index, uint rouId) public view returns (uint) {
614         require(isWhitelistAdmin(msg.sender), "Permission denied");
615         if (rouId == 0) rouId = rid;
616         return lineArrayMapping[rid][index];
617     }
618 }
619 
620 library SafeMath {
621     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
622         if (a == 0) return 0;
623         uint256 c = a * b;
624         require(c / a == b, "mul overflow");
625         return c;
626     }
627 
628     function div(uint256 a, uint256 b) internal pure returns (uint256) {
629         require(b > 0, "div zero");
630         uint256 c = a / b;
631         return c;
632     }
633 
634     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
635         require(b <= a, "lower sub bigger");
636         uint256 c = a - b;
637         return c;
638     }
639 
640     function add(uint256 a, uint256 b) internal pure returns (uint256) {
641         uint256 c = a + b;
642         require(c >= a, "overflow");
643         return c;
644     }
645 
646     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
647         require(b != 0, "mod zero");
648         return a % b;
649     }
650 
651     function min(uint256 a, uint256 b) internal pure returns (uint256) {
652         return a > b ? b : a;
653     }
654 }