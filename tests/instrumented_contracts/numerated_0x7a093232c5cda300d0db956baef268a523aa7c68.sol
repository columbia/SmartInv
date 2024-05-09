1 pragma solidity 0.4.25;
2 
3 /// @title Events used in FomoSport
4 contract FSEvents {
5 
6     event onGameCreated(
7         uint256 indexed gameID,
8         uint256 timestamp
9     );
10 
11     event onGameActivated(
12         uint256 indexed gameID,
13         uint256 startTime,
14         uint256 timestamp
15     );
16 
17     event onGamePaused(
18         uint256 indexed gameID,
19         bool paused,
20         uint256 timestamp
21     );
22 
23     event onChangeCloseTime(
24         uint256 indexed gameID,
25         uint256 closeTimestamp,
26         uint256 timestamp
27     );
28 
29     event onPurchase(
30         uint256 indexed gameID,
31         uint256 indexed playerID,
32         address playerAddress,
33         bytes32 playerName,
34         uint256 teamID,
35         uint256 ethIn,
36         uint256 keysBought,
37         uint256 affID,
38         uint256 timestamp
39     );
40 
41     event onComment(
42         uint256 indexed gameID,
43         uint256 indexed playerID,
44         address playerAddress,
45         bytes32 playerName,
46         uint256 ethIn,
47         string comment,
48         uint256 timestamp
49     );
50 
51     event onWithdraw(
52         uint256 indexed gameID,
53         uint256 indexed playerID,
54         address playerAddress,
55         bytes32 playerName,
56         uint256 ethOut,
57         uint256 timestamp
58     );
59 
60     event onGameEnded(
61         uint256 indexed gameID,
62         uint256 winningTeamID,
63         string comment,
64         uint256 timestamp
65     );
66 
67     event onGameCancelled(
68         uint256 indexed gameID,
69         string comment,
70         uint256 timestamp
71     );
72 
73     event onFundCleared(
74         uint256 indexed gameID,
75         uint256 fundCleared,
76         uint256 timestamp
77     );
78 }
79 
80 
81 /// @title A raffle system for sports betting, designed with FOMO elements
82 /// @notice This contract manages multiple games. Owner(s) can create games and
83 /// assign winning team for each game. Players can withdraw their winnings before
84 /// the deadline set by the owner(s). If there's no winning team, the owner(s)
85 /// can also cancel a game so the players get back their bettings (minus fees).
86 /// @dev The address of the forwarder, player book, and owner(s) are hardcoded.
87 /// Check 'TODO' before deploy.
88 contract FomoSport is FSEvents {
89     using FSKeyCalc for *;
90     using SafeMath for *;
91 
92     // TODO: check address!!
93     FSInterfaceForForwarder constant private FSKingCorp = FSInterfaceForForwarder(0x3a2321DDC991c50518969B93d2C6B76bf5309790);
94     FSBookInterface constant private FSBook = FSBookInterface(0xb440cF08BC2C78C33f3D29726d6c8ba5cBaA4B91);
95 
96     string constant public name_ = "FomoSport";
97     uint256 public gameIDIndex_;
98     
99     // (gameID => gameData)
100     mapping(uint256 => FSdatasets.Game) public game_;
101 
102     // (gameID => gameStatus)
103     mapping(uint256 => FSdatasets.GameStatus) public gameStatus_;
104 
105     // (gameID => (teamID => teamData))
106     mapping(uint256 => mapping(uint256 => FSdatasets.Team)) public teams_;
107 
108     // (playerID => (gameID => playerData))
109     mapping(uint256 => mapping(uint256 => FSdatasets.Player)) public players_;
110 
111     // (playerID => (gameID => (teamID => playerTeamData)))
112     mapping(uint256 => mapping(uint256 => mapping(uint256 => FSdatasets.PlayerTeam))) public playerTeams_;
113 
114     // (gameID => (commentID => commentData))
115     mapping(uint256 => mapping(uint256 => FSdatasets.PlayerComment)) public playerComments_;
116 
117     // (gameID => numberOfComments)
118     mapping(uint256 => uint256) public playerCommentsIndex_;
119 
120 
121     constructor() public {
122         gameIDIndex_ = 1;
123     }
124 
125 
126     /// @notice Create a game. Only owner(s) can call this function.
127     /// Emits "onGameCreated" event.
128     /// @param _name Name of the new game.
129     /// @param _teamNames Array consisting names of all teams in the game.
130     /// The size of the array indicates the number of teams in this game.
131     /// @return Game ID of the newly created game.
132     function createGame(string _name, bytes32[] _teamNames)
133         external
134         isHuman()
135         isOwner()
136         returns(uint256)
137     {
138         uint256 _gameID = gameIDIndex_;
139         gameIDIndex_++;
140 
141         // initialize game
142         game_[_gameID].name = _name;
143 
144         // initialize each team
145         uint256 _nt = _teamNames.length;
146         require(_nt > 0, "number of teams must be larger than 0");
147 
148         game_[_gameID].numberOfTeams = _nt;
149         for (uint256 i = 0; i < _nt; i++) {
150             teams_[_gameID][i] = FSdatasets.Team(_teamNames[i], 0, 0, 0, 0);
151         }
152 
153         emit onGameCreated(_gameID, now);
154 
155         return _gameID;
156     }
157 
158 
159     /// @notice Activate a game. Only owner(s) can do this.
160     /// Players can start buying keys after start time.
161     /// Emits "onGameActivated" event.
162     /// @param _gameID Game ID of the game.
163     /// @param _startTime Timestamp of the start time.
164     function activate(uint256 _gameID, uint256 _startTime)
165         external
166         isHuman()
167         isOwner()
168     {
169         require(_gameID < gameIDIndex_, "incorrect game id");
170         require(game_[_gameID].gameStartTime == 0, "already activated");
171         
172         // TODO: do some initialization
173         game_[_gameID].gameStartTime = _startTime;
174 
175         emit onGameActivated(_gameID, _startTime, now);
176     }
177 
178 
179     /// @notice Buy keys for each team.
180     /// Emits "onPurchase" for each team with a purchase.
181     /// Emits "onComment" if there's a valid comment.
182     /// @param _gameID Game ID of the game to buy tickets.
183     /// @param _teamEth Array consisting amount of ETH for each team to buy tickets.
184     /// The size of the array must be the same as the number of teams.
185     /// The paid ETH along with this function call must be the same as the sum of all
186     /// ETH in this array.
187     /// @param _affCode Affiliate code used for this transaction. Use 0 if no affiliate
188     /// code is used.
189     /// @param _comment A string comment passed along with this transaction. Only
190     /// valid when paid more than 0.001 ETH.
191     function buysXid(uint256 _gameID, uint256[] memory _teamEth, uint256 _affCode, string memory _comment)
192         public
193         payable
194         isActivated(_gameID)
195         isOngoing(_gameID)
196         isNotPaused(_gameID)
197         isNotClosed(_gameID)
198         isHuman()
199         isWithinLimits(msg.value)
200     {
201         // fetch player id
202         uint256 _pID = FSBook.getPlayerID(msg.sender);
203         
204         uint256 _affID;
205         if (_affCode != 0 && _affCode != _pID) {
206             // update last affiliate 
207             FSBook.setPlayerLAff(_pID, _affCode);
208             _affID = _affCode;
209         } else {
210             _affID = FSBook.getPlayerLAff(_pID);
211         }
212         
213         // purchase keys for each team
214         buysCore(_gameID, _pID, _teamEth, _affID);
215 
216         // handle comment
217         handleComment(_gameID, _pID, _comment);
218     }
219 
220 
221     /// @notice Pause a game. Only owner(s) can do this.
222     /// Players can't buy tickets if a game is paused.
223     /// Emits "onGamePaused" event.
224     /// @param _gameID Game ID of the game.
225     /// @param _paused "true" to pause this game, "false" to unpause.
226     function pauseGame(uint256 _gameID, bool _paused)
227         external
228         isActivated(_gameID)
229         isOngoing(_gameID)
230         isOwner()
231     {
232         game_[_gameID].paused = _paused;
233 
234         emit onGamePaused(_gameID, _paused, now);
235     }
236 
237 
238     /// @notice Set a closing time for betting. Only owner(s) can do this.
239     /// Players can't buy tickets for this game once the closing time is passed.
240     /// Emits "onChangeCloseTime" event.
241     /// @param _gameID Game ID of the game.
242     /// @param _closeTime Timestamp of the closing time.
243     function setCloseTime(uint256 _gameID, uint256 _closeTime)
244         external
245         isActivated(_gameID)
246         isOngoing(_gameID)
247         isOwner()
248     {
249         game_[_gameID].closeTime = _closeTime;
250 
251         emit onChangeCloseTime(_gameID, _closeTime, now);
252     }
253 
254 
255     /// @notice Select a winning team. Only owner(s) can do this.
256     /// Players can't no longer buy tickets for this game once a winning team is selected.
257     /// Players who bought tickets for the winning team are able to withdraw winnings.
258     /// Emits "onGameEnded" event.
259     /// @param _gameID Game ID of the game.
260     /// @param _team Team ID of the winning team.
261     /// @param _comment A closing comment to describe the conclusion of the game.
262     /// @param _deadline Timestamp of the withdraw deadline of the game
263     function settleGame(uint256 _gameID, uint256 _team, string _comment, uint256 _deadline)
264         external
265         isActivated(_gameID)
266         isOngoing(_gameID)
267         isValidTeam(_gameID, _team)
268         isOwner()
269     {
270         // TODO: check deadline limit
271         require(_deadline >= now + 86400, "deadline must be more than one day later.");
272 
273         game_[_gameID].ended = true;
274         game_[_gameID].winnerTeam = _team;
275         game_[_gameID].gameEndComment = _comment;
276         game_[_gameID].withdrawDeadline = _deadline;
277 
278         if (teams_[_gameID][_team].keys == 0) {
279             // no one bought winning keys, send pot to community
280             uint256 _totalPot = (gameStatus_[_gameID].winningVaultInst).add(gameStatus_[_gameID].winningVaultFinal);
281             gameStatus_[_gameID].totalWithdrawn = _totalPot;
282             if (_totalPot > 0) {
283                 FSKingCorp.deposit.value(_totalPot)();
284             }
285         }
286 
287         emit FSEvents.onGameEnded(_gameID, _team, _comment, now);
288     }
289 
290 
291     /// @notice Cancel a game. Only owner(s) can do this.
292     /// Players can't no longer buy tickets for this game once a winning team is selected.
293     /// Players who bought tickets can get back 95% of the ETH paid.
294     /// Emits "onGameCancelled" event.
295     /// @param _gameID Game ID of the game.
296     /// @param _comment A closing comment to describe the conclusion of the game.
297     /// @param _deadline Timestamp of the withdraw deadline of the game
298     function cancelGame(uint256 _gameID, string _comment, uint256 _deadline)
299         external
300         isActivated(_gameID)
301         isOngoing(_gameID)
302         isOwner()
303     {
304         // TODO: check deadline limit
305         require(_deadline >= now + 86400, "deadline must be more than one day later.");
306 
307         game_[_gameID].ended = true;
308         game_[_gameID].canceled = true;
309         game_[_gameID].gameEndComment = _comment;
310         game_[_gameID].withdrawDeadline = _deadline;
311 
312         emit FSEvents.onGameCancelled(_gameID, _comment, now);
313     }
314 
315 
316     /// @notice Withdraw winnings. Only available after a game is ended
317     /// (winning team selected or game canceled).
318     /// Emits "onWithdraw" event.
319     /// @param _gameID Game ID of the game.
320     function withdraw(uint256 _gameID)
321         external
322         isHuman()
323         isActivated(_gameID)
324         isEnded(_gameID)
325     {
326         require(now < game_[_gameID].withdrawDeadline, "withdraw deadline already passed");
327         require(gameStatus_[_gameID].fundCleared == false, "fund already cleared");
328 
329         uint256 _pID = FSBook.pIDxAddr_(msg.sender);
330 
331         require(_pID != 0, "player has not played this game");
332         require(players_[_pID][_gameID].withdrawn == false, "player already cashed out");
333 
334         players_[_pID][_gameID].withdrawn = true;
335 
336         if (game_[_gameID].canceled) {
337             // game is canceled
338             // withdraw 95% of the original payments
339             uint256 _totalInvestment = players_[_pID][_gameID].eth.mul(95) / 100;
340             if (_totalInvestment > 0) {
341                 // send to player
342                 FSBook.getPlayerAddr(_pID).transfer(_totalInvestment);
343                 gameStatus_[_gameID].totalWithdrawn = _totalInvestment.add(gameStatus_[_gameID].totalWithdrawn);
344             }
345 
346             emit FSEvents.onWithdraw(_gameID, _pID, msg.sender, FSBook.getPlayerName(_pID), _totalInvestment, now);
347         } else {
348             uint256 _totalWinnings = getPlayerInstWinning(_gameID, _pID, game_[_gameID].winnerTeam).add(getPlayerPotWinning(_gameID, _pID, game_[_gameID].winnerTeam));
349             if (_totalWinnings > 0) {
350                 // send to player
351                 FSBook.getPlayerAddr(_pID).transfer(_totalWinnings);
352                 gameStatus_[_gameID].totalWithdrawn = _totalWinnings.add(gameStatus_[_gameID].totalWithdrawn);
353             }
354 
355             emit FSEvents.onWithdraw(_gameID, _pID, msg.sender, FSBook.getPlayerName(_pID), _totalWinnings, now);
356         }
357     }
358 
359 
360     /// @notice Clear funds of a game. Only owner(s) can do this, after withdraw deadline
361     /// is passed.
362     /// Emits "onFundCleared" event.
363     /// @param _gameID Game ID of the game.
364     function clearFund(uint256 _gameID)
365         external
366         isHuman()
367         isEnded(_gameID)
368         isOwner()
369     {
370         require(now >= game_[_gameID].withdrawDeadline, "withdraw deadline not passed yet");
371         require(gameStatus_[_gameID].fundCleared == false, "fund already cleared");
372 
373         gameStatus_[_gameID].fundCleared = true;
374 
375         // send remaining fund to community
376         uint256 _totalPot = (gameStatus_[_gameID].winningVaultInst).add(gameStatus_[_gameID].winningVaultFinal);
377         uint256 _amount = _totalPot.sub(gameStatus_[_gameID].totalWithdrawn);
378         if (_amount > 0) {
379             FSKingCorp.deposit.value(_amount)();
380         }
381 
382         emit onFundCleared(_gameID, _amount, now);
383     }
384 
385 
386     /// @notice Get a player's current instant pot winnings.
387     /// @param _gameID Game ID of the game.
388     /// @param _pID Player ID of the player.
389     /// @param _team Team ID of the team.
390     /// @return Instant pot winnings of the player for this game and this team.
391     function getPlayerInstWinning(uint256 _gameID, uint256 _pID, uint256 _team)
392         public
393         view
394         isActivated(_gameID)
395         isValidTeam(_gameID, _team)
396         returns(uint256)
397     {
398         return ((((teams_[_gameID][_team].mask).mul(playerTeams_[_pID][_gameID][_team].keys)) / (1000000000000000000)).sub(playerTeams_[_pID][_gameID][_team].mask));
399     }
400 
401 
402     /// @notice Get a player's current final pot winnings.
403     /// @param _gameID Game ID of the game.
404     /// @param _pID Player ID of the player.
405     /// @param _team Team ID of the team.
406     /// @return Final pot winnings of the player for this game and this team.
407     function getPlayerPotWinning(uint256 _gameID, uint256 _pID, uint256 _team)
408         public
409         view
410         isActivated(_gameID)
411         isValidTeam(_gameID, _team)
412         returns(uint256)
413     {
414         if (teams_[_gameID][_team].keys > 0) {
415             return gameStatus_[_gameID].winningVaultFinal.mul(playerTeams_[_pID][_gameID][_team].keys) / teams_[_gameID][_team].keys;
416         } else {
417             return 0;
418         }
419     }
420 
421 
422     /// @notice Get current game status.
423     /// @param _gameID Game ID of the game.
424     /// @return (number of teams, names, keys, eth, current key price for 1 key)
425     function getGameStatus(uint256 _gameID)
426         public
427         view
428         isActivated(_gameID)
429         returns(uint256, bytes32[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
430     {
431         uint256 _nt = game_[_gameID].numberOfTeams;
432         bytes32[] memory _names = new bytes32[](_nt);
433         uint256[] memory _keys = new uint256[](_nt);
434         uint256[] memory _eth = new uint256[](_nt);
435         uint256[] memory _keyPrice = new uint256[](_nt);
436         uint256 i;
437 
438         for (i = 0; i < _nt; i++) {
439             _names[i] = teams_[_gameID][i].name;
440             _keys[i] = teams_[_gameID][i].keys;
441             _eth[i] = teams_[_gameID][i].eth;
442             _keyPrice[i] = getBuyPrice(_gameID, i, 1000000000000000000);
443         }
444 
445         return (_nt, _names, _keys, _eth, _keyPrice);
446     }
447 
448 
449     /// @notice Get player status of a game.
450     /// @param _gameID Game ID of the game.
451     /// @param _pID Player ID of the player.
452     /// @return (name, eth for each team, keys for each team, inst win for each team, pot win for each team)
453     function getPlayerStatus(uint256 _gameID, uint256 _pID)
454         public
455         view
456         isActivated(_gameID)
457         returns(bytes32, uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
458     {
459         uint256 _nt = game_[_gameID].numberOfTeams;
460         uint256[] memory _eth = new uint256[](_nt);
461         uint256[] memory _keys = new uint256[](_nt);
462         uint256[] memory _instWin = new uint256[](_nt);
463         uint256[] memory _potWin = new uint256[](_nt);
464         uint256 i;
465 
466         for (i = 0; i < _nt; i++) {
467             _eth[i] = playerTeams_[_pID][_gameID][i].eth;
468             _keys[i] = playerTeams_[_pID][_gameID][i].keys;
469             _instWin[i] = getPlayerInstWinning(_gameID, _pID, i);
470             _potWin[i] = getPlayerPotWinning(_gameID, _pID, i);
471         }
472         
473         return (FSBook.getPlayerName(_pID), _eth, _keys, _instWin, _potWin);
474     }
475 
476 
477     /// @notice Get the price buyer have to pay for next keys.
478     /// @param _gameID Game ID of the game.
479     /// @param _team Team ID of the team.
480     /// @param _keys Number of keys (in wei).
481     /// @return Price for the number of keys to buy (in wei).
482     function getBuyPrice(uint256 _gameID, uint256 _team, uint256 _keys)
483         public 
484         view
485         isActivated(_gameID)
486         isValidTeam(_gameID, _team)
487         returns(uint256)
488     {                  
489         return ((teams_[_gameID][_team].keys.add(_keys)).ethRec(_keys));
490     }
491 
492 
493     /// @notice Get the prices buyer have to pay for next keys for all teams.
494     /// @param _gameID Game ID of the game.
495     /// @param _keys Array of number of keys (in wei) for all teams.
496     /// @return (total eth, array of prices in wei).
497     function getBuyPrices(uint256 _gameID, uint256[] memory _keys)
498         public
499         view
500         isActivated(_gameID)
501         returns(uint256, uint256[])
502     {
503         uint256 _totalEth = 0;
504         uint256 _nt = game_[_gameID].numberOfTeams;
505         uint256[] memory _eth = new uint256[](_nt);
506         uint256 i;
507 
508         require(_nt == _keys.length, "Incorrect number of teams");
509 
510         for (i = 0; i < _nt; i++) {
511             if (_keys[i] > 0) {
512                 _eth[i] = getBuyPrice(_gameID, i, _keys[i]);
513                 _totalEth = _totalEth.add(_eth[i]);
514             }
515         }
516 
517         return (_totalEth, _eth);
518     }
519     
520 
521     /// @notice Get the number of keys can be bought with an amount of ETH.
522     /// @param _gameID Game ID of the game.
523     /// @param _team Team ID of the team.
524     /// @param _eth Amount of ETH in wei.
525     /// @return Number of keys can be bought (in wei).
526     function getKeysfromETH(uint256 _gameID, uint256 _team, uint256 _eth)
527         public 
528         view
529         isActivated(_gameID)
530         isValidTeam(_gameID, _team)
531         returns(uint256)
532     {                  
533         return (teams_[_gameID][_team].eth).keysRec(_eth);
534     }
535 
536 
537     /// @notice Get all numbers of keys can be bought with amounts of ETH.
538     /// @param _gameID Game ID of the game.
539     /// @param _eths Array of amounts of ETH in wei.
540     /// @return (total keys, array of number of keys in wei).
541     function getKeysFromETHs(uint256 _gameID, uint256[] memory _eths)
542         public
543         view
544         isActivated(_gameID)
545         returns(uint256, uint256[])
546     {
547         uint256 _totalKeys = 0;
548         uint256 _nt = game_[_gameID].numberOfTeams;
549         uint256[] memory _keys = new uint256[](_nt);
550         uint256 i;
551 
552         require(_nt == _eths.length, "Incorrect number of teams");
553 
554         for (i = 0; i < _nt; i++) {
555             if (_eths[i] > 0) {
556                 _keys[i] = getKeysfromETH(_gameID, i, _eths[i]);
557                 _totalKeys = _totalKeys.add(_keys[i]);
558             }
559         }
560 
561         return (_totalKeys, _keys);
562     }
563 
564 
565     /// @dev Handle comments.
566     /// @param _gameID Game ID of the game.
567     /// @param _pID Player ID of the player.
568     /// @param _comment Comment to be used.
569     function handleComment(uint256 _gameID, uint256 _pID, string memory _comment)
570         private
571     {
572         bytes memory _commentBytes = bytes(_comment);
573         // comment is empty, do nothing
574         if (_commentBytes.length == 0) {
575             return;
576         }
577 
578         // only handle comments when eth >= 0.001
579         uint256 _totalEth = msg.value;
580         if (_totalEth >= 1000000000000000) {
581             require(_commentBytes.length <= 64, "comment is too long");
582             bytes32 _name = FSBook.getPlayerName(_pID);
583 
584             playerComments_[_gameID][playerCommentsIndex_[_gameID]] = FSdatasets.PlayerComment(_pID, _name, _totalEth, _comment);
585             playerCommentsIndex_[_gameID] ++;
586 
587             emit onComment(_gameID, _pID, msg.sender, _name, _totalEth, _comment, now);
588         }
589     }
590 
591 
592     /// @dev Buy keys for all teams.
593     /// @param _gameID Game ID of the game.
594     /// @param _pID Player ID of the player.
595     /// @param _teamEth Array of eth paid for each team.
596     /// @param _affID Affiliate ID
597     function buysCore(uint256 _gameID, uint256 _pID, uint256[] memory _teamEth, uint256 _affID)
598         private
599     {
600         uint256 _nt = game_[_gameID].numberOfTeams;
601         uint256[] memory _keys = new uint256[](_nt);
602         bytes32 _name = FSBook.getPlayerName(_pID);
603         uint256 _totalEth = 0;
604         uint256 i;
605 
606         require(_teamEth.length == _nt, "Number of teams is not correct");
607 
608         // for all teams...
609         for (i = 0; i < _nt; i++) {
610             if (_teamEth[i] > 0) {
611                 // compute total eth
612                 _totalEth = _totalEth.add(_teamEth[i]);
613 
614                 // compute number of keys to buy
615                 _keys[i] = (teams_[_gameID][i].eth).keysRec(_teamEth[i]);
616 
617                 // update player data
618                 playerTeams_[_pID][_gameID][i].eth = _teamEth[i].add(playerTeams_[_pID][_gameID][i].eth);
619                 playerTeams_[_pID][_gameID][i].keys = _keys[i].add(playerTeams_[_pID][_gameID][i].keys);
620 
621                 // update team data
622                 teams_[_gameID][i].eth = _teamEth[i].add(teams_[_gameID][i].eth);
623                 teams_[_gameID][i].keys = _keys[i].add(teams_[_gameID][i].keys);
624 
625                 emit FSEvents.onPurchase(_gameID, _pID, msg.sender, _name, i, _teamEth[i], _keys[i], _affID, now);
626             }
627         }
628 
629         // check assigned ETH for each team is the same as msg.value
630         require(_totalEth == msg.value, "Total ETH is not the same as msg.value");        
631             
632         // update game data and player data
633         gameStatus_[_gameID].totalEth = _totalEth.add(gameStatus_[_gameID].totalEth);
634         players_[_pID][_gameID].eth = _totalEth.add(players_[_pID][_gameID].eth);
635 
636         distributeAll(_gameID, _pID, _affID, _totalEth, _keys);
637     }
638 
639 
640     /// @dev Distribute paid ETH to different pots.
641     /// @param _gameID Game ID of the game.
642     /// @param _pID Player ID of the player.
643     /// @param _affID Affiliate ID used for this transasction.
644     /// @param _totalEth Total ETH paid.
645     /// @param _keys Array of keys bought for each team.
646     function distributeAll(uint256 _gameID, uint256 _pID, uint256 _affID, uint256 _totalEth, uint256[] memory _keys)
647         private
648     {
649         // community 2%
650         uint256 _com = _totalEth / 50;
651 
652         // distribute 3% to aff
653         uint256 _aff = _totalEth.mul(3) / 100;
654         _com = _com.add(handleAffiliate(_pID, _affID, _aff));
655 
656         // instant pot (15%)
657         uint256 _instPot = _totalEth.mul(15) / 100;
658 
659         // winning pot (80%)
660         uint256 _pot = _totalEth.mul(80) / 100;
661 
662         // Send community to forwarder
663         if (!address(FSKingCorp).call.value(_com)(abi.encode("deposit()"))) {
664             // if unable to deposit, add to pot
665             _pot = _pot.add(_com);
666         }
667 
668         gameStatus_[_gameID].winningVaultInst = _instPot.add(gameStatus_[_gameID].winningVaultInst);
669         gameStatus_[_gameID].winningVaultFinal = _pot.add(gameStatus_[_gameID].winningVaultFinal);
670 
671         // update masks for instant winning vault
672         uint256 _nt = _keys.length;
673         for (uint256 i = 0; i < _nt; i++) {
674             uint256 _newPot = _instPot.add(teams_[_gameID][i].dust);
675             uint256 _dust = updateMasks(_gameID, _pID, i, _newPot, _keys[i]);
676             teams_[_gameID][i].dust = _dust;
677         }
678     }
679 
680 
681     /// @dev Handle affiliate payments.
682     /// @param _pID Player ID of the player.
683     /// @param _affID Affiliate ID used for this transasction.
684     /// @param _aff Amount of ETH for affiliate payment.
685     /// @return The amount remained for the community (if there's no affiliate payment)
686     function handleAffiliate(uint256 _pID, uint256 _affID, uint256 _aff)
687         private
688         returns (uint256)
689     {
690         uint256 _com = 0;
691 
692         if (_affID == 0 || _affID == _pID) {
693             _com = _aff;
694         } else if(FSBook.getPlayerHasAff(_affID)) {
695             FSBook.depositAffiliate.value(_aff)(_affID);
696         } else {
697             _com = _aff;
698         }
699 
700         return _com;
701     }
702 
703 
704     /// @dev Updates masks for instant pot.
705     /// @param _gameID Game ID of the game.
706     /// @param _pID Player ID of the player.
707     /// @param _team Team ID of the team.
708     /// @param _gen Amount of ETH to be added into instant pot.
709     /// @param _keys Number of keys bought.
710     /// @return Dust left over.
711     function updateMasks(uint256 _gameID, uint256 _pID, uint256 _team, uint256 _gen, uint256 _keys)
712         private
713         returns(uint256)
714     {
715         /* MASKING NOTES
716             earnings masks are a tricky thing for people to wrap their minds around.
717             the basic thing to understand here.  is were going to have a global
718             tracker based on profit per share for each round, that increases in
719             relevant proportion to the increase in share supply.
720             
721             the player will have an additional mask that basically says "based
722             on the rounds mask, my shares, and how much i've already withdrawn,
723             how much is still owed to me?"
724         */
725         
726         // calc profit per key & round mask based on this buy:  (dust goes to pot)
727         if (teams_[_gameID][_team].keys > 0) {
728             uint256 _ppt = (_gen.mul(1000000000000000000)) / (teams_[_gameID][_team].keys);
729             teams_[_gameID][_team].mask = _ppt.add(teams_[_gameID][_team].mask);
730 
731             updatePlayerMask(_gameID, _pID, _team, _ppt, _keys);
732 
733             // calculate & return dust
734             return(_gen.sub((_ppt.mul(teams_[_gameID][_team].keys)) / (1000000000000000000)));
735         } else {
736             return _gen;
737         }
738     }
739 
740 
741     /// @dev Updates masks for the player.
742     /// @param _gameID Game ID of the game.
743     /// @param _pID Player ID of the player.
744     /// @param _team Team ID of the team.
745     /// @param _ppt Amount of unit ETH.
746     /// @param _keys Number of keys bought.
747     /// @return Dust left over.
748     function updatePlayerMask(uint256 _gameID, uint256 _pID, uint256 _team, uint256 _ppt, uint256 _keys)
749         private
750     {
751         if (_keys > 0) {
752             // calculate player earning from their own buy (only based on the keys
753             // they just bought).  & update player earnings mask
754             uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
755             playerTeams_[_pID][_gameID][_team].mask = (((teams_[_gameID][_team].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(playerTeams_[_pID][_gameID][_team].mask);
756         }
757     }
758 
759 
760     /// @dev Check if a game is activated.
761     /// @param _gameID Game ID of the game.
762     modifier isActivated(uint256 _gameID) {
763         require(game_[_gameID].gameStartTime > 0, "Not activated yet");
764         require(game_[_gameID].gameStartTime <= now, "game not started yet");
765         _;
766     }
767 
768 
769     /// @dev Check if a game is not paused.
770     /// @param _gameID Game ID of the game.
771     modifier isNotPaused(uint256 _gameID) {
772         require(game_[_gameID].paused == false, "game is paused");
773         _;
774     }
775 
776 
777     /// @dev Check if a game is not closed.
778     /// @param _gameID Game ID of the game.
779     modifier isNotClosed(uint256 _gameID) {
780         require(game_[_gameID].closeTime == 0 || game_[_gameID].closeTime > now, "game is closed");
781         _;
782     }
783 
784 
785     /// @dev Check if a game is not settled.
786     /// @param _gameID Game ID of the game.
787     modifier isOngoing(uint256 _gameID) {
788         require(game_[_gameID].ended == false, "game is ended");
789         _;
790     }
791 
792 
793     /// @dev Check if a game is settled.
794     /// @param _gameID Game ID of the game.
795     modifier isEnded(uint256 _gameID) {
796         require(game_[_gameID].ended == true, "game is not ended");
797         _;
798     }
799 
800 
801     /// @dev Check if caller is not a smart contract.
802     modifier isHuman() {
803         address _addr = msg.sender;
804         require (_addr == tx.origin, "Human only");
805 
806         uint256 _codeLength;
807         assembly { _codeLength := extcodesize(_addr) }
808         require(_codeLength == 0, "Human only");
809         _;
810     }
811 
812 
813     // TODO: Check address!!!
814     /// @dev Check if caller is one of the owner(s).
815     modifier isOwner() {
816         require(
817             msg.sender == 0xE3FF68fB79FEE1989FB67Eb04e196E361EcAec3e ||
818             msg.sender == 0xb914843D2E56722a2c133Eff956d1F99b820D468 ||
819             msg.sender == 0xE0b005384dF8F4D80e9a69B6210eC1929A935D97 ||
820             msg.sender == 0xc52FA2C9411fCd4f58be2d6725094689C46242f2
821             , "Only owner can do this");
822         _;
823     }
824 
825 
826     /// @dev Check if purchase is within limits.
827     /// (between 0.000000001 ETH and 100000 ETH)
828     /// @param _eth Amount of ETH
829     modifier isWithinLimits(uint256 _eth) {
830         require(_eth >= 1000000000, "too little money");
831         require(_eth <= 100000000000000000000000, "too much money");
832         _;    
833     }
834 
835 
836     /// @dev Check if team ID is valid.
837     /// @param _gameID Game ID of the game.
838     /// @param _team Team ID of the team.
839     modifier isValidTeam(uint256 _gameID, uint256 _team) {
840         require(_team < game_[_gameID].numberOfTeams, "there is no such team");
841         _;
842     }
843 }
844 
845 // key calculation
846 library FSKeyCalc {
847     using SafeMath for *;
848     
849     /// @dev calculates number of keys received given X eth 
850     /// @param _curEth current amount of eth in contract 
851     /// @param _newEth eth being spent
852     /// @return amount of ticket purchased
853     function keysRec(uint256 _curEth, uint256 _newEth)
854         internal
855         pure
856         returns (uint256)
857     {
858         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
859     }
860 
861 
862     /// @dev calculates amount of eth received if you sold X keys 
863     /// @param _curKeys current amount of keys that exist 
864     /// @param _sellKeys amount of keys you wish to sell
865     /// @return amount of eth received
866     function ethRec(uint256 _curKeys, uint256 _sellKeys)
867         internal
868         pure
869         returns (uint256)
870     {
871         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
872     }
873 
874     /// @dev calculates how many keys would exist with given an amount of eth
875     /// @param _eth eth "in contract"
876     /// @return number of keys that would exist
877     function keys(uint256 _eth) 
878         internal
879         pure
880         returns(uint256)
881     {
882         return ((((((_eth).mul(1000000000000000000)).mul(3125000000000000000000000000)).add(562498828125610351562500000000000000000000000000000000000000000000)).sqrt()).sub(749999218750000000000000000000000)) / (1562500000);
883     }
884     
885     /// @dev calculates how much eth would be in contract given a number of keys
886     /// @param _keys number of keys "in contract" 
887     /// @return eth that would exists
888     function eth(uint256 _keys) 
889         internal
890         pure
891         returns(uint256)
892     {
893         return ((781250000).mul(_keys.sq()).add(((1499998437500000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
894     }
895 }
896 
897 
898 // datasets
899 library FSdatasets {
900 
901     struct Game {
902         string name;                     // game name
903         uint256 numberOfTeams;           // number of teams
904         uint256 gameStartTime;           // game start time (> 0 means activated)
905 
906         bool paused;                     // game paused
907         bool ended;                      // game ended
908         bool canceled;                   // game canceled
909         uint256 winnerTeam;              // winner team        
910         uint256 withdrawDeadline;        // deadline for withdraw fund
911         string gameEndComment;           // comment for game ending or canceling
912         uint256 closeTime;               // betting close time
913     }
914 
915     struct GameStatus {
916         uint256 totalEth;                // total eth invested
917         uint256 totalWithdrawn;          // total withdrawn by players
918         uint256 winningVaultInst;        // current "instant" winning vault
919         uint256 winningVaultFinal;       // current "final" winning vault        
920         bool fundCleared;                // fund already cleared
921     }
922 
923     struct Team {
924         bytes32 name;       // team name
925         uint256 keys;       // number of keys
926         uint256 eth;        // total eth for the team
927         uint256 mask;       // mask of this team
928         uint256 dust;       // dust for winning vault
929     }
930 
931     struct Player {
932         uint256 eth;        // total eth for the game
933         bool withdrawn;     // winnings already withdrawn
934     }
935 
936     struct PlayerTeam {
937         uint256 keys;       // number of keys
938         uint256 eth;        // total eth for the team
939         uint256 mask;       // mask for this team
940     }
941 
942     struct PlayerComment {
943         uint256 playerID;
944         bytes32 playerName;
945         uint256 ethIn;
946         string comment;
947     }
948 }
949 
950 
951 interface FSInterfaceForForwarder {
952     function deposit() external payable returns(bool);
953 }
954 
955 
956 interface FSBookInterface {
957     function pIDxAddr_(address _addr) external returns (uint256);
958     function pIDxName_(bytes32 _name) external returns (uint256);
959 
960     function getPlayerID(address _addr) external returns (uint256);
961     function getPlayerName(uint256 _pID) external view returns (bytes32);
962     function getPlayerLAff(uint256 _pID) external view returns (uint256);
963     function setPlayerLAff(uint256 _pID, uint256 _lAff) external;
964     function getPlayerAffT2(uint256 _pID) external view returns (uint256);
965     function getPlayerAddr(uint256 _pID) external view returns (address);
966     function getPlayerHasAff(uint256 _pID) external view returns (bool);
967     function getNameFee() external view returns (uint256);
968     function getAffiliateFee() external view returns (uint256);
969     function depositAffiliate(uint256 _pID) external payable;
970 }
971 
972 
973 /// @title SafeMath v0.1.9
974 /// @dev Math operations with safety checks that throw on error
975 /// change notes: original SafeMath library from OpenZeppelin modified by Inventor
976 /// - added sqrt
977 /// - added sq
978 /// - added pwr 
979 /// - changed asserts to requires with error log outputs
980 /// - removed div, its useless
981 library SafeMath {
982     
983     /// @dev Multiplies two numbers, throws on overflow.
984     function mul(uint256 a, uint256 b) 
985         internal 
986         pure 
987         returns (uint256 c) 
988     {
989         if (a == 0) {
990             return 0;
991         }
992         c = a * b;
993         require(c / a == b, "SafeMath mul failed");
994         return c;
995     }
996 
997 
998     /// @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
999     function sub(uint256 a, uint256 b)
1000         internal
1001         pure
1002         returns (uint256) 
1003     {
1004         require(b <= a, "SafeMath sub failed");
1005         return a - b;
1006     }
1007 
1008 
1009     /// @dev Adds two numbers, throws on overflow.
1010     function add(uint256 a, uint256 b)
1011         internal
1012         pure
1013         returns (uint256 c) 
1014     {
1015         c = a + b;
1016         require(c >= a, "SafeMath add failed");
1017         return c;
1018     }
1019     
1020 
1021     /// @dev gives square root of given x.
1022     function sqrt(uint256 x)
1023         internal
1024         pure
1025         returns (uint256 y) 
1026     {
1027         uint256 z = ((add(x, 1)) / 2);
1028         y = x;
1029         while (z < y) {
1030             y = z;
1031             z = ((add((x / z), z)) / 2);
1032         }
1033     }
1034 
1035 
1036     /// @dev gives square. multiplies x by x
1037     function sq(uint256 x)
1038         internal
1039         pure
1040         returns (uint256)
1041     {
1042         return (mul(x,x));
1043     }
1044 
1045 
1046     /// @dev x to the power of y 
1047     function pwr(uint256 x, uint256 y)
1048         internal 
1049         pure 
1050         returns (uint256)
1051     {
1052         if (x == 0) {
1053             return (0);
1054         } else if (y == 0) {
1055             return (1);
1056         } else {
1057             uint256 z = x;
1058             for (uint256 i = 1; i < y; i++) {
1059                 z = mul(z,x);
1060             }
1061             return (z);
1062         }
1063     }
1064 }