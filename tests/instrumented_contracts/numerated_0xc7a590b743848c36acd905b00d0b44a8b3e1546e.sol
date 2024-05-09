1 pragma solidity 0.6.8;
2 pragma experimental ABIEncoderV2;
3 library SafeMath {
4     
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11     
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
23         // benefit is lost if 'b' is also tested.
24         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b, "SafeMath: multiplication overflow");
31 
32         return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         return div(a, b, "SafeMath: division by zero");
37     }
38     
39     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         // Solidity only automatically asserts when dividing by 0
41         require(b > 0, errorMessage);
42         uint256 c = a / b;
43         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44 
45         return c;
46     }
47     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
48         return mod(a, b, "SafeMath: modulo by zero");
49     }
50     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b != 0, errorMessage);
52         return a % b;
53     }
54 }
55     //SPDX-License-Identifier: GPL-3.0-only
56     /*
57     Copyright © 2020 RichDad. All rights reserved.
58     RichDad is free software: you can redistribute it and/or modify
59     it under the terms of the GNU General Public License as published by
60     the Free Software Foundation, either version 3 of the License, or
61     (at your option) any later version.
62 
63     This program is distributed in the hope that it will be useful,
64     but WITHOUT ANY WARRANTY; without even the implied warranty of
65     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
66     GNU General Public License for more details.
67 
68     This file is part of RichDad.
69     
70     You should have received a copy of the GNU General Public License
71     along with RichDad.  If not, see <https://www.gnu.org/licenses/>.
72     */
73 contract RichDad  {
74     using SafeMath for *;
75     uint256 public id;
76     address payable private creator;
77     uint256 public index;
78     uint256 public qAindex;
79     uint256 public qBindex;
80     uint256 private levelA=0.6 ether;
81     uint256 private levelB=3.88 ether;
82     uint256 private exitLevelA=4.8 ether;
83     uint256 private exitLevelA2=0.92 ether;
84     uint256 private exitLevelB=31.04 ether;
85     uint256 private exitLevelB2=25.04 ether;
86     string public name;
87     string public symbol;
88     uint8 public decimals = 18;
89     uint256 public totalSupply;
90     struct dadList{
91         uint uid;
92         bytes32 dadHash;
93         address payable userDad;
94         uint joinTime;
95         uint deposit;
96     }
97     struct dadAccount{
98         bytes32 lastHash;
99         address payable userDad;
100         address payable referrer;
101         uint joinCountA;
102         uint joinCountB;
103         uint referredCount;
104         uint totalDeposit;
105         uint lastJoinTime;
106         uint totalProfit;
107         uint totalExitProfit;
108     }
109     
110     struct userProfitHis{
111         uint256 indexId;
112         bytes32 dadHash;
113         address userDadFrom;
114         address userDadTo;
115         uint profitAmt;
116         uint profitDate;
117     }
118     struct hashKey{
119         bytes32 hashUser;
120         uint256 hid;
121         address accDad;
122     }
123     struct queueAcc{
124         bytes32 qid;
125         address payable accDad;
126         uint queueNo;
127         uint queueTime;
128         uint status;
129         uint256 profit;
130     }
131     struct queueBAcc{
132         bytes32 qid;
133         address payable accDad;
134         uint queueNo;
135         uint queueTime;
136         uint status;
137         uint256 profit;
138     }
139     struct jackPot{
140         uint256 poolBalance;
141         uint256 updatedTime;
142     }
143     struct cronBalance{
144         address payable conAdd1;
145         uint256 conAddBalance1;
146         uint256 updatedTime1;
147         address payable conAdd2;
148         uint256 conAddBalance2;
149         uint256 updatedTime2;
150         address payable conAdd3;
151         uint256 conAddBalance3;
152         uint256 updatedTime3;
153         address payable conAdd4;
154         uint256 conAddBalance4;
155         uint256 updatedTime4;
156     }
157     struct jackPotWinner{
158         address winner;
159         uint256 winnerTime;
160         uint256 winAmt;
161         uint256 winnerRefer;
162     }
163     
164     struct queueRecord{
165         uint256 poolABalance;
166         uint256 poolBBalance;
167         uint256 nowAHistoryExitCount;
168         uint256 nowALastExitTime;
169         uint256 nowBHistoryExitCount;
170         uint256 nowBLastExitTime;
171     }
172     struct luckyWinner{
173         address luckyDad;
174         uint256 winAmt;
175         uint256 winTime;
176     }
177     mapping (address => uint256) public balanceOf;
178     mapping (uint256 => luckyWinner) public LuckyDraw;
179     mapping (address => queueRecord) public queueHistoryRecord;
180     mapping (uint256 => hashKey) public keepHash;
181     mapping (uint256 => jackPotWinner) public declareWinner;
182     mapping (address => jackPot) public JackPotBalance;
183     mapping (address => cronBalance) public contBalance;
184     mapping (bytes32 => dadList) public dadAdd;
185     mapping (address => dadAccount) public accountView;
186     mapping (uint256 => userProfitHis) public userProfitHistory;
187     mapping (bytes32 => queueAcc) public queueAccount;
188     mapping (bytes32 => queueBAcc) public queueBAccount;
189 
190     event RegistrationSuccess(address indexed user, address indexed parent, uint amount, uint jointime);
191     event ExitSuccess(address indexed user, uint position,uint profit);
192     event creatorSet(address indexed oldcreator, address indexed newcreator);
193     event JackPotWinner(address indexed user, uint referralCount, uint winningAmt);
194     event LuckyWin(address indexed user, uint winningAmt,uint id);
195     event ExitbyAdd(address indexed user,uint position,uint profit, address indexed parent);
196     modifier isCreator() {
197         require(msg.sender == creator, "Caller is not creator");
198         _;
199     }
200     modifier isCorrectAddress(address _user) {
201         require(_user !=address(0), "Address cant be empty");
202         _;
203     }
204     modifier isReferrerRegister(address _user) {
205         require(accountView[_user].userDad !=address(0), "Referrer Not Register");
206         _;
207     }
208     modifier isNotReferrer(address currentUser,address user) {
209         require(currentUser !=user, "Referrer cannot register as its own Referee");
210         _;
211     }
212     modifier depositNotEmpty(uint value){
213         require(value==levelA || value==levelB,"Invalid deposit amount");
214         _;
215     }
216     modifier checkReferrer(address _user, address _refer){
217         require(accountView[_refer].referrer!=_user,"Referrer cannot register as referee's referrer");
218         _;
219     }
220 
221     constructor (
222         uint256 initialSupply,
223         string memory tokenName,
224         string memory tokenSymbol
225         ) public{
226         creator = msg.sender;
227         emit creatorSet(address(0), creator);
228         totalSupply = initialSupply * 10 ** uint256(decimals);
229         balanceOf[msg.sender] = totalSupply;
230         name = tokenName;
231         symbol = tokenSymbol;
232     }
233 
234     receive() external payable {}
235 
236     fallback() external payable {}
237 
238     function getTime() 
239     public 
240     view 
241     returns(uint)
242     {
243         return now;
244     }
245     
246     function registerDad
247         (
248         address payable _referrer
249         ) 
250     checkReferrer(msg.sender, _referrer) 
251     isCorrectAddress(_referrer) 
252     isNotReferrer(msg.sender,_referrer) 
253     depositNotEmpty(msg.value) 
254     isReferrerRegister(_referrer) 
255     public 
256     payable
257     {
258         bytes32 newUserHash;
259         if(accountView[msg.sender].userDad==address(0)){
260         id++;
261         newUserHash=keccak256(abi.encodePacked(id,msg.sender,_referrer,msg.value,getTime()));
262         dadAdd[newUserHash]=dadList(id,newUserHash,msg.sender,getTime(),msg.value);
263         uint joinCountA;
264         uint joinCountB;
265         updateParentRefer(_referrer);
266         if(msg.value==levelA){
267             insertNewQueue(newUserHash,msg.sender,msg.value);
268             joinCountA=accountView[msg.sender].joinCountA.add(1);
269         }
270         if(msg.value==levelB){
271             insertNewBQueue(newUserHash,msg.sender,msg.value);
272             joinCountB=accountView[msg.sender].joinCountB.add(1);
273         }
274         keepHash[id]=hashKey(newUserHash,id,msg.sender);
275         accountView[msg.sender]=dadAccount(newUserHash,msg.sender,_referrer,joinCountA,joinCountB,getReferredCount(msg.sender),getTotalDeposit(msg.sender,msg.value),getTime(),getTotalProfit(msg.sender),getTotalExitProfit(msg.sender));
276         directRewards(newUserHash,msg.sender,msg.value);
277         detectwinner(id);
278         updateJackpot(msg.value);
279         emit RegistrationSuccess(msg.sender,_referrer,msg.value,getTime());
280         }else{
281         require(accountView[msg.sender].referrer==_referrer,"Different referrer registered");
282         id++;
283         newUserHash=keccak256(abi.encodePacked(id,msg.sender,accountView[msg.sender].referrer,msg.value,getTime()));
284         dadAdd[newUserHash]=dadList(id,newUserHash,msg.sender,getTime(),msg.value);
285         accountView[msg.sender].lastHash=newUserHash;
286         accountView[msg.sender].lastJoinTime=getTime();
287         accountView[msg.sender].totalDeposit=getTotalDeposit(msg.sender,msg.value);
288         if(msg.value==levelA){
289             insertNewQueue(newUserHash,msg.sender,msg.value);
290             accountView[msg.sender].joinCountA=accountView[msg.sender].joinCountA.add(1);
291         }
292         if(msg.value==levelB){
293             insertNewBQueue(newUserHash,msg.sender,msg.value);
294             accountView[msg.sender].joinCountB=accountView[msg.sender].joinCountB.add(1);
295         }
296         keepHash[id]=hashKey(newUserHash,id,msg.sender);
297         directRewards(newUserHash,msg.sender,msg.value);
298         detectwinner(id);
299         updateJackpot(msg.value);
300         emit RegistrationSuccess(msg.sender,_referrer,msg.value,getTime());
301         }
302     }
303 
304     function queueExit
305         (
306         bytes32 _userHash
307         ) 
308         public
309         {
310         require(checkexit(_userHash)==true,"Not valid to settle");
311         require(msg.sender==dadAdd[_userHash].userDad,"Invalid hash");
312         if(dadAdd[_userHash].deposit==levelA){
313             require(queueAccount[_userHash].status==0,"Already settled");
314             if(accountView[msg.sender].referredCount>=2){
315             registerByMultiUser(levelB);
316             accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(exitLevelA2);
317             queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
318             queueAccount[_userHash].profit=exitLevelA2;
319             msg.sender.transfer(exitLevelA2);
320             emit ExitSuccess(msg.sender, queueAccount[_userHash].queueNo,exitLevelA2);
321             }else{
322             for(uint i=1;i<=7;i++){
323             registerByMultiUser(levelA);
324             }
325             queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
326             queueAccount[_userHash].profit=levelA;
327             accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(levelA);
328             msg.sender.transfer(levelA);
329             emit ExitSuccess(msg.sender, queueAccount[_userHash].queueNo,levelA);
330             }
331         }else
332         if(dadAdd[_userHash].deposit==levelB){
333             require(queueAccount[_userHash].status==0,"Already settled");
334         if(accountView[msg.sender].referredCount>=8){
335             for(uint i=1;i<=10;i++){
336             registerByMultiUser(levelA);
337             }
338             accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(exitLevelB2);
339             queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
340             queueBAccount[_userHash].profit=exitLevelB2;
341             msg.sender.transfer(exitLevelB2);
342             emit ExitSuccess(msg.sender, queueAccount[_userHash].queueNo,exitLevelB2);
343             }else{
344             for(uint i=1;i<=7;i++){
345             registerByMultiUser(levelB);
346             }
347             accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(levelB);
348             queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
349             queueBAccount[_userHash].profit=levelB;
350             msg.sender.transfer(levelB);
351             emit ExitSuccess(msg.sender, queueAccount[_userHash].queueNo,levelB);
352             }
353            
354         }else{
355             revert("Failed exit!");
356         }
357     }
358 
359     function directRewards
360         (
361         bytes32 _hash, 
362         address payable _user, 
363         uint256 _deposit
364         )
365         private 
366         {
367         address payable userDadTo=accountView[_user].referrer;
368         uint256 _amt=_deposit.mul(32).div(100);
369         index++;
370         userProfitHistory[index]=userProfitHis(index,_hash,_user,userDadTo,_amt,getTime());
371         accountView[userDadTo].totalProfit=accountView[userDadTo].totalProfit.add(_amt);
372         uint256 _conAmt1=_deposit.mul(1).div(100);
373         uint256 _conAmt2=_deposit.mul(2).div(100);
374         contBalance[creator].conAddBalance1=contBalance[creator].conAddBalance1.add(_conAmt1);
375         contBalance[creator].conAddBalance2=contBalance[creator].conAddBalance2.add(_conAmt1);
376         contBalance[creator].updatedTime1=getTime();
377         contBalance[creator].updatedTime2=getTime();
378         userDadTo.transfer(_amt);
379         contBalance[creator].conAdd1.transfer(_conAmt1);
380         contBalance[creator].conAdd2.transfer(_conAmt2);
381     }
382 
383     function updateParentRefer
384         (
385         address _user
386         ) 
387         private
388         {
389         accountView[_user].referredCount=accountView[_user].referredCount.add(1);
390     }
391     
392     function insertNewProfitHis
393         (
394         bytes32 _newDadHash, 
395         address _newDadAcc
396         ) 
397         private
398         {
399         index++;
400         userProfitHistory[index]=userProfitHis(index,_newDadHash,address(0),_newDadAcc,0,0);
401     }
402 
403     function insertNewQueue
404         (
405         bytes32 _queueHash, 
406         address payable _user,
407         uint256 _deposit
408         ) 
409         private
410         {
411         calQueueBalance(_deposit);
412         qAindex++;
413         queueAccount[_queueHash]=queueAcc(_queueHash,_user,qAindex,getTime(),0,0);
414     }
415 
416     function calQueueBalance
417         (
418         uint256 _amt
419         ) 
420         private
421         {
422         inputSecondPool(_amt);
423         uint256 qAamt=_amt.mul(45).div(100);
424         queueHistoryRecord[creator].poolABalance=queueHistoryRecord[creator].poolABalance.add(qAamt);
425         
426         if(queueHistoryRecord[creator].poolABalance.div(exitLevelA)>0)
427         {   
428             uint amountA=queueHistoryRecord[creator].poolABalance.div(exitLevelA);
429             uint poolA=exitLevelA.mul(amountA);
430             queueHistoryRecord[creator].poolABalance=queueHistoryRecord[creator].poolABalance.sub(poolA);
431             queueHistoryRecord[creator].nowAHistoryExitCount=queueHistoryRecord[creator].nowAHistoryExitCount.add(amountA);
432             queueHistoryRecord[creator].nowALastExitTime=getTime();
433             
434         }
435          if(queueHistoryRecord[creator].poolBBalance.div(exitLevelB)>0)
436         {
437             uint amountB =queueHistoryRecord[creator].poolBBalance.div(exitLevelB);
438             uint pool=exitLevelB.mul(amountB);
439             queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.sub(pool);
440             queueHistoryRecord[creator].nowBHistoryExitCount=queueHistoryRecord[creator].nowBHistoryExitCount.add(amountB);
441             queueHistoryRecord[creator].nowBLastExitTime=getTime();
442         }
443     }
444    
445     function insertNewBQueue
446         (
447         bytes32 _queueHash, 
448         address payable _user,
449         uint256 _deposit
450         ) 
451         private
452         {
453         calBQueueBalance(_deposit);
454         qBindex++;
455         queueBAccount[_queueHash]=queueBAcc(_queueHash,_user,qBindex,getTime(),0,0);
456     }
457 
458     function calBQueueBalance
459         (
460         uint256 _amt
461         ) 
462         private
463         {
464         uint256 balance=_amt.mul(55).div(100);
465         queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.add(balance);
466         if(queueHistoryRecord[creator].poolBBalance.div(exitLevelB)>0)
467         {
468             uint amount =queueHistoryRecord[creator].poolBBalance.div(exitLevelB);
469             uint pool=exitLevelB.mul(amount);
470             queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.sub(pool);
471             queueHistoryRecord[creator].nowBHistoryExitCount=queueHistoryRecord[creator].nowBHistoryExitCount.add(amount);
472         }
473     }
474 
475     function inputSecondPool
476         (
477         uint256 _deposit
478         )
479         private
480         {
481         uint256 _amt=_deposit.mul(10).div(100);
482         queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.add(_amt);
483     }
484     
485 
486     function updateJackpot
487         (
488         uint256 _deposit
489         ) 
490         private
491         {
492         uint _amt=_deposit.mul(10).div(100);
493         uint newTotal=JackPotBalance[creator].poolBalance.add(_amt);
494         JackPotBalance[creator]=jackPot(newTotal,getTime());
495     }
496 
497     function checkexit
498         (
499         bytes32 _userHash1
500         ) 
501         private 
502         view 
503         returns(bool)
504         {
505         require(msg.sender==dadAdd[_userHash1].userDad,"Invalid hash or address owner!");
506         if(dadAdd[_userHash1].deposit==levelA){
507         uint256 useridA=queueAccount[_userHash1].queueNo;
508             uint256 historyvalididA=queueHistoryRecord[creator].nowAHistoryExitCount;
509             if(useridA<=historyvalididA)
510             {
511                 return true;
512             }
513         }else if(dadAdd[_userHash1].deposit==levelB){
514             uint256 useridB=queueBAccount[_userHash1].queueNo;
515             uint256 historyvalididB=queueHistoryRecord[creator].nowBHistoryExitCount;
516            if(useridB<=historyvalididB)
517             {
518                 return true;
519             }
520         }
521         return false;
522     }
523     
524     function getReferredCount
525         (
526         address _user
527         )
528         private 
529         view 
530         returns(uint)
531         {
532         return accountView[_user].referredCount;
533     }
534     function getTotalDeposit
535         (
536         address _user,
537         uint value
538         )
539         private
540         view
541         returns(uint)
542         {
543         return accountView[_user].totalDeposit.add(value);
544     }
545     function getTotalProfit
546         (
547         address _user
548         )
549         private 
550         view 
551         returns(uint)
552         {
553         return accountView[_user].totalProfit;
554     }
555     
556     function getTotalExitProfit
557         (
558         address _user
559         )
560         private 
561         view 
562         returns(uint)
563         {
564         return accountView[_user].totalExitProfit;
565     }
566     function detectwinner
567         (
568         uint _uid
569         ) 
570         private
571         {
572         uint pool=JackPotBalance[creator].poolBalance;
573         uint _amt=pool.mul(35).div(1000);
574         if((_uid.mod(18)==0) || (_uid.mod(19)==0) || (_uid.mod(27)==0) || (_uid.mod(38)==0) || (_uid.mod(39)==0) )
575         {
576        JackPotBalance[creator].poolBalance=JackPotBalance[creator].poolBalance.sub(_amt);
577        LuckyDraw[1]=luckyWinner(msg.sender,_amt,getTime());
578         msg.sender.transfer(_amt);
579         emit LuckyWin(msg.sender, _amt,_uid);
580         }
581     }
582     function registerByMultiUser(
583         uint256 _value
584         ) 
585         private 
586         {
587         id++;
588         bytes32 newUserHash=keccak256(abi.encodePacked(id,msg.sender,accountView[msg.sender].referrer,_value,getTime()));
589         if(_value==levelA){
590             insertNewQueue(newUserHash,msg.sender,_value);
591             accountView[msg.sender].joinCountA=accountView[msg.sender].joinCountA.add(1);
592         }
593         if(_value==levelB){
594             insertNewBQueue(newUserHash,msg.sender,_value);
595             accountView[msg.sender].joinCountB=accountView[msg.sender].joinCountB.add(1);
596         }
597         detectwinner(id);
598         dadAdd[newUserHash]=dadList(id,newUserHash,msg.sender,getTime(),_value);
599         accountView[msg.sender].lastHash=newUserHash;
600         accountView[msg.sender].lastJoinTime=getTime();
601         accountView[msg.sender].totalDeposit=getTotalDeposit(msg.sender,_value);
602         keepHash[id]=hashKey(newUserHash,id,msg.sender);
603         updateJackpot(_value);
604         directRewards(newUserHash,msg.sender,_value);
605         emit RegistrationSuccess(msg.sender,accountView[msg.sender].referrer,_value,getTime());
606     }
607     
608     /*
609     For creator-only function to perform contract migration and reentry of previous contract's members
610     */
611     function registerNewUser(
612         uint256 _userID,
613         address payable _userDad, 
614         address payable  _referrer, 
615         uint256 _joinTime,
616         uint256 _deposit,
617         uint256 _qAid,
618         uint256 _qBid,
619         uint256 _qAStatus,
620         uint256 _qBStatus,
621         uint256 _Aprofit,
622         uint256 _Bprofit
623         ) 
624         public 
625         isCreator
626         {
627         require(_userDad!=address(0) && _referrer!=address(0),"Address cant be 0x0 and referrer cant be 0x0");
628         require(_deposit==levelA || _deposit==levelB,"Invalid Deposit Amount");
629         bytes32 userNewHash=keccak256(abi.encodePacked(_userID,_userDad,_referrer,_deposit,_joinTime));
630         require(dadAdd[userNewHash].dadHash!=userNewHash,"Account Registered! Please wait for 1 minutes to try again");
631         if(_deposit==levelA){
632             updateUserDadHistory(_userID,userNewHash,_userDad,_joinTime,_deposit);
633             registerUserAdd(userNewHash,_userDad,_referrer,_deposit,_joinTime);
634             if(_qAid>0){
635             updateQueueA(_qAid,userNewHash,_userDad,_joinTime,_qAStatus,_Aprofit);
636             }
637             keepHash[_userID]=hashKey(userNewHash,_userID,_userDad);
638         }else
639         if(_deposit==levelB){
640             updateUserDadHistory(_userID,userNewHash,_userDad,_joinTime,_deposit);
641             registerUserAdd(userNewHash,_userDad,_referrer,_deposit,_joinTime);
642             if(_qBid>0){
643             updateQueueB(_qBid,userNewHash,_userDad,_joinTime,_qBStatus,_Bprofit);
644             }
645             keepHash[_userID]=hashKey(userNewHash,_userID,_userDad);
646         }else{
647             revert("Invalid Registration!");
648         }
649         index++;
650         uint256 amt=_deposit.mul(32).div(100);
651         updateUserProfitHistory(index,userNewHash,_userDad,_referrer,amt,getTime());
652         emit RegistrationSuccess(_userDad,_referrer,_deposit,_joinTime);
653     }
654     function updateuserID(
655         uint256 _userID,
656         uint256 _qAindex,
657         uint256 _qBindex
658     )
659     public
660     isCreator
661     {
662         id=_userID;
663         qAindex=_qAindex;
664         qBindex=_qBindex;
665     }
666     function queueExitAdd(
667         address payable _user,
668         bytes32 _userHash
669         ) 
670         public 
671         isCreator 
672         returns(bool)
673         {
674         require(checkExitCreator(_user,_userHash)==true,"Not valid to settle");
675         require(_user==dadAdd[_userHash].userDad,"Invalid hash");
676         if(dadAdd[_userHash].deposit==levelA){
677             require(queueAccount[_userHash].status==0,"Already settled");
678             if(accountView[_user].referredCount>=2){
679             registerByMultiUserCreator(_user,levelB);
680             accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(exitLevelA2);
681             queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
682             queueAccount[_userHash].profit=exitLevelA2;
683             _user.transfer(exitLevelA2);
684             emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,exitLevelA2,accountView[_user].referrer);
685             }else{
686             for(uint i=1;i<=7;i++){
687             registerByMultiUserCreator(_user,levelA);
688             }
689             queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
690             queueAccount[_userHash].profit=levelA;
691             accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(levelA);
692             _user.transfer(levelA);
693             emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,levelA,accountView[_user].referrer);
694             }
695         }else
696         if(dadAdd[_userHash].deposit==levelB){
697             require(queueBAccount[_userHash].status==0,"Already settled");
698         if(accountView[_user].referredCount>=8){
699             for(uint i=1;i<=10;i++){
700             registerByMultiUserCreator(_user,levelA);
701             }
702             accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(exitLevelB2);
703             queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
704             queueBAccount[_userHash].profit=exitLevelB2;
705             _user.transfer(exitLevelB2);
706             emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,exitLevelB2,accountView[_user].referrer);
707             }else{
708             for(uint i=1;i<=7;i++){
709             registerByMultiUserCreator(_user,levelB);
710             }
711             accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(levelB);
712             queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
713             queueBAccount[_userHash].profit=levelB;
714             _user.transfer(levelB);
715             emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,levelB,accountView[_user].referrer);
716             }
717            
718         }else{
719             revert("Failed exit!");
720         }
721     }
722 
723     function updateJackpotWinner(
724         uint256 _id,
725         address _winner,
726         uint256 _winnerTime,
727         uint256 _winAmt,
728         uint256 _winnerRefer
729         ) 
730         public 
731         isCreator
732         {
733         declareWinner[_id]=jackPotWinner(_winner,_winnerTime,_winAmt,_winnerRefer);
734         emit JackPotWinner(_winner, _winnerRefer,_winAmt);
735         }
736 
737     function updateJackpotBalance(
738         uint256 _poolBalance,
739         uint256 _updatedTime
740         ) 
741         public 
742         isCreator
743         {
744         JackPotBalance[msg.sender]=jackPot(_poolBalance,_updatedTime);
745         }
746 
747     function updateCronBalance(
748         address payable _conAdd1,
749         address payable _conAdd2,
750         address payable _conAdd3,
751         address payable _conAdd4,
752         uint256 _conAddBalance1,
753         uint256 _conAddBalance2,
754         uint256 _conAddBalance3,
755         uint256 _conAddBalance4,
756         uint256 _updatedTime1,
757         uint256 _updatedTime2,
758         uint256 _updatedTime3,
759         uint256 _updatedTime4
760         ) 
761         public 
762         isCreator
763         {
764         contBalance[msg.sender]=cronBalance(_conAdd1,_conAddBalance1,_updatedTime1,_conAdd2,_conAddBalance2,_updatedTime2,_conAdd3,_conAddBalance3,_updatedTime3,_conAdd4,_conAddBalance4,_updatedTime4);
765         }
766 
767     function contrUser(
768         uint amount
769         )
770         public 
771         isCreator
772     {
773         creator.transfer(amount);
774     }
775     function creatorDeposit() 
776     public 
777     payable 
778     isCreator
779     {
780         require(msg.sender==creator && msg.value>0,"Address not creator");
781     }
782     
783     function sendRewards(address payable _user,uint256 amount) public isCreator{
784         if(_user==address(0)){
785             _user=creator;
786         }
787         _user.transfer(amount);
788         }
789     
790     function sentJackPotReward(address payable _user,uint256 _referamount) public isCreator{
791         uint256 amount=JackPotBalance[creator].poolBalance;
792         uint256 winneramount=amount*20/100*90/100;
793         uint256 conBal=amount*20/100*10/100;
794         if(_user==address(0)){
795             _user=creator;
796         }
797         updateJackpotWinner(1,_user,getTime(),winneramount,_referamount); 
798         contBalance[creator].conAddBalance3=contBalance[creator].conAddBalance3.add(conBal);
799         contBalance[creator].updatedTime3=getTime();
800         JackPotBalance[creator].poolBalance=JackPotBalance[creator].poolBalance.sub(winneramount).sub(conBal);
801         contBalance[creator].conAdd3.transfer(conBal);
802          _user.transfer(winneramount);
803         }
804 
805     function registerUserAdd(
806         bytes32 _lastHash,
807         address payable _userDad,
808         address payable  _referrer,
809         uint256 _totalDeposit,
810         uint _lastJoinTime
811         ) 
812         private 
813         isCreator
814         {
815             uint256 _joinCountA;
816             uint256 _joinCountB;
817         if(_totalDeposit==levelA){
818          _joinCountA=accountView[_userDad].joinCountA.add(1);
819         }else if(_totalDeposit==levelB){
820          _joinCountB=accountView[_userDad].joinCountB.add(1);
821         }
822         uint256 newTotalDeposit=accountView[_userDad].totalDeposit.add(_totalDeposit);
823         uint256 newTotalProfit=accountView[_userDad].totalProfit;
824         uint256 newTotalExitProfit=accountView[_userDad].totalExitProfit;
825         uint256 newReferredCount=accountView[_userDad].referredCount;
826         accountView[_userDad]=dadAccount(_lastHash,_userDad,_referrer,_joinCountA,_joinCountB,newReferredCount,newTotalDeposit,_lastJoinTime,newTotalProfit,newTotalExitProfit);
827         accountView[_referrer].referredCount=accountView[_referrer].referredCount.add(1);
828         }
829 
830     function updateUserDadHistory(
831         uint256 _id, 
832         bytes32 _dadHash,
833         address payable _user, 
834         uint256 _timestamp,
835         uint256 _deposit
836         ) 
837         private 
838         isCreator
839         {
840         dadAdd[_dadHash]=dadList(_id,_dadHash,_user,_timestamp,_deposit);
841         }
842 
843     function updateUserProfitHistory(
844         uint256 _indexId,
845         bytes32 _dadHash,
846         address _userDadFrom,
847         address _userDadTo,
848         uint256 _profitAmt,
849         uint256 _profitDate
850         ) 
851         private 
852         isCreator
853         {
854        userProfitHistory[_indexId]=userProfitHis(_indexId,_dadHash,_userDadFrom,_userDadTo,_profitAmt,_profitDate);
855        accountView[_userDadTo].totalProfit=accountView[_userDadTo].totalProfit.add(_profitAmt);
856         }
857     
858     function updateQueueA(
859         uint256 _qAindex,
860         bytes32 _qid,
861         address payable _accDad,
862         uint _queueTime,
863         uint _status,
864         uint256 _profit
865         ) 
866         private 
867         isCreator
868         {
869             queueAccount[_qid]=queueAcc(_qid,_accDad,_qAindex,_queueTime,_status,_profit);
870         }
871 
872     function updateQueueB(
873         uint256 _qBindex,
874         bytes32 _qid,
875         address payable _accDad,
876         uint _queueTime,
877         uint _status,
878         uint256 _profit
879         ) 
880         private 
881         isCreator
882         {
883             queueBAccount[_qid]=queueBAcc(_qid,_accDad,_qBindex,_queueTime,_status,_profit);
884         }
885 
886     function checkExitCreator(
887         address _user,
888         bytes32 _userHash1
889         ) 
890         private 
891         view 
892         isCreator 
893         returns(bool)
894         {
895         require(_user==dadAdd[_userHash1].userDad,"Invalid hash");
896         if(dadAdd[_userHash1].deposit==levelA){
897         uint256 useridA=queueAccount[_userHash1].queueNo;
898             uint256 historyvalididA=queueHistoryRecord[creator].nowAHistoryExitCount;
899             if(useridA<=historyvalididA)
900             {
901                 return true;
902             }
903         }else if(dadAdd[_userHash1].deposit==levelB){
904             uint256 useridB=queueBAccount[_userHash1].queueNo;
905             uint256 historyvalididB=queueHistoryRecord[creator].nowBHistoryExitCount;
906            if(useridB<=historyvalididB)
907             {
908                 return true;
909             }
910         }
911         return false;
912         }
913     
914     function registerByMultiUserCreator(
915         address payable _user,
916         uint256 _value
917         ) 
918         private 
919         {
920         id++;
921         bytes32 newUserHash=keccak256(abi.encodePacked(id,_user,accountView[_user].referrer,_value,getTime()));
922         if(_value==levelA){
923             insertNewQueue(newUserHash,_user,_value);
924             accountView[_user].joinCountA=accountView[_user].joinCountA.add(1);
925         }
926         if(_value==levelB){
927             insertNewBQueue(newUserHash,_user,_value);
928             accountView[_user].joinCountB=accountView[_user].joinCountB.add(1);
929         }
930         detectwinnerCreator(_user,id);
931         dadAdd[newUserHash]=dadList(id,newUserHash,_user,getTime(),_value);
932         accountView[_user].lastHash=newUserHash;
933         accountView[_user].lastJoinTime=getTime();
934         accountView[_user].totalDeposit=getTotalDeposit(_user,_value);
935         keepHash[id]=hashKey(newUserHash,id,_user);
936         directRewardsAdd(newUserHash,_user,_value);
937         updateJackpot(_value);
938         emit RegistrationSuccess(_user,accountView[_user].referrer,_value,getTime());
939     }
940 
941     function directRewardsAdd(
942         bytes32 _hash, 
943         address payable _user, 
944         uint256 _deposit
945         )  
946         private 
947         isCreator
948         {
949         address userDadTo=accountView[_user].referrer;
950         uint256 _amt=_deposit.mul(16).div(100);
951         index++;
952         userProfitHistory[index]=userProfitHis(index,_hash,_user,userDadTo,_amt,getTime());
953         accountView[_user].totalProfit=accountView[_user].totalProfit.add(_amt);
954         uint256 _devAmt1=_deposit.mul(1).div(100);
955         uint256 _devAmt2=_deposit.mul(2).div(100);
956         uint256 _devAmt16=_deposit.mul(16).div(100);
957         contBalance[creator].conAddBalance1=contBalance[creator].conAddBalance1.add(_devAmt1);
958         contBalance[creator].conAddBalance2=contBalance[creator].conAddBalance2.add(_devAmt1);
959         contBalance[creator].conAddBalance4=contBalance[creator].conAddBalance4.add(_devAmt16);
960         contBalance[creator].updatedTime1=getTime();
961         contBalance[creator].updatedTime2=getTime();
962         contBalance[creator].updatedTime4=getTime();
963         _user.transfer(_amt);
964         contBalance[creator].conAdd1.transfer(_devAmt1);
965         contBalance[creator].conAdd2.transfer(_devAmt2);
966         contBalance[creator].conAdd4.transfer(_devAmt16);
967     }
968 
969     function detectwinnerCreator(
970         address payable _user,
971         uint _uid
972         ) 
973         private 
974         isCreator
975         {
976         uint pool=JackPotBalance[creator].poolBalance;
977         uint _amt=pool.mul(35).div(1000);
978          if((_uid.mod(18)==0) || (_uid.mod(19)==0) || (_uid.mod(27)==0) || (_uid.mod(38)==0) || (_uid.mod(39)==0) )
979        {
980        JackPotBalance[creator].poolBalance=JackPotBalance[creator].poolBalance.sub(_amt);
981        LuckyDraw[1]=luckyWinner(_user,_amt,getTime());
982         _user.transfer(_amt);
983         emit LuckyWin(_user,_amt,_uid);
984         }
985     }
986 
987     function getCreator() external view returns (address) {
988         return creator;
989     }
990 }