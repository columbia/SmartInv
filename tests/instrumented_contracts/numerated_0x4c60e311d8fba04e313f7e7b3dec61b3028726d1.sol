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
74 contract EtherWorldCup {
75     using SafeMath for uint;
76 
77     /* CONSTANTS */
78 
79     address internal constant administrator = 0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae;
80     address internal constant givethAddress = 0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc;
81 
82     string name   = "EtherWorldCup";
83     string symbol = "EWC";
84 
85     /* VARIABLES */
86 
87     mapping (string =>  int8)                     worldCupGameID;
88     mapping (int8   =>  bool)                     gameFinished;
89     // Is a game no longer available for predictions to be made?
90     mapping (int8   =>  uint)                     gameLocked;
91     // A result is either the two digit code of a country, or the word "DRAW".
92     // Country codes are listed above.
93     mapping (int8   =>  string)                   gameResult;
94     int8 internal                                 latestGameFinished;
95     uint internal                                 prizePool;
96     uint internal                                 givethPool;
97     int                                           registeredPlayers;
98 
99     mapping (address => bool)                     playerRegistered;
100     mapping (address => mapping (int8 => bool))   playerMadePrediction;
101     mapping (address => mapping (int8 => string)) playerPredictions;
102     mapping (address => int8[64])                 playerPointArray;
103     mapping (address => int8)                     playerGamesScored;
104     mapping (address => uint)                     playerStreak;
105     address[]                                     playerList;
106 
107     /* DEBUG EVENTS */
108 
109     event Registration(
110         address _player
111     );
112 
113     event PlayerLoggedPrediction(
114         address _player,
115         int     _gameID,
116         string  _prediction
117     );
118 
119     event PlayerUpdatedScore(
120         address _player,
121         int     _lastGamePlayed
122     );
123 
124     event Comparison(
125         address _player,
126         uint    _gameID,
127         string  _myGuess,
128         string  _result,
129         bool    _correct
130     );
131 
132     event StartAutoScoring(
133         address _player
134     );
135 
136     event StartScoring(
137         address _player,
138         uint    _gameID
139     );
140 
141     event DidNotPredict(
142         address _player,
143         uint    _gameID
144     );
145 
146     event RipcordRefund(
147         address _player
148     );
149 
150     /* CONSTRUCTOR */
151 
152     constructor ()
153         public
154     {
155         // First stage games: these are known in advance.
156 
157         // Thursday 14th June, 2018
158         worldCupGameID["RU-SA"] = 1;   // Russia       vs Saudi Arabia
159         gameLocked[1]           = 1528988400;
160 
161         // Friday 15th June, 2018
162         worldCupGameID["EG-UY"] = 2;   // Egypt        vs Uruguay
163         worldCupGameID["MA-IR"] = 3;   // Morocco      vs Iran
164         worldCupGameID["PT-ES"] = 4;   // Portugal     vs Spain
165         gameLocked[2]           = 1529064000;
166         gameLocked[3]           = 1529074800;
167         gameLocked[4]           = 1529085600;
168 
169         // Saturday 16th June, 2018
170         worldCupGameID["FR-AU"] = 5;   // France       vs Australia
171         worldCupGameID["AR-IS"] = 6;   // Argentina    vs Iceland
172         worldCupGameID["PE-DK"] = 7;   // Peru         vs Denmark
173         worldCupGameID["HR-NG"] = 8;   // Croatia      vs Nigeria
174         gameLocked[5]           = 1529143200;
175         gameLocked[6]           = 1529154000;
176         gameLocked[7]           = 1529164800;
177         gameLocked[8]           = 1529175600;
178 
179         // Sunday 17th June, 2018
180         worldCupGameID["CR-CS"] = 9;   // Costa Rica   vs Serbia
181         worldCupGameID["DE-MX"] = 10;  // Germany      vs Mexico
182         worldCupGameID["BR-CH"] = 11;  // Brazil       vs Switzerland
183         gameLocked[9]           = 1529236800;
184         gameLocked[10]          = 1529247600;
185         gameLocked[11]          = 1529258400;
186 
187         // Monday 18th June, 2018
188         worldCupGameID["SE-KR"] = 12;  // Sweden       vs Korea
189         worldCupGameID["BE-PA"] = 13;  // Belgium      vs Panama
190         worldCupGameID["TN-EN"] = 14;  // Tunisia      vs England
191         gameLocked[12]          = 1529323200;
192         gameLocked[13]          = 1529334000;
193         gameLocked[14]          = 1529344800;
194 
195         // Tuesday 19th June, 2018
196         worldCupGameID["CO-JP"] = 15;  // Colombia     vs Japan
197         worldCupGameID["PL-SN"] = 16;  // Poland       vs Senegal
198         worldCupGameID["RU-EG"] = 17;  // Russia       vs Egypt
199         gameLocked[15]          = 1529409600;
200         gameLocked[16]          = 1529420400;
201         gameLocked[17]          = 1529431200;
202 
203         // Wednesday 20th June, 2018
204         worldCupGameID["PT-MA"] = 18;  // Portugal     vs Morocco
205         worldCupGameID["UR-SA"] = 19;  // Uruguay      vs Saudi Arabia
206         worldCupGameID["IR-ES"] = 20;  // Iran         vs Spain
207         gameLocked[18]          = 1529496000;
208         gameLocked[19]          = 1529506800;
209         gameLocked[20]          = 1529517600;
210 
211         // Thursday 21st June, 2018
212         worldCupGameID["DK-AU"] = 21;  // Denmark      vs Australia
213         worldCupGameID["FR-PE"] = 22;  // France       vs Peru
214         worldCupGameID["AR-HR"] = 23;  // Argentina    vs Croatia
215         gameLocked[21]          = 1529582400;
216         gameLocked[22]          = 1529593200;
217         gameLocked[23]          = 1529604000;
218 
219         // Friday 22nd June, 2018
220         worldCupGameID["BR-CR"] = 24;  // Brazil       vs Costa Rica
221         worldCupGameID["NG-IS"] = 25;  // Nigeria      vs Iceland
222         worldCupGameID["CS-CH"] = 26;  // Serbia       vs Switzerland
223         gameLocked[24]          = 1529668800;
224         gameLocked[25]          = 1529679600;
225         gameLocked[26]          = 1529690400;
226 
227         // Saturday 23rd June, 2018
228         worldCupGameID["BE-TN"] = 27;  // Belgium      vs Tunisia
229         worldCupGameID["KR-MX"] = 28;  // Korea        vs Mexico
230         worldCupGameID["DE-SE"] = 29;  // Germany      vs Sweden
231         gameLocked[27]          = 1529755200;
232         gameLocked[28]          = 1529766000;
233         gameLocked[29]          = 1529776800;
234 
235         // Sunday 24th June, 2018
236         worldCupGameID["EN-PA"] = 30;  // England      vs Panama
237         worldCupGameID["JP-SN"] = 31;  // Japan        vs Senegal
238         worldCupGameID["PL-CO"] = 32;  // Poland       vs Colombia
239         gameLocked[30]          = 1529841600;
240         gameLocked[31]          = 1529852400;
241         gameLocked[32]          = 1529863200;
242 
243         // Monday 25th June, 2018
244         worldCupGameID["UR-RU"] = 33;  // Uruguay      vs Russia
245         worldCupGameID["SA-EG"] = 34;  // Saudi Arabia vs Egypt
246         worldCupGameID["ES-MA"] = 35;  // Spain        vs Morocco
247         worldCupGameID["IR-PT"] = 36;  // Iran         vs Portugal
248         gameLocked[33]          = 1529935200;
249         gameLocked[34]          = 1529935200;
250         gameLocked[35]          = 1529949600;
251         gameLocked[36]          = 1529949600;
252 
253         // Tuesday 26th June, 2018
254         worldCupGameID["AU-PE"] = 37;  // Australia    vs Peru
255         worldCupGameID["DK-FR"] = 38;  // Denmark      vs France
256         worldCupGameID["NG-AR"] = 39;  // Nigeria      vs Argentina
257         worldCupGameID["IS-HR"] = 40;  // Iceland      vs Croatia
258         gameLocked[37]          = 1530021600;
259         gameLocked[38]          = 1530021600;
260         gameLocked[39]          = 1530036000;
261         gameLocked[40]          = 1530036000;
262 
263         // Wednesday 27th June, 2018
264         worldCupGameID["KR-DE"] = 41;  // Korea        vs Germany
265         worldCupGameID["MX-SE"] = 42;  // Mexico       vs Sweden
266         worldCupGameID["CS-BR"] = 43;  // Serbia       vs Brazil
267         worldCupGameID["CH-CR"] = 44;  // Switzerland  vs Costa Rica
268         gameLocked[41]          = 1530108000;
269         gameLocked[42]          = 1530108000;
270         gameLocked[43]          = 1530122400;
271         gameLocked[44]          = 1530122400;
272 
273         // Thursday 28th June, 2018
274         worldCupGameID["JP-PL"] = 45;  // Japan        vs Poland
275         worldCupGameID["SN-CO"] = 46;  // Senegal      vs Colombia
276         worldCupGameID["PA-TN"] = 47;  // Panama       vs Tunisia
277         worldCupGameID["EN-BE"] = 48;  // England      vs Belgium
278         gameLocked[45]          = 1530194400;
279         gameLocked[46]          = 1530194400;
280         gameLocked[47]          = 1530208800;
281         gameLocked[48]          = 1530208800;
282 
283         // Second stage games and onwards. The string values for these will be overwritten
284         //   as the tournament progresses. This is the order that will be followed for the
285         //   purposes of calculating winning streaks, as per the World Cup website.
286 
287         // Round of 16
288         // Saturday 30th June, 2018
289         worldCupGameID["1C-2D"]   = 49;  // 1C         vs 2D
290         worldCupGameID["1A-2B"]   = 50;  // 1A         vs 2B
291         gameLocked[49]            = 1530367200;
292         gameLocked[50]            = 1530381600;
293 
294         // Sunday 1st July, 2018
295         worldCupGameID["1B-2A"]   = 51;  // 1B         vs 2A
296         worldCupGameID["1D-2C"]   = 52;  // 1D         vs 2C
297         gameLocked[51]            = 1530453600;
298         gameLocked[52]            = 1530468000;
299 
300         // Monday 2nd July, 2018
301         worldCupGameID["1E-2F"]   = 53;  // 1E         vs 2F
302         worldCupGameID["1G-2H"]   = 54;  // 1G         vs 2H
303         gameLocked[53]            = 1530540000;
304         gameLocked[54]            = 1530554400;
305 
306         // Tuesday 3rd July, 2018
307         worldCupGameID["1F-2E"]   = 55;  // 1F         vs 2E
308         worldCupGameID["1H-2G"]   = 56;  // 1H         vs 2G
309         gameLocked[55]            = 1530626400;
310         gameLocked[56]            = 1530640800;
311 
312         // Quarter Finals
313         // Friday 6th July, 2018
314         worldCupGameID["W49-W50"] = 57; // W49         vs W50
315         worldCupGameID["W53-W54"] = 58; // W53         vs W54
316         gameLocked[57]            = 1530885600;
317         gameLocked[58]            = 1530900000;
318 
319         // Saturday 7th July, 2018
320         worldCupGameID["W55-W56"] = 59; // W55         vs W56
321         worldCupGameID["W51-W52"] = 60; // W51         vs W52
322         gameLocked[59]            = 1530972000;
323         gameLocked[60]            = 1530986400;
324 
325         // Semi Finals
326         // Tuesday 10th July, 2018
327         worldCupGameID["W57-W58"] = 61; // W57         vs W58
328         gameLocked[61]            = 1531245600;
329 
330         // Wednesday 11th July, 2018
331         worldCupGameID["W59-W60"] = 62; // W59         vs W60
332         gameLocked[62]            = 1531332000;
333 
334         // Third Place Playoff
335         // Saturday 14th July, 2018
336         worldCupGameID["L61-L62"] = 63; // L61         vs L62
337         gameLocked[63]            = 1531576800;
338 
339         // Grand Final
340         // Sunday 15th July, 2018
341         worldCupGameID["W61-W62"] = 64; // W61         vs W62
342         gameLocked[64]            = 1531666800;
343 
344         // Set initial variables.
345         latestGameFinished = 0;
346 
347     }
348 
349     /* PUBLIC-FACING COMPETITION INTERACTIONS */
350 
351     // Register to participate in the competition. Apart from gas costs from
352     //   making predictions and updating your score if necessary, this is the
353     //   only Ether you will need to spend throughout the tournament.
354     function register()
355         public
356         payable
357     {
358         address _customerAddress = msg.sender;
359         require(   tx.origin == _customerAddress
360                 && !playerRegistered[_customerAddress]
361                 && _isCorrectBuyin (msg.value));
362         registeredPlayers = SafeMath.addint256(registeredPlayers, 1);
363         playerRegistered[_customerAddress] = true;
364         playerGamesScored[_customerAddress] = 0;
365         playerList.push(_customerAddress);
366         uint fivePercent = 0.01009 ether;
367         uint tenPercent  = 0.02018 ether;
368         uint prizeEth    = (msg.value).sub(tenPercent);
369         require(playerRegistered[_customerAddress]);
370         prizePool  = prizePool.add(prizeEth);
371         givethPool = givethPool.add(fivePercent);
372         administrator.send(fivePercent);
373         emit Registration(_customerAddress);
374     }
375 
376     // Make a prediction for a game. An example would be makePrediction(1, "DRAW")
377     //   if you anticipate a draw in the game between Russia and Saudi Arabia,
378     //   or makePrediction(2, "UY") if you expect Uruguay to beat Egypt.
379     // The "DRAW" option becomes invalid after the group stage games have been played.
380     function makePrediction(int8 _gameID, string _prediction)
381         public {
382         address _customerAddress             = msg.sender;
383         uint    predictionTime               = now;
384         require(playerRegistered[_customerAddress]
385                 && !gameFinished[_gameID]
386                 && predictionTime < gameLocked[_gameID]);
387         // No draws allowed after the qualification stage.
388         if (_gameID > 48 && equalStrings(_prediction, "DRAW")) {
389             revert();
390         } else {
391             playerPredictions[_customerAddress][_gameID]    = _prediction;
392             playerMadePrediction[_customerAddress][_gameID] = true;
393             emit PlayerLoggedPrediction(_customerAddress, _gameID, _prediction);
394         }
395     }
396 
397     // What is the current score of a given tournament participant?
398     function showPlayerScores(address _participant)
399         view
400         public
401         returns (int8[64])
402     {
403         return playerPointArray[_participant];
404     }
405 
406     // What was the last game ID that has had an official score registered for it?
407     function gameResultsLogged()
408         view
409         public
410         returns (int)
411     {
412         return latestGameFinished;
413     }
414 
415     // Sum up the individual scores throughout the tournament and produce a final result.
416     function calculateScore(address _participant)
417         view
418         public
419         returns (int16)
420     {
421         int16 finalScore = 0;
422         for (int8 i = 0; i < latestGameFinished; i++) {
423             uint j = uint(i);
424             int16 gameScore = playerPointArray[_participant][j];
425             finalScore = SafeMath.addint16(finalScore, gameScore);
426         }
427         return finalScore;
428     }
429 
430     // How many people are taking part in the tournament?
431     function countParticipants()
432         public
433         view
434         returns (int)
435     {
436         return registeredPlayers;
437     }
438 
439     // Keeping this open for anyone to update anyone else so that at the end of
440     // the tournament we can force a score update for everyone using a script.
441     function updateScore(address _participant)
442         public
443     {
444         int8                     lastPlayed     = latestGameFinished;
445         require(lastPlayed > 0);
446         // Most recent game scored for this participant.
447         int8                     lastScored     = playerGamesScored[_participant];
448         // Most recent game played in the tournament (sets bounds for scoring iteration).
449         mapping (int8 => bool)   madePrediction = playerMadePrediction[_participant];
450         mapping (int8 => string) playerGuesses  = playerPredictions[_participant];
451         for (int8 i = lastScored; i < lastPlayed; i++) {
452             uint j = uint(i);
453             uint k = j.add(1);
454             uint streak = playerStreak[_participant];
455             emit StartScoring(_participant, k);
456             if (!madePrediction[int8(k)]) {
457                 playerPointArray[_participant][j] = 0;
458                 playerStreak[_participant]        = 0;
459                 emit DidNotPredict(_participant, k);
460             } else {
461                 string storage playerResult = playerGuesses[int8(k)];
462                 string storage actualResult = gameResult[int8(k)];
463                 bool correctGuess = equalStrings(playerResult, actualResult);
464                 emit Comparison(_participant, k, playerResult, actualResult, correctGuess);
465                  if (!correctGuess) {
466                      // The guess was wrong.
467                      playerPointArray[_participant][j] = 0;
468                      playerStreak[_participant]        = 0;
469                  } else {
470                      // The guess was right.
471                      streak = streak.add(1);
472                      playerStreak[_participant] = streak;
473                      if (streak >= 5) {
474                          // On a long streak - four points.
475                         playerPointArray[_participant][j] = 4;
476                      } else {
477                          if (streak >= 3) {
478                             // On a short streak - two points.
479                             playerPointArray[_participant][j] = 2;
480               }
481                          // Not yet at a streak - standard one point.
482                          else { playerPointArray[_participant][j] = 1; }
483                      }
484                  }
485             }
486         }
487         playerGamesScored[_participant] = lastPlayed;
488     }
489 
490     // Invoke this function to get *everyone* up to date score-wise.
491     // This is probably best used at the end of the tournament, to ensure
492     // that prizes are awarded to the correct addresses.
493     // Note: this is going to be VERY gas-intensive. Use it if you're desperate
494     //         to see how you square up against everyone else if they're slow to
495     //         update their own scores. Alternatively, if there's just one or two
496     //         stragglers, you can just call updateScore for them alone.
497     function updateAllScores()
498         public
499     {
500         uint allPlayers = playerList.length;
501         for (uint i = 0; i < allPlayers; i++) {
502             address _toScore = playerList[i];
503             emit StartAutoScoring(_toScore);
504             updateScore(_toScore);
505         }
506     }
507 
508     // Which game ID has a player last computed their score up to
509     //   using the updateScore function?
510     function playerLastScoredGame(address _player)
511         public
512         view
513         returns (int8)
514     {
515         return playerGamesScored[_player];
516     }
517 
518     // Is a player registered?
519     function playerIsRegistered(address _player)
520         public
521         view
522         returns (bool)
523     {
524         return playerRegistered[_player];
525     }
526 
527     // What was the official result of a game?
528     function correctResult(int8 _gameID)
529         public
530         view
531         returns (string)
532     {
533         return gameResult[_gameID];
534     }
535 
536     // What was the caller's prediction for a given game?
537     function playerGuess(int8 _gameID)
538         public
539         view
540         returns (string)
541     {
542         return playerPredictions[msg.sender][_gameID];
543     }
544 
545     // Lets us calculate what a participants score would be if they ran updateScore.
546     // Does NOT perform any state update.
547     function viewScore(address _participant)
548         public
549         view
550         returns (uint)
551     {
552         int8                     lastPlayed     = latestGameFinished;
553         // Most recent game played in the tournament (sets bounds for scoring iteration).
554         mapping (int8 => bool)   madePrediction = playerMadePrediction[_participant];
555         mapping (int8 => string) playerGuesses  = playerPredictions[_participant];
556         uint internalResult = 0;
557         uint internalStreak = 0;
558         for (int8 i = 0; i < lastPlayed; i++) {
559             uint j = uint(i);
560             uint k = j.add(1);
561             uint streak = internalStreak;
562 
563             if (!madePrediction[int8(k)]) {
564                 internalStreak = 0;
565             } else {
566                 string storage playerResult = playerGuesses[int8(k)];
567                 string storage actualResult = gameResult[int8(k)];
568                 bool correctGuess = equalStrings(playerResult, actualResult);
569                  if (!correctGuess) {
570                     internalStreak = 0;
571                  } else {
572                      // The guess was right.
573                      internalStreak++;
574                      streak++;
575                      if (streak >= 5) {
576                          // On a long streak - four points.
577                         internalResult += 4;
578                      } else {
579                          if (streak >= 3) {
580                             // On a short streak - two points.
581                             internalResult += 2;
582               }
583                          // Not yet at a streak - standard one point.
584                          else { internalResult += 1; }
585                      }
586                  }
587             }
588         }
589         return internalResult;
590     }
591 
592     /* ADMINISTRATOR FUNCTIONS FOR COMPETITION MAINTENANCE */
593 
594     modifier isAdministrator() {
595         address _sender = msg.sender;
596         if (_sender == administrator) {
597             _;
598         } else {
599             revert();
600         }
601     }
602 
603     // As new fixtures become known through progression or elimination, they're added here.
604     function addNewGame(string _opponents, int8 _gameID)
605         isAdministrator
606         public {
607             worldCupGameID[_opponents] = _gameID;
608     }
609 
610     // When the result of a game is known, enter the result.
611     function logResult(int8 _gameID, string _winner)
612         isAdministrator
613         public {
614         require((int8(0) < _gameID) && (_gameID <= 64)
615              && _gameID == latestGameFinished + 1);
616         // No draws allowed after the qualification stage.
617         if (_gameID > 48 && equalStrings(_winner, "DRAW")) {
618             revert();
619         } else {
620             require(!gameFinished[_gameID]);
621             gameFinished [_gameID] = true;
622             gameResult   [_gameID] = _winner;
623             latestGameFinished     = _gameID;
624             assert(gameFinished[_gameID]);
625         }
626     }
627 
628     // Concludes the tournament and issues the prizes, then self-destructs.
629     function concludeTournament(address _first   // 40% Ether.
630                               , address _second  // 30% Ether.
631                               , address _third   // 20% Ether.
632                               , address _fourth) // 10% Ether.
633         isAdministrator
634         public
635     {
636         // Don't hand out prizes until the final's... actually been played.
637         require(gameFinished[64]
638              && playerIsRegistered(_first)
639              && playerIsRegistered(_second)
640              && playerIsRegistered(_third)
641              && playerIsRegistered(_fourth));
642         // Send the money raised for Giveth.
643         givethAddress.send(givethPool);
644         // Determine 10% of the prize pool to distribute to winners.
645         uint tenth    = prizePool.div(10);
646         _first.send (tenth.mul(4));
647         _second.send(tenth.mul(3));
648         _third.send (tenth.mul(2));
649         // Since there might be rounding errors, fourth place gets everything else.
650         _fourth.send(address(this).balance);
651         // Thanks for playing, everyone.
652         selfdestruct(administrator);
653     }
654 
655     // The emergency escape hatch in case something has gone wrong. Refunds 95% of purchase Ether
656     //   to all registered addresses: the other 0.01009 has been sent directly to the developer who can
657     //   handle sending that back to everyone using a script.
658     // Let's hope this one doesn't have to get pulled, eh?
659     function pullRipCord()
660         isAdministrator
661         public
662     {
663         uint players = playerList.length;
664         for (uint i = 0; i < players; i++) {
665             address _toRefund = playerList[i];
666             _toRefund.send(0.19171 ether);
667             emit RipcordRefund(_toRefund);
668         }
669         selfdestruct(administrator);
670     }
671 
672    /* INTERNAL FUNCTIONS */
673 
674     // Gateway check - did you send exactly the right amount?
675     function _isCorrectBuyin(uint _buyin)
676         private
677         pure
678         returns (bool) {
679         return _buyin == 0.2018 ether;
680     }
681 
682     // Internal comparison between strings, returning 0 if equal, 1 otherwise.
683     function compare(string _a, string _b)
684         private
685         pure
686         returns (int)
687     {
688         bytes memory a = bytes(_a);
689         bytes memory b = bytes(_b);
690         uint minLength = a.length;
691         if (b.length < minLength) minLength = b.length;
692         for (uint i = 0; i < minLength; i ++)
693             if (a[i] < b[i])
694                 return -1;
695             else if (a[i] > b[i])
696                 return 1;
697         if (a.length < b.length)
698             return -1;
699         else if (a.length > b.length)
700             return 1;
701         else
702             return 0;
703     }
704 
705     /// Compares two strings and returns true if and only if they are equal.
706     function equalStrings(string _a, string _b) pure private returns (bool) {
707         return compare(_a, _b) == 0;
708     }
709 
710 }
711 
712 library SafeMath {
713 
714     /**
715     * @dev Multiplies two numbers, throws on overflow.
716     */
717     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
718         if (a == 0) {
719             return 0;
720         }
721         uint256 c = a * b;
722         assert(c / a == b);
723         return c;
724     }
725 
726     /**
727     * @dev Integer division of two numbers, truncating the quotient.
728     */
729     function div(uint256 a, uint256 b) internal pure returns (uint256) {
730         // assert(b > 0); // Solidity automatically throws when dividing by 0
731         uint256 c = a / b;
732         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
733         return c;
734     }
735 
736     /**
737     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
738     */
739     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
740         assert(b <= a);
741         return a - b;
742     }
743 
744     /**
745     * @dev Adds two numbers, throws on overflow.
746     */
747     function add(uint256 a, uint256 b) internal pure returns (uint256) {
748         uint256 c = a + b;
749         assert(c >= a);
750         return c;
751     }
752 
753     function addint16(int16 a, int16 b) internal pure returns (int16) {
754         int16 c = a + b;
755         assert(c >= a);
756         return c;
757     }
758 
759     function addint256(int256 a, int256 b) internal pure returns (int256) {
760         int256 c = a + b;
761         assert(c >= a);
762         return c;
763     }
764 }