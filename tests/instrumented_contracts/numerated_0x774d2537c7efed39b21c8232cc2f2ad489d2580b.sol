1 pragma solidity ^0.4.18;
2 
3 /**
4  *  @title Smart City Crowdsale contract http://www.smartcitycoin.io
5  */
6 
7 contract SmartCityToken {
8     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {}
9     
10     function setTokenStart(uint256 _newStartTime) public {}
11 
12     function burn() public {}
13 }
14 
15 contract SmartCityCrowdsale {
16     using SafeMath for uint256;
17 
18     // State
19 
20     struct Account {
21         uint256 accounted;   // received amount and bonus
22         uint256 received;    // received amount
23     }
24 
25     /// Crowdsale participants
26     mapping (address => Account) public buyins;
27 
28     /// Balances of Fixed Price sale participants.
29     mapping(address => uint256) public purchases;
30 
31     /// Total amount of ether received.
32     uint256 public totalReceived = 0;
33 
34     /// Total amount of ether accounted.
35     uint256 public totalAccounted = 0;
36 
37     /// Total tokens purchased during Phase 2.
38     uint256 public tokensPurchased = 0;
39 
40     /// Total amount of ether which has been finalised.
41     uint256 public totalFinalised = 0;
42     
43     /// Phase 1 end time.
44     uint256 public firstPhaseEndTime;
45     
46     /// Phase 2 start time.
47     uint256 public secondPhaseStartTime;
48     
49     /// Campaign end time.
50     uint256 public endTime;
51 
52     /// The price per token aftre Phase 1. Works also as an effective price in Phase 2 for Phase 1 participants.
53     uint256 public auctionEndPrice;
54     
55     /// The price for token within Phase 2 which is effective for those who did not participate in Phase 1
56     uint256 public fixedPrice;
57 
58     /// The current percentage of bonus.
59     uint256 public currentBonus = 15;
60 
61     /// Bonus that will be applied to purchases if Target is reached in Phase 1. Initially zero.
62     uint256 public auctionSuccessBonus = 0;
63     
64     /// Must be false for any public function to be called.
65     bool public paused = false;
66     
67     /// Campaign is ended
68     bool public campaignEnded = false;
69 
70     // Constants after constructor:
71 
72     /// CITY token contract.
73     SmartCityToken public tokenContract;
74 
75     /// The owner address.
76     address public owner;
77 
78     /// The wallet address.
79     address public wallet;
80 
81     /// Sale start time.
82     uint256 public startTime;
83 
84     /// Amount of tokens allocated for Phase 1.
85     /// Once totalAccounted / currentPrice is greater than this value, Phase 1 ends.
86     uint256 public tokenCapPhaseOne;
87     
88     /// Amount of tokens allocated for Phase 2
89     uint256 public tokenCapPhaseTwo;
90 
91 
92     // Static constants:
93 
94     /// Target
95     uint256 constant public FUNDING_GOAL = 109573 ether;
96     
97     /// Minimum token price after Phase 1 for Phase 2 to be started.
98     uint256 constant public TOKEN_MIN_PRICE_THRESHOLD = 100000000; // 0,00001 ETH per 1 CITY
99     
100     /// Maximum duration of Phase 1
101     uint256 constant public FIRST_PHASE_MAX_SPAN = 21 days;
102     
103     /// Maximum duration of Phase 2
104     uint256 constant public SECOND_PHASE_MAX_SPAN = 33 days;
105     
106     /// Minimum investment amount
107     uint256 constant public DUST_LIMIT = 5 finney;
108 
109     /// Number of days from Phase 1 beginning when bonus is available. Bonus percentage drops by 1 percent a day.
110     uint256 constant public BONUS_DURATION = 15;
111     
112     /// Percentage of bonus that will be applied to all purchases if Target is reached in Phase 1
113     uint256 constant public SUCCESS_BONUS = 15;
114     
115     /// token price in Phase 2 is by 20 % higher when resulting auction price
116     /// for those who did not participate in auction
117     uint256 constant public SECOND_PHASE_PRICE_FACTOR = 20;
118 
119     /// 1e15
120     uint256 constant public FACTOR = 1 finney;
121 
122     /// Divisor of the token.
123     uint256 constant public DIVISOR = 100000;
124 
125     // Events
126 
127     /// Buyin event.
128     event Buyin(address indexed receiver, uint256 accounted, uint256 received, uint256 price);
129 
130     /// Phase 1 just ended.
131     event PhaseOneEnded(uint256 price);
132     
133     /// Phase 2 is engagaed.
134     event PhaseTwoStared(uint256 fixedPrice);
135 
136     /// Investement event.
137     event Invested(address indexed receiver, uint256 received, uint256 tokens);
138 
139     /// The campaign just ended.
140     event Ended(bool goalReached);
141 
142     /// Finalised the purchase for receiver.
143     event Finalised(address indexed receiver, uint256 tokens);
144 
145     /// Campaign is over. All accounts finalised.
146     event Retired();
147     
148     // Modifiers
149     
150     /// Ensure the sale is ended.
151     modifier when_ended { require (now >= endTime); _; }
152 
153     /// Ensure sale is not paused.
154     modifier when_not_halted { require (!paused); _; }
155 
156     /// Ensure `_receiver` is a participant.
157     modifier only_investors(address _receiver) { require (buyins[_receiver].accounted != 0 || purchases[_receiver] != 0); _; }
158 
159     /// Ensure sender is owner.
160     modifier only_owner { require (msg.sender == owner); _; }
161     
162     /// Ensure sale is in progress.
163     modifier when_active { require (!campaignEnded); _;}
164 
165     /// Ensure phase 1 is in progress
166     modifier only_in_phase_1 { require (now >= startTime && now < firstPhaseEndTime); _; }
167     
168     /// Ensure phase 1 is over
169     modifier after_phase_1 { require (now >= firstPhaseEndTime); _; }
170 
171     /// Ensure phase 2 is in progress
172     modifier only_in_phase_2 { require (now >= secondPhaseStartTime && now < endTime); _; }
173 
174     /// Ensure the value sent is above threshold.
175     modifier reject_dust { require ( msg.value >= DUST_LIMIT ); _; }
176 
177     // Constructor
178 
179     function SmartCityCrowdsale(
180         address _tokenAddress,
181         address _owner,
182         address _walletAddress,
183         uint256 _startTime,
184         uint256 _tokenCapPhaseOne,
185         uint256 _tokenCapPhaseTwo
186     )
187         public
188     {
189         tokenContract = SmartCityToken(_tokenAddress);
190         wallet = _walletAddress;
191         owner = _owner;
192         startTime = _startTime;
193         firstPhaseEndTime = startTime.add(FIRST_PHASE_MAX_SPAN);
194         secondPhaseStartTime = 253402300799; // initialise by setting to 9999/12/31
195         endTime = secondPhaseStartTime.add(SECOND_PHASE_MAX_SPAN);
196         tokenCapPhaseOne = _tokenCapPhaseOne;
197         tokenCapPhaseTwo = _tokenCapPhaseTwo;
198     }
199 
200     /// The default fallback function
201     /// Calls buyin or invest function depending on current campaign phase
202     /// Throws if campaign has already ended
203     function()
204         public
205         payable
206         when_not_halted
207         when_active
208     {
209         if (now >= startTime && now < firstPhaseEndTime) { // phase 1 is ongoing
210             _buyin(msg.sender, msg.value);
211         }
212         else {
213             _invest(msg.sender, msg.value);
214         }
215     }
216 
217     // Phase 1 functions
218 
219     /// buyin function.
220     function buyin()
221         public
222         payable
223         when_not_halted
224         when_active
225         only_in_phase_1
226         reject_dust
227     {
228         _buyin(msg.sender, msg.value);
229     }
230     
231     ///  buyinAs function. takes the receiver address as an argument
232     function buyinAs(address _receiver)
233         public
234         payable
235         when_not_halted
236         when_active
237         only_in_phase_1
238         reject_dust
239     {
240         require (_receiver != address(0));
241         _buyin(_receiver, msg.value);
242     }
243     
244     /// internal buyin functionality
245     function _buyin(address _receiver, uint256 _value)
246         internal
247     {
248         if (currentBonus > 0) {
249             uint256 daysSinceStart = (now.sub(startTime)).div(86400); // # of days
250 
251             if (daysSinceStart < BONUS_DURATION &&
252                 BONUS_DURATION.sub(daysSinceStart) != currentBonus) {
253                 currentBonus = BONUS_DURATION.sub(daysSinceStart);
254             }
255             if (daysSinceStart >= BONUS_DURATION) {
256                 currentBonus = 0;
257             }
258         }
259 
260         uint256 accounted;
261         bool refund;
262         uint256 price;
263 
264         (accounted, refund, price) = theDeal(_value);
265 
266         // effective cap should not be exceeded, throw
267         require (!refund);
268 
269         // change state
270         buyins[_receiver].accounted = buyins[_receiver].accounted.add(accounted);
271         buyins[_receiver].received = buyins[_receiver].received.add(_value);
272         totalAccounted = totalAccounted.add(accounted);
273         totalReceived = totalReceived.add(_value);
274         firstPhaseEndTime = calculateEndTime();
275 
276         Buyin(_receiver, accounted, _value, price);
277 
278         // send to wallet
279         wallet.transfer(_value);
280     }
281 
282     /// The current end time of the sale assuming that nobody else buys in.
283     function calculateEndTime()
284         public
285         constant
286         when_active
287         only_in_phase_1
288         returns (uint256)
289     {
290         uint256 res = (FACTOR.mul(240000).div(DIVISOR.mul(totalAccounted.div(tokenCapPhaseOne)).add(FACTOR.mul(4).div(100)))).add(startTime).sub(4848);
291 
292         if (res >= firstPhaseEndTime) {
293             return firstPhaseEndTime;
294         }
295         else {
296             return res;
297         }
298     }
299     
300 
301     /// The current price for a token
302     function currentPrice()
303         public
304         constant
305         when_active
306         only_in_phase_1
307         returns (uint256 weiPerIndivisibleTokenPart)
308     {
309         return ((FACTOR.mul(240000).div(now.sub(startTime).add(4848))).sub(FACTOR.mul(4).div(100))).div(DIVISOR);
310     }
311 
312     /// Returns the total tokens which can be purchased right now.
313     function tokensAvailable()
314         public
315         constant
316         when_active
317         only_in_phase_1
318         returns (uint256 tokens)
319     {
320         uint256 _currentCap = totalAccounted.div(currentPrice());
321         if (_currentCap >= tokenCapPhaseOne) {
322             return 0;
323         }
324         return tokenCapPhaseOne.sub(_currentCap);
325     }
326 
327     /// The largest purchase than can be done right now. For informational puproses only
328     function maxPurchase()
329         public
330         constant
331         when_active
332         only_in_phase_1
333         returns (uint256 spend)
334     {
335         return tokenCapPhaseOne.mul(currentPrice()).sub(totalAccounted);
336     }
337 
338     /// Returns the number of tokens available per given price.
339     /// If this number exceeds tokens being currently available, returns refund = true
340     function theDeal(uint256 _value)
341         public
342         constant
343         when_active
344         only_in_phase_1
345         returns (uint256 accounted, bool refund, uint256 price)
346     {
347         uint256 _bonus = auctionBonus(_value);
348 
349         price = currentPrice();
350         accounted = _value.add(_bonus);
351 
352         uint256 available = tokensAvailable();
353         uint256 tokens = accounted.div(price);
354         refund = (tokens > available);
355     }
356 
357     /// Returns bonus for given amount
358     function auctionBonus(uint256 _value)
359         public
360         constant
361         when_active
362         only_in_phase_1
363         returns (uint256 extra)
364     {
365         return _value.mul(currentBonus).div(100);
366     }
367 
368     // After Phase 1
369     
370     /// Checks the results of the first phase
371     /// Changes state only once
372     function finaliseFirstPhase()
373         public
374         when_not_halted
375         when_active
376         after_phase_1
377         returns(uint256)
378     {
379         if (auctionEndPrice == 0) {
380             auctionEndPrice = totalAccounted.div(tokenCapPhaseOne);
381             PhaseOneEnded(auctionEndPrice);
382 
383             // check if second phase should be engaged
384             if (totalAccounted >= FUNDING_GOAL ) {
385                 // funding goal is reached: phase 2 is not engaged, all auction participants receive additional bonus, campaign is ended
386                 auctionSuccessBonus = SUCCESS_BONUS;
387                 endTime = firstPhaseEndTime;
388                 campaignEnded = true;
389                 
390                 tokenContract.setTokenStart(endTime);
391 
392                 Ended(true);
393             }
394             
395             else if (auctionEndPrice >= TOKEN_MIN_PRICE_THRESHOLD) {
396                 // funding goal is not reached, auctionEndPrice is above or equal to threshold value: engage phase 2
397                 fixedPrice = auctionEndPrice.add(auctionEndPrice.mul(SECOND_PHASE_PRICE_FACTOR).div(100));
398                 secondPhaseStartTime = now;
399                 endTime = secondPhaseStartTime.add(SECOND_PHASE_MAX_SPAN);
400 
401                 PhaseTwoStared(fixedPrice);
402             }
403             else if (auctionEndPrice < TOKEN_MIN_PRICE_THRESHOLD && auctionEndPrice > 0){
404                 // funding goal is not reached, auctionEndPrice is below threshold value: phase 2 is not engaged, campaign is ended
405                 endTime = firstPhaseEndTime;
406                 campaignEnded = true;
407 
408                 tokenContract.setTokenStart(endTime);
409 
410                 Ended(false);
411             }
412             else { // no one came, we are all alone in this world :(
413                 auctionEndPrice = 1 wei;
414                 endTime = firstPhaseEndTime;
415                 campaignEnded = true;
416 
417                 tokenContract.setTokenStart(endTime);
418 
419                 Ended(false);
420 
421                 Retired();
422             }
423         }
424         
425         return auctionEndPrice;
426     }
427 
428     // Phase 2 functions
429 
430     /// Make an investment during second phase
431     function invest()
432         public
433         payable
434         when_not_halted
435         when_active
436         only_in_phase_2
437         reject_dust
438     {
439         _invest(msg.sender, msg.value);
440     }
441     
442     ///
443     function investAs(address _receiver)
444         public
445         payable
446         when_not_halted
447         when_active
448         only_in_phase_2
449         reject_dust
450     {
451         require (_receiver != address(0));
452         _invest(_receiver, msg.value);
453     }
454     
455     /// internal invest functionality
456     function _invest(address _receiver, uint256 _value)
457         internal
458     {
459         uint256 tokensCnt = getTokens(_receiver, _value); 
460 
461         require(tokensCnt > 0);
462         require(tokensPurchased.add(tokensCnt) <= tokenCapPhaseTwo); // should not exceed available tokens
463         require(_value <= maxTokenPurchase(_receiver)); // should not go above target
464 
465         purchases[_receiver] = purchases[_receiver].add(_value);
466         totalReceived = totalReceived.add(_value);
467         totalAccounted = totalAccounted.add(_value);
468         tokensPurchased = tokensPurchased.add(tokensCnt);
469 
470         Invested(_receiver, _value, tokensCnt);
471         
472         // send to wallet
473         wallet.transfer(_value);
474 
475         // check if we've reached the target
476         if (totalAccounted >= FUNDING_GOAL) {
477             endTime = now;
478             campaignEnded = true;
479             
480             tokenContract.setTokenStart(endTime);
481             
482             Ended(true);
483         }
484     }
485     
486     /// Tokens currently available for purchase in Phase 2
487     function getTokens(address _receiver, uint256 _value)
488         public
489         constant
490         when_active
491         only_in_phase_2
492         returns(uint256 tokensCnt)
493     {
494         // auction participants have better price in second phase
495         if (buyins[_receiver].received > 0) {
496             tokensCnt = _value.div(auctionEndPrice);
497         }
498         else {
499             tokensCnt = _value.div(fixedPrice);
500         }
501 
502     }
503     
504     /// Maximum current purchase amount in Phase 2
505     function maxTokenPurchase(address _receiver)
506         public
507         constant
508         when_active
509         only_in_phase_2
510         returns(uint256 spend)
511     {
512         uint256 availableTokens = tokenCapPhaseTwo.sub(tokensPurchased);
513         uint256 fundingGoalOffset = FUNDING_GOAL.sub(totalReceived);
514         uint256 maxInvestment;
515         
516         if (buyins[_receiver].received > 0) {
517             maxInvestment = availableTokens.mul(auctionEndPrice);
518         }
519         else {
520             maxInvestment = availableTokens.mul(fixedPrice);
521         }
522 
523         if (maxInvestment > fundingGoalOffset) {
524             return fundingGoalOffset;
525         }
526         else {
527             return maxInvestment;
528         }
529     }
530 
531     // After sale end
532     
533     /// Finalise purchase: transfers the tokens to caller address
534     function finalise()
535         public
536         when_not_halted
537         when_ended
538         only_investors(msg.sender)
539     {
540         finaliseAs(msg.sender);
541     }
542 
543     /// Finalise purchase for address provided: transfers the tokens purchased by given participant to their address
544     function finaliseAs(address _receiver)
545         public
546         when_not_halted
547         when_ended
548         only_investors(_receiver)
549     {
550         bool auctionParticipant;
551         uint256 total;
552         uint256 tokens;
553         uint256 bonus;
554         uint256 totalFixed;
555         uint256 tokensFixed;
556 
557         // first time calling finalise after phase 2 has ended but target was not reached
558         if (!campaignEnded) {
559             campaignEnded = true;
560             
561             tokenContract.setTokenStart(endTime);
562             
563             Ended(false);
564         }
565 
566         if (buyins[_receiver].accounted != 0) {
567             auctionParticipant = true;
568 
569             total = buyins[_receiver].accounted;
570             tokens = total.div(auctionEndPrice);
571             
572             if (auctionSuccessBonus > 0) {
573                 bonus = tokens.mul(auctionSuccessBonus).div(100);
574             }
575             totalFinalised = totalFinalised.add(total);
576             delete buyins[_receiver];
577         }
578         
579         if (purchases[_receiver] != 0) {
580             totalFixed = purchases[_receiver];
581             
582             if (auctionParticipant) {
583                 tokensFixed = totalFixed.div(auctionEndPrice);
584             }
585             else {
586                 tokensFixed = totalFixed.div(fixedPrice);
587             }
588             totalFinalised = totalFinalised.add(totalFixed);
589             delete purchases[_receiver];
590         }
591 
592         tokens = tokens.add(bonus).add(tokensFixed);
593 
594         require (tokenContract.transferFrom(owner, _receiver, tokens));
595 
596         Finalised(_receiver, tokens);
597 
598         if (totalFinalised == totalAccounted) {
599             tokenContract.burn(); // burn all unsold tokens
600             Retired();
601         }
602     }
603 
604     // Owner functions
605 
606     /// Emergency function to pause buy-in and finalisation.
607     function setPaused(bool _paused) public only_owner { paused = _paused; }
608 
609     /// Emergency function to drain the contract of any funds.
610     function drain() public only_owner { wallet.transfer(this.balance); }
611     
612     /// Returns true if the campaign is in progress.
613     function isActive() public constant returns (bool) { return now >= startTime && now < endTime; }
614 
615     /// Returns true if all purchases are finished.
616     function allFinalised() public constant returns (bool) { return now >= endTime && totalAccounted == totalFinalised; }
617 }
618 
619 /**
620  * @title SafeMath
621  * @dev Math operations with safety checks that throw on error
622  */
623 library SafeMath {
624 
625   /**
626   * @dev Multiplies two numbers, throws on overflow.
627   */
628   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
629     if (a == 0) {
630       return 0;
631     }
632     uint256 c = a * b;
633     assert(c / a == b);
634     return c;
635   }
636 
637   /**
638   * @dev Integer division of two numbers, truncating the quotient.
639   */
640   function div(uint256 a, uint256 b) internal pure returns (uint256) {
641     uint256 c = a / b;
642     return c;
643   }
644 
645   /**
646   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
647   */
648   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
649     assert(b <= a);
650     return a - b;
651   }
652 
653   /**
654   * @dev Adds two numbers, throws on overflow.
655   */
656   function add(uint256 a, uint256 b) internal pure returns (uint256) {
657     uint256 c = a + b;
658     assert(c >= a);
659     return c;
660   }
661 }
662 
663     /**
664     *            CITY token by www.SmartCityCoin.io
665     * 
666     *          .ossssss:                      `+sssss`      
667     *         ` +ssssss+` `.://++++++//:.`  .osssss+       
668     *            /sssssssssssssssssssssssss+ssssso`        
669     *             -sssssssssssssssssssssssssssss+`         
670     *            .+sssssssss+:--....--:/ossssssss+.        
671     *          `/ssssssssssso`         .sssssssssss/`      
672     *         .ossssss+sssssss-       :sssss+:ossssso.     
673     *        `ossssso. .ossssss:    `/sssss/  `/ssssss.    
674     *        ossssso`   `+ssssss+` .osssss:     /ssssss`   
675     *       :ssssss`      /sssssso:ssssso.       +o+/:-`   
676     *       osssss+        -sssssssssss+`                  
677     *       ssssss:         .ossssssss/                    
678     *       osssss/          `+ssssss-                     
679     *       /ssssso           :ssssss                      
680     *       .ssssss-          :ssssss                      
681     *        :ssssss-         :ssssss          `           
682     *         /ssssss/`       :ssssss        `/s+:`        
683     *          :sssssso:.     :ssssss      ./ssssss+`      
684     *           .+ssssssso/-.`:ssssss``.-/osssssss+.       
685     *             .+ssssssssssssssssssssssssssss+-         
686     *               `:+ssssssssssssssssssssss+:`           
687     *                  `.:+osssssssssssso+:.`              
688     *                        `/ssssss.`                    
689     *                         :ssssss                      
690     */