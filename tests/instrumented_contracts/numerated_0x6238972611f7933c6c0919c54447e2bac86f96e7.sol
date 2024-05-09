1 pragma solidity 0.4.24;
2 
3 contract CopaDelCrypto
4 {
5   address public owner;
6   constructor() public
7   {
8     owner = msg.sender;
9   }
10   modifier onlyOwner
11   {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   struct Forecast
17   {
18     bytes32 part1;
19     bytes32 part2;
20     bytes32 part3;
21     bytes12 part4;
22     bool hasPaidOrWon;
23   }
24 
25   uint256 public prizeValue;
26   uint256 public resultsPublishedTime;
27 
28   bytes32 public worldCupResultPart1;
29   bytes32 public worldCupResultPart2;
30   bytes32 public worldCupResultPart3;
31   bytes12 public worldCupResultPart4;
32 
33   bool public forecastingClosed;
34   bool public resultsPublished;
35 
36   uint32 public resultsValidationStep;
37   uint32 public verifiedWinnersCount;
38   uint32 public verifiedWinnersLastCount;
39 
40   uint16 public publishedWinningScoreThreshold;
41   uint16 public expectedWinnersCount;
42 
43   address[] public players;
44 
45   mapping(address => Forecast) public forecasts;
46 
47   function PlaceNewForecast(bytes32 f1, bytes32 f2, bytes32 f3, bytes12 f4)
48   public payable
49   {
50     require(!forecastingClosed && msg.value == 50000000000000000 && !forecasts[msg.sender].hasPaidOrWon);
51 
52     forecasts[msg.sender].part1 = f1;
53     forecasts[msg.sender].part2 = f2;
54     forecasts[msg.sender].part3 = f3;
55     forecasts[msg.sender].part4 = f4;
56     forecasts[msg.sender].hasPaidOrWon = true;
57 
58     players.push(msg.sender);
59   }
60 
61   function UpdateForecast(bytes32 f1, bytes32 f2, bytes32 f3, bytes12 f4)
62   public
63   {
64     require(!forecastingClosed && forecasts[msg.sender].hasPaidOrWon);
65 
66     forecasts[msg.sender].part1 = f1;
67     forecasts[msg.sender].part2 = f2;
68     forecasts[msg.sender].part3 = f3;
69     forecasts[msg.sender].part4 = f4;
70   }
71 
72   function CloseForecasting(uint16 exWinCount)
73   public onlyOwner
74   {
75     require(!forecastingClosed);
76     require((exWinCount == 0 && players.length > 10000)
77              || (exWinCount > 0 && (uint32(exWinCount) * uint32(exWinCount) >= players.length
78                  && uint32(exWinCount - 1) * uint32(exWinCount - 1) < players.length)));
79     expectedWinnersCount = (players.length) > 10000 ? uint16(players.length / 100) : exWinCount;
80 
81     forecastingClosed = true;
82   }
83 
84   function PublishWorldCupResults(bytes32 res1, bytes32 res2, bytes32 res3, bytes12 res4)
85   public onlyOwner
86   {
87     require(forecastingClosed && !resultsPublished);
88 
89     worldCupResultPart1 = res1;
90     worldCupResultPart2 = res2;
91     worldCupResultPart3 = res3;
92     worldCupResultPart4 = res4;
93 
94     resultsValidationStep = 0;
95     verifiedWinnersCount = 0;
96     verifiedWinnersLastCount = 0;
97     resultsPublishedTime = block.timestamp;
98   }
99 
100   function PublishWinnersScoreThres(uint16 scoreThres)
101   public onlyOwner
102   {
103     require(forecastingClosed && !resultsPublished);
104 
105     publishedWinningScoreThreshold = scoreThres;
106   }
107 
108   function VerifyPublishedResults(uint16 stepSize)
109   public onlyOwner
110   {
111     require(forecastingClosed && !resultsPublished);
112     require(stepSize > 0 && resultsValidationStep + stepSize <= players.length);
113 
114     uint32 wins;
115     uint32 lasts;
116 
117     for (uint32 i = resultsValidationStep; i < resultsValidationStep + stepSize; i++) {
118 
119       Forecast memory fc = forecasts[players[i]];
120 
121       uint16 score = scoreGroups(fc.part1, fc.part2, worldCupResultPart1, worldCupResultPart2)
122                      + scoreKnockouts(fc.part2, fc.part3, fc.part4);
123 
124       if (score >= publishedWinningScoreThreshold) {
125         wins++;
126         if (score == publishedWinningScoreThreshold) {
127           lasts++;
128         }
129         forecasts[players[i]].hasPaidOrWon = true;
130       } else {
131         forecasts[players[i]].hasPaidOrWon = false;
132       }
133     }
134 
135     resultsValidationStep += stepSize;
136     verifiedWinnersCount += wins;
137     verifiedWinnersLastCount += lasts;
138 
139     if (resultsValidationStep == players.length) {
140       verifiedWinnersCount = validateWinnersCount(verifiedWinnersCount, verifiedWinnersLastCount, expectedWinnersCount);
141       verifiedWinnersLastCount = 0;
142       expectedWinnersCount = 0;
143 
144       if (verifiedWinnersCount > 0) {
145         prizeValue = address(this).balance / verifiedWinnersCount;
146         resultsPublished = true;
147       }
148     }
149   }
150 
151   function WithdrawPrize()
152   public
153   returns(bool)
154   {
155     require(prizeValue > 0);
156 
157     if (forecasts[msg.sender].hasPaidOrWon) {
158       forecasts[msg.sender].hasPaidOrWon = false;
159       if (!msg.sender.send(prizeValue)) {
160         forecasts[msg.sender].hasPaidOrWon = true;
161         return false;
162       }
163       return true;
164     }
165     return false;
166   }
167 
168   function CancelGame()
169   public onlyOwner
170   {
171     forecastingClosed = true;
172     resultsPublished = true;
173     resultsPublishedTime = block.timestamp;
174     prizeValue = address(this).balance / players.length;
175   }
176 
177   function CancelGameAfterResultsPublished()
178   public onlyOwner
179   {
180     CancelGame();
181     for (uint32 i = 0; i < players.length; i++) {
182     	forecasts[players[i]].hasPaidOrWon = true;
183     }
184   }
185 
186   function WithdrawUnclaimed()
187   public onlyOwner
188   returns(bool)
189   {
190     require(resultsPublished && block.timestamp >= (resultsPublishedTime + 10 weeks));
191 
192     uint256 amount = address(this).balance;
193     if (amount > 0) {
194       if (!msg.sender.send(amount)) {
195         return false;
196       }
197     }
198     return true;
199   }
200 
201   function getForecastData(bytes32 pred2, bytes32 pred3, bytes12 pred4, uint8 index)
202   public pure
203   returns(uint8)
204   {
205     assert(index >= 32 && index < 108);
206     if (index < 64) {
207       return uint8(pred2[index - 32]);
208     } else if (index < 96) {
209       return uint8(pred3[index - 64]);
210     } else {
211       return uint8(pred4[index - 96]);
212     }
213   }
214 
215   function getResultData(uint8 index)
216   public view
217   returns(uint8)
218   {
219     assert(index >= 32 && index < 108);
220     if (index < 64) {
221       return uint8(worldCupResultPart2[index - 32]);
222     } else if (index < 96) {
223       return uint8(worldCupResultPart3[index - 64]);
224     } else {
225       return uint8(worldCupResultPart4[index - 96]);
226     }
227   }
228 
229   function computeGroupPhasePoints(uint8 pred, uint8 result)
230   public pure
231   returns(uint8)
232   {
233     uint8 gamePoint = 0;
234 
235     int8 predLeft = int8(pred % 16);
236     int8 predRight = int8(pred >> 4);
237     int8 resultLeft = int8(result % 16);
238     int8 resultRight = int8(result >> 4);
239 
240     int8 outcome = resultLeft - resultRight;
241     int8 predOutcome = predLeft - predRight;
242 
243     if ((outcome > 0 && predOutcome > 0)
244         || (outcome < 0 && predOutcome < 0)
245         || (outcome == 0 && predOutcome == 0)) {
246       gamePoint += 4;
247     }
248 
249     if (predLeft == resultLeft) {
250       gamePoint += 2;
251     }
252 
253     if (predRight == resultRight) {
254       gamePoint += 2;
255     }
256     return gamePoint;
257   }
258 
259   function computeKnockoutPoints(uint8 pred, uint8 result, uint8 shootPred, uint8 shootResult,
260                                  uint8 roundFactorLeft, uint8 roundFactorRight, bool isInverted)
261   public pure
262   returns (uint16)
263   {
264     uint16 gamePoint = 0;
265     int8 predLeft = int8(pred % 16);
266     int8 predRight = int8(pred >> 4);
267     int8 resultLeft = int8(result % 16);
268     int8 resultRight = int8(result >> 4);
269 
270     int8 predOutcome = predLeft - predRight;
271     int8 outcome = resultLeft - resultRight;
272 
273     if (predOutcome == 0) {
274        predOutcome = int8(shootPred % 16) - int8(shootPred >> 4);
275     }
276     if (outcome == 0) { 
277        outcome = int8(shootResult % 16) - int8(shootResult >> 4);
278     }
279 
280     if (isInverted) {
281       resultLeft = resultLeft + resultRight;
282       resultRight = resultLeft - resultRight;
283       resultLeft = resultLeft - resultRight;
284       outcome = -outcome;
285     }
286 
287     if ((outcome > 0 && predOutcome > 0) || (outcome < 0 && predOutcome < 0)) {
288       gamePoint += 4 * (roundFactorLeft + roundFactorRight);
289     }
290 
291     gamePoint += 4 * ((predLeft == resultLeft ? roundFactorLeft : 0)
292                       + (predRight == resultRight ? roundFactorRight: 0));
293 
294     return gamePoint;
295   }
296 
297   function scoreGroups(bytes32 pred1, bytes32 pred2, bytes32 res1, bytes32 res2)
298   public pure
299   returns(uint16)
300   {
301     uint16 points = 0;
302     for (uint8 f = 0; f < 48; f++) {
303       if (f < 32) {
304         points += computeGroupPhasePoints(uint8(pred1[f]), uint8(res1[f]));
305       } else {
306         points += computeGroupPhasePoints(uint8(pred2[f - 32]), uint8(res2[f - 32]));
307       }
308     }
309     return points;
310   }
311 
312   function scoreKnockouts(bytes32 pred2, bytes32 pred3, bytes12 pred4)
313   public view
314   returns(uint16)
315   {
316     uint8 f = 48;
317     uint16 points = 0;
318 
319     int8[15] memory twinShift = [int8(16), 16, 16, 16, -16, -16, -16, -16, 8, 8, -8, -8, 4, -4, 0];
320     uint8[15] memory roundFactor = [uint8(2), 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 8, 8, 16];
321 
322     for (uint8 i = 0; i < 15; i++) {
323 
324       bool teamLeftOK = getForecastData(pred2, pred3, pred4, f) == getResultData(f);
325       bool teamRightOK = getForecastData(pred2, pred3, pred4, f + 1) == getResultData(f + 1);
326 
327       if (teamLeftOK || teamRightOK) {
328         points += computeKnockoutPoints(getForecastData(pred2, pred3, pred4, f + 2), getResultData(f + 2),
329                                         getForecastData(pred2, pred3, pred4, f + 3), getResultData(f + 3),
330                                         teamLeftOK ? roundFactor[i] : 0, teamRightOK ? roundFactor[i] : 0,
331                                         false);
332         if (i < 8) {
333           points += (teamLeftOK ? 4 : 0) + (teamRightOK ? 4 : 0);
334         }
335       }
336 
337       bool isInverted = (i < 8) || i == 14;
338       teamLeftOK = getForecastData(pred2, pred3, pred4, f) ==
339                    (getResultData(uint8(int8(f + (isInverted ? 1 : 0)) + twinShift[i])));
340       teamRightOK = getForecastData(pred2, pred3, pred4, f + 1) ==
341                    (getResultData(uint8(int8(f + (isInverted ? 0 : 1)) + twinShift[i])));
342 
343       if (teamLeftOK || teamRightOK) {
344         points += computeKnockoutPoints(getForecastData(pred2, pred3, pred4, f + 2),
345                                         getResultData(uint8(int8(f + 2) + twinShift[i])),
346                                         getForecastData(pred2, pred3, pred4, f + 3),
347                                         getResultData(uint8(int8(f + 3) + twinShift[i])),
348                                         teamLeftOK ? roundFactor[i] : 0, teamRightOK ? roundFactor[i] : 0,
349                                         isInverted);
350         if (i < 8) {
351           points += (teamLeftOK ? 2 : 0) + (teamRightOK ? 2 : 0);
352         }
353       }
354       f = f + 4;
355     }
356     return points;
357   }
358 
359   function validateWinnersCount(uint32 winners, uint32 last, uint32 expected)
360   public pure
361   returns(uint32)
362   {
363     if (winners < expected) {
364       return 0;
365     } else if ((winners == expected && last >= 1)
366                 || (last > 1 && (winners - last) < expected)) {
367       return winners;
368     } else {
369       return 0;
370     }
371   }
372 }