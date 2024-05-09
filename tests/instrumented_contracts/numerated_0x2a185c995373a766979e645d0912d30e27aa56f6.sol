1 pragma solidity ^0.4.24;
2 
3 /* SNAILFARM 3
4 
5 // SnailFarm 3 is an idlegame in which you buy or sell eggs,
6 // Which you can hatch into snails, who continuously produce more eggs
7 // The goal of the game is to reach 1 million snails.
8 // At that point, you win the round (and the ETH jackpot that comes with it)
9 
10 // SnailFarm 3 is the latest of a series of iterations over a few months.
11 // We will attempt to identify the key strengths of each of these iterations
12 // Focus on refining these features, in order to make for a fun, simple and
13 // Sustainable experience.
14 
15 // Shrimpfarm's killer feature: buying and selling eggs directly to the smart contract.
16 // Snailfarm 1: capturing and holding the Snailmaster position, a ruler collecting dividends.
17 // Snailfarm 2: juggling with hot potato boosts to increase hatch size.
18 
19 // SnailFarm 3 in a nutshell:
20 
21 // The game is played in rounds.
22 // Buy your starting snails once, play every round at your convenience.
23 // Player snails are reinitialised at the end of each round.
24 // Losing players receive "red eggs" as a percentage of their snails.
25 // Red eggs persist from round to round.
26 // Red eggs can be hatched as regular eggs for no ETH cost, or used to claim boosts.
27 
28 // Eggs can be bought and sold directly to the contract.
29 // No more than 20% of the egg supply can be bought at once.
30 // On sale, price is divided by 2.
31 
32 // Hatching eggs into snails come with a slight, fixed, ETH cost.
33 // The size of a hatch can be improved with special boosts.
34 // Each boost adds a fixed bonus of an extra full hatch.
35 // One boost means double hatch. Three boosts means quadruple hatch.
36 // Two types of boosts exist: hot potato, and personal.
37 
38 // Hot potato boosts: only one player can hold any of these at a time.
39 // The price of hot potato boosts rises with each player claim.
40 // The price of hot potato boosts is reinitialised as the round ends.
41 // Owners keep hot potato boosts between rounds, until another player claims them.
42 // SPIDERQUEEN- requires snails. Amount doubles with each claim.
43 // SQUIRRELDUKE- requires red eggs. Amount doubles with each claim.
44 // TADPOLEPRINCE- requires ETH. Amount raises by 20% with each claim,
45 // and the previous owner receives 110% of the ETH he spent.
46 
47 // Personal boosts: all players can hold them.
48 // Each personal boost has different rules.
49 
50 // SLUG- this boost persists between rounds.
51 // Slug requires a snail sacrifice of at least 100,000 snails.
52 // It will sacrifice ALL the snails the player own at the moment of the claim.
53 
54 // LETTUCE- this boost lasts for only one round.
55 // Lettuce requires red eggs.
56 // The price of lettuce starts high, and decreases with each lettuce buy.
57 // The price of lettuce is reinitialised and increases from round to round.
58 
59 // CARROT- this boost lasts for three rounds in a row.
60 // Carrot requires ETH.
61 // The price of carrot is fixed at 0.02 ETH.
62 
63 // The Snailmaster position as in SnailFarm 1 returns with a twist.
64 // While still a hot potato, becoming the Snailmaster now requires red eggs.
65 // That requirement doubles with each claim, and halves between each round.
66 // Being the Snailmaster persists between rounds.
67 // The Snailmaster gets a significant cut of every ETH transaction.
68 
69 // New mechanic: Red Harvest
70 // The red harvest lets players purchase red eggs for ETH.
71 // The red harvest works as a dutch auction, similar to cryptokitties.
72 // Starting price is equal to the current round pot.
73 // End price is a trivial amount of ETH.
74 // The auction lasts at most 4 hours.
75 // Price drops sharply at first, and slower near the end.
76 // The red harvest contains as many red eggs as the starting snail amount.
77 // When a player buys the red harvest, a new one is immediately put for sale.
78 
79 // Bankroll: players can fund the game and receive acorns in exchange.
80 // Acorns cannot be sold or actively used in any way.
81 // Acorn holders receive 10% of the ETH invested, proportional to their share.
82 // Acorns start at half-price to encourage early funding kickstarting the game.
83 // After that, acorn price slowly decreases from round to round.
84 // Potential dilution of early holdings encourages refunding the bankroll later on.
85 
86 // SnailFarm 3 is part of the SnailThrone ecosystem.
87 // A portion of the ETH spent in SnailFarm 3 is saved as throneDivs.
88 // SnailThrone holders are rewarded proportionally by throneDivs.
89 
90 // ETH of every SnailFarm 3 transaction is split as such:
91 // 50% to the snailPot
92 // 25% to the eggPot
93 // 10% to the acorn holders
94 // 10% to the throneDivs
95 // 5% to the SnailMaster
96 
97 */
98 
99 contract SnailFarm3 {
100     using SafeMath for uint;
101     
102     /* Event */
103     
104     event FundedTree (address indexed player, uint eth, uint acorns);
105     event ClaimedShare (address indexed player, uint eth, uint acorns);
106     event BecameMaster (address indexed player, uint indexed round);
107     event WithdrewBalance (address indexed player, uint eth);
108     event Hatched (address indexed player, uint eggs, uint snails, uint hatchery);
109     event SoldEgg (address indexed player, uint eggs, uint eth);
110     event BoughtEgg (address indexed player, uint eggs, uint eth, uint playereggs);
111     event StartedSnailing (address indexed player, uint indexed round);
112     event BecameQueen (address indexed player, uint indexed round, uint spiderreq, uint hatchery);
113     event BecameDuke (address indexed player, uint indexed round, uint squirrelreq, uint playerreds);
114     event BecamePrince (address indexed player, uint indexed round, uint tadpolereq);
115     event WonRound (address indexed roundwinner, uint indexed round, uint eth);
116     event BeganRound (uint indexed round);
117     event JoinedRound (address indexed player, uint indexed round, uint playerreds);
118     event GrabbedHarvest (address indexed player, uint indexed round, uint eth, uint playerreds);
119     event UsedRed (address indexed player, uint eggs, uint snails, uint hatchery);
120     event FoundSlug (address indexed player, uint indexed round, uint snails);
121     event FoundLettuce (address indexed player, uint indexed round, uint lettucereq, uint playerreds);
122     event FoundCarrot (address indexed player, uint indexed round);
123     event PaidThrone (address indexed player, uint eth);
124     event BoostedPot (address indexed player, uint eth);
125 
126     /* Constants */
127     
128     uint256 public constant FUND_TIMESTAMP       = 1544385600; // funding launch on 9th Dec 8pm GMT
129     uint256 public constant START_TIMESTAMP      = 1544904000; // game launch on 15th Dec 8pm GMT
130     uint256 public constant TIME_TO_HATCH_1SNAIL = 86400; //seconds in a day
131     uint256 public constant STARTING_SNAIL       = 300;
132     uint256 public constant FROGKING_REQ         = 1000000;
133     uint256 public constant ACORN_PRICE          = 0.001 ether;
134     uint256 public constant ACORN_MULT           = 10;
135     uint256 public constant STARTING_SNAIL_COST  = 0.004 ether;
136     uint256 public constant HATCHING_COST        = 0.0008 ether;
137     uint256 public constant SPIDER_BASE_REQ      = 80;
138     uint256 public constant SQUIRREL_BASE_REQ    = 2;
139     uint256 public constant TADPOLE_BASE_REQ     = 0.02 ether;
140     uint256 public constant SLUG_MIN_REQ         = 100000;
141     uint256 public constant LETTUCE_BASE_REQ     = 20;
142     uint256 public constant CARROT_COST          = 0.02 ether;
143     uint256 public constant HARVEST_COUNT        = 300;
144     uint256 public constant HARVEST_DURATION     = 14400; //4 hours in seconds
145     uint256 public constant HARVEST_DUR_ROOT     = 120; //saves computation
146     uint256 public constant HARVEST_MIN_COST     = 0.002 ether;
147     uint256 public constant SNAILMASTER_REQ      = 4096;
148     uint256 public constant ROUND_DOWNTIME       = 43200; //12 hours between rounds
149     address public constant SNAILTHRONE          = 0x261d650a521103428C6827a11fc0CBCe96D74DBc;
150 
151     /* Variables */
152     
153 	//False for downtime between rounds, true when round is ongoing
154     bool public gameActive             = false;
155 	
156 	//Used to ensure a proper game start
157     address public dev;
158 	
159 	//Current round
160     uint256 public round                = 0;
161 	
162 	//Current top snail holder
163 	address public currentLeader;
164 	
165 	//Owners of hot potatoes
166     address public currentSpiderOwner;
167     address public currentTadpoleOwner;
168 	address public currentSquirrelOwner;
169 	address public currentSnailmaster;
170 	
171 	//Current requirement for hot potatoes
172 	uint256 public spiderReq;
173     uint256 public tadpoleReq;
174 	uint256 public squirrelReq;
175 	
176 	//Current requirement for lettuce
177 	uint256 public lettuceReq;
178 	
179 	//Current requirement for Snailmaster
180 	uint256 public snailmasterReq       = SNAILMASTER_REQ;
181 	
182 	//Starting time for next round
183 	uint256 public nextRoundStart;
184 	
185 	//Starting price for Red Harvest auction
186 	uint256 public harvestStartCost;
187 	
188 	//Starting time for Red Harvest auction
189 	uint256 public harvestStartTime;
190 	
191 	//Current number of acorns over all holders
192 	uint256 public maxAcorn             = 0;
193 	
194 	//Current divs per acorn
195 	uint256 public divPerAcorn          = 0;
196 	
197 	//Current number of eggs for sale
198     uint256 public marketEgg            = 0;
199 		
200 	//Reserve pot and round jackpot
201     uint256 public snailPot             = 0;
202     uint256 public roundPot             = 0;
203     
204 	//Egg pot
205     uint256 public eggPot               = 0;
206     
207     //SnailThrone div pot
208     uint256 public thronePot            = 0;
209 
210     /* Mappings */
211     
212 	mapping (address => bool) public hasStartingSnail;
213 	mapping (address => bool) public hasSlug;
214 	mapping (address => bool) public hasLettuce;
215 	mapping (address => uint256) public gotCarrot;
216 	mapping (address => uint256) public playerRound;
217     mapping (address => uint256) public hatcherySnail;
218     mapping (address => uint256) public claimedEgg;
219     mapping (address => uint256) public lastHatch;
220     mapping (address => uint256) public redEgg;
221     mapping (address => uint256) public playerBalance;
222     mapping (address => uint256) public prodBoost;
223     mapping (address => uint256) public acorn;
224     mapping (address => uint256) public claimedShare;
225     
226     /* Functions */
227     
228     // Constructor
229     // Assigns all hot potatoes to dev for a proper game start
230     // (dev is banned from playing the game)
231     
232     constructor() public {
233         nextRoundStart = START_TIMESTAMP;
234         
235         //Assigns hot potatoes to dev originally
236         dev = msg.sender;
237         currentSnailmaster = msg.sender;
238         currentTadpoleOwner = msg.sender;
239         currentSquirrelOwner = msg.sender;
240         currentSpiderOwner = msg.sender;
241         currentLeader = msg.sender;
242         prodBoost[msg.sender] = 4; //base+tadpole+squirrel+spider
243     }
244     
245     // BeginRound
246     // Can be called by anyone to start a new round once downtime is over
247     // Sets appropriate values, and starts new round
248     
249     function BeginRound() public {
250         require(gameActive == false, "cannot start round while game is active");
251         require(now > nextRoundStart, "round downtime isn't over");
252         require(snailPot > 0, "cannot start round on empty pot");
253         
254         round = round.add(1);
255 		marketEgg = STARTING_SNAIL;
256         roundPot = snailPot.div(10);
257         spiderReq = SPIDER_BASE_REQ;
258         tadpoleReq = TADPOLE_BASE_REQ;
259         squirrelReq = SQUIRREL_BASE_REQ;
260         lettuceReq = LETTUCE_BASE_REQ.mul(round);
261         if(snailmasterReq > 2) {
262             snailmasterReq = snailmasterReq.div(2);
263         }
264         harvestStartTime = now;
265         harvestStartCost = roundPot;
266         
267         gameActive = true;
268         
269         emit BeganRound(round);
270     }
271     
272     // FundTree
273     // Buy a share of the bankroll
274     // Acorn price lowers from round to round
275     
276     function FundTree() public payable {
277         require(tx.origin == msg.sender, "no contracts allowed");
278         require(now > FUND_TIMESTAMP, "funding hasn't started yet");
279         
280         uint256 _acornsBought = ComputeAcornBuy(msg.value);
281         
282         //Previous divs are considered claimed
283         claimedShare[msg.sender] = claimedShare[msg.sender].add(_acornsBought.mul(divPerAcorn));
284         
285         //Add to maxAcorn
286         maxAcorn = maxAcorn.add(_acornsBought);
287         
288         //Split ETH to pot
289         PotSplit(msg.value);
290         
291         //Add player acorns
292         acorn[msg.sender] = acorn[msg.sender].add(_acornsBought);
293         
294         emit FundedTree(msg.sender, msg.value, _acornsBought);
295     }
296     
297     // ClaimAcornShare
298     // Sends unclaimed dividends to playerBalance
299     // Adjusts claimable dividends
300     
301     function ClaimAcornShare() public {
302         
303         uint256 _playerShare = ComputeMyShare();
304         
305         if(_playerShare > 0) {
306             
307             //Add new divs to claimed divs
308             claimedShare[msg.sender] = claimedShare[msg.sender].add(_playerShare);
309             
310             //Send divs to playerEarnings
311             playerBalance[msg.sender] = playerBalance[msg.sender].add(_playerShare);
312             
313             emit ClaimedShare(msg.sender, _playerShare, acorn[msg.sender]);
314         }
315     }
316     
317     // BecomeSnailmaster
318     // Hot potato with red eggs 
319     // Receives 5% of all incoming ETH
320     // Requirement halves every round, doubles on every claim
321 	
322     function BecomeSnailmaster() public {
323         require(gameActive, "game is paused");
324         require(playerRound[msg.sender] == round, "join new round to play");
325         require(redEgg[msg.sender] >= snailmasterReq, "not enough red eggs");
326         
327         redEgg[msg.sender] = redEgg[msg.sender].sub(snailmasterReq);
328         snailmasterReq = snailmasterReq.mul(2);
329         currentSnailmaster = msg.sender;
330         
331         emit BecameMaster(msg.sender, round);
332     }
333     
334     // WithdrawBalance
335     // Withdraws the ETH balance of a player to his wallet
336     
337     function WithdrawBalance() public {
338         require(playerBalance[msg.sender] > 0, "no ETH in player balance");
339         
340         uint _amount = playerBalance[msg.sender];
341         playerBalance[msg.sender] = 0;
342         msg.sender.transfer(_amount);
343         
344         emit WithdrewBalance(msg.sender, _amount);
345     }
346     
347     // PotSplit
348 	// Allocates the ETH of every transaction
349 	// 50% snailpot, 25% eggpot, 10% to acorn holders, 10% thronepot, 5% snailmaster
350     
351     function PotSplit(uint256 _msgValue) private {
352         
353         snailPot = snailPot.add(_msgValue.div(2));
354         eggPot = eggPot.add(_msgValue.div(4));
355         thronePot = thronePot.add(_msgValue.div(10));
356         
357         //Increase div per acorn proportionally
358         divPerAcorn = divPerAcorn.add(_msgValue.div(10).div(maxAcorn));
359         
360         //Snailmaster
361         playerBalance[currentSnailmaster] = playerBalance[currentSnailmaster].add(_msgValue.div(20));
362     }
363     
364     // JoinRound
365     // Gives red egg reward to player and lets them join the new round
366     
367     function JoinRound() public {
368         require(gameActive, "game is paused");
369         require(playerRound[msg.sender] != round, "player already in current round");
370         require(hasStartingSnail[msg.sender] == true, "buy starting snails first");
371         
372         uint256 _bonusRed = hatcherySnail[msg.sender].div(100);
373         hatcherySnail[msg.sender] = STARTING_SNAIL;
374         redEgg[msg.sender] = redEgg[msg.sender].add(_bonusRed);
375         
376         //Check if carrot is owned, remove 1 to count if so
377         if(gotCarrot[msg.sender] > 0) {
378             gotCarrot[msg.sender] = gotCarrot[msg.sender].sub(1);
379             
380             //Check if result puts us at 0, lower prodBoost if so
381             if(gotCarrot[msg.sender] == 0) {
382                 prodBoost[msg.sender] = prodBoost[msg.sender].sub(1);
383             }
384         }
385         
386         //Check if lettuce is owned, lower prodBoost if so
387         if(hasLettuce[msg.sender]) {
388             prodBoost[msg.sender] = prodBoost[msg.sender].sub(1);
389             hasLettuce[msg.sender] = false;
390         }
391         
392 		//Set lastHatch to now
393 		lastHatch[msg.sender] = now;
394         playerRound[msg.sender] = round;
395         
396         emit JoinedRound(msg.sender, round, redEgg[msg.sender]);
397     }
398     
399     // WinRound
400     // Called when a player meets the snail requirement
401     // Gives his earnings to winner
402     // Pauses the game for 12 hours
403     
404     function WinRound(address _msgSender) private {
405         
406         gameActive = false;
407         nextRoundStart = now.add(ROUND_DOWNTIME);
408         
409         hatcherySnail[_msgSender] = 0;
410         snailPot = snailPot.sub(roundPot);
411         playerBalance[_msgSender] = playerBalance[_msgSender].add(roundPot);
412         
413         emit WonRound(_msgSender, round, roundPot);
414     }
415     
416     // HatchEgg
417     // Hatches eggs into snails for a slight fixed ETH cost
418     // If the player owns boosts, adjust result accordingly
419     
420     function HatchEgg() public payable {
421         require(gameActive, "game is paused");
422         require(playerRound[msg.sender] == round, "join new round to play");
423         require(msg.value == HATCHING_COST, "wrong ETH cost");
424         
425         PotSplit(msg.value);
426         uint256 eggUsed = ComputeMyEgg(msg.sender);
427         uint256 newSnail = eggUsed.mul(prodBoost[msg.sender]);
428         claimedEgg[msg.sender] = 0;
429         lastHatch[msg.sender] = now;
430         hatcherySnail[msg.sender] = hatcherySnail[msg.sender].add(newSnail);
431         
432         if(hatcherySnail[msg.sender] > hatcherySnail[currentLeader]) {
433             currentLeader = msg.sender;
434         }
435         
436         if(hatcherySnail[msg.sender] >= FROGKING_REQ) {
437             WinRound(msg.sender);
438         }
439         
440         emit Hatched(msg.sender, eggUsed, newSnail, hatcherySnail[msg.sender]);
441     }
442     
443     // SellEgg
444     // Exchanges player eggs for ETH
445 	// Eggs sold are added to the market
446     
447     function SellEgg() public {
448         require(gameActive, "game is paused");
449         require(playerRound[msg.sender] == round, "join new round to play");
450         
451         uint256 eggSold = ComputeMyEgg(msg.sender);
452         uint256 eggValue = ComputeSell(eggSold);
453         claimedEgg[msg.sender] = 0;
454         lastHatch[msg.sender] = now;
455         marketEgg = marketEgg.add(eggSold);
456         eggPot = eggPot.sub(eggValue);
457         playerBalance[msg.sender] = playerBalance[msg.sender].add(eggValue);
458         
459         emit SoldEgg(msg.sender, eggSold, eggValue);
460     }
461     
462     // BuyEgg
463     // Buy a calculated amount of eggs for a given amount of ETH
464 	
465 	// Eggs bought are removed from the market
466     
467     function BuyEgg() public payable {
468         require(gameActive, "game is paused");
469         require(playerRound[msg.sender] == round, "join new round to play");
470         
471         uint256 _eggBought = ComputeBuy(msg.value);
472         
473         //Define final buy price
474         uint256 _ethSpent = msg.value;
475         
476         //Refund player if he overpays. maxBuy is a fourth of eggPot
477         //(a/a+b) implies 1/4 of b gets the maximum 20% supply
478         uint256 _maxBuy = eggPot.div(4);
479         if (msg.value > _maxBuy) {
480             uint _excess = msg.value.sub(_maxBuy);
481             playerBalance[msg.sender] = playerBalance[msg.sender].add(_excess);
482             _ethSpent = _maxBuy;
483         }  
484         
485         PotSplit(_ethSpent);
486         marketEgg = marketEgg.sub(_eggBought);
487         claimedEgg[msg.sender] = claimedEgg[msg.sender].add(_eggBought);
488         
489         emit BoughtEgg(msg.sender, _eggBought, _ethSpent, hatcherySnail[msg.sender]);
490     }
491     
492     // BuyStartingSnail
493     // Gives starting snails and sets prodBoost to 1
494     
495     function BuyStartingSnail() public payable {
496         require(gameActive, "game is paused");
497         require(tx.origin == msg.sender, "no contracts allowed");
498         require(hasStartingSnail[msg.sender] == false, "player already active");
499         require(msg.value == STARTING_SNAIL_COST, "wrongETH cost");
500         require(msg.sender != dev, "shoo shoo, developer");
501 
502         PotSplit(msg.value);
503 		hasStartingSnail[msg.sender] = true;
504         lastHatch[msg.sender] = now;
505 		prodBoost[msg.sender] = 1;
506 		playerRound[msg.sender] = round;
507         hatcherySnail[msg.sender] = STARTING_SNAIL;
508         
509         emit StartedSnailing(msg.sender, round);
510     }
511     
512     // GrabRedHarvest
513     // Gets red eggs for ETH
514     // Works as a dutch auction
515     
516     function GrabRedHarvest() public payable {
517         require(gameActive, "game is paused");
518         require(playerRound[msg.sender] == round, "join new round to play");
519         
520         //Check current harvest cost
521         uint256 _harvestCost = ComputeHarvest();
522         require(msg.value >= _harvestCost);
523         
524         //If player sent more ETH than needed, refund excess to playerBalance
525         if (msg.value > _harvestCost) {
526             uint _excess = msg.value.sub(_harvestCost);
527             playerBalance[msg.sender] = playerBalance[msg.sender].add(_excess);
528         }
529         
530         PotSplit(_harvestCost);
531         
532         //Reset the harvest
533         harvestStartCost = roundPot;
534         harvestStartTime = now;
535         
536         //Give red eggs to player
537         redEgg[msg.sender] = redEgg[msg.sender].add(HARVEST_COUNT);
538         
539         emit GrabbedHarvest(msg.sender, round, msg.value, redEgg[msg.sender]);
540     }
541     
542     // UseRedEgg
543     // Hatches a defined number of red eggs into snails
544     // No ETH cost
545     
546     function UseRedEgg(uint256 _redAmount) public {
547         require(gameActive, "game is paused");
548         require(playerRound[msg.sender] == round, "join new round to play");
549         require(redEgg[msg.sender] >= _redAmount, "not enough red eggs");
550         
551         redEgg[msg.sender] = redEgg[msg.sender].sub(_redAmount);
552         uint256 _newSnail = _redAmount.mul(prodBoost[msg.sender]);
553         hatcherySnail[msg.sender] = hatcherySnail[msg.sender].add(_newSnail);
554         
555         if(hatcherySnail[msg.sender] > hatcherySnail[currentLeader]) {
556             currentLeader = msg.sender;
557         }
558         
559         if(hatcherySnail[msg.sender] >= FROGKING_REQ) {
560             WinRound(msg.sender);
561         }
562         
563         emit UsedRed(msg.sender, _redAmount, _newSnail, hatcherySnail[msg.sender]);
564     }
565     
566     // FindSlug
567     // Sacrifices all the snails the player owns (minimum 100k)
568     // Raises his prodBoost by 1 permanently
569     
570     function FindSlug() public {
571         require(gameActive, "game is paused");
572         require(playerRound[msg.sender] == round, "join new round to play");
573         require(hasSlug[msg.sender] == false, "already owns slug");
574         require(hatcherySnail[msg.sender] >= SLUG_MIN_REQ, "not enough snails");
575         
576 		uint256 _sacrifice = hatcherySnail[msg.sender];
577         hatcherySnail[msg.sender] = 0;
578         hasSlug[msg.sender] = true;
579         prodBoost[msg.sender] = prodBoost[msg.sender].add(1);
580 
581         emit FoundSlug(msg.sender, round, _sacrifice);
582     }
583     
584     // FindLettuce
585     // Exchanges red eggs for lettuce (+1 prodBoost for the round)
586     // Lowers next lettuce requirement
587     
588     function FindLettuce() public {
589         require(gameActive, "game is paused");
590         require(playerRound[msg.sender] == round, "join new round to play");
591         require(hasLettuce[msg.sender] == false, "already owns lettuce");
592         require(redEgg[msg.sender] >= lettuceReq, "not enough red eggs");
593         
594         uint256 _eventLettuceReq = lettuceReq;
595         redEgg[msg.sender] = redEgg[msg.sender].sub(lettuceReq);
596         lettuceReq = lettuceReq.sub(LETTUCE_BASE_REQ);
597         if(lettuceReq < LETTUCE_BASE_REQ) {
598             lettuceReq = LETTUCE_BASE_REQ;
599         }
600         
601         hasLettuce[msg.sender] = true;
602         prodBoost[msg.sender] = prodBoost[msg.sender].add(1);
603 
604         emit FoundLettuce(msg.sender, round, _eventLettuceReq, redEgg[msg.sender]);
605     }
606     
607     // FindCarrot
608     // Trades ETH for carrot (+1 prodBoost for 3 rounds)
609     
610     function FindCarrot() public payable {
611         require(gameActive, "game is paused");
612         require(playerRound[msg.sender] == round, "join new round to play");
613         require(gotCarrot[msg.sender] == 0, "already owns carrot");
614         require(msg.value == CARROT_COST);
615         
616         PotSplit(msg.value);
617         gotCarrot[msg.sender] = 3;
618         prodBoost[msg.sender] = prodBoost[msg.sender].add(1);
619 
620         emit FoundCarrot(msg.sender, round);
621     }
622     
623     // PayThrone
624     // Sends thronePot to SnailThrone
625     
626     function PayThrone() public {
627         uint256 _payThrone = thronePot;
628         thronePot = 0;
629         if (!SNAILTHRONE.call.value(_payThrone)()){
630             revert();
631         }
632         
633         emit PaidThrone(msg.sender, _payThrone);
634     }
635     
636     // BecomeSpiderQueen
637     // Increases playerProdBoost while held, obtained with a snail sacrifice
638 	// Hot potato item, requirement doubles with every buy
639     
640     function BecomeSpiderQueen() public {
641         require(gameActive, "game is paused");
642         require(playerRound[msg.sender] == round, "join new round to play");
643         require(hatcherySnail[msg.sender] >= spiderReq, "not enough snails");
644 
645         // Remove sacrificed snails, increase req
646         hatcherySnail[msg.sender] = hatcherySnail[msg.sender].sub(spiderReq);
647         spiderReq = spiderReq.mul(2);
648         
649         // Lower prodBoost of old spider owner
650         prodBoost[currentSpiderOwner] = prodBoost[currentSpiderOwner].sub(1);
651         
652         // Give ownership to msg.sender, then increases his prodBoost
653         currentSpiderOwner = msg.sender;
654         prodBoost[currentSpiderOwner] = prodBoost[currentSpiderOwner].add(1);
655         
656         emit BecameQueen(msg.sender, round, spiderReq, hatcherySnail[msg.sender]);
657     }
658 	
659 	// BecomeSquirrelDuke
660 	// Increases playerProdBoost while held, obtained with a red egg sacrifice
661     // Hot potato item, requirement doubles with every buy
662     
663     function BecomeSquirrelDuke() public {
664         require(gameActive, "game is paused");
665         require(playerRound[msg.sender] == round, "join new round to play");
666         require(redEgg[msg.sender] >= squirrelReq, "not enough red eggs");
667         
668         // Remove red eggs spent, increase req
669         redEgg[msg.sender] = redEgg[msg.sender].sub(squirrelReq);
670         squirrelReq = squirrelReq.mul(2);
671         
672         // Lower prodBoost of old squirrel owner
673         prodBoost[currentSquirrelOwner] = prodBoost[currentSquirrelOwner].sub(1);
674         
675         // Give ownership to msg.sender, then increases his prodBoost
676         currentSquirrelOwner = msg.sender;
677         prodBoost[currentSquirrelOwner] = prodBoost[currentSquirrelOwner].add(1);
678         
679         emit BecameDuke(msg.sender, round, squirrelReq, redEgg[msg.sender]);
680     }
681     
682     // BecomeTadpolePrince
683     // Increases playerProdBoost while held, obtained with ETH
684 	
685     // Hot potato item, price increases by 20% with every buy
686     
687     function BecomeTadpolePrince() public payable {
688         require(gameActive, "game is paused");
689         require(playerRound[msg.sender] == round, "join new round to play");
690         require(msg.value >= tadpoleReq, "not enough ETH");
691         
692         // If player sent more ETH than needed, refund excess to playerBalance
693         if (msg.value > tadpoleReq) {
694             uint _excess = msg.value.sub(tadpoleReq);
695             playerBalance[msg.sender] = playerBalance[msg.sender].add(_excess);
696         }  
697         
698         // Calculate +10% from previous price
699         // Give result to the potsplit
700         uint _extra = tadpoleReq.div(12); 
701         PotSplit(_extra);
702         
703         // Calculate 110% of previous price
704         // Give result to the previous owner
705         uint _previousFlip = tadpoleReq.mul(11).div(12);
706         playerBalance[currentTadpoleOwner] = playerBalance[currentTadpoleOwner].add(_previousFlip);
707         
708         // Increase ETH required for next buy by 20%
709         tadpoleReq = (tadpoleReq.mul(6)).div(5); 
710         
711         // Lower prodBoost of old tadpole owner
712         prodBoost[currentTadpoleOwner] = prodBoost[currentTadpoleOwner].sub(1);
713         
714         // Give ownership to msg.sender, then increase his prodBoost
715         currentTadpoleOwner = msg.sender;
716         prodBoost[currentTadpoleOwner] = prodBoost[currentTadpoleOwner].add(1);
717         
718         emit BecamePrince(msg.sender, round, tadpoleReq);
719     }
720     
721     // fallback function
722     // Feeds the snailPot
723     
724     function() public payable {
725         snailPot = snailPot.add(msg.value);
726         
727         emit BoostedPot(msg.sender, msg.value);
728     }
729     
730     // ComputeAcornCost
731     // Returns acorn cost at the current time
732     // Before the game starts, acorns are at half cost
733     // After the game is started, cost is multiplied by 10/(10+round)
734     
735     function ComputeAcornCost() public view returns(uint256) {
736         uint256 _acornCost;
737         if(round != 0) {
738             _acornCost = ACORN_PRICE.mul(ACORN_MULT).div(ACORN_MULT.add(round));
739         } else {
740             _acornCost = ACORN_PRICE.div(2);
741         }
742         return _acornCost;
743     }
744     
745     // ComputeAcornBuy
746     // Returns acorn amount for a given amount of ETH
747     
748     function ComputeAcornBuy(uint256 _ether) public view returns(uint256) {
749         uint256 _costPerAcorn = ComputeAcornCost();
750         return _ether.div(_costPerAcorn);
751     }
752     
753     // ComputeMyShare
754     // Returns unclaimed share for the player
755     
756     function ComputeMyShare() public view returns(uint256) {
757         //Calculate share of player
758         uint256 _playerShare = divPerAcorn.mul(acorn[msg.sender]);
759 		
760         //Subtract already claimed divs
761     	_playerShare = _playerShare.sub(claimedShare[msg.sender]);
762         return _playerShare;
763     }
764     
765     // ComputeHarvest
766     // Calculates current ETH cost to claim red harvest
767     // Dutch auction
768     
769     function ComputeHarvest() public view returns(uint256) {
770 
771         //Time spent since auction start
772         uint256 _timeLapsed = now.sub(harvestStartTime);
773         
774         //Make sure we're not beyond the end point
775         if(_timeLapsed > HARVEST_DURATION) {
776             _timeLapsed = HARVEST_DURATION;
777         }
778         
779         //Get the square root of timeLapsed
780         _timeLapsed = ComputeSquare(_timeLapsed);
781         
782         //Price differential between start and end of auction
783         uint256 _priceChange = harvestStartCost.sub(HARVEST_MIN_COST);
784         
785         //Multiply priceChange by timeLapsed root then divide by end root
786         uint256 _harvestFactor = _priceChange.mul(_timeLapsed).div(HARVEST_DUR_ROOT);
787         
788         //Subtract result to starting price to get current price
789         return harvestStartCost.sub(_harvestFactor);
790     }
791     
792     // ComputeSquare
793     // Approximate square root
794     
795     function ComputeSquare(uint256 base) public pure returns (uint256 squareRoot) {
796         uint256 z = (base + 1) / 2;
797         squareRoot = base;
798         while (z < squareRoot) {
799             squareRoot = z;
800             z = (base / z + z) / 2;
801         }
802     }
803     
804     // ComputeSell
805 	// Calculates ether value for a given amount of eggs being sold
806 	// ETH = (eggs / (eggs + marketeggs)) * eggpot / 2
807 	// A sale can never give more than half of the eggpot
808     
809     function ComputeSell(uint256 eggspent) public view returns(uint256) {
810         uint256 _eggPool = eggspent.add(marketEgg);
811         uint256 _eggFactor = eggspent.mul(eggPot).div(_eggPool);
812         return _eggFactor.div(2);
813     }
814     
815     // ComputeBuy
816 	// Calculates number of eggs bought for a given amount of ether
817     // Eggs bought = ETH spent / (ETH spent + eggpot) * marketegg
818     // No more than 20% of the supply can be bought at once
819     
820     function ComputeBuy(uint256 ethspent) public view returns(uint256) {
821         uint256 _ethPool = ethspent.add(eggPot);
822         uint256 _ethFactor = ethspent.mul(marketEgg).div(_ethPool);
823         uint256 _maxBuy = marketEgg.div(5);
824         if(_ethFactor > _maxBuy) {
825             _ethFactor = _maxBuy;
826         }
827         return _ethFactor;
828     }
829     
830     // ComputeMyEgg
831     // Returns eggs produced since last hatch or sacrifice
832 	// Egg amount can never be above current snail count
833     
834     function ComputeMyEgg(address adr) public view returns(uint256) {
835         uint256 _eggs = now.sub(lastHatch[adr]);
836         _eggs = _eggs.mul(hatcherySnail[adr]).div(TIME_TO_HATCH_1SNAIL);
837         if (_eggs > hatcherySnail[adr]) {
838             _eggs = hatcherySnail[adr];
839         }
840         _eggs = _eggs.add(claimedEgg[adr]);
841         return _eggs;
842     }
843 
844     // Gets
845     
846     function GetSnail(address adr) public view returns(uint256) {
847         return hatcherySnail[adr];
848     }
849     
850     function GetAcorn(address adr) public view returns(uint256) {
851         return acorn[adr];
852     }
853 	
854 	function GetProd(address adr) public view returns(uint256) {
855 		return prodBoost[adr];
856 	}
857     
858     function GetMyEgg() public view returns(uint256) {
859         return ComputeMyEgg(msg.sender);
860     }
861 	
862 	function GetMyBalance() public view returns(uint256) {
863 	    return playerBalance[msg.sender];
864 	}
865 	
866 	function GetRed(address adr) public view returns(uint256) {
867 	    return redEgg[adr];
868 	}
869 	
870 	function GetLettuce(address adr) public view returns(bool) {
871 	    return hasLettuce[adr];
872 	}
873 	
874 	function GetCarrot(address adr) public view returns(uint256) {
875 	    return gotCarrot[adr];
876 	}
877 	
878 	function GetSlug(address adr) public view returns(bool) {
879 	    return hasSlug[adr];
880 	}
881 	
882 	function GetMyRound() public view returns(uint256) {
883 	    return playerRound[msg.sender];
884 	}
885 }
886 
887 library SafeMath {
888 
889   /**
890   * @dev Multiplies two numbers, throws on overflow.
891   */
892   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
893     if (a == 0) {
894       return 0;
895     }
896     uint256 c = a * b;
897     assert(c / a == b);
898     return c;
899   }
900 
901   /**
902   * @dev Integer division of two numbers, truncating the quotient.
903   */
904   function div(uint256 a, uint256 b) internal pure returns (uint256) {
905     // assert(b > 0); // Solidity automatically throws when dividing by 0
906     uint256 c = a / b;
907     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
908     return c;
909   }
910 
911   /**
912   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
913   */
914   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
915     assert(b <= a);
916     return a - b;
917   }
918 
919   /**
920   * @dev Adds two numbers, throws on overflow.
921   */
922   function add(uint256 a, uint256 b) internal pure returns (uint256) {
923     uint256 c = a + b;
924     assert(c >= a);
925     return c;
926   }
927 }