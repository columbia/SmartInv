1 pragma solidity ^0.4.18;
2 
3 
4 interface OraclizeResolverI {
5     function remoteSetWinner(uint _gameId, string _oraclizeSource, uint _callback_wei, uint _callback_gas_limit) external;
6     function eventSetWinner(uint _gameId, address _verityAddress, uint _verityResultIndex) external;
7 }
8 
9 
10 contract Bet0xgameMaster {
11     address public owner;
12     address public resolverAddress;
13 
14     mapping(bool => uint) boolMapping;
15 
16     string constant draw = "draw";
17 
18     uint public totalBetPool;
19 
20     struct PlayerBet {
21         uint betAmount;
22         uint team;
23         bool withdrawn;
24     }
25 
26     struct PlayerData {
27         uint totalBetAmount;
28         uint totalWithdrawn;
29     }
30     mapping(address => PlayerData) playerData;
31 
32     struct Game {
33         uint WINNER;
34         uint loserOne;
35         uint loserTwo;
36         string teamOne;
37         string teamTwo;
38 
39         string description;
40         string oddsApi;
41 
42         string oraclizeSource;
43 
44         address verityAddress;
45         uint verityResultIndex;
46 
47         bytes32 category;
48         bytes32 subcategory;
49 
50         uint betsCloseAt;
51         uint endsAt;
52 
53         uint gameId;
54         uint balance;
55         uint totalPool;
56 
57         bool drawPossible;
58 
59         uint withdrawAfter;
60 
61         mapping(uint => mapping(address => uint)) book;
62         mapping(uint => uint) oddsMapping;
63         mapping(string => uint) teamMapping;
64         mapping(address => mapping(uint => PlayerBet)) playerBets;
65     }
66     Game[] game;
67 
68     /// Events
69     event PlayerJoined(
70         uint indexed gameId,
71         address indexed playerAddress,
72         uint betAmount,
73         uint team
74     );
75 
76     event RewardWithdrawn(
77         uint indexed gameId,
78         address indexed withdrawer,
79         uint withdrawnAmount
80     );
81 
82     event WinningTeamSet(
83         uint indexed gameId,
84         string team
85     );
86 
87     event NewGame(
88         uint indexed gameId,
89         string teamOne,
90         string teamTwo,
91         uint betsCloseAt
92     );
93 
94     event BetFailed(
95         uint indexed gameId,
96         address indexed playerAddress,
97         uint betAmount,
98         uint team
99     );
100 
101     event GameInvalidated(
102         uint gameId
103     );
104 
105     /// Modifiers
106     modifier onlyOwner {
107         require(
108             msg.sender == owner,
109             "Only owner can do this"
110         );
111         _;
112     }
113 
114     modifier onlyValidTeamName(uint _gameId, string _team) {
115         require(
116             keccak256(bytes(_team)) == keccak256(bytes(game[_gameId].teamOne)) ||
117             keccak256(bytes(_team)) == keccak256(bytes(game[_gameId].teamTwo)) ||
118             keccak256(bytes(_team)) == keccak256(bytes(draw)),
119             "Not a valid team name for game."
120         );
121         _;
122     }
123 
124     modifier onlyValidTeam(uint _team) {
125         require(
126             _team > 0 &&
127             _team <= 3,
128             "Not a valid team identifier."
129         );
130         _;
131     }
132 
133     modifier onlyAfterEndTime(uint _gameId) {
134         require(
135             now >= game[_gameId].endsAt,
136             "Game not ended yet."
137         );
138         _;
139     }
140 
141     modifier onlyAfterWithdrawTime(uint _gameId) {
142         require(
143             now >= game[_gameId].withdrawAfter,
144             "Can't withdraw remaining rewards yet."
145         );
146         _;
147     }
148 
149     modifier onlyIfGameValid(uint _gameId) {
150         require(
151             game[_gameId].betsCloseAt > 0,
152             "Game not valid"
153         );
154         _;
155     }
156 
157     modifier onlyIfWinnerIsMissing(uint _gameId) {
158         require(
159             game[_gameId].WINNER == 0,
160             "Winner already set."
161         );
162         _;
163     }
164 
165     modifier onlyIfWinnerIsSet(uint _gameId) {
166         require(
167             game[_gameId].WINNER != 0,
168             "Winner not set."
169         );
170         _;
171     }
172 
173     modifier endsAtAfterBetsCloseAt(uint _betsCloseAt, uint _endsAt) {
174         require(
175             _betsCloseAt < _endsAt,
176             "Bets can't close after game ends."
177         );
178         _;
179     }
180 
181     modifier onlyBeforeBetsCloseAt(uint _gameId) {
182         require(
183             now < game[_gameId].betsCloseAt,
184             "Bets already closed."
185         );
186         _;
187     }
188 
189     modifier onlyResolver {
190         require(
191             msg.sender == resolverAddress || msg.sender == address(this),
192             "Only resolver can do this"
193         );
194         _;
195     }
196 
197     /// Constructor
198     constructor(address _resolverAddress) public {
199         owner = msg.sender;
200         resolverAddress = _resolverAddress;
201 
202         buildBoolMapping();
203     }
204 
205     /// Public functions
206     function createGame(
207         string _teamOne,
208         string _teamTwo,
209         uint _endsAt,
210         uint _betsCloseAt,
211         string _oraclizeSource,
212         address _verityAddress,
213         uint _verityResultIndex,
214         string _oddsApi,
215         bytes32[2] _categories,
216         bool _drawPossible,
217         string _description
218     )
219         public
220         onlyOwner
221         endsAtAfterBetsCloseAt(_betsCloseAt, _endsAt)
222     {
223         Game memory _game;
224 
225         _game.gameId = game.length;
226         _game.teamOne = _teamOne;
227         _game.teamTwo = _teamTwo;
228         _game.betsCloseAt = _betsCloseAt;
229         _game.endsAt = _endsAt;
230         _game.oddsApi = _oddsApi;
231         _game.category = _categories[0];
232         _game.subcategory = _categories[1];
233         _game.drawPossible = _drawPossible;
234         _game.description = _description;
235         _game.verityAddress = _verityAddress;
236         _game.verityResultIndex = _verityResultIndex;
237         _game.oraclizeSource = _oraclizeSource;
238 
239         _game.withdrawAfter = _endsAt + 1 weeks;
240 
241         game.push(_game);
242 
243         buildTeamMapping(_game.gameId);
244 
245         emit NewGame(
246             _game.gameId,
247             _teamOne,
248             _teamTwo,
249             _betsCloseAt
250         );
251     }
252 
253     function getGameLength() public view returns(uint) {
254         return game.length;
255     }
256 
257     function getGame(uint _gameId) public view returns(string, string, bool, uint, uint, uint, uint, string, string) {
258         Game storage _game = game[_gameId];
259 
260         return (
261             _game.teamOne,
262             _game.teamTwo,
263             _game.drawPossible,
264             _game.WINNER,
265             _game.betsCloseAt,
266             _game.endsAt,
267             _game.totalPool,
268             _game.oddsApi,
269             _game.description
270         );
271     }
272 
273     // Returns only first 32 characters of each team's name
274     function getGames(uint[] _gameIds) public view returns(
275         uint[], bytes32[], bytes32[], bool[], uint[], uint[]
276     ) {
277         bytes32[] memory _teamOne = new bytes32[](_gameIds.length);
278         bytes32[] memory _teamTwo = new bytes32[](_gameIds.length);
279         uint[] memory _WINNER = new uint[](_gameIds.length);
280         uint[] memory _betsCloseAt = new uint[](_gameIds.length);
281 
282         bool[] memory _drawPossible = new bool[](_gameIds.length);
283 
284         for(uint i = 0; i < _gameIds.length; ++i) {
285             _teamOne[i] = strToBytes32(game[_gameIds[i]].teamOne);
286             _teamTwo[i] = strToBytes32(game[_gameIds[i]].teamTwo);
287             _WINNER[i] = game[_gameIds[i]].WINNER;
288             _betsCloseAt[i] = game[_gameIds[i]].betsCloseAt;
289             _drawPossible[i] = game[_gameIds[i]].drawPossible;
290 
291         }
292 
293         return (
294             _gameIds,
295             _teamOne,
296             _teamTwo,
297             _drawPossible,
298             _WINNER,
299             _betsCloseAt
300         );
301     }
302 
303     function getGamesMeta(uint[] _gameIds) public view returns(
304         uint[], bytes32[], bytes32[], bool[], bool[]
305     ) {
306         bytes32[] memory _category = new bytes32[](_gameIds.length);
307         bytes32[] memory _subcategory = new bytes32[](_gameIds.length);
308         bool[] memory _hasOddsApi = new bool[](_gameIds.length);
309         bool[] memory _hasDescription = new bool[](_gameIds.length);
310 
311         for(uint i = 0; i < _gameIds.length; ++i) {
312             _category[i] = game[_gameIds[i]].category;
313             _subcategory[i] = game[_gameIds[i]].subcategory;
314             _hasOddsApi[i] = (bytes(game[_gameIds[i]].oddsApi).length != 0);
315             _hasDescription[i] = (bytes(game[_gameIds[i]].description).length != 0);
316         }
317 
318         return (
319             _gameIds,
320             _category,
321             _subcategory,
322             _hasOddsApi,
323             _hasDescription
324         );
325     }
326 
327     function getGamesPool(uint[] _gameIds) public view returns(
328         uint[], uint[], uint[], uint[]
329     ) {
330         uint[] memory _oddsOne = new uint[](_gameIds.length);
331         uint[] memory _oddsTwo = new uint[](_gameIds.length);
332         uint[] memory _oddsDraw = new uint[](_gameIds.length);
333 
334         for(uint i = 0; i < _gameIds.length; ++i) {
335             _oddsOne[i] = game[_gameIds[i]].oddsMapping[1];
336             _oddsTwo[i] = game[_gameIds[i]].oddsMapping[2];
337             _oddsDraw[i] = game[_gameIds[i]].oddsMapping[3];
338         }
339 
340         return (
341             _gameIds,
342             _oddsOne,
343             _oddsTwo,
344             _oddsDraw
345         );
346     }
347 
348     function getGameResolverData(uint _gameId) public view returns(string, address, uint) {
349         Game storage _game = game[_gameId];
350 
351         return(
352             _game.oraclizeSource,
353             _game.verityAddress,
354             _game.verityResultIndex
355         );
356     }
357 
358     function invalidateGame(uint _gameId)
359         public
360         onlyOwner
361         onlyIfWinnerIsMissing(_gameId)
362     {
363         Game storage _game = game[_gameId];
364 
365         _game.betsCloseAt = 0;
366         _game.endsAt = 0;
367         _game.withdrawAfter = now + 1 weeks;
368 
369         emit GameInvalidated(_gameId);
370     }
371 
372     function bet(uint _gameId, uint _team)
373         public
374         payable
375     {
376         if (storeBet(_gameId, _team, msg.value)) {
377             playerData[msg.sender].totalBetAmount += msg.value;
378             totalBetPool += msg.value;
379         } else {
380             address(msg.sender).transfer(msg.value);
381         }
382     }
383 
384     function multiBet(uint[] _gameIds, uint[] _teams, uint[] _amounts)
385         public
386         payable
387     {
388         require(
389             _gameIds.length == _teams.length &&
390             _gameIds.length == _amounts.length,
391             "Lengths do not match."
392         );
393 
394         uint _betsNum = _gameIds.length;
395         uint _balance = msg.value;
396 
397         for(uint i = 0; i < _betsNum; ++i) {
398             if (_balance >= _amounts[i]) {
399                 if (storeBet(_gameIds[i], _teams[i], _amounts[i])) {
400                     _balance -= _amounts[i];
401                 }
402             } else {
403                 revert("Not enough balance sent.");
404             }
405         }
406 
407         if (_balance > 0) {
408             msg.sender.transfer(_balance);
409         }
410 
411         playerData[msg.sender].totalBetAmount += (msg.value - _balance);
412         totalBetPool += (msg.value - _balance);
413     }
414 
415     function withdrawReward(uint _gameId)
416         public
417         onlyIfGameValid(_gameId)
418         onlyAfterEndTime(_gameId)
419         onlyIfWinnerIsSet(_gameId)
420     {
421         Game storage _game = game[_gameId];
422 
423         uint betAmount = _game.book[_game.WINNER][msg.sender];
424         if (betAmount == 0) {
425             return;
426         }
427 
428         uint reward = betAmount + (
429             betAmount *
430             (_game.oddsMapping[_game.loserOne] + _game.oddsMapping[_game.loserTwo]) /
431             _game.oddsMapping[_game.WINNER]
432         );
433 
434         if (_game.balance < reward) {
435             revert("Not enough balance on game. Contact 0xgame.");
436         }
437         address(msg.sender).transfer(reward);
438         _game.balance -= reward;
439         playerData[msg.sender].totalWithdrawn += reward;
440 
441         _game.playerBets[msg.sender][_game.WINNER].withdrawn = true;
442         _game.book[_game.WINNER][msg.sender] = 0;
443 
444         emit RewardWithdrawn(_gameId, msg.sender, reward);
445     }
446 
447     function multiWithdrawReward(uint[] _gameIds)
448         public
449     {
450         for (uint i = 0; i < _gameIds.length; ++i) {
451             withdrawReward(_gameIds[i]);
452         }
453     }
454 
455     function withdrawInvalidated(uint _gameId)
456         public
457     {
458         Game storage _game = game[_gameId];
459 
460         require(
461             _game.betsCloseAt == 0,
462             "Game not invalidated."
463         );
464 
465         uint[3][3] memory _playerData = getPlayerDataForGame(_gameId, msg.sender);
466 
467         uint _totalBetAmount =
468             _playerData[0][1] +
469             _playerData[1][1] +
470             _playerData[2][1];
471 
472         address(msg.sender).transfer(_totalBetAmount);
473 
474         _game.playerBets[msg.sender][1].betAmount = 0;
475         _game.playerBets[msg.sender][2].betAmount = 0;
476         _game.playerBets[msg.sender][3].betAmount = 0;
477     }
478 
479     function remoteSetWinner(uint _gameId, uint _callback_wei, uint _callback_gas_limit)
480         public
481         onlyAfterEndTime(_gameId)
482         onlyIfWinnerIsMissing(_gameId)
483     {
484         if (game[_gameId].verityAddress == 0x0) {
485             OraclizeResolverI(resolverAddress).remoteSetWinner(
486                 _gameId,
487                 game[_gameId].oraclizeSource,
488                 _callback_wei,
489                 _callback_gas_limit
490             );
491         } else {
492             OraclizeResolverI(resolverAddress).eventSetWinner(_gameId, game[_gameId].verityAddress, game[_gameId].verityResultIndex);
493         }
494     }
495 
496     function callback(uint _gameId, string _result)
497         external
498         onlyResolver
499         onlyValidTeamName(_gameId, _result)
500     {
501         game[_gameId].WINNER = game[_gameId].teamMapping[_result];
502         emit WinningTeamSet(_gameId, _result);
503         setLosers(_gameId);
504     }
505 
506     //  see private method buildTeamMapping, buildBoolMapping
507     //  first element in the nested array represents the team user betted on:
508     //    (teamOne -> 1, teamTwo -> 2, draw -> 3)
509     //  second element in nested array is the bet amount
510     //  third element in nested array represents withdrawal status:
511     //    (false -> 0, true -> 1)
512     //  additionally (applies to first level elements):
513     //    first array holds player data for teamOne
514     //    second array holds player data for teamTwo
515     //    third array holds pleyer data for draw
516     function getPlayerDataForGame(uint _gameId, address _playerAddress) public view returns(uint[3][3]) {
517         Game storage _game = game[_gameId];
518 
519         return [
520             [
521                 1,
522                 _game.playerBets[_playerAddress][1].betAmount,
523                 boolMapping[_game.playerBets[_playerAddress][1].withdrawn]
524             ],
525             [
526                 2,
527                 _game.playerBets[_playerAddress][2].betAmount,
528                 boolMapping[_game.playerBets[_playerAddress][2].withdrawn]
529             ],
530             [
531                 3,
532                 _game.playerBets[_playerAddress][3].betAmount,
533                 boolMapping[_game.playerBets[_playerAddress][3].withdrawn]
534             ]
535         ];
536     }
537 
538     function getPlayerData(address _playerAddress) public view returns(uint[2]) {
539         return [
540             playerData[_playerAddress].totalBetAmount,
541             playerData[_playerAddress].totalWithdrawn
542         ];
543     }
544 
545     function getGamePool(uint _gameId) public view returns(uint[3]) {
546         Game storage _game = game[_gameId];
547 
548         return [
549             _game.oddsMapping[1],
550             _game.oddsMapping[2],
551             _game.oddsMapping[3]
552         ];
553     }
554 
555     function addBalanceToGame(uint _gameId)
556         public
557         payable
558         onlyOwner
559     {
560         game[_gameId].balance += msg.value;
561     }
562 
563     function withdrawRemainingRewards(uint _gameId)
564         public
565         onlyOwner
566         onlyAfterWithdrawTime(_gameId)
567     {
568         address(owner).transfer(game[_gameId].balance);
569     }
570 
571     function setResolver(address _resolverAddress)
572         public
573         onlyOwner
574     {
575         resolverAddress = _resolverAddress;
576     }
577 
578     function updateGameMeta(uint _gameId, string _oddsApi, string _description)
579         public
580         onlyOwner
581     {
582         Game storage _game = game[_gameId];
583 
584         _game.oddsApi = _oddsApi;
585         _game.description = _description;
586     }
587 
588     /// Private functions
589     function buildBoolMapping() private {
590         boolMapping[false] = 0;
591         boolMapping[true] = 1;
592     }
593 
594     function buildTeamMapping(uint _gameId) internal {
595         game[_gameId].teamMapping[game[_gameId].teamOne] = 1;
596         game[_gameId].teamMapping[game[_gameId].teamTwo] = 2;
597         game[_gameId].teamMapping[draw] = 3;
598     }
599 
600     function setLosers(uint _gameId) private returns(string) {
601         Game storage _game = game[_gameId];
602 
603         if (_game.WINNER == 1) {
604             _game.loserOne = 2;
605             _game.loserTwo = 3;
606         } else if (_game.WINNER == 2) {
607             _game.loserOne = 1;
608             _game.loserTwo = 3;
609         } else if (_game.WINNER == 3) {
610             _game.loserOne = 1;
611             _game.loserTwo = 2;
612         }
613     }
614 
615     function storeBet(uint _gameId, uint _team, uint _amount)
616         private
617         onlyIfGameValid(_gameId)
618         onlyValidTeam(_team)
619         returns(bool)
620     {
621         Game storage _game = game[_gameId];
622 
623         if (now > _game.betsCloseAt) {
624             emit BetFailed(_gameId, msg.sender, _amount, _team);
625             return false;
626         }
627 
628         _game.book[_team][msg.sender] += _amount;
629         _game.oddsMapping[_team] += _amount;
630         _game.balance += _amount;
631         _game.totalPool += _amount;
632 
633         if (_game.playerBets[msg.sender][_team].betAmount == 0) {
634             _game.playerBets[msg.sender][_team] = PlayerBet(_amount, _team, false);
635         } else {
636             _game.playerBets[msg.sender][_team].betAmount += _amount;
637         }
638 
639         emit PlayerJoined(_gameId, msg.sender, _amount, _team);
640         return true;
641     }
642 
643     function strToBytes32(string _team) internal pure returns(bytes32 result) {
644         bytes memory _teamBytes;
645 
646         _teamBytes = bytes(_team);
647         assembly {
648             result := mload(add(_teamBytes, 32))
649         }
650     }
651 }