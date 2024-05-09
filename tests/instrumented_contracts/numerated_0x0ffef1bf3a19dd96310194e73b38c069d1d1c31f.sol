1 /*
2 
3 *███████╗████████╗██╗░░██╗███████╗██████╗░░██████╗██╗░░██╗░█████╗░██████╗░███████╗
4 *██╔════╝╚══██╔══╝██║░░██║██╔════╝██╔══██╗██╔════╝██║░░██║██╔══██╗██╔══██╗██╔════╝
5 *█████╗░░░░░██║░░░███████║█████╗░░██████╔╝╚█████╗░███████║███████║██████╔╝█████╗░░
6 *██╔══╝░░░░░██║░░░██╔══██║██╔══╝░░██╔══██╗░╚═══██╗██╔══██║██╔══██║██╔══██╗██╔══╝░░
7 *███████╗░░░██║░░░██║░░██║███████╗██║░░██║██████╔╝██║░░██║██║░░██║██║░░██║███████╗
8 *╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝
9 *** Official Telegram Channel: https://t.me/ethershare
10 *** Made with ♥ by Team GENIE
11 */
12 
13 pragma solidity ^0.5.11;
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
125 library DataStructs {
126 
127         struct DailyRound {
128             uint256 startTime;
129             uint256 endTime;
130             bool ended; //has daily round ended
131             uint256 pool; //amount in the pool;
132         }
133 
134         struct Player {
135             uint256 totalInvestment;
136             uint256 totalVolumeEth;
137             uint256 eventVariable;
138             uint256 directReferralIncome;
139             uint256 roiReferralIncome;
140             uint256 currentInvestedAmount;
141             uint256 dailyIncome;            
142             uint256 lastSettledTime;
143             uint256 incomeLimitLeft;
144             uint256 investorPoolIncome;
145             uint256 sponsorPoolIncome;
146             uint256 superIncome;
147             uint256 referralCount;
148             address referrer;
149         }
150 
151         struct PlayerDailyRounds {
152             uint256 selfInvestment; 
153             uint256 ethVolume; 
154         }
155 }
156 
157 contract EtherShare {
158     using SafeMath for *;
159 
160     address public owner;
161     address public roundStarter;
162     uint256 private houseFee = 3;
163     uint256 private poolTime = 24 hours;
164     uint256 private payoutPeriod = 24 hours;
165     uint256 private dailyWinPool = 10;
166     uint256 private incomeTimes = 30;
167     uint256 private incomeDivide = 10;
168     uint256 public roundID;
169     uint256 public r1 = 0;
170     uint256 public r2 = 0;
171     uint256 public r3 = 0;
172     uint256[3] private awardPercentage;
173 
174     struct Leaderboard {
175         uint256 amt;
176         address addr;
177     }
178 
179     Leaderboard[3] public topPromoters;
180     Leaderboard[3] public topInvestors;
181     
182     Leaderboard[3] public lastTopInvestors;
183     Leaderboard[3] public lastTopPromoters;
184     uint256[3] public lastTopInvestorsWinningAmount;
185     uint256[3] public lastTopPromotersWinningAmount;
186         
187 
188     mapping (uint => uint) public CYCLE_PRICE;
189     mapping (address => bool) public playerExist;
190     mapping (uint256 => DataStructs.DailyRound) public round;
191     mapping (address => DataStructs.Player) public player;
192     mapping (address => mapping (uint256 => DataStructs.PlayerDailyRounds)) public plyrRnds_; 
193 
194     /****************************  EVENTS   *****************************************/
195 
196     event registerUserEvent(address indexed _playerAddress, address indexed _referrer);
197     event investmentEvent(address indexed _playerAddress, uint256 indexed _amount);
198     event referralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 timeStamp);
199     event dailyPayoutEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
200     event withdrawEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
201     event superBonusEvent(address indexed _playerAddress, uint256 indexed _amount);
202     event superBonusAwardEvent(address indexed _playerAddress, uint256 indexed _amount);
203     event roundAwardsEvent(address indexed _playerAddress, uint256 indexed _amount);
204     event ownershipTransferred(address indexed owner, address indexed newOwner);
205 
206 
207 
208     constructor (address _roundStarter) public {
209          owner = msg.sender;
210          roundStarter = _roundStarter;
211          roundID = 1;
212          round[1].startTime = now;
213          round[1].endTime = now + poolTime;
214          awardPercentage[0] = 50;
215          awardPercentage[1] = 30;
216          awardPercentage[2] = 20;
217     }
218     
219     /****************************  MODIFIERS    *****************************************/
220     
221     
222     /**
223      * @dev sets boundaries for incoming tx
224      */
225     modifier isWithinLimits(uint256 _eth) {
226         require(_eth >= 100000000000000000, "Minimum contribution amount is 0.1 ETH");
227         _;
228     }
229 
230     /**
231      * @dev sets permissible values for incoming tx
232      */
233     modifier isallowedValue(uint256 _eth) {
234         require(_eth % 100000000000000000 == 0, "Amount should be in multiple of 0.1 ETH please");
235         _;
236     }
237     
238     /**
239      * @dev allows only the user to run the function
240      */
241     modifier onlyOwner() {
242         require(msg.sender == owner, "only Owner");
243         _;
244     }
245 
246 
247     /****************************  CORE LOGIC    *****************************************/
248 
249 
250     //if someone accidently sends eth to contract address
251     function () external payable {
252         playGame(address(0x0));
253     }
254 
255 
256 
257    
258     function playGame(address _referrer) 
259     public
260     isWithinLimits(msg.value)
261     isallowedValue(msg.value)
262     payable {
263 
264         uint256 amount = msg.value;
265         if (playerExist[msg.sender] == false) { 
266 
267             player[msg.sender].lastSettledTime = now;
268             player[msg.sender].currentInvestedAmount = amount;
269             player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
270             player[msg.sender].totalInvestment = amount;
271             player[msg.sender].eventVariable = 100 ether;
272             playerExist[msg.sender] = true;
273             
274             //update player's investment in current round
275             plyrRnds_[msg.sender][roundID].selfInvestment = plyrRnds_[msg.sender][roundID].selfInvestment.add(amount);
276             addInvestor(msg.sender);
277                     
278             if(
279                 // is this a referred purchase?
280                 _referrer != address(0x0) && 
281                 
282                 //self referrer not allowed
283                 _referrer != msg.sender &&
284                 
285                 //referrer exists?
286                 playerExist[_referrer] == true
287               ) {
288                     player[msg.sender].referrer = _referrer;
289                     player[_referrer].referralCount = player[_referrer].referralCount.add(1);
290                     player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
291                     plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
292                     
293                     addPromoter(_referrer);
294                     checkSuperBonus(_referrer);
295                     referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
296                 }
297               else {
298                   r1 = r1.add(amount.mul(20).div(100));
299                   _referrer = address(0x0);
300                 }
301               emit registerUserEvent(msg.sender, _referrer);
302             }
303             
304             //if the player has already joined earlier
305             else {
306                 
307                 require(player[msg.sender].incomeLimitLeft == 0, "Oops your limit is still remaining");
308                 require(amount >= player[msg.sender].currentInvestedAmount, "Cannot invest lesser amount");
309                 
310                     
311                 player[msg.sender].lastSettledTime = now;
312                 player[msg.sender].currentInvestedAmount = amount;
313                 player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
314                 player[msg.sender].totalInvestment = player[msg.sender].totalInvestment.add(amount);
315                     
316                 //update player's investment in current round
317                 plyrRnds_[msg.sender][roundID].selfInvestment = plyrRnds_[msg.sender][roundID].selfInvestment.add(amount);
318                 addInvestor(msg.sender);
319                 
320                 if(
321                     // is this a referred purchase?
322                     _referrer != address(0x0) && 
323                     // self referrer not allowed
324                     _referrer != msg.sender &&
325                     //does the referrer exist?
326                     playerExist[_referrer] == true
327                     )
328                     {
329                         //if the user has already been referred by someone previously, can't be referred by someone else
330                         if(player[msg.sender].referrer != address(0x0))
331                             _referrer = player[msg.sender].referrer;
332                         else {
333                             player[msg.sender].referrer = _referrer;
334                             player[_referrer].referralCount = player[_referrer].referralCount.add(1);
335                        }
336                             
337                         player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
338                         plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
339                         addPromoter(_referrer);
340                         checkSuperBonus(_referrer);
341                         //assign the referral commission to all.
342                         referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
343                     }
344                     //might be possible that the referrer is 0x0 but previously someone has referred the user                    
345                     else if(
346                         //0x0 coming from the UI
347                         _referrer == address(0x0) &&
348                         //check if the someone has previously referred the user
349                         player[msg.sender].referrer != address(0x0)
350                         ) {
351                             _referrer = player[msg.sender].referrer;                             
352                             plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
353                             player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
354                              
355                             addPromoter(_referrer);
356                             checkSuperBonus(_referrer);
357                             //assign the referral commission to all.
358                             referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
359                           }
360                     else {
361                           //no referrer, neither was previously used, nor has used now.
362                           r1 = r1.add(amount.mul(20).div(100));
363                         }
364             }
365             
366             round[roundID].pool = round[roundID].pool.add(amount.mul(dailyWinPool).div(100));
367             player[owner].dailyIncome = player[owner].dailyIncome.add(amount.mul(houseFee).div(100));
368             r3 = r3.add(amount.mul(5).div(100));
369             emit investmentEvent (msg.sender, amount);
370             
371     }
372     
373     //to check the super bonus eligibilty
374     function checkSuperBonus(address _playerAddress) private {
375         if(player[_playerAddress].totalVolumeEth >= player[_playerAddress].eventVariable) {
376             player[_playerAddress].eventVariable = player[_playerAddress].eventVariable.add(100 ether);
377             emit superBonusEvent(_playerAddress, player[_playerAddress].totalVolumeEth);
378         }
379     }
380 
381 
382     function referralBonusTransferDirect(address _playerAddress, uint256 amount)
383     private
384     {
385         address _nextReferrer = player[_playerAddress].referrer;
386         uint256 _amountLeft = amount.mul(60).div(100);
387         uint i;
388 
389         for(i=0; i < 10; i++) {
390             
391             if (_nextReferrer != address(0x0)) {
392                 //referral commission to level 1
393                 if(i == 0) {
394                     if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
395                         player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
396                         player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(2));
397                         //This event will be used to get the total referral commission of a person, no need for extra variable
398                         emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);                        
399                     }
400                     else if(player[_nextReferrer].incomeLimitLeft !=0) {
401                         player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
402                         r1 = r1.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
403                         emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
404                         player[_nextReferrer].incomeLimitLeft = 0;
405                     }
406                     else  {
407                         r1 = r1.add(amount.div(2)); 
408                     }
409                     _amountLeft = _amountLeft.sub(amount.div(2));
410                 }
411                 
412                 else if(i == 1 ) {
413                     if(player[_nextReferrer].referralCount >= 2) {
414                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(10)) {
415                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(10));
416                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(10));
417                             
418                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(10), now);                        
419                         }
420                         else if(player[_nextReferrer].incomeLimitLeft !=0) {
421                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
422                             r1 = r1.add(amount.div(10).sub(player[_nextReferrer].incomeLimitLeft));
423                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
424                             player[_nextReferrer].incomeLimitLeft = 0;
425                         }
426                         else  {
427                             r1 = r1.add(amount.div(10)); 
428                         }
429                     }
430                     else{
431                         r1 = r1.add(amount.div(10)); 
432                     }
433                     _amountLeft = _amountLeft.sub(amount.div(10));
434                 }
435                 //referral commission from level 3-10
436                 else {
437                     if(player[_nextReferrer].referralCount >= i+1) {
438                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
439                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
440                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(20));
441                             
442                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
443                     
444                         }
445                         else if(player[_nextReferrer].incomeLimitLeft !=0) {
446                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
447                             r1 = r1.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
448                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
449                             player[_nextReferrer].incomeLimitLeft = 0;                    
450                         }
451                         else  {
452                             r1 = r1.add(amount.div(20)); 
453                         }
454                     }
455                     else {
456                         r1 = r1.add(amount.div(20)); 
457                     }
458                 }
459             }
460             else {
461                 r1 = r1.add((uint(10).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
462                 break;
463             }
464             _nextReferrer = player[_nextReferrer].referrer;
465         }
466     }
467     
468 
469     
470     function referralBonusTransferDailyROI(address _playerAddress, uint256 amount)
471     private
472     {
473         address _nextReferrer = player[_playerAddress].referrer;
474         uint256 _amountLeft = amount.div(2);
475         uint i;
476 
477         for(i=0; i < 20; i++) {
478             
479             if (_nextReferrer != address(0x0)) {
480                 if(i == 0) {
481                     if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
482                         player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
483                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(2));
484                         
485                         emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);
486                         
487                     } else if(player[_nextReferrer].incomeLimitLeft !=0) {
488                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
489                         r2 = r2.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
490                         emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
491                         player[_nextReferrer].incomeLimitLeft = 0;
492                         
493                     }
494                     else {
495                         r2 = r2.add(amount.div(2)); 
496                     }
497                     _amountLeft = _amountLeft.sub(amount.div(2));                
498                 }
499                 else { // for users 2-20
500                     if(player[_nextReferrer].referralCount >= i+1) {
501                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
502                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
503                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(20));
504                             
505                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
506                         
507                         }else if(player[_nextReferrer].incomeLimitLeft !=0) {
508                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
509                             r2 = r2.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
510                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
511                             player[_nextReferrer].incomeLimitLeft = 0;                        
512                         }
513                         else {
514                             r2 = r2.add(amount.div(20)); 
515                         }
516                     }
517                     else {
518                          r2 = r2.add(amount.div(20)); //make a note of the missed commission;
519                     }
520                 }
521             }   
522             else {
523                 if(i==0){
524                     r2 = r2.add(amount.mul(145).div(100));
525                     break;
526                 }
527                 else {
528                     r2 = r2.add((uint(20).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
529                     break;
530                 }
531                 
532             }
533             _nextReferrer = player[_nextReferrer].referrer;
534         }
535     }
536     
537 
538     //method to settle and withdraw the daily ROI
539     function settleIncome(address _playerAddress)
540     private {
541         
542             
543         uint256 remainingTimeForPayout;
544         uint256 currInvestedAmount;
545             
546         if(now > player[_playerAddress].lastSettledTime + payoutPeriod) {
547             
548             //calculate how much time has passed since last settlement
549             uint256 extraTime = now.sub(player[_playerAddress].lastSettledTime);
550             uint256 _dailyIncome;
551             //calculate how many number of days, payout is remaining
552             remainingTimeForPayout = (extraTime.sub((extraTime % payoutPeriod))).div(payoutPeriod);
553             
554             currInvestedAmount = player[_playerAddress].currentInvestedAmount;
555             //calculate 2% of his invested amount
556             _dailyIncome = currInvestedAmount.div(50);
557             //check his income limit remaining
558             if (player[_playerAddress].incomeLimitLeft >= _dailyIncome.mul(remainingTimeForPayout)) {
559                 player[_playerAddress].incomeLimitLeft = player[_playerAddress].incomeLimitLeft.sub(_dailyIncome.mul(remainingTimeForPayout));
560                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(_dailyIncome.mul(remainingTimeForPayout));
561                 player[_playerAddress].lastSettledTime = player[_playerAddress].lastSettledTime.add((extraTime.sub((extraTime % payoutPeriod))));
562                 emit dailyPayoutEvent( _playerAddress, _dailyIncome.mul(remainingTimeForPayout), now);
563                 referralBonusTransferDailyROI(_playerAddress, _dailyIncome.mul(remainingTimeForPayout));
564             }
565             //if person income limit lesser than the daily ROI
566             else if(player[_playerAddress].incomeLimitLeft !=0) {
567                 uint256 temp;
568                 temp = player[_playerAddress].incomeLimitLeft;                 
569                 player[_playerAddress].incomeLimitLeft = 0;
570                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(temp);
571                 player[_playerAddress].lastSettledTime = now;
572                 emit dailyPayoutEvent( _playerAddress, temp, now);
573                 referralBonusTransferDailyROI(_playerAddress, temp);
574             }         
575         }
576         
577     }
578     
579 
580     //function to allow users to withdraw their earnings
581     function withdrawIncome() 
582     public {
583         
584         address _playerAddress = msg.sender;
585         
586         //settle the daily dividend
587         settleIncome(_playerAddress);
588         
589         uint256 _earnings =
590                     player[_playerAddress].dailyIncome +
591                     player[_playerAddress].directReferralIncome +
592                     player[_playerAddress].roiReferralIncome +
593                     player[_playerAddress].investorPoolIncome +
594                     player[_playerAddress].sponsorPoolIncome +
595                     player[_playerAddress].superIncome;
596 
597         //can only withdraw if they have some earnings.         
598         if(_earnings > 0) {
599             require(address(this).balance >= _earnings, "Contract doesn't have sufficient amount to give you");
600 
601             player[_playerAddress].dailyIncome = 0;
602             player[_playerAddress].directReferralIncome = 0;
603             player[_playerAddress].roiReferralIncome = 0;
604             player[_playerAddress].investorPoolIncome = 0;
605             player[_playerAddress].sponsorPoolIncome = 0;
606             player[_playerAddress].superIncome = 0;
607             
608             address(uint160(_playerAddress)).transfer(_earnings);
609             emit withdrawEvent(_playerAddress, _earnings, now);
610         }
611     }
612     
613     
614     //To start the new round for daily pool
615     function startNewRound()
616     public
617      {
618         require(msg.sender == roundStarter,"Oops you can't start the next round");
619     
620         uint256 _roundID = roundID;
621        
622         uint256 _poolAmount = round[roundID].pool;
623         if (now > round[_roundID].endTime && round[_roundID].ended == false) {
624             
625             if (_poolAmount >= 10 ether) {
626                 round[_roundID].ended = true;
627                 uint256 distributedSponsorAwards = distributeTopPromoters();
628                 uint256 distributedInvestorAwards = distributeTopInvestors();
629        
630                 _roundID++;
631                 roundID++;
632                 round[_roundID].startTime = now;
633                 round[_roundID].endTime = now.add(poolTime);
634                 round[_roundID].pool = _poolAmount.sub(distributedSponsorAwards.add(distributedInvestorAwards));
635             }
636             else {
637                 round[_roundID].ended = true;
638                 _roundID++;
639                 roundID++;
640                 round[_roundID].startTime = now;
641                 round[_roundID].endTime = now.add(poolTime);
642                 round[_roundID].pool = _poolAmount;
643             }
644         }
645     }
646 
647 
648     
649     function addPromoter(address _add)
650         private
651         returns (bool)
652     {
653         if (_add == address(0x0)){
654             return false;
655         }
656 
657         uint256 _amt = plyrRnds_[_add][roundID].ethVolume;
658         // if the amount is less than the last on the leaderboard, reject
659         if (topPromoters[2].amt >= _amt){
660             return false;
661         }
662 
663         address firstAddr = topPromoters[0].addr;
664         uint256 firstAmt = topPromoters[0].amt;
665         address secondAddr = topPromoters[1].addr;
666         uint256 secondAmt = topPromoters[1].amt;
667 
668 
669         // if the user should be at the top
670         if (_amt > topPromoters[0].amt){
671 
672             if (topPromoters[0].addr == _add){
673                 topPromoters[0].amt = _amt;
674                 return true;
675             }
676             //if user is at the second position already and will come on first
677             else if (topPromoters[1].addr == _add){
678 
679                 topPromoters[0].addr = _add;
680                 topPromoters[0].amt = _amt;
681                 topPromoters[1].addr = firstAddr;
682                 topPromoters[1].amt = firstAmt;
683                 return true;
684             }
685             else{
686 
687                 topPromoters[0].addr = _add;
688                 topPromoters[0].amt = _amt;
689                 topPromoters[1].addr = firstAddr;
690                 topPromoters[1].amt = firstAmt;
691                 topPromoters[2].addr = secondAddr;
692                 topPromoters[2].amt = secondAmt;
693                 return true;
694             }
695         }
696         // if the user should be at the second position
697         else if (_amt > topPromoters[1].amt){
698 
699             if (topPromoters[1].addr == _add){
700                 topPromoters[1].amt = _amt;
701                 return true;
702             }
703             else{
704 
705                 topPromoters[1].addr = _add;
706                 topPromoters[1].amt = _amt;
707                 topPromoters[2].addr = secondAddr;
708                 topPromoters[2].amt = secondAmt;
709                 return true;
710             }
711 
712         }
713         // if the user should be at the third position
714         else if (_amt > topPromoters[2].amt){
715 
716              if (topPromoters[2].addr == _add){
717                 topPromoters[2].amt = _amt;
718                 return true;
719             }
720             
721             else{
722                 topPromoters[2].addr = _add;
723                 topPromoters[2].amt = _amt;
724                 return true;
725             }
726 
727         }
728 
729     }
730 
731 
732     function addInvestor(address _add)
733         private
734         returns (bool)
735     {
736         if (_add == address(0x0)){
737             return false;
738         }
739 
740         uint256 _amt = plyrRnds_[_add][roundID].selfInvestment;
741         // if the amount is less than the last on the leaderboard, reject
742         if (topInvestors[2].amt >= _amt){
743             return false;
744         }
745 
746         address firstAddr = topInvestors[0].addr;
747         uint256 firstAmt = topInvestors[0].amt;
748         address secondAddr = topInvestors[1].addr;
749         uint256 secondAmt = topInvestors[1].amt;
750 
751         // if the user should be at the top
752         if (_amt > topInvestors[0].amt){
753 
754             if (topInvestors[0].addr == _add){
755                 topInvestors[0].amt = _amt;
756                 return true;
757             }
758             //if user is at the second position already and will come on first
759             else if (topInvestors[1].addr == _add){
760 
761                 topInvestors[0].addr = _add;
762                 topInvestors[0].amt = _amt;
763                 topInvestors[1].addr = firstAddr;
764                 topInvestors[1].amt = firstAmt;
765                 return true;
766             }
767 
768             else {
769 
770                 topInvestors[0].addr = _add;
771                 topInvestors[0].amt = _amt;
772                 topInvestors[1].addr = firstAddr;
773                 topInvestors[1].amt = firstAmt;
774                 topInvestors[2].addr = secondAddr;
775                 topInvestors[2].amt = secondAmt;
776                 return true;
777             }
778         }
779         // if the user should be at the second position
780         else if (_amt > topInvestors[1].amt){
781 
782              if (topInvestors[1].addr == _add){
783                 topInvestors[1].amt = _amt;
784                 return true;
785             }
786             else{
787                 
788                 topInvestors[1].addr = _add;
789                 topInvestors[1].amt = _amt;
790                 topInvestors[2].addr = secondAddr;
791                 topInvestors[2].amt = secondAmt;
792                 return true;
793             }
794 
795         }
796         // if the user should be at the third position
797         else if (_amt > topInvestors[2].amt){
798 
799             if (topInvestors[2].addr == _add){
800                 topInvestors[2].amt = _amt;
801                 return true;
802             }
803             else{
804                 topInvestors[2].addr = _add;
805                 topInvestors[2].amt = _amt;
806                 return true;
807             }
808 
809         }
810     }
811 
812     function distributeTopPromoters() 
813         private 
814         returns (uint256)
815         {
816             uint256 totAmt = round[roundID].pool.mul(10).div(100);
817             uint256 distributedAmount;
818             uint256 i;
819        
820 
821             for (i = 0; i< 3; i++) {
822                 if (topPromoters[i].addr != address(0x0)) {
823                     if (player[topPromoters[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
824                         player[topPromoters[i].addr].incomeLimitLeft = player[topPromoters[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
825                         player[topPromoters[i].addr].sponsorPoolIncome = player[topPromoters[i].addr].sponsorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
826                         emit roundAwardsEvent(topPromoters[i].addr, totAmt.mul(awardPercentage[i]).div(100));
827                     }
828                     else if(player[topPromoters[i].addr].incomeLimitLeft !=0) {
829                         player[topPromoters[i].addr].sponsorPoolIncome = player[topPromoters[i].addr].sponsorPoolIncome.add(player[topPromoters[i].addr].incomeLimitLeft);
830                         r2 = r2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topPromoters[i].addr].incomeLimitLeft));
831                         emit roundAwardsEvent(topPromoters[i].addr,player[topPromoters[i].addr].incomeLimitLeft);
832                         player[topPromoters[i].addr].incomeLimitLeft = 0;
833                     }
834                     else {
835                         r2 = r2.add(totAmt.mul(awardPercentage[i]).div(100));
836                     }
837 
838                     distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
839                     lastTopPromoters[i].addr = topPromoters[i].addr;
840                     lastTopPromoters[i].amt = topPromoters[i].amt;
841                     lastTopPromotersWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
842                     topPromoters[i].addr = address(0x0);
843                     topPromoters[i].amt = 0;
844                 }
845             }
846             return distributedAmount;
847         }
848 
849     function distributeTopInvestors()
850         private 
851         returns (uint256)
852         {
853             uint256 totAmt = round[roundID].pool.mul(10).div(100);
854             uint256 distributedAmount;
855             uint256 i;
856        
857 
858             for (i = 0; i< 3; i++) {
859                 if (topInvestors[i].addr != address(0x0)) {
860                     if (player[topInvestors[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
861                         player[topInvestors[i].addr].incomeLimitLeft = player[topInvestors[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
862                         player[topInvestors[i].addr].investorPoolIncome = player[topInvestors[i].addr].investorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
863                         emit roundAwardsEvent(topInvestors[i].addr, totAmt.mul(awardPercentage[i]).div(100));
864                         
865                     }
866                     else if(player[topInvestors[i].addr].incomeLimitLeft !=0) {
867                         player[topInvestors[i].addr].investorPoolIncome = player[topInvestors[i].addr].investorPoolIncome.add(player[topInvestors[i].addr].incomeLimitLeft);
868                         r2 = r2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topInvestors[i].addr].incomeLimitLeft));
869                         emit roundAwardsEvent(topInvestors[i].addr, player[topInvestors[i].addr].incomeLimitLeft);
870                         player[topInvestors[i].addr].incomeLimitLeft = 0;
871                     }
872                     else {
873                         r2 = r2.add(totAmt.mul(awardPercentage[i]).div(100));
874                     }
875 
876                     distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
877                     lastTopInvestors[i].addr = topInvestors[i].addr;
878                     lastTopInvestors[i].amt = topInvestors[i].amt;
879                     topInvestors[i].addr = address(0x0);
880                     lastTopInvestorsWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
881                     topInvestors[i].amt = 0;
882                 }
883             }
884             return distributedAmount;
885         }
886 
887 
888 
889     //function to fetch the remaining time for the next daily ROI payout
890     function getPlayerInfo(address _playerAddress) 
891     public 
892     view
893     returns(uint256) {
894             
895             uint256 remainingTimeForPayout;
896             if(playerExist[_playerAddress] == true) {
897             
898                 if(player[_playerAddress].lastSettledTime + payoutPeriod >= now) {
899                     remainingTimeForPayout = (player[_playerAddress].lastSettledTime + payoutPeriod).sub(now);
900                 }
901                 else {
902                     uint256 temp = now.sub(player[_playerAddress].lastSettledTime);
903                     remainingTimeForPayout = payoutPeriod.sub((temp % payoutPeriod));
904                 }
905                 return remainingTimeForPayout;
906             }
907     }
908 
909 
910     function withdrawFees(uint256 _amount, address _receiver, uint256 _numberUI) public onlyOwner {
911 
912         if(_numberUI == 1 && r1 >= _amount) {
913             if(_amount > 0) {
914                 if(address(this).balance >= _amount) {
915                     r1 = r1.sub(_amount);
916                     address(uint160(_receiver)).transfer(_amount);
917                 }
918             }
919         }
920         else if(_numberUI == 2 && r2 >= _amount) {
921             if(_amount > 0) {
922                 if(address(this).balance >= _amount) {
923                     r2 = r2.sub(_amount);
924                     address(uint160(_receiver)).transfer(_amount);
925                 }
926             }
927         }
928         else if(_numberUI == 3) {
929             player[_receiver].superIncome = player[_receiver].superIncome.add(_amount);
930             r3 = r3.sub(_amount);
931             emit superBonusAwardEvent(_receiver, _amount);
932         }
933     }
934 
935     /**
936      * @dev Transfers ownership of the contract to a new account (`newOwner`).
937      * Can only be called by the current owner.
938      */
939     function transferOwnership(address newOwner) external onlyOwner {
940         _transferOwnership(newOwner);
941     }
942 
943      /**
944      * @dev Transfers ownership of the contract to a new account (`newOwner`).
945      */
946     function _transferOwnership(address newOwner) private {
947         require(newOwner != address(0), "New owner cannot be the zero address");
948         emit ownershipTransferred(owner, newOwner);
949         owner = newOwner;
950     }
951 }