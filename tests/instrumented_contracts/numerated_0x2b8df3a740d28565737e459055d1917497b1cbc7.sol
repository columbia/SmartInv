1 pragma solidity ^0.5.17;
2 
3 /*
4 
5 ████████╗███████╗██╗░░░██╗██╗░░░██╗░█████╗░
6 ╚══██╔══╝██╔════╝██║░░░██║██║░░░██║██╔══██╗
7 ░░░██║░░░█████╗░░╚██╗░██╔╝╚██╗░██╔╝██║░░██║
8 ░░░██║░░░██╔══╝░░░╚████╔╝░░╚████╔╝░██║░░██║
9 ░░░██║░░░███████╗░░╚██╔╝░░░░╚██╔╝░░╚█████╔╝
10 ░░░╚═╝░░░╚══════╝░░░╚═╝░░░░░░╚═╝░░░░╚════╝░
11 Official Telegram: https://t.me/tevvo_official
12 Official Website: https://tevvo.io
13 */
14 
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, reverting on
18      * overflow.
19      *
20      * Counterpart to Solidity's `+` operator.
21      *
22      * Requirements:
23      * - Addition cannot overflow.
24      */
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28 
29         return c;
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, reverting on
34      * overflow (when the result is negative).
35      *
36      * Counterpart to Solidity's `-` operator.
37      *
38      * Requirements:
39      * - Subtraction cannot overflow.
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     /**
46      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
47      * overflow (when the result is negative).
48      *
49      * Counterpart to Solidity's `-` operator.
50      *
51      * Requirements:
52      * - Subtraction cannot overflow.
53      *
54      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
55      * @dev Get it via `npm install @openzeppelin/contracts@next`.
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
113      * @dev Get it via `npm install @openzeppelin/contracts@next`.
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 }
124 
125 interface Token {
126     function transfer(address _to, uint256 _amount) external  returns (bool success);
127     function balanceOf(address _owner) external view returns (uint256 balance);
128     function decimals()external view returns (uint8);
129 }
130 
131 library DataStructs {
132 
133         struct DailyRound {
134             uint256 startTime;
135             uint256 endTime;
136             bool ended; //has daily round ended
137             uint256 pool; //amount in the pool;
138         }
139 
140         struct User {
141             uint256 id;
142             uint256 totalInvestment;
143             uint256 directsIncome;
144             uint256 roiReferralIncome;
145             uint256 currInvestment;
146             uint256 dailyIncome;            
147             uint256 lastSettledTime;
148             uint256 incomeLimitLeft;
149             uint256 sponsorPoolIncome;
150             uint256 referralCount;
151             address referrer;
152         }
153 
154         struct PlayerDailyRounds {
155             uint256 ethVolume;
156         }
157 }
158 
159 contract Tevvo {
160     using SafeMath for *;
161     
162     Token public tevvoToken;
163 
164     address public owner;
165     uint256 private houseFee = 2;
166     uint256 private poolTime = 24 hours;
167     uint256 private payoutPeriod = 24 hours;
168     uint256 private dailyWinPool = 5;
169     uint256 private incomeTimes = 30;
170     uint256 private incomeDivide = 10;
171     uint256 public roundID;
172     uint256 public currUserID;
173     uint256 public m1 = 0;
174     uint256 public m2 = 0;
175     uint256[4] private awardPercentage;
176 
177     struct Leaderboard {
178         uint256 amt;
179         address addr;
180     }
181 
182     Leaderboard[4] public topSponsors;
183     
184     Leaderboard[4] public lastTopSponsors;
185     uint256[4] public lastTopSponsorsWinningAmount;
186     address [] public admins;
187     uint256 rate = 100000000000000000;// 1 ETH = 100 TVO tokens
188         
189 
190     mapping (uint => address) public userList;
191     mapping (uint256 => DataStructs.DailyRound) public round;
192     mapping (address => DataStructs.User) public player;
193     mapping (address => mapping (uint256 => DataStructs.PlayerDailyRounds)) public plyrRnds_; 
194 
195     /****************************  EVENTS   *****************************************/
196 
197     event registerUserEvent(address indexed _playerAddress, address indexed _referrer);
198     event investmentEvent(address indexed _playerAddress, uint256 indexed _amount);
199     event referralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 timeStamp);
200     event dailyPayoutEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
201     event withdrawEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
202     event superBonusEvent(address indexed _playerAddress, uint256 indexed _amount);
203     event roundAwardsEvent(address indexed _playerAddress, uint256 indexed _amount);
204     event ownershipTransferred(address indexed owner, address indexed newOwner);
205 
206 
207 
208     constructor (address _admin, address _tokenToBeUsed) public {
209          owner = _admin;
210          tevvoToken = Token(_tokenToBeUsed);
211          roundID = 1;
212          round[1].startTime = now;
213          round[1].endTime = now + poolTime;
214          awardPercentage[0] = 40;
215          awardPercentage[1] = 30;
216          awardPercentage[2] = 20;
217          awardPercentage[3] = 10;
218          
219          
220         currUserID++;
221          
222         player[owner].id = currUserID;
223         player[owner].incomeLimitLeft = 500000 ether;
224         player[owner].lastSettledTime = now;
225         player[owner].referralCount = 20;
226         userList[currUserID] = owner;
227          
228          
229     }
230     
231     /****************************  MODIFIERS    *****************************************/
232     
233     
234     /**
235      * @dev sets boundaries for incoming tx
236      */
237     modifier isWithinLimits(uint256 _eth) {
238         require(_eth >= 100000000000000000, "Minimum contribution amount is 0.1 ETH");
239         _;
240     }
241 
242     /**
243      * @dev sets permissible values for incoming tx
244      */
245     modifier isallowedValue(uint256 _eth) {
246         require(_eth % 100000000000000000 == 0, "Only in multiples of 0.1");
247         _;
248     }
249     
250     /**
251      * @dev allows only the user to run the function
252      */
253     modifier onlyOwner() {
254         require(msg.sender == owner, "only Owner");
255         _;
256     }
257 
258 
259     /****************************  CORE LOGIC    *****************************************/
260 
261 
262     //if someone accidently sends eth to contract address
263     function () external payable {
264         registerUser(1);
265     }
266 
267 
268     //function to maintain the business logic 
269     function registerUser(uint256 _referrerID) 
270     public
271     isWithinLimits(msg.value)
272     isallowedValue(msg.value)
273     payable {
274         
275         require(_referrerID > 0 && _referrerID <= currUserID, "Incorrect Referrer ID");
276         address _referrer = userList[_referrerID];
277     
278         uint256 amount = msg.value;
279         if (player[msg.sender].id <= 0) { //if player is a new joinee
280         
281             currUserID++;
282             player[msg.sender].id = currUserID;
283             player[msg.sender].lastSettledTime = now;
284             player[msg.sender].currInvestment = amount;
285             player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
286             player[msg.sender].totalInvestment = amount;
287             player[msg.sender].referrer = _referrer;
288             userList[currUserID] = msg.sender;
289             
290             player[_referrer].referralCount = player[_referrer].referralCount.add(1);
291             
292             if(_referrer == owner) {
293                 player[owner].directsIncome = player[owner].directsIncome.add(amount.mul(15).div(100));
294                 for(uint i=0; i<admins.length; i++) {
295                     player[admins[i]].directsIncome = player[admins[i]].directsIncome.add(amount.mul(15).div(400));
296                 }
297             }
298             else {
299                 plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
300                 addSponsorToPool(_referrer);
301                 directsReferralBonus(msg.sender, amount);
302             }
303                 
304               emit registerUserEvent(msg.sender, _referrer);
305         }
306             //if the player has already joined earlier
307         else {
308             require(player[msg.sender].incomeLimitLeft == 0, "limit is still remaining");
309             require(amount >= player[msg.sender].currInvestment, "Cannot invest lesser amount");
310             _referrer = player[msg.sender].referrer;
311             
312             player[msg.sender].lastSettledTime = now;
313             player[msg.sender].currInvestment = amount;
314             player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
315             player[msg.sender].totalInvestment = player[msg.sender].totalInvestment.add(amount);
316             
317             if(_referrer == owner) {
318                 player[owner].directsIncome = player[owner].directsIncome.add(amount.mul(15).div(100));
319                 for(uint i=0; i<admins.length; i++) {
320                     player[admins[i]].directsIncome = player[admins[i]].directsIncome.add(amount.mul(15).div(400));
321                 }
322             }
323             else {
324                 plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
325                 addSponsorToPool(_referrer);
326                 directsReferralBonus(msg.sender, amount);
327             }
328         }
329             
330             //add amount to daily pool
331             round[roundID].pool = round[roundID].pool.add(amount.mul(dailyWinPool).div(100));
332             //transfer 2% to main admin
333             player[owner].dailyIncome = player[owner].dailyIncome.add(amount.mul(houseFee).div(100));
334             //transfer 1% to other 4 admins
335             for(uint i=0; i<admins.length; i++){
336                 player[admins[i]].dailyIncome = player[admins[i]].dailyIncome.add(amount.div(100));
337             }
338             //calculate token rewards
339             uint256 tokensToAward = amount.div(rate).mul(10e18);
340             tevvoToken.transfer(msg.sender,tokensToAward);
341                 
342             //check if round time has finished
343             if (now > round[roundID].endTime && round[roundID].ended == false) {
344                 startNextRound();
345             }
346             
347             emit investmentEvent (msg.sender, amount);
348     }
349 
350 
351     function directsReferralBonus(address _playerAddress, uint256 amount)
352     private
353     {
354         address _nextReferrer = player[_playerAddress].referrer;
355         
356         if(player[_nextReferrer].id <=15){
357             if (player[_nextReferrer].incomeLimitLeft >= amount.mul(30).div(100)) {
358                 player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.mul(30).div(100));
359                 player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(30).div(100));
360             
361                 emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(30).div(100), now);                        
362             }
363             else if(player[_nextReferrer].incomeLimitLeft !=0) {
364                 player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(player[_nextReferrer].incomeLimitLeft);
365                 m1 = m1.add(amount.mul(30).div(100).sub(player[_nextReferrer].incomeLimitLeft));
366                 emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
367                 player[_nextReferrer].incomeLimitLeft = 0;
368             }
369             else  {
370                 m1 = m1.add(amount.mul(30).div(100)); //make a note of the missed commission;
371             }
372         }
373         else {
374             if (player[_nextReferrer].incomeLimitLeft >= amount.mul(20).div(100)) {
375                 player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.mul(20).div(100));
376                 player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(20).div(100));
377             
378                 emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(20).div(100), now);                        
379             }
380             else if(player[_nextReferrer].incomeLimitLeft !=0) {
381                 player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(player[_nextReferrer].incomeLimitLeft);
382                 m1 = m1.add(amount.mul(20).div(100).sub(player[_nextReferrer].incomeLimitLeft));
383                 emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
384                 player[_nextReferrer].incomeLimitLeft = 0;
385             }
386             else  {
387                 m1 = m1.add(amount.mul(20).div(100)); //make a note of the missed commission;
388             }
389         }
390     }
391     
392     
393 
394     //function to manage the matching bonus from the daily ROI
395     function roiReferralBonus(address _playerAddress, uint256 amount)
396     private
397     {
398         address _nextReferrer = player[_playerAddress].referrer;
399         uint256 _amountLeft = amount.div(2);
400         uint i;
401 
402         for(i=0; i < 25; i++) {
403             
404             if (_nextReferrer != address(0x0)) {
405                 if(i == 0) {
406                     if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
407                         player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
408                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(2));
409                         
410                         emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);
411                         
412                     } else if(player[_nextReferrer].incomeLimitLeft !=0) {
413                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
414                         m2 = m2.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
415                         emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
416                         player[_nextReferrer].incomeLimitLeft = 0;
417                         
418                     }
419                     else {
420                         m2 = m2.add(amount.div(2)); 
421                     }
422                     _amountLeft = _amountLeft.sub(amount.div(2));                
423                 }
424                 else { // for users 2-25
425                     if(player[_nextReferrer].referralCount >= i+1) {
426                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
427                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
428                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(20));
429                             
430                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
431                         
432                         }else if(player[_nextReferrer].incomeLimitLeft !=0) {
433                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
434                             m2 = m2.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
435                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
436                             player[_nextReferrer].incomeLimitLeft = 0;                        
437                         }
438                         else {
439                             m2 = m2.add(amount.div(20)); 
440                         }
441                     }
442                     else {
443                          m2 = m2.add(amount.div(20)); //make a note of the missed commission;
444                     }
445                 }
446             }   
447             else {
448                     m2 = m2.add((uint(25).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
449                     break;                
450             }
451             _nextReferrer = player[_nextReferrer].referrer;
452         }
453     }
454     
455 
456     //method to settle and withdraw the daily ROI
457     function settleIncome(address _playerAddress)
458     private {
459         
460             
461         uint256 remainingTimeForPayout;
462         uint256 currInvestedAmount;
463             
464         if(now > player[_playerAddress].lastSettledTime + payoutPeriod) {
465             
466             //calculate how much time has passed since last settlement
467             uint256 extraTime = now.sub(player[_playerAddress].lastSettledTime);
468             uint256 _dailyIncome;
469             //calculate how many number of days, payout is remaining
470             remainingTimeForPayout = (extraTime.sub((extraTime % payoutPeriod))).div(payoutPeriod);
471             
472             currInvestedAmount = player[_playerAddress].currInvestment;
473             //calculate 2.5% of his invested amount
474             _dailyIncome = currInvestedAmount.div(40);
475             //check his income limit remaining
476             if (player[_playerAddress].incomeLimitLeft >= _dailyIncome.mul(remainingTimeForPayout)) {
477                 player[_playerAddress].incomeLimitLeft = player[_playerAddress].incomeLimitLeft.sub(_dailyIncome.mul(remainingTimeForPayout));
478                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(_dailyIncome.mul(remainingTimeForPayout));
479                 player[_playerAddress].lastSettledTime = player[_playerAddress].lastSettledTime.add((extraTime.sub((extraTime % payoutPeriod))));
480                 emit dailyPayoutEvent( _playerAddress, _dailyIncome.mul(remainingTimeForPayout), now);
481                 roiReferralBonus(_playerAddress, _dailyIncome.mul(remainingTimeForPayout));
482             }
483             //if person income limit lesser than the daily ROI
484             else if(player[_playerAddress].incomeLimitLeft !=0) {
485                 uint256 temp;
486                 temp = player[_playerAddress].incomeLimitLeft;                 
487                 player[_playerAddress].incomeLimitLeft = 0;
488                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(temp);
489                 player[_playerAddress].lastSettledTime = now;
490                 emit dailyPayoutEvent( _playerAddress, temp, now);
491                 roiReferralBonus(_playerAddress, temp);
492             }         
493         }
494         
495     }
496     
497 
498     //function to allow users to withdraw their earnings
499     function withdrawEarnings() 
500     public {
501         
502         address _playerAddress = msg.sender;
503         
504         //settle the daily dividend
505         settleIncome(_playerAddress);
506         
507         uint256 _earnings =
508                     player[_playerAddress].dailyIncome +
509                     player[_playerAddress].directsIncome +
510                     player[_playerAddress].roiReferralIncome +
511                     player[_playerAddress].sponsorPoolIncome ;
512 
513         //can only withdraw if they have some earnings.         
514         if(_earnings > 0) {
515             require(address(this).balance >= _earnings, "Contract doesn't have sufficient amount to give you");
516 
517             player[_playerAddress].dailyIncome = 0;
518             player[_playerAddress].directsIncome = 0;
519             player[_playerAddress].roiReferralIncome = 0;
520             player[_playerAddress].sponsorPoolIncome = 0;
521             
522             address(uint160(_playerAddress)).transfer(_earnings);
523             emit withdrawEvent(_playerAddress, _earnings, now);
524         }
525     }
526     
527     
528     //To start the new round for daily pool
529     function startNextRound()
530     private
531      {
532         uint256 _roundID = roundID;
533        
534         uint256 _poolAmount = round[roundID].pool;
535         
536             if (_poolAmount >= 10 ether) {
537                 round[_roundID].ended = true;
538                 uint256 distributedSponsorAwards = awardTopPromoters();
539                 
540                 _roundID++;
541                 roundID++;
542                 round[_roundID].startTime = now;
543                 round[_roundID].endTime = now.add(poolTime);
544                 round[_roundID].pool = _poolAmount.sub(distributedSponsorAwards);
545             }
546             else {
547                 round[_roundID].startTime = now;
548                 round[_roundID].endTime = now.add(poolTime);
549                 round[_roundID].pool = _poolAmount;
550             }
551         
552     }
553 
554 
555     
556     function addSponsorToPool(address _add)
557         private
558         returns (bool)
559     {
560         if (_add == address(0x0)){
561             return false;
562         }
563 
564         uint256 _amt = plyrRnds_[_add][roundID].ethVolume;
565         // if the amount is less than the last on the leaderboard, reject
566         if (topSponsors[3].amt >= _amt){
567             return false;
568         }
569 
570         address firstAddr = topSponsors[0].addr;
571         uint256 firstAmt = topSponsors[0].amt;
572         
573         address secondAddr = topSponsors[1].addr;
574         uint256 secondAmt = topSponsors[1].amt;
575         
576         address thirdAddr = topSponsors[2].addr;
577         uint256 thirdAmt = topSponsors[2].amt;
578         
579 
580 
581         // if the user should be at the top
582         if (_amt > topSponsors[0].amt){
583 
584             if (topSponsors[0].addr == _add){
585                 topSponsors[0].amt = _amt;
586                 return true;
587             }
588             //if user is at the second position already and will come on first
589             else if (topSponsors[1].addr == _add){
590 
591                 topSponsors[0].addr = _add;
592                 topSponsors[0].amt = _amt;
593                 topSponsors[1].addr = firstAddr;
594                 topSponsors[1].amt = firstAmt;
595                 return true;
596             }
597             //if user is at the third position and will come on first
598             else if (topSponsors[2].addr == _add) {
599                 topSponsors[0].addr = _add;
600                 topSponsors[0].amt = _amt;
601                 topSponsors[1].addr = firstAddr;
602                 topSponsors[1].amt = firstAmt;
603                 topSponsors[2].addr = secondAddr;
604                 topSponsors[2].amt = secondAmt;
605                 return true;
606             }
607             else{
608 
609                 topSponsors[0].addr = _add;
610                 topSponsors[0].amt = _amt;
611                 topSponsors[1].addr = firstAddr;
612                 topSponsors[1].amt = firstAmt;
613                 topSponsors[2].addr = secondAddr;
614                 topSponsors[2].amt = secondAmt;
615                 topSponsors[3].addr = thirdAddr;
616                 topSponsors[3].amt = thirdAmt;
617                 return true;
618             }
619         }
620         // if the user should be at the second position
621         else if (_amt > topSponsors[1].amt){
622 
623             if (topSponsors[1].addr == _add){
624                 topSponsors[1].amt = _amt;
625                 return true;
626             }
627             //if user is at the third position, move it to second
628             else if(topSponsors[2].addr == _add) {
629                 topSponsors[1].addr = _add;
630                 topSponsors[1].amt = _amt;
631                 topSponsors[2].addr = secondAddr;
632                 topSponsors[2].amt = secondAmt;
633                 return true;
634             }
635             else{
636                 topSponsors[1].addr = _add;
637                 topSponsors[1].amt = _amt;
638                 topSponsors[2].addr = secondAddr;
639                 topSponsors[2].amt = secondAmt;
640                 topSponsors[3].addr = thirdAddr;
641                 topSponsors[3].amt = thirdAmt;
642                 return true;
643             }
644         }
645         //if the user should be at third position
646         else if(_amt > topSponsors[2].amt){
647             if(topSponsors[2].addr == _add) {
648                 topSponsors[2].amt = _amt;
649                 return true;
650             }
651             else {
652                 topSponsors[2].addr = _add;
653                 topSponsors[2].amt = _amt;
654                 topSponsors[3].addr = thirdAddr;
655                 topSponsors[3].amt = thirdAmt;
656             }
657         }
658         // if the user should be at the fourth position
659         else if (_amt > topSponsors[3].amt){
660 
661              if (topSponsors[3].addr == _add){
662                 topSponsors[3].amt = _amt;
663                 return true;
664             }
665             
666             else{
667                 topSponsors[3].addr = _add;
668                 topSponsors[3].amt = _amt;
669                 return true;
670             }
671         }
672     }
673 
674 
675     function awardTopPromoters() 
676         private 
677         returns (uint256)
678         {
679             uint256 totAmt = round[roundID].pool.mul(10).div(100);
680             uint256 distributedAmount;
681             uint256 i;
682        
683 
684             for (i = 0; i< 4; i++) {
685                 if (topSponsors[i].addr != address(0x0)) {
686                     if (player[topSponsors[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
687                         player[topSponsors[i].addr].incomeLimitLeft = player[topSponsors[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
688                         player[topSponsors[i].addr].sponsorPoolIncome = player[topSponsors[i].addr].sponsorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
689                         emit roundAwardsEvent(topSponsors[i].addr, totAmt.mul(awardPercentage[i]).div(100));
690                     }
691                     else if(player[topSponsors[i].addr].incomeLimitLeft !=0) {
692                         player[topSponsors[i].addr].sponsorPoolIncome = player[topSponsors[i].addr].sponsorPoolIncome.add(player[topSponsors[i].addr].incomeLimitLeft);
693                         m2 = m2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topSponsors[i].addr].incomeLimitLeft));
694                         emit roundAwardsEvent(topSponsors[i].addr,player[topSponsors[i].addr].incomeLimitLeft);
695                         player[topSponsors[i].addr].incomeLimitLeft = 0;
696                     }
697                     else {
698                         m2 = m2.add(totAmt.mul(awardPercentage[i]).div(100));
699                     }
700 
701                     distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
702                     lastTopSponsors[i].addr = topSponsors[i].addr;
703                     lastTopSponsors[i].amt = topSponsors[i].amt;
704                     lastTopSponsorsWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
705                     topSponsors[i].addr = address(0x0);
706                     topSponsors[i].amt = 0;
707                 }
708             }
709             return distributedAmount;
710         }
711 
712   
713     function withdrawAdminFees(uint256 _amount, address _receiver, uint256 _numberUI) public onlyOwner {
714 
715         if(_numberUI == 1 && m1 >= _amount) {
716             if(_amount > 0) {
717                 if(address(this).balance >= _amount) {
718                     m1 = m1.sub(_amount);
719                     address(uint160(_receiver)).transfer(_amount);
720                 }
721             }
722         }
723         else if(_numberUI == 2 && m2 >= _amount) {
724             if(_amount > 0) {
725                 if(address(this).balance >= _amount) {
726                     m2 = m2.sub(_amount);
727                     address(uint160(_receiver)).transfer(_amount);
728                 }
729             }
730         }
731     }
732     
733     function takeRemainingTokens() public onlyOwner {
734         tevvoToken.transfer(owner,tevvoToken.balanceOf(address(this)));
735     }
736     
737     function addAdmin(address _adminAddress) public onlyOwner returns(address [] memory){
738 
739         if(admins.length < 4) {
740                 admins.push(_adminAddress);
741             }
742         return admins;
743     }
744     
745     function removeAdmin(address  _adminAddress) public onlyOwner returns(address[] memory){
746 
747         for(uint i=0; i < admins.length; i++){
748             if(admins[i] == _adminAddress) {
749                 admins[i] = admins[admins.length-1];
750                 delete admins[admins.length-1];
751                 admins.length--;
752             }
753         }
754         return admins;
755 
756     }
757 
758      /* @dev Transfers ownership of the contract to a new account (`newOwner`).
759      * Can only be called by the current owner.
760      */
761     function transferOwnership(address newOwner) external onlyOwner {
762         _transferOwnership(newOwner);
763     }
764 
765      /**
766      * @dev Transfers ownership of the contract to a new account (`newOwner`).
767      */
768     function _transferOwnership(address newOwner) private {
769         require(newOwner != address(0), "New owner cannot be the zero address");
770         emit ownershipTransferred(owner, newOwner);
771         owner = newOwner;
772     }
773 }