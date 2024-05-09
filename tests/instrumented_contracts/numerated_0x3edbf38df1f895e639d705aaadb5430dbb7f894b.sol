1 pragma solidity 		^0.4.25		;	// 0.4.25+commit.59dbf8f1.Emscripten.clang					
2 										
3 contract		FORM_2019_01001		{						
4 										
5 	address	owner	;							
6 										
7 	function	NewForm		()	public	{				
8 		owner	= msg.sender;							
9 	}									
10 										
11 	modifier	onlyOwner	() {							
12 		require(msg.sender ==		owner	);					
13 		_;								
14 	}									
15 										
16 //					//					
17 //					//					
18 //										
19 //										
20 //										
21 //										
22 //										
23 //										
24 //										
25 //										
26 //										
27 //										
28 //										
29 //										
30 //										
31 //										
32 //										
33 //										
34 //										
35 //										
36 //										
37 //										
38 //										
39 //										
40 //										
41 //										
42 //										
43 //										
44 //										
45 //										
46 //										
47 //										
48 //										
49 //										
50 //										
51 //										
52 //										
53 //										
54 //										
55 //										
56 //										
57 //										
58 //										
59 //										
60 //										
61 //										
62 //										
63 //										
64 //										
65 //										
66 //										
67 //										
68 										
69 										
70 										
71 										
72 										
73 										
74 										
75 										
76 // 1 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
77 										
78 										
79 	string	inData_1	=	"e4ddBDcACBf2AB84eAf0AffeD2eD1E"						;
80 										
81 	function	setData_1	(	string	newData_1	)	public	onlyOwner	{	
82 		inData_1	=	newData_1	;					
83 	}									
84 										
85 	function	getData_1	()	public	constant	returns	(	string	)	{
86 		return	inData_1	;						
87 	}									
88 										
89 										
90 										
91 // 2 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
92 										
93 										
94 	string	inData_2	=	"356.34299069027500000000"						;
95 										
96 	function	setData_2	(	string	newData_2	)	public	onlyOwner	{	
97 		inData_2	=	newData_2	;					
98 	}									
99 										
100 	function	getData_2	()	public	constant	returns	(	string	)	{
101 		return	inData_2	;						
102 	}									
103 										
104 										
105 										
106 // 3 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
107 										
108 										
109 	string	inData_3	=	"10.000000000000000000"						;
110 										
111 	function	setData_3	(	string	newData_3	)	public	onlyOwner	{	
112 		inData_3	=	newData_3	;					
113 	}									
114 										
115 	function	getData_3	()	public	constant	returns	(	string	)	{
116 		return	inData_3	;						
117 	}									
118 										
119 										
120 										
121 // 4 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
122 										
123 										
124 	string	inData_4	=	"0x53da91ae3ffbcf997c1133d0d1b2"						;
125 										
126 	function	setData_4	(	string	newData_4	)	public	onlyOwner	{	
127 		inData_4	=	newData_4	;					
128 	}									
129 										
130 	function	getData_4	()	public	constant	returns	(	string	)	{
131 		return	inData_4	;						
132 	}									
133 										
134 										
135 										
136 // 5 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
137 										
138 										
139 	string	inData_5	=	"e260825e07cd22a87887850eedc5c9"						;
140 										
141 	function	setData_5	(	string	newData_5	)	public	onlyOwner	{	
142 		inData_5	=	newData_5	;					
143 	}									
144 										
145 	function	getData_5	()	public	constant	returns	(	string	)	{
146 		return	inData_5	;						
147 	}									
148 										
149 										
150 										
151 										
152 // 6 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
153 										
154 										
155 	string	inData_6	=	"3cF0F4401BaAeADdbD9ceaebb4CAaD"						;
156 										
157 	function	setData_6	(	string	newData_6	)	public	onlyOwner	{	
158 		inData_6	=	newData_6	;					
159 	}									
160 										
161 	function	getData_6	()	public	constant	returns	(	string	)	{
162 		return	inData_6	;						
163 	}									
164 										
165 										
166 										
167 // 7 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
168 										
169 										
170 	string	inData_7	=	"137.02805781747700000000"						;
171 										
172 	function	setData_7	(	string	newData_7	)	public	onlyOwner	{	
173 		inData_7	=	newData_7	;					
174 	}									
175 										
176 	function	getData_7	()	public	constant	returns	(	string	)	{
177 		return	inData_7	;						
178 	}									
179 										
180 										
181 										
182 // 8 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
183 										
184 										
185 	string	inData_8	=	"10.000000000000000000"						;
186 										
187 	function	setData_8	(	string	newData_8	)	public	onlyOwner	{	
188 		inData_8	=	newData_8	;					
189 	}									
190 										
191 	function	getData_8	()	public	constant	returns	(	string	)	{
192 		return	inData_8	;						
193 	}									
194 										
195 										
196 										
197 // 9 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
198 										
199 										
200 	string	inData_9	=	"0x53da91ae3ffbcf997c1133d0d1b2"						;
201 										
202 	function	setData_9	(	string	newData_9	)	public	onlyOwner	{	
203 		inData_9	=	newData_9	;					
204 	}									
205 										
206 	function	getData_9	()	public	constant	returns	(	string	)	{
207 		return	inData_9	;						
208 	}									
209 										
210 										
211 										
212 // 10 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
213 										
214 										
215 	string	inData_10	=	"e260825e07cd22a87887850eedc5c9"						;
216 										
217 	function	setData_10	(	string	newData_10	)	public	onlyOwner	{	
218 		inData_10	=	newData_10	;					
219 	}									
220 										
221 	function	getData_10	()	public	constant	returns	(	string	)	{
222 		return	inData_10	;						
223 	}									
224 										
225 										
226 										
227 										
228 // 11 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
229 										
230 										
231 	string	inData_11	=	"CF07A9f6Eb19891cdbB69Fcd7bF1aB"						;
232 										
233 	function	setData_11	(	string	newData_11	)	public	onlyOwner	{	
234 		inData_11	=	newData_11	;					
235 	}									
236 										
237 	function	getData_11	()	public	constant	returns	(	string	)	{
238 		return	inData_11	;						
239 	}									
240 										
241 										
242 										
243 // 12 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
244 										
245 										
246 	string	inData_12	=	"34.92521276174280000000"						;
247 										
248 	function	setData_12	(	string	newData_12	)	public	onlyOwner	{	
249 		inData_12	=	newData_12	;					
250 	}									
251 										
252 	function	getData_12	()	public	constant	returns	(	string	)	{
253 		return	inData_12	;						
254 	}									
255 										
256 										
257 										
258 // 13 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
259 										
260 										
261 	string	inData_13	=	"10.000000000000000000"						;
262 										
263 	function	setData_13	(	string	newData_13	)	public	onlyOwner	{	
264 		inData_13	=	newData_13	;					
265 	}									
266 										
267 	function	getData_13	()	public	constant	returns	(	string	)	{
268 		return	inData_13	;						
269 	}									
270 										
271 										
272 										
273 // 14 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
274 										
275 										
276 	string	inData_14	=	"0x53da91ae3ffbcf997c1133d0d1b2"						;
277 										
278 	function	setData_14	(	string	newData_14	)	public	onlyOwner	{	
279 		inData_14	=	newData_14	;					
280 	}									
281 										
282 	function	getData_14	()	public	constant	returns	(	string	)	{
283 		return	inData_14	;						
284 	}									
285 										
286 										
287 										
288 // 15 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
289 										
290 										
291 	string	inData_15	=	"e260825e07cd22a87887850eedc5c9"						;
292 										
293 	function	setData_15	(	string	newData_15	)	public	onlyOwner	{	
294 		inData_15	=	newData_15	;					
295 	}									
296 										
297 	function	getData_15	()	public	constant	returns	(	string	)	{
298 		return	inData_15	;						
299 	}									
300 										
301 										
302 										
303 										
304 // 16 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
305 										
306 										
307 	string	inData_16	=	"0xE38C52BB6Ecdc5CcfBcacf8efbCE"						;
308 										
309 	function	setData_16	(	string	newData_16	)	public	onlyOwner	{	
310 		inData_16	=	newData_16	;					
311 	}									
312 										
313 	function	getData_16	()	public	constant	returns	(	string	)	{
314 		return	inData_16	;						
315 	}									
316 										
317 										
318 										
319 // 17 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
320 										
321 										
322 	string	inData_17	=	"0.649727402479367"						;
323 										
324 	function	setData_17	(	string	newData_17	)	public	onlyOwner	{	
325 		inData_17	=	newData_17	;					
326 	}									
327 										
328 	function	getData_17	()	public	constant	returns	(	string	)	{
329 		return	inData_17	;						
330 	}									
331 										
332 										
333 										
334 // 18 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
335 										
336 										
337 	string	inData_18	=	"10.000000000000000000"						;
338 										
339 	function	setData_18	(	string	newData_18	)	public	onlyOwner	{	
340 		inData_18	=	newData_18	;					
341 	}									
342 										
343 	function	getData_18	()	public	constant	returns	(	string	)	{
344 		return	inData_18	;						
345 	}									
346 										
347 										
348 										
349 // 19 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
350 										
351 										
352 	string	inData_19	=	"0x53da91ae3ffbcf997c1133d0d1b2"						;
353 										
354 	function	setData_19	(	string	newData_19	)	public	onlyOwner	{	
355 		inData_19	=	newData_19	;					
356 	}									
357 										
358 	function	getData_19	()	public	constant	returns	(	string	)	{
359 		return	inData_19	;						
360 	}									
361 										
362 										
363 										
364 // 20 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
365 										
366 										
367 	string	inData_20	=	"e260825e07cd22a87887850eedc5c9"						;
368 										
369 	function	setData_20	(	string	newData_20	)	public	onlyOwner	{	
370 		inData_20	=	newData_20	;					
371 	}									
372 										
373 	function	getData_20	()	public	constant	returns	(	string	)	{
374 		return	inData_20	;						
375 	}									
376 										
377 										
378 										
379 										
380 // 21 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
381 										
382 										
383 	string	inData_21	=	"F1A4b85faC2c46Ca64DC58bE33d7E3"						;
384 										
385 	function	setData_21	(	string	newData_21	)	public	onlyOwner	{	
386 		inData_21	=	newData_21	;					
387 	}									
388 										
389 	function	getData_21	()	public	constant	returns	(	string	)	{
390 		return	inData_21	;						
391 	}									
392 										
393 										
394 										
395 // 22 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
396 										
397 										
398 	string	inData_22	=	"28.64382142967830000000"						;
399 										
400 	function	setData_22	(	string	newData_22	)	public	onlyOwner	{	
401 		inData_22	=	newData_22	;					
402 	}									
403 										
404 	function	getData_22	()	public	constant	returns	(	string	)	{
405 		return	inData_22	;						
406 	}									
407 										
408 										
409 										
410 // 23 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
411 										
412 										
413 	string	inData_23	=	"100.000000000000000000"						;
414 										
415 	function	setData_23	(	string	newData_23	)	public	onlyOwner	{	
416 		inData_23	=	newData_23	;					
417 	}									
418 										
419 	function	getData_23	()	public	constant	returns	(	string	)	{
420 		return	inData_23	;						
421 	}									
422 										
423 										
424 										
425 // 24 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
426 										
427 										
428 	string	inData_24	=	"0x2d0b1c47e02b21d068b783858d29"						;
429 										
430 	function	setData_24	(	string	newData_24	)	public	onlyOwner	{	
431 		inData_24	=	newData_24	;					
432 	}									
433 										
434 	function	getData_24	()	public	constant	returns	(	string	)	{
435 		return	inData_24	;						
436 	}									
437 										
438 										
439 										
440 // 25 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
441 										
442 										
443 	string	inData_25	=	"8c152436b26727d6268ee35f785cec"						;
444 										
445 	function	setData_25	(	string	newData_25	)	public	onlyOwner	{	
446 		inData_25	=	newData_25	;					
447 	}									
448 										
449 	function	getData_25	()	public	constant	returns	(	string	)	{
450 		return	inData_25	;						
451 	}									
452 										
453 										
454 										
455 										
456 // 26 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
457 										
458 										
459 	string	inData_26	=	"AdABCE55faC9BfEfCCD3B593dC76cA"						;
460 										
461 	function	setData_26	(	string	newData_26	)	public	onlyOwner	{	
462 		inData_26	=	newData_26	;					
463 	}									
464 										
465 	function	getData_26	()	public	constant	returns	(	string	)	{
466 		return	inData_26	;						
467 	}									
468 										
469 										
470 										
471 // 27 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
472 										
473 										
474 	string	inData_27	=	"8.46253364746049000000"						;
475 										
476 	function	setData_27	(	string	newData_27	)	public	onlyOwner	{	
477 		inData_27	=	newData_27	;					
478 	}									
479 										
480 	function	getData_27	()	public	constant	returns	(	string	)	{
481 		return	inData_27	;						
482 	}									
483 										
484 										
485 										
486 // 28 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
487 										
488 										
489 	string	inData_28	=	"100.000000000000000000"						;
490 										
491 	function	setData_28	(	string	newData_28	)	public	onlyOwner	{	
492 		inData_28	=	newData_28	;					
493 	}									
494 										
495 	function	getData_28	()	public	constant	returns	(	string	)	{
496 		return	inData_28	;						
497 	}									
498 										
499 										
500 										
501 // 29 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
502 										
503 										
504 	string	inData_29	=	"0x2d0b1c47e02b21d068b783858d29"						;
505 										
506 	function	setData_29	(	string	newData_29	)	public	onlyOwner	{	
507 		inData_29	=	newData_29	;					
508 	}									
509 										
510 	function	getData_29	()	public	constant	returns	(	string	)	{
511 		return	inData_29	;						
512 	}									
513 										
514 										
515 										
516 // 30 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
517 										
518 										
519 	string	inData_30	=	"8c152436b26727d6268ee35f785cec"						;
520 										
521 	function	setData_30	(	string	newData_30	)	public	onlyOwner	{	
522 		inData_30	=	newData_30	;					
523 	}									
524 										
525 	function	getData_30	()	public	constant	returns	(	string	)	{
526 		return	inData_30	;						
527 	}									
528 										
529 										
530 										
531 										
532 // 31 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
533 										
534 										
535 	string	inData_31	=	"2EbDdA77bC3ad8731F89F07EBAc7bD"						;
536 										
537 	function	setData_31	(	string	newData_31	)	public	onlyOwner	{	
538 		inData_31	=	newData_31	;					
539 	}									
540 										
541 	function	getData_31	()	public	constant	returns	(	string	)	{
542 		return	inData_31	;						
543 	}									
544 										
545 										
546 										
547 // 32 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
548 										
549 										
550 	string	inData_32	=	"1.95755087349616000000"						;
551 										
552 	function	setData_32	(	string	newData_32	)	public	onlyOwner	{	
553 		inData_32	=	newData_32	;					
554 	}									
555 										
556 	function	getData_32	()	public	constant	returns	(	string	)	{
557 		return	inData_32	;						
558 	}									
559 										
560 										
561 										
562 // 33 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
563 										
564 										
565 	string	inData_33	=	"100.000000000000000000"						;
566 										
567 	function	setData_33	(	string	newData_33	)	public	onlyOwner	{	
568 		inData_33	=	newData_33	;					
569 	}									
570 										
571 	function	getData_33	()	public	constant	returns	(	string	)	{
572 		return	inData_33	;						
573 	}									
574 										
575 										
576 										
577 // 34 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
578 										
579 										
580 	string	inData_34	=	"0x2d0b1c47e02b21d068b783858d29"						;
581 										
582 	function	setData_34	(	string	newData_34	)	public	onlyOwner	{	
583 		inData_34	=	newData_34	;					
584 	}									
585 										
586 	function	getData_34	()	public	constant	returns	(	string	)	{
587 		return	inData_34	;						
588 	}									
589 										
590 										
591 										
592 // 35 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
593 										
594 										
595 	string	inData_35	=	"8c152436b26727d6268ee35f785cec"						;
596 										
597 	function	setData_35	(	string	newData_35	)	public	onlyOwner	{	
598 		inData_35	=	newData_35	;					
599 	}									
600 										
601 	function	getData_35	()	public	constant	returns	(	string	)	{
602 		return	inData_35	;						
603 	}									
604 										
605 										
606 										
607 										
608 // 36 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
609 										
610 										
611 	string	inData_36	=	"0xa2baF1B14DFFeDdbD37E3bEDc45c"						;
612 										
613 	function	setData_36	(	string	newData_36	)	public	onlyOwner	{	
614 		inData_36	=	newData_36	;					
615 	}									
616 										
617 	function	getData_36	()	public	constant	returns	(	string	)	{
618 		return	inData_36	;						
619 	}									
620 										
621 										
622 										
623 // 37 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
624 										
625 										
626 	string	inData_37	=	"0.380368029746767"						;
627 										
628 	function	setData_37	(	string	newData_37	)	public	onlyOwner	{	
629 		inData_37	=	newData_37	;					
630 	}									
631 										
632 	function	getData_37	()	public	constant	returns	(	string	)	{
633 		return	inData_37	;						
634 	}									
635 										
636 										
637 										
638 // 38 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
639 										
640 										
641 	string	inData_38	=	"100.000000000000000000"						;
642 										
643 	function	setData_38	(	string	newData_38	)	public	onlyOwner	{	
644 		inData_38	=	newData_38	;					
645 	}									
646 										
647 	function	getData_38	()	public	constant	returns	(	string	)	{
648 		return	inData_38	;						
649 	}									
650 										
651 										
652 										
653 // 39 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
654 										
655 										
656 	string	inData_39	=	"0x2d0b1c47e02b21d068b783858d29"						;
657 										
658 	function	setData_39	(	string	newData_39	)	public	onlyOwner	{	
659 		inData_39	=	newData_39	;					
660 	}									
661 										
662 	function	getData_39	()	public	constant	returns	(	string	)	{
663 		return	inData_39	;						
664 	}									
665 										
666 										
667 										
668 // 40 IN DATA / SET DATA / GET DATA / string / PUBLIC / ONLY OWNER / CONSTANT										
669 										
670 										
671 	string	inData_40	=	"8c152436b26727d6268ee35f785cec"						;
672 										
673 	function	setData_40	(	string	newData_40	)	public	onlyOwner	{	
674 		inData_40	=	newData_40	;					
675 	}									
676 										
677 	function	getData_40	()	public	constant	returns	(	string	)	{
678 		return	inData_40	;						
679 	}									
680 										
681 										
682 										
683 										
684 										
685 										
686 //										
687 //										
688 //										
689 //										
690 //										
691 //										
692 //										
693 //										
694 //										
695 //										
696 //										
697 //										
698 //										
699 //										
700 //										
701 //										
702 //										
703 //										
704 //										
705 //										
706 //										
707 //										
708 //										
709 //										
710 //										
711 //										
712 //										
713 //										
714 //										
715 //										
716 //										
717 //										
718 //										
719 //										
720 //										
721 //										
722 //										
723 //										
724 //										
725 //										
726 //										
727 //										
728 //										
729 //										
730 //										
731 //										
732 //										
733 //										
734 //										
735 //										
736 //										
737 //										
738 //										
739 //										
740 //										
741 //										
742 //										
743 //										
744 //										
745 //										
746 //										
747 //										
748 //										
749 //										
750 //										
751 //										
752 //										
753 //										
754 //										
755 //										
756 //										
757 //										
758 //										
759 //										
760 //										
761 //										
762 //										
763 //										
764 //										
765 //										
766 //										
767 //										
768 //										
769 //										
770 //										
771 //										
772 //										
773 //										
774 //										
775 //										
776 //										
777 //										
778 //										
779 //										
780 //										
781 //										
782 //										
783 //										
784 //										
785 //										
786 //										
787 //										
788 //										
789 //										
790 //										
791 //										
792 //										
793 //										
794 //										
795 //										
796 //										
797 //										
798 //										
799 //										
800 //										
801 //										
802 //										
803 //										
804 //										
805 //										
806 //										
807 //										
808 //										
809 //										
810 //										
811 //										
812 //										
813 //										
814 //										
815 //										
816 //										
817 //										
818 //										
819 //										
820 //										
821 //										
822 //										
823 //										
824 //										
825 //										
826 //										
827 //										
828 //										
829 //										
830 //										
831 //										
832 //										
833 //										
834 //										
835 //										
836 //										
837 //										
838 //										
839 //										
840 //										
841 //										
842 //										
843 //										
844 //										
845 //										
846 //										
847 //										
848 //										
849 //										
850 //										
851 //										
852 //										
853 //										
854 //										
855 //										
856 //										
857 //										
858 //										
859 //										
860 //										
861 //										
862 //										
863 //										
864 //										
865 //										
866 //										
867 //										
868 //										
869 //										
870 //										
871 //										
872 //										
873 //										
874 //										
875 //										
876 //										
877 //										
878 //										
879 //										
880 //										
881 //										
882 //										
883 //										
884 //										
885 //										
886 //										
887 //										
888 //										
889 //										
890 //										
891 //										
892 //										
893 //										
894 //										
895 //										
896 //										
897 //										
898 //										
899 //										
900 //										
901 //										
902 //										
903 //										
904 //										
905 //										
906 //										
907 //										
908 //										
909 //										
910 //										
911 //										
912 //										
913 //										
914 //										
915 //										
916 //										
917 //										
918 //										
919 //										
920 //										
921 //										
922 //										
923 //										
924 //										
925 //										
926 //										
927 //										
928 //										
929 //										
930 //										
931 //										
932 //										
933 //										
934 //										
935 //										
936 //										
937 //										
938 //										
939 //										
940 //										
941 //										
942 //										
943 //										
944 //										
945 //										
946 //										
947 //										
948 //										
949 //										
950 //										
951 //										
952 //										
953 //										
954 //										
955 //										
956 //										
957 //										
958 //										
959 //										
960 //										
961 //										
962 //										
963 //										
964 //										
965 //										
966 //										
967 //										
968 //										
969 //										
970 //										
971 //										
972 //										
973 //										
974 //										
975 //										
976 //										
977 //										
978 //										
979 //										
980 //										
981 //										
982 //										
983 //										
984 //										
985 //										
986 //										
987 //										
988 //										
989 //										
990 //										
991 //										
992 //										
993 //										
994 //										
995 //										
996 //										
997 //										
998 //										
999 //										
1000 //										
1001 //										
1002 //										
1003 //										
1004 //										
1005 //										
1006 //										
1007 //										
1008 //										
1009 //										
1010 //										
1011 //										
1012 //										
1013 //										
1014 //										
1015 //										
1016 //										
1017 //										
1018 //										
1019 //										
1020 //										
1021 //										
1022 //										
1023 //										
1024 //										
1025 //										
1026 //										
1027 //										
1028 //										
1029 //										
1030 //										
1031 //										
1032 //										
1033 //										
1034 //										
1035 //										
1036 //										
1037 //										
1038 //										
1039 //										
1040 //										
1041 //										
1042 //										
1043 //										
1044 //										
1045 //										
1046 //										
1047 //										
1048 //										
1049 //										
1050 //										
1051 //										
1052 //										
1053 //										
1054 //										
1055 //										
1056 //										
1057 //										
1058 //										
1059 //										
1060 //										
1061 //										
1062 //										
1063 //										
1064 //										
1065 //										
1066 //										
1067 //										
1068 //										
1069 //										
1070 //										
1071 //										
1072 //										
1073 //										
1074 //										
1075 //										
1076 //										
1077 //										
1078 //										
1079 //										
1080 //										
1081 //										
1082 //										
1083 //										
1084 //										
1085 //										
1086 //										
1087 //										
1088 //										
1089 //										
1090 //										
1091 //										
1092 //										
1093 //										
1094 //										
1095 //										
1096 //										
1097 //										
1098 //										
1099 //										
1100 //										
1101 //										
1102 //										
1103 //										
1104 //										
1105 //										
1106 //										
1107 //										
1108 //										
1109 //										
1110 //										
1111 //										
1112 //										
1113 //										
1114 //										
1115 //										
1116 //										
1117 //										
1118 //										
1119 //										
1120 //										
1121 //										
1122 //										
1123 //										
1124 //										
1125 //										
1126 //										
1127 //										
1128 //										
1129 //										
1130 //										
1131 //										
1132 //										
1133 //										
1134 //										
1135 //										
1136 //										
1137 //										
1138 //										
1139 //										
1140 //										
1141 //										
1142 //										
1143 //										
1144 //										
1145 //										
1146 //										
1147 //										
1148 //										
1149 //										
1150 //										
1151 //										
1152 //										
1153 //										
1154 //										
1155 //										
1156 //										
1157 //										
1158 //										
1159 //										
1160 //										
1161 //										
1162 //										
1163 //										
1164 //										
1165 //										
1166 //										
1167 //										
1168 //										
1169 //										
1170 //										
1171 //										
1172 //										
1173 //										
1174 //										
1175 //										
1176 //										
1177 //										
1178 //										
1179 //										
1180 //										
1181 //										
1182 //										
1183 //										
1184 //										
1185 //										
1186 //										
1187 //										
1188 //										
1189 //										
1190 //										
1191 //										
1192 //										
1193 //										
1194 //										
1195 //										
1196 //										
1197 //										
1198 //										
1199 //										
1200 //										
1201 //										
1202 //										
1203 //										
1204 //										
1205 //										
1206 //										
1207 //										
1208 //										
1209 //										
1210 //										
1211 //										
1212 //										
1213 //										
1214 //										
1215 //										
1216 //										
1217 //										
1218 //										
1219 //										
1220 //										
1221 //										
1222 //										
1223 //										
1224 //										
1225 //										
1226 //										
1227 //										
1228 //										
1229 //										
1230 //										
1231 //										
1232 //										
1233 //										
1234 //										
1235 //										
1236 //										
1237 //										
1238 //										
1239 //										
1240 //										
1241 //										
1242 //										
1243 //										
1244 //										
1245 //										
1246 //										
1247 //										
1248 //										
1249 //										
1250 //										
1251 //										
1252 //										
1253 //										
1254 //										
1255 //										
1256 //										
1257 //										
1258 //										
1259 //										
1260 //										
1261 //										
1262 //										
1263 //										
1264 //										
1265 //										
1266 //										
1267 //										
1268 //										
1269 //										
1270 //										
1271 //										
1272 //										
1273 //										
1274 //										
1275 //										
1276 //										
1277 //										
1278 //										
1279 //										
1280 //										
1281 //										
1282 //										
1283 //										
1284 //										
1285 //										
1286 //										
1287 //										
1288 //										
1289 //										
1290 //										
1291 //										
1292 //										
1293 //										
1294 //										
1295 //										
1296 //										
1297 //										
1298 //										
1299 //										
1300 //										
1301 //										
1302 //										
1303 //										
1304 //										
1305 //										
1306 //										
1307 //										
1308 //										
1309 //										
1310 //										
1311 //										
1312 //										
1313 //										
1314 //										
1315 //										
1316 //										
1317 //										
1318 //										
1319 //										
1320 //										
1321 //										
1322 //										
1323 //										
1324 //										
1325 //										
1326 //										
1327 //										
1328 //										
1329 //										
1330 //										
1331 //										
1332 //										
1333 //										
1334 //										
1335 //										
1336 //										
1337 //										
1338 //										
1339 //										
1340 //										
1341 //										
1342 //										
1343 //										
1344 //										
1345 //										
1346 //										
1347 //										
1348 //										
1349 //										
1350 //										
1351 //										
1352 //										
1353 //										
1354 //										
1355 //										
1356 //										
1357 //										
1358 //										
1359 //										
1360 //										
1361 //										
1362 //										
1363 //										
1364 //										
1365 //										
1366 //										
1367 //										
1368 //										
1369 //										
1370 //										
1371 //										
1372 //										
1373 //										
1374 //										
1375 //										
1376 //										
1377 //										
1378 //										
1379 //										
1380 //										
1381 //										
1382 //										
1383 //										
1384 //										
1385 //										
1386 //										
1387 //										
1388 //										
1389 //										
1390 //										
1391 //										
1392 //										
1393 //										
1394 //										
1395 //										
1396 //										
1397 //										
1398 //										
1399 //										
1400 //										
1401 //										
1402 //										
1403 //										
1404 //										
1405 //										
1406 //										
1407 //										
1408 //										
1409 //										
1410 //										
1411 //										
1412 //										
1413 //										
1414 //										
1415 //										
1416 //										
1417 //										
1418 //										
1419 //										
1420 //										
1421 //										
1422 //										
1423 //										
1424 //										
1425 //										
1426 //										
1427 //										
1428 //										
1429 //										
1430 //										
1431 //										
1432 //										
1433 //										
1434 //										
1435 //										
1436 //										
1437 //										
1438 //										
1439 //										
1440 //										
1441 //										
1442 //										
1443 //										
1444 //										
1445 //										
1446 //										
1447 //										
1448 //										
1449 //										
1450 //										
1451 //										
1452 //										
1453 //										
1454 //										
1455 //										
1456 //										
1457 //										
1458 //										
1459 //										
1460 //										
1461 //										
1462 //										
1463 //										
1464 //										
1465 //										
1466 //										
1467 //										
1468 //										
1469 //										
1470 //										
1471 //										
1472 //										
1473 //										
1474 //										
1475 //										
1476 //										
1477 //										
1478 //										
1479 //										
1480 //										
1481 //										
1482 //										
1483 //										
1484 //										
1485 //										
1486 //										
1487 //										
1488 //										
1489 //										
1490 //										
1491 //										
1492 //										
1493 //										
1494 //										
1495 //										
1496 //										
1497 //										
1498 //										
1499 //										
1500 //										
1501 //										
1502 //										
1503 //										
1504 //										
1505 //										
1506 //										
1507 //										
1508 //										
1509 //										
1510 //										
1511 //										
1512 //										
1513 //										
1514 //										
1515 //										
1516 //										
1517 //										
1518 //										
1519 //										
1520 //										
1521 //										
1522 //										
1523 //										
1524 //										
1525 //										
1526 //										
1527 //										
1528 //										
1529 //										
1530 //										
1531 //										
1532 //										
1533 //										
1534 //										
1535 //										
1536 //										
1537 //										
1538 //										
1539 //										
1540 //										
1541 //										
1542 //										
1543 //										
1544 //										
1545 //										
1546 //										
1547 //										
1548 //										
1549 //										
1550 //										
1551 //										
1552 //										
1553 //										
1554 //										
1555 //										
1556 //										
1557 //										
1558 //										
1559 //										
1560 //										
1561 //										
1562 //										
1563 //										
1564 //										
1565 //										
1566 //										
1567 //										
1568 //										
1569 //										
1570 //										
1571 //										
1572 //										
1573 //										
1574 //										
1575 //										
1576 //										
1577 //										
1578 //										
1579 //										
1580 //										
1581 //										
1582 //										
1583 //										
1584 //										
1585 //										
1586 //										
1587 //										
1588 //										
1589 //										
1590 //										
1591 //										
1592 //										
1593 //										
1594 //										
1595 //										
1596 //										
1597 //										
1598 //										
1599 //										
1600 //										
1601 //										
1602 //										
1603 //										
1604 //										
1605 //										
1606 //										
1607 //										
1608 //										
1609 //										
1610 //										
1611 //										
1612 //										
1613 //										
1614 //										
1615 //										
1616 //										
1617 //										
1618 //										
1619 //										
1620 //										
1621 //										
1622 //										
1623 //										
1624 //										
1625 //										
1626 //										
1627 //										
1628 //										
1629 //										
1630 //										
1631 //										
1632 //										
1633 //										
1634 //										
1635 //										
1636 //										
1637 //										
1638 //										
1639 //										
1640 //										
1641 //										
1642 //										
1643 //										
1644 //										
1645 //										
1646 //										
1647 //										
1648 //										
1649 //										
1650 //										
1651 //										
1652 //										
1653 //										
1654 //										
1655 //										
1656 //										
1657 //										
1658 //										
1659 //										
1660 //										
1661 //										
1662 //										
1663 //										
1664 //										
1665 //										
1666 //										
1667 //										
1668 //										
1669 //										
1670 //										
1671 //										
1672 //										
1673 //										
1674 //										
1675 //										
1676 //										
1677 //										
1678 //										
1679 //										
1680 //										
1681 //										
1682 //										
1683 //										
1684 //										
1685 //										
1686 //										
1687 //										
1688 //										
1689 //										
1690 //										
1691 //										
1692 //										
1693 //										
1694 //										
1695 //										
1696 //										
1697 //										
1698 //										
1699 //										
1700 //										
1701 //										
1702 //										
1703 //										
1704 //										
1705 //										
1706 //										
1707 //										
1708 //										
1709 //										
1710 //										
1711 //										
1712 //										
1713 //										
1714 //										
1715 //										
1716 //										
1717 //										
1718 //										
1719 //										
1720 //										
1721 //										
1722 //										
1723 //										
1724 //										
1725 //										
1726 //										
1727 //										
1728 //										
1729 //										
1730 //										
1731 //										
1732 //										
1733 //										
1734 //										
1735 //										
1736 //										
1737 //										
1738 //										
1739 //										
1740 //										
1741 //										
1742 //										
1743 //										
1744 //										
1745 //										
1746 //										
1747 //										
1748 //										
1749 //										
1750 //										
1751 //										
1752 //										
1753 //										
1754 //										
1755 //										
1756 //										
1757 //										
1758 //										
1759 //										
1760 //										
1761 //										
1762 //										
1763 //										
1764 //										
1765 //										
1766 //										
1767 //										
1768 //										
1769 //										
1770 //										
1771 //										
1772 //										
1773 //										
1774 //										
1775 //										
1776 //										
1777 //										
1778 //										
1779 //										
1780 //										
1781 //										
1782 //										
1783 //										
1784 //										
1785 //										
1786 //										
1787 //										
1788 //										
1789 //										
1790 //										
1791 //										
1792 //										
1793 //										
1794 //										
1795 //										
1796 //										
1797 //										
1798 //										
1799 //										
1800 //										
1801 //										
1802 //										
1803 //										
1804 //										
1805 //										
1806 //										
1807 //										
1808 //										
1809 //										
1810 //										
1811 //										
1812 //										
1813 //										
1814 //										
1815 //										
1816 //										
1817 //										
1818 //										
1819 //										
1820 //										
1821 //										
1822 //										
1823 //										
1824 //										
1825 //										
1826 //										
1827 //										
1828 //										
1829 //										
1830 //										
1831 //										
1832 //										
1833 //										
1834 //										
1835 //										
1836 //										
1837 //										
1838 //										
1839 //										
1840 //										
1841 //										
1842 //										
1843 //										
1844 //										
1845 //										
1846 //										
1847 //										
1848 //										
1849 //										
1850 //										
1851 //										
1852 //										
1853 //										
1854 //										
1855 //										
1856 //										
1857 //										
1858 //										
1859 //										
1860 //										
1861 //										
1862 //										
1863 //										
1864 //										
1865 //										
1866 //										
1867 //										
1868 //										
1869 //										
1870 //										
1871 //										
1872 //										
1873 //										
1874 //										
1875 //										
1876 //										
1877 //										
1878 //										
1879 //										
1880 //										
1881 //										
1882 //										
1883 //										
1884 //										
1885 //										
1886 //										
1887 //										
1888 //										
1889 //										
1890 //										
1891 //										
1892 //										
1893 //										
1894 //										
1895 //										
1896 //										
1897 //										
1898 //										
1899 //										
1900 //										
1901 //										
1902 //										
1903 //										
1904 //										
1905 //										
1906 //										
1907 //										
1908 //										
1909 //										
1910 //										
1911 //										
1912 //										
1913 //										
1914 //										
1915 //										
1916 //										
1917 //										
1918 //										
1919 //										
1920 //										
1921 //										
1922 //										
1923 //										
1924 //										
1925 //										
1926 //										
1927 //										
1928 //										
1929 //										
1930 //										
1931 //										
1932 //										
1933 //										
1934 //										
1935 //										
1936 //										
1937 //										
1938 //										
1939 //										
1940 //										
1941 //										
1942 //										
1943 //										
1944 //										
1945 //										
1946 //										
1947 //										
1948 //										
1949 //										
1950 //										
1951 //										
1952 //										
1953 //										
1954 //										
1955 //										
1956 //										
1957 //										
1958 //										
1959 //										
1960 //										
1961 //										
1962 //										
1963 //										
1964 //										
1965 //										
1966 //										
1967 //										
1968 //										
1969 //										
1970 //										
1971 //										
1972 //										
1973 //										
1974 //										
1975 //										
1976 //										
1977 //										
1978 //										
1979 //										
1980 //										
1981 //										
1982 //										
1983 //										
1984 //										
1985 //										
1986 //										
1987 //										
1988 //										
1989 //										
1990 //										
1991 //										
1992 //										
1993 //										
1994 //										
1995 //										
1996 //										
1997 //										
1998 //										
1999 //										
2000 //										
2001 //										
2002 //										
2003 //										
2004 //										
2005 //										
2006 //										
2007 //										
2008 //										
2009 //										
2010 //										
2011 //										
2012 //										
2013 //										
2014 //										
2015 //										
2016 //										
2017 //										
2018 //										
2019 //										
2020 //										
2021 //										
2022 //										
2023 //										
2024 //										
2025 //										
2026 //										
2027 //										
2028 //										
2029 //										
2030 //										
2031 //										
2032 //										
2033 //										
2034 //										
2035 //										
2036 //										
2037 //										
2038 //										
2039 //										
2040 //										
2041 //										
2042 //										
2043 //										
2044 //										
2045 //										
2046 //										
2047 //										
2048 //										
2049 //										
2050 //										
2051 //										
2052 //										
2053 //										
2054 //										
2055 //										
2056 //										
2057 //										
2058 //										
2059 //										
2060 //										
2061 //										
2062 //										
2063 //										
2064 //										
2065 //										
2066 //										
2067 //										
2068 //										
2069 //										
2070 //										
2071 //										
2072 //										
2073 //										
2074 //										
2075 //										
2076 //										
2077 //										
2078 //										
2079 //										
2080 //										
2081 //										
2082 //										
2083 //										
2084 //										
2085 //										
2086 //										
2087 //										
2088 //										
2089 //										
2090 //										
2091 //										
2092 //										
2093 //										
2094 //										
2095 //										
2096 //										
2097 //										
2098 										
2099 }