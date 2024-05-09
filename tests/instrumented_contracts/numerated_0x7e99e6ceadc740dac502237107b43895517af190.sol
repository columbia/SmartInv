1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-02
3 */
4 
5 pragma solidity 0.6.8;
6 pragma experimental ABIEncoderV2;
7 library SafeMath {
8     
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12 
13         return c;
14     }
15     
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         return sub(a, b, "SafeMath: subtraction overflow");
18     }
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38 
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42     
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         // Solidity only automatically asserts when dividing by 0
45         require(b > 0, errorMessage);
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48 
49         return c;
50     }
51     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
52         return mod(a, b, "SafeMath: modulo by zero");
53     }
54     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b != 0, errorMessage);
56         return a % b;
57     }
58 }
59     //SPDX-License-Identifier: GPL-3.0-only
60     /*
61     Copyright © 2020 RichDad. All rights reserved.
62     RichDad is free software: you can redistribute it and/or modify
63     it under the terms of the GNU General Public License as published by
64     the Free Software Foundation, either version 3 of the License, or
65     (at your option) any later version.
66 
67     This program is distributed in the hope that it will be useful,
68     but WITHOUT ANY WARRANTY; without even the implied warranty of
69     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
70     GNU General Public License for more details.
71 
72     This file is part of RichDad.
73     
74     You should have received a copy of the GNU General Public License
75     along with RichDad.  If not, see <https://www.gnu.org/licenses/>.
76     */
77 contract RichDad  {
78     using SafeMath for *;
79     uint256 public id;
80     address payable private creator;
81     uint256 public index;
82     uint256 public qAindex;
83     uint256 public qBindex;
84     uint256 private levelA=0.6 ether;
85     uint256 private levelB=3.88 ether;
86     uint256 private exitLevelA=4.8 ether;
87     uint256 private exitLevelA2=0.92 ether;
88     uint256 private exitLevelB=31.04 ether;
89     uint256 private exitLevelB2=25.04 ether;
90     string public name;
91     string public symbol;
92     uint8 public decimals = 18;
93     uint256 public totalSupply;
94     struct dadList{
95         uint uid;
96         bytes32 dadHash;
97         address payable userDad;
98         uint joinTime;
99         uint deposit;
100     }
101     struct dadAccount{
102         bytes32 lastHash;
103         address payable userDad;
104         address payable referrer;
105         uint joinCountA;
106         uint joinCountB;
107         uint referredCount;
108         uint totalDeposit;
109         uint lastJoinTime;
110         uint totalProfit;
111         uint totalExitProfit;
112     }
113     
114     struct userProfitHis{
115         uint256 indexId;
116         bytes32 dadHash;
117         address userDadFrom;
118         address userDadTo;
119         uint profitAmt;
120         uint profitDate;
121     }
122     struct hashKey{
123         bytes32 hashUser;
124         uint256 hid;
125         address accDad;
126     }
127     struct queueAcc{
128         bytes32 qid;
129         address payable accDad;
130         uint queueNo;
131         uint queueTime;
132         uint status;
133         uint256 profit;
134     }
135     struct queueBAcc{
136         bytes32 qid;
137         address payable accDad;
138         uint queueNo;
139         uint queueTime;
140         uint status;
141         uint256 profit;
142     }
143     struct jackPot{
144         uint256 poolBalance;
145         uint256 updatedTime;
146     }
147     struct cronBalance{
148         address payable conAdd1;
149         uint256 conAddBalance1;
150         uint256 updatedTime1;
151         address payable conAdd2;
152         uint256 conAddBalance2;
153         uint256 updatedTime2;
154         address payable conAdd3;
155         uint256 conAddBalance3;
156         uint256 updatedTime3;
157         address payable conAdd4;
158         uint256 conAddBalance4;
159         uint256 updatedTime4;
160     }
161     struct jackPotWinner{
162         address winner;
163         uint256 winnerTime;
164         uint256 winAmt;
165         uint256 winnerRefer;
166     }
167     
168     struct queueRecord{
169         uint256 poolABalance;
170         uint256 poolBBalance;
171         uint256 nowAHistoryExitCount;
172         uint256 nowALastExitTime;
173         uint256 nowBHistoryExitCount;
174         uint256 nowBLastExitTime;
175     }
176     struct luckyWinner{
177         address luckyDad;
178         uint256 winAmt;
179         uint256 winTime;
180     }
181     mapping (address => uint256) public balanceOf;
182     mapping (uint256 => luckyWinner) public LuckyDraw;
183     mapping (address => queueRecord) public queueHistoryRecord;
184     mapping (uint256 => hashKey) public keepHash;
185     mapping (uint256 => jackPotWinner) public declareWinner;
186     mapping (address => jackPot) public JackPotBalance;
187     mapping (address => cronBalance) public contBalance;
188     mapping (bytes32 => dadList) public dadAdd;
189     mapping (address => dadAccount) public accountView;
190     mapping (uint256 => userProfitHis) public userProfitHistory;
191     mapping (bytes32 => queueAcc) public queueAccount;
192     mapping (bytes32 => queueBAcc) public queueBAccount;
193 
194     event RegistrationSuccess(address indexed user, address indexed parent, uint amount, uint jointime);
195     event ExitSuccess(address indexed user, uint position,uint profit);
196     event creatorSet(address indexed oldcreator, address indexed newcreator);
197     event JackPotWinner(address indexed user, uint referralCount, uint winningAmt);
198     event LuckyWin(address indexed user, uint winningAmt,uint id);
199     event ExitbyAdd(address indexed user,uint position,uint profit, address indexed parent);
200     modifier isCreator() {
201         require(msg.sender == creator, "Caller is not creator");
202         _;
203     }
204     modifier isCorrectAddress(address _user) {
205         require(_user !=address(0), "Address cant be empty");
206         _;
207     }
208     modifier isReferrerRegister(address _user) {
209         require(accountView[_user].userDad !=address(0), "Referrer Not Register");
210         _;
211     }
212     modifier isNotReferrer(address currentUser,address user) {
213         require(currentUser !=user, "Referrer cannot register as its own Referee");
214         _;
215     }
216     modifier depositNotEmpty(uint value){
217         require(value==levelA || value==levelB,"Invalid deposit amount");
218         _;
219     }
220     modifier checkReferrer(address _user, address _refer){
221         require(accountView[_refer].referrer!=_user,"Referrer cannot register as referee's referrer");
222         _;
223     }
224 
225     constructor (
226         uint256 initialSupply,
227         string memory tokenName,
228         string memory tokenSymbol
229         ) public{
230         creator = msg.sender;
231         emit creatorSet(address(0), creator);
232         totalSupply = initialSupply * 10 ** uint256(decimals);
233         balanceOf[msg.sender] = totalSupply;
234         name = tokenName;
235         symbol = tokenSymbol;
236     }
237 
238     receive() external payable {}
239 
240     fallback() external payable {}
241 
242     function getTime() 
243     public 
244     view 
245     returns(uint)
246     {
247         return now;
248     }
249     
250     function registerDad
251         (
252         address payable _referrer
253         ) 
254     checkReferrer(msg.sender, _referrer) 
255     isCorrectAddress(_referrer) 
256     isNotReferrer(msg.sender,_referrer) 
257     depositNotEmpty(msg.value) 
258     isReferrerRegister(_referrer) 
259     public 
260     payable
261     {
262         bytes32 newUserHash;
263         if(accountView[msg.sender].userDad==address(0)){
264         id++;
265         newUserHash=keccak256(abi.encodePacked(id,msg.sender,_referrer,msg.value,getTime()));
266         dadAdd[newUserHash]=dadList(id,newUserHash,msg.sender,getTime(),msg.value);
267         uint joinCountA;
268         uint joinCountB;
269         updateParentRefer(_referrer);
270         if(msg.value==levelA){
271             insertNewQueue(newUserHash,msg.sender,msg.value);
272             joinCountA=accountView[msg.sender].joinCountA.add(1);
273         }
274         if(msg.value==levelB){
275             insertNewBQueue(newUserHash,msg.sender,msg.value);
276             joinCountB=accountView[msg.sender].joinCountB.add(1);
277         }
278         keepHash[id]=hashKey(newUserHash,id,msg.sender);
279         accountView[msg.sender]=dadAccount(newUserHash,msg.sender,_referrer,joinCountA,joinCountB,getReferredCount(msg.sender),getTotalDeposit(msg.sender,msg.value),getTime(),getTotalProfit(msg.sender),getTotalExitProfit(msg.sender));
280         directRewards(newUserHash,msg.sender,msg.value);
281         detectwinner(id);
282         updateJackpot(msg.value);
283         emit RegistrationSuccess(msg.sender,_referrer,msg.value,getTime());
284         }else{
285         require(accountView[msg.sender].referrer==_referrer,"Different referrer registered");
286         id++;
287         newUserHash=keccak256(abi.encodePacked(id,msg.sender,accountView[msg.sender].referrer,msg.value,getTime()));
288         dadAdd[newUserHash]=dadList(id,newUserHash,msg.sender,getTime(),msg.value);
289         accountView[msg.sender].lastHash=newUserHash;
290         accountView[msg.sender].lastJoinTime=getTime();
291         accountView[msg.sender].totalDeposit=getTotalDeposit(msg.sender,msg.value);
292         if(msg.value==levelA){
293             insertNewQueue(newUserHash,msg.sender,msg.value);
294             accountView[msg.sender].joinCountA=accountView[msg.sender].joinCountA.add(1);
295         }
296         if(msg.value==levelB){
297             insertNewBQueue(newUserHash,msg.sender,msg.value);
298             accountView[msg.sender].joinCountB=accountView[msg.sender].joinCountB.add(1);
299         }
300         keepHash[id]=hashKey(newUserHash,id,msg.sender);
301         directRewards(newUserHash,msg.sender,msg.value);
302         detectwinner(id);
303         updateJackpot(msg.value);
304         emit RegistrationSuccess(msg.sender,_referrer,msg.value,getTime());
305         }
306     }
307 
308     function queueExit
309         (
310         bytes32 _userHash
311         ) 
312         public
313         {
314         require(checkexit(_userHash)==true,"Not valid to settle");
315         require(msg.sender==dadAdd[_userHash].userDad,"Invalid hash");
316         if(dadAdd[_userHash].deposit==levelA){
317             require(queueAccount[_userHash].status==0,"Already settled");
318             if(accountView[msg.sender].referredCount>=2){
319             registerByMultiUser(levelB);
320             accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(exitLevelA2);
321             queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
322             queueAccount[_userHash].profit=exitLevelA2;
323             msg.sender.transfer(exitLevelA2);
324             emit ExitSuccess(msg.sender, queueAccount[_userHash].queueNo,exitLevelA2);
325             }else{
326             for(uint i=1;i<=7;i++){
327             registerByMultiUser(levelA);
328             }
329             queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
330             queueAccount[_userHash].profit=levelA;
331             accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(levelA);
332             msg.sender.transfer(levelA);
333             emit ExitSuccess(msg.sender, queueAccount[_userHash].queueNo,levelA);
334             }
335         }else
336         if(dadAdd[_userHash].deposit==levelB){
337             require(queueBAccount[_userHash].status==0,"Already settled");
338         if(accountView[msg.sender].referredCount>=8){
339             for(uint i=1;i<=10;i++){
340             registerByMultiUser(levelA);
341             }
342             accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(exitLevelB2);
343             queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
344             queueBAccount[_userHash].profit=exitLevelB2;
345             msg.sender.transfer(exitLevelB2);
346             emit ExitSuccess(msg.sender, queueBAccount[_userHash].queueNo,exitLevelB2);
347             }else{
348             for(uint i=1;i<=7;i++){
349             registerByMultiUser(levelB);
350             }
351             accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(levelB);
352             queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
353             queueBAccount[_userHash].profit=levelB;
354             msg.sender.transfer(levelB);
355             emit ExitSuccess(msg.sender, queueBAccount[_userHash].queueNo,levelB);
356             }
357            
358         }else{
359             revert("Failed exit!");
360         }
361     }
362 
363     function directRewards
364         (
365         bytes32 _hash, 
366         address payable _user, 
367         uint256 _deposit
368         )
369         private 
370         {
371         address payable userDadTo=accountView[_user].referrer;
372         uint256 _amt=_deposit.mul(32).div(100);
373         index++;
374         userProfitHistory[index]=userProfitHis(index,_hash,_user,userDadTo,_amt,getTime());
375         accountView[userDadTo].totalProfit=accountView[userDadTo].totalProfit.add(_amt);
376         uint256 _conAmt1=_deposit.mul(1).div(100);
377         uint256 _conAmt2=_deposit.mul(2).div(100);
378         contBalance[creator].conAddBalance1=contBalance[creator].conAddBalance1.add(_conAmt1);
379         contBalance[creator].conAddBalance2=contBalance[creator].conAddBalance2.add(_conAmt1);
380         contBalance[creator].updatedTime1=getTime();
381         contBalance[creator].updatedTime2=getTime();
382         userDadTo.transfer(_amt);
383         contBalance[creator].conAdd1.transfer(_conAmt1);
384         contBalance[creator].conAdd2.transfer(_conAmt2);
385     }
386 
387     function updateParentRefer
388         (
389         address _user
390         ) 
391         private
392         {
393         accountView[_user].referredCount=accountView[_user].referredCount.add(1);
394     }
395     
396     function insertNewProfitHis
397         (
398         bytes32 _newDadHash, 
399         address _newDadAcc
400         ) 
401         private
402         {
403         index++;
404         userProfitHistory[index]=userProfitHis(index,_newDadHash,address(0),_newDadAcc,0,0);
405     }
406 
407     function insertNewQueue
408         (
409         bytes32 _queueHash, 
410         address payable _user,
411         uint256 _deposit
412         ) 
413         private
414         {
415         calQueueBalance(_deposit);
416         qAindex++;
417         queueAccount[_queueHash]=queueAcc(_queueHash,_user,qAindex,getTime(),0,0);
418     }
419 
420     function calQueueBalance
421         (
422         uint256 _amt
423         ) 
424         private
425         {
426         inputSecondPool(_amt);
427         uint256 qAamt=_amt.mul(45).div(100);
428         queueHistoryRecord[creator].poolABalance=queueHistoryRecord[creator].poolABalance.add(qAamt);
429         
430         if(queueHistoryRecord[creator].poolABalance.div(exitLevelA)>0)
431         {   
432             uint amountA=queueHistoryRecord[creator].poolABalance.div(exitLevelA);
433             uint poolA=exitLevelA.mul(amountA);
434             queueHistoryRecord[creator].poolABalance=queueHistoryRecord[creator].poolABalance.sub(poolA);
435             queueHistoryRecord[creator].nowAHistoryExitCount=queueHistoryRecord[creator].nowAHistoryExitCount.add(amountA);
436             queueHistoryRecord[creator].nowALastExitTime=getTime();
437             
438         }
439          if(queueHistoryRecord[creator].poolBBalance.div(exitLevelB)>0)
440         {
441             uint amountB =queueHistoryRecord[creator].poolBBalance.div(exitLevelB);
442             uint pool=exitLevelB.mul(amountB);
443             queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.sub(pool);
444             queueHistoryRecord[creator].nowBHistoryExitCount=queueHistoryRecord[creator].nowBHistoryExitCount.add(amountB);
445             queueHistoryRecord[creator].nowBLastExitTime=getTime();
446         }
447     }
448    
449     function insertNewBQueue
450         (
451         bytes32 _queueHash, 
452         address payable _user,
453         uint256 _deposit
454         ) 
455         private
456         {
457         calBQueueBalance(_deposit);
458         qBindex++;
459         queueBAccount[_queueHash]=queueBAcc(_queueHash,_user,qBindex,getTime(),0,0);
460     }
461 
462     function calBQueueBalance
463         (
464         uint256 _amt
465         ) 
466         private
467         {
468         uint256 balance=_amt.mul(55).div(100);
469         queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.add(balance);
470         if(queueHistoryRecord[creator].poolBBalance.div(exitLevelB)>0)
471         {
472             uint amount =queueHistoryRecord[creator].poolBBalance.div(exitLevelB);
473             uint pool=exitLevelB.mul(amount);
474             queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.sub(pool);
475             queueHistoryRecord[creator].nowBHistoryExitCount=queueHistoryRecord[creator].nowBHistoryExitCount.add(amount);
476         }
477     }
478 
479     function inputSecondPool
480         (
481         uint256 _deposit
482         )
483         private
484         {
485         uint256 _amt=_deposit.mul(10).div(100);
486         queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.add(_amt);
487     }
488     
489 
490     function updateJackpot
491         (
492         uint256 _deposit
493         ) 
494         private
495         {
496         uint _amt=_deposit.mul(10).div(100);
497         uint newTotal=JackPotBalance[creator].poolBalance.add(_amt);
498         JackPotBalance[creator]=jackPot(newTotal,getTime());
499     }
500 
501     function checkexit
502         (
503         bytes32 _userHash1
504         ) 
505         private 
506         view 
507         returns(bool)
508         {
509         require(msg.sender==dadAdd[_userHash1].userDad,"Invalid hash or address owner!");
510         if(dadAdd[_userHash1].deposit==levelA){
511         uint256 useridA=queueAccount[_userHash1].queueNo;
512             uint256 historyvalididA=queueHistoryRecord[creator].nowAHistoryExitCount;
513             if(useridA<=historyvalididA)
514             {
515                 return true;
516             }
517         }else if(dadAdd[_userHash1].deposit==levelB){
518             uint256 useridB=queueBAccount[_userHash1].queueNo;
519             uint256 historyvalididB=queueHistoryRecord[creator].nowBHistoryExitCount;
520            if(useridB<=historyvalididB)
521             {
522                 return true;
523             }
524         }
525         return false;
526     }
527     
528     function getReferredCount
529         (
530         address _user
531         )
532         private 
533         view 
534         returns(uint)
535         {
536         return accountView[_user].referredCount;
537     }
538     function getTotalDeposit
539         (
540         address _user,
541         uint value
542         )
543         private
544         view
545         returns(uint)
546         {
547         return accountView[_user].totalDeposit.add(value);
548     }
549     function getTotalProfit
550         (
551         address _user
552         )
553         private 
554         view 
555         returns(uint)
556         {
557         return accountView[_user].totalProfit;
558     }
559     
560     function getTotalExitProfit
561         (
562         address _user
563         )
564         private 
565         view 
566         returns(uint)
567         {
568         return accountView[_user].totalExitProfit;
569     }
570     function detectwinner
571         (
572         uint _uid
573         ) 
574         private
575         {
576         uint pool=JackPotBalance[creator].poolBalance;
577         uint _amt=pool.mul(35).div(1000);
578         if((_uid.mod(18)==0) || (_uid.mod(19)==0) || (_uid.mod(27)==0) || (_uid.mod(38)==0) || (_uid.mod(39)==0) )
579         {
580        JackPotBalance[creator].poolBalance=JackPotBalance[creator].poolBalance.sub(_amt);
581        LuckyDraw[1]=luckyWinner(msg.sender,_amt,getTime());
582         msg.sender.transfer(_amt);
583         emit LuckyWin(msg.sender, _amt,_uid);
584         }
585     }
586     function registerByMultiUser(
587         uint256 _value
588         ) 
589         private 
590         {
591         id++;
592         bytes32 newUserHash=keccak256(abi.encodePacked(id,msg.sender,accountView[msg.sender].referrer,_value,getTime()));
593         if(_value==levelA){
594             insertNewQueue(newUserHash,msg.sender,_value);
595             accountView[msg.sender].joinCountA=accountView[msg.sender].joinCountA.add(1);
596         }
597         if(_value==levelB){
598             insertNewBQueue(newUserHash,msg.sender,_value);
599             accountView[msg.sender].joinCountB=accountView[msg.sender].joinCountB.add(1);
600         }
601         detectwinner(id);
602         dadAdd[newUserHash]=dadList(id,newUserHash,msg.sender,getTime(),_value);
603         accountView[msg.sender].lastHash=newUserHash;
604         accountView[msg.sender].lastJoinTime=getTime();
605         accountView[msg.sender].totalDeposit=getTotalDeposit(msg.sender,_value);
606         keepHash[id]=hashKey(newUserHash,id,msg.sender);
607         updateJackpot(_value);
608         directRewards(newUserHash,msg.sender,_value);
609         emit RegistrationSuccess(msg.sender,accountView[msg.sender].referrer,_value,getTime());
610     }
611     
612     /*
613     For creator-only function to perform contract migration and reentry of previous contract's members
614     */
615     function registerNewUser(
616         uint256 _userID,
617         address payable _userDad, 
618         address payable  _referrer, 
619         uint256 _joinTime,
620         uint256 _deposit,
621         uint256 _qAid,
622         uint256 _qBid,
623         uint256 _qAStatus,
624         uint256 _qBStatus,
625         uint256 _Aprofit,
626         uint256 _Bprofit
627         ) 
628         public 
629         isCreator
630         {
631         require(_userDad!=address(0) && _referrer!=address(0),"Address cant be 0x0 and referrer cant be 0x0");
632         require(_deposit==levelA || _deposit==levelB,"Invalid Deposit Amount");
633         bytes32 userNewHash=keccak256(abi.encodePacked(_userID,_userDad,_referrer,_deposit,_joinTime));
634         require(dadAdd[userNewHash].dadHash!=userNewHash,"Account Registered! Please wait for 1 minutes to try again");
635         if(_deposit==levelA){
636             updateUserDadHistory(_userID,userNewHash,_userDad,_joinTime,_deposit);
637             registerUserAdd(userNewHash,_userDad,_referrer,_deposit,_joinTime);
638             if(_qAid>0){
639             updateQueueA(_qAid,userNewHash,_userDad,_joinTime,_qAStatus,_Aprofit);
640             }
641             keepHash[_userID]=hashKey(userNewHash,_userID,_userDad);
642         }else
643         if(_deposit==levelB){
644             updateUserDadHistory(_userID,userNewHash,_userDad,_joinTime,_deposit);
645             registerUserAdd(userNewHash,_userDad,_referrer,_deposit,_joinTime);
646             if(_qBid>0){
647             updateQueueB(_qBid,userNewHash,_userDad,_joinTime,_qBStatus,_Bprofit);
648             }
649             keepHash[_userID]=hashKey(userNewHash,_userID,_userDad);
650         }else{
651             revert("Invalid Registration!");
652         }
653         index++;
654         uint256 amt=_deposit.mul(32).div(100);
655         updateUserProfitHistory(index,userNewHash,_userDad,_referrer,amt,getTime());
656         emit RegistrationSuccess(_userDad,_referrer,_deposit,_joinTime);
657     }
658     function updateuserID(
659         uint256 _userID,
660         uint256 _qAindex,
661         uint256 _qBindex
662     )
663     public
664     isCreator
665     {
666         id=_userID;
667         qAindex=_qAindex;
668         qBindex=_qBindex;
669     }
670     function queueExitAdd(
671         address payable _user,
672         bytes32 _userHash
673         ) 
674         public 
675         isCreator 
676         returns(bool)
677         {
678         require(checkExitCreator(_user,_userHash)==true,"Not valid to settle");
679         require(_user==dadAdd[_userHash].userDad,"Invalid hash");
680         if(dadAdd[_userHash].deposit==levelA){
681             require(queueAccount[_userHash].status==0,"Already settled");
682             if(accountView[_user].referredCount>=2){
683             registerByMultiUserCreator(_user,levelB);
684             accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(exitLevelA2);
685             queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
686             queueAccount[_userHash].profit=exitLevelA2;
687             _user.transfer(exitLevelA2);
688             emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,exitLevelA2,accountView[_user].referrer);
689             }else{
690             for(uint i=1;i<=7;i++){
691             registerByMultiUserCreator(_user,levelA);
692             }
693             queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
694             queueAccount[_userHash].profit=levelA;
695             accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(levelA);
696             _user.transfer(levelA);
697             emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,levelA,accountView[_user].referrer);
698             }
699         }else
700         if(dadAdd[_userHash].deposit==levelB){
701             require(queueBAccount[_userHash].status==0,"Already settled");
702         if(accountView[_user].referredCount>=8){
703             for(uint i=1;i<=10;i++){
704             registerByMultiUserCreator(_user,levelA);
705             }
706             accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(exitLevelB2);
707             queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
708             queueBAccount[_userHash].profit=exitLevelB2;
709             _user.transfer(exitLevelB2);
710             emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,exitLevelB2,accountView[_user].referrer);
711             }else{
712             for(uint i=1;i<=7;i++){
713             registerByMultiUserCreator(_user,levelB);
714             }
715             accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(levelB);
716             queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
717             queueBAccount[_userHash].profit=levelB;
718             _user.transfer(levelB);
719             emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,levelB,accountView[_user].referrer);
720             }
721            
722         }else{
723             revert("Failed exit!");
724         }
725     }
726 
727     function updateJackpotWinner(
728         uint256 _id,
729         address _winner,
730         uint256 _winnerTime,
731         uint256 _winAmt,
732         uint256 _winnerRefer
733         ) 
734         public 
735         isCreator
736         {
737         declareWinner[_id]=jackPotWinner(_winner,_winnerTime,_winAmt,_winnerRefer);
738         emit JackPotWinner(_winner, _winnerRefer,_winAmt);
739         }
740     function updateQRecord(
741         uint256 _poolABalance,
742         uint256 _poolBBalance,
743         uint256 _nowAHistoryExitCount,
744         uint256 _nowALastExitTime,
745         uint256 _nowBHistoryExitCount,
746         uint256 _nowBLastExitTime
747         ) 
748         public 
749         isCreator
750         {
751         queueHistoryRecord[creator]=queueRecord(_poolABalance,_poolBBalance,_nowAHistoryExitCount,_nowALastExitTime,_nowBHistoryExitCount,_nowBLastExitTime);
752         }
753     function updateLuckyWinner(
754         uint256 _id,
755         address _luckyDad,
756         uint256 _winAmt,
757         uint256 _winTime
758         ) 
759         public 
760         isCreator
761         {
762         LuckyDraw[_id]=luckyWinner(_luckyDad,_winAmt,_winTime);
763         }
764         
765     function updateJackpotBalance(
766         uint256 _poolBalance,
767         uint256 _updatedTime
768         ) 
769         public 
770         isCreator
771         {
772         JackPotBalance[msg.sender]=jackPot(_poolBalance,_updatedTime);
773         }
774 
775     function updateCronBalance(
776         address payable _conAdd1,
777         address payable _conAdd2,
778         address payable _conAdd3,
779         address payable _conAdd4,
780         uint256 _conAddBalance1,
781         uint256 _conAddBalance2,
782         uint256 _conAddBalance3,
783         uint256 _conAddBalance4,
784         uint256 _updatedTime1,
785         uint256 _updatedTime2,
786         uint256 _updatedTime3,
787         uint256 _updatedTime4
788         ) 
789         public 
790         isCreator
791         {
792         contBalance[msg.sender]=cronBalance(_conAdd1,_conAddBalance1,_updatedTime1,_conAdd2,_conAddBalance2,_updatedTime2,_conAdd3,_conAddBalance3,_updatedTime3,_conAdd4,_conAddBalance4,_updatedTime4);
793         }
794 
795     function contrUser(
796         uint amount
797         )
798         public 
799         isCreator
800     {
801         creator.transfer(amount);
802     }
803     function creatorDeposit() 
804     public 
805     payable 
806     isCreator
807     {
808         require(msg.sender==creator && msg.value>0,"Address not creator");
809     }
810     
811     function sendRewards(address payable _user,uint256 amount) public isCreator{
812         if(_user==address(0)){
813             _user=creator;
814         }
815         _user.transfer(amount);
816         }
817     
818     function sentJackPotReward(address payable _user,uint256 _referamount) public isCreator{
819         uint256 amount=JackPotBalance[creator].poolBalance;
820         uint256 winneramount=amount*20/100*90/100;
821         uint256 conBal=amount*20/100*10/100;
822         if(_user==address(0)){
823             _user=creator;
824         }
825         updateJackpotWinner(1,_user,getTime(),winneramount,_referamount); 
826         contBalance[creator].conAddBalance3=contBalance[creator].conAddBalance3.add(conBal);
827         contBalance[creator].updatedTime3=getTime();
828         JackPotBalance[creator].poolBalance=JackPotBalance[creator].poolBalance.sub(winneramount).sub(conBal);
829         contBalance[creator].conAdd3.transfer(conBal);
830          _user.transfer(winneramount);
831         }
832 
833     function registerUserAdd(
834         bytes32 _lastHash,
835         address payable _userDad,
836         address payable  _referrer,
837         uint256 _totalDeposit,
838         uint _lastJoinTime
839         ) 
840         private 
841         isCreator
842         {
843             uint256 _joinCountA;
844             uint256 _joinCountB;
845         if(_totalDeposit==levelA){
846          _joinCountA=accountView[_userDad].joinCountA.add(1);
847         }else if(_totalDeposit==levelB){
848          _joinCountB=accountView[_userDad].joinCountB.add(1);
849         }
850         uint256 newTotalDeposit=accountView[_userDad].totalDeposit.add(_totalDeposit);
851         uint256 newTotalProfit=accountView[_userDad].totalProfit;
852         uint256 newTotalExitProfit=accountView[_userDad].totalExitProfit;
853         uint256 newReferredCount=accountView[_userDad].referredCount;
854         accountView[_userDad]=dadAccount(_lastHash,_userDad,_referrer,_joinCountA,_joinCountB,newReferredCount,newTotalDeposit,_lastJoinTime,newTotalProfit,newTotalExitProfit);
855         accountView[_referrer].referredCount=accountView[_referrer].referredCount.add(1);
856         }
857 
858     function updateUserDadHistory(
859         uint256 _id, 
860         bytes32 _dadHash,
861         address payable _user, 
862         uint256 _timestamp,
863         uint256 _deposit
864         ) 
865         private 
866         isCreator
867         {
868         dadAdd[_dadHash]=dadList(_id,_dadHash,_user,_timestamp,_deposit);
869         }
870 
871     function updateUserProfitHistory(
872         uint256 _indexId,
873         bytes32 _dadHash,
874         address _userDadFrom,
875         address _userDadTo,
876         uint256 _profitAmt,
877         uint256 _profitDate
878         ) 
879         private 
880         isCreator
881         {
882        userProfitHistory[_indexId]=userProfitHis(_indexId,_dadHash,_userDadFrom,_userDadTo,_profitAmt,_profitDate);
883        accountView[_userDadTo].totalProfit=accountView[_userDadTo].totalProfit.add(_profitAmt);
884         }
885     
886     function updateQueueA(
887         uint256 _qAindex,
888         bytes32 _qid,
889         address payable _accDad,
890         uint _queueTime,
891         uint _status,
892         uint256 _profit
893         ) 
894         private 
895         isCreator
896         {
897             queueAccount[_qid]=queueAcc(_qid,_accDad,_qAindex,_queueTime,_status,_profit);
898         }
899 
900     function updateQueueB(
901         uint256 _qBindex,
902         bytes32 _qid,
903         address payable _accDad,
904         uint _queueTime,
905         uint _status,
906         uint256 _profit
907         ) 
908         private 
909         isCreator
910         {
911             queueBAccount[_qid]=queueBAcc(_qid,_accDad,_qBindex,_queueTime,_status,_profit);
912         }
913 
914     function checkExitCreator(
915         address _user,
916         bytes32 _userHash1
917         ) 
918         private 
919         view 
920         isCreator 
921         returns(bool)
922         {
923         require(_user==dadAdd[_userHash1].userDad,"Invalid hash");
924         if(dadAdd[_userHash1].deposit==levelA){
925         uint256 useridA=queueAccount[_userHash1].queueNo;
926             uint256 historyvalididA=queueHistoryRecord[creator].nowAHistoryExitCount;
927             if(useridA<=historyvalididA)
928             {
929                 return true;
930             }
931         }else if(dadAdd[_userHash1].deposit==levelB){
932             uint256 useridB=queueBAccount[_userHash1].queueNo;
933             uint256 historyvalididB=queueHistoryRecord[creator].nowBHistoryExitCount;
934            if(useridB<=historyvalididB)
935             {
936                 return true;
937             }
938         }
939         return false;
940         }
941     
942     function registerByMultiUserCreator(
943         address payable _user,
944         uint256 _value
945         ) 
946         private 
947         {
948         id++;
949         bytes32 newUserHash=keccak256(abi.encodePacked(id,_user,accountView[_user].referrer,_value,getTime()));
950         if(_value==levelA){
951             insertNewQueue(newUserHash,_user,_value);
952             accountView[_user].joinCountA=accountView[_user].joinCountA.add(1);
953         }
954         if(_value==levelB){
955             insertNewBQueue(newUserHash,_user,_value);
956             accountView[_user].joinCountB=accountView[_user].joinCountB.add(1);
957         }
958         detectwinnerCreator(_user,id);
959         dadAdd[newUserHash]=dadList(id,newUserHash,_user,getTime(),_value);
960         accountView[_user].lastHash=newUserHash;
961         accountView[_user].lastJoinTime=getTime();
962         accountView[_user].totalDeposit=getTotalDeposit(_user,_value);
963         keepHash[id]=hashKey(newUserHash,id,_user);
964         directRewardsAdd(newUserHash,_user,_value);
965         updateJackpot(_value);
966         emit RegistrationSuccess(_user,accountView[_user].referrer,_value,getTime());
967     }
968 
969     function directRewardsAdd(
970         bytes32 _hash, 
971         address payable _user, 
972         uint256 _deposit
973         )  
974         private 
975         isCreator
976         {
977         address userDadTo=accountView[_user].referrer;
978         uint256 _amt=_deposit.mul(16).div(100);
979         index++;
980         userProfitHistory[index]=userProfitHis(index,_hash,_user,userDadTo,_amt,getTime());
981         accountView[_user].totalProfit=accountView[_user].totalProfit.add(_amt);
982         uint256 _devAmt1=_deposit.mul(1).div(100);
983         uint256 _devAmt2=_deposit.mul(2).div(100);
984         uint256 _devAmt16=_deposit.mul(16).div(100);
985         contBalance[creator].conAddBalance1=contBalance[creator].conAddBalance1.add(_devAmt1);
986         contBalance[creator].conAddBalance2=contBalance[creator].conAddBalance2.add(_devAmt1);
987         contBalance[creator].conAddBalance4=contBalance[creator].conAddBalance4.add(_devAmt16);
988         contBalance[creator].updatedTime1=getTime();
989         contBalance[creator].updatedTime2=getTime();
990         contBalance[creator].updatedTime4=getTime();
991         _user.transfer(_amt);
992         contBalance[creator].conAdd1.transfer(_devAmt1);
993         contBalance[creator].conAdd2.transfer(_devAmt2);
994         contBalance[creator].conAdd4.transfer(_devAmt16);
995     }
996 
997     function detectwinnerCreator(
998         address payable _user,
999         uint _uid
1000         ) 
1001         private 
1002         isCreator
1003         {
1004         uint pool=JackPotBalance[creator].poolBalance;
1005         uint _amt=pool.mul(35).div(1000);
1006          if((_uid.mod(18)==0) || (_uid.mod(19)==0) || (_uid.mod(27)==0) || (_uid.mod(38)==0) || (_uid.mod(39)==0) )
1007        {
1008        JackPotBalance[creator].poolBalance=JackPotBalance[creator].poolBalance.sub(_amt);
1009        LuckyDraw[1]=luckyWinner(_user,_amt,getTime());
1010         _user.transfer(_amt);
1011         emit LuckyWin(_user,_amt,_uid);
1012         }
1013     }
1014 
1015     function getCreator() external view returns (address) {
1016         return creator;
1017     }
1018 }