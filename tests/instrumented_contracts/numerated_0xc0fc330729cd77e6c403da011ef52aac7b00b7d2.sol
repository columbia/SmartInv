1 pragma solidity 0.4.25;
2 
3 library SafeMath256 {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint256 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     function _validateAddress(address _addr) internal pure {
45         require(_addr != address(0), "invalid address");
46     }
47 
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner, "not a contract owner");
54         _;
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58         _validateAddress(newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 
63 }
64 
65 contract Pausable is Ownable {
66     event Pause();
67     event Unpause();
68 
69     bool public paused = false;
70 
71     modifier whenNotPaused() {
72         require(!paused, "contract is paused");
73         _;
74     }
75 
76     modifier whenPaused() {
77         require(paused, "contract is not paused");
78         _;
79     }
80 
81     function pause() public onlyOwner whenNotPaused {
82         paused = true;
83         emit Pause();
84     }
85 
86     function unpause() public onlyOwner whenPaused {
87         paused = false;
88         emit Unpause();
89     }
90 }
91 
92 contract Controllable is Ownable {
93     mapping(address => bool) controllers;
94 
95     modifier onlyController {
96         require(_isController(msg.sender), "no controller rights");
97         _;
98     }
99 
100     function _isController(address _controller) internal view returns (bool) {
101         return controllers[_controller];
102     }
103 
104     function _setControllers(address[] _controllers) internal {
105         for (uint256 i = 0; i < _controllers.length; i++) {
106             _validateAddress(_controllers[i]);
107             controllers[_controllers[i]] = true;
108         }
109     }
110 }
111 
112 contract Upgradable is Controllable {
113     address[] internalDependencies;
114     address[] externalDependencies;
115 
116     function getInternalDependencies() public view returns(address[]) {
117         return internalDependencies;
118     }
119 
120     function getExternalDependencies() public view returns(address[]) {
121         return externalDependencies;
122     }
123 
124     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
125         for (uint256 i = 0; i < _newDependencies.length; i++) {
126             _validateAddress(_newDependencies[i]);
127         }
128         internalDependencies = _newDependencies;
129     }
130 
131     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
132         externalDependencies = _newDependencies;
133         _setControllers(_newDependencies);
134     }
135 }
136 
137 contract Battle {
138     function start(uint256, uint256, uint8[2], uint8[2], uint256, bool) external returns (uint256[2], uint32, uint32, uint32, uint32, uint256);
139 }
140 
141 contract Treasury {
142     function takeGold(uint256) external;
143 }
144 
145 contract Random {
146     function random(uint256) external view returns (uint256);
147     function randomOfBlock(uint256, uint256) external view returns (uint256);
148 }
149 
150 contract Getter {
151     function getDragonStrength(uint256) external view returns (uint32);
152     function isDragonOwner(address, uint256) external view returns (bool);
153     function isDragonInGladiatorBattle(uint256) public view returns (bool);
154     function isDragonOnSale(uint256) public view returns (bool);
155     function isBreedingOnSale(uint256) public view returns (bool);
156 }
157 
158 contract Gold {
159     function remoteTransfer(address _to, uint256 _value) external;
160 }
161 
162 contract GladiatorBattleStorage {
163     function challengesAmount() external view returns (uint256);
164     function battleOccurred(uint256) external view returns (bool);
165     function challengeCancelled(uint256) external view returns (bool);
166     function getChallengeApplicants(uint256) external view returns (uint256[]);
167     function challengeApplicantsAmount(uint256) external view returns (uint256);
168     function userApplicationIndex(address, uint256) external view returns (uint256, bool, uint256);
169     function challenges(uint256) external view returns (bool, uint256, uint256);
170     function challengeCompensation(uint256) external view returns (uint256);
171     function getDragonApplication(uint256) external view returns (uint256, uint8[2], address);
172     function battleBlockNumber(uint256) external view returns (uint256);
173     function creator(uint256) external view returns (address, uint256);
174     function opponent(uint256) external view returns (address, uint256);
175     function winner(uint256) external view returns (address, uint256);
176     function setCompensation(uint256, uint256) external;
177     function create(bool, uint256, uint16) external returns (uint256);
178     function addUserChallenge(address, uint256) external;
179     function addUserApplication(address, uint256, uint256) external;
180     function removeUserApplication(address, uint256) external;
181     function addChallengeApplicant(uint256, uint256) external;
182     function setCreator(uint256, address, uint256) external;
183     function setOpponent(uint256, address, uint256) external;
184     function setWinner(uint256, address, uint256) external;
185     function setDragonApplication(uint256, uint256, uint8[2], address) external;
186     function removeDragonApplication(uint256, uint256) external;
187     function setBattleBlockNumber(uint256, uint256) external;
188     function setAutoSelectBlock(uint256, uint256) external;
189     function autoSelectBlock(uint256) external view returns (uint256);
190     function challengeApplicants(uint256, uint256) external view returns (uint256);
191     function payOut(address, bool, uint256) external;
192     function setBattleOccurred(uint256) external;
193     function setChallengeCancelled(uint256) external;
194     function setChallengeBattleId(uint256, uint256) external;
195     function getExtensionTimePrice(uint256) external view returns (uint256);
196     function setExtensionTimePrice(uint256, uint256) external;
197 }
198 
199 contract GladiatorBattleSpectatorsStorage {
200     function challengeBetsValue(uint256, bool) external view returns (uint256);
201     function challengeBalance(uint256) external view returns (uint256);
202     function payOut(address, bool, uint256) external;
203     function setChallengeBalance(uint256, uint256) external;
204 }
205 
206 
207 contract GladiatorBattle is Upgradable {
208     using SafeMath256 for uint256;
209 
210     Battle battle;
211     Random random;
212     Gold goldTokens;
213     Getter getter;
214     Treasury treasury;
215     GladiatorBattleStorage _storage_;
216     GladiatorBattleSpectatorsStorage spectatorsStorage;
217 
218     uint8 constant MAX_TACTICS_PERCENTAGE = 80;
219     uint8 constant MIN_TACTICS_PERCENTAGE = 20;
220     uint8 constant MAX_DRAGON_STRENGTH_PERCENTAGE = 120;
221     uint8 constant PERCENTAGE = 100;
222     uint256 AUTO_SELECT_TIME = 6000; // in blocks
223     uint256 INTERVAL_FOR_NEW_BLOCK = 1000; // in blocks
224 
225     function() external payable {}
226 
227     function _safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
228         return b > a ? 0 : a.sub(b);
229     }
230 
231     function _payForBet(
232         uint256 _value,
233         bool _isGold,
234         uint256 _bet
235     ) internal {
236         if (_isGold) {
237             require(_value == 0, "specify isGold as false to send eth");
238             goldTokens.remoteTransfer(address(_storage_), _bet);
239         } else {
240             require(_value == _bet, "wrong eth amount");
241             address(_storage_).transfer(_value);
242         }
243     }
244 
245     function _validateChallengeId(uint256 _challengeId) internal view {
246         require(
247             _challengeId > 0 &&
248             _challengeId < _storage_.challengesAmount(),
249             "wrong challenge id"
250         );
251     }
252 
253     function _validateTactics(uint8[2] _tactics) internal pure {
254         require(
255             _tactics[0] >= MIN_TACTICS_PERCENTAGE &&
256             _tactics[0] <= MAX_TACTICS_PERCENTAGE &&
257             _tactics[1] >= MIN_TACTICS_PERCENTAGE &&
258             _tactics[1] <= MAX_TACTICS_PERCENTAGE,
259             "tactics value must be between 20 and 80"
260         );
261     }
262 
263     function _checkDragonAvailability(address _user, uint256 _dragonId) internal view {
264         require(getter.isDragonOwner(_user, _dragonId), "not a dragon owner");
265         require(!getter.isDragonOnSale(_dragonId), "dragon is on sale");
266         require(!getter.isBreedingOnSale(_dragonId), "dragon is on breeding sale");
267         require(!isDragonChallenging(_dragonId), "this dragon has already applied");
268     }
269 
270     function _checkTheBattleHasNotOccurred(uint256 _challengeId) internal view {
271         require(!_storage_.battleOccurred(_challengeId), "the battle has already occurred");
272     }
273 
274     function _checkTheChallengeIsNotCancelled(uint256 _id) internal view {
275         require(!_storage_.challengeCancelled(_id), "the challenge is cancelled");
276     }
277 
278     function _checkTheOpponentIsNotSelected(uint256 _id) internal view {
279         require(!_isOpponentSelected(_id), "opponent already selected");
280     }
281 
282     function _checkThatTimeHasCome(uint256 _blockNumber) internal view {
283         require(_blockNumber <= block.number, "time has not yet come");
284     }
285 
286     function _checkChallengeCreator(uint256 _id, address _user) internal view {
287         (address _creator, ) = _getCreator(_id);
288         require(_creator == _user, "not a challenge creator");
289     }
290 
291     function _checkForApplicants(uint256 _id) internal view {
292         require(_getChallengeApplicantsAmount(_id) > 0, "no applicants");
293     }
294 
295     function _compareApplicantsArrays(uint256 _challengeId, bytes32 _hash) internal view {
296         uint256[] memory _applicants = _storage_.getChallengeApplicants(_challengeId);
297         require(keccak256(abi.encode(_applicants)) == _hash, "wrong applicants array");
298     }
299 
300     function _compareDragonStrength(uint256 _challengeId, uint256 _applicantId) internal view {
301         ( , uint256 _dragonId) = _getCreator(_challengeId);
302         uint256 _strength = getter.getDragonStrength(_dragonId);
303         uint256 _applicantStrength = getter.getDragonStrength(_applicantId);
304         uint256 _maxStrength = _strength.mul(MAX_DRAGON_STRENGTH_PERCENTAGE).div(PERCENTAGE); // +20%
305         require(_applicantStrength <= _maxStrength, "too strong dragon");
306     }
307 
308     function _setChallengeCompensation(
309         uint256 _challengeId,
310         uint256 _bet,
311         uint256 _applicantsAmount
312     ) internal {
313         // 30% of a bet
314         _storage_.setCompensation(_challengeId, _bet.mul(3).div(10).div(_applicantsAmount));
315     }
316 
317     function _isOpponentSelected(uint256 _challengeId) internal view returns (bool) {
318         ( , uint256 _dragonId) = _getOpponent(_challengeId);
319         return _dragonId != 0;
320     }
321 
322     function _getChallengeApplicantsAmount(
323         uint256 _challengeId
324     ) internal view returns (uint256) {
325         return _storage_.challengeApplicantsAmount(_challengeId);
326     }
327 
328     function _getUserApplicationIndex(
329         address _user,
330         uint256 _challengeId
331     ) internal view returns (uint256, bool, uint256) {
332         return _storage_.userApplicationIndex(_user, _challengeId);
333     }
334 
335     function _getChallenge(
336         uint256 _id
337     ) internal view returns (bool, uint256, uint256) {
338         return _storage_.challenges(_id);
339     }
340 
341     function _getCompensation(
342         uint256 _id
343     ) internal view returns (uint256) {
344         return _storage_.challengeCompensation(_id);
345     }
346 
347     function _getDragonApplication(
348         uint256 _id
349     ) internal view returns (uint256, uint8[2], address) {
350         return _storage_.getDragonApplication(_id);
351     }
352 
353     function _getBattleBlockNumber(
354         uint256 _id
355     ) internal view returns (uint256) {
356         return _storage_.battleBlockNumber(_id);
357     }
358 
359     function _getCreator(
360         uint256 _id
361     ) internal view returns (address, uint256) {
362         return _storage_.creator(_id);
363     }
364 
365     function _getOpponent(
366         uint256 _id
367     ) internal view returns (address, uint256) {
368         return _storage_.opponent(_id);
369     }
370 
371     function _getSpectatorsBetsValue(
372         uint256 _challengeId,
373         bool _onCreator
374     ) internal view returns (uint256) {
375         return spectatorsStorage.challengeBetsValue(_challengeId, _onCreator);
376     }
377 
378     function isDragonChallenging(uint256 _dragonId) public view returns (bool) {
379         (uint256 _challengeId, , ) = _getDragonApplication(_dragonId);
380         if (_challengeId != 0) {
381             if (_storage_.challengeCancelled(_challengeId)) {
382                 return false;
383             }
384             ( , uint256 _owner) = _getCreator(_challengeId);
385             ( , uint256 _opponent) = _getOpponent(_challengeId);
386             bool _isParticipant = (_dragonId == _owner) || (_dragonId == _opponent);
387 
388             if (_isParticipant) {
389                 return !_storage_.battleOccurred(_challengeId);
390             }
391             return !_isOpponentSelected(_challengeId);
392         }
393         return false;
394     }
395 
396     function create(
397         address _user,
398         uint256 _dragonId,
399         uint8[2] _tactics,
400         bool _isGold,
401         uint256 _bet,
402         uint16 _counter,
403         uint256 _value // in eth
404     ) external onlyController returns (uint256 challengeId) {
405         _validateTactics(_tactics);
406         _checkDragonAvailability(_user, _dragonId);
407         require(_counter >= 5, "too few blocks");
408 
409         _payForBet(_value, _isGold, _bet);
410 
411         challengeId = _storage_.create(_isGold, _bet, _counter);
412         _storage_.addUserChallenge(_user, challengeId);
413         _storage_.setCreator(challengeId, _user, _dragonId);
414         _storage_.setDragonApplication(_dragonId, challengeId, _tactics, _user);
415     }
416 
417     function apply(
418         uint256 _challengeId,
419         address _user,
420         uint256 _dragonId,
421         uint8[2] _tactics,
422         uint256 _value // in eth
423     ) external onlyController {
424         _validateChallengeId(_challengeId);
425         _validateTactics(_tactics);
426         _checkTheBattleHasNotOccurred(_challengeId);
427         _checkTheChallengeIsNotCancelled(_challengeId);
428         _checkTheOpponentIsNotSelected(_challengeId);
429         _checkDragonAvailability(_user, _dragonId);
430         _compareDragonStrength(_challengeId, _dragonId);
431         ( , bool _exist, ) = _getUserApplicationIndex(_user, _challengeId);
432         require(!_exist, "you have already applied");
433 
434         (bool _isGold, uint256 _bet, ) = _getChallenge(_challengeId);
435 
436         _payForBet(_value, _isGold, _bet);
437 
438         _storage_.addUserApplication(_user, _challengeId, _dragonId);
439         _storage_.setDragonApplication(_dragonId, _challengeId, _tactics, _user);
440         _storage_.addChallengeApplicant(_challengeId, _dragonId);
441 
442         // if it's the first applicant then set auto select block
443         if (_getChallengeApplicantsAmount(_challengeId) == 1) {
444             _storage_.setAutoSelectBlock(_challengeId, block.number.add(AUTO_SELECT_TIME));
445         }
446     }
447 
448     function chooseOpponent(
449         address _user,
450         uint256 _challengeId,
451         uint256 _applicantId,
452         bytes32 _applicantsHash
453     ) external onlyController {
454         _validateChallengeId(_challengeId);
455         _checkChallengeCreator(_challengeId, _user);
456         _compareApplicantsArrays(_challengeId, _applicantsHash);
457         _selectOpponent(_challengeId, _applicantId);
458     }
459 
460     function autoSelectOpponent(
461         uint256 _challengeId,
462         bytes32 _applicantsHash
463     ) external onlyController returns (uint256 applicantId) {
464         _validateChallengeId(_challengeId);
465         _compareApplicantsArrays(_challengeId, _applicantsHash);
466         uint256 _autoSelectBlock = _storage_.autoSelectBlock(_challengeId);
467         require(_autoSelectBlock != 0, "no auto select");
468         _checkThatTimeHasCome(_autoSelectBlock);
469 
470         _checkForApplicants(_challengeId);
471 
472         uint256 _applicantsAmount = _getChallengeApplicantsAmount(_challengeId);
473         uint256 _index = random.random(2**256 - 1) % _applicantsAmount;
474         applicantId = _storage_.challengeApplicants(_challengeId, _index);
475 
476         _selectOpponent(_challengeId, applicantId);
477     }
478 
479     function _selectOpponent(uint256 _challengeId, uint256 _dragonId) internal {
480         _checkTheChallengeIsNotCancelled(_challengeId);
481         _checkTheOpponentIsNotSelected(_challengeId);
482 
483         (
484             uint256 _dragonChallengeId, ,
485             address _opponentUser
486         ) = _getDragonApplication(_dragonId);
487         ( , uint256 _creatorDragonId) = _getCreator(_challengeId);
488 
489         require(_dragonChallengeId == _challengeId, "wrong opponent");
490         require(_creatorDragonId != _dragonId, "the same dragon");
491 
492         _storage_.setOpponent(_challengeId, _opponentUser, _dragonId);
493 
494         ( , uint256 _bet, uint256 _counter) = _getChallenge(_challengeId);
495         _storage_.setBattleBlockNumber(_challengeId, block.number.add(_counter));
496 
497         _storage_.addUserChallenge(_opponentUser, _challengeId);
498         _storage_.removeUserApplication(_opponentUser, _challengeId);
499 
500         // if there are more applicants than one just selected then set challenge compensation
501         uint256 _applicantsAmount = _getChallengeApplicantsAmount(_challengeId);
502         if (_applicantsAmount > 1) {
503             uint256 _otherApplicants = _applicantsAmount.sub(1);
504             _setChallengeCompensation(_challengeId, _bet, _otherApplicants);
505         }
506     }
507 
508     function _checkBattleBlockNumber(uint256 _blockNumber) internal view {
509         require(_blockNumber != 0, "opponent is not selected");
510         _checkThatTimeHasCome(_blockNumber);
511     }
512 
513     function _checkBattlePossibilityAndGenerateRandom(uint256 _challengeId) internal view returns (uint256) {
514         uint256 _blockNumber = _getBattleBlockNumber(_challengeId);
515         _checkBattleBlockNumber(_blockNumber);
516         require(_blockNumber >= _safeSub(block.number, 256), "time has passed");
517         _checkTheBattleHasNotOccurred(_challengeId);
518         _checkTheChallengeIsNotCancelled(_challengeId);
519 
520         return random.randomOfBlock(2**256 - 1, _blockNumber);
521     }
522 
523     function _payReward(uint256 _challengeId) internal returns (uint256 reward, bool isGold) {
524         uint8 _factor = _getCompensation(_challengeId) > 0 ? 17 : 20;
525         uint256 _bet;
526         (isGold, _bet, ) = _getChallenge(_challengeId);
527         ( , uint256 _creatorId) = _getCreator(_challengeId);
528         (address _winner, uint256 _winnerId) = _storage_.winner(_challengeId);
529 
530         reward = _bet.mul(_factor).div(10);
531         _storage_.payOut(
532             _winner,
533             isGold,
534             reward
535         ); // 30% of bet to applicants
536 
537         bool _didCreatorWin = _creatorId == _winnerId;
538         uint256 _winnerBetsValue = _getSpectatorsBetsValue(_challengeId, _didCreatorWin);
539         uint256 _opponentBetsValue = _getSpectatorsBetsValue(_challengeId, !_didCreatorWin);
540         if (_opponentBetsValue > 0 && _winnerBetsValue > 0) {
541             uint256 _rewardFromSpectatorsBets = _opponentBetsValue.mul(15).div(100); // 15%
542 
543             uint256 _challengeBalance = spectatorsStorage.challengeBalance(_challengeId);
544             require(_challengeBalance >= _rewardFromSpectatorsBets, "not enough coins, something went wrong");
545 
546             spectatorsStorage.payOut(_winner, isGold, _rewardFromSpectatorsBets);
547 
548             _challengeBalance = _challengeBalance.sub(_rewardFromSpectatorsBets);
549             spectatorsStorage.setChallengeBalance(_challengeId, _challengeBalance);
550 
551             reward = reward.add(_rewardFromSpectatorsBets);
552         }
553     }
554 
555     function _setWinner(uint256 _challengeId, uint256 _dragonId) internal {
556         ( , , address _user) = _getDragonApplication(_dragonId);
557         _storage_.setWinner(_challengeId, _user, _dragonId);
558     }
559 
560     function start(
561         uint256 _challengeId
562     ) external onlyController returns (
563         uint256 seed,
564         uint256 battleId,
565         uint256 reward,
566         bool isGold
567     ) {
568         _validateChallengeId(_challengeId);
569         seed = _checkBattlePossibilityAndGenerateRandom(_challengeId);
570 
571         ( , uint256 _firstDragonId) = _getCreator(_challengeId);
572         ( , uint256 _secondDragonId) = _getOpponent(_challengeId);
573 
574         ( , uint8[2] memory _firstTactics, ) = _getDragonApplication(_firstDragonId);
575         ( , uint8[2] memory _secondTactics, ) = _getDragonApplication(_secondDragonId);
576 
577         uint256[2] memory winnerLooserIds;
578         (
579             winnerLooserIds, , , , , battleId
580         ) = battle.start(
581             _firstDragonId,
582             _secondDragonId,
583             _firstTactics,
584             _secondTactics,
585             seed,
586             true
587         );
588 
589         _setWinner(_challengeId, winnerLooserIds[0]);
590 
591         _storage_.setBattleOccurred(_challengeId);
592         _storage_.setChallengeBattleId(_challengeId, battleId);
593 
594         (reward, isGold) = _payReward(_challengeId);
595     }
596 
597     function cancel(
598         address _user,
599         uint256 _challengeId,
600         bytes32 _applicantsHash
601     ) external onlyController {
602         _validateChallengeId(_challengeId);
603         _checkChallengeCreator(_challengeId, _user);
604         _checkTheOpponentIsNotSelected(_challengeId);
605         _checkTheChallengeIsNotCancelled(_challengeId);
606         _compareApplicantsArrays(_challengeId, _applicantsHash);
607 
608         (bool _isGold, uint256 _value /* bet */, ) = _getChallenge(_challengeId);
609         uint256 _applicantsAmount = _getChallengeApplicantsAmount(_challengeId);
610         // if there are opponents then set challenge compensation
611         if (_applicantsAmount > 0) {
612             _setChallengeCompensation(_challengeId, _value, _applicantsAmount); // 30% to applicants
613             _value = _value.mul(7).div(10); // 70% to creator
614         }
615         _storage_.payOut(_user, _isGold, _value);
616         _storage_.setChallengeCancelled(_challengeId);
617     }
618 
619     function returnBet(address _user, uint256 _challengeId) external onlyController {
620         _validateChallengeId(_challengeId);
621         ( , bool _exist, uint256 _dragonId) = _getUserApplicationIndex(_user, _challengeId);
622         require(_exist, "wrong challenge");
623 
624         (bool _isGold, uint256 _bet, ) = _getChallenge(_challengeId);
625         uint256 _compensation = _getCompensation(_challengeId);
626         uint256 _value = _bet.add(_compensation);
627         _storage_.payOut(_user, _isGold, _value);
628         _storage_.removeDragonApplication(_dragonId, _challengeId);
629         _storage_.removeUserApplication(_user, _challengeId);
630 
631         // if there are no more applicants then reset auto select block
632         if (_getChallengeApplicantsAmount(_challengeId) == 0) {
633             _storage_.setAutoSelectBlock(_challengeId, 0);
634         }
635     }
636 
637     function addTimeForOpponentSelect(
638         address _user,
639         uint256 _challengeId
640     ) external onlyController returns (uint256 newAutoSelectBlock) {
641         _validateChallengeId(_challengeId);
642         _checkChallengeCreator(_challengeId, _user);
643         _checkForApplicants(_challengeId);
644         _checkTheOpponentIsNotSelected(_challengeId);
645         _checkTheChallengeIsNotCancelled(_challengeId);
646         uint256 _price = _storage_.getExtensionTimePrice(_challengeId);
647          // take gold
648         treasury.takeGold(_price);
649          // update multiplier
650         _storage_.setExtensionTimePrice(_challengeId, _price.mul(2));
651         // update auto select block
652         uint256 _autoSelectBlock = _storage_.autoSelectBlock(_challengeId);
653         newAutoSelectBlock = _autoSelectBlock.add(AUTO_SELECT_TIME);
654         _storage_.setAutoSelectBlock(_challengeId, newAutoSelectBlock);
655     }
656 
657     function updateBattleBlockNumber(
658         uint256 _challengeId
659     ) external onlyController returns (uint256 newBattleBlockNumber) {
660         _validateChallengeId(_challengeId);
661         _checkTheBattleHasNotOccurred(_challengeId);
662         _checkTheChallengeIsNotCancelled(_challengeId);
663         uint256 _blockNumber = _getBattleBlockNumber(_challengeId);
664         _checkBattleBlockNumber(_blockNumber);
665         require(_blockNumber < _safeSub(block.number, 256), "you can start a battle");
666 
667         newBattleBlockNumber = block.number.add(INTERVAL_FOR_NEW_BLOCK);
668         _storage_.setBattleBlockNumber(_challengeId, newBattleBlockNumber);
669     }
670 
671     // UPDATE CONTRACT
672 
673     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
674         super.setInternalDependencies(_newDependencies);
675 
676         battle = Battle(_newDependencies[0]);
677         random = Random(_newDependencies[1]);
678         goldTokens = Gold(_newDependencies[2]);
679         getter = Getter(_newDependencies[3]);
680         treasury = Treasury(_newDependencies[4]);
681         _storage_ = GladiatorBattleStorage(_newDependencies[5]);
682         spectatorsStorage = GladiatorBattleSpectatorsStorage(_newDependencies[6]);
683     }
684 }