1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
8 import {AppStorage, LibAppStorage} from "./LibAppStorage.sol";
9 
10 /**
11  * @title LibLockedUnderlying
12  * @author Brendan
13  * @notice Library to calculate the number of Underlying Tokens that would be locked if all of
14  * the Unripe Tokens are Chopped.
15  */
16 library LibLockedUnderlying {
17     using SafeMath for uint256;
18 
19     /**
20      * @notice Return the amount of Underlying Tokens that would be locked if all of the Unripe Tokens
21      * were chopped.
22      */
23     function getLockedUnderlying(
24         address unripeToken,
25         uint256 recapPercentPaid
26     ) external view returns (uint256 lockedUnderlying) {
27         AppStorage storage s = LibAppStorage.diamondStorage();
28         return
29             s
30                 .u[unripeToken]
31                 .balanceOfUnderlying
32                 .mul(getPercentLockedUnderlying(unripeToken, recapPercentPaid))
33                 .div(1e18);
34     }
35 
36     /**
37      * @notice Return the % of Underlying Tokens that would be locked if all of the Unripe Tokens
38      * were chopped.
39      * @param unripeToken The address of the Unripe Token
40      * @param recapPercentPaid The % of Sprouts that have been Rinsed or are Rinsable.
41      * Should have 6 decimal precision.
42      *
43      * @dev Solves the below equation for N_{⌈U/i⌉}:
44      * N_{t+1} = N_t - i * R * N_t / (U - i * t)
45      * where:
46      *  - N_t is the number of Underlying Tokens at step t
47      *  - U is the starting number of Unripe Tokens
48      *  - R is the % of Sprouts that are Rinsable or Rinsed
49      *  - i is the number of Unripe Beans that are chopped at each step. i ~= 46,659 is used as this is aboutr
50      *    the average Unripe Beans held per Farmer with a non-zero balance.
51      *
52      * The equation is solved by using a lookup table of N_{⌈U/i⌉} values for different values of
53      * U and R (The solution is independent of N) as solving iteratively is too computationally
54      * expensive and there is no more efficient way to solve the equation.
55      */
56     function getPercentLockedUnderlying(
57         address unripeToken,
58         uint256 recapPercentPaid
59     ) private view returns (uint256 percentLockedUnderlying) {
60         uint256 unripeSupply = IERC20(unripeToken).totalSupply();
61         if (unripeSupply < 1_000_000) return 0; // If < 1,000,000 Assume all supply is unlocked.
62         if (unripeSupply > 5_000_000) {
63             if (unripeSupply > 10_000_000) {
64                 if (recapPercentPaid > 0.1e6) {
65                     if (recapPercentPaid > 0.21e6) {
66                         if (recapPercentPaid > 0.38e6) {
67                             if (recapPercentPaid > 0.45e6) {
68                                 return 0.000106800755371506e18; // 90,000,000, 0.9
69                             } else {
70                                 return 0.019890729697455534e18; // 90,000,000, 0.45
71                             }
72                         } else if (recapPercentPaid > 0.29e6) {
73                             if (recapPercentPaid > 0.33e6) {
74                                 return 0.038002726385307994e18; // 90,000,000 0.38
75                             } else {
76                                 return 0.05969915165233464e18; // 90,000,000 0.33
77                             }
78                         } else if (recapPercentPaid > 0.25e6) {
79                             if (recapPercentPaid > 0.27e6) {
80                                 return 0.08520038853809475e18; // 90,000,000 0.29
81                             } else {
82                                 return 0.10160827712172482e18; // 90,000,000 0.27
83                             }
84                         } else {
85                             if (recapPercentPaid > 0.23e6) {
86                                 return 0.1210446758987509e18; // 90,000,000 0.25
87                             } else {
88                                 return 0.14404919400935834e18; // 90,000,000 0.23
89                             }
90                         }
91                     } else {
92                         if (recapPercentPaid > 0.17e6) {
93                             if (recapPercentPaid > 0.19e6) {
94                                 return 0.17125472579906187e18; // 90,000,000, 0.21
95                             } else {
96                                 return 0.2034031571094802e18; // 90,000,000, 0.19
97                             }
98                         } else if (recapPercentPaid > 0.14e6) {
99                             if (recapPercentPaid > 0.15e6) {
100                                 return 0.24136365460186238e18; // 90,000,000 0.17
101                             } else {
102                                 return 0.2861539540121635e18; // 90,000,000 0.15
103                             }
104                         } else if (recapPercentPaid > 0.12e6) {
105                             if (recapPercentPaid > 0.13e6) {
106                                 return 0.3114749615435798e18; // 90,000,000 0.14
107                             } else {
108                                 return 0.3389651289211062e18; // 90,000,000 0.13
109                             }
110                         } else {
111                             if (recapPercentPaid > 0.11e6) {
112                                 return 0.3688051484970447e18; // 90,000,000 0.12
113                             } else {
114                                 return 0.4011903974987394e18; // 90,000,000 0.11
115                             }
116                         }
117                     }
118                 } else {
119                     if (recapPercentPaid > 0.04e6) {
120                         if (recapPercentPaid > 0.08e6) {
121                             if (recapPercentPaid > 0.09e6) {
122                                 return 0.4363321054081788e18; // 90,000,000, 0.1
123                             } else {
124                                 return 0.4744586123058411e18; // 90,000,000, 0.09
125                             }
126                         } else if (recapPercentPaid > 0.06e6) {
127                             if (recapPercentPaid > 0.07e6) {
128                                 return 0.5158167251384363e18; // 90,000,000 0.08
129                             } else {
130                                 return 0.560673179393784e18; // 90,000,000 0.07
131                             }
132                         } else if (recapPercentPaid > 0.05e6) {
133                             if (recapPercentPaid > 0.055e6) {
134                                 return 0.6093162142284054e18; // 90,000,000 0.06
135                             } else {
136                                 return 0.6351540690346162e18; // 90,000,000 0.055
137                             }
138                         } else {
139                             if (recapPercentPaid > 0.045e6) {
140                                 return 0.6620572696973799e18; // 90,000,000 0.05
141                             } else {
142                                 return 0.6900686713435757e18; // 90,000,000 0.045
143                             }
144                         }
145                     } else {
146                         if (recapPercentPaid > 0.03e6) {
147                             if (recapPercentPaid > 0.035e6) {
148                                 return 0.7192328153846157e18; // 90,000,000, 0.04
149                             } else {
150                                 return 0.7495959945573412e18; // 90,000,000, 0.035
151                             }
152                         } else if (recapPercentPaid > 0.02e6) {
153                             if (recapPercentPaid > 0.025e6) {
154                                 return 0.7812063204281795e18; // 90,000,000 0.03
155                             } else {
156                                 return 0.8141137934523504e18; // 90,000,000 0.025
157                             }
158                         } else if (recapPercentPaid > 0.01e6) {
159                             if (recapPercentPaid > 0.015e6) {
160                                 return 0.8483703756831885e18; // 90,000,000 0.02
161                             } else {
162                                 return 0.8840300662301638e18; // 90,000,000 0.015
163                             }
164                         } else {
165                             if (recapPercentPaid > 0.005e6) {
166                                 return 0.921148979567821e18; // 90,000,000 0.01
167                             } else {
168                                 return 0.9597854268015467e18; // 90,000,000 0.005
169                             }
170                         }
171                     }
172                 }
173             } else {
174                 // > 5,000,000
175                 if (recapPercentPaid > 0.1e6) {
176                     if (recapPercentPaid > 0.21e6) {
177                         if (recapPercentPaid > 0.38e6) {
178                             if (recapPercentPaid > 0.45e6) {
179                                 return 0.000340444522821781e18; // 10,000,000, 0.9
180                             } else {
181                                 return 0.04023093970853808e18; // 10,000,000, 0.45
182                             }
183                         } else if (recapPercentPaid > 0.29e6) {
184                             if (recapPercentPaid > 0.33e6) {
185                                 return 0.06954881077191022e18; // 10,000,000 0.38
186                             } else {
187                                 return 0.10145116013499655e18; // 10,000,000 0.33
188                             }
189                         } else if (recapPercentPaid > 0.25e6) {
190                             if (recapPercentPaid > 0.27e6) {
191                                 return 0.13625887314323348e18; // 10,000,000 0.29
192                             } else {
193                                 return 0.15757224609763754e18; // 10,000,000 0.27
194                             }
195                         } else {
196                             if (recapPercentPaid > 0.23e6) {
197                                 return 0.18197183407669726e18; // 10,000,000 0.25
198                             } else {
199                                 return 0.20987581330872107e18; // 10,000,000 0.23
200                             }
201                         }
202                     } else {
203                         if (recapPercentPaid > 0.17e6) {
204                             if (recapPercentPaid > 0.19e6) {
205                                 return 0.24175584233885106e18; // 10,000,000, 0.21
206                             } else {
207                                 return 0.27814356260741413e18; // 10,000,000, 0.19
208                             }
209                         } else if (recapPercentPaid > 0.14e6) {
210                             if (recapPercentPaid > 0.15e6) {
211                                 return 0.3196378540296301e18; // 10,000,000 0.17
212                             } else {
213                                 return 0.36691292973511136e18; // 10,000,000 0.15
214                             }
215                         } else if (recapPercentPaid > 0.1e6) {
216                             if (recapPercentPaid > 0.13e6) {
217                                 return 0.3929517529835418e18; // 10,000,000 0.14
218                             } else {
219                                 return 0.4207273631610372e18; // 10,000,000 0.13
220                             }
221                         } else {
222                             if (recapPercentPaid > 0.11e6) {
223                                 return 0.450349413795883e18; // 10,000,000 0.12
224                             } else {
225                                 return 0.4819341506654745e18; // 10,000,000 0.11
226                             }
227                         }
228                     }
229                 } else {
230                     if (recapPercentPaid > 0.04e6) {
231                         if (recapPercentPaid > 0.08e6) {
232                             if (recapPercentPaid > 0.09e6) {
233                                 return 0.5156047910307769e18; // 10,000,000, 0.1
234                             } else {
235                                 return 0.551491923831086e18; // 10,000,000, 0.09
236                             }
237                         } else if (recapPercentPaid > 0.06e6) {
238                             if (recapPercentPaid > 0.07e6) {
239                                 return 0.5897339319558434e18; // 10,000,000 0.08
240                             } else {
241                                 return 0.6304774377677631e18; // 10,000,000 0.07
242                             }
243                         } else if (recapPercentPaid > 0.05e6) {
244                             if (recapPercentPaid > 0.055e6) {
245                                 return 0.6738777731119263e18; // 10,000,000 0.06
246                             } else {
247                                 return 0.6966252960203008e18; // 10,000,000 0.055
248                             }
249                         } else {
250                             if (recapPercentPaid > 0.045e6) {
251                                 return 0.7200994751088836e18; // 10,000,000 0.05
252                             } else {
253                                 return 0.7443224016328813e18; // 10,000,000 0.045
254                             }
255                         }
256                     } else {
257                         if (recapPercentPaid > 0.03e6) {
258                             if (recapPercentPaid > 0.035e6) {
259                                 return 0.7693168090963867e18; // 10,000,000, 0.04
260                             } else {
261                                 return 0.7951060911805916e18; // 10,000,000, 0.035
262                             }
263                         } else if (recapPercentPaid > 0.02e6) {
264                             if (recapPercentPaid > 0.025e6) {
265                                 return 0.8217143201541763e18; // 10,000,000 0.03
266                             } else {
267                                 return 0.8491662657783823e18; // 10,000,000 0.025
268                             }
269                         } else if (recapPercentPaid > 0.01e6) {
270                             if (recapPercentPaid > 0.015e6) {
271                                 return 0.8774874147196358e18; // 10,000,000 0.02
272                             } else {
273                                 return 0.9067039904828691e18; // 10,000,000 0.015
274                             }
275                         } else {
276                             if (recapPercentPaid > 0.005e6) {
277                                 return 0.9368429738790524e18; // 10,000,000 0.01
278                             } else {
279                                 return 0.9679321240407666e18; // 10,000,000 0.005
280                             }
281                         }
282                     }
283                 }
284             }
285         } else {
286             if (unripeSupply > 1_000_000) {
287                 if (recapPercentPaid > 0.1e6) {
288                     if (recapPercentPaid > 0.21e6) {
289                         if (recapPercentPaid > 0.38e6) {
290                             if (recapPercentPaid > 0.45e6) {
291                                 return 0.000946395082480844e18; // 3,000,000, 0.9
292                             } else {
293                                 return 0.06786242725985348e18; // 3,000,000, 0.45
294                             }
295                         } else if (recapPercentPaid > 0.29e6) {
296                             if (recapPercentPaid > 0.33e6) {
297                                 return 0.10822315472628707e18; // 3,000,000 0.38
298                             } else {
299                                 return 0.14899524306327216e18; // 3,000,000 0.33
300                             }
301                         } else if (recapPercentPaid > 0.25e6) {
302                             if (recapPercentPaid > 0.27e6) {
303                                 return 0.1910488239684135e18; // 3,000,000 0.29
304                             } else {
305                                 return 0.215863137234529e18; // 3,000,000 0.27
306                             }
307                         } else {
308                             if (recapPercentPaid > 0.23e6) {
309                                 return 0.243564628757033e18; // 3,000,000 0.25
310                             } else {
311                                 return 0.2744582675491247e18; // 3,000,000 0.23
312                             }
313                         }
314                     } else {
315                         if (recapPercentPaid > 0.17e6) {
316                             if (recapPercentPaid > 0.19e6) {
317                                 return 0.3088786047254358e18; // 3,000,000, 0.21
318                             } else {
319                                 return 0.3471924328319608e18; // 3,000,000, 0.19
320                             }
321                         } else if (recapPercentPaid > 0.14e6) {
322                             if (recapPercentPaid > 0.15e6) {
323                                 return 0.38980166833777796e18; // 3,000,000 0.17
324                             } else {
325                                 return 0.4371464748698771e18; // 3,000,000 0.15
326                             }
327                         } else if (recapPercentPaid > 0.12e6) {
328                             if (recapPercentPaid > 0.13e6) {
329                                 return 0.46274355346663876e18; // 3,000,000 0.14
330                             } else {
331                                 return 0.4897086460787351e18; // 3,000,000 0.13
332                             }
333                         } else {
334                             if (recapPercentPaid > 0.11e6) {
335                                 return 0.518109082463349e18; // 3,000,000 0.12
336                             } else {
337                                 return 0.5480152684204499e18; // 3,000,000 0.11
338                             }
339                         }
340                     }
341                 } else {
342                     if (recapPercentPaid > 0.04e6) {
343                         if (recapPercentPaid > 0.08e6) {
344                             if (recapPercentPaid > 0.09e6) {
345                                 return 0.5795008171102514e18; // 3,000,000, 0.1
346                             } else {
347                                 return 0.6126426856374751e18; // 3,000,000, 0.09
348                             }
349                         } else if (recapPercentPaid > 0.06e6) {
350                             if (recapPercentPaid > 0.07e6) {
351                                 return 0.6475213171017626e18; // 3,000,000 0.08
352                             } else {
353                                 return 0.6842207883207123e18; // 3,000,000 0.07
354                             }
355                         } else if (recapPercentPaid > 0.05e6) {
356                             if (recapPercentPaid > 0.055e6) {
357                                 return 0.7228289634394097e18; // 3,000,000 0.06
358                             } else {
359                                 return 0.742877347280416e18; // 3,000,000 0.055
360                             }
361                         } else {
362                             if (recapPercentPaid > 0.045e6) {
363                                 return 0.7634376536479606e18; // 3,000,000 0.05
364                             } else {
365                                 return 0.784522002909275e18; // 3,000,000 0.045
366                             }
367                         }
368                     } else {
369                         if (recapPercentPaid > 0.03e6) {
370                             if (recapPercentPaid > 0.035e6) {
371                                 return 0.8061427832364296e18; // 3,000,000, 0.04
372                             } else {
373                                 return 0.8283126561589187e18; // 3,000,000, 0.035
374                             }
375                         } else if (recapPercentPaid > 0.02e6) {
376                             if (recapPercentPaid > 0.025e6) {
377                                 return 0.8510445622247672e18; // 3,000,000 0.03
378                             } else {
379                                 return 0.8743517267721741e18; // 3,000,000 0.025
380                             }
381                         } else if (recapPercentPaid > 0.01e6) {
382                             if (recapPercentPaid > 0.015e6) {
383                                 return 0.8982476658137254e18; // 3,000,000 0.02
384                             } else {
385                                 return 0.9227461920352636e18; // 3,000,000 0.015
386                             }
387                         } else {
388                             if (recapPercentPaid > 0.005e6) {
389                                 return 0.9478614209115208e18; // 3,000,000 0.01
390                             } else {
391                                 return 0.9736077769406731e18; // 3,000,000 0.005
392                             }
393                         }
394                     }
395                 }
396             } else {
397                 if (recapPercentPaid > 0.1e6) {
398                     if (recapPercentPaid > 0.21e6) {
399                         if (recapPercentPaid > 0.38e6) {
400                             if (recapPercentPaid > 0.45e6) {
401                                 return 0.003360632002379016e18; // 1,000,000, 0.9
402                             } else {
403                                 return 0.12071031956650236e18; // 1,000,000, 0.45
404                             }
405                         } else if (recapPercentPaid > 0.29e6) {
406                             if (recapPercentPaid > 0.33e6) {
407                                 return 0.1752990554517151e18; // 1,000,000 0.38
408                             } else {
409                                 return 0.22598948369141458e18; // 1,000,000 0.33
410                             }
411                         } else if (recapPercentPaid > 0.25e6) {
412                             if (recapPercentPaid > 0.27e6) {
413                                 return 0.27509697387157794e18; // 1,000,000 0.29
414                             } else {
415                                 return 0.3029091410266461e18; // 1,000,000 0.27
416                             }
417                         } else {
418                             if (recapPercentPaid > 0.23e6) {
419                                 return 0.33311222196618273e18; // 1,000,000 0.25
420                             } else {
421                                 return 0.36588364748950297e18; // 1,000,000 0.23
422                             }
423                         }
424                     } else {
425                         if (recapPercentPaid > 0.17e6) {
426                             if (recapPercentPaid > 0.19e6) {
427                                 return 0.40141235983370593e18; // 1,000,000, 0.21
428                             } else {
429                                 return 0.43989947169522015e18; // 1,000,000, 0.19
430                             }
431                         } else if (recapPercentPaid > 0.14e6) {
432                             if (recapPercentPaid > 0.15e6) {
433                                 return 0.4815589587559236e18; // 1,000,000 0.17
434                             } else {
435                                 return 0.5266183872325827e18; // 1,000,000 0.15
436                             }
437                         } else if (recapPercentPaid > 0.12e6) {
438                             if (recapPercentPaid > 0.13e6) {
439                                 return 0.5504980973828455e18; // 1,000,000 0.14
440                             } else {
441                                 return 0.5753196780298556e18; // 1,000,000 0.13
442                             }
443                         } else {
444                             if (recapPercentPaid > 0.11e6) {
445                                 return 0.6011157438454372e18; // 1,000,000 0.12
446                             } else {
447                                 return 0.6279199091408495e18; // 1,000,000 0.11
448                             }
449                         }
450                     }
451                 } else {
452                     if (recapPercentPaid > 0.04e6) {
453                         if (recapPercentPaid > 0.08e6) {
454                             if (recapPercentPaid > 0.09e6) {
455                                 return 0.6557668151543954e18; // 1,000,000, 0.1
456                             } else {
457                                 return 0.6846921580052533e18; // 1,000,000, 0.09
458                             }
459                         } else if (recapPercentPaid > 0.06e6) {
460                             if (recapPercentPaid > 0.07e6) {
461                                 return 0.7147327173281093e18; // 1,000,000 0.08
462                             } else {
463                                 return 0.745926385603471e18; // 1,000,000 0.07
464                             }
465                         } else if (recapPercentPaid > 0.05e6) {
466                             if (recapPercentPaid > 0.055e6) {
467                                 return 0.7783121981988174e18; // 1,000,000 0.06
468                             } else {
469                                 return 0.7949646772335068e18; // 1,000,000 0.055
470                             }
471                         } else {
472                             if (recapPercentPaid > 0.045e6) {
473                                 return 0.8119303641360465e18; // 1,000,000 0.05
474                             } else {
475                                 return 0.8292144735871585e18; // 1,000,000 0.045
476                             }
477                         }
478                     } else {
479                         if (recapPercentPaid > 0.03e6) {
480                             if (recapPercentPaid > 0.035e6) {
481                                 return 0.8468222976009872e18; // 1,000,000, 0.04
482                             } else {
483                                 return 0.8647592065514869e18; // 1,000,000, 0.035
484                             }
485                         } else if (recapPercentPaid > 0.02e6) {
486                             if (recapPercentPaid > 0.025e6) {
487                                 return 0.8830306502110374e18; // 1,000,000 0.03
488                             } else {
489                                 return 0.9016421588014247e18; // 1,000,000 0.025
490                             }
491                         } else if (recapPercentPaid > 0.01e6) {
492                             if (recapPercentPaid > 0.015e6) {
493                                 return 0.9205993440573136e18; // 1,000,000 0.02
494                             } else {
495                                 return 0.9399079003023474e18; // 1,000,000 0.015
496                             }
497                         } else {
498                             if (recapPercentPaid > 0.005e6) {
499                                 return 0.959573605538012e18; // 1,000,000 0.01
500                             } else {
501                                 return 0.9796023225453983e18; // 1,000,000 0.005
502                             }
503                         }
504                     }
505                 }
506             }
507         }
508     }
509 }
