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
132     event PlayerPointGain(
133         address _player,
134         uint _gameID,
135         uint _streak,
136         uint _points
137     );
138     
139     event StartAutoScoring(
140         address _player
141     );
142     
143     event StartScoring(
144         address _player,
145         uint    _gameID
146     );
147     
148     event DidNotPredict(
149         address _player,
150         uint    _gameID
151     );
152     
153     event RipcordRefund(
154         address _player
155     );
156     
157     /* CONSTRUCTOR */
158     
159     constructor ()
160         public
161     {
162         // First stage games: these are known in advance.
163         
164         // Thursday 14th June, 2018
165         worldCupGameID["RU-SA"] = 1;   // Russia       vs Saudi Arabia
166         gameLocked[1]           = 1528988400;
167         
168         // Friday 15th June, 2018
169         worldCupGameID["EG-UY"] = 2;   // Egypt        vs Uruguay
170         worldCupGameID["MA-IR"] = 3;   // Morocco      vs Iran
171         worldCupGameID["PT-ES"] = 4;   // Portugal     vs Spain
172         gameLocked[2]           = 1529064000;
173         gameLocked[3]           = 1529074800;
174         gameLocked[4]           = 1529085600;
175         
176         // Saturday 16th June, 2018
177         worldCupGameID["FR-AU"] = 5;   // France       vs Australia
178         worldCupGameID["AR-IS"] = 6;   // Argentina    vs Iceland
179         worldCupGameID["PE-DK"] = 7;   // Peru         vs Denmark
180         worldCupGameID["HR-NG"] = 8;   // Croatia      vs Nigeria
181         gameLocked[5]           = 1529143200;
182         gameLocked[6]           = 1529154000;
183         gameLocked[7]           = 1529164800;
184         gameLocked[8]           = 1529175600;
185         
186         // Sunday 17th June, 2018
187         worldCupGameID["CR-CS"] = 9;   // Costa Rica   vs Serbia
188         worldCupGameID["DE-MX"] = 10;  // Germany      vs Mexico
189         worldCupGameID["BR-CH"] = 11;  // Brazil       vs Switzerland
190         gameLocked[9]           = 1529236800;
191         gameLocked[10]          = 1529247600;
192         gameLocked[11]          = 1529258400;
193         
194         // Monday 18th June, 2018
195         worldCupGameID["SE-KR"] = 12;  // Sweden       vs Korea
196         worldCupGameID["BE-PA"] = 13;  // Belgium      vs Panama
197         worldCupGameID["TN-EN"] = 14;  // Tunisia      vs England
198         gameLocked[12]          = 1529323200;
199         gameLocked[13]          = 1529334000;
200         gameLocked[14]          = 1529344800;
201         
202         // Tuesday 19th June, 2018
203         worldCupGameID["CO-JP"] = 15;  // Colombia     vs Japan
204         worldCupGameID["PL-SN"] = 16;  // Poland       vs Senegal
205         worldCupGameID["RU-EG"] = 17;  // Russia       vs Egypt
206         gameLocked[15]          = 1529409600;
207         gameLocked[16]          = 1529420400;
208         gameLocked[17]          = 1529431200;
209         
210         // Wednesday 20th June, 2018
211         worldCupGameID["PT-MA"] = 18;  // Portugal     vs Morocco
212         worldCupGameID["UR-SA"] = 19;  // Uruguay      vs Saudi Arabia
213         worldCupGameID["IR-ES"] = 20;  // Iran         vs Spain
214         gameLocked[18]          = 1529496000;
215         gameLocked[19]          = 1529506800;
216         gameLocked[20]          = 1529517600;
217         
218         // Thursday 21st June, 2018
219         worldCupGameID["DK-AU"] = 21;  // Denmark      vs Australia
220         worldCupGameID["FR-PE"] = 22;  // France       vs Peru
221         worldCupGameID["AR-HR"] = 23;  // Argentina    vs Croatia
222         gameLocked[21]          = 1529582400;
223         gameLocked[22]          = 1529593200;
224         gameLocked[23]          = 1529604000;
225         
226         // Friday 22nd June, 2018
227         worldCupGameID["BR-CR"] = 24;  // Brazil       vs Costa Rica
228         worldCupGameID["NG-IS"] = 25;  // Nigeria      vs Iceland
229         worldCupGameID["CS-CH"] = 26;  // Serbia       vs Switzerland
230         gameLocked[24]          = 1529668800;
231         gameLocked[25]          = 1529679600;
232         gameLocked[26]          = 1529690400;
233         
234         // Saturday 23rd June, 2018
235         worldCupGameID["BE-TN"] = 27;  // Belgium      vs Tunisia
236         worldCupGameID["KR-MX"] = 28;  // Korea        vs Mexico
237         worldCupGameID["DE-SE"] = 29;  // Germany      vs Sweden
238         gameLocked[27]          = 1529755200;
239         gameLocked[28]          = 1529766000;
240         gameLocked[29]          = 1529776800;
241         
242         // Sunday 24th June, 2018
243         worldCupGameID["EN-PA"] = 30;  // England      vs Panama
244         worldCupGameID["JP-SN"] = 31;  // Japan        vs Senegal
245         worldCupGameID["PL-CO"] = 32;  // Poland       vs Colombia
246         gameLocked[30]          = 1529841600;
247         gameLocked[31]          = 1529852400;
248         gameLocked[32]          = 1529863200;
249         
250         // Monday 25th June, 2018
251         worldCupGameID["UR-RU"] = 33;  // Uruguay      vs Russia
252         worldCupGameID["SA-EG"] = 34;  // Saudi Arabia vs Egypt
253         worldCupGameID["ES-MA"] = 35;  // Spain        vs Morocco
254         worldCupGameID["IR-PT"] = 36;  // Iran         vs Portugal
255         gameLocked[33]          = 1529935200;
256         gameLocked[34]          = 1529935200;
257         gameLocked[35]          = 1529949600;
258         gameLocked[36]          = 1529949600;
259         
260         // Tuesday 26th June, 2018
261         worldCupGameID["AU-PE"] = 37;  // Australia    vs Peru
262         worldCupGameID["DK-FR"] = 38;  // Denmark      vs France
263         worldCupGameID["NG-AR"] = 39;  // Nigeria      vs Argentina
264         worldCupGameID["IS-HR"] = 40;  // Iceland      vs Croatia
265         gameLocked[37]          = 1530021600;
266         gameLocked[38]          = 1530021600;
267         gameLocked[39]          = 1530036000;
268         gameLocked[40]          = 1530036000;
269         
270         // Wednesday 27th June, 2018
271         worldCupGameID["KR-DE"] = 41;  // Korea        vs Germany
272         worldCupGameID["MX-SE"] = 42;  // Mexico       vs Sweden
273         worldCupGameID["CS-BR"] = 43;  // Serbia       vs Brazil
274         worldCupGameID["CH-CR"] = 44;  // Switzerland  vs Costa Rica
275         gameLocked[41]          = 1530108000;
276         gameLocked[42]          = 1530108000;
277         gameLocked[43]          = 1530122400;
278         gameLocked[44]          = 1530122400;
279         
280         // Thursday 28th June, 2018
281         worldCupGameID["JP-PL"] = 45;  // Japan        vs Poland
282         worldCupGameID["SN-CO"] = 46;  // Senegal      vs Colombia
283         worldCupGameID["PA-TN"] = 47;  // Panama       vs Tunisia
284         worldCupGameID["EN-BE"] = 48;  // England      vs Belgium
285         gameLocked[45]          = 1530194400;
286         gameLocked[46]          = 1530194400;
287         gameLocked[47]          = 1530208800;
288         gameLocked[48]          = 1530208800;
289         
290         // Second stage games and onwards. The string values for these will be overwritten
291         //   as the tournament progresses. This is the order that will be followed for the
292         //   purposes of calculating winning streaks, as per the World Cup website.
293         
294         // Round of 16
295         // Saturday 30th June, 2018
296         worldCupGameID["1C-2D"]   = 49;  // 1C         vs 2D
297         worldCupGameID["1A-2B"]   = 50;  // 1A         vs 2B
298         gameLocked[49]            = 1530367200;
299         gameLocked[50]            = 1530381600;
300         
301         // Sunday 1st July, 2018
302         worldCupGameID["1B-2A"]   = 51;  // 1B         vs 2A
303         worldCupGameID["1D-2C"]   = 52;  // 1D         vs 2C
304         gameLocked[51]            = 1530453600;
305         gameLocked[52]            = 1530468000;
306         
307         // Monday 2nd July, 2018
308         worldCupGameID["1E-2F"]   = 53;  // 1E         vs 2F
309         worldCupGameID["1G-2H"]   = 54;  // 1G         vs 2H
310         gameLocked[53]            = 1530540000;
311         gameLocked[54]            = 1530554400;
312         
313         // Tuesday 3rd July, 2018
314         worldCupGameID["1F-2E"]   = 55;  // 1F         vs 2E
315         worldCupGameID["1H-2G"]   = 56;  // 1H         vs 2G
316         gameLocked[55]            = 1530626400;
317         gameLocked[56]            = 1530640800;
318         
319         // Quarter Finals
320         // Friday 6th July, 2018
321         worldCupGameID["W49-W50"] = 57; // W49         vs W50
322         worldCupGameID["W53-W54"] = 58; // W53         vs W54
323         gameLocked[57]            = 1530885600;
324         gameLocked[58]            = 1530900000;
325         
326         // Saturday 7th July, 2018
327         worldCupGameID["W55-W56"] = 59; // W55         vs W56
328         worldCupGameID["W51-W52"] = 60; // W51         vs W52
329         gameLocked[59]            = 1530972000;
330         gameLocked[60]            = 1530986400;
331         
332         // Semi Finals
333         // Tuesday 10th July, 2018
334         worldCupGameID["W57-W58"] = 61; // W57         vs W58
335         gameLocked[61]            = 1531245600;
336         
337         // Wednesday 11th July, 2018
338         worldCupGameID["W59-W60"] = 62; // W59         vs W60
339         gameLocked[62]            = 1531332000;
340         
341         // Third Place Playoff
342         // Saturday 14th July, 2018
343         worldCupGameID["L61-L62"] = 63; // L61         vs L62
344         gameLocked[63]            = 1531576800;
345         
346         // Grand Final
347         // Sunday 15th July, 2018
348         worldCupGameID["W61-W62"] = 64; // W61         vs W62
349         gameLocked[64]            = 1531666800;
350         
351         // Set initial variables.
352         latestGameFinished = 0;
353         
354     }
355     
356     /* PUBLIC-FACING COMPETITION INTERACTIONS */
357 
358     // Register to participate in the competition. Apart from gas costs from
359     //   making predictions and updating your score if necessary, this is the
360     //   only Ether you will need to spend throughout the tournament.
361     function register()
362         public
363         payable
364     {
365         address _customerAddress = msg.sender;
366         require(   tx.origin == _customerAddress
367                 && !playerRegistered[_customerAddress]
368                 && _isCorrectBuyin (msg.value));
369         registeredPlayers = SafeMath.addint256(registeredPlayers, 1);
370         playerRegistered[_customerAddress] = true;
371         playerGamesScored[_customerAddress] = 0;
372         playerList.push(_customerAddress);
373         uint fivePercent = 0.01009 ether;
374         uint tenPercent  = 0.02018 ether;
375         uint prizeEth    = (msg.value).sub(tenPercent);
376         require(playerRegistered[_customerAddress]);
377         prizePool  = prizePool.add(prizeEth);
378         givethPool = givethPool.add(fivePercent);
379         administrator.send(fivePercent);
380         emit Registration(_customerAddress);
381     }
382     
383     // Make a prediction for a game. An example would be makePrediction(1, "DRAW")
384     //   if you anticipate a draw in the game between Russia and Saudi Arabia, 
385     //   or makePrediction(2, "UY") if you expect Uruguay to beat Egypt.
386     // The "DRAW" option becomes invalid after the group stage games have been played.
387     function makePrediction(int8 _gameID, string _prediction) 
388         public {
389         address _customerAddress             = msg.sender;
390         uint    predictionTime               = now;
391         require(playerRegistered[_customerAddress]
392                 && !gameFinished[_gameID]
393                 && predictionTime < gameLocked[_gameID]);
394         // No draws allowed after the qualification stage.
395         if (_gameID > 48 && equalStrings(_prediction, "DRAW")) {
396             revert();
397         } else {
398             playerPredictions[_customerAddress][_gameID]    = _prediction;
399             playerMadePrediction[_customerAddress][_gameID] = true;
400             emit PlayerLoggedPrediction(_customerAddress, _gameID, _prediction);
401         }
402     }
403     
404     // What is the current score of a given tournament participant?
405     function showPlayerScores(address _participant)
406         view
407         public
408         returns (int8[64])
409     {
410         return playerPointArray[_participant];
411     }
412     
413     // What was the last game ID that has had an official score registered for it?
414     function gameResultsLogged()
415         view
416         public
417         returns (int)
418     {
419         return latestGameFinished;
420     }
421     
422     // Sum up the individual scores throughout the tournament and produce a final result.
423     function calculateScore(address _participant)
424         view
425         public
426         returns (int16)
427     {
428         int16 finalScore = 0;
429         for (int8 i = 0; i < latestGameFinished; i++) {
430             uint j = uint(i);
431             int16 gameScore = playerPointArray[_participant][j];
432             finalScore = SafeMath.addint16(finalScore, gameScore);
433         }
434         return finalScore;
435     }
436     
437     // How many people are taking part in the tournament?
438     function countParticipants()
439         public
440         view
441         returns (int) 
442     {
443         return registeredPlayers;
444     }
445     
446     // Keeping this open for anyone to update anyone else so that at the end of
447     // the tournament we can force a score update for everyone using a script.
448     function updateScore(address _participant) 
449         public 
450     {
451         int8                     lastPlayed     = latestGameFinished;
452         require(lastPlayed > 0);
453         // Most recent game scored for this participant.
454         int8                     lastScored     = playerGamesScored[_participant];
455         // Most recent game played in the tournament (sets bounds for scoring iteration).
456         mapping (int8 => bool)   madePrediction = playerMadePrediction[_participant];
457         mapping (int8 => string) playerGuesses  = playerPredictions[_participant];
458         for (int8 i = lastScored; i < lastPlayed; i++) {
459             uint j = uint(i);
460             uint k = j.add(1);
461             uint streak = playerStreak[_participant];
462             emit StartScoring(_participant, k);
463             if (!madePrediction[int8(k)]) {
464                 playerPointArray[_participant][j] = 0;
465                 playerStreak[_participant]        = 0;
466                 emit DidNotPredict(_participant, k);
467                 emit PlayerPointGain(_participant, k, 0, 0);
468             } else {
469                 string storage playerResult = playerGuesses[int8(k)];
470                 string storage actualResult = gameResult[int8(k)];
471                 bool correctGuess = equalStrings(playerResult, actualResult);
472                 emit Comparison(_participant, k, playerResult, actualResult, correctGuess);
473                  if (!correctGuess) {
474                      // The guess was wrong.
475                      playerPointArray[_participant][j] = 0;
476                      playerStreak[_participant]        = 0;
477                      emit PlayerPointGain(_participant, k, 0, 0);
478                  } else {
479                      // The guess was right.
480                      streak = streak.add(1);
481                      playerStreak[_participant] = streak;
482                      if (streak >= 5) {
483                          // On a long streak - four points.
484                         playerPointArray[_participant][j] = 4;
485                         emit PlayerPointGain(_participant, k, streak, 4);
486                      } else {
487                          if (streak >= 3) {
488                             // On a short streak - two points.
489                             playerPointArray[_participant][j] = 2;
490                             emit PlayerPointGain(_participant, k, streak, 2);
491               }
492                          // Not yet at a streak - standard one point.
493                          else { playerPointArray[_participant][j] = 1;
494                                 emit PlayerPointGain(_participant, k, streak, 1);
495                               }
496                      }
497                  }
498             }
499         }
500         playerGamesScored[_participant] = lastPlayed;
501     }
502     
503     // Invoke this function to get *everyone* up to date score-wise.
504     // This is probably best used at the end of the tournament, to ensure
505     // that prizes are awarded to the correct addresses.
506     // Note: this is going to be VERY gas-intensive. Use it if you're desperate
507     //         to see how you square up against everyone else if they're slow to
508     //         update their own scores. Alternatively, if there's just one or two
509     //         stragglers, you can just call updateScore for them alone.
510     function updateAllScores()
511         public
512     {
513         uint allPlayers = playerList.length;
514         for (uint i = 0; i < allPlayers; i++) {
515             address _toScore = playerList[i];
516             emit StartAutoScoring(_toScore);
517             updateScore(_toScore);
518         }
519     }
520     
521     // Which game ID has a player last computed their score up to
522     //   using the updateScore function?
523     function playerLastScoredGame(address _player)
524         public
525         view
526         returns (int8)
527     {
528         return playerGamesScored[_player];
529     }
530     
531     // Is a player registered?
532     function playerIsRegistered(address _player)
533         public
534         view
535         returns (bool)
536     {
537         return playerRegistered[_player];
538     }
539 
540     // What was the official result of a game?
541     function correctResult(int8 _gameID)
542         public
543         view
544         returns (string)
545     {
546         return gameResult[_gameID];
547     }
548     
549     // What was the caller's prediction for a given game?
550     function playerGuess(int8 _gameID)
551         public
552         view
553         returns (string)
554     {
555         return playerPredictions[msg.sender][_gameID];
556     }
557 
558     /* ADMINISTRATOR FUNCTIONS FOR COMPETITION MAINTENANCE */
559     
560     modifier isAdministrator() {
561         address _sender = msg.sender;
562         if (_sender == administrator) {
563             _;
564         } else {
565             revert();
566         }
567     }
568 
569     // As new fixtures become known through progression or elimination, they're added here.
570     function addNewGame(string _opponents, int8 _gameID)
571         isAdministrator
572         public {
573             worldCupGameID[_opponents] = _gameID;
574     }
575 
576     // When the result of a game is known, enter the result.
577     function logResult(int8 _gameID, string _winner) 
578         isAdministrator
579         public {
580         require((int8(0) < _gameID) && (_gameID <= 64)
581              && _gameID == latestGameFinished + 1);
582         // No draws allowed after the qualification stage.
583         if (_gameID > 48 && equalStrings(_winner, "DRAW")) {
584             revert();
585         } else {
586             require(!gameFinished[_gameID]);
587             gameFinished [_gameID] = true;
588             gameResult   [_gameID] = _winner;
589             latestGameFinished     = _gameID;
590             assert(gameFinished[_gameID]);
591         }
592     }
593     
594     // Concludes the tournament and issues the prizes, then self-destructs.
595     function concludeTournament(address _first   // 40% Ether.
596                               , address _second  // 30% Ether.
597                               , address _third   // 20% Ether.
598                               , address _fourth) // 10% Ether.
599         isAdministrator
600         public 
601     {
602         // Don't hand out prizes until the final's... actually been played.
603         require(gameFinished[64]
604              && playerIsRegistered(_first)
605              && playerIsRegistered(_second)
606              && playerIsRegistered(_third)
607              && playerIsRegistered(_fourth));
608         // Send the money raised for Giveth.
609         givethAddress.send(givethPool);
610         // Determine 10% of the prize pool to distribute to winners.
611         uint tenth    = prizePool.div(10);
612         _first.send (tenth.mul(4));
613         _second.send(tenth.mul(3));
614         _third.send (tenth.mul(2));
615         // Since there might be rounding errors, fourth place gets everything else.
616         _fourth.send(address(this).balance);
617         // Thanks for playing, everyone.
618         selfdestruct(administrator);
619     }
620     
621     // The emergency escape hatch in case something has gone wrong. Refunds 95% of purchase Ether 
622     //   to all registered addresses: the other 0.01009 has been sent directly to the developer who can
623     //   handle sending that back to everyone using a script.
624     // Let's hope this one doesn't have to get pulled, eh?
625     function pullRipCord()
626         isAdministrator
627         public
628     {
629         uint players = playerList.length;
630         for (uint i = 0; i < players; i++) {
631             address _toRefund = playerList[i];
632             _toRefund.send(0.19171 ether);
633             emit RipcordRefund(_toRefund);
634         }
635         selfdestruct(administrator);
636     }
637 
638    /* INTERNAL FUNCTIONS */
639    
640     // Gateway check - did you send exactly the right amount?
641     function _isCorrectBuyin(uint _buyin) 
642         private
643         pure
644         returns (bool) {
645         return _buyin == 0.2018 ether;
646     }
647     
648     // Internal comparison between strings, returning 0 if equal, 1 otherwise.
649     function compare(string _a, string _b)
650         private
651         pure
652         returns (int)
653     {
654         bytes memory a = bytes(_a);
655         bytes memory b = bytes(_b);
656         uint minLength = a.length;
657         if (b.length < minLength) minLength = b.length;
658         for (uint i = 0; i < minLength; i ++)
659             if (a[i] < b[i])
660                 return -1;
661             else if (a[i] > b[i])
662                 return 1;
663         if (a.length < b.length)
664             return -1;
665         else if (a.length > b.length)
666             return 1;
667         else
668             return 0;
669     }
670     
671     /// Compares two strings and returns true if and only if they are equal.
672     function equalStrings(string _a, string _b) pure private returns (bool) {
673         return compare(_a, _b) == 0;
674     }
675     
676 }
677 
678 library SafeMath {
679 
680     /**
681     * @dev Multiplies two numbers, throws on overflow.
682     */
683     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
684         if (a == 0) {
685             return 0;
686         }
687         uint256 c = a * b;
688         assert(c / a == b);
689         return c;
690     }
691 
692     /**
693     * @dev Integer division of two numbers, truncating the quotient.
694     */
695     function div(uint256 a, uint256 b) internal pure returns (uint256) {
696         // assert(b > 0); // Solidity automatically throws when dividing by 0
697         uint256 c = a / b;
698         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
699         return c;
700     }
701 
702     /**
703     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
704     */
705     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
706         assert(b <= a);
707         return a - b;
708     }
709 
710     /**
711     * @dev Adds two numbers, throws on overflow.
712     */
713     function add(uint256 a, uint256 b) internal pure returns (uint256) {
714         uint256 c = a + b;
715         assert(c >= a);
716         return c;
717     }
718     
719     function addint16(int16 a, int16 b) internal pure returns (int16) {
720         int16 c = a + b;
721         assert(c >= a);
722         return c;
723     }
724     
725     function addint256(int256 a, int256 b) internal pure returns (int256) {
726         int256 c = a + b;
727         assert(c >= a);
728         return c;
729     }
730 }