1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73    @title ERC827 interface, an extension of ERC20 token standard
74 
75    Interface of a ERC827 token, following the ERC20 standard with extra
76    methods to transfer value and data and execute calls in transfers and
77    approvals.
78  */
79 contract ERC827 is ERC20 {
80 
81   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
82   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
83   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
84 
85 }
86 
87 contract AccessControl {
88     address public ceoAddress;
89     address public cfoAddress;
90     address public cooAddress;
91 
92     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
93     bool public paused = false;
94 
95     /// @dev Access modifier for CEO-only functionality
96     modifier onlyCEO() {
97         require(msg.sender == ceoAddress);
98         _;
99     }
100 
101     /// @dev Access modifier for CFO-only functionality
102     modifier onlyCFO() {
103         require(msg.sender == cfoAddress);
104         _;
105     }
106 
107     /// @dev Access modifier for COO-only functionality
108     modifier onlyCOO() {
109         require(msg.sender == cooAddress);
110         _;
111     }
112 
113     modifier onlyCLevel() {
114         require(
115             msg.sender == cooAddress || 
116             msg.sender == ceoAddress || 
117             msg.sender == cfoAddress
118         );
119         _;
120     }
121 
122     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
123     /// @param _newCEO The address of the new CEO
124     function setCEO(address _newCEO) external onlyCEO {
125         require(_newCEO != address(0));
126 
127         ceoAddress = _newCEO;
128     }
129 
130     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
131     /// @param _newCFO The address of the new CFO
132     function setCFO(address _newCFO) external onlyCEO {
133         require(_newCFO != address(0));
134 
135         cfoAddress = _newCFO;
136     }
137 
138     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
139     /// @param _newCOO The address of the new COO
140     function setCOO(address _newCOO) external onlyCEO {
141         require(_newCOO != address(0));
142 
143         cooAddress = _newCOO;
144     }
145 
146     /*** Pausable functionality adapted from OpenZeppelin ***/
147 
148     /// @dev Modifier to allow actions only when the contract IS NOT paused
149     modifier whenNotPaused() {
150         require(!paused);
151         _;
152     }
153 
154     /// @dev Modifier to allow actions only when the contract IS paused
155     modifier whenPaused {
156         require(paused);
157         _;
158     }
159 
160     /// @dev Called by any "C-level" role to pause the contract. Used only when
161     ///  a bug or exploit is detected and we need to limit damage.
162     function pause() external onlyCLevel whenNotPaused {
163         paused = true;
164     }
165 
166     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
167     ///  one reason we may pause the contract is when CFO or COO accounts are
168     ///  compromised.
169     /// @notice This is public rather than external so it can be called by
170     ///  derived contracts.
171     function unpause() public onlyCEO whenPaused {
172         paused = false;
173     }
174 }
175 
176 interface RandomInterface {
177 
178   function maxRandom() public returns (uint256 randomNumber);
179 
180   function random(uint256 _upper) public returns (uint256 randomNumber);
181 
182   function randomNext(uint256 _seed, uint256 _upper) public pure returns(uint256, uint256);
183 }
184 
185 contract PlayerInterface {
186     function checkOwner(address _owner, uint32[11] _ids) public view returns (bool);
187     function queryPlayerType(uint32[11] _ids) public view returns (uint32[11] playerTypes);
188     function queryPlayer(uint32 _id) public view returns (uint16[8]);
189     function queryPlayerUnAwakeSkillIds(uint32[11] _playerIds) public view returns (uint16[11] playerUnAwakeSkillIds);
190     function tournamentResult(uint32[3][11][32] _playerAwakeSkills) public;
191 }
192 
193 /// @title TournamentBase contract for BS.
194 contract TournamentBase {
195 
196     event Enter(address user, uint256 fee, uint8 defenceCount, uint8 midfieldCount, uint8 forwardCount, uint32[11] playerIds);
197     event CancelEnter(address user);
198     event StartCompetition(uint256 id, uint256 time, address[32] users);
199     event CancelCompetition(uint256 id);
200     event Sponsor(address user, uint256 competitionId, address target, uint256 fee);
201     
202     event Ball(uint256 competitionId, uint8 gameIndex, address user, uint32 playerId, uint8 time);
203     event Battle(uint256 competitionId, uint8 gameIndex, address userA, uint8 scoreA, address userB, uint8 scoreB);
204     event Champion(uint256 competitionId, address user);
205     event EndCompetition(uint256 competitionId, uint256 totalReward, uint256 totalWeight, uint8[32] teamWinCounts);
206 
207     event Reward(uint256 competitionId, address target, uint8 winCount, address user, uint256 sponsorAmount, uint256 amount);
208 
209     uint256 public minEnterFee = 100*(10**18);
210     //uint256 public constant sponsorInterval = 1 hours;
211     uint32[5] public operatingCosts = [100, 100, 120, 160, 240];
212 
213     struct Team {
214       uint256 fees;
215       uint32[11] playerIds;
216       uint16[11] playerAtkWeights;
217       uint128 index;
218       TeamStatus status;
219       uint16 attack;
220       uint16 defense;
221       uint16 stamina;
222     }
223 
224     enum TeamStatus { Normal, Enter, Competition }
225     enum PlayerPosType { GoalKeeper, Defence, Midfield, Forward }
226     enum CompetitionStatus { None, Start, End, Cancel }
227 
228     struct SponsorsInfo {
229         mapping(address => uint256) sponsors;
230         uint256 totalAmount;
231     }
232 
233     struct CompetitionInfo {
234         uint256 totalReward;
235         uint256 totalWeight;
236         uint8[32] teamWinCounts;
237         address[32] users;
238         //uint64 startTime;
239         CompetitionStatus status;
240         uint8 userCount;
241     }
242 
243     mapping (address => Team) public userToTeam;
244     address[] teamUserInfo;
245 
246     uint256 nextCompetitionId;
247     mapping (uint256 => CompetitionInfo) public competitionInfos;
248     mapping (uint256 => mapping (uint256 => SponsorsInfo)) public sponsorInfos;
249 
250     PlayerInterface bsCoreContract;
251     RandomInterface randomContract;
252     ERC827 public joyTokenContract;
253 }
254 
255 contract PlayerSkill {
256     enum SkillType { Undefined, WinGamesInOneTournament, ScoreInOneGame, ScoreInOneTournament, 
257         FanOfPlayerID, ChampionWithPlayerID, HattricksInOneTuournament, Terminator,
258         LonelyKiller, VictoryBringer, Saver, ICanDoBetterTournament, ICanDoBetter, 
259         LearnFromFailure, LearnFromFailureTournament}
260 
261     struct SkillConfig {
262         SkillType skillType;
263         uint32 target;
264         uint8 addAttri;
265     }
266 
267     function _getSkill(uint16 skillId) internal pure returns(uint16, uint16) {
268         return (skillId >> 2, (skillId & 0x03));
269     }
270 
271     function triggerSkill(uint32[11][32] _playerIds, uint8[32] _teamWinCounts, uint8[4][31] _gameScores,
272             uint8[3][3][31] _gameBalls, uint8[5][11][32] _playerBalls, uint16[11][32] _playerUnAwakeSkillIds,
273             uint32[3][11][32] _playerAwakeSkills) internal pure {
274 
275         SkillConfig[35] memory skillConfigs = _getSkillConfigs();
276         for (uint8 i = 0; i < 32; i++) {
277             for (uint8 j = 0; j < 11; j++) {
278                 uint16 skillId = _playerUnAwakeSkillIds[i][j];
279                 if (skillId > 0) {
280                     uint16 addAttriType;
281                     (skillId, addAttriType) = _getSkill(skillId);
282                     SkillConfig memory skillConfig = skillConfigs[skillId];
283 
284                     if (skillConfig.skillType != SkillType.Undefined) {
285                         if (_triggerSkill(skillConfig, i, j, _teamWinCounts, _gameScores, _gameBalls, _playerBalls)){
286                             _playerAwakeSkills[i][j][0] = _playerIds[i][j];
287                             _playerAwakeSkills[i][j][1] = addAttriType;
288                             _playerAwakeSkills[i][j][2] = skillConfig.addAttri;
289                         }
290                     }
291                 }
292             }
293         }
294     }
295 
296     function _getSkillConfigs() internal pure returns(SkillConfig[35]) {
297         return [
298             SkillConfig(SkillType.Undefined, 0, 0),
299             SkillConfig(SkillType.WinGamesInOneTournament,1,1),
300             SkillConfig(SkillType.WinGamesInOneTournament,2,2),
301             SkillConfig(SkillType.WinGamesInOneTournament,3,3),
302             SkillConfig(SkillType.WinGamesInOneTournament,4,4),
303             SkillConfig(SkillType.WinGamesInOneTournament,5,5),
304             SkillConfig(SkillType.ScoreInOneGame,1,1),
305             SkillConfig(SkillType.ScoreInOneGame,2,3),
306             SkillConfig(SkillType.ScoreInOneGame,3,5),
307             SkillConfig(SkillType.ScoreInOneGame,4,7),
308             SkillConfig(SkillType.ScoreInOneGame,5,10),
309             SkillConfig(SkillType.ScoreInOneTournament,10,3),
310             SkillConfig(SkillType.ScoreInOneTournament,13,4),
311             SkillConfig(SkillType.ScoreInOneTournament,16,5),
312             SkillConfig(SkillType.ScoreInOneTournament,20,8),
313             SkillConfig(SkillType.VictoryBringer,1,4),
314             SkillConfig(SkillType.VictoryBringer,3,6),
315             SkillConfig(SkillType.VictoryBringer,5,8),
316             SkillConfig(SkillType.Saver,1,5),
317             SkillConfig(SkillType.Saver,3,7),
318             SkillConfig(SkillType.Saver,5,10),
319             SkillConfig(SkillType.HattricksInOneTuournament,1,3),
320             SkillConfig(SkillType.HattricksInOneTuournament,3,6),
321             SkillConfig(SkillType.HattricksInOneTuournament,5,10),
322             SkillConfig(SkillType.Terminator,1,5),
323             SkillConfig(SkillType.Terminator,3,8),
324             SkillConfig(SkillType.Terminator,5,12),
325             SkillConfig(SkillType.LonelyKiller,1,5),
326             SkillConfig(SkillType.LonelyKiller,3,7),
327             SkillConfig(SkillType.LonelyKiller,5,10),
328             SkillConfig(SkillType.ICanDoBetterTournament,15,0),
329             SkillConfig(SkillType.ICanDoBetter,5,0),
330             SkillConfig(SkillType.LearnFromFailure,5,5),
331             SkillConfig(SkillType.LearnFromFailureTournament,15,8),
332             SkillConfig(SkillType.ChampionWithPlayerID,0,5)
333         ];
334     }
335 
336     function _triggerSkill(SkillConfig memory _skillConfig, uint8 _teamIndex, uint8 _playerIndex,
337             uint8[32] _teamWinCounts, uint8[4][31] _gameScores, uint8[3][3][31] _gameBalls,
338             uint8[5][11][32] _playerBalls) internal pure returns(bool) {
339 
340         uint256 i;
341         uint256 accumulateValue = 0;
342         if (SkillType.WinGamesInOneTournament == _skillConfig.skillType) {
343             return _teamWinCounts[_teamIndex] >= _skillConfig.target;
344         }
345 
346         if (SkillType.ScoreInOneGame == _skillConfig.skillType) {
347             for (i = 0; i < 5; i++) {
348                 if (_playerBalls[_teamIndex][_playerIndex][i] >= _skillConfig.target) {
349                     return true;
350                 }
351             }
352             return false;
353         }
354 
355         if (SkillType.ScoreInOneTournament == _skillConfig.skillType) {
356             for (i = 0; i < 5; i++) {
357                 accumulateValue += _playerBalls[_teamIndex][_playerIndex][i];
358             }
359             return accumulateValue >= _skillConfig.target;
360         }
361 
362 
363 /*         if (SkillType.ChampionWithPlayerID == _skillConfig.skillType) {
364             if (_teamWinCounts[_teamIndex] >= 5) {
365                 for (i = 0; i < 11; i++) {
366                     if (_playerIds[i] == _skillConfig.target) {
367                         return true;
368                     }
369                 }
370             }
371             return false;
372         } */
373 
374         if (SkillType.HattricksInOneTuournament == _skillConfig.skillType) {
375             for (i = 0; i < 5; i++) {
376                 if (_playerBalls[_teamIndex][_playerIndex][i] >= 3) {
377                     accumulateValue++;
378                 }
379             }
380 
381             return accumulateValue >= _skillConfig.target;
382         }
383 
384         if (SkillType.Terminator == _skillConfig.skillType) {
385             for (i = 0; i < 31; i++) {
386                 if ((_gameScores[i][0] == _teamIndex && _gameScores[i][2] == _gameScores[i][3]+1)
387                     || (_gameScores[i][1] == _teamIndex && _gameScores[i][2]+1 == _gameScores[i][3])) {
388                     if (_gameBalls[i][2][1] == _teamIndex && _gameBalls[i][2][2] == _playerIndex) {
389                         accumulateValue++;
390                     }
391                 }
392             }
393 
394             return accumulateValue >= _skillConfig.target;
395         }
396 
397         if (SkillType.LonelyKiller == _skillConfig.skillType) {
398             for (i = 0; i < 31; i++) {
399                 if ((_gameScores[i][0] == _teamIndex && _gameScores[i][2] == 1 && _gameScores[i][3] == 0)
400                     || (_gameScores[i][1] == _teamIndex && _gameScores[i][2] == 0 && _gameScores[i][3] == 1)) {
401                     if (_gameBalls[i][2][1] == _teamIndex && _gameBalls[i][2][2] == _playerIndex) {
402                         accumulateValue++;
403                     }
404                 }
405             }
406 
407             return accumulateValue >= _skillConfig.target;
408         }
409 
410         if (SkillType.VictoryBringer == _skillConfig.skillType) {
411             for (i = 0; i < 31; i++) {
412                 if ((_gameScores[i][0] == _teamIndex && _gameScores[i][2] > _gameScores[i][3])
413                     || (_gameScores[i][1] == _teamIndex && _gameScores[i][2] < _gameScores[i][3])) {
414                     if (_gameBalls[i][0][1] == _teamIndex && _gameBalls[i][0][2] == _playerIndex) {
415                         accumulateValue++;
416                     }
417                 }
418             }
419 
420             return accumulateValue >= _skillConfig.target;
421         }
422 
423         if (SkillType.Saver == _skillConfig.skillType) {
424             for (i = 0; i < 31; i++) {
425                 if (_gameBalls[i][1][1] == _teamIndex && _gameBalls[i][1][2] == _playerIndex) {
426                     accumulateValue++;
427                 }
428             }
429             return accumulateValue >= _skillConfig.target;
430         }
431 
432         if (SkillType.ICanDoBetterTournament == _skillConfig.skillType) {
433             for (i = 0; i < 31; i++) {
434                 if (_gameScores[i][0] == _teamIndex) {
435                     accumulateValue += _gameScores[i][3];
436                 }
437 
438                 if (_gameScores[i][1] == _teamIndex) {
439                     accumulateValue += _gameScores[i][2];
440                 }
441             }
442             return accumulateValue >= _skillConfig.target;
443         }
444 
445         if (SkillType.ICanDoBetter == _skillConfig.skillType) {
446             for (i = 0; i < 31; i++) {
447                 if ((_gameScores[i][0] == _teamIndex && _gameScores[i][3] >= _skillConfig.target)
448                     || (_gameScores[i][1] == _teamIndex && _gameScores[i][2] >= _skillConfig.target)) {
449                     return true;
450                 }
451             }
452             return false;
453         }
454 
455         if (SkillType.LearnFromFailure == _skillConfig.skillType && _teamIndex == 0) {
456             for (i = 0; i < 31; i++) {
457                 if ((_gameScores[i][0] == _teamIndex && _gameScores[i][3] >= _skillConfig.target)
458                     || (_gameScores[i][1] == _teamIndex && _gameScores[i][2] >= _skillConfig.target)) {
459                     return true;
460                 }
461             }
462             return false;
463         }
464 
465         if (SkillType.LearnFromFailureTournament == _skillConfig.skillType && _teamIndex == 0) {
466             for (i = 0; i < 31; i++) {
467                 if (_gameScores[i][0] == _teamIndex) {
468                     accumulateValue += _gameScores[i][3];
469                 }
470 
471                 if (_gameScores[i][1] == _teamIndex) {
472                     accumulateValue += _gameScores[i][2];
473                 }
474             }
475             return accumulateValue >= _skillConfig.target;
476         }
477     }
478 }
479 
480 contract TournamentCompetition is TournamentBase, PlayerSkill {
481 
482     uint256 constant rangeParam = 90;
483     uint256 constant halfBattleMinutes = 45;
484     uint256 constant minBattleMinutes = 2;
485 
486     struct BattleTeam {
487         uint16[11] playerAtkWeights;
488         uint16 attack;
489         uint16 defense;
490         uint16 stamina;
491     }
492     struct BattleInfo {
493         uint256 competitionId;
494         uint256 seed;
495         uint256 maxRangeA;
496         uint256 maxRangeB;
497         uint8[32] teamIndexs;
498         BattleTeam[32] teamInfos;
499         uint32[11][32] allPlayerIds;
500         address addressA;
501         address addressB;
502         uint8 roundIndex;
503         uint8 gameIndex;
504         uint8 teamLength;
505         uint8 indexA;
506         uint8 indexB;
507     }
508 
509     function competition(uint256 _competitionId, CompetitionInfo storage ci, uint8[32] _teamWinCounts, uint32[3][11][32] _playerAwakeSkills) internal {
510         uint8[4][31] memory gameScores;
511         uint8[3][3][31] memory gameBalls;
512         uint8[5][11][32] memory playerBalls;
513         uint16[11][32] memory playerUnAwakeSkillIds;
514 
515         BattleInfo memory battleInfo;
516         battleInfo.competitionId = _competitionId;
517         battleInfo.seed = randomContract.maxRandom();
518         battleInfo.teamLength = uint8(ci.userCount);
519         for (uint8 i = 0; i < battleInfo.teamLength; i++) {
520             battleInfo.teamIndexs[i] = i;
521         }
522 
523         _queryBattleInfo(ci, battleInfo, playerUnAwakeSkillIds);
524         while (battleInfo.teamLength > 1) {
525             _battle(ci, battleInfo, gameScores, gameBalls, playerBalls);
526             for (i = 0; i < battleInfo.teamLength; i++) {
527                 _teamWinCounts[battleInfo.teamIndexs[i]] += 1;
528             }
529         }
530         address winner = ci.users[battleInfo.teamIndexs[0]];
531         Champion(_competitionId, winner);
532 
533         triggerSkill(battleInfo.allPlayerIds, _teamWinCounts, gameScores, 
534             gameBalls, playerBalls, playerUnAwakeSkillIds, _playerAwakeSkills);
535     }
536 
537     function _queryBattleInfo(CompetitionInfo storage ci, BattleInfo memory _battleInfo, uint16[11][32] memory _playerUnAwakeSkillIds) internal view {
538         for (uint8 i = 0; i < _battleInfo.teamLength; i++) {
539 
540             Team storage team = userToTeam[ci.users[i]];
541             _battleInfo.allPlayerIds[i] = team.playerIds;
542 
543             _battleInfo.teamInfos[i].playerAtkWeights = team.playerAtkWeights;
544             _battleInfo.teamInfos[i].attack = team.attack;
545             _battleInfo.teamInfos[i].defense = team.defense;
546             _battleInfo.teamInfos[i].stamina = team.stamina;
547 
548             _playerUnAwakeSkillIds[i] = bsCoreContract.queryPlayerUnAwakeSkillIds(_battleInfo.allPlayerIds[i]);
549 
550             // uint256[3] memory teamAttrs;
551             // (teamAttrs, _battleInfo.teamInfos[i].playerAtkWeights) = _calTeamAttribute(ci.users[i], team.defenceCount, team.midfieldCount, team.forwardCount, _battleInfo.allPlayerIds[i]);   
552 
553             // _battleInfo.teamInfos[i].attack = uint16(teamAttrs[0]);
554             // _battleInfo.teamInfos[i].defense = uint16(teamAttrs[1]);
555             // _battleInfo.teamInfos[i].stamina = uint16(teamAttrs[2]);
556         }
557     }
558 
559     function _battle(CompetitionInfo storage _ci, BattleInfo _battleInfo, uint8[4][31] _gameScores,
560             uint8[3][3][31] _gameBalls, uint8[5][11][32] _playerBalls) internal {
561         uint8 resultTeamLength = 0;
562         for (uint8 i = 0; i < _battleInfo.teamLength; i+=2) {
563             uint8 a = _battleInfo.teamIndexs[i];
564             uint8 b = _battleInfo.teamIndexs[i+1];
565             uint8 scoreA;
566             uint8 scoreB;
567             _battleInfo.indexA = a;
568             _battleInfo.indexB = b;
569             _battleInfo.addressA = _ci.users[a];
570             _battleInfo.addressB = _ci.users[b];
571             (scoreA, scoreB) = _battleTeam(_battleInfo, _gameScores, _gameBalls, _playerBalls);
572             if (scoreA > scoreB) {
573                 _battleInfo.teamIndexs[resultTeamLength++] = a;
574             } else {
575                 _battleInfo.teamIndexs[resultTeamLength++] = b;
576             }
577             Battle(_battleInfo.competitionId, _battleInfo.gameIndex, _battleInfo.addressA, scoreA, _battleInfo.addressB, scoreB);
578         }
579 
580         _battleInfo.roundIndex++;
581         _battleInfo.teamLength = resultTeamLength;
582     }
583 
584     function _battleTeam(BattleInfo _battleInfo, uint8[4][31] _gameScores, uint8[3][3][31] _gameBalls, 
585             uint8[5][11][32] _playerBalls) internal returns (uint8 scoreA, uint8 scoreB) {
586         BattleTeam memory _aTeam = _battleInfo.teamInfos[_battleInfo.indexA];
587         BattleTeam memory _bTeam = _battleInfo.teamInfos[_battleInfo.indexB];
588         _battleInfo.maxRangeA = 5 + rangeParam*_bTeam.defense/_aTeam.attack;
589         _battleInfo.maxRangeB = 5 + rangeParam*_aTeam.defense/_bTeam.attack;
590         //DebugRange(_a, _b, _aTeam.attack, _aTeam.defense, _aTeam.stamina, _bTeam.attack, _bTeam.defense, _bTeam.stamina, maxRangeA, maxRangeB);
591         //DebugRange2(maxRangeA, maxRangeB);
592         _battleScore(_battleInfo, 0, _playerBalls, _gameBalls);
593 
594         _battleInfo.maxRangeA = 5 + rangeParam*(uint256(_bTeam.defense)*uint256(_bTeam.stamina)*(100+uint256(_aTeam.stamina)))/(uint256(_aTeam.attack)*uint256(_aTeam.stamina)*(100+uint256(_bTeam.stamina)));
595         _battleInfo.maxRangeB = 5 + rangeParam*(uint256(_aTeam.defense)*uint256(_aTeam.stamina)*(100+uint256(_bTeam.stamina)))/(uint256(_bTeam.attack)*uint256(_bTeam.stamina)*(100+uint256(_aTeam.stamina)));
596         //DebugRange2(maxRangeA, maxRangeB);
597         _battleScore(_battleInfo, halfBattleMinutes, _playerBalls, _gameBalls);
598 
599         uint8 i = 0;
600         for (i = 0; i < 11; i++) {
601             scoreA += _playerBalls[_battleInfo.indexA][i][_battleInfo.roundIndex];
602             scoreB += _playerBalls[_battleInfo.indexB][i][_battleInfo.roundIndex];
603         }
604         if (scoreA == scoreB) {
605             _battleInfo.maxRangeA = 5 + rangeParam * (uint256(_bTeam.defense)*uint256(_bTeam.stamina)*uint256(_bTeam.stamina)*(100+uint256(_aTeam.stamina))*(100+uint256(_aTeam.stamina)))/(uint256(_aTeam.attack)*uint256(_aTeam.stamina)*uint256(_aTeam.stamina)*(100+uint256(_bTeam.stamina))*(100+uint256(_bTeam.stamina)));
606             _battleInfo.maxRangeB = 5 + rangeParam * (uint256(_aTeam.defense)*uint256(_aTeam.stamina)*uint256(_aTeam.stamina)*(100+uint256(_bTeam.stamina))*(100+uint256(_bTeam.stamina)))/(uint256(_bTeam.attack)*uint256(_bTeam.stamina)*uint256(_bTeam.stamina)*(100+uint256(_aTeam.stamina))*(100+uint256(_aTeam.stamina)));
607             //DebugRange2(maxRangeA, maxRangeB);
608             (scoreA, scoreB) = _battleOvertimeScore(_battleInfo, scoreA, scoreB, _playerBalls, _gameBalls);
609         }
610 
611         _gameScores[_battleInfo.gameIndex][0] = _battleInfo.indexA;
612         _gameScores[_battleInfo.gameIndex][1] = _battleInfo.indexB;
613         _gameScores[_battleInfo.gameIndex][2] = scoreA;
614         _gameScores[_battleInfo.gameIndex][3] = scoreB;
615         _battleInfo.gameIndex++;
616     }
617 
618     function _battleScore(BattleInfo _battleInfo, uint256 _timeoffset, uint8[5][11][32] _playerBalls, uint8[3][3][31] _gameBalls) internal {
619         uint256 _battleMinutes = 0;
620         while (_battleMinutes < halfBattleMinutes - minBattleMinutes) {
621             bool isAWin;
622             uint256 scoreTime;
623             uint8 index;
624             (isAWin, scoreTime) = _battleOneScore(_battleInfo);
625             _battleMinutes += scoreTime;
626             if (_battleMinutes <= halfBattleMinutes) {
627                 uint8 teamIndex;
628                 address addressWin;
629 
630                 if (isAWin) {
631                     teamIndex = _battleInfo.indexA;
632                     addressWin = _battleInfo.addressA;
633                 } else {
634                     teamIndex = _battleInfo.indexB;
635                     addressWin = _battleInfo.addressB;
636                 }
637 
638                 (_battleInfo.seed, index) = _randBall(_battleInfo.seed, _battleInfo.teamInfos[teamIndex].playerAtkWeights);
639                 uint32 playerId = _battleInfo.allPlayerIds[teamIndex][index];
640                 Ball(_battleInfo.competitionId, _battleInfo.gameIndex+1, addressWin, playerId, uint8(_timeoffset+_battleMinutes));
641                 _playerBalls[teamIndex][index][_battleInfo.roundIndex]++;
642                 _onBall(_battleInfo.gameIndex, teamIndex, index, uint8(_timeoffset+_battleMinutes), _gameBalls);
643             }
644         }
645     }
646 
647     function _battleOneScore(BattleInfo _battleInfo) internal view returns(bool, uint256) {
648         uint256 tA;
649         (_battleInfo.seed, tA) = randomContract.randomNext(_battleInfo.seed, _battleInfo.maxRangeA-minBattleMinutes+1);
650         tA += minBattleMinutes;
651         uint256 tB;
652         (_battleInfo.seed, tB) = randomContract.randomNext(_battleInfo.seed, _battleInfo.maxRangeB-minBattleMinutes+1);
653         tB += minBattleMinutes;
654         if (tA < tB || (tA == tB && _battleInfo.seed % 2 == 0)) {
655            return (true, tA);
656         } else {
657            return (false, tB);
658         }
659     }
660 
661     function _randBall(uint256 _seed, uint16[11] memory _atkWeight) internal view returns(uint256, uint8) {
662         uint256 rand;
663         (_seed, rand) = randomContract.randomNext(_seed, _atkWeight[_atkWeight.length-1]);
664         rand += 1;
665         for (uint8 i = 0; i < _atkWeight.length; i++) {
666             if (_atkWeight[i] >= rand) {
667                 return (_seed, i);
668             }
669         }
670     }
671 
672     function _onBall(uint8 _gameIndex, uint8 _teamIndex, uint8 _playerIndex, uint8 _time, uint8[3][3][31] _gameBalls) internal pure {
673         if (_gameBalls[_gameIndex][0][0] == 0) {
674             _gameBalls[_gameIndex][0][0] = _time;
675             _gameBalls[_gameIndex][0][1] = _teamIndex;
676             _gameBalls[_gameIndex][0][2] = _playerIndex;
677         }
678 
679         _gameBalls[_gameIndex][2][0] = _time;
680         _gameBalls[_gameIndex][2][1] = _teamIndex;
681         _gameBalls[_gameIndex][2][2] = _playerIndex;
682     }
683 
684     function _onOverTimeBall(uint8 _gameIndex, uint8 _teamIndex, uint8 _playerIndex, uint8 _time, uint8[3][3][31] _gameBalls) internal pure {
685         _gameBalls[_gameIndex][1][0] = _time;
686         _gameBalls[_gameIndex][1][1] = _teamIndex;
687         _gameBalls[_gameIndex][1][2] = _playerIndex;
688     }
689 
690     function _battleOvertimeScore(BattleInfo _battleInfo, uint8 _scoreA, uint8 _scoreB,
691             uint8[5][11][32] _playerBalls, uint8[3][3][31] _gameBalls) internal returns(uint8 scoreA, uint8 scoreB) {
692         bool isAWin;
693         uint8 index;
694         uint256 scoreTime;
695         (isAWin, scoreTime) = _battleOneScore(_battleInfo);
696         scoreTime = scoreTime % 30 + 90;
697         uint8 teamIndex;
698         address addressWin;
699         if (isAWin) {
700             teamIndex = _battleInfo.indexA;
701             scoreA = _scoreA + 1;
702             scoreB = _scoreB;
703 
704             addressWin = _battleInfo.addressA;
705         } else {
706             teamIndex = _battleInfo.indexB;
707             scoreA = _scoreA;
708             scoreB = _scoreB + 1;
709 
710             addressWin = _battleInfo.addressB;
711         }
712 
713         (_battleInfo.seed, index) = _randBall(_battleInfo.seed, _battleInfo.teamInfos[teamIndex].playerAtkWeights);
714         uint32 playerId = _battleInfo.allPlayerIds[teamIndex][index];
715         Ball(_battleInfo.competitionId, _battleInfo.gameIndex+1, addressWin, playerId, uint8(scoreTime));
716         _playerBalls[teamIndex][index][_battleInfo.roundIndex]++;
717 
718         _onBall(_battleInfo.gameIndex, teamIndex, index, uint8(scoreTime), _gameBalls);
719         _onOverTimeBall(_battleInfo.gameIndex, teamIndex, index, uint8(scoreTime), _gameBalls);
720     }
721 }
722 
723 contract TournamentInterface {
724     /// @dev simply a boolean to indicate this is the contract we expect to be
725     function isTournament() public pure returns (bool);
726     function isPlayerIdle(address _owner, uint256 _playerId) public view returns (bool);
727 }
728 
729 /// @title Tournament contract for BS.
730 contract TournamentCore is TournamentInterface, TournamentCompetition, AccessControl {
731 
732     using SafeMath for uint256;
733     function TournamentCore(address _joyTokenContract, address _bsCoreContract, address _randomAddress, address _CFOAddress) public {
734 
735         // the creator of the contract is the initial CEO
736         ceoAddress = msg.sender;
737 
738         // the creator of the contract is also the initial COO
739         cooAddress = msg.sender;
740 
741         cfoAddress = _CFOAddress;
742 
743         randomContract = RandomInterface(_randomAddress);
744 
745         joyTokenContract = ERC827(_joyTokenContract);
746         bsCoreContract = PlayerInterface(_bsCoreContract);
747 
748         nextCompetitionId = 1;
749     }
750 
751     function isTournament() public pure returns (bool) {
752         return true;
753     }
754 
755     function setMinEnterFee(uint256 minFee) external onlyCEO {
756         minEnterFee = minFee;
757     }
758 
759     function setOperatingCost(uint32[5] costs) external onlyCEO {
760         operatingCosts = costs;
761     }
762 
763     function getOperationCost(uint256 teamCount) public view returns (uint256) {
764         uint256 cost = 0;
765         if (teamCount <= 2) {
766             cost = operatingCosts[0];
767         } else if(teamCount <= 4) {
768             cost = operatingCosts[1];
769         } else if(teamCount <= 8) {
770             cost = operatingCosts[2];
771         } else if(teamCount <= 16) {
772             cost = operatingCosts[3];
773         } else {
774             cost = operatingCosts[4];
775         }
776         return cost.mul(10**18);
777     }
778 
779     function isPlayerIdle(address _owner, uint256 _playerId) public view returns (bool) {
780         Team storage teamInfo = userToTeam[_owner];
781         for (uint256 i = 0; i < teamInfo.playerIds.length; i++) {
782             if (teamInfo.playerIds[i] == _playerId) {
783                 return false;
784             }
785         }
786 
787         return true;
788     }
789 
790     function enter(address _sender, uint256 _fees, uint8 _defenceCount, uint8 _midfieldCount, uint8 _forwardCount,
791             uint32[11] _playerIds) external whenNotPaused {
792         require(_fees >= minEnterFee);
793         require(_playerIds.length == 11);
794         require(_defenceCount >= 1 && _defenceCount <= 5);
795         require(_midfieldCount >= 1 && _midfieldCount <= 5);
796         require(_forwardCount >= 1 && _forwardCount <= 5);
797         require(_defenceCount + _midfieldCount + _forwardCount == 10);
798 
799         require(msg.sender == address(joyTokenContract) || msg.sender == _sender);
800 
801         require(joyTokenContract.transferFrom(_sender, address(this), _fees));
802 
803         uint32[11] memory ids = _playerIds;
804         _insertSortMemory(ids);
805         for (uint256 i = 0; i < 11 - 1; i++) {
806             require(ids[i] < ids[i + 1]);
807         }
808 
809         require(bsCoreContract.checkOwner(_sender, _playerIds));
810         uint32[11] memory playerTypes = bsCoreContract.queryPlayerType(_playerIds);
811         _insertSortMemory(playerTypes);
812         for (i = 0; i < 11 - 1; i++) {
813             if (playerTypes[i] > 0) {
814                 break;
815             }
816         }
817         for (; i < 11 - 1; i++) {
818             require(playerTypes[i] < playerTypes[i + 1]);
819         }
820 
821         Team storage teamInfo = userToTeam[_sender];
822         require(teamInfo.status == TeamStatus.Normal);
823         enterInner(_sender, _fees, _defenceCount, _midfieldCount, _forwardCount, _playerIds, teamInfo);
824 
825         Enter(_sender, _fees, _defenceCount, _midfieldCount, _forwardCount, _playerIds);
826     }
827 
828     function cancelEnter(address _user) external onlyCOO {
829         Team storage teamInfo = userToTeam[_user];
830         require(teamInfo.status == TeamStatus.Enter);
831         uint256 fees = teamInfo.fees;
832         uint128 index = teamInfo.index;
833         require(teamUserInfo[index-1] == _user);
834         if (index < teamUserInfo.length) {
835             address user = teamUserInfo[teamUserInfo.length-1];
836             teamUserInfo[index-1] = user;
837             userToTeam[user].index = index;
838         }
839         teamUserInfo.length--;
840         delete userToTeam[_user];
841 
842         require(joyTokenContract.transfer(_user, fees));
843         CancelEnter(_user);
844     }
845 
846     function cancelAllEnter() external onlyCOO {
847         for (uint256 i = 0; i < teamUserInfo.length; i++) {
848             address user = teamUserInfo[i];
849             Team storage teamInfo = userToTeam[user];
850             require(teamInfo.status == TeamStatus.Enter);
851             uint256 fees = teamInfo.fees;
852 
853             // uint256 index = teamInfo.index;
854             // require(teamUserInfo[index-1] == user);
855 
856             delete userToTeam[user];
857 
858             require(joyTokenContract.transfer(user, fees));
859             CancelEnter(user);
860         }
861         teamUserInfo.length = 0;
862     }
863 
864     function enterInner(address _sender, uint256 _value, uint8 _defenceCount, uint8 _midfieldCount, uint8 _forwardCount,
865         uint32[11] _playerIds, Team storage _teamInfo) internal {
866 
867         uint16[11] memory playerAtkWeights;
868         uint256[3] memory teamAttrs;
869         (teamAttrs, playerAtkWeights) = _calTeamAttribute(_defenceCount, _midfieldCount, _forwardCount, _playerIds);
870         uint256 teamIdx = teamUserInfo.length++;
871         teamUserInfo[teamIdx] = _sender;
872         _teamInfo.status = TeamStatus.Enter;
873 
874         require((teamIdx + 1) == uint256(uint128(teamIdx + 1)));
875         _teamInfo.index = uint128(teamIdx + 1);
876 
877         _teamInfo.attack = uint16(teamAttrs[0]);
878         _teamInfo.defense = uint16(teamAttrs[1]);
879         _teamInfo.stamina = uint16(teamAttrs[2]);
880 
881         _teamInfo.playerIds = _playerIds;
882         _teamInfo.playerAtkWeights = playerAtkWeights;
883 
884         _teamInfo.fees = _value;
885     }
886 
887     function getTeamAttribute(uint8 _defenceCount, uint8 _midfieldCount, uint8 _forwardCount,
888         uint32[11] _playerIds) external view returns (uint256 attack, uint256 defense, uint256 stamina) {
889         uint256[3] memory teamAttrs;
890         uint16[11] memory playerAtkWeights;
891         (teamAttrs, playerAtkWeights) = _calTeamAttribute(_defenceCount, _midfieldCount, _forwardCount, _playerIds);
892         attack = teamAttrs[0];
893         defense = teamAttrs[1];
894         stamina = teamAttrs[2];
895     }
896 
897     function _calTeamAttribute(uint8 _defenceCount, uint8 _midfieldCount, uint8 _forwardCount,
898         uint32[11] _playerIds) internal view returns (uint256[3] _attrs, uint16[11] _playerAtkWeights) {
899 
900         uint256[3][11] memory playerAttrs;
901 
902         _getAttribute(_playerIds, 0, PlayerPosType.GoalKeeper, 1, 0, playerAttrs);
903         uint8 startIndex = 1;
904         uint8 i;
905         for (i = startIndex; i < startIndex + _defenceCount; i++) {
906             _getAttribute(_playerIds, i, PlayerPosType.Defence, _defenceCount, i - startIndex, playerAttrs);
907         }
908         startIndex = startIndex + _defenceCount;
909         for (i = startIndex; i < startIndex + _midfieldCount; i++) {
910             _getAttribute(_playerIds, i, PlayerPosType.Midfield, _midfieldCount, i - startIndex, playerAttrs);
911         }
912         startIndex = startIndex + _midfieldCount;
913         for (i = startIndex; i < startIndex + _forwardCount; i++) {
914             _getAttribute(_playerIds, i, PlayerPosType.Forward, _forwardCount, i - startIndex, playerAttrs);
915         }
916 
917         uint16 lastAtkWeight = 0;
918         for (i = 0; i < _playerIds.length; i++) {
919             _attrs[0] += playerAttrs[i][0];
920             _attrs[1] += playerAttrs[i][1];
921             _attrs[2] += playerAttrs[i][2];
922             _playerAtkWeights[i] = uint16(lastAtkWeight + playerAttrs[i][0] / 10000);
923             lastAtkWeight = _playerAtkWeights[i];
924         }
925 
926         _attrs[0] /= 10000;
927         _attrs[1] /= 10000;
928         _attrs[2] /= 10000;
929     }
930 
931     function _getAttribute(uint32[11] _playerIds, uint8 _i, PlayerPosType _type, uint8 _typeSize, uint8 _typeIndex, uint256[3][11] playerAttrs)
932     internal view {
933         uint8 xPos;
934         uint8 yPos;
935         (xPos, yPos) = _getPos(_type, _typeSize, _typeIndex);
936 
937         uint16[8] memory a = bsCoreContract.queryPlayer(_playerIds[_i]);
938         uint256 aWeight;
939         uint256 dWeight;
940         (aWeight, dWeight) = _getWeight(yPos);
941         uint256 sWeight = 100 - aWeight - dWeight;
942         if (_type == PlayerPosType.GoalKeeper && a[5] == 1) {
943             dWeight += dWeight;
944         }
945         uint256 xWeight = 50;
946         if (xPos + 1 >= a[4] && xPos <= a[4] + 1) {
947             xWeight = 100;
948         }
949         playerAttrs[_i][0] = (a[1] * aWeight * xWeight);
950         playerAttrs[_i][1] = (a[2] * dWeight * xWeight);
951         playerAttrs[_i][2] = (a[3] * sWeight * xWeight);
952     }
953 
954     function _getWeight(uint256 yPos) internal pure returns (uint256, uint256) {
955         if (yPos == 0) {
956             return (5, 90);
957         }
958         if (yPos == 1) {
959             return (10, 80);
960         }
961         if (yPos == 2) {
962             return (10, 70);
963         }
964         if (yPos == 3) {
965             return (10, 60);
966         }
967         if (yPos == 4) {
968             return (20, 30);
969         }
970         if (yPos == 5) {
971             return (20, 20);
972         }
973         if (yPos == 6) {
974             return (30, 20);
975         }
976         if (yPos == 7) {
977             return (60, 10);
978         }
979         if (yPos == 8) {
980             return (70, 10);
981         }
982         if (yPos == 9) {
983             return (80, 10);
984         }
985     }
986 
987     function _getPos(PlayerPosType _type, uint8 _size, uint8 _index) internal pure returns (uint8, uint8) {
988         uint8 yPosOffset = 0;
989         if (_type == PlayerPosType.GoalKeeper) {
990             return (3, 0);
991         }
992         if (_type == PlayerPosType.Midfield) {
993             yPosOffset += 3;
994         }
995         if (_type == PlayerPosType.Forward) {
996             yPosOffset += 6;
997         }
998         if (_size == 5) {
999             if (_index == 0) {
1000                 return (0, 2 + yPosOffset);
1001             }
1002             if (_index == 1) {
1003                 return (2, 2 + yPosOffset);
1004             }
1005             if (_index == 2) {
1006                 return (4, 2 + yPosOffset);
1007             }
1008             if (_index == 3) {
1009                 return (6, 2 + yPosOffset);
1010             } else {
1011                 return (3, 3 + yPosOffset);
1012             }
1013         }
1014         if (_size == 4) {
1015             if (_index == 0) {
1016                 return (0, 2 + yPosOffset);
1017             }
1018             if (_index == 1) {
1019                 return (2, 2 + yPosOffset);
1020             }
1021             if (_index == 2) {
1022                 return (4, 2 + yPosOffset);
1023             } else {
1024                 return (6, 2 + yPosOffset);
1025             }
1026         }
1027         if (_size == 3) {
1028             if (_index == 0) {
1029                 return (1, 2 + yPosOffset);
1030             }
1031             if (_index == 1) {
1032                 return (3, 2 + yPosOffset);
1033             } else {
1034                 return (5, 2 + yPosOffset);
1035             }
1036         }
1037         if (_size == 2) {
1038             if (_index == 0) {
1039                 return (2, 2 + yPosOffset);
1040             } else {
1041                 return (4, 2 + yPosOffset);
1042             }
1043         }
1044         if (_size == 1) {
1045             return (3, 2 + yPosOffset);
1046         }
1047     }
1048 
1049     ///
1050     function start(uint8 _minTeamCount) external onlyCOO whenNotPaused returns (uint256) {
1051         require(teamUserInfo.length >= _minTeamCount);
1052 
1053         uint256 competitionId = nextCompetitionId++;
1054         CompetitionInfo storage ci = competitionInfos[competitionId];
1055         //ci.startTime = uint64(now);
1056         ci.status = CompetitionStatus.Start;
1057 
1058         //randomize the last _minTeamCount(=32) teams, and take them out.
1059         uint256 i;
1060         uint256 startI = teamUserInfo.length - _minTeamCount;
1061         uint256 j;
1062         require(ci.users.length >= _minTeamCount);
1063         ci.userCount = _minTeamCount;
1064         uint256 seed = randomContract.maxRandom();
1065         address[32] memory selectUserInfo;
1066         for (i = startI; i < teamUserInfo.length; i++) {
1067             selectUserInfo[i - startI] = teamUserInfo[i];
1068         }
1069         i = teamUserInfo.length;
1070         teamUserInfo.length = teamUserInfo.length - _minTeamCount;
1071         for (; i > startI; i--) {
1072 
1073             //random from 0 to i
1074             uint256 m;
1075             (seed, m) = randomContract.randomNext(seed, i);
1076 
1077             //take out [m], put into competitionInfo
1078             address user;
1079             if (m < startI) {
1080                 user = teamUserInfo[m];
1081             } else {
1082                 user = selectUserInfo[m-startI];
1083             }
1084             ci.users[j] = user;
1085             Team storage teamInfo = userToTeam[user];
1086             teamInfo.status = TeamStatus.Competition;
1087             teamInfo.index = uint128(competitionId);
1088 
1089             SponsorsInfo storage si = sponsorInfos[competitionId][j];
1090             si.sponsors[user] = (si.sponsors[user]).add(teamInfo.fees);
1091             si.totalAmount = (si.totalAmount).add(teamInfo.fees);
1092 
1093             //exchange [i - 1] and [m]
1094             if (m != i - 1) {
1095 
1096                 user = selectUserInfo[i - 1 - startI];
1097             
1098                 if (m < startI) {
1099                     teamUserInfo[m] = user;
1100                     userToTeam[user].index = uint128(m + 1);
1101                 } else {
1102                     selectUserInfo[m - startI] = user;
1103                 }
1104             }
1105 
1106             //delete [i - 1]
1107             //delete teamUserInfo[i - 1];
1108             j++;
1109         }
1110 
1111         StartCompetition(competitionId, now, ci.users);
1112 
1113         return competitionId;
1114     }
1115 
1116     function sponsor(address _sender, uint256 _competitionId, uint256 _teamIdx, uint256 _count) external whenNotPaused returns (bool) {
1117         require(msg.sender == address(joyTokenContract) || msg.sender == _sender);
1118 
1119         CompetitionInfo storage ci = competitionInfos[_competitionId];
1120         require(ci.status == CompetitionStatus.Start);
1121         //require(now < ci.startTime + sponsorInterval);
1122 
1123         require(joyTokenContract.transferFrom(_sender, address(this), _count));
1124 
1125         require(_teamIdx < ci.userCount);
1126         address targetUser = ci.users[_teamIdx];
1127         Team storage teamInfo = userToTeam[targetUser];
1128         require(teamInfo.status == TeamStatus.Competition);
1129         
1130         SponsorsInfo storage si = sponsorInfos[_competitionId][_teamIdx];
1131         si.sponsors[_sender] = (si.sponsors[_sender]).add(_count);
1132         si.totalAmount = (si.totalAmount).add(_count);
1133 
1134         Sponsor(_sender, _competitionId, targetUser, _count);
1135     }
1136 
1137     function reward(uint256 _competitionId, uint256 _teamIdx) external whenNotPaused {
1138         require(_teamIdx < 32);
1139 
1140         SponsorsInfo storage si = sponsorInfos[_competitionId][_teamIdx];
1141         uint256 baseValue = si.sponsors[msg.sender];
1142         require(baseValue > 0);
1143         CompetitionInfo storage ci = competitionInfos[_competitionId];
1144         if (ci.status == CompetitionStatus.Cancel) {
1145             // if (msg.sender == ci.users[_teamIdx]) {
1146             //     Team storage teamInfo = userToTeam[msg.sender];
1147             //     require(teamInfo.index == _competitionId && teamInfo.status == TeamStatus.Competition);
1148             //     delete userToTeam[msg.sender];
1149             // }
1150             delete si.sponsors[msg.sender];
1151             require(joyTokenContract.transfer(msg.sender, baseValue));
1152         } else if (ci.status == CompetitionStatus.End) {
1153             require(ci.teamWinCounts[_teamIdx] > 0);
1154 
1155             uint256 rewardValue = baseValue.mul(_getWinCountWeight(ci.teamWinCounts[_teamIdx]));
1156             rewardValue = ci.totalReward.mul(rewardValue) / ci.totalWeight;
1157             rewardValue = rewardValue.add(baseValue);
1158 
1159             Reward(_competitionId, ci.users[_teamIdx], ci.teamWinCounts[_teamIdx], msg.sender, baseValue, rewardValue);
1160 
1161             delete si.sponsors[msg.sender];
1162 
1163             require(joyTokenContract.transfer(msg.sender, rewardValue));
1164         }
1165     }
1166 
1167     function competition(uint256 _id) external onlyCOO whenNotPaused {
1168         CompetitionInfo storage ci = competitionInfos[_id];
1169         require(ci.status == CompetitionStatus.Start);
1170 
1171         uint8[32] memory teamWinCounts;
1172         uint32[3][11][32] memory playerAwakeSkills;
1173         TournamentCompetition.competition(_id, ci, teamWinCounts, playerAwakeSkills);
1174 
1175         _reward(_id, ci, teamWinCounts);
1176 
1177         bsCoreContract.tournamentResult(playerAwakeSkills);
1178 
1179         for (uint256 i = 0; i < ci.userCount; i++) {
1180             delete userToTeam[ci.users[i]];
1181         }
1182     }
1183 
1184     function cancelCompetition(uint256 _id) external onlyCOO {
1185         CompetitionInfo storage ci = competitionInfos[_id];
1186         require(ci.status == CompetitionStatus.Start);
1187         ci.status = CompetitionStatus.Cancel;
1188 
1189         for (uint256 i = 0; i < ci.userCount; i++) {
1190             //Team storage teamInfo = userToTeam[ci.users[i]];
1191             //require(teamInfo.index == _id && teamInfo.status == TeamStatus.Competition);
1192 
1193             delete userToTeam[ci.users[i]];
1194         }
1195 
1196         CancelCompetition(_id);
1197     }
1198 
1199     function _getWinCountWeight(uint256 _winCount) internal pure returns (uint256) {
1200         if (_winCount == 0) {
1201             return 0;
1202         }
1203 
1204         if (_winCount == 1) {
1205             return 1;
1206         }
1207 
1208         if (_winCount == 2) {
1209             return 2;
1210         }
1211 
1212         if (_winCount == 3) {
1213             return 3;
1214         }
1215 
1216         if (_winCount == 4) {
1217             return 4;
1218         }
1219 
1220         if (_winCount >= 5) {
1221             return 8;
1222         }
1223     }
1224 
1225     function _reward(uint256 _competitionId, CompetitionInfo storage ci, uint8[32] teamWinCounts) internal {
1226         uint256 totalReward = 0;
1227         uint256 totalWeight = 0;
1228         uint256 i;
1229         for (i = 0; i < ci.userCount; i++) {
1230             if (teamWinCounts[i] == 0) {
1231                 totalReward = totalReward.add(sponsorInfos[_competitionId][i].totalAmount);
1232             } else {
1233                 uint256 weight = sponsorInfos[_competitionId][i].totalAmount;
1234                 weight = weight.mul(_getWinCountWeight(teamWinCounts[i]));
1235                 totalWeight = totalWeight.add(weight);
1236             }
1237         }
1238 
1239         uint256 cost = getOperationCost(ci.userCount);
1240 
1241         uint256 ownerCut;
1242         if (totalReward > cost) {
1243             ownerCut = cost.add((totalReward - cost).mul(3)/100);
1244             totalReward = totalReward.sub(ownerCut);
1245         } else {
1246             ownerCut = totalReward;
1247             totalReward = 0;
1248         }
1249 
1250         require(joyTokenContract.transfer(cfoAddress, ownerCut));
1251 
1252         ci.totalReward = totalReward;
1253         ci.totalWeight = totalWeight;
1254         ci.teamWinCounts = teamWinCounts;
1255         ci.status = CompetitionStatus.End;
1256 
1257         EndCompetition(_competitionId, totalReward, totalWeight, teamWinCounts);
1258     }
1259 
1260     function _insertSortMemory(uint32[11] arr) internal pure {
1261         uint256 n = arr.length;
1262         uint256 i;
1263         uint32 key;
1264         uint256 j;
1265 
1266         for (i = 1; i < n; i++) {
1267             key = arr[i];
1268 
1269             for (j = i; j > 0 && arr[j-1] > key; j--) {
1270                 arr[j] = arr[j-1];
1271             }
1272 
1273             arr[j] = key;
1274         }
1275     }
1276 
1277     function getTeam(address _owner) external view returns (uint256 index, uint256 fees, uint32[11] playerIds,
1278             uint16[11] playerAtkWeights, TeamStatus status, uint16 attack, uint16 defense, uint16 stamina) {
1279         Team storage teamInfo = userToTeam[_owner];
1280         index = teamInfo.index;
1281         fees = teamInfo.fees;
1282         playerIds = teamInfo.playerIds;
1283         playerAtkWeights = teamInfo.playerAtkWeights;
1284         status = teamInfo.status;
1285         attack = teamInfo.attack;
1286         defense = teamInfo.defense;
1287         stamina = teamInfo.stamina;
1288     }
1289 
1290     function getCompetitionInfo(uint256 _id) external view returns (uint256 totalReward, uint256 totalWeight,
1291             address[32] users, uint8[32] teamWinCounts, uint8 userCount, CompetitionStatus status) {
1292         CompetitionInfo storage ci = competitionInfos[_id];
1293         //startTime = ci.startTime;
1294         totalReward = ci.totalReward;
1295         totalWeight = ci.totalWeight;
1296         users = ci.users;
1297         teamWinCounts = ci.teamWinCounts;
1298         userCount = ci.userCount;
1299         status = ci.status;
1300     }
1301 }