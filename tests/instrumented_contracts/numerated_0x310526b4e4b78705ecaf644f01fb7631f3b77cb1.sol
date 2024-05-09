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
137 contract Gold {
138     function remoteTransfer(address _to, uint256 _value) external;
139 }
140 
141 contract GladiatorBattleStorage {
142     function challengesAmount() external view returns (uint256);
143     function battleOccurred(uint256) external view returns (bool);
144     function challenges(uint256) external view returns (bool, uint256, uint256);
145     function battleBlockNumber(uint256) external view returns (uint256);
146     function creator(uint256) external view returns (address, uint256);
147     function opponent(uint256) external view returns (address, uint256);
148     function winner(uint256) external view returns (address, uint256);
149 }
150 
151 contract GladiatorBattleSpectatorsStorage {
152     function challengeBetsValue(uint256, bool) external view returns (uint256);
153     function challengeBalance(uint256) external view returns (uint256);
154     function challengeBetsAmount(uint256, bool) external view returns (uint256);
155     function betsAmount() external view returns (uint256);
156     function allBets(uint256) external view returns (address, uint256, bool, uint256, bool);
157     function payOut(address, bool, uint256) external;
158     function setChallengeBalance(uint256, uint256) external;
159     function setChallengeBetsAmount(uint256, bool, uint256) external;
160     function setChallengeBetsValue(uint256, bool, uint256) external;
161     function addBet(address, uint256, bool, uint256) external returns (uint256);
162     function deactivateBet(uint256) external;
163     function addChallengeBet(uint256, uint256) external;
164     function removeChallengeBet(uint256, uint256) external;
165     function addUserChallenge(address, uint256, uint256) external;
166     function removeUserChallenge(address, uint256) external;
167     function userChallengeBetId(address, uint256) external view returns (uint256);
168     function challengeWinningBetsAmount(uint256) external view returns (uint256);
169     function setChallengeWinningBetsAmount(uint256, uint256) external;
170     function getUserBet(address, uint256) external view returns (uint256, bool, uint256, bool);
171 }
172 
173 contract GladiatorBattleSpectators is Upgradable {
174     using SafeMath256 for uint256;
175 
176     Gold goldTokens;
177     GladiatorBattleSpectatorsStorage _storage_;
178     GladiatorBattleStorage battleStorage;
179 
180     uint256 constant MULTIPLIER = 10**6; // for more accurate calculations
181 
182     function _safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
183         return b > a ? 0 : a.sub(b);
184     }
185 
186     function _validateChallengeId(uint256 _challengeId) internal view {
187         require(
188             _challengeId > 0 &&
189             _challengeId < battleStorage.challengesAmount(),
190             "wrong challenge id"
191         );
192     }
193 
194     function _validateBetId(uint256 _betId) internal view {
195         require(
196             _betId > 0 &&
197             _betId < _storage_.betsAmount(),
198             "wrong bet id"
199         );
200         ( , , , , bool _active) = _storage_.allBets(_betId);
201         require(_active, "the bet is not active");
202     }
203 
204     function _getChallengeCurrency(
205         uint256 _challengeId
206     ) internal view returns (bool isGold) {
207         (isGold, , ) = battleStorage.challenges(_challengeId);
208     }
209 
210     function _getChallengeBetsAmount(
211         uint256 _challengeId,
212         bool _willCreatorWin
213     ) internal view returns (uint256) {
214         return _storage_.challengeBetsAmount(_challengeId, _willCreatorWin);
215     }
216 
217     function _getChallengeBetsValue(
218         uint256 _challengeId,
219         bool _willCreatorWin
220     ) internal view returns (uint256) {
221         return _storage_.challengeBetsValue(_challengeId, _willCreatorWin);
222     }
223 
224     function _getChallengeBalance(
225         uint256 _challengeId
226     ) internal view returns (uint256) {
227         return _storage_.challengeBalance(_challengeId);
228     }
229 
230     function _setChallengeBetsAmount(
231         uint256 _challengeId,
232         bool _willCreatorWin,
233         uint256 _value
234     ) internal {
235         _storage_.setChallengeBetsAmount(_challengeId, _willCreatorWin, _value);
236     }
237 
238     function _setChallengeBetsValue(
239         uint256 _challengeId,
240         bool _willCreatorWin,
241         uint256 _value
242     ) internal {
243         _storage_.setChallengeBetsValue(_challengeId, _willCreatorWin, _value);
244     }
245 
246     function _setChallengeBalance(
247         uint256 _challengeId,
248         uint256 _value
249     ) internal {
250         _storage_.setChallengeBalance(_challengeId, _value);
251     }
252 
253     function _updateBetsValues(
254         uint256 _challengeId,
255         bool _willCreatorWin,
256         uint256 _value,
257         bool _increase // or decrease
258     ) internal {
259         uint256 _betsAmount = _getChallengeBetsAmount(_challengeId, _willCreatorWin);
260         uint256 _betsValue = _getChallengeBetsValue(_challengeId, _willCreatorWin);
261         uint256 _betsTotalValue = _getChallengeBalance(_challengeId);
262 
263         if (_increase) {
264             _betsAmount = _betsAmount.add(1);
265             _betsValue = _betsValue.add(_value);
266             _betsTotalValue = _betsTotalValue.add(_value);
267         } else {
268             _betsAmount = _betsAmount.sub(1);
269             _betsValue = _betsValue.sub(_value);
270             _betsTotalValue = _betsTotalValue.sub(_value);
271         }
272 
273         _setChallengeBetsAmount(_challengeId, _willCreatorWin, _betsAmount);
274         _setChallengeBetsValue(_challengeId, _willCreatorWin, _betsValue);
275         _setChallengeBalance(_challengeId, _betsTotalValue);
276     }
277 
278     function _checkThatOpponentIsSelected(
279         uint256 _challengeId
280     ) internal view returns (bool) {
281         ( , uint256 _dragonId) = battleStorage.opponent(_challengeId);
282         require(_dragonId != 0, "the opponent is not selected");
283     }
284 
285     function _hasBattleOccurred(uint256 _challengeId) internal view returns (bool) {
286         return battleStorage.battleOccurred(_challengeId);
287     }
288 
289     function _checkThatBattleHasNotOccurred(
290         uint256 _challengeId
291     ) internal view {
292         require(!_hasBattleOccurred(_challengeId), "the battle has already occurred");
293     }
294 
295     function _checkThatBattleHasOccurred(
296         uint256 _challengeId
297     ) internal view {
298         require(_hasBattleOccurred(_challengeId), "the battle has not yet occurred");
299     }
300 
301     function _checkThatWeDoNotKnowTheResult(
302         uint256 _challengeId
303     ) internal view {
304         uint256 _blockNumber = battleStorage.battleBlockNumber(_challengeId);
305         require(
306             _blockNumber > block.number || _blockNumber < _safeSub(block.number, 256),
307             "we already know the result"
308         );
309     }
310 
311     function _isWinningBet(
312         uint256 _challengeId,
313         bool _willCreatorWin
314     ) internal view returns (bool) {
315         (address _winner, ) = battleStorage.winner(_challengeId);
316         (address _creator, ) = battleStorage.creator(_challengeId);
317         bool _isCreatorWinner = _winner == _creator;
318         return _isCreatorWinner == _willCreatorWin;
319     }
320 
321     function _checkWinner(
322         uint256 _challengeId,
323         bool _willCreatorWin
324     ) internal view {
325         require(_isWinningBet(_challengeId, _willCreatorWin), "you did not win the bet");
326     }
327 
328     function _checkThatBetIsActive(bool _active) internal pure {
329         require(_active, "bet is not active");
330     }
331 
332     function _payForBet(
333         uint256 _value,
334         bool _isGold,
335         uint256 _bet
336     ) internal {
337         if (_isGold) {
338             require(_value == 0, "specify isGold as false to send eth");
339             goldTokens.remoteTransfer(address(_storage_), _bet);
340         } else {
341             require(_value == _bet, "wrong eth amount");
342             address(_storage_).transfer(_value);
343         }
344     }
345 
346     function() external payable {}
347 
348     function _create(
349         address _user,
350         uint256 _challengeId,
351         bool _willCreatorWin,
352         uint256 _value
353     ) internal {
354         uint256 _betId = _storage_.addBet(_user, _challengeId, _willCreatorWin, _value);
355         _storage_.addChallengeBet(_challengeId, _betId);
356         _storage_.addUserChallenge(_user, _challengeId, _betId);
357     }
358 
359     function placeBet(
360         address _user,
361         uint256 _challengeId,
362         bool _willCreatorWin,
363         uint256 _value,
364         uint256 _ethValue
365     ) external onlyController returns (bool isGold) {
366         _validateChallengeId(_challengeId);
367         _checkThatOpponentIsSelected(_challengeId);
368         _checkThatBattleHasNotOccurred(_challengeId);
369         _checkThatWeDoNotKnowTheResult(_challengeId);
370         require(_value > 0, "a bet must be more than 0");
371 
372         isGold = _getChallengeCurrency(_challengeId);
373         _payForBet(_ethValue, isGold, _value);
374 
375         uint256 _existingBetId = _storage_.userChallengeBetId(_user, _challengeId);
376         require(_existingBetId == 0, "you have already placed a bet");
377 
378         _create(_user, _challengeId, _willCreatorWin, _value);
379 
380         _updateBetsValues(_challengeId, _willCreatorWin, _value, true);
381     }
382 
383     function _remove(
384         address _user,
385         uint256 _challengeId,
386         uint256 _betId
387     ) internal {
388         _storage_.deactivateBet(_betId);
389         _storage_.removeChallengeBet(_challengeId, _betId);
390         _storage_.removeUserChallenge(_user, _challengeId);
391     }
392 
393     function removeBet(
394         address _user,
395         uint256 _challengeId
396     ) external onlyController {
397         _validateChallengeId(_challengeId);
398 
399         uint256 _betId = _storage_.userChallengeBetId(_user, _challengeId);
400         (
401             address _realUser,
402             uint256 _realChallengeId,
403             bool _willCreatorWin,
404             uint256 _value,
405             bool _active
406         ) = _storage_.allBets(_betId);
407 
408         require(_realUser == _user, "not your bet");
409         require(_realChallengeId == _challengeId, "wrong challenge");
410         _checkThatBetIsActive(_active);
411 
412         if (_hasBattleOccurred(_challengeId)) {
413             require(!_isWinningBet(_challengeId, _willCreatorWin), "request a reward instead");
414             uint256 _opponentBetsAmount = _getChallengeBetsAmount(_challengeId, !_willCreatorWin);
415             require(_opponentBetsAmount == 0, "your bet lost");
416         } else {
417             _checkThatWeDoNotKnowTheResult(_challengeId);
418         }
419 
420         _remove(_user, _challengeId, _betId);
421 
422         bool _isGold = _getChallengeCurrency(_challengeId);
423         _storage_.payOut(_user, _isGold, _value);
424 
425         _updateBetsValues(_challengeId, _willCreatorWin, _value, false);
426     }
427 
428     function _updateWinningBetsAmount(
429         uint256 _challengeId,
430         bool _willCreatorWin
431     ) internal returns (bool) {
432         uint256 _betsAmount = _getChallengeBetsAmount(_challengeId, _willCreatorWin);
433         uint256 _existingWinningBetsAmount = _storage_.challengeWinningBetsAmount(_challengeId);
434         uint256 _winningBetsAmount = _existingWinningBetsAmount == 0 ? _betsAmount : _existingWinningBetsAmount;
435         _winningBetsAmount = _winningBetsAmount.sub(1);
436         _storage_.setChallengeWinningBetsAmount(_challengeId, _winningBetsAmount);
437         return _winningBetsAmount == 0;
438     }
439 
440     function requestReward(
441         address _user,
442         uint256 _challengeId
443     ) external onlyController returns (uint256 reward, bool isGold) {
444         _validateChallengeId(_challengeId);
445         _checkThatBattleHasOccurred(_challengeId);
446         (
447             uint256 _betId,
448             bool _willCreatorWin,
449             uint256 _value,
450             bool _active
451         ) = _storage_.getUserBet(_user, _challengeId);
452         _checkThatBetIsActive(_active);
453 
454         _checkWinner(_challengeId, _willCreatorWin);
455 
456         bool _isLast = _updateWinningBetsAmount(_challengeId, _willCreatorWin);
457 
458         uint256 _betsValue = _getChallengeBetsValue(_challengeId, _willCreatorWin);
459         uint256 _opponentBetsValue = _getChallengeBetsValue(_challengeId, !_willCreatorWin);
460 
461         uint256 _percentage = _value.mul(MULTIPLIER).div(_betsValue);
462         reward = _opponentBetsValue.mul(85).div(100).mul(_percentage).div(MULTIPLIER); // 15% to winner in the battle
463         reward = reward.add(_value);
464 
465         uint256 _challengeBalance = _getChallengeBalance(_challengeId);
466         require(_challengeBalance >= reward, "not enough coins, something went wrong");
467 
468         reward = _isLast ? _challengeBalance : reward; // get rid of inaccuracies of calculations
469 
470         isGold = _getChallengeCurrency(_challengeId);
471         _storage_.payOut(_user, isGold, reward);
472 
473         _setChallengeBalance(_challengeId, _challengeBalance.sub(reward));
474         _storage_.deactivateBet(_betId);
475     }
476 
477 
478     // UPDATE CONTRACT
479 
480     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
481         super.setInternalDependencies(_newDependencies);
482 
483         goldTokens = Gold(_newDependencies[0]);
484         _storage_ = GladiatorBattleSpectatorsStorage(_newDependencies[1]);
485         battleStorage = GladiatorBattleStorage(_newDependencies[2]);
486     }
487 }