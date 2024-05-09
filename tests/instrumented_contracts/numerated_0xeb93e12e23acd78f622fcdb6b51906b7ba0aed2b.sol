1 pragma solidity ^0.4.24;
2 
3 /* SNAILFARM 2
4 
5 // We keep the same basics as SnailFarm: hatch eggs into snails, buy or sell eggs for money.
6 // Hatching now comes with a small ETH cost.
7 // Your snails don't die anymore when you sell eggs.
8 // Referrals are gone.
9 // The formula for buying and selling eggs is simplified.
10 // Only a finite number of eggs is available for sale.
11 // This number is based on initial seed, and varies based on player buys and sells.
12 // Eggs sell for half of the current buy price.
13 // There is no more extra inflation tied to hatching.
14 
15 // The ultimate goal of the game is the Snailmaster title.
16 // The reward is now a lump sum rather than a constant fee.
17 // To become Snailmaster, you need a certain number of snails.
18 // Once you take the Snailmaster title, you lose 90% of your snails.
19 // 20% of the snailpot is immediately paid out to the Snailmaster.
20 // When someone becomes the Snailmaster, a new round starts.
21 // The amount of snails required to claim the title increases with each new round.
22 // The amount of starting snails also increases by that same amount for new players.
23 
24 // We introduce a new mechanic: the Ethertree.
25 // Every ETH added to the contract is split 50/50 between the snailpot and the treepot.
26 // Players can claim ETH from the ethertree through selling acorns.
27 // Players can buy acorns for twice their current price.
28 // (Half of the ETH goes in the snailpot, half of the ETH buys acorns at their going rate.)
29 // Players get a better rate on acorn buys if the current snailpot is under the previous snailpot.
30 // The price of acorns can only rise over time.
31 
32 // We add three hot potato items: the SpiderQueen, the TadpolePrince, and the SquirrelDuke.
33 // Owning any of these boosts adds base hatch size to your hatch, cumulative.
34 // (With 2 boosts, you get 1+1+1 = 3 times the snails when you hatch your eggs.)
35 // The Tadpole Prince costs ETH, and rises by 20% with every buy.
36 // 10% goes to the previous holder, 5% goes to the snailpot, 5% to the treepot.
37 // The Spider Queen costs snails, this cost doubles with every buy.
38 // The Squirrel Duke costs acorns, this cost doubles with every buy.
39 
40 */
41 
42 contract SnailFarm2 {
43     using SafeMath for uint;
44     
45     /* Event */
46     
47     event SoldAcorn (address indexed seller, uint acorns, uint eth);
48     event BoughtAcorn (address indexed buyer, uint acorns, uint eth);
49     event BecameMaster (address indexed newmaster, uint indexed round, uint reward, uint pot);
50     event WithdrewEarnings (address indexed player, uint eth);
51     event Hatched (address indexed player, uint eggs, uint snails);
52     event SoldEgg (address indexed seller, uint eggs, uint eth);
53     event BoughtEgg (address indexed buyer, uint eggs, uint eth);
54     event StartedSnailing (address indexed player, uint indexed round);
55     event BecameQueen (address indexed newqueen, uint indexed round, uint newreq);
56     event BecameDuke (address indexed newduke, uint indexed round, uint newreq);
57     event BecamePrince (address indexed newprince, uint indexed round, uint newreq);
58 
59     /* Constants */
60     
61     uint256 public TIME_TO_HATCH_1SNAIL = 86400; //seconds in a day
62     uint256 public STARTING_SNAIL       = 200;
63     uint256 public SNAILMASTER_INCREASE = 100000;
64     uint256 public STARTING_SNAIL_COST  = 0.004 ether;
65     uint256 public HATCHING_COST        = 0.0008 ether;
66     uint256 public SPIDER_BASE_REQ      = 80;
67     uint256 public SPIDER_BOOST         = 1;
68     uint256 public TADPOLE_BASE_REQ     = 0.02 ether;
69     uint256 public TADPOLE_BOOST        = 1;
70 	uint256 public SQUIRREL_BASE_REQ    = 1;
71     uint256 public SQUIRREL_BOOST       = 1;
72 
73 	
74     /* Variables */
75     
76 	//Becomes true one time to start the game
77     bool public gameStarted             = false;
78 	
79 	//Used to ensure a proper game start
80     address public gameOwner;
81 	
82 	//Current round
83     uint256 public round                = 0;
84 	
85 	//Owners of hot potatoes
86     address public currentSpiderOwner;
87     address public currentTadpoleOwner;
88 	address public currentSquirrelOwner;
89 	
90 	//Current requirement for hot potatoes
91 	uint256 public spiderReq;
92     uint256 public tadpoleReq;
93 	uint256 public squirrelReq;
94 	
95 	//Current requirement for snailmaster
96     uint256 public snailmasterReq       = SNAILMASTER_INCREASE;
97     
98     //Current amount of snails given to new players
99 	uint256 public startingSnailAmount  = STARTING_SNAIL;
100 	
101 	//Current number of eggs for sale
102     uint256 public marketEggs;
103 	
104 	//Current number of acorns in existence
105 	uint256 public totalAcorns;
106 		
107 	//Ether pots
108     uint256 public snailPot;
109 	uint256 public previousSnailPot;
110     uint256 public treePot;
111 
112     	
113     /* Mappings */
114     
115 	mapping (address => bool) public hasStartingSnails;
116     mapping (address => uint256) public hatcherySnail;
117     mapping (address => uint256) public claimedEggs;
118     mapping (address => uint256) public lastHatch;
119     mapping (address => uint256) public playerAcorns;
120     mapping (address => uint256) public playerEarnings;
121     mapping (address => uint256) public playerProdBoost;
122     
123 	
124     /* Functions */
125     
126     // Constructor
127     // Sets msg.sender as gameOwner for SeedMarket purposes
128     // Assigns all hot potatoes to gameOwner and sets his prodBoost accordingly
129     // (gameOwner is banned from playing the game)
130     
131     constructor() public {
132         gameOwner = msg.sender;
133         
134         currentTadpoleOwner = gameOwner;
135         currentSquirrelOwner = gameOwner;
136         currentSpiderOwner = gameOwner;
137         hasStartingSnails[gameOwner] = true; //prevents buying starting snails
138         playerProdBoost[gameOwner] = 4; //base+tadpole+squirrel+spider
139     }
140     
141     // SeedMarket
142     // Sets eggs and acorns, funds the pot, starts the game
143 	
144 	// 10000:1 ratio for _eggs:msg.value gives near parity with starting snails
145 	// Recommended ratio = 5000:1
146 	// Acorns can be any amount, the higher the better as we deal with integers
147 	// Recommended value = 1000000
148 	// 1% of the acorns are left without an owner
149 	// This prevents an infinite acorn price rise,
150 	// In the case of a complete acorn dump followed by egg buys
151     
152     function SeedMarket(uint256 _eggs, uint256 _acorns) public payable {
153         require(msg.value > 0);
154         require(round == 0);
155         require(msg.sender == gameOwner);
156         
157         marketEggs = _eggs.mul(TIME_TO_HATCH_1SNAIL); //for readability
158         snailPot = msg.value.div(2); //50% to the snailpot
159         treePot = msg.value.sub(snailPot); //remainder to the treepot
160 		previousSnailPot = snailPot.mul(10); //encourage early acorn funding
161         totalAcorns = _acorns; 
162         playerAcorns[msg.sender] = _acorns.mul(99).div(100); 
163         spiderReq = SPIDER_BASE_REQ;
164         tadpoleReq = TADPOLE_BASE_REQ;
165 		squirrelReq = SQUIRREL_BASE_REQ;
166         round = 1;
167         gameStarted = true;
168     }
169     
170     // SellAcorns
171     // Takes a given amount of acorns, increases player ETH balance
172     
173     function SellAcorns(uint256 _acorns) public {
174         require(playerAcorns[msg.sender] > 0);
175         
176         playerAcorns[msg.sender] = playerAcorns[msg.sender].sub(_acorns);
177         uint256 _acornEth = ComputeAcornPrice().mul(_acorns);
178         totalAcorns = totalAcorns.sub(_acorns);
179         treePot = treePot.sub(_acornEth);
180         playerEarnings[msg.sender] = playerEarnings[msg.sender].add(_acornEth);
181         
182         emit SoldAcorn(msg.sender, _acorns, _acornEth);
183     }
184     
185     // BuyAcorns
186     // Takes a given amount of ETH, gives acorns in return
187 	
188 	// If current snailpot is under previous snailpot, 3 acorns for the price of 4
189 	// If current snailpot is equal or above, 1 acorn for the price of 
190     
191     function BuyAcorns() public payable {
192         require(msg.value > 0);
193         require(tx.origin == msg.sender);
194         require(gameStarted);
195         
196 		if (snailPot < previousSnailPot) {
197 			uint256 _acornBought = ((msg.value.div(ComputeAcornPrice())).mul(3)).div(4);
198 			AcornPotSplit(msg.value);
199 		} else {
200 			_acornBought = (msg.value.div(ComputeAcornPrice())).div(2);
201 			PotSplit(msg.value);
202 		}
203         totalAcorns = totalAcorns.add(_acornBought);
204         playerAcorns[msg.sender] = playerAcorns[msg.sender].add(_acornBought);
205         
206         emit BoughtAcorn(msg.sender, _acornBought, msg.value);
207     }
208     
209     // BecomeSnailmaster
210     // Gives out 20% of the snailpot and increments round for a snail sacrifice
211 	
212     // Increases Snailmaster requirement
213     // Resets Spider and Tadpole reqs to initial values
214     
215     function BecomeSnailmaster() public {
216         require(gameStarted);
217         require(hatcherySnail[msg.sender] >= snailmasterReq);
218         
219         hatcherySnail[msg.sender] = hatcherySnail[msg.sender].div(10);
220         
221         uint256 _snailReqIncrease = round.mul(SNAILMASTER_INCREASE);
222         snailmasterReq = snailmasterReq.add(_snailReqIncrease);
223         uint256 _startingSnailIncrease = round.mul(STARTING_SNAIL);
224         startingSnailAmount = startingSnailAmount.add(_startingSnailIncrease);
225         
226         spiderReq = SPIDER_BASE_REQ;
227         tadpoleReq = TADPOLE_BASE_REQ;
228         squirrelReq = SQUIRREL_BASE_REQ;
229         
230         previousSnailPot = snailPot;
231         uint256 _rewardSnailmaster = snailPot.div(5);
232         snailPot = snailPot.sub(_rewardSnailmaster);
233         round++;
234         playerEarnings[msg.sender] = playerEarnings[msg.sender].add(_rewardSnailmaster);
235         
236         emit BecameMaster(msg.sender, round, _rewardSnailmaster, snailPot);
237     }
238     
239     // WithdrawEarnings
240     // Withdraws all ETH earnings of a player to his wallet
241     
242     function WithdrawEarnings() public {
243         require(playerEarnings[msg.sender] > 0);
244         
245         uint _amount = playerEarnings[msg.sender];
246         playerEarnings[msg.sender] = 0;
247         msg.sender.transfer(_amount);
248         
249         emit WithdrewEarnings(msg.sender, _amount);
250     }
251     
252     // PotSplit
253 	// Splits value equally between the two pots
254 	
255     // Should be called each time ether is spent on the game
256     
257     function PotSplit(uint256 _msgValue) private {
258         uint256 _potBoost = _msgValue.div(2);
259         snailPot = snailPot.add(_potBoost);
260         treePot = treePot.add(_potBoost);
261     }
262 	
263 	// AcornPotSplit	
264     // Gives one fourth to the snailpot, three fourths to the treepot
265     
266 	// Variant of PotSplit with a privileged rate
267 	// Encourages pot funding with each new round
268 	
269     function AcornPotSplit(uint256 _msgValue) private {
270         uint256 _snailBoost = _msgValue.div(4);
271 		uint256 _treeBoost = _msgValue.sub(_snailBoost);
272         snailPot = snailPot.add(_snailBoost);
273         treePot = treePot.add(_treeBoost);
274     }
275     
276     // HatchEggs
277     // Hatches eggs into snails for a slight ETH cost
278 	
279     // If the player owns a hot potato, adjust prodBoost accordingly
280     
281     function HatchEggs() public payable {
282         require(gameStarted);
283         require(msg.value == HATCHING_COST);		
284         
285         PotSplit(msg.value);
286         uint256 eggsUsed = ComputeMyEggs();
287         uint256 newSnail = (eggsUsed.div(TIME_TO_HATCH_1SNAIL)).mul(playerProdBoost[msg.sender]);
288         claimedEggs[msg.sender]= 0;
289         lastHatch[msg.sender]= now;
290         hatcherySnail[msg.sender] = hatcherySnail[msg.sender].add(newSnail);
291         
292         emit Hatched(msg.sender, eggsUsed, newSnail);
293     }
294     
295     // SellEggs
296     // Sells current player eggs for ETH at a snail cost
297 	
298     // Ether is taken from the snailpot
299 	// Eggs sold are added to the market
300     
301     function SellEggs() public {
302         require(gameStarted);
303         
304         uint256 eggsSold = ComputeMyEggs();
305         uint256 eggValue = ComputeSell(eggsSold);
306         claimedEggs[msg.sender] = 0;
307         lastHatch[msg.sender] = now;
308         marketEggs = marketEggs.add(eggsSold);
309         snailPot = snailPot.sub(eggValue);
310         playerEarnings[msg.sender] = playerEarnings[msg.sender].add(eggValue);
311         
312         emit SoldEgg(msg.sender, eggsSold, eggValue);
313     }
314     
315     // BuyEggs
316     // Buy a calculated amount of eggs for a given amount of ETH
317 	
318 	// Eggs bought are removed from the market
319     
320     function BuyEggs() public payable {
321         require(gameStarted);
322         require(hasStartingSnails[msg.sender] == true);
323         require(msg.sender != gameOwner);
324         
325         uint256 eggsBought = ComputeBuy(msg.value);
326         PotSplit(msg.value);
327         marketEggs = marketEggs.sub(eggsBought);
328         claimedEggs[msg.sender] = claimedEggs[msg.sender].add(eggsBought);
329         
330         emit BoughtEgg(msg.sender, eggsBought, msg.value);
331     }
332     
333     // BuyStartingSnails
334     // Gives starting snails and sets playerProdBoost to 1
335     
336     function BuyStartingSnails() public payable {
337         require(gameStarted);
338         require(tx.origin == msg.sender);
339         require(hasStartingSnails[msg.sender] == false);
340         require(msg.value == STARTING_SNAIL_COST); 
341 
342         PotSplit(msg.value);
343 		hasStartingSnails[msg.sender] = true;
344         lastHatch[msg.sender] = now;
345 		playerProdBoost[msg.sender] = 1;
346         hatcherySnail[msg.sender] = startingSnailAmount;
347         
348         emit StartedSnailing(msg.sender, round);
349     }
350     
351     // BecomeSpiderQueen
352     // Increases playerProdBoost while held, obtained with a snail sacrifice
353 	
354 	// Hot potato item, requirement doubles with every buy
355     
356     function BecomeSpiderQueen() public {
357         require(gameStarted);
358         require(hatcherySnail[msg.sender] >= spiderReq);
359 
360         // Remove sacrificed snails, increase req
361         hatcherySnail[msg.sender] = hatcherySnail[msg.sender].sub(spiderReq);
362         spiderReq = spiderReq.mul(2);
363         
364         // Lower prodBoost of old spider owner
365         playerProdBoost[currentSpiderOwner] = playerProdBoost[currentSpiderOwner].sub(SPIDER_BOOST);
366         
367         // Give ownership to msg.sender, then increases his prodBoost
368         currentSpiderOwner = msg.sender;
369         playerProdBoost[currentSpiderOwner] = playerProdBoost[currentSpiderOwner].add(SPIDER_BOOST);
370         
371         emit BecameQueen(msg.sender, round, spiderReq);
372     }
373 	
374 	// BecomeSquirrelDuke
375 	// Increases playerProdBoost while held, obtained with an acorn sacrifice
376 
377     // Hot potato item, requirement doubles with every buy
378     
379     function BecomeSquirrelDuke() public {
380         require(gameStarted);
381         require(hasStartingSnails[msg.sender] == true);
382         require(playerAcorns[msg.sender] >= squirrelReq);
383         
384         // Remove sacrificed acorns, change totalAcorns in consequence, increase req
385         playerAcorns[msg.sender] = playerAcorns[msg.sender].sub(squirrelReq);
386 		totalAcorns = totalAcorns.sub(squirrelReq);
387         squirrelReq = squirrelReq.mul(2);
388         
389         // Lower prodBoost of old squirrel owner
390         playerProdBoost[currentSquirrelOwner] = playerProdBoost[currentSquirrelOwner].sub(SQUIRREL_BOOST);
391         
392         // Give ownership to msg.sender, then increases his prodBoost
393         currentSquirrelOwner = msg.sender;
394         playerProdBoost[currentSquirrelOwner] = playerProdBoost[currentSquirrelOwner].add(SQUIRREL_BOOST);
395         
396         emit BecameDuke(msg.sender, round, squirrelReq);
397     }
398     
399     // BecomeTadpolePrince
400     // Increases playerProdBoost while held, obtained with ETH
401 	
402     // Hot potato item, price increases by 20% with every buy
403     
404     function BecomeTadpolePrince() public payable {
405         require(gameStarted);
406         require(hasStartingSnails[msg.sender] == true);
407         require(msg.value >= tadpoleReq);
408         
409         // If player sent more ETH than needed, refund excess to playerEarnings
410         if (msg.value > tadpoleReq) {
411             uint _excess = msg.value.sub(tadpoleReq);
412             playerEarnings[msg.sender] = playerEarnings[msg.sender].add(_excess);
413         }  
414         
415         // Calculate +10% from previous price
416         // Give result to the potsplit
417         uint _extra = tadpoleReq.div(12); 
418         PotSplit(_extra);
419         
420         // Calculate 110% of previous price
421         // Give result to the previous owner
422         uint _previousFlip = tadpoleReq.mul(11).div(12);
423         playerEarnings[currentTadpoleOwner] = playerEarnings[currentTadpoleOwner].add(_previousFlip);
424         
425         // Increase ETH required for next buy by 20%
426         tadpoleReq = (tadpoleReq.mul(6)).div(5); 
427         
428         // Lower prodBoost of old tadpole owner
429         playerProdBoost[currentTadpoleOwner] = playerProdBoost[currentTadpoleOwner].sub(TADPOLE_BOOST);
430         
431         // Give ownership to msg.sender, then increase his prodBoost
432         currentTadpoleOwner = msg.sender;
433         playerProdBoost[currentTadpoleOwner] = playerProdBoost[currentTadpoleOwner].add(TADPOLE_BOOST);
434         
435         emit BecamePrince(msg.sender, round, tadpoleReq);
436     }
437     
438     // ComputeAcornPrice
439 	// Returns the current ether value of one acorn
440 	
441     // Acorn price = treePot / totalAcorns
442     
443     function ComputeAcornPrice() public view returns(uint256) {
444         return treePot.div(totalAcorns);
445     }
446     
447     // ComputeSell
448 	// Calculates ether value for a given amount of eggs being sold
449     
450 	// ETH = (eggs / (eggs + marketeggs)) * snailpot / 2
451 	// A sale can never give more than half of the snailpot
452     
453     function ComputeSell(uint256 eggspent) public view returns(uint256) {
454         uint256 _eggPool = eggspent.add(marketEggs);
455         uint256 _eggFactor = eggspent.mul(snailPot).div(_eggPool);
456         return _eggFactor.div(2);
457     }
458     
459     // ComputeBuy
460 	// Calculates number of eggs bought for a given amount of ether
461 	
462     // Eggs bought = ETH spent / (ETH spent + snailpot) * marketeggs
463     
464     function ComputeBuy(uint256 ethspent) public view returns(uint256) {
465         uint256 _ethPool = ethspent.add(snailPot);
466         uint256 _ethFactor = ethspent.mul(marketEggs).div(_ethPool);
467         return _ethFactor;
468     }
469     
470     // ComputeMyEggs
471     // Returns current player eggs
472     
473     function ComputeMyEggs() public view returns(uint256) {
474         return claimedEggs[msg.sender].add(ComputeEggsSinceLastHatch(msg.sender));
475     }
476     
477     // ComputeEggsSinceLastHatch
478     // Returns eggs produced since last hatch
479     
480     function ComputeEggsSinceLastHatch(address adr) public view returns(uint256) {
481         uint256 secondsPassed = min(TIME_TO_HATCH_1SNAIL , now.sub(lastHatch[adr]));
482         return secondsPassed.mul(hatcherySnail[adr]);
483     }
484     
485     // Helper function for CalculateEggsSinceLastHatch
486 	// If a < b, return a
487 	// Else, return b
488     
489     function min(uint256 a, uint256 b) private pure returns (uint256) {
490         return a < b ? a : b;
491     }
492 
493     // Gets
494     
495     function GetMySnail() public view returns(uint256) {
496         return hatcherySnail[msg.sender];
497     }
498 	
499 	function GetMyProd() public view returns(uint256) {
500 		return playerProdBoost[msg.sender];
501 	}
502     
503     function GetMyEgg() public view returns(uint256) {
504         return ComputeMyEggs().div(TIME_TO_HATCH_1SNAIL);
505     }
506     
507     function GetMyAcorn() public view returns(uint256) {
508         return playerAcorns[msg.sender];
509     }
510 	
511 	function GetMyEarning() public view returns(uint256) {
512 	    return playerEarnings[msg.sender];
513 	}
514 }
515 
516 library SafeMath {
517 
518   /**
519   * @dev Multiplies two numbers, throws on overflow.
520   */
521   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
522     if (a == 0) {
523       return 0;
524     }
525     uint256 c = a * b;
526     assert(c / a == b);
527     return c;
528   }
529 
530   /**
531   * @dev Integer division of two numbers, truncating the quotient.
532   */
533   function div(uint256 a, uint256 b) internal pure returns (uint256) {
534     // assert(b > 0); // Solidity automatically throws when dividing by 0
535     uint256 c = a / b;
536     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
537     return c;
538   }
539 
540   /**
541   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
542   */
543   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
544     assert(b <= a);
545     return a - b;
546   }
547 
548   /**
549   * @dev Adds two numbers, throws on overflow.
550   */
551   function add(uint256 a, uint256 b) internal pure returns (uint256) {
552     uint256 c = a + b;
553     assert(c >= a);
554     return c;
555   }
556 }