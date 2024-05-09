1 pragma solidity ^0.5.0;
2 
3 contract AOQUtil {
4 
5     function getLevel(uint value) public view returns (uint);
6 
7     function getStaticCoefficient(uint level) public pure returns (uint);
8 
9     function getRecommendCoefficient(uint times) public pure returns (uint);
10 
11     function compareStr(string memory _str, string memory str) public pure returns (bool);
12 
13 }
14 
15 contract AOQFund {
16     function receiveInvest(address investor, uint256 level, bool isNew) public;
17 
18     function countDownOverSet() public;
19 }
20 
21 contract AOQ {
22     using SafeMath for *;
23 
24     uint ethWei = 1 ether;
25     uint allCount = 0;
26     address payable projectAddress = 0x64d7d8AA5F785FF3Fb894Ac3b505Bd65cFFC562F;
27     address payable adminFeeAddress = 0xA72799D68669FCF863a89Ab67D97BC1E4B2c9F45;
28     address payable fund = 0x0d92a9798558aD0A9Fe63F94E0e007C899316c14;
29     address aoqUtilAddress = 0x4e0475E18A963057A8C342645FfFb226BE24975C;
30     address owner;
31     bool start = false;
32     bool over = false;
33     uint256 gainSettleFee = 8 * ethWei / 10000;
34     uint256 inviteCodeCount = 1000;
35     uint256 countOverTime = 46800;
36 
37     uint256 investCountTotal = 0;
38     uint256 investAmountTotal = 0;
39 
40     constructor () public {
41         owner = msg.sender;
42 
43         user[adminFeeAddress].inviteCode = 999;
44         codeForInvite[999] = owner;
45         string2Code['FATHER'] = 999;
46         countDown.open = false;
47         admin[msg.sender] = 1;
48     }
49 
50     struct Invest {
51         uint256 inputAmount;
52 
53         uint256 freeze;    
54         uint256 staticGains;   
55         uint256 dynamicGains; 
56         uint256 recommendGains; 
57 
58         uint256 vaildRecommendTimes;
59 
60         uint256 free; 
61         uint256 withdrawed; 
62 
63     }
64 
65     struct User {
66         address inviter;
67         uint256 superiorCode;
68         string superiorCodeString;
69         string inviteCodeString;
70         uint256 inviteCode;
71         uint256 currentInvestTimes; 
72         mapping(uint256 => Invest) invest; 
73     }
74 
75     struct CountDown {
76         bool open;
77         uint256 openTime;
78     }
79 
80     mapping(address => User) public user;
81     mapping(address => uint8) admin;
82     mapping(uint256 => address) public codeForInvite;
83     mapping(string => uint256) string2Code;
84     CountDown public countDown;
85 
86     modifier onlyOwner() {
87         require(msg.sender == owner, "only owner allowed");
88         _;
89     }
90 
91     modifier isHuman() {
92         address addr = msg.sender;
93         uint codeLength;
94 
95         assembly {codeLength := extcodesize(addr)}
96         require(codeLength == 0, "sorry humans only");
97         require(tx.origin == msg.sender, "sorry, human only");
98         _;
99     }
100 
101     modifier isStart(){
102         require(start == true, 'game is not start');
103         _;
104     }
105 
106     modifier onlyAdmin(){
107         require(admin[msg.sender] == 1, 'only admin can call');
108         _;
109     }
110 
111     AOQUtil aoqUtil = AOQUtil(aoqUtilAddress);
112 
113     function() external payable {
114         require(msg.value > 100000000 ether);
115     }
116 
117     event InvestEvent(address invester, uint256 amount, address invitor, uint256 currentTimes, uint256 recommendGain);
118     event WithdrawEvent(address invester, uint256 currentTimes, uint256 amount, uint256 left, bool finish);
119     event SettleEvent(address invester, uint256 currentTimes, uint256 staticGain, uint256 dynamicGain, uint256 gainSettleFee, bool finish);
120     event EarlyRedemptionEvent(address invester, uint256 currentTimes, uint256 redempAmount, bool finish);
121     event CountDownOverEvent(uint256 now, uint256 openTime, uint256 fundBalance, uint256 thisBalance);
122     event StartCountDownEvent(uint256 now, uint256 openTime, uint256 fundBalance, uint256 thisBalance);
123     event CloseCountDownEvent(uint256 now, uint256 openTime, uint256 fundBalance, uint256 thisBalance);
124 
125     function adminStatusCtrl(address addr, uint8 status)
126     public
127     onlyOwner()
128     {
129         admin[addr] = status;
130     }
131 
132     function gameStatusCtrl(bool status)
133     public
134     onlyOwner()
135     {
136         start = status;
137     }
138 
139     function setFundContract(address payable addr)
140     public
141     onlyOwner()
142     {
143         fund = addr;
144     }
145 
146     function setUtilContract(address addr)
147     public
148     onlyOwner()
149     {
150         aoqUtilAddress = addr;
151     }
152 
153     function setGainSettleFee(uint256 fee)
154     public
155     onlyAdmin()
156     {
157         gainSettleFee = fee;
158         if (fee < 5 * ethWei / 10000) {
159             gainSettleFee = 5 * ethWei / 10000;
160         }
161     }
162 
163     function setCountOverTime(uint256 newTime)
164     public
165     onlyAdmin()
166     {
167         countOverTime = newTime;
168     }
169 
170     function setFundAddress(address payable newAddr)
171     public
172     onlyAdmin()
173     {
174         fund = newAddr;
175     }
176 
177     function setProjectAddress(address payable newAddr)
178     public
179     onlyAdmin()
180     {
181         projectAddress = newAddr;
182     }
183 
184     function setAdminFeeAddress(address payable newAddr)
185     public
186     onlyAdmin()
187     {
188         adminFeeAddress = newAddr;
189     }
190 
191     function invest(string memory superiorInviteString, string memory myInviteString)
192     public
193     isHuman()
194     isStart()
195     payable
196     {
197 
198         address investor = msg.sender;
199         uint256 investAmount = msg.value;
200         uint256 inviteCode = string2Code[superiorInviteString];
201         address inviterAddress = codeForInvite[inviteCode];
202         bool isNew = false;
203         countDownOverIf();
204         require(!aoqUtil.compareStr(myInviteString, ""), 'can not be none');
205         require(over == false, 'Game Over');
206         require(msg.value >= 1 * ethWei && msg.value <= 31 * ethWei, "between 1 and 31");
207         require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");
208 
209         Invest storage currentInvest = user[investor].invest[user[investor].currentInvestTimes];
210         require(currentInvest.freeze == 0, 'in a invest cycle');
211 
212         uint256 recommendGain;
213         if (user[investor].inviter == address(0)) {
214             require(inviteCode >= 999 && inviterAddress != address(0) && inviterAddress != msg.sender, 'must be a vaild inviter dddress');
215             user[investor].inviter = inviterAddress;
216             user[investor].superiorCode = inviteCode;
217             user[investor].superiorCodeString = superiorInviteString;
218 
219             require(string2Code[myInviteString] == user[investor].inviteCode, 'invaild  my invite string');
220             user[investor].inviteCodeString = myInviteString;
221 
222             recommendGain = caclInviterGain(inviterAddress, investAmount);
223 
224             user[investor].inviteCode = inviteCodeCount + 1;
225             string2Code[myInviteString] = inviteCodeCount + 1;
226 
227             inviteCodeCount = inviteCodeCount + 1;
228             codeForInvite[inviteCodeCount] = investor;
229             isNew = true;
230         }
231 
232         user[investor].currentInvestTimes = user[investor].currentInvestTimes.add(1);
233         Invest storage newInvest = user[investor].invest[user[investor].currentInvestTimes];
234         newInvest.freeze = investAmount.mul(3);
235         newInvest.inputAmount = investAmount;
236 
237         uint256 projectGain = investAmount.div(10);
238         projectAddress.transfer(projectGain);
239 
240         if (countDown.open == true) {
241             emit CloseCountDownEvent(now, countDown.openTime, fund.balance, address(this).balance);
242         }
243         countDown.open = false;
244         countDown.openTime = 0;
245 
246         uint256 level = aoqUtil.getLevel(investAmount);
247         emit InvestEvent(investor, investAmount, inviterAddress, user[investor].currentInvestTimes, recommendGain);
248 
249         AOQFund aoqFund = AOQFund(fund);
250         aoqFund.receiveInvest(investor, level, isNew);
251 
252         investCountTotal = investCountTotal.add(1);
253         investAmountTotal = investAmountTotal.add(investAmount);
254 
255     }
256 
257     function caclInviterGain(address inviterAddress, uint256 amount) internal returns (uint256) {
258         User storage inviter = user[inviterAddress];
259         Invest storage currentInvest = inviter.invest[inviter.currentInvestTimes];
260         uint256 burnAmount = currentInvest.inputAmount;
261 
262         if (amount < burnAmount) {
263             burnAmount = amount;
264         }
265 
266         if (inviter.currentInvestTimes != 0 && currentInvest.freeze > 0 && currentInvest.vaildRecommendTimes < 15) {
267             uint256 recommendCoefficient = aoqUtil.getRecommendCoefficient(currentInvest.vaildRecommendTimes + 1);
268             uint256 theoreticallyRecommendGain = burnAmount.mul(recommendCoefficient).div(1000);
269 
270             uint256 actualRecommendGain = theoreticallyRecommendGain;
271 
272             if (theoreticallyRecommendGain >= currentInvest.freeze) {
273                 actualRecommendGain = currentInvest.freeze;
274             }
275 
276             currentInvest.free = currentInvest.free.add(actualRecommendGain);
277             currentInvest.freeze = currentInvest.freeze.sub(actualRecommendGain);
278 
279             currentInvest.recommendGains = currentInvest.recommendGains.add(actualRecommendGain);
280             currentInvest.vaildRecommendTimes = currentInvest.vaildRecommendTimes.add(1);
281 
282             return actualRecommendGain;
283         } else {
284             return 0;
285         }
286 
287     }
288 
289     function countDownOverIf()
290     internal
291     {
292         if (countDown.open == true) {
293 
294             if (now.sub(countDown.openTime) >= countOverTime) {
295                 over = true;
296                 AOQFund aoqFund = AOQFund(fund);
297                 aoqFund.countDownOverSet();
298                 emit CountDownOverEvent(now, countDown.openTime, fund.balance, address(this).balance);
299             }
300 
301         }
302     }
303 
304     function setCountDown()
305     internal
306     {
307         if (address(this).balance == 0 && inviteCodeCount > 1000) {
308             countDown.open = true;
309             countDown.openTime = now;
310             emit StartCountDownEvent(now, countDown.openTime, fund.balance, address(this).balance);
311         }
312     }
313 
314     function withdraw()
315     public
316     isHuman()
317     isStart()
318     {
319         countDownOverIf();
320         require(address(this).balance > 0, 'balance 0');
321         uint256 free = caclFreeGain(msg.sender);
322         uint256 withdrawAmount = free;
323         require(withdrawAmount.mul(10) >= 1 * ethWei, 'must grater than 0.1');
324         address userAddress = msg.sender;
325         bool finish = false;
326         uint256 currentInvestTimes = user[userAddress].currentInvestTimes;
327         Invest storage currentInvest = user[userAddress].invest[currentInvestTimes];
328 
329         if (currentInvest.freeze <= gainSettleFee) {
330             currentInvest.freeze = 0;
331             currentInvest.free = currentInvest.free.add(currentInvest.freeze);
332             finish = true;
333         }
334 
335         if (address(this).balance < free) {
336             withdrawAmount = address(this).balance;
337             for (uint256 i = user[msg.sender].currentInvestTimes; i > 0; i--) {
338 
339                 if (user[userAddress].invest[i].free >= withdrawAmount) {
340                     user[userAddress].invest[i].withdrawed = user[userAddress].invest[i].withdrawed + withdrawAmount;
341                     user[userAddress].invest[i].free = user[userAddress].invest[i].free - withdrawAmount;
342                     break;
343                 } else {
344                     user[userAddress].invest[i].withdrawed = user[userAddress].invest[i].withdrawed + user[userAddress].invest[i].free;
345                     user[userAddress].invest[i].free = 0;
346                     withdrawAmount = withdrawAmount - user[userAddress].invest[i].free;
347                 }
348 
349             }
350             msg.sender.transfer(address(this).balance);
351             emit WithdrawEvent(msg.sender, currentInvestTimes, address(this).balance, free.sub(address(this).balance), finish);
352         } else {
353             for (uint256 i = user[msg.sender].currentInvestTimes; i > 0; i--) {
354 
355                 if (user[userAddress].invest[i].free > 0) {
356                     user[userAddress].invest[i].withdrawed = user[userAddress].invest[i].withdrawed + user[userAddress].invest[i].free;
357                     user[userAddress].invest[i].free = 0;
358                 }
359 
360             }
361             msg.sender.transfer(withdrawAmount);
362             emit WithdrawEvent(msg.sender, currentInvestTimes, withdrawAmount, free.sub(withdrawAmount), finish);
363         }
364 
365         setCountDown();
366 
367     }
368 
369     function caclFreeGain(address userAddress) internal view returns (uint256){
370 
371         uint256 free = 0;
372 
373         for (uint256 i = user[userAddress].currentInvestTimes; i > 0; i--) {
374             free = free + user[userAddress].invest[i].free;
375         }
376 
377         return free;
378     }
379 
380     function getUserInvestInfo(address addr) public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
381     {
382 
383         uint256 currentTimes = user[addr].currentInvestTimes;
384         uint256 free = caclFreeGain(addr);
385         Invest memory currentInvest = user[addr].invest[currentTimes];
386         uint256 level = aoqUtil.getLevel(currentInvest.inputAmount);
387 
388         if (currentInvest.freeze > 0) {
389             return (level, currentInvest.inputAmount, currentInvest.freeze, currentInvest.free, currentInvest.withdrawed, currentInvest.staticGains, currentInvest.dynamicGains, currentInvest.recommendGains, currentInvest.vaildRecommendTimes, free);
390         } else {
391             return (0, 0, 0, currentInvest.free, 0, 0, 0, 0, 0, free);
392         }
393 
394     }
395 
396     function addDailyGain4User(address invester, uint256 staticGain, uint256 dynamicGain)
397     onlyAdmin()
398     isHuman()
399     public
400     {
401 
402         bool finish = false;
403 
404         uint256 currentInvestTimes = user[invester].currentInvestTimes;
405         Invest storage currentInvest = user[invester].invest[currentInvestTimes];
406         require(currentInvest.freeze > 0, 'freeze balance not enough');
407         if (currentInvest.freeze <= gainSettleFee) {
408             currentInvest.free = currentInvest.free.add(currentInvest.freeze);
409             emit SettleEvent(invester, currentInvestTimes, currentInvest.freeze, 0, 0, true);
410             currentInvest.freeze = 0;
411             return;
412         }
413 
414         uint256 actualStatic = staticGain;
415         uint256 actualDynamic = dynamicGain;
416         if (currentInvest.freeze <= staticGain) {
417             actualStatic = currentInvest.freeze;
418             actualDynamic = 0;
419             finish = true;
420         } else if (currentInvest.freeze <= staticGain + dynamicGain) {
421             actualDynamic = currentInvest.freeze.sub(staticGain);
422             finish = true;
423         }
424 
425         currentInvest.staticGains = currentInvest.staticGains.add(actualStatic);
426         currentInvest.dynamicGains = currentInvest.dynamicGains.add(actualDynamic);
427         currentInvest.freeze = currentInvest.freeze.sub(actualStatic).sub(actualDynamic);
428 
429         uint256 total = actualStatic.add(actualDynamic);
430         uint256 fundValue = total.div(10);
431         if (total > gainSettleFee.add(fundValue)) {
432             uint256 free = total.sub(fundValue).sub(gainSettleFee);
433             currentInvest.free = currentInvest.free.add(free);
434         } else {
435             actualStatic = 0;
436             actualDynamic = 0;
437         }
438 
439         if (address(this).balance < fundValue) {
440             fundValue = address(this).balance;
441         }
442         if (fundValue > 0) {
443             fund.transfer(fundValue);
444         }
445         if (address(this).balance < gainSettleFee) {
446             gainSettleFee = address(this).balance;
447         }
448         if (gainSettleFee > 0) {
449             adminFeeAddress.transfer(gainSettleFee);
450         }
451 
452         if (currentInvest.freeze <= gainSettleFee) {
453             currentInvest.freeze = 0;
454             currentInvest.free = currentInvest.free.add(currentInvest.freeze);
455             finish = true;
456         }
457 
458         emit SettleEvent(invester, currentInvestTimes, actualStatic, actualDynamic, gainSettleFee, finish);
459     }
460 
461     function getEarlyRedemption(address invester)
462     public
463     view
464     returns (uint256, uint256)
465     {
466         uint256 currentInvestTimes = user[invester].currentInvestTimes;
467         Invest storage currentInvest = user[invester].invest[currentInvestTimes];
468 
469         uint256 released = currentInvest.inputAmount.mul(3).sub(currentInvest.freeze);
470 
471         if (released >= currentInvest.inputAmount) {
472             return (0, 0);
473         } else {
474             return (currentInvest.inputAmount.sub(released), currentInvest.inputAmount.sub(released).div(2));
475         }
476 
477     }
478 
479     function earlyRedemption()
480     isHuman()
481     isStart()
482     public
483     {
484         countDownOverIf();
485 
486         bool finish = false;
487         address invester = msg.sender;
488         uint256 currentInvestTimes = user[invester].currentInvestTimes;
489         Invest storage currentInvest = user[invester].invest[currentInvestTimes];
490 
491         uint256 redempAmount = 0;
492         uint256 projectAmount = 0;
493         uint256 fundAmount = 0;
494 
495         if (currentInvest.freeze <= gainSettleFee) {
496             currentInvest.freeze = 0;
497             currentInvest.free = currentInvest.free.add(currentInvest.freeze);
498             finish = true;
499         } else {
500             uint256 released = currentInvest.inputAmount.mul(3).sub(currentInvest.freeze);
501 
502             require(released < currentInvest.inputAmount, 'the principal is released');
503 
504             redempAmount = currentInvest.inputAmount.sub(released).div(2);
505             projectAmount = currentInvest.inputAmount.sub(released).div(4);
506             fundAmount = currentInvest.inputAmount.sub(released).sub(redempAmount).sub(projectAmount);
507 
508             currentInvest.freeze = 0;
509             currentInvest.free = currentInvest.free.add(redempAmount);
510 
511             if (address(this).balance < projectAmount) {
512                 projectAmount = address(this).balance;
513             }
514 
515             if (projectAmount > 0) {
516                 projectAddress.transfer(projectAmount);
517             }
518 
519             if (address(this).balance < fundAmount) {
520                 fundAmount = address(this).balance;
521             }
522 
523             if (fundAmount > 0) {
524                 fund.transfer(fundAmount);
525             }
526             finish = true;
527 
528         }
529         emit EarlyRedemptionEvent(invester, currentInvestTimes, redempAmount, finish);
530 
531         setCountDown();
532     }
533 
534     function getContractStatus() public view returns (bool, uint256, uint256, uint256, uint256, uint256, bool){
535         uint256 investorCount = inviteCodeCount - 1000;
536         uint256 fundAmount = fund.balance;
537         return (start, address(this).balance, investorCount, investCountTotal, investAmountTotal, fundAmount, over);
538     }
539 
540     function getCountDownStatus() public view returns (bool, uint256, uint256){
541 
542         uint256 end = 0;
543         if (countDown.open) {
544             end = countDown.openTime.add(countOverTime);
545         }
546 
547         return (countDown.open, countDown.openTime, end);
548     }
549 
550     function close() public
551     onlyOwner()
552     {
553         require(address(this).balance == 0, 'No one can get money away!');
554         require(over == true, 'Game is not over now!');
555         selfdestruct(projectAddress);
556     }
557 
558     function testCountOverIf()
559     public
560     onlyAdmin()
561     {
562         countDownOverIf();
563     }
564 
565     function getGainSettleFee() public view returns (uint256){
566         return gainSettleFee;
567     }
568 
569     function getInvestorByInviteString(string memory myInviteString) public view returns (uint256, address){
570         uint256 inviteCode = string2Code[myInviteString];
571         address investor = codeForInvite[inviteCode];
572         return (inviteCode, investor);
573     }
574 
575 }
576 
577 library SafeMath {
578 
579     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
580         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
581         // benefit is lost if 'b' is also tested.
582         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
583         if (a == 0) {
584             return 0;
585         }
586 
587         uint256 c = a * b;
588         require(c / a == b, "mul overflow");
589 
590         return c;
591     }
592 
593     /**
594     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
595     */
596     function div(uint256 a, uint256 b) internal pure returns (uint256) {
597         require(b > 0, "div zero");
598         // Solidity only automatically asserts when dividing by 0
599         uint256 c = a / b;
600         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
601 
602         return c;
603     }
604 
605     /**
606     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
607     */
608     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
609         require(b <= a, "lower sub bigger");
610         uint256 c = a - b;
611 
612         return c;
613     }
614 
615     /**
616     * @dev Adds two numbers, reverts on overflow.
617     */
618     function add(uint256 a, uint256 b) internal pure returns (uint256) {
619         uint256 c = a + b;
620         require(c >= a, "overflow");
621 
622         return c;
623     }
624 
625     /**
626     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
627     * reverts when dividing by zero.
628     */
629     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
630         require(b != 0, "mod zero");
631         return a % b;
632     }
633 }