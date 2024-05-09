1 pragma solidity ^0.4.6;
2 
3 contract WinMatrix
4 {
5    
6    address developer; 
7 
8    enum BetTypes{number0, number1,number2,number3,number4,number5,number6,number7,number8,number9,
9    number10,number11,number12,number13,number14,number15,number16,number17,number18,number19,number20,number21,
10    number22,number23,number24,number25,number26,number27,number28,number29,number30,number31,number32,number33,
11    number34,number35,number36, red, black, odd, even, dozen1,dozen2,dozen3, column1,column2,column3, low,high,
12    pair_01, pair_02, pair_03, pair_12, pair_23, pair_36, pair_25, pair_14, pair_45, pair_56, pair_69, pair_58, pair_47,
13    pair_78, pair_89, pair_912, pair_811, pair_710, pair_1011, pair_1112, pair_1215, pair_1518, pair_1617, pair_1718, pair_1720,
14    pair_1619, pair_1922, pair_2023, pair_2124, pair_2223, pair_2324, pair_2528, pair_2629, pair_2730, pair_2829, pair_2930, pair_1114,
15    pair_1013, pair_1314, pair_1415, pair_1316, pair_1417, pair_1821, pair_1920, pair_2021, pair_2225, pair_2326, pair_2427, pair_2526,
16    pair_2627, pair_2831, pair_2932, pair_3033, pair_3132, pair_3233, pair_3134, pair_3235, pair_3336, pair_3435, pair_3536, corner_0_1_2_3,
17    corner_1_2_5_4, corner_2_3_6_5, corner_4_5_8_7, corner_5_6_9_8, corner_7_8_11_10, corner_8_9_12_11, corner_10_11_14_13, corner_11_12_15_14,
18    corner_13_14_17_16, corner_14_15_18_17, corner_16_17_20_19, corner_17_18_21_20, corner_19_20_23_22, corner_20_21_24_23, corner_22_23_26_25,
19    corner_23_24_27_26, corner_25_26_29_28, corner_26_27_30_29, corner_28_29_32_31, corner_29_30_33_32, corner_31_32_35_34, corner_32_33_36_35,
20    three_0_2_3, three_0_1_2, three_1_2_3, three_4_5_6, three_7_8_9, three_10_11_12, three_13_14_15, three_16_17_18, three_19_20_21, three_22_23_24,
21    three_25_26_27, three_28_29_30, three_31_32_33, three_34_35_36, six_1_2_3_4_5_6, six_4_5_6_7_8_9, six_7_8_9_10_11_12, six_10_11_12_13_14_15,
22    six_13_14_15_16_17_18, six_16_17_18_19_20_21, six_19_20_21_22_23_24, six_22_23_24_25_26_27, six_25_26_27_28_29_30, six_28_29_30_31_32_33,
23    six_31_32_33_34_35_36}
24    
25 
26    uint16 constant maxTypeBets = 157;
27    uint16 private betsProcessed;
28    mapping (uint16 => uint8) private winMatrix;
29       
30    function WinMatrix() 
31    {
32       developer = msg.sender;
33       betsProcessed   = 0;       
34    }
35 
36    function getBetsProcessed() external constant returns (uint16)
37    {
38         return betsProcessed;
39    }
40 
41    function deleteContract() onlyDeveloper  
42    {
43         suicide(msg.sender);
44    }
45 
46    function generateWinMatrix(uint16 count) onlyDeveloper
47    {      
48       if (betsProcessed == maxTypeBets) throw;
49       var max = betsProcessed + count;
50       if (max > maxTypeBets) max = maxTypeBets;
51 
52       for(uint16 bet=betsProcessed; bet<max; bet++)
53       {   
54         BetTypes betType = BetTypes(bet);                   
55         for(uint8 wheelResult=0; wheelResult<=36; wheelResult++)
56         {
57           uint16 index = getIndex(bet, wheelResult);
58           
59           if (bet <= 36) // bet on number
60           {
61               if (bet == wheelResult) winMatrix[index] = 35;
62           }
63           else if (betType == BetTypes.red)
64           {
65             if ((wheelResult == 1 ||
66                 wheelResult == 3  ||
67                 wheelResult == 5  ||
68                 wheelResult == 7  ||
69                 wheelResult == 9  ||
70                 wheelResult == 12 ||
71                 wheelResult == 14 ||
72                 wheelResult == 16 ||
73                 wheelResult == 18 ||
74                 wheelResult == 19 ||
75                 wheelResult == 21 ||
76                 wheelResult == 23 ||
77                 wheelResult == 25 ||
78                 wheelResult == 27 ||
79                 wheelResult == 30 ||
80                 wheelResult == 32 ||
81                 wheelResult == 34 ||
82                 wheelResult == 36) && wheelResult != 0) winMatrix[index] = 1; 
83                 
84           }
85           else if (betType == BetTypes.black)
86           {
87               if (!(wheelResult == 1 ||
88                 wheelResult == 3  ||
89                 wheelResult == 5  ||
90                 wheelResult == 7  ||
91                 wheelResult == 9  ||
92                 wheelResult == 12 ||
93                 wheelResult == 14 ||
94                 wheelResult == 16 ||
95                 wheelResult == 18 ||
96                 wheelResult == 19 ||
97                 wheelResult == 21 ||
98                 wheelResult == 23 ||
99                 wheelResult == 25 ||
100                 wheelResult == 27 ||
101                 wheelResult == 30 ||
102                 wheelResult == 32 ||
103                 wheelResult == 34 ||
104                 wheelResult == 36) && wheelResult != 0) winMatrix[index] = 1;
105           }
106           else if (betType == BetTypes.odd)
107           {
108             if (wheelResult % 2 != 0 && wheelResult != 0) winMatrix[index] = 1;  
109           }
110           else if (betType == BetTypes.even)
111           {
112             if (wheelResult % 2 == 0 && wheelResult != 0) winMatrix[index] = 1;     
113           }
114           else if (betType == BetTypes.low)
115           {
116               if (wheelResult < 19 && wheelResult != 0) winMatrix[index] = 1; 
117           }
118           else if (betType == BetTypes.high)
119           {
120             if (wheelResult > 18 && wheelResult != 0) winMatrix[index] = 1;     
121           }
122           else if (betType == BetTypes.dozen1)
123           {
124             if (wheelResult <13 && wheelResult != 0) winMatrix[index] = 2;
125           }
126           else if (betType == BetTypes.dozen2)
127           {
128             if (wheelResult >13 && wheelResult < 25 && wheelResult != 0) winMatrix[index] = 2;
129           }              
130           else if (betType == BetTypes.dozen3)
131           {
132               if (wheelResult >24 && wheelResult != 0) winMatrix[index] = 2;
133           }   
134           else if (betType == BetTypes.column1)
135           {
136               if (wheelResult%3 == 1 && wheelResult != 0) winMatrix[index] = 2;
137           }
138           else if (betType == BetTypes.column2)
139           {
140             if (wheelResult%3 == 2 && wheelResult != 0) winMatrix[index] = 2;    
141           }              
142           else if (betType == BetTypes.column3)
143           {
144               if (wheelResult%3 == 0 && wheelResult != 0) winMatrix[index] = 2;
145           }
146           else if (betType == BetTypes.pair_01)
147           {
148               if (wheelResult == 0 || wheelResult == 1) winMatrix[index] = 17;
149           }               
150           else if (betType == BetTypes.pair_02)
151           {
152               if (wheelResult == 0 || wheelResult == 2) winMatrix[index] = 17;
153           }
154           else if (betType == BetTypes.pair_03)
155           {
156               if (wheelResult == 0 || wheelResult == 3) winMatrix[index] = 17;
157           }               
158           else if (betType == BetTypes.pair_03)
159           {
160               if (wheelResult == 0 || wheelResult == 3) winMatrix[index] = 17;
161           }          
162           else if (betType == BetTypes.pair_12)
163           {
164               if (wheelResult == 1 || wheelResult == 2) winMatrix[index] = 17;
165           }
166           else if (betType == BetTypes.pair_23)
167           {
168               if (wheelResult == 2 || wheelResult == 3) winMatrix[index] = 17;
169           }
170           else if (betType == BetTypes.pair_36)
171           {
172               if (wheelResult == 3 || wheelResult == 6) winMatrix[index] = 17;
173           }
174           else if (betType == BetTypes.pair_25)
175           {
176               if (wheelResult == 2 || wheelResult == 5) winMatrix[index] = 17;
177           }
178           else if (betType == BetTypes.pair_14)
179           {
180               if (wheelResult == 1 || wheelResult == 4) winMatrix[index] = 17;
181           }
182           else if (betType == BetTypes.pair_45)
183           {
184               if (wheelResult == 4 || wheelResult == 5) winMatrix[index] = 17;
185           }
186           else if (betType == BetTypes.pair_56)
187           {
188               if (wheelResult == 5 || wheelResult == 6) winMatrix[index] = 17;
189           }
190           else if (betType == BetTypes.pair_69)
191           {
192               if (wheelResult == 6 || wheelResult == 9) winMatrix[index] = 17;
193           }
194           else if (betType == BetTypes.pair_58)
195           {
196               if (wheelResult == 5 || wheelResult == 8) winMatrix[index] = 17;
197           }
198           else if (betType == BetTypes.pair_47)
199           {
200               if (wheelResult == 4 || wheelResult == 7) winMatrix[index] = 17;
201           }
202           else if (betType == BetTypes.pair_78)
203           {
204               if (wheelResult == 7 || wheelResult == 8) winMatrix[index] = 17;
205           }
206           else if (betType == BetTypes.pair_89)
207           {
208               if (wheelResult == 8 || wheelResult == 9) winMatrix[index] = 17;
209           }
210           else if (betType == BetTypes.pair_912)
211           {
212               if (wheelResult == 9 || wheelResult == 12) winMatrix[index] = 17;
213           }
214           else if (betType == BetTypes.pair_811)
215           {
216               if (wheelResult == 8 || wheelResult == 11) winMatrix[index] = 17;
217           }
218           else if (betType == BetTypes.pair_710)
219           {
220               if (wheelResult == 7 || wheelResult == 10) winMatrix[index] = 17;
221           }
222           else if (betType == BetTypes.pair_1011)
223           {
224               if (wheelResult == 10 || wheelResult == 11) winMatrix[index] = 17;
225           }
226           else if (betType == BetTypes.pair_1112)
227           {
228               if (wheelResult == 12 || wheelResult == 12) winMatrix[index] = 17;
229           }
230           else if (betType == BetTypes.pair_1215)
231           {
232               if (wheelResult == 12 || wheelResult == 15) winMatrix[index] = 17;
233           }
234           else if (betType == BetTypes.pair_1518)
235           {
236               if (wheelResult == 15 || wheelResult == 18) winMatrix[index] = 17;
237           }
238           else if (betType == BetTypes.pair_1617)
239           {
240               if (wheelResult == 16 || wheelResult == 17) winMatrix[index] = 17;
241           }
242           else if (betType == BetTypes.pair_1718)
243           {
244               if (wheelResult == 17 || wheelResult == 18) winMatrix[index] = 17;
245           }
246           else if (betType == BetTypes.pair_1720)
247           {
248               if (wheelResult == 17 || wheelResult == 20) winMatrix[index] = 17;
249           }
250           else if (betType == BetTypes.pair_1619)
251           {
252               if (wheelResult == 16 || wheelResult == 19) winMatrix[index] = 17;
253           }
254           else if (betType == BetTypes.pair_1922)
255           {
256               if (wheelResult == 19 || wheelResult == 22) winMatrix[index] = 17;
257           }
258           else if (betType == BetTypes.pair_2023)
259           {
260               if (wheelResult == 20 || wheelResult == 23) winMatrix[index] = 17;
261           }
262           else if (betType == BetTypes.pair_2124)
263           {
264               if (wheelResult == 21 || wheelResult == 24) winMatrix[index] = 17;
265           }
266           else if (betType == BetTypes.pair_2223)
267           {
268               if (wheelResult == 22 || wheelResult == 23) winMatrix[index] = 17;
269           }
270           else if (betType == BetTypes.pair_2324)
271           {
272               if (wheelResult == 23 || wheelResult == 24) winMatrix[index] = 17;
273           }
274           else if (betType == BetTypes.pair_2528)
275           {
276               if (wheelResult == 25 || wheelResult == 28) winMatrix[index] = 17;
277           }
278           else if (betType == BetTypes.pair_2629)
279           {
280               if (wheelResult == 26 || wheelResult == 29) winMatrix[index] = 17;
281           }
282           else if (betType == BetTypes.pair_2730)
283           {
284               if (wheelResult == 27 || wheelResult == 30) winMatrix[index] = 17;
285           }
286           else if (betType == BetTypes.pair_2829)
287           {
288               if (wheelResult == 28 || wheelResult == 29) winMatrix[index] = 17;
289           }
290           else if (betType == BetTypes.pair_2930)
291           {
292               if (wheelResult == 29 || wheelResult == 30) winMatrix[index] = 17;
293           }
294           else if (betType == BetTypes.pair_1114)
295           {
296               if (wheelResult == 11 || wheelResult == 14) winMatrix[index] = 17;
297           } 
298           else if (betType == BetTypes.pair_1013)
299           {
300               if (wheelResult == 10 || wheelResult == 13) winMatrix[index] = 17;
301           } 
302           else if (betType == BetTypes.pair_1314)
303           {
304               if (wheelResult == 13 || wheelResult == 14) winMatrix[index] = 17;
305           } 
306           else if (betType == BetTypes.pair_1415)
307           {
308               if (wheelResult == 14 || wheelResult == 15) winMatrix[index] = 17;
309           }
310           else if (betType == BetTypes.pair_1316)
311           {
312               if (wheelResult == 13 || wheelResult == 16) winMatrix[index] = 17;
313           }
314           else if (betType == BetTypes.pair_1417)
315           {
316               if (wheelResult == 14 || wheelResult == 17) winMatrix[index] = 17;
317           }
318           else if (betType == BetTypes.pair_1821)
319           {
320               if (wheelResult == 18 || wheelResult == 21) winMatrix[index] = 17;
321           }
322           else if (betType == BetTypes.pair_1920)
323           {
324               if (wheelResult == 19 || wheelResult == 20) winMatrix[index] = 17;
325           }
326           else if (betType == BetTypes.pair_2021)
327           {
328               if (wheelResult == 20 || wheelResult == 21) winMatrix[index] = 17;
329           } 
330           else if (betType == BetTypes.pair_2225)
331           {
332               if (wheelResult == 22 || wheelResult == 25) winMatrix[index] = 17;
333           } 
334           else if (betType == BetTypes.pair_2326)
335           {
336               if (wheelResult == 23 || wheelResult == 26) winMatrix[index] = 17;
337           } 
338           else if (betType == BetTypes.pair_2427)
339           {
340               if (wheelResult == 24 || wheelResult == 27) winMatrix[index] = 17;
341           } 
342           else if (betType == BetTypes.pair_2526)
343           {
344               if (wheelResult == 25 || wheelResult == 26) winMatrix[index] = 17;
345           } 
346           else if (betType == BetTypes.pair_2627)
347           {
348               if (wheelResult == 26 || wheelResult == 27) winMatrix[index] = 17;
349           } 
350           else if (betType == BetTypes.pair_2831)
351           {
352               if (wheelResult == 28 || wheelResult == 31) winMatrix[index] = 17;
353           }
354           else if (betType == BetTypes.pair_2932)
355           {
356               if (wheelResult == 29 || wheelResult == 32) winMatrix[index] = 17;
357           }
358           else if (betType == BetTypes.pair_3033)
359           {
360               if (wheelResult == 30 || wheelResult == 33) winMatrix[index] = 17;
361           }
362           else if (betType == BetTypes.pair_3132)
363           {
364               if (wheelResult == 31 || wheelResult == 32) winMatrix[index] = 17;
365           }
366           else if (betType == BetTypes.pair_3233)
367           {
368               if (wheelResult == 32 || wheelResult == 33) winMatrix[index] = 17;
369           }
370           else if (betType == BetTypes.pair_3134)
371           {
372               if (wheelResult == 31 || wheelResult == 34) winMatrix[index] = 17;
373           }
374           else if (betType == BetTypes.pair_3235)
375           {
376               if (wheelResult == 32 || wheelResult == 35) winMatrix[index] = 17;
377           }
378           else if (betType == BetTypes.pair_3336)
379           {
380               if (wheelResult == 33 || wheelResult == 36) winMatrix[index] = 17;
381           }
382           else if (betType == BetTypes.pair_3435)
383           {
384               if (wheelResult == 34 || wheelResult == 35) winMatrix[index] = 17;
385           }
386           else if (betType == BetTypes.pair_3536)
387           {
388               if (wheelResult == 35 || wheelResult == 36) winMatrix[index] = 17;
389           }
390           else if (betType == BetTypes.corner_0_1_2_3)
391           {
392             if (wheelResult == 0 || wheelResult == 1  || wheelResult == 2  || wheelResult == 3) winMatrix[index] = 8;
393           }
394           else if (betType == BetTypes.corner_1_2_5_4)
395           {
396             if (wheelResult == 1 || wheelResult == 2  || wheelResult == 5  || wheelResult == 4) winMatrix[index] = 8;
397           }
398           else if (betType == BetTypes.corner_2_3_6_5)
399           {
400             if (wheelResult == 2 || wheelResult == 3  || wheelResult == 6  || wheelResult == 5) winMatrix[index] = 8;
401           }
402           else if (betType == BetTypes.corner_4_5_8_7)
403           {
404             if (wheelResult == 4 || wheelResult == 5  || wheelResult == 8  || wheelResult == 7) winMatrix[index] = 8;
405           }
406           else if (betType == BetTypes.corner_5_6_9_8)
407           {
408             if (wheelResult == 5 || wheelResult == 6  || wheelResult == 9  || wheelResult == 8) winMatrix[index] = 8;
409           }
410           else if (betType == BetTypes.corner_7_8_11_10)
411           {
412             if (wheelResult == 7 || wheelResult == 8  || wheelResult == 11  || wheelResult == 10) winMatrix[index] = 8;
413           }
414           else if (betType == BetTypes.corner_8_9_12_11)
415           {
416             if (wheelResult == 8 || wheelResult == 9  || wheelResult == 12  || wheelResult == 11) winMatrix[index] = 8;
417           }
418           else if (betType == BetTypes.corner_10_11_14_13)
419           {
420             if (wheelResult == 10 || wheelResult == 11  || wheelResult == 14  || wheelResult == 13) winMatrix[index] = 8;
421           }
422           else if (betType == BetTypes.corner_11_12_15_14)
423           {
424             if (wheelResult == 11 || wheelResult == 12  || wheelResult == 15  || wheelResult == 14) winMatrix[index] = 8;
425           }
426           else if (betType == BetTypes.corner_13_14_17_16)
427           {
428             if (wheelResult == 13 || wheelResult == 14  || wheelResult == 17  || wheelResult == 16) winMatrix[index] = 8;
429           }
430           else if (betType == BetTypes.corner_14_15_18_17)
431           {
432             if (wheelResult == 14 || wheelResult == 15  || wheelResult == 18  || wheelResult == 17) winMatrix[index] = 8;
433           }
434           else if (betType == BetTypes.corner_16_17_20_19)
435           {
436             if (wheelResult == 16 || wheelResult == 17  || wheelResult == 20  || wheelResult == 19) winMatrix[index] = 8;
437           }
438           else if (betType == BetTypes.corner_17_18_21_20)
439           {
440             if (wheelResult == 17 || wheelResult == 18  || wheelResult == 21  || wheelResult == 20) winMatrix[index] = 8;
441           }
442           else if (betType == BetTypes.corner_19_20_23_22)
443           {
444             if (wheelResult == 19 || wheelResult == 20  || wheelResult == 23  || wheelResult == 22) winMatrix[index] = 8;
445           }
446           else if (betType == BetTypes.corner_20_21_24_23)
447           {
448             if (wheelResult == 20 || wheelResult == 21  || wheelResult == 24  || wheelResult == 23) winMatrix[index] = 8;
449           }
450           else if (betType == BetTypes.corner_22_23_26_25)
451           {
452             if (wheelResult == 22 || wheelResult == 23  || wheelResult == 26  || wheelResult == 25) winMatrix[index] = 8;
453           }
454           else if (betType == BetTypes.corner_23_24_27_26)
455           {
456             if (wheelResult == 23 || wheelResult == 24  || wheelResult == 27  || wheelResult == 26) winMatrix[index] = 8;
457           }
458           else if (betType == BetTypes.corner_25_26_29_28)
459           {
460             if (wheelResult == 25 || wheelResult == 26  || wheelResult == 29  || wheelResult == 28) winMatrix[index] = 8;
461           }
462           else if (betType == BetTypes.corner_26_27_30_29)
463           {
464             if (wheelResult == 26 || wheelResult == 27  || wheelResult == 30  || wheelResult == 29) winMatrix[index] = 8;
465           }
466           else if (betType == BetTypes.corner_28_29_32_31)
467           {
468             if (wheelResult == 28 || wheelResult == 29  || wheelResult == 32  || wheelResult == 31) winMatrix[index] = 8;
469           }
470           else if (betType == BetTypes.corner_29_30_33_32)
471           {
472             if (wheelResult == 29 || wheelResult == 30  || wheelResult == 33  || wheelResult == 32) winMatrix[index] = 8;
473           }
474           else if (betType == BetTypes.corner_31_32_35_34)
475           {
476             if (wheelResult == 31 || wheelResult == 32  || wheelResult == 35  || wheelResult == 34) winMatrix[index] = 8;
477           }
478           else if (betType == BetTypes.corner_32_33_36_35)
479           {
480             if (wheelResult == 32 || wheelResult == 33  || wheelResult == 36  || wheelResult == 35) winMatrix[index] = 8;
481           }
482           else if (betType == BetTypes.three_0_2_3)
483           {
484             if (wheelResult == 0 || wheelResult == 2  || wheelResult == 3) winMatrix[index] = 11;
485           }          
486           else if (betType == BetTypes.three_0_1_2)
487           {
488             if (wheelResult == 0 || wheelResult == 1  || wheelResult == 2) winMatrix[index] = 11;
489           }          
490           else if (betType == BetTypes.three_1_2_3)
491           {
492             if (wheelResult == 1 || wheelResult == 2  || wheelResult == 3) winMatrix[index] = 11;
493           }
494           else if (betType == BetTypes.three_4_5_6)
495           {
496             if (wheelResult == 4 || wheelResult == 5  || wheelResult == 6) winMatrix[index] = 11;
497           }
498           else if (betType == BetTypes.three_7_8_9)
499           {
500             if (wheelResult == 7 || wheelResult == 8  || wheelResult == 9) winMatrix[index] = 11;
501           }
502           else if (betType == BetTypes.three_10_11_12)
503           {
504             if (wheelResult == 10 || wheelResult == 11  || wheelResult == 12) winMatrix[index] = 11;
505           }
506           else if (betType == BetTypes.three_13_14_15)
507           {
508             if (wheelResult == 13 || wheelResult == 14  || wheelResult == 15) winMatrix[index] = 11;
509           }
510           else if (betType == BetTypes.three_16_17_18)
511           {
512             if (wheelResult == 16 || wheelResult == 17  || wheelResult == 18) winMatrix[index] = 11;
513           }
514           else if (betType == BetTypes.three_19_20_21)
515           {
516             if (wheelResult == 19 || wheelResult == 20  || wheelResult == 21) winMatrix[index] = 11;
517           }
518           else if (betType == BetTypes.three_22_23_24)
519           {
520             if (wheelResult == 22 || wheelResult == 23  || wheelResult == 24) winMatrix[index] = 11;
521           }
522           else if (betType == BetTypes.three_25_26_27)
523           {
524             if (wheelResult == 25 || wheelResult == 26  || wheelResult == 27) winMatrix[index] = 11;
525           }
526           else if (betType == BetTypes.three_28_29_30)
527           {
528             if (wheelResult == 28 || wheelResult == 29  || wheelResult == 30) winMatrix[index] = 11;
529           }
530           else if (betType == BetTypes.three_31_32_33)
531           {
532             if (wheelResult == 31 || wheelResult == 32  || wheelResult == 33) winMatrix[index] = 11;
533           }
534           else if (betType == BetTypes.three_34_35_36)
535           {
536             if (wheelResult == 34 || wheelResult == 35  || wheelResult == 36) winMatrix[index] = 11;
537           }
538           else if (betType == BetTypes.six_1_2_3_4_5_6)
539           {
540             if (wheelResult == 1 || wheelResult == 2  || wheelResult == 3  || wheelResult == 4  || wheelResult == 5  || wheelResult == 6) winMatrix[index] = 5;
541           }
542           else if (betType == BetTypes.six_4_5_6_7_8_9)
543           {
544             if (wheelResult == 4 || wheelResult == 5  || wheelResult == 6  || wheelResult == 7  || wheelResult == 8  || wheelResult == 9) winMatrix[index] = 5;
545           }
546           else if (betType == BetTypes.six_7_8_9_10_11_12)
547           {
548             if (wheelResult == 7 || wheelResult == 8  || wheelResult == 9  || wheelResult == 10  || wheelResult == 11  || wheelResult == 12) winMatrix[index] = 5;
549           }
550           else if (betType == BetTypes.six_10_11_12_13_14_15)
551           {
552             if (wheelResult == 10 || wheelResult == 11  || wheelResult == 12  || wheelResult == 13  || wheelResult == 14  || wheelResult == 15) winMatrix[index] = 5;
553           }
554           else if (betType == BetTypes.six_13_14_15_16_17_18)
555           {
556             if (wheelResult == 13 || wheelResult == 14  || wheelResult == 15  || wheelResult == 16  || wheelResult == 17  || wheelResult == 18) winMatrix[index] = 5;
557           }
558           else if (betType == BetTypes.six_16_17_18_19_20_21)
559           {
560             if (wheelResult == 16 || wheelResult == 17  || wheelResult == 18  || wheelResult == 19  || wheelResult == 20  || wheelResult == 21) winMatrix[index] = 5;
561           }
562           else if (betType == BetTypes.six_19_20_21_22_23_24)
563           {
564             if (wheelResult == 19 || wheelResult == 20  || wheelResult == 21  || wheelResult == 22  || wheelResult == 23  || wheelResult == 24) winMatrix[index] = 5;
565           }
566           else if (betType == BetTypes.six_22_23_24_25_26_27)
567           {
568             if (wheelResult == 22 || wheelResult == 23  || wheelResult == 24  || wheelResult == 25  || wheelResult == 26  || wheelResult == 27) winMatrix[index] = 5;
569           }
570           else if (betType == BetTypes.six_25_26_27_28_29_30)
571           {
572             if (wheelResult == 25 || wheelResult == 26  || wheelResult == 27  || wheelResult == 28  || wheelResult == 29  || wheelResult == 30) winMatrix[index] = 5;
573           }
574           else if (betType == BetTypes.six_28_29_30_31_32_33)
575           {
576             if (wheelResult == 28 || wheelResult == 29  || wheelResult == 30  || wheelResult == 31  || wheelResult == 32  || wheelResult == 33) winMatrix[index] = 5;
577           }
578           else if (betType == BetTypes.six_31_32_33_34_35_36)
579           {
580             if (wheelResult == 31 || wheelResult == 32  || wheelResult == 33  || wheelResult == 34  || wheelResult == 35  || wheelResult == 36) winMatrix[index] = 5;
581           }
582         }
583       }
584 
585       betsProcessed = max;
586    }
587 
588    function getIndex(uint16 bet, uint16 wheelResult) private returns (uint16)
589    {
590       return (bet+1)*256 + (wheelResult+1);
591    }
592        
593     modifier onlyDeveloper() 
594     {
595        if (msg.sender!=developer) throw;
596        _;
597     }
598 
599 
600     function getCoeff(uint16 n) external returns (uint256) 
601     {
602         return winMatrix[n];
603     }
604 
605    function() 
606    {
607       throw;
608    }
609    
610 
611 }