1 pragma solidity 0.4.25;
2 
3 // File: contracts\lib\BMEvents.sol
4 
5 /// @title Events used in FomoSport
6 contract BMEvents {
7 
8     event onGameCreated(
9         uint256 indexed gameID,
10         uint256 timestamp
11     );
12 
13     event onGameActivated(
14         uint256 indexed gameID,
15         uint256 startTime,
16         uint256 timestamp
17     );
18 
19     event onGamePaused(
20         uint256 indexed gameID,
21         bool paused,
22         uint256 timestamp
23     );
24 
25     event onChangeCloseTime(
26         uint256 indexed gameID,
27         uint256 closeTimestamp,
28         uint256 timestamp
29     );
30 
31     event onPurchase(
32         uint256 indexed gameID,
33         uint256 indexed playerID,
34         address playerAddress,
35         bytes32 playerName,
36         uint256 teamID,
37         uint256 ethIn,
38         uint256 keysBought,
39         uint256 timestamp
40     );
41 
42     event onWithdraw(
43         uint256 indexed gameID,
44         uint256 indexed playerID,
45         address playerAddress,
46         bytes32 playerName,
47         uint256 ethOut,
48         uint256 timestamp
49     );
50 
51     event onGameEnded(
52         uint256 indexed gameID,
53         uint256 winningTeamID,
54         string comment,
55         uint256 timestamp
56     );
57 
58     event onGameCancelled(
59         uint256 indexed gameID,
60         string comment,
61         uint256 timestamp
62     );
63 
64     event onFundCleared(
65         uint256 indexed gameID,
66         uint256 fundCleared,
67         uint256 timestamp
68     );
69 }
70 
71 // File: contracts\lib\SafeMath.sol
72 
73 /// @title SafeMath v0.1.9
74 /// @dev Math operations with safety checks that throw on error
75 /// change notes: original SafeMath library from OpenZeppelin modified by Inventor
76 /// - added sqrt
77 /// - added sq
78 /// - added pwr 
79 /// - changed asserts to requires with error log outputs
80 /// - removed div, its useless
81 library SafeMath {
82     
83     /// @dev Multiplies two numbers, throws on overflow.
84     function mul(uint256 a, uint256 b) 
85         internal 
86         pure 
87         returns (uint256 c) 
88     {
89         if (a == 0) {
90             return 0;
91         }
92         c = a * b;
93         require(c / a == b, "SafeMath mul failed");
94         return c;
95     }
96 
97 
98     /// @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99     function sub(uint256 a, uint256 b)
100         internal
101         pure
102         returns (uint256) 
103     {
104         require(b <= a, "SafeMath sub failed");
105         return a - b;
106     }
107 
108 
109     /// @dev Adds two numbers, throws on overflow.
110     function add(uint256 a, uint256 b)
111         internal
112         pure
113         returns (uint256 c) 
114     {
115         c = a + b;
116         require(c >= a, "SafeMath add failed");
117         return c;
118     }
119     
120 
121     /// @dev gives square root of given x.
122     function sqrt(uint256 x)
123         internal
124         pure
125         returns (uint256 y) 
126     {
127         uint256 z = ((add(x, 1)) / 2);
128         y = x;
129         while (z < y) {
130             y = z;
131             z = ((add((x / z), z)) / 2);
132         }
133     }
134 
135 
136     /// @dev gives square. multiplies x by x
137     function sq(uint256 x)
138         internal
139         pure
140         returns (uint256)
141     {
142         return (mul(x,x));
143     }
144 
145 
146     /// @dev x to the power of y 
147     function pwr(uint256 x, uint256 y)
148         internal 
149         pure 
150         returns (uint256)
151     {
152         if (x == 0) {
153             return (0);
154         } else if (y == 0) {
155             return (1);
156         } else {
157             uint256 z = x;
158             for (uint256 i = 1; i < y; i++) {
159                 z = mul(z,x);
160             }
161             return (z);
162         }
163     }
164 }
165 
166 // File: contracts\lib\BMKeyCalc.sol
167 
168 // key calculation
169 library BMKeyCalc {
170     using SafeMath for *;
171     
172     /// @dev calculates number of keys received given X eth 
173     /// @param _curEth current amount of eth in contract 
174     /// @param _newEth eth being spent
175     /// @return amount of ticket purchased
176     function keysRec(uint256 _curEth, uint256 _newEth)
177         internal
178         pure
179         returns (uint256)
180     {
181         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
182     }
183 
184 
185     /// @dev calculates amount of eth received if you sold X keys 
186     /// @param _curKeys current amount of keys that exist 
187     /// @param _sellKeys amount of keys you wish to sell
188     /// @return amount of eth received
189     function ethRec(uint256 _curKeys, uint256 _sellKeys)
190         internal
191         pure
192         returns (uint256)
193     {
194         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
195     }
196 
197     /// @dev calculates how many keys would exist with given an amount of eth
198     /// @param _eth eth "in contract"
199     /// @return number of keys that would exist
200     function keys(uint256 _eth) 
201         internal
202         pure
203         returns(uint256)
204     {
205         return ((((((_eth).mul(1000000000000000000)).mul(3125000000000000000000000000)).add(562498828125610351562500000000000000000000000000000000000000000000)).sqrt()).sub(749999218750000000000000000000000)) / (1562500000);
206     }
207     
208     /// @dev calculates how much eth would be in contract given a number of keys
209     /// @param _keys number of keys "in contract" 
210     /// @return eth that would exists
211     function eth(uint256 _keys) 
212         internal
213         pure
214         returns(uint256)
215     {
216         return ((781250000).mul(_keys.sq()).add(((1499998437500000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
217     }
218 }
219 
220 // File: contracts\lib\BMDatasets.sol
221 
222 // datasets
223 library BMDatasets {
224 
225     struct Game {
226         string name;                     // game name
227         uint256 numberOfTeams;           // number of teams
228         uint256 gameStartTime;           // game start time (> 0 means activated)
229 
230         bool paused;                     // game paused
231         bool ended;                      // game ended
232         bool canceled;                   // game canceled
233         uint256 winnerTeam;              // winner team        
234         uint256 withdrawDeadline;        // deadline for withdraw fund
235         string gameEndComment;           // comment for game ending or canceling
236         uint256 closeTime;               // betting close time
237     }
238 
239     struct GameStatus {
240         uint256 totalEth;                // total eth invested
241         uint256 totalWithdrawn;          // total withdrawn by players
242         uint256 winningVaultInst;        // current "instant" winning vault
243         uint256 winningVaultFinal;       // current "final" winning vault        
244         bool fundCleared;                // fund already cleared
245     }
246 
247     struct Team {
248         bytes32 name;       // team name
249         uint256 keys;       // number of keys
250         uint256 eth;        // total eth for the team
251         uint256 mask;       // mask of this team
252         uint256 dust;       // dust for winning vault
253     }
254 
255     struct Player {
256         uint256 eth;        // total eth for the game
257         bool withdrawn;     // winnings already withdrawn
258     }
259 
260     struct PlayerTeam {
261         uint256 keys;       // number of keys
262         uint256 eth;        // total eth for the team
263         uint256 mask;       // mask for this team
264     }
265 }
266 
267 // File: contracts\lib\Ownable.sol
268 
269 /**
270  * @title Ownable
271  * @dev The Ownable contract has an owner address, and provides basic authorization control
272  * functions, this simplifies the implementation of "user permissions".
273  */
274 contract Ownable {
275     address public owner;
276     address public dev;
277 
278     /**
279     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
280     * account.
281     */
282     constructor() public {
283         owner = msg.sender;
284     }
285 
286 
287     /**
288     * @dev Throws if called by any account other than the owner.
289     */
290     modifier onlyOwner() {
291         require(msg.sender == owner, "only owner");
292         _;
293     }
294 
295     /**
296     * @dev Throws if called by any account other than the dev.
297     */
298     modifier onlyDev() {
299         require(msg.sender == dev, "only dev");
300         _;
301     }
302 
303     /**
304     * @dev Throws if called by any account other than the owner or dev.
305     */
306     modifier onlyDevOrOwner() {
307         require(msg.sender == owner || msg.sender == dev, "only owner or dev");
308         _;
309     }
310 
311     /**
312     * @dev Allows the current owner to transfer control of the contract to a newOwner.
313     * @param newOwner The address to transfer ownership to.
314     */
315     function transferOwnership(address newOwner) onlyOwner public {
316         if (newOwner != address(0)) {
317             owner = newOwner;
318         }
319     }
320 
321     /**
322     * @dev Allows the current owner to set a new dev address.
323     * @param newDev The new dev address.
324     */
325     function setDev(address newDev) onlyOwner public {
326         if (newDev != address(0)) {
327             dev = newDev;
328         }
329     }
330 }
331 
332 // File: contracts\interface\BMForwarderInterface.sol
333 
334 interface BMForwarderInterface {
335     function deposit() external payable;
336 }
337 
338 // File: contracts\interface\BMPlayerBookInterface.sol
339 
340 interface BMPlayerBookInterface {
341     function pIDxAddr_(address _addr) external returns (uint256);
342     function pIDxName_(bytes32 _name) external returns (uint256);
343 
344     function getPlayerID(address _addr) external returns (uint256);
345     function getPlayerName(uint256 _pID) external view returns (bytes32);
346     function getPlayerLAff(uint256 _pID) external view returns (uint256);
347     function setPlayerLAff(uint256 _pID, uint256 _lAff) external;
348     function getPlayerAffT2(uint256 _pID) external view returns (uint256);
349     function getPlayerAddr(uint256 _pID) external view returns (address);
350     function getPlayerHasAff(uint256 _pID) external view returns (bool);
351     function getNameFee() external view returns (uint256);
352     function getAffiliateFee() external view returns (uint256);
353     function depositAffiliate(uint256 _pID) external payable;
354 }
355 
356 // File: contracts\BMSport.sol
357 
358 /// @title A raffle system for sports betting, designed with FOMO elements
359 /// @notice This contract manages multiple games. Owner(s) can create games and
360 /// assign winning team for each game. Players can withdraw their winnings before
361 /// the deadline set by the owner(s). If there's no winning team, the owner(s)
362 /// can also cancel a game so the players get back their bettings (minus fees).
363 /// @dev The address of the forwarder, player book, and owner(s) are hardcoded.
364 /// Check 'TODO' before deploy.
365 contract BMSport is BMEvents, Ownable {
366     using BMKeyCalc for *;
367     using SafeMath for *;
368 
369     // TODO: check address!!
370     BMForwarderInterface  private Banker_Address;
371     BMPlayerBookInterface private BMBook;
372 
373     string constant public name_ = "BMSport";
374     uint256 public gameIDIndex_;
375     
376     // (gameID => gameData)
377     mapping(uint256 => BMDatasets.Game) public game_;
378 
379     // (gameID => gameStatus)
380     mapping(uint256 => BMDatasets.GameStatus) public gameStatus_;
381 
382     // (gameID => (teamID => teamData))
383     mapping(uint256 => mapping(uint256 => BMDatasets.Team)) public teams_;
384 
385     // (playerID => (gameID => playerData))
386     mapping(uint256 => mapping(uint256 => BMDatasets.Player)) public players_;
387 
388     // (playerID => (gameID => (teamID => playerTeamData)))
389     mapping(uint256 => mapping(uint256 => mapping(uint256 => BMDatasets.PlayerTeam))) public playerTeams_;
390 
391 
392     constructor(BMPlayerBookInterface book_addr) public {
393         require(book_addr != address(0), "need a playerbook address");
394         BMBook = book_addr;
395         gameIDIndex_ = 1;
396     }
397 
398 
399     /// @notice Create a game. Only owner(s) can call this function.
400     /// Emits "onGameCreated" event.
401     /// @param _name Name of the new game.
402     /// @param _teamNames Array consisting names of all teams in the game.
403     /// The size of the array indicates the number of teams in this game.
404     /// @return Game ID of the newly created game.
405     function createGame(string _name, bytes32[] _teamNames)
406         external
407         isHuman()
408         onlyDevOrOwner()
409         returns(uint256)
410     {
411         uint256 _gameID = gameIDIndex_;
412         gameIDIndex_++;
413 
414         // initialize game
415         game_[_gameID].name = _name;
416 
417         // initialize each team
418         uint256 _nt = _teamNames.length;
419         require(_nt > 0, "number of teams must be larger than 0");
420 
421         game_[_gameID].numberOfTeams = _nt;
422         for (uint256 i = 0; i < _nt; i++) {
423             teams_[_gameID][i] = BMDatasets.Team(_teamNames[i], 0, 0, 0, 0);
424         }
425 
426         emit onGameCreated(_gameID, now);
427 
428         return _gameID;
429     }
430 
431 
432     /// @notice Activate a game. Only owner(s) can do this.
433     /// Players can start buying keys after start time.
434     /// Emits "onGameActivated" event.
435     /// @param _gameID Game ID of the game.
436     /// @param _startTime Timestamp of the start time.
437     function activate(uint256 _gameID, uint256 _startTime)
438         external
439         isHuman()
440         onlyDevOrOwner()
441     {
442         require(_gameID < gameIDIndex_, "incorrect game id");
443         require(game_[_gameID].gameStartTime == 0, "already activated");
444         
445         // TODO: do some initialization
446         game_[_gameID].gameStartTime = _startTime;
447 
448         emit onGameActivated(_gameID, _startTime, now);
449     }
450 
451 
452     /// @notice Buy keys for each team.
453     /// Emits "onPurchase" for each team with a purchase.
454     /// @param _gameID Game ID of the game to buy tickets.
455     /// @param _teamEth Array consisting amount of ETH for each team to buy tickets.
456     /// The size of the array must be the same as the number of teams.
457     /// The paid ETH along with this function call must be the same as the sum of all
458     /// ETH in this array.
459     /// @param _affCode Affiliate code used for this transaction. Use 0 if no affiliate
460     /// code is used.
461     function buysXid(uint256 _gameID, uint256[] memory _teamEth)
462         public
463         payable
464         isActivated(_gameID)
465         isOngoing(_gameID)
466         isNotPaused(_gameID)
467         isNotClosed(_gameID)
468         isHuman()
469         isWithinLimits(msg.value)
470     {
471         // fetch player id
472         uint256 _pID = BMBook.getPlayerID(msg.sender);
473         
474         // purchase keys for each team
475         buysCore(_gameID, _pID, _teamEth);
476     }
477 
478 
479     /// @notice Pause a game. Only owner(s) can do this.
480     /// Players can't buy tickets if a game is paused.
481     /// Emits "onGamePaused" event.
482     /// @param _gameID Game ID of the game.
483     /// @param _paused "true" to pause this game, "false" to unpause.
484     function pauseGame(uint256 _gameID, bool _paused)
485         external
486         isActivated(_gameID)
487         isOngoing(_gameID)
488         onlyDevOrOwner()
489     {
490         game_[_gameID].paused = _paused;
491 
492         emit onGamePaused(_gameID, _paused, now);
493     }
494 
495 
496     /// @notice Set a closing time for betting. Only owner(s) can do this.
497     /// Players can't buy tickets for this game once the closing time is passed.
498     /// Emits "onChangeCloseTime" event.
499     /// @param _gameID Game ID of the game.
500     /// @param _closeTime Timestamp of the closing time.
501     function setCloseTime(uint256 _gameID, uint256 _closeTime)
502         external
503         isActivated(_gameID)
504         isOngoing(_gameID)
505         onlyDevOrOwner()
506     {
507         game_[_gameID].closeTime = _closeTime;
508 
509         emit onChangeCloseTime(_gameID, _closeTime, now);
510     }
511 
512 
513     /// @notice Select a winning team. Only owner(s) can do this.
514     /// Players can't no longer buy tickets for this game once a winning team is selected.
515     /// Players who bought tickets for the winning team are able to withdraw winnings.
516     /// Emits "onGameEnded" event.
517     /// @param _gameID Game ID of the game.
518     /// @param _team Team ID of the winning team.
519     /// @param _comment A closing comment to describe the conclusion of the game.
520     /// @param _deadline Timestamp of the withdraw deadline of the game
521     function settleGame(uint256 _gameID, uint256 _team, string _comment, uint256 _deadline)
522         external
523         isActivated(_gameID)
524         isOngoing(_gameID)
525         isValidTeam(_gameID, _team)
526         onlyDevOrOwner()
527     {
528         // TODO: check deadline limit
529         require(_deadline >= now + 86400, "deadline must be more than one day later.");
530 
531         game_[_gameID].ended = true;
532         game_[_gameID].winnerTeam = _team;
533         game_[_gameID].gameEndComment = _comment;
534         game_[_gameID].withdrawDeadline = _deadline;
535 
536         if (teams_[_gameID][_team].keys == 0) {
537             // no one bought winning keys, send pot to community
538             uint256 _totalPot = (gameStatus_[_gameID].winningVaultInst).add(gameStatus_[_gameID].winningVaultFinal);
539             gameStatus_[_gameID].totalWithdrawn = _totalPot;
540             if (_totalPot > 0) {
541                 Banker_Address.deposit.value(_totalPot)();
542             }
543         }
544 
545         emit BMEvents.onGameEnded(_gameID, _team, _comment, now);
546     }
547 
548 
549     /// @notice Cancel a game. Only owner(s) can do this.
550     /// Players can't no longer buy tickets for this game once a winning team is selected.
551     /// Players who bought tickets can get back 95% of the ETH paid.
552     /// Emits "onGameCancelled" event.
553     /// @param _gameID Game ID of the game.
554     /// @param _comment A closing comment to describe the conclusion of the game.
555     /// @param _deadline Timestamp of the withdraw deadline of the game
556     function cancelGame(uint256 _gameID, string _comment, uint256 _deadline)
557         external
558         isActivated(_gameID)
559         isOngoing(_gameID)
560         onlyDevOrOwner()
561     {
562         // TODO: check deadline limit
563         require(_deadline >= now + 86400, "deadline must be more than one day later.");
564 
565         game_[_gameID].ended = true;
566         game_[_gameID].canceled = true;
567         game_[_gameID].gameEndComment = _comment;
568         game_[_gameID].withdrawDeadline = _deadline;
569 
570         emit BMEvents.onGameCancelled(_gameID, _comment, now);
571     }
572 
573 
574     /// @notice Withdraw winnings. Only available after a game is ended
575     /// (winning team selected or game canceled).
576     /// Emits "onWithdraw" event.
577     /// @param _gameID Game ID of the game.
578     function withdraw(uint256 _gameID)
579         external
580         isHuman()
581         isActivated(_gameID)
582         isEnded(_gameID)
583     {
584         require(now < game_[_gameID].withdrawDeadline, "withdraw deadline already passed");
585         require(gameStatus_[_gameID].fundCleared == false, "fund already cleared");
586 
587         uint256 _pID = BMBook.pIDxAddr_(msg.sender);
588 
589         require(_pID != 0, "player has not played this game");
590         require(players_[_pID][_gameID].withdrawn == false, "player already cashed out");
591 
592         players_[_pID][_gameID].withdrawn = true;
593 
594         if (game_[_gameID].canceled) {
595             // game is canceled
596             // withdraw 95% of the original payments
597             uint256 _totalInvestment = players_[_pID][_gameID].eth.mul(95) / 100;
598             if (_totalInvestment > 0) {
599                 // send to player
600                 BMBook.getPlayerAddr(_pID).transfer(_totalInvestment);
601                 gameStatus_[_gameID].totalWithdrawn = _totalInvestment.add(gameStatus_[_gameID].totalWithdrawn);
602             }
603 
604             emit BMEvents.onWithdraw(_gameID, _pID, msg.sender, BMBook.getPlayerName(_pID), _totalInvestment, now);
605         } else {
606             uint256 _totalWinnings = getPlayerInstWinning(_gameID, _pID, game_[_gameID].winnerTeam).add(getPlayerPotWinning(_gameID, _pID, game_[_gameID].winnerTeam));
607             if (_totalWinnings > 0) {
608                 // send to player
609                 BMBook.getPlayerAddr(_pID).transfer(_totalWinnings);
610                 gameStatus_[_gameID].totalWithdrawn = _totalWinnings.add(gameStatus_[_gameID].totalWithdrawn);
611             }
612 
613             emit BMEvents.onWithdraw(_gameID, _pID, msg.sender, BMBook.getPlayerName(_pID), _totalWinnings, now);
614         }
615     }
616 
617 
618     /// @notice Clear funds of a game. Only owner(s) can do this, after withdraw deadline
619     /// is passed.
620     /// Emits "onFundCleared" event.
621     /// @param _gameID Game ID of the game.
622     function clearFund(uint256 _gameID)
623         external
624         isHuman()
625         isEnded(_gameID)
626         onlyDevOrOwner()
627     {
628         require(now >= game_[_gameID].withdrawDeadline, "withdraw deadline not passed yet");
629         require(gameStatus_[_gameID].fundCleared == false, "fund already cleared");
630 
631         gameStatus_[_gameID].fundCleared = true;
632 
633         // send remaining fund to community
634         uint256 _totalPot = (gameStatus_[_gameID].winningVaultInst).add(gameStatus_[_gameID].winningVaultFinal);
635         uint256 _amount = _totalPot.sub(gameStatus_[_gameID].totalWithdrawn);
636         if (_amount > 0) {
637             Banker_Address.deposit.value(_amount)();
638         }
639 
640         emit onFundCleared(_gameID, _amount, now);
641     }
642 
643 
644     /// @notice Get a player's current instant pot winnings.
645     /// @param _gameID Game ID of the game.
646     /// @param _pID Player ID of the player.
647     /// @param _team Team ID of the team.
648     /// @return Instant pot winnings of the player for this game and this team.
649     function getPlayerInstWinning(uint256 _gameID, uint256 _pID, uint256 _team)
650         public
651         view
652         isActivated(_gameID)
653         isValidTeam(_gameID, _team)
654         returns(uint256)
655     {
656         return ((((teams_[_gameID][_team].mask).mul(playerTeams_[_pID][_gameID][_team].keys)) / (1000000000000000000)).sub(playerTeams_[_pID][_gameID][_team].mask));
657     }
658 
659 
660     /// @notice Get a player's current final pot winnings.
661     /// @param _gameID Game ID of the game.
662     /// @param _pID Player ID of the player.
663     /// @param _team Team ID of the team.
664     /// @return Final pot winnings of the player for this game and this team.
665     function getPlayerPotWinning(uint256 _gameID, uint256 _pID, uint256 _team)
666         public
667         view
668         isActivated(_gameID)
669         isValidTeam(_gameID, _team)
670         returns(uint256)
671     {
672         if (teams_[_gameID][_team].keys > 0) {
673             return gameStatus_[_gameID].winningVaultFinal.mul(playerTeams_[_pID][_gameID][_team].keys) / teams_[_gameID][_team].keys;
674         } else {
675             return 0;
676         }
677     }
678 
679 
680     /// @notice Get current game status.
681     /// @param _gameID Game ID of the game.
682     /// @return (number of teams, names, keys, eth, current key price for 1 key)
683     function getGameStatus(uint256 _gameID)
684         public
685         view
686         isActivated(_gameID)
687         returns(uint256, bytes32[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
688     {
689         uint256 _nt = game_[_gameID].numberOfTeams;
690         bytes32[] memory _names = new bytes32[](_nt);
691         uint256[] memory _keys = new uint256[](_nt);
692         uint256[] memory _eth = new uint256[](_nt);
693         uint256[] memory _keyPrice = new uint256[](_nt);
694         uint256 i;
695 
696         for (i = 0; i < _nt; i++) {
697             _names[i] = teams_[_gameID][i].name;
698             _keys[i] = teams_[_gameID][i].keys;
699             _eth[i] = teams_[_gameID][i].eth;
700             _keyPrice[i] = getBuyPrice(_gameID, i, 1000000000000000000);
701         }
702 
703         return (_nt, _names, _keys, _eth, _keyPrice);
704     }
705 
706 
707     /// @notice Get player status of a game.
708     /// @param _gameID Game ID of the game.
709     /// @param _pID Player ID of the player.
710     /// @return (name, eth for each team, keys for each team, inst win for each team, pot win for each team)
711     function getPlayerStatus(uint256 _gameID, uint256 _pID)
712         public
713         view
714         isActivated(_gameID)
715         returns(bytes32, uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
716     {
717         uint256 _nt = game_[_gameID].numberOfTeams;
718         uint256[] memory _eth = new uint256[](_nt);
719         uint256[] memory _keys = new uint256[](_nt);
720         uint256[] memory _instWin = new uint256[](_nt);
721         uint256[] memory _potWin = new uint256[](_nt);
722         uint256 i;
723 
724         for (i = 0; i < _nt; i++) {
725             _eth[i] = playerTeams_[_pID][_gameID][i].eth;
726             _keys[i] = playerTeams_[_pID][_gameID][i].keys;
727             _instWin[i] = getPlayerInstWinning(_gameID, _pID, i);
728             _potWin[i] = getPlayerPotWinning(_gameID, _pID, i);
729         }
730         
731         return (BMBook.getPlayerName(_pID), _eth, _keys, _instWin, _potWin);
732     }
733 
734 
735     /// @notice Get the price buyer have to pay for next keys.
736     /// @param _gameID Game ID of the game.
737     /// @param _team Team ID of the team.
738     /// @param _keys Number of keys (in wei).
739     /// @return Price for the number of keys to buy (in wei).
740     function getBuyPrice(uint256 _gameID, uint256 _team, uint256 _keys)
741         public 
742         view
743         isActivated(_gameID)
744         isValidTeam(_gameID, _team)
745         returns(uint256)
746     {                  
747         return ((teams_[_gameID][_team].keys.add(_keys)).ethRec(_keys));
748     }
749 
750 
751     /// @notice Get the prices buyer have to pay for next keys for all teams.
752     /// @param _gameID Game ID of the game.
753     /// @param _keys Array of number of keys (in wei) for all teams.
754     /// @return (total eth, array of prices in wei).
755     function getBuyPrices(uint256 _gameID, uint256[] memory _keys)
756         public
757         view
758         isActivated(_gameID)
759         returns(uint256, uint256[])
760     {
761         uint256 _totalEth = 0;
762         uint256 _nt = game_[_gameID].numberOfTeams;
763         uint256[] memory _eth = new uint256[](_nt);
764         uint256 i;
765 
766         require(_nt == _keys.length, "Incorrect number of teams");
767 
768         for (i = 0; i < _nt; i++) {
769             if (_keys[i] > 0) {
770                 _eth[i] = getBuyPrice(_gameID, i, _keys[i]);
771                 _totalEth = _totalEth.add(_eth[i]);
772             }
773         }
774 
775         return (_totalEth, _eth);
776     }
777     
778 
779     /// @notice Get the number of keys can be bought with an amount of ETH.
780     /// @param _gameID Game ID of the game.
781     /// @param _team Team ID of the team.
782     /// @param _eth Amount of ETH in wei.
783     /// @return Number of keys can be bought (in wei).
784     function getKeysfromETH(uint256 _gameID, uint256 _team, uint256 _eth)
785         public 
786         view
787         isActivated(_gameID)
788         isValidTeam(_gameID, _team)
789         returns(uint256)
790     {                  
791         return (teams_[_gameID][_team].eth).keysRec(_eth);
792     }
793 
794 
795     /// @notice Get all numbers of keys can be bought with amounts of ETH.
796     /// @param _gameID Game ID of the game.
797     /// @param _eths Array of amounts of ETH in wei.
798     /// @return (total keys, array of number of keys in wei).
799     function getKeysFromETHs(uint256 _gameID, uint256[] memory _eths)
800         public
801         view
802         isActivated(_gameID)
803         returns(uint256, uint256[])
804     {
805         uint256 _totalKeys = 0;
806         uint256 _nt = game_[_gameID].numberOfTeams;
807         uint256[] memory _keys = new uint256[](_nt);
808         uint256 i;
809 
810         require(_nt == _eths.length, "Incorrect number of teams");
811 
812         for (i = 0; i < _nt; i++) {
813             if (_eths[i] > 0) {
814                 _keys[i] = getKeysfromETH(_gameID, i, _eths[i]);
815                 _totalKeys = _totalKeys.add(_keys[i]);
816             }
817         }
818 
819         return (_totalKeys, _keys);
820     }
821 
822     /// @dev Buy keys for all teams.
823     /// @param _gameID Game ID of the game.
824     /// @param _pID Player ID of the player.
825     /// @param _teamEth Array of eth paid for each team.
826     function buysCore(uint256 _gameID, uint256 _pID, uint256[] memory _teamEth)
827         private
828     {
829         uint256 _nt = game_[_gameID].numberOfTeams;
830         uint256[] memory _keys = new uint256[](_nt);
831         bytes32 _name = BMBook.getPlayerName(_pID);
832         uint256 _totalEth = 0;
833         uint256 i;
834 
835         require(_teamEth.length == _nt, "Number of teams is not correct");
836 
837         // for all teams...
838         for (i = 0; i < _nt; i++) {
839             if (_teamEth[i] > 0) {
840                 // compute total eth
841                 _totalEth = _totalEth.add(_teamEth[i]);
842 
843                 // compute number of keys to buy
844                 _keys[i] = (teams_[_gameID][i].eth).keysRec(_teamEth[i]);
845 
846                 // update player data
847                 playerTeams_[_pID][_gameID][i].eth = _teamEth[i].add(playerTeams_[_pID][_gameID][i].eth);
848                 playerTeams_[_pID][_gameID][i].keys = _keys[i].add(playerTeams_[_pID][_gameID][i].keys);
849 
850                 // update team data
851                 teams_[_gameID][i].eth = _teamEth[i].add(teams_[_gameID][i].eth);
852                 teams_[_gameID][i].keys = _keys[i].add(teams_[_gameID][i].keys);
853 
854                 emit BMEvents.onPurchase(_gameID, _pID, msg.sender, _name, i, _teamEth[i], _keys[i], now);
855             }
856         }
857 
858         // check assigned ETH for each team is the same as msg.value
859         require(_totalEth == msg.value, "Total ETH is not the same as msg.value");        
860             
861         // update game data and player data
862         gameStatus_[_gameID].totalEth = _totalEth.add(gameStatus_[_gameID].totalEth);
863         players_[_pID][_gameID].eth = _totalEth.add(players_[_pID][_gameID].eth);
864 
865         distributeAll(_gameID, _pID, _totalEth, _keys);
866     }
867 
868 
869     /// @dev Distribute paid ETH to different pots.
870     /// @param _gameID Game ID of the game.
871     /// @param _pID Player ID of the player.
872     /// @param _totalEth Total ETH paid.
873     /// @param _keys Array of keys bought for each team.
874     function distributeAll(uint256 _gameID, uint256 _pID, uint256 _totalEth, uint256[] memory _keys)
875         private
876     {
877         // community 5%
878         uint256 _com = _totalEth / 20;
879 
880         // instant pot (15%)
881         uint256 _instPot = _totalEth.mul(15) / 100;
882 
883         // winning pot (80%)
884         uint256 _pot = _totalEth.mul(80) / 100;
885 
886         // Send community to forwarder
887 
888         Banker_Address.deposit.value(_com)();
889 
890         gameStatus_[_gameID].winningVaultInst = _instPot.add(gameStatus_[_gameID].winningVaultInst);
891         gameStatus_[_gameID].winningVaultFinal = _pot.add(gameStatus_[_gameID].winningVaultFinal);
892 
893         // update masks for instant winning vault
894         uint256 _nt = _keys.length;
895         for (uint256 i = 0; i < _nt; i++) {
896             uint256 _newPot = _instPot.add(teams_[_gameID][i].dust);
897             uint256 _dust = updateMasks(_gameID, _pID, i, _newPot, _keys[i]);
898             teams_[_gameID][i].dust = _dust;
899         }
900     }
901 
902 
903     /// @dev Updates masks for instant pot.
904     /// @param _gameID Game ID of the game.
905     /// @param _pID Player ID of the player.
906     /// @param _team Team ID of the team.
907     /// @param _gen Amount of ETH to be added into instant pot.
908     /// @param _keys Number of keys bought.
909     /// @return Dust left over.
910     function updateMasks(uint256 _gameID, uint256 _pID, uint256 _team, uint256 _gen, uint256 _keys)
911         private
912         returns(uint256)
913     {
914         /* MASKING NOTES
915             earnings masks are a tricky thing for people to wrap their minds around.
916             the basic thing to understand here.  is were going to have a global
917             tracker based on profit per share for each round, that increases in
918             relevant proportion to the increase in share supply.
919             
920             the player will have an additional mask that basically says "based
921             on the rounds mask, my shares, and how much i've already withdrawn,
922             how much is still owed to me?"
923         */
924         
925         // calc profit per key & round mask based on this buy:  (dust goes to pot)
926         if (teams_[_gameID][_team].keys > 0) {
927             uint256 _ppt = (_gen.mul(1000000000000000000)) / (teams_[_gameID][_team].keys);
928             teams_[_gameID][_team].mask = _ppt.add(teams_[_gameID][_team].mask);
929 
930             updatePlayerMask(_gameID, _pID, _team, _ppt, _keys);
931 
932             // calculate & return dust
933             return(_gen.sub((_ppt.mul(teams_[_gameID][_team].keys)) / (1000000000000000000)));
934         } else {
935             return _gen;
936         }
937     }
938 
939 
940     /// @dev Updates masks for the player.
941     /// @param _gameID Game ID of the game.
942     /// @param _pID Player ID of the player.
943     /// @param _team Team ID of the team.
944     /// @param _ppt Amount of unit ETH.
945     /// @param _keys Number of keys bought.
946     /// @return Dust left over.
947     function updatePlayerMask(uint256 _gameID, uint256 _pID, uint256 _team, uint256 _ppt, uint256 _keys)
948         private
949     {
950         if (_keys > 0) {
951             // calculate player earning from their own buy (only based on the keys
952             // they just bought).  & update player earnings mask
953             uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
954             playerTeams_[_pID][_gameID][_team].mask = (((teams_[_gameID][_team].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(playerTeams_[_pID][_gameID][_team].mask);
955         }
956     }
957 
958     /**
959     * @dev Allows the current owner to transfer Banker_Address to a new banker.
960     * @param banker The address to transfer Banker_Address to.
961     */
962     function transferBanker(BMForwarderInterface banker) 
963     public
964     onlyOwner()
965     {
966         if (banker != address(0)) {
967             Banker_Address = banker;
968         }
969     }
970 
971 
972     /// @dev Check if a game is activated.
973     /// @param _gameID Game ID of the game.
974     modifier isActivated(uint256 _gameID) {
975         require(game_[_gameID].gameStartTime > 0, "Not activated yet");
976         require(game_[_gameID].gameStartTime <= now, "game not started yet");
977         _;
978     }
979 
980 
981     /// @dev Check if a game is not paused.
982     /// @param _gameID Game ID of the game.
983     modifier isNotPaused(uint256 _gameID) {
984         require(game_[_gameID].paused == false, "game is paused");
985         _;
986     }
987 
988 
989     /// @dev Check if a game is not closed.
990     /// @param _gameID Game ID of the game.
991     modifier isNotClosed(uint256 _gameID) {
992         require(game_[_gameID].closeTime == 0 || game_[_gameID].closeTime > now, "game is closed");
993         _;
994     }
995 
996 
997     /// @dev Check if a game is not settled.
998     /// @param _gameID Game ID of the game.
999     modifier isOngoing(uint256 _gameID) {
1000         require(game_[_gameID].ended == false, "game is ended");
1001         _;
1002     }
1003 
1004 
1005     /// @dev Check if a game is settled.
1006     /// @param _gameID Game ID of the game.
1007     modifier isEnded(uint256 _gameID) {
1008         require(game_[_gameID].ended == true, "game is not ended");
1009         _;
1010     }
1011 
1012 
1013     /// @dev Check if caller is not a smart contract.
1014     modifier isHuman() {
1015         address _addr = msg.sender;
1016         require (_addr == tx.origin, "Human only");
1017 
1018         uint256 _codeLength;
1019         assembly { _codeLength := extcodesize(_addr) }
1020         require(_codeLength == 0, "Human only");
1021         _;
1022     }
1023 
1024 
1025     /// @dev Check if purchase is within limits.
1026     /// (between 0.000000001 ETH and 100000 ETH)
1027     /// @param _eth Amount of ETH
1028     modifier isWithinLimits(uint256 _eth) {
1029         require(_eth >= 1000000000, "too little money");
1030         require(_eth <= 100000000000000000000000, "too much money");
1031         _;    
1032     }
1033 
1034 
1035     /// @dev Check if team ID is valid.
1036     /// @param _gameID Game ID of the game.
1037     /// @param _team Team ID of the team.
1038     modifier isValidTeam(uint256 _gameID, uint256 _team) {
1039         require(_team < game_[_gameID].numberOfTeams, "there is no such team");
1040         _;
1041     }
1042 }