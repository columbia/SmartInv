1 pragma solidity ^0.4.24;
2 
3 /*
4 
5 0xBTC WORLD CUP : 14th June - 15th July 2018 [Russia]
6     - designed and implemented by Norsefire.
7     - thanks to Etherguy and oguzhanox for debugging and front-end respectively.
8 
9 Rules are as follows:
10     * Entry to the game costs 0.2018 0xBTC. Use the register function when sending this.
11         - Any larger or smaller amount of 0xBTC, will be rejected.
12     * 90% of the entry price will go towards the prize fund, with 10% forming a fee.
13         Of this fee, half goes to the developer, and half goes directly to Giveth (giveth.io/donate).
14         The entry fee is the only 0xBTC you will need to send for the duration of the
15         tournament, barring the gas you spend for placing predictions.
16     * Buying an entry allows the sender to place predictions on each game in the World Cup,
17         barring those which have already kicked off prior to the time a participant enters.
18     * Predictions can be made (or changed!) at any point up until the indicated kick-off time.
19     * Selecting the correct result for any given game awards the player one point.
20         In the first stage, a participant can also select a draw. This is not available from the RO16 onwards.
21     * If a participant reaches a streak of three or more correct predictions in a row, they receive two points
22         for every correct prediction from the third game until the streak is broken.
23     * If a participant reaches a streak of *five* or more correct predictions in a row, they receive four points
24         for every correct prediction from the fifth game until the streak is broken.
25     * In the event of a tie, the following algorithm is used to decide rankings:
26         - Compare the sum totals of the scores over the last 32 games.
27         - If this produces a draw as well, compare results of the last 16 games.
28         - This repeats until comparing the results of the final.
29         - If it's a dead heat throughout, a coin-flip (or some equivalent method) will be used to determine the winner.
30 
31 Prizes:
32     FIRST  PLACE: 40% of 0xBTC contained within the pot.
33     SECOND PLACE: 30% of 0xBTC contained within the pot.
34     THIRD  PLACE: 20% of 0xBTC contained within the pot.
35     FOURTH PLACE: 10% of 0xBTC contained within the pot.
36 
37 Participant Teams and Groups:
38 
39 [Group D] AR - Argentina
40 [Group C] AU - Australia
41 [Group G] BE - Belgium
42 [Group E] BR - Brazil
43 [Group E] CH - Switzerland
44 [Group H] CO - Colombia
45 [Group E] CR - Costa Rica
46 [Group E] CS - Serbia
47 [Group F] DE - Germany
48 [Group C] DK - Denmark
49 [Group A] EG - Egypt
50 [Group G] EN - England
51 [Group B] ES - Spain
52 [Group C] FR - France
53 [Group D] HR - Croatia
54 [Group B] IR - Iran
55 [Group D] IS - Iceland
56 [Group H] JP - Japan
57 [Group F] KR - Republic of Korea
58 [Group B] MA - Morocco
59 [Group F] MX - Mexico
60 [Group D] NG - Nigeria
61 [Group G] PA - Panama
62 [Group C] PE - Peru
63 [Group H] PL - Poland
64 [Group B] PT - Portugal
65 [Group A] RU - Russia
66 [Group A] SA - Saudi Arabia
67 [Group F] SE - Sweden
68 [Group H] SN - Senegal
69 [Group G] TN - Tunisia
70 [Group A] UY - Uruguay
71 
72 */
73 
74 contract ZeroBTCInterface {
75     function approve(address spender, uint tokens) public returns (bool success);
76     function transferFrom(address from, address to, uint tokens) public returns (bool success);
77 }
78 
79 contract ZeroBTCWorldCup {
80     using SafeMath for uint;
81 
82     /* CONSTANTS */
83 
84     address internal constant administrator = 0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae;
85     address internal constant givethAddress = 0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc;
86     address internal constant BTCTKNADDR    = 0xB6eD7644C69416d67B522e20bC294A9a9B405B31;
87     ZeroBTCInterface public BTCTKN;
88 
89     string name   = "0xBTCWorldCup";
90     string symbol = "0xBTCWC";
91     uint    internal constant entryFee      = 2018e15;
92     uint    internal constant ninetyPercent = 18162e14;
93     uint    internal constant fivePercent   = 1009e14;
94     uint    internal constant tenPercent    = 2018e14;
95 
96     /* VARIABLES */
97 
98     mapping (string =>  int8)                     worldCupGameID;
99     mapping (int8   =>  bool)                     gameFinished;
100     // Is a game no longer available for predictions to be made?
101     mapping (int8   =>  uint)                     gameLocked;
102     // A result is either the two digit code of a country, or the word "DRAW".
103     // Country codes are listed above.
104     mapping (int8   =>  string)                   gameResult;
105     int8 internal                                 latestGameFinished;
106     uint internal                                 prizePool;
107     uint internal                                 givethPool;
108     uint internal                                 adminPool;
109     int                                           registeredPlayers;
110 
111     mapping (address => bool)                     playerRegistered;
112     mapping (address => mapping (int8 => bool))   playerMadePrediction;
113     mapping (address => mapping (int8 => string)) playerPredictions;
114     mapping (address => int8[64])                 playerPointArray;
115     mapping (address => int8)                     playerGamesScored;
116     mapping (address => uint)                     playerStreak;
117     address[]                                     playerList;
118 
119     /* DEBUG EVENTS */
120 
121     event Registration(
122         address _player
123     );
124 
125     event PlayerLoggedPrediction(
126         address _player,
127         int     _gameID,
128         string  _prediction
129     );
130 
131     event PlayerUpdatedScore(
132         address _player,
133         int     _lastGamePlayed
134     );
135 
136     event Comparison(
137         address _player,
138         uint    _gameID,
139         string  _myGuess,
140         string  _result,
141         bool    _correct
142     );
143 
144     event StartAutoScoring(
145         address _player
146     );
147 
148     event StartScoring(
149         address _player,
150         uint    _gameID
151     );
152 
153     event DidNotPredict(
154         address _player,
155         uint    _gameID
156     );
157 
158     event RipcordRefund(
159         address _player
160     );
161 
162     /* CONSTRUCTOR */
163 
164     constructor ()
165         public
166     {
167         // First stage games: these are known in advance.
168 
169         // Thursday 14th June, 2018
170         worldCupGameID["RU-SA"] = 1;   // Russia       vs Saudi Arabia
171         gameLocked[1]           = 1528993800;
172 
173         // Friday 15th June, 2018
174         worldCupGameID["EG-UY"] = 2;   // Egypt        vs Uruguay
175         worldCupGameID["MA-IR"] = 3;   // Morocco      vs Iran
176         worldCupGameID["PT-ES"] = 4;   // Portugal     vs Spain
177         gameLocked[2]           = 1529064000;
178         gameLocked[3]           = 1529074800;
179         gameLocked[4]           = 1529085600;
180 
181         // Saturday 16th June, 2018
182         worldCupGameID["FR-AU"] = 5;   // France       vs Australia
183         worldCupGameID["AR-IS"] = 6;   // Argentina    vs Iceland
184         worldCupGameID["PE-DK"] = 7;   // Peru         vs Denmark
185         worldCupGameID["HR-NG"] = 8;   // Croatia      vs Nigeria
186         gameLocked[5]           = 1529143200;
187         gameLocked[6]           = 1529154000;
188         gameLocked[7]           = 1529164800;
189         gameLocked[8]           = 1529175600;
190 
191         // Sunday 17th June, 2018
192         worldCupGameID["CR-CS"] = 9;   // Costa Rica   vs Serbia
193         worldCupGameID["DE-MX"] = 10;  // Germany      vs Mexico
194         worldCupGameID["BR-CH"] = 11;  // Brazil       vs Switzerland
195         gameLocked[9]           = 1529236800;
196         gameLocked[10]          = 1529247600;
197         gameLocked[11]          = 1529258400;
198 
199         // Monday 18th June, 2018
200         worldCupGameID["SE-KR"] = 12;  // Sweden       vs Korea
201         worldCupGameID["BE-PA"] = 13;  // Belgium      vs Panama
202         worldCupGameID["TN-EN"] = 14;  // Tunisia      vs England
203         gameLocked[12]          = 1529323200;
204         gameLocked[13]          = 1529334000;
205         gameLocked[14]          = 1529344800;
206 
207         // Tuesday 19th June, 2018
208         worldCupGameID["CO-JP"] = 15;  // Colombia     vs Japan
209         worldCupGameID["PL-SN"] = 16;  // Poland       vs Senegal
210         worldCupGameID["RU-EG"] = 17;  // Russia       vs Egypt
211         gameLocked[15]          = 1529409600;
212         gameLocked[16]          = 1529420400;
213         gameLocked[17]          = 1529431200;
214 
215         // Wednesday 20th June, 2018
216         worldCupGameID["PT-MA"] = 18;  // Portugal     vs Morocco
217         worldCupGameID["UR-SA"] = 19;  // Uruguay      vs Saudi Arabia
218         worldCupGameID["IR-ES"] = 20;  // Iran         vs Spain
219         gameLocked[18]          = 1529496000;
220         gameLocked[19]          = 1529506800;
221         gameLocked[20]          = 1529517600;
222 
223         // Thursday 21st June, 2018
224         worldCupGameID["DK-AU"] = 21;  // Denmark      vs Australia
225         worldCupGameID["FR-PE"] = 22;  // France       vs Peru
226         worldCupGameID["AR-HR"] = 23;  // Argentina    vs Croatia
227         gameLocked[21]          = 1529582400;
228         gameLocked[22]          = 1529593200;
229         gameLocked[23]          = 1529604000;
230 
231         // Friday 22nd June, 2018
232         worldCupGameID["BR-CR"] = 24;  // Brazil       vs Costa Rica
233         worldCupGameID["NG-IS"] = 25;  // Nigeria      vs Iceland
234         worldCupGameID["CS-CH"] = 26;  // Serbia       vs Switzerland
235         gameLocked[24]          = 1529668800;
236         gameLocked[25]          = 1529679600;
237         gameLocked[26]          = 1529690400;
238 
239         // Saturday 23rd June, 2018
240         worldCupGameID["BE-TN"] = 27;  // Belgium      vs Tunisia
241         worldCupGameID["KR-MX"] = 28;  // Korea        vs Mexico
242         worldCupGameID["DE-SE"] = 29;  // Germany      vs Sweden
243         gameLocked[27]          = 1529755200;
244         gameLocked[28]          = 1529766000;
245         gameLocked[29]          = 1529776800;
246 
247         // Sunday 24th June, 2018
248         worldCupGameID["EN-PA"] = 30;  // England      vs Panama
249         worldCupGameID["JP-SN"] = 31;  // Japan        vs Senegal
250         worldCupGameID["PL-CO"] = 32;  // Poland       vs Colombia
251         gameLocked[30]          = 1529841600;
252         gameLocked[31]          = 1529852400;
253         gameLocked[32]          = 1529863200;
254 
255         // Monday 25th June, 2018
256         worldCupGameID["UR-RU"] = 33;  // Uruguay      vs Russia
257         worldCupGameID["SA-EG"] = 34;  // Saudi Arabia vs Egypt
258         worldCupGameID["ES-MA"] = 35;  // Spain        vs Morocco
259         worldCupGameID["IR-PT"] = 36;  // Iran         vs Portugal
260         gameLocked[33]          = 1529935200;
261         gameLocked[34]          = 1529935200;
262         gameLocked[35]          = 1529949600;
263         gameLocked[36]          = 1529949600;
264 
265         // Tuesday 26th June, 2018
266         worldCupGameID["AU-PE"] = 37;  // Australia    vs Peru
267         worldCupGameID["DK-FR"] = 38;  // Denmark      vs France
268         worldCupGameID["NG-AR"] = 39;  // Nigeria      vs Argentina
269         worldCupGameID["IS-HR"] = 40;  // Iceland      vs Croatia
270         gameLocked[37]          = 1530021600;
271         gameLocked[38]          = 1530021600;
272         gameLocked[39]          = 1530036000;
273         gameLocked[40]          = 1530036000;
274 
275         // Wednesday 27th June, 2018
276         worldCupGameID["KR-DE"] = 41;  // Korea        vs Germany
277         worldCupGameID["MX-SE"] = 42;  // Mexico       vs Sweden
278         worldCupGameID["CS-BR"] = 43;  // Serbia       vs Brazil
279         worldCupGameID["CH-CR"] = 44;  // Switzerland  vs Costa Rica
280         gameLocked[41]          = 1530108000;
281         gameLocked[42]          = 1530108000;
282         gameLocked[43]          = 1530122400;
283         gameLocked[44]          = 1530122400;
284 
285         // Thursday 28th June, 2018
286         worldCupGameID["JP-PL"] = 45;  // Japan        vs Poland
287         worldCupGameID["SN-CO"] = 46;  // Senegal      vs Colombia
288         worldCupGameID["PA-TN"] = 47;  // Panama       vs Tunisia
289         worldCupGameID["EN-BE"] = 48;  // England      vs Belgium
290         gameLocked[45]          = 1530194400;
291         gameLocked[46]          = 1530194400;
292         gameLocked[47]          = 1530208800;
293         gameLocked[48]          = 1530208800;
294 
295         // Second stage games and onwards. The string values for these will be overwritten
296         //   as the tournament progresses. This is the order that will be followed for the
297         //   purposes of calculating winning streaks, as per the World Cup website.
298 
299         // Round of 16
300         // Saturday 30th June, 2018
301         worldCupGameID["1C-2D"]   = 49;  // 1C         vs 2D
302         worldCupGameID["1A-2B"]   = 50;  // 1A         vs 2B
303         gameLocked[49]            = 1530367200;
304         gameLocked[50]            = 1530381600;
305 
306         // Sunday 1st July, 2018
307         worldCupGameID["1B-2A"]   = 51;  // 1B         vs 2A
308         worldCupGameID["1D-2C"]   = 52;  // 1D         vs 2C
309         gameLocked[51]            = 1530453600;
310         gameLocked[52]            = 1530468000;
311 
312         // Monday 2nd July, 2018
313         worldCupGameID["1E-2F"]   = 53;  // 1E         vs 2F
314         worldCupGameID["1G-2H"]   = 54;  // 1G         vs 2H
315         gameLocked[53]            = 1530540000;
316         gameLocked[54]            = 1530554400;
317 
318         // Tuesday 3rd July, 2018
319         worldCupGameID["1F-2E"]   = 55;  // 1F         vs 2E
320         worldCupGameID["1H-2G"]   = 56;  // 1H         vs 2G
321         gameLocked[55]            = 1530626400;
322         gameLocked[56]            = 1530640800;
323 
324         // Quarter Finals
325         // Friday 6th July, 2018
326         worldCupGameID["W49-W50"] = 57; // W49         vs W50
327         worldCupGameID["W53-W54"] = 58; // W53         vs W54
328         gameLocked[57]            = 1530885600;
329         gameLocked[58]            = 1530900000;
330 
331         // Saturday 7th July, 2018
332         worldCupGameID["W55-W56"] = 59; // W55         vs W56
333         worldCupGameID["W51-W52"] = 60; // W51         vs W52
334         gameLocked[59]            = 1530972000;
335         gameLocked[60]            = 1530986400;
336 
337         // Semi Finals
338         // Tuesday 10th July, 2018
339         worldCupGameID["W57-W58"] = 61; // W57         vs W58
340         gameLocked[61]            = 1531245600;
341 
342         // Wednesday 11th July, 2018
343         worldCupGameID["W59-W60"] = 62; // W59         vs W60
344         gameLocked[62]            = 1531332000;
345 
346         // Third Place Playoff
347         // Saturday 14th July, 2018
348         worldCupGameID["L61-L62"] = 63; // L61         vs L62
349         gameLocked[63]            = 1531576800;
350 
351         // Grand Final
352         // Sunday 15th July, 2018
353         worldCupGameID["W61-W62"] = 64; // W61         vs W62
354         gameLocked[64]            = 1531666800;
355 
356         // Set initial variables.
357         latestGameFinished = 0;
358 
359     }
360 
361     /* PUBLIC-FACING COMPETITION INTERACTIONS */
362     
363     // Register to participate in the competition. Apart from gas costs from
364     //   making predictions and updating your score if necessary, this is the
365     //   only 0xBTC you will need to spend throughout the tournament.
366     function register()
367         public
368     {
369         address _customerAddress = msg.sender;
370         require(!playerRegistered[_customerAddress]);
371         // Receive the entry fee tokens.
372         BTCTKN.transferFrom(_customerAddress, address(this), entryFee);
373         
374         registeredPlayers = SafeMath.addint256(registeredPlayers, 1);
375         playerRegistered[_customerAddress] = true;
376         playerGamesScored[_customerAddress] = 0;
377         playerList.push(_customerAddress);
378         require(playerRegistered[_customerAddress]);
379         prizePool  = prizePool.add(ninetyPercent);
380         givethPool = givethPool.add(fivePercent);
381         adminPool  = adminPool.add(fivePercent);
382         emit Registration(_customerAddress);
383     }
384 
385     // Make a prediction for a game. An example would be makePrediction(1, "DRAW")
386     //   if you anticipate a draw in the game between Russia and Saudi Arabia,
387     //   or makePrediction(2, "UY") if you expect Uruguay to beat Egypt.
388     // The "DRAW" option becomes invalid after the group stage games have been played.
389     function makePrediction(int8 _gameID, string _prediction)
390         public {
391         address _customerAddress             = msg.sender;
392         uint    predictionTime               = now;
393         require(playerRegistered[_customerAddress]
394                 && !gameFinished[_gameID]
395                 && predictionTime < gameLocked[_gameID]);
396         // No draws allowed after the qualification stage.
397         if (_gameID > 48 && equalStrings(_prediction, "DRAW")) {
398             revert();
399         } else {
400             playerPredictions[_customerAddress][_gameID]    = _prediction;
401             playerMadePrediction[_customerAddress][_gameID] = true;
402             emit PlayerLoggedPrediction(_customerAddress, _gameID, _prediction);
403         }
404     }
405 
406     // What is the current score of a given tournament participant?
407     function showPlayerScores(address _participant)
408         view
409         public
410         returns (int8[64])
411     {
412         return playerPointArray[_participant];
413     }
414 
415     function seekApproval()
416         public
417         returns (bool)
418     {
419         BTCTKN.approve(address(this), entryFee);
420     }
421     
422     // What was the last game ID that has had an official score registered for it?
423     function gameResultsLogged()
424         view
425         public
426         returns (int)
427     {
428         return latestGameFinished;
429     }
430 
431     // Sum up the individual scores throughout the tournament and produce a final result.
432     function calculateScore(address _participant)
433         view
434         public
435         returns (int16)
436     {
437         int16 finalScore = 0;
438         for (int8 i = 0; i < latestGameFinished; i++) {
439             uint j = uint(i);
440             int16 gameScore = playerPointArray[_participant][j];
441             finalScore = SafeMath.addint16(finalScore, gameScore);
442         }
443         return finalScore;
444     }
445 
446     // How many people are taking part in the tournament?
447     function countParticipants()
448         public
449         view
450         returns (int)
451     {
452         return registeredPlayers;
453     }
454 
455     // Keeping this open for anyone to update anyone else so that at the end of
456     // the tournament we can force a score update for everyone using a script.
457     function updateScore(address _participant)
458         public
459     {
460         int8                     lastPlayed     = latestGameFinished;
461         require(lastPlayed > 0);
462         // Most recent game scored for this participant.
463         int8                     lastScored     = playerGamesScored[_participant];
464         // Most recent game played in the tournament (sets bounds for scoring iteration).
465         mapping (int8 => bool)   madePrediction = playerMadePrediction[_participant];
466         mapping (int8 => string) playerGuesses  = playerPredictions[_participant];
467         for (int8 i = lastScored; i < lastPlayed; i++) {
468             uint j = uint(i);
469             uint k = j.add(1);
470             uint streak = playerStreak[_participant];
471             emit StartScoring(_participant, k);
472             if (!madePrediction[int8(k)]) {
473                 playerPointArray[_participant][j] = 0;
474                 playerStreak[_participant]        = 0;
475                 emit DidNotPredict(_participant, k);
476             } else {
477                 string storage playerResult = playerGuesses[int8(k)];
478                 string storage actualResult = gameResult[int8(k)];
479                 bool correctGuess = equalStrings(playerResult, actualResult);
480                 emit Comparison(_participant, k, playerResult, actualResult, correctGuess);
481                  if (!correctGuess) {
482                      // The guess was wrong.
483                      playerPointArray[_participant][j] = 0;
484                      playerStreak[_participant]        = 0;
485                  } else {
486                      // The guess was right.
487                      streak = streak.add(1);
488                      playerStreak[_participant] = streak;
489                      if (streak >= 5) {
490                          // On a long streak - four points.
491                         playerPointArray[_participant][j] = 4;
492                      } else {
493                          if (streak >= 3) {
494                             // On a short streak - two points.
495                             playerPointArray[_participant][j] = 2;
496               }
497                          // Not yet at a streak - standard one point.
498                          else { playerPointArray[_participant][j] = 1; }
499                      }
500                  }
501             }
502         }
503         playerGamesScored[_participant] = lastPlayed;
504     }
505 
506     // Invoke this function to get *everyone* up to date score-wise.
507     // This is probably best used at the end of the tournament, to ensure
508     // that prizes are awarded to the correct addresses.
509     // Note: this is going to be VERY gas-intensive. Use it if you're desperate
510     //         to see how you square up against everyone else if they're slow to
511     //         update their own scores. Alternatively, if there's just one or two
512     //         stragglers, you can just call updateScore for them alone.
513     function updateAllScores()
514         public
515     {
516         uint allPlayers = playerList.length;
517         for (uint i = 0; i < allPlayers; i++) {
518             address _toScore = playerList[i];
519             emit StartAutoScoring(_toScore);
520             updateScore(_toScore);
521         }
522     }
523 
524     // Which game ID has a player last computed their score up to
525     //   using the updateScore function?
526     function playerLastScoredGame(address _player)
527         public
528         view
529         returns (int8)
530     {
531         return playerGamesScored[_player];
532     }
533 
534     // Is a player registered?
535     function playerIsRegistered(address _player)
536         public
537         view
538         returns (bool)
539     {
540         return playerRegistered[_player];
541     }
542 
543     // What was the official result of a game?
544     function correctResult(int8 _gameID)
545         public
546         view
547         returns (string)
548     {
549         return gameResult[_gameID];
550     }
551 
552     // What was the caller's prediction for a given game?
553     function playerGuess(int8 _gameID)
554         public
555         view
556         returns (string)
557     {
558         return playerPredictions[msg.sender][_gameID];
559     }
560 
561     // Lets us calculate what a participants score would be if they ran updateScore.
562     // Does NOT perform any state update.
563     function viewScore(address _participant)
564         public
565         view
566         returns (uint)
567     {
568         int8                     lastPlayed     = latestGameFinished;
569         // Most recent game played in the tournament (sets bounds for scoring iteration).
570         mapping (int8 => bool)   madePrediction = playerMadePrediction[_participant];
571         mapping (int8 => string) playerGuesses  = playerPredictions[_participant];
572         uint internalResult = 0;
573         uint internalStreak = 0;
574         for (int8 i = 0; i < lastPlayed; i++) {
575             uint j = uint(i);
576             uint k = j.add(1);
577             uint streak = internalStreak;
578 
579             if (!madePrediction[int8(k)]) {
580                 internalStreak = 0;
581             } else {
582                 string storage playerResult = playerGuesses[int8(k)];
583                 string storage actualResult = gameResult[int8(k)];
584                 bool correctGuess = equalStrings(playerResult, actualResult);
585                  if (!correctGuess) {
586                     internalStreak = 0;
587                  } else {
588                      // The guess was right.
589                      internalStreak++;
590                      streak++;
591                      if (streak >= 5) {
592                          // On a long streak - four points.
593                         internalResult += 4;
594                      } else {
595                          if (streak >= 3) {
596                             // On a short streak - two points.
597                             internalResult += 2;
598               }
599                          // Not yet at a streak - standard one point.
600                          else { internalResult += 1; }
601                      }
602                  }
603             }
604         }
605         return internalResult;
606     }
607 
608     /* ADMINISTRATOR FUNCTIONS FOR COMPETITION MAINTENANCE */
609 
610     modifier isAdministrator() {
611         address _sender = msg.sender;
612         if (_sender == administrator) {
613             _;
614         } else {
615             revert();
616         }
617     }
618 
619     function _btcToken(address _tokenContract) private pure returns (bool) {
620         return _tokenContract == BTCTKNADDR; // Returns "true" if this is the 0xBTC Token Contract
621     }
622     
623     // As new fixtures become known through progression or elimination, they're added here.
624     function addNewGame(string _opponents, int8 _gameID)
625         isAdministrator
626         public {
627             worldCupGameID[_opponents] = _gameID;
628     }
629 
630     // When the result of a game is known, enter the result.
631     function logResult(int8 _gameID, string _winner)
632         isAdministrator
633         public {
634         require((int8(0) < _gameID) && (_gameID <= 64)
635              && _gameID == latestGameFinished + 1);
636         // No draws allowed after the qualification stage.
637         if (_gameID > 48 && equalStrings(_winner, "DRAW")) {
638             revert();
639         } else {
640             require(!gameFinished[_gameID]);
641             gameFinished [_gameID] = true;
642             gameResult   [_gameID] = _winner;
643             latestGameFinished     = _gameID;
644             assert(gameFinished[_gameID]);
645         }
646     }
647 
648     // Concludes the tournament and issues the prizes, then self-destructs.
649     function concludeTournament(address _first   // 40% 0xBTC.
650                               , address _second  // 30% 0xBTC.
651                               , address _third   // 20% 0xBTC.
652                               , address _fourth) // 10% 0xBTC.
653         isAdministrator
654         public
655     {
656         // Don't hand out prizes until the final's... actually been played.
657         require(gameFinished[64]
658              && playerIsRegistered(_first)
659              && playerIsRegistered(_second)
660              && playerIsRegistered(_third)
661              && playerIsRegistered(_fourth));
662         // Determine 10% of the prize pool to distribute to winners.
663         uint tenth       = prizePool.div(10);
664         // Determine the prize allocations.
665         uint firstPrize  = tenth.mul(4);
666         uint secondPrize = tenth.mul(3);
667         uint thirdPrize  = tenth.mul(2);
668         // Send the first three prizes.
669         BTCTKN.approve(_first, firstPrize);
670         BTCTKN.transferFrom(address(this), _first, firstPrize);
671         BTCTKN.approve(_second, secondPrize);
672         BTCTKN.transferFrom(address(this), _second, secondPrize);
673         BTCTKN.approve(_third, thirdPrize);
674         BTCTKN.transferFrom(address(this), _third, thirdPrize);
675         // Send the tokens raised to Giveth.
676         BTCTKN.approve(givethAddress, givethPool);
677         BTCTKN.transferFrom(address(this), givethAddress, givethPool);
678         // Send the tokens assigned to developer.
679         BTCTKN.approve(administrator, adminPool);
680         BTCTKN.transferFrom(address(this), administrator, adminPool);
681         // Since there might be rounding errors, fourth place gets everything else.
682         uint fourthPrize = ((prizePool.sub(firstPrize)).sub(secondPrize)).sub(thirdPrize);
683         BTCTKN.approve(_fourth, fourthPrize);
684         BTCTKN.transferFrom(address(this), _fourth, fourthPrize);
685         selfdestruct(administrator);
686     }
687 
688     // The emergency escape hatch in case something has gone wrong.
689     // Given the small amount of individual coins per participant, it would
690     // be far more expensive in gas than what's sent back if required.
691     // You're going to have to take it on trust that I (the dev, duh), will
692     // sort out refunds. Let's pray to Suarez it doesn't need pulling.
693     function pullRipCord()
694         isAdministrator
695         public
696     {
697         uint totalPool = (prizePool.add(givethPool)).add(adminPool);
698         BTCTKN.transferFrom(address(this), administrator, totalPool);
699         selfdestruct(administrator);
700     }
701 
702    /* INTERNAL FUNCTIONS */
703 
704     // Gateway check - did you send exactly the right amount?
705     function _isCorrectBuyin(uint _buyin)
706         private
707         pure
708         returns (bool) {
709         return _buyin == entryFee;
710     }
711 
712     // Internal comparison between strings, returning 0 if equal, 1 otherwise.
713     function compare(string _a, string _b)
714         private
715         pure
716         returns (int)
717     {
718         bytes memory a = bytes(_a);
719         bytes memory b = bytes(_b);
720         uint minLength = a.length;
721         if (b.length < minLength) minLength = b.length;
722         for (uint i = 0; i < minLength; i ++)
723             if (a[i] < b[i])
724                 return -1;
725             else if (a[i] > b[i])
726                 return 1;
727         if (a.length < b.length)
728             return -1;
729         else if (a.length > b.length)
730             return 1;
731         else
732             return 0;
733     }
734 
735     /// Compares two strings and returns true if and only if they are equal.
736     function equalStrings(string _a, string _b) pure private returns (bool) {
737         return compare(_a, _b) == 0;
738     }
739 
740 }
741 
742 library SafeMath {
743 
744     /**
745     * @dev Multiplies two numbers, throws on overflow.
746     */
747     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
748         if (a == 0) {
749             return 0;
750         }
751         uint256 c = a * b;
752         assert(c / a == b);
753         return c;
754     }
755 
756     /**
757     * @dev Integer division of two numbers, truncating the quotient.
758     */
759     function div(uint256 a, uint256 b) internal pure returns (uint256) {
760         // assert(b > 0); // Solidity automatically throws when dividing by 0
761         uint256 c = a / b;
762         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
763         return c;
764     }
765 
766     /**
767     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
768     */
769     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
770         assert(b <= a);
771         return a - b;
772     }
773 
774     /**
775     * @dev Adds two numbers, throws on overflow.
776     */
777     function add(uint256 a, uint256 b) internal pure returns (uint256) {
778         uint256 c = a + b;
779         assert(c >= a);
780         return c;
781     }
782 
783     function addint16(int16 a, int16 b) internal pure returns (int16) {
784         int16 c = a + b;
785         assert(c >= a);
786         return c;
787     }
788 
789     function addint256(int256 a, int256 b) internal pure returns (int256) {
790         int256 c = a + b;
791         assert(c >= a);
792         return c;
793     }
794 }