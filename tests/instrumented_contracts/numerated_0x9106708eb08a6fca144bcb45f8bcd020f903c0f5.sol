1 pragma solidity ^0.4.19;
2 
3 // File: contracts/ERC721Draft.sol
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 contract ERC721 {
7     function implementsERC721() public pure returns (bool);
8     function totalSupply() public view returns (uint256 total);
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function ownerOf(uint256 _tokenId) public view returns (address owner);
11     function approve(address _to, uint256 _tokenId) public;
12     function transferFrom(address _from, address _to, uint256 _tokenId) public;
13     function transfer(address _to, uint256 _tokenId) public;
14     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
15     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
16 
17     // Optional
18     // function name() public view returns (string name);
19     // function symbol() public view returns (string symbol);
20     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
21     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
22 }
23 
24 // File: contracts/FighterCoreInterface.sol
25 
26 contract FighterCoreInterface is ERC721 {
27     function getFighter(uint256 _id)
28         public
29         view
30         returns (
31         uint256 prizeCooldownEndTime,
32         uint256 battleCooldownEndTime,
33         uint256 prizeCooldownIndex,
34         uint256 battlesFought,
35         uint256 battlesWon,
36         uint256 generation,
37         uint256 genes,
38         uint256 dexterity,
39         uint256 strength,
40         uint256 vitality,
41         uint256 luck,
42         uint256 experience
43     );
44     
45     function createPrizeFighter(
46         uint16 _generation,
47         uint256 _genes,
48         uint8 _dexterity,
49         uint8 _strength,
50         uint8 _vitality,
51         uint8 _luck,
52         address _owner
53     ) public;
54     
55     function updateFighter(
56         uint256 _fighterId,
57         uint8 _dexterity,
58         uint8 _strength,
59         uint8 _vitality,
60         uint8 _luck,
61         uint32 _experience,
62         uint64 _prizeCooldownEndTime,
63         uint16 _prizeCooldownIndex,
64         uint64 _battleCooldownEndTime,
65         uint16 _battlesFought,
66         uint16 _battlesWon
67     ) public;
68 
69     function updateFighterBattleStats(
70         uint256 _fighterId,
71         uint64 _prizeCooldownEndTime,
72         uint16 _prizeCooldownIndex,
73         uint64 _battleCooldownEndTime,
74         uint16 _battlesFought,
75         uint16 _battlesWon
76     ) public;
77 
78     function updateDexterity(uint256 _fighterId, uint8 _dexterity) public;
79     function updateStrength(uint256 _fighterId, uint8 _strength) public;
80     function updateVitality(uint256 _fighterId, uint8 _vitality) public;
81     function updateLuck(uint256 _fighterId, uint8 _luck) public;
82     function updateExperience(uint256 _fighterId, uint32 _experience) public;
83 }
84 
85 // File: contracts/Battle/BattleDeciderInterface.sol
86 
87 contract BattleDeciderInterface {
88     function isBattleDecider() public pure returns (bool);
89     function determineWinner(uint256[7][] teamAttacker, uint256[7][] teamDefender) public returns (
90         bool attackerWon,
91         uint256 xpForAttacker,
92         uint256 xpForDefender
93     );
94 }
95 
96 // File: contracts/Ownable.sol
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109 
110   /**
111    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112    * account.
113    */
114   function Ownable() public {
115     owner = msg.sender;
116   }
117 
118   /**
119    * @dev Throws if called by any account other than the owner.
120    */
121   modifier onlyOwner() {
122     require(msg.sender == owner);
123     _;
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     require(newOwner != address(0));
132     OwnershipTransferred(owner, newOwner);
133     owner = newOwner;
134   }
135 
136 }
137 
138 // File: contracts/Pausable.sol
139 
140 /**
141  * @title Pausable
142  * @dev Base contract which allows children to implement an emergency stop mechanism.
143  */
144 contract Pausable is Ownable {
145   event Pause();
146   event Unpause();
147 
148   bool public paused = false;
149 
150 
151   /**
152    * @dev Modifier to make a function callable only when the contract is not paused.
153    */
154   modifier whenNotPaused() {
155     require(!paused);
156     _;
157   }
158 
159   /**
160    * @dev Modifier to make a function callable only when the contract is paused.
161    */
162   modifier whenPaused() {
163     require(paused);
164     _;
165   }
166 
167   /**
168    * @dev called by the owner to pause, triggers stopped state
169    */
170   function pause() onlyOwner whenNotPaused public {
171     paused = true;
172     Pause();
173   }
174 
175   /**
176    * @dev called by the owner to unpause, returns to normal state
177    */
178   function unpause() onlyOwner whenPaused public {
179     paused = false;
180     Unpause();
181   }
182 }
183 
184 // File: contracts/Battle/GeneScienceInterface.sol
185 
186 /// @title defined the interface that will be referenced in main Fighter contract
187 contract GeneScienceInterface {
188     /// @dev simply a boolean to indicate this is the contract we expect to be
189     function isGeneScience() public pure returns (bool);
190 
191     /// @dev given genes of fighter 1 & 2, return a genetic combination - may have a random factor
192     /// @param genes1 genes of fighter1
193     /// @param genes2 genes of fighter1
194     /// @return the genes that are supposed to be passed down the new fighter
195     function mixGenes(uint256 genes1, uint256 genes2) public returns (uint256);
196 }
197 
198 // File: contracts/Battle/BattleBase.sol
199 
200 contract BattleBase is Ownable, Pausable {
201     event TeamCreated(uint256 indexed teamId, uint256[] fighterIds);
202     event TeamDeleted(uint256 indexed teamId, uint256[] fighterIds);
203     event BattleResult(address indexed winnerAddress, address indexed loserAddress, uint256[] attackerFighterIds, uint256[] defenderFighterIds, bool attackerWon, uint16 prizeFighterGeneration, uint256 prizeFighterGenes, uint32 attackerXpGained, uint32 defenderXpGained);
204     
205     struct Team {
206         address owner;
207         uint256[] fighterIds;
208     }
209 
210     struct RaceBaseStats {
211         uint8 strength;
212         uint8 dexterity;
213         uint8 vitality;
214     }
215     
216     Team[] public teams;
217     // index => base stats (where index represents the race)
218     RaceBaseStats[] public raceBaseStats;
219     
220     uint256 internal randomCounter = 0;
221     
222     FighterCoreInterface public fighterCore;
223     GeneScienceInterface public geneScience;
224     BattleDeciderInterface public battleDecider;
225     
226     mapping (uint256 => uint256) public fighterIndexToTeam;
227     mapping (uint256 => bool) public teamIndexToExist;
228     // an array of deleted teamIds owned by each address so that we can reuse these again
229     // mapping (address => uint256[]) public addressToDeletedTeams;
230     
231     // an array of deleted teams we can reuse later
232     uint256[] public deletedTeamIds;
233     
234     uint256 public maxPerTeam = 5;
235 
236     uint8[] public genBaseStats = [
237         16, // gen 0
238         12, // gen 1
239         10, // gen 2
240         8, // gen 3
241         7, // gen 4
242         6, // gen 5
243         5, // gen 6
244         4, // gen 7
245         3, // gen 8
246         2, // gen 9
247         1 // gen 10+
248     ];
249     
250     // modifier ownsFighters(uint256[] _fighterIds) {
251     //     uint len = _fighterIds.length;
252     //     for (uint i = 0; i < len; i++) {
253     //       require(fighterCore.ownerOf(_fighterIds[i]) == msg.sender);
254     //     }
255     //     _;
256     // }
257     
258     modifier onlyTeamOwner(uint256 _teamId) {
259         require(teams[_teamId].owner == msg.sender);
260         _;
261     }
262 
263     modifier onlyExistingTeam(uint256 _teamId) {
264         require(teamIndexToExist[_teamId] == true);
265         _;
266     }
267 
268     function teamExists(uint256 _teamId) public view returns (bool) {
269         return teamIndexToExist[_teamId] == true;
270     }
271 
272     /// @dev random number from 0 to (_modulus - 1)
273     function randMod(uint256 _randCounter, uint _modulus) internal view returns (uint256) { 
274         return uint(keccak256(now, msg.sender, _randCounter)) % _modulus;
275     }
276 
277     function getDeletedTeams() public view returns (uint256[]) {
278         // return addressToDeletedTeams[_address];
279         return deletedTeamIds;
280     }
281 
282     function getRaceBaseStats(uint256 _id) public view returns (
283         uint256 strength,
284         uint256 dexterity,
285         uint256 vitality
286     ) {
287         RaceBaseStats storage race = raceBaseStats[_id];
288         
289         strength = race.strength;
290         dexterity = race.dexterity;
291         vitality = race.vitality;
292     }
293 }
294 
295 // File: contracts/Battle/BattleAdmin.sol
296 
297 contract BattleAdmin is BattleBase {
298     event ContractUpgrade(address newContract);
299 
300     address public newContractAddress;
301     
302     // An approximation of currently how many seconds are in between blocks.
303     uint256 public secondsPerBlock = 15;
304 
305     uint32[7] public prizeCooldowns = [
306         uint32(1 minutes),
307         uint32(30 minutes),
308         uint32(2 hours),
309         uint32(6 hours),
310         uint32(12 hours),
311         uint32(1 days),
312         uint32(3 days)
313     ];
314 
315     function setFighterCoreAddress(address _address) public onlyOwner {
316         _setFighterCoreAddress(_address);
317     }
318 
319     function _setFighterCoreAddress(address _address) internal {
320         FighterCoreInterface candidateContract = FighterCoreInterface(_address);
321 
322         require(candidateContract.implementsERC721());
323 
324         fighterCore = candidateContract;
325     }
326     
327     function setGeneScienceAddress(address _address) public onlyOwner {
328         _setGeneScienceAddress(_address);
329     }
330 
331     function _setGeneScienceAddress(address _address) internal {
332         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
333 
334         require(candidateContract.isGeneScience());
335 
336         geneScience = candidateContract;
337     }
338 
339     function setBattleDeciderAddress(address _address) public onlyOwner {
340         _setBattleDeciderAddress(_address);
341     }
342 
343     function _setBattleDeciderAddress(address _address) internal {
344         BattleDeciderInterface deciderCandidateContract = BattleDeciderInterface(_address);
345 
346         require(deciderCandidateContract.isBattleDecider());
347 
348         battleDecider = deciderCandidateContract;
349     }
350 
351     function addRace(uint8 _strength, uint8 _dexterity, uint8 _vitality) public onlyOwner {
352         raceBaseStats.push(RaceBaseStats({
353             strength: _strength,
354             dexterity: _dexterity,
355             vitality: _vitality
356         }));
357     }
358 
359     // in case we ever add a bad race type
360     function removeLastRace() public onlyOwner {
361         // don't allow the first 4 races to be removed
362         require(raceBaseStats.length > 4);
363         
364         delete raceBaseStats[raceBaseStats.length - 1];
365     }
366 
367     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
368     ///  breaking bug. This method does nothing but keep track of the new contract and
369     ///  emit a message indicating that the new address is set. It's up to clients of this
370     ///  contract to update to the new contract address in that case.
371     /// @param _v2Address new address
372     function setNewAddress(address _v2Address) public onlyOwner whenPaused {
373         newContractAddress = _v2Address;
374         
375         ContractUpgrade(_v2Address);
376     }
377 
378     // Owner can fix how many seconds per blocks are currently observed.
379     function setSecondsPerBlock(uint256 _secs) external onlyOwner {
380         require(_secs < prizeCooldowns[0]);
381         secondsPerBlock = _secs;
382     }
383 }
384 
385 // File: contracts/Battle/BattlePrize.sol
386 
387 contract BattlePrize is BattleAdmin {
388     // array index is level, value is experience to reach that level
389     uint32[50] public stats = [
390         0,
391         100,
392         300,
393         600,
394         1000,
395         1500,
396         2100,
397         2800,
398         3600,
399         4500,
400         5500,
401         6600,
402         7800,
403         9100,
404         10500,
405         12000,
406         13600,
407         15300,
408         17100,
409         19000,
410         21000,
411         23100,
412         25300,
413         27600,
414         30000,
415         32500,
416         35100,
417         37800,
418         40600,
419         43500,
420         46500,
421         49600,
422         52800,
423         56100,
424         59500,
425         63000,
426         66600,
427         70300,
428         74100,
429         78000,
430         82000,
431         86100,
432         90300,
433         94600,
434         99000,
435         103500,
436         108100,
437         112800,
438         117600,
439         122500
440     ];
441 
442     uint8[11] public extraStatsForGen = [
443         16, // 0 - here for ease of use even though we never create gen0s
444         12, // 1
445         10, // 2
446         8, // 3
447         7, // 4
448         6, // 5
449         5, // 6
450         4, // 7
451         3, // 8
452         2, // 9
453         1 // 10+
454     ];
455 
456     // the number of battles before a delay to gain new exp kicks in
457     uint8 public battlesTillBattleCooldown = 5;
458     // the number of battles before a delay to gain new exp kicks in
459     uint32 public experienceDelay = uint32(6 hours);
460 
461     // Luck is determined as follows:
462     // Rank 0 (5 stars) - random between 4~5
463     // Rank 1-2 (4 stars) - random between 2~4
464     // Rank 3-8 (3 stars) - random between 2~3
465     // Rank 9-15 (2 stars) - random between 1~3
466     // Rank 16+ (1 star) - random between 1~2
467     function genToLuck(uint256 _gen, uint256 _rand) public pure returns (uint8) {
468         if (_gen >= 1 || _gen <= 2) {
469             return 2 + uint8(_rand) % 3; // 2 to 4
470         } else if (_gen >= 3 || _gen <= 8) {
471             return 2 + uint8(_rand) % 2; // 2 to 3
472         }  else if (_gen >= 9 || _gen <= 15) {
473             return 1 + uint8(_rand) % 3; // 1 to 3
474         } else { // 16+
475             return 1 + uint8(_rand) % 2; // 1 to 2
476         }
477     }
478 
479     function raceToBaseStats(uint _race) public view returns (
480         uint8 strength,
481         uint8 dexterity,
482         uint8 vitality
483     ) {
484         // in case we ever have an unknown race due to new races added
485         if (_race >= raceBaseStats.length) {
486             _race = 0;
487         }
488 
489         RaceBaseStats memory raceStats = raceBaseStats[_race];
490 
491         strength = raceStats.strength;
492         dexterity = raceStats.dexterity;
493         vitality = raceStats.vitality;
494     }
495 
496     function genToExtraStats(uint256 _gen, uint256 _rand) public view returns (
497         uint8 extraStrength,
498         uint8 extraDexterity,
499         uint8 extraVitality
500     ) {
501         // in case we ever have an unknown race due to new races added
502         if (_gen >= 10) {
503             _gen = 10;
504         }
505 
506         uint8 extraStats = extraStatsForGen[_gen];
507 
508         uint256 rand1 = _rand & 0xff;
509         uint256 rand2 = _rand >> 16 & 0xff;
510         uint256 rand3 = _rand >> 16 >> 16 & 0xff;
511 
512         uint256 sum = rand1 + rand2 + rand3;
513 
514         extraStrength = uint8((extraStats * rand1) / sum);
515         extraDexterity = uint8((extraStats * rand2) / sum);
516         extraVitality = uint8((extraStats * rand3) / sum);
517 
518         uint8 remainder = extraStats - (extraStrength + extraDexterity + extraVitality);
519 
520         if (rand1 > rand2 && rand1 > rand3) {
521             extraStrength += remainder;
522         } else if (rand2 > rand3) {
523             extraDexterity += remainder;
524         } else {
525             extraVitality += remainder;
526         }
527     }
528 
529     function _getStrengthDexterityVitality(uint256 _race, uint256 _generation, uint256 _rand) public view returns (
530         uint256 strength,
531         uint256 dexterity,
532         uint256 vitality
533     ) {
534         uint8 baseStrength;
535         uint8 baseDexterity;
536         uint8 baseVitality;
537         uint8 extraStrength;
538         uint8 extraDexterity;
539         uint8 extraVitality;
540 
541         (baseStrength, baseDexterity, baseVitality) = raceToBaseStats(_race);
542         (extraStrength, extraDexterity, extraVitality) = genToExtraStats(_generation, _rand);
543 
544         strength = baseStrength + extraStrength;
545         dexterity = baseDexterity + extraDexterity;
546         vitality = baseVitality + extraVitality;
547     }
548 
549     // we return an array here, because we had an issue of too many local variables when returning a tuple
550     // function _generateFighterStats(uint256 _attackerLeaderId, uint256 _defenderLeaderId) internal returns (uint256[6]) {
551     function _generateFighterStats(uint256 generation1, uint256 genes1, uint256 generation2, uint256 genes2) internal returns (uint256[6]) {
552         // uint256 generation1;
553         // uint256 genes1;
554         // uint256 generation2;
555         // uint256 genes2;
556 
557         uint256 generation256 = ((generation1 + generation2) / 2) + 1;
558 
559         // making sure a gen 65536 doesn't turn out as a gen 0 :)
560         if (generation256 > 65535)
561             generation256 = 65535;
562         
563         uint16 generation = uint16(generation256);
564 
565         uint256 genes = geneScience.mixGenes(genes1, genes2);
566 
567         uint256 strength;
568         uint256 dexterity;
569         uint256 vitality;
570 
571         uint256 rand = uint(keccak256(now, msg.sender, randomCounter++));
572 
573         (strength, dexterity, vitality) = _getStrengthDexterityVitality(_getRaceFromGenes(genes), generation, rand);
574 
575         uint256 luck = genToLuck(genes, rand);
576 
577         return [
578             generation,
579             genes,
580             strength,
581             dexterity,
582             vitality,
583             luck
584         ];
585     }
586 
587     // takes in genes and returns raceId
588     // race is first loci after version. 
589     // [][]...[][race][version] 
590     // each loci = 2B, race is also 2B. father's gene is determining the fighter's race
591     function _getRaceFromGenes(uint256 _genes) internal pure returns (uint256) {
592         return (_genes >> (16)) & 0xff;
593     }
594 
595     function experienceToLevel(uint256 _experience) public view returns (uint256) {
596         for (uint256 i = 0; i < stats.length; i++) {
597             if (stats[i] > _experience) {
598                 // current level is i
599                 return i;
600             }
601         }
602 
603         return 50;
604     }
605 
606     // returns a number between 0 and 4 based on which stat to increase
607     // 0 - no stat increase
608     // 1 - dexterity
609     // 2 - strength
610     // 3 - vitality
611     // 4 - luck
612     function _calculateNewStat(uint32 _currentExperience, uint32 _newExperience) internal returns (uint256) {
613         // find current level
614         for (uint256 i = 0; i < stats.length; i++) {
615             if (stats[i] > _currentExperience) {
616                 // current level is i
617                 if (stats[i] <= _newExperience) {
618                     // level up a random stat
619                     return 1 + randMod(randomCounter++, 4);
620                 } else {
621                     return 0;
622                 }
623             }
624         }
625 
626         // at max level
627         return 0;
628     }
629 
630     // function _getFighterGenAndGenes(uint256 _fighterId) internal view returns (
631     //     uint256 generation,
632     //     uint256 genes
633     // ) {
634     //     (,,,,, generation, genes,,,,,) = fighterCore.getFighter(_fighterId);
635     // }
636 
637     function _getFighterStatsData(uint256 _fighterId) internal view returns (uint256[6]) {
638         uint256 dexterity;
639         uint256 strength;
640         uint256 vitality;
641         uint256 luck;
642         uint256 experience;
643         uint256 battleCooldownEndTime;
644         
645         (
646             ,
647             battleCooldownEndTime,
648             ,
649             ,
650             ,
651             ,
652             ,
653             dexterity,
654             strength,
655             vitality,
656             luck,
657             experience
658         ) = fighterCore.getFighter(_fighterId);
659 
660         return [
661             dexterity,
662             strength,
663             vitality,
664             luck,
665             experience,
666             battleCooldownEndTime
667         ];
668     }
669 
670     function _getFighterBattleData(uint256 _fighterId) internal view returns (uint256[7]) {
671         uint256 prizeCooldownEndTime;
672         uint256 prizeCooldownIndex;
673         uint256 battleCooldownEndTime;
674         uint256 battlesFought;
675         uint256 battlesWon;
676         uint256 generation;
677         uint256 genes;
678         
679         (
680             prizeCooldownEndTime,
681             battleCooldownEndTime,
682             prizeCooldownIndex,
683             battlesFought,
684             battlesWon,
685             generation,
686             genes,
687             ,
688             ,
689             ,
690             ,
691         ) = fighterCore.getFighter(_fighterId);
692 
693         return [
694             prizeCooldownEndTime,
695             prizeCooldownIndex,
696             battleCooldownEndTime,
697             battlesFought,
698             battlesWon,
699             generation,
700             genes
701         ];
702     }
703 
704     function _increaseFighterStats(
705         uint256 _fighterId,
706         uint32 _experienceGained,
707         uint[6] memory data
708     ) internal {
709         // dont update if on cooldown
710         if (data[5] >= block.number) {
711             return;
712         }
713 
714         uint32 experience = uint32(data[4]);
715         uint32 newExperience = experience + _experienceGained;
716         uint256 _statIncrease = _calculateNewStat(experience, newExperience);
717         
718         fighterCore.updateExperience(_fighterId, newExperience);
719 
720         if (_statIncrease == 1) {
721             fighterCore.updateDexterity(_fighterId, uint8(++data[0]));
722         } else if (_statIncrease == 2) {
723             fighterCore.updateStrength(_fighterId, uint8(++data[1]));
724         } else if (_statIncrease == 3) {
725             fighterCore.updateVitality(_fighterId, uint8(++data[2]));
726         } else if (_statIncrease == 4) {
727             fighterCore.updateLuck(_fighterId, uint8(++data[3]));
728         }
729     }
730 
731     function _increaseTeamFighterStats(uint256[] memory _fighterIds, uint32 _experienceGained) private {
732         for (uint i = 0; i < _fighterIds.length; i++) {
733             _increaseFighterStats(_fighterIds[i], _experienceGained, _getFighterStatsData(_fighterIds[i]));
734         }
735     }
736 
737     function _updateFighterBattleStats(
738         uint256 _fighterId,
739         bool _winner,
740         bool _leader,
741         uint[7] memory data,
742         bool _skipAwardPrize
743     ) internal {
744         uint64 prizeCooldownEndTime = uint64(data[0]);
745         uint16 prizeCooldownIndex = uint16(data[1]);
746         uint64 battleCooldownEndTime = uint64(data[2]);
747         uint16 updatedBattlesFought = uint16(data[3]) + 1;
748 
749         // trigger prize cooldown
750         if (_winner && _leader && !_skipAwardPrize) {
751             prizeCooldownEndTime = uint64((prizeCooldowns[prizeCooldownIndex] / secondsPerBlock) + block.number);
752 
753             if (prizeCooldownIndex < 6) {
754                prizeCooldownIndex += 1;
755             }
756         }
757 
758         if (updatedBattlesFought % battlesTillBattleCooldown == 0) {
759             battleCooldownEndTime = uint64((experienceDelay / secondsPerBlock) + block.number);
760         }
761 
762         fighterCore.updateFighterBattleStats(
763             _fighterId,
764             prizeCooldownEndTime,
765             prizeCooldownIndex,
766             battleCooldownEndTime,
767             updatedBattlesFought,
768             uint16(data[4]) + (_winner ? 1 : 0) // battlesWon
769         );
770     }
771 
772     function _updateTeamBattleStats(uint256[] memory _fighterIds, bool _attackerWin, bool _skipAwardPrize) private {
773         for (uint i = 0; i < _fighterIds.length; i++) {
774             _updateFighterBattleStats(_fighterIds[i], _attackerWin, i == 0, _getFighterBattleData(_fighterIds[i]), _skipAwardPrize);
775         }
776     }
777 
778     function _awardPrizeFighter(
779         address _winner, uint256[7] _attackerLeader, uint256[7] _defenderLeader
780     )
781         internal
782         returns (uint16 prizeGen, uint256 prizeGenes)
783     {
784         uint256[6] memory newFighterData = _generateFighterStats(_attackerLeader[5], _attackerLeader[6], _defenderLeader[5], _defenderLeader[6]);
785 
786         prizeGen = uint16(newFighterData[0]);
787         prizeGenes = newFighterData[1];
788 
789         fighterCore.createPrizeFighter(
790             prizeGen,
791             prizeGenes,
792             uint8(newFighterData[2]),
793             uint8(newFighterData[3]),
794             uint8(newFighterData[4]),
795             uint8(newFighterData[5]),
796             _winner
797         );
798     }
799 
800     function _updateFightersAndAwardPrizes(
801         uint256[] _attackerFighterIds,
802         uint256[] _defenderFighterIds,
803         bool _attackerWin,
804         address _winnerAddress,
805         uint32 _attackerExperienceGained,
806         uint32 _defenderExperienceGained
807     )
808         internal
809         returns (uint16 prizeGen, uint256 prizeGenes)
810     {
811         // grab prize cooldown info before it gets updated
812         uint256[7] memory attackerLeader = _getFighterBattleData(_attackerFighterIds[0]);
813         uint256[7] memory defenderLeader = _getFighterBattleData(_defenderFighterIds[0]);
814 
815         bool skipAwardPrize = (_attackerWin && attackerLeader[0] >= block.number) || (!_attackerWin && defenderLeader[0] >= block.number);
816         
817         _increaseTeamFighterStats(_attackerFighterIds, _attackerExperienceGained);
818         _increaseTeamFighterStats(_defenderFighterIds, _defenderExperienceGained);
819         
820         _updateTeamBattleStats(_attackerFighterIds, _attackerWin, skipAwardPrize);
821         _updateTeamBattleStats(_defenderFighterIds, !_attackerWin, skipAwardPrize);
822         
823         // prizes
824 
825         // dont award prize if on cooldown
826         if (skipAwardPrize) {
827             return;
828         }
829 
830         return _awardPrizeFighter(_winnerAddress, attackerLeader, defenderLeader);
831     }
832 }
833 
834 // File: contracts/Battle/BattleCore.sol
835 
836 contract BattleCore is BattlePrize {
837     function BattleCore(address _coreAddress, address _geneScienceAddress, address _battleDeciderAddress) public {
838         addRace(4, 4, 4); // half elf
839         addRace(6, 2, 4); // orc
840         addRace(4, 5, 3); // succubbus
841         addRace(6, 4, 2); // mage
842         addRace(7, 1, 4);
843 
844         _setFighterCoreAddress(_coreAddress);
845         _setGeneScienceAddress(_geneScienceAddress);
846         _setBattleDeciderAddress(_battleDeciderAddress);
847         
848         // no team 0
849         uint256[] memory fighterIds = new uint256[](1);
850         fighterIds[0] = uint256(0);
851         _createTeam(address(0), fighterIds);
852         teamIndexToExist[0] = false;
853     }
854 
855     /// @dev DON'T give me your money.
856     function() external {}
857     
858     function totalTeams() public view returns (uint256) {
859         // team 0 doesn't exist
860         return teams.length - 1;
861     }
862     
863     function isValidTeam(uint256[] _fighterIds) public view returns (bool) {
864         for (uint i = 0; i < _fighterIds.length; i++) {
865             uint256 fighterId = _fighterIds[i];
866             if (fighterCore.ownerOf(fighterId) != msg.sender)
867                 return false;
868             if (fighterIndexToTeam[fighterId] > 0)
869                 return false;
870 
871             // check for duplicate fighters
872             for (uint j = i + 1; j < _fighterIds.length; j++) {
873                 if (_fighterIds[i] == _fighterIds[j]) {
874                     return false;            
875                 }
876             }
877         }
878         
879         return true;
880     }
881     
882     function createTeam(uint256[] _fighterIds)
883         public
884         whenNotPaused
885         returns(uint256)
886     {
887         require(_fighterIds.length > 0 && _fighterIds.length <= maxPerTeam);
888         
889         require(isValidTeam(_fighterIds));
890 
891         return _createTeam(msg.sender, _fighterIds);
892     }
893     
894     function _createTeam(address _owner, uint256[] _fighterIds) internal returns(uint256) {
895         Team memory _team = Team({
896             owner: _owner,
897             fighterIds: _fighterIds
898         });
899 
900         uint256 newTeamId;
901 
902         // reuse teamId if address has deleted teams
903         if (deletedTeamIds.length > 0) {
904             newTeamId = deletedTeamIds[deletedTeamIds.length - 1];
905             delete deletedTeamIds[deletedTeamIds.length - 1];
906             deletedTeamIds.length--;
907             teams[newTeamId] = _team;
908         } else {
909             newTeamId = teams.push(_team) - 1;
910         }
911 
912         require(newTeamId <= 4294967295);
913 
914         for (uint i = 0; i < _fighterIds.length; i++) {
915             uint256 fighterId = _fighterIds[i];
916 
917             fighterIndexToTeam[fighterId] = newTeamId;
918         }
919 
920         teamIndexToExist[newTeamId] = true;
921 
922         TeamCreated(newTeamId, _fighterIds);
923 
924         return newTeamId;
925     }
926 
927     function deleteTeam(uint256 _teamId)
928         public
929         whenNotPaused
930         onlyTeamOwner(_teamId)
931         onlyExistingTeam(_teamId)
932     {
933         _deleteTeam(_teamId);
934     }
935 
936     function _deleteTeam(uint256 _teamId) private {
937         Team memory team = teams[_teamId];
938 
939         for (uint256 i = 0; i < team.fighterIds.length; i++) {
940             fighterIndexToTeam[team.fighterIds[i]] = 0;
941         }
942 
943         TeamDeleted(_teamId, team.fighterIds);
944 
945         delete teams[_teamId];
946 
947         deletedTeamIds.push(_teamId);
948         
949         teamIndexToExist[_teamId] = false;
950     }
951 
952     function battle(uint256[] _attackerFighterIds, uint256 _defenderTeamId)
953         public
954         whenNotPaused
955         onlyExistingTeam(_defenderTeamId)
956         returns (bool)
957     {
958         require(_attackerFighterIds.length > 0 && _attackerFighterIds.length <= maxPerTeam);
959         require(isValidTeam(_attackerFighterIds));
960 
961         Team memory defenderTeam = teams[_defenderTeamId];
962 
963         // check that a user isn't attacking himself
964         require(msg.sender != defenderTeam.owner);
965 
966         uint256[] memory defenderFighterIds = defenderTeam.fighterIds;
967         
968         bool attackerWon;
969         uint256 xpForAttacker;
970         uint256 xpForDefender;
971 
972         _deleteTeam(_defenderTeamId);
973 
974         (
975             attackerWon,
976             xpForAttacker,
977             xpForDefender
978         ) = battleDecider.determineWinner(getFighterArray(_attackerFighterIds), getFighterArray(defenderFighterIds));
979         
980         address winnerAddress;
981         address loserAddress;
982 
983         if (attackerWon) {
984             winnerAddress = msg.sender;
985             loserAddress = defenderTeam.owner;
986         } else {
987             winnerAddress = defenderTeam.owner;
988             loserAddress = msg.sender;
989         }
990         
991         uint16 prizeGen;
992         uint256 prizeGenes;
993         (prizeGen, prizeGenes) = _updateFightersAndAwardPrizes(_attackerFighterIds, defenderFighterIds, attackerWon, winnerAddress, uint32(xpForAttacker), uint32(xpForDefender));
994         
995         BattleResult(winnerAddress, loserAddress, _attackerFighterIds, defenderFighterIds, attackerWon, prizeGen, prizeGenes, uint32(xpForAttacker), uint32(xpForDefender));
996 
997         return attackerWon;
998     }
999         
1000     /// @param _id The ID of the team of interest.
1001     function getTeam(uint256 _id)
1002         public
1003         view
1004         returns (
1005         address owner,
1006         uint256[] fighterIds
1007     ) {
1008         Team storage _team = teams[_id];
1009 
1010         owner = _team.owner;
1011         fighterIds = _team.fighterIds;
1012     }
1013 
1014     function getFighterArray(uint256[] _fighterIds) public view returns (uint256[7][]) {
1015         uint256[7][] memory res = new uint256[7][](_fighterIds.length);
1016 
1017         for (uint i = 0; i < _fighterIds.length; i++) {
1018             uint256 generation;
1019             uint256 genes;
1020             uint256 dexterity;
1021             uint256 strength;
1022             uint256 vitality;
1023             uint256 luck;
1024             uint256 experience;
1025             
1026             (
1027                 ,
1028                 ,
1029                 ,
1030                 ,
1031                 ,
1032                 generation,
1033                 genes,
1034                 dexterity,
1035                 strength,
1036                 vitality,
1037                 luck,
1038                 experience
1039             ) = fighterCore.getFighter(_fighterIds[i]);
1040 
1041             uint256 level = experienceToLevel(experience);
1042 
1043             res[i] = [
1044                 level,
1045                 generation,
1046                 strength,
1047                 dexterity,
1048                 vitality,
1049                 luck,
1050                 genes
1051             ];
1052         }
1053 
1054         return res;
1055     }
1056 }