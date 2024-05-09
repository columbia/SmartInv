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
29 contract Controllable is Ownable {
30     mapping(address => bool) controllers;
31 
32     modifier onlyController {
33         require(_isController(msg.sender), "no controller rights");
34         _;
35     }
36 
37     function _isController(address _controller) internal view returns (bool) {
38         return controllers[_controller];
39     }
40 
41     function _setControllers(address[] _controllers) internal {
42         for (uint256 i = 0; i < _controllers.length; i++) {
43             _validateAddress(_controllers[i]);
44             controllers[_controllers[i]] = true;
45         }
46     }
47 }
48 
49 contract Upgradable is Controllable {
50     address[] internalDependencies;
51     address[] externalDependencies;
52 
53     function getInternalDependencies() public view returns(address[]) {
54         return internalDependencies;
55     }
56 
57     function getExternalDependencies() public view returns(address[]) {
58         return externalDependencies;
59     }
60 
61     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
62         for (uint256 i = 0; i < _newDependencies.length; i++) {
63             _validateAddress(_newDependencies[i]);
64         }
65         internalDependencies = _newDependencies;
66     }
67 
68     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
69         externalDependencies = _newDependencies;
70         _setControllers(_newDependencies);
71     }
72 }
73 
74 
75 
76 
77 //////////////CONTRACT//////////////
78 
79 
80 
81 
82 contract Events is Upgradable {
83     event EggClaimed(address indexed user, uint256 indexed id);
84     event EggSentToNest(address indexed user, uint256 indexed id);
85     event EggHatched(address indexed user, uint256 indexed dragonId, uint256 indexed eggId);
86     event DragonUpgraded(uint256 indexed id);
87     event EggCreated(address indexed user, uint256 indexed id);
88     event DragonOnSale(address indexed seller, uint256 indexed id);
89     event DragonRemovedFromSale(address indexed seller, uint256 indexed id);
90     event DragonRemovedFromBreeding(address indexed seller, uint256 indexed id);
91     event DragonOnBreeding(address indexed seller, uint256 indexed id);
92     event DragonBought(address indexed buyer, address indexed seller, uint256 indexed id, uint256 price);
93     event DragonBreedingBought(address indexed buyer, address indexed seller, uint256 indexed id, uint256 price);
94     event DistributionUpdated(uint256 restAmount, uint256 lastBlock, uint256 interval);
95     event EggOnSale(address indexed seller, uint256 indexed id);
96     event EggRemovedFromSale(address indexed seller, uint256 indexed id);
97     event EggBought(address indexed buyer, address indexed seller, uint256 indexed id, uint256 price);
98     event GoldSellOrderCreated(address indexed seller, uint256 price, uint256 amount);
99     event GoldSellOrderCancelled(address indexed seller);
100     event GoldSold(address indexed buyer, address indexed seller, uint256 amount, uint256 price);
101     event GoldBuyOrderCreated(address indexed buyer, uint256 price, uint256 amount);
102     event GoldBuyOrderCancelled(address indexed buyer);
103     event GoldBought(address indexed seller, address indexed buyer, uint256 amount, uint256 price);
104     event SkillOnSale(address indexed seller, uint256 indexed id);
105     event SkillRemovedFromSale(address indexed seller, uint256 indexed id);
106     event SkillBought(address indexed buyer, address indexed seller, uint256 id, uint256 indexed target, uint256 price);
107     event SkillSet(uint256 indexed id);
108     event SkillUsed(uint256 indexed id, uint256 indexed target);
109     event DragonNameSet(uint256 indexed id, bytes32 name);
110     event DragonTacticsSet(uint256 indexed id, uint8 melee, uint8 attack);
111     event UserNameSet(address indexed user, bytes32 name);
112     event BattleEnded(
113         uint256 indexed battleId,
114         uint256 date,
115         uint256 seed,
116         uint256 attackerId,
117         uint256 indexed winnerId,
118         uint256 indexed looserId,
119         bool isGladiator,
120         uint256 gladiatorBattleId
121     );
122     event BattleDragonsDetails(
123         uint256 indexed battleId,
124         uint8 winnerLevel,
125         uint32 winnerCoolness,
126         uint8 looserLevel,
127         uint32 looserCoolness
128     );
129     event BattleHealthAndMana(
130         uint256 indexed battleId,
131         uint32 attackerMaxHealth,
132         uint32 attackerMaxMana,
133         uint32 attackerInitHealth,
134         uint32 attackerInitMana,
135         uint32 opponentMaxHealth,
136         uint32 opponentMaxMana,
137         uint32 opponentInitHealth,
138         uint32 opponentInitMana
139     );
140     event BattleSkills(
141         uint256 indexed battleId,
142         uint32 attackerAttack,
143         uint32 attackerDefense,
144         uint32 attackerStamina,
145         uint32 attackerSpeed,
146         uint32 attackerIntelligence,
147         uint32 opponentAttack,
148         uint32 opponentDefense,
149         uint32 opponentStamina,
150         uint32 opponentSpeed,
151         uint32 opponentIntelligence
152     );
153     event BattleTacticsAndBuffs(
154         uint256 indexed battleId,
155         uint8 attackerMeleeChance,
156         uint8 attackerAttackChance,
157         uint8 opponentMeleeChance,
158         uint8 opponentAttackChance,
159         uint32[5] attackerBuffs,
160         uint32[5] opponentBuffs
161     );
162     event GladiatorBattleEnded(
163         uint256 indexed id,
164         uint256 battleId,
165         address indexed winner,
166         address indexed looser,
167         uint256 reward,
168         bool isGold
169     );
170     event GladiatorBattleCreated(
171         uint256 indexed id,
172         address indexed user,
173         uint256 indexed dragonId,
174         uint256 bet,
175         bool isGold
176     );
177     event GladiatorBattleApplicantAdded(
178         uint256 indexed id,
179         address indexed user,
180         uint256 indexed dragonId
181     );
182     event GladiatorBattleOpponentSelected(
183         uint256 indexed id,
184         uint256 indexed dragonId
185     );
186     event GladiatorBattleCancelled(uint256 indexed id);
187     event GladiatorBattleBetReturned(uint256 indexed id, address indexed user);
188     event GladiatorBattleOpponentSelectTimeUpdated(uint256 indexed id, uint256 blockNumber);
189     event GladiatorBattleBlockNumberUpdated(uint256 indexed id, uint256 blockNumber);
190     event GladiatorBattleSpectatorBetPlaced(
191         uint256 indexed id,
192         address indexed user,
193         bool indexed willCreatorWin,
194         uint256 bet,
195         bool isGold
196     );
197     event GladiatorBattleSpectatorBetRemoved(uint256 indexed id, address indexed user);
198     event GladiatorBattleSpectatorRewardPaidOut(
199         uint256 indexed id,
200         address indexed user,
201         uint256 reward,
202         bool isGold
203     );
204     event LeaderboardRewardsDistributed(uint256[10] dragons, address[10] users);
205 
206     function emitEggClaimed(
207         address _user,
208         uint256 _id
209     ) external onlyController {
210         emit EggClaimed(_user, _id);
211     }
212 
213     function emitEggSentToNest(
214         address _user,
215         uint256 _id
216     ) external onlyController {
217         emit EggSentToNest(_user, _id);
218     }
219 
220     function emitDragonUpgraded(
221         uint256 _id
222     ) external onlyController {
223         emit DragonUpgraded(_id);
224     }
225 
226     function emitEggHatched(
227         address _user,
228         uint256 _dragonId,
229         uint256 _eggId
230     ) external onlyController {
231         emit EggHatched(_user, _dragonId, _eggId);
232     }
233 
234     function emitEggCreated(
235         address _user,
236         uint256 _id
237     ) external onlyController {
238         emit EggCreated(_user, _id);
239     }
240 
241     function emitDragonOnSale(
242         address _user,
243         uint256 _id
244     ) external onlyController {
245         emit DragonOnSale(_user, _id);
246     }
247 
248     function emitDragonRemovedFromSale(
249         address _user,
250         uint256 _id
251     ) external onlyController {
252         emit DragonRemovedFromSale(_user, _id);
253     }
254 
255     function emitDragonRemovedFromBreeding(
256         address _user,
257         uint256 _id
258     ) external onlyController {
259         emit DragonRemovedFromBreeding(_user, _id);
260     }
261 
262     function emitDragonOnBreeding(
263         address _user,
264         uint256 _id
265     ) external onlyController {
266         emit DragonOnBreeding(_user, _id);
267     }
268 
269     function emitDragonBought(
270         address _buyer,
271         address _seller,
272         uint256 _id,
273         uint256 _price
274     ) external onlyController {
275         emit DragonBought(_buyer, _seller, _id, _price);
276     }
277 
278     function emitDragonBreedingBought(
279         address _buyer,
280         address _seller,
281         uint256 _id,
282         uint256 _price
283     ) external onlyController {
284         emit DragonBreedingBought(_buyer, _seller, _id, _price);
285     }
286 
287     function emitDistributionUpdated(
288         uint256 _restAmount,
289         uint256 _lastBlock,
290         uint256 _interval
291     ) external onlyController {
292         emit DistributionUpdated(_restAmount, _lastBlock, _interval);
293     }
294 
295     function emitEggOnSale(
296         address _user,
297         uint256 _id
298     ) external onlyController {
299         emit EggOnSale(_user, _id);
300     }
301 
302     function emitEggRemovedFromSale(
303         address _user,
304         uint256 _id
305     ) external onlyController {
306         emit EggRemovedFromSale(_user, _id);
307     }
308 
309     function emitEggBought(
310         address _buyer,
311         address _seller,
312         uint256 _id,
313         uint256 _price
314     ) external onlyController {
315         emit EggBought(_buyer, _seller, _id, _price);
316     }
317 
318     function emitGoldSellOrderCreated(
319         address _user,
320         uint256 _price,
321         uint256 _amount
322     ) external onlyController {
323         emit GoldSellOrderCreated(_user, _price, _amount);
324     }
325 
326     function emitGoldSellOrderCancelled(
327         address _user
328     ) external onlyController {
329         emit GoldSellOrderCancelled(_user);
330     }
331 
332     function emitGoldSold(
333         address _buyer,
334         address _seller,
335         uint256 _amount,
336         uint256 _price
337     ) external onlyController {
338         emit GoldSold(_buyer, _seller, _amount, _price);
339     }
340 
341     function emitGoldBuyOrderCreated(
342         address _user,
343         uint256 _price,
344         uint256 _amount
345     ) external onlyController {
346         emit GoldBuyOrderCreated(_user, _price, _amount);
347     }
348 
349     function emitGoldBuyOrderCancelled(
350         address _user
351     ) external onlyController {
352         emit GoldBuyOrderCancelled(_user);
353     }
354 
355     function emitGoldBought(
356         address _buyer,
357         address _seller,
358         uint256 _amount,
359         uint256 _price
360     ) external onlyController {
361         emit GoldBought(_buyer, _seller, _amount, _price);
362     }
363 
364     function emitSkillOnSale(
365         address _user,
366         uint256 _id
367     ) external onlyController {
368         emit SkillOnSale(_user, _id);
369     }
370 
371     function emitSkillRemovedFromSale(
372         address _user,
373         uint256 _id
374     ) external onlyController {
375         emit SkillRemovedFromSale(_user, _id);
376     }
377 
378     function emitSkillBought(
379         address _buyer,
380         address _seller,
381         uint256 _id,
382         uint256 _target,
383         uint256 _price
384     ) external onlyController {
385         emit SkillBought(_buyer, _seller, _id, _target, _price);
386     }
387 
388     function emitSkillSet(
389         uint256 _id
390     ) external onlyController {
391         emit SkillSet(_id);
392     }
393 
394     function emitSkillUsed(
395         uint256 _id,
396         uint256 _target
397     ) external onlyController {
398         emit SkillUsed(_id, _target);
399     }
400 
401     function emitDragonNameSet(
402         uint256 _id,
403         bytes32 _name
404     ) external onlyController {
405         emit DragonNameSet(_id, _name);
406     }
407 
408     function emitDragonTacticsSet(
409         uint256 _id,
410         uint8 _melee,
411         uint8 _attack
412     ) external onlyController {
413         emit DragonTacticsSet(_id, _melee, _attack);
414     }
415 
416     function emitUserNameSet(
417         address _user,
418         bytes32 _name
419     ) external onlyController {
420         emit UserNameSet(_user, _name);
421     }
422 
423     function emitBattleEnded(
424         uint256 _battleId,
425         uint256 _date,
426         uint256 _seed,
427         uint256 _attackerId,
428         uint256 _winnerId,
429         uint256 _looserId,
430         bool _isGladiator,
431         uint256 _gladiatorBattleId
432     ) external onlyController {
433         emit BattleEnded(
434             _battleId,
435             _date,
436             _seed,
437             _attackerId,
438             _winnerId,
439             _looserId,
440             _isGladiator,
441             _gladiatorBattleId
442         );
443     }
444 
445     function emitBattleDragonsDetails(
446         uint256 _battleId,
447         uint8 _winnerLevel,
448         uint32 _winnerCoolness,
449         uint8 _looserLevel,
450         uint32 _looserCoolness
451     ) external onlyController {
452         emit BattleDragonsDetails(
453             _battleId,
454             _winnerLevel,
455             _winnerCoolness,
456             _looserLevel,
457             _looserCoolness
458         );
459     }
460 
461     function emitBattleHealthAndMana(
462         uint256 _battleId,
463         uint32 _attackerMaxHealth,
464         uint32 _attackerMaxMana,
465         uint32 _attackerInitHealth,
466         uint32 _attackerInitMana,
467         uint32 _opponentMaxHealth,
468         uint32 _opponentMaxMana,
469         uint32 _opponentInitHealth,
470         uint32 _opponentInitMana
471     ) external onlyController {
472         emit BattleHealthAndMana(
473             _battleId,
474             _attackerMaxHealth,
475             _attackerMaxMana,
476             _attackerInitHealth,
477             _attackerInitMana,
478             _opponentMaxHealth,
479             _opponentMaxMana,
480             _opponentInitHealth,
481             _opponentInitMana
482         );
483     }
484 
485     function emitBattleSkills(
486         uint256 _battleId,
487         uint32 _attackerAttack,
488         uint32 _attackerDefense,
489         uint32 _attackerStamina,
490         uint32 _attackerSpeed,
491         uint32 _attackerIntelligence,
492         uint32 _opponentAttack,
493         uint32 _opponentDefense,
494         uint32 _opponentStamina,
495         uint32 _opponentSpeed,
496         uint32 _opponentIntelligence
497     ) external onlyController {
498         emit BattleSkills(
499             _battleId,
500             _attackerAttack,
501             _attackerDefense,
502             _attackerStamina,
503             _attackerSpeed,
504             _attackerIntelligence,
505             _opponentAttack,
506             _opponentDefense,
507             _opponentStamina,
508             _opponentSpeed,
509             _opponentIntelligence
510         );
511     }
512 
513     function emitBattleTacticsAndBuffs(
514         uint256 _battleId,
515         uint8 _attackerMeleeChance,
516         uint8 _attackerAttackChance,
517         uint8 _opponentMeleeChance,
518         uint8 _opponentAttackChance,
519         uint32[5] _attackerBuffs,
520         uint32[5] _opponentBuffs
521     ) external onlyController {
522         emit BattleTacticsAndBuffs(
523             _battleId,
524             _attackerMeleeChance,
525             _attackerAttackChance,
526             _opponentMeleeChance,
527             _opponentAttackChance,
528             _attackerBuffs,
529             _opponentBuffs
530         );
531     }
532 
533     function emitGladiatorBattleEnded(
534         uint256 _id,
535         uint256 _battleId,
536         address _winner,
537         address _looser,
538         uint256 _reward,
539         bool _isGold
540     ) external onlyController {
541         emit GladiatorBattleEnded(
542             _id,
543             _battleId,
544             _winner,
545             _looser,
546             _reward,
547             _isGold
548         );
549     }
550 
551     function emitGladiatorBattleCreated(
552         uint256 _id,
553         address _user,
554         uint256 _dragonId,
555         uint256 _bet,
556         bool _isGold
557     ) external onlyController {
558         emit GladiatorBattleCreated(
559             _id,
560             _user,
561             _dragonId,
562             _bet,
563             _isGold
564         );
565     }
566 
567     function emitGladiatorBattleApplicantAdded(
568         uint256 _id,
569         address _user,
570         uint256 _dragonId
571     ) external onlyController {
572         emit GladiatorBattleApplicantAdded(
573             _id,
574             _user,
575             _dragonId
576         );
577     }
578 
579     function emitGladiatorBattleOpponentSelected(
580         uint256 _id,
581         uint256 _dragonId
582     ) external onlyController {
583         emit GladiatorBattleOpponentSelected(
584             _id,
585             _dragonId
586         );
587     }
588 
589     function emitGladiatorBattleCancelled(
590         uint256 _id
591     ) external onlyController {
592         emit GladiatorBattleCancelled(
593             _id
594         );
595     }
596 
597     function emitGladiatorBattleBetReturned(
598         uint256 _id,
599         address _user
600     ) external onlyController {
601         emit GladiatorBattleBetReturned(
602             _id,
603             _user
604         );
605     }
606 
607     function emitGladiatorBattleOpponentSelectTimeUpdated(
608         uint256 _id,
609         uint256 _blockNumber
610     ) external onlyController {
611         emit GladiatorBattleOpponentSelectTimeUpdated(
612             _id,
613             _blockNumber
614         );
615     }
616 
617     function emitGladiatorBattleBlockNumberUpdated(
618         uint256 _id,
619         uint256 _blockNumber
620     ) external onlyController {
621         emit GladiatorBattleBlockNumberUpdated(
622             _id,
623             _blockNumber
624         );
625     }
626 
627     function emitGladiatorBattleSpectatorBetPlaced(
628         uint256 _id,
629         address _user,
630         bool _willCreatorWin,
631         uint256 _value,
632         bool _isGold
633     ) external onlyController {
634         emit GladiatorBattleSpectatorBetPlaced(
635             _id,
636             _user,
637             _willCreatorWin,
638             _value,
639             _isGold
640         );
641     }
642 
643     function emitGladiatorBattleSpectatorBetRemoved(
644         uint256 _id,
645         address _user
646     ) external onlyController {
647         emit GladiatorBattleSpectatorBetRemoved(
648             _id,
649             _user
650         );
651     }
652 
653     function emitGladiatorBattleSpectatorRewardPaidOut(
654         uint256 _id,
655         address _user,
656         uint256 _value,
657         bool _isGold
658     ) external onlyController {
659         emit GladiatorBattleSpectatorRewardPaidOut(
660             _id,
661             _user,
662             _value,
663             _isGold
664         );
665     }
666 
667     function emitLeaderboardRewardsDistributed(
668         uint256[10] _dragons,
669         address[10] _users
670     ) external onlyController {
671         emit LeaderboardRewardsDistributed(
672             _dragons,
673             _users
674         );
675     }
676 }