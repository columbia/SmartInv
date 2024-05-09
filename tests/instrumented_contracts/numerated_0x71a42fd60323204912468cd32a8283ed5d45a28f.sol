1 pragma solidity ^0.4.24;
2 
3 /* SLUGROAD
4 
5 Simple Fomo Game with fair scaling.
6 Slugroad has 3 different tracks: different networks, with different settings.
7 This is the Ethereum track.
8 
9 A car drives to hyperspeed.
10 Speed starts at a min of 100mph and rises to a max 1000mph over 7 days.
11 
12 Buy Slugs with ETH.
13 Slugs persist between loops!
14 
15 Get ETH divs from other Slug buys.
16 Use your earned ETH to Time Warp, buying Slugs for a cheaper price.
17 
18 Throw Slugs on the windshield to stop the car (+6 minute timer) and become the Driver.
19 
20 As the driver, you earn miles according to your speed.
21 Trade 6000 miles for 1% of the pot.
22 
23 Once the car reaches hyperspeed, the Driver starts draining the pot.
24 0.01% is drained every second, up to a maximum of 36% in one hour.
25 
26 The Driver can jump out of the window at any moment to secure his gains.
27 Once the Driver jumps out, the car drives freely.
28 Timer resets to 1 hour.
29 The wheel goes to the starter, but he gets no reward if the car crosses the finish line.
30 
31 If someone else throws Slugs before the Driver jumps out, he takes the wheel.
32 Timer resets to 6 minutes, and the Driver gets nothing!
33 
34 If the Driver keeps the wheel for one hour in hyperspeed, he gets the full pot.
35 Then we move to loop 2 immediately, on a 7 days timer.
36 
37 Slug price: (0.000025 + (loopchest/10000)) / loop
38 The price of slugs initially rises then lowers through a loop, as the pot is drained.
39 With each new loop, the price of slugs decrease significantly (cancel out early advantage)
40 
41 Players can Skip Ahead with the ether they won.
42 Slug price changes to (0.000025 + (loopchest/10000)) / (loop + 1)
43 Traveling through time will always be more fruitful than buying.
44 
45 Pot split:
46 - 60% divs
47 - 20% slugBank (reserve pot)
48 - 10% loopChest (round pot)
49 - 10% snailthrone
50 
51 */
52 
53 contract Slugroad {
54     using SafeMath for uint;
55     
56     /* Events */
57     
58     event WithdrewBalance (address indexed player, uint eth);
59     event BoughtSlug (address indexed player, uint eth, uint slug);
60     event SkippedAhead (address indexed player, uint eth, uint slug);
61     event TradedMile (address indexed player, uint eth, uint mile);
62     event BecameDriver (address indexed player, uint eth);
63     event TookWheel (address indexed player, uint eth);
64     event ThrewSlug (address indexed player);
65     event JumpedOut (address indexed player, uint eth);
66     event TimeWarped (address indexed player, uint indexed loop, uint eth);
67     event NewLoop (address indexed player, uint indexed loop);
68     event PaidThrone (address indexed player, uint eth);
69     event BoostedPot (address indexed player, uint eth);    
70 
71     /* Constants */
72     
73     uint256 constant public RACE_TIMER_START    = 604800; //7 days
74     uint256 constant public HYPERSPEED_LENGTH   = 3600; //1 hour
75 	uint256 constant public THROW_SLUG_REQ      = 200; //slugs to become driver
76     uint256 constant public DRIVER_TIMER_BOOST  = 360; //6 minutes
77     uint256 constant public SLUG_COST_FLOOR     = 0.000025 ether; //4 zeroes
78     uint256 constant public DIV_SLUG_COST       = 10000; //loop pot divider
79     uint256 constant public TOKEN_MAX_BUY       = 1 ether; //max allowed eth in one buy transaction
80     uint256 constant public MIN_SPEED           = 100;
81     uint256 constant public MAX_SPEED           = 1000;
82     uint256 constant public ACCEL_FACTOR        = 672; //inverse of acceleration per second
83     uint256 constant public MILE_REQ            = 6000; //required miles for 1% of the pot
84     address constant public SNAILTHRONE         = 0x261d650a521103428C6827a11fc0CBCe96D74DBc;
85 	
86     /* Variables */
87     
88     // Race starter
89     address public starter;
90     bool public gameStarted;
91     
92     // loop, timer, driver
93     uint256 public loop;
94     uint256 public timer;
95     address public driver;
96     
97     // Are we in hyperspeed?
98     bool public hyperSpeed = false;
99     
100     // Last driver claim
101     uint256 public lastHijack;
102     
103     // Pots
104     uint256 public loopChest;
105     uint256 public slugBank;
106     uint256 public thronePot;
107     
108     // Divs for one slug, max amount of slugs
109     uint256 public divPerSlug;
110     uint256 public maxSlug;
111     	
112     /* Mappings */
113     
114     mapping (address => uint256) public slugNest;
115     mapping (address => uint256) public playerBalance;
116     mapping (address => uint256) public claimedDiv;
117     mapping (address => uint256) public mile;
118 	
119     /* Functions */
120     
121     //-- GAME START --
122     
123     // Constructor
124     // Sets msg.sender as starter, to start the game properly
125     
126     constructor() public {
127         starter = msg.sender;
128         gameStarted = false;
129     }
130     
131     // StartRace
132     // Initialize timer
133     // Set starter as driver (starter can't win or trade miles)
134     // Buy tokens for value of message
135     
136     function StartRace() public payable {
137         require(gameStarted == false);
138         require(msg.sender == starter);
139         
140         timer = now.add(RACE_TIMER_START).add(HYPERSPEED_LENGTH);
141         loop = 1;
142         gameStarted = true;
143         lastHijack = now;
144         driver = starter;
145         BuySlug();
146     }
147 
148     //-- PRIVATE --
149 
150     // PotSplit
151     // Called on buy and hatch
152     // 60% divs, 20% slugBank, 10% loopChest, 10% thronePot
153     
154     function PotSplit(uint256 _msgValue) private {
155         divPerSlug = divPerSlug.add(_msgValue.mul(3).div(5).div(maxSlug));
156         slugBank = slugBank.add(_msgValue.div(5));
157         loopChest = loopChest.add(_msgValue.div(10));
158         thronePot = thronePot.add(_msgValue.div(10));
159     }
160     
161     // ClaimDiv
162     // Sends player dividends to his playerBalance
163     // Adjusts claimable dividends
164     
165     function ClaimDiv() private {
166         uint256 _playerDiv = ComputeDiv(msg.sender);
167         
168         if(_playerDiv > 0){
169             //Add new divs to claimed divs
170             claimedDiv[msg.sender] = claimedDiv[msg.sender].add(_playerDiv);
171                 
172             //Send divs to playerBalance
173             playerBalance[msg.sender] = playerBalance[msg.sender].add(_playerDiv);
174         }
175     }
176     
177     // BecomeDriver
178     // Gives driver role, and miles to previous driver
179     
180     function BecomeDriver() private {
181         
182         //give miles to previous driver
183         uint256 _mile = ComputeMileDriven();
184         mile[driver] = mile[driver].add(_mile);
185         
186         //if we're in hyperspeed, the new driver ends up 6 minutes before hyperspeed
187         if(now.add(HYPERSPEED_LENGTH) >= timer){
188             timer = now.add(DRIVER_TIMER_BOOST).add(HYPERSPEED_LENGTH);
189             
190             emit TookWheel(msg.sender, loopChest);
191             
192         //else, simply add 6 minutes to timer    
193         } else {
194             timer = timer.add(DRIVER_TIMER_BOOST);
195             
196             emit BecameDriver(msg.sender, loopChest);
197         }
198         
199         lastHijack = now;
200         driver = msg.sender;
201     }
202     
203     //-- ACTIONS --
204     
205     // TimeWarp
206     // Call manually when race is over
207     // Distributes loopchest and miles to winner, moves to next loop 
208     
209     function TimeWarp() public {
210 		require(gameStarted == true, "game hasn't started yet");
211         require(now >= timer, "race isn't finished yet");
212         
213         //give miles to driver
214         uint256 _mile = ComputeMileDriven();
215         mile[driver] = mile[driver].add(_mile);
216         
217         //Reset timer and start new loop 
218         timer = now.add(RACE_TIMER_START).add(HYPERSPEED_LENGTH);
219         loop = loop.add(1);
220         
221         //Adjust loop and slug pots
222         uint256 _nextPot = slugBank.div(2);
223         slugBank = slugBank.sub(_nextPot);
224         
225         //Make sure the car isn't driving freely
226         if(driver != starter){
227             
228             //Calculate reward
229             uint256 _reward = loopChest;
230         
231             //Change loopchest
232             loopChest = _nextPot;
233         
234             //Give reward
235             playerBalance[driver] = playerBalance[driver].add(_reward);
236         
237             emit TimeWarped(driver, loop, _reward);
238             
239         //Else, start a new loop with different event    
240         } else {
241             
242             //Change loopchest
243             loopChest = loopChest.add(_nextPot);
244 
245             emit NewLoop(msg.sender, loop);
246         }
247         
248         lastHijack = now;
249         //msg.sender becomes Driver
250         driver = msg.sender;
251     }
252     
253     // BuySlug
254     // Get token price, adjust maxSlug and divs, give slugs
255     
256     function BuySlug() public payable {
257         require(gameStarted == true, "game hasn't started yet");
258         require(tx.origin == msg.sender, "contracts not allowed");
259         require(msg.value <= TOKEN_MAX_BUY, "maximum buy = 1 ETH");
260 		require(now <= timer, "race is over!");
261         
262         //Calculate price and resulting slugs
263         uint256 _slugBought = ComputeBuy(msg.value, true);
264             
265         //Adjust player claimed divs
266         claimedDiv[msg.sender] = claimedDiv[msg.sender].add(_slugBought.mul(divPerSlug));
267             
268         //Change maxSlug before new div calculation
269         maxSlug = maxSlug.add(_slugBought);
270             
271         //Divide incoming ETH
272         PotSplit(msg.value);
273             
274         //Add player slugs
275         slugNest[msg.sender] = slugNest[msg.sender].add(_slugBought);
276         
277 		emit BoughtSlug(msg.sender, msg.value, _slugBought);
278 		
279         //Become driver if player bought at least 200 slugs
280         if(_slugBought >= 200){
281             BecomeDriver();
282         }       
283     }
284     
285     // SkipAhead
286     // Functions like BuySlug, using player balance
287     // Less cost per Slug (+1 loop)
288     
289     function SkipAhead() public {
290         require(gameStarted == true, "game hasn't started yet");
291         ClaimDiv();
292         require(playerBalance[msg.sender] > 0, "no ether to timetravel");
293 		require(now <= timer, "race is over!");
294         
295         //Calculate price and resulting slugs
296         uint256 _etherSpent = playerBalance[msg.sender];
297         uint256 _slugHatched = ComputeBuy(_etherSpent, false);
298             
299         //Adjust player claimed divs (reinvest + new slugs) and balance
300         claimedDiv[msg.sender] = claimedDiv[msg.sender].add(_slugHatched.mul(divPerSlug));
301         playerBalance[msg.sender] = 0;
302             
303         //Change maxSlug before new div calculation
304         maxSlug = maxSlug.add(_slugHatched);
305                     
306         //Divide reinvested ETH
307         PotSplit(_etherSpent);
308             
309         //Add player slugs
310         slugNest[msg.sender] = slugNest[msg.sender].add(_slugHatched);
311         
312 		emit SkippedAhead(msg.sender, _etherSpent, _slugHatched);
313 		
314         //Become driver if player hatched at least 200 slugs
315         if(_slugHatched >= 200){
316             BecomeDriver();
317         }
318     }
319     
320     // WithdrawBalance
321     // Sends player ingame ETH balance to his wallet
322     
323     function WithdrawBalance() public {
324         ClaimDiv();
325         require(playerBalance[msg.sender] > 0, "no ether to withdraw");
326         
327         uint256 _amount = playerBalance[msg.sender];
328         playerBalance[msg.sender] = 0;
329         msg.sender.transfer(_amount);
330         
331         emit WithdrewBalance(msg.sender, _amount);
332     }
333     
334     // ThrowSlug
335     // Throws slugs on the windshield to claim Driver
336     
337     function ThrowSlug() public {
338         require(gameStarted == true, "game hasn't started yet");
339         require(slugNest[msg.sender] >= THROW_SLUG_REQ, "not enough slugs in nest");
340         require(now <= timer, "race is over!");
341         
342         //Call ClaimDiv so ETH isn't blackholed
343         ClaimDiv();
344             
345         //Remove slugs
346         maxSlug = maxSlug.sub(THROW_SLUG_REQ);
347         slugNest[msg.sender] = slugNest[msg.sender].sub(THROW_SLUG_REQ);
348             
349         //Adjust msg.sender claimed dividends
350         claimedDiv[msg.sender] = claimedDiv[msg.sender].sub(THROW_SLUG_REQ.mul(divPerSlug));
351         
352 		emit ThrewSlug(msg.sender);
353 		
354         //Run become driver function
355         BecomeDriver();
356     }
357     
358     // JumpOut
359     // Driver jumps out of the car to secure his ETH gains
360     // Give him his miles as well
361     
362     function JumpOut() public {
363         require(gameStarted == true, "game hasn't started yet");
364         require(msg.sender == driver, "can't jump out if you're not in the car!");
365         require(msg.sender != starter, "starter isn't allowed to be driver");
366         
367         //give miles to driver
368         uint256 _mile = ComputeMileDriven();
369         mile[driver] = mile[driver].add(_mile);
370         
371         //calculate reward
372         uint256 _reward = ComputeHyperReward();
373             
374         //remove reward from pot
375         loopChest = loopChest.sub(_reward);
376             
377         //put timer back to 1 hours (+1 hour of hyperspeed)
378         timer = now.add(HYPERSPEED_LENGTH.mul(2));
379             
380         //give player his reward
381         playerBalance[msg.sender] = playerBalance[msg.sender].add(_reward);
382         
383         //set driver as the starter
384         driver = starter;
385         
386         //set lastHijack to reset miles count to 0 (easier on frontend)
387         lastHijack = now;
388             
389         emit JumpedOut(msg.sender, _reward);
390     }
391     
392     // TradeMile
393     // Exchanges player miles for part of the pot
394     
395     function TradeMile() public {
396         require(mile[msg.sender] >= MILE_REQ, "not enough miles for a reward");
397         require(msg.sender != starter, "starter isn't allowed to trade miles");
398         require(msg.sender != driver, "can't trade miles while driver");
399         
400         //divide player miles by req
401 		uint256 _mile = mile[msg.sender].div(MILE_REQ);
402 		
403 		//can't get more than 20% of the pot at once
404 		if(_mile > 20){
405 		    _mile = 20;
406 		}
407         
408         //calculate reward
409         uint256 _reward = ComputeMileReward(_mile);
410         
411         //remove reward from pot
412         loopChest = loopChest.sub(_reward);
413         
414         //lower player miles by amount spent
415         mile[msg.sender] = mile[msg.sender].sub(_mile.mul(MILE_REQ));
416         
417         //give player his reward
418         playerBalance[msg.sender] = playerBalance[msg.sender].add(_reward);
419         
420         emit TradedMile(msg.sender, _reward, _mile);
421     }
422     
423     // PayThrone
424     // Sends thronePot to SnailThrone
425     
426     function PayThrone() public {
427         uint256 _payThrone = thronePot;
428         thronePot = 0;
429         if (!SNAILTHRONE.call.value(_payThrone)()){
430             revert();
431         }
432         
433         emit PaidThrone(msg.sender, _payThrone);
434     }
435     
436     // fallback function
437     // Feeds the slugBank
438     
439     function() public payable {
440         slugBank = slugBank.add(msg.value);
441         
442         emit BoostedPot(msg.sender, msg.value);
443     }
444     
445     //-- VIEW --
446 
447     // ComputeHyperReward
448     // Returns ETH reward for driving in hyperspeed
449     // Reward = HYPERSPEED_LENGTH - (timer - now) * 0.01% * loopchest
450     // 0.01% = /10000
451     // This will throw before we're in hyperspeed, so account for that in frontend
452     
453     function ComputeHyperReward() public view returns(uint256) {
454         uint256 _remainder = timer.sub(now);
455         return HYPERSPEED_LENGTH.sub(_remainder).mul(loopChest).div(10000);
456     }
457 
458     // ComputeSlugCost
459     // Returns ETH required to buy one slug
460     // 1 slug = (S_C_FLOOR + (loopchest / DIV_SLUG_COST)) / loop 
461     // On hatch, add 1 to loop
462     
463     function ComputeSlugCost(bool _isBuy) public view returns(uint256) {
464         if(_isBuy == true){
465             return (SLUG_COST_FLOOR.add(loopChest.div(DIV_SLUG_COST))).div(loop);
466         } else {
467             return (SLUG_COST_FLOOR.add(loopChest.div(DIV_SLUG_COST))).div(loop.add(1));
468         }
469     }
470     
471     // ComputeBuy
472     // Returns slugs bought for a given amount of ETH
473     // True = buy, false = hatch
474     
475     function ComputeBuy(uint256 _ether, bool _isBuy) public view returns(uint256) {
476         uint256 _slugCost;
477         if(_isBuy == true){
478             _slugCost = ComputeSlugCost(true);
479         } else {
480             _slugCost = ComputeSlugCost(false);
481         }
482         return _ether.div(_slugCost);
483     }
484     
485     // ComputeDiv
486     // Returns unclaimed divs for a player
487     
488     function ComputeDiv(address _player) public view returns(uint256) {
489         //Calculate share of player
490         uint256 _playerShare = divPerSlug.mul(slugNest[_player]);
491 		
492         //Subtract already claimed divs
493     	_playerShare = _playerShare.sub(claimedDiv[_player]);
494         return _playerShare;
495     }
496     
497     // ComputeSpeed
498     // Returns current speed
499     // speed = maxspeed - ((timer - _time - 1 hour) / accelFactor)
500     
501     function ComputeSpeed(uint256 _time) public view returns(uint256) {
502         
503         //check we're not in hyperspeed
504         if(timer > _time.add(HYPERSPEED_LENGTH)){
505             
506             //check we're not more than 7 days away from end
507             if(timer.sub(_time) < RACE_TIMER_START){
508                 return MAX_SPEED.sub((timer.sub(_time).sub(HYPERSPEED_LENGTH)).div(ACCEL_FACTOR));
509             } else {
510                 return MIN_SPEED; //more than 7 days away
511             }
512         } else {
513             return MAX_SPEED; //hyperspeed
514         }
515     }
516     
517     // ComputeMileDriven
518     // Returns miles driven during this driver session
519     
520     function ComputeMileDriven() public view returns(uint256) {
521         uint256 _speedThen = ComputeSpeed(lastHijack);
522         uint256 _speedNow = ComputeSpeed(now);
523         uint256 _timeDriven = now.sub(lastHijack);
524         uint256 _averageSpeed = (_speedNow.add(_speedThen)).div(2);
525         return _timeDriven.mul(_averageSpeed).div(HYPERSPEED_LENGTH);
526     }
527     
528     // ComputeMileReward
529     // Returns ether reward for a given multiplier of the req
530     
531     function ComputeMileReward(uint256 _reqMul) public view returns(uint256) {
532         return _reqMul.mul(loopChest).div(100);
533     }
534     
535     // GetNest
536     // Returns player slugs
537     
538     function GetNest(address _player) public view returns(uint256) {
539         return slugNest[_player];
540     }
541     
542     // GetMile
543     // Returns player mile
544     
545     function GetMile(address _player) public view returns(uint256) {
546         return mile[_player];
547     }
548     
549     // GetBalance
550     // Returns player balance
551     
552     function GetBalance(address _player) public view returns(uint256) {
553         return playerBalance[_player];
554     }
555 }
556 
557 library SafeMath {
558 
559   /**
560   * @dev Multiplies two numbers, throws on overflow.
561   */
562   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
563     if (a == 0) {
564       return 0;
565     }
566     uint256 c = a * b;
567     assert(c / a == b);
568     return c;
569   }
570 
571   /**
572   * @dev Integer division of two numbers, truncating the quotient.
573   */
574   function div(uint256 a, uint256 b) internal pure returns (uint256) {
575     // assert(b > 0); // Solidity automatically throws when dividing by 0
576     uint256 c = a / b;
577     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
578     return c;
579   }
580 
581   /**
582   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
583   */
584   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
585     assert(b <= a);
586     return a - b;
587   }
588 
589   /**
590   * @dev Adds two numbers, throws on overflow.
591   */
592   function add(uint256 a, uint256 b) internal pure returns (uint256) {
593     uint256 c = a + b;
594     assert(c >= a);
595     return c;
596   }
597 }