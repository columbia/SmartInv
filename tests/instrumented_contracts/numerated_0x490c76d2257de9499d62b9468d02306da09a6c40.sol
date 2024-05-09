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
376         storeBet(_gameId, _team, msg.value);
377         playerData[msg.sender].totalBetAmount += msg.value;
378         totalBetPool += msg.value;
379     }
380 
381     function multiBet(uint[] _gameIds, uint[] _teams, uint[] _amounts)
382         public
383         payable
384     {
385         require(
386             _gameIds.length == _teams.length &&
387             _gameIds.length == _amounts.length,
388             "Lengths do not match."
389         );
390 
391         uint _betsNum = _gameIds.length;
392         uint _balance = msg.value;
393 
394         for(uint i = 0; i < _betsNum; ++i) {
395             if (_balance >= _amounts[i]) {
396                 storeBet(_gameIds[i], _teams[i], _amounts[i]);
397                 _balance -= _amounts[i];
398             } else {
399                 revert("Not enough balance sent.");
400             }
401         }
402 
403         if (_balance > 0) {
404             msg.sender.transfer(_balance);
405             playerData[msg.sender].totalBetAmount += (msg.value - _balance);
406             totalBetPool += (msg.value - _balance);
407         }
408     }
409 
410     function withdrawReward(uint _gameId)
411         public
412         onlyIfGameValid(_gameId)
413         onlyAfterEndTime(_gameId)
414         onlyIfWinnerIsSet(_gameId)
415     {
416         Game storage _game = game[_gameId];
417 
418         uint betAmount = _game.book[_game.WINNER][msg.sender];
419         if (betAmount == 0) {
420             return;
421         }
422 
423         uint reward = betAmount + (
424             betAmount *
425             (_game.oddsMapping[_game.loserOne] + _game.oddsMapping[_game.loserTwo]) /
426             _game.oddsMapping[_game.WINNER]
427         );
428 
429         if (_game.balance < reward) {
430             revert("Not enough balance on game. Contact 0xgame.");
431         }
432         address(msg.sender).transfer(reward);
433         _game.balance -= reward;
434         playerData[msg.sender].totalWithdrawn += reward;
435 
436         _game.playerBets[msg.sender][_game.WINNER].withdrawn = true;
437         _game.book[_game.WINNER][msg.sender] = 0;
438 
439         emit RewardWithdrawn(_gameId, msg.sender, reward);
440     }
441 
442     function multiWithdrawReward(uint[] _gameIds)
443         public
444     {
445         for (uint i = 0; i < _gameIds.length; ++i) {
446             withdrawReward(_gameIds[i]);
447         }
448     }
449 
450     function withdrawInvalidated(uint _gameId)
451         public
452     {
453         Game storage _game = game[_gameId];
454 
455         require(
456             _game.betsCloseAt == 0,
457             "Game not invalidated."
458         );
459 
460         uint[3][3] memory _playerData = getPlayerDataForGame(_gameId, msg.sender);
461 
462         uint _totalBetAmount =
463             _playerData[0][1] +
464             _playerData[1][1] +
465             _playerData[2][1];
466 
467         address(msg.sender).transfer(_totalBetAmount);
468 
469         _game.playerBets[msg.sender][1].betAmount = 0;
470         _game.playerBets[msg.sender][2].betAmount = 0;
471         _game.playerBets[msg.sender][3].betAmount = 0;
472     }
473 
474     function remoteSetWinner(uint _gameId, uint _callback_wei, uint _callback_gas_limit)
475         public
476         onlyAfterEndTime(_gameId)
477         onlyIfWinnerIsMissing(_gameId)
478     {
479         if (game[_gameId].verityAddress == 0x0) {
480             OraclizeResolverI(resolverAddress).remoteSetWinner(
481                 _gameId,
482                 game[_gameId].oraclizeSource,
483                 _callback_wei,
484                 _callback_gas_limit
485             );
486         } else {
487             OraclizeResolverI(resolverAddress).eventSetWinner(_gameId, game[_gameId].verityAddress, game[_gameId].verityResultIndex);
488         }
489     }
490 
491     function callback(uint _gameId, string _result)
492         external
493         onlyResolver
494         onlyValidTeamName(_gameId, _result)
495     {
496         game[_gameId].WINNER = game[_gameId].teamMapping[_result];
497         emit WinningTeamSet(_gameId, _result);
498         setLosers(_gameId);
499     }
500 
501     //  see private method buildTeamMapping, buildBoolMapping
502     //  first element in the nested array represents the team user betted on:
503     //    (teamOne -> 1, teamTwo -> 2, draw -> 3)
504     //  second element in nested array is the bet amount
505     //  third element in nested array represents withdrawal status:
506     //    (false -> 0, true -> 1)
507     //  additionally (applies to first level elements):
508     //    first array holds player data for teamOne
509     //    second array holds player data for teamTwo
510     //    third array holds pleyer data for draw
511     function getPlayerDataForGame(uint _gameId, address _playerAddress) public view returns(uint[3][3]) {
512         Game storage _game = game[_gameId];
513 
514         return [
515             [
516                 1,
517                 _game.playerBets[_playerAddress][1].betAmount,
518                 boolMapping[_game.playerBets[_playerAddress][1].withdrawn]
519             ],
520             [
521                 2,
522                 _game.playerBets[_playerAddress][2].betAmount,
523                 boolMapping[_game.playerBets[_playerAddress][2].withdrawn]
524             ],
525             [
526                 3,
527                 _game.playerBets[_playerAddress][3].betAmount,
528                 boolMapping[_game.playerBets[_playerAddress][3].withdrawn]
529             ]
530         ];
531     }
532 
533     function getPlayerData(address _playerAddress) public view returns(uint[2]) {
534         return [
535             playerData[_playerAddress].totalBetAmount,
536             playerData[_playerAddress].totalWithdrawn
537         ];
538     }
539 
540     function getGamePool(uint _gameId) public view returns(uint[3]) {
541         Game storage _game = game[_gameId];
542 
543         return [
544             _game.oddsMapping[1],
545             _game.oddsMapping[2],
546             _game.oddsMapping[3]
547         ];
548     }
549 
550     function addBalanceToGame(uint _gameId)
551         public
552         payable
553         onlyOwner
554     {
555         game[_gameId].balance += msg.value;
556     }
557 
558     function withdrawRemainingRewards(uint _gameId)
559         public
560         onlyOwner
561         onlyAfterWithdrawTime(_gameId)
562     {
563         address(owner).transfer(game[_gameId].balance);
564     }
565 
566     function setResolver(address _resolverAddress)
567         public
568         onlyOwner
569     {
570         resolverAddress = _resolverAddress;
571     }
572 
573     function updateGameMeta(uint _gameId, string _oddsApi, string _description)
574         public
575         onlyOwner
576     {
577         Game storage _game = game[_gameId];
578 
579         _game.oddsApi = _oddsApi;
580         _game.description = _description;
581     }
582 
583     /// Private functions
584     function buildBoolMapping() private {
585         boolMapping[false] = 0;
586         boolMapping[true] = 1;
587     }
588 
589     function buildTeamMapping(uint _gameId) internal {
590         game[_gameId].teamMapping[game[_gameId].teamOne] = 1;
591         game[_gameId].teamMapping[game[_gameId].teamTwo] = 2;
592         game[_gameId].teamMapping[draw] = 3;
593     }
594 
595     function setLosers(uint _gameId) private returns(string) {
596         Game storage _game = game[_gameId];
597 
598         if (_game.WINNER == 1) {
599             _game.loserOne = 2;
600             _game.loserTwo = 3;
601         } else if (_game.WINNER == 2) {
602             _game.loserOne = 1;
603             _game.loserTwo = 3;
604         } else if (_game.WINNER == 3) {
605             _game.loserOne = 1;
606             _game.loserTwo = 2;
607         }
608     }
609 
610     function storeBet(uint _gameId, uint _team, uint _amount)
611         private
612         onlyIfGameValid(_gameId)
613         onlyValidTeam(_team)
614     {
615         Game storage _game = game[_gameId];
616 
617         if (now > _game.betsCloseAt) {
618             emit BetFailed(_gameId, msg.sender, _amount, _team);
619             return;
620         }
621 
622         _game.book[_team][msg.sender] += _amount;
623         _game.oddsMapping[_team] += _amount;
624         _game.balance += _amount;
625         _game.totalPool += _amount;
626 
627         if (_game.playerBets[msg.sender][_team].betAmount == 0) {
628             _game.playerBets[msg.sender][_team] = PlayerBet(_amount, _team, false);
629         } else {
630             _game.playerBets[msg.sender][_team].betAmount += _amount;
631         }
632 
633         emit PlayerJoined(_gameId, msg.sender, _amount, _team);
634     }
635 
636     function strToBytes32(string _team) internal pure returns(bytes32 result) {
637         bytes memory _teamBytes;
638 
639         _teamBytes = bytes(_team);
640         assembly {
641             result := mload(add(_teamBytes, 32))
642         }
643     }
644 }