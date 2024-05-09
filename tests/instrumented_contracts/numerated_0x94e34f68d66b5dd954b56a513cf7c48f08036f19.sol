1 pragma solidity 0.4.25;
2 
3 library SafeMath8 {
4 
5     function mul(uint8 a, uint8 b) internal pure returns (uint8) {
6         if (a == 0) {
7             return 0;
8         }
9         uint8 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint8 a, uint8 b) internal pure returns (uint8) {
15         return a / b;
16     }
17 
18     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint8 a, uint8 b) internal pure returns (uint8) {
24         uint8 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint8 a, uint8 b) internal pure returns (uint8) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint8 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 library SafeMath16 {
40 
41     function mul(uint16 a, uint16 b) internal pure returns (uint16) {
42         if (a == 0) {
43             return 0;
44         }
45         uint16 c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49 
50     function div(uint16 a, uint16 b) internal pure returns (uint16) {
51         return a / b;
52     }
53 
54     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
55         assert(b <= a);
56         return a - b;
57     }
58 
59     function add(uint16 a, uint16 b) internal pure returns (uint16) {
60         uint16 c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 
65     function pow(uint16 a, uint16 b) internal pure returns (uint16) {
66         if (a == 0) return 0;
67         if (b == 0) return 1;
68 
69         uint16 c = a ** b;
70         assert(c / (a ** (b - 1)) == a);
71         return c;
72     }
73 }
74 
75 library SafeMath32 {
76 
77     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
78         if (a == 0) {
79             return 0;
80         }
81         uint32 c = a * b;
82         assert(c / a == b);
83         return c;
84     }
85 
86     function div(uint32 a, uint32 b) internal pure returns (uint32) {
87         return a / b;
88     }
89 
90     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
91         assert(b <= a);
92         return a - b;
93     }
94 
95     function add(uint32 a, uint32 b) internal pure returns (uint32) {
96         uint32 c = a + b;
97         assert(c >= a);
98         return c;
99     }
100 
101     function pow(uint32 a, uint32 b) internal pure returns (uint32) {
102         if (a == 0) return 0;
103         if (b == 0) return 1;
104 
105         uint32 c = a ** b;
106         assert(c / (a ** (b - 1)) == a);
107         return c;
108     }
109 }
110 
111 library SafeMath256 {
112 
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         if (a == 0) {
115             return 0;
116         }
117         uint256 c = a * b;
118         assert(c / a == b);
119         return c;
120     }
121 
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a / b;
124     }
125 
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         assert(b <= a);
128         return a - b;
129     }
130 
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         assert(c >= a);
134         return c;
135     }
136 
137     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
138         if (a == 0) return 0;
139         if (b == 0) return 1;
140 
141         uint256 c = a ** b;
142         assert(c / (a ** (b - 1)) == a);
143         return c;
144     }
145 }
146 
147 contract Ownable {
148     address public owner;
149 
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     function _validateAddress(address _addr) internal pure {
153         require(_addr != address(0), "invalid address");
154     }
155 
156     constructor() public {
157         owner = msg.sender;
158     }
159 
160     modifier onlyOwner() {
161         require(msg.sender == owner, "not a contract owner");
162         _;
163     }
164 
165     function transferOwnership(address newOwner) public onlyOwner {
166         _validateAddress(newOwner);
167         emit OwnershipTransferred(owner, newOwner);
168         owner = newOwner;
169     }
170 
171 }
172 
173 contract Pausable is Ownable {
174     event Pause();
175     event Unpause();
176 
177     bool public paused = false;
178 
179     modifier whenNotPaused() {
180         require(!paused, "contract is paused");
181         _;
182     }
183 
184     modifier whenPaused() {
185         require(paused, "contract is not paused");
186         _;
187     }
188 
189     function pause() public onlyOwner whenNotPaused {
190         paused = true;
191         emit Pause();
192     }
193 
194     function unpause() public onlyOwner whenPaused {
195         paused = false;
196         emit Unpause();
197     }
198 }
199 
200 contract Controllable is Ownable {
201     mapping(address => bool) controllers;
202 
203     modifier onlyController {
204         require(_isController(msg.sender), "no controller rights");
205         _;
206     }
207 
208     function _isController(address _controller) internal view returns (bool) {
209         return controllers[_controller];
210     }
211 
212     function _setControllers(address[] _controllers) internal {
213         for (uint256 i = 0; i < _controllers.length; i++) {
214             _validateAddress(_controllers[i]);
215             controllers[_controllers[i]] = true;
216         }
217     }
218 }
219 
220 contract Upgradable is Controllable {
221     address[] internalDependencies;
222     address[] externalDependencies;
223 
224     function getInternalDependencies() public view returns(address[]) {
225         return internalDependencies;
226     }
227 
228     function getExternalDependencies() public view returns(address[]) {
229         return externalDependencies;
230     }
231 
232     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
233         for (uint256 i = 0; i < _newDependencies.length; i++) {
234             _validateAddress(_newDependencies[i]);
235         }
236         internalDependencies = _newDependencies;
237     }
238 
239     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
240         externalDependencies = _newDependencies;
241         _setControllers(_newDependencies);
242     }
243 }
244 
245 contract Getter {
246     function getDragonProfile(uint256) external view returns (bytes32, uint16, uint256, uint8, uint8, uint16, bool, uint32);
247     function getDragonStrength(uint256) external view returns (uint32);
248     function getDragonCurrentHealthAndMana(uint256) external view returns (uint32, uint32, uint8, uint8);
249     function getDragonHealthAndMana(uint256) external view returns (uint256, uint32, uint32, uint32, uint32);
250     function getDragonsAmount() external view returns (uint256);
251     function isDragonOwner(address, uint256) external view returns (bool);
252     function ownerOfDragon(uint256) public view returns (address);
253     function isDragonInGladiatorBattle(uint256) public view returns (bool);
254 }
255 
256 contract Core is Upgradable {
257     function setDragonRemainingHealthAndMana(uint256, uint32, uint32) external;
258     function increaseDragonExperience(uint256, uint256) external;
259     function increaseDragonWins(uint256) external;
260     function increaseDragonDefeats(uint256) external;
261     function resetDragonBuffs(uint256) external;
262     function getDragonFullRegenerationTime(uint256) external view returns (uint32);
263 }
264 
265 contract Battle {
266     function start(uint256, uint256, uint8[2], uint8[2], uint256, bool) external returns (uint256[2], uint32, uint32, uint32, uint32, uint256);
267 }
268 
269 contract Treasury {
270     uint256 public hatchingPrice;
271     function giveGold(address, uint256) external;
272     function remainingGold() external view returns (uint256);
273 }
274 
275 contract Random {
276     function random(uint256) external view returns (uint256);
277 }
278 
279 
280 
281 
282 //////////////CONTRACT//////////////
283 
284 
285 
286 
287 contract BattleController is Upgradable {
288     using SafeMath8 for uint8;
289     using SafeMath16 for uint16;
290     using SafeMath32 for uint32;
291     using SafeMath256 for uint256;
292 
293     Core core;
294     Battle battle;
295     Treasury treasury;
296     Getter getter;
297     Random random;
298 
299     // stores date to which dragon is untouchable as opponent for the battle
300     mapping (uint256 => uint256) lastBattleDate;
301 
302     uint8 constant MAX_PERCENTAGE = 100;
303     uint8 constant MIN_HEALTH_PERCENTAGE = 50;
304     uint8 constant MAX_TACTICS_PERCENTAGE = 80;
305     uint8 constant MIN_TACTICS_PERCENTAGE = 20;
306     uint8 constant PERCENT_MULTIPLIER = 100;
307     uint8 constant DRAGON_STRENGTH_DIFFERENCE_PERCENTAGE = 10;
308 
309     uint256 constant GOLD_REWARD_MULTIPLIER = 10 ** 18;
310 
311     function _min(uint256 lth, uint256 rth) internal pure returns (uint256) {
312         return lth > rth ? rth : lth;
313     }
314 
315     function _isTouchable(uint256 _id) internal view returns (bool) {
316         uint32 _regenerationTime = core.getDragonFullRegenerationTime(_id);
317         return lastBattleDate[_id].add(_regenerationTime.mul(4)) < now;
318     }
319 
320     function _checkBattlePossibility(
321         address _sender,
322         uint256 _id,
323         uint256 _opponentId,
324         uint8[2] _tactics
325     ) internal view {
326         require(getter.isDragonOwner(_sender, _id), "not an owner");
327         require(!getter.isDragonOwner(_sender, _opponentId), "can't be owner of opponent dragon");
328         require(!getter.isDragonOwner(address(0), _opponentId), "opponent dragon has no owner");
329 
330         require(!getter.isDragonInGladiatorBattle(_id), "your dragon participates in gladiator battle");
331         require(!getter.isDragonInGladiatorBattle(_opponentId), "opponent dragon participates in gladiator battle");
332 
333         require(_isTouchable(_opponentId), "opponent dragon is untouchable");
334 
335         require(
336             _tactics[0] >= MIN_TACTICS_PERCENTAGE &&
337             _tactics[0] <= MAX_TACTICS_PERCENTAGE &&
338             _tactics[1] >= MIN_TACTICS_PERCENTAGE &&
339             _tactics[1] <= MAX_TACTICS_PERCENTAGE,
340             "tactics value must be between 20 and 80"
341         );
342 
343         uint8 _attackerHealthPercentage;
344         uint8 _attackerManaPercentage;
345         ( , , _attackerHealthPercentage, _attackerManaPercentage) = getter.getDragonCurrentHealthAndMana(_id);
346         require(
347             _attackerHealthPercentage >= MIN_HEALTH_PERCENTAGE,
348             "dragon's health less than 50%"
349         );
350         uint8 _opponentHealthPercentage;
351         uint8 _opponentManaPercentage;
352         ( , , _opponentHealthPercentage, _opponentManaPercentage) = getter.getDragonCurrentHealthAndMana(_opponentId);
353         require(
354             _opponentHealthPercentage == MAX_PERCENTAGE &&
355             _opponentManaPercentage == MAX_PERCENTAGE,
356             "opponent health and/or mana is not full"
357         );
358     }
359 
360     function startBattle(
361         address _sender,
362         uint256 _id,
363         uint256 _opponentId,
364         uint8[2] _tactics
365     ) external onlyController returns (
366         uint256 battleId,
367         uint256 seed,
368         uint256[2] winnerLooserIds
369     ) {
370         _checkBattlePossibility(_sender, _id, _opponentId, _tactics);
371 
372         seed = random.random(2**256 - 1);
373 
374         uint32 _winnerHealth;
375         uint32 _winnerMana;
376         uint32 _looserHealth;
377         uint32 _looserMana;
378 
379         (
380             winnerLooserIds,
381             _winnerHealth, _winnerMana,
382             _looserHealth, _looserMana,
383             battleId
384         ) = battle.start(
385             _id,
386             _opponentId,
387             _tactics,
388             [0, 0],
389             seed,
390             false
391         );
392 
393         core.setDragonRemainingHealthAndMana(winnerLooserIds[0], _winnerHealth, _winnerMana);
394         core.setDragonRemainingHealthAndMana(winnerLooserIds[1], _looserHealth, _looserMana);
395 
396         core.increaseDragonWins(winnerLooserIds[0]);
397         core.increaseDragonDefeats(winnerLooserIds[1]);
398 
399         lastBattleDate[_opponentId] = now;
400 
401         _payBattleRewards(
402             _sender,
403             _id,
404             _opponentId,
405             winnerLooserIds[0]
406         );
407     }
408 
409     function _payBattleRewards(
410         address _sender,
411         uint256 _id,
412         uint256 _opponentId,
413         uint256 _winnerId
414     ) internal {
415         uint32 _strength = getter.getDragonStrength(_id);
416         uint32 _opponentStrength = getter.getDragonStrength(_opponentId);
417         bool _isAttackerWinner = _id == _winnerId;
418 
419         uint256 _xpFactor = _calculateExperience(_isAttackerWinner, _strength, _opponentStrength);
420         core.increaseDragonExperience(_winnerId, _xpFactor);
421 
422         if (_isAttackerWinner) {
423             uint256 _factor = _calculateGoldRewardFactor(_strength, _opponentStrength);
424             _payGoldReward(_sender, _id, _factor);
425         }
426     }
427 
428     function _calculateExperience(
429         bool _isAttackerWinner,
430         uint32 _attackerStrength,
431         uint32 _opponentStrength
432     ) internal pure returns (uint256) {
433 
434         uint8 _attackerFactor;
435         uint256 _winnerStrength;
436         uint256 _looserStrength;
437 
438         uint8 _degree;
439 
440         if (_isAttackerWinner) {
441             _attackerFactor = 10;
442             _winnerStrength = _attackerStrength;
443             _looserStrength = _opponentStrength;
444             _degree = _winnerStrength <= _looserStrength ? 2 : 5;
445         } else {
446             _attackerFactor = 5;
447             _winnerStrength = _opponentStrength;
448             _looserStrength = _attackerStrength;
449             _degree = _winnerStrength <= _looserStrength ? 1 : 5;
450         }
451 
452         uint256 _factor = _looserStrength.pow(_degree).mul(_attackerFactor).div(_winnerStrength.pow(_degree));
453 
454         if (_isAttackerWinner) {
455             return _factor;
456         }
457         return _min(_factor, 10); // 1
458     }
459 
460     function _calculateGoldRewardFactor(
461         uint256 _winnerStrength,
462         uint256 _looserStrength
463     ) internal pure returns (uint256) {
464         uint8 _degree = _winnerStrength <= _looserStrength ? 1 : 8;
465         return _looserStrength.pow(_degree).mul(GOLD_REWARD_MULTIPLIER).div(_winnerStrength.pow(_degree));
466     }
467 
468     function _getMaxGoldReward(
469         uint256 _hatchingPrice,
470         uint256 _dragonsAmount
471     ) internal pure returns (uint256) {
472         uint8 _factor;
473 
474         if (_dragonsAmount < 15000) _factor = 20;
475         else if (_dragonsAmount < 30000) _factor = 10;
476         else _factor = 5;
477 
478         return _hatchingPrice.mul(_factor).div(PERCENT_MULTIPLIER);
479     }
480 
481     function _payGoldReward(
482         address _sender,
483         uint256 _id,
484         uint256 _factor
485     ) internal {
486         uint256 _goldRemain = treasury.remainingGold();
487         uint256 _dragonsAmount = getter.getDragonsAmount();
488         uint32 _coolness;
489         (, , , , , , , _coolness) = getter.getDragonProfile(_id);
490         uint256 _hatchingPrice = treasury.hatchingPrice();
491         // dragon coolness is multyplied by 100
492         uint256 _value = _goldRemain.mul(_coolness).mul(10).div(_dragonsAmount.pow(2)).div(100);
493         _value = _value.mul(_factor).div(GOLD_REWARD_MULTIPLIER);
494 
495         uint256 _maxReward = _getMaxGoldReward(_hatchingPrice, _dragonsAmount);
496         if (_value > _maxReward) _value = _maxReward;
497         if (_value > _goldRemain) _value = _goldRemain;
498         treasury.giveGold(_sender, _value);
499     }
500 
501     struct Opponent {
502         uint256 id;
503         uint256 timestamp;
504         uint32 strength;
505     }
506 
507     function _iterateTimestampIndex(uint8 _index) internal pure returns (uint8) {
508         return _index < 5 ? _index.add(1) : 0;
509     }
510 
511     function _getPercentOfValue(uint32 _value, uint8 _percent) internal pure returns (uint32) {
512         return _value.mul(_percent).div(PERCENT_MULTIPLIER);
513     }
514 
515     function matchOpponents(uint256 _attackerId) external view returns (uint256[6]) {
516         uint32 _attackerStrength = getter.getDragonStrength(_attackerId);
517         uint32 _strengthDiff = _getPercentOfValue(_attackerStrength, DRAGON_STRENGTH_DIFFERENCE_PERCENTAGE);
518         uint32 _minStrength = _attackerStrength.sub(_strengthDiff);
519         uint32 _maxStrength = _attackerStrength.add(_strengthDiff);
520         uint32 _strength;
521         uint256 _timestamp; // usually the date of the last battle
522         uint8 _timestampIndex;
523         uint8 _healthPercentage;
524         uint8 _manaPercentage;
525 
526         address _owner = getter.ownerOfDragon(_attackerId);
527 
528         Opponent[6] memory _opponents;
529         _opponents[0].timestamp =
530         _opponents[1].timestamp =
531         _opponents[2].timestamp =
532         _opponents[3].timestamp =
533         _opponents[4].timestamp =
534         _opponents[5].timestamp = now;
535 
536         for (uint256 _id = 1; _id <= getter.getDragonsAmount(); _id++) { // no dragon with id = 0
537 
538             if (
539                 _attackerId != _id
540                 && !getter.isDragonOwner(_owner, _id)
541                 && !getter.isDragonInGladiatorBattle(_id)
542                 && _isTouchable(_id)
543             ) {
544                 _strength = getter.getDragonStrength(_id);
545                 if (_strength >= _minStrength && _strength <= _maxStrength) {
546 
547                     ( , , _healthPercentage, _manaPercentage) = getter.getDragonCurrentHealthAndMana(_id);
548                     if (_healthPercentage == MAX_PERCENTAGE && _manaPercentage == MAX_PERCENTAGE) {
549 
550                         (_timestamp, , , , ) = getter.getDragonHealthAndMana(_id);
551                         if (_timestamp < _opponents[_timestampIndex].timestamp) {
552 
553                             _opponents[_timestampIndex] = Opponent(_id, _timestamp, _strength);
554                             _timestampIndex = _iterateTimestampIndex(_timestampIndex);
555                         }
556                     }
557                 }
558             }
559         }
560         return [
561             _opponents[0].id,
562             _opponents[1].id,
563             _opponents[2].id,
564             _opponents[3].id,
565             _opponents[4].id,
566             _opponents[5].id
567         ];
568     }
569 
570     function resetDragonBuffs(uint256 _id) external onlyController {
571         core.resetDragonBuffs(_id);
572     }
573 
574     // UPDATE CONTRACT
575 
576     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
577         super.setInternalDependencies(_newDependencies);
578 
579         core = Core(_newDependencies[0]);
580         battle = Battle(_newDependencies[1]);
581         treasury = Treasury(_newDependencies[2]);
582         getter = Getter(_newDependencies[3]);
583         random = Random(_newDependencies[4]);
584     }
585 }