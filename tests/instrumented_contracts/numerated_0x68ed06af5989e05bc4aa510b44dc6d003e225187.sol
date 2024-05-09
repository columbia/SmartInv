1 pragma solidity 0.4.25;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     function _validateAddress(address _addr) internal pure {
9         require(_addr != address(0), "invalid address");
10     }
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner() {
17         require(msg.sender == owner, "not a contract owner");
18         _;
19     }
20 
21     function transferOwnership(address newOwner) public onlyOwner {
22         _validateAddress(newOwner);
23         emit OwnershipTransferred(owner, newOwner);
24         owner = newOwner;
25     }
26 
27 }
28 
29 contract Pausable is Ownable {
30     event Pause();
31     event Unpause();
32 
33     bool public paused = false;
34 
35     modifier whenNotPaused() {
36         require(!paused, "contract is paused");
37         _;
38     }
39 
40     modifier whenPaused() {
41         require(paused, "contract is not paused");
42         _;
43     }
44 
45     function pause() public onlyOwner whenNotPaused {
46         paused = true;
47         emit Pause();
48     }
49 
50     function unpause() public onlyOwner whenPaused {
51         paused = false;
52         emit Unpause();
53     }
54 }
55 
56 contract Controllable is Ownable {
57     mapping(address => bool) controllers;
58 
59     modifier onlyController {
60         require(_isController(msg.sender), "no controller rights");
61         _;
62     }
63 
64     function _isController(address _controller) internal view returns (bool) {
65         return controllers[_controller];
66     }
67 
68     function _setControllers(address[] _controllers) internal {
69         for (uint256 i = 0; i < _controllers.length; i++) {
70             _validateAddress(_controllers[i]);
71             controllers[_controllers[i]] = true;
72         }
73     }
74 }
75 
76 contract Upgradable is Controllable {
77     address[] internalDependencies;
78     address[] externalDependencies;
79 
80     function getInternalDependencies() public view returns(address[]) {
81         return internalDependencies;
82     }
83 
84     function getExternalDependencies() public view returns(address[]) {
85         return externalDependencies;
86     }
87 
88     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
89         for (uint256 i = 0; i < _newDependencies.length; i++) {
90             _validateAddress(_newDependencies[i]);
91         }
92         internalDependencies = _newDependencies;
93     }
94 
95     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
96         externalDependencies = _newDependencies;
97         _setControllers(_newDependencies);
98     }
99 }
100 
101 contract HumanOriented {
102     modifier onlyHuman() {
103         require(msg.sender == tx.origin, "not a human");
104         _;
105     }
106 }
107 
108 
109 contract Events {
110     function emitBattleEnded(uint256, uint256, uint256, uint256, uint256, uint256, bool, uint256) external;
111     function emitBattleDragonsDetails(uint256, uint8, uint32, uint8, uint32) external;
112     function emitBattleHealthAndMana(uint256, uint32, uint32, uint32, uint32, uint32, uint32, uint32, uint32) external;
113     function emitBattleSkills(uint256, uint32, uint32, uint32, uint32, uint32, uint32, uint32, uint32, uint32, uint32) external;
114     function emitBattleTacticsAndBuffs(uint256, uint8, uint8, uint8, uint8, uint32[5], uint32[5]) external;
115     function emitGladiatorBattleEnded(uint256, uint256, address, address, uint256, bool) external;
116     function emitGladiatorBattleCreated(uint256, address, uint256, uint256, bool) external;
117     function emitGladiatorBattleApplicantAdded(uint256, address, uint256) external;
118     function emitGladiatorBattleOpponentSelected(uint256, uint256) external;
119     function emitGladiatorBattleCancelled(uint256) external;
120     function emitGladiatorBattleBetReturned(uint256, address) external;
121     function emitGladiatorBattleOpponentSelectTimeUpdated(uint256, uint256) external;
122     function emitGladiatorBattleBlockNumberUpdated(uint256, uint256) external;
123     function emitGladiatorBattleSpectatorBetPlaced(uint256, address, bool, uint256, bool) external;
124     function emitGladiatorBattleSpectatorBetRemoved(uint256, address) external;
125     function emitGladiatorBattleSpectatorRewardPaidOut(uint256, address, uint256, bool) external;
126 }
127 
128 contract BattleController {
129     function startBattle(address, uint256, uint256, uint8[2]) external returns (uint256, uint256, uint256[2]);
130     function matchOpponents(uint256) external view returns (uint256[6]);
131     function resetDragonBuffs(uint256) external;
132 }
133 
134 contract Getter {
135     function getDragonProfile(uint256) external view returns (bytes32, uint16, uint256, uint8, uint8, uint16, bool, uint32);
136     function getDragonTactics(uint256) external view returns (uint8, uint8);
137     function getDragonSkills(uint256) external view returns (uint32, uint32, uint32, uint32, uint32);
138     function getDragonCurrentHealthAndMana(uint256) external view returns (uint32, uint32, uint8, uint8);
139     function getDragonMaxHealthAndMana(uint256) external view returns (uint32, uint32);
140     function getDragonBuffs(uint256) external view returns (uint32[5]);
141     function getDragonApplicationForGladiatorBattle(uint256) external view returns (uint256, uint8[2], address);
142     function getGladiatorBattleParticipants(uint256) external view returns (address, uint256, address, uint256, address, uint256);
143 }
144 
145 contract GladiatorBattle {
146     function create(address, uint256, uint8[2], bool, uint256, uint16, uint256) external returns (uint256);
147     function apply(uint256, address, uint256, uint8[2], uint256) external;
148     function chooseOpponent(address, uint256, uint256, bytes32) external;
149     function autoSelectOpponent(uint256, bytes32) external returns (uint256);
150     function start(uint256) external returns (uint256, uint256, uint256, bool);
151     function cancel(address, uint256, bytes32) external;
152     function returnBet(address, uint256) external;
153     function addTimeForOpponentSelect(address, uint256) external returns (uint256);
154     function updateBattleBlockNumber(uint256) external returns (uint256);
155 }
156 
157 contract GladiatorBattleSpectators {
158     function placeBet(address, uint256, bool, uint256, uint256) external returns (bool);
159     function removeBet(address, uint256) external;
160     function requestReward(address, uint256) external returns (uint256, bool);
161 }
162 
163 
164 
165 contract MainBattle is Upgradable, Pausable, HumanOriented {
166     BattleController battleController;
167     Getter getter;
168     GladiatorBattle gladiatorBattle;
169     GladiatorBattleSpectators gladiatorBattleSpectators;
170     Events events;
171 
172     function matchOpponents(uint256 _id) external view returns (uint256[6]) {
173         return battleController.matchOpponents(_id);
174     }
175 
176     function battle(
177         uint256 _id,
178         uint256 _opponentId,
179         uint8[2] _tactics
180     ) external onlyHuman whenNotPaused {
181         uint32 _attackerInitHealth;
182         uint32 _attackerInitMana;
183         uint32 _opponentInitHealth;
184         uint32 _opponentInitMana;
185         (_attackerInitHealth, _attackerInitMana, , ) = getter.getDragonCurrentHealthAndMana(_id);
186         (_opponentInitHealth, _opponentInitMana, , ) = getter.getDragonCurrentHealthAndMana(_opponentId);
187 
188         uint256 _battleId;
189         uint256 _seed;
190         uint256[2] memory _winnerLooserIds;
191         (
192             _battleId,
193             _seed,
194             _winnerLooserIds
195         ) = battleController.startBattle(msg.sender, _id, _opponentId, _tactics);
196 
197         _emitBattleEventsPure(
198             _id,
199             _opponentId,
200             _tactics,
201             _winnerLooserIds,
202             _battleId,
203             _seed,
204             _attackerInitHealth,
205             _attackerInitMana,
206             _opponentInitHealth,
207             _opponentInitMana
208         );
209     }
210 
211     function _emitBattleEventsPure(
212         uint256 _id,
213         uint256 _opponentId,
214         uint8[2] _tactics,
215         uint256[2] _winnerLooserIds,
216         uint256 _battleId,
217         uint256 _seed,
218         uint32 _attackerInitHealth,
219         uint32 _attackerInitMana,
220         uint32 _opponentInitHealth,
221         uint32 _opponentInitMana
222     ) internal {
223         _saveBattleHealthAndMana(
224             _battleId,
225             _id,
226             _opponentId,
227             _attackerInitHealth,
228             _attackerInitMana,
229             _opponentInitHealth,
230             _opponentInitMana
231         );
232         _emitBattleEvents(
233             _id,
234             _opponentId,
235             _tactics,
236             [0, 0],
237             _winnerLooserIds[0],
238             _winnerLooserIds[1],
239             _battleId,
240             _seed,
241             0
242         );
243     }
244 
245     function _emitBattleEventsForGladiatorBattle(
246         uint256 _battleId,
247         uint256 _seed,
248         uint256 _gladiatorBattleId
249     ) internal {
250         uint256 _firstDragonId;
251         uint256 _secondDragonId;
252         uint256 _winnerDragonId;
253         (
254           , _firstDragonId,
255           , _secondDragonId,
256           , _winnerDragonId
257         ) = getter.getGladiatorBattleParticipants(_gladiatorBattleId);
258 
259         _saveBattleHealthAndManaFull(
260             _battleId,
261             _firstDragonId,
262             _secondDragonId
263         );
264 
265         uint8[2] memory _tactics;
266         uint8[2] memory _tactics2;
267 
268         ( , _tactics, ) = getter.getDragonApplicationForGladiatorBattle(_firstDragonId);
269         ( , _tactics2, ) = getter.getDragonApplicationForGladiatorBattle(_secondDragonId);
270 
271         _emitBattleEvents(
272             _firstDragonId,
273             _secondDragonId,
274             _tactics,
275             _tactics2,
276             _winnerDragonId,
277             _winnerDragonId != _firstDragonId ? _firstDragonId : _secondDragonId,
278             _battleId,
279             _seed,
280             _gladiatorBattleId
281         );
282     }
283 
284     function _emitBattleEvents(
285         uint256 _id,
286         uint256 _opponentId,
287         uint8[2] _tactics,
288         uint8[2] _tactics2,
289         uint256 _winnerId,
290         uint256 _looserId,
291         uint256 _battleId,
292         uint256 _seed,
293         uint256 _gladiatorBattleId
294     ) internal {
295         _saveBattleData(
296             _battleId,
297             _seed,
298             _id,
299             _winnerId,
300             _looserId,
301             _gladiatorBattleId
302         );
303 
304         _saveBattleDragonsDetails(
305             _battleId,
306             _id,
307             _opponentId
308         );
309 
310         _saveBattleSkills(
311             _battleId,
312             _id,
313             _opponentId
314         );
315         _saveBattleTacticsAndBuffs(
316             _battleId,
317             _id,
318             _opponentId,
319             _tactics[0],
320             _tactics[1],
321             _tactics2[0],
322             _tactics2[1]
323         );
324     }
325 
326     function _saveBattleData(
327         uint256 _battleId,
328         uint256 _seed,
329         uint256 _attackerId,
330         uint256 _winnerId,
331         uint256 _looserId,
332         uint256 _gladiatorBattleId
333     ) internal {
334 
335         events.emitBattleEnded(
336             _battleId,
337             now,
338             _seed,
339             _attackerId,
340             _winnerId,
341             _looserId,
342             _gladiatorBattleId > 0,
343             _gladiatorBattleId
344         );
345     }
346 
347     function _saveBattleDragonsDetails(
348         uint256 _battleId,
349         uint256 _winnerId,
350         uint256 _looserId
351     ) internal {
352         uint8 _winnerLevel;
353         uint32 _winnerCoolness;
354         uint8 _looserLevel;
355         uint32 _looserCoolness;
356         (, , , _winnerLevel, , , , _winnerCoolness) = getter.getDragonProfile(_winnerId);
357         (, , , _looserLevel, , , , _looserCoolness) = getter.getDragonProfile(_looserId);
358 
359         events.emitBattleDragonsDetails(
360             _battleId,
361             _winnerLevel,
362             _winnerCoolness,
363             _looserLevel,
364             _looserCoolness
365         );
366     }
367 
368     function _saveBattleHealthAndManaFull(
369         uint256 _battleId,
370         uint256 _firstId,
371         uint256 _secondId
372     ) internal {
373         uint32 _firstInitHealth;
374         uint32 _firstInitMana;
375         uint32 _secondInitHealth;
376         uint32 _secondInitMana;
377 
378         (_firstInitHealth, _firstInitMana) = getter.getDragonMaxHealthAndMana(_firstId);
379         (_secondInitHealth, _secondInitMana) = getter.getDragonMaxHealthAndMana(_secondId);
380 
381         _saveBattleHealthAndMana(
382             _battleId,
383             _firstId,
384             _secondId,
385             _firstInitHealth,
386             _firstInitMana,
387             _secondInitHealth,
388             _secondInitMana
389         );
390     }
391 
392     function _saveBattleHealthAndMana(
393         uint256 _battleId,
394         uint256 _attackerId,
395         uint256 _opponentId,
396         uint32 _attackerInitHealth,
397         uint32 _attackerInitMana,
398         uint32 _opponentInitHealth,
399         uint32 _opponentInitMana
400     ) internal {
401         uint32 _attackerMaxHealth;
402         uint32 _attackerMaxMana;
403         uint32 _opponentMaxHealth;
404         uint32 _opponentMaxMana;
405         (_attackerMaxHealth, _attackerMaxMana) = getter.getDragonMaxHealthAndMana(_attackerId);
406         (_opponentMaxHealth, _opponentMaxMana) = getter.getDragonMaxHealthAndMana(_opponentId);
407 
408         events.emitBattleHealthAndMana(
409             _battleId,
410             _attackerMaxHealth,
411             _attackerMaxMana,
412             _attackerInitHealth,
413             _attackerInitMana,
414             _opponentMaxHealth,
415             _opponentMaxMana,
416             _opponentInitHealth,
417             _opponentInitMana
418         );
419     }
420 
421     function _saveBattleSkills(
422         uint256 _battleId,
423         uint256 _attackerId,
424         uint256 _opponentId
425     ) internal {
426         uint32 _attackerAttack;
427         uint32 _attackerDefense;
428         uint32 _attackerStamina;
429         uint32 _attackerSpeed;
430         uint32 _attackerIntelligence;
431         uint32 _opponentAttack;
432         uint32 _opponentDefense;
433         uint32 _opponentStamina;
434         uint32 _opponentSpeed;
435         uint32 _opponentIntelligence;
436 
437         (
438             _attackerAttack,
439             _attackerDefense,
440             _attackerStamina,
441             _attackerSpeed,
442             _attackerIntelligence
443         ) = getter.getDragonSkills(_attackerId);
444         (
445             _opponentAttack,
446             _opponentDefense,
447             _opponentStamina,
448             _opponentSpeed,
449             _opponentIntelligence
450         ) = getter.getDragonSkills(_opponentId);
451 
452         events.emitBattleSkills(
453             _battleId,
454             _attackerAttack,
455             _attackerDefense,
456             _attackerStamina,
457             _attackerSpeed,
458             _attackerIntelligence,
459             _opponentAttack,
460             _opponentDefense,
461             _opponentStamina,
462             _opponentSpeed,
463             _opponentIntelligence
464         );
465     }
466 
467     function _saveBattleTacticsAndBuffs(
468         uint256 _battleId,
469         uint256 _id,
470         uint256 _opponentId,
471         uint8 _attackerMeleeChance,
472         uint8 _attackerAttackChance,
473         uint8 _opponentMeleeChance,
474         uint8 _opponentAttackChance
475     ) internal {
476         if (_opponentMeleeChance == 0 || _opponentAttackChance == 0) {
477             (
478                 _opponentMeleeChance,
479                 _opponentAttackChance
480             ) = getter.getDragonTactics(_opponentId);
481         }
482 
483         uint32[5] memory _buffs = getter.getDragonBuffs(_id);
484         uint32[5] memory _opponentBuffs = getter.getDragonBuffs(_opponentId);
485 
486         battleController.resetDragonBuffs(_id);
487         battleController.resetDragonBuffs(_opponentId);
488 
489         events.emitBattleTacticsAndBuffs(
490             _battleId,
491             _attackerMeleeChance,
492             _attackerAttackChance,
493             _opponentMeleeChance,
494             _opponentAttackChance,
495             _buffs,
496             _opponentBuffs
497         );
498     }
499 
500     // GLADIATOR BATTLES
501 
502     function createGladiatorBattle(
503         uint256 _dragonId,
504         uint8[2] _tactics,
505         bool _isGold,
506         uint256 _bet,
507         uint16 _counter
508     ) external payable onlyHuman whenNotPaused {
509         address(gladiatorBattle).transfer(msg.value);
510         gladiatorBattle.create(msg.sender, _dragonId, _tactics, _isGold, _bet, _counter, msg.value);
511     }
512 
513     function applyForGladiatorBattle(
514         uint256 _battleId,
515         uint256 _dragonId,
516         uint8[2] _tactics
517     ) external payable onlyHuman whenNotPaused {
518         address(gladiatorBattle).transfer(msg.value);
519         gladiatorBattle.apply(_battleId, msg.sender, _dragonId, _tactics, msg.value);
520     }
521 
522     function chooseOpponentForGladiatorBattle(
523         uint256 _battleId,
524         uint256 _opponentId,
525         bytes32 _applicantsHash
526     ) external onlyHuman whenNotPaused {
527         gladiatorBattle.chooseOpponent(msg.sender, _battleId, _opponentId, _applicantsHash);
528     }
529 
530     function autoSelectOpponentForGladiatorBattle(
531         uint256 _battleId,
532         bytes32 _applicantsHash
533     ) external onlyHuman whenNotPaused {
534         gladiatorBattle.autoSelectOpponent(_battleId, _applicantsHash);
535     }
536 
537     function _emitGladiatorBattleEnded(
538         uint256 _gladiatorBattleId,
539         uint256 _battleId,
540         address _winner,
541         address _looser,
542         uint256 _reward,
543         bool _isGold
544     ) internal {
545         events.emitGladiatorBattleEnded(
546             _gladiatorBattleId,
547             _battleId,
548             _winner,
549             _looser,
550             _reward,
551             _isGold
552         );
553     }
554 
555     function startGladiatorBattle(
556         uint256 _gladiatorBattleId
557     ) external onlyHuman whenNotPaused returns (uint256) {
558         (
559             uint256 _seed,
560             uint256 _battleId,
561             uint256 _reward,
562             bool _isGold
563         ) = gladiatorBattle.start(_gladiatorBattleId);
564 
565         (
566             address _firstUser, ,
567             address _secondUser, ,
568             address _winner,
569             uint256 _winnerId
570         ) = getter.getGladiatorBattleParticipants(_gladiatorBattleId);
571 
572         _emitGladiatorBattleEnded(
573             _gladiatorBattleId,
574             _battleId,
575             _winner,
576             _winner != _firstUser ? _firstUser : _secondUser,
577             _reward,
578             _isGold
579         );
580 
581         _emitBattleEventsForGladiatorBattle(
582             _battleId,
583             _seed,
584             _gladiatorBattleId
585         );
586 
587         return _winnerId;
588     }
589 
590     function cancelGladiatorBattle(
591         uint256 _battleId,
592         bytes32 _applicantsHash
593     ) external onlyHuman whenNotPaused {
594         gladiatorBattle.cancel(msg.sender, _battleId, _applicantsHash);
595     }
596 
597     function returnBetFromGladiatorBattle(uint256 _battleId) external onlyHuman whenNotPaused {
598         gladiatorBattle.returnBet(msg.sender, _battleId);
599     }
600 
601     function addTimeForOpponentSelectForGladiatorBattle(uint256 _battleId) external onlyHuman whenNotPaused {
602         gladiatorBattle.addTimeForOpponentSelect(msg.sender, _battleId);
603     }
604 
605     function updateBlockNumberOfGladiatorBattle(uint256 _battleId) external onlyHuman whenNotPaused {
606         gladiatorBattle.updateBattleBlockNumber(_battleId);
607     }
608 
609     function placeSpectatorBetOnGladiatorBattle(
610         uint256 _battleId,
611         bool _willCreatorWin,
612         uint256 _value
613     ) external payable onlyHuman whenNotPaused {
614         address(gladiatorBattleSpectators).transfer(msg.value);
615         gladiatorBattleSpectators.placeBet(msg.sender, _battleId, _willCreatorWin, _value, msg.value);
616     }
617 
618     function removeSpectatorBetFromGladiatorBattle(
619         uint256 _battleId
620     ) external onlyHuman whenNotPaused {
621         gladiatorBattleSpectators.removeBet(msg.sender, _battleId);
622     }
623 
624     function requestSpectatorRewardForGladiatorBattle(
625         uint256 _battleId
626     ) external onlyHuman whenNotPaused {
627         gladiatorBattleSpectators.requestReward(msg.sender, _battleId);
628     }
629 
630     // UPDATE CONTRACT
631 
632     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
633         super.setInternalDependencies(_newDependencies);
634 
635         battleController = BattleController(_newDependencies[0]);
636         gladiatorBattle = GladiatorBattle(_newDependencies[1]);
637         gladiatorBattleSpectators = GladiatorBattleSpectators(_newDependencies[2]);
638         getter = Getter(_newDependencies[3]);
639         events = Events(_newDependencies[4]);
640     }
641 }