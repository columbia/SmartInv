1 //SPDX-License-Identifier: MIT License\
2  
3 /*
4  
5 ████████╗███████╗██╗░░░██╗██╗░░░██╗░█████╗░██████╗░░░░░█████╗░
6 ╚══██╔══╝██╔════╝██║░░░██║██║░░░██║██╔══██╗╚════██╗░░░██╔══██╗
7 ░░░██║░░░█████╗░░╚██╗░██╔╝╚██╗░██╔╝██║░░██║░░███╔═╝░░░██║░░██║
8 ░░░██║░░░██╔══╝░░░╚████╔╝░░╚████╔╝░██║░░██║██╔══╝░░░░░██║░░██║
9 ░░░██║░░░███████╗░░╚██╔╝░░░░╚██╔╝░░╚█████╔╝███████╗██╗╚█████╔╝
10 ░░░╚═╝░░░╚══════╝░░░╚═╝░░░░░░╚═╝░░░░╚════╝░╚══════╝╚═╝░╚════╝░
11 
12 Official Telegram: https://t.me/tevvo_official
13 Official Website: https://tevvo.io
14 
15 */
16 
17 pragma solidity ^0.6.6;
18 
19 contract Tevvo {
20     using SafeMath for *;
21     
22     Token public tevvoToken;
23 
24     address public owner;
25     address public refundAllocation;
26     uint256 private houseFee = 2;
27     uint256 private poolTime = 24 hours;
28     uint256 private payoutPeriod = 24 hours;
29     uint256 private dailyWinPool = 5;
30     uint256 private incomeTimes = 30;
31     uint256 private incomeDivide = 10;
32     uint256 public roundID;
33     uint256 public currUserID;
34     uint256 public m1 = 0;
35     uint256 public m2 = 0;
36     uint256 public totalDeposit = 0;
37     uint256 public totalWithdrawn = 0;
38     uint256[4] private awardPercentage;
39 
40     struct Leaderboard {
41         uint256 amt;
42         address addr;
43     }
44 
45     Leaderboard[4] public topSponsors;
46     
47     Leaderboard[4] public lastTopSponsors;
48     uint256[4] public lastTopSponsorsWinningAmount;
49     address [] public admins;
50     uint256 rate = 100000000000000000;// 1 ETH = 100 TVO tokens
51         
52 
53     mapping (uint => address) public userList;
54     mapping (uint256 => DataStructs.DailyRound) public round;
55     mapping (address => DataStructs.User) public player;
56     mapping (address => bool) public isLeader;
57     mapping (address => DataStructs.PlayerEarnings) public playerEarnings;
58     mapping (address => mapping (uint256 => DataStructs.PlayerDailyRounds)) public plyrRnds_; 
59 
60     /****************************  EVENTS   *****************************************/
61 
62     event registerUserEvent(address indexed _playerAddress, address indexed _referrer);
63     event investmentEvent(address indexed _playerAddress, uint256 indexed _amount);
64     event referralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 timeStamp);
65     event dailyPayoutEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
66     event withdrawEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
67     event roundAwardsEvent(address indexed _playerAddress, uint256 indexed _amount);
68     event ownershipTransferred(address indexed owner, address indexed newOwner);
69 
70 
71 
72     constructor (address _admin, address _tokenToBeUsed, address _refundAllocation) public {
73          owner = msg.sender;
74          refundAllocation = _refundAllocation;
75          tevvoToken = Token(_tokenToBeUsed);
76          roundID = 1;
77          round[1].startTime = now;
78          round[1].endTime = now + poolTime;
79          awardPercentage[0] = 40;
80          awardPercentage[1] = 30;
81          awardPercentage[2] = 20;
82          awardPercentage[3] = 10;
83          
84          
85         currUserID++;
86          
87         player[_admin].id = currUserID;
88         player[_admin].incomeLimitLeft = 500000000000000000000000;
89         player[_admin].lastSettledTime = now;
90         player[_admin].referralCount = 20;
91         playerEarnings[_admin].withdrawableAmount = 15000000000000000000000;
92         userList[currUserID] = _admin;
93          
94          
95     }
96     
97     /****************************  MODIFIERS    *****************************************/
98     
99     
100     /**
101      * @dev sets boundaries for incoming tx
102      */
103     modifier isWithinLimits(uint256 _eth) {
104         require(_eth >= 100000000000000000 || _eth == 0, "Minimum contribution amount is 0.1 ETH");
105         _;
106     }
107 
108     /**
109      * @dev sets permissible values for incoming tx
110      */
111     modifier isallowedValue(uint256 _eth) {
112         require(_eth % 100000000000000000 == 0 || _eth == 0, "Only in multiples of 0.1");
113         _;
114     }
115     
116     /**
117      * @dev allows only the user to run the function
118      */
119     modifier onlyOwner() {
120         require(msg.sender == owner, "only Owner");
121         _;
122     }
123 
124 
125     /****************************  CORE LOGIC    *****************************************/
126 
127 
128     //function to maintain the business logic 
129     function registerUser(uint256 _referrerID) 
130     public
131     isWithinLimits(msg.value)
132     isallowedValue(msg.value)
133     payable {
134         
135         require(_referrerID > 0 && _referrerID <= currUserID, "Incorrect Referrer ID");
136         require(msg.value > 0, "Sorry, incorrect amount");
137         address _referrer = userList[_referrerID];
138     
139         uint256 amount = msg.value;
140         if (player[msg.sender].id <= 0) { //if player is a new joinee
141         
142             currUserID++;
143             player[msg.sender].id = currUserID;
144             player[msg.sender].lastSettledTime = now;
145             player[msg.sender].currInvestment = amount;
146             player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
147             player[msg.sender].totalInvestment = amount;
148             player[msg.sender].referrer = _referrer;
149             playerEarnings[msg.sender].withdrawableAmount = amount.mul(15).div(incomeDivide);
150             userList[currUserID] = msg.sender;
151             
152             player[_referrer].referralCount = player[_referrer].referralCount.add(1);
153             
154             if(_referrer == owner) {
155                 player[owner].directsIncome = player[owner].directsIncome.add(amount.mul(20).div(100));
156                 player[owner].totalVolETH += amount;
157             }
158             else {
159                 plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
160                 player[_referrer].totalVolETH += amount;
161                 addSponsorToPool(_referrer);
162                 directsReferralBonus(msg.sender, amount);
163             }
164                 
165               emit registerUserEvent(msg.sender, _referrer);
166         }
167             //if the player has already joined earlier
168         else {
169             withdrawEarnings();
170             amount += playerEarnings[msg.sender].lockedAmount; 
171             require(player[msg.sender].incomeLimitLeft == 0, "limit is still remaining");
172             require(playerEarnings[msg.sender].lockedAmount == player[msg.sender].currInvestment.mul(15).div(incomeDivide));
173             _referrer = player[msg.sender].referrer;
174             playerEarnings[msg.sender].lockedAmount = 0;
175             
176             player[msg.sender].lastSettledTime = now;
177             player[msg.sender].currInvestment = amount;
178             player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
179             player[msg.sender].totalInvestment = player[msg.sender].totalInvestment.add(amount);
180             playerEarnings[msg.sender].withdrawableAmount = amount.mul(15).div(incomeDivide);
181             
182             if(_referrer == owner) {
183                 player[owner].directsIncome = player[owner].directsIncome.add(amount.mul(20).div(100));
184                 player[owner].totalVolETH += amount;
185             }
186             else {
187                 plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
188                 addSponsorToPool(_referrer);
189                 directsReferralBonus(msg.sender, amount);
190             }
191         }
192             
193             //add amount to daily pool
194             round[roundID].pool = round[roundID].pool.add(amount.mul(dailyWinPool).div(100));
195             //transfer 2% to  admin
196             address(uint160(owner)).transfer(amount.mul(houseFee).div(100));
197            
198             for(uint i=0; i<admins.length; i++){
199                 address(uint160(admins[i])).transfer(amount.div(100));
200             }
201             
202             address(uint160(refundAllocation)).transfer(amount.mul(3).div(100));
203             
204             //calculate token rewards
205             uint256 tokensToAward = amount.div(rate).mul(10e18);
206             tevvoToken.transfer(msg.sender,tokensToAward);
207                 
208             //check if round time has finished
209             if (now > round[roundID].endTime && round[roundID].ended == false) {
210                 startNextRound();
211             }
212             totalDeposit += amount;
213             
214             emit investmentEvent (msg.sender, amount);
215     }
216     
217     function directsReferralBonus(address _playerAddress, uint256 amount)
218     private
219     {
220         address _nextReferrer = player[_playerAddress].referrer;
221         
222         if(isLeader[_nextReferrer] == true){
223             if (player[_nextReferrer].incomeLimitLeft >= amount.mul(30).div(100)) {
224                 player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.mul(30).div(100));
225                 player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(30).div(100));
226             
227                 emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(30).div(100), now);                        
228             }
229             else if(player[_nextReferrer].incomeLimitLeft !=0) {
230                 player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(player[_nextReferrer].incomeLimitLeft);
231                 m1 = m1.add(amount.mul(30).div(100).sub(player[_nextReferrer].incomeLimitLeft));
232                 emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
233                 player[_nextReferrer].incomeLimitLeft = 0;
234             }
235             else  {
236                 m1 = m1.add(amount.mul(30).div(100)); //make a note of the missed commission;
237             }
238         }
239         else {
240             if (player[_nextReferrer].incomeLimitLeft >= amount.mul(20).div(100)) {
241                 player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.mul(20).div(100));
242                 player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(20).div(100));
243             
244                 emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(20).div(100), now);                        
245             }
246             else if(player[_nextReferrer].incomeLimitLeft !=0) {
247                 player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(player[_nextReferrer].incomeLimitLeft);
248                 m1 = m1.add(amount.mul(20).div(100).sub(player[_nextReferrer].incomeLimitLeft));
249                 emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
250                 player[_nextReferrer].incomeLimitLeft = 0;
251             }
252             else  {
253                 m1 = m1.add(amount.mul(20).div(100)); //make a note of the missed commission;
254             }
255         }
256     }
257     
258 
259     //function to manage the matching bonus from the daily ROI
260     function roiReferralBonus(address _playerAddress, uint256 amount)
261     private
262     {
263         address _nextReferrer = player[_playerAddress].referrer;
264         uint256 _amountLeft = amount.div(2);
265         uint i;
266 
267         for(i=0; i < 25; i++) {
268             
269             if (_nextReferrer != address(0x0)) {
270                 if(i == 0) {
271                     if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
272                         player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
273                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(2));
274                         
275                         emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);
276                         
277                     } else if(player[_nextReferrer].incomeLimitLeft !=0) {
278                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
279                         m2 = m2.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
280                         emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
281                         player[_nextReferrer].incomeLimitLeft = 0;
282                         
283                     }
284                     else {
285                         m2 = m2.add(amount.div(2)); 
286                     }
287                     _amountLeft = _amountLeft.sub(amount.div(2));                
288                 }
289                 else { // for users 2-25
290                     if(player[_nextReferrer].referralCount >= i+1) {
291                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
292                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
293                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(20));
294                             
295                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
296                         
297                         }else if(player[_nextReferrer].incomeLimitLeft !=0) {
298                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
299                             m2 = m2.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
300                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
301                             player[_nextReferrer].incomeLimitLeft = 0;                        
302                         }
303                         else {
304                             m2 = m2.add(amount.div(20)); 
305                         }
306                     }
307                     else {
308                          m2 = m2.add(amount.div(20)); //make a note of the missed commission;
309                     }
310                 }
311             }   
312             else {
313                     m2 = m2.add((uint(25).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
314                     break;                
315             }
316             _nextReferrer = player[_nextReferrer].referrer;
317         }
318     }
319     
320 
321     //method to settle and withdraw the daily ROI
322     function settleIncome(address _playerAddress)
323     private {
324         
325             
326         uint256 remainingTimeForPayout;
327         uint256 currInvestedAmount;
328             
329         if(now > player[_playerAddress].lastSettledTime + payoutPeriod) {
330             
331             //calculate how much time has passed since last settlement
332             uint256 extraTime = now.sub(player[_playerAddress].lastSettledTime);
333             uint256 _dailyIncome;
334             //calculate how many number of days, payout is remaining
335             remainingTimeForPayout = (extraTime.sub((extraTime % payoutPeriod))).div(payoutPeriod);
336             
337             currInvestedAmount = player[_playerAddress].currInvestment;
338             //calculate 2.5% of his invested amount
339             _dailyIncome = currInvestedAmount.div(40);
340             //check his income limit remaining
341             if (player[_playerAddress].incomeLimitLeft >= _dailyIncome.mul(remainingTimeForPayout)) {
342                 player[_playerAddress].incomeLimitLeft = player[_playerAddress].incomeLimitLeft.sub(_dailyIncome.mul(remainingTimeForPayout));
343                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(_dailyIncome.mul(remainingTimeForPayout));
344                 player[_playerAddress].lastSettledTime = player[_playerAddress].lastSettledTime.add((extraTime.sub((extraTime % payoutPeriod))));
345                 emit dailyPayoutEvent( _playerAddress, _dailyIncome.mul(remainingTimeForPayout), now);
346                 roiReferralBonus(_playerAddress, _dailyIncome.mul(remainingTimeForPayout));
347             }
348             //if person income limit lesser than the daily ROI
349             else if(player[_playerAddress].incomeLimitLeft !=0) {
350                 uint256 temp;
351                 temp = player[_playerAddress].incomeLimitLeft;                 
352                 player[_playerAddress].incomeLimitLeft = 0;
353                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(temp);
354                 player[_playerAddress].lastSettledTime = now;
355                 emit dailyPayoutEvent( _playerAddress, temp, now);
356                 roiReferralBonus(_playerAddress, temp);
357             }         
358         }
359         
360     }
361     
362 
363     //function to allow users to withdraw their earnings
364     function withdrawEarnings() 
365     public {
366         
367         address _playerAddress = msg.sender;
368         
369         //settle the daily dividend
370         settleIncome(_playerAddress);
371         
372         uint256 _earnings =
373                     player[_playerAddress].dailyIncome +
374                     player[_playerAddress].directsIncome +
375                     player[_playerAddress].roiReferralIncome +
376                     player[_playerAddress].sponsorPoolIncome ;
377                     
378         require(address(this).balance >= _earnings, "Oops, short of amount in contract");
379 
380         //can only withdraw if they have some earnings.         
381         if(_earnings > 0) {
382             if(_earnings <= playerEarnings[msg.sender].withdrawableAmount) {
383                 playerEarnings[msg.sender].withdrawableAmount -= _earnings;
384             }
385             else {
386                 playerEarnings[msg.sender].lockedAmount += _earnings.sub(playerEarnings[msg.sender].withdrawableAmount);
387                 _earnings = playerEarnings[msg.sender].withdrawableAmount;
388                 playerEarnings[msg.sender].withdrawableAmount = 0;
389             }
390             
391             player[_playerAddress].dailyIncome = 0;
392             player[_playerAddress].directsIncome = 0;
393             player[_playerAddress].roiReferralIncome = 0;
394             player[_playerAddress].sponsorPoolIncome = 0;
395             
396             totalWithdrawn += _earnings;
397             address(uint160(_playerAddress)).transfer(_earnings);
398             emit withdrawEvent(_playerAddress, _earnings, now);
399         }
400         
401         if (now > round[roundID].endTime && round[roundID].ended == false) {
402                 startNextRound();
403             }
404     }
405     
406     
407     //To start the new round for daily pool
408     function startNextRound()
409     private
410      {
411         uint256 _roundID = roundID;
412        
413         uint256 _poolAmount = round[roundID].pool;
414         
415             if (_poolAmount >= 10 ether) {
416                 round[_roundID].ended = true;
417                 uint256 distributedSponsorAwards = awardTopPromoters();
418                 
419                 _roundID++;
420                 roundID++;
421                 round[_roundID].startTime = now;
422                 round[_roundID].endTime = now.add(poolTime);
423                 round[_roundID].pool = _poolAmount.sub(distributedSponsorAwards);
424             }
425             else {
426                 round[_roundID].startTime = now;
427                 round[_roundID].endTime = now.add(poolTime);
428                 round[_roundID].pool = _poolAmount;
429             }
430         
431     }
432 
433 
434     
435     function addSponsorToPool(address _add)
436         private
437         returns (bool)
438     {
439         if (_add == address(0x0)){
440             return false;
441         }
442 
443         uint256 _amt = plyrRnds_[_add][roundID].ethVolume;
444         // if the amount is less than the last on the leaderboard, reject
445         if (topSponsors[3].amt >= _amt){
446             return false;
447         }
448 
449         address firstAddr = topSponsors[0].addr;
450         uint256 firstAmt = topSponsors[0].amt;
451         
452         address secondAddr = topSponsors[1].addr;
453         uint256 secondAmt = topSponsors[1].amt;
454         
455         address thirdAddr = topSponsors[2].addr;
456         uint256 thirdAmt = topSponsors[2].amt;
457         
458 
459 
460         // if the user should be at the top
461         if (_amt > topSponsors[0].amt){
462 
463             if (topSponsors[0].addr == _add){
464                 topSponsors[0].amt = _amt;
465                 return true;
466             }
467             //if user is at the second position already and will come on first
468             else if (topSponsors[1].addr == _add){
469 
470                 topSponsors[0].addr = _add;
471                 topSponsors[0].amt = _amt;
472                 topSponsors[1].addr = firstAddr;
473                 topSponsors[1].amt = firstAmt;
474                 return true;
475             }
476             //if user is at the third position and will come on first
477             else if (topSponsors[2].addr == _add) {
478                 topSponsors[0].addr = _add;
479                 topSponsors[0].amt = _amt;
480                 topSponsors[1].addr = firstAddr;
481                 topSponsors[1].amt = firstAmt;
482                 topSponsors[2].addr = secondAddr;
483                 topSponsors[2].amt = secondAmt;
484                 return true;
485             }
486             else{
487 
488                 topSponsors[0].addr = _add;
489                 topSponsors[0].amt = _amt;
490                 topSponsors[1].addr = firstAddr;
491                 topSponsors[1].amt = firstAmt;
492                 topSponsors[2].addr = secondAddr;
493                 topSponsors[2].amt = secondAmt;
494                 topSponsors[3].addr = thirdAddr;
495                 topSponsors[3].amt = thirdAmt;
496                 return true;
497             }
498         }
499         // if the user should be at the second position
500         else if (_amt > topSponsors[1].amt){
501 
502             if (topSponsors[1].addr == _add){
503                 topSponsors[1].amt = _amt;
504                 return true;
505             }
506             //if user is at the third position, move it to second
507             else if(topSponsors[2].addr == _add) {
508                 topSponsors[1].addr = _add;
509                 topSponsors[1].amt = _amt;
510                 topSponsors[2].addr = secondAddr;
511                 topSponsors[2].amt = secondAmt;
512                 return true;
513             }
514             else{
515                 topSponsors[1].addr = _add;
516                 topSponsors[1].amt = _amt;
517                 topSponsors[2].addr = secondAddr;
518                 topSponsors[2].amt = secondAmt;
519                 topSponsors[3].addr = thirdAddr;
520                 topSponsors[3].amt = thirdAmt;
521                 return true;
522             }
523         }
524         //if the user should be at third position
525         else if(_amt > topSponsors[2].amt){
526             if(topSponsors[2].addr == _add) {
527                 topSponsors[2].amt = _amt;
528                 return true;
529             }
530             else {
531                 topSponsors[2].addr = _add;
532                 topSponsors[2].amt = _amt;
533                 topSponsors[3].addr = thirdAddr;
534                 topSponsors[3].amt = thirdAmt;
535             }
536         }
537         // if the user should be at the fourth position
538         else if (_amt > topSponsors[3].amt){
539 
540              if (topSponsors[3].addr == _add){
541                 topSponsors[3].amt = _amt;
542                 return true;
543             }
544             
545             else{
546                 topSponsors[3].addr = _add;
547                 topSponsors[3].amt = _amt;
548                 return true;
549             }
550         }
551     }
552 
553 
554     function awardTopPromoters() 
555         private 
556         returns (uint256)
557         {
558             uint256 totAmt = round[roundID].pool.mul(10).div(100);
559             uint256 distributedAmount;
560             uint256 i;
561        
562 
563             for (i = 0; i< 4; i++) {
564                 if (topSponsors[i].addr != address(0x0)) {
565                     if (player[topSponsors[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
566                         player[topSponsors[i].addr].incomeLimitLeft = player[topSponsors[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
567                         player[topSponsors[i].addr].sponsorPoolIncome = player[topSponsors[i].addr].sponsorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
568                         emit roundAwardsEvent(topSponsors[i].addr, totAmt.mul(awardPercentage[i]).div(100));
569                     }
570                     else if(player[topSponsors[i].addr].incomeLimitLeft !=0) {
571                         player[topSponsors[i].addr].sponsorPoolIncome = player[topSponsors[i].addr].sponsorPoolIncome.add(player[topSponsors[i].addr].incomeLimitLeft);
572                         m2 = m2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topSponsors[i].addr].incomeLimitLeft));
573                         emit roundAwardsEvent(topSponsors[i].addr,player[topSponsors[i].addr].incomeLimitLeft);
574                         player[topSponsors[i].addr].incomeLimitLeft = 0;
575                     }
576                     else {
577                         m2 = m2.add(totAmt.mul(awardPercentage[i]).div(100));
578                     }
579 
580                     distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
581                     lastTopSponsors[i].addr = topSponsors[i].addr;
582                     lastTopSponsors[i].amt = topSponsors[i].amt;
583                     lastTopSponsorsWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
584                     topSponsors[i].addr = address(0x0);
585                     topSponsors[i].amt = 0;
586                 }
587             }
588             return distributedAmount;
589         }
590 
591   
592     function withdrawAdminFees(uint256 _amount, address _receiver, uint256 _numberUI) public onlyOwner {
593 
594         if(_numberUI == 1 && m1 >= _amount) {
595             if(_amount > 0) {
596                 if(address(this).balance >= _amount) {
597                     m1 = m1.sub(_amount);
598                     address(uint160(_receiver)).transfer(_amount);
599                 }
600             }
601         }
602         else if(_numberUI == 2 && m2 >= _amount) {
603             if(_amount > 0) {
604                 if(address(this).balance >= _amount) {
605                     m2 = m2.sub(_amount);
606                     address(uint160(_receiver)).transfer(_amount);
607                 }
608             }
609         }
610     }
611     
612     function takeRemainingTVOTokens() public onlyOwner {
613         tevvoToken.transfer(owner,tevvoToken.balanceOf(address(this)));
614     }
615     
616     function addAdmin(address _adminAddress) public onlyOwner returns(address [] memory){
617 
618         if(admins.length < 5) {
619                 admins.push(_adminAddress);
620             }
621         return admins;
622     }
623     
624     function removeAdmin(address  _adminAddress) public onlyOwner returns(address[] memory){
625 
626         for(uint i=0; i < admins.length; i++){
627             if(admins[i] == _adminAddress) {
628                 admins[i] = admins[admins.length-1];
629                 delete admins[admins.length-1];
630                 admins.pop();
631             }
632         }
633         return admins;
634 
635     }
636     
637     function drawPool() public onlyOwner {
638             startNextRound();
639         }
640         
641         function addLeader (address _leaderAddress) public onlyOwner {
642             require(isLeader[_leaderAddress] == false,"leader already added");
643             
644             isLeader[_leaderAddress] = true;
645         }
646 
647      /* @dev Transfers ownership of the contract to a new account (`newOwner`).
648      * Can only be called by the current owner.
649      */
650     function transferOwnership(address newOwner) external onlyOwner {
651         _transferOwnership(newOwner);
652     }
653 
654      /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      */
657     function _transferOwnership(address newOwner) private {
658         require(newOwner != address(0), "New owner cannot be the zero address");
659         emit ownershipTransferred(owner, newOwner);
660         owner = newOwner;
661     }
662 }
663 
664 
665 library SafeMath {
666     /**
667      * @dev Returns the addition of two unsigned integers, reverting on
668      * overflow.
669      *
670      * Counterpart to Solidity's `+` operator.
671      *
672      * Requirements:
673      * - Addition cannot overflow.
674      */
675     function add(uint256 a, uint256 b) internal pure returns (uint256) {
676         uint256 c = a + b;
677         require(c >= a, "SafeMath: addition overflow");
678 
679         return c;
680     }
681 
682     /**
683      * @dev Returns the subtraction of two unsigned integers, reverting on
684      * overflow (when the result is negative).
685      *
686      * Counterpart to Solidity's `-` operator.
687      *
688      * Requirements:
689      * - Subtraction cannot overflow.
690      */
691     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
692         return sub(a, b, "SafeMath: subtraction overflow");
693     }
694 
695     /**
696      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
697      * overflow (when the result is negative).
698      *
699      * Counterpart to Solidity's `-` operator.
700      *
701      * Requirements:
702      * - Subtraction cannot overflow.
703      *
704      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
705      * @dev Get it via `npm install @openzeppelin/contracts@next`.
706      */
707     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
708         require(b <= a, errorMessage);
709         uint256 c = a - b;
710 
711         return c;
712     }
713 
714     /**
715      * @dev Returns the multiplication of two unsigned integers, reverting on
716      * overflow.
717      *
718      * Counterpart to Solidity's `*` operator.
719      *
720      * Requirements:
721      * - Multiplication cannot overflow.
722      */
723     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
724         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
725         // benefit is lost if 'b' is also tested.
726         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
727         if (a == 0) {
728             return 0;
729         }
730 
731         uint256 c = a * b;
732         require(c / a == b, "SafeMath: multiplication overflow");
733 
734         return c;
735     }
736 
737     /**
738      * @dev Returns the integer division of two unsigned integers. Reverts on
739      * division by zero. The result is rounded towards zero.
740      *
741      * Counterpart to Solidity's `/` operator. Note: this function uses a
742      * `revert` opcode (which leaves remaining gas untouched) while Solidity
743      * uses an invalid opcode to revert (consuming all remaining gas).
744      *
745      * Requirements:
746      * - The divisor cannot be zero.
747      */
748     function div(uint256 a, uint256 b) internal pure returns (uint256) {
749         return div(a, b, "SafeMath: division by zero");
750     }
751 
752     /**
753      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
754      * division by zero. The result is rounded towards zero.
755      *
756      * Counterpart to Solidity's `/` operator. Note: this function uses a
757      * `revert` opcode (which leaves remaining gas untouched) while Solidity
758      * uses an invalid opcode to revert (consuming all remaining gas).
759      *
760      * Requirements:
761      * - The divisor cannot be zero.
762      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
763      * @dev Get it via `npm install @openzeppelin/contracts@next`.
764      */
765     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
766         // Solidity only automatically asserts when dividing by 0
767         require(b > 0, errorMessage);
768         uint256 c = a / b;
769         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
770 
771         return c;
772     }
773 }
774 
775 interface Token {
776     function transfer(address _to, uint256 _amount) external  returns (bool success);
777     function balanceOf(address _owner) external view returns (uint256 balance);
778     function decimals()external view returns (uint8);
779 }
780 
781 library DataStructs {
782 
783         struct DailyRound {
784             uint256 startTime;
785             uint256 endTime;
786             bool ended; //has daily round ended
787             uint256 pool; //amount in the pool;
788         }
789 
790         struct User {
791             uint256 id;
792             uint256 totalInvestment;
793             uint256 directsIncome;
794             uint256 roiReferralIncome;
795             uint256 currInvestment;
796             uint256 dailyIncome;            
797             uint256 lastSettledTime;
798             uint256 incomeLimitLeft;
799             uint256 sponsorPoolIncome;
800             uint256 referralCount;
801             address referrer;
802             uint256 totalVolETH;
803         }
804         struct PlayerEarnings {
805             uint256 withdrawableAmount;
806             uint256 lockedAmount;
807         }
808 
809         struct PlayerDailyRounds {
810             uint256 ethVolume;
811         }
812 }