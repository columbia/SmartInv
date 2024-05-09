1 pragma solidity ^0.4.6;
2 
3 
4 contract iE4RowEscrow {
5         function getNumGamesStarted() constant returns (int ngames);
6 }
7 
8 
9 contract E4RowEscrowU is iE4RowEscrow {
10 
11 event StatEvent(string msg);
12 event StatEventI(string msg, uint val);
13 event StatEventA(string msg, address addr);
14 
15         uint constant MAX_PLAYERS = 5;
16 
17         enum EndReason  {erWinner, erTimeOut, erCheat}
18         enum SettingStateValue  {debug, release, lockedRelease}
19 
20         struct gameInstance {
21                 address[5] players;
22                 uint[5] playerPots;
23                 uint numPlayers;
24 
25                 bool active; // active
26                 bool allocd; //  allocated already. 
27                 uint started; // time game started
28                 uint lastMoved; // time game last moved
29                 uint payout; // payout amont
30                 address winner; // address of winner
31 
32 
33                 EndReason reasonEnded; // enum reason of ended
34 
35         }
36 
37         struct arbiter {
38                 mapping (uint => uint)  gameIndexes; // game handles
39 
40                 uint arbToken; // 2 bytes
41                 uint gameSlots; // a counter of alloc'd game structs (they can be reused)
42                 uint gamesStarted; // total games started
43                 uint gamesCompleted;
44                 uint gamesCheated;
45                 uint gamesTimedout;
46                 uint numPlayers;
47                 bool registered; 
48                 bool locked;
49         }
50 
51 
52         address public  owner;  // owner is address that deployed contract
53         address public  tokenPartner;   // the address of partner that receives rake fees
54         uint public numArbiters;        // number of arbiters
55 
56         int numGamesStarted;    // total stats from all arbiters
57 
58         uint public numGamesCompleted; // ...
59         uint public numGamesCheated;    // ...
60         uint public numGamesTimedOut;   // ...
61 
62         uint public houseFeeHoldover; // hold fee till threshold
63         uint public lastPayoutTime;     // timestamp of last payout time
64 
65 
66         // configurables
67         uint public gameTimeOut;
68         uint public registrationFee;
69         uint public houseFeeThreshold;
70         uint public payoutInterval;
71 
72         uint raGas; // for register arb
73         uint sgGas;// for start game
74         uint wpGas; // for winner paid
75         uint rfGas; // for refund
76         uint feeGas; // for rake fee payout
77 
78         SettingStateValue public settingsState = SettingStateValue.debug; 
79 
80 
81         mapping (address => arbiter)  arbiters;
82         mapping (uint => address)  arbiterTokens;
83         mapping (uint => address)  arbiterIndexes;
84         mapping (uint => gameInstance)  games;
85 
86 
87         function E4RowEscrowU() public
88         {
89                 owner = msg.sender;
90         }
91 
92 
93         function applySettings(SettingStateValue _state, uint _fee, uint _threshold, uint _timeout, uint _interval)
94         {
95                 if (msg.sender != owner) 
96                         throw;
97 
98                 // ----------------------------------------------
99                 // these items are tweakable for game optimization
100                 // ----------------------------------------------
101                 houseFeeThreshold = _threshold;
102                 gameTimeOut = _timeout;
103                 payoutInterval = _interval;
104 
105                 if (settingsState == SettingStateValue.lockedRelease) {
106                         StatEvent("Settings Tweaked");
107                         return;
108                 }
109 
110                 settingsState = _state;
111                 registrationFee = _fee;
112 
113                 // set default op gas -  any futher settings done in set up gas
114                 raGas = 150000; 
115                 sgGas = 110000;
116                 wpGas = 20000; 
117                 rfGas = 20000; 
118                 feeGas = 360000; 
119 
120                 StatEvent("Settings Changed");
121 
122 
123         }
124 
125         //-----------------------------
126         // return an arbiter token from an hGame
127         //-----------------------------
128         function ArbTokFromHGame(uint _hGame) returns (uint _tok)
129         { 
130                 _tok =  (_hGame / (2 ** 48)) & 0xffff;
131         }
132 
133 
134         //-----------------------------
135         // suicide the contract, not called for release
136         //-----------------------------
137         function HaraKiri()
138         {
139                 if ((msg.sender == owner) && (settingsState != SettingStateValue.lockedRelease))
140                           suicide(tokenPartner);
141                 else
142                         StatEvent("Kill attempt failed");
143         }
144 
145 
146 
147 
148         //-----------------------------
149         // default function
150         //-----------------------------
151         function() payable  {
152                 throw;
153         }
154 
155         //------------------------------------------------------
156         // check active game and valid player, return player index
157         //-------------------------------------------------------
158         function validPlayer(uint _hGame, address _addr)  internal returns( bool _valid, uint _pidx)
159         {
160                 _valid = false;
161                 if (activeGame(_hGame)) {
162                         for (uint i = 0; i < games[_hGame].numPlayers; i++) {
163                                 if (games[_hGame].players[i] == _addr) {
164                                         _valid=true;
165                                         _pidx = i;
166                                         break;
167                                 }
168                         }
169                 }
170         }
171 
172         //------------------------------------------------------
173         // check valid player, return player index
174         //-------------------------------------------------------
175         function validPlayer2(uint _hGame, address _addr) internal  returns( bool _valid, uint _pidx)
176         {
177                 _valid = false;
178                 for (uint i = 0; i < games[_hGame].numPlayers; i++) {
179                         if (games[_hGame].players[i] == _addr) {
180                                 _valid=true;
181                                 _pidx = i;
182                                 break;
183                         }
184                 }
185         }
186 
187         //------------------------------------------------------
188         // check the arbiter is valid by comparing token
189         //------------------------------------------------------
190         function validArb(address _addr, uint _tok) internal  returns( bool _valid)
191         {
192                 _valid = false;
193 
194                 if ((arbiters[_addr].registered)
195                         && (arbiters[_addr].arbToken == _tok)) 
196                         _valid = true;
197         }
198 
199         //------------------------------------------------------
200         // check the arbiter is valid without comparing token
201         //------------------------------------------------------
202         function validArb2(address _addr) internal  returns( bool _valid)
203         {
204                 _valid = false;
205                 if (arbiters[_addr].registered)
206                         _valid = true;
207         }
208 
209         //------------------------------------------------------
210         // check if arbiter is locked out
211         //------------------------------------------------------
212         function arbLocked(address _addr) internal  returns( bool _locked)
213         {
214                 _locked = false;
215                 if (validArb2(_addr)) 
216                         _locked = arbiters[_addr].locked;
217         }
218 
219         //------------------------------------------------------
220         // return if game is active
221         //------------------------------------------------------
222         function activeGame(uint _hGame) internal  returns( bool _valid)
223         {
224                 _valid = false;
225                 if ((_hGame > 0)
226                         && (games[_hGame].active))
227                         _valid = true;
228         }
229 
230 
231         //------------------------------------------------------
232         // register game arbiter, max players of 5, pass in exact registration fee
233         //------------------------------------------------------
234         function registerArbiter(uint _numPlayers, uint _arbToken) public payable 
235         {
236 
237                 if (msg.value != registrationFee) {
238                         throw;  //Insufficient Fee
239                 }
240 
241                 if (_arbToken == 0) {
242                         throw; // invalid token
243                 }
244 
245                 if (arbTokenExists(_arbToken & 0xffff)) {
246                         throw; // Token Already Exists
247                 }
248 
249                 if (arbiters[msg.sender].registered) {
250                         throw; // Arb Already Registered
251                 }
252 
253                 if (_numPlayers > MAX_PLAYERS) {
254                         throw; // Exceeds Max Players
255                 }
256 
257                 arbiters[msg.sender].gamesStarted = 0;
258                 arbiters[msg.sender].gamesCompleted = 0;
259                 arbiters[msg.sender].gamesCheated = 0;
260                 arbiters[msg.sender].gamesTimedout = 0;
261                 arbiters[msg.sender].locked = false;
262                 arbiters[msg.sender].arbToken = _arbToken & 0xffff;
263                 arbiters[msg.sender].numPlayers = _numPlayers;
264                 arbiters[msg.sender].registered = true;
265 
266                 arbiterTokens[(_arbToken & 0xffff)] = msg.sender;
267                 arbiterIndexes[numArbiters++] = msg.sender;
268 
269 
270                 if (!tokenPartner.call.gas(raGas).value(msg.value)()) {
271                         //Statvent("Send Error"); // event never registers
272                         throw;
273                 }
274                 StatEventI("Arb Added", _arbToken);
275         }
276 
277 
278         //------------------------------------------------------
279         // start game.  pass in valid hGame containing token in top two bytes
280         //------------------------------------------------------
281         function startGame(uint _hGame, int _hkMax, address[] _players) public 
282         {
283                 uint ntok = ArbTokFromHGame(_hGame);
284                 if (!validArb(msg.sender, ntok )) {
285                         StatEvent("Invalid Arb");
286                         return; 
287                 }
288 
289 
290                 if (arbLocked(msg.sender)) {
291                         StatEvent("Arb Locked");
292                         return; 
293                 }
294 
295                 arbiter xarb = arbiters[msg.sender];
296                 if (_players.length != xarb.numPlayers) { 
297                         StatEvent("Incorrect num players");
298                         return; 
299                 }
300 
301                 if (_hkMax > 0)
302                         houseKeep(_hkMax, ntok); 
303 
304                 if (!games[_hGame].allocd) {
305                         games[_hGame].allocd = true;
306                         xarb.gameIndexes[xarb.gameSlots++] = _hGame;
307                 } 
308                 numGamesStarted++; // always inc this one
309                 xarb.gamesStarted++;
310 
311                 games[_hGame].active = true;
312                 games[_hGame].started = now; 
313                 games[_hGame].lastMoved = now; 
314                 games[_hGame].payout = 0; 
315                 games[_hGame].winner = address(0);
316 
317                 games[_hGame].numPlayers = _players.length; // we'll be the judge of how many unique players
318                 for (uint i = 0; i< _players.length && i < MAX_PLAYERS; i++) {
319                     games[_hGame].players[i] = _players[i];
320                     games[_hGame].playerPots[i] = 0;
321                 }
322 
323 
324                 StatEventI("Game Added", _hGame);
325 
326 
327         }
328 
329         //------------------------------------------------------
330         // clean up game, set to inactive, refund any balances
331         // called by housekeep ONLY
332         //------------------------------------------------------
333         function abortGame(address _arb, uint  _hGame, EndReason _reason) private returns(bool _success)
334         {
335              gameInstance nGame = games[_hGame];
336              
337                 // find game in game id, 
338                 if (nGame.active) {
339                         _success = true;
340                         for (uint i = 0; i < nGame.numPlayers; i++) {
341                                 if (nGame.playerPots[i] > 0) {
342                                         address a = nGame.players[i];
343                                         uint nsend = nGame.playerPots[i];
344                                         nGame.playerPots[i] = 0;
345                                         if (!a.call.gas(rfGas).value(nsend)()) {
346                                                 houseFeeHoldover += nsend; // cannot refund due to error, give to the house
347                                                 StatEventA("Cannot Refund Address", a);
348                                         }
349                                 }
350                         }
351                         nGame.active = false;
352                         nGame.reasonEnded = _reason;
353                         if (_reason == EndReason.erCheat) {
354                                 numGamesCheated++;
355                                 arbiters[_arb].gamesCheated++;
356                                 StatEvent("Game Aborted-Cheat");
357                         } else if (_reason == EndReason.erTimeOut) {
358                                 numGamesTimedOut++;
359                                 arbiters[_arb].gamesTimedout++;
360                                 StatEvent("Game Aborted-TimeOut");
361                         } else 
362                                 StatEvent("Game Aborted!");
363                 }
364         }
365 
366 
367         //------------------------------------------------------
368         // called by arbiter when winner is decided
369         //------------------------------------------------------
370         function winnerDecided(uint _hGame, address _winner, uint _winnerBal) public
371         {
372 
373                 if (!validArb(msg.sender, ArbTokFromHGame(_hGame))) {
374                         StatEvent("Invalid Arb");
375                         return; // no throw no change made
376                 }
377 
378                 var (valid, pidx) = validPlayer(_hGame, _winner);
379                 if (!valid) {
380                         StatEvent("Invalid Player");
381                         return;
382                 }
383 
384                 arbiter xarb = arbiters[msg.sender];
385                 gameInstance xgame = games[_hGame];
386 
387                 uint totalPot = 0;
388 
389                 if (xgame.playerPots[pidx] != _winnerBal) {
390                     abortGame(msg.sender, _hGame, EndReason.erCheat);
391                     return;
392                 }
393 
394                 for (uint i = 0; i < xgame.numPlayers; i++) {
395                         totalPot += xgame.playerPots[i];
396                 }
397 
398                 uint nportion;
399                 uint nremnant;
400                 if (totalPot > 0) {
401                         nportion = totalPot/50; // 2 percent fixed
402                         nremnant = totalPot-nportion;
403                 } else {
404                         nportion = 0;
405                         nremnant = 0;
406                 }
407 
408 
409                 xgame.lastMoved = now;
410                 xgame.active = false;
411                 xgame.reasonEnded = EndReason.erWinner;
412                 xgame.winner = _winner;
413                 xgame.payout = nremnant;
414 
415                 if (nportion > 0) {
416                         houseFeeHoldover += nportion;
417                         if ((houseFeeHoldover > houseFeeThreshold)
418                                 && (now > (lastPayoutTime + payoutInterval))) {
419                                 uint ntmpho = houseFeeHoldover;
420                                 houseFeeHoldover = 0;
421                                 lastPayoutTime = now; // reset regardless of succeed/fail
422                                 if (!tokenPartner.call.gas(feeGas).value(ntmpho)()) {
423                                         houseFeeHoldover = ntmpho; // put it back
424                                         StatEvent("House-Fee Error1");
425                                 } 
426                         }
427                 }
428 
429                 for (i = 0; i < xgame.numPlayers; i++) {
430                         xgame.playerPots[i] = 0;
431                 }
432 
433                 xarb.gamesCompleted++;
434                 numGamesCompleted++;
435                 if (nremnant > 0) {
436                         if (!_winner.call.gas(wpGas).value(uint(nremnant))()) {
437                                 // StatEvent("Send Error");
438                                 throw; // if you cant pay the winner - very bad
439                         } else {
440                                 StatEventI("Winner Paid", _hGame);
441                         }
442                 }
443         }
444 
445         //------------------------------------------------------
446         // handle a bet made by a player, validate the player and game
447         // add to players balance
448         //------------------------------------------------------
449         function handleBet(uint _hGame) public payable 
450         {
451                 address narb = arbiterTokens[ArbTokFromHGame(_hGame)];
452                 if (narb == address(0)) {
453                         StatEvent("Invalid hGame");
454                         if (settingsState != SettingStateValue.debug)
455                                 throw;
456                         else
457                                 return;
458                 }
459 
460                 var (valid, pidx) = validPlayer(_hGame, msg.sender);
461                 if (!valid) {
462                         StatEvent("Invalid Player");
463                         if (settingsState != SettingStateValue.debug)
464                                 throw;
465                         else
466                                 return;
467                 }
468 
469                 games[_hGame].playerPots[pidx] += msg.value;
470                 games[_hGame].lastMoved = now;
471 
472                 StatEventI("Bet Added", _hGame);
473 
474         }
475 
476 
477         //------------------------------------------------------
478         // return if arb token exists
479         //------------------------------------------------------
480         function arbTokenExists(uint _tok) constant returns (bool _exists)
481         {
482                 _exists = false;
483                 if ((_tok > 0)
484                         && (arbiterTokens[_tok] != address(0))
485                         && arbiters[arbiterTokens[_tok]].registered)
486                         _exists = true;
487 
488         }
489 
490 
491 
492 
493         //------------------------------------------------------
494         // called by ico token contract 
495         //------------------------------------------------------
496         function getNumGamesStarted() constant returns (int _games) 
497         {
498                 _games = numGamesStarted;
499         }
500 
501         //------------------------------------------------------
502         // return arbiter game stats
503         //------------------------------------------------------
504         function getArbInfo(uint _idx) constant  returns (address _addr, uint _started, uint _completed, uint _cheated, uint _timedOut) 
505         {
506                 if (_idx >= numArbiters) {
507                         StatEvent("Invalid Arb");
508                         return;
509                 }
510                 _addr = arbiterIndexes[_idx];
511                 if ((_addr == address(0))
512                         || (!arbiters[_addr].registered)) {
513                         StatEvent("Invalid Arb");
514                         return;
515                 }
516                 arbiter xarb = arbiters[_addr];
517                 _started = xarb.gamesStarted;
518                 _completed = xarb.gamesCompleted;
519                 _timedOut = xarb.gamesTimedout;
520                 _cheated = xarb.gamesCheated;
521         }
522 
523 
524         //------------------------------------------------------
525         // scan for a game 10 minutes old
526         // if found abort the game, causing funds to be returned
527         //------------------------------------------------------
528         function houseKeep(int _max, uint _arbToken) public
529         {
530                 uint gi;
531                 address a;
532                 int aborted = 0;
533 
534                 arbiter xarb = arbiters[msg.sender];// have to set it to something
535                 
536          
537                 if (msg.sender == owner) {
538                         for (uint ar = 0; (ar < numArbiters) && (aborted < _max) ; ar++) {
539                             a = arbiterIndexes[ar];
540                             xarb = arbiters[a];    
541 
542                             for ( gi = 0; (gi < xarb.gameSlots) && (aborted < _max); gi++) {
543                                 gameInstance ngame0 = games[xarb.gameIndexes[gi]];
544                                 if ((ngame0.active)
545                                     && ((now - ngame0.lastMoved) > gameTimeOut)) {
546                                         abortGame(a, xarb.gameIndexes[gi], EndReason.erTimeOut);
547                                         ++aborted;
548                                 }
549                             }
550                         }
551 
552                 } else {
553                         if (!validArb(msg.sender, _arbToken))
554                                 StatEvent("Housekeep invalid arbiter");
555                         else {
556                             a = msg.sender;
557                             xarb = arbiters[a];    
558                             for (gi = 0; (gi < xarb.gameSlots) && (aborted < _max); gi++) {
559                                 gameInstance ngame1 = games[xarb.gameIndexes[gi]];
560                                 if ((ngame1.active)
561                                     && ((now - ngame1.lastMoved) > gameTimeOut)) {
562                                         abortGame(a, xarb.gameIndexes[gi], EndReason.erTimeOut);
563                                         ++aborted;
564                                 }
565                             }
566 
567                         }
568                 }
569         }
570 
571 
572         //------------------------------------------------------
573         // return game info
574         //------------------------------------------------------
575         function getGameInfo(uint _hGame)  constant  returns (EndReason _reason, uint _players, uint _payout, bool _active, address _winner )
576         {
577                 gameInstance ngame = games[_hGame];
578                 _active = ngame.active;
579                 _players = ngame.numPlayers;
580                 _winner = ngame.winner;
581                 _payout = ngame.payout;
582                 _reason = ngame.reasonEnded;
583 
584         }
585 
586         //------------------------------------------------------
587         // return arbToken and low bytes from an HGame
588         //------------------------------------------------------
589         function checkHGame(uint _hGame) constant returns(uint _arbTok, uint _lowWords)
590         {
591                 _arbTok = ArbTokFromHGame(_hGame);
592                 _lowWords = _hGame & 0xffffffffffff;
593 
594         }
595 
596         //------------------------------------------------------
597         // get operation gas amounts
598         //------------------------------------------------------
599         function getOpGas() constant returns (uint _ra, uint _sg, uint _wp, uint _rf, uint _fg) 
600         {
601                 _ra = raGas; // register arb
602                 _sg = sgGas; // start game
603                 _wp = wpGas; // winner paid
604                 _rf = rfGas; // refund
605                 _fg = feeGas; // rake fee gas
606         }
607 
608 
609         //------------------------------------------------------
610         // set operation gas amounts for forwading operations
611         //------------------------------------------------------
612         function setOpGas(uint _ra, uint _sg, uint _wp, uint _rf, uint _fg) 
613         {
614                 if (msg.sender != owner)
615                         throw;
616 
617                 raGas = _ra;
618                 sgGas = _sg;
619                 wpGas = _wp;
620                 rfGas = _rf;
621                 feeGas = _fg;
622         }
623 
624         //------------------------------------------------------
625         // set a micheivous arbiter to locked
626         //------------------------------------------------------
627         function setArbiterLocked(address _addr, bool _lock)  public 
628         {
629                 if (owner != msg.sender)  {
630                         throw; 
631                 } else if (!validArb2(_addr)) {
632                         StatEvent("invalid arb");
633                 } else {
634                         arbiters[_addr].locked = _lock;
635                 }
636 
637         }
638 
639         //------------------------------------------------------
640         // flush the house fees whenever commanded to.
641         // ignore the threshold and the last payout time
642         // but this time only reset lastpayouttime upon success
643         //------------------------------------------------------
644         function flushHouseFees()
645         {
646                 if (msg.sender != owner) {
647                         StatEvent("only owner calls this function");
648                 } else if (houseFeeHoldover > 0) {
649                         uint ntmpho = houseFeeHoldover;
650                         houseFeeHoldover = 0;
651                         if (!tokenPartner.call.gas(feeGas).value(ntmpho)()) {
652                                 houseFeeHoldover = ntmpho; // put it back
653                                 StatEvent("House-Fee Error2"); 
654                         } else {
655                                 lastPayoutTime = now;
656                                 StatEvent("House-Fee Paid");
657                         }
658                 }
659 
660         }
661 
662 
663         //------------------------------------------------------
664         // set the token partner
665         //------------------------------------------------------
666         function setTokenPartner(address _addr) public
667         {
668                 if (msg.sender != owner) {
669                         throw;
670                 } 
671 
672                 if ((settingsState == SettingStateValue.lockedRelease) 
673                         && (tokenPartner == address(0))) {
674                         tokenPartner = _addr;
675                         StatEvent("Token Partner Final!");
676                 } else if (settingsState != SettingStateValue.lockedRelease) {
677                         tokenPartner = _addr;
678                         StatEvent("Token Partner Assigned!");
679                 }
680 
681         }
682 
683         // ----------------------------
684         // swap executor
685         // ----------------------------
686         function changeOwner(address _addr) 
687         {
688                 if (msg.sender != owner
689                         || settingsState == SettingStateValue.lockedRelease)
690                          throw;
691 
692                 owner = _addr;
693         }
694 
695 
696 
697 }