1 pragma solidity ^0.4.24;
2 
3 /*
4 
5 ETHEREUM WORLD CUP : 14th June - 15th July 2018 [Russia]
6     - designed and implemented by Norsefire.
7     - thanks to Etherguy and oguzhanox for debugging and front-end respectively.
8 
9 Rules are as follows:
10     * Entry to the game costs 0.2018 Ether. Use the register function when sending this.
11         - Any larger or smaller amount of Ether, will be rejected.
12     * 90% of the entry fee will go towards the prize fund, with 10% forming a fee.
13         Of this fee, half goes to the developer, and half goes directly to Giveth (giveth.io/donate).
14         The entry fee is the only Ether you will need to send for the duration of the
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
32     FIRST  PLACE: 40% of Ether contained within the pot.
33     SECOND PLACE: 30% of Ether contained within the pot.
34     THIRD  PLACE: 20% of Ether contained within the pot.
35     FOURTH PLACE: 10% of Ether contained within the pot.
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
89     string name   = "EtherWorldCup";
90     string symbol = "EWC";
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
171         gameLocked[1]           = 1528988400;
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
365     //   only Ether you will need to spend throughout the tournament.
366     function register()
367         public
368         payable
369     {
370         address _customerAddress = msg.sender;
371         require(    !playerRegistered[_customerAddress]
372                   && tx.origin == _customerAddress);
373         // Receive the entry fee tokens.
374         require(BTCTKN.transferFrom(_customerAddress, address(this), entryFee));
375         
376         registeredPlayers = SafeMath.addint256(registeredPlayers, 1);
377         playerRegistered[_customerAddress] = true;
378         playerGamesScored[_customerAddress] = 0;
379         playerList.push(_customerAddress);
380         require(playerRegistered[_customerAddress]);
381         prizePool  = prizePool.add(ninetyPercent);
382         givethPool = givethPool.add(fivePercent);
383         adminPool  = adminPool.add(fivePercent);
384         emit Registration(_customerAddress);
385     }
386 
387     // Make a prediction for a game. An example would be makePrediction(1, "DRAW")
388     //   if you anticipate a draw in the game between Russia and Saudi Arabia,
389     //   or makePrediction(2, "UY") if you expect Uruguay to beat Egypt.
390     // The "DRAW" option becomes invalid after the group stage games have been played.
391     function makePrediction(int8 _gameID, string _prediction)
392         public {
393         address _customerAddress             = msg.sender;
394         uint    predictionTime               = now;
395         require(playerRegistered[_customerAddress]
396                 && !gameFinished[_gameID]
397                 && predictionTime < gameLocked[_gameID]);
398         // No draws allowed after the qualification stage.
399         if (_gameID > 48 && equalStrings(_prediction, "DRAW")) {
400             revert();
401         } else {
402             playerPredictions[_customerAddress][_gameID]    = _prediction;
403             playerMadePrediction[_customerAddress][_gameID] = true;
404             emit PlayerLoggedPrediction(_customerAddress, _gameID, _prediction);
405         }
406     }
407 
408     // What is the current score of a given tournament participant?
409     function showPlayerScores(address _participant)
410         view
411         public
412         returns (int8[64])
413     {
414         return playerPointArray[_participant];
415     }
416 
417     function seekApproval()
418         public
419         returns (bool)
420     {
421         BTCTKN.approve(address(this), entryFee);
422     }
423     
424     // What was the last game ID that has had an official score registered for it?
425     function gameResultsLogged()
426         view
427         public
428         returns (int)
429     {
430         return latestGameFinished;
431     }
432 
433     // Sum up the individual scores throughout the tournament and produce a final result.
434     function calculateScore(address _participant)
435         view
436         public
437         returns (int16)
438     {
439         int16 finalScore = 0;
440         for (int8 i = 0; i < latestGameFinished; i++) {
441             uint j = uint(i);
442             int16 gameScore = playerPointArray[_participant][j];
443             finalScore = SafeMath.addint16(finalScore, gameScore);
444         }
445         return finalScore;
446     }
447 
448     // How many people are taking part in the tournament?
449     function countParticipants()
450         public
451         view
452         returns (int)
453     {
454         return registeredPlayers;
455     }
456 
457     // Keeping this open for anyone to update anyone else so that at the end of
458     // the tournament we can force a score update for everyone using a script.
459     function updateScore(address _participant)
460         public
461     {
462         int8                     lastPlayed     = latestGameFinished;
463         require(lastPlayed > 0);
464         // Most recent game scored for this participant.
465         int8                     lastScored     = playerGamesScored[_participant];
466         // Most recent game played in the tournament (sets bounds for scoring iteration).
467         mapping (int8 => bool)   madePrediction = playerMadePrediction[_participant];
468         mapping (int8 => string) playerGuesses  = playerPredictions[_participant];
469         for (int8 i = lastScored; i < lastPlayed; i++) {
470             uint j = uint(i);
471             uint k = j.add(1);
472             uint streak = playerStreak[_participant];
473             emit StartScoring(_participant, k);
474             if (!madePrediction[int8(k)]) {
475                 playerPointArray[_participant][j] = 0;
476                 playerStreak[_participant]        = 0;
477                 emit DidNotPredict(_participant, k);
478             } else {
479                 string storage playerResult = playerGuesses[int8(k)];
480                 string storage actualResult = gameResult[int8(k)];
481                 bool correctGuess = equalStrings(playerResult, actualResult);
482                 emit Comparison(_participant, k, playerResult, actualResult, correctGuess);
483                  if (!correctGuess) {
484                      // The guess was wrong.
485                      playerPointArray[_participant][j] = 0;
486                      playerStreak[_participant]        = 0;
487                  } else {
488                      // The guess was right.
489                      streak = streak.add(1);
490                      playerStreak[_participant] = streak;
491                      if (streak >= 5) {
492                          // On a long streak - four points.
493                         playerPointArray[_participant][j] = 4;
494                      } else {
495                          if (streak >= 3) {
496                             // On a short streak - two points.
497                             playerPointArray[_participant][j] = 2;
498               }
499                          // Not yet at a streak - standard one point.
500                          else { playerPointArray[_participant][j] = 1; }
501                      }
502                  }
503             }
504         }
505         playerGamesScored[_participant] = lastPlayed;
506     }
507 
508     // Invoke this function to get *everyone* up to date score-wise.
509     // This is probably best used at the end of the tournament, to ensure
510     // that prizes are awarded to the correct addresses.
511     // Note: this is going to be VERY gas-intensive. Use it if you're desperate
512     //         to see how you square up against everyone else if they're slow to
513     //         update their own scores. Alternatively, if there's just one or two
514     //         stragglers, you can just call updateScore for them alone.
515     function updateAllScores()
516         public
517     {
518         uint allPlayers = playerList.length;
519         for (uint i = 0; i < allPlayers; i++) {
520             address _toScore = playerList[i];
521             emit StartAutoScoring(_toScore);
522             updateScore(_toScore);
523         }
524     }
525 
526     // Which game ID has a player last computed their score up to
527     //   using the updateScore function?
528     function playerLastScoredGame(address _player)
529         public
530         view
531         returns (int8)
532     {
533         return playerGamesScored[_player];
534     }
535 
536     // Is a player registered?
537     function playerIsRegistered(address _player)
538         public
539         view
540         returns (bool)
541     {
542         return playerRegistered[_player];
543     }
544 
545     // What was the official result of a game?
546     function correctResult(int8 _gameID)
547         public
548         view
549         returns (string)
550     {
551         return gameResult[_gameID];
552     }
553 
554     // What was the caller's prediction for a given game?
555     function playerGuess(int8 _gameID)
556         public
557         view
558         returns (string)
559     {
560         return playerPredictions[msg.sender][_gameID];
561     }
562 
563     // Lets us calculate what a participants score would be if they ran updateScore.
564     // Does NOT perform any state update.
565     function viewScore(address _participant)
566         public
567         view
568         returns (uint)
569     {
570         int8                     lastPlayed     = latestGameFinished;
571         // Most recent game played in the tournament (sets bounds for scoring iteration).
572         mapping (int8 => bool)   madePrediction = playerMadePrediction[_participant];
573         mapping (int8 => string) playerGuesses  = playerPredictions[_participant];
574         uint internalResult = 0;
575         uint internalStreak = 0;
576         for (int8 i = 0; i < lastPlayed; i++) {
577             uint j = uint(i);
578             uint k = j.add(1);
579             uint streak = internalStreak;
580 
581             if (!madePrediction[int8(k)]) {
582                 internalStreak = 0;
583             } else {
584                 string storage playerResult = playerGuesses[int8(k)];
585                 string storage actualResult = gameResult[int8(k)];
586                 bool correctGuess = equalStrings(playerResult, actualResult);
587                  if (!correctGuess) {
588                     internalStreak = 0;
589                  } else {
590                      // The guess was right.
591                      internalStreak++;
592                      streak++;
593                      if (streak >= 5) {
594                          // On a long streak - four points.
595                         internalResult += 4;
596                      } else {
597                          if (streak >= 3) {
598                             // On a short streak - two points.
599                             internalResult += 2;
600               }
601                          // Not yet at a streak - standard one point.
602                          else { internalResult += 1; }
603                      }
604                  }
605             }
606         }
607         return internalResult;
608     }
609 
610     /* ADMINISTRATOR FUNCTIONS FOR COMPETITION MAINTENANCE */
611 
612     modifier isAdministrator() {
613         address _sender = msg.sender;
614         if (_sender == administrator) {
615             _;
616         } else {
617             revert();
618         }
619     }
620 
621     function _btcToken(address _tokenContract) private pure returns (bool) {
622         return _tokenContract == BTCTKNADDR; // Returns "true" if this is the 0xBTC Token Contract
623     }
624     
625     // As new fixtures become known through progression or elimination, they're added here.
626     function addNewGame(string _opponents, int8 _gameID)
627         isAdministrator
628         public {
629             worldCupGameID[_opponents] = _gameID;
630     }
631 
632     // When the result of a game is known, enter the result.
633     function logResult(int8 _gameID, string _winner)
634         isAdministrator
635         public {
636         require((int8(0) < _gameID) && (_gameID <= 64)
637              && _gameID == latestGameFinished + 1);
638         // No draws allowed after the qualification stage.
639         if (_gameID > 48 && equalStrings(_winner, "DRAW")) {
640             revert();
641         } else {
642             require(!gameFinished[_gameID]);
643             gameFinished [_gameID] = true;
644             gameResult   [_gameID] = _winner;
645             latestGameFinished     = _gameID;
646             assert(gameFinished[_gameID]);
647         }
648     }
649 
650     // Concludes the tournament and issues the prizes, then self-destructs.
651     function concludeTournament(address _first   // 40% Ether.
652                               , address _second  // 30% Ether.
653                               , address _third   // 20% Ether.
654                               , address _fourth) // 10% Ether.
655         isAdministrator
656         public
657     {
658         // Don't hand out prizes until the final's... actually been played.
659         require(gameFinished[64]
660              && playerIsRegistered(_first)
661              && playerIsRegistered(_second)
662              && playerIsRegistered(_third)
663              && playerIsRegistered(_fourth));
664         // Determine 10% of the prize pool to distribute to winners.
665         uint tenth       = prizePool.div(10);
666         // Determine the prize allocations.
667         uint firstPrize  = tenth.mul(4);
668         uint secondPrize = tenth.mul(3);
669         uint thirdPrize  = tenth.mul(2);
670         // Send the first three prizes.
671         BTCTKN.approve(_first, firstPrize);
672         BTCTKN.transferFrom(address(this), _first, firstPrize);
673         BTCTKN.approve(_second, secondPrize);
674         BTCTKN.transferFrom(address(this), _second, secondPrize);
675         BTCTKN.approve(_third, thirdPrize);
676         BTCTKN.transferFrom(address(this), _third, thirdPrize);
677         // Send the tokens raised to Giveth.
678         BTCTKN.approve(givethAddress, givethPool);
679         BTCTKN.transferFrom(address(this), givethAddress, givethPool);
680         // Send the tokens assigned to developer.
681         BTCTKN.approve(administrator, adminPool);
682         BTCTKN.transferFrom(address(this), administrator, adminPool);
683         // Since there might be rounding errors, fourth place gets everything else.
684         uint fourthPrize = ((prizePool.sub(firstPrize)).sub(secondPrize)).sub(thirdPrize);
685         BTCTKN.approve(_fourth, fourthPrize);
686         BTCTKN.transferFrom(address(this), _fourth, fourthPrize);
687         selfdestruct(administrator);
688     }
689 
690     // The emergency escape hatch in case something has gone wrong.
691     // Given the small amount of individual coins per participant, it would
692     // be far more expensive in gas than what's sent back if required.
693     // You're going to have to take it on trust that I (the dev, duh), will
694     // sort out refunds. Let's pray to Suarez it doesn't need pulling.
695     function pullRipCord()
696         isAdministrator
697         public
698     {
699         uint totalPool = (prizePool.add(givethPool)).add(adminPool);
700         BTCTKN.approve(administrator, totalPool);
701         BTCTKN.transferFrom(address(this), administrator, totalPool);
702         selfdestruct(administrator);
703     }
704 
705    /* INTERNAL FUNCTIONS */
706 
707     // Gateway check - did you send exactly the right amount?
708     function _isCorrectBuyin(uint _buyin)
709         private
710         pure
711         returns (bool) {
712         return _buyin == entryFee;
713     }
714 
715     // Internal comparison between strings, returning 0 if equal, 1 otherwise.
716     function compare(string _a, string _b)
717         private
718         pure
719         returns (int)
720     {
721         bytes memory a = bytes(_a);
722         bytes memory b = bytes(_b);
723         uint minLength = a.length;
724         if (b.length < minLength) minLength = b.length;
725         for (uint i = 0; i < minLength; i ++)
726             if (a[i] < b[i])
727                 return -1;
728             else if (a[i] > b[i])
729                 return 1;
730         if (a.length < b.length)
731             return -1;
732         else if (a.length > b.length)
733             return 1;
734         else
735             return 0;
736     }
737 
738     /// Compares two strings and returns true if and only if they are equal.
739     function equalStrings(string _a, string _b) pure private returns (bool) {
740         return compare(_a, _b) == 0;
741     }
742 
743 }
744 
745 library SafeMath {
746 
747     /**
748     * @dev Multiplies two numbers, throws on overflow.
749     */
750     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
751         if (a == 0) {
752             return 0;
753         }
754         uint256 c = a * b;
755         assert(c / a == b);
756         return c;
757     }
758 
759     /**
760     * @dev Integer division of two numbers, truncating the quotient.
761     */
762     function div(uint256 a, uint256 b) internal pure returns (uint256) {
763         // assert(b > 0); // Solidity automatically throws when dividing by 0
764         uint256 c = a / b;
765         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
766         return c;
767     }
768 
769     /**
770     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
771     */
772     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
773         assert(b <= a);
774         return a - b;
775     }
776 
777     /**
778     * @dev Adds two numbers, throws on overflow.
779     */
780     function add(uint256 a, uint256 b) internal pure returns (uint256) {
781         uint256 c = a + b;
782         assert(c >= a);
783         return c;
784     }
785 
786     function addint16(int16 a, int16 b) internal pure returns (int16) {
787         int16 c = a + b;
788         assert(c >= a);
789         return c;
790     }
791 
792     function addint256(int256 a, int256 b) internal pure returns (int256) {
793         int256 c = a + b;
794         assert(c >= a);
795         return c;
796     }
797 }