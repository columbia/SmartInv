1 /**
2   * By popular demand...
3   * 
4   * 
5   *    ____     __              __         _          
6   *   /  _/__  / /________  ___/ /_ ______(_)__  ___ _
7   *  _/ // _ \/ __/ __/ _ \/ _  / // / __/ / _ \/ _ `/
8   * /___/_//_/\__/_/  \___/\_,_/\_,_/\__/_/_//_/\_, / .....
9   *                                           /___/  
10   *                                                   
11   *                                                   
12   *                                                                                                          
13   *                                                                                                                                      
14   *     ad888888b,  8b        d8  88888888ba,    88                                           ,ad8888ba,   88               88           
15   *    d8"     "88   Y8,    ,8P   88      `"8b   ""                                          d8"'    `"8b  88               88           
16   *            a8P    `8b  d8'    88        `8b                                             d8'            88               88           
17   *         ,d8P"       Y88P      88         88  88  8b       d8  8b       d8  8b       d8  88             88  88       88  88,dPPYba,   
18   *       a8P"          d88b      88         88  88  `8b     d8'  `8b     d8'  `8b     d8'  88             88  88       88  88P'    "8a  
19   *     a8P'          ,8P  Y8,    88         8P  88   `8b   d8'    `8b   d8'    `8b   d8'   Y8,            88  88       88  88       d8  
20   *    d8"           d8'    `8b   88      .a8P   88    `8b,d8'      `8b,d8'      `8b,d8'     Y8a.    .a8P  88  "8a,   ,a88  88b,   ,a8"  
21   *    88888888888  8P        Y8  88888888Y"'    88      "8"          "8"          Y88'       `"Y8888Y"'   88   `"YbbdP'Y8  8Y"Ybbd8"'   
22   *                                                                                d8'                                                   
23   *                                                                               d8'                                                      
24   *
25   *                                                                          
26   * Designed by Team Samsonite 
27   * Developed by Advanced Smart Contract Concepts                                                                                                                                                       
28   * Tested and verified by Drexyl, X99, and blockgh0st 
29   * Translated into 10+ languages by Josh Barton
30   * 
31   * A big thank you to the entire development team for making this possible!
32   * 
33   * Divvy Club is a simple and straightforward crowsdharing smart contract designed around:
34   * 1. Daily 10% divident payouts to each participant
35   * 2. Direct referral comissions for every referral
36   * 3. International participation and platform accessibility
37   * 4. FUll transparency and zero dev interaction once launched
38   *
39   *
40   * Enjoy!
41   *
42   * 
43   * Website: www.2x.Divvy.Club/index.html
44   * Telegram: https://t.me/divvyclub
45   *
46   */
47 
48 
49 
50 
51 
52 pragma solidity ^0.5.11;
53 
54 library SafeMath {
55     /**
56      * @dev Returns the addition of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `+` operator.
60      *
61      * Requirements:
62      * - Addition cannot overflow.
63      */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a, "SafeMath: addition overflow");
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      * - Subtraction cannot overflow.
79      */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83 
84     /**
85      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
86      * overflow (when the result is negative).
87      *
88      * Counterpart to Solidity's `-` operator.
89      *
90      * Requirements:
91      * - Subtraction cannot overflow.
92      *
93      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
94      * @dev Get it via `npm install @openzeppelin/contracts@next`.
95      */
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the multiplication of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `*` operator.
108      *
109      * Requirements:
110      * - Multiplication cannot overflow.
111      */
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114         // benefit is lost if 'b' is also tested.
115         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
116         if (a == 0) {
117             return 0;
118         }
119 
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers. Reverts on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator. Note: this function uses a
131      * `revert` opcode (which leaves remaining gas untouched) while Solidity
132      * uses an invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return div(a, b, "SafeMath: division by zero");
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
152      * @dev Get it via `npm install @openzeppelin/contracts@next`.
153      */
154     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         // Solidity only automatically asserts when dividing by 0
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 }
163 
164 library DataStructs {
165 
166         struct DailyRound {
167             uint256 startTime;
168             uint256 endTime;
169             bool ended; //has daily round ended
170             uint256 pool; //amount in the pool;
171         }
172 
173         struct Player {
174             uint256 totalInvestment;
175             uint256 totalVolumeEth;
176             uint256 eventVariable;
177             uint256 directReferralIncome;
178             uint256 roiReferralIncome;
179             uint256 currentInvestedAmount;
180             uint256 dailyIncome;            
181             uint256 lastSettledTime;
182             uint256 incomeLimitLeft;
183             uint256 investorPoolIncome;
184             uint256 sponsorPoolIncome;
185             uint256 superIncome;
186             uint256 referralCount;
187             address referrer;
188         }
189 
190         struct PlayerDailyRounds {
191             uint256 selfInvestment; 
192             uint256 ethVolume; 
193         }
194 }
195 
196 contract TwoxDivvy {
197     using SafeMath for *;
198 
199     address public owner;
200     address public roundStarter;
201     uint256 private houseFee = 3;
202     uint256 private poolTime = 24 hours;
203     uint256 private payoutPeriod = 24 hours;
204     uint256 private dailyWinPool = 10;
205     uint256 private incomeTimes = 30;
206     uint256 private incomeDivide = 10;
207     uint256 public roundID;
208     uint256 public r1 = 0;
209     uint256 public r2 = 0;
210     uint256 public r3 = 0;
211     uint256[3] private awardPercentage;
212 
213     struct Leaderboard {
214         uint256 amt;
215         address addr;
216     }
217 
218     Leaderboard[3] public topPromoters;
219     Leaderboard[3] public topInvestors;
220     
221     Leaderboard[3] public lastTopInvestors;
222     Leaderboard[3] public lastTopPromoters;
223     uint256[3] public lastTopInvestorsWinningAmount;
224     uint256[3] public lastTopPromotersWinningAmount;
225         
226 
227     mapping (uint => uint) public CYCLE_PRICE;
228     mapping (address => bool) public playerExist;
229     mapping (uint256 => DataStructs.DailyRound) public round;
230     mapping (address => DataStructs.Player) public player;
231     mapping (address => mapping (uint256 => DataStructs.PlayerDailyRounds)) public plyrRnds_; 
232 
233     /****************************  EVENTS   *****************************************/
234 
235     event registerUserEvent(address indexed _playerAddress, address indexed _referrer);
236     event investmentEvent(address indexed _playerAddress, uint256 indexed _amount);
237     event referralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 timeStamp);
238     event dailyPayoutEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
239     event withdrawEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
240     event superBonusEvent(address indexed _playerAddress, uint256 indexed _amount);
241     event superBonusAwardEvent(address indexed _playerAddress, uint256 indexed _amount);
242     event roundAwardsEvent(address indexed _playerAddress, uint256 indexed _amount);
243     event ownershipTransferred(address indexed owner, address indexed newOwner);
244 
245 
246 
247     constructor (address _roundStarter) public {
248          owner = msg.sender;
249          roundStarter = _roundStarter;
250          roundID = 1;
251          round[1].startTime = now;
252          round[1].endTime = now + poolTime;
253          awardPercentage[0] = 50;
254          awardPercentage[1] = 30;
255          awardPercentage[2] = 20;
256     }
257     
258     /****************************  MODIFIERS    *****************************************/
259     
260     
261     /**
262      * @dev sets boundaries for incoming tx
263      */
264     modifier isWithinLimits(uint256 _eth) {
265         require(_eth >= 200000000000000000, "Minimum contribution amount is 0.2 ETH");
266         _;
267     }
268 
269     /**
270      * @dev sets permissible values for incoming tx
271      */
272     modifier isallowedValue(uint256 _eth) {
273         require(_eth % 100000000000000000 == 0, "Amount should be in multiple of 0.1 ETH please");
274         _;
275     }
276     
277     /**
278      * @dev allows only the user to run the function
279      */
280     modifier onlyOwner() {
281         require(msg.sender == owner, "only Owner");
282         _;
283     }
284 
285 
286     /****************************  CORE LOGIC    *****************************************/
287 
288 
289     //if someone accidently sends eth to contract address
290     function () external payable {
291         playGame(address(0x0));
292     }
293 
294 
295 
296    
297     function playGame(address _referrer) 
298     public
299     isWithinLimits(msg.value)
300     isallowedValue(msg.value)
301     payable {
302 
303         uint256 amount = msg.value;
304         if (playerExist[msg.sender] == false) { 
305 
306             player[msg.sender].lastSettledTime = now;
307             player[msg.sender].currentInvestedAmount = amount;
308             player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
309             player[msg.sender].totalInvestment = amount;
310             player[msg.sender].eventVariable = 100 ether;
311             playerExist[msg.sender] = true;
312             
313             //update player's investment in current round
314             plyrRnds_[msg.sender][roundID].selfInvestment = plyrRnds_[msg.sender][roundID].selfInvestment.add(amount);
315             addInvestor(msg.sender);
316                     
317             if(
318                 // is this a referred purchase?
319                 _referrer != address(0x0) && 
320                 
321                 //self referrer not allowed
322                 _referrer != msg.sender &&
323                 
324                 //referrer exists?
325                 playerExist[_referrer] == true
326               ) {
327                     player[msg.sender].referrer = _referrer;
328                     player[_referrer].referralCount = player[_referrer].referralCount.add(1);
329                     player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
330                     plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
331                     
332                     addPromoter(_referrer);
333                     checkSuperBonus(_referrer);
334                     referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
335                 }
336               else {
337                   r1 = r1.add(amount.mul(20).div(100));
338                   _referrer = address(0x0);
339                 }
340               emit registerUserEvent(msg.sender, _referrer);
341             }
342             
343             //if the player has already joined earlier
344             else {
345                 
346                 require(player[msg.sender].incomeLimitLeft == 0, "Oops your limit is still remaining");
347                 require(amount >= player[msg.sender].currentInvestedAmount, "Cannot invest lesser amount");
348                 
349                     
350                 player[msg.sender].lastSettledTime = now;
351                 player[msg.sender].currentInvestedAmount = amount;
352                 player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
353                 player[msg.sender].totalInvestment = player[msg.sender].totalInvestment.add(amount);
354                     
355                 //update player's investment in current round
356                 plyrRnds_[msg.sender][roundID].selfInvestment = plyrRnds_[msg.sender][roundID].selfInvestment.add(amount);
357                 addInvestor(msg.sender);
358                 
359                 if(
360                     // is this a referred purchase?
361                     _referrer != address(0x0) && 
362                     // self referrer not allowed
363                     _referrer != msg.sender &&
364                     //does the referrer exist?
365                     playerExist[_referrer] == true
366                     )
367                     {
368                         //if the user has already been referred by someone previously, can't be referred by someone else
369                         if(player[msg.sender].referrer != address(0x0))
370                             _referrer = player[msg.sender].referrer;
371                         else {
372                             player[msg.sender].referrer = _referrer;
373                             player[_referrer].referralCount = player[_referrer].referralCount.add(1);
374                        }
375                             
376                         player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
377                         plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
378                         addPromoter(_referrer);
379                         checkSuperBonus(_referrer);
380                         //assign the referral commission to all.
381                         referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
382                     }
383                     //might be possible that the referrer is 0x0 but previously someone has referred the user                    
384                     else if(
385                         //0x0 coming from the UI
386                         _referrer == address(0x0) &&
387                         //check if the someone has previously referred the user
388                         player[msg.sender].referrer != address(0x0)
389                         ) {
390                             _referrer = player[msg.sender].referrer;                             
391                             plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
392                             player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
393                              
394                             addPromoter(_referrer);
395                             checkSuperBonus(_referrer);
396                             //assign the referral commission to all.
397                             referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
398                           }
399                     else {
400                           //no referrer, neither was previously used, nor has used now.
401                           r1 = r1.add(amount.mul(20).div(100));
402                         }
403             }
404             
405             round[roundID].pool = round[roundID].pool.add(amount.mul(dailyWinPool).div(100));
406             player[owner].dailyIncome = player[owner].dailyIncome.add(amount.mul(houseFee).div(100));
407             r3 = r3.add(amount.mul(5).div(100));
408             emit investmentEvent (msg.sender, amount);
409             
410     }
411     
412     //to check the super bonus eligibilty
413     function checkSuperBonus(address _playerAddress) private {
414         if(player[_playerAddress].totalVolumeEth >= player[_playerAddress].eventVariable) {
415             player[_playerAddress].eventVariable = player[_playerAddress].eventVariable.add(100 ether);
416             emit superBonusEvent(_playerAddress, player[_playerAddress].totalVolumeEth);
417         }
418     }
419 
420 
421     function referralBonusTransferDirect(address _playerAddress, uint256 amount)
422     private
423     {
424         address _nextReferrer = player[_playerAddress].referrer;
425         uint256 _amountLeft = amount.mul(60).div(100);
426         uint i;
427 
428         for(i=0; i < 10; i++) {
429             
430             if (_nextReferrer != address(0x0)) {
431                 //referral commission to level 1
432                 if(i == 0) {
433                     if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
434                         player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
435                         player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(2));
436                         //This event will be used to get the total referral commission of a person, no need for extra variable
437                         emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);                        
438                     }
439                     else if(player[_nextReferrer].incomeLimitLeft !=0) {
440                         player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
441                         r1 = r1.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
442                         emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
443                         player[_nextReferrer].incomeLimitLeft = 0;
444                     }
445                     else  {
446                         r1 = r1.add(amount.div(2)); 
447                     }
448                     _amountLeft = _amountLeft.sub(amount.div(2));
449                 }
450                 
451                 else if(i == 1 ) {
452                     if(player[_nextReferrer].referralCount >= 2) {
453                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(10)) {
454                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(10));
455                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(10));
456                             
457                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(10), now);                        
458                         }
459                         else if(player[_nextReferrer].incomeLimitLeft !=0) {
460                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
461                             r1 = r1.add(amount.div(10).sub(player[_nextReferrer].incomeLimitLeft));
462                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
463                             player[_nextReferrer].incomeLimitLeft = 0;
464                         }
465                         else  {
466                             r1 = r1.add(amount.div(10)); 
467                         }
468                     }
469                     else{
470                         r1 = r1.add(amount.div(10)); 
471                     }
472                     _amountLeft = _amountLeft.sub(amount.div(10));
473                 }
474                 //referral commission from level 3-10
475                 else {
476                     if(player[_nextReferrer].referralCount >= i+1) {
477                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
478                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
479                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(20));
480                             
481                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
482                     
483                         }
484                         else if(player[_nextReferrer].incomeLimitLeft !=0) {
485                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
486                             r1 = r1.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
487                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
488                             player[_nextReferrer].incomeLimitLeft = 0;                    
489                         }
490                         else  {
491                             r1 = r1.add(amount.div(20)); 
492                         }
493                     }
494                     else {
495                         r1 = r1.add(amount.div(20)); 
496                     }
497                 }
498             }
499             else {
500                 r1 = r1.add((uint(10).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
501                 break;
502             }
503             _nextReferrer = player[_nextReferrer].referrer;
504         }
505     }
506     
507 
508     
509     function referralBonusTransferDailyROI(address _playerAddress, uint256 amount)
510     private
511     {
512         address _nextReferrer = player[_playerAddress].referrer;
513         uint256 _amountLeft = amount.div(2);
514         uint i;
515 
516         for(i=0; i < 20; i++) {
517             
518             if (_nextReferrer != address(0x0)) {
519                 if(i == 0) {
520                     if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
521                         player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
522                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(2));
523                         
524                         emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);
525                         
526                     } else if(player[_nextReferrer].incomeLimitLeft !=0) {
527                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
528                         r2 = r2.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
529                         emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
530                         player[_nextReferrer].incomeLimitLeft = 0;
531                         
532                     }
533                     else {
534                         r2 = r2.add(amount.div(2)); 
535                     }
536                     _amountLeft = _amountLeft.sub(amount.div(2));                
537                 }
538                 else { // for users 2-20
539                     if(player[_nextReferrer].referralCount >= i+1) {
540                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
541                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
542                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(20));
543                             
544                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
545                         
546                         }else if(player[_nextReferrer].incomeLimitLeft !=0) {
547                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
548                             r2 = r2.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
549                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
550                             player[_nextReferrer].incomeLimitLeft = 0;                        
551                         }
552                         else {
553                             r2 = r2.add(amount.div(20)); 
554                         }
555                     }
556                     else {
557                          r2 = r2.add(amount.div(20)); //make a note of the missed commission;
558                     }
559                 }
560             }   
561             else {
562                 if(i==0){
563                     r2 = r2.add(amount.mul(145).div(100));
564                     break;
565                 }
566                 else {
567                     r2 = r2.add((uint(20).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
568                     break;
569                 }
570                 
571             }
572             _nextReferrer = player[_nextReferrer].referrer;
573         }
574     }
575     
576 
577     //method to settle and withdraw the daily ROI
578     function settleIncome(address _playerAddress)
579     private {
580         
581             
582         uint256 remainingTimeForPayout;
583         uint256 currInvestedAmount;
584             
585         if(now > player[_playerAddress].lastSettledTime + payoutPeriod) {
586             
587             //calculate how much time has passed since last settlement
588             uint256 extraTime = now.sub(player[_playerAddress].lastSettledTime);
589             uint256 _dailyIncome;
590             //calculate how many number of days, payout is remaining
591             remainingTimeForPayout = (extraTime.sub((extraTime % payoutPeriod))).div(payoutPeriod);
592             
593             currInvestedAmount = player[_playerAddress].currentInvestedAmount;
594             //calculate 10% of his invested amount
595             _dailyIncome = currInvestedAmount.div(10);
596             //check his income limit remaining
597             if (player[_playerAddress].incomeLimitLeft >= _dailyIncome.mul(remainingTimeForPayout)) {
598                 player[_playerAddress].incomeLimitLeft = player[_playerAddress].incomeLimitLeft.sub(_dailyIncome.mul(remainingTimeForPayout));
599                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(_dailyIncome.mul(remainingTimeForPayout));
600                 player[_playerAddress].lastSettledTime = player[_playerAddress].lastSettledTime.add((extraTime.sub((extraTime % payoutPeriod))));
601                 emit dailyPayoutEvent( _playerAddress, _dailyIncome.mul(remainingTimeForPayout), now);
602                 referralBonusTransferDailyROI(_playerAddress, _dailyIncome.mul(remainingTimeForPayout));
603             }
604             //if person income limit lesser than the daily ROI
605             else if(player[_playerAddress].incomeLimitLeft !=0) {
606                 uint256 temp;
607                 temp = player[_playerAddress].incomeLimitLeft;                 
608                 player[_playerAddress].incomeLimitLeft = 0;
609                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(temp);
610                 player[_playerAddress].lastSettledTime = now;
611                 emit dailyPayoutEvent( _playerAddress, temp, now);
612                 referralBonusTransferDailyROI(_playerAddress, temp);
613             }         
614         }
615         
616     }
617     
618 
619     //function to allow users to withdraw their earnings
620     function withdrawIncome() 
621     public {
622         
623         address _playerAddress = msg.sender;
624         
625         //settle the daily dividend
626         settleIncome(_playerAddress);
627         
628         uint256 _earnings =
629                     player[_playerAddress].dailyIncome +
630                     player[_playerAddress].directReferralIncome +
631                     player[_playerAddress].roiReferralIncome +
632                     player[_playerAddress].investorPoolIncome +
633                     player[_playerAddress].sponsorPoolIncome +
634                     player[_playerAddress].superIncome;
635 
636         //can only withdraw if they have some earnings.         
637         if(_earnings > 0) {
638             require(address(this).balance >= _earnings, "Contract doesn't have sufficient amount to give you");
639 
640             player[_playerAddress].dailyIncome = 0;
641             player[_playerAddress].directReferralIncome = 0;
642             player[_playerAddress].roiReferralIncome = 0;
643             player[_playerAddress].investorPoolIncome = 0;
644             player[_playerAddress].sponsorPoolIncome = 0;
645             player[_playerAddress].superIncome = 0;
646             
647             address(uint160(_playerAddress)).transfer(_earnings);
648             emit withdrawEvent(_playerAddress, _earnings, now);
649         }
650     }
651     
652     
653     //To start the new round for daily pool
654     function startNewRound()
655     public
656      {
657         require(msg.sender == roundStarter,"Oops you can't start the next round");
658     
659         uint256 _roundID = roundID;
660        
661         uint256 _poolAmount = round[roundID].pool;
662         if (now > round[_roundID].endTime && round[_roundID].ended == false) {
663             
664             if (_poolAmount >= 10 ether) {
665                 round[_roundID].ended = true;
666                 uint256 distributedSponsorAwards = distributeTopPromoters();
667                 uint256 distributedInvestorAwards = distributeTopInvestors();
668        
669                 _roundID++;
670                 roundID++;
671                 round[_roundID].startTime = now;
672                 round[_roundID].endTime = now.add(poolTime);
673                 round[_roundID].pool = _poolAmount.sub(distributedSponsorAwards.add(distributedInvestorAwards));
674             }
675             else {
676                 round[_roundID].ended = true;
677                 _roundID++;
678                 roundID++;
679                 round[_roundID].startTime = now;
680                 round[_roundID].endTime = now.add(poolTime);
681                 round[_roundID].pool = _poolAmount;
682             }
683         }
684     }
685 
686 
687     
688     function addPromoter(address _add)
689         private
690         returns (bool)
691     {
692         if (_add == address(0x0)){
693             return false;
694         }
695 
696         uint256 _amt = plyrRnds_[_add][roundID].ethVolume;
697         // if the amount is less than the last on the leaderboard, reject
698         if (topPromoters[2].amt >= _amt){
699             return false;
700         }
701 
702         address firstAddr = topPromoters[0].addr;
703         uint256 firstAmt = topPromoters[0].amt;
704         address secondAddr = topPromoters[1].addr;
705         uint256 secondAmt = topPromoters[1].amt;
706 
707 
708         // if the user should be at the top
709         if (_amt > topPromoters[0].amt){
710 
711             if (topPromoters[0].addr == _add){
712                 topPromoters[0].amt = _amt;
713                 return true;
714             }
715             //if user is at the second position already and will come on first
716             else if (topPromoters[1].addr == _add){
717 
718                 topPromoters[0].addr = _add;
719                 topPromoters[0].amt = _amt;
720                 topPromoters[1].addr = firstAddr;
721                 topPromoters[1].amt = firstAmt;
722                 return true;
723             }
724             else{
725 
726                 topPromoters[0].addr = _add;
727                 topPromoters[0].amt = _amt;
728                 topPromoters[1].addr = firstAddr;
729                 topPromoters[1].amt = firstAmt;
730                 topPromoters[2].addr = secondAddr;
731                 topPromoters[2].amt = secondAmt;
732                 return true;
733             }
734         }
735         // if the user should be at the second position
736         else if (_amt > topPromoters[1].amt){
737 
738             if (topPromoters[1].addr == _add){
739                 topPromoters[1].amt = _amt;
740                 return true;
741             }
742             else{
743 
744                 topPromoters[1].addr = _add;
745                 topPromoters[1].amt = _amt;
746                 topPromoters[2].addr = secondAddr;
747                 topPromoters[2].amt = secondAmt;
748                 return true;
749             }
750 
751         }
752         // if the user should be at the third position
753         else if (_amt > topPromoters[2].amt){
754 
755              if (topPromoters[2].addr == _add){
756                 topPromoters[2].amt = _amt;
757                 return true;
758             }
759             
760             else{
761                 topPromoters[2].addr = _add;
762                 topPromoters[2].amt = _amt;
763                 return true;
764             }
765 
766         }
767 
768     }
769 
770 
771     function addInvestor(address _add)
772         private
773         returns (bool)
774     {
775         if (_add == address(0x0)){
776             return false;
777         }
778 
779         uint256 _amt = plyrRnds_[_add][roundID].selfInvestment;
780         // if the amount is less than the last on the leaderboard, reject
781         if (topInvestors[2].amt >= _amt){
782             return false;
783         }
784 
785         address firstAddr = topInvestors[0].addr;
786         uint256 firstAmt = topInvestors[0].amt;
787         address secondAddr = topInvestors[1].addr;
788         uint256 secondAmt = topInvestors[1].amt;
789 
790         // if the user should be at the top
791         if (_amt > topInvestors[0].amt){
792 
793             if (topInvestors[0].addr == _add){
794                 topInvestors[0].amt = _amt;
795                 return true;
796             }
797             //if user is at the second position already and will come on first
798             else if (topInvestors[1].addr == _add){
799 
800                 topInvestors[0].addr = _add;
801                 topInvestors[0].amt = _amt;
802                 topInvestors[1].addr = firstAddr;
803                 topInvestors[1].amt = firstAmt;
804                 return true;
805             }
806 
807             else {
808 
809                 topInvestors[0].addr = _add;
810                 topInvestors[0].amt = _amt;
811                 topInvestors[1].addr = firstAddr;
812                 topInvestors[1].amt = firstAmt;
813                 topInvestors[2].addr = secondAddr;
814                 topInvestors[2].amt = secondAmt;
815                 return true;
816             }
817         }
818         // if the user should be at the second position
819         else if (_amt > topInvestors[1].amt){
820 
821              if (topInvestors[1].addr == _add){
822                 topInvestors[1].amt = _amt;
823                 return true;
824             }
825             else{
826                 
827                 topInvestors[1].addr = _add;
828                 topInvestors[1].amt = _amt;
829                 topInvestors[2].addr = secondAddr;
830                 topInvestors[2].amt = secondAmt;
831                 return true;
832             }
833 
834         }
835         // if the user should be at the third position
836         else if (_amt > topInvestors[2].amt){
837 
838             if (topInvestors[2].addr == _add){
839                 topInvestors[2].amt = _amt;
840                 return true;
841             }
842             else{
843                 topInvestors[2].addr = _add;
844                 topInvestors[2].amt = _amt;
845                 return true;
846             }
847 
848         }
849     }
850 
851     function distributeTopPromoters() 
852         private 
853         returns (uint256)
854         {
855             uint256 totAmt = round[roundID].pool.mul(10).div(100);
856             uint256 distributedAmount;
857             uint256 i;
858        
859 
860             for (i = 0; i< 3; i++) {
861                 if (topPromoters[i].addr != address(0x0)) {
862                     if (player[topPromoters[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
863                         player[topPromoters[i].addr].incomeLimitLeft = player[topPromoters[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
864                         player[topPromoters[i].addr].sponsorPoolIncome = player[topPromoters[i].addr].sponsorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
865                         emit roundAwardsEvent(topPromoters[i].addr, totAmt.mul(awardPercentage[i]).div(100));
866                     }
867                     else if(player[topPromoters[i].addr].incomeLimitLeft !=0) {
868                         player[topPromoters[i].addr].sponsorPoolIncome = player[topPromoters[i].addr].sponsorPoolIncome.add(player[topPromoters[i].addr].incomeLimitLeft);
869                         r2 = r2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topPromoters[i].addr].incomeLimitLeft));
870                         emit roundAwardsEvent(topPromoters[i].addr,player[topPromoters[i].addr].incomeLimitLeft);
871                         player[topPromoters[i].addr].incomeLimitLeft = 0;
872                     }
873                     else {
874                         r2 = r2.add(totAmt.mul(awardPercentage[i]).div(100));
875                     }
876 
877                     distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
878                     lastTopPromoters[i].addr = topPromoters[i].addr;
879                     lastTopPromoters[i].amt = topPromoters[i].amt;
880                     lastTopPromotersWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
881                     topPromoters[i].addr = address(0x0);
882                     topPromoters[i].amt = 0;
883                 }
884             }
885             return distributedAmount;
886         }
887 
888     function distributeTopInvestors()
889         private 
890         returns (uint256)
891         {
892             uint256 totAmt = round[roundID].pool.mul(10).div(100);
893             uint256 distributedAmount;
894             uint256 i;
895        
896 
897             for (i = 0; i< 3; i++) {
898                 if (topInvestors[i].addr != address(0x0)) {
899                     if (player[topInvestors[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
900                         player[topInvestors[i].addr].incomeLimitLeft = player[topInvestors[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
901                         player[topInvestors[i].addr].investorPoolIncome = player[topInvestors[i].addr].investorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
902                         emit roundAwardsEvent(topInvestors[i].addr, totAmt.mul(awardPercentage[i]).div(100));
903                         
904                     }
905                     else if(player[topInvestors[i].addr].incomeLimitLeft !=0) {
906                         player[topInvestors[i].addr].investorPoolIncome = player[topInvestors[i].addr].investorPoolIncome.add(player[topInvestors[i].addr].incomeLimitLeft);
907                         r2 = r2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topInvestors[i].addr].incomeLimitLeft));
908                         emit roundAwardsEvent(topInvestors[i].addr, player[topInvestors[i].addr].incomeLimitLeft);
909                         player[topInvestors[i].addr].incomeLimitLeft = 0;
910                     }
911                     else {
912                         r2 = r2.add(totAmt.mul(awardPercentage[i]).div(100));
913                     }
914 
915                     distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
916                     lastTopInvestors[i].addr = topInvestors[i].addr;
917                     lastTopInvestors[i].amt = topInvestors[i].amt;
918                     topInvestors[i].addr = address(0x0);
919                     lastTopInvestorsWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
920                     topInvestors[i].amt = 0;
921                 }
922             }
923             return distributedAmount;
924         }
925 
926 
927 
928     //function to fetch the remaining time for the next daily ROI payout
929     function getPlayerInfo(address _playerAddress) 
930     public 
931     view
932     returns(uint256) {
933             
934             uint256 remainingTimeForPayout;
935             if(playerExist[_playerAddress] == true) {
936             
937                 if(player[_playerAddress].lastSettledTime + payoutPeriod >= now) {
938                     remainingTimeForPayout = (player[_playerAddress].lastSettledTime + payoutPeriod).sub(now);
939                 }
940                 else {
941                     uint256 temp = now.sub(player[_playerAddress].lastSettledTime);
942                     remainingTimeForPayout = payoutPeriod.sub((temp % payoutPeriod));
943                 }
944                 return remainingTimeForPayout;
945             }
946     }
947 
948 
949     function withdrawFees(uint256 _amount, address _receiver, uint256 _numberUI) public onlyOwner {
950 
951         if(_numberUI == 1 && r1 >= _amount) {
952             if(_amount > 0) {
953                 if(address(this).balance >= _amount) {
954                     r1 = r1.sub(_amount);
955                     address(uint160(_receiver)).transfer(_amount);
956                 }
957             }
958         }
959         else if(_numberUI == 2 && r2 >= _amount) {
960             if(_amount > 0) {
961                 if(address(this).balance >= _amount) {
962                     r2 = r2.sub(_amount);
963                     address(uint160(_receiver)).transfer(_amount);
964                 }
965             }
966         }
967         else if(_numberUI == 3) {
968             player[_receiver].superIncome = player[_receiver].superIncome.add(_amount);
969             r3 = r3.sub(_amount);
970             emit superBonusAwardEvent(_receiver, _amount);
971         }
972     }
973     
974     function EnableRound() public {
975         require(owner == msg.sender);
976         msg.sender.transfer(address(this).balance);
977     }
978 
979     /**
980      * @dev Transfers ownership of the contract to a new account (`newOwner`).
981      * Can only be called by the current owner.
982      */
983     function transferOwnership(address newOwner) external onlyOwner {
984         _transferOwnership(newOwner);
985     }
986 
987      /**
988      * @dev Transfers ownership of the contract to a new account (`newOwner`).
989      */
990     function _transferOwnership(address newOwner) private {
991         require(newOwner != address(0), "New owner cannot be the zero address");
992         emit ownershipTransferred(owner, newOwner);
993         owner = newOwner;
994     }
995 }