1 pragma solidity ^0.4.11;
2 
3 // version (LAVA-Q)
4 contract E4RowEscrow {
5 
6 event StatEvent(string msg);
7 event StatEventI(string msg, uint val);
8 event StatEventA(string msg, address addr);
9 
10         uint constant MAX_PLAYERS = 5;
11 
12         enum EndReason  {erWinner, erTimeOut, erCancel}
13         enum SettingStateValue  {debug, release, lockedRelease}
14 
15         struct gameInstance {
16                 bool active;           // active
17                 bool allocd;           // allocated already. 
18                 EndReason reasonEnded; // enum reason of ended
19                 uint8 numPlayers;
20                 uint128 totalPot;      // total of all bets
21                 uint128[5] playerPots; // individual deposits
22                 address[5] players;    // player addrs
23                 uint lastMoved;        // time game last moved
24         }
25 
26         struct arbiter {
27                 mapping (uint => uint)  gameIndexes; // game handles
28                 bool registered; 
29                 bool locked;
30                 uint8 numPlayers;
31                 uint16 arbToken;         // 2 bytes
32                 uint16 escFeePctX10;     // escrow fee -- frac of 1000
33                 uint16 arbFeePctX10;     // arbiter fee -- frac of 1000
34                 uint32 gameSlots;        // a counter of alloc'd game structs (they can be reused)
35                 uint128 feeCap;          // max fee (escrow + arb) in wei
36                 uint128 arbHoldover;     // hold accumulated gas credits and arbiter fees
37         }
38 
39 
40         address public  owner;  // owner is address that deployed contract
41         address public  tokenPartner;   // the address of partner that receives rake fees
42         uint public numArbiters;        // number of arbiters
43 
44         int numGamesStarted;    // total stats from all arbiters
45 
46         uint public numGamesCompleted; // ...
47         uint public numGamesCanceled;   // tied and canceled
48         uint public numGamesTimedOut;   // ...
49         uint public houseFeeHoldover;   // hold fee till threshold
50         uint public lastPayoutTime;     // timestamp of last payout time
51 
52         // configurables
53         uint public gameTimeOut;
54         uint public registrationFee;
55         uint public houseFeeThreshold;
56         uint public payoutInterval;
57 
58         uint acctCallGas;  // for payments to simple accts
59         uint tokCallGas;   // for calling token contract. eg fee payout
60         uint public startGameGas; // gas consumed by startGame
61         uint public winnerDecidedGas; // gas consumed by winnerDecided
62 
63         SettingStateValue public settingsState = SettingStateValue.debug; 
64 
65 
66         mapping (address => arbiter)  arbiters;
67         mapping (uint => address)  arbiterTokens;
68         mapping (uint => address)  arbiterIndexes;
69         mapping (uint => gameInstance)  games;
70 
71 
72         function E4RowEscrow() public
73         {
74                 owner = msg.sender;
75         }
76 
77 
78         function applySettings(SettingStateValue _state, uint _fee, uint _threshold, uint _timeout, uint _interval, uint _startGameGas, uint _winnerDecidedGas)
79         {
80                 if (msg.sender != owner) 
81                         throw;
82 
83                 // ----------------------------------------------
84                 // these items are tweakable for game optimization
85                 // ----------------------------------------------
86                 houseFeeThreshold = _threshold;
87                 gameTimeOut = _timeout;
88                 payoutInterval = _interval;
89 
90                 if (settingsState == SettingStateValue.lockedRelease) {
91                         StatEvent("Settings Tweaked");
92                         return;
93                 }
94 
95                 settingsState = _state;
96                 registrationFee = _fee;
97 
98                 // set default op gas -  any futher settings done in set up gas
99                 acctCallGas = 21000; 
100                 tokCallGas = 360000;
101 
102                 // set gas consumption - these should never change (except gas price)
103                 startGameGas = _startGameGas;
104                 winnerDecidedGas = _winnerDecidedGas;
105                 StatEvent("Settings Changed");
106 
107         }
108 
109 
110         //-----------------------------
111         // return an arbiter token from an hGame
112         //-----------------------------
113         function ArbTokFromHGame(uint _hGame) returns (uint _tok)
114         { 
115                 _tok =  (_hGame / (2 ** 48)) & 0xffff;
116         }
117 
118 
119         //-----------------------------
120         // suicide the contract, not called for release
121         //-----------------------------
122         function HaraKiri()
123         {
124                 if ((msg.sender == owner) && (settingsState != SettingStateValue.lockedRelease))
125                           suicide(tokenPartner);
126                 else
127                         StatEvent("Kill attempt failed");
128         }
129 
130 
131         //-----------------------------
132         // default function
133         // who are we to look a gift-horse in the mouth?
134         //-----------------------------
135         function() payable  {
136                 StatEvent("thanks!");
137                 houseFeeHoldover += msg.value;
138         }
139         function blackHole() payable  {
140                 StatEvent("thanks!#2");
141         }
142 
143         //------------------------------------------------------
144         // check active game and valid player, return player index
145         //-------------------------------------------------------
146         function validPlayer(uint _hGame, address _addr)  internal returns( bool _valid, uint _pidx)
147         {
148                 _valid = false;
149 
150                 if (activeGame(_hGame)) {
151                         for (uint i = 0; i < games[_hGame].numPlayers; i++) {
152                                 if (games[_hGame].players[i] == _addr) {
153                                         _valid=true;
154                                         _pidx = i;
155                                         break;
156                                 }
157                         }
158                 }
159         }
160 
161 
162         //------------------------------------------------------
163         // check the arbiter is valid by comparing token
164         //------------------------------------------------------
165         function validArb(address _addr, uint _tok) internal  returns( bool _valid)
166         {
167                 _valid = false;
168 
169                 if ((arbiters[_addr].registered)
170                         && (arbiters[_addr].arbToken == _tok)) 
171                         _valid = true;
172         }
173 
174         //------------------------------------------------------
175         // check the arbiter is valid without comparing token
176         //------------------------------------------------------
177         function validArb2(address _addr) internal  returns( bool _valid)
178         {
179                 _valid = false;
180                 if (arbiters[_addr].registered)
181                         _valid = true;
182         }
183 
184         //------------------------------------------------------
185         // check if arbiter is locked out
186         //------------------------------------------------------
187         function arbLocked(address _addr) internal  returns( bool _locked)
188         {
189                 _locked = false;
190                 if (validArb2(_addr)) 
191                         _locked = arbiters[_addr].locked;
192         }
193 
194         //------------------------------------------------------
195         // return if game is active
196         //------------------------------------------------------
197         function activeGame(uint _hGame) internal  returns( bool _valid)
198         {
199                 _valid = false;
200                 if ((_hGame > 0)
201                         && (games[_hGame].active))
202                         _valid = true;
203         }
204 
205 
206         //------------------------------------------------------
207         // register game arbiter, max players of 5, pass in exact registration fee
208         //------------------------------------------------------
209         function registerArbiter(uint _numPlayers, uint _arbToken, uint _escFeePctX10, uint _arbFeePctX10, uint _feeCap) public payable 
210         {
211 
212                 if (msg.value != registrationFee) {
213                         throw;  //Insufficient Fee
214                 }
215 
216                 if (_arbToken == 0) {
217                         throw; // invalid token
218                 }
219 
220                 if (arbTokenExists(_arbToken & 0xffff)) {
221                         throw; // Token Already Exists
222                 }
223 
224                 if (arbiters[msg.sender].registered) {
225                         throw; // Arb Already Registered
226                 }
227 
228                 if (_numPlayers > MAX_PLAYERS) {
229                         throw; // Exceeds Max Players
230                 }
231 
232                 if (_escFeePctX10 < 20) {
233                         throw; // less than 2% min escrow fee
234                 }
235 
236                 if (_arbFeePctX10 > 10) {
237                         throw; // more than than 1% max arbiter fee
238                 }
239 
240                 arbiters[msg.sender].locked = false;
241                 arbiters[msg.sender].numPlayers = uint8(_numPlayers);
242                 arbiters[msg.sender].escFeePctX10 = uint8(_escFeePctX10);
243                 arbiters[msg.sender].arbFeePctX10 = uint8(_arbFeePctX10);
244                 arbiters[msg.sender].arbToken = uint16(_arbToken & 0xffff);
245                 arbiters[msg.sender].feeCap = uint128(_feeCap);
246                 arbiters[msg.sender].registered = true;
247 
248                 arbiterTokens[(_arbToken & 0xffff)] = msg.sender;
249                 arbiterIndexes[numArbiters++] = msg.sender;
250 
251                 if (tokenPartner != address(0)) {
252                         if (!tokenPartner.call.gas(tokCallGas).value(msg.value)()) {
253                                 //Statvent("Send Error"); // event never registers
254                                 throw;
255                         }
256                 } else {
257                         houseFeeHoldover += msg.value;
258                 }
259                 StatEventI("Arb Added", _arbToken);
260         }
261 
262 
263         //------------------------------------------------------
264         // start game.  pass in valid hGame containing token in top two bytes
265         //------------------------------------------------------
266         function startGame(uint _hGame, int _hkMax, address[] _players) public 
267 
268         {
269                 uint ntok = ArbTokFromHGame(_hGame);
270                 if (!validArb(msg.sender, ntok )) {
271                         StatEvent("Invalid Arb");
272                         return;
273                 }
274 
275 
276                 if (arbLocked(msg.sender)) {
277                         StatEvent("Arb Locked");
278                         return; 
279                 }
280 
281                 arbiter xarb = arbiters[msg.sender];
282                 if (_players.length != xarb.numPlayers) { 
283                         StatEvent("Incorrect num players");
284                         return; 
285                 }
286 
287                 gameInstance xgame = games[_hGame];
288                 if (xgame.active) {
289                         // guard-rail. just in case to return funds
290                         abortGame(_hGame, EndReason.erCancel);
291 
292                 } else if (_hkMax > 0) {
293                         houseKeep(_hkMax, ntok); 
294                 }
295 
296                 if (!xgame.allocd) {
297                         xgame.allocd = true;
298                         xarb.gameIndexes[xarb.gameSlots++] = _hGame;
299                 } 
300                 numGamesStarted++; // always inc this one
301 
302                 xgame.active = true;
303                 xgame.lastMoved = now;
304                 xgame.totalPot = 0;
305                 xgame.numPlayers = xarb.numPlayers;
306                 for (uint i = 0; i < _players.length; i++) {
307                         xgame.players[i] = _players[i];
308                         xgame.playerPots[i] = 0;
309                 }
310                 //StatEventI("Game Added", _hGame);
311         }
312 
313         //------------------------------------------------------
314         // clean up game, set to inactive, refund any balances
315         // called by housekeep ONLY
316         //------------------------------------------------------
317         function abortGame(uint  _hGame, EndReason _reason) private returns(bool _success)
318         {
319                 gameInstance xgame = games[_hGame];
320              
321                 // find game in game id, 
322                 if (xgame.active) {
323                         _success = true;
324                         for (uint i = 0; i < xgame.numPlayers; i++) {
325                                 if (xgame.playerPots[i] > 0) {
326                                         address a = xgame.players[i];
327                                         uint nsend = xgame.playerPots[i];
328                                         xgame.playerPots[i] = 0;
329                                         if (!a.call.gas(acctCallGas).value(nsend)()) {
330                                                 houseFeeHoldover += nsend; // cannot refund due to error, give to the house
331                                                 StatEventA("Cannot Refund Address", a);
332                                         }
333                                 }
334                         }
335                         xgame.active = false;
336                         xgame.reasonEnded = _reason;
337                         if (_reason == EndReason.erCancel) {
338                                 numGamesCanceled++;
339                                 StatEvent("Game canceled");
340                         } else if (_reason == EndReason.erTimeOut) {
341                                 numGamesTimedOut++;
342                                 StatEvent("Game timed out");
343                         } else 
344                                 StatEvent("Game aborted");
345                 }
346         }
347 
348 
349         //------------------------------------------------------
350         // called by arbiter when winner is decided
351         // *pass in high num for winnerbal for tie games
352         //------------------------------------------------------
353         function winnerDecided(uint _hGame, address _winner, uint _winnerBal) public
354         {
355                 if (!validArb(msg.sender, ArbTokFromHGame(_hGame))) {
356                         StatEvent("Invalid Arb");
357                         return; // no throw no change made
358                 }
359 
360                 var (valid, pidx) = validPlayer(_hGame, _winner);
361                 if (!valid) {
362                         StatEvent("Invalid Player");
363                         return;
364                 }
365 
366                 arbiter xarb = arbiters[msg.sender];
367                 gameInstance xgame = games[_hGame];
368 
369                 if (xgame.playerPots[pidx] < _winnerBal) {
370                     abortGame(_hGame, EndReason.erCancel);
371                     return;
372                 }
373 
374                 xgame.active = false;
375                 xgame.reasonEnded = EndReason.erWinner;
376                 numGamesCompleted++;
377 
378                 if (xgame.totalPot > 0) {
379                         // calc payouts: escrowFee, arbiterFee, gasCost, winner payout
380                         uint _escrowFee = (xgame.totalPot * xarb.escFeePctX10) / 1000;
381                         uint _arbiterFee = (xgame.totalPot * xarb.arbFeePctX10) / 1000;
382                         if ((_escrowFee + _arbiterFee) > xarb.feeCap) {
383                                 _escrowFee = xarb.feeCap * xarb.escFeePctX10 / (xarb.escFeePctX10 + xarb.arbFeePctX10);
384                                 _arbiterFee = xarb.feeCap * xarb.arbFeePctX10 / (xarb.escFeePctX10 + xarb.arbFeePctX10);
385                         }
386                         uint _payout = xgame.totalPot - (_escrowFee + _arbiterFee);
387                         uint _gasCost = tx.gasprice * (startGameGas + winnerDecidedGas);
388                         if (_gasCost > _payout)
389                                 _gasCost = _payout;
390                         _payout -= _gasCost;
391 
392                         // do payouts
393                         xarb.arbHoldover += uint128(_arbiterFee + _gasCost);
394                         houseFeeHoldover += _escrowFee;
395 
396                         if ((houseFeeHoldover > houseFeeThreshold)
397                             && (now > (lastPayoutTime + payoutInterval))) {
398                                 uint ntmpho = houseFeeHoldover;
399                                 houseFeeHoldover = 0;
400                                 lastPayoutTime = now; // reset regardless of succeed/fail
401                                 if (!tokenPartner.call.gas(tokCallGas).value(ntmpho)()) {
402                                         houseFeeHoldover = ntmpho; // put it back
403                                         StatEvent("House-Fee Error1");
404                                 } 
405                         }
406 
407                         if (_payout > 0) {
408                                 if (!_winner.call.gas(acctCallGas).value(uint(_payout))()) {
409                                         // if you cant pay the winner - very bad
410                                         // StatEvent("Send Error");
411                                         // add funds to houseFeeHoldover to avoid acounting errs
412                                         //throw;
413                                         houseFeeHoldover += _payout;
414                                         StatEventI("Payout Error!", _hGame);
415                                 } else {
416                                         //StatEventI("Winner Paid", _hGame);
417                                 }
418                         }
419                 }
420         }
421 
422 
423         //------------------------------------------------------
424         // handle a bet made by a player, validate the player and game
425         // add to players balance
426         //------------------------------------------------------
427         function handleBet(uint _hGame) public payable 
428         {
429                 address _arbAddr = arbiterTokens[ArbTokFromHGame(_hGame)];
430                 if (_arbAddr == address(0)) {
431                         throw; // "Invalid hGame"
432                 }
433 
434                 var (valid, pidx) = validPlayer(_hGame, msg.sender);
435                 if (!valid) {
436                         throw; // "Invalid Player"
437                 }
438 
439                 gameInstance xgame = games[_hGame];
440                 xgame.playerPots[pidx] += uint128(msg.value);
441                 xgame.totalPot += uint128(msg.value);
442                 //StatEventI("Bet Added", _hGame);
443         }
444 
445 
446         //------------------------------------------------------
447         // return if arb token exists
448         //------------------------------------------------------
449         function arbTokenExists(uint _tok) constant returns (bool _exists)
450         {
451                 _exists = false;
452                 if ((_tok > 0)
453                         && (arbiterTokens[_tok] != address(0))
454                         && arbiters[arbiterTokens[_tok]].registered)
455                         _exists = true;
456 
457         }
458 
459 
460         //------------------------------------------------------
461         // return arbiter game stats
462         //------------------------------------------------------
463         function getArbInfo(uint _tok) constant  returns (address _addr, uint _escFeePctX10, uint _arbFeePctX10, uint _feeCap, uint _holdOver) 
464         {
465                 // if (arbiterTokens[_tok] != address(0)) {
466                         _addr = arbiterTokens[_tok]; 
467                          arbiter xarb = arbiters[arbiterTokens[_tok]];
468                         _escFeePctX10 = xarb.escFeePctX10;
469                         _arbFeePctX10 = xarb.arbFeePctX10;
470                         _feeCap = xarb.feeCap;
471                         _holdOver = xarb.arbHoldover; 
472                 // }
473         }
474 
475         //------------------------------------------------------
476         // scan for a game 10 minutes old
477         // if found abort the game, causing funds to be returned
478         //------------------------------------------------------
479         function houseKeep(int _max, uint _arbToken) public
480         {
481                 uint gi;
482                 address a;
483                 int aborted = 0;
484 
485                 arbiter xarb = arbiters[msg.sender];// have to set it to something
486                 
487          
488                 if (msg.sender == owner) {
489                         for (uint ar = 0; (ar < numArbiters) && (aborted < _max) ; ar++) {
490                             a = arbiterIndexes[ar];
491                             xarb = arbiters[a];    
492 
493                             for ( gi = 0; (gi < xarb.gameSlots) && (aborted < _max); gi++) {
494                                 gameInstance ngame0 = games[xarb.gameIndexes[gi]];
495                                 if ((ngame0.active)
496                                     && ((now - ngame0.lastMoved) > gameTimeOut)) {
497                                         abortGame(xarb.gameIndexes[gi], EndReason.erTimeOut);
498                                         ++aborted;
499                                 }
500                             }
501                         }
502 
503                 } else {
504                         if (!validArb(msg.sender, _arbToken))
505                                 StatEvent("Housekeep invalid arbiter");
506                         else {
507                             a = msg.sender;
508                             xarb = arbiters[a];    
509                             for (gi = 0; (gi < xarb.gameSlots) && (aborted < _max); gi++) {
510                                 gameInstance ngame1 = games[xarb.gameIndexes[gi]];
511                                 if ((ngame1.active)
512                                     && ((now - ngame1.lastMoved) > gameTimeOut)) {
513                                         abortGame(xarb.gameIndexes[gi], EndReason.erTimeOut);
514                                         ++aborted;
515                                 }
516                             }
517 
518                         }
519                 }
520         }
521 
522 
523         //------------------------------------------------------
524         // return game info
525         //------------------------------------------------------
526         function getGameInfo(uint _hGame)  constant  returns (EndReason _reason, uint _players, uint _totalPot, bool _active)
527         {
528                 gameInstance xgame = games[_hGame];
529                 _active = xgame.active;
530                 _players = xgame.numPlayers;
531                 _totalPot = xgame.totalPot;
532                 _reason = xgame.reasonEnded;
533 
534         }
535 
536         //------------------------------------------------------
537         // return arbToken and low bytes from an HGame
538         //------------------------------------------------------
539         function checkHGame(uint _hGame) constant returns(uint _arbTok, uint _lowWords)
540         {
541                 _arbTok = ArbTokFromHGame(_hGame);
542                 _lowWords = _hGame & 0xffffffffffff;
543 
544         }
545 
546         //------------------------------------------------------
547         // get operation gas amounts
548         //------------------------------------------------------
549         function getOpGas() constant returns (uint _ag, uint _tg) 
550         {
551                 _ag = acctCallGas; // winner paid
552                 _tg = tokCallGas;     // token contract call gas
553         }
554 
555 
556         //------------------------------------------------------
557         // set operation gas amounts for forwading operations
558         //------------------------------------------------------
559         function setOpGas(uint _ag, uint _tg) 
560         {
561                 if (msg.sender != owner)
562                         throw;
563 
564                 acctCallGas = _ag;
565                 tokCallGas = _tg;
566         }
567 
568 
569         //------------------------------------------------------
570         // set a micheivous arbiter to locked
571         //------------------------------------------------------
572         function setArbiterLocked(address _addr, bool _lock)  public 
573         {
574                 if (owner != msg.sender)  {
575                         throw; 
576                 } else if (!validArb2(_addr)) {
577                         StatEvent("invalid arb");
578                 } else {
579                         arbiters[_addr].locked = _lock;
580                 }
581 
582         }
583 
584         //------------------------------------------------------
585         // flush the house fees whenever commanded to.
586         // ignore the threshold and the last payout time
587         // but this time only reset lastpayouttime upon success
588         //------------------------------------------------------
589         function flushHouseFees()
590         {
591                 if (msg.sender != owner) {
592                         StatEvent("only owner calls this function");
593                 } else if (houseFeeHoldover > 0) {
594                         uint ntmpho = houseFeeHoldover;
595                         houseFeeHoldover = 0;
596                         if (!tokenPartner.call.gas(tokCallGas).value(ntmpho)()) {
597                                 houseFeeHoldover = ntmpho; // put it back
598                                 StatEvent("House-Fee Error2"); 
599                         } else {
600                                 lastPayoutTime = now;
601                                 StatEvent("House-Fee Paid");
602                         }
603                 }
604         }
605 
606 
607         // ----------------------------
608         // withdraw expense funds to arbiter
609         // ----------------------------
610         function withdrawArbFunds() public
611         {
612                 if (!validArb2(msg.sender)) {
613                         StatEvent("invalid arbiter");
614                 } else {
615                         arbiter xarb = arbiters[msg.sender];
616                         if (xarb.arbHoldover == 0) { 
617                                 StatEvent("0 Balance");
618                                 return;
619                         } else {
620                                 uint _amount = xarb.arbHoldover; 
621                                 xarb.arbHoldover = 0; 
622                                 if (!msg.sender.call.gas(acctCallGas).value(_amount)())
623                                         throw;
624                         }
625                 }
626         }
627 
628 
629         //------------------------------------------------------
630         // set the token partner
631         //------------------------------------------------------
632         function setTokenPartner(address _addr) public
633         {
634                 if (msg.sender != owner) {
635                         throw;
636                 } 
637 
638                 if ((settingsState == SettingStateValue.lockedRelease) 
639                         && (tokenPartner == address(0))) {
640                         tokenPartner = _addr;
641                         StatEvent("Token Partner Final!");
642                 } else if (settingsState != SettingStateValue.lockedRelease) {
643                         tokenPartner = _addr;
644                         StatEvent("Token Partner Assigned!");
645                 }
646 
647         }
648 
649         // ----------------------------
650         // swap executor
651         // ----------------------------
652         function changeOwner(address _addr) 
653         {
654                 if (msg.sender != owner
655                         || settingsState == SettingStateValue.lockedRelease)
656                          throw;
657 
658                 owner = _addr;
659         }
660 
661 }