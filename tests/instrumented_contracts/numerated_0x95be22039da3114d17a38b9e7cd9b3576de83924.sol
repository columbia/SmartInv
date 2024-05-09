1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     
10   address public owner;
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner public {
35     require(newOwner != address(0));
36     OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40 }
41 
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48     
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     Unpause();
84   }
85   
86 }
87 
88 
89 /**
90  * @title Helps contracts guard agains reentrancy attacks.
91  * @author Remco Bloemen <remco@2π.com>
92  * @notice If you mark a function `nonReentrant`, you should also
93  * mark it `external`.
94  */
95 contract ReentrancyGuard {
96 
97   /**
98    * @dev We use a single lock for the whole contract.
99    */
100   bool private reentrancy_lock = false;
101 
102   /**
103    * @dev Prevents a contract from calling itself, directly or indirectly.
104    * @notice If you mark a function `nonReentrant`, you should also
105    * mark it `external`. Calling one nonReentrant function from
106    * another is not supported. Instead, you can implement a
107    * `private` function doing the actual work, and a `external`
108    * wrapper marked as `nonReentrant`.
109    */
110   modifier nonReentrant() {
111     require(!reentrancy_lock);
112     reentrancy_lock = true;
113     _;
114     reentrancy_lock = false;
115   }
116 
117 }
118 
119 
120 /**
121  * @title Destructible
122  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
123  */
124 contract Destructible is Ownable {
125 
126   function Destructible() public payable { }
127 
128   /**
129    * @dev Transfers the current balance to the owner and terminates the contract.
130    */
131   function destroy() onlyOwner public {
132     selfdestruct(owner);
133   }
134 
135   function destroyAndSend(address _recipient) onlyOwner public {
136     selfdestruct(_recipient);
137   }
138   
139 }
140 
141 
142 /// @dev Interface to the Core Contract of Ether Dungeon.
143 contract EDCoreInterface {
144 
145     /// @dev The external function to get all the game settings in one call.
146     function getGameSettings() external view returns (
147         uint _recruitHeroFee,
148         uint _transportationFeeMultiplier,
149         uint _noviceDungeonId,
150         uint _consolationRewardsRequiredFaith,
151         uint _challengeFeeMultiplier,
152         uint _dungeonPreparationTime,
153         uint _trainingFeeMultiplier,
154         uint _equipmentTrainingFeeMultiplier,
155         uint _preparationPeriodTrainingFeeMultiplier,
156         uint _preparationPeriodEquipmentTrainingFeeMultiplier
157     );
158     
159     /**
160      * @dev The external function to get all the relevant information about a specific player by its address.
161      * @param _address The address of the player.
162      */
163     function getPlayerDetails(address _address) external view returns (
164         uint dungeonId, 
165         uint payment, 
166         uint dungeonCount, 
167         uint heroCount, 
168         uint faith,
169         bool firstHeroRecruited
170     );
171     
172     /**
173      * @dev The external function to get all the relevant information about a specific dungeon by its ID.
174      * @param _id The ID of the dungeon.
175      */
176     function getDungeonDetails(uint _id) external view returns (
177         uint creationTime, 
178         uint status, 
179         uint difficulty, 
180         uint capacity, 
181         address owner, 
182         bool isReady, 
183         uint playerCount
184     );
185     
186     /**
187      * @dev Split floor related details out of getDungeonDetails, just to avoid Stack Too Deep error.
188      * @param _id The ID of the dungeon.
189      */
190     function getDungeonFloorDetails(uint _id) external view returns (
191         uint floorNumber, 
192         uint floorCreationTime, 
193         uint rewards, 
194         uint seedGenes, 
195         uint floorGenes
196     );
197 
198     /**
199      * @dev The external function to get all the relevant information about a specific hero by its ID.
200      * @param _id The ID of the hero.
201      */
202     function getHeroDetails(uint _id) external view returns (
203         uint creationTime, 
204         uint cooldownStartTime, 
205         uint cooldownIndex, 
206         uint genes, 
207         address owner, 
208         bool isReady, 
209         uint cooldownRemainingTime
210     );
211 
212     /// @dev Get the attributes (equipments + stats) of a hero from its gene.
213     function getHeroAttributes(uint _genes) public pure returns (uint[]);
214     
215     /// @dev Calculate the power of a hero from its gene, it calculates the equipment power, stats power, and super hero boost.
216     function getHeroPower(uint _genes, uint _dungeonDifficulty) public pure returns (
217         uint totalPower, 
218         uint equipmentPower, 
219         uint statsPower, 
220         bool isSuper, 
221         uint superRank,
222         uint superBoost
223     );
224     
225     /// @dev Calculate the power of a dungeon floor.
226     function getDungeonPower(uint _genes) public pure returns (uint);
227     
228     /**
229      * @dev Calculate the sum of top 5 heroes power a player owns.
230      *  The gas usage increased with the number of heroes a player owned, roughly 500 x hero count.
231      *  This is used in transport function only to calculate the required tranport fee.
232      */
233     function calculateTop5HeroesPower(address _address, uint _dungeonId) public view returns (uint);
234     
235 }
236 
237 
238 /// @dev Core Contract of "Enter the Coliseum" game of the ED (Ether Dungeon) Platform.
239 contract EDColiseumAlpha is Pausable, ReentrancyGuard, Destructible {
240     
241     struct Participant {
242         address player;
243         uint heroId;
244         uint heroPower;
245     }
246     
247     /// @dev The address of the EtherDungeonCore contract.
248     EDCoreInterface public edCoreContract = EDCoreInterface(0xf7eD56c1AC4d038e367a987258b86FC883b960a1);
249     
250     /// @dev Seed for the random number generator used for calculating fighting result.
251     uint _seed;
252     
253     
254     /* ======== SETTINGS ======== */
255 
256     /// @dev The required win count to win a jackpot.
257     uint public jackpotWinCount = 3;
258     
259     /// @dev The percentage of jackpot a player get when reaching the jackpotWinCount.
260     uint public jackpotWinPercent = 50;
261     
262     /// @dev The percentage of rewards a player get when being the final winner of a tournament.
263     uint public winPercent = 55;
264     
265     /// @dev The percentage of rewards a player get when being the final loser of a tournament, remaining will add to tournamentJackpot.
266     uint public losePercent = 35;
267     
268     /// @dev Dungeon difficulty to be used when calculating super hero power boost, 1 is no boost.
269     uint public dungeonDifficulty = 1;
270 
271     /// @dev The required fee to join a participant
272     uint public participationFee = 0.02 ether;
273     
274     /// @dev The maximum number of participants for a tournament.
275     uint public constant maxParticipantCount = 8;
276     
277     
278     /* ======== STATE VARIABLES ======== */
279     
280     /// @dev The next tournaments round number.
281     uint public nextTournamentRound = 1;
282 
283     /// @dev The current accumulated rewards pool.
284     uint public tournamentRewards;
285 
286     /// @dev The current accumulated jackpot.
287     uint public tournamentJackpot = 0.2 ether;
288     
289     /// @dev Array of all the participant for next tournament.
290     Participant[] public participants;
291     
292     /// @dev Array of all the participant for the previous tournament.
293     Participant[] public previousParticipants;
294     
295     /// @dev Array to store the participant index all winners / losers for each "fighting round" of the previous tournament.
296     uint[maxParticipantCount / 2] public firstRoundWinners;
297     uint[maxParticipantCount / 4] public secondRoundWinners;
298     uint[maxParticipantCount / 2] public firstRoundLosers;
299     uint[maxParticipantCount / 4] public secondRoundLosers;
300     uint public finalWinner;
301     uint public finalLoser;
302     
303     /// @dev Mapping of hero ID to the hero's last participated tournament round to avoid repeated hero participation.
304     mapping(uint => uint) public heroIdToLastRound;
305     
306     /// @dev Mapping of player ID to the consecutive win counts, used for calculating jackpot.
307     mapping(address => uint) public playerToWinCounts;
308 
309     
310     /* ======== EVENTS ======== */
311     
312     /// @dev The PlayerTransported event is fired when user transported to another dungeon.
313     event TournamentFinished(uint timestamp, uint tournamentRound, address finalWinner, address finalLoser, uint winnerRewards, uint loserRewards, uint winCount, uint jackpotRewards);
314     
315     /// @dev Payable constructor to pass in the initial jackpot ethers.
316     function EDColiseum() public payable {}
317 
318     
319     /* ======== PUBLIC/EXTERNAL FUNCTIONS ======== */
320     
321     /// @dev The external function to get all the game settings in one call.
322     function getGameSettings() external view returns (
323         uint _jackpotWinCount,
324         uint _jackpotWinPercent,
325         uint _winPercent,
326         uint _losePercent,
327         uint _dungeonDifficulty,
328         uint _participationFee,
329         uint _maxParticipantCount
330     ) {
331         _jackpotWinCount = jackpotWinCount;
332         _jackpotWinPercent = jackpotWinPercent;
333         _winPercent = winPercent;
334         _losePercent = losePercent;
335         _dungeonDifficulty = dungeonDifficulty;
336         _participationFee = participationFee;
337         _maxParticipantCount = maxParticipantCount;
338     }
339     
340     /// @dev The external function to get all the game settings in one call.
341     function getNextTournamentData() external view returns (
342         uint _nextTournamentRound,
343         uint _tournamentRewards,
344         uint _tournamentJackpot,
345         uint _participantCount
346     ) {
347         _nextTournamentRound = nextTournamentRound;
348         _tournamentRewards = tournamentRewards;
349         _tournamentJackpot = tournamentJackpot;
350         _participantCount = participants.length;
351     }
352     
353     /// @dev The external function to call when joining the next tournament.
354     function joinTournament(uint _heroId) whenNotPaused nonReentrant external payable {
355         uint genes;
356         address owner;
357         (,,, genes, owner,,) = edCoreContract.getHeroDetails(_heroId);
358         
359         // Throws if the hero is not owned by the sender.
360         require(msg.sender == owner);
361         
362         // Throws if the hero is already participated in the next tournament.
363         require(heroIdToLastRound[_heroId] != nextTournamentRound);
364         
365         // Throws if participation count is full.
366         require(participants.length < maxParticipantCount);
367         
368         // Throws if payment not enough, any exceeding funds will be transferred back to the player.
369         require(msg.value >= participationFee);
370         tournamentRewards += participationFee;
371 
372         if (msg.value > participationFee) {
373             msg.sender.transfer(msg.value - participationFee);
374         }
375         
376         // Set the hero participation round.
377         heroIdToLastRound[_heroId] = nextTournamentRound;
378         
379         // Get the hero power and set it to storage.
380         uint heroPower;
381         (heroPower,,,,) = edCoreContract.getHeroPower(genes, dungeonDifficulty);
382         
383         // Throw if heroPower is 12 (novice hero).
384         require(heroPower > 12);
385         
386         // Set the participant data to storage.
387         participants.push(Participant(msg.sender, _heroId, heroPower));
388     }
389     
390     /// @dev The onlyOwner external function to call when joining the next tournament.
391     function startTournament() onlyOwner nonReentrant external {
392         // Throws if participation count is not full.
393         require(participants.length == maxParticipantCount);
394         
395         // FIGHT!
396         _firstRoundFight();
397         _secondRoundWinnersFight();
398         _secondRoundLosersFight();
399         _finalRoundWinnersFight();
400         _finalRoundLosersFight();
401         
402         // REWARDS!
403         uint winnerRewards = tournamentRewards * winPercent / 100;
404         uint loserRewards = tournamentRewards * losePercent / 100;
405         uint addToJackpot = tournamentRewards - winnerRewards - loserRewards;
406         
407         address winner = participants[finalWinner].player;
408         address loser = participants[finalLoser].player;
409         winner.transfer(winnerRewards);
410         loser.transfer(loserRewards);
411         tournamentJackpot += addToJackpot;
412         
413         // JACKPOT!
414         playerToWinCounts[winner]++;
415         
416         // Reset other participants' consecutive winCount.
417         for (uint i = 0; i < participants.length; i++) {
418             address participant = participants[i].player;
419             
420             if (participant != winner && playerToWinCounts[participant] != 0) {
421                 playerToWinCounts[participant] = 0;
422             }
423         }
424         
425         // Detemine if the winner have enough consecutive winnings for jackpot.
426         uint jackpotRewards;
427         uint winCount = playerToWinCounts[winner];
428         if (winCount == jackpotWinCount) {
429             // Reset consecutive winCount of winner.
430             playerToWinCounts[winner] = 0;
431             
432             jackpotRewards = tournamentJackpot * jackpotWinPercent / 100;
433             tournamentJackpot -= jackpotRewards;
434             
435             winner.transfer(jackpotRewards);
436         }
437         
438         // Reset tournament data and increment round.
439         tournamentRewards = 0;
440         previousParticipants = participants;
441         participants.length = 0;
442         nextTournamentRound++;
443         
444         // Emit TournamentFinished event.
445         TournamentFinished(now, nextTournamentRound - 1, winner, loser, winnerRewards, loserRewards, winCount, jackpotRewards);
446     }
447     
448     /// @dev The onlyOwner external function to call to cancel the next tournament and refunds.
449     function cancelTournament() onlyOwner nonReentrant external {
450         for (uint i = 0; i < participants.length; i++) {
451             address participant = participants[i].player;
452             
453             if (participant != 0x0) {
454                 participant.transfer(participationFee);
455             }
456         }
457         
458         // Reset tournament data and increment round.
459         tournamentRewards = 0;
460         participants.length = 0;
461         nextTournamentRound++;
462     }
463     
464     /// @dev Withdraw all Ether from the contract.
465     function withdrawBalance() onlyOwner external {
466         // Can only withdraw if no participants joined (i.e. call cancelTournament first.)
467         require(participants.length == 0);
468         
469         msg.sender.transfer(this.balance);
470     }
471 
472     /* ======== SETTER FUNCTIONS ======== */
473     
474     function setEdCoreContract(address _newEdCoreContract) onlyOwner external {
475         edCoreContract = EDCoreInterface(_newEdCoreContract);
476     }
477     
478     function setJackpotWinCount(uint _newJackpotWinCount) onlyOwner external {
479         jackpotWinCount = _newJackpotWinCount;
480     }
481     
482     function setJackpotWinPercent(uint _newJackpotWinPercent) onlyOwner external {
483         jackpotWinPercent = _newJackpotWinPercent;
484     }
485     
486     function setWinPercent(uint _newWinPercent) onlyOwner external {
487         winPercent = _newWinPercent;
488     }
489     
490     function setLosePercent(uint _newLosePercent) onlyOwner external {
491         losePercent = _newLosePercent;
492     }
493     
494     function setDungeonDifficulty(uint _newDungeonDifficulty) onlyOwner external {
495         dungeonDifficulty = _newDungeonDifficulty;
496     }
497     
498     function setParticipationFee(uint _newParticipationFee) onlyOwner external {
499         participationFee = _newParticipationFee;
500     }
501     
502     /* ======== INTERNAL/PRIVATE FUNCTIONS ======== */
503     
504     /// @dev Compute all winners and losers for the first round.
505     function _firstRoundFight() private {
506         // Get all hero powers.
507         uint heroPower0 = participants[0].heroPower;
508         uint heroPower1 = participants[1].heroPower;
509         uint heroPower2 = participants[2].heroPower;
510         uint heroPower3 = participants[3].heroPower;
511         uint heroPower4 = participants[4].heroPower;
512         uint heroPower5 = participants[5].heroPower;
513         uint heroPower6 = participants[6].heroPower;
514         uint heroPower7 = participants[7].heroPower;
515         
516         // Random number.
517         uint rand;
518         
519         // 0 Vs 1
520         rand = _getRandomNumber(100);
521         if (
522             (heroPower0 > heroPower1 && rand < 60) || 
523             (heroPower0 == heroPower1 && rand < 50) ||
524             (heroPower0 < heroPower1 && rand < 40)
525         ) {
526             firstRoundWinners[0] = 0;
527             firstRoundLosers[0] = 1;
528         } else {
529             firstRoundWinners[0] = 1;
530             firstRoundLosers[0] = 0;
531         }
532         
533         // 2 Vs 3
534         rand = _getRandomNumber(100);
535         if (
536             (heroPower2 > heroPower3 && rand < 60) || 
537             (heroPower2 == heroPower3 && rand < 50) ||
538             (heroPower2 < heroPower3 && rand < 40)
539         ) {
540             firstRoundWinners[1] = 2;
541             firstRoundLosers[1] = 3;
542         } else {
543             firstRoundWinners[1] = 3;
544             firstRoundLosers[1] = 2;
545         }
546         
547         // 4 Vs 5
548         rand = _getRandomNumber(100);
549         if (
550             (heroPower4 > heroPower5 && rand < 60) || 
551             (heroPower4 == heroPower5 && rand < 50) ||
552             (heroPower4 < heroPower5 && rand < 40)
553         ) {
554             firstRoundWinners[2] = 4;
555             firstRoundLosers[2] = 5;
556         } else {
557             firstRoundWinners[2] = 5;
558             firstRoundLosers[2] = 4;
559         }
560         
561         // 6 Vs 7
562         rand = _getRandomNumber(100);
563         if (
564             (heroPower6 > heroPower7 && rand < 60) || 
565             (heroPower6 == heroPower7 && rand < 50) ||
566             (heroPower6 < heroPower7 && rand < 40)
567         ) {
568             firstRoundWinners[3] = 6;
569             firstRoundLosers[3] = 7;
570         } else {
571             firstRoundWinners[3] = 7;
572             firstRoundLosers[3] = 6;
573         }
574     }
575     
576     /// @dev Compute all second winners of all first round winners.
577     function _secondRoundWinnersFight() private {
578         // Get all hero powers of all first round winners.
579         uint winner0 = firstRoundWinners[0];
580         uint winner1 = firstRoundWinners[1];
581         uint winner2 = firstRoundWinners[2];
582         uint winner3 = firstRoundWinners[3];
583         uint heroPower0 = participants[winner0].heroPower;
584         uint heroPower1 = participants[winner1].heroPower;
585         uint heroPower2 = participants[winner2].heroPower;
586         uint heroPower3 = participants[winner3].heroPower;
587         
588         // Random number.
589         uint rand;
590         
591         // 0 Vs 1
592         rand = _getRandomNumber(100);
593         if (
594             (heroPower0 > heroPower1 && rand < 60) || 
595             (heroPower0 == heroPower1 && rand < 50) ||
596             (heroPower0 < heroPower1 && rand < 40)
597         ) {
598             secondRoundWinners[0] = winner0;
599         } else {
600             secondRoundWinners[0] = winner1;
601         }
602         
603         // 2 Vs 3
604         rand = _getRandomNumber(100);
605         if (
606             (heroPower2 > heroPower3 && rand < 60) || 
607             (heroPower2 == heroPower3 && rand < 50) ||
608             (heroPower2 < heroPower3 && rand < 40)
609         ) {
610             secondRoundWinners[1] = winner2;
611         } else {
612             secondRoundWinners[1] = winner3;
613         }
614     }
615     
616     /// @dev Compute all second losers of all first round losers.
617     function _secondRoundLosersFight() private {
618         // Get all hero powers of all first round losers.
619         uint loser0 = firstRoundLosers[0];
620         uint loser1 = firstRoundLosers[1];
621         uint loser2 = firstRoundLosers[2];
622         uint loser3 = firstRoundLosers[3];
623         uint heroPower0 = participants[loser0].heroPower;
624         uint heroPower1 = participants[loser1].heroPower;
625         uint heroPower2 = participants[loser2].heroPower;
626         uint heroPower3 = participants[loser3].heroPower;
627         
628         // Random number.
629         uint rand;
630         
631         // 0 Vs 1
632         rand = _getRandomNumber(100);
633         if (
634             (heroPower0 > heroPower1 && rand < 60) || 
635             (heroPower0 == heroPower1 && rand < 50) ||
636             (heroPower0 < heroPower1 && rand < 40)
637         ) {
638             secondRoundLosers[0] = loser1;
639         } else {
640             secondRoundLosers[0] = loser0;
641         }
642         
643         // 2 Vs 3
644         rand = _getRandomNumber(100);
645         if (
646             (heroPower2 > heroPower3 && rand < 60) || 
647             (heroPower2 == heroPower3 && rand < 50) ||
648             (heroPower2 < heroPower3 && rand < 40)
649         ) {
650             secondRoundLosers[1] = loser3;
651         } else {
652             secondRoundLosers[1] = loser2;
653         }
654     }
655     
656     /// @dev Compute the final winner.
657     function _finalRoundWinnersFight() private {
658         // Get all hero powers of all first round winners.
659         uint winner0 = secondRoundWinners[0];
660         uint winner1 = secondRoundWinners[1];
661         uint heroPower0 = participants[winner0].heroPower;
662         uint heroPower1 = participants[winner1].heroPower;
663         
664         // Random number.
665         uint rand;
666         
667         // 0 Vs 1
668         rand = _getRandomNumber(100);
669         if (
670             (heroPower0 > heroPower1 && rand < 60) || 
671             (heroPower0 == heroPower1 && rand < 50) ||
672             (heroPower0 < heroPower1 && rand < 40)
673         ) {
674             finalWinner = winner0;
675         } else {
676             finalWinner = winner1;
677         }
678     }
679     
680     /// @dev Compute the final loser.
681     function _finalRoundLosersFight() private {
682         // Get all hero powers of all first round winners.
683         uint loser0 = secondRoundLosers[0];
684         uint loser1 = secondRoundLosers[1];
685         uint heroPower0 = participants[loser0].heroPower;
686         uint heroPower1 = participants[loser1].heroPower;
687         
688         // Random number.
689         uint rand;
690         
691         // 0 Vs 1
692         rand = _getRandomNumber(100);
693         if (
694             (heroPower0 > heroPower1 && rand < 60) || 
695             (heroPower0 == heroPower1 && rand < 50) ||
696             (heroPower0 < heroPower1 && rand < 40)
697         ) {
698             finalLoser = loser1;
699         } else {
700             finalLoser = loser0;
701         }
702     }
703     
704     // @dev Return a pseudo random uint smaller than lower bounds.
705     function _getRandomNumber(uint _upper) private returns (uint) {
706         _seed = uint(keccak256(
707             _seed,
708             block.blockhash(block.number - 1),
709             block.coinbase,
710             block.difficulty
711         ));
712         
713         return _seed % _upper;
714     }
715 
716 }