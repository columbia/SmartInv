1 pragma solidity ^0.5.9;
2 
3 contract CryptoKingdoms
4 {
5     uint public constant gameNumber = 8;
6     
7     address public constant previousGameAddress = 0x2c8dc01FB73c7079cC8A9e7a339C172Bbf2d3EbC;
8     
9     address public nextGameAddress;
10     
11     enum Race
12     {
13         None,
14         Humane
15     }
16 
17     struct Kingdom
18     {
19         Race race;
20 
21         string name;
22 
23         uint actions;
24         
25         uint gold;
26         
27         uint soldiers;
28         uint spies;
29         uint wizards;
30         uint dragons;
31         
32         uint hovels;
33         uint miningCamps;
34         uint banks;
35         uint barracks;
36         uint castles;
37     }
38     
39     Kingdom public winner;
40     uint winnerPrize;
41     
42     uint constant defaultJoinDuration = 26 days;
43     uint constant defaultGameDuration = 33 days;
44     uint constant defaultTurnTime = 11 hours;
45     
46     uint constant joinGameCost = 0.0225 ether;
47     
48     uint constant soldierCost = 3;
49     uint constant spyCost = 100;
50     uint constant wizardCost = 250;
51     uint constant dragonCost = 3000;
52     uint constant hovelCost = 100;
53     uint constant miningCampCost = 1000;
54     uint constant bankCost = 1500;
55     uint constant barracksCost = 300;
56     uint constant castleCost = 15000;
57     
58     uint constant soldierAttack = 1;
59     uint constant spyAttack = 5;
60     uint constant wizardAttack = 100;
61     uint constant dragonAttack = 500;
62     
63     uint constant barracksDefence = 5;
64     uint constant castleDefence = 1000;
65     
66     uint constant wizardGoldPerTurn = 20;
67     uint constant hovelGoldPerTurn = 5;
68     uint constant miningCampGoldPerTurn = 150;
69 
70     uint constant bankedGoldPerUnitGoldPerTurn = 50;
71     uint constant bankLimit = 15;
72     
73     uint constant barracksSoldiersPerTurn = 25;
74     uint constant castleSoldiersPerTurn = 50;
75     
76     uint constant hovelCapacity = 3;
77     
78     uint constant espionageCost = 25;
79     
80     address payable[] private players;
81     address payable private host;
82     
83     mapping (address => Kingdom) private kingdoms;
84     
85     uint gameTurnTime = defaultTurnTime;
86     uint gameDuration = defaultGameDuration;
87     uint gameJoinDuration = defaultJoinDuration;
88     uint gameTotalTurns;
89     uint gameStartTime;
90     uint gameEndTime;
91     
92     uint hostFees;
93     
94     uint currentTurnNumber;
95     uint leaderPlayerIndex;
96     uint espionageInformationType;
97     
98     event turnCompleted();
99     event newPlayerJoined(string playerName);
100     event attackCompleted(uint goldExchanged, uint soldierDeaths, uint wizardDeaths, uint dragonDeaths);
101     event spyReported(string name, uint detail, uint info, uint moreInfo);
102     event sabotaged(uint sabotagedGold, uint sabotagedDragons, uint sabotagedHovels, uint sabotagedMiningCamps, uint sabotagedBanks, uint dragonsKilled);
103     event hostMessage(string message);
104     event gameEnded();
105     
106     constructor (uint joinTimeSeconds, uint gameTimeSeconds, uint turnTimeSeconds) public
107     {
108         if (joinTimeSeconds > 0)
109         {
110             gameJoinDuration = joinTimeSeconds;
111         }
112         
113         if (gameTimeSeconds > 0)
114         {
115             gameDuration = gameTimeSeconds;
116         }
117         
118         if (turnTimeSeconds > 0)
119         {
120             gameTurnTime = turnTimeSeconds;
121         }
122         
123         gameStartTime = block.timestamp + gameJoinDuration;
124         gameEndTime = gameStartTime + gameDuration;
125         gameTotalTurns = (gameDuration / gameTurnTime) + 1; // +1 for the last turn
126         host = msg.sender;
127     }
128     
129     function gameStats() public view returns (uint version,
130                                               uint numberPlayers,
131                                               uint totalGold,
132                                               uint totalPrizePool,
133                                               uint gameStartTimeSeconds,
134                                               uint gameDurationSeconds,
135                                               uint gameTurns,
136                                               uint gameTurnTimeSeconds,
137                                               uint gameCurrentTurn,
138                                               uint gameLeaderIndex)
139     {
140         for (uint playerIndex = 0; playerIndex < players.length; playerIndex++)
141         {
142             address playerAddress = players[playerIndex];
143             Kingdom storage kingdom = kingdoms[playerAddress];
144             totalGold += kingdom.gold;
145         }
146         return (gameNumber, players.length, totalGold, winnerPrize,
147                 gameStartTime, gameDuration,
148                 gameTotalTurns, gameTurnTime,
149                 currentTurnNumber,
150                 leaderPlayerIndex);
151     }
152     
153     
154     //  === Host Functions ===
155     
156     modifier onlyHost()
157     {
158         require(msg.sender == host);
159         _;
160     }
161     
162     modifier onlyIfGameStarted()
163     {
164         require(block.timestamp > gameStartTime);
165         _;
166     }
167     
168     modifier onlyIfTurnTime()
169     {
170         if (block.timestamp < gameEndTime)
171         {
172             uint time = block.timestamp;
173             uint turnsRemaining = ((gameEndTime - time) / gameTurnTime) + 1; // For game start turn.
174             uint blocktimeTurnNumber = gameTotalTurns - turnsRemaining;
175             require(currentTurnNumber < blocktimeTurnNumber);
176         }
177         else
178         {
179             require(currentTurnNumber < gameTotalTurns);
180         }
181         _;
182     }
183     
184     // Called by the game host (at most) every gameTurnTime to update the game state and to allow players to progress.
185     function turn() public onlyIfGameStarted() onlyIfTurnTime()
186     {
187         uint turnsToUpdate = 0;
188         if (block.timestamp < gameEndTime)
189         {
190             uint turnsRemaining = ((gameEndTime - block.timestamp) / gameTurnTime) + 1;
191             uint blocktimeTurnNumber = gameTotalTurns - turnsRemaining;
192             turnsToUpdate = blocktimeTurnNumber - currentTurnNumber;
193         }
194         else
195         {
196             turnsToUpdate = gameTotalTurns - currentTurnNumber;
197         }
198         
199         leaderPlayerIndex = 0;
200         uint maxPlayerRank = 0;
201         
202         for (uint playerIndex = 0; playerIndex < players.length; playerIndex++)
203         {
204             address player = players[playerIndex];
205             Kingdom storage kingdom = kingdoms[player];
206             kingdom.actions += turnsToUpdate;
207             kingdom.gold += (kingdom.hovels * hovelGoldPerTurn
208                            + kingdom.miningCamps * miningCampGoldPerTurn
209                            + kingdom.wizards * wizardGoldPerTurn
210                            + (kingdom.banks * (kingdom.gold / bankedGoldPerUnitGoldPerTurn))) * turnsToUpdate;
211             kingdom.soldiers += (kingdom.barracks * barracksSoldiersPerTurn + kingdom.castles * castleSoldiersPerTurn) * turnsToUpdate;
212             
213             uint estimatedPlayerRank = kingdom.gold * ((currentTurnNumber * 100) / (gameTotalTurns * 100))
214                                    + ((kingdom.soldiers * soldierCost) + (kingdom.wizards * wizardCost) + (kingdom.dragons * dragonCost)
215                                     + (kingdom.hovels * hovelCost) + (kingdom.miningCamps * miningCampCost) + (kingdom.banks * bankCost)
216                                     + (kingdom.barracks * barracksCost)) * (gameTotalTurns / 4);
217             if (estimatedPlayerRank > maxPlayerRank)
218             {
219                 maxPlayerRank = estimatedPlayerRank;
220                 leaderPlayerIndex = playerIndex;
221             }
222         }
223         
224         currentTurnNumber += turnsToUpdate;
225         
226         if (currentTurnNumber == gameTotalTurns)
227         {
228             endGame();
229         }
230         
231         emit turnCompleted();
232     }
233     
234     function endGame() private
235     {
236         uint largestGoldAmount = 0;
237         address payable winnerAddress;
238         for (uint playerIndex = 0; playerIndex < players.length; playerIndex++)
239         {
240             address payable playerAddress = players[playerIndex];
241             Kingdom storage kingdom = kingdoms[playerAddress];
242             if (kingdom.gold > largestGoldAmount)
243             {
244                 largestGoldAmount = kingdom.gold;
245                 winnerAddress = playerAddress;
246             }
247         }
248         
249         winner = kingdoms[winnerAddress];
250         winnerAddress.transfer(winnerPrize);
251         host.transfer(hostFees);
252     }
253     
254     function setNextGame(address gameAddress) public onlyHost()
255     {
256         nextGameAddress = gameAddress;
257     }
258     
259     // The game host reserves the right to modify abusive kingdom names.
260     function changeKingdomName(uint kingdomIndex, string memory newName) public onlyHost()
261     {
262         address payable playerAddress = players[kingdomIndex];
263         Kingdom storage kingdom = kingdoms[playerAddress];
264         kingdom.name = newName;
265     }
266     
267     function message(string memory s) public onlyHost()
268     {
269         emit hostMessage(s);
270     }
271     
272     
273     //  === Player Functions ===
274 
275     modifier onlyIfNewPlayer()
276     {
277         // No existing kingdom for sender address.
278         require(kingdoms[msg.sender].race == Race.None);
279         require(currentTurnNumber < gameTotalTurns);
280         require(msg.value == joinGameCost);
281         _;
282     }
283     
284     modifier onlyIfTurnsRemaining()
285     {
286         require(currentTurnNumber < gameTotalTurns);
287         _;
288     }
289     
290     modifier onlyIfValidPlayerIndex(uint playerIndex)
291     {
292         require(playerIndex < players.length);
293         _;
294     }
295     
296     modifier onlyIfOtherPlayerIndex(uint otherPlayerIndex)
297     {
298         address otherPlayer = players[otherPlayerIndex];
299         require(msg.sender != otherPlayer);
300         _;
301     }
302     
303     modifier onlyIfActions()
304     {
305         Kingdom storage kingdom = kingdoms[msg.sender];
306         require(kingdom.actions > 0);
307         _;
308     }
309     
310     modifier onlyIfGold(uint goldCost)
311     {
312         Kingdom storage kingdom = kingdoms[msg.sender];
313         require(kingdom.gold >= goldCost);
314         _;
315     }
316     
317     modifier onlyIfHovels(uint amount)
318     {
319         Kingdom storage kingdom = kingdoms[msg.sender];
320         require(kingdom.hovels >= ((kingdom.spies + kingdom.wizards + amount) / hovelCapacity));
321         _;
322     }
323 
324     modifier onlyIfUnderBankLimit(uint amount)
325     {
326         Kingdom storage kingdom = kingdoms[msg.sender];
327         require((kingdom.banks + amount) <= bankLimit);
328         _;
329     }
330 
331     modifier onlyIfSpies()
332     {
333         Kingdom storage kingdom = kingdoms[msg.sender];
334         require(kingdom.spies > 0);
335         _;
336     }
337     
338     modifier onlyIfWizards(uint number)
339     {
340         Kingdom storage kingdom = kingdoms[msg.sender];
341         require(kingdom.wizards > 0);
342         _;
343     }
344     
345     modifier onlyIfDragons()
346     {
347         Kingdom storage kingdom = kingdoms[msg.sender];
348         require(kingdom.dragons > 0);
349         _;
350     }
351     
352     function joinGame(string memory playerName) public payable onlyIfNewPlayer() onlyIfTurnsRemaining()
353     {
354         winnerPrize += (msg.value * 7) / 10;
355         hostFees += (msg.value * 3) / 10;
356         
357         kingdoms[msg.sender] = Kingdom({
358             race: Race.Humane,
359             name: playerName,
360             actions: currentTurnNumber,
361             gold: 1320 + (currentTurnNumber * hovelGoldPerTurn * 5),
362             soldiers: 25,
363             spies: 0,
364             wizards: 0,
365             dragons: 0,
366             hovels: 3,
367             miningCamps: 1,
368             banks: 0,
369             barracks: 0,
370             castles: 0
371         });
372         
373         players.push(msg.sender);
374         
375         emit newPlayerJoined(playerName);
376     }
377 
378     function playerStats() public view
379              returns (Race race, string memory kingdomName, uint actions, uint gold,
380                       uint soldiers, uint spies, uint wizards, uint dragons,
381                       uint hovels, uint miningCamps, uint banks, uint barracks, uint castles)
382     {
383         Kingdom storage kingdom = kingdoms[msg.sender];
384         return (kingdom.race, kingdom.name, kingdom.actions, kingdom.gold,
385                 kingdom.soldiers, kingdom.spies, kingdom.wizards, kingdom.dragons,
386                 kingdom.hovels, kingdom.miningCamps, kingdom.banks, kingdom.barracks, kingdom.castles);
387     }
388     
389     function playerAtIndex(uint playerIndex) public view
390              onlyIfValidPlayerIndex(playerIndex)
391              returns (string memory playerName)
392     {
393         address playerAddress = players[playerIndex];
394         Kingdom storage kingdom = kingdoms[playerAddress];
395         return kingdom.name;
396     }
397     
398     // === Player Actions ===
399 
400     function recruitSoldiers(uint amount) public
401              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfGold(amount * soldierCost)
402     {
403         Kingdom storage kingdom = kingdoms[msg.sender];
404         kingdom.gold -= amount * soldierCost;
405         kingdom.soldiers += amount;
406         kingdom.actions -= 1;
407     }
408 
409     function recruitSpies(uint amount) public
410              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfGold(amount * spyCost) onlyIfHovels(amount)
411     {
412         Kingdom storage kingdom = kingdoms[msg.sender];
413         kingdom.gold -= amount * spyCost;
414         kingdom.spies += amount;
415     }
416     
417     function summonWizards(uint amount) public
418              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfGold(amount * wizardCost) onlyIfHovels(amount)
419     {
420         Kingdom storage kingdom = kingdoms[msg.sender];
421         kingdom.gold -= amount * wizardCost;
422         kingdom.wizards += amount;
423         kingdom.actions -= 1;
424     }
425     
426     function trainDragons(uint amount) public
427              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfGold(amount * dragonCost)
428     {
429         Kingdom storage kingdom = kingdoms[msg.sender];
430         kingdom.gold -= amount * dragonCost;
431         kingdom.dragons += amount;
432         kingdom.actions -= 1;
433     }
434 
435     function buildHovels(uint amount) public
436              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfGold(amount * hovelCost)
437     {
438         Kingdom storage kingdom = kingdoms[msg.sender];
439         kingdom.gold -= amount * hovelCost;
440         kingdom.hovels += amount;
441         kingdom.actions -= 1;
442     }
443 
444     function buildBarracks(uint amount) public
445              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfGold(amount * barracksCost)
446     {
447         Kingdom storage kingdom = kingdoms[msg.sender];
448         kingdom.gold -= amount * barracksCost;
449         kingdom.barracks += amount;
450         kingdom.actions -= 1;
451     }
452 
453     function buildMiningCamps(uint amount) public
454              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfGold(amount * miningCampCost)
455     {
456         Kingdom storage kingdom = kingdoms[msg.sender];
457         kingdom.gold -= amount * miningCampCost;
458         kingdom.miningCamps += amount;
459         kingdom.actions -= 1;
460     }
461     
462     function buildBanks(uint amount) public
463              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfGold(amount * bankCost) onlyIfUnderBankLimit(amount)
464     {
465         Kingdom storage kingdom = kingdoms[msg.sender];
466         kingdom.gold -= amount * bankCost;
467         kingdom.banks += amount;
468         kingdom.actions -= 1;
469     }
470 
471     function buildCastles(uint amount) public
472              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfGold(amount * castleCost)
473     {
474         Kingdom storage kingdom = kingdoms[msg.sender];
475         kingdom.gold -= amount * castleCost;
476         kingdom.castles += amount;
477         kingdom.actions -= 1;
478     }
479 
480     function attack(uint targetPlayerIndex, uint numberOfSoldiers) public
481              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfOtherPlayerIndex(targetPlayerIndex)
482     {
483         Kingdom storage attackingKingdom = kingdoms[msg.sender];
484         require(attackingKingdom.soldiers >= numberOfSoldiers);
485         
486         address targetPlayer = players[targetPlayerIndex];        
487         Kingdom storage defendingKingdom = kingdoms[targetPlayer];
488         
489         uint goldExchanged = 0;
490         
491         uint randomValue = (uint(keccak256(abi.encodePacked(block.timestamp))) << 2) >> ((block.timestamp / 9753) % 7);
492 
493         uint attackForce = numberOfSoldiers         * soldierAttack
494                          + attackingKingdom.spies   * spyAttack
495                          + attackingKingdom.wizards * wizardAttack
496                          + attackingKingdom.dragons * dragonAttack
497                          + 1;
498         attackForce *= 100 + (randomValue % 10);
499         attackForce /= 100;
500 
501         uint defenceForce = defendingKingdom.soldiers * soldierAttack
502                           + defendingKingdom.spies    * spyAttack
503                           + defendingKingdom.wizards  * wizardAttack
504                           + defendingKingdom.dragons  * dragonAttack
505                           + defendingKingdom.barracks * barracksDefence
506                           + defendingKingdom.castles  * castleDefence
507                           + 1;
508         
509         uint attackingArmySoldierDeaths = 0;
510         uint attackingArmyWizardDeaths = 0;
511         uint attackingArmyDragonsDeaths = 0;
512         
513         if (attackForce > defenceForce)
514         {
515             // Victory
516             
517             goldExchanged = (defenceForce * defendingKingdom.gold * 1000000) / (attackForce * 2000000);
518             
519             attackingArmySoldierDeaths = (defenceForce * numberOfSoldiers * 1000000) / (attackForce * 3000000);
520             
521             if (defendingKingdom.gold < goldExchanged)
522             {
523                 goldExchanged = defendingKingdom.gold;
524             }
525             defendingKingdom.gold -= goldExchanged;
526             defendingKingdom.soldiers -= (defenceForce * defendingKingdom.soldiers * 1000000) / (attackForce * 4000000);
527             
528             goldExchanged += randomValue % (currentTurnNumber * 3); // We found this along the way!
529             attackingKingdom.gold += goldExchanged;
530             attackingKingdom.soldiers -= attackingArmySoldierDeaths;
531         }
532         else
533         {
534             // Defeat
535             
536             defendingKingdom.soldiers -= (attackForce * defendingKingdom.soldiers * 250000) / (defenceForce * 1000000);
537             
538             if (numberOfSoldiers > 0)
539             {
540                 attackingArmySoldierDeaths = randomValue % numberOfSoldiers;
541                 attackingKingdom.soldiers -= attackingArmySoldierDeaths;
542             }
543         }
544         
545         if (goldExchanged > 0 || attackingArmySoldierDeaths > 0)
546         {
547             if ((numberOfSoldiers * soldierAttack) < // Whirlwind Attack
548                 ((attackingKingdom.spies * spyAttack) + (attackingKingdom.wizards * wizardAttack) + (attackingKingdom.dragons * dragonAttack)))
549             {
550                 attackingArmyWizardDeaths = attackingKingdom.wizards / ((randomValue % 5) + 4);
551                 attackingArmyDragonsDeaths = attackingKingdom.dragons / ((randomValue % 3) + 3);
552             }
553             else
554             {
555                 attackingArmyWizardDeaths = attackingKingdom.wizards / ((randomValue % 6) + 6);
556                 attackingArmyDragonsDeaths = attackingKingdom.dragons / ((randomValue % 9) + 7);
557             }
558             attackingKingdom.wizards -= attackingArmyWizardDeaths;
559             attackingKingdom.dragons -= attackingArmyDragonsDeaths;
560         
561             defendingKingdom.wizards -= defendingKingdom.wizards  / ((randomValue % 7) + 6);
562             defendingKingdom.dragons -= defendingKingdom.dragons / ((randomValue % 9) + 9);
563         }
564         
565         attackingKingdom.actions -= 1;
566         
567         emit attackCompleted(goldExchanged, attackingArmySoldierDeaths, attackingArmyWizardDeaths, attackingArmyDragonsDeaths);
568     }
569 
570     function espionage(uint targetPlayerIndex) public
571              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfSpies() onlyIfActions() onlyIfGold(espionageCost) onlyIfOtherPlayerIndex(targetPlayerIndex)
572     {
573         Kingdom storage kingdom = kingdoms[msg.sender];
574         kingdom.gold -= espionageCost;
575         
576         address targetPlayer = players[targetPlayerIndex];        
577         Kingdom storage defendingKingdom = kingdoms[targetPlayer];
578         
579         if (kingdom.spies * 2 > defendingKingdom.spies)
580         {
581             // Success
582             
583             uint infoType = (currentTurnNumber + espionageInformationType) % 3;
584             if (infoType == 0)
585             {
586                 emit spyReported(defendingKingdom.name, 1, defendingKingdom.gold, defendingKingdom.dragons);
587             }
588             else if (infoType == 1)
589             {
590                 emit spyReported(defendingKingdom.name, 2, defendingKingdom.soldiers, defendingKingdom.banks);
591             }
592             else if (infoType == 2)
593             {
594                 emit spyReported(defendingKingdom.name, 3, defendingKingdom.miningCamps, defendingKingdom.castles);
595             }
596             
597             espionageInformationType++;
598         }
599         else
600         {
601             // Failure
602             
603             emit spyReported(defendingKingdom.name, 0, kingdom.spies, 0);
604         }
605     }
606 
607     function sabotage(uint targetPlayerIndex) public
608              onlyIfGameStarted() onlyIfTurnsRemaining() onlyIfActions() onlyIfDragons() onlyIfOtherPlayerIndex(targetPlayerIndex)
609     {
610         Kingdom storage attackingKingdom = kingdoms[msg.sender];
611 
612         address targetPlayer = players[targetPlayerIndex];
613         Kingdom storage defendingKingdom = kingdoms[targetPlayer];
614         
615         uint attackForce = attackingKingdom.dragons;
616         uint defenceForce = defendingKingdom.dragons + defendingKingdom.castles;
617         if (attackForce > defenceForce)
618         {
619             // Victory
620             
621             uint sabotagedFraction = ((attackForce * 3) / (defenceForce + 1)) + 2;
622             uint sabotagedGold = defendingKingdom.gold / (sabotagedFraction * 3);
623             uint sabotagedDragons = defendingKingdom.dragons / (sabotagedFraction * 4);
624             uint sabotagedHovels = defendingKingdom.hovels / (sabotagedFraction * 5);
625             uint sabotagedMiningCamps = defendingKingdom.miningCamps / sabotagedFraction;
626             uint sabotagedBanks = defendingKingdom.banks / (sabotagedFraction * 5);
627             defendingKingdom.gold -= sabotagedGold;
628             defendingKingdom.dragons -= sabotagedDragons;
629             defendingKingdom.hovels -= sabotagedHovels;
630             defendingKingdom.miningCamps -= sabotagedMiningCamps;
631             defendingKingdom.banks -= sabotagedBanks;
632             
633             uint dragonsKilled = sabotagedDragons * 3 + 2;
634             if (dragonsKilled > attackingKingdom.dragons)
635             {
636                 dragonsKilled = attackingKingdom.dragons;
637             }
638             attackingKingdom.dragons -= dragonsKilled;
639             
640             emit sabotaged(sabotagedGold, sabotagedDragons, sabotagedHovels, sabotagedMiningCamps, sabotagedBanks, dragonsKilled);
641         }
642         else
643         {
644             // Defeat
645             
646             uint dragonsKilled = attackingKingdom.dragons / 20 + 1;
647             attackingKingdom.dragons -= dragonsKilled;
648             
649             if (defendingKingdom.dragons < dragonsKilled)
650             {
651                 defendingKingdom.dragons = 0;
652             }
653             else
654             {
655                 defendingKingdom.dragons -= dragonsKilled;
656             }
657             
658             emit sabotaged(0, dragonsKilled, 0, 0, 0, dragonsKilled);
659         }
660         
661         attackingKingdom.actions -= 1;
662     }
663 }