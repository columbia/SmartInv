1 pragma solidity ^0.4.8;
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
41    function isReady() external constant returns (bool)
42    {
43         return betsProcessed == maxTypeBets;
44    }
45 
46    function deleteContract() onlyDeveloper  
47    {
48         suicide(msg.sender);
49    }
50 
51    function generateWinMatrix(uint16 count) onlyDeveloper
52    {      
53       if (betsProcessed == maxTypeBets) throw;
54       var max = betsProcessed + count;
55       if (max > maxTypeBets) max = maxTypeBets;
56 
57       for(uint16 bet=betsProcessed; bet<max; bet++)
58       {   
59         BetTypes betType = BetTypes(bet);                   
60         for(uint8 wheelResult=0; wheelResult<=36; wheelResult++)
61         {
62           uint16 index = getIndex(bet, wheelResult);
63           
64           if (bet <= 36) // bet on number
65           {
66               if (bet == wheelResult) winMatrix[index] = 35;
67           }
68           else if (betType == BetTypes.red)
69           {
70             if ((wheelResult == 1 ||
71                 wheelResult == 3  ||
72                 wheelResult == 5  ||
73                 wheelResult == 7  ||
74                 wheelResult == 9  ||
75                 wheelResult == 12 ||
76                 wheelResult == 14 ||
77                 wheelResult == 16 ||
78                 wheelResult == 18 ||
79                 wheelResult == 19 ||
80                 wheelResult == 21 ||
81                 wheelResult == 23 ||
82                 wheelResult == 25 ||
83                 wheelResult == 27 ||
84                 wheelResult == 30 ||
85                 wheelResult == 32 ||
86                 wheelResult == 34 ||
87                 wheelResult == 36) && wheelResult != 0) winMatrix[index] = 1; 
88                 
89           }
90           else if (betType == BetTypes.black)
91           {
92               if (!(wheelResult == 1 ||
93                 wheelResult == 3  ||
94                 wheelResult == 5  ||
95                 wheelResult == 7  ||
96                 wheelResult == 9  ||
97                 wheelResult == 12 ||
98                 wheelResult == 14 ||
99                 wheelResult == 16 ||
100                 wheelResult == 18 ||
101                 wheelResult == 19 ||
102                 wheelResult == 21 ||
103                 wheelResult == 23 ||
104                 wheelResult == 25 ||
105                 wheelResult == 27 ||
106                 wheelResult == 30 ||
107                 wheelResult == 32 ||
108                 wheelResult == 34 ||
109                 wheelResult == 36) && wheelResult != 0) winMatrix[index] = 1;
110           }
111           else if (betType == BetTypes.odd)
112           {
113             if (wheelResult % 2 != 0 && wheelResult != 0) winMatrix[index] = 1;  
114           }
115           else if (betType == BetTypes.even)
116           {
117             if (wheelResult % 2 == 0 && wheelResult != 0) winMatrix[index] = 1;     
118           }
119           else if (betType == BetTypes.low)
120           {
121               if (wheelResult < 19 && wheelResult != 0) winMatrix[index] = 1; 
122           }
123           else if (betType == BetTypes.high)
124           {
125             if (wheelResult > 18) winMatrix[index] = 1;     
126           }
127           else if (betType == BetTypes.dozen1)
128           {
129             if (wheelResult <13 && wheelResult != 0) winMatrix[index] = 2;
130           }
131           else if (betType == BetTypes.dozen2)
132           {
133             if (wheelResult >12 && wheelResult < 25) winMatrix[index] = 2;
134           }              
135           else if (betType == BetTypes.dozen3)
136           {
137               if (wheelResult >24) winMatrix[index] = 2;
138           }   
139           else if (betType == BetTypes.column1)
140           {
141               if (wheelResult%3 == 1 && wheelResult != 0) winMatrix[index] = 2;
142           }
143           else if (betType == BetTypes.column2)
144           {
145             if (wheelResult%3 == 2 && wheelResult != 0) winMatrix[index] = 2;    
146           }              
147           else if (betType == BetTypes.column3)
148           {
149               if (wheelResult%3 == 0 && wheelResult != 0) winMatrix[index] = 2;
150           }
151           else if (betType == BetTypes.pair_01)
152           {
153               if (wheelResult == 0 || wheelResult == 1) winMatrix[index] = 17;
154           }               
155           else if (betType == BetTypes.pair_02)
156           {
157               if (wheelResult == 0 || wheelResult == 2) winMatrix[index] = 17;
158           }          
159           else if (betType == BetTypes.pair_03)
160           {
161               if (wheelResult == 0 || wheelResult == 3) winMatrix[index] = 17;
162           }          
163           else if (betType == BetTypes.pair_12)
164           {
165               if (wheelResult == 1 || wheelResult == 2) winMatrix[index] = 17;
166           }
167           else if (betType == BetTypes.pair_23)
168           {
169               if (wheelResult == 2 || wheelResult == 3) winMatrix[index] = 17;
170           }
171           else if (betType == BetTypes.pair_36)
172           {
173               if (wheelResult == 3 || wheelResult == 6) winMatrix[index] = 17;
174           }
175           else if (betType == BetTypes.pair_25)
176           {
177               if (wheelResult == 2 || wheelResult == 5) winMatrix[index] = 17;
178           }
179           else if (betType == BetTypes.pair_14)
180           {
181               if (wheelResult == 1 || wheelResult == 4) winMatrix[index] = 17;
182           }
183           else if (betType == BetTypes.pair_45)
184           {
185               if (wheelResult == 4 || wheelResult == 5) winMatrix[index] = 17;
186           }
187           else if (betType == BetTypes.pair_56)
188           {
189               if (wheelResult == 5 || wheelResult == 6) winMatrix[index] = 17;
190           }
191           else if (betType == BetTypes.pair_69)
192           {
193               if (wheelResult == 6 || wheelResult == 9) winMatrix[index] = 17;
194           }
195           else if (betType == BetTypes.pair_58)
196           {
197               if (wheelResult == 5 || wheelResult == 8) winMatrix[index] = 17;
198           }
199           else if (betType == BetTypes.pair_47)
200           {
201               if (wheelResult == 4 || wheelResult == 7) winMatrix[index] = 17;
202           }
203           else if (betType == BetTypes.pair_78)
204           {
205               if (wheelResult == 7 || wheelResult == 8) winMatrix[index] = 17;
206           }
207           else if (betType == BetTypes.pair_89)
208           {
209               if (wheelResult == 8 || wheelResult == 9) winMatrix[index] = 17;
210           }
211           else if (betType == BetTypes.pair_912)
212           {
213               if (wheelResult == 9 || wheelResult == 12) winMatrix[index] = 17;
214           }
215           else if (betType == BetTypes.pair_811)
216           {
217               if (wheelResult == 8 || wheelResult == 11) winMatrix[index] = 17;
218           }
219           else if (betType == BetTypes.pair_710)
220           {
221               if (wheelResult == 7 || wheelResult == 10) winMatrix[index] = 17;
222           }
223           else if (betType == BetTypes.pair_1011)
224           {
225               if (wheelResult == 10 || wheelResult == 11) winMatrix[index] = 17;
226           }
227           else if (betType == BetTypes.pair_1112)
228           {
229               if (wheelResult == 11 || wheelResult == 12) winMatrix[index] = 17;
230           }
231           else if (betType == BetTypes.pair_1215)
232           {
233               if (wheelResult == 12 || wheelResult == 15) winMatrix[index] = 17;
234           }
235           else if (betType == BetTypes.pair_1518)
236           {
237               if (wheelResult == 15 || wheelResult == 18) winMatrix[index] = 17;
238           }
239           else if (betType == BetTypes.pair_1617)
240           {
241               if (wheelResult == 16 || wheelResult == 17) winMatrix[index] = 17;
242           }
243           else if (betType == BetTypes.pair_1718)
244           {
245               if (wheelResult == 17 || wheelResult == 18) winMatrix[index] = 17;
246           }
247           else if (betType == BetTypes.pair_1720)
248           {
249               if (wheelResult == 17 || wheelResult == 20) winMatrix[index] = 17;
250           }
251           else if (betType == BetTypes.pair_1619)
252           {
253               if (wheelResult == 16 || wheelResult == 19) winMatrix[index] = 17;
254           }
255           else if (betType == BetTypes.pair_1922)
256           {
257               if (wheelResult == 19 || wheelResult == 22) winMatrix[index] = 17;
258           }
259           else if (betType == BetTypes.pair_2023)
260           {
261               if (wheelResult == 20 || wheelResult == 23) winMatrix[index] = 17;
262           }
263           else if (betType == BetTypes.pair_2124)
264           {
265               if (wheelResult == 21 || wheelResult == 24) winMatrix[index] = 17;
266           }
267           else if (betType == BetTypes.pair_2223)
268           {
269               if (wheelResult == 22 || wheelResult == 23) winMatrix[index] = 17;
270           }
271           else if (betType == BetTypes.pair_2324)
272           {
273               if (wheelResult == 23 || wheelResult == 24) winMatrix[index] = 17;
274           }
275           else if (betType == BetTypes.pair_2528)
276           {
277               if (wheelResult == 25 || wheelResult == 28) winMatrix[index] = 17;
278           }
279           else if (betType == BetTypes.pair_2629)
280           {
281               if (wheelResult == 26 || wheelResult == 29) winMatrix[index] = 17;
282           }
283           else if (betType == BetTypes.pair_2730)
284           {
285               if (wheelResult == 27 || wheelResult == 30) winMatrix[index] = 17;
286           }
287           else if (betType == BetTypes.pair_2829)
288           {
289               if (wheelResult == 28 || wheelResult == 29) winMatrix[index] = 17;
290           }
291           else if (betType == BetTypes.pair_2930)
292           {
293               if (wheelResult == 29 || wheelResult == 30) winMatrix[index] = 17;
294           }
295           else if (betType == BetTypes.pair_1114)
296           {
297               if (wheelResult == 11 || wheelResult == 14) winMatrix[index] = 17;
298           } 
299           else if (betType == BetTypes.pair_1013)
300           {
301               if (wheelResult == 10 || wheelResult == 13) winMatrix[index] = 17;
302           } 
303           else if (betType == BetTypes.pair_1314)
304           {
305               if (wheelResult == 13 || wheelResult == 14) winMatrix[index] = 17;
306           } 
307           else if (betType == BetTypes.pair_1415)
308           {
309               if (wheelResult == 14 || wheelResult == 15) winMatrix[index] = 17;
310           }
311           else if (betType == BetTypes.pair_1316)
312           {
313               if (wheelResult == 13 || wheelResult == 16) winMatrix[index] = 17;
314           }
315           else if (betType == BetTypes.pair_1417)
316           {
317               if (wheelResult == 14 || wheelResult == 17) winMatrix[index] = 17;
318           }
319           else if (betType == BetTypes.pair_1821)
320           {
321               if (wheelResult == 18 || wheelResult == 21) winMatrix[index] = 17;
322           }
323           else if (betType == BetTypes.pair_1920)
324           {
325               if (wheelResult == 19 || wheelResult == 20) winMatrix[index] = 17;
326           }
327           else if (betType == BetTypes.pair_2021)
328           {
329               if (wheelResult == 20 || wheelResult == 21) winMatrix[index] = 17;
330           } 
331           else if (betType == BetTypes.pair_2225)
332           {
333               if (wheelResult == 22 || wheelResult == 25) winMatrix[index] = 17;
334           } 
335           else if (betType == BetTypes.pair_2326)
336           {
337               if (wheelResult == 23 || wheelResult == 26) winMatrix[index] = 17;
338           } 
339           else if (betType == BetTypes.pair_2427)
340           {
341               if (wheelResult == 24 || wheelResult == 27) winMatrix[index] = 17;
342           } 
343           else if (betType == BetTypes.pair_2526)
344           {
345               if (wheelResult == 25 || wheelResult == 26) winMatrix[index] = 17;
346           } 
347           else if (betType == BetTypes.pair_2627)
348           {
349               if (wheelResult == 26 || wheelResult == 27) winMatrix[index] = 17;
350           } 
351           else if (betType == BetTypes.pair_2831)
352           {
353               if (wheelResult == 28 || wheelResult == 31) winMatrix[index] = 17;
354           }
355           else if (betType == BetTypes.pair_2932)
356           {
357               if (wheelResult == 29 || wheelResult == 32) winMatrix[index] = 17;
358           }
359           else if (betType == BetTypes.pair_3033)
360           {
361               if (wheelResult == 30 || wheelResult == 33) winMatrix[index] = 17;
362           }
363           else if (betType == BetTypes.pair_3132)
364           {
365               if (wheelResult == 31 || wheelResult == 32) winMatrix[index] = 17;
366           }
367           else if (betType == BetTypes.pair_3233)
368           {
369               if (wheelResult == 32 || wheelResult == 33) winMatrix[index] = 17;
370           }
371           else if (betType == BetTypes.pair_3134)
372           {
373               if (wheelResult == 31 || wheelResult == 34) winMatrix[index] = 17;
374           }
375           else if (betType == BetTypes.pair_3235)
376           {
377               if (wheelResult == 32 || wheelResult == 35) winMatrix[index] = 17;
378           }
379           else if (betType == BetTypes.pair_3336)
380           {
381               if (wheelResult == 33 || wheelResult == 36) winMatrix[index] = 17;
382           }
383           else if (betType == BetTypes.pair_3435)
384           {
385               if (wheelResult == 34 || wheelResult == 35) winMatrix[index] = 17;
386           }
387           else if (betType == BetTypes.pair_3536)
388           {
389               if (wheelResult == 35 || wheelResult == 36) winMatrix[index] = 17;
390           }
391           else if (betType == BetTypes.corner_0_1_2_3)
392           {
393             if (wheelResult == 0 || wheelResult == 1  || wheelResult == 2  || wheelResult == 3) winMatrix[index] = 8;
394           }
395           else if (betType == BetTypes.corner_1_2_5_4)
396           {
397             if (wheelResult == 1 || wheelResult == 2  || wheelResult == 5  || wheelResult == 4) winMatrix[index] = 8;
398           }
399           else if (betType == BetTypes.corner_2_3_6_5)
400           {
401             if (wheelResult == 2 || wheelResult == 3  || wheelResult == 6  || wheelResult == 5) winMatrix[index] = 8;
402           }
403           else if (betType == BetTypes.corner_4_5_8_7)
404           {
405             if (wheelResult == 4 || wheelResult == 5  || wheelResult == 8  || wheelResult == 7) winMatrix[index] = 8;
406           }
407           else if (betType == BetTypes.corner_5_6_9_8)
408           {
409             if (wheelResult == 5 || wheelResult == 6  || wheelResult == 9  || wheelResult == 8) winMatrix[index] = 8;
410           }
411           else if (betType == BetTypes.corner_7_8_11_10)
412           {
413             if (wheelResult == 7 || wheelResult == 8  || wheelResult == 11  || wheelResult == 10) winMatrix[index] = 8;
414           }
415           else if (betType == BetTypes.corner_8_9_12_11)
416           {
417             if (wheelResult == 8 || wheelResult == 9  || wheelResult == 12  || wheelResult == 11) winMatrix[index] = 8;
418           }
419           else if (betType == BetTypes.corner_10_11_14_13)
420           {
421             if (wheelResult == 10 || wheelResult == 11  || wheelResult == 14  || wheelResult == 13) winMatrix[index] = 8;
422           }
423           else if (betType == BetTypes.corner_11_12_15_14)
424           {
425             if (wheelResult == 11 || wheelResult == 12  || wheelResult == 15  || wheelResult == 14) winMatrix[index] = 8;
426           }
427           else if (betType == BetTypes.corner_13_14_17_16)
428           {
429             if (wheelResult == 13 || wheelResult == 14  || wheelResult == 17  || wheelResult == 16) winMatrix[index] = 8;
430           }
431           else if (betType == BetTypes.corner_14_15_18_17)
432           {
433             if (wheelResult == 14 || wheelResult == 15  || wheelResult == 18  || wheelResult == 17) winMatrix[index] = 8;
434           }
435           else if (betType == BetTypes.corner_16_17_20_19)
436           {
437             if (wheelResult == 16 || wheelResult == 17  || wheelResult == 20  || wheelResult == 19) winMatrix[index] = 8;
438           }
439           else if (betType == BetTypes.corner_17_18_21_20)
440           {
441             if (wheelResult == 17 || wheelResult == 18  || wheelResult == 21  || wheelResult == 20) winMatrix[index] = 8;
442           }
443           else if (betType == BetTypes.corner_19_20_23_22)
444           {
445             if (wheelResult == 19 || wheelResult == 20  || wheelResult == 23  || wheelResult == 22) winMatrix[index] = 8;
446           }
447           else if (betType == BetTypes.corner_20_21_24_23)
448           {
449             if (wheelResult == 20 || wheelResult == 21  || wheelResult == 24  || wheelResult == 23) winMatrix[index] = 8;
450           }
451           else if (betType == BetTypes.corner_22_23_26_25)
452           {
453             if (wheelResult == 22 || wheelResult == 23  || wheelResult == 26  || wheelResult == 25) winMatrix[index] = 8;
454           }
455           else if (betType == BetTypes.corner_23_24_27_26)
456           {
457             if (wheelResult == 23 || wheelResult == 24  || wheelResult == 27  || wheelResult == 26) winMatrix[index] = 8;
458           }
459           else if (betType == BetTypes.corner_25_26_29_28)
460           {
461             if (wheelResult == 25 || wheelResult == 26  || wheelResult == 29  || wheelResult == 28) winMatrix[index] = 8;
462           }
463           else if (betType == BetTypes.corner_26_27_30_29)
464           {
465             if (wheelResult == 26 || wheelResult == 27  || wheelResult == 30  || wheelResult == 29) winMatrix[index] = 8;
466           }
467           else if (betType == BetTypes.corner_28_29_32_31)
468           {
469             if (wheelResult == 28 || wheelResult == 29  || wheelResult == 32  || wheelResult == 31) winMatrix[index] = 8;
470           }
471           else if (betType == BetTypes.corner_29_30_33_32)
472           {
473             if (wheelResult == 29 || wheelResult == 30  || wheelResult == 33  || wheelResult == 32) winMatrix[index] = 8;
474           }
475           else if (betType == BetTypes.corner_31_32_35_34)
476           {
477             if (wheelResult == 31 || wheelResult == 32  || wheelResult == 35  || wheelResult == 34) winMatrix[index] = 8;
478           }
479           else if (betType == BetTypes.corner_32_33_36_35)
480           {
481             if (wheelResult == 32 || wheelResult == 33  || wheelResult == 36  || wheelResult == 35) winMatrix[index] = 8;
482           }
483           else if (betType == BetTypes.three_0_2_3)
484           {
485             if (wheelResult == 0 || wheelResult == 2  || wheelResult == 3) winMatrix[index] = 11;
486           }          
487           else if (betType == BetTypes.three_0_1_2)
488           {
489             if (wheelResult == 0 || wheelResult == 1  || wheelResult == 2) winMatrix[index] = 11;
490           }          
491           else if (betType == BetTypes.three_1_2_3)
492           {
493             if (wheelResult == 1 || wheelResult == 2  || wheelResult == 3) winMatrix[index] = 11;
494           }
495           else if (betType == BetTypes.three_4_5_6)
496           {
497             if (wheelResult == 4 || wheelResult == 5  || wheelResult == 6) winMatrix[index] = 11;
498           }
499           else if (betType == BetTypes.three_7_8_9)
500           {
501             if (wheelResult == 7 || wheelResult == 8  || wheelResult == 9) winMatrix[index] = 11;
502           }
503           else if (betType == BetTypes.three_10_11_12)
504           {
505             if (wheelResult == 10 || wheelResult == 11  || wheelResult == 12) winMatrix[index] = 11;
506           }
507           else if (betType == BetTypes.three_13_14_15)
508           {
509             if (wheelResult == 13 || wheelResult == 14  || wheelResult == 15) winMatrix[index] = 11;
510           }
511           else if (betType == BetTypes.three_16_17_18)
512           {
513             if (wheelResult == 16 || wheelResult == 17  || wheelResult == 18) winMatrix[index] = 11;
514           }
515           else if (betType == BetTypes.three_19_20_21)
516           {
517             if (wheelResult == 19 || wheelResult == 20  || wheelResult == 21) winMatrix[index] = 11;
518           }
519           else if (betType == BetTypes.three_22_23_24)
520           {
521             if (wheelResult == 22 || wheelResult == 23  || wheelResult == 24) winMatrix[index] = 11;
522           }
523           else if (betType == BetTypes.three_25_26_27)
524           {
525             if (wheelResult == 25 || wheelResult == 26  || wheelResult == 27) winMatrix[index] = 11;
526           }
527           else if (betType == BetTypes.three_28_29_30)
528           {
529             if (wheelResult == 28 || wheelResult == 29  || wheelResult == 30) winMatrix[index] = 11;
530           }
531           else if (betType == BetTypes.three_31_32_33)
532           {
533             if (wheelResult == 31 || wheelResult == 32  || wheelResult == 33) winMatrix[index] = 11;
534           }
535           else if (betType == BetTypes.three_34_35_36)
536           {
537             if (wheelResult == 34 || wheelResult == 35  || wheelResult == 36) winMatrix[index] = 11;
538           }
539           else if (betType == BetTypes.six_1_2_3_4_5_6)
540           {
541             if (wheelResult == 1 || wheelResult == 2  || wheelResult == 3  || wheelResult == 4  || wheelResult == 5  || wheelResult == 6) winMatrix[index] = 5;
542           }
543           else if (betType == BetTypes.six_4_5_6_7_8_9)
544           {
545             if (wheelResult == 4 || wheelResult == 5  || wheelResult == 6  || wheelResult == 7  || wheelResult == 8  || wheelResult == 9) winMatrix[index] = 5;
546           }
547           else if (betType == BetTypes.six_7_8_9_10_11_12)
548           {
549             if (wheelResult == 7 || wheelResult == 8  || wheelResult == 9  || wheelResult == 10  || wheelResult == 11  || wheelResult == 12) winMatrix[index] = 5;
550           }
551           else if (betType == BetTypes.six_10_11_12_13_14_15)
552           {
553             if (wheelResult == 10 || wheelResult == 11  || wheelResult == 12  || wheelResult == 13  || wheelResult == 14  || wheelResult == 15) winMatrix[index] = 5;
554           }
555           else if (betType == BetTypes.six_13_14_15_16_17_18)
556           {
557             if (wheelResult == 13 || wheelResult == 14  || wheelResult == 15  || wheelResult == 16  || wheelResult == 17  || wheelResult == 18) winMatrix[index] = 5;
558           }
559           else if (betType == BetTypes.six_16_17_18_19_20_21)
560           {
561             if (wheelResult == 16 || wheelResult == 17  || wheelResult == 18  || wheelResult == 19  || wheelResult == 20  || wheelResult == 21) winMatrix[index] = 5;
562           }
563           else if (betType == BetTypes.six_19_20_21_22_23_24)
564           {
565             if (wheelResult == 19 || wheelResult == 20  || wheelResult == 21  || wheelResult == 22  || wheelResult == 23  || wheelResult == 24) winMatrix[index] = 5;
566           }
567           else if (betType == BetTypes.six_22_23_24_25_26_27)
568           {
569             if (wheelResult == 22 || wheelResult == 23  || wheelResult == 24  || wheelResult == 25  || wheelResult == 26  || wheelResult == 27) winMatrix[index] = 5;
570           }
571           else if (betType == BetTypes.six_25_26_27_28_29_30)
572           {
573             if (wheelResult == 25 || wheelResult == 26  || wheelResult == 27  || wheelResult == 28  || wheelResult == 29  || wheelResult == 30) winMatrix[index] = 5;
574           }
575           else if (betType == BetTypes.six_28_29_30_31_32_33)
576           {
577             if (wheelResult == 28 || wheelResult == 29  || wheelResult == 30  || wheelResult == 31  || wheelResult == 32  || wheelResult == 33) winMatrix[index] = 5;
578           }
579           else if (betType == BetTypes.six_31_32_33_34_35_36)
580           {
581             if (wheelResult == 31 || wheelResult == 32  || wheelResult == 33  || wheelResult == 34  || wheelResult == 35  || wheelResult == 36) winMatrix[index] = 5;
582           }
583         }
584       }
585 
586       betsProcessed = max;
587    }
588 
589    function getIndex(uint16 bet, uint16 wheelResult) private returns (uint16)
590    {
591       return (bet+1)*256 + (wheelResult+1);
592    }
593        
594     modifier onlyDeveloper() 
595     {
596        if (msg.sender!=developer) throw;
597        _;
598     }
599 
600 
601     function getCoeff(uint16 n) external constant returns (uint256) 
602     {
603         return winMatrix[n];
604     }
605 
606    function() 
607    {
608       throw;
609    }
610    
611 
612 }