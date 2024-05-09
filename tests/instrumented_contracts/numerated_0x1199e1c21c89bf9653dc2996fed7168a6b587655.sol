1 pragma solidity ^0.4.24;
2 
3 /* SNAILTREE
4 
5 // SnailTree is a mock HYIP, coupled with a jackpot.
6 
7 // To start, players spend ETH to plant a root.
8 // They get a "tree size" proportional to their investment.
9 // They also get Pecans the moment they invest.
10 // Pecan number starts proportional to ETH, and then multiplied.
11 // This buy multiplier is global.
12 // The longer nobody plants a root, the bigger multiplier.
13 
14 // Each player gets to claim ETH equivalent to their treeSize.
15 // This claim starts equivalent to 4% of their initial, daily.
16 // This claim also gets them Pecans.
17 // The amount of Pecans given raises with time.
18 // This claim multiplier builds up the longer the player doesn't claim.
19 
20 // Instead of claiming ETH, players can grow their tree.
21 // Growing the tree reinvests the ETH they would have claimed.
22 // Their treeSize raises proportionally.
23 // If their lastClaim was at least one hour ago, they receive a boost.
24 // Boosts are straight multipliers to Pecan rewards.
25 
26 // A player can give Pecans to Wonkers the Squirrel,
27 // And receive ETH in return, from the wonkPot.
28 // Once Wonkers receives enough Pecans, the round is over.
29 // Whoever gave him Pecans last wins the roundPot (20% of the jackPot).
30 
31 // A new round starts immediately.
32 // Players from the previous round see their treeSize decrease by 20%.
33 // Their growth boost also resets to 1.
34 // This occurs automatically on their next action.
35 
36 */
37 
38 contract SnailTree {
39     using SafeMath for uint;
40     
41     /* Event */
42     
43     event PlantedRoot(address indexed player, uint eth, uint pecan, uint treesize);
44     event GavePecan(address indexed player, uint eth, uint pecan);
45     event ClaimedShare(address indexed player, uint eth, uint pecan);
46     event GrewTree(address indexed player, uint eth, uint pecan, uint boost);
47     event WonRound (address indexed player, uint indexed round, uint eth);
48     event WithdrewBalance (address indexed player, uint eth);
49     event PaidThrone (address indexed player, uint eth);
50     event BoostedPot (address indexed player, uint eth);
51 
52     /* Constants */
53     
54     uint256 constant SECONDS_IN_HOUR    = 3600;
55     uint256 constant SECONDS_IN_DAY     = 86400;
56     uint256 constant PECAN_WIN_FACTOR   = 0.0000000001 ether; //add 1B pecans per 0.1 ETH in pot
57     uint256 constant TREE_SIZE_COST     = 0.0000005 ether; //= 1 treeSize
58     uint256 constant REWARD_SIZE_ETH    = 0.00000002 ether; //4% per day per treeSize
59     address constant SNAILTHRONE        = 0x261d650a521103428C6827a11fc0CBCe96D74DBc;
60 
61     /* Variables */
62     
63 	//Current round
64     uint256 public gameRound            = 0;
65 	
66 	//Fund for %claims
67 	uint256 public treePot              = 0;
68 	
69 	//Direct rewards
70 	uint256 public wonkPot              = 0;
71 	
72 	//Round winner reward
73 	uint256 public jackPot              = 0;
74 	
75 	//Divs for SnailThrone holders
76 	uint256 public thronePot            = 0;
77 	
78 	//Pecans required to win this round
79 	uint256 public pecanToWin           = 0;
80 	
81 	//Pecans given this round
82 	uint256 public pecanGiven           = 0;
83 	
84 	//Last ETH investment
85 	uint256 public lastRootPlant        = 0;
86 	
87     /* Mappings */
88     
89     mapping (address => uint256) playerRound;
90     mapping (address => uint256) playerBalance;
91     mapping (address => uint256) treeSize;
92     mapping (address => uint256) pecan;
93     mapping (address => uint256) lastClaim;
94     mapping (address => uint256) boost;
95 
96     /* Functions */
97     
98     // Constructor
99     // Sets round to 1 and lastRootPlant to now
100     
101     constructor() public {
102         gameRound = 1;
103         pecanToWin = 1;
104         lastRootPlant = now;
105     }
106     
107     //-- PRIVATE --
108     
109     // CheckRound
110     // Ensures player is on correct round
111     // If not, reduce his treeSize by 20% per round missed
112     // Increase his round until he's on the correct one
113     
114     function CheckRound() private {       
115         while(playerRound[msg.sender] != gameRound){
116             treeSize[msg.sender] = treeSize[msg.sender].mul(4).div(5);
117             playerRound[msg.sender] = playerRound[msg.sender].add(1);
118             boost[msg.sender] = 1;
119         }
120     }
121     
122     // WinRound
123     // Called when a player gives enough Pecans to Wonkers
124     // Gives his earnings to winner
125     
126     function WinRound(address _msgSender) private {
127         
128         //Increment round
129         uint256 _round = gameRound;
130         gameRound = gameRound.add(1);
131         
132         //Compute reward and adjust pot
133         uint256 _reward = jackPot.div(5);
134         jackPot = jackPot.sub(_reward);
135         
136         //Reset pecan given to 0
137         pecanGiven = 0;
138         
139         //Set new pecan requirement
140         pecanToWin = ComputePecanToWin();
141     
142         //Send reward
143         playerBalance[_msgSender] = playerBalance[_msgSender].add(_reward);
144         
145         emit WonRound(_msgSender, _round, _reward);
146     }
147     
148     // PotSplit
149 	// Allocates the ETH of every transaction
150 	// 40% treePot, 30% wonkPot, 20% jackPot, 10% thronePot
151     
152     function PotSplit(uint256 _msgValue) private {
153         
154         treePot = treePot.add(_msgValue.mul(4).div(10));
155         wonkPot = wonkPot.add(_msgValue.mul(3).div(10));
156         jackPot = jackPot.add(_msgValue.div(5));
157         thronePot = thronePot.add(_msgValue.div(10));
158     }
159     
160     //-- GAME ACTIONS --
161     
162     // PlantRoot
163     // Gives player treeSize and pecan
164     // Sets lastRootPlant and lastClaim to now
165     
166     function PlantRoot() public payable {
167         require(tx.origin == msg.sender, "no contracts allowed");
168         require(msg.value >= 0.001 ether, "at least 1 finney to plant a root");
169 
170         //Check if player is in correct round
171         CheckRound();
172 
173         //Split ETH to pot
174         PotSplit(msg.value);
175         
176         //Set new pecan requirement
177         pecanToWin = ComputePecanToWin();
178         
179         //Get pecans to give
180         uint256 _newPecan = ComputePlantPecan(msg.value);
181         
182         //Set claims to now
183         lastRootPlant = now;
184         lastClaim[msg.sender] = now;
185         
186         //Get treeSize to give
187         uint256 _treePlant = msg.value.div(TREE_SIZE_COST);
188         
189         //Add player treeSize
190         treeSize[msg.sender] = treeSize[msg.sender].add(_treePlant);
191         
192         //Add player pecans
193         pecan[msg.sender] = pecan[msg.sender].add(_newPecan);
194         
195         emit PlantedRoot(msg.sender, msg.value, _newPecan, treeSize[msg.sender]);
196     }
197     
198     // GivePecan
199     // Exchanges player Pecans for ETH
200 	// Wins the round if enough Pecans are given
201     
202     function GivePecan(uint256 _pecanGift) public {
203         require(pecan[msg.sender] >= _pecanGift, "not enough pecans");
204         
205         //Check if player is in correct round
206         CheckRound();
207         
208         //Get reward
209         uint256 _ethReward = ComputeWonkTrade(_pecanGift);
210         
211         //Lower player pecan
212         pecan[msg.sender] = pecan[msg.sender].sub(_pecanGift);
213         
214         //Adjust pecan given
215         pecanGiven = pecanGiven.add(_pecanGift);
216         
217         //Lower wonkPot
218         wonkPot = wonkPot.sub(_ethReward);
219         
220         //Give reward
221         playerBalance[msg.sender] = playerBalance[msg.sender].add(_ethReward);
222         
223         //Check if player Wins
224         if(pecanGiven >= pecanToWin){
225             WinRound(msg.sender);
226         } else {
227 			emit GavePecan(msg.sender, _ethReward, _pecanGift);
228 		}
229     }
230     
231     // ClaimShare
232     // Gives player his share of ETH, and Pecans
233     // Sets his lastClaim to now
234     
235     function ClaimShare() public {
236         require(treeSize[msg.sender] > 0, "plant a root first");
237 		
238         //Check if player is in correct round
239         CheckRound();
240         
241         //Get ETH reward
242         uint256 _ethReward = ComputeEtherShare(msg.sender);
243         
244         //Get Pecan reward
245         uint256 _pecanReward = ComputePecanShare(msg.sender);
246         
247         //Set lastClaim
248         lastClaim[msg.sender] = now;
249         
250         //Lower treePot
251         treePot = treePot.sub(_ethReward);
252         
253         //Give rewards
254         pecan[msg.sender] = pecan[msg.sender].add(_pecanReward);
255         playerBalance[msg.sender] = playerBalance[msg.sender].add(_ethReward);
256         
257         emit ClaimedShare(msg.sender, _ethReward, _pecanReward);
258     }
259     
260     // GrowTree
261     // Uses player share to grow his treeSize
262     // Gives share pecans multiplied by boost
263     // Increases boost if last claim was at least one hour ago
264     
265     function GrowTree() public {
266         require(treeSize[msg.sender] > 0, "plant a root first");
267 
268         //Check if player is in correct round
269         CheckRound();
270         
271         //Get ETH used
272         uint256 _ethUsed = ComputeEtherShare(msg.sender);
273         
274         //Get Pecan reward
275         uint256 _pecanReward = ComputePecanShare(msg.sender);
276         
277         //Check if player gets a boost increase
278         uint256 _timeSpent = now.sub(lastClaim[msg.sender]);
279         
280         //Set lastClaim
281         lastClaim[msg.sender] = now;
282         
283         //Get treeSize to give
284         uint256 _treeGrowth = _ethUsed.div(TREE_SIZE_COST);
285         
286         //Add player treeSize
287         treeSize[msg.sender] = treeSize[msg.sender].add(_treeGrowth);
288         
289         //Give boost if eligible (maximum +10 at once)
290         if(_timeSpent >= SECONDS_IN_HOUR){
291             uint256 _boostPlus = _timeSpent.div(SECONDS_IN_HOUR);
292             if(_boostPlus > 10){
293                 _boostPlus = 10;
294             }
295             boost[msg.sender] = boost[msg.sender].add(_boostPlus);
296         }
297         
298         //Give Pecan reward
299         pecan[msg.sender] = pecan[msg.sender].add(_pecanReward);
300         
301         emit GrewTree(msg.sender, _ethUsed, _pecanReward, boost[msg.sender]);
302     }
303     
304     //-- MISC ACTIONS --
305     
306     // WithdrawBalance
307     // Withdraws the ETH balance of a player to his wallet
308     
309     function WithdrawBalance() public {
310         require(playerBalance[msg.sender] > 0, "no ETH in player balance");
311         
312         uint _amount = playerBalance[msg.sender];
313         playerBalance[msg.sender] = 0;
314         msg.sender.transfer(_amount);
315         
316         emit WithdrewBalance(msg.sender, _amount);
317     }
318     
319     // PayThrone
320     // Sends thronePot to SnailThrone
321     
322     function PayThrone() public {
323         uint256 _payThrone = thronePot;
324         thronePot = 0;
325         if (!SNAILTHRONE.call.value(_payThrone)()){
326             revert();
327         }
328         
329         emit PaidThrone(msg.sender, _payThrone);
330     }
331     
332     // fallback function
333     // Feeds the jackPot
334     
335     function() public payable {
336         jackPot = jackPot.add(msg.value);
337         
338         emit BoostedPot(msg.sender, msg.value);
339     }
340     
341     //-- CALCULATIONS --
342     
343     // ComputeEtherShare
344     // Returns ETH reward for a claim
345     // Reward = 0.00000002 ETH per treeSize per day
346     
347     function ComputeEtherShare(address adr) public view returns(uint256) {
348         
349         //Get time since last claim
350         uint256 _timeLapsed = now.sub(lastClaim[adr]);
351         
352         //Compute reward
353         uint256 _reward = _timeLapsed.mul(REWARD_SIZE_ETH).mul(treeSize[adr]).div(SECONDS_IN_DAY);
354         
355         //Check reward isn't above remaining treePot
356         if(_reward >= treePot){
357             _reward = treePot;
358         }
359         return _reward;
360     }
361     
362     // ComputeShareBoostFactor
363     // Returns current personal Pecan multiplier
364     // Starts at 4, adds 1 per hour
365     
366     function ComputeShareBoostFactor(address adr) public view returns(uint256) {
367         
368         //Get time since last claim
369         uint256 _timeLapsed = now.sub(lastClaim[adr]);
370         
371         //Compute boostFactor (starts at 4, +1 per hour)
372         uint256 _boostFactor = (_timeLapsed.div(SECONDS_IN_HOUR)).add(4);
373         return _boostFactor;
374     }
375     
376     // ComputePecanShare
377     // Returns Pecan reward for a claim
378     // Reward = 1 Pecan per treeSize per day, multiplied by personal boost
379     
380     function ComputePecanShare(address adr) public view returns(uint256) {
381         
382         //Get time since last claim
383         uint256 _timeLapsed = now.sub(lastClaim[adr]);
384         
385         //Get boostFactor
386         uint256 _shareBoostFactor = ComputeShareBoostFactor(adr);
387         
388         //Compute reward
389         uint256 _reward = _timeLapsed.mul(treeSize[adr]).mul(_shareBoostFactor).mul(boost[msg.sender]).div(SECONDS_IN_DAY);
390         return _reward;
391     }
392     
393     // ComputePecanToWin
394     // Returns amount of Pecans that must be given to win the round
395     // Pecans to win = 1B + (1B per 0.2 ETH in jackpot) 
396     
397     function ComputePecanToWin() public view returns(uint256) {
398         uint256 _pecanToWin = jackPot.div(PECAN_WIN_FACTOR);
399         return _pecanToWin;
400     }
401     
402     // ComputeWonkTrade
403     // Returns ETH reward for a given amount of Pecans
404     // % of wonkPot rewarded = (Pecans gifted / Pecans to win) / 2, maximum 50% 
405     
406     function ComputeWonkTrade(uint256 _pecanGift) public view returns(uint256) {
407         
408         //Make sure gift isn't above requirement to win
409         if(_pecanGift > pecanToWin) {
410             _pecanGift = pecanToWin;
411         }
412         uint256 _reward = _pecanGift.mul(wonkPot).div(pecanToWin).div(2);
413         return _reward;
414     }
415     
416     // ComputePlantBoostFactor
417     // Returns global boost multiplier
418     // +1% per second
419     
420     function ComputePlantBoostFactor() public view returns(uint256) {
421         
422         //Get time since last global plant
423         uint256 _timeLapsed = now.sub(lastRootPlant);
424         
425         //Compute boostFactor (starts at 100, +1 per second)
426         uint256 _boostFactor = (_timeLapsed.mul(1)).add(100);
427         return _boostFactor;
428     }
429     
430     // ComputePlantPecan
431     // Returns Pecan reward for a given buy
432     // 1 Pecan per the cost of 1 Tree Size, multiplied by global boost
433     
434     function ComputePlantPecan(uint256 _msgValue) public view returns(uint256) {
435 
436         //Get boostFactor
437         uint256 _treeBoostFactor = ComputePlantBoostFactor();
438         
439         //Compute reward 
440         uint256 _reward = _msgValue.mul(_treeBoostFactor).div(TREE_SIZE_COST).div(100);
441         return _reward;
442     }
443 
444     //-- GETTERS --
445     
446     function GetTree(address adr) public view returns(uint256) {
447         return treeSize[adr];
448     }
449     
450     function GetPecan(address adr) public view returns(uint256) {
451         return pecan[adr];
452     }
453 	
454 	function GetMyBoost() public view returns(uint256) {
455         return boost[msg.sender];
456     }
457 	
458 	function GetMyBalance() public view returns(uint256) {
459 	    return playerBalance[msg.sender];
460 	}
461 	
462 	function GetMyRound() public view returns(uint256) {
463 	    return playerRound[msg.sender];
464 	}
465 	
466 	function GetMyLastClaim() public view returns(uint256) {
467 	    return lastClaim[msg.sender];
468 	}
469 }
470 
471 /* SafeMath library */
472 
473 library SafeMath {
474 
475   /**
476   * @dev Multiplies two numbers, throws on overflow.
477   */
478   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
479     if (a == 0) {
480       return 0;
481     }
482     uint256 c = a * b;
483     assert(c / a == b);
484     return c;
485   }
486 
487   /**
488   * @dev Integer division of two numbers, truncating the quotient.
489   */
490   function div(uint256 a, uint256 b) internal pure returns (uint256) {
491     // assert(b > 0); // Solidity automatically throws when dividing by 0
492     uint256 c = a / b;
493     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
494     return c;
495   }
496 
497   /**
498   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
499   */
500   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
501     assert(b <= a);
502     return a - b;
503   }
504 
505   /**
506   * @dev Adds two numbers, throws on overflow.
507   */
508   function add(uint256 a, uint256 b) internal pure returns (uint256) {
509     uint256 c = a + b;
510     assert(c >= a);
511     return c;
512   }
513 }