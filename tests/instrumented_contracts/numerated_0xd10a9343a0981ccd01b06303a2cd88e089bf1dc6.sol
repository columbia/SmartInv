1 pragma solidity ^0.5.7;
2 
3 /* SNAILTROI
4 
5 SnailTroi is a daily ROI game, with extra twists to sustain it.
6 
7 1) TROI
8 To start, players spend ETH to Grow their Troi.
9 They get a "troi size" proportional to their investment.
10 Each player gets to harvest ETH equivalent to their troiSize.
11 This harvest starts equivalent to 1% of their initial, daily.
12 A global bonus rises by 8% per day (1% in 3 hours, roughly 0.0001% per second).
13 As soon as any player claims this global bonus, it resets to 0.
14 A player can only harvest once a day.
15 
16 2) FOUR KINGS
17 Players can spend ETH to collect up to 4 kings.
18 Each of these kings is a hot potato, with an unique effect.
19 The price of a king starts at 0.02 eth, and rises by 0.02 eth on each buy
20 
21 BLUE KING (0) - receives 4% divs on each buy
22 RED KING (1) - doubles global bonus for the owner
23 GREEN KING (2) - receives 4% divs on each claim
24 PURPLE KING (3) - receives 4% of the pot when the Doomclock stops
25 
26 3) DOOMCLOCK 
27 A timer starts at 24 hours, FOMO style.
28 If this timer reaches 0, whoever bought last gets 4% of the pot.
29 The Four Kings come back to their base price, and ETH gains relative to troiSize are lowered by 10%.
30 The Doomclock resets to 24 hours on a large enough buy.
31 The required buy starts at 0.001 ETH, and increases by 0.001 ETH on each reset.
32 
33 4) REFERRALS
34 Whenever a referred player claims, his referrer gets an extra 20% of his claim.
35 In the absence of referral, this extra 20% goes to the dev.
36 To be able to refer someone, a player must own a certain number of snails in SnailThrone.
37 Referrals can be changed at any time through a new GrowTroi action.
38 
39 5) DAILY BONUS
40 A daily timer of 24 hours runs nonstop.
41 Whoever spends the most ETH in one buy during this 24 hour period wins 2% of the pot.
42 
43 6) SPLIT
44 On GrowTroi:
45 - 90% to the troiPot (main pot)
46 - 10% to the thronePot (SnailThrone divs)
47 
48 On Kings:
49 - initial + 0.01 eth to the previous owner
50 - 0.005 eth to the troiPot
51 - 0.005 eth to the thronePot
52 
53 */
54 
55 contract SnailThrone {
56     mapping (address => uint256) public hatcherySnail;
57 }
58 
59 contract SnailTroi {
60     using SafeMath for uint;
61     
62     /* Event */
63 
64     event GrewTroi(address indexed player, uint eth, uint size);
65     event NewLeader(address indexed player, uint eth);
66     event HarvestedFroot(address indexed player, uint eth, uint size);
67     event BecameKing(address indexed player, uint eth, uint king);
68     event ResetClock(address indexed player, uint eth);
69     event Doomed(address leader, address king, uint eth);
70     event WonDaily (address indexed player, uint eth);
71     event WithdrewBalance (address indexed player, uint eth);
72     event PaidThrone (address indexed player, uint eth);
73     event BoostedChest (address indexed player, uint eth);
74 
75     /* Constants */
76     
77     uint256 constant SECONDS_IN_DAY     = 86400;
78     uint256 constant MINIMUM_INVEST     = 0.001 ether; //same value for Doomclock raise
79     uint256 constant KING_BASE_COST     = 0.02 ether; //resets to this everytime the Doomclock reaches 0
80     uint256 constant REFERRAL_REQ       = 420;
81     uint256 constant REFERRAL_PERCENT   = 20;
82     uint256 constant KING_PERCENT       = 4;
83     uint256 constant DAILY_PERCENT      = 2;
84     address payable constant SNAILTHRONE= 0x261d650a521103428C6827a11fc0CBCe96D74DBc;
85     
86 	SnailThrone throneContract;
87 
88     /* Variables */
89 	
90 	//Game status to ensure proper start
91 	bool public gameActive              = false;
92 	
93 	//Dev address for proper start
94 	address public dev                  = msg.sender;
95 	
96 	//Main reward pot
97 	uint256 public troiChest            = 0;
98 	
99 	//Divs for SnailThrone holders
100 	uint256 public thronePot            = 0;
101 	
102 	//Current reward per troiSize
103 	uint256 public troiReward           = 0.000001 ether; //divide by this to get troiSize per ETH
104 	
105 	//Doomclock
106 	uint256 public doomclockTimer;
107 	uint256 public doomclockCost        = MINIMUM_INVEST;
108 	address public doomclockLeader; //last buyer spending more ETH than doomclockCost
109 	
110 	//King struct
111 	struct King {
112         uint256 cost;
113         address owner;
114     }
115 
116     King[4] lostKing;
117 	
118 	//Last global claim
119 	uint256 public lastBonus;
120 	
121 	//Daily timer, leader, current max
122 	uint256 public dailyTimer;
123 	address public dailyLeader;
124 	uint256 public dailyMax;
125 	
126     /* Mappings */
127     
128     mapping (address => uint256) playerBalance;
129     mapping (address => uint256) troiSize;
130     mapping (address => uint256) lastFroot;
131     mapping (address => address) referral;
132 
133     /* Functions */
134     
135     // Constructor
136     
137     constructor() public {
138         throneContract = SnailThrone(SNAILTHRONE);
139     }
140     
141     // StartGame
142     // Only usable by owner once, to start the game properly
143     // Requires a seed of 1 ETH
144     
145     function StartGame() payable public {
146         require(gameActive != true, "game is already active");
147         require(msg.sender == dev, "you're not snailking!");
148         require(msg.value == 1 ether, "seed must be 1 ETH");
149         
150         //All seed ETH goes to Chest
151 		troiChest = msg.value;
152 		
153 		//Get troiSize to give
154         uint256 _growth = msg.value.div(troiReward);
155         
156         //Add player troiSize
157         troiSize[msg.sender] = troiSize[msg.sender].add(_growth);
158 		
159 		//Avoid blackholing ETH
160 		referral[msg.sender] = dev;
161 		doomclockLeader = dev;
162 		dailyLeader = dev;
163 		
164         for(uint256 i = 0; i < 4; i++){
165             lostKing[i].cost = KING_BASE_COST;
166             lostKing[i].owner = dev;
167         }
168         
169         dailyTimer = now.add(SECONDS_IN_DAY);
170         doomclockTimer = now.add(SECONDS_IN_DAY);
171         lastBonus = now;
172         lastFroot[msg.sender] = now;
173         gameActive = true;
174     }
175     
176     //-- PRIVATE --
177     
178     // CheckDailyTimer
179     // If we're over, give reward to leader and reset values
180     // Transfer thronePot to SnailThrone if balance > 0.01 ETH
181     
182     function CheckDailyTimer() private {
183         if(now > dailyTimer){
184             dailyTimer = now.add(SECONDS_IN_DAY);
185             uint256 _reward = troiChest.mul(DAILY_PERCENT).div(100);
186             troiChest = troiChest.sub(_reward);
187             playerBalance[dailyLeader] = playerBalance[dailyLeader].add(_reward);
188             dailyMax = 0;
189             
190             emit WonDaily(dailyLeader, _reward);
191             
192             if(thronePot > 0.01 ether){
193                 uint256 _payThrone = thronePot;
194                 thronePot = 0;
195                 (bool success, bytes memory data) = SNAILTHRONE.call.value(_payThrone)("");
196                 require(success);
197      
198                 emit PaidThrone(msg.sender, _payThrone);
199             }
200         }
201     }
202 
203     // CheckDoomclock
204     // If we're not over, check if enough ETH to reset
205     // Increase doomclockCost and change doomclockLeader if so
206     // Else, reward winners and reset Kings
207     
208     function CheckDoomclock(uint256 _msgValue) private {
209         if(now < doomclockTimer){
210             if(_msgValue >= doomclockCost){
211                 doomclockTimer = now.add(SECONDS_IN_DAY);
212                 doomclockCost = doomclockCost.add(MINIMUM_INVEST);
213                 doomclockLeader = msg.sender;
214                 
215                 emit ResetClock(msg.sender, doomclockCost);
216             }
217         } else {
218 			troiReward = troiReward.mul(9).div(10);
219             doomclockTimer = now.add(SECONDS_IN_DAY);
220             doomclockCost = MINIMUM_INVEST;
221             uint256 _reward = troiChest.mul(KING_PERCENT).div(100);
222             troiChest = troiChest.sub(_reward.mul(2));
223             playerBalance[doomclockLeader] = playerBalance[doomclockLeader].add(_reward);
224             playerBalance[lostKing[3].owner] = playerBalance[lostKing[3].owner].add(_reward);
225             
226             for(uint256 i = 0; i < 4; i++){
227             lostKing[i].cost = KING_BASE_COST;
228             }
229             
230             emit Doomed(doomclockLeader, lostKing[3].owner, _reward);
231         }
232     }
233     
234     //-- GAME ACTIONS --
235     
236     // GrowTroi
237     // Claims divs if need be
238     // Gives player troiSize in exchange for ETH
239     // Checks Doomclock, dailyMax
240     
241     function GrowTroi(address _ref) public payable {
242         require(gameActive == true, "game hasn't started yet");
243         require(tx.origin == msg.sender, "no contracts allowed");
244         require(msg.value >= MINIMUM_INVEST, "at least 1 finney to grow a troi");
245         require(_ref != msg.sender, "can't refer yourself, silly");
246         
247         //Call HarvestFroot if player is already invested, else set lastFroot to now
248         if(troiSize[msg.sender] != 0){
249             HarvestFroot();
250         } else {
251             lastFroot[msg.sender] = now;
252         }
253         
254         //Assign new ref. If referrer lacks snail requirement, dev becomes referrer
255         uint256 _snail = GetSnail(_ref);
256         if(_snail >= REFERRAL_REQ){
257             referral[msg.sender] = _ref;
258         } else {
259             referral[msg.sender] = dev;
260         }
261 
262         //Split ETH to pot
263         uint256 _chestTemp = troiChest.add(msg.value.mul(9).div(10));
264         thronePot = thronePot.add(msg.value.div(10));
265         
266         //Give reward to Blue King
267         uint256 _reward = msg.value.mul(KING_PERCENT).div(100);
268         _chestTemp = _chestTemp.sub(_reward);
269         troiChest = _chestTemp;
270         playerBalance[lostKing[0].owner] = playerBalance[lostKing[0].owner].add(_reward);
271         
272         //Get troiSize to give
273         uint256 _growth = msg.value.div(troiReward);
274         
275         //Add player troiSize
276         troiSize[msg.sender] = troiSize[msg.sender].add(_growth);
277         
278         //Emit event
279         emit GrewTroi(msg.sender, msg.value, troiSize[msg.sender]);
280     
281         //Check msg.value against dailyMax
282         if(msg.value > dailyMax){
283             dailyMax = msg.value;
284             dailyLeader = msg.sender;
285             
286             emit NewLeader(msg.sender, msg.value);
287         }
288         
289         //Check dailyTimer
290         CheckDailyTimer();
291         
292         //Check Doomclock
293         CheckDoomclock(msg.value);
294     }
295     
296     // HarvestFroot
297     // Gives player his share of ETH, according to global bonus
298     // Sets his lastFroot to now, sets lastBonus to now
299     // Checks Doomclock
300     
301     function HarvestFroot() public {
302         require(gameActive == true, "game hasn't started yet");
303         require(troiSize[msg.sender] > 0, "grow your troi first");
304         uint256 _timeSince = lastFroot[msg.sender].add(SECONDS_IN_DAY);
305         require(now > _timeSince, "your harvest isn't ready");
306         
307         //Get ETH reward for player and ref
308         uint256 _reward = ComputeHarvest();
309         uint256 _ref = _reward.mul(REFERRAL_PERCENT).div(100);
310         uint256 _king = _reward.mul(KING_PERCENT).div(100);
311         
312         //Set lastFroot and lastBonus
313         lastFroot[msg.sender] = now;
314         lastBonus = now;
315         
316         //Lower troiPot
317         troiChest = troiChest.sub(_reward).sub(_ref).sub(_king);
318         
319         //Give referral reward
320         playerBalance[referral[msg.sender]] = playerBalance[referral[msg.sender]].add(_ref);
321         
322         //Give green king reward
323         playerBalance[lostKing[2].owner] = playerBalance[lostKing[2].owner].add(_king);
324         
325         //Give player reward
326         playerBalance[msg.sender] = playerBalance[msg.sender].add(_reward);
327         
328         emit HarvestedFroot(msg.sender, _reward, troiSize[msg.sender]);
329         
330         //Check dailyTimer
331         CheckDailyTimer();
332         
333         //Check Doomclock
334         CheckDoomclock(0);
335     }
336     
337     // BecomeKing
338     // Player becomes the owner of a King in exchange for ETH
339     // Pays out previous owner, increases cost
340     
341     function BecomeKing(uint256 _id) payable public {
342         require(gameActive == true, "game is paused");
343         require(tx.origin == msg.sender, "no contracts allowed");
344         require(msg.value == lostKing[_id].cost, "wrong ether cost for king");
345         
346         //split 0.01 ETH to pots
347         troiChest = troiChest.add(KING_BASE_COST.div(4));
348         thronePot = thronePot.add(KING_BASE_COST.div(4));
349         
350         //give value - 0.01 ETH to previous owner
351         uint256 _prevReward = msg.value.sub(KING_BASE_COST.div(2));
352         address _prevOwner = lostKing[_id].owner;
353         playerBalance[_prevOwner] = playerBalance[_prevOwner].add(_prevReward);
354         
355         //give King to flipper, increase cost
356         lostKing[_id].owner = msg.sender;
357         lostKing[_id].cost = lostKing[_id].cost.add(KING_BASE_COST);
358         
359         emit BecameKing(msg.sender, msg.value, _id);
360     }
361     
362     //-- MISC ACTIONS --
363     
364     // WithdrawBalance
365     // Withdraws the ETH balance of a player to his wallet
366     
367     function WithdrawBalance() public {
368         require(playerBalance[msg.sender] > 0, "no ETH in player balance");
369         
370         uint _amount = playerBalance[msg.sender];
371         playerBalance[msg.sender] = 0;
372         msg.sender.transfer(_amount);
373         
374         emit WithdrewBalance(msg.sender, _amount);
375     }
376     
377     // fallback function
378     // Feeds the troiChest
379     
380     function() external payable {
381         troiChest = troiChest.add(msg.value);
382         
383         emit BoostedChest(msg.sender, msg.value);
384     }
385     
386     //-- CALCULATIONS --
387     
388     // ComputeHarvest
389     // Returns ETH reward for HarvestShare
390     
391     function ComputeHarvest() public view returns(uint256) {
392         
393         //Get time since last Harvest
394         uint256 _timeLapsed = now.sub(lastFroot[msg.sender]);
395         
396         //Get current bonus
397         uint256 _bonus = ComputeBonus();
398         //Compute reward
399         uint256 _reward = troiReward.mul(troiSize[msg.sender]).mul(_timeLapsed.add(_bonus)).div(SECONDS_IN_DAY).div(100);
400         
401         //Check reward + ref + king isn't above remaining troiChest
402         uint256 _sum = _reward.add(_reward.mul(REFERRAL_PERCENT.add(KING_PERCENT)).div(100));
403         if(_sum > troiChest){
404             _reward = troiChest.mul(100).div(REFERRAL_PERCENT.add(KING_PERCENT).add(100));
405         }
406         return _reward;
407     }
408     
409     // ComputeBonus 
410     // Returns time since last bonus x 8
411     
412     function ComputeBonus() public view returns(uint256) {
413         uint256 _bonus = (now.sub(lastBonus)).mul(8);
414         if(msg.sender == lostKing[1].owner){
415             _bonus = _bonus.mul(2);
416         }
417         return _bonus;
418     }
419     
420     //-- GETTERS --
421     
422     function GetTroi(address adr) public view returns(uint256) {
423         return troiSize[adr];
424     }
425 	
426 	function GetMyBalance() public view returns(uint256) {
427 	    return playerBalance[msg.sender];
428 	}
429 	
430 	function GetMyLastHarvest() public view returns(uint256) {
431 	    return lastFroot[msg.sender];
432 	}
433 	
434 	function GetMyReferrer() public view returns(address) {
435 	    return referral[msg.sender];
436 	}
437 	
438 	function GetSnail(address _adr) public view returns(uint256) {
439         return throneContract.hatcherySnail(_adr);
440     }
441 	
442 	function GetKingCost(uint256 _id) public view returns(uint256) {
443 		return lostKing[_id].cost;
444 	}
445 	
446 	function GetKingOwner(uint256 _id) public view returns(address) {
447 		return lostKing[_id].owner;
448 	}
449 }
450 
451 /* SafeMath library */
452 
453 library SafeMath {
454 
455   /**
456   * @dev Multiplies two numbers, throws on overflow.
457   */
458   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
459     if (a == 0) {
460       return 0;
461     }
462     uint256 c = a * b;
463     assert(c / a == b);
464     return c;
465   }
466 
467   /**
468   * @dev Integer division of two numbers, truncating the quotient.
469   */
470   function div(uint256 a, uint256 b) internal pure returns (uint256) {
471     // assert(b > 0); // Solidity automatically throws when dividing by 0
472     uint256 c = a / b;
473     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
474     return c;
475   }
476 
477   /**
478   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
479   */
480   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
481     assert(b <= a);
482     return a - b;
483   }
484 
485   /**
486   * @dev Adds two numbers, throws on overflow.
487   */
488   function add(uint256 a, uint256 b) internal pure returns (uint256) {
489     uint256 c = a + b;
490     assert(c >= a);
491     return c;
492   }
493 }