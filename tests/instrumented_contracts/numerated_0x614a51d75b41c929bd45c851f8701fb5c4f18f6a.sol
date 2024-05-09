1 /**
2  *Submitted for verification at Ether5.net on 2020-09-07
3 */
4 
5 /**
6   *
7   * Designed by Team Brave
8   * Developed by Advanced Smart Contract Concepts                                                                                                                                                       
9   * Tested and verified by Drexyl, X99, and blockgh0st 
10   * Translated into 10+ languages by Josh Barton
11   * 
12   * A big thank you to the entire development team for making this possible!
13   * 
14   * Divvy Club is a simple and straightforward crowsdharing smart contract designed around:
15   * 1. Daily 5% divident payouts to each participant
16   * 2. Direct referral comissions for every referral
17   * 3. International participation and platform accessibility
18   * 4. FUll transparency and zero dev interaction once launched
19   *
20   *
21   * Enjoy!
22   *
23   * 
24   * Website: www.ether5.net
25 *** Official Telegram Channel: https://t.me/Ether5_Daily
26 *** Made with YC by Team Brave
27   *
28   */
29 
30 pragma solidity ^0.5.11;
31 
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, reverting on
35      * overflow.
36      *
37      * Counterpart to Solidity's `+` operator.
38      *
39      * Requirements:
40      * - Addition cannot overflow.
41      */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      *
71      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
72      * @dev Get it via `npm install @openzeppelin/contracts@next`.
73      */
74     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82      * @dev Returns the multiplication of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `*` operator.
86      *
87      * Requirements:
88      * - Multiplication cannot overflow.
89      */
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92         // benefit is lost if 'b' is also tested.
93         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      */
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         return div(a, b, "SafeMath: division by zero");
117     }
118 
119     /**
120      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
121      * division by zero. The result is rounded towards zero.
122      *
123      * Counterpart to Solidity's `/` operator. Note: this function uses a
124      * `revert` opcode (which leaves remaining gas untouched) while Solidity
125      * uses an invalid opcode to revert (consuming all remaining gas).
126      *
127      * Requirements:
128      * - The divisor cannot be zero.
129      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
130      * @dev Get it via `npm install @openzeppelin/contracts@next`.
131      */
132     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         // Solidity only automatically asserts when dividing by 0
134         require(b > 0, errorMessage);
135         uint256 c = a / b;
136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137 
138         return c;
139     }
140 }
141 
142 library DataStructs {
143 
144         struct DailyRound {
145             uint256 startTime;
146             uint256 endTime;
147             bool ended; //has daily round ended
148             uint256 pool; //amount in the pool;
149         }
150 
151         struct Player {
152             uint256 totalInvestment;
153             uint256 totalVolumeEth;
154             uint256 eventVariable;
155             uint256 directReferralIncome;
156             uint256 roiReferralIncome;
157             uint256 currentInvestedAmount;
158             uint256 dailyIncome;            
159             uint256 lastSettledTime;
160             uint256 incomeLimitLeft;
161             uint256 investorPoolIncome;
162             uint256 sponsorPoolIncome;
163             uint256 superIncome;
164             uint256 referralCount;
165             address referrer;
166         }
167 
168         struct PlayerDailyRounds {
169             uint256 selfInvestment; 
170             uint256 ethVolume; 
171         }
172 }
173 
174 contract Ether5 {
175     using SafeMath for *;
176 
177     address public  owner;
178     address public  roundStarter;
179     uint256 private houseFee = 18;
180     uint256 private poolTime = 24 hours;
181     uint256 private payoutPeriod = 24 hours;
182     uint256 private dailyWinPool = 10;
183     uint256 private incomeTimes  = 30;
184     uint256 private incomeDivide = 10;
185     uint256 public  roundID;
186     uint256 public  r1 = 0;
187     uint256 public  r2 = 0;
188     uint256 public  r3 = 0;
189     uint256[3] private awardPercentage;
190 
191     mapping (uint => uint) public CYCLE_PRICE;
192     mapping (address => bool) public playerExist;
193     mapping (uint256 => DataStructs.DailyRound) public round;
194     mapping (address => DataStructs.Player) public player;
195     mapping (address => mapping (uint256 => DataStructs.PlayerDailyRounds)) public plyrRnds_; 
196 
197     /****************************  EVENTS   *****************************************/
198 
199     event registerUserEvent(address indexed _playerAddress, address indexed _referrer);
200     event investmentEvent(address indexed _playerAddress, uint256 indexed _amount);
201     event referralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 timeStamp);
202     event dailyPayoutEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
203     event withdrawEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
204     event ownershipTransferred(address indexed owner, address indexed newOwner);
205 
206     constructor (address _roundStarter) public {
207          owner = msg.sender;
208          roundStarter = _roundStarter;
209          roundID = 1;
210          round[1].startTime = now;
211          round[1].endTime = now + poolTime;
212          awardPercentage[0] = 50;
213          awardPercentage[1] = 30;
214          awardPercentage[2] = 20;
215     }
216     
217     /****************************  MODIFIERS    *****************************************/
218     
219     
220     /**
221      * @dev sets boundaries for incoming tx
222      */
223     modifier isWithinLimits(uint256 _eth) {
224         require(_eth >= 100000000000000000, "Minimum contribution amount is 0.1 ETH");
225         _;
226     }
227 
228     /**
229      * @dev sets permissible values for incoming tx
230      */
231     modifier isallowedValue(uint256 _eth) {
232         require(_eth % 100000000000000000 == 0, "Amount should be in multiple of 0.1 ETH please");
233         _;
234     }
235     
236     /**
237      * @dev allows only the user to run the function
238      */
239     modifier onlyOwner() {
240         require(msg.sender == owner, "only Owner");
241         _;
242     }
243 
244 
245     /****************************  CORE LOGIC    *****************************************/
246 
247 
248     //if someone accidently sends eth to contract address
249     function () external payable {
250         playGame(address(0x0));
251     }
252 
253 
254 
255    
256     function playGame(address _referrer) 
257     public
258     isWithinLimits(msg.value)
259     isallowedValue(msg.value)
260     payable {
261 
262         uint256 amount = msg.value;
263         if (playerExist[msg.sender] == false) { 
264 
265             player[msg.sender].lastSettledTime = now;
266             player[msg.sender].currentInvestedAmount = amount;
267             player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
268             player[msg.sender].totalInvestment = amount;
269             player[msg.sender].eventVariable = 100 ether;
270             playerExist[msg.sender] = true;
271             
272             //update player's investment in current round
273             plyrRnds_[msg.sender][roundID].selfInvestment = plyrRnds_[msg.sender][roundID].selfInvestment.add(amount);
274 
275             if(
276                 // is this a referred purchase?
277                 _referrer != address(0x0) && 
278                 
279                 //self referrer not allowed
280                 _referrer != msg.sender &&
281                 
282                 //referrer exists?
283                 playerExist[_referrer] == true
284               ) {
285                     player[msg.sender].referrer = _referrer;
286                     player[_referrer].referralCount = player[_referrer].referralCount.add(1);
287                     player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
288                     plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
289                     
290                     referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
291                 }
292               else {
293                   r1 = r1.add(amount.mul(20).div(100));
294                   _referrer = address(0x0);
295                 }
296               emit registerUserEvent(msg.sender, _referrer);
297             }
298             
299             //if the player has already joined earlier
300             else {
301                 
302                 require(player[msg.sender].incomeLimitLeft == 0, "Oops your limit is still remaining");
303                 require(amount >= player[msg.sender].currentInvestedAmount, "Cannot invest lesser amount");
304                 
305                     
306                 player[msg.sender].lastSettledTime = now;
307                 player[msg.sender].currentInvestedAmount = amount;
308                 player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
309                 player[msg.sender].totalInvestment = player[msg.sender].totalInvestment.add(amount);
310                     
311                 //update player's investment in current round
312                 plyrRnds_[msg.sender][roundID].selfInvestment = plyrRnds_[msg.sender][roundID].selfInvestment.add(amount);
313 
314                 if(
315                     // is this a referred purchase?
316                     _referrer != address(0x0) && 
317                     // self referrer not allowed
318                     _referrer != msg.sender &&
319                     //does the referrer exist?
320                     playerExist[_referrer] == true
321                     )
322                     {
323                         //if the user has already been referred by someone previously, can't be referred by someone else
324                         if(player[msg.sender].referrer != address(0x0))
325                             _referrer = player[msg.sender].referrer;
326                         else {
327                             player[msg.sender].referrer = _referrer;
328                             player[_referrer].referralCount = player[_referrer].referralCount.add(1);
329                        }
330                             
331                         player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
332                         plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
333 
334                         //assign the referral commission to all.
335                         referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
336                     }
337                     //might be possible that the referrer is 0x0 but previously someone has referred the user                    
338                     else if(
339                         //0x0 coming from the UI
340                         _referrer == address(0x0) &&
341                         //check if the someone has previously referred the user
342                         player[msg.sender].referrer != address(0x0)
343                         ) {
344                             _referrer = player[msg.sender].referrer;                             
345                             plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
346                             player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
347 
348                             //assign the referral commission to all.
349                             referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
350                           }
351                     else {
352                           //no referrer, neither was previously used, nor has used now.
353                           r1 = r1.add(amount.mul(20).div(100));
354                         }
355             }
356             
357             round[roundID].pool = round[roundID].pool.add(amount.mul(dailyWinPool).div(100));
358             player[owner].dailyIncome = player[owner].dailyIncome.add(amount.mul(houseFee).div(100));
359             r3 = r3.add(amount.mul(5).div(100));
360             emit investmentEvent (msg.sender, amount);
361             
362     }
363     
364     function referralBonusTransferDirect(address _playerAddress, uint256 amount)
365     private
366     {
367         address _nextReferrer = player[_playerAddress].referrer;
368         uint256 _amountLeft = amount.mul(60).div(100);
369         uint i;
370 
371         for(i=0; i < 10; i++) {
372             
373             if (_nextReferrer != address(0x0)) {
374                 //referral commission to level 1
375                 if(i == 0) {
376                     if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
377                         player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
378                         player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(2));
379                         //This event will be used to get the total referral commission of a person, no need for extra variable
380                         emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);                        
381                     }
382                     else if(player[_nextReferrer].incomeLimitLeft !=0) {
383                         player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
384                         r1 = r1.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
385                         emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
386                         player[_nextReferrer].incomeLimitLeft = 0;
387                     }
388                     else  {
389                         r1 = r1.add(amount.div(2)); 
390                     }
391                     _amountLeft = _amountLeft.sub(amount.div(2));
392                 }
393                 
394                 else if(i == 1 ) {
395                     if(player[_nextReferrer].referralCount >= 2) {
396                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(10)) {
397                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(10));
398                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(10));
399                             
400                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(10), now);                        
401                         }
402                         else if(player[_nextReferrer].incomeLimitLeft !=0) {
403                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
404                             r1 = r1.add(amount.div(10).sub(player[_nextReferrer].incomeLimitLeft));
405                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
406                             player[_nextReferrer].incomeLimitLeft = 0;
407                         }
408                         else  {
409                             r1 = r1.add(amount.div(10)); 
410                         }
411                     }
412                     else{
413                         r1 = r1.add(amount.div(10)); 
414                     }
415                     _amountLeft = _amountLeft.sub(amount.div(10));
416                 }
417                 //referral commission from level 3-10
418                 else {
419                     if(player[_nextReferrer].referralCount >= i+1) {
420                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
421                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
422                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(20));
423                             
424                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
425                     
426                         }
427                         else if(player[_nextReferrer].incomeLimitLeft !=0) {
428                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
429                             r1 = r1.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
430                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
431                             player[_nextReferrer].incomeLimitLeft = 0;                    
432                         }
433                         else  {
434                             r1 = r1.add(amount.div(20)); 
435                         }
436                     }
437                     else {
438                         r1 = r1.add(amount.div(20)); 
439                     }
440                 }
441             }
442             else {
443                 r1 = r1.add((uint(10).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
444                 break;
445             }
446             _nextReferrer = player[_nextReferrer].referrer;
447         }
448     }
449     
450 
451     
452     function referralBonusTransferDailyROI(address _playerAddress, uint256 amount)
453     private
454     {
455         address _nextReferrer = player[_playerAddress].referrer;
456         uint256 _amountLeft = amount.div(2);
457         uint i;
458 
459         for(i=0; i < 20; i++) {
460             
461             if (_nextReferrer != address(0x0)) {
462                 if(i == 0) {
463                     if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
464                         player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
465                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(2));
466                         
467                         emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);
468                         
469                     } else if(player[_nextReferrer].incomeLimitLeft !=0) {
470                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
471                         r2 = r2.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
472                         emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
473                         player[_nextReferrer].incomeLimitLeft = 0;
474                         
475                     }
476                     else {
477                         r2 = r2.add(amount.div(2)); 
478                     }
479                     _amountLeft = _amountLeft.sub(amount.div(2));                
480                 }
481                 else { // for users 2-20
482                     if(player[_nextReferrer].referralCount >= i+1) {
483                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
484                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
485                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(20));
486                             
487                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
488                         
489                         }else if(player[_nextReferrer].incomeLimitLeft !=0) {
490                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
491                             r2 = r2.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
492                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
493                             player[_nextReferrer].incomeLimitLeft = 0;                        
494                         }
495                         else {
496                             r2 = r2.add(amount.div(20)); 
497                         }
498                     }
499                     else {
500                          r2 = r2.add(amount.div(20)); //make a note of the missed commission;
501                     }
502                 }
503             }   
504             else {
505                 if(i==0){
506                     r2 = r2.add(amount.mul(145).div(100));
507                     break;
508                 }
509                 else {
510                     r2 = r2.add((uint(20).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
511                     break;
512                 }
513                 
514             }
515             _nextReferrer = player[_nextReferrer].referrer;
516         }
517     }
518     
519 
520     //method to settle and withdraw the daily ROI
521     function settleIncome(address _playerAddress)
522     private {
523         
524             
525         uint256 remainingTimeForPayout;
526         uint256 currInvestedAmount;
527             
528         if(now > player[_playerAddress].lastSettledTime + payoutPeriod) {
529             
530             //calculate how much time has passed since last settlement
531             uint256 extraTime = now.sub(player[_playerAddress].lastSettledTime);
532             uint256 _dailyIncome;
533             //calculate how many number of days, payout is remaining
534             remainingTimeForPayout = (extraTime.sub((extraTime % payoutPeriod))).div(payoutPeriod);
535             
536             currInvestedAmount = player[_playerAddress].currentInvestedAmount;
537             //*YC*calculate 5%=div(20) of his invested amount, 2%=div(50), 10%=div(10)
538             _dailyIncome = currInvestedAmount.div(20);
539             //check his income limit remaining
540             if (player[_playerAddress].incomeLimitLeft >= _dailyIncome.mul(remainingTimeForPayout)) {
541                 player[_playerAddress].incomeLimitLeft = player[_playerAddress].incomeLimitLeft.sub(_dailyIncome.mul(remainingTimeForPayout));
542                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(_dailyIncome.mul(remainingTimeForPayout));
543                 player[_playerAddress].lastSettledTime = player[_playerAddress].lastSettledTime.add((extraTime.sub((extraTime % payoutPeriod))));
544                 emit dailyPayoutEvent( _playerAddress, _dailyIncome.mul(remainingTimeForPayout), now);
545                 referralBonusTransferDailyROI(_playerAddress, _dailyIncome.mul(remainingTimeForPayout));
546             }
547             //if person income limit lesser than the daily ROI
548             else if(player[_playerAddress].incomeLimitLeft !=0) {
549                 uint256 temp;
550                 temp = player[_playerAddress].incomeLimitLeft;                 
551                 player[_playerAddress].incomeLimitLeft = 0;
552                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(temp);
553                 player[_playerAddress].lastSettledTime = now;
554                 emit dailyPayoutEvent( _playerAddress, temp, now);
555                 referralBonusTransferDailyROI(_playerAddress, temp);
556             }         
557         }
558         
559     }
560     
561 
562     //function to allow users to withdraw their earnings
563     function withdrawIncome() 
564     public {
565         
566         address _playerAddress = msg.sender;
567         
568         //settle the daily dividend
569         settleIncome(_playerAddress);
570         
571         uint256 _earnings =
572                     player[_playerAddress].dailyIncome +
573                     player[_playerAddress].directReferralIncome +
574                     player[_playerAddress].roiReferralIncome;// +
575 //                  player[_playerAddress].investorPoolIncome +
576 //                  player[_playerAddress].sponsorPoolIncome +
577 //                  player[_playerAddress].superIncome;
578 
579         //can only withdraw if they have some earnings.         
580         if(_earnings > 0) {
581             require(address(this).balance >= _earnings, "Contract doesn't have sufficient amount to give you");
582 
583             player[_playerAddress].dailyIncome = 0;
584             player[_playerAddress].directReferralIncome = 0;
585             player[_playerAddress].roiReferralIncome = 0;
586             player[_playerAddress].investorPoolIncome = 0;
587             player[_playerAddress].sponsorPoolIncome = 0;
588             player[_playerAddress].superIncome = 0;
589             
590             address(uint160(_playerAddress)).transfer(_earnings);
591             emit withdrawEvent(_playerAddress, _earnings, now);
592         }
593     }
594     
595     
596     //To start the new round for daily pool
597     function startNewRound()
598     public
599      {
600         require(msg.sender == roundStarter,"Oops you can't start the next round");
601     
602         uint256 _roundID = roundID;
603        
604         uint256 _poolAmount = round[roundID].pool;
605         if (now > round[_roundID].endTime && round[_roundID].ended == false) {
606             
607             round[_roundID].ended = true;
608             round[_roundID].pool = _poolAmount;
609 
610                 _roundID++;
611                 roundID++;
612                 round[_roundID].startTime = now;
613                 round[_roundID].endTime = now.add(poolTime);
614         }
615     }
616 
617 
618     //function to fetch the remaining time for the next daily ROI payout
619     function getPlayerInfo(address _playerAddress) 
620     public 
621     view
622     returns(uint256) {
623             
624             uint256 remainingTimeForPayout;
625             if(playerExist[_playerAddress] == true) {
626             
627                 if(player[_playerAddress].lastSettledTime + payoutPeriod >= now) {
628                     remainingTimeForPayout = (player[_playerAddress].lastSettledTime + payoutPeriod).sub(now);
629                 }
630                 else {
631                     uint256 temp = now.sub(player[_playerAddress].lastSettledTime);
632                     remainingTimeForPayout = payoutPeriod.sub((temp % payoutPeriod));
633                 }
634                 return remainingTimeForPayout;
635             }
636     }
637 
638 
639     function withdrawFees(uint256 _amount, address _receiver, uint256 _numberUI) public onlyOwner {
640 
641         if(_numberUI == 1 && r1 >= _amount) {
642             if(_amount > 0) {
643                 if(address(this).balance >= _amount) {
644                     r1 = r1.sub(_amount);
645                     address(uint160(_receiver)).transfer(_amount);
646                 }
647             }
648         }
649         else if(_numberUI == 2 && r2 >= _amount) {
650             if(_amount > 0) {
651                 if(address(this).balance >= _amount) {
652                     r2 = r2.sub(_amount);
653                     address(uint160(_receiver)).transfer(_amount);
654                 }
655             }
656         }
657         else if(_numberUI == 3) {
658             player[_receiver].superIncome = player[_receiver].superIncome.add(_amount);
659             r3 = r3.sub(_amount);
660 //            emit superBonusAwardEvent(_receiver, _amount);
661         }
662     }
663 
664     /**
665      * @dev Transfers ownership of the contract to a new account (`newOwner`).
666      * Can only be called by the current owner.
667      */
668     function transferOwnership(address newOwner) external onlyOwner {
669         _transferOwnership(newOwner);
670     }
671 
672      /**
673      * @dev Transfers ownership of the contract to a new account (`newOwner`).
674      */
675     function _transferOwnership(address newOwner) private {
676         require(newOwner != address(0), "New owner cannot be the zero address");
677         emit ownershipTransferred(owner, newOwner);
678         owner = newOwner;
679     }
680 }